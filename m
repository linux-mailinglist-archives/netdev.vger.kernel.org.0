Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B891A690613
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 12:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbjBILFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 06:05:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbjBILEo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 06:04:44 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE79F59CA;
        Thu,  9 Feb 2023 03:04:41 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 319AtCiC023439;
        Thu, 9 Feb 2023 11:04:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=EDTIGT0BpL3gLPYAzKCpU8BcJEormS9nxBHYOGFJ16w=;
 b=UeNrWmJw8zcz21DOcN1WH1ZZm6177kx8obQjAN8HIUgU9Xi4hH3gnQ4G0mUYn7heAQKy
 GnNQW0O+ytVB4Lpjqi+XNf56bGgIlStrUhtUUEo/H8AbCjSOR6Y0pDRcd6ittmOztcxn
 3wQuTAFpqbC2prXg8lbouj34fQ7dUxhI7dZoGd0E8GBj1TnesO275HO3UwTCuCXUtWvW
 SseVdK1qBLtomUaZWmsnTXFwRO2Gdf8NlQOnir3pU8Lk2h0o8PCEjpcArb2Bg/Nd7fe7
 gwqbh0B2n31ftzZGd5oPWZXcvLc02qcDR4ykTMWAxFSfFNJw/DfFdmf1T55O5AMDZnOc Rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nmygjg76m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 11:04:33 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 319Atwvk025673;
        Thu, 9 Feb 2023 11:04:33 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nmygjg75w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 11:04:33 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 318KT9bQ002393;
        Thu, 9 Feb 2023 11:04:30 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3nhf06p28x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 11:04:30 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 319B4RPO22479210
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Feb 2023 11:04:27 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1276820043;
        Thu,  9 Feb 2023 11:04:27 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E23E020040;
        Thu,  9 Feb 2023 11:04:26 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Thu,  9 Feb 2023 11:04:26 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55271)
        id B4575E12A5; Thu,  9 Feb 2023 12:04:26 +0100 (CET)
From:   Alexandra Winter <wintera@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Thorsten Winkler <twinkler@linux.ibm.com>,
        Jules Irenge <jbi.octave@gmail.com>,
        Joe Perches <joe@perches.com>,
        Alexandra Winter <wintera@linux.ibm.com>
Subject: [PATCH net-next v2 3/4] s390/qeth: Convert sysfs sprintf to sysfs_emit
Date:   Thu,  9 Feb 2023 12:04:23 +0100
Message-Id: <20230209110424.1707501-4-wintera@linux.ibm.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230209110424.1707501-1-wintera@linux.ibm.com>
References: <20230209110424.1707501-1-wintera@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: GbMSpBIS1UznuRglsDXWHva-gJ3EwVEN
X-Proofpoint-GUID: QRDL9Gou_DmV0M6lvyntaW7pV3pQbjsq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-09_08,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 suspectscore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0
 malwarescore=0 bulkscore=0 adultscore=0 priorityscore=1501 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302090105
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thorsten Winkler <twinkler@linux.ibm.com>

Following the advice of the Documentation/filesystems/sysfs.rst.
All sysfs related show()-functions should only use sysfs_emit() or
sysfs_emit_at() when formatting the value to be returned to user space.

Reported-by: Jules Irenge <jbi.octave@gmail.com>
Reported-by: Joe Perches <joe@perches.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: Thorsten Winkler <twinkler@linux.ibm.com>
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
---
 drivers/s390/net/qeth_core_sys.c | 66 ++++++++++++++-------------
 drivers/s390/net/qeth_l2_sys.c   | 28 ++++++------
 drivers/s390/net/qeth_l3_sys.c   | 77 +++++++++++---------------------
 3 files changed, 73 insertions(+), 98 deletions(-)

diff --git a/drivers/s390/net/qeth_core_sys.c b/drivers/s390/net/qeth_core_sys.c
index d1adc4b83193..eea93f8f106f 100644
--- a/drivers/s390/net/qeth_core_sys.c
+++ b/drivers/s390/net/qeth_core_sys.c
@@ -23,15 +23,15 @@ static ssize_t qeth_dev_state_show(struct device *dev,
 
 	switch (card->state) {
 	case CARD_STATE_DOWN:
-		return sprintf(buf, "DOWN\n");
+		return sysfs_emit(buf, "DOWN\n");
 	case CARD_STATE_SOFTSETUP:
 		if (card->dev->flags & IFF_UP)
-			return sprintf(buf, "UP (LAN %s)\n",
-				       netif_carrier_ok(card->dev) ? "ONLINE" :
-								     "OFFLINE");
-		return sprintf(buf, "SOFTSETUP\n");
+			return sysfs_emit(buf, "UP (LAN %s)\n",
+					  netif_carrier_ok(card->dev) ?
+					  "ONLINE" : "OFFLINE");
+		return sysfs_emit(buf, "SOFTSETUP\n");
 	default:
-		return sprintf(buf, "UNKNOWN\n");
+		return sysfs_emit(buf, "UNKNOWN\n");
 	}
 }
 
@@ -42,7 +42,7 @@ static ssize_t qeth_dev_chpid_show(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	return sprintf(buf, "%02X\n", card->info.chpid);
+	return sysfs_emit(buf, "%02X\n", card->info.chpid);
 }
 
 static DEVICE_ATTR(chpid, 0444, qeth_dev_chpid_show, NULL);
@@ -52,7 +52,7 @@ static ssize_t qeth_dev_if_name_show(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	return sprintf(buf, "%s\n", netdev_name(card->dev));
+	return sysfs_emit(buf, "%s\n", netdev_name(card->dev));
 }
 
 static DEVICE_ATTR(if_name, 0444, qeth_dev_if_name_show, NULL);
@@ -62,7 +62,7 @@ static ssize_t qeth_dev_card_type_show(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	return sprintf(buf, "%s\n", qeth_get_cardname_short(card));
+	return sysfs_emit(buf, "%s\n", qeth_get_cardname_short(card));
 }
 
 static DEVICE_ATTR(card_type, 0444, qeth_dev_card_type_show, NULL);
@@ -86,7 +86,7 @@ static ssize_t qeth_dev_inbuf_size_show(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	return sprintf(buf, "%s\n", qeth_get_bufsize_str(card));
+	return sysfs_emit(buf, "%s\n", qeth_get_bufsize_str(card));
 }
 
 static DEVICE_ATTR(inbuf_size, 0444, qeth_dev_inbuf_size_show, NULL);
@@ -96,7 +96,7 @@ static ssize_t qeth_dev_portno_show(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	return sprintf(buf, "%i\n", card->dev->dev_port);
+	return sysfs_emit(buf, "%i\n", card->dev->dev_port);
 }
 
 static ssize_t qeth_dev_portno_store(struct device *dev,
@@ -134,7 +134,7 @@ static DEVICE_ATTR(portno, 0644, qeth_dev_portno_show, qeth_dev_portno_store);
 static ssize_t qeth_dev_portname_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
-	return sprintf(buf, "no portname required\n");
+	return sysfs_emit(buf, "no portname required\n");
 }
 
 static ssize_t qeth_dev_portname_store(struct device *dev,
@@ -157,18 +157,18 @@ static ssize_t qeth_dev_prioqing_show(struct device *dev,
 
 	switch (card->qdio.do_prio_queueing) {
 	case QETH_PRIO_Q_ING_PREC:
-		return sprintf(buf, "%s\n", "by precedence");
+		return sysfs_emit(buf, "%s\n", "by precedence");
 	case QETH_PRIO_Q_ING_TOS:
-		return sprintf(buf, "%s\n", "by type of service");
+		return sysfs_emit(buf, "%s\n", "by type of service");
 	case QETH_PRIO_Q_ING_SKB:
-		return sprintf(buf, "%s\n", "by skb-priority");
+		return sysfs_emit(buf, "%s\n", "by skb-priority");
 	case QETH_PRIO_Q_ING_VLAN:
-		return sprintf(buf, "%s\n", "by VLAN headers");
+		return sysfs_emit(buf, "%s\n", "by VLAN headers");
 	case QETH_PRIO_Q_ING_FIXED:
-		return sprintf(buf, "always queue %i\n",
+		return sysfs_emit(buf, "always queue %i\n",
 			       card->qdio.default_out_queue);
 	default:
-		return sprintf(buf, "disabled\n");
+		return sysfs_emit(buf, "disabled\n");
 	}
 }
 
@@ -242,7 +242,7 @@ static ssize_t qeth_dev_bufcnt_show(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	return sprintf(buf, "%i\n", card->qdio.in_buf_pool.buf_count);
+	return sysfs_emit(buf, "%i\n", card->qdio.in_buf_pool.buf_count);
 }
 
 static ssize_t qeth_dev_bufcnt_store(struct device *dev,
@@ -298,7 +298,7 @@ static DEVICE_ATTR(recover, 0200, NULL, qeth_dev_recover_store);
 static ssize_t qeth_dev_performance_stats_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
-	return sprintf(buf, "1\n");
+	return sysfs_emit(buf, "1\n");
 }
 
 static ssize_t qeth_dev_performance_stats_store(struct device *dev,
@@ -335,7 +335,7 @@ static ssize_t qeth_dev_layer2_show(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	return sprintf(buf, "%i\n", card->options.layer);
+	return sysfs_emit(buf, "%i\n", card->options.layer);
 }
 
 static ssize_t qeth_dev_layer2_store(struct device *dev,
@@ -470,23 +470,25 @@ static ssize_t qeth_dev_switch_attrs_show(struct device *dev,
 	int	rc = 0;
 
 	if (!qeth_card_hw_is_reachable(card))
-		return sprintf(buf, "n/a\n");
+		return sysfs_emit(buf, "n/a\n");
 
 	rc = qeth_query_switch_attributes(card, &sw_info);
 	if (rc)
 		return rc;
 
 	if (!sw_info.capabilities)
-		rc = sprintf(buf, "unknown");
+		rc = sysfs_emit(buf, "unknown");
 
 	if (sw_info.capabilities & QETH_SWITCH_FORW_802_1)
-		rc = sprintf(buf, (sw_info.settings & QETH_SWITCH_FORW_802_1 ?
-							"[802.1]" : "802.1"));
+		rc = sysfs_emit(buf,
+				(sw_info.settings & QETH_SWITCH_FORW_802_1 ?
+				"[802.1]" : "802.1"));
 	if (sw_info.capabilities & QETH_SWITCH_FORW_REFL_RELAY)
-		rc += sprintf(buf + rc,
-			(sw_info.settings & QETH_SWITCH_FORW_REFL_RELAY ?
-							" [rr]" : " rr"));
-	rc += sprintf(buf + rc, "\n");
+		rc += sysfs_emit_at(buf, rc,
+				    (sw_info.settings &
+				    QETH_SWITCH_FORW_REFL_RELAY ?
+				    " [rr]" : " rr"));
+	rc += sysfs_emit_at(buf, rc, "\n");
 
 	return rc;
 }
@@ -573,7 +575,7 @@ static ssize_t qeth_dev_blkt_total_show(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	return sprintf(buf, "%i\n", card->info.blkt.time_total);
+	return sysfs_emit(buf, "%i\n", card->info.blkt.time_total);
 }
 
 static ssize_t qeth_dev_blkt_total_store(struct device *dev,
@@ -593,7 +595,7 @@ static ssize_t qeth_dev_blkt_inter_show(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	return sprintf(buf, "%i\n", card->info.blkt.inter_packet);
+	return sysfs_emit(buf, "%i\n", card->info.blkt.inter_packet);
 }
 
 static ssize_t qeth_dev_blkt_inter_store(struct device *dev,
@@ -613,7 +615,7 @@ static ssize_t qeth_dev_blkt_inter_jumbo_show(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	return sprintf(buf, "%i\n", card->info.blkt.inter_packet_jumbo);
+	return sysfs_emit(buf, "%i\n", card->info.blkt.inter_packet_jumbo);
 }
 
 static ssize_t qeth_dev_blkt_inter_jumbo_store(struct device *dev,
diff --git a/drivers/s390/net/qeth_l2_sys.c b/drivers/s390/net/qeth_l2_sys.c
index a617351fff57..7f592f912517 100644
--- a/drivers/s390/net/qeth_l2_sys.c
+++ b/drivers/s390/net/qeth_l2_sys.c
@@ -19,7 +19,7 @@ static ssize_t qeth_bridge_port_role_state_show(struct device *dev,
 	char *word;
 
 	if (!qeth_bridgeport_allowed(card))
-		return sprintf(buf, "n/a (VNIC characteristics)\n");
+		return sysfs_emit(buf, "n/a (VNIC characteristics)\n");
 
 	mutex_lock(&card->sbp_lock);
 	if (qeth_card_hw_is_reachable(card) &&
@@ -53,7 +53,7 @@ static ssize_t qeth_bridge_port_role_state_show(struct device *dev,
 			QETH_CARD_TEXT_(card, 2, "SBP%02x:%02x",
 				card->options.sbp.role, state);
 		else
-			rc = sprintf(buf, "%s\n", word);
+			rc = sysfs_emit(buf, "%s\n", word);
 	}
 	mutex_unlock(&card->sbp_lock);
 
@@ -66,7 +66,7 @@ static ssize_t qeth_bridge_port_role_show(struct device *dev,
 	struct qeth_card *card = dev_get_drvdata(dev);
 
 	if (!qeth_bridgeport_allowed(card))
-		return sprintf(buf, "n/a (VNIC characteristics)\n");
+		return sysfs_emit(buf, "n/a (VNIC characteristics)\n");
 
 	return qeth_bridge_port_role_state_show(dev, attr, buf, 0);
 }
@@ -117,7 +117,7 @@ static ssize_t qeth_bridge_port_state_show(struct device *dev,
 	struct qeth_card *card = dev_get_drvdata(dev);
 
 	if (!qeth_bridgeport_allowed(card))
-		return sprintf(buf, "n/a (VNIC characteristics)\n");
+		return sysfs_emit(buf, "n/a (VNIC characteristics)\n");
 
 	return qeth_bridge_port_role_state_show(dev, attr, buf, 1);
 }
@@ -132,11 +132,11 @@ static ssize_t qeth_bridgeport_hostnotification_show(struct device *dev,
 	int enabled;
 
 	if (!qeth_bridgeport_allowed(card))
-		return sprintf(buf, "n/a (VNIC characteristics)\n");
+		return sysfs_emit(buf, "n/a (VNIC characteristics)\n");
 
 	enabled = card->options.sbp.hostnotification;
 
-	return sprintf(buf, "%d\n", enabled);
+	return sysfs_emit(buf, "%d\n", enabled);
 }
 
 static ssize_t qeth_bridgeport_hostnotification_store(struct device *dev,
@@ -180,7 +180,7 @@ static ssize_t qeth_bridgeport_reflect_show(struct device *dev,
 	char *state;
 
 	if (!qeth_bridgeport_allowed(card))
-		return sprintf(buf, "n/a (VNIC characteristics)\n");
+		return sysfs_emit(buf, "n/a (VNIC characteristics)\n");
 
 	if (card->options.sbp.reflect_promisc) {
 		if (card->options.sbp.reflect_promisc_primary)
@@ -190,7 +190,7 @@ static ssize_t qeth_bridgeport_reflect_show(struct device *dev,
 	} else
 		state = "none";
 
-	return sprintf(buf, "%s\n", state);
+	return sysfs_emit(buf, "%s\n", state);
 }
 
 static ssize_t qeth_bridgeport_reflect_store(struct device *dev,
@@ -280,10 +280,10 @@ static ssize_t qeth_vnicc_timeout_show(struct device *dev,
 
 	rc = qeth_l2_vnicc_get_timeout(card, &timeout);
 	if (rc == -EBUSY)
-		return sprintf(buf, "n/a (BridgePort)\n");
+		return sysfs_emit(buf, "n/a (BridgePort)\n");
 	if (rc == -EOPNOTSUPP)
-		return sprintf(buf, "n/a\n");
-	return rc ? rc : sprintf(buf, "%d\n", timeout);
+		return sysfs_emit(buf, "n/a\n");
+	return rc ? rc : sysfs_emit(buf, "%d\n", timeout);
 }
 
 /* change timeout setting */
@@ -318,10 +318,10 @@ static ssize_t qeth_vnicc_char_show(struct device *dev,
 	rc = qeth_l2_vnicc_get_state(card, vnicc, &state);
 
 	if (rc == -EBUSY)
-		return sprintf(buf, "n/a (BridgePort)\n");
+		return sysfs_emit(buf, "n/a (BridgePort)\n");
 	if (rc == -EOPNOTSUPP)
-		return sprintf(buf, "n/a\n");
-	return rc ? rc : sprintf(buf, "%d\n", state);
+		return sysfs_emit(buf, "n/a\n");
+	return rc ? rc : sysfs_emit(buf, "%d\n", state);
 }
 
 /* change setting of characteristic */
diff --git a/drivers/s390/net/qeth_l3_sys.c b/drivers/s390/net/qeth_l3_sys.c
index 6143dd485810..f3986c6e21b9 100644
--- a/drivers/s390/net/qeth_l3_sys.c
+++ b/drivers/s390/net/qeth_l3_sys.c
@@ -32,26 +32,26 @@ static ssize_t qeth_l3_dev_route_show(struct qeth_card *card,
 {
 	switch (route->type) {
 	case PRIMARY_ROUTER:
-		return sprintf(buf, "%s\n", "primary router");
+		return sysfs_emit(buf, "%s\n", "primary router");
 	case SECONDARY_ROUTER:
-		return sprintf(buf, "%s\n", "secondary router");
+		return sysfs_emit(buf, "%s\n", "secondary router");
 	case MULTICAST_ROUTER:
 		if (card->info.broadcast_capable == QETH_BROADCAST_WITHOUT_ECHO)
-			return sprintf(buf, "%s\n", "multicast router+");
+			return sysfs_emit(buf, "%s\n", "multicast router+");
 		else
-			return sprintf(buf, "%s\n", "multicast router");
+			return sysfs_emit(buf, "%s\n", "multicast router");
 	case PRIMARY_CONNECTOR:
 		if (card->info.broadcast_capable == QETH_BROADCAST_WITHOUT_ECHO)
-			return sprintf(buf, "%s\n", "primary connector+");
+			return sysfs_emit(buf, "%s\n", "primary connector+");
 		else
-			return sprintf(buf, "%s\n", "primary connector");
+			return sysfs_emit(buf, "%s\n", "primary connector");
 	case SECONDARY_CONNECTOR:
 		if (card->info.broadcast_capable == QETH_BROADCAST_WITHOUT_ECHO)
-			return sprintf(buf, "%s\n", "secondary connector+");
+			return sysfs_emit(buf, "%s\n", "secondary connector+");
 		else
-			return sprintf(buf, "%s\n", "secondary connector");
+			return sysfs_emit(buf, "%s\n", "secondary connector");
 	default:
-		return sprintf(buf, "%s\n", "no");
+		return sysfs_emit(buf, "%s\n", "no");
 	}
 }
 
@@ -138,7 +138,7 @@ static ssize_t qeth_l3_dev_sniffer_show(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	return sprintf(buf, "%i\n", card->options.sniffer ? 1 : 0);
+	return sysfs_emit(buf, "%i\n", card->options.sniffer ? 1 : 0);
 }
 
 static ssize_t qeth_l3_dev_sniffer_store(struct device *dev,
@@ -200,7 +200,7 @@ static ssize_t qeth_l3_dev_hsuid_show(struct device *dev,
 
 	memcpy(tmp_hsuid, card->options.hsuid, sizeof(tmp_hsuid));
 	EBCASC(tmp_hsuid, 8);
-	return sprintf(buf, "%s\n", tmp_hsuid);
+	return sysfs_emit(buf, "%s\n", tmp_hsuid);
 }
 
 static ssize_t qeth_l3_dev_hsuid_store(struct device *dev,
@@ -285,7 +285,7 @@ static ssize_t qeth_l3_dev_ipato_enable_show(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	return sprintf(buf, "%u\n", card->ipato.enabled ? 1 : 0);
+	return sysfs_emit(buf, "%u\n", card->ipato.enabled ? 1 : 0);
 }
 
 static ssize_t qeth_l3_dev_ipato_enable_store(struct device *dev,
@@ -330,7 +330,7 @@ static ssize_t qeth_l3_dev_ipato_invert4_show(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	return sprintf(buf, "%u\n", card->ipato.invert4 ? 1 : 0);
+	return sysfs_emit(buf, "%u\n", card->ipato.invert4 ? 1 : 0);
 }
 
 static ssize_t qeth_l3_dev_ipato_invert4_store(struct device *dev,
@@ -367,35 +367,21 @@ static ssize_t qeth_l3_dev_ipato_add_show(char *buf, struct qeth_card *card,
 			enum qeth_prot_versions proto)
 {
 	struct qeth_ipato_entry *ipatoe;
-	int str_len = 0;
+	char addr_str[INET6_ADDRSTRLEN];
+	int offset = 0;
 
 	mutex_lock(&card->ip_lock);
 	list_for_each_entry(ipatoe, &card->ipato.entries, entry) {
-		char addr_str[INET6_ADDRSTRLEN];
-		int entry_len;
-
 		if (ipatoe->proto != proto)
 			continue;
 
-		entry_len = qeth_l3_ipaddr_to_string(proto, ipatoe->addr,
-						     addr_str);
-		if (entry_len < 0)
-			continue;
-
-		/* Append /%mask to the entry: */
-		entry_len += 1 + ((proto == QETH_PROT_IPV4) ? 2 : 3);
-		/* Enough room to format %entry\n into null terminated page? */
-		if (entry_len + 1 > PAGE_SIZE - str_len - 1)
-			break;
-
-		entry_len = scnprintf(buf, PAGE_SIZE - str_len,
-				      "%s/%i\n", addr_str, ipatoe->mask_bits);
-		str_len += entry_len;
-		buf += entry_len;
+		qeth_l3_ipaddr_to_string(proto, ipatoe->addr, addr_str);
+		offset += sysfs_emit_at(buf, offset, "%s/%i\n",
+					addr_str, ipatoe->mask_bits);
 	}
 	mutex_unlock(&card->ip_lock);
 
-	return str_len ? str_len : scnprintf(buf, PAGE_SIZE, "\n");
+	return offset ? offset : sysfs_emit(buf, "\n");
 }
 
 static ssize_t qeth_l3_dev_ipato_add4_show(struct device *dev,
@@ -501,7 +487,7 @@ static ssize_t qeth_l3_dev_ipato_invert6_show(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	return sprintf(buf, "%u\n", card->ipato.invert6 ? 1 : 0);
+	return sysfs_emit(buf, "%u\n", card->ipato.invert6 ? 1 : 0);
 }
 
 static ssize_t qeth_l3_dev_ipato_invert6_store(struct device *dev,
@@ -586,35 +572,22 @@ static ssize_t qeth_l3_dev_ip_add_show(struct device *dev, char *buf,
 				       enum qeth_ip_types type)
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
+	char addr_str[INET6_ADDRSTRLEN];
 	struct qeth_ipaddr *ipaddr;
-	int str_len = 0;
+	int offset = 0;
 	int i;
 
 	mutex_lock(&card->ip_lock);
 	hash_for_each(card->ip_htable, i, ipaddr, hnode) {
-		char addr_str[INET6_ADDRSTRLEN];
-		int entry_len;
-
 		if (ipaddr->proto != proto || ipaddr->type != type)
 			continue;
 
-		entry_len = qeth_l3_ipaddr_to_string(proto, (u8 *)&ipaddr->u,
-						     addr_str);
-		if (entry_len < 0)
-			continue;
-
-		/* Enough room to format %addr\n into null terminated page? */
-		if (entry_len + 1 > PAGE_SIZE - str_len - 1)
-			break;
-
-		entry_len = scnprintf(buf, PAGE_SIZE - str_len, "%s\n",
-				      addr_str);
-		str_len += entry_len;
-		buf += entry_len;
+		qeth_l3_ipaddr_to_string(proto, (u8 *)&ipaddr->u, addr_str);
+		offset += sysfs_emit_at(buf, offset, "%s\n", addr_str);
 	}
 	mutex_unlock(&card->ip_lock);
 
-	return str_len ? str_len : scnprintf(buf, PAGE_SIZE, "\n");
+	return offset ? offset : sysfs_emit(buf, "\n");
 }
 
 static ssize_t qeth_l3_dev_vipa_add4_show(struct device *dev,
-- 
2.37.2

