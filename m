Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5C2486758
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 17:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240981AbiAFQHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 11:07:35 -0500
Received: from mail-mw2nam10on2070.outbound.protection.outlook.com ([40.107.94.70]:31745
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240980AbiAFQHf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 11:07:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O+P8GABFI73wkW5Tug7UJqTEMMgoR6oBsz/2darTVg67DGDQWKsiFfg2zAW+QU/KBUQaAf2ZHUYdTIzHdMDTG0Q/o5Y6H0J2fu/XzjnPu6g09Gto9l3y+mRHaheYoaSAtAzeO7SBVMzK6qMqu2dFybSeFAKmJLPfJqNMYPjBB4PG5N4lGIEdyuX4BZWte6GPp0aVLu73lIHe05N79o4lARC1HJ16qxXxGFqVpJw6UpBpfLYC03kliH5wPZQhVZeerXYNMhu7pc4DDoQxfDh+azLRD4PW5hViOUNefbz3jNMpp4EA9X0Go12ekGNkSPa8uu3qwU0nNV5+IvTXQPzGLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FXADXkk5sSj22FWkYO177+uXKBzhvIa77eGTjMsb8/c=;
 b=AIJCALXzK5Cg1DAUFHc1liUJLJW1RcEpqmV6LKInUQPoTboiNUEEVKCtlCayBjVhFkUNugUIycHEJPYiMu27JaSRZ7oYkkKetP/pB350aigP3xu7eJJxfMsPJiyFKvMT2RjvqxAjgoV/lOju7yaaWOLgqPt4YZIfnvwwCN+LJ5QBP27w25huyn2fNiON+M+Y1jYiJjmu3EWDLPZzBBkIn4MHep4rhLWfPK2j9eMnwbID+RczOfqk3jyC568DCHp/SYfVPlssQz1+1Y372r3qvltXHfb0wT0gRZhmS6uDhOJ5WK9k6Lw5TgaBEzi6C2OeDIJ4gEmjN2AZfS5YwbPsvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FXADXkk5sSj22FWkYO177+uXKBzhvIa77eGTjMsb8/c=;
 b=NRy88Da8Axg/+F4OCN/q8cphzQwUiiTSb0Sg8alcN5LgXoSD5rSh9mOGyYo60MdTpgCdqMZsABWdiYV5gULzgiYcvoKlzC7LUEh0GqYIhW5CF/Tn8TwPX7dQxJZ6R0joryG7H0u+HLDUV4ANrn8uurX3d9RypG2LLhDYwg+xo75nHiNNbSjJuaL6OX2jmAX8qQpWpgL8QbZjro0YwIcQiFDcnQDFJquuVKsicDFerkjjn8ggCGA3JCI+U8OgG/A+1s9bJwLxh/jw8k2IbGeFHfkv8363UfoOPPBxLZLfNBwjsGqu9+D+V8aem944Atdh3ig9hgw4hlx5QXquOhFiaw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM5PR12MB1641.namprd12.prod.outlook.com (2603:10b6:4:10::23) by
 DM6PR12MB4058.namprd12.prod.outlook.com (2603:10b6:5:21d::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4867.7; Thu, 6 Jan 2022 16:07:33 +0000
Received: from DM5PR12MB1641.namprd12.prod.outlook.com
 ([fe80::41f2:c3c7:f19:7dfa]) by DM5PR12MB1641.namprd12.prod.outlook.com
 ([fe80::41f2:c3c7:f19:7dfa%11]) with mapi id 15.20.4844.016; Thu, 6 Jan 2022
 16:07:33 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 4/8] mlxsw: spectrum_acl_bloom_filter: Make mlxsw_sp_acl_bf_key_encode() more flexible
Date:   Thu,  6 Jan 2022 18:06:48 +0200
Message-Id: <20220106160652.821176-5-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220106160652.821176-1-idosch@nvidia.com>
References: <20220106160652.821176-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR1P264CA0037.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:3e::34) To DM5PR12MB1641.namprd12.prod.outlook.com
 (2603:10b6:4:10::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 385b3372-93a0-41d7-8c50-08d9d12ea618
X-MS-TrafficTypeDiagnostic: DM6PR12MB4058:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4058A6DFA2D10DA0968991A9B24C9@DM6PR12MB4058.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3zbsAHASdUA4hIBSvful+8fVXYnCh2H5b0ZXg7ASdYu/AE0DWTu27xviVBJIuPw/jGtIkd80H49FAe+66eCYoIwchPDKjp+VYIQTE52ED+KNkymDzncrTgj8rYMDbGdVewq9avKV8HOElb5QXVcRH79AcUhzgT7tTaOXksYZJUBo4L1xjErmebBL02pMuYto3Up7xI3NRWr42MfbgFnOtr/cb/c/eCOSeCOZnTK4SvHzpGLIpm/2A19nJgBRdhG/iod4j43SCSo21cn4mWSmjYQuBhvTDG9lq0QM238k5MQ+/t2wBkw/H3MDSPoiqrvDiudpMxv1gjas/pdtI+MI/Yr5smc2Qu6bnh5oYyc1VTcBuimg/rxn8lP8lbyRPMfRseKe6t/iGrOBDwpHVyr2971jSbEbflLZJRi35ijKjm9fSigKWfPzQCxqalteSoL+wVxIuSCiX/mnAbtr90qcoDGIHSqvJkrCyQYDVRPuHF3xRs4+RraCkse0ID0aFVCz0ze3sGQdGXCvntWzJnyK3lBhlafUHaNFCbB6PRBXPcb0MYnFpVlv9LbMJKqSu7ze2mqNZtmTHtyhyJv59pEXQhewvdYV86JmNlJ5ibhFK5jdlUIYH7R10m5gr/2WBAeF3MFFHklLpdWD9Syu4JentA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1641.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(6666004)(508600001)(66946007)(66476007)(5660300002)(36756003)(66556008)(6916009)(316002)(86362001)(4326008)(26005)(38100700002)(8676002)(2616005)(83380400001)(6512007)(6486002)(2906002)(1076003)(107886003)(8936002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Z7M+LXImj4Y+ibIkiOMm91wERGLC4prZM2qpglZfQKBGqQW229t+KfhGrkc6?=
 =?us-ascii?Q?hSe3jSLiVYkGPcMBSAZlteVloXt+RKkBZBuYwh/qZtFMk/G9GN4yOetWCMM8?=
 =?us-ascii?Q?+fxjR5Wqy4wB8u3vnLo3bvbrrbYJ7u0VRS2ullAHBuA/6r0VffgPPR1UDCNe?=
 =?us-ascii?Q?uM6/CibT5yoWsDnEsrzUPpupe3JcgH2h999WfqIFoWIVfWqkkvLPUbFb0q5C?=
 =?us-ascii?Q?aUT5nBrQcbeuv3J6NqyTy01Yx2pthFlwlt4BUApQXWe8IIrBGKUoqBvUUZe8?=
 =?us-ascii?Q?nX/CAVHrdBV6U+62pjrVCS/9T2JXxpOTkFWSsEATBq0qucXf/Xktr8RMWfOh?=
 =?us-ascii?Q?iFXXx25ntAWBKTuBEHvZRP2xfc4Wca+EdfXOouG2MFpNHbV4mnlLHboILKck?=
 =?us-ascii?Q?8q1bBbOA8u1A3/kOI56WaSJp1YKiquctW6RW6Q8hB4yyFlHCfwjypLXLCZsJ?=
 =?us-ascii?Q?k1bWKWYKZFbCQWJNat0a3+/CgwZ3OpKzy5W8X9f5Fe7drfZB+WhfkX9dAhTA?=
 =?us-ascii?Q?3RkL4pr/H1QZaG1Nmayz20eIlR/p9UUsz2+PNKRKvTkmHMG3+6z2tXj8oT6q?=
 =?us-ascii?Q?FpLATvqkZQky58LikPO9+D2zHL35f4MN6GiKO3TPWrG8mwD67//7CSXPFj/H?=
 =?us-ascii?Q?cmToBnksQpI7hAF13U4XRdDz8hubcEaruC6R6zYN4hgn77L7tWkcjAwdmmut?=
 =?us-ascii?Q?gGM5KyiBkdxDpjo4R5NWX3r4HVJ/7YYY9V9owZMHvpG0Omch7bKowwiIVedJ?=
 =?us-ascii?Q?O0SUgoVbyISS4vw7/oTWc+A3amysyvbBFabNGlG0WU6rDkBAGyx7RpDMTaoF?=
 =?us-ascii?Q?hcoVGkYxs6KDJhcM4E1qhy+kB0rmqEAj429QjOk0u+OYSTr0YBRa7AQHPyPI?=
 =?us-ascii?Q?ziwLiQfv285ApJ1AT9JlgpogtTLmNfHzjBzZ/gJ38oWlU2Xn6FVLNLqMvREB?=
 =?us-ascii?Q?rQjUIo+pQ9qDV23wRrMLrDAL0wbr6UeIZS8WZrFgrwE3qz2MYUZXi6USzsUe?=
 =?us-ascii?Q?vBWuYhhymU77v8zn6cp9s8bZU8t0Us5BCUss2nYBeMRvFo2Qa9xniuaDzaWJ?=
 =?us-ascii?Q?q4j0kc2qHl47B956qmNiT71//v9PP42QqQvo6BxZVo2qGSwCv/5pJaMSKyAx?=
 =?us-ascii?Q?LWqjIYPFxobBOOV++R9c7jzTixWtwHHadQZVG4NwDTfTXqJ0xeEcdtcGxkyC?=
 =?us-ascii?Q?HlZJGOavhzyPoIPX+G9nwVr5sz7BKCKtaj5LNSA9SQPBq3zPemL1J+4tBLF5?=
 =?us-ascii?Q?xI2TNy3SmP7NCXDI/fo0hr4T2uDd7V6ZvdQ0iZ41QMn6Q6GeaC0pw6pcqnFz?=
 =?us-ascii?Q?xsHMJNrS9YdarHVMFbNyomI+gVN7ubhAIZa0Y3DmZSpBoeRA3BFcg2iBLPJB?=
 =?us-ascii?Q?77A/ArMXsUX8WGQh3dveiu0ByGFrOPspMj2FmEmHMsbU5+kpBKLSN2pEqYAk?=
 =?us-ascii?Q?zDI4ZAmtZSIlM8KDniPp8q4igpIszQtjtjkD1G5NWWPpmPpIV7H9JekoxgCh?=
 =?us-ascii?Q?CqZ4R4qV7eF4PzrxjLiUgRb48/VjsrYNtJI3PLeG29HSzgd/X6GUqz/zLvj8?=
 =?us-ascii?Q?0+BeqCd7Ms6amuhxiN7B+IaMq5uWUyQvoUunBXo9l6TritwGviEVcdyz8l7t?=
 =?us-ascii?Q?yHZv6KMqrQSbwy2Qzc+LTSE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 385b3372-93a0-41d7-8c50-08d9d12ea618
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1641.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2022 16:07:33.6213
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P/NwChT57HfXsQ4JoE67U/VTEI5zpRAAETbKkv1inR3Ua6UAbBNedsrsmnWtFCZxjffpgag8JnJjxyGqKN3UZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4058
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Spectrum-4 will calculate hash function for bloom filter differently from
the existing ASICs.

One of the changes is related to the way that the chunks will be build -
without padding.

As preparation for support of Spectrum-4 bloom filter, make
mlxsw_sp_acl_bf_key_encode() more flexible, so it will be able to use it
for Spectrum-4 as well.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../mlxsw/spectrum_acl_bloom_filter.c         | 36 +++++++++++++------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_bloom_filter.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_bloom_filter.c
index 732c261f83cf..f0cd14a791df 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_bloom_filter.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_bloom_filter.c
@@ -116,9 +116,10 @@ static u16 mlxsw_sp_acl_bf_crc(const u8 *buffer, size_t len)
 }
 
 static void
-mlxsw_sp_acl_bf_key_encode(struct mlxsw_sp_acl_atcam_region *aregion,
-			   struct mlxsw_sp_acl_atcam_entry *aentry,
-			   char *output, u8 *len)
+__mlxsw_sp_acl_bf_key_encode(struct mlxsw_sp_acl_atcam_region *aregion,
+			     struct mlxsw_sp_acl_atcam_entry *aentry,
+			     char *output, u8 *len, u8 max_chunks, u8 pad_bytes,
+			     u8 key_offset, u8 chunk_key_len, u8 chunk_len)
 {
 	struct mlxsw_afk_key_info *key_info = aregion->region->key_info;
 	u8 chunk_index, chunk_count, block_count;
@@ -129,17 +130,30 @@ mlxsw_sp_acl_bf_key_encode(struct mlxsw_sp_acl_atcam_region *aregion,
 	chunk_count = 1 + ((block_count - 1) >> 2);
 	erp_region_id = cpu_to_be16(aentry->ht_key.erp_id |
 				   (aregion->region->id << 4));
-	for (chunk_index = MLXSW_BLOOM_KEY_CHUNKS - chunk_count;
-	     chunk_index < MLXSW_BLOOM_KEY_CHUNKS; chunk_index++) {
-		memset(chunk, 0, MLXSW_BLOOM_CHUNK_PAD_BYTES);
-		memcpy(chunk + MLXSW_BLOOM_CHUNK_PAD_BYTES, &erp_region_id,
+	for (chunk_index = max_chunks - chunk_count; chunk_index < max_chunks;
+	     chunk_index++) {
+		memset(chunk, 0, pad_bytes);
+		memcpy(chunk + pad_bytes, &erp_region_id,
 		       sizeof(erp_region_id));
-		memcpy(chunk + MLXSW_BLOOM_CHUNK_KEY_OFFSET,
+		memcpy(chunk + key_offset,
 		       &aentry->enc_key[chunk_key_offsets[chunk_index]],
-		       MLXSW_BLOOM_CHUNK_KEY_BYTES);
-		chunk += MLXSW_BLOOM_KEY_CHUNK_BYTES;
+		       chunk_key_len);
+		chunk += chunk_len;
 	}
-	*len = chunk_count * MLXSW_BLOOM_KEY_CHUNK_BYTES;
+	*len = chunk_count * chunk_len;
+}
+
+static void
+mlxsw_sp_acl_bf_key_encode(struct mlxsw_sp_acl_atcam_region *aregion,
+			   struct mlxsw_sp_acl_atcam_entry *aentry,
+			   char *output, u8 *len)
+{
+	__mlxsw_sp_acl_bf_key_encode(aregion, aentry, output, len,
+				     MLXSW_BLOOM_KEY_CHUNKS,
+				     MLXSW_BLOOM_CHUNK_PAD_BYTES,
+				     MLXSW_BLOOM_CHUNK_KEY_OFFSET,
+				     MLXSW_BLOOM_CHUNK_KEY_BYTES,
+				     MLXSW_BLOOM_KEY_CHUNK_BYTES);
 }
 
 static unsigned int
-- 
2.33.1

