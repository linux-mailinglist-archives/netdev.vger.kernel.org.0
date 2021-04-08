Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FDA9357D89
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 09:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbhDHHr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 03:47:56 -0400
Received: from mail-mw2nam10on2079.outbound.protection.outlook.com ([40.107.94.79]:53729
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229505AbhDHHrz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 03:47:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EIhQ8+SaBBWwmJfZZJQRhYp7b6btYczTReMlSoBmnvV4Kg9OauWdOzQTdUaaARoal9w6nXfxl7YiuznUXojK0e4fOyHJGewwfMmW6OEisKwApITYjWpQYR/x1Vu5NV5qAZpkc6Nf23r9z86Q298Ysrk4StmxielgkJwUAih2VxUg6lDH0Otdeq/uHT5L0ZtjxtTcG/i2H+309XE2ElJNQi9H+V2Ke0qMQ24DHxL0dD2kkqWpGKjhJudAhsZHpEf1waaGGWDsYeq8DR8+pEswGLYz+AO9KBtuiRcB1mwisN8IHs9RljExjYq9S0kgzh4pwkNFSNCqPqQtJbtcfZ2kXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D3aoprgBWO0v1I+mxx9p1OZm/1TsyLC8iybC1m0vnpM=;
 b=ICh7NslD/6W9jPV50KcRntNOlFyGQUOccozee4fC7kom4rGv6DzhMTyx0vACLA4zfAiC7gXzTPkQO5VibRwTuOjhQYAy5dnoKKfX0gkbYx33dnVd4E4Rtqg9jrBR3DLAGpTM7zfGDlA6sqjPR0w5dXDJJP9WIaU8qiG3e7Q427i26fZEWxTOLa3B1ryNaKzTg3uJcLNRfe5vVvLLkOKwQXIirB1n1P+3Yf4r3dyDlErXOfLW5oQo06sQjbCeQGePEi837s+iNHc5KcLermC+of3AS8Ht+ewyBCrhUZ+yRb27MTdL9tDyv2ZgngtB1j3gRxfY1SaxDfM9uXFfrbBvEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=netfilter.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D3aoprgBWO0v1I+mxx9p1OZm/1TsyLC8iybC1m0vnpM=;
 b=sMUvLTQQrD1qdvbK0EYAKHTkqSSMixL0GpbSWTHaPbxbVNlkP4d6vimbiV9fEBAEtS6Zo7RcMRWs1p62EboKk9hpDtGtapvbB+eDvz4sVmbH1VFF8BohZlGoWaW34BuVPSNSRhI82wQGRySsxUcnyI4wls7IW91csJmb8dAvTGdrjjw2j/dPGvUviCR/e83T5YuRrXQRw94RmAt1R05SKotrGGjQQCNJ3e5r6PCdHV8UE2i+VUFd4CjlNp1clzUrtvJvucvv/0SVQmK+NFVqZK/MiouQswg6c6hAmto3YCoao+FtUIn7+c4qzID3vqQTk8KR7AaPdUkvj2rJ2GI2BA==
Received: from CO2PR18CA0055.namprd18.prod.outlook.com (2603:10b6:104:2::23)
 by BN6PR1201MB0130.namprd12.prod.outlook.com (2603:10b6:405:59::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Thu, 8 Apr
 2021 07:47:43 +0000
Received: from CO1NAM11FT032.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:2:cafe::1c) by CO2PR18CA0055.outlook.office365.com
 (2603:10b6:104:2::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend
 Transport; Thu, 8 Apr 2021 07:47:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; netfilter.org; dkim=none (message not signed)
 header.d=none;netfilter.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 CO1NAM11FT032.mail.protection.outlook.com (10.13.174.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Thu, 8 Apr 2021 07:47:41 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 8 Apr
 2021 07:47:41 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 8 Apr
 2021 07:47:40 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 8 Apr 2021 00:47:39 -0700
From:   Jianbo Liu <jianbol@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <pablo@netfilter.org>, Jianbo Liu <jianbol@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: [PATCH net] net: flow_offload: Fix UBSAN invalid-load warning in tcf_block_unbind
Date:   Thu, 8 Apr 2021 07:47:18 +0000
Message-ID: <20210408074718.14331-1-jianbol@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 942df542-f1ee-4f28-79a3-08d8fa6296dc
X-MS-TrafficTypeDiagnostic: BN6PR1201MB0130:
X-Microsoft-Antispam-PRVS: <BN6PR1201MB0130C86B82EF976F6683F493C5749@BN6PR1201MB0130.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e2HzWpd2mD8PabyVHCaP+ioQuMdJVP8hUlgoWlQqaUDxaMPcXm46JvU7gCgDhO9Ed6PrxvmFbR8wLv493vRZAY65kapTzfhMwJB3oXzRIIj6Zbtzt8pabmRAc3wU+wKyU+V4PKFRQyyTbe2t6BymdPZwVqpIIh+P7ZZrIxKTLMP5u+RpMLsaPRooXHhS9QDpfscnVX+WkLD/MgkkK1X0TfDyffbmegHCdkUFskLDNrXG9Bdd3CgNu2P90OKDlLekhDCMZcKopPjDQcmluU1+BrsnbnP0SzBTOOdK77b0iFLDtFuJVKlVjIybvwTF4kbc8qyWQd4X4QkGkVHNtjj1ccPFx4zVPXZypxJAGTkd6oDWXaFoDuou1767m2JMimxEHqoWH4O2Ba3UlCbEyG/q4L3xfv/5xp8OU9x+W6u7R65hVN7Gmtm3PeF4jWi+zJraaEHxOpCmdE3bVhLL+hLQxRGFUU4ufBlWT0jff79xqLvemtmMiq1aECmRtMJGvmJ2Y6JkeMHsL05RO1otOeL81CKKCWWy2W+E808kA4ol3f4EuPRqNXJIdOKxE43KWiLOZOmSBS1UK7DcIHVV7uLSfc3MGdOIJHe/wzri1BO59KxJyWdGbD05LJ7hMzxXuJDCl4nkzhT+uAR6BWeoembDW9pdg8eus/VajrBwed1zhlg=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(136003)(39860400002)(346002)(396003)(46966006)(36840700001)(36860700001)(478600001)(36906005)(316002)(36756003)(5660300002)(336012)(82310400003)(2906002)(70586007)(54906003)(47076005)(426003)(7696005)(83380400001)(8676002)(70206006)(8936002)(1076003)(2616005)(107886003)(7636003)(82740400003)(356005)(6666004)(6916009)(4326008)(186003)(86362001)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2021 07:47:41.6456
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 942df542-f1ee-4f28-79a3-08d8fa6296dc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT032.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0130
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When device is removed, indirect block is unregisterd. As
bo->unlocked_driver_cb is not initialized, the following UBSAN is
triggered.

UBSAN: invalid-load in net/sched/cls_api.c:1496:10
load of value 6 is not a valid value for type '_Bool'

This patch fixes the warning by calling device's indr block bind
callback, and unlocked_driver_cb is assigned with correct value.

Fixes: 0fdcf78d5973 ("net: use flow_indr_dev_setup_offload()")
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
---
 include/net/flow_offload.h | 11 ++++++-----
 net/core/flow_offload.c    | 13 +++++++------
 net/sched/cls_api.c        | 11 ++++++++---
 3 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index dc5c1e69cd9f..8cdc60833890 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -459,6 +459,11 @@ typedef int flow_setup_cb_t(enum tc_setup_type type, void *type_data,
 
 struct flow_block_cb;
 
+typedef int flow_indr_block_bind_cb_t(struct net_device *dev, struct Qdisc *sch, void *cb_priv,
+				      enum tc_setup_type type, void *type_data,
+				      void *data,
+				      void (*cleanup)(struct flow_block_cb *block_cb));
+
 struct flow_block_indr {
 	struct list_head		list;
 	struct net_device		*dev;
@@ -466,6 +471,7 @@ struct flow_block_indr {
 	enum flow_block_binder_type	binder_type;
 	void				*data;
 	void				*cb_priv;
+	flow_indr_block_bind_cb_t	*setup_cb;
 	void				(*cleanup)(struct flow_block_cb *block_cb);
 };
 
@@ -562,11 +568,6 @@ static inline void flow_block_init(struct flow_block *flow_block)
 	INIT_LIST_HEAD(&flow_block->cb_list);
 }
 
-typedef int flow_indr_block_bind_cb_t(struct net_device *dev, struct Qdisc *sch, void *cb_priv,
-				      enum tc_setup_type type, void *type_data,
-				      void *data,
-				      void (*cleanup)(struct flow_block_cb *block_cb));
-
 int flow_indr_dev_register(flow_indr_block_bind_cb_t *cb, void *cb_priv);
 void flow_indr_dev_unregister(flow_indr_block_bind_cb_t *cb, void *cb_priv,
 			      void (*release)(void *cb_priv));
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index 715b67f6c62f..85a3d8530952 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -373,7 +373,8 @@ int flow_indr_dev_register(flow_indr_block_bind_cb_t *cb, void *cb_priv)
 }
 EXPORT_SYMBOL(flow_indr_dev_register);
 
-static void __flow_block_indr_cleanup(void (*release)(void *cb_priv),
+static void __flow_block_indr_cleanup(struct flow_indr_dev *indr_dev,
+				      void (*release)(void *cb_priv),
 				      void *cb_priv,
 				      struct list_head *cleanup_list)
 {
@@ -381,8 +382,10 @@ static void __flow_block_indr_cleanup(void (*release)(void *cb_priv),
 
 	list_for_each_entry_safe(this, next, &flow_block_indr_list, indr.list) {
 		if (this->release == release &&
-		    this->indr.cb_priv == cb_priv)
+		    this->indr.cb_priv == cb_priv) {
+			this->indr.setup_cb = indr_dev->cb;
 			list_move(&this->indr.list, cleanup_list);
+		}
 	}
 }
 
@@ -390,10 +393,8 @@ static void flow_block_indr_notify(struct list_head *cleanup_list)
 {
 	struct flow_block_cb *this, *next;
 
-	list_for_each_entry_safe(this, next, cleanup_list, indr.list) {
-		list_del(&this->indr.list);
+	list_for_each_entry_safe(this, next, cleanup_list, indr.list)
 		this->indr.cleanup(this);
-	}
 }
 
 void flow_indr_dev_unregister(flow_indr_block_bind_cb_t *cb, void *cb_priv,
@@ -418,7 +419,7 @@ void flow_indr_dev_unregister(flow_indr_block_bind_cb_t *cb, void *cb_priv,
 		return;
 	}
 
-	__flow_block_indr_cleanup(release, cb_priv, &cleanup_list);
+	__flow_block_indr_cleanup(this, release, cb_priv, &cleanup_list);
 	mutex_unlock(&flow_indr_block_lock);
 
 	flow_block_indr_notify(&cleanup_list);
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index d3db70865d66..b213206da728 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -646,7 +646,7 @@ static void tc_block_indr_cleanup(struct flow_block_cb *block_cb)
 	struct net_device *dev = block_cb->indr.dev;
 	struct Qdisc *sch = block_cb->indr.sch;
 	struct netlink_ext_ack extack = {};
-	struct flow_block_offload bo;
+	struct flow_block_offload bo = {};
 
 	tcf_block_offload_init(&bo, dev, sch, FLOW_BLOCK_UNBIND,
 			       block_cb->indr.binder_type,
@@ -654,8 +654,13 @@ static void tc_block_indr_cleanup(struct flow_block_cb *block_cb)
 			       &extack);
 	rtnl_lock();
 	down_write(&block->cb_lock);
-	list_del(&block_cb->driver_list);
-	list_move(&block_cb->list, &bo.cb_list);
+	if (!block_cb->indr.setup_cb ||
+	    block_cb->indr.setup_cb(dev, sch, block_cb->indr.cb_priv,
+				    TC_SETUP_BLOCK, &bo, block, NULL)) {
+		list_del(&block_cb->indr.list);
+		list_del(&block_cb->driver_list);
+		list_move(&block_cb->list, &bo.cb_list);
+	}
 	tcf_block_unbind(block, &bo);
 	up_write(&block->cb_lock);
 	rtnl_unlock();
-- 
2.26.2

