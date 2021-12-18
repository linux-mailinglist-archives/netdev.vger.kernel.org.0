Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60832479DAF
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 22:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234530AbhLRVuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 16:50:12 -0500
Received: from mail-mw2nam10on2096.outbound.protection.outlook.com ([40.107.94.96]:43520
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232747AbhLRVuJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Dec 2021 16:50:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z9hWH9iQkJhee8NTQNPNAzsdU7HLsTLeAMdH8uhs2Tywt+WNgR78OilTR6VYNcXXQUJtE6yctGxrsiG4YhI5DKCbrKv3OZKRrx660DBAVygflSQl83Z+A1HDBaI+ihOJKnzLjKr2RrIDKMGfc2aYn2Z+KP7roTJNk7MiSbJoYbD/rmHGxpSddA7himcLNSUd75qJbt7fmdwmNUeHpUKaVbFlq1RE7utOnd3VUT6vpXISBpYpZJnBdeMt+fnUvVLJ1LrYI5oLCX6AUrkZCJkzZnWCGmaxC2J6kloxlIXva90wVVLX4r+APHb5vHT1c2MFwXozngxk8aBBJhW5NgAtnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4T2/Zwi7qvUvlg4E+wvgAWvB4arizCJxGL7NW2Z+8tg=;
 b=HhpybB4VCGDEtFLMELT42sVtWERA4ssjCPVknYaPy65/OL7AO+DmqKkDU95Ye6b5MuRCQJWlU0ORBiUDqLcvHCL4Z7EXrjWJ77/jarw33LC82MaV1T0TLs4wQdExgblHczcxhZ2fG48nHkyALeQEOUQAQUXVdQLKyiVtkDCbVG+syBpgw4uBOoT/pa0pCBy3t3U7Qn+3CUZh9P4ZQYDUWspYs2D5/1FzXz6QhorU4vDsMpopaWG3UrgPDmmq9P1WtGghvTunPME4r9fNeW/a3aNJZt2bWNQISvE1lhfIb4djceqsi1EIQdc6P69lvDva+EGGRWQgkybz57KFwGxg5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4T2/Zwi7qvUvlg4E+wvgAWvB4arizCJxGL7NW2Z+8tg=;
 b=MayQ+gtr0ZOeNCv07iCVZ1xymLFH5rPE0wxkaPfTTwHavdoIZuyGMHcBqbMeH9Ugxj6DzgNgRNUXPVEkjPNaVZKcvHTiHUuyCrUdLxwyVkkY8V7WRw0Nl8/FxrngRcyB+FcNoYMByfFOLmq7s5nACVF2WNyBf5PTK5oMwOUWfNw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO6PR10MB5633.namprd10.prod.outlook.com
 (2603:10b6:303:148::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17; Sat, 18 Dec
 2021 21:50:06 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4801.017; Sat, 18 Dec 2021
 21:50:05 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-gpio@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
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
        Lee Jones <lee.jones@linaro.org>
Subject: [RFC v5 net-next 00/13] add support for VSC75XX control over SPI
Date:   Sat, 18 Dec 2021 13:49:41 -0800
Message-Id: <20211218214954.109755-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR02CA0011.namprd02.prod.outlook.com
 (2603:10b6:300:4b::21) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5f27ccdf-bcab-4c18-234d-08d9c27059d8
X-MS-TrafficTypeDiagnostic: CO6PR10MB5633:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB56330C817465752B35F04B37A4799@CO6PR10MB5633.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oiPACE+NvrjHCjSS2MVCVhouhj8BcmB1BOLJTjXIJ9tyskEwzZKaT6pq45XbzNFS6YNrPo6Lr8EK4LvSSo8vXdIuYWKLCMww/JAl3wTJ/7mw26/6reCnv2pbYdApKF2Ha7mLM2nQYz8NkN/VVfTe3rUWzpFhO6+xOdnkzO86JLIU3sHvAVhef63Mt7TQz28xrbpLStxrVlkCkWseyIsr+JwDk1IkO1kV1evOeaB76JPbj9HncfLyGB1RJ+YrPISG9ZvpIPmkqkpovacVC0FdEPGLlqa+ZD1euM80taVnF+a6kE6ATwRspDaqUvJo4djaf4uod7ynvFbtkd2/cH/faXm+bSs74xw5X6f5c3rgaxikpPJ5LyoE8yhRseLQ/VV6H5RzW19LAmjJVCiBhqYCHlidNkMsctn0nS/AZKDfbbeCJKjk6SPfZyFr9jeAHqeZi2Kr6oS8tBTcLgWejVOfCGh8uwsQo3uqKaa1mjnIELPXnzkFXvL477Oy70MNhO5ZgT8BozthP512J/rkEkZpck2aDLrctu8k5Ra2UWl9UG0RWHwtnUCQ63v6wRyHwfWqSSObqBo6FgGBngdST4q4VinhRktcuJLjJ0BLsDUoFRu7DGvS76QfpBVLn/OKxmHCKx909hvjrQV7KIKF8k8VNxxSc7/36xUeXAAF76X4irSZnVXn9ZhniUa67legFfUX4wevQMAX4cetjxcFii/lTg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39830400003)(396003)(366004)(346002)(376002)(136003)(6486002)(6506007)(7416002)(2906002)(36756003)(6512007)(26005)(86362001)(66556008)(66476007)(186003)(1076003)(6666004)(4326008)(83380400001)(30864003)(66946007)(2616005)(44832011)(8936002)(8676002)(316002)(54906003)(38100700002)(5660300002)(508600001)(52116002)(38350700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ix9hOPns3ZVpFcRc+frPFyTl/HCpXfQdAFZN0ijZgG8PjZqMyNaykDY7E67n?=
 =?us-ascii?Q?OVLBfPPYd7D5mvJzjJsOOQp+hrQ4y2kQ/qy9af+ea3PgmfMb6MylmrbYgDiM?=
 =?us-ascii?Q?0+L/7SWE9dkbKQ0gTR0LCpT9wKYF6RGdHLTWOq+Xsqr2FUCMfhZMAcBLSgDc?=
 =?us-ascii?Q?t0jU1yMIZXXHHB63TWabZGoQvGofYMbGnk3kR/gmn/Avdupi67S09z6stFSj?=
 =?us-ascii?Q?Ct8qBS+HzAvu/ugMxLMqbM/typwMvqQfX0wQZwU53T9He+q9APBhPiEv1cSt?=
 =?us-ascii?Q?hH5V7DvsJn/IYJylZzQ68eCfjmdAJQObXEddtWBbyBg4SiD3FVPh4tgMeyLx?=
 =?us-ascii?Q?YIOEvDeAX9l3DckC7mgL/ZDT1UYptczmItsbNXOYousOiHxlOtYnDe0NMomz?=
 =?us-ascii?Q?eCEkRobDAH6XrCVmeXKn71/hsPuw5JtaSQD6Nz628qNXnnD6euUhdOLEc9tb?=
 =?us-ascii?Q?XCbZBukxN/+8ofaoQ+yfLWruX4PpF1svBeYEPOAWCxBRz6G0iUPQOisqt2zs?=
 =?us-ascii?Q?CaUeqEjbATMexB54/JqCl+U9xT78/5gIeUIbGc+kMOh3Su2AeLYwNgyKLxzW?=
 =?us-ascii?Q?ZsnwK64BzuTpTvxCKOF8nd2mESjnzzPSCDDZSmVr0F7tfZcl4mQVXJ5X0i3j?=
 =?us-ascii?Q?gUYTOesJ3brrZO88EgqhoXWUdOaQC2od86Kx7UVQGaVlhDeaCrUGEczKhW4s?=
 =?us-ascii?Q?JJpRHJ9st9+qpu+igjVr4n5s9kGmAKZFivn56lENefcji9Sy2TpyWtOxx28D?=
 =?us-ascii?Q?7nLse1qBVe5+AIdb5yA7FeBZDlm3vhQkRzu0qMMlvcCiGGoeT8zii0sFMRCd?=
 =?us-ascii?Q?y/bwq1cCZgDbZ4d8RR/w6dlFMxi+mO/JQoS2A045o6tdNN0VytodQJJjXaQT?=
 =?us-ascii?Q?LpgIOXp8oihP6gbZaKOlq1yqooGUH1UWC6fKp8kpEKfYpFVdoq1Ucg5Ivpyz?=
 =?us-ascii?Q?4vJ8+J8r+bWKSTVw5V/bH4eznFT/xy3nzyQiN9ROi+4lCPqV3QyB/ku4Ulhv?=
 =?us-ascii?Q?8dnmBv7UVyz8TZ193YjyydQ3xleTjIDhif23hcJF8dF32HtU8fLDH6a43X9l?=
 =?us-ascii?Q?5DI8aaspH5hhgZZU/psq0hWqkrv457/Oto98xjRG0cNuJPoHHuVnrfB+aJiY?=
 =?us-ascii?Q?a3ZYYRyIvlTNnWfSF/bSZy0zy2H7I9+yb/XOO0M+Swv169Yw1l+0cOUMhzxw?=
 =?us-ascii?Q?8lOmp4XKsFiMEFUo5wABsgWTq8r+tsGoUugl/5ykIcdwKI4RUxtQXNXD53zn?=
 =?us-ascii?Q?KwyDatWog6dUpzuvM3HF+zm5hh7JMyev+C7ATadNv2+shtbLTpA9X7va2nw5?=
 =?us-ascii?Q?VlocM5vytBnq7b1pw3c338mlbUJxXD6itzK96oZ9pr6pLeyuS3gZb5ewCN4C?=
 =?us-ascii?Q?u+PLIyfUZTvVX1isaFjBkpFSi5bEhEKO2MN9B9B7Ga5zXTZHMOY73CXh2KN8?=
 =?us-ascii?Q?XuY+WnJlyTLr1inVLR9qlAsbzjuJs0C+04B98+p5AqyV94+EarAs0nwestKO?=
 =?us-ascii?Q?ljangvrPmLBr5yFmo5dAOHB9Iv/TPHWJbPgBfH7x2vrPRjlvKsLQFLKKyUME?=
 =?us-ascii?Q?5qVaaLF0/PJb1saaGDjFUd6IgHXnvB02mZ69S03S8hhMIfk2B3wQJt+cNHpP?=
 =?us-ascii?Q?t0HdRUOF1Q94CjSem1ttBOqAHlPWgEV7SL2Ug2sskP9z369t+5fi1ufomPvq?=
 =?us-ascii?Q?aNik6w=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f27ccdf-bcab-4c18-234d-08d9c27059d8
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2021 21:50:05.4723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0gFXc+xLDBW/V5YilLtWrotGwHSonpD2oy8tqV7D/qaaYcIky+Nm4u2DhJEzbeGEk+99lolm82ezH2uWFD1K4O4LpoCICjKoc5Y27QnurE4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5633
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch set in general is to add support for the VSC7511, VSC7512,
VSC7513 and VSC7514 devices controlled over SPI. The driver is
believed to be fully functional for the internal phy ports (0-3) 
on the VSC7512. As I'll discuss, it is not yet functional for other
ports yet.


V5 is an overhaul of the framework. Instead of struct spi_device being
called directly into drivers/net/dsa/ocelot/ocelot_spi.c, it is now done
through drivers/net/mfd/ocelot-spi.c. The MFD layer is handled in
drivers/net/mfd/ocelot-core.c. At the end of this patch set, three
optional devices are supported: ocelot-pinctrl to control pins, 
mdio-mscc-miim to communicate on the external MDIO bus, and
ocelot-ext to manage the switch.

This structure seems to really clean things up. "ocelot_ext" comes in
around 650 lines now, down from 950 in v4. Much of that has moved to
ocelot-spi.c. All references to SPI have been removed from ocelot_ext. I
know lines of a file isn't a great metric of software design quality,
but I think they are related in this case.

My hope at the end of this RFC is to be able to split this into several
smaller patch sets. One set would add MFD + pinctrl, and possibly MDIO.
To the best of my current knowledge those drivers are functionally
complete and possibly ready for full "PATCH" status instead of RFC. 

Of note: the MFD uses hard-coded resources, while the MMIO version uses
DTS resources. If nothing else, I'll update the relevant documentation
accordingly.

A separate patch set would be to add switch capabilities. Since the
external phys are now functional, I can turn my focus to those
additional ports. 

That leads to a direct question: Is it acceptable to do switch
capabilities in two patch sets? Set 1 would add internal phy
functionality that currently works, set 2 would add PCS / SGMII support
to ports 4-7? For full transparency: I don't have Fib{re,er} 
hardware so I don't plan to develop that support. I simply won't be able
to test it.

As I mentioned in the last RFC:
The hardware setup I'm using for development is a beaglebone black, with
jumpers from SPI0 to the microchip VSC7512 dev board. The microchip dev 
board has been modified to not boot from flash, but wait for SPI. An
ethernet cable is connected from the beaglebone ethernet to port 0 of
the dev board.


The device tree I'm using for the VSC7512 is below, and has changed in
architecture significantly since V4:

&spi0 {
	#address-cells = <1>;
	#size-cells = <0>;
	status = "okay";

	ocelot-chip@0 {
		compatible = "mscc,vsc7512_mfd_spi";
		spi-max-frequency = <250000>;
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

				port@2 {
					reg = <2>;
					label = "swp2";
					status = "okay";
					phy-handle = <&sw_phy2>;
					phy-mode = "internal";
				};

				port@3 {
					reg = <3>;
					label = "swp3";
					status = "okay";
					phy-handle = <&sw_phy3>;
					phy-mode = "internal";
				};

				port@4 {
					reg = <4>;
					label = "swp4";
					status = "okay";
					phy-handle = <&sw_phy4>;
					phy-mode = "sgmii";
				};

				port@5 {
					reg = <5>;
					label = "swp5";
					status = "okay";
					phy-handle = <&sw_phy5>;
					phy-mode = "sgmii";
				};

				port@6 {
					reg = <6>;
					label = "swp6";
					status = "okay";
					phy-handle = <&sw_phy6>;
					phy-mode = "sgmii";
				};

				port@7 {
					reg = <7>;
					label = "swp7";
					status = "okay";
					phy-handle = <&sw_phy7>;
					phy-mode = "sgmii";
				};
			};


			mdio {
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
		};

		mdio1: mdio1 {
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

        /* Non-functional at the moment */
		sgpio: sgpio {
			compatible = "mscc,ocelot-sgpio";
			bus-frequency=<12500000>;
			clocks = <&ocelot_clock>;
			microchip,sgpio-port-ranges = <0 31>;

			sgpio_in0: sgpio@0 {
				compatible = "microchip,sparx5-sgpio-bank";
				reg = <0>;
				gpio-controller;
				#gpio-cells = <3>;
				ngpios = <32>;
			};

			sgpio_out1: sgpio@1 {
				compatible = "microchip,sparx5-sgpio-bank";
				reg = <1>;
				gpio-controller;
				gpio-cells = <3>;
				ngpios = <32>;
			};
		};
	};
};



The relevant boot log for the switch / MDIO bus is here. Of note: ports
4-7 are now properly probed before the switch comes up.

[    1.357533] SPI driver ocelot_mfd_spi has no spi_device_id for mscc,vsc7514_mfd_spi
[    1.357561] SPI driver ocelot_mfd_spi has no spi_device_id for mscc,vsc7513_mfd_spi
[    1.357571] SPI driver ocelot_mfd_spi has no spi_device_id for mscc,vsc7512_mfd_spi
[    1.357581] SPI driver ocelot_mfd_spi has no spi_device_id for mscc,vsc7511_mfd_spi
[    3.159000] ocelot_mfd_spi spi0.0: configured SPI bus for speed 250000, rx padding bytes 0
[    3.167549] ocelot_mfd_spi spi0.0: initializing SPI interface for chip
[    3.175088] ocelot_mfd_spi spi0.0: resetting ocelot chip
[    3.301006] ocelot_mfd_spi spi0.0: initializing SPI interface for chip
[    3.309537] pinctrl-ocelot pinctrl-ocelot: DMA mask not set
[    3.315694] gpiochip_find_base: found new base at 2026
[    3.315737] gpio gpiochip4: (ocelot-gpio): created GPIO range 0->21 ==> pinctrl-ocelot PIN 0->21
[    3.321957] gpio gpiochip4: (ocelot-gpio): added GPIO chardev (254:4)
[    3.322059] gpio gpiochip4: registered GPIOs 2026 to 2047 on ocelot-gpio
[    3.322076] pinctrl-ocelot pinctrl-ocelot: driver registered
[    3.331370] mscc-miim ocelot-miim1: DMA mask not set
[    3.337044] mdio_bus ocelot-miim1-mii: GPIO lookup for consumer reset
[    3.337065] mdio_bus ocelot-miim1-mii: using device tree for GPIO lookup
[    3.337088] of_get_named_gpiod_flags: can't parse 'reset-gpios' property of node '/ocp/interconnect@48000000/segment@0/target-module@30000/spi@0/ocelot-chip@0/mdio1[0]'
[    3.337141] of_get_named_gpiod_flags: can't parse 'reset-gpio' property of node '/ocp/interconnect@48000000/segment@0/target-module@30000/spi@0/ocelot-chip@0/mdio1[0]'
[    3.337190] mdio_bus ocelot-miim1-mii: using lookup tables for GPIO lookup
[    3.337202] mdio_bus ocelot-miim1-mii: No GPIO consumer reset found
[    3.337215] libphy: mscc_miim: probed
[    3.343764] mdio_bus ocelot-miim1-mii:04: GPIO lookup for consumer reset
[    3.343788] mdio_bus ocelot-miim1-mii:04: using device tree for GPIO lookup
[    3.343809] of_get_named_gpiod_flags: can't parse 'reset-gpios' property of node '/ocp/interconnect@48000000/segment@0/target-module@30000/spi@0/ocelot-chip@0/mdio1/ethernet-phy@4[0]'
[    3.343873] of_get_named_gpiod_flags: can't parse 'reset-gpio' property of node '/ocp/interconnect@48000000/segment@0/target-module@30000/spi@0/ocelot-chip@0/mdio1/ethernet-phy@4[0]'
[    3.343928] mdio_bus ocelot-miim1-mii:04: using lookup tables for GPIO lookup
[    3.343939] mdio_bus ocelot-miim1-mii:04: No GPIO consumer reset found
# Repeated for 5, 6 and 7
[    3.355921] ocelot-ext-switch ocelot-ext-switch: DMA mask not set
[    3.864119] mdio_bus ocelot-ext-switch-mii: GPIO lookup for consumer reset
[    3.864151] mdio_bus ocelot-ext-switch-mii: using device tree for GPIO lookup
[    3.864176] of_get_named_gpiod_flags: can't parse 'reset-gpios' property of node '/ocp/interconnect@48000000/segment@0/target-module@30000/spi@0/ocelot-chip@0/ethernet-switch@0/mdio[0]'
[    3.864236] of_get_named_gpiod_flags: can't parse 'reset-gpio' property of node '/ocp/interconnect@48000000/segment@0/target-module@30000/spi@0/ocelot-chip@0/ethernet-switch@0/mdio[0]'
[    3.864291] mdio_bus ocelot-ext-switch-mii: using lookup tables for GPIO lookup
[    3.864303] mdio_bus ocelot-ext-switch-mii: No GPIO consumer reset found
[    4.363826] libphy: ocelot_ext MDIO bus: probed
[    4.371316] mdio_bus ocelot-ext-switch-mii:00: GPIO lookup for consumer reset
[    4.371340] mdio_bus ocelot-ext-switch-mii:00: using device tree for GPIO lookup
[    4.371360] of_get_named_gpiod_flags: can't parse 'reset-gpios' property of node '/ocp/interconnect@48000000/segment@0/target-module@30000/spi@0/ocelot-chip@0/ethernet-switch@0/mdio/ethernet-phy@0[0]'
[    4.371433] of_get_named_gpiod_flags: can't parse 'reset-gpio' property of node '/ocp/interconnect@48000000/segment@0/target-module@30000/spi@0/ocelot-chip@0/ethernet-switch@0/mdio/ethernet-phy@0[0]'
[    4.371495] mdio_bus ocelot-ext-switch-mii:00: using lookup tables for GPIO lookup
[    4.371507] mdio_bus ocelot-ext-switch-mii:00: No GPIO consumer reset found
[    4.374476] mdio_bus ocelot-ext-switch-mii:01: GPIO lookup for consumer reset
[    4.374504] mdio_bus ocelot-ext-switch-mii:01: using device tree for GPIO lookup
[    4.374524] of_get_named_gpiod_flags: can't parse 'reset-gpios' property of node '/ocp/interconnect@48000000/segment@0/target-module@30000/spi@0/ocelot-chip@0/ethernet-switch@0/mdio/ethernet-phy@1[0]'
[    4.374597] of_get_named_gpiod_flags: can't parse 'reset-gpio' property of node '/ocp/interconnect@48000000/segment@0/target-module@30000/spi@0/ocelot-chip@0/ethernet-switch@0/mdio/ethernet-phy@1[0]'
[    4.374657] mdio_bus ocelot-ext-switch-mii:01: using lookup tables for GPIO lookup
[    4.374669] mdio_bus ocelot-ext-switch-mii:01: No GPIO consumer reset found
# Repeated for 2 and 3
[    8.105647] ocelot-ext-switch ocelot-ext-switch: PHY [ocelot-ext-switch-mii:00] driver [Generic PHY] (irq=POLL)
[    8.119027] ocelot-ext-switch ocelot-ext-switch: configuring for phy/internal link mode
[    8.145065] ocelot-ext-switch ocelot-ext-switch swp1 (uninitialized): PHY [ocelot-ext-switch-mii:01] driver [Generic PHY] (irq=POLL)
[    8.163599] ocelot-ext-switch ocelot-ext-switch swp2 (uninitialized): PHY [ocelot-ext-switch-mii:02] driver [Generic PHY] (irq=POLL)
[    8.182016] ocelot-ext-switch ocelot-ext-switch swp3 (uninitialized): PHY [ocelot-ext-switch-mii:03] driver [Generic PHY] (irq=POLL)
[    8.200313] ocelot-ext-switch ocelot-ext-switch swp4 (uninitialized): PHY [ocelot-miim1-mii:04] driver [Generic PHY] (irq=POLL)
[    8.218238] ocelot-ext-switch ocelot-ext-switch swp5 (uninitialized): PHY [ocelot-miim1-mii:05] driver [Generic PHY] (irq=POLL)
[    8.236204] ocelot-ext-switch ocelot-ext-switch swp6 (uninitialized): PHY [ocelot-miim1-mii:06] driver [Generic PHY] (irq=POLL)
[    8.254153] ocelot-ext-switch ocelot-ext-switch swp7 (uninitialized): PHY [ocelot-miim1-mii:07] driver [Generic PHY] (irq=POLL)
[    8.277362] device eth0 entered promiscuous mode
[    8.282119] DSA: tree 0 setup
[    8.285250] ocelot_mfd_spi spi0.0: ocelot mfd core setup complete
[    8.297532] ocelot_mfd_spi spi0.0: ocelot spi mfd probed
[   10.259154] ocelot-ext-switch ocelot-ext-switch: Link is Up - 100Mbps/Full - flow control off

Then I enable ports 1-3 on a bridge with STP with an intentional loop of
port 2 plugged directly into port 3:

[   21.040578] cpsw-switch 4a100000.switch: starting ndev. mode: dual_mac
[   21.133226] SMSC LAN8710/LAN8720 4a101000.mdio:00: attached PHY driver (mii_bus:phy_addr=4a101000.mdio:00, irq=POLL)
[   21.150341] 8021q: adding VLAN 0 to HW filter on device eth0
[   21.175435] ocelot-ext-switch ocelot-ext-switch swp1: configuring for phy/internal link mode
[   21.210804] ocelot-ext-switch ocelot-ext-switch swp2: configuring for phy/internal link mode
[   21.245110] ocelot-ext-switch ocelot-ext-switch swp3: configuring for phy/internal link mode
[   21.310462] br0: port 1(swp1) entered blocking state
[   21.315670] br0: port 1(swp1) entered disabled state
[   21.334172] device swp1 entered promiscuous mode
[   21.365554] br0: port 2(swp2) entered blocking state
[   21.370594] br0: port 2(swp2) entered disabled state
[   21.388041] device swp2 entered promiscuous mode
[   21.410549] br0: port 3(swp3) entered blocking state
[   21.415726] br0: port 3(swp3) entered disabled state
[   21.432923] device swp3 entered promiscuous mode
[   21.713724] ocelot-ext-switch ocelot-ext-switch: Link is Down
[   22.741120] ocelot-ext-switch ocelot-ext-switch: Link is Up - 100Mbps/Full - flow control off
[   23.382081] cpsw-switch 4a100000.switch eth0: Link is Up - 100Mbps/Full - flow control off
[   23.392704] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   24.339517] ocelot-ext-switch ocelot-ext-switch swp2: Link is Up - 1Gbps/Full - flow control rx/tx
[   24.348688] IPv6: ADDRCONF(NETDEV_CHANGE): swp2: link becomes ready
[   24.355215] br0: port 2(swp2) entered blocking state
[   24.360220] br0: port 2(swp2) entered listening state
[   24.427317] ocelot-ext-switch ocelot-ext-switch swp3: Link is Up - 1Gbps/Full - flow control rx/tx
[   24.436649] IPv6: ADDRCONF(NETDEV_CHANGE): swp3: link becomes ready
[   24.443458] br0: port 3(swp3) entered blocking state
[   24.448507] br0: port 3(swp3) entered listening state
[   25.463130] ocelot-ext-switch ocelot-ext-switch swp1: Link is Up - 1Gbps/Full - flow control rx/tx
[   25.472385] IPv6: ADDRCONF(NETDEV_CHANGE): swp1: link becomes ready
[   25.479062] br0: port 1(swp1) entered blocking state
[   25.484241] br0: port 1(swp1) entered listening state
[   26.091585] br0: port 3(swp3) entered blocking state
[   39.531066] br0: port 2(swp2) entered learning state
[   40.811057] br0: port 1(swp1) entered learning state
[   54.891054] br0: port 2(swp2) entered forwarding state
[   54.896328] br0: topology change detected, propagating
[   54.906787] IPv6: ADDRCONF(NETDEV_CHANGE): br0: link becomes ready
[   55.531415] br0: received packet on swp2 with own address as source address (addr:*, vlan:0)
[   56.171057] br0: port 1(swp1) entered forwarding state
[   56.176312] br0: topology change detected, propagating
[   90.091617] br0: received packet on swp2 with own address as source address (addr:*, vlan:0)

(I'm curious about those swp2 packets that trickle through...)

In order to make this work, I have modified the cpsw driver, and now the
cpsw_new driver, to allow for frames over 1500 bytes. Otherwise the
tagging protocol will not work between the beaglebone and the VSC7512. I
plan to eventually try to get those changes in mainline, but I don't
want to get distracted from my initial goal. I also had to change
bonecommon.dtsi to avoid using VLAN 0.


Lastly, this patch set relies on changes that have been merged in from
linux-pinctrl/next. kernel-test-robot will complain that the last two
patches won't compile and might not even apply. The path forward might
be to get the MFD / pinctrl into linux-pinctrl before the next merge
window. I doubt the ocelot-ext will be fully functional by then, though
it does feel close!


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


Colin Foster (13):
  mfd: ocelot: add support for external mfd control over SPI for the
    VSC7512
  mfd: ocelot: offer an interface for MFD children to get regmaps
  net: mscc: ocelot: expose ocelot wm functions
  net: dsa: felix: add configurable device quirks
  net: mdio: mscc-miim: add ability to externally register phy reset
    control
  net: dsa: ocelot: add external ocelot switch control
  mfd: ocelot: enable the external switch interface
  mfd: add interface to check whether a device is mfd
  net: mdio: mscc-miim: add local dev variable to cleanup probe function
  net: mdio: mscc-miim: add MFD functionality through ocelot-core
  mfd: ocelot-core: add control for the external mdio interface
  pinctrl: ocelot: add MFD functionality through ocelot-core
  mfd: ocelot: add ocelot-pinctrl as a supported child interface

 drivers/mfd/Kconfig                        |  15 +
 drivers/mfd/Makefile                       |   3 +
 drivers/mfd/mfd-core.c                     |   5 +
 drivers/mfd/ocelot-core.c                  | 203 +++++++
 drivers/mfd/ocelot-mfd.h                   |  19 +
 drivers/mfd/ocelot-spi.c                   | 374 ++++++++++++
 drivers/net/dsa/ocelot/Kconfig             |  15 +
 drivers/net/dsa/ocelot/Makefile            |   5 +
 drivers/net/dsa/ocelot/felix.c             |   7 +-
 drivers/net/dsa/ocelot/felix.h             |   1 +
 drivers/net/dsa/ocelot/felix_vsc9959.c     |   1 +
 drivers/net/dsa/ocelot/ocelot_ext.c        | 644 +++++++++++++++++++++
 drivers/net/dsa/ocelot/seville_vsc9953.c   |   4 +-
 drivers/net/ethernet/mscc/ocelot_devlink.c |  31 +
 drivers/net/ethernet/mscc/ocelot_vsc7514.c |  28 -
 drivers/net/mdio/mdio-mscc-miim.c          |  50 +-
 drivers/pinctrl/pinctrl-ocelot.c           |  30 +-
 include/linux/mdio/mdio-mscc-miim.h        |   3 +-
 include/linux/mfd/core.h                   |  10 +
 include/soc/mscc/ocelot.h                  |  19 +
 20 files changed, 1410 insertions(+), 57 deletions(-)
 create mode 100644 drivers/mfd/ocelot-core.c
 create mode 100644 drivers/mfd/ocelot-mfd.h
 create mode 100644 drivers/mfd/ocelot-spi.c
 create mode 100644 drivers/net/dsa/ocelot/ocelot_ext.c

-- 
2.25.1

