Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0432AD020
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 07:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728905AbgKJG6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 01:58:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbgKJG6l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 01:58:41 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 927D0C0613CF;
        Mon,  9 Nov 2020 22:58:41 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id q10so10553173pfn.0;
        Mon, 09 Nov 2020 22:58:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=wUCfwIoXBFGejjJ2NoMgucXoGDnUKh4CIguDii/DOwo=;
        b=LIvsDhiZwv0uSPqZ0yDGzO53SUiTfj1EnRcKWVTu2DKxgcGENqMJkWld41+w7TteTo
         ZsnfoBJuA+7CcktOa0mgZvEoo9yi2DA0j3URNwqvGy5hfM68cSWBYMUANZoH3p8JEalX
         I98vYx/6KPXEfq+yHb+Nk0Q66HIEYQrofB7FCe0T679UXUq2BRZaHyWJt4OvyCg126Tp
         wWd4B5M3E/kQTxsuGfSMRjsAwT/fpCZttFwby1xtvDRNNWcFakO5KyjgWZfVroqVIBlJ
         dtX8k0rXj9VOZsaj6zGFgDaCOonxJ/eIdhw1kjQv7bZKHIE5pqkBreVbklV9hg13o9q8
         5HdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=wUCfwIoXBFGejjJ2NoMgucXoGDnUKh4CIguDii/DOwo=;
        b=h0XnDv9IFXnLXU7YMJGMXzxwC2ibsy4958/3016diIm9uExXw2jjE5L0CI3wskQXza
         GmkdNe/Hx8XNRDKG+/yZD4pYFd8r7tNfNoiu2TLPYigAS6tzer80z9/6HerTxqOogG8L
         j1HYlZDIZm6MOBCbyJncBFFI5F5mjXF9JClqY2fpZipvRun69bpXgRhGsmKk1oxl4lGJ
         Q2mqLDgWfHNFo4J2YfmKVfVEAPMWPf40ofuozmjlySZdtGqcqPW2TvKftx9qdW7zzMrO
         diRk5+NiA7/WjdfIB1NllBmHgESYH+Ml0+eYBGH0UZMETP+Jc2EewWM/ceMFVnlR2RLK
         iZUQ==
X-Gm-Message-State: AOAM533yY2F0z2C52nK4RAyVSn781BKSatnps8JcjPHcnk6JH+5F/2x1
        5+ief2RocYdU1jz2FqfD8Vw=
X-Google-Smtp-Source: ABdhPJzMEuN6t9GU4SFeXAdFAFpKB2AHbRzG6mv151g64L7zZIhUJU9TJ5/78eIAI/V8VyBo9VLGRA==
X-Received: by 2002:aa7:8ed0:0:b029:18a:e177:7bce with SMTP id b16-20020aa78ed00000b029018ae1777bcemr17683806pfr.0.1604991518130;
        Mon, 09 Nov 2020 22:58:38 -0800 (PST)
Received: from localhost.localdomain ([8.210.202.142])
        by smtp.gmail.com with ESMTPSA id q23sm13328624pfg.192.2020.11.09.22.58.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Nov 2020 22:58:37 -0800 (PST)
From:   Yejune Deng <yejune.deng@gmail.com>
To:     pizza@shaftnet.org, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, yejune.deng@gmail.com
Subject: [PATCH] Replace a set of atomic_add()
Date:   Tue, 10 Nov 2020 14:58:11 +0800
Message-Id: <1604991491-27908-1-git-send-email-yejune.deng@gmail.com>
X-Mailer: git-send-email 1.9.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

a set of atomic_inc() looks more readable

Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
---
 drivers/net/wireless/st/cw1200/bh.c  | 10 +++++-----
 drivers/net/wireless/st/cw1200/wsm.c |  8 ++++----
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/st/cw1200/bh.c b/drivers/net/wireless/st/cw1200/bh.c
index 02efe84..c364a39 100644
--- a/drivers/net/wireless/st/cw1200/bh.c
+++ b/drivers/net/wireless/st/cw1200/bh.c
@@ -85,7 +85,7 @@ int cw1200_register_bh(struct cw1200_common *priv)
 
 void cw1200_unregister_bh(struct cw1200_common *priv)
 {
-	atomic_add(1, &priv->bh_term);
+	atomic_inc(&priv->bh_term);
 	wake_up(&priv->bh_wq);
 
 	flush_workqueue(priv->bh_workqueue);
@@ -107,7 +107,7 @@ void cw1200_irq_handler(struct cw1200_common *priv)
 	if (/* WARN_ON */(priv->bh_error))
 		return;
 
-	if (atomic_add_return(1, &priv->bh_rx) == 1)
+	if (atomic_inc_return(&priv->bh_rx) == 1)
 		wake_up(&priv->bh_wq);
 }
 EXPORT_SYMBOL_GPL(cw1200_irq_handler);
@@ -120,7 +120,7 @@ void cw1200_bh_wakeup(struct cw1200_common *priv)
 		return;
 	}
 
-	if (atomic_add_return(1, &priv->bh_tx) == 1)
+	if (atomic_inc_return(&priv->bh_tx) == 1)
 		wake_up(&priv->bh_wq);
 }
 
@@ -382,7 +382,7 @@ static int cw1200_bh_tx_helper(struct cw1200_common *priv,
 	BUG_ON(tx_len < sizeof(*wsm));
 	BUG_ON(__le16_to_cpu(wsm->len) != tx_len);
 
-	atomic_add(1, &priv->bh_tx);
+	atomic_inc(&priv->bh_tx);
 
 	tx_len = priv->hwbus_ops->align_size(
 		priv->hwbus_priv, tx_len);
@@ -537,7 +537,7 @@ static int cw1200_bh(void *arg)
 			pr_debug("[BH] Device resume.\n");
 			atomic_set(&priv->bh_suspend, CW1200_BH_RESUMED);
 			wake_up(&priv->bh_evt_wq);
-			atomic_add(1, &priv->bh_rx);
+			atomic_inc(&priv->bh_rx);
 			goto done;
 		}
 
diff --git a/drivers/net/wireless/st/cw1200/wsm.c b/drivers/net/wireless/st/cw1200/wsm.c
index d9b6147..99624dd 100644
--- a/drivers/net/wireless/st/cw1200/wsm.c
+++ b/drivers/net/wireless/st/cw1200/wsm.c
@@ -1139,7 +1139,7 @@ static int wsm_cmd_send(struct cw1200_common *priv,
 			pr_err("Outstanding outgoing frames:  %d\n", priv->hw_bufs_used);
 
 			/* Kill BH thread to report the error to the top layer. */
-			atomic_add(1, &priv->bh_term);
+			atomic_inc(&priv->bh_term);
 			wake_up(&priv->bh_wq);
 			ret = -ETIMEDOUT;
 		}
@@ -1160,7 +1160,7 @@ static int wsm_cmd_send(struct cw1200_common *priv,
 void wsm_lock_tx(struct cw1200_common *priv)
 {
 	wsm_cmd_lock(priv);
-	if (atomic_add_return(1, &priv->tx_lock) == 1) {
+	if (atomic_inc_return(&priv->tx_lock) == 1) {
 		if (wsm_flush_tx(priv))
 			pr_debug("[WSM] TX is locked.\n");
 	}
@@ -1169,7 +1169,7 @@ void wsm_lock_tx(struct cw1200_common *priv)
 
 void wsm_lock_tx_async(struct cw1200_common *priv)
 {
-	if (atomic_add_return(1, &priv->tx_lock) == 1)
+	if (atomic_inc_return(&priv->tx_lock) == 1)
 		pr_debug("[WSM] TX is locked (async).\n");
 }
 
@@ -1223,7 +1223,7 @@ bool wsm_flush_tx(struct cw1200_common *priv)
 void wsm_unlock_tx(struct cw1200_common *priv)
 {
 	int tx_lock;
-	tx_lock = atomic_sub_return(1, &priv->tx_lock);
+	tx_lock = atomic_dec_return(&priv->tx_lock);
 	BUG_ON(tx_lock < 0);
 
 	if (tx_lock == 0) {
-- 
1.9.1

