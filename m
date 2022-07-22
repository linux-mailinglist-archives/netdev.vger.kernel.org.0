Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94DA457E424
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 18:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235302AbiGVQGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 12:06:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235330AbiGVQG3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 12:06:29 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2072.outbound.protection.outlook.com [40.107.95.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC7913F36
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 09:06:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=POuLXT9kxu4WVwy8QFdUGFrcfjgdOwaF4Gcg01uJwHEm+qU7uqSKLazdQFNUb2OIim6kTr75ln2zkiVmXYf6z9VFdOJLUrnTB6eYWal7xCV6cH96USFptuoGrk53NbFvugTvB7SayoZsZmfwdszqfOjb4z5aHxGLN4hzOfcT5yu6takzhdRYZS2xEPX7mnLZJwfLro6ijaMm94zJ0hXurBwMlFWV9NkHVwhfPUG38ZpyddbWFVxByc5Stb5A+cTfSXIO1eSFclGNP5U1MOi4Q+gzy9qVUE0bXnBOvohpe/D7rCYJ8bXKJPjcBLzxQZNuJLIAhnQl57VBknYk2LH8TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DggtUei1bA7tcaYBGILcO8uL6PwnvobY/ZfO76mhf5U=;
 b=fxEL08d0T7DxSM4IrqmvWG72VGECJxg/hNE2cqdoen6eVb0ei9INvBzJqIP4u3we5HP8x3yslhDCVCSeQBxQOvZtnCQszenPQLvP6kYQeXWcWaKs0b40X2FJk8urMRha9wvl7cbgC1Zt09yV4j3yke0cFv4Tw6IXBf7oeinVtam4yCkGCE/SDmxfeQebtg9JGueWJ00qw7a/ykYlXlvwy6s9TKB/tfYLqnd23bcYV6i6PBkc2275hjtQHef5W5ZxuChdgaG7ycxrBkEpLeQTd5i1FPsomzuKSnv9uZAeNkp0JQySW7uxzrLKJs1wx7vEFGH39tYmpDXpsV8hBmgHIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DggtUei1bA7tcaYBGILcO8uL6PwnvobY/ZfO76mhf5U=;
 b=cGfJegcQqrnn2sZb7ZY4bWp/WP/+ycKfOwbajf/9cMJ6XDKpgZl4i58bn9+nxeRPjuoArcu7qPWycoix4cI8pqcH7l/RMVIaZgXw7Tz7K2nf51lwZWNIW4T9I5YWgO3PMsz39Ict3Jm3gKsyoNWOK9kcgNl4/9sFhHaj59sWthTYctUKN8JXBKPh5gzEi3dPoT98Stu1sj4kWUvMd8X1J7s1sMHebo4+XJohkI97ErZQeChQgQuu+SBB+Oi40OsgYv3lm7B714Hyq6FOTizbceaf8hAuvIK1DCjqtL+r66GF4FyIJuVSDOLKQcAHFnk8032+Tqx/gcfRNgUnLKCo7Q==
Received: from DS7PR03CA0043.namprd03.prod.outlook.com (2603:10b6:5:3b5::18)
 by BY5PR12MB4999.namprd12.prod.outlook.com (2603:10b6:a03:1da::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Fri, 22 Jul
 2022 16:06:24 +0000
Received: from DM6NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b5:cafe::49) by DS7PR03CA0043.outlook.office365.com
 (2603:10b6:5:3b5::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23 via Frontend
 Transport; Fri, 22 Jul 2022 16:06:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT019.mail.protection.outlook.com (10.13.172.172) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5458.17 via Frontend Transport; Fri, 22 Jul 2022 16:06:23 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 22 Jul
 2022 11:06:18 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 22 Jul
 2022 11:06:18 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Fri, 22 Jul 2022 11:06:17 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next 02/14] sfc: ef100 representor RX NAPI poll
Date:   Fri, 22 Jul 2022 17:04:11 +0100
Message-ID: <e2303beb8032fb0e57ef195ff8516445c7ffc71d.1658497661.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1658497661.git.ecree.xilinx@gmail.com>
References: <cover.1658497661.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 01221d44-6dd8-4632-a09f-08da6bfc2002
X-MS-TrafficTypeDiagnostic: BY5PR12MB4999:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BahcO2/ZaMLuKlul8qQL2Vim3R3OtGiffHy5y/Agcl82zTXyGObcMAzc1TPLaGNA1lY7tjz3fZiDA2zwUyobQpiNV8ZQ0S0crKnckuSjVtfV8zAy5h8fibbiNjzttuPo5ZGc3LQqcHmIKZ6OOsxH5Rc2PqpNa4P04JeWdaWZcBsmPZPVTRVOp2Y/IcZxfOHTYwCAjH0PJGIPvQvcykhB/McOMAR67hZbZQHyYnlt8iYjjKOdlW3Ac1aumS4PwcMJk+3X/tLoHE9JjlYIsipDleFPNRiCRSRjHHh6B0YE9C/tnoSKyrvr0pp0aFkX3nGqzdsRRyffMcbCC/y1Ppu5PBqjGayX1ez1ISjTpkVfuKVCNbTs2cJNCXWOKQH9NJDRTTDAlgx4GjR+IhCFF+uwsyoxdwxAbLDqx66jAMlbX4VKo9lac4HU3Zx6hutMEHJ0prAB3HX9hQGy46TyyIjJm+c5ak6NK6M0AIsbgcEvxWW4jqHLTA91vUtBA1uXPCGRPOKYSu6EQvaxy/btgEexZcUytSJYQIKCKb6cPxvdS+QO9ALDdALbKL6plJApNb90anLta4G1wUgBU4qWuoSMXdZ/uARsPJ1Gajy0ckeGHocBoMI9vMOSabM1r2BiRmYdEFkg7awukuHyjxlpbH1IYxwx71vu2kL2Ysse//HoC9mMe+kh281GkjaUpC/WLq60gJnqfQ0LPPyIIWb+K9EWgL02sss9imyEbC+f7bGaoY9fZTbF4+xygbIb14dgoJkXzGRWH+0pR/d2u+sGGhLM0g4JLNhoevgkvEhnGvjGhpZgREFEYNq1Segx5jH+2ywVLpWx2OH4eKcQmhEEJPTWEg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(396003)(376002)(39860400002)(40470700004)(46966006)(36840700001)(26005)(41300700001)(40460700003)(9686003)(110136005)(186003)(2876002)(82310400005)(82740400003)(47076005)(36756003)(55446002)(70206006)(54906003)(2906002)(336012)(40480700001)(36860700001)(478600001)(8676002)(42882007)(316002)(8936002)(83170400001)(83380400001)(70586007)(5660300002)(4326008)(356005)(6666004)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2022 16:06:23.8226
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 01221d44-6dd8-4632-a09f-08da6bfc2002
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4999
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

This patch adds the 'bottom half' napi->poll routine for representor RX.
See the next patch (with the top half) for an explanation of the 'fake
 interrupt' scheme used to drive this NAPI context.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/ef100_rep.c | 64 ++++++++++++++++++++++++++++
 drivers/net/ethernet/sfc/ef100_rep.h | 11 +++++
 2 files changed, 75 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef100_rep.c b/drivers/net/ethernet/sfc/ef100_rep.c
index 102071ed051b..fe45ae963391 100644
--- a/drivers/net/ethernet/sfc/ef100_rep.c
+++ b/drivers/net/ethernet/sfc/ef100_rep.c
@@ -16,12 +16,16 @@
 
 #define EFX_EF100_REP_DRIVER	"efx_ef100_rep"
 
+static int efx_ef100_rep_poll(struct napi_struct *napi, int weight);
+
 static int efx_ef100_rep_init_struct(struct efx_nic *efx, struct efx_rep *efv,
 				     unsigned int i)
 {
 	efv->parent = efx;
 	efv->idx = i;
 	INIT_LIST_HEAD(&efv->list);
+	INIT_LIST_HEAD(&efv->rx_list);
+	spin_lock_init(&efv->rx_lock);
 	efv->msg_enable = NETIF_MSG_DRV | NETIF_MSG_PROBE |
 			  NETIF_MSG_LINK | NETIF_MSG_IFDOWN |
 			  NETIF_MSG_IFUP | NETIF_MSG_RX_ERR |
@@ -29,6 +33,25 @@ static int efx_ef100_rep_init_struct(struct efx_nic *efx, struct efx_rep *efv,
 	return 0;
 }
 
+static int efx_ef100_rep_open(struct net_device *net_dev)
+{
+	struct efx_rep *efv = netdev_priv(net_dev);
+
+	netif_napi_add(net_dev, &efv->napi, efx_ef100_rep_poll,
+		       NAPI_POLL_WEIGHT);
+	napi_enable(&efv->napi);
+	return 0;
+}
+
+static int efx_ef100_rep_close(struct net_device *net_dev)
+{
+	struct efx_rep *efv = netdev_priv(net_dev);
+
+	napi_disable(&efv->napi);
+	netif_napi_del(&efv->napi);
+	return 0;
+}
+
 static netdev_tx_t efx_ef100_rep_xmit(struct sk_buff *skb,
 				      struct net_device *dev)
 {
@@ -93,6 +116,8 @@ static void efx_ef100_rep_get_stats64(struct net_device *dev,
 }
 
 static const struct net_device_ops efx_ef100_rep_netdev_ops = {
+	.ndo_open		= efx_ef100_rep_open,
+	.ndo_stop		= efx_ef100_rep_close,
 	.ndo_start_xmit		= efx_ef100_rep_xmit,
 	.ndo_get_port_parent_id	= efx_ef100_rep_get_port_parent_id,
 	.ndo_get_phys_port_name	= efx_ef100_rep_get_phys_port_name,
@@ -256,3 +281,42 @@ void efx_ef100_fini_vfreps(struct efx_nic *efx)
 	list_for_each_entry_safe(efv, next, &efx->vf_reps, list)
 		efx_ef100_vfrep_destroy(efx, efv);
 }
+
+static int efx_ef100_rep_poll(struct napi_struct *napi, int weight)
+{
+	struct efx_rep *efv = container_of(napi, struct efx_rep, napi);
+	unsigned int read_index;
+	struct list_head head;
+	struct sk_buff *skb;
+	bool need_resched;
+	int spent = 0;
+
+	INIT_LIST_HEAD(&head);
+	/* Grab up to 'weight' pending SKBs */
+	spin_lock_bh(&efv->rx_lock);
+	read_index = efv->write_index;
+	while (spent < weight && !list_empty(&efv->rx_list)) {
+		skb = list_first_entry(&efv->rx_list, struct sk_buff, list);
+		list_del(&skb->list);
+		list_add_tail(&skb->list, &head);
+		spent++;
+	}
+	spin_unlock_bh(&efv->rx_lock);
+	/* Receive them */
+	netif_receive_skb_list(&head);
+	if (spent < weight)
+		if (napi_complete_done(napi, spent)) {
+			spin_lock_bh(&efv->rx_lock);
+			efv->read_index = read_index;
+			/* If write_index advanced while we were doing the
+			 * RX, then storing our read_index won't re-prime the
+			 * fake-interrupt.  In that case, we need to schedule
+			 * NAPI again to consume the additional packet(s).
+			 */
+			need_resched = efv->write_index != read_index;
+			spin_unlock_bh(&efv->rx_lock);
+			if (need_resched)
+				napi_schedule(&efv->napi);
+		}
+	return spent;
+}
diff --git a/drivers/net/ethernet/sfc/ef100_rep.h b/drivers/net/ethernet/sfc/ef100_rep.h
index d47fd8ff6220..77037ab22052 100644
--- a/drivers/net/ethernet/sfc/ef100_rep.h
+++ b/drivers/net/ethernet/sfc/ef100_rep.h
@@ -29,7 +29,13 @@ struct efx_rep_sw_stats {
  * @msg_enable: log message enable flags
  * @mport: m-port ID of corresponding VF
  * @idx: VF index
+ * @write_index: number of packets enqueued to @rx_list
+ * @read_index: number of packets consumed from @rx_list
+ * @rx_pring_size: max length of RX list
  * @list: entry on efx->vf_reps
+ * @rx_list: list of SKBs queued for receive in NAPI poll
+ * @rx_lock: protects @rx_list
+ * @napi: NAPI control structure
  * @stats: software traffic counters for netdev stats
  */
 struct efx_rep {
@@ -38,7 +44,12 @@ struct efx_rep {
 	u32 msg_enable;
 	u32 mport;
 	unsigned int idx;
+	unsigned int write_index, read_index;
+	unsigned int rx_pring_size;
 	struct list_head list;
+	struct list_head rx_list;
+	spinlock_t rx_lock;
+	struct napi_struct napi;
 	struct efx_rep_sw_stats stats;
 };
 
