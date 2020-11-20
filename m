Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 230532BA58C
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 10:11:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgKTJJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 04:09:56 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5274 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726739AbgKTJJv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 04:09:51 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AK92EYZ040358;
        Fri, 20 Nov 2020 04:09:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=UnmTuI3E5dumnNGDlNB3vRf2srBC4V3/wv0U7JufAcQ=;
 b=sjArgLyQdSVOop16gcGhUeiniOLVTUPupUOU56cjMxvU17KvDKNbkeoJQUZuEcUOx7Rm
 179+mWAjYOboWRyzj1VzuQ+fI0hInepCvJudeCyqeMmQdLCnJ9RAZmGOEI3wqOuECgVt
 FX6YiEfAVTvi6TuaqXn8XQb6+aDz+a5kntUAwUG3CMu7Tt0dPoOO1Lw8/S16RA0RUu9q
 Rtt77XGQsdia4dcTKQCdhHMNZQdoByXQPh4BLO8CQwbOzftvOccexqDe7WWALq1skEaQ
 /sh71YHmEv+JMmRTQ3WDm1yZWSQs9GFcPHgajZf1LDFlCDpf+k5q3itaQB86BA3uQs0I iA== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34x8b6vhhw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Nov 2020 04:09:45 -0500
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AK97TSM007503;
        Fri, 20 Nov 2020 09:09:43 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma05fra.de.ibm.com with ESMTP id 34v69uss3h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Nov 2020 09:09:43 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AK99ehq9306776
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Nov 2020 09:09:40 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 999FB4203F;
        Fri, 20 Nov 2020 09:09:40 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4DFC542041;
        Fri, 20 Nov 2020 09:09:40 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 20 Nov 2020 09:09:40 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>
Subject: [PATCH net 1/4] s390/qeth: Remove pnso workaround
Date:   Fri, 20 Nov 2020 10:09:36 +0100
Message-Id: <20201120090939.101406-2-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201120090939.101406-1-jwi@linux.ibm.com>
References: <20201120090939.101406-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-20_03:2020-11-19,2020-11-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 bulkscore=0 clxscore=1015 impostorscore=0 adultscore=0
 mlxscore=0 phishscore=0 spamscore=0 malwarescore=0 priorityscore=1501
 mlxlogscore=960 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011200056
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexandra Winter <wintera@linux.ibm.com>

Remove workaround that supported early hardware implementations
of PNSO OC3. Rely on the 'enarf' feature bit instead.

Fixes: fa115adff2c1 ("s390/qeth: Detect PNSO OC3 capability")
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Reviewed-by: Julian Wiedmann <jwi@linux.ibm.com>
[jwi: use logical instead of bit-wise AND]
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_l2_main.c | 18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 28f6dda95736..79939ba5d523 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -985,32 +985,19 @@ static void qeth_l2_setup_bridgeport_attrs(struct qeth_card *card)
  *	change notification' and thus can support the learning_sync bridgeport
  *	attribute
  *	@card: qeth_card structure pointer
- *
- *	This is a destructive test and must be called before dev2br or
- *	bridgeport address notification is enabled!
  */
 static void qeth_l2_detect_dev2br_support(struct qeth_card *card)
 {
 	struct qeth_priv *priv = netdev_priv(card->dev);
 	bool dev2br_supported;
-	int rc;
 
 	QETH_CARD_TEXT(card, 2, "d2brsup");
 	if (!IS_IQD(card))
 		return;
 
 	/* dev2br requires valid cssid,iid,chid */
-	if (!card->info.ids_valid) {
-		dev2br_supported = false;
-	} else if (css_general_characteristics.enarf) {
-		dev2br_supported = true;
-	} else {
-		/* Old machines don't have the feature bit:
-		 * Probe by testing whether a disable succeeds
-		 */
-		rc = qeth_l2_pnso(card, PNSO_OC_NET_ADDR_INFO, 0, NULL, NULL);
-		dev2br_supported = !rc;
-	}
+	dev2br_supported = card->info.ids_valid &&
+			   css_general_characteristics.enarf;
 	QETH_CARD_TEXT_(card, 2, "D2Bsup%02x", dev2br_supported);
 
 	if (dev2br_supported)
@@ -2233,7 +2220,6 @@ static int qeth_l2_set_online(struct qeth_card *card, bool carrier_ok)
 	struct net_device *dev = card->dev;
 	int rc = 0;
 
-	/* query before bridgeport_notification may be enabled */
 	qeth_l2_detect_dev2br_support(card);
 
 	mutex_lock(&card->sbp_lock);
-- 
2.17.1

