Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD100546E4C
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 22:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350522AbiFJUYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 16:24:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350676AbiFJUY3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 16:24:29 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2123.outbound.protection.outlook.com [40.107.96.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94836308AFB;
        Fri, 10 Jun 2022 13:23:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YMbA4nyNW/3+/Gnh8ApucSOBWanaHmfDdhhKbZRLNIZ7jN0beMLgtUtBkpZqxMtHG+h3GIpAUCDrYnI8DqY3wQzQGa+LBjy77Kk1KTfTtrqkBbzA93wqT87n/t0o/uDbtZMqTQD+uKubZEfh6jPABYD/FLCckgO9rd7TR+L6uPxnL8Bdh3LEhW4/HH32V+qwL2v3LDfrUqnwvm1vPJsrxLqcGhOc8iSalgbPVGUav74bjyOVm5XBoNpnrRLvV03xv+sJPi8VNn7pcAc23nKJTUqSmn4ZUToq0YUycaJtN4KmCjrtrPd48tuDjbkzAIfMrwE2mngTNLh9xm9XUlgi+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/3GhMLbfKjzgKhc51tVzzYTb9pE0J5edXmqZ72crJwE=;
 b=KxGwsfjd6bguU20A4OCKlfaHu6O4tJBVHb2NETdi7+mISViHfA9EiKqZIBHgtNnK/0oXIHoRz1VRBsbQZFqpHJUstZIq1xhp1UtEVePKQHEkK3ota72J8d1evuIqnyEqRCfG+8i42tc0Mx5WscozUlBUdJK81fnZmTgSuuaemDOgI0Pd2o/65mkJC4xCF3EFdZc7wzXTC6ji0mr2b53zejkBEE43rNeEFq/F5h/EneYuH3G8Fb7OTHzAiZ2u0udhcCL8RWyQZHsMM6ijQebpRA9bTbizuArzmB+fRHM+9UjeIOPlYtig1ei4Oz0RsZKu8mu7NKJaCjYCahor+VA04w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/3GhMLbfKjzgKhc51tVzzYTb9pE0J5edXmqZ72crJwE=;
 b=z1DdHelOyTUPd5/LuD4UTe/SnU5F/1Z3XZz5oghhcha1CwHgLmuPQ2vR6EVGYWlDG8XJP5qJIBhCvZwpTsnbCLvXNlKM0rajRFiOTObu3+QTqvH4PlNMgLf6zfqwvE6+MNLmoD9aGqiumxZVG6F/K5Ua9d0U2U8DI3yef/K0Jtc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB1629.namprd10.prod.outlook.com
 (2603:10b6:301:9::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Fri, 10 Jun
 2022 20:23:45 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b8c0:76a2:4c89:d10f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b8c0:76a2:4c89:d10f%7]) with mapi id 15.20.5332.014; Fri, 10 Jun 2022
 20:23:45 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-gpio@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH v10 net-next 0/7] add support for VSC7512 control over SPI
Date:   Fri, 10 Jun 2022 13:23:23 -0700
Message-Id: <20220610202330.799510-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0246.namprd04.prod.outlook.com
 (2603:10b6:303:88::11) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6a00a233-4534-45da-7e57-08da4b1f1e13
X-MS-TrafficTypeDiagnostic: MWHPR10MB1629:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB1629A2C1EA783C418806EB4BA4A69@MWHPR10MB1629.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w1XUS+j6A8FQjOKkbgJ+B1k0ONspVcdQfxPcpVUiP+uWhcnT105+0w93j7Xw+13qaqlv2L4MNrsuGvaxgX9vPiLNnXcZgfQxNhWbkEa5ibvoa+VmVHUkNSovNKL/LvXATLkZugXi5cibaNrViGrYwjr0hhVjDXJvTXY75eg0ZXBx7vth7bl4KMyz9cYz/sRoKXjhq3V9ONFKfXy8mqYppZ2lyn6w13D3K38uovONRmThTXJr0dK+ip2GCXFq3tjE+4KvzgT3tqGH5G8w7OSGCiUEva4uPhkzH8GLE7dQJN5hJEDvGcB7HvcdFeu3NhqCDzQRDgE50v819zh2LBE/EqrfWig0AWU7dhBptb1TAasO2TaAyN2LKoEXmFUlTAxckPJ21pYoLG0jyVTj+LP4QQrzd0K/c2uQgIo/AkgvfMPRPUaNc8yPgWScttPWAobLLJMH818uWo6q3tU8aEFIStPWtlpuTBy5XzYqARLYB0x8aVExLuDTscK++t2BJQyGbC8wP0agx3Vizvx+6yFdIHNvKCGA3NL0h8vyyolsQ5tcVpvVnf7XSFg7HQdY0ORtgXNHFDFRQtcEETtimsCzv7juuwAfrh7fDNuV8OKnPsbtnFoRqafnGEwUNd3NEuT1JpPW/kYQx8mRnGP0pxVLAlgJKse7DykL1+ARycv/BSOoQGEXD5WLoqbTQywtdafImoDT8/2Pi2fVd/PAIL6ZWA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(39830400003)(396003)(366004)(346002)(316002)(83380400001)(2616005)(2906002)(1076003)(6486002)(54906003)(8936002)(36756003)(6666004)(52116002)(6512007)(6506007)(26005)(186003)(41300700001)(86362001)(44832011)(66556008)(66476007)(38100700002)(38350700002)(5660300002)(4326008)(7416002)(8676002)(508600001)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?M/FgyClUYi42p4eLsMBn/NtUD30peEd2fpu3AOghQt70k507HU6janG1ewt/?=
 =?us-ascii?Q?1kv1/t+PmDBTROUq651T8FbVhL3YIjfHtDFbvEv1fr8sBbe0TXsoobQyUeAH?=
 =?us-ascii?Q?bSuKtNC8JYA3eImxOyGSy6pzdYAdg9qAQEU8N/jNOq+IyUH9JVqYML11MxMH?=
 =?us-ascii?Q?08d6su0VMAXpnAQn0/a1R8Jt+6R/KsQ5j2UEL1/t79Qm+IlFQJeDa9hCO25Y?=
 =?us-ascii?Q?jPwkS/1c+9rxbuknzC2/KiTwB9TsSE3FV902UgHsSP7HgH/MUIDR7JUXNit2?=
 =?us-ascii?Q?8fiAP0UxZiqz28fNbiCB2e2doCIGAX3tIZ1UXmWUguTi3dFGe4EJQR1jkyig?=
 =?us-ascii?Q?AmsJ0dxHZquKoqlEBbL1DoGTwala8mlU4Us5uQqgkmwEh7QfOqDziJgDhy5X?=
 =?us-ascii?Q?WlTCHYHmO4V78bjdwkdjwRsIfCfK14+RzDpOHBeeBA0O9t53sbw5lcKOi6VA?=
 =?us-ascii?Q?V0vGHh+HiC88MBIv9xwKX3rMbnJwlxWgkb6nMUHjLa7W5YN/0T/y7a2/GYTo?=
 =?us-ascii?Q?4CGL6Cz/ruTGR+YPjoWpBmxbpPv92B+5lH3Q8DDJm3dzQrt3V4z0mrMFrTl1?=
 =?us-ascii?Q?KgKmrjWFydAoNiiZVbGyN+2B8Wcz6XhHi4S7UPdO/rTLfEGn11BFcjiIf94O?=
 =?us-ascii?Q?bzE9KdKPeH3l6l+gZQ/XH7kyuEP5xJXkU2BdXJL/zQzADpHQfhT+1WvoSasU?=
 =?us-ascii?Q?AmRrPJgz4a8/4url93OMNFal6tHB43yX57PakDSKQ6dfx+VlSsxHpQllytKB?=
 =?us-ascii?Q?3L0M4e9PUyI+jq633mmWFT+KCxsYeDHi2Hawdm3DzlonG8rdibpOiPHcBACm?=
 =?us-ascii?Q?EnYbMZkTjLJxIfYbuOi+bIcBGrXNYTFz0i+FkvEhnhzigeCYp4KGMHTTww+w?=
 =?us-ascii?Q?u41pvVYANzVeZgLntBURVitgN+cvEqalppnOKm6eybnAykf5MvPr0X1m6RGH?=
 =?us-ascii?Q?F03N2CJINAyvXXAtxgQZgLlR1gS8xQmq2xUbpuHgqV9GQ9AWQd2w9RV4Lxeg?=
 =?us-ascii?Q?zFbfAZmmeRKtkzXej3mkh/Q0CTyMEAjaTHGdSHh0i91WgkiP2CWxZ3YEspZP?=
 =?us-ascii?Q?Jb2DdnDGUdz+/Ex4cKYi1ZXxHHRZzTqshQaMxsskMc639ZAr481CrLsEIfnI?=
 =?us-ascii?Q?aKNmuA1/slAR2OffXFon5+2VLlmk5xwfUhl6Bwemm/UFG2Ic6iijOlS6uLpn?=
 =?us-ascii?Q?xq3/2YtbkZmVhUGE03TZT0meqgnE1ZAYLq3I7zecktKkbF6B/L3gMy0RDt4U?=
 =?us-ascii?Q?agP1wrHMGq1h6yCmhJd+Ttdv0LtxzOhQv9eFuchxcqT9yaUCPHbUDoYdVFCM?=
 =?us-ascii?Q?n+r+tlGTcXjdRZClKRCCk3b1+YTpDgnkmte8alUlydTK4laDsp6QF0KgvnIm?=
 =?us-ascii?Q?BR+MVBiLZ/Nai9gNdXort4yj2UC7ERbv/jjDW4wcHcqz28iar9u1rOXMWEAf?=
 =?us-ascii?Q?pdIx8X+IjyqrjAVtsW7OY+mVv6dH68x8vZEgV58PR83mDkUDMtsoUF5Tnjzt?=
 =?us-ascii?Q?o576OjVRhY/IGBajpM9SEJGaTP7wEq0YJMhymbcABNdurdE7zye5iTiccusL?=
 =?us-ascii?Q?fwjHw40cfQbguKpfVOrRylBhqwUPzHZpEvfvGduuOmw7h/+W47q4oFKvxbto?=
 =?us-ascii?Q?PSl+FsD3j3F9QULfEWp+11eB/uQhW0FJqMFrm4ZVSfqh5n43IqcPOJbSAgvv?=
 =?us-ascii?Q?RtyZEyHBJShZlgT7rM+mJDybtwKec4J+EdMLOikKedHFdwwi8tHzxCht9ups?=
 =?us-ascii?Q?rai9qzPIzVPdHG2BGSb9VMw5SVAaKWlmcraMoK7+IYLtAWm0QOdz?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a00a233-4534-45da-7e57-08da4b1f1e13
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2022 20:23:44.9822
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mdyNrkhxNHoCjFOtccT/PZT/M+NRTDkYzn1S43jFBVPZCt5JDlgF6ls+wwFveVue5i3zTLlAR82NmWOerEqSiqHKm82YsZK3sNIRA+vqdm8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1629
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch set in general is to add support for the VSC7512, and
eventually the VSC7511, VSC7513 and VSC7514 devices controlled over
SPI. Specifically this patch set enables pinctrl, serial gpio expander
access, and control of an internal and an external MDIO bus.

I have mentioned previously:
The hardware setup I'm using for development is a beaglebone black, with
jumpers from SPI0 to the microchip VSC7512 dev board. The microchip dev
board has been modified to not boot from flash, but wait for SPI. An
ethernet cable is connected from the beaglebone ethernet to port 0 of
the dev board. Network functionality will be included in a future patch set.

The device tree I'm using is included in the documentation, so I'll not
include that in this cover letter. I have exported the serial GPIOs to the
LEDs, and verified functionality via
"echo heartbeat > sys/class/leds/port0led/trigger"

/ {
	vscleds {
		compatible = "gpio-leds";
		vscled@0 {
			label = "port0led";
			gpios = <&sgpio_out1 0 0 GPIO_ACTIVE_LOW>;
			default-state = "off";
		};
		vscled@1 {
			label = "port0led1";
			gpios = <&sgpio_out1 0 1 GPIO_ACTIVE_LOW>;
			default-state = "off";
		};
[ ... ]
	};
};

And I'll include the relevant dmesg prints - I don't love the "invalid
resource" prints, as they seem to be misleading. They're a byproduct of
looking for IO resources before falling back to REG, which succeeds.

[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Linux version 5.18.0-12138-g89bf3be45d34 (colin@euler) (arm-linux-gnueabi-gcc (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0, GNU ld (GNU Binutils for Ubuntu) 2.34) #702 SMP PREEMPT Fri Jun 10 10:12:20 PDT 2022
...
[    1.923330] pinctrl-ocelot ocelot-pinctrl.0.auto: DMA mask not set
[    1.923498] pinctrl-ocelot ocelot-pinctrl.0.auto: invalid resource
[    1.935102] pinctrl-ocelot ocelot-pinctrl.0.auto: driver registered
[    1.954499] pinctrl-microchip-sgpio ocelot-sgpio.1.auto: DMA mask not set
[    1.954708] pinctrl-microchip-sgpio ocelot-sgpio.1.auto: invalid resource
[    1.966000] mscc-miim ocelot-miim0.2.auto: DMA mask not set
[    1.966154] mscc-miim ocelot-miim0.2.auto: invalid resource
[    1.966307] mscc-miim ocelot-miim0.2.auto: invalid resource
[    2.995959] mscc-miim ocelot-miim1.3.auto: DMA mask not set
[    2.996118] mscc-miim ocelot-miim1.3.auto: invalid resource
[    2.996274] mscc-miim ocelot-miim1.3.auto: invalid resource
[    2.996286] mscc-miim ocelot-miim1.3.auto: error 00000000: Failed to get resource

Lastly, I removed the Kconfig tristate patches for pinctrl and ocelot-mfd.
They broke the last RFC build, so I'll probably want to add that at a
later time.


I only have hardware to test the last patch, so any testers are welcome.
I've been extra cautious about the
ocelot_platform_init_regmap_from_resource helper function, both before
and after the last patch. I accidentally broke it in the past and would
like to avoid doing so again.


RFC history:
v1 (accidentally named vN)
	* Initial architecture. Not functional
	* General concepts laid out

v2
	* Near functional. No CPU port communication, but control over all
	external ports
	* Cleaned up regmap implementation from v1

v3
	* Functional
	* Shared MDIO transactions routed through mdio-mscc-miim
	* CPU / NPI port enabled by way of vsc7512_enable_npi_port /
	felix->info->enable_npi_port
	* NPI port tagging functional - Requires a CPU port driver that supports
	frames of 1520 bytes. Verified with a patch to the cpsw driver

v4
    * Functional
    * Device tree fixes
    * Add hooks for pinctrl-ocelot - some functionality by way of sysfs
    * Add hooks for pinctrl-microsemi-sgpio - not yet fully functional
    * Remove lynx_pcs interface for a generic phylink_pcs. The goal here
    is to have an ocelot_pcs that will work for each configuration of
    every port.

v5
    * Restructured to MFD
    * Several commits were split out, submitted, and accepted
    * pinctrl-ocelot believed to be fully functional (requires commits
    from the linux-pinctrl tree)
    * External MDIO bus believed to be fully functional

v6
    * Applied several suggestions from the last RFC from Lee Jones. I
      hope I didn't miss anything.
    * Clean up MFD core - SPI interaction. They no longer use callbacks.
    * regmaps get registered to the child device, and don't attempt to
      get shared. It seems if a regmap is to be shared, that should be
      solved with syscon, not dev or mfd.

v7
    * Applied as much as I could from Lee and Vladimir's suggestions. As
      always, the feedback is greatly appreciated!
    * Remove "ocelot_spi" container complication
    * Move internal MDIO bus from ocelot_ext to MFD, with a devicetree
      change to match
    * Add initial HSIO support
    * Switch to IORESOURCE_REG for resource definitions

v8
    * Applied another round of suggestions from Lee and Vladimir
    * Utilize regmap bus reads, which speeds bulk transfers up by an
      order of magnitude
    * Add two additional patches to utilize phylink_generic_validate
    * Changed GPL V2 to GPL in licenses where applicable (checkpatch)
    * Remove initial hsio/serdes changes from the RFC

v9
    * Submitting as a PATCH instead of an RFC
    * Remove switch functionality - will be a separate patch set
    * Remove Kconfig tristate module options
    * Another round of suggestions from Lee, Vladimir, and Andy. Many
      thanks!
    * Add documentation
    * Update maintainers

v10
    * Fix warming by removing unused function

Colin Foster (7):
  mfd: ocelot: add helper to get regmap from a resource
  net: mdio: mscc-miim: add ability to be used in a non-mmio
    configuration
  pinctrl: ocelot: add ability to be used in a non-mmio configuration
  pinctrl: microchip-sgpio: add ability to be used in a non-mmio
    configuration
  resource: add define macro for register address resources
  dt-bindings: mfd: ocelot: add bindings for VSC7512
  mfd: ocelot: add support for the vsc7512 chip via spi

 .../devicetree/bindings/mfd/mscc,ocelot.yaml  | 160 +++++++++
 MAINTAINERS                                   |   7 +
 drivers/mfd/Kconfig                           |  18 +
 drivers/mfd/Makefile                          |   2 +
 drivers/mfd/ocelot-core.c                     | 175 ++++++++++
 drivers/mfd/ocelot-spi.c                      | 313 ++++++++++++++++++
 drivers/mfd/ocelot.h                          |  28 ++
 drivers/net/mdio/mdio-mscc-miim.c             |  27 +-
 drivers/pinctrl/pinctrl-microchip-sgpio.c     |   9 +-
 drivers/pinctrl/pinctrl-ocelot.c              |  10 +-
 include/linux/ioport.h                        |   5 +
 include/linux/mfd/ocelot.h                    |  32 ++
 12 files changed, 754 insertions(+), 32 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml
 create mode 100644 drivers/mfd/ocelot-core.c
 create mode 100644 drivers/mfd/ocelot-spi.c
 create mode 100644 drivers/mfd/ocelot.h
 create mode 100644 include/linux/mfd/ocelot.h

-- 
2.25.1

