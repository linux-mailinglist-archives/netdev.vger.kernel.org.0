Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7473B2611
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 06:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229474AbhFXEQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 00:16:15 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:8084 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229478AbhFXEQO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 00:16:14 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15O43a6m025937
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 00:13:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=NAb72fDKY1Q8x7BvgFLOQE2CgtdWK7fm03kZKnF72yw=;
 b=odU6xWLLzeepeFKWneL+vNdy5P1GYCi1+R8XZa7QI8QOwVjgwPnvwHnXqh1gA3/Fxzgo
 hzhbhBDMhjsk3AA4LOZB7Df4ZRXgk96fwr10htLhzkzr2f8AZtb8OXikZzOu5OWXP5me
 eWGNWL4URydVxF/Q0qVMfnAvMLHMbOXYS8x5xW4kJEcHoTiChsmUSYw5ciTOLLkvw3Ca
 EnieuHun357V0eJYFQe/sT7N0Ii+A5ZgwuS7HkeQvUg50a4s0J/gApeqA4+GMZXt0fjR
 VeGWeKyXU9mu05HtVjIKh3IV5PNMcJSyyRD8K4BnmznoQXlcu/gFKOWJWuUGQhGcYhwH RQ== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39ch58jfbu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 00:13:25 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15O4A5Lj008851
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 04:13:24 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma01wdc.us.ibm.com with ESMTP id 3998795qg6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 04:13:24 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15O4DKwV11665736
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Jun 2021 04:13:20 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB75E6A051;
        Thu, 24 Jun 2021 04:13:20 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 99CAE6A04D;
        Thu, 24 Jun 2021 04:13:19 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.85.145.253])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 24 Jun 2021 04:13:19 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>, sukadev@linux.ibm.com,
        Brian King <brking@linux.ibm.com>, cforno12@linux.ibm.com,
        Abdul Haleem <abdhalee@in.ibm.com>
Subject: [PATCH net 2/7] Revert "ibmvnic: remove duplicate napi_schedule call in open function"
Date:   Wed, 23 Jun 2021 21:13:11 -0700
Message-Id: <20210624041316.567622-3-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210624041316.567622-1-sukadev@linux.ibm.com>
References: <20210624041316.567622-1-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 2YZqwNcM3OUjxumNNnUS20txsK-_3mDr
X-Proofpoint-GUID: 2YZqwNcM3OUjxumNNnUS20txsK-_3mDr
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-23_14:2021-06-23,2021-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 clxscore=1015 impostorscore=0
 malwarescore=0 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106240021
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dany Madden <drt@linux.ibm.com>

This reverts commit 7c451f3ef676c805a4b77a743a01a5c21a250a73.

When a vnic interface is taken down and then up, connectivity is not
restored. We bisected it to this commit. Reverting this commit until
we can fully investigate the issue/benefit of the change.

Fixes: 7c451f3ef676 ("ibmvnic: remove duplicate napi_schedule call in open function")
Reported-by: Cristobal Forno <cforno12@linux.ibm.com>
Reported-by: Abdul Haleem <abdhalee@in.ibm.com>
Signed-off-by: Dany Madden <drt@linux.ibm.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index f13ad6bc67cd..fe1627ea9762 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1234,6 +1234,11 @@ static int __ibmvnic_open(struct net_device *netdev)
 
 	netif_tx_start_all_queues(netdev);
 
+	if (prev_state == VNIC_CLOSED) {
+		for (i = 0; i < adapter->req_rx_queues; i++)
+			napi_schedule(&adapter->napi[i]);
+	}
+
 	adapter->state = VNIC_OPEN;
 	return rc;
 }
-- 
2.31.1

