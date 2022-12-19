Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF43650B0F
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 13:01:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231994AbiLSMBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 07:01:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231686AbiLSMA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 07:00:59 -0500
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F924FCFE;
        Mon, 19 Dec 2022 04:00:14 -0800 (PST)
Received: from wsk (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 13364839D5;
        Mon, 19 Dec 2022 13:00:12 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1671451212;
        bh=7Tc08O5/QSZU9JKvbwkVI7bh4NdF+iLSTXKKDKKb9+I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FIrpeZz0t4AmQgZz1wwK6gVNwP0i0bnsweCmFKA8xLVCdqRCkB4wNKYDigrokRJHv
         eqL8iXcu7SRq1bJGFy1Gyfzj1+p1Lc6qwC+ImrMOOX6HNgiYX3BBVOKXR+btocEDtQ
         +JgtvF/ioC01E+HujxsDwrHEYeCuAqu1oRIM4RdjRo/7lc4HNpaX1ZWJ5DZOaHnWOD
         yQOVNi6BcP0r/TLVw7kRzQ4huAInstETGDTkP8P3iCz4WTdfSlr0yVHd9x1tAS5ix/
         v8W5pgMhtPiXcOPUhFyqYA+NkexojHdLxzbXDYJm1IGPt6pOBgHjm/XmEaFF+7zXoC
         2HgBnd/JKEfFw==
Date:   Mon, 19 Dec 2022 13:00:05 +0100
From:   Lukasz Majewski <lukma@denx.de>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] dsa: marvell: Provide per device information
 about max frame size
Message-ID: <20221219130005.6e995cb0@wsk>
In-Reply-To: <CAKgT0Udm6s8Wib1dFp6f4yVhdMm62-4kjetYSucLr-Ruyg7-yg@mail.gmail.com>
References: <20221215144536.3810578-1-lukma@denx.de>
        <4d16ffd327d193f8c1f7c40f968fda90a267348e.camel@gmail.com>
        <20221216140526.799bd82f@wsk>
        <CAKgT0Udm6s8Wib1dFp6f4yVhdMm62-4kjetYSucLr-Ruyg7-yg@mail.gmail.com>
Organization: denx.de
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/7XCBTm3tbk2vu6GHzeVhVz3";
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

--Sig_/7XCBTm3tbk2vu6GHzeVhVz3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Alexander,

> On Fri, Dec 16, 2022 at 5:05 AM Lukasz Majewski <lukma@denx.de> wrote:
> >
> > Hi Alexander,
> > =20
> > > On Thu, 2022-12-15 at 15:45 +0100, Lukasz Majewski wrote: =20
> > > > Different Marvell DSA switches support different size of max
> > > > frame bytes to be sent.
> > > >
> > > > For example mv88e6185 supports max 1632 bytes, which is now
> > > > in-driver standard value. On the other hand - mv88e6250 supports
> > > > 2048 bytes.
> > > >
> > > > As this value is internal and may be different for each switch
> > > > IC, new entry in struct mv88e6xxx_info has been added to store
> > > > it.
> > > >
> > > > Signed-off-by: Lukasz Majewski <lukma@denx.de>
> > > > ---
> > > > Changes for v2:
> > > > - Define max_frame_size with default value of 1632 bytes,
> > > > - Set proper value for the mv88e6250 switch SoC (linkstreet)
> > > > family ---
> > > >  drivers/net/dsa/mv88e6xxx/chip.c | 13 ++++++++++++-
> > > >  drivers/net/dsa/mv88e6xxx/chip.h |  1 +
> > > >  2 files changed, 13 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/drivers/net/dsa/mv88e6xxx/chip.c
> > > > b/drivers/net/dsa/mv88e6xxx/chip.c index
> > > > 2ca3cbba5764..7ae4c389ce50 100644 ---
> > > > a/drivers/net/dsa/mv88e6xxx/chip.c +++
> > > > b/drivers/net/dsa/mv88e6xxx/chip.c @@ -3093,7 +3093,9 @@ static
> > > > int mv88e6xxx_get_max_mtu(struct dsa_switch *ds, int port) if
> > > > (chip->info->ops->port_set_jumbo_size) return 10240 -
> > > > VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN; else if
> > > > (chip->info->ops->set_max_frame_size)
> > > > -           return 1632 - VLAN_ETH_HLEN - EDSA_HLEN -
> > > > ETH_FCS_LEN;
> > > > +           return (chip->info->max_frame_size  - VLAN_ETH_HLEN
> > > > +                   - EDSA_HLEN - ETH_FCS_LEN);
> > > > +
> > > >     return 1522 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
> > > >  }
> > > >
> > > > =20
> > >
> > > Is there any specific reason for triggering this based on the
> > > existance of the function call? =20
> >
> > This was the original code in this driver.
> >
> > This value (1632 or 2048 bytes) is SoC (family) specific.
> >
> > By checking which device defines set_max_frame_size callback, I
> > could fill the chip->info->max_frame_size with 1632 value.
> > =20
> > > Why not just replace:
> > >       else if (chip->info->ops->set_max_frame_size)
> > > with:
> > >       else if (chip->info->max_frame_size)
> > > =20
> >
> > I think that the callback check is a bit "defensive" approach ->
> > 1522B is the default value and 1632 (or 10240 - jumbo) can be set
> > only when proper callback is defined.
> > =20
> > > Otherwise my concern is one gets defined without the other
> > > leading to a future issue as 0 - extra headers will likely wrap
> > > and while the return value may be a signed int, it is usually
> > > stored in an unsigned int so it would effectively uncap the MTU. =20
> >
> > Please correct me if I misunderstood something:
> >
> > The problem is with new mv88eXXXX devices, which will not provide
> > max_frame_size information to their chip->info struct?
> >
> > Or is there any other issue? =20
>=20
> That was mostly my concern. I was adding a bit of my own defensive
> programming in the event that somebody forgot to fill out the
> chip->info. If nothing else it might make sense to add a check to
> verify that the max_frame_size is populated before blindly using it.
> So perhaps you could do something similar to the max_t approach I had
> called out earlier but instead of applying it on the last case you
> could apply it for the "set_max_frame_size" case with 1632 being the
> minimum and being overwritten by 2048 if it is set in max_frame_size.

I think that I shall add:

else if (chip->info->ops->set_max_frame_size)
	return max_t(int, chip->info->max_frame_size, 1632) - (headers)

So then the "default" value of 1632 will be overwritten by 2048 bytes.


Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/7XCBTm3tbk2vu6GHzeVhVz3
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmOgUkUACgkQAR8vZIA0
zr0IIgf8DFwX5ALMURFb3pBxRfxtz7QWbOAhFlH5dZMui438mh4Yt8vRsW05YSm0
JT82EGxvq+o9XaCZh+7zIRtXa/gRJwOBnIYZ3Ouz/JDVAkLPd/qEbeilIlNVw9YU
apvXST3vFR8O6GxwoT7zZhT/rK6lVhIzhmpEZXzuIOXXPKW26aQL+llHeTAN1/ha
rJ9MS0bPgScyUQzZb/SbqhgCrDPPk8GfO7bhOQl8/8wzRiwmEqeTZFH72bXbIh60
mMFJFzXeigGRoAia3R/zioa4er7/6licKMhKiUyeOM4hMjxn5FKQteCnJVhsdCAZ
yHcrIXTWMYjtg/WGeUYoWohcD9DliQ==
=gxDE
-----END PGP SIGNATURE-----

--Sig_/7XCBTm3tbk2vu6GHzeVhVz3--
