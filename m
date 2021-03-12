Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 560953386AF
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 08:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231477AbhCLHlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 02:41:40 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:35558 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbhCLHlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 02:41:39 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12C7dbXS071230;
        Fri, 12 Mar 2021 07:41:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=kR3O04/eNSabRoDa/VWP49NBp/uh96w1wu41opTeCwc=;
 b=VR2fWzv8ZtpA/87nbeqkVW466fHjViRvrH4s7Myqb0PQls8Qsb3wwLcQbpzk5ms3vHkK
 w34m35HEsDNq1CK5XcmN3AI+SywMYgJrDUwcFBqnNNJhopjUWjSiPK4zFS6TXblAMFFm
 DvgaK4k9TMiiUCFxEUqS8y3Hd9yMEL+hDHndN8jDJ85+oF6RhilBh/X2uU6zXQbI0/87
 /uWeURixXYDRL/CBv/B/sV6NchSfzKiaxPUK4RXWwQdxCLSxlUIkpwMFUdlof4lyQpmp
 KhZk620YJpNB3ftPRKGfe3fRHVl0byq5m3XwdbcktlzaEPigUuvFwWjwzod955ssCZcz 4A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 373y8c185f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Mar 2021 07:41:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12C7fADW131477;
        Fri, 12 Mar 2021 07:41:23 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 374kgw5mpt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Mar 2021 07:41:23 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 12C7fLff010239;
        Fri, 12 Mar 2021 07:41:21 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 12 Mar 2021 07:41:20 +0000
Date:   Fri, 12 Mar 2021 10:41:12 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        mptcp@lists.01.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net] mptcp: fix bit MPTCP_PUSH_PENDING tests
Message-ID: <YEsbGCmx4Jh3fApi@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9920 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103120051
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9920 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 mlxscore=0 phishscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103120051
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MPTCP_PUSH_PENDING define is 6 and these tests should be testing if
BIT(6) is set.

Fixes: c2e6048fa1cf ("mptcp: fix race in release_cb")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 net/mptcp/protocol.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 76958570ae7f..1590b9d4cde2 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2968,7 +2968,7 @@ static void mptcp_release_cb(struct sock *sk)
 	for (;;) {
 		flags = 0;
 		if (test_and_clear_bit(MPTCP_PUSH_PENDING, &mptcp_sk(sk)->flags))
-			flags |= MPTCP_PUSH_PENDING;
+			flags |= BIT(MPTCP_PUSH_PENDING);
 		if (!flags)
 			break;
 
@@ -2981,7 +2981,7 @@ static void mptcp_release_cb(struct sock *sk)
 		 */
 
 		spin_unlock_bh(&sk->sk_lock.slock);
-		if (flags & MPTCP_PUSH_PENDING)
+		if (flags & BIT(MPTCP_PUSH_PENDING))
 			__mptcp_push_pending(sk, 0);
 
 		cond_resched();
-- 
2.30.1

