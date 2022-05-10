Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D81F522108
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 18:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347300AbiEJQW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 12:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347274AbiEJQWw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 12:22:52 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2048.outbound.protection.outlook.com [40.107.21.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 269332A1534;
        Tue, 10 May 2022 09:18:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=So9t0P6BtPrtDmkxehwjF2t1WUpyjAYaTWurZDInMCFwQPoWS/7LZW2C2FD7GP4LwmfS9VG44iAnmn0EZrxPVIsY7dMH3Q2Dcsbsh8PMqvqHG3KQdqz1IueCHrCm/tGSUXlnqDuG7RcvL0WVkp+y7kFg007tRWCo/+mjIuzHDuYoMnSQXEhzaIkXEOTePWcLBq10SpL/YqGNV7ZfehitB5CUBIQkgpZBWy3M8KA+Fw0jW5GIhfzb7IZnBn+DTNV+IUDClfGFqf41kz9SlWaD7KqDvSAdr6NuZo8coAF65HkGJ0o84msKTdFctjTarrkwOVQyVGKDgddf6wMqECyM+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/5u1BKGDoMQL/E3j/Kj/+LQUr7r9QXtwp/niSqc3AJI=;
 b=NfbHVBhZpYE1rXD8u7NA+uTuiINCDjS5FmWBhnHUxLn81Fr7lJbo+SaG4gNR2po+t7HunshOMX+LQILugeVAO4r0G6G1OYkpjp9RrH/OzN1IyLgqajcBJbUgBKrEgcG17VxfW+1rwzwe/c1Upf8GxVIPbI2rC5ZdLlBrZ1y45oejKvuizSFcMpg2Zs0SDWDrFaEs31mcImtnAQB+J8mRs3DiRiyQoFx3aB1mAf6efqayr1huomxiKqydHeWx1KeBxKi33EsHmDWydBDGJsLSBeHHj7Wor5F1/iO8yidqNe2DEqlpcvmXHJtKvlMO2vCkvevBipMuIfqwGqHWI0v1OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/5u1BKGDoMQL/E3j/Kj/+LQUr7r9QXtwp/niSqc3AJI=;
 b=UfzvTpiZM9M0tpN0P90IwNePnFtB3VfwuSO8weBsU1aOEya5PrZPWfbQr2tktylARI0V3YvdSeB2VHE/ICM6WWW6/vljIB/zp2nLkYlPIN7E5aFD0XJrnvFpsxivyD8v7zqkXCC1YnIAtzbmbeMlgw5UgcCpn5/wg2XEErTNzq0=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8919.eurprd04.prod.outlook.com (2603:10a6:10:2e2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Tue, 10 May
 2022 16:18:50 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 16:18:50 +0000
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
Thread-Index: AQHYYwzpO7u0NDHwdU2qDb+lARh+Pa0WyfwAgACjXwCAAN/OgA==
Date:   Tue, 10 May 2022 16:18:50 +0000
Message-ID: <20220510161849.w5kbicqgbxnodfwt@skbuf>
References: <20220508185313.2222956-1-colin.foster@in-advantage.com>
 <20220509171304.hfh5rbynt4qtr6m4@skbuf> <20220510025748.GA2316428@euler>
In-Reply-To: <20220510025748.GA2316428@euler>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: caaf6d73-88ff-4e12-8312-08da32a0c4c7
x-ms-traffictypediagnostic: DU2PR04MB8919:EE_
x-microsoft-antispam-prvs: <DU2PR04MB89193281CB2709096728254DE0C99@DU2PR04MB8919.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kCckJRzHYyFE/WZmgQMkj/DGSvHFrQ4xrzX9pD0rpsSWil+cTsVeHJ4aTAZB+i5FoynjtwOnEUk66k0Z7kM0k4MMtbYPA37t9kYA5UcV95Q+FlQP/eKLrdwqCrXom1EtmID6pQW6jz2ti7vzcpM1vUsol+ZU+1qiPVYuX6y3/M1taPJdNYJ0wcc0D8lutneiLD01JW5G+Pg64DtHfYKlK1mX0/ZG/wFXN46bVOBHaL/x3YnMTutsR3qxDGJsxgHhfK4sryX5+xoqBbr07sy8fBdiDMv3BOBryx4Q9l1OxUCLfXbjNPKFWVZ5HAuT9y+ZTMabUVlcRZOGkM94Ryrfhq5L31NCqSLDUP/5d9ISD5uzh2DcGSgOqHosTWpO5rnQ7Z6vaT+AVTinOoloMDP35cDThDScCrDCwBnbYHD8QAjVljHfXoI50jrUcn/Mmo8BQ6YPdlauyejPbFFAHjfgm03k1qf0Sb16dEuZ8M989b6j2dAB2bVKEpTcyDVf5iMHmJlpP1hRiFVf2l5TGI/vNnS1nc+DzqU9AOtO8gYUr3g1JueTSy5hOjqbh7lNH954hZG0AXAYvE+yhtY/WpQNI2GCVDHfhfchztHzGMU/FneoNzsCVt/a6c6u54CJGCVe9xF+X9bhh7Sdn7a+xsh0/R5Y7ZOs/VW7yy9T6gThQIRqvRPinZBeGutW9iWEIukSLxpPmhPvYUG2BerVlb/xYA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(6506007)(83380400001)(26005)(44832011)(71200400001)(7416002)(6512007)(9686003)(66556008)(33716001)(5660300002)(186003)(1076003)(2906002)(38070700005)(38100700002)(91956017)(8936002)(316002)(508600001)(76116006)(6486002)(122000001)(66476007)(64756008)(8676002)(4326008)(66946007)(66446008)(86362001)(54906003)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?sPsLgttjGu5/PAJfKztLjs0JAP7rg04LVGDltS7xBBDrdxf5lZhTraKmGssm?=
 =?us-ascii?Q?RCLyL6SSnxL8FgsyBbguOEjqOL5Gy7IRqc+Sn/OypcnCCOhiGzS1G9dl1SG3?=
 =?us-ascii?Q?fqN/BqR0fgNxpUjZE+ys95ws0xmaIRXIvrdue2WhpLNGCG6h6w1cBqcYypJP?=
 =?us-ascii?Q?WfvPXB7dkGSOwx6RLopygVUif4r+W1p7Fcjv2V1sKmoNNrqP3n0EscJ+xQSD?=
 =?us-ascii?Q?C7Nw8DTlpcG5ewMt4OTKtoO4LwYyKx2ol90M4kMjMsxEv0lGzpsSpf1XGYMc?=
 =?us-ascii?Q?GRGHC959zue4TBVc3Ddik/bmZKkeqr6AOV084bKdiU/8UiNr6PqkxHneSDBk?=
 =?us-ascii?Q?krcDUuz7YAJspJjm3rEb4EZczrNoN5oJTSDQV5O2x6pgtilkZuwLkqI0Ch/r?=
 =?us-ascii?Q?6mPKN23VSkvMZSg0lqI8n1N3nHsPscL4Z2ai2qQjcxSTVKRxdp/+oRBOtcw6?=
 =?us-ascii?Q?P/aBZ/WQW1F14PKapCqlcxY9eZYCMCj44xD2/z5lVj0KJC6cfxhnP+pcWjE2?=
 =?us-ascii?Q?KySgXSoHdZhAhUP2dFVnZUMyCK/Tx0IVaTM6c1xj1XRGQZs9LlUn6ykQRKJg?=
 =?us-ascii?Q?KbITORNB0YdnF5Wh8TzFGu1dryRqB2PWjCwvwe1w4o6yY6yJbWzaRdatyU+0?=
 =?us-ascii?Q?4B+d6AMfSaHbopfXhFEPCc0UpKPevbJIKTYddRJUC/jTA46cLB0RCrtyKQFp?=
 =?us-ascii?Q?jLAOtxX/d6FSpvdBNp4F76b+fj6pd/ZgcsheeVWK5a8nBkS8YuYqG3G/37Xo?=
 =?us-ascii?Q?mBO+iPnpjL0L51BiA8ifEdWv+qX1KDreaLLZBBzQa6e0wPiAPJ4IS6cOoJKn?=
 =?us-ascii?Q?6YtokGpfNsJC9jjNyOxheo0fgdbMEujUOLVeLUQAB/9j4bAvrx0GrK5BV9Qm?=
 =?us-ascii?Q?3gJ8h6LsH75zvET9sIxzasKdi6msrRII7qnqco02PoN/DjZlVwmIakMkGIRD?=
 =?us-ascii?Q?2zcSND0tZYHKIP5tWV4vuEPMmy4AHF7KojHgqjBcK6ouXYc/U72Q4hJozZN+?=
 =?us-ascii?Q?I4w3gIJU/75kikoCTUt6OoIffHfxWKzPwunHPCTnmYCw3QYTZOELEGQNpbwo?=
 =?us-ascii?Q?aODGnMutaHZW76oxuAJoGSXj1CHaSLJe1uVFjluqvv86d0L/aomFabL4om5o?=
 =?us-ascii?Q?TMx/F153pyikIYy1JYk/hlYx7CEIwivVdjGmWclgeWnavcm/mkGXjp5ITJPR?=
 =?us-ascii?Q?/FQtvoSfov9WMY6O4HNpAiEbtac/sBeUjw5yb0V9fkfrCxo5R/i7XlzHOM1b?=
 =?us-ascii?Q?1bSrmJoT20JbakfPDZXEj7MQ6xJONsY7OI6ABmTD3Af3T12VkJmNXZGpfJlK?=
 =?us-ascii?Q?ndVRShicr3Sq03KC/Q17tEHbY4tgqrLRRQG/8ukjc9kIolmC2IbhZaBho4kE?=
 =?us-ascii?Q?HhelH1PCMrfzrt0BPKcxQifpaXe3koB8sbiO0BpMmUiXmOp9K5o6v3+fniIq?=
 =?us-ascii?Q?bTSPdOdP3ui78WjEOOG04qGphIy0RZ4NXxBHmEDXIkIqBGLMA5mR5L3TqkKd?=
 =?us-ascii?Q?v5P/oeUWyAZnTBZrIDQbTzc3gktO5MUwu98gFq2HKIMbR7pImgqJmSwoNAV9?=
 =?us-ascii?Q?9Ae875u8E7ER7YSS0u+H7UmQrPRdfBwzdwMVinUxxEPKKEdjx9GlEYLXQD56?=
 =?us-ascii?Q?+CTDIbGjTNwxj9yPDcqx6bJ7Meruz/nYbnbGl0THy1XxjJAhZmHn0L7JC4N6?=
 =?us-ascii?Q?2WuQ1LECbt/Zm2Ao8/t1+Av03uK1VHsRC/+1P+WsAVHsUWV1J5Fk13mN0Ma3?=
 =?us-ascii?Q?OixzJ7FzyYY0Ppri40QYuZXoXwIWOCk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F934BB8801111D46881D47FF8FAC29BA@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: caaf6d73-88ff-4e12-8312-08da32a0c4c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2022 16:18:50.3755
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pJ7eHODY1JlRz3HIPy9H4IzV/cHvK4UkdNtoTNaZnsJx/+MuPyrHwVS7J+Bu1Q/X076cZ0pQMffj+QRHUyZZNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8919
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 09, 2022 at 07:57:48PM -0700, Colin Foster wrote:
> On Mon, May 09, 2022 at 05:13:05PM +0000, Vladimir Oltean wrote:
> > Hi Colin,
> >=20
> > On Sun, May 08, 2022 at 11:52:57AM -0700, Colin Foster wrote:
> >=20
> > Why does this get printed, if you put a dump_stack() in of_dma_configur=
e_id()?
>=20
> Below. I'm one of the only users of IORESOURCE_REG, from what I can
> tell... Not sure if that's any consolation.
>=20
> >=20
> > > [    2.835718] pinctrl-ocelot ocelot-pinctrl.0.auto: invalid resource
> > > [    2.842717] gpiochip_find_base: found new base at 2026
> > > [    2.842774] gpio gpiochip4: (ocelot-gpio): created GPIO range 0->2=
1 =3D=3D> ocelot-pinctrl.0.auto PIN 0->21
> > > [    2.845693] gpio gpiochip4: (ocelot-gpio): added GPIO chardev (254=
:4)
> > > [    2.845828] gpio gpiochip4: registered GPIOs 2026 to 2047 on ocelo=
t-gpio
> > > [    2.845855] pinctrl-ocelot ocelot-pinctrl.0.auto: driver registere=
d
> > > [    2.855925] pinctrl-microchip-sgpio ocelot-sgpio.1.auto: DMA mask =
not set
> > > [    2.863089] pinctrl-microchip-sgpio ocelot-sgpio.1.auto: invalid r=
esource
> > > [    2.870801] gpiochip_find_base: found new base at 1962
> > > [    2.871528] gpio_stub_drv gpiochip5: (ocelot-sgpio.1.auto-input): =
added GPIO chardev (254:5)
> > > [    2.871666] gpio_stub_drv gpiochip5: registered GPIOs 1962 to 2025=
 on ocelot-sgpio.1.auto-input
> > > [    2.872364] gpiochip_find_base: found new base at 1898
> > > [    2.873244] gpio_stub_drv gpiochip6: (ocelot-sgpio.1.auto-output):=
 added GPIO chardev (254:6)
> > > [    2.873354] gpio_stub_drv gpiochip6: registered GPIOs 1898 to 1961=
 on ocelot-sgpio.1.auto-output
> > > [    2.881148] mscc-miim ocelot-miim0.2.auto: DMA mask not set
>=20
> [   16.699517] CPU: 0 PID: 7 Comm: kworker/u2:0 Not tainted 5.18.0-rc5-01=
315-g0a0ea78e3a79-dirty #632
> [   16.708574] Hardware name: Generic AM33XX (Flattened Device Tree)
> [   16.714704] Workqueue: events_unbound deferred_probe_work_func
> [   16.720608] Backtrace:=20
> [   16.755335]  of_dma_configure_id from platform_dma_configure+0x2c/0x38
> [   16.772320]  platform_dma_configure from really_probe+0x78/0x298
>=20
> platform_dma_configure gets called because...
>=20
> [   16.778360]  really_probe from __driver_probe_device+0x94/0xf4
> [   16.789913]  __driver_probe_device from driver_probe_device+0x44/0xe0
> [   16.799980]  driver_probe_device from __device_attach_driver+0x9c/0xc4
> [   16.814326]  __device_attach_driver from bus_for_each_drv+0x94/0xe4
> [   16.826319]  bus_for_each_drv from __device_attach+0x104/0x170
> [   16.836827]  __device_attach from device_initial_probe+0x1c/0x20
> [   16.847507]  device_initial_probe from bus_probe_device+0x94/0x9c
> [   16.853637]  bus_probe_device from device_add+0x3ec/0x8b4
> [   16.864756]  device_add from platform_device_add+0x100/0x210
> [   16.880864]  platform_device_add from mfd_add_devices+0x308/0x62c
>=20
> platform_device_add sets up pdev->bus =3D &platform_bus_type;

This part is clear. MFD cells are platform devices which have an
of_node, so platform_dma_configure() calls of_dma_configure_id().

> That assignment looks to date back to the before times... Now you have
> me curious. And a little scared :-)
>=20
> [   16.898465]  mfd_add_devices from devm_mfd_add_devices+0x80/0xc0
> [   16.914924]  devm_mfd_add_devices from ocelot_core_init+0x40/0x6c
> [   16.927790]  ocelot_core_init from ocelot_spi_probe+0xf4/0x188
> [   16.937251]  ocelot_spi_probe from spi_probe+0x94/0xb8
> [   16.948118]  spi_probe from really_probe+0x110/0x298
> [   16.958800]  really_probe from __driver_probe_device+0x94/0xf4
> [   16.970354]  __driver_probe_device from driver_probe_device+0x44/0xe0
> [   16.980422]  driver_probe_device from __device_attach_driver+0x9c/0xc4
> [   16.994768]  __device_attach_driver from bus_for_each_drv+0x94/0xe4
> [   17.006762]  bus_for_each_drv from __device_attach+0x104/0x170
> [   17.017269]  __device_attach from device_initial_probe+0x1c/0x20
> [   17.027948]  device_initial_probe from bus_probe_device+0x94/0x9c
> [   17.034077]  bus_probe_device from device_add+0x3ec/0x8b4
> [   17.045197]  device_add from __spi_add_device+0x7c/0x10c
> [   17.060959]  __spi_add_device from spi_add_device+0x48/0x78
> [   17.072252]  spi_add_device from of_register_spi_device+0x258/0x390
> [   17.082147]  of_register_spi_device from spi_register_controller+0x26c=
/0x6d8
> [   17.095970]  spi_register_controller from devm_spi_register_controller=
+0x24/0x60
> [   17.113822]  devm_spi_register_controller from omap2_mcspi_probe+0x4c8=
/0x574
> [   17.126608]  omap2_mcspi_probe from platform_probe+0x6c/0xc8
> [   17.142717]  platform_probe from really_probe+0x110/0x298
> [   17.153835]  really_probe from __driver_probe_device+0x94/0xf4
> [   17.165387]  __driver_probe_device from driver_probe_device+0x44/0xe0
> [   17.175455]  driver_probe_device from __device_attach_driver+0x9c/0xc4
> [   17.189800]  __device_attach_driver from bus_for_each_drv+0x94/0xe4
> [   17.201792]  bus_for_each_drv from __device_attach+0x104/0x170
> [   17.212299]  __device_attach from device_initial_probe+0x1c/0x20
> [   17.222979]  device_initial_probe from bus_probe_device+0x94/0x9c
> [   17.229109]  bus_probe_device from deferred_probe_work_func+0x8c/0xb8
> [   17.241277]  deferred_probe_work_func from process_one_work+0x1e0/0x53=
c
> [   17.255728]  process_one_work from worker_thread+0x238/0x4fc
> [   17.271836]  worker_thread from kthread+0x108/0x138
> [   17.328184] mscc-miim ocelot-miim0.2.auto: DMA mask not set

Unfortunately I don't have any hardware to test, but I think what
happens is:

mfd_add_device()
{
	calls platform_device_alloc()
		calls setup_pdev_dma_masks()
			sets up the default pdev->dev.dma_mask pointer

	overwrites pdev->dev.dma_mask with parent->dma_mask;
	// your parent->dma_mask is NULL

	calls platform_device_add()
		...
		calls of_dma_configure_id
			complains that pdev->dev.dma_mask is NULL (i.e.
			the bus hasn't bothered setting up a default DMA
			mask, which in fact it did)
}

I don't have enough background regarding the justification for commit
b018e1361bad ("mfd: core: Copy DMA mask and params from parent"), but it
might be detrimential in some cases?

The warning is printed since the slightly unrelated commit 4d8bde883bfb
("OF: Don't set default coherent DMA mask").=
