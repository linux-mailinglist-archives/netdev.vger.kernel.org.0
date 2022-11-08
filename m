Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C400620D99
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 11:48:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233961AbiKHKsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 05:48:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233955AbiKHKsF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 05:48:05 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2057.outbound.protection.outlook.com [40.107.220.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C20AE41994
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 02:48:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oU7RpEORM4qYepo/8LCjExD9x44vyMyoAb1FIDQY8OVCvmRTxj7xSfRfmghHO+ayscPu96XbWNH0bNerF8+QXjyktKt/IABMycAQfDgW90Gmke4Lx+EdkXfLz+K2IvRM3nLMOqoVhm39Pwf4FYNzur91ZAQEDzYyVe+9WKMgDaMlT6+CdeewgUDGUJ++ThoYeBlVMxs9ni2Ul7s3ZeT9o7Hc5KaTrti9H+tQkTmIQopfYFeCeCmmFnt4JxkBwRt+nsXMbtxDqqKx2YcxfvoHvWc4lwiUrQnVbR4IbvLE5je4z9X5krV4xWWOkjsrpMPfPNobXWdfuzKVWtprdoG/7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l7DEUJc2u2U3TTxDUpB8poMa2Pk7ZwYtl+Wds4ifdKY=;
 b=BdjCvDjMZn0ejAReNzd4qxI1nEmPcOWDY/f0iq9XuKq1qAh1boK20nZb4EaSY5KNj4wP4pZ2qB+7uhM0UuDegAN6Fnf0jcZxRKv/j4+fQqhXHQ6vcY97bq2hGjKvU2BILpLMu6Jjbb1nJRusKcwfE1VZdADueWoDORQbjnUJKG0Gl/J1xHxGdLCrJOzGdCdNlOpaBUoLzeLfL5JDipE3mFz6U4nHpBEEG3LJkHfFaRgezQaBjoM8waIThcNS13N0gQPfflkiSNkBpsGxeRbQ4INpdekg5AQQjn3kosVJzLzbnWx55koCcx4RCCKUg/v6o0lRQKmZcTvUjHW/CgQsTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l7DEUJc2u2U3TTxDUpB8poMa2Pk7ZwYtl+Wds4ifdKY=;
 b=ox7kX7p+XIFC11rQToU5szyiAMSueJFt+jPf09fnz+qd8gilXjyIW7THKURREsz3NkoUcK/azE5Hu+SWvJGFXczxOZzNNeQuYeCdACPCSWSInvfHpWsn4mX+WAtralK8lFR3otKVxwzwaXaCGOI7efpufNTLz+mItSIuq8wTVCT+rVsYdrBhbrGkawVmltgxuNVEDc2cSQY92EgwKj27rE2dpPPp0xN0UeA6YYsCcjPyQF3FXpybk27g6rAeBar8504PT8c9eSV1N2WIGhnwsV8Fh4+S5ryHrCLZo8Q8ZoXMn14fur1zFKS6+rcZPhzamrkfI3iaWE3bFFXeLQSgpA==
Received: from BN8PR04CA0051.namprd04.prod.outlook.com (2603:10b6:408:d4::25)
 by BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Tue, 8 Nov
 2022 10:48:00 +0000
Received: from BN8NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:d4:cafe::c3) by BN8PR04CA0051.outlook.office365.com
 (2603:10b6:408:d4::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27 via Frontend
 Transport; Tue, 8 Nov 2022 10:48:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT028.mail.protection.outlook.com (10.13.176.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.20 via Frontend Transport; Tue, 8 Nov 2022 10:47:59 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 8 Nov 2022
 02:47:45 -0800
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Tue, 8 Nov 2022 02:47:41 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ivan Vecera <ivecera@redhat.com>, <netdev@vger.kernel.org>
CC:     Nikolay Aleksandrov <razor@blackwall.org>,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        <bridge@lists.linux-foundation.org>,
        Ido Schimmel <idosch@nvidia.com>,
        "Hans J . Schultz" <netdev@kapio-technology.com>,
        <mlxsw@nvidia.com>
Subject: [PATCH net-next 02/15] bridge: switchdev: Allow device drivers to install locked FDB entries
Date:   Tue, 8 Nov 2022 11:47:08 +0100
Message-ID: <68167a3ebca74bb7cd45da0ff7c1268a70c33a96.1667902754.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1667902754.git.petrm@nvidia.com>
References: <cover.1667902754.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT028:EE_|BN9PR12MB5259:EE_
X-MS-Office365-Filtering-Correlation-Id: 8297ccc6-feed-47e8-1cd3-08dac176b446
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5VmVcRYgO6juEBrE9bztqJAxi5Q1ov2LKACVEx8ZCeCcByP5iv/o3qIMITKc71IOV6e3g6XyeSTspE3pxdwmgM9mUk/0dtQFcBJb5rjVinYlAYVguKdAw1THfiYNj9gFBYjxjrjI4i3dGYh0Lqv6m4tJFliCjHiwgyCBXVEIJi66MgLEg8iphffPbZGkOD6gvULENJvjy0icnxch4kzc5He6JMoSTWMl93VnlUo29YcLk0dMIUCXyzbLgDmgCJPo3GXUE3oAnK6Tzu6KyjFH0Fc0zG0pi7qqoUkGp0hzPK6UXrlRHKm5jd+Fm/PDBUu1k4Lqy3Ybe6tbHTASUyVZRhHvwpDShDq5ORJdQWfJKT58u1QxYoTuTxebekwoCYuUrTX1TAt43CGZcz0z4jUt+8Hvpah6Cwr98rZNEWPEEHE/7QeL8nZz5srCn/ghZCL8Cpln1YYm90L6+RXKxE9SRd+HGzxA2badQIZsT9Eavoop5L7qK53yCTCRJ5MDiMvKfOpwdp827NYrH21kQyXuy1LZuf6hLeAJX6IKv6cu2tm6l30Umz8zTgWZYW7BV7HxtY63h1OMcirKg2naFx3l6urU0QVSZtvGNzTx6aDc7UxJ4YW1hCzyjo0BZqJVB1ldNuDzNdUYnu0SYrz1IbInhTa57cz35XD9SJ8N96KYoxTNWFhxUcf3d/5RQSVCtxF5VBRuEXqdRCVqce/a1xucA1qOyv0626nhq/aH97AjsAbshTNr9xltaj+/Qea6cGdLozxnt+KI6PiQ1D06jxTFcg==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(39860400002)(136003)(376002)(451199015)(46966006)(36840700001)(40470700004)(478600001)(82310400005)(356005)(7636003)(86362001)(6666004)(54906003)(107886003)(110136005)(82740400003)(36756003)(40460700003)(8936002)(316002)(83380400001)(7696005)(26005)(41300700001)(40480700001)(70206006)(8676002)(4326008)(70586007)(336012)(186003)(2616005)(16526019)(36860700001)(426003)(5660300002)(2906002)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2022 10:47:59.9110
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8297ccc6-feed-47e8-1cd3-08dac176b446
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5259
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hans J. Schultz <netdev@kapio-technology.com>

When the bridge is offloaded to hardware, FDB entries are learned and
aged-out by the hardware. Some device drivers synchronize the hardware
and software FDBs by generating switchdev events towards the bridge.

When a port is locked, the hardware must not learn autonomously, as
otherwise any host will blindly gain authorization. Instead, the
hardware should generate events regarding hosts that are trying to gain
authorization and their MAC addresses should be notified by the device
driver as locked FDB entries towards the bridge driver.

Allow device drivers to notify the bridge driver about such entries by
extending the 'switchdev_notifier_fdb_info' structure with the 'locked'
bit. The bit can only be set by device drivers and not by the bridge
driver.

Prevent a locked entry from being installed if MAB is not enabled on the
bridge port.

If an entry already exists in the bridge driver, reject the locked entry
if the current entry does not have the "locked" flag set or if it points
to a different port. The same semantics are implemented in the software
data path.

Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---

Notes:
    v1:
    * Adjust commit message.
    * Add a check in br_switchdev_fdb_notify().
    * Use 'false' instead of '0' in br_switchdev_fdb_populate().
    
    Changes made by Ido:
    * Reword commit message.
    * Forbid locked entries when MAB is not enabled.
    * Forbid roaming of locked entries.
    * Avoid setting 'locked' bit towards device drivers.

 include/net/switchdev.h   |  1 +
 net/bridge/br.c           |  3 ++-
 net/bridge/br_fdb.c       | 22 ++++++++++++++++++++--
 net/bridge/br_private.h   |  2 +-
 net/bridge/br_switchdev.c |  4 ++++
 5 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index 7dcdc97c0bc3..ca0312b78294 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -248,6 +248,7 @@ struct switchdev_notifier_fdb_info {
 	u16 vid;
 	u8 added_by_user:1,
 	   is_local:1,
+	   locked:1,
 	   offloaded:1;
 };
 
diff --git a/net/bridge/br.c b/net/bridge/br.c
index 145999b8c355..4f5098d33a46 100644
--- a/net/bridge/br.c
+++ b/net/bridge/br.c
@@ -166,7 +166,8 @@ static int br_switchdev_event(struct notifier_block *unused,
 	case SWITCHDEV_FDB_ADD_TO_BRIDGE:
 		fdb_info = ptr;
 		err = br_fdb_external_learn_add(br, p, fdb_info->addr,
-						fdb_info->vid, false);
+						fdb_info->vid,
+						fdb_info->locked, false);
 		if (err) {
 			err = notifier_from_errno(err);
 			break;
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 3b83af4458b8..e69a872bfc1d 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -1139,7 +1139,7 @@ static int __br_fdb_add(struct ndmsg *ndm, struct net_bridge *br,
 					   "FDB entry towards bridge must be permanent");
 			return -EINVAL;
 		}
-		err = br_fdb_external_learn_add(br, p, addr, vid, true);
+		err = br_fdb_external_learn_add(br, p, addr, vid, false, true);
 	} else {
 		spin_lock_bh(&br->hash_lock);
 		err = fdb_add_entry(br, p, addr, ndm, nlh_flags, vid, nfea_tb);
@@ -1377,7 +1377,7 @@ void br_fdb_unsync_static(struct net_bridge *br, struct net_bridge_port *p)
 }
 
 int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
-			      const unsigned char *addr, u16 vid,
+			      const unsigned char *addr, u16 vid, bool locked,
 			      bool swdev_notify)
 {
 	struct net_bridge_fdb_entry *fdb;
@@ -1386,6 +1386,9 @@ int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
 
 	trace_br_fdb_external_learn_add(br, p, addr, vid);
 
+	if (locked && (!p || !(p->flags & BR_PORT_MAB)))
+		return -EINVAL;
+
 	spin_lock_bh(&br->hash_lock);
 
 	fdb = br_fdb_find(br, addr, vid);
@@ -1398,6 +1401,9 @@ int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
 		if (!p)
 			flags |= BIT(BR_FDB_LOCAL);
 
+		if (locked)
+			flags |= BIT(BR_FDB_LOCKED);
+
 		fdb = fdb_create(br, p, addr, vid, flags);
 		if (!fdb) {
 			err = -ENOMEM;
@@ -1405,6 +1411,13 @@ int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
 		}
 		fdb_notify(br, fdb, RTM_NEWNEIGH, swdev_notify);
 	} else {
+		if (locked &&
+		    (!test_bit(BR_FDB_LOCKED, &fdb->flags) ||
+		     READ_ONCE(fdb->dst) != p)) {
+			err = -EINVAL;
+			goto err_unlock;
+		}
+
 		fdb->updated = jiffies;
 
 		if (READ_ONCE(fdb->dst) != p) {
@@ -1421,6 +1434,11 @@ int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
 			modified = true;
 		}
 
+		if (locked != test_bit(BR_FDB_LOCKED, &fdb->flags)) {
+			change_bit(BR_FDB_LOCKED, &fdb->flags);
+			modified = true;
+		}
+
 		if (swdev_notify)
 			set_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
 
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 4ce8b8e5ae0b..4c4fda930068 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -811,7 +811,7 @@ int br_fdb_sync_static(struct net_bridge *br, struct net_bridge_port *p);
 void br_fdb_unsync_static(struct net_bridge *br, struct net_bridge_port *p);
 int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
 			      const unsigned char *addr, u16 vid,
-			      bool swdev_notify);
+			      bool locked, bool swdev_notify);
 int br_fdb_external_learn_del(struct net_bridge *br, struct net_bridge_port *p,
 			      const unsigned char *addr, u16 vid,
 			      bool swdev_notify);
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index 8f3d76c751dd..8a0abe35137d 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -136,6 +136,7 @@ static void br_switchdev_fdb_populate(struct net_bridge *br,
 	item->added_by_user = test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
 	item->offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags);
 	item->is_local = test_bit(BR_FDB_LOCAL, &fdb->flags);
+	item->locked = false;
 	item->info.dev = (!p || item->is_local) ? br->dev : p->dev;
 	item->info.ctx = ctx;
 }
@@ -146,6 +147,9 @@ br_switchdev_fdb_notify(struct net_bridge *br,
 {
 	struct switchdev_notifier_fdb_info item;
 
+	if (test_bit(BR_FDB_LOCKED, &fdb->flags))
+		return;
+
 	br_switchdev_fdb_populate(br, &item, fdb, NULL);
 
 	switch (type) {
-- 
2.35.3

