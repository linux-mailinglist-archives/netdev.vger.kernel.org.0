Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 620041918F6
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 19:25:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727985AbgCXSZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 14:25:05 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36360 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727957AbgCXSZE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 14:25:04 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02OI4Hjt093932
        for <netdev@vger.kernel.org>; Tue, 24 Mar 2020 14:25:04 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ywe7tp27r-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 24 Mar 2020 14:25:04 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Tue, 24 Mar 2020 18:24:59 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 24 Mar 2020 18:24:56 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02OIOvkg41484444
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Mar 2020 18:24:57 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A15EBA405B;
        Tue, 24 Mar 2020 18:24:57 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6A5EFA4062;
        Tue, 24 Mar 2020 18:24:57 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 24 Mar 2020 18:24:57 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 10/11] s390/qeth: keep track of fixed prio-queue configuration
Date:   Tue, 24 Mar 2020 19:24:47 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200324182448.95362-1-jwi@linux.ibm.com>
References: <20200324182448.95362-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20032418-4275-0000-0000-000003B2452A
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20032418-4276-0000-0000-000038C77FF2
Message-Id: <20200324182448.95362-11-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-24_05:2020-03-23,2020-03-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 impostorscore=0 bulkscore=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2003240090
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a device is configured in prio-queue mode to pin all traffic onto
a specific HW queue, treat this as a distinct variant of prio-queueing
instead of QETH_NO_PRIO_QUEUEING.

This corrects an error message from qeth_osa_set_output_queues() for
devices configured in such a mode.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      | 1 +
 drivers/s390/net/qeth_core_main.c | 2 ++
 drivers/s390/net/qeth_core_sys.c  | 8 ++++----
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index a6553e78af08..5f85617bdce3 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -211,6 +211,7 @@ struct qeth_vnicc_info {
 #define QETH_PRIO_Q_ING_TOS   2
 #define QETH_PRIO_Q_ING_SKB   3
 #define QETH_PRIO_Q_ING_VLAN  4
+#define QETH_PRIO_Q_ING_FIXED 5
 
 /* Packing */
 #define QETH_LOW_WATERMARK_PACK  2
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 37073e68647a..4940e4fb556e 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -3646,6 +3646,8 @@ int qeth_get_priority_queue(struct qeth_card *card, struct sk_buff *skb)
 			return ~ntohs(veth->h_vlan_TCI) >>
 			       (VLAN_PRIO_SHIFT + 1) & 3;
 		break;
+	case QETH_PRIO_Q_ING_FIXED:
+		return card->qdio.default_out_queue;
 	default:
 		break;
 	}
diff --git a/drivers/s390/net/qeth_core_sys.c b/drivers/s390/net/qeth_core_sys.c
index 533a7f26dbe1..d7e429f6631e 100644
--- a/drivers/s390/net/qeth_core_sys.c
+++ b/drivers/s390/net/qeth_core_sys.c
@@ -211,16 +211,16 @@ static ssize_t qeth_dev_prioqing_store(struct device *dev,
 		card->qdio.do_prio_queueing = QETH_PRIO_Q_ING_VLAN;
 		card->qdio.default_out_queue = QETH_DEFAULT_QUEUE;
 	} else if (sysfs_streq(buf, "no_prio_queueing:0")) {
-		card->qdio.do_prio_queueing = QETH_NO_PRIO_QUEUEING;
+		card->qdio.do_prio_queueing = QETH_PRIO_Q_ING_FIXED;
 		card->qdio.default_out_queue = 0;
 	} else if (sysfs_streq(buf, "no_prio_queueing:1")) {
-		card->qdio.do_prio_queueing = QETH_NO_PRIO_QUEUEING;
+		card->qdio.do_prio_queueing = QETH_PRIO_Q_ING_FIXED;
 		card->qdio.default_out_queue = 1;
 	} else if (sysfs_streq(buf, "no_prio_queueing:2")) {
-		card->qdio.do_prio_queueing = QETH_NO_PRIO_QUEUEING;
+		card->qdio.do_prio_queueing = QETH_PRIO_Q_ING_FIXED;
 		card->qdio.default_out_queue = 2;
 	} else if (sysfs_streq(buf, "no_prio_queueing:3")) {
-		card->qdio.do_prio_queueing = QETH_NO_PRIO_QUEUEING;
+		card->qdio.do_prio_queueing = QETH_PRIO_Q_ING_FIXED;
 		card->qdio.default_out_queue = 3;
 	} else if (sysfs_streq(buf, "no_prio_queueing")) {
 		card->qdio.do_prio_queueing = QETH_NO_PRIO_QUEUEING;
-- 
2.17.1

