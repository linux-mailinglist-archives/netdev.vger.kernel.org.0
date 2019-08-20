Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFFB6962C3
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 16:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730276AbfHTOq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 10:46:57 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32108 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730159AbfHTOq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 10:46:57 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7KEZM61097669
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 10:46:56 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ughxqbe8y-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 10:46:56 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Tue, 20 Aug 2019 15:46:53 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 20 Aug 2019 15:46:52 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7KEkpuK60227766
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 14:46:51 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 07DC611C04C;
        Tue, 20 Aug 2019 14:46:51 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BC01311C05B;
        Tue, 20 Aug 2019 14:46:50 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 20 Aug 2019 14:46:50 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 1/9] s390/qeth: use node_descriptor struct
Date:   Tue, 20 Aug 2019 16:46:35 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190820144643.64041-1-jwi@linux.ibm.com>
References: <20190820144643.64041-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19082014-0012-0000-0000-00000340BBCA
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19082014-0013-0000-0000-0000217AE04C
Message-Id: <20190820144643.64041-2-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-20_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908200145
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rather than fumbling with hard-coded offsets, use the proper struct to
access the retrieved RCD information.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      |  2 +-
 drivers/s390/net/qeth_core_main.c | 31 +++++++++++++++++++++++--------
 2 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 28db887d38ed..47e01cdd1775 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -651,7 +651,7 @@ struct qeth_card_blkt {
 struct qeth_card_info {
 	unsigned short unit_addr2;
 	unsigned short cula;
-	unsigned short chpid;
+	u8 chpid;
 	__u16 func_level;
 	char mcl_level[QETH_MCL_LENGTH + 1];
 	u8 open_when_online:1;
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 0803070246aa..50f2773a1f8c 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -1775,19 +1775,32 @@ static int qeth_send_control_data(struct qeth_card *card,
 	return rc;
 }
 
+struct qeth_node_desc {
+	struct node_descriptor nd1;
+	struct node_descriptor nd2;
+	struct node_descriptor nd3;
+};
+
 static void qeth_read_conf_data_cb(struct qeth_card *card,
 				   struct qeth_cmd_buffer *iob)
 {
-	unsigned char *prcd = iob->data;
+	struct qeth_node_desc *nd = (struct qeth_node_desc *) iob->data;
+	u8 *tag;
 
 	QETH_CARD_TEXT(card, 2, "cfgunit");
-	card->info.chpid = prcd[30];
-	card->info.unit_addr2 = prcd[31];
-	card->info.cula = prcd[63];
-	card->info.is_vm_nic = ((prcd[0x10] == _ascebc['V']) &&
-				(prcd[0x11] == _ascebc['M']));
-	card->info.use_v1_blkt = prcd[74] == 0xF0 && prcd[75] == 0xF0 &&
-				 prcd[76] >= 0xF1 && prcd[76] <= 0xF4;
+	card->info.is_vm_nic = nd->nd1.plant[0] == _ascebc['V'] &&
+			       nd->nd1.plant[1] == _ascebc['M'];
+	tag = (u8 *)&nd->nd1.tag;
+	card->info.chpid = tag[0];
+	card->info.unit_addr2 = tag[1];
+
+	tag = (u8 *)&nd->nd2.tag;
+	card->info.cula = tag[1];
+
+	card->info.use_v1_blkt = nd->nd3.model[0] == 0xF0 &&
+				 nd->nd3.model[1] == 0xF0 &&
+				 nd->nd3.model[2] >= 0xF1 &&
+				 nd->nd3.model[2] <= 0xF4;
 
 	qeth_notify_reply(iob->reply, 0);
 	qeth_put_cmd(iob);
@@ -1803,6 +1816,8 @@ static int qeth_read_conf_data(struct qeth_card *card)
 	ciw = ccw_device_get_ciw(channel->ccwdev, CIW_TYPE_RCD);
 	if (!ciw || ciw->cmd == 0)
 		return -EOPNOTSUPP;
+	if (ciw->count < sizeof(struct qeth_node_desc))
+		return -EINVAL;
 
 	iob = qeth_alloc_cmd(channel, ciw->count, 1, QETH_RCD_TIMEOUT);
 	if (!iob)
-- 
2.17.1

