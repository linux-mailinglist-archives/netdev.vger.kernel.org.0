Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 125B82A3D2E
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 08:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727737AbgKCHKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 02:10:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbgKCHKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 02:10:20 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5184CC0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 23:10:19 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id c20so13384227pfr.8
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 23:10:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8OpCxwSm3PgNpymlgJjYXIblVA6rebCtOQW9fc/WZ8o=;
        b=ISRT7LKHDau0TRwmMO4TaC7doQQvZFIYhV6k5dbUcAXu0QAeNNdvBY7F8v1EKXRwYB
         InRFB+Aaie+bmDjm5wHeHs3yfvYVlt8IepwHuBGdU1pBo8iU0wjXsWH4sLlDTvmH/erE
         2w4wsFDQQtLCGUlNOltkp5sWc5XIKKVlSjG+kQlu/3sFtECRcKYNPA3gZDtun5Ka+U37
         SktZ5bRz0F7sZPcjySQ14ZEsVCAOohtIU1oZ7cPvgtCtxYFSsdYJc3YH+xotMImRWcnr
         n7Hc5gcdkn+0as3EsktCMBDuexm42/f6vR8dlPtnVLWMi1z0e+/mEemldVKZZ3nVD2j0
         qIJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8OpCxwSm3PgNpymlgJjYXIblVA6rebCtOQW9fc/WZ8o=;
        b=K1AHDSiO+gyN6fywZ+G1i+1q3Bq2p5/txbcAMZ6PLgydWZ2+dR2A0/Aw/9uc7+vCtJ
         Psa/kZFWiHg5QXE61zQONx3EP9ikNTQwRUE8fSr8ixxGbAljPN+8csjC3j5cSAEvrLPN
         Fqil8DbMhkwiblZYiwc9NRwphYM67TYhKzjgX/pbmlrPAUMDFX4ctKiq5TbsRNMQcq0y
         Ub2804YJd1jWQOXaIVXMsedApwqbjpMku30AzLCqyq82ehfUgcU0U0jL2Lljfb3+bMth
         ADqwE88xyMEC7RWVbWg1G312NhrlWIDrXmGcO4JQgWTgnkf+wHta0Qzf3ts4FBt7YpeO
         GTsA==
X-Gm-Message-State: AOAM533w8Q7BdBmM6sTrOCf6ToYQylPjjWFoGIYEa+j7mz8qVDsBMrte
        8CKjrmt9G+y09vK3iBylewk=
X-Google-Smtp-Source: ABdhPJwVa6U6wEW6zm+lAs5GsU3YHvRtxcFClIwhJkgNUR6CF6BgE9hm3kGjhWrsj9CQh739sg0rHQ==
X-Received: by 2002:a17:90a:af82:: with SMTP id w2mr2391571pjq.77.1604387418975;
        Mon, 02 Nov 2020 23:10:18 -0800 (PST)
Received: from localhost.localdomain ([49.207.216.192])
        by smtp.gmail.com with ESMTPSA id 92sm2020074pjv.32.2020.11.02.23.10.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 23:10:18 -0800 (PST)
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
Subject: [net-next V3 2/8] net: ipv4: convert tasklets to use new tasklet_setup() API
Date:   Tue,  3 Nov 2020 12:39:41 +0530
Message-Id: <20201103070947.577831-3-allen.lkml@gmail.com>
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

