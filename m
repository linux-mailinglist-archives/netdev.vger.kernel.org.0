Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9AB659272C
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 02:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbiHOA4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Aug 2022 20:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbiHOA4J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Aug 2022 20:56:09 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2104.outbound.protection.outlook.com [40.107.94.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 004EBA46D;
        Sun, 14 Aug 2022 17:56:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Th95WjukDTCyXY+/No0kn1BajXQQTzBYMaMG+S9WXTXzBWLGER0AW8hp0o0aXsg2NzeOHlio2o4KpissYUhuwizpDKq7GyreJcywcTp+qC4fnMUtAez0NyxI+NWna0Ah+yuJEHsWUVufEsIdDFnm3qt3UgKAVipihFrbDzsWz83K/bp3oH45D7O3nryriNEDjhQ0zsbnMRc+xSjTIZPjCwkqXKeqLG6U0hd110BxbGHZ/vnCu1X+0m0MWQPiz7H5lDE5UvAd7zX8qR9oPHDVvkxrDY5/eG+rCTU5oJn3Ne7TB6xsEFXnFXRoNiJXQBcV3gMehtnt8wTRTFxApZ3Evg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4oChL1ri2hqgnQYaT8N4Isn8P7c3bAS4du7ETAoVQos=;
 b=d+3PzGC+uTTutwL1sJsa56LmiN61L6pI+cc3zSydpkxuWeg56lRaQQh+ZB1t0khNlSLteogFMf6L5ys8xqeMffJX2kpcu90CIK0sadZepbfjX5yzXFisypfdQMdKHzuwAUKas61GyWON/ywpLDkqXVV/iHS/Cig/f7A7szNk6katLY2YHsTnRMD0bOV4VpXI6J31aNY/BN2ijiUoZMFozfcy1KtO8WOPeJjgWBqtS+uxAz47/x9Eu21xqZxCjRpBC6mwndlT9voSEXkwRuAN5DtAyPsxoevKzcTMNe8nTqZwtBuI3HpL6idliB1qC+fAOqtcFD/p+oa/NLr1rC5cZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4oChL1ri2hqgnQYaT8N4Isn8P7c3bAS4du7ETAoVQos=;
 b=jdoPxxKWUfo8mWFlbJutxsKQCsyhyBF9hDp9eZyjwfPhCrrAwmC/Nm22Jncz7t80Q3Q/THrcZd8IsCug0PrYydtT2Ov8FbP7MMBjQM/v6iBXZsgngT3OncHdakxkpetTA7jxU8fQMvPL3+u+k31yH+y4FZ3W5NqBlqzKp6xswXk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SN7PR10MB6286.namprd10.prod.outlook.com
 (2603:10b6:806:26e::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Mon, 15 Aug
 2022 00:56:05 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee%4]) with mapi id 15.20.5504.027; Mon, 15 Aug 2022
 00:56:05 +0000
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
        Lee Jones <lee.jones@linaro.org>,
        katie.morris@in-advantage.com,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v16 mfd 0/8] add support for VSC7512 control over SPI
Date:   Sun, 14 Aug 2022 17:55:45 -0700
Message-Id: <20220815005553.1450359-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0034.namprd08.prod.outlook.com
 (2603:10b6:a03:100::47) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1c2162df-3ae0-427d-eda7-08da7e58ee3f
X-MS-TrafficTypeDiagnostic: SN7PR10MB6286:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3MiYvvHUQVZz3A/u33LikZFzytXzAcQJ/bJDE8kr/gVNG9nMEavr13F6lsolrHKv+8yQoypROmJNTmWGsXteFjcd7HmJLpFXUG6WGClJetWDvhHpB6RAh/HJ0L6X1ptAkMrSFNzsDsWNOjF7sgE90/ldJOFz6CCSCMbz1wWnVgUU6f644MT00mgkn5y6CXCLkoOHzX3p/BGbiQruJiUlK2y8CU2FN/TG2kvL5kAeGl+YLQnc8AXnZc7YmrqTOdKsXoe96Zj9EWtLNkIVn1SWSgd1f7Sjm+rH/rBglB4iE5K9IygPrdYdybmfORz+1Xm4ucxYwIhH36WGpHnxFfbHRepPj/LLSPo3VeHlDheuU0/QGC1xibUZOBeZFu3SobUsBPWtrx7Y/FwG2e+KVd8aY4vgl1schDF8Z/1vv4BYIpArh3B5zdgmUk9rjR+WlEeuURuIiEfUxZNrF4wRFynzVmYCCQhy72ZJiy+n163KyrRDuKoSzDrVeXWj/eV4I03PcA8VID32gMKnQGA0dfg7qsfntHjTttS1Mv1YHj35xzW3M9Wv+NF7hVaKwAZo5hlOEYdUrExTx9io4uxeSrV+RPguZqQSZpw+klm8XmIXq1Slk8XXnoXjweu3yThS26gxUuY8GMYNDvjHT5NdtS06FQ78Lx7uGie1AldXyMESn0zHRbgUMFF05cAgjYJ8Ytq3HkErf+ftTf7zt/+htHIm6h595zQnWxjkEjkrFxHE98FTyKBNFLtxunmLCeXemSMX+Ql0Kzsf14rjTSSYaspb6ouljMtBpZytXa6DnNpG9A7VeUTuqG3U4iLDHnt1mFhX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39830400003)(366004)(136003)(396003)(346002)(376002)(38350700002)(5660300002)(7416002)(2906002)(44832011)(86362001)(38100700002)(52116002)(6666004)(41300700001)(6506007)(478600001)(2616005)(6486002)(186003)(316002)(1076003)(6512007)(26005)(83380400001)(8676002)(66556008)(66946007)(66476007)(4326008)(8936002)(54906003)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7S3zCvVIOt5lbaI2xDF4FmvC2mnGaNoOKDZ6gnVk4Om+EQkLEJxlie4zkX7s?=
 =?us-ascii?Q?SQ+RynsxGGNILU2L0BdFxLJlKw36R/pVC6mBHrLVDzvonqyAdH5ch9eoLzm1?=
 =?us-ascii?Q?0CFkCk6oK8GeWfKmMbMVoRom2b88UWaHROBfID1eVr8pshSKwEzBhO8kgn58?=
 =?us-ascii?Q?eXRSjcn/OamUuHeR6GhTY0xA1sVSIr/216/HrEdOdSx4ugdnUugcEtI3XqPL?=
 =?us-ascii?Q?q0KA96PxSR1tFDpCs0oaC+u3QH909DOY+1TXEAAzRz8HViuAEDyBdIPlCbbW?=
 =?us-ascii?Q?mwWNx0k0xG9vUGMNy5Tkv/BSMHM+9HPeByr/w2/PzsoVGDHpA7QdcPMHoGBA?=
 =?us-ascii?Q?iPizEGv8YsWwCxiL3/8kCn7rtkavKuQcZ7T13awJmneo0OJgp8QF1oShyiCl?=
 =?us-ascii?Q?ilPwAAfjuSigI+3vkdvRLtrD/Pa6sRnz0ZQcUfu8KpZXZsV3q01G3mS97YF6?=
 =?us-ascii?Q?ufcMfeJP5Hl0VOrpV80LZzxcf1aoC9QnVBc2XQ23bsmsayaY326P3yppaCpm?=
 =?us-ascii?Q?NHYQ+MoXODVvfMBrdDdPllLL5+N3iBE8VygOthxdX7gEMhpq+tEM80L4ZuWb?=
 =?us-ascii?Q?QqTtsfyVcdKb2pZW3Tgmnxb9sC+B3zPwKsSLNiCn5f5PbMSFXE2Cg/CcuU8+?=
 =?us-ascii?Q?ebA8nIk9dG52FK30a7Yylox3WOsFknXBS7iLD0KxXxy24GcaJcc96t1+fdaL?=
 =?us-ascii?Q?bREdBV0yNCz8lCnTq3ekhP1bku3zOHCC1T7aSXn7aOwT2JRk1/B/8Qdaexcl?=
 =?us-ascii?Q?4PPzxwn8YGMpzExjwuVxNZAIO1wGzePt+vPr61zhXoDywFC7G5yod8sSvU20?=
 =?us-ascii?Q?6NQKwegqpeW1CRJrNRLL1PxAqEvqXE6LQqgBay9PAcU+yASdz4ha9+E6yxu2?=
 =?us-ascii?Q?GtFXYqz+9m+zv4q+masmDbHhx+JglyLDsyO0yZHsgmDQD4uNVN7kFgFO2vok?=
 =?us-ascii?Q?fcENOJR+OHTv69syPxN0fCiaRdB7VqgKplVv+ZzcffjrorN/Ha2EL6FgVpXm?=
 =?us-ascii?Q?U+lBL5sdzdw43Z2c+VNfwvZX5yq7XidoPC1m2ZJOk2DoszxNpgkh1vCLsAth?=
 =?us-ascii?Q?s5d53glQIBlmFpNsKQEhXzhNmVRo0JewuPDVJRDY/pA8ELRgWVqNgyYhZ2qc?=
 =?us-ascii?Q?4BFfyELmuT3hQub4hhL7oyKjai4pW2RhWcRORPnfkcWf0MMxmrw9U5cwhsyt?=
 =?us-ascii?Q?HKDW/IUwuSh8wLwZ883iM7Z0ETaB8h0xZijYQlZmzTZuHZKbKLu5IimCg93J?=
 =?us-ascii?Q?VgPuaQkasW8Nl/N3hlOReB5/mCsjpQdSShbkbgZozLNFnwVEudemuiK47Vu0?=
 =?us-ascii?Q?sNONcvsT4r2CY2U02SUq5THeFHNG3tgoTC8G71q8stRztA7Wh0nZySubZLKU?=
 =?us-ascii?Q?KnCM9+yKU2BN16ovyqzu29hdORowtTWlznhXOgmMH4LyIYdmj63Hv32HwIQ/?=
 =?us-ascii?Q?HcdXZ2alxV3IJ0uPduFsqrPDGpcwxoO9rc7j7x7WQVmtf4j97JHEorzqCrSw?=
 =?us-ascii?Q?j5ADH+YEQ2cQ92U4h4K7O9w/G4Rnn9cPzpqn4I6/KuitqWVB3AbPWEW7q/Io?=
 =?us-ascii?Q?sTaoMRk9frKCALrLn89wiIJZdzSBFuIoUj7E0ZEpiRaCepeC1zt6a/PAmKNF?=
 =?us-ascii?Q?n33TwpR2V1LJ2tAkOGKKxdw=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c2162df-3ae0-427d-eda7-08da7e58ee3f
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2022 00:56:04.8703
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4Px8paAUJ+xIsK+yiS+5kGa/HnaUR0dMDWIJU7VyNkSHmc7sq7spiZ8f6ldgoR5zp3dTBfid84wX3JKenY+/T0Y+CiWWfhvOJah7mhLMaSg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6286
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
v16
    * Add reviewed-by tags (patches 1-6)
    * Utilize resource_size() (patch 8/8)
    * One more round of missed includes (patch 8/8)
    * Remove pinctrl-ocelot module patch, which was applied in v6.0-rc1

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

Colin Foster (8):
  mfd: ocelot: add helper to get regmap from a resource
  net: mdio: mscc-miim: add ability to be used in a non-mmio
    configuration
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
 drivers/mfd/ocelot-core.c                     | 161 ++++++++++
 drivers/mfd/ocelot-spi.c                      | 299 ++++++++++++++++++
 drivers/mfd/ocelot.h                          |  49 +++
 drivers/net/mdio/mdio-mscc-miim.c             |  42 +--
 drivers/pinctrl/Kconfig                       |   5 +-
 drivers/pinctrl/pinctrl-microchip-sgpio.c     |  14 +-
 drivers/pinctrl/pinctrl-ocelot.c              |  16 +-
 include/linux/ioport.h                        |   5 +
 include/linux/mfd/ocelot.h                    |  62 ++++
 13 files changed, 795 insertions(+), 49 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml
 create mode 100644 drivers/mfd/ocelot-core.c
 create mode 100644 drivers/mfd/ocelot-spi.c
 create mode 100644 drivers/mfd/ocelot.h
 create mode 100644 include/linux/mfd/ocelot.h

-- 
2.25.1

