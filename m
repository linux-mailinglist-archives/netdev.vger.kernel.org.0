Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2AFD2AA26C
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 05:45:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727505AbgKGEpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 23:45:19 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:30614 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726880AbgKGEpS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 23:45:18 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A74VFAY152041
        for <netdev@vger.kernel.org>; Fri, 6 Nov 2020 23:45:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=M8vILUdxFa8IU5pdw/3441q6nP4v8s7OUkzQMxsiiTQ=;
 b=kStOLBDf86BXx5CDHx0v+uXe48i/T80MCxp/Ewt5yEUtrS8lziYQcrCoAr/mbzDHrv5c
 S9FBc/6A0sh4XNuVB1ghjZk52xMY6w+t0OfceRnSEqjAvWQHKTJy+JeVzgGSqxda5PfB
 37lPQsS5j/dOBDr6r12YLiC/qfuuDLv/+VNa8BgAZeDjH6XCrNTrrLcR41dtdGRO0jFF
 +plVRCZWTU+V1rjhDToPpoEG2Mech+NTNGEPbJZFFVMJh7gARLn5xR1ekmhfUnOciKY3
 Ikgpx9sBPBwAS2v3iIyvnTTlH6WCVSTmHaC0+nACQXF708C2+tMXbYlfaKSnyO4XdEae jg== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34n72vx7x0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 06 Nov 2020 23:45:17 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A74hQcN029934
        for <netdev@vger.kernel.org>; Sat, 7 Nov 2020 04:45:17 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma02wdc.us.ibm.com with ESMTP id 34nk7q8f0m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 07 Nov 2020 04:45:17 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A74jFVa58262010
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 7 Nov 2020 04:45:16 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D9193C605B;
        Sat,  7 Nov 2020 04:45:15 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1AFABC605A;
        Sat,  7 Nov 2020 04:45:15 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.85.137.49])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sat,  7 Nov 2020 04:45:14 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Dany Madden <drt@linux.vnet.ibm.com>, Lijun Pan <ljp@linux.ibm.com>
Subject: [RFC PATCH] powerpc/vnic: Add some debugs
Date:   Fri,  6 Nov 2020 20:45:13 -0800
Message-Id: <20201107044514.1723116-1-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-06_06:2020-11-05,2020-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_spam_definite policy=outbound score=100 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 suspectscore=0 bulkscore=0 phishscore=0
 mlxlogscore=-1000 mlxscore=100 adultscore=0 spamscore=100 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011070024
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We sometimes run into situations where a soft/hard reset of the adapter
takes a long time or fails to complete. Having additional messages that
include important adapter state info will hopefully help understand what
is happening, reduce the guess work and minimize requests to reproduce
problems with debug patches.

Sending this as an RFC for now, while we continue testing/optimizing the
messages.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 48 +++++++++++++++++++++++-------
 1 file changed, 37 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index af4dfbe28d56..02985a0d82dc 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -404,6 +404,8 @@ static void replenish_pools(struct ibmvnic_adapter *adapter)
 		if (adapter->rx_pool[i].active)
 			replenish_rx_pool(adapter, &adapter->rx_pool[i]);
 	}
+
+	netdev_dbg(adapter->netdev, "Replenished %d pools\n", i);
 }
 
 static void release_stats_buffers(struct ibmvnic_adapter *adapter)
@@ -911,6 +913,7 @@ static int ibmvnic_login(struct net_device *netdev)
 
 	__ibmvnic_set_mac(netdev, adapter->mac_addr);
 
+	netdev_dbg(netdev, "[S:%d] Login succeeded\n", adapter->state);
 	return 0;
 }
 
@@ -945,7 +948,7 @@ static int set_link_state(struct ibmvnic_adapter *adapter, u8 link_state)
 	bool resend;
 	int rc;
 
-	netdev_dbg(netdev, "setting link state %d\n", link_state);
+	netdev_dbg(netdev, "Setting link state %d\n", link_state);
 
 	memset(&crq, 0, sizeof(crq));
 	crq.logical_link_state.first = IBMVNIC_CRQ_CMD;
@@ -1332,6 +1335,10 @@ static int ibmvnic_close(struct net_device *netdev)
 	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
 	int rc;
 
+	netdev_dbg(netdev, "[S:%d FOP:%d FRR:%d] Closing\n",
+		   adapter->state, adapter->failover_pending,
+		   adapter->force_reset_recovery);
+
 	/* If device failover is pending, just set device state and return.
 	 * Device operation will be handled by reset routine.
 	 */
@@ -1918,8 +1925,10 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 	struct net_device *netdev = adapter->netdev;
 	int i, rc;
 
-	netdev_dbg(adapter->netdev, "Re-setting driver (%d)\n",
-		   rwi->reset_reason);
+	netdev_dbg(adapter->netdev,
+		   "[S:%d FOP:%d] Reset reason %d, reset_state %d\n",
+		   adapter->state, adapter->failover_pending,
+		   rwi->reset_reason, reset_state);
 
 	rtnl_lock();
 
@@ -2066,6 +2075,8 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 out:
 	rtnl_unlock();
 
+	netdev_dbg(adapter->netdev, "[S:%d FOP:%d] Reset done, rc %d\n",
+		   adapter->state, adapter->failover_pending, rc);
 	return rc;
 }
 
@@ -2096,40 +2107,44 @@ static int do_hard_reset(struct ibmvnic_adapter *adapter,
 	if (rc) {
 		netdev_err(adapter->netdev,
 			   "Couldn't initialize crq. rc=%d\n", rc);
-		return rc;
+		goto out;
 	}
 
 	rc = ibmvnic_reset_init(adapter, false);
 	if (rc)
-		return rc;
+		goto out;
 
 	/* If the adapter was in PROBE state prior to the reset,
 	 * exit here.
 	 */
 	if (reset_state == VNIC_PROBED)
-		return 0;
+		goto out;
 
 	rc = ibmvnic_login(netdev);
 	if (rc) {
 		adapter->state = VNIC_PROBED;
-		return 0;
+		rc = 0;
+		goto out;
 	}
 
 	rc = init_resources(adapter);
 	if (rc)
-		return rc;
+		goto out;
 
 	ibmvnic_disable_irqs(adapter);
 	adapter->state = VNIC_CLOSED;
 
 	if (reset_state == VNIC_CLOSED)
-		return 0;
+		goto out;
 
 	rc = __ibmvnic_open(netdev);
 	if (rc)
-		return IBMVNIC_OPEN_FAILED;
+		rc = IBMVNIC_OPEN_FAILED;
 
-	return 0;
+out:
+	netdev_dbg(adapter->netdev, "[S:%d FOP:%d] Hard reset done, rc %d\n",
+		   adapter->state, adapter->failover_pending, rc);
+	return rc;
 }
 
 static struct ibmvnic_rwi *get_next_rwi(struct ibmvnic_adapter *adapter)
@@ -2181,6 +2196,12 @@ static void __ibmvnic_reset(struct work_struct *work)
 
 	rwi = get_next_rwi(adapter);
 	while (rwi) {
+		netdev_dbg(adapter->netdev,
+			   "[S:%d FOP:%d FRR:%d WFR:%d] Processing reset %d\n",
+			   adapter->state, adapter->failover_pending,
+			   adapter->force_reset_recovery,
+			   adapter->wait_for_reset, rwi->reset_reason);
+
 		spin_lock_irqsave(&adapter->state_lock, flags);
 
 		if (adapter->state == VNIC_REMOVING ||
@@ -2246,6 +2267,11 @@ static void __ibmvnic_reset(struct work_struct *work)
 	}
 
 	clear_bit_unlock(0, &adapter->resetting);
+
+	netdev_err(adapter->netdev,
+		   "[S:%d FRR:%d WFR:%d] Done processing resets\n",
+		   adapter->state, adapter->force_reset_recovery,
+		   adapter->wait_for_reset);
 }
 
 static void __ibmvnic_delayed_reset(struct work_struct *work)
-- 
2.25.4

