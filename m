Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 760A66B0D4C
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 16:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbjCHPtM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 10:49:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232060AbjCHPsv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 10:48:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8087313DCF
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 07:48:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678290479;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u2aYp4k828paO2h5rj3MxTswJBSoiDLF+Fg9X0l8IWA=;
        b=Dq4tvOQYpqTsOcqUB6D9w9gDcAf+pOfb16bKUWyRprn+AqoDYL10KGaWsoRKfAtaHaG7mD
        //DmPxg+rhj1rB2v75HcPO4NTs/MY9bKcrv6URpeUZjJm14aNIKtdL05F2KI20Pbq04BDC
        rA9slElAltZtgaC9PMEMmsZRqDW5PW8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-343-xM-2GCZMPASzAkICNgnVGw-1; Wed, 08 Mar 2023 10:47:57 -0500
X-MC-Unique: xM-2GCZMPASzAkICNgnVGw-1
Received: by mail-wm1-f69.google.com with SMTP id l23-20020a7bc457000000b003e206cbce8dso6002273wmi.7
        for <netdev@vger.kernel.org>; Wed, 08 Mar 2023 07:47:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678290476;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u2aYp4k828paO2h5rj3MxTswJBSoiDLF+Fg9X0l8IWA=;
        b=NeJJqDV7g+6Oa9ntKesfLb/LVvxCy7dQSwNxQt6pmBkMB36TWFarxDHwqBnx/4Tv1v
         xs3LoadFy8FlUmPg03HM2Zh6NPDGp/r1Fk8Ot1VDmqtGaPPYeeMzlkGQux8W92CMxBai
         3tPYXt1/YoLa2dEemmDR5NNDQ1knaGCkrRmRcAblSPeDdA4IFYoMc56BmrFiRNZy3XWz
         xiNbJj5947FMfKc1aCY63j/UQkUrIjDFgkJJZXB3g0WmA/n8uHtehCC8+TZScZp0shQu
         y4g09V1uVVDYlIe29OupX6AVJL7+EdiZ8OV5qcEb4F+eWWp+2tskEOlWkk+4Ri52hSBN
         eOzA==
X-Gm-Message-State: AO0yUKX4jFJqa0WSM73zQzJuc59s4OAr560/vdgyVoCT6XTCd7GavES2
        RoHOxyjlvmctLBijJP2UQa6q2xXBGdSyJG7ITo3Ws+5YWjOyVuDkDeyQyyLFI8D8fqMdIZFt4vf
        zklo3M+bHP9wQwCTF
X-Received: by 2002:a5d:4486:0:b0:2c9:ee31:962a with SMTP id j6-20020a5d4486000000b002c9ee31962amr11179365wrq.64.1678290476336;
        Wed, 08 Mar 2023 07:47:56 -0800 (PST)
X-Google-Smtp-Source: AK7set+QDdXbeizTpc8SYwh1Qyqpz5WXRoTKRZxdmJXTe+90dzWsC34But3KQMEaYVGmq+5Z41kZyQ==
X-Received: by 2002:a5d:4486:0:b0:2c9:ee31:962a with SMTP id j6-20020a5d4486000000b002c9ee31962amr11179340wrq.64.1678290475982;
        Wed, 08 Mar 2023 07:47:55 -0800 (PST)
Received: from localhost (net-188-216-77-84.cust.vodafonedsl.it. [188.216.77.84])
        by smtp.gmail.com with ESMTPSA id s10-20020adfea8a000000b002c7e1a39adcsm15693003wrm.23.2023.03.08.07.47.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 07:47:55 -0800 (PST)
Date:   Wed, 8 Mar 2023 16:47:53 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        saeedm@nvidia.com, leon@kernel.org, shayagr@amazon.com,
        akiyano@amazon.com, darinzon@amazon.com, sgoutham@marvell.com,
        toke@redhat.com, teknoraver@meta.com
Subject: Re: [PATCH net-next 7/8] net/mlx5e: take into account device
 reconfiguration for xdp_features flag
Message-ID: <ZAiuKRDqQ+1cQb2J@lore-desk>
References: <cover.1678200041.git.lorenzo@kernel.org>
 <8857cb8138b33c8938782e2154a56b095d611d18.1678200041.git.lorenzo@kernel.org>
 <c2d13e84-2c30-d930-37a4-4e984b85a0e4@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="rMc+rVd0QyMnGonh"
Content-Disposition: inline
In-Reply-To: <c2d13e84-2c30-d930-37a4-4e984b85a0e4@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--rMc+rVd0QyMnGonh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

>=20
>=20
> On 07/03/2023 16:54, Lorenzo Bianconi wrote:
> > Take into account LRO and GRO configuration setting device xdp_features
> > flag. Moreover consider channel rq_wq_type enabling rx scatter-gatter
> > support in xdp_features flag.
> >=20
> > Fixes: 66c0e13ad236 ("drivers: net: turn on XDP features")
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >   drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 +
> >   .../ethernet/mellanox/mlx5/core/en_ethtool.c  | 10 ++++-
> >   .../net/ethernet/mellanox/mlx5/core/en_main.c | 45 ++++++++++++++++---
> >   .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  3 ++
> >   4 files changed, 51 insertions(+), 8 deletions(-)
> >=20
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net=
/ethernet/mellanox/mlx5/core/en.h
> > index 88460b7796e5..4276c6eb6820 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
> > @@ -1243,6 +1243,7 @@ void mlx5e_build_nic_params(struct mlx5e_priv *pr=
iv, struct mlx5e_xsk *xsk, u16
> >   void mlx5e_rx_dim_work(struct work_struct *work);
> >   void mlx5e_tx_dim_work(struct work_struct *work);
> > +void mlx5e_set_xdp_feature(struct net_device *netdev);
> >   netdev_features_t mlx5e_features_check(struct sk_buff *skb,
> >   				       struct net_device *netdev,
> >   				       netdev_features_t features);
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/dri=
vers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
> > index 7708acc9b2ab..79fd21ecb9cb 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
> > @@ -1985,6 +1985,7 @@ static int set_pflag_rx_striding_rq(struct net_de=
vice *netdev, bool enable)
> >   	struct mlx5e_priv *priv =3D netdev_priv(netdev);
> >   	struct mlx5_core_dev *mdev =3D priv->mdev;
> >   	struct mlx5e_params new_params;
> > +	int err;
> >   	if (enable) {
> >   		/* Checking the regular RQ here; mlx5e_validate_xsk_param called
> > @@ -2005,7 +2006,14 @@ static int set_pflag_rx_striding_rq(struct net_d=
evice *netdev, bool enable)
> >   	MLX5E_SET_PFLAG(&new_params, MLX5E_PFLAG_RX_STRIDING_RQ, enable);
> >   	mlx5e_set_rq_type(mdev, &new_params);
> > -	return mlx5e_safe_switch_params(priv, &new_params, NULL, NULL, true);
> > +	err =3D mlx5e_safe_switch_params(priv, &new_params, NULL, NULL, true);
> > +	if (err)
> > +		return err;
> > +
> > +	/* update XDP supported features */
> > +	mlx5e_set_xdp_feature(netdev);
> > +
> > +	return 0;
> >   }
> >   static int set_pflag_rx_no_csum_complete(struct net_device *netdev, b=
ool enable)
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/driver=
s/net/ethernet/mellanox/mlx5/core/en_main.c
> > index 76a9c5194a70..1b68dd2be2c5 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > @@ -4004,6 +4004,30 @@ static int mlx5e_handle_feature(struct net_devic=
e *netdev,
> >   	return 0;
> >   }
> > +void mlx5e_set_xdp_feature(struct net_device *netdev)
> > +{
> > +	struct mlx5e_priv *priv =3D netdev_priv(netdev);
> > +	bool ndo_xmit =3D test_bit(MLX5E_STATE_XDP_ACTIVE, &priv->state);
>=20
> Our driver doesn't require loading a dummy XDP program to have the
> redirect-in ability. It's always there.
>=20
> I actually have a bug fix under internal review with Saeed that addresses
> this.
>=20
> In addition, it cleans up the NETDEV_XDP_ACT_NDO_XMIT_SG as we do not
> support it yet. I have a series that's adding support and will submit it
> soon.
>=20
> Any reason you're submitting these fixes to net-next rather than net?

Hi Tariq,

I am fine to repost this series for net instead of net-next. Any downsides =
about
it?

> Maybe it'd be better if we integrate the patches, here's my fix (still un=
der
> review...):
>=20
> Author: Tariq Toukan <tariqt@nvidia.com>
> Date:   Thu Feb 23 08:58:04 2023 +0200
>=20
>     net/mlx5e: Fix exposed xdp_features
>=20
>     Always declare NETDEV_XDP_ACT_NDO_XMIT as the ndo_xdp_xmit callback
>     is always functional per our design, and does not require loading
>     a dummy xdp program.
>=20
>     Although non-linear XDP buffer is supported for XDP_TX flow, do not
>     declare NETDEV_XDP_ACT_NDO_XMIT_SG as it is yet supported for
>     redirected-in frames.
>=20
>     Fixes: 66c0e13ad236 ("drivers: net: turn on XDP features")
>     Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
>=20
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> index 53feb0529943..9a5d3ce1fbcd 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -4741,13 +4741,6 @@ static int mlx5e_xdp_set(struct net_device *netdev,
> struct bpf_prog *prog)
>         if (old_prog)
>                 bpf_prog_put(old_prog);
>=20
> -       if (reset) {
> -               if (prog)
> -                       xdp_features_set_redirect_target(netdev, true);
> -               else
> -                       xdp_features_clear_redirect_target(netdev);
> -       }
> -
>         if (!test_bit(MLX5E_STATE_OPENED, &priv->state) || reset)
>                 goto unlock;
>=20
> @@ -5144,6 +5137,7 @@ static void mlx5e_build_nic_netdev(struct net_device
> *netdev)
>         netdev->features         |=3D NETIF_F_HW_VLAN_STAG_FILTER;
>=20
>         netdev->xdp_features =3D NETDEV_XDP_ACT_BASIC |
> NETDEV_XDP_ACT_REDIRECT |
> +                              NETDEV_XDP_ACT_NDO_XMIT |
>                                NETDEV_XDP_ACT_XSK_ZEROCOPY |
>                                NETDEV_XDP_ACT_RX_SG;

I am fine to drop this my patch and rely on the one you provided but it dep=
ends
on the eta about the described patches because otherwise real capabilities =
and
xdp-features will not be aligned. Any inputs on it?

>=20
>=20
> > +	struct mlx5e_params *params =3D &priv->channels.params;
> > +	xdp_features_t val;
> > +
> > +	if (params->packet_merge.type !=3D MLX5E_PACKET_MERGE_NONE) {
> > +		xdp_clear_features_flag(netdev);
> > +		return;
> > +	}
> > +
> > +	val =3D NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT |
> > +	      NETDEV_XDP_ACT_XSK_ZEROCOPY;
> > +	if (ndo_xmit)
> > +		val |=3D NETDEV_XDP_ACT_NDO_XMIT;
> > +	if (params->rq_wq_type =3D=3D MLX5_WQ_TYPE_CYCLIC) {
> > +		val |=3D NETDEV_XDP_ACT_RX_SG;
> > +		if (ndo_xmit)
> > +			val |=3D NETDEV_XDP_ACT_NDO_XMIT_SG;
>=20
> This NETDEV_XDP_ACT_NDO_XMIT_SG capability is not related to the RQ type.
> It's still not supported at this point.

ack, I will fix it.

>=20
> BTW, I have a series completing all the missing capabilities (multibuf on
> Striding + multibuf redirect-in), should be submitted in this kernel.

cool :)

Regards,
Lorenzo

>=20
> > +	}
> > +	xdp_set_features_flag(netdev, val);
> > +}
> > +
> >   int mlx5e_set_features(struct net_device *netdev, netdev_features_t f=
eatures)
> >   {
> >   	netdev_features_t oper_features =3D features;
> > @@ -4030,6 +4054,9 @@ int mlx5e_set_features(struct net_device *netdev,=
 netdev_features_t features)
> >   		return -EINVAL;
> >   	}
> > +	/* update XDP supported features */
> > +	mlx5e_set_xdp_feature(netdev);
> > +
> >   	return 0;
> >   }
> > @@ -4762,10 +4789,14 @@ static int mlx5e_xdp_set(struct net_device *net=
dev, struct bpf_prog *prog)
> >   		bpf_prog_put(old_prog);
> >   	if (reset) {
> > -		if (prog)
> > -			xdp_features_set_redirect_target(netdev, true);
> > -		else
> > +		if (prog) {
> > +			bool xmit_sg;
> > +
> > +			xmit_sg =3D new_params.rq_wq_type =3D=3D MLX5_WQ_TYPE_CYCLIC;
>=20
> Same, not related. Still not supported at this point.
>=20
> > +			xdp_features_set_redirect_target(netdev, xmit_sg);
> > +		} else {
> >   			xdp_features_clear_redirect_target(netdev);
> > +		}
> >   	}
> >   	if (!test_bit(MLX5E_STATE_OPENED, &priv->state) || reset)
> > @@ -5163,13 +5194,10 @@ static void mlx5e_build_nic_netdev(struct net_d=
evice *netdev)
> >   	netdev->features         |=3D NETIF_F_HIGHDMA;
> >   	netdev->features         |=3D NETIF_F_HW_VLAN_STAG_FILTER;
> > -	netdev->xdp_features =3D NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRE=
CT |
> > -			       NETDEV_XDP_ACT_XSK_ZEROCOPY |
> > -			       NETDEV_XDP_ACT_RX_SG;
> > -
> >   	netdev->priv_flags       |=3D IFF_UNICAST_FLT;
> >   	netif_set_tso_max_size(netdev, GSO_MAX_SIZE);
> > +	mlx5e_set_xdp_feature(netdev);
> >   	mlx5e_set_netdev_dev_addr(netdev);
> >   	mlx5e_macsec_build_netdev(priv);
> >   	mlx5e_ipsec_build_netdev(priv);
> > @@ -5241,6 +5269,9 @@ static int mlx5e_nic_init(struct mlx5_core_dev *m=
dev,
> >   		mlx5_core_err(mdev, "TLS initialization failed, %d\n", err);
> >   	mlx5e_health_create_reporters(priv);
> > +	/* update XDP supported features */
> > +	mlx5e_set_xdp_feature(netdev);
> > +
> >   	return 0;
> >   }
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers=
/net/ethernet/mellanox/mlx5/core/en_rep.c
> > index 9b9203443085..43fd12fb87b8 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> > @@ -747,6 +747,9 @@ static void mlx5e_build_rep_params(struct net_devic=
e *netdev)
> >   	/* RQ */
> >   	mlx5e_build_rq_params(mdev, params);
> > +	/* update XDP supported features */
> > +	mlx5e_set_xdp_feature(netdev);
> > +
> >   	/* CQ moderation params */
> >   	params->rx_dim_enabled =3D MLX5_CAP_GEN(mdev, cq_moderation);
> >   	mlx5e_set_rx_cq_mode_params(params, cq_period_mode);
>=20

--rMc+rVd0QyMnGonh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCZAiuKQAKCRA6cBh0uS2t
rB7PAP0SC0uXtgxP8IVnfoMtucBMLSKsJfPkSgYEIFTUGOQt+QD+LuapybqTcuuL
ZPqsu2iF19D1ZcLGl7+mmeQJAMYfqws=
=SWLI
-----END PGP SIGNATURE-----

--rMc+rVd0QyMnGonh--

