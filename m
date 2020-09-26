Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01147279890
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 12:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgIZKpf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 06:45:35 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:20909 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727072AbgIZKo4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 06:44:56 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08QAWTWg158875;
        Sat, 26 Sep 2020 06:44:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=oGxJWDhTVxloV6EqunW+QVq0JCFryj7iP9Ht+9Xo1Ts=;
 b=PuG7JwhMmygOVqUtGFQO/sRL8/IyE/wNYLBZjDTWrzxnpLUN8gLjQXY33Dfuqm74mzIH
 2KwGRqOiujUYD5CMeoqXRcCKZe2CNqLMcFCU5YYkdvRdQBwF1DtcuLndsjq31OZEu/zV
 m8AMsvIir/cyxxoahUP/wjnLguCqJO9Al+JckfSlhpGg1VxCPaVTz6YZcX+K3lgSDB3Q
 RieSh27WrEmSE5Sr0Bv4V3HpespNnMSXQq8oT/qJvPRfKWwWj4Y3QX3F7EN6v9dzWd24
 DxJMSCw553ElUY7LqDtaQ4q6TNAcg4n/cgjTnFG44xyPt2cfKHCCmYzO7E+tfPhhBeSF Dw== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33t3xqr6j6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 26 Sep 2020 06:44:51 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08QAguRi011681;
        Sat, 26 Sep 2020 10:44:49 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 33sw97r985-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 26 Sep 2020 10:44:49 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08QAikHP18874826
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Sep 2020 10:44:46 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 41B3EA4054;
        Sat, 26 Sep 2020 10:44:46 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0310CA405C;
        Sat, 26 Sep 2020 10:44:46 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat, 26 Sep 2020 10:44:45 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 05/14] net/smc: prepare for more proposed ISM devices
Date:   Sat, 26 Sep 2020 12:44:23 +0200
Message-Id: <20200926104432.74293-6-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200926104432.74293-1-kgraul@linux.ibm.com>
References: <20200926104432.74293-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-26_06:2020-09-24,2020-09-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 suspectscore=3 bulkscore=0 mlxlogscore=999
 clxscore=1015 impostorscore=0 priorityscore=1501 phishscore=0 mlxscore=0
 spamscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009260091
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

SMCD Version 2 allows proposing of up to 8 ISM devices in addition
to the native ISM device of SMCD Version 1.
This patch prepares the struct smc_init_info to deal with these
additional 8 ISM devices.

Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/af_smc.c   | 72 +++++++++++++++++++++++++++++-----------------
 net/smc/smc.h      |  4 +++
 net/smc/smc_clc.c  |  2 +-
 net/smc/smc_core.c | 23 ++++++++-------
 net/smc/smc_core.h |  4 +--
 net/smc/smc_pnet.c |  8 +++---
 6 files changed, 69 insertions(+), 44 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 911482741224..dc0049b25bd9 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -564,7 +564,7 @@ static int smc_find_ism_device(struct smc_sock *smc, struct smc_init_info *ini)
 {
 	/* Find ISM device with same PNETID as connecting interface  */
 	smc_pnet_find_ism_resource(smc->clcsock->sk, ini);
-	if (!ini->ism_dev)
+	if (!ini->ism_dev[0])
 		return SMC_CLC_DECL_NOSMCDDEV;
 	return 0;
 }
@@ -573,7 +573,7 @@ static int smc_find_ism_device(struct smc_sock *smc, struct smc_init_info *ini)
 static int smc_connect_ism_vlan_setup(struct smc_sock *smc,
 				      struct smc_init_info *ini)
 {
-	if (ini->vlan_id && smc_ism_get_vlan(ini->ism_dev, ini->vlan_id))
+	if (ini->vlan_id && smc_ism_get_vlan(ini->ism_dev[0], ini->vlan_id))
 		return SMC_CLC_DECL_ISMVLANERR;
 	return 0;
 }
@@ -586,7 +586,7 @@ static int smc_connect_ism_vlan_cleanup(struct smc_sock *smc, bool is_smcd,
 {
 	if (!is_smcd)
 		return 0;
-	if (ini->vlan_id && smc_ism_put_vlan(ini->ism_dev, ini->vlan_id))
+	if (ini->vlan_id && smc_ism_put_vlan(ini->ism_dev[0], ini->vlan_id))
 		return SMC_CLC_DECL_CNFERR;
 	return 0;
 }
@@ -712,7 +712,7 @@ static int smc_connect_ism(struct smc_sock *smc,
 	int rc = 0;
 
 	ini->is_smcd = true;
-	ini->ism_peer_gid = aclc->d0.gid;
+	ini->ism_peer_gid[0] = aclc->d0.gid;
 	ini->first_contact_peer = aclc->hdr.typev2 & SMC_FIRST_CONTACT_MASK;
 
 	/* there is only one lgr role for SMC-D; use server lock */
@@ -754,7 +754,7 @@ static int __smc_connect(struct smc_sock *smc)
 {
 	bool ism_supported = false, rdma_supported = false;
 	struct smc_clc_msg_accept_confirm aclc;
-	struct smc_init_info ini = {0};
+	struct smc_init_info *ini = NULL;
 	int smc_type;
 	int rc = 0;
 
@@ -769,21 +769,27 @@ static int __smc_connect(struct smc_sock *smc)
 	if (using_ipsec(smc))
 		return smc_connect_decline_fallback(smc, SMC_CLC_DECL_IPSEC);
 
+	ini = kzalloc(sizeof(*ini), GFP_KERNEL);
+	if (!ini)
+		return smc_connect_decline_fallback(smc, SMC_CLC_DECL_MEM);
+
 	/* get vlan id from IP device */
-	if (smc_vlan_by_tcpsk(smc->clcsock, &ini))
+	if (smc_vlan_by_tcpsk(smc->clcsock, ini)) {
+		kfree(ini);
 		return smc_connect_decline_fallback(smc,
 						    SMC_CLC_DECL_GETVLANERR);
+	}
 
 	/* check if there is an ism device available */
-	if (!smc_find_ism_device(smc, &ini) &&
-	    !smc_connect_ism_vlan_setup(smc, &ini)) {
+	if (!smc_find_ism_device(smc, ini) &&
+	    !smc_connect_ism_vlan_setup(smc, ini)) {
 		/* ISM is supported for this connection */
 		ism_supported = true;
 		smc_type = SMC_TYPE_D;
 	}
 
 	/* check if there is a rdma device available */
-	if (!smc_find_rdma_device(smc, &ini)) {
+	if (!smc_find_rdma_device(smc, ini)) {
 		/* RDMA is supported for this connection */
 		rdma_supported = true;
 		if (ism_supported)
@@ -793,29 +799,34 @@ static int __smc_connect(struct smc_sock *smc)
 	}
 
 	/* if neither ISM nor RDMA are supported, fallback */
-	if (!rdma_supported && !ism_supported)
+	if (!rdma_supported && !ism_supported) {
+		kfree(ini);
 		return smc_connect_decline_fallback(smc, SMC_CLC_DECL_NOSMCDEV);
+	}
 
 	/* perform CLC handshake */
-	rc = smc_connect_clc(smc, smc_type, &aclc, &ini);
+	rc = smc_connect_clc(smc, smc_type, &aclc, ini);
 	if (rc) {
-		smc_connect_ism_vlan_cleanup(smc, ism_supported, &ini);
+		smc_connect_ism_vlan_cleanup(smc, ism_supported, ini);
+		kfree(ini);
 		return smc_connect_decline_fallback(smc, rc);
 	}
 
 	/* depending on previous steps, connect using rdma or ism */
 	if (rdma_supported && aclc.hdr.typev1 == SMC_TYPE_R)
-		rc = smc_connect_rdma(smc, &aclc, &ini);
+		rc = smc_connect_rdma(smc, &aclc, ini);
 	else if (ism_supported && aclc.hdr.typev1 == SMC_TYPE_D)
-		rc = smc_connect_ism(smc, &aclc, &ini);
+		rc = smc_connect_ism(smc, &aclc, ini);
 	else
 		rc = SMC_CLC_DECL_MODEUNSUPP;
 	if (rc) {
-		smc_connect_ism_vlan_cleanup(smc, ism_supported, &ini);
+		smc_connect_ism_vlan_cleanup(smc, ism_supported, ini);
+		kfree(ini);
 		return smc_connect_decline_fallback(smc, rc);
 	}
 
-	smc_connect_ism_vlan_cleanup(smc, ism_supported, &ini);
+	smc_connect_ism_vlan_cleanup(smc, ism_supported, ini);
+	kfree(ini);
 	return 0;
 }
 
@@ -1219,14 +1230,14 @@ static void smc_find_ism_device_serv(struct smc_sock *new_smc,
 	if (!smcd_indicated(pclc->hdr.typev1))
 		goto not_found;
 	ini->is_smcd = true; /* prepare ISM check */
-	ini->ism_peer_gid = pclc_smcd->gid;
+	ini->ism_peer_gid[0] = pclc_smcd->gid;
 	if (smc_find_ism_device(new_smc, ini))
 		goto not_found;
 	if (!smc_listen_ism_init(new_smc, ini))
 		return;		/* ISM device found */
 
 not_found:
-	ini->ism_dev = NULL;
+	ini->ism_dev[0] = NULL;
 	ini->is_smcd = false;
 }
 
@@ -1319,7 +1330,7 @@ static void smc_listen_work(struct work_struct *work)
 	struct smc_clc_msg_accept_confirm cclc;
 	struct smc_clc_msg_proposal_area *buf;
 	struct smc_clc_msg_proposal *pclc;
-	struct smc_init_info ini = {0};
+	struct smc_init_info *ini = NULL;
 	int rc = 0;
 
 	if (new_smc->listen_smc->sk.sk_state != SMC_LISTEN)
@@ -1363,8 +1374,14 @@ static void smc_listen_work(struct work_struct *work)
 	if (rc)
 		goto out_decl;
 
+	ini = kzalloc(sizeof(*ini), GFP_KERNEL);
+	if (!ini) {
+		rc = SMC_CLC_DECL_MEM;
+		goto out_decl;
+	}
+
 	/* get vlan id from IP device */
-	if (smc_vlan_by_tcpsk(new_smc->clcsock, &ini)) {
+	if (smc_vlan_by_tcpsk(new_smc->clcsock, ini)) {
 		rc = SMC_CLC_DECL_GETVLANERR;
 		goto out_decl;
 	}
@@ -1375,32 +1392,32 @@ static void smc_listen_work(struct work_struct *work)
 	smc_tx_init(new_smc);
 
 	/* determine ISM or RoCE device used for connection */
-	rc = smc_listen_find_device(new_smc, pclc, &ini);
+	rc = smc_listen_find_device(new_smc, pclc, ini);
 	if (rc)
 		goto out_unlock;
 
 	/* send SMC Accept CLC message */
-	rc = smc_clc_send_accept(new_smc, ini.first_contact_local);
+	rc = smc_clc_send_accept(new_smc, ini->first_contact_local);
 	if (rc)
 		goto out_unlock;
 
 	/* SMC-D does not need this lock any more */
-	if (ini.is_smcd)
+	if (ini->is_smcd)
 		mutex_unlock(&smc_server_lgr_pending);
 
 	/* receive SMC Confirm CLC message */
 	rc = smc_clc_wait_msg(new_smc, &cclc, sizeof(cclc),
 			      SMC_CLC_CONFIRM, CLC_WAIT_TIME);
 	if (rc) {
-		if (!ini.is_smcd)
+		if (!ini->is_smcd)
 			goto out_unlock;
 		goto out_decl;
 	}
 
 	/* finish worker */
-	if (!ini.is_smcd) {
+	if (!ini->is_smcd) {
 		rc = smc_listen_rdma_finish(new_smc, &cclc,
-					    ini.first_contact_local);
+					    ini->first_contact_local);
 		if (rc)
 			goto out_unlock;
 		mutex_unlock(&smc_server_lgr_pending);
@@ -1412,8 +1429,9 @@ static void smc_listen_work(struct work_struct *work)
 out_unlock:
 	mutex_unlock(&smc_server_lgr_pending);
 out_decl:
-	smc_listen_decline(new_smc, rc, ini.first_contact_local);
+	smc_listen_decline(new_smc, rc, ini ? ini->first_contact_local : 0);
 out_free:
+	kfree(ini);
 	kfree(buf);
 }
 
diff --git a/net/smc/smc.h b/net/smc/smc.h
index 2bd57e57b7e7..6c89cb80860b 100644
--- a/net/smc/smc.h
+++ b/net/smc/smc.h
@@ -23,6 +23,10 @@
 #define SMCPROTO_SMC		0	/* SMC protocol, IPv4 */
 #define SMCPROTO_SMC6		1	/* SMC protocol, IPv6 */
 
+#define SMC_MAX_ISM_DEVS	8	/* max # of proposed non-native ISM
+					 * devices
+					 */
+
 extern struct proto smc_proto;
 extern struct proto smc_proto6;
 
diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index 8ad0bbaac846..fca718836ec1 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -463,7 +463,7 @@ int smc_clc_send_proposal(struct smc_sock *smc, int smc_type,
 		/* add SMC-D specifics */
 		plen += sizeof(*pclc_smcd);
 		pclc_base->iparea_offset = htons(sizeof(*pclc_smcd));
-		pclc_smcd->gid = ini->ism_dev->local_gid;
+		pclc_smcd->gid = ini->ism_dev[0]->local_gid;
 	}
 	pclc_base->hdr.length = htons(plen);
 
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index c811ae1a8add..26db5ef01842 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -375,7 +375,7 @@ static int smc_lgr_create(struct smc_sock *smc, struct smc_init_info *ini)
 	int i;
 
 	if (ini->is_smcd && ini->vlan_id) {
-		if (smc_ism_get_vlan(ini->ism_dev, ini->vlan_id)) {
+		if (smc_ism_get_vlan(ini->ism_dev[0], ini->vlan_id)) {
 			rc = SMC_CLC_DECL_ISMVLANERR;
 			goto out;
 		}
@@ -412,13 +412,13 @@ static int smc_lgr_create(struct smc_sock *smc, struct smc_init_info *ini)
 	lgr->conns_all = RB_ROOT;
 	if (ini->is_smcd) {
 		/* SMC-D specific settings */
-		get_device(&ini->ism_dev->dev);
-		lgr->peer_gid = ini->ism_peer_gid;
-		lgr->smcd = ini->ism_dev;
-		lgr_list = &ini->ism_dev->lgr_list;
+		get_device(&ini->ism_dev[0]->dev);
+		lgr->peer_gid = ini->ism_peer_gid[0];
+		lgr->smcd = ini->ism_dev[0];
+		lgr_list = &ini->ism_dev[0]->lgr_list;
 		lgr_lock = &lgr->smcd->lgr_lock;
 		lgr->peer_shutdown = 0;
-		atomic_inc(&ini->ism_dev->lgr_cnt);
+		atomic_inc(&ini->ism_dev[0]->lgr_cnt);
 	} else {
 		/* SMC-R specific settings */
 		lgr->role = smc->listen_smc ? SMC_SERV : SMC_CLNT;
@@ -449,7 +449,7 @@ static int smc_lgr_create(struct smc_sock *smc, struct smc_init_info *ini)
 	kfree(lgr);
 ism_put_vlan:
 	if (ini->is_smcd && ini->vlan_id)
-		smc_ism_put_vlan(ini->ism_dev, ini->vlan_id);
+		smc_ism_put_vlan(ini->ism_dev[0], ini->vlan_id);
 out:
 	if (rc < 0) {
 		if (rc == -ENOMEM)
@@ -1288,8 +1288,10 @@ int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini)
 	spinlock_t *lgr_lock;
 	int rc = 0;
 
-	lgr_list = ini->is_smcd ? &ini->ism_dev->lgr_list : &smc_lgr_list.list;
-	lgr_lock = ini->is_smcd ? &ini->ism_dev->lgr_lock : &smc_lgr_list.lock;
+	lgr_list = ini->is_smcd ? &ini->ism_dev[0]->lgr_list :
+				  &smc_lgr_list.list;
+	lgr_lock = ini->is_smcd ? &ini->ism_dev[0]->lgr_lock :
+				  &smc_lgr_list.lock;
 	ini->first_contact_local = 1;
 	role = smc->listen_smc ? SMC_SERV : SMC_CLNT;
 	if (role == SMC_CLNT && ini->first_contact_peer)
@@ -1301,7 +1303,8 @@ int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini)
 	list_for_each_entry(lgr, lgr_list, list) {
 		write_lock_bh(&lgr->conns_lock);
 		if ((ini->is_smcd ?
-		     smcd_lgr_match(lgr, ini->ism_dev, ini->ism_peer_gid) :
+		     smcd_lgr_match(lgr, ini->ism_dev[0],
+				    ini->ism_peer_gid[0]) :
 		     smcr_lgr_match(lgr, ini->ib_lcl, role, ini->ib_clcqpn)) &&
 		    !lgr->sync_err &&
 		    lgr->vlan_id == ini->vlan_id &&
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 37a5903789b0..ec86084b0dfd 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -301,8 +301,8 @@ struct smc_init_info {
 	u8			ib_port;
 	u32			ib_clcqpn;
 	/* SMC-D */
-	u64			ism_peer_gid;
-	struct smcd_dev		*ism_dev;
+	u64			ism_peer_gid[SMC_MAX_ISM_DEVS + 1];
+	struct smcd_dev		*ism_dev[SMC_MAX_ISM_DEVS + 1];
 };
 
 /* Find the connection associated with the given alert token in the link group.
diff --git a/net/smc/smc_pnet.c b/net/smc/smc_pnet.c
index 0af5b4acca30..0b0f2704026f 100644
--- a/net/smc/smc_pnet.c
+++ b/net/smc/smc_pnet.c
@@ -933,10 +933,10 @@ static void smc_pnet_find_ism_by_pnetid(struct net_device *ndev,
 	list_for_each_entry(ismdev, &smcd_dev_list.list, list) {
 		if (smc_pnet_match(ismdev->pnetid, ndev_pnetid) &&
 		    !ismdev->going_away &&
-		    (!ini->ism_peer_gid ||
-		     !smc_ism_cantalk(ini->ism_peer_gid, ini->vlan_id,
+		    (!ini->ism_peer_gid[0] ||
+		     !smc_ism_cantalk(ini->ism_peer_gid[0], ini->vlan_id,
 				      ismdev))) {
-			ini->ism_dev = ismdev;
+			ini->ism_dev[0] = ismdev;
 			break;
 		}
 	}
@@ -970,7 +970,7 @@ void smc_pnet_find_ism_resource(struct sock *sk, struct smc_init_info *ini)
 {
 	struct dst_entry *dst = sk_dst_get(sk);
 
-	ini->ism_dev = NULL;
+	ini->ism_dev[0] = NULL;
 	if (!dst)
 		goto out;
 	if (!dst->dev)
-- 
2.17.1

