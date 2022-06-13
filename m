Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D793549A55
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 19:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241635AbiFMRqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 13:46:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239833AbiFMRqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 13:46:35 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2078.outbound.protection.outlook.com [40.107.243.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D141A16F918
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 06:22:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IHo4XixBcwcvm4iGXLH8NZ+grA8Tn8VFlJWTUA/4mm00hOPJ55+jpLpS8rFvTDdSzZLoTH07HxzrIa3R3Y2xHoZL8mczLlV9HNX6usqsU8Rqp6pspIcpjroNX3Zi/gEJsdtcyvEw3+6K13JgSg9ZGC+ZAYAqi4FoGUVE7wjJavKGqZalyhgghamsP9YGAcV40+aS6zjB4h3qnuVQ1WVjiE9954L/zB7cMxvBAyzhVCKTLbJzBU5GBA7g1RWAEVS1DqVXIVQXzliXtHnwC7/qHORq2GDEIgG8ojRqsdAmFfj5s0LWJi9lU87xtok8JNYsl795IOal6lJOKUNPXqNofQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z4e7b31c8xKN6DP7Pm/ACrof8kSYyc5btRPLO+deLR0=;
 b=Ocy6t0WZp9/v2XKONDCg7zx0OdvECfLngtLVOclT1IW+JN53MwPci8hHe5uLAFz2+XdaUY4E1Etzeadza/08madM+NCc5VjXMgueYPVrpPVhi0QNsMF+UN5GeA/OAqXRMJwzorJUvfzzRqZ6nlN1hYbBYG+ArgTwkAjC3RDpCl6Dz29MeWLP2dlsbsfzsTywOywvVlQTI41S3SZv5JBgMRwUIFwdLK40o7tc/1lVF72vQAq5VsoxAuA6AOag48lXNFTtj+Ob6i8/3AVqGMpSTK+u/onlyQTIaDyDVswJbKXc0mRem21XFxSKGOi1Y1vHg2iNH8VlX+txBkj9WixeyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z4e7b31c8xKN6DP7Pm/ACrof8kSYyc5btRPLO+deLR0=;
 b=P3WMpdIVen8pbMc6qkeNjSC9HGoNeGCyLV50hl7EqxnckdSvz9oLPnItZ+807/j+Y/EdMjBxRiJucC9atVO+2A7zL1FpkngGdUIVa7ou5opRUFd7ljooUyl/5dnrKoys+yB6Tz0YB4seChsqnqlHrVQp3mv7n92rDpyo7EPg2B9l5i/eqLcOOTLoKjsgXgla4U9rWQLs/HpdfWfm750YsooBXB/zR0ueSBzLxG1aJik5xT5WkGYwWKMKUEmPrbkOjk/eXPOTqKPL3y4c/yt3nnLXU3WqlkYEl6ykGLLn+v7QBLer0hqCk+/7HJyfUmwpv5y6MrPlPx9Xljk32/ARAQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BL1PR12MB5361.namprd12.prod.outlook.com (2603:10b6:208:31f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Mon, 13 Jun
 2022 13:22:15 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190%7]) with mapi id 15.20.5332.020; Mon, 13 Jun 2022
 13:22:15 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 3/3] mlxsw: Revert "Prepare for XM implementation - LPM trees"
Date:   Mon, 13 Jun 2022 16:21:16 +0300
Message-Id: <20220613132116.2021055-4-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613132116.2021055-1-idosch@nvidia.com>
References: <20220613132116.2021055-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR1P264CA0163.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:55::10) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 52c143b4-c7f3-49b9-75f5-08da4d3fbbd2
X-MS-TrafficTypeDiagnostic: BL1PR12MB5361:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5361F9803367F7EC78BF0CC8B2AB9@BL1PR12MB5361.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7pLGNj1J2Pcnyz+gWm03tN6sJk14omOH+VL6wmRKBX12M7+B++GrLmnpMLKKtNhDRCnOO+eFzSkrl+W1rV//GQecwojLqNpWpAQLfKt4Mwaux84MiQeRoBgj/Zz9YtWuchzL/p20jtJcX8SndTU9xz2DnIYrZfLEoJP5TtV/9XCuV0ejZJIb6oS6uAtEj3YWyQrISB8S1wEp0URIFuIkxVnPfuQF+3oKKkF6dRVR5D80G1GiWSbOwSv1queY+06GEXzwbGDCz70IddTbKOxfskyMpsko1pAU3VOJubvM7+m2IcNG1DFbJFbmYYcAjFWal9Z0D2hKMEqzDZUFGp2HoatlSQBEpnj1uoQM3atoetfez6ulhj3BAngpWPflT1oG+2+hux6cWyxrzuHFr5glYdjo6qk7fe781F+eQ4FdtVfbbqTwLoRK9n0K1V/GpKwg75fMQrynzDFDS2RUe518SOqgjybUNNzsJtOR4ngilIR8qI17eQo7v1Gyvn7sVG2cl/nhCdNR1oFHdu3akxZF6YFXSiy/YrdafqeiNvXYUujKFBzFyFOxYDgmb7ICeNRoXgQhHVboI1AuK6JAx/YotlwOy7nE2U7vPEc1dK+fvPaddCGp1fPz2Zc6/IHmJf/deeqagGdRE4fWbyzTHA8qKQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(316002)(6916009)(36756003)(66476007)(4326008)(66946007)(38100700002)(2906002)(8676002)(107886003)(86362001)(66556008)(66574015)(8936002)(6486002)(6512007)(2616005)(26005)(30864003)(5660300002)(6506007)(83380400001)(1076003)(508600001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XWZEUx3G4JqA2mRC1bf11UlURnPsznYqlJ8RTfxMxme8yl9UUxkXE4rZpXsf?=
 =?us-ascii?Q?rZRtqkLUKQkRzFEYJD1V6c1SpPsA98LMoGli3bNPpMnyIdo6CfrUheNy28rK?=
 =?us-ascii?Q?wWbQYJDDWVl/6/xlQIDZC/Gaiwhz7c9rZTF+reculmFAYv88Yq11Iv0JPS+Y?=
 =?us-ascii?Q?EfvqerUwWe2a4Pyp2GJzk2x2KdWs5DWlHHoJzCPBOshy0qyhgbfFDEEqmM90?=
 =?us-ascii?Q?DHjfEdr9AiBdrV52dKoKBKIbApFt17/vivOj0ZXe8lszlq2rxJ0B1VBTJFdv?=
 =?us-ascii?Q?0NGxOI/gaWweEfZAEDDYnVXIIuebj9iariSjfXGmVdpfzVez1T0kE6gT6ISD?=
 =?us-ascii?Q?TzgBTS4ExcrBzoFl/goUoRdOPN6TnR3N2dmEsJF6Q9waets1F70nuHoBp6u/?=
 =?us-ascii?Q?8GYOISncIBWCvC5y+g4HrsDHhrnIdKzLHX8lN7UZUNYohnDJaKBPUyQenXCn?=
 =?us-ascii?Q?FVAeaL/AZd8QNFqx6QHmxtFKe8HbOudKqCw2gQZ6xJI+jj0ZI2TzWtPNiShc?=
 =?us-ascii?Q?S9OTWYcKYPbgpvJwE9l4rKYy+7lHS+yJ/uMSMEgf7126MVtwxPAR8uJhPc6P?=
 =?us-ascii?Q?QHlqMDYM0dShvJ/2GMZ+UAJWIEHRCHYrsBRWiNjSGlhVkBDTDu8FEdW92XTO?=
 =?us-ascii?Q?qG5er84WTOyr/qiNTl4ICgrJX1j79hwrkCexhj4lVLmTELl36nSWgBF7t0Ag?=
 =?us-ascii?Q?FffN2DYt9+K41Q3NKRnm04DwIeIidZfIpQBd8qmRlZpyzJl3UtFkTUK1wj+O?=
 =?us-ascii?Q?X/F6SxOhzHnxhSse8TPjIwE/qzK5ybSYYasznPfhzpkPDw7EG7WyMgJXYO8P?=
 =?us-ascii?Q?z/QRNzqt5u5cdQ8LiVBdsaknAg8jrd4L6ax0KS0rkm9Vq5ARwIDzRHr/P/PW?=
 =?us-ascii?Q?S29ejb7bGUETDgoRO74OKpH8lxkcMUqOWlRR44glp/eYkMPv2KhsEj/8VCz3?=
 =?us-ascii?Q?Gq+UKuO6P5hnW8SUWG3aB92PYnZXIDHXmoLYfcnuSlJiAGnslOIN333iYyZ0?=
 =?us-ascii?Q?fBzym2up/A/IMYOWo+ZuKlRQvwMPuumFWMEedPlPpUNXT8EgI07LYJhPVsg+?=
 =?us-ascii?Q?Z6esuWzuHMPLOmaxC9fopt8LhKCzc3LYYH3PABDqF29UhoklgjSyHlvvcSVy?=
 =?us-ascii?Q?V1cnIwlazw2SowiVjk6gMUvtg458EMffVsJRGmoFBoO6NJtuX8VsWiRsg7li?=
 =?us-ascii?Q?zXAe87sh/7xkXuMGiQZtuIJmDRin6cETkxeaQWV1vLio+VPjTngjADX7p+JM?=
 =?us-ascii?Q?u/51khcyYTw9IG5artfLkLOVEfdzL/dw5tIctjBK8RsiT+/TWPtWIO407ptm?=
 =?us-ascii?Q?5+RDrz8yVehosL2+GhGSnZK75rScvTiH8oAwrxO0PA8xFWnFlm/5odw3rnWN?=
 =?us-ascii?Q?0ruk9pu4gqDLqQa2HFA1/Jv+xZca8pEQI8K+isihBaqjUiSb1oURh3ZAx8ns?=
 =?us-ascii?Q?/ObuxWk+4BG2YQAH8mAEhX/LM8XAoj6rV4K+8YgGl55oqodWXMcTFqm6APvW?=
 =?us-ascii?Q?ZwBxzFoSZGL0gBwk2RpL85wbH2Lows1iZJkAMrBRDLm9FcT3xLMTSwb7RtKR?=
 =?us-ascii?Q?vI2mElWi7YKPnxOq/zLeTgUYZyX/7Huqha9UtmMI93qL+qqUKp9rBOT45Jvz?=
 =?us-ascii?Q?zupilCtIvUYyIGxiZ9GnY1QfONlpLTunVXdGQDomX0+BfotQIrUzy+H4hIRh?=
 =?us-ascii?Q?4fj+OxR4Ca2QnyuhHFGeaX2pJvibnNutB3mxxiakmj9D6rMGj97t1YNJGu1d?=
 =?us-ascii?Q?vZTUjvQv0A=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52c143b4-c7f3-49b9-75f5-08da4d3fbbd2
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2022 13:22:15.6694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t69qEPe6OFamTEFQ0mxs3+lN9EEP99VWrCgqVzh4Z9Srz2tJoBNHNFSEnlqbQ/RhNEeNFggqgjbOMb9U3FEm6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5361
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

This reverts commit 923ba95ea22d ("Merge branch
'mlxsw-spectrum-prepare-for-xm-implementation-lpm-trees'").

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  83 ---------------
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 100 ++++++------------
 .../ethernet/mellanox/mlxsw/spectrum_router.h |  11 --
 3 files changed, 31 insertions(+), 163 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index d1a94c22ee60..d830a35755a8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -8924,86 +8924,6 @@ mlxsw_reg_rmft2_ipv6_pack(char *payload, bool v, u16 offset, u16 virtual_router,
 	mlxsw_reg_rmft2_sip6_mask_memcpy_to(payload, (void *)&sip6_mask);
 }
 
-/* Note that XRALXX register position violates the rule of ordering register
- * definition by the ID. However, XRALXX pack helpers are using RALXX pack
- * helpers, RALXX registers have higher IDs.
- */
-
-/* XRALTA - XM Router Algorithmic LPM Tree Allocation Register
- * -----------------------------------------------------------
- * The XRALTA is used to allocate the XLT LPM trees.
- *
- * This register embeds original RALTA register.
- */
-#define MLXSW_REG_XRALTA_ID 0x7811
-#define MLXSW_REG_XRALTA_LEN 0x08
-#define MLXSW_REG_XRALTA_RALTA_OFFSET 0x04
-
-MLXSW_REG_DEFINE(xralta, MLXSW_REG_XRALTA_ID, MLXSW_REG_XRALTA_LEN);
-
-static inline void mlxsw_reg_xralta_pack(char *payload, bool alloc,
-					 enum mlxsw_reg_ralxx_protocol protocol,
-					 u8 tree_id)
-{
-	char *ralta_payload = payload + MLXSW_REG_XRALTA_RALTA_OFFSET;
-
-	MLXSW_REG_ZERO(xralta, payload);
-	mlxsw_reg_ralta_pack(ralta_payload, alloc, protocol, tree_id);
-}
-
-/* XRALST - XM Router Algorithmic LPM Structure Tree Register
- * ----------------------------------------------------------
- * The XRALST is used to set and query the structure of an XLT LPM tree.
- *
- * This register embeds original RALST register.
- */
-#define MLXSW_REG_XRALST_ID 0x7812
-#define MLXSW_REG_XRALST_LEN 0x108
-#define MLXSW_REG_XRALST_RALST_OFFSET 0x04
-
-MLXSW_REG_DEFINE(xralst, MLXSW_REG_XRALST_ID, MLXSW_REG_XRALST_LEN);
-
-static inline void mlxsw_reg_xralst_pack(char *payload, u8 root_bin, u8 tree_id)
-{
-	char *ralst_payload = payload + MLXSW_REG_XRALST_RALST_OFFSET;
-
-	MLXSW_REG_ZERO(xralst, payload);
-	mlxsw_reg_ralst_pack(ralst_payload, root_bin, tree_id);
-}
-
-static inline void mlxsw_reg_xralst_bin_pack(char *payload, u8 bin_number,
-					     u8 left_child_bin,
-					     u8 right_child_bin)
-{
-	char *ralst_payload = payload + MLXSW_REG_XRALST_RALST_OFFSET;
-
-	mlxsw_reg_ralst_bin_pack(ralst_payload, bin_number, left_child_bin,
-				 right_child_bin);
-}
-
-/* XRALTB - XM Router Algorithmic LPM Tree Binding Register
- * --------------------------------------------------------
- * The XRALTB register is used to bind virtual router and protocol
- * to an allocated LPM tree.
- *
- * This register embeds original RALTB register.
- */
-#define MLXSW_REG_XRALTB_ID 0x7813
-#define MLXSW_REG_XRALTB_LEN 0x08
-#define MLXSW_REG_XRALTB_RALTB_OFFSET 0x04
-
-MLXSW_REG_DEFINE(xraltb, MLXSW_REG_XRALTB_ID, MLXSW_REG_XRALTB_LEN);
-
-static inline void mlxsw_reg_xraltb_pack(char *payload, u16 virtual_router,
-					 enum mlxsw_reg_ralxx_protocol protocol,
-					 u8 tree_id)
-{
-	char *raltb_payload = payload + MLXSW_REG_XRALTB_RALTB_OFFSET;
-
-	MLXSW_REG_ZERO(xraltb, payload);
-	mlxsw_reg_raltb_pack(raltb_payload, virtual_router, protocol, tree_id);
-}
-
 /* MFCR - Management Fan Control Register
  * --------------------------------------
  * This register controls the settings of the Fan Speed PWM mechanism.
@@ -12510,9 +12430,6 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(rigr2),
 	MLXSW_REG(recr2),
 	MLXSW_REG(rmft2),
-	MLXSW_REG(xralta),
-	MLXSW_REG(xralst),
-	MLXSW_REG(xraltb),
 	MLXSW_REG(mfcr),
 	MLXSW_REG(mfsc),
 	MLXSW_REG(mfsm),
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 1b389e4ad3af..e3f52019cbcb 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -484,7 +484,6 @@ struct mlxsw_sp_fib {
 	struct mlxsw_sp_vr *vr;
 	struct mlxsw_sp_lpm_tree *lpm_tree;
 	enum mlxsw_sp_l3proto proto;
-	const struct mlxsw_sp_router_ll_ops *ll_ops;
 };
 
 struct mlxsw_sp_vr {
@@ -498,31 +497,12 @@ struct mlxsw_sp_vr {
 	refcount_t ul_rif_refcnt;
 };
 
-static int mlxsw_sp_router_ll_basic_ralta_write(struct mlxsw_sp *mlxsw_sp, char *xralta_pl)
-{
-	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ralta),
-			       xralta_pl + MLXSW_REG_XRALTA_RALTA_OFFSET);
-}
-
-static int mlxsw_sp_router_ll_basic_ralst_write(struct mlxsw_sp *mlxsw_sp, char *xralst_pl)
-{
-	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ralst),
-			       xralst_pl + MLXSW_REG_XRALST_RALST_OFFSET);
-}
-
-static int mlxsw_sp_router_ll_basic_raltb_write(struct mlxsw_sp *mlxsw_sp, char *xraltb_pl)
-{
-	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(raltb),
-			       xraltb_pl + MLXSW_REG_XRALTB_RALTB_OFFSET);
-}
-
 static const struct rhashtable_params mlxsw_sp_fib_ht_params;
 
 static struct mlxsw_sp_fib *mlxsw_sp_fib_create(struct mlxsw_sp *mlxsw_sp,
 						struct mlxsw_sp_vr *vr,
 						enum mlxsw_sp_l3proto proto)
 {
-	const struct mlxsw_sp_router_ll_ops *ll_ops = mlxsw_sp->router->proto_ll_ops[proto];
 	struct mlxsw_sp_lpm_tree *lpm_tree;
 	struct mlxsw_sp_fib *fib;
 	int err;
@@ -538,7 +518,6 @@ static struct mlxsw_sp_fib *mlxsw_sp_fib_create(struct mlxsw_sp *mlxsw_sp,
 	fib->proto = proto;
 	fib->vr = vr;
 	fib->lpm_tree = lpm_tree;
-	fib->ll_ops = ll_ops;
 	mlxsw_sp_lpm_tree_hold(lpm_tree);
 	err = mlxsw_sp_vr_lpm_tree_bind(mlxsw_sp, fib, lpm_tree->id);
 	if (err)
@@ -577,36 +556,33 @@ mlxsw_sp_lpm_tree_find_unused(struct mlxsw_sp *mlxsw_sp)
 }
 
 static int mlxsw_sp_lpm_tree_alloc(struct mlxsw_sp *mlxsw_sp,
-				   const struct mlxsw_sp_router_ll_ops *ll_ops,
 				   struct mlxsw_sp_lpm_tree *lpm_tree)
 {
-	char xralta_pl[MLXSW_REG_XRALTA_LEN];
+	char ralta_pl[MLXSW_REG_RALTA_LEN];
 
-	mlxsw_reg_xralta_pack(xralta_pl, true,
-			      (enum mlxsw_reg_ralxx_protocol) lpm_tree->proto,
-			      lpm_tree->id);
-	return ll_ops->ralta_write(mlxsw_sp, xralta_pl);
+	mlxsw_reg_ralta_pack(ralta_pl, true,
+			     (enum mlxsw_reg_ralxx_protocol) lpm_tree->proto,
+			     lpm_tree->id);
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ralta), ralta_pl);
 }
 
 static void mlxsw_sp_lpm_tree_free(struct mlxsw_sp *mlxsw_sp,
-				   const struct mlxsw_sp_router_ll_ops *ll_ops,
 				   struct mlxsw_sp_lpm_tree *lpm_tree)
 {
-	char xralta_pl[MLXSW_REG_XRALTA_LEN];
+	char ralta_pl[MLXSW_REG_RALTA_LEN];
 
-	mlxsw_reg_xralta_pack(xralta_pl, false,
-			      (enum mlxsw_reg_ralxx_protocol) lpm_tree->proto,
-			      lpm_tree->id);
-	ll_ops->ralta_write(mlxsw_sp, xralta_pl);
+	mlxsw_reg_ralta_pack(ralta_pl, false,
+			     (enum mlxsw_reg_ralxx_protocol) lpm_tree->proto,
+			     lpm_tree->id);
+	mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ralta), ralta_pl);
 }
 
 static int
 mlxsw_sp_lpm_tree_left_struct_set(struct mlxsw_sp *mlxsw_sp,
-				  const struct mlxsw_sp_router_ll_ops *ll_ops,
 				  struct mlxsw_sp_prefix_usage *prefix_usage,
 				  struct mlxsw_sp_lpm_tree *lpm_tree)
 {
-	char xralst_pl[MLXSW_REG_XRALST_LEN];
+	char ralst_pl[MLXSW_REG_RALST_LEN];
 	u8 root_bin = 0;
 	u8 prefix;
 	u8 last_prefix = MLXSW_REG_RALST_BIN_NO_CHILD;
@@ -614,20 +590,19 @@ mlxsw_sp_lpm_tree_left_struct_set(struct mlxsw_sp *mlxsw_sp,
 	mlxsw_sp_prefix_usage_for_each(prefix, prefix_usage)
 		root_bin = prefix;
 
-	mlxsw_reg_xralst_pack(xralst_pl, root_bin, lpm_tree->id);
+	mlxsw_reg_ralst_pack(ralst_pl, root_bin, lpm_tree->id);
 	mlxsw_sp_prefix_usage_for_each(prefix, prefix_usage) {
 		if (prefix == 0)
 			continue;
-		mlxsw_reg_xralst_bin_pack(xralst_pl, prefix, last_prefix,
-					  MLXSW_REG_RALST_BIN_NO_CHILD);
+		mlxsw_reg_ralst_bin_pack(ralst_pl, prefix, last_prefix,
+					 MLXSW_REG_RALST_BIN_NO_CHILD);
 		last_prefix = prefix;
 	}
-	return ll_ops->ralst_write(mlxsw_sp, xralst_pl);
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ralst), ralst_pl);
 }
 
 static struct mlxsw_sp_lpm_tree *
 mlxsw_sp_lpm_tree_create(struct mlxsw_sp *mlxsw_sp,
-			 const struct mlxsw_sp_router_ll_ops *ll_ops,
 			 struct mlxsw_sp_prefix_usage *prefix_usage,
 			 enum mlxsw_sp_l3proto proto)
 {
@@ -638,11 +613,12 @@ mlxsw_sp_lpm_tree_create(struct mlxsw_sp *mlxsw_sp,
 	if (!lpm_tree)
 		return ERR_PTR(-EBUSY);
 	lpm_tree->proto = proto;
-	err = mlxsw_sp_lpm_tree_alloc(mlxsw_sp, ll_ops, lpm_tree);
+	err = mlxsw_sp_lpm_tree_alloc(mlxsw_sp, lpm_tree);
 	if (err)
 		return ERR_PTR(err);
 
-	err = mlxsw_sp_lpm_tree_left_struct_set(mlxsw_sp, ll_ops, prefix_usage, lpm_tree);
+	err = mlxsw_sp_lpm_tree_left_struct_set(mlxsw_sp, prefix_usage,
+						lpm_tree);
 	if (err)
 		goto err_left_struct_set;
 	memcpy(&lpm_tree->prefix_usage, prefix_usage,
@@ -653,15 +629,14 @@ mlxsw_sp_lpm_tree_create(struct mlxsw_sp *mlxsw_sp,
 	return lpm_tree;
 
 err_left_struct_set:
-	mlxsw_sp_lpm_tree_free(mlxsw_sp, ll_ops, lpm_tree);
+	mlxsw_sp_lpm_tree_free(mlxsw_sp, lpm_tree);
 	return ERR_PTR(err);
 }
 
 static void mlxsw_sp_lpm_tree_destroy(struct mlxsw_sp *mlxsw_sp,
-				      const struct mlxsw_sp_router_ll_ops *ll_ops,
 				      struct mlxsw_sp_lpm_tree *lpm_tree)
 {
-	mlxsw_sp_lpm_tree_free(mlxsw_sp, ll_ops, lpm_tree);
+	mlxsw_sp_lpm_tree_free(mlxsw_sp, lpm_tree);
 }
 
 static struct mlxsw_sp_lpm_tree *
@@ -669,7 +644,6 @@ mlxsw_sp_lpm_tree_get(struct mlxsw_sp *mlxsw_sp,
 		      struct mlxsw_sp_prefix_usage *prefix_usage,
 		      enum mlxsw_sp_l3proto proto)
 {
-	const struct mlxsw_sp_router_ll_ops *ll_ops = mlxsw_sp->router->proto_ll_ops[proto];
 	struct mlxsw_sp_lpm_tree *lpm_tree;
 	int i;
 
@@ -683,7 +657,7 @@ mlxsw_sp_lpm_tree_get(struct mlxsw_sp *mlxsw_sp,
 			return lpm_tree;
 		}
 	}
-	return mlxsw_sp_lpm_tree_create(mlxsw_sp, ll_ops, prefix_usage, proto);
+	return mlxsw_sp_lpm_tree_create(mlxsw_sp, prefix_usage, proto);
 }
 
 static void mlxsw_sp_lpm_tree_hold(struct mlxsw_sp_lpm_tree *lpm_tree)
@@ -694,11 +668,8 @@ static void mlxsw_sp_lpm_tree_hold(struct mlxsw_sp_lpm_tree *lpm_tree)
 static void mlxsw_sp_lpm_tree_put(struct mlxsw_sp *mlxsw_sp,
 				  struct mlxsw_sp_lpm_tree *lpm_tree)
 {
-	const struct mlxsw_sp_router_ll_ops *ll_ops =
-				mlxsw_sp->router->proto_ll_ops[lpm_tree->proto];
-
 	if (--lpm_tree->ref_count == 0)
-		mlxsw_sp_lpm_tree_destroy(mlxsw_sp, ll_ops, lpm_tree);
+		mlxsw_sp_lpm_tree_destroy(mlxsw_sp, lpm_tree);
 }
 
 #define MLXSW_SP_LPM_TREE_MIN 1 /* tree 0 is reserved */
@@ -788,23 +759,23 @@ static struct mlxsw_sp_vr *mlxsw_sp_vr_find_unused(struct mlxsw_sp *mlxsw_sp)
 static int mlxsw_sp_vr_lpm_tree_bind(struct mlxsw_sp *mlxsw_sp,
 				     const struct mlxsw_sp_fib *fib, u8 tree_id)
 {
-	char xraltb_pl[MLXSW_REG_XRALTB_LEN];
+	char raltb_pl[MLXSW_REG_RALTB_LEN];
 
-	mlxsw_reg_xraltb_pack(xraltb_pl, fib->vr->id,
-			      (enum mlxsw_reg_ralxx_protocol) fib->proto,
-			      tree_id);
-	return fib->ll_ops->raltb_write(mlxsw_sp, xraltb_pl);
+	mlxsw_reg_raltb_pack(raltb_pl, fib->vr->id,
+			     (enum mlxsw_reg_ralxx_protocol) fib->proto,
+			     tree_id);
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(raltb), raltb_pl);
 }
 
 static int mlxsw_sp_vr_lpm_tree_unbind(struct mlxsw_sp *mlxsw_sp,
 				       const struct mlxsw_sp_fib *fib)
 {
-	char xraltb_pl[MLXSW_REG_XRALTB_LEN];
+	char raltb_pl[MLXSW_REG_RALTB_LEN];
 
 	/* Bind to tree 0 which is default */
-	mlxsw_reg_xraltb_pack(xraltb_pl, fib->vr->id,
-			      (enum mlxsw_reg_ralxx_protocol) fib->proto, 0);
-	return fib->ll_ops->raltb_write(mlxsw_sp, xraltb_pl);
+	mlxsw_reg_raltb_pack(raltb_pl, fib->vr->id,
+			     (enum mlxsw_reg_ralxx_protocol) fib->proto, 0);
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(raltb), raltb_pl);
 }
 
 static u32 mlxsw_sp_fix_tb_id(u32 tb_id)
@@ -10245,12 +10216,6 @@ static void __mlxsw_sp_router_fini(struct mlxsw_sp *mlxsw_sp)
 	mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(rgcr), rgcr_pl);
 }
 
-static const struct mlxsw_sp_router_ll_ops mlxsw_sp_router_ll_basic_ops = {
-	.ralta_write = mlxsw_sp_router_ll_basic_ralta_write,
-	.ralst_write = mlxsw_sp_router_ll_basic_ralst_write,
-	.raltb_write = mlxsw_sp_router_ll_basic_raltb_write,
-};
-
 static int mlxsw_sp_lb_rif_init(struct mlxsw_sp *mlxsw_sp)
 {
 	u16 lb_rif_index;
@@ -10324,9 +10289,6 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 	if (err)
 		goto err_router_ops_init;
 
-	router->proto_ll_ops[MLXSW_SP_L3_PROTO_IPV4] = &mlxsw_sp_router_ll_basic_ops;
-	router->proto_ll_ops[MLXSW_SP_L3_PROTO_IPV6] = &mlxsw_sp_router_ll_basic_ops;
-
 	INIT_LIST_HEAD(&mlxsw_sp->router->nh_res_grp_list);
 	INIT_DELAYED_WORK(&mlxsw_sp->router->nh_grp_activity_dw,
 			  mlxsw_sp_nh_grp_activity_work);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
index f646a5d3a9c2..f7510be1cf2d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
@@ -51,8 +51,6 @@ struct mlxsw_sp_router {
 	const struct mlxsw_sp_ipip_ops **ipip_ops_arr;
 	struct mlxsw_sp_router_nve_decap nve_decap_config;
 	struct mutex lock; /* Protects shared router resources */
-	/* One set of ops for each protocol: IPv4 and IPv6 */
-	const struct mlxsw_sp_router_ll_ops *proto_ll_ops[MLXSW_SP_L3_PROTO_MAX];
 	struct mlxsw_sp_fib_entry_op_ctx *ll_op_ctx;
 	u16 lb_rif_index;
 	const struct mlxsw_sp_adj_grp_size_range *adj_grp_size_ranges;
@@ -64,15 +62,6 @@ struct mlxsw_sp_router {
 	u32 adj_trap_index;
 };
 
-/* Low-level router ops. Basically this is to handle the different
- * register sets to work with ordinary and XM trees and FIB entries.
- */
-struct mlxsw_sp_router_ll_ops {
-	int (*ralta_write)(struct mlxsw_sp *mlxsw_sp, char *xralta_pl);
-	int (*ralst_write)(struct mlxsw_sp *mlxsw_sp, char *xralst_pl);
-	int (*raltb_write)(struct mlxsw_sp *mlxsw_sp, char *xraltb_pl);
-};
-
 struct mlxsw_sp_rif_ipip_lb;
 struct mlxsw_sp_rif_ipip_lb_config {
 	enum mlxsw_reg_ritr_loopback_ipip_type lb_ipipt;
-- 
2.36.1

