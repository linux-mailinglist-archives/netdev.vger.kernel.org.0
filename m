Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8F0E2B3206
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 04:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbgKODKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 22:10:24 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:60188 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726392AbgKODKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 22:10:18 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AF39LHm093452;
        Sun, 15 Nov 2020 03:10:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=gxNaaU/W3FUj48sXjVNEtaJGXcSYRrY8PpuBzT4uXH0=;
 b=e393Zf5OvhljCzqI7we2NEQu45ChN4/3ng7LvfYS3uvbVaVl6gvEmj6xk3yblTuTo4U3
 rkE6krS/BLzhCLmSmMXIgjaF4dU+kq+Ou+ZKhq2/dwBq4K77EGk9USp2rI+mViMvm1IH
 IYAKVDomK2K39QXFDkmjTM+cl8HG8toetoqhVjhuUi7NoEE1c3l/Mq7QTJIk29KFEXEQ
 QO0OrHqd/cz7J8bFEbPg/te7TCLqigxLoX9CC/esDEe1Nwh//yNig4fg6ISXiJkK3NFm
 nzpzMd0DxfXfExEOU6P9PW5T7ybxlcXUwLqYCwfN7203TquqCj16BQuHkdSpZdLR+cdL iQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 34t7vmsfnc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 15 Nov 2020 03:10:16 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AF3556G072503;
        Sun, 15 Nov 2020 03:10:15 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 34ts4v35br-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 15 Nov 2020 03:10:15 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AF3AE6h011936;
        Sun, 15 Nov 2020 03:10:14 GMT
Received: from oracle.com (/10.129.135.37)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 14 Nov 2020 19:10:14 -0800
From:   rao.shoaib@oracle.com
To:     netdev@vger.kernel.org, kuba@kernel.org
Cc:     Rao Shoaib <rao.shoaib@oracle.com>
Subject: [RFC net-next af_unix v1 1/1] af_unix: Allow delivery of SIGURG on AF_UNIX streams socket
Date:   Sat, 14 Nov 2020 18:58:05 -0800
Message-Id: <1605409085-20294-2-git-send-email-rao.shoaib@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1605409085-20294-1-git-send-email-rao.shoaib@oracle.com>
References: <1605409085-20294-1-git-send-email-rao.shoaib@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9805 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011150017
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9805 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0 spamscore=0
 adultscore=0 mlxscore=0 priorityscore=1501 phishscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011150017
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

