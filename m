Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4201918F4
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 19:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbgCXSZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 14:25:03 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:7364 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727769AbgCXSZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 14:25:02 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02OI3GSN127665
        for <netdev@vger.kernel.org>; Tue, 24 Mar 2020 14:25:02 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ywd2scs5n-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 24 Mar 2020 14:25:01 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Tue, 24 Mar 2020 18:24:57 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 24 Mar 2020 18:24:55 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02OIOuKv22020098
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Mar 2020 18:24:56 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7BF7CA4054;
        Tue, 24 Mar 2020 18:24:56 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 44BE8A4064;
        Tue, 24 Mar 2020 18:24:56 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 24 Mar 2020 18:24:56 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 06/11] s390/qeth: clean up the mac_bits
Date:   Tue, 24 Mar 2020 19:24:43 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200324182448.95362-1-jwi@linux.ibm.com>
References: <20200324182448.95362-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20032418-4275-0000-0000-000003B24527
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20032418-4276-0000-0000-000038C77FF0
Message-Id: <20200324182448.95362-7-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-24_05:2020-03-23,2020-03-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0
 priorityscore=1501 malwarescore=0 phishscore=0 mlxlogscore=999 bulkscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003240090
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We're down to a single bit flag for MAC-address related status, reflect
that in the info struct.
Also set up the flag during initialization instead of clearing it during
shutdown - one more little step towards unifying the shutdown code.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h    |  3 +--
 drivers/s390/net/qeth_l2_main.c | 13 +++++++------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 257b7f3c5558..911dcef6adc6 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -668,18 +668,17 @@ struct qeth_card_blkt {
 
 #define QETH_BROADCAST_WITH_ECHO    0x01
 #define QETH_BROADCAST_WITHOUT_ECHO 0x02
-#define QETH_LAYER2_MAC_REGISTERED  0x02
 struct qeth_card_info {
 	unsigned short unit_addr2;
 	unsigned short cula;
 	u8 chpid;
 	__u16 func_level;
 	char mcl_level[QETH_MCL_LENGTH + 1];
+	u8 dev_addr_is_registered:1;
 	u8 open_when_online:1;
 	u8 promisc_mode:1;
 	u8 use_v1_blkt:1;
 	u8 is_vm_nic:1;
-	int mac_bits;
 	enum qeth_card_types type;
 	enum qeth_link_types link_type;
 	int broadcast_capable;
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 73cb363b1fab..249b00d91d46 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -291,7 +291,6 @@ static void qeth_l2_stop_card(struct qeth_card *card)
 	qeth_qdio_clear_card(card, 0);
 	qeth_clear_working_pool_list(card);
 	flush_workqueue(card->event_wq);
-	card->info.mac_bits &= ~QETH_LAYER2_MAC_REGISTERED;
 	card->info.promisc_mode = 0;
 }
 
@@ -337,14 +336,16 @@ static void qeth_l2_register_dev_addr(struct qeth_card *card)
 		qeth_l2_request_initial_mac(card);
 
 	if (!IS_OSN(card) && !qeth_l2_send_setmac(card, card->dev->dev_addr))
-		card->info.mac_bits |= QETH_LAYER2_MAC_REGISTERED;
+		card->info.dev_addr_is_registered = 1;
+	else
+		card->info.dev_addr_is_registered = 0;
 }
 
 static int qeth_l2_validate_addr(struct net_device *dev)
 {
 	struct qeth_card *card = dev->ml_priv;
 
-	if (card->info.mac_bits & QETH_LAYER2_MAC_REGISTERED)
+	if (card->info.dev_addr_is_registered)
 		return eth_validate_addr(dev);
 
 	QETH_CARD_TEXT(card, 4, "nomacadr");
@@ -370,7 +371,7 @@ static int qeth_l2_set_mac_address(struct net_device *dev, void *p)
 
 	/* don't register the same address twice */
 	if (ether_addr_equal_64bits(dev->dev_addr, addr->sa_data) &&
-	    (card->info.mac_bits & QETH_LAYER2_MAC_REGISTERED))
+	    card->info.dev_addr_is_registered)
 		return 0;
 
 	/* add the new address, switch over, drop the old */
@@ -380,9 +381,9 @@ static int qeth_l2_set_mac_address(struct net_device *dev, void *p)
 	ether_addr_copy(old_addr, dev->dev_addr);
 	ether_addr_copy(dev->dev_addr, addr->sa_data);
 
-	if (card->info.mac_bits & QETH_LAYER2_MAC_REGISTERED)
+	if (card->info.dev_addr_is_registered)
 		qeth_l2_remove_mac(card, old_addr);
-	card->info.mac_bits |= QETH_LAYER2_MAC_REGISTERED;
+	card->info.dev_addr_is_registered = 1;
 	return 0;
 }
 
-- 
2.17.1

