Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA38A279880
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 12:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727557AbgIZKoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 06:44:54 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60716 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726309AbgIZKow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 06:44:52 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08QAgmXm078331;
        Sat, 26 Sep 2020 06:44:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=Otp78AUy9r5bNGT/9wCkiRnOHgp+D5qz1fJa9gBplJc=;
 b=LFixRElgCAySTDfXgUqqh1GG5TAQfPE/ZNVoB6IcK491OvNsggcsD8t933mVvm9U1MI9
 amR7gWZFyEwJWdZP2h+cKLNltOVrrcclYZKfisRTyqe6NLZSjPGfDywnv+JWcsfc/xhW
 7qHHQHr3coV8W47+3ic6zyLA1qyb16Nzvb1S8wqA+vNvtXH/wrsmTCk/kA57exxBHb8z
 n1RAWGrY1qTZJcsc4dNuILvaaROg+m+NSzzgMx4SS5Qdm8u9nNeuaHW/SEx0yPf4JNUK
 zDzgohaXLS8Jh/OPGJS3Jeqt2wzTPd+rObMga1XdtRB0gM6mIPNyPdvWKgfIxCnjF28u YQ== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33t44j80nb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 26 Sep 2020 06:44:50 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08QAgwCY004829;
        Sat, 26 Sep 2020 10:44:48 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 33t16k01xm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 26 Sep 2020 10:44:48 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08QAijf429360520
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Sep 2020 10:44:45 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 547CDA4054;
        Sat, 26 Sep 2020 10:44:45 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 107DCA405B;
        Sat, 26 Sep 2020 10:44:45 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat, 26 Sep 2020 10:44:45 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 02/14] net/smc: CLC header fields renaming
Date:   Sat, 26 Sep 2020 12:44:20 +0200
Message-Id: <20200926104432.74293-3-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200926104432.74293-1-kgraul@linux.ibm.com>
References: <20200926104432.74293-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-26_06:2020-09-24,2020-09-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 malwarescore=0 priorityscore=1501 adultscore=0 clxscore=1015
 suspectscore=1 bulkscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009260091
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

SMCD version 2 defines 2 more bits in the CLC header to specify
version 2 types. This patch prepares better naming of the CLC
header fields. No functional change.

Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/af_smc.c  | 14 +++++++-------
 net/smc/smc_clc.c | 22 ++++++++++++----------
 net/smc/smc_clc.h | 12 ++++++------
 3 files changed, 25 insertions(+), 23 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index ed8f97166be9..1a02d3665c46 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -618,7 +618,7 @@ static int smc_connect_rdma(struct smc_sock *smc,
 	ini->is_smcd = false;
 	ini->ib_lcl = &aclc->r0.lcl;
 	ini->ib_clcqpn = ntoh24(aclc->r0.qpn);
-	ini->first_contact_peer = aclc->hdr.flag;
+	ini->first_contact_peer = aclc->hdr.typev2 & SMC_FIRST_CONTACT_MASK;
 
 	mutex_lock(&smc_client_lgr_pending);
 	reason_code = smc_conn_create(smc, ini);
@@ -713,7 +713,7 @@ static int smc_connect_ism(struct smc_sock *smc,
 
 	ini->is_smcd = true;
 	ini->ism_peer_gid = aclc->d0.gid;
-	ini->first_contact_peer = aclc->hdr.flag;
+	ini->first_contact_peer = aclc->hdr.typev2 & SMC_FIRST_CONTACT_MASK;
 
 	/* there is only one lgr role for SMC-D; use server lock */
 	mutex_lock(&smc_server_lgr_pending);
@@ -804,9 +804,9 @@ static int __smc_connect(struct smc_sock *smc)
 	}
 
 	/* depending on previous steps, connect using rdma or ism */
-	if (rdma_supported && aclc.hdr.path == SMC_TYPE_R)
+	if (rdma_supported && aclc.hdr.typev1 == SMC_TYPE_R)
 		rc = smc_connect_rdma(smc, &aclc, &ini);
-	else if (ism_supported && aclc.hdr.path == SMC_TYPE_D)
+	else if (ism_supported && aclc.hdr.typev1 == SMC_TYPE_D)
 		rc = smc_connect_ism(smc, &aclc, &ini);
 	else
 		rc = SMC_CLC_DECL_MODEUNSUPP;
@@ -1316,7 +1316,7 @@ static void smc_listen_work(struct work_struct *work)
 	smc_tx_init(new_smc);
 
 	/* check if ISM is available */
-	if (pclc->hdr.path == SMC_TYPE_D || pclc->hdr.path == SMC_TYPE_B) {
+	if (pclc->hdr.typev1 == SMC_TYPE_D || pclc->hdr.typev1 == SMC_TYPE_B) {
 		struct smc_clc_msg_smcd *pclc_smcd = smc_get_clc_msg_smcd(pclc);
 
 		ini.is_smcd = true; /* prepare ISM check */
@@ -1326,7 +1326,7 @@ static void smc_listen_work(struct work_struct *work)
 			rc = smc_listen_ism_init(new_smc, pclc, &ini);
 		if (!rc)
 			ism_supported = true;
-		else if (pclc->hdr.path == SMC_TYPE_D)
+		else if (pclc->hdr.typev1 == SMC_TYPE_D)
 			goto out_unlock; /* skip RDMA and decline */
 	}
 
@@ -1339,7 +1339,7 @@ static void smc_listen_work(struct work_struct *work)
 		rc = smc_find_rdma_device(new_smc, &ini);
 		if (rc) {
 			/* no RDMA device found */
-			if (pclc->hdr.path == SMC_TYPE_B)
+			if (pclc->hdr.typev1 == SMC_TYPE_B)
 				/* neither ISM nor RDMA device found */
 				rc = SMC_CLC_DECL_NOSMCDEV;
 			goto out_unlock;
diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index bd116e1949b9..524d2b225640 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -64,12 +64,12 @@ static bool smc_clc_msg_hdr_valid(struct smc_clc_msg_hdr *clcm, bool check_trl)
 		break;
 	case SMC_CLC_ACCEPT:
 	case SMC_CLC_CONFIRM:
-		if (clcm->path != SMC_TYPE_R && clcm->path != SMC_TYPE_D)
+		if (clcm->typev1 != SMC_TYPE_R && clcm->typev1 != SMC_TYPE_D)
 			return false;
 		clc = (struct smc_clc_msg_accept_confirm *)clcm;
-		if ((clcm->path == SMC_TYPE_R &&
+		if ((clcm->typev1 == SMC_TYPE_R &&
 		     ntohs(clc->hdr.length) != SMCR_CLC_ACCEPT_CONFIRM_LEN) ||
-		    (clcm->path == SMC_TYPE_D &&
+		    (clcm->typev1 == SMC_TYPE_D &&
 		     ntohs(clc->hdr.length) != SMCD_CLC_ACCEPT_CONFIRM_LEN))
 			return false;
 		trl = (struct smc_clc_msg_trail *)
@@ -327,7 +327,7 @@ int smc_clc_wait_msg(struct smc_sock *smc, void *buf, int buflen,
 		goto out;
 	}
 
-	if (clcm->type == SMC_CLC_PROPOSAL && clcm->path == SMC_TYPE_N)
+	if (clcm->type == SMC_CLC_PROPOSAL && clcm->typev1 == SMC_TYPE_N)
 		reason_code = SMC_CLC_DECL_VERSMISMAT; /* just V2 offered */
 
 	/* receive the complete CLC message */
@@ -365,7 +365,8 @@ int smc_clc_wait_msg(struct smc_sock *smc, void *buf, int buflen,
 		dclc = (struct smc_clc_msg_decline *)clcm;
 		reason_code = SMC_CLC_DECL_PEERDECL;
 		smc->peer_diagnosis = ntohl(dclc->peer_diagnosis);
-		if (((struct smc_clc_msg_decline *)buf)->hdr.flag) {
+		if (((struct smc_clc_msg_decline *)buf)->hdr.typev2 &
+						SMC_FIRST_CONTACT_MASK) {
 			smc->conn.lgr->sync_err = 1;
 			smc_lgr_terminate_sched(smc->conn.lgr);
 		}
@@ -389,7 +390,8 @@ int smc_clc_send_decline(struct smc_sock *smc, u32 peer_diag_info)
 	dclc.hdr.type = SMC_CLC_DECLINE;
 	dclc.hdr.length = htons(sizeof(struct smc_clc_msg_decline));
 	dclc.hdr.version = SMC_V1;
-	dclc.hdr.flag = (peer_diag_info == SMC_CLC_DECL_SYNCERR) ? 1 : 0;
+	dclc.hdr.typev2 = (peer_diag_info == SMC_CLC_DECL_SYNCERR) ?
+						SMC_FIRST_CONTACT_MASK : 0;
 	if ((!smc->conn.lgr || !smc->conn.lgr->is_smcd) &&
 	    smc_ib_is_valid_local_systemid())
 		memcpy(dclc.id_for_peer, local_systemid,
@@ -447,7 +449,7 @@ int smc_clc_send_proposal(struct smc_sock *smc, int smc_type,
 	       sizeof(SMC_EYECATCHER));
 	pclc_base->hdr.type = SMC_CLC_PROPOSAL;
 	pclc_base->hdr.version = SMC_V1;		/* SMC version */
-	pclc_base->hdr.path = smc_type;
+	pclc_base->hdr.typev1 = smc_type;
 	if (smc_type == SMC_TYPE_R || smc_type == SMC_TYPE_B) {
 		/* add SMC-R specifics */
 		memcpy(pclc_base->lcl.id_for_peer, local_systemid,
@@ -509,12 +511,12 @@ static int smc_clc_send_confirm_accept(struct smc_sock *smc,
 	/* send SMC Confirm CLC msg */
 	clc->hdr.version = SMC_V1;		/* SMC version */
 	if (first_contact)
-		clc->hdr.flag = 1;
+		clc->hdr.typev2 |= SMC_FIRST_CONTACT_MASK;
 	if (conn->lgr->is_smcd) {
 		/* SMC-D specific settings */
 		memcpy(clc->hdr.eyecatcher, SMCD_EYECATCHER,
 		       sizeof(SMCD_EYECATCHER));
-		clc->hdr.path = SMC_TYPE_D;
+		clc->hdr.typev1 = SMC_TYPE_D;
 		clc->hdr.length = htons(SMCD_CLC_ACCEPT_CONFIRM_LEN);
 		clc->d0.gid = conn->lgr->smcd->local_gid;
 		clc->d0.token = conn->rmb_desc->token;
@@ -530,7 +532,7 @@ static int smc_clc_send_confirm_accept(struct smc_sock *smc,
 		link = conn->lnk;
 		memcpy(clc->hdr.eyecatcher, SMC_EYECATCHER,
 		       sizeof(SMC_EYECATCHER));
-		clc->hdr.path = SMC_TYPE_R;
+		clc->hdr.typev1 = SMC_TYPE_R;
 		clc->hdr.length = htons(SMCR_CLC_ACCEPT_CONFIRM_LEN);
 		memcpy(clc->r0.lcl.id_for_peer, local_systemid,
 		       sizeof(local_systemid));
diff --git a/net/smc/smc_clc.h b/net/smc/smc_clc.h
index fcd8521c7737..5b2d0582886e 100644
--- a/net/smc/smc_clc.h
+++ b/net/smc/smc_clc.h
@@ -54,19 +54,19 @@
 #define SMC_CLC_DECL_ERR_RDYLNK	0x09990002  /*	 ib ready link failed	      */
 #define SMC_CLC_DECL_ERR_REGRMB	0x09990003  /*	 reg rmb failed		      */
 
+#define SMC_FIRST_CONTACT_MASK	0b10	/* first contact bit within typev2 */
+
 struct smc_clc_msg_hdr {	/* header1 of clc messages */
 	u8 eyecatcher[4];	/* eye catcher */
 	u8 type;		/* proposal / accept / confirm / decline */
 	__be16 length;
 #if defined(__BIG_ENDIAN_BITFIELD)
 	u8 version : 4,
-	   flag    : 1,
-	   rsvd	   : 1,
-	   path	   : 2;
+	   typev2  : 2,
+	   typev1  : 2;
 #elif defined(__LITTLE_ENDIAN_BITFIELD)
-	u8 path    : 2,
-	   rsvd    : 1,
-	   flag    : 1,
+	u8 typev1  : 2,
+	   typev2  : 2,
 	   version : 4;
 #endif
 } __packed;			/* format defined in RFC7609 */
-- 
2.17.1

