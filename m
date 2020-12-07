Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F39772D118D
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 14:14:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbgLGNN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 08:13:29 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:4570 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725994AbgLGNNZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 08:13:25 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B7D3sYo156925;
        Mon, 7 Dec 2020 08:12:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=1GGuCG5/vrNUI2W87fr44kb7dIsquH04Z/K6O/GGrjs=;
 b=aXsGsUSHI3VYlMPezOXOe3zY7m8RoAtfYiKv3nrle1T7lG3nvpFBqU0OUcRy0x0PJl+a
 ej6pdvhk/P27xxtHpyDQ7FAfj4nOIk9u4LEA/kYcRNgXMhHGDgEWkrNc4iwWyll1qTEn
 2CUTG2ZYGHM6uzFEX/4FnnIkU/fMETX7c2Y71SlunlKJ+GrGShvhPh3Qp7S64ch9UPNl
 NckB/XQ6aMx07WwYPLcbJChS7DCy8nEQOnr7Q/LcxQ8nF+GEKMM+OPeDiN5c67HK+64Y
 NO3DFBgHVlhqPCGtccpUNojTmuq3ZT1oWYg8cwLlCny+9S4TJWEJokrw78fzrKMeNNQF uQ== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 359m0pt5f5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Dec 2020 08:12:40 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B7DCdlu000920;
        Mon, 7 Dec 2020 13:12:39 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3583svjdhb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Dec 2020 13:12:39 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B7DCaJm22872358
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Dec 2020 13:12:36 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3FCDB11C054;
        Mon,  7 Dec 2020 13:12:36 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 09A7511C04C;
        Mon,  7 Dec 2020 13:12:36 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Dec 2020 13:12:35 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 1/6] s390/qeth: don't call INIT_LIST_HEAD() on iob's list entry
Date:   Mon,  7 Dec 2020 14:12:28 +0100
Message-Id: <20201207131233.90383-2-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201207131233.90383-1-jwi@linux.ibm.com>
References: <20201207131233.90383-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-07_11:2020-12-04,2020-12-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 priorityscore=1501 impostorscore=0
 clxscore=1015 adultscore=0 spamscore=0 lowpriorityscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012070080
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
index 0e9af2fbaa76..69b474f8735e 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -624,7 +624,7 @@ struct qeth_reply {
 };
 
 struct qeth_cmd_buffer {
-	struct list_head list;
+	struct list_head list_entry;
 	struct completion done;
 	spinlock_t lock;
 	unsigned int length;
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 319190824cd2..8171b9d3a70e 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -615,7 +615,7 @@ static void qeth_enqueue_cmd(struct qeth_card *card,
 			     struct qeth_cmd_buffer *iob)
 {
 	spin_lock_irq(&card->lock);
-	list_add_tail(&iob->list, &card->cmd_waiter_list);
+	list_add_tail(&iob->list_entry, &card->cmd_waiter_list);
 	spin_unlock_irq(&card->lock);
 }
 
@@ -623,7 +623,7 @@ static void qeth_dequeue_cmd(struct qeth_card *card,
 			     struct qeth_cmd_buffer *iob)
 {
 	spin_lock_irq(&card->lock);
-	list_del(&iob->list);
+	list_del(&iob->list_entry);
 	spin_unlock_irq(&card->lock);
 }
 
@@ -977,7 +977,7 @@ static void qeth_clear_ipacmd_list(struct qeth_card *card)
 	QETH_CARD_TEXT(card, 4, "clipalst");
 
 	spin_lock_irqsave(&card->lock, flags);
-	list_for_each_entry(iob, &card->cmd_waiter_list, list)
+	list_for_each_entry(iob, &card->cmd_waiter_list, list_entry)
 		qeth_notify_cmd(iob, -ECANCELED);
 	spin_unlock_irqrestore(&card->lock, flags);
 }
@@ -1047,7 +1047,6 @@ struct qeth_cmd_buffer *qeth_alloc_cmd(struct qeth_channel *channel,
 
 	init_completion(&iob->done);
 	spin_lock_init(&iob->lock);
-	INIT_LIST_HEAD(&iob->list);
 	refcount_set(&iob->ref_count, 1);
 	iob->channel = channel;
 	iob->timeout = timeout;
@@ -1094,7 +1093,7 @@ static void qeth_issue_next_read_cb(struct qeth_card *card,
 
 	/* match against pending cmd requests */
 	spin_lock_irqsave(&card->lock, flags);
-	list_for_each_entry(tmp, &card->cmd_waiter_list, list) {
+	list_for_each_entry(tmp, &card->cmd_waiter_list, list_entry) {
 		if (tmp->match && tmp->match(tmp, iob)) {
 			request = tmp;
 			/* take the object outside the lock */
-- 
2.17.1

