Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 840A055C9B1
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244690AbiF1ITh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 04:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243937AbiF1IS5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 04:18:57 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2136.outbound.protection.outlook.com [40.107.212.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3331D2CCAB;
        Tue, 28 Jun 2022 01:17:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H/Js5FMuVNw6Jx0H3pN7mh1o79TmjVy5+aLED6lZjZLJ0SfaT1PSzW99xhMB2Rw896ppXYMXyDM8qEoWAbU5R52SCtVY1Fq3pvXiSuR5LYOOUTRRrGdTMbow+7Yb0hqcHwjVLYr4t+abeV3cfxUetz+bF5MPvAstiCszRN2oG6YcniwhbAsDVUsXrDFB2ZHZGtKuN/GpuBxwsAhRjTmbuKpUvHEkY1kiVA1LwwKHzD0h3FmJIopyMdh+eCaO1dPbmDpF9pZKDWgWEyUR3ipxxt1zeMcwa03dkdSJEk4e1WqfJ6TVyHog3Rh/Pm7nLhQHJ7XrXcJcwzuYwU6/9NYqEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GumwKd6cvFXEsUfU0e6+fBYBfBZuUMuro89Vly2/lKY=;
 b=Z9hCClTqvxDrVpIk9qltXUkPsnsDFF+TLkO3+uZ5k4ePq0d4MOTDygSLW0A9y8W2fA4+cl4T8rLTZB7xfhzrdN+AX+1IX8ql5E009Ih+lrcCeOaEOdRy1pUCiuLgVmtGAqZDorG7OM2c35Gw3y/i9+S1lx28e8PbMHlJJRreZeb4yYkxHpTP4x1EZRO4ysW96tHs0sVk1bUF33FTcslI0fhclbraShTlb9Ru42JsLr54K4ES0dLy/vlXYP3LM1MmjNNNvkIFJhgdzdfcmWWQlI2byqyUJg1kGpYwOxfU0LDeA1+yfsQT7QoJhDFEiGJfVpPej/8sjjNS0+oT7ZgcQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GumwKd6cvFXEsUfU0e6+fBYBfBZuUMuro89Vly2/lKY=;
 b=F/mZCaPd71y88cD+w2fI3RTm/qpjdVN9lb81wQRZyp3YFECJilSRX5Lb/j7sro2noGhI4fFfCSpCYWEV8t/NOc2OHHRLi8Ficud10uTI5/AgHj0IHIuQZ4xj4HWEqGoiMVC/cVip7tyO4sprgB5zcEIkDNmBsNFudxolKMCjKKE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SJ0PR10MB5891.namprd10.prod.outlook.com
 (2603:10b6:a03:425::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Tue, 28 Jun
 2022 08:17:25 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e%6]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 08:17:25 +0000
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
Subject: [PATCH v11 net-next 0/9] add support for VSC7512 control over SPI
Date:   Tue, 28 Jun 2022 01:17:00 -0700
Message-Id: <20220628081709.829811-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0259.namprd04.prod.outlook.com
 (2603:10b6:303:88::24) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 220d694a-8d49-4af9-7c64-08da58dea207
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5891:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MyUl8RyYWVyTFlSPbXnSfTObXNBpqJtyeJC1XUwzSTmkcQzrVNkbbU018eEubFUZtjXxYOg9xshdIwaMWMSZ1YDoL7PRvu2IoYLcMi8bRfDTdsYdCAwvLT4wo6HkfsuUGyEmf7nDtghPEn0oBUFUop+msHr31TA19BddXAcet3jgJqm2RU3tDhvaOLnBF4U8YbK+5/uW7xz5r9G1DQ57lyg4uHxOJg3NBurtVEmyAT/pw734kfFzzftqEzgyAA4ge8FAMQJJ+0UsQRqvagHxtLX9sS5xKFnc9ivqy3ZYie4rFguWzmChHK0kug4f5+wE/HlaGdnhCdk7OpKKUyIwLdCPfwMPNVbycmyjfcrkKiHmViewEaDfIypBe2cvZDPmKYekUQ0yLczhTXiM2sm8387uAlnmwJiieX3sS4VS1fgmNakX3+9ew3kAviqpZsHzIazFVYfyfI+S59DUYRY05+QQUd+jyTEKuk0pqQ7e10/AmTG4v+7jMpoD4VxR/qHlbv2AL4vXv14Gx37lCcwNuyS5PkU95kAdU0n7TA3cMgt8o736tROBBr4qnMxRMC2cwwoLPWc880YWoyXs4AaGm2TLou6VD/Nd7NlNbPDRkFoefDUBHxVDi9ChLubpiUPwvFf/16qMy1e3n3BDBWmGx2w5vofagtUpDnSSeTRS0R4+DAKt022APVj/cbkm8X97HRcmbX3YRocsRN7JozqQlSpmInQm0j13WEgKv1N+uSFSG1HUXZBt6tM7c1O6tK0G93k9Xg0LPh5imed9FRpKywjNPzbKy3Gjrm1FeciQl3k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(396003)(39840400004)(376002)(136003)(36756003)(38100700002)(6512007)(6666004)(41300700001)(38350700002)(44832011)(478600001)(8676002)(4326008)(2616005)(66946007)(66556008)(66476007)(6506007)(2906002)(54906003)(86362001)(1076003)(6486002)(8936002)(186003)(5660300002)(7416002)(316002)(83380400001)(26005)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9ArvtjuaXEqt6CGEJjjkuLt6bfDISdvd8o7jVRkIGvb5zVcdDrzEWIyEUkGv?=
 =?us-ascii?Q?GpCZ7MIbv5ZrFSMUp8BY1Ye3+VTDTIkJikPtXS744X69GrjxNf2xvu3dWSur?=
 =?us-ascii?Q?yKPcsJCU3Woyv1Ckg+3k2aMG5TI2javCh7+cpSuVDroGz/7hsUnQuVwWzR69?=
 =?us-ascii?Q?5bII96r8Mph1ZYnNViSVKZgyEMLeIoL0Czu5CeanXQqkYSIdDFaHfK/9Bfiz?=
 =?us-ascii?Q?w+PeXW2aYl9dm9qafeeBmwj21/n0I523tln5pBfA8IH0hCPtRBpERVpifDur?=
 =?us-ascii?Q?qvJBOGND9FmVp0An6wHQSTpdUyLmvymLMW/tBhpjo5LP2+RAkbfEjOLqU9sm?=
 =?us-ascii?Q?WmmYfutNy7bMy2J3XENP8KS3QR8LbVH4MKtN6zBAo62I1/hlFMxieYHqdHWH?=
 =?us-ascii?Q?5DTpH60Uu0vubEp0+TLGF0Ly5zHAWeVO6GGQxuu7/w/LfX+6/q21Z3z0Y9TN?=
 =?us-ascii?Q?qjzLAuN6bsxB9RhUjKs+M9n1zI8on96hRUdr9/dlXKuyQI5v+t6Pr0Whgg1N?=
 =?us-ascii?Q?xd+P0CUiDJHYWNYHxsrp9OX0HeQqQVWbX+Ddg9Fl6lZ3u4WniBmOORQ+nBz9?=
 =?us-ascii?Q?erwEtZs6KGUlK71DIWOX8pSEbRWuFBcY9PxHtGyhnWk+5GmUpMklpP5MsY1w?=
 =?us-ascii?Q?IiYoUCeL7wb5MCRSFrFLCx18KvBo+Qlm5q0tGXs/bTohsSolW7+8smkaTvZg?=
 =?us-ascii?Q?+55uXHN3f8qaPimF1ZPrsgOVbERVqD4m5UVlTGnO/bQK/9IC4ypDy0Nfa1zY?=
 =?us-ascii?Q?Ya50a9/t+dnPU/861HMxrlWLvQU6Gn7/1OishQ6wMw9r7ty2MhC0a0vBQxvX?=
 =?us-ascii?Q?5J1qLoXEr9Bu6qXx1xEQbRwKj2dWbDOuWBYR93MhXK+5jruciGcqSP3U9vmw?=
 =?us-ascii?Q?xkTgnn06pFw24HNU2HGJdPoTDZyjq2NDDYvIjGMbmTtNrRyrZOGUcKV6cqXH?=
 =?us-ascii?Q?XqCX6PtKIJWr0fwkFRE5AobduumeOwOHc/NPSGNSNRzmAvm3c9h/+pFGuvDd?=
 =?us-ascii?Q?/pggf8vmX6WRtyCU8TvFSnA8aVPCHL3/VCgHGK6zS6l0RWpSyJ33t3bkmkjW?=
 =?us-ascii?Q?64ppdgB+FXvw1InOLBZZuSLQA49yjAoXZh55Tuox5UyZY/lzzdsp/de+sO9c?=
 =?us-ascii?Q?tkIvIooDe7p/LisC96vd70puon2EnFeGRyMY99lIoPHWldMT3W4WbjKg/Qeu?=
 =?us-ascii?Q?iE9AjDPT8TZ5qwrGBX6i6HPVWzg/7E/wTScC+HAj+vTjTF3SkqhPi3QJ49G4?=
 =?us-ascii?Q?t+wPOn3M8ijbjr2H2++Po0U3TpdAL/OOwDpQaF52QidnhRRR2LlUwK9+Dt7G?=
 =?us-ascii?Q?iouJKmdG+INTJE6aiaGtRvyxOP40YUgKfflNGKbhYcs29aqDyLJ5cyEgItW/?=
 =?us-ascii?Q?agv4sL0gIpHMEfndxsxKdzthSlfWAUDnKyZSloxyjLZuU3ZuSrgSvCBxgI6R?=
 =?us-ascii?Q?6d3zyqAWtqQ8fFnH+EH36tEkdJSd/mw3cynYYb6FhQzLuOaS7lPDpmpHR7pB?=
 =?us-ascii?Q?SY/VGvYToKjN1A7OFlRJ4qDi3fIZGTr58ae8M+LUr1Yi2obgfUf5GXtukS4m?=
 =?us-ascii?Q?AKKW/d3XXwLnXqFsgJ3xGt0/9w63QM1kb4oY2sUZIEQ1eq3KFurWygb7HP2X?=
 =?us-ascii?Q?V4gJriaEd1NwrS5J63Iph8Y=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 220d694a-8d49-4af9-7c64-08da58dea207
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 08:17:25.4011
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uh5a89z1Bw4UahvGNc6dmZjH2cH+hKuNwOGlUqRBE2cozClWIKerAI6/o07Ef76+YngRjfA7Uf+SuFXyCRYMU5E0LZNAn8vd0D850BpbGa0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5891
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

Booting Linux on physical CPU 0x0
Linux version 5.19.0-rc3-00662-gb661f062e865
...
[    1.930121] pinctrl-ocelot ocelot-pinctrl.0.auto: DMA mask not set
[    1.930287] pinctrl-ocelot ocelot-pinctrl.0.auto: invalid resource
[    1.930861] gpiochip_find_base: found new base at 2026
[    1.930912] gpio gpiochip4: (ocelot-gpio): created GPIO range 0->21 ==> ocelot-pinctrl.0.auto PIN 0->21
[    1.933211] gpio gpiochip4: (ocelot-gpio): added GPIO chardev (254:4)
[    1.933358] gpio gpiochip4: registered GPIOs 2026 to 2047 on ocelot-gpio
[    1.933378] pinctrl-ocelot ocelot-pinctrl.0.auto: driver registered
[    1.951876] pinctrl-microchip-sgpio ocelot-sgpio.1.auto: DMA mask not set
[    1.952100] pinctrl-microchip-sgpio ocelot-sgpio.1.auto: invalid resource
[    1.952971] gpiochip_find_base: found new base at 1962
[    1.953710] gpio_stub_drv gpiochip5: (ocelot-sgpio.1.auto-input): added GPIO chardev (254:5)
[    1.953822] gpio_stub_drv gpiochip5: registered GPIOs 1962 to 2025 on ocelot-sgpio.1.auto-input
[    1.954612] gpiochip_find_base: found new base at 1898
[    1.955513] gpio_stub_drv gpiochip6: (ocelot-sgpio.1.auto-output): added GPIO chardev (254:6)
[    1.955611] gpio_stub_drv gpiochip6: registered GPIOs 1898 to 1961 on ocelot-sgpio.1.auto-output
[    1.963280] mscc-miim ocelot-miim0.2.auto: DMA mask not set
[    1.963432] mscc-miim ocelot-miim0.2.auto: invalid resource
[    1.963585] mscc-miim ocelot-miim0.2.auto: invalid resource
[    1.964633] mdio_bus ocelot-miim0.2.auto-mii: GPIO lookup for consumer reset
[    1.964651] mdio_bus ocelot-miim0.2.auto-mii: using device tree for GPIO lookup
[    1.964676] of_get_named_gpiod_flags: can't parse 'reset-gpios' property of node '/ocp/interconnect@48000000/segment@0/target-module@30000/spi@0/switch@0/mdio@7107009c[0]'
[    1.964767] of_get_named_gpiod_flags: can't parse 'reset-gpio' property of node '/ocp/interconnect@48000000/segment@0/target-module@30000/spi@0/switch@0/mdio@7107009c[0]'
[    1.964857] mdio_bus ocelot-miim0.2.auto-mii: using lookup tables for GPIO lookup
[    1.964868] mdio_bus ocelot-miim0.2.auto-mii: No GPIO consumer reset found


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

v11
    * Suggestions from Rob and Andy. Thanks!
    * Add pinctrl module functionality back and fixing those features
    * Fix aarch64 compiler error

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
 drivers/mfd/ocelot-core.c                     | 175 ++++++++++
 drivers/mfd/ocelot-spi.c                      | 313 ++++++++++++++++++
 drivers/mfd/ocelot.h                          |  28 ++
 drivers/net/mdio/mdio-mscc-miim.c             |  35 +-
 drivers/pinctrl/Kconfig                       |   4 +-
 drivers/pinctrl/pinctrl-microchip-sgpio.c     |  14 +-
 drivers/pinctrl/pinctrl-ocelot.c              |  15 +-
 include/linux/ioport.h                        |   5 +
 include/linux/mfd/ocelot.h                    |  35 ++
 13 files changed, 773 insertions(+), 38 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml
 create mode 100644 drivers/mfd/ocelot-core.c
 create mode 100644 drivers/mfd/ocelot-spi.c
 create mode 100644 drivers/mfd/ocelot.h
 create mode 100644 include/linux/mfd/ocelot.h

-- 
2.25.1

