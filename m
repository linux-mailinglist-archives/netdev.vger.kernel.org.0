Return-Path: <netdev+bounces-11240-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B05EC7321E9
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 23:53:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D33481C20EFA
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 21:53:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF371174D7;
	Thu, 15 Jun 2023 21:53:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDBB4174C5
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 21:53:16 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2052.outbound.protection.outlook.com [40.107.237.52])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B96D02962
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 14:53:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OVfZpm282D7xaUB2aHpxE2yk/Z4ekyBQTgiV+iexoGOi1/MvMYhUVeUxrMI8NLo+eakCC8o/z3HlZN3i9YvRO1++RoniNsMzcRUPcED3vMxYWhgCEyPDJIy9RyQY1vuAqWXraSR226KPD7yLVjItkgJ1CMabz+I7jRSlp38TnE7M8Mg8sOQrHEr77WiJLvKpGjM52LF2rN71Ca+2tC2oT1fauVoFPDVwQ1WUlaGGgmPzXQemHdO2pFiDwKu7stPa6+pqf9wBoAU2JVYhVSPsg55QqHXhjg6YdGweysw+yOXr2SwEw9RUM8HpXtLCf6EDLDc+lzvo6yY9uLVpSAc5kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XcIi9FkmeIPocxGNS1wu5NDlimqLjGl8C0ma0l17wyA=;
 b=HRMICfFr+S2zw/YO5CGd6+R1/WQeaMUrxwFKU/9vJdj5XX0Kgi7pFojwQr3IcVUAZdbbBM2r3RZvH+9h0JS7+mElxB+GIFqkx7DPd5EJFGqIvYIvWBuDbMfQLvOMVpd89so9tArp/7+gR6j4mV8IMCddXOf/bpT9jb1gCXkoxLUDlU+ii2LQ1ZQHH9meoNrTxDDN8NDGnDFftSkqpvostde4acbC055MYRL/ZLl8Xd7ZXsQEfQrdJfxAUGIZmP3UVxskdwseuw/CBm+K8zOlTme/oE7YxfMGVX3yaFfFSKuSl4LoWsRCykvx4+Blpg7bQbY8MfNXVo3U/Xe0sydxoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XcIi9FkmeIPocxGNS1wu5NDlimqLjGl8C0ma0l17wyA=;
 b=UVKaJ3HE15aFL3/cCIFvsg8quX0bWirO8+Kcmot4SveQUH44bMcUp7xlCUvX+JwuHMM0+er6i5ok9DPe9XrEsmk+JfQz8FJxj5FKuEx0lq12Na4BlpvINQ4JaTZ7Tuu+Fch5g+3noBYRCSI5Oi83c73mnPJ7mc7vGD/2XElr3xQ=
Received: from MW4P220CA0001.NAMP220.PROD.OUTLOOK.COM (2603:10b6:303:115::6)
 by CH3PR12MB8725.namprd12.prod.outlook.com (2603:10b6:610:170::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.25; Thu, 15 Jun
 2023 21:53:11 +0000
Received: from MWH0EPF000989EB.namprd02.prod.outlook.com
 (2603:10b6:303:115:cafe::7c) by MW4P220CA0001.outlook.office365.com
 (2603:10b6:303:115::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37 via Frontend
 Transport; Thu, 15 Jun 2023 21:53:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000989EB.mail.protection.outlook.com (10.167.241.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.27 via Frontend Transport; Thu, 15 Jun 2023 21:53:10 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Thu, 15 Jun
 2023 16:53:09 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Thu, 15 Jun
 2023 16:53:09 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23 via Frontend
 Transport; Thu, 15 Jun 2023 16:53:07 -0500
From: <edward.cree@amd.com>
To: <linux-net-drivers@amd.com>, <davem@davemloft.net>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <edumazet@google.com>
CC: Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
	<habetsm.xilinx@gmail.com>, <oe-kbuild-all@lists.linux.dev>,
	<simon.horman@corigine.com>, <pieter.jansen-van-vuuren@amd.com>,
	<naresh.kamboju@linaro.org>, kernel test robot <lkp@intel.com>
Subject: [PATCH v2 net-next] sfc: do not try to call tc functions when CONFIG_SFC_SRIOV=n
Date: Thu, 15 Jun 2023 22:52:43 +0100
Message-ID: <20230615215243.34942-1-edward.cree@amd.com>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000989EB:EE_|CH3PR12MB8725:EE_
X-MS-Office365-Filtering-Correlation-Id: fb14f676-7eef-411e-f63f-08db6deae930
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	StBiHvR97dNcYam10RvR5v9aciOFdnA15udo2j4xienz7/25aQzm3LjnMXQkXVO+Lqq7rdiPoQFOcnDW7JNk3wCufWaDoHb5ZxuwQAmYZcmNGRO441XNQCsN5so6XLAeKZxy3t2u7g2D7muH4NGeOa4syH02NHFWYUzafGsVT7OWLeI7/iRe1IVsfMuWNOaGaya1SUR7bgWsTh+0QXXsT2DK3ko3zWSs0U2IS6M5xiVWKen/2hU2q473JKDa3h1rYEM4D+7jjZCSsuWxUrJVPVAMdL4/Cm6k15rZsJ+qZdkOYV6Xj1+9waVxzuaR+1N2gvgoPM7OIhb3FTAXtMVV4GfJAWkaI+d7Deis1VnOGIlWvoJcWWNvPBV3agfASNhTklt3iMAGCwTPBHIJnKpqJsyZggB9FHyKYIEAjyOEJokkwoDn27iEiF0B0hIU9AZXGia5WtktnnnSAzxUpL1w7gC57kWsZ494havJCic1KdacWZ1q5Ct442+uoaaYMDtHxwXRhz8HasAoE2dSvVBZ2i0sEwjKHfcDuQbOyvzMYFoxP8OLJZSuZwnTRMSEyvyigsNXxRL6wjep7HlfBW2dSUxHywXzKaGonlAZl1S32o7QjZdTSEFTNEYde7GFFFZIUKH75K3/1Yi3fLPgvWnOV/gFaxVWf67Oufa1KDERJ7lQPlcjmkXaAoSgWvpBFPRdp6LYQzw7p2ODsTIugmsaOCCZQKay/339iJxhrMI05T+f/7gspIq7XLqaJY9zSBSx
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(136003)(376002)(396003)(451199021)(40470700004)(46966006)(36840700001)(81166007)(478600001)(82740400003)(6666004)(356005)(82310400005)(40480700001)(83380400001)(26005)(336012)(2616005)(426003)(36860700001)(47076005)(186003)(36756003)(1076003)(966005)(40460700003)(316002)(7416002)(41300700001)(2876002)(70206006)(70586007)(4326008)(86362001)(2906002)(5660300002)(8676002)(8936002)(110136005)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 21:53:10.3725
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fb14f676-7eef-411e-f63f-08db6deae930
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000989EB.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8725
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Edward Cree <ecree.xilinx@gmail.com>

Functions efx_tc_netdev_event and efx_tc_netevent_event do not exist
 in that case as object files tc_bindings.o and tc_encap_actions.o
 are not built, so the calls to them from ef100_netdev_event and
 ef100_netevent_event cause link errors.
Wrap the corresponding header files (tc_bindings.h, tc_encap_actions.h)
 with #if IS_ENABLED(CONFIG_SFC_SRIOV), and add an #else with static
 inline stubs for these two functions.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202306102026.ISK5JfUQ-lkp@intel.com/
Fixes: 7e5e7d800011 ("sfc: neighbour lookup for TC encap action offload")
Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/tc_bindings.h      | 12 ++++++++++++
 drivers/net/ethernet/sfc/tc_encap_actions.h | 11 +++++++++++
 2 files changed, 23 insertions(+)

diff --git a/drivers/net/ethernet/sfc/tc_bindings.h b/drivers/net/ethernet/sfc/tc_bindings.h
index 095ddeb59eb3..a326d23d322b 100644
--- a/drivers/net/ethernet/sfc/tc_bindings.h
+++ b/drivers/net/ethernet/sfc/tc_bindings.h
@@ -12,6 +12,7 @@
 #define EFX_TC_BINDINGS_H
 #include "net_driver.h"
 
+#if IS_ENABLED(CONFIG_SFC_SRIOV)
 #include <net/sch_generic.h>
 
 struct efx_rep;
@@ -28,4 +29,15 @@ int efx_tc_indr_setup_cb(struct net_device *net_dev, struct Qdisc *sch,
 			 void (*cleanup)(struct flow_block_cb *block_cb));
 int efx_tc_netdev_event(struct efx_nic *efx, unsigned long event,
 			struct net_device *net_dev);
+
+#else /* CONFIG_SFC_SRIOV */
+
+static inline int efx_tc_netdev_event(struct efx_nic *efx, unsigned long event,
+				      struct net_device *net_dev)
+{
+	return NOTIFY_DONE;
+}
+
+#endif /* CONFIG_SFC_SRIOV */
+
 #endif /* EFX_TC_BINDINGS_H */
diff --git a/drivers/net/ethernet/sfc/tc_encap_actions.h b/drivers/net/ethernet/sfc/tc_encap_actions.h
index 4d755fb92daf..c3c7904ad7ff 100644
--- a/drivers/net/ethernet/sfc/tc_encap_actions.h
+++ b/drivers/net/ethernet/sfc/tc_encap_actions.h
@@ -12,6 +12,7 @@
 #define EFX_TC_ENCAP_ACTIONS_H
 #include "net_driver.h"
 
+#if IS_ENABLED(CONFIG_SFC_SRIOV)
 #include <linux/refcount.h>
 #include <net/tc_act/tc_tunnel_key.h>
 
@@ -100,4 +101,14 @@ void efx_tc_unregister_egdev(struct efx_nic *efx, struct net_device *net_dev);
 int efx_tc_netevent_event(struct efx_nic *efx, unsigned long event,
 			  void *ptr);
 
+#else /* CONFIG_SFC_SRIOV */
+
+static inline int efx_tc_netevent_event(struct efx_nic *efx,
+					unsigned long event, void *ptr)
+{
+	return NOTIFY_DONE;
+}
+
+#endif /* CONFIG_SFC_SRIOV */
+
 #endif /* EFX_TC_ENCAP_ACTIONS_H */

