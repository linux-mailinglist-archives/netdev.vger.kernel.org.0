Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9446A57D92A
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 06:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233902AbiGVEGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 00:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233614AbiGVEGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 00:06:33 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2097.outbound.protection.outlook.com [40.107.220.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5002B8CC93;
        Thu, 21 Jul 2022 21:06:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DWQ6BKz9vq1r6e11JEb4dk+Nllpgi8Rqo/5q0ezM3mHqte1YtV7S0AY92nxYvQm8DZNNAI5QamBvZ8WIZZAAjjW6LiPT3n2wkaApvCgRRaH4ckP7da3Ja+lwulthaZUzZsE0Auv9Wkq4YP+Xg2+qQ8/n45bCUxOe9S37VOm90PkC8bgfzaM4HohnWpafZ3dc4SYPu5Bb8zmU5qyAf6u7yOzj2rcFVT+22Z/j6sU4EPG+hA7Hl/RSkRBEv2P+qoEP1gjr+EeCXy1AczBNNtkLXCfkpkRpTmnLHvKr0nGTABhteN1oR1LfN2B8woHCXG4N04J4BrJ19vCIHWtp4g0fjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VGOfP0WRwAYxfuqiZ2bKcmd/0n/xmEGsZbMv8AkGs3Q=;
 b=Ucopj/2pCf+I6zunIO9y4sv6EaO8NIsT5dbzdL5uzsSeo5i25VUSnjp/qLdcoOhH0EExVbnqhK95NEOT/an+dE9Kz+Bn5Vh1/9/xb7k1BsYPrHzSP0cQ1bZiQNy/+5OVxfbCAkjwQzvw144Fw5PmNAdHvrk7HUZSQ8pg83SLdFqTI1nT48PMiJDFQaes+5N+5x6bGwoHuT0KZ+++F5rvASTkTTGCmcW77M6H9/p/1fFzGurNSk2tsC4M7Cyns2L74TQqEk97nxHVvNW+OJl+QRPuborEHin7U4Ycnt50853+imV4Or5lpd1M92piy2ColEdhlObJo+HBrLBhkW0lhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VGOfP0WRwAYxfuqiZ2bKcmd/0n/xmEGsZbMv8AkGs3Q=;
 b=SnVoe4B8rpyK2cx9aA8K9Aq26wrUEiHi4drMyx68XshIAucoU/ENPFzPfS+AGyfi4FXTG9kg6qnByBavyx+RlfPzy2MXCnxeiWcOaQ1aMTxo1SL8g68813LALDZlc7hVRirE8DaehCVrbgL0PEbUsEaTBUcxmad/zZiIxJeiOlU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MN2PR10MB3919.namprd10.prod.outlook.com
 (2603:10b6:208:1be::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Fri, 22 Jul
 2022 04:06:25 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7451:2903:45de:3912]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7451:2903:45de:3912%7]) with mapi id 15.20.5438.023; Fri, 22 Jul 2022
 04:06:25 +0000
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
Subject: [PATCH v14 mfd 0/9] add support for VSC7512 control over SPI
Date:   Thu, 21 Jul 2022 21:06:00 -0700
Message-Id: <20220722040609.91703-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0044.namprd03.prod.outlook.com
 (2603:10b6:303:8e::19) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 64acea3f-f064-4244-62ef-08da6b978b60
X-MS-TrafficTypeDiagnostic: MN2PR10MB3919:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tf65Cb4M+BJvoMgXcfcLnFrd/9I8qvRVLeg1ynW2Wmdo2bBUFt0H37mO7qxFuTy2zrVWb3AU0rTnYM1wnXRu6Ur/fVgQp8Pqeig5BXwseFJz3WqsxtGtrcslKOCaf2e7q+ku7M0OnjnOuI98w5gLXo4VAeXJEyAovb+BV4I4qA6behDQh72z317j9E71dIU5FfUnQXy5xDtGKVK3oarx9yUGJXBLWAPrFBTX/LWk1e+f1z9ojP2u1wxWLdBrn6JzvG/NUwmrJn09hc57r4yj5GcsU4OIfaNmEPL3Sbg2MPqKsL0AUVrPJ92h11oFj6xtv0SoSrHhB6Eq8lppFizoKflK61TukyBcUL5jQgodFe0Z/VXcYIT+CZC38QHPLXY5GXYUIBphLZQQonhavTK5EhhcO8XS4bcN5J0qbkKPsp/Zh70xqPWFUOIu2bq5RP64xj3/AMi1PM4FNUqrK16i1yzhud2OTT845jDlrjcZzRUvVf1qXf41kQDoSOyP3P4YkdQoTVv8rkGnG3PxeJ8j9TAu6GVLE+CGlYZ3oYDxstDjgMjfHvgi3+i7wSC6M1E9DYCB7CdJ21x71Z1w4YEb0x8iSxzHwlcjQXsxKL8u4RRO57Kto3OMHuWX3MqwVaOQ3S/qbIDW05xxy57CB8Dlm8xzZpExI645l0U6T8n3tKdtDZzhr6oIWAcisCE0XIKE3G0K4Jjcz/onLeMw2/632qPrk2OC+M7KN8ECp8rBF2tgi+sypoiv2qE12PGaH84z83ImlS5SS/ALuw7tKzrHL17F3vBPtli9/Bz4IZqxl/w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(346002)(376002)(136003)(396003)(39840400004)(36756003)(6506007)(2906002)(44832011)(41300700001)(52116002)(5660300002)(1076003)(66556008)(8676002)(8936002)(4326008)(66476007)(186003)(6486002)(478600001)(6666004)(6512007)(7416002)(83380400001)(26005)(316002)(86362001)(38100700002)(107886003)(2616005)(38350700002)(54906003)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?37vgMVGkRcyOb8wFRxU7iX0P1tx30xoJ8UgPriPz+3iUeJ7Jn4Y37I20CrPh?=
 =?us-ascii?Q?eLVmEk4E3RzaW48ZiUVpF1pkipElNIEDRcx5d6Nv4kq3EkcKtH9BBziYXgyj?=
 =?us-ascii?Q?jBTF84n+CCC02pFp5d1YeaQ+ioFG/hJw5WzUuWLpIYW7ZoQ+DjSoMnP4yELw?=
 =?us-ascii?Q?cG3tyeA6DM711/dDc0r+eI6RirepQEko1eJhhmDr8I0yuZcKuhG8QNnKgLkh?=
 =?us-ascii?Q?yEIyxWU5hqjQj7YayNaJSODXoLuW8gtpQx9Qb5cdvQmCJVL5wRtokrD/6RU4?=
 =?us-ascii?Q?46Y8a3LcmzuyzQ5gtM2bc5lC2Hd/DeJBd4d3UEvGLeKQQKKuzq2kugb1RG+d?=
 =?us-ascii?Q?oQB4bBAcQzb0bKOyjnOtQ0uiPxGO+PvWpv3GhNWedxs2UypNnxaFV3rkJbkh?=
 =?us-ascii?Q?dHFdCKTk4+6JYjt4ikVLVmqjGe1GGgs/kuWt034ww/BEt3SLAN48z4PXB7V3?=
 =?us-ascii?Q?TDkj/hfMrheZPamzM1Rm/3rrtlOtqpvlFkisaZ03XD5fbybUesAC1iEMLAeU?=
 =?us-ascii?Q?LpEGigXJ1eyh5T3hVYmoN4d7XUH8LriUAu2PDpG1b+2gt4dhmh0yyh4I0RT1?=
 =?us-ascii?Q?TeLm74+gsVpXN2NPK8ujm/6hONht6pSWEk9OMv/VdgQ3kJNsxDhqGCwChXd8?=
 =?us-ascii?Q?Kygg7VysoAn3bVtLt9BFWqLFtqZu1zcdqceZvvrOHv7oVbTWUzobKE497Xx/?=
 =?us-ascii?Q?F/7uMkMWwxWuqa24OoIzIc/klw3RUqJYvEB/B1ejGMmv1GykcPnjI83CqUZ8?=
 =?us-ascii?Q?oVC/jt/malJXAShVH7txHU8ye1mnS7CaA90+VUdqbXoxZdGFfd0OflH2bA2g?=
 =?us-ascii?Q?cuw8Q/J2x5TIB7c0uDZBwga/yJ51fpzUM9WOKESceFoEy23/mNq2Tn/MxwIS?=
 =?us-ascii?Q?K5MpV3Dv6dX79qFAgl3Cjc91bXQ5nL2ZJUVG+gflRmqmwhZyQ/J9G1wVulrJ?=
 =?us-ascii?Q?PgqktlhvXDU0cXYJQ3YepKRKc6Ct0jauwmLDI4lwwNLKCAYj9rZutRyUE56U?=
 =?us-ascii?Q?D2OhL+UU6zJ0uG2ZF5uPoKrSx6ntZihEChO1Wr1nO4HN5cVSQYvKFid8CQdZ?=
 =?us-ascii?Q?SXnZGdtnaVQSfpnH3Z053v4UJEmTH1vIyKerLQFylU9ENsYozTcM5bhyh/X/?=
 =?us-ascii?Q?JRLTufhuMYsyJ7ALs76qqJNvSJswl+rWmmc/kM9XPuTFqjBhiJaZmHY2eazY?=
 =?us-ascii?Q?0SE0Us7WTR5z8G/L7WpICiMR+JGlkHlTrJlmZC5mYsSVmZnZ5lDpD2gYJTOn?=
 =?us-ascii?Q?GRuO7Z0/cvI81/GE8FDtCM3yEjZzGySTzBOiO6oANuUDOb7ubvV8TeKejNow?=
 =?us-ascii?Q?UZQdCI39HHgtyPgaiCegZTxyjSOCVcsEZ7DBbKKz81qKWvaUohN3G7ZP4q6Q?=
 =?us-ascii?Q?MVQhth98KftuSGu05XrqVe6nThV6gTWNlpXGnIVXmhUXg4FEzOtcByfGapNx?=
 =?us-ascii?Q?BHxkY6AS/1NXxDK7gNgLhfKt4Mc9euxIYcfYP3jzTsl4nvkgIvHRhx/9hrsy?=
 =?us-ascii?Q?AprqDUhpIuvCbq7Z50pC80LEmo/kE1xiYL0u68nBFt6EakqUhVlG7xYrZ+7i?=
 =?us-ascii?Q?D9UUOqcMXr8+0L4eNixQIU3iQSnvn5Eoe50N5Q1ucALO7jp26OVwew2h4Foa?=
 =?us-ascii?Q?bw=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64acea3f-f064-4244-62ef-08da6b978b60
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2022 04:06:25.1273
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RAhlJtTC3LOajvYpa8AaNX4s9Q4wFlebix6onDzoHUnGE9+ff98xEByd/RUGOfUUXUFM8R98GnXWYcRcLme6hWTNeW1bE+m1YKh3KUZUuQQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3919
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

 .../devicetree/bindings/mfd/mscc,ocelot.yaml  | 160 +++++++++
 MAINTAINERS                                   |   7 +
 drivers/mfd/Kconfig                           |  21 ++
 drivers/mfd/Makefile                          |   3 +
 drivers/mfd/ocelot-core.c                     | 157 +++++++++
 drivers/mfd/ocelot-spi.c                      | 304 ++++++++++++++++++
 drivers/mfd/ocelot.h                          |  53 +++
 drivers/net/mdio/mdio-mscc-miim.c             |  42 +--
 drivers/pinctrl/Kconfig                       |  12 +-
 drivers/pinctrl/pinctrl-microchip-sgpio.c     |  14 +-
 drivers/pinctrl/pinctrl-ocelot.c              |  22 +-
 include/linux/ioport.h                        |   5 +
 include/linux/mfd/ocelot.h                    |  60 ++++
 13 files changed, 809 insertions(+), 51 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml
 create mode 100644 drivers/mfd/ocelot-core.c
 create mode 100644 drivers/mfd/ocelot-spi.c
 create mode 100644 drivers/mfd/ocelot.h
 create mode 100644 include/linux/mfd/ocelot.h

-- 
2.25.1

