Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB76287CE7
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 22:15:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730106AbgJHUPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 16:15:17 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51572 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730096AbgJHUPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 16:15:17 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 098KE0U0112531
        for <netdev@vger.kernel.org>; Thu, 8 Oct 2020 20:15:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=gxNaaU/W3FUj48sXjVNEtaJGXcSYRrY8PpuBzT4uXH0=;
 b=wP6AXY14dPQEml8N0w+9IkWMMILyXtcqWnL7+IudMrdJt7h9wV4WvedfvFeGBhfuB3B8
 4DaKJ+ctVWcmcLHWuAxM9Zjbtv5nXYl/wKUTmpVOYMqi29/5SKZ3cHsQTbDpCc+YJARC
 8y9hviDxO3eCYanSiNnSwNTnmdJlOdwwFcd0xrrXLtqWh+srxxMcno2sMyya7XZPNBB2
 SoGeaLN2p2/wP+cW9doWrTzeG5VqeIHnq/CsMIIoTdP7tW3+iUfvHwu3hjvyKYThRAtm
 fPmdA6RksxOTEclZINmIhJmQ+pNWDQILvlHJe968ogYt09DmSNybFKO1I/t3b0msiPuR cg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 3429jur0p9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 20:15:16 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 098KFFM6013327
        for <netdev@vger.kernel.org>; Thu, 8 Oct 2020 20:15:15 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 3429khg2tx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 20:15:14 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 098KFBBV028427
        for <netdev@vger.kernel.org>; Thu, 8 Oct 2020 20:15:11 GMT
Received: from oracle.com (/10.129.135.37)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 08 Oct 2020 13:15:10 -0700
From:   rao.shoaib@oracle.com
To:     netdev@vger.kernel.org
Cc:     Rao Shoaib <rao.shoaib@oracle.com>
Subject: [RFC net-next af_unix v1 1/1] af_unix: Allow delivery of SIGURG on AF_UNIX streams socket
Date:   Thu,  8 Oct 2020 13:03:58 -0700
Message-Id: <1602187438-12464-2-git-send-email-rao.shoaib@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1602187438-12464-1-git-send-email-rao.shoaib@oracle.com>
References: <1602187438-12464-1-git-send-email-rao.shoaib@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9768 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=1 mlxscore=0 adultscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010080142
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9768 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 phishscore=0 bulkscore=0 suspectscore=1 lowpriorityscore=0 spamscore=0
 clxscore=1011 malwarescore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010080142
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rao Shoaib <rao.shoaib@oracle.com>

For AF_UNIX stream socket send SIGURG to the peer if
the msg has MSG_OOB flag set.

Signed-off-by: Rao Shoaib <rao.shoaib@oracle.com>
---
 net/unix/af_unix.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 92784e5..4f01d74 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1840,8 +1840,6 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
 		return err;
 
 	err = -EOPNOTSUPP;
-	if (msg->msg_flags&MSG_OOB)
-		goto out_err;
 
 	if (msg->msg_namelen) {
 		err = sk->sk_state == TCP_ESTABLISHED ? -EISCONN : -EOPNOTSUPP;
@@ -1906,6 +1904,9 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
 		sent += size;
 	}
 
+	if (msg->msg_flags & MSG_OOB)
+		sk_send_sigurg(other);
+
 	scm_destroy(&scm);
 
 	return sent;
-- 
1.8.3.1

