Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71A0034009E
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 09:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbhCRIFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 04:05:15 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48986 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229598AbhCRIFJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 04:05:09 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12I83NZL142512;
        Thu, 18 Mar 2021 04:04:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=FIaQVKTrcqpV7T9mGxF8KbYtkllxI8B8w9dkIWVUWmE=;
 b=GW810HP0J8BCV7Y/iuWsGFLRAkBcvJgL4NROkfoKPcmdV3MeVkanlfLlt6oMeqR5dFed
 1LhgH4IYX0yiKIlT8iiLK3RXC/bg3xORsv7Ua5O0J2OkOFJYaXBeJkhe7AY5cOUehk2b
 ti63xFAJLRyE2p1WLn6vUGlBRmSFAnIoqEqsojpPHquWJ9LNbcKw2m2XmwDic7BtaoH4
 K7Alq6QzoaPac+JSRPWtzgysoIZpqApbkuUGwJAZ+vH5puLe07NtNPJdOsiPfu1pR2zA
 rfsp6uJIPADkSjHeQx9P/GUA4OXCGpcBxk9yDWZoSE+TA+JJ7juNqoTjNEex+ePqj9r5 /Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37bxvkp0u1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 04:04:54 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12I83QXd142753;
        Thu, 18 Mar 2021 04:04:53 -0400
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37bxvkp0t4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 04:04:53 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12I833uo028798;
        Thu, 18 Mar 2021 08:04:52 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma02wdc.us.ibm.com with ESMTP id 378n1an5f9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 08:04:52 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12I84p7335520898
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Mar 2021 08:04:51 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DB1A5124054;
        Thu, 18 Mar 2021 08:04:51 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1998D124053;
        Thu, 18 Mar 2021 08:04:51 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.80.209.131])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 18 Mar 2021 08:04:50 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net
Cc:     tlfalcon@linux.ibm.com, ast@kernel.org, daniel@iogearbox.net,
        andriin@fb.com, edumazet@google.com, weiwan@google.com,
        cong.wang@bytedance.com, ap420073@gmail.com,
        shemminger@linux-foundation.org, Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net] net: core: avoid napi_disable to cause deadlock
Date:   Thu, 18 Mar 2021 03:04:50 -0500
Message-Id: <20210318080450.38893-1-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-18_02:2021-03-17,2021-03-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1011
 suspectscore=0 adultscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103180061
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are chances that napi_disable is called twice by NIC driver.
This could generate deadlock. For example,
the first napi_disable will spin until NAPI_STATE_SCHED is cleared
by napi_complete_done, then set it again.
When napi_disable is called the second time, it will loop infinitely
because no dev->poll will be running to clear NAPI_STATE_SCHED.

CPU0				CPU1
 napi_disable
  test_and_set_bit
  (napi_complete_done clears
   NAPI_STATE_SCHED, ret 0,
   and set NAPI_STATE_SCHED)
				napi_disable
				 test_and_set_bit
				 (ret 1 and loop infinitely because
				  no napi instance is scheduled to
				  clear NAPI_STATE_SCHED bit)

Checking the napi state bit to make sure if napi is already disabled,
exit the call early enough to avoid spinning infinitely.

Fixes: bea3348eef27 ("[NET]: Make NAPI polling independent of struct net_device objects.")
Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
---
 net/core/dev.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 6c5967e80132..eb3c0ddd4fd7 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6809,6 +6809,24 @@ EXPORT_SYMBOL(netif_napi_add);
 void napi_disable(struct napi_struct *n)
 {
 	might_sleep();
+
+	/* make sure napi_disable() runs only once,
+	 * When napi is disabled, the state bits are like:
+	 * NAPI_STATE_SCHED (set by previous napi_disable)
+	 * NAPI_STATE_NPSVC (set by previous napi_disable)
+	 * NAPI_STATE_DISABLE (cleared by previous napi_disable)
+	 * NAPI_STATE_PREFER_BUSY_POLL (cleared by previous napi_complete_done)
+	 * NAPI_STATE_MISSED (cleared by previous napi_complete_done)
+	 */
+
+	if (napi_disable_pending(n))
+		return;
+	if (test_bit(NAPI_STATE_SCHED, &n->state) &&
+	    test_bit(NAPI_STATE_NPSVC, &n->state) &&
+	    !test_bit(NAPI_STATE_MISSED, &n->state) &&
+	    !test_bit(NAPI_STATE_PREFER_BUSY_POLL, &n->state))
+		return;
+
 	set_bit(NAPI_STATE_DISABLE, &n->state);
 
 	while (test_and_set_bit(NAPI_STATE_SCHED, &n->state))
-- 
2.23.0

