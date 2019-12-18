Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5791F124DD2
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 17:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727598AbfLRQfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 11:35:05 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36259 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727565AbfLRQfC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 11:35:02 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBIGYLVZ186226
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 11:35:01 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wyjb5amgt-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 11:35:00 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Wed, 18 Dec 2019 16:34:58 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 18 Dec 2019 16:34:55 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBIGYsEc46137428
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 16:34:54 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2DF24A4055;
        Wed, 18 Dec 2019 16:34:54 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F1860A4057;
        Wed, 18 Dec 2019 16:34:53 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 18 Dec 2019 16:34:53 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 8/9] s390/qeth: consolidate helpers for capability checking
Date:   Wed, 18 Dec 2019 17:34:49 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191218163450.36731-1-jwi@linux.ibm.com>
References: <20191218163450.36731-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19121816-0028-0000-0000-000003C9F647
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19121816-0029-0000-0000-0000248D43BE
Message-Id: <20191218163450.36731-9-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-18_05:2019-12-17,2019-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 clxscore=1015 spamscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 priorityscore=1501 adultscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912180136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the old code to use struct qeth_ipa_caps, and while at it remove
all unused helper macros.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      | 47 ++-----------------------------
 drivers/s390/net/qeth_core_main.c | 28 +++++++++---------
 drivers/s390/net/qeth_core_mpc.h  | 13 +++++++--
 3 files changed, 27 insertions(+), 61 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index b54ef12840a2..6e16b19732f6 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -125,12 +125,6 @@ struct qeth_routing_info {
 	enum qeth_routing_types type;
 };
 
-/* IPA stuff */
-struct qeth_ipa_info {
-	__u32 supported_funcs;
-	__u32 enabled_funcs;
-};
-
 /* SETBRIDGEPORT stuff */
 enum qeth_sbp_roles {
 	QETH_SBP_ROLE_NONE	= 0,
@@ -169,41 +163,6 @@ struct qeth_vnicc_info {
 	bool rx_bcast_enabled;
 };
 
-static inline int qeth_is_adp_supported(struct qeth_ipa_info *ipa,
-		enum qeth_ipa_setadp_cmd func)
-{
-	return (ipa->supported_funcs & func);
-}
-
-static inline int qeth_is_ipa_supported(struct qeth_ipa_info *ipa,
-		enum qeth_ipa_funcs func)
-{
-	return (ipa->supported_funcs & func);
-}
-
-static inline int qeth_is_ipa_enabled(struct qeth_ipa_info *ipa,
-		enum qeth_ipa_funcs func)
-{
-	return (ipa->supported_funcs & ipa->enabled_funcs & func);
-}
-
-#define qeth_adp_supported(c, f) \
-	qeth_is_adp_supported(&c->options.adp, f)
-#define qeth_is_supported(c, f) \
-	qeth_is_ipa_supported(&c->options.ipa4, f)
-#define qeth_is_enabled(c, f) \
-	qeth_is_ipa_enabled(&c->options.ipa4, f)
-#define qeth_is_supported6(c, f) \
-	qeth_is_ipa_supported(&c->options.ipa6, f)
-#define qeth_is_enabled6(c, f) \
-	qeth_is_ipa_enabled(&c->options.ipa6, f)
-#define qeth_is_ipafunc_supported(c, prot, f) \
-	 ((prot == QETH_PROT_IPV6) ? \
-		qeth_is_supported6(c, f) : qeth_is_supported(c, f))
-#define qeth_is_ipafunc_enabled(c, prot, f) \
-	 ((prot == QETH_PROT_IPV6) ? \
-		qeth_is_enabled6(c, f) : qeth_is_enabled(c, f))
-
 #define QETH_IDX_FUNC_LEVEL_OSD		 0x0101
 #define QETH_IDX_FUNC_LEVEL_IQD		 0x4108
 
@@ -735,11 +694,11 @@ enum qeth_discipline_id {
 };
 
 struct qeth_card_options {
+	struct qeth_ipa_caps ipa4;
+	struct qeth_ipa_caps ipa6;
 	struct qeth_routing_info route4;
-	struct qeth_ipa_info ipa4;
-	struct qeth_ipa_info adp; /*Adapter parameters*/
 	struct qeth_routing_info route6;
-	struct qeth_ipa_info ipa6;
+	struct qeth_ipa_caps adp; /* Adapter parameters */
 	struct qeth_sbp_info sbp; /* SETBRIDGEPORT options */
 	struct qeth_vnicc_info vnicc; /* VNICC options */
 	int fake_broadcast;
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 38f3ed7567bc..6b55271091cb 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -2862,7 +2862,7 @@ static int qeth_query_setadapterparms_cb(struct qeth_card *card,
 		      cmd->data.setadapterparms.data.query_cmds_supp.lan_type;
 		QETH_CARD_TEXT_(card, 2, "lnk %d", card->info.link_type);
 	}
-	card->options.adp.supported_funcs =
+	card->options.adp.supported =
 		cmd->data.setadapterparms.data.query_cmds_supp.supported_cmds;
 	return 0;
 }
@@ -2918,8 +2918,8 @@ static int qeth_query_ipassists_cb(struct qeth_card *card,
 	case IPA_RC_NOTSUPP:
 	case IPA_RC_L2_UNSUPPORTED_CMD:
 		QETH_CARD_TEXT(card, 2, "ipaunsup");
-		card->options.ipa4.supported_funcs |= IPA_SETADAPTERPARMS;
-		card->options.ipa6.supported_funcs |= IPA_SETADAPTERPARMS;
+		card->options.ipa4.supported |= IPA_SETADAPTERPARMS;
+		card->options.ipa6.supported |= IPA_SETADAPTERPARMS;
 		return -EOPNOTSUPP;
 	default:
 		QETH_DBF_MESSAGE(1, "IPA_CMD_QIPASSIST on device %x: Unhandled rc=%#x\n",
@@ -2927,13 +2927,11 @@ static int qeth_query_ipassists_cb(struct qeth_card *card,
 		return -EIO;
 	}
 
-	if (cmd->hdr.prot_version == QETH_PROT_IPV4) {
-		card->options.ipa4.supported_funcs = cmd->hdr.ipa_supported;
-		card->options.ipa4.enabled_funcs = cmd->hdr.ipa_enabled;
-	} else if (cmd->hdr.prot_version == QETH_PROT_IPV6) {
-		card->options.ipa6.supported_funcs = cmd->hdr.ipa_supported;
-		card->options.ipa6.enabled_funcs = cmd->hdr.ipa_enabled;
-	} else
+	if (cmd->hdr.prot_version == QETH_PROT_IPV4)
+		card->options.ipa4 = cmd->hdr.assists;
+	else if (cmd->hdr.prot_version == QETH_PROT_IPV6)
+		card->options.ipa6 = cmd->hdr.assists;
+	else
 		QETH_DBF_MESSAGE(1, "IPA_CMD_QIPASSIST on device %x: Flawed LIC detected\n",
 				 CARD_DEVID(card));
 	return 0;
@@ -5002,9 +5000,9 @@ int qeth_core_hardsetup_card(struct qeth_card *card, bool *carrier_ok)
 		*carrier_ok = true;
 	}
 
-	card->options.ipa4.supported_funcs = 0;
-	card->options.ipa6.supported_funcs = 0;
-	card->options.adp.supported_funcs = 0;
+	card->options.ipa4.supported = 0;
+	card->options.ipa6.supported = 0;
+	card->options.adp.supported = 0;
 	card->options.sbp.supported_funcs = 0;
 	card->info.diagass_support = 0;
 	rc = qeth_query_ipassists(card, QETH_PROT_IPV4);
@@ -5421,9 +5419,9 @@ int qeth_setassparms_cb(struct qeth_card *card,
 
 	cmd->hdr.return_code = cmd->data.setassparms.hdr.return_code;
 	if (cmd->hdr.prot_version == QETH_PROT_IPV4)
-		card->options.ipa4.enabled_funcs = cmd->hdr.ipa_enabled;
+		card->options.ipa4.enabled = cmd->hdr.assists.enabled;
 	if (cmd->hdr.prot_version == QETH_PROT_IPV6)
-		card->options.ipa6.enabled_funcs = cmd->hdr.ipa_enabled;
+		card->options.ipa6.enabled = cmd->hdr.assists.enabled;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(qeth_setassparms_cb);
diff --git a/drivers/s390/net/qeth_core_mpc.h b/drivers/s390/net/qeth_core_mpc.h
index f13225b43781..f4dc37e28ac7 100644
--- a/drivers/s390/net/qeth_core_mpc.h
+++ b/drivers/s390/net/qeth_core_mpc.h
@@ -53,6 +53,16 @@ static inline bool qeth_ipa_caps_enabled(struct qeth_ipa_caps *caps, u32 mask)
 	return (caps->enabled & mask) == mask;
 }
 
+#define qeth_adp_supported(c, f) \
+	qeth_ipa_caps_supported(&c->options.adp, f)
+#define qeth_is_supported(c, f) \
+	qeth_ipa_caps_supported(&c->options.ipa4, f)
+#define qeth_is_supported6(c, f) \
+	qeth_ipa_caps_supported(&c->options.ipa6, f)
+#define qeth_is_ipafunc_supported(c, prot, f) \
+	 ((prot == QETH_PROT_IPV6) ? qeth_is_supported6(c, f) : \
+				     qeth_is_supported(c, f))
+
 enum qeth_card_types {
 	QETH_CARD_TYPE_OSD     = 1,
 	QETH_CARD_TYPE_IQD     = 5,
@@ -766,8 +776,7 @@ struct qeth_ipacmd_hdr {
 	__u8   prim_version_no;
 	__u8   param_count;
 	__u16  prot_version;
-	__u32  ipa_supported;
-	__u32  ipa_enabled;
+	struct qeth_ipa_caps assists;
 } __attribute__ ((packed));
 
 /* The IPA command itself */
-- 
2.17.1

