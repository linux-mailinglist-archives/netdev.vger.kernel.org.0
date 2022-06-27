Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBAAE55DAF3
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232684AbiF0HIa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 03:08:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232673AbiF0HIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 03:08:12 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2082.outbound.protection.outlook.com [40.107.237.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1323C2BD4
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 00:08:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WClGXyjeacN9LPMy286363Uym/+Gz8cBKIWEwOMlZgbtGWES3Cg7CL8nUJV+jL71rESbnQ154AIh/Pz9nSKnO/uc8ogSDr9BPcQiaQ/eR2PL9kp72w356OOJ57/XjGJMkQHaqDK67CZ+CyRgLnohjP9EQacGA1tiyZLKm76NCa3/vnMB4tED3T6Yx8CcxCXmHKhLMErEj5BgVUSiY4Tevh+K5YbTYcExiodKiBViNQ2f4vxhbbh1iNbNmxk0MFTYkxlBbCQygdr9rdtBe2hYayrObgEqWY/WGmblQgMBqVzbZ8Pw3xfJFBKDQEmk2T5f4ncI4z4bLNNKmrdBC8IH4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DpxlTOC5ScCUNDsJaG9K+XLCGVBYmiRFFpOd1VEJIT0=;
 b=Z8b56Z63zl9nT3XRfCA4FJV2gDSAqApY5+3BJTVUNbDfn9jPL7p9m/tKR9wxAJb/LwymQ/bUEL8I2vUOHibQ6y9ub97lMYDyilYRcDuXk2Gs/Z0vj4l9IuCrOeoZ8Rc1hf3+uXqZi8QqYFkkQdAZJAKVCv7HtQg77dQnW5R7h8ijMOwtGOhKkJyhhiFnAsIXHoXZqYt14MBK4Sz2QFzWzAIeld+FsQdqIC+8mkmFKJWmd+2HVMSYbf8dyh6ELtAevohiJKlES6X+o0Gh7oM7zxyUADEVjk+YuS6/cKFeEeAPWPw9xuMkc3ps4Kz+sdc2tJcGRzn8JFZ1vnJyJVdnAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DpxlTOC5ScCUNDsJaG9K+XLCGVBYmiRFFpOd1VEJIT0=;
 b=RsobDoEfWGE1qMDVXpZhclPpogyQx6w79VP6tq80drVNPJ98F/X+5CTqdU5Xcc63u1gjaSa7qkTLhO8GXZL+ggUa7BtAFnwE++qAmsEomfawTezglumufYd4knYZCi44Hy5mpuAAlK69xdr1sKpD2LeSaaVruGDUeznLR90epMihNy1XwmKHxcckIVwhgesHs9zBQZpSKBmrnM63tRn97H+Ps/147eQDznnxB3eHRZxPuo9cT1Uqfo3mz/Ov9TAPkIJ1Gsm9s6c0Qq9CPNJQ2wI8WtnUC4LKa2m+9W4deBuFBsa2Yt59kQ0g2Bml4zhHJgIG+jJTZXrHi1pEry/L8A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SJ0PR12MB5439.namprd12.prod.outlook.com (2603:10b6:a03:3ae::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Mon, 27 Jun
 2022 07:08:07 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%5]) with mapi id 15.20.5373.018; Mon, 27 Jun 2022
 07:08:07 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 12/13] mlxsw: spectrum_fid: Set 'mid_base' as part of flood tables initialization
Date:   Mon, 27 Jun 2022 10:06:20 +0300
Message-Id: <20220627070621.648499-13-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627070621.648499-1-idosch@nvidia.com>
References: <20220627070621.648499-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0039.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:152::8) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 715f7061-1da3-4db8-a80f-08da580bc93b
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5439:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MXsBZGBhewgn5dv++yjcQw6Jl2tOVPM+9hJ/85hGMvJ3yAyZ3Ekr6WlVO/H7eH48ClaUuvHCUIRQub0lzp0ED+NLod4MN7gzCc7kc9xpw0p32564jCUUOvhtjq6NeKE26bdSk7pdTerF3Shm6OS4mSPT5yT3uXSvqxYrgcRePolgX9x9mlCGyHFxD+n2DxaIhgMNCA9Z5UxEmczhKfzVJxAgbOwumzqst+y60kpGj6NCK45ryt1+ApTYsibGdtzQcdgT58IuXyJEXVnFJAS8UtR6KeGfDnHiuuwAlaXfI0OTGBbPbmvgo+MX8gNN0qCzteZaGDCubcizm8KIKEAfPVzC2e0okXNew3fFJ/d/GwutE+j/wYCcEuUfl+eCSXtZl04CdEG9e2u1qM2tOABTJ/1uJ7qYmnajvJV9Sei0dmT334HQfWPAIwLsATeSSmTXrjNnSVMURIlzOE/YDtW00wkgktV6IDHvCBgkg0QM4bccm70vEzHT1lMYr0f7YN8CHf9d9yF7LxJzMggDyYugGlNpK22UDb/CZ2F+nK2EJ8SwSqsN7pDf8LNcgs9VI2sgWAQlJYiswTOIi5O4RKrp6zVW/n/eeo9/Vrv1D+9/RsxKpNqbf84fyYhUiJ6WkHdApftw7fD9VyBFArjNiKjJ0BI4fwalx0ve86JP3mBfsKlAdsLoXPw9FDX5FDPFjvk7MUhhmNZmPqcrfAzi91mG//8M/J4s+7r876uVIf2QtxjRmMHILvEKgSa9YzWtBsbw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(346002)(136003)(39860400002)(366004)(6512007)(2616005)(36756003)(6666004)(6916009)(66556008)(316002)(107886003)(1076003)(186003)(66946007)(41300700001)(6506007)(2906002)(38100700002)(66476007)(6486002)(8936002)(478600001)(4326008)(86362001)(8676002)(83380400001)(26005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Zz2+BiOCbF4UQ3kT5eDDD3mf4THpl+oiNH4yiBgObnjyjE7OdXMFO+fx7BdC?=
 =?us-ascii?Q?ygFQbehk032VYH9el6d7llw0MTM7nRnPupvXDvq4HLdRzIPZToiNEqBKww1w?=
 =?us-ascii?Q?Wp4MCVZFOuOXIig5NfEW2hDWkDtQ1EELa5q0eMPMndbj7koUnBFiPllaZmh7?=
 =?us-ascii?Q?43sGMS1LFzFTd5RRviHauVuH5R26auQdKCAmvchtQa3S000ow1O4H7dr9D1k?=
 =?us-ascii?Q?5uuAahBWDRevEmALIEMCkXGJGVgMHKZLx5obMEAR9eNjYUokfGDb9Eey5/1m?=
 =?us-ascii?Q?TtQGMFqQo2hzG2y9+Vi7GVr3O1KLkk8swH3es4vf7e4FnOzkTx4Z0Fg3cAtf?=
 =?us-ascii?Q?4t0JPCj3wwt7EJ+KCC6A/By1jIacyf+G8wa0n1H8/yZhNPPx6PAICtlKDcyM?=
 =?us-ascii?Q?ATzrM+FGuXX3PulxZ0ylP0VNbua8ulfEGGQeUQldvlQwqyhkggOMzyYF+mFW?=
 =?us-ascii?Q?Hffubln8X76GzoruhY0Wo9qD1QZVyxsfGj+zWd2j9EGnu2QNDjoja9crjceA?=
 =?us-ascii?Q?DjQ0FhnmKh3ZqI1LYlPWIlNnEM2/90XHTerwfnXEATzhsafXMcrePH88mEbj?=
 =?us-ascii?Q?giexEnI3rvXhnCdnaXQIWPRH6OF+n4xTrfp0XW/zaeMjUuEPIH3N35SKnygR?=
 =?us-ascii?Q?McgKTPpV663Z7a18jBerNvgJvLObcsaKDes6F0JtqSPp982WvkVpLGVeftlF?=
 =?us-ascii?Q?nJMuI2lE6kubjgkVmbSYNMboszfEiqgB2WqEJcC0DW7CJA+06hcxFPeYP807?=
 =?us-ascii?Q?w6mZnAQysdL63KsqJR6alurSnsEGgzmah7rMuLAgf0b/hC5lT22bBjOvkCRd?=
 =?us-ascii?Q?QGcNVqiPNqrD0/FQqD1Ds+iNlyBWNlhG49YXUcqwS4cYrgwWrOnDhapwHCOA?=
 =?us-ascii?Q?j6a4DrkGhgV8kZ9zktaIxaMdy405R9hIP20f+oMYi6nwHVs3HWwYK8yi2eeQ?=
 =?us-ascii?Q?eZ6jTPgiH4W0GjFzZcSaJB2vhR+S29PUyEXYwlhqjSgiwnaJahlJX9rhT61i?=
 =?us-ascii?Q?B9pea22ZF4D5KAKV2B6yt9O2wZxZ5QRSXEfHJStkE2Jpu5haDxX04sToPQDy?=
 =?us-ascii?Q?wswTJuSe8j70UPKgLUlC0CEH5w8XUk/awcsgQxVH//2XdMSDN89lQrtVKCbw?=
 =?us-ascii?Q?lhXuzLgmZAmzhan9C3m/KC4172KFw9FFel9h/XeqdBe1XSByeM78YA2O9M1u?=
 =?us-ascii?Q?hb652B3AKdiO51Iturx44FESDKn0F+C42wqqHnlBW2QNpCbAXM6PRtoN9JWA?=
 =?us-ascii?Q?SO/QrvIWZbsuvUQ4LqPEfShWN2MEmFkCldxwP679WnZkkWazDGPdSz0aeCG4?=
 =?us-ascii?Q?Y3BnBcLUAcrGN69YrNsqeFGHFhDJf2qtUycbiptLF5HwdqTiPbRThLkIbhTv?=
 =?us-ascii?Q?TsDM1NUp2LsVLBxGred3SW4R+LiXDfI+XPi4mJZJQzN5O3ycAfEvcGbsJmHO?=
 =?us-ascii?Q?RrI5OHfbj6jqgE8gGat4TN+OKKFWjOTdS1Oy66B1l3Gk0Lk9Dd9iythCNkt4?=
 =?us-ascii?Q?NBB4Pqr/wSilvZ7KdB2W7ao5GJiEyy/qXYmEqLFk5Iz+DI+Lc8o3VOj2Qm6B?=
 =?us-ascii?Q?NxFVijgLnsDvncdzWW5ZzZB/f7HveLHZqMe0jg5m?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 715f7061-1da3-4db8-a80f-08da580bc93b
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2022 07:08:07.1923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2NfwkEPwWFpccxuHgliDmO9eSCouyoVcD1sj36VllOFo2tJyZqwXkFnfUAICKI3NjiqsnrKapOpdQzv0qZed2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5439
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

The PGT (Port Group Table) table maps an index to a bitmap of local ports
to which a packet needs to be replicated. This table is used for layer 2
multicast and flooding.

The index to PGT table which is called 'mid_index', is a result of
'mid_base' + 'fid_offset'. Using the legacy bridge model, firmware
configures 'mid_base'. However, using the new model, software is
responsible to configure it via SFGC register. The first 15K entries will
be used for flooding and the rest for multicast. The table will look as
follows:

+----------------------------+
|                            |
| 802.1q, unicast flooding   | 4K entries
|                            |
+----------------------------+
|                            |
| 802.1q, multicast flooding | 4K entries
|                            |
+----------------------------+
|                            |
| 802.1q, broadcast flooding | 4K entries
|                            |
+----------------------------+
| 802.1d, unicast flooding   | 1K entries
+----------------------------+
| 802.1d, multicast flooding | 1K entries
+----------------------------+
| 802.1d, broadcast flooding | 1K entries
+----------------------------+
|                            |
|                            |
|    Multicast entries       | The rest of the table
|                            |
|                            |
+----------------------------+

Add 'pgt_base' to 'struct mlxsw_sp_fid_family' and use it to calculate
MID base, set 'SFGC.mid_base' as part of flood tables initialization.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  3 +-
 .../ethernet/mellanox/mlxsw/spectrum_fid.c    | 33 +++++++++++++++++--
 2 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index d0ebb565b5cd..022b2168f3a5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -1114,13 +1114,14 @@ static inline void
 mlxsw_reg_sfgc_pack(char *payload, enum mlxsw_reg_sfgc_type type,
 		    enum mlxsw_reg_bridge_type bridge_type,
 		    enum mlxsw_flood_table_type table_type,
-		    unsigned int flood_table)
+		    unsigned int flood_table, u16 mid_base)
 {
 	MLXSW_REG_ZERO(sfgc, payload);
 	mlxsw_reg_sfgc_type_set(payload, type);
 	mlxsw_reg_sfgc_bridge_type_set(payload, bridge_type);
 	mlxsw_reg_sfgc_table_type_set(payload, table_type);
 	mlxsw_reg_sfgc_flood_table_set(payload, flood_table);
+	mlxsw_reg_sfgc_mid_base_set(payload, mid_base);
 }
 
 /* SFDF - Switch Filtering DB Flush
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
index a82612a894eb..d168e9f5c62d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
@@ -110,6 +110,7 @@ struct mlxsw_sp_fid_family {
 	struct mlxsw_sp *mlxsw_sp;
 	bool flood_rsp;
 	enum mlxsw_reg_bridge_type bridge_type;
+	u16 pgt_base;
 };
 
 static const int mlxsw_sp_sfgc_uc_packet_types[MLXSW_REG_SFGC_TYPE_MAX] = {
@@ -321,6 +322,18 @@ mlxsw_sp_fid_flood_table_lookup(const struct mlxsw_sp_fid *fid,
 	return NULL;
 }
 
+static u16
+mlxsw_sp_fid_flood_table_mid(const struct mlxsw_sp_fid_family *fid_family,
+			     const struct mlxsw_sp_flood_table *flood_table,
+			     u16 fid_offset)
+{
+	u16 num_fids;
+
+	num_fids = fid_family->end_index - fid_family->start_index + 1;
+	return fid_family->pgt_base + num_fids * flood_table->table_index +
+	       fid_offset;
+}
+
 int mlxsw_sp_fid_flood_set(struct mlxsw_sp_fid *fid,
 			   enum mlxsw_sp_flood_type packet_type, u16 local_port,
 			   bool member)
@@ -736,6 +749,10 @@ static const struct mlxsw_sp_fid_ops mlxsw_sp_fid_8021d_ops = {
 	.fdb_clear_offload	= mlxsw_sp_fid_8021d_fdb_clear_offload,
 };
 
+#define MLXSW_SP_FID_8021Q_MAX (VLAN_N_VID - 2)
+#define MLXSW_SP_FID_8021Q_PGT_BASE 0
+#define MLXSW_SP_FID_8021D_PGT_BASE (3 * MLXSW_SP_FID_8021Q_MAX)
+
 static const struct mlxsw_sp_flood_table mlxsw_sp_fid_8021d_flood_tables[] = {
 	{
 		.packet_type	= MLXSW_SP_FLOOD_TYPE_UC,
@@ -765,6 +782,7 @@ static const struct mlxsw_sp_fid_family mlxsw_sp_fid_8021d_family = {
 	.rif_type		= MLXSW_SP_RIF_TYPE_FID,
 	.ops			= &mlxsw_sp_fid_8021d_ops,
 	.bridge_type		= MLXSW_REG_BRIDGE_TYPE_1,
+	.pgt_base		= MLXSW_SP_FID_8021D_PGT_BASE,
 };
 
 static bool
@@ -801,7 +819,7 @@ static const struct mlxsw_sp_fid_ops mlxsw_sp_fid_8021q_emu_ops = {
 /* There are 4K-2 emulated 802.1Q FIDs, starting right after the 802.1D FIDs */
 #define MLXSW_SP_FID_8021Q_EMU_START	(VLAN_N_VID + MLXSW_SP_FID_8021D_MAX)
 #define MLXSW_SP_FID_8021Q_EMU_END	(MLXSW_SP_FID_8021Q_EMU_START + \
-					 VLAN_VID_MASK - 2)
+					 MLXSW_SP_FID_8021Q_MAX - 1)
 
 /* Range and flood configuration must match mlxsw_config_profile */
 static const struct mlxsw_sp_fid_family mlxsw_sp_fid_8021q_emu_family = {
@@ -814,6 +832,7 @@ static const struct mlxsw_sp_fid_family mlxsw_sp_fid_8021q_emu_family = {
 	.rif_type		= MLXSW_SP_RIF_TYPE_VLAN_EMU,
 	.ops			= &mlxsw_sp_fid_8021q_emu_ops,
 	.bridge_type            = MLXSW_REG_BRIDGE_TYPE_1,
+	.pgt_base		= MLXSW_SP_FID_8021Q_PGT_BASE,
 };
 
 static void mlxsw_sp_fid_rfid_setup(struct mlxsw_sp_fid *fid, const void *arg)
@@ -1151,8 +1170,11 @@ mlxsw_sp_fid_flood_table_init(struct mlxsw_sp_fid_family *fid_family,
 {
 	enum mlxsw_sp_flood_type packet_type = flood_table->packet_type;
 	const int *sfgc_packet_types;
+	u16 mid_base, table_index;
 	int i;
 
+	mid_base = mlxsw_sp_fid_flood_table_mid(fid_family, flood_table, 0);
+
 	sfgc_packet_types = mlxsw_sp_packet_type_sfgc_types[packet_type];
 	for (i = 0; i < MLXSW_REG_SFGC_TYPE_MAX; i++) {
 		struct mlxsw_sp *mlxsw_sp = fid_family->mlxsw_sp;
@@ -1161,9 +1183,14 @@ mlxsw_sp_fid_flood_table_init(struct mlxsw_sp_fid_family *fid_family,
 
 		if (!sfgc_packet_types[i])
 			continue;
+
+		mid_base = mlxsw_sp->ubridge ? mid_base : 0;
+		table_index = mlxsw_sp->ubridge ? 0 : flood_table->table_index;
+
 		mlxsw_reg_sfgc_pack(sfgc_pl, i, fid_family->bridge_type,
-				    flood_table->table_type,
-				    flood_table->table_index);
+				    flood_table->table_type, table_index,
+				    mid_base);
+
 		err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(sfgc), sfgc_pl);
 		if (err)
 			return err;
-- 
2.36.1

