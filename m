Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 801A83281E1
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 16:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236936AbhCAPLA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 10:11:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236943AbhCAPKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 10:10:33 -0500
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 715D6C06178A
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 07:09:53 -0800 (PST)
Received: by mail-vs1-xe34.google.com with SMTP id l192so8782603vsd.5
        for <netdev@vger.kernel.org>; Mon, 01 Mar 2021 07:09:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JYUshVdIGpfkx3r8XsmqIrACh8j5JhOEEsMDIbj1ZNM=;
        b=nK2aj378rHybaUwUYrcASOBEi1Y+2U8yi/4VPcTrT+1iHfIpcN1Ht+x8RT1Ir89/DY
         A5uuYcwYeygg/RlzIkvx7lEpiVMpIa2x39PtQw6lVJqToGS9mlDEyaIMfWjMJhAmnVfG
         tmDGK8kI6MYEsNGBnHOXQGucZHSLV/PGi0MZlKqXHUyGHMcuVLN4XbK78ri0jCXljxC0
         /Hf8squWSctk72FyiQm/CnIIudBXdPFvhA2ZsxbOV9ldj8viMWM9iAG0rT1Ci0a9e5zo
         JzVIdIr4gRIU61gi9F/2lXq1NQOWIjlazdUjVPxhf+OuDmb2x3g8JGOivV/x8h5JSO3t
         HhEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JYUshVdIGpfkx3r8XsmqIrACh8j5JhOEEsMDIbj1ZNM=;
        b=QP6LNc8xycQN6QeveIU7a7Z2BJWJSSh75qUoSg2owBzJj83HtVB83E1dqNPb27GlYc
         eC6yMDHw8tqfIJF6vqwmS+ZWf1JY6K+lRPrDDDTbVg0Z5KQv0Mv41EJd06EMwzW+qbHO
         nJmVrmV337lkfbKyijMvm5S2TUrLcnrlA4zXHOT0tlf/QeMO0onq4Pegz0syo9ytrx77
         tml9yC4ZlX+OPH6rpx2kM87Zng6KQUo95pxRll+E2JO+f4qVOwvuzxF0RTwn8eq2MTEX
         HdQ2KmEyT2LUmSzRjSeI9MZPmmChc6ilgSRxR7NUE2MvdDP0PGQuzSQ9Dl98yzqM7/uT
         FHQw==
X-Gm-Message-State: AOAM530KrrsR3KLvlDUEGt7wgKk3QgrUPKzTpUJ2Kw62LT03UXfWrTgz
        DQE+T08rFPgn5uAt0prVsGXFtBLtpbM=
X-Google-Smtp-Source: ABdhPJwKNKEvqdmHKeRUlSwGMNZrhKNwQwU3nqLuYovqaN08/XlYFsVrtOtRrVHjV0mciCY8dCzu6Q==
X-Received: by 2002:a67:808a:: with SMTP id b132mr8554566vsd.8.1614611392194;
        Mon, 01 Mar 2021 07:09:52 -0800 (PST)
Received: from willemb2.c.googlers.com.com (162.116.74.34.bc.googleusercontent.com. [34.74.116.162])
        by smtp.gmail.com with ESMTPSA id r5sm2339808vkf.43.2021.03.01.07.09.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 07:09:51 -0800 (PST)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Willem de Bruijn <willemb@google.com>,
        Kris Karas <bugs-a17@moonlit-rail.com>
Subject: [PATCH net] net: expand textsearch ts_state to fit skb_seq_state
Date:   Mon,  1 Mar 2021 15:09:44 +0000
Message-Id: <20210301150944.138500-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

The referenced commit expands the skb_seq_state used by
skb_find_text with a 4B frag_off field, growing it to 48B.

This exceeds container ts_state->cb, causing a stack corruption:

[   73.238353] Kernel panic - not syncing: stack-protector: Kernel stack
is corrupted in: skb_find_text+0xc5/0xd0
[   73.247384] CPU: 1 PID: 376 Comm: nping Not tainted 5.11.0+ #4
[   73.252613] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 1.14.0-2 04/01/2014
[   73.260078] Call Trace:
[   73.264677]  dump_stack+0x57/0x6a
[   73.267866]  panic+0xf6/0x2b7
[   73.270578]  ? skb_find_text+0xc5/0xd0
[   73.273964]  __stack_chk_fail+0x10/0x10
[   73.277491]  skb_find_text+0xc5/0xd0
[   73.280727]  string_mt+0x1f/0x30
[   73.283639]  ipt_do_table+0x214/0x410

The struct is passed between skb_find_text and its callbacks
skb_prepare_seq_read, skb_seq_read and skb_abort_seq read through
the textsearch interface using TS_SKB_CB.

I assumed that this mapped to skb->cb like other .._SKB_CB wrappers.
skb->cb is 48B. But it maps to ts_state->cb, which is only 40B.

skb->cb was increased from 40B to 48B after ts_state was introduced,
in commit 3e3850e989c5 ("[NETFILTER]: Fix xfrm lookup in
ip_route_me_harder/ip6_route_me_harder").

Increase ts_state.cb[] to 48 to fit the struct.

Also add a BUILD_BUG_ON to avoid a repeat.

The alternative is to directly add a dependency from textsearch onto
linux/skbuff.h, but I think the intent is textsearch to have no such
dependencies on its callers.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=211911
Fixes: 97550f6fa592 ("net: compound page support in skb_seq_read")
Reported-by: Kris Karas <bugs-a17@moonlit-rail.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 include/linux/textsearch.h | 2 +-
 net/core/skbuff.c          | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/textsearch.h b/include/linux/textsearch.h
index 13770cfe33ad..6673e4d4ac2e 100644
--- a/include/linux/textsearch.h
+++ b/include/linux/textsearch.h
@@ -23,7 +23,7 @@ struct ts_config;
 struct ts_state
 {
 	unsigned int		offset;
-	char			cb[40];
+	char			cb[48];
 };
 
 /**
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 545a472273a5..c421c8f80925 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3659,6 +3659,8 @@ unsigned int skb_find_text(struct sk_buff *skb, unsigned int from,
 	struct ts_state state;
 	unsigned int ret;
 
+	BUILD_BUG_ON(sizeof(struct skb_seq_state) > sizeof(state.cb));
+
 	config->get_next_block = skb_ts_get_next_block;
 	config->finish = skb_ts_finish;
 
-- 
2.30.1.766.gb4fecdf3b7-goog

