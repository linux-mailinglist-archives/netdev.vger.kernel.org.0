Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94EB23A3D46
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 09:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231488AbhFKHgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 03:36:15 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:61974 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231438AbhFKHgF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 03:36:05 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15B7Xrpl002968;
        Fri, 11 Jun 2021 03:34:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=mH5ILxj9UsxOFX5Vvqjgq6n3ByqaB8VHI1LeJQsEuiQ=;
 b=ebJif2bBLofkusQxkcQKC9TUig8D1l2OaPLmfdYdhEthp0pB/ivsWZraJD8E8fq3TCXW
 ki2ZwjYlu8ZYzvF2L2XphSAJdMgzCJGKjjjQ9dzlvsz+MUae4lRnP5YSpoq7j6EBdMrE
 UNbA475CHZj2wpRMIbzGIAw1sZU9NMClHWmG2yh/p87U8jdSwr5ORwkmEGKI2+vbgWHy
 he2dEtfxwGbFaOFYCHJLc62uABTFcZhafwZ/xmLOw2KBc7Gw9ECEsqSGjZWh401IdJqN
 /VH3Ov/cunxsNAPwaJ25GYVW4qsU0+RL/F/RuxfXewv2L+Hfkw9V2w4NfHRIPvLzpfbV QA== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 394333gs78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Jun 2021 03:34:01 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15B7WPNl019382;
        Fri, 11 Jun 2021 07:33:52 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 3900w8stuy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Jun 2021 07:33:52 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15B7Wvrp29229444
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Jun 2021 07:32:57 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 54645A406F;
        Fri, 11 Jun 2021 07:33:49 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0DFF0A4065;
        Fri, 11 Jun 2021 07:33:49 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 11 Jun 2021 07:33:48 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 4/9] s390/qeth: use ethtool_sprintf()
Date:   Fri, 11 Jun 2021 09:33:36 +0200
Message-Id: <20210611073341.1634501-5-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210611073341.1634501-1-jwi@linux.ibm.com>
References: <20210611073341.1634501-1-jwi@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: AopHn8_J1Uoru5Y94PQ9DlCN_ko5y-QI
X-Proofpoint-ORIG-GUID: AopHn8_J1Uoru5Y94PQ9DlCN_ko5y-QI
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-11_01:2021-06-11,2021-06-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 priorityscore=1501 mlxscore=0 impostorscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106110048
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use a recently introduced helper to fill our ethtool stats strings.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_ethtool.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/net/qeth_ethtool.c b/drivers/s390/net/qeth_ethtool.c
index 190dac2065df..2c4cb300a8fc 100644
--- a/drivers/s390/net/qeth_ethtool.c
+++ b/drivers/s390/net/qeth_ethtool.c
@@ -80,10 +80,8 @@ static void qeth_add_stat_strings(u8 **data, const char *prefix,
 {
 	unsigned int i;
 
-	for (i = 0; i < size; i++) {
-		snprintf(*data, ETH_GSTRING_LEN, "%s%s", prefix, stats[i].name);
-		*data += ETH_GSTRING_LEN;
-	}
+	for (i = 0; i < size; i++)
+		ethtool_sprintf(data, "%s%s", prefix, stats[i].name);
 }
 
 static int qeth_get_sset_count(struct net_device *dev, int stringset)
-- 
2.25.1

