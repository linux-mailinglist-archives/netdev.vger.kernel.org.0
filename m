Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC28E676C73
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 12:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbjAVLt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 06:49:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjAVLt0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 06:49:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6993F35BD;
        Sun, 22 Jan 2023 03:49:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DFF8660BC1;
        Sun, 22 Jan 2023 11:49:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAE01C433D2;
        Sun, 22 Jan 2023 11:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674388164;
        bh=Vx8kZgpecl8j894UuS9Gy9fQuZxp9dtbzjLs5dhZuiU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M13eMLVacR/YRSqNczt3ZXzVnr7q5dfyicuZPEXGiMjZ63P+TpCeUD1qRt3g6PRiQ
         83MIGHNJm3ZZULp3JZbGVXlQRIXP41xEuheEDPP7DJpbp1mMU4WZggOo/dO0Yj0x8q
         rKfMMa1pkQGKAJBo42r+KnSy+tvUnlcz3Vy57ohLw+jrGdhJuKMTWxe9zbUMLQR8Jb
         OAtsVvntsNbS4wS7DT6NVqzhVkq0YtmO35XgwOEPxKJHPrhXih7QG/CB2sUuON38br
         meH6mkihj2+3/thSEC9o6A9vTAuUbjgmOrhCc2CLRuyO7DqLpfc0TGqrtJ7Poa7LdI
         R/6uawCbo0NUg==
Date:   Sun, 22 Jan 2023 12:49:20 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, davem@davemloft.net,
        hawk@kernel.org, pabeni@redhat.com, edumazet@google.com,
        toke@redhat.com, memxor@gmail.com, alardam@gmail.com,
        saeedm@nvidia.com, anthony.l.nguyen@intel.com, gospo@broadcom.com,
        vladimir.oltean@nxp.com, nbd@nbd.name, john@phrozen.org,
        leon@kernel.org, simon.horman@corigine.com, aelior@marvell.com,
        christophe.jaillet@wanadoo.fr, ecree.xilinx@gmail.com,
        mst@redhat.com, bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, intel-wired-lan@lists.osuosl.org,
        lorenzo.bianconi@redhat.com, niklas.soderlund@corigine.com
Subject: Re: [PATCH bpf-next 2/7] drivers: net: turn on XDP features
Message-ID: <Y80iwBNd3tPvEbMd@lore-desk>
References: <cover.1674234430.git.lorenzo@kernel.org>
 <861224c406f78694530fde0d52c49d92e1e990a2.1674234430.git.lorenzo@kernel.org>
 <20230120191152.44d29bb1@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="w+GUdlDdqYVq1hNu"
Content-Disposition: inline
In-Reply-To: <20230120191152.44d29bb1@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--w+GUdlDdqYVq1hNu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Fri, 20 Jan 2023 18:16:51 +0100 Lorenzo Bianconi wrote:
> > +static inline void
> > +xdp_features_set_redirect_target(xdp_features_t *xdp_features, bool su=
pport_sg)
> > +{
> > +	*xdp_features |=3D NETDEV_XDP_ACT_NDO_XMIT;
> > +	if (support_sg)
> > +		*xdp_features |=3D NETDEV_XDP_ACT_NDO_XMIT_SG;
> > +}
> > +
> > +static inline void
> > +xdp_features_clear_redirect_target(xdp_features_t *xdp_features)
> > +{
> > +	*xdp_features &=3D ~(NETDEV_XDP_ACT_NDO_XMIT |
> > +			   NETDEV_XDP_ACT_NDO_XMIT_SG);
> > +}
> > +
>=20
> Shouldn't these generate netlink notifications?

ack, I would say we need to add NETDEV_XDP_FEAT_CHANGE case in
netdev_genl_netdevice_event routine and maybe add a new
NETDEV_XDP_FEAT_CHANGE flag in netdev_cmd. What do you think?

Regards,
Lorenzo

--w+GUdlDdqYVq1hNu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY80iwAAKCRA6cBh0uS2t
rAxtAP9ZfJkB37hk72ekJNDpeCVLGZ9NJ+YCmn3/JWHaNxQTzQEAycDTiwQ0yNkk
GG1x89Gce/hWDOmYnA2ThF+j/KgquQo=
=vN6K
-----END PGP SIGNATURE-----

--w+GUdlDdqYVq1hNu--
