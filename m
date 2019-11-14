Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A70FFC3E5
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 11:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfKNKTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 05:19:43 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:12642 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726979AbfKNKTm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 05:19:42 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xAEAIQiR122111
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 05:19:39 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2w92hjwh30-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 05:19:38 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Thu, 14 Nov 2019 10:19:35 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 14 Nov 2019 10:19:33 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAEAJVlM29360370
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Nov 2019 10:19:31 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8CDDDA4057;
        Thu, 14 Nov 2019 10:19:31 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 42B03A405B;
        Thu, 14 Nov 2019 10:19:31 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 Nov 2019 10:19:31 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 11/11] s390/qeth: don't check drvdata in sysfs code
Date:   Thu, 14 Nov 2019 11:19:24 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191114101924.29558-1-jwi@linux.ibm.com>
References: <20191114101924.29558-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19111410-0020-0000-0000-000003861974
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111410-0021-0000-0000-000021DC2EE4
Message-Id: <20191114101924.29558-12-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-14_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911140095
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Given the way how the sysfs attributes are registered / unregistered,
the show/store helpers will never be called with a NULL drvdata.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core_sys.c | 80 ++-------------------------
 drivers/s390/net/qeth_l2_sys.c   | 29 ----------
 drivers/s390/net/qeth_l3_sys.c   | 94 --------------------------------
 3 files changed, 4 insertions(+), 199 deletions(-)

diff --git a/drivers/s390/net/qeth_core_sys.c b/drivers/s390/net/qeth_core_sys.c
index 9f392497d570..e81170ab6d9a 100644
--- a/drivers/s390/net/qeth_core_sys.c
+++ b/drivers/s390/net/qeth_core_sys.c
@@ -20,8 +20,6 @@ static ssize_t qeth_dev_state_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
-	if (!card)
-		return -EINVAL;
 
 	switch (card->state) {
 	case CARD_STATE_DOWN:
@@ -45,8 +43,6 @@ static ssize_t qeth_dev_chpid_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
-	if (!card)
-		return -EINVAL;
 
 	return sprintf(buf, "%02X\n", card->info.chpid);
 }
@@ -57,8 +53,7 @@ static ssize_t qeth_dev_if_name_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
-	if (!card)
-		return -EINVAL;
+
 	return sprintf(buf, "%s\n", QETH_CARD_IFNAME(card));
 }
 
@@ -68,8 +63,6 @@ static ssize_t qeth_dev_card_type_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
-	if (!card)
-		return -EINVAL;
 
 	return sprintf(buf, "%s\n", qeth_get_cardname_short(card));
 }
@@ -94,8 +87,6 @@ static ssize_t qeth_dev_inbuf_size_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
-	if (!card)
-		return -EINVAL;
 
 	return sprintf(buf, "%s\n", qeth_get_bufsize_str(card));
 }
@@ -106,8 +97,6 @@ static ssize_t qeth_dev_portno_show(struct device *dev,
 			struct device_attribute *attr, char *buf)
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
-	if (!card)
-		return -EINVAL;
 
 	return sprintf(buf, "%i\n", card->dev->dev_port);
 }
@@ -120,9 +109,6 @@ static ssize_t qeth_dev_portno_store(struct device *dev,
 	unsigned int portno, limit;
 	int rc = 0;
 
-	if (!card)
-		return -EINVAL;
-
 	mutex_lock(&card->conf_mutex);
 	if (card->state != CARD_STATE_DOWN) {
 		rc = -EPERM;
@@ -171,9 +157,6 @@ static ssize_t qeth_dev_prioqing_show(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	if (!card)
-		return -EINVAL;
-
 	switch (card->qdio.do_prio_queueing) {
 	case QETH_PRIO_Q_ING_PREC:
 		return sprintf(buf, "%s\n", "by precedence");
@@ -195,9 +178,6 @@ static ssize_t qeth_dev_prioqing_store(struct device *dev,
 	struct qeth_card *card = dev_get_drvdata(dev);
 	int rc = 0;
 
-	if (!card)
-		return -EINVAL;
-
 	if (IS_IQD(card))
 		return -EOPNOTSUPP;
 
@@ -262,9 +242,6 @@ static ssize_t qeth_dev_bufcnt_show(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	if (!card)
-		return -EINVAL;
-
 	return sprintf(buf, "%i\n", card->qdio.in_buf_pool.buf_count);
 }
 
@@ -276,9 +253,6 @@ static ssize_t qeth_dev_bufcnt_store(struct device *dev,
 	int cnt, old_cnt;
 	int rc = 0;
 
-	if (!card)
-		return -EINVAL;
-
 	mutex_lock(&card->conf_mutex);
 	if (card->state != CARD_STATE_DOWN) {
 		rc = -EPERM;
@@ -307,9 +281,6 @@ static ssize_t qeth_dev_recover_store(struct device *dev,
 	char *tmp;
 	int i;
 
-	if (!card)
-		return -EINVAL;
-
 	if (!qeth_card_hw_is_reachable(card))
 		return -EPERM;
 
@@ -325,11 +296,6 @@ static DEVICE_ATTR(recover, 0200, NULL, qeth_dev_recover_store);
 static ssize_t qeth_dev_performance_stats_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
-	struct qeth_card *card = dev_get_drvdata(dev);
-
-	if (!card)
-		return -EINVAL;
-
 	return sprintf(buf, "1\n");
 }
 
@@ -342,9 +308,6 @@ static ssize_t qeth_dev_performance_stats_store(struct device *dev,
 	bool reset;
 	int rc;
 
-	if (!card)
-		return -EINVAL;
-
 	rc = kstrtobool(buf, &reset);
 	if (rc)
 		return rc;
@@ -370,9 +333,6 @@ static ssize_t qeth_dev_layer2_show(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	if (!card)
-		return -EINVAL;
-
 	return sprintf(buf, "%i\n", card->options.layer);
 }
 
@@ -385,9 +345,6 @@ static ssize_t qeth_dev_layer2_store(struct device *dev,
 	int i, rc = 0;
 	enum qeth_discipline_id newdis;
 
-	if (!card)
-		return -EINVAL;
-
 	mutex_lock(&card->discipline_mutex);
 	if (card->state != CARD_STATE_DOWN) {
 		rc = -EPERM;
@@ -453,9 +410,6 @@ static ssize_t qeth_dev_isolation_show(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	if (!card)
-		return -EINVAL;
-
 	switch (card->options.isolation) {
 	case ISOLATION_MODE_NONE:
 		return snprintf(buf, 6, "%s\n", ATTR_QETH_ISOLATION_NONE);
@@ -475,9 +429,6 @@ static ssize_t qeth_dev_isolation_store(struct device *dev,
 	enum qeth_ipa_isolation_modes isolation;
 	int rc = 0;
 
-	if (!card)
-		return -EINVAL;
-
 	mutex_lock(&card->conf_mutex);
 	if (!IS_OSD(card) && !IS_OSX(card)) {
 		rc = -EOPNOTSUPP;
@@ -522,9 +473,6 @@ static ssize_t qeth_dev_switch_attrs_show(struct device *dev,
 	struct qeth_switch_info sw_info;
 	int	rc = 0;
 
-	if (!card)
-		return -EINVAL;
-
 	if (!qeth_card_hw_is_reachable(card))
 		return sprintf(buf, "n/a\n");
 
@@ -555,8 +503,6 @@ static ssize_t qeth_hw_trap_show(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	if (!card)
-		return -EINVAL;
 	if (card->info.hwtrap)
 		return snprintf(buf, 5, "arm\n");
 	else
@@ -570,9 +516,6 @@ static ssize_t qeth_hw_trap_store(struct device *dev,
 	int rc = 0;
 	int state = 0;
 
-	if (!card)
-		return -EINVAL;
-
 	mutex_lock(&card->conf_mutex);
 	if (qeth_card_hw_is_reachable(card))
 		state = 1;
@@ -607,24 +550,12 @@ static ssize_t qeth_hw_trap_store(struct device *dev,
 static DEVICE_ATTR(hw_trap, 0644, qeth_hw_trap_show,
 		   qeth_hw_trap_store);
 
-static ssize_t qeth_dev_blkt_show(char *buf, struct qeth_card *card, int value)
-{
-
-	if (!card)
-		return -EINVAL;
-
-	return sprintf(buf, "%i\n", value);
-}
-
 static ssize_t qeth_dev_blkt_store(struct qeth_card *card,
 		const char *buf, size_t count, int *value, int max_value)
 {
 	char *tmp;
 	int i, rc = 0;
 
-	if (!card)
-		return -EINVAL;
-
 	mutex_lock(&card->conf_mutex);
 	if (card->state != CARD_STATE_DOWN) {
 		rc = -EPERM;
@@ -645,7 +576,7 @@ static ssize_t qeth_dev_blkt_total_show(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	return qeth_dev_blkt_show(buf, card, card->info.blkt.time_total);
+	return sprintf(buf, "%i\n", card->info.blkt.time_total);
 }
 
 static ssize_t qeth_dev_blkt_total_store(struct device *dev,
@@ -657,8 +588,6 @@ static ssize_t qeth_dev_blkt_total_store(struct device *dev,
 				   &card->info.blkt.time_total, 5000);
 }
 
-
-
 static DEVICE_ATTR(total, 0644, qeth_dev_blkt_total_show,
 		   qeth_dev_blkt_total_store);
 
@@ -667,7 +596,7 @@ static ssize_t qeth_dev_blkt_inter_show(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	return qeth_dev_blkt_show(buf, card, card->info.blkt.inter_packet);
+	return sprintf(buf, "%i\n", card->info.blkt.inter_packet);
 }
 
 static ssize_t qeth_dev_blkt_inter_store(struct device *dev,
@@ -687,8 +616,7 @@ static ssize_t qeth_dev_blkt_inter_jumbo_show(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	return qeth_dev_blkt_show(buf, card,
-				  card->info.blkt.inter_packet_jumbo);
+	return sprintf(buf, "%i\n", card->info.blkt.inter_packet_jumbo);
 }
 
 static ssize_t qeth_dev_blkt_inter_jumbo_store(struct device *dev,
diff --git a/drivers/s390/net/qeth_l2_sys.c b/drivers/s390/net/qeth_l2_sys.c
index f2c3b127b1e4..d9af5fe040be 100644
--- a/drivers/s390/net/qeth_l2_sys.c
+++ b/drivers/s390/net/qeth_l2_sys.c
@@ -18,9 +18,6 @@ static ssize_t qeth_bridge_port_role_state_show(struct device *dev,
 	int rc = 0;
 	char *word;
 
-	if (!card)
-		return -EINVAL;
-
 	if (qeth_l2_vnicc_is_in_use(card))
 		return sprintf(buf, "n/a (VNIC characteristics)\n");
 
@@ -79,8 +76,6 @@ static ssize_t qeth_bridge_port_role_store(struct device *dev,
 	int rc = 0;
 	enum qeth_sbp_roles role;
 
-	if (!card)
-		return -EINVAL;
 	if (sysfs_streq(buf, "primary"))
 		role = QETH_SBP_ROLE_PRIMARY;
 	else if (sysfs_streq(buf, "secondary"))
@@ -132,9 +127,6 @@ static ssize_t qeth_bridgeport_hostnotification_show(struct device *dev,
 	struct qeth_card *card = dev_get_drvdata(dev);
 	int enabled;
 
-	if (!card)
-		return -EINVAL;
-
 	if (qeth_l2_vnicc_is_in_use(card))
 		return sprintf(buf, "n/a (VNIC characteristics)\n");
 
@@ -150,9 +142,6 @@ static ssize_t qeth_bridgeport_hostnotification_store(struct device *dev,
 	bool enable;
 	int rc;
 
-	if (!card)
-		return -EINVAL;
-
 	rc = kstrtobool(buf, &enable);
 	if (rc)
 		return rc;
@@ -183,9 +172,6 @@ static ssize_t qeth_bridgeport_reflect_show(struct device *dev,
 	struct qeth_card *card = dev_get_drvdata(dev);
 	char *state;
 
-	if (!card)
-		return -EINVAL;
-
 	if (qeth_l2_vnicc_is_in_use(card))
 		return sprintf(buf, "n/a (VNIC characteristics)\n");
 
@@ -207,9 +193,6 @@ static ssize_t qeth_bridgeport_reflect_store(struct device *dev,
 	int enable, primary;
 	int rc = 0;
 
-	if (!card)
-		return -EINVAL;
-
 	if (sysfs_streq(buf, "none")) {
 		enable = 0;
 		primary = 0;
@@ -315,9 +298,6 @@ static ssize_t qeth_vnicc_timeout_show(struct device *dev,
 	u32 timeout;
 	int rc;
 
-	if (!card)
-		return -EINVAL;
-
 	rc = qeth_l2_vnicc_get_timeout(card, &timeout);
 	if (rc == -EBUSY)
 		return sprintf(buf, "n/a (BridgePort)\n");
@@ -335,9 +315,6 @@ static ssize_t qeth_vnicc_timeout_store(struct device *dev,
 	u32 timeout;
 	int rc;
 
-	if (!card)
-		return -EINVAL;
-
 	rc = kstrtou32(buf, 10, &timeout);
 	if (rc)
 		return rc;
@@ -357,9 +334,6 @@ static ssize_t qeth_vnicc_char_show(struct device *dev,
 	u32 vnicc;
 	int rc;
 
-	if (!card)
-		return -EINVAL;
-
 	vnicc = qeth_l2_vnicc_sysfs_attr_to_char(attr->attr.name);
 	rc = qeth_l2_vnicc_get_state(card, vnicc, &state);
 
@@ -380,9 +354,6 @@ static ssize_t qeth_vnicc_char_store(struct device *dev,
 	u32 vnicc;
 	int rc;
 
-	if (!card)
-		return -EINVAL;
-
 	if (kstrtobool(buf, &state))
 		return -EINVAL;
 
diff --git a/drivers/s390/net/qeth_l3_sys.c b/drivers/s390/net/qeth_l3_sys.c
index 2f73b33c9347..b6b38b69a5f4 100644
--- a/drivers/s390/net/qeth_l3_sys.c
+++ b/drivers/s390/net/qeth_l3_sys.c
@@ -60,9 +60,6 @@ static ssize_t qeth_l3_dev_route4_show(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	if (!card)
-		return -EINVAL;
-
 	return qeth_l3_dev_route_show(card, &card->options.route4, buf);
 }
 
@@ -109,9 +106,6 @@ static ssize_t qeth_l3_dev_route4_store(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	if (!card)
-		return -EINVAL;
-
 	return qeth_l3_dev_route_store(card, &card->options.route4,
 				QETH_PROT_IPV4, buf, count);
 }
@@ -124,9 +118,6 @@ static ssize_t qeth_l3_dev_route6_show(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	if (!card)
-		return -EINVAL;
-
 	return qeth_l3_dev_route_show(card, &card->options.route6, buf);
 }
 
@@ -135,9 +126,6 @@ static ssize_t qeth_l3_dev_route6_store(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	if (!card)
-		return -EINVAL;
-
 	return qeth_l3_dev_route_store(card, &card->options.route6,
 				QETH_PROT_IPV6, buf, count);
 }
@@ -150,9 +138,6 @@ static ssize_t qeth_l3_dev_fake_broadcast_show(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	if (!card)
-		return -EINVAL;
-
 	return sprintf(buf, "%i\n", card->options.fake_broadcast? 1:0);
 }
 
@@ -163,9 +148,6 @@ static ssize_t qeth_l3_dev_fake_broadcast_store(struct device *dev,
 	char *tmp;
 	int i, rc = 0;
 
-	if (!card)
-		return -EINVAL;
-
 	mutex_lock(&card->conf_mutex);
 	if (card->state != CARD_STATE_DOWN) {
 		rc = -EPERM;
@@ -190,9 +172,6 @@ static ssize_t qeth_l3_dev_sniffer_show(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	if (!card)
-		return -EINVAL;
-
 	return sprintf(buf, "%i\n", card->options.sniffer ? 1 : 0);
 }
 
@@ -203,9 +182,6 @@ static ssize_t qeth_l3_dev_sniffer_store(struct device *dev,
 	int rc = 0;
 	unsigned long i;
 
-	if (!card)
-		return -EINVAL;
-
 	if (!IS_IQD(card))
 		return -EPERM;
 	if (card->options.cq == QETH_CQ_ENABLED)
@@ -248,16 +224,12 @@ static ssize_t qeth_l3_dev_sniffer_store(struct device *dev,
 static DEVICE_ATTR(sniffer, 0644, qeth_l3_dev_sniffer_show,
 		qeth_l3_dev_sniffer_store);
 
-
 static ssize_t qeth_l3_dev_hsuid_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 	char tmp_hsuid[9];
 
-	if (!card)
-		return -EINVAL;
-
 	if (!IS_IQD(card))
 		return -EPERM;
 
@@ -273,9 +245,6 @@ static ssize_t qeth_l3_dev_hsuid_store(struct device *dev,
 	char *tmp;
 	int rc;
 
-	if (!card)
-		return -EINVAL;
-
 	if (!IS_IQD(card))
 		return -EPERM;
 	if (card->state != CARD_STATE_DOWN)
@@ -336,9 +305,6 @@ static ssize_t qeth_l3_dev_ipato_enable_show(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	if (!card)
-		return -EINVAL;
-
 	return sprintf(buf, "%i\n", card->ipato.enabled? 1:0);
 }
 
@@ -349,9 +315,6 @@ static ssize_t qeth_l3_dev_ipato_enable_store(struct device *dev,
 	bool enable;
 	int rc = 0;
 
-	if (!card)
-		return -EINVAL;
-
 	mutex_lock(&card->conf_mutex);
 	if (card->state != CARD_STATE_DOWN) {
 		rc = -EPERM;
@@ -385,9 +348,6 @@ static ssize_t qeth_l3_dev_ipato_invert4_show(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	if (!card)
-		return -EINVAL;
-
 	return sprintf(buf, "%i\n", card->ipato.invert4? 1:0);
 }
 
@@ -399,9 +359,6 @@ static ssize_t qeth_l3_dev_ipato_invert4_store(struct device *dev,
 	bool invert;
 	int rc = 0;
 
-	if (!card)
-		return -EINVAL;
-
 	mutex_lock(&card->conf_mutex);
 	if (sysfs_streq(buf, "toggle")) {
 		invert = !card->ipato.invert4;
@@ -460,9 +417,6 @@ static ssize_t qeth_l3_dev_ipato_add4_show(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	if (!card)
-		return -EINVAL;
-
 	return qeth_l3_dev_ipato_add_show(buf, card, QETH_PROT_IPV4);
 }
 
@@ -528,9 +482,6 @@ static ssize_t qeth_l3_dev_ipato_add4_store(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	if (!card)
-		return -EINVAL;
-
 	return qeth_l3_dev_ipato_add_store(buf, count, card, QETH_PROT_IPV4);
 }
 
@@ -558,9 +509,6 @@ static ssize_t qeth_l3_dev_ipato_del4_store(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	if (!card)
-		return -EINVAL;
-
 	return qeth_l3_dev_ipato_del_store(buf, count, card, QETH_PROT_IPV4);
 }
 
@@ -572,9 +520,6 @@ static ssize_t qeth_l3_dev_ipato_invert6_show(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	if (!card)
-		return -EINVAL;
-
 	return sprintf(buf, "%i\n", card->ipato.invert6? 1:0);
 }
 
@@ -585,9 +530,6 @@ static ssize_t qeth_l3_dev_ipato_invert6_store(struct device *dev,
 	bool invert;
 	int rc = 0;
 
-	if (!card)
-		return -EINVAL;
-
 	mutex_lock(&card->conf_mutex);
 	if (sysfs_streq(buf, "toggle")) {
 		invert = !card->ipato.invert6;
@@ -617,9 +559,6 @@ static ssize_t qeth_l3_dev_ipato_add6_show(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	if (!card)
-		return -EINVAL;
-
 	return qeth_l3_dev_ipato_add_show(buf, card, QETH_PROT_IPV6);
 }
 
@@ -628,9 +567,6 @@ static ssize_t qeth_l3_dev_ipato_add6_store(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	if (!card)
-		return -EINVAL;
-
 	return qeth_l3_dev_ipato_add_store(buf, count, card, QETH_PROT_IPV6);
 }
 
@@ -643,9 +579,6 @@ static ssize_t qeth_l3_dev_ipato_del6_store(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	if (!card)
-		return -EINVAL;
-
 	return qeth_l3_dev_ipato_del_store(buf, count, card, QETH_PROT_IPV6);
 }
 
@@ -679,9 +612,6 @@ static ssize_t qeth_l3_dev_ip_add_show(struct device *dev, char *buf,
 	int entry_len; /* length of 1 entry string, differs between v4 and v6 */
 	int i;
 
-	if (!card)
-		return -EINVAL;
-
 	entry_len = (proto == QETH_PROT_IPV4)? 12 : 40;
 	entry_len += 2; /* \n + terminator */
 	mutex_lock(&card->ip_lock);
@@ -741,9 +671,6 @@ static ssize_t qeth_l3_dev_vipa_add4_store(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	if (!card)
-		return -EINVAL;
-
 	return qeth_l3_dev_vipa_add_store(buf, count, card, QETH_PROT_IPV4);
 }
 
@@ -771,9 +698,6 @@ static ssize_t qeth_l3_dev_vipa_del4_store(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	if (!card)
-		return -EINVAL;
-
 	return qeth_l3_dev_vipa_del_store(buf, count, card, QETH_PROT_IPV4);
 }
 
@@ -793,9 +717,6 @@ static ssize_t qeth_l3_dev_vipa_add6_store(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	if (!card)
-		return -EINVAL;
-
 	return qeth_l3_dev_vipa_add_store(buf, count, card, QETH_PROT_IPV6);
 }
 
@@ -808,9 +729,6 @@ static ssize_t qeth_l3_dev_vipa_del6_store(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	if (!card)
-		return -EINVAL;
-
 	return qeth_l3_dev_vipa_del_store(buf, count, card, QETH_PROT_IPV6);
 }
 
@@ -884,9 +802,6 @@ static ssize_t qeth_l3_dev_rxip_add4_store(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	if (!card)
-		return -EINVAL;
-
 	return qeth_l3_dev_rxip_add_store(buf, count, card, QETH_PROT_IPV4);
 }
 
@@ -914,9 +829,6 @@ static ssize_t qeth_l3_dev_rxip_del4_store(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	if (!card)
-		return -EINVAL;
-
 	return qeth_l3_dev_rxip_del_store(buf, count, card, QETH_PROT_IPV4);
 }
 
@@ -936,9 +848,6 @@ static ssize_t qeth_l3_dev_rxip_add6_store(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	if (!card)
-		return -EINVAL;
-
 	return qeth_l3_dev_rxip_add_store(buf, count, card, QETH_PROT_IPV6);
 }
 
@@ -951,9 +860,6 @@ static ssize_t qeth_l3_dev_rxip_del6_store(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	if (!card)
-		return -EINVAL;
-
 	return qeth_l3_dev_rxip_del_store(buf, count, card, QETH_PROT_IPV6);
 }
 
-- 
2.17.1

