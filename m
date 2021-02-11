Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 455CF31854C
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 07:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbhBKGo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 01:44:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbhBKGov (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 01:44:51 -0500
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AB7DC061788
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 22:43:43 -0800 (PST)
Received: by mail-ot1-x334.google.com with SMTP id k10so4280588otl.2
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 22:43:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=it8SmkoPR+YtqAuTi7CdU+4vERt/ARK6RZ7nOtpYH7E=;
        b=KN6gLbCtaXe+mopa7YrEZ6rMPzZvZjqRLUTthB+qPoODuYSq+o/FBQHiwFq/U3sRgY
         TtDcJwdu9H6yT8RRF+tjTIhg6N8BWM43iY3DNyAFX4AJ0Qy0YzvxfA4NPWM5FxttdPVN
         j5X+DFjGW/weliDF11OE5HUtUWfUich9MSG5PeY2xwVwFkhQ67BBf2e0bbew4jP99ATn
         1lDDpwT/3u3hZuQwvk0H5WjMw5p4UsMoOPY4n0ZtdoD4E1BPCnzCZqstK0nD2zYgDG20
         SwzumBlL1Sdifhd+rAtuPaB3Zonrhmrab3zcxdsU29HUI1Es68/csEgVqdiDlXiPrC5t
         b5LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=it8SmkoPR+YtqAuTi7CdU+4vERt/ARK6RZ7nOtpYH7E=;
        b=Gmld1I2jSdRqZTccHk57ollLcsNKXFi103imO2pF/pQazMfXEb9uNKq/y9yunknVh/
         rnsT8f/+1Mqvv58BxiX15ukHUPqDNVQ5UhIShBZptaQF/5MJy9i+A40pB1zpDRODK/fo
         cjZw8HEW9tpmy/f8tN9gsZKtieb6MHCI4xdZLY+hMH9f3H9Tta68PV9nLJlUguP/eUg2
         SaM7XSyN0AZBLq9L1Sa1S/dkZAN60du5n1vNvPw3eKbvcMBtxZG+EyNv6JWTbfS2yQv0
         OiuDTG3IMiOT9M+Q4PSi8a4TkqZfrBZSdztoTbn4qCk6bPDxZ5QLRgj4pEu40P50BThs
         gUJQ==
X-Gm-Message-State: AOAM531eKF8pjHWt2ab/At7FMId7oBApPUl7PndNfGP31YT/m8NVb2/a
        z6SAinIF7e14mmj1QhgqWcVBWXUUmK4=
X-Google-Smtp-Source: ABdhPJzYOzRO6I3b11vOTrK1GTtrUVBtGVNsBzfwP+r/Popnc+9H+8TcVui9u8dJUDMFcrEO4a3c5g==
X-Received: by 2002:a9d:69d9:: with SMTP id v25mr280366oto.126.1613025822659;
        Wed, 10 Feb 2021 22:43:42 -0800 (PST)
Received: from pear.attlocal.net ([2600:1700:271:1a80:302d:c724:5317:9751])
        by smtp.gmail.com with ESMTPSA id y65sm993375oie.50.2021.02.10.22.43.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Feb 2021 22:43:42 -0800 (PST)
From:   Lijun Pan <lijunp213@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <lijunp213@gmail.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH net-next v2 5/8] ibmvnic: fix miscellaneous checks
Date:   Thu, 11 Feb 2021 00:43:22 -0600
Message-Id: <20210211064325.80591-6-lijunp213@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210211064325.80591-1-lijunp213@gmail.com>
References: <20210211064325.80591-1-lijunp213@gmail.com>
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
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 67b09a53d7ac..0c27a1f9663a 100644
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
@@ -2333,7 +2333,8 @@ static int ibmvnic_reset(struct ibmvnic_adapter *adapter,
 
 	if (adapter->state == VNIC_PROBING) {
 		netdev_warn(netdev, "Adapter reset during probe\n");
-		ret = adapter->init_done_rc = EAGAIN;
+		adapter->init_done_rc = EAGAIN;
+		ret = EAGAIN;
 		goto err;
 	}
 
@@ -2746,7 +2747,6 @@ static int ibmvnic_set_channels(struct net_device *netdev,
 			    channels->rx_count, channels->tx_count,
 			    adapter->req_rx_queues, adapter->req_tx_queues);
 	return ret;
-
 }
 
 static void ibmvnic_get_strings(struct net_device *dev, u32 stringset, u8 *data)
@@ -2835,8 +2835,8 @@ static void ibmvnic_get_ethtool_stats(struct net_device *dev,
 		return;
 
 	for (i = 0; i < ARRAY_SIZE(ibmvnic_stats); i++)
-		data[i] = be64_to_cpu(IBMVNIC_GET_STAT(adapter,
-						ibmvnic_stats[i].offset));
+		data[i] = be64_to_cpu(IBMVNIC_GET_STAT
+				      (adapter, ibmvnic_stats[i].offset));
 
 	for (j = 0; j < adapter->req_tx_queues; j++) {
 		data[i] = adapter->tx_stats_buffers[j].packets;
@@ -2876,6 +2876,7 @@ static int ibmvnic_set_priv_flags(struct net_device *netdev, u32 flags)
 
 	return 0;
 }
+
 static const struct ethtool_ops ibmvnic_ethtool_ops = {
 	.get_drvinfo		= ibmvnic_get_drvinfo,
 	.get_msglevel		= ibmvnic_get_msglevel,
@@ -3145,7 +3146,7 @@ static int enable_scrq_irq(struct ibmvnic_adapter *adapter,
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

