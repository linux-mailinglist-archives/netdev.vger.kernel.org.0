Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D05736EA1F2
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 04:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233870AbjDUCvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 22:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233679AbjDUCvO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 22:51:14 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D015E75;
        Thu, 20 Apr 2023 19:51:10 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 41be03b00d2f7-51f6461af24so1344912a12.2;
        Thu, 20 Apr 2023 19:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682045470; x=1684637470;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c3gqGXUpc3KYe5z+gS2RcAbeFyLxMU5SRbpmpf891/c=;
        b=Yck4T+vntovmXZEumLESoURloMmWy6Y7UkKFCg9sz/cHM75rWCU5t9hODeh8oadjov
         CKPRpKyymA3SnLOPT/xZuRVKtanfT1Mtz+/EtVwVlDldI92ZgCDt4h9bQ9jMVuCxvVp+
         tBldXE72UozeUum3r1fb2CUH8xBtBxtoDX5o10FKWTPr9IKmmHmrYDj4otq73vcOrsqf
         tK3Q6CrE+2cZ9XMOKIz0+A6PRUhD25OgdNVNU2MZbmN8Iwdy9VouZV3PlTyRSmkJWbnv
         hod3xG7N5Qx4EZ+5j3ASi8ZwaA26ZWVTVyfG2PI1T4E/ceijMpoHnleheZE+SMw1Rfe6
         4tvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682045470; x=1684637470;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=c3gqGXUpc3KYe5z+gS2RcAbeFyLxMU5SRbpmpf891/c=;
        b=DITKoWvmLtWLrTsFpPHtNmHHPyxD3KjhfGxj2qK3geRgm37T9gdCizw4mpFP17fcDL
         2AVLpX0yeVtDDtkFn5qQS91bgbN1rP2f8txX5+wKOFL5p+ZwEYVDP4i1BZKJrv+NXRdd
         sfPf1SixWRTNvXJS+lzrtSmlnjGnrCFR0U+ptVc698BjMzx7AGrFAS7ZjWI2xq7eBWSx
         IfBALChL4zeY/y6A6Zb6C3NLCaT9V+Yutw/85ej4DsmLcHgnexngfmsJ5eX06AvCqDx0
         lIAR2VICup0hmt1lv15DZ9viIBNbF3xqg/6EPngyNdK8he2/P5dl5Qz3b0m8fdPUlUcv
         ojkw==
X-Gm-Message-State: AAQBX9dxJmjpxNTvtBtJc+6nN1ta4uDzzEsqemoARXyGUfvkXARqxRNw
        n9BRZwn+v5wk/a3uQ67VE06BCsQWygI=
X-Google-Smtp-Source: AKy350Z3JhT4mTro1Ifrc8y8dKWqiYXcJkAZQoBipxpDZ0HYwLQGZ1riYwHUljvTAJgiORv6QSmR1g==
X-Received: by 2002:a17:902:d2ca:b0:1a2:71c1:c30f with SMTP id n10-20020a170902d2ca00b001a271c1c30fmr4160649plc.7.1682045469766;
        Thu, 20 Apr 2023 19:51:09 -0700 (PDT)
Received: from localhost (2603-800c-1a02-1bae-a7fa-157f-969a-4cde.res6.spectrum.com. [2603:800c:1a02:1bae:a7fa:157f:969a:4cde])
        by smtp.gmail.com with ESMTPSA id j8-20020a170902690800b001a1b66af22fsm1741810plk.62.2023.04.20.19.51.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 19:51:09 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
From:   Tejun Heo <tj@kernel.org>
To:     jiangshanlai@gmail.com
Cc:     linux-kernel@vger.kernel.org, kernel-team@meta.com,
        Tejun Heo <tj@kernel.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 10/22] wifi: mwifiex: Use alloc_ordered_workqueue() to create ordered workqueues
Date:   Thu, 20 Apr 2023 16:50:34 -1000
Message-Id: <20230421025046.4008499-11-tj@kernel.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230421025046.4008499-1-tj@kernel.org>
References: <20230421025046.4008499-1-tj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BACKGROUND
==========

When multiple work items are queued to a workqueue, their execution order
doesn't match the queueing order. They may get executed in any order and
simultaneously. When fully serialized execution - one by one in the queueing
order - is needed, an ordered workqueue should be used which can be created
with alloc_ordered_workqueue().

However, alloc_ordered_workqueue() was a later addition. Before it, an
ordered workqueue could be obtained by creating an UNBOUND workqueue with
@max_active==1. This originally was an implementation side-effect which was
broken by 4c16bd327c74 ("workqueue: restore WQ_UNBOUND/max_active==1 to be
ordered"). Because there were users that depended on the ordered execution,
5c0338c68706 ("workqueue: restore WQ_UNBOUND/max_active==1 to be ordered")
made workqueue allocation path to implicitly promote UNBOUND workqueues w/
@max_active==1 to ordered workqueues.

While this has worked okay, overloading the UNBOUND allocation interface
this way creates other issues. It's difficult to tell whether a given
workqueue actually needs to be ordered and users that legitimately want a
min concurrency level wq unexpectedly gets an ordered one instead. With
planned UNBOUND workqueue updates to improve execution locality and more
prevalence of chiplet designs which can benefit from such improvements, this
isn't a state we wanna be in forever.

This patch series audits all callsites that create an UNBOUND workqueue w/
@max_active==1 and converts them to alloc_ordered_workqueue() as necessary.

WHAT TO LOOK FOR
================

The conversions are from

  alloc_workqueue(WQ_UNBOUND | flags, 1, args..)

to

  alloc_ordered_workqueue(flags, args...)

which don't cause any functional changes. If you know that fully ordered
execution is not ncessary, please let me know. I'll drop the conversion and
instead add a comment noting the fact to reduce confusion while conversion
is in progress.

If you aren't fully sure, it's completely fine to let the conversion
through. The behavior will stay exactly the same and we can always
reconsider later.

As there are follow-up workqueue core changes, I'd really appreciate if the
patch can be routed through the workqueue tree w/ your acks. Thanks.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: Ganapathi Bhat <ganapathi017@gmail.com>
Cc: Sharvari Harisangam <sharvari.harisangam@nxp.com>
Cc: Xinming Hu <huxinming820@gmail.com>
Cc: Kalle Valo <kvalo@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 .../net/wireless/marvell/mwifiex/cfg80211.c   | 13 +++++------
 drivers/net/wireless/marvell/mwifiex/main.c   | 22 +++++++++----------
 2 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index bcd564dc3554..5a7be57ed78a 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -3124,10 +3124,9 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 
 	SET_NETDEV_DEV(dev, adapter->dev);
 
-	priv->dfs_cac_workqueue = alloc_workqueue("MWIFIEX_DFS_CAC%s",
-						  WQ_HIGHPRI |
-						  WQ_MEM_RECLAIM |
-						  WQ_UNBOUND, 1, name);
+	priv->dfs_cac_workqueue =
+		alloc_ordered_workqueue("MWIFIEX_DFS_CAC%s",
+					WQ_HIGHPRI | WQ_MEM_RECLAIM, name);
 	if (!priv->dfs_cac_workqueue) {
 		mwifiex_dbg(adapter, ERROR, "cannot alloc DFS CAC queue\n");
 		ret = -ENOMEM;
@@ -3136,9 +3135,9 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 
 	INIT_DELAYED_WORK(&priv->dfs_cac_work, mwifiex_dfs_cac_work_queue);
 
-	priv->dfs_chan_sw_workqueue = alloc_workqueue("MWIFIEX_DFS_CHSW%s",
-						      WQ_HIGHPRI | WQ_UNBOUND |
-						      WQ_MEM_RECLAIM, 1, name);
+	priv->dfs_chan_sw_workqueue =
+		alloc_ordered_workqueue("MWIFIEX_DFS_CHSW%s",
+					WQ_HIGHPRI | WQ_MEM_RECLAIM, name);
 	if (!priv->dfs_chan_sw_workqueue) {
 		mwifiex_dbg(adapter, ERROR, "cannot alloc DFS channel sw queue\n");
 		ret = -ENOMEM;
diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index ea22a08e6c08..19a6107d115c 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -1546,18 +1546,17 @@ mwifiex_reinit_sw(struct mwifiex_adapter *adapter)
 		adapter->rx_work_enabled = true;
 
 	adapter->workqueue =
-		alloc_workqueue("MWIFIEX_WORK_QUEUE",
-				WQ_HIGHPRI | WQ_MEM_RECLAIM | WQ_UNBOUND, 1);
+		alloc_ordered_workqueue("MWIFIEX_WORK_QUEUE",
+					WQ_HIGHPRI | WQ_MEM_RECLAIM);
 	if (!adapter->workqueue)
 		goto err_kmalloc;
 
 	INIT_WORK(&adapter->main_work, mwifiex_main_work_queue);
 
 	if (adapter->rx_work_enabled) {
-		adapter->rx_workqueue = alloc_workqueue("MWIFIEX_RX_WORK_QUEUE",
-							WQ_HIGHPRI |
-							WQ_MEM_RECLAIM |
-							WQ_UNBOUND, 1);
+		adapter->rx_workqueue =
+			alloc_ordered_workqueue("MWIFIEX_RX_WORK_QUEUE",
+						WQ_HIGHPRI | WQ_MEM_RECLAIM);
 		if (!adapter->rx_workqueue)
 			goto err_kmalloc;
 		INIT_WORK(&adapter->rx_work, mwifiex_rx_work_queue);
@@ -1701,18 +1700,17 @@ mwifiex_add_card(void *card, struct completion *fw_done,
 		adapter->rx_work_enabled = true;
 
 	adapter->workqueue =
-		alloc_workqueue("MWIFIEX_WORK_QUEUE",
-				WQ_HIGHPRI | WQ_MEM_RECLAIM | WQ_UNBOUND, 1);
+		alloc_ordered_workqueue("MWIFIEX_WORK_QUEUE",
+					WQ_HIGHPRI | WQ_MEM_RECLAIM);
 	if (!adapter->workqueue)
 		goto err_kmalloc;
 
 	INIT_WORK(&adapter->main_work, mwifiex_main_work_queue);
 
 	if (adapter->rx_work_enabled) {
-		adapter->rx_workqueue = alloc_workqueue("MWIFIEX_RX_WORK_QUEUE",
-							WQ_HIGHPRI |
-							WQ_MEM_RECLAIM |
-							WQ_UNBOUND, 1);
+		adapter->rx_workqueue =
+			alloc_ordered_workqueue("MWIFIEX_RX_WORK_QUEUE",
+						WQ_HIGHPRI | WQ_MEM_RECLAIM);
 		if (!adapter->rx_workqueue)
 			goto err_kmalloc;
 
-- 
2.40.0

