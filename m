Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7ED11B2E5
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 16:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388564AbfLKPjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 10:39:18 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:2760 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388490AbfLKPir (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 10:38:47 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBBFWO9Y019845;
        Wed, 11 Dec 2019 10:38:44 -0500
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wtfbxjtpm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Dec 2019 10:38:44 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id xBBFZwNt019689;
        Wed, 11 Dec 2019 15:38:42 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma02wdc.us.ibm.com with ESMTP id 2wr3q6nurf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Dec 2019 15:38:42 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBBFcf3T50069940
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Dec 2019 15:38:41 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9C904BE04F;
        Wed, 11 Dec 2019 15:38:41 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 40D71BE053;
        Wed, 11 Dec 2019 15:38:41 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.41.178.211])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 11 Dec 2019 15:38:41 +0000 (GMT)
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     linuxppc-dev@ozlabs.org, julietk@linux.vnet.ibm.com,
        Thomas Falcon <tlfalcon@linux.ibm.com>
Subject: [PATCH net v2] net/ibmvnic: Fix typo in retry check
Date:   Wed, 11 Dec 2019 09:38:39 -0600
Message-Id: <1576078719-9604-1-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-11_04:2019-12-11,2019-12-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=1 spamscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 priorityscore=1501 bulkscore=0
 adultscore=0 mlxscore=0 lowpriorityscore=0 clxscore=1015 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-1912110131
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This conditional is missing a bang, with the intent
being to break when the retry count reaches zero.

Fixes: 476d96ca9c ("ibmvnic: Bound waits for device queries")
Suggested-by: Juliet Kim <julietk@linux.vnet.ibm.com>
Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index efb0f10..2d84523 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -184,7 +184,7 @@ static int ibmvnic_wait_for_completion(struct ibmvnic_adapter *adapter,
 			netdev_err(netdev, "Device down!\n");
 			return -ENODEV;
 		}
-		if (retry--)
+		if (!retry--)
 			break;
 		if (wait_for_completion_timeout(comp_done, div_timeout))
 			return 0;
-- 
1.8.3.1

