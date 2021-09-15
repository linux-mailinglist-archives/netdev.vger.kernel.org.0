Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7E8240BE9F
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 05:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236505AbhIODyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 23:54:51 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46498 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236507AbhIODyb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 23:54:31 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 18F1xtox021443
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 23:53:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=qK539ZJP6twyLxjqj4LwRUZgKMsNonqGDmsnEYIeWKs=;
 b=iaJ0HbAQMDs/YHG37LbBfvH6AHWXTWaaD/xcqcYbJEduVR7hGFV4KG2q0adV7K77QbHa
 7RWukRgg8qPPzfa8M0hwaHEo+gOwAx6RIkv+KTQLNcwE0QFf1zN7uDmQi4h8m55cdH5u
 oNVEsd+rJsc9lrsbJPeH17ShSpvlbRh745kwG+4qKXs0jxMiL7bs2FbyO9177fiCX1T5
 CbsRaU4ZQA5SP6c1d3Rm2Wr0SdECxDsWvw6sm4sWWKpm3F/iXLQOFkqCiqt+mXFBlx9X
 aDzEm2MEZCqLfANoWfI8HKt7BWydtmYFvq9fNA9m0E5pUHlmIYvD6lrT7Q/1MhCHway3 nw== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b37nn1kht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 23:53:11 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18F3lpjN024768
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 03:53:11 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma02dal.us.ibm.com with ESMTP id 3b0m3bhjq7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 03:53:11 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18F3rATZ51642630
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Sep 2021 03:53:10 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DC3E3112061;
        Wed, 15 Sep 2021 03:53:09 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9CEA0112067;
        Wed, 15 Sep 2021 03:53:07 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.77.142.77])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 15 Sep 2021 03:53:07 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Brian King <brking@linux.ibm.com>, cforno12@linux.ibm.com,
        Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.vnet.ibm.com>
Subject: [PATCH net-next RESEND v2 4/9] ibmvnic: Use/rename local vars in init_tx_pools
Date:   Tue, 14 Sep 2021 20:52:54 -0700
Message-Id: <20210915035259.355092-5-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210915035259.355092-1-sukadev@linux.ibm.com>
References: <20210915035259.355092-1-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: UTi3XRGhVFbCfuw87pWeTbhQO7QAR0WL
X-Proofpoint-GUID: UTi3XRGhVFbCfuw87pWeTbhQO7QAR0WL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.687,Hydra:6.0.235,FMLib:17.0.607.475
 definitions=2020-10-13_15,2020-10-13_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 bulkscore=0 impostorscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 lowpriorityscore=0 suspectscore=0 spamscore=0 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109150000
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

