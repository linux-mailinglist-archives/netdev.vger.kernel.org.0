Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC060124DD1
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 17:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727577AbfLRQfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 11:35:05 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:7962 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727533AbfLRQfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 11:35:00 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBIGYoWM091773
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 11:34:59 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2wym9r0g2t-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 11:34:59 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Wed, 18 Dec 2019 16:34:57 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 18 Dec 2019 16:34:54 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBIGYr5u46530794
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 16:34:53 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4E179A4055;
        Wed, 18 Dec 2019 16:34:53 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0DE54A4051;
        Wed, 18 Dec 2019 16:34:53 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 18 Dec 2019 16:34:52 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 5/9] s390/qeth: remove open-coded inet_make_mask()
Date:   Wed, 18 Dec 2019 17:34:46 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191218163450.36731-1-jwi@linux.ibm.com>
References: <20191218163450.36731-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19121816-0020-0000-0000-00000399938B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19121816-0021-0000-0000-000021F0B767
Message-Id: <20191218163450.36731-6-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-18_05:2019-12-17,2019-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 impostorscore=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 bulkscore=0 spamscore=0 clxscore=1015 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912180136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use inet_make_mask() to replace some complicated bit-fiddling.

Also use the right data types to replace some raw memcpy calls with
proper assignments.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core_mpc.h |  8 ++++----
 drivers/s390/net/qeth_l3.h       |  2 +-
 drivers/s390/net/qeth_l3_main.c  | 34 ++++++++++++++------------------
 3 files changed, 20 insertions(+), 24 deletions(-)

diff --git a/drivers/s390/net/qeth_core_mpc.h b/drivers/s390/net/qeth_core_mpc.h
index 88f4dc140751..f13225b43781 100644
--- a/drivers/s390/net/qeth_core_mpc.h
+++ b/drivers/s390/net/qeth_core_mpc.h
@@ -338,14 +338,14 @@ enum qeth_card_info_port_speed {
 
 /* (SET)DELIP(M) IPA stuff ***************************************************/
 struct qeth_ipacmd_setdelip4 {
-	__u8   ip_addr[4];
-	__u8   mask[4];
+	__be32 addr;
+	__be32 mask;
 	__u32  flags;
 } __attribute__ ((packed));
 
 struct qeth_ipacmd_setdelip6 {
-	__u8   ip_addr[16];
-	__u8   mask[16];
+	struct in6_addr addr;
+	struct in6_addr prefix;
 	__u32  flags;
 } __attribute__ ((packed));
 
diff --git a/drivers/s390/net/qeth_l3.h b/drivers/s390/net/qeth_l3.h
index 2383ffad0a4a..89fb91dad12e 100644
--- a/drivers/s390/net/qeth_l3.h
+++ b/drivers/s390/net/qeth_l3.h
@@ -35,7 +35,7 @@ struct qeth_ipaddr {
 	union {
 		struct {
 			__be32 addr;
-			unsigned int mask;
+			__be32 mask;
 		} a4;
 		struct {
 			struct in6_addr addr;
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 8db548340632..bd2273f9ca35 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -369,17 +369,16 @@ static int qeth_l3_send_setdelmc(struct qeth_card *card,
 	return qeth_send_ipa_cmd(card, iob, qeth_l3_setdelip_cb, NULL);
 }
 
-static void qeth_l3_fill_netmask(u8 *netmask, unsigned int len)
+static void qeth_l3_set_ipv6_prefix(struct in6_addr *prefix, unsigned int len)
 {
-	int i, j;
-	for (i = 0; i < 16; i++) {
-		j = (len) - (i * 8);
-		if (j >= 8)
-			netmask[i] = 0xff;
-		else if (j > 0)
-			netmask[i] = (u8)(0xFF00 >> j);
-		else
-			netmask[i] = 0;
+	unsigned int i = 0;
+
+	while (len && i < 4) {
+		int mask_len = min_t(int, len, 32);
+
+		prefix->s6_addr32[i] = inet_make_mask(mask_len);
+		len -= mask_len;
+		i++;
 	}
 }
 
@@ -402,7 +401,6 @@ static int qeth_l3_send_setdelip(struct qeth_card *card,
 {
 	struct qeth_cmd_buffer *iob;
 	struct qeth_ipa_cmd *cmd;
-	__u8 netmask[16];
 	u32 flags;
 
 	QETH_CARD_TEXT(card, 4, "setdelip");
@@ -417,15 +415,13 @@ static int qeth_l3_send_setdelip(struct qeth_card *card,
 	QETH_CARD_TEXT_(card, 4, "flags%02X", flags);
 
 	if (addr->proto == QETH_PROT_IPV6) {
-		memcpy(cmd->data.setdelip6.ip_addr, &addr->u.a6.addr,
-		       sizeof(struct in6_addr));
-		qeth_l3_fill_netmask(netmask, addr->u.a6.pfxlen);
-		memcpy(cmd->data.setdelip6.mask, netmask,
-		       sizeof(struct in6_addr));
+		cmd->data.setdelip6.addr = addr->u.a6.addr;
+		qeth_l3_set_ipv6_prefix(&cmd->data.setdelip6.prefix,
+					addr->u.a6.pfxlen);
 		cmd->data.setdelip6.flags = flags;
 	} else {
-		memcpy(cmd->data.setdelip4.ip_addr, &addr->u.a4.addr, 4);
-		memcpy(cmd->data.setdelip4.mask, &addr->u.a4.mask, 4);
+		cmd->data.setdelip4.addr = addr->u.a4.addr;
+		cmd->data.setdelip4.mask = addr->u.a4.mask;
 		cmd->data.setdelip4.flags = flags;
 	}
 
@@ -2436,7 +2432,7 @@ static int qeth_l3_ip_event(struct notifier_block *this,
 
 	qeth_l3_init_ipaddr(&addr, QETH_IP_TYPE_NORMAL, QETH_PROT_IPV4);
 	addr.u.a4.addr = ifa->ifa_address;
-	addr.u.a4.mask = be32_to_cpu(ifa->ifa_mask);
+	addr.u.a4.mask = ifa->ifa_mask;
 
 	return qeth_l3_handle_ip_event(card, &addr, event);
 }
-- 
2.17.1

