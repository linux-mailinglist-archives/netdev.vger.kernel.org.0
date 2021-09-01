Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9983FD01D
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 02:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242495AbhIAAK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 20:10:59 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:24964 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243393AbhIAAJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 20:09:18 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 18103iB9011628
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 20:08:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=hCsVQbs2OJC2ekzFDlYFH6MX7lTssgTX45sVMA8Jyok=;
 b=kC5POOdVZJYL6fNKQZT3nsTJp0iinvz8BuvnkvKUZz9lha8hOMEmvEbCZhvbcbBTRG0P
 9l+VUoMMz2gbLT7oVINmjcpC1GCiUtuv+ln3UZyrCvBP9oWgExED8Vu9KiixjCLBgmbw
 EEM5vH4I6xGzxnSYV4Il/6oFtOuvgCgzO7pzXT6OVWgKg7Dc66G3UjhAPGUmc3SVfSZs
 kDek5uYTyb58YH8tThxt/De0w0bccHlAwrCFzU11DabcnOLO2F2tusfxqgnze07fGpZX
 XeXI+zqLQ+E0xxmn/gB28aHZgjIHrMAtRxRvo5oQpN1uzt2ZJ/0sdY4iYdbeahFEzIgz Dw== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3assarypvn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 20:08:22 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17VNvif6013379
        for <netdev@vger.kernel.org>; Wed, 1 Sep 2021 00:08:22 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma02dal.us.ibm.com with ESMTP id 3aqcsdj2sk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 00:08:21 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18108Kvh33882382
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Sep 2021 00:08:20 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E32C7805C;
        Wed,  1 Sep 2021 00:08:20 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0CA3A78066;
        Wed,  1 Sep 2021 00:08:19 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.65.237.107])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  1 Sep 2021 00:08:18 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Brian King <brking@linux.ibm.com>, cforno12@linux.ibm.com,
        Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>
Subject: [PATCH net-next 3/9] ibmvnic: Use/rename local vars in init_rx_pools
Date:   Tue, 31 Aug 2021 17:08:06 -0700
Message-Id: <20210901000812.120968-4-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210901000812.120968-1-sukadev@linux.ibm.com>
References: <20210901000812.120968-1-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: cGwELd8gNkZq9E50gcSt_l26sCg2ESOC
X-Proofpoint-GUID: cGwELd8gNkZq9E50gcSt_l26sCg2ESOC
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-31_10:2021-08-31,2021-08-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 mlxscore=0 spamscore=0 phishscore=0 priorityscore=1501 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108310133
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To make the code more readable, use/rename some local variables.
Basically we have a set of pools, num_pools. Each pool has a set of
buffers, pool_size and each buffer is of size buff_size.

pool_size is a bit ambiguous (whether size in bytes or buffers). Add
a comment in the header file to make it explicit.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 17 +++++++++--------
 drivers/net/ethernet/ibm/ibmvnic.h |  2 +-
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 911315b10731..a611bd3f2539 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -618,14 +618,16 @@ static int init_rx_pools(struct net_device *netdev)
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
@@ -636,17 +638,16 @@ static int init_rx_pools(struct net_device *netdev)
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
2.31.1

