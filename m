Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE662A3FD9
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 10:19:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727789AbgKCJT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 04:19:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726734AbgKCJT2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 04:19:28 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F2E9C0613D1
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 01:19:28 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id i7so11267008pgh.6
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 01:19:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JApShhfCvmLPl+HZpc9d9E6Zu3XN4DCqO1cBwrgabIk=;
        b=fLG/nK4XKMQQPerHv3ZwDKzwo83lQfZ2M2ch6ojyzq/QCXQfmoZ+1TFQpzvmfOFYOL
         970I0oLCkBtLdRrFP1ncsXzQxCWZpsYkKl31CLusiSxcvxNoMj7JNC7iK8pjg/JhJuvk
         GWiCmYlgUvlJOyC4v6YF+HeI/kelGQ4NBbMt1uhGtLjNuR7HxC3mEzMDG1/U3G/WiHxU
         1g+qxPBH2jNS/b7Q1oomk2Z82rSsfXkOa7ZfLRckD8bRCgOMxsF1d8VlBv1wqOLVjjzr
         Ay7w+2+5i8cJJ8Sfu7T4P1z5tn0rjrowXu2odNvn0gXHoXlEkqgqOfBKW87xx2QnwNiK
         ghMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JApShhfCvmLPl+HZpc9d9E6Zu3XN4DCqO1cBwrgabIk=;
        b=alRzZ/6um+W5P+QnS/UMTHq/YLhKAAou1mtdI2InIxRPZ+HRDy48tgIddfR0KglGwT
         AeLuNTdj1iEfXMWICMwPcINcQLI92NPxSmGtHtjMZKjVv+y1W9aYBee8hRaWk/2KRmbF
         jdVg9W/WHcKpJ9JHqmjuzbT2S0B08uuz9J3v4+slp26ItdlhC+yBEHgDBXunuwYLjwcS
         H5N80M2LSF9Vk7Ao2laxj1Fr5ldbzOa0kVEGemQeIMHVtVlapQC936xgsfU93ehO/gEH
         ZUAi1slKM14/kkBs6+50ws0SLc+/sst+3yI+D/RV3//qdN7yJjwsGULwYCXkqpA8Nixf
         pvPg==
X-Gm-Message-State: AOAM532fn9SdQVbyMYeEjvUIC54gu4tKy+6TQjMD6bwtMZxUEGnyRvo9
        K8eAGFYU8SvVY2Irr9VqHzc=
X-Google-Smtp-Source: ABdhPJyFL6NvRrNJE5SNjsKYo99q2br2Brc2miLaO0vZVrv9N6dcbeDt3YKPtIUoXk7Vq1LWwTQ/6g==
X-Received: by 2002:a17:90a:f0c7:: with SMTP id fa7mr2900184pjb.3.1604395168043;
        Tue, 03 Nov 2020 01:19:28 -0800 (PST)
Received: from localhost.localdomain ([49.207.216.192])
        by smtp.gmail.com with ESMTPSA id f204sm17178063pfa.189.2020.11.03.01.19.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 01:19:27 -0800 (PST)
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
Subject: [net-next v4 8/8] net: xfrm: convert tasklets to use new tasklet_setup() API
Date:   Tue,  3 Nov 2020 14:48:23 +0530
Message-Id: <20201103091823.586717-9-allen.lkml@gmail.com>
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
 net/xfrm/xfrm_input.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index 37456d022cfa..be6351e3f3cd 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -760,9 +760,9 @@ int xfrm_input_resume(struct sk_buff *skb, int nexthdr)
 }
 EXPORT_SYMBOL(xfrm_input_resume);
 
-static void xfrm_trans_reinject(unsigned long data)
+static void xfrm_trans_reinject(struct tasklet_struct *t)
 {
-	struct xfrm_trans_tasklet *trans = (void *)data;
+	struct xfrm_trans_tasklet *trans = from_tasklet(trans, t, tasklet);
 	struct sk_buff_head queue;
 	struct sk_buff *skb;
 
@@ -818,7 +818,6 @@ void __init xfrm_input_init(void)
 
 		trans = &per_cpu(xfrm_trans_tasklet, i);
 		__skb_queue_head_init(&trans->queue);
-		tasklet_init(&trans->tasklet, xfrm_trans_reinject,
-			     (unsigned long)trans);
+		tasklet_setup(&trans->tasklet, xfrm_trans_reinject);
 	}
 }
-- 
2.25.1

