Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A06D546C0B
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 19:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350235AbiFJR5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 13:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350229AbiFJR5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 13:57:11 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2121.outbound.protection.outlook.com [40.107.223.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 270E76AA72;
        Fri, 10 Jun 2022 10:57:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oS/CTuf4oK0on/xMjrfvE0hdchwZwS6QE6ohMCPdsTFt/6wmboN5KsFW+gmgqptRCb9AUD9ZEP6hZ50m9XlH/WCALw4jfPtkJlG+JHNUjHlM81+RkbdxDk1e81oDhyyYbp/gmZ9IwwN72QG2p9I+FVEwY2H2KcZCcYYQAA4km9SnxIrmxXHUebFaEMrvSfXGOLzK99nyw9mjqJmK7zQ7uIdTrz2J0P+dT6NJUJbu0SWJRF7RyI/fgBuQDL6gLaMdRxczLBGnoZDJC19W9ANlUaMnChCjhyZJULaUhehPGAjRBqemMG33JtGmRS8MpOODhHPX/+D/UgywFXGtjIxA+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yfoRC535zL7s7jBaHbqCVKXoM/gj57GffkONTm+sSKM=;
 b=VUzIlZGdOfsFYWYv3qr7ODc11T+8jObHIUIqJAwm9CZfHgA71S0j8wqMgeWfcO5TvK9dxu8D8IsRE9DsM5uSZVMRrNiSKn1O0F1mvZ0wbV0m6udryxpkG6ceJaWnrEwxXlBIrp0MhF6NFoawul4jkQmP9SCOSeQjeQ4RM3otGrZ+jXuvdYlhtqSo27iD62ZTWE9HNdgvmR23wF4mLdUXOcoezt2V+L0Zh0vWyslmSsiIVlrEIhF/e5rY3dLbIQ16/hZwaLtxtQZkv1hcQbpmcrMbsU9FEv9rq7667QC6AvU14hE6YPbEXuDfnT/ZZrr6GsI06dOj2xI1usi7AotwGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yfoRC535zL7s7jBaHbqCVKXoM/gj57GffkONTm+sSKM=;
 b=RukwsAoWXhMEJu8C0/giPzbLCqq1SfU4chA3lTh6O8i2wq78XyOW0fgxLvu0xB77NlKj/zRsUN9PVcFXOvkZcpGedTRgliKZy3S7irjsGNMO8H1H2lYZOw3ElI2pI2Dwnc9ZP1fBI9PjO9E4/6xORTrTzByShSxEuFF0jW9vLBI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DM6PR10MB3356.namprd10.prod.outlook.com
 (2603:10b6:5:1a9::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.15; Fri, 10 Jun
 2022 17:57:05 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b8c0:76a2:4c89:d10f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b8c0:76a2:4c89:d10f%7]) with mapi id 15.20.5332.014; Fri, 10 Jun 2022
 17:57:05 +0000
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
Subject: [PATCH v9 net-next 0/7] add support for VSC7512 control over SPI
Date:   Fri, 10 Jun 2022 10:56:48 -0700
Message-Id: <20220610175655.776153-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR19CA0070.namprd19.prod.outlook.com
 (2603:10b6:300:94::32) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a19aad16-0e14-42ac-ae6b-08da4b0aa101
X-MS-TrafficTypeDiagnostic: DM6PR10MB3356:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB33568886A48A7C3D22987419A4A69@DM6PR10MB3356.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IJyN/Plz7sTazClPjc01pL0QCAw1Z92CVbqupHO7uZDxuG78BQnxGS9W8hy0Opq7UWBTUYdRAKh6X8qTQSO5gWHrVlowqMePRiMpv+xG5QaqUXObg6CPssyQ502hFDIjUMLXANk5T48dRcI+M6cudKXD8HSzoUkgAYXgKYiMH6H37aRSIpYb4CB6w1+QfJOINmDDM2apaCKD7KyayS9yZx023bdfSky6kAaURbJjOPW0spIu4n4H38l0mckn6Y17UpvSDF1p3hZDQaWEcxaU5A9RjG8zmlO5X+9lJ752vMI1NGlS2XRmELdMyrlfzJ68e0zMClpaw9+CubF5wb057MztPaCL4E4mG5/VQxhQBJTTOTSQeP7B0DR7dGI0XgVcBT6kmDLWTcsfaAZ5Cfb0SlGO9z7rQz/VSCDHcJfEveE7zwaUUZhdUhmdFSAaTL4SIiMRV0d5rDOT/iG8cbz+UpvXv3GxfkkajY8FEtwxARSFbEUaoSVIDeDa8UyeZekDMCQCAJtVlGiFgA/M68Zyk74DB7MIlp+T6ZKi8+TADlQWlwAksK2DhmfXnB8TEVOkMnBJrdTUeJXvHkwJ9XIaIucagxr6H69qdqpdlM7KOCNrAYOMano4tL3Fu2Q5ZjeRwcPpMZb50q3nZZ8mVj5IU4eep/yo75bDYXEn8QpGc1laPaTmUi4U3dyW6lK3GVNSHkcWZ/i9bvm/xz3vkh/DOw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(346002)(366004)(396003)(136003)(39830400003)(1076003)(54906003)(316002)(4326008)(52116002)(8676002)(2616005)(86362001)(508600001)(6512007)(26005)(6506007)(6666004)(41300700001)(6486002)(186003)(83380400001)(2906002)(38350700002)(44832011)(8936002)(36756003)(38100700002)(66556008)(66946007)(66476007)(7416002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KSljU+cGYcvdwwEo/bqIL6T6xqr1FduPlVi32ogIP22wccze4FUOgojRzsKj?=
 =?us-ascii?Q?E0HU5fYZ2T84iRCO1L7ibt0BbC6jNbRpNtFa75OUwQF8r1H0t1QFnGDqSXe+?=
 =?us-ascii?Q?qJJrKYWuVTUjMliTBC+TEGdSG8b7g0qguMl+rpkr0paYq1YQ9mJ5EsS1EyhG?=
 =?us-ascii?Q?N602t/sajj8diwEV9GkGldmCX7ipvv7Ol3bLNwM+6ARAzPTRPXgY22RKLxS6?=
 =?us-ascii?Q?EYWXdAmp1b9U7g0Mnk202JNCp4Tu3hf0pyNurxIS1HVV4+fRcfJI2/QFWP92?=
 =?us-ascii?Q?PiOoygP6Xc8gVHVG24Mme6Bq5z1D1ynaG9Y72dsN8EjDc9vdn1qpPkpxZ08o?=
 =?us-ascii?Q?zYzvTk/xS92esk4e15PucS5pMUSQQ46H+5DnQX+wyrJQlpQN+EuYdsJedV7Y?=
 =?us-ascii?Q?Gg0DebK5vF5C1tkDzQ8blhQYqrc4iDoip/O3mzThpevfDgP4E1PIV1W6rRqJ?=
 =?us-ascii?Q?MUlNLY0oKeKK4W+F8bznBUWSaxrJ7Nj/eNyXaA4YSEzKwJac2/E4lbnP2yCD?=
 =?us-ascii?Q?8qE5ThWqg1ExW+9uSjDTGHbeNIfgWt8WgwPNPdZpmH0pMiCQ2t3WqXCiMLNk?=
 =?us-ascii?Q?K6UVGwI16ZMgIPdlzeBFuwCvbCKC6SEddoobsG3FJjN0iQs+UTWvqZTxGFRQ?=
 =?us-ascii?Q?sxVY01s5gNjIOO/sgGEji7SE3ltsy7493aCDFg86M0Fk0kk+GDkefYtHTxFd?=
 =?us-ascii?Q?ZjslNOqHitzByzwSeIe4/NBkiitPUZvJup4RVrKdVN2h/cw3YIbghQ1dDtqV?=
 =?us-ascii?Q?ymeVAqoLohrEh9YN3T45/daEjntXu7FUtrfonV8WEBF1vpFg1G9ckEtzHZEp?=
 =?us-ascii?Q?O/sAmMFWXPJ899WaEjPi6/Ww/8NiTE9dYS1T/18Pn+fdiIjEFRfBgYp9NF2e?=
 =?us-ascii?Q?yIs8JI2Gji68canZ+1cEtibz5TQBRtt7nuiGNaEG1SOtdW8C0SkDlHZyKBSr?=
 =?us-ascii?Q?oEcX00eEqatw+JFESCmiQJn3xEb46FqL/iNKDcJHTZizpaNLeiiGzZeG6TPj?=
 =?us-ascii?Q?X1JLrfeSkU77QlCsQU+nyL/40bWw8v1bqjH0iF5r790ACFFVK5yRILPn8hVV?=
 =?us-ascii?Q?vfJSYnRU5RS3IEh777CFCLGflOh5O5trK2PRa9g8EWU/Hd1CrYr5YMFyoI8x?=
 =?us-ascii?Q?N/9+gLE6fkv39JdCGvEUfxRDQlTigv1Bi5tTZFtyv06MuKrJH2BIcSNcaFuT?=
 =?us-ascii?Q?FzjglCpVdbPwqaDb1SOvDXYVByBkwQvSK5EEDqeoYXy/hpRxqfRogNB1Nobr?=
 =?us-ascii?Q?jzP+kREM/SBV7RGleUuPRb+Dk1EttALB8cEu4RJACgZI+6Veo2hNNzoaNEGa?=
 =?us-ascii?Q?9tI9TMh3lr6UMZAkYu/K8km1UZ9N1K2Qy0TA7mAr5ObIPQeSvveUMTFtzGpb?=
 =?us-ascii?Q?1Z4rhQPMLy9tbTm/d23iiGh2LYqnFr+P1NGM/yLywvt+8ubMKAkb/prYg9+0?=
 =?us-ascii?Q?mz56h+W5SdaYhQD75i9ikSutmAH8mvElquKuWx+kh43J+a0z3lMzplowLFe0?=
 =?us-ascii?Q?wT6sVojmpkuVMgqSIV/mL0KCud20hvEY8CZe4EcHsNXuAQYnMhqJawUFRvln?=
 =?us-ascii?Q?vGOat6EG8erRQc1KFYReOgkjxuvHmx3Mw96WFjh4y27JjdrHEGAyL4V1kbR8?=
 =?us-ascii?Q?AGp5/5HaztdtUUxAO1JkXdGQgesQecOSGzWjnnueCfyMXAitpmSIZvdqkBLL?=
 =?us-ascii?Q?X59NUAVja1rzyeYpgxWSJgEYOoCWfi3HgvRQE3vnMP+a+8JBpIHbN5TsOcAp?=
 =?us-ascii?Q?ArDdLvp5EDeHKHLmT5vLpVi4KLPgxYdto0KXSX2s6NWEhbAaUbdn?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a19aad16-0e14-42ac-ae6b-08da4b0aa101
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2022 17:57:05.2781
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kL5g6PHh8geNS4Y3ndoFmy6TY2PKF0Us+4XrGw9cysDytd2uJUegW2ceqYQjYGylMnaxyLLYbI2Fpv+kKXwAusqsvBsj8htirHCE0w5Mbj4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3356
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
 drivers/mfd/ocelot-core.c                     | 184 ++++++++++
 drivers/mfd/ocelot-spi.c                      | 313 ++++++++++++++++++
 drivers/mfd/ocelot.h                          |  28 ++
 drivers/net/mdio/mdio-mscc-miim.c             |  27 +-
 drivers/pinctrl/pinctrl-microchip-sgpio.c     |   9 +-
 drivers/pinctrl/pinctrl-ocelot.c              |  10 +-
 include/linux/ioport.h                        |   5 +
 include/linux/mfd/ocelot.h                    |  32 ++
 12 files changed, 763 insertions(+), 32 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml
 create mode 100644 drivers/mfd/ocelot-core.c
 create mode 100644 drivers/mfd/ocelot-spi.c
 create mode 100644 drivers/mfd/ocelot.h
 create mode 100644 include/linux/mfd/ocelot.h

-- 
2.25.1

