Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 265B02D464A
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 17:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729967AbgLIQDr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 11:03:47 -0500
Received: from mail-eopbgr60048.outbound.protection.outlook.com ([40.107.6.48]:36676
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728392AbgLIQDr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 11:03:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a0riwAOxWxiDcL9hQAy4Vwa2UtvmaoLqvrtvKE4hBSFnwJrnkiCGj5AHuGZ5d+4o+e4dXls/3uTexFzp6co89nh9seTaQYZkdWZV0S3aJliFdJivOAH+bmtU6hY504A7MyWhOv8RCmTjeoAv2Ny55/j6LwubKwuj0+o3ef2/Z2fKxUN2b1CxLE15y49xZt9pXmffdG4AYAcwr4/CJKuzL4lpj/xJ8D9RABHGAkfBGjWgWHo8cTs1UUy3HR0Sht7R/q54K3oiHOLDU7V5xvui/O8QH7+5/+QvNu+/kOasmnVeA8MRQzvzrZnsQGTYFQugS2eO6h6FmeVj8emm5bjIGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nj2/rfizjPUWlZ9QekU751OoWU5HcqkDHSmRwk+E7rI=;
 b=Xthd5uNO/y4W0RE1A3OM/Vd4k048KsbKfFj2mD2pZCJhQhXyWjBcBjVDMDePZMjhndIdt70xK2Ryslyt72jkZILrXuym7y+K0IdJdlWNANFMF9n7kPWylQ3/XlzOsxnGElwNnAdDqGgYSTvKUSBJBZtes6nRB5x7x8JT4xv4zMYqpeiUaITnGGg1Cp1uuyavswKWFt7PSTlrkZozleIDMtfveXAcPPiZb+NYvlvNVvHhYLzwca+rR9ysqjCPP+RTLA9wO4SS6T1J9EOLyCH8DE1bW8KkhSYrrcUS8u+4ZF4G8/Gdbg8pfpuSaDK9aA/CA24dIf9vbf1zcDLSQv4peQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nj2/rfizjPUWlZ9QekU751OoWU5HcqkDHSmRwk+E7rI=;
 b=ewUKwjFdJfFj2gcYZ/ZW4VHWnutmfFnRgM1Xnt/8AwPQtNeJ7RWuN1cCLOgGqvhUd9UmYnzr3EpbnHxPYPUCjVukxTA8U86NxWZF0QvxmCybc9Ozsw4IvdYJfCINpfR8OdLpRbxdCucHV9HRgUZXbvOZvWDqEu12TC1GltfNrho=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com (2603:10a6:20b:a7::12)
 by AM6PR05MB4149.eurprd05.prod.outlook.com (2603:10a6:209:50::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.23; Wed, 9 Dec
 2020 16:03:01 +0000
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::642a:6259:153:ab88]) by AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::642a:6259:153:ab88%3]) with mapi id 15.20.3632.024; Wed, 9 Dec 2020
 16:03:01 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next 1/4] net: sched: Add multi-queue support to sch_tree_lock
Date:   Wed,  9 Dec 2020 18:02:48 +0200
Message-Id: <20201209160251.19054-2-maximmi@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201209160251.19054-1-maximmi@mellanox.com>
References: <20201209160251.19054-1-maximmi@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [94.188.199.18]
X-ClientProxiedBy: AM0PR04CA0098.eurprd04.prod.outlook.com
 (2603:10a6:208:be::39) To AM6PR05MB5974.eurprd05.prod.outlook.com
 (2603:10a6:20b:a7::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-l-vrt-208.mtl.labs.mlnx (94.188.199.18) by AM0PR04CA0098.eurprd04.prod.outlook.com (2603:10a6:208:be::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Wed, 9 Dec 2020 16:02:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 925640aa-ee20-43fa-c830-08d89c5be7d1
X-MS-TrafficTypeDiagnostic: AM6PR05MB4149:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtFwd,ExtAddr
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB41494367ABEBA8A973B96B3DD1CC0@AM6PR05MB4149.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SL1654Vv+ZQymcAIpPyLAdYpcKkgidMNMpszTLf2iHh1h+7SmI3F7xGe/pSu4+jzOGiMNkQ/v1PZ+27zIwsWsSRHVWIpUiqAtqZY2qjnPK/H33vm/yZIE4cORT+gpOJdNAleGPgCz5CeR6Vn8KapomsuXxxzUlXWxmuMo4vs8ONTejsDhyvd7Iz+yDiUWcpk0IrgoEnu1/kAp5yEOYpaV7tWxv9mcGtbfwyH0SBrnisJtvAd102PPy2A3OB/aIRmFdxC5JWb56BtzQyzUhqj7gfbYvAn/Um9JaCFkuA5nhFZOjskk32VxI2X/TOcyI9oJdMv1WZyaGumaFkraBrKXAUpjlS0YlVmQglgsXqQStunHbBwZhy2h3l6ZWQtvbzN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB5974.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(136003)(376002)(5660300002)(16526019)(186003)(26005)(86362001)(110136005)(956004)(2616005)(54906003)(52116002)(8936002)(1076003)(6506007)(6512007)(508600001)(66556008)(34490700003)(66946007)(7416002)(2906002)(66476007)(83380400001)(4326008)(6666004)(6486002)(8676002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?+3ML/h0k6RwLw3/Dwbe7WQCyCNcuBulHK4vrYi/3vEEl401n9nyrttrtbnMu?=
 =?us-ascii?Q?J7QD9sAtxDpcub47r0+v20XSqDAznCMSxflKzNBG8GUp5zoYn9hBK/6zh+fO?=
 =?us-ascii?Q?eH1g9h5I29gpqAb6yFY/Of8HuDG6O+aee6IKylnmAF4yW/ogketssPpB+w/R?=
 =?us-ascii?Q?3iKxr37VJ3YrHM9l19FY+8aL6NQR40zmMbYVh6mRIjVJhdjuoU8zfx3xXccp?=
 =?us-ascii?Q?3S0OuE/XIrFHohpqAYstQX/Uyb0qme6FmbozfThymQUHofRlYUSkEPxkYDq/?=
 =?us-ascii?Q?3oD8g4WN08gDNA5Sf+xa1BgRpSsXkTkXCYpA0sHzBY1urFWqyf98joAseqU2?=
 =?us-ascii?Q?IDwy0UmtTYLo5vWBNF00I4J5HJ6iaPBYH1DKSfXhI6FtulNNpOSHI4Qi+OL1?=
 =?us-ascii?Q?6l+p+x9iygM7zLAid/BcW5Vlx2uVfTjlKHALScBR1LnM2+1ZGjnKnoDi31cN?=
 =?us-ascii?Q?AYCYI9AxiBXYaE5O4OEXwF/69IpGajaFKeJmjIuFvPaYwMHto68p+F2QaWHB?=
 =?us-ascii?Q?RominQeGHxb7UFtyyE2s97QiZFoGUcafTRqBk25b6d1YgSnotlVGmtkgwQbe?=
 =?us-ascii?Q?qV1B9lm4zuzciiu3A52yADS8eBNHuBVW9RZR17xTI7WNKkKya8XW3RXKo0fY?=
 =?us-ascii?Q?I4or8vql5KoIz3kp0ifIPXB69LM6s9HP2P/S3zinA6D2K+x10IvrkPoZCQsC?=
 =?us-ascii?Q?OeB28bo3x3V3pKB5KnGotG1PeadKxoBXOocdhUWSGynbSEE6NOfgn9X9A0zI?=
 =?us-ascii?Q?fkGI7Se/zkhwkm4vtXKzkScfIl8kNh7alxq2LBPJ/NehfoM/2rkZSLcVy6la?=
 =?us-ascii?Q?csDDQCL8b/Epbek3jeyFaPKqOQAc/2AS4vN2tOANKzmxPhFRNt7GpZ6Ba7gs?=
 =?us-ascii?Q?oRuHGBssGBL4IciKHX56wPl6Qgc6ne5h5SwbEbuMtJbycVujS+kbEuWtC8Jr?=
 =?us-ascii?Q?TLP6yYw1lpdH/ae8EPZGTpu86WpuGLQY1P3hL/2CCQZhGtQDgMLOXx+SbgTQ?=
 =?us-ascii?Q?2jkk?=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthSource: AM6PR05MB5974.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2020 16:03:01.7687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-Network-Message-Id: 925640aa-ee20-43fa-c830-08d89c5be7d1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yx6Rrn5ivk8WKRQwqUxlUtqiiUMFPRcBklFZKKzIfnKv2cJNTGvE5f5AvCJALoAGxFyZZzP8IMpsMLpRzPj/Ng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4149
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

