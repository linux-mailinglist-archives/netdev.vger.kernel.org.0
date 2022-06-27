Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A741455C243
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232582AbiF0HHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 03:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232592AbiF0HHQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 03:07:16 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2074.outbound.protection.outlook.com [40.107.237.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CB6C5FA9
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 00:07:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lVJwB2x2nzHIIRVim7kcJstI1CFSZxQ9PjUULjPWlcebzili5bjPmgETSrsV3AicxJ4WGSGE8t1UBcavCulqwE9I0ZQOklD9kgPfU58tTJcROv7I5yEjqRTkwIyaeVH5AAZ0Hbj4DvSK2g6c6RRwq/QvrLpRpen66CX27kc2wz7C9koWIBHPMEbNpzbAixVukPSFe0JBXwlcWsdpERSZ0nGcNQJ/isTW8gP6Mj+wXC7D6Mu9lF6NMOG2wLQ7f7oNoIkTHW+LYbrPggp4gTQAKMBf7cA16AGN6x9m6nhOPRHQVLxK/n/InDBMjnNR/8FPTMp70U5gVk7cyIqQCgezeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g8WJVIbfQ3AIDmakzFZ4pU2KFBWj9roiSn+9Qapkcfw=;
 b=mRoE7zZHsDGS4EJVy2ayYeLrB0mCUKR0t1AG14aEuROXqev5WSIeD6Y3U4L2f/pa/jXBYRtK97LeNaJ7Ume+TgmtuJpaMll0Sq1Fc7xY36IZjJF62dGKUCkmz93hvfYGVB6tu6nK7YeDTjaPYcXknh5Obw2XpGuYSwf+QEMA9HEplI7dKXichsTgsJI9Q13mzchfyrw4MjDM2LNkZA8W5/S+ZlQLM6+s3uStm9lsEkcTqDk68aAYxfTnBWsz+68ueDZtGcZzh1SQsZkLdrtKkuBxFxReLvyINBxmdDm3rXFACrguJvR04suv7NlIgGljsKRSfMIqMaAJtpT2heDy8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g8WJVIbfQ3AIDmakzFZ4pU2KFBWj9roiSn+9Qapkcfw=;
 b=TOWakmY0OL4bDF1DLbUaTxMnkyZ5aW7fiEgE6Q/vL2IqTXkZlUVRMlMIhZ3RCbaGCcmjTOADy74jOcjv91I3KK7diD9M6K0A5Z38eySHem7Exjnm5uhavY2c9GRZ4OSB019tV6D2l6qsZQ3R2O2n4h7niC7hT6f8IqMjxovwBTbh//lJ4M/41xJgx7ozR1YGGFl1d3EoIOAApJIJ0ai/aHD3rVtKyqz0ovULh8ykDpwE6L/ljJ6T++HJFA35nye70HrSR7CGMvEMQzeWSWgTrWLkevxkuYeguPT/fMVKFyjBCe/dY/GdelscdhhoR3Q/si1bN/cV4Y/U4XzeR9WymQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SJ0PR12MB5439.namprd12.prod.outlook.com (2603:10b6:a03:3ae::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Mon, 27 Jun
 2022 07:07:13 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%5]) with mapi id 15.20.5373.018; Mon, 27 Jun 2022
 07:07:13 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 02/13] mlxsw: spectrum_fid: Configure flooding table type for rFID
Date:   Mon, 27 Jun 2022 10:06:10 +0300
Message-Id: <20220627070621.648499-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627070621.648499-1-idosch@nvidia.com>
References: <20220627070621.648499-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0103.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::19) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1dcbe6bd-9d56-4500-ff15-08da580ba93d
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5439:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tYvEp63+XZbzjZAMICv+VfECTw6OacfkYZS1S8UFCdAU++WIg09wFRGW4GfFpzg8crYQlvKAd6mZAKFUR4JKnD7mvUnubbYRK8sfe82GD6vB6IVUV6q9m6DGih35u2jmxqitNyd9HFXG3LiWAf4k6b5kb91zyFyrky3Mb9za4dq97jKOqt0lzNSOw1qp3qtdPBcNZ0cz9ul3F4IP10BLFgZnRNTLrXFOKaXvZtxmmIWsrog+2MD/l8EtLenV1CICYY76Z/lTyokogTU2DcTcJfNMZ/2ApC9IFDkQlaWPDyzaCkQH0S5OwhkcOb1vDOennmJZw6+FdHXLeGtUUxERYGCuDsQBW8ifpzONOGQDTFIQ1olYE1Rbixiu1n7QCqzyzzbqDZfIqOH3p7+cXxfEfSQ9IglqkT31FejL9of2SHYFoq5WhGFLY63crZWzprvnNhZ9iIrxkD+lFD874CufSRC+M8EYSBn+J6vkA1QhrEl1W60tTuXQbBnUI7Vw+WVbe8tM3ThCOSSmQKsPY53sInVneYlal7iofG+vHRnE6rpGB2bjdpiMwAxBV4bpbZSKbo/uHPRAaQqUBqFphMmapDcSJs27Aq/scFJ98zOo4Il3rM3Xw1rNEVbXGShkPeHgK+OxEeeIHIBMrjZOOZiAF0H7nylHtqHIpSW0v06RVuBTfgljn3CrpPsU5bGT5tr7TipUTSby9mZlqcXcQlG3X1qByVWt/HSA/nmoaJyYLQPvartXN8h9etdExSVAOey7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(346002)(136003)(39860400002)(366004)(66574015)(6512007)(2616005)(36756003)(6916009)(66556008)(316002)(107886003)(1076003)(186003)(66946007)(41300700001)(6506007)(2906002)(38100700002)(66476007)(6486002)(8936002)(478600001)(4326008)(86362001)(8676002)(83380400001)(26005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?11algpbsY7URA4oLatxUEQJiqCtqHe8IoUMe+klqgFZdo0hEgW0ZK0jgXLlM?=
 =?us-ascii?Q?GgmutZvSSO3SKGtfG68mvryXXi0hD1gSPSNk2Nw9ojvsz93Kjki+I7/HcD3w?=
 =?us-ascii?Q?V6oQi+9XCOG9pvH2IrCnx6/8UwNKYqEwoFIvccWufkUvKES/CwZ+moC/0gwQ?=
 =?us-ascii?Q?zz/IubV/5kuoQWQceWzSUCvXpW+WO2pePBK/xrEHkTBijtQqVwFUQ4NiwXSK?=
 =?us-ascii?Q?Szr7aVoeVudk4OhLnyadgDAULbqYrkMsrI4/7FlIiU6eUUcP8O41uDvGOADn?=
 =?us-ascii?Q?RrHMG6ve5Eybel33kg/yLPWAZNnDQN8WvwufM5H/7ohJ/7iN3ipVz/zNGqDl?=
 =?us-ascii?Q?jPPAIFvHY7egnjVt0biZybZ/IfDIMwVK5mpHAojC31xnUuSKiNMYQxNIsUKP?=
 =?us-ascii?Q?54PR/n3iPuJYvKm9dU4nx2gSZ9Rzhv78iHVu+Eqd11rT8iy2CZzPBs2PFabP?=
 =?us-ascii?Q?osRf8+mu8J0LyUUBbZ8C2+hyVwMynpEDK9MKjKqAMwqkhTqLK0DzLQbKxCN8?=
 =?us-ascii?Q?5OCXfU0xR3aBxOhnIALBMmtmhRo/oUsWZ0G7UTYKCc7qYX774E9FRjESTSqF?=
 =?us-ascii?Q?2aGeIxlnRTrLNalgWQ7q+4EoI1ngQC81sJNDsuFm92RRVzCw5/FjzQ9ycv1Z?=
 =?us-ascii?Q?4YMq0z+xe/haG4J9Bs9AK2ovnLx20KAtK84OLBt7ytTTuvC1Vs+ZkfUyx+WB?=
 =?us-ascii?Q?Ohabi5zx6QmIzkR3d4JG7YQEoD8vGowhAuUCWwFkUPS+/Sqdm36n5IcczYlI?=
 =?us-ascii?Q?qGozK/S3OXNUx57NS02riTP7Pvp2u6HykyECUsv9pIzBPnZrDSboKfDM4UVV?=
 =?us-ascii?Q?3HFeujXEMUiMU1ETznpN0zuIu/cx0T4/lUbrS88EKBCp4s3VPggaKU1qC9WQ?=
 =?us-ascii?Q?f/LrwISeMgUZpuR4vqoNpB5FNMwYrMougVLMO2Ymm5T+CZQ1h5cuunGWU46T?=
 =?us-ascii?Q?/U+Rh3P8ZffVmuwQg9otrshy2fNEc0QHVEgQU2nHUNhLg+23gFUaI6JTgWWi?=
 =?us-ascii?Q?BzxDsoPX7Qys1HP8T1G3sjHLmq/SPNNFlAXe6YtohiMwMqV3z4kEPl1rErzP?=
 =?us-ascii?Q?jm2ArYtyDx6yq3W7852CeMAzO9VaHuKE0DhRLyxrwiwFNiDenkl+z/2j6exv?=
 =?us-ascii?Q?WFzsO3V9d1l0eiaIbzULZ/1+AZztBjL5IwDPYOtKEZDYupubrLDl0Llu0sOn?=
 =?us-ascii?Q?rlcNrb3mo19XP0h7c0ATpvnn2k8YrUOitSDx2FbHv2zPZV/YF0UTiFjEPgNg?=
 =?us-ascii?Q?S0TrHIjx2QcqBYNkhLPr+d/wL1p5HaaE3/XDt5R+6vmn4fVEqQ967iI1bgRQ?=
 =?us-ascii?Q?Usl+1hKElffkb/ecTxq3uZ0X7a9qOfbq8sc9TJ3UXzgtNS5nusT3QxUGwQEv?=
 =?us-ascii?Q?+7j6rxw5d89inQDuij8cuRBIPCrn79cXK6wXSGyFBo5Q+TINn3kmOKy3f1lF?=
 =?us-ascii?Q?COJz8Y46rpHiKrYFQGEpavvNxk1gpbYQ9ZHReKg1ioHyMcA5ePc/l4bdipm1?=
 =?us-ascii?Q?G3phPdnX49IrouurjOAkVjQ+PSI0Jc5Z2d1gcFgWw1QFI6PbNpYQiVHY7v8l?=
 =?us-ascii?Q?wTQNDAArm6jAECiJ+xYhViq5KjTjdwOn1laY8YPg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dcbe6bd-9d56-4500-ff15-08da580ba93d
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2022 07:07:13.4580
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hEc8l0vxF63DiH0B56XAPjgIL/Zm3hHWoxstsKhaZcY1JDWRF6jxVHcE+o6MUQYS8Z53F7Ym5pZKLpcNc6Zpyw==
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

Using unified bridge model, RITR register no longer configures the rFID
used for sub-port RIFs. It needs to be created by software via SFMR. Such
FIDs need to be created with a special flood indication using
'SFMR.flood_rsp=1'. It means that for such FIDs, router sub-port flooding
table will be used, this table is configured by firmware.

Set the above mentioned field as part of FID initialization and FID
edition, so then when other fields will be updated in SFMR, this field
will store the correct value and will not be overwritten.

Add 'flood_rsp' variable to 'struct mlxsw_sp_fid_family', set it to true
for rFID and to false for the rest.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h          |  3 ++-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c | 14 ++++++++++++--
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 7961f0c55fa6..80a02ba788bb 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -1960,7 +1960,7 @@ MLXSW_ITEM32(reg, sfmr, smpe, 0x28, 0, 16);
 
 static inline void mlxsw_reg_sfmr_pack(char *payload,
 				       enum mlxsw_reg_sfmr_op op, u16 fid,
-				       u16 fid_offset)
+				       u16 fid_offset, bool flood_rsp)
 {
 	MLXSW_REG_ZERO(sfmr, payload);
 	mlxsw_reg_sfmr_op_set(payload, op);
@@ -1968,6 +1968,7 @@ static inline void mlxsw_reg_sfmr_pack(char *payload,
 	mlxsw_reg_sfmr_fid_offset_set(payload, fid_offset);
 	mlxsw_reg_sfmr_vtfp_set(payload, false);
 	mlxsw_reg_sfmr_vv_set(payload, false);
+	mlxsw_reg_sfmr_flood_rsp_set(payload, flood_rsp);
 }
 
 /* SPVMLR - Switch Port VLAN MAC Learning Register
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
index fb04fbec7c82..b67b51addb7d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
@@ -109,6 +109,7 @@ struct mlxsw_sp_fid_family {
 	enum mlxsw_sp_rif_type rif_type;
 	const struct mlxsw_sp_fid_ops *ops;
 	struct mlxsw_sp *mlxsw_sp;
+	bool flood_rsp;
 };
 
 static const int mlxsw_sp_sfgc_uc_packet_types[MLXSW_REG_SFGC_TYPE_MAX] = {
@@ -422,9 +423,13 @@ static int mlxsw_sp_fid_op(const struct mlxsw_sp_fid *fid, bool valid)
 {
 	struct mlxsw_sp *mlxsw_sp = fid->fid_family->mlxsw_sp;
 	char sfmr_pl[MLXSW_REG_SFMR_LEN];
+	bool flood_rsp = false;
+
+	if (mlxsw_sp->ubridge)
+		flood_rsp = fid->fid_family->flood_rsp;
 
 	mlxsw_reg_sfmr_pack(sfmr_pl, mlxsw_sp_sfmr_op(valid), fid->fid_index,
-			    fid->fid_offset);
+			    fid->fid_offset, flood_rsp);
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(sfmr), sfmr_pl);
 }
 
@@ -432,9 +437,13 @@ static int mlxsw_sp_fid_edit_op(const struct mlxsw_sp_fid *fid)
 {
 	struct mlxsw_sp *mlxsw_sp = fid->fid_family->mlxsw_sp;
 	char sfmr_pl[MLXSW_REG_SFMR_LEN];
+	bool flood_rsp = false;
+
+	if (mlxsw_sp->ubridge)
+		flood_rsp = fid->fid_family->flood_rsp;
 
 	mlxsw_reg_sfmr_pack(sfmr_pl, MLXSW_REG_SFMR_OP_CREATE_FID,
-			    fid->fid_index, fid->fid_offset);
+			    fid->fid_index, fid->fid_offset, flood_rsp);
 	mlxsw_reg_sfmr_vv_set(sfmr_pl, fid->vni_valid);
 	mlxsw_reg_sfmr_vni_set(sfmr_pl, be32_to_cpu(fid->vni));
 	mlxsw_reg_sfmr_vtfp_set(sfmr_pl, fid->nve_flood_index_valid);
@@ -898,6 +907,7 @@ static const struct mlxsw_sp_fid_family mlxsw_sp_fid_rfid_family = {
 	.end_index		= MLXSW_SP_RFID_BASE + MLXSW_SP_RFID_MAX - 1,
 	.rif_type		= MLXSW_SP_RIF_TYPE_SUBPORT,
 	.ops			= &mlxsw_sp_fid_rfid_ops,
+	.flood_rsp		= true,
 };
 
 static void mlxsw_sp_fid_dummy_setup(struct mlxsw_sp_fid *fid, const void *arg)
-- 
2.36.1

