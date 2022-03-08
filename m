Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58D334D1AC9
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 15:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347644AbiCHOln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 09:41:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347649AbiCHOl1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 09:41:27 -0500
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50052.outbound.protection.outlook.com [40.107.5.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 247AC3980C;
        Tue,  8 Mar 2022 06:40:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fEw0+OfF4DWEb8NVbIp9GcldBGPcRbaI6hMLN2WP9kVxiaS1JtHEOuY3f2iiWwS8em70GMdLmmgareNmqUzC2GmMHPbOq1eA20VP+AOZbDB8fpEEb3JshEz2oYm7AUaR1qs/+00ZCSlrPY4Bgl3TQg0wL8u2I1DOQeQH/MjEg9uFzSCm+MGfeqwVG5CKyrdIcMyAS2xOcEmt650H1cwJorcWJOQEBPq5T1KADsrwUPXxeSXdbrBdMo9UfddlD7UJAcD3GrhN09Ju7RZdWOSf/CnUr8ZMiKRiz0qngfzNWtqQflcKzvLaLW5Pp81Rv6eehykrFuvkqNlSka0Z3zt/0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GlXZ9F9nllO2eSTCJDiXZ87XsBE12rgR/ENal7Y1GK8=;
 b=bNYy2ZbNLFKcEPYy1Lvc+JzJpUQ949pRhvcPHVkHu9/Rhp41OIquM/5b/CK3n+d9L7ijA9PIXQoh2ovcv3kJuIM/oAVWbyLyvZa736lTcoCfo9FoJgyBTSSTUQZRXqYQZ1KZPnHT6m+3tUj9tsSy7nKZD8XGwErlEp5t0Jk8dUU6SJwv3pY3ps7WPgx410Hyk4R8hl5D7y3Ir8F5QcR8N23bD+R4CrCXhgTNyw+nudK0xxfcG73Y5n5lA2cvqP++LyzGvE3+sS2rzXAbJR1arZWTbb8IxV6A0zhKBkyjVJq/tnuohabJFcAJ+Kd9bOe59itxs5PxAVx5AQg19rsXYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GlXZ9F9nllO2eSTCJDiXZ87XsBE12rgR/ENal7Y1GK8=;
 b=MWCHCwJ0zGJf62ckXRKY1grDrJFlyHAbqwGA5vwyP1mmL/Ar+r1BJl6Cn7NSwj/BPtmrVk4DhYnn9nVYorSR+0AlYtnOtm5AvXb8o1Qx94A7F+hcDCL64bKxf+1AVGHeCAZrQqfznPITNwSReL9q8tFzecwX2dDib2v/IGOw9dk=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8808.eurprd04.prod.outlook.com (2603:10a6:10:2e3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Tue, 8 Mar
 2022 14:39:57 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36%5]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 14:39:57 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-phy@lists.infradead.org" <linux-phy@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
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
        Andrew Lunn <andrew@lunn.ch>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee.jones@linaro.org>,
        "katie.morris@in-advantage.com" <katie.morris@in-advantage.com>
Subject: Re: [RFC v7 net-next 00/13] add support for VSC7512 control over SPI
Thread-Topic: [RFC v7 net-next 00/13] add support for VSC7512 control over SPI
Thread-Index: AQHYMcjMMQklYDWG1EudSp8aw3YIC6y1kTAA
Date:   Tue, 8 Mar 2022 14:39:57 +0000
Message-ID: <20220308143956.jik5bvszvqmrukgb@skbuf>
References: <20220307021208.2406741-1-colin.foster@in-advantage.com>
In-Reply-To: <20220307021208.2406741-1-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7742f581-83f5-42ed-4ce1-08da01118472
x-ms-traffictypediagnostic: DU2PR04MB8808:EE_
x-microsoft-antispam-prvs: <DU2PR04MB88083DD16DDC58A8C82A6588E0099@DU2PR04MB8808.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2J/IqW7epYfMHaPWMc2yWlEdZXLlxdkHP+WorFJhuhuA8rbQdOM2ErgU2oKPD5R/6ei8lod9ffBDTGsWdU1xAIpzqUHSpucj8ID/RhbUhRNaVGMfwRIuv51kQ6Oq71fqpdlDvXlQu7Clg00mjutIlyPsD70b6mMDhBHcOyuzhDdk0Di9vDaceMx+2TYYeyUtSPAu2JHgaLxKdIRDeWgjzz/zUx7R8B9wGqfqCk7qC3A3QB/WRmoVnV5Kp79i6LA7ESO14Wu/mK2xTQ1a30hrOsXpRXyybzppsuDztJgvF+gzbjw+wpLLKm0N6kHVMc+cKOxl8zOOBLa6gYtcbzaY1OB9EPOpKUBsIYNSdMFsX+7EZYZmydo73xtiUwLJkTRTNNUPltLxX+Donowhl4lYiSjcBP77hQd2XKsmp6X2br0RUf2Sp7breBIQ5M2KmuBJuQsNblFJbS2Riq+vfzAjWHrUhaNFhrCP/k+NX3Rir0YVWXcdWLU2HIEFk6xWRkfpufNZ7Vj6cm2B7aOMdMruizPrCMLovdYDtQ4nhIvbh2bk3tlt28Jbc1XfFYntn/kY79k9t3ehnae/ryP5d11WD2cP7ON5EEafD58ROWSSArabyvJZM5RHSeqDZqPpvFg2wzL5vbSWcjK0FNKgIC6qKcKpWC+kh50Uan4so3Gqb4fpWHaE1o9ipCWj+9iI8tS/FRYXYssZFjHNda51hY8VyA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(91956017)(2906002)(6506007)(6512007)(9686003)(66476007)(66446008)(64756008)(66556008)(76116006)(66946007)(6486002)(8676002)(4326008)(33716001)(498600001)(122000001)(71200400001)(38100700002)(86362001)(38070700005)(6916009)(54906003)(83380400001)(1076003)(186003)(44832011)(7416002)(5660300002)(26005)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MLLpbUXJgS4RWyw3zsqWivbujG9TAVgjPi7QGiW52dOkn/YtxLQAZ7TAdBQc?=
 =?us-ascii?Q?zzj6ODtvrqIhlIdR0rVdI6//sRrwbBxdxNvD2JGPaZRhzUAb8Z0RaNbScYEe?=
 =?us-ascii?Q?qv3p7zi7+F6AEJ70yrqjOTS43YHilMY/XkJ2E7HjluWy/GWdTSU/nb/i4IKW?=
 =?us-ascii?Q?53G2em5acOVpmrnPD54SC/pstSDxJ6XDEwDSQWD02mcLqNd8HjNkF2wNuWVU?=
 =?us-ascii?Q?pT1p97S3CpILhIaveosjTLvGBjOUZWzLZ3p5+PvlNgZ9235aRLekp2HIwkXx?=
 =?us-ascii?Q?kyH7VKW3FD3h+Wg0qc28iDxe7gI+E1WxbEb5YZJdZWA/5yi1P/FJPUzzYVrr?=
 =?us-ascii?Q?QqJFxfz5zLv0DVp1nVzIOWuawrl2R3eDV/JNkGZai+kd2yQjDQqaxWgFOTlo?=
 =?us-ascii?Q?TcI0QwjcJeVOybbivdVPUs59MPINEoYU2QvWGFKSoMRrJFFHlcVwAR5tjgol?=
 =?us-ascii?Q?NTI3IrAKiQu8PlIj0hKeLmawI2RbDEAfsEXrKeyr1a0OvfibpTVR+PSRHkny?=
 =?us-ascii?Q?JtgFRWt03BKuegWUv2hA928q5k/Nz/xxI7DE83OOSXmSn0nMed0AfzZdDjtJ?=
 =?us-ascii?Q?/xOvQdOKg8H0K/x1ttMf7PDbIu6x0P4TwN0Op59S58HHM3k9FMs4juo0i2xs?=
 =?us-ascii?Q?uCItOrQlbx/mSl3qEAPqqatC2uyH3Og2MBljx9y6Kaq4q7h5LkVlKFyt7N98?=
 =?us-ascii?Q?4afDlAACEsmTrAP9CSj3tr1GCq4yNRQf2nLfhvU4E/XM+Hjt/Z+WsXBecUi+?=
 =?us-ascii?Q?o3UCsBSWU21z/KP4ZUkE/KebFaLsCEk3IRB7cre0+Cc9nUMFhO06TbnQhNRn?=
 =?us-ascii?Q?OQzsKYRH6b1WcV2ceOE2hdvl9w/e3wNFwfllmzN4VHrt3afp+apKcBO5zor6?=
 =?us-ascii?Q?kfYm+4hnjwzOIF/zHyv1d3/mnVYNztQOfhV9cxtZ74IibCVST5AgRt5nu+We?=
 =?us-ascii?Q?sgi5chHEs9dM4u5K3dW4Lup2pDhuelbVBGPi4rMdc03rxM9pduwmRx1IJSN9?=
 =?us-ascii?Q?ZFb/uEyF4xfev/s7AO7fQ74ftA4KpaeF9CqI3WD4R6nV+77wZBlHLbEUIFev?=
 =?us-ascii?Q?LazM8H6yfu2oWgKpJvL164lERVWMF55OHBfirPFHjNebZXksBR9hLwr0y9Zh?=
 =?us-ascii?Q?36KeCSEC/P0SHixigI4ZTD1Sp5CvmKFlWeg/FyRq0aJnTvNjsquTdnY3f792?=
 =?us-ascii?Q?VNmaTtG5xg2diJs2VJZ6Y6zBrO9QJlSyQvV7hv5jUxvFe0iA52McYmV+mLUs?=
 =?us-ascii?Q?Thz7ZYVOWWG/6+g+xetU2G4mgGyCMiSHVKfVqlzi9WI9aHaOAO4DdtpwKCYE?=
 =?us-ascii?Q?0c92sAnJm8h6H432mz8BNKDu2eJkAgQYPrF8qnNcOZaYjQlthX5iOcacvhsu?=
 =?us-ascii?Q?vXMvtlo76hCIUA4LKB+pcOORpk2gD2rKY62KH8jRsiyvvqgaHShvsp5WRoB8?=
 =?us-ascii?Q?3R6WZpO9YD/ZpC72vASig2yx82GGU/adA3x0jsNb13t3IQc9vt96eLd8+jrb?=
 =?us-ascii?Q?lcf6lREjEmXgd8UYXOuK6QJ5uin1roTJdV+EV0E+yNirHEKvcjsnLmQMKbpx?=
 =?us-ascii?Q?7Xh1Ncepa+iR+idur4PCZeN5NOZE+BDowY+68TwDgD8bTf7JgId/fyqvwg/o?=
 =?us-ascii?Q?qCiqx/ZMrAtpbV6rZYvHJQ8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7B334D65EBDC354496E36D8446CBD1C3@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7742f581-83f5-42ed-4ce1-08da01118472
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2022 14:39:57.3407
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uhfO6iDTrMmAf9HTS7joLCCHe/X0CTvIZqWuZYhhoFhhuADjjzNCnBuxsJAygw3oFd8uI65pGWIK1cyStziyvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8808
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 06, 2022 at 06:11:55PM -0800, Colin Foster wrote:
> The patch set in general is to add support for the VSC7512, and
> eventually the VSC7511, VSC7513 and VSC7514 devices controlled over
> SPI. The driver is believed to be fully functional for the internal
> phy ports (0-3)  on the VSC7512. It is not yet functional for SGMII,
> QSGMII, and SerDes ports.
>=20
> I have mentioned previously:
> The hardware setup I'm using for development is a beaglebone black, with
> jumpers from SPI0 to the microchip VSC7512 dev board. The microchip dev
> board has been modified to not boot from flash, but wait for SPI. An
> ethernet cable is connected from the beaglebone ethernet to port 0 of
> the dev board.
>=20
> The relevant sections of the device tree I'm using for the VSC7512 is
> below. Notably the SGPIO LEDs follow link status and speed from network
> triggers.
>=20
> In order to make this work, I have modified the cpsw driver, and now the
> cpsw_new driver, to allow for frames over 1500 bytes. Otherwise the
> tagging protocol will not work between the beaglebone and the VSC7512. I
> plan to eventually try to get those changes in mainline, but I don't
> want to get distracted from my initial goal. I also had to change
> bonecommon.dtsi to avoid using VLAN 0.
>=20
>=20
> Of note: The Felix driver had the ability to register the internal MDIO
> bus. I am no longer using that in the switch driver, it is now an
> additional sub-device under the MFD.
>=20
> I also made use of IORESOURCE_REG, which removed the "device_is_mfd"
> requirement.
>=20
>=20
> / {
> 	vscleds {
> 		compatible =3D "gpio-leds";
> 		vscled@0 {
> 			label =3D "port0led";
> 			gpios =3D <&sgpio_out1 0 0 GPIO_ACTIVE_LOW>;
> 			default-state =3D "off";
> 			linux,default-trigger =3D "ocelot-miim0.2.auto-mii:00:link";
> 		};
> 		vscled@1 {
> 			label =3D "port0led1";
> 			gpios =3D <&sgpio_out1 0 1 GPIO_ACTIVE_LOW>;
> 			default-state =3D "off";
> 			linux,default-trigger =3D "ocelot-miim0.2.auto-mii:00:1Gbps";
> 		};
> [ ... ]
> 		vscled@71 {
> 			label =3D "port7led1";
> 			gpios =3D <&sgpio_out1 7 1 GPIO_ACTIVE_LOW>;
> 			default-state =3D "off";
> 			linux,default-trigger =3D "ocelot-miim1-mii:07:1Gbps";
> 		};
> 	};
> };
>=20
> &spi0 {
> 	#address-cells =3D <1>;
> 	#size-cells =3D <0>;
> 	status =3D "okay";
>=20
> 	ocelot-chip@0 {
> 		compatible =3D "mscc,vsc7512_mfd_spi";
> 		spi-max-frequency =3D <2500000>;
> 		reg =3D <0>;
>=20
> 		ethernet-switch@0 {

I'm not exactly clear on what exactly does the bus address (@0)
represent here and in other (but not all) sub-nodes.
dtc probably warns that there shouldn't be any unit address, since
#address-cells and #size-cells are both 0 for ocelot-chip@0.

> 			compatible =3D "mscc,vsc7512-ext-switch";
> 			ports {
> 				#address-cells =3D <1>;
> 				#size-cells =3D <0>;
>=20
> 				port@0 {
> 					reg =3D <0>;
> 					label =3D "cpu";
> 					status =3D "okay";
> 					ethernet =3D <&mac_sw>;
> 					phy-handle =3D <&sw_phy0>;
> 					phy-mode =3D "internal";
> 				};
>=20
> 				port@1 {
> 					reg =3D <1>;
> 					label =3D "swp1";
> 					status =3D "okay";
> 					phy-handle =3D <&sw_phy1>;
> 					phy-mode =3D "internal";
> 				};
> 			};
> 		};
>=20
> 		mdio0: mdio0@0 {
> 			compatible =3D "mscc,ocelot-miim";
> 			#address-cells =3D <1>;
> 			#size-cells =3D <0>;
>=20
> 			sw_phy0: ethernet-phy@0 {
> 				reg =3D <0x0>;
> 			};
>=20
> 			sw_phy1: ethernet-phy@1 {
> 				reg =3D <0x1>;
> 			};
>=20
> 			sw_phy2: ethernet-phy@2 {
> 				reg =3D <0x2>;
> 			};
>=20
> 			sw_phy3: ethernet-phy@3 {
> 				reg =3D <0x3>;
> 			};
> 		};
>=20
> 		mdio1: mdio1@1 {
> 			compatible =3D "mscc,ocelot-miim";
> 			pinctrl-names =3D "default";
> 			pinctrl-0 =3D <&miim1>;
> 			#address-cells =3D <1>;
> 			#size-cells =3D <0>;
>=20
> 			sw_phy4: ethernet-phy@4 {
> 				reg =3D <0x4>;
> 			};
>=20
> 			sw_phy5: ethernet-phy@5 {
> 				reg =3D <0x5>;
> 			};
>=20
> 			sw_phy6: ethernet-phy@6 {
> 				reg =3D <0x6>;
> 			};
>=20
> 			sw_phy7: ethernet-phy@7 {
> 				reg =3D <0x7>;
> 			};
>=20
> 		};
>=20
> 		gpio: pinctrl@0 {
> 			compatible =3D "mscc,ocelot-pinctrl";
> 			gpio-controller;
> 			#gpio_cells =3D <2>;
> 			gpio-ranges =3D <&gpio 0 0 22>;
>=20
> 			led_shift_reg_pins: led-shift-reg-pins {
> 				pins =3D "GPIO_0", "GPIO_1", "GPIO_2", "GPIO_3";
> 				function =3D "sg0";
> 			};
>=20
> 			miim1: miim1 {
> 				pins =3D "GPIO_14", "GPIO_15";
> 				function =3D "miim";
> 			};
> 		};
>=20
> 		sgpio: sgpio {
> 			compatible =3D "mscc,ocelot-sgpio";
> 			#address-cells =3D <1>;
> 			#size-cells =3D <0>;
> 			bus-frequency=3D<12500000>;
> 			clocks =3D <&ocelot_clock>;
> 			microchip,sgpio-port-ranges =3D <0 15>;
> 			pinctrl-names =3D "default";
> 			pinctrl-0 =3D <&led_shift_reg_pins>;
>=20
> 			sgpio_in0: sgpio@0 {
> 				compatible =3D "microchip,sparx5-sgpio-bank";
> 				reg =3D <0>;
> 				gpio-controller;
> 				#gpio-cells =3D <3>;
> 				ngpios =3D <64>;
> 			};
>=20
> 			sgpio_out1: sgpio@1 {
> 				compatible =3D "microchip,sparx5-sgpio-bank";
> 				reg =3D <1>;
> 				gpio-controller;
> 				#gpio-cells =3D <3>;
> 				ngpios =3D <64>;
> 			};
> 		};
>=20
> 		hsio: syscon {
> 			compatible =3D "mscc,ocelot-hsio", "syscon", "simple-mfd";
>=20
> 			serdes: serdes {
> 				compatible =3D "mscc,vsc7514-serdes";
> 				#phy-cells =3D <2>;
> 			};
> 		};
> 	};
> };

The switch-related portion of this patch set looks good enough to me.
I'll let somebody else with more knowledge provide feedback on the
mfd/pinctrl/gpio/phylink/led integration aspects.=
