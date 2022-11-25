Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30A54638F4A
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 18:46:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbiKYRqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 12:46:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbiKYRqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 12:46:48 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A342854775
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 09:46:46 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id z6so2913053qtv.5
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 09:46:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/0RT1UDB+rgQuo3hDD+sJfqCPq7Bq2PrPiWHxsUI7y4=;
        b=nrOjTkdMJy0wE9hFRFfnykbcMYiYgVdW7p46tkcwkh+gg3L7cCD9/fUHVO9iULzS6r
         eOcC0DrhOS467QOI3SI4vsK/kn6bokFVFomQNfDSFgqUUxJ3e7YM0D91bC067ZnRudak
         QrmhJMXbJYyJS8D4z8fTsW/3ruFU1Mt/+aKs5ON0EH4Kh7nzjrnNLpiJIS+r0XX+nX7H
         QesTkUtqKTB3zlGzP05U7fVlLWQKJ9l3a8P6N6N8FOID7tygNJKRLZbneuVu577VfKcU
         Egyc87XiW4TlEAtmi+ew5jcGOTaHyraiCspcMuSc4CUAYuo9BxEXaCc52LEPS/v4u1pV
         TcyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/0RT1UDB+rgQuo3hDD+sJfqCPq7Bq2PrPiWHxsUI7y4=;
        b=i9HP/5//TFhGo/2FYm72RECMpir6jROfWajTIUItUtn1w39NEH+r5iuwfCHmhen8oN
         Uf5EOOzE1tiU5U8MawYzp/FAM3xnPeNDw/hAsKPetWufTCtqTIDJmu1bMt3I6y1nqkZT
         vdUUQ8LCndOZtSp7oWdVc3jGMDzOm7R8B0LfKmU+KI0AQ6wX4xnUsEEnRJIvk3kC7uOL
         SqnGL8RM4oYbkgRYoamp6O6/s8iQOZfoTV/4Dl9LcS5nKoztcmYaam97pjRJbpwR5c9s
         glIDW6AsgqPk5X4s/bVp/cQdo9rv+uSmQGIrx+IiwerGxnxKi/fTkM/ymqBmu79uMd6k
         bxxA==
X-Gm-Message-State: ANoB5plj6BrB6Qd7jOxMcfMisPZeXhaIF9LdVsOO7YWP1aQ/oj9HzcSD
        FTcVgOaiJ4vt4Z9s+mU/6rCZTXibHMdKZg==
X-Google-Smtp-Source: AA0mqf6WvpMmG6oaHXAtotWJGzFacckzwsPlrUVXrInoTQWP1OAj8J3h364toGXpNAi8pp/g0nCsgA==
X-Received: by 2002:ac8:1019:0:b0:3a5:42b9:d7aa with SMTP id z25-20020ac81019000000b003a542b9d7aamr36057618qti.58.1669398405405;
        Fri, 25 Nov 2022 09:46:45 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id w21-20020a05620a0e9500b006faa88ba2b5sm3064121qkm.7.2022.11.25.09.46.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Nov 2022 09:46:44 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>,
        tipc-discussion@lists.sourceforge.net
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        Shuang Li <shuali@redhat.com>
Subject: [PATCH net] tipc: re-fetch skb cb after tipc_msg_validate
Date:   Fri, 25 Nov 2022 12:46:43 -0500
Message-Id: <1b1cdba762915325bd8ef9a98d0276eb673df2a5.1669398403.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As the call trace shows, the original skb was freed in tipc_msg_validate(),
and dereferencing the old skb cb would cause an use-after-free crash.

  BUG: KASAN: use-after-free in tipc_crypto_rcv_complete+0x1835/0x2240 [tipc]
  Call Trace:
   <IRQ>
   tipc_crypto_rcv_complete+0x1835/0x2240 [tipc]
   tipc_crypto_rcv+0xd32/0x1ec0 [tipc]
   tipc_rcv+0x744/0x1150 [tipc]
  ...
  Allocated by task 47078:
   kmem_cache_alloc_node+0x158/0x4d0
   __alloc_skb+0x1c1/0x270
   tipc_buf_acquire+0x1e/0xe0 [tipc]
   tipc_msg_create+0x33/0x1c0 [tipc]
   tipc_link_build_proto_msg+0x38a/0x2100 [tipc]
   tipc_link_timeout+0x8b8/0xef0 [tipc]
   tipc_node_timeout+0x2a1/0x960 [tipc]
   call_timer_fn+0x2d/0x1c0
  ...
  Freed by task 47078:
   tipc_msg_validate+0x7b/0x440 [tipc]
   tipc_crypto_rcv_complete+0x4b5/0x2240 [tipc]
   tipc_crypto_rcv+0xd32/0x1ec0 [tipc]
   tipc_rcv+0x744/0x1150 [tipc]

This patch fixes it by re-fetching the skb cb from the new allocated skb
after calling tipc_msg_validate().

Fixes: fc1b6d6de220 ("tipc: introduce TIPC encryption & authentication")
Reported-by: Shuang Li <shuali@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/tipc/crypto.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
index f09316a9035f..d67440de011e 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -1971,6 +1971,9 @@ static void tipc_crypto_rcv_complete(struct net *net, struct tipc_aead *aead,
 	/* Ok, everything's fine, try to synch own keys according to peers' */
 	tipc_crypto_key_synch(rx, *skb);
 
+	/* Re-fetch skb cb as skb might be changed in tipc_msg_validate */
+	skb_cb = TIPC_SKB_CB(*skb);
+
 	/* Mark skb decrypted */
 	skb_cb->decrypted = 1;
 
-- 
2.31.1

