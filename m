Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4884129BB8
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 18:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390330AbfEXQDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 12:03:51 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:43506 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390314AbfEXQDv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 12:03:51 -0400
Received: by mail-pl1-f202.google.com with SMTP id m12so6153230pls.10
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 09:03:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=aFleB3wOqrn8F0T7ewvSf23uLfLWHJva9hDVgt/O6Yo=;
        b=vaQ5tdGIpoTkIio5zXfq/wKozRXK3zz9wghbP7Sm59eJdkdwb6uRKbOLG9E95eFqbO
         Go46Ggv69gkdJ3QIIABoWoioqo02Bx1QScqMK0HciMLLpu+i4CygU84UGG+PQatUIrsb
         Yq79QrCrKQgx2aMd8Egkzsungr/JBsj7axlN3UaZT8xuw9XkuY/BX2XMk34/AFPOaWMB
         Zx9LIpc9+v8H4oMOW1gitMX16wc6jfoZzNVMnfugd4/vIcgCQfHDugKaTk6NkalfpHaO
         cguodCWApTQyNXrnCB8F+JFeYUJM4iRuOsVe96s38raanRUgIUziKk8+cltQdv9nDCfb
         XaZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=aFleB3wOqrn8F0T7ewvSf23uLfLWHJva9hDVgt/O6Yo=;
        b=SjS0fOma8d9J7fDZwe52FMSMEWQFjLPbKREprH9lws/Fkjvtb9EggnOz2eCp24XI5W
         BKiLHav9q3zkXof5lx0G/Qlyy5btR/wXbR+z+J++H4XZssbVaWyv/XB/OR0ixies7SZc
         53h7aNjhcH0KESUW7kpIy+7NzRK7yt2pesXKmxjXpDAHARXWPSIZobX7etG+K2NKeT54
         E84NTYSIKCvI7hHbmHMLWUJDS0CTmkvECDCGx0dd9jiBTq6FdfK9xSZTYsoigqVvlqBV
         77VbxM6ObRV+MytDmcE3LBcIlbLItG6htHkbjzGSn0GW4XtMn/NMS22jZpu3C6JoNuyr
         5sxA==
X-Gm-Message-State: APjAAAXvFU5FNCsPcQaWruwQoKg8eADNrcdCJEuG3cyk9pfem5DvnsK0
        QiuraB00wVq+eITuhV+4z9ii0JZNpCqq7w==
X-Google-Smtp-Source: APXvYqwwlH6FSp0MBDCirhPBSvA4Q+GlEl/YCpL/Csc4yEbwg12ygVpj16quiZhNMSz2bZ5FSP9cfOgKNWEhTA==
X-Received: by 2002:a63:2f47:: with SMTP id v68mr21636377pgv.251.1558713830057;
 Fri, 24 May 2019 09:03:50 -0700 (PDT)
Date:   Fri, 24 May 2019 09:03:31 -0700
In-Reply-To: <20190524160340.169521-1-edumazet@google.com>
Message-Id: <20190524160340.169521-3-edumazet@google.com>
Mime-Version: 1.0
References: <20190524160340.169521-1-edumazet@google.com>
X-Mailer: git-send-email 2.22.0.rc1.257.g3120a18244-goog
Subject: [PATCH net-next 02/11] net: rename inet_frags_exit_net() to fqdir_exit()
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

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/inet_frag.h                 | 2 +-
 net/ieee802154/6lowpan/reassembly.c     | 4 ++--
 net/ipv4/inet_fragment.c                | 4 ++--
 net/ipv4/ip_fragment.c                  | 4 ++--
 net/ipv6/netfilter/nf_conntrack_reasm.c | 4 ++--
 net/ipv6/reassembly.c                   | 4 ++--
 6 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/net/inet_frag.h b/include/net/inet_frag.h
index b19b1ba44ac595215f44b9c86029d6ad27e26458..d1bfd5dbe2d439e1cd9c620e5197ffbffb05920a 100644
--- a/include/net/inet_frag.h
+++ b/include/net/inet_frag.h
@@ -109,7 +109,7 @@ static inline int inet_frags_init_net(struct fqdir *fqdir)
 	atomic_long_set(&fqdir->mem, 0);
 	return rhashtable_init(&fqdir->rhashtable, &fqdir->f->rhash_params);
 }
-void inet_frags_exit_net(struct fqdir *fqdir);
+void fqdir_exit(struct fqdir *fqdir);
 
 void inet_frag_kill(struct inet_frag_queue *q);
 void inet_frag_destroy(struct inet_frag_queue *q);
diff --git a/net/ieee802154/6lowpan/reassembly.c b/net/ieee802154/6lowpan/reassembly.c
index 8551d307f2149d0c9e74c7d9f89665b082ed63bc..dc73452d3224b7b125405ba577e8d222e2ee9db3 100644
--- a/net/ieee802154/6lowpan/reassembly.c
+++ b/net/ieee802154/6lowpan/reassembly.c
@@ -464,7 +464,7 @@ static int __net_init lowpan_frags_init_net(struct net *net)
 		return res;
 	res = lowpan_frags_ns_sysctl_register(net);
 	if (res < 0)
-		inet_frags_exit_net(&ieee802154_lowpan->frags);
+		fqdir_exit(&ieee802154_lowpan->frags);
 	return res;
 }
 
@@ -474,7 +474,7 @@ static void __net_exit lowpan_frags_exit_net(struct net *net)
 		net_ieee802154_lowpan(net);
 
 	lowpan_frags_ns_sysctl_unregister(net);
-	inet_frags_exit_net(&ieee802154_lowpan->frags);
+	fqdir_exit(&ieee802154_lowpan->frags);
 }
 
 static struct pernet_operations lowpan_frags_ops = {
diff --git a/net/ipv4/inet_fragment.c b/net/ipv4/inet_fragment.c
index f8de2860e3a3e0941d29c9d65ab8336cfee56f65..a5ec5d9567931d03cfa3fbe1a370857ed8dc3b3d 100644
--- a/net/ipv4/inet_fragment.c
+++ b/net/ipv4/inet_fragment.c
@@ -145,13 +145,13 @@ static void inet_frags_free_cb(void *ptr, void *arg)
 	inet_frag_put(fq);
 }
 
-void inet_frags_exit_net(struct fqdir *fqdir)
+void fqdir_exit(struct fqdir *fqdir)
 {
 	fqdir->high_thresh = 0; /* prevent creation of new frags */
 
 	rhashtable_free_and_destroy(&fqdir->rhashtable, inet_frags_free_cb, NULL);
 }
-EXPORT_SYMBOL(inet_frags_exit_net);
+EXPORT_SYMBOL(fqdir_exit);
 
 void inet_frag_kill(struct inet_frag_queue *fq)
 {
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index c93e27cb0a8d1e404fd54e6aa5ea6a99ccecba4a..9de13b5d23e37f585aa50e636e009e9d21083d02 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -685,14 +685,14 @@ static int __net_init ipv4_frags_init_net(struct net *net)
 		return res;
 	res = ip4_frags_ns_ctl_register(net);
 	if (res < 0)
-		inet_frags_exit_net(&net->ipv4.frags);
+		fqdir_exit(&net->ipv4.frags);
 	return res;
 }
 
 static void __net_exit ipv4_frags_exit_net(struct net *net)
 {
 	ip4_frags_ns_ctl_unregister(net);
-	inet_frags_exit_net(&net->ipv4.frags);
+	fqdir_exit(&net->ipv4.frags);
 }
 
 static struct pernet_operations ip4_frags_ops = {
diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 5b877d732b2fff23adb5be64dcbed587ab4e8077..f08e1422c56dcd207d148ecb578df4a8f7ac2d9d 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -506,14 +506,14 @@ static int nf_ct_net_init(struct net *net)
 		return res;
 	res = nf_ct_frag6_sysctl_register(net);
 	if (res < 0)
-		inet_frags_exit_net(&net->nf_frag.frags);
+		fqdir_exit(&net->nf_frag.frags);
 	return res;
 }
 
 static void nf_ct_net_exit(struct net *net)
 {
 	nf_ct_frags6_sysctl_unregister(net);
-	inet_frags_exit_net(&net->nf_frag.frags);
+	fqdir_exit(&net->nf_frag.frags);
 }
 
 static struct pernet_operations nf_ct_net_ops = {
diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index acd5a9a04415506570da67cc3dcee9cb61cfbd5b..f1142f5d5075a56164aa3f1f56c12328ab99747c 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -528,14 +528,14 @@ static int __net_init ipv6_frags_init_net(struct net *net)
 
 	res = ip6_frags_ns_sysctl_register(net);
 	if (res < 0)
-		inet_frags_exit_net(&net->ipv6.frags);
+		fqdir_exit(&net->ipv6.frags);
 	return res;
 }
 
 static void __net_exit ipv6_frags_exit_net(struct net *net)
 {
 	ip6_frags_ns_sysctl_unregister(net);
-	inet_frags_exit_net(&net->ipv6.frags);
+	fqdir_exit(&net->ipv6.frags);
 }
 
 static struct pernet_operations ip6_frags_ops = {
-- 
2.22.0.rc1.257.g3120a18244-goog

