Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3495345E386
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 00:47:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237515AbhKYXug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 18:50:36 -0500
Received: from mail-eopbgr20050.outbound.protection.outlook.com ([40.107.2.50]:20738
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1350183AbhKYXsf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 18:48:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kl/kNz9qb1oJJWp5dfFwQcu23AzjlyUF1t3xiXHCeQwUrRaebQiuEfDVitX2IkHkev+rgX9ygdlaj9Xlg2c/xYLyOlFzV3XAeN0qzbmJJtAhWPMyHC9UuIMxEJf/LIJRvr9gSVmyRu9Ruq2CPRNsMrfmjCCNFbDHL52vFh2nfODB3T12DZUbc4onVNfZBuhHLY4uxgzUWGu2IO7Z5iNhGtQCtruNkcPYfWhjPVYW6UlYUo1afmVcd7kx1ZS0+FKWQK4Omlri2EHKwTtDH/fBeFYKq8Wr0U5rO/cGi6H6VX86P9LFw6g2kar7FPxIrkzRGo0ORnpcHyDwgPoeAZymKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y5IlAwEWwz5NZHbb5xpoJB/Lvlp0lmibIrYPNskNMUo=;
 b=DV83znUOeDobt8UHZvlsKx0nttKMojv7oKlVAffhNFRhlYRIcXSw/nWesvENbpMZBo16zz/bdLqnOj1mBN5XvLr05FJXXQll9KE+Scw/FAJbRHg5Ikdy7P6e2PzuFobX2bGIvZZYRfNQMeGSYaKFx1dq3TB4iUeRKP4KbhwbzA9VD7hPcvZ9d/A3ppEXYZm0QTrAJKAnhQBSPEMVpm3rl0cmOPrA67RF9Pp1Nd89JmF42NQg9SDX6V2Q1XpMp4jkE+DeIgop1W2NtTJcZVAOmWS06Bj8gI/EhoGFVySsUnjqfnF9k08VditL7MkxuWL6OeGbKVbLppBBdzX2jAmEMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y5IlAwEWwz5NZHbb5xpoJB/Lvlp0lmibIrYPNskNMUo=;
 b=l6kivhl1tLab/35Gn2t2Gc+u3MtLwwsqgfDeQF/usySc0OS1syBrGzmShvP2GN7XoQv52IbIAgwaIlJHl4wPKcejwRaAYrqgxbiAPmwl2WaApHN2g5CzDimSfcW3hbXhu+aM7VtzG9vg71R/eXMMIEvxzMc6RKXGnSBFZXHn5wg=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2302.eurprd04.prod.outlook.com (2603:10a6:800:2b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22; Thu, 25 Nov
 2021 23:45:21 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5%7]) with mapi id 15.20.4734.022; Thu, 25 Nov 2021
 23:45:21 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Po Liu <po.liu@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <atenart@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "Y.B. Lu" <yangbo.lu@nxp.com>, Rui Sousa <rui.sousa@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "Allan W . Nielsen" <allan.nielsen@microchip.com>
Subject: Re: [PATCH net-next 0/4] Fix broken PTP over IP on Ocelot switches
Thread-Topic: [PATCH net-next 0/4] Fix broken PTP over IP on Ocelot switches
Thread-Index: AQHX4lM06ld1R/REck2gHqZwslJbh6wU6FwA
Date:   Thu, 25 Nov 2021 23:45:21 +0000
Message-ID: <20211125234520.2h6vtwar4hkb2knd@skbuf>
References: <20211125232118.2644060-1-vladimir.oltean@nxp.com>
In-Reply-To: <20211125232118.2644060-1-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6f890bdc-5cff-4529-7190-08d9b06da51b
x-ms-traffictypediagnostic: VI1PR0401MB2302:
x-microsoft-antispam-prvs: <VI1PR0401MB23021F93199D56DCB5DA2D66E0629@VI1PR0401MB2302.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 552Bl+vN28k1MlcZxxD2EySnVB4EE0YGVmNBGorDrNaq6l0nHQKtz1JNucnXgovpLYe3X0Bx6w0kXrwXcc5Xiq46r1ZUu3MFtGWs1YuMAT3h/LkFFffT0kDr33ibz/wm7o5hVqmi7kDi8Cmffzu8iCMvCZmx2c8NBrbaCijkkmC4Y+lr+uWPo4ahEXFCKMeVPmOORJOa8caIuSeRy/Wg6NDAffol9JoeeAOdzfpduxSwTdC7eEmennJf4p+sz/8sdTh9g+g2DaLJ0pId2wUNmQ8/oPVzl35anj4PDjK99PkLUlVltMbC+r7n4RMu/FHNq+3roKvJak7pKabgCfItD1TYGnrhv5UtP+n7BWoixIl/kqQAsYnwGNUy/rKWd3B8xUHwB79YFQ43IXPgwuky773K2x7t00dLMqsVBmb3eXjHhgep5gk9JgV56KSk1Swrva7vuQKjxRjp8JTPeJXULUa+1ge8XJ9uSc+ArlTWI52+O4n2CoGvEGm7l1qlwUfO9zNWbnHrgdmMHxWkiDgRuSxYmP94/FW9PKb83maR/Jvn5uF4L5HGfsv+HqEbe8yVYGOvCFqYkA0TE8tWxVylE+YrwZMW9XSZ8IKwIXp2a/LC2/yj8h9D/SywGCMjYorn3ObuvScL5phoiIc0AYm0z0rI5Bpk0jlsfi3Tfld5bu7YYZDQCyrBaZrChGQBG2swvHNNz4f2+7LVZeamMjpUmsirYVTW7/v1KSjecRJZOZkk4cph/tNi4WF4z4SNknnc
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(110136005)(33716001)(1076003)(44832011)(8936002)(26005)(54906003)(508600001)(6486002)(38070700005)(83380400001)(316002)(66946007)(2906002)(9686003)(6512007)(91956017)(6636002)(66476007)(4326008)(38100700002)(76116006)(8676002)(64756008)(66446008)(86362001)(122000001)(5660300002)(71200400001)(66556008)(186003)(6506007)(7416002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ozDvCjzgJ/5tpX4SP3jbaXVPqx3uQQECVq+Q0iYQxxsseRyldQ8j2KvRasXI?=
 =?us-ascii?Q?I5+AU5m0/ZEAPGdLz1yQUWQkO0tOJhdRBkOLDJiX/b4jnOsuJrnuiEEBXXvh?=
 =?us-ascii?Q?oR4O+9xY8yL7GzqRy+k5GLUORC9qAfCK1cqEjXCrrs9OPT3S4AplckPOntlk?=
 =?us-ascii?Q?fr9fS5cTPOiDqFd+eHktwDqTzFsVeMUiGv23NSETNcXL64tr1J59dGv+q4JA?=
 =?us-ascii?Q?BjsQNsqsQY6/Zni0Gmmzo7vbg4av2f7CYSR67N2olJSgyiDNkrBdVpj2tLkH?=
 =?us-ascii?Q?0tXN2at0W+Z4hD+WPEzEgzHaRFlPERmDP38CbXzp+UHKtq/CxVrtzHqKMr6F?=
 =?us-ascii?Q?IfRqHpFR693mer7Srayu1pCwRMqEjsYdCyfEb6p6mTc4gD5rKNMyrrMDQKUA?=
 =?us-ascii?Q?oZvK0JBc5BuOW3f+AgaC/WhE7JRi1CtRBH+ZE5gJWDJqGhlkam7T291RcxVX?=
 =?us-ascii?Q?2dTewvEuLd7yWWiqTzp5V3LT4ddWJNmjhf90pID2XzGn5pyr2KkX65RVY42/?=
 =?us-ascii?Q?lFV136ffKKHBfwMaHgSSGlGedUugZ45ZZu/nbR9eBmBqxG7B+fWzbQ/4AanQ?=
 =?us-ascii?Q?ilEIw/jXs0vyjuygyywi+0i/KLMpzav9vs43JA+JxCiDkfRLK/z5+jLDXXmq?=
 =?us-ascii?Q?D1IT7mOie73BbA8UGwvpf67HPxzegamKSP0Iu9l2vsKkE1VhdA4CETCPVWXG?=
 =?us-ascii?Q?ZlvnQMhN7shOpS+U/UfZMeCMQNdq44/04OU20TZiwo93YwAFo27f5hi51La5?=
 =?us-ascii?Q?DSEzJ8IgGfKUjJcL6B4NYnA681+/X4wiRPWIGRHXZzyFIPWyWXzrpuplxGN2?=
 =?us-ascii?Q?u5+VH86G9iqclPoRORdf5Q1cckTdcQMDwz5H6U+qVxXy1n1ACpGnAAdnC1op?=
 =?us-ascii?Q?58Nb+RfIGZUeWDWih94Delb1uEnKDSQmdtxxmyyOJmWa3gj1c+L+YrTsC4eh?=
 =?us-ascii?Q?ahZLTx7dSxK32AaggQppx4/QzGjz2DW9Kco0EAQVaZKoE2wjwl3ac+5KA3ns?=
 =?us-ascii?Q?bMiFqaY6bZ4RlUi2RlLwyC0cUiFtAJ92Qg08Q3ygXiV3jonJxF1STme/TuMx?=
 =?us-ascii?Q?irK0ben7wm2egKXdCemToZn3O+jI94reF6JgYpqNvQDqGKemkNSNN1qooXXQ?=
 =?us-ascii?Q?mg/NvjXMsr5zMpmpzxZrulHF5BLEZpTkW7L12e/WpTZw6tFryvjvQo2XZ4XN?=
 =?us-ascii?Q?v/2TfJujf2oNy66WFMUpHfZIuHzhW9cm/+mdnhuV6QySt7vEDJcvVN6TFdmu?=
 =?us-ascii?Q?1ajL0pnYvFcWn07ffg7pmN/Uma4y/kwqSfDLS3D7M+tXcNBWVgKftyog6jgZ?=
 =?us-ascii?Q?uM+/OtxMjbHADO4GIql13+god0J9KNVS1VuvNucUqXwOFCKS1sT8D0N/IXba?=
 =?us-ascii?Q?bw6XdFnQt2rrOSkZRjIt0HyjLeHA/+oiBGYpB+7j+lFbYVl+y1sk8mSX/cMb?=
 =?us-ascii?Q?u3KIzavuO1qXP3vqBe2M9zB0sXXdfUohiPWRlFYjzbH6bQK+J2TaKdTe2FP7?=
 =?us-ascii?Q?vs2V6RSFsvNUebqQGXOdWZEOH9+wlqGkXFZ/pOgCKiU0w/aOM+PTFaNuJ8+b?=
 =?us-ascii?Q?1/c0zA4ddUYdLoyyY3uex6bWdGkCV2Nxody0nrhRqzSaWo4Db5Y83PNAdKB3?=
 =?us-ascii?Q?7uv6f49ehKSqodf58K4Lf+I=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A1D1CB1893D4434FA26651846F87E4CA@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f890bdc-5cff-4529-7190-08d9b06da51b
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2021 23:45:21.5629
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mdmfDWWk/gM8PlLlw4qp1/n/ZKLC5sE4wXsX0XkppxWL9PRtj8YID+fGEFvg5ZPF8S+rGhlaW9jaRzWdcp3R4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2302
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 26, 2021 at 01:21:14AM +0200, Vladimir Oltean wrote:
> Po Liu reported recently that timestamping PTP over IPv4 is broken using
> the felix driver on NXP LS1028A. This has been known for a while, of
> course, since it has always been broken. The reason is because IP PTP
> packets are currently treated as unknown IP multicast, which is not
> flooded to the CPU port in the ocelot driver design, so packets don't
> reach the ptp4l program.
>=20
> The series solves the problem by installing packet traps per port when
> the timestamping ioctl is called, depending on the RX filter selected
> (L2, L4 or both).
>=20
> Vladimir Oltean (4):
>   net: mscc: ocelot: don't downgrade timestamping RX filters in
>     SIOCSHWTSTAMP
>   net: mscc: ocelot: create a function that replaces an existing VCAP
>     filter
>   net: ptp: add a definition for the UDP port for IEEE 1588 general
>     messages
>   net: mscc: ocelot: set up traps for PTP packets
>=20
>  drivers/net/ethernet/mscc/ocelot.c      | 247 +++++++++++++++++++++++-
>  drivers/net/ethernet/mscc/ocelot_vcap.c |  16 ++
>  include/linux/ptp_classify.h            |   1 +
>  include/soc/mscc/ocelot_vcap.h          |   2 +
>  4 files changed, 259 insertions(+), 7 deletions(-)
>=20
> --=20
> 2.25.1
>

I don't know why I targeted these patches to "net-next". Habit I guess.
Nonetheless, they apply equally well to "net", can they be considered
for merging there without me resending?=
