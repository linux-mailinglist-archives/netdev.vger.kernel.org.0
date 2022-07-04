Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6C1564D8E
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 08:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231187AbiGDGN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 02:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232651AbiGDGNZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 02:13:25 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2084.outbound.protection.outlook.com [40.107.212.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1344EE9D
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 23:13:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bbvUhjs5AgkCZ+YrPRrA6Xmr5F4/Q6keCH/yOm2I34IMB5aRWRX4B8XZ6zE+/UHNkqXPT+pcHBq8gImOaGXSePo6L43aT2EiGDaj9agaLQUxe2L2iv5W7TKMGSIUeuekAhypv1HTAi9l3f/8oU4xlG2BdcZId2Tde9+LxvmXqMG1hC9+RriyHBPjGkyxxljdsWgtlaFCDhjkT7MQXLMI8IMb+QAsAHZNo2kGnN36PeWnKHcuGVZ/gKE96QL/TKcT3ifF5urQE5XkdYMMOY1NWk4FHw8YTlj143HowYeCKhf1QPtUs7kx4H3u02rXiBNhO65MouaKruR7VVN4CD9SSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cFg0tp+nt3EpWJFxyzPa9qs4SQq6bJ5ikQ+nhANplF0=;
 b=fM0oj+RWYO/lvs6bCf8lTYKDVx1KK7If6ZDTDsCLIeJ6fDnyZo1nSSIWKdwXTRl9sHjvfqS3GpPeSKVflkxDZ5MdQgDscVhCTzAhnl1PjfFuz5YTo1Awg/FtRHlb/114OL56W6vAtXNvIb2rsyi6kNkz09jizkR31JHmOwk96opTsrMKcw8AoWxU8Kas94o7sFmlFClwRiDMc/wR5Wi4IhEGLm94s78hX7iEZvbdlt0bhFGA2wvrZbdUlT79ApPLpB/wieVozQ0Q/D/HDc3V9yiWKxJTjnUq1JcuuZVHjSaP5WbtE3xqKRsAO3wfzqHLxAQsVZmfaYMqGIx+JrVBxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cFg0tp+nt3EpWJFxyzPa9qs4SQq6bJ5ikQ+nhANplF0=;
 b=rU2k9m64XUh5mTgxgWk3ywLk2P43WkGTfaLcddIShxmXrq+Y4kJYIM1DGEMA6HZrISviUPIiRvFiSJKgLotdW6CfctPn0TMWEGQ8BVkkJY4rQw9OiZ8OYfQxXVsnhKI+ImwiXArAHwlisKPSy4IdTQF8Dw+x7GE+apoHRPzY0cDNnOgh7o4zDcmS5t6lm6r+QwOGeHIKNWmJtg+rxBRp6J1dcIn1EqE4wGuurGANhcK6nmDvmRiwpnjo6jUnWRyq425eiO0m7hWn1xrN7uES1MhtZqnMAwXPmpaByswlBdqM26DwIeHXogwCADLYZ6/gQXA5v0kDA9kwRfztkxcLKA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM6PR12MB3068.namprd12.prod.outlook.com (2603:10b6:5:3e::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Mon, 4 Jul
 2022 06:13:21 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%7]) with mapi id 15.20.5395.020; Mon, 4 Jul 2022
 06:13:21 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 06/13] mlxsw: Configure egress FID classification after routing
Date:   Mon,  4 Jul 2022 09:11:32 +0300
Message-Id: <20220704061139.1208770-7-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220704061139.1208770-1-idosch@nvidia.com>
References: <20220704061139.1208770-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P190CA0016.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:2b::29) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a0fc33fe-2d4e-46d2-f803-08da5d844b88
X-MS-TrafficTypeDiagnostic: DM6PR12MB3068:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hENfDhrAuHH3Qglzau7ywZtgR99Y4dXStAD+BzNrYCG1mhI8Yj4ANorP2eqp+cvlDmycDQI6Ss2yC3nyGpIyls+s+stMaDRGQlGzrJvTelHDHsh3+k7TUgxSsnQhJGpWr8jo6ilEtL4smJSmqxzCAeXAXm+BCmPUXQUQFaFdok0UJuDqU4WuMXeVc9S7qUL9BTzCEpgNdkXWzja4A1lXJ9t42MteU+N1zziOXNYo5milWQYhWvY0PHOfDMpclFOSGRUoy9cc573OxsTe+VyKnK8W4XZxMxsvgpu9Hth0kgsIStMeRTsGDHNM/z0ZN2psClh8ysHNkanzyv9cma9FJZbgBXAc/O9og3Qhoe4Oie6Wl2wuqa1wonvOcfs3sw6JK/P4obXKQyTijGNfWlSjF5v+F2z498hZCpG9yUpLWEcs0KoXTPQ6ZOBVBmLsJjjhLVVJ4kwtfJdFq+IN11V7wxXxGsPgkJA1uwSy5BRUaJQj0wCRJqBkQiFHaJvIYl27oPBOzP+xL2iqveX8n7lhmIRV7PIR71oCliUAWyIq8FkTRSH1UQLIyX4BI9cXZrh5JfiZz2Omb6EgoSsYUK2CaxWGtiEbqGov+Yy9BbsV3uq25EAgZJcLtTGb+F8HWeYGBeGS3HZv30zfmaqvvng21WJc2qB2kCteA81MS0piBAcSexys4ktVHtKNfPJFcLrPLeScGTtEmSkGQWAfzGOXCQS0x2XYOEe22+hBIm1s4McKXXVVzOhkys4BfqPs340hNczIdt8s1klLlBc73lbTRg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(376002)(366004)(346002)(39860400002)(6666004)(6506007)(6512007)(4326008)(2616005)(8676002)(66946007)(26005)(66476007)(66556008)(6486002)(6916009)(86362001)(41300700001)(316002)(38100700002)(186003)(1076003)(107886003)(66574015)(83380400001)(478600001)(2906002)(8936002)(5660300002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wAfqADQQQJrcMVcVTPxPT3tMUbl8WU+ewGtzZzYQ4gvBrGoCFSKFpvD9YXvu?=
 =?us-ascii?Q?iXTUNRBtuS+npI9JyWMf1t+Vdyak9Vv57FWgqYTU+iafq0W/CHf9zOR5PaGz?=
 =?us-ascii?Q?CKFEgv99anxaWIj1a/EeXKuk/Hm+hWCDnmt8d83dSE0OQ89bch0xp8F+T/JS?=
 =?us-ascii?Q?fsVmc9E+viv29lAP4urbThprayiOFQORqAZ/tn8t/dPls718qqSsvp8ZLQBX?=
 =?us-ascii?Q?9UVAEMHmhtS9t4k8bxl0kI0xA74Ojezl07q3U0vjxqbn49PnD35ZgCsWS4V3?=
 =?us-ascii?Q?gPrnzbs+eF+Te8WPRH0gosFcXEAtKBHnCs5mZZEAUWV/59mEAdbN52NBVX+a?=
 =?us-ascii?Q?kVlbXtjWj9eh0D5L433Y89l76ILohHNgb0ZhOUhSNE5FuX7hzETwylIFpAIy?=
 =?us-ascii?Q?uJLfXSnqLVue1fvnTDO8LaujAVJ5JUCT2+9Uh1Z3q0v84yqFoODUk0m2mYZV?=
 =?us-ascii?Q?jb2YpjfoSh08XWYuXKmuNh1aBlwAJQqPwfgIQi1Zpuro3jc3kJGKjeaCsrnE?=
 =?us-ascii?Q?COJW3VzHFA7UU4HoKYvvNmNAY6qPJjDxCyphPmnn6ZbHpzv/vfP73WIFVXf7?=
 =?us-ascii?Q?DEPqfP513UgsaoxcQGXZ+a+G+PoZ0+x+zdynnaOpAvoHinWBLZdTnV0Yio6w?=
 =?us-ascii?Q?Pa9RcSc8NWnDkQngc+aogMCqoZEXbBtuQTu6hnOGl42Lsp7u3IaTtgk27ahS?=
 =?us-ascii?Q?J/+XFGllzqDDMN3HeZCE+9xDvFGDjhUr3OgzeFmXWFJ4pAeNjsS3Jy/Ez+9Z?=
 =?us-ascii?Q?4L0W4CFdFqYX2C4ZkOxaVjdJa7+Y12v+Mv0WZXRdnuH9dSLtOvOW1FqoAK9P?=
 =?us-ascii?Q?eN6kGFNnm2QJ+o1pJ3bYxRgH2WZbcwBkvdfTnEU+Rvxb5NVmrCSVh6TZVJ/e?=
 =?us-ascii?Q?bVuIsUGk6HfjPHkOnBbsHGtQ+7qyuhdEd6/OJgDiddEswl0FjjFli/b7SOn7?=
 =?us-ascii?Q?nGd5rngS9hWRx3wENgYuN+qFeV+b/mbWrc18fd3gH/x/TO9tAX4YyS+cX2ZK?=
 =?us-ascii?Q?u+3TFWPTrnQ5m7xOIHuw0LHwK5cPziYCQ0E6meuQ/OSlZocM9+1E38N+JGCh?=
 =?us-ascii?Q?fA0nqAdd6JELbtRl117s1mHC9vSJdGJigSPk+eqaotyfuAg/GPPk2kV4ZL60?=
 =?us-ascii?Q?ULICQiI80jM4MfU+9JVP7+HY2MAeuPnC3nXyRrowBzTYG1JMLw7SMJNa2Muo?=
 =?us-ascii?Q?Mvc+CIA+XpTaVDgGb7riaCl4wbas4zfd93VV9Wzr6EBxfdJz98+5NLCm3VbB?=
 =?us-ascii?Q?T0CbC4FP0FXvt1WiwlHLegv1A0EmEw84qmCynLi21laCkaOAoQvwJINbpEcq?=
 =?us-ascii?Q?cx6CUHI+N1uwU9/XTbB2zmTsBxFYnQT5HvJPtuqjZy5gcQ/Ex3o5sFuUeurD?=
 =?us-ascii?Q?Rg7au3jnTtD4joEQ5uuT+LrBz/DARVx3SpmvQ2C/xiyQhkP+sEclkt+4RP30?=
 =?us-ascii?Q?FHosDbJRlMY7lWp7ZcMoN1u6lLZmidinMSLa7dqy4AP1/124Z/QRgB6VATkA?=
 =?us-ascii?Q?84A19cHDB1wxlWcQKn6fBbcG6L5j6M9jlJWE7LQcFubaER3gGlHwyMh452k3?=
 =?us-ascii?Q?WhLmM4h0C1if5SyrqQ5VnODN1DtoWB6+AAJ6AH9A?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0fc33fe-2d4e-46d2-f803-08da5d844b88
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2022 06:13:21.2242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: trYqfrD2H9H5I0ul6cCSHK1/WDqYnYdYpGdURliqfoAz3p/Q0kfkc8Bh1PF0Vt1uwxSoaHM2YkAW+d+02JZS5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3068
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

After routing, a packet needs to perform an L2 lookup using the DMAC it got
from the routing and a FID. In unified bridge model, the egress FID
configuration needs to be performed by software.

It is configured by RITR for both sub-port RIFs and FID RIFs. Currently
FID RIFs already configure eFID. Add eFID configuration for sub-port RIFs.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h             | 3 ++-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 46ed2c1810be..520b990054eb 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -7113,10 +7113,11 @@ static inline void mlxsw_reg_ritr_rif_pack(char *payload, u16 rif)
 }
 
 static inline void mlxsw_reg_ritr_sp_if_pack(char *payload, bool lag,
-					     u16 system_port, u16 vid)
+					     u16 system_port, u16 efid, u16 vid)
 {
 	mlxsw_reg_ritr_sp_if_lag_set(payload, lag);
 	mlxsw_reg_ritr_sp_if_system_port_set(payload, system_port);
+	mlxsw_reg_ritr_sp_if_efid_set(payload, efid);
 	mlxsw_reg_ritr_sp_if_vid_set(payload, vid);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index fe3ae524f340..eec4fb0561e9 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -9316,15 +9316,18 @@ static int mlxsw_sp_rif_subport_op(struct mlxsw_sp_rif *rif, bool enable)
 	struct mlxsw_sp *mlxsw_sp = rif->mlxsw_sp;
 	struct mlxsw_sp_rif_subport *rif_subport;
 	char ritr_pl[MLXSW_REG_RITR_LEN];
+	u16 efid;
 
 	rif_subport = mlxsw_sp_rif_subport_rif(rif);
 	mlxsw_reg_ritr_pack(ritr_pl, enable, MLXSW_REG_RITR_SP_IF,
 			    rif->rif_index, rif->vr_id, rif->dev->mtu);
 	mlxsw_reg_ritr_mac_pack(ritr_pl, rif->dev->dev_addr);
 	mlxsw_reg_ritr_if_mac_profile_id_set(ritr_pl, rif->mac_profile_id);
+	efid = mlxsw_sp->ubridge ? mlxsw_sp_fid_index(rif->fid) : 0;
 	mlxsw_reg_ritr_sp_if_pack(ritr_pl, rif_subport->lag,
 				  rif_subport->lag ? rif_subport->lag_id :
 						     rif_subport->system_port,
+				  efid,
 				  mlxsw_sp->ubridge ? 0 : rif_subport->vid);
 
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ritr), ritr_pl);
-- 
2.36.1

