Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6661F5614F7
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 10:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233271AbiF3IYr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 04:24:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233599AbiF3IYM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 04:24:12 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2052.outbound.protection.outlook.com [40.107.237.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A206416594
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 01:23:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PLrPxuRFQv4kY6mWlnzxx03OXVhU2n+mhVifJ6JfV12DP8e3V6uOIa6sZrHoapbu+9R9+XV3Sn6s+Rs/djjQaR8AoSpFolah6qQE7A7PTgYGnzymqiPkYoAo4UVr3KNRymZoOfF3P7KfP4GwnBedeyphtSQ5PUBP0akbZkREDuNbtPaRwPs1rnujqiGL++rdKWOivNMPFdJxgdNWuyo9Z8p3q6ftq7oNsi6nKW1FQCZJx2WcSeL2Tyw9R0S9kkxMFBr9CGF9IVAg3GMA6sgC8u+IBWgbxQDsDy0g+21pqkt0Z4xI09HXomZ5OOv3qeS6bSfT4xhqexsQsaGNFGSOYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cFg0tp+nt3EpWJFxyzPa9qs4SQq6bJ5ikQ+nhANplF0=;
 b=LjIU82ayIkQjL1T4huYDMvnb4tnB0T9/tPQzqVjlS+8VKtLE0MQC5AhNecje7s/jg3Dr69qfOJ7GcrLzHD1AnG5yCtqZNBnFYTebBWzfXOqCc92gG4LUAiQL887rNT1MNlxbI1SaafOnSgD+HwE6qkbJ8hOnD5blbFTe2weAk6gT3KMACC/lXbqxKGrIuf6obErbtp3s+bcQW5TKqX8VYI+lgXSMFbJEiez/FHHOwcQrsGJYFHCh+cqpzEMBsxsgXa3Y4cW1YraNBXCF6yN5VI9vCy3SibPB3DGYAQ7XZxSJhFPnokHVEVx9TDWr7UPsoCm7kzZgCNt5MP25aer8Dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cFg0tp+nt3EpWJFxyzPa9qs4SQq6bJ5ikQ+nhANplF0=;
 b=VrHUdwiM3t6dOjrSOibcfEAs1eSaoTNw9REM9Y7wQ9VXUIOA9WwsovjUHvB4d/7e4UaaQqECwSDfMwObGaEmYAP0v8x9GtTqu6uyeAQntVZF2dFpjf4nVUoyv3wtIbMycmNWrCqR5zlLBmUQE1g19mXnnFe4vpqpYuUdg2NF+1AekhxmS8YNEUqYdNi/C3ODtPyXfF2ke7hsF8BkchxEaxg/x8uZgj4tJEFBpGKWf6KEHAyWSR97t0lan6I6kmwoCKczy+iU2yJP39wfbMOf4nYjV7+dazW3Y/47ebvUA+R61qfvxMTCLQE1ajBHEGzWH+XsFTgSqya7ZYQpN69QlQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MN2PR12MB2880.namprd12.prod.outlook.com (2603:10b6:208:106::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Thu, 30 Jun
 2022 08:23:55 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%5]) with mapi id 15.20.5395.014; Thu, 30 Jun 2022
 08:23:54 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 06/13] mlxsw: Configure egress FID classification after routing
Date:   Thu, 30 Jun 2022 11:22:50 +0300
Message-Id: <20220630082257.903759-7-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220630082257.903759-1-idosch@nvidia.com>
References: <20220630082257.903759-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P190CA0019.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:2b::32) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ca591663-b06e-4532-9488-08da5a71df26
X-MS-TrafficTypeDiagnostic: MN2PR12MB2880:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZEZpcae2w5JtG3lnUD8WUD2N9+hoZbgEEmgPwbgujrRwUNKuXmgAEjK81LOjCZKx3v11AldqCbGmOU9W/6OrQTT4jx1/8+wnMqsy+nRSQnDh0jKTtmYkktU/lHEk5srzn54SgPf4wLAoHUPGbcP0BMoavj5zUSs/yWgff8SyNgmIu5Kt5kJbMsNjLwNxQQnoRVi3Lz0TiQnzts9rL6sqeOyz1o9WOdmKNNQreVNNyT6fae1qemL53kiZebhwkCX9nTXz4LHJNiB37D45hSrmvCeT5iYjhjRzRTzY9gc1TFJMwri7HlToBMqV3V2HX0h+w7QGUhzFMKG5KvvvQ2qI8XxClSXY4BgcJ2Ele6c1pWFhhf4u6Tzs3GmMa5nLFCykuoB6xxtnO4bp4lQ3On7ISr/EcN3wORPn4QJdNjyhfiJF67OFVkLXChRuAxTYL/PqM6B47MKagKIp6spbI/CAercWNYPv8vqtSB6cx70nE7TEWVSIS3CKqE3ZNQYuSSgr7pdQtOqkHvem11HPl079BxPCL6pBlpSUEVMesaR5Qn+u6IKBlTiT12sFzhXfm8f8XH8YZuZ6azsKeS7bm1F3iLZ8uk/FbcG0ArlRaruFC0hEZLGtkuTs5N1p+znwF4OXOTgwnqS4cjMhX8W10kuRH8TXCGHbW3yKMl9Xxv0vypWMj75P5VeMCFuQhrUGXt+0HJrAYQAH4Winun/X3+7vUETRGrIgz8lce19+w2QlMsRQh3P4hnQ7nDE106IXkWpL7azsbEXtVPQ4kp2jey7XHA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(376002)(366004)(39860400002)(136003)(86362001)(6486002)(1076003)(36756003)(8676002)(66556008)(66946007)(478600001)(4326008)(66476007)(8936002)(6916009)(186003)(316002)(5660300002)(6666004)(38100700002)(6506007)(2906002)(6512007)(2616005)(83380400001)(26005)(41300700001)(107886003)(66574015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gbANDTFE4LGk9QBu4Y3r9C9PRwndtK+2pxztQKm0eCUI5b50nV40DpmwTB9Z?=
 =?us-ascii?Q?8bZo+2V9zS2Bb+e0rzFOK1CJKS/G1Uwao1Keg58L+en0PpYMl/FGnhujEPUN?=
 =?us-ascii?Q?KNLuNQGdkb6X19H5+sHkQI3eIwxxofUYVXuEGERz/nDb2+g4qRVVXti5pGcE?=
 =?us-ascii?Q?Fqc5MOUZFa0i0FgVG7fcIiaAg8rh7hh+4HXtPj+b3vRBCIeOgYdKw7ru5kM7?=
 =?us-ascii?Q?2N5JUSjb/fSiHLJAHOO3GdVMVCjSW0UxFs73PCJO7jprugRmrezg5oxaVqq0?=
 =?us-ascii?Q?fIPz/JHrCE51bzHSE8hAwSsX2DKT8Pc5SWoTWg4taFWVTNjLz6F0gSg8uJY7?=
 =?us-ascii?Q?9X41wWTBF3P8sHSLtcFZX9KjLsXclNU7UoJs/pElzl61Xo0qH+bumR2JCNue?=
 =?us-ascii?Q?PljFnO7ysYs+kMsHsLHppz/V4projj7Q1lAXvkfyQ8NMQqC6qRScio49Xa8Y?=
 =?us-ascii?Q?ruOQF369JHr58NzZ9SmEggmmdLmpu9Fth7LyggfnaYjy+tFX2dHy6pKwyMf3?=
 =?us-ascii?Q?sZapArYaEATsi+wFisAOE2OUl5d8ifGFhVr24YlwbCxQBVBQUFXbGO6gaXWF?=
 =?us-ascii?Q?xt4vBnl60rAD8lovKJYQJH6pWvY6fEkT46CI5SuGT/tbstPzPgkjVvQiR7Mm?=
 =?us-ascii?Q?Y0hqijckfBOYNRmeBg9Ihd9YLnyLOuvOkSCcluxRy4I6mg/05mpQnNQhma6/?=
 =?us-ascii?Q?SPdPQH/F3DZIvkJ/0ZcYFwYg0Xdwnn5bE85v5Oe1gi5LXSC83pYRfB/pC0u4?=
 =?us-ascii?Q?x0CMUrbo5PmL1JtganqAmBzBq5hHxPeZEY1dr9QU5UFJLFWriBUzXABYSGzu?=
 =?us-ascii?Q?5aQE9imKyWmB68OWmsQBOWNKYTnNb09FjwStAJq0wanj03mg4JduLqiS0qEo?=
 =?us-ascii?Q?DZ1TCAQVpvNu1FCM0UTeO+QS8NLuq0Bzo2GRL6Zr+uANUgzURvYWXNUVgNPJ?=
 =?us-ascii?Q?04ljYK4UAequwt/sjT+kg4R6av19sDNTgglWMoaVf6F+mx/CUxnUBg7QHcDr?=
 =?us-ascii?Q?mNQfDkRoQGE7uZfxMhACgF5zH/E9/VMCUioaLYPESxGWyDltAFdRjgGuBalm?=
 =?us-ascii?Q?FonI55IB2rc8RhQ8oLVEYfaqu1bejM5QXuJaTxHH57VPbOlhg5GeIPL/g4rq?=
 =?us-ascii?Q?O8LIFD6R0wnyL6PY4X0g1J9Bb/uBugptDSWSE5WOrWPFD6Zg/R13Q9PWDiw4?=
 =?us-ascii?Q?qzzahhf0xhnITEgirtxBOKP41I8JBlJ/tFy2A495Hvp4JVtVj6ZOUrvteHxu?=
 =?us-ascii?Q?tm6dNONARdIXnIQx4t2Oyb6L3P5imYEUYGlWD7CIzOB5UF26CtLYlPd/xTMu?=
 =?us-ascii?Q?kVygsxs97jq6Nw/3uGFfXdqnFw6RP68SjSlOTzHqZ4V/0p/N0l2DqEFHwbHT?=
 =?us-ascii?Q?TYd3sdTAP9eu7Mu5K8NTKI4OtrHYGuZCXVwFQA856PNUBP2+Ypxf+uToAj4P?=
 =?us-ascii?Q?fMz3yaUu5n0HkYaqi/Ms1BfJUQn8kj2kI9L63V65YBmf3VOjm/qJ47aFUDiw?=
 =?us-ascii?Q?RuYXFqIF1Lk3yiIPYi577nU+gb95W2KN8HU3qAWrlgthsBhMzp2XbhgMIhDq?=
 =?us-ascii?Q?D/OC/K2qcefPMieFWkOmgaC7Zb1vW0DqXnxotHuM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca591663-b06e-4532-9488-08da5a71df26
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 08:23:54.8935
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CoNA3B1F+YWloz7kLLQX5B2JB/MZK8/JnpO483o8tIVQB5LIlvfCP/WvZBF9iAjnWniThKfxu+4BSkErtP8ODQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB2880
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

