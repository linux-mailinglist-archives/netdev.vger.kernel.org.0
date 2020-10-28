Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93FDB29E26B
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 03:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404336AbgJ2COW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 22:14:22 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:28972 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726778AbgJ1Vfv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 17:35:51 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09SAWIL6112439;
        Wed, 28 Oct 2020 07:00:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=O9NVZXcWHFl5NEq2e8YwO8pfMDn/rjKTPA/GCr87lbU=;
 b=ZocmigXojXKcz4DO9pXfsGS+3G8CBx/2+mDhNwuHbMmaZ+GtfA+caganE+fE+NgTfm8b
 yXKZnKkLqqKmbh/37uvMyGD81GKYGZHVXrsqp40NrAYxFiXwSgCQox+oCbiM6aZF+Pkc
 Uv5vVnfqFirNlAB741CLm80LsVZp3xU4ueeOpFN01EZSCi+e2I5wXCtWXF0L8p4vJKQ7
 EzZBvRgGBN7tFI9M7WuENFSGMbHuH4J2DcPgkmRBQxwIisyL+khvxIIIpDr5UdFv3W58
 65MjNpDOUTSFt09+LZ8RGRkAwQQCO3w3qLNw+QJJ6OssVMIR/vL07Ir+Ks+5zKR4vlxO /w== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34esjkpfgf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Oct 2020 07:00:55 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09SAuu3E019071;
        Wed, 28 Oct 2020 11:00:52 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 34dwh0h63k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Oct 2020 11:00:52 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09SB0nNw26214742
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Oct 2020 11:00:49 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B09DBAE061;
        Wed, 28 Oct 2020 11:00:49 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 74751AE056;
        Wed, 28 Oct 2020 11:00:49 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 28 Oct 2020 11:00:49 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next] net/smc: improve return codes for SMC-Dv2
Date:   Wed, 28 Oct 2020 12:00:39 +0100
Message-Id: <20201028110039.33645-1-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-28_04:2020-10-26,2020-10-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 adultscore=0 mlxscore=0 phishscore=0 bulkscore=0 lowpriorityscore=0
 malwarescore=0 clxscore=1015 priorityscore=1501 suspectscore=1
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010280067
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To allow better problem diagnosis the return codes for SMC-Dv2 are
improved by this patch. A few more CLC DECLINE codes are defined and
sent to the peer when an SMC connection cannot be established.
There are now multiple SMC variations that are offered by the client and
the server may encounter problems to initialize all of them.
Because only one diagnosis code can be sent to the client the decision
was made to send the first code that was encountered. Because the server
tries the variations in the order of importance (SMC-Dv2, SMC-D, SMC-R)
this makes sure that the diagnosis code of the most important variation
is sent.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/af_smc.c   | 61 +++++++++++++++++++++++++++++++---------------
 net/smc/smc_clc.h  |  5 ++++
 net/smc/smc_core.h |  1 +
 3 files changed, 47 insertions(+), 20 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 82be0bd0f6e8..5414704f4cac 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1346,6 +1346,7 @@ static int smc_listen_v2_check(struct smc_sock *new_smc,
 {
 	struct smc_clc_smcd_v2_extension *pclc_smcd_v2_ext;
 	struct smc_clc_v2_extension *pclc_v2_ext;
+	int rc;
 
 	ini->smc_type_v1 = pclc->hdr.typev1;
 	ini->smc_type_v2 = pclc->hdr.typev2;
@@ -1353,29 +1354,30 @@ static int smc_listen_v2_check(struct smc_sock *new_smc,
 	if (pclc->hdr.version > SMC_V1)
 		ini->smcd_version |=
 				ini->smc_type_v2 != SMC_TYPE_N ? SMC_V2 : 0;
+	if (!(ini->smcd_version & SMC_V2)) {
+		rc = SMC_CLC_DECL_PEERNOSMC;
+		goto out;
+	}
 	if (!smc_ism_v2_capable) {
 		ini->smcd_version &= ~SMC_V2;
+		rc = SMC_CLC_DECL_NOISM2SUPP;
 		goto out;
 	}
 	pclc_v2_ext = smc_get_clc_v2_ext(pclc);
 	if (!pclc_v2_ext) {
 		ini->smcd_version &= ~SMC_V2;
+		rc = SMC_CLC_DECL_NOV2EXT;
 		goto out;
 	}
 	pclc_smcd_v2_ext = smc_get_clc_smcd_v2_ext(pclc_v2_ext);
-	if (!pclc_smcd_v2_ext)
+	if (!pclc_smcd_v2_ext) {
 		ini->smcd_version &= ~SMC_V2;
+		rc = SMC_CLC_DECL_NOV2DEXT;
+	}
 
 out:
-	if (!ini->smcd_version) {
-		if (pclc->hdr.typev1 == SMC_TYPE_B ||
-		    pclc->hdr.typev2 == SMC_TYPE_B)
-			return SMC_CLC_DECL_NOSMCDEV;
-		if (pclc->hdr.typev1 == SMC_TYPE_D ||
-		    pclc->hdr.typev2 == SMC_TYPE_D)
-			return SMC_CLC_DECL_NOSMCDDEV;
-		return SMC_CLC_DECL_NOSMCRDEV;
-	}
+	if (!ini->smcd_version)
+		return rc;
 
 	return 0;
 }
@@ -1473,6 +1475,12 @@ static void smc_check_ism_v2_match(struct smc_init_info *ini,
 	}
 }
 
+static void smc_find_ism_store_rc(u32 rc, struct smc_init_info *ini)
+{
+	if (!ini->rc)
+		ini->rc = rc;
+}
+
 static void smc_find_ism_v2_device_serv(struct smc_sock *new_smc,
 					struct smc_clc_msg_proposal *pclc,
 					struct smc_init_info *ini)
@@ -1483,7 +1491,7 @@ static void smc_find_ism_v2_device_serv(struct smc_sock *new_smc,
 	unsigned int matches = 0;
 	u8 smcd_version;
 	u8 *eid = NULL;
-	int i;
+	int i, rc;
 
 	if (!(ini->smcd_version & SMC_V2) || !smcd_indicated(ini->smc_type_v2))
 		goto not_found;
@@ -1492,8 +1500,10 @@ static void smc_find_ism_v2_device_serv(struct smc_sock *new_smc,
 	smc_v2_ext = smc_get_clc_v2_ext(pclc);
 	smcd_v2_ext = smc_get_clc_smcd_v2_ext(smc_v2_ext);
 	if (!smcd_v2_ext ||
-	    !smc_v2_ext->hdr.flag.seid) /* no system EID support for SMCD */
+	    !smc_v2_ext->hdr.flag.seid) { /* no system EID support for SMCD */
+		smc_find_ism_store_rc(SMC_CLC_DECL_NOSEID, ini);
 		goto not_found;
+	}
 
 	mutex_lock(&smcd_dev_list.mutex);
 	if (pclc_smcd->ism.chid)
@@ -1525,9 +1535,12 @@ static void smc_find_ism_v2_device_serv(struct smc_sock *new_smc,
 		ini->smcd_version = SMC_V2;
 		ini->is_smcd = true;
 		ini->ism_selected = i;
-		if (smc_listen_ism_init(new_smc, ini))
+		rc = smc_listen_ism_init(new_smc, ini);
+		if (rc) {
+			smc_find_ism_store_rc(rc, ini);
 			/* try next active ISM device */
 			continue;
+		}
 		return; /* matching and usable V2 ISM device found */
 	}
 	/* no V2 ISM device could be initialized */
@@ -1544,19 +1557,23 @@ static void smc_find_ism_v1_device_serv(struct smc_sock *new_smc,
 					struct smc_init_info *ini)
 {
 	struct smc_clc_msg_smcd *pclc_smcd = smc_get_clc_msg_smcd(pclc);
+	int rc = 0;
 
 	/* check if ISM V1 is available */
 	if (!(ini->smcd_version & SMC_V1) || !smcd_indicated(ini->smc_type_v1))
 		goto not_found;
 	ini->is_smcd = true; /* prepare ISM check */
 	ini->ism_peer_gid[0] = ntohll(pclc_smcd->ism.gid);
-	if (smc_find_ism_device(new_smc, ini))
+	rc = smc_find_ism_device(new_smc, ini);
+	if (rc)
 		goto not_found;
 	ini->ism_selected = 0;
-	if (!smc_listen_ism_init(new_smc, ini))
+	rc = smc_listen_ism_init(new_smc, ini);
+	if (!rc)
 		return;		/* V1 ISM device found */
 
 not_found:
+	smc_find_ism_store_rc(rc, ini);
 	ini->ism_dev[0] = NULL;
 	ini->is_smcd = false;
 }
@@ -1613,16 +1630,16 @@ static int smc_listen_find_device(struct smc_sock *new_smc,
 		return 0;
 
 	if (!(ini->smcd_version & SMC_V1))
-		return SMC_CLC_DECL_NOSMCDEV;
+		return ini->rc ?: SMC_CLC_DECL_NOSMCD2DEV;
 
 	/* check for matching IP prefix and subnet length */
 	rc = smc_listen_prfx_check(new_smc, pclc);
 	if (rc)
-		return rc;
+		return ini->rc ?: rc;
 
 	/* get vlan id from IP device */
 	if (smc_vlan_by_tcpsk(new_smc->clcsock, ini))
-		return SMC_CLC_DECL_GETVLANERR;
+		return ini->rc ?: SMC_CLC_DECL_GETVLANERR;
 
 	/* check for ISM device matching V1 proposed device */
 	smc_find_ism_v1_device_serv(new_smc, pclc, ini);
@@ -1630,10 +1647,14 @@ static int smc_listen_find_device(struct smc_sock *new_smc,
 		return 0;
 
 	if (pclc->hdr.typev1 == SMC_TYPE_D)
-		return SMC_CLC_DECL_NOSMCDDEV; /* skip RDMA and decline */
+		/* skip RDMA and decline */
+		return ini->rc ?: SMC_CLC_DECL_NOSMCDDEV;
 
 	/* check if RDMA is available */
-	return smc_find_rdma_v1_device_serv(new_smc, pclc, ini);
+	rc = smc_find_rdma_v1_device_serv(new_smc, pclc, ini);
+	smc_find_ism_store_rc(rc, ini);
+
+	return (!rc) ? 0 : ini->rc;
 }
 
 /* listen worker: finish RDMA setup */
diff --git a/net/smc/smc_clc.h b/net/smc/smc_clc.h
index b3f46ab79e47..e7ab05683bc9 100644
--- a/net/smc/smc_clc.h
+++ b/net/smc/smc_clc.h
@@ -37,6 +37,11 @@
 #define SMC_CLC_DECL_NOSMCDEV	0x03030000  /* no SMC device found (R or D)   */
 #define SMC_CLC_DECL_NOSMCDDEV	0x03030001  /* no SMC-D device found	      */
 #define SMC_CLC_DECL_NOSMCRDEV	0x03030002  /* no SMC-R device found	      */
+#define SMC_CLC_DECL_NOISM2SUPP	0x03030003  /* hardware has no ISMv2 support  */
+#define SMC_CLC_DECL_NOV2EXT	0x03030004  /* peer sent no clc v2 extension  */
+#define SMC_CLC_DECL_NOV2DEXT	0x03030005  /* peer sent no clc SMC-Dv2 ext.  */
+#define SMC_CLC_DECL_NOSEID	0x03030006  /* peer sent no SEID	      */
+#define SMC_CLC_DECL_NOSMCD2DEV	0x03030007  /* no SMC-Dv2 device found	      */
 #define SMC_CLC_DECL_MODEUNSUPP	0x03040000  /* smc modes do not match (R or D)*/
 #define SMC_CLC_DECL_RMBE_EC	0x03050000  /* peer has eyecatcher in RMBE    */
 #define SMC_CLC_DECL_OPTUNSUPP	0x03060000  /* fastopen sockopt not supported */
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index f1e867ce2e63..9aee54a6bcba 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -301,6 +301,7 @@ struct smc_init_info {
 	u8			first_contact_peer;
 	u8			first_contact_local;
 	unsigned short		vlan_id;
+	u32			rc;
 	/* SMC-R */
 	struct smc_clc_msg_local *ib_lcl;
 	struct smc_ib_device	*ib_dev;
-- 
2.17.1

