Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1739560C972
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 12:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232246AbiJYKId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 06:08:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232199AbiJYKHx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 06:07:53 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2070.outbound.protection.outlook.com [40.107.244.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07A8822B24
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 03:01:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O0BEV1MbJHYasOSmEk4OAW0ngMtIk+3LjkXzMCL6HelvE1PNFwLXVHI+yyC1PdLDqFT72ztj4ioYZa3TMVOejgbtfAi9y4TlOiXlTg3lXZEx+IUjkZbnC8Xx5Ea5MOB83dEWCO269/hOhsMUN+3HoVWLIAim4kC+jdMfSbRkR5os5yG9HXI2rpruInrBvh5JIUDvbZsbWw+eL6r+N5PHTc9sbWV2aXER0tmLU5q9UXAvun32hY7EWpQBP4qV0+X7NNafiUEIoruZyoavXY2Td6+AKYi16GTp8n14QasIZSa1IWNs5o3mf+3/BbX7ED7xN5YviEzlAoVAvyokdg7qRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bs5WF0VsyanM73k9HlbZ0mo3jYQFRi6r1iCry6cLibU=;
 b=ckqclc2PQnmIjIV8s4V2szAVLPGk785S5ablKzB6gXMX3ERY+cvO/VIxIiCjppWuMpEflBQ+vABQgiZ+LjLbSMjZEM1bnfWgEUNtgqokx2VI4ZywHuzn0t43ERJUYeOggJSAuN2Nlk0wHi067Y71xdZzEvLtiWyjOE7fXdVaF2t3/e/N262DLtmR1HTVbcpdXgnQC4//gUctYYQS1riaybv3sgpdUrsVLr25GOt+xVp8jnfCS2Rpe92UBXX3hoFIGeQJIk3jw8MYg6sMa70AIQ9WVvvYeSHoNemtXRf1mrty2S9c0vUYzS9vqefB7OgDz+W6vyNakb9uHmkydro+rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bs5WF0VsyanM73k9HlbZ0mo3jYQFRi6r1iCry6cLibU=;
 b=HQL6vxejYTe5k1f3kqLaGatpihx3j+uRbdirSBhF/Za3LKEANqgDJEGNc5hy1cmuIgoYjMjiNMHxTuG69tC4oZ6rauXnVuVBNBG0KirLZ42tJEAo+iIUBqgMdQ33Y6aK42iTZa1rJtF/rkVt7k49zOcO3xKmmZlkQ3gw03IzEo5gsTLvyGCb/EkN1wbWP2HU0tInp2NZZLpDTklerHiNOCyH/S4ygtdfj6AjbNHsCkGXC/b9fnubB6seBacHE3DcUbxGEqgF4czafDTugcJ/jzb6BfFQe48gP/hdEgxWqvZLDn/rK+FlUrCoO2tdN/QISJPqt0VCoGavhOhQwZ902Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MN2PR12MB4270.namprd12.prod.outlook.com (2603:10b6:208:1d9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Tue, 25 Oct
 2022 10:01:29 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e%7]) with mapi id 15.20.5746.028; Tue, 25 Oct 2022
 10:01:29 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, jiri@nvidia.com, petrm@nvidia.com,
        ivecera@redhat.com, roopa@nvidia.com, razor@blackwall.org,
        netdev@kapio-technology.com, vladimir.oltean@nxp.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 06/16] mlxsw: spectrum_trap: Register 802.1X packet traps with devlink
Date:   Tue, 25 Oct 2022 13:00:14 +0300
Message-Id: <20221025100024.1287157-7-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221025100024.1287157-1-idosch@nvidia.com>
References: <20221025100024.1287157-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0401CA0001.eurprd04.prod.outlook.com
 (2603:10a6:800:4a::11) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|MN2PR12MB4270:EE_
X-MS-Office365-Filtering-Correlation-Id: cb1cb48d-4008-4b0c-48d6-08dab66fe2df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lNi1tuv0fJuruqaRjctZHH79mhGHSBGssJOYZEEoVeo+dJyfP0NhQnhtqtYpk2RZENZUiJxVxySAgO6sqFmNKMXJdXAfPA12bv/jC2U2Pkdt+Z/wFKBWu3l4vcc5LuZnqPoUHT04h/zNZv35zKg5s8gtSDwu9ytScOEiORU9dx6s7YbfZQ9ZgBiLJa80j2ib/zLRBoLeijnQhfqysGvCEYVdCQYosMZJmtYkpe+Bwy0VK7hTLPKRPmmgv08TsOw/pRaMEx9L27j9h8xVp5Z9Ow3ADGopPMCX4Lhd/Ib43BjwEFwzOmvRDobD+o05TSdVPcUOImOf9ffFKZcnwrMhdT1/NEYHsxy95Rxw0yvSSxT0X3O5wMfBBe1R7Vtn2T/nRlUQ9Ew40LVv4hqvZciYuzE4z+6DHn93Ym7xr29WvrkQ1cPzVVfAUtNNRis6jJxnwbHjnz0LraVWPww65o00LK1l3mdJQZFllzqnZB6oBhkGKnr4kJz+0Xs0JKfsu2jURW2ao7JzMZMJKitEP2+SUxyHZ9Y1F7fccJ94Ej9e01SuFaM8m/mHV8HXursMQ52dQOI71jaRERHP0Vnw8izFBpAOV93ICScXSb1COMyeP2hj/NI8XAv6JkeD7O/+QqyUZ8WrXN3jZ1f3CbKyNKRd7ltDejP63IaSALJO0uSkhQsvh47GRc7Fbknz4ziCRnG/QnsttFCC2QQDw+h62cM5Rg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(366004)(136003)(39860400002)(376002)(451199015)(36756003)(5660300002)(66476007)(66556008)(66946007)(7416002)(38100700002)(8936002)(83380400001)(86362001)(316002)(186003)(2616005)(1076003)(26005)(6512007)(6486002)(478600001)(2906002)(8676002)(41300700001)(4326008)(6506007)(6666004)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wGZLvkR9JenpmX5sTANnlzOg5jvVHCPSwzyfzRG1llDvDx4eiwDo73BEz3A0?=
 =?us-ascii?Q?uzboYTo7yMASAT7UZPIeCujLEqGF5aWqLvIetoZAX0ENT3KPzHFcMIQlzmkG?=
 =?us-ascii?Q?Up0PXasiHZ/OA6pk+IwriXc5XlgcrBHIlHx58IgFHp3FkcNI/lrbWELVJGIw?=
 =?us-ascii?Q?MutGU7d2+2z7TgCb3/Zu2U3mJp1cAPfXTMqbc4xHxGOaqduP1xTIRWwN1W2/?=
 =?us-ascii?Q?LsAVgU7LBySJBlTQhDK99ED5XRr5pqDSDZUSZtKiEqzp1BtZ98uu4U+h3a/A?=
 =?us-ascii?Q?HRutV3LLpOdohgQyeEp1TrnvMm8MiwjOqR8rvZflI8xGvoq4RFE7JKuQKffc?=
 =?us-ascii?Q?axbEgkYUm/QqCW5Q4VBXL76vJ+xLuqT9B7MEdtQFSEwri4lyuU5tMpicMcd3?=
 =?us-ascii?Q?W0Q4Hl9a34xoLCqAmHgW8ZlybbVzoOk/RwoQhGxJimhE+t4LLHuzZsp1j+dF?=
 =?us-ascii?Q?1rJCUrrJDRbDJ07YySRYxFu0REUfVQK2q1IL2mZlZv/y0vG/6d4V7mOYMCW5?=
 =?us-ascii?Q?ywQcT3XJ0+ilId+iGw0q0HX0xIyDWC2HD6iZlpkr2IK9WM5VSGWLj2Ab0DUb?=
 =?us-ascii?Q?bblJZSV7mEVn9JaMapuWWt8C+jka5IqLPWIGsY2Z3nZ4ITjOHvtvsVT5Tkie?=
 =?us-ascii?Q?Tuu36BIKqxcR3vPPrxzMW/EdQcDYXEb6edaclb4EGGx/07Mhem68AzkAmU44?=
 =?us-ascii?Q?PWeL81wFpYClL6ZasRMnMzimJf+h6cGpOhdeMmYI8K3anuM4aUN4qAC1IJ2i?=
 =?us-ascii?Q?9v5G7X4NgMnvlML4ICIMws9gdnB8oq5yUZHk9EpsGbaAFrEiBnosavFpUuE1?=
 =?us-ascii?Q?lZHqUJIG8tGYn7oxc8X41Mya5mdSG2dT1POVFnWnq6JCjPdJJS+ePVBYIIMV?=
 =?us-ascii?Q?55cU+fiCjg/Mm8hSiJg3Y36uA3yxveIqmvGpAATMSgwry8YNfxYb7RkcXZ8/?=
 =?us-ascii?Q?8txL/oiVifnY70Y8UGb15N1mYbW2VSeOHxT4jeTgJNIQTHI8B6KMyvOspU5f?=
 =?us-ascii?Q?xfyYX8ZXESWjZ7TOlA6OZOxUhqoS37CVQbKkwLjaSG/nyoNNHe4dcrseVoqI?=
 =?us-ascii?Q?2jqE+aqwo1za+uPNFPQt/5VWe0X3jWc+SZZ+XVA0GmbJDhC8S00aDkEPVSf/?=
 =?us-ascii?Q?WwFR00vfbt8LnJRVomvgYrGNsR/gBS2WyaOeA6fa3UEZ1c5YxbcvawDuHL3k?=
 =?us-ascii?Q?fgfHuCm1lA46UuMu8FpqLh0JKBe/8bITLMHRDmggTKrubL6zNe2Mt+B890YP?=
 =?us-ascii?Q?qQqBDaE+zZu2c6AaDRpe+qrgqlfUApjwsyT55M/83gJ0tAZkGZMkYzHGdL6P?=
 =?us-ascii?Q?m1lEnL7LuHn+CZsVeGQwFHCP2IYAavwBy1fRBj/TJ2hyP7y7kAd1mXTqzySD?=
 =?us-ascii?Q?eSglzRFSLxVMerheMuDkusCUdRbCMIc3emtUJLEourVGKLNUb2Okcfysy2RN?=
 =?us-ascii?Q?z7ZCJLuVTzalpuDaxo9YvlvAD7TkDSGjhuNBOm+2lNIBvNl4eWrZ1aS5wmtj?=
 =?us-ascii?Q?fvtbjOARM5KM+cj16tTFN80vGmvT4JzXAUNUPQGXWPZigxyRNJcU1pkhU7xy?=
 =?us-ascii?Q?DYL5yFuHXvQ9s3TJaF34cqLw6sK4RMmYSo71U7nR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb1cb48d-4008-4b0c-48d6-08dab66fe2df
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2022 10:01:29.2130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wyanFNhLP5QDoba0SGFbCC0LDRl2uvcT8DP0g+vLrSZzmakOKA+4CNZujgDpdYG4MK+7+jaw01TWUowBAtPdgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4270
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Register the previously added packet traps with devlink. This allows
user space to tune their policers and in the case of the locked port
trap, user space can set its action to "trap" in order to gain
visibility into packets that were discarded by the device due to the
locked port check failure.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  1 +
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   | 25 +++++++++++++++++++
 drivers/net/ethernet/mellanox/mlxsw/trap.h    |  2 ++
 3 files changed, 28 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index b74f30ec629a..7240af45ade5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -6316,6 +6316,7 @@ enum mlxsw_reg_htgt_trap_group {
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_TUNNEL_DISCARDS,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_ACL_DISCARDS,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_BUFFER_DISCARDS,
+	MLXSW_REG_HTGT_TRAP_GROUP_SP_EAPOL,
 
 	__MLXSW_REG_HTGT_TRAP_GROUP_MAX,
 	MLXSW_REG_HTGT_TRAP_GROUP_MAX = __MLXSW_REG_HTGT_TRAP_GROUP_MAX - 1
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index f4bfdb6dab9c..899c954e0e5f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -510,6 +510,9 @@ mlxsw_sp_trap_policer_items_arr[] = {
 	{
 		.policer = MLXSW_SP_TRAP_POLICER(20, 10240, 4096),
 	},
+	{
+		.policer = MLXSW_SP_TRAP_POLICER(21, 128, 128),
+	},
 };
 
 static const struct mlxsw_sp_trap_group_item mlxsw_sp_trap_group_items_arr[] = {
@@ -628,6 +631,11 @@ static const struct mlxsw_sp_trap_group_item mlxsw_sp_trap_group_items_arr[] = {
 		.hw_group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_FLOW_LOGGING,
 		.priority = 4,
 	},
+	{
+		.group = DEVLINK_TRAP_GROUP_GENERIC(EAPOL, 21),
+		.hw_group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_EAPOL,
+		.priority = 5,
+	},
 };
 
 static const struct mlxsw_sp_trap_item mlxsw_sp_trap_items_arr[] = {
@@ -1160,6 +1168,23 @@ static const struct mlxsw_sp_trap_item mlxsw_sp_trap_items_arr[] = {
 			MLXSW_SP_RXL_DISCARD(ROUTER3, L3_DISCARDS),
 		},
 	},
+	{
+		.trap = MLXSW_SP_TRAP_CONTROL(EAPOL, EAPOL, TRAP),
+		.listeners_arr = {
+			MLXSW_SP_RXL_NO_MARK(EAPOL, EAPOL, TRAP_TO_CPU, true),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_DROP(LOCKED_PORT, L2_DROPS),
+		.listeners_arr = {
+			MLXSW_RXL_DIS(mlxsw_sp_rx_drop_listener, FDB_MISS,
+				      TRAP_EXCEPTION_TO_CPU, false,
+				      SP_L2_DISCARDS, DISCARD, SP_L2_DISCARDS),
+			MLXSW_RXL_DIS(mlxsw_sp_rx_drop_listener, FDB_MISMATCH,
+				      TRAP_EXCEPTION_TO_CPU, false,
+				      SP_L2_DISCARDS, DISCARD, SP_L2_DISCARDS),
+		},
+	},
 };
 
 static struct mlxsw_sp_trap_policer_item *
diff --git a/drivers/net/ethernet/mellanox/mlxsw/trap.h b/drivers/net/ethernet/mellanox/mlxsw/trap.h
index 8da169663bda..83477c8e6971 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/trap.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/trap.h
@@ -25,6 +25,8 @@ enum {
 	MLXSW_TRAP_ID_IGMP_V2_LEAVE = 0x33,
 	MLXSW_TRAP_ID_IGMP_V3_REPORT = 0x34,
 	MLXSW_TRAP_ID_PKT_SAMPLE = 0x38,
+	MLXSW_TRAP_ID_FDB_MISS = 0x3A,
+	MLXSW_TRAP_ID_FDB_MISMATCH = 0x3B,
 	MLXSW_TRAP_ID_FID_MISS = 0x3D,
 	MLXSW_TRAP_ID_DECAP_ECN0 = 0x40,
 	MLXSW_TRAP_ID_MTUERROR = 0x52,
-- 
2.37.3

