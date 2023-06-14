Return-Path: <netdev+bounces-10947-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AC0A730BB6
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 01:43:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0E385280C11
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 23:43:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59B3917FFE;
	Wed, 14 Jun 2023 23:42:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA2717FEC
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 23:42:00 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A746C1BE5;
	Wed, 14 Jun 2023 16:41:54 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35EJv8Ae012628;
	Wed, 14 Jun 2023 23:41:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=70OFeu0VyYgfOvhAEvMSXO4k59IImsw+OSvbT8vLdKY=;
 b=kXpJvgjpYw9/XX/k8H9sIwojlyugQYFrNMuE9AtD/bsbtwUuLK2OirashBUo+yF/d6JW
 btEQKYisZCY1az0xLoeX0H6GHwkCV9Cj5SXFCwLAHroyd+8QK9xCg2nvYPDFTEddQ8WE
 Bbgduxz3Ne8NPJ5z+fh3j9oTtbcUDtdZ2oLFLTvymYWVrhWbrIvAjWZBdX2nT2wDBxv+
 rLx6FXxJDYrb+hkuFUtArGV0SOV8urkxZ3phR4UhrMQD9VxvzKY4jG/ytJvmRUkLxj1M
 23VI6l41i1t/I/0l8XRiBA0SLBodxj442hrR3sHjhc1TNpRSblJ+p8BoStuHzV4IgGoz cQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4fy3gse4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jun 2023 23:41:36 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35ENHNJM017710;
	Wed, 14 Jun 2023 23:41:35 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm5y0br-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jun 2023 23:41:35 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35ENfUeX023835;
	Wed, 14 Jun 2023 23:41:35 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3r4fm5y09x-6;
	Wed, 14 Jun 2023 23:41:35 +0000
From: Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
To: davem@davemloft.net
Cc: david@fries.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        zbr@ioremap.net, brauner@kernel.org, johannes@sipsolutions.net,
        ecree.xilinx@gmail.com, leon@kernel.org, keescook@chromium.org,
        socketcan@hartkopp.net, petrm@nvidia.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Liam.Howlett@Oracle.com,
        akpm@linux-foundation.org, anjali.k.kulkarni@oracle.com
Subject: [PATCH v6 5/6] connector/cn_proc: Allow non-root users access
Date: Wed, 14 Jun 2023 16:41:27 -0700
Message-ID: <20230614234129.3264175-6-anjali.k.kulkarni@oracle.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230614234129.3264175-1-anjali.k.kulkarni@oracle.com>
References: <20230614234129.3264175-1-anjali.k.kulkarni@oracle.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-14_14,2023-06-14_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306140207
X-Proofpoint-GUID: M6wLedEHs7a_VN2I4TO-EasLf1zSMQo0
X-Proofpoint-ORIG-GUID: M6wLedEHs7a_VN2I4TO-EasLf1zSMQo0
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

There were a couple of reasons for not allowing non-root users access
initially  - one is there was some point no proper receive buffer
management in place for netlink multicast. But that should be long
fixed. See link below for more context.

Second is that some of the messages may contain data that is root only. But
this should be handled with a finer granularity, which is being done at the
protocol layer.  The only problematic protocols are nf_queue and the
firewall netlink. Hence, this restriction for non-root access was relaxed
for NETLINK_ROUTE initially:
https://lore.kernel.org/all/20020612013101.A22399@wotan.suse.de/

This restriction has also been removed for following protocols:
NETLINK_KOBJECT_UEVENT, NETLINK_AUDIT, NETLINK_SOCK_DIAG,
NETLINK_GENERIC, NETLINK_SELINUX.

Since process connector messages are not sensitive (process fork, exit
notifications etc.), and anyone can read /proc data, we can allow non-root
access here. However, since process event notification is not the only
consumer of NETLINK_CONNECTOR, we can make this change even more
fine grained than the protocol level, by checking for multicast group
within the protocol.

Allow non-root access for NETLINK_CONNECTOR via NL_CFG_F_NONROOT_RECV
but add new bind function cn_bind(), which allows non-root access only
for CN_IDX_PROC multicast group.

Signed-off-by: Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
---
 drivers/connector/cn_proc.c   |  7 -------
 drivers/connector/connector.c | 19 +++++++++++++++++++
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/connector/cn_proc.c b/drivers/connector/cn_proc.c
index 825d5f506919..6eaff3a96b99 100644
--- a/drivers/connector/cn_proc.c
+++ b/drivers/connector/cn_proc.c
@@ -412,12 +412,6 @@ static void cn_proc_mcast_ctl(struct cn_msg *msg,
 	    !task_is_in_init_pid_ns(current))
 		return;
 
-	/* Can only change if privileged. */
-	if (!__netlink_ns_capable(nsp, &init_user_ns, CAP_NET_ADMIN)) {
-		err = EPERM;
-		goto out;
-	}
-
 	if (msg->len == sizeof(*pinput)) {
 		pinput = (struct proc_input *)msg->data;
 		mc_op = pinput->mcast_op;
@@ -465,7 +459,6 @@ static void cn_proc_mcast_ctl(struct cn_msg *msg,
 		break;
 	}
 
-out:
 	cn_proc_ack(err, msg->seq, msg->ack);
 }
 
diff --git a/drivers/connector/connector.c b/drivers/connector/connector.c
index d1179df2b0ba..7f7b94f616a6 100644
--- a/drivers/connector/connector.c
+++ b/drivers/connector/connector.c
@@ -166,6 +166,23 @@ static int cn_call_callback(struct sk_buff *skb)
 	return err;
 }
 
+/*
+ * Allow non-root access for NETLINK_CONNECTOR family having CN_IDX_PROC
+ * multicast group.
+ */
+static int cn_bind(struct net *net, int group)
+{
+	unsigned long groups = (unsigned long) group;
+
+	if (ns_capable(net->user_ns, CAP_NET_ADMIN))
+		return 0;
+
+	if (test_bit(CN_IDX_PROC - 1, &groups))
+		return 0;
+
+	return -EPERM;
+}
+
 static void cn_release(struct sock *sk, unsigned long *groups)
 {
 	if (groups && test_bit(CN_IDX_PROC - 1, groups)) {
@@ -261,6 +278,8 @@ static int cn_init(void)
 	struct netlink_kernel_cfg cfg = {
 		.groups	= CN_NETLINK_USERS + 0xf,
 		.input	= cn_rx_skb,
+		.flags  = NL_CFG_F_NONROOT_RECV,
+		.bind   = cn_bind,
 		.release = cn_release,
 	};
 
-- 
2.41.0


