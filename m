Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35FD62A3D33
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 08:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727810AbgKCHKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 02:10:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbgKCHKv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 02:10:51 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7B58C0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 23:10:51 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id x23so8153649plr.6
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 23:10:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wyxxcSZc1SJ6rvTowrOjryo8LHecdATP5X2cPcq3mdc=;
        b=mj/6GsC5yALid87j12A0nPtQvGrSezfoya+A2rIa1N4HCXgBHgsvwEGjKXyYGTa7rO
         TCoAAqrUm/NHX8oD02IQXOmJq8ZRLvkYJP2usBQKbMSJEwHyNojJ/qHHgHw73PTDf21/
         iAuQpATGfJHB6+klswbJspfplbrqvNggeLyoGBIwA8apGYZ+++6tUv//3BOYQGvE81rR
         05guizYqLd5X0yM92WGLquxDCb87W/S7zQQs5CpUvTW23ClYHIBf5liRmHDiEPhMWuLy
         lMTcW+6EsyeWwZHy9H3LUabcpHyJTtfDTgOL4jstoWdah9pFuF3sj0o6R4VXw4ZJfhGw
         hb5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wyxxcSZc1SJ6rvTowrOjryo8LHecdATP5X2cPcq3mdc=;
        b=EbmXtdJXogVywiMmqlNNHNw99dpQptyHjZj6ZY3HdpfUAOUCqy10f2gjKBxNuJBcAC
         y/Fk3aKRSrn2l6jR5PMEPuw3SLgA9eAwxEnIKk0HzCLS/KPoYNW0Wt/P+dWiSRFaXY5L
         AOBfqNrblxI2f5llC85GvfrFzqDQkvc5oBZyUVvMFuGN/cY4V37pJlrDr3Xs6uG3glgp
         bWuwnB1+87CNhCB/D3TCOaGdKkKP9i3mYjX3M9Zop0MaRnnhG63NbS5CZ/s6sW6GcBTe
         u765EBkAhfwYxcNWqsrDnka2sroYtWGN3lZKOgmcBWOx4Vdp3zCVlR/kMo2FnVQ5BvJC
         xgWQ==
X-Gm-Message-State: AOAM530hybkFVHtgJln2nUOW6axuhKKZDBUkyZHMQzpUPEDQW7YB0JER
        xZAffiN1pUNOdOkzYyt6+ZM=
X-Google-Smtp-Source: ABdhPJxZpHwxSZViSu36Gr+KGc2H61OSN+wF/PTCfnhLPh2JmNWoaO+I6Ufza37vS+/IETSBW+jfjg==
X-Received: by 2002:a17:902:a40c:b029:d6:e361:7e4f with SMTP id p12-20020a170902a40cb02900d6e3617e4fmr1236216plq.58.1604387451354;
        Mon, 02 Nov 2020 23:10:51 -0800 (PST)
Received: from localhost.localdomain ([49.207.216.192])
        by smtp.gmail.com with ESMTPSA id 92sm2020074pjv.32.2020.11.02.23.10.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 23:10:50 -0800 (PST)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     gerrit@erg.abdn.ac.uk, kuba@kernel.org, edumazet@google.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        johannes@sipsolutions.net, alex.aring@gmail.com,
        stefan@datenfreihafen.org, santosh.shilimkar@oracle.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [net-next V3 7/8] net: smc: convert tasklets to use new tasklet_setup() API
Date:   Tue,  3 Nov 2020 12:39:46 +0530
Message-Id: <20201103070947.577831-8-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201103070947.577831-1-allen.lkml@gmail.com>
References: <20201103070947.577831-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <apais@linux.microsoft.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <apais@linux.microsoft.com>
---
 net/smc/smc_cdc.c |  6 +++---
 net/smc/smc_wr.c  | 14 ++++++--------
 2 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
index b1ce6ccbfaec..f23f558054a7 100644
--- a/net/smc/smc_cdc.c
+++ b/net/smc/smc_cdc.c
@@ -389,9 +389,9 @@ static void smc_cdc_msg_recv(struct smc_sock *smc, struct smc_cdc_msg *cdc)
  * Context:
  * - tasklet context
  */
-static void smcd_cdc_rx_tsklet(unsigned long data)
+static void smcd_cdc_rx_tsklet(struct tasklet_struct *t)
 {
-	struct smc_connection *conn = (struct smc_connection *)data;
+	struct smc_connection *conn = from_tasklet(conn, t, rx_tsklet);
 	struct smcd_cdc_msg *data_cdc;
 	struct smcd_cdc_msg cdc;
 	struct smc_sock *smc;
@@ -411,7 +411,7 @@ static void smcd_cdc_rx_tsklet(unsigned long data)
  */
 void smcd_cdc_rx_init(struct smc_connection *conn)
 {
-	tasklet_init(&conn->rx_tsklet, smcd_cdc_rx_tsklet, (unsigned long)conn);
+	tasklet_setup(&conn->rx_tsklet, smcd_cdc_rx_tsklet);
 }
 
 /***************************** init, exit, misc ******************************/
diff --git a/net/smc/smc_wr.c b/net/smc/smc_wr.c
index 1e23cdd41eb1..cbc73a7e4d59 100644
--- a/net/smc/smc_wr.c
+++ b/net/smc/smc_wr.c
@@ -131,9 +131,9 @@ static inline void smc_wr_tx_process_cqe(struct ib_wc *wc)
 	wake_up(&link->wr_tx_wait);
 }
 
-static void smc_wr_tx_tasklet_fn(unsigned long data)
+static void smc_wr_tx_tasklet_fn(struct tasklet_struct *t)
 {
-	struct smc_ib_device *dev = (struct smc_ib_device *)data;
+	struct smc_ib_device *dev = from_tasklet(dev, t, send_tasklet);
 	struct ib_wc wc[SMC_WR_MAX_POLL_CQE];
 	int i = 0, rc;
 	int polled = 0;
@@ -435,9 +435,9 @@ static inline void smc_wr_rx_process_cqes(struct ib_wc wc[], int num)
 	}
 }
 
-static void smc_wr_rx_tasklet_fn(unsigned long data)
+static void smc_wr_rx_tasklet_fn(struct tasklet_struct *t)
 {
-	struct smc_ib_device *dev = (struct smc_ib_device *)data;
+	struct smc_ib_device *dev = from_tasklet(dev, t, recv_tasklet);
 	struct ib_wc wc[SMC_WR_MAX_POLL_CQE];
 	int polled = 0;
 	int rc;
@@ -698,10 +698,8 @@ void smc_wr_remove_dev(struct smc_ib_device *smcibdev)
 
 void smc_wr_add_dev(struct smc_ib_device *smcibdev)
 {
-	tasklet_init(&smcibdev->recv_tasklet, smc_wr_rx_tasklet_fn,
-		     (unsigned long)smcibdev);
-	tasklet_init(&smcibdev->send_tasklet, smc_wr_tx_tasklet_fn,
-		     (unsigned long)smcibdev);
+	tasklet_setup(&smcibdev->recv_tasklet, smc_wr_rx_tasklet_fn);
+	tasklet_setup(&smcibdev->send_tasklet, smc_wr_tx_tasklet_fn);
 }
 
 int smc_wr_create_link(struct smc_link *lnk)
-- 
2.25.1

