Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0078057CAC1
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 14:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233682AbiGUMkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 08:40:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232164AbiGUMkA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 08:40:00 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20079.outbound.protection.outlook.com [40.107.2.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB9276956;
        Thu, 21 Jul 2022 05:39:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GCTmEZ55+6X6/AjLGSJWQQNqO9gsVLlB6/7D1WvIu1sobxJfVWKTqnnC36VODjup4UUjXqyyehGRuBdvB9R0NUg371+utzoz5Ixno6gyDY31fmO1+f1XW4/icbbUgqgdfANkJ1NIDwyUgWMTWcirr6GUEIQh0TP+Vsd3DIJUcXelXWM7Gh3eFmDhT8VSo4rEI+n0zctvQdvCAeQvRDS7+btS1YqzKXlJah9LEUkXYQPz5x/ZWaeMQs7JUmoLy8j0PPDjl5DC+7NX3ixOwl/jkb9UxALovA6XhTpvzabOiImEZ1KhyoENlL2S0rD/3xBoZ9O34kKn3t7HH9/isqDDGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MtwH5Uiu4o5/5+yqwAjA/c8u0JBkiPuY4PwDay1QCjc=;
 b=f+XKKffhtIHBQTNoZQ/M+1qMkEjynlMsnvINZ1BKa9BP4ucOpu+GXGarT/rcJxKX5HmN8aZNcIJ51MpygOTJEEHbh8iyvgMGlNFQkSMXV3VG/KzG3/4RXw4IlO9FDaL6QIS4Hm6Av6JhzsAtvpaeSwV49hThUTAjF6tM04E5b7RVeGt4xKScF4tBgRDXbcTEji8mjTEyjFofJ3Y647FvpPo0jfm7GwAH5Ugmcl16YbLqi+CR14eqQ58/qdvrDDuz/6X9aN74COvg4oHSRHf3aXsGB5QbkNQIPeiz6WUoif4XAu7MoENOY4L3wrUvLWMlyQaVAOxmXqhfAcFToJq/ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MtwH5Uiu4o5/5+yqwAjA/c8u0JBkiPuY4PwDay1QCjc=;
 b=htsp92ZTqey/kP0d9hzegezeWKrPYFBNxWmqAYex3WuPa3H3ERADxnnvZJf6B9aiq326tNnfxMV0uAR/WIVViqWEirjVrVYkJiA1wtG0L/HSqTNsJEyH/hum+dclzHHKaPbI3qTtD3PML64XfkSmOFX58Xv3PR60x5WDmaDyALw=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by AM6PR04MB5640.eurprd04.prod.outlook.com (2603:10a6:20b:a3::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 21 Jul
 2022 12:39:55 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::1df3:3463:6004:6e27]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::1df3:3463:6004:6e27%4]) with mapi id 15.20.5458.018; Thu, 21 Jul 2022
 12:39:55 +0000
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
Subject: RE: [PATCH net-next v3 19/47] net: fman: Get PCS node in per-mac init
Thread-Topic: [PATCH net-next v3 19/47] net: fman: Get PCS node in per-mac
 init
Thread-Index: AQHYmJcYHN/BPHCBxE2E4yLEE8zAva2IzKTg
Date:   Thu, 21 Jul 2022 12:39:55 +0000
Message-ID: <VI1PR04MB58079FD99476E843DE70F89AF2919@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-20-sean.anderson@seco.com>
In-Reply-To: <20220715215954.1449214-20-sean.anderson@seco.com>
Accept-Language: en-GB, ro-RO, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 28d3ae81-4c20-42e3-58a7-08da6b161da7
x-ms-traffictypediagnostic: AM6PR04MB5640:EE_
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NA4W84pGgYBrDbYUH8Mb/SV+Qjriqf6MCKFJUwAJfP5eDj4Jhgh5I0Qe2Bb1y3kt4Fnmlh023RKyX6puBJQKWMSPOOvNNNKIrzMXRGRCj+LTas8FVqfXUXMB76cw0rIFymA0mJ1cxeKPMwx5koqeDF0eIPgOFAKR6xh7olKN1q0TiT3WSSfaJK+hGmLc7zR37uc7WBk9qFGmQygUgDmI4xjg6fYdWNLPucc6shIyhp3DP+PqqUaaFrHf3rziLIPKXrD7s0D2eG1md81vc7EWrv67osIhPQ9JwAO6/9yPXkSUoifZTn4f7svWFkd1nUJ2QtFvXubMIvodn4AIUyVAIt/C8ytRZWcLZtr61Zh97aJSU5F3LFezPCBO4Bm9QKMBXtmxVFXJkP2DbGpdZrNw113zYilCzrMOFDkkkIOzlWTuf6C0odSiSysZMFhiOc/mqNtzLuao2gppRJSTuZhT7IXq4apOD+GsTmIoq2sscUjvl8iSS3HsYIuRw5ooJQibrUmNauK4BufvGrVchZSIaRMLfmlU7w5YSYiFJw+8eG0WhVmIuOhLIgP+jejg74XWhRAad8V6YdCKvENFQD9uI1SsqWHRVVnQBZf/lEIJJpt/jS59o9SU36GL/H8EKrvbeKotwXPh2fbD2kCHyyDTnfPstxI0/aLJJ5yCcXiA0znpRxVEC3pSL3er5qLEYT1aInImyDpq3wNjTisXf1bcXnd0B4deSYe3oIh5Bw0FrQl7p8n3eLLesdx6izTNKr9eJw2UwOL1DbR7ESfAuQEoUodwSeY5PLtvqsoXnYVv3A1WyNg3tzLWJ2MSsWU+pVdh
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(376002)(39860400002)(346002)(396003)(7696005)(478600001)(6506007)(66476007)(83380400001)(64756008)(66556008)(55236004)(9686003)(76116006)(66446008)(71200400001)(52536014)(26005)(2906002)(66946007)(110136005)(41300700001)(53546011)(33656002)(8676002)(55016003)(86362001)(316002)(186003)(54906003)(4744005)(122000001)(8936002)(38070700005)(4326008)(5660300002)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?d76ZlM3pz+NGncPAbZGbwgBWKsXZS4M7jwd7oIXIjKYQmaCxGPFW3o3QnxQf?=
 =?us-ascii?Q?WX7roQGHIzIMdKgWzBmrVoHiCq9mHUguvhHi0oc82nAICJ7WAuN7dtoaiPDb?=
 =?us-ascii?Q?P/zaeDXSeJPN1NBPNQGJyRSRHu/dMOXzkxCqj2ruSa9xZKWEMIERmB2j4kbr?=
 =?us-ascii?Q?QMP5Yd/5i4eIk5zXPlydD+l4v2tXmjicKtFcVEGiKBaDdjg2Cqax6kfbpHCJ?=
 =?us-ascii?Q?CyJVTi5uBozeRJ58rYcxL081DZGfzpDRzEnwTwfIdUvWTafK5fqDgkRADBVc?=
 =?us-ascii?Q?/vRPM1jmK/9YQ4dSryu+XG6tq0oX3Mp9fTnDY3dKvXt3UQ+PqKnKDcS5E6uc?=
 =?us-ascii?Q?8JH1SY543DVQEbqrBvaG0BQnxHQmHbRcw9IFAgIFj+ZlVBXpF75hudKXqeTZ?=
 =?us-ascii?Q?3Uv2/ymc9C4iNGpX9TqiwhpqjOBrrSAh4uSpNZMKtgtArC5E9HUvjw/Ed8Kb?=
 =?us-ascii?Q?cXsjBVaHyJM3ql/z227lZnayBLTmIY85NBd1pOtFY56dBxn4pd7Xyn0RmVS9?=
 =?us-ascii?Q?zbEVFRrHc+tc4x/SMpfQ2Z7ZLfxgqjn4lr8co4XN4vNHRrcrKPZWytIHe64B?=
 =?us-ascii?Q?5PBQXE5zNl1kgBfw9IQ4xsLT4cf1AxkYV69a8d5eUkKBDN/jAnVA+vKijrdC?=
 =?us-ascii?Q?yMXj/r5Nq9192j5pG73fm+2PQ3aWm2g6IYrEVqmiq3621aj7ky6fiMvXrcxm?=
 =?us-ascii?Q?m3vldSBLPepH7ITpEzKOhbDIidf/vYpBFbsNJJPFbFyc+7312xKL3pNBglIx?=
 =?us-ascii?Q?3G4cHP23WcfPuECyOW+yOZphUTUkOeR/LtgYWwTEpeTL8aGPqPxQw598kZ/0?=
 =?us-ascii?Q?5uysw+4Pzeh9bVf2EStb5tQmU8bFqUlcVZ/gk6Rg3dxF99sqG4++MM0W8V9r?=
 =?us-ascii?Q?+skazfluNozdpQbhc9beo5LbuqxRG7oZmViTHviqOenSoKikMjNvPyP3IhHM?=
 =?us-ascii?Q?IVKHneC48eV6c6ETootDCYhDMStSNXnJsrNo7JeTl4LnHBkt0ef8kvD/blAv?=
 =?us-ascii?Q?dUogc0BQr7zN22u98iT3CIRVfYlQ8RGfmpluSIAUpDMFnuwIBKYZGNfdT4RD?=
 =?us-ascii?Q?9R0BcrhIAUojhuVCSic0vdYapMrybd1xSQmKW/J0whYzwnsf4XhBl4umP5Er?=
 =?us-ascii?Q?p8cM3nb57N7MhKKcrZeewUzjJSlFho0qtpbzfwstX0N1kMuax3ni16dXcnap?=
 =?us-ascii?Q?hu1kzMYQPzR/ZKy4cah0ExI5l3LZPQ+wUlQoe+QNG91A0EbRv9t6jsaRDOtr?=
 =?us-ascii?Q?pRqaMYE0Qwx9w10ZN2dcGqUFdCs6fxD0zsUbdcIHZZ/tO0JhKA8X6UxtcKZS?=
 =?us-ascii?Q?iiUN6YeHa4xSt0eZ9Yg5DHN2U4jqUe379Aa/sNlVI4bEA5kIFZzeA4rmDbKP?=
 =?us-ascii?Q?lB2ehJjC2jsG2IzfromBtDTRGsuV9c3T2yS21pBMkxgaNg1eZ1Zf0r9smOW4?=
 =?us-ascii?Q?uecL2sOWFTrDxm8wNwiuG9gP2HdijxdQf3U8JvPL7A0voamAPXJHTSNceH2g?=
 =?us-ascii?Q?lp/2EsKkTq1KmVwFDTRuJOsM5OBc/I93ubtZm+S53HrFHRrom9a05os8HhNf?=
 =?us-ascii?Q?6gSAjtH03KA6gFS+aQ9CbdRgDRUCbtzI8FtyCTdk?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28d3ae81-4c20-42e3-58a7-08da6b161da7
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2022 12:39:55.6680
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N/BMlrPRPtTYH+fWBNyfFzKeuS5MLY5PbcAY0A6l85Z5TeNs0poEiUYHGBJyY5rrV1h3BHryEll47R6dDzfK2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5640
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
> Sent: Saturday, July 16, 2022 0:59
> To: David S . Miller <davem@davemloft.net>; Jakub Kicinski
> <kuba@kernel.org>; Madalin Bucur <madalin.bucur@nxp.com>;
> netdev@vger.kernel.org
> Cc: Paolo Abeni <pabeni@redhat.com>; Eric Dumazet
> <edumazet@google.com>; linux-arm-kernel@lists.infradead.org; Russell
> King <linux@armlinux.org.uk>; linux-kernel@vger.kernel.org; Sean Anderson
> <sean.anderson@seco.com>
> Subject: [PATCH net-next v3 19/47] net: fman: Get PCS node in per-mac ini=
t
>=20
> This moves the reading of the PCS property out of the generic probe and
> into the mac-specific initialization function. This reduces the
> mac-specific jobs done in the top-level probe function.
>=20
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>

Acked-by: Camelia Groza <camelia.groza@nxp.com>
