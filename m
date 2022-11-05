Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5781061DAC3
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 15:13:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbiKEONn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Nov 2022 10:13:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiKEONm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Nov 2022 10:13:42 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D812726576;
        Sat,  5 Nov 2022 07:13:39 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id b1-20020a17090a7ac100b00213fde52d49so6788562pjl.3;
        Sat, 05 Nov 2022 07:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mc5/Wq/QLHmzgpVMSRqnzX2BpVx6vMxkIU8iSMcAVMQ=;
        b=b5u1gfszkwLvwol4kU5LuW0PdIiztNP0GUP5Fz+70LSaU+STOmBGO/4AIlOGcx3NYh
         oQgtrT0fgIAt1LUcH66IZSbZQgqGQa6PISTz9+m581U8U+dYzakjT3dzQAEom9XpVuUo
         TfcWJVgHKJ7l5f7MSiwfYfN4MWvU3CgZiPSmVsji8gRx7dnIwjBRF05B5UYpw683L/HJ
         1v80hXYajZ9nbAyXFRkM4+5zi8I1Jv5rIRumXUkBm8lQ7NfKN9bHXcktEWjeRAt+kZP7
         v+ZVI/Of2zbGCD2l/BKRgFpc8S4wjak5Bd83MoUKkOKqVmHa55E9StG0XjFK48kzg5qD
         MRBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mc5/Wq/QLHmzgpVMSRqnzX2BpVx6vMxkIU8iSMcAVMQ=;
        b=BWpb6cLjeAxJYuXR3JhFlLeit1zQd5tb2kW/D2YBf/43YjmCBDU9Tv29uNnSvf15w9
         P72qRamAQHwE2ocMa4ncMuLMdyZXt9quNTUSXjH79R4AeeMP+r6nHcV3GxTY2/6I/QZc
         InBXAeXSzjI1ZnVAjlivJIGRSVOFQ1j8sEN0wrpNv/2x2AhUTH/TjkTosBw7Em2GOoho
         0lLnnJVNgYU/90fL9vY5MdzEMJVBq5g5LsFkRIpLa5zrZii7deAD6srDlcXzeRsAU3Dt
         932uXbgt38nDQfBGSxBaiJu7eHA6+ruQhInCUkftb8n/6mYbmXQ8zRVY8W+P08K8Q8ZG
         l3/Q==
X-Gm-Message-State: ACrzQf1AiF5pcwI3WvTKIKG/HrWYl+QQVXU57FgGJKnTwmwE7zl4qm6o
        omsJqcuoDFfuEOLq01whMgA=
X-Google-Smtp-Source: AMsMyM5h8sJQF+cdGme7Ao2S3FTe5aQUEts242DlrG+c66cbxzCzm5nNVspr+cBlCV9bUu9MyINLUA==
X-Received: by 2002:a17:903:50e:b0:182:631b:df6f with SMTP id jn14-20020a170903050e00b00182631bdf6fmr40747468plb.66.1667657617868;
        Sat, 05 Nov 2022 07:13:37 -0700 (PDT)
Received: from localhost ([223.104.41.238])
        by smtp.gmail.com with ESMTPSA id v21-20020a631515000000b004405c6eb962sm1359798pgl.4.2022.11.05.07.13.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Nov 2022 07:13:37 -0700 (PDT)
From:   Hawkins Jiawei <yin31149@gmail.com>
To:     kuba@kernel.org
Cc:     18801353760@163.com, davem@davemloft.net, edumazet@google.com,
        jhs@mojatatu.com, jiri@resnulli.us, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzbot+232ebdbd36706c965ebf@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com,
        yin31149@gmail.com
Subject: Re: [PATCH] net: sched: fix memory leak in tcindex_set_parms
Date:   Sat,  5 Nov 2022 22:11:56 +0800
Message-Id: <20221105141156.28093-1-yin31149@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221103192308.581a9124@kernel.org>
References: <20221103192308.581a9124@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Nov 2022 at 10:23, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri,  4 Nov 2022 00:07:00 +0800 Hawkins Jiawei wrote:
> > > Can't you localize all the changes to this if block?
> > >
> > > Maybe add a function called tcindex_filter_result_reinit()
> > > which will act more appropriately? 
> >
> > I think we shouldn't put the tcf_exts_destroy(&old_e)
> > into this if block, or other RCU readers may derefer the
> > freed memory (Please correct me If I am wrong).
> >
> > So I put the tcf_exts_destroy(&old_e) near the tcindex
> > destroy work, after the RCU updateing.
>
> I'm not sure what this code is trying to do, to be honest.
> Your concern that there may be a concurrent reader is valid,
> but then again tcindex_filter_result_init() just wipes the
> entire structure with a memset() so concurrent readers are
> already likely broken?
>
> Maybe tcindex_filter_result_init() dates back to times when
> exts were a list (see commit 22dc13c837c) and calling
> tcf_exts_init() wasn't that different than cleaning it up?
> In other words this code is trying to destroy old_r, not
> reinitialize it?
Yes, I also think this code is just trying to destroy the old_r.

In my opinion, the context here is a bit like, this filter's some
properties has been changed, so kernel should drop its old filter
result and update a new one.

Before kernel finishes RCU updating, concurrent readers should
see an empty result(or a valid old result), cleaned by
tcindex_filter_result_init().

This won't trigger the memory leak before commit b9a24bb76bf6
("net_sched: properly handle failure case of tcf_exts_init()"),
I think. Because the new filter result still uses the old_r->exts.

Yet after this commit, kernel allocates the new struct tcf_exts for
new filter result in tcindex_alloc_perfect_hash(), which triggers
the memory leak if kernel cleans the old_r without destroying its
newly allocted struct tcf_exts.

As for the patch, I think we'd better free this struct tcf_exts
after RCU updating, to make sure that concurrent readers can only
see an empty result or a valid old result, before finishing updating
(Please correct me if I am wrong).
>
> > > 
> > > >               err = tcindex_filter_result_init(old_r, cp, net);
