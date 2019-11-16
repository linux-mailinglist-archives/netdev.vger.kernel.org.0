Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E847BFF408
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 17:47:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbfKPQrs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 11:47:48 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:51080 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727794AbfKPQrr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 11:47:47 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAGGl7fZ113516
        for <netdev@vger.kernel.org>; Sat, 16 Nov 2019 11:47:46 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2wae609fvd-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 16 Nov 2019 11:47:45 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <kgraul@linux.ibm.com>;
        Sat, 16 Nov 2019 16:47:44 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sat, 16 Nov 2019 16:47:41 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAGGleaQ66322450
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 16 Nov 2019 16:47:40 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 188D2A4053;
        Sat, 16 Nov 2019 16:47:40 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CEADBA4051;
        Sat, 16 Nov 2019 16:47:39 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat, 16 Nov 2019 16:47:39 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 2/4] net/smc: guarantee removal of link groups in reboot
Date:   Sat, 16 Nov 2019 17:47:30 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191116164732.47059-1-kgraul@linux.ibm.com>
References: <20191116164732.47059-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19111616-0012-0000-0000-00000364D199
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111616-0013-0000-0000-000021A05225
Message-Id: <20191116164732.47059-3-kgraul@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-16_05:2019-11-15,2019-11-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 suspectscore=1 malwarescore=0 clxscore=1015 bulkscore=0
 adultscore=0 priorityscore=1501 mlxscore=0 mlxlogscore=999 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911160156
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

When rebooting it should be guaranteed all link groups are cleaned
up and freed.

Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_core.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index cf34b9d96595..bb92c7c6214c 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -14,6 +14,7 @@
 #include <linux/random.h>
 #include <linux/workqueue.h>
 #include <linux/wait.h>
+#include <linux/reboot.h>
 #include <net/tcp.h>
 #include <net/sock.h>
 #include <rdma/ib_verbs.h>
@@ -1282,14 +1283,27 @@ static void smc_lgrs_shutdown(void)
 	spin_unlock(&smcd_dev_list.lock);
 }
 
+static int smc_core_reboot_event(struct notifier_block *this,
+				 unsigned long event, void *ptr)
+{
+	smc_lgrs_shutdown();
+
+	return 0;
+}
+
+static struct notifier_block smc_reboot_notifier = {
+	.notifier_call = smc_core_reboot_event,
+};
+
 int __init smc_core_init(void)
 {
 	atomic_set(&lgr_cnt, 0);
-	return 0;
+	return register_reboot_notifier(&smc_reboot_notifier);
 }
 
 /* Called (from smc_exit) when module is removed */
 void smc_core_exit(void)
 {
+	unregister_reboot_notifier(&smc_reboot_notifier);
 	smc_lgrs_shutdown();
 }
-- 
2.17.1

