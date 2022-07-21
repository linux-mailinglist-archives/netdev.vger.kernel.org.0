Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDB8257CD35
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 16:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbiGUOUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 10:20:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbiGUOUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 10:20:49 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140089.outbound.protection.outlook.com [40.107.14.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B32431924;
        Thu, 21 Jul 2022 07:20:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P5IlKo7/SYX+MgqQxtD4Hck9UocGkOcpjDAzZ4py1ByJIhk/xKC1H7PtaYUX3YMV+y756E6NnqPsZk7io1xWx5iebLWLOh4zrEw8LDrcM1S9q5UeVbz2k2zn4lXdR737H2D0OpcPcWu4d75hL3oOg3LViDwdpIZ03egYpPYCpwaSuI1UgUY43vYbmgDW3Jr8ZCcZXwgHJPQwP7Qda+VQoGAuyoqHpp2K5saNqkWkdgE2bAp3irScjglyeYMsJzoK8a+FCxWFiu7lICm+fs20KCAYLxp/7Doh8jXy9MVQ9/k/1FoGDHjm1gdb6tKJc2IWlLhGEs+SyqzOwCkQX9yDTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hrbWObrkKPUODBDZ87wWS64MBlJNvyPdOMPHDfhBWls=;
 b=Fn3o5JbBbdwo2Ypwn3BRk6mLSNNJz4AQjzxa9x36MiyENXg086EEEP+LcTa9P9OwSwqnqejf7mQJtmxyrlcRNld9IArB0kjbgrDDf/vt3IlpnCOUjsMWz/6z4D3sMzHK1LWs2sDzsfVvWcuxAU2ut5tiDTASUjHTQ2+WvYrZpjW1pxg5dVPJ8V03/BthyQeMb+b49keNGekPSdmPkrzyOmZSOXcEayhMRmlnTLV5KmEL3KJSqxtUUSZWlxN45S/SzpxCEiy347YMqdS9dhpycKwIqx0M25SbTYQcQ33mEDL5aZRI4lkx4phrgP131NjsPUcZ8oMFXazD8BppWmGNVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hrbWObrkKPUODBDZ87wWS64MBlJNvyPdOMPHDfhBWls=;
 b=Yrbh3VmyZplORLkDbcx3urfdBizUClOLeV4WCc9mfX5RN1VUJapF61/nNp0TDX4NyiXYrvMtJaxdMlspcYff18/TWKWvGwlcQRGdluzAJb0SEtnJgVK8aRPoTzCBIeZ7LE+gA3jIOQOcElgnKS9bNm+5ZcYg6repCVYyuX5YjRM=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by GV1PR04MB9088.eurprd04.prod.outlook.com (2603:10a6:150:23::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Thu, 21 Jul
 2022 14:20:42 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::1df3:3463:6004:6e27]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::1df3:3463:6004:6e27%4]) with mapi id 15.20.5458.018; Thu, 21 Jul 2022
 14:20:42 +0000
From:   Camelia Alexandra Groza <camelia.groza@nxp.com>
To:     Sean Anderson <sean.anderson@seco.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sean Anderson <sean.anderson@seco.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Leo Li <leoyang.li@nxp.com>, Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-phy@lists.infradead.org" <linux-phy@lists.infradead.org>
Subject: RE: [PATCH net-next v3 46/47] arm64: dts: ls1046ardb: Add serdes
 bindings
Thread-Topic: [PATCH net-next v3 46/47] arm64: dts: ls1046ardb: Add serdes
 bindings
Thread-Index: AQHYmJdO9OJQL8uRzkOwnuesK8wAT62I4DBg
Date:   Thu, 21 Jul 2022 14:20:42 +0000
Message-ID: <VI1PR04MB58077A401571734F967FAF12F2919@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-47-sean.anderson@seco.com>
In-Reply-To: <20220715215954.1449214-47-sean.anderson@seco.com>
Accept-Language: en-GB, ro-RO, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 587074b1-e57f-4272-e2a0-08da6b2431ed
x-ms-traffictypediagnostic: GV1PR04MB9088:EE_
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2eTkgOcGrXugVTseJKRWGvH4EAYC/HIuq5yEvZ6KNOWlRNt70/UWQ1nhtycLyVzhZYz7EHwYvMHy8jtfEFW4hpdwzl3nzsAN88D/Pkn1tdPnkaRhAgrk/PS3+xdy3hU1l4g4esAPg/U3f7xj30ESkxQxaiGK4UAtvacITxYFFja9c5Exl09v5eXXpTAdbYuEiM5IMqjyrgt+8JD/cp0u6xHxh/I5oRjgIKYE4EBO71zav70VuXIzQY8NyfHm+r2BQs4mDqjIRGhK8o3/rJYwNh0r99XI4QvtisF+FTX8CMDph8nirwS9yfNizMbqTKJoBsVSBfLxY2shSyTJYEO9vMBH+T1m1RIgUNZ1seEZupC5hxhpx9XRvcGJOfnTmkKnV/W7V2BuneGZtMd9Zaf/fhZvxcPJCNQ2W0vOlKN/DY14Kak9fhhavHH6CYGiJP3iOacfI4CpUiYyyXpc96kLEeaXb5q1TrPUdst2a7lmx0jymKlqDiXkJkag7AWogp8HSi808wrGbGyjBJe0EApd0OrB6lHletCdslEL6oiK1HfCoT8/BJAmVPS7pGUwTScYNNdm5O2P2uPQrgSRLZ159FGCffFO82VvRDYmq5i50A7OM4fNsofZgoLMUHQUCjY7oMhBcwMvierdAxeHWUzCNVuVOf2z80PrgNhKI78G9MsD4istKoLmyzncXBf19JLUZKbDh+CygHQQ4D+2wFV5Tqhhv2fjaOAEeO7SemSA4JDSybipp9ULWyalaJYZr31dPSICq8vds3hvQx5C1S/Rn4ACP+6ugbCMjeGn5IIyJ+o=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(39860400002)(396003)(136003)(366004)(38100700002)(71200400001)(478600001)(66446008)(41300700001)(54906003)(316002)(110136005)(53546011)(4326008)(33656002)(66476007)(76116006)(66946007)(7416002)(83380400001)(7696005)(186003)(66556008)(8676002)(38070700005)(86362001)(8936002)(52536014)(9686003)(55236004)(6506007)(55016003)(122000001)(5660300002)(64756008)(2906002)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?SCnE9aaLlP/+m6QqxViyXFuA/8er60l9o24YI9jqC7S6GYJY4QQ8nqVrzxIQ?=
 =?us-ascii?Q?eYtgEZCxwLhxTtV5dEI9/fSBFWusVVvbqv6gcLUGuf9nNbhbaFvdVB5dskLO?=
 =?us-ascii?Q?UtNqK1LkEYOyb/FiLymLWArtXYhTg8TeCyaeIaNgp0AZv3/cuub1PlJsjiJU?=
 =?us-ascii?Q?NZHO/ftgtYQsBpFa2I/loA93y3igF0RQHnheeFmQaIFOZYSvDQHu3oQqIjG6?=
 =?us-ascii?Q?ndWsriBw50YOvYB/nYMjLVIy4oWiMgy6avGb9W+9RH6xCgqNPR0n83DMHrP4?=
 =?us-ascii?Q?o3GmqKmpmAqfuHsrtWXstiDM8t4gpc5Y6QSB/st1mEK7jd0PExSg8gDnf85k?=
 =?us-ascii?Q?3taBIr3vmpQX4Ekfo8w+q5UC14GjTnDJiqfNLzaqosJiEb+rY6UNYpSaO1RP?=
 =?us-ascii?Q?PLiRjrBwbXHrXKTnu/a6aLiYtdbilHI0G2uZzIzKuiN45ybww9autRda3hXf?=
 =?us-ascii?Q?rVMI1zj81ij9Z2wYNxgd1mp6opKJdlI+5fyvRzLq+L6II8QI98t3HhQnXEmz?=
 =?us-ascii?Q?WmqMVVC/n/lhs3/rl6fEse3ZLhuEfjz/aX/XBJivlyhDtmYGih1lmZctDG8l?=
 =?us-ascii?Q?Swtd9ugNMbLB+bpmSa4QV3fLJx1DctW4hEoIM0eAVkpFhk0ZqtpU692mWWhz?=
 =?us-ascii?Q?ocEYPXcB6ZtIy+XMGkxq/QpOg7zrZNCMtMRECpIwkt6Xw39EXWYCgYhr3uo5?=
 =?us-ascii?Q?eluqfLgd6zxw6z57OMpMNj1jqVKubHQ/PtnSPJSuFC6gzrq4Ix1y15MfTIpg?=
 =?us-ascii?Q?w0oLE7K4yfGGkkUQmaGv6De98q1gi208uE7SnyHnPowLw2KHMsca6b/CmmUz?=
 =?us-ascii?Q?bWCrGXMmEfdte1VKvZeaQ3ddt8LZnb2yedw9puRVqz7hCBPIpfHhV1Y0iC8o?=
 =?us-ascii?Q?F9baNMpjWV68s0w1F5ZnaBi5zRaFHcfOl0HByVuOY9li1uyKL0zipVjOYtZd?=
 =?us-ascii?Q?t3it4QKnUxXiHtqSwGyVbViRR+WTVcwNY+dre2YsXb7Sv0XCcpA+2y58haO+?=
 =?us-ascii?Q?jX32rT1VJO/edZEtXU7QHjPkcSMFWORvz3EPs5+7Jcwv8KHJikEMd9lKN37q?=
 =?us-ascii?Q?HkoIHArGaZJKmTlNE3FcfHKXI6SncFvojv+p9T6i7SUUfLcage9fGHG0Y0x8?=
 =?us-ascii?Q?WP24O3jE8lAiKIScp0UaDIiYi9O8EomayL7tx49HOedzmTNX+ba5ljs9o/PW?=
 =?us-ascii?Q?vnqJNJC7Zs9j9qHrcD43n6arAKQvvucbPEal8FJMk6YbV/4ghcYlggNKh1tX?=
 =?us-ascii?Q?TXFMdaCtV1Uxh6BUdiEQ0QuzgBEtLPAFYnhPJHaFlOJF4ZOJ4CuvHXdI+K9q?=
 =?us-ascii?Q?jyJlWdIFiWRNTbad8iiR/i27tXtAKQ1u1o8iFbFRv6rHN8s4ymprNZsZxn5W?=
 =?us-ascii?Q?BzENuzXXB8bZ8KD8GFeXqiNqyb1nZ1RT7LfeZihmVKTybJySJf2+DA4J1R8U?=
 =?us-ascii?Q?uyc1FquJaSdoipD+2kOxijGlJrUhVVpBcSINgauUzNJbn8qB5lNqPWmDBg4d?=
 =?us-ascii?Q?eWZFlL5m88EfY26Qzrjx0Mug5p7Dcowu/lw91A9xAcMb7vyiBrzmQvlZ/PaH?=
 =?us-ascii?Q?r2QsjIWmoUrbkadNcZ+m0vCKxl2dzp4oedpx5BKe?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 587074b1-e57f-4272-e2a0-08da6b2431ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2022 14:20:42.6858
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wzpjqhrhCdIWTolWgV1mtpjCRadh1srmDP9BAHiOyhc4sj1N7ec2zsIVTNZhhOnLigQHOrl1p4B2jVge3uNOCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR04MB9088
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Sean Anderson <sean.anderson@seco.com>
> Sent: Saturday, July 16, 2022 1:00
> To: David S . Miller <davem@davemloft.net>; Jakub Kicinski
> <kuba@kernel.org>; Madalin Bucur <madalin.bucur@nxp.com>;
> netdev@vger.kernel.org
> Cc: Paolo Abeni <pabeni@redhat.com>; Eric Dumazet
> <edumazet@google.com>; linux-arm-kernel@lists.infradead.org; Russell
> King <linux@armlinux.org.uk>; linux-kernel@vger.kernel.org; Sean Anderson
> <sean.anderson@seco.com>; Kishon Vijay Abraham I <kishon@ti.com>;
> Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>; Leo Li
> <leoyang.li@nxp.com>; Rob Herring <robh+dt@kernel.org>; Shawn Guo
> <shawnguo@kernel.org>; Vinod Koul <vkoul@kernel.org>;
> devicetree@vger.kernel.org; linux-phy@lists.infradead.org
> Subject: [PATCH net-next v3 46/47] arm64: dts: ls1046ardb: Add serdes
> bindings
>=20
> This adds appropriate bindings for the macs which use the SerDes. The
> 156.25MHz fixed clock is a crystal. The 100MHz clocks (there are
> actually 3) come from a Renesas 6V49205B at address 69 on i2c0. There is
> no driver for this device (and as far as I know all you can do with the
> 100MHz clocks is gate them), so I have chosen to model it as a single
> fixed clock.
>=20
> Note: the SerDes1 lane numbering for the LS1046A is *reversed*.
> This means that Lane A (what the driver thinks is lane 0) uses pins
> SD1_TX3_P/N.
>=20
> Because this will break ethernet if the serdes is not enabled, enable
> the serdes driver by default on Layerscape.
>=20
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> ---
> Please let me know if there is a better/more specific config I can use
> here.
>=20
> (no changes since v1)

My LS1046ARDB hangs at boot with this patch right after the second SerDes i=
s probed,
right before the point where the PCI host bridge is registered. I can get a=
round this
either by disabling the second SerDes node from the device tree, or disabli=
ng
CONFIG_PCI_LAYERSCAPE at build.

I haven't debugged it more but there seems to be an issue here.

>  .../boot/dts/freescale/fsl-ls1046a-rdb.dts    | 34 +++++++++++++++++++
>  drivers/phy/freescale/Kconfig                 |  1 +
>  2 files changed, 35 insertions(+)
>=20
> diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts
> b/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts
> index 7025aad8ae89..4f4dd0ed8c53 100644
> --- a/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts
> +++ b/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts
> @@ -26,6 +26,32 @@ aliases {
>  	chosen {
>  		stdout-path =3D "serial0:115200n8";
>  	};
> +
> +	clocks {
> +		clk_100mhz: clock-100mhz {
> +			compatible =3D "fixed-clock";
> +			#clock-cells =3D <0>;
> +			clock-frequency =3D <100000000>;
> +		};
> +
> +		clk_156mhz: clock-156mhz {
> +			compatible =3D "fixed-clock";
> +			#clock-cells =3D <0>;
> +			clock-frequency =3D <156250000>;
> +		};
> +	};
> +};
> +
> +&serdes1 {
> +	clocks =3D <&clk_100mhz>, <&clk_156mhz>;
> +	clock-names =3D "ref0", "ref1";
> +	status =3D "okay";
> +};
> +
> +&serdes2 {
> +	clocks =3D <&clk_100mhz>, <&clk_100mhz>;
> +	clock-names =3D "ref0", "ref1";
> +	status =3D "okay";
>  };
>=20
>  &duart0 {
> @@ -140,21 +166,29 @@ ethernet@e6000 {
>  	ethernet@e8000 {
>  		phy-handle =3D <&sgmii_phy1>;
>  		phy-connection-type =3D "sgmii";
> +		phys =3D <&serdes1 1>;
> +		phy-names =3D "serdes";
>  	};
>=20
>  	ethernet@ea000 {
>  		phy-handle =3D <&sgmii_phy2>;
>  		phy-connection-type =3D "sgmii";
> +		phys =3D <&serdes1 0>;
> +		phy-names =3D "serdes";
>  	};
>=20
>  	ethernet@f0000 { /* 10GEC1 */
>  		phy-handle =3D <&aqr106_phy>;
>  		phy-connection-type =3D "xgmii";
> +		phys =3D <&serdes1 3>;
> +		phy-names =3D "serdes";
>  	};
>=20
>  	ethernet@f2000 { /* 10GEC2 */
>  		fixed-link =3D <0 1 1000 0 0>;
>  		phy-connection-type =3D "xgmii";
> +		phys =3D <&serdes1 2>;
> +		phy-names =3D "serdes";
>  	};
>=20
>  	mdio@fc000 {
> diff --git a/drivers/phy/freescale/Kconfig b/drivers/phy/freescale/Kconfi=
g
> index fe2a3efe0ba4..9595666213d0 100644
> --- a/drivers/phy/freescale/Kconfig
> +++ b/drivers/phy/freescale/Kconfig
> @@ -43,6 +43,7 @@ config PHY_FSL_LYNX_10G
>  	tristate "Freescale Layerscale Lynx 10G SerDes support"
>  	select GENERIC_PHY
>  	select REGMAP_MMIO
> +	default y if ARCH_LAYERSCAPE
>  	help
>  	  This adds support for the Lynx "SerDes" devices found on various
> QorIQ
>  	  SoCs. There may be up to four SerDes devices on each SoC, and
> each
> --
> 2.35.1.1320.gc452695387.dirty

