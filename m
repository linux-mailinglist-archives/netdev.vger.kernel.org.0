Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CDB45E84E1
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 23:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232827AbiIWVaB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 17:30:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232753AbiIWV37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 17:29:59 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D19035E31F
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 14:29:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N7Wnt6DgI3OWfufoTnOVC8+NMky3RgXVr3r6Wb7j4Pl+Uxsb5cl2HIopqESPMFSx8eB22pzGnFfq77GdoIqkSfatlQ9LGtRQT1XuV08T1404AykcEUS4mqcanzgs8tih0b2mLEDbNgUY9mHSOQ1J8ZuFb+MqD5ICvfEPRqEb29TUW0xQypYiMXJy0nv+20J51oYmL9Y4WaQW7Cqs7FODW/xpQ2iIrzJw+2ZSEAE2Hh9g6WbgwXvXNSiyyIaZ/5RMt1CIZtHjjD/1pOFUx87FEGazrhem1LmugPfQ8nW3MjG+NXT3kM31sVZYvEGXLINFRvrU6Q54ZrTqHCPhLPUvzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F+gwaQ5ZB4wauMMEjimUTnM+1AZmtKeZGVrRPRChL3U=;
 b=Lt/v0GEyM18VHneof+V2cv57sPmWZTeLEsf4A/Q+oQ9wr0r7Yvj7L6WqZ8ubNSm7ifb2Gi+zucfmWYzPgqfds3fhzmAqJg2lFA/AmAm00226Lqqo2FpRBq9/Av0n30HUiBA4GQTq2kz/A/ZNZMr6GXIud25GK+gK73qsl318wJwepcUPdgnL50Hk4+LOH+56yQyH9uEAkY9TCx/n0lzk9KcVkBRBUcNEd9wn6eTe4Y2+GTj1BQeKQgcEBCeSrgFvigesu5Gx2nP9sJh5YVCRFKPv2HH72s261oYiyCq5jVNX01IzxJ8uF7d1GMomMw9qMwp+zjBenF1S5DfHMA+kcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F+gwaQ5ZB4wauMMEjimUTnM+1AZmtKeZGVrRPRChL3U=;
 b=AJHzEeFAnoqokBwPT4phVDYMh2bQjj+7wZ+eCnqU9msHegvo+8LgcYrNn4m0x0CHJQvJuHVWreJ+cV8rur4r2euI39OVT/DdAaD5hBcHlj/EVUWDo1JACxqnLmPz96RB7u2M2bDDuIscPi6RGF3umAiYKgJGZjvGfCeU4595ptsUdphpBcUtUvO9/WPOiECcVgmcETuFqNzFVYJ2kDABbhzMceO5UfyZPWPgLp9GQoJcY2wHSME7t3B8z0o75KOQjyBRbOG5KwEzztFEOip/jI50S/fSMbmGq+JbhI+asKXl/mR14zq2iTk3uFKhWtjcsff9N+W4IM3clpBBnvvcRQ==
Received: from BN1PR10CA0006.namprd10.prod.outlook.com (2603:10b6:408:e0::11)
 by MN2PR12MB4551.namprd12.prod.outlook.com (2603:10b6:208:263::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20; Fri, 23 Sep
 2022 21:29:55 +0000
Received: from BN8NAM11FT095.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e0:cafe::67) by BN1PR10CA0006.outlook.office365.com
 (2603:10b6:408:e0::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20 via Frontend
 Transport; Fri, 23 Sep 2022 21:29:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT095.mail.protection.outlook.com (10.13.176.206) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5654.14 via Frontend Transport; Fri, 23 Sep 2022 21:29:55 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 23 Sep
 2022 16:29:54 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Fri, 23 Sep 2022 16:29:53 -0500
From:   <ecree@xilinx.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
Subject: [PATCH net-next 3/6] sfc: optional logging of TC offload errors
Date:   Fri, 23 Sep 2022 22:05:35 +0100
Message-ID: <4d0739086b12813e9858bc96e1a9e4689a202f80.1663962653.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1663962652.git.ecree.xilinx@gmail.com>
References: <cover.1663962652.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT095:EE_|MN2PR12MB4551:EE_
X-MS-Office365-Filtering-Correlation-Id: bfdfb946-ef2f-404a-7946-08da9daac20f
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hs723wljy+cHK27D9EhU0A0W0wnsYhQ2achln8HZyRniEUyvg/PJkMn5Oa1vZA7uFJrXDxi5It8eQmNRizBxHJmXkxG/7kfryto9vKRDWbz/5P1jvmHpwzkXQgDV0T6Mtaj1F1uXUA5DYKQMXkuhxtAw994PwNp3V8Kbr9Fwus7T9mf6hk9p57D8w4OGj9cG9GyndvWdyFlKv6QZBzTiHzYo9WUkfzU3uerNNtypQ9aVuym9ZAwSW5/vattuUNTZgJyYBeCwoNxfdCvaYqzJdYm6qsRMk1F9v0NcCxAwFzKuYGdMOSots3nyInWYVNK45hfhq7GQMvCB5+f/eo63cwyTL6pO/XLQTdtYiukwYiXkBfY5upQDQqi3BEn/uEAxmnn726ocSl3d3hfEdHl87CeXjUi0IJ6yy/7a/1lydX1OPe9Ri7qAjEg3bmBaiWkpUrLsEKlHj2crKlTMIMPABSqWu4WlkLBDMRRHZFgw5dKtj13jLDhYB6duAtOREsH/AiVyBgj00HfZNSa42M0HT7ovwhSK9crqSPwpvHvVOjHNa8JfY31iRCp8w9Cw1y6WDsH20NRwFn3zGtIR/c/f2OqXdAAqSOt0i3GeSRa8ltFcj294T74EGXNzknEWXvnpPsC29rnTovvOJHmBTh5gx503bYhj+0XGEQBl2PkwHmGlRXjpPH54SHPvO4RAxuyA0kzbfB5ivk7NRjfoBkaitVi6ykOGuMm7OHPEE3LCCfPifJDl3XXD7LkXI58IL8eX/GYY8KWD7GiDD8vebTm5YZSeYwPBPm0V3Gjlsj9LoQNxpVABbCxQpfmYdE9cgEHf
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(136003)(396003)(346002)(451199015)(36840700001)(40470700004)(46966006)(82310400005)(82740400003)(36860700001)(8676002)(4326008)(70206006)(70586007)(110136005)(316002)(2876002)(54906003)(2906002)(8936002)(41300700001)(83380400001)(26005)(47076005)(186003)(336012)(42882007)(9686003)(5660300002)(478600001)(6666004)(55446002)(36756003)(40460700003)(81166007)(40480700001)(356005)(83170400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 21:29:55.1360
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bfdfb946-ef2f-404a-7946-08da9daac20f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT095.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4551
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

TC offload support will involve complex limitations on what matches and
 actions a rule can do, in some cases potentially depending on rules
 already offloaded.  So add an ethtool private flag "log-tc-errors" which
 controls reporting the reasons for un-offloadable TC rules at NETIF_INFO.

Reviewed-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/ef100_ethtool.c  |  2 ++
 drivers/net/ethernet/sfc/ethtool_common.c | 37 +++++++++++++++++++++++
 drivers/net/ethernet/sfc/ethtool_common.h |  2 ++
 drivers/net/ethernet/sfc/net_driver.h     |  2 ++
 drivers/net/ethernet/sfc/tc.h             | 18 +++++++++++
 5 files changed, 61 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef100_ethtool.c b/drivers/net/ethernet/sfc/ef100_ethtool.c
index 702abbe59b76..135ece2f1375 100644
--- a/drivers/net/ethernet/sfc/ef100_ethtool.c
+++ b/drivers/net/ethernet/sfc/ef100_ethtool.c
@@ -43,6 +43,8 @@ const struct ethtool_ops ef100_ethtool_ops = {
 	.get_pauseparam         = efx_ethtool_get_pauseparam,
 	.set_pauseparam         = efx_ethtool_set_pauseparam,
 	.get_sset_count		= efx_ethtool_get_sset_count,
+	.get_priv_flags		= efx_ethtool_get_priv_flags,
+	.set_priv_flags		= efx_ethtool_set_priv_flags,
 	.self_test		= efx_ethtool_self_test,
 	.get_strings		= efx_ethtool_get_strings,
 	.get_link_ksettings	= efx_ethtool_get_link_ksettings,
diff --git a/drivers/net/ethernet/sfc/ethtool_common.c b/drivers/net/ethernet/sfc/ethtool_common.c
index a8cbceeb301b..6649a2327d03 100644
--- a/drivers/net/ethernet/sfc/ethtool_common.c
+++ b/drivers/net/ethernet/sfc/ethtool_common.c
@@ -101,6 +101,14 @@ static const struct efx_sw_stat_desc efx_sw_stat_desc[] = {
 
 #define EFX_ETHTOOL_SW_STAT_COUNT ARRAY_SIZE(efx_sw_stat_desc)
 
+static const char efx_ethtool_priv_flags_strings[][ETH_GSTRING_LEN] = {
+	"log-tc-errors",
+};
+
+#define EFX_ETHTOOL_PRIV_FLAGS_LOG_TC_ERRS		BIT(0)
+
+#define EFX_ETHTOOL_PRIV_FLAGS_COUNT ARRAY_SIZE(efx_ethtool_priv_flags_strings)
+
 void efx_ethtool_get_drvinfo(struct net_device *net_dev,
 			     struct ethtool_drvinfo *info)
 {
@@ -452,6 +460,8 @@ int efx_ethtool_get_sset_count(struct net_device *net_dev, int string_set)
 		       efx_ptp_describe_stats(efx, NULL);
 	case ETH_SS_TEST:
 		return efx_ethtool_fill_self_tests(efx, NULL, NULL, NULL);
+	case ETH_SS_PRIV_FLAGS:
+		return EFX_ETHTOOL_PRIV_FLAGS_COUNT;
 	default:
 		return -EINVAL;
 	}
@@ -478,12 +488,39 @@ void efx_ethtool_get_strings(struct net_device *net_dev,
 	case ETH_SS_TEST:
 		efx_ethtool_fill_self_tests(efx, NULL, strings, NULL);
 		break;
+	case ETH_SS_PRIV_FLAGS:
+		for (i = 0; i < EFX_ETHTOOL_PRIV_FLAGS_COUNT; i++)
+			strscpy(strings + i * ETH_GSTRING_LEN,
+				efx_ethtool_priv_flags_strings[i],
+				ETH_GSTRING_LEN);
+		break;
 	default:
 		/* No other string sets */
 		break;
 	}
 }
 
+u32 efx_ethtool_get_priv_flags(struct net_device *net_dev)
+{
+	struct efx_nic *efx = efx_netdev_priv(net_dev);
+	u32 ret_flags = 0;
+
+	if (efx->log_tc_errs)
+		ret_flags |= EFX_ETHTOOL_PRIV_FLAGS_LOG_TC_ERRS;
+
+	return ret_flags;
+}
+
+int efx_ethtool_set_priv_flags(struct net_device *net_dev, u32 flags)
+{
+	struct efx_nic *efx = efx_netdev_priv(net_dev);
+
+	efx->log_tc_errs =
+		!!(flags & EFX_ETHTOOL_PRIV_FLAGS_LOG_TC_ERRS);
+
+	return 0;
+}
+
 void efx_ethtool_get_stats(struct net_device *net_dev,
 			   struct ethtool_stats *stats,
 			   u64 *data)
diff --git a/drivers/net/ethernet/sfc/ethtool_common.h b/drivers/net/ethernet/sfc/ethtool_common.h
index 659491932101..0afc74021a5e 100644
--- a/drivers/net/ethernet/sfc/ethtool_common.h
+++ b/drivers/net/ethernet/sfc/ethtool_common.h
@@ -27,6 +27,8 @@ int efx_ethtool_fill_self_tests(struct efx_nic *efx,
 int efx_ethtool_get_sset_count(struct net_device *net_dev, int string_set);
 void efx_ethtool_get_strings(struct net_device *net_dev, u32 string_set,
 			     u8 *strings);
+u32 efx_ethtool_get_priv_flags(struct net_device *net_dev);
+int efx_ethtool_set_priv_flags(struct net_device *net_dev, u32 flags);
 void efx_ethtool_get_stats(struct net_device *net_dev,
 			   struct ethtool_stats *stats __attribute__ ((unused)),
 			   u64 *data);
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 7ef823d7a89a..2e9ba0cfe848 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -855,6 +855,7 @@ enum efx_xdp_tx_queues_mode {
  * @timer_max_ns: Interrupt timer maximum value, in nanoseconds
  * @irq_rx_adaptive: Adaptive IRQ moderation enabled for RX event queues
  * @irqs_hooked: Channel interrupts are hooked
+ * @log_tc_errs: Error logging for TC filter insertion is enabled
  * @irq_rx_mod_step_us: Step size for IRQ moderation for RX event queues
  * @irq_rx_moderation_us: IRQ moderation time for RX event queues
  * @msg_enable: Log message enable flags
@@ -1017,6 +1018,7 @@ struct efx_nic {
 	unsigned int timer_max_ns;
 	bool irq_rx_adaptive;
 	bool irqs_hooked;
+	bool log_tc_errs;
 	unsigned int irq_mod_step_us;
 	unsigned int irq_rx_moderation_us;
 	u32 msg_enable;
diff --git a/drivers/net/ethernet/sfc/tc.h b/drivers/net/ethernet/sfc/tc.h
index 7b1a6fa0097d..3e2299c5a885 100644
--- a/drivers/net/ethernet/sfc/tc.h
+++ b/drivers/net/ethernet/sfc/tc.h
@@ -14,6 +14,24 @@
 #include <net/flow_offload.h>
 #include "net_driver.h"
 
+/* Error reporting: convenience macros.  For indicating why a given filter
+ * insertion is not supported; errors in internal operation or in the
+ * hardware should be netif_err()s instead.
+ */
+/* Used when error message is constant. */
+#define EFX_TC_ERR_MSG(efx, extack, message)	do {			\
+	NL_SET_ERR_MSG_MOD(extack, message);				\
+	if (efx->log_tc_errs)						\
+		netif_info(efx, drv, efx->net_dev, "%s\n", message);	\
+} while (0)
+/* Used when error message is not constant; caller should also supply a
+ * constant extack message with NL_SET_ERR_MSG_MOD().
+ */
+#define efx_tc_err(efx, fmt, args...)	do {		\
+if (efx->log_tc_errs)					\
+	netif_info(efx, drv, efx->net_dev, fmt, ##args);\
+} while (0)
+
 struct efx_tc_action_set {
 	u16 deliver:1;
 	u32 dest_mport;
