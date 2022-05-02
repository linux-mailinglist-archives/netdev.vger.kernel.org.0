Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEF69516AFF
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 08:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353816AbiEBGz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 02:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244222AbiEBGzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 02:55:54 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA35935270;
        Sun,  1 May 2022 23:52:24 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 5498140003;
        Mon,  2 May 2022 06:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1651474342;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CRnuH9NmDN7PIjjb0xMDNRrIFcSL+3W+2vUxFvjNLKo=;
        b=GHdJ3TT4SITL2nwOkmdIRURaN/xuQC5jufmrAZumYAEe4lZtwnW6aQXQN/YT10EFNdhjP2
        iOU/QR9OcQwgUPcY2J9vtH/Ck6X24V8L9szzdgkGqYuE7WTORx81kA2addlo1LG7/gFK6b
        5v0h05tFajTYdl+oUq0lermRU+f96HuaN90dD2Z5cGHp8lWWfbkHbE4/C1Ecnqscb9Q/wz
        MqxwSSUaWbWnqE1zw3isHiX3CkZXDMSVyqXCcKwvpHd0XM70yegrcq7vYFrxrVl7Epq/rZ
        u1VSqNFGOmK/liT99vSNmD7zsaz6Muly8EeV3fBvIKtzAVkGAeB2UP+57ZN2Kg==
Date:   Mon, 2 May 2022 08:51:03 +0200
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
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
Subject: Re: [net-next v2 00/12] add support for Renesas RZ/N1 ethernet
 subsystem devices
Message-ID: <20220502085103.19b4f47b@fixe.home>
In-Reply-To: <20220429123235.3098ed12@kernel.org>
References: <20220429143505.88208-1-clement.leger@bootlin.com>
        <20220429123235.3098ed12@kernel.org>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Fri, 29 Apr 2022 12:32:35 -0700,
Jakub Kicinski <kuba@kernel.org> a =C3=A9crit :

> On Fri, 29 Apr 2022 16:34:53 +0200 Cl=C3=A9ment L=C3=A9ger wrote:
> > The Renesas RZ/N1 SoCs features an ethernet subsystem which contains
> > (most notably) a switch, two GMACs, and a MII converter [1]. This
> > series adds support for the switch and the MII converter.
> >=20
> > The MII converter present on this SoC has been represented as a PCS
> > which sit between the MACs and the PHY. This PCS driver is probed from
> > the device-tree since it requires to be configured. Indeed the MII
> > converter also contains the registers that are handling the muxing of
> > ports (Switch, MAC, HSR, RTOS, etc) internally to the SoC.
> >=20
> > The switch driver is based on DSA and exposes 4 ports + 1 CPU
> > management port. It include basic bridging support as well as FDB and
> > statistics support. =20
>=20
> Build's not happy (W=3D1 C=3D1):
>=20
> drivers/net/dsa/rzn1_a5psw.c:574:29: warning: symbol 'a5psw_switch_ops' w=
as not declared. Should it be static?
> In file included from ../drivers/net/dsa/rzn1_a5psw.c:17:
> drivers/net/dsa/rzn1_a5psw.h:221:1: note: offset of packed bit-field =E2=
=80=98port_mask=E2=80=99 has changed in GCC 4.4
>   221 | } __packed;
>       | ^
>=20

Hi Jakub, I only had this one (due to the lack of W=3D1 C=3D1 I guess) which
I thought (wrongly) that it was due to my GCC version:

  CC      net/dsa/switch.o
  CC      net/dsa/tag_8021q.o
In file included from ../drivers/net/dsa/rzn1_a5psw.c:17:
../drivers/net/dsa/rzn1_a5psw.h:221:1: note: offset of packed bit-field
  =E2=80=98port_mask=E2=80=99 has changed in GCC 4.4 221 | } __packed;
      | ^
  CC      kernel/module.o
  CC      drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.o
  CC      drivers/net/ethernet/stmicro/stmmac/dwmac100_core.o

I'll fix the other errors which are more trivial, however, I did not
found a way to fix the packed bit-field warning.

Thanks

> drivers/net/dsa/rzn1_a5psw.h:200: warning: Function parameter or member '=
hclk' not described in 'a5psw'
> drivers/net/dsa/rzn1_a5psw.h:200: warning: Function parameter or member '=
clk' not described in 'a5psw'
>=20
> Not sure how many of these are added by you but I think 2 at least.



--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
