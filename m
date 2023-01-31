Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7256838CC
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 22:38:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbjAaViL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 16:38:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231656AbjAaViH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 16:38:07 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A033F1EFEA
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 13:37:38 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id q130-20020a632a88000000b004a03cfb3ac6so7329285pgq.6
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 13:37:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3bZD2t4k0gPu8udAjjX6jVXjMh20eSHaCu90Kp2OZAc=;
        b=YE5KtzJPWgD0qx5kA2APinbFORMleD0v6oanJeRb7QijPLu/8lFoprByccRlC9ptHL
         5TjXCHDXyyXolXdSmSTzfujf3DFsmEtQVys3M4lW911R5oKOygA4/pkpEsjv1e0fixAf
         /zLy+c0B/sSUbCKZupetfzPsEIEEWNLDf4H+LfXU3tqqjqnOWe0hrHBMTXkRWqXXIL8h
         qe6mFU74wRi/qjXHtpF4b+VrdNFovwfJ6sOd8AZWS3GhwlVN9gRveYWy2SNI0l5Yv73L
         +Ayr1c1cNTZ8wHsEfCi/3SCA2jW9/eEbuffWhN/I3tvh7IsbL+7XmE4+6lezW2b4WMTz
         RCCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3bZD2t4k0gPu8udAjjX6jVXjMh20eSHaCu90Kp2OZAc=;
        b=5+3cSEykHw2/6Tg2Oe7/FqZCp1YflUiz8FDTgL5jtLp2KjP0Hxv7muBXFZyc1h/VRm
         2xpdqQZpMtrlhXInnsq10tVLdePE1iT/mDSAhuHKYXpS/ZX7k44SVaLRzF3zgICUHksu
         v64CWFhytceooJkkeihvkU9xcH7OL2rx58MRGsjtcVo7PEDpV38Qe3MmBdxY2OOoc3sS
         H0juAl1kl/jW7NmITeV/SWx7BD3LTVXKCkOcDa7zk/fU6z54zl9Vh5Ge/9nXqOIe0xeh
         ezmkBL0oEIefdkCkqXfslCzGmBBhBwZYWOn1mr8BKNiRAv9uhNBV+76tx8O57+infVc7
         9WWA==
X-Gm-Message-State: AO0yUKXMd/cLq55S52tBl/f2AyNq/uOOK89t2DvuvaJZxgeq2gTcvqd9
        hdiZfKtwRZfu6g6wBfE+5vSqImmFiWb1FXDJQrdCMpX19lyKTOcKMVDB5WjNj4KahHrlxIv4rJy
        7jp96TlsEoXa68vFRfjq1fLBd+ebeZx/YEvwvjjTZtbMdj9AUdIQ2UkN2ySuTpdpttk9IHXmkjJ
        gPVg==
X-Google-Smtp-Source: AK7set9P9k0QAnuliDSuMBioJnepUuvW+zNMKBxkqev2tuWhc/QiVas1o05n/W5p7mBsGecuSuBzMeKpK8qqwU8JMAc=
X-Received: from pkaligineedi.sea.corp.google.com ([2620:15c:100:202:b3b0:66c1:e130:ede9])
 (user=pkaligineedi job=sendgmr) by 2002:a17:90a:740b:b0:229:7638:4499 with
 SMTP id a11-20020a17090a740b00b0022976384499mr147824pjg.167.1675201058030;
 Tue, 31 Jan 2023 13:37:38 -0800 (PST)
Date:   Tue, 31 Jan 2023 13:37:14 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230131213714.588281-1-pkaligineedi@google.com>
Subject: [PATCH net-next 1/1] gve: Fix gve interrupt names
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

Fixes: 893ce44df565 ("gve: Add basic driver framework for Compute Engine Virtual NIC")
Signed-off-by: Praveen Kaligineedi <pkaligineedi@google.com>
Reviewed-by: Jeroen de Borst <jeroendb@google.com>
---
 drivers/net/ethernet/google/gve/gve_main.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 5b40f9c53196..534d3ce8ec40 100644
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
+	snprintf(priv->mgmt_msix_name, sizeof(priv->mgmt_msix_name), "gve%d-mgmnt",
+		 PCI_SLOT(priv->pdev->devfn));
 	err = request_irq(priv->msix_vectors[priv->mgmt_msix_idx].vector,
 			  gve_mgmnt_intr, 0, priv->mgmt_msix_name, priv);
 	if (err) {
@@ -401,8 +400,8 @@ static int gve_alloc_notify_blocks(struct gve_priv *priv)
 		struct gve_notify_block *block = &priv->ntfy_blocks[i];
 		int msix_idx = i;
 
-		snprintf(block->name, sizeof(block->name), "%s-ntfy-block.%d",
-			 name, i);
+		snprintf(block->name, sizeof(block->name), "gve%d-ntfy-block.%d",
+			 PCI_SLOT(priv->pdev->devfn), i);
 		block->priv = priv;
 		err = request_irq(priv->msix_vectors[msix_idx].vector,
 				  gve_is_gqi(priv) ? gve_intr : gve_intr_dqo,
-- 
2.39.1.456.gfc5497dd1b-goog

