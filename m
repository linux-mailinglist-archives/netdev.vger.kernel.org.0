Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A301285CA3
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 12:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbgJGKNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 06:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727297AbgJGKNV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 06:13:21 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEDF2C061755
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 03:13:21 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id t23so2616259pji.0
        for <netdev@vger.kernel.org>; Wed, 07 Oct 2020 03:13:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jGHPc0wsp/eCAEZWmQTtpjy/YIO2n1w06Oj3cEp87eU=;
        b=rODrqZUrUkyhIazNlFRvLiHXCitjbqh+z7UuOi26aO6VwGEjidIoBYV8YjRyd3EBF9
         X5H2OiyG2CJRPDmdFMGEXiKoGxAaIUK+owIfLxW5968XBNxDngPyAqfBPKAShj631bId
         +E1qHqqz9fH8IJPHt+3c7M8uoIfuD8Hc91g+7VvFejnjK0XWxqraLKTf1/X5rzkscTMc
         YvLSWKrz4+LraJviCUw9uvZx5xQ+7w9n83w8xCYuBgw7SNxpfGfSUrWt28MQ/6MRmwgZ
         JhOuK6SOCTGgD2wUK0VUM5Y/+DA/U8d3kf5xvXhUqsJS9kUnYPgX3KF7KDaBRTS0qHnt
         QpQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jGHPc0wsp/eCAEZWmQTtpjy/YIO2n1w06Oj3cEp87eU=;
        b=pBUqTCt1Qmz5u1Hph3/JVakImR80ehDsn3iP7+ahCjgViKDqVkvMMSf0rznHGa6NEO
         us3l0cLqIvBZ9Zt7b2+Q7YWM+mmrHcwFDEBiStrtH1w8rCnplV/ZP1p75aN/cFETZZY3
         i/gU5pVVxg1psWhTL2vNXL7Ef8pM7zHxK09o3Uv68kE9rjfRFoYljSjCBqb+PDxPm9Wt
         rN1PsZCjCZEruerVUsVPjMJOjbi4M5DrKaOnBoBzzhOgM/PmB8mzPYrUu4V/WpjkCEcq
         +sFmE8O7rjmdDtOpJsSHapgOeE2tPJsTgoknyLPQ8IZAiMM9lAbf4Ip+0DlrBWYSstvv
         jXPw==
X-Gm-Message-State: AOAM5306nnACrMv4eMwC8exF4IykT+IFFKdXYt4x8EWQhyOiI0o8WaIe
        vN+t50XGJGW/L+644rY1EiQ=
X-Google-Smtp-Source: ABdhPJxqd9G/RTf6Y6OKZgMxdyiFuicPRBrQ3b0cegGCr5u8bhz40jsv96pCQdm34tDZw636kPC9vQ==
X-Received: by 2002:a17:902:680c:b029:d3:d414:8e32 with SMTP id h12-20020a170902680cb02900d3d4148e32mr2162846plk.17.1602065601306;
        Wed, 07 Oct 2020 03:13:21 -0700 (PDT)
Received: from localhost.localdomain ([49.207.204.22])
        by smtp.gmail.com with ESMTPSA id q24sm1105291pgb.12.2020.10.07.03.13.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 03:13:20 -0700 (PDT)
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
Subject: [net-next v2 7/8] net: smc: convert tasklets to use new tasklet_setup() API
Date:   Wed,  7 Oct 2020 15:42:18 +0530
Message-Id: <20201007101219.356499-8-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201007101219.356499-1-allen.lkml@gmail.com>
References: <20201007101219.356499-1-allen.lkml@gmail.com>
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
index b1ce6ccbf..f23f55805 100644
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
index 1e23cdd41..cbc73a7e4 100644
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

