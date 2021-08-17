Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21EC83EED48
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 15:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239953AbhHQNXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 09:23:51 -0400
Received: from mail-bn8nam11on2065.outbound.protection.outlook.com ([40.107.236.65]:48321
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239916AbhHQNXn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 09:23:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CItJ3auuied4zB0CJfnTb1cZlYYroinKkgU1pTdU8yAtst76lpR95EHwpZAk33uVIxSQl5/VU00F+85f0EQbCcFDbZPWzVoYKd93HmtgCSm/TUKMWYQNe9b2+r+XM54rwMJT+oTG7vjqNC6w0Z4O4IiET24Ojz2TFOZUhKGGkpIDrJI6usPT0IcOct+5lAKrIEY2JLB742fgb5UNz9tgmzokSWdpH0DJCttW1zhMI8DeBME3VQTrLDrmblrEMLCK1E6TEwIAX7re5lX7La1wGmAk9d4ZCDIdOWR6KOaXfDsY0ifuHmq0ukAyK5x/rVCypgpVUuNknombLAlvYOBjbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h0uS11R6ZRxpR+5lvCtHil0JrfR3Ual+CoIhvd2bNPo=;
 b=jxrVWfSuVF6Z6qH/WXgiMf+pyKQ1CLJB6pJ4vkXfZLTyAt2eOboatG7unqw7n4UBWZcP9Yl6tF1MBODr+Sztw8mVY5DCK9Ffo4lndHOvvllcH57bu8ZHYYHv5dWqt0H511olQlF0xOVLJgb3Ym/V2F5h4PZeDiZcnR1y/pDW7w0aJ/WiOPP/nvt2H3NHuEIv43oWpLOTUnALW5tXucgdnkV1msvUDu3AmtBomWdQAjereY0TUux7DH+MSB86LkP5P5EIGA+vKXha5AOwFru0GaNAnjROfqn4fng08U92P8doBFnQV9fOIdx2l0UOlc8bJddvQu08Nr8/KPvMrhYIWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h0uS11R6ZRxpR+5lvCtHil0JrfR3Ual+CoIhvd2bNPo=;
 b=tha9+lUCn86Ya/No4nQrB6ne8sgaWQc2Xbis3jet183L8JvATCsT0ZoX2Z3eCCFdgRUB+mOZznIbIzkmxVTGquSt5v+fcqeP2TKDjxcK1RMTAjf3LjX1qpsm4UCPY11NX2hOLb38zegEjcf7iwmFllFNVIkEZqg0nMdbUjo3KfHL6SgCH5HVzIHOsFCsig2eMFVNrjNNT5Xt54ZXAuecpliEUJUtGlY8m7HmX4QwfzuTr+VxPOm+oSHokqhn32CxSoM8ldKO+9nRlfXvWkErBwNUmx3M9AKQ8aWjBkFRindIl+BT3NAzqrnRrAIcMLz8VtJ3wNQGs0Nnjl2IeBNmmg==
Received: from DM5PR2201CA0021.namprd22.prod.outlook.com (2603:10b6:4:14::31)
 by MWHPR12MB1168.namprd12.prod.outlook.com (2603:10b6:300:e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.22; Tue, 17 Aug
 2021 13:23:08 +0000
Received: from DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:14:cafe::5) by DM5PR2201CA0021.outlook.office365.com
 (2603:10b6:4:14::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16 via Frontend
 Transport; Tue, 17 Aug 2021 13:23:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT050.mail.protection.outlook.com (10.13.173.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4415.14 via Frontend Transport; Tue, 17 Aug 2021 13:23:08 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 17 Aug
 2021 13:23:08 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 17 Aug 2021 13:23:06 +0000
From:   Eli Cohen <elic@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <elic@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next 2/2] net: Fix offloading indirect devices dependency on qdisc order creation
Date:   Tue, 17 Aug 2021 16:22:17 +0300
Message-ID: <20210817132217.100710-3-elic@nvidia.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210817132217.100710-1-elic@nvidia.com>
References: <20210817132217.100710-1-elic@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bf59157c-73a4-4d86-d709-08d96182275e
X-MS-TrafficTypeDiagnostic: MWHPR12MB1168:
X-Microsoft-Antispam-PRVS: <MWHPR12MB1168D056EA7275417DCD0FCEABFE9@MWHPR12MB1168.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V9bPoTz5DsmFQYO7xqrbnoQVpXoLrKuIw2neE02O/J75zx6dG1Ia0glOOaEyBLtpPHu1IbDu1gazB2OWFuP0xSVHgI9OBr9IaSfo6pNIpKo+nT35Ocs8N3t+7S3IlThCDt3Zhrrjv1djh38ZjebXfrw82OVpB3gnDRJy0MAYvnN5i7eWEyOrgUCXizABMfIOaHPSlzAnkVH85rGcCXa04wanhMZwFZ7DLEGwzn+pO9aptNe1kJu49Jj/v4XoDj3DZJkO/PFuOCf/tLfamWglbws8GdO+olDaTd75mkEzpqrEBHUCArX1OJaSeAJY5mlTyvAt1v/tmnj2DojtYEcqDnLVeO1gYhnlVC7R6R/NEI65bjqPA5M4Bx+2QIW/WcM8tu1qDThYhpNpJUfP4gyAv96azkU/ehKyY+E6Lqj01nTXkFdE/U/ZnOPCIXZGHXX04IZUNOJsn+FUJqoS9z1DG8AJrHvzyorFycz58QIb5SbrsRgVB9I6ZfWiJa0vFvYj2MUC+w+gv7+fHUTqBlh4w7axV+LyE/PhbQjY6mhDTPUpGWH9X3JE6nFdHAlkJ4e+HyBi3XNPCKbOMk64xuvF7X6Wfmk1GABz+DFm955Iqn8J0gNL0qGtc2CtDa0vmT3CGpvcDNKwoTDMN7+bA3t/IfzFbY6XfhJUGB6lDvxIgQcHZHeKa4gAxne64u5VfJZtMra2g8JbTHs/INlEoe92xw==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(346002)(39860400002)(46966006)(36840700001)(6666004)(426003)(82310400003)(54906003)(8676002)(107886003)(36756003)(2906002)(2616005)(186003)(8936002)(7696005)(7636003)(82740400003)(110136005)(70206006)(26005)(36860700001)(478600001)(83380400001)(86362001)(356005)(70586007)(1076003)(47076005)(336012)(4326008)(5660300002)(316002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2021 13:23:08.2426
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bf59157c-73a4-4d86-d709-08d96182275e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1168
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, when creating an ingress qdisc on an indirect device before
the driver registered for callbacks, the driver will not have a chance
to register its filter configuration callbacks.

To fix that, modify the code such that it keeps track of all the ingress
qdiscs that call flow_indr_dev_setup_offload(). When a driver calls
flow_indr_dev_register(),  go through the list of tracked ingress qdiscs
and call the driver callback entry point so as to give it a chance to
register its callback.

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Eli Cohen <elic@nvidia.com>
---
 include/net/flow_offload.h            |  1 +
 net/core/flow_offload.c               | 91 ++++++++++++++++++++++++++-
 net/netfilter/nf_flow_table_offload.c |  1 +
 net/netfilter/nf_tables_offload.c     |  1 +
 net/sched/cls_api.c                   |  1 +
 5 files changed, 94 insertions(+), 1 deletion(-)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index f3c2841566a0..5aa27acdb0b3 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -453,6 +453,7 @@ struct flow_block_offload {
 	struct list_head *driver_block_list;
 	struct netlink_ext_ack *extack;
 	struct Qdisc *sch;
+	struct list_head *cb_list_head;
 };
 
 enum tc_setup_type;
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index 1da83997e86a..81a504d88e63 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -321,6 +321,7 @@ EXPORT_SYMBOL(flow_block_cb_setup_simple);
 static DEFINE_MUTEX(flow_indr_block_lock);
 static LIST_HEAD(flow_block_indr_list);
 static LIST_HEAD(flow_block_indr_dev_list);
+static LIST_HEAD(flow_indir_dev_list);
 
 struct flow_indr_dev {
 	struct list_head		list;
@@ -345,6 +346,35 @@ static struct flow_indr_dev *flow_indr_dev_alloc(flow_indr_block_bind_cb_t *cb,
 	return indr_dev;
 }
 
+struct flow_indir_dev_info {
+	void *data;
+	struct net_device *dev;
+	struct Qdisc *sch;
+	enum tc_setup_type type;
+	void (*cleanup)(struct flow_block_cb *block_cb);
+	struct list_head list;
+	enum flow_block_command command;
+	enum flow_block_binder_type binder_type;
+	struct list_head *cb_list;
+};
+
+static void existing_qdiscs_register(flow_indr_block_bind_cb_t *cb, void *cb_priv)
+{
+	struct flow_block_offload bo;
+	struct flow_indir_dev_info *cur;
+	struct tcf_block *block;
+
+	list_for_each_entry(cur, &flow_indir_dev_list, list) {
+		memset(&bo, 0, sizeof(bo));
+		bo.command = cur->command;
+		bo.binder_type = cur->binder_type;
+		block = cur->data;
+		INIT_LIST_HEAD(&bo.cb_list);
+		cb(cur->dev, cur->sch, cb_priv, cur->type, &bo, cur->data, cur->cleanup);
+		list_splice(&bo.cb_list, cur->cb_list);
+	}
+}
+
 int flow_indr_dev_register(flow_indr_block_bind_cb_t *cb, void *cb_priv)
 {
 	struct flow_indr_dev *indr_dev;
@@ -366,6 +396,7 @@ int flow_indr_dev_register(flow_indr_block_bind_cb_t *cb, void *cb_priv)
 	}
 
 	list_add(&indr_dev->list, &flow_block_indr_dev_list);
+	existing_qdiscs_register(cb, cb_priv);
 	mutex_unlock(&flow_indr_block_lock);
 
 	return 0;
@@ -462,7 +493,59 @@ struct flow_block_cb *flow_indr_block_cb_alloc(flow_setup_cb_t *cb,
 }
 EXPORT_SYMBOL(flow_indr_block_cb_alloc);
 
-int flow_indr_dev_setup_offload(struct net_device *dev, struct Qdisc *sch,
+static struct flow_indir_dev_info *find_indir_dev(void *data)
+{
+	struct flow_indir_dev_info *cur;
+
+	list_for_each_entry(cur, &flow_indir_dev_list, list) {
+		if (cur->data == data)
+			return cur;
+	}
+	return NULL;
+}
+
+static int indir_dev_add(void *data, struct net_device *dev, struct Qdisc *sch,
+			 enum tc_setup_type type, void (*cleanup)(struct flow_block_cb *block_cb),
+			 struct flow_block_offload *bo)
+{
+	struct flow_indir_dev_info *info;
+
+	info = find_indir_dev(data);
+	if (info)
+		return -EEXIST;
+
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+
+	info->data = data;
+	info->dev = dev;
+	info->sch = sch;
+	info->type = type;
+	info->cleanup = cleanup;
+	info->command = bo->command;
+	info->binder_type = bo->binder_type;
+	info->cb_list = bo->cb_list_head;
+
+	list_add(&info->list, &flow_indir_dev_list);
+	return 0;
+}
+
+static int indir_dev_remove(void *data)
+{
+	struct flow_indir_dev_info *info;
+
+	info = find_indir_dev(data);
+	if (!info)
+		return -ENOENT;
+
+	list_del(&info->list);
+
+	kfree(info);
+	return 0;
+}
+
+int flow_indr_dev_setup_offload(struct net_device *dev,	struct Qdisc *sch,
 				enum tc_setup_type type, void *data,
 				struct flow_block_offload *bo,
 				void (*cleanup)(struct flow_block_cb *block_cb))
@@ -470,6 +553,12 @@ int flow_indr_dev_setup_offload(struct net_device *dev, struct Qdisc *sch,
 	struct flow_indr_dev *this;
 
 	mutex_lock(&flow_indr_block_lock);
+
+	if (bo->command == FLOW_BLOCK_BIND)
+		indir_dev_add(data, dev, sch, type, cleanup, bo);
+	else if (bo->command == FLOW_BLOCK_UNBIND)
+		indir_dev_remove(data);
+
 	list_for_each_entry(this, &flow_block_indr_dev_list, list)
 		this->cb(dev, sch, this->cb_priv, type, bo, data, cleanup);
 
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index f92006cec94c..cbd9f59098b7 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -1097,6 +1097,7 @@ static void nf_flow_table_block_offload_init(struct flow_block_offload *bo,
 	bo->command	= cmd;
 	bo->binder_type	= FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS;
 	bo->extack	= extack;
+	bo->cb_list_head = &flowtable->flow_block.cb_list;
 	INIT_LIST_HEAD(&bo->cb_list);
 }
 
diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index b58d73a96523..9656c1646222 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -353,6 +353,7 @@ static void nft_flow_block_offload_init(struct flow_block_offload *bo,
 	bo->command	= cmd;
 	bo->binder_type	= FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS;
 	bo->extack	= extack;
+	bo->cb_list_head = &basechain->flow_block.cb_list;
 	INIT_LIST_HEAD(&bo->cb_list);
 }
 
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index e3e79e9bd706..9b276d14be4c 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -634,6 +634,7 @@ static void tcf_block_offload_init(struct flow_block_offload *bo,
 	bo->block_shared = shared;
 	bo->extack = extack;
 	bo->sch = sch;
+	bo->cb_list_head = &flow_block->cb_list;
 	INIT_LIST_HEAD(&bo->cb_list);
 }
 
-- 
2.32.0

