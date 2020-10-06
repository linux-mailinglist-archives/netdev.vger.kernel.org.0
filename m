Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02B60284615
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 08:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727131AbgJFGdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 02:33:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbgJFGdA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 02:33:00 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 295E4C0613A7
        for <netdev@vger.kernel.org>; Mon,  5 Oct 2020 23:33:00 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id bb1so721706plb.2
        for <netdev@vger.kernel.org>; Mon, 05 Oct 2020 23:33:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=by+tzajr9kAMTTEc6RsIBmmFCfwkhljdRZw/IZM0hSY=;
        b=eskzh5dWvjG6+E2R6ciSgoUDEB97DT55EbgwDyIVh3BhYreBcjyDdMDZTLJ+ir+yq3
         8MFxqVIxUYfpp0zYdBFv3J7eNgTwiuaA3bX1N2A/OkKvL8Voaq23xTDbyaMHWtiCG6+a
         3j4tX2+JtSCsR0U8cgJBKxCoCPsZ32VRw2hs7yHFI4OxwYr49xqAF/KhCElVr0KzMg7H
         iqQ5vDG6nn0TfDqiOObXSNSORp957rGn3SmZggcHXNyeHHWF4QqsINvQK7y6dQ+vptc0
         THvtp9U+WWY0jYYnBb9hYqfUSjUUEZWz24QTYBgC3LvoZs9P86eVpcadj1XpZ32nTTgn
         kHSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=by+tzajr9kAMTTEc6RsIBmmFCfwkhljdRZw/IZM0hSY=;
        b=MAtHIOmKZ68y2wVkzIXPEY1mZEYH6w1qo0/jLMGGFv9jAkVCQga6r026R5jprCp26L
         PUdG/SOk+4OpjvopVGWPiG5kXK504wcacx85+kKvMykI3GSV+XYfqtXXrqtgkGeu1ln2
         dJdvnp0jorNpIXJZtpxZRDHSR7mMz/LnQLYHZ+60EoEIOENOJT3AxWvBpSY0WtO7F0vF
         YuXUpV7NGjD6Re04tfmrTvlv9nsLy1GXi9rwDcLNH9vFCHgSwzMSXh6dZEeCkIc2paUk
         I67WuxvY420ZprShbnuaAIqJJpnguFjTwJHdrrLSBqyx4WI/9nHyf+aSAfzyQxDEOWO3
         chEA==
X-Gm-Message-State: AOAM531yYSrsXY5XtXFm7xeLtAh31eQoBgViE42cyiaAeiPDwvwmO+vB
        pVKn7aLgGPTGVK2dPKvhjrU=
X-Google-Smtp-Source: ABdhPJxAfAF1kDCQ85LfpMOVmjV5GHgnq8jQTxupIhr6nmdNVrdLhuPHLWIqcgqJ9i5ilZPV+8H4KQ==
X-Received: by 2002:a17:90b:118a:: with SMTP id gk10mr2753559pjb.218.1601965979739;
        Mon, 05 Oct 2020 23:32:59 -0700 (PDT)
Received: from localhost.localdomain ([49.207.203.202])
        by smtp.gmail.com with ESMTPSA id 124sm2047361pfd.132.2020.10.05.23.32.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 23:32:59 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     gerrit@erg.abdn.ac.uk, kuba@kernel.org, edumazet@google.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        johannes@sipsolutions.net, alex.aring@gmail.com,
        stefan@datenfreihafen.org, santosh.shilimkar@oracle.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>,
        Allen Pais <apais@linux.microsoft.com>
Subject: [RESEND net-next 7/8] net: smc: convert tasklets to use new tasklet_setup() API
Date:   Tue,  6 Oct 2020 12:02:00 +0530
Message-Id: <20201006063201.294959-8-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201006063201.294959-1-allen.lkml@gmail.com>
References: <20201006063201.294959-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

