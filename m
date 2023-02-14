Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B78A6969DF
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 17:38:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232489AbjBNQiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 11:38:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232508AbjBNQig (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 11:38:36 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2061.outbound.protection.outlook.com [40.107.96.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95C7B26CED
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 08:38:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z9COz3X6IkB2byI2dCoAuj3VSEmTT5EHUQ4BmkvPD8cRt2/cfKHkDHCm62h6gBHSsdTfYp6x1YXHv0LrNtfad0AK2P/BUor8CeH3SCCooGrkC7gp7ZNYkGvFJhmWgSNdUXwa7jiHuJUZATg8SdUiMs868XkVe+C6JctTxcDMB5YFktPseq2aj8BuMhvsii3LPMSTAgCsJcPXX/QxORARhNi+Z45CI/+XM+88Why7xwLEuhVzqIwQmFfjZzp2IgJmXdiaGmaqup9G9PhOi48ahBoPu3blbaEkjEbQMM8qTPPf3tuT7syTNuwGOT1m3NMxT77Q7v8md+Mkc6LaPUvE9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W+SG6cAsDQNJPaZ19wPHeMDYXLDl2eNuC+uG2RMCIcM=;
 b=dM5F9SQ6ENnZqq6Ar+wYNna1r06nJiT+WlGOu4NTyYgtVSM7djLXF74U+R4vJhdXfRSZFEcRpkvd18JoucFa4NI54vSNlK67vTqCGkq1ch0inQLoo1tePxQljLFpMD2BaP67kjyFQaD/LY079VD/dacLHWeuuKewA2V5fzgT1OIkSPQ0t+kf5AV/q8UZMibf109Fm6n0Bhvmg+dLNw3NsDNb9SDurJ1Ah5c9Ss8y841Qi/DGNY46c/cFEUVG+jJ5nVcb0OPSiKD08QfSVQinnvp4DEmcL6JCtozasbPCrey3+k6q0TJoDRzRfGz/AeRM+FitopVwgIkKJVgl4/wMQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W+SG6cAsDQNJPaZ19wPHeMDYXLDl2eNuC+uG2RMCIcM=;
 b=r8K9lQ/J2nFBCY8ZVF5U8ALW6vAIAfwAyOnkkeu5B5N/ZyUCHOzBW/dywk4Yu2IclTcf/lxpUvlY0naMdxAw47XAapqBDqN1Hn9NzuMPwnL/aum9kbiVNWbyf1UYCduiE9qRbKC7VTvMNRqYnibFbZQWq6UhgRWDyqXPb8L7hmwB4iPQ/Bs8/xhMegZtN/BVLI+oCScoxZSpRfelm9Ck3ac4q06qfNgJ3/rE4af2O8PuylFb+VS9vhaIeNPk9apWzkkTlGDmTzuVYl3ObPevkLv/OnakrVdSjd9UP4JXQ4XwLbuKj0SK+944Ee7bmaLINRH1JO+F0jD5k1IdhE2YeQ==
Received: from BN8PR04CA0053.namprd04.prod.outlook.com (2603:10b6:408:d4::27)
 by SA1PR12MB7317.namprd12.prod.outlook.com (2603:10b6:806:2ba::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.23; Tue, 14 Feb
 2023 16:38:28 +0000
Received: from BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:d4:cafe::59) by BN8PR04CA0053.outlook.office365.com
 (2603:10b6:408:d4::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24 via Frontend
 Transport; Tue, 14 Feb 2023 16:38:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN8NAM11FT020.mail.protection.outlook.com (10.13.176.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.26 via Frontend Transport; Tue, 14 Feb 2023 16:38:28 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 14 Feb
 2023 08:38:22 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Tue, 14 Feb 2023 08:38:22 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Tue, 14 Feb 2023 08:38:21 -0800
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        <netdev@vger.kernel.org>
CC:     Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next v2 06/10] devlink: Move devlink health dump to health file
Date:   Tue, 14 Feb 2023 18:38:02 +0200
Message-ID: <1676392686-405892-7-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1676392686-405892-1-git-send-email-moshe@nvidia.com>
References: <1676392686-405892-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT020:EE_|SA1PR12MB7317:EE_
X-MS-Office365-Filtering-Correlation-Id: a5c093af-483a-48d5-d2cb-08db0ea9e6d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TwYFPTs1HIZ+LwUC2YsPyPyz5gqjDkg8mtjWOl8oGWuLyywjTRd5LhzKyc2j0bIEwhvoO18JvEgu1eRbTOzrRQkYDzVaVb6tZU/wJ6omoBJvjZnga4+N4nJWPcrr6bG3JyG7syX2b+I+4NLcOJ0I5EQvSvJFkVvVuQooHocGu0KKVyQT4b9aswBd0AvcOf9eiPXnuLXKBmyqr9QMi5kldSitkrDJqrEBOov4lcs8VBZjdEOlphRjvB98i6n6WdGq1CF0/UxbjV3zF8/OZ37fOdd5C+Yl8Bz+2Q9dUWxDd2eMvVwXVtaGC/IiobgLT3vnW29mc0DjsF3YzQYlkf90IKG/I8aAP+mxs0c+Vk2yVBFawRwd5wTJVRhXU7CkE7SxmR0Wrnl7AbVgg+QVt2viMjRpEqFJWRh8+u9ZeYQa22muaYxE8oNOAE0vV+ChJAoTXlmHsb5zckz96VB0DHK+XR3Q1e8Bi5LfsOuYycwnTcI5IDRL3prZO3FbVLSvMHur1PZDh6EyTQassjXC7Dcp+dbeFTE+SppNx792idP2uqG+xB73GIscXXRKC8sI4c5fGJMr+R6CmQ1z0o4cbB0hLAdJdo/UU3r/UyuilyTcyXXxhY8EoYstu1TvgnpT1/MWTK8ty/biYj1UI9BD4Pq3kt4c69W1ILeQPJKbIuRJms4CHy7G6J23TaovD3vhGPQvrVEhECs7VQQVXyTIhu1Ikw==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(396003)(136003)(39860400002)(451199018)(40470700004)(46966006)(36840700001)(40460700003)(110136005)(47076005)(83380400001)(426003)(316002)(70206006)(70586007)(8676002)(41300700001)(5660300002)(478600001)(8936002)(6666004)(107886003)(4326008)(186003)(26005)(2616005)(356005)(336012)(40480700001)(36756003)(82310400005)(86362001)(2906002)(36860700001)(7636003)(7696005)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 16:38:28.6479
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a5c093af-483a-48d5-d2cb-08db0ea9e6d9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7317
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move devlink health report dump callbacks and related code from
leftover.c to health.c. No functional change in this patch.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
---
 net/devlink/devl_internal.h |   4 ++
 net/devlink/health.c        | 122 +++++++++++++++++++++++++++++++++++
 net/devlink/leftover.c      | 123 ------------------------------------
 3 files changed, 126 insertions(+), 123 deletions(-)

diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index a4b96f8a0ab4..ae7229742d66 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -278,3 +278,7 @@ int devlink_nl_cmd_health_reporter_recover_doit(struct sk_buff *skb,
 						struct genl_info *info);
 int devlink_nl_cmd_health_reporter_diagnose_doit(struct sk_buff *skb,
 						 struct genl_info *info);
+int devlink_nl_cmd_health_reporter_dump_get_dumpit(struct sk_buff *skb,
+						   struct netlink_callback *cb);
+int devlink_nl_cmd_health_reporter_dump_clear_doit(struct sk_buff *skb,
+						   struct genl_info *info);
diff --git a/net/devlink/health.c b/net/devlink/health.c
index fbeedc8df043..6991b9405f4f 100644
--- a/net/devlink/health.c
+++ b/net/devlink/health.c
@@ -5,6 +5,7 @@
  */
 
 #include <net/genetlink.h>
+#include <net/sock.h>
 #include <trace/events/devlink.h>
 #include "devl_internal.h"
 
@@ -507,6 +508,56 @@ devlink_health_reporter_recover(struct devlink_health_reporter *reporter,
 	return 0;
 }
 
+static void
+devlink_health_dump_clear(struct devlink_health_reporter *reporter)
+{
+	if (!reporter->dump_fmsg)
+		return;
+	devlink_fmsg_free(reporter->dump_fmsg);
+	reporter->dump_fmsg = NULL;
+}
+
+int devlink_health_do_dump(struct devlink_health_reporter *reporter,
+			   void *priv_ctx,
+			   struct netlink_ext_ack *extack)
+{
+	int err;
+
+	if (!reporter->ops->dump)
+		return 0;
+
+	if (reporter->dump_fmsg)
+		return 0;
+
+	reporter->dump_fmsg = devlink_fmsg_alloc();
+	if (!reporter->dump_fmsg) {
+		err = -ENOMEM;
+		return err;
+	}
+
+	err = devlink_fmsg_obj_nest_start(reporter->dump_fmsg);
+	if (err)
+		goto dump_err;
+
+	err = reporter->ops->dump(reporter, reporter->dump_fmsg,
+				  priv_ctx, extack);
+	if (err)
+		goto dump_err;
+
+	err = devlink_fmsg_obj_nest_end(reporter->dump_fmsg);
+	if (err)
+		goto dump_err;
+
+	reporter->dump_ts = jiffies;
+	reporter->dump_real_ts = ktime_get_real_ns();
+
+	return 0;
+
+dump_err:
+	devlink_health_dump_clear(reporter);
+	return err;
+}
+
 int devlink_health_report(struct devlink_health_reporter *reporter,
 			  const char *msg, void *priv_ctx)
 {
@@ -1174,3 +1225,74 @@ int devlink_nl_cmd_health_reporter_diagnose_doit(struct sk_buff *skb,
 	devlink_fmsg_free(fmsg);
 	return err;
 }
+
+static struct devlink_health_reporter *
+devlink_health_reporter_get_from_cb(struct netlink_callback *cb)
+{
+	const struct genl_dumpit_info *info = genl_dumpit_info(cb);
+	struct devlink_health_reporter *reporter;
+	struct nlattr **attrs = info->attrs;
+	struct devlink *devlink;
+
+	devlink = devlink_get_from_attrs_lock(sock_net(cb->skb->sk), attrs);
+	if (IS_ERR(devlink))
+		return NULL;
+	devl_unlock(devlink);
+
+	reporter = devlink_health_reporter_get_from_attrs(devlink, attrs);
+	devlink_put(devlink);
+	return reporter;
+}
+
+int devlink_nl_cmd_health_reporter_dump_get_dumpit(struct sk_buff *skb,
+						   struct netlink_callback *cb)
+{
+	struct devlink_nl_dump_state *state = devlink_dump_state(cb);
+	struct devlink_health_reporter *reporter;
+	int err;
+
+	reporter = devlink_health_reporter_get_from_cb(cb);
+	if (!reporter)
+		return -EINVAL;
+
+	if (!reporter->ops->dump)
+		return -EOPNOTSUPP;
+
+	mutex_lock(&reporter->dump_lock);
+	if (!state->idx) {
+		err = devlink_health_do_dump(reporter, NULL, cb->extack);
+		if (err)
+			goto unlock;
+		state->dump_ts = reporter->dump_ts;
+	}
+	if (!reporter->dump_fmsg || state->dump_ts != reporter->dump_ts) {
+		NL_SET_ERR_MSG(cb->extack, "Dump trampled, please retry");
+		err = -EAGAIN;
+		goto unlock;
+	}
+
+	err = devlink_fmsg_dumpit(reporter->dump_fmsg, skb, cb,
+				  DEVLINK_CMD_HEALTH_REPORTER_DUMP_GET);
+unlock:
+	mutex_unlock(&reporter->dump_lock);
+	return err;
+}
+
+int devlink_nl_cmd_health_reporter_dump_clear_doit(struct sk_buff *skb,
+						   struct genl_info *info)
+{
+	struct devlink *devlink = info->user_ptr[0];
+	struct devlink_health_reporter *reporter;
+
+	reporter = devlink_health_reporter_get_from_info(devlink, info);
+	if (!reporter)
+		return -EINVAL;
+
+	if (!reporter->ops->dump)
+		return -EOPNOTSUPP;
+
+	mutex_lock(&reporter->dump_lock);
+	devlink_health_dump_clear(reporter);
+	mutex_unlock(&reporter->dump_lock);
+	return 0;
+}
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index e460bcf1d247..55be664d14ad 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -5372,129 +5372,6 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 	return err;
 }
 
-static void
-devlink_health_dump_clear(struct devlink_health_reporter *reporter)
-{
-	if (!reporter->dump_fmsg)
-		return;
-	devlink_fmsg_free(reporter->dump_fmsg);
-	reporter->dump_fmsg = NULL;
-}
-
-int devlink_health_do_dump(struct devlink_health_reporter *reporter,
-			   void *priv_ctx,
-			   struct netlink_ext_ack *extack)
-{
-	int err;
-
-	if (!reporter->ops->dump)
-		return 0;
-
-	if (reporter->dump_fmsg)
-		return 0;
-
-	reporter->dump_fmsg = devlink_fmsg_alloc();
-	if (!reporter->dump_fmsg) {
-		err = -ENOMEM;
-		return err;
-	}
-
-	err = devlink_fmsg_obj_nest_start(reporter->dump_fmsg);
-	if (err)
-		goto dump_err;
-
-	err = reporter->ops->dump(reporter, reporter->dump_fmsg,
-				  priv_ctx, extack);
-	if (err)
-		goto dump_err;
-
-	err = devlink_fmsg_obj_nest_end(reporter->dump_fmsg);
-	if (err)
-		goto dump_err;
-
-	reporter->dump_ts = jiffies;
-	reporter->dump_real_ts = ktime_get_real_ns();
-
-	return 0;
-
-dump_err:
-	devlink_health_dump_clear(reporter);
-	return err;
-}
-
-static struct devlink_health_reporter *
-devlink_health_reporter_get_from_cb(struct netlink_callback *cb)
-{
-	const struct genl_dumpit_info *info = genl_dumpit_info(cb);
-	struct devlink_health_reporter *reporter;
-	struct nlattr **attrs = info->attrs;
-	struct devlink *devlink;
-
-	devlink = devlink_get_from_attrs_lock(sock_net(cb->skb->sk), attrs);
-	if (IS_ERR(devlink))
-		return NULL;
-	devl_unlock(devlink);
-
-	reporter = devlink_health_reporter_get_from_attrs(devlink, attrs);
-	devlink_put(devlink);
-	return reporter;
-}
-
-static int
-devlink_nl_cmd_health_reporter_dump_get_dumpit(struct sk_buff *skb,
-					       struct netlink_callback *cb)
-{
-	struct devlink_nl_dump_state *state = devlink_dump_state(cb);
-	struct devlink_health_reporter *reporter;
-	int err;
-
-	reporter = devlink_health_reporter_get_from_cb(cb);
-	if (!reporter)
-		return -EINVAL;
-
-	if (!reporter->ops->dump)
-		return -EOPNOTSUPP;
-
-	mutex_lock(&reporter->dump_lock);
-	if (!state->idx) {
-		err = devlink_health_do_dump(reporter, NULL, cb->extack);
-		if (err)
-			goto unlock;
-		state->dump_ts = reporter->dump_ts;
-	}
-	if (!reporter->dump_fmsg || state->dump_ts != reporter->dump_ts) {
-		NL_SET_ERR_MSG(cb->extack, "Dump trampled, please retry");
-		err = -EAGAIN;
-		goto unlock;
-	}
-
-	err = devlink_fmsg_dumpit(reporter->dump_fmsg, skb, cb,
-				  DEVLINK_CMD_HEALTH_REPORTER_DUMP_GET);
-unlock:
-	mutex_unlock(&reporter->dump_lock);
-	return err;
-}
-
-static int
-devlink_nl_cmd_health_reporter_dump_clear_doit(struct sk_buff *skb,
-					       struct genl_info *info)
-{
-	struct devlink *devlink = info->user_ptr[0];
-	struct devlink_health_reporter *reporter;
-
-	reporter = devlink_health_reporter_get_from_info(devlink, info);
-	if (!reporter)
-		return -EINVAL;
-
-	if (!reporter->ops->dump)
-		return -EOPNOTSUPP;
-
-	mutex_lock(&reporter->dump_lock);
-	devlink_health_dump_clear(reporter);
-	mutex_unlock(&reporter->dump_lock);
-	return 0;
-}
-
 static int devlink_nl_cmd_health_reporter_test_doit(struct sk_buff *skb,
 						    struct genl_info *info)
 {
-- 
2.27.0

