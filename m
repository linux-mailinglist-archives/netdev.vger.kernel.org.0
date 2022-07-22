Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA89657E414
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 18:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235386AbiGVQGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 12:06:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235178AbiGVQGX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 12:06:23 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2064.outbound.protection.outlook.com [40.107.223.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D93712C11A
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 09:06:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WGOPDdWrfeUb7CXuLTQ4Os5zAbpEkgTBr6hOFQ6WKnvfOCOMj26m08kFOvMqJHpy1OLveMHnknICXEdItFJQuZ6ELf+CwD7yePr7ohWk8wOZ1UCgzknh20EFC/7w95AYBs2pWIwG8/a3O6QtrZ2cAiiPF+o40hAHQewE1DGMUKHXJPN52TcSj0EoK/o8NBHAZ70X3ZfuypSxJ0EU+36Zr4pZU0K3ucISdjOn9VD+MRloV4/ArnL38pEFGPV0dS/JFZQxyXi6AIhytQuwGep2UEzkxqs28sFDsAnOx2+nCB57RNwrh2BGpp0ATrHPk7IRVLOCpw+ZOUX/GP4W4U0Xnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g1BOn3ovXjF5eBdA59lopxEnBIhV4f4pluGlLUojo/Q=;
 b=eE7KTg/OJIUBesFKOB3vdHeXKiDmn68JB+vcGqddIkU3XME8DyReogPh3Tx/62uYs9jbwBzXnGr4MlxASLj582eZUDC+y0bronpmptlO+qIhSr6M88E6x2aKL1yNeRcqTOonw6o2GFBKmd9x/gmdksrLtg84iJnC91sJEVkZyZrHtX7Mj+kTBCp7zgLG1kkej2ksgpVHoqlrhBbKBzJ5uoSyEeyQ2+3VuA3l7ULIUW5y1Bnp893hz+2Ag/DPi2rmKca2O9lvvXflGks0Wz0c4QblTdWm5DRJ5x/E18bSl8T0aebqaZr+3ZmGSBv+ob5d+aM5Q1aEQLj4rdIHXl2RPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g1BOn3ovXjF5eBdA59lopxEnBIhV4f4pluGlLUojo/Q=;
 b=YmupYILueOvhPxjl8PoUjtcS4ru8LvbpCEN4JasaCSB/GEPb8+7n6EpjpqQVmklKDqJicvCUJEnMd5E3hOVwNx64f4yuI+lxKrR+TyOwHKAzTxDrcXWgwmVtY9aqj6Dxj0gSJznYc0T6UU9MpqcD7cXmuLX0pG8bnkBQTGfDp/9O/n0Te+VSjkuQpp/ZGkyvA9qsfQ0SRsPseciF/lAu/gHa+1EtChO00c0SG4/PNPbtJgVULPXh6VFOz9vYLG8tj+WxJ7JhhCf6rvoKkpfHiIfbTVGpew7nuHl4WmYxU5ntDM4oM1+fvdIEZZ2iYxP9IVBIyuEYXmCASEgGWLYp6Q==
Received: from DM6PR05CA0048.namprd05.prod.outlook.com (2603:10b6:5:335::17)
 by BY5PR12MB5016.namprd12.prod.outlook.com (2603:10b6:a03:1c5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Fri, 22 Jul
 2022 16:06:20 +0000
Received: from DM6NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:335:cafe::b4) by DM6PR05CA0048.outlook.office365.com
 (2603:10b6:5:335::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.1 via Frontend
 Transport; Fri, 22 Jul 2022 16:06:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT046.mail.protection.outlook.com (10.13.172.121) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5458.17 via Frontend Transport; Fri, 22 Jul 2022 16:06:20 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 22 Jul
 2022 11:06:19 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 22 Jul
 2022 11:06:19 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Fri, 22 Jul 2022 11:06:18 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next 03/14] sfc: ef100 representor RX top half
Date:   Fri, 22 Jul 2022 17:04:12 +0100
Message-ID: <2d013b34ed5b5f2299daed10e99ffee0eae96a56.1658497661.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1658497661.git.ecree.xilinx@gmail.com>
References: <cover.1658497661.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3b1a2613-c3ac-4695-9b17-08da6bfc1dbd
X-MS-TrafficTypeDiagnostic: BY5PR12MB5016:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NFRmb4YXPY5a9pBW5KfBiRWfmb2PLGD5vDyOwE9fv7GolL+0opRnDerR5e3A4PmO/SOwJ5MYb90M9HVwD2byrph+P5UkUmEcaAB2sfNuo83GihBCBfFMlke5diKC5NA5SIZLpihfAmjSTR0pf/i9gr4Pdd0ntkH5e6j2td4cIPoNePsqI8wCQq3ZVMRu9iTwS9jdHLEhK5C6ClFvawgOVW62Bj5QrAfNwI5522HWtAkjLEJngyiMRPwZX8hr5RN2Ci68YjDAB4ay8fGDbvGVevGoDvEaQ186+uCAFU9blwYc0KvtlvleRJO6lsVTgIlXGQCtL910Ru6JF0ncjYPwvV5si4bbxWx8wbGudn+VmySq4j3JeWTOUZipG/uQQ3HD7GllEmBkCqpnjj62hbzIlIYj7Qp9aBbgMVciyiJbjEQiFOqyVMhoAze105a2mL/rAErAWWAhO1+bs5fudFzHa/tMr0P+SCAVCgajhDvZAQknQGWcBBfCQgSqsa033nWPW4KPC3DHn6+1tgniSagOjzqhzjYp+emErfvKnR0ZEVdWzAeIR+6bSyl8bKqiAigEZ0aZtakmSWtVKQci/OAjzoW2sRWnQ/QcSs0GrHErDlgRZeNqRPwA7nZWnutMl+17hUZiSBXuSrfAaROGDbm/Ukf+u9XRa4rQQ932lNHR98fy9HWkLji0fUpQFilcfX35VTEPaZT2Xp8A9XSHH0rkGuUt0up/Xl3cVq8UpWtdhCQhInaa0mgj0SQAG70KzeaD9IIOk4ugLqzxRJG3g4iTwlpoTrcLuurSPDJcz0oCTZ/bNbCtXZEywoRs+EiYPkWGq54H7SYe2/UpZUDNJC99FQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(136003)(346002)(39860400002)(40470700004)(36840700001)(46966006)(336012)(47076005)(186003)(36860700001)(356005)(83170400001)(82740400003)(55446002)(36756003)(41300700001)(478600001)(316002)(6666004)(54906003)(26005)(110136005)(42882007)(81166007)(9686003)(70586007)(2876002)(82310400005)(4326008)(8936002)(40460700003)(40480700001)(5660300002)(8676002)(2906002)(70206006)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2022 16:06:20.0148
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b1a2613-c3ac-4695-9b17-08da6bfc1dbd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB5016
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
