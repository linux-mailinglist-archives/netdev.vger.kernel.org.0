Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F20664F65BA
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 18:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237725AbiDFQnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 12:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238653AbiDFQnD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 12:43:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FAA62D0FFE
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 07:02:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23FBA617CC
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 14:02:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0210EC385A3;
        Wed,  6 Apr 2022 14:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649253768;
        bh=uzUWupfh+5CFkIN8O1pne0u/KjQkA/rfqBh0qD+Lpv0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ltfRsfCnIW7r/Ib5Y42iDgDYsM6tnrhFOFobhPiuL6NIFOeyZHFiQwcIENf2ngLJn
         lwdQyRqZ0gUUao3+Tl2OMT2RLzEwPAcZVWGqs57eCiDgq4pWTtnHqdizdZQxytfujN
         PJ6n7ODgv/hW9KjOvXBWIpbeuU4SJSo/iiuPytEFcwyNMnsVTm2JKYm1+yIXQLFaxM
         HCGBJOEFp8vp83kwOEgTb7+fJiT/dnCKAbRY3F7UHeWVzMAu+oeubmIIEVxIHGLEfB
         q8accJLmBinsWnNGAQccW+5xGrBz6MHdXWwgcFJqhrf3oBNzkja4ofakywOwAhsGiV
         tclF+obeo+E1g==
Date:   Wed, 6 Apr 2022 16:02:44 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        thomas.petazzoni@bootlin.com, linux@armlinux.org.uk,
        jbrouer@redhat.com, ilias.apalodimas@linaro.org, jdamato@fastly.com
Subject: Re: [PATCH net-next] net: mvneta: add support for page_pool_get_stats
Message-ID: <Yk2dhD2rjQQaF4Pc@lore-desk>
References: <e4a3bb0fb407ead607b85f7f041f24b586c8b99d.1649190493.git.lorenzo@kernel.org>
 <Yk2X6KPyeN3z7OUW@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="3OL8aaSaBF9lPCU0"
Content-Disposition: inline
In-Reply-To: <Yk2X6KPyeN3z7OUW@lunn.ch>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--3OL8aaSaBF9lPCU0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> > +static void mvneta_ethtool_update_pp_stats(struct mvneta_port *pp,
> > +					   struct page_pool_stats *stats)
> > +{
> > +	int i;
> > +
> > +	memset(stats, 0, sizeof(*stats));
> > +	for (i =3D 0; i < rxq_number; i++) {
> > +		struct page_pool *page_pool =3D pp->rxqs[i].page_pool;
> > +		struct page_pool_stats pp_stats =3D {};
> > +
> > +		if (!page_pool_get_stats(page_pool, &pp_stats))
> > +			continue;
> > +
> > +		stats->alloc_stats.fast +=3D pp_stats.alloc_stats.fast;
> > +		stats->alloc_stats.slow +=3D pp_stats.alloc_stats.slow;
> > +		stats->alloc_stats.slow_high_order +=3D
> > +			pp_stats.alloc_stats.slow_high_order;
> > +		stats->alloc_stats.empty +=3D pp_stats.alloc_stats.empty;
> > +		stats->alloc_stats.refill +=3D pp_stats.alloc_stats.refill;
> > +		stats->alloc_stats.waive +=3D pp_stats.alloc_stats.waive;
> > +		stats->recycle_stats.cached +=3D pp_stats.recycle_stats.cached;
> > +		stats->recycle_stats.cache_full +=3D
> > +			pp_stats.recycle_stats.cache_full;
> > +		stats->recycle_stats.ring +=3D pp_stats.recycle_stats.ring;
> > +		stats->recycle_stats.ring_full +=3D
> > +			pp_stats.recycle_stats.ring_full;
> > +		stats->recycle_stats.released_refcnt +=3D
> > +			pp_stats.recycle_stats.released_refcnt;
>=20
> Am i right in saying, these are all software stats? They are also
> generic for any receive queue using the page pool?

yes, these stats are accounted by the kernel so they are sw stats, but I gu=
ess
xdp ones are sw as well, right?

>=20
> It seems odd the driver is doing the addition here. Why not pass stats
> into page_pool_get_stats()? That will make it easier when you add
> additional statistics?
>=20
> I'm also wondering if ethtool -S is even the correct API. It should be
> for hardware dependent statistics, those which change between
> implementations. Where as these statistics should be generic. Maybe
> they should be in /sys/class/net/ethX/statistics/ and the driver
> itself is not even involved, the page pool code implements it?

I do not have a strong opinion on it, but I can see an issue for some drive=
rs
(e.g. mvpp2 iirc) where page_pools are not specific for each net_device but=
 are shared
between multiple ports, so maybe it is better to allow the driver to decide=
 how
to report them. What do you think?

Regards,
Lorenzo

>=20
>        Andrew

--3OL8aaSaBF9lPCU0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYk2dhAAKCRA6cBh0uS2t
rA31AQDsf9jnfVWTP/UF9XIR8+01vCUPXyZdcIqbuD8XVp1KhQD/XKWH3mOUWcN8
VfDMoKolRyxsIFSXxxaqN9fGvy2X9Qk=
=a/RR
-----END PGP SIGNATURE-----

--3OL8aaSaBF9lPCU0--
