Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A257929BBE
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 18:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390581AbfEXQEK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 12:04:10 -0400
Received: from mail-ua1-f74.google.com ([209.85.222.74]:37563 "EHLO
        mail-ua1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389962AbfEXQEJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 12:04:09 -0400
Received: by mail-ua1-f74.google.com with SMTP id u3so2285519uao.4
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 09:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=DiTS4sZKd+xSQh1aIZF9GDbaZTRZU02BTcO8HkLrNLI=;
        b=CFkF9AFcBrJkxvKukzx13Q79TsYPcwBOP72IYqNnGc311ippvUPs0etP/dQ/qZfcjy
         0+inuH5NbsFmz6UNGe9hDciEoa7htmE79PaDh2XTrruMA2I1XM1xaCAEH7BXoJ1I7bB9
         Y8rP29T1UzAqUwwdsf7SXeha0YzjITr8nFJM9MBb7cAgcDd8Cbjn/Z5XZS7OOpI9U8Ch
         6aT8rXLDQivqUzihB+UHlYVnzpcRvT5/MtRVLYXr1OufD334slkO+pW9Kh8vRHkDG+f7
         WISwW7SMv5ndut8QgQ2A3qUuW2Vw3PeswcxR9/XIuoVgUPE2YmGt/zGz2CZ6KlZaintz
         bIQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=DiTS4sZKd+xSQh1aIZF9GDbaZTRZU02BTcO8HkLrNLI=;
        b=nwXjYb1u9p37zcWMvON6jZ83bPHFWIk9eFNwPzxIkV/v+VBqdFJU4MCj4CZVB3S5iy
         cujFiGpRLNIjpqc3SHCI3z62tND92H7zrRXJqzlOGyLar9pwgeuQZuFq/BtaqXlHlA5J
         ErryIZmymxo29SRnmErmMN8XGDARPSeRCJRtzyA1hgydL3bOWpFWBESaAD543ATICpEn
         zgQPIyaJbAu0Co8g+d+pX5D/0Cr322YGns8wWBJyg0Ff4lSbSq896VYp/iXwq8X4ZnMu
         7THkUYMeWzBrJ82E7k9eEGhIMo6tuG5ilzd/EBG/Tu/oG0wuc3A5HeBxdlULK7nzOElY
         iKMw==
X-Gm-Message-State: APjAAAVRSsdHN3WzMLsDpFjbLzcQqRovPp5mEI3Nlml8aVDNlb/6DlgV
        R13FZJ0hpcLGhSVSbeHmNUuVX0YkSZEcMQ==
X-Google-Smtp-Source: APXvYqwV+d7FUxw9Ql28r0wzIzBqibW0i4t+PeUkR13+jPcLJ7sfaerEYiXimLDDb4YzM+8iFLzShnAqZ4LyJg==
X-Received: by 2002:a1f:2b58:: with SMTP id r85mr5933048vkr.41.1558713848496;
 Fri, 24 May 2019 09:04:08 -0700 (PDT)
Date:   Fri, 24 May 2019 09:03:37 -0700
In-Reply-To: <20190524160340.169521-1-edumazet@google.com>
Message-Id: <20190524160340.169521-9-edumazet@google.com>
Mime-Version: 1.0
References: <20190524160340.169521-1-edumazet@google.com>
X-Mailer: git-send-email 2.22.0.rc1.257.g3120a18244-goog
Subject: [PATCH net-next 08/11] net: rename inet_frags_init_net() to fdir_init()
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

And pass an extra parameter, since we will soon
dynamically allocate fqdir structures.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/inet_frag.h                 | 3 ++-
 net/ieee802154/6lowpan/reassembly.c     | 3 +--
 net/ipv4/ip_fragment.c                  | 3 +--
 net/ipv6/netfilter/nf_conntrack_reasm.c | 3 +--
 net/ipv6/reassembly.c                   | 3 +--
 5 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/include/net/inet_frag.h b/include/net/inet_frag.h
index d1bfd5dbe2d439e1cd9c620e5197ffbffb05920a..fca246b0abd84d354c6ca1902af9867732ff49cc 100644
--- a/include/net/inet_frag.h
+++ b/include/net/inet_frag.h
@@ -104,8 +104,9 @@ struct inet_frags {
 int inet_frags_init(struct inet_frags *);
 void inet_frags_fini(struct inet_frags *);
 
-static inline int inet_frags_init_net(struct fqdir *fqdir)
+static inline int fqdir_init(struct fqdir *fqdir, struct inet_frags *f)
 {
+	fqdir->f = f;
 	atomic_long_set(&fqdir->mem, 0);
 	return rhashtable_init(&fqdir->rhashtable, &fqdir->f->rhash_params);
 }
diff --git a/net/ieee802154/6lowpan/reassembly.c b/net/ieee802154/6lowpan/reassembly.c
index 4bbd6999c58fc04ad660928a10f89a7ff0ed4cf2..82db76ce0e61c06c6e56a00999530c7b47b49143 100644
--- a/net/ieee802154/6lowpan/reassembly.c
+++ b/net/ieee802154/6lowpan/reassembly.c
@@ -452,9 +452,8 @@ static int __net_init lowpan_frags_init_net(struct net *net)
 	ieee802154_lowpan->fqdir.high_thresh = IPV6_FRAG_HIGH_THRESH;
 	ieee802154_lowpan->fqdir.low_thresh = IPV6_FRAG_LOW_THRESH;
 	ieee802154_lowpan->fqdir.timeout = IPV6_FRAG_TIMEOUT;
-	ieee802154_lowpan->fqdir.f = &lowpan_frags;
 
-	res = inet_frags_init_net(&ieee802154_lowpan->fqdir);
+	res = fqdir_init(&ieee802154_lowpan->fqdir, &lowpan_frags);
 	if (res < 0)
 		return res;
 	res = lowpan_frags_ns_sysctl_register(net);
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index fb035f4f36ca72c6a9013830a3fb327d802b3e00..d95592d5298136d852d9bb07a6f2091865f83e35 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -672,9 +672,8 @@ static int __net_init ipv4_frags_init_net(struct net *net)
 	net->ipv4.fqdir.timeout = IP_FRAG_TIME;
 
 	net->ipv4.fqdir.max_dist = 64;
-	net->ipv4.fqdir.f = &ip4_frags;
 
-	res = inet_frags_init_net(&net->ipv4.fqdir);
+	res = fqdir_init(&net->ipv4.fqdir, &ip4_frags);
 	if (res < 0)
 		return res;
 	res = ip4_frags_ns_ctl_register(net);
diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 3387ce53040953f16de1fbb447c744af87e0cefa..e72a1cc42163cc801e441e18b3a10a4c9f578aa3 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -494,9 +494,8 @@ static int nf_ct_net_init(struct net *net)
 	net->nf_frag.fqdir.high_thresh = IPV6_FRAG_HIGH_THRESH;
 	net->nf_frag.fqdir.low_thresh = IPV6_FRAG_LOW_THRESH;
 	net->nf_frag.fqdir.timeout = IPV6_FRAG_TIMEOUT;
-	net->nf_frag.fqdir.f = &nf_frags;
 
-	res = inet_frags_init_net(&net->nf_frag.fqdir);
+	res = fqdir_init(&net->nf_frag.fqdir, &nf_frags);
 	if (res < 0)
 		return res;
 	res = nf_ct_frag6_sysctl_register(net);
diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index aabc9b2e83e4ba9ae4af6a6d7047fe926c391d59..8235c5a8e8fe8d99c339e3f39979d8fe388f7c0a 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -515,9 +515,8 @@ static int __net_init ipv6_frags_init_net(struct net *net)
 	net->ipv6.fqdir.high_thresh = IPV6_FRAG_HIGH_THRESH;
 	net->ipv6.fqdir.low_thresh = IPV6_FRAG_LOW_THRESH;
 	net->ipv6.fqdir.timeout = IPV6_FRAG_TIMEOUT;
-	net->ipv6.fqdir.f = &ip6_frags;
 
-	res = inet_frags_init_net(&net->ipv6.fqdir);
+	res = fqdir_init(&net->ipv6.fqdir, &ip6_frags);
 	if (res < 0)
 		return res;
 
-- 
2.22.0.rc1.257.g3120a18244-goog

