Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6AAC426ABA
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 14:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241545AbhJHM2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 08:28:30 -0400
Received: from mail-bn7nam10on2081.outbound.protection.outlook.com ([40.107.92.81]:38688
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241582AbhJHM2O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 08:28:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jPBGrkkOJNvCTRZ/Bq/mSm3QWHHQWmxkRFKr7McY7xALHmVze5tKVh4w7e1gDTXGkfwRH2ItX2zIJTpXm8P1dRiO1A64Nh2+AO+tWjN1oGQxAp42tboeqLxv5GPCLtcl2IjLkYar59GYAMQPw1NmlT+KbtPsI9rzumF63RM0z5fjxpDSI9n33sJFD3bsfuI/v5UeXH2Xb/BPsdEaqNLe1D7MJlnAU9IdFkaaV2WLNqg+cR6v6ep4dSyw2KWJo56I0hJS16ZqLq+V5xTzloNzrmdWSJcSu0/OkwNjlB/Hc9YCRm69JAuxwjz/jYHyciMOL0LLMpm35x8FrgWb/7D4MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4dK3GIoiKN0D5DHbI88X0iH3TPKz45yTldo9SrMkQhs=;
 b=JTpN7Ybfv2kjhgrrQIjwE9wO7rv8u55NDtzIMUxVw4DC0qpPz4aCP5wWh/2Xg22vhyQpBya0KsYLrVJCgivZlLhPOkeC5HfFB9oM9TwVMSiIhRszS0IOrcb7GyIGgCwKaRk/ysCwKZMeLW+yQp7ivKf+pH/BTWnxuje4sZtTlC1Liu05GUALjrVXQKhitu7YZsAs7gkfLAh2zwOoiiLMkcjGu/rFG4j/f+2F5+BrRPh9NH6t1t5Pkh1aznRES9xY6qLTyxVGzXUluFL+GxIP45khRBASCFd8aVniI1beQXC1Bga5rTEzhyRvhEEsokyOnzXWMQaQ/H7o4bY3EekU3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=chelsio.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4dK3GIoiKN0D5DHbI88X0iH3TPKz45yTldo9SrMkQhs=;
 b=TFvvu9yACXwGbC5QeRy6axjcVhXFsJzeEQ5Fawn09fehky+1+xmVdl6+uB5ykEgd40ILAoqkrfsM3X/66DD96DI19kPoyspn/SbmgQmKacEa6TYPkAIbjqzl7Zd8YGQnuBmTPn9VHi9H75Hjnhb+sza5jSTjX95b9C9OxNb1TZQ7VSlbsVNoqNIwAnJ1E1EECo77xaN8UlcrB3LwsmCu79UVCARnoHB2MiJ0P+10z9E94TvxP4KgfknXukcbb4eQnlOfhz6GusWSh1BiNKgGtunRG81nW8aQAywPanWkTlNRLwE6qvrK6TFbFSek3VHDTXM04XgORayB3AGrdjzjbQ==
Received: from BN6PR19CA0073.namprd19.prod.outlook.com (2603:10b6:404:133::11)
 by MN2PR12MB3006.namprd12.prod.outlook.com (2603:10b6:208:cd::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Fri, 8 Oct
 2021 12:26:15 +0000
Received: from BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:133:cafe::b7) by BN6PR19CA0073.outlook.office365.com
 (2603:10b6:404:133::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.16 via Frontend
 Transport; Fri, 8 Oct 2021 12:26:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; chelsio.com; dkim=none (message not signed)
 header.d=none;chelsio.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT052.mail.protection.outlook.com (10.13.177.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4587.18 via Frontend Transport; Fri, 8 Oct 2021 12:26:14 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 8 Oct
 2021 12:26:13 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Fri, 8 Oct 2021 05:26:09 -0700
From:   Mark Zhang <markzhang@nvidia.com>
To:     <jgg@nvidia.com>, <dledford@redhat.com>, <saeedm@nvidia.com>
CC:     <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <aharonl@nvidia.com>, <netao@nvidia.com>, <leonro@nvidia.com>,
        <dennis.dalessandro@cornelisnetworks.com>, <galpress@amazon.com>,
        <kuba@kernel.org>, <maorg@nvidia.com>,
        <mike.marciniszyn@cornelisnetworks.com>,
        <mustafa.ismail@intel.com>, <bharat@chelsio.com>,
        <selvin.xavier@broadcom.com>, <shiraz.saleem@intel.com>,
        <yishaih@nvidia.com>, <zyjzyj2000@gmail.com>,
        "Mark Zhang" <markzhang@nvidia.com>
Subject: [PATCH rdma-next v4 05/13] RDMA/counter: Add an is_disabled field in struct rdma_hw_stats
Date:   Fri, 8 Oct 2021 15:24:31 +0300
Message-ID: <20211008122439.166063-6-markzhang@nvidia.com>
X-Mailer: git-send-email 2.8.4
In-Reply-To: <20211008122439.166063-1-markzhang@nvidia.com>
References: <20211008122439.166063-1-markzhang@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1c08853f-1bbc-4c4f-5825-08d98a56d265
X-MS-TrafficTypeDiagnostic: MN2PR12MB3006:
X-Microsoft-Antispam-PRVS: <MN2PR12MB30063B95F72500880A54B7D9C7B29@MN2PR12MB3006.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GeAdQKOudAZxVbphak8ZcxZWnDcW5PULcVA0GHg5YJ1WmUCCh1Th4xrpJl9zwIyjwHZry2EVFGnptMoPxF7ip/9r+48F102jjWtT9QK9P7XHVL2SydbJOClsu3WXK6KLo/ua9UzXg+YBRyr5JMDwLtm/VNGP85cAaSTTI6nHtNT8C2YlB7qs+9UKmfsWb1NVsY2NwbBr0Bc50A1Yyvd5z2QBT8Opnm2XKfMeVqCkWd9u09v2+IqmR6JVPBGC1qHq5sFmuvAEdtS/3Bc/8RM32KYQ1MsXKyjGufloli9dwl5VXM5epY5WXS1jxl11qJTLvPvfGW53lT4vhM++ui2sf00Gqj4eoqBfDrSI8BKaIFcUt1dO0BmsIDtakf9GqE3nOuhSG1PocAufJLZ1K/w7bIGlrHJmxJQJe/fm5WfPNljx4faorKc+e7+2wfd1WKUqSSlt0EqAIopbZlBRoFWjmipxffIpxF6auIdY9aXapfTw0xlPZZxyneg9aqygsVbR4upEynwh8j3LYn5QUG86mXeTFIkpylrdAYPahqqarFPI1v7Q6lNqLJY1JE2bu/6OkNZCCXLXrchEBdhWKCAhjs2KPUUV/lIKEOOUgAcbGLCHxHl7zf++Sg6HATtpIILNtiRlJ4zO2A5maLsyi2fzSEbsJcmgl+4krVGVUzDut9O9+zYdK75+UItAEUN8mUJQpLDgEaHQ++kb9Qzm0atqzQ==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(8936002)(6636002)(47076005)(8676002)(4326008)(83380400001)(508600001)(36756003)(107886003)(5660300002)(336012)(426003)(86362001)(2616005)(26005)(7636003)(186003)(70206006)(2906002)(7696005)(356005)(36860700001)(110136005)(6666004)(7416002)(70586007)(54906003)(1076003)(316002)(82310400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2021 12:26:14.9774
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c08853f-1bbc-4c4f-5825-08d98a56d265
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3006
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aharon Landau <aharonl@nvidia.com>

Add a bitmap in rdma_hw_stat structure, with each bit indicates whether
the corresponding counter is currently disabled or not. By default
hwcounters are enabled.

Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
---
 drivers/infiniband/core/nldev.c | 11 ++++++++++-
 drivers/infiniband/core/verbs.c | 13 +++++++++++++
 include/rdma/ib_verbs.h         |  3 +++
 3 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 3f6b98a87566..67519730b1ac 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -968,15 +968,21 @@ static int fill_stat_counter_hwcounters(struct sk_buff *msg,
 	if (!table_attr)
 		return -EMSGSIZE;
 
-	for (i = 0; i < st->num_counters; i++)
+	mutex_lock(&st->lock);
+	for (i = 0; i < st->num_counters; i++) {
+		if (test_bit(i, st->is_disabled))
+			continue;
 		if (rdma_nl_stat_hwcounter_entry(msg, st->descs[i].name,
 						 st->value[i]))
 			goto err;
+	}
+	mutex_unlock(&st->lock);
 
 	nla_nest_end(msg, table_attr);
 	return 0;
 
 err:
+	mutex_unlock(&st->lock);
 	nla_nest_cancel(msg, table_attr);
 	return -EMSGSIZE;
 }
@@ -2104,6 +2110,9 @@ static int stat_get_doit_default_counter(struct sk_buff *skb,
 		goto err_stats;
 	}
 	for (i = 0; i < num_cnts; i++) {
+		if (test_bit(i, stats->is_disabled))
+			continue;
+
 		v = stats->value[i] +
 			rdma_counter_get_hwstat_value(device, port, i);
 		if (rdma_nl_stat_hwcounter_entry(msg,
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 8e72290d6b38..47cf273d0678 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -2994,11 +2994,20 @@ struct rdma_hw_stats *rdma_alloc_hw_stats_struct(
 	if (!stats)
 		return NULL;
 
+	stats->is_disabled = kcalloc(BITS_TO_LONGS(num_counters),
+				     sizeof(*stats->is_disabled), GFP_KERNEL);
+	if (!stats->is_disabled)
+		goto err;
+
 	stats->descs = descs;
 	stats->num_counters = num_counters;
 	stats->lifespan = msecs_to_jiffies(lifespan);
 
 	return stats;
+
+err:
+	kfree(stats);
+	return NULL;
 }
 EXPORT_SYMBOL(rdma_alloc_hw_stats_struct);
 
@@ -3008,6 +3017,10 @@ EXPORT_SYMBOL(rdma_alloc_hw_stats_struct);
  */
 void rdma_free_hw_stats_struct(struct rdma_hw_stats *stats)
 {
+	if (!stats)
+		return;
+
+	kfree(stats->is_disabled);
 	kfree(stats);
 }
 EXPORT_SYMBOL(rdma_free_hw_stats_struct);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 938c0c0a1c19..ae467365706b 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -565,6 +565,8 @@ struct rdma_stat_desc {
  *   their own value during their allocation routine.
  * @descs - Array of pointers to static descriptors used for the counters
  *   in directory.
+ * @is_disabled - A bitmap to indicate each counter is currently disabled
+ *   or not.
  * @num_counters - How many hardware counters there are.  If name is
  *   shorter than this number, a kernel oops will result.  Driver authors
  *   are encouraged to leave BUILD_BUG_ON(ARRAY_SIZE(@name) < num_counters)
@@ -577,6 +579,7 @@ struct rdma_hw_stats {
 	unsigned long	timestamp;
 	unsigned long	lifespan;
 	const struct rdma_stat_desc *descs;
+	unsigned long	*is_disabled;
 	int		num_counters;
 	u64		value[];
 };
-- 
2.26.2

