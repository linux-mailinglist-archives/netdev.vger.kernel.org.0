Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAF9E6B1E82
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 09:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbjCIIpC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 03:45:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbjCIIoh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 03:44:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A43165942C
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 00:43:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678351419;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iXe/9FWrduVAObLUprj9Sqq1YiIJdjdZxC3N6+6q+Pw=;
        b=SXEwDqKwPmQUzI+Te18zc8tQbbLPpF10MLTNhBPQXlXpFnYDD6Y0P6F9zKsKUyE7zrtowN
        CqAqJ+ot4kEp0ybxzNZZ0n4NHBKQaUAylg9l/VCem7NNol1NszKDJ4sPnH2YcAbFhfVlqW
        HkkQLtONLFQRoshdKou2T5CN7PNZ7eM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-661--qGZuqghOtGpMejUn0Mp4g-1; Thu, 09 Mar 2023 03:43:38 -0500
X-MC-Unique: -qGZuqghOtGpMejUn0Mp4g-1
Received: by mail-wm1-f70.google.com with SMTP id l23-20020a7bc457000000b003e206cbce8dso402272wmi.7
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 00:43:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678351417;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iXe/9FWrduVAObLUprj9Sqq1YiIJdjdZxC3N6+6q+Pw=;
        b=0LhH0kRLTrtCXdymnXjTEqVVkJ9ra5sOPSALEyNjuT1WwSIWzvhNROmSn1wMyOS+Gi
         hCrcHmyIWRLjgeTPQI3BlUg+Ry40/q+PWPIW6+eFdQKgGwBqRzFwBxqNbqTGxxI6v2nf
         SAFOaX6Po0xG1PgoCZCGjbtMPtQympLxyM9DK0zY37U2MuFsByE6V0mAga35y/EK10Rr
         jHz/4BDNF50mwpbbDhdRH1t9MXCKgw90e9CUIAAUU6bFU6DJGSY+InuHCzXhUZyoH0Od
         XpB++wZLtCWMmXw2lSIsgo1IN8NWHg32K+ZwtOk1/r1qbbWadR4Om/kgN89UrNZ89yJx
         Odow==
X-Gm-Message-State: AO0yUKWcTlwSlGWTvvOtr1lr/aUjSJb7rN8xGYIO3Oj0dFZhbBJ9hBTV
        FW7iZmsN9kn1wv7plZJepkaJpmrfwzQJIfuaxnFCKxSmGfuu1Kgxdtlv9YDpy/6NPDD0OxoWE3K
        4YvdEonR2EnrnpQFu
X-Received: by 2002:a05:600c:3d14:b0:3df:9858:c033 with SMTP id bh20-20020a05600c3d1400b003df9858c033mr18316341wmb.8.1678351417319;
        Thu, 09 Mar 2023 00:43:37 -0800 (PST)
X-Google-Smtp-Source: AK7set97LablOfEKTZ/itjMS23UWlYW77XM+fTeXjGedaJGVmoY7cRLDh035Qj+dhDk/OEb1/yN93A==
X-Received: by 2002:a05:600c:3d14:b0:3df:9858:c033 with SMTP id bh20-20020a05600c3d1400b003df9858c033mr18316321wmb.8.1678351416995;
        Thu, 09 Mar 2023 00:43:36 -0800 (PST)
Received: from localhost (net-188-216-77-84.cust.vodafonedsl.it. [188.216.77.84])
        by smtp.gmail.com with ESMTPSA id m16-20020a7bca50000000b003eb5a0873e0sm1812497wml.39.2023.03.09.00.43.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 00:43:36 -0800 (PST)
Date:   Thu, 9 Mar 2023 09:43:34 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        saeedm@nvidia.com, leon@kernel.org, shayagr@amazon.com,
        akiyano@amazon.com, darinzon@amazon.com, sgoutham@marvell.com,
        toke@redhat.com, teknoraver@meta.com,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [PATCH net-next 7/8] net/mlx5e: take into account device
 reconfiguration for xdp_features flag
Message-ID: <ZAmcNtcP7CbkgCC0@lore-desk>
References: <cover.1678200041.git.lorenzo@kernel.org>
 <8857cb8138b33c8938782e2154a56b095d611d18.1678200041.git.lorenzo@kernel.org>
 <c2d13e84-2c30-d930-37a4-4e984b85a0e4@gmail.com>
 <ZAiuKRDqQ+1cQb2J@lore-desk>
 <03095151-3659-0b1b-8e67-a416b8eafa2b@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="l5S63rz6Rq2BKuj6"
Content-Disposition: inline
In-Reply-To: <03095151-3659-0b1b-8e67-a416b8eafa2b@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--l5S63rz6Rq2BKuj6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

>=20
>=20
> On 08/03/2023 17:47, Lorenzo Bianconi wrote:
> > >=20
> > >=20
> > > On 07/03/2023 16:54, Lorenzo Bianconi wrote:
> > > > Take into account LRO and GRO configuration setting device xdp_feat=
ures
> > > > flag. Moreover consider channel rq_wq_type enabling rx scatter-gatt=
er
> > > > support in xdp_features flag.
> > > >=20
> > > > Fixes: 66c0e13ad236 ("drivers: net: turn on XDP features")
> > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > > ---
> > > >    drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 +
> > > >    .../ethernet/mellanox/mlx5/core/en_ethtool.c  | 10 ++++-
> > > >    .../net/ethernet/mellanox/mlx5/core/en_main.c | 45 +++++++++++++=
+++---
> > > >    .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  3 ++
> > > >    4 files changed, 51 insertions(+), 8 deletions(-)
> > > >=20
> > > > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers=
/net/ethernet/mellanox/mlx5/core/en.h
> > > > index 88460b7796e5..4276c6eb6820 100644
> > > > --- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
> > > > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
> > > > @@ -1243,6 +1243,7 @@ void mlx5e_build_nic_params(struct mlx5e_priv=
 *priv, struct mlx5e_xsk *xsk, u16
> > > >    void mlx5e_rx_dim_work(struct work_struct *work);
> > > >    void mlx5e_tx_dim_work(struct work_struct *work);
> > > > +void mlx5e_set_xdp_feature(struct net_device *netdev);
> > > >    netdev_features_t mlx5e_features_check(struct sk_buff *skb,
> > > >    				       struct net_device *netdev,
> > > >    				       netdev_features_t features);
> > > > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b=
/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
> > > > index 7708acc9b2ab..79fd21ecb9cb 100644
> > > > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
> > > > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
> > > > @@ -1985,6 +1985,7 @@ static int set_pflag_rx_striding_rq(struct ne=
t_device *netdev, bool enable)
> > > >    	struct mlx5e_priv *priv =3D netdev_priv(netdev);
> > > >    	struct mlx5_core_dev *mdev =3D priv->mdev;
> > > >    	struct mlx5e_params new_params;
> > > > +	int err;
> > > >    	if (enable) {
> > > >    		/* Checking the regular RQ here; mlx5e_validate_xsk_param call=
ed
> > > > @@ -2005,7 +2006,14 @@ static int set_pflag_rx_striding_rq(struct n=
et_device *netdev, bool enable)
> > > >    	MLX5E_SET_PFLAG(&new_params, MLX5E_PFLAG_RX_STRIDING_RQ, enable=
);
> > > >    	mlx5e_set_rq_type(mdev, &new_params);
> > > > -	return mlx5e_safe_switch_params(priv, &new_params, NULL, NULL, tr=
ue);
> > > > +	err =3D mlx5e_safe_switch_params(priv, &new_params, NULL, NULL, t=
rue);
> > > > +	if (err)
> > > > +		return err;
> > > > +
> > > > +	/* update XDP supported features */
> > > > +	mlx5e_set_xdp_feature(netdev);
> > > > +
> > > > +	return 0;
> > > >    }
> > > >    static int set_pflag_rx_no_csum_complete(struct net_device *netd=
ev, bool enable)
> > > > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/dr=
ivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > > > index 76a9c5194a70..1b68dd2be2c5 100644
> > > > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > > > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > > > @@ -4004,6 +4004,30 @@ static int mlx5e_handle_feature(struct net_d=
evice *netdev,
> > > >    	return 0;
> > > >    }
> > > > +void mlx5e_set_xdp_feature(struct net_device *netdev)
> > > > +{
> > > > +	struct mlx5e_priv *priv =3D netdev_priv(netdev);
> > > > +	bool ndo_xmit =3D test_bit(MLX5E_STATE_XDP_ACTIVE, &priv->state);
> > >=20
> > > Our driver doesn't require loading a dummy XDP program to have the
> > > redirect-in ability. It's always there.
> > >=20
> > > I actually have a bug fix under internal review with Saeed that addre=
sses
> > > this.
> > >=20
> > > In addition, it cleans up the NETDEV_XDP_ACT_NDO_XMIT_SG as we do not
> > > support it yet. I have a series that's adding support and will submit=
 it
> > > soon.
> > >=20
> > > Any reason you're submitting these fixes to net-next rather than net?
> >=20
> > Hi Tariq,
> >=20
> > I am fine to repost this series for net instead of net-next. Any downsi=
des about
> > it?
>=20
> Let's repost to net.
> It's a fixes series, and 6.3 is still in its RCs.
> If you don't post it to net then the xdp-features in 6.3 will be broken.

ack, fine.

>=20
> >=20
> > > Maybe it'd be better if we integrate the patches, here's my fix (stil=
l under
> > > review...):
> > >=20
> > > Author: Tariq Toukan <tariqt@nvidia.com>
> > > Date:   Thu Feb 23 08:58:04 2023 +0200
> > >=20
> > >      net/mlx5e: Fix exposed xdp_features
> > >=20
> > >      Always declare NETDEV_XDP_ACT_NDO_XMIT as the ndo_xdp_xmit callb=
ack
> > >      is always functional per our design, and does not require loading
> > >      a dummy xdp program.
> > >=20
> > >      Although non-linear XDP buffer is supported for XDP_TX flow, do =
not
> > >      declare NETDEV_XDP_ACT_NDO_XMIT_SG as it is yet supported for
> > >      redirected-in frames.
> > >=20
> > >      Fixes: 66c0e13ad236 ("drivers: net: turn on XDP features")
> > >      Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> > >=20
> > > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > > b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > > index 53feb0529943..9a5d3ce1fbcd 100644
> > > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > > @@ -4741,13 +4741,6 @@ static int mlx5e_xdp_set(struct net_device *ne=
tdev,
> > > struct bpf_prog *prog)
> > >          if (old_prog)
> > >                  bpf_prog_put(old_prog);
> > >=20
> > > -       if (reset) {
> > > -               if (prog)
> > > -                       xdp_features_set_redirect_target(netdev, true=
);
> > > -               else
> > > -                       xdp_features_clear_redirect_target(netdev);
> > > -       }
> > > -
> > >          if (!test_bit(MLX5E_STATE_OPENED, &priv->state) || reset)
> > >                  goto unlock;
> > >=20
> > > @@ -5144,6 +5137,7 @@ static void mlx5e_build_nic_netdev(struct net_d=
evice
> > > *netdev)
> > >          netdev->features         |=3D NETIF_F_HW_VLAN_STAG_FILTER;
> > >=20
> > >          netdev->xdp_features =3D NETDEV_XDP_ACT_BASIC |
> > > NETDEV_XDP_ACT_REDIRECT |
> > > +                              NETDEV_XDP_ACT_NDO_XMIT |
> > >                                 NETDEV_XDP_ACT_XSK_ZEROCOPY |
> > >                                 NETDEV_XDP_ACT_RX_SG;
> >=20
> > I am fine to drop this my patch and rely on the one you provided but it=
 depends
> > on the eta about the described patches because otherwise real capabilit=
ies and
> > xdp-features will not be aligned. Any inputs on it?
> >=20
>=20
> My patch doesn't replace yours, as it doesn't fix the missing
> features_update according to striding RQ and HW LRO/GRO.
>=20
> I think we should combine them, either take mine as-is into your series, =
or
> squash it into this patch. I'm fine with both.

ack fine, I will squash your changes into the patch posting a new version, =
thx.

Regards,
Lorenzo

>=20
> > >=20
> > >=20
> > > > +	struct mlx5e_params *params =3D &priv->channels.params;
> > > > +	xdp_features_t val;
> > > > +
> > > > +	if (params->packet_merge.type !=3D MLX5E_PACKET_MERGE_NONE) {
> > > > +		xdp_clear_features_flag(netdev);
> > > > +		return;
> > > > +	}
> > > > +
> > > > +	val =3D NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT |
> > > > +	      NETDEV_XDP_ACT_XSK_ZEROCOPY;
> > > > +	if (ndo_xmit)
> > > > +		val |=3D NETDEV_XDP_ACT_NDO_XMIT;
> > > > +	if (params->rq_wq_type =3D=3D MLX5_WQ_TYPE_CYCLIC) {
> > > > +		val |=3D NETDEV_XDP_ACT_RX_SG;
> > > > +		if (ndo_xmit)
> > > > +			val |=3D NETDEV_XDP_ACT_NDO_XMIT_SG;
> > >=20
> > > This NETDEV_XDP_ACT_NDO_XMIT_SG capability is not related to the RQ t=
ype.
> > > It's still not supported at this point.
> >=20
> > ack, I will fix it.
> >=20
> > >=20
> > > BTW, I have a series completing all the missing capabilities (multibu=
f on
> > > Striding + multibuf redirect-in), should be submitted in this kernel.
> >=20
> > cool :)
> >=20
> > Regards,
> > Lorenzo
> >=20
>=20

--l5S63rz6Rq2BKuj6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCZAmcNgAKCRA6cBh0uS2t
rJd4AP93HW5UMY7ELV0rFP2bVTRAtInbJZ41xhSwQSspc9uO5gEApqTT6QUKNHJr
WWu2jorZkr464W/TznzrS0TnuZopPAg=
=em5I
-----END PGP SIGNATURE-----

--l5S63rz6Rq2BKuj6--

