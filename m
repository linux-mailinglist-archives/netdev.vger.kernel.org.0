Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84ABA51EF83
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 21:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234427AbiEHTDq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 15:03:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235886AbiEHS5V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 14:57:21 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2115.outbound.protection.outlook.com [40.107.223.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C593DA1B1;
        Sun,  8 May 2022 11:53:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nIgZRIQ8NolNaEmLQqpniedICes2fnUQyrHCeb/nNrT5APf4Yt2vu0swkRLdM/2nSJMaP8v9kladIpIZMLTDhZbX2bZs0cCeLxPxSGbVrKoLLZ+ic2jJqDHmYN4vJz+3dDv3ODTCrBUjaXKhvtvUl5jGghuHBbgyi3e2r+fg/gmkNTyYFoyLZ5EiyC83IPEnQ1oPf2IzlOhTH+6q5bq/J3s+pSUWAFcaw7x1mv6d/a8iOyS5v164Mg4WM3kP4vVHauxP2ytkizS9M2mm04Q4uANKCBlhQBqMwUW9397ZryUybrdUDjUlrcUH631NtOsK5wIFvV2ma7f06CXelPhqYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YL0Qj2T3LPScZxsALjGxBTEcLOVm4YSI7x5XngbMCrg=;
 b=ni80TKVR4afwCczsotmyvBq0QIoOsVzEkx9l1FGbGMhA78p7gDLQ00QvKKu4AIxlKEePYQp72JeptHKi3S0f8sLHaIeH3Wcox5mJB0lUdKZjnnNDsMFggAYN5UDcTbulLhO1U3+wUgE+cVPWCI02OKfvx+P6kAt49boJECooIfhzy7ExLoKTUOoWPlrtACCCCV5Gn2XtQrp6nDzx46Q2E8vYmCD8BnsX7+Hn0kLuIYA75Y46SJoJydv86BuInnJJkynK+iepw0s6YbI4uF8iBaV8tn6eQy2hl+9NvkuMWno13rHeFFbLfYa4v7BsheTT1KZk2Iptd49ow5o5zHYh4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YL0Qj2T3LPScZxsALjGxBTEcLOVm4YSI7x5XngbMCrg=;
 b=sbDl1O50tvwoy/5RVU/wFwy6DMqTqT8ocZC43rlQeVQzReVCaQ8dotLnhFL5xqGyRJxea9anxK1UvGnegZ/ioJj9e+vFnmChVux8jPzHbmmtTc+64NYgEZ8yQWlqcHkQDbuoXf+0IzfopMdZl+JiM3vIOGTLOSy6qb2U7WiPreY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SJ0PR10MB5533.namprd10.prod.outlook.com
 (2603:10b6:a03:3f7::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Sun, 8 May
 2022 18:53:25 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e%3]) with mapi id 15.20.5227.020; Sun, 8 May 2022
 18:53:24 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Terry Bowman <terry.bowman@amd.com>, Wolfram Sang <wsa@kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [RFC v8 net-next 00/16] add support for VSC7512 control over SPI
Date:   Sun,  8 May 2022 11:52:57 -0700
Message-Id: <20220508185313.2222956-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0045.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::20) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 050f2d61-3208-46f4-5c20-08da312407af
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5533:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB553339943BDEE2B85BDBF957A4C79@SJ0PR10MB5533.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5Jfc1cep98sUmLYuLmbRl6z3ioC1tNuM+RBHwuQ/mwZfvJKqkbFZWnlHcMAAug7LvZ/2YFTxgmx9qivf4bgiaaNVKZrtAJ1z+ECym4rYkunHKh0Gq9/yD7z6o01ZRqTAKRS5NQ5hjs19nqMvlURjoz2zLp4rKbCio4n7H6OZnLg3h4iL56+xFvzMXfs2jkXEeHwoLKPeWKzciqJZT3ZOC2ci6MXtgeR+PGvEMuhHVM0X2hUf2gWLimtOEa5MaWa/CZUzzk8NfqkBIV8GJ7KHuozjv9CcE0SdYSXK78JYrzeaJZk2WxvhjBxe6u9nYaEn76gc0T56k+eRCAbHBGb6lRkcaC1uzew+mEDExQus4tUnC9NhC0nc/V+X1ICJsjWECiDYALg5JqpmshtCYilLX4uK4l4DS4+xaYE7j/ANtFHeFZBjc0dSNhHPePMhV15oPr6ETE9D00DxcN8sNaU+0tsawKO9I5LTAQ4JgE3GKaP0zZafFquTlqHIdeaAI7jLGfycGLpZ6cA6OE+Xi87GTnnlFfHbAG8wIDj89DTeWLwtsBIjSiGV61VzUidOB2Gb/wDw2gw5bnmDKaFS0x3gB3suS2tzjwlRPNrFcH9lqXB/lpyq6djwrLfBFNdrP+l8PFTkRwDsbR9ONgBt9YPM8ebCO+8i3yt/cOOHdQIMP278h7rpnAu/rsGSayiu/71FrMK2iAb6Zh6jcemWO2mcgw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(39830400003)(136003)(376002)(366004)(396003)(346002)(316002)(66946007)(6666004)(30864003)(26005)(66556008)(508600001)(44832011)(6512007)(6486002)(66476007)(52116002)(186003)(86362001)(2906002)(4326008)(54906003)(8676002)(38100700002)(2616005)(38350700002)(6506007)(83380400001)(8936002)(7416002)(1076003)(36756003)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QrwtAJRTh4pR8MlDnyl33oEnuDLWewoo9IYGHfy5IWKjww19CZ7nOtliKQSF?=
 =?us-ascii?Q?ihyetIpb7uthjdZqUrLYPR5X2706BjG+ax1BlO7k8NBn7YfGjRbCSnMdJFG9?=
 =?us-ascii?Q?ueHeGSEI0yqNTfCuJdwO90xbvnYAsFq7KB8wFxCnIbTCW3YIFP+RcMJYXg5g?=
 =?us-ascii?Q?0h07QJmiwP3EpL/Vho3fdURMSoKB271JUUWgPLBOqg+iZPng+Hd9YG2c7zaf?=
 =?us-ascii?Q?j8uVeeg3hDZNlcN+syAa0pZwEvVvc4I1QliSxzP2cAY8ik59zGwvP/vD6uDv?=
 =?us-ascii?Q?GMKPFrqBeACs+LXxAx31wm/8/rXsG16cIUpt7cCI5zg8Mu5L2no+6h80y7WQ?=
 =?us-ascii?Q?PdQB4vS17M6WtO4Am3kBKtOBuR2dEA+lVsi0INBSrvI0SusvihQ3gIvw9s02?=
 =?us-ascii?Q?UyEpXRJm9/qlZMEVAvdEdI5qc1hafBPgByrMHopc5nL6TmSeLdVCNB5shAF8?=
 =?us-ascii?Q?j67wAB6NxaUoaQ8iUdITd1ntR4dr7bMaAWzlhlaXe63OiSR7Avk81NIPslSv?=
 =?us-ascii?Q?mU/KITpO5zmzfvzcqZb7Pi9rb8vwhtcHuPYWJYDv1+aSsU75z68UWBeJCuK6?=
 =?us-ascii?Q?bz6kTNdYYwf+P7v0qs1uIwsIYvAYBT8kKDLQ06QdVOgm4mL4w/jKWejOJdPH?=
 =?us-ascii?Q?XNda7Bqtu3xWfw8VeHJWIfwyYHvUSoH3Nav3vcVNBl35jwnY4LD+n8O7qPg+?=
 =?us-ascii?Q?h4eAmTioQyidZSfPfIQefbHlrP+wAZFtvwHo5VIjPOUopd6PQ4xR1h2OdIe9?=
 =?us-ascii?Q?hJ4qCOAXq2qnlLEe14VPwkavMRPIucKM44tNwMgOxYP+NDkP58LS5TRVbpYb?=
 =?us-ascii?Q?NCaGnBOPJ98SyppR6ALakrh7Kew9p7dsmUtzymk7jqQAdlfJ19MprG6zZCb6?=
 =?us-ascii?Q?pHpUHdtwJ5hqXXVqSUji9xq2Xa3KK4lr9ot1+2DfBX9EqGZU9doJyPrd5uoR?=
 =?us-ascii?Q?i+QfJooD9h1LazOzC0ZsqOTrg+ZqFccW2xloJkiWzVwNSegTl7Ko71WK8thQ?=
 =?us-ascii?Q?4bJdNt9BUE2b49av2RkMijZjuknJzSZDBvkT/Y0s/QRSDTtU3zL+zvW48+Q0?=
 =?us-ascii?Q?cwJGUnuUvszOLvHt/bYnq6q8W2AoZ46L0lmGl0N4XLAYUrDsDSN5v9BR+6/4?=
 =?us-ascii?Q?EUdtRQgA3YlHb0xYZXxAJKa3fnSK10Vcmy/n5VdLOVVLcVBUzauShbfoEPsG?=
 =?us-ascii?Q?uNYoSndEIBQB7bdntrBOclC5IpVX6ShfsTQt4++0j5kLntCcBu4gC5E9KQ4x?=
 =?us-ascii?Q?LG1YqogUKHwn451jYLpvRDz8pgAgXd1ZksfL6/BTuKR4K8Kutnz/Yhk1JKY5?=
 =?us-ascii?Q?mw669o4+ixrQqPFbq/M1+b8mUzizLXSjXd6tBKNroi2qadr6xJjSd7V9wPIe?=
 =?us-ascii?Q?ePDwdmB8vkA8drp7NnIfXktIa0O3jUfaIqMFlqO3ioN9LZOWYt87sOlK654G?=
 =?us-ascii?Q?7EakzsoGpxIkpeU6ICfHQ0JakMWQE34+2ELjPKIykCsppTGdSoun8Koj9se4?=
 =?us-ascii?Q?fqEEuL8bFPDgyWVyHrr/9pHvziMUYRcKL2i3SLJp4FASsRpby13dpTghT3TX?=
 =?us-ascii?Q?Z9/R2/ZkFiPg2xVAB1Uj99MzJ06t3j1YbGDjP4Fs8LSzmzbRt25cLqzK/r6u?=
 =?us-ascii?Q?nKT2IKCx9rIZFRZzpWx+G7lh/mWYeT0S+gEoWakQcCeK+lYWzR15lA5Mxybe?=
 =?us-ascii?Q?dAo1Zu7J7wPeDYGM+MaItBh9/G8LULyhdyEiHNOjrkDFFqM0Xw+0AxhsWb/o?=
 =?us-ascii?Q?YkW0tLUQxrrfWF3ZjPbknEDi0B5mmcKbN6wcH8ZLbzi3rLBMffxX?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 050f2d61-3208-46f4-5c20-08da312407af
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 18:53:24.7144
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9wBm60tylZlAzDsYN+sGBYJpxDXChmsPg5o0DRrYHOZe4qZTlgftVtpBzs85asX08s95h/q7HliIVyJSZl28cJsI/trC+jmJaqTEmmeYxro=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5533
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
SPI. The driver is believed to be fully functional for the internal
phy ports (0-3)  on the VSC7512. It is not yet functional for SGMII,
QSGMII, and SerDes ports.

I have mentioned previously:
The hardware setup I'm using for development is a beaglebone black, with
jumpers from SPI0 to the microchip VSC7512 dev board. The microchip dev
board has been modified to not boot from flash, but wait for SPI. An
ethernet cable is connected from the beaglebone ethernet to port 0 of
the dev board.

The relevant sections of the device tree I'm using for the VSC7512 is
below. Notably the SGPIO LEDs follow link status and speed from network
triggers.

In order to make this work, I have modified the cpsw driver, and now the
cpsw_new driver, to allow for frames over 1500 bytes. Otherwise the
tagging protocol will not work between the beaglebone and the VSC7512. I
plan to eventually try to get those changes in mainline, but I don't
want to get distracted from my initial goal. I also had to change
bonecommon.dtsi to avoid using VLAN 0.

I believe much of the MFD sections are very near feature-complete,
whereas the switch section will require ongoing work to enable
additional ports / features. This could lead to a couple potential
scenarios:

The first being patches 1-8 being split into a separate patch set, while
patches 9-16 remain in the RFC state. This would offer the pinctrl /
sgpio / mdio controller functionality, but no switch control until it is
ready.

The second would assume the current state of the switch driver is
acceptable (or at least very near so) and the current patch set gets an
official PATCH set (with minor changes as necessary - e.g. squashing
patch 16 into 14). That might be ambitious.

The third would be to keep this patch set in RFC until switch
functionality is more complete. I'd understand if this was the desired
path... but it would mean me having to bug more reviewers.


/ {
	vscleds {
		compatible = "gpio-leds";
		vscled@0 {
			label = "port0led";
			gpios = <&sgpio_out1 0 0 GPIO_ACTIVE_LOW>;
			default-state = "off";
			linux,default-trigger = "ocelot-miim0.2.auto-mii:00:link";
		};
		vscled@1 {
			label = "port0led1";
			gpios = <&sgpio_out1 0 1 GPIO_ACTIVE_LOW>;
			default-state = "off";
			linux,default-trigger = "ocelot-miim0.2.auto-mii:00:1Gbps";
		};
[ ... ]
	};
};

&spi0 {
	#address-cells = <1>;
	#size-cells = <0>;
	status = "okay";

	ocelot-chip@0 {
		compatible = "mscc,vsc7512_mfd_spi";
		spi-max-frequency = <2500000>;
		reg = <0>;

		ethernet-switch@0 {
			compatible = "mscc,vsc7512-ext-switch";
			ports {
				#address-cells = <1>;
				#size-cells = <0>;

				port@0 {
					reg = <0>;
					label = "cpu";
					status = "okay";
					ethernet = <&mac_sw>;
					phy-handle = <&sw_phy0>;
					phy-mode = "internal";
				};

				port@1 {
					reg = <1>;
					label = "swp1";
					status = "okay";
					phy-handle = <&sw_phy1>;
					phy-mode = "internal";
				};
			};
		};

		mdio0: mdio0@0 {
			compatible = "mscc,ocelot-miim";
			#address-cells = <1>;
			#size-cells = <0>;

			sw_phy0: ethernet-phy@0 {
				reg = <0x0>;
			};

			sw_phy1: ethernet-phy@1 {
				reg = <0x1>;
			};

			sw_phy2: ethernet-phy@2 {
				reg = <0x2>;
			};

			sw_phy3: ethernet-phy@3 {
				reg = <0x3>;
			};
		};

		mdio1: mdio1@1 {
			compatible = "mscc,ocelot-miim";
			pinctrl-names = "default";
			pinctrl-0 = <&miim1>;
			#address-cells = <1>;
			#size-cells = <0>;

			sw_phy4: ethernet-phy@4 {
				reg = <0x4>;
			};

			sw_phy5: ethernet-phy@5 {
				reg = <0x5>;
			};

			sw_phy6: ethernet-phy@6 {
				reg = <0x6>;
			};

			sw_phy7: ethernet-phy@7 {
				reg = <0x7>;
			};
		};

		gpio: pinctrl@0 {
			compatible = "mscc,ocelot-pinctrl";
			gpio-controller;
			#gpio_cells = <2>;
			gpio-ranges = <&gpio 0 0 22>;

			led_shift_reg_pins: led-shift-reg-pins {
				pins = "GPIO_0", "GPIO_1", "GPIO_2", "GPIO_3";
				function = "sg0";
			};

			miim1: miim1 {
				pins = "GPIO_14", "GPIO_15";
				function = "miim";
			};
		};

		sgpio: sgpio {
			compatible = "mscc,ocelot-sgpio";
			#address-cells = <1>;
			#size-cells = <0>;
			bus-frequency=<12500000>;
			clocks = <&ocelot_clock>;
			microchip,sgpio-port-ranges = <0 15>;
			pinctrl-names = "default";
			pinctrl-0 = <&led_shift_reg_pins>;

			sgpio_in0: sgpio@0 {
				compatible = "microchip,sparx5-sgpio-bank";
				reg = <0>;
				gpio-controller;
				#gpio-cells = <3>;
				ngpios = <64>;
			};

			sgpio_out1: sgpio@1 {
				compatible = "microchip,sparx5-sgpio-bank";
				reg = <1>;
				gpio-controller;
				#gpio-cells = <3>;
				ngpios = <64>;
			};
		};
	};
};

And I'll include the relevant dmesg prints - I don't love the "invalid
resource" prints, as they seem to be misleading. They're a byproduct of
looking for IO resources before falling back to REG.

[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Linux version 5.18.0-rc5-01295-g47053e327c52 (X@X) (arm-linux-gnueabi-gcc (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0, GNU ld (GNU Binutils for Ubuntu) 2.34) #630 SMP PREEMPT Sun May 8 10:56:51 PDT 2022
...
[    2.829319] pinctrl-ocelot ocelot-pinctrl.0.auto: DMA mask not set
[    2.835718] pinctrl-ocelot ocelot-pinctrl.0.auto: invalid resource
[    2.842717] gpiochip_find_base: found new base at 2026
[    2.842774] gpio gpiochip4: (ocelot-gpio): created GPIO range 0->21 ==> ocelot-pinctrl.0.auto PIN 0->21
[    2.845693] gpio gpiochip4: (ocelot-gpio): added GPIO chardev (254:4)
[    2.845828] gpio gpiochip4: registered GPIOs 2026 to 2047 on ocelot-gpio
[    2.845855] pinctrl-ocelot ocelot-pinctrl.0.auto: driver registered
[    2.855925] pinctrl-microchip-sgpio ocelot-sgpio.1.auto: DMA mask not set
[    2.863089] pinctrl-microchip-sgpio ocelot-sgpio.1.auto: invalid resource
[    2.870801] gpiochip_find_base: found new base at 1962
[    2.871528] gpio_stub_drv gpiochip5: (ocelot-sgpio.1.auto-input): added GPIO chardev (254:5)
[    2.871666] gpio_stub_drv gpiochip5: registered GPIOs 1962 to 2025 on ocelot-sgpio.1.auto-input
[    2.872364] gpiochip_find_base: found new base at 1898
[    2.873244] gpio_stub_drv gpiochip6: (ocelot-sgpio.1.auto-output): added GPIO chardev (254:6)
[    2.873354] gpio_stub_drv gpiochip6: registered GPIOs 1898 to 1961 on ocelot-sgpio.1.auto-output
[    2.881148] mscc-miim ocelot-miim0.2.auto: DMA mask not set
[    2.886929] mscc-miim ocelot-miim0.2.auto: invalid resource
[    2.893738] mdio_bus ocelot-miim0.2.auto-mii: GPIO lookup for consumer reset
[    2.893769] mdio_bus ocelot-miim0.2.auto-mii: using device tree for GPIO lookup
[    2.893802] of_get_named_gpiod_flags: can't parse 'reset-gpios' property of node '/ocp/interconnect@48000000/segment@0/target-module@30000/spi@0/ocelot-chip@0/mdio0[0]'
[    2.893898] of_get_named_gpiod_flags: can't parse 'reset-gpio' property of node '/ocp/interconnect@48000000/segment@0/target-module@30000/spi@0/ocelot-chip@0/mdio0[0]'
[    2.893996] mdio_bus ocelot-miim0.2.auto-mii: using lookup tables for GPIO lookup
[    2.894012] mdio_bus ocelot-miim0.2.auto-mii: No GPIO consumer reset found
[    3.395738] mdio_bus ocelot-miim0.2.auto-mii:00: GPIO lookup for consumer reset
[    3.395777] mdio_bus ocelot-miim0.2.auto-mii:00: using device tree for GPIO lookup
[    3.395840] of_get_named_gpiod_flags: can't parse 'reset-gpios' property of node '/ocp/interconnect@48000000/segment@0/target-module@30000/spi@0/ocelot-chip@0/mdio0/ethernet-phy@0[0]'
[    3.395959] of_get_named_gpiod_flags: can't parse 'reset-gpio' property of node '/ocp/interconnect@48000000/segment@0/target-module@30000/spi@0/ocelot-chip@0/mdio0/ethernet-phy@0[0]'
[    3.396069] mdio_bus ocelot-miim0.2.auto-mii:00: using lookup tables for GPIO lookup
[    3.396086] mdio_bus ocelot-miim0.2.auto-mii:00: No GPIO consumer reset found
...
[    3.449187] ocelot-ext-switch ocelot-ext-switch.4.auto: DMA mask not set
[    5.336880] ocelot-ext-switch ocelot-ext-switch.4.auto: PHY [ocelot-miim0.2.auto-mii:00] driver [Generic PHY] (irq=POLL)
[    5.349087] ocelot-ext-switch ocelot-ext-switch.4.auto: configuring for phy/internal link mode
[    5.363619] ocelot-ext-switch ocelot-ext-switch.4.auto swp1 (uninitialized): PHY [ocelot-miim0.2.auto-mii:01] driver [Generic PHY] (irq=POLL)
[    5.381396] ocelot-ext-switch ocelot-ext-switch.4.auto swp2 (uninitialized): PHY [ocelot-miim0.2.auto-mii:02] driver [Generic PHY] (irq=POLL)
[    5.398525] ocelot-ext-switch ocelot-ext-switch.4.auto swp3 (uninitialized): PHY [ocelot-miim0.2.auto-mii:03] driver [Generic PHY] (irq=POLL)
[    5.422048] device eth0 entered promiscuous mode
[    5.426785] DSA: tree 0 setup
...
[    7.450067] ocelot-ext-switch ocelot-ext-switch.4.auto: Link is Up - 100Mbps/Full - flow control off
[   21.556395] cpsw-switch 4a100000.switch: starting ndev. mode: dual_mac
[   21.648564] SMSC LAN8710/LAN8720 4a101000.mdio:00: attached PHY driver (mii_bus:phy_addr=4a101000.mdio:00, irq=POLL)
[   21.667970] 8021q: adding VLAN 0 to HW filter on device eth0
[   21.705360] ocelot-ext-switch ocelot-ext-switch.4.auto swp1: configuring for phy/internal link mode
[   22.018230] ocelot-ext-switch ocelot-ext-switch.4.auto: Link is Down
[   23.771740] cpsw-switch 4a100000.switch eth0: Link is Up - 100Mbps/Full - flow control off
[   24.090929] ocelot-ext-switch ocelot-ext-switch.4.auto: Link is Up - 100Mbps/Full - flow control off
[   25.853021] ocelot-ext-switch ocelot-ext-switch.4.auto swp1: Link is Up - 1Gbps/Full - flow control rx/tx


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


Colin Foster (16):
  pinctrl: ocelot: allow pinctrl-ocelot to be loaded as a module
  pinctrl: microchip-sgpio: allow sgpio driver to be used as a module
  net: ocelot: add interface to get regmaps when exernally controlled
  net: mdio: mscc-miim: add ability to be used in a non-mmio
    configuration
  pinctrl: ocelot: add ability to be used in a non-mmio configuration
  pinctrl: microchip-sgpio: add ability to be used in a non-mmio
    configuration
  resource: add define macro for register address resources
  mfd: ocelot: add support for the vsc7512 chip via spi
  net: mscc: ocelot: expose ocelot wm functions
  net: dsa: felix: add configurable device quirks
  net: mscc: ocelot: expose regfield definition to be used by other
    drivers
  net: mscc: ocelot: expose stats layout definition to be used by other
    drivers
  net: mscc: ocelot: expose vcap_props structure
  net: dsa: ocelot: add external ocelot switch control
  net: dsa: felix: add phylink_get_caps capability
  net: dsa: ocelot: utilize phylink_generic_validate

 drivers/mfd/Kconfig                        |  18 +
 drivers/mfd/Makefile                       |   2 +
 drivers/mfd/ocelot-core.c                  | 138 ++++++++
 drivers/mfd/ocelot-spi.c                   | 311 +++++++++++++++++
 drivers/mfd/ocelot.h                       |  34 ++
 drivers/net/dsa/ocelot/Kconfig             |  14 +
 drivers/net/dsa/ocelot/Makefile            |   5 +
 drivers/net/dsa/ocelot/felix.c             |  29 +-
 drivers/net/dsa/ocelot/felix.h             |   3 +
 drivers/net/dsa/ocelot/felix_vsc9959.c     |   1 +
 drivers/net/dsa/ocelot/ocelot_ext.c        | 366 +++++++++++++++++++++
 drivers/net/dsa/ocelot/seville_vsc9953.c   |   1 +
 drivers/net/ethernet/mscc/ocelot_devlink.c |  31 ++
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 230 +------------
 drivers/net/ethernet/mscc/vsc7514_regs.c   | 200 +++++++++++
 drivers/net/mdio/mdio-mscc-miim.c          |  31 +-
 drivers/pinctrl/Kconfig                    |   4 +-
 drivers/pinctrl/pinctrl-microchip-sgpio.c  |  26 +-
 drivers/pinctrl/pinctrl-ocelot.c           |  35 +-
 include/linux/ioport.h                     |   5 +
 include/soc/mscc/ocelot.h                  |  19 ++
 include/soc/mscc/vsc7514_regs.h            |   6 +
 22 files changed, 1251 insertions(+), 258 deletions(-)
 create mode 100644 drivers/mfd/ocelot-core.c
 create mode 100644 drivers/mfd/ocelot-spi.c
 create mode 100644 drivers/mfd/ocelot.h
 create mode 100644 drivers/net/dsa/ocelot/ocelot_ext.c

-- 
2.25.1

