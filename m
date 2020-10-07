Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48654285C9B
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 12:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727946AbgJGKMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 06:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727297AbgJGKMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 06:12:48 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F067BC061755
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 03:12:47 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id g29so1093347pgl.2
        for <netdev@vger.kernel.org>; Wed, 07 Oct 2020 03:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X7q08WJPRaUgkdBI6ZeZlBDNumfcd2QVr0PmpHExqCk=;
        b=BFA9QnF6jpkTX99GpicyN62oLT0R2hhveyUCW3leYcQjAX13zQTTNOgwG0shvYfDHk
         J1wWdBocVjyDqJPDWq6192owzS2VUEN2zunPPLL24cMzRGGFDSGCy3j/q10UkqU4tEE8
         AAHSTTLE+MfDh8RYMC+yKrqWm/sBc75uncSDgmccrrrrktl9uM+2aI4S8ve4F5jFlioJ
         lwyThCfRiPEdtHCGBEmDQZKSio3L2qiYcDyHRO0gEVMxrbm7v+Z9R/Y02TnZTU0wVwu1
         F//w+MEBE7mTGtBtyTM93/g9qzylFNJco+BpMMxSQsWc0VvuRQuEspUDCubl4zVWYTKc
         dnoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X7q08WJPRaUgkdBI6ZeZlBDNumfcd2QVr0PmpHExqCk=;
        b=rAK+267a1Rmaj/TnohEkv0i8QzwhdtOXRkthc/LvjULng/pw3SAoX5471ezyG+tGbL
         p6oSPB20Xj1+LOqH/ElRpnDMfwB6gwBew96rKtp6em+X2f1rYrjSJOw+oQ1sgZUEtkkm
         VT07Dvn+YYcUYUDRUV0cHhU1sH8F7wdXswibZI4QhWRf573L+ZnT1hG2eC6W/EmCNPdN
         0YDBPR91GAxcejbmuLgqL2HSCUd5c3SJpP1znUxesAtjwejpFKII5TzWdPQawt1KM+hv
         VGrD7UXiLXWW9npEwlPjOba1ezdh8dk61C4DyDgliit2K/UuHOYaUXW7wYBNfzH9TJqu
         wxFA==
X-Gm-Message-State: AOAM530/GmZO3E7tCjyNs37PX9IbC+m4ntjhCNtBJoXks1+tMi0UjLie
        9TGFcKF2IVR0Q5QCfgxIUpo=
X-Google-Smtp-Source: ABdhPJxDdJoZigi7hmNcKWivfWP6qRPYwJf+fz8i2s84XVIHy0iglls19j9ioXFEERxQXiGuk1+GmQ==
X-Received: by 2002:a62:1a95:0:b029:151:d47e:119b with SMTP id a143-20020a621a950000b0290151d47e119bmr2371754pfa.46.1602065567562;
        Wed, 07 Oct 2020 03:12:47 -0700 (PDT)
Received: from localhost.localdomain ([49.207.204.22])
        by smtp.gmail.com with ESMTPSA id q24sm1105291pgb.12.2020.10.07.03.12.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 03:12:47 -0700 (PDT)
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
Subject: [net-next v2 2/8] net: ipv4: convert tasklets to use new tasklet_setup() API
Date:   Wed,  7 Oct 2020 15:42:13 +0530
Message-Id: <20201007101219.356499-3-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201007101219.356499-1-allen.lkml@gmail.com>
References: <20201007101219.356499-1-allen.lkml@gmail.com>
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
index bf48cd73e..6e998d428 100644
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

