Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE28E2B69C2
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 17:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727279AbgKQQQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 11:16:38 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50914 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726854AbgKQQQh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 11:16:37 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AHG3vmj119393;
        Tue, 17 Nov 2020 11:15:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=ExMz3MhMgHnLHhMOTFNkkxlQhAotSZGw988rvdtUC+w=;
 b=Q+i+ttmpRUI17dj7NXv/b5qjZ6i0lyhNwfs5w9l937lgt1Dg7pQdUI3RbumB9wi9uhgb
 dwpNJbK3ixiqAqtQwgbDefO4tZVq5h7Qa43RdslPY7q4xbomXldDeb1y4SmqC0DAmK6x
 WAub3q8OT90yWthj/LsCb+2Gz+wypHW/P+BJzE988YbrV+gn2gpw4WXNdrlB4DMSnd74
 TUbe0TJS59DOExvbZvqn3UVelTqYDmyLKsWFawFUqcmdXwKFaVqov1CvyelXYsQCZtK+
 R0W2cesrSbk2VR1dAtzjADlR7T9yiA4RrQWDlze+vtPVkuiMJytwjtPhLzHqadR0XPLI mA== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34veev81ef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 11:15:31 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AHG8SdK001804;
        Tue, 17 Nov 2020 16:15:29 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 34t6gh3a49-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 16:15:29 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AHGFRBQ1901192
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Nov 2020 16:15:27 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D81A4A4066;
        Tue, 17 Nov 2020 16:15:26 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8CB12A405B;
        Tue, 17 Nov 2020 16:15:26 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 17 Nov 2020 16:15:26 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH net-next 3/9] s390/qeth: remove useless if/else
Date:   Tue, 17 Nov 2020 17:15:14 +0100
Message-Id: <20201117161520.1089-4-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201117161520.1089-1-jwi@linux.ibm.com>
References: <20201117161520.1089-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-17_04:2020-11-17,2020-11-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 priorityscore=1501 adultscore=0 lowpriorityscore=0 spamscore=0
 phishscore=0 malwarescore=0 impostorscore=0 mlxlogscore=910 clxscore=1015
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170114
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

Fix the following coccinelle report:

./drivers/s390/net/qeth_l3_main.c:107:2-4: WARNING: possible condition with no effect (if == else)

Both branches are the same since
commit ab29c480b194 ("s390/qeth: replace deprecated simple_stroul()"),
so remove them.

Reported-by: Tosk Robot <tencent_os_robot@tencent.com>
Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
[jwi: point to the commit that introduced this]
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_l3_main.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index b1c1d2510d55..264b6c782382 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -104,10 +104,7 @@ static bool qeth_l3_is_addr_covered_by_ipato(struct qeth_card *card,
 		qeth_l3_convert_addr_to_bits(ipatoe->addr, ipatoe_bits,
 					  (ipatoe->proto == QETH_PROT_IPV4) ?
 					  4 : 16);
-		if (addr->proto == QETH_PROT_IPV4)
-			rc = !memcmp(addr_bits, ipatoe_bits, ipatoe->mask_bits);
-		else
-			rc = !memcmp(addr_bits, ipatoe_bits, ipatoe->mask_bits);
+		rc = !memcmp(addr_bits, ipatoe_bits, ipatoe->mask_bits);
 		if (rc)
 			break;
 	}
-- 
2.17.1

