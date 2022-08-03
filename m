Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 919EB5886E5
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 07:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235957AbiHCFru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 01:47:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233823AbiHCFrt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 01:47:49 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2121.outbound.protection.outlook.com [40.107.244.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11E613C8FB;
        Tue,  2 Aug 2022 22:47:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=juR1RMcjKstEMyuzfZ8qm4eiveu2V8kZXgURP/vPOYDNoSWWGFcYFtLnD7puudIVYBHXI/X1E8Zpb6CgHLxzsQNOs93S4EPETArJTnCbG4RO2MepAltohLaR5X9Bqi08dOLHiMI2B/lf/sz9ESvb/7xGo/HyhB+7SotX7BaVSLs2zY8zksD8SBgyJxV3SJlzflYbYvG59/nGzXtfCP0VD4hET4yroU9WWaiX6V2mVxLNb8GWmWes6U8GAmporf/pMh2js04Cv8nG8fhLeKEOZqbTV+GR97g2mGdx9zDkr8ZpA4udQVPHZldB8S7sD+YWSxyPCXzIYdmY0flvXlUGBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K7ocOf4bzpiTpgZ1eYleDkM6K1p7oKf6YcKhPWqZKHw=;
 b=YK/wMQuk5xDXq4ti5lxd8DkPp+z+jpWgW2VBLTN7K7EKlIrDP8j80/FXO7o2ejcDeawk/wzQ/v9D4Sr0xkjAhGTX6TNhPyfNBHTW5wl4eKAg8oGD6U7TKjdaC+R77pxixYvFzMaKQViXz7rrBzgoPc/KIqxpCHXHlYo8bDXlsALuncZA1wTjxSNLjAdkqmXreAQhAKDLklVlBbMyO8xDBDbaMnJqhAc5QGnyXAMjq4120SvQeOWfGhi9TBH5cSdPNOGxMSTiNz5MsKuc4N+rVToeg3FxZ/8xB89f3YPyrzod0wNHoYWA+OwOYWtFC/DBAEkfv82D/F4BRD+yyXE6rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K7ocOf4bzpiTpgZ1eYleDkM6K1p7oKf6YcKhPWqZKHw=;
 b=BmRRS1cOdmmMhBg6GvTV7Gv2xEKdS/zPJqf9WToshEcXk8N/5piLxi1Lh2x5nxIZW1FZdn1IHBEFsMPlDeuVRsBcG3dp4NXM2ixweZ6RRc7+qnqTc+MvhJAEh22/rx0VJQatquFexAAb1HQm786ARhK7+7leXBqnQYaMiDhdsnM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MW4PR10MB6438.namprd10.prod.outlook.com
 (2603:10b6:303:218::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Wed, 3 Aug
 2022 05:47:43 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee%4]) with mapi id 15.20.5482.014; Wed, 3 Aug 2022
 05:47:43 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Terry Bowman <terry.bowman@amd.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Wolfram Sang <wsa@kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        UNGLinuxDriver@microchip.com,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Lee Jones <lee.jones@linaro.org>, katie.morris@in-advantage.com
Subject: [PATCH v15 mfd 0/9] add support for VSC7512 control over SPI
Date:   Tue,  2 Aug 2022 22:47:19 -0700
Message-Id: <20220803054728.1541104-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0026.prod.exchangelabs.com (2603:10b6:a02:80::39)
 To MWHPR1001MB2351.namprd10.prod.outlook.com (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3a1ee1dd-17c8-4a91-87df-08da7513af06
X-MS-TrafficTypeDiagnostic: MW4PR10MB6438:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2Ck7zmOdITf5lvXfiNn4UdprjQE6lMYPJd3u+ZpzmYghI1rbN3KHXyBC2e99YxFImMNdpNxS5mpQJlA9GbyHlB1R9kVQ8YZrXxtfDCsgV10hauYvALU+RVupKpMjKya7H29TY1bB7cBg64dFsagfQT2c8ulWQes98tq4LKw/LjE7rptvXQr7c64JauZ0Vub70RqVnKNOFBar0eYUQ8/TqD9XUbbjgl2ouFduqZq3kG09D7Vjt9o7moEKFnGLoSsDjgcMzq4InwfnfmczQ+RBx09QUUZ5pXhLP1bQe4ZY1f4R4eA7lFOazf78FSumjIy9xL6rfrXMGFiN1PTrcdarckEMqCYZIvL0cduzDzh7gn8glij8z0vmrh2h3VScqtevPZrjHzoTM1/ILYi4nJTTqVUm8ilBt/cAw8U6PoBJE1Iq+7KlrvZyT36l6l/l0OEfNVF5CMyJYQTLWKXwL0N0G85tnL8uKmn83+ApUXim+3kaZE8SvOOt6aUDmvXkolC57xRLY9YVAqK+DpjyK0H52SapM17QJx5m/OW3TB3LNgbZYQP4nQP77BsMbA1EkxuGXtJ3h1VbNTbTXhqo5MRmM10NJgvfG46BUA69gJLb02womRrgyPNeyDXJb4NPwWy2XQ3eQOxiF+wLirQStZfO1Lhmsgw0z8f4W3cyIgJel6fmoZdpA5m9T055IpI8z+Ozp9fxDz6MU22NurhL20v5AJhWy8N/KxQK0Jy0MSCYJ3UYb/Q7CuzRXuAg3pqwQ3S7yrm9opCwQ5cj5O/e6AlINz3UFybphwX6e25mOMKnWDk9drh0KXUnbAy/1letTUsj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(366004)(346002)(136003)(39830400003)(396003)(186003)(41300700001)(6666004)(2906002)(6512007)(26005)(52116002)(1076003)(6506007)(107886003)(2616005)(38350700002)(38100700002)(86362001)(83380400001)(5660300002)(36756003)(7416002)(6486002)(478600001)(8676002)(4326008)(66476007)(66556008)(66946007)(8936002)(44832011)(316002)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hNF955za2lixk4uLzlyxSA51rhRJ7zgMyYF8OsKTv7HKz5izxB4XHjkjiFmp?=
 =?us-ascii?Q?NvtdqVL4RSYCcYQYs81fmdupYEdclTmKJv8a7CeoVaGaEkBxhvXtVY7pxwqi?=
 =?us-ascii?Q?jRwb4+ov76O+mkAOqLCbeGCTeQPXFptKbKa8jUrSF0pAM40xWkHUpVQxlhG5?=
 =?us-ascii?Q?zGBVDKQ7GgSeybT91CdcqI8nKyXmpmJt4f8y3ovXVhAgG5x7axOUjVk0bryG?=
 =?us-ascii?Q?+GmLiWSF1MaNqK4DWHWF/Pp1G2yNVWipbJjylnC8+3KEyAsEpvudnk9J+W2f?=
 =?us-ascii?Q?I60X0kMmT/63GbU5v8rIqzklaNGx+2IjEiMgARGWlvswIsNGGrl3NagNVLft?=
 =?us-ascii?Q?dkh6VUUuKzb3igNYJdLnafC4rCA0+vyvGr/4wPQoeSaUFselWAakIYxyC6St?=
 =?us-ascii?Q?Cvjpw7TJxx0xbu+qMl+BDWbM7bOu+Yjw+j6tKSjnBJ34BpcVwSG9N4WaHxun?=
 =?us-ascii?Q?PvQKrxPscwYS3d0iC1Ps/O6wfcrDTbzT4rb8c7EqUn5NWMO9s+YXfzNo6xU2?=
 =?us-ascii?Q?ktYDOTgBY/ZpleeJiITHzaobwgF0fgz35GcrNKYMRfJhZnXHKFQKt/XNSRuG?=
 =?us-ascii?Q?XfF8GrlHx6xdzruOWx7dpOBOC+05ovJQjIIk48rGFhVsEozNMRQpgNIAKNlY?=
 =?us-ascii?Q?B8edAZNiYHVkiFvc9cePgPkeZHMHG2oPjD658nhJ10VG9JINlJIJL+LdYPhf?=
 =?us-ascii?Q?zy4s1wSmctjGo8Pcqj+6ODmRn54Zaj/kxEFijDsGuze6rHNbMDltvYXF2lXE?=
 =?us-ascii?Q?9DkvMBBdFwx75GoHK1Ov+gCturCIGOBVydQAe35CCLs/r0yLtv+RAoveTwJa?=
 =?us-ascii?Q?zLN6f6mHbHUU6yywqpucBaqT3n+1QFlwirFN+3KB+EwMjwfVyV3W0BONPlli?=
 =?us-ascii?Q?9zU6+6UDEop56D19Ogvol6ITeM52zgXbQyOOinTG4FaHyXEhVCwrqsusZVb/?=
 =?us-ascii?Q?2wzQ20AVb4cZSXZHjfOvbKcA1mWpKtc4s3R5pzFK53Ey8cbZgVpPdjyoCuCi?=
 =?us-ascii?Q?sCyMQYK8F/BSH8vt/wt4/Z8akE01Wiph/O2TxkC/uqpyjwnaflieCWsT2iCC?=
 =?us-ascii?Q?qkogOsu+UXJbUrsjbf/UJDa+XflueWVnQCzXa3mRWJGABQia/i2AaRI66ZVO?=
 =?us-ascii?Q?4cdGW8Rhm0kjq1USV9HY8EVxUPsHhFgWXCwtZV2hwyVkCC0i2jrTLdMeEjjR?=
 =?us-ascii?Q?A89q5yHfk6nz/6/1Sxx76pA7UBQ0z8a0sbHXvAk3of+/vGq2xbJGZjpDNFAp?=
 =?us-ascii?Q?2s2dlp4JDtdjjWsMVkdsw+2tvXQN0Uwu2Y6MZR8xtJJU4w7txukrb0rFxNRo?=
 =?us-ascii?Q?VakTp6q2q5aQrKd75gPbDyOkevxM11jpoZ3V7y/4EmE5bMeqLLOoFv08WxCc?=
 =?us-ascii?Q?Gu//yQonYCvu9/yYM8TDt19cbvxYV/7uVWRkLKworeW0GuevTIC5R/yYv9DJ?=
 =?us-ascii?Q?T1ECGG8YjKd7V+lRP9ElBao8jkCgGkDI0k6b6BFRlZRZgAUVr1sG7SC3iUBd?=
 =?us-ascii?Q?IrraAfMf+YEqvrW2Py9QoFFcX56QU/pYCwTtYNxPdPW9RZT3uk/UfwFpouPM?=
 =?us-ascii?Q?LtSSfuxHBOmzReA/I9bsh01U8hiS9pq8xMfGT3iCVd6GVxeve15bR1ZqG0Mx?=
 =?us-ascii?Q?9y+vt2Q2teQiEWmhQyKIiaY=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a1ee1dd-17c8-4a91-87df-08da7513af06
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2022 05:47:43.0115
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ugG+k53l6KWeXWn2I8GATEjigHPvIS3Lasju8HckgYOyoEnEDBHA8Gi3Lt57C4LWkdt9vqjCEhcVGtPyf3BCtT9D482YkXy0oIQizswmCy0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6438
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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

I verified module functionality with modprobe ocelot-soc;
modprobe pinctrl-ocelot;
modprobe pinctrl-microchip-sgpio;

I only have hardware to test the last patch, so any testers are welcome.
I've been extra cautious about the ocelot_regmap_from_resource helper
function, both before and after the last patch. I accidentally broke it
in the past and would like to avoid doing so again.


RFC history:
v15
    * Add missed includes
    * Fix punctuation and function convention inside comments
    * Utilize spi_message_init_with_transfers() instead of
      spi_message_add_tail()
    * Remove unnecessary "< 0" comparisons
    * Utilize HZ_PER_MHZ instead of magic numbers

v14
    * Add header guards to include/linux/mfd/ocelot.h and
      drivers/mfd/ocelot.h
    * Lines extended to 100 chars (patch 9/9)
    * Remove unnecessary "dev" and "spi" elements from ocelot_ddata
      structure
    * Add doc comments for ocelot_ddata
    * Add Reviewed and Acked tags
    * Submit to MFD instead of net-next

v13
    * Suggestions from Andy for code cleanup, missed includes, forward
      declarations, module names.
    * Fix x86 allmodconfig build
    * MFD module name is now ocelot-soc
    * Add module names to Kconfig for pinctrl changes

v12
    * Suggestions from Vladimir, Andy, Randy, and Rob. Thanks as always!
    * Utilize dev_get_regmap to clean up interfaces
    * MFD_OCELOT can be a module

v11
    * Suggestions from Rob and Andy. Thanks!
    * Add pinctrl module functionality back and fixing those features
    * Fix aarch64 compiler error

v10
    * Fix warning by removing unused function

v9
    * Submitting as a PATCH instead of an RFC
    * Remove switch functionality - will be a separate patch set
    * Remove Kconfig tristate module options
    * Another round of suggestions from Lee, Vladimir, and Andy. Many
      thanks!
    * Add documentation
    * Update maintainers

v8
    * Applied another round of suggestions from Lee and Vladimir
    * Utilize regmap bus reads, which speeds bulk transfers up by an
      order of magnitude
    * Add two additional patches to utilize phylink_generic_validate
    * Changed GPL V2 to GPL in licenses where applicable (checkpatch)
    * Remove initial hsio/serdes changes from the RFC

v7
    * Applied as much as I could from Lee and Vladimir's suggestions. As
      always, the feedback is greatly appreciated!
    * Remove "ocelot_spi" container complication
    * Move internal MDIO bus from ocelot_ext to MFD, with a devicetree
      change to match
    * Add initial HSIO support
    * Switch to IORESOURCE_REG for resource definitions

v6
    * Applied several suggestions from the last RFC from Lee Jones. I
      hope I didn't miss anything.
    * Clean up MFD core - SPI interaction. They no longer use callbacks.
    * regmaps get registered to the child device, and don't attempt to
      get shared. It seems if a regmap is to be shared, that should be
      solved with syscon, not dev or mfd.

v5
    * Restructured to MFD
    * Several commits were split out, submitted, and accepted
    * pinctrl-ocelot believed to be fully functional (requires commits
    from the linux-pinctrl tree)
    * External MDIO bus believed to be fully functional

v4
    * Functional
    * Device tree fixes
    * Add hooks for pinctrl-ocelot - some functionality by way of sysfs
    * Add hooks for pinctrl-microsemi-sgpio - not yet fully functional
    * Remove lynx_pcs interface for a generic phylink_pcs. The goal here
    is to have an ocelot_pcs that will work for each configuration of
    every port.

v3
	* Functional
	* Shared MDIO transactions routed through mdio-mscc-miim
	* CPU / NPI port enabled by way of vsc7512_enable_npi_port /
	felix->info->enable_npi_port
	* NPI port tagging functional - Requires a CPU port driver that supports
	frames of 1520 bytes. Verified with a patch to the cpsw driver

v2
	* Near functional. No CPU port communication, but control over all
	external ports
	* Cleaned up regmap implementation from v1

v1 (accidentally named vN)
	* Initial architecture. Not functional
	* General concepts laid out


Colin Foster (9):
  mfd: ocelot: add helper to get regmap from a resource
  net: mdio: mscc-miim: add ability to be used in a non-mmio
    configuration
  pinctrl: ocelot: allow pinctrl-ocelot to be loaded as a module
  pinctrl: ocelot: add ability to be used in a non-mmio configuration
  pinctrl: microchip-sgpio: allow sgpio driver to be used as a module
  pinctrl: microchip-sgpio: add ability to be used in a non-mmio
    configuration
  resource: add define macro for register address resources
  dt-bindings: mfd: ocelot: add bindings for VSC7512
  mfd: ocelot: add support for the vsc7512 chip via spi

 .../devicetree/bindings/mfd/mscc,ocelot.yaml  | 160 ++++++++++
 MAINTAINERS                                   |   7 +
 drivers/mfd/Kconfig                           |  21 ++
 drivers/mfd/Makefile                          |   3 +
 drivers/mfd/ocelot-core.c                     | 157 ++++++++++
 drivers/mfd/ocelot-spi.c                      | 296 ++++++++++++++++++
 drivers/mfd/ocelot.h                          |  49 +++
 drivers/net/mdio/mdio-mscc-miim.c             |  42 +--
 drivers/pinctrl/Kconfig                       |  12 +-
 drivers/pinctrl/pinctrl-microchip-sgpio.c     |  14 +-
 drivers/pinctrl/pinctrl-ocelot.c              |  22 +-
 include/linux/ioport.h                        |   5 +
 include/linux/mfd/ocelot.h                    |  62 ++++
 13 files changed, 799 insertions(+), 51 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml
 create mode 100644 drivers/mfd/ocelot-core.c
 create mode 100644 drivers/mfd/ocelot-spi.c
 create mode 100644 drivers/mfd/ocelot.h
 create mode 100644 include/linux/mfd/ocelot.h

-- 
2.25.1

