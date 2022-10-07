Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 744575F78E9
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 15:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbiJGN0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 09:26:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbiJGN0D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 09:26:03 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2041.outbound.protection.outlook.com [40.107.220.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18BE09C2D6
        for <netdev@vger.kernel.org>; Fri,  7 Oct 2022 06:26:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y/ZF1ZHX0DpYC4HE+XiYte7Bad8/yNZDlKs7Q6Py6PBrt5YumgWSEJSgnRtBUqIjNakBSypjxUeK0T5hI95ck7ow/AqJNqGTXl4UvbnX2r24x44G2rLa4SmE7QJ96B2f3O8e7PqzJTQnxjBm7F8oZ3Pdg7VaN89HA5FEf7m9ZTmn/YOA1viuhnGsU5Dmr1lNqlEx3ctVsCk5kCR7k2HcRQlFJ0lHVFhI4ERyhQlGJ37hXuedFWPbUP4STTGy+Qhge42iqwaaw239YVy9RrxbuCl64iXSSW9gX1ZzBLkpU2yqJbcqEffJaceraybCZ5bKnAM+S68VLuGMqiseUKbM2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KzrYube0RKL32HMfYnsHerQ8HH37t16kSQHaSnXZxpA=;
 b=QK2AXGVELFWyyasluL/f98MyrdvDFMbbXQ89UuaDzRSQo6kRe2jDw37jAWUyKguBQpF142Iatx7NbFhUBtSSlmscoVW1qyVRuTw3k0Hl3Hjs4krRQ9rlUl76Ut0xswzHB6Cd1JBpQ1ptXCiRSOhD/RVFjYDIA7FoXgcflgBaL17qcQrg47c1cWcr8fBXWwqNH4NI7RqPerQCb301HTMiWPTXR+3eGmm1UThAtYLop+ladXFRworgObsjlIRQV/rCTwZbHHRfOz4Dg9kIRNzW+Sc9ARDrUuszu28TB/4BsdG7ozFmyUqSVvGGYYdYbl52SQOYHp0CCYYoi8xLs662qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KzrYube0RKL32HMfYnsHerQ8HH37t16kSQHaSnXZxpA=;
 b=BqjsK7UC6Ilp0dUOh4FBAvtCzSmQNj54YAn9RS1DyFdMu8+Pz13rRfMFT6qm90VQqGnbB4j+yUvfbC4a6UjUPGAmbDB61aA6UyLTRtzkvQPdQ+UyMfLrSAaF/V9Uab9qSDLCD10PH1PmJtfYfQvAd4IUBingnUCMe2LijYCHC7l6eyKGK479/06kMrA0OwvNp0OBy+1x18f9q9yGlZp6RUVKPKUhtPUVaJdMqr3OufiGCT3OhDrenT5bJNPaEevVoz4rGBdsgBNBYvhmikP9jazxoJjlwmZzg5QH9d74LOCFM0FGqXrzLT2RhnWQba6lHoJdIrr7+c9EvY/NlVgH4w==
Received: from BN9PR03CA0931.namprd03.prod.outlook.com (2603:10b6:408:108::6)
 by DM4PR12MB5120.namprd12.prod.outlook.com (2603:10b6:5:393::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Fri, 7 Oct
 2022 13:26:00 +0000
Received: from BN8NAM11FT097.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:108:cafe::f8) by BN9PR03CA0931.outlook.office365.com
 (2603:10b6:408:108::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24 via Frontend
 Transport; Fri, 7 Oct 2022 13:26:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT097.mail.protection.outlook.com (10.13.176.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5709.10 via Frontend Transport; Fri, 7 Oct 2022 13:25:59 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 7 Oct
 2022 08:25:59 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 7 Oct
 2022 08:25:58 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Fri, 7 Oct 2022 08:25:57 -0500
From:   <ecree@xilinx.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        <johannes@sipsolutions.net>, <marcelo.leitner@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: [RFC PATCH net-next 3/3] sfc: remove 'log-tc-errors' ethtool private flag
Date:   Fri, 7 Oct 2022 14:25:14 +0100
Message-ID: <7f21319d25833b4bd8b34615d1aa91465c5a8481.1665147129.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1665147129.git.ecree.xilinx@gmail.com>
References: <cover.1665147129.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT097:EE_|DM4PR12MB5120:EE_
X-MS-Office365-Filtering-Correlation-Id: 07c615aa-f0a4-402c-bdb0-08daa867797c
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V+Pk1dSUKp+MX/KbS8SItWj5iAOW/xn+MHJynvazM9PXasYTrZmcxVMDm9Ygpw/FlgF/04CpxKqsAHuzaS0mgGncojILOIePqBepkQe2BJ/aJ7G+lXBVL+8DEk/hyDvgrXa2rStfGWE5rNMRl5SXJDsLvN3A0zVybQUppeNgI+vROICrzYORE4aSjaeeNxbp7bIpt2sqhqTQQnRo52dwsWAz4tcIJARky8u3XWkffQEeVP617NlUSNIQ9n8Fri5T3r59Mi1Z9bM8XmdvAG6aL9AmhIvJ9q2Lfkl/9LNikCYdXzdDm1xd5zRd9H4pBD7i7AkCXNrD5loyrdQc0EPWBfJQ+NtUQCQnSKs+VnwoW/HTyWntByPX6Ks660lwfCt/b14mKsdhEmT0E+LcHBTRS/n0RediZGfu7tY9pkuzTlAacCrv2qmNW3Q94/QDamAdLoQ0UjZSzPlwToRwfDU7kRW2vRIcAbOkDyVLWWxhyFBsbhGLvIKoqR6sASnt0fsfPLf+/7rMuN7Al7zeeAjycrcJHjTXstpBtUVA3ykm5UVb5QasQ8J7p7LTpiY1TbJH8TBl52MrSXTlRqQJNEfp+TDgYmIpUx0z7+b8u1/2+8YetMEw1PbH8trsvfZ7qAZDcOnMjNnYglN6sAkTbp0gmGpSR7n4ES6MQL6BeeDqN1cTy4jt9KmMRNo1dAr/uyR82RAzJqjs3H0fyHhgI7g4ETAFLvBsm3obeLi68vb4xzKC2luYT+/jOG8bh9lCm/qQgFBEYE5+nNv0ec0K2HrUedvATRSVL8MrT1vuzdmcpRc=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(39860400002)(136003)(346002)(451199015)(46966006)(36840700001)(40470700004)(8676002)(316002)(36860700001)(81166007)(82310400005)(83380400001)(55446002)(82740400003)(83170400001)(40480700001)(356005)(9686003)(47076005)(70206006)(2906002)(110136005)(2876002)(8936002)(41300700001)(5660300002)(336012)(186003)(42882007)(54906003)(4326008)(40460700003)(478600001)(70586007)(26005)(6666004)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2022 13:25:59.9037
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 07c615aa-f0a4-402c-bdb0-08daa867797c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT097.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5120
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=no
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
