Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7A33A3D40
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 09:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbhFKHgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 03:36:05 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:21982 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231366AbhFKHfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 03:35:55 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15B7Xgo3090952;
        Fri, 11 Jun 2021 03:33:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Mf1JDhS+OE1v4VU2uB79jh0WAUzTNTfoqL3GOKvqg84=;
 b=muXn0p2qnEzR0L7cqaq1oOHZ2kDJrbPvCuSKgQ5rrv1Mgqeyhh0DkD5pR7gVlPE1MYkC
 82ZYLqr+bBKa0VyJpoZkagUylxEmY8Gp8Xw9YP+NmzAMirpC+OhzRik80Mu4j/SGntyp
 VRi0PU0X3XY8atuhfXjb9iLxfrrlO5dLkLCBVSxRkTFbOs4Ct/MLd22U0k6qMreyu23X
 FWFZKT6TZ+Us04x62G2mLqCblXvIAr143CJfzuJpIl8la/8rbjjxcPOgO/j6Ix+te2Vg
 CsDvIKhyUw3de9QgOggIE2b8Ki/B0683YECpBc1ih7zmkE2RGaeqh3rJhi6igPGS1lCP uw== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3942x412pj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Jun 2021 03:33:55 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15B7WYnX027739;
        Fri, 11 Jun 2021 07:33:53 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 3936ns0f0g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Jun 2021 07:33:53 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15B7Xo2l27263372
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Jun 2021 07:33:50 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E93DEA406F;
        Fri, 11 Jun 2021 07:33:49 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A2DEDA4065;
        Fri, 11 Jun 2021 07:33:49 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 11 Jun 2021 07:33:49 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 6/9] s390/qeth: remove QAOB's pointer to its TX buffer
Date:   Fri, 11 Jun 2021 09:33:38 +0200
Message-Id: <20210611073341.1634501-7-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210611073341.1634501-1-jwi@linux.ibm.com>
References: <20210611073341.1634501-1-jwi@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Sje8E34qOaUo2Ijj2FKsS31o-5QvfDo3
X-Proofpoint-ORIG-GUID: Sje8E34qOaUo2Ijj2FKsS31o-5QvfDo3
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-11_01:2021-06-11,2021-06-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 mlxscore=0 adultscore=0 impostorscore=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 malwarescore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106110048
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maintaining a pointer inside the aob's user-definable area is fragile
and unnecessary. At this stage we only need it to overload the buffer's
state field, and to access the buffer's TX queue.

The first part is easily solved by tracking the aob's state within the
aob itself. This also feels much cleaner and self-contained.
For enabling the access to the associated TX queue, we can store the
queue's index in the aob.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 arch/s390/include/asm/qdio.h      |   4 +-
 drivers/s390/net/qeth_core.h      |  17 +++--
 drivers/s390/net/qeth_core_main.c | 118 ++++++++++--------------------
 3 files changed, 49 insertions(+), 90 deletions(-)

diff --git a/arch/s390/include/asm/qdio.h b/arch/s390/include/asm/qdio.h
index 8fc52679543d..cb4f73c7228d 100644
--- a/arch/s390/include/asm/qdio.h
+++ b/arch/s390/include/asm/qdio.h
@@ -137,7 +137,6 @@ struct slibe {
  * @user0: user defineable value
  * @res4: reserved paramater
  * @user1: user defineable value
- * @user2: user defineable value
  */
 struct qaob {
 	u64 res0[6];
@@ -152,8 +151,7 @@ struct qaob {
 	u16 dcount[QDIO_MAX_ELEMENTS_PER_BUFFER];
 	u64 user0;
 	u64 res4[2];
-	u64 user1;
-	u64 user2;
+	u8 user1[16];
 } __attribute__ ((packed, aligned(256)));
 
 /**
diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 5de5b419a761..457224b7b97f 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -417,12 +417,17 @@ enum qeth_qdio_out_buffer_state {
 	QETH_QDIO_BUF_EMPTY,
 	/* Filled by driver; owned by hardware in order to be sent. */
 	QETH_QDIO_BUF_PRIMED,
-	/* Discovered by the TX completion code: */
-	QETH_QDIO_BUF_PENDING,
-	/* Finished by the TX completion code: */
-	QETH_QDIO_BUF_NEED_QAOB,
-	/* Received QAOB notification on CQ: */
-	QETH_QDIO_BUF_QAOB_DONE,
+};
+
+enum qeth_qaob_state {
+	QETH_QAOB_ISSUED,
+	QETH_QAOB_PENDING,
+	QETH_QAOB_DONE,
+};
+
+struct qeth_qaob_priv1 {
+	unsigned int state;
+	u8 queue_no;
 };
 
 struct qeth_qdio_out_buffer {
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 99e3b0b75cc3..5ddb2939d4fc 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -431,45 +431,6 @@ static enum iucv_tx_notify qeth_compute_cq_notification(int sbalf15,
 	return n;
 }
 
-static void qeth_qdio_handle_aob(struct qeth_card *card,
-				 unsigned long phys_aob_addr)
-{
-	struct qaob *aob;
-	struct qeth_qdio_out_buffer *buffer;
-	struct qeth_qdio_out_q *queue;
-
-	aob = (struct qaob *) phys_to_virt(phys_aob_addr);
-	QETH_CARD_TEXT(card, 5, "haob");
-	QETH_CARD_TEXT_(card, 5, "%lx", phys_aob_addr);
-	buffer = (struct qeth_qdio_out_buffer *) aob->user1;
-	QETH_CARD_TEXT_(card, 5, "%lx", aob->user1);
-
-	if (aob->aorc)
-		QETH_CARD_TEXT_(card, 2, "aorc%02X", aob->aorc);
-
-	switch (atomic_xchg(&buffer->state, QETH_QDIO_BUF_QAOB_DONE)) {
-	case QETH_QDIO_BUF_PRIMED:
-		/* Faster than TX completion code, let it handle the async
-		 * completion for us. It will also recycle the QAOB.
-		 */
-		break;
-	case QETH_QDIO_BUF_PENDING:
-		/* TX completion code is active and will handle the async
-		 * completion for us. It will also recycle the QAOB.
-		 */
-		break;
-	case QETH_QDIO_BUF_NEED_QAOB:
-		/* TX completion code is already finished. */
-
-		queue = buffer->q;
-		atomic_set(&buffer->state, QETH_QDIO_BUF_EMPTY);
-		napi_schedule(&queue->napi);
-		break;
-	default:
-		WARN_ON_ONCE(1);
-	}
-}
-
 static void qeth_setup_ccw(struct ccw1 *ccw, u8 cmd_code, u8 flags, u32 len,
 			   void *data)
 {
@@ -1412,11 +1373,13 @@ static void qeth_tx_complete_pending_bufs(struct qeth_card *card,
 	struct qeth_qdio_out_buffer *buf, *tmp;
 
 	list_for_each_entry_safe(buf, tmp, &queue->pending_bufs, list_entry) {
+		struct qeth_qaob_priv1 *priv;
 		struct qaob *aob = buf->aob;
 		enum iucv_tx_notify notify;
 		unsigned int i;
 
-		if (drain || atomic_read(&buf->state) == QETH_QDIO_BUF_EMPTY) {
+		priv = (struct qeth_qaob_priv1 *)&aob->user1;
+		if (drain || READ_ONCE(priv->state) == QETH_QAOB_DONE) {
 			QETH_CARD_TEXT(card, 5, "fp");
 			QETH_CARD_TEXT_(card, 5, "%lx", (long) buf);
 
@@ -3625,8 +3588,12 @@ static void qeth_flush_buffers(struct qeth_qdio_out_q *queue, int index,
 			if (!buf->aob)
 				buf->aob = qdio_allocate_aob();
 			if (buf->aob) {
+				struct qeth_qaob_priv1 *priv;
+
 				aob = buf->aob;
-				aob->user1 = (u64) buf;
+				priv = (struct qeth_qaob_priv1 *)&aob->user1;
+				priv->state = QETH_QAOB_ISSUED;
+				priv->queue_no = queue->queue_no;
 			}
 		}
 	} else {
@@ -3765,6 +3732,18 @@ int qeth_configure_cq(struct qeth_card *card, enum qeth_cq cq)
 }
 EXPORT_SYMBOL_GPL(qeth_configure_cq);
 
+static void qeth_qdio_handle_aob(struct qeth_card *card, struct qaob *aob)
+{
+	struct qeth_qaob_priv1 *priv = (struct qeth_qaob_priv1 *)&aob->user1;
+	unsigned int queue_no = priv->queue_no;
+
+	BUILD_BUG_ON(sizeof(*priv) > ARRAY_SIZE(aob->user1));
+
+	if (xchg(&priv->state, QETH_QAOB_DONE) == QETH_QAOB_PENDING &&
+	    queue_no < card->qdio.no_out_queues)
+		napi_schedule(&card->qdio.out_qs[queue_no]->napi);
+}
+
 static void qeth_qdio_cq_handler(struct qeth_card *card, unsigned int qdio_err,
 				 unsigned int queue, int first_element,
 				 int count)
@@ -3791,7 +3770,7 @@ static void qeth_qdio_cq_handler(struct qeth_card *card, unsigned int qdio_err,
 		       buffer->element[e].addr) {
 			unsigned long phys_aob_addr = buffer->element[e].addr;
 
-			qeth_qdio_handle_aob(card, phys_aob_addr);
+			qeth_qdio_handle_aob(card, phys_to_virt(phys_aob_addr));
 			++e;
 		}
 		qeth_scrub_qdio_buffer(buffer, QDIO_MAX_ELEMENTS_PER_BUFFER);
@@ -6039,6 +6018,7 @@ static void qeth_iqd_tx_complete(struct qeth_qdio_out_q *queue,
 
 	if (qdio_error == QDIO_ERROR_SLSB_PENDING) {
 		struct qaob *aob = buffer->aob;
+		struct qeth_qaob_priv1 *priv;
 		enum iucv_tx_notify notify;
 
 		if (!aob) {
@@ -6051,51 +6031,27 @@ static void qeth_iqd_tx_complete(struct qeth_qdio_out_q *queue,
 
 		QETH_CARD_TEXT_(card, 5, "pel%u", bidx);
 
-		switch (atomic_cmpxchg(&buffer->state,
-				       QETH_QDIO_BUF_PRIMED,
-				       QETH_QDIO_BUF_PENDING)) {
-		case QETH_QDIO_BUF_PRIMED:
-			/* We have initial ownership, no QAOB (yet): */
+		priv = (struct qeth_qaob_priv1 *)&aob->user1;
+		/* QAOB hasn't completed yet: */
+		if (xchg(&priv->state, QETH_QAOB_PENDING) != QETH_QAOB_DONE) {
 			qeth_notify_skbs(queue, buffer, TX_NOTIFY_PENDING);
 
-			/* Handle race with qeth_qdio_handle_aob(): */
-			switch (atomic_xchg(&buffer->state,
-					    QETH_QDIO_BUF_NEED_QAOB)) {
-			case QETH_QDIO_BUF_PENDING:
-				/* No concurrent QAOB notification. */
-
-				/* Prepare the queue slot for immediate re-use: */
-				qeth_scrub_qdio_buffer(buffer->buffer, queue->max_elements);
-				if (qeth_alloc_out_buf(queue, bidx,
-						       GFP_ATOMIC)) {
-					QETH_CARD_TEXT(card, 2, "outofbuf");
-					qeth_schedule_recovery(card);
-				}
-
-				list_add(&buffer->list_entry,
-					 &queue->pending_bufs);
-				/* Skip clearing the buffer: */
-				return;
-			case QETH_QDIO_BUF_QAOB_DONE:
-				notify = qeth_compute_cq_notification(aob->aorc, 1);
-				qeth_notify_skbs(queue, buffer, notify);
-				error = !!aob->aorc;
-				break;
-			default:
-				WARN_ON_ONCE(1);
+			/* Prepare the queue slot for immediate re-use: */
+			qeth_scrub_qdio_buffer(buffer->buffer, queue->max_elements);
+			if (qeth_alloc_out_buf(queue, bidx, GFP_ATOMIC)) {
+				QETH_CARD_TEXT(card, 2, "outofbuf");
+				qeth_schedule_recovery(card);
 			}
 
-			break;
-		case QETH_QDIO_BUF_QAOB_DONE:
-			/* qeth_qdio_handle_aob() already received a QAOB: */
-			notify = qeth_compute_cq_notification(aob->aorc, 0);
-			qeth_notify_skbs(queue, buffer, notify);
-			error = !!aob->aorc;
-			break;
-		default:
-			WARN_ON_ONCE(1);
+			list_add(&buffer->list_entry, &queue->pending_bufs);
+			/* Skip clearing the buffer: */
+			return;
 		}
 
+		/* QAOB already completed: */
+		notify = qeth_compute_cq_notification(aob->aorc, 0);
+		qeth_notify_skbs(queue, buffer, notify);
+		error = !!aob->aorc;
 		memset(aob, 0, sizeof(*aob));
 	} else if (card->options.cq == QETH_CQ_ENABLED) {
 		qeth_notify_skbs(queue, buffer,
-- 
2.25.1

