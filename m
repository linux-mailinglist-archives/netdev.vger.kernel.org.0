Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC96310C0C
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 14:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbhBENmx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 08:42:53 -0500
Received: from mail-db8eur05on2069.outbound.protection.outlook.com ([40.107.20.69]:29638
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230310AbhBENjr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 08:39:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lzw3T4p0yp5rqyTxhGOn3ezLd1JwuZkG4mrCkEZwOWZZ5x0YzQQ3maJIdSJUTJL7GP/KY3GLWx02VoyVPBlLyTI7HyeiCZ8rWCEZYbqwoFqB4nEV1QvWGKt2tcnaoJW+VnNAXkxJCkSG7O/LIgSB5Dsyrlhg/RcMlA+ggrtw5AuArRqlb2Q2sBJYuqTspenmq57Iep0djdCjQpFZmnwxirGkAZvK3F6wI/lu/LjatMXqxw9IxMJxziKvaWb9DQ3tIdPhm3heCV4qix1OqVkm4iX1+g5CFH2GZQQaVPLnjz6eJ0P3OgTjWMreR7lulKelpXOwTAksOOjPHQEI3X2kAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C2GQWcRrxWKKJ1Y8Eb9IZDiTIjf4XgrqccDO/eKS0g4=;
 b=NaOpJRgjp1fZbplT3qqTgEsz9+EM8QHyOpeecV1yr1W12SWJsvebY5f5YmKS5mrQt+N6vH/opCcXnogfNMXc7OsZpxATL2LCWBH8rerRZrFcIV1fg+cVXCXpl0NT5214gtFJxjdHoS2M2bUpfiVxK/Lw+R6m7q7n/KjnIyBUcoOIKZN8EKPjAoN40piaXouGbwWpty5kd4/w8duBz03umNkdb+f/ZgeenOFEbFxaPgk5Vp14t+T1db1qh3WjakD9c8jxmzVet6YOH745cXX5OhTYAeRHE6EQM33okLfdD0vLOngEuuG0DKIbpiOLkhbRCvx8KbtWGxOF7SaTDaJEGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C2GQWcRrxWKKJ1Y8Eb9IZDiTIjf4XgrqccDO/eKS0g4=;
 b=pgC5WS7UfPRMihawnn0z3G20mFn33KO8fMin3TWWyndT1dDcgmO0LDfUMIaqpDpJcgWN0oQSqHyAd3Aqds9pEPDhAjwgvijyvuO7WDXe1Zk0tW2z+BFnaetuyGiRX2Yl1WqTyQCM2xVtr0GoSmAPZPUl7taq0Ziuy//qnX91UBw=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4910.eurprd04.prod.outlook.com (2603:10a6:803:5c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.24; Fri, 5 Feb
 2021 13:37:29 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7%7]) with mapi id 15.20.3825.020; Fri, 5 Feb 2021
 13:37:29 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: [PATCH v3 net-next 3/4] Revert "net: Have netpoll bring-up DSA management interface"
Date:   Fri,  5 Feb 2021 15:37:12 +0200
Message-Id: <20210205133713.4172846-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210205133713.4172846-1-vladimir.oltean@nxp.com>
References: <20210205133713.4172846-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.12.227.87]
X-ClientProxiedBy: VI1PR09CA0138.eurprd09.prod.outlook.com
 (2603:10a6:803:12c::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (5.12.227.87) by VI1PR09CA0138.eurprd09.prod.outlook.com (2603:10a6:803:12c::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20 via Frontend Transport; Fri, 5 Feb 2021 13:37:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b1f406a6-e07c-4709-ab27-08d8c9db2e88
X-MS-TrafficTypeDiagnostic: VI1PR04MB4910:
X-Microsoft-Antispam-PRVS: <VI1PR04MB49102EC56E520870B04229E7E0B29@VI1PR04MB4910.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:119;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L2dVWSLUBiS0/HT8faCGoVMOSvfU7o5jfqL/WCdNJltUViJYdi0jlbpKvmn6+eCKmVUSarSbaM3eTUgocc1XjAldEg6yf3hzo6IVJhFyIOt3NxmcQENU5ZlDdNmlI3UMWMKp3Gs/UWYAL4Ysq/WuBTHh3UmNZ49rR+xun8T49LOSozlHoaepgxSy8vIcSvdw1PrhBPS/CzkNzqbUCGEconYlHCHmtLAmJrgeDyeiMtga4OH3L8VDWzuZK9103L9gV7JseGCP0N+hMpSHQTQu0959zKeEiADPPxSZ3zGWZWRoiY1mOyeaEi//HJk/vnwzimGhG++PetiTP5Eyeg7NKsTn776Fc/4fYHUYnIV6OF+fKIEOeJuVltv8BMz5Y5khr2+DG/GRCXTzQj1XMHlsw6VRnhPpob7KHjbWKYF2pxf60+hcWM0LZia6rbWIAIrd0XZkzTthn7G5J3m/H2QiEqfOlKk4Y/QJv0PhbgJYBVhrMBqjjODi8Gp682xcBhDJt8Rpfe8kN1HavTtMUnUfZbtlPLWOrz5AWGhvCbnawbMNdrTNWvINgG8O29505l9X
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(39860400002)(346002)(136003)(366004)(2906002)(16526019)(5660300002)(186003)(8936002)(69590400011)(8676002)(2616005)(1076003)(956004)(44832011)(6486002)(478600001)(4326008)(54906003)(6506007)(66946007)(83380400001)(86362001)(66556008)(66476007)(26005)(316002)(110136005)(6512007)(52116002)(36756003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?7LsvvwDYSIUUPqpmAqhTlNTafwlitDscCqSaloYkS/XVZv0c/HLvAn4+N0ag?=
 =?us-ascii?Q?ETvVMRl+1RTa02//SBayhTItOtljZDM4QzuVxxR+aeFS/SS7VIExWpwi1XcQ?=
 =?us-ascii?Q?5N3HY5AVeciJfeMexCt3U8315k1vSVEiYll2wlo+XxBmJsjWISJS9sByEGY2?=
 =?us-ascii?Q?5vcT7IVe5MKI/vHpj4Js/AOrxN5JfpjkuF9BFQTxFocOs94kmwSx6OsXx5EE?=
 =?us-ascii?Q?gXqYNg1E/aKLn0BhBxXc21SG8k3ZY+qWvrrx9FVQtQr0X5c7vjmwx8nAm/YH?=
 =?us-ascii?Q?QmBp44Em8GQSo5AYJQC6W+UlMWhqY8PMY9dM4Tzr5puF5HouEDJfSeJ8fD0g?=
 =?us-ascii?Q?t0OrRZbugAibIVNRhBkEka1Hng5BGobsxDRcoUy+p6ibks+qpQFPTokCOkYF?=
 =?us-ascii?Q?up71m8CU7sd81iZ7UPtTlR03otn+AmmGt5dgj5Kk7cxplFSpSZzm8lu3N8OT?=
 =?us-ascii?Q?cTTvpTyNhyBk1bOnwQR5fWez8QJG/jtA9YE4GgxXc8Oq+X3Uzogf0GcmS+Zb?=
 =?us-ascii?Q?VJY8/v/ZTrgh/JOOZgSOOQjcgA7mi+idaVS6hXF39MxAnJXuC41sYTBtSuMS?=
 =?us-ascii?Q?IWvTqPSdD9Rv6CO0nR4LWvxRJFkBI4hMFSRaRqH84Dd9RL/mZRywV4UNzxoG?=
 =?us-ascii?Q?y0VGQsFpHaAJ3x8mSFZPl2KqQj4jQEk1r5sCPXXMfBVnIkKBWpmQcuamrLDL?=
 =?us-ascii?Q?Td+mWLRYQEC3Cj8JiiDYEPxO1kKkUZzKjLyVrKmccIiRfqHXssPrKScCZiRL?=
 =?us-ascii?Q?O0rcEOyipDMl8HMtITR1mMgERiO+RZ9V7ZgMKGh6qvQ5FBdL26Eww/TIovNx?=
 =?us-ascii?Q?Gx7NqHP5/96E30uMnPd6C2JgCZXcbsBkrCTMjjqkef4kad/3ZFxR0Wc0A+Eu?=
 =?us-ascii?Q?dcOdldTekKcwx7HRNjI/7uVyHnjT57Si2rBl4xnd7QVPhohz0y0d0XPnnLFi?=
 =?us-ascii?Q?YxRpcYmMLovM2/C6IRBTnfOHOsvu7yvwwfVak/+Mq9XuSlXVZKluttWUj/YO?=
 =?us-ascii?Q?JsSXKnEKZ31jRL4yl9xoT1EfvFVDYUrbS8f2QPrLqPjmlkZAPgfUOzIs27Xn?=
 =?us-ascii?Q?0cn543dBBLhtclWDO2jGw76d19gEgjQnFxnPDalqtkL20CVkt68CwV1Mbv7S?=
 =?us-ascii?Q?s09VCPb2hGcPZkkAq9WDTFK5OiG0q1kKO7CfQboi/AWxFqyajxbAyhCfEz7n?=
 =?us-ascii?Q?dSV4axnpRLJav47KZ9i1BtAgayM0InVwE/YVBe7122lnFiyB3yxrvd0/8oOX?=
 =?us-ascii?Q?lTH+sJCeWCt9XA52rW7OVptVOVqB4nnl9GMCRS75aNzNc98k15zdapKmkwis?=
 =?us-ascii?Q?atUTl/0Wrm8ieig8an23XCPT?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1f406a6-e07c-4709-ab27-08d8c9db2e88
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2021 13:37:29.2912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oPD5ZtBmRHqlBouv2cEZqVdYsDAzGSauB2QIm6x7eQGRDG7WBc/owD1lUq3wOY2NqXl7QZ32b7Oq81+3bXv3Gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4910
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 1532b9778478577152201adbafa7738b1e844868.

The above commit is good and it works, however it was meant as a bugfix
for stable kernels and now we have more self-contained ways in DSA to
handle the situation where the DSA master must be brought up.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v3:
None.

Changes in v2:
None.

 net/core/netpoll.c | 22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 960948290001..c310c7c1cef7 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -29,7 +29,6 @@
 #include <linux/slab.h>
 #include <linux/export.h>
 #include <linux/if_vlan.h>
-#include <net/dsa.h>
 #include <net/tcp.h>
 #include <net/udp.h>
 #include <net/addrconf.h>
@@ -658,15 +657,15 @@ EXPORT_SYMBOL_GPL(__netpoll_setup);
 
 int netpoll_setup(struct netpoll *np)
 {
-	struct net_device *ndev = NULL, *dev = NULL;
-	struct net *net = current->nsproxy->net_ns;
+	struct net_device *ndev = NULL;
 	struct in_device *in_dev;
 	int err;
 
 	rtnl_lock();
-	if (np->dev_name[0])
+	if (np->dev_name[0]) {
+		struct net *net = current->nsproxy->net_ns;
 		ndev = __dev_get_by_name(net, np->dev_name);
-
+	}
 	if (!ndev) {
 		np_err(np, "%s doesn't exist, aborting\n", np->dev_name);
 		err = -ENODEV;
@@ -674,19 +673,6 @@ int netpoll_setup(struct netpoll *np)
 	}
 	dev_hold(ndev);
 
-	/* bring up DSA management network devices up first */
-	for_each_netdev(net, dev) {
-		if (!netdev_uses_dsa(dev))
-			continue;
-
-		err = dev_change_flags(dev, dev->flags | IFF_UP, NULL);
-		if (err < 0) {
-			np_err(np, "%s failed to open %s\n",
-			       np->dev_name, dev->name);
-			goto put;
-		}
-	}
-
 	if (netdev_master_upper_dev_get(ndev)) {
 		np_err(np, "%s is a slave device, aborting\n", np->dev_name);
 		err = -EBUSY;
-- 
2.25.1

