Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF622522CDC
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 09:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242612AbiEKHI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 03:08:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235005AbiEKHIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 03:08:25 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::228])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD5B5A30A0;
        Wed, 11 May 2022 00:08:22 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 0B8841BF20D;
        Wed, 11 May 2022 07:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652252901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j94gMFJ0WOTyCXQ5/7RSgY2UuqQn8cfJodJNeaB6sKM=;
        b=o4c+Ks//LyKW+VNGeLfdEJFW3hTEugCv+16z7cGmKcltjQ8WhG3X3Vq+S/UPO3WWdiZPCP
        VJ0y6wQTbnbXrfocRv47evYyFOBJG1kG9I38pNS9Alv/2ZBrYS124ovixjjR118MPtrKb7
        Ibcuhc6jF5wTvdv2iw6auQvuqeRGDtGYJtB7O2clACTSUHmBrEiiDv3HV0nrt167iZEK1N
        XgMr3cCTZhl2jR/X0BEjAVQf78V5xN8PVGhmscA+bWpLSWuk/+kSLGxMawkgGvclsuLNZP
        IThnigvwZvpCraoAPYAxFKKMUkfdIEL+3iubgF6L95KefI/yL0GiUpnG+M3TLQ==
Date:   Wed, 11 May 2022 09:08:15 +0200
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?B?TWlxdcOobA==?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4 00/12] add support for Renesas RZ/N1
 ethernet subsystem devices
Message-ID: <20220511090815.42deebac@xps-bootlin>
In-Reply-To: <1b097089-d6e6-5622-15aa-7038b66b1367@gmail.com>
References: <20220509131900.7840-1-clement.leger@bootlin.com>
        <1b097089-d6e6-5622-15aa-7038b66b1367@gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Tue, 10 May 2022 09:30:17 -0700,
Florian Fainelli <f.fainelli@gmail.com> a =C3=A9crit :

> On 5/9/22 06:18, Cl=C3=A9ment L=C3=A9ger wrote:
> > The Renesas RZ/N1 SoCs features an ethernet subsystem which contains
> > (most notably) a switch, two GMACs, and a MII converter [1]. This
> > series adds support for the switch and the MII converter.
> >=20
> > The MII converter present on this SoC has been represented as a PCS
> > which sit between the MACs and the PHY. This PCS driver is probed
> > from the device-tree since it requires to be configured. Indeed the
> > MII converter also contains the registers that are handling the
> > muxing of ports (Switch, MAC, HSR, RTOS, etc) internally to the SoC.
> >=20
> > The switch driver is based on DSA and exposes 4 ports + 1 CPU
> > management port. It include basic bridging support as well as FDB
> > and statistics support.
> >=20
> > This series needs commits 14f11da778ff6421 ("soc: renesas: rzn1:
> > Select PM and PM_GENERIC_DOMAINS configs") and ed66b37f916ee23b
> > ("ARM: dts: r9a06g032: Add missing '#power-domain-cells'") which
> > are available on the renesas-devel tree in order to enable generic
> > power domain on RZ/N1.
> >=20
> > Link: [1]
> > https://www.renesas.com/us/en/document/mah/rzn1d-group-rzn1s-group-rzn1=
l-group-users-manual-r-engine-and-ethernet-peripherals
> > =20
> Build testing this patch set gave me the following Kconfig warnings:
>=20
> WARNING: unmet direct dependencies detected for PCS_RZN1_MIIC
>    Depends on [n]: NETDEVICES [=3Dy] && (ARCH_RZN1 [=3Dn] || COMPILE_TEST
> [=3Dn]) Selected by [m]:
>    - NET_DSA_RZN1_A5PSW [=3Dm] && NETDEVICES [=3Dy] && NET_DSA [=3Dm]
>=20
> WARNING: unmet direct dependencies detected for PCS_RZN1_MIIC
>    Depends on [n]: NETDEVICES [=3Dy] && (ARCH_RZN1 [=3Dn] || COMPILE_TEST
> [=3Dn]) Selected by [m]:
>    - NET_DSA_RZN1_A5PSW [=3Dm] && NETDEVICES [=3Dy] && NET_DSA [=3Dm]
>=20
> WARNING: unmet direct dependencies detected for PCS_RZN1_MIIC
>    Depends on [n]: NETDEVICES [=3Dy] && (ARCH_RZN1 [=3Dn] || COMPILE_TEST
> [=3Dn]) Selected by [m]:
>    - NET_DSA_RZN1_A5PSW [=3Dm] && NETDEVICES [=3Dy] && NET_DSA [=3Dm]
>=20
> I started off with arm64's defconfig and then enabled all of the DSA=20
> drivers.

Ok, I'll fix that.

Cl=C3=A9ment
