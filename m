Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C495446A3EC
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 19:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346769AbhLFSZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 13:25:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21189 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346740AbhLFSZq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 13:25:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638814937;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mEG28ovqNRWUVFjUSshI4gzm6s3LaL7IRipMefu8BVI=;
        b=AmnK2psy0bXJdTEGudg7OA8XE07tP6nj/A2WyiQu/M+BHN2Vy+vkbIKlUw6/HYJy9onHKG
        8GPsWVIKxtfG1D1xeBcm1uEVRt9HYMVwTJ1MXNSYGotednAhr3pa+f+Z3Ksr2/j8J9u82f
        QA+/3Ij0+3f7MtmtwWOCMhl/v1QRox0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-516-J1AU9IGDPtyKpA3e5SYUXA-1; Mon, 06 Dec 2021 13:22:16 -0500
X-MC-Unique: J1AU9IGDPtyKpA3e5SYUXA-1
Received: by mail-wm1-f72.google.com with SMTP id j193-20020a1c23ca000000b003306ae8bfb7so6476264wmj.7
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 10:22:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mEG28ovqNRWUVFjUSshI4gzm6s3LaL7IRipMefu8BVI=;
        b=u/ny59CjGmvbgKnxuomYW+w+WYNGX87LNasVW8yvgVun6gwdcv4WOCh97Fu69tsWSf
         FWhL/eB6CPChH3Yzh1mjYQYcmrwOEo892YNVOduojhETVJwqBGLGj88piLII2aDH6sfR
         mLpje1a4Y2LilvZ0p1Rr/TUgDGtFY5U+vVtjt/6/uQiDXZEFzddiaOz9cMBCadrVNt6O
         o/p3oQEwmfrEMH2Cdpi5Rsxw1svKNNEbe2pIdM+0QDbyDI/uOnHhc0z3ONISkoiVqm2x
         rVwy0d4PIC6XHxTs3NeU1EdtyLUDnreMNHHO8T02FWT6zGJKCwCMq/tg5ZYj5bnh/3YF
         ZjTw==
X-Gm-Message-State: AOAM532i0qa58CyqE39xK97t+wKTpxoh3BKs18qVhz0cpLDTramPwovJ
        xVhJ8FswfiYc+7ZGNd8GZcy4sFUBI9p3a9dSp6ggZh9rEFMf4DPwlistE8sGsDDsYiBNntITA/8
        1F71WcSDLxWOJbZ3P
X-Received: by 2002:a05:600c:1c07:: with SMTP id j7mr280875wms.12.1638814934827;
        Mon, 06 Dec 2021 10:22:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxagOJVTe24auXjqT51ofmkzZ6ES/H9GNK96h5MY+fOvaoshdbm0yyEqzA+Gk6muCxRVXtR4A==
X-Received: by 2002:a05:600c:1c07:: with SMTP id j7mr280857wms.12.1638814934675;
        Mon, 06 Dec 2021 10:22:14 -0800 (PST)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id j40sm135540wms.19.2021.12.06.10.22.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 10:22:14 -0800 (PST)
Date:   Mon, 6 Dec 2021 19:22:12 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Russell Strong <russell@strong.id.au>
Subject: [PATCH net-next 3/4] ipv4: Reject routes specifying ECN bits in
 rtm_tos
Message-ID: <21597671f9f2ef5175846eb02d100527ac242373.1638814614.git.gnault@redhat.com>
References: <cover.1638814614.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1638814614.git.gnault@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the new dscp_t type to replace the fc_tos field of fib_config, to
ensure IPv4 routes aren't influenced by ECN bits when configured with
non-zero rtm_tos.

Before this patch, IPv4 routes specifying an rtm_tos with some of the
ECN bits set were accepted. However they wouldn't work (never match) as
IPv4 normally clears the ECN bits with IPTOS_RT_MASK before doing a FIB
lookup (although a few buggy code paths don't).

After this patch, IPv4 routes specifying an rtm_tos with any ECN bit
set is rejected.

Note, IPv6 routes ignore rtm_tos altogether: any rtm_tos is accepted,
but treated as if it were 0.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 include/net/ip_fib.h    |  3 ++-
 net/ipv4/fib_frontend.c | 10 +++++++++-
 net/ipv4/fib_trie.c     |  7 +++++--
 3 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index 3417ba2d27ad..920091064731 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -17,6 +17,7 @@
 #include <linux/rcupdate.h>
 #include <net/fib_notifier.h>
 #include <net/fib_rules.h>
+#include <net/inet_dscp.h>
 #include <net/inetpeer.h>
 #include <linux/percpu.h>
 #include <linux/notifier.h>
@@ -24,7 +25,7 @@
 
 struct fib_config {
 	u8			fc_dst_len;
-	u8			fc_tos;
+	dscp_t			fc_dscp;
 	u8			fc_protocol;
 	u8			fc_scope;
 	u8			fc_type;
diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index 4d61ddd8a0ec..0cc6dacabead 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -32,6 +32,7 @@
 #include <linux/list.h>
 #include <linux/slab.h>
 
+#include <net/inet_dscp.h>
 #include <net/ip.h>
 #include <net/protocol.h>
 #include <net/route.h>
@@ -735,8 +736,15 @@ static int rtm_to_fib_config(struct net *net, struct sk_buff *skb,
 	memset(cfg, 0, sizeof(*cfg));
 
 	rtm = nlmsg_data(nlh);
+
+	if (!inet_validate_dscp(rtm->rtm_tos)) {
+		NL_SET_ERR_MSG(extack, "Invalid dsfield (tos): ECN bits must be 0");
+		err = -EINVAL;
+		goto errout;
+	}
+	cfg->fc_dscp = inet_dsfield_to_dscp(rtm->rtm_tos);
+
 	cfg->fc_dst_len = rtm->rtm_dst_len;
-	cfg->fc_tos = rtm->rtm_tos;
 	cfg->fc_table = rtm->rtm_table;
 	cfg->fc_protocol = rtm->rtm_protocol;
 	cfg->fc_scope = rtm->rtm_scope;
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 8060524f4256..d937eeebb812 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -61,6 +61,7 @@
 #include <linux/vmalloc.h>
 #include <linux/notifier.h>
 #include <net/net_namespace.h>
+#include <net/inet_dscp.h>
 #include <net/ip.h>
 #include <net/protocol.h>
 #include <net/route.h>
@@ -1210,9 +1211,9 @@ int fib_table_insert(struct net *net, struct fib_table *tb,
 	struct fib_info *fi;
 	u8 plen = cfg->fc_dst_len;
 	u8 slen = KEYLENGTH - plen;
-	u8 tos = cfg->fc_tos;
 	u32 key;
 	int err;
+	u8 tos;
 
 	key = ntohl(cfg->fc_dst);
 
@@ -1227,6 +1228,7 @@ int fib_table_insert(struct net *net, struct fib_table *tb,
 		goto err;
 	}
 
+	tos = inet_dscp_to_dsfield(cfg->fc_dscp);
 	l = fib_find_node(t, &tp, key);
 	fa = l ? fib_find_alias(&l->leaf, slen, tos, fi->fib_priority,
 				tb->tb_id, false) : NULL;
@@ -1703,8 +1705,8 @@ int fib_table_delete(struct net *net, struct fib_table *tb,
 	struct key_vector *l, *tp;
 	u8 plen = cfg->fc_dst_len;
 	u8 slen = KEYLENGTH - plen;
-	u8 tos = cfg->fc_tos;
 	u32 key;
+	u8 tos;
 
 	key = ntohl(cfg->fc_dst);
 
@@ -1715,6 +1717,7 @@ int fib_table_delete(struct net *net, struct fib_table *tb,
 	if (!l)
 		return -ESRCH;
 
+	tos = inet_dscp_to_dsfield(cfg->fc_dscp);
 	fa = fib_find_alias(&l->leaf, slen, tos, 0, tb->tb_id, false);
 	if (!fa)
 		return -ESRCH;
-- 
2.21.3

