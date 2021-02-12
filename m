Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67A5831A2A4
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 17:27:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbhBLQZt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 11:25:49 -0500
Received: from mail-eopbgr20076.outbound.protection.outlook.com ([40.107.2.76]:39985
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230053AbhBLQZ0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 11:25:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fnb9bMQfB9wx1ouWumo3hH3PKxlejyh5N6cnrdD2amoQthI7tn9qrfhNoTM25Y6LfALHLNwq9sV/m/YU08rbzTuX3v4AETuJxabtYn0UkNAYZrBYfXmE5mcEIntkfrMtqfSF0Yrcu99JS15UL5Pu3vYtpBs7MwAYAOZA7MLc40aJ1uk7+0hzEZLTuPJOGrT86KWSr7W4Rjzq78QHeuWKF8OmCfQOiaixNdmJNvrebBckTx6rdDoVucPCx2C3hN/AFQars5uf47XfREoum6le+T8dhQEv85nvRQotFpd0PHinhwjcPk5eiSKe1Q6fdmI+wDDeTUGR6VVg8lCCoAaiPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aIYUw4gS86+eyIxNhl7/Bp42sAfmzvRZWXnZ393SVWI=;
 b=gDKXuZ6n6CTOlkZIO4d5xy4YRV/oBoe6JQYQD5+RVGQEHkhHkvDdXAJQPAYdhLOhvypDoeAN8AZm7upLyKGyWxDirxl/cQi5KCxDtrARAGtpbak4sawFcUit5PMdqm5j9d1ep9NFJxrav5viMLkLBSiYM3VWnmP3NAJESIvuo2djI5msy37Owh6DNLAvAjYQMFqb0eq0p0A8xQz6wiJb56HTSK5Taht947MwanaFToGOyrbrhi3shWwBITNWbgxO+kyf6TnGPZBktRAfENbJk9cuUSnDPnlXtze122c16SULaxLwEDqazxm12PjLDgefmzqXAb1w4vnYIr2yiCl/qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aIYUw4gS86+eyIxNhl7/Bp42sAfmzvRZWXnZ393SVWI=;
 b=FLv6qGg8KbAbNGK1L0Xi91QPg1rfOUUSqSAC1EQUsMa+cGMRwwbm7ux5bsPYdkD4KJL5dmZx1fr+TLO71nfpc71fXzd5lH2JdqdP/uPa1IEpurWj3v+kJz9kDSXStj2SbkJML284H2TIP7INYfQglSgIN2XyJx6GkowSPScuftM=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6638.eurprd04.prod.outlook.com (2603:10a6:803:119::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Fri, 12 Feb
 2021 16:24:37 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7%7]) with mapi id 15.20.3846.029; Fri, 12 Feb 2021
 16:24:37 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Bjarni Jonasson <bjarni.jonasson@microchip.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steen Hegelund <steen.hegelund@microchip.com>
Subject: Re: [PATCH net v1 2/3] net: phy: mscc: improved serdes calibration
 applied to VSC8514
Thread-Topic: [PATCH net v1 2/3] net: phy: mscc: improved serdes calibration
 applied to VSC8514
Thread-Index: AQHXAUhgxOfe/xZjIkSaIpt8gbo4p6pUtIoA
Date:   Fri, 12 Feb 2021 16:24:37 +0000
Message-ID: <20210212162436.querlrgmhwy3u2rk@skbuf>
References: <20210212140643.23436-1-bjarni.jonasson@microchip.com>
 <20210212140643.23436-2-bjarni.jonasson@microchip.com>
In-Reply-To: <20210212140643.23436-2-bjarni.jonasson@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [5.12.227.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4dceb86a-31eb-4ef2-59e4-08d8cf72b108
x-ms-traffictypediagnostic: VE1PR04MB6638:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB6638584660F6DAF325D9F647E08B9@VE1PR04MB6638.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HtIjvZTdKKLxnVquOMcgeZXXkPOOO7cJo0pXU+QERINkw9GSaavFZw625uNWhGmbgPrJkuDdkbedCmThzPZFGZYc8G6WxEvd7fl4JW6c/mGiIOozzAqhcTkCDWZHrFklmxMp8+ZoYAwW7+V4C/gttujg7A6qK4CVMp2zo+kQkZuT3DQMMruSCm68by4W6dVWAx6wgILu7Iom0zIJhB49g8qwbEnzQbG+aDwtEgEPZZKZydM4ybqZyqvSyBzSV119zrSaHvqfpgU1ft+9FXJWYsgEyl/PTSlIhhSNXyAI3FuyzQibyXG6kIsQpz398pjsKHPwT6ml31t1Xe8M3cIHlsO+d18bNQ0lJ391oYso3/P+Pc6/gVZIldqfoQDWu3HBeZedF0OEZBfKNhVkeBte7hwBqIqvOCosP3zTGfVK42sI8nLMYyYBiCVA2tKbegmAuNb4EH9CYVrWii4EoXjx9CMFg1qity9U8LQ30IBsrsN11KuSAick/ZL6rGLzKt6h6lRp3yxRgJhvSxUmsEDa+w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(396003)(136003)(39860400002)(366004)(376002)(346002)(5660300002)(4326008)(26005)(4744005)(54906003)(91956017)(66446008)(66476007)(7416002)(66556008)(33716001)(76116006)(64756008)(66946007)(71200400001)(186003)(2906002)(6486002)(6916009)(6512007)(478600001)(9686003)(316002)(86362001)(44832011)(8936002)(6506007)(1076003)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?u/RPkkjcPcTImOGCiTVaGkaMWIMA/cxLh186uAZ33f+4W5sOvq4wKc2aLTSL?=
 =?us-ascii?Q?stlFwDnnI/vJws0L33uCg+/Zwwd+EU+vsMXmax0lO6Aqb1TlFXzojqnHWAp5?=
 =?us-ascii?Q?6cWCqPHP0UMaobqN9NxgNzHK3vXmdrcWcFoZALQ5TRKFw9wjbTMkh/BTxpG/?=
 =?us-ascii?Q?sEstEvcgv1Frt7fhOJUl74nG7QdWZPNSnu1Wnw7nxzOyc1kgYt9V0/4wHuha?=
 =?us-ascii?Q?EbfE46vPXUMU2wYO9NI4Ho8AiEZRoJ/RJS9GObMUFCRIgRd1Bk+/kffCkjZM?=
 =?us-ascii?Q?Ru6XSYBp+LvtorRlKTYbTNBRoBD4ZxhRNhF95hSA2WTSl8P6dpwea7vK3DnZ?=
 =?us-ascii?Q?F6w9sNaJw0efXFlyNk9Oy2k/vtb8y3ZIKV8VMC3Pynn9uYNESobAw4+oqWD7?=
 =?us-ascii?Q?gWkK/JSjRUkiB1aI0mEuUY1C0n9cDAtD+BSq89H1mIM82VEBCRfACzO/ViVV?=
 =?us-ascii?Q?eLklLPFTCtjXTNoiO+3Hse4HAWBDGSYLmBY49wm+dhUNWJLOMi3GfTpECf8N?=
 =?us-ascii?Q?oaOZ04l+QU1joZp3M29WSHVRqcQ2QpCB9hnnwK7UTUIrlai9hu/g77/m5IkJ?=
 =?us-ascii?Q?vmn+eVA1Y02kE4kkOF3tgAkqRrKDelLJoBE4qNiiFL0IEIbic9xsJuHGuqvJ?=
 =?us-ascii?Q?Rt0HQCUBhqR0AmOcedgbl+3FiQ4ua6jGCobi38yari+gT2tIeJpktb/EncRR?=
 =?us-ascii?Q?Fu5K/dZOb8wPsonEOLHpt0zJNWJdEGdoZUueaZ4jzVs96vjrOsus493e6BY8?=
 =?us-ascii?Q?aLjWVfNtcxgnBok5rYfdtYz0OafuOdO4z52CPauxsExGZqswsTyLA3ueTs55?=
 =?us-ascii?Q?4NeUeBQgWG9/zPLyYqzJrLPvFZPnCPENT56lXq1ytJkabi7PaAJC19Xk95tZ?=
 =?us-ascii?Q?yWYIvNRHY5Qdg2AmIL6jV0eOw9JkwT1ssTGdWm73OGnHgqY4iJndPyJVnmr1?=
 =?us-ascii?Q?wQeTEboJ4nhgcdvYhvC4aLYZ65NJIUzK8Nqw5zyxBSvzLj2bgXoomPM5UeQY?=
 =?us-ascii?Q?mdxrtt7MtDUjj5pqu4uM1AfQGm3yDQeu1sfwRH81un79WcFS8X+kA2mlUs0u?=
 =?us-ascii?Q?fNyYqtJDWUeTjN8oJnXAUq6y7XDDWnYOEgWHWJd38XsLdn7mCyoDvz5Mg2Rb?=
 =?us-ascii?Q?aubZIkOfN5nHDUswVh7Qz2a9OCg3xp1AonZvE8GpF7Hkj8bRNvNAf+nWCS5V?=
 =?us-ascii?Q?inSiri4Tw2Cy+SPML1cKk0qTIlmVGGJUJ4VTUZiBvrXf6yaeTCLZ2cODPXap?=
 =?us-ascii?Q?sy95HJvnM6wu2QV9vFwamLSGHA+Qm8qK3hHci8Jh1t09kkvZfDflK5lJK67P?=
 =?us-ascii?Q?408zwnybQmdQ2Bvr2oujnUEk?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F00B5665B18FD746A99B164E00C48B5B@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dceb86a-31eb-4ef2-59e4-08d8cf72b108
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Feb 2021 16:24:37.5431
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VAkXjEwT+kmdQNei6CnE7H0YJwxRhoZv1Bhwh2sJqTnw3RWnfXUitybgqNVK4CsqYmQ3W4AQTNmajDaZBtupVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6638
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 12, 2021 at 03:06:42PM +0100, Bjarni Jonasson wrote:
> The current IB serdes calibration algorithm (performed by the onboard 805=
1)
> has proven to be unstable for the VSC8514 QSGMII phy.
> A new algorithm has been developed based on
> 'Frequency-offset Jittered-Injection' or 'FoJi' method which solves
> all known issues.  This patch disables the 8051 algorithm and
> replaces it with the new FoJi algorithm.
> The calibration is now performed in the driver.
>=20
> Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
> Signed-off-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>
> Fixes: e4f9ba642f0b ("net: phy: mscc: add support for VSC8514 PHY.")
> ---

Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com> # for regressions=
