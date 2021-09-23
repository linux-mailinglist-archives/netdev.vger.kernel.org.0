Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A18044161FC
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 17:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241986AbhIWP0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 11:26:45 -0400
Received: from mail-am6eur05on2083.outbound.protection.outlook.com ([40.107.22.83]:44215
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241985AbhIWP0o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 11:26:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=icUIVK4RRQ5N+zHIE9I14gWbnIBI34BEQ0YTcKay5AcUNJXEJ2xkR27I00pXZMbu14PDocILeqkXLceRZpEyl+7q8Ark7AoLEsKwCt1yRQAtdczVfq7aRX4z7VOA+I5etxbH6CPgs3ZlD4KDV8cLCwnwYIqrr0p/+YDQFzOf8eeZKieoYyd9vzugZSG7Qa0MY99chLwg+tXrHHWKuYEHYjKlozXthls62KMpB36kXll9OVJ+hk8134nOr9y1rQJDrLWWw/25qRiLDB1SB0Y80/dd8zVzJ10QX+LkU8qyoACDlI7XmolBNceFYiGHuZ5FfeM88HSD6V3/opJtTxhp7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=k42a5tIqn2xEzDPzMf/8PXfnhLryjF3qHoPzMzUAUC4=;
 b=Ox1JGMcle76bTOvgunguktuK3jdxcM1Kjuqo5Cd8xPgs785Hq28NzceSjyfR1IQ/qH3NFknk7X40KBd68wrd/kixQUg9KpErG5ECqjR+dq7k8DZAwrzXFr347NfGx8MiOMhdRT0BzXJuJoa1ZYBg/cy0Xq2NHJ1nJMp6CLzH4saq1giJVWyCNSPf9rDBkjMR4RcEeQW5KNYD11sggQ9m7ZJvSXesUhqzaVzHt3iqFNZaebQH7kjjMUMgzWjPYkVZ2b1lFlryvr2Ejr+VwwkpMv4zxchVMRjAmYOpBmpt5HF1NeH8/PRYWiyOC8yKVglxiqeLprOA3aD+MuFvWu7JwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k42a5tIqn2xEzDPzMf/8PXfnhLryjF3qHoPzMzUAUC4=;
 b=aFOhGSGvI/eNRzNa3xf1QNxa43W3tKifhuC51z+ADSnYQL9DQB0U1JcJXj636814irgx0FUQ9+CSr9EaMdrX6mUMwzLXcacXTN1xYqzAQWdLiMchy8GipISP13hCQBXpxmVjMSrRSq6lXdy4rYi84bmAuoysYlhwt/cL5o6omG4=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2509.eurprd04.prod.outlook.com (2603:10a6:800:56::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16; Thu, 23 Sep
 2021 15:25:11 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4523.021; Thu, 23 Sep 2021
 15:25:10 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Roopa Prabhu <roopa@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH 0/4] Faster ndo_fdb_dump for drivers with shared FDB
Thread-Topic: [RFC PATCH 0/4] Faster ndo_fdb_dump for drivers with shared FDB
Thread-Index: AQHXls+U+tbP+byAdEOJ1ujBjTSpAqux8MUA
Date:   Thu, 23 Sep 2021 15:25:10 +0000
Message-ID: <20210923152510.uuelo5buk3yxqpjv@skbuf>
References: <20210821210018.1314952-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210821210018.1314952-1-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 16da862e-a158-4955-7b86-08d97ea6553c
x-ms-traffictypediagnostic: VI1PR0401MB2509:
x-microsoft-antispam-prvs: <VI1PR0401MB2509807D03E5148251216A5EE0A39@VI1PR0401MB2509.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: c5nrw2xqry6XkTMSM08LT6nMukCbB/o7lTJT89mkw/q3vvpeR+G5ARcXgf+PJFPnNY3m8lWchu0zWII30aj5xZqr1Kd+jXijRMaDkbLkFzDx8hz5SAW83z+px1v3Sfs2TR0k4hd1/mKS3ZChr/82dlhqroN0gezMtXfCPNeAJcNbSSYo8EBnCZV2kHZFmdSNO0t4O1ivUldrzxDtF1Dccr/OIXpNgqTSvh9TEVYTfc8iNriyRO+dW23nADD5JL1rG6cutCfa4m72IJ91l/lcIBOTJCu9BmrSXVEt9B/ghuT/iF1puJ34EXKqehM5HF4rCOnyiaEAoyKrg+L3wzVsdzt57rN4t1n5PQes+m78ZWjYEzriedaiH+0EpEP4IquosgHDQHwazxHf/q9Or5saNVGhwfTyA3yCbCpppVyXsH7Ant3VI7t4r+MGd3EfzjRfANij7z9YnjB+hguCHRfQTGrJ55+EH9ukQzFh0GKGmWISRMLw3KTP23LlpmwmGrnsoK0FieshaqymdhSJ06aYGpMz3iU2lw2h/PnAReQ1fUb4DZ4f2rpCD5HJaXp/IZxnQULSD2/hsplIUD6zfm6ZDEL9vUUffVGxH3krRvqMEADbASrWuNWy1pZKyhHcZZ7ZrHrLeOYgy3FmFUvwTEuPOnjcNdRO+S8EncVnlxZ67+AGLY5APMO4QAIda4NvPvizju0hKzEQCEn0g8zy1saFuatNUZ2Iwg98/WKNsytJJv143H+b3mcWxbEPFbgfhNz3UxERMSRl/d/2xdQZCCv/tA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(6512007)(8676002)(6506007)(4326008)(1076003)(86362001)(508600001)(9686003)(5660300002)(33716001)(66446008)(64756008)(66476007)(186003)(26005)(71200400001)(966005)(38070700005)(110136005)(316002)(91956017)(38100700002)(8936002)(6486002)(76116006)(66946007)(122000001)(2906002)(66556008)(83380400001)(44832011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9acrONwY/nJ6lGvXD1RJrxOS21MrYvqoeBBT83zcYcyiKKBPVMYCLYPyle6y?=
 =?us-ascii?Q?Z3JmGgPz7koz4JWtlDVE4smB8BJT6r8Rr9T6XU89O75rh/e8jaQdMnTj3KdL?=
 =?us-ascii?Q?JWMHlcB/lVv9AT3+97XxFjGFyK/p1sr7cE3YvIFkaGscddYhl/mTpca6eEhP?=
 =?us-ascii?Q?zZL4SsbLRv14fFoCC8MDBR9vpqTRIXgOdgaKqa17F5QZMYNTa63Rgh06V6Sp?=
 =?us-ascii?Q?fBgmkIAny/vUtCEjYHCO3o6TCQDare+LRiBiUdgXpLu6oUY1vUSZPs225iwG?=
 =?us-ascii?Q?IqECOwvmPb0pL0/6m22gOA4sctyBQOzss9efNZYYyYAUW9kbhiqkDICjwtvc?=
 =?us-ascii?Q?2AxHL8uZ0ENVEHSEuO7KuW05DNI8DvmDNNPcOMljgFxrIkR7uZIJo/Yy0k/3?=
 =?us-ascii?Q?DLdWeasZ7yt+1q+3VAw67PDgi7LHuLAXTAglc8MLBElorVgaC29/SEO6rjcG?=
 =?us-ascii?Q?9eLTgMraKkq9ngpt7n4I7Kzj4RhFyeFhK1uhHa5qsoiO2yICmE75vSsrpQ2R?=
 =?us-ascii?Q?bPmgNyWavy+aVH2KXe6FkZvfxspQuorpHrjh0jP3KAjtTrF1I8aUJer6rUFp?=
 =?us-ascii?Q?Y/dtsei2TeRd4H9kd8c8+R9cCAyhwloBcuxFmIgAxH32gJoIHkn7K4D4wzYD?=
 =?us-ascii?Q?rrAEtBuHJLmrYCQO4YdRdihlf3GnK+EijwkadvtbMTY0tum0w4HNmampj18X?=
 =?us-ascii?Q?lJO2zfAn1LsfahRwCsiNA7TA0xg9cZ5UMDb5vf8hLkw8MCqxpmopMPElgXE2?=
 =?us-ascii?Q?ImRQk0hBmYd2/IGNzJdzO+uJtVolar0mISk/k66bwPm8pNH6pPSJC/bTi0hV?=
 =?us-ascii?Q?Q4ZcqGxadWQY6nnEXVygY1qCwHkCMa8YK+mrs0+PQIU9SCgMYgLGayxhRdld?=
 =?us-ascii?Q?JNPGNNRV7s5Tq0piTbuauyc2BkAzVV3bGBMf2kbn2CcGhPZUF81MSwMq7jHT?=
 =?us-ascii?Q?GGrwDbPionOhaMtSfO5eblJCj5SzYXWB1EScV3a+zpm+Ci4H/HEH66dWU/rH?=
 =?us-ascii?Q?Y4Cvxnz05jZq5jQdQQQ+6YzM5Yn2VI2i29n7HRFZMfntLYtnh1ztpFQgdpEE?=
 =?us-ascii?Q?+71rJnvxJiJOR0ZhbQgHYydwZupm/wZZVsTjlna35K4cb19jY0lMw3I6OQDH?=
 =?us-ascii?Q?hwTQirh7A3fRNBKKfN5JTzOGst120sqg9XxKBIBXzuVrBegCUq2g62Ycy9pq?=
 =?us-ascii?Q?7zsB+aeb+Q+BmV02hy2bDIT4aybhLt8TH+H33gYR68BQ9kfK2OppFAyuomnH?=
 =?us-ascii?Q?1yGC+tWGCkDXxyOY18MCSFlz7Ix9Zbp+6GRCou+qrkzmjncHlTogI1IGH9CQ?=
 =?us-ascii?Q?QCgXmwFcshRuCHxQLbjizUrA?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DCE08FC7D05EB04A86845820BB0AFF78@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16da862e-a158-4955-7b86-08d97ea6553c
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2021 15:25:10.8114
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QEqLwixzbGpdVoq+VOr8hs+ytoVlKqj3fSRTO+Yfhw4n6fAgJtJ1wQSv6B2HiMpxjVbMI1rNrd7X9tHjK6R+dQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2509
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Roopa, Andrew, Florian,

On Sun, Aug 22, 2021 at 12:00:14AM +0300, Vladimir Oltean wrote:
> I have a board where it is painfully slow to run "bridge fdb". It has 16
> switch ports which are accessed over an I2C controller -> I2C mux 1 ->
> I2C mux 2 -> I2C-to-SPI bridge.
>=20
> It doesn't really help either that we traverse the hardware FDB of each
> switch for every netdev, even though we already know all there is to
> know the first time we traversed it. In fact, I hacked up some rtnetlink
> and DSA changes, and with those, the time to run 'bridge fdb' on this
> board decreases from 207 seconds to 26 seconds (2 FDB traversals instead
> of 16), turning something intolerable into 'tolerable'.
>=20
> I don't know how much we care about .ndo_fdb_dump implemented directly
> by drivers (and that's where I expect this to be most useful), because
> of SWITCHDEV_FDB_ADD_TO_BRIDGE and all that. So this is RFC in case it
> is helpful for somebody, at least during debugging.
>=20
> Vladimir Oltean (4):
>   net: rtnetlink: create a netlink cb context struct for fdb dump
>   net: rtnetlink: add a minimal state machine for dumping shared FDBs
>   net: dsa: implement a shared FDB dump procedure
>   net: dsa: sja1105: implement shared FDB dump
>=20
>  drivers/net/dsa/sja1105/sja1105_main.c        |  50 +++--
>  .../ethernet/freescale/dpaa2/dpaa2-switch.c   |   9 +-
>  drivers/net/ethernet/mscc/ocelot.c            |   5 +-
>  drivers/net/ethernet/mscc/ocelot_net.c        |   4 +
>  drivers/net/vxlan.c                           |   8 +-
>  include/linux/rtnetlink.h                     |  25 +++
>  include/net/dsa.h                             |  17 ++
>  net/bridge/br_fdb.c                           |   6 +-
>  net/core/rtnetlink.c                          | 105 +++++++---
>  net/dsa/dsa2.c                                |   2 +
>  net/dsa/dsa_priv.h                            |   1 +
>  net/dsa/slave.c                               | 189 ++++++++++++++++--
>  net/dsa/switch.c                              |   8 +
>  13 files changed, 368 insertions(+), 61 deletions(-)
>=20
> --=20
> 2.25.1
>=20

Does something like this have any chance of being accepted?
https://patchwork.kernel.org/project/netdevbpf/cover/20210821210018.1314952=
-1-vladimir.oltean@nxp.com/=
