Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1F6768F41D
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 18:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231523AbjBHRPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 12:15:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231395AbjBHRPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 12:15:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC5329436
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 09:14:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675876450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7jHL+4ukdO7JS9MpzLr+cH71JvjbK3FEFVBlwwrSKv4=;
        b=Rp7+womRdGQOrTyCl0yw2SPL8nhuJ7p8vsqfLS67JGlGn1fZMovUYfGVXr4DmiSHjpVfPy
        zj9QQaYJKHTo38XmLBRVzUF4ky2yttMck3YoQt5Iq2FSFBQZKiwjrT6L4z/vUP33Rsb4h/
        S7eGKMRm45tQe8KPIK6BxD48Uo5eanY=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-584-FouNqBW2MCGw5yH-1sTM9w-1; Wed, 08 Feb 2023 12:14:07 -0500
X-MC-Unique: FouNqBW2MCGw5yH-1sTM9w-1
Received: by mail-qk1-f198.google.com with SMTP id 130-20020a370588000000b0072fcbe20069so9646614qkf.22
        for <netdev@vger.kernel.org>; Wed, 08 Feb 2023 09:14:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7jHL+4ukdO7JS9MpzLr+cH71JvjbK3FEFVBlwwrSKv4=;
        b=ZWhqI7QBr2bRcjCer4XgvbjB5N5Rm+VkZbrpvg+KTb2S7HLhvHgFfgNg+qd3mkEa7S
         e/nbNmnraA82OF7m48N4hZqeTTiKsC7yz4kU1+W6VpC55wURHkRpb5tWza3tFl3cYyfU
         OJNP7/yBiBZoQ41I8UsmGcYaXJxTDkBYXtiRx7AXIEDz13pCRdBHI6QxKKSnq1XdrIwa
         pkN+RhMArcOqw7sPkKDx+uy12TEka+ajDs3Z0Luukqs2T6GLqf4TpItiBMHeTJPJnIDp
         lqvPJ/VOud0E6ictq2a9kDKBmBaI67I0UhxsWC8j9U5uwR/rygnYnB2mKH71++TvOUJB
         y6bw==
X-Gm-Message-State: AO0yUKXc2lZ6pUhq+7t00oX9MYFQrxw7hkF+hCHnvypXDwW9J6Fs8AVU
        bGxB0Ee7ECoB9OhQ4l5OIunRwdeHKxx6nB/qT4g5FLI7otEjO5L9abuNh7OK+24+/QZYlKomIOt
        LU5eSMRawssK0SRnq
X-Received: by 2002:ac8:66d2:0:b0:3b9:bc8c:c1fd with SMTP id m18-20020ac866d2000000b003b9bc8cc1fdmr23796180qtp.8.1675876447054;
        Wed, 08 Feb 2023 09:14:07 -0800 (PST)
X-Google-Smtp-Source: AK7set+kBpHbset30IVGVWm+uVy7hojgOweG1o0bNthsrFOZXthE31mPmqeuihgSdlAZ4mU8dydcTA==
X-Received: by 2002:ac8:66d2:0:b0:3b9:bc8c:c1fd with SMTP id m18-20020ac866d2000000b003b9bc8cc1fdmr23796164qtp.8.1675876446804;
        Wed, 08 Feb 2023 09:14:06 -0800 (PST)
Received: from debian (2a01cb058918ce00464fe7234b8f6f47.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:464f:e723:4b8f:6f47])
        by smtp.gmail.com with ESMTPSA id dl12-20020a05620a1d0c00b0071323d3e37fsm11983947qkb.133.2023.02.08.09.14.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 09:14:06 -0800 (PST)
Date:   Wed, 8 Feb 2023 18:14:03 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Subject: [PATCH net 2/3] ipv6: Fix tcp socket connection with DSCP.
Message-ID: <f8b69f5aaa0049c2d9d162b1155beab535cdbf04.1675875519.git.gnault@redhat.com>
References: <cover.1675875519.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1675875519.git.gnault@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Take into account the IPV6_TCLASS socket option (DSCP) in
tcp_v6_connect(). Otherwise fib6_rule_match() can't properly
match the DSCP value, resulting in invalid route lookup.

For example:

  ip route add unreachable table main 2001:db8::10/124

  ip route add table 100 2001:db8::10/124 dev eth0
  ip -6 rule add dsfield 0x04 table 100

  echo test | socat - TCP6:[2001:db8::11]:54321,ipv6-tclass=0x04

Without this patch, socat fails at connect() time ("No route to host")
because the fib-rule doesn't jump to table 100 and the lookup ends up
being done in the main table.

Fixes: 2cc67cc731d9 ("[IPV6] ROUTE: Routing by Traffic Class.")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 net/ipv6/tcp_ipv6.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 11b736a76bd7..0d25e813288d 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -272,6 +272,7 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 	fl6.flowi6_proto = IPPROTO_TCP;
 	fl6.daddr = sk->sk_v6_daddr;
 	fl6.saddr = saddr ? *saddr : np->saddr;
+	fl6.flowlabel = ip6_make_flowinfo(np->tclass, np->flow_label);
 	fl6.flowi6_oif = sk->sk_bound_dev_if;
 	fl6.flowi6_mark = sk->sk_mark;
 	fl6.fl6_dport = usin->sin6_port;
-- 
2.30.2

