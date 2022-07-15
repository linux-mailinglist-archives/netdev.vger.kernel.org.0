Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DFC75761CE
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 14:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234553AbiGOMgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 08:36:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234497AbiGOMg3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 08:36:29 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 226FF7B37E
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 05:36:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oArN7tieEdafAnnWa1C5E9RVuJbMa9Y5ugY+9yRd+X8W+6sdB9a+aRNRBlVTZs7JybVJ5btJHct3s6EQyHXhk/Drrrm1Vk2SEfVKqXRaHfd96n+xhJwunDoxokJQv9qoUmLTjnr587nu2UZSPVFex6rTAtNxXTo91b8xTBOuhjGxojzFATk+owqee70nGbRjfqU8w7asu08fo6gfn2X4H7BQMnGoYo9VPCOiYp8q/RIzrPAClNqt5YXnSHEW3TtIE2+x9/33HS0Fm/j7zg52m5T3KsZPLcZt2bgWY84NimEPuPodQIo7zqVo1KB/4NHv/NoxccdmFo5NpDeAe9TQcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ai17Nip/Ow4qGFBtiy6u21q1ROOifzIXjDoRkWInieQ=;
 b=ZsvoHdXedEMOBxLzYK6G3Ii4GlFu04h3THr63SSzSbyfPyQ73BqezniiDFMVp5pHRmoUr8QrzFQ/0S5B102uToDP0ZorvurLJ7QI34w/pJu5v5jziilkdAfksxuIXENd7MDyKh6qDoY3ThMQhGru/NKIDtQqCgCuppxwOxZHV0lnCoKgD9NTboEgdbcvT6kRNyd0cKGkWwh8cO2j692iJTKcPLVVbTiI3K9C9+kVQvcFtoUWgxBcq9Zm7wK4QPzaVOuf71CH5f+jIWdyHH6dJjK9WnT35hq2l20Jszpwbc5S7ZaFsV4TvgFyeRr8kEjCntFOTJioZ48aAsUeCEVQ9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ai17Nip/Ow4qGFBtiy6u21q1ROOifzIXjDoRkWInieQ=;
 b=K3+zH+WX7c2GLX0xxn1ExiQYp937Yxh8J3Yjp1ok8jtmas9QIMVHpPIezbSqPdE2eJkV/ZAxa5hbRPGgnuRcD2QPw1M7cJkzeuXjJX7PMpFTAq64R92hHkGbI35qehn3adVscKNr+CzJY1B5JbQcU1YMOcNwf7Rjjx9H1oxtb7Ntk9XszqLtwip+uDHVimHAt9x0JG+69g43s3ReRvvoqjg1yWEK/VYbKGs73tM7gXbN/caQWkuYo2jUy9EO2YkF8Y2X0FOT3c/EXYs2+UyhvJgTuwbOT0RQoCYjlDJ/MeCCilVkZXJqhln3o6QEgf8CLtQsXrlYXIr/kndCblGLyQ==
Received: from MW2PR2101CA0001.namprd21.prod.outlook.com (2603:10b6:302:1::14)
 by BN6PR12MB1700.namprd12.prod.outlook.com (2603:10b6:404:108::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.12; Fri, 15 Jul
 2022 12:36:21 +0000
Received: from CO1NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:302:1:cafe::10) by MW2PR2101CA0001.outlook.office365.com
 (2603:10b6:302:1::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.6 via Frontend
 Transport; Fri, 15 Jul 2022 12:36:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT029.mail.protection.outlook.com (10.13.174.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5438.12 via Frontend Transport; Fri, 15 Jul 2022 12:36:20 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 15 Jul
 2022 07:36:19 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 15 Jul
 2022 05:36:19 -0700
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Fri, 15 Jul 2022 07:36:18 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next 09/10] sfc: hook up ef100 representor TX
Date:   Fri, 15 Jul 2022 13:33:31 +0100
Message-ID: <a9998ab95dc4b74e3a611119a87867691d33e0ba.1657878101.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1657878101.git.ecree.xilinx@gmail.com>
References: <cover.1657878101.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bff4e106-19c6-4d2a-6714-08da665e9f01
X-MS-TrafficTypeDiagnostic: BN6PR12MB1700:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RqIPwdStYxl5qeFzn5Ep2sPEvaJBQpYxGh6EgN7K2eI+1FfoylKULHFFWrBxdXDHznRswRXdh26GPMhGsSWLG99uJoAphMuqWv0mfDsfFCZPZNr1DJZdA1Ob/cH9IVbLGq2vDrfuumhIzkcxeUOJfUK6L/4Zxs8uNbjKVka4jPdHswk4Alnd+qf87Zw4GhfuutGyzS0TasHSz4TCV5jW2eVAX693i2ghc9m82yJwNrNIWp29CMy5tBH5zuATglXfPzPU0wFd5jYWQO+bz/ULuQKSu9cfkXmtV3uk+xz8XUnMcrEWehu3HnOqIkwVwxCS2WK193FjZR2MzuHDon/32wth7Mz8zqjQrfak87CiiDpsCxPKO99vL40/4CvUiiYqrPA5COc9IpeGRBgZqvRWvq18dVHJjb1N8p+ZwQy6qVL5FSDAMpU/AWl6toNth2Dkanop3+WsyzRQNPi3gIPP13CeblfaFbuWxWdug91tKRS/t7BSU4/WU1+G5W7S08FHD6/QkdQpPmg0LfVD+JeaYHXdxBpwon/DNJxGxJYotaGtLYA+x8AmH1bFVi2xE6GCaOPuDlF64KXsLA3x5yD5ZpPpcfNwhGApFDGRZazk6+WlXS/lNU7JISFW734vE0AJwDsVD75q58BGL7Mz7g7n0QQL1jVHe0NWWdO2JC5gkfmuR10rXI4fIc+S7c9clRUls+zlqEffW9q1utaFhEBZCbfisnrd0SsfBNKvb4g1aNkzqJHwMFIFw2ax2HUtdKSOlpaenhFDhHHwXQOf2yJczLyNzK5YwDhskSS1NA+mXRqPwiAW0xZT5h+ylbH2M+0gxhYZy0AVRIjhVMLq2GCN8y4SncpwylUdiLcP0twRuTv8fdcWm0ntWUYdy5oBxtcIcCekByx4WXAtXaD1LIRqdQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(396003)(39860400002)(376002)(36840700001)(46966006)(40470700004)(356005)(47076005)(82740400003)(186003)(36860700001)(336012)(36756003)(42882007)(8936002)(2906002)(2876002)(5660300002)(40480700001)(26005)(110136005)(478600001)(8676002)(6666004)(81166007)(9686003)(41300700001)(316002)(70586007)(83380400001)(83170400001)(70206006)(4326008)(55446002)(82310400005)(54906003)(40460700003)(52103002)(158003001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 12:36:20.5099
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bff4e106-19c6-4d2a-6714-08da665e9f01
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1700
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

Implement .ndo_start_xmit() by calling into the parent PF's TX path.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/ef100_netdev.c | 11 ++++++++++-
 drivers/net/ethernet/sfc/ef100_netdev.h |  5 +++++
 drivers/net/ethernet/sfc/ef100_rep.c    | 23 +++++++++++++++++++++++
 3 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
index f4a124b8ffbe..3443477c26da 100644
--- a/drivers/net/ethernet/sfc/ef100_netdev.c
+++ b/drivers/net/ethernet/sfc/ef100_netdev.c
@@ -195,6 +195,15 @@ static netdev_tx_t ef100_hard_start_xmit(struct sk_buff *skb,
 					 struct net_device *net_dev)
 {
 	struct efx_nic *efx = efx_netdev_priv(net_dev);
+
+	return __ef100_hard_start_xmit(skb, efx, net_dev, NULL);
+}
+
+netdev_tx_t __ef100_hard_start_xmit(struct sk_buff *skb,
+				    struct efx_nic *efx,
+				    struct net_device *net_dev,
+				    struct efx_rep *efv)
+{
 	struct efx_tx_queue *tx_queue;
 	struct efx_channel *channel;
 	int rc;
@@ -209,7 +218,7 @@ static netdev_tx_t ef100_hard_start_xmit(struct sk_buff *skb,
 	}
 
 	tx_queue = &channel->tx_queue[0];
-	rc = ef100_enqueue_skb(tx_queue, skb);
+	rc = __ef100_enqueue_skb(tx_queue, skb, efv);
 	if (rc == 0)
 		return NETDEV_TX_OK;
 
diff --git a/drivers/net/ethernet/sfc/ef100_netdev.h b/drivers/net/ethernet/sfc/ef100_netdev.h
index 38b032ba0953..86bf985e0951 100644
--- a/drivers/net/ethernet/sfc/ef100_netdev.h
+++ b/drivers/net/ethernet/sfc/ef100_netdev.h
@@ -10,7 +10,12 @@
  */
 
 #include <linux/netdevice.h>
+#include "ef100_rep.h"
 
+netdev_tx_t __ef100_hard_start_xmit(struct sk_buff *skb,
+				    struct efx_nic *efx,
+				    struct net_device *net_dev,
+				    struct efx_rep *efv);
 int ef100_netdev_event(struct notifier_block *this,
 		       unsigned long event, void *ptr);
 int ef100_probe_netdev(struct efx_probe_data *probe_data);
diff --git a/drivers/net/ethernet/sfc/ef100_rep.c b/drivers/net/ethernet/sfc/ef100_rep.c
index cf0eac920592..6d4c3f0eee0a 100644
--- a/drivers/net/ethernet/sfc/ef100_rep.c
+++ b/drivers/net/ethernet/sfc/ef100_rep.c
@@ -10,6 +10,7 @@
  */
 
 #include "ef100_rep.h"
+#include "ef100_netdev.h"
 #include "ef100_nic.h"
 #include "mae.h"
 
@@ -28,6 +29,25 @@ static int efx_ef100_rep_init_struct(struct efx_nic *efx, struct efx_rep *efv,
 	return 0;
 }
 
+static netdev_tx_t efx_ef100_rep_xmit(struct sk_buff *skb,
+				      struct net_device *dev)
+{
+	struct efx_rep *efv = netdev_priv(dev);
+	struct efx_nic *efx = efv->parent;
+	netdev_tx_t rc;
+
+	/* __ef100_hard_start_xmit() will always return success even in the
+	 * case of TX drops, where it will increment efx's tx_dropped.  The
+	 * efv stats really only count attempted TX, not success/failure.
+	 */
+	atomic64_inc(&efv->stats.tx_packets);
+	atomic64_add(skb->len, &efv->stats.tx_bytes);
+	netif_tx_lock(efx->net_dev);
+	rc = __ef100_hard_start_xmit(skb, efx, dev, efv);
+	netif_tx_unlock(efx->net_dev);
+	return rc;
+}
+
 static int efx_ef100_rep_get_port_parent_id(struct net_device *dev,
 					    struct netdev_phys_item_id *ppid)
 {
@@ -60,6 +80,7 @@ static int efx_ef100_rep_get_phys_port_name(struct net_device *dev,
 }
 
 static const struct net_device_ops efx_ef100_rep_netdev_ops = {
+	.ndo_start_xmit		= efx_ef100_rep_xmit,
 	.ndo_get_port_parent_id	= efx_ef100_rep_get_port_parent_id,
 	.ndo_get_phys_port_name	= efx_ef100_rep_get_phys_port_name,
 };
@@ -119,6 +140,8 @@ static struct efx_rep *efx_ef100_rep_create_netdev(struct efx_nic *efx,
 	net_dev->ethtool_ops = &efx_ef100_rep_ethtool_ops;
 	net_dev->min_mtu = EFX_MIN_MTU;
 	net_dev->max_mtu = EFX_MAX_MTU;
+	net_dev->features |= NETIF_F_LLTX;
+	net_dev->hw_features |= NETIF_F_LLTX;
 	return efv;
 fail1:
 	free_netdev(net_dev);
