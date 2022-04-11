Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79B2F4FBC03
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 14:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239856AbiDKM3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 08:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236026AbiDKM3a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 08:29:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38D0B286EE
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 05:27:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F00C1B815B4
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 12:27:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F7A0C385AA;
        Mon, 11 Apr 2022 12:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649680034;
        bh=8FDowP1jHJ9zt+jOMIHqzyUvAcYkylg3zS9ZLWM1YhY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F+t81CXY4DvvdsiI0X0i6hICiULueVTVSSdpIfodNUCblgAXIYAl9zE7yOEOO826/
         jvibwU8fb/FHeOTPKz9IyuIGAlvMrRVqS7J50rX2QFNcZj+IVAofgUG4eslijNgICY
         zVD+eSL1qEF039awRNciOf8KDEWQ4nzH5M7wdBOVZke18dWotu7OFceimhnCFWzFgM
         G/Uj6vLZi7tyGwmF3NzjzhfbzrTfE6spi/PFF8M7ckIIm+4eB5633kvl0Vv+V2qSYq
         Oerg2H5XiW9yUr9/66c+b77qsgX43ZKjdOLAVuHRXOjSe7j3IZLMYbM3Xz65h4pTHu
         4sHHRMmN4kNPw==
Date:   Mon, 11 Apr 2022 14:27:10 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        thomas.petazzoni@bootlin.com, linux@armlinux.org.uk,
        jbrouer@redhat.com, ilias.apalodimas@linaro.org, jdamato@fastly.com
Subject: Re: [PATCH v3 net-next 1/2] net: page_pool: introduce ethtool stats
Message-ID: <YlQenv0v/7munOfN@lore-desk>
References: <cover.1649528984.git.lorenzo@kernel.org>
 <628c0a6d9bdbc547c93fcd4ae2e84d08af7bc8e1.1649528984.git.lorenzo@kernel.org>
 <YlQXl2a6vctIxXuP@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="o7ylXkfsizR48TZY"
Content-Disposition: inline
In-Reply-To: <YlQXl2a6vctIxXuP@lunn.ch>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--o7ylXkfsizR48TZY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> > diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> > index ea5fb70e5101..94b2d666db03 100644
> > --- a/include/net/page_pool.h
> > +++ b/include/net/page_pool.h
> > @@ -117,6 +117,10 @@ struct page_pool_stats {
> >  	struct page_pool_recycle_stats recycle_stats;
> >  };
> > =20
> > +int page_pool_ethtool_stats_get_count(void);
> > +u8 *page_pool_ethtool_stats_get_strings(u8 *data);
> > +u64 *page_pool_ethtool_stats_get(u64 *data, struct page_pool_stats *st=
ats);
> > +
> >  /*
> >   * Drivers that wish to harvest page pool stats and report them to use=
rs
> >   * (perhaps via ethtool, debugfs, or another mechanism) can allocate a
>=20
> You could also add stub function here for when the page pool
> statistics are disabled. We can then avoid all the messy #ifdef in the
> drivers.
>=20
> > +u64 *page_pool_ethtool_stats_get(u64 *data, struct page_pool_stats *st=
ats)
> > +{
> > +	int i;
> > +
> > +	for (i =3D 0; i < ARRAY_SIZE(pp_stats); i++) {
> > +		*data++ =3D stats->alloc_stats.fast;
> > +		*data++ =3D stats->alloc_stats.slow;
> > +		*data++ =3D stats->alloc_stats.slow_high_order;
> > +		*data++ =3D stats->alloc_stats.empty;
> > +		*data++ =3D stats->alloc_stats.refill;
> > +		*data++ =3D stats->alloc_stats.waive;
> > +		*data++ =3D stats->recycle_stats.cached;
> > +		*data++ =3D stats->recycle_stats.cache_full;
> > +		*data++ =3D stats->recycle_stats.ring;
> > +		*data++ =3D stats->recycle_stats.ring_full;
> > +		*data++ =3D stats->recycle_stats.released_refcnt;
> > +	}
> > +
> > +	return data;
>=20
> What is the purpose of the loop?

ops sorry, you are right. I will fix it.

Regards,
Lorenzo

>=20
>      Andrew

--o7ylXkfsizR48TZY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYlQengAKCRA6cBh0uS2t
rHHXAQCZ56kdoaCa4cgqaXfq7KFZJHOo0M99sp5foaDXCU6/fAD/RB6/W6bUC0hq
Z/VqlbzuvKsIIyD8DOPHNZhRjMuLrww=
=nbrb
-----END PGP SIGNATURE-----

--o7ylXkfsizR48TZY--
