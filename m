Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C37F12D8DAC
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 15:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390981AbgLMN6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 08:58:48 -0500
Received: from mail-eopbgr10047.outbound.protection.outlook.com ([40.107.1.47]:64638
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729208AbgLMN6r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Dec 2020 08:58:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jYX2V1/aCfBIuL4kEFnyuMEpwpsBaQmi4YU2hs01ifvOnq353OD0/Q5YMYsga3wlOauUVQJ2uY87UJ36h2SzqIf0lsY3VTIfj8AkWCT5UgXor0jencL/LxElNEqLzjlThusZWx0hPQiZfM63HOdZB0FCAZVCcVhvrUFqL11nzfnOc984QBxieDF2uU6zlctTMG6bT5oHP+yI9pPhwdg+5bUxQVXBAtFL7QIMCHB0XO7UwXLMLh/jvdV1AMGmAGaYtIwk136aXi1o7vUUXd+inr0wExMQq0jhdO2dEfBOIMvP6Euf7+icNdVTm/5UQNRkdhki4CFIHUMTeXdnMKoEcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4bNUNyX2OkcA/p7RRz8/0NoCDR167RI4yVLO7Zke4+Y=;
 b=B0uRQXRSQ6Wx26LwP1ibXmly7V7lbixKjDj5KMn1sZDD7IT24/Y8awJCpcZ+2VOE7Kj0P/7XS0souB2Mka8LS5voJtvskyWz6MPyNCH8TP6ulhqJFjMqKN+XeFslRltetkYNWqE86vZ5lpEX9KvhaLSdlmDMZtfOAJl/mbaIRRLrRtRx1/GzfU+RpfEL7acEudTPq+WXC9crd97UQbg7ydkAGoijoMq+V9hOySzEir1scNO8M+DKJcurWwFoJWsi8aK6vIzbXCbQh3HD8A4MdaiJ4x/pF+B/RFYRZq45jZljzmQGVvze5hEiDaWJv6PrZCBt/WxQKn3xs+Xvh3QW8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4bNUNyX2OkcA/p7RRz8/0NoCDR167RI4yVLO7Zke4+Y=;
 b=Fy1N42YJw/0HIQ7RCvewEOSaC5jkv/k7IxyT191WspJzF4q+fwwpq8vVOMMXPJI4hDPmbsllLMYEwAvrtO8F0Rj2vPBrzHJc75GlwUszeba7SrxKTN22kvQBzUqvyDMNGAdk74jmKkMFrKeGnWYnxvie+neZ9bceWOQJd9ceyho=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB3968.eurprd04.prod.outlook.com (2603:10a6:803:3d::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Sun, 13 Dec
 2020 13:57:58 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3654.020; Sun, 13 Dec 2020
 13:57:58 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marek Behun <marek.behun@nic.cz>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH v2 net-next 1/6] net: bridge: notify switchdev of
 disappearance of old FDB entry upon migration
Thread-Topic: [PATCH v2 net-next 1/6] net: bridge: notify switchdev of
 disappearance of old FDB entry upon migration
Thread-Index: AQHW0PlmzHTq9ao+zkuxYGhmmae9UKn1BAAAgAAD5oCAAAYSgA==
Date:   Sun, 13 Dec 2020 13:57:58 +0000
Message-ID: <20201213135757.wf7c7dkl4odnn44z@skbuf>
References: <20201213024018.772586-1-vladimir.oltean@nxp.com>
 <20201213024018.772586-2-vladimir.oltean@nxp.com>
 <85b824ea-5f43-b483-55b6-4ffd0e8275d8@nvidia.com>
 <562e27af-ff7a-8dad-4303-19edd5b15af8@nvidia.com>
In-Reply-To: <562e27af-ff7a-8dad-4303-19edd5b15af8@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.120]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a43a07d8-1b19-4884-8fb8-08d89f6f18f5
x-ms-traffictypediagnostic: VI1PR04MB3968:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB3968BB91520F7A776821BB21E0C80@VI1PR04MB3968.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SeJzzZql9YO4AgoXNS21DH3llA+zpNrnKjFWTBXfjykNDohR0T5qMmkDP6LToPm4WQ6XOXt7vVSvra5RmrK/E5Ax2Jv6EZ155E5QeboGJZqwWuLd0qfo1yOWQt68ZS29zX2vKT1qaCM7Kn2m0zzi29pdVxzG8RohDn/B2R5c71lpYpIMjcFDeivJzYz6qVKTshe/XVlk9ZlKfXzdydCjPIjnlDeRgz3fzI44ZMvY45gUkcgcp85Dlo4DAmVwYRKUiMBIx+/f+77OGI9vHChDUzIBa3obfYtE4kY4ECaZmt51PgminDnHHytrUnu2sATzUEdIyvmBGtF5ARf/Dx9uOQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(396003)(376002)(136003)(366004)(39850400004)(346002)(6506007)(86362001)(54906003)(1076003)(2906002)(26005)(6486002)(478600001)(5660300002)(44832011)(558084003)(33716001)(4326008)(316002)(7416002)(186003)(66476007)(66446008)(66556008)(64756008)(76116006)(6512007)(9686003)(8936002)(66946007)(71200400001)(8676002)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?sq0EnGlnjz/antvdtvklXn8Wquz9zAF4A/2UTyJcg06LqcXNXD1MY5sT7y75?=
 =?us-ascii?Q?KBkLZRDsdBZ6tK+pFeoNx6QKJ8Y5oFdYGdcqX2dRoZRrwbLrBeGDYim+TjQi?=
 =?us-ascii?Q?T1ZGJtozVBqFZXMH+vcQiN5H0o/mlUqr5OrOxKwf3FsqysFzKZPwcigALtvw?=
 =?us-ascii?Q?2+bhfhDBbOKz/bytKZc1xNqShQn3NIfakc3kRd6EiEPAfSVSXEzegbeg4IMk?=
 =?us-ascii?Q?awMnba+wF8VAi0OTtVwh0Pk4haxTvc/4s/R9McjBsSGZswdKRdG0ek5w16vY?=
 =?us-ascii?Q?9orEWeWYmQ7p05cpBdtwwh+2PutM6Vh9shMsDaHoMtEKlxUMUPn5tZDzpp2q?=
 =?us-ascii?Q?SLXUDThxjYlh8ONTqnVyceC+GHc6JWO6u5zt2zl2QkQZ47g6DAbjVqOh3qd4?=
 =?us-ascii?Q?+aryElFR0p872lozI9Fz9iAiCVol/TMPHR+v5aLrTqBs0AL+rvajA0DfBXgz?=
 =?us-ascii?Q?tb7oiiCqgR3X2tcxyrY33BkzcsW0FTskImVbX08q/1Dc80vhZfJDjHUWMC0v?=
 =?us-ascii?Q?BACO+qAH+2AN5wutxL1QFgrwujppp2MW/BjS1YMCFZLbSmvdS3nMAKKF5WYZ?=
 =?us-ascii?Q?PSGHiKzQk/BwBMQ14a2K3/t1qA7DPGjCaTM5pC3vx5eP7532EJ4t6U2uieur?=
 =?us-ascii?Q?dNhoTEl3qYu2gAVzstlPHOYU7Z03zVSErrFQ8rrMxCZuJabLe0Z/JJF/qrdm?=
 =?us-ascii?Q?5/o7ogN9ocTEz7ojfbpd/bDKB2n9JuVLHBskvWn9hlBt+arL5+HS5VpV1fJK?=
 =?us-ascii?Q?9AedbXo8xNhkjGG0CqhkbDFXdqnZX0SVo4XpGsribQ2Z4DvduOnDoc+UvaGP?=
 =?us-ascii?Q?NAxtB3aH7wZTjwCekIOGii4mm3HUk54sQoq+CqGA4T/6Cvy9I82dQotqw01X?=
 =?us-ascii?Q?9ICqBxBA881dPnjhojaSbgay5yN4tf5NFhil/kAS2noVxhKglIwEO8l+jUfB?=
 =?us-ascii?Q?RzcpU/3DucabdQlA72gbTlROIJZnSq3aMh2XhB2sCs8rJBupCEFDNHqEW3Kq?=
 =?us-ascii?Q?bBpU?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <58F46658F1B9A4458E3B58A4F77D0D92@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a43a07d8-1b19-4884-8fb8-08d89f6f18f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2020 13:57:58.1188
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m/aDW4O04mYjxXbN7mg7S+eSYyB9+FIBmr8lA2q1d5s3JxrEcqMUJGZGzeHJ4W2D4xLhlWlCFrOq1m0YSlJLcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3968
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 13, 2020 at 03:36:13PM +0200, Nikolay Aleksandrov wrote:
> Nevermind the whole comment. :) I was looking at the wrong code and got c=
onfused.
>
> All is well (thanks to Ido).
>
> Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>

Ok, thanks. By the way, which wrong code were you looking at?=
