Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05D4F35BAFE
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 09:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236930AbhDLHlp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 03:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236837AbhDLHlp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 03:41:45 -0400
Received: from mail-oo1-xc30.google.com (mail-oo1-xc30.google.com [IPv6:2607:f8b0:4864:20::c30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02017C061574
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 00:41:28 -0700 (PDT)
Received: by mail-oo1-xc30.google.com with SMTP id i25-20020a4aa1190000b02901bbd9429832so2856026ool.0
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 00:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OD9w8Kmg0mzXYvbDUWGakxasKghAMLGXaDnFTp1OrKw=;
        b=loLt4qb2J3aRPFyRgr07WATaBS8gBNjRp0TvwbLgcrKnaHTA1TQhyMbx/48KYk/FOE
         tIXe6OOADDpG1A4sEseLsfroqdklgyJRMfr7ixRMrteEPJTI6h4WiurCZb43lxS/8euk
         7QAFZkkcvWhRqxbxZqWvoNIoQMYpGBkASEuEUmoxTIABxu3G8MvrL/rnxA2kISlygF/A
         6gYJcQPc7Tduafa+VGm78/7lRNwf2fpNh2dTNxYHbYGIiHBJOFtfaoKGWpkLDky2cxfm
         hKA3qnqryTUay8K70I5MfK5fwQLTpck7IcQkSuR3MaCHVXGUrZze5BNLB6phND0kjzHW
         ZPgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OD9w8Kmg0mzXYvbDUWGakxasKghAMLGXaDnFTp1OrKw=;
        b=iEzInlZI67fLO6LzymkGoaMODg6qaHPa+CW8xS0BsadnXSZ92mnAf+sn5EhJQLxIx6
         oxHk+5Q8mdGLN1/WFlb6W08BEhnm8gmzMO4jl693O56HjmXmryCW5xUiMwQw8WoJZkZs
         Biu4jXWC2QKkF8TuWoOvv3mZOTJ78n1+W+9SfSLiHSULBCeYllKxpjxjiRkM0l9zixh1
         oHRl8+U6yYWD3MBmhTHQRG3ANKWhmCM2SvwQGxNEceE8aqWxTrycPoSoN/tXlvNTwyyu
         diEZ9oX3BDHtu6llaPiOZqLK0bT0PztRWS2kjjH4xWUXQkVCAI/VNPAoTsicZnirFEoM
         8UOQ==
X-Gm-Message-State: AOAM531xdADQTlsjYWLb5kvwPco0Hx5qA+lR1E3BjNaiFvoxk/RqbsAF
        4pzMHAiSVlYRRHEiHf3Tn31lNcnIRM4=
X-Google-Smtp-Source: ABdhPJwbkydzkhLrJU2glngzNmaZuI1T6utDQkojg1Br6olXCBsJiNy0Ph/rO968bypmd0CR+MyteQ==
X-Received: by 2002:a4a:e1d3:: with SMTP id n19mr1908059oot.21.1618213287246;
        Mon, 12 Apr 2021 00:41:27 -0700 (PDT)
Received: from pear.attlocal.net ([2600:1700:271:1a80:70fe:cfb5:1414:607d])
        by smtp.gmail.com with ESMTPSA id 62sm2508421oto.60.2021.04.12.00.41.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Apr 2021 00:41:26 -0700 (PDT)
From:   Lijun Pan <lijunp213@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <lijunp213@gmail.com>
Subject: [PATCH net-next 1/2] ibmvnic: print reset reason as a string
Date:   Mon, 12 Apr 2021 02:41:27 -0500
Message-Id: <20210412074128.9313-2-lijunp213@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210412074128.9313-1-lijunp213@gmail.com>
References: <20210412074128.9313-1-lijunp213@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The reset reason can be added or deleted over different versions
of the source code. Print a string instead of a number.

Signed-off-by: Lijun Pan <lijunp213@gmail.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 35 ++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 473411542911..5c89dd7fa3de 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1911,6 +1911,26 @@ static int ibmvnic_set_mac(struct net_device *netdev, void *p)
 	return rc;
 }
 
+static const char *reset_reason_to_string(enum ibmvnic_reset_reason reason)
+{
+	switch (reason) {
+	case VNIC_RESET_FAILOVER:
+		return "FAILOVER";
+	case VNIC_RESET_MOBILITY:
+		return "MOBILITY";
+	case VNIC_RESET_FATAL:
+		return "FATAL";
+	case VNIC_RESET_NON_FATAL:
+		return "NON_FATAL";
+	case VNIC_RESET_TIMEOUT:
+		return "TIMEOUT";
+	case VNIC_RESET_CHANGE_PARAM:
+		return "CHANGE_PARAM";
+	default:
+		return "UNKNOWN";
+	}
+}
+
 /*
  * do_reset returns zero if we are able to keep processing reset events, or
  * non-zero if we hit a fatal error and must halt.
@@ -1924,9 +1944,9 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 	int i, rc;
 
 	netdev_dbg(adapter->netdev,
-		   "[S:%d FOP:%d] Reset reason %d, reset_state %d\n",
+		   "[S:%d FOP:%d] Reset reason: %s, reset_state %d\n",
 		   adapter->state, adapter->failover_pending,
-		   rwi->reset_reason, reset_state);
+		   reset_reason_to_string(rwi->reset_reason), reset_state);
 
 	adapter->reset_reason = rwi->reset_reason;
 	/* requestor of VNIC_RESET_CHANGE_PARAM already has the rtnl lock */
@@ -2139,8 +2159,8 @@ static int do_hard_reset(struct ibmvnic_adapter *adapter,
 	struct net_device *netdev = adapter->netdev;
 	int rc;
 
-	netdev_dbg(adapter->netdev, "Hard resetting driver (%d)\n",
-		   rwi->reset_reason);
+	netdev_dbg(adapter->netdev, "Hard resetting driver (%s)\n",
+		   reset_reason_to_string(rwi->reset_reason));
 
 	/* read the state and check (again) after getting rtnl */
 	reset_state = adapter->state;
@@ -2363,8 +2383,8 @@ static int ibmvnic_reset(struct ibmvnic_adapter *adapter,
 	list_for_each(entry, &adapter->rwi_list) {
 		tmp = list_entry(entry, struct ibmvnic_rwi, list);
 		if (tmp->reset_reason == reason) {
-			netdev_dbg(netdev, "Skipping matching reset, reason=%d\n",
-				   reason);
+			netdev_dbg(netdev, "Skipping matching reset, reason=%s\n",
+				   reset_reason_to_string(reason));
 			ret = EBUSY;
 			goto err;
 		}
@@ -2384,7 +2404,8 @@ static int ibmvnic_reset(struct ibmvnic_adapter *adapter,
 	}
 	rwi->reset_reason = reason;
 	list_add_tail(&rwi->list, &adapter->rwi_list);
-	netdev_dbg(adapter->netdev, "Scheduling reset (reason %d)\n", reason);
+	netdev_dbg(adapter->netdev, "Scheduling reset (reason %s)\n",
+		   reset_reason_to_string(reason));
 	schedule_work(&adapter->ibmvnic_reset);
 
 	ret = 0;
-- 
2.23.0

