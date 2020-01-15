Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7E813C7FD
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 16:36:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729151AbgAOPgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 10:36:36 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43056 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726418AbgAOPgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 10:36:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579102594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DJubPjYV5ieGhBVDKcdhG12ZoyxttwO5oOLEcYKnOqg=;
        b=Bn1AmIiy2Ek2glAVQXV3fIcMB4cwgbRk6+UvYw/RpF2ZU8AX0kJ0lmBO93mQbYZ+PU/mEy
        Q8caQ9Fz4MVMlG3/8z56hK+mfwRdT+WvbhPFI6yi//aiuVdFnbisciO1jdvlOYTwnFZZ6m
        ejnhtpibRF4WG9/GUHQ09vDERRWgg90=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-hNcuhYZIPUCYMTdSoA3bCA-1; Wed, 15 Jan 2020 10:36:32 -0500
X-MC-Unique: hNcuhYZIPUCYMTdSoA3bCA-1
Received: by mail-wr1-f70.google.com with SMTP id z15so8171326wrw.0
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 07:36:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DJubPjYV5ieGhBVDKcdhG12ZoyxttwO5oOLEcYKnOqg=;
        b=dFs/+yPdtexupidib1IZ5VYUWTt25ied++X1kwlIeM6BQYN7cd4ZHYkc8t6C6/BtR2
         C1YfD7S3UiZz/N6F2t92ROMYUzh+oVIYJwjYZCzt0Rs3kVV10ty97aJTlZ5otVGeicFE
         UH864MLVuFOV8Fa/JrObpf/sIX1JIbmyhygSFMn8576st7AyFKwLnid8HXGm+WIEeyFB
         Wp8dyDEM6hT5G4yOf1Ib0NdTIEOeqsaUfB4pvuAdEOp/sQIv/RUE0M1EmAHnrK/TCFhk
         962eMUMW7sI/P40j3XiNXinsN6oPGLUhhK+3RMC2k/M07Pyw3XZ/RNCwLWyUoCe5kV7v
         GM7g==
X-Gm-Message-State: APjAAAXmdQ0FlpBn5Y2koem9m+65F9kdRQgB4ekyGDg0gHn45uowNhDV
        OyCHGZ7vSjl1YmKrnwOwp6whdHkMarvvyv+jyTMDK1qxXbHEHmzQEQyFxSLJzrHNBASx28vrzSv
        c9NsMvDHhFYlkvMo5
X-Received: by 2002:adf:e5ca:: with SMTP id a10mr31463836wrn.347.1579102591554;
        Wed, 15 Jan 2020 07:36:31 -0800 (PST)
X-Google-Smtp-Source: APXvYqxwg8KcSCXJnaNHNYl9Q1/nY/WSDFMY0T/QDU2FI9y0eAb7s+Mz+JiVIvvS5zPo88LwMdGHJA==
X-Received: by 2002:adf:e5ca:: with SMTP id a10mr31463817wrn.347.1579102591330;
        Wed, 15 Jan 2020 07:36:31 -0800 (PST)
Received: from linux.home (2a01cb058a4e7100d3814d1912515f67.ipv6.abo.wanadoo.fr. [2a01:cb05:8a4e:7100:d381:4d19:1251:5f67])
        by smtp.gmail.com with ESMTPSA id d8sm24445243wrx.71.2020.01.15.07.36.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2020 07:36:30 -0800 (PST)
Date:   Wed, 15 Jan 2020 16:36:28 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH net-next v2 2/2] netns: constify exported functions
Message-ID: <0c754407f2018e1a4e736508c91b8604e6cdd0db.1579102319.git.gnault@redhat.com>
References: <cover.1579102319.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1579102319.git.gnault@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mark function parameters as 'const' where possible.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 include/net/net_namespace.h | 10 +++++-----
 net/core/net_namespace.c    |  6 +++---
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index b8ceaf0cd997..854d39ef1ca3 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -347,9 +347,9 @@ static inline struct net *read_pnet(const possible_net_t *pnet)
 #endif
 
 int peernet2id_alloc(struct net *net, struct net *peer, gfp_t gfp);
-int peernet2id(struct net *net, struct net *peer);
-bool peernet_has_id(struct net *net, struct net *peer);
-struct net *get_net_ns_by_id(struct net *net, int id);
+int peernet2id(const struct net *net, struct net *peer);
+bool peernet_has_id(const struct net *net, struct net *peer);
+struct net *get_net_ns_by_id(const struct net *net, int id);
 
 struct pernet_operations {
 	struct list_head list;
@@ -427,7 +427,7 @@ static inline void unregister_net_sysctl_table(struct ctl_table_header *header)
 }
 #endif
 
-static inline int rt_genid_ipv4(struct net *net)
+static inline int rt_genid_ipv4(const struct net *net)
 {
 	return atomic_read(&net->ipv4.rt_genid);
 }
@@ -459,7 +459,7 @@ static inline void rt_genid_bump_all(struct net *net)
 	rt_genid_bump_ipv6(net);
 }
 
-static inline int fnhe_genid(struct net *net)
+static inline int fnhe_genid(const struct net *net)
 {
 	return atomic_read(&net->fnhe_genid);
 }
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 85c565571c1c..fd0727670f34 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -268,7 +268,7 @@ int peernet2id_alloc(struct net *net, struct net *peer, gfp_t gfp)
 EXPORT_SYMBOL_GPL(peernet2id_alloc);
 
 /* This function returns, if assigned, the id of a peer netns. */
-int peernet2id(struct net *net, struct net *peer)
+int peernet2id(const struct net *net, struct net *peer)
 {
 	int id;
 
@@ -283,12 +283,12 @@ EXPORT_SYMBOL(peernet2id);
 /* This function returns true is the peer netns has an id assigned into the
  * current netns.
  */
-bool peernet_has_id(struct net *net, struct net *peer)
+bool peernet_has_id(const struct net *net, struct net *peer)
 {
 	return peernet2id(net, peer) >= 0;
 }
 
-struct net *get_net_ns_by_id(struct net *net, int id)
+struct net *get_net_ns_by_id(const struct net *net, int id)
 {
 	struct net *peer;
 
-- 
2.21.1

