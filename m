Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC32E5843A2
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 17:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231630AbiG1Pye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 11:54:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbiG1Pya (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 11:54:30 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2070.outbound.protection.outlook.com [40.107.93.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B2A16BD64
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 08:54:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gGpHmIfueSB3nDrWPx1quxsG5t/TP7jgm2L90kj/RKvv7jb+3KrW/F+XJiGMo728RuoErOnl0Mk9R+De7uUBl1DoBHletlnx7Dvawc70NHyXEYECcs1JA+KpHbx7A0YPICLb4rAdfLoxfXm0DQvYz+QLFz9SvoZl3FuTaBL2TcupqbNBrCKxYGPpMLt8mIvuNEPcEN86EvE4D8mzRoIOhiVbOXX641h71dgDahlvuXX1X7t/uKCU1uJeJLkOBFRD9EDJlIfrwsG1GdkxWKlXKjetV53fWAwsbp7ilVnU0OeyN0kb9hTlU2h01AzxleklAgJPw6N+iGLXkvIs0hwuUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=48U8P8DfAzqcHemHFepGsX3gL0xGFg1FXWX+kEDtIe0=;
 b=fu8C1RDjPGGFEM3yxgshWNx0fKld8+stTcA4r8dvYmRpCwzO1ANP64mCo5eTsZFF+8enhCLieyDfDo5HuW/u7BDX0OJqdYtNZPEjTPudUq46HanPGZnc2iSwLbx7qQJ4vy37Hxc6RLI8RQMfsOA9HMXb+1PYoAMIQ4V5gQtfju90SWdiEWkjKrps88HtggYk3tSsGXRnyJRmx9GBc41ncklaQQv15oDGsWrczOwNa9gcbiC36RcH3RfEG0lYotvesExy6rloXMiP6xKv4KQXs3SfQhs3HsR5KBWO1ZeIHwbafAbaYx99zW4V9umPPLvUYLRHIZoX9tPjlBU01ShFEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=48U8P8DfAzqcHemHFepGsX3gL0xGFg1FXWX+kEDtIe0=;
 b=bWsXGLXa4rMa7cOPM2te/7zO1JnWHRVSPL1JOs4CZM3C30lllexjdWbZufwMg3IO1t7fSKPJjyEkBUCxTtwJca6VNiBkU0SvgRNx1cUmIzC7kVVyWgv4adxJH+PG1wgWAyHuaJ2bxwuZGZif2G96Z4CfVawtWhXfaFhxsKpO1UhC7eZ0EUv27+67Zvcf8qOPOvJa+080EJ/5X0o8pUn6yINZVhmoaBlk1KRhnN8EOuDtESsCRRygw18HTjoEDs7AmYEcqSVo7R1ewjNEPUr3ktQok7ynuCvOy0zO5My4FfNaUfYZSEVVBo5I3x5rfES7nFDaJzBO9GSltzThAdwRDg==
Received: from DM6PR14CA0068.namprd14.prod.outlook.com (2603:10b6:5:18f::45)
 by BYAPR12MB2983.namprd12.prod.outlook.com (2603:10b6:a03:d6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.21; Thu, 28 Jul
 2022 15:54:27 +0000
Received: from DM6NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:18f:cafe::2) by DM6PR14CA0068.outlook.office365.com
 (2603:10b6:5:18f::45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.23 via Frontend
 Transport; Thu, 28 Jul 2022 15:54:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT064.mail.protection.outlook.com (10.13.172.234) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5482.10 via Frontend Transport; Thu, 28 Jul 2022 15:54:27 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Thu, 28 Jul 2022 15:54:26 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Thu, 28 Jul 2022 08:54:26 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Thu, 28 Jul 2022 08:54:23 -0700
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "Tariq Toukan" <tariqt@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Jiri Pirko <jiri@nvidia.com>, <netdev@vger.kernel.org>
Subject: [PATCH net-next v2 2/9] net: devlink: remove region snapshots list dependency on devlink->lock
Date:   Thu, 28 Jul 2022 18:53:43 +0300
Message-ID: <1659023630-32006-3-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1659023630-32006-1-git-send-email-moshe@nvidia.com>
References: <1659023630-32006-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3d18cdd2-b2b0-4db3-98b6-08da70b1736c
X-MS-TrafficTypeDiagnostic: BYAPR12MB2983:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BL3tZYcLwpkNbiiUNAvy5V/L5i5pTKeNsuP+cJvHRtV4nrSfUnl2KgQ/Z9JAVJuSuk1yAla//SFBU+oJowciW35sxB3Xj2FXC6WbnS6I+GF9KBGRFK4YQbIhpgC2wKj/ZBw2oZegmSdNxMZ15dkEnZtEnAeSF87eDet/l1gEVtkKx9H89qRZAz8OvSWUXwW78oK+AeEMrw+uqFb9C+K1dEXLTpoTVmBWGP14XvrE+gIJSJHgu8/Gwmyw9wdarRHKZuCZ816BhaZl+j5oxyB5uA7wC0KyukTxbXJjscok/qYFMg3mwDz1lpBKTaJsVj9K6wmLvy8AK03ed9YQH9XQ2DSPOrQQFHkx9ayrYCM1vNTBmMzo9MW5CZJa9rzVbT1WBJHvjAMjbmipe4kCI/7Gbzw7g/TlVlL476X41qzBc0LFeFhRfPwMs5HoLdbwLQQM12zg0kzBXzRPQ7Z5mEuQkjsutA3A7jkF6/YVEW600USkOR5CtXNw42C7juArCUeVDcQiqheAByFPVEykmR2RRykDjOwv9YLKqBysGaonjlsJaoib+Ae+a81E/sIY44CkrbnGIuUSo0upLISmUc36Av9CqopsuVwUGT/PDqioIz9XeNGxsMRRAUwaRHv5HTi9CUd9vflyyk31zLQnfRM5KO/Xn6kNifsLp/B+HnGl+bU4QZqDLQD87GBrCKp+2y5/XQr3uTDKsHayqyQQJuwiyF7imI9r1Mw/e69wDdbSNMrwNaHXo0uOgoICf2SK9xsa4OAUxqvKTCqgb8vT0nACOZVb7XfXPvTVJ+DKbFpmblyjLuH9KNuihiut552hF/sdvd+YcFcc9IHtQLeCdwBsYQ==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(396003)(39860400002)(136003)(36840700001)(46966006)(40470700004)(83380400001)(2906002)(8936002)(40460700003)(54906003)(356005)(40480700001)(26005)(186003)(2616005)(478600001)(7696005)(336012)(426003)(5660300002)(6666004)(47076005)(41300700001)(82740400003)(82310400005)(70586007)(110136005)(316002)(8676002)(36756003)(4326008)(81166007)(86362001)(36860700001)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 15:54:27.3115
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d18cdd2-b2b0-4db3-98b6-08da70b1736c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2983
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

Note that in mlx4 region snapshots could be created on any command
failure. That can happen in any flow that involves commands to FW,
which means most of the driver flows.

So resolve this by removing dependency on devlink->lock for region
snapshots list consistency and introduce new mutex to ensure it.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
v1->v2:
- enhanced patch description
---
 net/core/devlink.c | 41 +++++++++++++++++++++++++++++------------
 1 file changed, 29 insertions(+), 12 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 64d150516e45..274dafd8a594 100644
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
@@ -5817,7 +5821,7 @@ static int __devlink_region_snapshot_id_get(struct devlink *devlink, u32 *id)
  *	Multiple snapshots can be created on a region.
  *	The @snapshot_id should be obtained using the getter function.
  *
- *	Must be called only while holding the devlink instance lock.
+ *	Must be called only while holding the region snapshot lock.
  *
  *	@region: devlink region of the snapshot
  *	@data: snapshot data
@@ -5831,7 +5835,7 @@ __devlink_region_snapshot_create(struct devlink_region *region,
 	struct devlink_snapshot *snapshot;
 	int err;
 
-	devl_assert_locked(devlink);
+	lockdep_assert_held(&region->snapshot_lock);
 
 	/* check if region can hold one more snapshot */
 	if (region->cur_snapshots == region->max_snapshots)
@@ -5869,7 +5873,7 @@ static void devlink_region_snapshot_del(struct devlink_region *region,
 {
 	struct devlink *devlink = region->devlink;
 
-	devl_assert_locked(devlink);
+	lockdep_assert_held(&region->snapshot_lock);
 
 	devlink_nl_region_notify(region, snapshot, DEVLINK_CMD_REGION_DEL);
 	region->cur_snapshots--;
@@ -6048,11 +6052,15 @@ static int devlink_nl_cmd_region_del(struct sk_buff *skb,
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
 
@@ -6100,9 +6108,12 @@ devlink_nl_cmd_region_new(struct sk_buff *skb, struct genl_info *info)
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
@@ -6111,17 +6122,18 @@ devlink_nl_cmd_region_new(struct sk_buff *skb, struct genl_info *info)
 
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
 
@@ -6159,16 +6171,20 @@ devlink_nl_cmd_region_new(struct sk_buff *skb, struct genl_info *info)
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
 
@@ -11094,6 +11110,7 @@ struct devlink_region *devl_region_create(struct devlink *devlink,
 	region->ops = ops;
 	region->size = region_size;
 	INIT_LIST_HEAD(&region->snapshot_list);
+	mutex_init(&region->snapshot_lock);
 	list_add_tail(&region->list, &devlink->region_list);
 	devlink_nl_region_notify(region, NULL, DEVLINK_CMD_REGION_NEW);
 
@@ -11167,6 +11184,7 @@ devlink_port_region_create(struct devlink_port *port,
 	region->port_ops = ops;
 	region->size = region_size;
 	INIT_LIST_HEAD(&region->snapshot_list);
+	mutex_init(&region->snapshot_lock);
 	list_add_tail(&region->list, &port->region_list);
 	devlink_nl_region_notify(region, NULL, DEVLINK_CMD_REGION_NEW);
 
@@ -11196,6 +11214,7 @@ void devl_region_destroy(struct devlink_region *region)
 		devlink_region_snapshot_del(region, snapshot);
 
 	list_del(&region->list);
+	mutex_destroy(&region->snapshot_lock);
 
 	devlink_nl_region_notify(region, NULL, DEVLINK_CMD_REGION_DEL);
 	kfree(region);
@@ -11271,13 +11290,11 @@ EXPORT_SYMBOL_GPL(devlink_region_snapshot_id_put);
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

