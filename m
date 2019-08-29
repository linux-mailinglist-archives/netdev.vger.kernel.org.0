Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE4B9A1C42
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 16:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbfH2OC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 10:02:57 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:38735 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727285AbfH2OC4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 10:02:56 -0400
Received: by mail-qk1-f195.google.com with SMTP id u190so3023418qkh.5
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 07:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hSASmgqt3XWJvTzIc6IftE27Ja/JvPk3A0Np4u/v5OU=;
        b=AV/lc/mPkQvpror0yZ2aKOVmfabB7eWHpANqfuHNlIi+D1cDN4wLieZe0PXfOz8iYq
         PjjnbHcL5LF45GOKQ1ouEo0lwOPXrFcfx4aHjwv6fCfh3bv5rIF8x/3NMd+Y8etN2ox4
         GbzkXwfVficdlLFOQIv7eFGTq5I01uPFFhk3N24wjzF1OYvuVitbanfgpqjQOrz5olix
         msQPFaZB6PhwDbUASy+BqBjG2zEfz7Iyif7KTu83p/URRMhGJGVh7x06pBvA+eaEUgXi
         aCAE3SQ3nFdfOxhbRoFFFaLbnP9+CSq3VDBvw0zenAH5AfC+qgcZDMzHv9OOtDfNW4gI
         Bm3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hSASmgqt3XWJvTzIc6IftE27Ja/JvPk3A0Np4u/v5OU=;
        b=OFXmoGAS65tFxmRUe0L2OCTGZLGCs3UDx/251m234rHCnJTvh+UZzzzAa0jgRFXrVH
         cruTEaZ5002xsrzT64h7z/6Ff1j59NhJo7U8sawxmEwJsl1OBjDunj7nv053AhuihxQX
         KvQ2pwipNzfXkzmf3gXb6l2MrtHoyA4jtC8dwMzYCVVcHA4+okoxUoI0IV+taB3U1UDj
         Rn4+XhBcJRWszYmpELIEObt4+EeM1eqGqiq8SOtGVQglcokzE+OJJrUFauWEnxY5SHu6
         d0FLHRe9aeQaYrnWDBtVaROkc8S4eVUZ8dyb+sZ+8yOcg3/3iDbPgieK3Stklvm1Ngy5
         xYEQ==
X-Gm-Message-State: APjAAAXBBtnsJ2wjKiXXk/xe3DLNvbFxlKOrcMJVHZtan4FBL0w9tXfl
        BjqPqhcD/mFcPaWHxDi7AYY=
X-Google-Smtp-Source: APXvYqy/iCNUQ1GSdEKAoUhxLkDKQq2VxBlPWQ005vJmavV8ESX3Zc8qpgBluaXer3B2U7p18gzU9A==
X-Received: by 2002:a37:7742:: with SMTP id s63mr8575189qkc.442.1567087374904;
        Thu, 29 Aug 2019 07:02:54 -0700 (PDT)
Received: from lukehsiao.nyc.corp.google.com ([2620:0:1003:312:8a63:c3f1:7411:4939])
        by smtp.gmail.com with ESMTPSA id j50sm1305097qtj.30.2019.08.29.07.02.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 07:02:53 -0700 (PDT)
From:   Luke Hsiao <luke.w.hsiao@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Luke Hsiao <lukehsiao@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Priyaranjan Jha <priyarjha@google.com>
Subject: [PATCH net-next] tcp_bbr: clarify that bbr_bdp() rounds up in comments
Date:   Thu, 29 Aug 2019 10:02:44 -0400
Message-Id: <20190829140244.195954-1-luke.w.hsiao@gmail.com>
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luke Hsiao <lukehsiao@google.com>

This explicitly clarifies that bbr_bdp() returns the rounded-up value of
the bandwidth-delay product and why in the comments.

Signed-off-by: Luke Hsiao <lukehsiao@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Acked-by: Priyaranjan Jha <priyarjha@google.com>
---
 net/ipv4/tcp_bbr.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_bbr.c b/net/ipv4/tcp_bbr.c
index 56be7d27f208..95b59540eee1 100644
--- a/net/ipv4/tcp_bbr.c
+++ b/net/ipv4/tcp_bbr.c
@@ -346,7 +346,7 @@ static void bbr_cwnd_event(struct sock *sk, enum tcp_ca_event event)
 
 /* Calculate bdp based on min RTT and the estimated bottleneck bandwidth:
  *
- * bdp = bw * min_rtt * gain
+ * bdp = ceil(bw * min_rtt * gain)
  *
  * The key factor, gain, controls the amount of queue. While a small gain
  * builds a smaller queue, it becomes more vulnerable to noise in RTT
@@ -370,7 +370,9 @@ static u32 bbr_bdp(struct sock *sk, u32 bw, int gain)
 
 	w = (u64)bw * bbr->min_rtt_us;
 
-	/* Apply a gain to the given value, then remove the BW_SCALE shift. */
+	/* Apply a gain to the given value, remove the BW_SCALE shift, and
+	 * round the value up to avoid a negative feedback loop.
+	 */
 	bdp = (((w * gain) >> BBR_SCALE) + BW_UNIT - 1) / BW_UNIT;
 
 	return bdp;
-- 
2.23.0.187.g17f5b7556c-goog

