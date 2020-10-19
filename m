Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21463292ECF
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 21:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731405AbgJSTwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 15:52:39 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43966 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727936AbgJSTwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 15:52:38 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09JJX5ml073465
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 15:52:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : mime-version : content-type; s=pp1;
 bh=gf2tRQ9mhyRFCQEBNlvIw8oOmrztT2DAPGb5augNDHo=;
 b=IhJ98JRVdBWENZm6vSj5XBHh9a6qf8XkfdR0OfPLP5N4iMCdVSGktPyQWJ/+WwWA96Zv
 AEVci297sR/+L9hm+CDc5hgUe6iR6c4woZbCK3bEUaCaJ5q4TOzF+EUWoIgkCZrF5zmc
 MlUfO9fuLGFgq7kOlTHVU+06iU09KxiIgKpTO5tBj2OsjfTKM2MRK2FD50ngpOGME8q2
 tJcnmL4dS3X7pU63NJpMhsKzmnLCuu4eXEuAWZiyM1UMlb9e6NTrgk8zzn8g41U1M0c/
 0JXZArEyOsLcnk/0M4OPX03RLAbW2hwc8CVJRRcZmEUq+oEMQSra9OXaql7wxua4Juxb 9g== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 349gs510dm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 15:52:37 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09JJkool019008
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 19:52:37 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma03wdc.us.ibm.com with ESMTP id 347r88teg0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 19:52:37 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09JJqaHv32178486
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Oct 2020 19:52:36 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 72C54B2071;
        Mon, 19 Oct 2020 19:52:36 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 577E4B2066;
        Mon, 19 Oct 2020 19:52:36 +0000 (GMT)
Received: from suka-w540.localdomain (unknown [9.85.152.173])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 19 Oct 2020 19:52:36 +0000 (GMT)
Received: by suka-w540.localdomain (Postfix, from userid 1000)
        id 8AE852E11A3; Mon, 19 Oct 2020 12:52:33 -0700 (PDT)
Date:   Mon, 19 Oct 2020 12:52:33 -0700
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Dany Madden <drt@linux.vnet.ibm.com>, Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH v2 1/1] powerpc/vnic: Extend "failover pending" window
Message-ID: <20201019195233.GA1282438@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 2.0.32 on an i486
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-19_08:2020-10-16,2020-10-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=3
 bulkscore=0 clxscore=1015 malwarescore=0 impostorscore=0
 priorityscore=1501 spamscore=0 mlxlogscore=999 phishscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010190131
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From 67f8977f636e462a1cd1eadb28edd98ef4f2b756 Mon Sep 17 00:00:00 2001
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Date: Thu, 10 Sep 2020 11:18:41 -0700
Subject: [PATCH 1/1] powerpc/vnic: Extend "failover pending" window

Commit 5a18e1e0c193b introduced the 'failover_pending' state to track
the "failover pending window" - where we wait for the partner to become
ready (after a transport event) before actually attempting to failover.
i.e window is between following two events:

        a. we get a transport event due to a FAILOVER

        b. later, we get CRQ_INITIALIZED indicating the partner is
           ready  at which point we schedule a FAILOVER reset.

and ->failover_pending is true during this window.

If during this window, we attempt to open (or close) a device, we pretend
that the operation succeded and let the FAILOVER reset path complete the
operation.

This is fine, except if the transport event ("a" above) occurs during the
open and after open has already checked whether a failover is pending. If
that happens, we fail the open, which can cause the boot scripts to leave
the interface down requiring administrator to manually bring up the device.

This fix "extends" the failover pending window till we are _actually_
ready to perform the failover reset (i.e until after we get the RTNL
lock). Since open() holds the RTNL lock, we can be sure that we either
finish the open or if the open() fails due to the failover pending window,
we can again pretend that open is done and let the failover complete it.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
Changelog [v2]:
	[Brian King] Ensure we clear failover_pending during hard reset
---
 drivers/net/ethernet/ibm/ibmvnic.c | 36 ++++++++++++++++++++++++++----
 1 file changed, 32 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 1b702a43a5d0..2a0f6f6820db 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1197,18 +1197,27 @@ static int ibmvnic_open(struct net_device *netdev)
 	if (adapter->state != VNIC_CLOSED) {
 		rc = ibmvnic_login(netdev);
 		if (rc)
-			return rc;
+			goto out;
 
 		rc = init_resources(adapter);
 		if (rc) {
 			netdev_err(netdev, "failed to initialize resources\n");
 			release_resources(adapter);
-			return rc;
+			goto out;
 		}
 	}
 
 	rc = __ibmvnic_open(netdev);
 
+out:
+	/*
+	 * If open fails due to a pending failover, set device state and
+	 * return. Device operation will be handled by reset routine.
+	 */
+	if (rc && adapter->failover_pending) {
+		adapter->state = VNIC_OPEN;
+		rc = 0;
+	}
 	return rc;
 }
 
@@ -1931,6 +1940,13 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 		   rwi->reset_reason);
 
 	rtnl_lock();
+	/*
+	 * Now that we have the rtnl lock, clear any pending failover.
+	 * This will ensure ibmvnic_open() has either completed or will
+	 * block until failover is complete.
+	 */
+	if (rwi->reset_reason == VNIC_RESET_FAILOVER)
+		adapter->failover_pending = false;
 
 	netif_carrier_off(netdev);
 	adapter->reset_reason = rwi->reset_reason;
@@ -2211,6 +2227,13 @@ static void __ibmvnic_reset(struct work_struct *work)
 			/* CHANGE_PARAM requestor holds rtnl_lock */
 			rc = do_change_param_reset(adapter, rwi, reset_state);
 		} else if (adapter->force_reset_recovery) {
+			/*
+			 * Since we are doing a hard reset now, clear the
+			 * failover_pending flag so we don't ignore any
+			 * future MOBILITY or other resets.
+			 */
+			adapter->failover_pending = false;
+
 			/* Transport event occurred during previous reset */
 			if (adapter->wait_for_reset) {
 				/* Previous was CHANGE_PARAM; caller locked */
@@ -2275,9 +2298,15 @@ static int ibmvnic_reset(struct ibmvnic_adapter *adapter,
 	unsigned long flags;
 	int ret;
 
+	/*
+	 * If failover is pending don't schedule any other reset.
+	 * Instead let the failover complete. If there is already a
+	 * a failover reset scheduled, we will detect and drop the
+	 * duplicate reset when walking the ->rwi_list below.
+	 */
 	if (adapter->state == VNIC_REMOVING ||
 	    adapter->state == VNIC_REMOVED ||
-	    adapter->failover_pending) {
+	    (adapter->failover_pending && reason != VNIC_RESET_FAILOVER)) {
 		ret = EBUSY;
 		netdev_dbg(netdev, "Adapter removing or pending failover, skipping reset\n");
 		goto err;
@@ -4653,7 +4682,6 @@ static void ibmvnic_handle_crq(union ibmvnic_crq *crq,
 		case IBMVNIC_CRQ_INIT:
 			dev_info(dev, "Partner initialized\n");
 			adapter->from_passive_init = true;
-			adapter->failover_pending = false;
 			if (!completion_done(&adapter->init_done)) {
 				complete(&adapter->init_done);
 				adapter->init_done_rc = -EIO;
-- 
2.25.4

