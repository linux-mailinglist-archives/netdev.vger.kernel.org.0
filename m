Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E14DCF3CD7
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 01:27:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727744AbfKHA1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 19:27:38 -0500
Received: from mail-pl1-f202.google.com ([209.85.214.202]:36709 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726320AbfKHA1i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 19:27:38 -0500
Received: by mail-pl1-f202.google.com with SMTP id g2so2938635plq.3
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 16:27:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=2rfQJPhWyGs4WYtykBhK+gfUYdjHV5wJtRqLM0MmU0A=;
        b=St798GbZHtw/NE0PffftFDbtPJA3wlkzMICViBgJdmvVyVlJPoxjkxmWpqZfqAkp51
         0Sy6WJaMmPgZ+DIS27kCljeTLAd6I4S4yXUp8qIH2CayObA4jqwbiiAjntL5N3b1jlDy
         k5bkegRusA5WwTej24iTupTl7nYokRppTWgx9O5fzWN1m1hGnZ9HUFI17dsonhhOvK4D
         6MaqvOiKys7Cew9J0eJhF/Eu50G2mCSVFRNBzWmD7mKAsl4sekkd3UA/V4LPf9lGCFFG
         t6bYkDo3x4NCh5ZtnIayM6CjSe/AqMUcEK6JvvLg8V6z0IlWUTpmHv0RICMt0r5MB+xv
         O8VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2rfQJPhWyGs4WYtykBhK+gfUYdjHV5wJtRqLM0MmU0A=;
        b=ZBIoA66MkJ0efEdA/mx1dTNOgHGWpdcdKo/Mogl807+bAgwdW1K+F8MQWUOPcJCDFO
         xPDiHNeo/R2uk0kL5SOwvk/y+N9qzBHityCIlFWG74YDpq1P37KRKN62+VA2h2pp1KSb
         ay8krrn1oP2NxZzJzivx5BiBXUDowMYmFnEUvc6l+OqOLtZ9OI03Ecct+IbUJbRyTqR/
         Ad0V5Q9DQtAuMkgGMXPxuYGIcN8n8tnWMjVe3jI+VipYW9JArGGolKfcD+m47LDO/PHx
         n0VwhyDJNob72022bdZDVgs0WQXCxOg8nBBvMQksO9lX0WMzcff5hZ1qWMuuEoa/sPwk
         W6uA==
X-Gm-Message-State: APjAAAUD3Pha3hH41pK4UT3eaLW+ofLc/sBQkNIf2U24p4MHa/JlRvt2
        0J6cFj0w122tHiVOlfEB/73ZAUNNZGyAVQ==
X-Google-Smtp-Source: APXvYqzsAGvClFf5Q1ZL/IcHUoMo8gGDfXYTLucCe2lLZXwNje+5g6CTbUMQaNvDGPApWu0h+Wya6vhj8hV2eA==
X-Received: by 2002:a63:a5b:: with SMTP id z27mr8486381pgk.416.1573172857226;
 Thu, 07 Nov 2019 16:27:37 -0800 (PST)
Date:   Thu,  7 Nov 2019 16:27:16 -0800
In-Reply-To: <20191108002722.129055-1-edumazet@google.com>
Message-Id: <20191108002722.129055-4-edumazet@google.com>
Mime-Version: 1.0
References: <20191108002722.129055-1-edumazet@google.com>
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH net-next 3/9] net: nlmon: use standard dev_lstats_add() and dev_lstats_read()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No need to hand-code the exact same functions.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 drivers/net/nlmon.c | 28 +++-------------------------
 1 file changed, 3 insertions(+), 25 deletions(-)

diff --git a/drivers/net/nlmon.c b/drivers/net/nlmon.c
index 68771b2f351a228860cdfbc7ab3f028665b2590e..afb119f383252cc4c78e5456d12b7066eb26953f 100644
--- a/drivers/net/nlmon.c
+++ b/drivers/net/nlmon.c
@@ -9,13 +9,7 @@
 
 static netdev_tx_t nlmon_xmit(struct sk_buff *skb, struct net_device *dev)
 {
-	int len = skb->len;
-	struct pcpu_lstats *stats = this_cpu_ptr(dev->lstats);
-
-	u64_stats_update_begin(&stats->syncp);
-	stats->bytes += len;
-	stats->packets++;
-	u64_stats_update_end(&stats->syncp);
+	dev_lstats_add(dev, skb->len);
 
 	dev_kfree_skb(skb);
 
@@ -56,25 +50,9 @@ static int nlmon_close(struct net_device *dev)
 static void
 nlmon_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 {
-	int i;
-	u64 bytes = 0, packets = 0;
-
-	for_each_possible_cpu(i) {
-		const struct pcpu_lstats *nl_stats;
-		u64 tbytes, tpackets;
-		unsigned int start;
-
-		nl_stats = per_cpu_ptr(dev->lstats, i);
-
-		do {
-			start = u64_stats_fetch_begin_irq(&nl_stats->syncp);
-			tbytes = nl_stats->bytes;
-			tpackets = nl_stats->packets;
-		} while (u64_stats_fetch_retry_irq(&nl_stats->syncp, start));
+	u64 packets, bytes;
 
-		packets += tpackets;
-		bytes += tbytes;
-	}
+	dev_lstats_read(dev, &packets, &bytes);
 
 	stats->rx_packets = packets;
 	stats->tx_packets = 0;
-- 
2.24.0.432.g9d3f5f5b63-goog

