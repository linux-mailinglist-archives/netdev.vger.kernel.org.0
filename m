Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CBCE1BFAD7
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 15:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729234AbgD3N4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 09:56:19 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:62352 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728074AbgD3N4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 09:56:14 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03UDdkIu131881;
        Thu, 30 Apr 2020 09:56:13 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30me47g6fr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Apr 2020 09:56:12 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03UDmSDX031744;
        Thu, 30 Apr 2020 13:56:10 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 30mcu72qe7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Apr 2020 13:56:10 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03UDu7j132768162
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 13:56:08 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E34B04C050;
        Thu, 30 Apr 2020 13:56:07 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC88B4C04E;
        Thu, 30 Apr 2020 13:56:07 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 30 Apr 2020 13:56:07 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 14/14] net/smc: remove obsolete link state DELETING
Date:   Thu, 30 Apr 2020 15:55:51 +0200
Message-Id: <20200430135551.26267-15-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200430135551.26267-1-kgraul@linux.ibm.com>
References: <20200430135551.26267-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-30_08:2020-04-30,2020-04-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 lowpriorityscore=0 priorityscore=1501 mlxscore=0 impostorscore=0
 spamscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 phishscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300106
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The connection layer in af_smc.c is now using the new LLC flow
framework, which made the link state DELETING obsolete. Remove the state
and the respective helpers.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/smc_core.c | 4 +---
 net/smc/smc_core.h | 1 -
 net/smc/smc_llc.c  | 7 -------
 net/smc/smc_llc.h  | 1 -
 4 files changed, 1 insertion(+), 12 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 096dce92ee2b..3539ceef9a97 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -200,7 +200,6 @@ static int smcr_link_send_delete(struct smc_link *lnk, bool orderly)
 {
 	if (lnk->state == SMC_LNK_ACTIVE &&
 	    !smc_llc_send_delete_link(lnk, SMC_LLC_REQ, orderly)) {
-		smc_llc_link_deleting(lnk);
 		return 0;
 	}
 	return -ENOTCONN;
@@ -767,8 +766,7 @@ void smc_port_terminate(struct smc_ib_device *smcibdev, u8 ibport)
 			continue;
 		/* tbd - terminate only when no more links are active */
 		for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
-			if (!smc_link_usable(&lgr->lnk[i]) ||
-			    lgr->lnk[i].state == SMC_LNK_DELETING)
+			if (!smc_link_usable(&lgr->lnk[i]))
 				continue;
 			if (lgr->lnk[i].smcibdev == smcibdev &&
 			    lgr->lnk[i].ibport == ibport) {
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 0be26386057f..f12474cc666c 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -36,7 +36,6 @@ enum smc_link_state {			/* possible states of a link */
 	SMC_LNK_INACTIVE,	/* link is inactive */
 	SMC_LNK_ACTIVATING,	/* link is being activated */
 	SMC_LNK_ACTIVE,		/* link is active */
-	SMC_LNK_DELETING,	/* link is being deleted */
 };
 
 #define SMC_WR_BUF_SIZE		48	/* size of work request buffer */
diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index 92c9a8a8aaf9..327cf30b98cc 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -545,7 +545,6 @@ static void smc_llc_rx_delete_link(struct smc_link *link,
 	struct smc_link_group *lgr = smc_get_lgr(link);
 
 	smc_lgr_forget(lgr);
-	smc_llc_link_deleting(link);
 	if (lgr->role == SMC_SERV) {
 		/* client asks to delete this link, send request */
 		smc_llc_prep_delete_link(llc, link, SMC_LLC_REQ, true);
@@ -878,12 +877,6 @@ void smc_llc_link_active(struct smc_link *link)
 	}
 }
 
-void smc_llc_link_deleting(struct smc_link *link)
-{
-	link->state = SMC_LNK_DELETING;
-	smc_wr_wakeup_tx_wait(link);
-}
-
 /* called in worker context */
 void smc_llc_link_clear(struct smc_link *link)
 {
diff --git a/net/smc/smc_llc.h b/net/smc/smc_llc.h
index e9f23affece6..48029a5e14c3 100644
--- a/net/smc/smc_llc.h
+++ b/net/smc/smc_llc.h
@@ -57,7 +57,6 @@ void smc_llc_lgr_init(struct smc_link_group *lgr, struct smc_sock *smc);
 void smc_llc_lgr_clear(struct smc_link_group *lgr);
 int smc_llc_link_init(struct smc_link *link);
 void smc_llc_link_active(struct smc_link *link);
-void smc_llc_link_deleting(struct smc_link *link);
 void smc_llc_link_clear(struct smc_link *link);
 int smc_llc_do_confirm_rkey(struct smc_link *send_link,
 			    struct smc_buf_desc *rmb_desc);
-- 
2.17.1

