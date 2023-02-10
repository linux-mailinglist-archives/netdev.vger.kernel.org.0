Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8170D691F78
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 14:04:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232114AbjBJNEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 08:04:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232113AbjBJNEF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 08:04:05 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2081.outbound.protection.outlook.com [40.107.93.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A79ED7396A
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 05:03:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RVuUsd3MywOvli/a7CMPyPgxt+OBwFrAIqpjt8WHytH2pJwHWY1nemvNADnb59PYKhnnu7cuxoB1OgSUI1JPSWKoKstbpxoeJ4Q1nbzULB40CL9drfDd0gZUx6ti5BIdMANY1EXsRTt9MELc00lZp/O3SougfBxjC67YPrHMB7aKVJ6Fko952PfjQGb+VJZkRDxf70gSYEsF3/3q99tJaXG8LIDq0FM9238VHAc30cveIV+BhNBwmvo8wlhCaG9JEL8M0kSwqg8vDiXCtVhjwY1iYBdYbwS5iVLJ9ikfLwmf+qfYpbsd/9vPPaerNiXRlSsqrwp9XV0bSOSv+DdNHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=14orTkbRdXyOLwcepz1mkxaqyy05acLbbIkznLScwJE=;
 b=djTHvDs2A9WGafOMUXyfHhAdJxctklCm+wx5Lw+rqgHTD4Llj0VAZKV5ctrNJcWhdOsIxgBVJSzEhKczzBUsV4gvCQekky0gRsY6ijlovaL+Nbb/YmNqEHiPfK/hx+1tfsRLco79OJNReGbEgoryvA8PzcOp8jLOlbPBmd0R2Cz19YdkdPBvLPMHcTWDp0TZaGV6VFMOfqjCUBEI8jd4ZD5wB7WI4rWB5ddcLA6vQx562Xd6VsP1BxBlf4446TDzJ9h6Mz9Sat2AkfPcLymndxH95YELuImlBKyVJwSk2X5lwrGTuDQPOMqNynzOOmcKRFsuNn9F2RNiX0iV8fvDeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=14orTkbRdXyOLwcepz1mkxaqyy05acLbbIkznLScwJE=;
 b=kc9Tx2g4MNkA0IK+Ftf/eg0XUS/hDnAnOLNEig8l0a089BbpH8eEPIiEmXCNjMzg+ta4ZXkgD42Cx/QKHakFVWSAHVI7nDZbB6ambajYYMdZ9TPtGEJh6OdAXUcBR+D5ljtEPoHE6y1+GvmCLGJMbzJc78voiQXHk5yNK0ImcsQ=
Received: from DM6PR07CA0090.namprd07.prod.outlook.com (2603:10b6:5:337::23)
 by BY5PR12MB4323.namprd12.prod.outlook.com (2603:10b6:a03:211::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.21; Fri, 10 Feb
 2023 13:03:52 +0000
Received: from DM6NAM11FT086.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:337:cafe::5c) by DM6PR07CA0090.outlook.office365.com
 (2603:10b6:5:337::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.21 via Frontend
 Transport; Fri, 10 Feb 2023 13:03:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT086.mail.protection.outlook.com (10.13.173.75) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6086.21 via Frontend Transport; Fri, 10 Feb 2023 13:03:52 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 10 Feb
 2023 07:03:51 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 10 Feb
 2023 05:03:50 -0800
Received: from xhdipdslab59.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Fri, 10 Feb 2023 07:03:47 -0600
From:   Harsh Jain <h.jain@amd.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <thomas.lendacky@amd.com>,
        <Raju.Rangoju@amd.com>, <Shyam-sundar.S-k@amd.com>,
        <harshjain.prof@gmail.com>, <abhijit.gangurde@amd.com>,
        <puneet.gupta@amd.com>, <nikhil.agarwal@amd.com>,
        <tarak.reddy@amd.com>, <netdev@vger.kernel.org>
CC:     Harsh Jain <h.jain@amd.com>
Subject: [PATCH  4/6] net: ethernet: efct: Add Hardware timestamp support
Date:   Fri, 10 Feb 2023 18:33:19 +0530
Message-ID: <20230210130321.2898-5-h.jain@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230210130321.2898-1-h.jain@amd.com>
References: <20230210130321.2898-1-h.jain@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT086:EE_|BY5PR12MB4323:EE_
X-MS-Office365-Filtering-Correlation-Id: 61b22b80-ca47-4ec7-8100-08db0b674223
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WuDqqlLGSHDzsZmeRIIgpCt2F4cqJQH6+DmXSPLfp3zrXe+a0iLaOBLUCl2yJN4nRB0MOaEfPvM/oj7qwsyIx1ycHHR1MPUQrz6H0X4RYslfBypCi9gqOHoIFsP52U0wRBQMvK5RTWCU5BLFf+Fcg/XL08UpxiFZ4TUSP/jUp0+3175/uOjabaEDMdsqfJC3RLpbo0j7W/Qajeq8QCJqA2EBJq1RPvmiJyd9w6I7ZpTyotoN0eztRoxZrUTvVliDB4HkeGvqdabLUgAAhBIvl2YnwIgFOWac2yuYfarr1tUC/u4qZtIpgmb8ZwN+cylasb93SBEmZUxoS2q5IRtSsIP8vNL4P1JKLFZZFfjlVoke490nZb3J+N7E1P3C4bw31qpYSjCRnO8oY1l7yDpq3Q467KsqWjPQWrAHZgXt66iVWQopwEmOqd6lSzjMxZwFU7bEkqtklE9vUMsntyhpplCaipeQ7eCmcQwCQImkSfb931YsGSceQe5hg8nEvgjGAMTNtQPhXcF8dZ0rPqiKXmBXUS0Sy7Nq0gs9+VngZpqk0AJL4dUIIWIlRF91G/FrbxxwJxlmxMx8FX/pcP59AsXmqRXyUuwDCc1Tzt9r+dPP0kfuco+DWiJ9NOzI491YXtdep+bQzQge2XAL7IL+Fpd5nt9dDH8WvsutkPNIhfzfpVApjrW3TyirmqGOgej+i49k32RTHeBoHLkdJIzHkhn97F+pvlaExjFV8yxU7QsoaVh+1t6C+Il+/i5+TPNV
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(396003)(346002)(136003)(451199018)(46966006)(40470700004)(36840700001)(36756003)(86362001)(356005)(82740400003)(81166007)(921005)(36860700001)(70206006)(41300700001)(8936002)(70586007)(316002)(110136005)(5660300002)(4326008)(8676002)(40460700003)(82310400005)(40480700001)(47076005)(30864003)(83380400001)(426003)(2616005)(336012)(478600001)(2906002)(6666004)(186003)(1076003)(26005)(66899018)(36900700001)(559001)(579004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 13:03:52.1123
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 61b22b80-ca47-4ec7-8100-08db0b674223
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT086.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4323
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for
- packet timestamping in Tx/Rx.
- PTP clock support
- Periodic PPS signal output

Signed-off-by: Abhijit Gangurde<abhijit.gangurde@amd.com>
Signed-off-by: Puneet Gupta <puneet.gupta@amd.com>
Signed-off-by: Nikhil Agarwal<nikhil.agarwal@amd.com>
Signed-off-by: Tarak Reddy<tarak.reddy@amd.com>
Signed-off-by: Harsh Jain <h.jain@amd.com>
---
 drivers/net/ethernet/amd/efct/efct_driver.h |   15 +
 drivers/net/ethernet/amd/efct/efct_netdev.c |   24 +
 drivers/net/ethernet/amd/efct/efct_nic.c    |   61 +
 drivers/net/ethernet/amd/efct/efct_ptp.c    | 1481 +++++++++++++++++++
 drivers/net/ethernet/amd/efct/efct_ptp.h    |  186 +++
 drivers/net/ethernet/amd/efct/efct_rx.c     |   35 +
 drivers/net/ethernet/amd/efct/efct_tx.c     |   17 +
 drivers/net/ethernet/amd/efct/mcdi.c        |    9 +
 8 files changed, 1828 insertions(+)
 create mode 100644 drivers/net/ethernet/amd/efct/efct_ptp.c
 create mode 100644 drivers/net/ethernet/amd/efct/efct_ptp.h

diff --git a/drivers/net/ethernet/amd/efct/efct_driver.h b/drivers/net/ethernet/amd/efct/efct_driver.h
index eb110895cb18..205ea7b3b9b4 100644
--- a/drivers/net/ethernet/amd/efct/efct_driver.h
+++ b/drivers/net/ethernet/amd/efct/efct_driver.h
@@ -37,6 +37,9 @@
  * Efx data structures
  *
  **************************************************************************/
+#ifdef CONFIG_EFCT_PTP
+struct efct_ptp_data;
+#endif
 #define EFCT_MAX_RX_QUEUES 16
 #define EFCT_MAX_TX_QUEUES 32
 #define EFCT_MAX_EV_QUEUES 48
@@ -451,6 +454,10 @@ struct efct_ev_queue {
 	unsigned char queue_count;
 	/* Associated queue */
 	void *queue;
+#ifdef CONFIG_EFCT_PTP
+	u64 sync_timestamp_major;
+	enum efct_sync_events_state sync_events_state;
+#endif
 	/* Number of IRQs since last adaptive moderation decision */
 	u32 irq_count;
 	/* IRQ moderation score */
@@ -486,6 +493,10 @@ struct efct_nic {
 	struct net_device *net_dev;
 	void *nic_data;
 	void  *phy_data;
+#ifdef CONFIG_EFCT_PTP
+	struct efct_ptp_data *ptp_data;
+	struct efct_ptp_data *phc_ptp_data;
+#endif
 	enum efct_phy_mode phy_mode;
 	bool phy_power_force_off;
 	enum efct_loopback_mode loopback_mode;
@@ -745,6 +756,10 @@ struct efct_nic_type {
 	irqreturn_t (*irq_handle_msix)(int irq, void *dev_id);
 	u32 (*check_caps)(const struct efct_nic *efct, u8 flag, u32 offset);
 	bool (*has_dynamic_sensors)(struct efct_nic *efct);
+#ifdef CONFIG_EFCT_PTP
+	int (*ptp_set_ts_config)(struct efct_nic *efct, struct hwtstamp_config *init);
+	u32 hwtstamp_filters;
+#endif
 	int (*get_phys_port_id)(struct efct_nic *efct, struct netdev_phys_item_id *ppid);
 	int (*irq_test_generate)(struct efct_nic *efct);
 	void (*ev_test_generate)(struct efct_ev_queue *evq);
diff --git a/drivers/net/ethernet/amd/efct/efct_netdev.c b/drivers/net/ethernet/amd/efct/efct_netdev.c
index a7814a1b1386..b6a69dfc720a 100644
--- a/drivers/net/ethernet/amd/efct/efct_netdev.c
+++ b/drivers/net/ethernet/amd/efct/efct_netdev.c
@@ -12,6 +12,9 @@
 #include "mcdi.h"
 #include "mcdi_port_common.h"
 #include "efct_devlink.h"
+#ifdef CONFIG_EFCT_PTP
+#include "efct_ptp.h"
+#endif
 
 static int efct_netdev_event(struct notifier_block *this,
 			     unsigned long event, void *ptr)
@@ -110,6 +113,10 @@ static void efct_stop_all_queues(struct efct_nic *efct)
 				continue;
 			efct->type->ev_purge(&efct->evq[i]);
 		}
+#ifdef CONFIG_EFCT_PTP
+		for_each_set_bit(i, &efct->evq_active_mask, efct->max_evq_count)
+			efct->evq[i].sync_events_state = SYNC_EVENTS_DISABLED;
+#endif
 		return;
 	}
 
@@ -165,6 +172,9 @@ static int efct_net_open(struct net_device *net_dev)
 	if (rc)
 		goto fail;
 
+#ifdef CONFIG_EFCT_PTP
+	efct_ptp_evt_data_init(efct);
+#endif
 	rc = efct_start_all_queues(efct);
 	if (rc) {
 		netif_err(efct, drv, efct->net_dev, "efct_start_all_queues failed, index %d\n", rc);
@@ -189,6 +199,10 @@ static int efct_net_open(struct net_device *net_dev)
 	netif_start_queue(net_dev);
 	efct->state = STATE_NET_UP;
 	mutex_unlock(&efct->state_lock);
+#ifdef CONFIG_EFCT_PTP
+	if (efct->ptp_data->txtstamp)
+		efct_ptp_tx_ts_event(efct, true);
+#endif
 
 	return 0;
 
@@ -206,6 +220,10 @@ static int efct_net_stop(struct net_device *net_dev)
 {
 	struct efct_nic *efct = efct_netdev_priv(net_dev);
 
+#ifdef CONFIG_EFCT_PTP
+	if (efct->ptp_data->txtstamp &&  !((efct->reset_pending & (1 << RESET_TYPE_DATAPATH))))
+		efct_ptp_tx_ts_event(efct, false);
+#endif
 	mutex_lock(&efct->state_lock);
 	efct->state = STATE_NET_DOWN;
 	netif_stop_queue(net_dev);
@@ -300,6 +318,12 @@ static int efct_eth_ioctl(struct net_device *net_dev, struct ifreq *ifr,
 			  int cmd)
 {
 	switch (cmd) {
+#ifdef CONFIG_EFCT_PTP
+	case SIOCGHWTSTAMP:
+		return efct_ptp_get_ts_config(net_dev, ifr);
+	case SIOCSHWTSTAMP:
+		return efct_ptp_set_ts_config(net_dev, ifr);
+#endif
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/amd/efct/efct_nic.c b/drivers/net/ethernet/amd/efct/efct_nic.c
index 0610b4633e15..90fd3c2c1eab 100644
--- a/drivers/net/ethernet/amd/efct/efct_nic.c
+++ b/drivers/net/ethernet/amd/efct/efct_nic.c
@@ -16,6 +16,9 @@
 #include "mcdi_functions.h"
 #include "efct_nic.h"
 #include "mcdi_port_common.h"
+#ifdef CONFIG_EFCT_PTP
+#include "efct_ptp.h"
+#endif
 #include "efct_evq.h"
 
 #define EFCT_NUM_MCDI_BUFFERS	1
@@ -279,7 +282,17 @@ static int efct_probe_main(struct efct_nic *efct)
 		pci_err(efct->efct_dev->pci_dev, "failed to get timer details\n");
 		goto fail3;
 	}
+#ifdef CONFIG_EFCT_PTP
+	rc = efct_ptp_probe_setup(efct);
+	if (rc) {
+		pci_err(efct->efct_dev->pci_dev, "failed to init PTP\n");
+		goto fail4;
+	}
+#endif
 	return 0;
+#ifdef CONFIG_EFCT_PTP
+fail4:
+#endif
 fail3:
 	efct_remove_common(efct);
 fail2:
@@ -292,6 +305,9 @@ static int efct_probe_main(struct efct_nic *efct)
 
 static void efct_remove_main(struct efct_nic *efct)
 {
+#ifdef CONFIG_EFCT_PTP
+	efct_ptp_remove_setup(efct);
+#endif
 	efct_remove_common(efct);
 	efct_nic_free_buffer(efct, &efct->mcdi_buf);
 	kfree(efct->nic_data);
@@ -504,6 +520,9 @@ static int efct_ev_init(struct efct_ev_queue *eventq)
 	eventq->evq_phase = false;
 	eventq->consumer_index = 0;
 	eventq->unsol_consumer_index = 0;
+#ifdef CONFIG_EFCT_PTP
+	eventq->sync_events_state = SYNC_EVENTS_DISABLED;
+#endif
 	rc = efct_mcdi_ev_init(eventq);
 	if (rc) {
 		netif_err(eventq->efct, drv, eventq->efct->net_dev,
@@ -719,6 +738,21 @@ static void efct_handle_flush_ev(struct efct_nic *efct, bool is_txq, int qid)
 	WARN_ON(atomic_read(&efct->active_queues) < 0);
 }
 
+#ifdef CONFIG_EFCT_PTP
+static int efct_time_sync_event(struct efct_ev_queue *evq, union efct_qword *p_event, int quota)
+{
+	int spent = 1;
+
+	evq->sync_timestamp_major =  EFCT_QWORD_FIELD(*p_event, ESF_HZ_EV_TSYNC_TIME_HIGH_48);
+	/* if sync events have been disabled then we want to silently ignore
+	 * this event, so throw away result.
+	 */
+	(void)cmpxchg(&evq->sync_events_state, SYNC_EVENTS_REQUESTED, SYNC_EVENTS_VALID);
+
+	return spent;
+}
+#endif
+
 /* TODO : Remove this Macro and use from efct_reg.h after the hw yml file is
  * updated with Error events change
  */
@@ -735,6 +769,12 @@ efct_ev_control(struct efct_ev_queue *evq, union efct_qword *p_event, int quota)
 	evq->unsol_consumer_index++;
 
 	switch (subtype) {
+#ifdef CONFIG_EFCT_PTP
+	case ESE_HZ_X3_CTL_EVENT_SUBTYPE_TIME_SYNC:
+		evq->n_evq_time_sync_events++;
+		spent = efct_time_sync_event(evq, p_event, quota);
+		break;
+#endif
 	case ESE_HZ_X3_CTL_EVENT_SUBTYPE_ERROR:
 		{
 			u8 qlabel, ftype, reason;
@@ -1188,6 +1228,9 @@ static void efct_pull_stats(struct efct_nic *efct)
 	if (!efct->stats_initialised) {
 		efct_reset_sw_stats(efct);
 		efct_nic_reset_stats(efct);
+#ifdef CONFIG_EFCT_PTP
+		efct_ptp_reset_stats(efct);
+#endif
 		efct->stats_initialised = true;
 	}
 }
@@ -1380,6 +1423,20 @@ static int efct_type_reset(struct efct_nic *efct, enum reset_type reset_type)
 	netif_info(efct, drv, efct->net_dev, "Resetting statistics.\n");
 	efct->stats_initialised = false;
 	efct->type->pull_stats(efct);
+#ifdef CONFIG_EFCT_PTP
+	if (efct_phc_exposed(efct)) {
+		rc = efct_ptp_start(efct);
+		if (rc < 0) {
+			netif_err(efct, drv, efct->net_dev, "PTP enable failed in reset\n");
+			goto err;
+		}
+		rc = efct_ptp_hw_pps_enable(efct, true);
+		if (rc < 0) {
+			netif_err(efct, drv, efct->net_dev, "PPS enable failed in reset.\n");
+			goto err;
+		}
+	}
+#endif
 	if (was_up) {
 		netif_device_attach(efct->net_dev);
 		return dev_open(efct->net_dev, NULL);
@@ -1490,6 +1547,10 @@ const struct efct_nic_type efct_nic_type = {
 	.map_reset_reason = efct_map_reset_reason,
 	.reset = efct_type_reset,
 	.has_dynamic_sensors = efct_has_dynamic_sensors,
+#ifdef CONFIG_EFCT_PTP
+	.ptp_set_ts_config = efct_ptp_enable_ts,
+	.hwtstamp_filters = 1 << HWTSTAMP_FILTER_NONE | 1 << HWTSTAMP_FILTER_ALL,
+#endif
 	.get_phys_port_id = efct_type_get_phys_port_id,
 	.mcdi_reboot_detected = efct_mcdi_reboot_detected,
 	.irq_test_generate = efct_type_irq_test_generate,
diff --git a/drivers/net/ethernet/amd/efct/efct_ptp.c b/drivers/net/ethernet/amd/efct/efct_ptp.c
new file mode 100644
index 000000000000..142c537064a0
--- /dev/null
+++ b/drivers/net/ethernet/amd/efct/efct_ptp.c
@@ -0,0 +1,1481 @@
+// SPDX-License-Identifier: GPL-2.0
+/****************************************************************************
+ * Driver for AMD/Xilinx network controllers and boards
+ * Copyright (C) 2021, Xilinx, Inc.
+ * Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
+ */
+
+#include "mcdi_pcol.h"
+#include "mcdi.h"
+#include "efct_netdev.h"
+#include "mcdi_functions.h"
+#include "efct_io.h"
+#include "efct_reg.h"
+#include "efct_ptp.h"
+#include "efct_nic.h"
+
+static LIST_HEAD(efct_phcs_list);
+static DEFINE_SPINLOCK(efct_phcs_list_lock);
+
+/* Precalculate scale word to avoid long long division at runtime */
+/* This is equivalent to 2^66 / 10^9. */
+#define PPB_SCALE_WORD  ((1LL << (57)) / 1953125LL)
+
+/* How much to shift down after scaling to convert to FP40 */
+#define PPB_SHIFT_FP40		26
+/* ... and FP44. */
+#define PPB_SHIFT_FP44		22
+
+/* Maximum parts-per-billion adjustment that is acceptable */
+#define MAX_PPB			100000000
+
+#define PTP_SYNC_SAMPLE	6
+
+/*  */
+#define	SYNCHRONISATION_GRANULARITY_NS	1400
+
+#define PTP_TIME_READ_SAMPLE 6
+
+/* Number of bits of sub-nanosecond in partial timestamps */
+#define PARTIAL_TS_SUB_BITS_2 2
+
+#define PARTIAL_TS_NANO_MASK 0xffffffff
+#define PARTIAL_TS_SEC_MASK 0xff
+#define TIME_TO_SEC_SHIFT 32
+#define SYNC_TS_SEC_SHIFT 16
+
+static void efct_ptp_ns_to_s_qns(s64 ns, u32 *nic_major, u32 *nic_minor, u32 *nic_hi)
+{
+	struct timespec64 ts = ns_to_timespec64(ns);
+
+	*nic_hi = (u32)(ts.tv_sec >> TIME_TO_SEC_SHIFT);
+	*nic_major = (u32)ts.tv_sec;
+	*nic_minor = ts.tv_nsec << PARTIAL_TS_SUB_BITS_2;
+}
+
+static u64 efct_ptp_time(struct efct_nic *efct)
+{
+	return le64_to_cpu(_efct_readq(efct->membase + ER_HZ_PORT0_REG_HOST_THE_TIME));
+}
+
+void efct_ptp_evt_data_init(struct efct_nic *efct)
+{
+	struct efct_ptp_data *ptp;
+
+	ptp = efct->ptp_data;
+
+	ptp->evt_frag_idx = 0;
+	ptp->evt_code = 0;
+}
+
+static ktime_t efct_ptp_s_qns_to_ktime_correction(u32 nic_major, u32 nic_minor,
+						  s32 correction)
+{
+	ktime_t kt;
+
+	nic_minor = DIV_ROUND_CLOSEST(nic_minor, 4);
+	correction = DIV_ROUND_CLOSEST(correction, 4);
+
+	kt = ktime_set(nic_major, nic_minor);
+
+	if (correction >= 0)
+		kt = ktime_add_ns(kt, (u64)correction);
+	else
+		kt = ktime_sub_ns(kt, (u64)-correction);
+	return kt;
+}
+
+static ktime_t efct_ptp_s64_qns_to_ktime_correction(u32 nich, u64 timereg,
+						    s64 correction)
+
+{
+	u64 nic_major;
+	u32 nic_minor;
+	ktime_t kt;
+
+	nic_minor = (timereg & 0xFFFFFFFF);
+	nic_minor = DIV_ROUND_CLOSEST(nic_minor, 4);
+	correction = DIV_ROUND_CLOSEST(correction, 4);
+	nic_major = (timereg >> TIME_TO_SEC_SHIFT) | ((u64)nich << 32);
+	kt = ktime_set(nic_major, nic_minor);
+
+	if (correction >= 0)
+		kt = ktime_add_ns(kt, (u64)correction);
+	else
+		kt = ktime_sub_ns(kt, (u64)-correction);
+	return kt;
+}
+
+bool efct_phc_exposed(struct efct_nic *efct)
+{
+	return efct->phc_ptp_data == efct->ptp_data && efct->ptp_data;
+}
+
+static void efct_ptp_delete_data(struct kref *kref)
+{
+	struct efct_ptp_data *ptp = container_of(kref, struct efct_ptp_data,
+						kref);
+
+	ptp->efct = NULL;
+	kfree(ptp);
+}
+
+static s64 efct_get_the_time_read_delay(struct efct_nic *efct)
+{
+	u64 time[PTP_TIME_READ_SAMPLE];
+	struct efct_ptp_data *ptp;
+	s64 mindiff = LONG_MAX;
+	ktime_t t1, t0;
+	int i;
+
+	ptp = efct->ptp_data;
+
+	/* Assuming half of time taken to read PCI register
+	 * as correction
+	 */
+	for (i = 0; i < ARRAY_SIZE(time); i++)
+		time[i] = efct_ptp_time(efct);
+	for (i = 0; i < ARRAY_SIZE(time) - 1; i++) {
+		t1 = ptp->nic64_to_kernel_time(0, time[i + 1], 0);
+		t0 = ptp->nic64_to_kernel_time(0, time[i], 0);
+		if (ktime_to_ns(ktime_sub(t1, t0)) < mindiff)
+			mindiff = ktime_to_ns(ktime_sub(t1, t0));
+	}
+
+	return -(mindiff  >> 1);
+}
+
+int efct_ptp_ts_set_sync_status(struct efct_nic *efct, u32 in_sync, u32 timeout)
+{
+	MCDI_DECLARE_BUF(mcdi_req, MC_CMD_PTP_IN_SET_SYNC_STATUS_LEN);
+	u32 flag;
+	int rc;
+
+	if (!efct->ptp_data)
+		return -ENOTTY;
+
+	if (!(efct->ptp_data->capabilities &
+		(1 << MC_CMD_PTP_OUT_GET_ATTRIBUTES_V2_REPORT_SYNC_STATUS_LBN)))
+		return -EOPNOTSUPP;
+
+	if (in_sync != 0)
+		flag = MC_CMD_PTP_IN_SET_SYNC_STATUS_IN_SYNC;
+	else
+		flag = MC_CMD_PTP_IN_SET_SYNC_STATUS_NOT_IN_SYNC;
+
+	MCDI_SET_DWORD(mcdi_req, PTP_IN_OP, MC_CMD_PTP_OP_SET_SYNC_STATUS);
+	MCDI_SET_DWORD(mcdi_req, PTP_IN_PERIPH_ID, 0);
+	MCDI_SET_DWORD(mcdi_req, PTP_IN_SET_SYNC_STATUS_STATUS, flag);
+	MCDI_SET_DWORD(mcdi_req, PTP_IN_SET_SYNC_STATUS_TIMEOUT, timeout);
+
+	rc = efct_mcdi_rpc(efct, MC_CMD_PTP, mcdi_req, sizeof(mcdi_req),
+			   NULL, 0, NULL);
+	return rc;
+}
+
+static int efct_mcdi_ptp_read_nic_time(struct efct_nic *efct, u32 *sech, u64 *timer_l)
+{
+	size_t outlen;
+	int rc;
+
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_PTP_OUT_READ_NIC_TIME_V2_LEN);
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_PTP_IN_READ_NIC_TIME_V2_LEN);
+
+	MCDI_SET_DWORD(inbuf, PTP_IN_OP, MC_CMD_PTP_OP_READ_NIC_TIME);
+
+	rc = efct_mcdi_rpc(efct, MC_CMD_PTP, inbuf, sizeof(inbuf),
+			   outbuf, sizeof(outbuf), &outlen);
+	if (rc != 0)
+		return rc;
+	if (outlen > MC_CMD_PTP_OUT_READ_NIC_TIME_LEN)
+		*sech = MCDI_DWORD(outbuf, PTP_OUT_READ_NIC_TIME_V2_MAJOR_HI);
+	else
+		*sech = 0;
+	if (timer_l) {
+		*timer_l = MCDI_DWORD(outbuf, PTP_OUT_READ_NIC_TIME_V2_NANOSECONDS);
+		*timer_l |= ((u64)MCDI_DWORD(outbuf, PTP_OUT_READ_NIC_TIME_V2_MAJOR)
+			      << TIME_TO_SEC_SHIFT);
+	}
+
+	return rc;
+}
+
+static int efct_ptp_synchronize(struct efct_nic *efct, u32 num_readings, bool retry)
+{
+	struct pps_event_time last_time;
+	u32 ngood = 0, last_good = 0;
+	struct efct_ptp_timeset *ts;
+	struct timespec64 mc_time;
+	struct efct_ptp_data *ptp;
+	struct timespec64 delta;
+	s64 diff_min = LONG_MAX;
+	struct timespec64 diff;
+	u32 timer_h, timer_h1;
+	s64 diff_avg = 0;
+	s64 correction;
+	int rc = 0;
+	u32 i;
+
+	ts = kmalloc_array(num_readings, sizeof(*ts), GFP_KERNEL);
+	if (!ts)
+		return -ENOMEM;
+	ptp = efct->ptp_data;
+	rc = efct_mcdi_ptp_read_nic_time(efct, &timer_h, NULL);
+	if (rc)
+		goto out;
+
+	for (i = 0; i <  num_readings; i++) {
+		ktime_get_real_ts64(&ts[ngood].prets);
+		ts[ngood].nictime = efct_ptp_time(efct);
+		ktime_get_real_ts64(&ts[ngood].posts);
+		diff = timespec64_sub(ts[ngood].posts, ts[ngood].prets);
+		ts[ngood].window = timespec64_to_ns(&diff);
+		if (ts[ngood].window > SYNCHRONISATION_GRANULARITY_NS) {
+			//TODO addstat. Adjust SYNCHRONISATION_GRANULARITY_NS
+			// macro value based on experiments such this it can guess there is
+			// context switch between pre and post reading
+			++ptp->sw_stats.invalid_sync_windows;
+		} else {
+			mc_time = ktime_to_timespec64(ptp->nic64_to_kernel_time
+				(timer_h, ts[ngood].nictime, 0));
+			diff = timespec64_sub(mc_time, ts[ngood].prets);
+			ts[ngood].mc_host_diff = timespec64_to_ns(&diff);
+
+			diff_avg += div_s64((ts[ngood].mc_host_diff - diff_avg), (ngood + 1));
+			ngood++;
+		}
+	}
+	pps_get_ts(&last_time);
+	rc = efct_mcdi_ptp_read_nic_time(efct, &timer_h1, NULL);
+	if (rc)
+		goto out;
+	if (retry && timer_h != timer_h1)
+		return efct_ptp_synchronize(efct, PTP_SYNC_SAMPLE,  false);
+	if (ngood == 0) {
+		++ptp->sw_stats.skipped_sync;
+		rc = -EAGAIN;
+		goto out;
+	}
+
+	if (ngood > 2) { /* No point doing this if only 1-2 valid samples, Use last_good 0*/
+		/* Find the sample which is closest to the average */
+		for (i = 0; i < ngood; i++) {
+			s64 d = abs(ts[i].mc_host_diff - diff_avg);
+
+			if (d < diff_min) {
+				diff_min = d;
+				last_good = i;
+			}
+		}
+	}
+	correction = efct_get_the_time_read_delay(efct);
+	// Pass correction in quarter nano second format
+	mc_time = ktime_to_timespec64(ptp->nic64_to_kernel_time
+				(timer_h1, ts[last_good].nictime, correction <<
+				efct->efct_dev->params.ts_subnano_bit));
+	ptp->last_delta = timespec64_sub(mc_time, ts[last_good].prets);
+	ptp->last_delta_valid = true;
+	delta = timespec64_sub(last_time.ts_real, ts[last_good].prets);
+	timespec64_add_ns(&delta, mc_time.tv_nsec);
+	pps_sub_ts(&last_time, delta);
+	ptp->host_time_pps = last_time;
+
+out:
+	kfree(ts);
+	return rc;
+}
+
+static void *ptp_data_alloc(gfp_t flags)
+{
+	struct efct_ptp_data *ptp;
+
+	ptp = kzalloc(sizeof(*ptp), flags);
+	if (!ptp)
+		return ERR_PTR(-ENOMEM);
+	kref_init(&ptp->kref);
+
+	return ptp;
+}
+
+static void ptp_data_get(struct efct_ptp_data *ptp)
+{
+	kref_get(&ptp->kref);
+}
+
+static void ptp_data_put(struct efct_ptp_data *ptp)
+{
+	kref_put(&ptp->kref, efct_ptp_delete_data);
+}
+
+static void ptp_data_del(struct efct_ptp_data *ptp)
+{
+	kref_put(&ptp->kref, efct_ptp_delete_data);
+}
+
+static int efct_ptp_get_attributes(struct efct_nic *efct)
+{
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_PTP_OUT_GET_ATTRIBUTES_V2_LEN);
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_PTP_IN_GET_ATTRIBUTES_LEN);
+	struct efct_ptp_data *ptp;
+	s64 freq_adj_min;
+	s64 freq_adj_max;
+	size_t out_len;
+	u32 fmt;
+	int rc;
+
+	ptp = efct->ptp_data;
+
+	MCDI_SET_DWORD(inbuf, PTP_IN_OP, MC_CMD_PTP_OP_GET_ATTRIBUTES);
+	MCDI_SET_DWORD(inbuf, PTP_IN_PERIPH_ID, 0);
+	rc = efct_mcdi_rpc_quiet(efct, MC_CMD_PTP, inbuf, sizeof(inbuf),
+				 outbuf, sizeof(outbuf), &out_len);
+
+	if (rc != 0) {
+		pci_err(efct->efct_dev->pci_dev, "No PTP support\n");
+		efct_mcdi_display_error(efct, MC_CMD_PTP, sizeof(inbuf),
+					outbuf, sizeof(outbuf), rc);
+		goto out;
+	}
+	fmt = MCDI_DWORD(outbuf, PTP_OUT_GET_ATTRIBUTES_V2_TIME_FORMAT);
+	switch (fmt) {
+	case MC_CMD_PTP_OUT_GET_ATTRIBUTES_V2_SECONDS_QTR_NANOSECONDS:
+		if (efct->efct_dev->params.ts_subnano_bit != PARTIAL_TS_SUB_BITS_2) {
+			rc = -EINVAL;
+			pci_err(efct->efct_dev->pci_dev,
+				"Error: Time format %d and design param %d not in sync\n",
+				fmt, efct->efct_dev->params.ts_subnano_bit);
+			goto out;
+		}
+		ptp->ns_to_nic_time = efct_ptp_ns_to_s_qns;
+		ptp->nic_to_kernel_time = efct_ptp_s_qns_to_ktime_correction;
+		ptp->nic64_to_kernel_time = efct_ptp_s64_qns_to_ktime_correction;
+		ptp->nic_time.minor_max = 4000000000UL;
+		ptp->nic_time.sync_event_minor_shift = 24;
+		break;
+	default:
+		pci_err(efct->efct_dev->pci_dev, "Time format not supported 0x%x\n", fmt);
+		rc = -ERANGE;
+		goto out;
+	}
+
+	ptp->capabilities = MCDI_DWORD(outbuf, PTP_OUT_GET_ATTRIBUTES_V2_CAPABILITIES);
+	/* Set up the shift for conversion between frequency
+	 * adjustments in parts-per-billion and the fixed-point
+	 * fractional ns format that the adapter uses.
+	 */
+	if (ptp->capabilities & (1 << MC_CMD_PTP_OUT_GET_ATTRIBUTES_V2_FP44_FREQ_ADJ_LBN)) {
+		ptp->adjfreq_ppb_shift = PPB_SHIFT_FP44;
+	} else {
+		pci_err(efct->efct_dev->pci_dev, "Unsupported fixed-point representation of frequency adjustments\n");
+		return -EINVAL;
+	}
+	if (out_len >= MC_CMD_PTP_OUT_GET_ATTRIBUTES_V2_LEN) {
+		freq_adj_min = MCDI_QWORD(outbuf, PTP_OUT_GET_ATTRIBUTES_V2_FREQ_ADJ_MIN);
+		freq_adj_max = MCDI_QWORD(outbuf, PTP_OUT_GET_ATTRIBUTES_V2_FREQ_ADJ_MAX);
+
+		/* The Linux PTP Hardware Clock interface expects frequency adjustments(adj_ppb) in
+		 * parts per billion(e.g. +10000000 means go 1% faster; -50000000 means go 5%
+		 * slower). The MCDI interface between the driver and the NMC firmware uses a
+		 * nanosecond based adjustment
+		 * (e.g. +0.01 means go 1% faster, -0.05 means go 5% slower).
+		 *	adj_ns = adj_ppb / 10 ^ 9
+		 * adj_ns is represented in the MCDI messages as a signed fixed-point 64-bit value
+		 * with either 40 or 44 bits for the fractional part.
+		 * For the 44 bit format:
+		 * adj_ns_fp44 = adj_ns * 2^44
+		 * adj_ppb = adj_ns_fp44 * 10^9 / 2^44
+		 * The highest common factor of those is 2^9 so that is equivalent to:
+		 * adj_ppb = adj_ns_fp44 * 1953125 / 2^35\
+		 * adj_ppb = 10000000 equivalent to adj_ns = 0.01, corresponding representation in
+		 * fixed point 44 bit format  is 028F5C28F5C.
+		 */
+		freq_adj_min = (freq_adj_min * 1953125LL) >> 35;
+		freq_adj_max = (freq_adj_max * 1953125LL) >> 35;
+		ptp->max_adjfreq = min_t(s64, abs(freq_adj_min), abs(freq_adj_max));
+	} else {
+		ptp->max_adjfreq = MAX_PPB;
+	}
+out:
+	return rc;
+}
+
+static int efct_mcdi_ptp_op_enable(struct efct_nic *efct)
+{
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_PTP_IN_ENABLE_LEN);
+	MCDI_DECLARE_BUF_ERR(outbuf);
+	int rc;
+
+	MCDI_SET_DWORD(inbuf, PTP_IN_OP, MC_CMD_PTP_OP_ENABLE);
+	MCDI_SET_DWORD(inbuf, PTP_IN_PERIPH_ID, 0);
+
+	MCDI_SET_DWORD(inbuf, PTP_IN_ENABLE_MODE, 0);
+
+	rc = efct_mcdi_rpc_quiet(efct, MC_CMD_PTP, inbuf, sizeof(inbuf),
+				 outbuf, sizeof(outbuf), NULL);
+	rc = (rc == -EALREADY) ? 0 : rc;
+	if (rc)
+		efct_mcdi_display_error(efct, MC_CMD_PTP,
+					MC_CMD_PTP_IN_ENABLE_LEN,
+				       outbuf, sizeof(outbuf), rc);
+	return rc;
+}
+
+static int efct_mcdi_ptp_op_disable(struct efct_nic *efct)
+{
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_PTP_IN_DISABLE_LEN);
+	MCDI_DECLARE_BUF_ERR(outbuf);
+	int rc;
+
+	MCDI_SET_DWORD(inbuf, PTP_IN_OP, MC_CMD_PTP_OP_DISABLE);
+	MCDI_SET_DWORD(inbuf, PTP_IN_PERIPH_ID, 0);
+	rc = efct_mcdi_rpc_quiet(efct, MC_CMD_PTP, inbuf, sizeof(inbuf),
+				 outbuf, sizeof(outbuf), NULL);
+	rc = (rc == -EALREADY) ? 0 : rc;
+	if (rc)
+		efct_mcdi_display_error(efct, MC_CMD_PTP,
+					MC_CMD_PTP_IN_DISABLE_LEN,
+				       outbuf, sizeof(outbuf), rc);
+	return rc;
+}
+
+int efct_ptp_start(struct efct_nic *efct)
+{
+	struct efct_ptp_data *ptp = efct->ptp_data;
+	int rc;
+
+	rc = efct_mcdi_ptp_op_enable(efct);
+	if (rc != 0)
+		goto fail;
+
+	ptp->evt_frag_idx = 0;
+	ptp->current_adjfreq = 0;
+	ptp->enabled = true;
+	return 0;
+
+fail:
+	return rc;
+}
+
+int efct_ptp_stop(struct efct_nic *efct)
+{
+	struct efct_ptp_data *ptp = efct->ptp_data;
+	int rc;
+
+	rc = efct_mcdi_ptp_op_disable(efct);
+	ptp->last_delta_valid = false;
+	ptp->enabled = false;
+
+	return rc;
+}
+
+static ktime_t efct_ptp_nic_to_kernel_time(struct efct_tx_queue *txq, u32 sec, u32 nano)
+{
+	struct efct_ev_queue *evq;
+	struct efct_ptp_data *ptp;
+	struct efct_nic *efct;
+	ktime_t kt = { 0 };
+	u32 sync_major;
+	s8 delta;
+
+	efct = txq->efct;
+	ptp = efct->ptp_data;
+	evq = &txq->efct->evq[txq->evq_index];
+	//TODO How to handle ovelapping nanoseconds
+	sync_major = evq->sync_timestamp_major >> SYNC_TS_SEC_SHIFT;
+	delta = sec - sync_major;
+	sec = sync_major + delta;
+	kt = ptp->nic_to_kernel_time(sec, nano, ptp->ts_corrections.general_tx);
+	return kt;
+}
+
+void efct_include_ts_in_skb(struct efct_tx_queue *txq, u64 partial_ts, struct sk_buff *skb)
+{
+	struct skb_shared_hwtstamps timestamps;
+	struct efct_ev_queue *evq;
+	u32 nano;
+	u32 sec;
+
+	evq = &txq->efct->evq[txq->evq_index];
+	if (evq->sync_events_state != SYNC_EVENTS_VALID)
+		return;
+	memset(&timestamps, 0, sizeof(timestamps));
+	nano = (partial_ts & PARTIAL_TS_NANO_MASK);
+	sec = (partial_ts >> TIME_TO_SEC_SHIFT) & PARTIAL_TS_SEC_MASK;
+	timestamps.hwtstamp = efct_ptp_nic_to_kernel_time(txq, sec, nano);
+	//TODO: Enable PTP stat to track dropped timestamp once validation of timestamp is added
+	// ++ptp->sw_stats.invalid_sync_windows;
+	skb_tstamp_tx(skb, &timestamps);
+}
+
+#define PTP_SW_STAT(ext_name, field_name)				\
+	{ #ext_name, 0, offsetof(struct efct_ptp_data, field_name) }
+#define PTP_MC_STAT(ext_name, mcdi_name)				\
+	{ #ext_name, 32, MC_CMD_PTP_OUT_STATUS_STATS_ ## mcdi_name ## _OFST }
+static const struct efct_hw_stat_desc efct_ptp_stat_desc[] = {
+	PTP_SW_STAT(ptp_invalid_sync_windows, sw_stats.invalid_sync_windows),
+	PTP_SW_STAT(ptp_skipped_sync, sw_stats.skipped_sync),
+	PTP_SW_STAT(pps_fw, sw_stats.pps_fw),
+	PTP_SW_STAT(pps_in_count, sw_stats.pps_hw),
+	PTP_MC_STAT(pps_in_offset_mean, PPS_OFF_MEAN),
+	PTP_MC_STAT(pps_in_offset_last, PPS_OFF_LAST),
+	PTP_MC_STAT(pps_in_offset_max, PPS_OFF_MAX),
+	PTP_MC_STAT(pps_in_offset_min, PPS_OFF_MIN),
+	PTP_MC_STAT(pps_in_period_mean, PPS_PER_MEAN),
+	PTP_MC_STAT(pps_in_period_last, PPS_PER_LAST),
+	PTP_MC_STAT(pps_in_period_max, PPS_PER_MAX),
+	PTP_MC_STAT(pps_in_period_min, PPS_PER_MIN),
+	PTP_MC_STAT(pps_in_bad, PPS_BAD),
+	PTP_MC_STAT(pps_in_oflow, PPS_OFLOW),
+};
+
+#define PTP_STAT_COUNT ARRAY_SIZE(efct_ptp_stat_desc)
+
+static const unsigned long efct_ptp_stat_mask[] = {
+	[0 ... BITS_TO_LONGS(PTP_STAT_COUNT) - 1] = ~0UL,
+};
+
+void efct_ptp_reset_stats(struct efct_nic *efct)
+{
+	MCDI_DECLARE_BUF(in_rst_stats, MC_CMD_PTP_IN_RESET_STATS_LEN);
+	struct efct_ptp_data *ptp = efct->ptp_data;
+	int rc;
+
+	if (!ptp)
+		return;
+	memset(&ptp->sw_stats, 0, sizeof(ptp->sw_stats));
+
+	MCDI_SET_DWORD(in_rst_stats, PTP_IN_OP, MC_CMD_PTP_OP_RESET_STATS);
+	MCDI_SET_DWORD(in_rst_stats, PTP_IN_PERIPH_ID, 0);
+
+	rc = efct_mcdi_rpc(efct, MC_CMD_PTP, in_rst_stats, sizeof(in_rst_stats),
+			   NULL, 0, NULL);
+	if (rc < 0)
+		netif_dbg(efct, drv, efct->net_dev, "PPS stats MCDI fail\n");
+}
+
+size_t efct_ptp_describe_stats(struct efct_nic *efct, u8 *strings)
+{
+	if (!efct->ptp_data)
+		return 0;
+
+	return efct_nic_describe_stats(efct_ptp_stat_desc, PTP_STAT_COUNT,
+				      efct_ptp_stat_mask, strings);
+}
+
+size_t efct_ptp_update_stats(struct efct_nic *efct, u64 *stats)
+{
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_PTP_OUT_STATUS_LEN);
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_PTP_IN_STATUS_LEN);
+	struct efct_ptp_data *ptp = efct->ptp_data;
+	size_t i;
+	int rc;
+
+	if (!ptp)
+		return 0;
+
+	/* Copy software statistics */
+	for (i = 0; i < PTP_STAT_COUNT; i++) {
+		if (efct_ptp_stat_desc[i].dma_width)
+			continue;
+		stats[i] = *(u32 *)((char *)efct->ptp_data +
+					     efct_ptp_stat_desc[i].offset);
+	}
+	/* Fetch MC statistics.  We *must* fill in all statistics or
+	 * risk leaking kernel memory to userland, so if the MCDI
+	 * request fails we pretend we got zeroes.
+	 */
+	MCDI_SET_DWORD(inbuf, PTP_IN_OP, MC_CMD_PTP_OP_STATUS);
+	MCDI_SET_DWORD(inbuf, PTP_IN_PERIPH_ID, 0);
+	rc = efct_mcdi_rpc(efct, MC_CMD_PTP, inbuf, sizeof(inbuf),
+			   outbuf, sizeof(outbuf), NULL);
+	if (rc)
+		memset(outbuf, 0, sizeof(outbuf));
+	efct_nic_update_stats(efct_ptp_stat_desc, PTP_STAT_COUNT,
+			      efct_ptp_stat_mask,
+			     stats,
+			     NULL,
+			     _MCDI_PTR(outbuf, 0));
+
+	return PTP_STAT_COUNT;
+}
+
+/* Get PTP timestamp corrections */
+static int efct_ptp_get_timestamp_corrections(struct efct_nic *efct)
+{
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_PTP_OUT_GET_TIMESTAMP_CORRECTIONS_V2_LEN);
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_PTP_IN_GET_TIMESTAMP_CORRECTIONS_LEN);
+	size_t out_len;
+	int rc;
+
+	MCDI_SET_DWORD(inbuf, PTP_IN_OP,
+		       MC_CMD_PTP_OP_GET_TIMESTAMP_CORRECTIONS);
+	MCDI_SET_DWORD(inbuf, PTP_IN_PERIPH_ID, 0);
+
+	rc = efct_mcdi_rpc_quiet(efct, MC_CMD_PTP, inbuf, sizeof(inbuf),
+				 outbuf, sizeof(outbuf), &out_len);
+	if (rc == 0) {
+		efct->ptp_data->ts_corrections.ptp_tx =
+			MCDI_DWORD(outbuf,
+				   PTP_OUT_GET_TIMESTAMP_CORRECTIONS_V2_PTP_TX);
+		efct->ptp_data->ts_corrections.ptp_rx =
+			MCDI_DWORD(outbuf, PTP_OUT_GET_TIMESTAMP_CORRECTIONS_V2_PTP_RX);
+		efct->ptp_data->ts_corrections.pps_out =
+			MCDI_DWORD(outbuf, PTP_OUT_GET_TIMESTAMP_CORRECTIONS_V2_PPS_OUT);
+		efct->ptp_data->ts_corrections.pps_in =
+			MCDI_DWORD(outbuf, PTP_OUT_GET_TIMESTAMP_CORRECTIONS_V2_PPS_IN);
+
+		if (out_len >= MC_CMD_PTP_OUT_GET_TIMESTAMP_CORRECTIONS_V2_LEN) {
+			efct->ptp_data->ts_corrections.general_tx =
+				MCDI_DWORD(outbuf, PTP_OUT_GET_TIMESTAMP_CORRECTIONS_V2_GENERAL_TX);
+			efct->ptp_data->ts_corrections.general_rx =
+				MCDI_DWORD(outbuf, PTP_OUT_GET_TIMESTAMP_CORRECTIONS_V2_GENERAL_RX);
+		} else {
+			efct->ptp_data->ts_corrections.general_tx =
+				efct->ptp_data->ts_corrections.ptp_tx;
+			efct->ptp_data->ts_corrections.general_rx =
+				efct->ptp_data->ts_corrections.ptp_rx;
+		}
+	} else {
+		efct_mcdi_display_error(efct, MC_CMD_PTP, sizeof(inbuf), outbuf,
+					sizeof(outbuf), rc);
+		return rc;
+	}
+
+	return 0;
+}
+
+int efct_ptp_hw_pps_enable(struct efct_nic *efct, bool enable)
+{
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_PTP_IN_PPS_ENABLE_LEN);
+	struct efct_pps_data *pps_data;
+	int rc;
+
+	if (!efct->ptp_data)
+		return -ENOTTY;
+
+	if (!efct->ptp_data->pps_data)
+		return -ENOTTY;
+
+	pps_data = efct->ptp_data->pps_data;
+
+	MCDI_SET_DWORD(inbuf, PTP_IN_OP, MC_CMD_PTP_OP_PPS_ENABLE);
+	MCDI_SET_DWORD(inbuf, PTP_IN_PERIPH_ID, 0);
+	MCDI_SET_DWORD(inbuf, PTP_IN_PPS_ENABLE_OP,
+		       enable ? MC_CMD_PTP_ENABLE_PPS :
+				MC_CMD_PTP_DISABLE_PPS);
+	rc = efct_mcdi_rpc(efct, MC_CMD_PTP, inbuf, sizeof(inbuf),
+			   NULL, 0, NULL);
+
+	if (rc && rc != -MC_CMD_ERR_EALREADY)
+		return rc;
+
+	if (enable) {
+		memset(&pps_data->s_delta, 0x0, sizeof(pps_data->s_delta));
+		memset(&pps_data->s_assert, 0x0, sizeof(pps_data->s_assert));
+		memset(&pps_data->n_assert, 0x0, sizeof(pps_data->n_assert));
+	}
+	pps_data->nic_hw_pps_enabled = enable;
+
+	return 0;
+}
+
+static void efct_ptp_pps_worker(struct work_struct *work)
+{
+	struct ptp_clock_event ptp_evt;
+	struct efct_ptp_data *ptp;
+	struct efct_nic *efct;
+
+	ptp = container_of(work, struct efct_ptp_data, pps_work);
+	efct = (ptp ? ptp->efct : NULL);
+	if (!ptp || !efct || !ptp->pps_workwq)
+		return;
+	ptp_data_get(ptp);
+
+	if (efct_ptp_synchronize(efct, PTP_SYNC_SAMPLE, true))
+		goto out;
+
+	if (ptp->usr_evt_enabled & (1 << PTP_CLK_REQ_PPS)) {
+		ptp_evt.type = PTP_CLOCK_PPSUSR;
+		ptp_evt.pps_times = ptp->host_time_pps;
+		ptp_clock_event(ptp->phc_clock, &ptp_evt);
+	}
+out:
+	ptp_data_put(ptp);
+}
+
+static void efct_remove_pps_workqueue(struct efct_ptp_data *ptp_data)
+{
+	struct workqueue_struct *pps_workwq = ptp_data->pps_workwq;
+
+	ptp_data->pps_workwq = NULL; /* tells worker to do nothing */
+	if (!pps_workwq)
+		return;
+	cancel_work_sync(&ptp_data->pps_work);
+	destroy_workqueue(pps_workwq);
+}
+
+static int efct_create_pps_workqueue(struct efct_ptp_data *ptp)
+{
+	struct efct_device *efct;
+	char busdevice[11];
+
+	efct = ptp->efct->efct_dev;
+
+	snprintf(busdevice, sizeof(busdevice), "%04x:%02x:%02x",
+		 pci_domain_nr(efct->pci_dev->bus),
+		 efct->pci_dev->bus->number,
+		 efct->pci_dev->devfn);
+
+	INIT_WORK(&ptp->pps_work, efct_ptp_pps_worker);
+	ptp->pps_workwq = alloc_workqueue("efct_pps_%s", WQ_UNBOUND |
+					  WQ_MEM_RECLAIM | WQ_SYSFS, 1,
+					  busdevice);
+	if (!ptp->pps_workwq)
+		return -ENOMEM;
+	return 0;
+}
+
+static int efct_ptp_create_pps(struct efct_ptp_data *ptp, int index)
+{
+	struct pps_source_info info;
+	struct efct_pps_data *pps;
+
+	pps = kzalloc(sizeof(*pps), GFP_KERNEL);
+	if (!pps)
+		return -ENOMEM;
+
+	pps->nic_hw_pps_enabled = false;
+
+	pps->ptp = ptp;
+	ptp->pps_data = pps;
+	memset(&info, 0, sizeof(struct pps_source_info));
+	snprintf(info.name, PPS_MAX_NAME_LEN, "ptp%d.ext", index);
+	info.mode = PPS_CAPTUREASSERT | PPS_OFFSETASSERT | PPS_CANWAIT |
+			PPS_TSFMT_TSPEC,
+	info.echo         = NULL,
+	info.owner       = THIS_MODULE,
+	pps->device = pps_register_source(&info, PPS_CAPTUREASSERT | PPS_OFFSETASSERT);
+	if (IS_ERR(pps->device))
+		goto fail1;
+	if (efct_ptp_hw_pps_enable(ptp->efct, true))
+		goto fail2;
+
+	return 0;
+
+fail2:
+	pps_unregister_source(pps->device);
+fail1:
+	kfree(pps);
+	ptp->pps_data = NULL;
+
+	return -ENOMEM;
+}
+
+static void efct_ptp_destroy_pps(struct efct_ptp_data *ptp)
+{
+	if (!ptp->pps_data)
+		return;
+
+	ptp->usr_evt_enabled = 0;
+	if (ptp->pps_data->device) {
+		efct_ptp_hw_pps_enable(ptp->efct, false);
+		pps_unregister_source(ptp->pps_data->device);
+		ptp->pps_data->device = NULL;
+	}
+
+	kfree(ptp->pps_data);
+	ptp->pps_data = NULL;
+}
+
+static int efct_phc_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
+{
+	MCDI_DECLARE_BUF(inadj, MC_CMD_PTP_IN_ADJUST_V2_LEN);
+	struct efct_ptp_data *ptp_data;
+	struct efct_nic *efct;
+	s64 adjustment_ns;
+	s64 ppb;
+	int rc;
+
+	ptp_data = container_of(ptp, struct efct_ptp_data, phc_clock_info);
+	efct = ptp_data->efct;
+
+	ppb = scaled_ppm_to_ppb(scaled_ppm);
+	/* Convert ppb to fixed point ns taking care to round correctly. */
+	adjustment_ns =
+		((s64)ppb * PPB_SCALE_WORD + (1 << (ptp_data->adjfreq_ppb_shift - 1)))
+			 >> ptp_data->adjfreq_ppb_shift;
+
+	MCDI_SET_DWORD(inadj, PTP_IN_OP, MC_CMD_PTP_OP_ADJUST);
+	MCDI_SET_DWORD(inadj, PTP_IN_PERIPH_ID, 0);
+	MCDI_SET_QWORD(inadj, PTP_IN_ADJUST_V2_FREQ, adjustment_ns);
+	MCDI_SET_DWORD(inadj, PTP_IN_ADJUST_V2_MAJOR_HI, 0);
+	MCDI_SET_DWORD(inadj, PTP_IN_ADJUST_V2_MAJOR, 0);
+	MCDI_SET_DWORD(inadj, PTP_IN_ADJUST_V2_MINOR, 0);
+	rc = efct_mcdi_rpc(efct, MC_CMD_PTP, inadj, sizeof(inadj),
+			   NULL, 0, NULL);
+	if (rc != 0)
+		return rc;
+
+	ptp_data->current_adjfreq = adjustment_ns;
+	return 0;
+}
+
+static int efct_adjtime(struct ptp_clock_info *ptp, u32 nic_major_hi, u32 nic_major, u32 nic_minor)
+{
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_PTP_IN_ADJUST_V2_LEN);
+	struct efct_ptp_data *ptp_data;
+	struct efct_nic *efct;
+	int rc;
+
+	ptp_data = container_of(ptp, struct efct_ptp_data, phc_clock_info);
+	efct = ptp_data->efct;
+	ptp_data->last_delta_valid = false;
+	MCDI_SET_DWORD(inbuf, PTP_IN_OP, MC_CMD_PTP_OP_ADJUST);
+	MCDI_SET_DWORD(inbuf, PTP_IN_PERIPH_ID, 0);
+	MCDI_SET_QWORD(inbuf, PTP_IN_ADJUST_V2_FREQ, ptp_data->current_adjfreq);
+	MCDI_SET_DWORD(inbuf, PTP_IN_ADJUST_V2_MAJOR_HI, nic_major_hi);
+	MCDI_SET_DWORD(inbuf, PTP_IN_ADJUST_V2_MAJOR, nic_major);
+	MCDI_SET_DWORD(inbuf, PTP_IN_ADJUST_V2_MINOR, nic_minor);
+	rc = efct_mcdi_rpc(efct, MC_CMD_PTP, inbuf, sizeof(inbuf), NULL, 0, NULL);
+
+	if (!rc)
+		return rc;
+	rc = efct_ptp_synchronize(efct, PTP_SYNC_SAMPLE, true);
+
+	return rc;
+}
+
+static int efct_phc_adjtime(struct ptp_clock_info *ptp, s64 delta)
+{
+	u32 nic_major, nic_minor, nic_major_hi;
+	struct efct_ptp_data *ptp_data;
+	struct efct_nic *efct;
+
+	ptp_data = container_of(ptp, struct efct_ptp_data, phc_clock_info);
+	efct = ptp_data->efct;
+	ptp_data->last_delta_valid = false;
+	efct->ptp_data->ns_to_nic_time(delta, &nic_major, &nic_minor, &nic_major_hi);
+	return efct_adjtime(ptp, nic_major_hi, nic_major, nic_minor);
+}
+
+static int efct_phc_gettime64(struct ptp_clock_info *ptp, struct timespec64 *ts)
+{
+	struct efct_ptp_data *ptp_data;
+	struct efct_nic *efct;
+	u64 timer_l, timer_l2;
+	u32 timer_h;
+	ktime_t kt;
+	int rc;
+
+	ptp_data = container_of(ptp, struct efct_ptp_data, phc_clock_info);
+	efct = ptp_data->efct;
+	rc = efct_mcdi_ptp_read_nic_time(efct, &timer_h, &timer_l);
+	if (rc)
+		return rc;
+	timer_l2 = efct_ptp_time(efct);
+	if (unlikely((timer_l >> TIME_TO_SEC_SHIFT) > (timer_l2 >> TIME_TO_SEC_SHIFT))) {
+		/* Read time again if lower 32 bit of seconds wrap. */
+		rc = efct_mcdi_ptp_read_nic_time(efct, &timer_h, NULL);
+		if (rc)
+			return rc;
+		timer_l2 = efct_ptp_time(efct);
+	}
+
+	kt = ptp_data->nic64_to_kernel_time(timer_h, timer_l2, 0);
+	*ts = ktime_to_timespec64(kt);
+
+	return 0;
+}
+
+static int efct_phc_gettimex64(struct ptp_clock_info *ptp, struct timespec64 *ts,
+			       struct ptp_system_timestamp *sts)
+{
+	struct efct_ptp_data *ptp_data;
+	u32 timer_h, timer_h1;
+	struct efct_nic *efct;
+	u64 timer_l;
+	ktime_t kt;
+	int rc;
+
+	ptp_data = container_of(ptp, struct efct_ptp_data, phc_clock_info);
+	efct = ptp_data->efct;
+	rc = efct_mcdi_ptp_read_nic_time(efct, &timer_h, NULL);
+	if (rc)
+		return rc;
+	ptp_read_system_prets(sts);
+	timer_l = efct_ptp_time(efct);
+	ptp_read_system_postts(sts);
+	rc =  efct_mcdi_ptp_read_nic_time(efct, &timer_h1, NULL);
+	if (rc)
+		return rc;
+	if (timer_h1 != timer_h) {
+		ptp_read_system_prets(sts);
+		timer_l = efct_ptp_time(efct);
+		ptp_read_system_postts(sts);
+	}
+
+	kt = ptp_data->nic64_to_kernel_time(timer_h1, timer_l, 0);
+	*ts = ktime_to_timespec64(kt);
+
+	return 0;
+}
+
+static int efct_phc_getcrosststamp(struct ptp_clock_info *ptp,
+				   struct system_device_crosststamp *cts)
+{
+	struct system_time_snapshot snap;
+	struct efct_ptp_data *ptp_data;
+	struct efct_nic *efct;
+
+	ptp_data = container_of(ptp, struct efct_ptp_data, phc_clock_info);
+	efct = ptp_data->efct;
+	efct_ptp_synchronize(efct, PTP_SYNC_SAMPLE, true);
+	ktime_get_snapshot(&snap);
+	cts->device = ktime_add(snap.real, timespec64_to_ktime(ptp_data->last_delta));
+	cts->sys_realtime = snap.real;
+	cts->sys_monoraw = snap.raw;
+
+	return 0;
+}
+
+static int efct_phc_settime64(struct ptp_clock_info *p, const struct timespec64 *ts)
+{
+	u32 nic_major, nic_minor, nic_major_hi;
+	struct efct_ptp_data *ptp_data;
+	struct timespec64 time_now;
+	struct timespec64 delta;
+	struct efct_nic *efct;
+	int rc;
+
+	ptp_data = container_of(p, struct efct_ptp_data, phc_clock_info);
+	efct = ptp_data->efct;
+	rc = efct_phc_gettime64(p, &time_now);
+	if (rc != 0)
+		return rc;
+	delta = timespec64_sub(*ts, time_now);
+	nic_major_hi = delta.tv_sec >> TIME_TO_SEC_SHIFT;
+	nic_major = (u32)delta.tv_sec;
+	nic_minor = (u32)delta.tv_nsec << efct->efct_dev->params.ts_subnano_bit;
+	rc = efct_adjtime(p, nic_major_hi, nic_major, nic_minor);
+	if (rc != 0)
+		return rc;
+
+	return 0;
+}
+
+static int efct_setup_pps_worker(struct efct_ptp_data *ptp, int enable)
+{
+	int rc = 0;
+
+	if (enable && !ptp->pps_workwq) {
+		rc = efct_create_pps_workqueue(ptp);
+		if (rc < 0)
+			goto err;
+	} else if (!enable && ptp->pps_workwq) {
+		efct_remove_pps_workqueue(ptp);
+	}
+err:
+	return rc;
+}
+
+static int efct_phc_enable(struct ptp_clock_info *ptp,
+			   struct ptp_clock_request *request,
+			   int enable)
+{
+	struct efct_ptp_data *ptp_data = container_of(ptp,
+						     struct efct_ptp_data,
+						     phc_clock_info);
+	int rc = 0;
+
+	switch (request->type) {
+	case PTP_CLK_REQ_EXTTS:
+		if (ptp->pin_config[0].func != PTP_PF_EXTTS)
+			enable = false;
+		if (enable)
+			ptp_data->usr_evt_enabled |= (1 << request->type);
+		else
+			ptp_data->usr_evt_enabled &= ~(1 << request->type);
+		break;
+
+	case PTP_CLK_REQ_PPS:
+		rc = efct_setup_pps_worker(ptp_data, enable);
+		if (rc < 0)
+			goto err;
+		if (enable)
+			ptp_data->usr_evt_enabled |= (1 << request->type);
+		else
+			ptp_data->usr_evt_enabled &= ~(1 << request->type);
+		break;
+	default:
+		rc = -EOPNOTSUPP;
+		goto err;
+	}
+	return 0;
+err:
+	return rc;
+}
+
+static int efct_phc_verify(struct ptp_clock_info *ptp, unsigned int pin,
+			   enum ptp_pin_function func, unsigned int chan)
+{
+	switch (func) {
+	case PTP_PF_NONE:
+	case PTP_PF_EXTTS:
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static const struct ptp_clock_info efct_phc_clock_info = {
+	.owner		= THIS_MODULE,
+	.name		= "efct",
+	.max_adj	= MAX_PPB, /* unused, ptp_data->max_adjfreq used instead */
+	.n_alarm	= 0,
+	.n_ext_ts	= 1,
+	.n_pins		= 1,
+	.n_per_out	= 0,
+	.pps		= 1,
+	.adjfine	= efct_phc_adjfine,
+	.adjtime	= efct_phc_adjtime,
+	.gettimex64	= efct_phc_gettimex64,
+	.settime64	= efct_phc_settime64,
+	.getcrosststamp = efct_phc_getcrosststamp,
+	.enable		= efct_phc_enable,
+	.verify		= efct_phc_verify,
+};
+
+static void efct_associate_phc(struct efct_nic *efct, unsigned char *serial)
+{
+	struct efct_ptp_data *other, *next;
+
+	if (efct->phc_ptp_data) {
+		netif_err(efct, drv, efct->net_dev,
+			  "PHC already associated. It can be a bug in driver\n");
+		return;
+	}
+	spin_lock(&efct_phcs_list_lock);
+
+	list_for_each_entry_safe(other, next, &efct_phcs_list,
+				 phcs_node) {
+		if (!strncmp(other->serial,  serial, EFCT_MAX_VERSION_INFO_LEN)) {
+			efct->phc_ptp_data = other;
+			ptp_data_get(other);
+			goto out;
+		}
+	}
+
+	efct->phc_ptp_data = efct->ptp_data;
+	list_add(&efct->phc_ptp_data->phcs_node, &efct_phcs_list);
+
+out:
+	spin_unlock(&efct_phcs_list_lock);
+}
+
+static void efct_dissociate_phc(struct efct_nic *efct)
+{
+	if (!efct->phc_ptp_data)
+		return;
+
+	if (efct->ptp_data == efct->phc_ptp_data) {
+		spin_lock(&efct_phcs_list_lock);
+		list_del(&efct->ptp_data->phcs_node);
+		spin_unlock(&efct_phcs_list_lock);
+	} else {
+		ptp_data_put(efct->phc_ptp_data);
+		efct->phc_ptp_data = NULL;
+	}
+}
+
+static int efct_get_board_serial(struct efct_nic *efct, u8 *serial)
+{
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_GET_VERSION_EXT_IN_LEN);
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_VERSION_V5_OUT_LEN);
+	size_t outlength;
+	const char *str;
+	u32 flags;
+	int rc;
+
+	rc = efct_mcdi_rpc(efct, MC_CMD_GET_VERSION, inbuf, sizeof(inbuf),
+			   outbuf, sizeof(outbuf), &outlength);
+	if (rc || outlength < MC_CMD_GET_VERSION_V5_OUT_LEN)
+		return -EINVAL;
+		/* Handle V2 additions */
+	flags = MCDI_DWORD(outbuf, GET_VERSION_V5_OUT_FLAGS);
+	if (!(flags & BIT(MC_CMD_GET_VERSION_V5_OUT_BOARD_EXT_INFO_PRESENT_LBN)))
+		return -EINVAL;
+
+	str = MCDI_PTR(outbuf, GET_VERSION_V5_OUT_BOARD_SERIAL);
+	strscpy(serial, str, EFCT_MAX_VERSION_INFO_LEN);
+
+	return rc;
+}
+
+int efct_ptp_probe_setup(struct efct_nic *efct)
+{
+	unsigned char serial[EFCT_MAX_VERSION_INFO_LEN];
+	struct efct_ptp_data *ptp;
+	struct ptp_pin_desc *ppd;
+	int rc;
+
+	rc = 0;
+	ptp = ptp_data_alloc(GFP_KERNEL);
+	if (IS_ERR(ptp))
+		return PTR_ERR(ptp);
+	efct->ptp_data = ptp;
+	ptp->efct = efct;
+	rc = efct_get_board_serial(efct, serial);
+	if (rc) {
+		pr_err("Failed to get PTP UID, rc=%d", rc);
+		goto fail1;
+	}
+	efct_associate_phc(efct, serial);
+	strscpy(ptp->serial, serial, EFCT_MAX_VERSION_INFO_LEN);
+	ptp->config.flags = 0;
+	ptp->config.tx_type = HWTSTAMP_TX_OFF;
+	ptp->config.rx_filter = HWTSTAMP_FILTER_NONE;
+	rc = efct_ptp_get_attributes(efct);
+	if (rc < 0)
+		goto fail2;
+
+	/* Get the timestamp corrections */
+	rc = efct_ptp_get_timestamp_corrections(efct);
+	if (rc < 0)
+		goto fail2;
+	if (efct_phc_exposed(efct)) {
+		efct_ptp_start(efct);
+		ptp->phc_clock_info = efct_phc_clock_info;
+		ptp->phc_clock_info.max_adj = ptp->max_adjfreq;
+		ppd = &ptp->pin_config[0];
+		snprintf(ppd->name, sizeof(ppd->name), "pps0");
+		ppd->index = 0;
+		ppd->func = PTP_PF_EXTTS;
+		ptp->phc_clock_info.pin_config = ptp->pin_config;
+		ptp->phc_clock = ptp_clock_register(&ptp->phc_clock_info,
+						    &efct->efct_dev->pci_dev->dev);
+		if (IS_ERR(ptp->phc_clock)) {
+			rc = PTR_ERR(ptp->phc_clock);
+			goto fail2;
+		}
+		rc = efct_ptp_create_pps(ptp, ptp_clock_index(ptp->phc_clock));
+		if (rc < 0)
+			pci_err(efct->efct_dev->pci_dev, "PPS not enabled\n");
+	}
+	return 0;
+fail2:
+	efct_dissociate_phc(efct);
+fail1:
+	ptp_data_del(ptp);
+	efct->ptp_data = NULL;
+	return rc;
+}
+
+void efct_ptp_remove_setup(struct efct_nic *efct)
+{
+	struct efct_ptp_data *ptp;
+
+	ptp = efct->ptp_data;
+	if (efct_phc_exposed(efct)) {
+		efct_ptp_destroy_pps(ptp);
+		efct_remove_pps_workqueue(ptp);
+		efct_ptp_stop(efct);
+	}
+
+	if (ptp->phc_clock)
+		ptp_clock_unregister(ptp->phc_clock);
+	ptp->phc_clock = NULL;
+
+	efct_dissociate_phc(efct);
+	ptp_data_del(ptp);
+}
+
+int efct_ptp_get_ts_config(struct net_device *net_dev, struct ifreq *ifr)
+{
+	struct efct_nic *efct;
+
+	efct = efct_netdev_priv(net_dev);
+	if (!efct->ptp_data)
+		return -EOPNOTSUPP;
+
+	return copy_to_user(ifr->ifr_data, &efct->ptp_data->config,
+			    sizeof(efct->ptp_data->config)) ? -EFAULT : 0;
+}
+
+void efct_ptp_get_ts_info(struct efct_nic *efct, struct ethtool_ts_info *ts_info)
+{
+	struct efct_ptp_data *phc_ptp = efct->phc_ptp_data;
+
+	ASSERT_RTNL();
+
+	if (!phc_ptp)
+		return;
+
+	ts_info->so_timestamping |= (SOF_TIMESTAMPING_TX_HARDWARE |
+				     SOF_TIMESTAMPING_RX_HARDWARE |
+				     SOF_TIMESTAMPING_RAW_HARDWARE);
+
+	if (phc_ptp->phc_clock)
+		ts_info->phc_index = ptp_clock_index(phc_ptp->phc_clock);
+	ts_info->tx_types = 1 << HWTSTAMP_TX_OFF | 1 << HWTSTAMP_TX_ON;
+	ts_info->rx_filters = phc_ptp->efct->type->hwtstamp_filters;
+}
+
+int efct_ptp_subscribe_timesync(struct efct_ev_queue *eventq)
+{
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_PTP_IN_TIME_EVENT_SUBSCRIBE_LEN);
+	int rc;
+
+	if (eventq->sync_events_state == SYNC_EVENTS_REQUESTED ||
+	    eventq->sync_events_state == SYNC_EVENTS_VALID)
+		return 0;
+	eventq->sync_events_state = SYNC_EVENTS_REQUESTED;
+	MCDI_SET_DWORD(inbuf, PTP_IN_OP, MC_CMD_PTP_OP_TIME_EVENT_SUBSCRIBE);
+	MCDI_SET_DWORD(inbuf, PTP_IN_PERIPH_ID, 0);
+	MCDI_POPULATE_DWORD_2(inbuf, PTP_IN_TIME_EVENT_SUBSCRIBE_QUEUE,
+			      PTP_IN_TIME_EVENT_SUBSCRIBE_QUEUE_ID, eventq->index,
+			      PTP_IN_TIME_EVENT_SUBSCRIBE_REPORT_SYNC_STATUS, 1);
+	rc = efct_mcdi_rpc(eventq->efct, MC_CMD_PTP, inbuf, sizeof(inbuf), NULL, 0, NULL);
+	if (rc != 0) {
+		netif_err(eventq->efct, drv, eventq->efct->net_dev,
+			  "Time sync event subscribe failed\n");
+		return rc;
+	}
+
+	return rc;
+}
+
+int efct_ptp_unsubscribe_timesync(struct efct_ev_queue *eventq)
+{
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_PTP_IN_TIME_EVENT_UNSUBSCRIBE_LEN);
+	int rc;
+
+	if (eventq->sync_events_state == SYNC_EVENTS_DISABLED)
+		return 0;
+	eventq->sync_events_state =  SYNC_EVENTS_DISABLED;
+
+	MCDI_SET_DWORD(inbuf, PTP_IN_OP, MC_CMD_PTP_OP_TIME_EVENT_UNSUBSCRIBE);
+	MCDI_SET_DWORD(inbuf, PTP_IN_PERIPH_ID, 0);
+	MCDI_SET_DWORD(inbuf, PTP_IN_TIME_EVENT_UNSUBSCRIBE_CONTROL,
+		       MC_CMD_PTP_IN_TIME_EVENT_UNSUBSCRIBE_SINGLE);
+	MCDI_SET_DWORD(inbuf, PTP_IN_TIME_EVENT_UNSUBSCRIBE_QUEUE,
+		       eventq->index);
+
+	rc = efct_mcdi_rpc(eventq->efct, MC_CMD_PTP, inbuf, sizeof(inbuf), NULL, 0, NULL);
+
+	return rc;
+}
+
+int efct_ptp_tx_ts_event(struct efct_nic *efct, bool flag)
+{
+	struct efct_ev_queue *eventq;
+	int eidx, rc;
+	int k;
+
+	for_each_set_bit(k, &efct->txq_active_mask, efct->max_txq_count) {
+		eidx = efct->txq[k].evq_index;
+		eventq = &efct->evq[eidx];
+		if (eventq->type != EVQ_T_TX)
+			continue;
+		if (flag) {
+			rc = efct_ptp_subscribe_timesync(eventq);
+			if (rc)
+				goto fail;
+		} else {
+			rc = efct_ptp_unsubscribe_timesync(eventq);
+		}
+	}
+	return 0;
+fail:
+	for_each_set_bit(k, &efct->txq_active_mask, efct->max_txq_count) {
+		eidx = efct->txq[k].evq_index;
+		eventq = &efct->evq[k];
+		if (eventq->type != EVQ_T_TX)
+			continue;
+
+		efct_ptp_unsubscribe_timesync(&efct->evq[k]);
+	}
+	return rc;
+}
+
+int efct_ptp_enable_ts(struct efct_nic *efct, struct hwtstamp_config *init)
+{
+	struct efct_ptp_data *ptp;
+	int rc = 0;
+
+	ptp = efct->ptp_data;
+	switch (init->tx_type) {
+	case HWTSTAMP_TX_OFF:
+		if (ptp->txtstamp) {
+			ptp->txtstamp = false;
+			mutex_lock(&efct->state_lock);
+			if (efct->state == STATE_NET_UP)
+				efct_ptp_tx_ts_event(efct, false);
+			mutex_unlock(&efct->state_lock);
+		}
+		break;
+	case HWTSTAMP_TX_ON:
+		if (!ptp->txtstamp) {
+			ptp->txtstamp = true;
+			mutex_lock(&efct->state_lock);
+			if (efct->state == STATE_NET_UP)
+				efct_ptp_tx_ts_event(efct, true);
+			mutex_unlock(&efct->state_lock);
+		}
+		break;
+	default:
+		return -ERANGE;
+	}
+
+	switch (init->rx_filter) {
+	case HWTSTAMP_FILTER_NONE:
+		if (ptp->rxtstamp) {
+			ptp->rxtstamp = false;
+
+			init->rx_filter = HWTSTAMP_FILTER_NONE;
+		}
+		break;
+	case HWTSTAMP_FILTER_ALL:
+	case HWTSTAMP_FILTER_PTP_V1_L4_EVENT:
+	case HWTSTAMP_FILTER_PTP_V1_L4_SYNC:
+	case HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ:
+	case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
+	case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
+	case HWTSTAMP_FILTER_PTP_V2_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
+		if (!ptp->rxtstamp) {
+			init->rx_filter = HWTSTAMP_FILTER_ALL;
+			ptp->rxtstamp = true;
+		}
+		break;
+	default:
+		return -ERANGE;
+	}
+
+	efct_ptp_synchronize(efct, PTP_SYNC_SAMPLE, true);
+
+	return rc;
+}
+
+int efct_ptp_set_ts_config(struct net_device *net_dev, struct ifreq *ifr)
+{
+	struct hwtstamp_config config;
+	struct efct_nic *efct;
+	int rc;
+
+	efct = efct_netdev_priv(net_dev);
+	/* Not a PTP enabled port */
+	if (!efct->ptp_data)
+		return -EOPNOTSUPP;
+
+	if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
+		return -EFAULT;
+
+	if (config.flags)
+		return -EINVAL;
+
+	rc = efct->type->ptp_set_ts_config(efct, &config);
+	if (rc != 0)
+		return rc;
+	efct->ptp_data->config = config;
+	return copy_to_user(ifr->ifr_data, &config, sizeof(config))
+		? -EFAULT : 0;
+}
+
+static void hw_pps_event_pps(struct efct_nic *efct, struct efct_ptp_data *ptp)
+{
+	struct efct_pps_data *pps;
+	struct pps_event_time ts;
+
+	pps = efct->ptp_data->pps_data;
+	if (!pps)
+		return;
+	pps->n_assert = ptp->nic_to_kernel_time(EFCT_QWORD_FIELD(ptp->evt_frags[0],
+						MCDI_EVENT_DATA),
+						EFCT_QWORD_FIELD(ptp->evt_frags[1],
+								 MCDI_EVENT_DATA),
+						ptp->ts_corrections.pps_in);
+
+	if (pps->nic_hw_pps_enabled) {
+		pps->s_assert = timespec64_sub(ktime_to_timespec64(pps->n_assert),
+					       pps->ptp->last_delta);
+		pps->s_delta = pps->ptp->last_delta;
+		pps->last_ev++;
+
+		if (pps->device) {
+			ts.ts_real = ktime_to_timespec64(pps->n_assert);
+			pps_event(pps->device, &ts, PPS_CAPTUREASSERT, NULL);
+		}
+	}
+	ptp->sw_stats.pps_hw++;
+}
+
+static void ptp_event_pps(struct efct_nic *efct, struct efct_ptp_data *ptp)
+{
+	struct ptp_clock_event ptp_evt;
+	struct efct_pps_data *pps;
+
+	pps = ptp->pps_data;
+	if (!pps)
+		return;
+	if (ptp->usr_evt_enabled & (1 << PTP_CLK_REQ_EXTTS)) {
+		pps->n_assert = ptp->nic_to_kernel_time
+			(EFCT_QWORD_FIELD(ptp->evt_frags[0], MCDI_EVENT_DATA),
+			 EFCT_QWORD_FIELD(ptp->evt_frags[1], MCDI_EVENT_DATA),
+			 ptp->ts_corrections.pps_in);
+
+		ptp_evt.type = PTP_CLOCK_EXTTS;
+		ptp_evt.index = 0;
+		ptp_evt.timestamp = ktime_to_ns(pps->n_assert);
+		ptp_clock_event(ptp->phc_clock, &ptp_evt);
+	}
+
+	if (efct && ptp->pps_workwq)
+		queue_work(ptp->pps_workwq, &ptp->pps_work);
+	ptp->sw_stats.pps_fw++;
+}
+
+void efct_ptp_event(struct efct_nic *efct, union efct_qword *ev)
+{
+	struct efct_ptp_data *ptp;
+	int code;
+
+	code = EFCT_QWORD_FIELD(*ev, MCDI_EVENT_CODE);
+	ptp = efct->phc_ptp_data;
+	if (ptp->evt_frag_idx == 0) {
+		ptp->evt_code = code;
+	} else if (ptp->evt_code != code) {
+		netif_err(efct, hw, efct->net_dev,
+			  "PTP out of sequence event %d\n", code);
+		ptp->evt_frag_idx = 0;
+	}
+	efct = ptp->efct;
+	ptp->evt_frags[ptp->evt_frag_idx++] = *ev;
+	if (!MCDI_EVENT_FIELD(*ev, CONT)) {
+		/* Process resulting event */
+		switch (code) {
+		case MCDI_EVENT_CODE_PTP_PPS:
+			ptp_event_pps(efct, ptp);
+			break;
+		case MCDI_EVENT_CODE_HW_PPS:
+			hw_pps_event_pps(efct, ptp);
+			break;
+		default:
+			netif_err(efct, hw, efct->net_dev,
+				  "PTP unknown event %d\n", code);
+			break;
+		}
+		ptp->evt_frag_idx = 0;
+	} else if (ptp->evt_frag_idx == MAX_EVENT_FRAGS) {
+		netif_err(efct, hw, efct->net_dev,
+			  "PTP too many event fragments\n");
+		ptp->evt_frag_idx = 0;
+	}
+}
+
diff --git a/drivers/net/ethernet/amd/efct/efct_ptp.h b/drivers/net/ethernet/amd/efct/efct_ptp.h
new file mode 100644
index 000000000000..5629eed09bdb
--- /dev/null
+++ b/drivers/net/ethernet/amd/efct/efct_ptp.h
@@ -0,0 +1,186 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/****************************************************************************
+ * Driver for AMD/Xilinx network controllers and boards
+ * Copyright (C) 2021, Xilinx, Inc.
+ * Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
+ */
+
+#ifndef EFCT_PTP_H
+#define EFCT_PTP_H
+
+#include <linux/net_tstamp.h>
+#include <linux/pps_kernel.h>
+#include <linux/ptp_clock_kernel.h>
+#include "efct_driver.h"
+#include "efct_bitfield.h"
+
+/* Maximum number of events expected to make up a PTP event */
+#define	MAX_EVENT_FRAGS			3
+/**
+ * struct efct_ptp_data - Precision Time Protocol (PTP) state
+ * @efct: The NIC context
+ * @phcs_node: Node in list of all PHC PTP data
+ * @kref: Reference count.
+ * @config: Current timestamp configuration
+ * @enabled: PTP operation enabled. If this is disabled normal timestamping
+ *	     can still work.
+ * @txtstamp: Enable Tx side PTP timestamping
+ * @rxtstamp: Enable Rx side PTP timestamping
+ * @evt_lock: Lock for manipulating evt_list and evt_free_list
+ * @evt_frags: Partly assembled PTP events
+ * @evt_frag_idx: Current fragment number
+ * @evt_code: Last event code
+ * @adapter_base_addr: MAC address of port0 (used as unique identifier) of PHC
+ * @mode: Mode in which PTP operating (PTP version)
+ * @ns_to_nic_time: Function to convert from scalar nanoseconds to NIC time
+ * @nic_to_kernel_time: Function to convert from NIC 32 bit wide second to kernel time
+ * @nic64_to_kernel_time: Function to convert from NIC 64 bit wide second to kernel time
+ * @capabilities: Capabilities flags from the NIC
+ * @rx_ts_inline: Flag for whether RX timestamps are inline (else they are
+ *	separate events)
+ * @evt_list: List of MC receive events awaiting packets
+ * @rx_evts: Instantiated events (on evt_list and evt_free_list)
+ * @workwq: Work queue for processing pending PTP operations
+ * @work: Work task
+ * @reset_required: A serious error has occurred and the PTP task needs to be
+ *                  reset (disable, enable).
+ * @ts_corrections.ptp_tx: Required driver correction of PTP packet transmit
+ *                         timestamps
+ * @ts_corrections.ptp_rx: Required driver correction of PTP packet receive
+ *                         timestamps
+ * @ts_corrections.pps_out: PPS output error (information only)
+ * @ts_corrections.pps_in: Required driver correction of PPS input timestamps
+ * @ts_corrections.general_tx: Required driver correction of general packet
+ *                             transmit timestamps
+ * @ts_corrections.general_rx: Required driver correction of general packet
+ *                             receive timestamps
+ * @nic_time.minor_max: Wrap point for NIC minor times
+ * @nic_time.sync_event_diff_min: Minimum acceptable difference between time
+ * in packet prefix and last MCDI time sync event i.e. how much earlier than
+ * the last sync event time a packet timestamp can be.
+ * @nic_time.sync_event_diff_max: Maximum acceptable difference between time
+ * in packet prefix and last MCDI time sync event i.e. how much later than
+ * the last sync event time a packet timestamp can be.
+ * @nic_time.sync_event_minor_shift: Shift required to make minor time from
+ * field in MCDI time sync event.
+ * @pps_work: pps work task for handling pps events
+ * @pps_workwq: pps work queue
+ * @phc_clock: Pointer to registered phc device
+ * @phc_clock_info: Registration structure for phc device
+ * @adjfreq_ppb_shift: Shift required to convert scaled parts-per-billion
+ * @pps_data: Data associated with optional HW PPS events
+ * @max_adjfreq: Current ppb adjustment, lives here instead of phc_clock_info as
+ *		 it must be accessible without PHC support, using private ioctls.
+ * @current_adjfreq: Current ppb adjustment.
+ * @pin_config: PTP pin functions description
+ * @last_delta_valid: Boolean
+ * @last_delta: Clock difference between nic and host
+ * @host_time_pps: Host time at last PPS
+ * @usr_evt_enabled: Flag indicating how NIC generated TS events are handled
+ */
+
+struct efct_tx_queue;
+
+struct efct_ptp_data {
+	struct efct_nic *efct;
+	struct list_head phcs_node;
+	struct kref kref;
+	struct hwtstamp_config config;
+	bool enabled;
+	bool txtstamp;
+	bool rxtstamp;
+	union efct_qword evt_frags[MAX_EVENT_FRAGS];
+	int evt_frag_idx;
+	int evt_code;
+	u8 serial[EFCT_MAX_VERSION_INFO_LEN];
+	void (*ns_to_nic_time)(s64 ns, u32 *nic_major, u32 *nic_minor, u32 *nic_hi);
+	ktime_t (*nic_to_kernel_time)(u32 nic_major, u32 nic_minor,
+				      s32 correction);
+	ktime_t (*nic64_to_kernel_time)(u32 nich, u64 timereg,
+					s64 correction);
+	u32 capabilities;
+	struct {
+		s32 ptp_tx;
+		s32 ptp_rx;
+		s32 pps_out;
+		s32 pps_in;
+		s32 general_tx;
+		s32 general_rx;
+	} ts_corrections;
+	struct {
+		u32 minor_max;
+		u32 sync_event_diff_min;
+		u32 sync_event_diff_max;
+		u32 sync_event_minor_shift;
+	} nic_time;
+	struct {
+		u64 skipped_sync;
+		u64 invalid_sync_windows;
+		u64 pps_fw;
+		u64 pps_hw;
+	} sw_stats;
+	struct work_struct pps_work;
+	struct workqueue_struct *pps_workwq;
+	struct ptp_clock *phc_clock;
+	struct ptp_clock_info phc_clock_info;
+	u32 adjfreq_ppb_shift;
+	struct efct_pps_data *pps_data;
+	s64 max_adjfreq;
+	s64 current_adjfreq;
+	struct ptp_pin_desc pin_config[1];
+	bool last_delta_valid;
+	struct timespec64 last_delta;
+	struct pps_event_time host_time_pps;
+	u8 usr_evt_enabled;
+};
+
+/**
+ * struct efct_pps_data - PPS device node informatino
+ * @ptp: Pointer to parent ptp structure
+ * @s_assert: sys assert time of hw_pps event
+ * @n_assert: nic assert time of hw_pps event
+ * @s_delta: computed delta between nic and sys clocks
+ * @nic_hw_pps_enabled: Are hw_pps events enabled
+ * @device: PPS device pointer
+ */
+
+struct efct_pps_data {
+	struct efct_ptp_data *ptp;
+	struct timespec64 s_assert;
+	ktime_t n_assert;
+	struct timespec64 s_delta;
+	bool nic_hw_pps_enabled;
+	struct pps_device *device;
+	int last_ev;
+};
+
+struct efct_ptp_timeset {
+	struct timespec64 prets;
+	u64 nictime;
+	struct timespec64 posts;
+	s64 window;	/* Derived: end - start */
+	s64 mc_host_diff;	/* Derived: mc_time - host_time */
+};
+
+int efct_ptp_probe_setup(struct efct_nic *efct);
+void efct_ptp_remove_setup(struct efct_nic *efct);
+int efct_ptp_get_ts_config(struct net_device *net_dev, struct ifreq *ifr);
+int efct_ptp_set_ts_config(struct net_device *net_dev, struct ifreq *ifr);
+int efct_ptp_enable_ts(struct efct_nic *efct, struct hwtstamp_config *init);
+void efct_ptp_event(struct efct_nic *efct, union efct_qword *ev);
+void efct_ptp_get_ts_info(struct efct_nic *efct, struct ethtool_ts_info *ts_info);
+int efct_ptp_ts_set_sync_status(struct efct_nic *efct, u32 in_sync, u32 timeout);
+void efct_include_ts_in_skb(struct efct_tx_queue *txq, u64 partial_ts, struct sk_buff *skb);
+int efct_ptp_tx_ts_event(struct efct_nic *efct, bool flag);
+void efct_ptp_reset_stats(struct efct_nic *efct);
+size_t efct_ptp_describe_stats(struct efct_nic *efct, u8 *strings);
+size_t efct_ptp_update_stats(struct efct_nic *efct, u64 *stats);
+int efct_ptp_subscribe_timesync(struct efct_ev_queue *eventq);
+int efct_ptp_unsubscribe_timesync(struct efct_ev_queue *eventq);
+void efct_ptp_evt_data_init(struct efct_nic *efct);
+int efct_ptp_stop(struct efct_nic *efct);
+int efct_ptp_start(struct efct_nic *efct);
+int efct_ptp_hw_pps_enable(struct efct_nic *efct, bool enable);
+bool efct_phc_exposed(struct efct_nic *efct);
+
+#endif
diff --git a/drivers/net/ethernet/amd/efct/efct_rx.c b/drivers/net/ethernet/amd/efct/efct_rx.c
index a715344c5a3d..d875b770f532 100644
--- a/drivers/net/ethernet/amd/efct/efct_rx.c
+++ b/drivers/net/ethernet/amd/efct/efct_rx.c
@@ -13,6 +13,9 @@
 #include "efct_common.h"
 #include "efct_reg.h"
 #include "efct_io.h"
+#ifdef CONFIG_EFCT_PTP
+#include "efct_ptp.h"
+#endif
 
 /* Post buffer to NIC */
 static void efct_rx_buff_post(struct efct_rx_queue *rxq, struct efct_buffer *buffer, bool rollover)
@@ -365,10 +368,35 @@ static bool check_fcs(struct efct_rx_queue *rx_queue, union efct_qword *p_meta)
 	return 0;
 }
 
+#ifdef CONFIG_EFCT_PTP
+#define NSEC_BITS_MASK 0xffffffff
+
+static void efct_include_ts_in_rxskb(struct efct_rx_queue *rxq, union efct_qword *p_meta,
+				     struct sk_buff *skb)
+{
+	struct skb_shared_hwtstamps *timestamps;
+	struct efct_ptp_data *ptp;
+	struct efct_nic *efct;
+	u64 pkt_ts_major;
+	u32 pkt_ts_minor;
+
+	efct = rxq->efct;
+	ptp = efct->ptp_data;
+	timestamps = skb_hwtstamps(skb);
+	pkt_ts_major = EFCT_OWORD_FIELD(*((union efct_oword *)p_meta), ESF_HZ_RX_PREFIX_TIMESTAMP);
+	pkt_ts_minor = (pkt_ts_major & NSEC_BITS_MASK);
+	pkt_ts_major = pkt_ts_major >> 32;
+	timestamps->hwtstamp = ptp->nic_to_kernel_time(pkt_ts_major, pkt_ts_minor,
+				ptp->ts_corrections.general_rx);
+}
+#endif
 /* Deliver packet to stack */
 static void efct_rx_deliver(struct efct_rx_queue *rxq, u8 *pkt_start, union efct_qword *p_meta)
 {
 	struct sk_buff *skb = NULL;
+#ifdef CONFIG_EFCT_PTP
+	struct efct_ptp_data *ptp;
+#endif
 	struct efct_nic *efct;
 	struct ethhdr *eth;
 	__wsum csum = 0;
@@ -377,6 +405,9 @@ static void efct_rx_deliver(struct efct_rx_queue *rxq, u8 *pkt_start, union efct
 	efct = rxq->efct;
 
 	len = EFCT_QWORD_FIELD(*p_meta, ESF_HZ_RX_PREFIX_LENGTH);
+#ifdef CONFIG_EFCT_PTP
+	ptp = efct->ptp_data;
+#endif
 	if (unlikely(check_fcs(rxq, p_meta))) {
 		if (!(efct->net_dev->features & NETIF_F_RXALL))
 			goto drop;
@@ -410,6 +441,10 @@ static void efct_rx_deliver(struct efct_rx_queue *rxq, u8 *pkt_start, union efct
 		rxq->n_rx_alloc_skb_fail++;
 		goto drop;
 	}
+#ifdef CONFIG_EFCT_PTP
+	if (ptp->rxtstamp && EFCT_QWORD_FIELD(*p_meta, ESF_HZ_RX_PREFIX_TIMESTAMP_STATUS))
+		efct_include_ts_in_rxskb(rxq, p_meta, skb);
+#endif
 	/* Copy packet from rx buffer to skb */
 	memcpy(skb_put(skb, len), pkt_start, len);
 	skb_mark_napi_id(skb, &efct->evq[rxq->evq_index].napi);
diff --git a/drivers/net/ethernet/amd/efct/efct_tx.c b/drivers/net/ethernet/amd/efct/efct_tx.c
index 29b09726d122..24079b7dbd32 100644
--- a/drivers/net/ethernet/amd/efct/efct_tx.c
+++ b/drivers/net/ethernet/amd/efct/efct_tx.c
@@ -9,6 +9,9 @@
 #include "efct_tx.h"
 #include "efct_reg.h"
 #include "efct_io.h"
+#ifdef CONFIG_EFCT_PTP
+#include "efct_ptp.h"
+#endif
 
 /* Transmit header size in bytes */
 #define EFCT_TX_HEADER_BYTES (ESE_HZ_XN_CTPIO_HDR_STRUCT_SIZE / 8)
@@ -200,6 +203,9 @@ static void txq_copy_skb_frags(struct efct_tx_queue *txq, struct sk_buff *skb)
 
 int efct_enqueue_skb(struct efct_tx_queue *txq, struct sk_buff *skb, struct net_device *net_dev)
 {
+#ifdef CONFIG_EFCT_PTP
+	struct efct_ptp_data *ptp;
+#endif
 	bool ts = false;
 	u64 pkt_header;
 	int skb_len;
@@ -224,6 +230,13 @@ int efct_enqueue_skb(struct efct_tx_queue *txq, struct sk_buff *skb, struct net_
 
 	txq_may_stop(txq);
 
+#ifdef CONFIG_EFCT_PTP
+	ptp = txq->efct->ptp_data;
+	if (ptp->txtstamp && efct_xmit_with_hwtstamp(skb)) {
+		ts = true;
+		skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
+	}
+#endif
 	pkt_header = efct_tx_pkt_header(skb_len < EFCT_MIN_FRAME_ALIGN ?
 			EFCT_MIN_FRAME_ALIGN : skb_len, txq->ct_thresh, ts);
 
@@ -271,6 +284,10 @@ void _efct_ev_tx(struct efct_tx_queue *txq, u8 seq, bool __always_unused ts_stat
 			netif_err(txq->efct, drv, txq->efct->net_dev, "Error: skb should not be null\n");
 			continue;
 		}
+#ifdef CONFIG_EFCT_PTP
+		if (ts_status)
+			efct_include_ts_in_skb(txq, partial_ts, skb);
+#endif
 		pkts++;
 		bytes += skb->len;
 
diff --git a/drivers/net/ethernet/amd/efct/mcdi.c b/drivers/net/ethernet/amd/efct/mcdi.c
index 80e9fc928eb5..266a8d7d19e2 100644
--- a/drivers/net/ethernet/amd/efct/mcdi.c
+++ b/drivers/net/ethernet/amd/efct/mcdi.c
@@ -12,6 +12,9 @@
 #include "efct_io.h"
 #include "mcdi.h"
 #include "mcdi_pcol.h"
+#ifdef CONFIG_EFCT_PTP
+#include "efct_ptp.h"
+#endif
 struct efct_mcdi_copy_buffer {
 	union efct_dword buffer[DIV_ROUND_UP(MCDI_CTL_SDU_LEN_MAX, 4)];
 };
@@ -1508,6 +1511,12 @@ bool efct_mcdi_process_event(struct efct_nic *efct,
 		netif_info(efct, hw, efct->net_dev, "MC entered BIST mode\n");
 		efct_mcdi_ev_death(efct, true);
 		return true;
+#ifdef CONFIG_EFCT_PTP
+	case MCDI_EVENT_CODE_PTP_PPS:
+	case MCDI_EVENT_CODE_HW_PPS:
+		efct_ptp_event(efct, event);
+		return true;
+#endif
 	}
 
 	return false;
-- 
2.25.1

