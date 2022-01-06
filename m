Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DCF848675A
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 17:07:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240980AbiAFQHm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 11:07:42 -0500
Received: from mail-bn8nam11on2044.outbound.protection.outlook.com ([40.107.236.44]:40092
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240977AbiAFQHl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 11:07:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h+sIWTrW4FzRJplnW9YIgp3M95GP5VfTQrODo9r5t0tB5Jn1Py2O44bBEydjgS5MMdhYnQlNbmplmkDZUOArkjq5NaDALNL40vTz4aT4MZgOPgydpkP1bhB0mFW0lJz2pDg1REZZbO6h7FZH6TvwGZtiUjM3wxpzpKTGPqi/z1YD79t1NPjLytYZ2pHx+LnWWeg02gbnrGL6tAFP61+V7lRTAeKCDVtp/c1Y7kXATJ2CN0Lqk6cahzBxPkD0bLZB1yYYe4TfNtGY/F7L7XR4bdGL0/xAc/l/prMK5yGWgy7q4F/IOvik//n6v5UGmFbu7Lsf7PqMe4P1tTuWAYNR3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CF+rNNUbfO+3nGlpZCgoHWS97LW6WKHzW08HZKB5yCs=;
 b=Dw4Y+mUKDenu6/0vT49IJJIgbHmPUe0c/ofIdoHgEHtNWOjYnh4VuSoy6ETNiO7xt7/Rkk2zZVwH+2J17eGsUXCchy/SkyGXPo1S0bdn1yb5tichBSrPgIaBvB1Pehnhn/iI6Ov290Ac0mrolCpXLXtJHCse91zHIH6lPtM+otAMdztFN8Q3S8J2cR/RAsEwYdzSBMN3yoTiRS/ALMS4fHD4d/t2lAFRBJSW25weXKxUohIWFoWsSo7xDJLaE/Tf6MkTNyAa2yFg+FP1DQmbHHAbDn4rOh3nfxm/kBfNLtG7ATr0kuNs/tvshBzm7zCjFafopSgIZ0cRQYkPeq3mQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CF+rNNUbfO+3nGlpZCgoHWS97LW6WKHzW08HZKB5yCs=;
 b=VAHF85Fl3+qbgCzunV+m2BWS1rRi9rfxzrFFLvid3g2KwwbjDAAVGxhEdoUB6DG1gW/spgWMF6Jb/ALB6bGkp4+GksPL0N+1pNWLa5/pQ3JkMUojWPtkS0QTXUDhFYDYXSSsOyE28ygbRRBosJuRljjM20IwzzG2Ac1T7YUvXfDV0Qz1U5MWq1eEsciToc4A9bEwcaHAVPqQU52UapD5a5zXvTr41u9kK5hbbw/qf4795YrdiwLWszgBEIyCKYgQ+7L++/oKOLTydJSwSU0RU6CgGxwu/e8Ak/9jQjcxcduuv09AeT+O7mE2xEhKX423qMOEKhqzXGL6ip2xWQCm4Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM5PR12MB1641.namprd12.prod.outlook.com (2603:10b6:4:10::23) by
 DM6PR12MB4058.namprd12.prod.outlook.com (2603:10b6:5:21d::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4867.7; Thu, 6 Jan 2022 16:07:40 +0000
Received: from DM5PR12MB1641.namprd12.prod.outlook.com
 ([fe80::41f2:c3c7:f19:7dfa]) by DM5PR12MB1641.namprd12.prod.outlook.com
 ([fe80::41f2:c3c7:f19:7dfa%11]) with mapi id 15.20.4844.016; Thu, 6 Jan 2022
 16:07:40 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 5/8] mlxsw: spectrum_acl_bloom_filter: Rename Spectrum-2 specific objects for future use
Date:   Thu,  6 Jan 2022 18:06:49 +0200
Message-Id: <20220106160652.821176-6-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220106160652.821176-1-idosch@nvidia.com>
References: <20220106160652.821176-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR2P264CA0076.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:32::16) To DM5PR12MB1641.namprd12.prod.outlook.com
 (2603:10b6:4:10::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 06e76d9c-a501-4e3d-e8dc-08d9d12ea9f5
X-MS-TrafficTypeDiagnostic: DM6PR12MB4058:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB405839AAD27F3F3A0FAD29C5B24C9@DM6PR12MB4058.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SfWwjN1bTuVJgIJWghyOZF3/inq+eUPyDCUHnJp9Qr7ucG/9LSuXZ1d70CQT11Ye0F4Xukom8fi3wuJ1QHA1s83zb3LCcSXfS15ND7CCgs3kEwKYD1mNuTd35tDzwbRbbttV+9Dh8I5K3IfmBPS/CxA9jttMnW3P4lp/VSNU5YkMoEUWPoyWbByBD8yIf9Hyfj58SXlUrBP9p+isRqYLTpRsmH1a+JNJ6tKpkTeeIIr++efVFA2b5iN8vEPJ7b5DrBzJPz0k5MkjKY2pj+GyT3ICIKylddkQizTRWvTk9SJppgrjwHCS6z+U1pU/uXYAQ6RXu2pTsIDJ0E+rm2aNYsi557OoRsK1knYum0h3+BKTP+war9u9Lpty1XuPrxvXcv0T1MrcNPFZmtB1hQVFk5Lf72gXEjkaD0UZDDYM4uxxH52EZIIdm95VwlDgvvx6SXPe5EU+oj8V3Q0Ea8afQlRlVkNcc3btJvowok+DZ3EEdRvIjsuo8yDIGP7saL4dLmd/2Atpxk2s2SrtDXgXhygeeaCQvGGkQ0m4fPE9RhRplFTPDPenNPv17aImpgHhfSw7R7lxDKP+6sMaKT0ZJdyeW6xBptWuGL+SxciOM5HzO6Z+D2kdU8MVisG+QkqcC53G4uDjlY7D32Aow5Anvg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1641.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(508600001)(66946007)(66476007)(5660300002)(36756003)(66556008)(6916009)(316002)(86362001)(4326008)(26005)(38100700002)(8676002)(2616005)(83380400001)(6512007)(6486002)(2906002)(1076003)(107886003)(8936002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?m+/9BVO3XiKHuwGXLxlvVhg7ZnfDWHy3lVNZQZQNfLvjKDNCrknYIelvHzeI?=
 =?us-ascii?Q?xaogY6bAaXB0zHtLU+C6cBITz9Lrq89AzWSRr5XbXW0NOLfBd3hfgpr9V9JN?=
 =?us-ascii?Q?76OBwJBeEa+UpR2DTOurNPWtWz9xR612/1C/3KtgrARnxwQdchAnSf9t3tOB?=
 =?us-ascii?Q?y56Fruif/IYjzRHWf0qUwKHxwW5gM2JazE4CJE2B6PUjkoZnlP0cTH3kCUjx?=
 =?us-ascii?Q?FBWn1Z9bWPtl8/s4I46lSoOu6y3kdy975bSEbLZLbNFb09knikAex2gkHmMF?=
 =?us-ascii?Q?+/DcGiYdDA46E0jluM+7pfBIbjZUTp/5SKzwPj1Bh8/MMgW+bTS+lgfdcJp3?=
 =?us-ascii?Q?n7+4OXCfWjPWh2cxFRY/G866JsZ9IO1hKU1JNUQu5zi0Q0Vp3q10hQiTbeW9?=
 =?us-ascii?Q?UzwObJPd5sQZ/Wxu8E8k/2LygQXKLDh2YH5gUX0yvwoqds+SQFIq2UAmyBUD?=
 =?us-ascii?Q?T2oWGJ5s4Ew6n+2tnsOFGhUrZkVuDwKiIrlcv1MeRA1XamR5E1r6xtPKATt9?=
 =?us-ascii?Q?jwQiU4AljIWXoehqh1tNoR7ZDwTptb/K3JyPDFENvbWFZ7cVGpoXAae+ITQ/?=
 =?us-ascii?Q?FBgVG84XqilJNNu91i/2NeKXg8KBXDzusvgTPqLl9rO3Nwhgn66ikEhWFoey?=
 =?us-ascii?Q?WhZRamP3NAkzrerFSt03CtiDKRz154yRQQCjAHC9GbN5RKDE1zc2OSeO7hDZ?=
 =?us-ascii?Q?jN1P7J9iHmcGUBeg2fSYYVY5XGbidmJ/C3tnQSqhHXo/I2b0hZDJGgUR+Vdo?=
 =?us-ascii?Q?ObJldAHjjY9HkS3Xg7v/6qkVCKs3vOsI+tDYidSvdu1PCU2QYDMnoM8tN6+u?=
 =?us-ascii?Q?nPODGnGu5NYC7S5j9hYcZXqcDuWOHM9vIw5NT5nI73TOX0PzgJXEwiEDufW5?=
 =?us-ascii?Q?ci2xPdM2SImHQZF3D5qTc1yvxXaPUZZdn7w1neCv0126bL4TXcS5n1nbFRSO?=
 =?us-ascii?Q?XrK0t5em8o62bvy2+WLfuTz+V9DQwMEWq9Xh1JgLU+Srg6yRVEMjp/ZuJmlw?=
 =?us-ascii?Q?CUlWejktfddiAVc3qw5lvH/pe5fcg019w39mowEd9Qi6MIZWu0NME+ycq7Mw?=
 =?us-ascii?Q?kilj+jRgQroGZppVcE6rs0gsKfKEeLT4Cp46+yMLYGH4aSpP5P9OOOlmRA+g?=
 =?us-ascii?Q?oplJZuUirB2S2zyvB69OsF/alaDi/BSpIfxNRbt7/tdnC2w+XmTnqHteXPWT?=
 =?us-ascii?Q?doG5w23DZTSC2ZWmNuIQ6H7nCflIVEBc80cRKqPdAYR7S6/K6FAwKrGGyJ4D?=
 =?us-ascii?Q?4E/xrk3XGmxEWmmSEPSkDpPN8RkbajOHjqZ6EaNip4wl/I5bvcLqmg4cWldu?=
 =?us-ascii?Q?YZ5qnC1HeD9LyDtzwFAeNC4ig9aPoa0Q1daXnzWwYKOsVa3DsXVwBUfnqeCh?=
 =?us-ascii?Q?ce8kDumYR41v2O8xyXgoEklvi0VaIegX4gvDzKCIhIuoikr7chb8Xd7c3WTY?=
 =?us-ascii?Q?IW/l+W7BTYWfFGaONQi1bo+5Ph7p5QpAMysoES1DMBCgnLm0Ji+Ecmp+1eK3?=
 =?us-ascii?Q?VqZWrvHH0+EAC6iVlZm25+/3FMZkr5TiHoJo8OuQfzWv9RlO6nAdYJ6FSE3v?=
 =?us-ascii?Q?eL/qy4V5zVRwr6sE8jExGWiMmzVLEK9uuqL15DyYbZsTCshI6mluK1iTuY3a?=
 =?us-ascii?Q?+gBMtsEzkQEBSXC79V7cFV0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06e76d9c-a501-4e3d-e8dc-08d9d12ea9f5
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1641.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2022 16:07:40.1989
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0e3WlDpsZ/ZIqERFOlGNHZAo2ZSX7NhFbzQogJZFv4Sj6jXM7OKUC18kKvIF7I04zh9e/k+fvbuQQU3W9p4lyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4058
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Spectrum-4 will calculate hash function for bloom filter differently from
the existing ASICs.

There are two changes:
1. Instead of using one hash function to calculate 16 bits output (CRC-16),
   two functions will be used.
2. The chunks will be built differently, without padding.

As preparation for support of Spectrum-4 bloom filter, rename CRC table
to include "sp2" prefix and "crc16", as next patch will add two additional
tables. In addition, rename all the dedicated functions and defines for
Spectrum-{2,3} to include "sp2" prefix.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../mlxsw/spectrum_acl_bloom_filter.c         | 50 +++++++++----------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_bloom_filter.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_bloom_filter.c
index f0cd14a791df..3a3c7683b725 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_bloom_filter.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_bloom_filter.c
@@ -27,7 +27,7 @@ struct mlxsw_sp_acl_bf {
  * +-------------------------+------------------------+------------------------+
  */
 #define MLXSW_BLOOM_KEY_CHUNKS 3
-#define MLXSW_BLOOM_KEY_LEN 69
+#define MLXSW_SP2_BLOOM_KEY_LEN 69
 
 /* Each chunk size is 23 bytes. 18 bytes of it contain 4 key blocks, each is
  * 36 bits, 2 bytes which hold eRP ID and region ID, and 3 bytes of zero
@@ -42,14 +42,14 @@ struct mlxsw_sp_acl_bf {
  * |    0    | region ID |  eRP ID  |      4 Key blocks (18 Bytes)      |
  * +---------+-----------+----------+-----------------------------------+
  */
-#define MLXSW_BLOOM_CHUNK_PAD_BYTES 3
-#define MLXSW_BLOOM_CHUNK_KEY_BYTES 18
-#define MLXSW_BLOOM_KEY_CHUNK_BYTES 23
+#define MLXSW_SP2_BLOOM_CHUNK_PAD_BYTES 3
+#define MLXSW_SP2_BLOOM_CHUNK_KEY_BYTES 18
+#define MLXSW_SP2_BLOOM_KEY_CHUNK_BYTES 23
 
 /* The offset of the key block within a chunk is 5 bytes as it comes after
  * 3 bytes of zero padding and 16 bits of region ID and eRP ID.
  */
-#define MLXSW_BLOOM_CHUNK_KEY_OFFSET 5
+#define MLXSW_SP2_BLOOM_CHUNK_KEY_OFFSET 5
 
 /* Each chunk contains 4 key blocks. Chunk 2 uses key blocks 11-8,
  * and we need to populate it with 4 key blocks copied from the entry encoded
@@ -66,7 +66,7 @@ static const u8 chunk_key_offsets[MLXSW_BLOOM_KEY_CHUNKS] = {2, 20, 38};
  * which is 0x8529 (1 + x^3 + x^5 + x^8 + x^10 + x^15 and
  * the implicit x^16).
  */
-static const u16 mlxsw_sp_acl_bf_crc_tab[256] = {
+static const u16 mlxsw_sp2_acl_bf_crc16_tab[256] = {
 0x0000, 0x8529, 0x8f7b, 0x0a52, 0x9bdf, 0x1ef6, 0x14a4, 0x918d,
 0xb297, 0x37be, 0x3dec, 0xb8c5, 0x2948, 0xac61, 0xa633, 0x231a,
 0xe007, 0x652e, 0x6f7c, 0xea55, 0x7bd8, 0xfef1, 0xf4a3, 0x718a,
@@ -101,17 +101,17 @@ static const u16 mlxsw_sp_acl_bf_crc_tab[256] = {
 0x0c4c, 0x8965, 0x8337, 0x061e, 0x9793, 0x12ba, 0x18e8, 0x9dc1,
 };
 
-static u16 mlxsw_sp_acl_bf_crc_byte(u16 crc, u8 c)
+static u16 mlxsw_sp2_acl_bf_crc16_byte(u16 crc, u8 c)
 {
-	return (crc << 8) ^ mlxsw_sp_acl_bf_crc_tab[(crc >> 8) ^ c];
+	return (crc << 8) ^ mlxsw_sp2_acl_bf_crc16_tab[(crc >> 8) ^ c];
 }
 
-static u16 mlxsw_sp_acl_bf_crc(const u8 *buffer, size_t len)
+static u16 mlxsw_sp2_acl_bf_crc(const u8 *buffer, size_t len)
 {
 	u16 crc = 0;
 
 	while (len--)
-		crc = mlxsw_sp_acl_bf_crc_byte(crc, *buffer++);
+		crc = mlxsw_sp2_acl_bf_crc16_byte(crc, *buffer++);
 	return crc;
 }
 
@@ -144,28 +144,28 @@ __mlxsw_sp_acl_bf_key_encode(struct mlxsw_sp_acl_atcam_region *aregion,
 }
 
 static void
-mlxsw_sp_acl_bf_key_encode(struct mlxsw_sp_acl_atcam_region *aregion,
-			   struct mlxsw_sp_acl_atcam_entry *aentry,
-			   char *output, u8 *len)
+mlxsw_sp2_acl_bf_key_encode(struct mlxsw_sp_acl_atcam_region *aregion,
+			    struct mlxsw_sp_acl_atcam_entry *aentry,
+			    char *output, u8 *len)
 {
 	__mlxsw_sp_acl_bf_key_encode(aregion, aentry, output, len,
 				     MLXSW_BLOOM_KEY_CHUNKS,
-				     MLXSW_BLOOM_CHUNK_PAD_BYTES,
-				     MLXSW_BLOOM_CHUNK_KEY_OFFSET,
-				     MLXSW_BLOOM_CHUNK_KEY_BYTES,
-				     MLXSW_BLOOM_KEY_CHUNK_BYTES);
+				     MLXSW_SP2_BLOOM_CHUNK_PAD_BYTES,
+				     MLXSW_SP2_BLOOM_CHUNK_KEY_OFFSET,
+				     MLXSW_SP2_BLOOM_CHUNK_KEY_BYTES,
+				     MLXSW_SP2_BLOOM_KEY_CHUNK_BYTES);
 }
 
 static unsigned int
-mlxsw_sp_acl_bf_index_get(struct mlxsw_sp_acl_bf *bf,
-			  struct mlxsw_sp_acl_atcam_region *aregion,
-			  struct mlxsw_sp_acl_atcam_entry *aentry)
+mlxsw_sp2_acl_bf_index_get(struct mlxsw_sp_acl_bf *bf,
+			   struct mlxsw_sp_acl_atcam_region *aregion,
+			   struct mlxsw_sp_acl_atcam_entry *aentry)
 {
-	char bf_key[MLXSW_BLOOM_KEY_LEN];
+	char bf_key[MLXSW_SP2_BLOOM_KEY_LEN];
 	u8 bf_size;
 
-	mlxsw_sp_acl_bf_key_encode(aregion, aentry, bf_key, &bf_size);
-	return mlxsw_sp_acl_bf_crc(bf_key, bf_size);
+	mlxsw_sp2_acl_bf_key_encode(aregion, aentry, bf_key, &bf_size);
+	return mlxsw_sp2_acl_bf_crc(bf_key, bf_size);
 }
 
 static unsigned int
@@ -190,7 +190,7 @@ mlxsw_sp_acl_bf_entry_add(struct mlxsw_sp *mlxsw_sp,
 
 	mutex_lock(&bf->lock);
 
-	bf_index = mlxsw_sp_acl_bf_index_get(bf, aregion, aentry);
+	bf_index = mlxsw_sp2_acl_bf_index_get(bf, aregion, aentry);
 	rule_index = mlxsw_sp_acl_bf_rule_count_index_get(bf, erp_bank,
 							  bf_index);
 
@@ -233,7 +233,7 @@ mlxsw_sp_acl_bf_entry_del(struct mlxsw_sp *mlxsw_sp,
 
 	mutex_lock(&bf->lock);
 
-	bf_index = mlxsw_sp_acl_bf_index_get(bf, aregion, aentry);
+	bf_index = mlxsw_sp2_acl_bf_index_get(bf, aregion, aentry);
 	rule_index = mlxsw_sp_acl_bf_rule_count_index_get(bf, erp_bank,
 							  bf_index);
 
-- 
2.33.1

