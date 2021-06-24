Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B46B3B3917
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 00:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232830AbhFXWLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 18:11:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbhFXWLg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 18:11:36 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BED34C061574
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 15:09:15 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id c29-20020ac86e9d0000b0290247b267c8e4so7452952qtv.22
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 15:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=mpNTeSoEnY7vCu6WVHK75NuVad7XCi4IdNxQzkrVJfU=;
        b=mebf3Ki5WgGBJQMULKsl3AzRP3iZ31AGHuGutUaWG7WzgIP9yfeIPlqwI4zwwOc3DY
         xvRGiXjNMGhaGqRyEsRPP0J7ms8VXF6ZBoVyK23ccKuNs+/4/StzfrrKz7I4ldmaxn/y
         7b2akHppHpu2V/uQNgPouK5jrU2V8D7htSuzgOLUMBYHLrumHGLJNAtboy+CMIhUXosq
         DFzRHBuvd36QWlbRS8xRhCYKl70Bu9mx7M3Ti5o1FyJvikhB/P8CxKuBsQpHkCqxc5Qr
         YB9ymblYtcZQFFDMHHdlujNkNKCIiL/J5FoX+2FlPUuNbojflJFJImfNXI3EpALIGQne
         9dlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=mpNTeSoEnY7vCu6WVHK75NuVad7XCi4IdNxQzkrVJfU=;
        b=T93ZyTUpP08G9ngKPj8tl7q7c6ZJZC1j69/5z9XS/A7Q4t0a18jIiypmmFOQ9TL0zX
         xdFwOkUhe0JfboUut0+jqfWHKvDmmcNX/a2uXONcjFPPg29ugd5gzexvK0tyngs4NZT6
         i6QYBSaH6V+Z3SmmlOJiPkjuJc5PuVTxy5AiVZftaz1iJtrN9cgtQdbgjfZIT4l1es1j
         6BFjq6C55ohzNRD4egbogm5IG1MRlQhTIA/hh/r/JrNhE5W/EB3GUkmy4bBIgigpzr4+
         6S8o71+7QK8NOyt47v2uwltc8AOiuadZ0E7OVZ21jbIcjVUiyVi5nfZBNGAWDU72tzeW
         BiDw==
X-Gm-Message-State: AOAM533+kWZMAsnMQ+y4TAGUjGIxhSzV8W+SqqpJ0S+mnSWUgk6MafEL
        IHULaCSL9lu1zgCgFCscL+tS9Hg=
X-Google-Smtp-Source: ABdhPJzjIgMliBGLSQM4oMxiAtdKlIIufhC+rSQ2MFvBzpnzUnxxQA9fS+pMU5SpVs+CYLTInxf0Z80=
X-Received: from bcf-linux.svl.corp.google.com ([2620:15c:2c4:1:cb6c:4753:6df0:b898])
 (user=bcf job=sendgmr) by 2002:a05:6214:1085:: with SMTP id
 o5mr7850207qvr.13.1624572554811; Thu, 24 Jun 2021 15:09:14 -0700 (PDT)
Date:   Thu, 24 Jun 2021 15:08:52 -0700
Message-Id: <20210624220852.3733930-1-bcf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH net-next] gve: Fix warnings reported for DQO patchset
From:   Bailey Forrest <bcf@google.com>
To:     Bailey Forrest <bcf@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

https://patchwork.kernel.org/project/netdevbpf/list/?series=506637&state=*

- Remove unused variable
- Use correct integer type for string formatting.
- Remove `inline` in C files

Fixes: 9c1a59a2f4bc ("gve: DQO: Add ring allocation and initialization")
Fixes: a57e5de476be ("gve: DQO: Add TX path")
Signed-off-by: Bailey Forrest <bcf@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
---
 drivers/net/ethernet/google/gve/gve_main.c   | 2 +-
 drivers/net/ethernet/google/gve/gve_tx_dqo.c | 9 ++++-----
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 1bf446836724..ac4819c25aca 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -696,7 +696,7 @@ static int gve_destroy_rings(struct gve_priv *priv)
 	return 0;
 }
 
-static inline void gve_rx_free_rings(struct gve_priv *priv)
+static void gve_rx_free_rings(struct gve_priv *priv)
 {
 	if (gve_is_gqi(priv))
 		gve_rx_free_rings_gqi(priv);
diff --git a/drivers/net/ethernet/google/gve/gve_tx_dqo.c b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
index a4906b9df540..05ddb6a75c38 100644
--- a/drivers/net/ethernet/google/gve/gve_tx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
@@ -261,7 +261,7 @@ void gve_tx_free_rings_dqo(struct gve_priv *priv)
 }
 
 /* Returns the number of slots available in the ring */
-static inline u32 num_avail_tx_slots(const struct gve_tx_ring *tx)
+static u32 num_avail_tx_slots(const struct gve_tx_ring *tx)
 {
 	u32 num_used = (tx->dqo_tx.tail - tx->dqo_tx.head) & tx->mask;
 
@@ -727,9 +727,8 @@ static void remove_from_list(struct gve_tx_ring *tx,
 			     struct gve_index_list *list,
 			     struct gve_tx_pending_packet_dqo *pending_packet)
 {
-	s16 index, prev_index, next_index;
+	s16 prev_index, next_index;
 
-	index = pending_packet - tx->dqo.pending_packets;
 	prev_index = pending_packet->prev;
 	next_index = pending_packet->next;
 
@@ -890,9 +889,9 @@ static void remove_miss_completions(struct gve_priv *priv,
 		dev_kfree_skb_any(pending_packet->skb);
 		pending_packet->skb = NULL;
 		tx->dropped_pkt++;
-		net_err_ratelimited("%s: No reinjection completion was received for: %ld.\n",
+		net_err_ratelimited("%s: No reinjection completion was received for: %d.\n",
 				    priv->dev->name,
-				    (pending_packet - tx->dqo.pending_packets));
+				    (int)(pending_packet - tx->dqo.pending_packets));
 
 		pending_packet->state = GVE_PACKET_STATE_TIMED_OUT_COMPL;
 		pending_packet->timeout_jiffies =
-- 
2.32.0.93.g670b81a890-goog

