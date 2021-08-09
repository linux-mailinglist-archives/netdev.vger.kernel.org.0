Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2504D3E419E
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 10:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233985AbhHIIcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 04:32:09 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:29222 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233933AbhHIIcI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 04:32:08 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17985XYj175485;
        Mon, 9 Aug 2021 04:31:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=qTjY1rFayv2T+Y+hRj2cvtakImgezdyMoLeCM9W868E=;
 b=WsS3chLhMK8yfhzjAYbML8D1usDzQyG3QqqXQet2QNfiKnd5jbIq/07o7pdKHSfnRL1L
 BBvK1c/6YjmF0RFJ2dstLhHQ6LOskHlME5mdp3qT8cTxMmKlD8ZBEL/V3bVeoQhYEVks
 fEEaVNskSM6LMIGT3qgjSh0k2sqGVfKIaB4xwifEwJeJ0VY7wn+RgTUY4TubV0ycELdC
 AmuUS/OKdYBnKDCZD79CNXqyLrY0DYuYiZAJd5jI85WbcF4w0Wb2pXGF9ZQS9W5Gmv6s
 Flbv0ubwjoKSkJ1ue+lhil1ySTYUza+29Op0saLoenDgqpMnDpGlUsTD9yX5dtfc7ta1 yw== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aa74j22wu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 04:31:36 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1798SGNq023831;
        Mon, 9 Aug 2021 08:31:34 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3a9ht8umd0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 08:31:34 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1798SOLW61604338
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Aug 2021 08:28:24 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3B6E2A4053;
        Mon,  9 Aug 2021 08:31:30 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9978AA405B;
        Mon,  9 Aug 2021 08:31:29 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  9 Aug 2021 08:31:29 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH net-next 5/5] net/iucv: Replace deprecated CPU-hotplug functions.
Date:   Mon,  9 Aug 2021 10:30:50 +0200
Message-Id: <20210809083050.2328336-6-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210809083050.2328336-1-kgraul@linux.ibm.com>
References: <20210809083050.2328336-1-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: nehYgYQLYL1x-APIZkzd4bHKa9kuZGYo
X-Proofpoint-GUID: nehYgYQLYL1x-APIZkzd4bHKa9kuZGYo
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-09_01:2021-08-06,2021-08-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 mlxscore=0 clxscore=1015 mlxlogscore=999 priorityscore=1501 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108090065
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

The functions get_online_cpus() and put_online_cpus() have been
deprecated during the CPU hotplug rework. They map directly to
cpus_read_lock() and cpus_read_unlock().

Replace deprecated CPU-hotplug functions with the official version.
The behavior remains unchanged.

Cc: Julian Wiedmann <jwi@linux.ibm.com>
Cc: Karsten Graul <kgraul@linux.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-s390@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/iucv/iucv.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/iucv/iucv.c b/net/iucv/iucv.c
index bebc7d09815d..f3343a8541a5 100644
--- a/net/iucv/iucv.c
+++ b/net/iucv/iucv.c
@@ -502,14 +502,14 @@ static void iucv_setmask_mp(void)
 {
 	int cpu;
 
-	get_online_cpus();
+	cpus_read_lock();
 	for_each_online_cpu(cpu)
 		/* Enable all cpus with a declared buffer. */
 		if (cpumask_test_cpu(cpu, &iucv_buffer_cpumask) &&
 		    !cpumask_test_cpu(cpu, &iucv_irq_cpumask))
 			smp_call_function_single(cpu, iucv_allow_cpu,
 						 NULL, 1);
-	put_online_cpus();
+	cpus_read_unlock();
 }
 
 /**
@@ -542,7 +542,7 @@ static int iucv_enable(void)
 	size_t alloc_size;
 	int cpu, rc;
 
-	get_online_cpus();
+	cpus_read_lock();
 	rc = -ENOMEM;
 	alloc_size = iucv_max_pathid * sizeof(struct iucv_path);
 	iucv_path_table = kzalloc(alloc_size, GFP_KERNEL);
@@ -555,12 +555,12 @@ static int iucv_enable(void)
 	if (cpumask_empty(&iucv_buffer_cpumask))
 		/* No cpu could declare an iucv buffer. */
 		goto out;
-	put_online_cpus();
+	cpus_read_unlock();
 	return 0;
 out:
 	kfree(iucv_path_table);
 	iucv_path_table = NULL;
-	put_online_cpus();
+	cpus_read_unlock();
 	return rc;
 }
 
@@ -573,11 +573,11 @@ static int iucv_enable(void)
  */
 static void iucv_disable(void)
 {
-	get_online_cpus();
+	cpus_read_lock();
 	on_each_cpu(iucv_retrieve_cpu, NULL, 1);
 	kfree(iucv_path_table);
 	iucv_path_table = NULL;
-	put_online_cpus();
+	cpus_read_unlock();
 }
 
 static int iucv_cpu_dead(unsigned int cpu)
@@ -786,7 +786,7 @@ static int iucv_reboot_event(struct notifier_block *this,
 	if (cpumask_empty(&iucv_irq_cpumask))
 		return NOTIFY_DONE;
 
-	get_online_cpus();
+	cpus_read_lock();
 	on_each_cpu_mask(&iucv_irq_cpumask, iucv_block_cpu, NULL, 1);
 	preempt_disable();
 	for (i = 0; i < iucv_max_pathid; i++) {
@@ -794,7 +794,7 @@ static int iucv_reboot_event(struct notifier_block *this,
 			iucv_sever_pathid(i, NULL);
 	}
 	preempt_enable();
-	put_online_cpus();
+	cpus_read_unlock();
 	iucv_disable();
 	return NOTIFY_DONE;
 }
-- 
2.25.1

