Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE32631A9A7
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 03:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbhBMChC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 21:37:02 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51838 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229648AbhBMChC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 21:37:02 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11D2ESEG049604
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 21:36:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=4s5Ox4K3E1TRzxUIVO97qCz3nOAT0ojDesq7W4GauVc=;
 b=oFCGNkoBOcvz6/THP0ElmD/amahHoq6+20tbKEWuEf9VNEd59c9DJQd6+NdCNJxEytvI
 KbKGDt+k/0W0Ld0Q1Rt7eFbDCVZvJTKq3sccJSHFx6iqmxt93M/F2W/q11ikkaxd/JE6
 XC1zEJDA7eI8hfGcsNpj6lnfVKpjg3gmGAJYMqxuqtnHvWBSORiW6i1+mIEx/Of0wLxC
 yPHuJMuv3IdAWgTFM+dACRbjjlL5BHW0rAFzdOoTUVIdsPmersOVeoJ6sGcL0w/ZlIXH
 7S9Q+nHcbCbtp5wMenzBwRgmdd6cqcP3qlK/LOmehQZ7MzUllBBEy8/FVznV2zvwRh+h IQ== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36p5t4gc3x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 21:36:15 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11D2WaD9013641
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 02:36:14 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma02dal.us.ibm.com with ESMTP id 36hjrawubg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 02:36:14 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11D2aCNG30605628
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 13 Feb 2021 02:36:12 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5FD22C6057;
        Sat, 13 Feb 2021 02:36:12 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 98E4BC6055;
        Sat, 13 Feb 2021 02:36:11 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.80.198.213])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sat, 13 Feb 2021 02:36:11 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     sukadev@linux.ibm.com, drt@linux.ibm.com,
        Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net-next] ibmvnic: simplify reset_long_term_buff function
Date:   Fri, 12 Feb 2021 20:36:10 -0600
Message-Id: <20210213023610.55911-1-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-12_10:2021-02-12,2021-02-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 malwarescore=0 suspectscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 priorityscore=1501 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102130017
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The only thing reset_long_term_buff() should do is set
buffer to zero. After doing that, it is not necessary to
send_request_map again to VIOS since it actually does not
change the mapping. So, keep memset function and remove all
others.

Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 46 ++++++------------------------
 1 file changed, 8 insertions(+), 38 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 1774fbaab146..7a5e589e7223 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -253,40 +253,12 @@ static void free_long_term_buff(struct ibmvnic_adapter *adapter,
 	dma_free_coherent(dev, ltb->size, ltb->buff, ltb->addr);
 }
 
-static int reset_long_term_buff(struct ibmvnic_adapter *adapter,
-				struct ibmvnic_long_term_buff *ltb)
+static int reset_long_term_buff(struct ibmvnic_long_term_buff *ltb)
 {
-	struct device *dev = &adapter->vdev->dev;
-	int rc;
+	if (!ltb->buff)
+		return -EINVAL;
 
 	memset(ltb->buff, 0, ltb->size);
-
-	mutex_lock(&adapter->fw_lock);
-	adapter->fw_done_rc = 0;
-
-	reinit_completion(&adapter->fw_done);
-	rc = send_request_map(adapter, ltb->addr, ltb->size, ltb->map_id);
-	if (rc) {
-		mutex_unlock(&adapter->fw_lock);
-		return rc;
-	}
-
-	rc = ibmvnic_wait_for_completion(adapter, &adapter->fw_done, 10000);
-	if (rc) {
-		dev_info(dev,
-			 "Reset failed, long term map request timed out or aborted\n");
-		mutex_unlock(&adapter->fw_lock);
-		return rc;
-	}
-
-	if (adapter->fw_done_rc) {
-		dev_info(dev,
-			 "Reset failed, attempting to free and reallocate buffer\n");
-		free_long_term_buff(adapter, ltb);
-		mutex_unlock(&adapter->fw_lock);
-		return alloc_long_term_buff(adapter, ltb, ltb->size);
-	}
-	mutex_unlock(&adapter->fw_lock);
 	return 0;
 }
 
@@ -508,8 +480,7 @@ static int reset_rx_pools(struct ibmvnic_adapter *adapter)
 						  rx_pool->size *
 						  rx_pool->buff_size);
 		} else {
-			rc = reset_long_term_buff(adapter,
-						  &rx_pool->long_term_buff);
+			rc = reset_long_term_buff(&rx_pool->long_term_buff);
 		}
 
 		if (rc)
@@ -632,12 +603,11 @@ static int init_rx_pools(struct net_device *netdev)
 	return 0;
 }
 
-static int reset_one_tx_pool(struct ibmvnic_adapter *adapter,
-			     struct ibmvnic_tx_pool *tx_pool)
+static int reset_one_tx_pool(struct ibmvnic_tx_pool *tx_pool)
 {
 	int rc, i;
 
-	rc = reset_long_term_buff(adapter, &tx_pool->long_term_buff);
+	rc = reset_long_term_buff(&tx_pool->long_term_buff);
 	if (rc)
 		return rc;
 
@@ -664,10 +634,10 @@ static int reset_tx_pools(struct ibmvnic_adapter *adapter)
 
 	tx_scrqs = adapter->num_active_tx_pools;
 	for (i = 0; i < tx_scrqs; i++) {
-		rc = reset_one_tx_pool(adapter, &adapter->tso_pool[i]);
+		rc = reset_one_tx_pool(&adapter->tso_pool[i]);
 		if (rc)
 			return rc;
-		rc = reset_one_tx_pool(adapter, &adapter->tx_pool[i]);
+		rc = reset_one_tx_pool(&adapter->tx_pool[i]);
 		if (rc)
 			return rc;
 	}
-- 
2.23.0

