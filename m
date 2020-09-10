Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D296264B2B
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 19:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbgIJRZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 13:25:38 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:23384 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727019AbgIJRYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 13:24:10 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08AH4d87127908;
        Thu, 10 Sep 2020 13:24:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=BEGpEQ3J4/6Oh2DjS04yrRsii8Of/tNXTOnjnThOxYE=;
 b=hjbMYF/TKQrTyNyelHnrYsBWLtPSPhpjC1kycZbHOePRMQl5veKZvzd1aWcH8k9XaYes
 dlF1N7FawhkXN7TBlhgAkUnoHKPnJTxPa8ga2ELEqRAV/tt1JFcGjlwvUtI4YM/7uSeA
 OX9nSplIoFLGqFq9kcqVTQ9TxWaONtlBydloktmDK9aRzpgx1DR0U7NdJa23FUm+zCDl
 SjF/LiSplHVYoiQaCn964ytuLf5+bOR0e8O2xwzCqHGIT1b72ht7yMVxp2+UUQdS2/Nm
 l7NNayI9KBWJDfYh3DxxrgO309MWPuUoFhc+rPKmo1rxL5ImVLo1tLQE3zVSP8KbwB2D Og== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33fq1pbc9q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 13:24:04 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08AH6BGn135901;
        Thu, 10 Sep 2020 13:24:03 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33fq1pbc91-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 13:24:03 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08AHGmVa023198;
        Thu, 10 Sep 2020 17:24:01 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 33c2a8eajx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 17:24:01 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08AHNwRO19333568
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Sep 2020 17:23:58 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9A58B42041;
        Thu, 10 Sep 2020 17:23:58 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2EFD34203F;
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
Subject: [PATCH net-next 7/8] s390/qeth: implement ndo_bridge_getlink for learning_sync
Date:   Thu, 10 Sep 2020 19:23:50 +0200
Message-Id: <20200910172351.5622-8-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200910172351.5622-1-jwi@linux.ibm.com>
References: <20200910172351.5622-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-10_05:2020-09-10,2020-09-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 mlxscore=0 suspectscore=0 bulkscore=0 spamscore=0 clxscore=1015
 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009100157
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexandra Winter <wintera@linux.ibm.com>

Documentation/networking/switchdev.txt and 'man bridge' indicate that the
learning_sync bridge attribute is used to indicate whether a given
device will sync MAC addresses learned on its device port to a master
bridge FDB.

learning_sync attribute can not be read while interface is offline (down).
See
'commit e6e771b3d897 ("s390/qeth: detach netdevice while card is offline")'
We return EOPNOTSUPP and not EONODEV in this case, because EONOTSUPP is the
only rc that is tolerated by 'bridge -d link show'.

Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Reviewed-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_l2_main.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index ef2962e03546..338bc62556cf 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -33,6 +33,7 @@ static void qeth_bridge_state_change(struct qeth_card *card,
 					struct qeth_ipa_cmd *cmd);
 static void qeth_addr_change_event(struct qeth_card *card,
 				   struct qeth_ipa_cmd *cmd);
+static bool qeth_bridgeport_is_in_use(struct qeth_card *card);
 static void qeth_l2_vnicc_set_defaults(struct qeth_card *card);
 static void qeth_l2_vnicc_init(struct qeth_card *card);
 static bool qeth_l2_vnicc_recover_timeout(struct qeth_card *card, u32 vnicc,
@@ -836,6 +837,25 @@ static int qeth_l2_dev2br_an_set(struct qeth_card *card, bool enable)
 	return rc;
 }
 
+static int qeth_l2_bridge_getlink(struct sk_buff *skb, u32 pid, u32 seq,
+				  struct net_device *dev, u32 filter_mask,
+				  int nlflags)
+{
+	struct qeth_priv *priv = netdev_priv(dev);
+	struct qeth_card *card = dev->ml_priv;
+	u16 mode = BRIDGE_MODE_UNDEF;
+
+	/* Do not even show qeth devs that cannot do bridge_setlink */
+	if (!priv->brport_hw_features || !netif_device_present(dev) ||
+	    qeth_bridgeport_is_in_use(card))
+		return -EOPNOTSUPP;
+
+	return ndo_dflt_bridge_getlink(skb, pid, seq, dev,
+				       mode, priv->brport_features,
+				       priv->brport_hw_features,
+				       nlflags, filter_mask, NULL);
+}
+
 static const struct net_device_ops qeth_l2_netdev_ops = {
 	.ndo_open		= qeth_open,
 	.ndo_stop		= qeth_stop,
@@ -851,7 +871,8 @@ static const struct net_device_ops qeth_l2_netdev_ops = {
 	.ndo_vlan_rx_kill_vid   = qeth_l2_vlan_rx_kill_vid,
 	.ndo_tx_timeout	   	= qeth_tx_timeout,
 	.ndo_fix_features	= qeth_fix_features,
-	.ndo_set_features	= qeth_set_features
+	.ndo_set_features	= qeth_set_features,
+	.ndo_bridge_getlink	= qeth_l2_bridge_getlink,
 };
 
 static const struct net_device_ops qeth_osn_netdev_ops = {
-- 
2.17.1

