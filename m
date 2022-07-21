Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C475057CB5B
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 15:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233861AbiGUNGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 09:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233992AbiGUNGK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 09:06:10 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2069.outbound.protection.outlook.com [40.107.22.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C053931E;
        Thu, 21 Jul 2022 06:05:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C+DGHvzMSliA/5gaIW2D09c+0twzpsHPgRj8y0D4sVJqVyt97S+jGdVEX5rkj2Xaok7caDoPfsYQXhqBcimNQWvc4or5xNFghr7cR3a9oPn1rd5x7Ca31xKhz+WUaVZ0mzqTqZrYRdom/oNKnWSxuasy/1X5AsTt5GpDpyDIuahV2lxfzInGXE1Stucx8vgYyNkJYUH7l4HVK/fA5J/rdQ0P6tEVk+ccoGFKgpHJDn/6HPtouCqIXcZtp8xvVuaIxFwyFIHOeQw8SWMmBm0M1A9fCRta+gmT94B7N9WJpNqFu6MWhZ57OVZE3d56Ps6Qw6+OIyvkorz3mp11taEmrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n1oCbCAygMmXNdEhlY5r+e6jIxRoWFes1krUHitRvJo=;
 b=UuuPoTigeaiSk7ALhsYAFk3hXn5woslXL7esDitjmCRGgvTO0xC9HQPYOP01m3/drcB7oF7Tf4AXXRRbC5W9NtSWqwKbtBABQtGCvIBVObyepMqn1sIoabRa/iAKxraChvvU/HF0XjI77UrLrLYuCoywkMrv7jm2CaNruWnrOx84EdDnVlpKiF5aPRx/jFXUicSvTaUmcz/xWjr5pTvZSimEkm8jLOqijSbzizglk/BHgJo9XnL6+tUwgRd45AcrvtI6pfGnrSa2gWOB5FMxmhcEM9dctHLJd1XYTqR2vwkiAu4+wx+6xJXdMzIPvUI7RysfJPuVlOBNX2SlYeLT8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n1oCbCAygMmXNdEhlY5r+e6jIxRoWFes1krUHitRvJo=;
 b=SrTX2BLHh2YJV/43H3ueov69GCJ6X5NdZfVZWWhkadV5fR9QvC/LgYcJqvUszB3Rkmz/Vv3OEuVEF4sP49NqZ3Obdqbgrw9aLGPgqpfpAnfvSgrwg6JkYJq87jcteIt6bww7VXPz50MALEvqhx4iQVRowRnJ7Nk9oy+hCPk+d98=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by VI1PR0401MB2560.eurprd04.prod.outlook.com (2603:10a6:800:58::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Thu, 21 Jul
 2022 13:05:07 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::1df3:3463:6004:6e27]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::1df3:3463:6004:6e27%4]) with mapi id 15.20.5458.018; Thu, 21 Jul 2022
 13:05:07 +0000
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
Subject: RE: [PATCH net-next v3 30/47] net: fman: Pass params directly to mac
 init
Thread-Topic: [PATCH net-next v3 30/47] net: fman: Pass params directly to mac
 init
Thread-Index: AQHYmJcKUSctAc9AlUO0jcQqZUZy9a2I070Q
Date:   Thu, 21 Jul 2022 13:05:07 +0000
Message-ID: <VI1PR04MB5807CCAABB3CDAC7622AB753F2919@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-31-sean.anderson@seco.com>
In-Reply-To: <20220715215954.1449214-31-sean.anderson@seco.com>
Accept-Language: en-GB, ro-RO, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0b362b25-c87d-4e6c-9725-08da6b19a2c2
x-ms-traffictypediagnostic: VI1PR0401MB2560:EE_
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AZDT3BitAVUzBrCPgcKUUFcMmXvfDY82tbqdtw86asZRXmFfiJWKwzstSMDf71JQbbCS4AKpXpGI5ssmfqRRFaCgUcgh7/DOxW1YKQQItBDrpSXz3DHsuUWmEP0oiKB3Wd7yXVsWiYfb4Uv/0luPEnvIlEkOfxkqK6pFEDAh7LgywN8N/8/xhpiNx0tUl02IHz8ODEnNQ84gLxBfxYtPXla7hQMEHMFd2tlZRYW9ugECrue4jEYBk7+Q6syVU+hGHN5RtLCt79hWFsildfynrbDTC2ifyP/W3KLDaxBGnz6/zug3QlyiSPO7miS1jyN7epI8m+EIMzkgKQiGcizAEZJ1DAh7Z++M/3+LsWWhr6FVF+fhLCY9ZklcsPMvMICYLY5dPjxgq63jF549c9byv0vIu4T4lpSxUSOQF4Rux/5eBJtnPHTvac4IAhJ74LP4XyWWcHs0Mru/bJ920eL4wx1WW48ts0LWB7ce3JoPBEcDu9I9LOg5CstEdEPIt+LvZ2o3AIeTYy9HrZjlF23j0vqg39dnF2sKOK1yZUJjYta5jjIx43KytfHlCvJ9+zZadIWPU/pds7zo0KUlSnFgUsFrP/QTgUQKe36NTbRnsp1h9moQweH2VI11cGQ0R/xbX7hNeBoJEMOMoa3EnIGRa4l6wzAQWkjwA3eUzC/KaJ+jtn/hGCGaOPClOE2RRdCk/aXyvUJnI+ZGI/o6WElao0BBINu1hAYnUdBoXZtJ/dG3ipN7ZokDMEwZJ3jyxu3QhOy36e13WO70R0TF1Jyd+dzHID6/RIYrt5gmD3+bFtw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(366004)(396003)(136003)(346002)(33656002)(4326008)(66946007)(76116006)(66446008)(52536014)(66476007)(41300700001)(2906002)(55016003)(8936002)(122000001)(8676002)(316002)(4744005)(66556008)(64756008)(71200400001)(478600001)(5660300002)(186003)(110136005)(6506007)(38100700002)(53546011)(83380400001)(54906003)(86362001)(26005)(9686003)(7696005)(38070700005)(55236004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HvCECO5H9Iz5lAo5W8zlYz/bauvPmmjhErvlBBvoH2jSblnQparSjnxTUiYk?=
 =?us-ascii?Q?v3Wp3cRHUXIP1jUFy76F0pLQLfkVcajiLGz6tZrSR7gjKM/izOjacdpdTazF?=
 =?us-ascii?Q?WtipEZLyBP/wgXw+iQbH+yvtS4iju0MujCdXp0kcoGl4hcVM95BAFlyaXcKq?=
 =?us-ascii?Q?6/cr7gfmoKHkGXQnmzDEnJAyvsEbF28Jxa4XdBencJLkep9YcBfrUCH3nseZ?=
 =?us-ascii?Q?63PctEOqkY5KKaF0hGBYFwaxp61Tv2kmIOpDJH6PxOX+1AS7TF1LyC7T2RJG?=
 =?us-ascii?Q?+OvEReckdeX3g6VWXVdUF9YA2AyqeB349qOhDUCcTE0vkYoi1tJbZtM7aQJU?=
 =?us-ascii?Q?JqFitMswMBhuUUttI9hwTUicj65hZKFz8XEFyaPjegVYwNF8dKvYGKbZVDBq?=
 =?us-ascii?Q?elaqGPLH3/bdoynWyn9M6Oy7ygJX4z24Y6EgT20kFw0LwgXtrTNhjIOQ0Wxx?=
 =?us-ascii?Q?fbcfWhW595VQnm8WjXzXdcZt2qlGaMb37ig7BOMnc7ySGkqNKEnFeKvEZ6ny?=
 =?us-ascii?Q?IK5vEwc+mc10R0Ff87WTfT1gyoxRrEJSAGGAINqkP5adjreIZj6aTgA+PaA8?=
 =?us-ascii?Q?p3exdHhkpnJ7/MH+iqPUcbm7XUZInbVuLxaw1GBKQkZBK76136EMA7MkF2Yo?=
 =?us-ascii?Q?QM00DhJHonEGwKlFi/32y00T2dyy0aRqr/GoRk+1Ie/NrISV7m5nAOGDKdCf?=
 =?us-ascii?Q?LzXRbgrpU36L7kCkxvVNfJbsJz22s/1RL4vYzcZE+2U3NUMx3Vp0bdCftFHS?=
 =?us-ascii?Q?0m22XBgAwgO/+dIBFuJT8maOWj0CqPJfjyoM51ghokiXhV/P2GDcC/YdbCur?=
 =?us-ascii?Q?MFFg8Dj7+VdyMYqQ9uP7QOmRPEPlREKJS7UNermSyV9x4FKftyMjxuSV57lb?=
 =?us-ascii?Q?wry2ZIK0HIeVLJMSmxPUJm9L6wcbvsUZGeLQMPQnuoa4glx4wrXFFzRhAeSF?=
 =?us-ascii?Q?d8qdawX6sarl2sJzL31d2POJM/4fwxaQR7nBby6/Vfmu31bfMS34eFGMJWJb?=
 =?us-ascii?Q?6mPsQpObfpRPer3JFdQWChQudvjPf6I289n2QwB/znpu25VuGF/fp35k6jPu?=
 =?us-ascii?Q?VzhiVVnatZc9jcgmJ15r6LFkDyL5nfbDCGQ6u2kIOIlj8glEM2hDxkUxpqeS?=
 =?us-ascii?Q?w33zJarvBcUzSpFhZQQj20tNKekKSRIHBD2jYTFQPBrfDGGglGDeKy1AxGTS?=
 =?us-ascii?Q?dXjlgnhJEZtPWugXY+okFsYQVW5bBF7oA/GSFo9mxPgA6ga9FsnXCwuGcW3e?=
 =?us-ascii?Q?cL6Fq9XW/ksts0JNWSV2Iohf6LdjJYfMpOwMUbRxf2HjE2GeI7cEyrTLWy8h?=
 =?us-ascii?Q?A+FEqXTtGPlILY0U1pHvhjZLGHsauJQ9pd6uugsi/HWTXyD/6d0Ld8z8Nn+x?=
 =?us-ascii?Q?88oI+0KrQXm9ArZmJKwZA4tAdB3mkNNmzz8rBPJuYOXvHkh2Nx8YZ8gpHesk?=
 =?us-ascii?Q?FEZX5NJs8arN7VIOuHD9FeV+dBaPfEpgHtQjFCbUh7fPZzevE1n/M/XvYnHC?=
 =?us-ascii?Q?WRKuw9/0Jt2F/T9i+kt7ioXCoYRnMHvUekV1V4xLyNxztFvrMd+I/d5oxxG8?=
 =?us-ascii?Q?KraVtR4q28R7Ccv1tRKZ/Z0DO8hiaBYpqRf1QrHB?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b362b25-c87d-4e6c-9725-08da6b19a2c2
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2022 13:05:07.4893
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x4oZzBYxhdTU/VkOHPDhkJjsTN4OIHL8JyK3wZSddweptdNx1mInrE1HRMEXHePX7fQxvn9E56CqAMy/JU1XrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2560
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
> Subject: [PATCH net-next v3 30/47] net: fman: Pass params directly to mac
> init
>=20
> Instead of having the mac init functions call back into the fman core to
> get their params, just pass them directly to the init functions.
>=20
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>

Acked-by: Camelia Groza <camelia.groza@nxp.com>

