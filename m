Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADF0564EBD5
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 14:06:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbiLPNGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 08:06:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbiLPNFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 08:05:47 -0500
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DACF725EE;
        Fri, 16 Dec 2022 05:05:38 -0800 (PST)
Received: from wsk (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id A4C9384881;
        Fri, 16 Dec 2022 14:05:36 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1671195937;
        bh=v2hyP2ZH/dKnNRKXD+eheCejY2sZlWVOdtlMHVrs2lc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=zpUCmv+f/PKfpiFBdXAbepeTZPQkKaPxD9EZ0X+idM5hgFRm7rxDKL34Pi5ltGvQA
         cvBcm0JaqHVGB2/JhQHNXWTkfCztmUXxM/7wh718ahkBri1wjPAwendW+GdXs4qNfc
         LNfl/7E8zaOtBWy1cng1X/g4oTYySgTLUwJepragKQxvP+AtBEo8e32Od++lNbULkU
         lF0z1QFdHGSqHFlHzQjng1siEXd7EQ6dvkqGwaorFyP6S01BUGGU5KmfkMRl2pJV7F
         s7iI2rPBO01oKfdFi1QQdisv5VQ7m1k2W9+DfF0X7wR3YZyQUKdPc2bF0KiMWxH+xV
         GIPcYDIx4A+SA==
Date:   Fri, 16 Dec 2022 14:05:26 +0100
From:   Lukasz Majewski <lukma@denx.de>
To:     Alexander H Duyck <alexander.duyck@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] dsa: marvell: Provide per device information
 about max frame size
Message-ID: <20221216140526.799bd82f@wsk>
In-Reply-To: <4d16ffd327d193f8c1f7c40f968fda90a267348e.camel@gmail.com>
References: <20221215144536.3810578-1-lukma@denx.de>
        <4d16ffd327d193f8c1f7c40f968fda90a267348e.camel@gmail.com>
Organization: denx.de
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/nCzLGEgU8x4RN6D+MU=naZZ";
 protocol="application/pgp-signature"; micalg=pgp-sha512
X-Virus-Scanned: clamav-milter 0.103.6 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/nCzLGEgU8x4RN6D+MU=naZZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Alexander,

> On Thu, 2022-12-15 at 15:45 +0100, Lukasz Majewski wrote:
> > Different Marvell DSA switches support different size of max frame
> > bytes to be sent.
> >=20
> > For example mv88e6185 supports max 1632 bytes, which is now
> > in-driver standard value. On the other hand - mv88e6250 supports
> > 2048 bytes.
> >=20
> > As this value is internal and may be different for each switch IC,
> > new entry in struct mv88e6xxx_info has been added to store it.
> >=20
> > Signed-off-by: Lukasz Majewski <lukma@denx.de>
> > ---
> > Changes for v2:
> > - Define max_frame_size with default value of 1632 bytes,
> > - Set proper value for the mv88e6250 switch SoC (linkstreet) family
> > ---
> >  drivers/net/dsa/mv88e6xxx/chip.c | 13 ++++++++++++-
> >  drivers/net/dsa/mv88e6xxx/chip.h |  1 +
> >  2 files changed, 13 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/net/dsa/mv88e6xxx/chip.c
> > b/drivers/net/dsa/mv88e6xxx/chip.c index 2ca3cbba5764..7ae4c389ce50
> > 100644 --- a/drivers/net/dsa/mv88e6xxx/chip.c
> > +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> > @@ -3093,7 +3093,9 @@ static int mv88e6xxx_get_max_mtu(struct
> > dsa_switch *ds, int port) if (chip->info->ops->port_set_jumbo_size)
> >  		return 10240 - VLAN_ETH_HLEN - EDSA_HLEN -
> > ETH_FCS_LEN; else if (chip->info->ops->set_max_frame_size)
> > -		return 1632 - VLAN_ETH_HLEN - EDSA_HLEN -
> > ETH_FCS_LEN;
> > +		return (chip->info->max_frame_size  - VLAN_ETH_HLEN
> > +			- EDSA_HLEN - ETH_FCS_LEN);
> > +
> >  	return 1522 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
> >  }
> >=20
> >  =20
>=20
> Is there any specific reason for triggering this based on the
> existance of the function call?=20

This was the original code in this driver.

This value (1632 or 2048 bytes) is SoC (family) specific.

By checking which device defines set_max_frame_size callback, I could
fill the chip->info->max_frame_size with 1632 value.

> Why not just replace:
> 	else if (chip->info->ops->set_max_frame_size)
> with:
> 	else if (chip->info->max_frame_size)
>=20

I think that the callback check is a bit "defensive" approach -> 1522B
is the default value and 1632 (or 10240 - jumbo) can be set only when
proper callback is defined.

> Otherwise my concern is one gets defined without the other leading to
> a future issue as 0 - extra headers will likely wrap and while the
> return value may be a signed int, it is usually stored in an unsigned
> int so it would effectively uncap the MTU.

Please correct me if I misunderstood something:

The problem is with new mv88eXXXX devices, which will not provide
max_frame_size information to their chip->info struct?

Or is there any other issue?

>=20
> Actually you could take this one step further since all values should
> be 1522 or greater you could just drop the else/if and replace the
> last line with "max_t(int, chip->info->max_frame_size, 1522) -
> (headers)".

This would be possible, yes.

However, then we will not check if the proper callback (e.g.
chip->info->ops->set_max_frame_size) is available for specific SoC.

If this is OK for maintainers for this driver, then I don't mind.


Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/nCzLGEgU8x4RN6D+MU=naZZ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmOcbRcACgkQAR8vZIA0
zr38sggAoqoz/XJ1GyUjOFPHF9eVrTISta2YQ/2HM9q8L5hN3Hkh32xkYCI/62HO
OsoE2qrYUMLsaa0ei0qu6Qv5NnUBEpazOt6XcMFoyawmUjAZdvboxGO7eFZoFd9J
hk5kcJBTdXEHDEDsYY7ynpJIbHDGKhYj2uvGr9fRR7Lx4xfCOIZ7G5hc49HGS7y5
lBJuQxhmLCVwUiQmCANSWaeuQfHnldehxrS7gdrEkbMIlT+jVnaQ9G+z2mm0UjA0
K+euWcWwgDosk/j8KP/XU1Gw6i1hiMG/CyiK3z7l7iFC/F/7HjPR0iclzvCpU+PI
vDR1hTdvFTyvphpaQyaZyk7d8C4a6Q==
=tt9B
-----END PGP SIGNATURE-----

--Sig_/nCzLGEgU8x4RN6D+MU=naZZ--
