Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E587D5573CB
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 09:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbiFWHUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 03:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbiFWHUF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 03:20:05 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2067.outbound.protection.outlook.com [40.107.96.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC6545AFD
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 00:20:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l+DQDRdlWvDKuePmIQOAyUYenOFOCnNAbKlmc11Jm8R05Uu0iN0qyq1Kb6pTZeGin6E8XdXClc2ABzomBmaP6JUrXL4vQh5WORdXFzM8Oib64+WopMAci8TJLMQsvvYY7x3ti/KzHlAeyRZKHifwd9gbKI3zxYTRml5+pVT/VbqOGEp1sdbmpi9d0wn7EvVP2G+XQqoQ9mZSnzAFdPNi4V2iWTBvdMPPxq0oCwf7+Ak+6oJBl+NaqAx1oBEI3omJkpY+xn1u87kEIzE/t4x21RSR7//x6bflddYS1w6MJN9M1N8RqMdWtaU8CBTjd2HJCHsLeQqoMGDc98rkWs7HFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dEF1NGyfkFmEYS1TR948i1BU3VKbhgk6Uwpzj9VmL/E=;
 b=kMhnelbWbdMt5Q17deBw3b+N7ihq7lSR7eXPpiPMH5gFtzss2v7bSRbeuuTBmPsDbG/CfbynPe0WsUGE+FNi27c+RXsYzlf22Q44EOZ/PN3jnrMeW7VqiTDsqvIarCg9g35sIZ3y6huMLDPpLk/Hk9PUYCvhCh2Fn/QzE1QbZUyZzTS4P8qfpY91I89kP5vwqRYYPZ2dVN1FNXodmTmBb6gs88KR+zWOt5vdetZDfxUxBz0y/DMlkfdcVop0UCyooYcxFHdMp6kQXr4CcHmLdgNhaYJWbemuU55RPxYlAK5cn9hOiszq4taZI4/smQPi+JHjDGb6ty0n7h/9fmFCgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dEF1NGyfkFmEYS1TR948i1BU3VKbhgk6Uwpzj9VmL/E=;
 b=cAlOsTJIt+cOsRz+GEfvaBzIQ/FL/JmIncXqh+KseIaRIBMhLgwL1zX/ckcxBEVNVpRwB7rq+wqjDLJJqz1bWlBf35Nefig9gRW2igflrWt/m9YyRQ3EZVx0khfftUMtqS0nm3vFhgYwY2uaXTXqXZ2bZ7jrr8kNzJzWqYJexDwktAe25Ms3zQxYEeL/4mF5MVQrqpFs2vBefni9KZ/Ahq49l0O5zB+pm1pEmKc3/uE8gpMj2zcq7gTiIg7vUiebittZmx/nAevxCQBf/Vc1uLZRHMWj+lSyx2mOoYITvSFeJH7Sb0LPXELv8ZzM3hAM4QWruI6Oy1lUgz6FiGKxFw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA1PR12MB6163.namprd12.prod.outlook.com (2603:10b6:208:3e9::22)
 by SA0PR12MB4414.namprd12.prod.outlook.com (2603:10b6:806:9a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Thu, 23 Jun
 2022 07:20:03 +0000
Received: from IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::6da4:ce53:39ae:8dbf]) by IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::6da4:ce53:39ae:8dbf%7]) with mapi id 15.20.5353.018; Thu, 23 Jun 2022
 07:20:03 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 8/8] mlxsw: spectrum: Change mlxsw_sp_rif_vlan_fid_op() to be dedicated for FID RIFs
Date:   Thu, 23 Jun 2022 10:17:37 +0300
Message-Id: <20220623071737.318238-9-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623071737.318238-1-idosch@nvidia.com>
References: <20220623071737.318238-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0701CA0058.eurprd07.prod.outlook.com
 (2603:10a6:800:5f::20) To IA1PR12MB6163.namprd12.prod.outlook.com
 (2603:10b6:208:3e9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 49b12690-3ca4-4c9f-ddc2-08da54e8ca68
X-MS-TrafficTypeDiagnostic: SA0PR12MB4414:EE_
X-Microsoft-Antispam-PRVS: <SA0PR12MB44145CD230A82F3C94B0F3D6B2B59@SA0PR12MB4414.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WSGsZB8zsF5mijnfLAc8c8LUrXKnrlPdttmeYEO6zwa5aPcKh5OIVcpwr5LROFqYfu71BqfDpMvcZIY5A51Ud8MMZPmf0/vy9eaZr4cNJXP+di7PQqDPUJSbjBHZDco2wxn3dYiycDSTM8G88VSbnJ1Rz4IrDluqJLc/k9u04madXCdSyy8IpnUDlKt1vqvohPBOUH5nSbKmIpeFvJBNkMOckXhnxrvv/Gs2O0OfuHOjiORLj8/R9AUWhbpIoBLxRUDN2k2Hujj/fGXDYNv+Fi8/xbN2su8RyCPRrg5dwLqQllyhpf6FrIGg4os6xOZ8a6HWQI+crN+SB7c8EoYRTVAAf4WPYz2+L1WEq6XvIsrL4qHN9mkRWUUrVV4e1e9eI0gZSIeFhXXn4rCl0HjHvIj/wJcMwsSAsNaMoCcbcXUBe5lXQiD06Lq5G/0jzTVnJZ2KSmT5KpeQ72PMRpxrDC5QYBB4ZA6CYGuIAagi/D14otsowStnIi5MNfFUv3IQWlppLM+Z6TrKRwo1O4Z3/Tug0rhiPSoGG1Zm7CPXBF0Nuz8704rH0WD/Kl1p1kh4kOH8kQHswzHQTNKiQoAI2fJ1GHFv5E11h38Xasw3HFTza/sT2WALis6Y2+A2hC7Sh/+Ax7pEpiK3dzwwdL0PP6xfKJrLffyOcKbvAmzaeNbr8mBtJ/1Zt7PiEHRrzuYUDhOkIIPv79XuL8LKMJjLbg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(376002)(366004)(136003)(39860400002)(66574015)(86362001)(83380400001)(2616005)(107886003)(8676002)(66556008)(4326008)(66476007)(66946007)(8936002)(1076003)(38100700002)(186003)(5660300002)(2906002)(26005)(6506007)(6512007)(316002)(6486002)(6916009)(478600001)(36756003)(6666004)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lBcPgctWk5ZNOM9BodJRZrtf0QGPX3NunLeSm7D6uuqDeMZSkFrE9Krjly/S?=
 =?us-ascii?Q?oqCjFnuykxicyAiDS6n63bmY0crCkXq18pl/y5LuTBVlljJuyy742j9mCY/H?=
 =?us-ascii?Q?ALJwTwzD+56o9lNI87urlo4goesTdVWydrtapVIIkU1d1Pv6iNhlGVpQvqR9?=
 =?us-ascii?Q?A0zVGLPEdQa2IcV1m1TGGhDRBbmT4gT3JLyk0Ef7orX9gSVYJ1LbPt+JAQfp?=
 =?us-ascii?Q?N4K4Tk8ui8V/V+3MHxmwZ4SlgYFebFEAjmsll9ZsqSnrlTuc2KCKEWvGmMlX?=
 =?us-ascii?Q?HWj5qSIPvz7BW/UMEgkIQg0pUxevZvCgWoAM6BJZqBoHdiXwXNJH1RLs2vQH?=
 =?us-ascii?Q?HJZTQwrJH3iLPVscO0HGiPoFBdQnbLsFb80U2Q+AJGpDFIQbeD/fAuAntnQr?=
 =?us-ascii?Q?1ArQHmBjjffU7ivNgHDx12YkD1VCtFiZDAWwosrI3/xMF1G4b0ARRaVpiaRV?=
 =?us-ascii?Q?P81jGbcnW+IfoFG0PrbjUtSuT7yX51cOICPuEYuoO+Vr3/BWEbW8V9Q1LFc9?=
 =?us-ascii?Q?gO6ZYtUXXZTzBSW1ixFwzotEj5MehVN15NBcYOZFQlp4h8tV/boig6K+SbUa?=
 =?us-ascii?Q?urJ3Im9cBlsgfb8NywWeQ+j23sknURAlE9vn08bYvRW654P39AAf2xV/8TIg?=
 =?us-ascii?Q?M9E4P4gwyKilSuUSmD26keKjVOEXOIkNdKUydtoIaGSr54495hwq44iGbyQ4?=
 =?us-ascii?Q?XF2vnOW8rhIw9n5PhsxnMv9D7ZyayzkGQ4q778A1fUi6GLJVFz7AN+p9TMkv?=
 =?us-ascii?Q?FALLfOEHFVdhcAeqW3b01Qi6/pxHa40nTwPhrTIULW7GQg6AUa2KR4eBE/5a?=
 =?us-ascii?Q?0hhaaVhA2GKctrATJ+Ydc0DaToZSbXNtcrtUPBPCoL/CfFG5GK3mkElpeXaT?=
 =?us-ascii?Q?zcnxoHk+MtnvD8mwya5W3NvlKEYCjQzRQdYrSlm2tmLkZE1MjL5sg8+VrdH7?=
 =?us-ascii?Q?YeKpLpL6VeVXSp6ge5Z3s9i43M4I+S2UWTdd3rL2JveP0uk5Dow9tE2tASVL?=
 =?us-ascii?Q?h6GzmwtfZ1XOfeSO4hommzlqO5WAR0K4TxbDjiNtfotgbBtht/9Sws5JKQ1G?=
 =?us-ascii?Q?Gw1mI+FoN4y1WaoTFYY7sSgit4aB/DiJv4wwXv2xGJojzyL2bUAeFRkHfYtu?=
 =?us-ascii?Q?G2QiEmhn5pEkqJ8vLTYcXfHJ/J2EON73ZTKeyXMiUwIVBtIMp/kwHsUnC/ke?=
 =?us-ascii?Q?8EH5QX/FvpZnptRTZ+X8f5gRYAY+KZKkn0tcQY9s0GgBQzBQDYlm0mrzKSQk?=
 =?us-ascii?Q?xvWZaT52rQiI4g0uh/SlNGPk7GkmJFptSNpBP6Y9oPi2vo0WmVNEX889ZJzi?=
 =?us-ascii?Q?E/3HkUIIt9VgcWsJ8f8+Q1xUFrCeIKI9uFElciLuzDCb067ZBLrBtp3E0TYj?=
 =?us-ascii?Q?14+4xgqz/jEAsD0Nmh9F+7ZwW91qlycA7tHgy21azhx3sItLB7R8jp45RuuW?=
 =?us-ascii?Q?4uXF4/muGTysOHF3DG6M6p0owI9s7RqCJRwGc9VRha7hUbguc9Z/0LQioX7Z?=
 =?us-ascii?Q?XRrOGNHYADmW7Wr4gzCltnaFCOmLnjaIQOrX76EGI9+8SYwhtMR0kgxleTMH?=
 =?us-ascii?Q?CVIEfsB1r/RbQG1FxNp3uLFl64bDKmD18ujKPfWDS5zHdCLUlzXvTlsJCvak?=
 =?us-ascii?Q?0aeBrkNIV7FetGC+qUNKhAL1HlJshSaRyLxRPi/u3UZTa5SvgtIVufLzM8fo?=
 =?us-ascii?Q?kCEl1LokKpeIb0MHTuKN/sZN0NBaFrNuty0Z8x+QdLKffxL9iNxVyzZ98Yww?=
 =?us-ascii?Q?UJ6rDRou9g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49b12690-3ca4-4c9f-ddc2-08da54e8ca68
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6163.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2022 07:20:03.3393
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OSDYyQpznNEszCDa1nNFxxtdWY7PtMTFXGWQuIEYqIRbQqMJG1m24VKJRZD/O8gHvKwPe5L0trEBHzczImEK5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4414
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

The function was designed to configure both VLAN and FID RIFs, but
currently the driver does not use VLAN RIFs. Instead, it emulates VLAN
RIFs using FID RIFs.

As part of the conversion to the unified bridge model, the driver will
need to use VLAN RIFs, but they will be configured differently from FID
RIFs.

As a preparation for this change, rename the function to reflect the
fact that it is specific to FID RIFs and do not pass the RIF type as an
argument.

This leaves mlxsw_reg_ritr_fid_set() unused, so remove it.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h      | 10 ----------
 .../ethernet/mellanox/mlxsw/spectrum_router.c  | 18 ++++++++----------
 2 files changed, 8 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index c9070e2a9dc4..7961f0c55fa6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -6937,16 +6937,6 @@ MLXSW_ITEM32(reg, ritr, vlan_if_efid, 0x0C, 0, 16);
  */
 MLXSW_ITEM32(reg, ritr, fid_if_fid, 0x08, 0, 16);
 
-static inline void mlxsw_reg_ritr_fid_set(char *payload,
-					  enum mlxsw_reg_ritr_if_type rif_type,
-					  u16 fid)
-{
-	if (rif_type == MLXSW_REG_RITR_FID_IF)
-		mlxsw_reg_ritr_fid_if_fid_set(payload, fid);
-	else
-		mlxsw_reg_ritr_vlan_if_vlan_id_set(payload, fid);
-}
-
 /* Sub-port Interface */
 
 /* reg_ritr_sp_if_lag
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index c6d39c553d64..63652460c40d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -9389,10 +9389,9 @@ static const struct mlxsw_sp_rif_ops mlxsw_sp_rif_subport_ops = {
 	.fid_get		= mlxsw_sp_rif_subport_fid_get,
 };
 
-static int mlxsw_sp_rif_vlan_fid_op(struct mlxsw_sp_rif *rif,
-				    enum mlxsw_reg_ritr_if_type type,
-				    u16 vid_fid, bool enable)
+static int mlxsw_sp_rif_fid_op(struct mlxsw_sp_rif *rif, u16 fid, bool enable)
 {
+	enum mlxsw_reg_ritr_if_type type = MLXSW_REG_RITR_FID_IF;
 	struct mlxsw_sp *mlxsw_sp = rif->mlxsw_sp;
 	char ritr_pl[MLXSW_REG_RITR_LEN];
 
@@ -9400,7 +9399,7 @@ static int mlxsw_sp_rif_vlan_fid_op(struct mlxsw_sp_rif *rif,
 			    rif->dev->mtu);
 	mlxsw_reg_ritr_mac_pack(ritr_pl, rif->dev->dev_addr);
 	mlxsw_reg_ritr_if_mac_profile_id_set(ritr_pl, rif->mac_profile_id);
-	mlxsw_reg_ritr_fid_set(ritr_pl, type, vid_fid);
+	mlxsw_reg_ritr_fid_if_fid_set(ritr_pl, fid);
 
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ritr), ritr_pl);
 }
@@ -9424,10 +9423,9 @@ static int mlxsw_sp_rif_fid_configure(struct mlxsw_sp_rif *rif,
 		return err;
 	rif->mac_profile_id = mac_profile;
 
-	err = mlxsw_sp_rif_vlan_fid_op(rif, MLXSW_REG_RITR_FID_IF, fid_index,
-				       true);
+	err = mlxsw_sp_rif_fid_op(rif, fid_index, true);
 	if (err)
-		goto err_rif_vlan_fid_op;
+		goto err_rif_fid_op;
 
 	err = mlxsw_sp_fid_flood_set(rif->fid, MLXSW_SP_FLOOD_TYPE_MC,
 				     mlxsw_sp_router_port(mlxsw_sp), true);
@@ -9454,8 +9452,8 @@ static int mlxsw_sp_rif_fid_configure(struct mlxsw_sp_rif *rif,
 	mlxsw_sp_fid_flood_set(rif->fid, MLXSW_SP_FLOOD_TYPE_MC,
 			       mlxsw_sp_router_port(mlxsw_sp), false);
 err_fid_mc_flood_set:
-	mlxsw_sp_rif_vlan_fid_op(rif, MLXSW_REG_RITR_FID_IF, fid_index, false);
-err_rif_vlan_fid_op:
+	mlxsw_sp_rif_fid_op(rif, fid_index, false);
+err_rif_fid_op:
 	mlxsw_sp_rif_mac_profile_put(mlxsw_sp, mac_profile);
 	return err;
 }
@@ -9474,7 +9472,7 @@ static void mlxsw_sp_rif_fid_deconfigure(struct mlxsw_sp_rif *rif)
 			       mlxsw_sp_router_port(mlxsw_sp), false);
 	mlxsw_sp_fid_flood_set(rif->fid, MLXSW_SP_FLOOD_TYPE_MC,
 			       mlxsw_sp_router_port(mlxsw_sp), false);
-	mlxsw_sp_rif_vlan_fid_op(rif, MLXSW_REG_RITR_FID_IF, fid_index, false);
+	mlxsw_sp_rif_fid_op(rif, fid_index, false);
 	mlxsw_sp_rif_mac_profile_put(rif->mlxsw_sp, rif->mac_profile_id);
 }
 
-- 
2.36.1

