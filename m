Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67F15189C58
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 13:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbgCRMz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 08:55:27 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4476 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726971AbgCRMz0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 08:55:26 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02ICWeGu166639
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 08:55:25 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yu8ad6pkr-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 08:55:24 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Wed, 18 Mar 2020 12:55:22 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 18 Mar 2020 12:55:20 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02ICtJSF51183860
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Mar 2020 12:55:19 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F3E3DA405F;
        Wed, 18 Mar 2020 12:55:18 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B37F6A405B;
        Wed, 18 Mar 2020 12:55:18 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 18 Mar 2020 12:55:18 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 10/11] s390/qeth: remove gratuitous NULL checks
Date:   Wed, 18 Mar 2020 13:54:54 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200318125455.5838-1-jwi@linux.ibm.com>
References: <20200318125455.5838-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20031812-0012-0000-0000-000003932FEB
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20031812-0013-0000-0000-000021D01255
Message-Id: <20200318125455.5838-11-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-18_05:2020-03-18,2020-03-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 mlxscore=0 clxscore=1015 priorityscore=1501 spamscore=0
 malwarescore=0 impostorscore=0 suspectscore=0 bulkscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003180059
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qeth_do_ioctl() is only reached through our own net_device_ops, so we
can trust that dev->ml_priv still contains what we put there earlier.

qeth_bridgeport_an_set() is an internal function that doesn't require
such sanity checks.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 3 ---
 drivers/s390/net/qeth_l2_main.c   | 2 --
 2 files changed, 5 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 3f0b13ff580e..bd3adbb6ad50 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -6264,9 +6264,6 @@ int qeth_do_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 	struct mii_ioctl_data *mii_data;
 	int rc = 0;
 
-	if (!card)
-		return -ENODEV;
-
 	switch (cmd) {
 	case SIOC_QETH_ADP_SET_SNMP_CONTROL:
 		rc = qeth_snmp_command(card, rq->ifr_ifru.ifru_data);
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 71eb2d9bfbb7..2aaf5e3779ce 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -1519,8 +1519,6 @@ int qeth_bridgeport_an_set(struct qeth_card *card, int enable)
 	struct ccw_device *ddev;
 	struct subchannel_id schid;
 
-	if (!card)
-		return -EINVAL;
 	if (!card->options.sbp.supported_funcs)
 		return -EOPNOTSUPP;
 	ddev = CARD_DDEV(card);
-- 
2.17.1

