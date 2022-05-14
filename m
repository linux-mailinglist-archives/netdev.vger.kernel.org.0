Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0FD7527391
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 21:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234760AbiENTAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 May 2022 15:00:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiENTAr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 May 2022 15:00:47 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8627727140
        for <netdev@vger.kernel.org>; Sat, 14 May 2022 12:00:45 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1npx0A-0002Iw-5u; Sat, 14 May 2022 21:00:30 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 1F5A97E3FA;
        Sat, 14 May 2022 19:00:29 +0000 (UTC)
Date:   Sat, 14 May 2022 21:00:28 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Chee Hou Ong <chee.houx.ong@intel.com>,
        Aman Kumar <aman.kumar@intel.com>,
        Pallavi Kumari <kumari.pallavi@intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH net 1/2] Revert "can: m_can: pci: use custom bit timings
 for Elkhart Lake"
Message-ID: <20220514190028.nlnof3rmmv5eczgj@pengutronix.de>
References: <20220513130819.386012-1-mkl@pengutronix.de>
 <20220513130819.386012-2-mkl@pengutronix.de>
 <20220513102145.748db22c@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="e6aordrod4avk3n3"
Content-Disposition: inline
In-Reply-To: <20220513102145.748db22c@kernel.org>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--e6aordrod4avk3n3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 13.05.2022 10:21:45, Jakub Kicinski wrote:
> On Fri, 13 May 2022 15:08:18 +0200 Marc Kleine-Budde wrote:
> > From: Jarkko Nikula <jarkko.nikula@linux.intel.com>
> >=20
> > This reverts commit 0e8ffdf3b86dfd44b651f91b12fcae76c25c453b.
> >=20
> > Commit 0e8ffdf3b86d ("can: m_can: pci: use custom bit timings for
> > Elkhart Lake") broke the test case using bitrate switching.
> >=20
> > | ip link set can0 up type can bitrate 500000 dbitrate 4000000 fd on
> > | ip link set can1 up type can bitrate 500000 dbitrate 4000000 fd on
> > | candump can0 &
> > | cangen can1 -I 0x800 -L 64 -e -fb \
> > |     -D 11223344deadbeef55667788feedf00daabbccdd44332211 -n 1 -v -v
> >=20
> > Above commit does everything correctly according to the datasheet.
> > However datasheet wasn't correct.
> >=20
> > I got confirmation from hardware engineers that the actual CAN
> > hardware on Intel Elkhart Lake is based on M_CAN version v3.2.0.
> > Datasheet was mirroring values from an another specification which was
> > based on earlier M_CAN version leading to wrong bit timings.
> >=20
> > Therefore revert the commit and switch back to common bit timings.
> >=20
> > Fixes: 0e8ffdf3b86d ("can: m_can: pci: use custom bit timings for Elkha=
rt Lake")
> > Link: https://lore.kernel.org/all/20220512124144.536850-1-jarkko.nikula=
@linux.intel.com
> > Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
> > Reported-by: Chee Hou Ong <chee.houx.ong@intel.com>
> > Reported-by: Aman Kumar <aman.kumar@intel.com>
> > Reported-by: Pallavi Kumari <kumari.pallavi@intel.com>
> > Cc: <stable@vger.kernel.org> # v5.16+
> > Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
>=20
> nit: the hash in the fixes tag should be:

Doh!

> Fixes: ea4c1787685d ("can: m_can: pci: use custom bit timings for Elkhart=
 Lake")
>=20
> Do you want to respin or is the can tree non-rebasable?

No - it's non-rebasable as soon as merged to net(-next) :)

Here's a new pull request with a adjusted Fixes tag.

| https://lore.kernel.org/all/20220514185742.407230-1-mkl@pengutronix.de

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--e6aordrod4avk3n3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmJ//EoACgkQrX5LkNig
0102Tgf/eU9UrKmJKVPOC+HAlGDtz+3GAfP/GnYcrRZu6ZhJj5rrK517vkJRSxSZ
gQBMtZLO1BFfmmFXw2S+1FMQNijgtR2Czd+N25oT34dTvNVGOOr6Q//NibQiy6BI
uJXMMZ/PG3fnGkjKtkA+/jAIXYBORGwyTbX49/UvFxpQ6Az14J3WJKuVFXmnccLv
kLr01GdjcVJ1d5YkWVy4IxTE6FhsyPNeL9Lv6KDp3p1fmiD8VJeU1X+y2PDBvuZh
pCTlW63zIVxXwZEXst83X2azrIyD3k4q9ROHszP8abxv9v9kfTnTo6KV5/cUg12+
PlcHGMdoK82piJUoP5mhBRfNk/7hGA==
=y4iW
-----END PGP SIGNATURE-----

--e6aordrod4avk3n3--
