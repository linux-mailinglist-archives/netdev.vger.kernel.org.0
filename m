Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 489A42CF8ED
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 03:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727531AbgLECXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 21:23:21 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:49012 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725601AbgLECXU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 21:23:20 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B5243QY158275
        for <netdev@vger.kernel.org>; Fri, 4 Dec 2020 21:22:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=Ku2hKEzSK5G4TcJRC8zl5qGZrhVf9XirKksnAfUeZlk=;
 b=j+X4QraHGONr7GjPhuK+nb5ntAvHi6n3snYKYwueSPhTxX4uU6fsBI9JY80qeqsjb0h9
 uq81Ec8WMYWan4M/nJQ/jnWfecyAUOdT1YVNRwhvbITVKkm55ePPjdKlXQAEkMBsLBBS
 wEMTilx2mf5w6DMMBmhHoTecx1haFV3Aqzsi08/d+fx68Mi74ccrnZ1y/d8oqu12xmRa
 92HrrygKWJFtKdS0d8t5UT+wPl+A0gS0XCGrk0wHqSEsLah/xGBbVNVlV7qopyPLTFQT
 JfaQexh+qnlUjH+8hhFyLtMvD6FGdU73h6hfiiCy75bg3wtlEPT0HD7DiLPkLS3tWCKp Gg== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 357yk4t1x7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 04 Dec 2020 21:22:39 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B52Kjim016700
        for <netdev@vger.kernel.org>; Sat, 5 Dec 2020 02:22:39 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma01wdc.us.ibm.com with ESMTP id 355vrgfm8g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 05 Dec 2020 02:22:39 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B52MbUd24117756
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 5 Dec 2020 02:22:37 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C3F4213604F;
        Sat,  5 Dec 2020 02:22:37 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 06C8A136051;
        Sat,  5 Dec 2020 02:22:36 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.85.152.92])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sat,  5 Dec 2020 02:22:36 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Dany Madden <drt@linux.ibm.com>, Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net-next v3 1/1] ibmvnic: add some debugs
Date:   Fri,  4 Dec 2020 18:22:35 -0800
Message-Id: <20201205022235.2414110-1-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-04_13:2020-12-04,2020-12-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=1
 priorityscore=1501 spamscore=0 malwarescore=0 impostorscore=0 bulkscore=0
 adultscore=0 lowpriorityscore=0 phishscore=0 mlxscore=0 mlxlogscore=999
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012050007
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
---
 drivers/net/ethernet/ibm/ibmvnic.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index da9450f18717..613432b9097b 100644
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
@@ -909,6 +911,7 @@ static int ibmvnic_login(struct net_device *netdev)
 
 	__ibmvnic_set_mac(netdev, adapter->mac_addr);
 
+	netdev_dbg(netdev, "[S:%d] Login succeeded\n", adapter->state);
 	return 0;
 }
 
@@ -1339,6 +1342,10 @@ static int ibmvnic_close(struct net_device *netdev)
 	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
 	int rc;
 
+	netdev_dbg(netdev, "[S:%d FOP:%d FRR:%d] Closing\n",
+		   adapter->state, adapter->failover_pending,
+		   adapter->force_reset_recovery);
+
 	/* If device failover is pending, just set device state and return.
 	 * Device operation will be handled by reset routine.
 	 */
@@ -1931,8 +1938,10 @@ static int do_reset(struct ibmvnic_adapter *adapter,
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
@@ -2091,6 +2100,8 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 		adapter->state = reset_state;
 	rtnl_unlock();
 
+	netdev_dbg(adapter->netdev, "[S:%d FOP:%d] Reset done, rc %d\n",
+		   adapter->state, adapter->failover_pending, rc);
 	return rc;
 }
 
@@ -2160,6 +2171,8 @@ static int do_hard_reset(struct ibmvnic_adapter *adapter,
 	/* restore adapter state if reset failed */
 	if (rc)
 		adapter->state = reset_state;
+	netdev_dbg(adapter->netdev, "[S:%d FOP:%d] Hard reset done, rc %d\n",
+		   adapter->state, adapter->failover_pending, rc);
 	return rc;
 }
 
@@ -2270,6 +2283,11 @@ static void __ibmvnic_reset(struct work_struct *work)
 	}
 
 	clear_bit_unlock(0, &adapter->resetting);
+
+	netdev_dbg(adapter->netdev,
+		   "[S:%d FRR:%d WFR:%d] Done processing resets\n",
+		   adapter->state, adapter->force_reset_recovery,
+		   adapter->wait_for_reset);
 }
 
 static void __ibmvnic_delayed_reset(struct work_struct *work)
@@ -2315,7 +2333,8 @@ static int ibmvnic_reset(struct ibmvnic_adapter *adapter,
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

