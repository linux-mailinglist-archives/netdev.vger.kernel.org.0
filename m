Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C31513FA6A
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 21:17:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732871AbgAPUQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 15:16:54 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:24333 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729030AbgAPUQx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 15:16:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579205812;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=/CytHn2L7KeYF8wQ/geRYrNGxGmK8j4Brp8m4l1SyQA=;
        b=DOVDRf0vXbYkSu/8Z9aXlwmdxGacooOcAkyMezkAu79aJKYAXtVOnj0tE6EEyEf81NA5N4
        sSyPuMDaZECWCA6i7Y8yRDiXmUySEN+0F/N/mQRg52GhiziuTJPw3PJhPRKM1qTBeJe8/o
        iGUu/K7EO58KKEz8G9twIMAOtU4Saww=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-408-N3fzD7lIOQWltK5cuXGpYw-1; Thu, 16 Jan 2020 15:16:50 -0500
X-MC-Unique: N3fzD7lIOQWltK5cuXGpYw-1
Received: by mail-wr1-f70.google.com with SMTP id d8so9584464wrq.12
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 12:16:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=/CytHn2L7KeYF8wQ/geRYrNGxGmK8j4Brp8m4l1SyQA=;
        b=jMDWHyzdkCsmRPhQ2YYm3/Q6ZScrWegDG3Wq6YyifuJTAtFjYFkciXlT8OAwxFbTC9
         0nwyahQ8PN/nkAbny2cN79sWa66B/zjaRW97WJvYoqkYqwen/SCwSaTaCm9c9wmxNk5U
         Q58ofq8LjyKXVsksjsjf5Q5wt4yPJ6FbS2wRATcdA/0HPXX5tjGVvDw/N2JYquBeOw2z
         HT9471IWnZhzoBTP7Iss6OfkqA3XUEuKPHGDPmiEdGbUWeKuVKSTjNjY9Tzw3qaZLs3i
         nyWj3b2o8+o0mmw56CPRUAKGbZcWrTgohZjLhUSIwIcL1NpAP8Hdl29APtXtNE/OT+xn
         ZHHw==
X-Gm-Message-State: APjAAAWnuSS3rKqk43liBV7DXrwEKPHCdBZZgeEcoOQ1lu1RKKUsOWpN
        wLLcey6m4LWyt1G81e4Dj2Btq/zHWR2FaqqxA0/Mlqvo4es07PCRSguOnZ/A1vrIbyEspMh1Gpj
        VmyN+I11sx+R3ArzX
X-Received: by 2002:adf:b64b:: with SMTP id i11mr4956359wre.58.1579205809253;
        Thu, 16 Jan 2020 12:16:49 -0800 (PST)
X-Google-Smtp-Source: APXvYqxqVwjrwdffCiAm/ijqSIT3YVXm0bAEtcLqu1y1hDHTetFVodfuMSQ4TDBBKXOWJy4MrluJ9g==
X-Received: by 2002:adf:b64b:: with SMTP id i11mr4956339wre.58.1579205808962;
        Thu, 16 Jan 2020 12:16:48 -0800 (PST)
Received: from linux.home (2a01cb058a4e7100d3814d1912515f67.ipv6.abo.wanadoo.fr. [2a01:cb05:8a4e:7100:d381:4d19:1251:5f67])
        by smtp.gmail.com with ESMTPSA id g2sm30848987wrw.76.2020.01.16.12.16.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 12:16:48 -0800 (PST)
Date:   Thu, 16 Jan 2020 21:16:46 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH net-next] netns: Constify exported functions
Message-ID: <a681349038fd0358b304c8b9a744946831e5e5f1.1579205730.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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
index 6412c1fbfcb5..757cc1d084e7 100644
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

