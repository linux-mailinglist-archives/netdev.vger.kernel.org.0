Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD547567898
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 22:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231812AbiGEUsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 16:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbiGEUsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 16:48:13 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2113.outbound.protection.outlook.com [40.107.92.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3495B875;
        Tue,  5 Jul 2022 13:48:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BYWSmCgWauno1PTEdTEEGR97NN6ntKPDUckslCIOCXayHfyAmyzlqRhROFcIh3IRKSqyZkOw8l4GMC5hNQ8pkTV42VPd6tZFLRObSchACThT8c04lpzSFBnSwilWjojwEVo1Hwk36zhoHqM1PiSidV65jzcwHnDsW/zH07bHlaHPveZDGj24bOt9CTUeh7Zeg0h9p74eRdkJwLzNgFZwtbql43cC07HTYYwFi/edaqBjSarJPG+rReFryNgOIJ4nQNZxeQTmpSojlac1TzpARtfT2KbV6gR9cI9S2djfIpou43YUAe34f+nM6bxQttR3BDmaw/xdVMRb2eszBI8jgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5YNAfpS4GMvpSVUl9l1SCyJw2P1X5HGidtvE9RYJgQ4=;
 b=DsiG569VveNZ0B2zysxHWlvvCFz/jSfwaxmLhbBgm+TBbswRRBG0N9oUNnim1xODgZFI67qqZB+KDpwad4qxTSf7G50Ub7uUglPVWjUoZvOXpSJPf+MM0mt7yIdqhMWvxDS+y6fPkEPhc/QYsWUrBj4LOMNUvH9L/s3LQ8m6JTAuODfJak+eHhnBtnkd4FDZMuO5P64yRQaW2nuh1zo7fY9ZiihbQNYjRkuSAspsLueaUDCoGbeoBdBP/kuixtucejBW8Npokkuh9uoiBMoZyst71UNSHbfWG4otKkGhtJr/zwOQGvEKGAUsN7ldoBaMXbu86EKRcZZw6v6/JeO0rA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5YNAfpS4GMvpSVUl9l1SCyJw2P1X5HGidtvE9RYJgQ4=;
 b=C1LchXen35rly8BEvhe55mj/nGLRPa5sYCJRYhJfxw+zWiMRywGjxjEAwYdQbqVo5veYUnJdjRhd76tgKXdXwh0Fllo/UeBuieEwmmSAKX5G2A2dihJ12cIeTr+2EhSmp2gRgB4dsR0P1Yx4vuz0Ttd3u0oX2/Brb2vZEfgbtyE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BL0PR10MB2898.namprd10.prod.outlook.com
 (2603:10b6:208:75::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Tue, 5 Jul
 2022 20:48:10 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e%6]) with mapi id 15.20.5395.020; Tue, 5 Jul 2022
 20:48:10 +0000
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
Subject: [PATCH v13 net-next 0/9] add support for VSC7512 control over SPI
Date:   Tue,  5 Jul 2022 13:47:34 -0700
Message-Id: <20220705204743.3224692-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW2PR2101CA0001.namprd21.prod.outlook.com
 (2603:10b6:302:1::14) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1804e99f-942d-4ba6-796f-08da5ec7ab95
X-MS-TrafficTypeDiagnostic: BL0PR10MB2898:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eka7/5pCWNzDs3RS4NLUELQ00sjzyOaxxixG9iBWc+l2cTaoqJIwArcqpclbgBbcGVu51FWjql9g4yqDbCH5jgHDG1pplEwL76V+Liprc+FQQLJagr3YkEmy1ZZVyHZ1zGMFtDoHDa2SlfIRnp6yk5yxDyznC03a6yR8H3msyvtKY6srUf6TSzdMuqeKsAE7PGjXW2LRHdkIp3OVppf1Ztu4LdQo3crEIm2Ru5f+yXNck5zGE05pMwOEDBleAhy/gWCZ1TuZey5/ZhsMGMqkDdT4fcJ5+0Us1Nqhq6NaIxj+sV4Sw5sZelE0YL6j+1jCPiMIvBn/RNQ+qmQKGoylPHj65X/7i6oN9jRqdyFI+dWZRuPE/14Xj5bWRxasIwMUfccWN5nUyW9oUslJt6TWF5+Gf8YY5+52xuS7i8w36Qe6hPYkvOYFiN4YhL8cFtUOJZEq7CQ2T5fMx2jRjx0Ypm2pKazFoFhLx1EV76ufWMjv6/C8A76AObEnsgz/t3O3T1xAyZCRTXD6EMF9nw4a0JZvBAkn7rTwYIEfQWGSfKjpDqRyiq60zSAdHb4o158srpFo0OI4bEp6NMVORzf2GwKD2blKPIoDuslsm+p+7r8CjOkrSn+tuVddzfyB7yW453j7krea/xcc/3NkwBMtrPjK+Q5+06rXRMUlTiFFCdXh1nNvHRo4RtR0I+D9Gj60J9b31x8pWz6FAjm87aZ6TMRvDQRGuPMST/ej7viL4SR0Qwfk2QjlBcEmrHcDHZ7PV8uFaGOqw1GKHYDwsfPcr8prhLUKpA6Yx2kK797kBDCVbIPrNXSILe9o6uz9yEhN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39830400003)(376002)(346002)(136003)(396003)(366004)(478600001)(38350700002)(66556008)(66476007)(8676002)(66946007)(4326008)(316002)(38100700002)(186003)(107886003)(2616005)(1076003)(6486002)(41300700001)(26005)(6506007)(6666004)(52116002)(6512007)(54906003)(83380400001)(5660300002)(86362001)(2906002)(44832011)(7416002)(36756003)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jml3GlJx05Op/c6/OVodp0CZY45dAPgXDPPsFd5e5H/qCPd3fS9SQiwoJLuT?=
 =?us-ascii?Q?OTgfUcxAaD29Slu9pvpGo+sixt2fNT8R31tE+H448Y9TXd3FOJfzG6Dbhclg?=
 =?us-ascii?Q?CQ+SXL2/o1j6IK/isUXIj/DdE5+Ef0k/607/70TbJ2mX+/xvweTViR4pM6GZ?=
 =?us-ascii?Q?phkF37NW4ZBvg2yoXM1ULyrnmSy41dpPQk3XfU3zLP684pIxvkQvDGm9uZd3?=
 =?us-ascii?Q?1ddI0n5+y0jEdfLQlNuAt0VhWvRXXx84M4d/qaeZER3gDfoMAabtPON7z7en?=
 =?us-ascii?Q?OkdqYY8Rl4LzXKAbawBZEOMT9UVeA2qqo7yq4q0iZTisavdylg6/7EHEKRsG?=
 =?us-ascii?Q?NPOnVwhZYTgmZ1AMkCk+mV+IlBdmsclZBm90HSvG1EkkYFzYShV4DosrHIu9?=
 =?us-ascii?Q?rcfT0v96tJ9bb8L9brIgq5wHRY2B0ieR7sCHDUItA1rp5wtQTHxq8ieanjsf?=
 =?us-ascii?Q?wlHsfDzHn+B0e3LuMBE33xYj+r27oZdLHQlPeNL4M87EmQ+KnIbfukQd/dMA?=
 =?us-ascii?Q?bQZPHzTpebdlx9sQ/SYYMmHwXopy5ytTkpUXiQvBwG1XglbsW+VrHas1cyhs?=
 =?us-ascii?Q?lfFt49NthxmSzfBGQqeX3BwV5Wbvwd/FKciaEVfk7ijTEHR/5BCA0yW17O8t?=
 =?us-ascii?Q?RKCe113+X8xHVQ3Objy7nc33aLUBzelTPXk37de7kcrbbAgyPP8t0oAY6Ja7?=
 =?us-ascii?Q?SkE4hEUoXPTfnIkUWjVB4VcSDtkppU3bf6uhKXURziZhN2/ekvBS+kTdwWW9?=
 =?us-ascii?Q?6PykjY+y5Tq5/MR2TeUGW2BAvG0Tw95RcRLSn5F4hWheVtbahpmhtOIaZ/4i?=
 =?us-ascii?Q?tosGB5lEAlGOSxyqZU0by5ZeegJKv1PmY3rsL1Olv0r9p8WlCnEFePbsFtxk?=
 =?us-ascii?Q?tW9njqKzbiLw4lY50COpVHtqp92tr52Bd7AUDJegxswlkgBCvMAseQSjhyQQ?=
 =?us-ascii?Q?vo07jm90uq5oX6i+YVdUig+WQH8KXBzoclfkPcA57xjDWD5Il6PYdunkxuc+?=
 =?us-ascii?Q?LOSP+lmhc441EyNx/KJevte0t1y+Eq28P3HyJRI4+GzJzA/8xLTf/+52wmKo?=
 =?us-ascii?Q?ufFhhXVeNwwkbjAZsBS0znLApqWPMV1l7BqGfxt0ASIKBXPMDq+pfp7KdH++?=
 =?us-ascii?Q?z+wVjBIbaGlqha7z8o0o/bV1IDmQzYTAON34tHBOQh+2wQHS7Tj8qdoL0GRa?=
 =?us-ascii?Q?S9aS43HcEHgW+F113QYwZL1wrNSwKMvDSiNbyPLIvYo6YnA7Kzh4r8uMp2tT?=
 =?us-ascii?Q?/iLNzktG8OfD3+A5IgnF3zaVLBsiXVLeWzNQw7uS/gWmXfBPQz/hzQW5p+Ux?=
 =?us-ascii?Q?V2RWvEasZwtdo787MewQXoybDymHPiV2MNDbRE2aocUHADU1iOCWshn+/OCf?=
 =?us-ascii?Q?PNIGkHbqqh0wY40ywINfgUUVrHyAnIYglwykGR8Cwl5YMBEitrIwa5ZNSC/X?=
 =?us-ascii?Q?RYyAjsCMJCJdZt67bUjARQyKXAFp5YoL29iA6/VOaHFtf8zcAquYtsha1hao?=
 =?us-ascii?Q?DVR6aIlp3vx5ILm3b644J7tRJtzICGahgcbcuehjSep+AyMPB20yQJr9yJwc?=
 =?us-ascii?Q?DULdogDeqEviqAmz3x7UtGgrvx1uXtKGyP8NN/l0VO4N4T+I/aKOcjowFzif?=
 =?us-ascii?Q?abM6uatCzmNe7em+Y+t9T3E=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1804e99f-942d-4ba6-796f-08da5ec7ab95
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2022 20:48:09.8892
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sL2+Gr8LeEAQPE8ChblvsOfkj8oPB1vDJnbHiEn+o7ixob49dnyskdOxdS9FIBrWXzauFaBxpWB9/q+4q7xpdXkH+Se9cD1MLW6rC0PooAI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2898
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

I verified module functionality with modprobe ocelot-soc;
modprobe pinctrl-ocelot;
modprobe pinctrl-microchip-sgpio;

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

v13
    * Suggestions from Andy for code cleanup, missed includes, forward
      declarations, module names.
    * Fix x86 allmodconfig build
    * MFD module name is now ocelot-soc
    * Add module names to Kconfig for pinctrl changes

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
 drivers/mfd/Kconfig                           |  21 ++
 drivers/mfd/Makefile                          |   3 +
 drivers/mfd/ocelot-core.c                     | 169 ++++++++++
 drivers/mfd/ocelot-spi.c                      | 317 ++++++++++++++++++
 drivers/mfd/ocelot.h                          |  34 ++
 drivers/net/mdio/mdio-mscc-miim.c             |  42 +--
 drivers/pinctrl/Kconfig                       |  12 +-
 drivers/pinctrl/pinctrl-microchip-sgpio.c     |  14 +-
 drivers/pinctrl/pinctrl-ocelot.c              |  22 +-
 include/linux/ioport.h                        |   5 +
 include/linux/mfd/ocelot.h                    |  55 +++
 13 files changed, 810 insertions(+), 51 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml
 create mode 100644 drivers/mfd/ocelot-core.c
 create mode 100644 drivers/mfd/ocelot-spi.c
 create mode 100644 drivers/mfd/ocelot.h
 create mode 100644 include/linux/mfd/ocelot.h

-- 
2.25.1

