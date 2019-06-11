Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C9B63D269
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 18:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405644AbfFKQiS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 12:38:18 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:40506 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404758AbfFKQiP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 12:38:15 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5BGR42Y186600
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 12:38:14 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2t2f9qa9jx-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 12:38:13 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Tue, 11 Jun 2019 17:38:11 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 11 Jun 2019 17:38:09 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5BGc8UJ62914784
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jun 2019 16:38:08 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DD26F4C050;
        Tue, 11 Jun 2019 16:38:07 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8EECC4C052;
        Tue, 11 Jun 2019 16:38:07 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 11 Jun 2019 16:38:07 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 09/13] s390/qeth: remove 'channel' parameter from callbacks
Date:   Tue, 11 Jun 2019 18:37:56 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190611163800.64730-1-jwi@linux.ibm.com>
References: <20190611163800.64730-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19061116-4275-0000-0000-0000034169C3
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061116-4276-0000-0000-000038517C08
Message-Id: <20190611163800.64730-10-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-11_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906110106
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Each cmd buffer maintains a pointer to the IO channel that it was/will
be issued on. So when dealing with cmd buffers, we don't need to pass
around a separate channel pointer.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      |  5 ++--
 drivers/s390/net/qeth_core_main.c | 38 ++++++++++++++-----------------
 drivers/s390/net/qeth_l2_main.c   |  5 ++--
 3 files changed, 21 insertions(+), 27 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index be50e701b744..c1292d3420a2 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -585,8 +585,7 @@ struct qeth_cmd_buffer {
 	unsigned char *data;
 	void (*finalize)(struct qeth_card *card, struct qeth_cmd_buffer *iob,
 			 unsigned int length);
-	void (*callback)(struct qeth_card *card, struct qeth_channel *channel,
-			 struct qeth_cmd_buffer *iob);
+	void (*callback)(struct qeth_card *card, struct qeth_cmd_buffer *iob);
 };
 
 static inline struct qeth_ipa_cmd *__ipa_cmd(struct qeth_cmd_buffer *iob)
@@ -995,7 +994,7 @@ void qeth_drain_output_queues(struct qeth_card *card);
 void qeth_setadp_promisc_mode(struct qeth_card *);
 int qeth_setadpparms_change_macaddr(struct qeth_card *);
 void qeth_tx_timeout(struct net_device *);
-void qeth_release_buffer(struct qeth_channel *, struct qeth_cmd_buffer *);
+void qeth_release_buffer(struct qeth_cmd_buffer *iob);
 void qeth_notify_reply(struct qeth_reply *reply, int reason);
 void qeth_prepare_ipa_cmd(struct qeth_card *card, struct qeth_cmd_buffer *iob,
 			  u16 cmd_length);
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index df86705bdc55..10f16ddeb71a 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -63,7 +63,6 @@ static struct device *qeth_core_root_dev;
 static struct lock_class_key qdio_out_skb_queue_key;
 
 static void qeth_issue_next_read_cb(struct qeth_card *card,
-				    struct qeth_channel *channel,
 				    struct qeth_cmd_buffer *iob);
 static void qeth_free_buffer_pool(struct qeth_card *);
 static int qeth_qdio_establish(struct qeth_card *);
@@ -521,7 +520,7 @@ static int __qeth_issue_next_read(struct qeth_card *card)
 		QETH_DBF_MESSAGE(2, "error %i on device %x when starting next read ccw!\n",
 				 rc, CARD_DEVID(card));
 		atomic_set(&channel->irq_pending, 0);
-		qeth_release_buffer(channel, iob);
+		qeth_release_buffer(iob);
 		card->read_or_write_problem = 1;
 		qeth_schedule_recovery(card);
 		wake_up(&card->wait_q);
@@ -713,9 +712,9 @@ static struct qeth_cmd_buffer *__qeth_get_buffer(struct qeth_channel *channel)
 	return NULL;
 }
 
-void qeth_release_buffer(struct qeth_channel *channel,
-		struct qeth_cmd_buffer *iob)
+void qeth_release_buffer(struct qeth_cmd_buffer *iob)
 {
+	struct qeth_channel *channel = iob->channel;
 	unsigned long flags;
 
 	spin_lock_irqsave(&channel->iob_lock, flags);
@@ -731,10 +730,9 @@ void qeth_release_buffer(struct qeth_channel *channel,
 EXPORT_SYMBOL_GPL(qeth_release_buffer);
 
 static void qeth_release_buffer_cb(struct qeth_card *card,
-				   struct qeth_channel *channel,
 				   struct qeth_cmd_buffer *iob)
 {
-	qeth_release_buffer(channel, iob);
+	qeth_release_buffer(iob);
 }
 
 static void qeth_cancel_cmd(struct qeth_cmd_buffer *iob, int rc)
@@ -743,7 +741,7 @@ static void qeth_cancel_cmd(struct qeth_cmd_buffer *iob, int rc)
 
 	if (reply)
 		qeth_notify_reply(reply, rc);
-	qeth_release_buffer(iob->channel, iob);
+	qeth_release_buffer(iob);
 }
 
 struct qeth_cmd_buffer *qeth_get_buffer(struct qeth_channel *channel)
@@ -763,13 +761,12 @@ void qeth_clear_cmd_buffers(struct qeth_channel *channel)
 	int cnt;
 
 	for (cnt = 0; cnt < QETH_CMD_BUFFER_NO; cnt++)
-		qeth_release_buffer(channel, &channel->iob[cnt]);
+		qeth_release_buffer(&channel->iob[cnt]);
 	channel->io_buf_no = 0;
 }
 EXPORT_SYMBOL_GPL(qeth_clear_cmd_buffers);
 
 static void qeth_issue_next_read_cb(struct qeth_card *card,
-				    struct qeth_channel *channel,
 				    struct qeth_cmd_buffer *iob)
 {
 	struct qeth_ipa_cmd *cmd = NULL;
@@ -842,7 +839,7 @@ static void qeth_issue_next_read_cb(struct qeth_card *card,
 	memcpy(&card->seqno.pdu_hdr_ack,
 		QETH_PDU_HEADER_SEQ_NO(iob->data),
 		QETH_SEQ_NO_LENGTH);
-	qeth_release_buffer(channel, iob);
+	qeth_release_buffer(iob);
 	__qeth_issue_next_read(card);
 }
 
@@ -1110,7 +1107,7 @@ static void qeth_irq(struct ccw_device *cdev, unsigned long intparm,
 		return;
 
 	if (iob && iob->callback)
-		iob->callback(card, iob->channel, iob);
+		iob->callback(card, iob);
 
 out:
 	wake_up(&card->wait_q);
@@ -1834,7 +1831,7 @@ static int qeth_send_control_data(struct qeth_card *card, int len,
 
 	reply = qeth_alloc_reply(card);
 	if (!reply) {
-		qeth_release_buffer(channel, iob);
+		qeth_release_buffer(iob);
 		return -ENOMEM;
 	}
 	reply->callback = reply_cb;
@@ -1849,7 +1846,7 @@ static int qeth_send_control_data(struct qeth_card *card, int len,
 						   timeout);
 	if (timeout <= 0) {
 		qeth_put_reply(reply);
-		qeth_release_buffer(channel, iob);
+		qeth_release_buffer(iob);
 		return (timeout == -ERESTARTSYS) ? -EINTR : -ETIME;
 	}
 
@@ -1869,7 +1866,7 @@ static int qeth_send_control_data(struct qeth_card *card, int len,
 		QETH_CARD_TEXT_(card, 2, " err%d", rc);
 		qeth_dequeue_reply(card, reply);
 		qeth_put_reply(reply);
-		qeth_release_buffer(channel, iob);
+		qeth_release_buffer(iob);
 		atomic_set(&channel->irq_pending, 0);
 		wake_up(&card->wait_q);
 		return rc;
@@ -1922,9 +1919,9 @@ static int qeth_idx_check_activate_response(struct qeth_card *card,
 }
 
 static void qeth_idx_query_read_cb(struct qeth_card *card,
-				   struct qeth_channel *channel,
 				   struct qeth_cmd_buffer *iob)
 {
+	struct qeth_channel *channel = iob->channel;
 	u16 peer_level;
 	int rc;
 
@@ -1951,13 +1948,13 @@ static void qeth_idx_query_read_cb(struct qeth_card *card,
 
 out:
 	qeth_notify_reply(iob->reply, rc);
-	qeth_release_buffer(channel, iob);
+	qeth_release_buffer(iob);
 }
 
 static void qeth_idx_query_write_cb(struct qeth_card *card,
-				    struct qeth_channel *channel,
 				    struct qeth_cmd_buffer *iob)
 {
+	struct qeth_channel *channel = iob->channel;
 	u16 peer_level;
 	int rc;
 
@@ -1978,7 +1975,7 @@ static void qeth_idx_query_write_cb(struct qeth_card *card,
 
 out:
 	qeth_notify_reply(iob->reply, rc);
-	qeth_release_buffer(channel, iob);
+	qeth_release_buffer(iob);
 }
 
 static void qeth_idx_finalize_query_cmd(struct qeth_card *card,
@@ -1989,11 +1986,10 @@ static void qeth_idx_finalize_query_cmd(struct qeth_card *card,
 }
 
 static void qeth_idx_activate_cb(struct qeth_card *card,
-				 struct qeth_channel *channel,
 				 struct qeth_cmd_buffer *iob)
 {
 	qeth_notify_reply(iob->reply, 0);
-	qeth_release_buffer(channel, iob);
+	qeth_release_buffer(iob);
 }
 
 static void qeth_idx_setup_activate_cmd(struct qeth_card *card,
@@ -2852,7 +2848,7 @@ int qeth_send_ipa_cmd(struct qeth_card *card, struct qeth_cmd_buffer *iob,
 	QETH_CARD_TEXT(card, 4, "sendipa");
 
 	if (card->read_or_write_problem) {
-		qeth_release_buffer(iob->channel, iob);
+		qeth_release_buffer(iob);
 		return -EIO;
 	}
 
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 5fc36ed20c67..e1b25084dcd4 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -1030,11 +1030,10 @@ struct qeth_discipline qeth_l2_discipline = {
 EXPORT_SYMBOL_GPL(qeth_l2_discipline);
 
 static void qeth_osn_assist_cb(struct qeth_card *card,
-			       struct qeth_channel *channel,
 			       struct qeth_cmd_buffer *iob)
 {
 	qeth_notify_reply(iob->reply, 0);
-	qeth_release_buffer(channel, iob);
+	qeth_release_buffer(iob);
 }
 
 int qeth_osn_assist(struct net_device *dev, void *data, int data_len)
@@ -1812,7 +1811,7 @@ static int qeth_l2_vnicc_request(struct qeth_card *card,
 		req->getset_timeout.vnic_char = cbctl->param.vnic_char;
 		break;
 	default:
-		qeth_release_buffer(iob->channel, iob);
+		qeth_release_buffer(iob);
 		return -EOPNOTSUPP;
 	}
 
-- 
2.17.1

