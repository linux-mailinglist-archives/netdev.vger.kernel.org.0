Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C359E6969DE
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 17:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231882AbjBNQix (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 11:38:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232414AbjBNQig (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 11:38:36 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2065.outbound.protection.outlook.com [40.107.237.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DBBD2C656
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 08:38:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iDGuyfdZb4MPv7Bw4tS1oMtsHphYkhG7wYqjTWd3ZVV1/I9EgXHx0pBMJFdh+TXBqsrFPBrSm5ceiMcXKDNaTJriMX4oSh3d5mTaAyaJr3Bh4NGV1RP0lTUgUL7kX7FPTL1BFb11ONzlZ+mwOxs9WnGZFtQTRKO/pvr1Qalm24m4NfadA6+oKYQsqhxsoE5b2h/A8UxhFBlCOlNt4dB87yuxjh9c9B1c3IH2/0P61OCWY408BsjOhbwlO9g0moG3qIM7b3f6WM59f8w2CMtZA12Sjn7TKjiauovakmE50Da0jUrQ6vs7+IObaT2MpMc0A0DdhNvwHsylGoxh5yTNAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/HRky/mklUbUGEQEfTapTrRLQDerTiJ8ALml8rydypg=;
 b=iH96d1kpJ2Wl2a+rJNwQ41WjY0VFUMg26TYakiov8R/WaxnSDIXTrVXtNmXlCPAEiRjCu3sGjOmPLKa0NDW5v/61pEluE4c5XczbDgjmYdX+IFsvvS+VMujNaLKZkp0aRX+oNAXfo8FwXmFP94OLQbeYyhFfVEs5lazQNXB7gbwpImFNltK3CYtIkNfpi/7fxHlrisoQ6oJ3rEFx8fivCADqwBhtupNQocSGVNyvUffj1ynapR7sNKeE9SdHSIui2AC1ESzujZ4TWL//SvJWFr8I8if/jMdp+dnvWw/9fZqFFsbecdbvGJ6AAjVFhFyNbC2vHlrLgiGkDv0dAcZ9Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/HRky/mklUbUGEQEfTapTrRLQDerTiJ8ALml8rydypg=;
 b=C31SZpdLUz8fsgS2J9JWQiJb1GyOlr+RmLifxFxNI0PVMrVO4PofMXnXyAI28G25S/46iYvGa6uah9IgEHSNyTFruhWO8JRm+yv9sWItZeDH1h6sFfgg5iPdzWuxC2yMLPOJXM/M3NvmRkzrLSeiffkWiq9l7vXqy33Z0qBPpH5SXOqBXCrvT/2fAuLzfhnvABf7AJXB4kJ06E0P9BXepQfTQtk3QtYTozG8BrwdFgc5wYKc7Yg5H4HMcMIPhtoedy/FCuFLSqUbvL6KbnuDlWvUei6XgEYY4a0ivSWz+hBV31sdvsl7ay3Uj2I5WZhCKBIZ41G/wgFnu6lZAUY5uQ==
Received: from BN8PR04CA0046.namprd04.prod.outlook.com (2603:10b6:408:d4::20)
 by MN0PR12MB5858.namprd12.prod.outlook.com (2603:10b6:208:379::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Tue, 14 Feb
 2023 16:38:27 +0000
Received: from BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:d4:cafe::2) by BN8PR04CA0046.outlook.office365.com
 (2603:10b6:408:d4::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24 via Frontend
 Transport; Tue, 14 Feb 2023 16:38:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN8NAM11FT020.mail.protection.outlook.com (10.13.176.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.26 via Frontend Transport; Tue, 14 Feb 2023 16:38:27 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 14 Feb
 2023 08:38:19 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Tue, 14 Feb 2023 08:38:18 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Tue, 14 Feb 2023 08:38:17 -0800
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        <netdev@vger.kernel.org>
CC:     Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next v2 04/10] devlink: Move devlink health report and recover to health file
Date:   Tue, 14 Feb 2023 18:38:00 +0200
Message-ID: <1676392686-405892-5-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1676392686-405892-1-git-send-email-moshe@nvidia.com>
References: <1676392686-405892-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT020:EE_|MN0PR12MB5858:EE_
X-MS-Office365-Filtering-Correlation-Id: 8177641f-1185-4fde-0890-08db0ea9e5e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x6Ua8qJcr11ewR1v9HQyE/fARZd93xbAKtaQEMGBuihYeigj30e1vGRFwJxcr/OrxE4Vba1CQWWsxz7/6UZdmKoUCDrB56UxO+SuzpISd16pI1va+dtT9/I+rjxngjMjTwRqNVezfyjHfOPjbwDrS/Nk+4W2vthVN+GqWitRlbqQStCQ/r6G1NuFmckMAjAn6rMB2Ydud+B+zvtcbDnfqls9TWR9U0qK52weVJZjcgzGRtjXzqpzekkajy2Z4pv75C7wcjvy8+hNV5I9Gg8wF/AwQ8cRs2WuaiPFGXgQRrgBo3rsflkDM6GK6MuwfTw/ZIoTOqfMYDpWPNXyaJ+BEJ7uFOvxaVZjCjnAYs9mIltnjkEOBgPE5vjxJ+TIvAGF5BPaDr2sRrdzRtd+++a5xl8/UZFjJFwUkxoR7m8qvZN8enosH8zfYi2QRBEwKmVynGcaTl2AFQHtXY6EyIgjipMqWF0X+D89IusRkOf9G5JVW8tnaNSGHFpyMv2V6qDBEh0J7k91g+CQ2BY3J9HO067N8Jmy37SFyYEIcAzRfe3agfXrZ71m+2Ge4njvRiLnGQfCof/j1YOOqlnbesiB9hVuCDQcfWCKiiGubl5Be+2qgJigDfXKxhf6lX+aLnHCBUf3JsWoAS1koUvF2INEpX2qG8Kmbfufu80LUJZwtPj6rT6J4Fj1JGoaaEIZJqU49gfDSI0POcsOKLSjwVhDVQ==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(39860400002)(346002)(376002)(451199018)(40470700004)(46966006)(36840700001)(30864003)(41300700001)(8936002)(316002)(70586007)(70206006)(8676002)(4326008)(110136005)(2906002)(5660300002)(426003)(7696005)(36756003)(478600001)(36860700001)(336012)(186003)(6666004)(107886003)(40480700001)(86362001)(7636003)(40460700003)(47076005)(356005)(26005)(82310400005)(83380400001)(2616005)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 16:38:27.0698
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8177641f-1185-4fde-0890-08db0ea9e5e9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5858
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move devlink health report helper and recover callback and related code
from leftover.c to health.c. No functional change in this patch.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
---
 net/devlink/devl_internal.h |   5 ++
 net/devlink/health.c        | 136 ++++++++++++++++++++++++++++++++++
 net/devlink/leftover.c      | 141 +-----------------------------------
 3 files changed, 144 insertions(+), 138 deletions(-)

diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index 085f80b5feb8..d1a901cb5900 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -237,6 +237,9 @@ devlink_nl_health_reporter_fill(struct sk_buff *msg,
 				struct devlink_health_reporter *reporter,
 				enum devlink_command cmd, u32 portid,
 				u32 seq, int flags);
+int devlink_health_do_dump(struct devlink_health_reporter *reporter,
+			   void *priv_ctx,
+			   struct netlink_ext_ack *extack);
 
 void devlink_fmsg_free(struct devlink_fmsg *fmsg);
 
@@ -267,3 +270,5 @@ int devlink_nl_cmd_health_reporter_get_doit(struct sk_buff *skb,
 					    struct genl_info *info);
 int devlink_nl_cmd_health_reporter_set_doit(struct sk_buff *skb,
 					    struct genl_info *info);
+int devlink_nl_cmd_health_reporter_recover_doit(struct sk_buff *skb,
+						struct genl_info *info);
diff --git a/net/devlink/health.c b/net/devlink/health.c
index 1c92f369c918..bfeb71f17ff0 100644
--- a/net/devlink/health.c
+++ b/net/devlink/health.c
@@ -5,6 +5,7 @@
  */
 
 #include <net/genetlink.h>
+#include <trace/events/devlink.h>
 #include "devl_internal.h"
 
 void *
@@ -408,3 +409,138 @@ int devlink_nl_cmd_health_reporter_set_doit(struct sk_buff *skb,
 
 	return 0;
 }
+
+static void devlink_recover_notify(struct devlink_health_reporter *reporter,
+				   enum devlink_command cmd)
+{
+	struct devlink *devlink = reporter->devlink;
+	struct sk_buff *msg;
+	int err;
+
+	WARN_ON(cmd != DEVLINK_CMD_HEALTH_REPORTER_RECOVER);
+	WARN_ON(!xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED));
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return;
+
+	err = devlink_nl_health_reporter_fill(msg, reporter, cmd, 0, 0, 0);
+	if (err) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	genlmsg_multicast_netns(&devlink_nl_family, devlink_net(devlink), msg,
+				0, DEVLINK_MCGRP_CONFIG, GFP_KERNEL);
+}
+
+void
+devlink_health_reporter_recovery_done(struct devlink_health_reporter *reporter)
+{
+	reporter->recovery_count++;
+	reporter->last_recovery_ts = jiffies;
+}
+EXPORT_SYMBOL_GPL(devlink_health_reporter_recovery_done);
+
+static int
+devlink_health_reporter_recover(struct devlink_health_reporter *reporter,
+				void *priv_ctx, struct netlink_ext_ack *extack)
+{
+	int err;
+
+	if (reporter->health_state == DEVLINK_HEALTH_REPORTER_STATE_HEALTHY)
+		return 0;
+
+	if (!reporter->ops->recover)
+		return -EOPNOTSUPP;
+
+	err = reporter->ops->recover(reporter, priv_ctx, extack);
+	if (err)
+		return err;
+
+	devlink_health_reporter_recovery_done(reporter);
+	reporter->health_state = DEVLINK_HEALTH_REPORTER_STATE_HEALTHY;
+	devlink_recover_notify(reporter, DEVLINK_CMD_HEALTH_REPORTER_RECOVER);
+
+	return 0;
+}
+
+int devlink_health_report(struct devlink_health_reporter *reporter,
+			  const char *msg, void *priv_ctx)
+{
+	enum devlink_health_reporter_state prev_health_state;
+	struct devlink *devlink = reporter->devlink;
+	unsigned long recover_ts_threshold;
+	int ret;
+
+	/* write a log message of the current error */
+	WARN_ON(!msg);
+	trace_devlink_health_report(devlink, reporter->ops->name, msg);
+	reporter->error_count++;
+	prev_health_state = reporter->health_state;
+	reporter->health_state = DEVLINK_HEALTH_REPORTER_STATE_ERROR;
+	devlink_recover_notify(reporter, DEVLINK_CMD_HEALTH_REPORTER_RECOVER);
+
+	/* abort if the previous error wasn't recovered */
+	recover_ts_threshold = reporter->last_recovery_ts +
+			       msecs_to_jiffies(reporter->graceful_period);
+	if (reporter->auto_recover &&
+	    (prev_health_state != DEVLINK_HEALTH_REPORTER_STATE_HEALTHY ||
+	     (reporter->last_recovery_ts && reporter->recovery_count &&
+	      time_is_after_jiffies(recover_ts_threshold)))) {
+		trace_devlink_health_recover_aborted(devlink,
+						     reporter->ops->name,
+						     reporter->health_state,
+						     jiffies -
+						     reporter->last_recovery_ts);
+		return -ECANCELED;
+	}
+
+	if (reporter->auto_dump) {
+		mutex_lock(&reporter->dump_lock);
+		/* store current dump of current error, for later analysis */
+		devlink_health_do_dump(reporter, priv_ctx, NULL);
+		mutex_unlock(&reporter->dump_lock);
+	}
+
+	if (!reporter->auto_recover)
+		return 0;
+
+	devl_lock(devlink);
+	ret = devlink_health_reporter_recover(reporter, priv_ctx, NULL);
+	devl_unlock(devlink);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(devlink_health_report);
+
+void
+devlink_health_reporter_state_update(struct devlink_health_reporter *reporter,
+				     enum devlink_health_reporter_state state)
+{
+	if (WARN_ON(state != DEVLINK_HEALTH_REPORTER_STATE_HEALTHY &&
+		    state != DEVLINK_HEALTH_REPORTER_STATE_ERROR))
+		return;
+
+	if (reporter->health_state == state)
+		return;
+
+	reporter->health_state = state;
+	trace_devlink_health_reporter_state_update(reporter->devlink,
+						   reporter->ops->name, state);
+	devlink_recover_notify(reporter, DEVLINK_CMD_HEALTH_REPORTER_RECOVER);
+}
+EXPORT_SYMBOL_GPL(devlink_health_reporter_state_update);
+
+int devlink_nl_cmd_health_reporter_recover_doit(struct sk_buff *skb,
+						struct genl_info *info)
+{
+	struct devlink *devlink = info->user_ptr[0];
+	struct devlink_health_reporter *reporter;
+
+	reporter = devlink_health_reporter_get_from_info(devlink, info);
+	if (!reporter)
+		return -EINVAL;
+
+	return devlink_health_reporter_recover(reporter, NULL, info->extack);
+}
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 0b1c5e0122f3..03184dd3d271 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -5963,61 +5963,6 @@ static int devlink_fmsg_dumpit(struct devlink_fmsg *fmsg, struct sk_buff *skb,
 	return err;
 }
 
-static void devlink_recover_notify(struct devlink_health_reporter *reporter,
-				   enum devlink_command cmd)
-{
-	struct devlink *devlink = reporter->devlink;
-	struct sk_buff *msg;
-	int err;
-
-	WARN_ON(cmd != DEVLINK_CMD_HEALTH_REPORTER_RECOVER);
-	WARN_ON(!xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED));
-
-	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
-	if (!msg)
-		return;
-
-	err = devlink_nl_health_reporter_fill(msg, reporter, cmd, 0, 0, 0);
-	if (err) {
-		nlmsg_free(msg);
-		return;
-	}
-
-	genlmsg_multicast_netns(&devlink_nl_family, devlink_net(devlink), msg,
-				0, DEVLINK_MCGRP_CONFIG, GFP_KERNEL);
-}
-
-void
-devlink_health_reporter_recovery_done(struct devlink_health_reporter *reporter)
-{
-	reporter->recovery_count++;
-	reporter->last_recovery_ts = jiffies;
-}
-EXPORT_SYMBOL_GPL(devlink_health_reporter_recovery_done);
-
-static int
-devlink_health_reporter_recover(struct devlink_health_reporter *reporter,
-				void *priv_ctx, struct netlink_ext_ack *extack)
-{
-	int err;
-
-	if (reporter->health_state == DEVLINK_HEALTH_REPORTER_STATE_HEALTHY)
-		return 0;
-
-	if (!reporter->ops->recover)
-		return -EOPNOTSUPP;
-
-	err = reporter->ops->recover(reporter, priv_ctx, extack);
-	if (err)
-		return err;
-
-	devlink_health_reporter_recovery_done(reporter);
-	reporter->health_state = DEVLINK_HEALTH_REPORTER_STATE_HEALTHY;
-	devlink_recover_notify(reporter, DEVLINK_CMD_HEALTH_REPORTER_RECOVER);
-
-	return 0;
-}
-
 static void
 devlink_health_dump_clear(struct devlink_health_reporter *reporter)
 {
@@ -6027,9 +5972,9 @@ devlink_health_dump_clear(struct devlink_health_reporter *reporter)
 	reporter->dump_fmsg = NULL;
 }
 
-static int devlink_health_do_dump(struct devlink_health_reporter *reporter,
-				  void *priv_ctx,
-				  struct netlink_ext_ack *extack)
+int devlink_health_do_dump(struct devlink_health_reporter *reporter,
+			   void *priv_ctx,
+			   struct netlink_ext_ack *extack)
 {
 	int err;
 
@@ -6068,55 +6013,6 @@ static int devlink_health_do_dump(struct devlink_health_reporter *reporter,
 	return err;
 }
 
-int devlink_health_report(struct devlink_health_reporter *reporter,
-			  const char *msg, void *priv_ctx)
-{
-	enum devlink_health_reporter_state prev_health_state;
-	struct devlink *devlink = reporter->devlink;
-	unsigned long recover_ts_threshold;
-	int ret;
-
-	/* write a log message of the current error */
-	WARN_ON(!msg);
-	trace_devlink_health_report(devlink, reporter->ops->name, msg);
-	reporter->error_count++;
-	prev_health_state = reporter->health_state;
-	reporter->health_state = DEVLINK_HEALTH_REPORTER_STATE_ERROR;
-	devlink_recover_notify(reporter, DEVLINK_CMD_HEALTH_REPORTER_RECOVER);
-
-	/* abort if the previous error wasn't recovered */
-	recover_ts_threshold = reporter->last_recovery_ts +
-			       msecs_to_jiffies(reporter->graceful_period);
-	if (reporter->auto_recover &&
-	    (prev_health_state != DEVLINK_HEALTH_REPORTER_STATE_HEALTHY ||
-	     (reporter->last_recovery_ts && reporter->recovery_count &&
-	      time_is_after_jiffies(recover_ts_threshold)))) {
-		trace_devlink_health_recover_aborted(devlink,
-						     reporter->ops->name,
-						     reporter->health_state,
-						     jiffies -
-						     reporter->last_recovery_ts);
-		return -ECANCELED;
-	}
-
-	if (reporter->auto_dump) {
-		mutex_lock(&reporter->dump_lock);
-		/* store current dump of current error, for later analysis */
-		devlink_health_do_dump(reporter, priv_ctx, NULL);
-		mutex_unlock(&reporter->dump_lock);
-	}
-
-	if (!reporter->auto_recover)
-		return 0;
-
-	devl_lock(devlink);
-	ret = devlink_health_reporter_recover(reporter, priv_ctx, NULL);
-	devl_unlock(devlink);
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(devlink_health_report);
-
 static struct devlink_health_reporter *
 devlink_health_reporter_get_from_cb(struct netlink_callback *cb)
 {
@@ -6135,37 +6031,6 @@ devlink_health_reporter_get_from_cb(struct netlink_callback *cb)
 	return reporter;
 }
 
-void
-devlink_health_reporter_state_update(struct devlink_health_reporter *reporter,
-				     enum devlink_health_reporter_state state)
-{
-	if (WARN_ON(state != DEVLINK_HEALTH_REPORTER_STATE_HEALTHY &&
-		    state != DEVLINK_HEALTH_REPORTER_STATE_ERROR))
-		return;
-
-	if (reporter->health_state == state)
-		return;
-
-	reporter->health_state = state;
-	trace_devlink_health_reporter_state_update(reporter->devlink,
-						   reporter->ops->name, state);
-	devlink_recover_notify(reporter, DEVLINK_CMD_HEALTH_REPORTER_RECOVER);
-}
-EXPORT_SYMBOL_GPL(devlink_health_reporter_state_update);
-
-static int devlink_nl_cmd_health_reporter_recover_doit(struct sk_buff *skb,
-						       struct genl_info *info)
-{
-	struct devlink *devlink = info->user_ptr[0];
-	struct devlink_health_reporter *reporter;
-
-	reporter = devlink_health_reporter_get_from_info(devlink, info);
-	if (!reporter)
-		return -EINVAL;
-
-	return devlink_health_reporter_recover(reporter, NULL, info->extack);
-}
-
 static int devlink_nl_cmd_health_reporter_diagnose_doit(struct sk_buff *skb,
 							struct genl_info *info)
 {
-- 
2.27.0

