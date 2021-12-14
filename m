Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2EEA473C5E
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 06:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbhLNFSJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 00:18:09 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:18072 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229870AbhLNFSI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 00:18:08 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BE3bWl0026865;
        Tue, 14 Dec 2021 05:18:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=I1ki9SS9qqu1LIL4NpZJihDXUWn3V4CDGWaUDF2hucY=;
 b=IM+1s3eBFjPQ+Wu8e7P2YhO9c42tPvs/+O1UhwMFbj68o2pt8XZ0OkioSe7u5qMQ1IqA
 pbFb7/9PwTkltjgc5zEc77tKjAMTJAGNV0mm73G1T5XaUqlacxYeShDVgKWtANHBllNa
 ufvUtD2DkSfEd+8ljw2Fky7+F+opBQMLyTkGdPlxJuEOJR6jM69itdIvsFAosfaNRFhm
 C92vdorLIfTjYunP6BUTtCTKCU+cJOhK7464KE71C+VBSHFevLbJvG7ennwZQseR6P/e
 9KYcdzThJEMoGqUQIbeBhF23KxkeGq8PWI/jJy/5SY0as4wqdYO2wBXr3kTJAQzBne2Z Vg== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cx9ra0070-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Dec 2021 05:18:07 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BE5CBs6021887;
        Tue, 14 Dec 2021 05:18:07 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma03dal.us.ibm.com with ESMTP id 3cvkmasbn8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Dec 2021 05:18:07 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BE5I67T42533328
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 05:18:06 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 05C86AE060;
        Tue, 14 Dec 2021 05:18:06 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9331DAE067;
        Tue, 14 Dec 2021 05:18:05 +0000 (GMT)
Received: from ltcden12-lp23.aus.stglabs.ibm.com (unknown [9.40.195.166])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 14 Dec 2021 05:18:05 +0000 (GMT)
From:   Dany Madden <drt@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     sukadev@linux.ibm.com, ricklind@linux.ibm.com,
        brking@linux.ibm.com, otis@otisroot.com
Subject: [PATCH net 1/2] ibmvnic: Update driver return codes
Date:   Tue, 14 Dec 2021 00:17:47 -0500
Message-Id: <20211214051748.511675-2-drt@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211214051748.511675-1-drt@linux.ibm.com>
References: <20211214051748.511675-1-drt@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: fja1Hw8HC1NmqJK9mYW-rezhrA9Unnbu
X-Proofpoint-ORIG-GUID: fja1Hw8HC1NmqJK9mYW-rezhrA9Unnbu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-14_01,2021-12-13_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 suspectscore=0
 clxscore=1015 phishscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 lowpriorityscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2112140027
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update return codes to be more informative.

Signed-off-by: Jacob Root <otis@otisroot.com>
Signed-off-by: Dany Madden <drt@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 64 ++++++++++++++++--------------
 1 file changed, 34 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 0bb3911dd014..dd2827b0489d 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -308,7 +308,7 @@ static int alloc_long_term_buff(struct ibmvnic_adapter *adapter,
 	if (adapter->fw_done_rc) {
 		dev_err(dev, "Couldn't map LTB, rc = %d\n",
 			adapter->fw_done_rc);
-		rc = -1;
+		rc = -EIO;
 		goto out;
 	}
 	rc = 0;
@@ -540,13 +540,15 @@ static int init_stats_token(struct ibmvnic_adapter *adapter)
 {
 	struct device *dev = &adapter->vdev->dev;
 	dma_addr_t stok;
+	int rc;
 
 	stok = dma_map_single(dev, &adapter->stats,
 			      sizeof(struct ibmvnic_statistics),
 			      DMA_FROM_DEVICE);
-	if (dma_mapping_error(dev, stok)) {
-		dev_err(dev, "Couldn't map stats buffer\n");
-		return -1;
+	rc = dma_mapping_error(dev, stok);
+	if (rc) {
+		dev_err(dev, "Couldn't map stats buffer, rc = %d\n", rc);
+		return rc;
 	}
 
 	adapter->stats_token = stok;
@@ -655,7 +657,7 @@ static int init_rx_pools(struct net_device *netdev)
 	u64 num_pools;
 	u64 pool_size;		/* # of buffers in one pool */
 	u64 buff_size;
-	int i, j;
+	int i, j, rc;
 
 	pool_size = adapter->req_rx_add_entries_per_subcrq;
 	num_pools = adapter->req_rx_queues;
@@ -674,7 +676,7 @@ static int init_rx_pools(struct net_device *netdev)
 				   GFP_KERNEL);
 	if (!adapter->rx_pool) {
 		dev_err(dev, "Failed to allocate rx pools\n");
-		return -1;
+		return -ENOMEM;
 	}
 
 	/* Set num_active_rx_pools early. If we fail below after partial
@@ -697,6 +699,7 @@ static int init_rx_pools(struct net_device *netdev)
 					    GFP_KERNEL);
 		if (!rx_pool->free_map) {
 			dev_err(dev, "Couldn't alloc free_map %d\n", i);
+			rc = -ENOMEM;
 			goto out_release;
 		}
 
@@ -705,6 +708,7 @@ static int init_rx_pools(struct net_device *netdev)
 					   GFP_KERNEL);
 		if (!rx_pool->rx_buff) {
 			dev_err(dev, "Couldn't alloc rx buffers\n");
+			rc = -ENOMEM;
 			goto out_release;
 		}
 	}
@@ -718,8 +722,9 @@ static int init_rx_pools(struct net_device *netdev)
 		dev_dbg(dev, "Updating LTB for rx pool %d [%d, %d]\n",
 			i, rx_pool->size, rx_pool->buff_size);
 
-		if (alloc_long_term_buff(adapter, &rx_pool->long_term_buff,
-					 rx_pool->size * rx_pool->buff_size))
+		rc = alloc_long_term_buff(adapter, &rx_pool->long_term_buff,
+					  rx_pool->size * rx_pool->buff_size);
+		if (rc)
 			goto out;
 
 		for (j = 0; j < rx_pool->size; ++j) {
@@ -756,7 +761,7 @@ static int init_rx_pools(struct net_device *netdev)
 	/* We failed to allocate one or more LTBs or map them on the VIOS.
 	 * Hold onto the pools and any LTBs that we did allocate/map.
 	 */
-	return -1;
+	return rc;
 }
 
 static void release_vpd_data(struct ibmvnic_adapter *adapter)
@@ -817,13 +822,13 @@ static int init_one_tx_pool(struct net_device *netdev,
 				   sizeof(struct ibmvnic_tx_buff),
 				   GFP_KERNEL);
 	if (!tx_pool->tx_buff)
-		return -1;
+		return -ENOMEM;
 
 	tx_pool->free_map = kcalloc(pool_size, sizeof(int), GFP_KERNEL);
 	if (!tx_pool->free_map) {
 		kfree(tx_pool->tx_buff);
 		tx_pool->tx_buff = NULL;
-		return -1;
+		return -ENOMEM;
 	}
 
 	for (i = 0; i < pool_size; i++)
@@ -914,7 +919,7 @@ static int init_tx_pools(struct net_device *netdev)
 	adapter->tx_pool = kcalloc(num_pools,
 				   sizeof(struct ibmvnic_tx_pool), GFP_KERNEL);
 	if (!adapter->tx_pool)
-		return -1;
+		return -ENOMEM;
 
 	adapter->tso_pool = kcalloc(num_pools,
 				    sizeof(struct ibmvnic_tx_pool), GFP_KERNEL);
@@ -924,7 +929,7 @@ static int init_tx_pools(struct net_device *netdev)
 	if (!adapter->tso_pool) {
 		kfree(adapter->tx_pool);
 		adapter->tx_pool = NULL;
-		return -1;
+		return -ENOMEM;
 	}
 
 	/* Set num_active_tx_pools early. If we fail below after partial
@@ -1113,7 +1118,7 @@ static int ibmvnic_login(struct net_device *netdev)
 		retry = false;
 		if (retry_count > retries) {
 			netdev_warn(netdev, "Login attempts exceeded\n");
-			return -1;
+			return -EACCES;
 		}
 
 		adapter->init_done_rc = 0;
@@ -1154,25 +1159,26 @@ static int ibmvnic_login(struct net_device *netdev)
 							 timeout)) {
 				netdev_warn(netdev,
 					    "Capabilities query timed out\n");
-				return -1;
+				return -ETIMEDOUT;
 			}
 
 			rc = init_sub_crqs(adapter);
 			if (rc) {
 				netdev_warn(netdev,
 					    "SCRQ initialization failed\n");
-				return -1;
+				return rc;
 			}
 
 			rc = init_sub_crq_irqs(adapter);
 			if (rc) {
 				netdev_warn(netdev,
 					    "SCRQ irq initialization failed\n");
-				return -1;
+				return rc;
 			}
 		} else if (adapter->init_done_rc) {
-			netdev_warn(netdev, "Adapter login failed\n");
-			return -1;
+			netdev_warn(netdev, "Adapter login failed, init_done_rc = %d\n",
+				    adapter->init_done_rc);
+			return -EIO;
 		}
 	} while (retry);
 
@@ -1231,7 +1237,7 @@ static int set_link_state(struct ibmvnic_adapter *adapter, u8 link_state)
 		if (!wait_for_completion_timeout(&adapter->init_done,
 						 timeout)) {
 			netdev_err(netdev, "timeout setting link state\n");
-			return -1;
+			return -ETIMEDOUT;
 		}
 
 		if (adapter->init_done_rc == PARTIALSUCCESS) {
@@ -2288,7 +2294,7 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 				/* If someone else changed the adapter state
 				 * when we dropped the rtnl, fail the reset
 				 */
-				rc = -1;
+				rc = -EAGAIN;
 				goto out;
 			}
 			adapter->state = VNIC_CLOSED;
@@ -2330,10 +2336,8 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 		}
 
 		rc = ibmvnic_reset_init(adapter, true);
-		if (rc) {
-			rc = IBMVNIC_INIT_FAILED;
+		if (rc)
 			goto out;
-		}
 
 		/* If the adapter was in PROBE or DOWN state prior to the reset,
 		 * exit here.
@@ -3759,7 +3763,7 @@ static int init_sub_crqs(struct ibmvnic_adapter *adapter)
 
 	allqueues = kcalloc(total_queues, sizeof(*allqueues), GFP_KERNEL);
 	if (!allqueues)
-		return -1;
+		return -ENOMEM;
 
 	for (i = 0; i < total_queues; i++) {
 		allqueues[i] = init_sub_crq_queue(adapter);
@@ -3828,7 +3832,7 @@ static int init_sub_crqs(struct ibmvnic_adapter *adapter)
 	for (i = 0; i < registered_queues; i++)
 		release_sub_crq_queue(adapter, allqueues[i], 1);
 	kfree(allqueues);
-	return -1;
+	return -ENOMEM;
 }
 
 static void send_request_cap(struct ibmvnic_adapter *adapter, int retry)
@@ -4187,7 +4191,7 @@ static int send_login(struct ibmvnic_adapter *adapter)
 	if (!adapter->tx_scrq || !adapter->rx_scrq) {
 		netdev_err(adapter->netdev,
 			   "RX or TX queues are not allocated, device login failed\n");
-		return -1;
+		return -ENOMEM;
 	}
 
 	release_login_buffer(adapter);
@@ -4307,7 +4311,7 @@ static int send_login(struct ibmvnic_adapter *adapter)
 	kfree(login_buffer);
 	adapter->login_buf = NULL;
 buf_alloc_failed:
-	return -1;
+	return -ENOMEM;
 }
 
 static int send_request_map(struct ibmvnic_adapter *adapter, dma_addr_t addr,
@@ -5628,7 +5632,7 @@ static int ibmvnic_reset_init(struct ibmvnic_adapter *adapter, bool reset)
 
 	if (!wait_for_completion_timeout(&adapter->init_done, timeout)) {
 		dev_err(dev, "Initialization sequence timed out\n");
-		return -1;
+		return -ETIMEDOUT;
 	}
 
 	if (adapter->init_done_rc) {
@@ -5639,7 +5643,7 @@ static int ibmvnic_reset_init(struct ibmvnic_adapter *adapter, bool reset)
 	if (adapter->from_passive_init) {
 		adapter->state = VNIC_OPEN;
 		adapter->from_passive_init = false;
-		return -1;
+		return -EINVAL;
 	}
 
 	if (reset &&
-- 
2.27.0

