Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B74643932D
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 11:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbhJYKAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 06:00:03 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42458 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232713AbhJYJ7f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 05:59:35 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19P9XBHk000793;
        Mon, 25 Oct 2021 09:57:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=feTOol3MkVvExu4/U6tP8c9PLGo5c83GJiSpB/2+SlY=;
 b=W4PGmxSsJzHH3hkQk364sECIqnV9+zGyVwLipsUElJ0AwBmUY0TegV/PA21ZNz1u73Bm
 5A9KuU67C13ibZVuAsh+b5oYXFgLbhzN5pppzNocws7gKfqLuMdHN10ij77MGKwVbeFH
 udYkDs3vYXAC/s+NH+35zkCqmE715C7oLwwdRgd39wolLm8hNi4pyl4g9hcAOsBgtmEz
 c7eRyTHZUBaxepGMqveip5LkYZvwuAgDR9P/PvUPIym4FYwPl1aB6Rc+iv9DoLtTNJY7
 o3NdmoP4eOLAvJAQ9+gzlLmz+VITwCDZIAfdsNRHoAk+8FI9DzYj2otDLSZyY7cP4sHR tA== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bwt23gfsg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 09:57:10 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19P9h4s6010017;
        Mon, 25 Oct 2021 09:57:09 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3bva19m9c7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 09:57:08 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19P9v5J140894882
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Oct 2021 09:57:05 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9015F11C058;
        Mon, 25 Oct 2021 09:57:05 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4DE0411C05C;
        Mon, 25 Oct 2021 09:57:05 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 25 Oct 2021 09:57:05 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 4/9] s390/qeth: clarify remaining dev_kfree_skb_any() users
Date:   Mon, 25 Oct 2021 11:56:53 +0200
Message-Id: <20211025095658.3527635-5-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211025095658.3527635-1-jwi@linux.ibm.com>
References: <20211025095658.3527635-1-jwi@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: esEEAUM-mNJNYtgcaxYeyWTIL4jDOK2a
X-Proofpoint-ORIG-GUID: esEEAUM-mNJNYtgcaxYeyWTIL4jDOK2a
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-25_03,2021-10-25_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 impostorscore=0 malwarescore=0 mlxscore=0 spamscore=0 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110250058
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For none of the users we are under risk of running in HW IRQ context or
or with IRQs disabled. Thus we always end up in consume_skb().

But the two occurences in the RX path should really report the dropped
packet to dropmon, so have them use kfree_skb() instead. That's also
consistent with what napi_free_frags() does internally.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 48dea62bdaa4..d6230e4e8b1c 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -2630,7 +2630,7 @@ static void qeth_free_qdio_queues(struct qeth_card *card)
 	qeth_free_cq(card);
 	for (j = 0; j < QDIO_MAX_BUFFERS_PER_Q; ++j) {
 		if (card->qdio.in_q->bufs[j].rx_skb)
-			dev_kfree_skb_any(card->qdio.in_q->bufs[j].rx_skb);
+			consume_skb(card->qdio.in_q->bufs[j].rx_skb);
 	}
 	qeth_free_qdio_queue(card->qdio.in_q);
 	card->qdio.in_q = NULL;
@@ -5606,7 +5606,7 @@ static void qeth_receive_skb(struct qeth_card *card, struct sk_buff *skb,
 		if (uses_frags)
 			napi_free_frags(napi);
 		else
-			dev_kfree_skb_any(skb);
+			kfree_skb(skb);
 		return;
 	}
 
@@ -5797,7 +5797,7 @@ static int qeth_extract_skb(struct qeth_card *card,
 					if (uses_frags)
 						napi_free_frags(napi);
 					else
-						dev_kfree_skb_any(skb);
+						kfree_skb(skb);
 					QETH_CARD_STAT_INC(card,
 							   rx_length_errors);
 				}
-- 
2.25.1

