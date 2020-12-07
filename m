Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 629382D111B
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 13:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgLGMyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 07:54:03 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57016 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725881AbgLGMyD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 07:54:03 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B7CZJ6b048226;
        Mon, 7 Dec 2020 07:53:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=dqZxJFNbRagO1UI/B/IDHCKkS8MdVZIpMrSRG/zsbF4=;
 b=DsDkKgTv6fmXl4HWybUDZkV0T5ouSBg9tMMMa4qxEqBgebCvuYnq+91VMYrCDTzU53za
 VDvtlZckLxGKAj/ZnQfS+bqKuyJ65MkDBCIGECHRVF/VES3xBKE70Y4PTqfm5LUDs5LO
 JHjdoBXX6VF3Hoq4xN1Ji9RbKD0XZ5wj1UlxSEEm8qLni8vrxX2bB4iIwLOlXrDyUjxx
 jkkw1hVznHwQvoX1tFYR8l2fiH2psUwJqlLUESlmuXSPPkAR4AsJ4DBv0J+5nbChCOjd
 ptMCPit1VOHFKb1dp5OVl5AWvj09nBL4SmrOGY8DMOFXabbr/BpZD8bRby6oGlmAcnt7 lg== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 359m0psfs0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Dec 2020 07:53:17 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B7CmLgO007178;
        Mon, 7 Dec 2020 12:53:15 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3581u82fq8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Dec 2020 12:53:15 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B7CrCBX60162448
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Dec 2020 12:53:12 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7183711C04C;
        Mon,  7 Dec 2020 12:53:12 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 304A411C052;
        Mon,  7 Dec 2020 12:53:12 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Dec 2020 12:53:12 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next] net/af_iucv: use DECLARE_SOCKADDR to cast from sockaddr
Date:   Mon,  7 Dec 2020 13:53:07 +0100
Message-Id: <20201207125307.68725-1-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-07_10:2020-12-04,2020-12-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=963
 suspectscore=0 malwarescore=0 priorityscore=1501 impostorscore=0
 clxscore=1015 adultscore=0 spamscore=0 lowpriorityscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012070078
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This gets us compile-time size checking.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 net/iucv/af_iucv.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/iucv/af_iucv.c b/net/iucv/af_iucv.c
index db7d888914fa..882f028992c3 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -587,7 +587,7 @@ static void __iucv_auto_name(struct iucv_sock *iucv)
 static int iucv_sock_bind(struct socket *sock, struct sockaddr *addr,
 			  int addr_len)
 {
-	struct sockaddr_iucv *sa = (struct sockaddr_iucv *) addr;
+	DECLARE_SOCKADDR(struct sockaddr_iucv *, sa, addr);
 	char uid[sizeof(sa->siucv_user_id)];
 	struct sock *sk = sock->sk;
 	struct iucv_sock *iucv;
@@ -691,7 +691,7 @@ static int iucv_sock_autobind(struct sock *sk)
 
 static int afiucv_path_connect(struct socket *sock, struct sockaddr *addr)
 {
-	struct sockaddr_iucv *sa = (struct sockaddr_iucv *) addr;
+	DECLARE_SOCKADDR(struct sockaddr_iucv *, sa, addr);
 	struct sock *sk = sock->sk;
 	struct iucv_sock *iucv = iucv_sk(sk);
 	unsigned char user_data[16];
@@ -738,7 +738,7 @@ static int afiucv_path_connect(struct socket *sock, struct sockaddr *addr)
 static int iucv_sock_connect(struct socket *sock, struct sockaddr *addr,
 			     int alen, int flags)
 {
-	struct sockaddr_iucv *sa = (struct sockaddr_iucv *) addr;
+	DECLARE_SOCKADDR(struct sockaddr_iucv *, sa, addr);
 	struct sock *sk = sock->sk;
 	struct iucv_sock *iucv = iucv_sk(sk);
 	int err;
@@ -874,7 +874,7 @@ static int iucv_sock_accept(struct socket *sock, struct socket *newsock,
 static int iucv_sock_getname(struct socket *sock, struct sockaddr *addr,
 			     int peer)
 {
-	struct sockaddr_iucv *siucv = (struct sockaddr_iucv *) addr;
+	DECLARE_SOCKADDR(struct sockaddr_iucv *, siucv, addr);
 	struct sock *sk = sock->sk;
 	struct iucv_sock *iucv = iucv_sk(sk);
 
-- 
2.17.1

