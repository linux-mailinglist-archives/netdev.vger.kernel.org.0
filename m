Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10BD7640BC
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 07:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbfGJFdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 01:33:22 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49158 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727089AbfGJFdP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 01:33:15 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6A5SweC016908;
        Wed, 10 Jul 2019 05:33:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=w6FK4Bahgy7fMBI7ZAjTSDt9NWIBZ1xoNSvpaVY8DFE=;
 b=szFuctmfrxjYYrWWg4FBp7tHbglgeOjWo5zw2gyf278/knFm/+MbWfqSPYph2W2ayxR0
 kffYp4RTnsQ542LM3x7JMOoXlDVloqXzKeocrS0nK/2sayhf71M8wiSqTIRXL+JAf/17
 OKIPKXuQ8S//88y2pbjWE1axkDY8s/9GmDMIDFqPQBbx1J9yNjiSvV0sgUQeGZxMy+fa
 HRexbxJPC6kfnOvIKaFTLJcV/NTuGLy/tRDoyg1uoc86Xl2QE2v8cecdWPMa+10G5WcN
 yyPCSaxg3QWsukOqMJd6GI13x7lAVp0mq9dpDRMcOtcCIrp4LeJIqidjR+c3YmoWuDcm Eg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2tjk2tqxf3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Jul 2019 05:33:09 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6A5X9jo157323;
        Wed, 10 Jul 2019 05:33:09 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2tn1j0nw33-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Jul 2019 05:33:08 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6A5X7Hh009416;
        Wed, 10 Jul 2019 05:33:07 GMT
Received: from localhost.localdomain (/10.159.154.151)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 09 Jul 2019 22:33:07 -0700
From:   Santosh Shilimkar <santosh.shilimkar@oracle.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     santosh.shilimkar@oracle.com
Subject: [net][PATCH 2/5] Revert "RDS: IB: split the mr registration and invalidation path"
Date:   Tue,  9 Jul 2019 22:32:41 -0700
Message-Id: <1562736764-31752-3-git-send-email-santosh.shilimkar@oracle.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1562736764-31752-1-git-send-email-santosh.shilimkar@oracle.com>
References: <1562736764-31752-1-git-send-email-santosh.shilimkar@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9313 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=975
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907100067
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9313 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907100066
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gerd Rausch <gerd.rausch@oracle.com>

This reverts commit 56012459310a1dbcc55c2dbf5500a9f7571402cb.

RDS kept spinning inside function "rds_ib_post_reg_frmr", waiting for
"i_fastreg_wrs" to become incremented:
         while (atomic_dec_return(&ibmr->ic->i_fastreg_wrs) <= 0) {
                 atomic_inc(&ibmr->ic->i_fastreg_wrs);
                 cpu_relax();
         }

Looking at the original commit:

commit 56012459310a ("RDS: IB: split the mr registration and
invalidation path")

In there, the "rds_ib_mr_cqe_handler" was changed in the following
way:

 void rds_ib_mr_cqe_handler(struct
 rds_ib_connection *ic,
 struct ib_wc *wc)
        if (frmr->fr_inv) {
                  frmr->fr_state = FRMR_IS_FREE;
                  frmr->fr_inv = false;
                atomic_inc(&ic->i_fastreg_wrs);
        } else {
                atomic_inc(&ic->i_fastunreg_wrs);
        }

It looks like it's got it exactly backwards:

Function "rds_ib_post_reg_frmr" keeps track of the outstanding
requests via "i_fastreg_wrs".

Function "rds_ib_post_inv" keeps track of the outstanding requests
via "i_fastunreg_wrs" (post original commit). It also sets:
         frmr->fr_inv = true;

However the completion handler "rds_ib_mr_cqe_handler" adjusts
"i_fastreg_wrs" when "fr_inv" had been true, and adjusts
"i_fastunreg_wrs" otherwise.

The original commit was done in the name of performance:
to remove the performance bottleneck

No performance benefit could be observed with a fixed-up version
of the original commit measured between two Oracle X7 servers,
both equipped with Mellanox Connect-X5 HCAs.

The prudent course of action is to revert this commit.

Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
---
 net/rds/ib.h      |  4 +---
 net/rds/ib_cm.c   |  9 ++-------
 net/rds/ib_frmr.c | 11 +++++------
 3 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/net/rds/ib.h b/net/rds/ib.h
index 67a715b..66c03c7 100644
--- a/net/rds/ib.h
+++ b/net/rds/ib.h
@@ -15,8 +15,7 @@
 
 #define RDS_IB_DEFAULT_RECV_WR		1024
 #define RDS_IB_DEFAULT_SEND_WR		256
-#define RDS_IB_DEFAULT_FR_WR		256
-#define RDS_IB_DEFAULT_FR_INV_WR	256
+#define RDS_IB_DEFAULT_FR_WR		512
 
 #define RDS_IB_DEFAULT_RETRY_COUNT	1
 
@@ -157,7 +156,6 @@ struct rds_ib_connection {
 
 	/* To control the number of wrs from fastreg */
 	atomic_t		i_fastreg_wrs;
-	atomic_t		i_fastunreg_wrs;
 
 	/* interrupt handling */
 	struct tasklet_struct	i_send_tasklet;
diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
index 66c6eb5..8891822 100644
--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -460,10 +460,7 @@ static int rds_ib_setup_qp(struct rds_connection *conn)
 	 * completion queue and send queue. This extra space is used for FRMR
 	 * registration and invalidation work requests
 	 */
-	fr_queue_space = rds_ibdev->use_fastreg ?
-			 (RDS_IB_DEFAULT_FR_WR + 1) +
-			 (RDS_IB_DEFAULT_FR_INV_WR + 1)
-			 : 0;
+	fr_queue_space = (rds_ibdev->use_fastreg ? RDS_IB_DEFAULT_FR_WR : 0);
 
 	/* add the conn now so that connection establishment has the dev */
 	rds_ib_add_conn(rds_ibdev, conn);
@@ -530,7 +527,6 @@ static int rds_ib_setup_qp(struct rds_connection *conn)
 	attr.send_cq = ic->i_send_cq;
 	attr.recv_cq = ic->i_recv_cq;
 	atomic_set(&ic->i_fastreg_wrs, RDS_IB_DEFAULT_FR_WR);
-	atomic_set(&ic->i_fastunreg_wrs, RDS_IB_DEFAULT_FR_INV_WR);
 
 	/*
 	 * XXX this can fail if max_*_wr is too large?  Are we supposed
@@ -1009,8 +1005,7 @@ void rds_ib_conn_path_shutdown(struct rds_conn_path *cp)
 		wait_event(rds_ib_ring_empty_wait,
 			   rds_ib_ring_empty(&ic->i_recv_ring) &&
 			   (atomic_read(&ic->i_signaled_sends) == 0) &&
-			   (atomic_read(&ic->i_fastreg_wrs) == RDS_IB_DEFAULT_FR_WR) &&
-			   (atomic_read(&ic->i_fastunreg_wrs) == RDS_IB_DEFAULT_FR_INV_WR));
+			   (atomic_read(&ic->i_fastreg_wrs) == RDS_IB_DEFAULT_FR_WR));
 		tasklet_kill(&ic->i_send_tasklet);
 		tasklet_kill(&ic->i_recv_tasklet);
 
diff --git a/net/rds/ib_frmr.c b/net/rds/ib_frmr.c
index 688dcd6..32ae26e 100644
--- a/net/rds/ib_frmr.c
+++ b/net/rds/ib_frmr.c
@@ -239,8 +239,8 @@ static int rds_ib_post_inv(struct rds_ib_mr *ibmr)
 	if (frmr->fr_state != FRMR_IS_INUSE)
 		goto out;
 
-	while (atomic_dec_return(&ibmr->ic->i_fastunreg_wrs) <= 0) {
-		atomic_inc(&ibmr->ic->i_fastunreg_wrs);
+	while (atomic_dec_return(&ibmr->ic->i_fastreg_wrs) <= 0) {
+		atomic_inc(&ibmr->ic->i_fastreg_wrs);
 		cpu_relax();
 	}
 
@@ -257,7 +257,7 @@ static int rds_ib_post_inv(struct rds_ib_mr *ibmr)
 	if (unlikely(ret)) {
 		frmr->fr_state = FRMR_IS_STALE;
 		frmr->fr_inv = false;
-		atomic_inc(&ibmr->ic->i_fastunreg_wrs);
+		atomic_inc(&ibmr->ic->i_fastreg_wrs);
 		pr_err("RDS/IB: %s returned error(%d)\n", __func__, ret);
 		goto out;
 	}
@@ -285,10 +285,9 @@ void rds_ib_mr_cqe_handler(struct rds_ib_connection *ic, struct ib_wc *wc)
 	if (frmr->fr_inv) {
 		frmr->fr_state = FRMR_IS_FREE;
 		frmr->fr_inv = false;
-		atomic_inc(&ic->i_fastreg_wrs);
-	} else {
-		atomic_inc(&ic->i_fastunreg_wrs);
 	}
+
+	atomic_inc(&ic->i_fastreg_wrs);
 }
 
 void rds_ib_unreg_frmr(struct list_head *list, unsigned int *nfreed,
-- 
1.9.1

