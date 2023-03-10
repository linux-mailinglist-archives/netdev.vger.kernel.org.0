Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91D526B5418
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 23:16:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231682AbjCJWQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 17:16:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231599AbjCJWQQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 17:16:16 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B98F7136FCA;
        Fri, 10 Mar 2023 14:16:14 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32ALhsWu026773;
        Fri, 10 Mar 2023 22:15:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2022-7-12;
 bh=eaW63H5WYY0jeCFNsqmZWFmy2A0ZfYVHoEKBNGRcozA=;
 b=gO4oGQ20MThbf5ZSpPHwMelBXTsrpfRhD05zn2SQtsSu+0ONbjWINM5isPF666p1AH+7
 Olfj1DOISrZuowUZbDrGpyDd3r+FdcQOixWzpH8jAkpfbOyLWIPtQ8aY3fYQMFfwQ5nY
 lHD2lEEe58H+onst+avtJPDq/XfZ5aq/dC0b1JUAhF5m8b2LQOsO3Qx4USXIX2AdNw0+
 5+2khnOpW+Nw8YAxaXq1E1bHbhTYFUjv/JacKwCr9lqXDUzRnPcwuo/zQs5R1kWlc9pf
 XjiSKiXo5fqUpS3lfJcQYGbZTuqw64HFiMZobBm+sSET7JnXcVK/GpH5dLJPYrnGb4NT MQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p417cp9hv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Mar 2023 22:15:56 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32AM4FaM031459;
        Fri, 10 Mar 2023 22:15:55 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p6feqs9s5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Mar 2023 22:15:55 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32AMFrOv028711;
        Fri, 10 Mar 2023 22:15:54 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3p6feqs9nh-2;
        Fri, 10 Mar 2023 22:15:54 +0000
From:   Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
To:     davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        zbr@ioremap.net, brauner@kernel.org, johannes@sipsolutions.net,
        ecree.xilinx@gmail.com, leon@kernel.org, keescook@chromium.org,
        socketcan@hartkopp.net, petrm@nvidia.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        anjali.k.kulkarni@oracle.com
Subject: [PATCH v1 1/5] netlink: Reverse the patch which removed filtering
Date:   Fri, 10 Mar 2023 14:15:43 -0800
Message-Id: <20230310221547.3656194-2-anjali.k.kulkarni@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310221547.3656194-1-anjali.k.kulkarni@oracle.com>
References: <20230310221547.3656194-1-anjali.k.kulkarni@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-10_10,2023-03-10_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303100177
X-Proofpoint-GUID: LBlGDv1AlfA9IyiA-Lq_Xq8-cd2RDTSq
X-Proofpoint-ORIG-GUID: LBlGDv1AlfA9IyiA-Lq_Xq8-cd2RDTSq
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To use filtering at the connector & cn_proc layers, we need to enable
filtering in the netlink layer. This reverses the patch which removed
netlink filtering:
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=549017aa1bb7`

Signed-off-by: Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
---
 include/linux/netlink.h  |  5 +++++
 net/netlink/af_netlink.c | 25 +++++++++++++++++++++++--
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index c43ac7690eca..866bbc5a4c8d 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -206,6 +206,11 @@ bool netlink_strict_get_check(struct sk_buff *skb);
 int netlink_unicast(struct sock *ssk, struct sk_buff *skb, __u32 portid, int nonblock);
 int netlink_broadcast(struct sock *ssk, struct sk_buff *skb, __u32 portid,
 		      __u32 group, gfp_t allocation);
+int netlink_broadcast_filtered(struct sock *ssk, struct sk_buff *skb,
+			       __u32 portid, __u32 group, gfp_t allocation,
+			       int (*filter)(struct sock *dsk,
+					     struct sk_buff *skb, void *data),
+			       void *filter_data);
 int netlink_set_err(struct sock *ssk, __u32 portid, __u32 group, int code);
 int netlink_register_notifier(struct notifier_block *nb);
 int netlink_unregister_notifier(struct notifier_block *nb);
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index c64277659753..003c7e6ec9be 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1432,6 +1432,8 @@ struct netlink_broadcast_data {
 	int delivered;
 	gfp_t allocation;
 	struct sk_buff *skb, *skb2;
+	int (*tx_filter)(struct sock *dsk, struct sk_buff *skb, void *data);
+	void *tx_data;
 };
 
 static void do_one_broadcast(struct sock *sk,
@@ -1485,6 +1487,11 @@ static void do_one_broadcast(struct sock *sk,
 			p->delivery_failure = 1;
 		goto out;
 	}
+	if (p->tx_filter && p->tx_filter(sk, p->skb2, p->tx_data)) {
+		kfree_skb(p->skb2);
+		p->skb2 = NULL;
+		goto out;
+	}
 	if (sk_filter(sk, p->skb2)) {
 		kfree_skb(p->skb2);
 		p->skb2 = NULL;
@@ -1507,8 +1514,12 @@ static void do_one_broadcast(struct sock *sk,
 	sock_put(sk);
 }
 
-int netlink_broadcast(struct sock *ssk, struct sk_buff *skb, u32 portid,
-		      u32 group, gfp_t allocation)
+int netlink_broadcast_filtered(struct sock *ssk, struct sk_buff *skb,
+			       u32 portid,
+			       u32 group, gfp_t allocation,
+			       int (*filter)(struct sock *dsk,
+					     struct sk_buff *skb, void *data),
+			       void *filter_data)
 {
 	struct net *net = sock_net(ssk);
 	struct netlink_broadcast_data info;
@@ -1527,6 +1538,8 @@ int netlink_broadcast(struct sock *ssk, struct sk_buff *skb, u32 portid,
 	info.allocation = allocation;
 	info.skb = skb;
 	info.skb2 = NULL;
+	info.tx_filter = filter;
+	info.tx_data = filter_data;
 
 	/* While we sleep in clone, do not allow to change socket list */
 
@@ -1552,6 +1565,14 @@ int netlink_broadcast(struct sock *ssk, struct sk_buff *skb, u32 portid,
 	}
 	return -ESRCH;
 }
+EXPORT_SYMBOL(netlink_broadcast_filtered);
+
+int netlink_broadcast(struct sock *ssk, struct sk_buff *skb, u32 portid,
+		      u32 group, gfp_t allocation)
+{
+	return netlink_broadcast_filtered(ssk, skb, portid, group, allocation,
+					  NULL, NULL);
+}
 EXPORT_SYMBOL(netlink_broadcast);
 
 struct netlink_set_err_data {
-- 
2.31.1

