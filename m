Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB5EF67838E
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 18:48:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232348AbjAWRsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 12:48:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbjAWRsF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 12:48:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E70A7ED7
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 09:47:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674496034;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=Yf2bT+UFBhqM2qEfHYxqRS5quiLzvwOq8P8EfitkpyU=;
        b=bNlfqlcNhrJUFkznZWgrnT2XlNtgs9ac2Y5KCYYqzBKmPbvqPeNIGDUToz2/G+mC4I1tA5
        XWrNIhIGZN/kBgOKYGSnlpe9RXEI/f20ODdWwrPEaiuT4S2E6nmvfXaGtL37xsQ4NkcsWc
        Pew1ad5qEfcwhr364FkQX+cu/vQp9hA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-615-gm0SgVTOPA-YkfRzGMvRkA-1; Mon, 23 Jan 2023 12:47:13 -0500
X-MC-Unique: gm0SgVTOPA-YkfRzGMvRkA-1
Received: by mail-wr1-f69.google.com with SMTP id v12-20020a5d590c000000b002bf9614f379so1282852wrd.4
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 09:47:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Yf2bT+UFBhqM2qEfHYxqRS5quiLzvwOq8P8EfitkpyU=;
        b=50DNf+JMtAIrh0iDZMxe2QiU1n9RK8NC4KcyOglLeMcouy/QpFJhJ7L3UJ5b0i0zHD
         iWFHqgs6TS+H2o58j9SeoOkoxiWdiCFACujUmb/R4tBJ1sP6dIAvpKRjS+t1AnGiSqRK
         Q5+6VxRi901cGY6ia7WZrt6ZSnWyFPrPcP/xRykKQGjdhpuUx+3P+2ym3kYKGNmt2/zx
         jCxuL8BzqVEbUsFnC7NKwPKqyfB4ZznQc5HFmE0Yck9x9Z+93bfR0UGavZz2yFBhD2KL
         Wrm/uff4HamrUAbv/IX1QhiRcFJFKFprC0YMiADUy1tuRW0AEVITBfMbDaTLbyexpfxk
         cj/g==
X-Gm-Message-State: AFqh2kq7hpRsNJQ1dHOIqgdFDaMXjbyQE4J9EyEuBuhitk+ByLdatFYZ
        FORbnYfnE0RVWXj4fG2vD3KJOvmU28EwDVICnuvp6dMEcmV8YAk7mXcVO7EaW5vAVjRtlHb2YEk
        aWfYXUiJ8OKWK27wb
X-Received: by 2002:a05:600c:2e14:b0:3d4:a1ba:a971 with SMTP id o20-20020a05600c2e1400b003d4a1baa971mr24441571wmf.24.1674496032290;
        Mon, 23 Jan 2023 09:47:12 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuEWr+atJad6P9uiFs3utRh10YIK3g0+3fU8Cwkfd/Msfv1NgZqUoSlhPFTMHo0b6CkDVx6oQ==
X-Received: by 2002:a05:600c:2e14:b0:3d4:a1ba:a971 with SMTP id o20-20020a05600c2e1400b003d4a1baa971mr24441561wmf.24.1674496032073;
        Mon, 23 Jan 2023 09:47:12 -0800 (PST)
Received: from debian ([195.135.110.30])
        by smtp.gmail.com with ESMTPSA id m27-20020a05600c3b1b00b003db012d49b7sm25243068wms.2.2023.01.23.09.47.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 09:47:11 -0800 (PST)
Date:   Mon, 23 Jan 2023 18:47:09 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH net-next] ipv6: Make ip6_route_output_flags_noref() static.
Message-ID: <50706db7f675e40b3594d62011d9363dce32b92e.1674495822.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This function is only used in net/ipv6/route.c and has no reason to be
visible outside of it.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 include/net/ip6_route.h | 4 ----
 net/ipv6/route.c        | 8 ++++----
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
index 035d61d50a98..81ee387a1fc4 100644
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -84,10 +84,6 @@ struct dst_entry *ip6_route_input_lookup(struct net *net,
 					 struct flowi6 *fl6,
 					 const struct sk_buff *skb, int flags);
 
-struct dst_entry *ip6_route_output_flags_noref(struct net *net,
-					       const struct sock *sk,
-					       struct flowi6 *fl6, int flags);
-
 struct dst_entry *ip6_route_output_flags(struct net *net, const struct sock *sk,
 					 struct flowi6 *fl6, int flags);
 
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 76889ceeead9..c180c2ef17c5 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2593,9 +2593,10 @@ INDIRECT_CALLABLE_SCOPE struct rt6_info *ip6_pol_route_output(struct net *net,
 	return ip6_pol_route(net, table, fl6->flowi6_oif, fl6, skb, flags);
 }
 
-struct dst_entry *ip6_route_output_flags_noref(struct net *net,
-					       const struct sock *sk,
-					       struct flowi6 *fl6, int flags)
+static struct dst_entry *ip6_route_output_flags_noref(struct net *net,
+						      const struct sock *sk,
+						      struct flowi6 *fl6,
+						      int flags)
 {
 	bool any_src;
 
@@ -2624,7 +2625,6 @@ struct dst_entry *ip6_route_output_flags_noref(struct net *net,
 
 	return fib6_rule_lookup(net, fl6, NULL, flags, ip6_pol_route_output);
 }
-EXPORT_SYMBOL_GPL(ip6_route_output_flags_noref);
 
 struct dst_entry *ip6_route_output_flags(struct net *net,
 					 const struct sock *sk,
-- 
2.30.2

