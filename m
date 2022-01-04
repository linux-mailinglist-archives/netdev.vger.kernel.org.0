Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A24D4846E5
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 18:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234571AbiADRWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 12:22:19 -0500
Received: from mail-eopbgr140085.outbound.protection.outlook.com ([40.107.14.85]:31269
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231504AbiADRWS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 12:22:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kySp8QnCIfhO8I6nQz+glD8KuEChJOz0ewzegY0qyoHiA03bXa2GevohcWtuyArdoI0SEZ9v+Og20qnsbUAWyRPvSfMIMU216J6U6TU0xPXujZpyaWSvxqiVDDgYSQkvERbvZ7IsY7JjjLfyzdFK3zV+3BOJbvUyiTasQYokVl5Pl8eJvOGuJujl6CAvHpdV28xC1VzCD4PM7+WazFFpusT4xwywEQMZqNMQD8IHQnKq+eY2Cxo6yp62dGddJMXhHSmmyOMfsjCUyR+sIK6t1O9WhewL63Qi6SBhPEBg5e4xSSgibY4vJyBzocxhu2TwKkOj/vYHDbUQJc1tH+kROA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6/0lVtDg1JveZMndevFvhKIbmGYH4z74CtsDTjWBUrs=;
 b=c98mprkn5zns+xA6WYkepAuvawWG+kilzFIbVkIo/yFr2tu6UyBFqUz7Bn41MsWs/wNlyNUPCZhQ+yaplu8KpTk69ngoxsHijmHa4QCzoRP4Q3jFcCIRdQsCf5k3MIKJ/QMEgYKoicFpeNY92iIZc12mCpHGL4BpjD1CQ2ZZMaym2bS+kK6H7uN8K1XguG/tV4u4eF/ZZVK71JFb62AnMGgDThm3Z2I9YGgfDJX+TK6aLKmtQH/2jKZqtjWSrdMK2AAo9NxgEAoCRg+tB+N7H3842vF22P2PwmbnROuqwX59Zpu7a8UDmeSuFjDLYY4jZX8SDo+ODKA64rXIJGtpEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6/0lVtDg1JveZMndevFvhKIbmGYH4z74CtsDTjWBUrs=;
 b=ANTZrBg3ASnTL6DP8x1cwpqfbmAXkSsXam9Wll5awtnmPAqkk7jllaQL58TG7h0tXEGlptVku/3jO459l+LNgeTLkBNZtbjVQA5kYjc0fErf7G1vHNLSLJMfiUbjtX6AkyzKJzbWK65zL8lx1FSINsmfAlc4vBy3U4MlQqYDTEg=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4432.eurprd04.prod.outlook.com (2603:10a6:803:69::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Tue, 4 Jan
 2022 17:22:11 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.016; Tue, 4 Jan 2022
 17:22:11 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH net-next v3 0/3] net: lan966x: Extend switchdev with mdb
 support
Thread-Topic: [PATCH net-next v3 0/3] net: lan966x: Extend switchdev with mdb
 support
Thread-Index: AQHYAYAnHxwH7hYCMUSenjaq4QxtBaxTHDUA
Date:   Tue, 4 Jan 2022 17:22:11 +0000
Message-ID: <20220104172210.hz75ymy2uweing5s@skbuf>
References: <20220104153338.425250-1-horatiu.vultur@microchip.com>
In-Reply-To: <20220104153338.425250-1-horatiu.vultur@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aa0f1872-3eee-4a54-5246-08d9cfa6be82
x-ms-traffictypediagnostic: VI1PR04MB4432:EE_
x-microsoft-antispam-prvs: <VI1PR04MB44326DAF9CAB7C7EA6D51400E04A9@VI1PR04MB4432.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1169;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UFipPHuVipT2nuzkcTFShTJSYVJ8fKMNi8rrVIV6xG0amYs266/3fGyxHV4ABzkRPa4RRR4fZHFiHhnWD5xbFzOAbCs332i6VBLbD6MmkCVR+UAVHoo8SwekOhWgKc9oQJM0eo7PEzyuhHYsbe/6T28eLK2uRM0qtcC9zMIwEwjJk08f8FSVHuWCVfBO3/wJLZyXAmHddkzXzfezFTpm23KN8OPkQOi14vd56mcPL72VnueK3eZiN1RuacvD/sv+vngS6A6n2RL3IOWwMo9Wd92XCs6kSgUJgGjcW/FOUlibuLqGNWTAp8ZyOUDU4ChdGDTeeMTLx7xaqz2mFdf0BVhHRPesCx3fzIP8usNKPty0kR+L9ChDkGWmLH4seugrdI5eDIERdoJ/2rHRWLoptwu16+X6cjgLUfnbIm7WtBFstXDXwNBmszbDkTK7A7DpU1EM+DpMBDGzh32GgFABGwGndzP95wnKe3s7UR3pV622HMgdVI1OPlgxexdxsy2p0ewCpdf488eULVO9byW4RkOF0RA6LZexFnaBRRBsRYgx9sBu2dw84koYSeQSR2rtEjaaAPppwbJqqNgQcDejtfG8wT77yAkD850coPnY5yiIBKpIYj0iidEpy+uJLPBbDJLxYTtE4MQfJ2Bxa7bY29RTNRysORAUyID/sGZqNB5HjHFZEfiP9UuYY7WEg3IXrxQ77Eo2E5OYYFXeFaR+hA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(508600001)(38070700005)(186003)(1076003)(8936002)(4326008)(6916009)(33716001)(2906002)(6506007)(71200400001)(76116006)(66476007)(66556008)(66446008)(122000001)(6512007)(66946007)(44832011)(54906003)(64756008)(86362001)(9686003)(8676002)(26005)(5660300002)(83380400001)(91956017)(316002)(6486002)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?x8zIojkhVbmZtCAMIVxiG4FpqJEdce8q7UF1ues4ZH3NbSnF0i2WXRhkpz6b?=
 =?us-ascii?Q?TVd2a4uQT8nQcKN98IPXVAHO/hWRt+At6wOf+sMZ3fJAprnikJINEDRHuDeI?=
 =?us-ascii?Q?rzgV9vntyoLMF8UOuquRAq6DpXCUG8qNYQ8BfmkcTX302YCDxxkJGaBcj/Ek?=
 =?us-ascii?Q?yGClca6+4VP/cvpMb5zz5S69rLvlMXZIgOidN91LQ9N+g3md9j96iv7qy1PX?=
 =?us-ascii?Q?mcgzBl4fAUAhd3FkivqGxnIFfl/eDJkwwiwFzrEcvfQmjvMs8P7tuA1AJh/A?=
 =?us-ascii?Q?p3/gdFPLfBu1YdM5ZybuZIUC5WOF3uwpIDolVdmhZ7CzedgF2AdMzDfzg88O?=
 =?us-ascii?Q?fkxLJJn7HSxBvBxqNiah3SvoxTemEDopp22dgNsAoyWj3LfGhajFo2EaV5XX?=
 =?us-ascii?Q?o9bd+cpWd34O4+KpD42mdOD8IKqLUly2QUl/BP0we3hbkVmYuB2ry4gu3NN+?=
 =?us-ascii?Q?AZH+UIp+ZuUpR7buZvhMr+9x+2bz0plQcyQeNM14oqD+hktb525DeJ5/CciD?=
 =?us-ascii?Q?dus2bzTCFNh8w54sgNmNnFHeHr+1qVZ7Ge756MQWQ51nA4dRaGRKFSSxteBd?=
 =?us-ascii?Q?FiN6iq8smrvxqp6kpQRsLv0Q99XZ/C6y3jZr3Xx7Nw2zDAsxAjTIOblgNDUh?=
 =?us-ascii?Q?Qf1ZWmAuHpL/3Pc3ub9s43hzkNrH6Jo/vlJyhqml3bvQbWyP2z3iGjz9J359?=
 =?us-ascii?Q?p8dWNKx3hWZiY/kbViaBNJ0nSBCyqPrV/xk14j6rELk8By5Gd8PjjUw2drhd?=
 =?us-ascii?Q?ru1BsvQ/FPp+G41d6mR2MS9TotzNgft5jjt1h7446ADjm7zcsQi3pkTSk28o?=
 =?us-ascii?Q?W6DH7nUapQcBNXNB0ew51dBXdJYoJxUSJ7HOU7CvikfWaxxETFPh3bqnpGTE?=
 =?us-ascii?Q?CQlMeuvA5XtDYXrMxn42oA/jr+cccTtZ7BXeLzDLwKPjhEatKwyNRisqQhad?=
 =?us-ascii?Q?0P/OM0WN2mMVEmZj4iTml30uzl87vocsEgqnXDawTdeJ13UysjlGtdzcOOjk?=
 =?us-ascii?Q?YffjQ90RXw3Xg+Y/1Y95FOsWGoimHPe/bbWp1V9ByQmE2zb2GjQrpPnwbSKd?=
 =?us-ascii?Q?yluO63xwoRybRfyxf8Im2TmS9SmIxOcZTTM6GU24+326vMdZeg2OgmFN+0SA?=
 =?us-ascii?Q?HfKdnXzXcZY80PqixvmHDQWGvs1pVuvMegkKKLIshN89Q8GnLGlXq2tH9Vvf?=
 =?us-ascii?Q?tml1QetneB4gLwXb87nZwYL5dJThNGnQ4hrj8WhjAZ//EPDETmLoUQISIZEY?=
 =?us-ascii?Q?xb8F5AUuQMadAj7vwm/jqFuZIK9yKMgjVBf/hfIcsmYJZHB/guqRQWvJEWND?=
 =?us-ascii?Q?o39HfscGj8WcYgefuNK54m0Zf5fixSYp3T2S97NSdSmw/T6v+rJ6ZIvqZxOl?=
 =?us-ascii?Q?KQfeMTXKvTR+1LtkYeLGiDRgOQR7uQGbfpSWTW8qeDixkWwJKkw+b7BS4Z16?=
 =?us-ascii?Q?PZ06W7xyK5B386BoJlGkGZyCVQ3xfszwvDpwrxiG8PJQM1YmL5gue3GuJFJm?=
 =?us-ascii?Q?bhmWbvD0MlHtJ4iKDEtnGEsM3GfXkODVg2hpq8f6IAN2YZZ0dXMcQR4ORc9l?=
 =?us-ascii?Q?H6Sq9/rudM0cUHZbYqrwidh07e2yJP/lLT9RRCSeuWvTItgkotoGt0nqpP1Z?=
 =?us-ascii?Q?kdshKyveOY6jobAnfg3sO8k=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <308DB1EA613DA84E8C7DEDF707C3207F@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa0f1872-3eee-4a54-5246-08d9cfa6be82
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2022 17:22:11.6274
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XZOgo/0PY+doFud5feTrU9Qs7XKM5G4OTESAh+Re1a/HTalPjm4FhGaPBVhKJEjU6P3Cs5O2lKhmbcpkgOmnPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4432
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 04, 2022 at 04:33:35PM +0100, Horatiu Vultur wrote:
> This patch series extends lan966x with mdb support by implementing
> the switchdev callbacks: SWITCHDEV_OBJ_ID_PORT_MDB and
> SWITCHDEV_OBJ_ID_HOST_MDB.
> It adds support for both ipv4/ipv6 entries and l2 entries.
>=20
> v2->v3:
> - rename PGID_FIRST and PGID_LAST to PGID_GP_START and PGID_GP_END
> - don't forget and relearn an entry for the CPU if there are more
>   references to the cpu.
>=20
> v1->v2:
> - rename lan966x_mac_learn_impl to __lan966x_mac_learn
> - rename lan966x_mac_cpu_copy to lan966x_mac_ip_learn
> - fix grammar and typos in comments and commit messages
> - add reference counter for entries that copy frames to CPU
>=20
> Horatiu Vultur (3):
>   net: lan966x: Add function lan966x_mac_ip_learn()
>   net: lan966x: Add PGID_GP_START and PGID_GP_END
>   net: lan966x: Extend switchdev with mdb support
>=20
>  .../net/ethernet/microchip/lan966x/Makefile   |   2 +-
>  .../ethernet/microchip/lan966x/lan966x_mac.c  |  36 +-
>  .../ethernet/microchip/lan966x/lan966x_main.c |   2 +
>  .../ethernet/microchip/lan966x/lan966x_main.h |  26 +-
>  .../ethernet/microchip/lan966x/lan966x_mdb.c  | 506 ++++++++++++++++++
>  .../ethernet/microchip/lan966x/lan966x_regs.h |   6 +
>  .../microchip/lan966x/lan966x_switchdev.c     |   8 +
>  .../ethernet/microchip/lan966x/lan966x_vlan.c |   7 +-
>  8 files changed, 584 insertions(+), 9 deletions(-)
>  create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_mdb.c
>=20
> --=20
> 2.33.0
>

For the series:

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>=
