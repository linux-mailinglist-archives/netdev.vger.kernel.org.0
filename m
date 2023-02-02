Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0013688062
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 15:48:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbjBBOsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 09:48:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232532AbjBBOsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 09:48:03 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2082.outbound.protection.outlook.com [40.107.93.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F7DD8F252;
        Thu,  2 Feb 2023 06:47:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jWf/IEqp41tje8jXapf07kTBZcFWGTdCccdye+PBqHyxjM+lKT1BjWjLHhCV1XF+RnEDyuZVO7KyznI8U+ZwQgWmjAU9VwCWnLQARu+0l6MtiAA4yp/34buFzNquFYKNdOPhWeKQVDrn7jtT5sHKdTYy9sIEcJOx4+buB9I9cip5OJuT5Pl4tSOXaxK/ENngBHAylR9rNmdAIjM0BuiIoytSnsd8ppf3Lu2E3O98fCcOHTjP7cFOkymRIfAWRQKoxWUS8Nxa08vzuulFmWQ25zv7/FibkJICtDzoz6rRFrSH00cRfXBlOhgQqhp8AqeYb/E7m/U5DlS1R60Ou5wKNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9kRnMMyWsJ0XTVuXF6Dclp9h8xByQv7Bak2Dvgxi1+s=;
 b=VEOBR+R6NSPnRH33SwsP5bNp4CmfKmFbplHla6cWpoU38SjWwr2NvdiON4e0qlok9mYi1QV/TOsuSceWM4QBCWXH/x/EI71258NUffYg3cBZYO+IeEWZ2WX1f+Nd1sIxaTXFNZvfTiqPx7AQdUJq6g70UUVDJ6VkQvc9qe6W2OaxIfiBhnFQzWD9uYY0spa9MK1B/WozW28vQZVj8vZpkpc/4Q+2Scr+Le7NTV+qavgore9zQelwUDOPNQYtChsR8nnz/+TXer75clRecsNll8fitJPURkn9YPE7RaGC1fmnzzIqPFAhiaMLmDdSQnjDQVoFg8vas8bV1V8jb7rWHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9kRnMMyWsJ0XTVuXF6Dclp9h8xByQv7Bak2Dvgxi1+s=;
 b=mGpPXohnhtbFcXKzwt8xHpNDl+h3fgtzAKPHeJZxh5Y9VO7yB4gLN8K1wp6LSsEIdyrCILddpJrSKHN+xezvpTlphZDBM6xtCXoGDVp1pFpnLBMcJxTzZSQXHFtyQWd4VCrmXxtCUKdr3ey0Arf+/c4ghZhWRA3IoNBKOTrB/Ly8J16cGfvLFaRAm1X/zsG8rQCepONfCtqKWJpDlwaowJiukzd5qz3Kwjs9JdWU9oGIRh6J6XegfK8DJA+SHA0bRx1nDoZgUiLrzOAyo0Zve58NpBizj9yHgdaYKMC6Fqt1QloqAiUA1JviByHRL2TsnG4DI/pCG63XsVErDljrCg==
Received: from DM6PR13CA0008.namprd13.prod.outlook.com (2603:10b6:5:bc::21) by
 DM6PR12MB4092.namprd12.prod.outlook.com (2603:10b6:5:214::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.24; Thu, 2 Feb 2023 14:47:51 +0000
Received: from DS1PEPF0000E65A.namprd02.prod.outlook.com
 (2603:10b6:5:bc:cafe::9a) by DM6PR13CA0008.outlook.office365.com
 (2603:10b6:5:bc::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.8 via Frontend
 Transport; Thu, 2 Feb 2023 14:47:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF0000E65A.mail.protection.outlook.com (10.167.18.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.21 via Frontend Transport; Thu, 2 Feb 2023 14:47:50 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 2 Feb 2023
 06:47:42 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 2 Feb 2023
 06:47:41 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Thu, 2 Feb
 2023 06:47:39 -0800
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        <netdev@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next 1/7] devlink: Split out dev get and dump code
Date:   Thu, 2 Feb 2023 16:47:00 +0200
Message-ID: <1675349226-284034-2-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1675349226-284034-1-git-send-email-moshe@nvidia.com>
References: <1675349226-284034-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E65A:EE_|DM6PR12MB4092:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ca5eb9b-538d-412d-9142-08db052c7565
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gKAEgRcb6HwnWOe8ROxxXHWjterBX2Yw3IlMlVPvQ5WEWQy5uyUF7htPAYbK6AZrWOr+foj2X5lmaOOkODikX5ekByWH1jidauB6rYiLtipRqXiEGBwKOTe3Gk2LV8LIfeAqgwhHa/oFbeeVBmJySXvkP5/ZEGYajI5A1aYe1myccQFSRevR0CzBSgW4OtEAyxCdLVCS9yflBgMAMekAi+DGikCwUZU4cAetOZs9iioxuhmiCKkco9STr2zXhJ0fRcxkANyzB+4z16N8uNBWIrX6HP2vfEONDz3SZyYIcfmVWo0nrMhUwjJ04oJ25vb9F3ImnjPENAXC7e+dVNf+nD46E8MCr1R5H7t+RZcMVR2xyHXSJGmrelMLwQumN9P5IlLAiBoiuHBBtVMLQaQJJNyUlgY/GcZZmGHEFAdR30/PtasT0ROZbXmT7hTGyTx2VBBZ5Lf+5tR0bu/zkS3ORAGIn9+lam9E0ewvd3bPm1JohXuVEmS1aduQV/WH3aDZnAeuD0Nnwb5Y411SfHVAB/iJjBqOcOuEvFe7Fnk3apnrwsFFz/Wrf8mPKnoj/+xAXVXyNkeHRhN9V9dSJ73VQNcEneDv3xV1R6yu5zFVwfRGU11qJtwTP4CaVQJtJyUOkLiPQu594SDHlHQuGgoI67tuZTBkp3R+dnkmIOVtTmHDpgHuzPnkzXQlrrgzwOEFizjdQl4A38hhEvEu30E8dEBN0FlNki+P4oFbLMrN1Yc1tiHJ4MaStYqVyhHminDn
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(346002)(39860400002)(396003)(451199018)(40470700004)(36840700001)(46966006)(40460700003)(478600001)(41300700001)(86362001)(83380400001)(6666004)(107886003)(7696005)(40480700001)(336012)(2616005)(47076005)(82310400005)(8676002)(186003)(26005)(70206006)(70586007)(426003)(4326008)(110136005)(54906003)(36860700001)(36756003)(316002)(2906002)(7636003)(82740400003)(356005)(8936002)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 14:47:50.7785
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ca5eb9b-538d-412d-9142-08db052c7565
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E65A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4092
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move devlink dev get and dump callbacks and related dev code to new file
dev.c. This file shall include all callbacks that are specific on
devlink dev object.

No functional change in this patch.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
---
 net/devlink/Makefile        |   2 +-
 net/devlink/dev.c           |  99 ++++++++++++++++++++++++++++++++++
 net/devlink/devl_internal.h |  17 ++++++
 net/devlink/leftover.c      | 102 +-----------------------------------
 4 files changed, 118 insertions(+), 102 deletions(-)
 create mode 100644 net/devlink/dev.c

diff --git a/net/devlink/Makefile b/net/devlink/Makefile
index 1b1eeac59cb3..daad4521c61e 100644
--- a/net/devlink/Makefile
+++ b/net/devlink/Makefile
@@ -1,3 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0
 
-obj-y := leftover.o core.o netlink.o
+obj-y := leftover.o core.o netlink.o dev.o
diff --git a/net/devlink/dev.c b/net/devlink/dev.c
new file mode 100644
index 000000000000..6a26dc7edef6
--- /dev/null
+++ b/net/devlink/dev.c
@@ -0,0 +1,99 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2016 Mellanox Technologies. All rights reserved.
+ * Copyright (c) 2016 Jiri Pirko <jiri@mellanox.com>
+ */
+
+#include <net/genetlink.h>
+#include "devl_internal.h"
+
+static int devlink_nl_fill(struct sk_buff *msg, struct devlink *devlink,
+			   enum devlink_command cmd, u32 portid,
+			   u32 seq, int flags)
+{
+	struct nlattr *dev_stats;
+	void *hdr;
+
+	hdr = genlmsg_put(msg, portid, seq, &devlink_nl_family, flags, cmd);
+	if (!hdr)
+		return -EMSGSIZE;
+
+	if (devlink_nl_put_handle(msg, devlink))
+		goto nla_put_failure;
+	if (nla_put_u8(msg, DEVLINK_ATTR_RELOAD_FAILED, devlink->reload_failed))
+		goto nla_put_failure;
+
+	dev_stats = nla_nest_start(msg, DEVLINK_ATTR_DEV_STATS);
+	if (!dev_stats)
+		goto nla_put_failure;
+
+	if (devlink_reload_stats_put(msg, devlink, false))
+		goto dev_stats_nest_cancel;
+	if (devlink_reload_stats_put(msg, devlink, true))
+		goto dev_stats_nest_cancel;
+
+	nla_nest_end(msg, dev_stats);
+	genlmsg_end(msg, hdr);
+	return 0;
+
+dev_stats_nest_cancel:
+	nla_nest_cancel(msg, dev_stats);
+nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	return -EMSGSIZE;
+}
+
+void devlink_notify(struct devlink *devlink, enum devlink_command cmd)
+{
+	struct sk_buff *msg;
+	int err;
+
+	WARN_ON(cmd != DEVLINK_CMD_NEW && cmd != DEVLINK_CMD_DEL);
+	WARN_ON(!xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED));
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return;
+
+	err = devlink_nl_fill(msg, devlink, cmd, 0, 0, 0);
+	if (err) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	genlmsg_multicast_netns(&devlink_nl_family, devlink_net(devlink),
+				msg, 0, DEVLINK_MCGRP_CONFIG, GFP_KERNEL);
+}
+
+int devlink_nl_cmd_get_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	struct devlink *devlink = info->user_ptr[0];
+	struct sk_buff *msg;
+	int err;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	err = devlink_nl_fill(msg, devlink, DEVLINK_CMD_NEW,
+			      info->snd_portid, info->snd_seq, 0);
+	if (err) {
+		nlmsg_free(msg);
+		return err;
+	}
+
+	return genlmsg_reply(msg, info);
+}
+
+static int
+devlink_nl_cmd_get_dump_one(struct sk_buff *msg, struct devlink *devlink,
+			    struct netlink_callback *cb)
+{
+	return devlink_nl_fill(msg, devlink, DEVLINK_CMD_NEW,
+			       NETLINK_CB(cb->skb).portid,
+			       cb->nlh->nlmsg_seq, NLM_F_MULTI);
+}
+
+const struct devlink_cmd devl_cmd_get = {
+	.dump_one		= devlink_nl_cmd_get_dump_one,
+};
diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index bdd7ad25c7e8..60dce85885b8 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -139,6 +139,16 @@ devlink_dump_state(struct netlink_callback *cb)
 	return (struct devlink_nl_dump_state *)cb->ctx;
 }
 
+static inline int
+devlink_nl_put_handle(struct sk_buff *msg, struct devlink *devlink)
+{
+	if (nla_put_string(msg, DEVLINK_ATTR_BUS_NAME, devlink->dev->bus->name))
+		return -EMSGSIZE;
+	if (nla_put_string(msg, DEVLINK_ATTR_DEV_NAME, dev_name(devlink->dev)))
+		return -EMSGSIZE;
+	return 0;
+}
+
 /* Commands */
 extern const struct devlink_cmd devl_cmd_get;
 extern const struct devlink_cmd devl_cmd_port_get;
@@ -157,6 +167,9 @@ extern const struct devlink_cmd devl_cmd_rate_get;
 extern const struct devlink_cmd devl_cmd_linecard_get;
 extern const struct devlink_cmd devl_cmd_selftests_get;
 
+/* Notify */
+void devlink_notify(struct devlink *devlink, enum devlink_command cmd);
+
 /* Ports */
 int devlink_port_netdevice_event(struct notifier_block *nb,
 				 unsigned long event, void *ptr);
@@ -166,6 +179,8 @@ devlink_port_get_from_info(struct devlink *devlink, struct genl_info *info);
 
 /* Reload */
 bool devlink_reload_actions_valid(const struct devlink_ops *ops);
+int devlink_reload_stats_put(struct sk_buff *msg, struct devlink *devlink,
+			     bool is_remote);
 int devlink_reload(struct devlink *devlink, struct net *dest_net,
 		   enum devlink_reload_action action,
 		   enum devlink_reload_limit limit,
@@ -188,3 +203,5 @@ devlink_rate_get_from_info(struct devlink *devlink, struct genl_info *info);
 struct devlink_rate *
 devlink_rate_node_get_from_info(struct devlink *devlink,
 				struct genl_info *info);
+/* Devlink nl cmds */
+int devlink_nl_cmd_get_doit(struct sk_buff *skb, struct genl_info *info);
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 056d9ca14a3d..54c8ea87e76b 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -596,15 +596,6 @@ devlink_region_snapshot_get_by_id(struct devlink_region *region, u32 id)
 	return NULL;
 }
 
-static int devlink_nl_put_handle(struct sk_buff *msg, struct devlink *devlink)
-{
-	if (nla_put_string(msg, DEVLINK_ATTR_BUS_NAME, devlink->dev->bus->name))
-		return -EMSGSIZE;
-	if (nla_put_string(msg, DEVLINK_ATTR_DEV_NAME, dev_name(devlink->dev)))
-		return -EMSGSIZE;
-	return 0;
-}
-
 static int devlink_nl_put_nested_handle(struct sk_buff *msg, struct devlink *devlink)
 {
 	struct nlattr *nested_attr;
@@ -699,7 +690,7 @@ static int devlink_reload_stat_put(struct sk_buff *msg,
 	return -EMSGSIZE;
 }
 
-static int devlink_reload_stats_put(struct sk_buff *msg, struct devlink *devlink, bool is_remote)
+int devlink_reload_stats_put(struct sk_buff *msg, struct devlink *devlink, bool is_remote)
 {
 	struct nlattr *reload_stats_attr, *act_info, *act_stats;
 	int i, j, stat_idx;
@@ -762,64 +753,6 @@ static int devlink_reload_stats_put(struct sk_buff *msg, struct devlink *devlink
 	return -EMSGSIZE;
 }
 
-static int devlink_nl_fill(struct sk_buff *msg, struct devlink *devlink,
-			   enum devlink_command cmd, u32 portid,
-			   u32 seq, int flags)
-{
-	struct nlattr *dev_stats;
-	void *hdr;
-
-	hdr = genlmsg_put(msg, portid, seq, &devlink_nl_family, flags, cmd);
-	if (!hdr)
-		return -EMSGSIZE;
-
-	if (devlink_nl_put_handle(msg, devlink))
-		goto nla_put_failure;
-	if (nla_put_u8(msg, DEVLINK_ATTR_RELOAD_FAILED, devlink->reload_failed))
-		goto nla_put_failure;
-
-	dev_stats = nla_nest_start(msg, DEVLINK_ATTR_DEV_STATS);
-	if (!dev_stats)
-		goto nla_put_failure;
-
-	if (devlink_reload_stats_put(msg, devlink, false))
-		goto dev_stats_nest_cancel;
-	if (devlink_reload_stats_put(msg, devlink, true))
-		goto dev_stats_nest_cancel;
-
-	nla_nest_end(msg, dev_stats);
-	genlmsg_end(msg, hdr);
-	return 0;
-
-dev_stats_nest_cancel:
-	nla_nest_cancel(msg, dev_stats);
-nla_put_failure:
-	genlmsg_cancel(msg, hdr);
-	return -EMSGSIZE;
-}
-
-static void devlink_notify(struct devlink *devlink, enum devlink_command cmd)
-{
-	struct sk_buff *msg;
-	int err;
-
-	WARN_ON(cmd != DEVLINK_CMD_NEW && cmd != DEVLINK_CMD_DEL);
-	WARN_ON(!xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED));
-
-	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
-	if (!msg)
-		return;
-
-	err = devlink_nl_fill(msg, devlink, cmd, 0, 0, 0);
-	if (err) {
-		nlmsg_free(msg);
-		return;
-	}
-
-	genlmsg_multicast_netns(&devlink_nl_family, devlink_net(devlink),
-				msg, 0, DEVLINK_MCGRP_CONFIG, GFP_KERNEL);
-}
-
 static int devlink_nl_port_attrs_put(struct sk_buff *msg,
 				     struct devlink_port *devlink_port)
 {
@@ -1274,39 +1207,6 @@ devlink_rate_is_parent_node(struct devlink_rate *devlink_rate,
 	return false;
 }
 
-static int devlink_nl_cmd_get_doit(struct sk_buff *skb, struct genl_info *info)
-{
-	struct devlink *devlink = info->user_ptr[0];
-	struct sk_buff *msg;
-	int err;
-
-	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
-	if (!msg)
-		return -ENOMEM;
-
-	err = devlink_nl_fill(msg, devlink, DEVLINK_CMD_NEW,
-			      info->snd_portid, info->snd_seq, 0);
-	if (err) {
-		nlmsg_free(msg);
-		return err;
-	}
-
-	return genlmsg_reply(msg, info);
-}
-
-static int
-devlink_nl_cmd_get_dump_one(struct sk_buff *msg, struct devlink *devlink,
-			    struct netlink_callback *cb)
-{
-	return devlink_nl_fill(msg, devlink, DEVLINK_CMD_NEW,
-			       NETLINK_CB(cb->skb).portid,
-			       cb->nlh->nlmsg_seq, NLM_F_MULTI);
-}
-
-const struct devlink_cmd devl_cmd_get = {
-	.dump_one		= devlink_nl_cmd_get_dump_one,
-};
-
 static int devlink_nl_cmd_port_get_doit(struct sk_buff *skb,
 					struct genl_info *info)
 {
-- 
2.27.0

