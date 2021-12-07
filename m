Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 604A346B69D
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 10:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233452AbhLGJI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 04:08:59 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60238 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233446AbhLGJIy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 04:08:54 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B77Gceg021785;
        Tue, 7 Dec 2021 09:05:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=EXZHMZzJfBoBmjE3MXYvEtJVwkJaGlyZOvyQ065p2H0=;
 b=GfzMkmN82X4SGXEd72DIaMl3lE5oMGrExkhb+6VFjCtUZPmQuh7DClhU1DcqoDrmSQEW
 13JWh6xbYr+A2Pq+YbdP4HvfNnRFQmKz1r4SyK4wjAsb5oQiYH9na+iVhNVgdoFsnh5e
 PYSdiR7FvCYvA7XCwsopCo0IzjaHk44LR4vaVx6vCmVvjRssLaxWm0nNq/hp4pe+ZFzF
 pRacfb+nrUyCsA4i6byWLr21jgPZ37iuqGJcMQtDTufkEZmRT2KLQ7WftK0QtECmFuq0
 lIwGfeHU7RsOd3wYpiwxRyXCT+SiaWfwukQkNf3AMFILQc+FIWF2pO8xhQWx7UiyJwuU Lg== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ct334t3n8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 09:05:16 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B793AZG008301;
        Tue, 7 Dec 2021 09:05:14 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3cqyyamdj2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 09:05:13 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B78vSAW25297280
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Dec 2021 08:57:28 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C9F3352057;
        Tue,  7 Dec 2021 09:05:08 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id B856D52051;
        Tue,  7 Dec 2021 09:05:08 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55271)
        id 76BEDE1269; Tue,  7 Dec 2021 10:05:08 +0100 (CET)
From:   Alexandra Winter <wintera@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>
Subject: [PATCH net-next 3/5] s390/qeth: don't offer .ndo_bridge_* ops for OSA devices
Date:   Tue,  7 Dec 2021 10:04:50 +0100
Message-Id: <20211207090452.1155688-4-wintera@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211207090452.1155688-1-wintera@linux.ibm.com>
References: <20211207090452.1155688-1-wintera@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: uNihWKptOqCYexCIUX1fog_PQ4El9Nsw
X-Proofpoint-ORIG-GUID: uNihWKptOqCYexCIUX1fog_PQ4El9Nsw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-07_03,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 mlxscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 impostorscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112070054
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

qeth_l2_detect_dev2br_support() will only set brport_hw_features for IQD
devices. So qeth_l2_bridge_getlink() and qeth_l2_bridge_setlink() will
always return -EOPNOTSUPP on OSA devices. Just don't offer these
callbacks instead.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
---
 drivers/s390/net/qeth_l2_main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 48355fbc0712..d1933c54bfbb 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -1091,8 +1091,6 @@ static const struct net_device_ops qeth_l2_osa_netdev_ops = {
 	.ndo_tx_timeout		= qeth_tx_timeout,
 	.ndo_fix_features	= qeth_fix_features,
 	.ndo_set_features	= qeth_set_features,
-	.ndo_bridge_getlink	= qeth_l2_bridge_getlink,
-	.ndo_bridge_setlink	= qeth_l2_bridge_setlink,
 };
 
 static int qeth_l2_setup_netdev(struct qeth_card *card)
-- 
2.32.0

