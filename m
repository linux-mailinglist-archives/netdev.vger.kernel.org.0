Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4DA144A0C
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 03:51:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728900AbgAVCvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 21:51:10 -0500
Received: from nwk-aaemail-lapp01.apple.com ([17.151.62.66]:41162 "EHLO
        nwk-aaemail-lapp01.apple.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727141AbgAVCvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 21:51:10 -0500
Received: from pps.filterd (nwk-aaemail-lapp01.apple.com [127.0.0.1])
        by nwk-aaemail-lapp01.apple.com (8.16.0.27/8.16.0.27) with SMTP id 00M0urWu049855;
        Tue, 21 Jan 2020 16:57:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=sender : from : to :
 cc : subject : date : message-id : in-reply-to : references : mime-version
 : content-transfer-encoding; s=20180706;
 bh=Ae2hDe9jeyTuxtxnE1PuRjG94xEJsl+jXkKJJYO/6R8=;
 b=FtbOckj0vMpYkJJo1uEGwBAEsgXn3ng+dZI3aO7+3kcujkOrkxhfWTcn2b4zLRNlrUlQ
 6wGtmL0FZnY3vK/csTr41UlcSn7Ki31SZa5LWBOYZHk9uETzI5fR6fuTLo8JFqH4gcge
 /XjZ5HVfPfNyRcrFoJH/n9i8Eo2bOBe2WD/T4GcK4cFmupyfDi916U34lf6g8zTMYFyT
 93moShhk1LD7iC6PwVSHSRRzmZGDj4W+WZkPiBjF8gwavdzmhkQ0IJPhUXreA+3ZJJmw
 l/Z6tUWzo+lqoQzztg5i8mLPBulA+89YRP+fLxSQ68A/2AzSs5hEGk+tQ5hkHvLW+TXK XA== 
Received: from ma1-mtap-s01.corp.apple.com (ma1-mtap-s01.corp.apple.com [17.40.76.5])
        by nwk-aaemail-lapp01.apple.com with ESMTP id 2xm1u51ya3-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Tue, 21 Jan 2020 16:57:05 -0800
Received: from nwk-mmpp-sz13.apple.com
 (nwk-mmpp-sz13.apple.com [17.128.115.216]) by ma1-mtap-s01.corp.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) with ESMTPS id <0Q4H00HWQHAUJ720@ma1-mtap-s01.corp.apple.com>; Tue,
 21 Jan 2020 16:57:02 -0800 (PST)
Received: from process_milters-daemon.nwk-mmpp-sz13.apple.com by
 nwk-mmpp-sz13.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) id <0Q4H00100GR2PR00@nwk-mmpp-sz13.apple.com>; Tue,
 21 Jan 2020 16:57:01 -0800 (PST)
X-Va-A: 
X-Va-T-CD: 4b1e0bf36502e052fc75ad21b706ed24
X-Va-E-CD: dcf48962d7af3bef0553ce6736fcbceb
X-Va-R-CD: 34982985ee288f0a9fc84841eeddfdb7
X-Va-CD: 0
X-Va-ID: ad8974cc-ce7b-4fd8-8f9b-5766312d1f97
X-V-A:  
X-V-T-CD: 4b1e0bf36502e052fc75ad21b706ed24
X-V-E-CD: dcf48962d7af3bef0553ce6736fcbceb
X-V-R-CD: 34982985ee288f0a9fc84841eeddfdb7
X-V-CD: 0
X-V-ID: b74b09bc-c712-41d4-b770-8c0f556f136b
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,,
 definitions=2020-01-17_05:,, signatures=0
Received: from localhost ([17.192.155.241]) by nwk-mmpp-sz13.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) with ESMTPSA id <0Q4H00DSGHB0DC30@nwk-mmpp-sz13.apple.com>; Tue,
 21 Jan 2020 16:57:00 -0800 (PST)
From:   Christoph Paasch <cpaasch@apple.com>
To:     netdev@vger.kernel.org
Cc:     mptcp@lists.01.org, Peter Krystad <peter.krystad@linux.intel.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next v3 08/19] mptcp: Add setsockopt()/getsockopt() socket
 operations
Date:   Tue, 21 Jan 2020 16:56:22 -0800
Message-id: <20200122005633.21229-9-cpaasch@apple.com>
X-Mailer: git-send-email 2.23.0
In-reply-to: <20200122005633.21229-1-cpaasch@apple.com>
References: <20200122005633.21229-1-cpaasch@apple.com>
MIME-version: 1.0
Content-transfer-encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2020-01-17_05:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peter Krystad <peter.krystad@linux.intel.com>

set/getsockopt behaviour with multiple subflows is undefined.
Therefore, for now, we return -EOPNOTSUPP unless we're in fallback mode.

Co-developed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Peter Krystad <peter.krystad@linux.intel.com>
Signed-off-by: Christoph Paasch <cpaasch@apple.com>
---
 net/mptcp/protocol.c | 58 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 249b2506a66a..875ca48de4b2 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -330,6 +330,62 @@ static void mptcp_destroy(struct sock *sk)
 {
 }
 
+static int mptcp_setsockopt(struct sock *sk, int level, int optname,
+			    char __user *uoptval, unsigned int optlen)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+	char __kernel *optval;
+	int ret = -EOPNOTSUPP;
+	struct socket *ssock;
+
+	/* will be treated as __user in tcp_setsockopt */
+	optval = (char __kernel __force *)uoptval;
+
+	pr_debug("msk=%p", msk);
+
+	/* @@ the meaning of setsockopt() when the socket is connected and
+	 * there are multiple subflows is not defined.
+	 */
+	lock_sock(sk);
+	ssock = __mptcp_socket_create(msk, MPTCP_SAME_STATE);
+	if (!IS_ERR(ssock)) {
+		pr_debug("subflow=%p", ssock->sk);
+		ret = kernel_setsockopt(ssock, level, optname, optval, optlen);
+	}
+	release_sock(sk);
+
+	return ret;
+}
+
+static int mptcp_getsockopt(struct sock *sk, int level, int optname,
+			    char __user *uoptval, int __user *uoption)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+	char __kernel *optval;
+	int ret = -EOPNOTSUPP;
+	int __kernel *option;
+	struct socket *ssock;
+
+	/* will be treated as __user in tcp_getsockopt */
+	optval = (char __kernel __force *)uoptval;
+	option = (int __kernel __force *)uoption;
+
+	pr_debug("msk=%p", msk);
+
+	/* @@ the meaning of getsockopt() when the socket is connected and
+	 * there are multiple subflows is not defined.
+	 */
+	lock_sock(sk);
+	ssock = __mptcp_socket_create(msk, MPTCP_SAME_STATE);
+	if (!IS_ERR(ssock)) {
+		pr_debug("subflow=%p", ssock->sk);
+		ret = kernel_getsockopt(ssock, level, optname, optval, option);
+	}
+	release_sock(sk);
+
+	return ret;
+}
+
 static int mptcp_get_port(struct sock *sk, unsigned short snum)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
@@ -380,6 +436,8 @@ static struct proto mptcp_prot = {
 	.init		= mptcp_init_sock,
 	.close		= mptcp_close,
 	.accept		= mptcp_accept,
+	.setsockopt	= mptcp_setsockopt,
+	.getsockopt	= mptcp_getsockopt,
 	.shutdown	= tcp_shutdown,
 	.destroy	= mptcp_destroy,
 	.sendmsg	= mptcp_sendmsg,
-- 
2.23.0

