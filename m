Return-Path: <netdev+bounces-10226-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 79A8272D12F
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 22:56:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC812280F10
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 20:56:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDB9CD2EE;
	Mon, 12 Jun 2023 20:56:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E74EA0
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 20:56:42 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2069.outbound.protection.outlook.com [40.107.244.69])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B64D83C19
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 13:56:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y675Wo/CA0NhdtavuFeOJfeos4uW8R7efQwd1xSyCZfPfizvdnJRcSrxNx4ASnJQiEF2GIoE10D3Evtm6Z6qH/2CKetoCu7wliSfxkiRrBJ7ZMd1vsUKl4lo+gXnoT2jhdbMescKaJGXA5Cc7mqAa/QlxQmJA4HPWPrO+9cxIIlh3b+TfS9tpQRlbxAdcl3w/UvEHuqcWvW0wOgTvaGPz/O8XaHgorANAVHnGMbUx4FgiJsdpEorZr+ycDd1ONdxKftgkib97F1ROhKyOokuCaV3/CdBMuR7NlPXXJT6rss97LfyqacNjAkpyooqqpJ4StELZQQwHbw8lKyjo4H4MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9+zgW5aG9fkuRRAf/BBbcA6qgQp00lKScPUSpatEl/Q=;
 b=nyyahkYeL/11VN7hLJY2gRxzRYxKhte0WeU5StSHvCrtqEpBccvMC8tv/1GDmEJCDtHZq/QhgsqgsnkaYk6qNImUHtOY0slv6wBL5QYIl/AduX6NdOdShJjalw00zJaBoE2cgRvbT0mBGh0ku8qqOpNN8oG5UEs6aWd0s+1qcybqjiE/Ry0y/CkndPB3sN4SOPscpISKjwtPxYpAWufXprdM4ne06f41m6Cx4KJqmbWqjgf4azIn7gFAPtoeU37XKNeX8VoET+w/uqFwkEZxDOVsl4xcNEOSQvFoasWDlLprPj0FiY+cE5L75ms1NGQZfhAumEvI2IiB04ESD9wddA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9+zgW5aG9fkuRRAf/BBbcA6qgQp00lKScPUSpatEl/Q=;
 b=04MgnLVPZBwL4qm6JAuqiqUIsTMYlKC2oqPVmxKrb8NAC0borRSUikMyGkz3iRHXih1qliiBPt6ap53HsOdSDKGbdlQSE+tuQH1XTsUb2OGVbNcTHHHeNtz/R9p68vZsASXFDbL84t+jdtvY8562DzqNSmn1M7FY9e3hDD8QFN4=
Received: from DS7PR06CA0024.namprd06.prod.outlook.com (2603:10b6:8:2a::8) by
 BL0PR12MB4884.namprd12.prod.outlook.com (2603:10b6:208:1ca::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Mon, 12 Jun
 2023 20:55:13 +0000
Received: from MWH0EPF000989E9.namprd02.prod.outlook.com
 (2603:10b6:8:2a:cafe::c6) by DS7PR06CA0024.outlook.office365.com
 (2603:10b6:8:2a::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.33 via Frontend
 Transport; Mon, 12 Jun 2023 20:55:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000989E9.mail.protection.outlook.com (10.167.241.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.22 via Frontend Transport; Mon, 12 Jun 2023 20:55:12 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Mon, 12 Jun
 2023 15:55:11 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23 via Frontend
 Transport; Mon, 12 Jun 2023 15:55:10 -0500
From: <edward.cree@amd.com>
To: <linux-net-drivers@amd.com>, <davem@davemloft.net>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <edumazet@google.com>
CC: Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
	<habetsm.xilinx@gmail.com>, <oe-kbuild-all@lists.linux.dev>,
	<simon.horman@corigine.com>, kernel test robot <lkp@intel.com>
Subject: [PATCH net-next] sfc: do not try to call tc functions when CONFIG_SFC_SRIOV=n
Date: Mon, 12 Jun 2023 21:54:28 +0100
Message-ID: <20230612205428.1780-1-edward.cree@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000989E9:EE_|BL0PR12MB4884:EE_
X-MS-Office365-Filtering-Correlation-Id: c4e5f941-de0c-4b69-5857-08db6b8750e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	c1kpMSM9D1bwdjb53kKl115PlSE/uiTCK+Kxuh9E73WNhKdYiSDzX2MvRU3e3mIMNdr8rEZGuCOfEGg3S4wXVS2cIKm5coBzNUuHu4/B6h4dA2izaHSoHv2Rop0PsWjFNL9/ZGZGvl4JdiuLnEN9tzYtEu+eQAT5TH0sV3LK+hS0LvFW59ui6ofSRsoH1wp8By0XU4bvgZd86+rFMDdS5R1vY1Vl/n2CQ2E38e0sOcyG+FbwuqsV62+TuhTvjnBW2pW2CrFv/GmquGFb7ocyTveUqifeih9Bp9bIvFHLj/VsyiqjX1mg43yBinzubiiiDMIPPYA6zvOdDhuZzUPzPmy23ZVVU9XFY6e/Hx2AEftAaSCBrGCP37Sc2xYtQH5IWijCLSI6sp6kuzfMNXJA0b39iLDxvOez2OjXnpt6v0XkfVD9jfw7PmeYr3mme8uJwX8qpHrp1rgh3f+8CooKRnX2ugcaUbNbpFP/DYfXimSGur1i0eC4GfoZwZInZEKKrPa/JlDLWPSg6KJDXA7AtSjwfz1zyiywDY9UWzhG0ucKA4fpBExKQ8OmzzchWP5AoPbohXK81gW6z07rwWDHewVFz074VgT6Nybb+KHWovMSM7O+qFA8Ge0ziPeFigYpvNJvevK78aNXEyecJ9S3sz5MVleUL8ry4w5ADvuOAp1m39oCKGA9UeugPVxjHr0Xz/7ZOiIeV7bw2JNOyVUK6RUZCZu8SQUcG3PSf+b/31tDpY7UoYWKrrYqp2veSBeS
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(136003)(376002)(396003)(451199021)(46966006)(36840700001)(40470700004)(40460700003)(6666004)(966005)(36756003)(426003)(336012)(83380400001)(47076005)(2616005)(82310400005)(86362001)(81166007)(82740400003)(1076003)(26005)(356005)(40480700001)(36860700001)(186003)(2876002)(2906002)(110136005)(54906003)(70206006)(4326008)(316002)(7416002)(70586007)(41300700001)(5660300002)(478600001)(8936002)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 20:55:12.3353
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c4e5f941-de0c-4b69-5857-08db6b8750e1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000989E9.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4884
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
Guard the relevant part of ef100_netdev_event with #ifdef, as well as
 the entire function ef100_netevent_event and the code that registers
 and unregisters the netevent notifier.
Also guard the includes of tc_bindings.h and tc_encap_actions.h into
 ef100_netdev.c, as the symbols from these headers are only available
 when the corresponding object files are built.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202306102026.ISK5JfUQ-lkp@intel.com/
Fixes: 7e5e7d800011 ("sfc: neighbour lookup for TC encap action offload")
Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/ef100_netdev.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
index 7f7d560cb2b4..3bb0442de7ea 100644
--- a/drivers/net/ethernet/sfc/ef100_netdev.c
+++ b/drivers/net/ethernet/sfc/ef100_netdev.c
@@ -23,8 +23,10 @@
 #include "mcdi_filters.h"
 #include "rx_common.h"
 #include "ef100_sriov.h"
+#ifdef CONFIG_SFC_SRIOV
 #include "tc_bindings.h"
 #include "tc_encap_actions.h"
+#endif
 #include "efx_devlink.h"
 
 static void ef100_update_name(struct efx_nic *efx)
@@ -301,22 +303,27 @@ int ef100_netdev_event(struct notifier_block *this,
 {
 	struct efx_nic *efx = container_of(this, struct efx_nic, netdev_notifier);
 	struct net_device *net_dev = netdev_notifier_info_to_dev(ptr);
+#ifdef CONFIG_SFC_SRIOV
 	struct ef100_nic_data *nic_data = efx->nic_data;
 	int err;
+#endif
 
 	if (efx->net_dev == net_dev &&
 	    (event == NETDEV_CHANGENAME || event == NETDEV_REGISTER))
 		ef100_update_name(efx);
 
+#ifdef CONFIG_SFC_SRIOV
 	if (!nic_data->grp_mae)
 		return NOTIFY_DONE;
 	err = efx_tc_netdev_event(efx, event, net_dev);
 	if (err & NOTIFY_STOP_MASK)
 		return err;
+#endif
 
 	return NOTIFY_DONE;
 }
 
+#ifdef CONFIG_SFC_SRIOV
 static int ef100_netevent_event(struct notifier_block *this,
 				unsigned long event, void *ptr)
 {
@@ -329,9 +336,9 @@ static int ef100_netevent_event(struct notifier_block *this,
 	err = efx_tc_netevent_event(efx, event, ptr);
 	if (err & NOTIFY_STOP_MASK)
 		return err;
-
 	return NOTIFY_DONE;
 };
+#endif
 
 static int ef100_register_netdev(struct efx_nic *efx)
 {
@@ -392,8 +399,8 @@ void ef100_remove_netdev(struct efx_probe_data *probe_data)
 	rtnl_unlock();
 
 	unregister_netdevice_notifier(&efx->netdev_notifier);
-	unregister_netevent_notifier(&efx->netevent_notifier);
 #if defined(CONFIG_SFC_SRIOV)
+	unregister_netevent_notifier(&efx->netevent_notifier);
 	if (!efx->type->is_vf)
 		efx_ef100_pci_sriov_disable(efx, true);
 #endif
@@ -513,6 +520,7 @@ int ef100_probe_netdev(struct efx_probe_data *probe_data)
 		goto fail;
 	}
 
+#ifdef CONFIG_SFC_SRIOV
 	efx->netevent_notifier.notifier_call = ef100_netevent_event;
 	rc = register_netevent_notifier(&efx->netevent_notifier);
 	if (rc) {
@@ -520,6 +528,7 @@ int ef100_probe_netdev(struct efx_probe_data *probe_data)
 			  "Failed to register netevent notifier, rc=%d\n", rc);
 		goto fail;
 	}
+#endif
 
 	efx_probe_devlink_unlock(efx);
 	return rc;

