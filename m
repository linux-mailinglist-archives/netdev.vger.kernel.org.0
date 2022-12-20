Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE9E46525A0
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 18:34:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233923AbiLTReM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 12:34:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbiLTReK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 12:34:10 -0500
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B7EA1A3B4;
        Tue, 20 Dec 2022 09:34:08 -0800 (PST)
Received: from wsk (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 5D9FB851EE;
        Tue, 20 Dec 2022 18:34:05 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1671557646;
        bh=e6i2o1JZsIOo4aNIzLcaOSiBPGTjt24suNHUWdBp7aQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CoMyUqCDMAq/4ooZ4MuAE5DWfyerc4wAkudLxyDp31y4O+ZK0C/+VAK8W0f1d3TCx
         8zvjr7agVBU+Zy+FVju7HdKZThNw4lggIJBAhCTx9hbtzRVuqfXim0uMl/Kby+hjxg
         rXSCBbSUpnnmufG+lTG2XVhvGRTSGMtnlHG3UoYsfAAbZRMAo+BTuCuD+vJgfW46E0
         KMVZqqejl5KVn1WGGnO19gjlyrjbHrFJbn5v8zwyx7KFYgKMrv/BT3s/1afY24V9Gb
         SFSCWSoufpEuW2uOuj+OOhMmmBIWdr9ZsInOLU3tZpGuZOy0iC9QwLI3nwiSGG15Vo
         5Qo/LL+0KHYiw==
Date:   Tue, 20 Dec 2022 18:33:59 +0100
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
Message-ID: <20221220183359.4b9cd95c@wsk>
In-Reply-To: <20221219130005.6e995cb0@wsk>
References: <20221215144536.3810578-1-lukma@denx.de>
        <4d16ffd327d193f8c1f7c40f968fda90a267348e.camel@gmail.com>
        <20221216140526.799bd82f@wsk>
        <CAKgT0Udm6s8Wib1dFp6f4yVhdMm62-4kjetYSucLr-Ruyg7-yg@mail.gmail.com>
        <20221219130005.6e995cb0@wsk>
Organization: denx.de
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/V55Prcsx6GdYTgrCs5T4fzE";
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

--Sig_/V55Prcsx6GdYTgrCs5T4fzE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Alexander,

> Hi Alexander,
>=20
> > On Fri, Dec 16, 2022 at 5:05 AM Lukasz Majewski <lukma@denx.de>
> > wrote: =20
> > >
> > > Hi Alexander,
> > >   =20
> > > > On Thu, 2022-12-15 at 15:45 +0100, Lukasz Majewski wrote:   =20
> > > > > Different Marvell DSA switches support different size of max
> > > > > frame bytes to be sent.
> > > > >
> > > > > For example mv88e6185 supports max 1632 bytes, which is now
> > > > > in-driver standard value. On the other hand - mv88e6250
> > > > > supports 2048 bytes.
> > > > >
> > > > > As this value is internal and may be different for each switch
> > > > > IC, new entry in struct mv88e6xxx_info has been added to store
> > > > > it.
> > > > >
> > > > > Signed-off-by: Lukasz Majewski <lukma@denx.de>
> > > > > ---
> > > > > Changes for v2:
> > > > > - Define max_frame_size with default value of 1632 bytes,
> > > > > - Set proper value for the mv88e6250 switch SoC (linkstreet)
> > > > > family ---
> > > > >  drivers/net/dsa/mv88e6xxx/chip.c | 13 ++++++++++++-
> > > > >  drivers/net/dsa/mv88e6xxx/chip.h |  1 +
> > > > >  2 files changed, 13 insertions(+), 1 deletion(-)
> > > > >
> > > > > diff --git a/drivers/net/dsa/mv88e6xxx/chip.c
> > > > > b/drivers/net/dsa/mv88e6xxx/chip.c index
> > > > > 2ca3cbba5764..7ae4c389ce50 100644 ---
> > > > > a/drivers/net/dsa/mv88e6xxx/chip.c +++
> > > > > b/drivers/net/dsa/mv88e6xxx/chip.c @@ -3093,7 +3093,9 @@
> > > > > static int mv88e6xxx_get_max_mtu(struct dsa_switch *ds, int
> > > > > port) if (chip->info->ops->port_set_jumbo_size) return 10240 -
> > > > > VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN; else if
> > > > > (chip->info->ops->set_max_frame_size)
> > > > > -           return 1632 - VLAN_ETH_HLEN - EDSA_HLEN -
> > > > > ETH_FCS_LEN;
> > > > > +           return (chip->info->max_frame_size  -
> > > > > VLAN_ETH_HLEN
> > > > > +                   - EDSA_HLEN - ETH_FCS_LEN);
> > > > > +
> > > > >     return 1522 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
> > > > >  }
> > > > >
> > > > >   =20
> > > >
> > > > Is there any specific reason for triggering this based on the
> > > > existance of the function call?   =20
> > >
> > > This was the original code in this driver.
> > >
> > > This value (1632 or 2048 bytes) is SoC (family) specific.
> > >
> > > By checking which device defines set_max_frame_size callback, I
> > > could fill the chip->info->max_frame_size with 1632 value.
> > >   =20
> > > > Why not just replace:
> > > >       else if (chip->info->ops->set_max_frame_size)
> > > > with:
> > > >       else if (chip->info->max_frame_size)
> > > >   =20
> > >
> > > I think that the callback check is a bit "defensive" approach ->
> > > 1522B is the default value and 1632 (or 10240 - jumbo) can be set
> > > only when proper callback is defined.
> > >   =20
> > > > Otherwise my concern is one gets defined without the other
> > > > leading to a future issue as 0 - extra headers will likely wrap
> > > > and while the return value may be a signed int, it is usually
> > > > stored in an unsigned int so it would effectively uncap the
> > > > MTU.   =20
> > >
> > > Please correct me if I misunderstood something:
> > >
> > > The problem is with new mv88eXXXX devices, which will not provide
> > > max_frame_size information to their chip->info struct?
> > >
> > > Or is there any other issue?   =20
> >=20
> > That was mostly my concern. I was adding a bit of my own defensive
> > programming in the event that somebody forgot to fill out the
> > chip->info. If nothing else it might make sense to add a check to
> > verify that the max_frame_size is populated before blindly using it.
> > So perhaps you could do something similar to the max_t approach I
> > had called out earlier but instead of applying it on the last case
> > you could apply it for the "set_max_frame_size" case with 1632
> > being the minimum and being overwritten by 2048 if it is set in
> > max_frame_size. =20
>=20
> I think that I shall add:
>=20
> else if (chip->info->ops->set_max_frame_size)
> 	return max_t(int, chip->info->max_frame_size, 1632) -
> (headers)
>=20
> So then the "default" value of 1632 will be overwritten by 2048 bytes.
>=20

Is this approach acceptable for you?

>=20
> Best regards,
>=20
> Lukasz Majewski
>=20
> --
>=20
> DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
> HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
> Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email:
> lukma@denx.de




Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/V55Prcsx6GdYTgrCs5T4fzE
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmOh8gcACgkQAR8vZIA0
zr0jRwf/YKx8sTurFMMsicIKIhMlAHQ+vcrCXDVACtJhUOm6FFluAbvXHsWiWo6S
XFA1gY7zDyD+H7v0G4nzLyxN8+VIK0P/GWGVrE4ghSShtbZoqKqm35PRYFf9F33Y
d8fuv4zzQGEO98ej/YwuLHjn+4TKu8jau67UiuEj1gAYKasD6n/FFOZ/PnCpLpbv
4B3ZAScS9SaH3cIJbJUPLpMlqs2wknNkibGx4EVzcyPmeEvBj4IcRqEE3Rt8bIO9
iuC2Uod8y5vb4Hf1RWHPGm95GMKSih9l67BRO/nkWhid5OH+KctbHtUBYR1bVKXa
UVGYI55ueXbamxbKxKV4fyXNpSWhqw==
=G6wU
-----END PGP SIGNATURE-----

--Sig_/V55Prcsx6GdYTgrCs5T4fzE--
