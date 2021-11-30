Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C503463116
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 11:34:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233443AbhK3Khp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 05:37:45 -0500
Received: from mail-eopbgr80113.outbound.protection.outlook.com ([40.107.8.113]:37185
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233346AbhK3Khj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Nov 2021 05:37:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j/v9t9k4nUa7grOiNVy7wO4UcW91ytVlCwx+ELvySCj4a8mDFhcRAyz7VQUYFsjYQh/tw/133b0A/Kwhi7LRYiOWa/twlHZGEIGMIdbZd0zFJOe1ObHhJzFni+FCkU7NhxcXYHNo7ZccSlhXUyCxRqtSqfGcQsI0m9UUL51fHo15KpZ7vl+Vr0HOekWl6viLKMyrnj3kKe5Gru/1e2q/fK5PxDwus2m0Sp/5akTyBFybDEdkL+JaWtw2XWKSn1o19Jh+niNLjhvm9JgjHpowcxK/r4pJXoSS/fNXLjsX/JhFy29mpdMs/GG2nlr+HpoQkgf/bSy98iXJI2Up+EFdKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YgEAoIq2d/GVlR0yuaFa0H2/C3On0XsY7oDSYUSJ8p8=;
 b=Gvph/Nbscw3M384b7GUOLJabrUW9lvPxF356iqT7yqWLtHlOQXaTeoOxL6x75A9TNyJERfANokv2KXTB0aVZJ4QNdRNwywpHsQV0Q5xjQLde5qD9Za3oNt5/4oOlCLxOEPfWUZiqNF4vBbbOtPUeNIL54W4b8DphTUg4mpc2TiY3EkvAj5MpX+AiRpXvGHwMuaGCp9I+8cl8CGd4bfbBgCCre2oSzApuWSrCdRYFplJSVJ0LHa/btF/9/5NQ70J8mO1sSbboX8xhCIXvOJaBCjfG+MArVBbSiiaZBRXdHojsNl59ucFtz2aSSCxv6lAcbjvdcQP/NAUlBT9Uh1TDWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YgEAoIq2d/GVlR0yuaFa0H2/C3On0XsY7oDSYUSJ8p8=;
 b=jqZHvjDO63jPK12W7V0jEHdUI1ai6ORslNszQCbvqS1ZjHPejIjW+Ts7lSFoVIwTSpRpOCFX+Z/Zl2F1VoDafROiwXykyZAz3KBnVQZP2PmxJEtugBK+8nMVb1jTSzCKfo4y1YE84NlPiTBce8/Rh4uIDydkttsN0evqoJxCnc4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:123::23)
 by VI1P190MB0064.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:a1::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22; Tue, 30 Nov
 2021 10:34:16 +0000
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::e15a:32ff:b93c:d136]) by VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::e15a:32ff:b93c:d136%4]) with mapi id 15.20.4734.024; Tue, 30 Nov 2021
 10:34:15 +0000
From:   Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Cc:     Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org,
        Yevhen Orlov <yevhen.orlov@plvision.eu>
Subject: [PATCH net-next v2 1/3] net: prestera: acl: migrate to new vTCAM api
Date:   Tue, 30 Nov 2021 12:32:58 +0200
Message-Id: <1638268383-8498-2-git-send-email-volodymyr.mytnyk@plvision.eu>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1638268383-8498-1-git-send-email-volodymyr.mytnyk@plvision.eu>
References: <1638268383-8498-1-git-send-email-volodymyr.mytnyk@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: AS8P251CA0008.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:2f2::26) To VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:800:123::23)
MIME-Version: 1.0
Received: from vmytnykub.x.ow.s (217.20.186.93) by AS8P251CA0008.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:2f2::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4734.21 via Frontend Transport; Tue, 30 Nov 2021 10:34:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a9f3412a-82ae-4a88-e69e-08d9b3ecf498
X-MS-TrafficTypeDiagnostic: VI1P190MB0064:
X-Microsoft-Antispam-PRVS: <VI1P190MB00648839E66FB75DCA7FB36F8F679@VI1P190MB0064.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oqwDpZhgVUVDEwGtznlUsX80tep+zAc+dnJcL5Wn9tXVRRIr6q4E9u9b78Pbiq6kX/ab8DucWzwr+ar2hLrjM0cXSZnQ9lYBXYsD1EwcrVUqU+g0zbKNgAnnTdawTCjlzyP4AErfrVxPOtHhSrqZ0mzrsN4WLpCCWjQEa0YrKbhfkXg3BSc2AavvGGz0BNFfrA+X/ySI/pWgtxJvqOnX/PzcTi6weommXTJsmY7uWg4R20wgBmscMfjvrWgB55F+R+ScpRlbx5SKKSp1Wn0+fuluEwSYR5m7XYrWv8VRMGVOTKYSptc67f/B2tz5rNQ/9pcxii5nbA22IcV6OXnKrR8T82QmGZTBuYdkK7mlJCcPNlE5nBIVjfC1D4fS2srpuga2PfoCSpLGCapl4xJykk49Eg3v+6mzA8UHLXQ9ZVoWWDFCQzsmgc1sMwBnSrKDtXKGHcOQmtHvqtli/bbYgRzQFyf+7LDr2MV8SaZIAex0Z09WA62JD1jOM9EBVcSeBgKlgUOuvsyK1lmTPucm/xgPTHdC0Wp1KRnyyyoxVf8t6eBsG3MevaIp+hmW+F18cZN79EeUTDNkaobP6cRXRcd9OYTgJjvHN5MbElNvNHKJcPYc92pDLvAUkTx15ckW4NtRYrEw7ehWH8hLJuVZ0u02XEKLq/jX5sznkTYC7QHRWTHOtn9CptX2nOqLTTPN80VrE6psBAcdMryAjwb5MA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0734.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(346002)(376002)(396003)(366004)(39830400003)(186003)(107886003)(83380400001)(36756003)(38100700002)(6666004)(8936002)(38350700002)(26005)(2906002)(52116002)(316002)(86362001)(44832011)(6916009)(66946007)(6486002)(508600001)(6512007)(8676002)(5660300002)(66476007)(2616005)(4326008)(6506007)(956004)(54906003)(30864003)(66556008)(579004)(559001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Xbuhz7rn5UNPxopPMqPUeXg+Aj5iqDXAH3wBW6mYQsQK+0WoY1QOOKPoKFEi?=
 =?us-ascii?Q?Gv6D4GrdOdMp9v0BEzSz5JQmhSVIBU+izSILHnHTY/HmVjRT7fSaPx3AACMu?=
 =?us-ascii?Q?KPqEMp5Plf+HQX7Wmqjv7qopYbBBrq00TCO5XQ6WeCzTbQDu4747z3DAIood?=
 =?us-ascii?Q?RaH4Gwi5O/i75QD+oRsZ+P7PX/B05bOG1KAgE3DrYj6pFYaereyUX6pXRGj+?=
 =?us-ascii?Q?6rijDSJz/3yJc0Eb8P/HQK0wo0gTfTIs6yynirxU9xC0VIi2qHBDjhJx7/me?=
 =?us-ascii?Q?2IQlR7lNGyvM+CunABsZrCIcBg3BXrvyCeLPbXhdx0/jAiH6rZSeury8BhXi?=
 =?us-ascii?Q?jkWo6n4MKefEId4NGDY0gGsrSvHEHcZTRDh4IzfA8AOtCxf0wS85s8Q3JkKa?=
 =?us-ascii?Q?17vNomEAFb64JkXg2ZtICS9Z5Gp63rf/6uzZykLYVMcau3R0kTfYb3CRCN2G?=
 =?us-ascii?Q?6sq6wnBIAE9oPU4A2QndigvgNNhhfHGalwGPqvxD/6FTyfjA5vI0Rg1ulnG4?=
 =?us-ascii?Q?Q0xsak+4LO8fz/xcVArtU76X59t1w/89uJoxhXOwfLXubhRYUbZRwc2UUcMN?=
 =?us-ascii?Q?wCzMZejLM+YQCBI8oJ0PWs38oQ8SAG88JaCc3jX06sWA+rBkQYc75sh78VaP?=
 =?us-ascii?Q?it2sEf5wQPNjUPh1IA+LhS9YTE6ZvvEhNFj1sHkSU04rTPfyVwprzLxMJmT6?=
 =?us-ascii?Q?vV4yaj0tFJnk4FrkdHbDNSUxsC2If+jkDJ1GgCqIspZAY3u+83zvcZFye4dK?=
 =?us-ascii?Q?RsT4gJ3oEUHYpmDQuSUKUtmPPnI/fFtod38wEy5DSfij1TEn+mKXOqZC/MLj?=
 =?us-ascii?Q?p0iLQ3HT3StXpiIAK+pn6f1dI28+SNdVq0ny77gh1hFXF77XGfdlIVkm0Ncj?=
 =?us-ascii?Q?STfOMRyMszZFJh3HOC7WBha/ioEPGrZ2qWizhY8bBTHmnun0EOu1WBGHWLJ6?=
 =?us-ascii?Q?nZHcn1ay5Fm4o9y01llMU5u2IJV9fGvKv/bHcp/YWoNObUqY7iXBIgtWmtsm?=
 =?us-ascii?Q?CpxVDa6Lbf8PUf1A1UuyCFc9MmCtnGeYn60zKBPF4ETxfSiPN5AqNXQoDbwX?=
 =?us-ascii?Q?tW4djKMw1Y/n2kHM5bF++uX5UR982vHBLl0Ptow9T8mTYcUrMR8PO9K9vmEz?=
 =?us-ascii?Q?0mtsN+07UJmeQxWH4MM79B9rW/3u+0kozhKMthPCMdxn7vmW9rqPK037CjXW?=
 =?us-ascii?Q?o3dfAKhw29a/UZvP8ehuUgwlHsD/k1NJCGTFCy4qElGL4DB25EXBLeMQESYp?=
 =?us-ascii?Q?mKwpPSjqKXL2ysLC4E9jrKyTjQZpRaRdJCV21zW8m9kl/Q+TzcyfC1jE6aZT?=
 =?us-ascii?Q?4lSaf3ZjIQOt7xAD48ps9magGrN/l//ZTAF8aSGLuRwiTP9uIMfZb9AmI23H?=
 =?us-ascii?Q?7nVfHyIdycHeSfIrYu7gxC/XdrGrazEgBIy6vQ+i+I2eLUArXGaa6D+2Rvux?=
 =?us-ascii?Q?rjxXI/7vW5MDctGBf5z8OUye49lqi/wNJ+IDyVDMBRFXBeNbQDEmplK6iwUW?=
 =?us-ascii?Q?if+gm53RN/QdP0vkPQWcRCAwrz9jwbKtva39RhnyWXI7JqNXl8P2WLiBeSjK?=
 =?us-ascii?Q?YwsNFtXp2ORohlAlBTTlYi+BjDBCuRUUkBnPbyONhMTYUimhK1H7qP7XMP3w?=
 =?us-ascii?Q?4vPifZPcykRHuYBTNE3JfZbHF8pBZ5uP2YhcIs8FLnCtxaF+B4d7c6lDqXlQ?=
 =?us-ascii?Q?j49Gyw=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: a9f3412a-82ae-4a88-e69e-08d9b3ecf498
X-MS-Exchange-CrossTenant-AuthSource: VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2021 10:34:15.0973
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oC+tavOeN25jXTRdirbubIDtMp6AJDv0NmgB+7e0MhFQIH9dZp1vL1+7iqwMqeYkQfep0WweoP1GMrg4wgxoaGB1FVpqGeEHpYhtTJvzEKg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0064
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Volodymyr Mytnyk <vmytnyk@marvell.com>

- Add new vTCAM HW API to configure HW ACLs.
- Migrate acl to use new vTCAM HW API.
- No counter support in this patch-set.

Co-developed-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
Signed-off-by: Volodymyr Mytnyk <vmytnyk@marvell.com>
---

Changes in V2:

- fix structure laid out
- remove unused prestera_acl_ruleset_keymask_set
- remove inline in the source code
- remove unused prestera_acl_uid_entry structure
- get rid of prestera_switch arg in prestera_flower_* apis

 .../net/ethernet/marvell/prestera/prestera_acl.c   | 640 +++++++++++++++------
 .../net/ethernet/marvell/prestera/prestera_acl.h   | 201 ++++---
 .../net/ethernet/marvell/prestera/prestera_flow.c  | 101 +++-
 .../net/ethernet/marvell/prestera/prestera_flow.h  |  16 +
 .../ethernet/marvell/prestera/prestera_flower.c    | 283 +++++----
 .../ethernet/marvell/prestera/prestera_flower.h    |   3 +-
 .../net/ethernet/marvell/prestera/prestera_hw.c    | 361 +++++-------
 .../net/ethernet/marvell/prestera/prestera_hw.h    |  41 +-
 .../net/ethernet/marvell/prestera/prestera_span.c  |   1 +
 9 files changed, 985 insertions(+), 662 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_acl.c b/drivers/net/ethernet/marvell/prestera/prestera_acl.c
index 83c75ffb1a1c..bfa83c5abd16 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_acl.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_acl.c
@@ -1,35 +1,68 @@
 // SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
-/* Copyright (c) 2020 Marvell International Ltd. All rights reserved */
+/* Copyright (c) 2020-2021 Marvell International Ltd. All rights reserved */
 
 #include <linux/rhashtable.h>
 
-#include "prestera.h"
-#include "prestera_hw.h"
 #include "prestera_acl.h"
-#include "prestera_span.h"
+#include "prestera_flow.h"
+#include "prestera_hw.h"
+#include "prestera.h"
+
+#define ACL_KEYMASK_SIZE	\
+	(sizeof(__be32) * __PRESTERA_ACL_RULE_MATCH_TYPE_MAX)
 
 struct prestera_acl {
 	struct prestera_switch *sw;
+	struct list_head vtcam_list;
 	struct list_head rules;
+	struct rhashtable ruleset_ht;
+	struct rhashtable acl_rule_entry_ht;
+	struct idr uid;
+};
+
+struct prestera_acl_ruleset_ht_key {
+	struct prestera_flow_block *block;
+};
+
+struct prestera_acl_rule_entry {
+	struct rhash_head ht_node;
+	struct prestera_acl_rule_entry_key key;
+	u32 hw_id;
+	u32 vtcam_id;
+	struct {
+		struct {
+			u8 valid:1;
+		} accept, drop, trap;
+	};
 };
 
 struct prestera_acl_ruleset {
+	struct rhash_head ht_node; /* Member of acl HT */
+	struct prestera_acl_ruleset_ht_key ht_key;
 	struct rhashtable rule_ht;
-	struct prestera_switch *sw;
-	u16 id;
+	struct prestera_acl *acl;
+	unsigned long rule_count;
+	refcount_t refcount;
+	void *keymask;
+	u32 vtcam_id;
+	u16 pcl_id;
+	bool offload;
 };
 
-struct prestera_acl_rule {
-	struct rhash_head ht_node;
+struct prestera_acl_vtcam {
 	struct list_head list;
-	struct list_head match_list;
-	struct list_head action_list;
-	struct prestera_flow_block *block;
-	unsigned long cookie;
-	u32 priority;
-	u8 n_actions;
-	u8 n_matches;
+	__be32 keymask[__PRESTERA_ACL_RULE_MATCH_TYPE_MAX];
+	refcount_t refcount;
 	u32 id;
+	bool is_keymask_set;
+	u8 lookup;
+};
+
+static const struct rhashtable_params prestera_acl_ruleset_ht_params = {
+	.key_len = sizeof(struct prestera_acl_ruleset_ht_key),
+	.key_offset = offsetof(struct prestera_acl_ruleset, ht_key),
+	.head_offset = offsetof(struct prestera_acl_ruleset, ht_node),
+	.automatic_shrinking = true,
 };
 
 static const struct rhashtable_params prestera_acl_rule_ht_params = {
@@ -39,28 +72,48 @@ static const struct rhashtable_params prestera_acl_rule_ht_params = {
 	.automatic_shrinking = true,
 };
 
+static const struct rhashtable_params __prestera_acl_rule_entry_ht_params = {
+	.key_offset  = offsetof(struct prestera_acl_rule_entry, key),
+	.head_offset = offsetof(struct prestera_acl_rule_entry, ht_node),
+	.key_len     = sizeof(struct prestera_acl_rule_entry_key),
+	.automatic_shrinking = true,
+};
+
 static struct prestera_acl_ruleset *
-prestera_acl_ruleset_create(struct prestera_switch *sw)
+prestera_acl_ruleset_create(struct prestera_acl *acl,
+			    struct prestera_flow_block *block)
 {
 	struct prestera_acl_ruleset *ruleset;
 	int err;
+	u32 uid;
 
 	ruleset = kzalloc(sizeof(*ruleset), GFP_KERNEL);
 	if (!ruleset)
 		return ERR_PTR(-ENOMEM);
 
+	ruleset->acl = acl;
+	ruleset->ht_key.block = block;
+	refcount_set(&ruleset->refcount, 1);
+
 	err = rhashtable_init(&ruleset->rule_ht, &prestera_acl_rule_ht_params);
 	if (err)
 		goto err_rhashtable_init;
 
-	err = prestera_hw_acl_ruleset_create(sw, &ruleset->id);
+	err = idr_alloc_u32(&acl->uid, NULL, &uid, U8_MAX, GFP_KERNEL);
 	if (err)
 		goto err_ruleset_create;
 
-	ruleset->sw = sw;
+	/* make pcl-id based on uid */
+	ruleset->pcl_id = (u8)uid;
+	err = rhashtable_insert_fast(&acl->ruleset_ht, &ruleset->ht_node,
+				     prestera_acl_ruleset_ht_params);
+	if (err)
+		goto err_ruleset_ht_insert;
 
 	return ruleset;
 
+err_ruleset_ht_insert:
+	idr_remove(&acl->uid, uid);
 err_ruleset_create:
 	rhashtable_destroy(&ruleset->rule_ht);
 err_rhashtable_init:
@@ -68,117 +121,158 @@ prestera_acl_ruleset_create(struct prestera_switch *sw)
 	return ERR_PTR(err);
 }
 
+int prestera_acl_ruleset_offload(struct prestera_acl_ruleset *ruleset)
+{
+	u32 vtcam_id;
+	int err;
+
+	if (ruleset->offload)
+		return -EEXIST;
+
+	err = prestera_acl_vtcam_id_get(ruleset->acl, 0,
+					ruleset->keymask, &vtcam_id);
+	if (err)
+		return err;
+
+	ruleset->vtcam_id = vtcam_id;
+	ruleset->offload = true;
+	return 0;
+}
+
 static void prestera_acl_ruleset_destroy(struct prestera_acl_ruleset *ruleset)
 {
-	prestera_hw_acl_ruleset_del(ruleset->sw, ruleset->id);
+	struct prestera_acl *acl = ruleset->acl;
+	u8 uid = ruleset->pcl_id & PRESTERA_ACL_KEYMASK_PCL_ID_USER;
+
+	rhashtable_remove_fast(&acl->ruleset_ht, &ruleset->ht_node,
+			       prestera_acl_ruleset_ht_params);
+
+	if (ruleset->offload)
+		WARN_ON(prestera_acl_vtcam_id_put(acl, ruleset->vtcam_id));
+
+	idr_remove(&acl->uid, uid);
+
 	rhashtable_destroy(&ruleset->rule_ht);
+	kfree(ruleset->keymask);
 	kfree(ruleset);
 }
 
-struct prestera_flow_block *
-prestera_acl_block_create(struct prestera_switch *sw, struct net *net)
+static struct prestera_acl_ruleset *
+__prestera_acl_ruleset_lookup(struct prestera_acl *acl,
+			      struct prestera_flow_block *block)
 {
-	struct prestera_flow_block *block;
-
-	block = kzalloc(sizeof(*block), GFP_KERNEL);
-	if (!block)
-		return NULL;
-	INIT_LIST_HEAD(&block->binding_list);
-	block->net = net;
-	block->sw = sw;
-
-	block->ruleset = prestera_acl_ruleset_create(sw);
-	if (IS_ERR(block->ruleset)) {
-		kfree(block);
-		return NULL;
-	}
+	struct prestera_acl_ruleset_ht_key ht_key;
 
-	return block;
+	memset(&ht_key, 0, sizeof(ht_key));
+	ht_key.block = block;
+	return rhashtable_lookup_fast(&acl->ruleset_ht, &ht_key,
+				      prestera_acl_ruleset_ht_params);
 }
 
-void prestera_acl_block_destroy(struct prestera_flow_block *block)
+struct prestera_acl_ruleset *
+prestera_acl_ruleset_lookup(struct prestera_acl *acl,
+			    struct prestera_flow_block *block)
 {
-	prestera_acl_ruleset_destroy(block->ruleset);
-	WARN_ON(!list_empty(&block->binding_list));
-	kfree(block);
+	struct prestera_acl_ruleset *ruleset;
+
+	ruleset = __prestera_acl_ruleset_lookup(acl, block);
+	if (!ruleset)
+		return ERR_PTR(-ENOENT);
+
+	refcount_inc(&ruleset->refcount);
+	return ruleset;
 }
 
-static struct prestera_flow_block_binding *
-prestera_acl_block_lookup(struct prestera_flow_block *block,
-			  struct prestera_port *port)
+struct prestera_acl_ruleset *
+prestera_acl_ruleset_get(struct prestera_acl *acl,
+			 struct prestera_flow_block *block)
 {
-	struct prestera_flow_block_binding *binding;
+	struct prestera_acl_ruleset *ruleset;
 
-	list_for_each_entry(binding, &block->binding_list, list)
-		if (binding->port == port)
-			return binding;
+	ruleset = __prestera_acl_ruleset_lookup(acl, block);
+	if (ruleset) {
+		refcount_inc(&ruleset->refcount);
+		return ruleset;
+	}
 
-	return NULL;
+	return prestera_acl_ruleset_create(acl, block);
 }
 
-int prestera_acl_block_bind(struct prestera_flow_block *block,
-			    struct prestera_port *port)
+void prestera_acl_ruleset_put(struct prestera_acl_ruleset *ruleset)
 {
-	struct prestera_flow_block_binding *binding;
-	int err;
+	if (!refcount_dec_and_test(&ruleset->refcount))
+		return;
 
-	if (WARN_ON(prestera_acl_block_lookup(block, port)))
-		return -EEXIST;
+	prestera_acl_ruleset_destroy(ruleset);
+}
 
-	binding = kzalloc(sizeof(*binding), GFP_KERNEL);
-	if (!binding)
-		return -ENOMEM;
-	binding->span_id = PRESTERA_SPAN_INVALID_ID;
-	binding->port = port;
+int prestera_acl_ruleset_bind(struct prestera_acl_ruleset *ruleset,
+			      struct prestera_port *port)
+{
+	struct prestera_acl_iface iface = {
+		.type = PRESTERA_ACL_IFACE_TYPE_PORT,
+		.port = port
+	};
 
-	err = prestera_hw_acl_port_bind(port, block->ruleset->id);
-	if (err)
-		goto err_rules_bind;
+	return prestera_hw_vtcam_iface_bind(port->sw, &iface, ruleset->vtcam_id,
+					    ruleset->pcl_id);
+}
 
-	list_add(&binding->list, &block->binding_list);
-	return 0;
+int prestera_acl_ruleset_unbind(struct prestera_acl_ruleset *ruleset,
+				struct prestera_port *port)
+{
+	struct prestera_acl_iface iface = {
+		.type = PRESTERA_ACL_IFACE_TYPE_PORT,
+		.port = port
+	};
 
-err_rules_bind:
-	kfree(binding);
-	return err;
+	return prestera_hw_vtcam_iface_unbind(port->sw, &iface,
+					      ruleset->vtcam_id);
 }
 
-int prestera_acl_block_unbind(struct prestera_flow_block *block,
-			      struct prestera_port *port)
+static int prestera_acl_ruleset_block_bind(struct prestera_acl_ruleset *ruleset,
+					   struct prestera_flow_block *block)
 {
 	struct prestera_flow_block_binding *binding;
+	int err;
 
-	binding = prestera_acl_block_lookup(block, port);
-	if (!binding)
-		return -ENOENT;
-
-	list_del(&binding->list);
+	block->ruleset_zero = ruleset;
+	list_for_each_entry(binding, &block->binding_list, list) {
+		err = prestera_acl_ruleset_bind(ruleset, binding->port);
+		if (err)
+			goto rollback;
+	}
+	return 0;
 
-	prestera_hw_acl_port_unbind(port, block->ruleset->id);
+rollback:
+	list_for_each_entry_continue_reverse(binding, &block->binding_list,
+					     list)
+		err = prestera_acl_ruleset_unbind(ruleset, binding->port);
+	block->ruleset_zero = NULL;
 
-	kfree(binding);
-	return 0;
+	return err;
 }
 
-struct prestera_acl_ruleset *
-prestera_acl_block_ruleset_get(struct prestera_flow_block *block)
+static void
+prestera_acl_ruleset_block_unbind(struct prestera_acl_ruleset *ruleset,
+				  struct prestera_flow_block *block)
 {
-	return block->ruleset;
-}
+	struct prestera_flow_block_binding *binding;
 
-u16 prestera_acl_rule_ruleset_id_get(const struct prestera_acl_rule *rule)
-{
-	return rule->block->ruleset->id;
+	list_for_each_entry(binding, &block->binding_list, list)
+		prestera_acl_ruleset_unbind(ruleset, binding->port);
+	block->ruleset_zero = NULL;
 }
 
-struct net *prestera_acl_block_net(struct prestera_flow_block *block)
+void
+prestera_acl_rule_keymask_pcl_id_set(struct prestera_acl_rule *rule, u16 pcl_id)
 {
-	return block->net;
-}
+	struct prestera_acl_match *r_match = &rule->re_key.match;
+	__be16 pcl_id_mask = htons(PRESTERA_ACL_KEYMASK_PCL_ID);
+	__be16 pcl_id_key = htons(pcl_id);
 
-struct prestera_switch *prestera_acl_block_sw(struct prestera_flow_block *block)
-{
-	return block->sw;
+	rule_match_set(r_match->key, PCL_ID, pcl_id_key);
+	rule_match_set(r_match->mask, PCL_ID, pcl_id_mask);
 }
 
 struct prestera_acl_rule *
@@ -189,8 +283,13 @@ prestera_acl_rule_lookup(struct prestera_acl_ruleset *ruleset,
 				      prestera_acl_rule_ht_params);
 }
 
+bool prestera_acl_ruleset_is_offload(struct prestera_acl_ruleset *ruleset)
+{
+	return ruleset->offload;
+}
+
 struct prestera_acl_rule *
-prestera_acl_rule_create(struct prestera_flow_block *block,
+prestera_acl_rule_create(struct prestera_acl_ruleset *ruleset,
 			 unsigned long cookie)
 {
 	struct prestera_acl_rule *rule;
@@ -199,178 +298,353 @@ prestera_acl_rule_create(struct prestera_flow_block *block,
 	if (!rule)
 		return ERR_PTR(-ENOMEM);
 
-	INIT_LIST_HEAD(&rule->match_list);
-	INIT_LIST_HEAD(&rule->action_list);
+	rule->ruleset = ruleset;
 	rule->cookie = cookie;
-	rule->block = block;
+
+	refcount_inc(&ruleset->refcount);
 
 	return rule;
 }
 
-struct list_head *
-prestera_acl_rule_match_list_get(struct prestera_acl_rule *rule)
+void prestera_acl_rule_priority_set(struct prestera_acl_rule *rule,
+				    u32 priority)
 {
-	return &rule->match_list;
+	rule->priority = priority;
 }
 
-struct list_head *
-prestera_acl_rule_action_list_get(struct prestera_acl_rule *rule)
+void prestera_acl_rule_destroy(struct prestera_acl_rule *rule)
 {
-	return &rule->action_list;
+	prestera_acl_ruleset_put(rule->ruleset);
+	kfree(rule);
 }
 
-int prestera_acl_rule_action_add(struct prestera_acl_rule *rule,
-				 struct prestera_acl_rule_action_entry *entry)
+int prestera_acl_rule_add(struct prestera_switch *sw,
+			  struct prestera_acl_rule *rule)
 {
-	struct prestera_acl_rule_action_entry *a_entry;
+	int err;
+	struct prestera_acl_ruleset *ruleset = rule->ruleset;
+	struct prestera_flow_block *block = ruleset->ht_key.block;
 
-	a_entry = kmalloc(sizeof(*a_entry), GFP_KERNEL);
-	if (!a_entry)
-		return -ENOMEM;
+	/* try to add rule to hash table first */
+	err = rhashtable_insert_fast(&ruleset->rule_ht, &rule->ht_node,
+				     prestera_acl_rule_ht_params);
+	if (err)
+		goto err_ht_insert;
 
-	memcpy(a_entry, entry, sizeof(*entry));
-	list_add(&a_entry->list, &rule->action_list);
+	prestera_acl_rule_keymask_pcl_id_set(rule, ruleset->pcl_id);
+	rule->re_arg.vtcam_id = ruleset->vtcam_id;
+	rule->re_key.prio = rule->priority;
+
+	rule->re = prestera_acl_rule_entry_find(sw->acl, &rule->re_key);
+	err = WARN_ON(rule->re) ? -EEXIST : 0;
+	if (err)
+		goto err_rule_add;
 
-	rule->n_actions++;
+	rule->re = prestera_acl_rule_entry_create(sw->acl, &rule->re_key,
+						  &rule->re_arg);
+	err = !rule->re ? -EINVAL : 0;
+	if (err)
+		goto err_rule_add;
+
+	/* bind the block (all ports) to chain index 0 */
+	if (!ruleset->rule_count) {
+		err = prestera_acl_ruleset_block_bind(ruleset, block);
+		if (err)
+			goto err_acl_block_bind;
+	}
+
+	list_add_tail(&rule->list, &sw->acl->rules);
+	ruleset->rule_count++;
 	return 0;
+
+err_acl_block_bind:
+	prestera_acl_rule_entry_destroy(sw->acl, rule->re);
+err_rule_add:
+	rule->re = NULL;
+	rhashtable_remove_fast(&ruleset->rule_ht, &rule->ht_node,
+			       prestera_acl_rule_ht_params);
+err_ht_insert:
+	return err;
 }
 
-u8 prestera_acl_rule_action_len(struct prestera_acl_rule *rule)
+void prestera_acl_rule_del(struct prestera_switch *sw,
+			   struct prestera_acl_rule *rule)
 {
-	return rule->n_actions;
+	struct prestera_acl_ruleset *ruleset = rule->ruleset;
+	struct prestera_flow_block *block = ruleset->ht_key.block;
+
+	rhashtable_remove_fast(&ruleset->rule_ht, &rule->ht_node,
+			       prestera_acl_rule_ht_params);
+	ruleset->rule_count--;
+	list_del(&rule->list);
+
+	prestera_acl_rule_entry_destroy(sw->acl, rule->re);
+
+	/* unbind block (all ports) */
+	if (!ruleset->rule_count)
+		prestera_acl_ruleset_block_unbind(ruleset, block);
 }
 
-u32 prestera_acl_rule_priority_get(struct prestera_acl_rule *rule)
+int prestera_acl_rule_get_stats(struct prestera_acl *acl,
+				struct prestera_acl_rule *rule,
+				u64 *packets, u64 *bytes, u64 *last_use)
 {
-	return rule->priority;
+	*last_use = jiffies;
+	*packets = 0;
+	*bytes = 0;
+
+	return 0;
 }
 
-void prestera_acl_rule_priority_set(struct prestera_acl_rule *rule,
-				    u32 priority)
+struct prestera_acl_rule_entry *
+prestera_acl_rule_entry_find(struct prestera_acl *acl,
+			     struct prestera_acl_rule_entry_key *key)
 {
-	rule->priority = priority;
+	struct prestera_acl_rule_entry *e;
+
+	e = rhashtable_lookup_fast(&acl->acl_rule_entry_ht, key,
+				   __prestera_acl_rule_entry_ht_params);
+	return IS_ERR(e) ? NULL : e;
 }
 
-int prestera_acl_rule_match_add(struct prestera_acl_rule *rule,
-				struct prestera_acl_rule_match_entry *entry)
+static int __prestera_acl_rule_entry2hw_del(struct prestera_switch *sw,
+					    struct prestera_acl_rule_entry *e)
 {
-	struct prestera_acl_rule_match_entry *m_entry;
+	return prestera_hw_vtcam_rule_del(sw, e->vtcam_id, e->hw_id);
+}
 
-	m_entry = kmalloc(sizeof(*m_entry), GFP_KERNEL);
-	if (!m_entry)
-		return -ENOMEM;
+static int __prestera_acl_rule_entry2hw_add(struct prestera_switch *sw,
+					    struct prestera_acl_rule_entry *e)
+{
+	struct prestera_acl_hw_action_info act_hw[PRESTERA_ACL_RULE_ACTION_MAX];
+	int act_num;
 
-	memcpy(m_entry, entry, sizeof(*entry));
-	list_add(&m_entry->list, &rule->match_list);
+	memset(&act_hw, 0, sizeof(act_hw));
+	act_num = 0;
 
-	rule->n_matches++;
-	return 0;
+	/* accept */
+	if (e->accept.valid) {
+		act_hw[act_num].id = PRESTERA_ACL_RULE_ACTION_ACCEPT;
+		act_num++;
+	}
+	/* drop */
+	if (e->drop.valid) {
+		act_hw[act_num].id = PRESTERA_ACL_RULE_ACTION_DROP;
+		act_num++;
+	}
+	/* trap */
+	if (e->trap.valid) {
+		act_hw[act_num].id = PRESTERA_ACL_RULE_ACTION_TRAP;
+		act_num++;
+	}
+
+	return prestera_hw_vtcam_rule_add(sw, e->vtcam_id, e->key.prio,
+					  e->key.match.key, e->key.match.mask,
+					  act_hw, act_num, &e->hw_id);
 }
 
-u8 prestera_acl_rule_match_len(struct prestera_acl_rule *rule)
+static void
+__prestera_acl_rule_entry_act_destruct(struct prestera_switch *sw,
+				       struct prestera_acl_rule_entry *e)
 {
-	return rule->n_matches;
+	/* destroy action entry */
 }
 
-void prestera_acl_rule_destroy(struct prestera_acl_rule *rule)
+void prestera_acl_rule_entry_destroy(struct prestera_acl *acl,
+				     struct prestera_acl_rule_entry *e)
 {
-	struct prestera_acl_rule_action_entry *a_entry;
-	struct prestera_acl_rule_match_entry *m_entry;
-	struct list_head *pos, *n;
-
-	list_for_each_safe(pos, n, &rule->match_list) {
-		m_entry = list_entry(pos, typeof(*m_entry), list);
-		list_del(pos);
-		kfree(m_entry);
-	}
+	int ret;
 
-	list_for_each_safe(pos, n, &rule->action_list) {
-		a_entry = list_entry(pos, typeof(*a_entry), list);
-		list_del(pos);
-		kfree(a_entry);
-	}
+	rhashtable_remove_fast(&acl->acl_rule_entry_ht, &e->ht_node,
+			       __prestera_acl_rule_entry_ht_params);
 
-	kfree(rule);
+	ret = __prestera_acl_rule_entry2hw_del(acl->sw, e);
+	WARN_ON(ret && ret != -ENODEV);
+
+	__prestera_acl_rule_entry_act_destruct(acl->sw, e);
+	kfree(e);
 }
 
-int prestera_acl_rule_add(struct prestera_switch *sw,
-			  struct prestera_acl_rule *rule)
+static int
+__prestera_acl_rule_entry_act_construct(struct prestera_switch *sw,
+					struct prestera_acl_rule_entry *e,
+					struct prestera_acl_rule_entry_arg *arg)
+{
+	/* accept */
+	e->accept.valid = arg->accept.valid;
+	/* drop */
+	e->drop.valid = arg->drop.valid;
+	/* trap */
+	e->trap.valid = arg->trap.valid;
+
+	return 0;
+}
+
+struct prestera_acl_rule_entry *
+prestera_acl_rule_entry_create(struct prestera_acl *acl,
+			       struct prestera_acl_rule_entry_key *key,
+			       struct prestera_acl_rule_entry_arg *arg)
 {
-	u32 rule_id;
+	struct prestera_acl_rule_entry *e;
 	int err;
 
-	/* try to add rule to hash table first */
-	err = rhashtable_insert_fast(&rule->block->ruleset->rule_ht,
-				     &rule->ht_node,
-				     prestera_acl_rule_ht_params);
-	if (err)
-		return err;
+	e = kzalloc(sizeof(*e), GFP_KERNEL);
+	if (!e)
+		goto err_kzalloc;
 
-	/* add rule to hw */
-	err = prestera_hw_acl_rule_add(sw, rule, &rule_id);
+	memcpy(&e->key, key, sizeof(*key));
+	e->vtcam_id = arg->vtcam_id;
+	err = __prestera_acl_rule_entry_act_construct(acl->sw, e, arg);
 	if (err)
-		goto err_rule_add;
+		goto err_act_construct;
 
-	rule->id = rule_id;
+	err = __prestera_acl_rule_entry2hw_add(acl->sw, e);
+	if (err)
+		goto err_hw_add;
 
-	list_add_tail(&rule->list, &sw->acl->rules);
+	err = rhashtable_insert_fast(&acl->acl_rule_entry_ht, &e->ht_node,
+				     __prestera_acl_rule_entry_ht_params);
+	if (err)
+		goto err_ht_insert;
 
-	return 0;
+	return e;
 
-err_rule_add:
-	rhashtable_remove_fast(&rule->block->ruleset->rule_ht, &rule->ht_node,
-			       prestera_acl_rule_ht_params);
-	return err;
+err_ht_insert:
+	WARN_ON(__prestera_acl_rule_entry2hw_del(acl->sw, e));
+err_hw_add:
+	__prestera_acl_rule_entry_act_destruct(acl->sw, e);
+err_act_construct:
+	kfree(e);
+err_kzalloc:
+	return NULL;
 }
 
-void prestera_acl_rule_del(struct prestera_switch *sw,
-			   struct prestera_acl_rule *rule)
+int prestera_acl_vtcam_id_get(struct prestera_acl *acl, u8 lookup,
+			      void *keymask, u32 *vtcam_id)
 {
-	rhashtable_remove_fast(&rule->block->ruleset->rule_ht, &rule->ht_node,
-			       prestera_acl_rule_ht_params);
-	list_del(&rule->list);
-	prestera_hw_acl_rule_del(sw, rule->id);
+	struct prestera_acl_vtcam *vtcam;
+	u32 new_vtcam_id;
+	int err;
+
+	/* find the vtcam that suits keymask. We do not expect to have
+	 * a big number of vtcams, so, the list type for vtcam list is
+	 * fine for now
+	 */
+	list_for_each_entry(vtcam, &acl->vtcam_list, list) {
+		if (lookup != vtcam->lookup)
+			continue;
+
+		if (!keymask && !vtcam->is_keymask_set) {
+			refcount_inc(&vtcam->refcount);
+			goto vtcam_found;
+		}
+
+		if (keymask && vtcam->is_keymask_set &&
+		    !memcmp(keymask, vtcam->keymask, sizeof(vtcam->keymask))) {
+			refcount_inc(&vtcam->refcount);
+			goto vtcam_found;
+		}
+	}
+
+	/* vtcam not found, try to create new one */
+	vtcam = kzalloc(sizeof(*vtcam), GFP_KERNEL);
+	if (!vtcam)
+		return -ENOMEM;
+
+	err = prestera_hw_vtcam_create(acl->sw, lookup, keymask, &new_vtcam_id,
+				       PRESTERA_HW_VTCAM_DIR_INGRESS);
+	if (err) {
+		kfree(vtcam);
+		return err;
+	}
+
+	vtcam->id = new_vtcam_id;
+	vtcam->lookup = lookup;
+	if (keymask) {
+		memcpy(vtcam->keymask, keymask, sizeof(vtcam->keymask));
+		vtcam->is_keymask_set = true;
+	}
+	refcount_set(&vtcam->refcount, 1);
+	list_add_rcu(&vtcam->list, &acl->vtcam_list);
+
+vtcam_found:
+	*vtcam_id = vtcam->id;
+	return 0;
 }
 
-int prestera_acl_rule_get_stats(struct prestera_switch *sw,
-				struct prestera_acl_rule *rule,
-				u64 *packets, u64 *bytes, u64 *last_use)
+int prestera_acl_vtcam_id_put(struct prestera_acl *acl, u32 vtcam_id)
 {
-	u64 current_packets;
-	u64 current_bytes;
+	struct prestera_acl_vtcam *vtcam;
 	int err;
 
-	err = prestera_hw_acl_rule_stats_get(sw, rule->id, &current_packets,
-					     &current_bytes);
-	if (err)
-		return err;
+	list_for_each_entry(vtcam, &acl->vtcam_list, list) {
+		if (vtcam_id != vtcam->id)
+			continue;
 
-	*packets = current_packets;
-	*bytes = current_bytes;
-	*last_use = jiffies;
+		if (!refcount_dec_and_test(&vtcam->refcount))
+			return 0;
 
-	return 0;
+		err = prestera_hw_vtcam_destroy(acl->sw, vtcam->id);
+		if (err && err != -ENODEV) {
+			refcount_set(&vtcam->refcount, 1);
+			return err;
+		}
+
+		list_del(&vtcam->list);
+		kfree(vtcam);
+		return 0;
+	}
+
+	return -ENOENT;
 }
 
 int prestera_acl_init(struct prestera_switch *sw)
 {
 	struct prestera_acl *acl;
+	int err;
 
 	acl = kzalloc(sizeof(*acl), GFP_KERNEL);
 	if (!acl)
 		return -ENOMEM;
 
+	acl->sw = sw;
 	INIT_LIST_HEAD(&acl->rules);
+	INIT_LIST_HEAD(&acl->vtcam_list);
+	idr_init(&acl->uid);
+
+	err = rhashtable_init(&acl->acl_rule_entry_ht,
+			      &__prestera_acl_rule_entry_ht_params);
+	if (err)
+		goto err_acl_rule_entry_ht_init;
+
+	err = rhashtable_init(&acl->ruleset_ht,
+			      &prestera_acl_ruleset_ht_params);
+	if (err)
+		goto err_ruleset_ht_init;
+
 	sw->acl = acl;
-	acl->sw = sw;
 
 	return 0;
+
+err_ruleset_ht_init:
+	rhashtable_destroy(&acl->acl_rule_entry_ht);
+err_acl_rule_entry_ht_init:
+	kfree(acl);
+	return err;
 }
 
 void prestera_acl_fini(struct prestera_switch *sw)
 {
 	struct prestera_acl *acl = sw->acl;
 
+	WARN_ON(!idr_is_empty(&acl->uid));
+	idr_destroy(&acl->uid);
+
+	WARN_ON(!list_empty(&acl->vtcam_list));
 	WARN_ON(!list_empty(&acl->rules));
+
+	rhashtable_destroy(&acl->ruleset_ht);
+	rhashtable_destroy(&acl->acl_rule_entry_ht);
+
 	kfree(acl);
 }
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_acl.h b/drivers/net/ethernet/marvell/prestera/prestera_acl.h
index 39b7869be659..92332eb70201 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_acl.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_acl.h
@@ -1,114 +1,118 @@
 /* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0 */
-/* Copyright (c) 2020 Marvell International Ltd. All rights reserved. */
+/* Copyright (c) 2020-2021 Marvell International Ltd. All rights reserved. */
 
 #ifndef _PRESTERA_ACL_H_
 #define _PRESTERA_ACL_H_
 
-enum prestera_acl_rule_match_entry_type {
-	PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_ETH_TYPE = 1,
-	PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_ETH_DMAC,
-	PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_ETH_SMAC,
-	PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_IP_PROTO,
-	PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_PORT,
-	PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_IP_SRC,
-	PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_IP_DST,
-	PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_L4_PORT_SRC,
-	PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_L4_PORT_DST,
-	PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_L4_PORT_RANGE_SRC,
-	PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_L4_PORT_RANGE_DST,
-	PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_VLAN_ID,
-	PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_VLAN_TPID,
-	PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_ICMP_TYPE,
-	PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_ICMP_CODE
+#include <linux/types.h>
+
+#define PRESTERA_ACL_KEYMASK_PCL_ID		0x3FF
+#define PRESTERA_ACL_KEYMASK_PCL_ID_USER			\
+	(PRESTERA_ACL_KEYMASK_PCL_ID & 0x00FF)
+
+#define rule_match_set_n(match_p, type, val_p, size)		\
+	memcpy(&(match_p)[PRESTERA_ACL_RULE_MATCH_TYPE_##type],	\
+	       val_p, size)
+#define rule_match_set(match_p, type, val)			\
+	memcpy(&(match_p)[PRESTERA_ACL_RULE_MATCH_TYPE_##type],	\
+	       &(val), sizeof(val))
+
+enum prestera_acl_match_type {
+	PRESTERA_ACL_RULE_MATCH_TYPE_PCL_ID,
+	PRESTERA_ACL_RULE_MATCH_TYPE_ETH_TYPE,
+	PRESTERA_ACL_RULE_MATCH_TYPE_ETH_DMAC_0,
+	PRESTERA_ACL_RULE_MATCH_TYPE_ETH_DMAC_1,
+	PRESTERA_ACL_RULE_MATCH_TYPE_ETH_SMAC_0,
+	PRESTERA_ACL_RULE_MATCH_TYPE_ETH_SMAC_1,
+	PRESTERA_ACL_RULE_MATCH_TYPE_IP_PROTO,
+	PRESTERA_ACL_RULE_MATCH_TYPE_SYS_PORT,
+	PRESTERA_ACL_RULE_MATCH_TYPE_SYS_DEV,
+	PRESTERA_ACL_RULE_MATCH_TYPE_IP_SRC,
+	PRESTERA_ACL_RULE_MATCH_TYPE_IP_DST,
+	PRESTERA_ACL_RULE_MATCH_TYPE_L4_PORT_SRC,
+	PRESTERA_ACL_RULE_MATCH_TYPE_L4_PORT_DST,
+	PRESTERA_ACL_RULE_MATCH_TYPE_L4_PORT_RANGE_SRC,
+	PRESTERA_ACL_RULE_MATCH_TYPE_L4_PORT_RANGE_DST,
+	PRESTERA_ACL_RULE_MATCH_TYPE_VLAN_ID,
+	PRESTERA_ACL_RULE_MATCH_TYPE_VLAN_TPID,
+	PRESTERA_ACL_RULE_MATCH_TYPE_ICMP_TYPE,
+	PRESTERA_ACL_RULE_MATCH_TYPE_ICMP_CODE,
+
+	__PRESTERA_ACL_RULE_MATCH_TYPE_MAX
 };
 
 enum prestera_acl_rule_action {
-	PRESTERA_ACL_RULE_ACTION_ACCEPT,
-	PRESTERA_ACL_RULE_ACTION_DROP,
-	PRESTERA_ACL_RULE_ACTION_TRAP
+	PRESTERA_ACL_RULE_ACTION_ACCEPT = 0,
+	PRESTERA_ACL_RULE_ACTION_DROP = 1,
+	PRESTERA_ACL_RULE_ACTION_TRAP = 2,
+	PRESTERA_ACL_RULE_ACTION_COUNT = 7,
+
+	PRESTERA_ACL_RULE_ACTION_MAX
 };
 
-struct prestera_switch;
-struct prestera_port;
-struct prestera_acl_rule;
-struct prestera_acl_ruleset;
+enum {
+	PRESTERA_ACL_IFACE_TYPE_PORT,
+	PRESTERA_ACL_IFACE_TYPE_INDEX
+};
 
-struct prestera_flow_block_binding {
-	struct list_head list;
-	struct prestera_port *port;
-	int span_id;
+struct prestera_acl_match {
+	__be32 key[__PRESTERA_ACL_RULE_MATCH_TYPE_MAX];
+	__be32 mask[__PRESTERA_ACL_RULE_MATCH_TYPE_MAX];
 };
 
-struct prestera_flow_block {
-	struct list_head binding_list;
-	struct prestera_switch *sw;
-	struct net *net;
-	struct prestera_acl_ruleset *ruleset;
-	struct flow_block_cb *block_cb;
+struct prestera_acl_rule_entry_key {
+	u32 prio;
+	struct prestera_acl_match match;
 };
 
-struct prestera_acl_rule_action_entry {
-	struct list_head list;
+struct prestera_acl_hw_action_info {
 	enum prestera_acl_rule_action id;
 };
 
-struct prestera_acl_rule_match_entry {
+/* This struct (arg) used only to be passed as parameter for
+ * acl_rule_entry_create. Must be flat. Can contain object keys, which will be
+ * resolved to object links, before saving to acl_rule_entry struct
+ */
+struct prestera_acl_rule_entry_arg {
+	u32 vtcam_id;
+	struct {
+		struct {
+			u8 valid:1;
+		} accept, drop, trap;
+	};
+};
+
+struct prestera_acl_rule {
+	struct rhash_head ht_node; /* Member of acl HT */
 	struct list_head list;
-	enum prestera_acl_rule_match_entry_type type;
+	struct prestera_acl_ruleset *ruleset;
+	unsigned long cookie;
+	u32 priority;
+	struct prestera_acl_rule_entry_key re_key;
+	struct prestera_acl_rule_entry_arg re_arg;
+	struct prestera_acl_rule_entry *re;
+};
+
+struct prestera_acl_iface {
 	union {
-		struct {
-			u8 key;
-			u8 mask;
-		} u8;
-		struct {
-			u16 key;
-			u16 mask;
-		} u16;
-		struct {
-			u32 key;
-			u32 mask;
-		} u32;
-		struct {
-			u64 key;
-			u64 mask;
-		} u64;
-		struct {
-			u8 key[ETH_ALEN];
-			u8 mask[ETH_ALEN];
-		} mac;
-	} keymask;
+		struct prestera_port *port;
+		u32 index;
+	};
+	u8 type;
 };
 
+struct prestera_acl;
+struct prestera_switch;
+struct prestera_flow_block;
+
 int prestera_acl_init(struct prestera_switch *sw);
 void prestera_acl_fini(struct prestera_switch *sw);
-struct prestera_flow_block *
-prestera_acl_block_create(struct prestera_switch *sw, struct net *net);
-void prestera_acl_block_destroy(struct prestera_flow_block *block);
-struct net *prestera_acl_block_net(struct prestera_flow_block *block);
-struct prestera_switch *prestera_acl_block_sw(struct prestera_flow_block *block);
-int prestera_acl_block_bind(struct prestera_flow_block *block,
-			    struct prestera_port *port);
-int prestera_acl_block_unbind(struct prestera_flow_block *block,
-			      struct prestera_port *port);
-struct prestera_acl_ruleset *
-prestera_acl_block_ruleset_get(struct prestera_flow_block *block);
+
 struct prestera_acl_rule *
-prestera_acl_rule_create(struct prestera_flow_block *block,
+prestera_acl_rule_create(struct prestera_acl_ruleset *ruleset,
 			 unsigned long cookie);
-u32 prestera_acl_rule_priority_get(struct prestera_acl_rule *rule);
 void prestera_acl_rule_priority_set(struct prestera_acl_rule *rule,
 				    u32 priority);
-u16 prestera_acl_rule_ruleset_id_get(const struct prestera_acl_rule *rule);
-struct list_head *
-prestera_acl_rule_action_list_get(struct prestera_acl_rule *rule);
-u8 prestera_acl_rule_action_len(struct prestera_acl_rule *rule);
-u8 prestera_acl_rule_match_len(struct prestera_acl_rule *rule);
-int prestera_acl_rule_action_add(struct prestera_acl_rule *rule,
-				 struct prestera_acl_rule_action_entry *entry);
-struct list_head *
-prestera_acl_rule_match_list_get(struct prestera_acl_rule *rule);
-int prestera_acl_rule_match_add(struct prestera_acl_rule *rule,
-				struct prestera_acl_rule_match_entry *entry);
 void prestera_acl_rule_destroy(struct prestera_acl_rule *rule);
 struct prestera_acl_rule *
 prestera_acl_rule_lookup(struct prestera_acl_ruleset *ruleset,
@@ -117,8 +121,37 @@ int prestera_acl_rule_add(struct prestera_switch *sw,
 			  struct prestera_acl_rule *rule);
 void prestera_acl_rule_del(struct prestera_switch *sw,
 			   struct prestera_acl_rule *rule);
-int prestera_acl_rule_get_stats(struct prestera_switch *sw,
+int prestera_acl_rule_get_stats(struct prestera_acl *acl,
 				struct prestera_acl_rule *rule,
 				u64 *packets, u64 *bytes, u64 *last_use);
+struct prestera_acl_rule_entry *
+prestera_acl_rule_entry_find(struct prestera_acl *acl,
+			     struct prestera_acl_rule_entry_key *key);
+void prestera_acl_rule_entry_destroy(struct prestera_acl *acl,
+				     struct prestera_acl_rule_entry *e);
+struct prestera_acl_rule_entry *
+prestera_acl_rule_entry_create(struct prestera_acl *acl,
+			       struct prestera_acl_rule_entry_key *key,
+			       struct prestera_acl_rule_entry_arg *arg);
+struct prestera_acl_ruleset *
+prestera_acl_ruleset_get(struct prestera_acl *acl,
+			 struct prestera_flow_block *block);
+struct prestera_acl_ruleset *
+prestera_acl_ruleset_lookup(struct prestera_acl *acl,
+			    struct prestera_flow_block *block);
+bool prestera_acl_ruleset_is_offload(struct prestera_acl_ruleset *ruleset);
+int prestera_acl_ruleset_offload(struct prestera_acl_ruleset *ruleset);
+void prestera_acl_ruleset_put(struct prestera_acl_ruleset *ruleset);
+int prestera_acl_ruleset_bind(struct prestera_acl_ruleset *ruleset,
+			      struct prestera_port *port);
+int prestera_acl_ruleset_unbind(struct prestera_acl_ruleset *ruleset,
+				struct prestera_port *port);
+void
+prestera_acl_rule_keymask_pcl_id_set(struct prestera_acl_rule *rule,
+				     u16 pcl_id);
+
+int prestera_acl_vtcam_id_get(struct prestera_acl *acl, u8 lookup,
+			      void *keymask, u32 *vtcam_id);
+int prestera_acl_vtcam_id_put(struct prestera_acl *acl, u32 vtcam_id);
 
 #endif /* _PRESTERA_ACL_H_ */
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_flow.c b/drivers/net/ethernet/marvell/prestera/prestera_flow.c
index c9891e968259..94a1feb3d9e1 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_flow.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_flow.c
@@ -60,11 +60,100 @@ static int prestera_flow_block_cb(enum tc_setup_type type,
 	}
 }
 
+static void prestera_flow_block_destroy(void *cb_priv)
+{
+	struct prestera_flow_block *block = cb_priv;
+
+	WARN_ON(!list_empty(&block->binding_list));
+
+	kfree(block);
+}
+
+static struct prestera_flow_block *
+prestera_flow_block_create(struct prestera_switch *sw, struct net *net)
+{
+	struct prestera_flow_block *block;
+
+	block = kzalloc(sizeof(*block), GFP_KERNEL);
+	if (!block)
+		return NULL;
+
+	INIT_LIST_HEAD(&block->binding_list);
+	block->net = net;
+	block->sw = sw;
+
+	return block;
+}
+
 static void prestera_flow_block_release(void *cb_priv)
 {
 	struct prestera_flow_block *block = cb_priv;
 
-	prestera_acl_block_destroy(block);
+	prestera_flow_block_destroy(block);
+}
+
+static bool
+prestera_flow_block_is_bound(const struct prestera_flow_block *block)
+{
+	return block->ruleset_zero;
+}
+
+static struct prestera_flow_block_binding *
+prestera_flow_block_lookup(struct prestera_flow_block *block,
+			   struct prestera_port *port)
+{
+	struct prestera_flow_block_binding *binding;
+
+	list_for_each_entry(binding, &block->binding_list, list)
+		if (binding->port == port)
+			return binding;
+
+	return NULL;
+}
+
+static int prestera_flow_block_bind(struct prestera_flow_block *block,
+				    struct prestera_port *port)
+{
+	struct prestera_flow_block_binding *binding;
+	int err;
+
+	binding = kzalloc(sizeof(*binding), GFP_KERNEL);
+	if (!binding)
+		return -ENOMEM;
+
+	binding->span_id = PRESTERA_SPAN_INVALID_ID;
+	binding->port = port;
+
+	if (prestera_flow_block_is_bound(block)) {
+		err = prestera_acl_ruleset_bind(block->ruleset_zero, port);
+		if (err)
+			goto err_ruleset_bind;
+	}
+
+	list_add(&binding->list, &block->binding_list);
+	return 0;
+
+err_ruleset_bind:
+	kfree(binding);
+	return err;
+}
+
+static int prestera_flow_block_unbind(struct prestera_flow_block *block,
+				      struct prestera_port *port)
+{
+	struct prestera_flow_block_binding *binding;
+
+	binding = prestera_flow_block_lookup(block, port);
+	if (!binding)
+		return -ENOENT;
+
+	list_del(&binding->list);
+
+	if (prestera_flow_block_is_bound(block))
+		prestera_acl_ruleset_unbind(block->ruleset_zero, port);
+
+	kfree(binding);
+	return 0;
 }
 
 static struct prestera_flow_block *
@@ -78,7 +167,7 @@ prestera_flow_block_get(struct prestera_switch *sw,
 	block_cb = flow_block_cb_lookup(f->block,
 					prestera_flow_block_cb, sw);
 	if (!block_cb) {
-		block = prestera_acl_block_create(sw, f->net);
+		block = prestera_flow_block_create(sw, f->net);
 		if (!block)
 			return ERR_PTR(-ENOMEM);
 
@@ -86,7 +175,7 @@ prestera_flow_block_get(struct prestera_switch *sw,
 					       sw, block,
 					       prestera_flow_block_release);
 		if (IS_ERR(block_cb)) {
-			prestera_acl_block_destroy(block);
+			prestera_flow_block_destroy(block);
 			return ERR_CAST(block_cb);
 		}
 
@@ -110,7 +199,7 @@ static void prestera_flow_block_put(struct prestera_flow_block *block)
 		return;
 
 	flow_block_cb_free(block_cb);
-	prestera_acl_block_destroy(block);
+	prestera_flow_block_destroy(block);
 }
 
 static int prestera_setup_flow_block_bind(struct prestera_port *port,
@@ -128,7 +217,7 @@ static int prestera_setup_flow_block_bind(struct prestera_port *port,
 
 	block_cb = block->block_cb;
 
-	err = prestera_acl_block_bind(block, port);
+	err = prestera_flow_block_bind(block, port);
 	if (err)
 		goto err_block_bind;
 
@@ -162,7 +251,7 @@ static void prestera_setup_flow_block_unbind(struct prestera_port *port,
 
 	prestera_span_destroy(block);
 
-	err = prestera_acl_block_unbind(block, port);
+	err = prestera_flow_block_unbind(block, port);
 	if (err)
 		goto error;
 
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_flow.h b/drivers/net/ethernet/marvell/prestera/prestera_flow.h
index 467c7038cace..5863acf06005 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_flow.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_flow.h
@@ -7,6 +7,22 @@
 #include <net/flow_offload.h>
 
 struct prestera_port;
+struct prestera_switch;
+
+struct prestera_flow_block_binding {
+	struct list_head list;
+	struct prestera_port *port;
+	int span_id;
+};
+
+struct prestera_flow_block {
+	struct list_head binding_list;
+	struct prestera_switch *sw;
+	unsigned int rule_count;
+	struct net *net;
+	struct prestera_acl_ruleset *ruleset_zero;
+	struct flow_block_cb *block_cb;
+};
 
 int prestera_flow_block_setup(struct prestera_port *port,
 			      struct flow_block_offload *f);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_flower.c b/drivers/net/ethernet/marvell/prestera/prestera_flower.c
index e571ba09ec08..c1dc4e49b07f 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_flower.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_flower.c
@@ -3,6 +3,7 @@
 
 #include "prestera.h"
 #include "prestera_acl.h"
+#include "prestera_flow.h"
 #include "prestera_flower.h"
 
 static int prestera_flower_parse_actions(struct prestera_flow_block *block,
@@ -10,35 +11,38 @@ static int prestera_flower_parse_actions(struct prestera_flow_block *block,
 					 struct flow_action *flow_action,
 					 struct netlink_ext_ack *extack)
 {
-	struct prestera_acl_rule_action_entry a_entry;
 	const struct flow_action_entry *act;
-	int err, i;
+	int i;
 
+	/* whole struct (rule->re_arg) must be initialized with 0 */
 	if (!flow_action_has_entries(flow_action))
 		return 0;
 
 	flow_action_for_each(i, act, flow_action) {
-		memset(&a_entry, 0, sizeof(a_entry));
-
 		switch (act->id) {
 		case FLOW_ACTION_ACCEPT:
-			a_entry.id = PRESTERA_ACL_RULE_ACTION_ACCEPT;
+			if (rule->re_arg.accept.valid)
+				return -EEXIST;
+
+			rule->re_arg.accept.valid = 1;
 			break;
 		case FLOW_ACTION_DROP:
-			a_entry.id = PRESTERA_ACL_RULE_ACTION_DROP;
+			if (rule->re_arg.drop.valid)
+				return -EEXIST;
+
+			rule->re_arg.drop.valid = 1;
 			break;
 		case FLOW_ACTION_TRAP:
-			a_entry.id = PRESTERA_ACL_RULE_ACTION_TRAP;
+			if (rule->re_arg.trap.valid)
+				return -EEXIST;
+
+			rule->re_arg.trap.valid = 1;
 			break;
 		default:
 			NL_SET_ERR_MSG_MOD(extack, "Unsupported action");
 			pr_err("Unsupported action\n");
 			return -EOPNOTSUPP;
 		}
-
-		err = prestera_acl_rule_action_add(rule, &a_entry);
-		if (err)
-			return err;
 	}
 
 	return 0;
@@ -47,12 +51,12 @@ static int prestera_flower_parse_actions(struct prestera_flow_block *block,
 static int prestera_flower_parse_meta(struct prestera_acl_rule *rule,
 				      struct flow_cls_offload *f,
 				      struct prestera_flow_block *block)
-{
-	struct flow_rule *f_rule = flow_cls_offload_flow_rule(f);
-	struct prestera_acl_rule_match_entry m_entry = {0};
+{	struct flow_rule *f_rule = flow_cls_offload_flow_rule(f);
+	struct prestera_acl_match *r_match = &rule->re_key.match;
+	struct prestera_port *port;
 	struct net_device *ingress_dev;
 	struct flow_match_meta match;
-	struct prestera_port *port;
+	__be16 key, mask;
 
 	flow_rule_match_meta(f_rule, &match);
 	if (match.mask->ingress_ifindex != 0xFFFFFFFF) {
@@ -61,7 +65,7 @@ static int prestera_flower_parse_meta(struct prestera_acl_rule *rule,
 		return -EINVAL;
 	}
 
-	ingress_dev = __dev_get_by_index(prestera_acl_block_net(block),
+	ingress_dev = __dev_get_by_index(block->net,
 					 match.key->ingress_ifindex);
 	if (!ingress_dev) {
 		NL_SET_ERR_MSG_MOD(f->common.extack,
@@ -76,22 +80,28 @@ static int prestera_flower_parse_meta(struct prestera_acl_rule *rule,
 	}
 	port = netdev_priv(ingress_dev);
 
-	m_entry.type = PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_PORT;
-	m_entry.keymask.u64.key = port->hw_id | ((u64)port->dev_id << 32);
-	m_entry.keymask.u64.mask = ~(u64)0;
+	mask = htons(0x1FFF);
+	key = htons(port->hw_id);
+	rule_match_set(r_match->key, SYS_PORT, key);
+	rule_match_set(r_match->mask, SYS_PORT, mask);
+
+	mask = htons(0x1FF);
+	key = htons(port->dev_id);
+	rule_match_set(r_match->key, SYS_DEV, key);
+	rule_match_set(r_match->mask, SYS_DEV, mask);
+
+	return 0;
 
-	return prestera_acl_rule_match_add(rule, &m_entry);
 }
 
 static int prestera_flower_parse(struct prestera_flow_block *block,
 				 struct prestera_acl_rule *rule,
 				 struct flow_cls_offload *f)
-{
-	struct flow_rule *f_rule = flow_cls_offload_flow_rule(f);
+{	struct flow_rule *f_rule = flow_cls_offload_flow_rule(f);
 	struct flow_dissector *dissector = f_rule->match.dissector;
-	struct prestera_acl_rule_match_entry m_entry;
-	u16 n_proto_mask = 0;
-	u16 n_proto_key = 0;
+	struct prestera_acl_match *r_match = &rule->re_key.match;
+	__be16 n_proto_mask = 0;
+	__be16 n_proto_key = 0;
 	u16 addr_type = 0;
 	u8 ip_proto = 0;
 	int err;
@@ -129,32 +139,19 @@ static int prestera_flower_parse(struct prestera_flow_block *block,
 		struct flow_match_basic match;
 
 		flow_rule_match_basic(f_rule, &match);
-		n_proto_key = ntohs(match.key->n_proto);
-		n_proto_mask = ntohs(match.mask->n_proto);
+		n_proto_key = match.key->n_proto;
+		n_proto_mask = match.mask->n_proto;
 
-		if (n_proto_key == ETH_P_ALL) {
+		if (ntohs(match.key->n_proto) == ETH_P_ALL) {
 			n_proto_key = 0;
 			n_proto_mask = 0;
 		}
 
-		/* add eth type key,mask */
-		memset(&m_entry, 0, sizeof(m_entry));
-		m_entry.type = PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_ETH_TYPE;
-		m_entry.keymask.u16.key = n_proto_key;
-		m_entry.keymask.u16.mask = n_proto_mask;
-		err = prestera_acl_rule_match_add(rule, &m_entry);
-		if (err)
-			return err;
-
-		/* add ip proto key,mask */
-		memset(&m_entry, 0, sizeof(m_entry));
-		m_entry.type = PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_IP_PROTO;
-		m_entry.keymask.u8.key = match.key->ip_proto;
-		m_entry.keymask.u8.mask = match.mask->ip_proto;
-		err = prestera_acl_rule_match_add(rule, &m_entry);
-		if (err)
-			return err;
+		rule_match_set(r_match->key, ETH_TYPE, n_proto_key);
+		rule_match_set(r_match->mask, ETH_TYPE, n_proto_mask);
 
+		rule_match_set(r_match->key, IP_PROTO, match.key->ip_proto);
+		rule_match_set(r_match->mask, IP_PROTO, match.mask->ip_proto);
 		ip_proto = match.key->ip_proto;
 	}
 
@@ -163,27 +160,27 @@ static int prestera_flower_parse(struct prestera_flow_block *block,
 
 		flow_rule_match_eth_addrs(f_rule, &match);
 
-		/* add ethernet dst key,mask */
-		memset(&m_entry, 0, sizeof(m_entry));
-		m_entry.type = PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_ETH_DMAC;
-		memcpy(&m_entry.keymask.mac.key,
-		       &match.key->dst, sizeof(match.key->dst));
-		memcpy(&m_entry.keymask.mac.mask,
-		       &match.mask->dst, sizeof(match.mask->dst));
-		err = prestera_acl_rule_match_add(rule, &m_entry);
-		if (err)
-			return err;
-
-		/* add ethernet src key,mask */
-		memset(&m_entry, 0, sizeof(m_entry));
-		m_entry.type = PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_ETH_SMAC;
-		memcpy(&m_entry.keymask.mac.key,
-		       &match.key->src, sizeof(match.key->src));
-		memcpy(&m_entry.keymask.mac.mask,
-		       &match.mask->src, sizeof(match.mask->src));
-		err = prestera_acl_rule_match_add(rule, &m_entry);
-		if (err)
-			return err;
+		/* DA key, mask */
+		rule_match_set_n(r_match->key,
+				 ETH_DMAC_0, &match.key->dst[0], 4);
+		rule_match_set_n(r_match->key,
+				 ETH_DMAC_1, &match.key->dst[4], 2);
+
+		rule_match_set_n(r_match->mask,
+				 ETH_DMAC_0, &match.mask->dst[0], 4);
+		rule_match_set_n(r_match->mask,
+				 ETH_DMAC_1, &match.mask->dst[4], 2);
+
+		/* SA key, mask */
+		rule_match_set_n(r_match->key,
+				 ETH_SMAC_0, &match.key->src[0], 4);
+		rule_match_set_n(r_match->key,
+				 ETH_SMAC_1, &match.key->src[4], 2);
+
+		rule_match_set_n(r_match->mask,
+				 ETH_SMAC_0, &match.mask->src[0], 4);
+		rule_match_set_n(r_match->mask,
+				 ETH_SMAC_1, &match.mask->src[4], 2);
 	}
 
 	if (addr_type == FLOW_DISSECTOR_KEY_IPV4_ADDRS) {
@@ -191,25 +188,11 @@ static int prestera_flower_parse(struct prestera_flow_block *block,
 
 		flow_rule_match_ipv4_addrs(f_rule, &match);
 
-		memset(&m_entry, 0, sizeof(m_entry));
-		m_entry.type = PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_IP_SRC;
-		memcpy(&m_entry.keymask.u32.key,
-		       &match.key->src, sizeof(match.key->src));
-		memcpy(&m_entry.keymask.u32.mask,
-		       &match.mask->src, sizeof(match.mask->src));
-		err = prestera_acl_rule_match_add(rule, &m_entry);
-		if (err)
-			return err;
+		rule_match_set(r_match->key, IP_SRC, match.key->src);
+		rule_match_set(r_match->mask, IP_SRC, match.mask->src);
 
-		memset(&m_entry, 0, sizeof(m_entry));
-		m_entry.type = PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_IP_DST;
-		memcpy(&m_entry.keymask.u32.key,
-		       &match.key->dst, sizeof(match.key->dst));
-		memcpy(&m_entry.keymask.u32.mask,
-		       &match.mask->dst, sizeof(match.mask->dst));
-		err = prestera_acl_rule_match_add(rule, &m_entry);
-		if (err)
-			return err;
+		rule_match_set(r_match->key, IP_DST, match.key->dst);
+		rule_match_set(r_match->mask, IP_DST, match.mask->dst);
 	}
 
 	if (flow_rule_match_key(f_rule, FLOW_DISSECTOR_KEY_PORTS)) {
@@ -224,21 +207,11 @@ static int prestera_flower_parse(struct prestera_flow_block *block,
 
 		flow_rule_match_ports(f_rule, &match);
 
-		memset(&m_entry, 0, sizeof(m_entry));
-		m_entry.type = PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_L4_PORT_SRC;
-		m_entry.keymask.u16.key = ntohs(match.key->src);
-		m_entry.keymask.u16.mask = ntohs(match.mask->src);
-		err = prestera_acl_rule_match_add(rule, &m_entry);
-		if (err)
-			return err;
+		rule_match_set(r_match->key, L4_PORT_SRC, match.key->src);
+		rule_match_set(r_match->mask, L4_PORT_SRC, match.mask->src);
 
-		memset(&m_entry, 0, sizeof(m_entry));
-		m_entry.type = PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_L4_PORT_DST;
-		m_entry.keymask.u16.key = ntohs(match.key->dst);
-		m_entry.keymask.u16.mask = ntohs(match.mask->dst);
-		err = prestera_acl_rule_match_add(rule, &m_entry);
-		if (err)
-			return err;
+		rule_match_set(r_match->key, L4_PORT_DST, match.key->dst);
+		rule_match_set(r_match->mask, L4_PORT_DST, match.mask->dst);
 	}
 
 	if (flow_rule_match_key(f_rule, FLOW_DISSECTOR_KEY_VLAN)) {
@@ -247,22 +220,15 @@ static int prestera_flower_parse(struct prestera_flow_block *block,
 		flow_rule_match_vlan(f_rule, &match);
 
 		if (match.mask->vlan_id != 0) {
-			memset(&m_entry, 0, sizeof(m_entry));
-			m_entry.type = PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_VLAN_ID;
-			m_entry.keymask.u16.key = match.key->vlan_id;
-			m_entry.keymask.u16.mask = match.mask->vlan_id;
-			err = prestera_acl_rule_match_add(rule, &m_entry);
-			if (err)
-				return err;
+			__be16 key = cpu_to_be16(match.key->vlan_id);
+			__be16 mask = cpu_to_be16(match.mask->vlan_id);
+
+			rule_match_set(r_match->key, VLAN_ID, key);
+			rule_match_set(r_match->mask, VLAN_ID, mask);
 		}
 
-		memset(&m_entry, 0, sizeof(m_entry));
-		m_entry.type = PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_VLAN_TPID;
-		m_entry.keymask.u16.key = ntohs(match.key->vlan_tpid);
-		m_entry.keymask.u16.mask = ntohs(match.mask->vlan_tpid);
-		err = prestera_acl_rule_match_add(rule, &m_entry);
-		if (err)
-			return err;
+		rule_match_set(r_match->key, VLAN_TPID, match.key->vlan_tpid);
+		rule_match_set(r_match->mask, VLAN_TPID, match.mask->vlan_tpid);
 	}
 
 	if (flow_rule_match_key(f_rule, FLOW_DISSECTOR_KEY_ICMP)) {
@@ -270,90 +236,109 @@ static int prestera_flower_parse(struct prestera_flow_block *block,
 
 		flow_rule_match_icmp(f_rule, &match);
 
-		memset(&m_entry, 0, sizeof(m_entry));
-		m_entry.type = PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_ICMP_TYPE;
-		m_entry.keymask.u8.key = match.key->type;
-		m_entry.keymask.u8.mask = match.mask->type;
-		err = prestera_acl_rule_match_add(rule, &m_entry);
-		if (err)
-			return err;
+		rule_match_set(r_match->key, ICMP_TYPE, match.key->type);
+		rule_match_set(r_match->mask, ICMP_TYPE, match.mask->type);
 
-		memset(&m_entry, 0, sizeof(m_entry));
-		m_entry.type = PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_ICMP_CODE;
-		m_entry.keymask.u8.key = match.key->code;
-		m_entry.keymask.u8.mask = match.mask->code;
-		err = prestera_acl_rule_match_add(rule, &m_entry);
-		if (err)
-			return err;
+		rule_match_set(r_match->key, ICMP_CODE, match.key->code);
+		rule_match_set(r_match->mask, ICMP_CODE, match.mask->code);
 	}
 
-	return prestera_flower_parse_actions(block, rule,
-					     &f->rule->action,
+	return prestera_flower_parse_actions(block, rule, &f->rule->action,
 					     f->common.extack);
 }
 
 int prestera_flower_replace(struct prestera_flow_block *block,
 			    struct flow_cls_offload *f)
 {
-	struct prestera_switch *sw = prestera_acl_block_sw(block);
+	struct prestera_acl_ruleset *ruleset;
+	struct prestera_acl *acl = block->sw->acl;
 	struct prestera_acl_rule *rule;
 	int err;
 
-	rule = prestera_acl_rule_create(block, f->cookie);
-	if (IS_ERR(rule))
-		return PTR_ERR(rule);
+	ruleset = prestera_acl_ruleset_get(acl, block);
+	if (IS_ERR(ruleset))
+		return PTR_ERR(ruleset);
+
+	/* increments the ruleset reference */
+	rule = prestera_acl_rule_create(ruleset, f->cookie);
+	if (IS_ERR(rule)) {
+		err = PTR_ERR(rule);
+		goto err_rule_create;
+	}
 
 	err = prestera_flower_parse(block, rule, f);
 	if (err)
-		goto err_flower_parse;
+		goto err_rule_add;
 
-	err = prestera_acl_rule_add(sw, rule);
+	if (!prestera_acl_ruleset_is_offload(ruleset)) {
+		err = prestera_acl_ruleset_offload(ruleset);
+		if (err)
+			goto err_ruleset_offload;
+	}
+
+	err = prestera_acl_rule_add(block->sw, rule);
 	if (err)
 		goto err_rule_add;
 
+	prestera_acl_ruleset_put(ruleset);
 	return 0;
 
+err_ruleset_offload:
 err_rule_add:
-err_flower_parse:
 	prestera_acl_rule_destroy(rule);
+err_rule_create:
+	prestera_acl_ruleset_put(ruleset);
 	return err;
 }
 
 void prestera_flower_destroy(struct prestera_flow_block *block,
 			     struct flow_cls_offload *f)
 {
+	struct prestera_acl_ruleset *ruleset;
 	struct prestera_acl_rule *rule;
-	struct prestera_switch *sw;
 
-	rule = prestera_acl_rule_lookup(prestera_acl_block_ruleset_get(block),
-					f->cookie);
+	ruleset = prestera_acl_ruleset_lookup(block->sw->acl, block);
+	if (IS_ERR(ruleset))
+		return;
+
+	rule = prestera_acl_rule_lookup(ruleset, f->cookie);
 	if (rule) {
-		sw = prestera_acl_block_sw(block);
-		prestera_acl_rule_del(sw, rule);
+		prestera_acl_rule_del(block->sw, rule);
 		prestera_acl_rule_destroy(rule);
 	}
+	prestera_acl_ruleset_put(ruleset);
+
 }
 
 int prestera_flower_stats(struct prestera_flow_block *block,
 			  struct flow_cls_offload *f)
 {
-	struct prestera_switch *sw = prestera_acl_block_sw(block);
+	struct prestera_acl_ruleset *ruleset;
 	struct prestera_acl_rule *rule;
 	u64 packets;
 	u64 lastuse;
 	u64 bytes;
 	int err;
 
-	rule = prestera_acl_rule_lookup(prestera_acl_block_ruleset_get(block),
-					f->cookie);
-	if (!rule)
-		return -EINVAL;
+	ruleset = prestera_acl_ruleset_lookup(block->sw->acl, block);
+	if (IS_ERR(ruleset))
+		return PTR_ERR(ruleset);
+
+	rule = prestera_acl_rule_lookup(ruleset, f->cookie);
+	if (!rule) {
+		err = -EINVAL;
+		goto err_rule_get_stats;
+	}
 
-	err = prestera_acl_rule_get_stats(sw, rule, &packets, &bytes, &lastuse);
+	err = prestera_acl_rule_get_stats(block->sw->acl, rule, &packets,
+					  &bytes, &lastuse);
 	if (err)
-		return err;
+		goto err_rule_get_stats;
 
 	flow_stats_update(&f->stats, bytes, packets, 0, lastuse,
-			  FLOW_ACTION_HW_STATS_IMMEDIATE);
-	return 0;
+			  FLOW_ACTION_HW_STATS_DELAYED);
+
+err_rule_get_stats:
+	prestera_acl_ruleset_put(ruleset);
+	return err;
 }
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_flower.h b/drivers/net/ethernet/marvell/prestera/prestera_flower.h
index 91e045eec58b..c6182473efa5 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_flower.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_flower.h
@@ -1,11 +1,12 @@
 /* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0 */
-/* Copyright (c) 2020 Marvell International Ltd. All rights reserved. */
+/* Copyright (c) 2020-2021 Marvell International Ltd. All rights reserved. */
 
 #ifndef _PRESTERA_FLOWER_H_
 #define _PRESTERA_FLOWER_H_
 
 #include <net/pkt_cls.h>
 
+struct prestera_switch;
 struct prestera_flow_block;
 
 int prestera_flower_replace(struct prestera_flow_block *block,
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
index 9b8b1ed474fc..d6c425b651cb 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
@@ -38,13 +38,12 @@ enum prestera_cmd_type_t {
 	PRESTERA_CMD_TYPE_BRIDGE_PORT_ADD = 0x402,
 	PRESTERA_CMD_TYPE_BRIDGE_PORT_DELETE = 0x403,
 
-	PRESTERA_CMD_TYPE_ACL_RULE_ADD = 0x500,
-	PRESTERA_CMD_TYPE_ACL_RULE_DELETE = 0x501,
-	PRESTERA_CMD_TYPE_ACL_RULE_STATS_GET = 0x510,
-	PRESTERA_CMD_TYPE_ACL_RULESET_CREATE = 0x520,
-	PRESTERA_CMD_TYPE_ACL_RULESET_DELETE = 0x521,
-	PRESTERA_CMD_TYPE_ACL_PORT_BIND = 0x530,
-	PRESTERA_CMD_TYPE_ACL_PORT_UNBIND = 0x531,
+	PRESTERA_CMD_TYPE_VTCAM_CREATE = 0x540,
+	PRESTERA_CMD_TYPE_VTCAM_DESTROY = 0x541,
+	PRESTERA_CMD_TYPE_VTCAM_RULE_ADD = 0x550,
+	PRESTERA_CMD_TYPE_VTCAM_RULE_DELETE = 0x551,
+	PRESTERA_CMD_TYPE_VTCAM_IFACE_BIND = 0x560,
+	PRESTERA_CMD_TYPE_VTCAM_IFACE_UNBIND = 0x561,
 
 	PRESTERA_CMD_TYPE_RXTX_INIT = 0x800,
 
@@ -359,76 +358,57 @@ struct prestera_msg_bridge_resp {
 	u8 pad[2];
 };
 
-struct prestera_msg_acl_action {
-	__le32 id;
-	__le32 reserved[5];
+struct prestera_msg_vtcam_create_req {
+	struct prestera_msg_cmd cmd;
+	__le32 keymask[__PRESTERA_ACL_RULE_MATCH_TYPE_MAX];
+	u8 direction;
+	u8 lookup;
+	u8 pad[2];
 };
 
-struct prestera_msg_acl_match {
-	__le32 type;
-	__le32 __reserved;
-	union {
-		struct {
-			u8 key;
-			u8 mask;
-		} u8;
-		struct {
-			__le16 key;
-			__le16 mask;
-		} u16;
-		struct {
-			__le32 key;
-			__le32 mask;
-		} u32;
-		struct {
-			__le64 key;
-			__le64 mask;
-		} u64;
-		struct {
-			u8 key[ETH_ALEN];
-			u8 mask[ETH_ALEN];
-		} mac;
-	} keymask;
+struct prestera_msg_vtcam_destroy_req {
+	struct prestera_msg_cmd cmd;
+	__le32 vtcam_id;
 };
 
-struct prestera_msg_acl_rule_req {
+struct prestera_msg_vtcam_rule_add_req {
 	struct prestera_msg_cmd cmd;
-	__le32 id;
-	__le32 priority;
-	__le16 ruleset_id;
-	u8 n_actions;
-	u8 n_matches;
+	__le32 key[__PRESTERA_ACL_RULE_MATCH_TYPE_MAX];
+	__le32 keymask[__PRESTERA_ACL_RULE_MATCH_TYPE_MAX];
+	__le32 vtcam_id;
+	__le32 prio;
+	__le32 n_act;
 };
 
-struct prestera_msg_acl_rule_resp {
-	struct prestera_msg_ret ret;
+struct prestera_msg_vtcam_rule_del_req {
+	struct prestera_msg_cmd cmd;
+	__le32 vtcam_id;
 	__le32 id;
 };
 
-struct prestera_msg_acl_rule_stats_resp {
-	struct prestera_msg_ret ret;
-	__le64 packets;
-	__le64 bytes;
-};
-
-struct prestera_msg_acl_ruleset_bind_req {
+struct prestera_msg_vtcam_bind_req {
 	struct prestera_msg_cmd cmd;
-	__le32 port;
-	__le32 dev;
-	__le16 ruleset_id;
-	u8 pad[2];
+	union {
+		struct {
+			__le32 hw_id;
+			__le32 dev_id;
+		} port;
+		__le32 index;
+	};
+	__le32 vtcam_id;
+	__le16 pcl_id;
+	__le16 type;
 };
 
-struct prestera_msg_acl_ruleset_req {
-	struct prestera_msg_cmd cmd;
-	__le16 id;
-	u8 pad[2];
+struct prestera_msg_vtcam_resp {
+	struct prestera_msg_ret ret;
+	__le32 vtcam_id;
+	__le32 rule_id;
 };
 
-struct prestera_msg_acl_ruleset_resp {
-	struct prestera_msg_ret ret;
-	__le16 id;
-	u8 pad[2];
+struct prestera_msg_acl_action {
+	__le32 id;
+	__le32 __reserved[7];
 };
 
 struct prestera_msg_span_req {
@@ -521,14 +501,17 @@ static void prestera_hw_build_tests(void)
 	BUILD_BUG_ON(sizeof(struct prestera_msg_vlan_req) != 16);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_fdb_req) != 28);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_bridge_req) != 16);
-	BUILD_BUG_ON(sizeof(struct prestera_msg_acl_rule_req) != 16);
-	BUILD_BUG_ON(sizeof(struct prestera_msg_acl_ruleset_bind_req) != 16);
-	BUILD_BUG_ON(sizeof(struct prestera_msg_acl_ruleset_req) != 8);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_span_req) != 16);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_stp_req) != 16);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_rxtx_req) != 8);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_lag_req) != 16);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_cpu_code_counter_req) != 8);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_vtcam_create_req) != 84);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_vtcam_destroy_req) != 8);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_vtcam_rule_add_req) != 168);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_vtcam_rule_del_req) != 12);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_vtcam_bind_req) != 20);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_acl_action) != 32);
 
 	/* check responses */
 	BUILD_BUG_ON(sizeof(struct prestera_msg_common_resp) != 8);
@@ -537,11 +520,9 @@ static void prestera_hw_build_tests(void)
 	BUILD_BUG_ON(sizeof(struct prestera_msg_port_stats_resp) != 248);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_port_info_resp) != 20);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_bridge_resp) != 12);
-	BUILD_BUG_ON(sizeof(struct prestera_msg_acl_rule_resp) != 12);
-	BUILD_BUG_ON(sizeof(struct prestera_msg_acl_rule_stats_resp) != 24);
-	BUILD_BUG_ON(sizeof(struct prestera_msg_acl_ruleset_resp) != 12);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_span_resp) != 12);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_rxtx_resp) != 12);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_vtcam_resp) != 16);
 
 	/* check events */
 	BUILD_BUG_ON(sizeof(struct prestera_msg_event_port) != 20);
@@ -1044,225 +1025,159 @@ static void prestera_hw_remote_fc_to_eth(u8 fc, bool *pause, bool *asym_pause)
 	}
 }
 
-int prestera_hw_acl_ruleset_create(struct prestera_switch *sw, u16 *ruleset_id)
+int prestera_hw_vtcam_create(struct prestera_switch *sw,
+			     u8 lookup, const u32 *keymask, u32 *vtcam_id,
+			     enum prestera_hw_vtcam_direction_t dir)
 {
-	struct prestera_msg_acl_ruleset_resp resp;
-	struct prestera_msg_acl_ruleset_req req;
 	int err;
+	struct prestera_msg_vtcam_resp resp;
+	struct prestera_msg_vtcam_create_req req = {
+		.lookup = lookup,
+		.direction = dir,
+	};
+
+	if (keymask)
+		memcpy(req.keymask, keymask, sizeof(req.keymask));
+	else
+		memset(req.keymask, 0, sizeof(req.keymask));
 
-	err = prestera_cmd_ret(sw, PRESTERA_CMD_TYPE_ACL_RULESET_CREATE,
+	err = prestera_cmd_ret(sw, PRESTERA_CMD_TYPE_VTCAM_CREATE,
 			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
 	if (err)
 		return err;
 
-	*ruleset_id = __le16_to_cpu(resp.id);
-
+	*vtcam_id = __le32_to_cpu(resp.vtcam_id);
 	return 0;
 }
 
-int prestera_hw_acl_ruleset_del(struct prestera_switch *sw, u16 ruleset_id)
+int prestera_hw_vtcam_destroy(struct prestera_switch *sw, u32 vtcam_id)
 {
-	struct prestera_msg_acl_ruleset_req req = {
-		.id = __cpu_to_le16(ruleset_id),
+	struct prestera_msg_vtcam_destroy_req req = {
+		.vtcam_id = __cpu_to_le32(vtcam_id),
 	};
 
-	return prestera_cmd(sw, PRESTERA_CMD_TYPE_ACL_RULESET_DELETE,
+	return prestera_cmd(sw, PRESTERA_CMD_TYPE_VTCAM_DESTROY,
 			    &req.cmd, sizeof(req));
 }
 
-static int prestera_hw_acl_actions_put(struct prestera_msg_acl_action *action,
-				       struct prestera_acl_rule *rule)
+static int
+prestera_acl_rule_add_put_action(struct prestera_msg_acl_action *action,
+				 struct prestera_acl_hw_action_info *info)
 {
-	struct list_head *a_list = prestera_acl_rule_action_list_get(rule);
-	struct prestera_acl_rule_action_entry *a_entry;
-	int i = 0;
-
-	list_for_each_entry(a_entry, a_list, list) {
-		action[i].id = __cpu_to_le32(a_entry->id);
-
-		switch (a_entry->id) {
-		case PRESTERA_ACL_RULE_ACTION_ACCEPT:
-		case PRESTERA_ACL_RULE_ACTION_DROP:
-		case PRESTERA_ACL_RULE_ACTION_TRAP:
-			/* just rule action id, no specific data */
-			break;
-		default:
-			return -EINVAL;
-		}
+	action->id = __cpu_to_le32(info->id);
 
-		i++;
-	}
-
-	return 0;
-}
-
-static int prestera_hw_acl_matches_put(struct prestera_msg_acl_match *match,
-				       struct prestera_acl_rule *rule)
-{
-	struct list_head *m_list = prestera_acl_rule_match_list_get(rule);
-	struct prestera_acl_rule_match_entry *m_entry;
-	int i = 0;
-
-	list_for_each_entry(m_entry, m_list, list) {
-		match[i].type = __cpu_to_le32(m_entry->type);
-
-		switch (m_entry->type) {
-		case PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_ETH_TYPE:
-		case PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_L4_PORT_SRC:
-		case PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_L4_PORT_DST:
-		case PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_VLAN_ID:
-		case PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_VLAN_TPID:
-			match[i].keymask.u16.key =
-				__cpu_to_le16(m_entry->keymask.u16.key);
-			match[i].keymask.u16.mask =
-				__cpu_to_le16(m_entry->keymask.u16.mask);
-			break;
-		case PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_ICMP_TYPE:
-		case PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_ICMP_CODE:
-		case PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_IP_PROTO:
-			match[i].keymask.u8.key = m_entry->keymask.u8.key;
-			match[i].keymask.u8.mask = m_entry->keymask.u8.mask;
-			break;
-		case PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_ETH_SMAC:
-		case PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_ETH_DMAC:
-			memcpy(match[i].keymask.mac.key,
-			       m_entry->keymask.mac.key,
-			       sizeof(match[i].keymask.mac.key));
-			memcpy(match[i].keymask.mac.mask,
-			       m_entry->keymask.mac.mask,
-			       sizeof(match[i].keymask.mac.mask));
-			break;
-		case PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_IP_SRC:
-		case PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_IP_DST:
-		case PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_L4_PORT_RANGE_SRC:
-		case PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_L4_PORT_RANGE_DST:
-			match[i].keymask.u32.key =
-				__cpu_to_le32(m_entry->keymask.u32.key);
-			match[i].keymask.u32.mask =
-				__cpu_to_le32(m_entry->keymask.u32.mask);
-			break;
-		case PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_PORT:
-			match[i].keymask.u64.key =
-				__cpu_to_le64(m_entry->keymask.u64.key);
-			match[i].keymask.u64.mask =
-				__cpu_to_le64(m_entry->keymask.u64.mask);
-			break;
-		default:
-			return -EINVAL;
-		}
-
-		i++;
+	switch (info->id) {
+	case PRESTERA_ACL_RULE_ACTION_ACCEPT:
+	case PRESTERA_ACL_RULE_ACTION_DROP:
+	case PRESTERA_ACL_RULE_ACTION_TRAP:
+		/* just rule action id, no specific data */
+		break;
+	default:
+		return -EINVAL;
 	}
 
 	return 0;
 }
 
-int prestera_hw_acl_rule_add(struct prestera_switch *sw,
-			     struct prestera_acl_rule *rule,
-			     u32 *rule_id)
+int prestera_hw_vtcam_rule_add(struct prestera_switch *sw,
+			       u32 vtcam_id, u32 prio, void *key, void *keymask,
+			       struct prestera_acl_hw_action_info *act,
+			       u8 n_act, u32 *rule_id)
 {
-	struct prestera_msg_acl_action *actions;
-	struct prestera_msg_acl_match *matches;
-	struct prestera_msg_acl_rule_resp resp;
-	struct prestera_msg_acl_rule_req *req;
-	u8 n_actions;
-	u8 n_matches;
+	struct prestera_msg_acl_action *actions_msg;
+	struct prestera_msg_vtcam_rule_add_req *req;
+	struct prestera_msg_vtcam_resp resp;
 	void *buff;
 	u32 size;
 	int err;
+	u8 i;
 
-	n_actions = prestera_acl_rule_action_len(rule);
-	n_matches = prestera_acl_rule_match_len(rule);
-
-	size = sizeof(*req) + sizeof(*actions) * n_actions +
-		sizeof(*matches) * n_matches;
+	size = sizeof(*req) + sizeof(*actions_msg) * n_act;
 
 	buff = kzalloc(size, GFP_KERNEL);
 	if (!buff)
 		return -ENOMEM;
 
 	req = buff;
-	actions = buff + sizeof(*req);
-	matches = buff + sizeof(*req) + sizeof(*actions) * n_actions;
-
-	/* put acl actions into the message */
-	err = prestera_hw_acl_actions_put(actions, rule);
-	if (err)
-		goto free_buff;
+	req->n_act = __cpu_to_le32(n_act);
+	actions_msg = buff + sizeof(*req);
 
 	/* put acl matches into the message */
-	err = prestera_hw_acl_matches_put(matches, rule);
-	if (err)
-		goto free_buff;
+	memcpy(req->key, key, sizeof(req->key));
+	memcpy(req->keymask, keymask, sizeof(req->keymask));
+
+	/* put acl actions into the message */
+	for (i = 0; i < n_act; i++) {
+		err = prestera_acl_rule_add_put_action(&actions_msg[i],
+						       &act[i]);
+		if (err)
+			goto free_buff;
+	}
 
-	req->ruleset_id = __cpu_to_le16(prestera_acl_rule_ruleset_id_get(rule));
-	req->priority = __cpu_to_le32(prestera_acl_rule_priority_get(rule));
-	req->n_actions = prestera_acl_rule_action_len(rule);
-	req->n_matches = prestera_acl_rule_match_len(rule);
+	req->vtcam_id = __cpu_to_le32(vtcam_id);
+	req->prio = __cpu_to_le32(prio);
 
-	err = prestera_cmd_ret(sw, PRESTERA_CMD_TYPE_ACL_RULE_ADD,
+	err = prestera_cmd_ret(sw, PRESTERA_CMD_TYPE_VTCAM_RULE_ADD,
 			       &req->cmd, size, &resp.ret, sizeof(resp));
 	if (err)
 		goto free_buff;
 
-	*rule_id = __le32_to_cpu(resp.id);
+	*rule_id = __le32_to_cpu(resp.rule_id);
 free_buff:
 	kfree(buff);
 	return err;
 }
 
-int prestera_hw_acl_rule_del(struct prestera_switch *sw, u32 rule_id)
+int prestera_hw_vtcam_rule_del(struct prestera_switch *sw,
+			       u32 vtcam_id, u32 rule_id)
 {
-	struct prestera_msg_acl_rule_req req = {
+	struct prestera_msg_vtcam_rule_del_req req = {
+		.vtcam_id = __cpu_to_le32(vtcam_id),
 		.id = __cpu_to_le32(rule_id)
 	};
 
-	return prestera_cmd(sw, PRESTERA_CMD_TYPE_ACL_RULE_DELETE,
+	return prestera_cmd(sw, PRESTERA_CMD_TYPE_VTCAM_RULE_DELETE,
 			    &req.cmd, sizeof(req));
 }
 
-int prestera_hw_acl_rule_stats_get(struct prestera_switch *sw, u32 rule_id,
-				   u64 *packets, u64 *bytes)
+int prestera_hw_vtcam_iface_bind(struct prestera_switch *sw,
+				 struct prestera_acl_iface *iface,
+				 u32 vtcam_id, u16 pcl_id)
 {
-	struct prestera_msg_acl_rule_stats_resp resp;
-	struct prestera_msg_acl_rule_req req = {
-		.id = __cpu_to_le32(rule_id)
+	struct prestera_msg_vtcam_bind_req req = {
+		.vtcam_id = __cpu_to_le32(vtcam_id),
+		.type = __cpu_to_le16(iface->type),
+		.pcl_id = __cpu_to_le16(pcl_id)
 	};
-	int err;
-
-	err = prestera_cmd_ret(sw, PRESTERA_CMD_TYPE_ACL_RULE_STATS_GET,
-			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
-	if (err)
-		return err;
 
-	*packets = __le64_to_cpu(resp.packets);
-	*bytes = __le64_to_cpu(resp.bytes);
-
-	return 0;
-}
-
-int prestera_hw_acl_port_bind(const struct prestera_port *port, u16 ruleset_id)
-{
-	struct prestera_msg_acl_ruleset_bind_req req = {
-		.port = __cpu_to_le32(port->hw_id),
-		.dev = __cpu_to_le32(port->dev_id),
-		.ruleset_id = __cpu_to_le16(ruleset_id),
-	};
+	if (iface->type == PRESTERA_ACL_IFACE_TYPE_PORT) {
+		req.port.dev_id = __cpu_to_le32(iface->port->dev_id);
+		req.port.hw_id = __cpu_to_le32(iface->port->hw_id);
+	} else {
+		req.index = __cpu_to_le32(iface->index);
+	}
 
-	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_ACL_PORT_BIND,
+	return prestera_cmd(sw, PRESTERA_CMD_TYPE_VTCAM_IFACE_BIND,
 			    &req.cmd, sizeof(req));
 }
 
-int prestera_hw_acl_port_unbind(const struct prestera_port *port,
-				u16 ruleset_id)
+int prestera_hw_vtcam_iface_unbind(struct prestera_switch *sw,
+				   struct prestera_acl_iface *iface,
+				   u32 vtcam_id)
 {
-	struct prestera_msg_acl_ruleset_bind_req req = {
-		.port = __cpu_to_le32(port->hw_id),
-		.dev = __cpu_to_le32(port->dev_id),
-		.ruleset_id = __cpu_to_le16(ruleset_id),
+	struct prestera_msg_vtcam_bind_req req = {
+		.vtcam_id = __cpu_to_le32(vtcam_id),
+		.type = __cpu_to_le16(iface->type)
 	};
 
-	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_ACL_PORT_UNBIND,
+	if (iface->type == PRESTERA_ACL_IFACE_TYPE_PORT) {
+		req.port.dev_id = __cpu_to_le32(iface->port->dev_id);
+		req.port.hw_id = __cpu_to_le32(iface->port->hw_id);
+	} else {
+		req.index = __cpu_to_le32(iface->index);
+	}
+
+	return prestera_cmd(sw, PRESTERA_CMD_TYPE_VTCAM_IFACE_UNBIND,
 			    &req.cmd, sizeof(req));
 }
 
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
index 57a3c2e5b112..6b7a9f8e2ea2 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
@@ -5,6 +5,7 @@
 #define _PRESTERA_HW_H_
 
 #include <linux/types.h>
+#include "prestera_acl.h"
 
 enum prestera_accept_frm_type {
 	PRESTERA_ACCEPT_FRAME_TYPE_TAGGED,
@@ -111,18 +112,24 @@ enum prestera_hw_cpu_code_cnt_t {
 	PRESTERA_HW_CPU_CODE_CNT_TYPE_TRAP = 1,
 };
 
+enum prestera_hw_vtcam_direction_t {
+	PRESTERA_HW_VTCAM_DIR_INGRESS = 0,
+	PRESTERA_HW_VTCAM_DIR_EGRESS = 1,
+};
+
 struct prestera_switch;
 struct prestera_port;
 struct prestera_port_stats;
 struct prestera_port_caps;
 enum prestera_event_type;
 struct prestera_event;
-struct prestera_acl_rule;
 
 typedef void (*prestera_event_cb_t)
 	(struct prestera_switch *sw, struct prestera_event *evt, void *arg);
 
 struct prestera_rxtx_params;
+struct prestera_acl_hw_action_info;
+struct prestera_acl_iface;
 
 /* Switch API */
 int prestera_hw_switch_init(struct prestera_switch *sw);
@@ -186,21 +193,23 @@ int prestera_hw_bridge_delete(struct prestera_switch *sw, u16 bridge_id);
 int prestera_hw_bridge_port_add(struct prestera_port *port, u16 bridge_id);
 int prestera_hw_bridge_port_delete(struct prestera_port *port, u16 bridge_id);
 
-/* ACL API */
-int prestera_hw_acl_ruleset_create(struct prestera_switch *sw,
-				   u16 *ruleset_id);
-int prestera_hw_acl_ruleset_del(struct prestera_switch *sw,
-				u16 ruleset_id);
-int prestera_hw_acl_rule_add(struct prestera_switch *sw,
-			     struct prestera_acl_rule *rule,
-			     u32 *rule_id);
-int prestera_hw_acl_rule_del(struct prestera_switch *sw, u32 rule_id);
-int prestera_hw_acl_rule_stats_get(struct prestera_switch *sw,
-				   u32 rule_id, u64 *packets, u64 *bytes);
-int prestera_hw_acl_port_bind(const struct prestera_port *port,
-			      u16 ruleset_id);
-int prestera_hw_acl_port_unbind(const struct prestera_port *port,
-				u16 ruleset_id);
+/* vTCAM API */
+int prestera_hw_vtcam_create(struct prestera_switch *sw,
+			     u8 lookup, const u32 *keymask, u32 *vtcam_id,
+			     enum prestera_hw_vtcam_direction_t direction);
+int prestera_hw_vtcam_rule_add(struct prestera_switch *sw, u32 vtcam_id,
+			       u32 prio, void *key, void *keymask,
+			       struct prestera_acl_hw_action_info *act,
+			       u8 n_act, u32 *rule_id);
+int prestera_hw_vtcam_rule_del(struct prestera_switch *sw,
+			       u32 vtcam_id, u32 rule_id);
+int prestera_hw_vtcam_destroy(struct prestera_switch *sw, u32 vtcam_id);
+int prestera_hw_vtcam_iface_bind(struct prestera_switch *sw,
+				 struct prestera_acl_iface *iface,
+				 u32 vtcam_id, u16 pcl_id);
+int prestera_hw_vtcam_iface_unbind(struct prestera_switch *sw,
+				   struct prestera_acl_iface *iface,
+				   u32 vtcam_id);
 
 /* SPAN API */
 int prestera_hw_span_get(const struct prestera_port *port, u8 *span_id);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_span.c b/drivers/net/ethernet/marvell/prestera/prestera_span.c
index 3cafca827bb7..845e9d8c8cc7 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_span.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_span.c
@@ -7,6 +7,7 @@
 #include "prestera.h"
 #include "prestera_hw.h"
 #include "prestera_acl.h"
+#include "prestera_flow.h"
 #include "prestera_span.h"
 
 struct prestera_span_entry {
-- 
2.7.4

