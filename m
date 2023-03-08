Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EFD26B111A
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 19:34:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbjCHSeq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 13:34:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjCHSep (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 13:34:45 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C375356505;
        Wed,  8 Mar 2023 10:34:43 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id cy23so69356312edb.12;
        Wed, 08 Mar 2023 10:34:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678300482;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VtUE/7DBohqNr7IJ3h/RgLd1gCpyEJMqeBsb1dHhiiw=;
        b=fHmNlpoMEszeE15zSWXKhmvAq0EDBulLvVk7HYWuPhBWDAN3TUjmkcrisqicYJ3bW/
         20+ijoy3Y/FQhe5M69QbmFhsZihZK7M8h3X6+HDqYB3hqjql8woeHenCG4MUgzzC8A3g
         ejqZNbW1gsV1Gfwit4wm46QaHrrj9hda+JuGS9nqE2CDZIMy6mO5ocOA00kalBh3HmTI
         oLceEemLvRTcQXfAbwysUE0hFZ+sJcvXGxLNk1KkV3kQjTmky04YODCLVdAZiZUGM84K
         kxxvEnQHVsNLf79Po4HmwGO3h5IjsYrZf3L2tNMVKHJ68/DMP2MRkmOny8WjTZ/N8W8H
         Ub9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678300482;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VtUE/7DBohqNr7IJ3h/RgLd1gCpyEJMqeBsb1dHhiiw=;
        b=ymK9WF0cPjpmD0eD7+bu6dSTJDHCy4Gm/IPlpRHQrbZRZ1tLPrHEYlmmCoJPtOqRtc
         SCpOzn65NXMMSHy7fvoHunYNy6RnH2KEdF/X6ZnSYZPvbTezKsSbvkgJvrXNzi3N49h0
         bCU3Y+LOowdmVc/qMi5mClSAtZCG4Z7I2dGoY+tUff/iFIG/lD5T1tDhxjBbCNNZvw9a
         EXz3Pbco9mwu5Tc17GA2Tq1G9g9vtlz+r4XGoC5nT5EMobiTTfK1CrkzFGyjnw0+URe+
         u45qUjhPoWWWDxhh/uFlDjpP5jWiQH3vix1GXbpcPnmKBGiMANpK2CVPzVn1qWVAR6eC
         rZHQ==
X-Gm-Message-State: AO0yUKVjlX0y+G3XuFYTZ9v4vIofGJJa9bIkI2Vw5MZs/717YX9RwW/E
        oJvICx6oDgVRXoMeSZ5AbAo=
X-Google-Smtp-Source: AK7set+NcA0sgdg4llwz3yGkNz7kStT6sPz/Ru82tgxk1Zl88I1GbZ2ntBhg9IwWQghzRUFE1LELOQ==
X-Received: by 2002:a05:6402:5154:b0:4bd:6b93:1289 with SMTP id n20-20020a056402515400b004bd6b931289mr17146099edd.15.1678300482112;
        Wed, 08 Mar 2023 10:34:42 -0800 (PST)
Received: from ?IPv6:2a02:168:6806:0:3ab6:1404:fd5c:80ff? ([2a02:168:6806:0:3ab6:1404:fd5c:80ff])
        by smtp.gmail.com with ESMTPSA id q18-20020a170906771200b008cc920469b5sm7922081ejm.18.2023.03.08.10.34.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 10:34:41 -0800 (PST)
Message-ID: <09d65e1ee0679e1e74b4f3a5a4c55bd48332f043.camel@gmail.com>
Subject: Re: [PATCH net-next v2 4/6] net: mdio: scan bus based on bus
 capabilities for C22 and C45
From:   Klaus Kudielka <klaus.kudielka@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Michael Walle <michael@walle.cc>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-aspeed@lists.ozlabs.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Date:   Wed, 08 Mar 2023 19:34:40 +0100
In-Reply-To: <72530e86-9ba9-4a01-9cd2-68835ecae7a0@lunn.ch>
References: <20230116-net-next-remove-probe-capabilities-v2-0-15513b05e1f4@walle.cc>
         <20230116-net-next-remove-probe-capabilities-v2-4-15513b05e1f4@walle.cc>
         <449bde236c08d5ab5e54abd73b645d8b29955894.camel@gmail.com>
         <100c439a-2a4d-4cb2-96f2-5bf273e2121a@lunn.ch>
         <712bc92ca6d576f33f63f1e9c2edf0030b10d3ae.camel@gmail.com>
         <db6b8a09-b680-4baa-8963-d355ad29eb09@lunn.ch>
         <0e10aa8492eadb587949d8744b56fccaabbd183b.camel@gmail.com>
         <72530e86-9ba9-4a01-9cd2-68835ecae7a0@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-1 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2023-03-07 at 21:35 +0100, Andrew Lunn wrote:
> > Summary: Still 4 calls to mdio_bus_scan_c22, but also *2* calls to mdio=
_bus_scan_c45, approx. 190*100 reads by the switch driver
>=20
> Those calls to mdio_bus_scan_c45 are caused by 743a19e38d02 net: dsa:
> mv88e6xxx: Separate C22 and C45 transactions.

Well, yes and no. I understand orion mdio is MDIOBUS_NO_CAP
and therefore the c45 scan is *not* called until 1a136ca2e0
net: mdio: scan bus based on bus capabilities for C22 and C45.
Which is the behaviour I see.
(I needed a close look at the conditions in the if statements
that were removed then)


> The only part of a c45 scan which is not linear is
> mv88e6xxx_g2_smi_phy_wait() which is implemented by
> mv88e6xxx_wait_mask(). That loops reading a register waiting for a bit
> to change. Maybe print out the value of i, and see if it is looping
> more times for C45 than C22?

Here the debug code

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/c=
hip.c
index 0a5d6c7bb1..23816cad41 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -90,6 +90,7 @@ int mv88e6xxx_wait_mask(struct mv88e6xxx_chip *chip, int =
addr, int reg,
 	u16 data;
 	int err;
 	int i;
+	static unsigned wait_count =3D 0, loop_count =3D 0;
=20
 	/* There's no bus specific operation to wait for a mask. Even
 	 * if the initial poll takes longer than 50ms, always do at
@@ -100,8 +101,13 @@ int mv88e6xxx_wait_mask(struct mv88e6xxx_chip *chip, i=
nt addr, int reg,
 		if (err)
 			return err;
=20
-		if ((data & mask) =3D=3D val)
+		if ((data & mask) =3D=3D val) {
+			wait_count++;
+			loop_count +=3D i;
+			if (wait_count % 10 =3D=3D 0)
+				dev_warn(chip->dev, "wait_count %u, loop_count %u\n", wait_count, loop=
_count);
 			return 0;
+		}
=20
 		if (i < 2)
 			cpu_relax();
diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 5b2f48c09a..19fde21cae 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -569,6 +569,7 @@ static int mdiobus_scan_bus_c22(struct mii_bus *bus)
 {
 	int i;
=20
+	dev_warn(&bus->dev, "*** mdiobus_scan_bus_c22 call ***\n");
 	for (i =3D 0; i < PHY_MAX_ADDR; i++) {
 		if ((bus->phy_mask & BIT(i)) =3D=3D 0) {
 			struct phy_device *phydev;
@@ -578,6 +579,7 @@ static int mdiobus_scan_bus_c22(struct mii_bus *bus)
 				return PTR_ERR(phydev);
 		}
 	}
+	dev_warn(&bus->dev, "*** mdiobus_scan_bus_c22 return ***\n");
 	return 0;
 }
=20
@@ -585,6 +587,7 @@ static int mdiobus_scan_bus_c45(struct mii_bus *bus)
 {
 	int i;
=20
+	dev_warn(&bus->dev, "*** mdiobus_scan_bus_c45 call ***\n");
 	for (i =3D 0; i < PHY_MAX_ADDR; i++) {
 		if ((bus->phy_mask & BIT(i)) =3D=3D 0) {
 			struct phy_device *phydev;
@@ -598,6 +601,7 @@ static int mdiobus_scan_bus_c45(struct mii_bus *bus)
 				return PTR_ERR(phydev);
 		}
 	}
+	dev_warn(&bus->dev, "*** mdiobus_scan_bus_c45 return ***\n");
 	return 0;
 }
=20


And here the trimmed results from boot @ 1a136ca2e0, plus debug code.

It's not only the looping during the mv88e6xxx_wait_mask calls, but
also the sheer amount of mv88e6xxx_wait_mask calls during the c45 scans.
(c22: ~0.1 sec & ~150 calls, c45: 2.3-2.5 sec & ~4800 calls)


[    0.195215] mdio_bus fixed-0: *** mdiobus_scan_bus_c22 call ***
[    0.195221] mdio_bus fixed-0: *** mdiobus_scan_bus_c22 return ***
[    0.195617] mdio_bus f1072004.mdio-mii: *** mdiobus_scan_bus_c22 call **=
*
[    0.195623] mdio_bus f1072004.mdio-mii: *** mdiobus_scan_bus_c22 return =
***
[    0.202583] mv88e6085 f1072004.mdio-mii:10: switch 0x1760 detected: Marv=
ell 88E6176, revision 1
[    0.212708] mdio_bus mv88e6xxx-0: *** mdiobus_scan_bus_c22 call ***
[    0.222200] mv88e6085 f1072004.mdio-mii:10: wait_count 10, loop_count 3
........
[    0.315724] mv88e6085 f1072004.mdio-mii:10: wait_count 150, loop_count 7=
6
[    0.315908] mdio_bus mv88e6xxx-0: *** mdiobus_scan_bus_c22 return ***
[    0.315913] mdio_bus mv88e6xxx-0: *** mdiobus_scan_bus_c45 call ***
[    0.321095] mv88e6085 f1072004.mdio-mii:10: wait_count 160, loop_count 8=
3
........
[    2.610380] mv88e6085 f1072004.mdio-mii:10: wait_count 4980, loop_count =
1571
[    2.613258] mdio_bus mv88e6xxx-0: *** mdiobus_scan_bus_c45 return ***
[    2.755785] mv88e6085 f1072004.mdio-mii:10: switch 0x1760 detected: Marv=
ell 88E6176, revision 1
[    2.766047] mdio_bus mv88e6xxx-1: *** mdiobus_scan_bus_c22 call ***
[    2.766960] mv88e6085 f1072004.mdio-mii:10: wait_count 4990, loop_count =
1574
........
[    2.867107] mv88e6085 f1072004.mdio-mii:10: wait_count 5130, loop_count =
1645
[    2.869938] mdio_bus mv88e6xxx-1: *** mdiobus_scan_bus_c22 return ***
[    2.869943] mdio_bus mv88e6xxx-1: *** mdiobus_scan_bus_c45 call ***
[    2.871556] mv88e6085 f1072004.mdio-mii:10: wait_count 5140, loop_count =
1649
........
[    5.371710] mv88e6085 f1072004.mdio-mii:10: wait_count 9970, loop_count =
4282
[    5.373332] mdio_bus mv88e6xxx-1: *** mdiobus_scan_bus_c45 return ***




Best regards, Klaus
