Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3719D55D1D9
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232599AbiF0HH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 03:07:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232593AbiF0HHU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 03:07:20 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2076.outbound.protection.outlook.com [40.107.94.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADEC45F85
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 00:07:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AYlwotFyvJyCvnuDNEYNUVJ29Xu0co7c7ZZsEB9Dh1nxGyS8QBO1iODsPV8o9wcbwBHjkcs5Ihn9zgFV+ybEGrhIJg2CYoVSKGqVFOdJstbdr5eb18qjl+9duOUgnbICRDrGBA84Cgje83pG2X1RwTh4qh0OMVOm4oQFO/nbMTGvFp+Oa1IUMcOerU7rEEM11A/tVImtsdLBLfBAHyfPfUanQ6cfY9Tvzm5ixRECp0XSqbfgF8MtYST4iOFp/zb5gs9kHfvl8ryInVX+QkdHbn9P1mCAOOAjD37C7+5YhHFMLCZlVk0SILcnZXKl0B92EpCdlPsCQkddMPQxIHyu2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6hG3uZCojnGt0WhrZmWSWPLx0JMuiFVpr7ToonRq2oM=;
 b=WCENfP0/rCphKvX+Hdcb5exn8/WC3YjardJGQHIXrltdNq/g9yI1df/2NP15bb42+PEVHCUu5WgnZDSZeeXn+zmzMPEvtgWAeeLM0OIaV+LM2PxzhhZvNNumOZLzrMIl5aPR6nKRzSDHLthdFiktHlAbUFIqHpbfxUpdA5jKiHzIBk0KvwoiHBZTyJeojSFXeirX+2Dvo2tUidrz05F1m8j5QPe0HMZSjigFHzMH7jN9QfS/cIgUsyZ2G1CCfk5I34+5eybHC/GyxPc3BQdhJ5jrbetzPqbdNLlznrJdCbc8xemqmQZQ5hwCvJSReKQ5Py0UFsgSb6IOh/mxOZX7PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6hG3uZCojnGt0WhrZmWSWPLx0JMuiFVpr7ToonRq2oM=;
 b=a8cEtXUXsCYlYw8myfH7dx55DOkJ1o/IeqVVAeAXE9l5lb9s98XKTL9dlCYle7RtYeg62fLbuA5j1qeAUaAwU6UNZDinS7+zxu9MDvzmBkr6R70ix2pYHQ+6H/2K7NTmGTi5YDDeQm/eI1gqW/YBBXj8tL0uTOyK5+IT5IL55MNuEF8/YhLrEHaaEsRVICk5+W0gMME7YgnOrK0wLYPa7ehnQzq4SlIfEr5MRwks6/14zQPO0T6dfVdKoxB+QiEs3y0riIPYCZ8t4OW4GbpigA/33qZYxSXKTSodGYvopVr6ZfAKz4UmTW4ClrBBEu25hlOdetwBFhi3cBBpbZII3Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SJ0PR12MB5439.namprd12.prod.outlook.com (2603:10b6:a03:3ae::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Mon, 27 Jun
 2022 07:07:18 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%5]) with mapi id 15.20.5373.018; Mon, 27 Jun 2022
 07:07:18 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 03/13] mlxsw: Prepare 'bridge_type' field for SFMR usage
Date:   Mon, 27 Jun 2022 10:06:11 +0300
Message-Id: <20220627070621.648499-4-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627070621.648499-1-idosch@nvidia.com>
References: <20220627070621.648499-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0484.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a8::21) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 273e692f-7b1a-43a3-3d6b-08da580bac39
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5439:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZsxQNc5b23qaZ6cWFZGfvBnuh1qKTdygq8wlJ8AhQaWtP/g1bLZf9OTOXOakLW6YbjnmlivS4btVoi2oaOi0inBleSP7Nv7aPlA8Xh31ByQUNLwGTjJoAkFnjdy0yH2uvOldYpFh8KH8SuKwLA8CspiNHKI/2IPWwwPmykrOzotCxYFHYiE3dBwmMhcmXu/28no/Cnj1eMSjoymsNPpnwAMbotRvdw9BqkFws6oIj/A71R3+bB9nPyPbtdHO1HlBow8TLnKHtk4HVQQOs8Ni5HmtiNew2GkBuhZH0hIBpaMp8MZRiLmrZNeKeDzfKZpYiDhW9trr6Ewhygv3EG4zxp48kHZi1kmgQYV3lBdlFVZs37nlqMG+9EKg0mMHye9oDcdDUpdibSZ0Ba2dn7/aawmT+33dXYtekoHQenbSE2er0Q5C4YsC9FGNW0H+sxC9o38xCWzdOmiUG4O2p0BR2qiW+bXIv6yldJ7Tus0hXdNiYIcCHChRAAbPwkqlCSu0ALw2FZU63EcLglvk813V+1s7iQf8pPchYV5y1wBORBKr0sFn0LWXgv+pcgB+vvTV43G7jk6gogr/QYS6WQJx3n8mACl//6PvVsnb2EzZ0ZVmJuUHNgUAq9wu7liDtPnuVcN5FnlJap4PbBBC0LyPnfVbjURiYdWJt1KHUlZ/XO5Prg0TESxWvSCjGndr8PBKlXTsBeBYu4J2t9gPvDVwaNJ0vAvZp7iI1fF+U3U3Q3lMfRTk6rhoI/BbBAadhJSW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(346002)(136003)(39860400002)(366004)(6512007)(2616005)(36756003)(6666004)(6916009)(66556008)(316002)(107886003)(1076003)(186003)(66946007)(41300700001)(6506007)(2906002)(38100700002)(66476007)(6486002)(8936002)(478600001)(4326008)(86362001)(8676002)(83380400001)(26005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TG4LVMdW29yxUoGQGBb80Z9ynzPjdDxzcw3EeDaHwesa7RqfReqDAuslL7nR?=
 =?us-ascii?Q?GwZpDZ2nXOj/qB1Ui8ReIQc186VugkjZgzmkO4ZRVcvTfHRHfSGOpc9FJDgg?=
 =?us-ascii?Q?9mOjUrjZjc1FpafPuyx60LV3np7VSIGZCuK3NHj+hVKHfAEsq7ay4iChpy3+?=
 =?us-ascii?Q?Br57WTlqzUyOFZXR7mILsCQ6fa2sGko/biLULQY4MgdLH/rXdeKAw/SmG0on?=
 =?us-ascii?Q?xpUUwUSrdjxuIdHgk4TloHTJbvV07dh77EtNED/QZsmoPULdunOjtho7YqqG?=
 =?us-ascii?Q?FpVObjb1R0fOBMRxGyGTAWCQShyByVD7nYnLW8XbRaH7oyvgf0HcB4qyMd3e?=
 =?us-ascii?Q?+7IGEqJTaT/KjCI2/OIGWxQVM5CNLw9AevXS0deSeZSejR2VGUUbIrKQaw40?=
 =?us-ascii?Q?oEec6nvVqIIO7J6LYARzb2RevvKr3pVnnBpzCdHAJveo5OcKVOyLDwrW16eV?=
 =?us-ascii?Q?WceX8b2BCXNdbm6L3tZ9hVliA00CWNo3FYjxQBL1M2KuvE59nRwGtVQqJ2yL?=
 =?us-ascii?Q?XiXvSb59SBAWk3Km1NEU8ie4FfnMd7+d9Tg1Rm1BPR1gLI25eoprmXo+Vx2o?=
 =?us-ascii?Q?sWA2DGLl40KJjqO95YLksDqvNbzaWd8WkGbZLd35kOuDUhRUE5A82d7Rw9cs?=
 =?us-ascii?Q?NfK1iNj95z+ppyWFaGhOGWXFlduly8GoRkniWPQ5gkLzSXAf/DEd2ixAftnI?=
 =?us-ascii?Q?jWNI2MUnHJfl0toF+poD3WlyciwSoH1lK6Gji9bneDdxT3V0A9O2b44KbST3?=
 =?us-ascii?Q?iRkqv3bXC2AOjnKGmXGlb8HKAJOzjUmFa/6+HpjcHqb4F67HVFAogA1VKHTd?=
 =?us-ascii?Q?YpB4Ykw/iiPewMz7TyQ7JKFRduzNy8g3gtYraHZviY/dr3LHJJUtm13b9+xC?=
 =?us-ascii?Q?LgQUjTGYE7lniX6EIYWjjgUeOrmfI3LFdyMf7300sQBCfua5hPi1KedXlNMm?=
 =?us-ascii?Q?ROExx06+ouqAopN3W0XSzO+f9qwqvxmCkVttpSH5cKqGjL1id6sfpkWKq9/U?=
 =?us-ascii?Q?jL7tGrTzq3QX6n7brKEhkznymSJS3YYTidYF02jKYQRGBtKxXkHWedWRGf0D?=
 =?us-ascii?Q?eUzz7i7KyH1EZmq+8uP9LetZhIm+QNNbDRGPwTBIkBgaT6dZ21TFwrtB8OCa?=
 =?us-ascii?Q?a2F7MfESnUhDuAAZ/fkTDmfPVJiUBvDgJvsIfsEg6Uxon0JBLJEvyebmZ+oW?=
 =?us-ascii?Q?3Wqo+8yb7VdMtaPX7EV5k2A+AbyMlI9UkEyv0AaQDGg2EL3YVuJe7uS/qMsN?=
 =?us-ascii?Q?GXjKWdJekC9lgV2tk4Bd4r0IXX/Gl+XFxp8WlX8000dgUs6O3wNK4aJnCE/C?=
 =?us-ascii?Q?Eq+F+33tjc9bExn9x6Tj7plEykRgvtR1GbgtRqRWfQPolgfT7OT6jaNGw94X?=
 =?us-ascii?Q?yg5cLC7FQDn7L4FZe3gtA3wBaEoeoq/8oFh2H4TKuPuL7kDMea3K5Ez3AAoa?=
 =?us-ascii?Q?dOp62w6m7iG8Uech7aT3JW5ON/hpqp8uEmNOdiZ88aEW97NQP85fKOZoiQQ7?=
 =?us-ascii?Q?ARWG6yk2d2N1w9I/iQDVfnqtCE4gpok1fo7s0j0uW5bCZtjQI7gWH0vykQbH?=
 =?us-ascii?Q?s+IbJJvC7n3MedtDBU1nYgRS8L4znPvhLuNjZ23T?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 273e692f-7b1a-43a3-3d6b-08da580bac39
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2022 07:07:18.4445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2k/zfBcAWIAI9jthJAW22AsUCthmOh6ToNqNAXAy/lcYCOixjXx/l4uJk8/TPYnuGu4uZLPm92FWNXL4i3pJCQ==
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

Under the legacy bridge model, the field 'bridge_type' is used only
in SFGC register, to determine the type of flood table (FID/FID offset).

Under the unified bridge model, it will be used also in SFMR register.
When a BUM packet needs to be flooded, SFGC is used to provide the
'mid_base' for PGT table. The access to SFGC is by
{packet type, bridge type}. Under the unified bridge model, software is
responsible for configuring 'bridge_type' as part of SFMR.

As preparation for the new required configuration, rename
'enum mlxsw_reg_sfgc_bridge_type' to 'enum mlxsw_reg_bridge_type'. Then
it can be used also in SFMR. In addition, align the names of the values to
internal documentation.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h          | 9 +++++----
 drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c | 8 ++++----
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 80a02ba788bb..e198ee7365b5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -1054,9 +1054,10 @@ enum mlxsw_reg_sfgc_type {
  */
 MLXSW_ITEM32(reg, sfgc, type, 0x00, 0, 4);
 
-enum mlxsw_reg_sfgc_bridge_type {
-	MLXSW_REG_SFGC_BRIDGE_TYPE_1Q_FID = 0,
-	MLXSW_REG_SFGC_BRIDGE_TYPE_VFID = 1,
+/* bridge_type is used in SFGC and SFMR. */
+enum mlxsw_reg_bridge_type {
+	MLXSW_REG_BRIDGE_TYPE_0 = 0, /* Used for .1q FIDs. */
+	MLXSW_REG_BRIDGE_TYPE_1 = 1, /* Used for .1d FIDs. */
 };
 
 /* reg_sfgc_bridge_type
@@ -1111,7 +1112,7 @@ MLXSW_ITEM32(reg, sfgc, mid_base, 0x10, 0, 16);
 
 static inline void
 mlxsw_reg_sfgc_pack(char *payload, enum mlxsw_reg_sfgc_type type,
-		    enum mlxsw_reg_sfgc_bridge_type bridge_type,
+		    enum mlxsw_reg_bridge_type bridge_type,
 		    enum mlxsw_flood_table_type table_type,
 		    unsigned int flood_table)
 {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
index b67b51addb7d..ef4d8ddb2a12 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
@@ -71,7 +71,7 @@ static const struct rhashtable_params mlxsw_sp_fid_vni_ht_params = {
 
 struct mlxsw_sp_flood_table {
 	enum mlxsw_sp_flood_type packet_type;
-	enum mlxsw_reg_sfgc_bridge_type bridge_type;
+	enum mlxsw_reg_bridge_type bridge_type;
 	enum mlxsw_flood_table_type table_type;
 	int table_index;
 };
@@ -709,19 +709,19 @@ static const struct mlxsw_sp_fid_ops mlxsw_sp_fid_8021d_ops = {
 static const struct mlxsw_sp_flood_table mlxsw_sp_fid_8021d_flood_tables[] = {
 	{
 		.packet_type	= MLXSW_SP_FLOOD_TYPE_UC,
-		.bridge_type	= MLXSW_REG_SFGC_BRIDGE_TYPE_VFID,
+		.bridge_type	= MLXSW_REG_BRIDGE_TYPE_1,
 		.table_type	= MLXSW_REG_SFGC_TABLE_TYPE_FID,
 		.table_index	= 0,
 	},
 	{
 		.packet_type	= MLXSW_SP_FLOOD_TYPE_MC,
-		.bridge_type	= MLXSW_REG_SFGC_BRIDGE_TYPE_VFID,
+		.bridge_type	= MLXSW_REG_BRIDGE_TYPE_1,
 		.table_type	= MLXSW_REG_SFGC_TABLE_TYPE_FID,
 		.table_index	= 1,
 	},
 	{
 		.packet_type	= MLXSW_SP_FLOOD_TYPE_BC,
-		.bridge_type	= MLXSW_REG_SFGC_BRIDGE_TYPE_VFID,
+		.bridge_type	= MLXSW_REG_BRIDGE_TYPE_1,
 		.table_type	= MLXSW_REG_SFGC_TABLE_TYPE_FID,
 		.table_index	= 2,
 	},
-- 
2.36.1

