Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41D64AB343
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 09:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389065AbfIFHgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 03:36:19 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33070 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726936AbfIFHgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 03:36:19 -0400
Received: by mail-pg1-f195.google.com with SMTP id n190so3015981pgn.0
        for <netdev@vger.kernel.org>; Fri, 06 Sep 2019 00:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wfTa9mVNxqo7UqKuHFn+1x6+Ls07vttUdga8PUYEOpc=;
        b=nADoLtBc8Z0v1YqOgT6Sis/Djcow6dLcZu8gs9l0gNltHeqQPm7bSuPwGUsl0CHIwm
         vPSDsF4wDBrjR0tEsWEXa1Dt7Pqz4MLlxK7Xus7TI6GrslvxYY2RdDm3YirprYMgX7Z3
         KXc7b0Nu0aYE38/AJb540evVs1gz3tI+HSP5HROuvlNmb7qmgP82cLWoYG43lvkcpgYO
         mS55zpAYCzPVtH+Tfj53FIjKmLLWM/PLH3JJncGusaba7cuZnettGZtRzQ6uJYzSR6WS
         ZYwL9YaUkFSrpfw1L8O+7en0Rv1I8MvIuGQTqSxztzYOzN+asLtHFN/FuLGVHyZC0Yoj
         rV8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wfTa9mVNxqo7UqKuHFn+1x6+Ls07vttUdga8PUYEOpc=;
        b=GJnhyUI0y1TnadNiY51e7oGy+8tjcHUJFwNk2WUxl2nBbmq68Tq+lpwMnnTkJayIRT
         a6TAruJUa6kmYwwx4wbGSggqjFxMGjFDfmP8QUXtat0jFQJJueYonTvpLt7XkZfUyfLx
         sEzI79AYg7VZmozt299rG/Gb30ShLTx+gvs1bS2BzFfRXP2Pa4iv97j38FGyF8vrB3os
         gNyBr0pZC8+vuzK/iHVex7tatdJtXYqr32jbGp5OhBNwU2lU4rLoVy/lEiWiHRg3IS3d
         ghNUWvHdsMk9UTvKW+9+G8TWDjxBWQgEYgWAUnH3rWzP14Xn4YtC6dB3BcIJKfN5X3xf
         3Ylg==
X-Gm-Message-State: APjAAAVk9DWNPZl2h7lwKLRK8pd3AID1TAVkp6iUoCmB2IkRKKB8MGyz
        XXn+ZZ/Bv8/hovCqLar4flGvhw8Gr6c=
X-Google-Smtp-Source: APXvYqxpmVGOlfO+RqchLKyGqvM5wawEPPMJs7G1SjJkJNYztaVUDsvahh7bfWSkMnqJcpGvfzH4LA==
X-Received: by 2002:a17:90a:ad88:: with SMTP id s8mr7857559pjq.53.1567755378212;
        Fri, 06 Sep 2019 00:36:18 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e192sm7914965pfh.83.2019.09.06.00.36.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Sep 2019 00:36:17 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Phil Karn <karn@ka9q.net>,
        Sukumar Gopalakrishnan <sukumarg1973@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv3 net-next] ipmr: remove hard code cache_resolve_queue_len limit
Date:   Fri,  6 Sep 2019 15:36:01 +0800
Message-Id: <20190906073601.10525-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190903084359.13310-1-liuhangbin@gmail.com>
References: <20190903084359.13310-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a re-post of previous patch wrote by David Miller[1].

Phil Karn reported[2] that on busy networks with lots of unresolved
multicast routing entries, the creation of new multicast group routes
can be extremely slow and unreliable.

The reason is we hard-coded multicast route entries with unresolved source
addresses(cache_resolve_queue_len) to 10. If some multicast route never
resolves and the unresolved source addresses increased, there will
be no ability to create new multicast route cache.

To resolve this issue, we need either add a sysctl entry to make the
cache_resolve_queue_len configurable, or just remove cache_resolve_queue_len
limit directly, as we already have the socket receive queue limits of mrouted
socket, pointed by David.

From my side, I'd perfer to remove the cache_resolve_queue_len limit instead
of creating two more(IPv4 and IPv6 version) sysctl entry.

[1] https://lkml.org/lkml/2018/7/22/11
[2] https://lkml.org/lkml/2018/7/21/343

v3: instead of remove cache_resolve_queue_len totally, let's only remove
the hard code limit when allocate the unresolved cache, as Eric Dumazet
suggested, so we don't need to re-count it in other places.

v2: hold the mfc_unres_lock while walking the unresolved list in
queue_count(), as Nikolay Aleksandrov remind.

Reported-by: Phil Karn <karn@ka9q.net>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/ipv4/ipmr.c  | 4 ++--
 net/ipv6/ip6mr.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index c07bc82cbbe9..313470f6bb14 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -1134,8 +1134,8 @@ static int ipmr_cache_unresolved(struct mr_table *mrt, vifi_t vifi,
 
 	if (!found) {
 		/* Create a new entry if allowable */
-		if (atomic_read(&mrt->cache_resolve_queue_len) >= 10 ||
-		    (c = ipmr_cache_alloc_unres()) == NULL) {
+		c = ipmr_cache_alloc_unres();
+		if (!c) {
 			spin_unlock_bh(&mfc_unres_lock);
 
 			kfree_skb(skb);
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index e80d36c5073d..857a89ad4d6c 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -1148,8 +1148,8 @@ static int ip6mr_cache_unresolved(struct mr_table *mrt, mifi_t mifi,
 		 *	Create a new entry if allowable
 		 */
 
-		if (atomic_read(&mrt->cache_resolve_queue_len) >= 10 ||
-		    (c = ip6mr_cache_alloc_unres()) == NULL) {
+		c = ip6mr_cache_alloc_unres();
+		if (!c) {
 			spin_unlock_bh(&mfc_unres_lock);
 
 			kfree_skb(skb);
-- 
2.19.2

