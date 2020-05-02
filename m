Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE8C61C2571
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 14:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728040AbgEBMgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 08:36:42 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4604 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727831AbgEBMgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 May 2020 08:36:17 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 042CWXD3125651;
        Sat, 2 May 2020 08:36:16 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30s5d248fm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 02 May 2020 08:36:16 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 042Ca2sw027703;
        Sat, 2 May 2020 12:36:14 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 30s0g5ga3p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 02 May 2020 12:36:13 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 042CaBAf58917282
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 2 May 2020 12:36:11 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ED251A405B;
        Sat,  2 May 2020 12:36:10 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AFB3CA4060;
        Sat,  2 May 2020 12:36:10 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat,  2 May 2020 12:36:10 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 08/13] net/smc: activate SMC server add link functions
Date:   Sat,  2 May 2020 14:35:47 +0200
Message-Id: <20200502123552.17204-9-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200502123552.17204-1-kgraul@linux.ibm.com>
References: <20200502123552.17204-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-02_06:2020-05-01,2020-05-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=1 adultscore=0
 impostorscore=0 mlxscore=0 phishscore=0 spamscore=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005020114
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Activate smc_llc_srv_add_link() in af_smc.c to start second link
establishment after the initial link of a link group was created. And
activate it in smc_llc.c to process an incoming ADD_LINK request from
an SMC client.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/af_smc.c  | 2 +-
 net/smc/smc_llc.c | 3 ++-
 net/smc/smc_llc.h | 1 +
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 1afb6e4275f2..c67272007f41 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1067,7 +1067,7 @@ static int smcr_serv_conf_first_link(struct smc_sock *smc)
 	smc_llc_link_active(link);
 
 	/* initial contact - try to establish second link */
-	/* tbd: call smc_llc_srv_add_link(link); */
+	smc_llc_srv_add_link(link);
 	return 0;
 }
 
diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index e6e280a3683d..9d102c912be9 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -1112,7 +1112,8 @@ static void smc_llc_add_link_work(struct work_struct *work)
 
 	if (lgr->role == SMC_CLNT)
 		smc_llc_process_cli_add_link(lgr);
-	/* tbd: call smc_llc_process_srv_add_link(lgr); */
+	else
+		smc_llc_process_srv_add_link(lgr);
 out:
 	smc_llc_flow_stop(lgr, &lgr->llc_flow_lcl);
 }
diff --git a/net/smc/smc_llc.h b/net/smc/smc_llc.h
index 7c314bbef8c8..1a7748d0541f 100644
--- a/net/smc/smc_llc.h
+++ b/net/smc/smc_llc.h
@@ -89,6 +89,7 @@ struct smc_llc_qentry *smc_llc_wait(struct smc_link_group *lgr,
 struct smc_llc_qentry *smc_llc_flow_qentry_clr(struct smc_llc_flow *flow);
 void smc_llc_flow_qentry_del(struct smc_llc_flow *flow);
 int smc_llc_cli_add_link(struct smc_link *link, struct smc_llc_qentry *qentry);
+int smc_llc_srv_add_link(struct smc_link *link);
 int smc_llc_init(void) __init;
 
 #endif /* SMC_LLC_H */
-- 
2.17.1

