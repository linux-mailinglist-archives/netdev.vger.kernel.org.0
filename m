Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 652843FE1B6
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 20:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345768AbhIASHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 14:07:02 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:40502 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235904AbhIASG6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 14:06:58 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 181I2mLq047372
        for <netdev@vger.kernel.org>; Wed, 1 Sep 2021 14:06:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=qK539ZJP6twyLxjqj4LwRUZgKMsNonqGDmsnEYIeWKs=;
 b=Mxr9bHAuHiTysCrV2mu+hsFUebDkDXrjV2NWDIRm5h3kS4YIqa5/e3Yj9+sOHdB3zzyY
 Q+zy0HIuDg/MvmJs9L0UWoezpdp8QMR96LgcGHhbu7QwOyv1sLFZlGtmTaa40RgTbrrf
 Th7wdDP8GSWPJOLJor0w4eFNoJ0oaewqYoV0X4u371X7N1kIvN++IW3ZULXmr5qLLRWo
 3Gaec2ZnXbLaxqhoE2lrColp6MCDkUarep7dlGYsLStSl0PU8NuuEThqchBTQCvEOUhp
 VMcNn9fhft0fdxifivmGfbc7qF66EfVfYoDaYiws/4T46KQ2zGxD65CBsGkIL9kaNlSP Ow== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ate1brtex-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 14:06:01 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 181I3o9p027852
        for <netdev@vger.kernel.org>; Wed, 1 Sep 2021 18:06:00 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma01dal.us.ibm.com with ESMTP id 3atdxw0w8q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 18:06:00 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 181I5wjD49348964
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Sep 2021 18:05:58 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A2618124060;
        Wed,  1 Sep 2021 18:05:58 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 78DC3124052;
        Wed,  1 Sep 2021 18:05:57 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.160.152.143])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  1 Sep 2021 18:05:57 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Brian King <brking@linux.ibm.com>, cforno12@linux.ibm.com,
        Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.vnet.ibm.com>
Subject: [PATCH net-next v2 4/9] ibmvnic: Use/rename local vars in init_tx_pools
Date:   Wed,  1 Sep 2021 11:05:46 -0700
Message-Id: <20210901180551.150126-5-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210901180551.150126-1-sukadev@linux.ibm.com>
References: <20210901180551.150126-1-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ro-wVvob5930JfE3vKWgNGPKj9DgiuVn
X-Proofpoint-ORIG-GUID: ro-wVvob5930JfE3vKWgNGPKj9DgiuVn
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-01_05:2021-09-01,2021-09-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 malwarescore=0 suspectscore=0 lowpriorityscore=0 mlxscore=0 adultscore=0
 spamscore=0 mlxlogscore=999 bulkscore=0 priorityscore=1501 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2108310000
 definitions=main-2109010104
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use/rename local variables in init_tx_pools() for consistency with
init_rx_pools() and for readability. Also add some comments

Reviewed-by: Rick Lindsley <ricklind@linux.vnet.ibm.com>
Reviewed-by: Dany Madden <drt@linux.ibm.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 688489475791..97041b319beb 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -781,31 +781,31 @@ static void release_tx_pools(struct ibmvnic_adapter *adapter)
 
 static int init_one_tx_pool(struct net_device *netdev,
 			    struct ibmvnic_tx_pool *tx_pool,
-			    int num_entries, int buf_size)
+			    int pool_size, int buf_size)
 {
 	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
 	int i;
 
-	tx_pool->tx_buff = kcalloc(num_entries,
+	tx_pool->tx_buff = kcalloc(pool_size,
 				   sizeof(struct ibmvnic_tx_buff),
 				   GFP_KERNEL);
 	if (!tx_pool->tx_buff)
 		return -1;
 
 	if (alloc_long_term_buff(adapter, &tx_pool->long_term_buff,
-				 num_entries * buf_size))
+				 pool_size * buf_size))
 		return -1;
 
-	tx_pool->free_map = kcalloc(num_entries, sizeof(int), GFP_KERNEL);
+	tx_pool->free_map = kcalloc(pool_size, sizeof(int), GFP_KERNEL);
 	if (!tx_pool->free_map)
 		return -1;
 
-	for (i = 0; i < num_entries; i++)
+	for (i = 0; i < pool_size; i++)
 		tx_pool->free_map[i] = i;
 
 	tx_pool->consumer_index = 0;
 	tx_pool->producer_index = 0;
-	tx_pool->num_buffers = num_entries;
+	tx_pool->num_buffers = pool_size;
 	tx_pool->buf_size = buf_size;
 
 	return 0;
@@ -815,17 +815,20 @@ static int init_tx_pools(struct net_device *netdev)
 {
 	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
 	struct device *dev = &adapter->vdev->dev;
-	int tx_subcrqs;
+	int num_pools;
+	u64 pool_size;		/* # of buffers in pool */
 	u64 buff_size;
 	int i, rc;
 
-	tx_subcrqs = adapter->num_active_tx_scrqs;
-	adapter->tx_pool = kcalloc(tx_subcrqs,
+	pool_size = adapter->req_tx_entries_per_subcrq;
+	num_pools = adapter->num_active_tx_scrqs;
+
+	adapter->tx_pool = kcalloc(num_pools,
 				   sizeof(struct ibmvnic_tx_pool), GFP_KERNEL);
 	if (!adapter->tx_pool)
 		return -1;
 
-	adapter->tso_pool = kcalloc(tx_subcrqs,
+	adapter->tso_pool = kcalloc(num_pools,
 				    sizeof(struct ibmvnic_tx_pool), GFP_KERNEL);
 	/* To simplify release_tx_pools() ensure that ->tx_pool and
 	 * ->tso_pool are either both NULL or both non-NULL.
@@ -839,9 +842,9 @@ static int init_tx_pools(struct net_device *netdev)
 	/* Set num_active_tx_pools early. If we fail below after partial
 	 * allocation, release_tx_pools() will know how many to look for.
 	 */
-	adapter->num_active_tx_pools = tx_subcrqs;
+	adapter->num_active_tx_pools = num_pools;
 
-	for (i = 0; i < tx_subcrqs; i++) {
+	for (i = 0; i < num_pools; i++) {
 		buff_size = adapter->req_mtu + VLAN_HLEN;
 		buff_size = ALIGN(buff_size, L1_CACHE_BYTES);
 
@@ -849,8 +852,7 @@ static int init_tx_pools(struct net_device *netdev)
 			i, adapter->req_tx_entries_per_subcrq, buff_size);
 
 		rc = init_one_tx_pool(netdev, &adapter->tx_pool[i],
-				      adapter->req_tx_entries_per_subcrq,
-				      buff_size);
+				      pool_size, buff_size);
 		if (rc) {
 			release_tx_pools(adapter);
 			return rc;
-- 
2.26.2

