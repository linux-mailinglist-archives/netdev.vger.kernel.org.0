Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF7B6B4342
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 15:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231975AbjCJOMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 09:12:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231733AbjCJOLs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 09:11:48 -0500
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 916B01194C1;
        Fri, 10 Mar 2023 06:11:02 -0800 (PST)
Received: from wsk (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 28ADE85F3E;
        Fri, 10 Mar 2023 15:10:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1678457459;
        bh=AOCuZzLPvux7c3tArEIyZ8PiULFhzIkISJCzFgahT4E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uJzVvzhq1+N3Nv4sdmJi2Lc9j4e9GyFbF4aFqcetdKldRTCCNJ6AC8OX+BNH9ojLn
         w5FcXyjF+zU6PjeQlUlkTV0F3BcToqejVfPaeikRR/itrJvT3riaQGIsrMwjKK0VMJ
         Xa/P6tZZOZ35YNsgE7ciq0gBNc8nZ+J9JnVXX1TSIWrXECxQ6nT1XINs1Ms6rGXQKa
         j05iwN9TgWkK7Fxe+PiJERMxGacRx2MDDU1ZhY2342cSIEXDYw30pye8sv0EvJr72o
         P9OykStj8Bq0SnV1XMtvbnsOZcu5eONWghEGhxnDgr1IExtjEBaZQkLNS/y7FJMv61
         oJlu+yZnDLixw==
Date:   Fri, 10 Mar 2023 15:10:52 +0100
From:   Lukasz Majewski <lukma@denx.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Russell King <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] dsa: marvell: Provide per device information about
 max frame size
Message-ID: <20230310151052.7bc677e9@wsk>
In-Reply-To: <20230310133651.pfqldx6jdgssbe54@skbuf>
References: <20230309125421.3900962-1-lukma@denx.de>
        <20230309125421.3900962-2-lukma@denx.de>
        <20230310120235.2cjxauvqxyei45li@skbuf>
        <20230310141719.7f691b45@wsk>
        <20230310133651.pfqldx6jdgssbe54@skbuf>
Organization: denx.de
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/66KvUnqbJfOyKPuGiz=LZXS";
 protocol="application/pgp-signature"; micalg=pgp-sha512
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/66KvUnqbJfOyKPuGiz=LZXS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Vladimir,

> On Fri, Mar 10, 2023 at 02:17:19PM +0100, Lukasz Majewski wrote:
> > > > For example mv88e6185 supports max 1632 bytes, which is now
> > > > in-driver standard value.   =20
> > >=20
> > > What is the criterion based on which 1632 is the "in-driver
> > > standard value"? =20
> >=20
> > It comes from the documentation I suppose. Moreover, this might be
> > the the "first" used value when set_max_mtu callback was
> > introduced. =20
>=20
> I'm not playing dumb, I just don't understand what is meant by
> "in-driver standard value". Is it the return value of
> mv88e6xxx_get_max_mtu() for the MV88E6185 chip?

The 1632 is a value from added early switch IC to this driver.

Then the get_max_mtu function was extended to support jumbo frames.

And the extension was based on having the .set_max_frame_size defined
in *_ops structure.

> Because I understood
> it to be somehow the value returned by default, for chips which don't
> have a way to change the MTU (because of the "standard" word).
>=20

Probably the "standard" shall be replaced above - it might be
misleading. "Default" would be better.

> > > > On the other hand - mv88e6250 supports 2048 bytes.   =20
> > >=20
> > > What you mean to suggest here is that, using the current
> > > classification from mv88e6xxx_get_max_mtu(), mv88e6250 falls into
> > > the "none of the above" bucket, for which the driver returns 1522
> > > - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN // 1492. But it truly
> > > supports a maximum frame length of 2048, per your research.
> > >  =20
> >=20
> > And this cannot be easily fixed.
> >=20
> > I could just provide callback to .set_max_frame_size in
> > mv88e6250_ops and the mv88e6250 would use 1632 bytes which would
> > prevent errors.
> >=20
> > However, when I dig deeper - it turned out that this value is
> > larger. And hence I wanted to do it in "right way". =20
>=20
> Correct, I'm not debating this. I'm just saying, as a reader of this
> patch set in linear order, that the justification is not obvious.
>=20
> > > I have also noticed that you have not acted upon my previous
> > > review comment:
> > > https://patchwork.kernel.org/project/netdevbpf/patch/20230106101651.1=
137755-1-lukma@denx.de/
> > >=20
> > > | 1522 - 30 =3D 1492.
> > > |=20
> > > | I don't believe that there are switches which don't support the
> > > standard | MTU of 1500 ?!
> > > |=20
> > > | >  		.port_base_addr =3D 0x10,
> > > | >  		.phy_base_addr =3D 0x0,
> > > | >  		.global1_addr =3D 0x1b,
> > > |=20
> > > | Note that I see this behavior isn't new. But I've simulated it,
> > > and it | will produce the following messages on probe:
> > > |=20
> > > | [    7.425752] mscc_felix 0000:00:00.5 swp0 (uninitialized): PHY
> > > [0000:00:00.3:10] driver [Microsemi GE VSC8514 SyncE] (irq=3DPOLL)
> > > | [ 7.437516] mscc_felix 0000:00:00.5: nonfatal error -34 setting
> > > MTU to 1500 on port 0 | [    7.588585] mscc_felix 0000:00:00.5
> > > swp1 (uninitialized): PHY [0000:00:00.3:11] driver [Microsemi GE
> > > VSC8514 SyncE] (irq=3DPOLL) | [    7.600433] mscc_felix
> > > 0000:00:00.5: nonfatal error -34 setting MTU to 1500 on port 1 |
> > > [    7.752613] mscc_felix 0000:00:00.5 swp2 (uninitialized): PHY
> > > [0000:00:00.3:12] driver [Microsemi GE VSC8514 SyncE] (irq=3DPOLL)
> > > | [    7.764457] mscc_felix 0000:00:00.5: nonfatal error -34
> > > setting MTU to 1500 on port 2 | [ 7.900771] mscc_felix
> > > 0000:00:00.5 swp3 (uninitialized): PHY [0000:00:00.3:13] driver
> > > [Microsemi GE VSC8514 SyncE] (irq=3DPOLL) | [ 7.912501] mscc_felix
> > > 0000:00:00.5: nonfatal error -34 setting MTU to 1500 on port 3 |
> > > | I wonder, shouldn't we first fix that, and apply this patch set
> > > afterwards?
> > >=20
> > > I guess I will have to fix this now, since you haven't done it. =20
> >=20
> > I do agree with Russel's reply here. =20
>=20
> It's possible that Russell might have slightly misunderstood my quoted
> reply here, because he said something about a PHY.
>=20
> > Moreover, as 6250 and 6220 also have max frame size equal to 2048
> > bytes, this would be fixed in v6 after getting the "validation"
> > function run. =20
>=20
> The problem with this kind of fix is that it should go to the "net"
> tree; it removes a user-visible warning that could have been avoided.
>=20
> OTOH, the kind of "fix" for 6250 and 6220 is different. It is
> sub-optimal use of hardware capabilities. That classifies as net-next
> material.
>=20
> The 2 go to different kernel branches.
>=20

As I said - v6 fixes it in the way which Russel proposed. I also do
like this approach, so to avoid "wasting effort" I would opt for having
this fix in this patchset.

(And I hope that we will finish work on it before MW closes).

> > This is the "patch 4" in the comment sent by Russel (to fix stuff
> > which is already broken, but it has been visible after running the
> > validation code):
> >=20
> > https://lists.openwall.net/netdev/2023/03/09/233 =20
>=20
> I will get there.. eventually.




Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/66KvUnqbJfOyKPuGiz=LZXS
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmQLOmwACgkQAR8vZIA0
zr0SdggAnlMT279Z5xFfrPUOgn2LhGbjP7xTcBRjpa3P3h19XoQtxxBvRS7M+ahB
Qv4n3ZXYfOJDuSFLxndW7Jmzey86hLLw0utCR5nvxmdO82eTKEAXSM0WdQWlqepd
Mm+FZgK5rwap4CZcnvsaYWRJI9NZap0mGJ2mhWccOedqCNj0AZE3GzMIc0ysfhZb
6GAYIGJD/dPNw1//+/Bl0PcN/4lIckzwp4nfZqHPl0+EBZ9VZ6Cu/pViQDGedoI9
vmWi72dYXg03FvH0dr5ydmfWNN6No+kqC8N/b67mhOpxkynPQrk2aHRfONwK42wi
F61F0uuAB+J0SBapcFPnvo6R3X6lmw==
=nx7W
-----END PGP SIGNATURE-----

--Sig_/66KvUnqbJfOyKPuGiz=LZXS--
