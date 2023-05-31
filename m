Return-Path: <netdev+bounces-6830-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B1A97185B4
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 17:08:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B9CE31C20D64
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 15:08:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 412D6168A8;
	Wed, 31 May 2023 15:07:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3529216425
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 15:07:46 +0000 (UTC)
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F7FB136
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 08:07:33 -0700 (PDT)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-561c1436c75so83601407b3.1
        for <netdev@vger.kernel.org>; Wed, 31 May 2023 08:07:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1685545652; x=1688137652;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9aQg/XyLc0KoyLOMQC9nxzXd5jehGRavUIxUSIV2naQ=;
        b=1EhPv/FGgUxPG7bhv9pWTsI9oglY2BT+2VHNgu6m+3vORlYefuXvCNDfSavIZlEXuq
         dlSl8rh+SFNbx36nrP/0GkdsrzahtH/Nq7Yla5bLSyD++kFxWXXgEMAGinIjlHsKDOu9
         lIj04xMLqI3xHIZJsMwBaLwOUnLn5vqMNtx5Pfapt8p49CozlpTrJDiYoEi+r5Iqb/rA
         BENjtK3nWgXHC+SASym4IQJIjAU8AJkyJOjpFDsO4YLkcsZjj4rt5eBxxpuGVddFlDPa
         U3Bg8+KJ0+loUmO5o+mnhqV7SEAEXnjFoPcA2kDDDCEk79J8XJ8anTbs1j+dtCtUGqYE
         9jaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685545652; x=1688137652;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9aQg/XyLc0KoyLOMQC9nxzXd5jehGRavUIxUSIV2naQ=;
        b=ljNvbFobM3ld6cXxYuO1ZtsXqfqnz3uFIDzyUoCDVxZqXF7JKdXZWTXs0NMjZDm4qu
         fCxfSY3YIBAc0JuxkXLFZlpGQluQ2ZBG2usWZV2pYYnKQIa5VsRUkftrrQJKgHTnaRBE
         F/mJvQ2t5sX9Jn0S81vrUZSTMv80hcY5uPw8kjv4tkoBUgFbsrI3HOPnzYikF7WdDk44
         DA30Maj39gQql24S94/ZDr64vso/dCoUdaCg6h0KoRWIOXebVA6q4kjLlsc4gQT++cRW
         n+YWrH02+6Q8vrV6xor/v53inqu6c7hVxGLs8K5FI2zJXuq1hiC7ASPdIUZxXVLWW4S1
         XKOg==
X-Gm-Message-State: AC+VfDx9/500PoGDyl1VrCibH5/sKxKhxma/bY5mHahq1errAF4Gl4u/
	31PHOzj6smmpjS4UXWL6XgHy6A+Ts8ZOmP9pSNtgCQ==
X-Google-Smtp-Source: ACHHUZ77LJrjRPlRCPaA1cCrFz7N3gR49T4+cjdOnPoFno78wVh8ZdLEgtBGtF1oXcnMf9/wyM5Ti7RrmCAKn4hRS+A=
X-Received: by 2002:a81:6c84:0:b0:565:9fc7:9330 with SMTP id
 h126-20020a816c84000000b005659fc79330mr5984962ywc.17.1685545652645; Wed, 31
 May 2023 08:07:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230531141556.1637341-1-lee@kernel.org> <CANn89iJw2N9EbF+Fm8KCPMvo-25ONwba+3PUr8L2ktZC1Z3uLw@mail.gmail.com>
In-Reply-To: <CANn89iJw2N9EbF+Fm8KCPMvo-25ONwba+3PUr8L2ktZC1Z3uLw@mail.gmail.com>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Wed, 31 May 2023 11:07:21 -0400
Message-ID: <CAM0EoMnUgXsr4UBeZR57vPpc5WRJkbWUFsii90jXJ=stoXCGcg@mail.gmail.com>
Subject: Re: [PATCH 1/1] net/sched: cls_u32: Fix reference counter leak
 leading to overflow
To: Eric Dumazet <edumazet@google.com>
Cc: Lee Jones <lee@kernel.org>, xiyou.wangcong@gmail.com, jiri@resnulli.us, 
	davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, stable@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 31, 2023 at 11:03=E2=80=AFAM Eric Dumazet <edumazet@google.com>=
 wrote:
>
> On Wed, May 31, 2023 at 4:16=E2=80=AFPM Lee Jones <lee@kernel.org> wrote:
> >
> > In the event of a failure in tcf_change_indev(), u32_set_parms() will
> > immediately return without decrementing the recently incremented
> > reference counter.  If this happens enough times, the counter will
> > rollover and the reference freed, leading to a double free which can be
> > used to do 'bad things'.
> >
> > Cc: stable@kernel.org # v4.14+
>
> Please add a Fixes: tag.
>
> > Signed-off-by: Lee Jones <lee@kernel.org>
> > ---
> >  net/sched/cls_u32.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
> > index 4e2e269f121f8..fad61ca5e90bf 100644
> > --- a/net/sched/cls_u32.c
> > +++ b/net/sched/cls_u32.c
> > @@ -762,8 +762,11 @@ static int u32_set_parms(struct net *net, struct t=
cf_proto *tp,
> >         if (tb[TCA_U32_INDEV]) {
> >                 int ret;
> >                 ret =3D tcf_change_indev(net, tb[TCA_U32_INDEV], extack=
);
>
> This call should probably be done earlier in the function, next to
> tcf_exts_validate_ex()
>
> Otherwise we might ask why the tcf_bind_filter() does not need to be undo=
ne.
>
> Something like:
>
> diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
> index 4e2e269f121f8a301368b9783753e055f5af6a4e..ac957ff2216ae18bcabdd3af3=
b0e127447ef8f91
> 100644
> --- a/net/sched/cls_u32.c
> +++ b/net/sched/cls_u32.c
> @@ -718,13 +718,18 @@ static int u32_set_parms(struct net *net, struct
> tcf_proto *tp,
>                          struct nlattr *est, u32 flags, u32 fl_flags,
>                          struct netlink_ext_ack *extack)
>  {
> -       int err;
> +       int err, ifindex =3D -1;
>
>         err =3D tcf_exts_validate_ex(net, tp, tb, est, &n->exts, flags,
>                                    fl_flags, extack);
>         if (err < 0)
>                 return err;
>
> +       if (tb[TCA_U32_INDEV]) {
> +               ifindex =3D tcf_change_indev(net, tb[TCA_U32_INDEV], exta=
ck);
> +               if (ifindex < 0)
> +                       return -EINVAL;
> +       }
>         if (tb[TCA_U32_LINK]) {
>                 u32 handle =3D nla_get_u32(tb[TCA_U32_LINK]);
>                 struct tc_u_hnode *ht_down =3D NULL, *ht_old;
> @@ -759,13 +764,9 @@ static int u32_set_parms(struct net *net, struct
> tcf_proto *tp,
>                 tcf_bind_filter(tp, &n->res, base);
>         }
>
> -       if (tb[TCA_U32_INDEV]) {
> -               int ret;
> -               ret =3D tcf_change_indev(net, tb[TCA_U32_INDEV], extack);
> -               if (ret < 0)
> -                       return -EINVAL;
> -               n->ifindex =3D ret;
> -       }
> +       if (ifindex >=3D 0)
> +               n->ifindex =3D ifindex;
> +

I guess we crossed paths ;->

Please, add a tdc test as well - it doesnt have to be in this patch,
can be a followup.

cheers,
jamal

>         return 0;
>  }

