Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DCDF5AD74E
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 18:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236358AbiIEQWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 12:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232055AbiIEQVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 12:21:55 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2113.outbound.protection.outlook.com [40.107.102.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A90655AC7F;
        Mon,  5 Sep 2022 09:21:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c2C+vteXQbk0qyZVby5N7x2n8k8HAUDPHJ2rw1OegpcFwNRZHXodC28ztGCGtY88dh1aroT/7UMedhDyyLb+WhD3O17yK0XiBOQv0pqH/KJc16LkL4Z5rz8DUYiNZIySuAYkGwTobYh8n+bbne63GROM3La3aVUqxK0NXvEKt0ZnnEspj8V9k2mhAJrRz+ExH6mp2Zrh2oxMQieIgEgg51MiupaCXBkB2ATvl8kUVRawE4DvPaYyprPk/UqmyoD7atN3Nar10Nq1W92UC7/Zhcm81ewsp/OKudhQFhkdcnGSloJHYXTY30jCPAO6QhvT/h1NTVTsSuuFk4wKQTGDlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4oChL1ri2hqgnQYaT8N4Isn8P7c3bAS4du7ETAoVQos=;
 b=fobCKif6wspHvBL8iaCR8l27IW9GszBIsIz/4Zi9SFL7u8m7uJJHNpMSwn+kv/AFbNq1+4yDf17K33uvJUI1gsqO+L9h51ubmEN9Ty67dugoHJ3tOSfdz0OFNPKyunssdgnr3MGGBSqCmq8B5lLr0TSFEUcIv5zqSoxF1ZgjrCu9h+FcliqBEZuQukYhQ4gxeEmefpdUjCRt8Z/71R13lX+rIDx47Sfo8vXFFLzRgjpCfsSv6TejhXD3pPloEowWzAHmYL5/SM998dsfOfSp0eCfFdAVBovs5lb58bMk50l/UcBG7JUC3zeqh//7uvveuLWSyMtD0OSVEX6KGvdUEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4oChL1ri2hqgnQYaT8N4Isn8P7c3bAS4du7ETAoVQos=;
 b=AKWS0zYo1RnzGwkgPQQqp81jZq4gX6qsU/aAU7OgW6lvTVjQ+QLkwD/uFIMUkNxZwk8cPuzdxRROfYwxZEs2pFfx5+mAVCajnWcwzoRln9FKyXyjEK3oiugN3tYBD3vu793q1nMih2z9ADkB/5eyey8EB/D8EPOktbTBdQUAJhk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by PH0PR10MB5848.namprd10.prod.outlook.com
 (2603:10b6:510:149::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.14; Mon, 5 Sep
 2022 16:21:50 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1%7]) with mapi id 15.20.5588.012; Mon, 5 Sep 2022
 16:21:50 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Terry Bowman <terry.bowman@amd.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
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
        Rob Herring <robh+dt@kernel.org>, Lee Jones <lee@kernel.org>,
        katie.morris@in-advantage.com
Subject: [RESEND PATCH v16 mfd 0/8] add support for VSC7512 control over SPI
Date:   Mon,  5 Sep 2022 09:21:24 -0700
Message-Id: <20220905162132.2943088-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0263.namprd04.prod.outlook.com
 (2603:10b6:303:88::28) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 79418615-814d-46ef-d7f5-08da8f5abc92
X-MS-TrafficTypeDiagnostic: PH0PR10MB5848:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J7HPFP5EnGYMCks8+Yqxtr3PtNVBi1kLTU7zRD4g7iAF6TsFl7BTmMmuZHQbFkVhZu1HhAC0wHqqEtwPD+2F0hKm/w9CiEQVgeMydK1iQXbqnxFJU6NcjXoVtB6kDUakNzEH/uu4dk5gB6lz051Z8DE1Hk2AT0vb4Y0uXTyJaQFHMe1otbZ1N1pj3DlCsk9JTEmkdFmfdE2QyvcI/tX6HRoolUXkU9w2zz+4FxnQ+mO7uVxQ86twDxlD7kSxSMpAwPyWLhLH2PFBCmBQk+pbiUwyT+z0U8xi/6QbJ1vOvd48IslMQzk1HYgs8b31LkUSTdzrXPDG6xZyx68/1mw9w+ZzHzfAF1ECEu7YAraaicqj/atIb9gQvoaEHmo8lyEYcxnHxKBzjNwm+ypzctOEFRAz9TT1SJI2jSk9FwlQGZUHpRbh9Rb9a6rogJVtbHvL3ru66vdqnKvGkj9v7BqnNc+gXuWtwwbcrbhE0ibuEtKKRtdlWvwc2kzTq7ChAmjKgrmFfMoG/yAEMJD3SDRlCauoge5yhuVF6oRTeN7UgeT9z3T5HTpQgYBzbZGHlOY/Jxx6uFprvZFqiRCeKu4WRshQHdzBti3A65poiVrIrkT3rBsOfz4suE4WgcUvd85wfWQojXN28ZlS5EppXFkM7cwUDETW/cfy1+tOYyHFd9ieLK6Vb85Ew7SE8YYf23AUvkik9lR6eGDpOhsfWKUDWxf4Cqcn6cIDTi27N/jijwyjgW1i+MRb4anYf40iNN/X4VD6KOGSmuQFltgKfwLBvQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(376002)(39830400003)(136003)(366004)(66946007)(5660300002)(8936002)(66556008)(54906003)(6486002)(41300700001)(6666004)(107886003)(52116002)(186003)(2906002)(1076003)(7416002)(2616005)(44832011)(6512007)(36756003)(6506007)(316002)(83380400001)(26005)(38350700002)(38100700002)(4326008)(86362001)(66476007)(8676002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?C9mWKt74npRH/iPafaRY+bBeSd3oAsiGIYAi78LsE6t+HHuo+QivQWgFeCE8?=
 =?us-ascii?Q?w42D6mwuVv0Xo7i73Tf8Y6dMDR5Rw0eu7jpUtlzsEaenfz6wtzPe8TrwALdL?=
 =?us-ascii?Q?md8sm8ES92Sz02VrdlNhPEC+nhMu1UaIcHa08YgWaDjoA2FY3nMWlmMhlPF7?=
 =?us-ascii?Q?Axc23z4lXmHrTSFFQ7QQ+zxmgD3yTcs0wgk7ZyrmbD4auleXLEwZwRhEe4b7?=
 =?us-ascii?Q?7EuMiqNf/yTZl/LvCGo/m2oGfyIoR21DDNZID4KuurOVvetW8RSS5kGoe5fy?=
 =?us-ascii?Q?BQhGBEI9VxtwfxgbYoX0QDeRevCfTicxZXKLqQbUNNOJrSU8jE5dsFjy7ZVO?=
 =?us-ascii?Q?/sapCR+cp2IB/HACIszilwgm1OapQvK13w2RuCwoMpXl66Bxf15yvyyNXCsv?=
 =?us-ascii?Q?Z7vyq4JlxnZ+iutiUa/0bekLf8zquUTU7B4GG0xFQ6OnrcPBrSOow9G0jQQz?=
 =?us-ascii?Q?7n2qe2UFebLPyrj7HR0apOFNzrF/pjZ1pggkwhtYD9lxjKlkBIV0iUtEaX8U?=
 =?us-ascii?Q?k/qjRdgpW/18+wmW1qjPP/kfX41D2S3vJ03yyDHkW6j9cfD8krb2l3EMrOGz?=
 =?us-ascii?Q?jgBq5fN7XQf2cjYzzTGaWHT18cUwL1WvmS86d08FMSFwYsVkdtLT79qdtP2T?=
 =?us-ascii?Q?PWuNlxdITdvD/SBFO+QYOs1iKeCSeAzqbZdupVrWqoNpquv+gRJVGuWN7ESp?=
 =?us-ascii?Q?JqHwMbQ5pARn1KG+x+/7XbJ1Qvb7xUdTW7NXjncEiZxMvGXhoZqLbyA9vrmO?=
 =?us-ascii?Q?ghXMNyMSp2kKj5HNQCApdg4hfw4Mol+/2h8cIl3G/TIuKKWN0bKwZB6g0Y05?=
 =?us-ascii?Q?TcjxuNB+bixqxG7HUwPvjoyACctPh0V/R4R031qULDUQTLdHXCmLFCB0Pblh?=
 =?us-ascii?Q?3RIvUzU6LBFcGGQuHMa7DLpbMcMT3eKKRD0iJ0oJbjk4ZS/S7TEsdlCMIMub?=
 =?us-ascii?Q?KOrvvUMj7cVNk0kO/YfWEaTaw9da54oQMkTs1zPSNd9DJI2Qnri+L4T9SobX?=
 =?us-ascii?Q?tibolDz+hQpjiLHaULbdyctsZuAubRAx3M5bkmsTQBMLV1HWKUPFjlCeuKFp?=
 =?us-ascii?Q?09cjE+7Yg2LE9jsLJykrEtlVxCQertJEWumXxJ3BsntF3voJF7WOia2/2uKm?=
 =?us-ascii?Q?zSTTDYNVNFPkeSnvWkvRGAA9KebTTP7qs5SMcXwnmFXFEnRU8aeofigRKWkf?=
 =?us-ascii?Q?C6bSLn1BynIS+IA+VP8ES3zRen39juAGs++lQ3qs62uSkPVTTMTfGSDA62R9?=
 =?us-ascii?Q?OeK84vaGakhrQSQEGuHBwxIjWGvcZSwdXiD9Ug3xLXhCgcK13sMZZcneVrHn?=
 =?us-ascii?Q?CDVo6GE2F1KvQjWyFosijpX+/8zNA0MDmxEdDFhaPJMKz0Csvjj33M1PMltE?=
 =?us-ascii?Q?num3o2y1u3/Oo33Ef2YQxoYa882TJ3AUsjSpq+0pJiMpjG1Apz0S1UUx736a?=
 =?us-ascii?Q?nfyZopa3qs5ZNwovOnnceMSxR0zCX58NLh4mihsqy9yirm4n6A3BVDM+B9Xy?=
 =?us-ascii?Q?65gjXf74KEa9zSNgHCzSJ8MEcdGeBTTpLerb89eWGMZW+fApjZqf0CYpA4XM?=
 =?us-ascii?Q?UnMX3dfszxq2wstE5KGnYkJDsT2b1vYOuON7uAdaY/NNwWvF5NK6Cf9Zcsod?=
 =?us-ascii?Q?m8ICqL5kpdOHc7g/jtQSpYw=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79418615-814d-46ef-d7f5-08da8f5abc92
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2022 16:21:50.2571
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dIO0qsAn5/8al/HTysUvu2pNks63OUJMjAXpFs33fVMZKwBrqgtyqyH1N8vwR/GZzgmMKt9MU68Ue/4kgVfTp61Rqji+AVtQt3BQdJSwqYU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5848
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

