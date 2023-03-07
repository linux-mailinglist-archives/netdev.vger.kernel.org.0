Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C56B06AF633
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 20:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbjCGT4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 14:56:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbjCGTz4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 14:55:56 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3200D4ECF2;
        Tue,  7 Mar 2023 11:48:03 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id cw28so56974542edb.5;
        Tue, 07 Mar 2023 11:48:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678218482;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Cnf7+HVj+Istie5SLthv+GJS8HwO737hHWs1KZL+Q+8=;
        b=NzQO0aDJcRPeIeQqQc1iQyueLVWrKiLCUn0Ea0m3B6HApbk30BHAoGFVHx09SHwx5W
         NQk3zbARdO3psDPD1CmctDoJRgyWJX1z0oS3IKZCqIr8OJsvYxahNVSfZEGhjTcNX60R
         VbnejLn5S33XHlqEDmK3f1VdImttVJPJxHLPhYJyeUllYvnfQmDL9NVQTiwn/O5C2ZdT
         qIrsE1EDptJ9hGpl8fNish9zZzi/xBJ53bzWLqQR0W5FrLv6eE0ft36bPWI5FwaEn0HQ
         bv6prWJ8oOiNtXXkYq0LKdSs+n5AxtgT6VtGMVezPGLfy5k1H/U+a/Oi3+89i4eb5Had
         ZhyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678218482;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Cnf7+HVj+Istie5SLthv+GJS8HwO737hHWs1KZL+Q+8=;
        b=1JdSfzIk+XAsL+n3HtUkQjSSrYpXS+3bCAOFb0h1lPblRpt1I/iPXhJHdcxQoEK66i
         hwdFSYO085TRGR3B93vfCaGR+6WHk+E78aHIjAj4sZ/EODBy72z0ogp6xKynqHwxTUfM
         KwRm/w8Z4MGxLmP7cbrFLmamGTaMPMX80cnV5w90cFni/1YsmLjdzR7ixz5Gx5cr00gw
         rb3edHY3bcdTSex7ERgwdWE0m/Hz91zvUJJhupWS7zv8KVuUi94VKPdVM28qQeYpWwsd
         nqLccZ2UvYkL/WB7+7r886KETGbBFWcN4an+U46lx+b6ADbM0N3ncFWGxEePPUK0EMWV
         SP6A==
X-Gm-Message-State: AO0yUKUbKZgjKmT6jxyeI5iEZGRcnL0VEPF9QVf1WkaH08bJ90/9kRlx
        1sZu8wVnm9d7Pt1u5iDdliU=
X-Google-Smtp-Source: AK7set85SCabp/ILqSRsiPd8RJcQo6TgmUXIX3Zte1U/CmtO2LX4bCed9zYmAHU/PsKD1jfADuf3Mg==
X-Received: by 2002:a17:906:1341:b0:8aa:502c:44d3 with SMTP id x1-20020a170906134100b008aa502c44d3mr15287809ejb.41.1678218482120;
        Tue, 07 Mar 2023 11:48:02 -0800 (PST)
Received: from ?IPv6:2a02:168:6806:0:30fc:b5a8:adb0:21cb? ([2a02:168:6806:0:30fc:b5a8:adb0:21cb])
        by smtp.gmail.com with ESMTPSA id bn17-20020a170906c0d100b008f7f6943d1dsm6487545ejb.42.2023.03.07.11.48.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 11:48:01 -0800 (PST)
Message-ID: <0e10aa8492eadb587949d8744b56fccaabbd183b.camel@gmail.com>
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
Date:   Tue, 07 Mar 2023 20:48:00 +0100
In-Reply-To: <db6b8a09-b680-4baa-8963-d355ad29eb09@lunn.ch>
References: <20230116-net-next-remove-probe-capabilities-v2-0-15513b05e1f4@walle.cc>
         <20230116-net-next-remove-probe-capabilities-v2-4-15513b05e1f4@walle.cc>
         <449bde236c08d5ab5e54abd73b645d8b29955894.camel@gmail.com>
         <100c439a-2a4d-4cb2-96f2-5bf273e2121a@lunn.ch>
         <712bc92ca6d576f33f63f1e9c2edf0030b10d3ae.camel@gmail.com>
         <db6b8a09-b680-4baa-8963-d355ad29eb09@lunn.ch>
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

On Mon, 2023-03-06 at 20:02 +0100, Andrew Lunn wrote:
>=20
>=20
> > "orion_mdio_smi_read: 43968 callbacks suppressed" after 5 seconds - qui=
te impressive!
>=20
> That is probably the switch being configured. I assume it uses address
> 16?

Correct, 0x10 according to the DTS.

> But it looks like there are many more after the bad commit. So is the
> return value messed up, putting the switch driver into a loop? Maybe
> print the smi address, register and the return value in
> orion_mdio_smi_read(). And maybe the same in the switch driver, if all
> reads happen to go through one function.


New debug session - I am not trusting the rate limiter anymore, but wrote m=
y own
(printing every 100th read in the switch driver).


PLUS: Code to see which mdiobus_scan functions are actually called



#### Debug code added ####

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/c=
hip.c
index 0a5d6c7bb1..04b141b063 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -54,6 +54,7 @@ static void assert_reg_lock(struct mv88e6xxx_chip *chip)
 int mv88e6xxx_read(struct mv88e6xxx_chip *chip, int addr, int reg, u16 *va=
l)
 {
        int err;
+       static unsigned debug =3D 0;
=20
        assert_reg_lock(chip);
=20
@@ -61,7 +62,8 @@ int mv88e6xxx_read(struct mv88e6xxx_chip *chip, int addr,=
 int reg, u16 *val)
        if (err)
                return err;
=20
-       dev_dbg(chip->dev, "<- addr: 0x%.2x reg: 0x%.2x val: 0x%.4x\n",
+       if (debug++ % 100 =3D=3D 0)
+       dev_warn(chip->dev, "<- addr: 0x%.2x reg: 0x%.2x val: 0x%.4x\n",
                addr, reg, *val);
=20
        return 0;
diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 5b2f48c09a..a914671707 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -712,6 +712,7 @@ int __mdiobus_register(struct mii_bus *bus, struct modu=
le *owner)
        }
=20
        if (bus->read) {
+               dev_warn(&bus->dev, "*** mdiobus_scan_c22 ***\n");
                err =3D mdiobus_scan_bus_c22(bus);
                if (err)
                        goto error;
@@ -720,6 +721,7 @@ int __mdiobus_register(struct mii_bus *bus, struct modu=
le *owner)
        prevent_c45_scan =3D mdiobus_prevent_c45_scan(bus);
=20
        if (!prevent_c45_scan && bus->read_c45) {
+               dev_warn(&bus->dev, "*** mdiobus_scan_c45 ***\n");
                err =3D mdiobus_scan_bus_c45(bus);
                if (err)
                        goto error;


#### TEST RESULTS ####

########
# good: [3486593374858b41ae6ef7720cb28ff39ad822f3] net: mdio: Add workaroun=
d for Micrel PHYs which are not C45 compatible

*** snip ***
[    0.194280] Creating 3 MTD partitions on "spi0.0":
[    0.194285] 0x000000000000-0x0000000f0000 : "U-Boot"
[    0.194466] 0x000000100000-0x000000800000 : "Rescue system"
[    0.194586] 0x0000000f0000-0x000000100000 : "u-boot-env"
[    0.195052] mdio_bus fixed-0: *** mdiobus_scan_c22 ***
[    0.195450] mdio_bus f1072004.mdio-mii: *** mdiobus_scan_c22 ***
[    0.202202] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x10 reg: 0x03 val:=
 0xffff
[    0.202455] mv88e6085 f1072004.mdio-mii:10: switch 0x1760 detected: Marv=
ell 88E6176, revision 1
[    0.212579] mdio_bus mv88e6xxx-0: *** mdiobus_scan_c22 ***
[    0.262165] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x19 val:=
 0xffff
[    0.290382] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x9a23
[    0.312415] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x1ba3
[    0.319994] mvneta_bm f10c8000.bm: Buffer Manager for network controller=
 enabled
[    0.321373] mvneta f1070000.ethernet eth0: Using device tree mac address=
 d8:58:d7:00:6f:b9
[    0.322348] mvneta f1030000.ethernet eth1: Using device tree mac address=
 d8:58:d7:00:6f:b7
[    0.323303] mvneta f1034000.ethernet eth2: Using device tree mac address=
 d8:58:d7:00:6f:b8
[    0.323480] orion-ehci f1058000.usb: EHCI Host Controller
[    0.323493] orion-ehci f1058000.usb: new USB bus registered, assigned bu=
s number 1
[    0.323539] orion-ehci f1058000.usb: irq 45, io mem 0xf1058000
[    0.338724] orion-ehci f1058000.usb: USB 2.0 started, EHCI 1.00
[    0.339060] hub 1-0:1.0: USB hub found
[    0.339078] hub 1-0:1.0: 1 port detected
[    0.339447] xhci-hcd f10f0000.usb3: xHCI Host Controller
[    0.339459] xhci-hcd f10f0000.usb3: new USB bus registered, assigned bus=
 number 2
[    0.339511] xhci-hcd f10f0000.usb3: hcc params 0x0a000990 hci version 0x=
100 quirks 0x0000000000010010
[    0.339536] xhci-hcd f10f0000.usb3: irq 46, io mem 0xf10f0000
[    0.339544] xhci-hcd f10f0000.usb3: xHCI Host Controller
[    0.339552] xhci-hcd f10f0000.usb3: new USB bus registered, assigned bus=
 number 3
[    0.339563] xhci-hcd f10f0000.usb3: Host supports USB 3.0 SuperSpeed
[    0.339807] hub 2-0:1.0: USB hub found
[    0.339825] hub 2-0:1.0: 1 port detected
[    0.339953] usb usb3: We don't know the algorithms for LPM for this host=
, disabling LPM.
[    0.340158] hub 3-0:1.0: USB hub found
[    0.340173] hub 3-0:1.0: 1 port detected
[    0.340349] xhci-hcd f10f8000.usb3: xHCI Host Controller
[    0.340360] xhci-hcd f10f8000.usb3: new USB bus registered, assigned bus=
 number 4
[    0.340404] xhci-hcd f10f8000.usb3: hcc params 0x0a000990 hci version 0x=
100 quirks 0x0000000000010010
[    0.340424] xhci-hcd f10f8000.usb3: irq 47, io mem 0xf10f8000
[    0.340432] xhci-hcd f10f8000.usb3: xHCI Host Controller
[    0.340439] xhci-hcd f10f8000.usb3: new USB bus registered, assigned bus=
 number 5
[    0.340449] xhci-hcd f10f8000.usb3: Host supports USB 3.0 SuperSpeed
[    0.340676] hub 4-0:1.0: USB hub found
[    0.340697] hub 4-0:1.0: 1 port detected
[    0.340823] usb usb5: We don't know the algorithms for LPM for this host=
, disabling LPM.
[    0.341025] hub 5-0:1.0: USB hub found
[    0.341041] hub 5-0:1.0: 1 port detected
[    0.341271] usbcore: registered new interface driver uas
[    0.341314] usbcore: registered new interface driver usb-storage
[    0.341781] armada38x-rtc f10a3800.rtc: registered as rtc0
[    0.341858] armada38x-rtc f10a3800.rtc: setting system clock to 2023-03-=
07T19:16:44 UTC (1678216604)
[    0.343536] at24 1-0054: 8192 byte 24c64 EEPROM, writable, 1 bytes/write
[    0.343568] i2c i2c-0: Added multiplexed i2c bus 1
[    0.343602] i2c i2c-0: Added multiplexed i2c bus 2
[    0.343632] i2c i2c-0: Added multiplexed i2c bus 3
[    0.343659] i2c i2c-0: Added multiplexed i2c bus 4
[    0.343687] i2c i2c-0: Added multiplexed i2c bus 5
[    0.343770] i2c i2c-0: Added multiplexed i2c bus 6
[    0.343801] i2c i2c-0: Added multiplexed i2c bus 7
[    0.344002] pca953x 8-0071: using no AI
[    0.345585] i2c i2c-0: Added multiplexed i2c bus 8
[    0.345593] pca954x 0-0070: registered 8 multiplexed busses for I2C mux =
pca9547
[    0.347053] orion_wdt: Initial timeout 171 sec
[    0.347239] sdhci: Secure Digital Host Controller Interface driver
[    0.347243] sdhci: Copyright(c) Pierre Ossman
[    0.347301] sdhci-pltfm: SDHCI platform and OF driver helper
[    0.356027] marvell-cesa f1090000.crypto: CESA device successfully regis=
tered
[    0.356491] NET: Registered PF_INET6 protocol family
[    0.357151] Segment Routing with IPv6
[    0.357179] In-situ OAM (IOAM) with IPv6
[    0.357242] NET: Registered PF_PACKET protocol family
[    0.357354] Registering SWP/SWPB emulation handler
[    0.374724] mmc0: SDHCI controller on f10d8000.sdhci [f10d8000.sdhci] us=
ing ADMA
[    0.394251] ata2: SATA link down (SStatus 0 SControl 300)
[    0.457112] sfp sfp: Host maximum power 3.0W
[    0.460953] mv88e6085 f1072004.mdio-mii:10: switch 0x1760 detected: Marv=
ell 88E6176, revision 1
[    0.470323] mdio_bus mv88e6xxx-1: *** mdiobus_scan_c22 ***
[    0.483424] mmc0: new high speed MMC card at address 0001
[    0.483838] mmcblk0: mmc0:0001 H8G4a\x92 7.28 GiB=20
[    0.484876]  mmcblk0: p1
[    0.485154] mmcblk0boot0: mmc0:0001 H8G4a\x92 4.00 MiB=20
[    0.485468] mmcblk0boot1: mmc0:0001 H8G4a\x92 4.00 MiB=20
[    0.485691] mmcblk0rpmb: mmc0:0001 H8G4a\x92 4.00 MiB, chardev (250:0)
[    0.509195] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x19 val:=
 0x7949
[    0.537564] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x19c3
[    0.558707] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    0.559391] ata1.00: supports DRM functions and may not be fully accessi=
ble
[    0.559396] ata1.00: ATA-10: KINGSTON SKC600MS512G, S4800105, max UDMA/1=
33
[    0.559402] ata1.00: 1000215216 sectors, multi 1: LBA48 NCQ (depth 32)
[    0.560071] ata1.00: Features: Trust Dev-Sleep
[    0.560168] ata1.00: supports DRM functions and may not be fully accessi=
ble
[    0.560821] ata1.00: configured for UDMA/133
[    0.560999] scsi 0:0:0:0: Direct-Access     ATA      KINGSTON SKC600M 01=
05 PQ: 0 ANSI: 5
[    0.561489] sd 0:0:0:0: [sda] 1000215216 512-byte logical blocks: (512 G=
B/477 GiB)
[    0.561497] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    0.561534] sd 0:0:0:0: [sda] Write Protect is off
[    0.561540] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.561596] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    0.561719] sd 0:0:0:0: [sda] Preferred minimum I/O size 4096 bytes
[    0.562284]  sda: sda1
[    0.562402] sd 0:0:0:0: [sda] Attached SCSI removable disk
[    0.566452] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x1b43
[    0.614624] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1b reg: 0x0b val:=
 0xc000
[    0.661046] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1b reg: 0x09 val:=
 0x0000
[    0.701647] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1b reg: 0x0b val:=
 0xc000
[    0.744298] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1b reg: 0x05 val:=
 0x3000
[    0.782001] sfp sfp: module TP-LINK          TL-SM321B        rev      s=
n 1403076900       dc 140401
[    0.782018] mvneta f1034000.ethernet eth2: switched to inband/1000base-x=
 link mode
[    0.784675] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x16 reg: 0x08 val:=
 0x2080
[    0.822923] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x0b val:=
 0x3020
[    0.858829] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x0b val:=
 0x3052
[    0.894730] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x0b val:=
 0x3084
[    0.930631] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x0b val:=
 0x30b6
[    0.966529] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x0b val:=
 0x30e8
[    1.002423] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x0b val:=
 0x311a
[    1.038289] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x0b val:=
 0x314c
[    1.074277] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x0b val:=
 0x317e
[    1.110265] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x0b val:=
 0x31b0
[    1.146260] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x0b val:=
 0x31e2
[    1.190453] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1b reg: 0x0b val:=
 0xc000
[    1.231278] mv88e6085 f1072004.mdio-mii:10: configuring for fixed/rgmii-=
id link mode
[    1.232939] mv88e6085 f1072004.mdio-mii:10: configuring for fixed/rgmii-=
id link mode
[    1.234212] mv88e6085 f1072004.mdio-mii:10: Link is Up - 1Gbps/Full - fl=
ow control off
[    1.237536] mv88e6085 f1072004.mdio-mii:10: Link is Up - 1Gbps/Full - fl=
ow control off
[    1.302662] mv88e6085 f1072004.mdio-mii:10 lan0 (uninitialized): PHY [mv=
88e6xxx-1:00] driver [Marvell 88E1540] (irq=3D68)
[    1.303520] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x1813
[    1.374838] mv88e6085 f1072004.mdio-mii:10 lan1 (uninitialized): PHY [mv=
88e6xxx-1:01] driver [Marvell 88E1540] (irq=3D69)
[    1.446118] mv88e6085 f1072004.mdio-mii:10 lan2 (uninitialized): PHY [mv=
88e6xxx-1:02] driver [Marvell 88E1540] (irq=3D70)
[    1.451042] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x1470
[    1.518298] mv88e6085 f1072004.mdio-mii:10 lan3 (uninitialized): PHY [mv=
88e6xxx-1:03] driver [Marvell 88E1540] (irq=3D71)
[    1.590825] mv88e6085 f1072004.mdio-mii:10 lan4 (uninitialized): PHY [mv=
88e6xxx-1:04] driver [Marvell 88E1540] (irq=3D72)
[    1.593735] device eth1 entered promiscuous mode
[    1.594611] device eth0 entered promiscuous mode
[    1.594631] DSA: tree 0 setup
[    1.595458] Freeing unused kernel image (initmem) memory: 1024K
[    1.595593] Run /init as init process
*** snip ***

Summary: 4 calls to mdio_bus_scan_c22, *0* calls to mdio_bus_scan_c45, appr=
ox. 25*100 reads by the switch driver



#####
# first bad commit: [1a136ca2e089d91df8eec0a796a324171373ffd8] net: mdio: s=
can bus based on bus capabilities for C22 and C45

*** snip ***
[    0.194373] Creating 3 MTD partitions on "spi0.0":
[    0.194378] 0x000000000000-0x0000000f0000 : "U-Boot"
[    0.194560] 0x000000100000-0x000000800000 : "Rescue system"
[    0.194681] 0x0000000f0000-0x000000100000 : "u-boot-env"
[    0.195153] mdio_bus fixed-0: *** mdiobus_scan_c22 ***
[    0.195553] mdio_bus f1072004.mdio-mii: *** mdiobus_scan_c22 ***
[    0.202306] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x10 reg: 0x03 val:=
 0xffff
[    0.202558] mv88e6085 f1072004.mdio-mii:10: switch 0x1760 detected: Marv=
ell 88E6176, revision 1
[    0.212681] mdio_bus mv88e6xxx-0: *** mdiobus_scan_c22 ***
[    0.262229] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x18a2
[    0.290246] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x1a22
[    0.312443] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x19 val:=
 0xffff
[    0.316028] mdio_bus mv88e6xxx-0: *** mdiobus_scan_c45 ***
[    0.337996] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x19 val:=
 0xffff
[    0.364407] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x19 val:=
 0xffff
[    0.390654] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x00b7
[    0.392810] ata2: SATA link down (SStatus 0 SControl 300)
[    0.416887] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x19 val:=
 0xffff
[    0.445425] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x80c9
[    0.473606] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x00d3
[    0.501416] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0cdc
[    0.529588] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x8ce6
[    0.554726] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    0.555399] ata1.00: supports DRM functions and may not be fully accessi=
ble
[    0.555403] ata1.00: ATA-10: KINGSTON SKC600MS512G, S4800105, max UDMA/1=
33
[    0.555410] ata1.00: 1000215216 sectors, multi 1: LBA48 NCQ (depth 32)
[    0.556083] ata1.00: Features: Trust Dev-Sleep
[    0.556183] ata1.00: supports DRM functions and may not be fully accessi=
ble
[    0.556838] ata1.00: configured for UDMA/133
[    0.557012] scsi 0:0:0:0: Direct-Access     ATA      KINGSTON SKC600M 01=
05 PQ: 0 ANSI: 5
[    0.557517] sd 0:0:0:0: [sda] 1000215216 512-byte logical blocks: (512 G=
B/477 GiB)
[    0.557525] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    0.557547] sd 0:0:0:0: [sda] Write Protect is off
[    0.557552] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.557585] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    0.557654] sd 0:0:0:0: [sda] Preferred minimum I/O size 4096 bytes
[    0.558145]  sda: sda1
[    0.558259] sd 0:0:0:0: [sda] Attached SCSI removable disk
[    0.558422] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x00ef
[    0.584790] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x00f7
[    0.613522] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0102
[    0.642251] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x010c
[    0.670981] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0116
[    0.699709] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0121
[    0.728625] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x19 val:=
 0xffff
[    0.757356] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x19 val:=
 0xffff
[    0.786449] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x8141
[    0.815176] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x814b
[    0.843908] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x8155
[    0.872638] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x8140
[    0.901005] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x19 val:=
 0xffff
[    0.929730] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x19 val:=
 0xffff
[    0.958275] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x017d
[    0.987002] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0188
[    1.015364] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0d92
[    1.043910] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x019c
[    1.072277] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0da6
[    1.101000] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0db0
[    1.129548] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x81ba
[    1.157907] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0dc5
[    1.186090] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0dce
[    1.214815] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x8dd8
[    1.243541] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x8e03
[    1.271726] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x19 val:=
 0xffff
[    1.300270] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0217
[    1.328633] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x19 val:=
 0xffff
[    1.357357] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0e2b
[    1.385900] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0235
[    1.414266] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0e20
[    1.442811] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x824a
[    1.471164] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x8e53
[    1.498797] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x19 val:=
 0xffff
[    1.526426] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0e66
[    1.554598] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0e70
[    1.582770] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x8e79
[    1.610763] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0284
[    1.638582] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0e8d
[    1.667118] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x8297
[    1.694931] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x19 val:=
 0xffff
[    1.722921] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x02aa
[    1.751281] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0eb4
[    1.778911] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0ebd
[    1.806902] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x82c7
[    1.834711] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x19 val:=
 0xffff
[    1.863256] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x02da
[    1.891431] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x82e5
[    1.919249] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0eee
[    1.947785] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x82f8
[    1.975960] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0302
[    2.004138] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x030c
[    2.031189] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x8314
[    2.058466] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0f1d
[    2.086642] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x8f27
[    2.114827] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x19 val:=
 0xffff
[    2.143003] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x19 val:=
 0xffff
[    2.171180] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x19 val:=
 0xffff
[    2.199357] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0f4e
[    2.227532] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0f58
[    2.255717] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0f62
[    2.284250] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x836c
[    2.312433] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0376
[    2.340608] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0360
[    2.368969] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0f8a
[    2.397147] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0f93
[    2.425324] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x19 val:=
 0xffff
[    2.453501] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x19 val:=
 0xffff
[    2.481677] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0fb1
[    2.509860] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0fba
[    2.538035] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0fc5
[    2.566209] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x19 val:=
 0xffff
[    2.594386] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x19 val:=
 0xffff
[    2.622564] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0fe2
[    2.650742] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0fec
[    2.678921] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0ff5
[    2.707643] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x8fe0
[    2.712205] mvneta_bm f10c8000.bm: Buffer Manager for network controller=
 enabled
[    2.713584] mvneta f1070000.ethernet eth0: Using device tree mac address=
 d8:58:d7:00:6f:b9
[    2.714556] mvneta f1030000.ethernet eth1: Using device tree mac address=
 d8:58:d7:00:6f:b7
[    2.715524] mvneta f1034000.ethernet eth2: Using device tree mac address=
 d8:58:d7:00:6f:b8
[    2.715699] orion-ehci f1058000.usb: EHCI Host Controller
[    2.715713] orion-ehci f1058000.usb: new USB bus registered, assigned bu=
s number 1
[    2.715755] orion-ehci f1058000.usb: irq 45, io mem 0xf1058000
[    2.730755] orion-ehci f1058000.usb: USB 2.0 started, EHCI 1.00
[    2.731088] hub 1-0:1.0: USB hub found
[    2.731107] hub 1-0:1.0: 1 port detected
[    2.731474] xhci-hcd f10f0000.usb3: xHCI Host Controller
[    2.731486] xhci-hcd f10f0000.usb3: new USB bus registered, assigned bus=
 number 2
[    2.731538] xhci-hcd f10f0000.usb3: hcc params 0x0a000990 hci version 0x=
100 quirks 0x0000000000010010
[    2.731563] xhci-hcd f10f0000.usb3: irq 46, io mem 0xf10f0000
[    2.731572] xhci-hcd f10f0000.usb3: xHCI Host Controller
[    2.731579] xhci-hcd f10f0000.usb3: new USB bus registered, assigned bus=
 number 3
[    2.731590] xhci-hcd f10f0000.usb3: Host supports USB 3.0 SuperSpeed
[    2.731833] hub 2-0:1.0: USB hub found
[    2.731851] hub 2-0:1.0: 1 port detected
[    2.731979] usb usb3: We don't know the algorithms for LPM for this host=
, disabling LPM.
[    2.732181] hub 3-0:1.0: USB hub found
[    2.732197] hub 3-0:1.0: 1 port detected
[    2.732375] xhci-hcd f10f8000.usb3: xHCI Host Controller
[    2.732387] xhci-hcd f10f8000.usb3: new USB bus registered, assigned bus=
 number 4
[    2.732430] xhci-hcd f10f8000.usb3: hcc params 0x0a000990 hci version 0x=
100 quirks 0x0000000000010010
[    2.732449] xhci-hcd f10f8000.usb3: irq 47, io mem 0xf10f8000
[    2.732457] xhci-hcd f10f8000.usb3: xHCI Host Controller
[    2.732464] xhci-hcd f10f8000.usb3: new USB bus registered, assigned bus=
 number 5
[    2.732475] xhci-hcd f10f8000.usb3: Host supports USB 3.0 SuperSpeed
[    2.732705] hub 4-0:1.0: USB hub found
[    2.732725] hub 4-0:1.0: 1 port detected
[    2.732851] usb usb5: We don't know the algorithms for LPM for this host=
, disabling LPM.
[    2.733062] hub 5-0:1.0: USB hub found
[    2.733078] hub 5-0:1.0: 1 port detected
[    2.733309] usbcore: registered new interface driver uas
[    2.733353] usbcore: registered new interface driver usb-storage
[    2.733820] armada38x-rtc f10a3800.rtc: registered as rtc0
[    2.733896] armada38x-rtc f10a3800.rtc: setting system clock to 2023-03-=
07T19:21:07 UTC (1678216867)
[    2.735580] at24 1-0054: 8192 byte 24c64 EEPROM, writable, 1 bytes/write
[    2.735611] i2c i2c-0: Added multiplexed i2c bus 1
[    2.735645] i2c i2c-0: Added multiplexed i2c bus 2
[    2.735674] i2c i2c-0: Added multiplexed i2c bus 3
[    2.735702] i2c i2c-0: Added multiplexed i2c bus 4
[    2.735730] i2c i2c-0: Added multiplexed i2c bus 5
[    2.735812] i2c i2c-0: Added multiplexed i2c bus 6
[    2.735842] i2c i2c-0: Added multiplexed i2c bus 7
[    2.736043] pca953x 8-0071: using no AI
[    2.737626] i2c i2c-0: Added multiplexed i2c bus 8
[    2.737634] pca954x 0-0070: registered 8 multiplexed busses for I2C mux =
pca9547
[    2.739068] orion_wdt: Initial timeout 171 sec
[    2.739255] sdhci: Secure Digital Host Controller Interface driver
[    2.739258] sdhci: Copyright(c) Pierre Ossman
[    2.739317] sdhci-pltfm: SDHCI platform and OF driver helper
[    2.748039] marvell-cesa f1090000.crypto: CESA device successfully regis=
tered
[    2.748503] NET: Registered PF_INET6 protocol family
[    2.749168] Segment Routing with IPv6
[    2.749195] In-situ OAM (IOAM) with IPv6
[    2.749259] NET: Registered PF_PACKET protocol family
[    2.749371] Registering SWP/SWPB emulation handler
[    2.770763] mmc0: SDHCI controller on f10d8000.sdhci [f10d8000.sdhci] us=
ing ADMA
[    2.848092] sfp sfp: Host maximum power 3.0W
[    2.851931] mv88e6085 f1072004.mdio-mii:10: switch 0x1760 detected: Marv=
ell 88E6176, revision 1
[    2.862003] mdio_bus mv88e6xxx-1: *** mdiobus_scan_c22 ***
[    2.879502] mmc0: new high speed MMC card at address 0001
[    2.879819] mmcblk0: mmc0:0001 H8G4a\x92 7.28 GiB=20
[    2.880804]  mmcblk0: p1
[    2.881033] mmcblk0boot0: mmc0:0001 H8G4a\x92 4.00 MiB=20
[    2.881318] mmcblk0boot1: mmc0:0001 H8G4a\x92 4.00 MiB=20
[    2.881526] mmcblk0rpmb: mmc0:0001 H8G4a\x92 4.00 MiB, chardev (250:0)
[    2.909764] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x9881
[    2.937887] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x1a02
[    2.960055] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x1b83
[    2.965581] mdio_bus mv88e6xxx-1: *** mdiobus_scan_c45 ***
[    2.985324] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x80a6
[    3.014234] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0cb0
[    3.042420] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0cba
[    3.071680] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0cc5
[    3.098030] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x00cd
[    3.126945] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0cd7
[    3.155490] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x00e2
[    3.182032] sfp sfp: module TP-LINK          TL-SM321B        rev      s=
n 1403076900       dc 140401
[    3.182049] mvneta f1034000.ethernet eth2: switched to inband/1000base-x=
 link mode
[    3.183859] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0cec
[    3.209353] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0cf3
[    3.237900] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x80fd
[    3.266266] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0d07
[    3.294991] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0d11
[    3.323174] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0d1b
[    3.351897] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x19 val:=
 0xffff
[    3.380623] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x8d30
[    3.408805] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x19 val:=
 0xffff
[    3.437345] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0144
[    3.465711] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x19 val:=
 0xffff
[    3.494436] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0d58
[    3.522622] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0d62
[    3.551344] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0d6c
[    3.579530] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0d76
[    3.606016] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0d7e
[    3.632557] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0d87
[    3.659641] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0d8f
[    3.687255] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0d98
[    3.714340] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0da2
[    3.744166] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0dad
[    3.773451] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x19 val:=
 0xffff
[    3.801786] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x19 val:=
 0xffff
[    3.828936] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0dca
[    3.858228] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x19 val:=
 0xffff
[    3.888063] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0dc0
[    3.917895] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0e0b
[    3.947548] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0216
[    3.977559] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0e22
[    4.007396] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x19 val:=
 0xffff
[    4.037230] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x8e38
[    4.066518] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0e44
[    4.096319] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0e4f
[    4.122872] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x19 val:=
 0xffff
[    4.152696] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x8e63
[    4.181982] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0e6d
[    4.211270] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x19 val:=
 0xffff
[    4.241094] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x8e84
[    4.270384] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0e8e
[    4.300039] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0299
[    4.326272] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x19 val:=
 0xffff
[    4.355559] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0eac
[    4.385205] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x82b7
[    4.414670] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x19 val:=
 0xffff
[    4.443957] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x19 val:=
 0xffff
[    4.473788] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0ed8
[    4.503440] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x02e4
[    4.532905] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x19 val:=
 0xffff
[    4.562192] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0ef9
[    4.591835] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x8305
[    4.619621] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x19 val:=
 0xffff
[    4.648373] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x8f18
[    4.677662] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0f24
[    4.707309] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x032f
[    4.736592] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0339
[    4.766058] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0f45
[    4.795345] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0f4f
[    4.824988] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x035a
[    4.854273] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0366
[    4.883739] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0f70
[    4.913020] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0f7b
[    4.943225] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0387
[    4.973238] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0f92
[    5.003082] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x19 val:=
 0xffff
[    5.029678] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x8fa6
[    5.058974] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0fb1
[    5.089165] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x03bc
[    5.116410] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x8fc6
[    5.142942] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0fce
[    5.172594] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x03d9
[    5.202067] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x0fe4
[    5.232259] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x03f0
[    5.261732] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x19 val:=
 0xffff
[    5.310709] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1b reg: 0x0e val:=
 0xffff
[    5.358659] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1b reg: 0x05 val:=
 0x4000
[    5.398693] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1b reg: 0x09 val:=
 0x0000
[    5.440937] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1b reg: 0x08 val:=
 0x0333
[    5.481719] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x16 reg: 0x04 val:=
 0x3737
[    5.520185] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x0b val:=
 0x301e
[    5.556120] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x0b val:=
 0x3050
[    5.592051] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x0b val:=
 0x3082
[    5.627992] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x0b val:=
 0x30b4
[    5.663857] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x0b val:=
 0x30e6
[    5.699797] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x0b val:=
 0x3118
[    5.735739] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x0b val:=
 0x314a
[    5.771678] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x0b val:=
 0x317c
[    5.807621] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x0b val:=
 0x31ae
[    5.843561] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x0b val:=
 0x31e0
[    5.886438] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1b reg: 0x0f val:=
 0xffff
[    5.930097] mv88e6085 f1072004.mdio-mii:10: configuring for fixed/rgmii-=
id link mode
[    5.931759] mv88e6085 f1072004.mdio-mii:10: configuring for fixed/rgmii-=
id link mode
[    5.933031] mv88e6085 f1072004.mdio-mii:10: Link is Up - 1Gbps/Full - fl=
ow control off
[    5.936172] mv88e6085 f1072004.mdio-mii:10: Link is Up - 1Gbps/Full - fl=
ow control off
[    6.002147] mv88e6085 f1072004.mdio-mii:10 lan0 (uninitialized): PHY [mv=
88e6xxx-1:00] driver [Marvell 88E1540] (irq=3D68)
[    6.002628] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x1400
[    6.066866] mv88e6085 f1072004.mdio-mii:10 lan1 (uninitialized): PHY [mv=
88e6xxx-1:01] driver [Marvell 88E1540] (irq=3D69)
[    6.138146] mv88e6085 f1072004.mdio-mii:10 lan2 (uninitialized): PHY [mv=
88e6xxx-1:02] driver [Marvell 88E1540] (irq=3D70)
[    6.194112] mv88e6085 f1072004.mdio-mii:10: <- addr: 0x1c reg: 0x18 val:=
 0x1460
[    6.210326] mv88e6085 f1072004.mdio-mii:10 lan3 (uninitialized): PHY [mv=
88e6xxx-1:03] driver [Marvell 88E1540] (irq=3D71)
[    6.282325] mv88e6085 f1072004.mdio-mii:10 lan4 (uninitialized): PHY [mv=
88e6xxx-1:04] driver [Marvell 88E1540] (irq=3D72)
[    6.285236] device eth1 entered promiscuous mode
[    6.286112] device eth0 entered promiscuous mode
[    6.286131] DSA: tree 0 setup
[    6.286972] Freeing unused kernel image (initmem) memory: 1024K
[    6.287111] Run /init as init process
*** snip ***

Summary: Still 4 calls to mdio_bus_scan_c22, but also *2* calls to mdio_bus=
_scan_c45, approx. 190*100 reads by the switch driver



So, the two calls to mdio_bus_scan_c45 are *new* on the Omnia with the "bad=
" commit, and seem to cause quite some extra traffic (almost factor 10).



Regards, Klaus

