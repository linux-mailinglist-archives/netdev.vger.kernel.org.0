Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18F4D4F852A
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 18:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345824AbiDGQub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 12:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235633AbiDGQu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 12:50:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E49F326F5
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 09:48:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CF6361092
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 16:48:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F8FBC385A0;
        Thu,  7 Apr 2022 16:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649350101;
        bh=emknm+BJzUboS0DHI97XaW96SpT84KibWEcGsmKE0XY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OOp4MwKrxA6r8rtw+65pHGCaLTVGW7wOohyvnP3ZS+0VXTvw3iz+jGFvfNqnCJb8M
         mdtMiyP2VaUW6Er+WkR01dJdWsa//MbhH8PnSeJjl1i2aFsmKpaHikuvdUw35Klg34
         SuzegHNQ98P4JPpReaei2jWqLPxkDTuaiHnNh3irSEr1kSjEiKMx0RxiUT9EizOw5a
         C0nTkkwsTz4GwTRxunYNWtmBk+anlSwR2SUZ4SNLpIMXSPbP3OujMNBEl1NjhDBS+2
         mALXmCN9YLmh/IMntlmgq5le4Fe7on/YT+CpFWm90N4i8prVRCaudT0kRISgjpj3PR
         WkP+/JrbqT0gA==
Date:   Thu, 7 Apr 2022 18:48:17 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Joe Damato <jdamato@fastly.com>, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, thomas.petazzoni@bootlin.com,
        linux@armlinux.org.uk, jbrouer@redhat.com,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH net-next] net: mvneta: add support for page_pool_get_stats
Message-ID: <Yk8V0ULnY3paXFzd@lore-desk>
References: <e4a3bb0fb407ead607b85f7f041f24b586c8b99d.1649190493.git.lorenzo@kernel.org>
 <Yk2X6KPyeN3z7OUW@lunn.ch>
 <Yk2dhD2rjQQaF4Pc@lore-desk>
 <20220406230136.GA96269@fastly.com>
 <Yk4j4YCVuOLK/1uE@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="w7fp6ivjkCveE+Nh"
Content-Disposition: inline
In-Reply-To: <Yk4j4YCVuOLK/1uE@lunn.ch>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--w7fp6ivjkCveE+Nh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Wed, Apr 06, 2022 at 04:01:37PM -0700, Joe Damato wrote:
> > On Wed, Apr 06, 2022 at 04:02:44PM +0200, Lorenzo Bianconi wrote:
> > > > > +static void mvneta_ethtool_update_pp_stats(struct mvneta_port *p=
p,
> > > > > +					   struct page_pool_stats *stats)
> > > > > +{
> > > > > +	int i;
> > > > > +
> > > > > +	memset(stats, 0, sizeof(*stats));
> > > > > +	for (i =3D 0; i < rxq_number; i++) {
> > > > > +		struct page_pool *page_pool =3D pp->rxqs[i].page_pool;
> > > > > +		struct page_pool_stats pp_stats =3D {};
> > > > > +
> > > > > +		if (!page_pool_get_stats(page_pool, &pp_stats))
> > > > > +			continue;
> > > > > +
> > > > > +		stats->alloc_stats.fast +=3D pp_stats.alloc_stats.fast;
> > > > > +		stats->alloc_stats.slow +=3D pp_stats.alloc_stats.slow;
> > > > > +		stats->alloc_stats.slow_high_order +=3D
> > > > > +			pp_stats.alloc_stats.slow_high_order;
> > > > > +		stats->alloc_stats.empty +=3D pp_stats.alloc_stats.empty;
> > > > > +		stats->alloc_stats.refill +=3D pp_stats.alloc_stats.refill;
> > > > > +		stats->alloc_stats.waive +=3D pp_stats.alloc_stats.waive;
> > > > > +		stats->recycle_stats.cached +=3D pp_stats.recycle_stats.cached;
> > > > > +		stats->recycle_stats.cache_full +=3D
> > > > > +			pp_stats.recycle_stats.cache_full;
> > > > > +		stats->recycle_stats.ring +=3D pp_stats.recycle_stats.ring;
> > > > > +		stats->recycle_stats.ring_full +=3D
> > > > > +			pp_stats.recycle_stats.ring_full;
> > > > > +		stats->recycle_stats.released_refcnt +=3D
> > > > > +			pp_stats.recycle_stats.released_refcnt;
> > > >=20
> > > > Am i right in saying, these are all software stats? They are also
> > > > generic for any receive queue using the page pool?
> > >=20
> > > yes, these stats are accounted by the kernel so they are sw stats, bu=
t I guess
> > > xdp ones are sw as well, right?
> > >=20
> > > >=20
> > > > It seems odd the driver is doing the addition here. Why not pass st=
ats
> > > > into page_pool_get_stats()? That will make it easier when you add
> > > > additional statistics?
> > > >=20
> > > > I'm also wondering if ethtool -S is even the correct API. It should=
 be
> > > > for hardware dependent statistics, those which change between
> > > > implementations. Where as these statistics should be generic. Maybe
> > > > they should be in /sys/class/net/ethX/statistics/ and the driver
> > > > itself is not even involved, the page pool code implements it?
> > >=20
> > > I do not have a strong opinion on it, but I can see an issue for some=
 drivers
> > > (e.g. mvpp2 iirc) where page_pools are not specific for each net_devi=
ce but are shared
> > > between multiple ports, so maybe it is better to allow the driver to =
decide how
> > > to report them. What do you think?
> >=20
> > When I did the implementation of this API the feedback was essentially
> > that the drivers should be responsible for reporting the stats of their
> > active page_pool structures; this is why the first driver to use this
> > (mlx5) uses the API and outputs the stats via ethtool -S.
> >=20
> > I have no strong preference, either, but I think that exposing the stats
> > via an API for the drivers to consume is less tricky; the driver knows
> > which page_pools are active and which pool is associated with which
> > RX-queue, and so on.
> >=20
> > If there is general consensus for a different approach amongst the
> > page_pool maintainers, I am happy to implement it.
>=20
> If we keep it in the drivers, it would be good to try to move some of
> the code into the core, to keep cut/paste to a minimum. We want the
> same strings for every driver for example, and it looks like it is
> going to be hard to add new counters, since you will need to touch
> every driver using the page pool.
>=20
> Maybe even consider adding ETH_SS_PAGE_POOL. You can then put
> page_pool_get_sset_count() and page_pool_get_sset_strings() as helpers
> in the core, and the driver just needs to implement the get_stats()
> part, again with a helper in the core which can do most of the work.

ack, fine. I will share a RFC patch to continue the discussion.

Regards,
Lorenzo

>=20
>        Andrew

--w7fp6ivjkCveE+Nh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYk8V0QAKCRA6cBh0uS2t
rGFWAQD5yvDcNU4r8IkxWBUSJmjHexLdznuxI2DYTvhG3anFCwD/TjfhhV1i1zJw
QAPUPhc8A+6xK/xM0W9mwwonor4t8w0=
=qo0o
-----END PGP SIGNATURE-----

--w7fp6ivjkCveE+Nh--
