Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 742133D64F8
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 18:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234253AbhGZQR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 12:17:58 -0400
Received: from mail-eopbgr00065.outbound.protection.outlook.com ([40.107.0.65]:22840
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241196AbhGZQPk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 12:15:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kxaHPcMzjNWpd7jP3GmqEr8nnfAq0nMTNhG/r7sAC3rG9jD3QPb3w6I+LxF8+vPvxZkhFN9HKm2WvB93NcgU7zGiyAK4BSa4aXf3cFeAv4JYzY5NF3LIBmT9Uth76TfFFGrOyeJXEE+MIF1dob0AgELjtXfWE6ZTAHZT1ooMJaj3xtLhSr0yjqjSAwpQrb1k6fTgg1BFGrsjOPU+y6FqECp4vnpaFwnpl6TTZmoKAxxxq5NouOZJWpJhYTgqrI2YKeBt2Ym3gHGTjM5NKyvVd75J8MnkC82RvsdhSpCA3SWm/qdi03ebuCNShkZ/xx0gAquuqNRGRWjCyeFqYR/pjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O+H/gpV6Kl/UMoP4E5sDMwPZ8hUHIbCfSKLMgU4eMM4=;
 b=iXJJSIH2MQcKHuPx/FR7YaTYr9Ol2/Rb/XI9b3nJ81d7n27m6EUiDV+YC5qITLPhY04rhBeF7nHgDPUEA8eMbfjlEPCsZo5Ex8hHKabkLe4hP22ZuOiNAo1sWwLd1NpvawtGHmZtOEnfXeIJEN4gwtOncrQXNtlSY2xauLt+VqYcvxoVUA6ePutusebc3ELPw54L/h1uMaTX/nqZdN7n6Nftr5yMOt0g9vGJ2rWw0/82fvlPvAnPG5TCZP/bMEdoTQg+8qqIgoTzVJSGt3374CyCbFiPcahfveEqIyF7MxKCPLusoeGhv56AVUiGddtMf36/GhDl9d0cdo8VUi/7PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O+H/gpV6Kl/UMoP4E5sDMwPZ8hUHIbCfSKLMgU4eMM4=;
 b=LQxGLPFn7PTjxQ2eJINSKd8HVBG2kGM0ctVkB0BeFkDvXJ/ZuYLx4Fc4ZBzl41KNy4SdW+oXsF3IW8MVGuldLuNxuDx5h2crSLbDv5FL05sWjX0wHHamqa4b5W+8ppWP3yziPaZuHWf7YhsyG5GETbHy1JS33rlb4SJIB3rEnZc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7328.eurprd04.prod.outlook.com (2603:10a6:800:1a5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Mon, 26 Jul
 2021 16:56:00 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4352.031; Mon, 26 Jul 2021
 16:56:00 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next 1/9] net: bridge: update BROPT_VLAN_ENABLED before notifying switchdev in br_vlan_filter_toggle
Date:   Mon, 26 Jul 2021 19:55:28 +0300
Message-Id: <20210726165536.1338471-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210726165536.1338471-1-vladimir.oltean@nxp.com>
References: <20210726165536.1338471-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR05CA0078.eurprd05.prod.outlook.com
 (2603:10a6:208:136::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM0PR05CA0078.eurprd05.prod.outlook.com (2603:10a6:208:136::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26 via Frontend Transport; Mon, 26 Jul 2021 16:55:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c20b94a-fd8d-461a-864d-08d950563e71
X-MS-TrafficTypeDiagnostic: VE1PR04MB7328:
X-Microsoft-Antispam-PRVS: <VE1PR04MB73289CC7606EB57C8A99E8C6E0E89@VE1PR04MB7328.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: quVwtkSCw71PcEGTCV8Y/HpZQL3rYeT8vGnd1CRrFE/qxOV4EOCrJ1vrfiY6OITlPZQytw2RFpt7wpFbBdh7+Eu3Wl2XoJm0BiNfKP555GCluleAuXe1+coC7ygKrgWsJKhNuNjbBHmgJNJiVFmKjhYPrXTKn5tl4+AP6RUnyZ9aQ1n6iCROHexCd0Fe5BjHBfxp1Ej6b3jJe3mUZ84ChGPqn9toB4avSv6JBixt8GuHMCxf/il66RlhMMX++8NQSXx4ptZUd40jHTZa9Dt2Jj+GttFc+Hlr7opZE/hkSkrYPM9xUH6KDVynYRVgsLF+3mgKxGjKNBVdlh9tAVMzhmuUK/siKTK1Fz33bLDVP42Lj2+qOOasladXmgYhOSro4vDC8bSUaK/h0HZkoq+RRCmI5HH6hJRix9PiqEGNNgYzqPxAlCBV0EK8g7StMac51WM36BQKi7XUnbDfG1VZK8cmnVe/j+ZI64zJ3SAeaaT/ZRWiBDLClsCafd2S0amlshm+uL7Hiy4PGcM6qNCkW6j04VVgrfztGIXSw9mdG+xDg3R7vfNOoKtNLXuqRpU6PdilUw0Kk2adnpLaczthw/ankNHlyNjuzA8HmNOktto9CoDftAQo0Od53ZH0xLE/ntoY0mK4zpJox/hCm8taJUMfSmORW/kGsbf5Gbb0zZuJV0PQXXm0bWrHfZ3GT4BDwOcwj9Q4ae1GFTutB8RtXLj38KH+2UaQ1pd/9HTe++g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(39850400004)(136003)(346002)(366004)(36756003)(38350700002)(38100700002)(83380400001)(478600001)(44832011)(956004)(6666004)(86362001)(2616005)(2906002)(52116002)(8676002)(8936002)(7416002)(66556008)(5660300002)(66946007)(54906003)(110136005)(66476007)(316002)(26005)(6512007)(6506007)(186003)(1076003)(4326008)(6486002)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?di8c6eF+TPnb7FFet7If1WUMSAujzXD0D7fW06rus4l4UxfmRYWy3hUHRVyX?=
 =?us-ascii?Q?MXaVMHyBOU9whkuunER5wQYiDbymjcYVicIX2JLs0pLHSPpbvCklRp/p/zIf?=
 =?us-ascii?Q?s0agCuecc/rpvmt45CHBwNEtGca63JQddHeWDp0EkC5jfHD6PzXlipu89da/?=
 =?us-ascii?Q?pZi+zz8FnuszarpQl3qKU4pnDMKq4vhmAl4E9SRSbXQ4oKGwYzbglgRChGJM?=
 =?us-ascii?Q?3WmIBjcNPLh/yEL1oQ0soN1tx+jp4mi1Cs5vYda+UNNawUjrv/Mw4HN5Bm9P?=
 =?us-ascii?Q?ePzk2oZFX/XfHpYU2kMn3Q/sCX7K4LdIbLU9aDDFXY1yykPXDpEa5r23QkEC?=
 =?us-ascii?Q?f9Un9/EXoad4qTUsJB0c+/QBv/FZGa+TLFwm1cPgjhJxu/MUTCcL+rg3W/xi?=
 =?us-ascii?Q?br3Ee9hyuR6u+HechLK4WIgV38SsUaktiBSKM2i47ET8Ry/OtfcXdhlMeMwt?=
 =?us-ascii?Q?Iuj32hpwkyg3ey1P1ooPDJ3cPIo2o67bbm/ELNyhFbAD1yxTPiL4yaVg+G7y?=
 =?us-ascii?Q?G8/5YEIsTXG9z5fWW7CYryLsAt4zwMA92BHpeydizqNGx0hBG4psuB/9zZ1E?=
 =?us-ascii?Q?xhtNRoKlXKNrZSrNbtU46mbcQZl9O5XxOlfzUqLEbtv895DBCU0P1Dg0c5nP?=
 =?us-ascii?Q?iV6y0SmxWSiEXp21sRSApTVz1WP0ptlAd1mlUhCqY2x+em6mUqFXjMR9tp7B?=
 =?us-ascii?Q?907CTZv4bPWRRK6QBZQI/+c/d4TZ94GD18BYNOULGRxKJBGUro/wbtdFULRE?=
 =?us-ascii?Q?A0IbCOcSNdBvhJTWrtxY4ZL+gx7H1fu/7Ze2PZfsIWBJvQAY3KTo9PLYVS+P?=
 =?us-ascii?Q?lwIwE06SkP9uX6MyvATBmgN3cx1f/ayQAyUEWnvxkl40SWNsvJYdDxqqlxMn?=
 =?us-ascii?Q?HnJm1T07NZWz45i51vmtztDz3IgHeI3ltNWklYpTy8lqbZRFkB1jfpRXESon?=
 =?us-ascii?Q?94hzO4Is5Kt1kqVxNjW9EyEePHueEPVSLaVuzrBiCObPeosMres8IKWuybR4?=
 =?us-ascii?Q?7WjFbpLCXbpUikW8QyMx/KGq4t/N5wtjnRlibyCFOMhmiwrg4ZzgLoditGje?=
 =?us-ascii?Q?IgA+RAy0TNloeAqqYnDJgr0awpGRTzzFXD2N8bv7Fho68SxHrYkgYqKOoR3A?=
 =?us-ascii?Q?N+kXm2Suw0v7H/7Vn23z0pKnHXphB46yWWPd3Yzs9GDAldnsZIlJNXVPp+DX?=
 =?us-ascii?Q?Qya4psgtFbpYVBGA74zX/sFq878yOijbdRjiudNki6pa5eswDLaGpg2GzpF3?=
 =?us-ascii?Q?KOaG1auwOEnz3xHxWm4LhAOFOnR9b7yr7owNCvggGVjz2CHG+770wP/r1b7z?=
 =?us-ascii?Q?aIzpQRA9AHEdynIG9ZFnr4x6?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c20b94a-fd8d-461a-864d-08d950563e71
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2021 16:55:59.6751
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cVzjs8NX5jLPttgCqSUou9+q0vQCxTu2aH81EVPkStYVkPgZA4wKloIjwvaQtZ6RU+bbwgnEjagXRF70SrHCvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7328
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING is notified by the bridge from
two places:
- nbp_vlan_init(), during bridge port creation
- br_vlan_filter_toggle(), during a netlink/sysfs/ioctl change requested
  by user space

If a switchdev driver uses br_vlan_enabled(br_dev) inside its handler
for the SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING attribute notifier,
different things will be seen depending on whether the bridge calls from
the first path or the second:
- in nbp_vlan_init(), br_vlan_enabled() reflects the current state of
  the bridge
- in br_vlan_filter_toggle(), br_vlan_enabled() reflects the past state
  of the bridge

This can lead in some cases to complications in driver implementation,
which can be avoided if these could reliably use br_vlan_enabled().

Nothing seems to depend on this behavior, and it seems overall more
straightforward for br_vlan_enabled() to return the proper value even
during the SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING notifier, so
temporarily enable the bridge option, then revert it if the switchdev
notifier failed.

Cc: Roopa Prabhu <roopa@nvidia.com>
Cc: Nikolay Aleksandrov <nikolay@nvidia.com>
Cc: Ido Schimmel <idosch@nvidia.com>
Cc: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_vlan.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 325600361487..805206f31795 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -840,11 +840,14 @@ int br_vlan_filter_toggle(struct net_bridge *br, unsigned long val,
 	if (br_opt_get(br, BROPT_VLAN_ENABLED) == !!val)
 		return 0;
 
+	br_opt_toggle(br, BROPT_VLAN_ENABLED, !!val);
+
 	err = switchdev_port_attr_set(br->dev, &attr, extack);
-	if (err && err != -EOPNOTSUPP)
+	if (err && err != -EOPNOTSUPP) {
+		br_opt_toggle(br, BROPT_VLAN_ENABLED, !val);
 		return err;
+	}
 
-	br_opt_toggle(br, BROPT_VLAN_ENABLED, !!val);
 	br_manage_promisc(br);
 	recalculate_group_addr(br);
 	br_recalculate_fwd_mask(br);
-- 
2.25.1

