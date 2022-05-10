Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF875220B0
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 18:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347085AbiEJQJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 12:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347406AbiEJQGb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 12:06:31 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150074.outbound.protection.outlook.com [40.107.15.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03062201EA9;
        Tue, 10 May 2022 08:58:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R7XrdWVGrstil0OfGXDP6RtEvoXVdhoQNQfoSSh7Ixaqte4UBqFfZGZKj1SpUVhCYABm9RE/e8pyoKbGrdv/oJ06zxogmcnopnInYQzW5BD/wJRY8z8pNPy8FHHqBjuQ+u1J5kbd4Boqnm0FpUFQKnJVky3QfDftNpvYRLjPw5OFwbXJZhmce14OZ+6+UzX3euMrJXI62SBVTq9+FMMd2W08D83YsbrlGHk+aVRYyRiXisjAW0IlZEb633VkaGq0ABNi1Xi+os/ZWPeVY2a3JtvOtxx6q8aFHeEqCLFKkq7DBRAyoDhkJ3vbJp5od0/Aqd1PFXFySuPqxGqv69hzUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d3uflw344q4QRIc/qUW+uFmUkKeHMuQuGKSkSBKL2v4=;
 b=jDkOZgPCn4RRMbEbaV4eTHXSNR/yi82W6ZjWxGKxU0JBWU/pIJPDtclng8wrZhynmuTprLDEwZigfg4w/8YHce79JXW+G9jSRioRnJaeV/ktOLMvYbEctxDjIxdlzrBMJ+PqVjYKPW7Tbecmqo8DfX3MH6HbBxrEhnoRZ+YaQjPr3bncltAYghrS2/bdrBfFd2r9Tw3pW3Qg5+9TmL+6sX05bhitRpNWbLKyJszLm0Z+nhtQxgP1IvSzWGgiJE0wyIwULOJYLhsuZLHaYvx6jpvIj3oLJ6tbOSDXb7vZ9szS/NysDu/f20/S14W83ld/9g9kYz4/25FwpKkSM8LSzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d3uflw344q4QRIc/qUW+uFmUkKeHMuQuGKSkSBKL2v4=;
 b=L03XqsbJy6bjAbueUfiwCJ3oCvkcXk9smFmEVH/PjLTTb33O3L60xAzf0u31LPcCBuC9/66W0VMfl7lIfWeqoM6UfYHVwe5DXhdHpW4UnlSfb1h42dgxme+kiDXjQIhGy6Vg2Xb9Ubr1ejbivZxycykN80AhQvcpuk+FWXQu12g=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB4914.eurprd04.prod.outlook.com (2603:10a6:208:ce::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Tue, 10 May
 2022 15:58:54 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 15:58:54 +0000
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
Subject: Re: [RFC v8 net-next 08/16] mfd: ocelot: add support for the vsc7512
 chip via spi
Thread-Topic: [RFC v8 net-next 08/16] mfd: ocelot: add support for the vsc7512
 chip via spi
Thread-Index: AQHYYwz1YnOGgXOqGkauFg8TINDh2q0YR5eA
Date:   Tue, 10 May 2022 15:58:54 +0000
Message-ID: <20220510155853.polwnf5t5angcx2a@skbuf>
References: <20220508185313.2222956-1-colin.foster@in-advantage.com>
 <20220508185313.2222956-9-colin.foster@in-advantage.com>
In-Reply-To: <20220508185313.2222956-9-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d60042d8-57f5-493f-6b77-08da329dfbca
x-ms-traffictypediagnostic: AM0PR04MB4914:EE_
x-microsoft-antispam-prvs: <AM0PR04MB491454CF57EA8E566E82C860E0C99@AM0PR04MB4914.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jGgf6xQtvUQPrXe0DZTGrQOmmwfpfIjdS2KUzkG7yATKZzaimIwLTsB4cPqVNsh7CdmRj+DqAmM1cwfNhJef4Me8Nt52/cWY18oovMdCb2Cgnq7D1Wkw7ebbuN4XHJrGEQt/JRwulKyRpCRP1JSb2aEQqDdv5QEEqN1LovGXw2MKnwGfWA4HYKPHFM75zynFHScxVQUWDyWTxYgVAv4FxjBft812huQ+z3EioQRHllCCf0rsKOU0k+yBVsVK/Ft0e2F+iLZ/2oIJfAxitfCKYXVJ/AgX6ScfbRq0yFDitvfTALnc5MOOjnUnZ/SGihtTv7WN2kABr6mtIQM9w3yWNnXK1oOfprI4CDtoZuV0bO/7h/ZGfeAGLZ9814Vmmh8bS/ZumfQuh7RwExfA2pktp0uOL0tkZ5oJhDzVfkxPYzio2H1KNQ/x8miSu2svGeOiEL3Qo0SrfxtDCZYj9O8L9bU1jmNo3XlKCK5b2n/CMUfe/xppMPhE63zjFKlVHTfRMezBsIfv15CRzUiwPC4g5v4FW0/vUr60/1u77MXcG/1f5qEdluVxBym1+8vRM+5cVSwRlLLkZ59CgXY2cjGfCpcml+m0L1YpWZ5JFWZXF29v0pXhlLSUfniPkVK/wT8O7gL6YexlhAXcYPvgkiOHdjGY+kXZeLLJuyeJVRc6Jd/VOVy0mxq95OxGQk6SRw05Sq3opbS+0DNkZEnD8XWvFw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(6512007)(9686003)(33716001)(38100700002)(38070700005)(2906002)(1076003)(91956017)(6506007)(71200400001)(86362001)(7416002)(44832011)(5660300002)(6916009)(26005)(66556008)(186003)(76116006)(8676002)(66476007)(66446008)(4326008)(66946007)(316002)(6486002)(64756008)(508600001)(122000001)(54906003)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2UPwsKWBXeMcA/aM8esaznTv47Y10gKqXeT7EyY0XT7SYbepJd9/ik/xsEcu?=
 =?us-ascii?Q?5OOqoyc3EZ6JvvcvEA3vg+BIBnb4m8xZ/Bag6TbstZpa8Fftml/xRJ6eHTGP?=
 =?us-ascii?Q?0ox8xk2I1kI45wKB44jQCDN+A7BnYJojNodZ7K5lfkgwvlelCQKiWD/iqv38?=
 =?us-ascii?Q?MOU8WaCT/8Bjck0U3G8J20bMEiX2boYVc+bjlYSPUMkEY2vQ/UExQoT3Wu6I?=
 =?us-ascii?Q?YIi1mY3ARM68GDjXp33x++kPBGMSzMFhBAXUPJqxj18Wb54a51qg2RaZB0sK?=
 =?us-ascii?Q?mTHYHxyRuK8li8CGHFcNkBaKXe6wASgamayXcu+hPRqtquciqGPJQxnLWobM?=
 =?us-ascii?Q?nweE6soM6dG2KxKvE3RkRe4HMMvIcR98863dqq0MmgOo6CyIXvN4ZNrzv5ik?=
 =?us-ascii?Q?iqC0tmMWfNm633HwqcTSGnCuXDyuJLNSuAjQIShCpehObY/pBxpCrXVQzhpQ?=
 =?us-ascii?Q?rgC3Ox68CZQUTdcXMtyO/7azLH6qT73fxiuc37AF/M7eCMb5WQdmopx/yUNm?=
 =?us-ascii?Q?uMod/LcuwO0eSeUIOmp6N4HUBgdD8yxs/uStbUYPN5I5XezzqKwkjo4aZ4rk?=
 =?us-ascii?Q?Qoq76/Q1lt1Jlfz4+rFbLB4uFrDEzbI23JLJrGI4TKjpUJEoRUyGGI/bwPiv?=
 =?us-ascii?Q?z0fMk01Djy9cMaNpSLyiLi8z+jBM7DHDlUZoevye/5yvn91+zDnV3/oI7D/c?=
 =?us-ascii?Q?JEFLAinw4djHx5/+CPpa4L+yl1QhG2mlpBn5ge2UWTjjR7jko7PWzKjJX5Hg?=
 =?us-ascii?Q?Sp+MS78CLCPQYBy64ZPXPy/8rvdGVhxg5/zmrJNriW07s4v7f8pSh1AjbHrt?=
 =?us-ascii?Q?kdKgruJgw+BVA7vB7vBGvFtKsYT2ZuF5vgiZELImVjhKt0qGVS8gDdzRPxuM?=
 =?us-ascii?Q?sm/koKbABcNIyEk1nTe32HHJ9rsozeEReSgAsb50zqnW7TYRfPnyjb5dOCts?=
 =?us-ascii?Q?eSFMuWgyi3LLaRqDhnBnMPLTfY/PyX211xEEXAe9Sqv2tR+mdsvsOw6QagYy?=
 =?us-ascii?Q?A+a3S1krXKRnGxkFW5fyd0SUZ3QVaOwbZwrgrshttMcYKB0zi065FEcPJbgz?=
 =?us-ascii?Q?q0XbCQFjfO4bn440rGf8EcgTJw7/dGXJXUvXPb1vle8rj9HWWu9A2fSYOSBg?=
 =?us-ascii?Q?plOGxHZNilgeQY81Li1h1iaK1dakm4CaPY2HEVGQ6eYJtBaQHUI7FSr6bce4?=
 =?us-ascii?Q?jdI8jpthNirNCdx6H1r4mqIPUCM1WWTbkGLREjtmoLZ7ni/vTVFynPmYjAHt?=
 =?us-ascii?Q?DB59M/3D+X4Rep+s+TTM73UVizyDOMBl6oJnSuTZ7L/DoatlT7kDVcN+EPQF?=
 =?us-ascii?Q?XF266oSUUvHjJuIMQ//VXH8zLUrFfdxVvK9hwP3nbUOlDgNvd5de3E104K/r?=
 =?us-ascii?Q?D0gDOFWOQxCzvckl55Mid1xFjdjHGGun2bHdpAsZLkmFaFkAJsdvnZRRvRG5?=
 =?us-ascii?Q?yXoElxJntuMLRwi/UFZmr12AJ7f5w06ec2Y56qrEQuO4JwL9V+ieO4kodRwI?=
 =?us-ascii?Q?So0mrX91WCpj4xZHw28QrvFR7Cl6HAsfb5W+X0ehcX6c1W+nPc2vDT9IFjmK?=
 =?us-ascii?Q?eb8RljifluAF4JUOSWWfvKZ3qrAkB89soJteV5F7pAJsKEGNMNsEH+qJNu+O?=
 =?us-ascii?Q?/H4dHtp1L9zxO/2I6yi8NFUHAGtkv8vuOPEzlcoytP5d5N6V0xo+kuz4g95A?=
 =?us-ascii?Q?vKdRJjqXpLKlX1pbqOBLVpbAZLdEfq6ZMK8Qnad9JYkZuBMN4czpS6ox7Y/2?=
 =?us-ascii?Q?tIEEx7yQSQwtunJC2sAUXEJs/giQoYQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3A9521602073F5459E049F7608246629@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d60042d8-57f5-493f-6b77-08da329dfbca
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2022 15:58:54.1479
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nVbCSILJl5WkAbJr5w00iH2GRrsiRQs7lhbFGejPRSxRYhhq/vQ71yghzGKXMCLEamZz4rOh4wNDcUR2l6q/Xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4914
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 08, 2022 at 11:53:05AM -0700, Colin Foster wrote:
> +static const struct mfd_cell vsc7512_devs[] =3D {
> +	{
> +		.name =3D "ocelot-pinctrl",
> +		.of_compatible =3D "mscc,ocelot-pinctrl",
> +		.num_resources =3D ARRAY_SIZE(vsc7512_pinctrl_resources),
> +		.resources =3D vsc7512_pinctrl_resources,
> +	}, {
> +		.name =3D "ocelot-sgpio",
> +		.of_compatible =3D "mscc,ocelot-sgpio",
> +		.num_resources =3D ARRAY_SIZE(vsc7512_sgpio_resources),
> +		.resources =3D vsc7512_sgpio_resources,
> +	}, {
> +		.name =3D "ocelot-miim0",
> +		.of_compatible =3D "mscc,ocelot-miim",
> +		.num_resources =3D ARRAY_SIZE(vsc7512_miim0_resources),
> +		.resources =3D vsc7512_miim0_resources,

I wonder whether you can differentiate these 2 MFD cells by "use_of_reg"
+ "of_reg".

> +	}, {
> +		.name =3D "ocelot-miim1",
> +		.of_compatible =3D "mscc,ocelot-miim",
> +		.num_resources =3D ARRAY_SIZE(vsc7512_miim1_resources),
> +		.resources =3D vsc7512_miim1_resources,
> +	},
> +};
> +
> +const struct of_device_id ocelot_spi_of_match[] =3D {
> +	{ .compatible =3D "mscc,vsc7512_mfd_spi" },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, ocelot_spi_of_match);

Don't forget to add a struct spi_device_id table for the driver.

> +
> +static struct spi_driver ocelot_spi_driver =3D {
> +	.driver =3D {
> +		.name =3D "ocelot_mfd_spi",
> +		.of_match_table =3D of_match_ptr(ocelot_spi_of_match),
> +	},
> +	.probe =3D ocelot_spi_probe,
> +};
> +module_spi_driver(ocelot_spi_driver);=
