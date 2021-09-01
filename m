Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 036513FE1B5
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 20:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345537AbhIASG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 14:06:59 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:53122 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345478AbhIASG4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 14:06:56 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 181I3gQV187461
        for <netdev@vger.kernel.org>; Wed, 1 Sep 2021 14:06:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=M6wOHtzBzQR8PzwJII4hlzFN1NNx5ohs41Ao5oYuLo4=;
 b=hWgIWQi2V/Teb2wjr3DWHQLXXvPh5ow54sRME2Tbm0BRsxYHH2iAcOpP7t5wEb3qFw1p
 UjVlpt09bN8Vl3ll62LhuFDpz0eKyM2pZyIVOYBlroJ7pbRjRRsbXJqnzKFhgAqSjXjD
 JR2Ilqpm/MSxxW+QzMH1/+YxluJjxk4cX7Ch6lWzvf5s9pZX6HbIqK4qzvjcsCcpE9Nl
 DczrrQw/I7JPshR+hL409xFX8+FqrWpCpuCNLjzUd9gHoF5cgckpxpeVV71Pk/0hBBdi
 RBWf2NWEurzt/CIhlJ0EjySARonpHyuoRp+58BuP/h1ui19Lz7k9AE1W+sFJaGssemq4 Ug== 
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ated288bs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 14:05:59 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 181I2mXe007583
        for <netdev@vger.kernel.org>; Wed, 1 Sep 2021 18:05:58 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma05wdc.us.ibm.com with ESMTP id 3atdxd0r6t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 18:05:58 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 181I5vj78126988
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Sep 2021 18:05:57 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2F32512405A;
        Wed,  1 Sep 2021 18:05:57 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1ACF2124054;
        Wed,  1 Sep 2021 18:05:56 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.160.152.143])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  1 Sep 2021 18:05:55 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Brian King <brking@linux.ibm.com>, cforno12@linux.ibm.com,
        Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.vnet.ibm.com>
Subject: [PATCH net-next v2 3/9] ibmvnic: Use/rename local vars in init_rx_pools
Date:   Wed,  1 Sep 2021 11:05:45 -0700
Message-Id: <20210901180551.150126-4-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210901180551.150126-1-sukadev@linux.ibm.com>
References: <20210901180551.150126-1-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: hre7hIjIbnUzoX1UhB9N1IK8J0_QmSxu
X-Proofpoint-ORIG-GUID: hre7hIjIbnUzoX1UhB9N1IK8J0_QmSxu
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-01_05:2021-09-01,2021-09-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 clxscore=1015 priorityscore=1501 phishscore=0 spamscore=0 impostorscore=0
 bulkscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2108310000
 definitions=main-2109010104
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To make the code more readable, use/rename some local variables.
Basically we have a set of pools, num_pools. Each pool has a set of
buffers, pool_size and each buffer is of size buff_size.

pool_size is a bit ambiguous (whether size in bytes or buffers). Add
a comment in the header file to make it explicit.

Reviewed-by: Rick Lindsley <ricklind@linux.vnet.ibm.com>
Reviewed-by: Dany Madden <drt@linux.ibm.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 17 +++++++++--------
 drivers/net/ethernet/ibm/ibmvnic.h |  2 +-
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index cd04c3eb6c41..688489475791 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -620,14 +620,16 @@ static int init_rx_pools(struct net_device *netdev)
 	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
 	struct device *dev = &adapter->vdev->dev;
 	struct ibmvnic_rx_pool *rx_pool;
-	int rxadd_subcrqs;
+	u64 num_pools;
+	u64 pool_size;		/* # of buffers in one pool */
 	u64 buff_size;
 	int i, j;
 
-	rxadd_subcrqs = adapter->num_active_rx_scrqs;
+	num_pools = adapter->num_active_rx_scrqs;
+	pool_size = adapter->req_rx_add_entries_per_subcrq;
 	buff_size = adapter->cur_rx_buf_sz;
 
-	adapter->rx_pool = kcalloc(rxadd_subcrqs,
+	adapter->rx_pool = kcalloc(num_pools,
 				   sizeof(struct ibmvnic_rx_pool),
 				   GFP_KERNEL);
 	if (!adapter->rx_pool) {
@@ -638,17 +640,16 @@ static int init_rx_pools(struct net_device *netdev)
 	/* Set num_active_rx_pools early. If we fail below after partial
 	 * allocation, release_rx_pools() will know how many to look for.
 	 */
-	adapter->num_active_rx_pools = rxadd_subcrqs;
+	adapter->num_active_rx_pools = num_pools;
 
-	for (i = 0; i < rxadd_subcrqs; i++) {
+	for (i = 0; i < num_pools; i++) {
 		rx_pool = &adapter->rx_pool[i];
 
 		netdev_dbg(adapter->netdev,
 			   "Initializing rx_pool[%d], %lld buffs, %lld bytes each\n",
-			   i, adapter->req_rx_add_entries_per_subcrq,
-			   buff_size);
+			   i, pool_size, buff_size);
 
-		rx_pool->size = adapter->req_rx_add_entries_per_subcrq;
+		rx_pool->size = pool_size;
 		rx_pool->index = i;
 		rx_pool->buff_size = ALIGN(buff_size, L1_CACHE_BYTES);
 		rx_pool->active = 1;
diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index 22df602323bc..5652566818fb 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -827,7 +827,7 @@ struct ibmvnic_rx_buff {
 
 struct ibmvnic_rx_pool {
 	struct ibmvnic_rx_buff *rx_buff;
-	int size;
+	int size;			/* # of buffers in the pool */
 	int index;
 	int buff_size;
 	atomic_t available;
-- 
2.26.2

