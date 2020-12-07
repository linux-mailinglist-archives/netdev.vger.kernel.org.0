Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 357582D1187
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 14:14:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbgLGNNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 08:13:25 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32798 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726456AbgLGNNY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 08:13:24 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B7D3NqR020046;
        Mon, 7 Dec 2020 08:12:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=YQPNeIPF6RIBmrywOjzZrAxoOvJe1FYJqrFOmQUs/DQ=;
 b=NHD5Qap9eCEfcm8FqWdx5IpmEuWDDGrJ58XEOpCT4gzmYe/BZRION5edQCJKFZZdKAR9
 CSGXknJ4eppy0R9+WmHV32YX+yx3n9Xaf7VqyCBpLT9/ISxjVVpZUVzbytCx83VHn6Q3
 QCu0uv26OYhxYMKO7J4U6eJiTkXeM1v1InTBOuhad9hSg8JiKTOAH0BUMRZEH3uDGp/+
 vhO1d1VHqAqJfbbZ6mWVgq7voK7eS/NTsVoHbyhqQeP/JQ/2QFvh3Mish9aHeZtpHC5f
 o6UxYBVDiB18c+PrLjNV6Dq0LLAjTZXG6dvUMZH7gVw4NAXox5SCQVjctvjqPbIIouay fQ== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 359kccbabe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Dec 2020 08:12:42 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B7DCee5001506;
        Mon, 7 Dec 2020 13:12:40 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3581fhjgpe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Dec 2020 13:12:40 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B7DCbpt7340732
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Dec 2020 13:12:37 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8053B11C05C;
        Mon,  7 Dec 2020 13:12:37 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4ACF811C05B;
        Mon,  7 Dec 2020 13:12:37 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Dec 2020 13:12:37 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 5/6] s390/qeth: remove QETH_QDIO_BUF_HANDLED_DELAYED state
Date:   Mon,  7 Dec 2020 14:12:32 +0100
Message-Id: <20201207131233.90383-6-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201207131233.90383-1-jwi@linux.ibm.com>
References: <20201207131233.90383-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-07_11:2020-12-04,2020-12-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 suspectscore=2 malwarescore=0 mlxlogscore=999
 spamscore=0 bulkscore=0 priorityscore=1501 phishscore=0 adultscore=0
 impostorscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012070080
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reuse the QETH_QDIO_BUF_EMPTY state to indicate that a TX buffer has
been completed with a QAOB notification, and may be cleaned up by
qeth_cleanup_handled_pending().

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      | 2 --
 drivers/s390/net/qeth_core_main.c | 5 ++---
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index d150da95d073..6f5ddc3eab8c 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -424,8 +424,6 @@ enum qeth_qdio_out_buffer_state {
 	/* Received QAOB notification on CQ: */
 	QETH_QDIO_BUF_QAOB_OK,
 	QETH_QDIO_BUF_QAOB_ERROR,
-	/* Handled via transfer pending / completion queue. */
-	QETH_QDIO_BUF_HANDLED_DELAYED,
 };
 
 struct qeth_qdio_out_buffer {
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 869694217450..da27ef451d05 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -477,8 +477,7 @@ static void qeth_cleanup_handled_pending(struct qeth_qdio_out_q *q, int bidx,
 
 		while (c) {
 			if (forced_cleanup ||
-			    atomic_read(&c->state) ==
-			      QETH_QDIO_BUF_HANDLED_DELAYED) {
+			    atomic_read(&c->state) == QETH_QDIO_BUF_EMPTY) {
 				struct qeth_qdio_out_buffer *f = c;
 
 				QETH_CARD_TEXT(f->q->card, 5, "fp");
@@ -549,7 +548,7 @@ static void qeth_qdio_handle_aob(struct qeth_card *card,
 				kmem_cache_free(qeth_core_header_cache, data);
 		}
 
-		atomic_set(&buffer->state, QETH_QDIO_BUF_HANDLED_DELAYED);
+		atomic_set(&buffer->state, QETH_QDIO_BUF_EMPTY);
 		break;
 	default:
 		WARN_ON_ONCE(1);
-- 
2.17.1

