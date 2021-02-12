Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06BBF31A5E8
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 21:17:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbhBLURW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 15:17:22 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:63364 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229797AbhBLURV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 15:17:21 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11CKCpHT185716
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 15:16:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=gYAEdddI3IYXDRivRtID10SYsVRfpoBn71sfg55lgmY=;
 b=Nh+VIGVmAmqyQY1CixiA9D9HkTfacktUgkB8GsypkGL35SZBpbgJ8y3Cm4pfaYQmE6By
 OAuivVAOoTFtxiZnozCdCT/bQstSd9do1W2+O5kJjfPgYjfGgKv7vz1KxLwTvKgLoWQg
 sKZnQp5J6UsVw1LDIfqsj2cOS2Pl75NBs6IShpgYtBvXaeoQqrlWB3v1hIKHQwRFzwPJ
 vsQ5iShdJFZBUYsMZoKiCMAnm09w4Qj78WdCMGhCU3LEAuxdekF40V45He05SCzQSTry
 E2f/Yy//LnjM2j5xK4SxirhCXmbAojuS05uFffJi8bcU3mjGN3n+3A4korv3aJzv6Yol rA== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36p0gxg2mb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 15:16:40 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11CKDLTG008977
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 20:16:39 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma03wdc.us.ibm.com with ESMTP id 36hjr9yquy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 20:16:39 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11CKGdG331654276
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 20:16:39 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1736BAE05F;
        Fri, 12 Feb 2021 20:16:39 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9BD80AE05C;
        Fri, 12 Feb 2021 20:16:38 +0000 (GMT)
Received: from ltcalpine2-lp16.aus.stglabs.ibm.com (unknown [9.40.195.199])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 12 Feb 2021 20:16:38 +0000 (GMT)
From:   Dany Madden <drt@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     sukadev@linux.ibm.com, ljp@linux.ibm.com, ricklind@linux.ibm.com,
        Dany Madden <drt@linux.ibm.com>
Subject: [PATCH net V2] ibmvnic: change IBMVNIC_MAX_IND_DESCS to 16
Date:   Fri, 12 Feb 2021 15:16:30 -0500
Message-Id: <20210212201630.9003-1-drt@linux.ibm.com>
X-Mailer: git-send-email 2.18.2
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-12_07:2021-02-12,2021-02-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 clxscore=1015 impostorscore=0 malwarescore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102120144
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The supported indirect subcrq entries on Power8 is 16. Power9
supports 128. Redefined this value to 16 to minimize the driver from
having to reset when migrating between Power9 and Power8. In our rx/tx
performance testing, we found no performance difference between 16 and
128 at this time.

Fixes: f019fb6392e5 ("ibmvnic: Introduce indirect subordinate Command Response Queue buffer")
Signed-off-by: Dany Madden <drt@linux.ibm.com>
---
Changelog[V2]: Fixed fixes tag. Removed an extra s at the end of buffer. 
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

