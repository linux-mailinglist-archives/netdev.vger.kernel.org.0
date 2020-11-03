Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 831742A3D30
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 08:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727767AbgKCHKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 02:10:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbgKCHKc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 02:10:32 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0469C0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 23:10:32 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id 72so6692553pfv.7
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 23:10:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nMNRjNylHskhmguTYIM2g5ir+w4s7Zf1QuwlIAsmLt4=;
        b=t8GmQVvKb0xb6Iske+8cnXf9RM41eGwqv9A80koscras1jEKI+oegBPR+Ww2eBCmWe
         WzHccbBMXfbFG+xUmTX+M6sYCj7RlSa2YIij0ABHgD1w1P4sJA3UxStMWET7SDlbGNFk
         yDGcWfnqf0Q/OzAlnM9ok6rgtZGYAsXr8F1VdBiAl6NJUbnlgoyqVbvRWJE9auh+CmNL
         yFN9B+PkbsrCczUbInzThFNzOEZDaVLqNTiSvlkpBwj5DQcSh63NZVUOsNg3cEarFKJZ
         WkcHrnFM+xd2gDnMSSECM7UWRfvoQfzr5bbE24X5k4pL4XPv7MJJFLNunrTEdZqkv2wj
         QNuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nMNRjNylHskhmguTYIM2g5ir+w4s7Zf1QuwlIAsmLt4=;
        b=caZKul9as+Ws8jBIrDpj0tpZR25RVwH16A+7P3+udcsSlSWZ4qb1jD2RA30hSW1EO+
         kevw2gT32QWnvYymO0xjPERqU18H0P0AKxSTANI/xajq14miNvpvslczTM5LGv/h0LwE
         v9lfOF8u4u6hTqZU7zyFJuKhypfo83gRTMXQ6FVffv3pUxrMpBazDzeGtqmONYA6mbiK
         Zp5LBLbdxfirZYi0ARZwgeRaXK4yFUqKf9HzHpu7xscpQvm5RJnLYaoGsGFPhB5fMOVM
         oeGl2SYvUyjGLh/dQHli0nnyNNBm9CBY7jNm2YU06Vg7W3NieySmOplSKXrgvBxyt+KS
         z30g==
X-Gm-Message-State: AOAM533nZBg7QOsDDwaazz9ih/o8zwmk+u/VkE6Wm3TJzNvzYsc2SStf
        4mddtPqjyHDLelQd0p/Iobo=
X-Google-Smtp-Source: ABdhPJzAMOOqW+C5dtRBBfT2qgAz+3Um/46MEeFeMLHH35aPqlyYx97ZF2ac3z44shFY49XP3e5BWA==
X-Received: by 2002:a17:90a:fe07:: with SMTP id ck7mr273712pjb.212.1604387432405;
        Mon, 02 Nov 2020 23:10:32 -0800 (PST)
Received: from localhost.localdomain ([49.207.216.192])
        by smtp.gmail.com with ESMTPSA id 92sm2020074pjv.32.2020.11.02.23.10.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 23:10:31 -0800 (PST)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     gerrit@erg.abdn.ac.uk, kuba@kernel.org, edumazet@google.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        johannes@sipsolutions.net, alex.aring@gmail.com,
        stefan@datenfreihafen.org, santosh.shilimkar@oracle.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [net-next V3 4/8] net: mac802154: convert tasklets to use new tasklet_setup() API
Date:   Tue,  3 Nov 2020 12:39:43 +0530
Message-Id: <20201103070947.577831-5-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201103070947.577831-1-allen.lkml@gmail.com>
References: <20201103070947.577831-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <apais@linux.microsoft.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Acked-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <apais@linux.microsoft.com>
---
 net/mac802154/main.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/mac802154/main.c b/net/mac802154/main.c
index 06ea0f8bfd5c..520cedc594e1 100644
--- a/net/mac802154/main.c
+++ b/net/mac802154/main.c
@@ -20,9 +20,9 @@
 #include "ieee802154_i.h"
 #include "cfg.h"
 
-static void ieee802154_tasklet_handler(unsigned long data)
+static void ieee802154_tasklet_handler(struct tasklet_struct *t)
 {
-	struct ieee802154_local *local = (struct ieee802154_local *)data;
+	struct ieee802154_local *local = from_tasklet(local, t, tasklet);
 	struct sk_buff *skb;
 
 	while ((skb = skb_dequeue(&local->skb_queue))) {
@@ -91,9 +91,7 @@ ieee802154_alloc_hw(size_t priv_data_len, const struct ieee802154_ops *ops)
 	INIT_LIST_HEAD(&local->interfaces);
 	mutex_init(&local->iflist_mtx);
 
-	tasklet_init(&local->tasklet,
-		     ieee802154_tasklet_handler,
-		     (unsigned long)local);
+	tasklet_setup(&local->tasklet, ieee802154_tasklet_handler);
 
 	skb_queue_head_init(&local->skb_queue);
 
-- 
2.25.1

