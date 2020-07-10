Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C36D21BF77
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 23:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbgGJV5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 17:57:20 -0400
Received: from mail-db8eur05on2045.outbound.protection.outlook.com ([40.107.20.45]:6078
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726582AbgGJV5R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 17:57:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hr1Z4HcHcx+CbWNcqeog1/NymitKyBOLXA2iUwsxVrUOa0eg9V4V0bytZuxEzxwdlVcCa6X+UNn3oe53hYQff2URGEUGBJurIHE2Bs9yrCA/ZCXuDWpCG7kFRSxrjSeifl6kWsW7ERcYh/m2IPTdfUqb4T3fI3o+uMIDmPV6ExFh9gYYwiOPI7VSQal38Qj7jKkFBC7v62uOrGyGYnypZaMJ+Iwe1UApg7d3uBiL3hIp44pfuFgLrNQy0TriuBe77Ne4QvdO88B0COMx9/wxw9g77H7FwHhgIcdZEFTdiR09M7d9zbaezIJKqpmDXwNSGQJws06phakHa4dwY1xZXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PiTj+e+v2zf3FqNRHUX1f+ovhDNF6EZ/y/ULcKOFtIw=;
 b=Kc1tPqUd4S6zAEnmAp7DZDafoKdxiyvsjNlvO1g6HysfQ0lMyBrzfnyJ7/ssBVZXvuLuE4NmiuHNIbe0lURpz9PiTFvKKHePYCQecikqrSeeYkhnaHIYumwfyNy6jRvLtVoKAwP9Fqt11Cz1st0N6nD1JmmZru/puG8e1fy0TfBPD98ENtggkiOvn5ERg1ZIVFbuuASf5WrDAjP3zl4DJzi5rromWY8toEef49CHXB7Z8cXQOU0cgTY6CtqgCQBlICFryacQtRQmExF3wSKecUv+n/p0WLRd7g8gC6mLts+vo0x08jGqCW0QcrOA/RnLrj30xVMTuM0GmBo8xoeIIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PiTj+e+v2zf3FqNRHUX1f+ovhDNF6EZ/y/ULcKOFtIw=;
 b=MT/7UNoWDKqv01ejdTLfjZH1LHKNz/6QRqKYZw4zfZ1HrYf3ibegYjaX5FmX5QTeFRDz4LSgDYReredlqEvgEK+FpkrXxEyhJb3OmQ+ZzD62bIA3FuiXrrAtVgCjq79ZJAX2799R6KtlOeF/m65Q5E4soJFSENOxvgakbCQp5cQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3354.eurprd05.prod.outlook.com (2603:10a6:7:35::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3174.20; Fri, 10 Jul 2020 21:57:03 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3174.023; Fri, 10 Jul 2020
 21:57:03 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>, davem@davemloft.net,
        kuba@kernel.org, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, michael.chan@broadcom.com, saeedm@mellanox.com,
        leon@kernel.org, kadlec@netfilter.org, fw@strlen.de,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        simon.horman@netronome.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 10/13] mlxsw: spectrum_matchall: Publish matchall data structures
Date:   Sat, 11 Jul 2020 00:55:12 +0300
Message-Id: <2517500302274b47a47fe8734d7faf734681f6bb.1594416408.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1594416408.git.petrm@mellanox.com>
References: <cover.1594416408.git.petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0116.eurprd07.prod.outlook.com
 (2603:10a6:207:7::26) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM3PR07CA0116.eurprd07.prod.outlook.com (2603:10a6:207:7::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.8 via Frontend Transport; Fri, 10 Jul 2020 21:57:01 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c6f773c8-c2ab-47c3-d4c5-08d8251c2e08
X-MS-TrafficTypeDiagnostic: HE1PR05MB3354:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB33546AD9E023560284DAF5E2DB650@HE1PR05MB3354.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zmSfwdpbOh8H2hop2Oppe3JoJKfIQI+Qn/h9RCwJpKD83Hiz4ZNhHZawC1WNEfGxbLzhF/M5udh3hIM3XZJvFFQYhOlJ/U2afSVSUBQt/xLTvc4+jNtKkmQ+MDAJVzQfKfLStsmp9s3hdEk26aKxyJvzK1EDBVjAE7o+s8GgKb9rwl5UafG7XKsGVmx93ne6XzyLeX0jMlJYEzf3V/u+Q1lxU5wschQml1aPVniBIaumIGhq0+nZSNpKV4nfZC8/CJLpDlhb1tQ67tbyQ8y+QmbO55emrNdN/dhuRZi5xAlJ4ZeBSC8u5Yvs5vfz2OcA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(376002)(346002)(396003)(366004)(956004)(86362001)(2906002)(6916009)(5660300002)(2616005)(83380400001)(54906003)(7416002)(6512007)(8676002)(107886003)(26005)(52116002)(6506007)(36756003)(66556008)(66476007)(316002)(8936002)(4326008)(478600001)(16526019)(6486002)(6666004)(186003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: zCXV3iGU16LkoEfUoXW38/LwC2gVZ7yJ5VO1abo3Pbda6XW659IbM22kMsLqtKMCMJHPVTrvaeZVuwP6FcXK/CZlv3Ju9gD0Zi07drKhS/GIJfz1kJ10YRJB7H8MlS5KCD7+MCu0F7N2ZX7uzsbqO7P3jm4Gws0Yjmjb47gWgsTdnhCSNtTO8TmNAuDciddTxidBrkvIPV7+9W8RvHygGJ3PnZvTsYxfK7kaiey9Q4imQS1oAIjWnRlULQox342Ct3SEJex+3FC0Y12kfy0dxy+gEGygMQ0BXxkl3Vw3IpCtbXAv+nrfvvF0dLZfF2VHv8yjjonCERorJImPoVqiBDi+4May/c3/VBjQrsZPeWmV8mtP1m3J0W+pB3OeTTWH+2dRxsF1xEm98RL4UbcPmbIvGjepJ0obN8ZajKY0IcHKbOMLwbQCjOa3jPnKdf2NLpOYSZZ8zhps38reOzWSxxqd5+q7clO6rPpHst6XY5g=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6f773c8-c2ab-47c3-d4c5-08d8251c2e08
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 21:57:03.7536
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 10HaDolb0duXPF/naSMdZ/Yh83i7v6vyfEZXA4X1odz9Kj9mDZ23MKrCB+dN9eMY14YY2v7qRaaNRNooqeLi7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3354
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A following patch introduces offloading of filters attached to blocks bound
to the RED tail_drop qevent. The only classifier that mlxsw will permit in
this role is matchall. mlxsw currently offloads matchall filters used with
clsact qdisc. The data structures used for that offload will come handy for
the qevent offload as well. Publish them in spectrum.h.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.h    | 24 +++++++++++++++++++
 .../mellanox/mlxsw/spectrum_matchall.c        | 23 ------------------
 2 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index ab54790d2955..51047b1aa23a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -960,6 +960,30 @@ extern const struct mlxsw_afk_ops mlxsw_sp1_afk_ops;
 extern const struct mlxsw_afk_ops mlxsw_sp2_afk_ops;
 
 /* spectrum_matchall.c */
+enum mlxsw_sp_mall_action_type {
+	MLXSW_SP_MALL_ACTION_TYPE_MIRROR,
+	MLXSW_SP_MALL_ACTION_TYPE_SAMPLE,
+	MLXSW_SP_MALL_ACTION_TYPE_TRAP,
+};
+
+struct mlxsw_sp_mall_mirror_entry {
+	const struct net_device *to_dev;
+	int span_id;
+};
+
+struct mlxsw_sp_mall_entry {
+	struct list_head list;
+	unsigned long cookie;
+	unsigned int priority;
+	enum mlxsw_sp_mall_action_type type;
+	bool ingress;
+	union {
+		struct mlxsw_sp_mall_mirror_entry mirror;
+		struct mlxsw_sp_port_sample sample;
+	};
+	struct rcu_head rcu;
+};
+
 int mlxsw_sp_mall_replace(struct mlxsw_sp *mlxsw_sp,
 			  struct mlxsw_sp_flow_block *block,
 			  struct tc_cls_matchall_offload *f);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
index f1a44a8eda55..195e28ab8e65 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
@@ -10,29 +10,6 @@
 #include "spectrum_span.h"
 #include "reg.h"
 
-enum mlxsw_sp_mall_action_type {
-	MLXSW_SP_MALL_ACTION_TYPE_MIRROR,
-	MLXSW_SP_MALL_ACTION_TYPE_SAMPLE,
-};
-
-struct mlxsw_sp_mall_mirror_entry {
-	const struct net_device *to_dev;
-	int span_id;
-};
-
-struct mlxsw_sp_mall_entry {
-	struct list_head list;
-	unsigned long cookie;
-	unsigned int priority;
-	enum mlxsw_sp_mall_action_type type;
-	bool ingress;
-	union {
-		struct mlxsw_sp_mall_mirror_entry mirror;
-		struct mlxsw_sp_port_sample sample;
-	};
-	struct rcu_head rcu;
-};
-
 static struct mlxsw_sp_mall_entry *
 mlxsw_sp_mall_entry_find(struct mlxsw_sp_flow_block *block, unsigned long cookie)
 {
-- 
2.20.1

