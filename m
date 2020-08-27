Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6D7255176
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 01:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728012AbgH0XAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 19:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728146AbgH0XAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 19:00:45 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC26C061234
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 16:00:45 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id x143so4663630pfc.4
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 16:00:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vd7WMar2kA1GekGixsbrKLPoor9vKFuUrGkIjjozsF8=;
        b=Qwd7vKpiDnLtT2UfgHGkcNN8COa7Iv+Gyy8REJe2/4HwQQfddRG5Je5UUEoBGmbf+y
         jl/xJfbKY3PklSp87mG8p8Rx7F7gJFMlyqYM7CQe9Jju6VqJJaPMAaiYWzW1YcFf0/Cw
         WO9y/TbJbks5yCxnwaZqwxBeECIlISC0KMTJCGqua0qKNieI0IA54rZf7Kuu/ouS23jr
         ExPRqkVx60iR0JfMyMBP4RnEG6ogmvI6lsn5BJBgyVBbt27SnOPVvfcjvStX6cWJyEh7
         AL1m/SA0lULq9435O2N1IA0b7j5QIHM0ps97tKFtS5+4p13gnK8U87jrmDg6JkuyKl5c
         P8VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vd7WMar2kA1GekGixsbrKLPoor9vKFuUrGkIjjozsF8=;
        b=EJVPnmdK0ibAJ8YdRhpe2j4HPPYF0G5waEWBzFpfUcxdzysbWcxw0ytB1HUaOggr2n
         CuXDulNiNax688k01xqk53R8FhpsKKBdyxPP/eTYgPUNmuzjidnt1B4dUrB21C7UxpjJ
         ga4p8bq7u+IKRK0JBVvw122K9NnE79Rnoo3MIE5aTGGxXgGNnRfVSy4/feNxg73t75K4
         XlYMs1LyoNZxEDA5qU21ljELOuQQ2KZMvhWWVmCn+wrfsTaCSL5ySxUiSEIP5LStgH28
         whLkQqip9f8STFPQs+IzMyyDTxKtYOLgNEweArsD8jnPvIJqGizSGICCHq8GQe4VJH9m
         nMSw==
X-Gm-Message-State: AOAM530ECHDQZAF9TB56PC+EYqqmckPDGpEm/YvDNRdIeYjucf881JCs
        FPZDPsQVcEg3LeDJpc3QES0wp3ghQxoAoQ==
X-Google-Smtp-Source: ABdhPJwoU0qANyKZf16sWXtw1jNKxIZgo90uSF1Ib+ADoASW6X8W1n8ZtQy5nS3ofqbClLfAavhtVA==
X-Received: by 2002:a17:902:8608:: with SMTP id f8mr17810659plo.66.1598569243671;
        Thu, 27 Aug 2020 16:00:43 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id n22sm3137534pjq.25.2020.08.27.16.00.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Aug 2020 16:00:43 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v3 net-next 06/12] ionic: clean up unnecessary non-static functions
Date:   Thu, 27 Aug 2020 16:00:24 -0700
Message-Id: <20200827230030.43343-7-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200827230030.43343-1-snelson@pensando.io>
References: <20200827230030.43343-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ionic_open() and ionic_stop() are not referenced outside of their
defining file, so make them static.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 4 ++--
 drivers/net/ethernet/pensando/ionic/ionic_lif.h | 2 --
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 03eee682f872..6a50bb6f090c 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1658,7 +1658,7 @@ static int ionic_start_queues(struct ionic_lif *lif)
 	return 0;
 }
 
-int ionic_open(struct net_device *netdev)
+static int ionic_open(struct net_device *netdev)
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
 	int err;
@@ -1704,7 +1704,7 @@ static void ionic_stop_queues(struct ionic_lif *lif)
 	ionic_txrx_disable(lif);
 }
 
-int ionic_stop(struct net_device *netdev)
+static int ionic_stop(struct net_device *netdev)
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index aa1cba74ba9b..517b51190d18 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -236,8 +236,6 @@ int ionic_lif_size(struct ionic *ionic);
 int ionic_lif_rss_config(struct ionic_lif *lif, u16 types,
 			 const u8 *key, const u32 *indir);
 
-int ionic_open(struct net_device *netdev);
-int ionic_stop(struct net_device *netdev);
 int ionic_reset_queues(struct ionic_lif *lif, ionic_reset_cb cb, void *arg);
 
 static inline void debug_stats_txq_post(struct ionic_queue *q,
-- 
2.17.1

