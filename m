Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F10E1284612
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 08:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbgJFGcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 02:32:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbgJFGcj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 02:32:39 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83D3FC0613A7
        for <netdev@vger.kernel.org>; Mon,  5 Oct 2020 23:32:39 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id i3so1124384pjz.4
        for <netdev@vger.kernel.org>; Mon, 05 Oct 2020 23:32:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dSBvkQ431tgtAVSNo2oauDu6/vBwSLhYF4EkUxJ0he4=;
        b=aMAV0F67n3Olnqm1INlSqKjivWnxEZrUufowPMTupPGs1lRPaipUz/o8DDnkl/3sbX
         JditUKb9egn8DrdAoUv7rKSH6pYrc9cK2Lo89FXuEdnDihdch2QfF5Rsgj2Y+YJlVeDl
         YgaBN7v4/TPgcA3Qfh1d1QWBudog+ZqpmyVX4IQaF0KFrCDF/JqUGK9pPOxLVNd0D87m
         bQ2pyaJjdidJK4Z604871T6KEFi92v8is9NPhwKj14ljBnuBMQ9JBPs36JikCGme9cSn
         1yjsR/24iJpu5U2UFGZp12Nu9ekTX5mlPWv+ZDgh4hE8Rm0rlZahnmSLRKSozASGQemm
         g+EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dSBvkQ431tgtAVSNo2oauDu6/vBwSLhYF4EkUxJ0he4=;
        b=muH9y2G1664sMJj1m5jx66wrsyjkQ6AhyEqOn1vtiloVV9qTzVYTJdMNWghLOzQLND
         QBmz5Fm9IWrob8G61/e2U/jzJJh14jv2JrWXRUNAjw4BEyrcu6y1vDx2xp6AkjvtXkKj
         3ZR18VJ1go1AAq8SYbz/eK3LHo7/H38STK+5HxMMuLaSNJlhcU+r6ZeKfGToU8rbiD85
         24D8+K6JVqJmAp6kvD03cetXGS2trznj2IqYVDb7vLazZ//GZkVryd8Fq1sTuYWQv4/5
         odQNMJnVTgNHeAUrL0ugABVRx65S8LiXGKf8P3rYwkU+skBI/rHkFOZH7zeI5VPWDkxW
         iYpw==
X-Gm-Message-State: AOAM530g7nbUf+GT0CutJf9jx/9dyasHBde/ghjxN+T1fqb/RvorDC+h
        RJr6HeilNZHBfx6mh2onE2A=
X-Google-Smtp-Source: ABdhPJylSLs6FtK8IAY33LEnW83x9uCYBJhBPBHa4qkbi6qPBvBmFQB+ML7sDR9CBfpbErb/dvOaLw==
X-Received: by 2002:a17:90a:6985:: with SMTP id s5mr191837pjj.17.1601965959167;
        Mon, 05 Oct 2020 23:32:39 -0700 (PDT)
Received: from localhost.localdomain ([49.207.203.202])
        by smtp.gmail.com with ESMTPSA id 124sm2047361pfd.132.2020.10.05.23.32.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 23:32:38 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     gerrit@erg.abdn.ac.uk, kuba@kernel.org, edumazet@google.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        johannes@sipsolutions.net, alex.aring@gmail.com,
        stefan@datenfreihafen.org, santosh.shilimkar@oracle.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>,
        Allen Pais <apais@linux.microsoft.com>
Subject: [RESEND net-next 4/8] net: mac802154: convert tasklets to use new tasklet_setup() API
Date:   Tue,  6 Oct 2020 12:01:57 +0530
Message-Id: <20201006063201.294959-5-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201006063201.294959-1-allen.lkml@gmail.com>
References: <20201006063201.294959-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <apais@linux.microsoft.com>
---
 net/mac802154/main.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/mac802154/main.c b/net/mac802154/main.c
index 06ea0f8bf..520cedc59 100644
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

