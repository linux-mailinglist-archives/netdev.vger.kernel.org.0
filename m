Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 157792F2877
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 07:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387993AbhALGoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 01:44:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728321AbhALGoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 01:44:05 -0500
Received: from mail-oo1-xc2f.google.com (mail-oo1-xc2f.google.com [IPv6:2607:f8b0:4864:20::c2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF70C0617A3
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 22:43:11 -0800 (PST)
Received: by mail-oo1-xc2f.google.com with SMTP id j21so347606oou.11
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 22:43:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qw6Igr8pEEQb3qYloEDGppg1SJg0zQ2daP9uTVnsJIg=;
        b=T37ce+zcFyKUHQPLvRHnxh38J++tjRrnAJzzmm8Jh1K4Z/SAoYD/yZYpSGhRP8NPbb
         eW1ajZmGsZVwBAr6LW6z+jcRQN7Fl5QUhEFUAA6R7mJoq8AG/DUy9reRmDdBGdEG2I5c
         NQv9rcjSu/PJh689HkriVIBODAfBI8meWard88PaR1z/IVoZ/KSq/t9jPEzdkl9lJ/4S
         OaXxtN6+TCk7LToOIn5asxKjz/Fva0pbPt5/sH7+Vk9t9I1iC6MIqlMpIELKo4iq3cyb
         n3L4bSfCGhHES93QkFynTySzsYA2GvSDOIkIie2ZV3rAXHHRmUhGIvyJhcmBc4f3BU1Q
         wpTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qw6Igr8pEEQb3qYloEDGppg1SJg0zQ2daP9uTVnsJIg=;
        b=garwcLab6BVCgzQcCW5WC4Yi4voXsGsTnlXGvKe/ko3CiXULY5s+AE1MUh34DC8sYe
         W25h0WJOOavF3teuh1d7jvG1RnZaPQbTqdQVe96qTq+OQHgpiSTMn+E8jhxUNvUwWi7I
         yWQwfjwqgx7yJ3AE09NWuWj6bx0HYvK+Xmt4E5vs0sPNWPpX67DwR0kTRRDqcAYKGnQC
         +vCduiw+ezYFp1EUThr+f9IMQFeC8MGSd7RUyFEcyuK+HVlOqR6oMzSuy19tkcKi9dAp
         LIp6rvwIuKVUpIKG26/C1F6qfzI0SbmyKR0SJYwnv3ZSrwEgNoFWwiBQ2vFDnHXfi+QC
         LcUA==
X-Gm-Message-State: AOAM531+44K4rDKxlbDFF0KuZqyKPhFvycZ27UkoCqqOUGu9EXYDHKTS
        P+YGCOkPzwY25ERJCw+VE9qKeue+Dbu4kw==
X-Google-Smtp-Source: ABdhPJxj9AYx+S6v25tV8sjlPEbE5IIrEuBzIVVzuci5hf3+EL0ylPwwJpJgkOyYgBQjcX66Fdh/yg==
X-Received: by 2002:a4a:d4cd:: with SMTP id r13mr1899573oos.35.1610433790567;
        Mon, 11 Jan 2021 22:43:10 -0800 (PST)
Received: from pear.attlocal.net ([2600:1700:271:1a80:ddc5:e91b:d3cf:e2ba])
        by smtp.gmail.com with ESMTPSA id 94sm482271otw.41.2021.01.11.22.43.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Jan 2021 22:43:10 -0800 (PST)
From:   Lijun Pan <lijunp213@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <lijunp213@gmail.com>
Subject: [PATCH net-next 5/7] ibmvnic: fix miscellaneous checks
Date:   Tue, 12 Jan 2021 00:43:03 -0600
Message-Id: <20210112064305.31606-6-lijunp213@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210112064305.31606-1-lijunp213@gmail.com>
References: <20210112064305.31606-1-lijunp213@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following checkpatch checks:
CHECK: Macro argument 'off' may be better as '(off)' to
avoid precedence issues
CHECK: Alignment should match open parenthesis
CHECK: multiple assignments should be avoided
CHECK: Blank lines aren't necessary before a close brace '}'
CHECK: Please use a blank line after function/struct/union/enum
declarations
CHECK: Unnecessary parentheses around 'rc != H_FUNCTION'

Signed-off-by: Lijun Pan <lijunp213@gmail.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 30add8a8a3dc..f9db139f652b 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -115,7 +115,7 @@ struct ibmvnic_stat {
 
 #define IBMVNIC_STAT_OFF(stat) (offsetof(struct ibmvnic_adapter, stats) + \
 			     offsetof(struct ibmvnic_statistics, stat))
-#define IBMVNIC_GET_STAT(a, off) (*((u64 *)(((unsigned long)(a)) + off)))
+#define IBMVNIC_GET_STAT(a, off) (*((u64 *)(((unsigned long)(a)) + (off))))
 
 static const struct ibmvnic_stat ibmvnic_stats[] = {
 	{"rx_packets", IBMVNIC_STAT_OFF(rx_packets)},
@@ -2069,14 +2069,14 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 			rc = reset_tx_pools(adapter);
 			if (rc) {
 				netdev_dbg(adapter->netdev, "reset tx pools failed (%d)\n",
-						rc);
+					   rc);
 				goto out;
 			}
 
 			rc = reset_rx_pools(adapter);
 			if (rc) {
 				netdev_dbg(adapter->netdev, "reset rx pools failed (%d)\n",
-						rc);
+					   rc);
 				goto out;
 			}
 		}
@@ -2334,7 +2334,8 @@ static int ibmvnic_reset(struct ibmvnic_adapter *adapter,
 
 	if (adapter->state == VNIC_PROBING) {
 		netdev_warn(netdev, "Adapter reset during probe\n");
-		ret = adapter->init_done_rc = EAGAIN;
+		adapter->init_done_rc = EAGAIN;
+		ret = EAGAIN;
 		goto err;
 	}
 
@@ -2754,7 +2755,6 @@ static int ibmvnic_set_channels(struct net_device *netdev,
 			    channels->rx_count, channels->tx_count,
 			    adapter->req_rx_queues, adapter->req_tx_queues);
 	return ret;
-
 }
 
 static void ibmvnic_get_strings(struct net_device *dev, u32 stringset, u8 *data)
@@ -2843,8 +2843,8 @@ static void ibmvnic_get_ethtool_stats(struct net_device *dev,
 		return;
 
 	for (i = 0; i < ARRAY_SIZE(ibmvnic_stats); i++)
-		data[i] = be64_to_cpu(IBMVNIC_GET_STAT(adapter,
-						ibmvnic_stats[i].offset));
+		data[i] = be64_to_cpu(IBMVNIC_GET_STAT
+				      (adapter, ibmvnic_stats[i].offset));
 
 	for (j = 0; j < adapter->req_tx_queues; j++) {
 		data[i] = adapter->tx_stats_buffers[j].packets;
@@ -2884,6 +2884,7 @@ static int ibmvnic_set_priv_flags(struct net_device *netdev, u32 flags)
 
 	return 0;
 }
+
 static const struct ethtool_ops ibmvnic_ethtool_ops = {
 	.get_drvinfo		= ibmvnic_get_drvinfo,
 	.get_msglevel		= ibmvnic_get_msglevel,
@@ -3155,7 +3156,7 @@ static int enable_scrq_irq(struct ibmvnic_adapter *adapter,
 		/* H_EOI would fail with rc = H_FUNCTION when running
 		 * in XIVE mode which is expected, but not an error.
 		 */
-		if (rc && (rc != H_FUNCTION))
+		if (rc && rc != H_FUNCTION)
 			dev_err(dev, "H_EOI FAILED irq 0x%llx. rc=%ld\n",
 				val, rc);
 	}
-- 
2.23.0

