Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04F252F40FE
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 02:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbhAMBQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 20:16:31 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:6648 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725536AbhAMBQa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 20:16:30 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10D1E2Xb173900;
        Tue, 12 Jan 2021 20:15:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=4xhPaprazWiykybz8OZP7L8Sdc5nZSEXyGE+XlZa3Bc=;
 b=ox74P3TL+HngumPYHWq0ruICYyYKJ1gvQzSUeg9dOWwuW9oydksNbrkgpXRkNHEfUFwV
 kj0+1+KMOQv5yfAdWRunCkmngdM1/4l94XRdCPSr2Z4MKVz82LFKzwOKrbLnilzRC8zM
 k4KsI96vP6s5/l2IlFlBsQuurpmOKSzqD843/5xzBFjHbm7BKidS996uNmJDTAesut/k
 LRnSXSJ/rWhBXIg0X+O3EQwLPaVE0U+g9PkcifF3eA+wZTZc90kuFRIAdP7nB5Jtr6vr
 IE8TQD9Kd9eLTkqlUv3KJbNUhssDJmN3/A+4sVJEhTVBXzH51BlFad07UX2DFKMQnkXb rg== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361q1000vs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 20:15:47 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10D1DG2o029836;
        Wed, 13 Jan 2021 01:15:46 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma03wdc.us.ibm.com with ESMTP id 35y4492297-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 01:15:46 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10D1Fkw332375162
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 01:15:46 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6102C124052;
        Wed, 13 Jan 2021 01:15:46 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3219F124053;
        Wed, 13 Jan 2021 01:15:46 +0000 (GMT)
Received: from suka-w540.localdomain (unknown [9.85.207.168])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 13 Jan 2021 01:15:46 +0000 (GMT)
Received: by suka-w540.localdomain (Postfix, from userid 1000)
        id 770112E288B; Tue, 12 Jan 2021 17:15:43 -0800 (PST)
Date:   Tue, 12 Jan 2021 17:15:43 -0800
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     netdev@vger.kernel.org, Dany Madden <drt@linux.ibm.com>,
        Lijun Pan <ljp@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>
Subject: Re: [PATCH net-next v2 3/7] ibmvnic: avoid allocating rwi entries
Message-ID: <20210113011543.GA218424@us.ibm.com>
References: <20210112181441.206545-1-sukadev@linux.ibm.com>
 <20210112181441.206545-4-sukadev@linux.ibm.com>
 <ee2fe19334bc8a23009df4cf1c54731bacb7d95c.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee2fe19334bc8a23009df4cf1c54731bacb7d95c.camel@kernel.org>
X-Operating-System: Linux 2.0.32 on an i486
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_21:2021-01-12,2021-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxlogscore=999
 phishscore=0 priorityscore=1501 suspectscore=0 lowpriorityscore=0
 mlxscore=0 impostorscore=0 malwarescore=0 adultscore=0 bulkscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101130003
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Saeed Mahameed [saeed@kernel.org] wrote:
> > -struct ibmvnic_rwi {
> > -	enum ibmvnic_reset_reason reset_reason;
> > -	struct list_head list;
> > -};
> > +			   VNIC_RESET_CHANGE_PARAM,
> > +			   VNIC_RESET_MAX};	// must be last
>        this is not the preferred comment style: ^^
> 
> I would just drop the comment here, it is clear from the name of the
> enum.
> 

Yeah, we debated and figured the comment could serve as another reminder.

Here is updated patch, fixing the comment style.

Thanks

Sukadev
---
From 59d4b23fe1f97a67436e14829368744ee288157d Mon Sep 17 00:00:00 2001
From: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Date: Wed, 16 Dec 2020 23:00:34 -0600
Subject: [PATCH net-next v2 3/7] ibmvnic: avoid allocating rwi entries

Whenever we need to schedule a reset, we allocate an rwi (reset work
item?) entry and add to the list of pending resets.

Since we only add one rwi for a given reason type to the list (no duplicates).
we will only have a handful of reset types in the list - even in the
worst case. In the common case we should just have a couple of entries
at most.

Rather than allocating/freeing every time (and dealing with the corner
case of the allocation failing), use a fixed number of rwi entries.
The extra memory needed is tiny and most of it will be used over the
active life of the adapter.

This also fixes a couple of tiny memory leaks. One is in ibmvnic_reset()
where we don't free the rwi entries after deleting them from the list due
to a transport event.  The second is in __ibmvnic_reset() where if we
find that the adapter is being removed, we simply break out of the loop
(with rc = EBUSY) but ignore any rwi entries that remain on the list.

Fixes: 2770a7984db58 ("Introduce hard reset recovery")
Fixes: 36f1031c51a2 ("ibmvnic: Do not process reset during or after device removal")
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 123 +++++++++++++++++------------
 drivers/net/ethernet/ibm/ibmvnic.h |  14 ++--
 2 files changed, 78 insertions(+), 59 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index cd8108dbddec..d1c2aaed1478 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2257,29 +2257,81 @@ static int do_hard_reset(struct ibmvnic_adapter *adapter,
 	return rc;
 }
 
-static struct ibmvnic_rwi *get_next_rwi(struct ibmvnic_adapter *adapter)
+/**
+ * Next reset will always be the first on the list.
+ * When we take it off the list, we move any remaining resets so
+ * that the next one is again the first on the list. Most of the
+ * time the pending_resets[] should have a couple of types of resets
+ * (FAILOVER, TIMEOUT or CHANGE-PARAM and less often, MOBILITY).
+ */
+static enum ibmvnic_reset_reason get_pending_reset(struct ibmvnic_adapter *adapter)
 {
-	struct ibmvnic_rwi *rwi;
+	enum ibmvnic_reset_reason *pending_resets;
+	enum ibmvnic_reset_reason reason = 0;
 	unsigned long flags;
+	int i;
 
 	spin_lock_irqsave(&adapter->rwi_lock, flags);
 
-	if (!list_empty(&adapter->rwi_list)) {
-		rwi = list_first_entry(&adapter->rwi_list, struct ibmvnic_rwi,
-				       list);
-		list_del(&rwi->list);
-	} else {
-		rwi = NULL;
+	pending_resets = &adapter->pending_resets[0];
+
+	reason = pending_resets[0];
+
+	if (reason)  {
+		for (i = 0; i < adapter->next_reset; i++) {
+			pending_resets[i] = pending_resets[i+1];
+			if (!pending_resets[i])
+				break;
+		}
+		adapter->next_reset--;
+	}
+
+	spin_unlock_irqrestore(&adapter->rwi_lock, flags);
+	return reason;
+}
+
+/**
+ * Add a pending reset, making sure not to add duplicates.
+ * If @clear is set, clear all existing resets before adding.
+ *
+ * TODO: If clear (i.e force_reset_recovery) is true AND we have a
+ * 	 duplicate reset, wouldn't it still make sense to clear the
+ * 	 queue including the duplicate and add this reset? Preserving
+ * 	 existing behavior for now.
+ */
+static void add_pending_reset(struct ibmvnic_adapter *adapter,
+			      enum ibmvnic_reset_reason reason,
+			      bool clear)
+{
+	enum ibmvnic_reset_reason *pending_resets;
+	unsigned long flags;
+	int i;
+
+	spin_lock_irqsave(&adapter->rwi_lock, flags);
+
+	pending_resets = &adapter->pending_resets[0];
+
+	for (i = 0; i < adapter->next_reset; i++) {
+		if (pending_resets[i] == reason)
+			goto out;
+	}
+
+	if (clear) {
+		for (i = 0; i < adapter->next_reset; i++) {
+			pending_resets[i] = 0;
+		}
+		adapter->next_reset = 0;
 	}
 
+	pending_resets[adapter->next_reset] = reason;
+	adapter->next_reset++;
+out:
 	spin_unlock_irqrestore(&adapter->rwi_lock, flags);
-	return rwi;
 }
 
 static void __ibmvnic_reset(struct work_struct *work)
 {
 	enum ibmvnic_reset_reason reason;
-	struct ibmvnic_rwi *rwi;
 	struct ibmvnic_adapter *adapter;
 	bool saved_state = false;
 	unsigned long flags;
@@ -2294,15 +2346,13 @@ static void __ibmvnic_reset(struct work_struct *work)
 		return;
 	}
 
-	rwi = get_next_rwi(adapter);
-	reason = rwi->reset_reason;
-	while (rwi) {
+	reason = get_pending_reset(adapter);
+	while (reason) {
 		spin_lock_irqsave(&adapter->state_lock, flags);
 
 		if (adapter->state == VNIC_REMOVING ||
 		    adapter->state == VNIC_REMOVED) {
 			spin_unlock_irqrestore(&adapter->state_lock, flags);
-			kfree(rwi);
 			rc = EBUSY;
 			break;
 		}
@@ -2347,14 +2397,12 @@ static void __ibmvnic_reset(struct work_struct *work)
 				adapter->from_passive_init)) {
 			rc = do_reset(adapter, reason, reset_state);
 		}
-		kfree(rwi);
 		adapter->last_reset_time = jiffies;
 
 		if (rc)
 			netdev_dbg(adapter->netdev, "Reset failed, rc=%d\n", rc);
 
-		rwi = get_next_rwi(adapter);
-		reason = rwi->reset_reason;
+		reason = get_pending_reset(adapter);
 
 		if (reason && (reason == VNIC_RESET_FAILOVER ||
 			       reason == VNIC_RESET_MOBILITY))
@@ -2386,17 +2434,14 @@ static void __ibmvnic_delayed_reset(struct work_struct *work)
 static int ibmvnic_reset(struct ibmvnic_adapter *adapter,
 			 enum ibmvnic_reset_reason reason)
 {
-	struct list_head *entry, *tmp_entry;
-	struct ibmvnic_rwi *rwi, *tmp;
 	struct net_device *netdev = adapter->netdev;
-	unsigned long flags;
 	int ret;
 
 	/*
 	 * If failover is pending don't schedule any other reset.
 	 * Instead let the failover complete. If there is already a
 	 * a failover reset scheduled, we will detect and drop the
-	 * duplicate reset when walking the ->rwi_list below.
+	 * duplicate reset when walking the ->pending_resets list.
 	 */
 	if (adapter->state == VNIC_REMOVING ||
 	    adapter->state == VNIC_REMOVED ||
@@ -2412,36 +2457,11 @@ static int ibmvnic_reset(struct ibmvnic_adapter *adapter,
 		goto err;
 	}
 
-	spin_lock_irqsave(&adapter->rwi_lock, flags);
-
-	list_for_each(entry, &adapter->rwi_list) {
-		tmp = list_entry(entry, struct ibmvnic_rwi, list);
-		if (tmp->reset_reason == reason) {
-			netdev_dbg(netdev, "Skipping matching reset, reason=%d\n",
-				   reason);
-			spin_unlock_irqrestore(&adapter->rwi_lock, flags);
-			ret = EBUSY;
-			goto err;
-		}
-	}
-
-	rwi = kzalloc(sizeof(*rwi), GFP_ATOMIC);
-	if (!rwi) {
-		spin_unlock_irqrestore(&adapter->rwi_lock, flags);
-		ibmvnic_close(netdev);
-		ret = ENOMEM;
-		goto err;
-	}
-	/* if we just received a transport event,
-	 * flush reset queue and process this reset
+	/* If we just received a transport event, clear
+	 * any pending resets and add just this reset.
 	 */
-	if (adapter->force_reset_recovery && !list_empty(&adapter->rwi_list)) {
-		list_for_each_safe(entry, tmp_entry, &adapter->rwi_list)
-			list_del(entry);
-	}
-	rwi->reset_reason = reason;
-	list_add_tail(&rwi->list, &adapter->rwi_list);
-	spin_unlock_irqrestore(&adapter->rwi_lock, flags);
+	add_pending_reset(adapter, reason, adapter->force_reset_recovery);
+
 	netdev_dbg(adapter->netdev, "Scheduling reset (reason %d)\n", reason);
 	schedule_work(&adapter->ibmvnic_reset);
 
@@ -5363,7 +5383,8 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	INIT_WORK(&adapter->ibmvnic_reset, __ibmvnic_reset);
 	INIT_DELAYED_WORK(&adapter->ibmvnic_delayed_reset,
 			  __ibmvnic_delayed_reset);
-	INIT_LIST_HEAD(&adapter->rwi_list);
+	adapter->next_reset = 0;
+	memset(&adapter->pending_resets, 0, sizeof(adapter->pending_resets));
 	spin_lock_init(&adapter->rwi_lock);
 	spin_lock_init(&adapter->state_lock);
 	mutex_init(&adapter->fw_lock);
diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index c09c3f6bba9f..1179a95a3f92 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -945,17 +945,14 @@ enum vnic_state {VNIC_PROBING = 1,
 		 VNIC_REMOVING,
 		 VNIC_REMOVED};
 
-enum ibmvnic_reset_reason {VNIC_RESET_FAILOVER = 1,
+enum ibmvnic_reset_reason {VNIC_RESET_UNUSED = 0,
+			   VNIC_RESET_FAILOVER = 1,
 			   VNIC_RESET_MOBILITY,
 			   VNIC_RESET_FATAL,
 			   VNIC_RESET_NON_FATAL,
 			   VNIC_RESET_TIMEOUT,
-			   VNIC_RESET_CHANGE_PARAM};
-
-struct ibmvnic_rwi {
-	enum ibmvnic_reset_reason reset_reason;
-	struct list_head list;
-};
+			   VNIC_RESET_CHANGE_PARAM,
+			   VNIC_RESET_MAX};	/* must be last */
 
 struct ibmvnic_tunables {
 	u64 rx_queues;
@@ -1082,7 +1079,8 @@ struct ibmvnic_adapter {
 	enum vnic_state state;
 	enum ibmvnic_reset_reason reset_reason;
 	spinlock_t rwi_lock;
-	struct list_head rwi_list;
+	enum ibmvnic_reset_reason pending_resets[VNIC_RESET_MAX-1];
+	short next_reset;
 	struct work_struct ibmvnic_reset;
 	struct delayed_work ibmvnic_delayed_reset;
 	unsigned long resetting;
-- 
2.26.2
