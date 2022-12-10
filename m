Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 961C46490D3
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 22:32:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbiLJV31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 16:29:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiLJV30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 16:29:26 -0500
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C81C12604;
        Sat, 10 Dec 2022 13:29:25 -0800 (PST)
Received: by mail-qv1-xf36.google.com with SMTP id i12so5612237qvs.2;
        Sat, 10 Dec 2022 13:29:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JdVaQPw9JOmrwqEexVFYsBtyoX2EotPLNIQCPfCfLiw=;
        b=q0B0d4K0Ja6GXp6d04BSemduO2nWMgxDxI/JHSo5D1qXw2k0jnKSFuEZBxoFVOeRhQ
         qufGPl8Cn0IDuG8LzcVoTtPMcRTfmVDC73pRIAM/E42Q0j8c29GKf9XsHoCATbS+9JSg
         W7OZ9n/eYNDYUcoJnj+ILXod3PCbpHSL6+HCsmCE8DQ941N5jVLqqfpkQKislslEmgFC
         illdbWn551/AlYgKmECzBvuj35xWA0ksljm7Ho3kNLWP5GTTkME3zoHmKngtFjHYEsLH
         mxqF/Fqw7ONjsSl/8JzIoqYG6V2bq9wITuilQwJ4aockyaB5OygtEk6w8uOpd/vEgamN
         37KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JdVaQPw9JOmrwqEexVFYsBtyoX2EotPLNIQCPfCfLiw=;
        b=iLNIgB7lzJ+eZux2z8x6aoAaFMAkEac0YQHnai1AMXCLqAmJeQSZSsb/NaGsSmRe1V
         cemLvp2fzD1nLHi3R9lJxCAaVdVYE5OQZBdfLXzThYZYROYDSAPYWG2QDG0JMYj86BWW
         ev10Lt/vwDYp2MBzGnQKWjhwHsoZj8EuSEpwhyfLRgSFko/+x8eNM8yt7CmKv2RSx3wz
         fTy7Zw5Xs9X5o8U/16N+s2PTK/eoVbT6y92TBwaolp7EpafguUUOSOAODa6ZNrfn82pL
         mY6WaSKgvxKLXYYbkMtyaf6B5b5w5vYj4XRR+b8MIJR4MncQCrGPRFA/IW1LvyZ/a2rZ
         euTw==
X-Gm-Message-State: ANoB5pl37PpliUJss5wcB3zJLsp3Yb7aYqnrEcqXAA6WHKIo28OB+VHS
        PQagBiCdKsJCZ1sSLaGJIDQ=
X-Google-Smtp-Source: AA0mqf7a9Pvmy72ODR1r4WEB249eRbpr/11t/E1KInna+k14NinC6Dzm5Na2CS1qgEYWEmZyDpQkrw==
X-Received: by 2002:a05:6214:2402:b0:4b4:a3d5:8ce8 with SMTP id fv2-20020a056214240200b004b4a3d58ce8mr22886075qvb.10.1670707764118;
        Sat, 10 Dec 2022 13:29:24 -0800 (PST)
Received: from localhost ([2600:1700:65a0:ab60:f46d:8b68:f76c:52a5])
        by smtp.gmail.com with ESMTPSA id x8-20020a05620a258800b006fef157c8aesm2865793qko.36.2022.12.10.13.29.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Dec 2022 13:29:23 -0800 (PST)
Date:   Sat, 10 Dec 2022 13:29:22 -0800
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Hawkins Jiawei <yin31149@gmail.com>
Cc:     18801353760@163.com, cong.wang@bytedance.com, davem@davemloft.net,
        dvyukov@google.com, edumazet@google.com, jhs@mojatatu.com,
        jiri@resnulli.us, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzbot+232ebdbd36706c965ebf@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH v3] net: sched: fix memory leak in tcindex_set_parms
Message-ID: <Y5T6Mrb7cs6o/BqS@pop-os.localdomain>
References: <Y4uvQA2xxtJXltSM@pop-os.localdomain>
 <20221205151956.28422-1-yin31149@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221205151956.28422-1-yin31149@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 05, 2022 at 11:19:56PM +0800, Hawkins Jiawei wrote:
> To be more specific, the simplified logic about original
> tcindex_set_parms() is as below:
> 
> static int
> tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
> 		  u32 handle, struct tcindex_data *p,
> 		  struct tcindex_filter_result *r, struct nlattr **tb,
> 		  struct nlattr *est, u32 flags, struct netlink_ext_ack *extack)
> {
> 	...
> 	if (p->perfect) {
> 		int i;
> 
> 		if (tcindex_alloc_perfect_hash(net, cp) < 0)
> 			goto errout;
> 		cp->alloc_hash = cp->hash;
> 		for (i = 0; i < min(cp->hash, p->hash); i++)
> 			cp->perfect[i].res = p->perfect[i].res;
> 		balloc = 1;
> 	}
> 	cp->h = p->h;
> 
> 	...
> 
> 	if (cp->perfect)
> 		r = cp->perfect + handle;

We can reach here if p->perfect is non-NULL.

> 	else
> 		r = tcindex_lookup(cp, handle) ? : &new_filter_result;
> 
> 	if (old_r && old_r != r) {
> 		err = tcindex_filter_result_init(old_r, cp, net);
> 		if (err < 0) {
> 			kfree(f);
> 			goto errout_alloc;
> 		}
> 	}
> 	...
> }
> 
> - cp's h field is directly copied from p's h field
> 
> - if `old_r` is retrieved from struct tcindex_filter, in other word,
> is retrieved from p's h field. Then the `r` should get the same value
> from `tcindex_loopup(cp, handle)`.

See above, 'r' can be 'cp->perfect + handle' which is newly allocated,
hence different from 'old_r'.

> 
> - so `old_r == r` is true, code will never uses tcindex_filter_result_init()
> to clear the old_r in such case.

Not always.

> 
> So I think this patch still can fix this memory leak caused by 
> tcindex_filter_result_init(), But maybe I need to improve my
> commit message.
> 

I think your patch may introduce other memory leaks and 'old_r' may
be left as obsoleted too.

Thanks.
