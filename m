Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 210D825407A
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 10:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728061AbgH0IR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 04:17:27 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:25280 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727961AbgH0IRS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 04:17:18 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07R8DYxB145739;
        Thu, 27 Aug 2020 04:17:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=9ZcU1ShPl4SUV2eWwc7DV5JrxiWKBtRYjznLjYAZmzw=;
 b=Ac+jF/omRGxviU71BOjUULViFh1Pxp1NHIFYto+gQsflZvw9eT9bLUK+/hElAp2DI73y
 MbqKgViydr3+v5U4MFT6c5vu1N1GpbX5S8QRltGBfcQObBfAcaggqSEImEYv3ji+Kx0r
 MmP8CFnDDb7g+oQbVz9RAIwYQ4JmfOtN4IjJ6WkQOam8yMKCJvT5cl1vjcyez60H0HCd
 mcI1G+M623UlKnD9+2cJPEZXAGxT4Nh0JNOxjdk5HqJbkUYOuMDUyMRGWwclI50hPzUj
 Lgzka1fxxXvwl+OC9JEWQaYHOBLhWlKIDRu9sLpBtwaQz48W6ZVNyoEvJWgOqiLk3RpD zQ== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33694e03c1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Aug 2020 04:17:14 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07R8CbLg017066;
        Thu, 27 Aug 2020 08:17:13 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 332uk6den3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Aug 2020 08:17:13 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07R8HA5l62718354
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Aug 2020 08:17:10 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E8A94C04A;
        Thu, 27 Aug 2020 08:17:10 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 045AE4C059;
        Thu, 27 Aug 2020 08:17:10 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 27 Aug 2020 08:17:09 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 7/8] s390/qeth: unify structs for bridge port state
Date:   Thu, 27 Aug 2020 10:17:04 +0200
Message-Id: <20200827081705.21922-8-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200827081705.21922-1-jwi@linux.ibm.com>
References: <20200827081705.21922-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-27_02:2020-08-27,2020-08-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 phishscore=0 spamscore=0 priorityscore=1501 adultscore=0 impostorscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008270057
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The data returned from IPA_SBP_QUERY_BRIDGE_PORTS and
IPA_SBP_BRIDGE_PORT_STATE_CHANGE has the same format. Use a single
struct definition for it.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
---
 drivers/s390/net/qeth_core_mpc.h | 14 +++-----------
 drivers/s390/net/qeth_l2_main.c  |  6 +++---
 2 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/s390/net/qeth_core_mpc.h b/drivers/s390/net/qeth_core_mpc.h
index b459def0fb26..6541bab96822 100644
--- a/drivers/s390/net/qeth_core_mpc.h
+++ b/drivers/s390/net/qeth_core_mpc.h
@@ -719,15 +719,8 @@ struct qeth_sbp_port_entry {
 		struct net_if_token token;
 } __packed;
 
-struct qeth_sbp_query_ports {
-	__u8 primary_bp_supported;
-	__u8 secondary_bp_supported;
-	__u8 num_entries;
-	__u8 entry_length;
-	struct qeth_sbp_port_entry entry[];
-} __packed;
-
-struct qeth_sbp_state_change {
+/* For IPA_SBP_QUERY_BRIDGE_PORTS, IPA_SBP_BRIDGE_PORT_STATE_CHANGE */
+struct qeth_sbp_port_data {
 	__u8 primary_bp_supported;
 	__u8 secondary_bp_supported;
 	__u8 num_entries;
@@ -741,8 +734,7 @@ struct qeth_ipacmd_setbridgeport {
 	union {
 		struct qeth_sbp_query_cmds_supp query_cmds_supp;
 		struct qeth_sbp_set_primary set_primary;
-		struct qeth_sbp_query_ports query_ports;
-		struct qeth_sbp_state_change state_change;
+		struct qeth_sbp_port_data port_data;
 	} data;
 } __packed;
 
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index d96636369b4c..1e3d64ab5e46 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -1125,8 +1125,7 @@ static void qeth_bridge_state_change_worker(struct work_struct *work)
 static void qeth_bridge_state_change(struct qeth_card *card,
 					struct qeth_ipa_cmd *cmd)
 {
-	struct qeth_sbp_state_change *qports =
-		 &cmd->data.sbp.data.state_change;
+	struct qeth_sbp_port_data *qports = &cmd->data.sbp.data.port_data;
 	struct qeth_bridge_state_data *data;
 
 	QETH_CARD_TEXT(card, 2, "brstchng");
@@ -1409,8 +1408,8 @@ static int qeth_bridgeport_query_ports_cb(struct qeth_card *card,
 	struct qeth_reply *reply, unsigned long data)
 {
 	struct qeth_ipa_cmd *cmd = (struct qeth_ipa_cmd *) data;
-	struct qeth_sbp_query_ports *qports = &cmd->data.sbp.data.query_ports;
 	struct _qeth_sbp_cbctl *cbctl = (struct _qeth_sbp_cbctl *)reply->param;
+	struct qeth_sbp_port_data *qports;
 	int rc;
 
 	QETH_CARD_TEXT(card, 2, "brqprtcb");
@@ -1418,6 +1417,7 @@ static int qeth_bridgeport_query_ports_cb(struct qeth_card *card,
 	if (rc)
 		return rc;
 
+	qports = &cmd->data.sbp.data.port_data;
 	if (qports->entry_length != sizeof(struct qeth_sbp_port_entry)) {
 		QETH_CARD_TEXT_(card, 2, "SBPs%04x", qports->entry_length);
 		return -EINVAL;
-- 
2.17.1

