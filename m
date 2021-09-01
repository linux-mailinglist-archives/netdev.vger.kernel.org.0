Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7E903FD01E
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 02:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242540AbhIAALL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 20:11:11 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52006 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S243416AbhIAAJV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 20:09:21 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 18104KNP130330
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 20:08:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=If8o3BQIwaQdoPbWi02Mb8phsGt6w8vXsylBrgUa14c=;
 b=M8swJQ6/d4B2s8BcIoVasjEjroPmdFng8f4V/pnDa7jn+7nHasZoiHHt2pf5o22fB+UD
 a1F7lzWzuSFcgcGolT4TO5iD9uWWgcEODM2Ps/zpLMn1Aic9YBp3KLIlgnz3XbzY/pYG
 NhC3lfUeqqk/5vJ6qkFvw9CxquvhJoMsEnv1E5QpaOjqahvSK4FXHTRFEYehUdxCyFDI
 UPgt2CPbatEuB0ysFVM+c0kYJTCPexwosQfmW3AqTcgZ8c2mK6tTkH+T6YTzMMEsx1n1
 Aqd1K73BX1ohepbh/QQDXI+bc7Secf1yThV3p40El2ZXMnm0THi2wQsqWXaxQeukEWBl fg== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3asxncg2kb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 20:08:24 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18107mT0005491
        for <netdev@vger.kernel.org>; Wed, 1 Sep 2021 00:08:23 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma01dal.us.ibm.com with ESMTP id 3astd0xgwd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 00:08:23 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18108LXk30212446
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Sep 2021 00:08:21 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D1C567805C;
        Wed,  1 Sep 2021 00:08:21 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A165F78066;
        Wed,  1 Sep 2021 00:08:20 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.65.237.107])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  1 Sep 2021 00:08:20 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Brian King <brking@linux.ibm.com>, cforno12@linux.ibm.com,
        Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>
Subject: [PATCH net-next 4/9] ibmvnic: Use/rename local vars in init_tx_pools
Date:   Tue, 31 Aug 2021 17:08:07 -0700
Message-Id: <20210901000812.120968-5-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210901000812.120968-1-sukadev@linux.ibm.com>
References: <20210901000812.120968-1-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: PuaUDDEs5mEAvYkzexOr2n2qiF408H8E
X-Proofpoint-ORIG-GUID: PuaUDDEs5mEAvYkzexOr2n2qiF408H8E
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-31_10:2021-08-31,2021-08-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 mlxscore=0 phishscore=0 priorityscore=1501
 malwarescore=0 mlxlogscore=999 adultscore=0 impostorscore=0 spamscore=0
 clxscore=1015 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2108310133
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use/rename local variables in init_tx_pools() for consistency with
init_rx_pools() and for readability. Also add some comments

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index a611bd3f2539..4c6739b250df 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -777,31 +777,31 @@ static void release_tx_pools(struct ibmvnic_adapter *adapter)
 
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
@@ -811,17 +811,20 @@ static int init_tx_pools(struct net_device *netdev)
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
@@ -835,9 +838,9 @@ static int init_tx_pools(struct net_device *netdev)
 	/* Set num_active_tx_pools early. If we fail below after partial
 	 * allocation, release_tx_pools() will know how many to look for.
 	 */
-	adapter->num_active_tx_pools = tx_subcrqs;
+	adapter->num_active_tx_pools = num_pools;
 
-	for (i = 0; i < tx_subcrqs; i++) {
+	for (i = 0; i < num_pools; i++) {
 		buff_size = adapter->req_mtu + VLAN_HLEN;
 		buff_size = ALIGN(buff_size, L1_CACHE_BYTES);
 
@@ -845,8 +848,7 @@ static int init_tx_pools(struct net_device *netdev)
 			i, adapter->req_tx_entries_per_subcrq, buff_size);
 
 		rc = init_one_tx_pool(netdev, &adapter->tx_pool[i],
-				      adapter->req_tx_entries_per_subcrq,
-				      buff_size);
+				      pool_size, buff_size);
 		if (rc) {
 			release_tx_pools(adapter);
 			return rc;
-- 
2.31.1

