Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51E3535BAFF
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 09:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236941AbhDLHls (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 03:41:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236837AbhDLHlr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 03:41:47 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0C55C061574
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 00:41:29 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id m13so12530558oiw.13
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 00:41:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2XJrww2eG4cJLvvogiSKBUXx57S/jNiH3qDaZbV0zCI=;
        b=JvUI07gI6P4EFSAEMQc49ST48XyF988u0nl8GPrWk9SvaL87kACsloqRcNyIFdl9pr
         8PpF5tWem3jCph1Rnwc8n6tu1Pagag2ioOszS08D5L4pvURPYD1y3U66xiP+sWdi9Qir
         6G1O8bUnqyXfK2M54RgIS339dIvviKN6/EaAPebwGeCHbgcH6U0sRbdEJTUPI/Cpfzq/
         QwFgQd7mYXDEQcF1HY/41ZUTAaBgmiBscYh8yvnQ34nF1JteH/8Umnrb5xEs8F7yMau9
         FrLLDRWqntxDBwdCO54GLMyqzhqazQRle+WQDSUi6+0NiZUIGVz/fDAcXwSmgi3KSmvs
         U6PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2XJrww2eG4cJLvvogiSKBUXx57S/jNiH3qDaZbV0zCI=;
        b=h5hID0iMXtDae9gvuKwbJL24I2Urgls5eOtkKkpq3lSziST3aN8d8miq99MOZB8L3q
         ICfqbFNG4/m/Ycu4f9ht47EelNjHYoMIWmZzT25VOCm9piddm1z4I9YFkxXjPETjLME9
         EtYSR9jgmIO3CNIfNwSVpL8hwRjUb9YEvJGkhzyyXafzGDL4/FZp/hj/JqG2TaGgTkJY
         EyVgV1RHueXfXI5YpTZtPrx0zKQJ4L7SvgpyXH1thlQEGGOcL4mCLm5XznwGRdbjyRi6
         aw9EMSosqx2N6WabPzmGSJKYFlWpqMZSpWSyVB0r6VbX435idoT7BucWn1bki6O7nktK
         gSxA==
X-Gm-Message-State: AOAM531isz+9lbiFTIjQUsDEMmjkDbCT14RtgJV46CgAjdfP55gH/rrK
        LzjY8MZFmaO7/FbHMMzO8lUinvCmV+U=
X-Google-Smtp-Source: ABdhPJzYp4zncLICmMGQ9WseipbS6o6JwmnPsmXtVjMErUwy16uaZNbjEoETWPX/eClS9gd0k8+9Tw==
X-Received: by 2002:aca:2b07:: with SMTP id i7mr18884205oik.66.1618213288129;
        Mon, 12 Apr 2021 00:41:28 -0700 (PDT)
Received: from pear.attlocal.net ([2600:1700:271:1a80:70fe:cfb5:1414:607d])
        by smtp.gmail.com with ESMTPSA id 62sm2508421oto.60.2021.04.12.00.41.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Apr 2021 00:41:27 -0700 (PDT)
From:   Lijun Pan <lijunp213@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <lijunp213@gmail.com>
Subject: [PATCH net-next 2/2] ibmvnic: print adapter state as a string
Date:   Mon, 12 Apr 2021 02:41:28 -0500
Message-Id: <20210412074128.9313-3-lijunp213@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210412074128.9313-1-lijunp213@gmail.com>
References: <20210412074128.9313-1-lijunp213@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The adapter state can be added or deleted over different versions
of the source code. Print a string instead of a number.

Signed-off-by: Lijun Pan <lijunp213@gmail.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 67 ++++++++++++++++++++++--------
 1 file changed, 49 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 5c89dd7fa3de..ee9bf18c597f 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -827,6 +827,30 @@ static void release_napi(struct ibmvnic_adapter *adapter)
 	adapter->napi_enabled = false;
 }
 
+static const char *adapter_state_to_string(enum vnic_state state)
+{
+	switch (state) {
+	case VNIC_PROBING:
+		return "PROBING";
+	case VNIC_PROBED:
+		return "PROBED";
+	case VNIC_OPENING:
+		return "OPENING";
+	case VNIC_OPEN:
+		return "OPEN";
+	case VNIC_CLOSING:
+		return "CLOSING";
+	case VNIC_CLOSED:
+		return "CLOSED";
+	case VNIC_REMOVING:
+		return "REMOVING";
+	case VNIC_REMOVED:
+		return "REMOVED";
+	default:
+		return "UNKNOWN";
+	}
+}
+
 static int ibmvnic_login(struct net_device *netdev)
 {
 	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
@@ -905,7 +929,7 @@ static int ibmvnic_login(struct net_device *netdev)
 
 	__ibmvnic_set_mac(netdev, adapter->mac_addr);
 
-	netdev_dbg(netdev, "[S:%d] Login succeeded\n", adapter->state);
+	netdev_dbg(netdev, "[S:%s] Login succeeded\n", adapter_state_to_string(adapter->state));
 	return 0;
 }
 
@@ -1185,8 +1209,9 @@ static int ibmvnic_open(struct net_device *netdev)
 	 * honor our setting below.
 	 */
 	if (adapter->failover_pending || (test_bit(0, &adapter->resetting))) {
-		netdev_dbg(netdev, "[S:%d FOP:%d] Resetting, deferring open\n",
-			   adapter->state, adapter->failover_pending);
+		netdev_dbg(netdev, "[S:%s FOP:%d] Resetting, deferring open\n",
+			   adapter_state_to_string(adapter->state),
+			   adapter->failover_pending);
 		adapter->state = VNIC_OPEN;
 		rc = 0;
 		goto out;
@@ -1350,8 +1375,9 @@ static int ibmvnic_close(struct net_device *netdev)
 	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
 	int rc;
 
-	netdev_dbg(netdev, "[S:%d FOP:%d FRR:%d] Closing\n",
-		   adapter->state, adapter->failover_pending,
+	netdev_dbg(netdev, "[S:%s FOP:%d FRR:%d] Closing\n",
+		   adapter_state_to_string(adapter->state),
+		   adapter->failover_pending,
 		   adapter->force_reset_recovery);
 
 	/* If device failover is pending, just set device state and return.
@@ -1944,9 +1970,11 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 	int i, rc;
 
 	netdev_dbg(adapter->netdev,
-		   "[S:%d FOP:%d] Reset reason: %s, reset_state %d\n",
-		   adapter->state, adapter->failover_pending,
-		   reset_reason_to_string(rwi->reset_reason), reset_state);
+		   "[S:%s FOP:%d] Reset reason: %s, reset_state: %s\n",
+		   adapter_state_to_string(adapter->state),
+		   adapter->failover_pending,
+		   reset_reason_to_string(rwi->reset_reason),
+		   adapter_state_to_string(reset_state));
 
 	adapter->reset_reason = rwi->reset_reason;
 	/* requestor of VNIC_RESET_CHANGE_PARAM already has the rtnl lock */
@@ -2006,8 +2034,8 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 				 * from VNIC_CLOSING state.
 				 */
 				netdev_dbg(netdev,
-					   "Open changed state from %d, updating.\n",
-					   reset_state);
+					   "Open changed state from %s, updating.\n",
+					   adapter_state_to_string(reset_state));
 				reset_state = VNIC_OPEN;
 				adapter->state = VNIC_CLOSING;
 			}
@@ -2148,8 +2176,9 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 	if (!(adapter->reset_reason == VNIC_RESET_CHANGE_PARAM))
 		rtnl_unlock();
 
-	netdev_dbg(adapter->netdev, "[S:%d FOP:%d] Reset done, rc %d\n",
-		   adapter->state, adapter->failover_pending, rc);
+	netdev_dbg(adapter->netdev, "[S:%s FOP:%d] Reset done, rc %d\n",
+		   adapter_state_to_string(adapter->state),
+		   adapter->failover_pending, rc);
 	return rc;
 }
 
@@ -2226,8 +2255,9 @@ static int do_hard_reset(struct ibmvnic_adapter *adapter,
 	/* restore adapter state if reset failed */
 	if (rc)
 		adapter->state = reset_state;
-	netdev_dbg(adapter->netdev, "[S:%d FOP:%d] Hard reset done, rc %d\n",
-		   adapter->state, adapter->failover_pending, rc);
+	netdev_dbg(adapter->netdev, "[S:%s FOP:%d] Hard reset done, rc %d\n",
+		   adapter_state_to_string(adapter->state),
+		   adapter->failover_pending, rc);
 	return rc;
 }
 
@@ -2306,8 +2336,8 @@ static void __ibmvnic_reset(struct work_struct *work)
 			if (rc) {
 				/* give backing device time to settle down */
 				netdev_dbg(adapter->netdev,
-					   "[S:%d] Hard reset failed, waiting 60 secs\n",
-					   adapter->state);
+					   "[S:%s] Hard reset failed, waiting 60 secs\n",
+					   adapter_state_to_string(adapter->state));
 				set_current_state(TASK_UNINTERRUPTIBLE);
 				schedule_timeout(60 * HZ);
 			}
@@ -2335,8 +2365,9 @@ static void __ibmvnic_reset(struct work_struct *work)
 	clear_bit_unlock(0, &adapter->resetting);
 
 	netdev_dbg(adapter->netdev,
-		   "[S:%d FRR:%d WFR:%d] Done processing resets\n",
-		   adapter->state, adapter->force_reset_recovery,
+		   "[S:%s FRR:%d WFR:%d] Done processing resets\n",
+		   adapter_state_to_string(adapter->state),
+		   adapter->force_reset_recovery,
 		   adapter->wait_for_reset);
 }
 
-- 
2.23.0

