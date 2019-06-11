Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E707B3D26A
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 18:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405649AbfFKQiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 12:38:22 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:51258 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2405605AbfFKQiS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 12:38:18 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5BGR3MM098873
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 12:38:14 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2t2emjcp6u-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 12:38:13 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Tue, 11 Jun 2019 17:38:11 +0100
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 11 Jun 2019 17:38:09 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5BGc7Xt39452940
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jun 2019 16:38:07 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7608D4C050;
        Tue, 11 Jun 2019 16:38:07 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 250964C04E;
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
Subject: [PATCH net-next 08/13] s390/qeth: convert device-specific trace entries
Date:   Tue, 11 Jun 2019 18:37:55 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190611163800.64730-1-jwi@linux.ibm.com>
References: <20190611163800.64730-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19061116-0028-0000-0000-0000037965F3
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061116-0029-0000-0000-0000243955DB
Message-Id: <20190611163800.64730-9-jwi@linux.ibm.com>
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

The vast majority of SETUP-classified trace entries can be moved to
their device-specific trace file. This reduces pollution of the global
SETUP file, and provides a consistent trace view of all activity on the
device.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 196 ++++++++++++++----------------
 drivers/s390/net/qeth_l2_main.c   |  28 ++---
 drivers/s390/net/qeth_l3_main.c   |  35 +++---
 3 files changed, 122 insertions(+), 137 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 2ad51afa6747..df86705bdc55 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -292,7 +292,7 @@ static int qeth_cq_init(struct qeth_card *card)
 	int rc;
 
 	if (card->options.cq == QETH_CQ_ENABLED) {
-		QETH_DBF_TEXT(SETUP, 2, "cqinit");
+		QETH_CARD_TEXT(card, 2, "cqinit");
 		qdio_reset_buffers(card->qdio.c_q->qdio_bufs,
 				   QDIO_MAX_BUFFERS_PER_Q);
 		card->qdio.c_q->next_buf_to_init = 127;
@@ -300,7 +300,7 @@ static int qeth_cq_init(struct qeth_card *card)
 			     card->qdio.no_in_queues - 1, 0,
 			     127);
 		if (rc) {
-			QETH_DBF_TEXT_(SETUP, 2, "1err%d", rc);
+			QETH_CARD_TEXT_(card, 2, "1err%d", rc);
 			goto out;
 		}
 	}
@@ -317,7 +317,7 @@ static int qeth_alloc_cq(struct qeth_card *card)
 		int i;
 		struct qdio_outbuf_state *outbuf_states;
 
-		QETH_DBF_TEXT(SETUP, 2, "cqon");
+		QETH_CARD_TEXT(card, 2, "cqon");
 		card->qdio.c_q = qeth_alloc_qdio_queue();
 		if (!card->qdio.c_q) {
 			rc = -1;
@@ -339,11 +339,11 @@ static int qeth_alloc_cq(struct qeth_card *card)
 			outbuf_states += QDIO_MAX_BUFFERS_PER_Q;
 		}
 	} else {
-		QETH_DBF_TEXT(SETUP, 2, "nocq");
+		QETH_CARD_TEXT(card, 2, "nocq");
 		card->qdio.c_q = NULL;
 		card->qdio.no_in_queues = 1;
 	}
-	QETH_DBF_TEXT_(SETUP, 2, "iqc%d", card->qdio.no_in_queues);
+	QETH_CARD_TEXT_(card, 2, "iqc%d", card->qdio.no_in_queues);
 	rc = 0;
 out:
 	return rc;
@@ -1297,7 +1297,7 @@ static int qeth_update_from_chp_desc(struct qeth_card *card)
 	struct channel_path_desc_fmt0 *chp_dsc;
 	int rc = 0;
 
-	QETH_DBF_TEXT(SETUP, 2, "chp_desc");
+	QETH_CARD_TEXT(card, 2, "chp_desc");
 
 	ccwdev = card->data.ccwdev;
 	chp_dsc = ccw_device_get_chp_desc(ccwdev, 0);
@@ -1311,14 +1311,14 @@ static int qeth_update_from_chp_desc(struct qeth_card *card)
 		rc = qeth_osa_set_output_queues(card, chp_dsc->chpp & 0x02);
 
 	kfree(chp_dsc);
-	QETH_DBF_TEXT_(SETUP, 2, "nr:%x", card->qdio.no_out_queues);
-	QETH_DBF_TEXT_(SETUP, 2, "lvl:%02x", card->info.func_level);
+	QETH_CARD_TEXT_(card, 2, "nr:%x", card->qdio.no_out_queues);
+	QETH_CARD_TEXT_(card, 2, "lvl:%02x", card->info.func_level);
 	return rc;
 }
 
 static void qeth_init_qdio_info(struct qeth_card *card)
 {
-	QETH_DBF_TEXT(SETUP, 4, "intqdinf");
+	QETH_CARD_TEXT(card, 4, "intqdinf");
 	atomic_set(&card->qdio.state, QETH_QDIO_UNINITIALIZED);
 	card->qdio.do_prio_queueing = QETH_PRIOQ_DEFAULT;
 	card->qdio.default_out_queue = QETH_DEFAULT_QUEUE;
@@ -1384,8 +1384,7 @@ static void qeth_start_kernel_thread(struct work_struct *work)
 static void qeth_buffer_reclaim_work(struct work_struct *);
 static void qeth_setup_card(struct qeth_card *card)
 {
-	QETH_DBF_TEXT(SETUP, 2, "setupcrd");
-	QETH_DBF_HEX(SETUP, 2, &card, sizeof(void *));
+	QETH_CARD_TEXT(card, 2, "setupcrd");
 
 	card->info.type = CARD_RDEV(card)->id.driver_info;
 	card->state = CARD_STATE_DOWN;
@@ -1619,7 +1618,7 @@ static int qeth_read_conf_data(struct qeth_card *card, void **buffer,
 
 static void qeth_configure_unitaddr(struct qeth_card *card, char *prcd)
 {
-	QETH_DBF_TEXT(SETUP, 2, "cfgunit");
+	QETH_CARD_TEXT(card, 2, "cfgunit");
 	card->info.chpid = prcd[30];
 	card->info.unit_addr2 = prcd[31];
 	card->info.cula = prcd[63];
@@ -1638,7 +1637,7 @@ static enum qeth_discipline_id qeth_vm_detect_layer(struct qeth_card *card)
 	char userid[80];
 	int rc = 0;
 
-	QETH_DBF_TEXT(SETUP, 2, "vmlayer");
+	QETH_CARD_TEXT(card, 2, "vmlayer");
 
 	cpcmd("QUERY USERID", userid, sizeof(userid), &rc);
 	if (rc)
@@ -1681,7 +1680,7 @@ static enum qeth_discipline_id qeth_vm_detect_layer(struct qeth_card *card)
 	kfree(response);
 	kfree(request);
 	if (rc)
-		QETH_DBF_TEXT_(SETUP, 2, "err%x", rc);
+		QETH_CARD_TEXT_(card, 2, "err%x", rc);
 	return disc;
 }
 
@@ -1698,13 +1697,13 @@ static enum qeth_discipline_id qeth_enforce_discipline(struct qeth_card *card)
 
 	switch (disc) {
 	case QETH_DISCIPLINE_LAYER2:
-		QETH_DBF_TEXT(SETUP, 3, "force l2");
+		QETH_CARD_TEXT(card, 3, "force l2");
 		break;
 	case QETH_DISCIPLINE_LAYER3:
-		QETH_DBF_TEXT(SETUP, 3, "force l3");
+		QETH_CARD_TEXT(card, 3, "force l3");
 		break;
 	default:
-		QETH_DBF_TEXT(SETUP, 3, "force no");
+		QETH_CARD_TEXT(card, 3, "force no");
 	}
 
 	return disc;
@@ -1712,7 +1711,7 @@ static enum qeth_discipline_id qeth_enforce_discipline(struct qeth_card *card)
 
 static void qeth_set_blkt_defaults(struct qeth_card *card)
 {
-	QETH_DBF_TEXT(SETUP, 2, "cfgblkt");
+	QETH_CARD_TEXT(card, 2, "cfgblkt");
 
 	if (card->info.use_v1_blkt) {
 		card->info.blkt.time_total = 0;
@@ -1902,8 +1901,8 @@ static int qeth_idx_check_activate_response(struct qeth_card *card,
 		return 0;
 
 	/* negative reply: */
-	QETH_DBF_TEXT_(SETUP, 2, "idxneg%c",
-		       QETH_IDX_ACT_CAUSE_CODE(iob->data));
+	QETH_CARD_TEXT_(card, 2, "idxneg%c",
+			QETH_IDX_ACT_CAUSE_CODE(iob->data));
 
 	switch (QETH_IDX_ACT_CAUSE_CODE(iob->data)) {
 	case QETH_IDX_ACT_ERR_EXCL:
@@ -1929,7 +1928,7 @@ static void qeth_idx_query_read_cb(struct qeth_card *card,
 	u16 peer_level;
 	int rc;
 
-	QETH_DBF_TEXT(SETUP, 2, "idxrdcb");
+	QETH_CARD_TEXT(card, 2, "idxrdcb");
 
 	rc = qeth_idx_check_activate_response(card, channel, iob);
 	if (rc)
@@ -1962,7 +1961,7 @@ static void qeth_idx_query_write_cb(struct qeth_card *card,
 	u16 peer_level;
 	int rc;
 
-	QETH_DBF_TEXT(SETUP, 2, "idxwrcb");
+	QETH_CARD_TEXT(card, 2, "idxwrcb");
 
 	rc = qeth_idx_check_activate_response(card, channel, iob);
 	if (rc)
@@ -2023,7 +2022,7 @@ static int qeth_idx_activate_read_channel(struct qeth_card *card)
 	struct qeth_cmd_buffer *iob;
 	int rc;
 
-	QETH_DBF_TEXT(SETUP, 2, "idxread");
+	QETH_CARD_TEXT(card, 2, "idxread");
 
 	iob = qeth_get_buffer(channel);
 	if (!iob)
@@ -2056,7 +2055,7 @@ static int qeth_idx_activate_write_channel(struct qeth_card *card)
 	struct qeth_cmd_buffer *iob;
 	int rc;
 
-	QETH_DBF_TEXT(SETUP, 2, "idxwrite");
+	QETH_CARD_TEXT(card, 2, "idxwrite");
 
 	iob = qeth_get_buffer(channel);
 	if (!iob)
@@ -2088,7 +2087,7 @@ static int qeth_cm_enable_cb(struct qeth_card *card, struct qeth_reply *reply,
 {
 	struct qeth_cmd_buffer *iob;
 
-	QETH_DBF_TEXT(SETUP, 2, "cmenblcb");
+	QETH_CARD_TEXT(card, 2, "cmenblcb");
 
 	iob = (struct qeth_cmd_buffer *) data;
 	memcpy(&card->token.cm_filter_r,
@@ -2102,7 +2101,7 @@ static int qeth_cm_enable(struct qeth_card *card)
 	int rc;
 	struct qeth_cmd_buffer *iob;
 
-	QETH_DBF_TEXT(SETUP, 2, "cmenable");
+	QETH_CARD_TEXT(card, 2, "cmenable");
 
 	iob = qeth_mpc_get_cmd_buffer(card);
 	if (!iob)
@@ -2124,7 +2123,7 @@ static int qeth_cm_setup_cb(struct qeth_card *card, struct qeth_reply *reply,
 {
 	struct qeth_cmd_buffer *iob;
 
-	QETH_DBF_TEXT(SETUP, 2, "cmsetpcb");
+	QETH_CARD_TEXT(card, 2, "cmsetpcb");
 
 	iob = (struct qeth_cmd_buffer *) data;
 	memcpy(&card->token.cm_connection_r,
@@ -2138,7 +2137,7 @@ static int qeth_cm_setup(struct qeth_card *card)
 	int rc;
 	struct qeth_cmd_buffer *iob;
 
-	QETH_DBF_TEXT(SETUP, 2, "cmsetup");
+	QETH_CARD_TEXT(card, 2, "cmsetup");
 
 	iob = qeth_mpc_get_cmd_buffer(card);
 	if (!iob)
@@ -2218,7 +2217,7 @@ static int qeth_ulp_enable_cb(struct qeth_card *card, struct qeth_reply *reply,
 	__u8 link_type;
 	struct qeth_cmd_buffer *iob;
 
-	QETH_DBF_TEXT(SETUP, 2, "ulpenacb");
+	QETH_CARD_TEXT(card, 2, "ulpenacb");
 
 	iob = (struct qeth_cmd_buffer *) data;
 	memcpy(&card->token.ulp_filter_r,
@@ -2239,7 +2238,7 @@ static int qeth_ulp_enable_cb(struct qeth_card *card, struct qeth_reply *reply,
 		card->info.link_type = link_type;
 	} else
 		card->info.link_type = 0;
-	QETH_DBF_TEXT_(SETUP, 2, "link%d", card->info.link_type);
+	QETH_CARD_TEXT_(card, 2, "link%d", card->info.link_type);
 	return 0;
 }
 
@@ -2257,8 +2256,7 @@ static int qeth_ulp_enable(struct qeth_card *card)
 	u16 max_mtu;
 	int rc;
 
-	/*FIXME: trace view callbacks*/
-	QETH_DBF_TEXT(SETUP, 2, "ulpenabl");
+	QETH_CARD_TEXT(card, 2, "ulpenabl");
 
 	iob = qeth_mpc_get_cmd_buffer(card);
 	if (!iob)
@@ -2283,7 +2281,7 @@ static int qeth_ulp_setup_cb(struct qeth_card *card, struct qeth_reply *reply,
 {
 	struct qeth_cmd_buffer *iob;
 
-	QETH_DBF_TEXT(SETUP, 2, "ulpstpcb");
+	QETH_CARD_TEXT(card, 2, "ulpstpcb");
 
 	iob = (struct qeth_cmd_buffer *) data;
 	memcpy(&card->token.ulp_connection_r,
@@ -2291,7 +2289,7 @@ static int qeth_ulp_setup_cb(struct qeth_card *card, struct qeth_reply *reply,
 	       QETH_MPC_TOKEN_LENGTH);
 	if (!strncmp("00S", QETH_ULP_SETUP_RESP_CONNECTION_TOKEN(iob->data),
 		     3)) {
-		QETH_DBF_TEXT(SETUP, 2, "olmlimit");
+		QETH_CARD_TEXT(card, 2, "olmlimit");
 		dev_err(&card->gdev->dev, "A connection could not be "
 			"established because of an OLM limit\n");
 		return -EMLINK;
@@ -2306,7 +2304,7 @@ static int qeth_ulp_setup(struct qeth_card *card)
 	struct qeth_cmd_buffer *iob;
 	struct ccw_dev_id dev_id;
 
-	QETH_DBF_TEXT(SETUP, 2, "ulpsetup");
+	QETH_CARD_TEXT(card, 2, "ulpsetup");
 
 	iob = qeth_mpc_get_cmd_buffer(card);
 	if (!iob)
@@ -2375,13 +2373,13 @@ static int qeth_alloc_qdio_queues(struct qeth_card *card)
 {
 	int i, j;
 
-	QETH_DBF_TEXT(SETUP, 2, "allcqdbf");
+	QETH_CARD_TEXT(card, 2, "allcqdbf");
 
 	if (atomic_cmpxchg(&card->qdio.state, QETH_QDIO_UNINITIALIZED,
 		QETH_QDIO_ALLOCATED) != QETH_QDIO_UNINITIALIZED)
 		return 0;
 
-	QETH_DBF_TEXT(SETUP, 2, "inq");
+	QETH_CARD_TEXT(card, 2, "inq");
 	card->qdio.in_q = qeth_alloc_qdio_queue();
 	if (!card->qdio.in_q)
 		goto out_nomem;
@@ -2395,8 +2393,8 @@ static int qeth_alloc_qdio_queues(struct qeth_card *card)
 		card->qdio.out_qs[i] = qeth_alloc_output_queue();
 		if (!card->qdio.out_qs[i])
 			goto out_freeoutq;
-		QETH_DBF_TEXT_(SETUP, 2, "outq %i", i);
-		QETH_DBF_HEX(SETUP, 2, &card->qdio.out_qs[i], sizeof(void *));
+		QETH_CARD_TEXT_(card, 2, "outq %i", i);
+		QETH_CARD_HEX(card, 2, &card->qdio.out_qs[i], sizeof(void *));
 		card->qdio.out_qs[i]->card = card;
 		card->qdio.out_qs[i]->queue_no = i;
 		/* give outbound qeth_qdio_buffers their qdio_buffers */
@@ -2487,7 +2485,7 @@ static void qeth_create_qib_param_field_blkt(struct qeth_card *card,
 
 static int qeth_qdio_activate(struct qeth_card *card)
 {
-	QETH_DBF_TEXT(SETUP, 3, "qdioact");
+	QETH_CARD_TEXT(card, 3, "qdioact");
 	return qdio_activate(CARD_DDEV(card));
 }
 
@@ -2496,7 +2494,7 @@ static int qeth_dm_act(struct qeth_card *card)
 	int rc;
 	struct qeth_cmd_buffer *iob;
 
-	QETH_DBF_TEXT(SETUP, 2, "dmact");
+	QETH_CARD_TEXT(card, 2, "dmact");
 
 	iob = qeth_mpc_get_cmd_buffer(card);
 	if (!iob)
@@ -2515,52 +2513,52 @@ static int qeth_mpc_initialize(struct qeth_card *card)
 {
 	int rc;
 
-	QETH_DBF_TEXT(SETUP, 2, "mpcinit");
+	QETH_CARD_TEXT(card, 2, "mpcinit");
 
 	rc = qeth_issue_next_read(card);
 	if (rc) {
-		QETH_DBF_TEXT_(SETUP, 2, "1err%d", rc);
+		QETH_CARD_TEXT_(card, 2, "1err%d", rc);
 		return rc;
 	}
 	rc = qeth_cm_enable(card);
 	if (rc) {
-		QETH_DBF_TEXT_(SETUP, 2, "2err%d", rc);
+		QETH_CARD_TEXT_(card, 2, "2err%d", rc);
 		goto out_qdio;
 	}
 	rc = qeth_cm_setup(card);
 	if (rc) {
-		QETH_DBF_TEXT_(SETUP, 2, "3err%d", rc);
+		QETH_CARD_TEXT_(card, 2, "3err%d", rc);
 		goto out_qdio;
 	}
 	rc = qeth_ulp_enable(card);
 	if (rc) {
-		QETH_DBF_TEXT_(SETUP, 2, "4err%d", rc);
+		QETH_CARD_TEXT_(card, 2, "4err%d", rc);
 		goto out_qdio;
 	}
 	rc = qeth_ulp_setup(card);
 	if (rc) {
-		QETH_DBF_TEXT_(SETUP, 2, "5err%d", rc);
+		QETH_CARD_TEXT_(card, 2, "5err%d", rc);
 		goto out_qdio;
 	}
 	rc = qeth_alloc_qdio_queues(card);
 	if (rc) {
-		QETH_DBF_TEXT_(SETUP, 2, "5err%d", rc);
+		QETH_CARD_TEXT_(card, 2, "5err%d", rc);
 		goto out_qdio;
 	}
 	rc = qeth_qdio_establish(card);
 	if (rc) {
-		QETH_DBF_TEXT_(SETUP, 2, "6err%d", rc);
+		QETH_CARD_TEXT_(card, 2, "6err%d", rc);
 		qeth_free_qdio_queues(card);
 		goto out_qdio;
 	}
 	rc = qeth_qdio_activate(card);
 	if (rc) {
-		QETH_DBF_TEXT_(SETUP, 2, "7err%d", rc);
+		QETH_CARD_TEXT_(card, 2, "7err%d", rc);
 		goto out_qdio;
 	}
 	rc = qeth_dm_act(card);
 	if (rc) {
-		QETH_DBF_TEXT_(SETUP, 2, "8err%d", rc);
+		QETH_CARD_TEXT_(card, 2, "8err%d", rc);
 		goto out_qdio;
 	}
 
@@ -2713,7 +2711,7 @@ int qeth_init_qdio_queues(struct qeth_card *card)
 	unsigned int i;
 	int rc;
 
-	QETH_DBF_TEXT(SETUP, 2, "initqdqs");
+	QETH_CARD_TEXT(card, 2, "initqdqs");
 
 	/* inbound queue */
 	qdio_reset_buffers(card->qdio.in_q->qdio_bufs, QDIO_MAX_BUFFERS_PER_Q);
@@ -2727,7 +2725,7 @@ int qeth_init_qdio_queues(struct qeth_card *card)
 	rc = do_QDIO(CARD_DDEV(card), QDIO_FLAG_SYNC_INPUT, 0, 0,
 		     card->qdio.in_buf_pool.buf_count - 1);
 	if (rc) {
-		QETH_DBF_TEXT_(SETUP, 2, "1err%d", rc);
+		QETH_CARD_TEXT_(card, 2, "1err%d", rc);
 		return rc;
 	}
 
@@ -2885,7 +2883,7 @@ static int qeth_send_startlan(struct qeth_card *card)
 {
 	struct qeth_cmd_buffer *iob;
 
-	QETH_DBF_TEXT(SETUP, 2, "strtlan");
+	QETH_CARD_TEXT(card, 2, "strtlan");
 
 	iob = qeth_get_ipacmd_buffer(card, IPA_CMD_STARTLAN, 0);
 	if (!iob)
@@ -2913,7 +2911,7 @@ static int qeth_query_setadapterparms_cb(struct qeth_card *card,
 	if (cmd->data.setadapterparms.data.query_cmds_supp.lan_type & 0x7f) {
 		card->info.link_type =
 		      cmd->data.setadapterparms.data.query_cmds_supp.lan_type;
-		QETH_DBF_TEXT_(SETUP, 2, "lnk %d", card->info.link_type);
+		QETH_CARD_TEXT_(card, 2, "lnk %d", card->info.link_type);
 	}
 	card->options.adp.supported_funcs =
 		cmd->data.setadapterparms.data.query_cmds_supp.supported_cmds;
@@ -2958,7 +2956,7 @@ static int qeth_query_ipassists_cb(struct qeth_card *card,
 {
 	struct qeth_ipa_cmd *cmd;
 
-	QETH_DBF_TEXT(SETUP, 2, "qipasscb");
+	QETH_CARD_TEXT(card, 2, "qipasscb");
 
 	cmd = (struct qeth_ipa_cmd *) data;
 
@@ -2967,7 +2965,7 @@ static int qeth_query_ipassists_cb(struct qeth_card *card,
 		break;
 	case IPA_RC_NOTSUPP:
 	case IPA_RC_L2_UNSUPPORTED_CMD:
-		QETH_DBF_TEXT(SETUP, 2, "ipaunsup");
+		QETH_CARD_TEXT(card, 2, "ipaunsup");
 		card->options.ipa4.supported_funcs |= IPA_SETADAPTERPARMS;
 		card->options.ipa6.supported_funcs |= IPA_SETADAPTERPARMS;
 		return -EOPNOTSUPP;
@@ -2995,7 +2993,7 @@ static int qeth_query_ipassists(struct qeth_card *card,
 	int rc;
 	struct qeth_cmd_buffer *iob;
 
-	QETH_DBF_TEXT_(SETUP, 2, "qipassi%i", prot);
+	QETH_CARD_TEXT_(card, 2, "qipassi%i", prot);
 	iob = qeth_get_ipacmd_buffer(card, IPA_CMD_QIPASSIST, prot);
 	if (!iob)
 		return -ENOMEM;
@@ -3061,7 +3059,7 @@ static int qeth_query_setdiagass(struct qeth_card *card)
 	struct qeth_cmd_buffer *iob;
 	struct qeth_ipa_cmd    *cmd;
 
-	QETH_DBF_TEXT(SETUP, 2, "qdiagass");
+	QETH_CARD_TEXT(card, 2, "qdiagass");
 	iob = qeth_get_ipacmd_buffer(card, IPA_CMD_SET_DIAG_ASS, 0);
 	if (!iob)
 		return -ENOMEM;
@@ -3114,7 +3112,7 @@ int qeth_hw_trap(struct qeth_card *card, enum qeth_diags_trap_action action)
 	struct qeth_cmd_buffer *iob;
 	struct qeth_ipa_cmd *cmd;
 
-	QETH_DBF_TEXT(SETUP, 2, "diagtrap");
+	QETH_CARD_TEXT(card, 2, "diagtrap");
 	iob = qeth_get_ipacmd_buffer(card, IPA_CMD_SET_DIAG_ASS, 0);
 	if (!iob)
 		return -ENOMEM;
@@ -4226,10 +4224,8 @@ static int qeth_setadpparms_set_access_ctrl_cb(struct qeth_card *card,
 	qeth_setadpparms_inspect_rc(cmd);
 
 	access_ctrl_req = &cmd->data.setadapterparms.data.set_access_ctrl;
-	QETH_DBF_TEXT_(SETUP, 2, "setaccb");
-	QETH_DBF_TEXT_(SETUP, 2, "%s", card->gdev->dev.kobj.name);
-	QETH_DBF_TEXT_(SETUP, 2, "rc=%d",
-		cmd->data.setadapterparms.hdr.return_code);
+	QETH_CARD_TEXT_(card, 2, "rc=%d",
+			cmd->data.setadapterparms.hdr.return_code);
 	if (cmd->data.setadapterparms.hdr.return_code !=
 						SET_ACCESS_CTRL_RC_SUCCESS)
 		QETH_DBF_MESSAGE(3, "ERR:SET_ACCESS_CTRL(%#x) on device %x: %#x\n",
@@ -4309,9 +4305,6 @@ static int qeth_setadpparms_set_access_ctrl(struct qeth_card *card,
 
 	QETH_CARD_TEXT(card, 4, "setacctl");
 
-	QETH_DBF_TEXT_(SETUP, 2, "setacctl");
-	QETH_DBF_TEXT_(SETUP, 2, "%s", card->gdev->dev.kobj.name);
-
 	iob = qeth_get_adapter_cmd(card, IPA_SETADP_SET_ACCESS_CONTROL,
 				   sizeof(struct qeth_ipacmd_setadpparms_hdr) +
 				   sizeof(struct qeth_set_access_ctrl));
@@ -4323,7 +4316,7 @@ static int qeth_setadpparms_set_access_ctrl(struct qeth_card *card,
 
 	rc = qeth_send_ipa_cmd(card, iob, qeth_setadpparms_set_access_ctrl_cb,
 			       &fallback);
-	QETH_DBF_TEXT_(SETUP, 2, "rc=%d", rc);
+	QETH_CARD_TEXT_(card, 2, "rc=%d", rc);
 	return rc;
 }
 
@@ -4699,7 +4692,7 @@ int qeth_vm_request_mac(struct qeth_card *card)
 	struct ccw_dev_id id;
 	int rc;
 
-	QETH_DBF_TEXT(SETUP, 2, "vmreqmac");
+	QETH_CARD_TEXT(card, 2, "vmreqmac");
 
 	request = kzalloc(sizeof(*request), GFP_KERNEL | GFP_DMA);
 	response = kzalloc(sizeof(*response), GFP_KERNEL | GFP_DMA);
@@ -4724,13 +4717,13 @@ int qeth_vm_request_mac(struct qeth_card *card)
 	if (request->resp_buf_len < sizeof(*response) ||
 	    response->version != request->resp_version) {
 		rc = -EIO;
-		QETH_DBF_TEXT(SETUP, 2, "badresp");
-		QETH_DBF_HEX(SETUP, 2, &request->resp_buf_len,
-			     sizeof(request->resp_buf_len));
+		QETH_CARD_TEXT(card, 2, "badresp");
+		QETH_CARD_HEX(card, 2, &request->resp_buf_len,
+			      sizeof(request->resp_buf_len));
 	} else if (!is_valid_ether_addr(response->mac)) {
 		rc = -EINVAL;
-		QETH_DBF_TEXT(SETUP, 2, "badmac");
-		QETH_DBF_HEX(SETUP, 2, response->mac, ETH_ALEN);
+		QETH_CARD_TEXT(card, 2, "badmac");
+		QETH_CARD_HEX(card, 2, response->mac, ETH_ALEN);
 	} else {
 		ether_addr_copy(card->dev->dev_addr, response->mac);
 	}
@@ -4750,13 +4743,13 @@ static void qeth_determine_capabilities(struct qeth_card *card)
 	struct ccw_device *ddev;
 	int ddev_offline = 0;
 
-	QETH_DBF_TEXT(SETUP, 2, "detcapab");
+	QETH_CARD_TEXT(card, 2, "detcapab");
 	ddev = CARD_DDEV(card);
 	if (!ddev->online) {
 		ddev_offline = 1;
 		rc = ccw_device_set_online(ddev);
 		if (rc) {
-			QETH_DBF_TEXT_(SETUP, 2, "3err%d", rc);
+			QETH_CARD_TEXT_(card, 2, "3err%d", rc);
 			goto out;
 		}
 	}
@@ -4765,7 +4758,7 @@ static void qeth_determine_capabilities(struct qeth_card *card)
 	if (rc) {
 		QETH_DBF_MESSAGE(2, "qeth_read_conf_data on device %x returned %i\n",
 				 CARD_DEVID(card), rc);
-		QETH_DBF_TEXT_(SETUP, 2, "5err%d", rc);
+		QETH_CARD_TEXT_(card, 2, "5err%d", rc);
 		goto out_offline;
 	}
 	qeth_configure_unitaddr(card, prcd);
@@ -4773,13 +4766,13 @@ static void qeth_determine_capabilities(struct qeth_card *card)
 
 	rc = qdio_get_ssqd_desc(ddev, &card->ssqd);
 	if (rc)
-		QETH_DBF_TEXT_(SETUP, 2, "6err%d", rc);
+		QETH_CARD_TEXT_(card, 2, "6err%d", rc);
 
-	QETH_DBF_TEXT_(SETUP, 2, "qfmt%d", card->ssqd.qfmt);
-	QETH_DBF_TEXT_(SETUP, 2, "ac1:%02x", card->ssqd.qdioac1);
-	QETH_DBF_TEXT_(SETUP, 2, "ac2:%04x", card->ssqd.qdioac2);
-	QETH_DBF_TEXT_(SETUP, 2, "ac3:%04x", card->ssqd.qdioac3);
-	QETH_DBF_TEXT_(SETUP, 2, "icnt%d", card->ssqd.icnt);
+	QETH_CARD_TEXT_(card, 2, "qfmt%d", card->ssqd.qfmt);
+	QETH_CARD_TEXT_(card, 2, "ac1:%02x", card->ssqd.qdioac1);
+	QETH_CARD_TEXT_(card, 2, "ac2:%04x", card->ssqd.qdioac2);
+	QETH_CARD_TEXT_(card, 2, "ac3:%04x", card->ssqd.qdioac3);
+	QETH_CARD_TEXT_(card, 2, "icnt%d", card->ssqd.icnt);
 	if (!((card->ssqd.qfmt != QDIO_IQDIO_QFMT) ||
 	    ((card->ssqd.qdioac1 & CHSC_AC1_INITIATE_INPUTQ) == 0) ||
 	    ((card->ssqd.qdioac3 & CHSC_AC3_FORMAT2_CQ_AVAILABLE) == 0))) {
@@ -4827,7 +4820,7 @@ static int qeth_qdio_establish(struct qeth_card *card)
 	int i, j, k;
 	int rc = 0;
 
-	QETH_DBF_TEXT(SETUP, 2, "qdioest");
+	QETH_CARD_TEXT(card, 2, "qdioest");
 
 	qib_param_field = kzalloc(QDIO_MAX_BUFFERS_PER_Q,
 				  GFP_KERNEL);
@@ -4931,8 +4924,7 @@ static int qeth_qdio_establish(struct qeth_card *card)
 
 static void qeth_core_free_card(struct qeth_card *card)
 {
-	QETH_DBF_TEXT(SETUP, 2, "freecrd");
-	QETH_DBF_HEX(SETUP, 2, &card, sizeof(void *));
+	QETH_CARD_TEXT(card, 2, "freecrd");
 	qeth_clean_channel(&card->read);
 	qeth_clean_channel(&card->write);
 	qeth_clean_channel(&card->data);
@@ -4984,7 +4976,7 @@ int qeth_core_hardsetup_card(struct qeth_card *card, bool *carrier_ok)
 	int retries = 3;
 	int rc;
 
-	QETH_DBF_TEXT(SETUP, 2, "hrdsetup");
+	QETH_CARD_TEXT(card, 2, "hrdsetup");
 	atomic_set(&card->force_alloc_skb, 0);
 	rc = qeth_update_from_chp_desc(card);
 	if (rc)
@@ -5009,10 +5001,10 @@ int qeth_core_hardsetup_card(struct qeth_card *card, bool *carrier_ok)
 		goto retriable;
 retriable:
 	if (rc == -ERESTARTSYS) {
-		QETH_DBF_TEXT(SETUP, 2, "break1");
+		QETH_CARD_TEXT(card, 2, "break1");
 		return rc;
 	} else if (rc) {
-		QETH_DBF_TEXT_(SETUP, 2, "1err%d", rc);
+		QETH_CARD_TEXT_(card, 2, "1err%d", rc);
 		if (--retries < 0)
 			goto out;
 		else
@@ -5024,10 +5016,10 @@ int qeth_core_hardsetup_card(struct qeth_card *card, bool *carrier_ok)
 
 	rc = qeth_idx_activate_read_channel(card);
 	if (rc == -EINTR) {
-		QETH_DBF_TEXT(SETUP, 2, "break2");
+		QETH_CARD_TEXT(card, 2, "break2");
 		return rc;
 	} else if (rc) {
-		QETH_DBF_TEXT_(SETUP, 2, "3err%d", rc);
+		QETH_CARD_TEXT_(card, 2, "3err%d", rc);
 		if (--retries < 0)
 			goto out;
 		else
@@ -5036,10 +5028,10 @@ int qeth_core_hardsetup_card(struct qeth_card *card, bool *carrier_ok)
 
 	rc = qeth_idx_activate_write_channel(card);
 	if (rc == -EINTR) {
-		QETH_DBF_TEXT(SETUP, 2, "break3");
+		QETH_CARD_TEXT(card, 2, "break3");
 		return rc;
 	} else if (rc) {
-		QETH_DBF_TEXT_(SETUP, 2, "4err%d", rc);
+		QETH_CARD_TEXT_(card, 2, "4err%d", rc);
 		if (--retries < 0)
 			goto out;
 		else
@@ -5048,13 +5040,13 @@ int qeth_core_hardsetup_card(struct qeth_card *card, bool *carrier_ok)
 	card->read_or_write_problem = 0;
 	rc = qeth_mpc_initialize(card);
 	if (rc) {
-		QETH_DBF_TEXT_(SETUP, 2, "5err%d", rc);
+		QETH_CARD_TEXT_(card, 2, "5err%d", rc);
 		goto out;
 	}
 
 	rc = qeth_send_startlan(card);
 	if (rc) {
-		QETH_DBF_TEXT_(SETUP, 2, "6err%d", rc);
+		QETH_CARD_TEXT_(card, 2, "6err%d", rc);
 		if (rc == -ENETDOWN) {
 			dev_warn(&card->gdev->dev, "The LAN is offline\n");
 			*carrier_ok = false;
@@ -5081,14 +5073,14 @@ int qeth_core_hardsetup_card(struct qeth_card *card, bool *carrier_ok)
 	if (qeth_is_supported(card, IPA_SETADAPTERPARMS)) {
 		rc = qeth_query_setadapterparms(card);
 		if (rc < 0) {
-			QETH_DBF_TEXT_(SETUP, 2, "7err%d", rc);
+			QETH_CARD_TEXT_(card, 2, "7err%d", rc);
 			goto out;
 		}
 	}
 	if (qeth_adp_supported(card, IPA_SETADP_SET_DIAG_ASSIST)) {
 		rc = qeth_query_setdiagass(card);
 		if (rc < 0) {
-			QETH_DBF_TEXT_(SETUP, 2, "8err%d", rc);
+			QETH_CARD_TEXT_(card, 2, "8err%d", rc);
 			goto out;
 		}
 	}
@@ -5705,7 +5697,7 @@ static void qeth_core_remove_device(struct ccwgroup_device *gdev)
 {
 	struct qeth_card *card = dev_get_drvdata(&gdev->dev);
 
-	QETH_DBF_TEXT(SETUP, 2, "removedv");
+	QETH_CARD_TEXT(card, 2, "removedv");
 
 	if (card->discipline) {
 		card->discipline->remove(gdev);
@@ -6102,8 +6094,8 @@ int qeth_set_features(struct net_device *dev, netdev_features_t features)
 	netdev_features_t changed = dev->features ^ features;
 	int rc = 0;
 
-	QETH_DBF_TEXT(SETUP, 2, "setfeat");
-	QETH_DBF_HEX(SETUP, 2, &features, sizeof(features));
+	QETH_CARD_TEXT(card, 2, "setfeat");
+	QETH_CARD_HEX(card, 2, &features, sizeof(features));
 
 	if ((changed & NETIF_F_IP_CSUM)) {
 		rc = qeth_set_ipa_csum(card, features & NETIF_F_IP_CSUM,
@@ -6149,7 +6141,7 @@ netdev_features_t qeth_fix_features(struct net_device *dev,
 {
 	struct qeth_card *card = dev->ml_priv;
 
-	QETH_DBF_TEXT(SETUP, 2, "fixfeat");
+	QETH_CARD_TEXT(card, 2, "fixfeat");
 	if (!qeth_is_supported(card, IPA_OUTBOUND_CHECKSUM))
 		features &= ~NETIF_F_IP_CSUM;
 	if (!qeth_is_supported6(card, IPA_OUTBOUND_CHECKSUM_V6))
@@ -6162,7 +6154,7 @@ netdev_features_t qeth_fix_features(struct net_device *dev,
 	if (!qeth_is_supported6(card, IPA_OUTBOUND_TSO))
 		features &= ~NETIF_F_TSO6;
 
-	QETH_DBF_HEX(SETUP, 2, &features, sizeof(features));
+	QETH_CARD_HEX(card, 2, &features, sizeof(features));
 	return features;
 }
 EXPORT_SYMBOL_GPL(qeth_fix_features);
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 7db2c5672e02..5fc36ed20c67 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -274,8 +274,7 @@ static int qeth_l2_vlan_rx_kill_vid(struct net_device *dev,
 
 static void qeth_l2_stop_card(struct qeth_card *card)
 {
-	QETH_DBF_TEXT(SETUP , 2, "stopcard");
-	QETH_DBF_HEX(SETUP, 2, &card, sizeof(void *));
+	QETH_CARD_TEXT(card, 2, "stopcard");
 
 	qeth_set_allowed_threads(card, 0, 1);
 
@@ -352,8 +351,7 @@ static int qeth_l2_request_initial_mac(struct qeth_card *card)
 {
 	int rc = 0;
 
-	QETH_DBF_TEXT(SETUP, 2, "l2reqmac");
-	QETH_DBF_TEXT_(SETUP, 2, "doL2%s", CARD_BUS_ID(card));
+	QETH_CARD_TEXT(card, 2, "l2reqmac");
 
 	if (MACHINE_IS_VM) {
 		rc = qeth_vm_request_mac(card);
@@ -361,7 +359,7 @@ static int qeth_l2_request_initial_mac(struct qeth_card *card)
 			goto out;
 		QETH_DBF_MESSAGE(2, "z/VM MAC Service failed on device %x: %#x\n",
 				 CARD_DEVID(card), rc);
-		QETH_DBF_TEXT_(SETUP, 2, "err%04x", rc);
+		QETH_CARD_TEXT_(card, 2, "err%04x", rc);
 		/* fall back to alternative mechanism: */
 	}
 
@@ -371,7 +369,7 @@ static int qeth_l2_request_initial_mac(struct qeth_card *card)
 			goto out;
 		QETH_DBF_MESSAGE(2, "READ_MAC Assist failed on device %x: %#x\n",
 				 CARD_DEVID(card), rc);
-		QETH_DBF_TEXT_(SETUP, 2, "1err%04x", rc);
+		QETH_CARD_TEXT_(card, 2, "1err%04x", rc);
 		/* fall back once more: */
 	}
 
@@ -381,7 +379,7 @@ static int qeth_l2_request_initial_mac(struct qeth_card *card)
 	eth_hw_addr_random(card->dev);
 
 out:
-	QETH_DBF_HEX(SETUP, 2, card->dev->dev_addr, card->dev->addr_len);
+	QETH_CARD_HEX(card, 2, card->dev->dev_addr, card->dev->addr_len);
 	return 0;
 }
 
@@ -465,7 +463,7 @@ static void qeth_promisc_to_bridge(struct qeth_card *card)
 		role = QETH_SBP_ROLE_NONE;
 
 	rc = qeth_bridgeport_setrole(card, role);
-	QETH_DBF_TEXT_(SETUP, 2, "bpm%c%04x",
+	QETH_CARD_TEXT_(card, 2, "bpm%c%04x",
 			(promisc_mode == SET_PROMISC_MODE_ON) ? '+' : '-', rc);
 	if (!rc) {
 		card->options.sbp.role = role;
@@ -794,12 +792,11 @@ static int qeth_l2_set_online(struct ccwgroup_device *gdev)
 
 	mutex_lock(&card->discipline_mutex);
 	mutex_lock(&card->conf_mutex);
-	QETH_DBF_TEXT(SETUP, 2, "setonlin");
-	QETH_DBF_HEX(SETUP, 2, &card, sizeof(void *));
+	QETH_CARD_TEXT(card, 2, "setonlin");
 
 	rc = qeth_core_hardsetup_card(card, &carrier_ok);
 	if (rc) {
-		QETH_DBF_TEXT_(SETUP, 2, "2err%04x", rc);
+		QETH_CARD_TEXT_(card, 2, "2err%04x", rc);
 		rc = -ENODEV;
 		goto out_remove;
 	}
@@ -830,7 +827,7 @@ static int qeth_l2_set_online(struct ccwgroup_device *gdev)
 	qeth_print_status_message(card);
 
 	/* softsetup */
-	QETH_DBF_TEXT(SETUP, 2, "softsetp");
+	QETH_CARD_TEXT(card, 2, "softsetp");
 
 	if (IS_OSD(card) || IS_OSX(card)) {
 		rc = qeth_l2_start_ipassists(card);
@@ -840,7 +837,7 @@ static int qeth_l2_set_online(struct ccwgroup_device *gdev)
 
 	rc = qeth_init_qdio_queues(card);
 	if (rc) {
-		QETH_DBF_TEXT_(SETUP, 2, "6err%d", rc);
+		QETH_CARD_TEXT_(card, 2, "6err%d", rc);
 		rc = -ENODEV;
 		goto out_remove;
 	}
@@ -894,8 +891,7 @@ static int __qeth_l2_set_offline(struct ccwgroup_device *cgdev,
 
 	mutex_lock(&card->discipline_mutex);
 	mutex_lock(&card->conf_mutex);
-	QETH_DBF_TEXT(SETUP, 3, "setoffl");
-	QETH_DBF_HEX(SETUP, 3, &card, sizeof(void *));
+	QETH_CARD_TEXT(card, 3, "setoffl");
 
 	if ((!recovery_mode && card->info.hwtrap) || card->info.hwtrap == 2) {
 		qeth_hw_trap(card, QETH_DIAGS_TRAP_DISARM);
@@ -916,7 +912,7 @@ static int __qeth_l2_set_offline(struct ccwgroup_device *cgdev,
 	if (!rc)
 		rc = (rc2) ? rc2 : rc3;
 	if (rc)
-		QETH_DBF_TEXT_(SETUP, 2, "1err%d", rc);
+		QETH_CARD_TEXT_(card, 2, "1err%d", rc);
 	qdio_free(CARD_DDEV(card));
 
 	/* let user_space know that device is offline */
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 99ca38164b99..15758f45837d 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -742,7 +742,7 @@ static int qeth_l3_setadapter_parms(struct qeth_card *card)
 {
 	int rc = 0;
 
-	QETH_DBF_TEXT(SETUP, 2, "setadprm");
+	QETH_CARD_TEXT(card, 2, "setadprm");
 
 	if (qeth_adp_supported(card, IPA_SETADP_ALTER_MAC_ADDRESS)) {
 		rc = qeth_setadpparms_change_macaddr(card);
@@ -979,7 +979,7 @@ static int qeth_l3_iqd_read_initial_mac(struct qeth_card *card)
 	struct qeth_cmd_buffer *iob;
 	struct qeth_ipa_cmd *cmd;
 
-	QETH_DBF_TEXT(SETUP, 2, "hsrmac");
+	QETH_CARD_TEXT(card, 2, "hsrmac");
 
 	iob = qeth_get_ipacmd_buffer(card, IPA_CMD_CREATE_ADDR,
 				     QETH_PROT_IPV6);
@@ -1017,7 +1017,7 @@ static int qeth_l3_get_unique_id(struct qeth_card *card)
 	struct qeth_cmd_buffer *iob;
 	struct qeth_ipa_cmd *cmd;
 
-	QETH_DBF_TEXT(SETUP, 2, "guniqeid");
+	QETH_CARD_TEXT(card, 2, "guniqeid");
 
 	if (!qeth_is_supported(card, IPA_IPV6)) {
 		card->info.unique_id =  UNIQUE_ID_IF_CREATE_ADDR_FAILED |
@@ -1044,7 +1044,7 @@ qeth_diags_trace_cb(struct qeth_card *card, struct qeth_reply *reply,
 	struct qeth_ipa_cmd	   *cmd;
 	__u16 rc;
 
-	QETH_DBF_TEXT(SETUP, 2, "diastrcb");
+	QETH_CARD_TEXT(card, 2, "diastrcb");
 
 	cmd = (struct qeth_ipa_cmd *)data;
 	rc = cmd->hdr.return_code;
@@ -1100,7 +1100,7 @@ qeth_diags_trace(struct qeth_card *card, enum qeth_diags_trace_cmds diags_cmd)
 	struct qeth_cmd_buffer *iob;
 	struct qeth_ipa_cmd    *cmd;
 
-	QETH_DBF_TEXT(SETUP, 2, "diagtrac");
+	QETH_CARD_TEXT(card, 2, "diagtrac");
 
 	iob = qeth_get_ipacmd_buffer(card, IPA_CMD_SET_DIAG_ASS, 0);
 	if (!iob)
@@ -1413,8 +1413,7 @@ static int qeth_l3_process_inbound_buffer(struct qeth_card *card,
 
 static void qeth_l3_stop_card(struct qeth_card *card)
 {
-	QETH_DBF_TEXT(SETUP, 2, "stopcard");
-	QETH_DBF_HEX(SETUP, 2, &card, sizeof(void *));
+	QETH_CARD_TEXT(card, 2, "stopcard");
 
 	qeth_set_allowed_threads(card, 0, 1);
 
@@ -2335,12 +2334,11 @@ static int qeth_l3_set_online(struct ccwgroup_device *gdev)
 
 	mutex_lock(&card->discipline_mutex);
 	mutex_lock(&card->conf_mutex);
-	QETH_DBF_TEXT(SETUP, 2, "setonlin");
-	QETH_DBF_HEX(SETUP, 2, &card, sizeof(void *));
+	QETH_CARD_TEXT(card, 2, "setonlin");
 
 	rc = qeth_core_hardsetup_card(card, &carrier_ok);
 	if (rc) {
-		QETH_DBF_TEXT_(SETUP, 2, "2err%04x", rc);
+		QETH_CARD_TEXT_(card, 2, "2err%04x", rc);
 		rc = -ENODEV;
 		goto out_remove;
 	}
@@ -2356,28 +2354,28 @@ static int qeth_l3_set_online(struct ccwgroup_device *gdev)
 	qeth_print_status_message(card);
 
 	/* softsetup */
-	QETH_DBF_TEXT(SETUP, 2, "softsetp");
+	QETH_CARD_TEXT(card, 2, "softsetp");
 
 	rc = qeth_l3_setadapter_parms(card);
 	if (rc)
-		QETH_DBF_TEXT_(SETUP, 2, "2err%04x", rc);
+		QETH_CARD_TEXT_(card, 2, "2err%04x", rc);
 	if (!card->options.sniffer) {
 		rc = qeth_l3_start_ipassists(card);
 		if (rc) {
-			QETH_DBF_TEXT_(SETUP, 2, "3err%d", rc);
+			QETH_CARD_TEXT_(card, 2, "3err%d", rc);
 			goto out_remove;
 		}
 		rc = qeth_l3_setrouting_v4(card);
 		if (rc)
-			QETH_DBF_TEXT_(SETUP, 2, "4err%04x", rc);
+			QETH_CARD_TEXT_(card, 2, "4err%04x", rc);
 		rc = qeth_l3_setrouting_v6(card);
 		if (rc)
-			QETH_DBF_TEXT_(SETUP, 2, "5err%04x", rc);
+			QETH_CARD_TEXT_(card, 2, "5err%04x", rc);
 	}
 
 	rc = qeth_init_qdio_queues(card);
 	if (rc) {
-		QETH_DBF_TEXT_(SETUP, 2, "6err%d", rc);
+		QETH_CARD_TEXT_(card, 2, "6err%d", rc);
 		rc = -ENODEV;
 		goto out_remove;
 	}
@@ -2432,8 +2430,7 @@ static int __qeth_l3_set_offline(struct ccwgroup_device *cgdev,
 
 	mutex_lock(&card->discipline_mutex);
 	mutex_lock(&card->conf_mutex);
-	QETH_DBF_TEXT(SETUP, 3, "setoffl");
-	QETH_DBF_HEX(SETUP, 3, &card, sizeof(void *));
+	QETH_CARD_TEXT(card, 3, "setoffl");
 
 	if ((!recovery_mode && card->info.hwtrap) || card->info.hwtrap == 2) {
 		qeth_hw_trap(card, QETH_DIAGS_TRAP_DISARM);
@@ -2459,7 +2456,7 @@ static int __qeth_l3_set_offline(struct ccwgroup_device *cgdev,
 	if (!rc)
 		rc = (rc2) ? rc2 : rc3;
 	if (rc)
-		QETH_DBF_TEXT_(SETUP, 2, "1err%d", rc);
+		QETH_CARD_TEXT_(card, 2, "1err%d", rc);
 	qdio_free(CARD_DDEV(card));
 
 	/* let user_space know that device is offline */
-- 
2.17.1

