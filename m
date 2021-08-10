Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32D173E5E10
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 16:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239555AbhHJOes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 10:34:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:54730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239178AbhHJOes (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 10:34:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8C7060E9B;
        Tue, 10 Aug 2021 14:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628606065;
        bh=oQ/VZBKja9t/3FYjXT+fwYul2R+R/fZdM9SCN0q4XLg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mN53ePwtgs8yV8bi0iT/nw4K4upeEsMp8ScR+lG4uo5sO1eaL768o/Muh6FTEVdNT
         Jj91Cy0KN1kdFzYAGwyBOesS9/92ULtFWf2CS/HsWU37GlCzSey7POUY/OtmJu6zAN
         B7oUiOpNFGwqaKCqTQeHw2rGAnoXEgiJJ5WGgwYhXG2BvQLuEFDE/cDDdMzJTj349g
         lRfi/6VdCVgfraR+TOjXr8SKmMEpf99u9mmbyNx0YbJLHsB8GINUqWVzfPrOskIOsk
         j74Fg+ZpyVOJrhdtYzM/dNVQfr2Xo/3P8r58zzftXLMi5elGfCEMUrqaaPdM6GzorO
         YNQiY2ov30++w==
Date:   Tue, 10 Aug 2021 15:34:06 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: mscc: Fix non-GPL export of regmap APIs
Message-ID: <20210810143406.GC4704@sirena.org.uk>
References: <20210810123748.47871-1-broonie@kernel.org>
 <20210810125536.edr64jhzgr7rdnmd@skbuf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="7qSK/uQB79J36Y4o"
Content-Disposition: inline
In-Reply-To: <20210810125536.edr64jhzgr7rdnmd@skbuf>
X-Cookie: Who is John Galt?
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--7qSK/uQB79J36Y4o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 10, 2021 at 12:55:37PM +0000, Vladimir Oltean wrote:
> On Tue, Aug 10, 2021 at 01:37:48PM +0100, Mark Brown wrote:

> > The ocelot driver makes use of regmap, wrapping it with driver specific
> > operations that are thin wrappers around the core regmap APIs. These are
> > exported with EXPORT_SYMBOL, dropping the _GPL from the core regmap
> > exports which is frowned upon. Add _GPL suffixes to at least the APIs that
> > are doing register I/O.

> Stupid question: is this enough? We also have order-two symbols exported
> as non-GPL, which call one of {__ocelot_read_ix, __ocelot_write_ix,
> __ocelot_rmw_ix, ocelot_port_writel, ocelot_port_rmwl, ocelot_regfields_init,
> ocelot_regmap_init}, and therefore indirectly call regmap. In fact, I
> think that all symbols exported by ocelot do that.

Yes, that'd be much better I think - I have to confess I didn't look at
the driver in too much detail beyond these most obvious examples to
figure out how exactly they slotted in structurally.

--7qSK/uQB79J36Y4o
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmESjl4ACgkQJNaLcl1U
h9C81Af/TywMfTPfp+HQnN/as2GSg00ICmokLW5KfW8Buvty6oOdBnIJ9Inp/L9i
WalF2aTKAjSGdj6fotgAZXiX5w2oZlvZsziS2I3+dkyvrCVwi05Fn9qkLTEYEI/q
oLPm0HQnUt+7F2c3Ay/bU8Qr26/S1QpXVkW8Le7LmAp1QRYHdvDYAmZKSuQNr/ay
CT9Vk/0SjpxXjxXGBrfg7vcq3oqHOs/Hi8Um4sZiNWM3BAejCi5EAz2XDtvWVKG2
+93ER1ynOiKbczwYc4vbi1u3eOHY26jm0F/KHG4eahqi3MimqkssG50p1Fl+zrOW
OVUlWDW9mqmQRevIId2tZ39SgCO4Kw==
=9K/C
-----END PGP SIGNATURE-----

--7qSK/uQB79J36Y4o--
