Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4F9B264B30
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 19:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbgIJR0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 13:26:36 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50216 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727027AbgIJRYM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 13:24:12 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08AH2k5a006942;
        Thu, 10 Sep 2020 13:24:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=c/3PJWfLHIkcDpxTtYTtiHeR6SG5MfRpzerzfIGp2J0=;
 b=qOXdlbpXTLRDiyy6mV9Qdp3H4c6ptFmJrBn4ZizC+O88juwUt8PIGNV2IQse7KocsFQH
 j2Bzrt906wWHl7i+5v7yxvKwARI//RmFlKUsEEjmGUAK3zI4sb88n7oq1Ajblzh5geB7
 EIR/sUTnCbjPwmeUpPLWeVd6ZWxosCejqt0OM9WV/SGW5+WfY+/BXynpUxpOvfMNC5zA
 eitgcpt53gWRu+KgfYeb/oCYVnbImIaCAEChR3XFLhNpSKIZWeH6DgE0ZukLhuh5oI2m
 AoiN561UuiGom181OM0WA5mZwxnm+ezhKxrPtgvtWvJyNJX5OVWjrgRpY88kIDQjpAar 8w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33fq9s24g6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 13:24:00 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08AH39bo007959;
        Thu, 10 Sep 2020 13:24:00 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33fq9s24fk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 13:24:00 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08AHHoeV017005;
        Thu, 10 Sep 2020 17:23:58 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 33c2a86a41-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 17:23:58 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08AHMMqf60031256
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Sep 2020 17:22:22 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E5B842047;
        Thu, 10 Sep 2020 17:23:55 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1C79C42045;
        Thu, 10 Sep 2020 17:23:55 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 10 Sep 2020 17:23:55 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>, Ivan Vecera <ivecera@redhat.com>
Subject: [PATCH net-next 1/8] s390/cio: Add new Operation Code OC3 to PNSO
Date:   Thu, 10 Sep 2020 19:23:44 +0200
Message-Id: <20200910172351.5622-2-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200910172351.5622-1-jwi@linux.ibm.com>
References: <20200910172351.5622-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-10_05:2020-09-10,2020-09-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 suspectscore=0 bulkscore=0 impostorscore=0 clxscore=1011 phishscore=0
 priorityscore=1501 malwarescore=0 lowpriorityscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009100157
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexandra Winter <wintera@linux.ibm.com>

Add support for operation code 3 (OC3) of the
Perform-Network-Subchannel-Operations (PNSO) function
of the Channel-Subsystem-Call (CHSC) instruction.

PNSO provides 2 operation codes:
OC0 - BRIDGE_INFO
OC3 - ADDR_INFO (new)

Extend the function calls to *pnso* to pass the OC and
add new response code 0108.

Support for OC3 is indicated by a flag in the css_general_characteristics.

Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Reviewed-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Reviewed-by: Vineeth Vijayan <vneethv@linux.ibm.com>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
---
 arch/s390/include/asm/ccwdev.h    |  5 ++---
 arch/s390/include/asm/chsc.h      |  7 +++++++
 arch/s390/include/asm/css_chars.h |  4 +++-
 drivers/s390/cio/chsc.c           | 11 ++++++-----
 drivers/s390/cio/chsc.h           |  6 ++----
 drivers/s390/cio/device_ops.c     |  8 ++++----
 drivers/s390/net/qeth_l2_main.c   | 13 ++++++++-----
 7 files changed, 32 insertions(+), 22 deletions(-)

diff --git a/arch/s390/include/asm/ccwdev.h b/arch/s390/include/asm/ccwdev.h
index 3cfe1eb89838..9739a00e2190 100644
--- a/arch/s390/include/asm/ccwdev.h
+++ b/arch/s390/include/asm/ccwdev.h
@@ -238,7 +238,6 @@ extern void ccw_device_get_schid(struct ccw_device *, struct subchannel_id *);
 struct channel_path_desc_fmt0 *ccw_device_get_chp_desc(struct ccw_device *, int);
 u8 *ccw_device_get_util_str(struct ccw_device *cdev, int chp_idx);
 int ccw_device_pnso(struct ccw_device *cdev,
-		    struct chsc_pnso_area *pnso_area,
-		    struct chsc_pnso_resume_token resume_token,
-		    int cnc);
+		    struct chsc_pnso_area *pnso_area, u8 oc,
+		    struct chsc_pnso_resume_token resume_token, int cnc);
 #endif /* _S390_CCWDEV_H_ */
diff --git a/arch/s390/include/asm/chsc.h b/arch/s390/include/asm/chsc.h
index 36ce2d25a5fc..ae4d2549cd67 100644
--- a/arch/s390/include/asm/chsc.h
+++ b/arch/s390/include/asm/chsc.h
@@ -11,6 +11,13 @@
 
 #include <uapi/asm/chsc.h>
 
+/**
+ * Operation codes for CHSC PNSO:
+ *    PNSO_OC_NET_BRIDGE_INFO - only addresses that are visible to a bridgeport
+ *    PNSO_OC_NET_ADDR_INFO   - all addresses
+ */
+#define PNSO_OC_NET_BRIDGE_INFO		0
+#define PNSO_OC_NET_ADDR_INFO		3
 /**
  * struct chsc_pnso_naid_l2 - network address information descriptor
  * @nit:  Network interface token
diff --git a/arch/s390/include/asm/css_chars.h b/arch/s390/include/asm/css_chars.h
index 480bb02ccacd..638137d46c85 100644
--- a/arch/s390/include/asm/css_chars.h
+++ b/arch/s390/include/asm/css_chars.h
@@ -36,7 +36,9 @@ struct css_general_char {
 	u64 alt_ssi : 1; /* bit 108 */
 	u64 : 1;
 	u64 narf : 1;	 /* bit 110 */
-	u64 : 12;
+	u64 : 5;
+	u64 enarf: 1;	 /* bit 116 */
+	u64 : 6;
 	u64 util_str : 1;/* bit 123 */
 } __packed;
 
diff --git a/drivers/s390/cio/chsc.c b/drivers/s390/cio/chsc.c
index c314e9495c1b..8f764a295a51 100644
--- a/drivers/s390/cio/chsc.c
+++ b/drivers/s390/cio/chsc.c
@@ -65,6 +65,8 @@ int chsc_error_from_response(int response)
 	case 0x0100:
 	case 0x0102:
 		return -ENOMEM;
+	case 0x0108:		/* "HW limit exceeded" for the op 0x003d */
+		return -EUSERS;
 	default:
 		return -EIO;
 	}
@@ -1340,6 +1342,7 @@ EXPORT_SYMBOL_GPL(chsc_scm_info);
  * chsc_pnso() - Perform Network-Subchannel Operation
  * @schid:		id of the subchannel on which PNSO is performed
  * @pnso_area:		request and response block for the operation
+ * @oc:			Operation Code
  * @resume_token:	resume token for multiblock response
  * @cnc:		Boolean change-notification control
  *
@@ -1347,10 +1350,8 @@ EXPORT_SYMBOL_GPL(chsc_scm_info);
  *
  * Returns 0 on success.
  */
-int chsc_pnso(struct subchannel_id schid,
-	      struct chsc_pnso_area *pnso_area,
-	      struct chsc_pnso_resume_token resume_token,
-	      int cnc)
+int chsc_pnso(struct subchannel_id schid, struct chsc_pnso_area *pnso_area,
+	      u8 oc, struct chsc_pnso_resume_token resume_token, int cnc)
 {
 	memset(pnso_area, 0, sizeof(*pnso_area));
 	pnso_area->request.length = 0x0030;
@@ -1359,7 +1360,7 @@ int chsc_pnso(struct subchannel_id schid,
 	pnso_area->ssid  = schid.ssid;
 	pnso_area->sch	 = schid.sch_no;
 	pnso_area->cssid = schid.cssid;
-	pnso_area->oc	 = 0; /* Store-network-bridging-information list */
+	pnso_area->oc	 = oc;
 	pnso_area->resume_token = resume_token;
 	pnso_area->n	   = (cnc != 0);
 	if (chsc(pnso_area))
diff --git a/drivers/s390/cio/chsc.h b/drivers/s390/cio/chsc.h
index 7ecf7e4c402e..7416957ba9f4 100644
--- a/drivers/s390/cio/chsc.h
+++ b/drivers/s390/cio/chsc.h
@@ -205,10 +205,8 @@ struct chsc_scm_info {
 
 int chsc_scm_info(struct chsc_scm_info *scm_area, u64 token);
 
-int chsc_pnso(struct subchannel_id schid,
-	      struct chsc_pnso_area *pnso_area,
-	      struct chsc_pnso_resume_token resume_token,
-	      int cnc);
+int chsc_pnso(struct subchannel_id schid, struct chsc_pnso_area *pnso_area,
+	      u8 oc, struct chsc_pnso_resume_token resume_token, int cnc);
 
 int __init chsc_get_cssid(int idx);
 
diff --git a/drivers/s390/cio/device_ops.c b/drivers/s390/cio/device_ops.c
index 963fcc9054c6..cdf44f398957 100644
--- a/drivers/s390/cio/device_ops.c
+++ b/drivers/s390/cio/device_ops.c
@@ -714,6 +714,7 @@ EXPORT_SYMBOL_GPL(ccw_device_get_schid);
  * ccw_device_pnso() - Perform Network-Subchannel Operation
  * @cdev:		device on which PNSO is performed
  * @pnso_area:		request and response block for the operation
+ * @oc:			Operation Code
  * @resume_token:	resume token for multiblock response
  * @cnc:		Boolean change-notification control
  *
@@ -722,14 +723,13 @@ EXPORT_SYMBOL_GPL(ccw_device_get_schid);
  * Returns 0 on success.
  */
 int ccw_device_pnso(struct ccw_device *cdev,
-		    struct chsc_pnso_area *pnso_area,
-		    struct chsc_pnso_resume_token resume_token,
-		    int cnc)
+		    struct chsc_pnso_area *pnso_area, u8 oc,
+		    struct chsc_pnso_resume_token resume_token, int cnc)
 {
 	struct subchannel_id schid;
 
 	ccw_device_get_schid(cdev, &schid);
-	return chsc_pnso(schid, pnso_area, resume_token, cnc);
+	return chsc_pnso(schid, pnso_area, oc, resume_token, cnc);
 }
 EXPORT_SYMBOL_GPL(ccw_device_pnso);
 
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 491578009f12..2ab130d5c42d 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -642,6 +642,7 @@ static void qeth_l2_set_rx_mode(struct net_device *dev)
 /**
  *	qeth_l2_pnso() - perform network subchannel operation
  *	@card: qeth_card structure pointer
+ *	@oc: Operation Code
  *	@cnc: Boolean Change-Notification Control
  *	@cb: Callback function will be executed for each element
  *		of the address list
@@ -652,7 +653,7 @@ static void qeth_l2_set_rx_mode(struct net_device *dev)
  *	control" is set, further changes in the address list will be reported
  *	via the IPA command.
  */
-static int qeth_l2_pnso(struct qeth_card *card, int cnc,
+static int qeth_l2_pnso(struct qeth_card *card, u8 oc, int cnc,
 			void (*cb)(void *priv, struct chsc_pnso_naid_l2 *entry),
 			void *priv)
 {
@@ -663,13 +664,14 @@ static int qeth_l2_pnso(struct qeth_card *card, int cnc,
 	int i, size, elems;
 	int rc;
 
-	QETH_CARD_TEXT(card, 2, "PNSO");
 	rr = (struct chsc_pnso_area *)get_zeroed_page(GFP_KERNEL);
 	if (rr == NULL)
 		return -ENOMEM;
 	do {
+		QETH_CARD_TEXT(card, 2, "PNSO");
 		/* on the first iteration, naihdr.resume_token will be zero */
-		rc = ccw_device_pnso(ddev, rr, rr->naihdr.resume_token, cnc);
+		rc = ccw_device_pnso(ddev, rr, oc, rr->naihdr.resume_token,
+				     cnc);
 		if (rc)
 			continue;
 		if (cb == NULL)
@@ -1578,11 +1580,12 @@ int qeth_bridgeport_an_set(struct qeth_card *card, int enable)
 	if (enable) {
 		qeth_bridge_emit_host_event(card, anev_reset, 0, NULL, NULL);
 		qeth_l2_set_pnso_mode(card, QETH_PNSO_BRIDGEPORT);
-		rc = qeth_l2_pnso(card, 1, qeth_bridgeport_an_set_cb, card);
+		rc = qeth_l2_pnso(card, PNSO_OC_NET_BRIDGE_INFO, 1,
+				  qeth_bridgeport_an_set_cb, card);
 		if (rc)
 			qeth_l2_set_pnso_mode(card, QETH_PNSO_NONE);
 	} else {
-		rc = qeth_l2_pnso(card, 0, NULL, NULL);
+		rc = qeth_l2_pnso(card, PNSO_OC_NET_BRIDGE_INFO, 0, NULL, NULL);
 		qeth_l2_set_pnso_mode(card, QETH_PNSO_NONE);
 	}
 	return rc;
-- 
2.17.1

