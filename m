Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6B685127B8
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 01:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233743AbiD0Xwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 19:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230362AbiD0Xwt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 19:52:49 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2479B3192A
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 16:49:36 -0700 (PDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23RNfp6h025120
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 23:49:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=usS7xMhGCtUd+GqbhobakN1f7zkZ+X8+RJznNXDDduI=;
 b=p0K+U2Qe7EU+qyGrmLBUpXedUx7CiyvpmFlX1ba+nC53bJ73M8j5TNlnZeqQ0Ys64pf6
 u+g1RSnT2ogZg5RSdyTqXXus21emn25gu9uEjUHKl/q7kNipSEl52W3bq+yaaegP/dWw
 m2mabjKZgtsbWcFxGvNGC2SnZ9KgUCaMrlu2Gbf81yOknniX4x/uUIA0nIvVQNIdmcGt
 PnzY7YnspuH3aRFOk0p/MrD0roZSc7o0icozo5DimKus3p5AS6ZZo/KLJCIl0ZU8u3IA
 8BTsSYngmYmvN5B6oC+xjk7HxbLfSrDbuKUUZQaK1Tq0GKxlPbnkVQwkzsfHKyxJLsZD NQ== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fqfqpr33c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 23:49:35 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23RNceYB031059
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 23:49:34 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma02wdc.us.ibm.com with ESMTP id 3fm939yf55-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 23:49:34 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23RNnXqZ44499242
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Apr 2022 23:49:33 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B3FF6124053;
        Wed, 27 Apr 2022 23:49:33 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 78C29124058;
        Wed, 27 Apr 2022 23:49:33 +0000 (GMT)
Received: from ltcden12-lp22.aus.stglabs.ibm.com (unknown [9.40.195.165])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 27 Apr 2022 23:49:33 +0000 (GMT)
From:   Dany Madden <drt@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     tlfalcon@linux.ibm.com
Subject: [PATCH net] Revert "ibmvnic: Add ethtool private flag for driver-defined queue limits"
Date:   Wed, 27 Apr 2022 18:51:46 -0500
Message-Id: <20220427235146.23189-1-drt@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Bhve7_w7M729rw2qbIPefbmXHFPeRf9m
X-Proofpoint-GUID: Bhve7_w7M729rw2qbIPefbmXHFPeRf9m
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-27_04,2022-04-27_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0 malwarescore=0
 impostorscore=0 suspectscore=0 clxscore=1015 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204270137
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 723ad916134784b317b72f3f6cf0f7ba774e5dae

When client requests channel or ring size larger than what the server
can support the server will cap the request to the supported max. So,
the client would not be able to successfully request resources that
exceed the server limit.

Fixes: 723ad9161347 ("ibmvnic: Add ethtool private flag for driver-defined queue limits")
Signed-off-by: Dany Madden <drt@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 129 ++++++++---------------------
 drivers/net/ethernet/ibm/ibmvnic.h |   6 --
 2 files changed, 35 insertions(+), 100 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 77683909ca3d..5c5931dba51d 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -3210,13 +3210,8 @@ static void ibmvnic_get_ringparam(struct net_device *netdev,
 {
 	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
 
-	if (adapter->priv_flags & IBMVNIC_USE_SERVER_MAXES) {
-		ring->rx_max_pending = adapter->max_rx_add_entries_per_subcrq;
-		ring->tx_max_pending = adapter->max_tx_entries_per_subcrq;
-	} else {
-		ring->rx_max_pending = IBMVNIC_MAX_QUEUE_SZ;
-		ring->tx_max_pending = IBMVNIC_MAX_QUEUE_SZ;
-	}
+	ring->rx_max_pending = adapter->max_rx_add_entries_per_subcrq;
+	ring->tx_max_pending = adapter->max_tx_entries_per_subcrq;
 	ring->rx_mini_max_pending = 0;
 	ring->rx_jumbo_max_pending = 0;
 	ring->rx_pending = adapter->req_rx_add_entries_per_subcrq;
@@ -3231,23 +3226,21 @@ static int ibmvnic_set_ringparam(struct net_device *netdev,
 				 struct netlink_ext_ack *extack)
 {
 	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
-	int ret;
 
-	ret = 0;
+	if (ring->rx_pending > adapter->max_rx_add_entries_per_subcrq  ||
+	    ring->tx_pending > adapter->max_tx_entries_per_subcrq) {
+		netdev_err(netdev, "Invalid request.\n");
+		netdev_err(netdev, "Max tx buffers = %llu\n",
+			   adapter->max_rx_add_entries_per_subcrq);
+		netdev_err(netdev, "Max rx buffers = %llu\n",
+			   adapter->max_tx_entries_per_subcrq);
+		return -EINVAL;
+	}
+
 	adapter->desired.rx_entries = ring->rx_pending;
 	adapter->desired.tx_entries = ring->tx_pending;
 
-	ret = wait_for_reset(adapter);
-
-	if (!ret &&
-	    (adapter->req_rx_add_entries_per_subcrq != ring->rx_pending ||
-	     adapter->req_tx_entries_per_subcrq != ring->tx_pending))
-		netdev_info(netdev,
-			    "Could not match full ringsize request. Requested: RX %d, TX %d; Allowed: RX %llu, TX %llu\n",
-			    ring->rx_pending, ring->tx_pending,
-			    adapter->req_rx_add_entries_per_subcrq,
-			    adapter->req_tx_entries_per_subcrq);
-	return ret;
+	return wait_for_reset(adapter);
 }
 
 static void ibmvnic_get_channels(struct net_device *netdev,
@@ -3255,14 +3248,8 @@ static void ibmvnic_get_channels(struct net_device *netdev,
 {
 	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
 
-	if (adapter->priv_flags & IBMVNIC_USE_SERVER_MAXES) {
-		channels->max_rx = adapter->max_rx_queues;
-		channels->max_tx = adapter->max_tx_queues;
-	} else {
-		channels->max_rx = IBMVNIC_MAX_QUEUES;
-		channels->max_tx = IBMVNIC_MAX_QUEUES;
-	}
-
+	channels->max_rx = adapter->max_rx_queues;
+	channels->max_tx = adapter->max_tx_queues;
 	channels->max_other = 0;
 	channels->max_combined = 0;
 	channels->rx_count = adapter->req_rx_queues;
@@ -3275,22 +3262,11 @@ static int ibmvnic_set_channels(struct net_device *netdev,
 				struct ethtool_channels *channels)
 {
 	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
-	int ret;
 
-	ret = 0;
 	adapter->desired.rx_queues = channels->rx_count;
 	adapter->desired.tx_queues = channels->tx_count;
 
-	ret = wait_for_reset(adapter);
-
-	if (!ret &&
-	    (adapter->req_rx_queues != channels->rx_count ||
-	     adapter->req_tx_queues != channels->tx_count))
-		netdev_info(netdev,
-			    "Could not match full channels request. Requested: RX %d, TX %d; Allowed: RX %llu, TX %llu\n",
-			    channels->rx_count, channels->tx_count,
-			    adapter->req_rx_queues, adapter->req_tx_queues);
-	return ret;
+	return wait_for_reset(adapter);
 }
 
 static void ibmvnic_get_strings(struct net_device *dev, u32 stringset, u8 *data)
@@ -3298,43 +3274,32 @@ static void ibmvnic_get_strings(struct net_device *dev, u32 stringset, u8 *data)
 	struct ibmvnic_adapter *adapter = netdev_priv(dev);
 	int i;
 
-	switch (stringset) {
-	case ETH_SS_STATS:
-		for (i = 0; i < ARRAY_SIZE(ibmvnic_stats);
-				i++, data += ETH_GSTRING_LEN)
-			memcpy(data, ibmvnic_stats[i].name, ETH_GSTRING_LEN);
+	if (stringset != ETH_SS_STATS)
+		return;
 
-		for (i = 0; i < adapter->req_tx_queues; i++) {
-			snprintf(data, ETH_GSTRING_LEN, "tx%d_packets", i);
-			data += ETH_GSTRING_LEN;
+	for (i = 0; i < ARRAY_SIZE(ibmvnic_stats); i++, data += ETH_GSTRING_LEN)
+		memcpy(data, ibmvnic_stats[i].name, ETH_GSTRING_LEN);
 
-			snprintf(data, ETH_GSTRING_LEN, "tx%d_bytes", i);
-			data += ETH_GSTRING_LEN;
+	for (i = 0; i < adapter->req_tx_queues; i++) {
+		snprintf(data, ETH_GSTRING_LEN, "tx%d_packets", i);
+		data += ETH_GSTRING_LEN;
 
-			snprintf(data, ETH_GSTRING_LEN,
-				 "tx%d_dropped_packets", i);
-			data += ETH_GSTRING_LEN;
-		}
+		snprintf(data, ETH_GSTRING_LEN, "tx%d_bytes", i);
+		data += ETH_GSTRING_LEN;
 
-		for (i = 0; i < adapter->req_rx_queues; i++) {
-			snprintf(data, ETH_GSTRING_LEN, "rx%d_packets", i);
-			data += ETH_GSTRING_LEN;
+		snprintf(data, ETH_GSTRING_LEN, "tx%d_dropped_packets", i);
+		data += ETH_GSTRING_LEN;
+	}
 
-			snprintf(data, ETH_GSTRING_LEN, "rx%d_bytes", i);
-			data += ETH_GSTRING_LEN;
+	for (i = 0; i < adapter->req_rx_queues; i++) {
+		snprintf(data, ETH_GSTRING_LEN, "rx%d_packets", i);
+		data += ETH_GSTRING_LEN;
 
-			snprintf(data, ETH_GSTRING_LEN, "rx%d_interrupts", i);
-			data += ETH_GSTRING_LEN;
-		}
-		break;
+		snprintf(data, ETH_GSTRING_LEN, "rx%d_bytes", i);
+		data += ETH_GSTRING_LEN;
 
-	case ETH_SS_PRIV_FLAGS:
-		for (i = 0; i < ARRAY_SIZE(ibmvnic_priv_flags); i++)
-			strcpy(data + i * ETH_GSTRING_LEN,
-			       ibmvnic_priv_flags[i]);
-		break;
-	default:
-		return;
+		snprintf(data, ETH_GSTRING_LEN, "rx%d_interrupts", i);
+		data += ETH_GSTRING_LEN;
 	}
 }
 
@@ -3347,8 +3312,6 @@ static int ibmvnic_get_sset_count(struct net_device *dev, int sset)
 		return ARRAY_SIZE(ibmvnic_stats) +
 		       adapter->req_tx_queues * NUM_TX_STATS +
 		       adapter->req_rx_queues * NUM_RX_STATS;
-	case ETH_SS_PRIV_FLAGS:
-		return ARRAY_SIZE(ibmvnic_priv_flags);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -3401,26 +3364,6 @@ static void ibmvnic_get_ethtool_stats(struct net_device *dev,
 	}
 }
 
-static u32 ibmvnic_get_priv_flags(struct net_device *netdev)
-{
-	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
-
-	return adapter->priv_flags;
-}
-
-static int ibmvnic_set_priv_flags(struct net_device *netdev, u32 flags)
-{
-	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
-	bool which_maxes = !!(flags & IBMVNIC_USE_SERVER_MAXES);
-
-	if (which_maxes)
-		adapter->priv_flags |= IBMVNIC_USE_SERVER_MAXES;
-	else
-		adapter->priv_flags &= ~IBMVNIC_USE_SERVER_MAXES;
-
-	return 0;
-}
-
 static const struct ethtool_ops ibmvnic_ethtool_ops = {
 	.get_drvinfo		= ibmvnic_get_drvinfo,
 	.get_msglevel		= ibmvnic_get_msglevel,
@@ -3434,8 +3377,6 @@ static const struct ethtool_ops ibmvnic_ethtool_ops = {
 	.get_sset_count         = ibmvnic_get_sset_count,
 	.get_ethtool_stats	= ibmvnic_get_ethtool_stats,
 	.get_link_ksettings	= ibmvnic_get_link_ksettings,
-	.get_priv_flags		= ibmvnic_get_priv_flags,
-	.set_priv_flags		= ibmvnic_set_priv_flags,
 };
 
 /* Routines for managing CRQs/sCRQs  */
diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index 8f5cefb932dd..1310c861bf83 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -41,11 +41,6 @@
 
 #define IBMVNIC_RESET_DELAY 100
 
-static const char ibmvnic_priv_flags[][ETH_GSTRING_LEN] = {
-#define IBMVNIC_USE_SERVER_MAXES 0x1
-	"use-server-maxes"
-};
-
 struct ibmvnic_login_buffer {
 	__be32 len;
 	__be32 version;
@@ -883,7 +878,6 @@ struct ibmvnic_adapter {
 	struct ibmvnic_control_ip_offload_buffer ip_offload_ctrl;
 	dma_addr_t ip_offload_ctrl_tok;
 	u32 msg_enable;
-	u32 priv_flags;
 
 	/* Vital Product Data (VPD) */
 	struct ibmvnic_vpd *vpd;
-- 
2.26.2

