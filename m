Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCD045FD6F2
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 11:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiJMJXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 05:23:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbiJMJXe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 05:23:34 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2054.outbound.protection.outlook.com [40.107.92.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F337CFA000
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 02:23:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lEzJ1H/nrxSdMD22AQ3MKOCV4l3OlxfnyUkpWLiLUHdUlXGFeeQHiFBf1RY/hAWuecOusN/URXS7E9S8EccVyEl/HOCAuulnv6+HWmKHBu93mHul4LXxjpD8hnKfOuos76g89bUTn2nrHtFz1B4MJFyj0uf/w/b8lOvRuH5RPfuysS0Fnp0o1NVPc85E9qVG+XPaPXqj3PHqfYCde184Lk3+SViEyJoCexygB29uFLauv70/4XbeX771sI0L5rx8nrJb1eNeZYX263VdO8HywgvtK6IXxCT78dPCYdBjJuhtRdTHjODWjSaIDTQCo0JWSCmK3pQM7fMMqZfTWR4mbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KzrYube0RKL32HMfYnsHerQ8HH37t16kSQHaSnXZxpA=;
 b=VYlf2bJ+scZpJXGZ3yVBzrtnOgIfS4rSBeG07lT3manQt2dHjd+VEdKW8A5V0lOxgdUlgDuDvJgrOVVPhUGNrRmD73hTz6K09o0QglmPe6rWQXy/6DB1PPCmRetXAU5u1M2XMr19Fyeu0+GJQTjb0sPysQoh+ZwmZE5Xm2IyLabRAqQwYISGMqG1t73sMzfp8V1K6DbMy6eM4LhYrnp8S93MRq0Kbffgwg1n4l+2jarmaGwv8EMaYk2teqpvy1t5NtlJmf+4wBzavMgAWfieOulpOq/jl2QIFnZ5iD1D+fPxoFDxLPLBsGE5lGZ8EBsrjN0zEaizZHhymfHeCXtEIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KzrYube0RKL32HMfYnsHerQ8HH37t16kSQHaSnXZxpA=;
 b=5MDREqgxYGW8gi28pSJS1TrwPY9JU7eKpufs5/XeIzUbxXSrT9bkdPGGEGMA7Oj+pDs4lGBsM1wCTNGrPUyW/1gfCoyuX0pA6kIsAQmZ+ATFxqgXxa1OU9MzMTrV3IyNnX3PjsSJG4lK/06v/3lvcsvwM1Ei7usYOPS5wPU+6J0=
Received: from DM6PR13CA0019.namprd13.prod.outlook.com (2603:10b6:5:bc::32) by
 IA1PR12MB6139.namprd12.prod.outlook.com (2603:10b6:208:3e9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.34; Thu, 13 Oct
 2022 09:23:30 +0000
Received: from DM6NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:bc:cafe::d1) by DM6PR13CA0019.outlook.office365.com
 (2603:10b6:5:bc::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.6 via Frontend
 Transport; Thu, 13 Oct 2022 09:23:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT009.mail.protection.outlook.com (10.13.173.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5723.20 via Frontend Transport; Thu, 13 Oct 2022 09:23:30 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 13 Oct
 2022 04:23:29 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Thu, 13 Oct 2022 04:23:27 -0500
From:   <edward.cree@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        <johannes@sipsolutions.net>, <marcelo.leitner@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: [RFC PATCH v2 net-next 3/3] sfc: remove 'log-tc-errors' ethtool private flag
Date:   Thu, 13 Oct 2022 10:23:02 +0100
Message-ID: <313f5241e0cf124edb5b14fbca057060f1e6d90d.1665567166.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1665567166.git.ecree.xilinx@gmail.com>
References: <cover.1665567166.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT009:EE_|IA1PR12MB6139:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d0527dc-aaaf-477c-2ac8-08daacfc97ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PMrqkuRbJlFIArZAwEaugnFXZFw0gzsEJPJ/BEs1ugxG3s1CTGecUD0fNvPjTroTvzDpWTqwScs84o3JAwqT0QMgPSCbIlBIuQ28czlRVOzW5gKd6KlM6jgXknw66KeHAerphTdgmcAsYwOHAayvHcvHaQbxW6eq5FQhnCQYoORKXKnj61Jt56blVfm3qCWGiNulVd7/KjmDirfqsFnMz4cZ3sTy3AjWdmM8WMWyNzFMASZ+Qwj8tpqYL0bccEVHiypKVR7CiLxO75lPi8Zgfikif3N6/pR3u6e3tFAoTN9ZsaobKdA6Eci1sWijaiP6mRi8AbNtUg2m41S5BaVmrFAgHSQ2a3sbFpGbU/n6+R+nlJxAnMWXlBcYkJ7ZJKRtn9h5LSjD+uR3FDt1YgrIEbDGmIdayvj+9yp2SxwT/6051FeJyE/j0YTWH/jq+MqxkTQulgAFgAgqJ5ADgCdlfn24+HY/5HvwoJ70YcMkivt2YiV0tqFJ0qFuzWUBU24TjEfHFTb6q/5Ii/cQdB3rUSb8uiN2n/+zpuAGGF24LJAqAxJi73CTZ6MomZebNYbQ6iGbDKVRz1sO5uPK9zDOLmwtA+vI/8ZQahs7wYqa/0Sf+WTLGVV+c830pQUcVy00k/CeHG98UAXarfuqIRbWUnKv64HraRfEYmJmpB3kzO/vM02qlYSPJx19GpLlI1A6eJGYRU6lIpjPOPLdAHQPif8K6NWFymSQxOAe12oAk8L4KZ0Gu8eHIDyekGPesByom36oh5ra3KWwM43B8BitjGPSd8r/7GMx9X5JckxoWmo=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(39860400002)(376002)(346002)(451199015)(46966006)(36840700001)(40470700004)(47076005)(83380400001)(36756003)(55446002)(426003)(70586007)(36860700001)(82310400005)(186003)(336012)(81166007)(86362001)(40480700001)(26005)(9686003)(6666004)(478600001)(8676002)(8936002)(41300700001)(82740400003)(316002)(356005)(2876002)(110136005)(5660300002)(54906003)(70206006)(2906002)(4326008)(40460700003)(6636002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2022 09:23:30.1878
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d0527dc-aaaf-477c-2ac8-08daacfc97ab
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6139
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

It no longer does anything now that we're using formatted extacks instead.
So we can remove the driver's whole get/set priv_flags implementation.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/ef100_ethtool.c  |  2 --
 drivers/net/ethernet/sfc/ethtool_common.c | 37 -----------------------
 drivers/net/ethernet/sfc/ethtool_common.h |  2 --
 drivers/net/ethernet/sfc/net_driver.h     |  2 --
 4 files changed, 43 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100_ethtool.c b/drivers/net/ethernet/sfc/ef100_ethtool.c
index 135ece2f1375..702abbe59b76 100644
--- a/drivers/net/ethernet/sfc/ef100_ethtool.c
+++ b/drivers/net/ethernet/sfc/ef100_ethtool.c
@@ -43,8 +43,6 @@ const struct ethtool_ops ef100_ethtool_ops = {
 	.get_pauseparam         = efx_ethtool_get_pauseparam,
 	.set_pauseparam         = efx_ethtool_set_pauseparam,
 	.get_sset_count		= efx_ethtool_get_sset_count,
-	.get_priv_flags		= efx_ethtool_get_priv_flags,
-	.set_priv_flags		= efx_ethtool_set_priv_flags,
 	.self_test		= efx_ethtool_self_test,
 	.get_strings		= efx_ethtool_get_strings,
 	.get_link_ksettings	= efx_ethtool_get_link_ksettings,
diff --git a/drivers/net/ethernet/sfc/ethtool_common.c b/drivers/net/ethernet/sfc/ethtool_common.c
index 6649a2327d03..a8cbceeb301b 100644
--- a/drivers/net/ethernet/sfc/ethtool_common.c
+++ b/drivers/net/ethernet/sfc/ethtool_common.c
@@ -101,14 +101,6 @@ static const struct efx_sw_stat_desc efx_sw_stat_desc[] = {
 
 #define EFX_ETHTOOL_SW_STAT_COUNT ARRAY_SIZE(efx_sw_stat_desc)
 
-static const char efx_ethtool_priv_flags_strings[][ETH_GSTRING_LEN] = {
-	"log-tc-errors",
-};
-
-#define EFX_ETHTOOL_PRIV_FLAGS_LOG_TC_ERRS		BIT(0)
-
-#define EFX_ETHTOOL_PRIV_FLAGS_COUNT ARRAY_SIZE(efx_ethtool_priv_flags_strings)
-
 void efx_ethtool_get_drvinfo(struct net_device *net_dev,
 			     struct ethtool_drvinfo *info)
 {
@@ -460,8 +452,6 @@ int efx_ethtool_get_sset_count(struct net_device *net_dev, int string_set)
 		       efx_ptp_describe_stats(efx, NULL);
 	case ETH_SS_TEST:
 		return efx_ethtool_fill_self_tests(efx, NULL, NULL, NULL);
-	case ETH_SS_PRIV_FLAGS:
-		return EFX_ETHTOOL_PRIV_FLAGS_COUNT;
 	default:
 		return -EINVAL;
 	}
@@ -488,39 +478,12 @@ void efx_ethtool_get_strings(struct net_device *net_dev,
 	case ETH_SS_TEST:
 		efx_ethtool_fill_self_tests(efx, NULL, strings, NULL);
 		break;
-	case ETH_SS_PRIV_FLAGS:
-		for (i = 0; i < EFX_ETHTOOL_PRIV_FLAGS_COUNT; i++)
-			strscpy(strings + i * ETH_GSTRING_LEN,
-				efx_ethtool_priv_flags_strings[i],
-				ETH_GSTRING_LEN);
-		break;
 	default:
 		/* No other string sets */
 		break;
 	}
 }
 
-u32 efx_ethtool_get_priv_flags(struct net_device *net_dev)
-{
-	struct efx_nic *efx = efx_netdev_priv(net_dev);
-	u32 ret_flags = 0;
-
-	if (efx->log_tc_errs)
-		ret_flags |= EFX_ETHTOOL_PRIV_FLAGS_LOG_TC_ERRS;
-
-	return ret_flags;
-}
-
-int efx_ethtool_set_priv_flags(struct net_device *net_dev, u32 flags)
-{
-	struct efx_nic *efx = efx_netdev_priv(net_dev);
-
-	efx->log_tc_errs =
-		!!(flags & EFX_ETHTOOL_PRIV_FLAGS_LOG_TC_ERRS);
-
-	return 0;
-}
-
 void efx_ethtool_get_stats(struct net_device *net_dev,
 			   struct ethtool_stats *stats,
 			   u64 *data)
diff --git a/drivers/net/ethernet/sfc/ethtool_common.h b/drivers/net/ethernet/sfc/ethtool_common.h
index 0afc74021a5e..659491932101 100644
--- a/drivers/net/ethernet/sfc/ethtool_common.h
+++ b/drivers/net/ethernet/sfc/ethtool_common.h
@@ -27,8 +27,6 @@ int efx_ethtool_fill_self_tests(struct efx_nic *efx,
 int efx_ethtool_get_sset_count(struct net_device *net_dev, int string_set);
 void efx_ethtool_get_strings(struct net_device *net_dev, u32 string_set,
 			     u8 *strings);
-u32 efx_ethtool_get_priv_flags(struct net_device *net_dev);
-int efx_ethtool_set_priv_flags(struct net_device *net_dev, u32 flags);
 void efx_ethtool_get_stats(struct net_device *net_dev,
 			   struct ethtool_stats *stats __attribute__ ((unused)),
 			   u64 *data);
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 2e9ba0cfe848..7ef823d7a89a 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -855,7 +855,6 @@ enum efx_xdp_tx_queues_mode {
  * @timer_max_ns: Interrupt timer maximum value, in nanoseconds
  * @irq_rx_adaptive: Adaptive IRQ moderation enabled for RX event queues
  * @irqs_hooked: Channel interrupts are hooked
- * @log_tc_errs: Error logging for TC filter insertion is enabled
  * @irq_rx_mod_step_us: Step size for IRQ moderation for RX event queues
  * @irq_rx_moderation_us: IRQ moderation time for RX event queues
  * @msg_enable: Log message enable flags
@@ -1018,7 +1017,6 @@ struct efx_nic {
 	unsigned int timer_max_ns;
 	bool irq_rx_adaptive;
 	bool irqs_hooked;
-	bool log_tc_errs;
 	unsigned int irq_mod_step_us;
 	unsigned int irq_rx_moderation_us;
 	u32 msg_enable;
