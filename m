Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 181724FFC22
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 19:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237213AbiDMRNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 13:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237342AbiDMRMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 13:12:53 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D1471B7A8
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 10:10:32 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23DH3drt010450
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 17:10:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=gR8AcsJhyNWESzaECLasD0sHPSEI5exghxZqnodHXQs=;
 b=lsE4mcMjBr3PNmfaWgw1I7pTK+RKhOpMvm5/D1zp1/8FzDT7oJKyD+TagZqd1mPcsGtW
 rQW495fyiYTaaeSARVqtAW2dpuFWhEPEooKIoU612GxyU9lc3cklVtbK2y2Ras+l08+c
 5CEys1Jm0Qn5SLXzOAB2Rhf6l2KjslsyLYMIt5t+avVPEwb88Ipfr3qSpb6CuulAVrS9
 ml7Gb8di2gPsnq3n0Mrt73C89KHazOri+hQXHeWS/TmdjS24YR8K9kIdBywkFVRTcdAH
 PfsprNOQKOixV8Unt97cFCPjs3dQbEEv5ljUdo3oxsqcjxD/AeJtgR31aQCvLZl/7lDS DA== 
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fe2k30569-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 17:10:31 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23DGraD2025062
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 17:10:30 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma05wdc.us.ibm.com with ESMTP id 3fb1s9sgj0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 17:10:30 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23DHATe433030614
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Apr 2022 17:10:30 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D9604124062;
        Wed, 13 Apr 2022 17:10:29 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9C6D1124053;
        Wed, 13 Apr 2022 17:10:29 +0000 (GMT)
Received: from ltcden12-lp23.aus.stglabs.ibm.com (unknown [9.40.195.166])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 13 Apr 2022 17:10:29 +0000 (GMT)
From:   Dany Madden <drt@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     sukadev@linux.ibm.com
Subject: [PATCH net-next 1/6] ibmvnic: rename local variable index to bufidx
Date:   Wed, 13 Apr 2022 13:10:21 -0400
Message-Id: <20220413171026.1264294-2-drt@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220413171026.1264294-1-drt@linux.ibm.com>
References: <20220413171026.1264294-1-drt@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 9g-EdAuzcY4E6vVPjjX7QdsrLpv7XGHA
X-Proofpoint-ORIG-GUID: 9g-EdAuzcY4E6vVPjjX7QdsrLpv7XGHA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-13_03,2022-04-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 malwarescore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 clxscore=1015
 phishscore=0 mlxlogscore=999 priorityscore=1501 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204130086
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.ibm.com>

The local variable 'index' is heavily used in some functions and is
confusing with the presence of other "index" fields like pool->index,
->consumer_index, etc. Rename it to bufidx to better reflect that its
the index of a buffer in the pool.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Signed-off-by: Dany Madden <drt@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 44 +++++++++++++++---------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 77683909ca3d..7fd9dd3759df 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -369,7 +369,7 @@ static void replenish_rx_pool(struct ibmvnic_adapter *adapter,
 	dma_addr_t dma_addr;
 	unsigned char *dst;
 	int shift = 0;
-	int index;
+	int bufidx;
 	int i;
 
 	if (!pool->active)
@@ -385,14 +385,14 @@ static void replenish_rx_pool(struct ibmvnic_adapter *adapter,
 	 * be 0.
 	 */
 	for (i = ind_bufp->index; i < count; ++i) {
-		index = pool->free_map[pool->next_free];
+		bufidx = pool->free_map[pool->next_free];
 
 		/* We maybe reusing the skb from earlier resets. Allocate
 		 * only if necessary. But since the LTB may have changed
 		 * during reset (see init_rx_pools()), update LTB below
 		 * even if reusing skb.
 		 */
-		skb = pool->rx_buff[index].skb;
+		skb = pool->rx_buff[bufidx].skb;
 		if (!skb) {
 			skb = netdev_alloc_skb(adapter->netdev,
 					       pool->buff_size);
@@ -407,24 +407,24 @@ static void replenish_rx_pool(struct ibmvnic_adapter *adapter,
 		pool->next_free = (pool->next_free + 1) % pool->size;
 
 		/* Copy the skb to the long term mapped DMA buffer */
-		offset = index * pool->buff_size;
+		offset = bufidx * pool->buff_size;
 		dst = pool->long_term_buff.buff + offset;
 		memset(dst, 0, pool->buff_size);
 		dma_addr = pool->long_term_buff.addr + offset;
 
 		/* add the skb to an rx_buff in the pool */
-		pool->rx_buff[index].data = dst;
-		pool->rx_buff[index].dma = dma_addr;
-		pool->rx_buff[index].skb = skb;
-		pool->rx_buff[index].pool_index = pool->index;
-		pool->rx_buff[index].size = pool->buff_size;
+		pool->rx_buff[bufidx].data = dst;
+		pool->rx_buff[bufidx].dma = dma_addr;
+		pool->rx_buff[bufidx].skb = skb;
+		pool->rx_buff[bufidx].pool_index = pool->index;
+		pool->rx_buff[bufidx].size = pool->buff_size;
 
 		/* queue the rx_buff for the next send_subcrq_indirect */
 		sub_crq = &ind_bufp->indir_arr[ind_bufp->index++];
 		memset(sub_crq, 0, sizeof(*sub_crq));
 		sub_crq->rx_add.first = IBMVNIC_CRQ_CMD;
 		sub_crq->rx_add.correlator =
-		    cpu_to_be64((u64)&pool->rx_buff[index]);
+		    cpu_to_be64((u64)&pool->rx_buff[bufidx]);
 		sub_crq->rx_add.ioba = cpu_to_be32(dma_addr);
 		sub_crq->rx_add.map_id = pool->long_term_buff.map_id;
 
@@ -466,10 +466,10 @@ static void replenish_rx_pool(struct ibmvnic_adapter *adapter,
 		sub_crq = &ind_bufp->indir_arr[i];
 		rx_buff = (struct ibmvnic_rx_buff *)
 				be64_to_cpu(sub_crq->rx_add.correlator);
-		index = (int)(rx_buff - pool->rx_buff);
-		pool->free_map[pool->next_free] = index;
-		dev_kfree_skb_any(pool->rx_buff[index].skb);
-		pool->rx_buff[index].skb = NULL;
+		bufidx = (int)(rx_buff - pool->rx_buff);
+		pool->free_map[pool->next_free] = bufidx;
+		dev_kfree_skb_any(pool->rx_buff[bufidx].skb);
+		pool->rx_buff[bufidx].skb = NULL;
 	}
 	adapter->replenish_add_buff_failure += ind_bufp->index;
 	atomic_add(buffers_added, &pool->available);
@@ -1926,7 +1926,7 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 	unsigned int offset;
 	int num_entries = 1;
 	unsigned char *dst;
-	int index = 0;
+	int bufidx = 0;
 	u8 proto = 0;
 
 	/* If a reset is in progress, drop the packet since
@@ -1960,9 +1960,9 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 	else
 		tx_pool = &adapter->tx_pool[queue_num];
 
-	index = tx_pool->free_map[tx_pool->consumer_index];
+	bufidx = tx_pool->free_map[tx_pool->consumer_index];
 
-	if (index == IBMVNIC_INVALID_MAP) {
+	if (bufidx == IBMVNIC_INVALID_MAP) {
 		dev_kfree_skb_any(skb);
 		tx_send_failed++;
 		tx_dropped++;
@@ -1973,7 +1973,7 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 
 	tx_pool->free_map[tx_pool->consumer_index] = IBMVNIC_INVALID_MAP;
 
-	offset = index * tx_pool->buf_size;
+	offset = bufidx * tx_pool->buf_size;
 	dst = tx_pool->long_term_buff.buff + offset;
 	memset(dst, 0, tx_pool->buf_size);
 	data_dma_addr = tx_pool->long_term_buff.addr + offset;
@@ -2003,9 +2003,9 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 	tx_pool->consumer_index =
 	    (tx_pool->consumer_index + 1) % tx_pool->num_buffers;
 
-	tx_buff = &tx_pool->tx_buff[index];
+	tx_buff = &tx_pool->tx_buff[bufidx];
 	tx_buff->skb = skb;
-	tx_buff->index = index;
+	tx_buff->index = bufidx;
 	tx_buff->pool_index = queue_num;
 
 	memset(&tx_crq, 0, sizeof(tx_crq));
@@ -2017,9 +2017,9 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 
 	if (skb_is_gso(skb))
 		tx_crq.v1.correlator =
-			cpu_to_be32(index | IBMVNIC_TSO_POOL_MASK);
+			cpu_to_be32(bufidx | IBMVNIC_TSO_POOL_MASK);
 	else
-		tx_crq.v1.correlator = cpu_to_be32(index);
+		tx_crq.v1.correlator = cpu_to_be32(bufidx);
 	tx_crq.v1.dma_reg = cpu_to_be16(tx_pool->long_term_buff.map_id);
 	tx_crq.v1.sge_len = cpu_to_be32(skb->len);
 	tx_crq.v1.ioba = cpu_to_be64(data_dma_addr);
-- 
2.27.0

