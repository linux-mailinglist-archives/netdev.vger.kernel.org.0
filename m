Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 791CB57CB68
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 15:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234111AbiGUNIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 09:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233857AbiGUNHZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 09:07:25 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2052.outbound.protection.outlook.com [40.107.21.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E50A5DF78;
        Thu, 21 Jul 2022 06:06:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SKslhTc+fzCZDhv58TW1mWdbJfekvQMCuyjBF0qaRCp7wO29vzuZTPWcXM8NQthJO6fXoZyG4xgPNfeaHTKvHE+AABPiCBKhkmlMZKHNFPKqFE7J1T7/kCepoZXa+gZMEkNbomqIs4OWhjISjDjR5MmOit0d2U1vV1tYe2sYN8BcIxnTOYEHHnQBFsKxJ1qsuMmivzgIhm/9vvexo1EkRmk9BX6eiSaRYclfn8cEWXoqe/cJa0brFkZ4BHnwLYU7/zFi5Vo4RXcBVsIltRnPxHds3AQnmstYgHRnfuZrEWroqAlhLMsF8rSObv4SvXqCA3DX+vHnIQS3F7bdGdIUgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wrut2FYt3ZfWuuaBSbS0azE8jzBP1cDsjqAojOJSUxg=;
 b=h1H6THCYCJl5PHpWucEShpn4l5kz2MPv76LRg8mhNhTKxlexOGEmqRcZHad6GLQpemuASfMXo6xMfLqpZMCz+9MBJSydlUTEDCa0ExMpqFfESLMVWPIWdKhmwO6xC2Piccs/YsXF3dlRuw48gvzJMcDVDp894ozNXA5MNpsGKMyYPoYxef54gQau7hf8rQovntkwrRTG25HKLbXHsHeuy3YY+kW/G5AftCUFHHmrEMYbg7MzkT127xvR3/E28lTVTBq9NmTc+L3Mjg5zKCozOLUBIDQ1ZnS49kcp41gwlYedlWgnpNy4Gofqbc2c4m/PSRUYAcMxdYLBwQ4InkAl5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wrut2FYt3ZfWuuaBSbS0azE8jzBP1cDsjqAojOJSUxg=;
 b=K49fsk7U91j4ji4mDEGXOAFwRdp31hQvhglv4zHztVf6P0sGOISrO+9Hoj/nvjsZuyp0CeeIgBWNSrQDYykOOuyjCANOq6ZL+Bur7ezvmp8tZHhHa2sYbk6Rd7lHVUKjN6l04Wf6EbFm6pw0rtH3K6g+vqqCSNnDn3PoGf1JZw0=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by VI1PR0401MB2656.eurprd04.prod.outlook.com (2603:10a6:800:56::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 21 Jul
 2022 13:06:43 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::1df3:3463:6004:6e27]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::1df3:3463:6004:6e27%4]) with mapi id 15.20.5458.018; Thu, 21 Jul 2022
 13:06:43 +0000
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
        Sean Anderson <sean.anderson@seco.com>
Subject: RE: [PATCH net-next v3 33/47] net: fman: Clean up error handling
Thread-Topic: [PATCH net-next v3 33/47] net: fman: Clean up error handling
Thread-Index: AQHYmJcMtrfSypnu4kK41rncT5KaHK2I1DBA
Date:   Thu, 21 Jul 2022 13:06:43 +0000
Message-ID: <VI1PR04MB5807209C2DCA220E794C0DCCF2919@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-34-sean.anderson@seco.com>
In-Reply-To: <20220715215954.1449214-34-sean.anderson@seco.com>
Accept-Language: en-GB, ro-RO, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8fe42380-0da6-421b-5c46-08da6b19dbe9
x-ms-traffictypediagnostic: VI1PR0401MB2656:EE_
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: S8GSq3DCPnc13lsWPKR95g3Y/ty2s6d99mLEtQ1fKmHmUiNQ7uP2eDOqqqhq2DS25RDt8AQ2NoYGxzf/R/UvplgovbCHUcBZ448gSwGSzLej5xLOU8vXK3YPRksR+hnIAH/atzsZfIsZkoBjItel8d8TbBo1K0vQHfNFj1Ny4HoHezZZVLRuhMsIHEubKcwTtFuVWBXrQbMU/6x8Jn5TMF1MzlOIDAJWsnYeljFFQK6EL2TmN2/fikLQCuigN3OZpEGgP+z8TBsIRaeQ6E5SltcRxDWRimYq7N6oK+i/jc3ezv8oSI2DYIYvgUwavuy7pRATOFsqYcPSi+tG/mIXy5xLXPybemn8gibOgBjYCsgQleQcL+BbKy6Au75F6IePJtNHwfa8FxiOHk/8LOJKxBuiE1hDazYo6TgINu+W98K5P4ajvHNiJr+/2woAVWzUh93aM8jGLVjyxoIXki90t8daD5auXiW8VXpvDpNMBERZywVpOd77WS6ObF56BZUn9XoFdiHl3uPeLq3HqVbkFjAwJ9JekUii50YWar0K5ZIrSpT+X3BW/9C/T/H4qtxwJxiHX+9RjbFXKLvNxzeWVDmQWm/RokiC7BCJY3udVjS9zPIn9fKM3XFkZ/uHgYo/AP9nzvxcuha5//9ol7OGnp9lgW7YOsaxSOPfSLoD2cSiAB53i8frvNvs1WHevpDpoQnTQPyGlq2UhlJ8dd5tbv29p563BlpFTfgjalN0b6Lcxf8nmaHLzAPOzoHG8Gahnvg2y/Dm4cCbjBofms6rlWhft0LE+Ttf3KAt8uG6UjEksIhcsWD5sXTw+EdOKREO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(366004)(396003)(39860400002)(136003)(376002)(186003)(83380400001)(52536014)(2906002)(71200400001)(41300700001)(26005)(6506007)(4744005)(7696005)(478600001)(53546011)(55236004)(9686003)(55016003)(33656002)(38070700005)(38100700002)(66476007)(66446008)(86362001)(110136005)(316002)(8936002)(64756008)(5660300002)(122000001)(4326008)(76116006)(66946007)(8676002)(66556008)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?GOZLLldCL6M/wAZI57xQGDjZjDEvgVXL/DYLRMdDd8kNFTEeUAxUeKJIMiaQ?=
 =?us-ascii?Q?7LvZELr2X0jRYQn5St3PYe1TAE/dF0A8pbC4U7uUCoj9oR1WaUqcsbMaFKlH?=
 =?us-ascii?Q?IeubSlGuQ4lCgP2kDe4YRGqGLPNRbGRZ1nmL1aD+RosK6dKwAG5qsH8xfTPd?=
 =?us-ascii?Q?K9USWBjMHlRREOrB3pfx/CBtTKqiVn+NnMvujtdId1f0SlQe9i8ovZeHmETs?=
 =?us-ascii?Q?cCGLqQda6Te3TRD+S+oORFGu17m3Axc7+hnZiEOrcpdo+9IANMmeEnRy4m57?=
 =?us-ascii?Q?mAnJydItlAQV+qCuoj2lQHkreGcz6OWfqrr3c62IaeDKwJSzJY+4XR//05Uv?=
 =?us-ascii?Q?MImwIJ+LU7aDitIRkzSlmi9I2QJupJZ9PnSykQhzxGt0kBW2z8LURgR2uggK?=
 =?us-ascii?Q?dHzyCW8gg4bOZnu8NMQ7Gt6N2i/CtcgMcTH1WjCL69i2cc3kjB/DjDut19yX?=
 =?us-ascii?Q?X2LscSfVSbzC/8RG6gu2ciY3iCFLWQomrDs2/CJMVZelF8wwmH5PmwO7dcxJ?=
 =?us-ascii?Q?jeAVVM0tE/kp9HsFlDs73biJE7inlJRUOkMAzUxGG8feYECGBOIITh3wOt98?=
 =?us-ascii?Q?zqPTBZlFaYC5b6B9s73Mxre3brRuMn5EkVOWB4554goj8+kKCDJAg/afvaLU?=
 =?us-ascii?Q?ilLUn1vk9vh5AAn61bGUARFYw7bClX99OG/JkmYoBPnFMz3PIAY808b8TiLY?=
 =?us-ascii?Q?r0pouLF7i4RC734fpJJiXZYIlUxONjsFXNMXn7ZftPvOKe5LTU07G5G5AlEE?=
 =?us-ascii?Q?OXN+fYdVifkpXCkZHRmTRxEa4OhrX79bBDjA8900DVA7B0INXdIiqrYpQewk?=
 =?us-ascii?Q?/x1s4k+Bfpv7hLoiKGkEvpzkNf5LGL+e+yz9TwAd+FefZFxITsKQ4fEAyL75?=
 =?us-ascii?Q?jSy5NTtcRI3ahCJjsnbr3qtfyRuiFlHfjqEC958Geygay3RiP5js5hgcEnt5?=
 =?us-ascii?Q?9lgC6KV4mjSg02SuID02UnBHWe92gPrNjATw3o0UB7VHTKbUNGJ0rhcPT5am?=
 =?us-ascii?Q?QvRKAPObf17Cgb6YAGwjPnk9l7XISVzAEe75x9FRPyE2EfXMt6FFl0Wa/n1I?=
 =?us-ascii?Q?qkizR+zIYIU4rJhCbAV7/BXD5JmmIedYUfr5BR2XuZuQbfu+V5H+bq9jnoe4?=
 =?us-ascii?Q?6KgQQgti0foFqrW+2Vs7fkevgJD9iN6D75F2x+kPljkD4n/JpNu1YIjfaYRc?=
 =?us-ascii?Q?tYyKA6t9eOFNSp6beiqbmyVtsr/5mLW7hrvCRdi5DFRqEYUXD2n7Q00C0H78?=
 =?us-ascii?Q?D2MFxyFB+q7lO+72G/WE54hkHSS+TKxqVH+mcVBU7/dtgtEpkn4tMn9QnaoQ?=
 =?us-ascii?Q?6O8RFT55SD+Amib7l/eOVnfMpUoaECYa1fRRDI0xuwXtAsXCbU+cfSZESfMI?=
 =?us-ascii?Q?q1tGKfOH07pBWnL28dX2WwBTJZPUzYOkW80pT2nZUPvFnZ+YNdujskMWuIGx?=
 =?us-ascii?Q?0bWAXbt4/BXY4hB0SIDhMTqReWdCKNXaNKKhKDnyhmhQ8vbTviixTs8ehwRa?=
 =?us-ascii?Q?iArB0y8CrdZwBi+/yuXkT+nn0c/M4GbOtti+lQqrF8VlIK5hEVdwNpswKdfj?=
 =?us-ascii?Q?ubk6uhpSYwT03kRIjQe7PfwBJbxN7F2g/1j/2C6M?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fe42380-0da6-421b-5c46-08da6b19dbe9
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2022 13:06:43.3736
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3cLT0UfPV5rd8Q3WQYm100nG6BIE5epemz8LLzQyCcccILYG6+rUsZZc4M2BHGzxoI+FU/xei4cdBrnAEXQ67w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2656
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
> <sean.anderson@seco.com>
> Subject: [PATCH net-next v3 33/47] net: fman: Clean up error handling
>=20
> This removes the _return label, since something like
>=20
> 	err =3D -EFOO;
> 	goto _return;
>=20
> can be replaced by the briefer
>=20
> 	return -EFOO;
>=20
> Additionally, this skips going to _return_of_node_put when dev_node has
> already been put (preventing a double put).
>=20
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>

Acked-by: Camelia Groza <camelia.groza@nxp.com>
