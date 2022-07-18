Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94836578674
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 17:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235573AbiGRPdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 11:33:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234761AbiGRPdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 11:33:02 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2061.outbound.protection.outlook.com [40.107.94.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 484F42667
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 08:33:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nGUUP08W1xgcH7c2G9llQUEsoihLx8bnDfZupCJyzWAnEcu+I4Qhy9FgJAHd6wM1zGGJq4KQrkx1CbFaF3EY3KaUBJB67avCbGYY856Shgucq1hoHe3+FAvuyhUWop/35ciaSZV5qbk3IHGwkRFZzUxdpMgLtcWzJeZYg+MKUA6V57bn9UW5kNGvoAx31qLBDxH9OQFrZLQfpm7Gt6Lu4P2ZrUM2+OC8eRUYM42NkwvYWnT7QKTDqmt9rymOBedttLyGTbAiPrU2qSfxE7QiJFb+UX5JCH/BE4SOX+g1dfZCqqmhSTr4y2xKdgZJ0ipFM3ANVenCVEO10wwu/yR8ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ai17Nip/Ow4qGFBtiy6u21q1ROOifzIXjDoRkWInieQ=;
 b=FuWzLU8ihBqnG3hiUTbeyS2gE8iUNDWVeFRCfCsfv/KDDhwBvJzBlTOEFFKsCIFl5mVhkHuTVI2J+/4iEd9lV0/WIL3Lfk5zHpqNIw9V2CiPUvh2sywgZD7X5L8a4+v2isqgAy7bdzy3AvsEnn8V6XPQtlM50/gmDLkqhWdVZeCpaEq/qeSAQ86pJ+JRW6HtMiCbnvA1tVg/C8atLlw0KnxcGI/x9uv60xA5fBEuT1I189HtIVEigZ8VVh0TlO1wkQZNBVnaicalgLSQokqvsh/FkKJpsA7Oo9xZ0bJSyxq+RiTDHcrvKghf6Ud/HEdi/GeGObmEYbGkaBbfti6odw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ai17Nip/Ow4qGFBtiy6u21q1ROOifzIXjDoRkWInieQ=;
 b=yHP+eB21y/Q2G44zZkGfrhOnKUlzoG5xg/TyslKf8/ift4o/+TN7KXLXEAlK4mjr8aDK52s/qOVZIj7lSjyUt1cZcPmuzPnP7eK3vSxrjrgBJ1MjXgXyEDxv7slHgcbzhzczm4zNgnVxdnyAujzcG+L3k1+GzMtbZ8FVmTtOS0a44xDX+CIHtPCrxUnISPyC7RTuvzsCFuw09zDlUsTfNkciIW/gpHbSbmn8SwgtZXTtqVwYN5bSP1f3zFyESlN8KldETITQO9VBw4Dx9HkbBjdpx7oDBvstLp1aLIhNQXsCT6igLlUZa4+onXDZZyr/YhBV0swpyw4RlLHTEG8Feg==
Received: from BN8PR15CA0033.namprd15.prod.outlook.com (2603:10b6:408:c0::46)
 by DM6PR12MB3243.namprd12.prod.outlook.com (2603:10b6:5:185::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.17; Mon, 18 Jul
 2022 15:32:58 +0000
Received: from BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:c0:cafe::c7) by BN8PR15CA0033.outlook.office365.com
 (2603:10b6:408:c0::46) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23 via Frontend
 Transport; Mon, 18 Jul 2022 15:32:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT064.mail.protection.outlook.com (10.13.176.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5438.12 via Frontend Transport; Mon, 18 Jul 2022 15:32:57 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 18 Jul
 2022 10:32:54 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 18 Jul
 2022 10:32:53 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Mon, 18 Jul 2022 10:32:52 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH v2 net-next 09/10] sfc: hook up ef100 representor TX
Date:   Mon, 18 Jul 2022 16:30:15 +0100
Message-ID: <aa6fe2efb07fbbbcaef889eb2454ac357bba85ed.1658158016.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1658158016.git.ecree.xilinx@gmail.com>
References: <cover.1658158016.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e93718be-0842-4664-1504-08da68d2caa2
X-MS-TrafficTypeDiagnostic: DM6PR12MB3243:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tcBLNhNY12cq4jlAoa/M7i5fPTliwLDw/xhPobTbFYiZy/fZObl2I0ewHzVi7/1Nlw/t+F6YCdJe+l7ZKBcBWhnpubkkWkr14Wazr+jpBRiS/phni80OY/ZTRR1jOXA/ccsBKn5fQDERj2MBBkfJ3+76FyADQocWwRnDi+jkr6yfLud3JBWW+mhW4tzsKd+VWxOiTSkpZoM7NfyNsayAq9VtP3zRLiJUKA51R5lrDo452HTEf1JDMfKLBMuILvrHZeplMdyBk8B6Y2m8Vma0SMMa63ggj40JF/f3N6lFH+30Eoa2BND/MTeJHithf5ZQLsBezurUlj9wnzw6U+XVBxhCDzboZSafNjUWub1OQcukiquVsC4fTlgK1zSUxhuNqc2Wcrx+50VmDh6o1olsqYg2Wj02IovaZer5/z00xIPyzeGRRbNfo0UciRAAEtSUj0KPiTMEfjjfyajjSwUIGRN7NM/cZGe0s73SrTkVRodIaAC8lZBJ0iNj9WUNPZgUnviXvwAFXP8oJa0uQ9TrOSotczHpWueKF8o0Je5Vle/jWlsvRhp3ZKkeCNQY95BpwU3SpIku9WpZMhXfeOqDIEFnb+y8xtkRcDk2vGdzk1w86lVxkkDaO2gmQu8X54OOtIwomKVoHGH4P0QpsNr6KxlzkaWQEzoYFfqtpl5NYTINqXrO1W6kjQ3un59wwMe60GvHiKmF4Pb9yyBFO5q8ZH569H4D2eBV/nQl8cxefe3k6Dauj3sDxfLFNhx1Rip6V5r5Z8JNlASOO9CRtPPVUCx2J1y8fUAhpVsBa1UnRA6+GhuofUdrftU8od6T4Oer6ngWgbNlg2GkU4/y9uHNHowwvtyjueG+XY6xJDy/MNLZ+u1W7uFpmIGdxke+2r6ak19OmOUqpaIiLAqykkmk6w==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(346002)(136003)(376002)(36840700001)(46966006)(40470700004)(6666004)(41300700001)(83380400001)(186003)(478600001)(336012)(47076005)(26005)(42882007)(2876002)(40480700001)(5660300002)(40460700003)(9686003)(82310400005)(36860700001)(316002)(54906003)(110136005)(8676002)(70206006)(70586007)(4326008)(8936002)(55446002)(36756003)(81166007)(82740400003)(83170400001)(356005)(2906002)(52103002)(158003001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 15:32:57.7606
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e93718be-0842-4664-1504-08da68d2caa2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3243
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
