Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67FA655FC47
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 11:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232587AbiF2Jkl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 05:40:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232825AbiF2Jkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 05:40:37 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2071.outbound.protection.outlook.com [40.107.92.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4691C369C4
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 02:40:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UAW5kPfJoOeP4hNAbxeXbC5zcS0HHTcDUlA4ThEs1f75siwwLD/4uLt0DzZHS07CFpKWgAiJwDNXkvAMZuLFAq4DjayARUbMBfaf4vsJjZ+HTC1VPV0cr7N7VCA7gKGli6ZMOtUg44Rm7U8c6DCT49VDaHyEQ+93O6OGlOfne618AOweMt2NHyFvNlGfUECd9w+VlWwHp65TA8Nzac43D5cYxiR6bezxivmXsG7dhEdqYk4CzHAohRB4Eu/BpIVlWpRGWkJFDlx3N4ijMgfpRLKwNQbB6RKrAP2iLPvhFZ9mUh/CCQHpKjOxNPz5j8U7+o5HPmDdKhmU9tXB8TXySw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mM3xPrZXkPT9RbXECoWXdL446cy/uRNiF97mVW7u/og=;
 b=B7fzta4mAPUDLLCQjyBhWMedgxF5Toffue8Iu4Gtbnqu4h40uuUUlqP/UX1W3OG5Moxp8KtPKZPFCeSzFzVKirvB5/rMN2e++PmKNLXNRlEQJFWhvIALM4WEyHWGfI7SZS5pbBruwy1D36K1gvr5dNebU3JdNal/i9Qqv+57gAr+c0I2OMCw72qbJ+NInpSEjwl910r5wTjFEujpci70hdgRDKH/oSflNWLgrkP5MUtzXudm8WBjtPMYFS6n5O48Ov2F51RYGNQVw3bl2EUcg3WrD39gKery9r8Ss+aQu0FGdREg/O08VJ80XTGeNsHpUz/xWsbdbkZ6lBLY0zMdMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mM3xPrZXkPT9RbXECoWXdL446cy/uRNiF97mVW7u/og=;
 b=GOW3TJNV5mxatn9MjazgB1PiXtTAgUiY0+FIcS0lHKp8pXtf4YzzWSvn6XKOQHrsgzS6AQvia72yrjqZq+IG9DxTvKap8HevINxbwT77duc/X0egbu6JDhkmBtjUgGueOTht70tXoC8vsMgLWoqLeJ+wbjXVhjW3BhCBiXyMlM9GzWmrNC+G07B4WUK3ubmZserNVZieK5kedo+yGvbffayc1hyTRdWOznkhVNFhemC6F1vK/YQze0xRtvWq5Ktl+VgURxmOTHsRt0JN7T0jI+ZjW7oqC5FAv0jeSe7oVhkv3LgMeu3T1q9EDabF562UU0fOldaoeMNspCeMyJbczw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BL0PR12MB4689.namprd12.prod.outlook.com (2603:10b6:208:8f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Wed, 29 Jun
 2022 09:40:33 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%5]) with mapi id 15.20.5395.014; Wed, 29 Jun 2022
 09:40:33 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 01/10] mlxsw: Align PGT index to legacy bridge model
Date:   Wed, 29 Jun 2022 12:39:58 +0300
Message-Id: <20220629094007.827621-2-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220629094007.827621-1-idosch@nvidia.com>
References: <20220629094007.827621-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P189CA0006.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:802:2a::19) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 84b1f63f-7c9e-409f-45b8-08da59b369a7
X-MS-TrafficTypeDiagnostic: BL0PR12MB4689:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HBPoXyN5UJUnYZ/avuqsY/WiyypU1K1d3zfXjH6uK6H/w+qAfm6iNLs5ilkqVjRrcViAN6bmFxSZr4vsoE7XEATpaLUpukLCh/DiQVpK2ryOWO83QTMs4nkTaQKcoGp5Gjl4TbSQ5kizUVUmpv35u4rXzvn0pmwWv0+VUd9PmKYcz77BHrQiOfZ9SwonJ3MAdMuncMRebGaG46hehNbdUXYtEQ7Ly1Hszz95OIAYX/EZUnjNH3QOlha2D9HRaCHWZmH8WValNweXQ4bYpSY/xreNxzlKXeDN4k4w2SKBx/eARMvfWo8K7UvI1J6+0ui6dMeyz5OtxCLA03fB7QGAmpZcgbMTkRkY1EDOqP+SoH0mLs5jNooUZVz1xAYw2pc1ddDJksmEaCU2atwpmVoIzzbLgi2Auv3n6CrzRMy8vDDX02AhQT6AtV01Jmunij9U5/q+jzU7za8rcCoGdfRO4zyUiEPvZorOubiK1FMKsnecwy5CCRSbdG5tSWuNdcp9kKVOF5fQsjJAuDds5vGSHtsJCaVkFc6C5jwfPByoKaAFlLZAwcVYtIrz03Pg9+HJTuyDm4v8go6qRt/5ZU5e77DG6auup1HhOy2+ZxR6/nhiwInTbI2i38xARmF4XQuiMnGs8W3UpZUWLsdp+vJQPNXbv/69fF9bxj+aC3bntRFweSawOC2KiF0t2vRE42rVy1Gj+QUbjCsFjrglreFsijzhFbOUtx1t7JuzV19J2mKVpgPbQBGqfMvT56AbIxo6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(366004)(346002)(136003)(396003)(6916009)(186003)(83380400001)(5660300002)(6506007)(6666004)(316002)(2906002)(1076003)(86362001)(8936002)(41300700001)(107886003)(2616005)(66946007)(8676002)(66476007)(4326008)(6512007)(66556008)(26005)(6486002)(36756003)(38100700002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BuRaXpqhmLOEzsZX+U5wJDslRUrbLXvrZNFoPe4mDreWqrCHgDWUf+cdOAzy?=
 =?us-ascii?Q?YcbPNQl1YTrL53Ft/J8rRsWFENO8JIzzoFrRI4LR2wJ3d6YdUraEkLojCwdz?=
 =?us-ascii?Q?aMXBRPl1KrUJ4o0dAuhl9uxuv0Tzh9aWJfMGb4TqnJSvWMYN/8xJsN/FTeCw?=
 =?us-ascii?Q?XWFAiu2LJXY1zFNtWkd+aNBxcTunxwzKz0r8b+bCd+MyN4iRw/PrXod3ANmf?=
 =?us-ascii?Q?3rwnBPJWHXCWanNU9Qr1G42jB/W/xsn+ewmi4pJvg9IXhFWtwm+x3f0d1NEq?=
 =?us-ascii?Q?a4h4AmJBH8C5gAYBaL5ULYqhnlAY3MQoZxP1H0ZvZL0eJS5Nxu9aPQoepLnP?=
 =?us-ascii?Q?kmTHEOVTH6a9qzyJpJvHLhy0oUToTjNg0P4bxbqhWWAvNvcjIcyeROh2lMLE?=
 =?us-ascii?Q?wzc3tspx01sWx9x/Nda68dtqsJ2be7zIXUvgR39xOuU87xS0QGEeJxHHucPr?=
 =?us-ascii?Q?0BhH3OKq0lZW7ZJbdMjdpxPdZm7u46kBxczunD+kOBlN//Gpy6olfPySQAb0?=
 =?us-ascii?Q?KOB/w+k124em5xluTwrabAp6V37kvm6tglKcZ+ZxWp8GLhunP7fwnHx7DscN?=
 =?us-ascii?Q?UByQyBmiNDoR+8InLirfAfyd6TT2A23y1SaEdM4K3/p/URVWAZp9S1maGqkj?=
 =?us-ascii?Q?kz93YrgZqrLWNfQcvHY1XoL1sHKxIKgm6xyJDuq73Bo/mqVp7cYSjY+6/enS?=
 =?us-ascii?Q?o5nTgbjOHOwc+p/dIeLkP0jJUCGGFHCkWPTLqwTlFS/wThVlESq5Pv4t7mDD?=
 =?us-ascii?Q?x5FDMp5l3/HJTsyX/++20XVrLTYUcVZhr586yySdlOs2YEjGXwrAuz6+0L3C?=
 =?us-ascii?Q?UJF9D9X8lmh+2efUP63PlRngiS0WGNpM/Ew4rwkAAqmB1SsfjNlAXfUXTH2e?=
 =?us-ascii?Q?k1eHIyKOTPmUf24laTaqgz980wwpzX1FZNzw8oL3l8Ntcu6f+Vb0pSzBkiLB?=
 =?us-ascii?Q?IE3DNkfkQcDrBUi0Yfo2cjWD3NagQk824MLAeUDpCHSEFgKbbMjt5WybmA1V?=
 =?us-ascii?Q?0etXjqIzz266QmicYlfPTDpStqxyZJO++ICHrhkMQmhFtoUKEuWawgsMQxBe?=
 =?us-ascii?Q?T08uX0jUCRU7cD5EQkYRjEK62yct26j6zH2DAigevzc6bHzvKvQHcH9Y4PTs?=
 =?us-ascii?Q?3omHckzxFeR9tVeRBkiloTlUZ2WuuvAuXnA22hctWq6MEM645mhBRj/Zf510?=
 =?us-ascii?Q?DQqQBvypIX2w5/00N/6LzavdunLrAbgd1Pj9m4pLRP3yWP7GJ7YPk7aJrsIi?=
 =?us-ascii?Q?vhIfjutvDKo1uy6PTW9IHRrSXMW5bhxVT0/NuL0Qb5+OVlMAewstfqaqxY1k?=
 =?us-ascii?Q?gT5y635m/TLX7fzVwJGMHh7l0bCwO7wucxbHnHPHAh/uhUFe4XvNDnKvVDSa?=
 =?us-ascii?Q?fOjk4aGKrTYlm7XVSQ16l+bEz8QiMrLtghYqO3WoJVLY4VztsSkote0H4WnP?=
 =?us-ascii?Q?i4K8n4jSvRaJ5Npl83HoEzzjmv6wM/sJowOEyDLm36IJuUzZf7MpxCfQceXU?=
 =?us-ascii?Q?AsiLhVhwPW3X05izcxb1gQ1hzGOEQhal+J7UJWT/0TXA3cuNx7I6LHkwM1ea?=
 =?us-ascii?Q?9UHp2ac26E0F8Hp73yPlAV/eVMsMNMORyTbnJE9w?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84b1f63f-7c9e-409f-45b8-08da59b369a7
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2022 09:40:33.5277
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LhPrkUUfnQEr7s/zlOgl50UuwG5GUAqQpaKUhdTqqz3Bttj6BYnn+3WkS6S3fM5hfLY4NMNBduITnqg8b7Mu5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4689
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

FID code reserves about 15K entries in PGT table for flooding. These
entries are just allocated and are not used yet because the code that uses
them is skipped now.

The next patches will convert MDB code to use PGT APIs. The allocation of
indexes for multicast is done after FID code reserves 15K entries.
Currently, legacy bridge model is used and firmware manages PGT table. That
means that the indexes which are allocated using PGT API are too high when
legacy bridge model is used. To not exceed firmware limitation for MDB
entries, add an API that returns the correct 'mid_index', based on bridge
model. For legacy model, subtract the number of flood entries from PGT
index. Use it to write the correct MID to SMID register. This API will be
used also from MDB code in the next patches.

PGT should not be aware of MDB and FID different usage, this API is
temporary and will be removed once unified bridge model will be used.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h   |  1 +
 .../net/ethernet/mellanox/mlxsw/spectrum_pgt.c   | 16 +++++++++++++---
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index b128692611d9..b7709e759080 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -1485,6 +1485,7 @@ void mlxsw_sp_pgt_mid_free_range(struct mlxsw_sp *mlxsw_sp, u16 mid_base,
 				 u16 count);
 int mlxsw_sp_pgt_entry_port_set(struct mlxsw_sp *mlxsw_sp, u16 mid,
 				u16 smpe, u16 local_port, bool member);
+u16 mlxsw_sp_pgt_index_to_mid(const struct mlxsw_sp *mlxsw_sp, u16 pgt_index);
 int mlxsw_sp_pgt_init(struct mlxsw_sp *mlxsw_sp);
 void mlxsw_sp_pgt_fini(struct mlxsw_sp *mlxsw_sp);
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_pgt.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_pgt.c
index 3b7265b539b2..e6bbe08ef379 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_pgt.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_pgt.c
@@ -182,6 +182,16 @@ static void mlxsw_sp_pgt_entry_put(struct mlxsw_sp_pgt *pgt, u16 mid)
 		mlxsw_sp_pgt_entry_destroy(pgt, pgt_entry);
 }
 
+#define MLXSW_SP_FID_PGT_FLOOD_ENTRIES	15354 /* Reserved for flooding. */
+
+u16 mlxsw_sp_pgt_index_to_mid(const struct mlxsw_sp *mlxsw_sp, u16 pgt_index)
+{
+	if (mlxsw_sp->ubridge)
+		return pgt_index;
+
+	return pgt_index - MLXSW_SP_FID_PGT_FLOOD_ENTRIES;
+}
+
 static void mlxsw_sp_pgt_smid2_port_set(char *smid2_pl, u16 local_port,
 					bool member)
 {
@@ -196,7 +206,7 @@ mlxsw_sp_pgt_entry_port_write(struct mlxsw_sp *mlxsw_sp,
 {
 	bool smpe_index_valid;
 	char *smid2_pl;
-	u16 smpe;
+	u16 smpe, mid;
 	int err;
 
 	smid2_pl = kmalloc(MLXSW_REG_SMID2_LEN, GFP_KERNEL);
@@ -206,9 +216,9 @@ mlxsw_sp_pgt_entry_port_write(struct mlxsw_sp *mlxsw_sp,
 	smpe_index_valid = mlxsw_sp->ubridge ? mlxsw_sp->pgt->smpe_index_valid :
 			   false;
 	smpe = mlxsw_sp->ubridge ? pgt_entry->smpe_index : 0;
+	mid = mlxsw_sp_pgt_index_to_mid(mlxsw_sp, pgt_entry->index);
 
-	mlxsw_reg_smid2_pack(smid2_pl, pgt_entry->index, 0, 0, smpe_index_valid,
-			     smpe);
+	mlxsw_reg_smid2_pack(smid2_pl, mid, 0, 0, smpe_index_valid, smpe);
 
 	mlxsw_sp_pgt_smid2_port_set(smid2_pl, local_port, member);
 	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(smid2), smid2_pl);
-- 
2.36.1

