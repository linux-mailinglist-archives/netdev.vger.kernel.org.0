Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3721B4F79F9
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 10:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241371AbiDGInO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 04:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236861AbiDGInI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 04:43:08 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2054.outbound.protection.outlook.com [40.107.94.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55DB755BD2
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 01:41:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IpQ/5q6LUk8XXHGO3tzunsF9Q7eMKR9sDeMmisT2lf3si8yRk5CZ2WVbI/BuRV9XP6C6YvaOq1K7CchURoNeXUFslEuhhPjAj1IMyCBymS9datyWJmBh49KbvzJq7ij7jiCB4igExKHp6R+8MMj4pb+9pj3tvxcTfojTMEMBhasdQmysm5VPJBI4FGcaDrLM68ciW6vnhqxb3wibF0g2W/SXQM5XQZraoVZKHDLfMeKD4wVBHs6LTgBDpQjWQKBE7+aXcCVUmnyjvgB8ZkIKbKPFPn7JWJQveFBQC6b72g/PES+/5bbg0oqlU3UMwbTrWpd3ziWkjQMnKaE65fRNNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nK0aucon0bmI0nP1eXSl7SdMra5rbQGf/H06m4yK868=;
 b=XuqVnVsjmZ5BCOahPguCkwJl5g4S1wug3SaZEIdGbZJZa9CQnSwYKn+XMU22UsOwyUcoFJsRyuvZIRxU5/zVLhXjWZFYcPq5l5B9fRhWaxBtLxtnrMJKSfY2CEAh0DLriJeoxnArzxOK44HsbHZdyityPHZ8j0Qx6BhuiHib8OCHQ6IpuyIJHczDnVnT7STBAmfVa5MvT+U9S3lBr3sijbPhNj0dWQONeia72UZ6oM06ERgj9G2V7DlTvDzpu3E4szW1vLaY4zrFkH7SLv8C3J/IGZtCnZSLJO3N10CLen2YPJnbxejfy2mKwx6pcQdD2gmz2Gt374IXTvtILuAoTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nK0aucon0bmI0nP1eXSl7SdMra5rbQGf/H06m4yK868=;
 b=nXY/DA5jC7a+M3cDkrfKcGKz+SUqA1a5HI0LYSxb1FjdLV5Nsf2sZLD9oAjMnhNtXQrEzSPUl9c0GpctaUftnlNVFyvvXiJx501XZgTGYFa5d1/Ygi9JnZjfadWgHpK0jrBRrbT9UvBD97UJa/Jl8iOir21VAVsgiZkmd0Kmwv5Zq7oLahhI1YuimQrcStX0aZF6yXOyaxoc5gE7OUP5y8pBo4QXPWcm5G1vsnc/kB9fGb+o9zKCi9M8cdeGVUBUe+niWsceLdqbeW3TGY2CFNZLkNqXxDYj9z941FAQ/gzVI1O5q4hu9sit/ShSIWhXsqcpARFjAUu0pr3jM+RfZQ==
Received: from BN9PR03CA0759.namprd03.prod.outlook.com (2603:10b6:408:13a::14)
 by BN6PR12MB1378.namprd12.prod.outlook.com (2603:10b6:404:1e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.21; Thu, 7 Apr
 2022 08:41:04 +0000
Received: from BN8NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13a:cafe::12) by BN9PR03CA0759.outlook.office365.com
 (2603:10b6:408:13a::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22 via Frontend
 Transport; Thu, 7 Apr 2022 08:41:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT055.mail.protection.outlook.com (10.13.177.62) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5144.20 via Frontend Transport; Thu, 7 Apr 2022 08:41:03 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 7 Apr
 2022 08:41:03 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Thu, 7 Apr 2022
 01:41:02 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Thu, 7 Apr
 2022 01:41:00 -0700
From:   Michael Guralnik <michaelgur@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <jiri@nvidia.com>, <ariela@nvidia.com>, <maorg@nvidia.com>,
        <saeedm@nvidia.com>, <kuba@kernel.org>, <moshe@nvidia.com>,
        Michael Guralnik <michaelgur@nvidia.com>
Subject: [RFC PATCH net-next 1/2] devlink: Introduce stats to the port object
Date:   Thu, 7 Apr 2022 11:40:49 +0300
Message-ID: <20220407084050.184989-2-michaelgur@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220407084050.184989-1-michaelgur@nvidia.com>
References: <20220407084050.184989-1-michaelgur@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 29d3d400-f013-4345-6bdf-08da187259e7
X-MS-TrafficTypeDiagnostic: BN6PR12MB1378:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB1378E0E05CC0E760785151BEAFE69@BN6PR12MB1378.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DbeZorBh8/f1odvjjBVyU92qy0sFCwctatW4hvfOnnD+T64UUTRmwyup9SBlMeykVtyNtdP5/9at83TnROnj+ENHTiGaFMYsJgMuHnZdYjeVP7J37K/d7jmPRTjvlniF4OFAlbknySqcwLnIaWwtaoGD5KhYvgVsM9cJgWWxEJjnlB95mCGAPSYcgJ+akPXkBqkQHiQuORAwAhO7mB1ozGkxg9ZPlILHvkliOZwCZKGTGfa1fJaq9hj7poK4CdjhNG+mJWAYRsTCiUrToeWOYt9IjUEUTRb9YuconEyfK1Aw0On1m8Tst7nU5gQ5qUfNYpd7RAs7eJ4AdPctt/K8CfKSNx3OnFLu4phdNns7tq0J8iRAvhf4WBfdmpqPbMeGDlRDcgswUJENl9BYSRma/xAvsyh+/7W2skpMWDh5HP/43bR/FqKDtyj4FKeJHbqMfRVXx0UvjcnUM+pjCxs0XD4qwozNfcfYaWCXQO1I1kasj8HV9rBpzjoufxiy3n/76PMatNj8SO9MDZL3Ql+FYFad+aLdR1nloWDpulCUK8NRMfDCMo2AH7I/nFKJsoszHBBlNqSOMuLKFye0vToF/Oxz9I//EBuYyWMsKnbCMJkr/visGum+rkNcb1WUSgxoRh1xT6j1r3b2/HI+2xv/LLUCXt4E/aAUKy0Zy8iGCwatGm+xiBLJa3eIYzKSX6UAvq9SHxZPsA7fByDC0wK+sQ==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(8936002)(5660300002)(86362001)(356005)(426003)(1076003)(186003)(82310400005)(8676002)(36860700001)(4326008)(26005)(2616005)(107886003)(83380400001)(336012)(36756003)(47076005)(316002)(54906003)(70206006)(70586007)(6666004)(7696005)(6916009)(81166007)(40460700003)(508600001)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 08:41:03.8304
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 29d3d400-f013-4345-6bdf-08da187259e7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1378
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introducing a mechanism for drivers to register statistics counters to
devlink ports.
Drivers to supply only name and a get method for the counter.

Signed-off-by: Michael Guralnik <michaelgur@nvidia.com>
---
 include/net/devlink.h | 28 +++++++++++++++
 net/core/devlink.c    | 80 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 108 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 8d5349d2fb68..e9c3996ed359 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -115,6 +115,11 @@ struct devlink_rate {
 	};
 };
 
+struct devlink_port_stats {
+	struct list_head stats_list;
+	int (*get)(struct devlink_port *port);
+};
+
 struct devlink_port {
 	struct list_head list;
 	struct list_head param_list;
@@ -135,6 +140,7 @@ struct devlink_port {
 	struct mutex reporters_lock; /* Protects reporter_list */
 
 	struct devlink_rate *devlink_rate;
+	struct devlink_port_stats stats;
 };
 
 struct devlink_port_new_attrs {
@@ -387,6 +393,16 @@ struct devlink_param_gset_ctx {
 	enum devlink_param_cmode cmode;
 };
 
+struct devlink_port_stat {
+	char *name;
+	u64 val;
+};
+
+struct devlink_port_stat_item {
+	struct list_head list;
+	const struct devlink_port_stat *stat;
+};
+
 /**
  * struct devlink_flash_notify - devlink dev flash notify data
  * @status_msg: current status string
@@ -1712,6 +1728,18 @@ devlink_trap_policers_unregister(struct devlink *devlink,
 				 const struct devlink_trap_policer *policers,
 				 size_t policers_count);
 
+void devlink_port_stat_unregister(struct devlink_port *port,
+				  const struct devlink_port_stat *stat);
+
+int devlink_port_stats_register(struct devlink_port *port,
+				const struct devlink_port_stat *stats,
+				size_t stats_count,
+				int (*get)(struct devlink_port *port));
+
+void devlink_port_stats_unregister(struct devlink_port *port,
+				   const struct devlink_port_stat *stats,
+				   size_t stats_count);
+
 #if IS_ENABLED(CONFIG_NET_DEVLINK)
 
 struct devlink *__must_check devlink_try_get(struct devlink *devlink);
diff --git a/net/core/devlink.c b/net/core/devlink.c
index fcd9f6d85cf1..9636d7998630 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4740,6 +4740,85 @@ static void devlink_param_notify(struct devlink *devlink,
 				msg, 0, DEVLINK_MCGRP_CONFIG, GFP_KERNEL);
 }
 
+struct devlink_port_stat_item *
+devlink_port_stat_find_by_name(struct list_head *stats_list, const char *stat_name)
+{
+	struct devlink_port_stat_item *stat_item;
+
+	list_for_each_entry(stat_item, stats_list, list)
+		if (!strcmp(stat_item->stat->name, stat_name))
+			return stat_item;
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(devlink_port_stat_find_by_name);
+
+void devlink_port_stat_unregister(struct devlink_port *port,
+			          const struct devlink_port_stat *stat)
+{
+	struct devlink_port_stat_item *stat_item;
+
+	stat_item =
+		devlink_port_stat_find_by_name(&port->stats.stats_list, stat->name);
+	WARN_ON(!stat_item);
+	list_del(&stat_item->list);
+	kfree(stat_item);
+}
+
+static int devlink_port_stat_register(struct devlink_port *port,
+				      const struct devlink_port_stat *stats)
+{
+	struct devlink_port_stat_item *stat_item;
+
+	WARN_ON(devlink_port_stat_find_by_name(&port->stats.stats_list, stats->name));
+
+	stat_item = kzalloc(sizeof(*stat_item), GFP_KERNEL);
+	if (!stat_item)
+		return -ENOMEM;
+
+	stat_item->stat = stats;
+
+	list_add_tail(&stat_item->list, &port->stats.stats_list);
+	return 0;
+}
+
+void devlink_port_stats_unregister(struct devlink_port *port,
+				   const struct devlink_port_stat *stats,
+				   size_t stats_count)
+{
+	const struct devlink_port_stat *stat = stats;
+	int i;
+
+	for (i = 0; i < stats_count; i++, stat++)
+		devlink_port_stat_unregister(port, stat);
+}
+EXPORT_SYMBOL_GPL(devlink_port_stats_unregister);
+
+int devlink_port_stats_register(struct devlink_port *port,
+				const struct devlink_port_stat *stats,
+				size_t stats_count,
+				int (*get)(struct devlink_port *port))
+{
+	const struct devlink_port_stat *stat = stats;
+	int i, err;
+
+	port->stats.get = get;
+	for (i = 0; i < stats_count; i++, stat++) {
+		err = devlink_port_stat_register(port, stat);
+		if (err)
+			goto rollback;
+	}
+	return 0;
+
+rollback:
+	if (!i)
+		return err;
+
+	for (stat--; i > 0; i--, stat--)
+		devlink_port_stat_unregister(port, stat);
+	return err;
+}
+EXPORT_SYMBOL_GPL(devlink_port_stats_register);
+
 static int devlink_nl_cmd_param_get_dumpit(struct sk_buff *msg,
 					   struct netlink_callback *cb)
 {
@@ -9281,6 +9360,7 @@ int devlink_port_register(struct devlink *devlink,
 	list_add_tail(&devlink_port->list, &devlink->port_list);
 	INIT_LIST_HEAD(&devlink_port->param_list);
 	INIT_LIST_HEAD(&devlink_port->region_list);
+	INIT_LIST_HEAD(&devlink_port->stats.stats_list);
 	mutex_unlock(&devlink->lock);
 	INIT_DELAYED_WORK(&devlink_port->type_warn_dw, &devlink_port_type_warn);
 	devlink_port_type_warn_schedule(devlink_port);
-- 
2.17.2

