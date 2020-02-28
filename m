Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60B8C172D9F
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 01:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730470AbgB1Apl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 19:45:41 -0500
Received: from mail-eopbgr130059.outbound.protection.outlook.com ([40.107.13.59]:43406
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730441AbgB1Apk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Feb 2020 19:45:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bmrXogttL+iJif7B1kJprI1rWYl+t9EgdC3A2NTd+8IJS7onSThKlJVgU7blkMjAknl2rkp7naTaLvniIfXtuSF5YOtHNlp5fjIwVtEm+3TcrpS1VXSsT8xVQCa1+J1xLfY6bRwMxdQrbAGiIP216OsvwqSRIHZR8+cx6tPHJeAozg2nEzUWrKLFhCuE3doZExebPa279lOyCHRifXEhkTtUOAhTl9wJH86c8fL+rE9Ghmj2/4A2RwPwrEwhMerKcFP/McxMwqHLDU7r20su/Fs0tVDjmbgeMyPfy43ZW1yjy4He7hmZcLJ8QP+sEfIA4kHOr3lKxkPRaWE+MaArEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fqg4kpqhC9LKB8JF7c8h0z6EbqOF4GnZBWQGd8kBgnY=;
 b=Q+1h5GAzxi4J1imxrtrKANPDFOosxM8/+fLh+EJbBmJHsryMcLNydcdA5si2iMvsAE6TEK6uRV/ox/C77uu2C7PmvxZOOgL6WzQg+C0SWGOi87522OOuyEaS2mgVkPu/SjitVpNpkrlM+nhkcuetu3Bq6KcfvGfsx28VpnpMu772qFEiLqM+kWGabcwSbrbx15IhgxUT1f4vHNnWA+OcxXUx46eeD6UAX+GA5ADDalaFO8wFIskKFYN242hJDd0fBqz6REAqZT6ApWHgEqQj+QFYC4a8mvjvsz5wHnbY5GeOVCWf/mji8008Od8K0KxbiJKIvhHorC+n1OQtJStRQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fqg4kpqhC9LKB8JF7c8h0z6EbqOF4GnZBWQGd8kBgnY=;
 b=iPEtHau9NPI3cyslBt0fjAIb1LTDz0CDOcT2Ld4Sdq64kVTR0pTHwsqM7mdi1X8DIXpnBz63RQUAvbpZ0K6FXIxIMQEup3OQ+/HFY6gcTo91C21W6KZ2ER4tTRpy88NcmqJS3m+nbVKxNwyXS4leI48kQWJXbYVGEY7Do17twLI=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4189.eurprd05.prod.outlook.com (52.133.14.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.14; Fri, 28 Feb 2020 00:45:30 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2750.024; Fri, 28 Feb 2020
 00:45:30 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Hamdan Igbaria <hamdani@mellanox.com>,
        Alex Vesker <valex@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 09/16] net/mlx5: DR, Change matcher priority parameter type
Date:   Thu, 27 Feb 2020 16:44:39 -0800
Message-Id: <20200228004446.159497-10-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200228004446.159497-1-saeedm@mellanox.com>
References: <20200228004446.159497-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0004.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::14) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (209.116.155.178) by BY5PR04CA0004.namprd04.prod.outlook.com (2603:10b6:a03:1d0::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14 via Frontend Transport; Fri, 28 Feb 2020 00:45:28 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [209.116.155.178]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1f75c923-a654-48d9-197a-08d7bbe782c1
X-MS-TrafficTypeDiagnostic: VI1PR05MB4189:|VI1PR05MB4189:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4189C4FF91B24785211CCFB0BEE80@VI1PR05MB4189.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:428;
X-Forefront-PRVS: 0327618309
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(366004)(376002)(396003)(136003)(199004)(189003)(66556008)(66946007)(66476007)(6506007)(316002)(4326008)(6512007)(107886003)(478600001)(52116002)(54906003)(6486002)(26005)(8676002)(6666004)(81166006)(86362001)(8936002)(16526019)(186003)(36756003)(81156014)(5660300002)(2616005)(956004)(2906002)(1076003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4189;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CYYHjUMVN8o//IR5vZgkUwJh4CXZXp/0LxexC6AuegMEnBdFGY/CtLy4ivbDaJDJU5eV71NDbP7FC+xri/jhu4cZi47mTw1EjfqIU47NqCxv7+ZtAcdqEh+sI3lmESbjklt4X+FyqnSvcuCeZeG5jFeCwIDW+h/ae648pXSyNhaK8vf7x7pcu0Aza81hc387ImFL2yDyNz5dbMrFyCBMOYSDpLwStpJypEsOvuVMjAUIZX8izjNAqOkgYYv9YuJkRSTCWrUjSC4yWLzxiToKvVFHNlWy+KqowY03Je5hE590YpPmA4pN0AqC0dk1c4wsFkJTC2q0vh4/vVVzkVl5WvhGWGT4x4mz4WZdw5+UERLBgQwV8DVRiH1/ThTCmlx4Rr/hFSLooTRARflrwcw6KpgkP7n5U8XsPiHA/O6oIxYZRR4bNEm7CLgJSXCVDsHaj6i2WVNAyQAVLNgbfwi+A3UIMDC8s2nKicrW79QJ1PTYsh8TaIdpc2coD62rd7Szq+IXohADz4yqiY9qgCdEteO54kjvkwjbWFJEQ18FiwM=
X-MS-Exchange-AntiSpam-MessageData: C5coFs6wL1IzFUjdmJc5AYYrgjHPLwHzu2s5jktvb46d0ISfDEY8yfX7WLkvdVxmOkvVFMrUZce57WXMk9/EKXV6uZysyJcSppd4GS3sB1zzyAaXizHNTCbQmNJNn1fEg86SAWoJm16dyEzJYBPoAg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f75c923-a654-48d9-197a-08d7bbe782c1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2020 00:45:30.5754
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7pxqrQtCHubxIeZ/UZN9eyr35Pj/+FgiHkTsu8dSywguNmootYKvX88VkXSzmhqFDB/DFLrKsi37NjonZGjpsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4189
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hamdan Igbaria <hamdani@mellanox.com>

Change matcher priority parameter type from u16 to u32,
this change is needed since sometimes upper levels
create a matcher with priority bigger than 2^16.

Signed-off-by: Hamdan Igbaria <hamdani@mellanox.com>
Reviewed-by: Alex Vesker <valex@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h   | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c      | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h     | 4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
index c6dbd856df94..2ecec4429070 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
@@ -671,7 +671,7 @@ static int dr_matcher_init(struct mlx5dr_matcher *matcher,
 
 struct mlx5dr_matcher *
 mlx5dr_matcher_create(struct mlx5dr_table *tbl,
-		      u16 priority,
+		      u32 priority,
 		      u8 match_criteria_enable,
 		      struct mlx5dr_match_parameters *mask)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index dffe35145d19..3fa739951b34 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -705,7 +705,7 @@ struct mlx5dr_matcher {
 	struct mlx5dr_matcher_rx_tx rx;
 	struct mlx5dr_matcher_rx_tx tx;
 	struct list_head matcher_list;
-	u16 prio;
+	u32 prio;
 	struct mlx5dr_match_param mask;
 	u8 match_criteria;
 	refcount_t refcount;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
index c2027192e21e..d12d3a2d46ab 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
@@ -140,7 +140,7 @@ static int mlx5_cmd_dr_create_flow_group(struct mlx5_flow_root_namespace *ns,
 					 struct mlx5_flow_group *fg)
 {
 	struct mlx5dr_matcher *matcher;
-	u16 priority = MLX5_GET(create_flow_group_in, in,
+	u32 priority = MLX5_GET(create_flow_group_in, in,
 				start_flow_index);
 	u8 match_criteria_enable = MLX5_GET(create_flow_group_in,
 					    in,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
index e1edc9c247b7..e09e4ea1b045 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
@@ -59,7 +59,7 @@ u32 mlx5dr_table_get_id(struct mlx5dr_table *table);
 
 struct mlx5dr_matcher *
 mlx5dr_matcher_create(struct mlx5dr_table *table,
-		      u16 priority,
+		      u32 priority,
 		      u8 match_criteria_enable,
 		      struct mlx5dr_match_parameters *mask);
 
@@ -151,7 +151,7 @@ mlx5dr_table_get_id(struct mlx5dr_table *table) { return 0; }
 
 static inline struct mlx5dr_matcher *
 mlx5dr_matcher_create(struct mlx5dr_table *table,
-		      u16 priority,
+		      u32 priority,
 		      u8 match_criteria_enable,
 		      struct mlx5dr_match_parameters *mask) { return NULL; }
 
-- 
2.24.1

