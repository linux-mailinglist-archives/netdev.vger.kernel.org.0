Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D05817249C
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 18:09:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729945AbgB0RIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 12:08:31 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52260 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729880AbgB0RIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 12:08:30 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01RH6QL1043850
        for <netdev@vger.kernel.org>; Thu, 27 Feb 2020 12:08:30 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ydcp68sdr-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 27 Feb 2020 12:08:28 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Thu, 27 Feb 2020 17:08:26 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 27 Feb 2020 17:08:24 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01RH8Mik51314780
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 17:08:22 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D211FA4054;
        Thu, 27 Feb 2020 17:08:22 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 99329A405B;
        Thu, 27 Feb 2020 17:08:22 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 27 Feb 2020 17:08:22 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 2/8] s390/qeth: clean up CREATE_ADDR cmd code
Date:   Thu, 27 Feb 2020 18:08:10 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200227170816.101286-1-jwi@linux.ibm.com>
References: <20200227170816.101286-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20022717-0008-0000-0000-0000035709A8
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20022717-0009-0000-0000-00004A782C8C
Message-Id: <20200227170816.101286-3-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-27_05:2020-02-26,2020-02-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 adultscore=0 bulkscore=0 mlxscore=0 phishscore=0 impostorscore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002270126
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Properly define the cmd's struct to get rid of some casts and accesses
at magic offsets.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
---
 drivers/s390/net/qeth_core_mpc.h |  5 +++--
 drivers/s390/net/qeth_l3_main.c  | 10 +++-------
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/s390/net/qeth_core_mpc.h b/drivers/s390/net/qeth_core_mpc.h
index 3865f7258449..3a3cebdaf948 100644
--- a/drivers/s390/net/qeth_core_mpc.h
+++ b/drivers/s390/net/qeth_core_mpc.h
@@ -550,8 +550,9 @@ struct qeth_ipacmd_setadpparms {
 
 /* CREATE_ADDR IPA Command:    ***********************************************/
 struct qeth_create_destroy_address {
-	__u8 unique_id[8];
-} __attribute__ ((packed));
+	u8 mac_addr[ETH_ALEN];
+	u16 uid;
+};
 
 /* SET DIAGNOSTIC ASSIST IPA Command:	 *************************************/
 
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 1c953981f73f..667a10d6495d 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -922,7 +922,7 @@ static int qeth_l3_iqd_read_initial_mac_cb(struct qeth_card *card,
 		return -EIO;
 
 	ether_addr_copy(card->dev->dev_addr,
-			cmd->data.create_destroy_addr.unique_id);
+			cmd->data.create_destroy_addr.mac_addr);
 	return 0;
 }
 
@@ -949,8 +949,7 @@ static int qeth_l3_get_unique_id_cb(struct qeth_card *card,
 	struct qeth_ipa_cmd *cmd = (struct qeth_ipa_cmd *) data;
 
 	if (cmd->hdr.return_code == 0) {
-		card->info.unique_id = *((__u16 *)
-				&cmd->data.create_destroy_addr.unique_id[6]);
+		card->info.unique_id = cmd->data.create_destroy_addr.uid;
 		return 0;
 	}
 
@@ -964,7 +963,6 @@ static int qeth_l3_get_unique_id(struct qeth_card *card)
 {
 	int rc = 0;
 	struct qeth_cmd_buffer *iob;
-	struct qeth_ipa_cmd *cmd;
 
 	QETH_CARD_TEXT(card, 2, "guniqeid");
 
@@ -978,10 +976,8 @@ static int qeth_l3_get_unique_id(struct qeth_card *card)
 				 IPA_DATA_SIZEOF(create_destroy_addr));
 	if (!iob)
 		return -ENOMEM;
-	cmd = __ipa_cmd(iob);
-	*((__u16 *) &cmd->data.create_destroy_addr.unique_id[6]) =
-			card->info.unique_id;
 
+	__ipa_cmd(iob)->data.create_destroy_addr.uid = card->info.unique_id;
 	rc = qeth_send_ipa_cmd(card, iob, qeth_l3_get_unique_id_cb, NULL);
 	return rc;
 }
-- 
2.17.1

