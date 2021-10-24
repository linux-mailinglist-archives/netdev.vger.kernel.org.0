Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52961438AE3
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 19:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbhJXRUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 13:20:49 -0400
Received: from mail-am6eur05on2041.outbound.protection.outlook.com ([40.107.22.41]:63681
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229638AbhJXRUs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Oct 2021 13:20:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fFyFBxWQNCwqVepzzmDQQrh4AZiQZf7/BLn8E8kZqHkKEP0hXVvy7WIhlT22GQ0VMDDnxvRNALvT6Y2pLvyPzcire81uWPRWB6vkCNGUupGxiEwRbYHaZCSLi0STEwRLTQZCMmY5LMAV+cgU7nBTVSF5y4BSqTuQpYuj1IDSqMCPvHzHc6AQ1VrK1tiPWB7cBsamAOTxnxNAFG02fRkVwfKtdTgqQUSWmgf7c9xk5EBCNXp2w78/RetqTedvJh05FGDgmVS6paDaWJ3dADKnxXI9rOqEphZXi4wGp0l8H0r7ACA+9vsl6qCxF/m8caRhqr99JdJf6v4Ihclq/aknsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wdllH7dUFPSQnF4GQrZciCCOLZSj3CXpubG3zPH97Cg=;
 b=iBVTBNXyp6EAxPb4Av3uYsNNqL33ASGEolw4xIyON8t4IAeLWsBLW5smEbX50GHQJoLUWV+Z70I6tm/7zNH3m5u+vesHksQtDDGboLaUoFWwcg2rLjT2J2NoLmvUr9wXF/HlSq8R80ZZCYUisM+HlW98pn+NaddtsIGP28w+MVJZ3Gu4gv7R0ddE6kHw+B+DFLHd7fOLkwNLgdbSfwQT7CgaG83kUfx8HSKZnGGO1pTRvRzwm6HqDIIt2tcBTD9zYJYsvZl06mkMxxo8RRUVTifjsyQIczxOqMvP2sbhmKo2Q21yIrUHdUm9KUYrG5f+KQ1/4FhM+pdTrjIX8dbuzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wdllH7dUFPSQnF4GQrZciCCOLZSj3CXpubG3zPH97Cg=;
 b=oDuvSYd242JFwF/L+Niu1AgxR2mdcxulsL4ZHPfY4zakz/95c/6OPiND1C+LEim7E/i7wYiarXJFWiu9JeXtrDQMHP4EOgdn+r2+wNcHPhlr22XSI0zFjx5ZULE56q73ZR5jxqxB/lHr6J9F0RSqNfSYyCOfq6HQ0NeW0e2xF5k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3552.eurprd04.prod.outlook.com (2603:10a6:803:9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Sun, 24 Oct
 2021 17:18:25 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Sun, 24 Oct 2021
 17:18:25 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        UNGLinuxDriver@microchip.com, DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        John Crispin <john@phrozen.org>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        Egil Hjelmeland <privat@egil-hjelmeland.no>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH v5 net-next 00/10] Drop rtnl_lock from DSA .port_fdb_{add,del}
Date:   Sun, 24 Oct 2021 20:17:47 +0300
Message-Id: <20211024171757.3753288-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P193CA0123.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:85::28) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM6P193CA0123.EURP193.PROD.OUTLOOK.COM (2603:10a6:209:85::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Sun, 24 Oct 2021 17:18:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 797771fb-b2a1-425a-22b8-08d99712498e
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3552:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB355208406B8EBDA57C546FE7E0829@VI1PR0402MB3552.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nGV959iatdZ1A9gjeW71hEp1QMg93U0CWvqqsHzFBgEVFF8ZP8TyPAmzEsogJQjub1raECWQxF4ZNAOHEDqJxAUopz5NVwBjNiZ1YwzXg4inr3hJou9saErRzUKJHb8Ni1rYWBbLJq0U0QLf342aQ7FU2YhD79s7T5q+VzEtuMimpU9Ib1NeJofBql7YGcZPajgqEuu5eYxBPktxUhb275NlgEIEudfXKSHD2AUeYYkyG60xEnu26SQCXv0DnMkQtNeO3GiAFshRyCBzydcYa8St6i/Pl2bxw+HeUdo+8zAb0Js2EP58t4f7Zo1oNFQZS0KiPtC9FyzJyeqnGA8H84IJGBOr2pcsB4h3GeQ0e7rOoFbxI4xx8X+ZcW8JILsCxJEZMU7VEwY9ejhBedrjdMiB//9vBjRVTNrDzdfkWGXHddaXG+Krg+Pq+6TVTob/fuZDVd2OCg8zT6U7hSJgAFWC4rcYI6C68KjdK7gRXRL5gr1DvpzeBG3LUAcoLTkxKxKv1GpH/RV/0nJTzdnwK5q09TYIMA+9XamJGVkl19hrogZ0TYOQw79qqkKXgjOHtWrm4OOyTIUAG27g/+suK0r+dVAHw+DdX1+xZcNhBDxQUeV3x/CS3yA5z388JZXPLN4HyjO6r0NJbuj8IzKtkVIrU0lhnl1WjpM5APouYwDHzH5TNZrdY9+uBmJFbHr4IgzRmxRvQg5l+bUlMok5ONrrH3NvUe8cv9NlsFaE/x3ylYNy6UtkJM/EPT+Sgyk3V4s4B0cECqOF70Ti5ka0HN3il2qNZnFt2NeAgoHKsE8m28Hq1y+7eTyhdEYv+brx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6916009)(966005)(6666004)(316002)(54906003)(6512007)(38350700002)(38100700002)(26005)(2616005)(6486002)(956004)(36756003)(86362001)(7416002)(8936002)(1076003)(186003)(8676002)(508600001)(44832011)(83380400001)(2906002)(66476007)(6506007)(66556008)(52116002)(5660300002)(4326008)(66946007)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?n+TVE6gLn0/F1Kk8dfPCQp0lxPb2UiOKj/PxU89DuP7ZaIS0F8DB+gu56sP7?=
 =?us-ascii?Q?SS/Ag/2Cl+xzAfGLjC+rDqo2s9pK+HTHTtoPIEYbNFtyDLNULBgn9cqyQVO0?=
 =?us-ascii?Q?IPGy5KRHcSIeoMwK2aM73PXFfTQ+LIFApOG8GWiLcBSE1GTuyj+uVLhZMDv7?=
 =?us-ascii?Q?aepchKtcAYyMLu/unAz3skpXKDJDCClw60hPXs3CIsHdQvNb6QgqzR0tkNxH?=
 =?us-ascii?Q?ttIK6Le7mH+nx/aiazqHk5bXtl3JUl3xRtsTE17VF06oYEoGTzbXcISqv0Gs?=
 =?us-ascii?Q?9hdvFNN69AYw72BQrHDstEcPvrBWao94qC7dOjI2bdNydvYr3jEFej9wfwxj?=
 =?us-ascii?Q?FCTQyQjKn4YYwthzfnsvdrAxUBGJHTjGRgtjMRsSDOq2oa3sUVqEOPWrfbPQ?=
 =?us-ascii?Q?ncy0Wqwk0XXol80JtdQFKvGwX+Q+3uqV9S1GHFMbqeqYA1J3zZkYAYTaIkQZ?=
 =?us-ascii?Q?AwwaLi1T6rnOjfkz2asJqyVIUPfeOyBwNBuc771557RMSWqYYSZDVjiDPXBU?=
 =?us-ascii?Q?lL5kGKdP16hcgavnkx6OZnOcsQeN9wK8/OedD8POOG2dYdGiJICsJwy4rTbb?=
 =?us-ascii?Q?DWleauG0SXYTUdqufiaT9ddWAYOXHIGxrg/UY+xYqc4d/5UmlkgU5YdxALCW?=
 =?us-ascii?Q?DHGB/ZzAy7EfT5RMY2ykLBHOL/YpN3IAoAofM9UDkFxOIa2wFodC7QrPTjb0?=
 =?us-ascii?Q?l+yJYZvOxPFSYt8emSR4wdtX1Ex8mOO70fTDxgloCxEpj+HcLF1pydlc/09H?=
 =?us-ascii?Q?GRiL/ParO1sY9vXdVaS8cGNN3KnadJTkf2Ja/d7RcuWd5p2IiN+ZkcGcUfzD?=
 =?us-ascii?Q?ZAbN8XQrX3yskVaD1oKrGbY81tdsI7QsQPIav7bvyPnQlUryQMeK7m2sJ8vX?=
 =?us-ascii?Q?rOGdMI8wA9rTKLYq+QLO0l8q0lqsjAUNIBRhvM6PvyHjO+5VMZIRDapQxaji?=
 =?us-ascii?Q?X3E2yNkwFW+eO9Spe4IPeDsIPtjluKQRltHqIcQB86PJ3L8ef8ISo6qU4qyY?=
 =?us-ascii?Q?nwbe8XVpkL7rG/rZxsr9VQpd2xCyGW6uRbCXErtymF+EQWwDXKJee9+2bRko?=
 =?us-ascii?Q?CtKB2Bp+JA/YMBnI5kff8DPgNcIPRxUNTekbhMTWUyXZWIl0aoCWY8l17FSD?=
 =?us-ascii?Q?8QRwCQYk4V9FIA8mLSmsXwnENAOezwMtMfE453ZwAetEcp+Hm8uHM4djx9+p?=
 =?us-ascii?Q?eCcIe228mP4ZehB7cwul5SFnurEQjOfbnCnJr9Uu44tL6fG2K1ogJNuWwswD?=
 =?us-ascii?Q?Sc2XKzvyjtIK3rTSLMv4eOn3OSS7BFgNarNOpIcsZLEnO9FBeuMQHUwSw+mX?=
 =?us-ascii?Q?TilWWP5iM4zSrI971eJ7uVBeLby+H0iNp8ClbLBvCS1+bNQtNCVd3IK0fwiQ?=
 =?us-ascii?Q?OX7rjbSdWeGUPBV8Cx84BJAnN6+wbGeO8Fr8fEcIc3LIwxGNs2L0jdG/SGeH?=
 =?us-ascii?Q?kZIx+rbPAMWgJn9a8Z5X1rVZusSl1lXk08/+IAz1Qf2GznOy41s2I94vH3D6?=
 =?us-ascii?Q?yNgQJR7O5U93xynw8X/BKAid2y8wdrY6R9MPlSRirDmH6hWMCcqPTUUBvpvi?=
 =?us-ascii?Q?Q0I7QZbA8KYJHrLZOm6jdRqnb04eXM8m2Y/vTgfaVNA0AoI1BwZc5yXJduQW?=
 =?us-ascii?Q?wxN3C7bv/pK/CP5CDwa0FL8=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 797771fb-b2a1-425a-22b8-08d99712498e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2021 17:18:25.0732
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oVyXX3vUo+QKRPJtwbO4KQ2dEF7gJ8WnXf9Utz/t1mSGC58Ud8ucBgLnAVdfMoVtcoCO5AWgRolkIyMXr/XKig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3552
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As mentioned in the RFC posted 2 months ago:
https://patchwork.kernel.org/project/netdevbpf/cover/20210824114049.3814660-1-vladimir.oltean@nxp.com/

DSA is transitioning to a driver API where the rtnl_lock is not held
when calling ds->ops->port_fdb_add() and ds->ops->port_fdb_del().
Drivers cannot take that lock privately from those callbacks either.

This change is required so that DSA can wait for switchdev FDB work
items to finish before leaving the bridge. That change will be made in a
future patch series.

A small selftest is provided with the patch set in the hope that
concurrency issues uncovered by this series, but not spotted by me by
code inspection, will be caught.

A status of the existing drivers:

- mv88e6xxx_port_fdb_add() and mv88e6xxx_port_fdb_del() take
  mv88e6xxx_reg_lock() so they should be safe.

- qca8k_fdb_add() and qca8k_fdb_del() take mutex_lock(&priv->reg_mutex)
  so they should be safe.

- hellcreek_fdb_add() and hellcreek_fdb_add() take mutex_lock(&hellcreek->reg_lock)
  so they should be safe.

- ksz9477_port_fdb_add() and ksz9477_port_fdb_del() take mutex_lock(&dev->alu_mutex)
  so they should be safe.

- b53_fdb_add() and b53_fdb_del() did not have locking, so I've added a
  scheme based on my own judgement there (not tested).

- felix_fdb_add() and felix_fdb_del() did not have locking, I've added
  and tested a locking scheme there.

- mt7530_port_fdb_add() and mt7530_port_fdb_del() take
  mutex_lock(&priv->reg_mutex), so they should be safe.

- gswip_port_fdb() did not have locking, so I've added a non-expert
  locking scheme based on my own judgement (not tested).

- lan9303_alr_add_port() and lan9303_alr_del_port() take
  mutex_lock(&chip->alr_mutex) so they should be safe.

- sja1105_fdb_add() and sja1105_fdb_del() did not have locking, I've
  added and tested a locking scheme.

Changes in v3:
Unlock arl_mutex only once in b53_fdb_dump().

Changes in v4:
- Use __must_hold in ocelot and b53
- Add missing mutex_init in lantiq_gswip
- Clean up the selftest a bit.

Changes in v5:
- Replace __must_hold with a comment.
- Add a new patch (01/10).

Vladimir Oltean (10):
  net: dsa: avoid refcount warnings when ->port_{fdb,mdb}_del returns
    error
  net: dsa: sja1105: wait for dynamic config command completion on
    writes too
  net: dsa: sja1105: serialize access to the dynamic config interface
  net: mscc: ocelot: serialize access to the MAC table
  net: dsa: b53: serialize access to the ARL table
  net: dsa: lantiq_gswip: serialize access to the PCE registers
  net: dsa: introduce locking for the address lists on CPU and DSA ports
  net: dsa: drop rtnl_lock from dsa_slave_switchdev_event_work
  selftests: lib: forwarding: allow tests to not require mz and jq
  selftests: net: dsa: add a stress test for unlocked FDB operations

 MAINTAINERS                                   |  1 +
 drivers/net/dsa/b53/b53_common.c              | 36 ++++++--
 drivers/net/dsa/b53/b53_priv.h                |  1 +
 drivers/net/dsa/lantiq_gswip.c                | 28 +++++-
 drivers/net/dsa/sja1105/sja1105.h             |  2 +
 .../net/dsa/sja1105/sja1105_dynamic_config.c  | 91 ++++++++++++++-----
 drivers/net/dsa/sja1105/sja1105_main.c        |  1 +
 drivers/net/ethernet/mscc/ocelot.c            | 53 ++++++++---
 include/net/dsa.h                             |  1 +
 include/soc/mscc/ocelot.h                     |  3 +
 net/dsa/dsa2.c                                |  1 +
 net/dsa/slave.c                               |  2 -
 net/dsa/switch.c                              | 80 ++++++++++------
 .../drivers/net/dsa/test_bridge_fdb_stress.sh | 47 ++++++++++
 tools/testing/selftests/net/forwarding/lib.sh | 10 +-
 15 files changed, 280 insertions(+), 77 deletions(-)
 create mode 100755 tools/testing/selftests/drivers/net/dsa/test_bridge_fdb_stress.sh

-- 
2.25.1

