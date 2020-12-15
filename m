Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CABF2DA92D
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 09:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbgLOIa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 03:30:56 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:29954 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725907AbgLOIaz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 03:30:55 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BF8DBZJ021241
        for <netdev@vger.kernel.org>; Tue, 15 Dec 2020 03:30:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=Ppj8S+uxb1b1heyp3pD6eIxgHU3SGqMRm+/cU4jWm9k=;
 b=Krl20srAsoZZQT8ssZ5s3Nl1sT5FA52PfU78mx/+0+2m59hfbnoJuRjMZe4Zv8g5pcsq
 K+Jb+q09/7fIfil/hm+iSP6lcJExDyO6pGFCDmduejnPx+h5HIf/aga/JWrGBmiHJl01
 6/qQofHdKalIaQfran2emoPAHHuKTcYOdjkgXvfVjhjMJw+NTPbO10NdydI2IjlP0EMD
 R3eW4Ubb4G6bxIivPxoX4+ZZWv78Sefyw7qNSs2EexFrVUrKAq+mDJbP1koVfaoru2Os
 YsKwoMFQt9mOPoTRcyu9JRYGOGOMg8uS7Lg2QzkrjDaWIGB2eVZpNVFPaOwtzdtpI5vY 9g== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35eseg8enq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 15 Dec 2020 03:30:13 -0500
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BF8RFgu008203
        for <netdev@vger.kernel.org>; Tue, 15 Dec 2020 08:30:13 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma04dal.us.ibm.com with ESMTP id 35cng93ps0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 15 Dec 2020 08:30:13 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BF8U9TW25493798
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Dec 2020 08:30:09 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B559B7805C;
        Tue, 15 Dec 2020 08:30:09 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5AA2D7805E;
        Tue, 15 Dec 2020 08:30:09 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.80.237.30])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 15 Dec 2020 08:30:09 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net-next] ibmvnic: merge do_change_param_reset into do_reset
Date:   Tue, 15 Dec 2020 02:30:08 -0600
Message-Id: <20201215083008.85601-1-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-15_04:2020-12-11,2020-12-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 spamscore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 bulkscore=0 clxscore=1015 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012150051
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit b27507bb59ed ("net/ibmvnic: unlock rtnl_lock in reset so
linkwatch_event can run") introduced do_change_param_reset function to
solve the rtnl lock issue. Majority of the code in do_change_param_reset
duplicates do_reset. Also, we can handle the rtnl lock issue in do_reset
itself. Hence merge do_change_param_reset back into do_reset to clean up
the code.

Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
---
This patch was accepted into net-next as 16b5f5ce351f but was reverted
in 9f32c27eb4fc to yield to other under-testing patches. Since those
bug fix patches are already accepted, resubmit this one.

 drivers/net/ethernet/ibm/ibmvnic.c | 154 +++++++++--------------------
 1 file changed, 44 insertions(+), 110 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index f302504faa8a..f6d3b20a5361 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1924,92 +1924,6 @@ static int ibmvnic_set_mac(struct net_device *netdev, void *p)
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
-			goto out;
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
-	if (rc) {
-		rc = IBMVNIC_INIT_FAILED;
-		goto out;
-	}
-
-	/* If the adapter was in PROBE state prior to the reset,
-	 * exit here.
-	 */
-	if (reset_state == VNIC_PROBED)
-		goto out;
-
-	rc = ibmvnic_login(netdev);
-	if (rc) {
-		goto out;
-	}
-
-	rc = init_resources(adapter);
-	if (rc)
-		goto out;
-
-	ibmvnic_disable_irqs(adapter);
-
-	adapter->state = VNIC_CLOSED;
-
-	if (reset_state == VNIC_CLOSED)
-		return 0;
-
-	rc = __ibmvnic_open(netdev);
-	if (rc) {
-		rc = IBMVNIC_OPEN_FAILED;
-		goto out;
-	}
-
-	/* refresh device's multicast list */
-	ibmvnic_set_multi(netdev);
-
-	/* kick napi */
-	for (i = 0; i < adapter->req_rx_queues; i++)
-		napi_schedule(&adapter->napi[i]);
-
-out:
-	if (rc)
-		adapter->state = reset_state;
-	return rc;
-}
-
 /**
  * do_reset returns zero if we are able to keep processing reset events, or
  * non-zero if we hit a fatal error and must halt.
@@ -2027,7 +1941,11 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 		   adapter->state, adapter->failover_pending,
 		   rwi->reset_reason, reset_state);
 
-	rtnl_lock();
+	adapter->reset_reason = rwi->reset_reason;
+	/* requestor of VNIC_RESET_CHANGE_PARAM already has the rtnl lock */
+	if (!(adapter->reset_reason == VNIC_RESET_CHANGE_PARAM))
+		rtnl_lock();
+
 	/*
 	 * Now that we have the rtnl lock, clear any pending failover.
 	 * This will ensure ibmvnic_open() has either completed or will
@@ -2037,7 +1955,6 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 		adapter->failover_pending = false;
 
 	netif_carrier_off(netdev);
-	adapter->reset_reason = rwi->reset_reason;
 
 	old_num_rx_queues = adapter->req_rx_queues;
 	old_num_tx_queues = adapter->req_tx_queues;
@@ -2049,25 +1966,37 @@ static int do_reset(struct ibmvnic_adapter *adapter,
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
@@ -2076,7 +2005,9 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 		 */
 		adapter->state = VNIC_PROBED;
 
-		if (adapter->reset_reason == VNIC_RESET_MOBILITY) {
+		if (adapter->reset_reason == VNIC_RESET_CHANGE_PARAM) {
+			rc = init_crq_queue(adapter);
+		} else if (adapter->reset_reason == VNIC_RESET_MOBILITY) {
 			rc = ibmvnic_reenable_crq_queue(adapter);
 			release_sub_crqs(adapter, 1);
 		} else {
@@ -2115,7 +2046,11 @@ static int do_reset(struct ibmvnic_adapter *adapter,
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
@@ -2180,7 +2115,9 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 	/* restore the adapter state if reset failed */
 	if (rc)
 		adapter->state = reset_state;
-	rtnl_unlock();
+	/* requestor of VNIC_RESET_CHANGE_PARAM should still hold the rtnl lock */
+	if (!(adapter->reset_reason == VNIC_RESET_CHANGE_PARAM))
+		rtnl_unlock();
 
 	netdev_dbg(adapter->netdev, "[S:%d FOP:%d] Reset done, rc %d\n",
 		   adapter->state, adapter->failover_pending, rc);
@@ -2311,10 +2248,7 @@ static void __ibmvnic_reset(struct work_struct *work)
 		}
 		spin_unlock_irqrestore(&adapter->state_lock, flags);
 
-		if (rwi->reset_reason == VNIC_RESET_CHANGE_PARAM) {
-			/* CHANGE_PARAM requestor holds rtnl_lock */
-			rc = do_change_param_reset(adapter, rwi, reset_state);
-		} else if (adapter->force_reset_recovery) {
+		if (adapter->force_reset_recovery) {
 			/*
 			 * Since we are doing a hard reset now, clear the
 			 * failover_pending flag so we don't ignore any
-- 
2.23.0

