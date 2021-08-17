Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 328363EF097
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 19:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231814AbhHQRGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 13:06:05 -0400
Received: from mail-mw2nam10on2048.outbound.protection.outlook.com ([40.107.94.48]:63233
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231750AbhHQRGD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 13:06:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SHh+eEu8GLB6Bn6EO5XPIV7mXoGiaJRQDtzYCJ5RHsZyIRuFnv4E3OIsi0NgI2qLZsgamtzrPV84L8M16Rww3diA9SIKujd9KuhBq97fJZ8EuAPsei/uoBo5jK8rTAEKYWjZYDQEJw37yWHqj1pDHErlFoD44dKS9kU1xD7/+Q1H6scYq9vCr6MVjEhQzjxu3LO5tvwSPoDo9oDHyDhDFB7dJ3IZXEphxr9oD/SR7TbXjG0leN5OW6cv2zFMgvo4AzehVptAsO34qPgEB62GqDI/z3/lEdnqu1tbuikwZfAQx6Tuzu2+juckNUte1t5/b81mETL7QrgktAVqboTSKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7hIlkiZWjz6ySPuq2orPZHVrKK/g7uwU/x1+T7C0jwY=;
 b=ijRPWSPtlQYS6TnzP4ZPPAUmnT4HhI6qNr3Gco/LqYDydnNvijJ6tzh+Ddyq2+3RwlYybnj4jBGtp8vQNLW67qC4WrMUnYPrCSrYbduNOOlFw4OGAfMHKepNkZ2Slqx79GtfqyLxnYH8tCkNBenbDKxII+phwQv/Mhnx1ne22YjKV9qsDaz8WjKP6CeIf0DXuv4CGIpJUbhuz4Ih/kOJrzAhYxR6MV2e2hFAwRtiZppRZo4nSC4Hb13LQDE4Lqm6FHLYlV7i04s02PE6HKgo+024ObW0xZdL31yED0BabZ87tlacgi9fBv1oUv9YAC5/Eg5ok8eNDyyUcmDGGE64aQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7hIlkiZWjz6ySPuq2orPZHVrKK/g7uwU/x1+T7C0jwY=;
 b=AuV6WVj1tr76+ghml+Ym50wfZEg8/u5ba6fkPmk+3SWEnhrKVCkcW/su3tGIQ4yQgUwLLw8XzZYkMa9kebEslBNcn/IbeuxIw+ympOBxWAxoMebO9BnOx9LuKtzUANqoF0wMln5HmKw2va1YcnFqcGKQTyNs4ONUjCSDvQ0cCcfK+vO+tZSJDg8rvZFjjzShZPQukXQIRq+iy38eOJxOiHGdt+oc9T0moPp7zsFrplwCz890xCKV++eAFZedHWZMjooo62sXITyhkjdOorL+xlRVhbmL2tNZ5yyMeEJPmm24S4g23qEsDly7Uvtx93lS2vLhiWbgf2CNshKp2IgiPA==
Received: from DM6PR07CA0083.namprd07.prod.outlook.com (2603:10b6:5:337::16)
 by BYAPR12MB3238.namprd12.prod.outlook.com (2603:10b6:a03:13b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.19; Tue, 17 Aug
 2021 17:05:29 +0000
Received: from DM6NAM11FT067.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:337:cafe::7f) by DM6PR07CA0083.outlook.office365.com
 (2603:10b6:5:337::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.15 via Frontend
 Transport; Tue, 17 Aug 2021 17:05:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT067.mail.protection.outlook.com (10.13.172.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4415.16 via Frontend Transport; Tue, 17 Aug 2021 17:05:28 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 17 Aug
 2021 17:05:28 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 17 Aug 2021 10:05:26 -0700
From:   Eli Cohen <elic@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <elic@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: [PATCHv2 net-next 2/2] net: Fix offloading indirect devices dependency on qdisc order creation
Date:   Tue, 17 Aug 2021 20:05:18 +0300
Message-ID: <20210817170518.378686-3-elic@nvidia.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210817170518.378686-1-elic@nvidia.com>
References: <20210817170518.378686-1-elic@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0555fc74-5cd8-4517-0256-08d961a136fb
X-MS-TrafficTypeDiagnostic: BYAPR12MB3238:
X-Microsoft-Antispam-PRVS: <BYAPR12MB323891B793192044E9588E73ABFE9@BYAPR12MB3238.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: THQtj+DRB0FZ3uEfLoWAnRKs6/sRPxaQanr8USJdARxhLi5qVHZ+gMNV5fZSfhSQL5lVtjXB5XoC62ZwCI83F2M/8jDaQzWXR+elv/vwZ1K6I6W+AJCDLuipWHuaxAe0H9jxj/JHMOz77b+AK31GY0v9CsbuoDkObSjdtdaLOyKM9TACmAbegT65nsCSRBxW2dFq8xZA7gf25IU5HbQG2POu8m/z6hVF6ZY439uBibp9g1PmENoa8SqtEyAeRWTV9BXtOzhwUgkg9YUSwidT8FHdUR5JiExCmVAdxH/2JKD/h1QClskMugWr2nYPq4ACJInwpLqk3/YW8joaPZvg1oXUD8blnZwn+zn8r81ywP5baQYHIe/dGGPrs/e0qE7sBPXshAKPXN29NnhlVoTl/Ur2mnH/rbZro54c5IDrDQDf2j1vPYTvAMcOWfDFmn3wdR8EWPLf0EqrSpLolEP3V5MRrx2L+CssLhrbst1VgTVu0blXh9YUf2KOIkPVS94bJzJGQzH5nZ+9gYAb7j21yyLfiWfqvbdk+SX7aE3Jy4wCvyk6jwBVAeBfpJc5n1bkEwjaT3jQnNK8DXrdA80PCf8X/83qNw3JOYqD8u0GWGjWotjvXG6/p4ylZ1h5k6GFx/TXDWg5qM3F9/rR9KbTxWv1on5Q4xbNKrs9ex+qET3Zi2t/soPTU8cUj6+9BDpQ11XW+mK4nRNge2KHrPsmJQ==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(346002)(396003)(46966006)(36840700001)(82310400003)(8676002)(70586007)(2906002)(36906005)(186003)(110136005)(82740400003)(26005)(8936002)(316002)(107886003)(86362001)(54906003)(70206006)(36860700001)(4326008)(1076003)(47076005)(7696005)(7636003)(426003)(5660300002)(6666004)(478600001)(356005)(2616005)(336012)(36756003)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2021 17:05:28.8545
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0555fc74-5cd8-4517-0256-08d961a136fb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT067.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3238
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
v1 -> v2:
Fix warning - variable set but not used

 include/net/flow_offload.h            |  1 +
 net/core/flow_offload.c               | 89 ++++++++++++++++++++++++++-
 net/netfilter/nf_flow_table_offload.c |  1 +
 net/netfilter/nf_tables_offload.c     |  1 +
 net/sched/cls_api.c                   |  1 +
 5 files changed, 92 insertions(+), 1 deletion(-)

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
index 1da83997e86a..6beaea13564a 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -321,6 +321,7 @@ EXPORT_SYMBOL(flow_block_cb_setup_simple);
 static DEFINE_MUTEX(flow_indr_block_lock);
 static LIST_HEAD(flow_block_indr_list);
 static LIST_HEAD(flow_block_indr_dev_list);
+static LIST_HEAD(flow_indir_dev_list);
 
 struct flow_indr_dev {
 	struct list_head		list;
@@ -345,6 +346,33 @@ static struct flow_indr_dev *flow_indr_dev_alloc(flow_indr_block_bind_cb_t *cb,
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
+
+	list_for_each_entry(cur, &flow_indir_dev_list, list) {
+		memset(&bo, 0, sizeof(bo));
+		bo.command = cur->command;
+		bo.binder_type = cur->binder_type;
+		INIT_LIST_HEAD(&bo.cb_list);
+		cb(cur->dev, cur->sch, cb_priv, cur->type, &bo, cur->data, cur->cleanup);
+		list_splice(&bo.cb_list, cur->cb_list);
+	}
+}
+
 int flow_indr_dev_register(flow_indr_block_bind_cb_t *cb, void *cb_priv)
 {
 	struct flow_indr_dev *indr_dev;
@@ -366,6 +394,7 @@ int flow_indr_dev_register(flow_indr_block_bind_cb_t *cb, void *cb_priv)
 	}
 
 	list_add(&indr_dev->list, &flow_block_indr_dev_list);
+	existing_qdiscs_register(cb, cb_priv);
 	mutex_unlock(&flow_indr_block_lock);
 
 	return 0;
@@ -462,7 +491,59 @@ struct flow_block_cb *flow_indr_block_cb_alloc(flow_setup_cb_t *cb,
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
@@ -470,6 +551,12 @@ int flow_indr_dev_setup_offload(struct net_device *dev, struct Qdisc *sch,
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

