Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2004D2ECD45
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 10:53:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbhAGJvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 04:51:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727283AbhAGJvq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 04:51:46 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 518A0C0612A1
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 01:51:08 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id y24so7125403edt.10
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 01:51:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pnRhj7MGrAFks0sNbh9iopBOpkA/i+Ed1RPw6h3LoTY=;
        b=c2I3RWLFfRCzkfKscd+p2mP6zbJsfQnzi/+2b4DQGjOyQv9Ea9kX7une3hm4bMePEB
         afkV0umzXsqgecJjImPh75jdCuVF+2o7hXw2shCKQMtBQC1fy4hLm1+oXo5E16s2zW6q
         VzraX3tx0OYcTb2KVQkWkv3jW3GGqmJmytD+LsfJwSKnU1EEzeQiwx2NCXij4iyDLhoc
         oK2rxFEfxnOD210F2iOpu1AwtkmBZAFOrF1JK85I3ntvGC/gaJFTsgL7JDZRWpf8Vpn9
         DoAp0q+bqMSi9hBH4GlUgstTu73ImCNSLKIB9rP4otIhyzPRgIpmZHigBpIsto4Xyi8A
         eirQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pnRhj7MGrAFks0sNbh9iopBOpkA/i+Ed1RPw6h3LoTY=;
        b=D+Bc2Y2L1OixgkW/qekkWMu3XOvZm4mdnqPOrITzeTP25+IfGE3mRJUXjfe7NKnJBg
         KeHT5Dyh5ruFv0fCQVc/AFpEGgFF88WP0CJSe3ry2OBxcW8cXiX0HagvKTILOStnD1jy
         GQ6+07qPEcKouFhb5gyKIQqrWYMhUkyj2XvnmFJD0l9hWtj7QyX+iXHXC7smPKkCgPWT
         pH2y8AeCJLzbinI4cBSbknh61QdbsvHj3mhxHuQ0Vl/LysNkX1I1xnSwlDiVyH1VtnYk
         ZtNJSRGbjPB+/9WkWWcAhqKT0dNpLHkMkklztjivKeMAoCzBQ3c+iUWRrAH6YDTPY3Kr
         /24Q==
X-Gm-Message-State: AOAM531Gsvmk0mkINU4eUrsloPWA12cbfHha7Vpn8hNKMlj/NKxdwIoX
        ZZ8kXhu6YjLoG9TZuDa3wlE=
X-Google-Smtp-Source: ABdhPJy8ZjDcb77QCvpbasYGt76R8EePoY3CYN7OgM/cRCdlakkn+Du+AxHyLjVvkUTLuu1I+RWdiQ==
X-Received: by 2002:a05:6402:c83:: with SMTP id cm3mr1058183edb.189.1610013067105;
        Thu, 07 Jan 2021 01:51:07 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id k15sm2251571ejc.79.2021.01.07.01.51.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 01:51:06 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Arnd Bergmann <arnd@arndb.de>, Taehee Yoo <ap420073@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, Florian Westphal <fw@strlen.de>
Subject: [PATCH v3 net-next 03/12] net: procfs: hold netif_lists_lock when retrieving device statistics
Date:   Thu,  7 Jan 2021 11:49:42 +0200
Message-Id: <20210107094951.1772183-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210107094951.1772183-1-olteanv@gmail.com>
References: <20210107094951.1772183-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

In the effort of making .ndo_get_stats64 be able to sleep, we need to
ensure the callers of dev_get_stats do not use atomic context.

The /proc/net/dev file uses an RCU read-side critical section to ensure
the integrity of the list of network interfaces, because it iterates
through all net devices in the netns to show their statistics.

To offer the equivalent protection against an interface registering or
deregistering, while also remaining in sleepable context, we can use the
netns mutex for the interface lists.

Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
None.

Changes in v2:
None.

 net/core/net-procfs.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/core/net-procfs.c b/net/core/net-procfs.c
index c714e6a9dad4..4784703c1e39 100644
--- a/net/core/net-procfs.c
+++ b/net/core/net-procfs.c
@@ -21,7 +21,7 @@ static inline struct net_device *dev_from_same_bucket(struct seq_file *seq, loff
 	unsigned int count = 0, offset = get_offset(*pos);
 
 	h = &net->dev_index_head[get_bucket(*pos)];
-	hlist_for_each_entry_rcu(dev, h, index_hlist) {
+	hlist_for_each_entry(dev, h, index_hlist) {
 		if (++count == offset)
 			return dev;
 	}
@@ -51,9 +51,11 @@ static inline struct net_device *dev_from_bucket(struct seq_file *seq, loff_t *p
  *	in detail.
  */
 static void *dev_seq_start(struct seq_file *seq, loff_t *pos)
-	__acquires(RCU)
 {
-	rcu_read_lock();
+	struct net *net = seq_file_net(seq);
+
+	netif_lists_lock(net);
+
 	if (!*pos)
 		return SEQ_START_TOKEN;
 
@@ -70,9 +72,10 @@ static void *dev_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 }
 
 static void dev_seq_stop(struct seq_file *seq, void *v)
-	__releases(RCU)
 {
-	rcu_read_unlock();
+	struct net *net = seq_file_net(seq);
+
+	netif_lists_unlock(net);
 }
 
 static void dev_seq_printf_stats(struct seq_file *seq, struct net_device *dev)
-- 
2.25.1

