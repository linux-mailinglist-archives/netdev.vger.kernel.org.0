Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4D028226B
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 10:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725778AbgJCITE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 04:19:04 -0400
Received: from mail-eopbgr30071.outbound.protection.outlook.com ([40.107.3.71]:37957
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725601AbgJCITE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 3 Oct 2020 04:19:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XctzHuZuopZ3+ufRPJLSUNhRlV+KKhzrvDkyx6YIGi5M5qzHw8k8/JYA6K+TlUIiDE8VoIzgtqPirDYrKr3NBtPVbAd0zNarjPckFxm3quZsXbkNXVjg3pcOMMx7AtGx+wJEKKChj2WH7uBIqqoudC0oKCBkS4bCablVxCQuqPv037Pn5PLofJttKoVg+le7JVBbG7YQy4GHqSZ7IyhhMz3aZnnAVWckZI6xKJ6NMXg/lHMbrMxU5/e5d0sO6QWaL2sTyWETgYPphNgUTZUqBZh5amRBuF4aq7eVFjMwYFF5JCnJs3lmXoxp2PqWGW6q67IsL3NNL5uod2o527n7dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5vToyNCY9DwGqvCLPaRYHhUNLRRsmTQslXJVVQ7kkks=;
 b=f7HyDpcuCLe+vFZ1p2sSu0yR/9FXt0vukycZmJAOnBgP/90lBXt3mxGwOcrzQ9Fa/kWLfTaWyyuhFaZ3fO4jZnF63oPKlrXuxX/Rbq4MoMW+TyCvGpzVfX+HR/0F3TffpDQZxgtFwAkgKxmLwykdQ+ZFz8i0Q3x7AxiXU2IwsrioxD14udzhLVCXzVNh0anLjzpkX8j9SXk1pR/X4NWXmL7o41/UuNXrEm3fNbLVwXAwOwZiqToUUiJAFX2z2YC9MS8ew2Kzi1zuoHvg4fBqSBU3oqcLXSi7lkJDyyrKO+gevEh0AstFimjUiXJIgGBPtcvHRpvwl1dp1snpzUtQjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5vToyNCY9DwGqvCLPaRYHhUNLRRsmTQslXJVVQ7kkks=;
 b=cTFFmND7WVRmUWn33RxS39J5QgjjV5oxkqDPBtOiyjgfRqdvDux7jeq1EYL6Apab6ZvWiUcvYjM8osNBt+CTjMN8ZAsMw1clmH05Oe4EK/M08nGrfBbQcwCBzAdOP1Z/sWrPS2fvtnNjJGf5IXnmHTCTVH/Na+QdJWQmId91378=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB7343.eurprd04.prod.outlook.com (2603:10a6:800:1a2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.35; Sat, 3 Oct
 2020 08:18:59 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.038; Sat, 3 Oct 2020
 08:18:59 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next] net: dsa: sja1105: remove duplicate prefix for VL Lookup dynamic config
Date:   Sat,  3 Oct 2020 11:18:36 +0300
Message-Id: <20201003081836.4052912-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.229.171]
X-ClientProxiedBy: AM3PR05CA0112.eurprd05.prod.outlook.com
 (2603:10a6:207:2::14) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.229.171) by AM3PR05CA0112.eurprd05.prod.outlook.com (2603:10a6:207:2::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.36 via Frontend Transport; Sat, 3 Oct 2020 08:18:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3a7c4469-89cd-4e5d-3761-08d86774fa29
X-MS-TrafficTypeDiagnostic: VE1PR04MB7343:
X-Microsoft-Antispam-PRVS: <VE1PR04MB73436B65BEF631A2313C97CAE00E0@VE1PR04MB7343.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Cm9TxnNEL8l0pdBsJbOzmkxd1jaI7lLUuwzjcYI8KZZtC14RMl7f4k4wU6JfxIP+P6bjrnAOiuOMDgdk4kD8WnoskRgEh+DIQYAdM6w4TQDQVFn3hqFWUMzm+S6UvV7sEBBWQwqHMiGWFU3/CiO38OPKf8AynFHNvXjiZBLy9JW/pBzzzNqaovDnWsNmujZNzGgDQerig6JKLX06299iNwzVJlGGrsOqwpK26Al9bKNNz3ea6nVlus9qTfKgD4j80mVRWyhhEnyb+qU8FoYIfMcwL8H5fpfPQu2Ggz7B+fU3MDkFZO6nI82SnAMEUXxOeiSBEnVYlvymB2sU49DfYjc0Y35UnPbo8uuYi4SnSaZ2XBWwrQ+AGfSrb1U2oGny
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(39860400002)(396003)(376002)(136003)(8676002)(26005)(69590400008)(6506007)(2906002)(36756003)(86362001)(44832011)(6486002)(66946007)(956004)(52116002)(4326008)(1076003)(2616005)(6666004)(83380400001)(16526019)(8936002)(186003)(6916009)(478600001)(66556008)(66476007)(316002)(5660300002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: I6bWxK/ZYUTqqT006sdOc+flylIuFuBAK7e5evjFubTWCeA94QXrR/xzmiuZh1n7JAWMvYnmo5e+Z5DLRTTCxSPkKeaz5QLLhjLgK2NO8hXEzNnINRDDYhIN5zsCF0I8JzLgQkoUsgO3sFLaY49LgbrDqSiHDrSPHODGiMy6/FTqGFt10C4yAYV+UUBsB0IRhlWBe787c9W3fxNvos0DjNeKV9UimqiEWiE6VIbtLQBYGsfj+/J+ouq1enUMnZYoI48dKA9pvOZ8BHNGa25okMOKHAsQv5153PpYKxO6PIFDAtoQOEJq62K7pBh2dxHjq7MvitlEjtKsXC29BtV1tU+deM9ZIjZWkYI12avkFSe2hvFpmQNAH7Y+y20mWtFKgze1VhsMsW7npj/3fTammv+2ImLB4/iZZFNlYJZYavQSFyY7ADr+LC6c7Tb9cNWbKkuSvmQWxMqsAKrdV9U1FPNZSVO7pAfA/0YyIST7C7PJdsOcAlUNd+7t+klh9syumXh0CBXIg6GVO3L+Miq0Xe7nKXcqZr2c5FUJB+lq2xsQVUgUY7N7dR+1wkcnRUAzklCJB3lQFDVSFPW7eqaEFlGKP6CcTknlfqSRKaXn7mayMVyqJRyB2Ua3uQjUqYrGJ2nOhnHvh6OEHRhvmalOeg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a7c4469-89cd-4e5d-3761-08d86774fa29
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2020 08:18:59.0314
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tM248Qu/OFrsDTy5CZmxI8jeIY9q94+wmt7KNWbw8lcPYmHBgj6iUkPVd80BFjRJECK12WK5rL2RAupd+o0vyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7343
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a strictly cosmetic change that renames some macros in
sja1105_dynamic_config.c. They were copy-pasted in haste and this has
resulted in them having the driver prefix twice.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_dynamic_config.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
index 75247f342124..b777d3f37573 100644
--- a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
@@ -97,10 +97,10 @@
 
 #define SJA1105_SIZE_DYN_CMD					4
 
-#define SJA1105ET_SJA1105_SIZE_VL_LOOKUP_DYN_CMD		\
+#define SJA1105ET_SIZE_VL_LOOKUP_DYN_CMD			\
 	SJA1105_SIZE_DYN_CMD
 
-#define SJA1105PQRS_SJA1105_SIZE_VL_LOOKUP_DYN_CMD		\
+#define SJA1105PQRS_SIZE_VL_LOOKUP_DYN_CMD			\
 	(SJA1105_SIZE_DYN_CMD + SJA1105_SIZE_VL_LOOKUP_ENTRY)
 
 #define SJA1105ET_SIZE_MAC_CONFIG_DYN_ENTRY			\
@@ -183,7 +183,7 @@ static size_t sja1105et_vl_lookup_entry_packing(void *buf, void *entry_ptr,
 						enum packing_op op)
 {
 	struct sja1105_vl_lookup_entry *entry = entry_ptr;
-	const int size = SJA1105ET_SJA1105_SIZE_VL_LOOKUP_DYN_CMD;
+	const int size = SJA1105ET_SIZE_VL_LOOKUP_DYN_CMD;
 
 	sja1105_packing(buf, &entry->egrmirr,  21, 17, size, op);
 	sja1105_packing(buf, &entry->ingrmirr, 16, 16, size, op);
@@ -644,7 +644,7 @@ const struct sja1105_dynamic_table_ops sja1105et_dyn_ops[BLK_IDX_MAX_DYN] = {
 		.cmd_packing = sja1105_vl_lookup_cmd_packing,
 		.access = OP_WRITE,
 		.max_entry_count = SJA1105_MAX_VL_LOOKUP_COUNT,
-		.packed_size = SJA1105ET_SJA1105_SIZE_VL_LOOKUP_DYN_CMD,
+		.packed_size = SJA1105ET_SIZE_VL_LOOKUP_DYN_CMD,
 		.addr = 0x35,
 	},
 	[BLK_IDX_L2_LOOKUP] = {
@@ -728,7 +728,7 @@ const struct sja1105_dynamic_table_ops sja1105pqrs_dyn_ops[BLK_IDX_MAX_DYN] = {
 		.cmd_packing = sja1105_vl_lookup_cmd_packing,
 		.access = (OP_READ | OP_WRITE),
 		.max_entry_count = SJA1105_MAX_VL_LOOKUP_COUNT,
-		.packed_size = SJA1105PQRS_SJA1105_SIZE_VL_LOOKUP_DYN_CMD,
+		.packed_size = SJA1105PQRS_SIZE_VL_LOOKUP_DYN_CMD,
 		.addr = 0x47,
 	},
 	[BLK_IDX_L2_LOOKUP] = {
-- 
2.25.1

