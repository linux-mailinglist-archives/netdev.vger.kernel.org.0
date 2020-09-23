Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3140427501A
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 06:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726929AbgIWExj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 00:53:39 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:11054 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726198AbgIWExj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 00:53:39 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08N4V7Zo109017
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 00:53:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : mime-version : content-type; s=pp1;
 bh=TYylSBz7dg2Y1D94tssy8hyNSVirx6AlhQP0h/SDgdo=;
 b=mHAy0HeIq7CyV2L2HCHydUtZhjm/i7VkHtF2uC4OfJD1DRv2FiS5hnJWNq1YNUKe8gus
 CjByhiCuw0EqtHq6FWWzO+M2nZeboljRg775AYTkROxEg2/dAs0FXhf0lHJzYaUj7lX5
 X4+j3bgNNZmNaQdkyXyrzPu1dju3oLnNOrIKneexZFZn7prgepBHAEXtJPuAWBgHqCUg
 FqP5Iv8kb2Y2gzaYN1E/cjk7/QLecRb7tA6vcIaaZ88IU3Rr6VGpRQBUo5Lnj+t/VcB6
 4NOykLBurNSMHmSUCIfVaZsM57VABJJJ1Hhk6CTaSeWrsjPRvSYpPDrz9sM8l8kn92uj MQ== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33qy7ngpbu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 00:53:37 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08N4qx44001237
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 04:53:37 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma02dal.us.ibm.com with ESMTP id 33n9m9b4ry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 04:53:37 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08N4rWhl60686794
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 04:53:32 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 15554BE051
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 04:53:36 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D99D8BE053
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 04:53:35 +0000 (GMT)
Received: from suka-w540.localdomain (unknown [9.85.173.158])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 04:53:35 +0000 (GMT)
Received: by suka-w540.localdomain (Postfix, from userid 1000)
        id B52912E119C; Tue, 22 Sep 2020 21:53:32 -0700 (PDT)
Date:   Tue, 22 Sep 2020 21:53:32 -0700
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     drt@linux.ibm.com, ljp@linux.ibm.com
Subject: [PATCH 1/1] powerpc/vnic: Extend "failover pending" window
Message-ID: <20200923045332.GA269687@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 2.0.32 on an i486
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-23_02:2020-09-21,2020-09-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=3 clxscore=1011
 phishscore=0 bulkscore=0 spamscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 malwarescore=0 impostorscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009230028
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


From 547fa5627b63102f3ef80edffff3a032d62c88c5 Mon Sep 17 00:00:00 2001
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
 drivers/net/ethernet/ibm/ibmvnic.c | 33 +++++++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 1b702a43a5d0..cf75a649ed8b 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1197,18 +1197,29 @@ static int ibmvnic_open(struct net_device *netdev)
 	if (adapter->state != VNIC_CLOSED) {
 		rc = ibmvnic_login(netdev);
 		if (rc)
-			return rc;
+			goto out;
 
 		rc = init_resources(adapter);
 		if (rc) {
-			netdev_err(netdev, "failed to initialize resources\n");
+			netdev_err(netdev,
+				"failed to initialize resources, failover %d\n",
+				adapter->failover_pending);
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
 
@@ -1931,6 +1942,13 @@ static int do_reset(struct ibmvnic_adapter *adapter,
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
@@ -2275,9 +2293,15 @@ static int ibmvnic_reset(struct ibmvnic_adapter *adapter,
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
@@ -4653,7 +4677,6 @@ static void ibmvnic_handle_crq(union ibmvnic_crq *crq,
 		case IBMVNIC_CRQ_INIT:
 			dev_info(dev, "Partner initialized\n");
 			adapter->from_passive_init = true;
-			adapter->failover_pending = false;
 			if (!completion_done(&adapter->init_done)) {
 				complete(&adapter->init_done);
 				adapter->init_done_rc = -EIO;
-- 
2.26.2

