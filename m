Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12A922B69A1
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 17:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727184AbgKQQPg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 11:15:36 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45938 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726884AbgKQQPe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 11:15:34 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AHFZHaZ047817;
        Tue, 17 Nov 2020 11:15:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=hrRaKNEXR7UncwKSunJoY61kSQPBbgqKEh2FwOj6Ygg=;
 b=VEZLIGwCSVyEEgz4YoibBfCDVik69S4GImkwfpVtyrTzrQ0X4NvcA54q6nZ0FRi4//wz
 YaRxR4gYHSAJG/bsbLyKsIRWRdn+2X1e1pSgAyX4Z3LR4kdY5pbXIM7yONMSsh891wMC
 PMZG1gbuhDzFjIqgaJMbPf4aL2YP76JlgTkOYbYONlIo8OZyQEWzSex+Z/UGxmUvUhIW
 0lluRsidB6GeN2ygwWjtrv8gYUzClpzE/fPRy0yqrpgRqCYOSRIgZP9mvXZIt4YaUMrH
 faLwRqhOqlN2LBnkjO9xjSWWI2ub8O1zK0hOo1uidl9eXzV8AoHolNhR58BYQM7AiIhx 9w== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34vfd85p02-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 11:15:31 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AHG8AEF004984;
        Tue, 17 Nov 2020 16:15:29 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 34t6v8b8yq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 16:15:29 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AHGFQ4W64422304
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Nov 2020 16:15:26 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 21DBFA405F;
        Tue, 17 Nov 2020 16:15:26 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DAB62A406A;
        Tue, 17 Nov 2020 16:15:25 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 17 Nov 2020 16:15:25 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 1/9] s390/qeth: don't call INIT_LIST_HEAD() on iob's list entry
Date:   Tue, 17 Nov 2020 17:15:12 +0100
Message-Id: <20201117161520.1089-2-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201117161520.1089-1-jwi@linux.ibm.com>
References: <20201117161520.1089-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-17_04:2020-11-17,2020-11-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 clxscore=1015 priorityscore=1501 phishscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170114
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

INIT_LIST_HEAD() only needs to be called on actual list heads.
While at it clarify the naming of the field.

Suggested-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      | 2 +-
 drivers/s390/net/qeth_core_main.c | 9 ++++-----
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index f73b4756ed5e..ec4525bd62e1 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -621,7 +621,7 @@ struct qeth_reply {
 };
 
 struct qeth_cmd_buffer {
-	struct list_head list;
+	struct list_head list_entry;
 	struct completion done;
 	spinlock_t lock;
 	unsigned int length;
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 93c9b30ab17a..67e5c46e8373 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -609,7 +609,7 @@ static void qeth_enqueue_cmd(struct qeth_card *card,
 			     struct qeth_cmd_buffer *iob)
 {
 	spin_lock_irq(&card->lock);
-	list_add_tail(&iob->list, &card->cmd_waiter_list);
+	list_add_tail(&iob->list_entry, &card->cmd_waiter_list);
 	spin_unlock_irq(&card->lock);
 }
 
@@ -617,7 +617,7 @@ static void qeth_dequeue_cmd(struct qeth_card *card,
 			     struct qeth_cmd_buffer *iob)
 {
 	spin_lock_irq(&card->lock);
-	list_del(&iob->list);
+	list_del(&iob->list_entry);
 	spin_unlock_irq(&card->lock);
 }
 
@@ -971,7 +971,7 @@ static void qeth_clear_ipacmd_list(struct qeth_card *card)
 	QETH_CARD_TEXT(card, 4, "clipalst");
 
 	spin_lock_irqsave(&card->lock, flags);
-	list_for_each_entry(iob, &card->cmd_waiter_list, list)
+	list_for_each_entry(iob, &card->cmd_waiter_list, list_entry)
 		qeth_notify_cmd(iob, -ECANCELED);
 	spin_unlock_irqrestore(&card->lock, flags);
 }
@@ -1041,7 +1041,6 @@ struct qeth_cmd_buffer *qeth_alloc_cmd(struct qeth_channel *channel,
 
 	init_completion(&iob->done);
 	spin_lock_init(&iob->lock);
-	INIT_LIST_HEAD(&iob->list);
 	refcount_set(&iob->ref_count, 1);
 	iob->channel = channel;
 	iob->timeout = timeout;
@@ -1088,7 +1087,7 @@ static void qeth_issue_next_read_cb(struct qeth_card *card,
 
 	/* match against pending cmd requests */
 	spin_lock_irqsave(&card->lock, flags);
-	list_for_each_entry(tmp, &card->cmd_waiter_list, list) {
+	list_for_each_entry(tmp, &card->cmd_waiter_list, list_entry) {
 		if (tmp->match && tmp->match(tmp, iob)) {
 			request = tmp;
 			/* take the object outside the lock */
-- 
2.17.1

