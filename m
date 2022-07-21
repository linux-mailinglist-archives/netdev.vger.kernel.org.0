Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9DEB57CAB4
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 14:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233647AbiGUMel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 08:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232314AbiGUMej (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 08:34:39 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60073.outbound.protection.outlook.com [40.107.6.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA50878213;
        Thu, 21 Jul 2022 05:34:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QZxVsaaeYveMQZ1BEgoPNSgUvJu1N8pcOZVAd+u18ZjOQF5iQqiAvXfAmSZrCONsq+cAMyDGDipN9PCeuIGWi3i2tXFoFsObDyBd9y6PYTjoxXmYSkUHSHiXlN45pnu/Pm2K/RbG0Faq1N3Y78XLY3KAkW9tK5RxAMeGJuEuTeLijHEDG6SOgMbVKIxMpyM1FmA/xFhZaw5G5tBThFmn1m+gdKufKyP5Z989/I7YG0u7w6QpwE8PW0KYg6CB2J7xJX74jei5HM4ChnhJqkhkx0kR3veZEJnkU6QM02QKTcSj3y6h1es12KFak3O+LhYRI1xW8k2fku6St4Swfn8OLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KzfBZ5McItdJT9HKX+oM6mRbcr6QVBVreNd9cZcrzr4=;
 b=Sf6JIt6JGW41GKDQu46yKPY6RILi4U3240cqxnEYy1YOYSXC4VXvijjupBCiYnr2dv+h991HweOqNRUDup9ZK9NQTjyUSYUSavtDTclMeRWAb4bvVhSrZOiJD3eqbxTdm0fxem2oyqZ4k0Sdh8adHbTbkGYZTNd9+h21Z0U7uJ1nIa7FNtEc5bfQBy37HIaVxO6B6JIfHmSNv4UpcHvlu93IfD/ZuRKYIEAYF/2Nv0L2Cf/aJ1RizhwKYxlDLJM/8mOUIfh2fXMcS2hGanMLyJr/2ai0K6XjN8R7gdyxc0PTZ8iwRLM2WqI3HUwGd8y3PNhQpHOJvs5shfrGQg64+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KzfBZ5McItdJT9HKX+oM6mRbcr6QVBVreNd9cZcrzr4=;
 b=mM7EmAn0kAboGIxrfOFptfcokdf3z/KLPBwEsABys1XdIfqEWTKUofjWzctcjv5eCEd9qJN1GmPeIsJ/T6ue4WrWbBHMysvYyQiH4p1kS3oVjHzeIIVWEkxBKRh+CUWfJCu1UB7iaZChRrsq3jLoIkktFnIZ/fRT0oEYsSzj7j4=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by DU2PR04MB8805.eurprd04.prod.outlook.com (2603:10a6:10:2e0::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 21 Jul
 2022 12:34:35 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::1df3:3463:6004:6e27]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::1df3:3463:6004:6e27%4]) with mapi id 15.20.5458.018; Thu, 21 Jul 2022
 12:34:35 +0000
From:   Camelia Alexandra Groza <camelia.groza@nxp.com>
To:     Sean Anderson <sean.anderson@seco.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
CC:     Alexandru Marginean <alexandru.marginean@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>,
        Bhadram Varka <vbhadram@nvidia.com>,
        Madalin Bucur <madalin.bucur@nxp.com>
Subject: RE: [PATCH v2 01/11] net: dpaa: Fix <1G ethernet on LS1046ARDB
Thread-Topic: [PATCH v2 01/11] net: dpaa: Fix <1G ethernet on LS1046ARDB
Thread-Index: AQHYm8padLS9RibhyECMtmMWQIOl/K2IxGvw
Date:   Thu, 21 Jul 2022 12:34:35 +0000
Message-ID: <VI1PR04MB5807F506B4486ABDAADCCEC8F2919@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <20220719235002.1944800-1-sean.anderson@seco.com>
 <20220719235002.1944800-2-sean.anderson@seco.com>
In-Reply-To: <20220719235002.1944800-2-sean.anderson@seco.com>
Accept-Language: en-GB, ro-RO, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2c11d205-07a9-4088-69e3-08da6b155ebc
x-ms-traffictypediagnostic: DU2PR04MB8805:EE_
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6RWGiT3pVLjGiW8Qjg2ecxZrY4OwZ2IpD1bLmIMSjsZof+FnrH6w7IKQ2FqISxRTCMrTRZ98E4kEMlW5hMpTAK0oI0yFnbHM8e2gtRVposvJp4xCv8RyCiS3yWC5kKSuVnUDLjG7/DZIPpFNQw0In+HN+Z3xx9TNdTe6xoeHSmMl9qpHUXrwmiUCltCfUs9ocK/M/WJPmBid1qbo5alxz1YV2g5lopVhP+trS3pT4T6hlXiXm1qnCO1E/m8+wuL5A5QaTG6kTWJgAO3F+xjzxwrnwqHgBIT2B0S3vzHTJkXk+F0jArb7wIxN6nmXyL2TyMyvskjDIvu3J3d8sKYeqQCxioKmHDKN2Y9LqUpiGH7D5Vqk+Gsuxg7LKeWfQuN8e9eqSJ1OOAZ5Y/q8ZqdE1wS/vVx33BOoujWnYXzdYo7tjFARYc3jvCIv3EhK61PAqXosYrLb0KX9tEGOoY/Dj0izJa7h7AllrHFxoHDxKlLr4yFEdUZQ4aEB2u4TsFd1ZCBwAuVMYDE3LdTXVPqx6pzQONOitXPUCR6aXbJj8teAZ3hyG4oNNOE0xhhRNgu8ihtnG+WqyDqAFQxe94+ocjqWoowJFtumcy3F+fx0lcj+fhpi/LkLYsZI0+9VAuILL9FEw2AM+GcrwwYIfASksElJAURk/0qzqmFeIfliJvzV3LpXwhuZOVy3p2z86UtwoG/1sAacsvjJuVGqV2NW7Vdpe6Fe91b4aCqDXLGBOjoxIlxltkw5fyx+6TKR9fDlvZloFwaaYDfUXUPTjg4SN5AIbJA7nzH80cl+TUkVK2EMS7bY1ATp0CSpCWQBT7ue
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(346002)(39860400002)(396003)(366004)(122000001)(2906002)(33656002)(110136005)(54906003)(9686003)(38100700002)(316002)(478600001)(53546011)(55016003)(7696005)(186003)(8936002)(76116006)(66556008)(8676002)(64756008)(4326008)(5660300002)(66446008)(66476007)(71200400001)(66946007)(26005)(38070700005)(86362001)(6506007)(41300700001)(55236004)(83380400001)(7416002)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Q8PyMvowP6eRK7G2RZy6eArvVGiPqucs8FkcaoC0WaYrpEqjjDhOqz01YfRB?=
 =?us-ascii?Q?0EO6mdMFwkHqEsBiHWFb+JpBW7uiHCRp1Y8Q2dDlri7qws5sMaYX+qRuQFpu?=
 =?us-ascii?Q?tbKPZk2caV3cOB1/B67Kf2w9wcGUEaOHmy2+c1mTvDanuuPqoSvLqHoMZf8F?=
 =?us-ascii?Q?dMwZQZMtd8u03P2+LCM9Ed6+XYLuUV+ZsnlBjS3qnvdKc1roKWOFO1dXHv1Y?=
 =?us-ascii?Q?Eoxzj6NI5p8jymIoecgmtUV7G1mJ3GXlixk/eTcQTDQ7AjWv5RNHYjP5pWHb?=
 =?us-ascii?Q?nITsoYS73AFvnobLoOy7VcRPoqqC+jMAAxaqg0Ne+bg4Ov7ydecZ9P06YD4E?=
 =?us-ascii?Q?coYzEjty6obyHyckC60PNNc9YV8KWMTihKp3i3jHa2aht1Y2ZzRz7fXLi2MY?=
 =?us-ascii?Q?8j4T4AEA7+NyoaRTVn7k6rL3lhFe8IuGMTg0ceyWU/sA9ho3xrU/H9MZEp5s?=
 =?us-ascii?Q?3/f5dXMI43LItsgMp7vulrHklYF085pxObjYIpgsNoaQcnmPG+SMJqwZCRgP?=
 =?us-ascii?Q?9irur0HBEKC8qmbSsIfwPRbQZcypaN0CYMRFy+UhW/JlaLoHZnNX90qXw0a2?=
 =?us-ascii?Q?06YTLUpkvK8WuK1xl5Ist61rBbDtmrlOVLT90Zpdr4jYz+YEjUPOHN4BXlIE?=
 =?us-ascii?Q?R+T/KilC6gcAa6tGuo1sXRDh1vf7oOJEuOEsxJVG+aanLJ2almTdbLUDTR2i?=
 =?us-ascii?Q?/n6eJV5H3ZBbuUAgGbj167YibtCMepuUx6f5mHEBeFALr3n2nLfTDcyXKJyU?=
 =?us-ascii?Q?z4x91Ti5LFwm0n1BT5o2lT2GyeKQ6ebDZ8B5cb+3c4iAbfwkuzexlYOsAEoc?=
 =?us-ascii?Q?/FLgGFyR/Q7v5fB7nhqpk7ooZQVUb50Caxv7ECzSQWwowMKmrG90MF+pL0om?=
 =?us-ascii?Q?wLAq1nRegFsHXfjHlhNS4lfp4FZm7wPVepSHzc+4NbKNJYmiKa39BsWwAHQ7?=
 =?us-ascii?Q?YJYk+51z6qDI0WsNzhOXL2iLMl5JvUgdqXfN0mspt/AYRtr9TTzHvfjGFzIB?=
 =?us-ascii?Q?rZjBinbY6bW0tzvuw6g9vBXLZ+zTO9Za4tvLQSSud2sS/MihIKxdKPbZnEFv?=
 =?us-ascii?Q?1XvG3k8yAdHqBNuS5CgR8x/MV1RzmyqXMf/+L0VuMX0pXCFa+LBNZjKhpOwe?=
 =?us-ascii?Q?cdCdCttURw4o2n+KjVNcWC//OLyab58nTSQOf87R1twGOphmMlz/6pkByngn?=
 =?us-ascii?Q?CW93edMaQhPUFnIJMAO68OYqeddsn+OmKK67f13O84Bbjx3AGz025oaR9VS2?=
 =?us-ascii?Q?/e/sLL5VHwtwHWE4tv1L75lDycjM/dRv7H9/fqc0RPveEvx3dVOWrWjdjW/L?=
 =?us-ascii?Q?z8tXXoINHrg59fXZtp+Eli3iWdR1vLLK9lHXLf/fcqw6c+QXemgzGmXv7zR/?=
 =?us-ascii?Q?JiZEm+b/rCibg4/N10jsfJJAo+9triNBvHxszMtB+u5gB4BNeIk6Xqrf9wxK?=
 =?us-ascii?Q?27WH5VxmNY5lZ+oEP7u5q5/GjCIAv6S9Apy9LTbiHGuhroIwzlYwc5yIriZd?=
 =?us-ascii?Q?k8YQc65RYpea6Pmgl+3jJs3X3ZJXLrVia5DQcZQw+BgG9cePVeRKr1sM9G/g?=
 =?us-ascii?Q?mkkS1zY9rHKBs8CClAAfBZcTSRvbAB3KXclgcqv9?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c11d205-07a9-4088-69e3-08da6b155ebc
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2022 12:34:35.3769
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n1jzObnZoWgY2rSnjvG8flfc1Y16oC0odAB3SK7pGqVIompc0zT5OJLLsX3t0am/t3KE7QRc2BDLnMQUZJBwJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8805
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
> Sent: Wednesday, July 20, 2022 2:50
> To: netdev@vger.kernel.org; Andrew Lunn <andrew@lunn.ch>; Heiner
> Kallweit <hkallweit1@gmail.com>; Russell King <linux@armlinux.org.uk>
> Cc: Alexandru Marginean <alexandru.marginean@nxp.com>; Paolo Abeni
> <pabeni@redhat.com>; David S . Miller <davem@davemloft.net>; linux-
> kernel@vger.kernel.org; Vladimir Oltean <olteanv@gmail.com>; Eric
> Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>;
> Sean Anderson <sean.anderson@seco.com>; Bhadram Varka
> <vbhadram@nvidia.com>; Madalin Bucur <madalin.bucur@nxp.com>
> Subject: [PATCH v2 01/11] net: dpaa: Fix <1G ethernet on LS1046ARDB
>=20
> As discussed in commit 73a21fa817f0 ("dpaa_eth: support all modes with
> rate adapting PHYs"), we must add a workaround for Aquantia phys with
> in-tree support in order to keep 1G support working. Update this
> workaround for the AQR113C phy found on revision C LS1046ARDB boards.
>=20
> Fixes: 12cf1b89a668 ("net: phy: Add support for AQR113C EPHY")
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> ---
> In a previous version of this commit, I referred to an AQR115, however
> on further inspection this appears to be an AQR113C. Confusingly, the
> higher-numbered phys support lower data rates.
>=20
> (no changes since v1)

Acked-by: Camelia Groza <camelia.groza@nxp.com>

