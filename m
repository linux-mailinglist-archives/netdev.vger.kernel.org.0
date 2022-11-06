Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 122A861E510
	for <lists+netdev@lfdr.de>; Sun,  6 Nov 2022 18:49:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbiKFRtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 12:49:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbiKFRtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 12:49:19 -0500
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C144BD;
        Sun,  6 Nov 2022 09:49:18 -0800 (PST)
Received: by mail-qk1-x729.google.com with SMTP id x18so6056237qki.4;
        Sun, 06 Nov 2022 09:49:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yi6dfTij4IZpgiQaleZPgThvdhGcr1NeDjqN55rBrh4=;
        b=Fsxhnt+S8VHlLTegM+VbWSvq09DEYo/1dn8XqlDATd62IILtb9BeOVrfQ4Um30pzYe
         /kvthCsraw93ufy3qhyrQTCm7nt1DFxw3EqjGcDybumY17+Lqi8+xswHcS0IWQSE2s7w
         wbtzi6Kojv0EA1kWxtx3WxVSQ+pBYdpn3so516ju1qTj+96716ZuC7JXMw6Kh9CfP7G8
         xvlbg9OZzV2po/5am0vFNtJ3bX0yf+SqGAAf/K0MVW5gwKJuxQ+VZUvaSJImjTygIjpL
         KqHgqPQOkTbRql2T+Oxdlfw+QoPijTxX2TlIcBcFavJ3cWj1F4b9ylK8PtzBVSbdAR+v
         FopA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yi6dfTij4IZpgiQaleZPgThvdhGcr1NeDjqN55rBrh4=;
        b=VCTa1OdshmI3hwfCncFwhzwHXs5dVmHS73VG/JGReRzL8eFEh1AVoOo4xo/fRMR1f6
         qpf7VDKlCndfHbKPQlf0hYYNjQdfOKCEKuP9Ap+D1e5ZRXOBIFOGEvmDAKIU8/Gc4Tjh
         0jdsuDA/vPbFRUcEfijBpiNfbqIfc2N1nyn+vtiKqewbH3Z7LozOSgDDQ+Hw2ld7J6+p
         sO4MJ8D7xSnGWiEwp3at3hAE/6kHHfnyUAqc5ZkRzDgb0hQX3Q5V5C3+bt3DDJ9B25QF
         ePWy0z9HwAfsvZw0X6tv4Qo70dj/aQxftRvLkftqmmbGMb3tKD/SZ6RTawRU3PrNObna
         8NJg==
X-Gm-Message-State: ACrzQf17WCQBT9ttX8PYYG1td+dO8vQkZbwhBKtLVGqCYeXxTc0ZBBhn
        I9IFF7uh5rtJSEVl3etK3hGWgfhVAc8=
X-Google-Smtp-Source: AMsMyM6TmTSIMVvSx45NvR//r5wdwa+REIBJXFj0qjJ4IYioZz2X/7H9KrWMhxlA1NgdwT0wQccFZQ==
X-Received: by 2002:a05:620a:1492:b0:6fa:2e33:c003 with SMTP id w18-20020a05620a149200b006fa2e33c003mr27609215qkj.587.1667756957684;
        Sun, 06 Nov 2022 09:49:17 -0800 (PST)
Received: from localhost ([2600:1700:65a0:ab60:320c:c2b1:6732:81ff])
        by smtp.gmail.com with ESMTPSA id fg26-20020a05622a581a00b00399b73d06f0sm4307254qtb.38.2022.11.06.09.49.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Nov 2022 09:49:17 -0800 (PST)
Date:   Sun, 6 Nov 2022 09:49:16 -0800
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Hawkins Jiawei <yin31149@gmail.com>
Cc:     18801353760@163.com, davem@davemloft.net, edumazet@google.com,
        jhs@mojatatu.com, jiri@resnulli.us, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com,
        syzbot+232ebdbd36706c965ebf@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] net: sched: fix memory leak in tcindex_set_parms
Message-ID: <Y2fznI8JgkTBCVAA@pop-os.localdomain>
References: <Y2a+eXr20BcI3JDe@pop-os.localdomain>
 <20221106145530.3717-1-yin31149@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221106145530.3717-1-yin31149@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 06, 2022 at 10:55:31PM +0800, Hawkins Jiawei wrote:
> Hi Cong,
> 
> >
> >
> > diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
> > index 1c9eeb98d826..00a6c04a4b42 100644
> > --- a/net/sched/cls_tcindex.c
> > +++ b/net/sched/cls_tcindex.c
> > @@ -479,6 +479,7 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
> >         }
> >
> >         if (old_r && old_r != r) {
> > +               tcf_exts_destroy(&old_r->exts);
> >                 err = tcindex_filter_result_init(old_r, cp, net);
> >                 if (err < 0) {
> >                         kfree(f);
> 
> As for the position of the tcf_exts_destroy(), should we
> call it after the RCU updating, after
> `rcu_assign_pointer(tp->root, cp)` ?
> 
> Or the concurrent RCU readers may derefer this freed memory
> (Please correct me If I am wrong).

I don't think so, because we already have tcf_exts_change() in multiple
places within tcindex_set_parms(). Even if this is really a problem,
moving it after rcu_assign_pointer() does not help, you need to wait for
a grace period.

Thanks.
