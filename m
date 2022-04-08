Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9534C4F9914
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 17:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237414AbiDHPNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 11:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237402AbiDHPNN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 11:13:13 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35ED3FC8A5;
        Fri,  8 Apr 2022 08:11:06 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 238F59cl029567;
        Fri, 8 Apr 2022 15:11:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=wImVeLo0tMFkZboFB2iKIhfRKw25W6aXPPE0HXlMEhA=;
 b=SIIw4fdNmBagte2HP1sexIfsMVl+mX7ovO6RRUfhCXxxnHOGpXJAH4WY4PRu8yGWqGLX
 4Be5h2Kgoo1NsCuakJ6hfpFLIwWM6rObiE41v7XQtPZSESLocVwikdVWvC4T8Rvs4Vy3
 iFdViGQtBd6dW+kavL33mKEiLEznJc2xa+K4ag0OhxpTiAEsdQVC6MkoB1kS3x1uEbdw
 AcVomamS+14t7PShlZzNlDEnFz1on0S3XXmEdOL0OPOjoEoi3sYRCTTlGnGUdGhThtW7
 5UuPZT5uDnOhuvrLqmKevfp9hP5ecchl6pbrLIGj+5w0/Lg1cJ+3JmoAz911TneUZMI7 nQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3faeu9jy5t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Apr 2022 15:11:03 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 238EoqpP015771;
        Fri, 8 Apr 2022 15:11:03 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3faeu9jy4w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Apr 2022 15:11:03 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 238F3Ux5029496;
        Fri, 8 Apr 2022 15:11:00 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3f6e4941y8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Apr 2022 15:11:00 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 238FAwBN46006698
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 8 Apr 2022 15:10:58 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8A0105204F;
        Fri,  8 Apr 2022 15:10:58 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 56A7D5204E;
        Fri,  8 Apr 2022 15:10:58 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, alibuda@linux.alibaba.com
Subject: [PATCH net 3/3] net/smc: Fix af_ops of child socket pointing to released memory
Date:   Fri,  8 Apr 2022 17:10:35 +0200
Message-Id: <20220408151035.1044701-4-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220408151035.1044701-1-kgraul@linux.ibm.com>
References: <20220408151035.1044701-1-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CMlsDN9UyLrBGMKkfVJndz0Q7H-5m2Zu
X-Proofpoint-ORIG-GUID: skNY5UKmYRbZInzrvtSAwlAp-pSl2z2I
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-08_05,2022-04-08_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 impostorscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0
 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1015 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204080075
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Child sockets may inherit the af_ops from the parent listen socket.
When the listen socket is released then the af_ops of the child socket
points to released memory.
Solve that by restoring the original af_ops for child sockets which
inherited the parent af_ops. And clear any inherited user_data of the
parent socket.

Fixes: 8270d9c21041 ("net/smc: Limit backlog connections")
Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/af_smc.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index f0d118e9f155..14ddc40149e8 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -121,6 +121,7 @@ static struct sock *smc_tcp_syn_recv_sock(const struct sock *sk,
 					  bool *own_req)
 {
 	struct smc_sock *smc;
+	struct sock *child;
 
 	smc = smc_clcsock_user_data(sk);
 
@@ -134,8 +135,17 @@ static struct sock *smc_tcp_syn_recv_sock(const struct sock *sk,
 	}
 
 	/* passthrough to original syn recv sock fct */
-	return smc->ori_af_ops->syn_recv_sock(sk, skb, req, dst, req_unhash,
-					      own_req);
+	child = smc->ori_af_ops->syn_recv_sock(sk, skb, req, dst, req_unhash,
+					       own_req);
+	/* child must not inherit smc or its ops */
+	if (child) {
+		rcu_assign_sk_user_data(child, NULL);
+
+		/* v4-mapped sockets don't inherit parent ops. Don't restore. */
+		if (inet_csk(child)->icsk_af_ops == inet_csk(sk)->icsk_af_ops)
+			inet_csk(child)->icsk_af_ops = smc->ori_af_ops;
+	}
+	return child;
 
 drop:
 	dst_release(dst);
-- 
2.32.0

