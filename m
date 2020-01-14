Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F070313B54B
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 23:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbgANWZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 17:25:33 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:43434 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727102AbgANWZc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 17:25:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579040731;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Yz7jhvh5Wa4mUmldKdd3JDBAyna/bpDTCIRSO1nebQ4=;
        b=DxiFCovdy2R4Td2pUCkxlWB8FPu8v0Of5zYMrnQFLICD2eK2u+ShgPECrdVY/1uRPVLjgo
        O9w93vhLakixhy4QXw1/J2rrqZQKIeHkeNWXL3ydlK9KDy8zpRggzXhI2bw73mFjntvMPT
        6Kl4sY56LF8yycCOvK3cN3gO4EnqDCI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-78-WANttlB8MGOO0c_lrZvaYw-1; Tue, 14 Jan 2020 17:25:28 -0500
X-MC-Unique: WANttlB8MGOO0c_lrZvaYw-1
Received: by mail-wr1-f69.google.com with SMTP id j13so7073909wrr.20
        for <netdev@vger.kernel.org>; Tue, 14 Jan 2020 14:25:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Yz7jhvh5Wa4mUmldKdd3JDBAyna/bpDTCIRSO1nebQ4=;
        b=XqoeoRg+++x+Za/+zWbp9tBxZ7KtwbSU+13mclHwf7qcst4opveboTZUakTFMzRxqa
         UfLSuBqnJ5hpzw7Y3FEFmqLpSwgrjNf9L0b5P+k3qA9dJztiuu+7NUdE/E4LHv7dmzHI
         HRGYZba1F0J2ppVpwL9+JjW4ftrLvrMFYtaUcJQENhzv8la8SCYtZHpBI6wSFQQFNhBX
         o0gbzuLz1XEM2mUs4qWZ2TR0/lrtHHgc11LKE1PAHVZ6qu5ifhugSigpKMlz9gmJ4siF
         3nskyRLA0NfhGcKF+w2gtfHIDtcV8xKG/OZT7pVYMUZ9LucQHkDB+ckQ4nIMnYjZLWQZ
         yyCQ==
X-Gm-Message-State: APjAAAWSqaH5WXndm3fhJzSoXpF6g4WmhylLGuJQM/VVaXZB/y/wljCf
        tHBvULUkSxF+cvb3GPEKjKPXpRgPh6dNnBsC4/YVRpNHRhLRDmNyMsBxRU/1+5c4Pd+94ZE9PXH
        yioUAFaupq4sdO/yA
X-Received: by 2002:a7b:c218:: with SMTP id x24mr30393270wmi.149.1579040726592;
        Tue, 14 Jan 2020 14:25:26 -0800 (PST)
X-Google-Smtp-Source: APXvYqx+IQiU59KG7B3wCdgZ0ShxZOY7AyQrk7RSa4ODUJaXh0fm+a1w4RNzKcf1O/tYogVf7NgCyw==
X-Received: by 2002:a7b:c218:: with SMTP id x24mr30393258wmi.149.1579040726423;
        Tue, 14 Jan 2020 14:25:26 -0800 (PST)
Received: from linux.home (2a01cb058a4e7100d3814d1912515f67.ipv6.abo.wanadoo.fr. [2a01:cb05:8a4e:7100:d381:4d19:1251:5f67])
        by smtp.gmail.com with ESMTPSA id s19sm19687894wmj.33.2020.01.14.14.25.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2020 14:25:25 -0800 (PST)
Date:   Tue, 14 Jan 2020 23:25:24 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH net-next 2/2] netns: constify exported functions
Message-ID: <bc4093c61a90c8c900b43fb35e57233da86f5500.1579040200.git.gnault@redhat.com>
References: <cover.1579040200.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1579040200.git.gnault@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mark function parameters as 'const' where possible.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
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

