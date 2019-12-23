Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2D712973A
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 15:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbfLWOWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 09:22:38 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60864 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726795AbfLWOWh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 09:22:37 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBNEK0FF118322
        for <netdev@vger.kernel.org>; Mon, 23 Dec 2019 09:22:35 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2x21qpdyny-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 23 Dec 2019 09:22:35 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Mon, 23 Dec 2019 14:22:33 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 23 Dec 2019 14:22:31 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBNEMTP246399560
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Dec 2019 14:22:30 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D27574C04E;
        Mon, 23 Dec 2019 14:22:29 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9DE234C046;
        Mon, 23 Dec 2019 14:22:29 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 23 Dec 2019 14:22:29 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 3/3] s390/qeth: remove QETH_RX_PULL_LEN
Date:   Mon, 23 Dec 2019 15:22:27 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191223142227.19500-1-jwi@linux.ibm.com>
References: <20191223142227.19500-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19122314-0028-0000-0000-000003CB504A
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19122314-0029-0000-0000-0000248EAB6A
Message-Id: <20191223142227.19500-4-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-23_06:2019-12-23,2019-12-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 mlxscore=0 spamscore=0
 impostorscore=0 bulkscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912230123
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit f677fcb9aeb6 ("s390/qeth: ensure linear access to packet headers"),
the CQ-specific skbs are allocated with a slightly bigger linear part
than necessary. Shrink it down to the maximum that's needed by
qeth_extract_skb().

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      | 1 -
 drivers/s390/net/qeth_core_main.c | 6 ++++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 4ab3be814ea7..7c37e94fb28b 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -221,7 +221,6 @@ struct qeth_vnicc_info {
 
 /* large receive scatter gather copy break */
 #define QETH_RX_SG_CB (PAGE_SIZE >> 1)
-#define QETH_RX_PULL_LEN 256
 
 struct qeth_hdr_layer3 {
 	__u8  id;
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index b32b50384c5c..3be3d13f8d65 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -2627,7 +2627,8 @@ static int qeth_init_input_buffer(struct qeth_card *card,
 
 	if ((card->options.cq == QETH_CQ_ENABLED) && (!buf->rx_skb)) {
 		buf->rx_skb = netdev_alloc_skb(card->dev,
-					       QETH_RX_PULL_LEN + ETH_HLEN);
+					       ETH_HLEN +
+					       sizeof(struct ipv6hdr));
 		if (!buf->rx_skb)
 			return 1;
 	}
@@ -5264,7 +5265,8 @@ static int qeth_extract_skb(struct qeth_card *card,
 
 	if (use_rx_sg) {
 		/* QETH_CQ_ENABLED only: */
-		if (qethbuffer->rx_skb) {
+		if (qethbuffer->rx_skb &&
+		    skb_tailroom(qethbuffer->rx_skb) >= linear_len + headroom) {
 			skb = qethbuffer->rx_skb;
 			qethbuffer->rx_skb = NULL;
 			goto use_skb;
-- 
2.17.1

