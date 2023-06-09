Return-Path: <netdev+bounces-9669-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0692672A292
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 20:50:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B6E262819DD
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 18:50:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA2ED408DB;
	Fri,  9 Jun 2023 18:50:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD03408C4
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 18:50:32 +0000 (UTC)
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43F9D35B5
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 11:50:30 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-3f7e4953107so8405e9.1
        for <netdev@vger.kernel.org>; Fri, 09 Jun 2023 11:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686336629; x=1688928629;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DHDmxWhKPuDVsVdS2XLmDCLLMiW9MiJueU0GA2Acq8Q=;
        b=a9VJyKW9LwlQ4EwSibcIeF5vGmWQt0nzKluzs9V5Lj0nY260nJRXCI+amu1cWH2Tn+
         DKMmqbu0plF85gjdqA8kW3YyPBVl2gIUCs5yBGlopKf0nGZyT5KtR5aVUOpYELstSSMr
         dLTlmTvY8FlA29nlJeaXA6wvyPu+JRwPR2MRjnVJjDWpQuL7HM3vpl6PgXC4xrNl0cjf
         rJOr0cgzzAm2D5EfQt4CpPnz8c+ftZQJP/Epe7zyW56K6f8TSj6/r4mL1uUdTy6P3cPe
         PpFyFR+knxOYj5zOXtGRM7mGe7PXM9V96jUoGH6Xs80cfrwsSUrGDaNZRzPCj+w97K1i
         QgyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686336629; x=1688928629;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DHDmxWhKPuDVsVdS2XLmDCLLMiW9MiJueU0GA2Acq8Q=;
        b=EJS6aRQNyeXktCPGpLvNePLFgKp4mlrk26ZD2y1LSN2321eBzO+NUHGTw9+kO/yiUH
         rqV5jlbv3Kc8VX0FBaeWDEAeJBfvlGiNLLo7A+/gODAZePIHOHI0h0yH2uXGx52Vbh9o
         FX0LcUOmPHmlJK87jmmMpXtw/xS04owG05ISbTx+LYc8s9+EW36Y4PfrqRhyuPPdb0ZS
         ipokaL9/V6r2pTWJaPi3zGwOfqUxtcFvEGIashFZywuma4U7VhdJJ6POUmJNIptQ1881
         jHUnegxcjRLK+OUc7ud/F5Uk/puHHliKMPLXJtV7YiqP2c3iTTa+EXGGkmtjJ/bJ+HE0
         cePg==
X-Gm-Message-State: AC+VfDznl88uAFqdod4nYOFcjzQ97cWKuLYG8PW+98g/GeEOfceTdiYm
	67wLe7ok+F4woydjp1cHttOumRLFWA5r/JRTJU0h+A==
X-Google-Smtp-Source: ACHHUZ4IRBsNQqVZ9lNwwR4Fm4nVA9Qz6gHH8dtBDuL229bICbukMl0xyE2wo5DWlfn2WptDqtDrO8a5TCxL4dXGBK0=
X-Received: by 2002:a05:600c:1f0d:b0:3f7:ba55:d03b with SMTP id
 bd13-20020a05600c1f0d00b003f7ba55d03bmr437139wmb.2.1686336628549; Fri, 09 Jun
 2023 11:50:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230609183207.1466075-1-kuba@kernel.org> <20230609183207.1466075-2-kuba@kernel.org>
In-Reply-To: <20230609183207.1466075-2-kuba@kernel.org>
From: Eric Dumazet <edumazet@google.com>
Date: Fri, 9 Jun 2023 20:50:07 +0200
Message-ID: <CANn89iK1mhsEhvT_aitD-G8gEd4Pqo6bB3kHYFUDiRQmiM_Bhg@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] net: create device lookup API with reference tracking
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

On Fri, Jun 9, 2023 at 8:32=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wro=
te:
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
>  include/linux/netdevice.h |  4 +++
>  net/core/dev.c            | 75 ++++++++++++++++++++++++++-------------
>  net/ethtool/netlink.c     |  8 ++---
>  net/ipv6/route.c          | 12 +++----
>  4 files changed, 65 insertions(+), 34 deletions(-)
>
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index c2f0c6002a84..732d7a226e93 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -3124,6 +3124,10 @@ struct net_device *netdev_sk_get_lowest_dev(struct=
 net_device *dev,
>                                             struct sock *sk);
>  struct net_device *dev_get_by_index(struct net *net, int ifindex);
>  struct net_device *__dev_get_by_index(struct net *net, int ifindex);
> +struct net_device *netdev_get_by_index(struct net *net, int ifindex,
> +                                      netdevice_tracker *tracker, gfp_t =
gfp);
> +struct net_device *netdev_get_by_name(struct net *net, const char *name,
> +                                     netdevice_tracker *tracker, gfp_t g=
fp);
>  struct net_device *dev_get_by_index_rcu(struct net *net, int ifindex);
>  struct net_device *dev_get_by_napi_id(unsigned int napi_id);
>  int dev_restart(struct net_device *dev);
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 6d6f8a7fe6b4..0e9419d220bf 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -758,18 +758,7 @@ struct net_device *dev_get_by_name_rcu(struct net *n=
et, const char *name)
>  }
>  EXPORT_SYMBOL(dev_get_by_name_rcu);
>
> -/**
> - *     dev_get_by_name         - find a device by its name
> - *     @net: the applicable net namespace
> - *     @name: name to find
> - *
> - *     Find an interface by name. This can be called from any
> - *     context and does its own locking. The returned handle has
> - *     the usage count incremented and the caller must use dev_put() to
> - *     release it when it is no longer needed. %NULL is returned if no
> - *     matching device is found.
> - */
> -
> +/* Deprecated for new users, call netdev_get_by_name() instead */
>  struct net_device *dev_get_by_name(struct net *net, const char *name)
>  {
>         struct net_device *dev;
> @@ -782,6 +771,31 @@ struct net_device *dev_get_by_name(struct net *net, =
const char *name)
>  }
>  EXPORT_SYMBOL(dev_get_by_name);
>
> +/**
> + *     netdev_get_by_name() - find a device by its name
> + *     @net: the applicable net namespace
> + *     @name: name to find
> + *     @tracker: tracking object for the acquired reference
> + *     @gfp: allocation flags for the tracker
> + *
> + *     Find an interface by name. This can be called from any
> + *     context and does its own locking. The returned handle has
> + *     the usage count incremented and the caller must use netdev_put() =
to
> + *     release it when it is no longer needed. %NULL is returned if no
> + *     matching device is found.
> + */
> +struct net_device *netdev_get_by_name(struct net *net, const char *name,
> +                                     netdevice_tracker *tracker, gfp_t g=
fp)
> +{
> +       struct net_device *dev;
> +
> +       dev =3D dev_get_by_name(net, name);
> +       if (dev)
> +               netdev_tracker_alloc(dev, tracker, gfp);
> +       return dev;
> +}
> +EXPORT_SYMBOL(netdev_get_by_name);
> +
>  /**
>   *     __dev_get_by_index - find a device by its ifindex
>   *     @net: the applicable net namespace
> @@ -831,18 +845,7 @@ struct net_device *dev_get_by_index_rcu(struct net *=
net, int ifindex)
>  }
>  EXPORT_SYMBOL(dev_get_by_index_rcu);
>
> -
> -/**
> - *     dev_get_by_index - find a device by its ifindex
> - *     @net: the applicable net namespace
> - *     @ifindex: index of device
> - *
> - *     Search for an interface by index. Returns NULL if the device
> - *     is not found or a pointer to the device. The device returned has
> - *     had a reference added and the pointer is safe until the user call=
s
> - *     dev_put to indicate they have finished with it.
> - */
> -
> +/* Deprecated for new users, call netdev_get_by_index() instead */
>  struct net_device *dev_get_by_index(struct net *net, int ifindex)
>  {
>         struct net_device *dev;
> @@ -855,6 +858,30 @@ struct net_device *dev_get_by_index(struct net *net,=
 int ifindex)
>  }
>  EXPORT_SYMBOL(dev_get_by_index);
>
> +/**
> + *     netdev_get_by_index() - find a device by its ifindex
> + *     @net: the applicable net namespace
> + *     @ifindex: index of device
> + *     @tracker: tracking object for the acquired reference
> + *     @gfp: allocation flags for the tracker
> + *
> + *     Search for an interface by index. Returns NULL if the device
> + *     is not found or a pointer to the device. The device returned has
> + *     had a reference added and the pointer is safe until the user call=
s
> + *     netdev_put() to indicate they have finished with it.
> + */
> +struct net_device *netdev_get_by_index(struct net *net, int ifindex,
> +                                      netdevice_tracker *tracker, gfp_t =
gfp)
> +{
> +       struct net_device *dev;
> +
> +       dev =3D dev_get_by_index(net, ifindex);
> +       if (dev)
> +               netdev_tracker_alloc(dev, tracker, gfp);
> +       return dev;
> +}
> +EXPORT_SYMBOL(netdev_get_by_index);
> +
>  /**
>   *     dev_get_by_napi_id - find a device by napi_id
>   *     @napi_id: ID of the NAPI struct
> diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
> index 08120095cc68..107ef80e48e1 100644
> --- a/net/ethtool/netlink.c
> +++ b/net/ethtool/netlink.c
> @@ -113,7 +113,8 @@ int ethnl_parse_header_dev_get(struct ethnl_req_info =
*req_info,
>         if (tb[ETHTOOL_A_HEADER_DEV_INDEX]) {
>                 u32 ifindex =3D nla_get_u32(tb[ETHTOOL_A_HEADER_DEV_INDEX=
]);
>
> -               dev =3D dev_get_by_index(net, ifindex);
> +               dev =3D netdev_get_by_index(net, ifindex, &req_info->dev_=
tracker,
> +                                         GFP_KERNEL);
>                 if (!dev) {
>                         NL_SET_ERR_MSG_ATTR(extack,
>                                             tb[ETHTOOL_A_HEADER_DEV_INDEX=
],

You forgot to change dev_put(dev) at line 126

> @@ -129,7 +130,8 @@ int ethnl_parse_header_dev_get(struct ethnl_req_info =
*req_info,
>                         return -ENODEV;
>                 }
>         } else if (devname_attr) {
> -               dev =3D dev_get_by_name(net, nla_data(devname_attr));
> +               dev =3D netdev_get_by_name(net, nla_data(devname_attr),
> +                                        &req_info->dev_tracker, GFP_KERN=
EL);
>                 if (!dev) {
>                         NL_SET_ERR_MSG_ATTR(extack, devname_attr,
>                                             "no device matches name");
> @@ -142,8 +144,6 @@ int ethnl_parse_header_dev_get(struct ethnl_req_info =
*req_info,
>         }
>
>         req_info->dev =3D dev;
> -       if (dev)
> -               netdev_tracker_alloc(dev, &req_info->dev_tracker, GFP_KER=
NEL);
>         req_info->flags =3D flags;
>         return 0;
>  }

