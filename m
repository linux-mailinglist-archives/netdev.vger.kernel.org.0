Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC8BC60BE6F
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 01:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbiJXXSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 19:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231372AbiJXXS0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 19:18:26 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A68D2E2B8C
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 14:39:06 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29OLT9SJ027200
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 21:38:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=A1Ws/zUI06kRpnv7pgaN0krEHxAIf3tqtxxzERgSgGk=;
 b=WG9SpPvz6OF8nXGaFZ/pxtLL9C59BrTlDfcMtAk0Pa3xgWgDImsqIogCsZl3pxRU9XGr
 kOPf0xLXpV6zrn0zCQsEbJ2ZhGH25jODynR1J3uWkInPoaKVrKJ/8+FLVpdOUeQJ6UfK
 fC7tLj0IGURijt8Cx+aiLMPVFp+mypH1W7+pOMj64SNjWO6VhNrtZhO5wsVSdgwWq6/Q
 0UC/vX3uUKAaD8g+gyk1wVGYtlUdSz1XTH52XGZPoAT2r3Fcnj5HvoahyhdGhU0iPkt0
 zB2qNIzSd2pZQuspZMjPsQLC7VDtbwUiUKn1W8h455xIR7cRGEw66dhBDLUalUu5ZAV9 Kw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ke2npg8y4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 21:38:48 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29OLU3km030675
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 21:38:47 GMT
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ke2npg8xn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Oct 2022 21:38:47 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29OLZlRR022365;
        Mon, 24 Oct 2022 21:38:46 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma01wdc.us.ibm.com with ESMTP id 3kc8594web-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Oct 2022 21:38:46 +0000
Received: from smtpav02.dal12v.mail.ibm.com ([9.208.128.128])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29OLcj8q2622148
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 21:38:46 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3BB0A5805A;
        Mon, 24 Oct 2022 21:38:44 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 91EB258062;
        Mon, 24 Oct 2022 21:38:43 +0000 (GMT)
Received: from li-8d37cfcc-31b9-11b2-a85c-83226d7135c9.ibm.com (unknown [9.65.197.49])
        by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 24 Oct 2022 21:38:43 +0000 (GMT)
From:   Nick Child <nnac123@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     nick.child@ibm.com, dave.taht@gmail.com,
        Nick Child <nnac123@linux.ibm.com>
Subject: [RFC PATCH net-next 1/1] ibmveth: Implement BQL
Date:   Mon, 24 Oct 2022 16:38:28 -0500
Message-Id: <20221024213828.320219-2-nnac123@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221024213828.320219-1-nnac123@linux.ibm.com>
References: <20221024213828.320219-1-nnac123@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: TtWQQOTLQls3z1_j9u_EDXIkT8d3xUmf
X-Proofpoint-ORIG-GUID: X1mW7QC2fRbQQ_PDVXopZBp-w_2wg7s3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-24_07,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 lowpriorityscore=0 impostorscore=0 malwarescore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 phishscore=0 suspectscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210240129
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Byte Queue Limits allows for dynamic size management of transmit
queues. By informing the higher-level networking layers about in-flight
transmissions, the number queued bytes will be optimized for better
performance and minimal buffer-bloat.

Since the ibmveth driver does not have an irq to receive packet
completion information from firmware, assume the packet has completed
transmission when the hypervisor call H_SEND_LOGICAL_LAN returns.

Signed-off-by: Nick Child <nnac123@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmveth.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index 3b14dc93f59d..1290848e2e2b 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -578,6 +578,7 @@ static int ibmveth_open(struct net_device *netdev)
 	}
 
 	for (i = 0; i < netdev->real_num_tx_queues; i++) {
+		netdev_tx_reset_queue(netdev_get_tx_queue(netdev, i));
 		if (ibmveth_allocate_tx_ltb(adapter, i))
 			goto out_free_tx_ltb;
 	}
@@ -1027,8 +1028,10 @@ static int ibmveth_set_channels(struct net_device *netdev,
 			continue;
 
 		rc = ibmveth_allocate_tx_ltb(adapter, i);
-		if (!rc)
+		if (!rc) {
+			netdev_tx_reset_queue(netdev_get_tx_queue(netdev, i));
 			continue;
+		}
 
 		/* if something goes wrong, free everything we just allocated */
 		netdev_err(netdev, "Failed to allocate more tx queues, returning to %d queues\n",
@@ -1125,6 +1128,7 @@ static netdev_tx_t ibmveth_start_xmit(struct sk_buff *skb,
 	union ibmveth_buf_desc desc;
 	int i, queue_num = skb_get_queue_mapping(skb);
 	unsigned long mss = 0;
+	struct netdev_queue *txq = netdev_get_tx_queue(netdev, queue_num);
 
 	if (ibmveth_is_packet_unsupported(skb, netdev))
 		goto out;
@@ -1202,6 +1206,7 @@ static netdev_tx_t ibmveth_start_xmit(struct sk_buff *skb,
 	/* finish writing to long_term_buff before VIOS accessing it */
 	dma_wmb();
 
+	netdev_tx_sent_queue(txq, skb->len);
 	if (ibmveth_send(adapter, desc.desc, mss)) {
 		adapter->tx_send_failed++;
 		netdev->stats.tx_dropped++;
@@ -1209,6 +1214,7 @@ static netdev_tx_t ibmveth_start_xmit(struct sk_buff *skb,
 		netdev->stats.tx_packets++;
 		netdev->stats.tx_bytes += skb->len;
 	}
+	netdev_tx_completed_queue(txq, 1, skb->len);
 
 out:
 	dev_consume_skb_any(skb);
-- 
2.31.1

