Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B99C226AF07
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 22:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728011AbgIOU7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 16:59:05 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:12536 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726454AbgIOU6E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 16:58:04 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08FKWoxS183723;
        Tue, 15 Sep 2020 16:58:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=ssoDHG2MAO56Ek3O5TB9CWGQjxqMgfp53u1nsDqaq1A=;
 b=s7Lu+8xtAa1Ng2O9KrfLLQCMOTnodiQ2PIAf3/iqvhYNhtl1appKDeZcyzDLSb+LlBFG
 YQ7SKPTadAlwzoYVE38XxHON8mxxoPTaWF9Nf5SQEil+BGSKIUtWedXgIoThb88WIYk5
 sYw4xJKkJZvOTdlwlCwHVYzlfM7nnVTVhCUaWhDiLAykVbFYxRtRoICOfeRLJprF1O1o
 0JiF9y4fICgI1tr5HywqzQ3ubhrqtLIcGvbDSm2RZBQvgXw9JRy68BH+3EkYJ/9Kxwiw
 3cB2j5QAIA/6G7F3L9RHmvlP1skdAzknHNzumITNdfaT/5Uo0RM46l21fUo/FcPdKye5 Ww== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33k1tmmxt3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Sep 2020 16:58:00 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08FKvskf010822;
        Tue, 15 Sep 2020 20:57:58 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 33h2r9bh50-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Sep 2020 20:57:58 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08FKuLEV26673544
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 20:56:21 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9454C42042;
        Tue, 15 Sep 2020 20:57:55 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4BC8D42045;
        Tue, 15 Sep 2020 20:57:55 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 15 Sep 2020 20:57:55 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 1/1] net/smc: check variable before dereferencing in smc_close.c
Date:   Tue, 15 Sep 2020 22:57:09 +0200
Message-Id: <20200915205709.50325-2-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200915205709.50325-1-kgraul@linux.ibm.com>
References: <20200915205709.50325-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-15_13:2020-09-15,2020-09-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 impostorscore=0 spamscore=0 priorityscore=1501 mlxscore=0 phishscore=0
 mlxlogscore=999 clxscore=1015 lowpriorityscore=0 bulkscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150161
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

smc->clcsock and smc->clcsock->sk are used before the check if they can
be dereferenced. Fix this by checking the variables first.

Fixes: a60a2b1e0af1 ("net/smc: reduce active tcp_listen workers")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_close.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/smc/smc_close.c b/net/smc/smc_close.c
index 10d05a6d34fc..0f9ffba07d26 100644
--- a/net/smc/smc_close.c
+++ b/net/smc/smc_close.c
@@ -208,11 +208,12 @@ int smc_close_active(struct smc_sock *smc)
 		break;
 	case SMC_LISTEN:
 		sk->sk_state = SMC_CLOSED;
-		smc->clcsock->sk->sk_data_ready = smc->clcsk_data_ready;
-		smc->clcsock->sk->sk_user_data = NULL;
 		sk->sk_state_change(sk); /* wake up accept */
-		if (smc->clcsock && smc->clcsock->sk)
+		if (smc->clcsock && smc->clcsock->sk) {
+			smc->clcsock->sk->sk_data_ready = smc->clcsk_data_ready;
+			smc->clcsock->sk->sk_user_data = NULL;
 			rc = kernel_sock_shutdown(smc->clcsock, SHUT_RDWR);
+		}
 		smc_close_cleanup_listen(sk);
 		release_sock(sk);
 		flush_work(&smc->tcp_listen_work);
-- 
2.17.1

