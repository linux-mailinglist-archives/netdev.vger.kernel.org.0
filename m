Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3907757BDDC
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 20:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbiGTSeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 14:34:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbiGTSeN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 14:34:13 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2057.outbound.protection.outlook.com [40.107.94.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE99F71BC4
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 11:34:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UxRnnmxjxF6p1755OiFppo8NoFo0NFCUnea63f8zAWnQvR5It2iXcQjaAB1aeDHpDIxbQ3Xab9nJHiEe2yPwhi9BixUKqi8D/SX1eCKpL8mgdNXi5lkuF3QVjewMGPl6HYjoppQsXu6qcPnd913YAlvWEh8MbskX9kJQSa7D+k1dWOivsjFRudyUwyiM5ekF4qeRezXJaOSuY/vQYY7jZ5Ij8Ag42xwbD+nEB5Q/nfiIth4amrL5qeDVrEaaFmtvZZ2XcT1O4Efov4dc1+C+njCJ0DgRipaaOF1KENKwca4gG9QGWCmlb6XQGACVgqDlkRkiiclwXtFZivDrFpAqHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ai17Nip/Ow4qGFBtiy6u21q1ROOifzIXjDoRkWInieQ=;
 b=NhThGSPnITcGk+p7QtSTywhghGcNgifHCTTLYgVPoWgxhHfrG89FpJkcCYyqkGPAs9WhATFq91aYa0CQuj60nUzB0bMdlsW9PrvXoXmTg9wPHP0sxr+gZlQaksY/J6pIDqOgFrDleqEY0QhEzbiMz0MopiRnZzeoBVnzy1D84ya5v9Re/rryuy/iGo6sCHPbFVAGRtzlml5yzDlHOOsQ8C0W+CsseiiCNvGwfqnkrUqE58H3uptxc3gi4LVan7E8dVQOZndhq0pnyAEpeyGC/0JeanB3DxDZOHJzrfVtm8rGLMp5FJJUwfm/bYschmJUrNTTSV6Ns/2fcgESmbtkYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ai17Nip/Ow4qGFBtiy6u21q1ROOifzIXjDoRkWInieQ=;
 b=lrNBCfACPfqogomJNB7YTEqp2ecqNtMwXB3JCd9JKY71+lxGL7dRNC2ylMZjaRs6HAfiLG/l1zhj8Z4SP006Ng4JqHh3xGrA75rqNZGQ5nE6ev6lC7M6pCxjTPMek8IIAYrIGrz2j0cLzlWfJMmw43+Go3LAdDKUIHVvjQ5U4y2Cgj8rc49BIewldxIS1matnZQNmBjmY11Z9U+VHhdVY3OdnvjU08yXnXrjVN9Drd3xC3ZV5+VaCklIjfF9AnyUlVqtcmENJbeebpmQQuyY2OyvOE8kpKjLvPZKCWBUYFg0RrHgcms1akJFfKnXsu4v9ZsaayWG0B0W1zEA+Yqw/g==
Received: from MW4PR04CA0248.namprd04.prod.outlook.com (2603:10b6:303:88::13)
 by MW4PR12MB6803.namprd12.prod.outlook.com (2603:10b6:303:20e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.15; Wed, 20 Jul
 2022 18:34:09 +0000
Received: from CO1NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:88:cafe::72) by MW4PR04CA0248.outlook.office365.com
 (2603:10b6:303:88::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.24 via Frontend
 Transport; Wed, 20 Jul 2022 18:34:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT044.mail.protection.outlook.com (10.13.175.188) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5458.17 via Frontend Transport; Wed, 20 Jul 2022 18:34:08 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 20 Jul
 2022 13:34:07 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 20 Jul
 2022 13:34:07 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Wed, 20 Jul 2022 13:34:06 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH v3 net-next 8/9] sfc: hook up ef100 representor TX
Date:   Wed, 20 Jul 2022 19:33:48 +0100
Message-ID: <20220720183349.29448-2-ecree@xilinx.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1658341691.git.ecree.xilinx@gmail.com>
References: <cover.1658341691.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8bc25a0c-ac58-434f-9b05-08da6a7e6f0b
X-MS-TrafficTypeDiagnostic: MW4PR12MB6803:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nmNJJTrNXBP9cGSmOF6oSUzGMjs1EsJLVixeRo02AD0akuOf3Xkb8S+6YQiEyyadgOhEKN+PYAcWYgSgGUWjXJncb5AxMSPS9BAgmVD9KIH17p5PGccPZdSA6f3Ll0X5d2SovFGQRovvb6r9k0++8Ztx8oG1DEL0sxLbgisFcIs0iDoHr9upFCWDzoa7oTqzMnQlQjjULHVFXUFen+UEj6qcx2Mk5g7gbT4A8NO6bXb/4VXh4iHX7Z+XWI8vgYu6TvccOHt9AqT7VEKxDHn2vlL/u0+2SCaq6K+9d3pwaID2T/D4EQ6fEmiWMHMZeMA73GAqpmZm+BnE/a0qoDz1W+eiTqPJv0AsN54RxyecldpgE7gi7yv0i6PcWtw69Bvivura+RT6vK4Z7YA66o/OIvWPM2q72PKPD6g9Y6GE/C11+DURJTwtXYJBA4IboGaD8VFoaLF7vhQsokAV+qD38L3RxI6kQnm4zEYM31G3Mx2HmjfvdpCKKbd+iNjAqePCjM4rrelPd4bIgKyYxVcIsDJi9VbZACi8eowQcwJHaQtQQlCXoIKv4sH156jJ8GSSObbsc8smURV2eKH9XkXtZOeSEh61nU0iWkl7bJ00lKzMmNEXwrk/+HCTcYgXP8MgTK6Sk+ji4vL626wdSHsdy6480qF1oZNJ4RUoMydBExeLgFSjgHWI4UotD988QghH73qv4FmgDcekMAnSaEWHHuDQB8rSuRehRo8UuoOrXvb7OEnHf2/dDag+Pd4Jip0cmpRzwdwhQWVQ39sadrD7X5DX55xjs1PBgAZV9V/r5WN3GT1CxGTaBVcDV1tVGu0qDNzVGA6NSNR3yvyR3AKQMzqttGWorbt5HY1hw87osSaOVREcpuP28U0Mkg6AI9g1gDuey0ouAcWtnDogkebfZA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(376002)(396003)(136003)(36840700001)(46966006)(40470700004)(70586007)(81166007)(8936002)(2906002)(4326008)(2876002)(5660300002)(6666004)(41300700001)(54906003)(478600001)(40460700003)(2616005)(82310400005)(83170400001)(82740400003)(336012)(83380400001)(1076003)(7696005)(186003)(36860700001)(356005)(26005)(40480700001)(8676002)(110136005)(316002)(36756003)(70206006)(42882007)(47076005)(52103002)(158003001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2022 18:34:08.5926
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bc25a0c-ac58-434f-9b05-08da6a7e6f0b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6803
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
