Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77523451D8D
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 01:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345761AbhKPAbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 19:31:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345785AbhKOT3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 14:29:21 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0284C0BC9A5
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 11:03:07 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id np3so13656370pjb.4
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 11:03:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=n+6AYEM1krZbe6qqssF9bDseXCWrufJeh1nSPzlF2gg=;
        b=DfUL4CQ6pB2RcYtPNoXnrmxc6QXlULTjMlUEnv2HFWSiHw7YYKfPjHe1wuVnp5PgTw
         WktWMJbIgidYmz/rbH19GGp4JKAq1UTPrtPv6a8XAMS8S5n7L9ce8cAm8cVzv40zAToM
         QcRM0SwpmC8GrFgLu7quUnBEqA+T6b9cefGyQrFrfeFgvSVk2BQ8IZSrXIZKm4wzBrfs
         NzF9370ZgyLcvFxiMGriN8jOHNtjfbmtwD+jm95DRk/5NYwtsT2KpR4EHUOfGfDmo0SM
         junu3JrHnrmS87M1tie4qKTo45Av1pZgBnanQfX6nom8kjUJZfW2oCZCL4E8+gKdDreE
         f51A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n+6AYEM1krZbe6qqssF9bDseXCWrufJeh1nSPzlF2gg=;
        b=1XKD3jRuoAVR6wO4pSqENm/Ci8gD4BHMyaAsenp0TTgOiVAfKoKxU6xUpobi+Yg1tI
         HquCqbfgGXLtHxuTHjTKk5gB4I9RshDiJmRfHVOjIW53pgSMLN8z/NUVITjDHuo79ZN8
         sttptc6i8hwbFi3d66qjfUEDKrcSqREMoUJmvUpnL9aLs0ept3llPFh8LU0USf81wi2C
         Q7aKZF7Vwmda5xvZ+f/TgjvtbjYlxgOPfBoC5x4XKUUr5r7Vko9xh33rPGXy9R2gur8K
         8DWxVBl9Xxel6ew+xr0I57ln4i7YoWCjKDmLTEd+5QwnSwlyOreQyaPSvnhUk60oTPgn
         kJuQ==
X-Gm-Message-State: AOAM531tqP+euWUD7bOW4QXkqoRIXIMxZFQBFInKl820cWJoF9vIAYaI
        rAaZSWkzMlXL7KTWG9QsA1Q=
X-Google-Smtp-Source: ABdhPJwFxrIFV1VJUpqK7HBXI8FJLGENkNBV6Y5vvs9q5tEVRDdkA5ni6iM/cKK24zqM4kvdy5TJeQ==
X-Received: by 2002:a17:902:e353:b0:142:d33:9acd with SMTP id p19-20020a170902e35300b001420d339acdmr38468446plc.78.1637002987251;
        Mon, 15 Nov 2021 11:03:07 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4994:f3d6:2eb1:61cb])
        by smtp.gmail.com with ESMTPSA id f21sm11850834pfe.69.2021.11.15.11.03.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 11:03:06 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Arjun Roy <arjunroy@google.com>
Subject: [PATCH net-next 05/20] net: remove sk_route_forced_caps
Date:   Mon, 15 Nov 2021 11:02:34 -0800
Message-Id: <20211115190249.3936899-6-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
In-Reply-To: <20211115190249.3936899-1-eric.dumazet@gmail.com>
References: <20211115190249.3936899-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

We were only using one bit, and we can replace it by sk_is_tcp()

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/sock.h | 3 ---
 net/core/sock.c    | 4 +++-
 net/ipv4/tcp.c     | 1 -
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 5bdeffdea5ecdb6069d13906bbf872d4479a1ce7..ebad629dd9eda4bcec6f621cf2d4f783f293b7b7 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -285,8 +285,6 @@ struct bpf_local_storage;
   *	@sk_no_check_rx: allow zero checksum in RX packets
   *	@sk_route_caps: route capabilities (e.g. %NETIF_F_TSO)
   *	@sk_route_nocaps: forbidden route capabilities (e.g NETIF_F_GSO_MASK)
-  *	@sk_route_forced_caps: static, forced route capabilities
-  *		(set in tcp_init_sock())
   *	@sk_gso_type: GSO type (e.g. %SKB_GSO_TCPV4)
   *	@sk_gso_max_size: Maximum GSO segment size to build
   *	@sk_gso_max_segs: Maximum number of GSO segments
@@ -461,7 +459,6 @@ struct sock {
 	struct page_frag	sk_frag;
 	netdev_features_t	sk_route_caps;
 	netdev_features_t	sk_route_nocaps;
-	netdev_features_t	sk_route_forced_caps;
 	int			sk_gso_type;
 	unsigned int		sk_gso_max_size;
 	gfp_t			sk_allocation;
diff --git a/net/core/sock.c b/net/core/sock.c
index 0be8e43f44b9e68678f4e20c3a86324ba1bfe03e..257b5fa604804ea671c0dbede4455ade8d65ede8 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2244,7 +2244,9 @@ void sk_setup_caps(struct sock *sk, struct dst_entry *dst)
 	u32 max_segs = 1;
 
 	sk_dst_set(sk, dst);
-	sk->sk_route_caps = dst->dev->features | sk->sk_route_forced_caps;
+	sk->sk_route_caps = dst->dev->features;
+	if (sk_is_tcp(sk))
+		sk->sk_route_caps |= NETIF_F_GSO;
 	if (sk->sk_route_caps & NETIF_F_GSO)
 		sk->sk_route_caps |= NETIF_F_GSO_SOFTWARE;
 	sk->sk_route_caps &= ~sk->sk_route_nocaps;
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index b7796b4cf0a099e9f14b28e50cb07367021a7cbf..4fa4b29260bd4c08da70b3fb199e3459013114f3 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -456,7 +456,6 @@ void tcp_init_sock(struct sock *sk)
 	WRITE_ONCE(sk->sk_rcvbuf, sock_net(sk)->ipv4.sysctl_tcp_rmem[1]);
 
 	sk_sockets_allocated_inc(sk);
-	sk->sk_route_forced_caps = NETIF_F_GSO;
 }
 EXPORT_SYMBOL(tcp_init_sock);
 
-- 
2.34.0.rc1.387.gb447b232ab-goog

