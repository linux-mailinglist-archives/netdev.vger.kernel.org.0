Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9AE5443D6
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 08:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238687AbiFIGe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 02:34:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238404AbiFIGeY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 02:34:24 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA6B8326EE
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 23:34:22 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id h1so19489408plf.11
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 23:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gDZCiATz4+88NA7QeL5ZEdLf1h8/4cV4veaCgP5CCF0=;
        b=FPckFk8k0LL06aVygqxmc0roO1XGokTuRUu7YWenlPNaDs8ZwT3x70eivmN2YDBujP
         J2IhNWlj6T5ilZf+spbpkXztc6iws+5g5Rdgi0JVwJBFz9znP62lojexlQxmsikR6lsT
         A6KUjivlgbkfAMi6eM2yawsW39WhMJSwF1EbtXBM9zTy1k4mF818EZaJB+Icm0YxnNEj
         TM69FebxlVGDrhmxclBGc7vxLsl1VJ6OjjRc1UtihkPUYHIU7KNifxu1eeVr8hYmc6+n
         QUy4aHBijhyA/iKi3QrLVjYsTg8ACRYLS1zI+ZDNcq7bQLyd4sXoBPcTUNhubBmcTBAT
         uTgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gDZCiATz4+88NA7QeL5ZEdLf1h8/4cV4veaCgP5CCF0=;
        b=FHjBOfWJuE6W030E9gUBzNKM7p6QlJAPt1O6yDh4H6R6bn8XduqlLtHh63E9ay6ToO
         D9trGyo3Nh1Dqtv1nQPAHT664/lwqcWnbsEfsHWCCIUTQyc7k1znjaYaxz7RSryqSTdr
         qsks2i1K3ArTIs7TaZ3OsUcETnog609QprRnJD/GwUnlUmLeXYKOfUs0+ZvY1k7zdQ6g
         Jr2h5sUdV8gPEXzcXoSiyQmV3vpNjmtivmAz8hyhGMq4Jh3X4lSGNFESwsOzKq2P/xr+
         1//tVig/2Je1N3yxb4x2872GOjrKtjlASwsfTGp5p75mfDFCs9rd3OC9NmdNGyOv9Rj6
         PhDg==
X-Gm-Message-State: AOAM530y5kk1jK2AuQt9ML3G5a9+zMViWx7qHfQE+zqY1TzKSW7sw1aj
        MfGBMAEtxwLbQJyO9XbcK5A=
X-Google-Smtp-Source: ABdhPJyUBVE10o4y7h/V6mVF+OIGgN9M/uF5UQD5kvX1uUtzpYqOBDP8oY52knezhrH/ATU7uhSq9w==
X-Received: by 2002:a17:902:d551:b0:168:93b6:a94a with SMTP id z17-20020a170902d55100b0016893b6a94amr7410806plf.149.1654756462367;
        Wed, 08 Jun 2022 23:34:22 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:f579:a14f:f943:9d9a])
        by smtp.gmail.com with ESMTPSA id 199-20020a6215d0000000b0051b9c0af43dsm16340050pfv.155.2022.06.08.23.34.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 23:34:22 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Wei Wang <weiwan@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 3/7] net: add per_cpu_fw_alloc field to struct proto
Date:   Wed,  8 Jun 2022 23:34:08 -0700
Message-Id: <20220609063412.2205738-4-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
In-Reply-To: <20220609063412.2205738-1-eric.dumazet@gmail.com>
References: <20220609063412.2205738-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Each protocol having a ->memory_allocated pointer gets a corresponding
per-cpu reserve, that following patches will use.

Instead of having reserved bytes per socket,
we want to have per-cpu reserves.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/sock.h     | 1 +
 include/net/tcp.h      | 2 ++
 include/net/udp.h      | 1 +
 net/core/sock.c        | 4 ++++
 net/decnet/af_decnet.c | 4 ++++
 net/ipv4/tcp.c         | 2 ++
 net/ipv4/tcp_ipv4.c    | 3 +++
 net/ipv4/udp.c         | 4 ++++
 net/ipv4/udplite.c     | 3 +++
 net/ipv6/tcp_ipv6.c    | 3 +++
 net/ipv6/udp.c         | 3 +++
 net/ipv6/udplite.c     | 3 +++
 net/mptcp/protocol.c   | 3 +++
 net/sctp/socket.c      | 7 +++++++
 14 files changed, 43 insertions(+)

diff --git a/include/net/sock.h b/include/net/sock.h
index 298897bbfb3a3ea6ba88f76bc486ae636e2b1cfd..825f8cbf791f02d798f17dd4f7a2659cebb0e98a 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1254,6 +1254,7 @@ struct proto {
 	void			(*enter_memory_pressure)(struct sock *sk);
 	void			(*leave_memory_pressure)(struct sock *sk);
 	atomic_long_t		*memory_allocated;	/* Current allocated memory. */
+	int  __percpu		*per_cpu_fw_alloc;
 	struct percpu_counter	*sockets_allocated;	/* Current number of sockets. */
 
 	/*
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 1e99f5c61f8499c121a9fc50643db559a6021a38..4794cae4577e4c64ce2664ed734ae90bbc531782 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -253,6 +253,8 @@ extern long sysctl_tcp_mem[3];
 #define TCP_RACK_NO_DUPTHRESH    0x4 /* Do not use DUPACK threshold in RACK */
 
 extern atomic_long_t tcp_memory_allocated;
+DECLARE_PER_CPU(int, tcp_memory_per_cpu_fw_alloc);
+
 extern struct percpu_counter tcp_sockets_allocated;
 extern unsigned long tcp_memory_pressure;
 
diff --git a/include/net/udp.h b/include/net/udp.h
index b83a003305667d1c1cd1bac00580fec9164958b0..b60eea2e3fae2f3f2d2acfdffdb7f442bcef4478 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -95,6 +95,7 @@ static inline struct udp_hslot *udp_hashslot2(struct udp_table *table,
 extern struct proto udp_prot;
 
 extern atomic_long_t udp_memory_allocated;
+DECLARE_PER_CPU(int, udp_memory_per_cpu_fw_alloc);
 
 /* sysctl variables for udp */
 extern long sysctl_udp_mem[3];
diff --git a/net/core/sock.c b/net/core/sock.c
index 6b786e836c7f5fc74307f050d4f32b4b554eb53b..3bb406167da93b7526ff85787b89fa65e44dce8b 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3798,6 +3798,10 @@ int proto_register(struct proto *prot, int alloc_slab)
 		pr_err("%s: missing sysctl_mem\n", prot->name);
 		return -EINVAL;
 	}
+	if (prot->memory_allocated && !prot->per_cpu_fw_alloc) {
+		pr_err("%s: missing per_cpu_fw_alloc\n", prot->name);
+		return -EINVAL;
+	}
 	if (alloc_slab) {
 		prot->slab = kmem_cache_create_usercopy(prot->name,
 					prot->obj_size, 0,
diff --git a/net/decnet/af_decnet.c b/net/decnet/af_decnet.c
index dc92a67baea39484cd4c93913d3eae8ac4463538..aa4f43f52499b55309784de0a2b5a3e434e9a19c 100644
--- a/net/decnet/af_decnet.c
+++ b/net/decnet/af_decnet.c
@@ -149,6 +149,7 @@ static DEFINE_RWLOCK(dn_hash_lock);
 static struct hlist_head dn_sk_hash[DN_SK_HASH_SIZE];
 static struct hlist_head dn_wild_sk;
 static atomic_long_t decnet_memory_allocated;
+static DEFINE_PER_CPU(int, decnet_memory_per_cpu_fw_alloc);
 
 static int __dn_setsockopt(struct socket *sock, int level, int optname,
 		sockptr_t optval, unsigned int optlen, int flags);
@@ -454,7 +455,10 @@ static struct proto dn_proto = {
 	.owner			= THIS_MODULE,
 	.enter_memory_pressure	= dn_enter_memory_pressure,
 	.memory_pressure	= &dn_memory_pressure,
+
 	.memory_allocated	= &decnet_memory_allocated,
+	.per_cpu_fw_alloc	= &decnet_memory_per_cpu_fw_alloc,
+
 	.sysctl_mem		= sysctl_decnet_mem,
 	.sysctl_wmem		= sysctl_decnet_wmem,
 	.sysctl_rmem		= sysctl_decnet_rmem,
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 9e696758a4c213f22919483dcd6740b10ee3294b..e6bdf8e2c09a156c45eae9490419b93b35f6e191 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -294,6 +294,8 @@ EXPORT_SYMBOL(sysctl_tcp_mem);
 
 atomic_long_t tcp_memory_allocated ____cacheline_aligned_in_smp;	/* Current allocated memory. */
 EXPORT_SYMBOL(tcp_memory_allocated);
+DEFINE_PER_CPU(int, tcp_memory_per_cpu_fw_alloc);
+EXPORT_PER_CPU_SYMBOL_GPL(tcp_memory_per_cpu_fw_alloc);
 
 #if IS_ENABLED(CONFIG_SMC)
 DEFINE_STATIC_KEY_FALSE(tcp_have_smc);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index fe8f23b95d32ca4a35d05166d471327bc608fa91..fda811a5251f2d76ac24a036e6b4f4e7d7d96d6f 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -3045,7 +3045,10 @@ struct proto tcp_prot = {
 	.stream_memory_free	= tcp_stream_memory_free,
 	.sockets_allocated	= &tcp_sockets_allocated,
 	.orphan_count		= &tcp_orphan_count,
+
 	.memory_allocated	= &tcp_memory_allocated,
+	.per_cpu_fw_alloc	= &tcp_memory_per_cpu_fw_alloc,
+
 	.memory_pressure	= &tcp_memory_pressure,
 	.sysctl_mem		= sysctl_tcp_mem,
 	.sysctl_wmem_offset	= offsetof(struct net, ipv4.sysctl_tcp_wmem),
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index bbc9970fa2e947ce8fdd08763033b6b5912af042..6172b4750a888bf792650a59f8ce0cd97d781fad 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -125,6 +125,8 @@ EXPORT_SYMBOL(sysctl_udp_mem);
 
 atomic_long_t udp_memory_allocated ____cacheline_aligned_in_smp;
 EXPORT_SYMBOL(udp_memory_allocated);
+DEFINE_PER_CPU(int, udp_memory_per_cpu_fw_alloc);
+EXPORT_PER_CPU_SYMBOL_GPL(udp_memory_per_cpu_fw_alloc);
 
 #define MAX_UDP_PORTS 65536
 #define PORTS_PER_CHAIN (MAX_UDP_PORTS / UDP_HTABLE_SIZE_MIN)
@@ -2946,6 +2948,8 @@ struct proto udp_prot = {
 	.psock_update_sk_prot	= udp_bpf_update_proto,
 #endif
 	.memory_allocated	= &udp_memory_allocated,
+	.per_cpu_fw_alloc	= &udp_memory_per_cpu_fw_alloc,
+
 	.sysctl_mem		= sysctl_udp_mem,
 	.sysctl_wmem_offset	= offsetof(struct net, ipv4.sysctl_udp_wmem_min),
 	.sysctl_rmem_offset	= offsetof(struct net, ipv4.sysctl_udp_rmem_min),
diff --git a/net/ipv4/udplite.c b/net/ipv4/udplite.c
index cd1cd68adeec88e4cfcc75c3f32b6243229df670..6e08a76ae1e7e13905fa13ea12e075b94308a8ff 100644
--- a/net/ipv4/udplite.c
+++ b/net/ipv4/udplite.c
@@ -51,7 +51,10 @@ struct proto 	udplite_prot = {
 	.unhash		   = udp_lib_unhash,
 	.rehash		   = udp_v4_rehash,
 	.get_port	   = udp_v4_get_port,
+
 	.memory_allocated  = &udp_memory_allocated,
+	.per_cpu_fw_alloc  = &udp_memory_per_cpu_fw_alloc,
+
 	.sysctl_mem	   = sysctl_udp_mem,
 	.obj_size	   = sizeof(struct udp_sock),
 	.h.udp_table	   = &udplite_table,
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index f37dd4aa91c6bae1df92a1e4edca362c50cd97b9..c72448ba6dc9c9e8762f2ff84e55fd5d50987c49 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -2159,7 +2159,10 @@ struct proto tcpv6_prot = {
 	.leave_memory_pressure	= tcp_leave_memory_pressure,
 	.stream_memory_free	= tcp_stream_memory_free,
 	.sockets_allocated	= &tcp_sockets_allocated,
+
 	.memory_allocated	= &tcp_memory_allocated,
+	.per_cpu_fw_alloc	= &tcp_memory_per_cpu_fw_alloc,
+
 	.memory_pressure	= &tcp_memory_pressure,
 	.orphan_count		= &tcp_orphan_count,
 	.sysctl_mem		= sysctl_tcp_mem,
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 55afd7f39c0450ff442a0499b7f8e42bf1a613bc..be074f07073a532d47b83497a2b6808f4271d43e 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1740,7 +1740,10 @@ struct proto udpv6_prot = {
 #ifdef CONFIG_BPF_SYSCALL
 	.psock_update_sk_prot	= udp_bpf_update_proto,
 #endif
+
 	.memory_allocated	= &udp_memory_allocated,
+	.per_cpu_fw_alloc	= &udp_memory_per_cpu_fw_alloc,
+
 	.sysctl_mem		= sysctl_udp_mem,
 	.sysctl_wmem_offset     = offsetof(struct net, ipv4.sysctl_udp_wmem_min),
 	.sysctl_rmem_offset     = offsetof(struct net, ipv4.sysctl_udp_rmem_min),
diff --git a/net/ipv6/udplite.c b/net/ipv6/udplite.c
index fbb700d3f437ee73824b369486010e152a659abb..b707258562597ebddf5e0d75e6415b6f967cca33 100644
--- a/net/ipv6/udplite.c
+++ b/net/ipv6/udplite.c
@@ -48,7 +48,10 @@ struct proto udplitev6_prot = {
 	.unhash		   = udp_lib_unhash,
 	.rehash		   = udp_v6_rehash,
 	.get_port	   = udp_v6_get_port,
+
 	.memory_allocated  = &udp_memory_allocated,
+	.per_cpu_fw_alloc  = &udp_memory_per_cpu_fw_alloc,
+
 	.sysctl_mem	   = sysctl_udp_mem,
 	.obj_size	   = sizeof(struct udp6_sock),
 	.h.udp_table	   = &udplite_table,
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 080a630d6902caa2022fda1c6b3edb65e4e74a8c..9563124ac8af9f9f45b16f23d5d77f17dd83d0c5 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3437,7 +3437,10 @@ static struct proto mptcp_prot = {
 	.get_port	= mptcp_get_port,
 	.forward_alloc_get	= mptcp_forward_alloc_get,
 	.sockets_allocated	= &mptcp_sockets_allocated,
+
 	.memory_allocated	= &tcp_memory_allocated,
+	.per_cpu_fw_alloc	= &tcp_memory_per_cpu_fw_alloc,
+
 	.memory_pressure	= &tcp_memory_pressure,
 	.sysctl_wmem_offset	= offsetof(struct net, ipv4.sysctl_tcp_wmem),
 	.sysctl_rmem_offset	= offsetof(struct net, ipv4.sysctl_tcp_rmem),
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 6d37d2dfb3da87fd509c21121d743f44bf6ee00c..05174acd981a8c304300b7a39b366d758d6fbafa 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -93,6 +93,7 @@ static int sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,
 
 static unsigned long sctp_memory_pressure;
 static atomic_long_t sctp_memory_allocated;
+static DEFINE_PER_CPU(int, sctp_memory_per_cpu_fw_alloc);
 struct percpu_counter sctp_sockets_allocated;
 
 static void sctp_enter_memory_pressure(struct sock *sk)
@@ -9657,7 +9658,10 @@ struct proto sctp_prot = {
 	.sysctl_wmem =  sysctl_sctp_wmem,
 	.memory_pressure = &sctp_memory_pressure,
 	.enter_memory_pressure = sctp_enter_memory_pressure,
+
 	.memory_allocated = &sctp_memory_allocated,
+	.per_cpu_fw_alloc = &sctp_memory_per_cpu_fw_alloc,
+
 	.sockets_allocated = &sctp_sockets_allocated,
 };
 
@@ -9700,7 +9704,10 @@ struct proto sctpv6_prot = {
 	.sysctl_wmem	= sysctl_sctp_wmem,
 	.memory_pressure = &sctp_memory_pressure,
 	.enter_memory_pressure = sctp_enter_memory_pressure,
+
 	.memory_allocated = &sctp_memory_allocated,
+	.per_cpu_fw_alloc = &sctp_memory_per_cpu_fw_alloc,
+
 	.sockets_allocated = &sctp_sockets_allocated,
 };
 #endif /* IS_ENABLED(CONFIG_IPV6) */
-- 
2.36.1.255.ge46751e96f-goog

