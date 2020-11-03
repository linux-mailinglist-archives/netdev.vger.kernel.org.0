Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6463B2A3FD5
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 10:19:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727630AbgKCJTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 04:19:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727068AbgKCJTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 04:19:02 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C096C0613D1
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 01:19:02 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id 13so13653250pfy.4
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 01:19:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nMNRjNylHskhmguTYIM2g5ir+w4s7Zf1QuwlIAsmLt4=;
        b=oFlEmYGlvL24rsIjgrI5dUafiVVZlIpy6u2aRq0b0pA1qppdgu4T/jXzheIaze9jJc
         0ufmKXqVxoYr7Mu8Bz7iSqVimy6bZBw8jM/wcNo3s+f2+FYp76P4nxqorAUbT7wi6mWP
         B+I/C19FNRCtBz7FBOBvB9X68uUA+2NhAnIyHx9y58UHoQPxBph5IexY4TlT3SOurSeG
         Gh817beda6F+/cP+HY91UfzQBGmyKRO6E1OmZn2TJfIG1bNLS7yqJT2pqYnxCHxQNUwG
         CPr1hXxmPmG+YNrtS484T3q0YOTwoKcIHXdPfpNWDgFveRgDP/Xe40jKcrjzyERAplEO
         JMJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nMNRjNylHskhmguTYIM2g5ir+w4s7Zf1QuwlIAsmLt4=;
        b=GinOl0ZKqxk517Vwy6K2kWnjVaFdKTPD6xOg2KL60kIb60Qta8D/NmiO10vA0/APU8
         u6xozX71d+tRN+e3Jv6icrvTn7LcYu026dtC/Hi3XYxV5yjEgzYd/DXaYeDtS6zQUxMx
         vCRf3RhdMvwL22t84smFhv5PKyY3p/86HyxH5kPfMSEUNxtxjPz6H7KS5rqU2D0ZOUgK
         0U6AhZD7CFVdIBnXxctbhlqdr4pXCCaReslvQZYNzRJa9oO9o12V5GusbH2DBwpdpwT9
         uFTnQ7KBDbrYnVgp5LT+lIhIatqXgDcKMWph3ubwuNE44lZE7oh7S2ELECnAbD5GW3A0
         HTPw==
X-Gm-Message-State: AOAM532UcNFIAVaF9q4Ovv8IdLxcx+cAlPsLbgqO3AyKn8PRJb8bqJnj
        wTm11w1NoYiAFKKsNWx4usU=
X-Google-Smtp-Source: ABdhPJzPq+my/nctZ053QeS4R19JnND1UU+KBwFBKfnSdJDSx03YV+olo5JCvPniHUxuNvkF455S0Q==
X-Received: by 2002:a63:f84c:: with SMTP id v12mr16566822pgj.125.1604395142204;
        Tue, 03 Nov 2020 01:19:02 -0800 (PST)
Received: from localhost.localdomain ([49.207.216.192])
        by smtp.gmail.com with ESMTPSA id f204sm17178063pfa.189.2020.11.03.01.18.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 01:19:01 -0800 (PST)
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
Subject: [net-next v4 4/8] net: mac802154: convert tasklets to use new tasklet_setup() API
Date:   Tue,  3 Nov 2020 14:48:19 +0530
Message-Id: <20201103091823.586717-5-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201103091823.586717-1-allen.lkml@gmail.com>
References: <20201103091823.586717-1-allen.lkml@gmail.com>
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

