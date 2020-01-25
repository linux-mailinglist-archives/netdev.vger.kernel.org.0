Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6B4F149674
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 16:53:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgAYPxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 10:53:15 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55796 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726382AbgAYPxO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 10:53:14 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00PFa1eW147265
        for <netdev@vger.kernel.org>; Sat, 25 Jan 2020 10:53:13 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xrk39xccp-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 25 Jan 2020 10:53:13 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Sat, 25 Jan 2020 15:53:11 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sat, 25 Jan 2020 15:53:10 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00PFr8Oi46858668
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 25 Jan 2020 15:53:09 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DAE0A4C046;
        Sat, 25 Jan 2020 15:53:08 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A24464C04A;
        Sat, 25 Jan 2020 15:53:08 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat, 25 Jan 2020 15:53:08 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 5/5] s390/qeth: remove HARDSETUP state
Date:   Sat, 25 Jan 2020 16:53:03 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200125155303.40971-1-jwi@linux.ibm.com>
References: <20200125155303.40971-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20012515-4275-0000-0000-0000039AD3DB
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20012515-4276-0000-0000-000038AEE5DE
Message-Id: <20200125155303.40971-6-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-25_05:2020-01-24,2020-01-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 suspectscore=2 phishscore=0 priorityscore=1501 mlxscore=0
 adultscore=0 spamscore=0 clxscore=1015 mlxlogscore=989 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2001250132
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qeth_l?_stop_card() is _never_ called while in HARDSETUP state, and
there's no other usage of the card state that relies on the
DOWN -> HARDSETUP -> SOFTSETUP transition.

As related cleanup, remove the check in qeth_realloc_buffer_pool() as it
is already done by the callers.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      |  1 -
 drivers/s390/net/qeth_core_main.c |  3 ---
 drivers/s390/net/qeth_core_sys.c  |  2 --
 drivers/s390/net/qeth_l2_main.c   |  4 ----
 drivers/s390/net/qeth_l3_main.c   | 14 +++-----------
 5 files changed, 3 insertions(+), 21 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 950d01551373..9575a627a1e1 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -558,7 +558,6 @@ enum qeth_channel_states {
  */
 enum qeth_card_states {
 	CARD_STATE_DOWN,
-	CARD_STATE_HARDSETUP,
 	CARD_STATE_SOFTSETUP,
 };
 
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 0f5f36e63823..9639938581f5 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -247,9 +247,6 @@ int qeth_realloc_buffer_pool(struct qeth_card *card, int bufcnt)
 {
 	QETH_CARD_TEXT(card, 2, "realcbp");
 
-	if (card->state != CARD_STATE_DOWN)
-		return -EPERM;
-
 	/* TODO: steel/add buffers from/to a running card's buffer pool (?) */
 	qeth_clear_working_pool_list(card);
 	qeth_free_buffer_pool(card);
diff --git a/drivers/s390/net/qeth_core_sys.c b/drivers/s390/net/qeth_core_sys.c
index 7bd86027f559..2bd9993aa60b 100644
--- a/drivers/s390/net/qeth_core_sys.c
+++ b/drivers/s390/net/qeth_core_sys.c
@@ -24,8 +24,6 @@ static ssize_t qeth_dev_state_show(struct device *dev,
 	switch (card->state) {
 	case CARD_STATE_DOWN:
 		return sprintf(buf, "DOWN\n");
-	case CARD_STATE_HARDSETUP:
-		return sprintf(buf, "HARDSETUP\n");
 	case CARD_STATE_SOFTSETUP:
 		if (card->dev->flags & IFF_UP)
 			return sprintf(buf, "UP (LAN %s)\n",
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index d5ffd40937d3..692bd2623401 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -283,9 +283,6 @@ static void qeth_l2_stop_card(struct qeth_card *card)
 
 	if (card->state == CARD_STATE_SOFTSETUP) {
 		qeth_clear_ipacmd_list(card);
-		card->state = CARD_STATE_HARDSETUP;
-	}
-	if (card->state == CARD_STATE_HARDSETUP) {
 		qeth_drain_output_queues(card);
 		card->state = CARD_STATE_DOWN;
 	}
@@ -776,7 +773,6 @@ static int qeth_l2_set_online(struct qeth_card *card)
 	qeth_trace_features(card);
 	qeth_l2_trace_features(card);
 
-	card->state = CARD_STATE_HARDSETUP;
 	qeth_print_status_message(card);
 
 	/* softsetup */
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index eb2d9c427b10..317d56647a4a 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -901,7 +901,7 @@ static int qeth_l3_start_ipa_broadcast(struct qeth_card *card)
 	return rc;
 }
 
-static int qeth_l3_start_ipassists(struct qeth_card *card)
+static void qeth_l3_start_ipassists(struct qeth_card *card)
 {
 	QETH_CARD_TEXT(card, 3, "strtipas");
 
@@ -911,7 +911,6 @@ static int qeth_l3_start_ipassists(struct qeth_card *card)
 	qeth_l3_start_ipa_multicast(card);		/* go on*/
 	qeth_l3_start_ipa_ipv6(card);		/* go on*/
 	qeth_l3_start_ipa_broadcast(card);		/* go on*/
-	return 0;
 }
 
 static int qeth_l3_iqd_read_initial_mac_cb(struct qeth_card *card,
@@ -1178,9 +1177,6 @@ static void qeth_l3_stop_card(struct qeth_card *card)
 	if (card->state == CARD_STATE_SOFTSETUP) {
 		qeth_l3_clear_ip_htable(card, 1);
 		qeth_clear_ipacmd_list(card);
-		card->state = CARD_STATE_HARDSETUP;
-	}
-	if (card->state == CARD_STATE_HARDSETUP) {
 		qeth_drain_output_queues(card);
 		card->state = CARD_STATE_DOWN;
 	}
@@ -2068,7 +2064,6 @@ static int qeth_l3_set_online(struct qeth_card *card)
 		goto out_remove;
 	}
 
-	card->state = CARD_STATE_HARDSETUP;
 	qeth_print_status_message(card);
 
 	/* softsetup */
@@ -2078,11 +2073,8 @@ static int qeth_l3_set_online(struct qeth_card *card)
 	if (rc)
 		QETH_CARD_TEXT_(card, 2, "2err%04x", rc);
 	if (!card->options.sniffer) {
-		rc = qeth_l3_start_ipassists(card);
-		if (rc) {
-			QETH_CARD_TEXT_(card, 2, "3err%d", rc);
-			goto out_remove;
-		}
+		qeth_l3_start_ipassists(card);
+
 		rc = qeth_l3_setrouting_v4(card);
 		if (rc)
 			QETH_CARD_TEXT_(card, 2, "4err%04x", rc);
-- 
2.17.1

