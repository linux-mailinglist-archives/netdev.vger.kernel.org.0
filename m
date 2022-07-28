Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE07584692
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 21:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbiG1S6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 14:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230481AbiG1S6r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 14:58:47 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2076.outbound.protection.outlook.com [40.107.93.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 172EF2A71E
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 11:58:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hpvyzVARuo3KhsjkHjgiSYfgHJtW+XDjedG/XQrLaCB+wrhqoIpTn7Lx0CDe3LRJeua+BpCSNMnJZnJVprvmd+ivNTTvYP0Tm4ZBKQLM6DNmI+it9b9NHYESTtgBHcXE/DxpwbPKZLDbj2jJ2oq1EDIZ7vnn/VyTovNt0k83gQo0Vkr2oC7TfrIa7vDg6eacelqTHDOA9LBRAlHQepKj/L++JrzhC0vHvsL6VudF/JIubXC81OAXOMIqVkwmDxM1cf/OHvUJ6ajAJ5yqKkZu51CZd0+2CELmI0Ype29B0s0DxRGWVGTK5WR8SBUCa01yc4oiAbw+AAnaM9w8W6DFaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g1BOn3ovXjF5eBdA59lopxEnBIhV4f4pluGlLUojo/Q=;
 b=PxTjV+qY6Yh7TITuwpmpMFkkGUt9GjhVg8cjqH9ztKuVQUFwgkc9Kz4+EFveUc9Uy19Ltnqbo8ka2A89HIWy8rzFdY8seQO7tgr1zQkxvK+KvyW959ysWSOGN6RI2nIw7ibuAx+U0a880jxY6hhqbZniRrB4RPtPbUOiDfd+K2euZrtYg8Yvb+IovsHMkvHaQbEb/niyO5AyQfzt8w9uKpm4882Ww8mgDh3CFccLzoTl+G0Bp5ynHwg6otZLoogBKTyjtThxsDdK7iVRtOp7eupQH0t3KblfyAxDITZwCczqdoF2URKH6ffqtoJweiE8JlvhwfTeOl8blQukdz76wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g1BOn3ovXjF5eBdA59lopxEnBIhV4f4pluGlLUojo/Q=;
 b=296Zahkuo2fAUErZwku5E5NeMZPrB7fqD2/7tB5S+TxZXElLc18n6bzwVu5CtrVxV7wPo+pfxuI3h1o6w+gTxcVhEKiNj5M/cZ4An7Ya+g+SnoGOZXgcxmrqG444H0Pr7GFFLF1lx10jJ3TGpYuWb4IaOq1WijaK8ZhieEca59XyG76zjOL1EhkeiefMLoKHtZrWZpuSVn1e576F2uIwzRiAp7R9YMXitf4SHxJl1hhVk0sVYLjvsU8x+P9fZRO6y1rEZDKz/T1skARzAp5tpvUMZM/N9e4mMktqjLSzLfnKpmBMpMGSWcaYhXs7tJCuAwxdEKWenzltFXjNH53wZw==
Received: from BN9PR03CA0805.namprd03.prod.outlook.com (2603:10b6:408:13f::30)
 by SJ1PR12MB6242.namprd12.prod.outlook.com (2603:10b6:a03:457::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Thu, 28 Jul
 2022 18:58:43 +0000
Received: from BN8NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13f:cafe::33) by BN9PR03CA0805.outlook.office365.com
 (2603:10b6:408:13f::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.7 via Frontend
 Transport; Thu, 28 Jul 2022 18:58:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT028.mail.protection.outlook.com (10.13.176.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5482.10 via Frontend Transport; Thu, 28 Jul 2022 18:58:42 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 28 Jul
 2022 13:58:41 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 28 Jul
 2022 11:58:40 -0700
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Thu, 28 Jul 2022 13:58:39 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next v3 03/10] sfc: ef100 representor RX top half
Date:   Thu, 28 Jul 2022 19:57:45 +0100
Message-ID: <3dd40cb839017241fe29b09c44501f37ee2a29c8.1659034549.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1659034549.git.ecree.xilinx@gmail.com>
References: <cover.1659034549.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: beb5349a-594d-4fa9-2831-08da70cb30b9
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6242:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RpK+hIyHZV7eTfRR4nMTVmgWLEBiF3sCU6ZUSlkNvyODHprRmK7JVbefTalJ5URDATOAyXi4M3a0ChNigIbKzkOhIJe+f3BVuP1A5cCDXXwaH+lo88QGBXfDSZ22sxt0ZbXHHrKo1wpjr+cgf/NMZ4QZJIhwpU1JxUZ2kIU8vwqa2tuHAyDVheBDfVNzJdb7gXQPZgxqPkhS2+Vp0zDSm2x6AQB88IS9oW8q3Z2PPriCqgTb5SYkCRvq57MOblIIAxf6wr/lE0EtVgqsSVeAHLpm5BqjLHswi6zed270yHemutRKemgRQ0ktdWBbe85pkZuLuq/T3yVtgbqxowf7T/tPjMeJz0tiCzhceRK3fkYNpexzpuASHyYH1UTioU0lz9b9ZgUk3lOs67y3G5U449DLaRnI8NsSjb/E9JLcGdpoQIik1GD4ja8y2XZ7/4o6E6bsUkcKk3MofflU6c5+q1HHJTVWuUVtyh829tGLQZF8H2xvP3aNX+8jTAsPpuEbJ7fMbz4oeIbIXdu23ZEAIm+jOm5U/a29tOsQlgf585A4ToBYtGYrSgiFWhY0FFOF80sMWYyq04gjoaIFovu0YULed7VmAZu3pNO5X3/vEg3V9JpbUmh5g9IlBh5/8iROw47WAT06EBUqfrw5ICkYuryWT+Rqj/TxwFtcJL5JKFbucQ04/IPEw7VXtOH8DNR6RUW9gcTi9wGcCaEcZS4C5+X3f/gL9QjA7elfrxvxscp83zLBHHODwXY3EzaZAPcYnlEMv3pO75rRredPInu+DhKEmtTNg7dVPjBPb7EHBGCbeCfm9pFaij65jBwS+iwRS7d44jUDEhOVTrNZFPD6OA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(136003)(396003)(39860400002)(40470700004)(36840700001)(46966006)(110136005)(55446002)(82310400005)(82740400003)(40460700003)(8936002)(5660300002)(26005)(81166007)(41300700001)(316002)(36860700001)(47076005)(2906002)(6666004)(83170400001)(42882007)(186003)(356005)(336012)(8676002)(54906003)(83380400001)(70206006)(40480700001)(478600001)(9686003)(36756003)(2876002)(4326008)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 18:58:42.3678
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: beb5349a-594d-4fa9-2831-08da70cb30b9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6242
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

Representor RX uses a NAPI context driven by a 'fake interrupt': when
 the parent PF receives a packet destined for the representor, it adds
 it to an SKB list (efv->rx_list), and schedules NAPI if the 'fake
 interrupt' is primed.  The NAPI poll then pulls packets off this list
 and feeds them to the stack with netif_receive_skb_list().
This scheme allows us to decouple representor RX from the parent PF's
 RX fast-path.
This patch implements the 'top half', which builds an SKB, copies data
 into it from the RX buffer (which can then be released), adds it to
 the queue and fires the 'fake interrupt' if necessary.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/ef100_rep.c | 55 ++++++++++++++++++++++++++++
 drivers/net/ethernet/sfc/ef100_rep.h |  1 +
 2 files changed, 56 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef100_rep.c b/drivers/net/ethernet/sfc/ef100_rep.c
index fe45ae963391..e6c6e9e764b2 100644
--- a/drivers/net/ethernet/sfc/ef100_rep.c
+++ b/drivers/net/ethernet/sfc/ef100_rep.c
@@ -13,9 +13,12 @@
 #include "ef100_netdev.h"
 #include "ef100_nic.h"
 #include "mae.h"
+#include "rx_common.h"
 
 #define EFX_EF100_REP_DRIVER	"efx_ef100_rep"
 
+#define EFX_REP_DEFAULT_PSEUDO_RING_SIZE	64
+
 static int efx_ef100_rep_poll(struct napi_struct *napi, int weight);
 
 static int efx_ef100_rep_init_struct(struct efx_nic *efx, struct efx_rep *efv,
@@ -198,6 +201,7 @@ static int efx_ef100_configure_rep(struct efx_rep *efv)
 	u32 selector;
 	int rc;
 
+	efv->rx_pring_size = EFX_REP_DEFAULT_PSEUDO_RING_SIZE;
 	/* Construct mport selector for corresponding VF */
 	efx_mae_mport_vf(efx, efv->idx, &selector);
 	/* Look up actual mport ID */
@@ -320,3 +324,54 @@ static int efx_ef100_rep_poll(struct napi_struct *napi, int weight)
 		}
 	return spent;
 }
+
+void efx_ef100_rep_rx_packet(struct efx_rep *efv, struct efx_rx_buffer *rx_buf)
+{
+	u8 *eh = efx_rx_buf_va(rx_buf);
+	struct sk_buff *skb;
+	bool primed;
+
+	/* Don't allow too many queued SKBs to build up, as they consume
+	 * GFP_ATOMIC memory.  If we overrun, just start dropping.
+	 */
+	if (efv->write_index - READ_ONCE(efv->read_index) > efv->rx_pring_size) {
+		atomic64_inc(&efv->stats.rx_dropped);
+		if (net_ratelimit())
+			netif_dbg(efv->parent, rx_err, efv->net_dev,
+				  "nodesc-dropped packet of length %u\n",
+				  rx_buf->len);
+		return;
+	}
+
+	skb = netdev_alloc_skb(efv->net_dev, rx_buf->len);
+	if (!skb) {
+		atomic64_inc(&efv->stats.rx_dropped);
+		if (net_ratelimit())
+			netif_dbg(efv->parent, rx_err, efv->net_dev,
+				  "noskb-dropped packet of length %u\n",
+				  rx_buf->len);
+		return;
+	}
+	memcpy(skb->data, eh, rx_buf->len);
+	__skb_put(skb, rx_buf->len);
+
+	skb_record_rx_queue(skb, 0); /* rep is single-queue */
+
+	/* Move past the ethernet header */
+	skb->protocol = eth_type_trans(skb, efv->net_dev);
+
+	skb_checksum_none_assert(skb);
+
+	atomic64_inc(&efv->stats.rx_packets);
+	atomic64_add(rx_buf->len, &efv->stats.rx_bytes);
+
+	/* Add it to the rx list */
+	spin_lock_bh(&efv->rx_lock);
+	primed = efv->read_index == efv->write_index;
+	list_add_tail(&skb->list, &efv->rx_list);
+	efv->write_index++;
+	spin_unlock_bh(&efv->rx_lock);
+	/* Trigger rx work */
+	if (primed)
+		napi_schedule(&efv->napi);
+}
diff --git a/drivers/net/ethernet/sfc/ef100_rep.h b/drivers/net/ethernet/sfc/ef100_rep.h
index 77037ab22052..7d2f15cee8d1 100644
--- a/drivers/net/ethernet/sfc/ef100_rep.h
+++ b/drivers/net/ethernet/sfc/ef100_rep.h
@@ -57,4 +57,5 @@ int efx_ef100_vfrep_create(struct efx_nic *efx, unsigned int i);
 void efx_ef100_vfrep_destroy(struct efx_nic *efx, struct efx_rep *efv);
 void efx_ef100_fini_vfreps(struct efx_nic *efx);
 
+void efx_ef100_rep_rx_packet(struct efx_rep *efv, struct efx_rx_buffer *rx_buf);
 #endif /* EF100_REP_H */
