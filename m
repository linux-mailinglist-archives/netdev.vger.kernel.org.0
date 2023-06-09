Return-Path: <netdev+bounces-9593-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9420F729F51
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 17:56:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2068B28199A
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 15:56:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81DD919E65;
	Fri,  9 Jun 2023 15:56:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779C817757
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 15:56:08 +0000 (UTC)
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B21873589
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 08:56:03 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id 3f1490d57ef6-bacfcc7d1b2so1831082276.2
        for <netdev@vger.kernel.org>; Fri, 09 Jun 2023 08:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1686326163; x=1688918163;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hjQ4waiFgY2SpS6vfX+NQ6H8ClBpY8gsNtdTsuAeGow=;
        b=Hahr+2kwlcgcYlWWa13W2s5PfYpu9RxRktd/OckDlJw9u8XVx/J/BE4+y95GCyz6ZI
         CgBOCMtmD/sEHGjXj0z40ZX07nkj9iPEx3IbqIFVqftn5dkB2ym/CYLNzNK/Fzuc0qu4
         QV0Qlwkl48D/y5ECYJInJZLAmAe3k23hcW6yyfs4bUnhvcjhEj+u4Bnrbvx4SEIYKKO9
         DBpFjQHUWGvecCRtzMk6kQmubkvsTni8r1HSyx3s1dDurs7O4Eo/72xYMtlTmC7sYTGq
         Rg+cJi0Wwoz8fo1cYBw6G4G30t7XIuQ8ZpAyXH07Tuno6pfThfSeoh1q53y8IynYj2AW
         Z/1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686326163; x=1688918163;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hjQ4waiFgY2SpS6vfX+NQ6H8ClBpY8gsNtdTsuAeGow=;
        b=iPyVhpwW42eHuaAc87pP3rPtX9QJGaXGbPn1uhyztOHh1gizMe4rSlU2v+ULhJt1d/
         9aO/1TOpYmC77KJUtR2IFgIVfsDhFkwYDIo/c3hcjST60mNl5DJZ1GBqkfxgWxnh0175
         6Sfzl1ePD9prH7yx/xO5P7rpgFsb54mLZuyV2hZmHKh43jvvDIFTE6hhAfH/j3i4nv+q
         XenbnqhW4veHwxjiST0LefQizlaSD/pWl6N0yfTkVBEEcvzceDKfnJd9AL/Pdb8wZtUN
         P5n0mrRNaQoscPBFXz/Z2QrXIuPVhkTgVMeAutCO53rftgdiWHBePQ2J7qqonIX3/pf2
         8zbw==
X-Gm-Message-State: AC+VfDxMGIZEawqqklrf69aVTjay2hMlxu0gBOn67nOIxgxkLp07xXi2
	sn42oGzqc8uiD+G/ywGKtEWHf/HBfg1/VQhbrdReiw==
X-Google-Smtp-Source: ACHHUZ4Pt3PfyCqbPbNK66rSrdmIz2exluZc2a1ZLp43ZMopF+KntRAFTyk/pOU1yJ+KQ3AZfNGHs7d+xb71DioOybc=
X-Received: by 2002:a0d:cf86:0:b0:565:2328:1db5 with SMTP id
 r128-20020a0dcf86000000b0056523281db5mr1284744ywd.48.1686326162595; Fri, 09
 Jun 2023 08:56:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230609070117.100507-1-jiapeng.chong@linux.alibaba.com> <ce770d0f-20b4-8040-8625-365758351998@mojatatu.com>
In-Reply-To: <ce770d0f-20b4-8040-8625-365758351998@mojatatu.com>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Fri, 9 Jun 2023 11:55:50 -0400
Message-ID: <CAM0EoMm_w5vCfdTTJrPfFCrmWOuqL1_yqCmwHFAZSDdHqVMKZg@mail.gmail.com>
Subject: Re: [PATCH] net/sched: act_pedit: Use kmemdup() to replace kmalloc + memcpy
To: Pedro Tammela <pctammela@mojatatu.com>
Cc: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>, xiyou.wangcong@gmail.com, 
	jiri@resnulli.us, davem@davemloft.net, edumazet@google.com, kuba@kernel.org, 
	pabeni@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Abaci Robot <abaci@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 9, 2023 at 8:30=E2=80=AFAM Pedro Tammela <pctammela@mojatatu.co=
m> wrote:
>
> On 09/06/2023 04:01, Jiapeng Chong wrote:
> > ./net/sched/act_pedit.c:245:21-28: WARNING opportunity for kmemdup.
> >
> > Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> > Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=3D5478
> > Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
>
> LGTM,
>
> Reviewed-by: Pedro Tammela <pctammela@mojatatu.com>

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal

> > ---
> >   net/sched/act_pedit.c | 4 +---
> >   1 file changed, 1 insertion(+), 3 deletions(-)
> >
> > diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
> > index fc945c7e4123..8c4e7fddddbf 100644
> > --- a/net/sched/act_pedit.c
> > +++ b/net/sched/act_pedit.c
> > @@ -242,14 +242,12 @@ static int tcf_pedit_init(struct net *net, struct=
 nlattr *nla,
> >       nparms->tcfp_flags =3D parm->flags;
> >       nparms->tcfp_nkeys =3D parm->nkeys;
> >
> > -     nparms->tcfp_keys =3D kmalloc(ksize, GFP_KERNEL);
> > +     nparms->tcfp_keys =3D kmemdup(parm->keys, ksize, GFP_KERNEL);
> >       if (!nparms->tcfp_keys) {
> >               ret =3D -ENOMEM;
> >               goto put_chain;
> >       }
> >
> > -     memcpy(nparms->tcfp_keys, parm->keys, ksize);
> > -
> >       for (i =3D 0; i < nparms->tcfp_nkeys; ++i) {
> >               u32 offmask =3D nparms->tcfp_keys[i].offmask;
> >               u32 cur =3D nparms->tcfp_keys[i].off;
>

