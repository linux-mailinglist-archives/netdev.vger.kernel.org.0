Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2EA6DB373
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 20:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233588AbjDGSuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 14:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233844AbjDGSt7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 14:49:59 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A3CC67E
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 11:48:49 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id i192-20020a6287c9000000b0062a43acb7faso18461350pfe.8
        for <netdev@vger.kernel.org>; Fri, 07 Apr 2023 11:48:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680893314;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rRZd6iT9a0saoV9His9aWNZlaA/h2S3ztQp0NF3vdFE=;
        b=Hdrln5Fr+4O+kZWNrGHIT8SFI9vXisqcIN6kWNIri/TtIGoknVJg/Q+oBu0XRP6L24
         YT6teYBCIsAycILogx2IL3GbAzGoFdK9hS6IEMvkrWx7L16TAwA1KnQ6TlEa5Cmh7k7I
         v0V/UohiP5ObDnW+jOqEYZsFm0bkUeuuCsDkALD7b4uU+bV+YOHQXApvIZigOdKeMf11
         SiHYiCVcOVajEEhDHA7efMjtspQrzeEgKzeJSJzV/iJw/dJtuUnLOtUcFjao0KS53xra
         9Sh4o23yvsjUTTQaxK1huZ6h1OMppVJOt9PqEhw4Vv7WztIlJ9bSKfGtmt1BE2AbaGbj
         B0gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680893314;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rRZd6iT9a0saoV9His9aWNZlaA/h2S3ztQp0NF3vdFE=;
        b=pgVncBMA6u/zyj8P2ykOfAYoLZa2bInNlRIelPIdsRVzW1pDNdU6XPeO1o1TuoRRCF
         uKI/kznSPDF0x2Bybyal+/5GWsZk54KadNrrfDPSoCXLrsQANVLwvxq6r/fMXzMZqC7a
         gRVw8E88C+HU4UXTdDnB42pS9e64+5ya/QgCf5IzwfDnezGEJ5JIzFzQ68qJCmCjW9aM
         miKNl2zgQXTXHvi0RCtVOEWwd1zItbeDj2K6qu1bAnSZEZMiirmK2kRYi7xCbz+M5VUZ
         ti4h+7DFbZHakwrwEVW2dt/UTmi1oEoAx67fLAZknZbmLdIXUBN4PvP6l/kGs1LlIwaZ
         rrFA==
X-Gm-Message-State: AAQBX9famt2t9edWRqFTzhXNZj7uvUUOLCjkXQTI5UUAyVDsS+wT7BMw
        ydckW87/G2gQ7mcm6Tg/hDsuK4GnHtFoVlWvP26YNCl4KafnxTSZOPOtO0aRpi8Y5kGtqdwrBD1
        lfrZS6HHO/7dSnkO4JciDRTf4D/pJoyDyRlx2g5vtH7XM6wYz1BcUJoeO2PhcG2N1mmw=
X-Google-Smtp-Source: AKy350YG5vl3LRwz80ERS99xaGWBV2xrQGWD8UnJO+GF2ZnxcQdXY0gnD0PKQAQD3mdhv8jOLWhv4m4rWmuwWA==
X-Received: from shailend.sea.corp.google.com ([2620:15c:100:202:62b1:eab4:e12:e9c2])
 (user=shailend job=sendgmr) by 2002:a63:24c3:0:b0:513:2523:1b5f with SMTP id
 k186-20020a6324c3000000b0051325231b5fmr670122pgk.3.1680893314293; Fri, 07 Apr
 2023 11:48:34 -0700 (PDT)
Date:   Fri,  7 Apr 2023 11:48:30 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230407184830.309398-1-shailend@google.com>
Subject: [PATCH net-next] gve: Unify duplicate GQ min pkt desc size constants
From:   Shailend Chand <shailend@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Shailend Chand <shailend@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The two constants accomplish the same thing.

Signed-off-by: Shailend Chand <shailend@google.com>
---
 drivers/net/ethernet/google/gve/gve.h    | 2 --
 drivers/net/ethernet/google/gve/gve_tx.c | 4 ++--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index 4d01c66d2d65..98eb78d98e9f 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -49,8 +49,6 @@
 
 #define GVE_XDP_ACTIONS 5
 
-#define GVE_TX_MAX_HEADER_SIZE 182
-
 #define GVE_GQ_TX_MIN_PKT_DESC_BYTES 182
 
 /* Each slot in the desc ring has a 1:1 mapping to a slot in the data ring */
diff --git a/drivers/net/ethernet/google/gve/gve_tx.c b/drivers/net/ethernet/google/gve/gve_tx.c
index fe6b933e1df1..813da572abca 100644
--- a/drivers/net/ethernet/google/gve/gve_tx.c
+++ b/drivers/net/ethernet/google/gve/gve_tx.c
@@ -730,7 +730,7 @@ static int gve_tx_fill_xdp(struct gve_priv *priv, struct gve_tx_ring *tx,
 	u32 reqi = tx->req;
 
 	pad = gve_tx_fifo_pad_alloc_one_frag(&tx->tx_fifo, len);
-	if (pad >= GVE_TX_MAX_HEADER_SIZE)
+	if (pad >= GVE_GQ_TX_MIN_PKT_DESC_BYTES)
 		pad = 0;
 	info = &tx->info[reqi & tx->mask];
 	info->xdp_frame = frame_p;
@@ -810,7 +810,7 @@ int gve_xdp_xmit_one(struct gve_priv *priv, struct gve_tx_ring *tx,
 {
 	int nsegs;
 
-	if (!gve_can_tx(tx, len + GVE_TX_MAX_HEADER_SIZE - 1))
+	if (!gve_can_tx(tx, len + GVE_GQ_TX_MIN_PKT_DESC_BYTES - 1))
 		return -EBUSY;
 
 	nsegs = gve_tx_fill_xdp(priv, tx, data, len, frame_p, false);
-- 
2.40.0.577.gac1e443424-goog

