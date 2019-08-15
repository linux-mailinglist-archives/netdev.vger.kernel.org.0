Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 783B18E873
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 11:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731489AbfHOJjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 05:39:00 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40300 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731289AbfHOJi7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 05:38:59 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7F9cp0N081368;
        Thu, 15 Aug 2019 09:38:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2019-08-05;
 bh=NiOQItys2rGPcm2AIh3NktxbZ2EbUmPGL3w8EK/wUgs=;
 b=EmtE9xsNhHnJbFONNrkEuyy4CGKNEgNAGEb0mOfKCsEXc7d/5LP12wYiRHRJyFRUjIMh
 DyTJjsJERFCm9gDYUh15IvBC3HIsZHjDNJuvfKrwO8a5eaoS5MWQ4obttIV4ccmEllHp
 z22jH1sbxpHuxGsKGNP2SOYmW1qZoLLMWhnKqiAuq2wfgVF7atff7+iuACdK9NybxnFz
 VMsyRcbwASflPb+MlzlL/LIO842aZF2FiBzo1FTXFuFDjwEV3G8WOAwZbGCYoX7uhqdH
 TzitoD5uV7QuXNYO/XtOwjAQsK6AaMGdnPmsa01jtiJnWujiXkQ26hQ5dsr8JAAAY6/l kg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2u9nvpj2q8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Aug 2019 09:38:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7F9XnZL179389;
        Thu, 15 Aug 2019 09:36:50 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 2ucpys6s3w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 15 Aug 2019 09:36:50 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x7F9aoY3184855;
        Thu, 15 Aug 2019 09:36:50 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2ucpys6s3n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Aug 2019 09:36:50 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7F9anA0014551;
        Thu, 15 Aug 2019 09:36:49 GMT
Received: from ca-dev40.us.oracle.com (/10.129.135.27)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 15 Aug 2019 02:36:48 -0700
From:   Ka-Cheong Poon <ka-cheong.poon@oracle.com>
To:     netdev@vger.kernel.org
Cc:     santosh.shilimkar@oracle.com, davem@davemloft.net,
        rds-devel@oss.oracle.com
Subject: [PATCH net-next] net/rds: Add RDS6_INFO_SOCKETS and RDS6_INFO_RECV_MESSAGES options
Date:   Thu, 15 Aug 2019 02:36:43 -0700
Message-Id: <1565861803-31268-1-git-send-email-ka-cheong.poon@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9349 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908150102
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support of the socket options RDS6_INFO_SOCKETS and
RDS6_INFO_RECV_MESSAGES which update the RDS_INFO_SOCKETS and
RDS_INFO_RECV_MESSAGES options respectively.  The old options work
for IPv4 sockets only.

Signed-off-by: Ka-Cheong Poon <ka-cheong.poon@oracle.com>
---
 net/rds/af_rds.c | 93 ++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 90 insertions(+), 3 deletions(-)

diff --git a/net/rds/af_rds.c b/net/rds/af_rds.c
index 2b969f9..e7b082a 100644
--- a/net/rds/af_rds.c
+++ b/net/rds/af_rds.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2006, 2018 Oracle and/or its affiliates. All rights reserved.
+ * Copyright (c) 2006, 2019 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -741,6 +741,10 @@ static void rds_sock_inc_info(struct socket *sock, unsigned int len,
 	spin_lock_bh(&rds_sock_lock);
 
 	list_for_each_entry(rs, &rds_sock_list, rs_item) {
+		/* This option only supports IPv4 sockets. */
+		if (!ipv6_addr_v4mapped(&rs->rs_bound_addr))
+			continue;
+
 		read_lock(&rs->rs_recv_lock);
 
 		/* XXX too lazy to maintain counts.. */
@@ -762,21 +766,60 @@ static void rds_sock_inc_info(struct socket *sock, unsigned int len,
 	lens->each = sizeof(struct rds_info_message);
 }
 
+#if IS_ENABLED(CONFIG_IPV6)
+static void rds6_sock_inc_info(struct socket *sock, unsigned int len,
+			       struct rds_info_iterator *iter,
+			       struct rds_info_lengths *lens)
+{
+	struct rds_incoming *inc;
+	unsigned int total = 0;
+	struct rds_sock *rs;
+
+	len /= sizeof(struct rds6_info_message);
+
+	spin_lock_bh(&rds_sock_lock);
+
+	list_for_each_entry(rs, &rds_sock_list, rs_item) {
+		read_lock(&rs->rs_recv_lock);
+
+		list_for_each_entry(inc, &rs->rs_recv_queue, i_item) {
+			total++;
+			if (total <= len)
+				rds6_inc_info_copy(inc, iter, &inc->i_saddr,
+						   &rs->rs_bound_addr, 1);
+		}
+
+		read_unlock(&rs->rs_recv_lock);
+	}
+
+	spin_unlock_bh(&rds_sock_lock);
+
+	lens->nr = total;
+	lens->each = sizeof(struct rds6_info_message);
+}
+#endif
+
 static void rds_sock_info(struct socket *sock, unsigned int len,
 			  struct rds_info_iterator *iter,
 			  struct rds_info_lengths *lens)
 {
 	struct rds_info_socket sinfo;
+	unsigned int cnt = 0;
 	struct rds_sock *rs;
 
 	len /= sizeof(struct rds_info_socket);
 
 	spin_lock_bh(&rds_sock_lock);
 
-	if (len < rds_sock_count)
+	if (len < rds_sock_count) {
+		cnt = rds_sock_count;
 		goto out;
+	}
 
 	list_for_each_entry(rs, &rds_sock_list, rs_item) {
+		/* This option only supports IPv4 sockets. */
+		if (!ipv6_addr_v4mapped(&rs->rs_bound_addr))
+			continue;
 		sinfo.sndbuf = rds_sk_sndbuf(rs);
 		sinfo.rcvbuf = rds_sk_rcvbuf(rs);
 		sinfo.bound_addr = rs->rs_bound_addr_v4;
@@ -786,15 +829,51 @@ static void rds_sock_info(struct socket *sock, unsigned int len,
 		sinfo.inum = sock_i_ino(rds_rs_to_sk(rs));
 
 		rds_info_copy(iter, &sinfo, sizeof(sinfo));
+		cnt++;
 	}
 
 out:
-	lens->nr = rds_sock_count;
+	lens->nr = cnt;
 	lens->each = sizeof(struct rds_info_socket);
 
 	spin_unlock_bh(&rds_sock_lock);
 }
 
+#if IS_ENABLED(CONFIG_IPV6)
+static void rds6_sock_info(struct socket *sock, unsigned int len,
+			   struct rds_info_iterator *iter,
+			   struct rds_info_lengths *lens)
+{
+	struct rds6_info_socket sinfo6;
+	struct rds_sock *rs;
+
+	len /= sizeof(struct rds6_info_socket);
+
+	spin_lock_bh(&rds_sock_lock);
+
+	if (len < rds_sock_count)
+		goto out;
+
+	list_for_each_entry(rs, &rds_sock_list, rs_item) {
+		sinfo6.sndbuf = rds_sk_sndbuf(rs);
+		sinfo6.rcvbuf = rds_sk_rcvbuf(rs);
+		sinfo6.bound_addr = rs->rs_bound_addr;
+		sinfo6.connected_addr = rs->rs_conn_addr;
+		sinfo6.bound_port = rs->rs_bound_port;
+		sinfo6.connected_port = rs->rs_conn_port;
+		sinfo6.inum = sock_i_ino(rds_rs_to_sk(rs));
+
+		rds_info_copy(iter, &sinfo6, sizeof(sinfo6));
+	}
+
+ out:
+	lens->nr = rds_sock_count;
+	lens->each = sizeof(struct rds6_info_socket);
+
+	spin_unlock_bh(&rds_sock_lock);
+}
+#endif
+
 static void rds_exit(void)
 {
 	sock_unregister(rds_family_ops.family);
@@ -808,6 +887,10 @@ static void rds_exit(void)
 	rds_bind_lock_destroy();
 	rds_info_deregister_func(RDS_INFO_SOCKETS, rds_sock_info);
 	rds_info_deregister_func(RDS_INFO_RECV_MESSAGES, rds_sock_inc_info);
+#if IS_ENABLED(CONFIG_IPV6)
+	rds_info_deregister_func(RDS6_INFO_SOCKETS, rds6_sock_info);
+	rds_info_deregister_func(RDS6_INFO_RECV_MESSAGES, rds6_sock_inc_info);
+#endif
 }
 module_exit(rds_exit);
 
@@ -845,6 +928,10 @@ static int rds_init(void)
 
 	rds_info_register_func(RDS_INFO_SOCKETS, rds_sock_info);
 	rds_info_register_func(RDS_INFO_RECV_MESSAGES, rds_sock_inc_info);
+#if IS_ENABLED(CONFIG_IPV6)
+	rds_info_register_func(RDS6_INFO_SOCKETS, rds6_sock_info);
+	rds_info_register_func(RDS6_INFO_RECV_MESSAGES, rds6_sock_inc_info);
+#endif
 
 	goto out;
 
-- 
1.8.3.1

