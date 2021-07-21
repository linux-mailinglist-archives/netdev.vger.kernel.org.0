Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC593D1420
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 18:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234013AbhGUPpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 11:45:52 -0400
Received: from mail-db8eur05on2043.outbound.protection.outlook.com ([40.107.20.43]:52896
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233981AbhGUPox (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 11:44:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d2e1+G06CxWTeSA3lML/nDfFDJ1r39S8Ht9mdpjjQNepcXXLvmN+Fkc8aBb9Flp4NQ1IkwyoQzj4qP43srpvuxI8Rc4NF/W16WxxK/uJmUVl0Uqu74k/B+eKD4c9+UxVrnuS8/rV6Z9pkSZtN232WxfupzMamWxOvmxl9/gfXGJSLNl4bIhl3hAOhUWN3J1juAvIHiVIyc0mHwOp9pbIlUXUUzbgZNGOTeBlJtShTkXklVf5KmJOWnMCNH2owzfSxbRLgnaccE9QH/erzNRPcPFF3RJep9ALy97TD2I1KNZ612BQlcgIgVp5ZwjoVOTSzquAVAR42IeMB4grYuDnvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+m37hXapyTt5O+cMcG7dLEszPk9ZyjZ0YENIGqE4H70=;
 b=URIbADqSBw9HMijbGvf8mQB1ABptskZo/E04niAE6CINTfLlzKWeGg53ImSxOF98xP9UbvpQFDnhEUPT8yEQSTN0ntt5kUmkt/5wuxooTbtD/4dEVSSj8K6cpBahWKfzaDaRo6bNZw7f2KKHTpqlT6UhoWfrLshXlBRK3KKD0BpmYyffu/qpj8IL57EqB2mTsU5dJR7XBV2nRl0nxHKenr6GkvBpyFLG8d738l417bi7Gaw9zw1FmJW8+S08KKwMlPPJpKaToMB/Q56jcFqGd7+b2FDf4my9EXzqz9SGZStGz/Q3WgQatzMTm4t4n9dn/y+1z9UDmOoTBX2dUAVdsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+m37hXapyTt5O+cMcG7dLEszPk9ZyjZ0YENIGqE4H70=;
 b=q5uz9yBCqfQsVoGYZVLjy80OeqUclOrhAiHp/RK/yKAO9kV6LYSF4EPLzgaLTni/Xhi1mXcffzdlTb24DWALEjjvh674ITDegObbNrFI4+UWizOylPuHi60Nlo8eNVbToi67UZFaC6dFGmXlT7UGci9Eq4lanlf1HrIxJE+Sjhk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3197.eurprd04.prod.outlook.com (2603:10a6:802:b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24; Wed, 21 Jul
 2021 16:25:27 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4331.034; Wed, 21 Jul 2021
 16:25:27 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [PATCH v6 net-next 6/7] net: bridge: guard the switchdev replay helpers against a NULL notifier block
Date:   Wed, 21 Jul 2021 19:24:02 +0300
Message-Id: <20210721162403.1988814-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210721162403.1988814-1-vladimir.oltean@nxp.com>
References: <20210721162403.1988814-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0292.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:196::9) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by LO4P123CA0292.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:196::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Wed, 21 Jul 2021 16:25:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 90768e9d-d36a-4650-ebe8-08d94c642677
X-MS-TrafficTypeDiagnostic: VI1PR04MB3197:
X-Microsoft-Antispam-PRVS: <VI1PR04MB31974098C232B66E34C53191E0E39@VI1PR04MB3197.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hZ07QThsrm8kKR5A1KnctHMj0QWAX7nMelZlRp7xv/hLxxkVAtBfnAf3n4SSBUVZPOjvRzvrfgb355mmPzJMg7hQcp5UfN+eF41Xzo1FWqxjyAzLnZCqNW0LmyYwb8oZJdUTObYJb6IMJQSny2TXZDdwaEoabFwuvLZUhFIrAxCBprypYPeq7vd2DTNjpoV/XbLWSUJBL5c+FZaxpM/zCg5GuUqE9BJN3e5e9aSyG7vjwVYwrhWFyxfWhVCtL9f0lx25J3mhPYo6jiROeQqlzZqNcx7bHW5N5C4mERvajjcko6jNSMWtN42U5P7YL0Ebk2CjpOLcydaop+Uyh8yUz3RNc4rczCw4u2teWhr2bMc+yunrE7nYmABh6VyUULvraXWAU5Ujz9r6rBilufmLYiVK7YbluaVp53gAgMz8LtOaSfabhnkiPf0pCW6jrJcI1q2QY/j3tAZS6v+6COLQJlAx3pTB2OOX6jESGtNHCwnlRAHmyPu4XEY70rlUksfdILbjkE/raInPiCgZTEm2aOxiz1h8Q0ScrV/z0fgXWAlvlNyGh7vjlZ1AtpD4eyQuGOzNDmPQ9dbri9dWDk4o7sTq8ThaLnQjkjbG69S7bnZk1RiEzIIvOV+PwKZ1mYKvoF4ggW7UY/4ay+JePjMESkaVakEEBSYLRKPwgsvH/zBgiBWWegOkngoWEcps7Eaeh9RcwDQv+jGF4dXAjDBsvg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39850400004)(396003)(136003)(366004)(346002)(8936002)(44832011)(38100700002)(2906002)(26005)(66946007)(6666004)(186003)(83380400001)(6512007)(8676002)(478600001)(6506007)(86362001)(36756003)(38350700002)(1076003)(5660300002)(316002)(7416002)(4326008)(66556008)(66476007)(52116002)(2616005)(110136005)(54906003)(956004)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BBya1OXNm54bg/JrMD/b49j6djw1lyGmIBOCxmtqqNN1HaqD7XsUxtSJJuHp?=
 =?us-ascii?Q?5NaLFpNrCdkx73MmlrOXdVR+O4cdWG7Vnntc2lwEFBRmWO3SEnRezwXndC90?=
 =?us-ascii?Q?aZRB0jnwWTZF6bPGIXWJxhchHsMWf+tg9p27NwqGPYGQZ2UNf0JDv6lGByMz?=
 =?us-ascii?Q?lNRCf8Z8g1OXyqI7L+kfGI0GhsJ4f+Q2d0PnD8qgHIPtjEcGeG0qvOnKxbV2?=
 =?us-ascii?Q?YAlLitIFRt+G4GK442EGNfxJzkuRaflG1sx4fwr2uMgiWxK0ucTWqnK3ginE?=
 =?us-ascii?Q?QDliSc12nWoM0Nre41ghksUe53Bozndnaeel7g7KNVSCGHIQF/ObA4XWi8sS?=
 =?us-ascii?Q?5kM0ehtV0JsCXLiQeM65v0bfx96p9sXnuU4lg6HSyee0ZPCTrxoAt8RCzJh3?=
 =?us-ascii?Q?rkpPWIMnZdCmWLzvdNY0FUNzzqdKU/+JjINcsTCvB40lelyZF0N19gHWpQ27?=
 =?us-ascii?Q?jO8BHxt/rAEs/JWDHuaOP6EKpxMFUHWn38WByX7bMLDv7fgPLvvOq+84pznr?=
 =?us-ascii?Q?vrRccN6lCbjEjtRQCGe+ZJMPzetEjgCsbz4l1xCHBGxCIIxkI2gc1fh8elQT?=
 =?us-ascii?Q?0qQZruaCttEsWKaHwIShz414I+X6xglQO+D8AySvLRStEVOdY2ZmEAGm+nbK?=
 =?us-ascii?Q?NIrgm7aC8FHFERW3t0B3Iv3NXXYxJ9KKRim1BC6vMStyOKdxeOxgQ4KX79H0?=
 =?us-ascii?Q?lYTsukQiysRtkFS38NQ4RmtmfeUZSzONmH9zyF83XgCGS77UFTKYuTCwWniV?=
 =?us-ascii?Q?HpwT5a+JbmJ0gtG+IFctTpRdXK5LFArislf5O+Sc/wCjHnjY7JqN4ga9oC4Q?=
 =?us-ascii?Q?X9/L0ayofDjLvP95PV0P2WoESuQ+NZnT7CcqAXVMaBx5ROpYvJ6B5Jzb6Dt6?=
 =?us-ascii?Q?cNSVErWz4M2or/UIT0N3tVIWU/fk2fndjg9ZQuCrcTbRpObQJvCAWqTlfEdZ?=
 =?us-ascii?Q?BQeXLQhvO7UQGsbbdlMAYMpC822SjUaH1ky9jdqJyGQywzYc+MYIY7dEcsE8?=
 =?us-ascii?Q?QnG2Bzj6U3Wr8YMwO6pGJM3jLwcLZn9RajW2Qm/kZfC+bfc0UtOVPNd8Euxt?=
 =?us-ascii?Q?95MSTV/Jail5bNqxeFAy5yNeAdAQcKT/kBiyxKm/1upKw+ijMQXOT2v3U4kI?=
 =?us-ascii?Q?JC+F+Nh24qXoh31iKt/kzTu9aiaLKG0HuhKlL84MdYRBr2kn2drt1G1LnmI0?=
 =?us-ascii?Q?V4IHxwiHrsFrNVwZN1QH7gBUzpZH7cUU763oEKsVgf8JD+/R8utuHOaQC+uH?=
 =?us-ascii?Q?+vxMTQu+sRyriPqNJKuS5KNX/RDfMF8kgecRIKf1BuP1jr4ye1xrahd1QGCZ?=
 =?us-ascii?Q?IdcuvWZhLPLNBHWVaX5I9104?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90768e9d-d36a-4650-ebe8-08d94c642677
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2021 16:25:27.6958
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: drOz9OlUF+HF8bQbC8CrlIkqvu8FNjfQwMxE/axlvUBDlbm9h8Q9f9/eRwLp0+Os3M387nrMt6cAxykZyNqscg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3197
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a desire to make the object and FDB replay helpers optional
when moving them inside the bridge driver. For example a certain driver
might not offload host MDBs and there is no case where the replay
helpers would be of immediate use to it.

So it would be nice if we could allow drivers to pass NULL pointers for
the atomic and blocking notifier blocks, and the replay helpers to do
nothing in that case.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_fdb.c  | 3 +++
 net/bridge/br_mdb.c  | 3 +++
 net/bridge/br_vlan.c | 3 +++
 3 files changed, 9 insertions(+)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 2b862cffc03a..47f190b6bfa3 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -760,6 +760,9 @@ int br_fdb_replay(const struct net_device *br_dev, const struct net_device *dev,
 	unsigned long action;
 	int err = 0;
 
+	if (!nb)
+		return 0;
+
 	if (!netif_is_bridge_master(br_dev))
 		return -EINVAL;
 
diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index d3383a47a2f2..09358c475787 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -617,6 +617,9 @@ int br_mdb_replay(struct net_device *br_dev, struct net_device *dev,
 
 	ASSERT_RTNL();
 
+	if (!nb)
+		return 0;
+
 	if (!netif_is_bridge_master(br_dev) || !netif_is_bridge_port(dev))
 		return -EINVAL;
 
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index e66b004df763..45ef07f682f1 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1856,6 +1856,9 @@ int br_vlan_replay(struct net_device *br_dev, struct net_device *dev,
 
 	ASSERT_RTNL();
 
+	if (!nb)
+		return 0;
+
 	if (!netif_is_bridge_master(br_dev))
 		return -EINVAL;
 
-- 
2.25.1

