Return-Path: <netdev+bounces-11324-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB3C77329A8
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 10:21:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1A9F41C20F42
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 08:21:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B65BBA36;
	Fri, 16 Jun 2023 08:21:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4266117
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 08:21:18 +0000 (UTC)
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35E53212B
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 01:21:17 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id d75a77b69052e-3f9a81da5d7so182971cf.0
        for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 01:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686903676; x=1689495676;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l+gBpuqIVgXDuANKVvrjMEjkijGvwa/uQ4Fu6QDAfbU=;
        b=2N/fCvVQ0iVfVsg15Fo/zQibip6FiFLzAdBzH2QMQ40zXUMdbaUpZ39wMXgKfd6yBN
         /dcb2HCD2sbpSSuOpX0OhCvFxD9tX2PSEfe7WidY4nNcYutIJFtl3IK/8PLh75RNxrp1
         rHbCuaw389QMCQbPpK350UY98n0R3qL/STIqvKLaTsipW1TOO5QoFhEBTuea8wrqluKo
         sEOXwLTulD3M5PY6ixtCd4ZHuNMyairClSgoKpi+//V2mTLmAhaxJaYBazG9H6Pkc53T
         NBRryK2PJJbWw7ZHSRF0ldguQn4yWmi7PBjI4xeINrl/+1BFLu1Dg+U7R8t0kC6lN0Pr
         Px8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686903676; x=1689495676;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l+gBpuqIVgXDuANKVvrjMEjkijGvwa/uQ4Fu6QDAfbU=;
        b=ducesjRDMwC+SCRD0yfLrOEAj+pnFnleckdyiuOKQNEF68LVRJW7zIISpXwJpWafk+
         9lQIEYGHYDRyQVhfmG15lQ776KhtsHSkyibkfBmOG4/kzf/6ARxRJC2NttfeJf5xjBzD
         ygOPjT43W7XcLFpeVQDm4aCpgcsCpThnfneSM0XePZUu3y2x8nXv36Ga0NV2z/KGgjWk
         30X4/srxLvw1hVoHdXPpKg7d47GctGOXl9/YAcleunN10GHepcQYYWJUDJFwbbJXr1g+
         8tZl2fcH7st2e30CJXLQOur7JtuZRUGk+pqb2ieKoB2WumPgwC0rmZu1lPvETDexWLDL
         RL4w==
X-Gm-Message-State: AC+VfDzNGtbay60xeGH1Po9EMzJICLA4XMQDqopXMZFkkfmIAiG8lLID
	Pz+Iq7SgW/BSLpo7QwSm2mQjR2c7CF0oHIIEjmk/4w==
X-Google-Smtp-Source: ACHHUZ7+JYWlvO7NQLlfFmHVJKU0scDPD2ohyec+CYTiuIl9tDen8tLC6V5uC2bnHDJN03GFXoNDzGRLrb5JOVFbtPg=
X-Received: by 2002:a05:622a:60d:b0:3f2:2c89:f1ef with SMTP id
 z13-20020a05622a060d00b003f22c89f1efmr493112qta.5.1686903676195; Fri, 16 Jun
 2023 01:21:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230612214944.1837648-1-kuba@kernel.org> <20230612214944.1837648-2-kuba@kernel.org>
In-Reply-To: <20230612214944.1837648-2-kuba@kernel.org>
From: Eric Dumazet <edumazet@google.com>
Date: Fri, 16 Jun 2023 10:21:04 +0200
Message-ID: <CANn89iLgNEosmFdi7R6Rg1Wk-Z5rWB2LB40H++qPtCE0Czo7kA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/2] net: create device lookup API with
 reference tracking
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com, 
	dsahern@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 12, 2023 at 11:49=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> w=
rote:
>
> New users of dev_get_by_index() and dev_get_by_name() keep
> getting added and it would be nice to steer them towards
> the APIs with reference tracking.
>
> Add variants of those calls which allocate the reference
> tracker and use them in a couple of places.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---


> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index 392aaa373b66..e510a4162ef8 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -3503,6 +3503,7 @@ int fib6_nh_init(struct net *net, struct fib6_nh *f=
ib6_nh,
>                  struct fib6_config *cfg, gfp_t gfp_flags,
>                  struct netlink_ext_ack *extack)
>  {
> +       netdevice_tracker *dev_tracker =3D &fib6_nh->fib_nh_dev_tracker;
>         struct net_device *dev =3D NULL;
>         struct inet6_dev *idev =3D NULL;
>         int addr_type;
> @@ -3520,7 +3521,8 @@ int fib6_nh_init(struct net *net, struct fib6_nh *f=
ib6_nh,
>
>         err =3D -ENODEV;
>         if (cfg->fc_ifindex) {
> -               dev =3D dev_get_by_index(net, cfg->fc_ifindex);
> +               dev =3D netdev_get_by_index(net, cfg->fc_ifindex,
> +                                         dev_tracker, gfp_flags);
>                 if (!dev)
>                         goto out;
>                 idev =3D in6_dev_get(dev);
> @@ -3554,11 +3556,11 @@ int fib6_nh_init(struct net *net, struct fib6_nh =
*fib6_nh,
>                 /* hold loopback dev/idev if we haven't done so. */
>                 if (dev !=3D net->loopback_dev) {
>                         if (dev) {
> -                               dev_put(dev);
> +                               netdev_put(dev, dev_tracker);
>                                 in6_dev_put(idev);
>                         }
>                         dev =3D net->loopback_dev;
> -                       dev_hold(dev);
> +                       netdev_hold(dev, dev_tracker, gfp_flags);
>                         idev =3D in6_dev_get(dev);
>                         if (!idev) {
>                                 err =3D -ENODEV;
> @@ -3610,8 +3612,6 @@ int fib6_nh_init(struct net *net, struct fib6_nh *f=
ib6_nh,
>         }
>
>         fib6_nh->fib_nh_dev =3D dev;
> -       netdev_tracker_alloc(dev, &fib6_nh->fib_nh_dev_tracker, gfp_flags=
);
> -
>         fib6_nh->fib_nh_oif =3D dev->ifindex;
>         err =3D 0;
>  out:
> @@ -3621,7 +3621,7 @@ int fib6_nh_init(struct net *net, struct fib6_nh *f=
ib6_nh,
>         if (err) {
>                 lwtstate_put(fib6_nh->fib_nh_lws);
>                 fib6_nh->fib_nh_lws =3D NULL;
> -               dev_put(dev);
> +               netdev_put(dev, dev_tracker);
>         }
>
>         return err;
> --
> 2.40.1
>

Oops, ip6_validate_gw() is able to change dev under us (this is done
in ip6_route_check_nh())

Crazy, I know...

