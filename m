Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC9D377442
	for <lists+netdev@lfdr.de>; Sun,  9 May 2021 00:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbhEHWKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 18:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbhEHWKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 18:10:15 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DE3FC061574;
        Sat,  8 May 2021 15:09:13 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id r13so6616920qvm.7;
        Sat, 08 May 2021 15:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7d/KU/DC62hu/FTJavom/LekEDnR80g4Tdja2rES75g=;
        b=s3NkkDJMhuw6Pvh66o/XcQB6W/rRnrwQ4HFpzl+nyj8x9ICEEayghHWVNu3Vumg9LL
         9f6qQSX2NzLyWR//OWRY2KywXzdspI/0PI9V7XJP2Ek8WEXV95PTTqim4uLHLastRl5K
         0wsmPrHCc4dWRf6eAbK3vWEkrRkuyGZyMNWAHAYbqFfonfwJhD4OX1tFm5/AdHHX1p2t
         QwnKccO/cCzV34SE/jWWp6EoCmNOsQ765zCP1Kg89Z2TIB1qrZIOrQ0tL5bgMW5wEo1W
         e34qLkjnwKnmrzme6zzKCBt+kUaQh/HPMf552V9nsqSb8yqItNOksp5GLpPc+n8/N+qo
         JRwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7d/KU/DC62hu/FTJavom/LekEDnR80g4Tdja2rES75g=;
        b=iAp/GGfvJUl3yfS/31bk2+GGPARU4UHPukhC61nHQTjsYpD49uqD/C5xdxgjdD5lbc
         0g471qfgyBQJ4N+gkoPAHvBsg3zA0cZmvSwFmwfepsBN4XaeVu03PO9Ed8+sCZmcUa9x
         N5SMDbGVrefVFd7xKCtcouVfg50K//y+q4eUUqA3d1OGNA6Qivuj3RfTHwHG/Ru/mC+r
         JPKiCrpydLhgERjoB/KpzfcK28ny0Da3FPjNhmqCBeckmTXkEQ4Q9expXnGFI7SRGNTc
         CNnguWGUHatsyxS5tC2rLWjOzWY7c38eoTkXZ71gnxwlcOE9TXNXdWo8tKKwkDVAi5os
         eVDg==
X-Gm-Message-State: AOAM532p7iDRKhUM+qIPwOz9lTz1nWr6tJByw0AR+VKrMk1OK26ksEcU
        k39Dl1AiZpg3c6u1afxDNiBFyJ+aCzBtBA==
X-Google-Smtp-Source: ABdhPJycm4RJ5dkrx/0QkwSdG9YzBCTFtY43LS3uk5Q1rzA+aJ1Wq794g25vqNApBlnMasOxCJVhrg==
X-Received: by 2002:a0c:ec0f:: with SMTP id y15mr16335250qvo.9.1620511752122;
        Sat, 08 May 2021 15:09:12 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:65fe:be14:6eed:46f])
        by smtp.gmail.com with ESMTPSA id 189sm8080797qkd.51.2021.05.08.15.09.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 May 2021 15:09:11 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, jiang.wang@bytedance.com,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v4 04/12] sock_map: export symbols for af_unix module
Date:   Sat,  8 May 2021 15:08:27 -0700
Message-Id: <20210508220835.53801-5-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210508220835.53801-1-xiyou.wangcong@gmail.com>
References: <20210508220835.53801-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Before af_unix there is no need to support modules. Now
we have to export these two functions for af_unix module.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/core/sock_map.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 6f1b82b8ad49..13b474d89f93 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -1513,6 +1513,7 @@ void sock_map_unhash(struct sock *sk)
 	rcu_read_unlock();
 	saved_unhash(sk);
 }
+EXPORT_SYMBOL_GPL(sock_map_unhash);
 
 void sock_map_close(struct sock *sk, long timeout)
 {
@@ -1536,6 +1537,7 @@ void sock_map_close(struct sock *sk, long timeout)
 	release_sock(sk);
 	saved_close(sk, timeout);
 }
+EXPORT_SYMBOL_GPL(sock_map_close);
 
 static int sock_map_iter_attach_target(struct bpf_prog *prog,
 				       union bpf_iter_link_info *linfo,
-- 
2.25.1

