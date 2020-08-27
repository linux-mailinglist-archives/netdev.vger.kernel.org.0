Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD17254C96
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 20:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbgH0SIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 14:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726971AbgH0SH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 14:07:56 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31D49C061264
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 11:07:56 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id t185so4106112pfd.13
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 11:07:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vd7WMar2kA1GekGixsbrKLPoor9vKFuUrGkIjjozsF8=;
        b=47bjQXHxlELuLkd1miaeJFmth3amDk/R2n8PHApxTFMi7wyXPQBnKgYP/Ko6hxWSoK
         1VvnR6n3wBMPpote7mPcUm86P3PN8LKt+8kJu3+j4gBX7euIREbvE7tnEBJnC77rpaJK
         lOerVBp4BcHLBWizJCTpNJmAoakxUvSwY6VlPcaumPK3CEBEyf/+ni+2udQAW4kzixTc
         6jxSy74pQWmoZ8BQn5zQv37uNHUsixmMOMwT5HOr6dDcQL4I44k20J1qoDjG+HDJme1E
         yS/vGmG9DEvxiepMM4Y3dmE81hPQROnSgnY+YlNLFgc+0Fd1Rqw51I+1Snv+PMzK0GPB
         ogRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vd7WMar2kA1GekGixsbrKLPoor9vKFuUrGkIjjozsF8=;
        b=KIsVItnN9SXZApE68wWQDYmMCGgulj7X4DNx4ad41hBp3PZyLgJoTvPGqJ8lE1MMYH
         lEeGyGX5kXKMcPoIHknIx5+KBw6JJoVtWUhKmC62wJC6WvxabL96H8KIB+KKK+hQyqor
         QOCtlXJPBg/z1j5XHYn+Go/Jnvc9aBRpwmJlNUHpHBh5IukMzM1ZKkHa2udC5vDeTPSB
         CPPVej1AQ2Ig5//fVqOnTLvUJS4ymSeNBhze3zOUZrsFNoLVLihG3RChCuBTYcjzBarH
         owxKzvqL/kJuu0A4pK5ggvT3mJwVK7l1vhocSDDc4Y/In9phEgPAKAq1bzpYHtsYTDlx
         pRzw==
X-Gm-Message-State: AOAM533Ygvy2bAUm8IhlS3myeBWNhvPvRCgIBIEtaxTz7OxlrK+TNmei
        HdZShVd/LWqBXCwSpD9B7QglxUsb1Zxpaw==
X-Google-Smtp-Source: ABdhPJw5xjqCsN5tyN/ds3fqPoBSYng8gCltu31hxTsVVha+/j1f3O8QddeIee2q+nK8ptcZMqB3iQ==
X-Received: by 2002:a05:6a00:15cb:: with SMTP id o11mr17650107pfu.263.1598551675300;
        Thu, 27 Aug 2020 11:07:55 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id n1sm3480249pfu.2.2020.08.27.11.07.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Aug 2020 11:07:53 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 06/12] ionic: clean up unnecessary non-static functions
Date:   Thu, 27 Aug 2020 11:07:29 -0700
Message-Id: <20200827180735.38166-7-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200827180735.38166-1-snelson@pensando.io>
References: <20200827180735.38166-1-snelson@pensando.io>
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

