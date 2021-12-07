Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26F7F46B698
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 10:05:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233448AbhLGJI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 04:08:57 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47102 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233443AbhLGJIw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 04:08:52 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B77GcDc021792;
        Tue, 7 Dec 2021 09:05:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=J1cVPa61Sfoe3YsYUFudEdPhxP2kYGghhFOxL3FKzfI=;
 b=SaToWhHVSSWQd2jpxavkklphMeW6ATSkFJE+RTEz6h7/G/PK32jiCjuU0UrImtBRDkMe
 ukx4QwzQC4JlF7ecR3gCHKrJKzoMbVB3GUNL7hYpWbhtNbKmtiEoM3GM4RwkrBXJOB1E
 sq4hsYfzKvUXeVhGvYl9w0iM1tCWLD33/uES/MraYxBSBh+H2BYgmZ0p1mYiJE4kRmaS
 vUT5OVMofn0HlecD5Lwom0VFoz28U4dxGddBiHei1buWmwv/8+2f26XbjU3mvJekot+0
 +aRFyCp2VFim0l4CHe+mnFRxO8LQoZ4a4lb0Qbi4XYa2n+o/4TVpJ6NU+aFR5Zu7gosP UQ== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ct334t3mp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 09:05:14 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B791rfK000406;
        Tue, 7 Dec 2021 09:05:13 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3cqyy9ve8p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 09:05:12 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B79592030146880
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Dec 2021 09:05:09 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 267E9AE063;
        Tue,  7 Dec 2021 09:05:09 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 15756AE051;
        Tue,  7 Dec 2021 09:05:09 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue,  7 Dec 2021 09:05:09 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55271)
        id 7B924E12B0; Tue,  7 Dec 2021 10:05:08 +0100 (CET)
From:   Alexandra Winter <wintera@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>
Subject: [PATCH net-next 5/5] s390/qeth: remove check for packing mode in qeth_check_outbound_queue()
Date:   Tue,  7 Dec 2021 10:04:52 +0100
Message-Id: <20211207090452.1155688-6-wintera@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211207090452.1155688-1-wintera@linux.ibm.com>
References: <20211207090452.1155688-1-wintera@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Yfa6lWlB4tmLzH1ur8tm1ubO68G8CYWb
X-Proofpoint-ORIG-GUID: Yfa6lWlB4tmLzH1ur8tm1ubO68G8CYWb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-07_03,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 mlxscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 impostorscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112070054
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

If qeth_check_outbound_queue() finds a partially filled TX buffer on
the queue and flushes it, then the queue _must_ have been in packing
mode.

Remove the redundant check when updating the relevant statistics.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 093ee14e8051..c296e0556f49 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -3635,12 +3635,10 @@ static void qeth_check_outbound_queue(struct qeth_qdio_out_q *queue)
 	if ((atomic_read(&queue->used_buffers) <= QETH_LOW_WATERMARK_PACK) ||
 	    !atomic_read(&queue->set_pci_flags_count)) {
 		unsigned int index, flush_cnt;
-		bool q_was_packing;
 
 		spin_lock(&queue->lock);
 
 		index = queue->next_buf_to_fill;
-		q_was_packing = queue->do_pack;
 
 		flush_cnt = qeth_switch_to_nonpacking_if_needed(queue);
 		if (!flush_cnt && !atomic_read(&queue->set_pci_flags_count))
@@ -3648,8 +3646,7 @@ static void qeth_check_outbound_queue(struct qeth_qdio_out_q *queue)
 
 		if (flush_cnt) {
 			qeth_flush_buffers(queue, index, flush_cnt);
-			if (q_was_packing)
-				QETH_TXQ_STAT_ADD(queue, bufs_pack, flush_cnt);
+			QETH_TXQ_STAT_ADD(queue, bufs_pack, flush_cnt);
 		}
 
 		spin_unlock(&queue->lock);
-- 
2.32.0

