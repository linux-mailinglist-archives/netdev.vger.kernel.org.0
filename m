Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B350C3F033B
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 14:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236106AbhHRMEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 08:04:09 -0400
Received: from mail-eopbgr00085.outbound.protection.outlook.com ([40.107.0.85]:55044
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235875AbhHRMDy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 08:03:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W4b2YfSJGu4ODDMbQsxuwqoo46+5OCbUwTvpOOfy/4U4UjGR8Ni3G6raEwQ6EZA1eizlN1qnfAxX8gcJ2h3FX8Ff1h0Po6gwhoRlIltlmV6s/81SWqS5VqNgYxY1fNfIrLELWTOP26M7h0oWsNmi4TmqgW2Jy/EqDnCZM7qdNNCxsf4co4qScoyQu6P6o7JnstWEPjub6CUNFpjgGgaPxBy8A+PspQ4kyn350uwgKKUuJwPZHKSs5xDypGABeOy5AN28VKOHzVmIsjTj44knJAjRI4Yy9rMRmmM86ByBBPWoIv5GlavHRjuENxhmn6dPk9NA1WDzza6KsRonA2zFzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BhSeQrhhCbH++pHC+OWvYkhnt60HoMDgsU19qU8cy/8=;
 b=JCZdRm0Q/SbMDG0N7PRy2ev3YVo3Uo3SkCwMvT2qtIbH/hEjL7DCQnl8dJ5oTXiyTZn5HlpX5BUaqNfq5e8rIH4mPvT7vRyApI4x02nHgCc2nljOyoKZskYYEhl6b251g0UyvdZTF39DgxS1xKnXd0v/t+4xcILalqUkc4bPtJ8qLWR11QFU/l9wGEU7rbYFozC/1DU62gpJ/yErnxTMDdWnkjrfPfsGmRZ5LOo8rbUlMGW32M7imfNpwBm563egqexyqYagHFpQfTd731RiRe0PeTZ5K6ZgApjCoKXyUz6yHM2sJ4dqNTLJnOKvd2DBLRtNeGW5Ur74mkX3Zp7Rsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BhSeQrhhCbH++pHC+OWvYkhnt60HoMDgsU19qU8cy/8=;
 b=fXjuPRVvjoniT2szr0uRQSOEhjszcYaLTLByK39J1ayRI9GxjIvjbJFVMilo+3p9Aduv/+su9e3AErAg4O/sPE1GUmXJKAbHbgqKZeHilvj6A6kQBMq2b5zHdyBW4IjnDw8jo9mTghExesAczfMx+Vx9m5I+1w5vB3NEc/xfc+I=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3839.eurprd04.prod.outlook.com (2603:10a6:803:21::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Wed, 18 Aug
 2021 12:02:57 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4415.024; Wed, 18 Aug 2021
 12:02:57 +0000
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
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: [RFC PATCH net-next 05/20] net: bridge: switchdev: make br_fdb_replay offer sleepable context to consumers
Date:   Wed, 18 Aug 2021 15:01:35 +0300
Message-Id: <20210818120150.892647-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210818120150.892647-1-vladimir.oltean@nxp.com>
References: <20210818120150.892647-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0134.eurprd08.prod.outlook.com
 (2603:10a6:800:d5::12) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by VI1PR08CA0134.eurprd08.prod.outlook.com (2603:10a6:800:d5::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Wed, 18 Aug 2021 12:02:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2da69ab7-ecb4-4730-a43b-08d962401e02
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3839:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB383907E232DDF7268341F3A7E0FF9@VI1PR0402MB3839.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TvF8ZRomPvLGwax3yQP0sEbGfzBXltakdR1F6njcAMBLvV8N0fmckxgUTmc7ew6d5IQ/BcdkJi6fRIFHUMlMZIx9iJA7dSIVsTSXnfJkzm4sJbKustkxP50jNGsDLNO0zLFfJYnmPNnQtqp2oP4fqlNS7WA8Pfy+dGGyUqURSN1qFmnfYF5Pm/4nJ1RZcilhmypFj+FY/82T99YJJESrNqNt7SGSXZ63BmjyYeAchTNX7XJAZ2oqph9+xKdYsxTY/XIXKjG+jG1hW81W2TKATzOzQ0AkF+za7eCDkVh57NxvkzyVI7qEHTyENOfYpQLyXDNAzXJiUGS47YMuiKDpMpw4g9gC963nlxU7j/6uJh8TA56VvXGjPkEWZNjQ789ygI3ub6Cq7fp+cGk1Ygj2ILiEhwx3vyJmrladksR9jQYHSG22XpQcC0jFUAyBVRohLzRrgEd8EhAyyA/B71J/BudSLEt84IVehKUy2w/K7UKj9bklGUU3c2dHkXEmhlGRP4i8e1hDfqNOI0iwROYBDME6cBHseQand+MrMjrVV0Jwa+YjqI7sFoaFdRUrkDliXPJMIRerg2UaX3FlMWLd/erDMCZV1DrEYnBF7AIspQjZyp9qKtS01aJDfXgZ9T58MDR+Oas+YUtaf/oNsAIc+VQy6IyyqjUah3Y/vYAeboa68wrGW55YMsh5OlnGfCrNVNGF1iqm6JXXyE09mWHINQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(39840400004)(366004)(376002)(66476007)(2906002)(66556008)(8936002)(6506007)(186003)(7406005)(7416002)(52116002)(26005)(86362001)(66946007)(6486002)(44832011)(36756003)(5660300002)(1076003)(110136005)(54906003)(6512007)(8676002)(316002)(6666004)(38350700002)(38100700002)(956004)(478600001)(83380400001)(2616005)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vSrZ0Fn7lhucB5x22F1aWDoA9qj5A2kRtPfTP0GxHNInW+NcgoFrugBcb74/?=
 =?us-ascii?Q?Xoh102loOObbIt+r1F+D6RfvZKNAo/tpKVjU6TsV+MVdt+u08hrZDol6SRaS?=
 =?us-ascii?Q?oRBs6MlZ/rTU4BY1flj6zo/4Y9JGWXT490iS48fobcN5/e5BwuSfQaEocuGr?=
 =?us-ascii?Q?q8ra9qwFFsH12stznvTJwdlI7cVLvw2XOGM5jYQHREmaQ6gJ34t+v9qWivi2?=
 =?us-ascii?Q?5UPfGrGi0uQdYPWxqHWRlvmebisBmiC18BNXIUef6q1K3ApoSQaN91xxYomy?=
 =?us-ascii?Q?QtiB4pgI8rZ1degkVQbZUFff218/PMGZ3gEOeMg5AekribDfK7ruyzajLVUa?=
 =?us-ascii?Q?Mc7/ryd+sy+zlvjkrWSOb0L3gOGarfotCpxE9e0tAj0JD6G4/4eNztkDIoXW?=
 =?us-ascii?Q?nyf6CGJCtTdjLxHHazLCY5yaEEOt2JSI8s1LWKTK84QHfyDQovvIz23uA4FM?=
 =?us-ascii?Q?LBAsaEc/K3YrDPCVPiw7vLFf9mjkIO9JnZk/0gOAlBY6D18sj8P+IERRVk74?=
 =?us-ascii?Q?ket8Gx7sdEVDO+CIET7i/hqF46O1e9np6B9Ven2ojFW7uhsLBTSy8PYFAC+w?=
 =?us-ascii?Q?2oTEzioDfa7BCELuRPLif/Fx6IFPFgIfN6vbbf2vkKIkyhFRhb0Sor5kWsqQ?=
 =?us-ascii?Q?GSf2MrR9tLcabsCmNZyeUKml0FoU9KgDklxCzFxhNKDORRkxAUvQkgPM0WIQ?=
 =?us-ascii?Q?3m+nm0RyhTQQUFxDC/9rJHZUZ5V63PIvrcsmx0eunnN/mjbEu4xQdUNo5fC/?=
 =?us-ascii?Q?pLlUQ+lnFXEWkgFhgM4GwqczAGPnQXeO8cU+a6WM+UTtKTc6uIsBKW5249Ib?=
 =?us-ascii?Q?1BAmgzafyeGURuQRmG0kUvUyxUdURnuoGGvpo+Vns/ZKlwd3UqsqOYOV6ZWz?=
 =?us-ascii?Q?0wsxOMzVxIGyHuSUSgMUarz3tbbKueG4z7R/bSWiqbWAnVWIfE6qfalw3EJy?=
 =?us-ascii?Q?DVZOQpqvSjNXye96XQpiKghV1H6ig0Sg7AsnGYtiyItSnWpO1Y/aODrvUf9v?=
 =?us-ascii?Q?XbzHVO94PXr7v0/XCdlf0W8QMkfuaiXjdIlRg+Fk7GgfeJjQNbu836yS1R1x?=
 =?us-ascii?Q?ohGdRVcH/SgmJ0NLxl0EFMRNcNbwRSLhvXCalfhe+DEWnLmLQ2DdyE9FSFqp?=
 =?us-ascii?Q?KkaQZiSBR7jDYTcjEoUN8z5MJwC7EM8EQRx5SHH4VJuEFfOqBq5Vh/WwdY25?=
 =?us-ascii?Q?GVD83D4cyTqyasOfKmBvYcQYod5VWmNSmjT0M6MkebOFaeT3IkgCCZoplp2a?=
 =?us-ascii?Q?dHrAdc11R/pdzY62veTOdH3+tSqxl/6yrr6PSO7gRqjO/5puJtBklqNT6pgP?=
 =?us-ascii?Q?KBIiWr6k8I5Aa9RI8B7YKYF4?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2da69ab7-ecb4-4730-a43b-08d962401e02
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 12:02:57.2803
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5py9AdncG7p4R9pJYbaKwuj4Loz3j10/7Db9+JlmyJGrybJCUJuyCWb/PI25a+Q82Qm6r12HIa6VnetS7N0RIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3839
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that the SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE events are notified on
the blocking chain, it would be nice if we could also drop the
rcu_read_lock() atomic context from br_fdb_replay() so that drivers can
actually benefit from the blocking context and simplify their logic.

Do something similar to what is done in br_mdb_queue_one/br_mdb_replay_one,
except the fact that FDB entries are held in a hash list.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_fdb.c | 38 ++++++++++++++++++++++++++++++++++----
 1 file changed, 34 insertions(+), 4 deletions(-)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 0bdbcfc53914..36f4e3b8d21b 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -752,12 +752,28 @@ static int br_fdb_replay_one(struct net_bridge *br, struct notifier_block *nb,
 	return notifier_to_errno(err);
 }
 
+static int br_fdb_queue_one(struct hlist_head *fdb_list,
+			    const struct net_bridge_fdb_entry *fdb)
+{
+	struct net_bridge_fdb_entry *fdb_new;
+
+	fdb_new = kmemdup(fdb, sizeof(*fdb), GFP_ATOMIC);
+	if (!fdb_new)
+		return -ENOMEM;
+
+	hlist_add_head_rcu(&fdb_new->fdb_node, fdb_list);
+
+	return 0;
+}
+
 int br_fdb_replay(const struct net_device *br_dev, const void *ctx, bool adding,
 		  struct notifier_block *nb)
 {
 	struct net_bridge_fdb_entry *fdb;
+	struct hlist_node *tmp;
 	struct net_bridge *br;
 	unsigned long action;
+	HLIST_HEAD(fdb_list);
 	int err = 0;
 
 	if (!nb)
@@ -770,20 +786,34 @@ int br_fdb_replay(const struct net_device *br_dev, const void *ctx, bool adding,
 
 	br = netdev_priv(br_dev);
 
+	rcu_read_lock();
+
+	hlist_for_each_entry_rcu(fdb, &br->fdb_list, fdb_node) {
+		err = br_fdb_queue_one(&fdb_list, fdb);
+		if (err) {
+			rcu_read_unlock();
+			goto out_free_fdb;
+		}
+	}
+
+	rcu_read_unlock();
+
 	if (adding)
 		action = SWITCHDEV_FDB_ADD_TO_DEVICE;
 	else
 		action = SWITCHDEV_FDB_DEL_TO_DEVICE;
 
-	rcu_read_lock();
-
-	hlist_for_each_entry_rcu(fdb, &br->fdb_list, fdb_node) {
+	hlist_for_each_entry(fdb, &fdb_list, fdb_node) {
 		err = br_fdb_replay_one(br, nb, fdb, action, ctx);
 		if (err)
 			break;
 	}
 
-	rcu_read_unlock();
+out_free_fdb:
+	hlist_for_each_entry_safe(fdb, tmp, &fdb_list, fdb_node) {
+		hlist_del_rcu(&fdb->fdb_node);
+		kfree(fdb);
+	}
 
 	return err;
 }
-- 
2.25.1

