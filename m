Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CAD561F822
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 17:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231921AbiKGQAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 11:00:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232178AbiKGQAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 11:00:44 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD1471FFB9;
        Mon,  7 Nov 2022 08:00:43 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id h193so10804015pgc.10;
        Mon, 07 Nov 2022 08:00:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zM62t9T1ZdT2U/84XnMAZPGX/TCN0Lrw5CQPxGSu9nE=;
        b=XIaFH84W6acrnXuOb0f2berYl14VEU8MabIMSt7LOmsiDV1x5DfnPaYwARgcnxWHky
         HlvbwdljMoTUqaPwCTeG6xecsHSnIj7FsCIxkc4qlZEhOLxopc9EgTDlsVOihCMDqd5W
         7crghGrWdDEh262g2ofsCg5CieErR6/do3LP3lDEi2+xC8qiO40d1UvtN319d0TAmj4o
         5zs6fpceGhbe646zXfprWRAnMzTSoShLEIUPQzJrTKBpHmx9n9CD0n2YV8+A9EfMCztn
         b9qbwW0pcTfcGrNHLqcFW+e+iMSJ6NyGsScE6LCxoTYhpOz6xsHSFIpcAfzCnBSDr//D
         RnlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zM62t9T1ZdT2U/84XnMAZPGX/TCN0Lrw5CQPxGSu9nE=;
        b=muKo/dp0493I9SREn1iTVdCzvHv28zKbxzNpjVSXnNS6IOQjfW5EtHqnkPdv4DRl+2
         xgsqYPQo/AZJ0LSL20AfV/V7GmSHlYf7D/pyX9Y9xfj5VzF8/VWeNNjZYrwpAPW16zx4
         1b89FoGQW9fSyInQnOkwn5BlsDTT7p1WB+PImWescEoSCONPnMN+nDPHNbSnibhUfhdI
         MB5ifpoA2PMf6RrZAKmsDG4aeJuvAMNigWffoRbpFhvOKWt6UW5YudS6+2/fF4iP6uJo
         4QbQY0XSBH6gA6uuf2DgzsViGj5lH3B0JULJsdCvOLF8UZWTIvKeQBEOIP769MNuiXc4
         nPhg==
X-Gm-Message-State: ACrzQf1eB0XR2A+xd0NN1VUbE1C+jQ7B19hH2V4DDHFmG6r6vojytUMT
        S96O8+JaBW7ClsrsNZFjd9A=
X-Google-Smtp-Source: AMsMyM7WYoPgOmXg3H1xSeSZ5zwMlyIdssD++Q+DTDBrW76qZMaJHmCQZIjYmH9Nc6tqcsWQj08wiQ==
X-Received: by 2002:a63:1308:0:b0:440:5517:c99d with SMTP id i8-20020a631308000000b004405517c99dmr29092127pgl.550.1667836843187;
        Mon, 07 Nov 2022 08:00:43 -0800 (PST)
Received: from localhost ([183.242.254.174])
        by smtp.gmail.com with ESMTPSA id y13-20020a170902b48d00b001869f2120a5sm5139984plr.34.2022.11.07.08.00.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 08:00:42 -0800 (PST)
From:   Hawkins Jiawei <yin31149@gmail.com>
To:     xiyou.wangcong@gmail.com, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     18801353760@163.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        syzbot+232ebdbd36706c965ebf@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, yin31149@gmail.com
Subject: Re: [PATCH] net: sched: fix memory leak in tcindex_set_parms
Date:   Tue,  8 Nov 2022 00:00:36 +0800
Message-Id: <20221107160036.175401-1-yin31149@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <Y2fznI8JgkTBCVAA@pop-os.localdomain>
References: <Y2fznI8JgkTBCVAA@pop-os.localdomain>
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

On Mon, 7 Nov 2022 at 01:49, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Sun, Nov 06, 2022 at 10:55:31PM +0800, Hawkins Jiawei wrote:
> > Hi Cong,
> >
> > >
> > >
> > > diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
> > > index 1c9eeb98d826..00a6c04a4b42 100644
> > > --- a/net/sched/cls_tcindex.c
> > > +++ b/net/sched/cls_tcindex.c
> > > @@ -479,6 +479,7 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
> > >         }
> > >
> > >         if (old_r && old_r != r) {
> > > +               tcf_exts_destroy(&old_r->exts);
> > >                 err = tcindex_filter_result_init(old_r, cp, net);
> > >                 if (err < 0) {
> > >                         kfree(f);
> >
> > As for the position of the tcf_exts_destroy(), should we
> > call it after the RCU updating, after
> > `rcu_assign_pointer(tp->root, cp)` ?
> >
> > Or the concurrent RCU readers may derefer this freed memory
> > (Please correct me If I am wrong).
>
> I don't think so, because we already have tcf_exts_change() in multiple
> places within tcindex_set_parms(). Even if this is really a problem,

Do you mean that, if this is a problem, then these tcf_exts_change()
should have already triggered the Use-after-Free?(Please correct me
if I get wrong)

But it seems that these tcf_exts_change() don't destory the old_r,
so it doesn't face the above concurrent problems.

I find there are two tcf_exts_chang() in tcindex_set_parms().
One is

	oldp = p;
	r->res = cr;
	tcf_exts_change(&r->exts, &e);

	rcu_assign_pointer(tp->root, cp);

the other is

	f->result.res = r->res;
	tcf_exts_change(&f->result.exts, &r->exts);

	fp = cp->h + (handle % cp->hash);
	for (nfp = rtnl_dereference(*fp);
	     nfp;
	     fp = &nfp->next, nfp = rtnl_dereference(*fp))
			; /* nothing */

	rcu_assign_pointer(*fp, f);

*r->exts* or *f->result.exts*, both are newly allocated in
`tcindex_set_params()`, so the concurrent RCU readers won't read them
before RCU updating.

> moving it after rcu_assign_pointer() does not help, you need to wait for
> a grace period.

Yes, you are right. So if this is really a problem, I wonder if we can
add the synchronize_rcu() before freeing the old->exts, like:

diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
index 1c9eeb98d826..57d900c664cf 100644
--- a/net/sched/cls_tcindex.c
+++ b/net/sched/cls_tcindex.c
@@ -338,6 +338,7 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
        struct tcf_result cr = {};
        int err, balloc = 0;
        struct tcf_exts e;
+       struct tcf_exts old_e = {};
 
        err = tcf_exts_init(&e, net, TCA_TCINDEX_ACT, TCA_TCINDEX_POLICE);
        if (err < 0)
@@ -479,6 +480,7 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
        }
 
        if (old_r && old_r != r) {
+               old_e = old_r->exts;
                err = tcindex_filter_result_init(old_r, cp, net);
                if (err < 0) {
                        kfree(f);
@@ -510,6 +512,9 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
                tcf_exts_destroy(&new_filter_result.exts);
        }
 
+       synchronize_rcu();
+       tcf_exts_destroy(&old_e);
+
        if (oldp)
                tcf_queue_work(&oldp->rwork, tcindex_partial_destroy_work);
        return 0;

>
> Thanks.
