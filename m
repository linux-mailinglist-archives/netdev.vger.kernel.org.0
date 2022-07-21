Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6739C57CB61
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 15:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233828AbiGUNHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 09:07:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233802AbiGUNG7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 09:06:59 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2070.outbound.protection.outlook.com [40.107.20.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E4A27AC01;
        Thu, 21 Jul 2022 06:06:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GezaWtaKOEZDwrMQnzIQggdYJYsdaJwG2nvQhXUUCMsimO2Uy++HNOXMyhxYOv7nTQl0NYQB/Igqk0K6CmswGfTkk+hMYz5EDfpGRO4Cr3lcAfu0FPG5Z44tBOJgl2DJJDkDGFw2H6h6LrtPB9GiBCp9zfpE13SRQh+4Iyd9y3DYIDPADn6072CZCFF0hWJ+A/YyBGw9wnv6+MU4JDnX8wf7jkdwSbq8XtMSsE2MD7PhZRyPJ+7TPEvwQhfDungaxczw0R2ME9WDSOMA+P7jp+xvcMmYO+6aAImABJsQJzjpYezYEqL8mz/KjrRsw/9/fbxE6+BS5vLheaHqYKEO9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Jw4tFt9GTFZ15K1je1jSDNGnzn4RvKeSV9EXCeNKN4=;
 b=TlSbx8Ul1NbK4AvbMsetfsXdqQwatCc/nKYZz/ioroUbdMJyceqq9jV3v9dZ+L8WZk752fAAp24P6A3LRy+ntP4OuOe6YAoqmzpFrdEeGLl3nj1sO5Kn0zCTE2g6t1hpYjH1thpW3X3ptycWllBajnIFwEiSgV2Z+ewuOAYbE8+gkremjnpaGolwR/TeZsj+mLhvD3Uahn8hSgjebFY9XjPhAQN3AYj5ADEjO0NU2IDrX01Sf/S32mvTU8iG0F7xlJQ9rwjQ4IdQHLIMkijM+z2gVgTR4TxJAjzW5LOmNATfcTNI0Eu4Tt1p73vcd2lUfzzz+ieDMrA7H26dZNugZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Jw4tFt9GTFZ15K1je1jSDNGnzn4RvKeSV9EXCeNKN4=;
 b=hUl955FdMEy0MbRGD9//H1DBxffp5ZSK3/9Jemrp1ilz6QOpwKuRo9o2qiZvpP2s0qwqH3kn9vCjMjPH2CLUI45FBRnDI7EXgmUEwhSpqixZ2FLp0v8nzshUEKDf37CRyrwCiflwFXpQX8RP4SXMh0MHQQxcLLmoe0O52jebOJo=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by VI1PR0401MB2656.eurprd04.prod.outlook.com (2603:10a6:800:56::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 21 Jul
 2022 13:06:17 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::1df3:3463:6004:6e27]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::1df3:3463:6004:6e27%4]) with mapi id 15.20.5458.018; Thu, 21 Jul 2022
 13:06:17 +0000
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
Subject: RE: [PATCH net-next v3 32/47] net: fman: Specify type of mac_dev for
 exception_cb
Thread-Topic: [PATCH net-next v3 32/47] net: fman: Specify type of mac_dev for
 exception_cb
Thread-Index: AQHYmJcNOuAGBq7o2Uaxgsq82AOm3a2I1A+Q
Date:   Thu, 21 Jul 2022 13:06:17 +0000
Message-ID: <VI1PR04MB5807A8B426E0CF0AECBBA9D9F2919@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-33-sean.anderson@seco.com>
In-Reply-To: <20220715215954.1449214-33-sean.anderson@seco.com>
Accept-Language: en-GB, ro-RO, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a70fe02b-de8a-4443-a6f6-08da6b19cc59
x-ms-traffictypediagnostic: VI1PR0401MB2656:EE_
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7PO459AD853BrrYcfkuH8a7AIhTdVTEWCTw1BUfUzpSdHNNDkFzlU/2H+jvAyJoF+V2MHaJuyTbcL6Tzgc6pDWUnd1S30kcl9Ss9NrZ1X26auEO7/yvwTjCfpvHTd2OlGEmPm6hP03+p6Eg5PrgbE7bm3XG6GIzehp92jqLKR5dCVJRogdxF9Up7AgGdghkrnn8zTSy8CtPCFOlJcAQctRAXocSrJs66DirvAWu7idKfcqV7GNFaXrAXpJvX2ezLoks8GWQRPHA/pIK+Xtk1KdgceSWSXMp+dbJobD5xgsT2PkxR5PTrfLRrrN7s14iZQhF7ClDtqKhFjAQKy9oroMhIw8+5YOYdwhDztgQqJWWBsl5+eTLN5l8NrPTEDe9OY5HRGileCEz1la+gvxBEf6VsOIUFaPM84f1Qfp6p+zJyJ9mBUpA2n+O7eUr8owWRze2H5jv7epckZzO5/5UDRs2I/DEIQFMDYGAfC5sBKfPDYaMOzMNzeZVZODRen4f0+j6AxhUSE6pRjh0ei/AIhCB330U9a0vxDMYNr2/AOwAz0EBFk/pYWuSJKPfMsV+s549UJKlqolijNb7AwszMTGP4I/SduKUqQNdIw1u19Pp2FNbxMjVpflBNZEL5O+MRdg7Vze7mdGuJ2M1vc4bZRoH3Lcn5xaJYWSlYZfP0UoCcS9nh2GJHSME1uLApOVd428IERjDcm4wvP3ojbstv3Xo9mE5E1E+a5iFPs3g0IwpR7HXL/uKcgDswMuUbhUHf85DCfL47Pb7/8dECwOkdc2sDeypmI4ljllWIyunnb/FOZZNKvMSUNuaKzdcahLYr
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(366004)(396003)(39860400002)(136003)(376002)(186003)(83380400001)(52536014)(2906002)(71200400001)(41300700001)(26005)(6506007)(4744005)(7696005)(478600001)(53546011)(55236004)(9686003)(55016003)(33656002)(38070700005)(38100700002)(66476007)(66446008)(86362001)(110136005)(316002)(8936002)(64756008)(5660300002)(122000001)(4326008)(76116006)(66946007)(8676002)(66556008)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?C3Y9UNn/iip59nCM0kPniw8c4T2ABXz7q34jyu1xksn9erE05+2CH1pDzmO9?=
 =?us-ascii?Q?A9W800SR1zaE/atxa54jBXZSsoT06pZQU8S8Xxp54ESvHf9s5OeL0LFm23os?=
 =?us-ascii?Q?4MH7ESbmlyjnBA2cifVt0F317Bx0zsmomKCcDxdZ8xgj+4hocIjvOw/nPxh/?=
 =?us-ascii?Q?fWflfK3U9KEHgzeuVSOCLeuB3holkXGKUArIU9B/FxlL32B89VFOnv9BNvdD?=
 =?us-ascii?Q?drkm4hEFMf0uEU332oMlj7P+HWCNvWtb9FtgDSZVvIZt0hgRnJT+qgxGIvuu?=
 =?us-ascii?Q?jhKwKnrM3QpmzN+ZTuASxt0+pphOfB1oAzugcZPY8fv5ZDEC2y6pwhmhYgQi?=
 =?us-ascii?Q?dAMllCPU06WM8x9lowsrplSsXYPvkUshnelAP2b8Sa0PXn51CxUzUMmj94g2?=
 =?us-ascii?Q?xpGccsbpvVOJkyQe1uNwrbOIs6Eti2fah6vYGFtLmpLOPRE/IvZtHNedgbG2?=
 =?us-ascii?Q?DcSbcrci5Cc5n2CCG1/PipqMWngDKZp1IVPFvHKEWyMpTnNx7rjm3r2r6fic?=
 =?us-ascii?Q?aEeKa514wYNCwQx6I1L6c+fSAAfPLvQEfgQ01Oj46SHcvOcTE+SKoKXAZ4vE?=
 =?us-ascii?Q?IVDWa9389ZiRoiOiQzXvUTlmJC1uLnuXtZ4IqiMOP2UWTeV2WO4gywvwDHE7?=
 =?us-ascii?Q?9DOE3i+xCErnGOezCkHQi1aB2vxbYz40Q6sRv5MXEh3gtmrbMNY47Y2GP4zz?=
 =?us-ascii?Q?7+j12vocu3tAVkan9TMXuY2bG0Yb8esAPpUsNniHhEVZ9rYaB/vJXy/bpA+Y?=
 =?us-ascii?Q?vjZ+GWS0Oeeto2jFTIfS0y7qWTKdc4IAvHc74uCw56+I1hARoezUMm7HYi7M?=
 =?us-ascii?Q?ZuCciBPVGVxInEwIdy3rO6zQHPhUSXq1RG07M8zH6D2qAiuBF227WQQZB+Im?=
 =?us-ascii?Q?Y4t5ahV7GnPrK68GO3jjwVOeBUDORKhvhlX5ffOBiBnzKByzBat1OjMHS3+Q?=
 =?us-ascii?Q?Yt4czQ/+SGPjUameYZ8RF27FIjJ7tqIXT0YBRa4I/b/zM1hPeMzqponzf0Vv?=
 =?us-ascii?Q?yiaBtdyGxeK+pXO08JI6hrIELkQggBR3JtBkT4wG/Iosa0XUTulWWwFAxKjH?=
 =?us-ascii?Q?6+zJbutL8U9Q7qCAuoSRX5IZQ0G/0GloQXX/UhsbUp0l3mR/D2QY2ar7ZrAU?=
 =?us-ascii?Q?XYXb01gDX6dw9bxswW6bN8eNLFF5XbuJ8B0+sy2RHFyGRNe2VnYrfXQy2Xrv?=
 =?us-ascii?Q?otDOXTcfzD9gfL9SXFlggdV80sT41rAmWLUJK1yhNaydASyb/0Y2BO4SkRnX?=
 =?us-ascii?Q?Xf6eaRQDNrjbR9K/VjQJYhRSBQJMOUbY52V6/p6rEYWQmJ++7Q0cZ0pbHBSL?=
 =?us-ascii?Q?BkLbcQIyNLNTO3stoSy884QbHa6i9RYJf8n+37PenLTr3UbuoyAjXZjrTKo8?=
 =?us-ascii?Q?X7DzLgsEXnBnajTVUsJz178XPl/zlGRVR7KwbIIIW37DDlBxbQG4tjr16p0c?=
 =?us-ascii?Q?i4GPbPd/XopbSPB6+lp8QUCFHnOk/IbKc26iu/aBPPm0+1LzckhJBNhucCms?=
 =?us-ascii?Q?4QtsX6zJkRZWw023IZzMuQkWty4HBj48BZin9O0yGYzBZV43wJbCwkNP1MNp?=
 =?us-ascii?Q?vZ0MlgeQCD1G2Uv+3XkSSFLU+u7UgRgHG4xQ5wS7?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a70fe02b-de8a-4443-a6f6-08da6b19cc59
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2022 13:06:17.2815
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q2c5KOAaHsszvVmYx9HHNjDp6lYgcHmPKVnI0UIcEjGRjWBMFVYK3JoVnK1+PHWoUaZd8mp36/c59CfFjFtwZg==
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
> Subject: [PATCH net-next v3 32/47] net: fman: Specify type of mac_dev for
> exception_cb
>=20
> Instead of using a void pointer for mac_dev, specify its type
> explicitly.
>=20
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>

Acked-by: Camelia Groza <camelia.groza@nxp.com>
