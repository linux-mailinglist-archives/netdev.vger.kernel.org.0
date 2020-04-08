Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 128071A1EAD
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 12:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbgDHKVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 06:21:19 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56224 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726521AbgDHKVT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 06:21:19 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 038ADliZ118979;
        Wed, 8 Apr 2020 10:21:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=jhFlMGAhryb0OEnOAZN5ySeN86EhDTD7tAAj+a4B5SM=;
 b=IYRmV4rWCctBj4h/4pFnR2QmIQuBdTC19BwEkkrguluVCGBc/n+ZivFTnAMSfBxbu7ax
 4dOv1tAUqwiFU9RgJt86pUErdJcUOtEN+Lq4CbaVxH14MZlGzazJvImAJW1uSTRBOFuK
 b6YrfxP+Z4F2EZRMyCZVhwyBiyDznqEuMhgybGMLeKLmN17xHhCbKvviyOS/sTkHfDEK
 TmuG/UfDk+cIf1i7QfRFZVkaeJt+IUWElJgZcXUh/ZUPw5/PB3Z9ICz3MT/8Cz5R1Tfh
 oyE96AspVhBb+KM8/zUTGcsSdGFaGoiEID0ABrXnPZeEHt9o62M8ej9GbU59Uo1z2VSH aA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 3091m0tm5s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 10:21:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 038ACYFH015983;
        Wed, 8 Apr 2020 10:21:08 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 3099v8mym9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 08 Apr 2020 10:21:08 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 038AL7ts038739;
        Wed, 8 Apr 2020 10:21:07 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 3099v8myk8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 10:21:07 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 038AL63e002134;
        Wed, 8 Apr 2020 10:21:06 GMT
Received: from ca-dev40.us.oracle.com (/10.129.135.27)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 08 Apr 2020 03:21:06 -0700
From:   Ka-Cheong Poon <ka-cheong.poon@oracle.com>
To:     netdev@vger.kernel.org
Cc:     santosh.shilimkar@oracle.com, davem@davemloft.net,
        rds-devel@oss.oracle.com, sironhide0null@gmail.com
Subject: [PATCH v2 net 1/2] net/rds: Replace struct rds_mr's r_refcount with struct kref
Date:   Wed,  8 Apr 2020 03:21:01 -0700
Message-Id: <fb149123516920dd5f5bf730a1da3a0cb9f3d25e.1586340235.git.ka-cheong.poon@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9584 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 priorityscore=1501 phishscore=0 suspectscore=3 bulkscore=0
 lowpriorityscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004080085
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

And removed rds_mr_put().

Signed-off-by: Ka-Cheong Poon <ka-cheong.poon@oracle.com>
---
 net/rds/message.c |  6 +++---
 net/rds/rdma.c    | 28 +++++++++++++++-------------
 net/rds/rds.h     |  9 ++-------
 3 files changed, 20 insertions(+), 23 deletions(-)

diff --git a/net/rds/message.c b/net/rds/message.c
index 50f13f1..bbecb8c 100644
--- a/net/rds/message.c
+++ b/net/rds/message.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2006 Oracle.  All rights reserved.
+ * Copyright (c) 2006, 2020 Oracle and/or its affiliates.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -162,12 +162,12 @@ static void rds_message_purge(struct rds_message *rm)
 	if (rm->rdma.op_active)
 		rds_rdma_free_op(&rm->rdma);
 	if (rm->rdma.op_rdma_mr)
-		rds_mr_put(rm->rdma.op_rdma_mr);
+		kref_put(&rm->rdma.op_rdma_mr->r_kref, __rds_put_mr_final);
 
 	if (rm->atomic.op_active)
 		rds_atomic_free_op(&rm->atomic);
 	if (rm->atomic.op_rdma_mr)
-		rds_mr_put(rm->atomic.op_rdma_mr);
+		kref_put(&rm->atomic.op_rdma_mr->r_kref, __rds_put_mr_final);
 }
 
 void rds_message_put(struct rds_message *rm)
diff --git a/net/rds/rdma.c b/net/rds/rdma.c
index 585e6b3..f828b66 100644
--- a/net/rds/rdma.c
+++ b/net/rds/rdma.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2007, 2017 Oracle and/or its affiliates. All rights reserved.
+ * Copyright (c) 2007, 2020 Oracle and/or its affiliates.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -84,7 +84,7 @@ static struct rds_mr *rds_mr_tree_walk(struct rb_root *root, u64 key,
 	if (insert) {
 		rb_link_node(&insert->r_rb_node, parent, p);
 		rb_insert_color(&insert->r_rb_node, root);
-		refcount_inc(&insert->r_refcount);
+		kref_get(&insert->r_kref);
 	}
 	return NULL;
 }
@@ -99,7 +99,7 @@ static void rds_destroy_mr(struct rds_mr *mr)
 	unsigned long flags;
 
 	rdsdebug("RDS: destroy mr key is %x refcnt %u\n",
-			mr->r_key, refcount_read(&mr->r_refcount));
+		 mr->r_key, kref_read(&mr->r_kref));
 
 	if (test_and_set_bit(RDS_MR_DEAD, &mr->r_state))
 		return;
@@ -115,8 +115,10 @@ static void rds_destroy_mr(struct rds_mr *mr)
 		mr->r_trans->free_mr(trans_private, mr->r_invalidate);
 }
 
-void __rds_put_mr_final(struct rds_mr *mr)
+void __rds_put_mr_final(struct kref *kref)
 {
+	struct rds_mr *mr = container_of(kref, struct rds_mr, r_kref);
+
 	rds_destroy_mr(mr);
 	kfree(mr);
 }
@@ -141,7 +143,7 @@ void rds_rdma_drop_keys(struct rds_sock *rs)
 		RB_CLEAR_NODE(&mr->r_rb_node);
 		spin_unlock_irqrestore(&rs->rs_rdma_lock, flags);
 		rds_destroy_mr(mr);
-		rds_mr_put(mr);
+		kref_put(&mr->r_kref, __rds_put_mr_final);
 		spin_lock_irqsave(&rs->rs_rdma_lock, flags);
 	}
 	spin_unlock_irqrestore(&rs->rs_rdma_lock, flags);
@@ -242,7 +244,7 @@ static int __rds_rdma_map(struct rds_sock *rs, struct rds_get_mr_args *args,
 		goto out;
 	}
 
-	refcount_set(&mr->r_refcount, 1);
+	kref_init(&mr->r_kref);
 	RB_CLEAR_NODE(&mr->r_rb_node);
 	mr->r_trans = rs->rs_transport;
 	mr->r_sock = rs;
@@ -343,7 +345,7 @@ static int __rds_rdma_map(struct rds_sock *rs, struct rds_get_mr_args *args,
 
 	rdsdebug("RDS: get_mr key is %x\n", mr->r_key);
 	if (mr_ret) {
-		refcount_inc(&mr->r_refcount);
+		kref_get(&mr->r_kref);
 		*mr_ret = mr;
 	}
 
@@ -351,7 +353,7 @@ static int __rds_rdma_map(struct rds_sock *rs, struct rds_get_mr_args *args,
 out:
 	kfree(pages);
 	if (mr)
-		rds_mr_put(mr);
+		kref_put(&mr->r_kref, __rds_put_mr_final);
 	return ret;
 }
 
@@ -440,7 +442,7 @@ int rds_free_mr(struct rds_sock *rs, char __user *optval, int optlen)
 	 * someone else drops their ref.
 	 */
 	rds_destroy_mr(mr);
-	rds_mr_put(mr);
+	kref_put(&mr->r_kref, __rds_put_mr_final);
 	return 0;
 }
 
@@ -481,7 +483,7 @@ void rds_rdma_unuse(struct rds_sock *rs, u32 r_key, int force)
 	 * trigger an async flush. */
 	if (zot_me) {
 		rds_destroy_mr(mr);
-		rds_mr_put(mr);
+		kref_put(&mr->r_kref, __rds_put_mr_final);
 	}
 }
 
@@ -490,7 +492,7 @@ void rds_rdma_free_op(struct rm_rdma_op *ro)
 	unsigned int i;
 
 	if (ro->op_odp_mr) {
-		rds_mr_put(ro->op_odp_mr);
+		kref_put(&ro->op_odp_mr->r_kref, __rds_put_mr_final);
 	} else {
 		for (i = 0; i < ro->op_nents; i++) {
 			struct page *page = sg_page(&ro->op_sg[i]);
@@ -730,7 +732,7 @@ int rds_cmsg_rdma_args(struct rds_sock *rs, struct rds_message *rm,
 				goto out_pages;
 			}
 			RB_CLEAR_NODE(&local_odp_mr->r_rb_node);
-			refcount_set(&local_odp_mr->r_refcount, 1);
+			kref_init(&local_odp_mr->r_kref);
 			local_odp_mr->r_trans = rs->rs_transport;
 			local_odp_mr->r_sock = rs;
 			local_odp_mr->r_trans_private =
@@ -827,7 +829,7 @@ int rds_cmsg_rdma_dest(struct rds_sock *rs, struct rds_message *rm,
 	if (!mr)
 		err = -EINVAL;	/* invalid r_key */
 	else
-		refcount_inc(&mr->r_refcount);
+		kref_get(&mr->r_kref);
 	spin_unlock_irqrestore(&rs->rs_rdma_lock, flags);
 
 	if (mr) {
diff --git a/net/rds/rds.h b/net/rds/rds.h
index e4a6035..3cda01c 100644
--- a/net/rds/rds.h
+++ b/net/rds/rds.h
@@ -291,7 +291,7 @@ struct rds_incoming {
 
 struct rds_mr {
 	struct rb_node		r_rb_node;
-	refcount_t		r_refcount;
+	struct kref		r_kref;
 	u32			r_key;
 
 	/* A copy of the creation flags */
@@ -946,12 +946,7 @@ int rds_cmsg_rdma_map(struct rds_sock *rs, struct rds_message *rm,
 int rds_cmsg_atomic(struct rds_sock *rs, struct rds_message *rm,
 		    struct cmsghdr *cmsg);
 
-void __rds_put_mr_final(struct rds_mr *mr);
-static inline void rds_mr_put(struct rds_mr *mr)
-{
-	if (refcount_dec_and_test(&mr->r_refcount))
-		__rds_put_mr_final(mr);
-}
+void __rds_put_mr_final(struct kref *kref);
 
 static inline bool rds_destroy_pending(struct rds_connection *conn)
 {
-- 
1.8.3.1

