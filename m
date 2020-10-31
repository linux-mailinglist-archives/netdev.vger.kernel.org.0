Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6DD52A14F4
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 10:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbgJaJqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 05:46:49 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:17882 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726451AbgJaJqt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 05:46:49 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09V9VFh7068436
        for <netdev@vger.kernel.org>; Sat, 31 Oct 2020 05:46:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=FURJg89Na+QYhw0UIsR7JteF8en0CtPYX4W0tEq2SE4=;
 b=eav+Zt3Dg68r7C5TimiS+BQEqnBTy7SGsUY0sFCLlO3JoC4PCWMsJayV71p9vjJIvXHa
 3wQx/COUh7LyLlblujj/yR67zYI+M0lQsYFC/bhaiRSYoUv5ZJJawtUkF0wQIt4JNEPY
 s51bD4j2oNbiR9akQlDSf2R6m7AX9Td+rNpx0n45ViR2l2dayy/YIksFOQe5/YDNwWlS
 Foytg7Fu9CwPv6Vl2koEuaUfqehMG5Yt6aIAOio2PYpeak+a4VSktkCTCcYSqProwfRm
 YMS87ZkFDHp1LvdP5OqB4lokVzJ44x/SvzYibPeaT5RsI9P+p5Gnt3BDzD3p4NzZO3ri Rw== 
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34h3wq1uv4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 31 Oct 2020 05:46:47 -0400
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09V9fbex022470
        for <netdev@vger.kernel.org>; Sat, 31 Oct 2020 09:46:46 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma04wdc.us.ibm.com with ESMTP id 34h0egt6ja-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 31 Oct 2020 09:46:46 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09V9kkTg38404452
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 31 Oct 2020 09:46:46 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 10AAEB2065;
        Sat, 31 Oct 2020 09:46:46 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AFFE0B2064;
        Sat, 31 Oct 2020 09:46:45 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.187.5])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Sat, 31 Oct 2020 09:46:45 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     sukadev@linux.ibm.com, drt@linux.ibm.com,
        Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net-next] ibmvnic: merge do_change_param_reset into do_reset
Date:   Sat, 31 Oct 2020 04:46:45 -0500
Message-Id: <20201031094645.17255-1-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-31_04:2020-10-30,2020-10-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 malwarescore=0 adultscore=0 clxscore=1015
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010310074
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit b27507bb59ed ("net/ibmvnic: unlock rtnl_lock in reset so
linkwatch_event can run") introduced do_change_param_reset function to
solve the rtnl lock issue. Majority of the code in do_change_param_reset
duplicates do_reset. Also, we can handle the rtnl lock issue in do_reset
itself. Hence merge do_change_param_reset back into do_reset to clean up
the code.

Fixes: b27507bb59ed ("net/ibmvnic: unlock rtnl_lock in reset so linkwatch_event can run")
Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 147 +++++++++--------------------
 1 file changed, 43 insertions(+), 104 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 8148f796a807..9b35cb46a97c 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1822,86 +1822,6 @@ static int ibmvnic_set_mac(struct net_device *netdev, void *p)
 	return rc;
 }
 
-/**
- * do_change_param_reset returns zero if we are able to keep processing reset
- * events, or non-zero if we hit a fatal error and must halt.
- */
-static int do_change_param_reset(struct ibmvnic_adapter *adapter,
-				 struct ibmvnic_rwi *rwi,
-				 u32 reset_state)
-{
-	struct net_device *netdev = adapter->netdev;
-	int i, rc;
-
-	netdev_dbg(adapter->netdev, "Change param resetting driver (%d)\n",
-		   rwi->reset_reason);
-
-	netif_carrier_off(netdev);
-	adapter->reset_reason = rwi->reset_reason;
-
-	ibmvnic_cleanup(netdev);
-
-	if (reset_state == VNIC_OPEN) {
-		rc = __ibmvnic_close(netdev);
-		if (rc)
-			return rc;
-	}
-
-	release_resources(adapter);
-	release_sub_crqs(adapter, 1);
-	release_crq_queue(adapter);
-
-	adapter->state = VNIC_PROBED;
-
-	rc = init_crq_queue(adapter);
-
-	if (rc) {
-		netdev_err(adapter->netdev,
-			   "Couldn't initialize crq. rc=%d\n", rc);
-		return rc;
-	}
-
-	rc = ibmvnic_reset_init(adapter, true);
-	if (rc)
-		return IBMVNIC_INIT_FAILED;
-
-	/* If the adapter was in PROBE state prior to the reset,
-	 * exit here.
-	 */
-	if (reset_state == VNIC_PROBED)
-		return 0;
-
-	rc = ibmvnic_login(netdev);
-	if (rc) {
-		adapter->state = reset_state;
-		return rc;
-	}
-
-	rc = init_resources(adapter);
-	if (rc)
-		return rc;
-
-	ibmvnic_disable_irqs(adapter);
-
-	adapter->state = VNIC_CLOSED;
-
-	if (reset_state == VNIC_CLOSED)
-		return 0;
-
-	rc = __ibmvnic_open(netdev);
-	if (rc)
-		return IBMVNIC_OPEN_FAILED;
-
-	/* refresh device's multicast list */
-	ibmvnic_set_multi(netdev);
-
-	/* kick napi */
-	for (i = 0; i < adapter->req_rx_queues; i++)
-		napi_schedule(&adapter->napi[i]);
-
-	return 0;
-}
-
 /**
  * do_reset returns zero if we are able to keep processing reset events, or
  * non-zero if we hit a fatal error and must halt.
@@ -1917,10 +1837,12 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 	netdev_dbg(adapter->netdev, "Re-setting driver (%d)\n",
 		   rwi->reset_reason);
 
-	rtnl_lock();
+	adapter->reset_reason = rwi->reset_reason;
+	/* requestor of VNIC_RESET_CHANGE_PARAM already has the rtnl lock */
+	if (!(adapter->reset_reason == VNIC_RESET_CHANGE_PARAM))
+		rtnl_lock();
 
 	netif_carrier_off(netdev);
-	adapter->reset_reason = rwi->reset_reason;
 
 	old_num_rx_queues = adapter->req_rx_queues;
 	old_num_tx_queues = adapter->req_tx_queues;
@@ -1932,25 +1854,37 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 	if (reset_state == VNIC_OPEN &&
 	    adapter->reset_reason != VNIC_RESET_MOBILITY &&
 	    adapter->reset_reason != VNIC_RESET_FAILOVER) {
-		adapter->state = VNIC_CLOSING;
+		if (adapter->reset_reason == VNIC_RESET_CHANGE_PARAM) {
+			rc = __ibmvnic_close(netdev);
+			if (rc)
+				goto out;
+		} else {
+			adapter->state = VNIC_CLOSING;
 
-		/* Release the RTNL lock before link state change and
-		 * re-acquire after the link state change to allow
-		 * linkwatch_event to grab the RTNL lock and run during
-		 * a reset.
-		 */
-		rtnl_unlock();
-		rc = set_link_state(adapter, IBMVNIC_LOGICAL_LNK_DN);
-		rtnl_lock();
-		if (rc)
-			goto out;
+			/* Release the RTNL lock before link state change and
+			 * re-acquire after the link state change to allow
+			 * linkwatch_event to grab the RTNL lock and run during
+			 * a reset.
+			 */
+			rtnl_unlock();
+			rc = set_link_state(adapter, IBMVNIC_LOGICAL_LNK_DN);
+			rtnl_lock();
+			if (rc)
+				goto out;
 
-		if (adapter->state != VNIC_CLOSING) {
-			rc = -1;
-			goto out;
+			if (adapter->state != VNIC_CLOSING) {
+				rc = -1;
+				goto out;
+			}
+
+			adapter->state = VNIC_CLOSED;
 		}
+	}
 
-		adapter->state = VNIC_CLOSED;
+	if (adapter->reset_reason == VNIC_RESET_CHANGE_PARAM) {
+		release_resources(adapter);
+		release_sub_crqs(adapter, 1);
+		release_crq_queue(adapter);
 	}
 
 	if (adapter->reset_reason != VNIC_RESET_NON_FATAL) {
@@ -1959,7 +1893,9 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 		 */
 		adapter->state = VNIC_PROBED;
 
-		if (adapter->reset_reason == VNIC_RESET_MOBILITY) {
+		if (adapter->reset_reason == VNIC_RESET_CHANGE_PARAM) {
+			rc = init_crq_queue(adapter);
+		} else if (adapter->reset_reason == VNIC_RESET_MOBILITY) {
 			rc = ibmvnic_reenable_crq_queue(adapter);
 			release_sub_crqs(adapter, 1);
 		} else {
@@ -1999,7 +1935,11 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 			goto out;
 		}
 
-		if (adapter->req_rx_queues != old_num_rx_queues ||
+		if (adapter->reset_reason == VNIC_RESET_CHANGE_PARAM) {
+			rc = init_resources(adapter);
+			if (rc)
+				goto out;
+		} else if (adapter->req_rx_queues != old_num_rx_queues ||
 		    adapter->req_tx_queues != old_num_tx_queues ||
 		    adapter->req_rx_add_entries_per_subcrq !=
 		    old_num_rx_slots ||
@@ -2060,7 +2000,9 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 	rc = 0;
 
 out:
-	rtnl_unlock();
+	/* requestor of VNIC_RESET_CHANGE_PARAM should still hold the rtnl lock */
+	if (!(adapter->reset_reason == VNIC_RESET_CHANGE_PARAM))
+		rtnl_unlock();
 
 	return rc;
 }
@@ -2194,10 +2136,7 @@ static void __ibmvnic_reset(struct work_struct *work)
 		}
 		spin_unlock_irqrestore(&adapter->state_lock, flags);
 
-		if (rwi->reset_reason == VNIC_RESET_CHANGE_PARAM) {
-			/* CHANGE_PARAM requestor holds rtnl_lock */
-			rc = do_change_param_reset(adapter, rwi, reset_state);
-		} else if (adapter->force_reset_recovery) {
+		if (adapter->force_reset_recovery) {
 			/* Transport event occurred during previous reset */
 			if (adapter->wait_for_reset) {
 				/* Previous was CHANGE_PARAM; caller locked */
-- 
2.22.0

