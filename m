Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27D874257EC
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 18:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242722AbhJGQ1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 12:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242661AbhJGQ1j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 12:27:39 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5B8AC061755
        for <netdev@vger.kernel.org>; Thu,  7 Oct 2021 09:25:45 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id z5-20020a17090acb0500b001a04086c030so1406198pjt.6
        for <netdev@vger.kernel.org>; Thu, 07 Oct 2021 09:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=jR9TGkqL0rHmu61LobodF7vDYPToecNjmx/obBnZsyg=;
        b=bVEM34Jn4xhf738uuqkWC0NYlDhF0nR2FSRUS7oBwrsZp0YlqIbijF9zbFQb91Btfe
         vCQbMhcnOq24Hnbm+kfkF2unTwxBZ3O9k1//hiQoK7dY7cDd5c3pwEnMBZbc8qctpwaE
         J5NJzJ4UYz7lG9M8vXxQFTK3J3Pmjv3ceB6kP8rKjV5ZWpw5We2GWExWClpBevuZyJPC
         P0fNd7MK7PRBWT/wRZ4hZqHUVCyHvISzSKLUUotEa8mJfu6HY5K9Ci/VD2uTWFuw6A0X
         Egz5QYsLH4CBRY3gauT9BtM0Z3yE+vZjFwsa1tB6KeLsi3HzPy7T4UFJd1lEZ+tJVBnO
         mPhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=jR9TGkqL0rHmu61LobodF7vDYPToecNjmx/obBnZsyg=;
        b=8E9gxZKRtK6Xh8Qtg5fasl6+S3twBDS7DMBjNQjY0l/FNTjLFOc4JIOYLrwHjd/Fxz
         5FyAdYBD09AHQBQ8b+w5g/l1HBlLRRyPbF/fK8vYGAHFAjMbLe5KUYdTWT0F9cun1jtF
         mn1ooguLtlWRFMQIstsmk7VyLTYYYv2B8pinhWjuwAWfXka6ROeR7NexCnS/mm3uZRBG
         lfJ5+ZIdadodMUR6V8BrpA1nJQ2vhSBO1j6BK9DkqDS8NW0NpNuIcGNB5aX2aHAY+Xqn
         jyLMgPJ7L42KjJwx9LHeViGajMD99Byb3KvIF8xWtO/H+qw/cTHurYdazR/xXEVzVRLU
         22zg==
X-Gm-Message-State: AOAM533Tk0VT5iU1fcM9os1FSXGTr9TcO+b97NOrmndbV6wtcNRIEpcN
        yK1Rlvtg79F2OHqxS7sfqaPw7HsowNxJQWjp4R+wmujtPUFk4EZvBbZTWF8+Fvq0yozGfTM+h99
        ETu9mfaZvtW/nmB5nQMtt0uccQoMRvc8G1T/7UEJyLJpQ57SXN842T7dUKlRJQfz5j7c=
X-Google-Smtp-Source: ABdhPJy1+8f0BDw3SaddSGii5a9yaJTEBQGe/vJ32AbOsRnvpbYeESxBu8/XTcq2aT46ID+S1XD52gLOFWoyaQ==
X-Received: from jeroendb.sea.corp.google.com ([2620:15c:100:202:fe55:7411:11ac:c2a7])
 (user=jeroendb job=sendgmr) by 2002:aa7:88d6:0:b0:44c:5c0b:c8a8 with SMTP id
 k22-20020aa788d6000000b0044c5c0bc8a8mr5276141pff.76.1633623945168; Thu, 07
 Oct 2021 09:25:45 -0700 (PDT)
Date:   Thu,  7 Oct 2021 09:25:32 -0700
In-Reply-To: <20211007162534.1502578-1-jeroendb@google.com>
Message-Id: <20211007162534.1502578-5-jeroendb@google.com>
Mime-Version: 1.0
References: <20211007162534.1502578-1-jeroendb@google.com>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
Subject: [PATCH net-next 5/7] gve: Add netif_set_xps_queue call
From:   Jeroen de Borst <jeroendb@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Catherine Sullivan <csully@google.com>,
        David Awogbemila <awogbemila@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Catherine Sullivan <csully@google.com>

Configure XPS when adding tx queues to the notification blocks.

Fixes: dbdaa67540512 ("gve: Move some static functions to a common file")
Signed-off-by: Catherine Sullivan <csully@google.com>
Signed-off-by: David Awogbemila <awogbemila@google.com>
---
 drivers/net/ethernet/google/gve/gve_utils.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/google/gve/gve_utils.c b/drivers/net/ethernet/google/gve/gve_utils.c
index 93f3dcbeeea9..45ff7a9ab5f9 100644
--- a/drivers/net/ethernet/google/gve/gve_utils.c
+++ b/drivers/net/ethernet/google/gve/gve_utils.c
@@ -18,12 +18,16 @@ void gve_tx_remove_from_block(struct gve_priv *priv, int queue_idx)
 
 void gve_tx_add_to_block(struct gve_priv *priv, int queue_idx)
 {
+	unsigned int active_cpus = min_t(int, priv->num_ntfy_blks / 2,
+					 num_online_cpus());
 	int ntfy_idx = gve_tx_idx_to_ntfy(priv, queue_idx);
 	struct gve_notify_block *block = &priv->ntfy_blocks[ntfy_idx];
 	struct gve_tx_ring *tx = &priv->tx[queue_idx];
 
 	block->tx = tx;
 	tx->ntfy_id = ntfy_idx;
+	netif_set_xps_queue(priv->dev, get_cpu_mask(ntfy_idx % active_cpus),
+			    queue_idx);
 }
 
 void gve_rx_remove_from_block(struct gve_priv *priv, int queue_idx)
-- 
2.33.0.800.g4c38ced690-goog

