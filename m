Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F12240BE9E
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 05:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236502AbhIODyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 23:54:50 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49624 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236495AbhIODy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 23:54:27 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 18ENxhhw026824
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 23:53:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=M6wOHtzBzQR8PzwJII4hlzFN1NNx5ohs41Ao5oYuLo4=;
 b=MrPwLJk74tnqkfmL7i+nJiMnSciOOT9AINxl00Rtij3IKWEcHbme7u+Uedeq5/72QtvC
 Wbl51cQX2CHZkNxjajQRK0zlArh1Nmz8pPce71PTK21mjxBZP5oy8CbbUXAKPqBREYyT
 kcjDgmlPb4nB62czr9Jk/b8fU+mT0HSbO2nZs6HbeoQC7YLsayldnvjjkX2cobz22nYK
 zXonrsE6GyHLWcNQniU9iPJf/hSNhOvBfUsyh8Eo2ETIY3hl59KtboR2dCTiXt+GqL8V
 gUw3ncJKn/W3h38wz5k3KM4ceevZBODVA6KV2TQTVbwVA+JXIAA1MA6eWbItEeOXx96e Vg== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b35wabnue-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 23:53:09 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18F3lPU2006021
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 03:53:07 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma03wdc.us.ibm.com with ESMTP id 3b0m3b84xk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 03:53:07 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18F3r7m937159316
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Sep 2021 03:53:07 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3957E112063;
        Wed, 15 Sep 2021 03:53:07 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 976FB112061;
        Wed, 15 Sep 2021 03:53:05 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.77.142.77])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 15 Sep 2021 03:53:05 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Brian King <brking@linux.ibm.com>, cforno12@linux.ibm.com,
        Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.vnet.ibm.com>
Subject: [PATCH net-next RESEND v2 3/9] ibmvnic: Use/rename local vars in init_rx_pools
Date:   Tue, 14 Sep 2021 20:52:53 -0700
Message-Id: <20210915035259.355092-4-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210915035259.355092-1-sukadev@linux.ibm.com>
References: <20210915035259.355092-1-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0aQpEKIb5s4AscG0YtFfc3L_7Ao5J_MG
X-Proofpoint-GUID: 0aQpEKIb5s4AscG0YtFfc3L_7Ao5J_MG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.687,Hydra:6.0.235,FMLib:17.0.607.475
 definitions=2020-10-13_15,2020-10-13_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 impostorscore=0 malwarescore=0
 adultscore=0 mlxlogscore=999 priorityscore=1501 clxscore=1015
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109140133
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

