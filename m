Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D05331A282
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 17:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbhBLQSs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 11:18:48 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:30396 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229648AbhBLQSl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 11:18:41 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11CG3vkP175149
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 11:17:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=1mquI83Dg8Pf/oCVQrmWvB5E7GNhmi8md9XB1DLGceQ=;
 b=ngESSyvclYAQYulYxZpwF4Z7calrtRTSrF9WMIlNIa5t4LiEU3gauiaKD4oA3LtL2fFx
 EEhT2UT0QGtvIG+sIa77DKTJrQsc7KGr4vEMlvU5lsT9s/b93HeZrYA2T9LwL90prF+m
 Ukbu5o1fIycI8iky6qdjxE3se3YjIEFi5pCtDKlmn3UrhN9Taycx/q5GVyElZ9ibt/LH
 Ob6Xkty9vipdtm5jc2/7hLOizEiBHWMqqYCdP2GDw/QmoudVAFW5B1YmHdXDSHvxJfUU
 5NuEp8JZMcItyruYBP8aoattETAnLRc1wpJVINsoDi6U0VK0IWGHFfZBRdbX9Ww0OLez 5g== 
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36nv8a9jwm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 11:17:57 -0500
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11CG7ajU008317
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 16:17:56 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma04wdc.us.ibm.com with ESMTP id 36hjr9x6j6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 16:17:56 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11CGHtpW21627150
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 16:17:55 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7B953BE051;
        Fri, 12 Feb 2021 16:17:55 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2102CBE04F;
        Fri, 12 Feb 2021 16:17:55 +0000 (GMT)
Received: from ltcalpine2-lp16.aus.stglabs.ibm.com (unknown [9.40.195.199])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 12 Feb 2021 16:17:54 +0000 (GMT)
From:   Dany Madden <drt@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     sukadev@linux.ibm.com, ljp@linux.ibm.com, ricklind@linux.ibm.com,
        Dany Madden <drt@linux.ibm.com>
Subject: [PATCH net] ibmvnic: change IBMVNIC_MAX_IND_DESCS to 16
Date:   Fri, 12 Feb 2021 11:17:27 -0500
Message-Id: <20210212161727.8557-1-drt@linux.ibm.com>
X-Mailer: git-send-email 2.18.2
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-12_05:2021-02-12,2021-02-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 mlxlogscore=999 mlxscore=0 clxscore=1011 bulkscore=0
 priorityscore=1501 phishscore=0 spamscore=0 impostorscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102120122
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The supported indirect subcrq entries on Power8 is 16. Power9
supports 128. Redefined this value to 16 to minimize the driver from
having to reset when migrating between Power9 and Power8. In our rx/tx
performance testing, we found no performance difference between 16 and
128 at this time.

Fixes: f019fb6392e5 ("ibmvnic: Introduce indirect subordinate Command Response Queue buffers")
Signed-off-by: Dany Madden <drt@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index c09c3f6bba9f..07ced1016aa4 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -31,7 +31,7 @@
 #define IBMVNIC_BUFFS_PER_POOL	100
 #define IBMVNIC_MAX_QUEUES	16
 #define IBMVNIC_MAX_QUEUE_SZ   4096
-#define IBMVNIC_MAX_IND_DESCS  128
+#define IBMVNIC_MAX_IND_DESCS  16
 #define IBMVNIC_IND_ARR_SZ	(IBMVNIC_MAX_IND_DESCS * 32)
 
 #define IBMVNIC_TSO_BUF_SZ	65536
-- 
2.26.2

