Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 259892A3FD3
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 10:18:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727479AbgKCJSu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 04:18:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727068AbgKCJSt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 04:18:49 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8227CC0613D1
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 01:18:49 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id j18so13674848pfa.0
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 01:18:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8OpCxwSm3PgNpymlgJjYXIblVA6rebCtOQW9fc/WZ8o=;
        b=DdLl75iXhMMb3xxzjiqOqaDZDZMqBd2npZKIR/JsJtKdQ3BkuPlwYKGw9vTL8jBFi/
         OeYQcR4jo69NRr1xAs/REGhdgz2xYEZEnqegMhyUju4kjAIjLfxBEonnC9Evwz1JKh9I
         dsgOLFPFm9hfwe+syfdkRfYBun00wXQOqVeXnpnGe+HQcxazVAO8N87UQ9skoo+zGdAE
         LZ6JBcUO7Fg4Gu/xiMNHssOrPBdw6DvYSZFI5NGkLtab3z7RB4RkeDzJ3O6Dw0ULMA1K
         +i8l66K/Drgm7wcttM/lCMaBcqdG70KKT/EoA2of10BxRMfP/gDl/m8DZh0JMJZaLa+H
         Zavg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8OpCxwSm3PgNpymlgJjYXIblVA6rebCtOQW9fc/WZ8o=;
        b=fm/GXaH4bwVPMCqX+FHZMzyaljrX4HHGqqgFb5I6aIke8i2eORDKLgNGAqH65g+12o
         5SoHqPohy1z6TQ4hLw7kQsAc3VLwgF7DoQdGkdZARt4vUDDLyBOx6ZXDz96noTiG5a8O
         qddWTVXEMrkMvfY1G8v8AXz0gm+S17squPwyoCXkfBPnEDAJwjTymR484nRpbdmdMcT2
         M8mFxmOxrrbNkTXJG9DNKe4zAcb+NUAz/AYVTZNWCrDKj4xhK0L+nqHFRj8pdhOvsvSR
         Cn83O0QrM2Y+IlPVa9VN7ioJylJRfqRZWf8DfyD9To5sK1Ss1ZosuG6EKzuq6puVgnBZ
         wNWw==
X-Gm-Message-State: AOAM533+EhKBhO2Cbi5a0PDnk77/ZMSEnclDVfbR157AMVeaR+4Q5Cid
        gGobzeV2gNGAZmJ9/oD9SxQ=
X-Google-Smtp-Source: ABdhPJxfoOdC+D5+BF4IetuAdWD+yHuaekB+CCmqEeGJ4mE9ax/2zAwnJ5JBWP0zHKhvAPVgpJ59bw==
X-Received: by 2002:a63:f551:: with SMTP id e17mr3598866pgk.170.1604395129126;
        Tue, 03 Nov 2020 01:18:49 -0800 (PST)
Received: from localhost.localdomain ([49.207.216.192])
        by smtp.gmail.com with ESMTPSA id f204sm17178063pfa.189.2020.11.03.01.18.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 01:18:48 -0800 (PST)
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
Subject: [net-next v4 2/8] net: ipv4: convert tasklets to use new tasklet_setup() API
Date:   Tue,  3 Nov 2020 14:48:17 +0530
Message-Id: <20201103091823.586717-3-allen.lkml@gmail.com>
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

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <apais@linux.microsoft.com>
---
 net/ipv4/tcp_output.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index bf48cd73e967..6e998d428ceb 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1038,9 +1038,9 @@ static void tcp_tsq_handler(struct sock *sk)
  * transferring tsq->head because tcp_wfree() might
  * interrupt us (non NAPI drivers)
  */
-static void tcp_tasklet_func(unsigned long data)
+static void tcp_tasklet_func(struct tasklet_struct *t)
 {
-	struct tsq_tasklet *tsq = (struct tsq_tasklet *)data;
+	struct tsq_tasklet *tsq = from_tasklet(tsq,  t, tasklet);
 	LIST_HEAD(list);
 	unsigned long flags;
 	struct list_head *q, *n;
@@ -1125,9 +1125,7 @@ void __init tcp_tasklet_init(void)
 		struct tsq_tasklet *tsq = &per_cpu(tsq_tasklet, i);
 
 		INIT_LIST_HEAD(&tsq->head);
-		tasklet_init(&tsq->tasklet,
-			     tcp_tasklet_func,
-			     (unsigned long)tsq);
+		tasklet_setup(&tsq->tasklet, tcp_tasklet_func);
 	}
 }
 
-- 
2.25.1

