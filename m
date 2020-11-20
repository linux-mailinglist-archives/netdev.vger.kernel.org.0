Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF93E2BB953
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 23:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729169AbgKTWlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 17:41:10 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59658 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729155AbgKTWlG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 17:41:06 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AKMVl1i139836
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 17:41:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=KHebmsQlylLk+t5XCYBU9stuSzXZgwxgGBxGTEkiFOQ=;
 b=O5uJnMD54a9nH6foPGEEW+kxAUqNS4FWfYAPHcfLSEoCNp0Mtfqx2g4qumKxDeuRl+/5
 asIUCpWBeY6fSZo9OQM9JX2iZxtpn18uPQFPtWucNxuL8qyy/eKuwxfvLutNEa2RfOmu
 +JpUn4hhQjASMCescy48YbfFtawSW+Kp1ZCAOewYSXKswWCzw7TsRE/9wCNiTwCV9yDn
 tOT1A/qezXcVElTuJqMCGP0s2P+YE0cteBAengDAMO6x82b7xfXiQzTazEpNPr4QRNF1
 RtiTcPQKF4cRGb06odMxCa9C7P6nRuhoVSCsp/OR3XBzdFnCBNvtfD+75auKrftOmMW/ RA== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34xkunmbub-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 17:41:06 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AKMatqT008159
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 22:41:05 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma02dal.us.ibm.com with ESMTP id 34vgjn94vr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 22:41:05 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AKMesgp63963596
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Nov 2020 22:40:54 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C64496E050;
        Fri, 20 Nov 2020 22:41:03 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2B6DE6E052;
        Fri, 20 Nov 2020 22:41:03 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.186.201])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 20 Nov 2020 22:41:03 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     sukadev@linux.ibm.com, drt@linux.ibm.com
Subject: [PATCH net 15/15] ibmvnic: add some debugs
Date:   Fri, 20 Nov 2020 16:40:49 -0600
Message-Id: <20201120224049.46933-16-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20201120224049.46933-1-ljp@linux.ibm.com>
References: <20201120224049.46933-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-20_16:2020-11-20,2020-11-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 malwarescore=0
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 adultscore=0
 phishscore=0 impostorscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011200144
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.ibm.com>

We sometimes run into situations where a soft/hard reset of the adapter
takes a long time or fails to complete. Having additional messages that
include important adapter state info will hopefully help understand what
is happening, reduce the guess work and minimize requests to reproduce
problems with debug patches.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index b1519e92ccce..1abeb3edee33 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -406,6 +406,8 @@ static void replenish_pools(struct ibmvnic_adapter *adapter)
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
 
@@ -1377,6 +1380,10 @@ static int ibmvnic_close(struct net_device *netdev)
 	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
 	int rc;
 
+	netdev_dbg(netdev, "[S:%d FOP:%d FRR:%d] Closing\n",
+		   adapter->state, adapter->failover_pending,
+		   adapter->force_reset_recovery);
+
 	/* If device failover is pending, just set device state and return.
 	 * Device operation will be handled by reset routine.
 	 */
@@ -1969,8 +1976,10 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 	struct net_device *netdev = adapter->netdev;
 	int i, rc;
 
-	netdev_dbg(adapter->netdev, "Re-setting driver (%d)\n",
-		   rwi->reset_reason);
+	netdev_dbg(adapter->netdev,
+		   "[S:%d FOP:%d] Reset reason %d, reset_state %d\n",
+		   adapter->state, adapter->failover_pending,
+		   rwi->reset_reason, reset_state);
 
 	rtnl_lock();
 	/*
@@ -2129,6 +2138,8 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 		adapter->state = reset_state;
 	rtnl_unlock();
 
+	netdev_dbg(adapter->netdev, "[S:%d FOP:%d] Reset done, rc %d\n",
+		   adapter->state, adapter->failover_pending, rc);
 	return rc;
 }
 
@@ -2198,6 +2209,8 @@ static int do_hard_reset(struct ibmvnic_adapter *adapter,
 	/* restore adapter state if reset failed */
 	if (rc)
 		adapter->state = reset_state;
+	netdev_dbg(adapter->netdev, "[S:%d FOP:%d] Hard reset done, rc %d\n",
+		   adapter->state, adapter->failover_pending, rc);
 	return rc;
 }
 
@@ -2307,7 +2320,14 @@ static void __ibmvnic_reset(struct work_struct *work)
 		complete(&adapter->reset_done);
 	}
 
+	netdev_dbg(adapter->netdev, "FRR=%d\n", adapter->force_reset_recovery);
+
 	clear_bit_unlock(0, &adapter->resetting);
+
+	netdev_err(adapter->netdev,
+		   "[S:%d FRR:%d WFR:%d] Done processing resets\n",
+		   adapter->state, adapter->force_reset_recovery,
+		   adapter->wait_for_reset);
 }
 
 static void __ibmvnic_delayed_reset(struct work_struct *work)
@@ -2353,7 +2373,8 @@ static int ibmvnic_reset(struct ibmvnic_adapter *adapter,
 	list_for_each(entry, &adapter->rwi_list) {
 		tmp = list_entry(entry, struct ibmvnic_rwi, list);
 		if (tmp->reset_reason == reason) {
-			netdev_dbg(netdev, "Skipping matching reset\n");
+			netdev_dbg(netdev, "Skipping matching reset, reason=%d\n",
+				   reason);
 			spin_unlock_irqrestore(&adapter->rwi_lock, flags);
 			ret = EBUSY;
 			goto err;
-- 
2.23.0

