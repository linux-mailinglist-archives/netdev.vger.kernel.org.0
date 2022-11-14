Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7091627A22
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 11:12:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236085AbiKNKMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 05:12:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236533AbiKNKL7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 05:11:59 -0500
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B93920377
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 02:10:31 -0800 (PST)
Received: from wsk (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id EE68F82A4D;
        Mon, 14 Nov 2022 11:10:28 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1668420629;
        bh=BPEhumdjePM766YnN0/pixKN97rftd5XsdPS3ODwWYM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=O1woi+X+x2UrWVDrTyCgeGcrRjLwVfqnB8z0MyozNz1Q/JP1mSewbyJoWaoemCf87
         qd5JxhIg1rU8dkwmdk/i29zMHWqhVDYBxphctwV3vuSXoLIe0aeG2c7VSi//RynWFJ
         iEGp8+uHBlDwraU2aLGbVmtDj+ayMJruXZ3IriVnVGIG/YbyoSoR21xApwIwXdPNPu
         5JZ0FS78DLSZJJGUwFHKQnnaI19C4LSEvh7U++pXNp+PhPpTV4MiVGiYfVLfotuLV4
         VGa0jtLNHNSXqOUTCJUkVquV+iuReFXLPrYa8koZOHriXAfUK0a/pUMTZNAPRoP6lY
         35XISdxU2fNWg==
Date:   Mon, 14 Nov 2022 11:10:22 +0100
From:   Lukasz Majewski <lukma@denx.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Subject: Re: [PATCH 3/9] net: dsa: mv88e6xxx: implement get_phy_address
Message-ID: <20221114111022.226f3976@wsk>
In-Reply-To: <20221111213813.jfelkktkj5wk45qy@skbuf>
References: <20221108082330.2086671-1-lukma@denx.de>
        <20221108082330.2086671-4-lukma@denx.de>
        <20221108091220.zpxsduscpvgr3zna@skbuf>
        <Y2pbc90XD5IvZZC0@lunn.ch>
        <20221110180053.0cb8045d@wsk>
        <20221111213813.jfelkktkj5wk45qy@skbuf>
Organization: denx.de
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/0.N=Gb4FVJrOYsXsTJ3WJW+";
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

--Sig_/0.N=Gb4FVJrOYsXsTJ3WJW+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Vladimir,

> On Thu, Nov 10, 2022 at 06:00:53PM +0100, Lukasz Majewski wrote:
> > Maybe in the generic case of PHY, yes (via Driver Model).
> >=20
> > However, when you delve into the mv88e6xxx driver [1] - you would
> > find that this is not supporting it yet ...
> >=20
> > As fair as I know - for the driver [1] - there was no ongoing effort
> > recently.
> >=20
> > Links:
> > [1] -
> > https://source.denx.de/u-boot/u-boot/-/blob/master/drivers/net/phy/mv88=
e61xx.c
> > =20
>=20
> U-Boot mailing list is moving a bit slower than netdev (and the patch
> set is not yet applied despite being ready), but I was talking about
> this:
> https://patchwork.ozlabs.org/project/uboot/list/?series=3D324983
>=20

Thanks for sharing this link. It looks like this driver also supports
switchnig addresses for Marvell ICs.

(This was the goal for mine previous patches).


> If you study DM_DSA, you'll see that only supporting PHY connection
> via phy-handle (even if the PHY is internal) (or fixed-link, in lack
> of a PHY) was an absolutely deliberate decision.

Ok. I do agree now - will adjust the code accordingly.


Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/0.N=Gb4FVJrOYsXsTJ3WJW+
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmNyFA4ACgkQAR8vZIA0
zr1v0wgA0rPDwXSVqXyDKPAAGo/AXzTG+qULxs3ULsIQqqLqZnrG4w462zGRuBgj
Q93IxA0r53IEYami1Rd2wX9O6Q8VYwRYSw7I9rNAG8kDCItPLqze0H2a41jUY5ub
tYIpyMxrPu3gmN4w2DZfikzpW5bfJ23B9uI/AVwwhLN1ntoBeO2I89MBqsf1+JuJ
NVYHpUUjhGt4Wyl2ENsXDeGpjPyBIPmRJmCYZa2IicIp5YEsP9K31fNDfMpw5Zk1
efoU9Qyd1eYOV9vDSdtUajH4vCCYyedlTbO8eGEX4+8IJWSHynZl4uy3f0s8hJ0o
MF65c5ryLRiI3OUc95fQTh3aLbc0UQ==
=4Lv+
-----END PGP SIGNATURE-----

--Sig_/0.N=Gb4FVJrOYsXsTJ3WJW+--
