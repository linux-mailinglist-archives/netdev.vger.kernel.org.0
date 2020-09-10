Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F320D264B50
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 19:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbgIJRbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 13:31:36 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:10936 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726991AbgIJRYG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 13:24:06 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08AH4nZo156039;
        Thu, 10 Sep 2020 13:24:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=NpYWB3MFQVMsksJBqKwyymwg89YmhPDDZTi9+06voI4=;
 b=JgRxTQB6epHt0Ea+mtGy6m1aCFWhq+WsLUZ2km7XZGATB5hkC3xqEz+zDAy5IOvu3h3k
 rTpoeCnREL11ASRfDHVJU+fdAXuhQ58gCXo3hEje+Tv7QdURYaxKbwnHMBwiDd3Hry71
 ieILuG0anCUTF+tQPb0ztHgrf+9fJh7dd1vkZOMHA5glj1PognDopwfCkh0B+L6IJZgR
 UALrmV5iuvqCC7f0S1DdaAtPsf6hdXLkVHsyRZVgkoE2VbozAl9Y7FwAY8ASwWHIfE3h
 e4tuluBdzKYsXcVbKJ34tzJ55z+M8DDC1qebqtReYJKxVbx9KSMz3FZZqw7GQZx80akl WQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33fqts1bxt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 13:24:03 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08AHM6EH053604;
        Thu, 10 Sep 2020 13:24:02 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33fqts1bwm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 13:24:02 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08AHHsGL001043;
        Thu, 10 Sep 2020 17:24:00 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 33c2a83mjp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 17:23:59 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08AHNvZb28639730
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Sep 2020 17:23:57 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1F56142041;
        Thu, 10 Sep 2020 17:23:57 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A321C42047;
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
Subject: [PATCH net-next 4/8] s390/qeth: Translate address events into switchdev notifiers
Date:   Thu, 10 Sep 2020 19:23:47 +0200
Message-Id: <20200910172351.5622-5-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200910172351.5622-1-jwi@linux.ibm.com>
References: <20200910172351.5622-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-10_05:2020-09-10,2020-09-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 phishscore=0 clxscore=1015 mlxlogscore=999 spamscore=0 malwarescore=0
 impostorscore=0 adultscore=0 bulkscore=0 priorityscore=1501
 suspectscore=13 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009100157
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexandra Winter <wintera@linux.ibm.com>

A qeth-l2 HiperSockets card can show switch-ish behaviour in the sense,
that it can report all MACs that are reachable via this interface. Just
like a switch device, it can notify the software bridge about changes
to its fdb. This patch exploits this device-to-bridge-notification and
extracts the relevant information from the hardware events to generate
notifications to an attached software bridge.

There are 2 sources for this information:
1) The reply message of Perform-Network-Subchannel-Operations (PNSO)
(operation code ADDR_INFO) reports all addresses that are currently
reachable (implemented in a later patch).
2) As long as device-to-bridge-notification is enabled, hardware will
generate address change notification events, whenever the content of
the hardware fdb changes (this patch).

The bridge_hostnotify feature (PNSO operation code BRIDGE_INFO) uses
the same address change notification events. We need to distinguish
between qeth_pnso_mode QETH_PNSO_BRIDGEPORT and QETH_PNSO_ADDR_INFO
and call a different handler. In both cases deadlocks must be
prevented, if the workqueue is drained under lock and QETH_PNSO_NONE,
when notification is disabled.

bridge_hostnotify generates udev events, there is no intend to do the same
for dev2br. Instead this patch will generate SWITCHDEV_FDB_ADD_TO_BRIDGE
and SWITCHDEV_FDB_DEL_TO_BRIDGE notifications, that will cause the
software bridge to add (or delete) entries to its fdb as 'extern_learn
offload'.

Documentation/networking/switchdev.txt proposes to add
"depends NET_SWITCHDEV" to driver's Kconfig. This is not done here,
so even in absence of the NET_SWITCHDEV module, the QETH_L2 module will
still be built, but then the switchdev notifiers will have no effect.

No VLAN filtering is done on the entries and VLAN information is not
passed on to the bridge fdb entries. This could be added later.
For now VLAN interfaces can be defined on the upper bridge interface.

Multicast entries are not passed on to the bridge fdb.
This could be added later. For now mcast flooding can be used in the
bridge.

The card reports all MACs that are in its FDB, but we must not pass on
MACs that are registered for this interface.

Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Reviewed-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h    |   1 +
 drivers/s390/net/qeth_l2_main.c | 110 +++++++++++++++++++++++++++++++-
 2 files changed, 110 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 14c583b5ea11..4c8134a953c9 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -677,6 +677,7 @@ struct qeth_card_blkt {
 enum qeth_pnso_mode {
 	QETH_PNSO_NONE,
 	QETH_PNSO_BRIDGEPORT,
+	QETH_PNSO_ADDR_INFO,
 };
 
 #define QETH_BROADCAST_WITH_ECHO    0x01
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 7cba3d0035bf..fffbc50cadc6 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -21,6 +21,7 @@
 #include <linux/list.h>
 #include <linux/hash.h>
 #include <linux/hashtable.h>
+#include <net/switchdev.h>
 #include <asm/chsc.h>
 #include <asm/css_chars.h>
 #include <asm/setup.h>
@@ -709,6 +710,68 @@ static int qeth_l2_pnso(struct qeth_card *card, u8 oc, int cnc,
 	return rc;
 }
 
+static bool qeth_is_my_net_if_token(struct qeth_card *card,
+				    struct net_if_token *token)
+{
+	return ((card->info.ddev_devno == token->devnum) &&
+		(card->info.cssid == token->cssid) &&
+		(card->info.iid == token->iid) &&
+		(card->info.ssid == token->ssid) &&
+		(card->info.chpid == token->chpid) &&
+		(card->info.chid == token->chid));
+}
+
+/**
+ *	qeth_l2_dev2br_fdb_notify() - update fdb of master bridge
+ *	@card:	qeth_card structure pointer
+ *	@code:	event bitmask: high order bit 0x80 set to
+ *				1 - removal of an object
+ *				0 - addition of an object
+ *			       Object type(s):
+ *				0x01 - VLAN, 0x02 - MAC, 0x03 - VLAN and MAC
+ *	@token: "network token" structure identifying 'physical' location
+ *		of the target
+ *	@addr_lnid: structure with MAC address and VLAN ID of the target
+ */
+static void qeth_l2_dev2br_fdb_notify(struct qeth_card *card, u8 code,
+				      struct net_if_token *token,
+				      struct mac_addr_lnid *addr_lnid)
+{
+	struct switchdev_notifier_fdb_info info;
+	u8 ntfy_mac[ETH_ALEN];
+
+	ether_addr_copy(ntfy_mac, addr_lnid->mac);
+	/* Ignore VLAN only changes */
+	if (!(code & IPA_ADDR_CHANGE_CODE_MACADDR))
+		return;
+	/* Ignore mcast entries */
+	if (is_multicast_ether_addr(ntfy_mac))
+		return;
+	/* Ignore my own addresses */
+	if (qeth_is_my_net_if_token(card, token))
+		return;
+
+	info.addr = ntfy_mac;
+	/* don't report VLAN IDs */
+	info.vid = 0;
+	info.added_by_user = false;
+	info.offloaded = true;
+
+	if (code & IPA_ADDR_CHANGE_CODE_REMOVAL) {
+		call_switchdev_notifiers(SWITCHDEV_FDB_DEL_TO_BRIDGE,
+					 card->dev, &info.info, NULL);
+		QETH_CARD_TEXT(card, 4, "andelmac");
+		QETH_CARD_TEXT_(card, 4,
+				"mc%012lx", ether_addr_to_u64(ntfy_mac));
+	} else {
+		call_switchdev_notifiers(SWITCHDEV_FDB_ADD_TO_BRIDGE,
+					 card->dev, &info.info, NULL);
+		QETH_CARD_TEXT(card, 4, "anaddmac");
+		QETH_CARD_TEXT_(card, 4,
+				"mc%012lx", ether_addr_to_u64(ntfy_mac));
+	}
+}
+
 static const struct net_device_ops qeth_l2_netdev_ops = {
 	.ndo_open		= qeth_open,
 	.ndo_stop		= qeth_stop,
@@ -1216,6 +1279,48 @@ struct qeth_addr_change_data {
 	struct qeth_ipacmd_addr_change ac_event;
 };
 
+static void qeth_l2_dev2br_worker(struct work_struct *work)
+{
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct qeth_addr_change_data *data;
+	struct qeth_card *card;
+	unsigned int i;
+
+	data = container_of(dwork, struct qeth_addr_change_data, dwork);
+	card = data->card;
+
+	QETH_CARD_TEXT(card, 4, "dev2brew");
+
+	if (READ_ONCE(card->info.pnso_mode) == QETH_PNSO_NONE)
+		goto free;
+
+	/* Potential re-config in progress, try again later: */
+	if (!rtnl_trylock()) {
+		queue_delayed_work(card->event_wq, dwork,
+				   msecs_to_jiffies(100));
+		return;
+	}
+
+	if (data->ac_event.lost_event_mask) {
+		QETH_DBF_MESSAGE(3,
+				 "Address change notification overflow on device %x\n",
+				 CARD_DEVID(card));
+	} else {
+		for (i = 0; i < data->ac_event.num_entries; i++) {
+			struct qeth_ipacmd_addr_change_entry *entry =
+					&data->ac_event.entry[i];
+			qeth_l2_dev2br_fdb_notify(card,
+						  entry->change_code,
+						  &entry->token,
+						  &entry->addr_lnid);
+		}
+	}
+	rtnl_unlock();
+
+free:
+	kfree(data);
+}
+
 static void qeth_addr_change_event_worker(struct work_struct *work)
 {
 	struct delayed_work *dwork = to_delayed_work(work);
@@ -1298,7 +1403,10 @@ static void qeth_addr_change_event(struct qeth_card *card,
 		QETH_CARD_TEXT(card, 2, "ACNalloc");
 		return;
 	}
-	INIT_DELAYED_WORK(&data->dwork, qeth_addr_change_event_worker);
+	if (card->info.pnso_mode == QETH_PNSO_BRIDGEPORT)
+		INIT_DELAYED_WORK(&data->dwork, qeth_addr_change_event_worker);
+	else
+		INIT_DELAYED_WORK(&data->dwork, qeth_l2_dev2br_worker);
 	data->card = card;
 	memcpy(&data->ac_event, hostevs,
 			sizeof(struct qeth_ipacmd_addr_change) + extrasize);
-- 
2.17.1

