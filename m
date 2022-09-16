Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 870515BB306
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 21:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbiIPTyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 15:54:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbiIPTx7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 15:53:59 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C65F4B959D
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 12:53:51 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28GJo0iw003439;
        Fri, 16 Sep 2022 19:53:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=SaJLns5srCbScECtBqEK6CjVBbStyT/A9rb0liiOy7Y=;
 b=nfPbSjkGqm3wZwGtr8ITgXqskgMOUShuoFYBSd4rFLjOE79/u6HA5/lalw4EHk0Hcmt2
 HDmI+6ORK5TcPVox8UMKVEgP77+Ez+DouVBJauhvxYLJ5ruVt3OqrGG1CPPTtujjkgB0
 YKTHrAOhaUd+ujzKWvwDLpIgrjpy1P76mDqm77oaHwWCEzHFyhu0VfcaKKSgkkqr8fYw
 mBZ+dK/NazFf+VVzBZ/5FSLixEWpMe0xMK9YaJBCE5QAAoXS15uuMFCndsYTpM5B8l3U
 UAnkDeuYbE8oTjI1up7MsypiTFq7OCIoOehrdW1lAys6DPYNpXD6QnSLn/S4PSDHVHn1 FA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3jmyn1024n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 16 Sep 2022 19:53:39 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28GJo456004766;
        Fri, 16 Sep 2022 19:53:38 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3jmyn1024b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 16 Sep 2022 19:53:38 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28GJpFsx032493;
        Fri, 16 Sep 2022 19:53:37 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma02wdc.us.ibm.com with ESMTP id 3jm91cpuwm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 16 Sep 2022 19:53:37 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28GJrcNg9765518
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Sep 2022 19:53:38 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 73D07136059;
        Fri, 16 Sep 2022 19:53:36 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E1FB3136053;
        Fri, 16 Sep 2022 19:53:35 +0000 (GMT)
Received: from ltc17u3.stglabs.ibm.com (unknown [9.114.219.126])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 16 Sep 2022 19:53:35 +0000 (GMT)
From:   Thinh Tran <thinhtr@linux.vnet.ibm.com>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, aelior@marvell.com, davem@davemloft.net,
        manishc@marvell.com, skalluru@marvell.com, pabeni@redhat.com,
        edumazet@google.com, Thinh Tran <thinhtr@linux.vnet.ibm.com>
Subject: [PATCH v2] bnx2x: Fix error recovering in switch configuration
Date:   Fri, 16 Sep 2022 19:51:14 +0000
Message-Id: <20220916195114.2474829-1-thinhtr@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220826184440.37e7cb85@kernel.org>
References: <20220826184440.37e7cb85@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ARkno1oyDsewmP30ALWjKsrYDgy-FudF
X-Proofpoint-GUID: U9v7lL8bdm-I5UDlD418hMNrUbSOmz6M
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-16_12,2022-09-16_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 priorityscore=1501 adultscore=0 phishscore=0 lowpriorityscore=0
 impostorscore=0 mlxscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209160140
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As the BCM57810 and other I/O adapters are connected
through a PCIe switch, the bnx2x driver causes unexpected
system hang/crash while handling PCIe switch errors, if
its error handler is called after other drivers' handlers.

In this case, after numbers of bnx2x_tx_timout(), the
bnx2x_nic_unload() is  called, frees up resources and
calls bnx2x_napi_disable(). Then when EEH calls its
error handler, the bnx2x_io_error_detected() and
bnx2x_io_slot_reset() also calling bnx2x_napi_disable()
and freeing the resources.

Signed-off-by: Thinh Tran <thinhtr@linux.vnet.ibm.com>

 v2:
   - Check the state of the NIC before calling disable nappi
     and freeing the IRQ
   - Prevent recurrence of TX timeout by turning off the carrier,
     calling netif_carrier_off() in bnx2x_tx_timeout()
   - Check and bail out early if fp->page_pool already freed
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h   |  2 +
 .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.c   | 27 +++++++++----
 .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.h   |  3 ++
 .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  | 38 +++++++++----------
 .../net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c  | 17 +++++----
 5 files changed, 53 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
index dd5945c4bfec..11280f0eb75b 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
@@ -1509,6 +1509,8 @@ struct bnx2x {
 	bool			cnic_loaded;
 	struct cnic_eth_dev	*(*cnic_probe)(struct net_device *);
 
+	bool			nic_stopped;
+
 	/* Flag that indicates that we can start looking for FCoE L2 queue
 	 * completions in the default status block.
 	 */
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index 712b5595bc39..7ba53ce1d09e 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -2705,6 +2705,7 @@ int bnx2x_nic_load(struct bnx2x *bp, int load_mode)
 	bnx2x_add_all_napi(bp);
 	DP(NETIF_MSG_IFUP, "napi added\n");
 	bnx2x_napi_enable(bp);
+	bp->nic_stopped = false;
 
 	if (IS_PF(bp)) {
 		/* set pf load just before approaching the MCP */
@@ -2950,6 +2951,7 @@ int bnx2x_nic_load(struct bnx2x *bp, int load_mode)
 load_error1:
 	bnx2x_napi_disable(bp);
 	bnx2x_del_all_napi(bp);
+	bp->nic_stopped = true;
 
 	/* clear pf_load status, as it was already set */
 	if (IS_PF(bp))
@@ -3085,14 +3087,17 @@ int bnx2x_nic_unload(struct bnx2x *bp, int unload_mode, bool keep_link)
 		if (!CHIP_IS_E1x(bp))
 			bnx2x_pf_disable(bp);
 
-		/* Disable HW interrupts, NAPI */
-		bnx2x_netif_stop(bp, 1);
-		/* Delete all NAPI objects */
-		bnx2x_del_all_napi(bp);
-		if (CNIC_LOADED(bp))
-			bnx2x_del_all_napi_cnic(bp);
-		/* Release IRQs */
-		bnx2x_free_irq(bp);
+		if (!bp->nic_stopped) {
+			/* Disable HW interrupts, NAPI */
+			bnx2x_netif_stop(bp, 1);
+			/* Delete all NAPI objects */
+			bnx2x_del_all_napi(bp);
+			if (CNIC_LOADED(bp))
+				bnx2x_del_all_napi_cnic(bp);
+			/* Release IRQs */
+			bnx2x_free_irq(bp);
+			bp->nic_stopped = true;
+		}
 
 		/* Report UNLOAD_DONE to MCP */
 		bnx2x_send_unload_done(bp, false);
@@ -4977,6 +4982,12 @@ void bnx2x_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 	struct bnx2x *bp = netdev_priv(dev);
 
+	/* Immediately indicate link as down */
+	bp->link_vars.link_up = 0;
+	bp->force_link_down = true;
+	netif_carrier_off(dev);
+	BNX2X_ERR("Indicating link is down due to Tx-timeout\n");
+
 	/* We want the information of the dump logged,
 	 * but calling bnx2x_panic() would kill all chances of recovery.
 	 */
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h
index d8b1824c334d..bc0dee25b804 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h
@@ -1015,6 +1015,9 @@ static inline void bnx2x_free_rx_sge_range(struct bnx2x *bp,
 {
 	int i;
 
+	if (!fp->page_pool.page)
+		return;
+
 	if (fp->mode == TPA_MODE_DISABLED)
 		return;
 
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index 962253db25b8..3129a3372f8b 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -9475,15 +9475,18 @@ void bnx2x_chip_cleanup(struct bnx2x *bp, int unload_mode, bool keep_link)
 		}
 	}
 
-	/* Disable HW interrupts, NAPI */
-	bnx2x_netif_stop(bp, 1);
-	/* Delete all NAPI objects */
-	bnx2x_del_all_napi(bp);
-	if (CNIC_LOADED(bp))
-		bnx2x_del_all_napi_cnic(bp);
+	if (!bp->nic_stopped) {
+		/* Disable HW interrupts, NAPI */
+		bnx2x_netif_stop(bp, 1);
+		/* Delete all NAPI objects */
+		bnx2x_del_all_napi(bp);
+		if (CNIC_LOADED(bp))
+			bnx2x_del_all_napi_cnic(bp);
 
-	/* Release IRQs */
-	bnx2x_free_irq(bp);
+		/* Release IRQs */
+		bnx2x_free_irq(bp);
+		bp->nic_stopped = true;
+	}
 
 	/* Reset the chip, unless PCI function is offline. If we reach this
 	 * point following a PCI error handling, it means device is really
@@ -10274,12 +10277,6 @@ static void bnx2x_sp_rtnl_task(struct work_struct *work)
 		bp->sp_rtnl_state = 0;
 		smp_mb();
 
-		/* Immediately indicate link as down */
-		bp->link_vars.link_up = 0;
-		bp->force_link_down = true;
-		netif_carrier_off(bp->dev);
-		BNX2X_ERR("Indicating link is down due to Tx-timeout\n");
-
 		bnx2x_nic_unload(bp, UNLOAD_NORMAL, true);
 		/* When ret value shows failure of allocation failure,
 		 * the nic is rebooted again. If open still fails, a error
@@ -14256,13 +14253,16 @@ static pci_ers_result_t bnx2x_io_slot_reset(struct pci_dev *pdev)
 		}
 		bnx2x_drain_tx_queues(bp);
 		bnx2x_send_unload_req(bp, UNLOAD_RECOVERY);
-		bnx2x_netif_stop(bp, 1);
-		bnx2x_del_all_napi(bp);
+		if (!bp->nic_stopped) {
+			bnx2x_netif_stop(bp, 1);
+			bnx2x_del_all_napi(bp);
 
-		if (CNIC_LOADED(bp))
-			bnx2x_del_all_napi_cnic(bp);
+			if (CNIC_LOADED(bp))
+				bnx2x_del_all_napi_cnic(bp);
 
-		bnx2x_free_irq(bp);
+			bnx2x_free_irq(bp);
+			bp->nic_stopped = true;
+		}
 
 		/* Report UNLOAD_DONE to MCP */
 		bnx2x_send_unload_done(bp, true);
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c
index c9129b9ba446..1f94f7987470 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c
@@ -529,13 +529,16 @@ void bnx2x_vfpf_close_vf(struct bnx2x *bp)
 	bnx2x_vfpf_finalize(bp, &req->first_tlv);
 
 free_irq:
-	/* Disable HW interrupts, NAPI */
-	bnx2x_netif_stop(bp, 0);
-	/* Delete all NAPI objects */
-	bnx2x_del_all_napi(bp);
-
-	/* Release IRQs */
-	bnx2x_free_irq(bp);
+	if (!bp->nic_stopped) {
+		/* Disable HW interrupts, NAPI */
+		bnx2x_netif_stop(bp, 0);
+		/* Delete all NAPI objects */
+		bnx2x_del_all_napi(bp);
+
+		/* Release IRQs */
+		bnx2x_free_irq(bp);
+		bp->nic_stopped = true;
+	}
 }
 
 static void bnx2x_leading_vfq_init(struct bnx2x *bp, struct bnx2x_virtf *vf,
-- 
2.25.1

