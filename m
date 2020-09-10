Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8832264B31
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 19:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727037AbgIJR07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 13:26:59 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:2642 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727025AbgIJRYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 13:24:11 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08AH2ilc006898;
        Thu, 10 Sep 2020 13:24:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=Va2B/cjq9t4I0v4Q/XK0hTd57VL2MKXafpQC+HFjP0w=;
 b=eb+MXQrCjl1Xys5BdVBjsqDA3rj2cWFV/kfODTbMpziQteDaTsi18DCO1zh7LFAigNy0
 U5Uqtt3zbXWHVMzEt2UvFQLpYlhWvhwh1U+48HriaDo9Z4nxQqoZFDMPkZz2d6ul4st8
 wgcLFl/YA2I497YAE95ntt7PpJuZr8P2kGKr9NVEJOafjY4xaH7hKI8L4BC7mJx4cF9B
 UCsxT0JiT7HTEOiXyEmeIMPBexcU1yrv90PyCs310caJImGDGQfqqvP41b59p2IgMs7M
 3JblVKx/cNg4S4CYAP4CKaiMeGt6B7rHrOIhaBWRT4EryhvMwWbxucd/4kpweDoXJ41/ 3g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33fq9s24ht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 13:24:04 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08AH2sHP007379;
        Thu, 10 Sep 2020 13:24:04 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33fq9s24h3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 13:24:03 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08AHHtb7017012;
        Thu, 10 Sep 2020 17:24:02 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 33c2a86a45-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 17:24:02 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08AHNxCX35979754
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Sep 2020 17:23:59 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2300C42041;
        Thu, 10 Sep 2020 17:23:59 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A7BE042042;
        Thu, 10 Sep 2020 17:23:58 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 10 Sep 2020 17:23:58 +0000 (GMT)
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
Subject: [PATCH net-next 8/8] s390/qeth: implement ndo_bridge_setlink for learning_sync
Date:   Thu, 10 Sep 2020 19:23:51 +0200
Message-Id: <20200910172351.5622-9-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200910172351.5622-1-jwi@linux.ibm.com>
References: <20200910172351.5622-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-10_05:2020-09-10,2020-09-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 suspectscore=0 bulkscore=0 impostorscore=0 clxscore=1015 phishscore=0
 priorityscore=1501 malwarescore=0 lowpriorityscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009100157
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexandra Winter <wintera@linux.ibm.com>

Documentation/networking/switchdev.txt and 'man bridge' indicate that the
learning_sync bridge attribute is used to control whether a given
device will sync MAC addresses learned on its device port to a master
bridge FDB, where they will show up as 'extern_learn offload'. So we map
qeth_l2_dev2br_an_set() to the learning_sync bridge link attribute.

Turning off learning_sync will flush all extern_learn entries from the
bridge fdb and all pending events from the card's work queue.

When the hardware interface goes offline with learning_sync on
(e.g. for HW recovery), all extern_learn entries will be flushed from the
bridge fdb and all pending events from the card's work queue. When the
interface goes online again, it will send new notifications for all then
valid MACs. learning_sync attribute can not be modified while interface is
offline. See
'commit e6e771b3d897 ("s390/qeth: detach netdevice while card is offline")'

An alternative implementation would be to always offload the 'learning'
attribute of a software bridge to the hardware interface attached to it
and thus implicitly enable fdb notification. This was not chosen for 2
reasons:
1) In our case the software bridge is NOT a representation of a hardware
switch. It is just connected to a smart NIC that is able to inform
about the addresses attached to it. It is not necessarily using source
MAC learning for this and other bridgeports can be attached to other
NICs with different properties.
2) We want a means to enable this notification explicitly. There may be
cases where a bridgeport is set to 'learning', but we do not want to
enable the notification.

Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Reviewed-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_l2_main.c | 125 ++++++++++++++++++++++++++++++++
 1 file changed, 125 insertions(+)

diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 338bc62556cf..54e02518ce08 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -306,6 +306,8 @@ static void qeth_l2_dev2br_fdb_flush(struct qeth_card *card)
 
 static void qeth_l2_stop_card(struct qeth_card *card)
 {
+	struct qeth_priv *priv = netdev_priv(card->dev);
+
 	QETH_CARD_TEXT(card, 2, "stopcard");
 
 	qeth_set_allowed_threads(card, 0, 1);
@@ -324,6 +326,12 @@ static void qeth_l2_stop_card(struct qeth_card *card)
 	qeth_l2_set_pnso_mode(card, QETH_PNSO_NONE);
 	qeth_flush_local_addrs(card);
 	card->info.promisc_mode = 0;
+
+	if (priv->brport_features & BR_LEARNING_SYNC) {
+		rtnl_lock();
+		qeth_l2_dev2br_fdb_flush(card);
+		rtnl_unlock();
+	}
 }
 
 static int qeth_l2_request_initial_mac(struct qeth_card *card)
@@ -856,6 +864,89 @@ static int qeth_l2_bridge_getlink(struct sk_buff *skb, u32 pid, u32 seq,
 				       nlflags, filter_mask, NULL);
 }
 
+static const struct nla_policy qeth_brport_policy[IFLA_BRPORT_MAX + 1] = {
+	[IFLA_BRPORT_LEARNING_SYNC]	= { .type = NLA_U8 },
+};
+
+/**
+ *	qeth_l2_bridge_setlink() - set bridgeport attributes
+ *	@dev: netdevice
+ *	@nlh: netlink message header
+ *	@flags: bridge flags (here: BRIDGE_FLAGS_SELF)
+ *	@extack: extended ACK report struct
+ *
+ *	Called under rtnl_lock
+ */
+static int qeth_l2_bridge_setlink(struct net_device *dev, struct nlmsghdr *nlh,
+				  u16 flags, struct netlink_ext_ack *extack)
+{
+	struct qeth_priv *priv = netdev_priv(dev);
+	struct nlattr *bp_tb[IFLA_BRPORT_MAX + 1];
+	struct qeth_card *card = dev->ml_priv;
+	struct nlattr *attr, *nested_attr;
+	bool enable, has_protinfo = false;
+	int rem1, rem2;
+	int rc;
+
+	if (!netif_device_present(dev))
+		return -ENODEV;
+	if (!(priv->brport_hw_features))
+		return -EOPNOTSUPP;
+
+	nlmsg_for_each_attr(attr, nlh, sizeof(struct ifinfomsg), rem1) {
+		if (nla_type(attr) == IFLA_PROTINFO) {
+			rc = nla_parse_nested(bp_tb, IFLA_BRPORT_MAX, attr,
+					      qeth_brport_policy, extack);
+			if (rc)
+				return rc;
+			has_protinfo = true;
+		} else if (nla_type(attr) == IFLA_AF_SPEC) {
+			nla_for_each_nested(nested_attr, attr, rem2) {
+				if (nla_type(nested_attr) == IFLA_BRIDGE_FLAGS)
+					continue;
+				NL_SET_ERR_MSG_ATTR(extack, nested_attr,
+						    "Unsupported attribute");
+				return -EINVAL;
+			}
+		} else {
+			NL_SET_ERR_MSG_ATTR(extack, attr, "Unsupported attribute");
+			return -EINVAL;
+		}
+	}
+	if (!has_protinfo)
+		return 0;
+	if (!bp_tb[IFLA_BRPORT_LEARNING_SYNC])
+		return -EINVAL;
+	enable = !!nla_get_u8(bp_tb[IFLA_BRPORT_LEARNING_SYNC]);
+
+	if (enable == !!(priv->brport_features & BR_LEARNING_SYNC))
+		return 0;
+
+	mutex_lock(&card->sbp_lock);
+	/* do not change anything if BridgePort is enabled */
+	if (qeth_bridgeport_is_in_use(card)) {
+		NL_SET_ERR_MSG(extack, "n/a (BridgePort)");
+		rc = -EBUSY;
+	} else if (enable) {
+		qeth_l2_set_pnso_mode(card, QETH_PNSO_ADDR_INFO);
+		rc = qeth_l2_dev2br_an_set(card, true);
+		if (rc)
+			qeth_l2_set_pnso_mode(card, QETH_PNSO_NONE);
+		else
+			priv->brport_features |= BR_LEARNING_SYNC;
+	} else {
+		rc = qeth_l2_dev2br_an_set(card, false);
+		if (!rc) {
+			qeth_l2_set_pnso_mode(card, QETH_PNSO_NONE);
+			priv->brport_features ^= BR_LEARNING_SYNC;
+			qeth_l2_dev2br_fdb_flush(card);
+		}
+	}
+	mutex_unlock(&card->sbp_lock);
+
+	return rc;
+}
+
 static const struct net_device_ops qeth_l2_netdev_ops = {
 	.ndo_open		= qeth_open,
 	.ndo_stop		= qeth_stop,
@@ -873,6 +964,7 @@ static const struct net_device_ops qeth_l2_netdev_ops = {
 	.ndo_fix_features	= qeth_fix_features,
 	.ndo_set_features	= qeth_set_features,
 	.ndo_bridge_getlink	= qeth_l2_bridge_getlink,
+	.ndo_bridge_setlink	= qeth_l2_bridge_setlink,
 };
 
 static const struct net_device_ops qeth_osn_netdev_ops = {
@@ -1016,6 +1108,38 @@ static void qeth_l2_detect_dev2br_support(struct qeth_card *card)
 		priv->brport_hw_features &= ~BR_LEARNING_SYNC;
 }
 
+static void qeth_l2_enable_brport_features(struct qeth_card *card)
+{
+	struct qeth_priv *priv = netdev_priv(card->dev);
+	int rc;
+
+	if (priv->brport_features & BR_LEARNING_SYNC) {
+		if (priv->brport_hw_features & BR_LEARNING_SYNC) {
+			qeth_l2_set_pnso_mode(card, QETH_PNSO_ADDR_INFO);
+			rc = qeth_l2_dev2br_an_set(card, true);
+			if (rc == -EAGAIN) {
+				/* Recoverable error, retry once */
+				qeth_l2_set_pnso_mode(card, QETH_PNSO_NONE);
+				qeth_l2_dev2br_fdb_flush(card);
+				qeth_l2_set_pnso_mode(card, QETH_PNSO_ADDR_INFO);
+				rc = qeth_l2_dev2br_an_set(card, true);
+			}
+			if (rc) {
+				netdev_err(card->dev,
+					   "failed to enable bridge learning_sync: %d\n",
+					   rc);
+				qeth_l2_set_pnso_mode(card, QETH_PNSO_NONE);
+				qeth_l2_dev2br_fdb_flush(card);
+				priv->brport_features ^= BR_LEARNING_SYNC;
+			}
+		} else {
+			dev_warn(&card->gdev->dev,
+				"bridge learning_sync not supported\n");
+			priv->brport_features ^= BR_LEARNING_SYNC;
+		}
+	}
+}
+
 static int qeth_l2_set_online(struct qeth_card *card)
 {
 	struct ccwgroup_device *gdev = card->gdev;
@@ -1075,6 +1199,7 @@ static int qeth_l2_set_online(struct qeth_card *card)
 
 		netif_device_attach(dev);
 		qeth_enable_hw_features(dev);
+		qeth_l2_enable_brport_features(card);
 
 		if (card->info.open_when_online) {
 			card->info.open_when_online = 0;
-- 
2.17.1

