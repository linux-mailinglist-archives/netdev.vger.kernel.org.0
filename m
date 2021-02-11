Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8421318549
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 07:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbhBKGoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 01:44:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbhBKGoU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 01:44:20 -0500
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80A3CC061786
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 22:43:40 -0800 (PST)
Received: by mail-oo1-xc29.google.com with SMTP id t196so1098089oot.2
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 22:43:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZnztfgT8qvtCptuO4dkMSZ08gS4MffnWEFlzWYw2qm8=;
        b=FJltONKyAx2e/ZbByHoX7rvTdfWri6lWf3IDcIbO9jfgLsm27GpLAqZnX+MSeTNmH8
         u4RU3DL5cekAPNcrgqGP4LpG+s7tnZGazMJ1deJ1LaR/fFOdxGMy4cqGc46Do/SWwFH7
         xLBWFGHZckmk0qYtf6eNEA2tb/lOeVbvOZ6+uXiVZUXw42JutP3u5ECWbUxjvxFqR8By
         1NIYX4pIHLTVl2fkvjfQEgFSJ+WmLnwIXrZQT4rY/I1iEqLosGYmJzd2CggtsPL61WTH
         Mcz2MfwQbasQz8Tp5S4suIMJxnPlgxgqUhWSkqQCcejwJXxFF+2nI3YloTdPIZ0+WBtb
         9CFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZnztfgT8qvtCptuO4dkMSZ08gS4MffnWEFlzWYw2qm8=;
        b=aLvKnYoIvrrgM5jP6q0jpZsrJ1aH9u0IhwCgh1PWrdi7NEu7I/j3ZbnSQ8FpplSV8r
         Mb6ctT9lbVNRaQmjIIvpJZpOzwXXcWWciwRkBqIrrLKkqBZCnh16Sa9lvBGohJaYimPY
         7kC/W6zeUyrSQeAOPpMCbfJaU94JyBp231H8G8JOePz0pNnpzo4vssprukZiU92Yoh71
         dAXxHOnL6NRToAGh30aoGS8xVwQi1NoLpznCj4OvI/KFyXZmoL6oPuu8ydrbWAV9rd35
         fa+5RbZwhUb1Mhy2XrLGdXtAjDcIvu2kJmzj5ZxKdIq1aWg2WaqIbhhoNEmV8nmMShuS
         EH1Q==
X-Gm-Message-State: AOAM531ffbK4Zoa6hGAkBxBevb/atfaOBo8kZbDJQ3upFGe+5d7MQY7e
        Y7pt1ndqis4FanTMUE9/Q11+tzcF4E4=
X-Google-Smtp-Source: ABdhPJy5e/mUrfVG9+bM010mQjQ/sQ60sFgBwcPO9ZIVJMJDE4ufJNZv2gBR3Lft/OzbtRKt8U6jbg==
X-Received: by 2002:a4a:dc51:: with SMTP id q17mr4598431oov.76.1613025819677;
        Wed, 10 Feb 2021 22:43:39 -0800 (PST)
Received: from pear.attlocal.net ([2600:1700:271:1a80:302d:c724:5317:9751])
        by smtp.gmail.com with ESMTPSA id y65sm993375oie.50.2021.02.10.22.43.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Feb 2021 22:43:39 -0800 (PST)
From:   Lijun Pan <lijunp213@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <lijunp213@gmail.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH net-next v2 4/8] ibmvnic: avoid multiple line dereference
Date:   Thu, 11 Feb 2021 00:43:21 -0600
Message-Id: <20210211064325.80591-5-lijunp213@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210211064325.80591-1-lijunp213@gmail.com>
References: <20210211064325.80591-1-lijunp213@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following checkpatch warning:
WARNING: Avoid multiple line dereference

Signed-off-by: Lijun Pan <lijunp213@gmail.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 6c1fc73d66dc..67b09a53d7ac 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2440,9 +2440,8 @@ static int ibmvnic_poll(struct napi_struct *napi, int budget)
 		if (!pending_scrq(adapter, rx_scrq))
 			break;
 		next = ibmvnic_next_scrq(adapter, rx_scrq);
-		rx_buff =
-		    (struct ibmvnic_rx_buff *)be64_to_cpu(next->
-							  rx_comp.correlator);
+		rx_buff = (struct ibmvnic_rx_buff *)
+			  be64_to_cpu(next->rx_comp.correlator);
 		/* do error checking */
 		if (next->rx_comp.rc) {
 			netdev_dbg(netdev, "rx buffer returned with rc %x\n",
@@ -3855,15 +3854,15 @@ static int send_login(struct ibmvnic_adapter *adapter)
 
 	for (i = 0; i < adapter->req_tx_queues; i++) {
 		if (adapter->tx_scrq[i]) {
-			tx_list_p[i] = cpu_to_be64(adapter->tx_scrq[i]->
-						   crq_num);
+			tx_list_p[i] =
+				cpu_to_be64(adapter->tx_scrq[i]->crq_num);
 		}
 	}
 
 	for (i = 0; i < adapter->req_rx_queues; i++) {
 		if (adapter->rx_scrq[i]) {
-			rx_list_p[i] = cpu_to_be64(adapter->rx_scrq[i]->
-						   crq_num);
+			rx_list_p[i] =
+				cpu_to_be64(adapter->rx_scrq[i]->crq_num);
 		}
 	}
 
@@ -4406,8 +4405,8 @@ static void handle_request_cap_rsp(union ibmvnic_crq *crq,
 	case PARTIALSUCCESS:
 		dev_info(dev, "req=%lld, rsp=%ld in %s queue, retrying.\n",
 			 *req_value,
-			 (long)be64_to_cpu(crq->request_capability_rsp.
-					       number), name);
+			 (long)be64_to_cpu(crq->request_capability_rsp.number),
+			 name);
 
 		if (be16_to_cpu(crq->request_capability_rsp.capability) ==
 		    REQ_MTU) {
-- 
2.23.0

