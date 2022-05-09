Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8475520366
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 19:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239633AbiEIRRN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 13:17:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239627AbiEIRRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 13:17:08 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2061.outbound.protection.outlook.com [40.107.21.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BD13222C23;
        Mon,  9 May 2022 10:13:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FiXXAQDbegDDzznYVwpb/1RmiCTNRG5WnRom3rPDRv0IThOtkqRUbc7l5kE9WZj/rEjRUi20kb6MN8kPxl9Z8nTAQ7oHUDNJA58zSJXm4G6hA1Pqrw2BCR/xVuo0ln90gepT0RIAJw/IH7jtmo83Fp7avNGWUyvwChjlpqNyvTV2vJlBGLo6OIePNMOg51XD0ZoziekaqwD26HSUgSNU01VbXzoUBy0RtCy0kFsd9IpOUpYC/iekBugMR3PK/ZCx7UXOAOsj0OvxiieFCkp3grzI3tVpAr+CwlVl1fs0iGvtkfbOjkIx5Kjay3pmAx392AVc7+Q+VK4AoyoioLGcOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wtgB8+hVMEu29276aSUTOwbcQ+3JdxpasUrm+2aGSOM=;
 b=FDU+ZVxBaYlYP6GlWLSmJpEAjl827qX6BkII7DMe1DaL8hHOovvfuMHcGmmjVuXrnZwitg+MwKQJpjNu/oqfn/XBY8ZWPKQM7mAdwUlFgggOoZ7ffYo5QyxKM1nSZ3CMjTOBCElNEM61naWyK28Bv1WRBklrS6mBE1SKSu4dW25+LCahoiiw8Cxe43Td2wddy0U9Lhg3zazA4H9QTTIY/5NA8QRGgj50Gizjinlt+PoUGLFrcv+Y5/YAz9DoRYi07ePBi/xlyAW457wHr0hryXfAuDuj1A40you/41DERPwAR0/hba56HLhXA6ISJFgtV+cvM6G7rIkYX0mJO5/cGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wtgB8+hVMEu29276aSUTOwbcQ+3JdxpasUrm+2aGSOM=;
 b=S8WnMox+trjP6usXPJlct9n+PoUIXoBYz5ZUA74JsZu8O+bXI2LIBIqVHLZMnmeHvCiextxQqJLb6O0dwDnkMZMJrHf9vTSZrwgoYw+ewOyU9o2uWZDnmcnipI2cx2aU9PqwnJr/mfkrEjl8VqLV5uaiTKlQQz4fjoyye45mXdc=
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by PAXPR04MB9519.eurprd04.prod.outlook.com (2603:10a6:102:22e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Mon, 9 May
 2022 17:13:06 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb%4]) with mapi id 15.20.5227.022; Mon, 9 May 2022
 17:13:05 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Wolfram Sang <wsa@kernel.org>,
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
        Andrew Lunn <andrew@lunn.ch>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [RFC v8 net-next 00/16] add support for VSC7512 control over SPI
Thread-Topic: [RFC v8 net-next 00/16] add support for VSC7512 control over SPI
Thread-Index: AQHYYwzpO7u0NDHwdU2qDb+lARh+Pa0WyfwA
Date:   Mon, 9 May 2022 17:13:05 +0000
Message-ID: <20220509171304.hfh5rbynt4qtr6m4@skbuf>
References: <20220508185313.2222956-1-colin.foster@in-advantage.com>
In-Reply-To: <20220508185313.2222956-1-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4f6dad48-04bc-41f9-1f2c-08da31df2ea8
x-ms-traffictypediagnostic: PAXPR04MB9519:EE_
x-microsoft-antispam-prvs: <PAXPR04MB951989DA0D6D5BDDE3BB4A74E0C69@PAXPR04MB9519.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 26nOxTn7C9RZbmWKSf2h4JJ1nIe9tKyujalTLySwhAblU8TffeStElMCEp2i0Nvp2kXkWHQqmbsSpqw/k8j/3ANqZDbXYteID2aLTTvIiSsajBwLle2cmcWeOurjForPW3Kux2GhwHkP8cEflp+n1J8jup0TWyqtOI1acR2uvUoGborobCJCrrXuwqdEU8FhwbwJYn2J69zyOCZTU3I+qY2lgCnf6C6JMvVlBfBkghg7AF7QR9dNFi+FkED4DP4lI2ikFa9h+qXk46pmmLL+Kn19e3B11oeqhhaZas1aST4MrCjoPPyYMAXPZLEjAgBfZ3PrIwBWTIIVd2NLzP9NwuwzObhL7/Ui+v+Xv4YRw96sE8bd/K/Qd8DBjJdpTIjDnCfHCw+tNvwUsEnrUHUwiC/zzZ8vHz5oZEUWbZtDnEsbUU5GuO3z9/OBQHRpP4IKl0LFolkxETpL+Y/o6faXM8pVlQhyqGbOWTo0K7Tn8H/2hJr/vWo9Db7SzaDqodynj7JNkL2ljrI7yYJRz0k6NOkT11CvRaMVkAnniR7oi596CaqH/531cF4us68IqSD4/nlXyX/BVzKzNTdRq4AZZNZQm9+G2poQ9ua1qfaZHxtg30HGKzMyKXYCNhojCgSITkZSIV1U7xuZO67SaG6MOvM3L8q248SNDhTsV8nJlE8BIjD/qQ1kaPaICT6rBz/I8pqmgNH+kwOSomKy6r4+AA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(8676002)(30864003)(44832011)(33716001)(8936002)(64756008)(66476007)(66556008)(66446008)(76116006)(66946007)(316002)(4326008)(6486002)(6506007)(71200400001)(6916009)(54906003)(5660300002)(7416002)(508600001)(2906002)(38070700005)(86362001)(122000001)(1076003)(186003)(9686003)(83380400001)(26005)(6512007)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?e7lnAAdB4EbBMf3b3KUPlF2+aVyH/xVz7H+qg9CmHBH4FhDslf9US9MZ8r6s?=
 =?us-ascii?Q?7Y8Ov4LoP9QqQ6ejEN8FM0seJukZmTrnek4r2SU+Ilk5viazrpLXMzdPOa0j?=
 =?us-ascii?Q?x3y9uJGlrot18IaiTKGRVdUr6ElgU4t7xiHnFir1BeZDlORO7zmt7YAkc+ZV?=
 =?us-ascii?Q?iEG1yr+Q8VmqDARvuwP700j7V6SrbwotmfmXe5iZvSy7zDfbtZ/nKQUa6cwQ?=
 =?us-ascii?Q?whmIr3srfLN/u7n/RyIraj29yjwSXgK1X2w3qKxkC/XfLQwYuVK0g8Hsg1Wd?=
 =?us-ascii?Q?vB0q0FtWR0Ea1musurQL+jfgdyEtkboIHE0nX2yf2+AqygEMLTNQyGbptpnv?=
 =?us-ascii?Q?xGVJPaRLRD9cjPqX/dZevRmGiDk3cQrM1SE85PlS+nyY84FolVsBwPCAGowl?=
 =?us-ascii?Q?aUTzyo2OoqMYsyTT5EQ/hF3cNUtZ1aVzdzN4D0lLj/cvym+xi29smWDoNfB3?=
 =?us-ascii?Q?zvNYnBsXJZxUV986j2pqCZ3wDCsR6x/AGfnI1fcldTO00x/qHDQ3BLpy7Oz9?=
 =?us-ascii?Q?AmsUHi8B+mFLrrb0SeJA/Cy62mc2yrCqJxYvMV4sMzog/slD/XLLAqyq0NWq?=
 =?us-ascii?Q?oa5rGJvrc9c0EZQsl/Ktp0GPFg4T0VrnV3/vhcENlPRh/WYAYigWvvfglNQB?=
 =?us-ascii?Q?plqy1td7848NFqBstAyBEFYwRgzEkbOcEIdKvux8jPN72dIjAVCQH+wEJByC?=
 =?us-ascii?Q?RmDZ5r+QaVajJLwc3WAHmOottKAYyiz0D87l0LBoIWqpRSurwyzoVx26XQwG?=
 =?us-ascii?Q?2Dw+FR70pQHm6EunA98+wZuhzPSNXPIEreupmUVfv0ntoZuD0YZ82SUTgcum?=
 =?us-ascii?Q?RIPTUMcpm0/bZxcpupU3O1RuTLYUghmfpg0IX2XTSSj2Z69H86qqoqkUSRDA?=
 =?us-ascii?Q?d75Q6A0uvfnvICDMTOttMa0J8lUtRMpZNRhzk7AnlzpzvuIhyUIx/5MKww9e?=
 =?us-ascii?Q?5E6rH2WBkmLKH14gs6aA3cZCP5swV96tpQ99ekb1EW/vX8f68Apw/yaD2pY4?=
 =?us-ascii?Q?Z1WLtwpqagHdRyfTs5/qRyCbMSDNiALT+/uwDA7Bssi4Uq+GhYqZl+Ln2I9Z?=
 =?us-ascii?Q?L7IcDwZfdHfRWGfn12jl90W5Q/OPAJO2pqjhcP11ksey7Gz39PefGtllP3rg?=
 =?us-ascii?Q?IoSdYo5tmmqENiebNkUHok5AyoPZmDSWW4YL22bCU9ILS6m4roruIFIf1Oke?=
 =?us-ascii?Q?SaiPGh5yJzm0qrF8CZBb/eypqIaPprQrDHSJhhw909J7U1IhhrUHh2jcxovM?=
 =?us-ascii?Q?Yjo8qjMXLrc4f9Q/LviOGZzhMcIl+lZ+Pa5wGZRa/sdkMrx6PqJKDGrR5+EG?=
 =?us-ascii?Q?I2oUvsd6NV8Zz//s60TGrlCoAuiyvqQDZZsuk79go2o835Z3z2jozN/4oTtV?=
 =?us-ascii?Q?afN90PqPV39sTglqeSmIbNfHzXIRODuVwcIHKdidNTEFuUuufPP+EW5y2PFI?=
 =?us-ascii?Q?gLOosAse1yv1SGif9bmEsHxGCHWy8C+IopiGylsFme58fR3wAQ0JmD/Da9e9?=
 =?us-ascii?Q?TCZxxg4scrN6cNah5xIu6t9Cjain65HVKVr1bt01ZHmuGbfgV3Wy9AD1JWMf?=
 =?us-ascii?Q?BAuL5KmNV2MU6bof/lDJaPKUc5oqXw4nFWyK7gTYBoXTTdG2B1S71scshVgm?=
 =?us-ascii?Q?ILjqHnGXysOHkMEBU/Imv7Qes42KP7P7dX9DbKwoX2LEn87Lhp8fn6ZN+X4u?=
 =?us-ascii?Q?GlMA7w/PDIm+13C9c4x9Edryaq257PXRNANvdS9a78N/9OjjK/tll88P7XZz?=
 =?us-ascii?Q?jILSILFr2ptLeko2FoQv0q3E6+VYNIA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4FD4442D19E59943A59CCAC2D0C463B4@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f6dad48-04bc-41f9-1f2c-08da31df2ea8
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2022 17:13:05.6428
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bqw3lL6Bd5A3HrI7sKBXXJME2+NG6aDBoH3KqK8g7+FhTnCptxQhbz5/VJfvWJZEbLxgObvzUuPys9pcUpw2Bw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9519
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Colin,

On Sun, May 08, 2022 at 11:52:57AM -0700, Colin Foster wrote:
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

This ti,dual-emac-pvid thing is a really odd thing to put in the device
tree. But what's the problem with VLAN 0 anyway?

>=20
> I believe much of the MFD sections are very near feature-complete,
> whereas the switch section will require ongoing work to enable
> additional ports / features. This could lead to a couple potential
> scenarios:
>=20
> The first being patches 1-8 being split into a separate patch set, while
> patches 9-16 remain in the RFC state. This would offer the pinctrl /
> sgpio / mdio controller functionality, but no switch control until it is
> ready.
>=20
> The second would assume the current state of the switch driver is
> acceptable (or at least very near so) and the current patch set gets an
> official PATCH set (with minor changes as necessary - e.g. squashing
> patch 16 into 14). That might be ambitious.
>=20
> The third would be to keep this patch set in RFC until switch
> functionality is more complete. I'd understand if this was the desired
> path... but it would mean me having to bug more reviewers.

Considering that the merge window is approaching, I'd say get the
non-DSA stuff accepted until then, then repost the DSA stuff in ~3 weeks
from now as non-RFC, once v5.18 is cut and the development for v5.20
(or whatever the number will be) begins.

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

Can you use hyphens instead of underscores in this compatible string?

> 		spi-max-frequency =3D <2500000>;
> 		reg =3D <0>;
>=20
> 		ethernet-switch@0 {

I don't think the switch node should have any address?

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

This is going to be interesting. Some drivers with multiple MDIO buses
create an "mdios" container with #address-cells =3D <1> and put the MDIO
bus nodes under that. Others create an "mdio" node and an "mdio0" node
(and no address for either of them).

The problem with the latter approach is that
Documentation/devicetree/bindings/net/mdio.yaml does not accept the
"mdio0"/"mdio1" node name for an MDIO bus.

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
> 		};
>=20
> 		gpio: pinctrl@0 {

Similar thing with the address. All these @0 addresses actually conflict
with each other.

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

And mixing nodes with addresses with nodes without addresses is broken too.

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
> 	};
> };
>=20
> And I'll include the relevant dmesg prints - I don't love the "invalid
> resource" prints, as they seem to be misleading. They're a byproduct of
> looking for IO resources before falling back to REG.
>=20
> [    0.000000] Booting Linux on physical CPU 0x0
> [    0.000000] Linux version 5.18.0-rc5-01295-g47053e327c52 (X@X) (arm-li=
nux-gnueabi-gcc (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0, GNU ld (GNU Binutils=
 for Ubuntu) 2.34) #630 SMP PREEMPT Sun May 8 10:56:51 PDT 2022
> ...
> [    2.829319] pinctrl-ocelot ocelot-pinctrl.0.auto: DMA mask not set

Why does this get printed, if you put a dump_stack() in of_dma_configure_id=
()?

> [    2.835718] pinctrl-ocelot ocelot-pinctrl.0.auto: invalid resource
> [    2.842717] gpiochip_find_base: found new base at 2026
> [    2.842774] gpio gpiochip4: (ocelot-gpio): created GPIO range 0->21 =
=3D=3D> ocelot-pinctrl.0.auto PIN 0->21
> [    2.845693] gpio gpiochip4: (ocelot-gpio): added GPIO chardev (254:4)
> [    2.845828] gpio gpiochip4: registered GPIOs 2026 to 2047 on ocelot-gp=
io
> [    2.845855] pinctrl-ocelot ocelot-pinctrl.0.auto: driver registered
> [    2.855925] pinctrl-microchip-sgpio ocelot-sgpio.1.auto: DMA mask not =
set
> [    2.863089] pinctrl-microchip-sgpio ocelot-sgpio.1.auto: invalid resou=
rce
> [    2.870801] gpiochip_find_base: found new base at 1962
> [    2.871528] gpio_stub_drv gpiochip5: (ocelot-sgpio.1.auto-input): adde=
d GPIO chardev (254:5)
> [    2.871666] gpio_stub_drv gpiochip5: registered GPIOs 1962 to 2025 on =
ocelot-sgpio.1.auto-input
> [    2.872364] gpiochip_find_base: found new base at 1898
> [    2.873244] gpio_stub_drv gpiochip6: (ocelot-sgpio.1.auto-output): add=
ed GPIO chardev (254:6)
> [    2.873354] gpio_stub_drv gpiochip6: registered GPIOs 1898 to 1961 on =
ocelot-sgpio.1.auto-output
> [    2.881148] mscc-miim ocelot-miim0.2.auto: DMA mask not set
> [    2.886929] mscc-miim ocelot-miim0.2.auto: invalid resource
> [    2.893738] mdio_bus ocelot-miim0.2.auto-mii: GPIO lookup for consumer=
 reset
> [    2.893769] mdio_bus ocelot-miim0.2.auto-mii: using device tree for GP=
IO lookup
> [    2.893802] of_get_named_gpiod_flags: can't parse 'reset-gpios' proper=
ty of node '/ocp/interconnect@48000000/segment@0/target-module@30000/spi@0/=
ocelot-chip@0/mdio0[0]'
> [    2.893898] of_get_named_gpiod_flags: can't parse 'reset-gpio' propert=
y of node '/ocp/interconnect@48000000/segment@0/target-module@30000/spi@0/o=
celot-chip@0/mdio0[0]'
> [    2.893996] mdio_bus ocelot-miim0.2.auto-mii: using lookup tables for =
GPIO lookup
> [    2.894012] mdio_bus ocelot-miim0.2.auto-mii: No GPIO consumer reset f=
ound
> [    3.395738] mdio_bus ocelot-miim0.2.auto-mii:00: GPIO lookup for consu=
mer reset
> [    3.395777] mdio_bus ocelot-miim0.2.auto-mii:00: using device tree for=
 GPIO lookup
> [    3.395840] of_get_named_gpiod_flags: can't parse 'reset-gpios' proper=
ty of node '/ocp/interconnect@48000000/segment@0/target-module@30000/spi@0/=
ocelot-chip@0/mdio0/ethernet-phy@0[0]'
> [    3.395959] of_get_named_gpiod_flags: can't parse 'reset-gpio' propert=
y of node '/ocp/interconnect@48000000/segment@0/target-module@30000/spi@0/o=
celot-chip@0/mdio0/ethernet-phy@0[0]'
> [    3.396069] mdio_bus ocelot-miim0.2.auto-mii:00: using lookup tables f=
or GPIO lookup
> [    3.396086] mdio_bus ocelot-miim0.2.auto-mii:00: No GPIO consumer rese=
t found
> ...
> [    3.449187] ocelot-ext-switch ocelot-ext-switch.4.auto: DMA mask not s=
et
> [    5.336880] ocelot-ext-switch ocelot-ext-switch.4.auto: PHY [ocelot-mi=
im0.2.auto-mii:00] driver [Generic PHY] (irq=3DPOLL)
> [    5.349087] ocelot-ext-switch ocelot-ext-switch.4.auto: configuring fo=
r phy/internal link mode
> [    5.363619] ocelot-ext-switch ocelot-ext-switch.4.auto swp1 (uninitial=
ized): PHY [ocelot-miim0.2.auto-mii:01] driver [Generic PHY] (irq=3DPOLL)
> [    5.381396] ocelot-ext-switch ocelot-ext-switch.4.auto swp2 (uninitial=
ized): PHY [ocelot-miim0.2.auto-mii:02] driver [Generic PHY] (irq=3DPOLL)
> [    5.398525] ocelot-ext-switch ocelot-ext-switch.4.auto swp3 (uninitial=
ized): PHY [ocelot-miim0.2.auto-mii:03] driver [Generic PHY] (irq=3DPOLL)

Do the PHYs not have a specific driver?

> [    5.422048] device eth0 entered promiscuous mode
> [    5.426785] DSA: tree 0 setup
> ...
> [    7.450067] ocelot-ext-switch ocelot-ext-switch.4.auto: Link is Up - 1=
00Mbps/Full - flow control off
> [   21.556395] cpsw-switch 4a100000.switch: starting ndev. mode: dual_mac
> [   21.648564] SMSC LAN8710/LAN8720 4a101000.mdio:00: attached PHY driver=
 (mii_bus:phy_addr=3D4a101000.mdio:00, irq=3DPOLL)
> [   21.667970] 8021q: adding VLAN 0 to HW filter on device eth0
> [   21.705360] ocelot-ext-switch ocelot-ext-switch.4.auto swp1: configuri=
ng for phy/internal link mode
> [   22.018230] ocelot-ext-switch ocelot-ext-switch.4.auto: Link is Down
> [   23.771740] cpsw-switch 4a100000.switch eth0: Link is Up - 100Mbps/Ful=
l - flow control off
> [   24.090929] ocelot-ext-switch ocelot-ext-switch.4.auto: Link is Up - 1=
00Mbps/Full - flow control off
> [   25.853021] ocelot-ext-switch ocelot-ext-switch.4.auto swp1: Link is U=
p - 1Gbps/Full - flow control rx/tx
>=20
>=20
> RFC history:
> v1 (accidentally named vN)
> 	* Initial architecture. Not functional
> 	* General concepts laid out
>=20
> v2
> 	* Near functional. No CPU port communication, but control over all
> 	external ports
> 	* Cleaned up regmap implementation from v1
>=20
> v3
> 	* Functional
> 	* Shared MDIO transactions routed through mdio-mscc-miim
> 	* CPU / NPI port enabled by way of vsc7512_enable_npi_port /
> 	felix->info->enable_npi_port
> 	* NPI port tagging functional - Requires a CPU port driver that supports
> 	frames of 1520 bytes. Verified with a patch to the cpsw driver
>=20
> v4
>     * Functional
>     * Device tree fixes
>     * Add hooks for pinctrl-ocelot - some functionality by way of sysfs
>     * Add hooks for pinctrl-microsemi-sgpio - not yet fully functional
>     * Remove lynx_pcs interface for a generic phylink_pcs. The goal here
>     is to have an ocelot_pcs that will work for each configuration of
>     every port.
>=20
> v5
>     * Restructured to MFD
>     * Several commits were split out, submitted, and accepted
>     * pinctrl-ocelot believed to be fully functional (requires commits
>     from the linux-pinctrl tree)
>     * External MDIO bus believed to be fully functional
>=20
> v6
>     * Applied several suggestions from the last RFC from Lee Jones. I
>       hope I didn't miss anything.
>     * Clean up MFD core - SPI interaction. They no longer use callbacks.
>     * regmaps get registered to the child device, and don't attempt to
>       get shared. It seems if a regmap is to be shared, that should be
>       solved with syscon, not dev or mfd.
>=20
> v7
>     * Applied as much as I could from Lee and Vladimir's suggestions. As
>       always, the feedback is greatly appreciated!
>     * Remove "ocelot_spi" container complication
>     * Move internal MDIO bus from ocelot_ext to MFD, with a devicetree
>       change to match
>     * Add initial HSIO support
>     * Switch to IORESOURCE_REG for resource definitions
>=20
> v8
>     * Applied another round of suggestions from Lee and Vladimir
>     * Utilize regmap bus reads, which speeds bulk transfers up by an

bus -> bulk?

>       order of magnitude
>     * Add two additional patches to utilize phylink_generic_validate
>     * Changed GPL V2 to GPL in licenses where applicable (checkpatch)
>     * Remove initial hsio/serdes changes from the RFC
>=20
>=20
> Colin Foster (16):
>   pinctrl: ocelot: allow pinctrl-ocelot to be loaded as a module
>   pinctrl: microchip-sgpio: allow sgpio driver to be used as a module
>   net: ocelot: add interface to get regmaps when exernally controlled
>   net: mdio: mscc-miim: add ability to be used in a non-mmio
>     configuration
>   pinctrl: ocelot: add ability to be used in a non-mmio configuration
>   pinctrl: microchip-sgpio: add ability to be used in a non-mmio
>     configuration
>   resource: add define macro for register address resources
>   mfd: ocelot: add support for the vsc7512 chip via spi
>   net: mscc: ocelot: expose ocelot wm functions
>   net: dsa: felix: add configurable device quirks
>   net: mscc: ocelot: expose regfield definition to be used by other
>     drivers
>   net: mscc: ocelot: expose stats layout definition to be used by other
>     drivers
>   net: mscc: ocelot: expose vcap_props structure
>   net: dsa: ocelot: add external ocelot switch control
>   net: dsa: felix: add phylink_get_caps capability
>   net: dsa: ocelot: utilize phylink_generic_validate
>=20
>  drivers/mfd/Kconfig                        |  18 +
>  drivers/mfd/Makefile                       |   2 +
>  drivers/mfd/ocelot-core.c                  | 138 ++++++++
>  drivers/mfd/ocelot-spi.c                   | 311 +++++++++++++++++
>  drivers/mfd/ocelot.h                       |  34 ++
>  drivers/net/dsa/ocelot/Kconfig             |  14 +
>  drivers/net/dsa/ocelot/Makefile            |   5 +
>  drivers/net/dsa/ocelot/felix.c             |  29 +-
>  drivers/net/dsa/ocelot/felix.h             |   3 +
>  drivers/net/dsa/ocelot/felix_vsc9959.c     |   1 +
>  drivers/net/dsa/ocelot/ocelot_ext.c        | 366 +++++++++++++++++++++
>  drivers/net/dsa/ocelot/seville_vsc9953.c   |   1 +
>  drivers/net/ethernet/mscc/ocelot_devlink.c |  31 ++
>  drivers/net/ethernet/mscc/ocelot_vsc7514.c | 230 +------------
>  drivers/net/ethernet/mscc/vsc7514_regs.c   | 200 +++++++++++
>  drivers/net/mdio/mdio-mscc-miim.c          |  31 +-
>  drivers/pinctrl/Kconfig                    |   4 +-
>  drivers/pinctrl/pinctrl-microchip-sgpio.c  |  26 +-
>  drivers/pinctrl/pinctrl-ocelot.c           |  35 +-
>  include/linux/ioport.h                     |   5 +
>  include/soc/mscc/ocelot.h                  |  19 ++
>  include/soc/mscc/vsc7514_regs.h            |   6 +
>  22 files changed, 1251 insertions(+), 258 deletions(-)
>  create mode 100644 drivers/mfd/ocelot-core.c
>  create mode 100644 drivers/mfd/ocelot-spi.c
>  create mode 100644 drivers/mfd/ocelot.h
>  create mode 100644 drivers/net/dsa/ocelot/ocelot_ext.c
>=20
> --=20
> 2.25.1
>=
