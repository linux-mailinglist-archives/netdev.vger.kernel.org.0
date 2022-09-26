Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62BCD5EB0A3
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 20:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231251AbiIZS7Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 14:59:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbiIZS7L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 14:59:11 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2050.outbound.protection.outlook.com [40.107.244.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E98C868A8
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 11:59:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hgRkzDBWyOPZQqwYsFlH5Aikpm3/GTTQogFuY1P3BPkfWND7QUMZPvxGbOw0zIWXcoS7t0+2Rxv6EPKxfIAoHgVL0iRaDbS770ruBPvd7qmTRp6lYI9SjQHbYk3bF9NHQqjnKHCzENnddvoK4RtzdplX4aF+y9CzE/fcnBKgyAALbsWwYSL8o9lgvgd8ILeCkoIGUXIycCKupXpyd5d9UjTe4l1vBrc4zLZ5leF44cMQA0siFHHBNoByTLNgSaCi9OKtNq3kIpxtg1JU7GY8MIq5DUb/5U+P/BRTSowS1wpBY2CcNmuziL0g8ghjxKrX8gEFboLlO6VuHZlW+LNe5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vJdc5tx2gP7FuLO9AXh0otorKyCJXe/Q3Vk/XHtuxiY=;
 b=T5BFHuvoMwSOGbkBj8/fzpofzwzd/QgSJaXjeUgly7hhdc3ur3iKUEzeLftOEMN9Y5o1ju8uLFL6TqTRENEDzucK12WHtLBcCQ2B9WgBSZ3nrwS30Fggsg2Tj/oGhKxa4epthZOXJ3RYdfe6XSaU0XDWFjsJ5dLwzJ6lIWpqXYVh/0rcjNhh65uNZSlXAODdS5u5QWK+TQwfJCBZduHLDjnJ4x2/9WG0sJwf4lbXlyRfqj0sl0CAatbm+c57luvGaSpFvad0d6hZE/DoDPwRokyKLh/WYrzaNb+bEt5GbluJ/SQPTj/86YnQK+yyZlrTITn9U80PgMkD0X+vxfcreQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vJdc5tx2gP7FuLO9AXh0otorKyCJXe/Q3Vk/XHtuxiY=;
 b=sVxRcLNcwF6d+4aGBQd8FTfiZGtvlOkzKnYUi2sh3Cx9mExBHcwHOqME6+ozKe3o/yT976ymXI5oHzcUlLCwxyiZ516Tpt+LmV19fBB3N85dg4MOy3mjYI7snFZOJAbJB9AbxUmnvAip6A/C/fSDSgAn1rew5oM1xjkiGIqyW8DYGjUj53W9Y0WsiNCvg4aCuilovxPFv40aNydwFQrxKwpAGoaT74kkXThPiMfYuHQMp132bKSrqgkAzHzbBXRWP8Tg7vNP4qUjqlGCp+mFUEenglMkoKMLpHx0LgtOa/W4evBaksB3r3nxlM7PWWDrt61aKZ8ryNgiA7fUAzWfVQ==
Received: from MW4PR03CA0016.namprd03.prod.outlook.com (2603:10b6:303:8f::21)
 by DS0PR12MB6464.namprd12.prod.outlook.com (2603:10b6:8:c4::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.24; Mon, 26 Sep 2022 18:59:05 +0000
Received: from CO1NAM11FT084.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8f:cafe::22) by MW4PR03CA0016.outlook.office365.com
 (2603:10b6:303:8f::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25 via Frontend
 Transport; Mon, 26 Sep 2022 18:59:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT084.mail.protection.outlook.com (10.13.174.194) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5654.14 via Frontend Transport; Mon, 26 Sep 2022 18:59:05 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 26 Sep
 2022 13:59:04 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Mon, 26 Sep 2022 13:59:03 -0500
From:   <ecree@xilinx.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH v2 net-next 3/6] sfc: optional logging of TC offload errors
Date:   Mon, 26 Sep 2022 19:57:33 +0100
Message-ID: <a1ff1d57bcd5a8229dd5f2147b09c4b2b896ecc9.1664218348.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1664218348.git.ecree.xilinx@gmail.com>
References: <cover.1664218348.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT084:EE_|DS0PR12MB6464:EE_
X-MS-Office365-Filtering-Correlation-Id: c7b4b86e-a23d-41f6-a76c-08da9ff12f44
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kdY/Gs3XC3z1SX4vx5wiIxO594nC4HPv/GI4udq0t/WwFuAQcBh7X7rUdA0Zwd7+GrHDD3BTzSEl6MIyxhw4Sb36h8CWKgxQPJS8Xq65yLL4VQ0DMFMiKdt2s1juAtwCvCAg1fCotPyw0exi85X4gXhUbIaO1QM7Q/vGA7soJmrkDq8nfXfPfGcJOrPY9lXPZicqRD+61RVHwkcjql24Jg0iRtcolXrQt3biNAVIxtZC/HzmJNxgXZn7YlwRwQe3D73U5jzBS67V0KpjFykZYA75HIh9t5kT9Fm2YRqEea8xVFrQ8Ma4pE87DNsFHtXdcLVP55YWQDCFY34QdqY2pnQ6z7xh2A6e9o5tehay580Lgaed3pNAQDdEtpqagQXvYmCBzkIVP04nj6DJ9X8Io3Bofuv6xEEyCssgeKTDDSn0XIsTs5Jruki1oghwyhnEq3TmVZ6VKGVew98Aw9wM8eOJhFkk2cN/7gupJHmQOOzY6zKjLXAMksR13QD78AhxW7zrHbO2mR/iFqyu7DgWQXyz3OmXeBCRQ1j+DMeA+dM+DGIhk9Vteu4L0EfaZTK0nw0UuqWPpkphNNd1UAViwpjV0de4AEpu3vv3ZSCFECSPAUlzyUKzSWIbF+kpwiSyzqbpvzC/2iC29mAeB0hgJWlUddqkfD1ETGBFP2EQPBgw9SavIpLg7wPFITIAHx2bpmXS62+FNka4JSCePNXStSjyDeJEvbeZqqhZUIdG2CVrIkTnMMaoN8zNdxXGZ0h81uwDwf9zBrD0hhxS86Yvc/x1yOZVuIQbXHRDgVHIyW99YcV2RFY9o6HCPFZwnIrC
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(376002)(39860400002)(136003)(451199015)(46966006)(36840700001)(40470700004)(478600001)(9686003)(55446002)(26005)(316002)(6666004)(54906003)(41300700001)(5660300002)(2906002)(2876002)(8936002)(83380400001)(110136005)(186003)(47076005)(42882007)(336012)(40460700003)(81166007)(83170400001)(356005)(82310400005)(8676002)(36860700001)(82740400003)(36756003)(70206006)(70586007)(4326008)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2022 18:59:05.3434
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c7b4b86e-a23d-41f6-a76c-08da9ff12f44
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT084.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6464
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
