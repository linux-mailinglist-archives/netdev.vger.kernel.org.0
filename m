Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6405639D9
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 21:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232533AbiGAT0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 15:26:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232460AbiGAT0c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 15:26:32 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2118.outbound.protection.outlook.com [40.107.100.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3FB84D4CA;
        Fri,  1 Jul 2022 12:26:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VrJ/ZS56DhadZ8+I8REn4qWdfF7XCt33k/tWOKIQSVfG2YIhU4r3tXEqGyAOwbdpdaAObYo7FY0TOd+N/3ZWXOoKiU+t9c0AKxOn/umtzwmi5ygShCzCVdM59N0jf2oh9HDSihpZ18c3kXLRz5PUO4iyqWuhL4Ud1W0vTcVFQfgWwR5j8VnwujpCZ5yL0NKAlul/wDcksyPxrw7OJQ7ZncLcd4PZGAHKZq4eYeq7fzBfNhbSuwp5z2X1xWKdpi0bcTHwDPLCH4xD7iu7IEisqxORhjM3hbSdhcJ406r/NuuTF5DTjk1mvRW43XjEFRzG8TKXXAyWb/kzMnrWKFbslg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UH6yRkNTL3l2eV4x+3ZKfB466PM52XOrYOv+6IJbg08=;
 b=QpyeCnIxZ9vJ11aT97VPnSLVqcaZUz0vnnMQoE8mY6yzHDz4+22zbnOGngeVy3h/Z+Mty+Ej8ZU3pPl0QtIlvODdbkZ0wuC6WDQCFfT9GvpoF237TALjpICGFyatUeXs3MbTF3VRJJuK/ZjR2LqZRi4hyhp2Uw/f/5N8Mj8r1hyNdTjynk28WMadfw+sSCdb7XnqWqDK/lh0rY2zEWxbPS2YhC5iVpeTG0ccb76XZmiDSq2H1IxSVFIk4gGMan/mz3IJBblkA/38Jhi+ULUHgIzQFEhR2Cl6H1GdnDg9qS7EzICivvOw1C4t+L9w3DxQ+cDOyBegIGkxt55LIa3jAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UH6yRkNTL3l2eV4x+3ZKfB466PM52XOrYOv+6IJbg08=;
 b=TVmrSITnzrS5Db7AeR1nuRNbOKCUlYZM94I1KXk2YMD0Pkp4eMLeL9Kgdu4f6mTa+VOWJraYfSjekQ8wEBF/EVw/E8SGxXrQxMrbsdWrLGXU92uNueFNaDQU1Ia7i2H5qCLJUSg0356niuDOjFdH16OJKLXqtLxBP7kqGj+HiiU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CY4PR1001MB2230.namprd10.prod.outlook.com
 (2603:10b6:910:46::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Fri, 1 Jul
 2022 19:26:19 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e%6]) with mapi id 15.20.5373.018; Fri, 1 Jul 2022
 19:26:19 +0000
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
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        katie.morris@in-advantage.com
Subject: [PATCH v12 net-next 0/9] add support for VSC7512 control over SPI
Date:   Fri,  1 Jul 2022 12:26:00 -0700
Message-Id: <20220701192609.3970317-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR1601CA0006.namprd16.prod.outlook.com
 (2603:10b6:300:da::16) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a269b5e1-eb28-4e3f-b0d4-08da5b9792cc
X-MS-TrafficTypeDiagnostic: CY4PR1001MB2230:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zbQMfAcV8jnUiuXx3XHgRbTEiX9PynrPGJo6Z7OeR4IcVvE0Y0ju2MmYjIFlKO+TK/BGmjyCS6YxjeemaWYMrHO9HwgBhkCqXbZ/WkQat06P2Eoz1pkfIT9ryMdmmNyWberDx2KVkANq+fCktjC+zlRYNxjHlafBg7HvT+LCHke33o1KtrMG/KLeOtyAW06g+GywSVWUBq23+R3pXmOtYoOuWt9Lsf/jS9ftceVxEkRRxbDHUUZzGMhQvT3Sq/yjTMiO0K9C5YHk6sIQHNDjzni5npkJlIHFOuwrWBrgPLEnb2ApOHjp/1HGgkBL2SQ/f+bqsBpg7GfDhQ5mo3SpCB6c3SH4w8rp2418MS5YRTLsVxHUowsGUPRDHIOD3bh0Yd7Xi1GcpSfDyS58Zk/2rQB3ZIw/5vjrtseu25KR/Hu4VmeP/nVZNIV/XNSqAeEFPq2WnK2j/aqXuHpatP7MqKF9t1XxN4b2PKn0VUfUJml79ZJv/0nhane/oK4UIaLHRY1xlA2aUvxrli7aGIWxmBid0jyLUMva9hTChek9rLJ0NTV2JKwpdiu4t5Q2abPB6BOgaTWec3HDdL+eLXkO1Cc3/jR/LPyZwxc4fL2KxU8phgJYFNN4KVkFgZBWKsqfJ//R3DfG0cpN2ajlG/uK+OSRl4BKlGQfbj79xsJCUjX/47GDJT6QZymnSmslp0eE7QSDrg+unV+sPh/JRQRKVMAjbJ+5PbpFONB0IkIIDm2Wexm5iiDB5dWUOgtdUge05AlDeB6WjS3S3uXFnT6wyYA62riACi9TYWf296bev1Gt1RjAuCn6SmXe/ebPmuWp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(346002)(39830400003)(376002)(136003)(396003)(66476007)(38350700002)(186003)(8676002)(8936002)(4326008)(86362001)(66946007)(1076003)(5660300002)(6666004)(38100700002)(107886003)(83380400001)(66556008)(7416002)(41300700001)(478600001)(316002)(36756003)(52116002)(44832011)(2906002)(6512007)(2616005)(6506007)(6486002)(26005)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wC22Qw/GnjHAK5zC195wtKAsavcfaM2RZgn3vI3e2mwV0x+swVxxHedWHC8K?=
 =?us-ascii?Q?l3JG/YkzMITjgpy3dM8jOku0dp0BadGCwCk5+lB00XmJX9/fWecIbomSUCKv?=
 =?us-ascii?Q?NhAMK+d+LJz/VrbXOuCd1A8jLwDyRVK2IA+7o7+T2J8vzkBotUR361z2KuKt?=
 =?us-ascii?Q?t3qNshQS1SJlS5rW6YjX5MZdoaCdQ5J3WEdv7Vwcedsd+wgvJZfz1i1OliFM?=
 =?us-ascii?Q?0vOCKYjUyUTvU3KK7N/79yfCauLm7Q/Z7cn0yBvisvc/1IttoR+Y0SvDpjyo?=
 =?us-ascii?Q?ib1Y8SOipdx3d3SriGxfKNQ0zlJZp0EA2aj4o8ZVpBrl3UnGTBMlCKk1Uohd?=
 =?us-ascii?Q?8+yDEewDkidYn4FphN7EnOoUUR2W2Pd8rqGztmM2+PSB5jtdwrn9s+pH1xLY?=
 =?us-ascii?Q?eQfL51hovHiDXwRf+9uTgHOyS5GeJita4ENID6Fwhdb/PyMkyy7zg9QT8mqJ?=
 =?us-ascii?Q?BQED/GOZuREx6hD/OpEf6Tp4o4oigVRkzwsL/NGX4zdv+Y4kVG2U5C4/Ms99?=
 =?us-ascii?Q?kDoziHn2DN7sA5y3JOqAHxugOHrRdQ3cc1gS6HD5RgP1SxNEXAdyX3TbIrqs?=
 =?us-ascii?Q?PhWsPU93SzljVd79aKAW00OgzMZs88ZninHS00SSLJ2Py9bx+d+QqakQlo53?=
 =?us-ascii?Q?mIbEJuQeOXLXqsQ0CVlyQ56Lrew874iZEZreZBZe3hLqq+QkkWZfsUcufHez?=
 =?us-ascii?Q?FiAYKVxoLg5rE5HmgVciirdAnsOjVSkw/WRo52ByMVYeyaKxFPKHMYQvFkj5?=
 =?us-ascii?Q?FFAsyOKAyEclVsZirQK59nEc0/9fbFLaCJ4gw3vPkE+SH4ylxKCnDyI4qkmJ?=
 =?us-ascii?Q?lJIxGLT9Ing754ipMR6gvNLVbpuFzxcybNlq9NS9kWQuETMqZzb/3fbfdKAg?=
 =?us-ascii?Q?FhF/mf/JReEW/ewTdCH4LdaGGT0ld749ax9upzDjBbQ9R+izV+7wuS8LL3Bt?=
 =?us-ascii?Q?9vjB+evB7WwYfDfVnOSrX5OO+KIaTIuN0eMQ5E1hhCWd7DFm52SAmD77iGbA?=
 =?us-ascii?Q?lxMdbN9yHWce3drXHOebLW8pTFPG2tU8FHR4BQ6OWwYRIBRg/wFmEZNcAqqe?=
 =?us-ascii?Q?f08MJbD+su4l8cTsupj2aNLr6kJR1gh/CHmTos0jRJrYZVTiO/0dm5SpOuUe?=
 =?us-ascii?Q?MEleSz+rPFPxw/9bGtafGiMV7TCKWTCuFqpuqeEKSE/havS8XxlSXJ2EaF5n?=
 =?us-ascii?Q?8NNsTgbqioeWn2IaionRetH25M7G1AZY19PH0Umszw3QD0O765FrGq1iT/Pp?=
 =?us-ascii?Q?Iz3sYk8jqwVfPxJAz4fR7VYUZkrZxLAGgBnZm34XPR594jiaMmUMVQZyu+Wh?=
 =?us-ascii?Q?WCLauqAFbz9qn71Byql4fRDhrpXh0lpNvHmZDxKsxJZnXmt7xGxi8xoyzwRe?=
 =?us-ascii?Q?4HD8g/E8UvbsKxElI/0mDTpP+yzReacr/BiQpQ/myGYa///GFPWODdBDll4t?=
 =?us-ascii?Q?Alab43upizs0/tbDzoIFbN3OcqzhsXSNwwZFzTnf7QXkqy3w9SfR5bnBw0C6?=
 =?us-ascii?Q?Avjxm01MElfvbedileFvWPgNnqIQHSzgbniVNxTAjP9y5c6IkSWcSdbqFbZk?=
 =?us-ascii?Q?orvyhlIrKkcsc0Iyv8LssHEmHw3O6qeCRZUbSOqYPpmHiYBPr5bK3RJ9oZgT?=
 =?us-ascii?Q?Dg=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a269b5e1-eb28-4e3f-b0d4-08da5b9792cc
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2022 19:26:18.9611
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fkc7lS7B5qAqGgxUIQbe9xUESzbGEC6D+lnf6kpgA2ydsS1Xik2vF4GHXHhS7DTASqJj1EimgvdQU5+376lUBgaZtPxlMJazxGibHZTBPCA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2230
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

[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Linux version 5.19.0-rc3-00745-g30c05ffbecdc (arm-linux-gnueabi-gcc (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0, GNU ld (GNU Binutils for Ubuntu) 2.34) #826 SMP PREEMPT Fri Jul 1 11:26:44 PDT 2022
...
[    1.952616] pinctrl-ocelot ocelot-pinctrl.0.auto: DMA mask not set
[    1.956522] pinctrl-ocelot ocelot-pinctrl.0.auto: driver registered
[    1.967188] pinctrl-microchip-sgpio ocelot-sgpio.1.auto: DMA mask not set
[    1.983763] mscc-miim ocelot-miim0.2.auto: DMA mask not set
[    3.020687] mscc-miim ocelot-miim1.3.auto: DMA mask not set


I only have hardware to test the last patch, so any testers are welcome.
I've been extra cautious about the ocelot_regmap_from_resource helper
function, both before and after the last patch. I accidentally broke it
in the past and would like to avoid doing so again.


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

v11
    * Suggestions from Rob and Andy. Thanks!
    * Add pinctrl module functionality back and fixing those features
    * Fix aarch64 compiler error

v12
    * Suggestions from Vladimir, Andy, Randy, and Rob. Thanks as always!
    * Utilize dev_get_regmap to clean up interfaces
    * MFD_OCELOT can be a module

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

 .../devicetree/bindings/mfd/mscc,ocelot.yaml  | 160 +++++++++
 MAINTAINERS                                   |   7 +
 drivers/mfd/Kconfig                           |  18 +
 drivers/mfd/Makefile                          |   2 +
 drivers/mfd/ocelot-core.c                     | 164 +++++++++
 drivers/mfd/ocelot-spi.c                      | 312 ++++++++++++++++++
 drivers/mfd/ocelot.h                          |  28 ++
 drivers/net/mdio/mdio-mscc-miim.c             |  34 +-
 drivers/pinctrl/Kconfig                       |   4 +-
 drivers/pinctrl/pinctrl-microchip-sgpio.c     |  14 +-
 drivers/pinctrl/pinctrl-ocelot.c              |  15 +-
 include/linux/ioport.h                        |   5 +
 include/linux/mfd/ocelot.h                    |  51 +++
 13 files changed, 772 insertions(+), 42 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml
 create mode 100644 drivers/mfd/ocelot-core.c
 create mode 100644 drivers/mfd/ocelot-spi.c
 create mode 100644 drivers/mfd/ocelot.h
 create mode 100644 include/linux/mfd/ocelot.h

-- 
2.25.1

