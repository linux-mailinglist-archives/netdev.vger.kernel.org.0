Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 071002C1CBC
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 05:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728893AbgKXEeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 23:34:12 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46148 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726820AbgKXEeL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 23:34:11 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AO4VYKW121008
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 23:34:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=+c1YbIOauRx6TeEMlRRE/9YnsKDz0ep2IWJXsMHO8QU=;
 b=eg8bFvZjrz+I4DojKrkY+zek0PlkW39Xkw5RuimWrC2IKJK8jlnIta54MKgeYTRo1jMM
 mE3x4gn2OiMGJXHtCJqWXvzDYttibqzurPU2dbqrAm0lPGcXecPG8DZPVcfkaKUrEgUe
 7oL+G13vj5j6jpV1oEBmgl1lbGC6u5XGbsk3GEHrAdAqgghBqYAQtRLvD9syS6aZtpeN
 Gw12u9VyQeCvY2oOTv1ZLDwlolaTHMQtlxBTDFdPKgNHMKHzkXvxtN2liV0Z/VjVBDmo
 skimK4K8yT/wcEJqfnUlmrC4zPHcTrCQyFXjYA8YLZG1ayKQ58qW+3F2t96OGNkfVfUg MA== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34ygttgfey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 23:34:10 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AO4W3FW022376
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 04:34:09 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma03dal.us.ibm.com with ESMTP id 34xth99hku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 04:34:09 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AO4Y89u5309028
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Nov 2020 04:34:08 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A7C14B2066;
        Tue, 24 Nov 2020 04:34:08 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 08832B2067;
        Tue, 24 Nov 2020 04:34:08 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.85.207.248])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 24 Nov 2020 04:34:07 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Dany Madden <drt@linux.ibm.com>, Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net-next v2 1/1] ibmvnic: add some debugs
Date:   Mon, 23 Nov 2020 20:34:07 -0800
Message-Id: <20201124043407.2127285-1-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-23_19:2020-11-23,2020-11-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 mlxscore=0 impostorscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 bulkscore=0 spamscore=0 phishscore=0 lowpriorityscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011240022
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We sometimes run into situations where a soft/hard reset of the adapter
takes a long time or fails to complete. Having additional messages that
include important adapter state info will hopefully help understand what
is happening, reduce the guess work and minimize requests to reproduce
problems with debug patches.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---

Changelog[v2]
	[Jakub Kacinski] Change an netdev_err() to netdev_info()? Changed
	to netdev_dbg() instead. Also sending to net rather than net-next.

	Note: this debug patch is based on following bug fixes and a feature
	from Dany Madden and Lijun Pan:

	https://lore.kernel.org/netdev/20201123193547.57225-1-ljp@linux.ibm.com/
	https://lore.kernel.org/netdev/319f8afadcd856037b1d83891f98db3d@linux.vnet.ibm.com/
	https://lore.kernel.org/netdev/20201123235841.6515-1-drt@linux.ibm.com/

---
 drivers/net/ethernet/ibm/ibmvnic.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 5cb4cfabe2de..e605a08c6551 100644
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
 
@@ -2308,6 +2321,11 @@ static void __ibmvnic_reset(struct work_struct *work)
 	}
 
 	clear_bit_unlock(0, &adapter->resetting);
+
+	netdev_dbg(adapter->netdev,
+		   "[S:%d FRR:%d WFR:%d] Done processing resets\n",
+		   adapter->state, adapter->force_reset_recovery,
+		   adapter->wait_for_reset);
 }
 
 static void __ibmvnic_delayed_reset(struct work_struct *work)
@@ -2353,7 +2371,8 @@ static int ibmvnic_reset(struct ibmvnic_adapter *adapter,
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
2.25.4

