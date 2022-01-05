Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BAD5485998
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 20:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243789AbiAET4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 14:56:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46328 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243775AbiAET4a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 14:56:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641412588;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kkxPE7csE0XuLRvys1rthi2yBRg1Kfy7/aNN8UlHJOA=;
        b=ZCIniE9DiQl/OdwaC84gEsQHgqjwxOBe3/4ahTH1QblJM2ZapbxGIX6Syq3RtoqOJayN/P
        nTPeqLdsp3y/cVwT/SqTKVAZTGdrvTfQ3BBs+m9tiuXPNzf0wHlxxY7C58GZSDltaN7yfh
        jGwW4lWcaUBCtABsIbZjByyGUpReXLE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-298-IvfrTeC-P_e8jUGg1k3OzA-1; Wed, 05 Jan 2022 14:56:25 -0500
X-MC-Unique: IvfrTeC-P_e8jUGg1k3OzA-1
Received: by mail-wm1-f69.google.com with SMTP id c5-20020a1c3505000000b00345c92c27c6so2308169wma.2
        for <netdev@vger.kernel.org>; Wed, 05 Jan 2022 11:56:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kkxPE7csE0XuLRvys1rthi2yBRg1Kfy7/aNN8UlHJOA=;
        b=xNnYDz2ADnDAmgRlDJ4ZQp54uHawxHUZH+r5qtpWuU7rRvcmncY367+EZ3sG7vA02x
         0h3TrlNZlhqb7aIew5XJB4OqpAogVNBQ4gkjnLiSOsw/Ol47sVwZxobMuqs3xj6Qgd8p
         UKVId/LslqbzC9w2uvmtftSrGe2Ab/EFzSST/CWRehNSTpPN8sMnsBxVokNfl9pEu5cK
         /X2boeKxxNQ8GrCoCgLExqtOgA7Rzj7QKzZwta/n5iEzl6yGRejmD2n85iqPj0yux6a/
         PqX+X1cl7jzdguQoXyd9gZWyMVcbIaP0K1WObZlDn1RXYLfmCRjqpb/SsabCBg9iN8uX
         5nVg==
X-Gm-Message-State: AOAM531dEMnKYY58ILcO+zFSHrIfOJN7tIEUBdZaHLX/c/tQcEd5ssG4
        e+Qml4OmA41f3SADhQrtqFFNMGlAVhSZPuN7U6kIyOJ30AdkkGmQIIfVLz6xuFdyUWW5Kv7u43m
        Gur5bEIBASE3UVeOl
X-Received: by 2002:a5d:5184:: with SMTP id k4mr700007wrv.462.1641412583985;
        Wed, 05 Jan 2022 11:56:23 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwpcJpp6Bbx8FPSjBQmpfnWr9P4r0NY9TW3jrje2RieiDpMqPhTCiZWyliA5tIa0638SiFIjQ==
X-Received: by 2002:a5d:5184:: with SMTP id k4mr700000wrv.462.1641412583859;
        Wed, 05 Jan 2022 11:56:23 -0800 (PST)
Received: from pc-1.home (2a01cb058d24940001d1c23ad2b4ba61.ipv6.abo.wanadoo.fr. [2a01:cb05:8d24:9400:1d1:c23a:d2b4:ba61])
        by smtp.gmail.com with ESMTPSA id p23sm3381492wms.3.2022.01.05.11.56.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 11:56:22 -0800 (PST)
Date:   Wed, 5 Jan 2022 20:56:20 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH net 1/4] xfrm: Don't accidentally set RTO_ONLINK in
 decode_session4()
Message-ID: <417b5d77540ced450db73d53aaf153a12bc50e88.1641407336.git.gnault@redhat.com>
References: <cover.1641407336.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1641407336.git.gnault@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to commit 94e2238969e8 ("xfrm4: strip ECN bits from tos field"),
clear the ECN bits from iph->tos when setting ->flowi4_tos.
This ensures that the last bit of ->flowi4_tos is cleared, so
ip_route_output_key_hash() isn't going to restrict the scope of the
route lookup.

Use ~INET_ECN_MASK instead of IPTOS_RT_MASK, because we have no reason
to clear the high order bits.

Found by code inspection, compile tested only.

Fixes: 4da3089f2b58 ("[IPSEC]: Use TOS when doing tunnel lookups")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 net/xfrm/xfrm_policy.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 1a06585022ab..0bb82df0f569 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -31,6 +31,7 @@
 #include <linux/if_tunnel.h>
 #include <net/dst.h>
 #include <net/flow.h>
+#include <net/inet_ecn.h>
 #include <net/xfrm.h>
 #include <net/ip.h>
 #if IS_ENABLED(CONFIG_IPV6_MIP6)
@@ -3294,7 +3295,7 @@ decode_session4(struct sk_buff *skb, struct flowi *fl, bool reverse)
 	fl4->flowi4_proto = iph->protocol;
 	fl4->daddr = reverse ? iph->saddr : iph->daddr;
 	fl4->saddr = reverse ? iph->daddr : iph->saddr;
-	fl4->flowi4_tos = iph->tos;
+	fl4->flowi4_tos = iph->tos & ~INET_ECN_MASK;
 
 	if (!ip_is_fragment(iph)) {
 		switch (iph->protocol) {
-- 
2.21.3

