Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6971D3F1D7A
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 18:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234085AbhHSQIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 12:08:49 -0400
Received: from mail-am6eur05on2045.outbound.protection.outlook.com ([40.107.22.45]:64993
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233719AbhHSQIn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 12:08:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bzkDCl7mF7l6QDjdOfy0Crf5HJ4YUX4S1GtAIsXwKeUEse4f2IVx+g6KKazsoO7w4MHKhbeFyDnxTDqx3mYE39/Y93DJsZVB0b4862AKDPvqixDifVrg0lOZftmDKXFHwRdVBYblODoaVGBLbyrv+6GGT2CD4s6B0GbnzmkikhEa7Asw1IYENc1pDrUnZThv9WM2dX/l4phwDTGF/jS9BQjUVriUmdCcYWrPEnF39TTQFUQ/al40jyKcMJcTKCXzCP8fS49MKKeDKLPW4qSH4scONB4MSDPHx4SQY/8tzM88IsB+cwGGIsCGwamr/dJjc4+qspJPjemV/dkWbQjwYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dVQpy1oOJ+mMQy9S87HfuBemalvNB9Cw/G5QXKhHIFo=;
 b=PYcFHD8GYiOlZH5GOBNCJhcxk8dI+RasmUZrSew2MRhvjIurP4qhNa6TTRgPyK1Z/0yW1+tJ1cYntjVpGheTrSXIJuJ3EadtjN/2t/qB4E7Mw/KhsmmCY8+d7nQhBp6TlasPBY1aNlTU+dVs/RcbdpHWmHoQvZIOuWb3eSaG7cR3HQSTE/RE4VuWH5vv4hes8jqs1XbClhjpZWfBXBLoWDZjyqPHV2+euCouXMNdhpnD1Qgx/uWTmgQgQrKavV/4mOxmkmS11IexX1jnHTBat1LMbg3maLtQFOQV7vEo0igRYxSf7E2OpXI+v/38vH24wvvTdkdSekdVWvYwSqdifg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dVQpy1oOJ+mMQy9S87HfuBemalvNB9Cw/G5QXKhHIFo=;
 b=ic8Ufo0G4Eh0FRvWWIIi13WsH+RKsRq2QcN/HfQZX6mJ9oB5H/9y4xxKDc0dzAuBczLIjRFoUTM9WpTadqbszgu3KysVUcF3mTya980L6G53GGhhvIxIi8WGN00MSEaMMd+CDrpT9yFrKiWqffBwRfDSUjCOspsbP9Bt5YUTQ6M=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6269.eurprd04.prod.outlook.com (2603:10a6:803:fa::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Thu, 19 Aug
 2021 16:08:03 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.019; Thu, 19 Aug 2021
 16:08:03 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        UNGLinuxDriver@microchip.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH v2 net-next 4/5] net: switchdev: don't assume RCU context in switchdev_handle_fdb_{add,del}_to_device
Date:   Thu, 19 Aug 2021 19:07:22 +0300
Message-Id: <20210819160723.2186424-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210819160723.2186424-1-vladimir.oltean@nxp.com>
References: <20210819160723.2186424-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P189CA0004.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::9) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM8P189CA0004.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:218::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Thu, 19 Aug 2021 16:07:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a6ff52a6-0cbb-40f4-fed2-08d9632b85aa
X-MS-TrafficTypeDiagnostic: VI1PR04MB6269:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB6269922D883295A77542A7E8E0C09@VI1PR04MB6269.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0zhX5qdFMwmunCItsnTPP/n2uvbq6wLr1u2SfClRxoQm9vSf6HAy8i80YeLB3zvEEdtgW+cbLpSPxiNVmwzz7qTzn0SyJjP3sIEqPY5Zv9U3PfoRwUbWSnrY2ItyiyLS9zNoBumRM6nPy7O55tQsQAo/PGR358p0ali1F2eax2IcDvOLAOKcLuF3Lzw68GkMADPhkFjBRhoROk3cyDzWs7O6zOLpRLE6r5oP6xbKW64INhtTY+flLnP5pixn0o2xAZi5d13ECbmwDNtvaVTqUw+yh7WiHRElDYrKtMuymAdT0WMeIdE9DLC6EVFNU28oqqRNIBx1igdKBFjabJgEmDWnwaRX12cNIZhhZP7IjK8OqiM1ngq+WqSMLvZBfDUcOC5gVXTmve7ZXBR+5Ux1cZ0Rcb5QzOW+DhZAuvfpyFjZooFHaF95Vg6JzJGRK8qS7NwDnel7EaYwL9+d46zD2yDsH4ubljVdrdPk9gnTCuF/41tCpIfe2o0czj1xVlqArSEvpAaj1PrF+Fc+Z5mLwmK47r2c4q0e7ASVKTFkmuO3FEeyACX2NbU0CPSvjkh8uaVaZ82Zs39KYyuseRDTKfZAOsZvgPHys2cfvfnZmWc4Qhs5KoKIDRoKo0CM9Za0uexRDXTesW2oQb4mU3sIr8kN67+xKf2rTMUhRmP4ozIu+g49SW6+vr7N+zYneFwXU6wWJ6i5UjIC2jvftcLWWw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(136003)(396003)(366004)(7406005)(2616005)(26005)(6486002)(38350700002)(5660300002)(38100700002)(7416002)(4326008)(8676002)(316002)(54906003)(110136005)(6512007)(6506007)(6666004)(478600001)(44832011)(186003)(1076003)(8936002)(956004)(66476007)(52116002)(2906002)(83380400001)(36756003)(86362001)(66946007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+6jRF6+5QCh3pU9u+rPWcyA+ondl4Pob7MfSOwnxB6RYU6kHeMk6YrOg2D1H?=
 =?us-ascii?Q?JaA6yZEs0Dmri1e0CF9rDId8zS3/hbBEfG+0yM/lfoOxUmUEHo4WdKMAuWao?=
 =?us-ascii?Q?zn6J3iRdcHOEZ5Kic65jWEH2J7MuekXG+KH+aucPymCDGF6nIbXJaBa3F78J?=
 =?us-ascii?Q?chlLPvqxjaUh4yyVNz9AAMf4U6MsyZQUQ760Iyhi3/aaTTT4TFokBMfwXqR4?=
 =?us-ascii?Q?drrFQ78b+h3pgPvb5xgq7NpPcYeOV6w+KGWai9rT6FBYvtmtbmDoEXkjCRRu?=
 =?us-ascii?Q?XhFd2jJaOoZAwSm8MQ+ASoVWiF2VQNgnti8eamrKm35z9gy99oAiZXjE3JYA?=
 =?us-ascii?Q?uj6mCFOjLX8KzQg8P1p6r07h+ToDuEK6upUKiVBpIS4bt87XdzWMhOo+0Fx8?=
 =?us-ascii?Q?L2aX+8NLBRwEDD7X1UUsmo2bRBfWNorML2TQ1vg06eiib700XPee2SDnmca/?=
 =?us-ascii?Q?S/OWK9apa9fQxgCBVCHAAXG3IuTsL0LiDnwq2ylukHL6/i6AA4UX3nR70OdC?=
 =?us-ascii?Q?C/YtGvHv1vMIf2utfwY3DTtDlJ4uHwCm5YusXff56KVoQMpLmcljyeh7JkYo?=
 =?us-ascii?Q?JhG3O4yp9DCtGtcXv1FdHoVFOy4y94GyUZXE80DMVaWJDFqekEGhlm5FL9cH?=
 =?us-ascii?Q?B4Iu83wL4g0LH2h2+oF2+WIq7YMYcwT9KgH8YmV0Rz3/VmYDfocbY3bHLhjf?=
 =?us-ascii?Q?0y5wNZ9MFaBh5tXrzHO4/o6tAy7ATTNcj88Yak4220J9sO3b3yo7aNBlfGG7?=
 =?us-ascii?Q?87EQlmLKCUXfNmKueH7C3iL/nYsaawpY4KOivXrgQYprwcO3+YLVjlPTKfpG?=
 =?us-ascii?Q?9XUVgvqnyeQCh/MKRR+NeVbPP4ro04HGueFT9t801KfCteq5cjj8nvX/dZxN?=
 =?us-ascii?Q?PJBsPJoNC12dsNrgcEajKvdM6RpcgnzVTj2UeiGkkff12kJl/43l5At9LSbv?=
 =?us-ascii?Q?0/Iv9FkO/MMbi+rVlrdXI5a/L6XdhBZ5auOnlILvwXFCrj0xBkrb1T4bi0YC?=
 =?us-ascii?Q?S64xedrPq2RzekCpZhqhi/DV4vJcrt0Os8YwBuJtVhoXGd1kBP5/kVCbYnw7?=
 =?us-ascii?Q?3GmEWpmkyjWjI9iD8BxZj7WWpQAGw1xyPVYkgoB0Rp7jY1cozwft/HmCiI+W?=
 =?us-ascii?Q?rfwlbKasbpJcZDyTUJiBAAOoWsE/EFdjtoEWlJ2VLgpxDzd/n8XX8xR5Q4yz?=
 =?us-ascii?Q?F8ndckfkHdGKTr4LQjG16XACsq5HCd0YySFXIlgb+m/mENmuvsIJ0XaWA/fi?=
 =?us-ascii?Q?fzO4yfws+Fna6EovFv01KYmEEaCPQ8xcyk8Lh7YPjRQ6rq2n135iZQPLm79O?=
 =?us-ascii?Q?bmRShj4/SQ52kndXmdHMAmJ3?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6ff52a6-0cbb-40f4-fed2-08d9632b85aa
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2021 16:08:02.8984
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7XremOFCsYSkHWQPaNJigXux4ypu37IWxyhBsdn157FJZSu0Zi9yuHd7BZGoivupbTeML/OxYr593mtSV76mHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6269
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that the SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE events are blocking, it
would be nice if callers of the fan-out helper functions (i.e. DSA)
could benefit from that blocking context.

But at the moment, switchdev_handle_fdb_{add,del}_to_device use some
netdev adjacency list checking functions that assume RCU protection.
Switch over to their rtnl_mutex equivalents, since we are also running
with that taken, and drop the surrounding rcu_read_lock from the callers.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c           |  4 ----
 net/switchdev/switchdev.c | 10 +++++++---
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 249303ac3c3c..b6a94861cddd 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2484,22 +2484,18 @@ static int dsa_slave_switchdev_blocking_event(struct notifier_block *unused,
 						     dsa_slave_port_attr_set);
 		return notifier_from_errno(err);
 	case SWITCHDEV_FDB_ADD_TO_DEVICE:
-		rcu_read_lock();
 		err = switchdev_handle_fdb_add_to_device(dev, ptr,
 							 dsa_slave_dev_check,
 							 dsa_foreign_dev_check,
 							 dsa_slave_fdb_add_to_device,
 							 NULL);
-		rcu_read_unlock();
 		return notifier_from_errno(err);
 	case SWITCHDEV_FDB_DEL_TO_DEVICE:
-		rcu_read_lock();
 		err = switchdev_handle_fdb_del_to_device(dev, ptr,
 							 dsa_slave_dev_check,
 							 dsa_foreign_dev_check,
 							 dsa_slave_fdb_del_to_device,
 							 NULL);
-		rcu_read_unlock();
 		return notifier_from_errno(err);
 	}
 
diff --git a/net/switchdev/switchdev.c b/net/switchdev/switchdev.c
index d09e8e9df5b6..fdbb73439f37 100644
--- a/net/switchdev/switchdev.c
+++ b/net/switchdev/switchdev.c
@@ -470,7 +470,7 @@ switchdev_lower_dev_find(struct net_device *dev,
 		.data = &switchdev_priv,
 	};
 
-	netdev_walk_all_lower_dev_rcu(dev, switchdev_lower_dev_walk, &priv);
+	netdev_walk_all_lower_dev(dev, switchdev_lower_dev_walk, &priv);
 
 	return switchdev_priv.lower_dev;
 }
@@ -543,7 +543,7 @@ static int __switchdev_handle_fdb_add_to_device(struct net_device *dev,
 	/* Event is neither on a bridge nor a LAG. Check whether it is on an
 	 * interface that is in a bridge with us.
 	 */
-	br = netdev_master_upper_dev_get_rcu(dev);
+	br = netdev_master_upper_dev_get(dev);
 	if (!br || !netif_is_bridge_master(br))
 		return 0;
 
@@ -569,6 +569,8 @@ int switchdev_handle_fdb_add_to_device(struct net_device *dev,
 {
 	int err;
 
+	ASSERT_RTNL();
+
 	err = __switchdev_handle_fdb_add_to_device(dev, dev, fdb_info,
 						   check_cb,
 						   foreign_dev_check_cb,
@@ -648,7 +650,7 @@ static int __switchdev_handle_fdb_del_to_device(struct net_device *dev,
 	/* Event is neither on a bridge nor a LAG. Check whether it is on an
 	 * interface that is in a bridge with us.
 	 */
-	br = netdev_master_upper_dev_get_rcu(dev);
+	br = netdev_master_upper_dev_get(dev);
 	if (!br || !netif_is_bridge_master(br))
 		return 0;
 
@@ -674,6 +676,8 @@ int switchdev_handle_fdb_del_to_device(struct net_device *dev,
 {
 	int err;
 
+	ASSERT_RTNL();
+
 	err = __switchdev_handle_fdb_del_to_device(dev, dev, fdb_info,
 						   check_cb,
 						   foreign_dev_check_cb,
-- 
2.25.1

