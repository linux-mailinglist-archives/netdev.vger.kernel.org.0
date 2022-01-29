Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D05C4A322F
	for <lists+netdev@lfdr.de>; Sat, 29 Jan 2022 23:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353322AbiA2WCw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 17:02:52 -0500
Received: from mail-dm3nam07on2115.outbound.protection.outlook.com ([40.107.95.115]:64192
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1353286AbiA2WCo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Jan 2022 17:02:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BnIhcO+brH9K/BTcARxYSKYRMJlYu3Eonrp5v1fEk19D6kTqqAHtm3XJtPCnNFC4PIddr8A2OWBnS1BqzPjMmx34HnZZEcwQOMHuP7TSV5GBoZ8eMX9HrPusX1goisXtFsknCt7zVBaSZlH26Ftqst8udvggcvsKffnPMPSQWcvs3vMOlgy2QVv+S1QlN651zQCEN3RaN0tvvuZvdPmmUpwkyF21oDG7GLkyES4aKhJrcIQy3yFeOYMCFmvQEIj+nkAG7z72dAvlde14FVVkb1nPEPaZMzWbortGbBF6yP32PpxEuLXg0DlvxdQNkNNaXgqI3mX0P2Yaz/rjnjI99w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1yWbV2njwGTDSvI19sKtHccEyaaBAvIIgDAtm6cRBGc=;
 b=BVgAN8/uDzFuSrq7h7kbb+FHprqd/3MzfVX2Iwu7fGUQiSYFRX5rGCvPAVuVdqY0rGLqN+RNi7dKbtTv+4akqcdUhZxeT1xmcJ4YTFSjx8HHQUP+A8bwwiE4fyHl/UhTgX8fHS1Gjb/VCtaqj6lTcqB+jHGrg6+glfPlP1lrvJvxxbn32P3o8fwWGy+VBjTnQqFH3r/FLcAzcxXbjCTG3F/57sMovjW0/ir8430WxTx7YCgPCEV/vY6QfagRoJy9V7wi0BN7AlqOVgxzxmD54fmB3OxlukydmgRgttHk9MSJfOAlyBZ4lCMABfpi0n8mRr7eBZ0abaaZdFNxQyvgEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1yWbV2njwGTDSvI19sKtHccEyaaBAvIIgDAtm6cRBGc=;
 b=t19QRLgy5kr/bZATQVW5aYRqFEpMLzadSLHYiKtSh9NPWyWQ5hHDmMLY8E+DawZRrVC7l/OGRaDnDCPyp336WvM8bY4Y87M5oo83D50wDwhaciJEPsoUcO26nTTdVsP+e8+x85D/g6IGdkDge0h98MjTe/d5xAgEiJg5lge6+J0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BYAPR10MB2968.namprd10.prod.outlook.com
 (2603:10b6:a03:85::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.18; Sat, 29 Jan
 2022 22:02:39 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4930.020; Sat, 29 Jan 2022
 22:02:39 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
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
Subject: [RFC v6 net-next 0/9] add support for VSC7512 control over SPI
Date:   Sat, 29 Jan 2022 14:02:12 -0800
Message-Id: <20220129220221.2823127-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CO1PR15CA0113.namprd15.prod.outlook.com
 (2603:10b6:101:21::33) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d329139e-1649-4af2-16e6-08d9e37310a6
X-MS-TrafficTypeDiagnostic: BYAPR10MB2968:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB29689B9F87CC0718E7EB47FAA4239@BYAPR10MB2968.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vfas3UXM9bTdLj0giWl5+6lfv45nq+V2Z9tfGNvnaK8XG+Pcq7RQzi7Z9n7qFr/StfGtfIGKlZzltSI2urmDJadrBvza1Z6UuGC3AkNc89//QEmToBDhkR+rZS1Hdl0HKJNnAdQLbivI359KRMgbAL52AnSosdhexd5iRXeOVy64IRupscXan5XQr14np9QVeP+8q+zEk/c+F0FbNIyx1ChCLX1Rs6xzfZhNfjIvLrbGE1qLE1tkdjr7xiHKvuRKtU3MUSVfBQrw0WfL5K9s+u/FJ+bmfzHB4B/BZR6WSDBT9KmAqPgz1D4pYjLPwz+SlI0izeQKAY687cBzBZ1rVEocvQopgZRQz2idM6/BvCYprm3MePo10IxuMYovb4efUmePkUgr2G3Y1zB/DtFnIXgpTAu0qKyT/TRmyfJgOVarqvIGPIl4JjrlnZievhvM6j7F7WXJJ/ro/CLkHUlBTRXLq9ipDNpnoDY4e1+CkeWzfLuh8WfcWvRtTRAG9NbxVQjzB9v780AMoFp1A3/G1UWNtHOdovbrMOwgJ6eGctHUZXLL7zshtwbIRXyaaxjlOiLl0rIF8wQgnDBZ3yXSlu0POuZVKWp/uQNpKkCu2uIThb4raJ6sqEcyGJfIJsThdcun1hKeucvEEMo316MpbqZucQpBAhJlZzGQMO7cpnsMTlhH2wVGpLeAJreBp3B0mcjUDceThU1Nt+wn6sBE7g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(136003)(376002)(346002)(42606007)(396003)(39830400003)(366004)(186003)(508600001)(5660300002)(6486002)(1076003)(86362001)(66946007)(8676002)(66476007)(26005)(4326008)(66556008)(8936002)(7416002)(107886003)(6506007)(38350700002)(6512007)(2906002)(30864003)(44832011)(6666004)(2616005)(52116002)(38100700002)(83380400001)(316002)(36756003)(54906003)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?F8qNht8a/bd0CvK1eKIMA/cTRzNpNqLjIrttdS+uVpyjqeqZhDuRtSY4QqdY?=
 =?us-ascii?Q?aE9J5YGRRKwJ8d6TWrBS/QIkGGqlp4aj6HJQ2SW1QSB2Isgpse/D3aujeYGX?=
 =?us-ascii?Q?DBvHwHGwVoND1YB6JGqyRLACN5pzEFvkINOS6vgEhRPEVDBFjVpOLJAD8OtJ?=
 =?us-ascii?Q?qOqX4HVd3Nap+LnG1eWXxS2xXyZjW5gunOKWQP1/RibqCMYMN7DhEhGIQRoq?=
 =?us-ascii?Q?BoxawRm10KpCkvlWnDRtUUe4He8sEMx9hWArbFE0AK2Eqm3Adsi4mcxxsJnr?=
 =?us-ascii?Q?F20BIxvaIerL1dZWzbMp1hfJVaXHl1TMM30CBfiUppHMl7/lNjFkGg+rhHMW?=
 =?us-ascii?Q?UFpERdmPAFv4+CUNlgsOWr59XbNRCFXqUAlMS5yl3e0PJdx7fmGrUMr0BYi/?=
 =?us-ascii?Q?GS09ktvio8+8ayy4DtBNWUjJStL3UDjMUOJpNHSjOzwEF9r4Flr7TZ70gnoZ?=
 =?us-ascii?Q?yEEL8J8824k51nNDY7q8PSDh2gSHzd5riyxdtTbL38MvI0+nkvB6QzFj4Tme?=
 =?us-ascii?Q?+dZPEmfWPE7xfVbzA38sagRidVp2C4Nmj5mmxorl7gRQHSb5aLXg6IycMZ8k?=
 =?us-ascii?Q?vvdaxXUBPJkNNic0dVQ2zCCfoiw89JQqt8xMFTMdS7/fbkyjjbfOvaNCBjN4?=
 =?us-ascii?Q?h2YWmOsnLsuWo7BS7oEfnNJfLyDH84H2OqPKB0T8037eTDs8Q1HUja8O2PlI?=
 =?us-ascii?Q?gzHMkhwMIZwW1P2xbJALW+aoTstlsZQ6lLt01lju5KC47aJLL1SBBeoV9vZk?=
 =?us-ascii?Q?HYjG2UDY2CPh78Ct+NdzxxfAz3cFaOQ1yplikmd7M8YGPjvXsOmXkX160A/9?=
 =?us-ascii?Q?aEAs5/u6UAF08d6CQDRjdr9Yu0YHaPngFBOBSUbsxdu1dsP9iylfNq3gRXLy?=
 =?us-ascii?Q?cgDZB1OGc5jssHnadNLhHA2a2iTGGQBzWc3q3BB5rC8Bf3BNZ3uaC8J03Ac+?=
 =?us-ascii?Q?2x7sAJ25ox8SxX2gPt1blxWTbBhrfUNinJql0AUTEWy4MMgnjYP1XzRYywj1?=
 =?us-ascii?Q?UCJiVu3sQebpJFxKl5jvKClpttb+vQXotj1wbqrl8xvvXRLkk3vm8d1+RmPw?=
 =?us-ascii?Q?HXipVQtdA9i8IjR071wgbkdXc2Cois883LPGZi1XVI3I5qGBxTU4IVhzM0Vk?=
 =?us-ascii?Q?kJB/TIr2oFCemJodaUkuLe85H38Hp8hkpemSOVU6mgSAvJ7pvbbu5/FjIjZn?=
 =?us-ascii?Q?rSwt1TJpprmOZ/1nk8Hoo0+NXu0emRtPLmKD3T2/ZSICNgpZv8K09khFbkIj?=
 =?us-ascii?Q?1qDouTqg3TVl+QqJtaQusbA4k7upyfXiHd7j7jwTUyCoGU8+Ydr229T8B/qh?=
 =?us-ascii?Q?f6U0OlowlX2ffhu1BjJx0cs3B1tYTKQl9qCDCmFkGZ2ShBiLD2XGsT+WOgm3?=
 =?us-ascii?Q?MZsXcQhd3kWSj86aT6GWf6LENkrx9ahESpUesA15kODfUNtKoEqmkD5Ytw7Z?=
 =?us-ascii?Q?sh1GHW79o/H9PGcL9ioyTVUz09ummwvk/QZ3Vajq/vjqufh7XbFG42ieM/Im?=
 =?us-ascii?Q?5fu0g9ETyC1Wd8BFINDDpzvn7NEqnTYFx//fJuOtF5en486Ha87A6p3G2hKP?=
 =?us-ascii?Q?W33ZYjvzOA1Z4OBJ+S0xnKe/yx4CZ+wxxbjgR1Ed/qplfZlaxFaCvmI1I3vv?=
 =?us-ascii?Q?tS1ro9TEtHIzd2lq0Lk4dmGDJUH0arphtuZcSasMM8QvFeysgpYmdmp45nqL?=
 =?us-ascii?Q?PJe6aw=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d329139e-1649-4af2-16e6-08d9e37310a6
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2022 22:02:39.3137
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JXNZvnT3wI2tWsA90vWRGtpWzAVFr7hyzzaBmUQr+UkSTqgN7fUR+YpoxXXSuOSd8FPSld7xr6SwY1FYm1RaUmiDI7aMPQ7uoekLr6c6tF4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2968
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


Lastly, there are things that I have not changed. v6 still uses
device_is_mfd to reason about whether it should use
devm_ioremap_resource or ocelot_get_regmap_from_resource. If necessary,
a different compatible string could be used. That would create some code
duplication, but if device_is_mfd is not desired I completely
understand.

I also still use ocelot_get_regmap_from_resource, and it has been
squashed into the main MFD addition commit. My initial thoughts of it
being able to be done through dev / MFD were probably over-complicating
things.


/ {
	model = "TI AM335x BeagleBone Black";
	compatible = "ti,am335x-bone-black", "ti,am335x-bone", "ti,am33xx";

	// 125 MHz clock on dev board
	ocelot_clock: ocelot-clock {
		compatible = "fixed-clock";
		#clock-cells = <0>;
		clock-frequency = <125000000>;
	};

	vscleds {
		compatible = "gpio-leds";
		vscled@0 {
			label = "port0led";
			gpios = <&sgpio_out1 0 0 GPIO_ACTIVE_LOW>;
			default-state = "off";
			linux,default-trigger = "ocelot-ext-switch-mii:00:link";
		};
		vscled@1 {
			label = "port0led1";
			gpios = <&sgpio_out1 0 1 GPIO_ACTIVE_LOW>;
			default-state = "off";
			linux,default-trigger = "ocelot-ext-switch-mii:00:1Gbps";
		};
		vscled@10 {
			label = "port1led";
			gpios = <&sgpio_out1 1 0 GPIO_ACTIVE_LOW>;
			default-state = "off";
			linux,default-trigger = "ocelot-ext-switch-mii:01:link";
		};
		vscled@11 {
			label = "port1led1";
			gpios = <&sgpio_out1 1 1 GPIO_ACTIVE_LOW>;
			default-state = "off";
			linux,default-trigger = "ocelot-ext-switch-mii:01:1Gbps";
		};
		vscled@20 {
			label = "port2led";
			gpios = <&sgpio_out1 2 0 GPIO_ACTIVE_LOW>;
			default-state = "off";
			linux,default-trigger = "ocelot-ext-switch-mii:02:link";
		};
		vscled@21 {
			label = "port2led1";
			gpios = <&sgpio_out1 2 1 GPIO_ACTIVE_LOW>;
			default-state = "off";
			linux,default-trigger = "ocelot-ext-switch-mii:02:1Gbps";
		};
		vscled@30 {
			label = "port3led";
			gpios = <&sgpio_out1 3 0 GPIO_ACTIVE_LOW>;
			default-state = "off";
			linux,default-trigger = "ocelot-ext-switch-mii:03:link";
		};
		vscled@31 {
			label = "port3led1";
			gpios = <&sgpio_out1 3 1 GPIO_ACTIVE_LOW>;
			default-state = "off";
			linux,default-trigger = "ocelot-ext-switch-mii:03:1Gbps";
		};
		vscled@40 {
			label = "port4led";
			gpios = <&sgpio_out1 4 0 GPIO_ACTIVE_LOW>;
			default-state = "off";
			linux,default-trigger = "ocelot-miim1-mii:04:link";
		};
		vscled@41 {
			label = "port4led1";
			gpios = <&sgpio_out1 4 1 GPIO_ACTIVE_LOW>;
			default-state = "off";
			linux,default-trigger = "ocelot-miim1-mii:04:1Gbps";
		};
		vscled@50 {
			label = "port5led";
			gpios = <&sgpio_out1 5 0 GPIO_ACTIVE_LOW>;
			default-state = "off";
			linux,default-trigger = "ocelot-miim1-mii:05:link";
		};
		vscled@51 {
			label = "port5led1";
			gpios = <&sgpio_out1 5 1 GPIO_ACTIVE_LOW>;
			default-state = "off";
			linux,default-trigger = "ocelot-miim1-mii:05:1Gbps";
		};
		vscled@60 {
			label = "port6led";
			gpios = <&sgpio_out1 6 0 GPIO_ACTIVE_LOW>;
			default-state = "off";
			linux,default-trigger = "ocelot-miim1-mii:06:link";
		};
		vscled@61 {
			label = "port6led1";
			gpios = <&sgpio_out1 6 1 GPIO_ACTIVE_LOW>;
			default-state = "off";
			linux,default-trigger = "ocelot-miim1-mii:06:1Gbps";
		};
		vscled@70 {
			label = "port7led";
			gpios = <&sgpio_out1 7 0 GPIO_ACTIVE_LOW>;
			default-state = "off";
			linux,default-trigger = "ocelot-miim1-mii:07:link";
		};
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
					phy-mode = "qsgmii";
					phys = <&serdes 4 SERDES6G(0)>;
				};

				port@5 {
					reg = <5>;
					label = "swp5";
					status = "okay";
					phy-handle = <&sw_phy5>;
					phy-mode = "qsgmii";
					phys = <&serdes 5 SERDES6G(0)>;
				};

				port@6 {
					reg = <6>;
					label = "swp6";
					status = "okay";
					phy-handle = <&sw_phy6>;
					phy-mode = "qsgmii";
					phys = <&serdes 6 SERDES6G(0)>;
				};

				port@7 {
					reg = <7>;
					label = "swp7";
					status = "okay";
					phy-handle = <&sw_phy7>;
					phy-mode = "qsgmii";
					phys = <&serdes 7 SERDES6G(0)>;
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


Colin Foster (9):
  pinctrl: ocelot: allow pinctrl-ocelot to be loaded as a module
  pinctrl: microchip-sgpio: allow sgpio driver to be used as a module
  net: mdio: mscc-miim: add local dev variable to cleanup probe function
  net: mdio: mscc-miim: add ability to externally register phy reset
    control
  mfd: add interface to check whether a device is mfd
  mfd: ocelot: add support for external mfd control over SPI for the
    VSC7512
  net: mscc: ocelot: expose ocelot wm functions
  net: dsa: felix: add configurable device quirks
  net: dsa: ocelot: add external ocelot switch control

 drivers/mfd/Kconfig                        |  19 +
 drivers/mfd/Makefile                       |   3 +
 drivers/mfd/mfd-core.c                     |   6 +
 drivers/mfd/ocelot-core.c                  | 169 +++++
 drivers/mfd/ocelot-spi.c                   | 325 ++++++++++
 drivers/mfd/ocelot.h                       |  36 ++
 drivers/net/dsa/ocelot/Kconfig             |  14 +
 drivers/net/dsa/ocelot/Makefile            |   5 +
 drivers/net/dsa/ocelot/felix.c             |   7 +-
 drivers/net/dsa/ocelot/felix.h             |   1 +
 drivers/net/dsa/ocelot/felix_vsc9959.c     |   1 +
 drivers/net/dsa/ocelot/ocelot_ext.c        | 681 +++++++++++++++++++++
 drivers/net/dsa/ocelot/seville_vsc9953.c   |   4 +-
 drivers/net/ethernet/mscc/ocelot_devlink.c |  31 +
 drivers/net/ethernet/mscc/ocelot_vsc7514.c |  28 -
 drivers/net/mdio/mdio-mscc-miim.c          |  49 +-
 drivers/pinctrl/Kconfig                    |   4 +-
 drivers/pinctrl/pinctrl-microchip-sgpio.c  |  26 +-
 drivers/pinctrl/pinctrl-ocelot.c           |  33 +-
 include/linux/mdio/mdio-mscc-miim.h        |   3 +-
 include/linux/mfd/core.h                   |  10 +
 include/soc/mscc/ocelot.h                  |  18 +
 22 files changed, 1409 insertions(+), 64 deletions(-)
 create mode 100644 drivers/mfd/ocelot-core.c
 create mode 100644 drivers/mfd/ocelot-spi.c
 create mode 100644 drivers/mfd/ocelot.h
 create mode 100644 drivers/net/dsa/ocelot/ocelot_ext.c

-- 
2.25.1

