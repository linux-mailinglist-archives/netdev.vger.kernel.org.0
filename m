Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E165624605
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 16:35:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbiKJPfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 10:35:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231573AbiKJPeo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 10:34:44 -0500
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E595FC2
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 07:34:36 -0800 (PST)
Received: from wsk (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 352F884D70;
        Thu, 10 Nov 2022 16:34:32 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1668094472;
        bh=/bTqao/m9hCU8Qf/ejM9vQo3HC+5/rXylp3lG16GaWc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Xyf2iNBhVcZmezmkjPa13XtKWXpvGngH83AtfmbijZVg+k+LP7ffSQVLRx4qXou2s
         stnrPUK0qvETpeoois5qCcipSuQ8nZ98un4+c+7LsFhWygozFS0Ab93+AjbMuBTg09
         /9GDygTu6vRFk97r11zkMwLiUSf0nwmcwni3A0XNHrmrKPBXpl6/Y77lbUlFz8dT5X
         9dezTwllFVohwbEjnzWxHwF4Woccdc7BF6eS9gOGeST0T62+VJuNptE5onZdXRqn04
         aFdoFsB8IBTGzTcJlwJFV2FoISp3hfkwRRRj0nyQ9IXuyevTtiisMWQdI72OnfcZPw
         yFmfp3bsHjtIA==
Date:   Thu, 10 Nov 2022 16:34:25 +0100
From:   Lukasz Majewski <lukma@denx.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Subject: Re: [PATCH 1/9] net: dsa: allow switch drivers to override default
 slave PHY addresses
Message-ID: <20221110163425.7b4974d5@wsk>
In-Reply-To: <Y2pX0qrLs/OCQOFr@lunn.ch>
References: <20221108082330.2086671-1-lukma@denx.de>
        <20221108082330.2086671-2-lukma@denx.de>
        <Y2pX0qrLs/OCQOFr@lunn.ch>
Organization: denx.de
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/RiyDIGE.SfCIMhPy=pBjacq";
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

--Sig_/RiyDIGE.SfCIMhPy=pBjacq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

> On Tue, Nov 08, 2022 at 09:23:22AM +0100, Lukasz Majewski wrote:
> > From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
> >=20
> > Avoid having to define a PHY for every physical port when PHY
> > addresses are fixed, but port index !=3D PHY address. =20
>=20
> Please could you expand the commit message.

I've left the comment untouched from Matthias...

> What i think is going on
> is that for the lower device, port 0 has phy address 0, port 1 phy
> address 1. But the upper switch has port 0 phy address 16, port 1 phy
> addr 17?

To be more specific -> for mv88e6071 and mv88e6020:

PHY ports have SMI addresses from 0 to 0x6 and
Switch PORTS have addresses from 0x8 to 0xE

Global 2 -> 0x7=20
Global 1 -> 0xF

Access to PHYs is ONLY possible via indirect access from Global 2 (0x7
SMI addr) - offsets 0x18 and 0x19.

but :-)

there is also RO_LED/ADDR4 pin (bootstrap), which when set changes the
SMI address of PHYs (from 0x00 - 0x04 to 0x10 to 0x14). This allows
easy expansion of the number of ports for switch...

>=20
> 6141 and 6341 set phy_base_addr to 0x10.=20

It depends if the HW designer set this bootstrap pin low or high :-)
(often this pin is not concerned until mainline/BSP driver is not
working :-) )

As it costs $ to fix this - it is easier to add "quirk" to the code.

> Oddly, this is only used for
> the interrupt. So i assume these two devices also need device tree
> phy-handle descriptions?

I only have access to 6071 and 6020 switches.

>=20
> It would be nice to fix the 6141 and the 6341 as well.

As Vladimir pointed out - many Marvell switches use the "old" DTS
description ...

>=20
> What might help with understanding is have the patch for the mv88e6xxx
> op first, and then wire it up in the core afterwards. Reviews tend to
> happen first to last, so either your commit message needs to explain
> what is coming, or you do things in the order which helps the reviewer
> the most.

I must admit, that I've just used code (his patch sert) from Matthias as
a starting point (to keep his credits).

>=20
>    Andrew




Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/RiyDIGE.SfCIMhPy=pBjacq
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmNtGgEACgkQAR8vZIA0
zr2ucQgA1B+3wogEAHiV6+Ln1bHkpyNZj9Uc9DhS/KluWCByEFtWp8L7mbX0p/5Y
S1iNEnOyYX00gIuDRVdbNDaEj6gREaTlb1QLQ5Y8BwF7PBc4WFdyou11Ca64N5dJ
YzPuqJBnE3NKlLcGTJKpN8+5Tq+i43FQeu5l66XTgx06+N77+01XYh3DBbARc+OJ
GgXQfk9RfsiFU+E6zuFB5TmGJD/5vsyV+sCtbbPduO5aEkrj9M+RLyDWbbDFJ4OD
dNC5TJGGMEuCfMroX8Lde+1hvIKOsTCPQhYzSBk9huvOjx8/BYyCQmeFk8jqBGEE
eD8CU1FTD6ms7UdPMx918rCgZtPvjA==
=wVQ3
-----END PGP SIGNATURE-----

--Sig_/RiyDIGE.SfCIMhPy=pBjacq--
