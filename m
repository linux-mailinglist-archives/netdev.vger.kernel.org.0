Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 037BB264B32
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 19:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbgIJR1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 13:27:10 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:23336 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727010AbgIJRYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 13:24:10 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08AH2bhd173306;
        Thu, 10 Sep 2020 13:24:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=PwTjmowOuK2EhuuN06UsA4+5WjIEuAQTdWvz2RL1ghI=;
 b=hPqkBRXFIzEAbHCfsRJsGGyIa68ioomHuiJweMWRs1IXah6HhmhS+7jQWYv0T0NKY9at
 B24ir2mpebTGEc4JfUSrFF/4wS1ugoDJJ+mQ4yc0WiCdX6IrBNXfQH9mrTxSjrXNskxa
 xT+7CnYD0KDGGe6at/XO1cYtHXwFL++ogOalL3hEn7sPGp8mlOszaKeO0b4zYBQH6gnH
 TRO8Luxmhx6mfvNXAQlKk15hOnzl/8UeKi5+I1oiLf7TdfTBP2iZvCa6eoX0moKeUfSd
 fApX19OfH5QJ0qe28ycrjlPWrNcSLx7DlmNN/6FXzs360JxBuOjc7PI30nieLTM6ThG/ BA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33fr1hrwxb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 13:24:04 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08AH30rj175323;
        Thu, 10 Sep 2020 13:24:03 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33fr1hrwwj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 13:24:03 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08AHI3B8017047;
        Thu, 10 Sep 2020 17:24:01 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 33c2a86a44-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 17:24:01 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08AHNw4Z19333562
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Sep 2020 17:23:58 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 213E242042;
        Thu, 10 Sep 2020 17:23:58 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A5EE442041;
        Thu, 10 Sep 2020 17:23:57 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 10 Sep 2020 17:23:57 +0000 (GMT)
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
Subject: [PATCH net-next 6/8] s390/qeth: Reset address notification in case of buffer overflow
Date:   Thu, 10 Sep 2020 19:23:49 +0200
Message-Id: <20200910172351.5622-7-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200910172351.5622-1-jwi@linux.ibm.com>
References: <20200910172351.5622-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-10_05:2020-09-10,2020-09-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=13
 impostorscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 priorityscore=1501 adultscore=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009100153
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexandra Winter <wintera@linux.ibm.com>

In case hardware sends more device-to-bridge-address-change notfications
than the qeth-l2 driver can handle, the hardware will send an overflow
event and then stop sending any events. It expects software to flush its
FDB and start over again. Re-enabling address-change-notification will
report all current addresses.

In order to re-enable address-change-notification this patch defines
the functions qeth_l2_dev2br_an_set() and qeth_l2_dev2br_an_set_cb
to enable or disable dev-to-bridge-address-notification.

A following patch will use the learning_sync bridgeport flag to trigger
enabling or disabling of address-change-notification, so we define
priv->brport_features to store the current setting. BRIDGE_INFO and
ADDR_INFO functionality are mutually exclusive, whereas ADDR_INFO and
qeth_l2_vnicc* can be used together.

Alternative implementations to handle buffer overflow:
Just re-enabling notification and adding all newly reported addresses
would cover any lost 'add' events, but not the lost 'delete' events.
Then these invalid addresses would stay in the bridge FDB as long as the
device exists.
Setting the net device down and up, would be an alternative, but is a bit
drastic. If the net device has many secondary addresses this will create
many delete/add events at its peers which could de-stabilize the
network segment.

Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Reviewed-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h    |   1 +
 drivers/s390/net/qeth_l2.h      |   2 +-
 drivers/s390/net/qeth_l2_main.c | 114 +++++++++++++++++++++++++++++++-
 drivers/s390/net/qeth_l2_sys.c  |  16 ++---
 4 files changed, 123 insertions(+), 10 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 4c8134a953c9..2c14012ca35d 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -789,6 +789,7 @@ struct qeth_switch_info {
 struct qeth_priv {
 	unsigned int rx_copybreak;
 	u32 brport_hw_features;
+	u32 brport_features;
 };
 
 #define QETH_NAPI_WEIGHT NAPI_POLL_WEIGHT
diff --git a/drivers/s390/net/qeth_l2.h b/drivers/s390/net/qeth_l2.h
index adf25c9fd2b3..cc95675c8bc4 100644
--- a/drivers/s390/net/qeth_l2.h
+++ b/drivers/s390/net/qeth_l2.h
@@ -23,7 +23,7 @@ int qeth_l2_vnicc_set_state(struct qeth_card *card, u32 vnicc, bool state);
 int qeth_l2_vnicc_get_state(struct qeth_card *card, u32 vnicc, bool *state);
 int qeth_l2_vnicc_set_timeout(struct qeth_card *card, u32 timeout);
 int qeth_l2_vnicc_get_timeout(struct qeth_card *card, u32 *timeout);
-bool qeth_l2_vnicc_is_in_use(struct qeth_card *card);
+bool qeth_bridgeport_allowed(struct qeth_card *card);
 
 struct qeth_mac {
 	u8 mac_addr[ETH_ALEN];
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index fffbc50cadc6..ef2962e03546 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -287,6 +287,22 @@ static void qeth_l2_set_pnso_mode(struct qeth_card *card,
 		drain_workqueue(card->event_wq);
 }
 
+static void qeth_l2_dev2br_fdb_flush(struct qeth_card *card)
+{
+	struct switchdev_notifier_fdb_info info;
+
+	QETH_CARD_TEXT(card, 2, "fdbflush");
+
+	info.addr = NULL;
+	/* flush all VLANs: */
+	info.vid = 0;
+	info.added_by_user = false;
+	info.offloaded = true;
+
+	call_switchdev_notifiers(SWITCHDEV_FDB_FLUSH_TO_BRIDGE,
+				 card->dev, &info.info, NULL);
+}
+
 static void qeth_l2_stop_card(struct qeth_card *card)
 {
 	QETH_CARD_TEXT(card, 2, "stopcard");
@@ -772,6 +788,54 @@ static void qeth_l2_dev2br_fdb_notify(struct qeth_card *card, u8 code,
 	}
 }
 
+static void qeth_l2_dev2br_an_set_cb(void *priv,
+				     struct chsc_pnso_naid_l2 *entry)
+{
+	u8 code = IPA_ADDR_CHANGE_CODE_MACADDR;
+	struct qeth_card *card = priv;
+
+	if (entry->addr_lnid.lnid < VLAN_N_VID)
+		code |= IPA_ADDR_CHANGE_CODE_VLANID;
+	qeth_l2_dev2br_fdb_notify(card, code,
+				  (struct net_if_token *)&entry->nit,
+				  (struct mac_addr_lnid *)&entry->addr_lnid);
+}
+
+/**
+ *	qeth_l2_dev2br_an_set() -
+ *	Enable or disable 'dev to bridge network address notification'
+ *	@card: qeth_card structure pointer
+ *	@enable: Enable or disable 'dev to bridge network address notification'
+ *
+ *	Returns negative errno-compatible error indication or 0 on success.
+ *
+ *	On enable, emits a series of address notifications for all
+ *	currently registered hosts.
+ *
+ *	Must be called under rtnl_lock
+ */
+static int qeth_l2_dev2br_an_set(struct qeth_card *card, bool enable)
+{
+	int rc;
+
+	if (enable) {
+		QETH_CARD_TEXT(card, 2, "anseton");
+		rc = qeth_l2_pnso(card, PNSO_OC_NET_ADDR_INFO, 1,
+				  qeth_l2_dev2br_an_set_cb, card);
+		if (rc == -EAGAIN)
+			/* address notification enabled, but inconsistent
+			 * addresses reported -> disable address notification
+			 */
+			qeth_l2_pnso(card, PNSO_OC_NET_ADDR_INFO, 0,
+				     NULL, NULL);
+	} else {
+		QETH_CARD_TEXT(card, 2, "ansetoff");
+		rc = qeth_l2_pnso(card, PNSO_OC_NET_ADDR_INFO, 0, NULL, NULL);
+	}
+
+	return rc;
+}
+
 static const struct net_device_ops qeth_l2_netdev_ops = {
 	.ndo_open		= qeth_open,
 	.ndo_stop		= qeth_stop,
@@ -1284,10 +1348,13 @@ static void qeth_l2_dev2br_worker(struct work_struct *work)
 	struct delayed_work *dwork = to_delayed_work(work);
 	struct qeth_addr_change_data *data;
 	struct qeth_card *card;
+	struct qeth_priv *priv;
 	unsigned int i;
+	int rc;
 
 	data = container_of(dwork, struct qeth_addr_change_data, dwork);
 	card = data->card;
+	priv = netdev_priv(card->dev);
 
 	QETH_CARD_TEXT(card, 4, "dev2brew");
 
@@ -1300,11 +1367,39 @@ static void qeth_l2_dev2br_worker(struct work_struct *work)
 				   msecs_to_jiffies(100));
 		return;
 	}
+	if (!netif_device_present(card->dev))
+		goto out_unlock;
 
 	if (data->ac_event.lost_event_mask) {
 		QETH_DBF_MESSAGE(3,
 				 "Address change notification overflow on device %x\n",
 				 CARD_DEVID(card));
+		/* Card fdb and bridge fdb are out of sync, card has stopped
+		 * notifications (no need to drain_workqueue). Purge all
+		 * 'extern_learn' entries from the parent bridge and restart
+		 * the notifications.
+		 */
+		qeth_l2_dev2br_fdb_flush(card);
+		rc = qeth_l2_dev2br_an_set(card, true);
+		if (rc) {
+			/* TODO: if we want to retry after -EAGAIN, be
+			 * aware there could be stale entries in the
+			 * workqueue now, that need to be drained.
+			 * For now we give up:
+			 */
+			netdev_err(card->dev,
+				   "bridge learning_sync failed to recover: %d\n",
+				   rc);
+			WRITE_ONCE(card->info.pnso_mode,
+				   QETH_PNSO_NONE);
+			/* To remove fdb entries reported by an_set: */
+			qeth_l2_dev2br_fdb_flush(card);
+			priv->brport_features ^= BR_LEARNING_SYNC;
+		} else {
+			QETH_DBF_MESSAGE(3,
+					 "Address Notification resynced on device %x\n",
+					 CARD_DEVID(card));
+		}
 	} else {
 		for (i = 0; i < data->ac_event.num_entries; i++) {
 			struct qeth_ipacmd_addr_change_entry *entry =
@@ -1315,6 +1410,8 @@ static void qeth_l2_dev2br_worker(struct work_struct *work)
 						  &entry->addr_lnid);
 		}
 	}
+
+out_unlock:
 	rtnl_unlock();
 
 free:
@@ -2035,7 +2132,7 @@ int qeth_l2_vnicc_get_timeout(struct qeth_card *card, u32 *timeout)
 }
 
 /* check if VNICC is currently enabled */
-bool qeth_l2_vnicc_is_in_use(struct qeth_card *card)
+static bool _qeth_l2_vnicc_is_in_use(struct qeth_card *card)
 {
 	if (!card->options.vnicc.sup_chars)
 		return false;
@@ -2050,6 +2147,21 @@ bool qeth_l2_vnicc_is_in_use(struct qeth_card *card)
 	return true;
 }
 
+/**
+ *	qeth_bridgeport_allowed - are any qeth_bridgeport functions allowed?
+ *	@card: qeth_card structure pointer
+ *
+ *	qeth_bridgeport functionality is mutually exclusive with usage of the
+ *	VNIC Characteristics and dev2br address notifications
+ */
+bool qeth_bridgeport_allowed(struct qeth_card *card)
+{
+	struct qeth_priv *priv = netdev_priv(card->dev);
+
+	return (!_qeth_l2_vnicc_is_in_use(card) &&
+		!(priv->brport_features & BR_LEARNING_SYNC));
+}
+
 /* recover user timeout setting */
 static bool qeth_l2_vnicc_recover_timeout(struct qeth_card *card, u32 vnicc,
 					  u32 *timeout)
diff --git a/drivers/s390/net/qeth_l2_sys.c b/drivers/s390/net/qeth_l2_sys.c
index 4695d25e54f2..4ba3bc57263f 100644
--- a/drivers/s390/net/qeth_l2_sys.c
+++ b/drivers/s390/net/qeth_l2_sys.c
@@ -18,7 +18,7 @@ static ssize_t qeth_bridge_port_role_state_show(struct device *dev,
 	int rc = 0;
 	char *word;
 
-	if (qeth_l2_vnicc_is_in_use(card))
+	if (!qeth_bridgeport_allowed(card))
 		return sprintf(buf, "n/a (VNIC characteristics)\n");
 
 	mutex_lock(&card->sbp_lock);
@@ -65,7 +65,7 @@ static ssize_t qeth_bridge_port_role_show(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	if (qeth_l2_vnicc_is_in_use(card))
+	if (!qeth_bridgeport_allowed(card))
 		return sprintf(buf, "n/a (VNIC characteristics)\n");
 
 	return qeth_bridge_port_role_state_show(dev, attr, buf, 0);
@@ -90,7 +90,7 @@ static ssize_t qeth_bridge_port_role_store(struct device *dev,
 	mutex_lock(&card->conf_mutex);
 	mutex_lock(&card->sbp_lock);
 
-	if (qeth_l2_vnicc_is_in_use(card))
+	if (!qeth_bridgeport_allowed(card))
 		rc = -EBUSY;
 	else if (card->options.sbp.reflect_promisc)
 		/* Forbid direct manipulation */
@@ -116,7 +116,7 @@ static ssize_t qeth_bridge_port_state_show(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	if (qeth_l2_vnicc_is_in_use(card))
+	if (!qeth_bridgeport_allowed(card))
 		return sprintf(buf, "n/a (VNIC characteristics)\n");
 
 	return qeth_bridge_port_role_state_show(dev, attr, buf, 1);
@@ -131,7 +131,7 @@ static ssize_t qeth_bridgeport_hostnotification_show(struct device *dev,
 	struct qeth_card *card = dev_get_drvdata(dev);
 	int enabled;
 
-	if (qeth_l2_vnicc_is_in_use(card))
+	if (!qeth_bridgeport_allowed(card))
 		return sprintf(buf, "n/a (VNIC characteristics)\n");
 
 	enabled = card->options.sbp.hostnotification;
@@ -153,7 +153,7 @@ static ssize_t qeth_bridgeport_hostnotification_store(struct device *dev,
 	mutex_lock(&card->conf_mutex);
 	mutex_lock(&card->sbp_lock);
 
-	if (qeth_l2_vnicc_is_in_use(card))
+	if (!qeth_bridgeport_allowed(card))
 		rc = -EBUSY;
 	else if (qeth_card_hw_is_reachable(card)) {
 		rc = qeth_bridgeport_an_set(card, enable);
@@ -179,7 +179,7 @@ static ssize_t qeth_bridgeport_reflect_show(struct device *dev,
 	struct qeth_card *card = dev_get_drvdata(dev);
 	char *state;
 
-	if (qeth_l2_vnicc_is_in_use(card))
+	if (!qeth_bridgeport_allowed(card))
 		return sprintf(buf, "n/a (VNIC characteristics)\n");
 
 	if (card->options.sbp.reflect_promisc) {
@@ -215,7 +215,7 @@ static ssize_t qeth_bridgeport_reflect_store(struct device *dev,
 	mutex_lock(&card->conf_mutex);
 	mutex_lock(&card->sbp_lock);
 
-	if (qeth_l2_vnicc_is_in_use(card))
+	if (!qeth_bridgeport_allowed(card))
 		rc = -EBUSY;
 	else if (card->options.sbp.role != QETH_SBP_ROLE_NONE)
 		rc = -EPERM;
-- 
2.17.1

