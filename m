Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0D45264B2A
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 19:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbgIJRZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 13:25:22 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:8656 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726973AbgIJRYG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 13:24:06 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08AHIbLS067350;
        Thu, 10 Sep 2020 13:24:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=Fgqk0HK/krHnDGI4gsvCueT/wtJ4B4xH6VaPmPBhBHk=;
 b=JVhMWSOcBcz/N2iAseQBEUs0DccVoiSvCGavA8vS9+zdxM1qNBTSxbVyg2ReApFgIKNA
 VQqQNjw5f1py5x24h78pZ207/p73+4QYgCKFoSRk4BstDEh9aHoi8QyLSggVFw/nDLpu
 YTwZkloM5y3IRXWqecpXggfSJ5fdC5YXfLJ7/kkJ26RV+8uJnE96RmB3saxN3nvPVLjZ
 wZWskMXCxyn6+4JEnLvlDYB2/I3wnBnYUeXlzP5xLqB6+xb2YWMUgxJGPFF0F8L2IKXN
 BUL36YXx54put+Oi47gLc3HklEiD6yGmw8r34bVIE5u8ZjWPBw+t9f0wyFq9gVf5CoB1 Zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33fre9r35a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 13:24:02 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08AHJSEx069370;
        Thu, 10 Sep 2020 13:24:01 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33fre9r34b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 13:24:01 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08AHIWvF017127;
        Thu, 10 Sep 2020 17:23:59 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 33c2a86a42-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 17:23:59 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08AHNuxG38994312
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Sep 2020 17:23:56 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 958484203F;
        Thu, 10 Sep 2020 17:23:56 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2636D42042;
        Thu, 10 Sep 2020 17:23:56 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 10 Sep 2020 17:23:56 +0000 (GMT)
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
Subject: [PATCH net-next 3/8] s390/qeth: Detect PNSO OC3 capability
Date:   Thu, 10 Sep 2020 19:23:46 +0200
Message-Id: <20200910172351.5622-4-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200910172351.5622-1-jwi@linux.ibm.com>
References: <20200910172351.5622-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-10_05:2020-09-10,2020-09-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 bulkscore=0 phishscore=0 clxscore=1015 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 suspectscore=4 mlxlogscore=999 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009100157
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexandra Winter <wintera@linux.ibm.com>

This patch detects whether device-to-bridge-notification, provided
by the Perform Network Subchannel Operation (PNSO) operation code
ADDR_INFO (OC3), is supported by this card. A following patch will
map this to the learning_sync bridgeport flag, so we store it in
priv->brport_hw_features in bridgeport flag format.

Only IQD cards provide PNSO.
There is a feature bit to indicate whether the machine provides OC3,
unfortunately it is not set on old machines.
So PNSO is called to find out. As this will disable notification
and is exclusive with bridgeport_notification, this must be done
during card initialisation before previous settings are restored.

PNSO functionality requires some configuration values that are added to
the qeth_card.info structure. Some helper functions are defined to fill
them out when the card is brought online and some other places are
adapted, that can also benefit from these fields.

Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Reviewed-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      | 10 ++++++-
 drivers/s390/net/qeth_core_main.c | 40 ++++++++++++++++++++-------
 drivers/s390/net/qeth_l2_main.c   | 45 +++++++++++++++++++++++++++++++
 3 files changed, 85 insertions(+), 10 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index da46af682af8..14c583b5ea11 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -684,9 +684,16 @@ enum qeth_pnso_mode {
 struct qeth_card_info {
 	unsigned short unit_addr2;
 	unsigned short cula;
-	u8 chpid;
 	__u16 func_level;
 	char mcl_level[QETH_MCL_LENGTH + 1];
+	/* doubleword below corresponds to net_if_token */
+	u16 ddev_devno;
+	u8 cssid;
+	u8 iid;
+	u8 ssid;
+	u8 chpid;
+	u16 chid;
+	u8 ids_valid:1; /* cssid,iid,chid */
 	u8 dev_addr_is_registered:1;
 	u8 open_when_online:1;
 	u8 promisc_mode:1;
@@ -780,6 +787,7 @@ struct qeth_switch_info {
 
 struct qeth_priv {
 	unsigned int rx_copybreak;
+	u32 brport_hw_features;
 };
 
 #define QETH_NAPI_WEIGHT NAPI_POLL_WEIGHT
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index e19640bc6daa..7cd0cbf8a4f0 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -2311,12 +2311,10 @@ static void qeth_idx_setup_activate_cmd(struct qeth_card *card,
 	u16 addr = (card->info.cula << 8) + card->info.unit_addr2;
 	u8 port = ((u8)card->dev->dev_port) | 0x80;
 	struct ccw1 *ccw = __ccw_from_cmd(iob);
-	struct ccw_dev_id dev_id;
 
 	qeth_setup_ccw(&ccw[0], CCW_CMD_WRITE, CCW_FLAG_CC, IDX_ACTIVATE_SIZE,
 		       iob->data);
 	qeth_setup_ccw(&ccw[1], CCW_CMD_READ, 0, iob->length, iob->data);
-	ccw_device_get_id(CARD_DDEV(card), &dev_id);
 	iob->finalize = qeth_idx_finalize_cmd;
 
 	port |= QETH_IDX_ACT_INVAL_FRAME;
@@ -2325,7 +2323,7 @@ static void qeth_idx_setup_activate_cmd(struct qeth_card *card,
 	       &card->token.issuer_rm_w, QETH_MPC_TOKEN_LENGTH);
 	memcpy(QETH_IDX_ACT_FUNC_LEVEL(iob->data),
 	       &card->info.func_level, 2);
-	memcpy(QETH_IDX_ACT_QDIO_DEV_CUA(iob->data), &dev_id.devno, 2);
+	memcpy(QETH_IDX_ACT_QDIO_DEV_CUA(iob->data), &card->info.ddev_devno, 2);
 	memcpy(QETH_IDX_ACT_QDIO_DEV_REALADDR(iob->data), &addr, 2);
 }
 
@@ -2599,7 +2597,6 @@ static int qeth_ulp_setup(struct qeth_card *card)
 {
 	__u16 temp;
 	struct qeth_cmd_buffer *iob;
-	struct ccw_dev_id dev_id;
 
 	QETH_CARD_TEXT(card, 2, "ulpsetup");
 
@@ -2614,8 +2611,7 @@ static int qeth_ulp_setup(struct qeth_card *card)
 	memcpy(QETH_ULP_SETUP_FILTER_TOKEN(iob->data),
 	       &card->token.ulp_filter_r, QETH_MPC_TOKEN_LENGTH);
 
-	ccw_device_get_id(CARD_DDEV(card), &dev_id);
-	memcpy(QETH_ULP_SETUP_CUA(iob->data), &dev_id.devno, 2);
+	memcpy(QETH_ULP_SETUP_CUA(iob->data), &card->info.ddev_devno, 2);
 	temp = (card->info.cula << 8) + card->info.unit_addr2;
 	memcpy(QETH_ULP_SETUP_REAL_DEVADDR(iob->data), &temp, 2);
 	return qeth_send_control_data(card, iob, qeth_ulp_setup_cb, NULL);
@@ -4920,7 +4916,6 @@ int qeth_vm_request_mac(struct qeth_card *card)
 {
 	struct diag26c_mac_resp *response;
 	struct diag26c_mac_req *request;
-	struct ccw_dev_id id;
 	int rc;
 
 	QETH_CARD_TEXT(card, 2, "vmreqmac");
@@ -4932,11 +4927,10 @@ int qeth_vm_request_mac(struct qeth_card *card)
 		goto out;
 	}
 
-	ccw_device_get_id(CARD_DDEV(card), &id);
 	request->resp_buf_len = sizeof(*response);
 	request->resp_version = DIAG26C_VERSION2;
 	request->op_code = DIAG26C_GET_MAC;
-	request->devno = id.devno;
+	request->devno = card->info.ddev_devno;
 
 	QETH_DBF_HEX(CTRL, 2, request, sizeof(*request));
 	rc = diag26c(request, response, DIAG26C_MAC_SERVICES);
@@ -5017,6 +5011,33 @@ static void qeth_determine_capabilities(struct qeth_card *card)
 	return;
 }
 
+static void qeth_read_ccw_conf_data(struct qeth_card *card)
+{
+	struct qeth_card_info *info = &card->info;
+	struct ccw_device *cdev = CARD_DDEV(card);
+	struct ccw_dev_id dev_id;
+
+	QETH_CARD_TEXT(card, 2, "ccwconfd");
+	ccw_device_get_id(cdev, &dev_id);
+
+	info->ddev_devno = dev_id.devno;
+	info->ids_valid = !ccw_device_get_cssid(cdev, &info->cssid) &&
+			  !ccw_device_get_iid(cdev, &info->iid) &&
+			  !ccw_device_get_chid(cdev, 0, &info->chid);
+	info->ssid = dev_id.ssid;
+
+	dev_info(&card->gdev->dev, "CHID: %x CHPID: %x\n",
+		 info->chid, info->chpid);
+
+	QETH_CARD_TEXT_(card, 3, "devn%x", info->ddev_devno);
+	QETH_CARD_TEXT_(card, 3, "cssid:%x", info->cssid);
+	QETH_CARD_TEXT_(card, 3, "iid:%x", info->iid);
+	QETH_CARD_TEXT_(card, 3, "ssid:%x", info->ssid);
+	QETH_CARD_TEXT_(card, 3, "chpid:%x", info->chpid);
+	QETH_CARD_TEXT_(card, 3, "chid:%x", info->chid);
+	QETH_CARD_TEXT_(card, 3, "idval%x", info->ids_valid);
+}
+
 static int qeth_qdio_establish(struct qeth_card *card)
 {
 	struct qdio_buffer **out_sbal_ptrs[QETH_MAX_OUT_QUEUES];
@@ -5185,6 +5206,7 @@ int qeth_core_hardsetup_card(struct qeth_card *card, bool *carrier_ok)
 	}
 
 	qeth_determine_capabilities(card);
+	qeth_read_ccw_conf_data(card);
 	qeth_idx_init(card);
 
 	rc = qeth_idx_activate_read_channel(card);
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 2ab130d5c42d..7cba3d0035bf 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -17,10 +17,12 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/etherdevice.h>
+#include <linux/if_bridge.h>
 #include <linux/list.h>
 #include <linux/hash.h>
 #include <linux/hashtable.h>
 #include <asm/chsc.h>
+#include <asm/css_chars.h>
 #include <asm/setup.h>
 #include "qeth_core.h"
 #include "qeth_l2.h"
@@ -826,6 +828,46 @@ static void qeth_l2_setup_bridgeport_attrs(struct qeth_card *card)
 	}
 }
 
+/**
+ *	qeth_l2_detect_dev2br_support() -
+ *	Detect whether this card supports 'dev to bridge fdb network address
+ *	change notification' and thus can support the learning_sync bridgeport
+ *	attribute
+ *	@card: qeth_card structure pointer
+ *
+ *	This is a destructive test and must be called before dev2br or
+ *	bridgeport address notification is enabled!
+ */
+static void qeth_l2_detect_dev2br_support(struct qeth_card *card)
+{
+	struct qeth_priv *priv = netdev_priv(card->dev);
+	bool dev2br_supported;
+	int rc;
+
+	QETH_CARD_TEXT(card, 2, "d2brsup");
+	if (!IS_IQD(card))
+		return;
+
+	/* dev2br requires valid cssid,iid,chid */
+	if (!card->info.ids_valid) {
+		dev2br_supported = false;
+	} else if (css_general_characteristics.enarf) {
+		dev2br_supported = true;
+	} else {
+		/* Old machines don't have the feature bit:
+		 * Probe by testing whether a disable succeeds
+		 */
+		rc = qeth_l2_pnso(card, PNSO_OC_NET_ADDR_INFO, 0, NULL, NULL);
+		dev2br_supported = !rc;
+	}
+	QETH_CARD_TEXT_(card, 2, "D2Bsup%02x", dev2br_supported);
+
+	if (dev2br_supported)
+		priv->brport_hw_features |= BR_LEARNING_SYNC;
+	else
+		priv->brport_hw_features &= ~BR_LEARNING_SYNC;
+}
+
 static int qeth_l2_set_online(struct qeth_card *card)
 {
 	struct ccwgroup_device *gdev = card->gdev;
@@ -840,6 +882,9 @@ static int qeth_l2_set_online(struct qeth_card *card)
 		goto out_remove;
 	}
 
+	/* query before bridgeport_notification may be enabled */
+	qeth_l2_detect_dev2br_support(card);
+
 	mutex_lock(&card->sbp_lock);
 	qeth_bridgeport_query_support(card);
 	if (card->options.sbp.supported_funcs) {
-- 
2.17.1

