Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43BED2F2873
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 07:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387832AbhALGnt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 01:43:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729325AbhALGns (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 01:43:48 -0500
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CC26C061794
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 22:43:08 -0800 (PST)
Received: by mail-oi1-x233.google.com with SMTP id w124so1318154oia.6
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 22:43:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uxL23eYJ4/SIOr9A1JVXfRa6FfkjIQ+pQUQ2CTOgWSA=;
        b=pp7+93wb0N3Wouq/ikHRk24tWpavlmww7TL2QVJqG1kIIfG1ghaVJcOjdqik/uduNM
         68NWv6c9G6jGjN+geSH0YgU+JSKfKh6qlmGfEXeOfefSNar5deLcKPGca+/jhxEZNn/9
         di4lrG2FyQrC88nMoncph9KX/7PmI+jOoP3OppSaz7iTLixMu2/hX97DyRFfUkokLkYU
         TIstmkyahIWHTM7NL3kWDGMnRjpIGlhldNppzhtTZHf3CgoiKMLQQXLEFpADSwHmJznw
         wTyPVC8pehE88Y9bR4kwvWC085k0hkNpqYr092KpsuqRZqKI0w7v/JlOwnZEE3jkvVi9
         gWEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uxL23eYJ4/SIOr9A1JVXfRa6FfkjIQ+pQUQ2CTOgWSA=;
        b=FB4bq8S+xTWCmZvLe2x1xgUVwxerBYJKg7bIr0SipprN5ozuQEsEyWCc3OqM0YkNqF
         D5M9u7mmFv6QgYeaP4/U28mhcP0pieSCF8m2J05RknvqH/N9UIaqGq1IWQBE11H/z0or
         H/G/8NrWqIwplzyPS6i/D6GEO6vLNgteLn/CJK9lSyTECJSBSvAypOiXdGbsLBZNIBqJ
         UlnNMYkq8Myq9YzwCAKYj5ElruxyJSZ43sme/DOCxqJmvvyEyuVTDAaFICcIODld5EXa
         m3oT4+37wF9StQohJx5MGRQaQpc+wYXJMpwkt3mqqcnrnXCWXhG5KPhp35jwnIizTdsp
         GWgA==
X-Gm-Message-State: AOAM5306QjaHtRq2JQJrFLiRsAgwJ2dJ09z8u1DucghG+IY5YnNurTUr
        PFxC84KqU9RAvEJ90voKM9pcKALeRKDPOQ==
X-Google-Smtp-Source: ABdhPJx189WUEQyB+r6VJQMb/W0l+EKMSNijv9HV1csSonstDqlFu7r3jUH5+PrG9Q2rb72PLXWIxA==
X-Received: by 2002:aca:1006:: with SMTP id 6mr1479961oiq.159.1610433787483;
        Mon, 11 Jan 2021 22:43:07 -0800 (PST)
Received: from pear.attlocal.net ([2600:1700:271:1a80:ddc5:e91b:d3cf:e2ba])
        by smtp.gmail.com with ESMTPSA id 94sm482271otw.41.2021.01.11.22.43.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Jan 2021 22:43:07 -0800 (PST)
From:   Lijun Pan <lijunp213@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <lijunp213@gmail.com>
Subject: [PATCH net-next 1/7] ibmvnic: prefer 'unsigned long' over 'unsigned long int'
Date:   Tue, 12 Jan 2021 00:42:59 -0600
Message-Id: <20210112064305.31606-2-lijunp213@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210112064305.31606-1-lijunp213@gmail.com>
References: <20210112064305.31606-1-lijunp213@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following checkpatch warnings:
WARNING: Prefer 'unsigned long' over 'unsigned long int' as the int is unnecessary
WARNING: Prefer 'long' over 'long int' as the int is unnecessary

Signed-off-by: Lijun Pan <lijunp213@gmail.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index f6d3b20a5361..d4ba5f5a2b08 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -3666,8 +3666,8 @@ static int ibmvnic_send_crq(struct ibmvnic_adapter *adapter,
 	int rc;
 
 	netdev_dbg(adapter->netdev, "Sending CRQ: %016lx %016lx\n",
-		   (unsigned long int)cpu_to_be64(u64_crq[0]),
-		   (unsigned long int)cpu_to_be64(u64_crq[1]));
+		   (unsigned long)cpu_to_be64(u64_crq[0]),
+		   (unsigned long)cpu_to_be64(u64_crq[1]));
 
 	if (!adapter->crq.active &&
 	    crq->generic.first != IBMVNIC_CRQ_INIT_CMD) {
@@ -3894,7 +3894,7 @@ static int send_login(struct ibmvnic_adapter *adapter)
 	netdev_dbg(adapter->netdev, "Login Buffer:\n");
 	for (i = 0; i < (adapter->login_buf_sz - 1) / 8 + 1; i++) {
 		netdev_dbg(adapter->netdev, "%016lx\n",
-			   ((unsigned long int *)(adapter->login_buf))[i]);
+			   ((unsigned long *)(adapter->login_buf))[i]);
 	}
 
 	memset(&crq, 0, sizeof(crq));
@@ -4262,7 +4262,7 @@ static void handle_query_ip_offload_rsp(struct ibmvnic_adapter *adapter)
 	netdev_dbg(adapter->netdev, "Query IP Offload Buffer:\n");
 	for (i = 0; i < (sizeof(adapter->ip_offload_buf) - 1) / 8 + 1; i++)
 		netdev_dbg(adapter->netdev, "%016lx\n",
-			   ((unsigned long int *)(buf))[i]);
+			   ((unsigned long *)(buf))[i]);
 
 	netdev_dbg(adapter->netdev, "ipv4_chksum = %d\n", buf->ipv4_chksum);
 	netdev_dbg(adapter->netdev, "ipv6_chksum = %d\n", buf->ipv6_chksum);
@@ -4421,7 +4421,7 @@ static void handle_request_cap_rsp(union ibmvnic_crq *crq,
 	case PARTIALSUCCESS:
 		dev_info(dev, "req=%lld, rsp=%ld in %s queue, retrying.\n",
 			 *req_value,
-			 (long int)be64_to_cpu(crq->request_capability_rsp.
+			 (long)be64_to_cpu(crq->request_capability_rsp.
 					       number), name);
 
 		if (be16_to_cpu(crq->request_capability_rsp.capability) ==
@@ -4492,7 +4492,7 @@ static int handle_login_rsp(union ibmvnic_crq *login_rsp_crq,
 	netdev_dbg(adapter->netdev, "Login Response Buffer:\n");
 	for (i = 0; i < (adapter->login_rsp_buf_sz - 1) / 8 + 1; i++) {
 		netdev_dbg(adapter->netdev, "%016lx\n",
-			   ((unsigned long int *)(adapter->login_rsp_buf))[i]);
+			   ((unsigned long *)(adapter->login_rsp_buf))[i]);
 	}
 
 	/* Sanity checks */
@@ -4835,8 +4835,8 @@ static void ibmvnic_handle_crq(union ibmvnic_crq *crq,
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

