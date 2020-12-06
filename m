Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5B1F2D0871
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 01:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728780AbgLGABg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 19:01:36 -0500
Received: from mail-eopbgr80049.outbound.protection.outlook.com ([40.107.8.49]:17892
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728687AbgLGABf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Dec 2020 19:01:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OWN6i+aeFMVOwQ1PaWmXbJWuVS/EqIvuNh9R9s6J5KlK8ufV6E0AM6dz2CsZl8lEzc0DPPTf1xlCu2mm4410qIpWnRQREqqr2g7xKrmPUddof2pzHAq0m5DGIPTTKKVJVI0Vh6SQq4WEQufrye0O+LBRZpeb/tZhgEWRbZXXsTWywkX+z1rMb1DaIKfYW4hnpgvBWh8Fer4ICG61d6R/NiK34gFq9rdo3vxOFR7Y3G2MRqmQxYNey/w/459Vy7eFPwM7CQEX/kiuUyL3+PerVJfP/RrXQGnfavK0MInZM3LKKvE/N3mOCC/eoasHpCCseXfTIQt9Z2HDfvns6MswOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RGx2CoCUTnIlmt5iAFFp7CH+wwxPytHnE/PNCdBToSg=;
 b=aEH9UHjnhiitYUj8pljfo7aFrQY8wJaFtMeubh7m3lAU9pQg4p7jzOa5z9gtEm5+3Z62gM0XYXfgkTRnp+wBfpycuc39CPPB6scBTjPXelQDJOr/5p8K1fhPQ67XpHuTD/NPrYOA/q3qBFRyW3wSWtsOnRCHZkBXogzW8zXM5oNaHQLgdwFbYLmvvt6IN0dvMKvrc19f2u3HxPbZ77MC7PWeL3U4G9sVCj1VYdiUeI+r88clvP0qCJsT9ISwBCuRIz5CJWwQAdBp68Nutr7tFVJSSzUSMHrLp0Bm0HiYkabXUO1ikdtTXvnfNP/UspePCIvS3SjMuQFOR3RVSWJ9sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RGx2CoCUTnIlmt5iAFFp7CH+wwxPytHnE/PNCdBToSg=;
 b=RxGz0EHcAJjDrKZfRsunRsydQAmSC59rIK6g7BsKTKOP2vr+iyyTOsl6oNTQ7bucwSfhonSJD+e797ORFUwp4PVxcVorvEBaEoHlwapzLU/YRUYj2si0tyXVd+gj9G09ULrlO3NUDB+pNYdZFz4xO7krtwrekeXH6RpQpneCb48=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB6637.eurprd04.prod.outlook.com (2603:10a6:803:126::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Mon, 7 Dec
 2020 00:00:04 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3632.021; Mon, 7 Dec 2020
 00:00:04 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jiri Benc <jbenc@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>
Subject: [RFC PATCH net-next 06/13] net_failover: hold the netdev lists lock when retrieving device statistics
Date:   Mon,  7 Dec 2020 01:59:12 +0200
Message-Id: <20201206235919.393158-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201206235919.393158-1-vladimir.oltean@nxp.com>
References: <20201206235919.393158-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: VI1PR08CA0156.eurprd08.prod.outlook.com
 (2603:10a6:800:d5::34) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by VI1PR08CA0156.eurprd08.prod.outlook.com (2603:10a6:800:d5::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21 via Frontend Transport; Mon, 7 Dec 2020 00:00:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7ae84657-c4c4-4d41-72b8-08d89a430c9f
X-MS-TrafficTypeDiagnostic: VE1PR04MB6637:
X-Microsoft-Antispam-PRVS: <VE1PR04MB6637857E13B88D0C882334CCE0CE0@VE1PR04MB6637.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4zcZ/ZVJsHFXAtwOIt2JiBtUSLmeSPpa3R0zDHDlSqKi/KniC9jcTcMkTFVCDk2EsLnO/SIhVXFZGZ/NjsKq8PsJmzNkDo0W5q1JZrc6+vKXVKWdwYVt/iM7uJFYwnyaBteBvGYnx25nfgIxKS+5Q5OGD3mQriHpG9HM9HtNHjVLzXPIqFr6wc8zzAzMcAEA0k6ekirN7hmpyfGGjjf6V7kZkjuFutea+W7SxzQPcD+2nN7ul3nu5/0Pb8ihcMadpczOZ1lVR00m3ZNygk9zThdQ4buFl8Ke3uvRfdMVYtswu5TgRYmWsI6XwhLtPM7lo1YNP0ZcABTfk/xHv08uX020QbvAXANKEgw2s3FsiOcMhdlmNAVmwGT2eo0sGBsT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(366004)(136003)(39860400002)(376002)(6506007)(52116002)(5660300002)(66946007)(66556008)(26005)(8676002)(2906002)(8936002)(1076003)(316002)(110136005)(54906003)(478600001)(44832011)(7416002)(6512007)(186003)(6486002)(16526019)(6666004)(36756003)(956004)(4326008)(86362001)(66476007)(69590400008)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?CRb8CyLt72hylLvAx6VVtggpLte0lCNWfkFAGSKa+8/bKDlUt4JYCN4qA+Yf?=
 =?us-ascii?Q?2sQWbHJiUygZwD9+W2pp/wlG8u2GAXEcRsGeE6bapKV1kBgpGmAAhcFd2uZw?=
 =?us-ascii?Q?FETudVNgO7VRljoKmfWLvK4bshbOZrAzRdEu+rUtgeIJgjBHytXypKWwQuW6?=
 =?us-ascii?Q?/P3phz5HzTecTt12tuwRTOftyfRpXfonCbqF/NqIG8bTk9RhHfnbMWImEMxF?=
 =?us-ascii?Q?2E579+D+27XFIy9OyMSbvrzmFKD43sAhiP/to9KpNuAik+FZP761mZ8122B/?=
 =?us-ascii?Q?0NqfKx8CpSj1kwHpa4p7mzUJxZm+v0bRlcdWHlcU/kC6S8sJGo25d+b42+O8?=
 =?us-ascii?Q?03pKE8UPX3+vZtWMH1Siq3s7wK69EMAh1wTlhUQ4/NW0FsEkq6UmJMOiFjjy?=
 =?us-ascii?Q?WfVMJLWhBMSTjUE0GPVz5MyWVvVdMahw/SuC2aZfnvJrgRbjy6h3un4Mtwo0?=
 =?us-ascii?Q?yhuj/XkS7cGEdiTIwr4ep9vCeisEobxTo+GvO/kku8IsHi2CpOFFl43YSglE?=
 =?us-ascii?Q?WpOsZ100Doe3dTCv7n+uULcA6jgXWFbZ7h07FRgEmCvg+QqFBKVSTqG7h9mu?=
 =?us-ascii?Q?+5iX2G9gemMAsUAlXnpyp56aWUkTiQeP2ifTkAFzFOz1VTek85umIz9ZFP/F?=
 =?us-ascii?Q?EqVxhOUkLb12BPjTvNndBQqV4/2DBqL+QtXg/wqCpZDSelNzevGZx/Dvq1yC?=
 =?us-ascii?Q?pNh+XEImZ6cNYe3kt42YWFHxI5c9UEdMuWPBCTxT8ojI4Vgo+WAJkZ35+2eD?=
 =?us-ascii?Q?WDDu5SMhQTO2SbGpySjGmrezTbX8b/KUcLDC0Oo03hzhWkWIj9pi2CUFukU1?=
 =?us-ascii?Q?oSuK6rwSiCcxhsRLTrJ1zTrxXowtCwdCqTXZspW3VoI0WNOC2bmOQBiteGXp?=
 =?us-ascii?Q?TMZ+uSebz72/CsllNKjFCw3X8w8eHhV1FghIE3XXBumBSXI/zXBuub7OXPyr?=
 =?us-ascii?Q?eN3cGUTs6WCJqARjrMXFtMDvJedktLUOfhZVH7zHJNXBbeJrNHRz9VH27UiB?=
 =?us-ascii?Q?54Fy?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ae84657-c4c4-4d41-72b8-08d89a430c9f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2020 00:00:04.1885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: atOLe+QI3JglKynUMxaL0BNtZqihkAc03MkG/da35pF+QtWTNl1otFxXbTgW1sdq2PMS7IpDjQjwrLeHWKKQIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6637
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the effort of making .ndo_get_stats64 be able to sleep, we need to
ensure the callers of dev_get_stats do not use atomic context.

The net_failover driver makes copious abuse of RCU protection for the
slave interfaces, which is probably unnecessary given the fact that it
already calls dev_hold on slave interfaces. Nonetheless, to avoid
regressions, we still need to offer the same level of protection against
unregistering the standby and primary devices. We can achieve this by
holding the netns mutex, which gives us the sleepable context that
dev_get_stats() wants to see. Holding this mutex also removes the need
for a separate lock for statistics.

Cc: Sridhar Samudrala <sridhar.samudrala@intel.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/net_failover.c | 15 +++++++--------
 include/net/net_failover.h |  3 ---
 2 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/net/net_failover.c b/drivers/net/net_failover.c
index 2a4892402ed8..90db0358bc1d 100644
--- a/drivers/net/net_failover.c
+++ b/drivers/net/net_failover.c
@@ -184,32 +184,31 @@ static void net_failover_get_stats(struct net_device *dev,
 {
 	struct net_failover_info *nfo_info = netdev_priv(dev);
 	const struct rtnl_link_stats64 *new;
+	struct net *net = dev_net(dev);
 	struct rtnl_link_stats64 temp;
 	struct net_device *slave_dev;
 
-	spin_lock(&nfo_info->stats_lock);
-	memcpy(stats, &nfo_info->failover_stats, sizeof(*stats));
+	mutex_lock(&net->netdev_lists_lock);
 
-	rcu_read_lock();
+	memcpy(stats, &nfo_info->failover_stats, sizeof(*stats));
 
-	slave_dev = rcu_dereference(nfo_info->primary_dev);
+	slave_dev = nfo_info->primary_dev;
 	if (slave_dev) {
 		new = dev_get_stats(slave_dev, &temp);
 		net_failover_fold_stats(stats, new, &nfo_info->primary_stats);
 		memcpy(&nfo_info->primary_stats, new, sizeof(*new));
 	}
 
-	slave_dev = rcu_dereference(nfo_info->standby_dev);
+	slave_dev = nfo_info->standby_dev;
 	if (slave_dev) {
 		new = dev_get_stats(slave_dev, &temp);
 		net_failover_fold_stats(stats, new, &nfo_info->standby_stats);
 		memcpy(&nfo_info->standby_stats, new, sizeof(*new));
 	}
 
-	rcu_read_unlock();
-
 	memcpy(&nfo_info->failover_stats, stats, sizeof(*stats));
-	spin_unlock(&nfo_info->stats_lock);
+
+	mutex_unlock(&net->netdev_lists_lock);
 }
 
 static int net_failover_change_mtu(struct net_device *dev, int new_mtu)
diff --git a/include/net/net_failover.h b/include/net/net_failover.h
index b12a1c469d1c..1e0089800a28 100644
--- a/include/net/net_failover.h
+++ b/include/net/net_failover.h
@@ -22,9 +22,6 @@ struct net_failover_info {
 
 	/* aggregated stats */
 	struct rtnl_link_stats64 failover_stats;
-
-	/* spinlock while updating stats */
-	spinlock_t stats_lock;
 };
 
 struct failover *net_failover_create(struct net_device *standby_dev);
-- 
2.25.1

