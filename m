Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 196276AC0DD
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 14:28:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbjCFN16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 08:27:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbjCFN14 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 08:27:56 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95685170A;
        Mon,  6 Mar 2023 05:27:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 475DDCE125A;
        Mon,  6 Mar 2023 13:27:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1418DC433D2;
        Mon,  6 Mar 2023 13:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678109269;
        bh=HRhFhlWDb67hte3F1aX0kWIRzKD200F52fse70wGeKo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LeREZiEpPwGqR19CSiaHhPodE3RO7F92M5jW2Xz1tOwur3RzJr8aNmsbOU9Ky6Zm/
         65TUjoXiO1gzKfIoXIdMdy17fXS0wrasmUF+l61PF+DlYwQyh63BKYA0prwZZpCu6m
         tLrs5cB7tFeyDW5VFcueWgfLFThIInyNRuFgK6FTB1jum59+gJJe6/2Qcuc/qNHdz3
         za5mQz00HkU2OnXES+wu9y7nHvGW8h5oiN4cHqoxYhF/4edpVrZBXnh/ZAKwiNRLgu
         cWz5ogQ96ZripN0AeRiX4TCLwxqgTVK3q702CPZrpjFRMTewNCw2BGsM5lh/AdcHOV
         M4r9tTlsMXo0A==
Date:   Mon, 6 Mar 2023 14:27:45 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        hawk@kernel.org, toke@redhat.com, memxor@gmail.com,
        alardam@gmail.com, lorenzo.bianconi@redhat.com
Subject: Re: [RFC net-next] ethtool: provide XDP information with
 XDP_FEATURES_GET
Message-ID: <ZAXqURbn2R+x8tiO@lore-desk>
References: <ced8d727138d487332e32739b392ec7554e7a241.1678098067.git.lorenzo@kernel.org>
 <ZAXoik8Y4OboNRAT@corigine.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="5mVK/B94dk9oukvO"
Content-Disposition: inline
In-Reply-To: <ZAXoik8Y4OboNRAT@corigine.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--5mVK/B94dk9oukvO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Mon, Mar 06, 2023 at 11:26:10AM +0100, Lorenzo Bianconi wrote:
> > Implement XDP_FEATURES_GET request to get network device information
> > about supported xdp functionalities through ethtool.
> >=20
> > Tested-by: Matteo Croce <teknoraver@meta.com>
> > Co-developed-by: Marek Majtyka <alardam@gmail.com>
> > Signed-off-by: Marek Majtyka <alardam@gmail.com>
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>=20
> ...
>=20
> > @@ -1429,6 +1431,18 @@ struct ethtool_sfeatures {
> >  	struct ethtool_set_features_block features[];
> >  };
> > =20
> > +/**
> > + * struct ethtool_xdp_gfeatures - command to get supported XDP features
> > + * @cmd: command number =3D %ETHTOOL_XDP_GFEATURES
> > + * size: array size of the features[] array
>=20
> nit: 'size' -> '@size'

ack, I will fix it.

>=20
> > + * @features: XDP feature masks
> > + */
> > +struct ethtool_xdp_gfeatures {
> > +	__u32	cmd;
> > +	__u32	size;
> > +	__u32	features[];
> > +};
> > +
> >  /**
> >   * struct ethtool_ts_info - holds a device's timestamping and PHC asso=
ciation
> >   * @cmd: command number =3D %ETHTOOL_GET_TS_INFO
>=20
> ...
>=20
> > diff --git a/net/ethtool/common.c b/net/ethtool/common.c
> > index 5fb19050991e..2be672c601ad 100644
> > --- a/net/ethtool/common.c
> > +++ b/net/ethtool/common.c
> > @@ -465,6 +465,17 @@ const char udp_tunnel_type_names[][ETH_GSTRING_LEN=
] =3D {
> >  static_assert(ARRAY_SIZE(udp_tunnel_type_names) =3D=3D
> >  	      __ETHTOOL_UDP_TUNNEL_TYPE_CNT);
> > =20
> > +const char xdp_features_strings[][ETH_GSTRING_LEN] =3D {
> > +	[NETDEV_XDP_ACT_BIT_BASIC_BIT] =3D	"xdp-basic",
> > +	[NETDEV_XDP_ACT_BIT_REDIRECT_BIT] =3D	"xdp-redirect",
> > +	[NETDEV_XDP_ACT_BIT_NDO_XMIT_BIT] =3D	"xdp-ndo-xmit",
> > +	[NETDEV_XDP_ACT_BIT_XSK_ZEROCOPY_BIT] =3D	"xdp-xsk-zerocopy",
> > +	[NETDEV_XDP_ACT_BIT_HW_OFFLOAD_BIT] =3D	"xdp-hw-offload",
> > +	[NETDEV_XDP_ACT_BIT_RX_SG_BIT] =3D	"xdp-rx-sg",
> > +	[NETDEV_XDP_ACT_BIT_NDO_XMIT_SG_BIT] =3D	"xdp-ndo-xmit-sg",
> > +};
>=20
> nit: blank line here

ack, I will fix it.

Regards,
Lorenzo

>=20
> > +static_assert(ARRAY_SIZE(xdp_features_strings) =3D=3D __NETDEV_XDP_ACT=
_BIT_MAX);
> > +
> >  /* return false if legacy contained non-0 deprecated fields
> >   * maxtxpkt/maxrxpkt. rest of ksettings always updated
> >   */
>=20
> ...

--5mVK/B94dk9oukvO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCZAXqUQAKCRA6cBh0uS2t
rOiYAPwLL9kgOkbZKo4dCfDWi7HWJYBsPcmc6o1Ll05p0YgwbAEAuLwHCOlee1vM
DNgVATHZ5oB2CPqLq7ItcDHt9bpp4QY=
=k24f
-----END PGP SIGNATURE-----

--5mVK/B94dk9oukvO--
