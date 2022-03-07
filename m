Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1ED4CEF5D
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 03:12:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234686AbiCGCNW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 21:13:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231687AbiCGCNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 21:13:20 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2099.outbound.protection.outlook.com [40.107.93.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA126FD2E;
        Sun,  6 Mar 2022 18:12:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JI5y7GFsPIx+oNYrQJUEYeJcodNjRIrMtfG0VByaNGEDftMdHk2WDvISqwXCAyxpvvnAvzRrbuK7PGBYi9dOKtugHCHb0MiOUz06a36hxZoLEkq4Q7S4OKMle5y28xZHMfWewyxAz2jO7Hrhqov7Hm+zR87wQGKy60OCNBoYYTBCOz9KKYdaqUEG6OwvGvSccYdBgRwtcconA5ZPyFkYmUb3lsRjvB0pjBmdZX2/FdltNlFA9jlq3ZcYnab7o+Yrd+boRFrDSN+K5+QCv5bgGx12Xp6GfbQqBoYBeS96O0JseScjuTRx/U6835VpFCCmtdMMc6ihGtvhnoL7xeiMAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W3OQJaPrRJ43miCon3QCaPuZcmeyirxtpky4yk/ausA=;
 b=VAiFqd12Fwp2ZemC+/Y04YZjhInzFMoOsCzUf9PZMjbe9iXVskmzqryWPsodB7g8DqiLEK0OIxKYCmQFwX3Hm2bynoWHJRZoQgYmg3x+B7ZiU6f35dziYxAPrjaARgH6MFdqPQh2/oJ7bYDgdC62CSbukR/o9iffL8VlfjvdkAepAlZD+EEm5a/4LyQx/GNislEo7Z4+hoVGhGRlwDdQjd5GeAI5Y5t+g9s3/eKv7LFZQXNUth/3z+gOIsN7REbRgL4K6HfVP2SByDLAKsT8mJN2PVszTgi+3Wb8jX8ZfvbwKfaXiff4xtB4ZlAMBEk6FUL0ulfuCmvvcDGgJI3mSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W3OQJaPrRJ43miCon3QCaPuZcmeyirxtpky4yk/ausA=;
 b=yWAaITb5tPapVHRXt/H2BIZn9KC5/9x94UPKqUzAicDLCldvhsQ1VzM+KSoRuw2VsvJWsPtnxruNUGyPTc4ko/TVzTs9TGe61VMu6PWCRxsSSjuZDrqPAzmJzPWrz/S2d3WgcSrROm5TpVYZRYHVruzrY83C+YnvbaA/hpeEAzQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SA2PR10MB4553.namprd10.prod.outlook.com
 (2603:10b6:806:11a::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Mon, 7 Mar
 2022 02:12:23 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5%6]) with mapi id 15.20.5038.026; Mon, 7 Mar 2022
 02:12:23 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        linux-phy@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Marc Zyngier <maz@kernel.org>,
        Hector Martin <marcan@marcan.st>,
        Angela Czubak <acz@semihalf.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>, katie.morris@in-advantage.com
Subject: [RFC v7 net-next 00/13] add support for VSC7512 control over SPI
Date:   Sun,  6 Mar 2022 18:11:55 -0800
Message-Id: <20220307021208.2406741-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0174.namprd04.prod.outlook.com
 (2603:10b6:303:85::29) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7f44f891-478c-4f66-9f0f-08d9ffdfea90
X-MS-TrafficTypeDiagnostic: SA2PR10MB4553:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB45537BAEEA4B7E3B15FA30F2A4089@SA2PR10MB4553.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bT8nFUX1K6xiRkFUl+PR6+73hCLFNE2I8NqYqD+qxbawOW0mDgzFwekv+YDM1u/x8nb647q2Dbol21BqUXlkwHrS9LGZfiYSaMihJKkbaeL2/uZoCa8/3dT1WZ963mEKN2ZkX21p7Rf0vy4rJnDQ2n9IvNTPxxYEJQ+cA5QoJywihNljBpouB4WBURYz/xV95PSybUTze+Q+gAL8Zm2oMxcAROHspj4fYY2B5u+l+BbtkIUIu6VaiaRIJmlM70WTfFSLbJE4MllMTbUajfOrVKht4C8NTinZPyflSDdSyPgfzpkd4ElnFQI6Z6VHGe63qTMOn6HVWfPDW6FRfK0kzCvu7UI7EHmtyuZdta4Sc1lj3ckKI56fMmPx+QRp/V8LytLFrTdh6F/mMfgYT83SDtu6UGUhYgH8HyZK88jHBCBW8ykkOofb5Qi9IhaDjDXvh332UaooREwFeL01tSP6YuQWOBhBmOK+R5yKCMw82kZUdZOt+tbhkwBKLw1XHalg3YMo3mThOm7W82n4PmXszdMOk9XAAZLdvi5JgbrgFfezTv41M2SkKE0z3T2QTJzZZ2kSwW9bo8bBnDozx8bbhVA/Cveo/umZYKL8IqdpKVZHfLdO5Y/Ggs8+mEpM5zAWJsTo5iEzO9UN/qSFTrtLGd40ppJ1VMhvu4jF8JPesD6+W+nMXD1uoWB9v2ovbexBX47Yter6Qy9aT9I4S5UwLA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(376002)(42606007)(396003)(39830400003)(136003)(346002)(38350700002)(86362001)(508600001)(107886003)(38100700002)(6486002)(54906003)(36756003)(44832011)(6666004)(6506007)(66556008)(66946007)(4326008)(316002)(66476007)(8676002)(6512007)(26005)(186003)(8936002)(83380400001)(52116002)(1076003)(5660300002)(7416002)(2616005)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f8V6wtOhYrCB7f4T7QgO/3ydAYjAw0LeNa+t8q1ppApaaPWdTraQdnYshjqr?=
 =?us-ascii?Q?XGsvux/KnUjVQ2sIgdUDzxz0l3eTZJBYDZ9kJWeWFmN87bqTIJMGdtgMStzK?=
 =?us-ascii?Q?NXjuMHXz4hmRtGfiUENLl7sb7ngu0Gq0nbi5F7XC/UY9iAdMlCsT4oVV3Xdr?=
 =?us-ascii?Q?dZtddBYd7u9Ne7iFop4ypbCY2KCfo8LEI+irWrbpS32aHTtEPkGMWwMKGyRt?=
 =?us-ascii?Q?R90tdFQMXvYXFpAdjDsQ7CA6kcnP9dBvOtsHVA4dCzo3J85WMNOK9beWrd6y?=
 =?us-ascii?Q?UxlDOarRNmk7faqMOM4ssnU7L+FLTcvjfQvnoU7jmOJ4WwRjDgg4BY3XMGmy?=
 =?us-ascii?Q?B/YJjHPGrGXClWuO9nDY5qSFooEcZthKVEDvUHB/Oglo0QZtBXB7iZTVdzeX?=
 =?us-ascii?Q?KkY0YfPCBaofiZDhIVG7wRxukfw60JRAD7S0uL94hr4WqzZVcRQOwCGJmnH3?=
 =?us-ascii?Q?q+vGO/if/acol5u9+Y5C0eepEVWzfWPmx8xj4LPrSCbQ0P1eWglhar2O8MqT?=
 =?us-ascii?Q?NT/a1H3crOMiY3uCKg8W54TN9L5hCtRRHc8tiEqBkGj98GBoUPohsjpHtdR4?=
 =?us-ascii?Q?xx9MFhhPXA8C5m+zmgoAHQx3YloAqnwRUVuVmrN3/EciQsTnpXuEAOEwfgla?=
 =?us-ascii?Q?1HaQF5Dm7oEV59lihhdMz0SXSSMHwBXHsHG+sdGyFKVycyTVG2sZ0MLHjfE4?=
 =?us-ascii?Q?cSRHbDgReVpEBnjy+BqtmsS/Nq3tNBP1HTwzIqlZ5BuTJ2GoQQxTyzGS5mvb?=
 =?us-ascii?Q?F6i2ISkKg5EjIK1hqsI4/uk6YV+icEANTSxEck4COzXuHqPaUXEnsKE67+VC?=
 =?us-ascii?Q?Vjr24jNcjcKTJMx/ZTgsbpuXjdecvovUpfO3OQ8+XsGTgARnIf7VSTGSmyF8?=
 =?us-ascii?Q?WlojxpjgjGmLRWleWkKaszZWExJdlo1HGf+oFrDCfHhZLqup7rcg0c+AAv5M?=
 =?us-ascii?Q?C/ck1aO3I3qrgAvKBzXh+waSTKRsieDDxPxefU2t8DE+xwsOkh0Ohupb/vjA?=
 =?us-ascii?Q?UGAeYomE8gXxcTHiZZGr71SbqSeS/gvIj1hXMw0uCJf6Syrd9Uw7sLMfy8U5?=
 =?us-ascii?Q?2sXoJJNrgB2aKVlJDB9mliYN6bJd2RV7jtd9eNz3iZ338K9IHGPUMpktdyH8?=
 =?us-ascii?Q?7m2rzzt7s2ytjSNPaOGX++wUZI81dhx1ECWy8HYdl24jk6sKgj9vkPnlUMXh?=
 =?us-ascii?Q?1idto+Oz7Qc9SXFdhplVnI2JYE9oZ815YGFu6WEKk07BhIMn5ZZeueThd0Hb?=
 =?us-ascii?Q?rJj4F5WPVQ7rxqgyvhbsGHWsLw9NhxtUkLJksWYi20NuIIoutDh4aDvC4Lh6?=
 =?us-ascii?Q?xhtbaJIPLBJtuAzcyO5t6/zBZqMQGvUDXZdVcO9R1KeakQdI4JGDNrM+x0Jg?=
 =?us-ascii?Q?cshZF0WLPX6dDUvjTOXO58M59IY+2iW3vTM2UsBisfMeex4JQXXnvuucj5sa?=
 =?us-ascii?Q?peHniSk86jgiF8cTPj1eBxNdvP5jGQ6N+N43pg75jDZmX0y16PZ0/rVu0ORE?=
 =?us-ascii?Q?C7AWvWsAx/FYz+fx67cPNqNpKZgRJ76kY7QdootP0gc4PDCIdZRQyD9WfYMB?=
 =?us-ascii?Q?RE1EQeBNUFfhnKLFW0PcSqmBjyet/swQ3npfa/wYUrc5ol8okE5GtPg3w/lE?=
 =?us-ascii?Q?nnv+mrVf6Wwq4xyh1rB7xi/ly/8lP5H3Lu+bE80c1kypbnKdFlujMPXQeNCd?=
 =?us-ascii?Q?/T9vZQ=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f44f891-478c-4f66-9f0f-08d9ffdfea90
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2022 02:12:23.4334
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sNXfXOtbX61eh6YvI+VjBIoEoLZ4dMMlyzcLWMo/q8JZaDHY2xCAUERhMSXZgh4lYoloU+1Xx7yrZt6HPQFv64fa68J8nFFIhxVM2M55uFo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4553
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


Of note: The Felix driver had the ability to register the internal MDIO
bus. I am no longer using that in the switch driver, it is now an
additional sub-device under the MFD.

I also made use of IORESOURCE_REG, which removed the "device_is_mfd"
requirement.


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
		vscled@71 {
			label = "port7led1";
			gpios = <&sgpio_out1 7 1 GPIO_ACTIVE_LOW>;
			default-state = "off";
			linux,default-trigger = "ocelot-miim1-mii:07:1Gbps";
		};
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

		hsio: syscon {
			compatible = "mscc,ocelot-hsio", "syscon", "simple-mfd";

			serdes: serdes {
				compatible = "mscc,vsc7514-serdes";
				#phy-cells = <2>;
			};
		};
	};
};


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

Colin Foster (13):
  pinctrl: ocelot: allow pinctrl-ocelot to be loaded as a module
  pinctrl: microchip-sgpio: allow sgpio driver to be used as a module
  net: mdio: mscc-miim: add local dev variable to cleanup probe function
  net: ocelot: add interface to get regmaps when exernally controlled
  net: mdio: mscc-miim: add ability to be used in a non-mmio
    configuration
  pinctrl: ocelot: add ability to be used in a non-mmio configuration
  pinctrl: microchip-sgpio: add ability to be used in a non-mmio
    configuration
  phy: ocelot-serdes: add ability to be used in mfd configuration
  resource: add define macro for register address resources
  mfd: ocelot: add support for the vsc7512 chip via spi
  net: mscc: ocelot: expose ocelot wm functions
  net: dsa: felix: add configurable device quirks
  net: dsa: ocelot: add external ocelot switch control

 drivers/mfd/Kconfig                        |  24 +
 drivers/mfd/Makefile                       |   3 +
 drivers/mfd/ocelot-core.c                  | 192 +++++++
 drivers/mfd/ocelot-spi.c                   | 313 ++++++++++++
 drivers/mfd/ocelot.h                       |  42 ++
 drivers/net/dsa/ocelot/Kconfig             |  14 +
 drivers/net/dsa/ocelot/Makefile            |   5 +
 drivers/net/dsa/ocelot/felix.c             |   7 +-
 drivers/net/dsa/ocelot/felix.h             |   1 +
 drivers/net/dsa/ocelot/felix_vsc9959.c     |   1 +
 drivers/net/dsa/ocelot/ocelot_ext.c        | 567 +++++++++++++++++++++
 drivers/net/dsa/ocelot/seville_vsc9953.c   |   1 +
 drivers/net/ethernet/mscc/ocelot_devlink.c |  31 ++
 drivers/net/ethernet/mscc/ocelot_vsc7514.c |  28 -
 drivers/net/mdio/mdio-mscc-miim.c          |  49 +-
 drivers/phy/mscc/phy-ocelot-serdes.c       |  11 +
 drivers/pinctrl/Kconfig                    |   4 +-
 drivers/pinctrl/pinctrl-microchip-sgpio.c  |  26 +-
 drivers/pinctrl/pinctrl-ocelot.c           |  35 +-
 include/linux/ioport.h                     |   5 +
 include/soc/mscc/ocelot.h                  |  19 +
 21 files changed, 1318 insertions(+), 60 deletions(-)
 create mode 100644 drivers/mfd/ocelot-core.c
 create mode 100644 drivers/mfd/ocelot-spi.c
 create mode 100644 drivers/mfd/ocelot.h
 create mode 100644 drivers/net/dsa/ocelot/ocelot_ext.c

-- 
2.25.1

From 3b52c7edd85e8d9c0b6ab43f8682b73d002def6c Mon Sep 17 00:00:00 2001
From: Colin Foster <colin.foster@in-advantage.com>
Date: Sun, 6 Mar 2022 17:25:07 -0800

