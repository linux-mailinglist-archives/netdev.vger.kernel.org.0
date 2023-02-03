Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7560F68A49A
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 22:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233783AbjBCVVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 16:21:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232000AbjBCVVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 16:21:37 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B6F6A77A9
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 13:21:33 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id x188-20020a2531c5000000b00716de19d76bso5950653ybx.19
        for <netdev@vger.kernel.org>; Fri, 03 Feb 2023 13:21:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=AVHemLtcDj33Q3JI4UAAM97JjEeInx76q6cfRYbvVxM=;
        b=jxktBu+v/awiRa9/42ZpS3n5wKi3eCpVe/9PgAsRxgUXdEewYBusVfcyj2I3qXnO/8
         2UEGfGGrkFOU4O3G/+eHfRcN8FQq+w0LehEDgsageE/6FM/voMhrpW+UFWHczwUNfUqr
         bvrZe4qd+lJgQ1GOCHumqdGJvRhQDH2J5Fjqusrk0+dqyHe70nMcUOdeXI6iXs2xMfHt
         vsULSsLf0lJ3NqchFf5OANLJapjymXzT10O7/kT1MnPT8s5rLJJ69K7ruaj/JNQ1BTdp
         WVhMvnQEjip51QRK8vt4T5TNAnE0TcI6nNrBwelw4I493rB4xVrDdp9b9uxE12e4W1AD
         am2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AVHemLtcDj33Q3JI4UAAM97JjEeInx76q6cfRYbvVxM=;
        b=0/EZWBx712rZxPip0TqoFKKw44+6PVujfTCA4t26duJrA8p8WANPZ/W/91UMYf/avf
         5iBl1ez73MTaJfs/KH/SQr9/3smYnXkgjfXfUBX76kZTClEWYPlDZI4E+F+tStGAke3C
         enZ5qWGVtS9sxmA3vqbGjPmDKypPYVU0KC3gKNiHhQ8XOln+MXxqrWIRjA7abkGgp7QC
         6kp0S1yK8LSfATBQAZY9UUz01S1tgpwuT22mYVuMEmUDb6hxSc8tGdqnkLrBe+ZAvQRQ
         R7qBNwAmBAgN5hJlC3I6B7ZAxvQyfXp2Bi+uNHS099XIeumlk9buTMq0Yywwa5fHxHN4
         k2UA==
X-Gm-Message-State: AO0yUKXKmmfII62EJLiS3KMmh4Gd3l4gYsSd/OqG6PsXw0VPBD3mMnDI
        rHTnsNVn4W5RZe1fz7Klr6nH5tngSuLbsAdVXTgSN/eAkpaloSCuAPuiuaNEsi2Qja919rZ6iP5
        eqsFL4WBceutABjz95k/pqvnTaGqfjNzKyVe10lc42bbsoHgA8EZyEE9yKCdcDllOFMaKo1yzvl
        8P3w==
X-Google-Smtp-Source: AK7set95w45S47JL9Ek7PHdLXem8EKsQs9zWk3H/7c10gmMLfgjPDcDPBdbshrhCIU7WAeM56Vvu64t4HGyLjT+wzHU=
X-Received: from pkaligineedi.sea.corp.google.com ([2620:15c:100:202:6b7c:ea35:60de:b876])
 (user=pkaligineedi job=sendgmr) by 2002:a25:be12:0:b0:855:fafc:7422 with SMTP
 id h18-20020a25be12000000b00855fafc7422mr10ybk.9.1675459291331; Fri, 03 Feb
 2023 13:21:31 -0800 (PST)
Date:   Fri,  3 Feb 2023 13:20:45 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230203212045.1298677-1-pkaligineedi@google.com>
Subject: [PATCH net-next v2] gve: Fix gve interrupt names
From:   Praveen Kaligineedi <pkaligineedi@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Praveen Kaligineedi <pkaligineedi@google.com>,
        Jeroen de Borst <jeroendb@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IRQs are currently requested before the netdevice is registered
and a proper name is assigned to the device. Changing interrupt
name to avoid using the format string in the name.

Interrupt name before change: eth%d-ntfy-block.<blk_id>
Interrupt name after change: gve-ntfy-blk<blk_id>@pci:<pci_name>

Signed-off-by: Praveen Kaligineedi <pkaligineedi@google.com>
Reviewed-by: Jeroen de Borst <jeroendb@google.com>
---
Changed in v2: 
- Updated interrupt names based on the feedback
- Removed Fixes tag
---
 drivers/net/ethernet/google/gve/gve_main.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 5b40f9c53196..07111c241e0e 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -327,7 +327,6 @@ static int gve_napi_poll_dqo(struct napi_struct *napi, int budget)
 static int gve_alloc_notify_blocks(struct gve_priv *priv)
 {
 	int num_vecs_requested = priv->num_ntfy_blks + 1;
-	char *name = priv->dev->name;
 	unsigned int active_cpus;
 	int vecs_enabled;
 	int i, j;
@@ -371,8 +370,8 @@ static int gve_alloc_notify_blocks(struct gve_priv *priv)
 	active_cpus = min_t(int, priv->num_ntfy_blks / 2, num_online_cpus());
 
 	/* Setup Management Vector  - the last vector */
-	snprintf(priv->mgmt_msix_name, sizeof(priv->mgmt_msix_name), "%s-mgmnt",
-		 name);
+	snprintf(priv->mgmt_msix_name, sizeof(priv->mgmt_msix_name), "gve-mgmnt@pci:%s",
+		 pci_name(priv->pdev));
 	err = request_irq(priv->msix_vectors[priv->mgmt_msix_idx].vector,
 			  gve_mgmnt_intr, 0, priv->mgmt_msix_name, priv);
 	if (err) {
@@ -401,8 +400,8 @@ static int gve_alloc_notify_blocks(struct gve_priv *priv)
 		struct gve_notify_block *block = &priv->ntfy_blocks[i];
 		int msix_idx = i;
 
-		snprintf(block->name, sizeof(block->name), "%s-ntfy-block.%d",
-			 name, i);
+		snprintf(block->name, sizeof(block->name), "gve-ntfy-blk%d@pci:%s",
+			 i, pci_name(priv->pdev));
 		block->priv = priv;
 		err = request_irq(priv->msix_vectors[msix_idx].vector,
 				  gve_is_gqi(priv) ? gve_intr : gve_intr_dqo,
-- 
2.39.1.519.gcb327c4b5f-goog

