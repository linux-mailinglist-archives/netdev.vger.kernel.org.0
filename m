Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C21FE62B40C
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 08:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232364AbiKPHg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 02:36:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233075AbiKPHg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 02:36:28 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E294013D3E;
        Tue, 15 Nov 2022 23:35:42 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id y4so15676061plb.2;
        Tue, 15 Nov 2022 23:35:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dfcUfIC+n8vuBd2oNUY05LgFgo0EmYT0jFwMTSVR4p4=;
        b=jU9TyiKsLljpWLipGvQPKjltF9dl6uz2tKBKMP0EZqI8MRukRZfldprZ7TQj4sepBX
         XSLKQOybHbmbb4OWFF65GrLHvSL82VNzSdkYuM78SKF7L313mc0G66PtOGq/o2Co227j
         5gpXx6L1GykdEIDX6zYDOlXYALjP7x9IBb1OYG3iRT8cEJHWYVUC7ryvqX9Y/c6yI1aa
         0Rtx34JrRm7BzGLVeibdLdVOSspiwA42YmTBuisdxyMPA5G7/5DKLYAcnj6RDoiZdPpe
         Ws9mZcLhve1PGCbC7xuo3UPWsb+VH0EquX52Fez/ERaImJ1v0Bm8pju3cmA8M1UXbRBV
         Jz3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dfcUfIC+n8vuBd2oNUY05LgFgo0EmYT0jFwMTSVR4p4=;
        b=fdq1owFT0ekD0Eeu0fEbi1xnBC6aal0lHKLOEVMKr6YWGscnkLrkyU9UCI3QpFVNB9
         uPSTzq+i3VL0J48dXR2fHuTf0GVzcKzNsXRq1z2sOgQss/VA8IKZjx3r7uf38ZNyVKXG
         /aZksCIbS2ZjfVb1XBQyAV4ZpJRNFru42yL8t4P/PAdKyW2LauAjfbgu7VSZ0AEvz2Jz
         Id7MLBNR7++6NkelT4RVh7ytDTRdoLNZse3oR6cNtwHbsz6KaHRe7uwZItw1f951+6V4
         pJ5u9QHHYN45QZt6ayEHper64+xJiu8SZeX8LZeZQeGxgX8kbe4ZpaPDyzFo9nEP9tn+
         e96A==
X-Gm-Message-State: ANoB5pmbGvPSfMVuLQid66iz81iV3DUxDkaqkwsNZpd95uXLYq00F5Ps
        Ag//qWXfo5cWnzJ5PR0FxB8=
X-Google-Smtp-Source: AA0mqf53kLI+++l/bYl0r6Ko0vXF2UDZRvG2xG3dkGQtk+URH2a9moMmEGZxLXjCKz+vV0ZLwcBumA==
X-Received: by 2002:a17:902:7404:b0:186:75f0:331c with SMTP id g4-20020a170902740400b0018675f0331cmr7917459pll.161.1668584142340;
        Tue, 15 Nov 2022 23:35:42 -0800 (PST)
Received: from localhost ([114.254.0.245])
        by smtp.gmail.com with ESMTPSA id i65-20020a628744000000b0056b6c7a17c6sm10487264pfe.12.2022.11.15.23.35.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 23:35:41 -0800 (PST)
From:   Hawkins Jiawei <yin31149@gmail.com>
To:     kuba@kernel.org
Cc:     18801353760@163.com, cong.wang@bytedance.com, davem@davemloft.net,
        edumazet@google.com, jhs@mojatatu.com, jiri@resnulli.us,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com,
        syzbot+232ebdbd36706c965ebf@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com,
        yin31149@gmail.com
Subject: Re: [PATCH v2] net: sched: fix memory leak in tcindex_set_parms
Date:   Wed, 16 Nov 2022 15:35:22 +0800
Message-Id: <20221116073522.80304-1-yin31149@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221115090237.5d5988bb@kernel.org>
References: <20221115090237.5d5988bb@kernel.org>
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

Hi,

On Wed, 16 Nov 2022 at 01:02, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 14 Nov 2022 01:05:08 +0800 Hawkins Jiawei wrote:
> > diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
> > index 1c9eeb98d826..d2fac9559d3e 100644
> > --- a/net/sched/cls_tcindex.c
> > +++ b/net/sched/cls_tcindex.c
> > @@ -338,6 +338,7 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
> >       struct tcf_result cr = {};
> >       int err, balloc = 0;
> >       struct tcf_exts e;
> > +     struct tcf_exts old_e = {};
>
> This is not a valid way of initializing a structure.
> tcf_exts_init() is supposed to be called.
> If we add a list member to that structure this code will break, again.

Yes, you are right. But the `old_e` variable here is used only for freeing
old_r->exts resource, `old_e` will be overwritten by old_r->exts content
as follows:

    struct tcf_exts old_e = {};
    ...

    if (old_r && old_r != r) {
            old_e = old_r->exts;
            ...
    }
    ...
    synchronize_rcu();
    tcf_exts_destroy(&old_e);

So this patch uses `struct tcf_exts old_e = {}` here just for a cleared space.
