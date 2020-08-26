Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4592125351F
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 18:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgHZQnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 12:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728019AbgHZQma (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 12:42:30 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD13EC061756
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 09:42:29 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id p11so1254120pfn.11
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 09:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vd7WMar2kA1GekGixsbrKLPoor9vKFuUrGkIjjozsF8=;
        b=aKr5sQMmrhEICzZrxutec9QyNRhtuXAEv09W+Ay+rpihNdD1mcjDSIlnfaqpzxhk3d
         xxGXiCK0bzGWyT/Mp/62kNuCL5/LHig0SMGzJu4/sXKkj9Pqp5eivUy3L3237tUv4ARt
         Uega4v5nQg40y7Z+E4MEtJ5dSf0mGxTcRPLtf3ymEwYV96X+N/gFDFBdeO2SlurLzGQr
         Y8QknaPDYo0670IBMyjcn3FlUbsiPP4jyuaTNgqawtVndlueRPV6qdlauCkl/Ct9qO5x
         d4z0xW7ICCpXbCj037okXg5CuAhZRuubobNEW1NHTBseTZ/TqmxtD03ppkMxxzGJRwxb
         3GMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vd7WMar2kA1GekGixsbrKLPoor9vKFuUrGkIjjozsF8=;
        b=C877V4tn6D/4mbps9lyv0mCJusvLIsp5ir3UbFP0Gl1AmjHwRFb7y6saXg4+wDJ5uV
         5+h1FnkFywOsBR32e7t0/r8+kSBt0nXEE1J6e40RVZgZEikBkWnEmBDZaxQ20KewTFeP
         6EGDGtp3bwU69xGrnu/KgVOCtlLHK6JZEvQTOOFfbgdZXFklwUcOdl2ZFbev1RRiWq+w
         nLINl+slosSqdmlOhgvbgRB8g0trimEhJariZgUaH5dfpK7oK1ZRDlHCwn+Dx85PujBx
         o9H82jTPVKcw0lFcMnpejPFPKOK3oIeEA8o2oLBwChXNbDARWpOwdEcalvlyiV81pjsi
         haGg==
X-Gm-Message-State: AOAM532+gj9/ZDbNiQJ1K1iaPSBkJHJxC5zLFzwSLAAzhaTKDd8+Fn34
        xlh05CneUM3tDNITbEQPxv6OU3NSeEK/bg==
X-Google-Smtp-Source: ABdhPJzCJs8EhjvPeVneimCwFaiPsPGlfXdoy4MatNqMwS1Ytkrxe9C3LcZErVfm+ZezMEUYRaiiKQ==
X-Received: by 2002:aa7:84d3:: with SMTP id x19mr12851709pfn.49.1598460148851;
        Wed, 26 Aug 2020 09:42:28 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id h193sm2986052pgc.42.2020.08.26.09.42.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Aug 2020 09:42:28 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 06/12] ionic: clean up unnecessary non-static functions
Date:   Wed, 26 Aug 2020 09:42:08 -0700
Message-Id: <20200826164214.31792-7-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200826164214.31792-1-snelson@pensando.io>
References: <20200826164214.31792-1-snelson@pensando.io>
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

