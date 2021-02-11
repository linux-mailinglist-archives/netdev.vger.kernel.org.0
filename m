Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F49D318546
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 07:45:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbhBKGoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 01:44:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbhBKGoM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 01:44:12 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E701C06174A
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 22:43:32 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id f3so1256948oiw.13
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 22:43:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x4+lzBuS/8r1ddumjZi3hvgG7HGx5HOlfFmw5XCNZfE=;
        b=tzeZ+VAPwyJBxrDCYroddn2W68pF9+UNXbYQjoRbTP20LXCwLsrvVgIwzXEK26AvWp
         r5IrzoeKnJ6HTs2fhPrcXxTYVJEmXzXqhWUZbo7B6C/mGGYGTIt7Q2NkxysNOLTNPhHU
         VkwPNfbQqKVqTj6/UEtY9QE9hjjeafpCoWlQVQsjXwUtRvVU++whK4DmgQ7ZGdQj5LWE
         DPyfqU3OgEj+N34XYO50gTBAFVo+VLgfUbs6AYcJkMwORyzRXkPU4091lWpAGwqYoAFa
         XwgdX0ivsIRGzCQ5fspsPJ0Fw1hndtsIInyn9V0duf7eotuGXjM6K9bKE9gW+UeSoFUz
         5DWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x4+lzBuS/8r1ddumjZi3hvgG7HGx5HOlfFmw5XCNZfE=;
        b=K1L2zlsuq8xjkm6sLYtnbOhKhqNl0dnxztjWlD96XlVFCqk9Z9gTKzloBqk+VhGiO4
         iLPrrPCO7/IuBHJRTNC2XVXRUxiSnYKtNRdlO7emC4Rppev5tXF0d2/XxreU0q3wQYpA
         PKY2L5aMvnh06r1owDIfef6DoQE3gaIzl0ycot2Cn1x/1yJgyasWr0I3izCMXwZKeCWZ
         YzBlIk9hA4R0acJ1xuxfn034S86wVXK2zGWKKAG7oljXpJ+/qwFlVHD7eDSj8kA51L8C
         BWKtOyof+oq/n4TbvrQ4VO7C2uWMZslwUgDZ5GLypxxmTO2xMbVXhSx1r2WN+sAmxoaT
         UkuQ==
X-Gm-Message-State: AOAM531+z3NFYrq5cAWvjpxZ+bj1gW+lwhMyTd8Q4SdssIl9SlvLKo69
        m+zZMLnwKmR7rM3t34mVt6mkEb5qe4w=
X-Google-Smtp-Source: ABdhPJx3cSKjaHCzjB9SkBMpmdFRzWvKFzeiW6ctwuw9lM6aCmfsnX8kvCYUR/dHPS/HHRxcUGUxMQ==
X-Received: by 2002:aca:af0c:: with SMTP id y12mr1814008oie.26.1613025811673;
        Wed, 10 Feb 2021 22:43:31 -0800 (PST)
Received: from pear.attlocal.net ([2600:1700:271:1a80:302d:c724:5317:9751])
        by smtp.gmail.com with ESMTPSA id y65sm993375oie.50.2021.02.10.22.43.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Feb 2021 22:43:31 -0800 (PST)
From:   Lijun Pan <lijunp213@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <lijunp213@gmail.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH net-next v2 1/8] ibmvnic: prefer 'unsigned long' over 'unsigned long int'
Date:   Thu, 11 Feb 2021 00:43:18 -0600
Message-Id: <20210211064325.80591-2-lijunp213@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210211064325.80591-1-lijunp213@gmail.com>
References: <20210211064325.80591-1-lijunp213@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following checkpatch warnings:
WARNING: Prefer 'unsigned long' over 'unsigned long int' as the int is unnecessary
WARNING: Prefer 'long' over 'long int' as the int is unnecessary

Signed-off-by: Lijun Pan <lijunp213@gmail.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index a1579cd4bfe1..55970f02d9da 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -3654,8 +3654,8 @@ static int ibmvnic_send_crq(struct ibmvnic_adapter *adapter,
 	int rc;
 
 	netdev_dbg(adapter->netdev, "Sending CRQ: %016lx %016lx\n",
-		   (unsigned long int)cpu_to_be64(u64_crq[0]),
-		   (unsigned long int)cpu_to_be64(u64_crq[1]));
+		   (unsigned long)cpu_to_be64(u64_crq[0]),
+		   (unsigned long)cpu_to_be64(u64_crq[1]));
 
 	if (!adapter->crq.active &&
 	    crq->generic.first != IBMVNIC_CRQ_INIT_CMD) {
@@ -3884,7 +3884,7 @@ static int send_login(struct ibmvnic_adapter *adapter)
 	netdev_dbg(adapter->netdev, "Login Buffer:\n");
 	for (i = 0; i < (adapter->login_buf_sz - 1) / 8 + 1; i++) {
 		netdev_dbg(adapter->netdev, "%016lx\n",
-			   ((unsigned long int *)(adapter->login_buf))[i]);
+			   ((unsigned long *)(adapter->login_buf))[i]);
 	}
 
 	memset(&crq, 0, sizeof(crq));
@@ -4252,7 +4252,7 @@ static void handle_query_ip_offload_rsp(struct ibmvnic_adapter *adapter)
 	netdev_dbg(adapter->netdev, "Query IP Offload Buffer:\n");
 	for (i = 0; i < (sizeof(adapter->ip_offload_buf) - 1) / 8 + 1; i++)
 		netdev_dbg(adapter->netdev, "%016lx\n",
-			   ((unsigned long int *)(buf))[i]);
+			   ((unsigned long *)(buf))[i]);
 
 	netdev_dbg(adapter->netdev, "ipv4_chksum = %d\n", buf->ipv4_chksum);
 	netdev_dbg(adapter->netdev, "ipv6_chksum = %d\n", buf->ipv6_chksum);
@@ -4411,7 +4411,7 @@ static void handle_request_cap_rsp(union ibmvnic_crq *crq,
 	case PARTIALSUCCESS:
 		dev_info(dev, "req=%lld, rsp=%ld in %s queue, retrying.\n",
 			 *req_value,
-			 (long int)be64_to_cpu(crq->request_capability_rsp.
+			 (long)be64_to_cpu(crq->request_capability_rsp.
 					       number), name);
 
 		if (be16_to_cpu(crq->request_capability_rsp.capability) ==
@@ -4482,7 +4482,7 @@ static int handle_login_rsp(union ibmvnic_crq *login_rsp_crq,
 	netdev_dbg(adapter->netdev, "Login Response Buffer:\n");
 	for (i = 0; i < (adapter->login_rsp_buf_sz - 1) / 8 + 1; i++) {
 		netdev_dbg(adapter->netdev, "%016lx\n",
-			   ((unsigned long int *)(adapter->login_rsp_buf))[i]);
+			   ((unsigned long *)(adapter->login_rsp_buf))[i]);
 	}
 
 	/* Sanity checks */
@@ -4825,8 +4825,8 @@ static void ibmvnic_handle_crq(union ibmvnic_crq *crq,
 	long rc;
 
 	netdev_dbg(netdev, "Handling CRQ: %016lx %016lx\n",
-		   (unsigned long int)cpu_to_be64(u64_crq[0]),
-		   (unsigned long int)cpu_to_be64(u64_crq[1]));
+		   (unsigned long)cpu_to_be64(u64_crq[0]),
+		   (unsigned long)cpu_to_be64(u64_crq[1]));
 	switch (gen_crq->first) {
 	case IBMVNIC_CRQ_INIT_RSP:
 		switch (gen_crq->cmd) {
-- 
2.23.0

