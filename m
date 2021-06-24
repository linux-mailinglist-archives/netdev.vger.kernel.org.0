Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A97E93B2614
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 06:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbhFXEQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 00:16:23 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41584 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230037AbhFXEQO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 00:16:14 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15O42iLS034668
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 00:13:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Rzxk4ZWc/K77XmHzh9xAqZZ8XJZ4NtphGJDha6pL1yw=;
 b=XePrX5NaKIilDTXno78i0TaaFoVBeuiki6s6YnSafUvAhUxzEbgAuyw88XCdLa6RwZ8B
 rhxYsKHj+vlwpPqOwX3/V8Mn+45W55HRTwp986xLnGx7aWdF+PeeYPmYYSMfJ6c+uPq9
 bSc0vGarg+QD5GYYlkumUdhOgvWDXNdeWkgEm1C/OuGV6XwVIROrOLd9bnd/cmBZQppm
 S0f9dsg4RHwRoGoMAoXx/BV+eye+azhvDlVDEF2VaTfZ4Mr99ZyAr+NlYyxj1HOpYs1J
 LHyS4SwXpHhiqjMv2w+TusZbXjlxVpImkqvD6ohlbt3FRHJ0l4cR305YgFxnx1isBjQJ pw== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39cjk78dpa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 00:13:21 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15O48r9L022348
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 04:13:21 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma04dal.us.ibm.com with ESMTP id 39bds22tyh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 04:13:20 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15O4DJJC28967250
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Jun 2021 04:13:19 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D5256A04F;
        Thu, 24 Jun 2021 04:13:19 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 52BF66A047;
        Thu, 24 Jun 2021 04:13:18 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.85.145.253])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 24 Jun 2021 04:13:18 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>, sukadev@linux.ibm.com,
        Brian King <brking@linux.ibm.com>, cforno12@linux.ibm.com
Subject: [PATCH net 1/7] Revert "ibmvnic: simplify reset_long_term_buff function"
Date:   Wed, 23 Jun 2021 21:13:10 -0700
Message-Id: <20210624041316.567622-2-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210624041316.567622-1-sukadev@linux.ibm.com>
References: <20210624041316.567622-1-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: I-wmtxA4fQGjjRrhK5qtTSlRcabnDAGV
X-Proofpoint-GUID: I-wmtxA4fQGjjRrhK5qtTSlRcabnDAGV
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-23_14:2021-06-23,2021-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 bulkscore=0 mlxscore=0 lowpriorityscore=0 spamscore=0
 clxscore=1015 phishscore=0 impostorscore=0 malwarescore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106240021
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 1c7d45e7b2c29080bf6c8cd0e213cc3cbb62a054.

We tried to optimize the number of hcalls we send and skipped sending
the REQUEST_MAP calls for some maps. However during resets, we need to
resend all the maps to the VIOS since the VIOS does not remember the
old values. In fact we may have failed over to a new VIOS which will
not have any of the mappings.

When we send packets with map ids the VIOS does not know about, it
triggers a FATAL reset. While the client does recover from the FATAL
error reset, we are seeing a large number of such resets. Handling
FATAL resets is lot more unnecessary work than issuing a few more
hcalls so revert the commit and resend the maps to the VIOS.

Fixes: 1c7d45e7b2c ("ibmvnic: simplify reset_long_term_buff function")
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 46 ++++++++++++++++++++++++------
 1 file changed, 38 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index adb0d5ca9ff1..f13ad6bc67cd 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -280,12 +280,40 @@ static void free_long_term_buff(struct ibmvnic_adapter *adapter,
 	dma_free_coherent(dev, ltb->size, ltb->buff, ltb->addr);
 }
 
-static int reset_long_term_buff(struct ibmvnic_long_term_buff *ltb)
+static int reset_long_term_buff(struct ibmvnic_adapter *adapter,
+				struct ibmvnic_long_term_buff *ltb)
 {
-	if (!ltb->buff)
-		return -EINVAL;
+	struct device *dev = &adapter->vdev->dev;
+	int rc;
 
 	memset(ltb->buff, 0, ltb->size);
+
+	mutex_lock(&adapter->fw_lock);
+	adapter->fw_done_rc = 0;
+
+	reinit_completion(&adapter->fw_done);
+	rc = send_request_map(adapter, ltb->addr, ltb->size, ltb->map_id);
+	if (rc) {
+		mutex_unlock(&adapter->fw_lock);
+		return rc;
+	}
+
+	rc = ibmvnic_wait_for_completion(adapter, &adapter->fw_done, 10000);
+	if (rc) {
+		dev_info(dev,
+			 "Reset failed, long term map request timed out or aborted\n");
+		mutex_unlock(&adapter->fw_lock);
+		return rc;
+	}
+
+	if (adapter->fw_done_rc) {
+		dev_info(dev,
+			 "Reset failed, attempting to free and reallocate buffer\n");
+		free_long_term_buff(adapter, ltb);
+		mutex_unlock(&adapter->fw_lock);
+		return alloc_long_term_buff(adapter, ltb, ltb->size);
+	}
+	mutex_unlock(&adapter->fw_lock);
 	return 0;
 }
 
@@ -507,7 +535,8 @@ static int reset_rx_pools(struct ibmvnic_adapter *adapter)
 						  rx_pool->size *
 						  rx_pool->buff_size);
 		} else {
-			rc = reset_long_term_buff(&rx_pool->long_term_buff);
+			rc = reset_long_term_buff(adapter,
+						  &rx_pool->long_term_buff);
 		}
 
 		if (rc)
@@ -630,11 +659,12 @@ static int init_rx_pools(struct net_device *netdev)
 	return 0;
 }
 
-static int reset_one_tx_pool(struct ibmvnic_tx_pool *tx_pool)
+static int reset_one_tx_pool(struct ibmvnic_adapter *adapter,
+			     struct ibmvnic_tx_pool *tx_pool)
 {
 	int rc, i;
 
-	rc = reset_long_term_buff(&tx_pool->long_term_buff);
+	rc = reset_long_term_buff(adapter, &tx_pool->long_term_buff);
 	if (rc)
 		return rc;
 
@@ -661,10 +691,10 @@ static int reset_tx_pools(struct ibmvnic_adapter *adapter)
 
 	tx_scrqs = adapter->num_active_tx_pools;
 	for (i = 0; i < tx_scrqs; i++) {
-		rc = reset_one_tx_pool(&adapter->tso_pool[i]);
+		rc = reset_one_tx_pool(adapter, &adapter->tso_pool[i]);
 		if (rc)
 			return rc;
-		rc = reset_one_tx_pool(&adapter->tx_pool[i]);
+		rc = reset_one_tx_pool(adapter, &adapter->tx_pool[i]);
 		if (rc)
 			return rc;
 	}
-- 
2.31.1

