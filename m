Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4578E602EAD
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 16:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbiJROis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 10:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbiJROiq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 10:38:46 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2084.outbound.protection.outlook.com [40.107.244.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94150CD5F9
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 07:38:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oT+w1EYas6WWa8KP8yFv/sBVHvFFfhwks+Q9AUO1XtBsB39dvTvRXB0Cq2kvv6nv2XuTZV3gmohR86CfNcqKb6xKSCymP4MmEHWBV4NDYNglzIzGZge+VfPD1Yg4ms4/65K8UmeoV0giGzCTjTcv7a7Tr8O0AsTxP6wsJz5Z98X2P+6Sbw3WJmQij/UZFvYRfLV2vLGO2nCWFXzFin2lbPhzqQR7OCdcN94b7e3kxgbTrXiHdl9jm+eVYFU1Kt1oC2vvvrhxTkE11LJ2kvr7fAuPtLWxH0FsGaNOL8UfGkmO1azXwi+bGdhtv1bLSzQHA7k/kHRwyG9n/wykRomreA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KzrYube0RKL32HMfYnsHerQ8HH37t16kSQHaSnXZxpA=;
 b=f/etTqhz/MPP2JvsIqnToBeetfkPS8Ylu4m80tlS/w0AWSXwIAdrDtYzhzw8An94+lhv3g0IlH8SikABA+5O6JA6azpUOmPiJwiR//XQntPc0ZntDmas/hIara64trm5eaBBD2k0+MQpoCXdS3xtXQvMW8PYyTrmG+tLZAT0+zd6B9Eb6NLSJC/vU00KZiE9WsP1Aoj1PCE3xmlJUGO3o8nYcMk1vRrv850nyRwSA+E8A/LoAFWaWe51dT8CmOYaO+NFTAxVWY6cT+27UaCqDAApBtvlKYMK5fmvK3zECTlF0idQpTLoHLVhxgP0OhbsCiUnnVxG+3NynGkEXgmptA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KzrYube0RKL32HMfYnsHerQ8HH37t16kSQHaSnXZxpA=;
 b=LyCG9b673kYRrIxhmWro5LMYKRjSHYkAvn1XskVA4piyiAQP8T91a7fPuemBAIdESIIv7LNL4rt0e1PKg/86P4BcyDxyAgNK4a3PLFFFpPHJnKQynLCMP6tkzEqVluhKX5MXxVl/7JabmUevYm3Hml//8ZwO0wBudNsUVXfY5Kc=
Received: from DM6PR11CA0025.namprd11.prod.outlook.com (2603:10b6:5:190::38)
 by CY5PR12MB6622.namprd12.prod.outlook.com (2603:10b6:930:42::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.33; Tue, 18 Oct
 2022 14:38:43 +0000
Received: from DM6NAM11FT111.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:190:cafe::b8) by DM6PR11CA0025.outlook.office365.com
 (2603:10b6:5:190::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.31 via Frontend
 Transport; Tue, 18 Oct 2022 14:38:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT111.mail.protection.outlook.com (10.13.173.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5723.20 via Frontend Transport; Tue, 18 Oct 2022 14:38:43 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 18 Oct
 2022 09:38:19 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31 via Frontend
 Transport; Tue, 18 Oct 2022 09:38:17 -0500
From:   <edward.cree@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        <johannes@sipsolutions.net>, <marcelo.leitner@gmail.com>,
        <jiri@resnulli.us>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH v3 net-next 3/3] sfc: remove 'log-tc-errors' ethtool private flag
Date:   Tue, 18 Oct 2022 15:37:29 +0100
Message-ID: <d19a1a71c5154ea73d9b52a7694f388f8bbf5d35.1666102698.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1666102698.git.ecree.xilinx@gmail.com>
References: <cover.1666102698.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT111:EE_|CY5PR12MB6622:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ccf6399-dd6d-4ec7-9048-08dab1167509
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9PVyoD2EIadTaIQXhcrKXt+CmPWJEUJ9vmw9W7+oI4EqkbL09mMSgU47gU8xPneKmrh6dxpRewLPJC1xXOgISdifcVpOufgh1yk3Q/Zzy7NI87ihb1tdtabsQk50WFv9wdF6y3tl/Sc3GUFfXYo4MvcR3kgS0c+avK5bSxdGVCnFNUV/tAfWzeYiWsMD4N9fCvEWwtTH3fV/se1A8JjwJ3nNmNo0mNVSxgO1BOBOx6KEg/yH+d2VksA8m5o/q9qMvBwwZT322FX3Edxl4e0jwLhgH7ukxu/GBqnyOUpNEVHZmuabR7r6cMfsZA9oOlSt2v4JcP5tKxKGLieF0hL76GE2xXaTHYqnr1ShNiaRFFyvPyFgsDgZiRphhcpKD4IlS0HrJr7nrl3Csq/CcTy5JrJqF5rgPLlTWW1bnIRKUy7fqONUqntKe/f5+vzaJ+n5TSlxgtlqsHRCH1MUQIGB25HChAUAIHMp48v5pXGx/f5hoUIhtCRDnR3nXLUpXtaEkZrJ7PcGfmQRpwJMxZjOuAzwZFcBLK0xsXIZ0bsz74nBexGwYI80nkat89zhuYYhQc7sFkt124Nu24Q3agxPetKZgj3rd00I0I+33EqGaTB9ZSbeAxSnj86QCc7G7JkVT04F3e2kSXScdUlf4hqXuElLAjwejd/0Z7eak1ySIpgGs6sp7RygGbsVpY8JznuyeEwLt7+y+qXWoDkPNdCwtJqGT7JSOVD39eg8MXsSNjCy6EHC8hu0yF2Rmo7q1AgrpvixcfoBRWQ3BN16ItV8m5k5wVWM4MqqFNlBJVzRM4g=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(396003)(136003)(346002)(451199015)(36840700001)(46966006)(40470700004)(2876002)(2906002)(4326008)(8676002)(7416002)(8936002)(5660300002)(41300700001)(55446002)(86362001)(36756003)(356005)(82740400003)(81166007)(40460700003)(9686003)(26005)(110136005)(6636002)(336012)(186003)(54906003)(82310400005)(6666004)(478600001)(36860700001)(70586007)(70206006)(40480700001)(426003)(47076005)(316002)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 14:38:43.6679
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ccf6399-dd6d-4ec7-9048-08dab1167509
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT111.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6622
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
