Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B201583159
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 19:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243208AbiG0R7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 13:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242492AbiG0R7c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 13:59:32 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2065.outbound.protection.outlook.com [40.107.102.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A36E65924E
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 10:04:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k+r60p0RRtoNRN1Umx1xZGZJNfJ96eE7O6ChgBeVWGu83S4MglFRSRJQI4eNP8PNXAMPsdSRseIid1bNXeETtGUBEi69q7nylmJH/6dKNeVZY0AvLGgKc5TQhRo9u7xuLfa/BAPa7IR6Yrhqtbg5cIEJOuvfWRbTJ1M60Z4uHkLUJ6jQ+WKuDCwxWn6rVFjcvBPfwfLyCk+ivfxmdcje4I29Wv+RiQrczZkuM3J8glaBzf9ajLZVOcu/FlLKSHpbvkJsGUEqdKXSnj+WBtP58P54bYVHPxYNjpxa9YmENOWGm6B5dOPzCDsMBUhPWoZeKvqAFcd9QFhIKPkV+Avwlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7YntpIuMv29X53sdaORpBfKCJfU0s7O1wUzYlFy8sZg=;
 b=GzgcHCg0x438piygR0WSKCNjVFGyvLWHA17CKwfIp99ewnvC5VDmyR9W86sydMmnKItFsSqx96cIQPtWHlnbzea2zEsz+uEOLTSYStRdU2Y1trSN0+HUhWTBsvNrknajFSlXBxFVWd6f0AgZokddjR9VQeT4QMyhYqdoviU5IyjPVLh5OyyDpCoPZzj3ynzPYkxCc4wcZBWlVGnPQ6VT7d5ZhBHdhxdsmTWLeuGj/y1YldJLdNa6toiFKQmkm2uUP9YUy//jZN1TxD+HfqqtlNsJp2k1q6dA10IxertxHgWVx8sNUM/EaJ7D0Sej1JeQ3+jgBog99NjUTNnmKhJoRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7YntpIuMv29X53sdaORpBfKCJfU0s7O1wUzYlFy8sZg=;
 b=QVII/RdoHp9PN1idUhdwlYScKZBCwztb4vr/vONM6PJdLnfwLyNq0r8GdmIBkFlrw/dHdyRQvij7KQP1GaigBL8IgkGMMQ3No4qSGt3jmQlpwe9C/kJUJCGNfEaubpaHhK1n7/MyZWnlVb37ZFHL1TjhlOzLt9JVu8oIAhRaa58lgPW9WFtPfsGO/vB/JHlpV7qFUnb3/BdWplQbmeGHboyPAmhhXbYWewlL2F9lJkwWsEFC8KxO3+LvfyntfRwDw5/GPfaFcDiFcb6TQEedRqc4nA2eHGT9FHa6/nXhXFL6an9fKyehhDRCbVa4HR7eXhwkuHGQ9kV/8SmnGQy6Vg==
Received: from BN7PR06CA0051.namprd06.prod.outlook.com (2603:10b6:408:34::28)
 by BN8PR12MB3603.namprd12.prod.outlook.com (2603:10b6:408:4a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.6; Wed, 27 Jul
 2022 17:04:12 +0000
Received: from BN8NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:34:cafe::97) by BN7PR06CA0051.outlook.office365.com
 (2603:10b6:408:34::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20 via Frontend
 Transport; Wed, 27 Jul 2022 17:04:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT057.mail.protection.outlook.com (10.13.177.49) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5482.10 via Frontend Transport; Wed, 27 Jul 2022 17:04:11 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Wed, 27 Jul 2022 17:04:10 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Wed, 27 Jul 2022 10:04:09 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Wed, 27 Jul 2022 10:04:07 -0700
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "Tariq Toukan" <tariqt@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Jiri Pirko <jiri@nvidia.com>, <netdev@vger.kernel.org>
Subject: [PATCH net-next 2/9] net: devlink: remove region snapshots list dependency on devlink->lock
Date:   Wed, 27 Jul 2022 20:03:29 +0300
Message-ID: <1658941416-74393-3-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1658941416-74393-1-git-send-email-moshe@nvidia.com>
References: <1658941416-74393-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fa3bd2fc-074f-4138-0479-08da6ff20731
X-MS-TrafficTypeDiagnostic: BN8PR12MB3603:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f7+RQPkJXx/9D7uNzChbk5fhmlg2eAhWmkNWPE8yQskUJhZen3Af0mWsYkZcc6ie42PAlt6NZiCe5iyKpwrVZsHWXO5WpMb71yZYDmKqMWcnAeTXxvAUW+DdzcytjcFcpmw4Oun8yTW0XQiOYbhtoDg6U4dQ7NC7f/jOmo7U0qGXdD2YDZDSwtOqn4CfFJTiBdfD5+IxN7YQIt58bqzf6v1V4YuUAbCD1zXSdLbfzgty6oLjhXeMAmaPwhhs1j+V9ZVC7wAdF+S1cL64tw0QF4f5TRw+n3b79C3LfORgwizpE1aBUEqo1/GKuYWNTLkS65lW8CFs3nRa/rJMSDDQQvsxyOApnIUeNObWYBcgxX+5/zoJ5cQD65itm6xZsZXx1fwVI2ssapEiyTx5NGSdlfxGDhOTPig89TbbEJaodkplzg2Qm/mTVGOZvVcutWmJMdqyGzH7944z3LVFWIFC0QGHtkt38kAQkGdqZKqOl88rwpmakKwqZqY+/oPe59AM6HX2f5iptJzwNboGyir8zJ8p7euHNTK88YAAJqYfo3qWFV1bj1mLZcum3QU36GVJMwyf7ExrlqSSdlsxKbnNlOE633OW7cBnfhPUwjeb23XD9Z7GFkc54e6bMvcQ7Z5QbNEja6pQwEMbD9hcc+Vqv3Dpth7wNkxyqBRobqrQ4L7nE4cTQVFchl8xzaGizgEFTFLT2Pl1U+ehLpRNhQVAXlgpM2CfTsz3r4brKBDLN9MBFxNJmuAVX9y7c1/gADQj0EPm5r24cQPALocggMYcFGcckDyOxMgpVLlzuw1g2JUcWGK1kMoK3iKirQactBqG3seRxhBMf0LVrxhxpcVXAg==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(396003)(136003)(39860400002)(36840700001)(46966006)(40470700004)(36756003)(2906002)(82310400005)(40480700001)(356005)(8676002)(8936002)(4326008)(86362001)(5660300002)(70206006)(70586007)(110136005)(316002)(54906003)(40460700003)(7696005)(47076005)(426003)(336012)(6666004)(2616005)(478600001)(186003)(26005)(41300700001)(81166007)(83380400001)(36860700001)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 17:04:11.7112
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fa3bd2fc-074f-4138-0479-08da6ff20731
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3603
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

After mlx4 driver is converted to do locked reload,
devlink_region_snapshot_create() may be called from both locked and
unlocked context.

So resolve this by removing dependency on devlink->lock for region
snapshots list consistency and introduce new mutex to ensure it.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/core/devlink.c | 41 +++++++++++++++++++++++++++++------------
 1 file changed, 29 insertions(+), 12 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index da002791e300..4de1f93053a2 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -695,6 +695,10 @@ struct devlink_region {
 		const struct devlink_region_ops *ops;
 		const struct devlink_port_region_ops *port_ops;
 	};
+	struct mutex snapshot_lock; /* protects snapshot_list,
+				     * max_snapshots and cur_snapshots
+				     * consistency.
+				     */
 	struct list_head snapshot_list;
 	u32 max_snapshots;
 	u32 cur_snapshots;
@@ -5818,7 +5822,7 @@ static int __devlink_region_snapshot_id_get(struct devlink *devlink, u32 *id)
  *	Multiple snapshots can be created on a region.
  *	The @snapshot_id should be obtained using the getter function.
  *
- *	Must be called only while holding the devlink instance lock.
+ *	Must be called only while holding the region snapshot lock.
  *
  *	@region: devlink region of the snapshot
  *	@data: snapshot data
@@ -5832,7 +5836,7 @@ __devlink_region_snapshot_create(struct devlink_region *region,
 	struct devlink_snapshot *snapshot;
 	int err;
 
-	devl_assert_locked(devlink);
+	lockdep_assert_held(&region->snapshot_lock);
 
 	/* check if region can hold one more snapshot */
 	if (region->cur_snapshots == region->max_snapshots)
@@ -5870,7 +5874,7 @@ static void devlink_region_snapshot_del(struct devlink_region *region,
 {
 	struct devlink *devlink = region->devlink;
 
-	devl_assert_locked(devlink);
+	lockdep_assert_held(&region->snapshot_lock);
 
 	devlink_nl_region_notify(region, snapshot, DEVLINK_CMD_REGION_DEL);
 	region->cur_snapshots--;
@@ -6049,11 +6053,15 @@ static int devlink_nl_cmd_region_del(struct sk_buff *skb,
 	if (!region)
 		return -EINVAL;
 
+	mutex_lock(&region->snapshot_lock);
 	snapshot = devlink_region_snapshot_get_by_id(region, snapshot_id);
-	if (!snapshot)
+	if (!snapshot) {
+		mutex_unlock(&region->snapshot_lock);
 		return -EINVAL;
+	}
 
 	devlink_region_snapshot_del(region, snapshot);
+	mutex_unlock(&region->snapshot_lock);
 	return 0;
 }
 
@@ -6101,9 +6109,12 @@ devlink_nl_cmd_region_new(struct sk_buff *skb, struct genl_info *info)
 		return -EOPNOTSUPP;
 	}
 
+	mutex_lock(&region->snapshot_lock);
+
 	if (region->cur_snapshots == region->max_snapshots) {
 		NL_SET_ERR_MSG_MOD(info->extack, "The region has reached the maximum number of stored snapshots");
-		return -ENOSPC;
+		err = -ENOSPC;
+		goto unlock;
 	}
 
 	snapshot_id_attr = info->attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID];
@@ -6112,17 +6123,18 @@ devlink_nl_cmd_region_new(struct sk_buff *skb, struct genl_info *info)
 
 		if (devlink_region_snapshot_get_by_id(region, snapshot_id)) {
 			NL_SET_ERR_MSG_MOD(info->extack, "The requested snapshot id is already in use");
-			return -EEXIST;
+			err = -EEXIST;
+			goto unlock;
 		}
 
 		err = __devlink_snapshot_id_insert(devlink, snapshot_id);
 		if (err)
-			return err;
+			goto unlock;
 	} else {
 		err = __devlink_region_snapshot_id_get(devlink, &snapshot_id);
 		if (err) {
 			NL_SET_ERR_MSG_MOD(info->extack, "Failed to allocate a new snapshot id");
-			return err;
+			goto unlock;
 		}
 	}
 
@@ -6160,16 +6172,20 @@ devlink_nl_cmd_region_new(struct sk_buff *skb, struct genl_info *info)
 			goto err_notify;
 	}
 
+	mutex_unlock(&region->snapshot_lock);
 	return 0;
 
 err_snapshot_create:
 	region->ops->destructor(data);
 err_snapshot_capture:
 	__devlink_snapshot_id_decrement(devlink, snapshot_id);
+	mutex_unlock(&region->snapshot_lock);
 	return err;
 
 err_notify:
 	devlink_region_snapshot_del(region, snapshot);
+unlock:
+	mutex_unlock(&region->snapshot_lock);
 	return err;
 }
 
@@ -11095,6 +11111,7 @@ struct devlink_region *devl_region_create(struct devlink *devlink,
 	region->ops = ops;
 	region->size = region_size;
 	INIT_LIST_HEAD(&region->snapshot_list);
+	mutex_init(&region->snapshot_lock);
 	list_add_tail(&region->list, &devlink->region_list);
 	devlink_nl_region_notify(region, NULL, DEVLINK_CMD_REGION_NEW);
 
@@ -11168,6 +11185,7 @@ devlink_port_region_create(struct devlink_port *port,
 	region->port_ops = ops;
 	region->size = region_size;
 	INIT_LIST_HEAD(&region->snapshot_list);
+	mutex_init(&region->snapshot_lock);
 	list_add_tail(&region->list, &port->region_list);
 	devlink_nl_region_notify(region, NULL, DEVLINK_CMD_REGION_NEW);
 
@@ -11197,6 +11215,7 @@ void devl_region_destroy(struct devlink_region *region)
 		devlink_region_snapshot_del(region, snapshot);
 
 	list_del(&region->list);
+	mutex_destroy(&region->snapshot_lock);
 
 	devlink_nl_region_notify(region, NULL, DEVLINK_CMD_REGION_DEL);
 	kfree(region);
@@ -11272,13 +11291,11 @@ EXPORT_SYMBOL_GPL(devlink_region_snapshot_id_put);
 int devlink_region_snapshot_create(struct devlink_region *region,
 				   u8 *data, u32 snapshot_id)
 {
-	struct devlink *devlink = region->devlink;
 	int err;
 
-	devl_lock(devlink);
+	mutex_lock(&region->snapshot_lock);
 	err = __devlink_region_snapshot_create(region, data, snapshot_id);
-	devl_unlock(devlink);
-
+	mutex_unlock(&region->snapshot_lock);
 	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_region_snapshot_create);
-- 
2.18.2

