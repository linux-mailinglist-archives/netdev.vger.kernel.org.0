Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 205D545526F
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 02:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241219AbhKRCAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 21:00:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233128AbhKRCAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 21:00:31 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C38CBC061570
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 17:57:32 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id s138so3883020pgs.4
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 17:57:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0gsA4Q+OPSpoP/q7gMfkEufnSK+DRnwBwLG7Y8j79Nk=;
        b=IjfpVeypwDxp5FoFUAIdDaWw0N9UpcejYl/6TUnxWd/6DvZ2/xOMOReb8bBr2sb5ZT
         e8d0235rlMITmgvc0ip+ubpgrU/EbPvA+WIKepXIXBNqf5UbEgsToHpIWS9lMUMLUW/e
         Xh2MIoxZKO+K8vAjsiQSeyRk6Vv7a63nDt9SCh3lj+MoLgAHPKSHHFqaZldq1vQnuUnu
         JRKMrKA7PB/P37qeNHGkhFIhrgA7dhxycAm+OTBr9PvguIhdl3wadmZ1n1yyIU0ZsN0Q
         CIqYCWWjj1odbozoCFuzT1yDbjrGD9RA4HzSLxoZnpJBgO7R5zW8ze4tdkjIC60nKZ6S
         ySCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0gsA4Q+OPSpoP/q7gMfkEufnSK+DRnwBwLG7Y8j79Nk=;
        b=V2o727Vlhv7g1AUqcy4w7O3vVgyJICSDvIJ5GcmEHf/pB+QAnwgvXMixhmtxe4Mgp4
         5H24u0u3cWl6w9DocjVBb1/7Ha8CdvoksBzqg/R3pTd9MhYh2Xp8Y6tyb4i3kyXBoIZO
         8l0fpP7qRVyfIoTOVuPxHC45YFJBQPA0wQi8gt6nVTluZ1rFdBgI43QyREo0Sx7ypq3U
         /lmuz7kDR7eQkPYLQa3MjAAJRNhQdeYct3O6XAa24Px+0nGRFIjc0ZcdpUniDHUaVIbP
         2dQpQy6P/D/uEtUwk6aUD6fMERE+q7qG5t0WcsbQLkF9D1ANX1VCSwm5puD9U14ZZ0KP
         pfGw==
X-Gm-Message-State: AOAM530RaHOevl1WqdNH4TtasIt9D3AJzvRCl1IlJi/mSKhOP9wZm9Ro
        bGhm7zOfAmctIt4G3zrfjcw=
X-Google-Smtp-Source: ABdhPJxMb9f0ME5jbdRT+Md6L3d47cpNB986iFMpAAzP5CZeF/5y9KjpzlFGZWcSVmJryzrHrL3f7Q==
X-Received: by 2002:a05:6a00:a8e:b0:47b:a658:7f4d with SMTP id b14-20020a056a000a8e00b0047ba6587f4dmr52221197pfl.82.1637200652408;
        Wed, 17 Nov 2021 17:57:32 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:db6:6273:9e40:bea5])
        by smtp.gmail.com with ESMTPSA id i33sm744083pgi.71.2021.11.17.17.57.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 17:57:31 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH net-next] tcp: add missing htmldocs for skb->ll_node and sk->defer_list
Date:   Wed, 17 Nov 2021 17:57:29 -0800
Message-Id: <20211118015729.994115-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Add missing entries to fix these "make htmldocs" warnings.

./include/linux/skbuff.h:953: warning: Function parameter or member 'll_node' not described in 'sk_buff'
./include/net/sock.h:540: warning: Function parameter or member 'defer_list' not described in 'sock'

Fixes: f35f821935d8 ("tcp: defer skb freeing after socket lock is released")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/linux/skbuff.h | 1 +
 include/net/sock.h     | 1 +
 2 files changed, 2 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index b8b806512e1615fad2bc9935baba3fff14996012..100fd604fbc9a32180a6f43626249d19bf415c4f 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -627,6 +627,7 @@ typedef unsigned char *sk_buff_data_t;
  *		for retransmit timer
  *	@rbnode: RB tree node, alternative to next/prev for netem/tcp
  *	@list: queue head
+ *	@ll_node: anchor in an llist (eg socket defer_list)
  *	@sk: Socket we are owned by
  *	@ip_defrag_offset: (aka @sk) alternate use of @sk, used in
  *		fragmentation management
diff --git a/include/net/sock.h b/include/net/sock.h
index f09c0c4736c46a18b820949ba3c8ea4e7c6fee57..a79fc772324e5da7b9f489de2e06698695d3e7d7 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -292,6 +292,7 @@ struct bpf_local_storage;
   *	@sk_pacing_shift: scaling factor for TCP Small Queues
   *	@sk_lingertime: %SO_LINGER l_linger setting
   *	@sk_backlog: always used with the per-socket spinlock held
+  *	@defer_list: head of llist storing skbs to be freed
   *	@sk_callback_lock: used with the callbacks in the end of this struct
   *	@sk_error_queue: rarely used
   *	@sk_prot_creator: sk_prot of original sock creator (see ipv6_setsockopt,
-- 
2.34.0.rc1.387.gb447b232ab-goog

