Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B91212DA8B8
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 08:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbgLOHnn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 02:43:43 -0500
Received: from mail-eopbgr40043.outbound.protection.outlook.com ([40.107.4.43]:38478
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726644AbgLOHnd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 02:43:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aVsp4VmNdAsVRIiE4Py9y6zPp1GF+YLtW8WbJx/BhgGGYH57GNBsMCN92ZkaVWt1Z/Gb6Wo5CITul6SwH9R4FNiWJitDO860EaryppXocPGyFEjpklAL5Zsn91/CaHkfviEpiJ81u4uRmHuU086h5pz8YsinPFPFHi44RwY7bDrK7QQDtnaMNDVsEYlJsGfpg2HIP+1d6iN6Gqrn8/ACBMuX6q2kCKfowbP4oKAXR6pSBAv2elBgyLkBKemgXIOEk2VMUHDq7ue7oi7xfPEJpY6hhkJckSCReVOvQIOzZmPQ/HbWrrR+7zBQGhb8JVAltB4Fl1tkHP7bq0aXNfGzOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nj2/rfizjPUWlZ9QekU751OoWU5HcqkDHSmRwk+E7rI=;
 b=K9zabK8ASk9wPG7ZbgmmY+C3bHNiu8VlVZFLYDFGfkaru27eRB7f+/EjY/4j2yrPJqE7gnNOK6qsX5kgEFIy5eZxihwp+lyQxA4P+LIqKxIym2qTs72dWeqrTWGicaPVxNnb9y3r3U6SVvI819p0cnMj0pTNm7h9SfRd5QYJpnJGzi41ms2ssXrsBrC/PTrzZvb+ahPUgGlWRw4L7w0CqdvJUl9c7BtqI5+Mdip3UFHcHgv8VXMgtTcEgaYN8XIn9Hk+yroSuAi9zqWrdazZKg3STcNtA+nFo2RzxBcEOCZckTbgDE+FnujDf+PEDTVPQtTYREOEuR4uWoxYOuDa0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nj2/rfizjPUWlZ9QekU751OoWU5HcqkDHSmRwk+E7rI=;
 b=gGVctCZ4BYyDo4+nYWVPnenwEsAZwP6qVRqd0LQOHGOFtfrpV0ikeKw6j5L7EgUixKv3DVK0OI4i4PSqtMA5ZWWTpdX2A603uAUiOSeBRTEsQVAhfqCDY+39hLP1+0hYqPeYAVVD0++liKgBkpz/Ek5ETkhaBL7SOXgPEYYZoi8=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5982.eurprd05.prod.outlook.com (2603:10a6:803:e4::28)
 by VI1PR0501MB2335.eurprd05.prod.outlook.com (2603:10a6:800:2e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.17; Tue, 15 Dec
 2020 07:42:05 +0000
Received: from VI1PR05MB5982.eurprd05.prod.outlook.com
 ([fe80::ddc9:9ef:5ece:9fd2]) by VI1PR05MB5982.eurprd05.prod.outlook.com
 ([fe80::ddc9:9ef:5ece:9fd2%5]) with mapi id 15.20.3654.015; Tue, 15 Dec 2020
 07:42:05 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, David Ahern <dsahern@gmail.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Yossi Kuperman <yossiku@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: [PATCH net-next v3 1/4] net: sched: Add multi-queue support to sch_tree_lock
Date:   Tue, 15 Dec 2020 09:42:10 +0200
Message-Id: <20201215074213.32652-3-maximmi@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201215074213.32652-1-maximmi@mellanox.com>
References: <20201215074213.32652-1-maximmi@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [94.188.199.18]
X-ClientProxiedBy: AM4PR05CA0025.eurprd05.prod.outlook.com (2603:10a6:205::38)
 To VI1PR05MB5982.eurprd05.prod.outlook.com (2603:10a6:803:e4::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-l-vrt-208.mtl.labs.mlnx (94.188.199.18) by AM4PR05CA0025.eurprd05.prod.outlook.com (2603:10a6:205::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Tue, 15 Dec 2020 07:42:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7bf9e90b-f629-495e-dbbb-08d8a0cceb64
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2335:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtFwd,ExtAddr
X-Microsoft-Antispam-PRVS: <VI1PR0501MB23358881F3DE680E36844CA3D1C60@VI1PR0501MB2335.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1AbHvpaSqNyjh8NQhEW7axxtTNFHLU8ZthGi5jKiV41Dch6xjj5Ajsh4uNiCOpfJOlEs4QFoZWsvSOT3Z4viL50qo8xbZjGhnOq+XQL1SV+5AgHMtxvoaaOlnpJtrZtKU+zOx1IcxIYDUGXGuManeID5I/vhcjV2aOmrNSAqtFZJeUD9xDts+Slu9YEmsZ/k8gZELoBXdCq+lETgzBm8TDA4WhJDaqjV5+2bVl91dCiQrD5NtxF4dmqfEW2GXv3r1S6euHROzn8VWKKp4fEaTRXY6C1UA4dlpdOZK+A8xlCweIMSk8eqDPpIaZNUwDd8+v8HYz64GwHd9uKJKHTQtQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5982.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(39860400002)(346002)(366004)(136003)(8676002)(52116002)(186003)(6486002)(16526019)(2906002)(66476007)(7416002)(66946007)(110136005)(6506007)(316002)(36756003)(5660300002)(66556008)(8936002)(6666004)(54906003)(83380400001)(26005)(107886003)(1076003)(2616005)(86362001)(478600001)(6512007)(4326008)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?MJ1Z+nLcotqyP6+ctai7ZRDGPUTsyqc0OLc3LV68GcG4cTDqCEPudyzRpQEt?=
 =?us-ascii?Q?yMtKJYCrCXXW03suz7PG11xqt+M/Zxb27UhbWviM//ujNyIsjgNGlY6XrknG?=
 =?us-ascii?Q?HD8wavSEovSs6ggc5VjkOJiYbcWn/w+ow0fJf/PMmXcDrw7+0A4ACLvhG1p4?=
 =?us-ascii?Q?ffTsxF+Tyo2gv7vE9ot6qsGWjdz5jlpyuAo+tG9ZavymbTv2gcI/pHqYHTp/?=
 =?us-ascii?Q?mcQc5v9jdh1L9BuB1OUd0Y08jgHYlYQavoPxvWMWAw3kEX7mdMYXiJko8UNT?=
 =?us-ascii?Q?UhQjsWG4jf2uMDqEWz3FhO2dP9TcOYtpGKELllrFT2Cb7ARPP0Yk+78/bfRj?=
 =?us-ascii?Q?qxCx6u0HeaaohaooDcSbze31itLoIDavAuGzpbSdYQYzVNO8F7VeM6epH85C?=
 =?us-ascii?Q?hKFMpCszBR0gEBoX7z0NyDWMW+O4aRShc5/x6vn26YKA58mjW7vC793JQe9u?=
 =?us-ascii?Q?HkmvpB1TvIt20Dnk9LjQapSqSAmW6cKSEgE+tXMyKxpE1m4MRZukUTygG/y0?=
 =?us-ascii?Q?u0QSVjGhtnxZEMcvWJid69e2lseVJ9OpTZxevg5IMxbO7v1CxEY8RTeANgmF?=
 =?us-ascii?Q?LEU+fpw+NAHV0LjBz4/2MvqZkIXp6jNXBCPB874sjJo8+vIUa97zlwVYCnIU?=
 =?us-ascii?Q?xlbG2vrZxJnt+eBypDTdAAU9ErHGcQHXIvs3IKAOUa24AoKW6uYEEktRNTaW?=
 =?us-ascii?Q?GUY7J90OSVLEDTtl0Ii3P6TPM+fyP3WybN306aS3lp8ViQxl4D4DxhGKAEMc?=
 =?us-ascii?Q?G99xv8IA3jSX5jvvmcm7BBCbb3gDbn+mmW5XnsGTdtvcZyHWzUBWKBKlItKy?=
 =?us-ascii?Q?w2pp29O0+yUcbtfBEftxy9GPBROsXpf3QTI2rUVfarORady16xYZs9u9eZHv?=
 =?us-ascii?Q?KeA9BIR6brDgYYjBxLCfS/Kzrm7IRU04C/1HkggB23Xsr6+AsEHns4K3Db2+?=
 =?us-ascii?Q?h/oEPw3B4BjfzzpXFaaCvii5gCBVCFfL+vo/c6tTp8Yme6UVslUhuOTdaYZm?=
 =?us-ascii?Q?oDrh?=
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5982.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2020 07:42:05.4704
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bf9e90b-f629-495e-dbbb-08d8a0cceb64
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dyiTsQVqZ5JLSZITbNeli46AQJoAlsCm715jwIpI9eIW8MZSrKvsoNwP3nXhyhcthmXslpOQha1b/b0yO2XQVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2335
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The existing qdiscs that set TCQ_F_MQROOT don't use sch_tree_lock.
However, hardware-offloaded HTB will start setting this flag while also
using sch_tree_lock.

The current implementation of sch_tree_lock basically locks on
qdisc->dev_queue->qdisc, and it works fine when the tree is attached to
some queue. However, it's not the case for MQROOT qdiscs: such a qdisc
is the root itself, and its dev_queue just points to queue 0, while not
actually being used, because there are real per-queue qdiscs.

This patch changes the logic of sch_tree_lock and sch_tree_unlock to
lock the qdisc itself if it's the MQROOT.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 include/net/sch_generic.h | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 162ed6249e8b..cfac2b0b5cc7 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -563,14 +563,20 @@ static inline struct net_device *qdisc_dev(const struct Qdisc *qdisc)
 	return qdisc->dev_queue->dev;
 }
 
-static inline void sch_tree_lock(const struct Qdisc *q)
+static inline void sch_tree_lock(struct Qdisc *q)
 {
-	spin_lock_bh(qdisc_root_sleeping_lock(q));
+	if (q->flags & TCQ_F_MQROOT)
+		spin_lock_bh(qdisc_lock(q));
+	else
+		spin_lock_bh(qdisc_root_sleeping_lock(q));
 }
 
-static inline void sch_tree_unlock(const struct Qdisc *q)
+static inline void sch_tree_unlock(struct Qdisc *q)
 {
-	spin_unlock_bh(qdisc_root_sleeping_lock(q));
+	if (q->flags & TCQ_F_MQROOT)
+		spin_unlock_bh(qdisc_lock(q));
+	else
+		spin_unlock_bh(qdisc_root_sleeping_lock(q));
 }
 
 extern struct Qdisc noop_qdisc;
-- 
2.20.1

