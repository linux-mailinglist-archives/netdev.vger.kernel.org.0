Return-Path: <netdev+bounces-6642-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 31E367172A7
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 02:38:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D7EED28141B
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 00:38:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 378B2A4C;
	Wed, 31 May 2023 00:36:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D7D184C
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 00:36:07 +0000 (UTC)
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F69319A
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 17:35:37 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-64d5b4c3ffeso3765456b3a.2
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 17:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1685493317; x=1688085317;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n13sK70ntf9lmsIk7TA5LIhrsOX2zMixR6tdDTqVnfI=;
        b=GGa6NhUxFPSkiOUWito71znmu//gL3kL8ORXvHp8USRfWMwCexnsjTgGJIN9YC8Qtm
         Ct/uSkfzCQXbD2FvCSzucXSYMkbeYZNbrErhOC0K85Mt1pYfzgvu8P0/57mh9ERjGz7P
         pCoCV0WUeQd6mZUE4TxexoYNNauDXsmFDinxEabVf+smoSrKZ+ovXq7wabqZtrSBxMv2
         3NbFDW7nxjGWs4GyofIHMA5LbLsgib+HUKCqGftiUzHF/RCEVjRMNkAqclqV5+PsObDR
         /Q6lAYWmPKJlz/czyMLEaBcQ/2+63572/yiOXedI8KSVOQx3eueh6WVMPCZuCUpgMTqc
         12TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685493317; x=1688085317;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n13sK70ntf9lmsIk7TA5LIhrsOX2zMixR6tdDTqVnfI=;
        b=eNLuWmybw+aQyEXGyD79U9lXU/v0r6OaOF2088zm0QyQAUu9NkX5eh9O32+8VW/ibe
         dF+R4+ucbJpLw4gcmpC7TgpXwsQNNFu4QoMCTtlknT2KKBf6X8GI2LVvRrbb9XmAJHca
         /kIBPsVYgwYY9RcejXm1IjxCcYNHLBS3XwGpnaM9y4dlh4AUan3iBTB1QkJkzRbdesfx
         frgrqfcOo2JuybALPu+B8z4FPNe6ErHjuR6/3FE1dBdWAVeNPr+qIk2i8BxVSqdfZH2S
         m3G3ayezD7/r8CPlye+MiEZBqeXOfllR1M8/oDosp3f5EBbWI47GbPiOPVjihsnZT8LG
         T9oQ==
X-Gm-Message-State: AC+VfDz4rZtMARwimy5HCCIn15+/YX8yIh+Ig63GpcjIj00+ivKOn80D
	wVbVmxhT+BdTv1RLeHd6OrgeyeLwG0ucQBi87b8s/g==
X-Google-Smtp-Source: ACHHUZ7yBqpLlJYxHExESv2T9834Ba8BVZoJbnwk9DOein9dgvHBbM0Oz8xkrbwUWQt4jx6NMThoyA==
X-Received: by 2002:a05:6a00:896:b0:650:154:8ac with SMTP id q22-20020a056a00089600b00650015408acmr3689531pfj.3.1685493316721;
        Tue, 30 May 2023 17:35:16 -0700 (PDT)
Received: from [172.17.0.2] (c-67-170-131-147.hsd1.wa.comcast.net. [67.170.131.147])
        by smtp.gmail.com with ESMTPSA id j12-20020a62b60c000000b0064cb0845c77sm2151340pff.122.2023.05.30.17.35.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 17:35:16 -0700 (PDT)
From: Bobby Eshleman <bobby.eshleman@bytedance.com>
Date: Wed, 31 May 2023 00:35:11 +0000
Subject: [PATCH RFC net-next v3 7/8] vsock: Add lockless sendmsg() support
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230413-b4-vsock-dgram-v3-7-c2414413ef6a@bytedance.com>
References: <20230413-b4-vsock-dgram-v3-0-c2414413ef6a@bytedance.com>
In-Reply-To: <20230413-b4-vsock-dgram-v3-0-c2414413ef6a@bytedance.com>
To: Stefan Hajnoczi <stefanha@redhat.com>, 
 Stefano Garzarella <sgarzare@redhat.com>, 
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 "K. Y. Srinivasan" <kys@microsoft.com>, 
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
 Dexuan Cui <decui@microsoft.com>, Bryan Tan <bryantan@vmware.com>, 
 Vishnu Dasa <vdasa@vmware.com>, 
 VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, 
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-hyperv@vger.kernel.org, Bobby Eshleman <bobby.eshleman@bytedance.com>
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Because the dgram sendmsg() path for AF_VSOCK acquires the socket lock
it does not scale when many senders share a socket.

Prior to this patch the socket lock is used to protect both reads and
writes to the local_addr, remote_addr, transport, and buffer size
variables of a vsock socket. What follows are the new protection schemes
for these fields that ensure a race-free and usually lock-free
multi-sender sendmsg() path for vsock dgrams.

- local_addr
    local_addr changes as a result of binding a socket. The write path
    for local_addr is bind() and various vsock_auto_bind() call sites.
    After a socket has been bound via vsock_auto_bind() or bind(), subsequent
    calls to bind()/vsock_auto_bind() do not write to local_addr again. bind()
    rejects the user request and vsock_auto_bind() early exits.
    Therefore, the local addr can not change while a parallel thread is
    in sendmsg() and lock-free reads of local addr in sendmsg() are safe.
    Change: only acquire lock for auto-binding as-needed in sendmsg().

- buffer size variables
    Not used by dgram, so they do not need protection. No change.

- remote_addr and transport
    Because a remote_addr update may result in a changed transport, but we
    would like to be able to read these two fields lock-free but coherently
    in the vsock send path, this patch packages these two fields into a new
    struct vsock_remote_info that is referenced by an RCU-protected pointer.

    Writes are synchronized as usual by the socket lock. Reads only take
    place in RCU read-side critical sections. When remote_addr or transport
    is updated, a new remote info is allocated. Old readers still see the
    old coherent remote_addr/transport pair, and new readers will refer to
    the new coherent. The coherency between remote_addr and transport
    previously provided by the socket lock alone is now also preserved by
    RCU, except with the highly-scalable lock-free read-side.

Helpers are introduced for accessing and updating the new pointer.

The new structure is contains an rcu_head so that kfree_rcu() can be
used. This removes the need of writers to use synchronize_rcu() after
freeing old structures which is simply more efficient and reduces code
churn where remote_addr/transport are already being updated inside RCU
read-side sections.

Only virtio has been tested, but updates were necessary to the VMCI and
hyperv code. Unfortunately the author does not have access to
VMCI/hyperv systems so those changes are untested.

Perf Tests (results from patch v2)
vCPUS: 16
Threads: 16
Payload: 4KB
Test Runs: 5
Type: SOCK_DGRAM

Before: 245.2 MB/s
After: 509.2 MB/s (+107%)

Notably, on the same test system, vsock dgram even outperforms
multi-threaded UDP over virtio-net with vhost and MQ support enabled.

Throughput metrics for single-threaded SOCK_DGRAM and
single/multi-threaded SOCK_STREAM showed no statistically signficant
throughput changes (lowest p-value reaching 0.27), with the range of the
mean difference ranging between -5% to +1%.

Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
---
 drivers/vhost/vsock.c                   |  12 +-
 include/linux/virtio_vsock.h            |   3 +-
 include/net/af_vsock.h                  |  39 ++-
 net/vmw_vsock/af_vsock.c                | 451 +++++++++++++++++++++++++-------
 net/vmw_vsock/diag.c                    |  10 +-
 net/vmw_vsock/hyperv_transport.c        |  27 +-
 net/vmw_vsock/virtio_transport_common.c |  32 ++-
 net/vmw_vsock/vmci_transport.c          |  84 ++++--
 net/vmw_vsock/vsock_bpf.c               |  10 +-
 9 files changed, 518 insertions(+), 150 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 159c1a22c1a8..b027a780d333 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -297,13 +297,17 @@ static int
 vhost_transport_cancel_pkt(struct vsock_sock *vsk)
 {
 	struct vhost_vsock *vsock;
+	unsigned int cid;
 	int cnt = 0;
 	int ret = -ENODEV;
 
 	rcu_read_lock();
+	ret = vsock_remote_addr_cid(vsk, &cid);
+	if (ret < 0)
+		goto out;
 
 	/* Find the vhost_vsock according to guest context id  */
-	vsock = vhost_vsock_get(vsk->remote_addr.svm_cid);
+	vsock = vhost_vsock_get(cid);
 	if (!vsock)
 		goto out;
 
@@ -706,6 +710,10 @@ static void vhost_vsock_flush(struct vhost_vsock *vsock)
 static void vhost_vsock_reset_orphans(struct sock *sk)
 {
 	struct vsock_sock *vsk = vsock_sk(sk);
+	unsigned int cid;
+
+	if (vsock_remote_addr_cid(vsk, &cid) < 0)
+		return;
 
 	/* vmci_transport.c doesn't take sk_lock here either.  At least we're
 	 * under vsock_table_lock so the sock cannot disappear while we're
@@ -713,7 +721,7 @@ static void vhost_vsock_reset_orphans(struct sock *sk)
 	 */
 
 	/* If the peer is still valid, no need to reset connection */
-	if (vhost_vsock_get(vsk->remote_addr.svm_cid))
+	if (vhost_vsock_get(cid))
 		return;
 
 	/* If the close timeout is pending, let it expire.  This avoids races
diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index 237ca87a2ecd..97656e83606f 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -231,7 +231,8 @@ virtio_transport_stream_enqueue(struct vsock_sock *vsk,
 				struct msghdr *msg,
 				size_t len);
 int
-virtio_transport_dgram_enqueue(struct vsock_sock *vsk,
+virtio_transport_dgram_enqueue(const struct vsock_transport *transport,
+			       struct vsock_sock *vsk,
 			       struct sockaddr_vm *remote_addr,
 			       struct msghdr *msg,
 			       size_t len);
diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index c115e655b4f5..84f2a9700ebd 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -25,12 +25,17 @@ extern spinlock_t vsock_table_lock;
 #define vsock_sk(__sk)    ((struct vsock_sock *)__sk)
 #define sk_vsock(__vsk)   (&(__vsk)->sk)
 
+struct vsock_remote_info {
+	struct sockaddr_vm addr;
+	struct rcu_head rcu;
+	const struct vsock_transport *transport;
+};
+
 struct vsock_sock {
 	/* sk must be the first member. */
 	struct sock sk;
-	const struct vsock_transport *transport;
 	struct sockaddr_vm local_addr;
-	struct sockaddr_vm remote_addr;
+	struct vsock_remote_info * __rcu remote_info;
 	/* Links for the global tables of bound and connected sockets. */
 	struct list_head bound_table;
 	struct list_head connected_table;
@@ -120,8 +125,8 @@ struct vsock_transport {
 
 	/* DGRAM. */
 	int (*dgram_bind)(struct vsock_sock *, struct sockaddr_vm *);
-	int (*dgram_enqueue)(struct vsock_sock *, struct sockaddr_vm *,
-			     struct msghdr *, size_t len);
+	int (*dgram_enqueue)(const struct vsock_transport *, struct vsock_sock *,
+			     struct sockaddr_vm *, struct msghdr *, size_t len);
 	bool (*dgram_allow)(u32 cid, u32 port);
 	int (*dgram_get_cid)(struct sk_buff *skb, unsigned int *cid);
 	int (*dgram_get_port)(struct sk_buff *skb, unsigned int *port);
@@ -196,6 +201,17 @@ void vsock_core_unregister(const struct vsock_transport *t);
 /* The transport may downcast this to access transport-specific functions */
 const struct vsock_transport *vsock_core_get_transport(struct vsock_sock *vsk);
 
+static inline struct vsock_remote_info *
+vsock_core_get_remote_info(struct vsock_sock *vsk)
+{
+
+	/* vsk->remote_info may be accessed if the rcu read lock is held OR the
+	 * socket lock is held
+	 */
+	return rcu_dereference_check(vsk->remote_info,
+				     lockdep_sock_is_held(sk_vsock(vsk)));
+}
+
 /**** UTILS ****/
 
 /* vsock_table_lock must be held */
@@ -214,7 +230,7 @@ void vsock_release_pending(struct sock *pending);
 void vsock_add_pending(struct sock *listener, struct sock *pending);
 void vsock_remove_pending(struct sock *listener, struct sock *pending);
 void vsock_enqueue_accept(struct sock *listener, struct sock *connected);
-void vsock_insert_connected(struct vsock_sock *vsk);
+int vsock_insert_connected(struct vsock_sock *vsk);
 void vsock_remove_bound(struct vsock_sock *vsk);
 void vsock_remove_connected(struct vsock_sock *vsk);
 struct sock *vsock_find_bound_socket(struct sockaddr_vm *addr);
@@ -223,7 +239,8 @@ struct sock *vsock_find_connected_socket(struct sockaddr_vm *src,
 void vsock_remove_sock(struct vsock_sock *vsk);
 void vsock_for_each_connected_socket(struct vsock_transport *transport,
 				     void (*fn)(struct sock *sk));
-int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk);
+int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk,
+			   struct sockaddr_vm *remote_addr);
 bool vsock_find_cid(unsigned int cid);
 struct sock *vsock_find_bound_dgram_socket(struct sockaddr_vm *addr);
 
@@ -253,4 +270,14 @@ static inline void __init vsock_bpf_build_proto(void)
 {}
 #endif
 
+/* RCU-protected remote addr helpers */
+int vsock_remote_addr_cid(struct vsock_sock *vsk, unsigned int *cid);
+int vsock_remote_addr_port(struct vsock_sock *vsk, unsigned int *port);
+int vsock_remote_addr_cid_port(struct vsock_sock *vsk, unsigned int *cid,
+			       unsigned int *port);
+int vsock_remote_addr_copy(struct vsock_sock *vsk, struct sockaddr_vm *dest);
+bool vsock_remote_addr_bound(struct vsock_sock *vsk);
+bool vsock_remote_addr_equals(struct vsock_sock *vsk, struct sockaddr_vm *other);
+int vsock_remote_addr_update_cid_port(struct vsock_sock *vsk, u32 cid, u32 port);
+
 #endif /* __AF_VSOCK_H__ */
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index e8c70069d77d..0520228d2a68 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -114,6 +114,8 @@
 static int __vsock_bind(struct sock *sk, struct sockaddr_vm *addr);
 static void vsock_sk_destruct(struct sock *sk);
 static int vsock_queue_rcv_skb(struct sock *sk, struct sk_buff *skb);
+static bool vsock_use_local_transport(unsigned int remote_cid);
+static bool sock_type_connectible(u16 type);
 
 /* Protocol family. */
 struct proto vsock_proto = {
@@ -145,6 +147,147 @@ static const struct vsock_transport *transport_local;
 static DEFINE_MUTEX(vsock_register_mutex);
 
 /**** UTILS ****/
+bool vsock_remote_addr_bound(struct vsock_sock *vsk)
+{
+	struct vsock_remote_info *remote_info;
+	bool ret;
+
+	rcu_read_lock();
+	remote_info = vsock_core_get_remote_info(vsk);
+	if (!remote_info) {
+		rcu_read_unlock();
+		return false;
+	}
+
+	ret = vsock_addr_bound(&remote_info->addr);
+	rcu_read_unlock();
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(vsock_remote_addr_bound);
+
+int vsock_remote_addr_copy(struct vsock_sock *vsk, struct sockaddr_vm *dest)
+{
+	struct vsock_remote_info *remote_info;
+
+	rcu_read_lock();
+	remote_info = vsock_core_get_remote_info(vsk);
+	if (!remote_info) {
+		rcu_read_unlock();
+		return -EINVAL;
+	}
+	memcpy(dest, &remote_info->addr, sizeof(*dest));
+	rcu_read_unlock();
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vsock_remote_addr_copy);
+
+int vsock_remote_addr_cid(struct vsock_sock *vsk, unsigned int *cid)
+{
+	return vsock_remote_addr_cid_port(vsk, cid, NULL);
+}
+EXPORT_SYMBOL_GPL(vsock_remote_addr_cid);
+
+int vsock_remote_addr_port(struct vsock_sock *vsk, unsigned int *port)
+{
+	return vsock_remote_addr_cid_port(vsk, NULL, port);
+}
+EXPORT_SYMBOL_GPL(vsock_remote_addr_port);
+
+int vsock_remote_addr_cid_port(struct vsock_sock *vsk, unsigned int *cid,
+			       unsigned int *port)
+{
+	struct vsock_remote_info *remote_info;
+
+	rcu_read_lock();
+	remote_info = vsock_core_get_remote_info(vsk);
+	if (!remote_info) {
+		rcu_read_unlock();
+		return -EINVAL;
+	}
+
+	if (cid)
+		*cid = remote_info->addr.svm_cid;
+	if (port)
+		*port = remote_info->addr.svm_port;
+
+	rcu_read_unlock();
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vsock_remote_addr_cid_port);
+
+/* The socket lock must be held by the caller */
+int vsock_set_remote_info(struct vsock_sock *vsk,
+			  const struct vsock_transport *transport,
+			  struct sockaddr_vm *addr)
+{
+	struct vsock_remote_info *old, *new;
+
+	if (addr || transport) {
+		new = kmalloc(sizeof(*new), GFP_KERNEL);
+		if (!new)
+			return -ENOMEM;
+
+		if (addr)
+			memcpy(&new->addr, addr, sizeof(new->addr));
+
+		if (transport)
+			new->transport = transport;
+	} else {
+		new = NULL;
+	}
+
+	old = rcu_replace_pointer(vsk->remote_info, new, lockdep_sock_is_held(sk_vsock(vsk)));
+	kfree_rcu(old, rcu);
+
+	return 0;
+}
+
+static const struct vsock_transport *
+vsock_connectible_lookup_transport(unsigned int cid, __u8 flags)
+{
+	const struct vsock_transport *transport;
+
+	if (vsock_use_local_transport(cid))
+		transport = transport_local;
+	else if (cid <= VMADDR_CID_HOST || !transport_h2g ||
+		 (flags & VMADDR_FLAG_TO_HOST))
+		transport = transport_g2h;
+	else
+		transport = transport_h2g;
+
+	return transport;
+}
+
+static const struct vsock_transport *
+vsock_dgram_lookup_transport(unsigned int cid, __u8 flags)
+{
+	if (transport_dgram)
+		return transport_dgram;
+
+	return vsock_connectible_lookup_transport(cid, flags);
+}
+
+bool vsock_remote_addr_equals(struct vsock_sock *vsk,
+			      struct sockaddr_vm *other)
+{
+	struct vsock_remote_info *remote_info;
+	bool equals;
+
+	rcu_read_lock();
+	remote_info = vsock_core_get_remote_info(vsk);
+	if (!remote_info) {
+		rcu_read_unlock();
+		return false;
+	}
+
+	equals = vsock_addr_equals_addr(&remote_info->addr, other);
+	rcu_read_unlock();
+
+	return equals;
+}
+EXPORT_SYMBOL_GPL(vsock_remote_addr_equals);
 
 /* Each bound VSocket is stored in the bind hash table and each connected
  * VSocket is stored in the connected hash table.
@@ -284,10 +427,16 @@ static struct sock *__vsock_find_connected_socket(struct sockaddr_vm *src,
 
 	list_for_each_entry(vsk, vsock_connected_sockets(src, dst),
 			    connected_table) {
-		if (vsock_addr_equals_addr(src, &vsk->remote_addr) &&
+		struct vsock_remote_info *remote_info;
+
+		rcu_read_lock();
+		remote_info = vsock_core_get_remote_info(vsk);
+		if (vsock_addr_equals_addr(src, &remote_info->addr) &&
 		    dst->svm_port == vsk->local_addr.svm_port) {
+			rcu_read_unlock();
 			return sk_vsock(vsk);
 		}
+		rcu_read_unlock();
 	}
 
 	return NULL;
@@ -300,17 +449,36 @@ static void vsock_insert_unbound(struct vsock_sock *vsk)
 	spin_unlock_bh(&vsock_table_lock);
 }
 
-void vsock_insert_connected(struct vsock_sock *vsk)
+int vsock_insert_connected(struct vsock_sock *vsk)
 {
-	struct list_head *list = vsock_connected_sockets(
-		&vsk->remote_addr, &vsk->local_addr);
+	struct list_head *list;
+	struct vsock_remote_info *remote_info;
+
+	rcu_read_lock();
+	remote_info = vsock_core_get_remote_info(vsk);
+	if (!remote_info) {
+		rcu_read_unlock();
+		return -EINVAL;
+	}
+	list = vsock_connected_sockets(&remote_info->addr, &vsk->local_addr);
+	rcu_read_unlock();
 
 	spin_lock_bh(&vsock_table_lock);
 	__vsock_insert_connected(list, vsk);
 	spin_unlock_bh(&vsock_table_lock);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(vsock_insert_connected);
 
+void vsock_remove_dgram_bound(struct vsock_sock *vsk)
+{
+	spin_lock_bh(&vsock_dgram_table_lock);
+	if (__vsock_in_bound_table(vsk))
+		__vsock_remove_bound(vsk);
+	spin_unlock_bh(&vsock_dgram_table_lock);
+}
+
 void vsock_remove_bound(struct vsock_sock *vsk)
 {
 	spin_lock_bh(&vsock_table_lock);
@@ -362,7 +530,10 @@ EXPORT_SYMBOL_GPL(vsock_find_connected_socket);
 
 void vsock_remove_sock(struct vsock_sock *vsk)
 {
-	vsock_remove_bound(vsk);
+	if (sock_type_connectible(sk_vsock(vsk)->sk_type))
+		vsock_remove_bound(vsk);
+	else
+		vsock_remove_dgram_bound(vsk);
 	vsock_remove_connected(vsk);
 }
 EXPORT_SYMBOL_GPL(vsock_remove_sock);
@@ -378,7 +549,7 @@ void vsock_for_each_connected_socket(struct vsock_transport *transport,
 		struct vsock_sock *vsk;
 		list_for_each_entry(vsk, &vsock_connected_table[i],
 				    connected_table) {
-			if (vsk->transport != transport)
+			if (vsock_core_get_transport(vsk) != transport)
 				continue;
 
 			fn(sk_vsock(vsk));
@@ -444,59 +615,39 @@ static bool vsock_use_local_transport(unsigned int remote_cid)
 
 static void vsock_deassign_transport(struct vsock_sock *vsk)
 {
-	if (!vsk->transport)
-		return;
-
-	vsk->transport->destruct(vsk);
-	module_put(vsk->transport->module);
-	vsk->transport = NULL;
-}
-
-static const struct vsock_transport *
-vsock_connectible_lookup_transport(unsigned int cid, __u8 flags)
-{
-	const struct vsock_transport *transport;
+	struct vsock_remote_info *remote_info;
 
-	if (vsock_use_local_transport(cid))
-		transport = transport_local;
-	else if (cid <= VMADDR_CID_HOST || !transport_h2g ||
-		 (flags & VMADDR_FLAG_TO_HOST))
-		transport = transport_g2h;
-	else
-		transport = transport_h2g;
-
-	return transport;
-}
-
-static const struct vsock_transport *
-vsock_dgram_lookup_transport(unsigned int cid, __u8 flags)
-{
-	if (transport_dgram)
-		return transport_dgram;
+	remote_info = rcu_replace_pointer(vsk->remote_info, NULL,
+					  lockdep_sock_is_held(sk_vsock(vsk)));
+	if (!remote_info)
+		return;
 
-	return vsock_connectible_lookup_transport(cid, flags);
+	remote_info->transport->destruct(vsk);
+	module_put(remote_info->transport->module);
+	kfree_rcu(remote_info, rcu);
 }
 
 /* Assign a transport to a socket and call the .init transport callback.
  *
- * Note: for connection oriented socket this must be called when vsk->remote_addr
- * is set (e.g. during the connect() or when a connection request on a listener
- * socket is received).
- * The vsk->remote_addr is used to decide which transport to use:
+ * The remote_addr is used to decide which transport to use:
  *  - remote CID == VMADDR_CID_LOCAL or g2h->local_cid or VMADDR_CID_HOST if
  *    g2h is not loaded, will use local transport;
  *  - remote CID <= VMADDR_CID_HOST or h2g is not loaded or remote flags field
  *    includes VMADDR_FLAG_TO_HOST flag value, will use guest->host transport;
  *  - remote CID > VMADDR_CID_HOST will use host->guest transport;
  */
-int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
+int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk,
+			   struct sockaddr_vm *remote_addr)
 {
 	const struct vsock_transport *new_transport;
+	struct vsock_remote_info *old_info;
 	struct sock *sk = sk_vsock(vsk);
-	unsigned int remote_cid = vsk->remote_addr.svm_cid;
+	unsigned int remote_cid;
 	__u8 remote_flags;
 	int ret;
 
+	remote_cid = remote_addr->svm_cid;
+
 	/* If the packet is coming with the source and destination CIDs higher
 	 * than VMADDR_CID_HOST, then a vsock channel where all the packets are
 	 * forwarded to the host should be established. Then the host will
@@ -506,10 +657,10 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
 	 * the connect path the flag can be set by the user space application.
 	 */
 	if (psk && vsk->local_addr.svm_cid > VMADDR_CID_HOST &&
-	    vsk->remote_addr.svm_cid > VMADDR_CID_HOST)
-		vsk->remote_addr.svm_flags |= VMADDR_FLAG_TO_HOST;
+	    remote_cid > VMADDR_CID_HOST)
+		remote_addr->svm_flags |= VMADDR_FLAG_TO_HOST;
 
-	remote_flags = vsk->remote_addr.svm_flags;
+	remote_flags = remote_addr->svm_flags;
 
 	switch (sk->sk_type) {
 	case SOCK_DGRAM:
@@ -525,8 +676,9 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
 		return -ESOCKTNOSUPPORT;
 	}
 
-	if (vsk->transport) {
-		if (vsk->transport == new_transport)
+	old_info = vsock_core_get_remote_info(vsk);
+	if (old_info && old_info->transport) {
+		if (old_info->transport == new_transport)
 			return 0;
 
 		/* transport->release() must be called with sock lock acquired.
@@ -535,7 +687,7 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
 		 * function is called on a new socket which is not assigned to
 		 * any transport.
 		 */
-		vsk->transport->release(vsk);
+		old_info->transport->release(vsk);
 		vsock_deassign_transport(vsk);
 	}
 
@@ -553,13 +705,18 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
 		}
 	}
 
-	ret = new_transport->init(vsk, psk);
+	ret = vsock_set_remote_info(vsk, new_transport, remote_addr);
 	if (ret) {
 		module_put(new_transport->module);
 		return ret;
 	}
 
-	vsk->transport = new_transport;
+	ret = new_transport->init(vsk, psk);
+	if (ret) {
+		vsock_set_remote_info(vsk, NULL, NULL);
+		module_put(new_transport->module);
+		return ret;
+	}
 
 	return 0;
 }
@@ -616,12 +773,14 @@ static bool vsock_is_pending(struct sock *sk)
 
 static int vsock_send_shutdown(struct sock *sk, int mode)
 {
+	const struct vsock_transport *transport;
 	struct vsock_sock *vsk = vsock_sk(sk);
 
-	if (!vsk->transport)
+	transport = vsock_core_get_transport(vsk);
+	if (!transport)
 		return -ENODEV;
 
-	return vsk->transport->shutdown(vsk, mode);
+	return transport->shutdown(vsk, mode);
 }
 
 static void vsock_pending_work(struct work_struct *work)
@@ -757,7 +916,10 @@ EXPORT_SYMBOL(vsock_bind_stream);
 static int vsock_bind_dgram(struct vsock_sock *vsk,
 			    struct sockaddr_vm *addr)
 {
-	if (!vsk->transport || !vsk->transport->dgram_bind) {
+	const struct vsock_transport *transport;
+
+	transport = vsock_core_get_transport(vsk);
+	if (!transport || !transport->dgram_bind) {
 		int retval;
 		spin_lock_bh(&vsock_dgram_table_lock);
 		retval = vsock_bind_common(vsk, addr, vsock_dgram_bind_table,
@@ -767,7 +929,7 @@ static int vsock_bind_dgram(struct vsock_sock *vsk,
 		return retval;
 	}
 
-	return vsk->transport->dgram_bind(vsk, addr);
+	return transport->dgram_bind(vsk, addr);
 }
 
 static int __vsock_bind(struct sock *sk, struct sockaddr_vm *addr)
@@ -816,6 +978,7 @@ static struct sock *__vsock_create(struct net *net,
 				   unsigned short type,
 				   int kern)
 {
+	struct vsock_remote_info *remote_info;
 	struct sock *sk;
 	struct vsock_sock *psk;
 	struct vsock_sock *vsk;
@@ -835,7 +998,14 @@ static struct sock *__vsock_create(struct net *net,
 
 	vsk = vsock_sk(sk);
 	vsock_addr_init(&vsk->local_addr, VMADDR_CID_ANY, VMADDR_PORT_ANY);
-	vsock_addr_init(&vsk->remote_addr, VMADDR_CID_ANY, VMADDR_PORT_ANY);
+
+	remote_info = kmalloc(sizeof(*remote_info), GFP_KERNEL);
+	if (!remote_info) {
+		sk_free(sk);
+		return NULL;
+	}
+	vsock_addr_init(&remote_info->addr, VMADDR_CID_ANY, VMADDR_PORT_ANY);
+	rcu_assign_pointer(vsk->remote_info, remote_info);
 
 	sk->sk_destruct = vsock_sk_destruct;
 	sk->sk_backlog_rcv = vsock_queue_rcv_skb;
@@ -882,6 +1052,7 @@ static bool sock_type_connectible(u16 type)
 static void __vsock_release(struct sock *sk, int level)
 {
 	if (sk) {
+		const struct vsock_transport *transport;
 		struct sock *pending;
 		struct vsock_sock *vsk;
 
@@ -895,8 +1066,9 @@ static void __vsock_release(struct sock *sk, int level)
 		 */
 		lock_sock_nested(sk, level);
 
-		if (vsk->transport)
-			vsk->transport->release(vsk);
+		transport = vsock_core_get_transport(vsk);
+		if (transport)
+			transport->release(vsk);
 		else if (sock_type_connectible(sk->sk_type))
 			vsock_remove_sock(vsk);
 
@@ -926,8 +1098,6 @@ static void vsock_sk_destruct(struct sock *sk)
 	 * possibly register the address family with the kernel.
 	 */
 	vsock_addr_init(&vsk->local_addr, VMADDR_CID_ANY, VMADDR_PORT_ANY);
-	vsock_addr_init(&vsk->remote_addr, VMADDR_CID_ANY, VMADDR_PORT_ANY);
-
 	put_cred(vsk->owner);
 }
 
@@ -951,16 +1121,22 @@ EXPORT_SYMBOL_GPL(vsock_create_connected);
 
 s64 vsock_stream_has_data(struct vsock_sock *vsk)
 {
-	return vsk->transport->stream_has_data(vsk);
+	const struct vsock_transport *transport;
+
+	transport = vsock_core_get_transport(vsk);
+
+	return transport->stream_has_data(vsk);
 }
 EXPORT_SYMBOL_GPL(vsock_stream_has_data);
 
 s64 vsock_connectible_has_data(struct vsock_sock *vsk)
 {
+	const struct vsock_transport *transport;
 	struct sock *sk = sk_vsock(vsk);
 
+	transport = vsock_core_get_transport(vsk);
 	if (sk->sk_type == SOCK_SEQPACKET)
-		return vsk->transport->seqpacket_has_data(vsk);
+		return transport->seqpacket_has_data(vsk);
 	else
 		return vsock_stream_has_data(vsk);
 }
@@ -968,7 +1144,10 @@ EXPORT_SYMBOL_GPL(vsock_connectible_has_data);
 
 s64 vsock_stream_has_space(struct vsock_sock *vsk)
 {
-	return vsk->transport->stream_has_space(vsk);
+	const struct vsock_transport *transport;
+
+	transport = vsock_core_get_transport(vsk);
+	return transport->stream_has_space(vsk);
 }
 EXPORT_SYMBOL_GPL(vsock_stream_has_space);
 
@@ -1017,6 +1196,7 @@ static int vsock_getname(struct socket *sock,
 	struct sock *sk;
 	struct vsock_sock *vsk;
 	struct sockaddr_vm *vm_addr;
+	struct vsock_remote_info *rcu_ptr;
 
 	sk = sock->sk;
 	vsk = vsock_sk(sk);
@@ -1025,11 +1205,17 @@ static int vsock_getname(struct socket *sock,
 	lock_sock(sk);
 
 	if (peer) {
+		rcu_read_lock();
 		if (sock->state != SS_CONNECTED) {
 			err = -ENOTCONN;
 			goto out;
 		}
-		vm_addr = &vsk->remote_addr;
+		rcu_ptr = vsock_core_get_remote_info(vsk);
+		if (!rcu_ptr) {
+			err = -EINVAL;
+			goto out;
+		}
+		vm_addr = &rcu_ptr->addr;
 	} else {
 		vm_addr = &vsk->local_addr;
 	}
@@ -1049,6 +1235,8 @@ static int vsock_getname(struct socket *sock,
 	err = sizeof(*vm_addr);
 
 out:
+	if (peer)
+		rcu_read_unlock();
 	release_sock(sk);
 	return err;
 }
@@ -1153,7 +1341,7 @@ static __poll_t vsock_poll(struct file *file, struct socket *sock,
 
 		lock_sock(sk);
 
-		transport = vsk->transport;
+		transport = vsock_core_get_transport(vsk);
 
 		/* Listening sockets that have connections in their accept
 		 * queue can be read.
@@ -1224,9 +1412,11 @@ static __poll_t vsock_poll(struct file *file, struct socket *sock,
 
 static int vsock_read_skb(struct sock *sk, skb_read_actor_t read_actor)
 {
+	const struct vsock_transport *transport;
 	struct vsock_sock *vsk = vsock_sk(sk);
 
-	return vsk->transport->read_skb(vsk, read_actor);
+	transport = vsock_core_get_transport(vsk);
+	return transport->read_skb(vsk, read_actor);
 }
 
 static int vsock_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
@@ -1235,7 +1425,7 @@ static int vsock_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
 	int err;
 	struct sock *sk;
 	struct vsock_sock *vsk;
-	struct sockaddr_vm *remote_addr;
+	struct sockaddr_vm stack_addr, *remote_addr;
 	const struct vsock_transport *transport;
 
 	if (msg->msg_flags & MSG_OOB)
@@ -1246,7 +1436,23 @@ static int vsock_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
 	sk = sock->sk;
 	vsk = vsock_sk(sk);
 
-	lock_sock(sk);
+	/* If auto-binding is required, acquire the slock to avoid potential
+	 * race conditions. Otherwise, do not acquire the lock.
+	 *
+	 * We know that the first check of local_addr is racy (indicated by
+	 * data_race()). By acquiring the lock and then subsequently checking
+	 * again if local_addr is bound (inside vsock_auto_bind()), we can
+	 * ensure there are no real data races.
+	 *
+	 * This technique is borrowed by inet_send_prepare().
+	 */
+	if (data_race(!vsock_addr_bound(&vsk->local_addr))) {
+		lock_sock(sk);
+		err = vsock_auto_bind(vsk);
+		release_sock(sk);
+		if (err)
+			return err;
+	}
 
 	/* If the provided message contains an address, use that.  Otherwise
 	 * fall back on the socket's remote handle (if it has been connected).
@@ -1256,6 +1462,7 @@ static int vsock_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
 			    &remote_addr) == 0) {
 		transport = vsock_dgram_lookup_transport(remote_addr->svm_cid,
 							 remote_addr->svm_flags);
+
 		if (!transport) {
 			err = -EINVAL;
 			goto out;
@@ -1286,18 +1493,39 @@ static int vsock_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
 			goto out;
 		}
 
-		err = transport->dgram_enqueue(vsk, remote_addr, msg, len);
+		err = transport->dgram_enqueue(transport, vsk, remote_addr, msg, len);
 		module_put(transport->module);
 	} else if (sock->state == SS_CONNECTED) {
-		remote_addr = &vsk->remote_addr;
-		transport = vsk->transport;
+		struct vsock_remote_info *remote_info;
+		const struct vsock_transport *transport;
 
-		err = vsock_auto_bind(vsk);
-		if (err)
+		rcu_read_lock();
+		remote_info = vsock_core_get_remote_info(vsk);
+		if (!remote_info) {
+			err = -EINVAL;
+			rcu_read_unlock();
 			goto out;
+		}
 
-		if (remote_addr->svm_cid == VMADDR_CID_ANY)
+		transport = remote_info->transport;
+		memcpy(&stack_addr, &remote_info->addr, sizeof(stack_addr));
+		rcu_read_unlock();
+
+		remote_addr = &stack_addr;
+
+		if (remote_addr->svm_cid == VMADDR_CID_ANY) {
 			remote_addr->svm_cid = transport->get_local_cid();
+			lock_sock(sk_vsock(vsk));
+			/* Even though the CID has changed, We do not have to
+			 * look up the transport again because the local CID
+			 * will never resolve to a different transport.
+			 */
+			err = vsock_set_remote_info(vsk, transport, remote_addr);
+			release_sock(sk_vsock(vsk));
+
+			if (err)
+				goto out;
+		}
 
 		/* XXX Should connect() or this function ensure remote_addr is
 		 * bound?
@@ -1313,14 +1541,13 @@ static int vsock_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
 			goto out;
 		}
 
-		err = transport->dgram_enqueue(vsk, remote_addr, msg, len);
+		err = transport->dgram_enqueue(transport, vsk, &stack_addr, msg, len);
 	} else {
 		err = -EINVAL;
 		goto out;
 	}
 
 out:
-	release_sock(sk);
 	return err;
 }
 
@@ -1331,18 +1558,22 @@ static int vsock_dgram_connect(struct socket *sock,
 	struct sock *sk;
 	struct vsock_sock *vsk;
 	struct sockaddr_vm *remote_addr;
+	const struct vsock_transport *transport;
 
 	sk = sock->sk;
 	vsk = vsock_sk(sk);
 
 	err = vsock_addr_cast(addr, addr_len, &remote_addr);
 	if (err == -EAFNOSUPPORT && remote_addr->svm_family == AF_UNSPEC) {
+		struct sockaddr_vm addr_any;
+
 		lock_sock(sk);
-		vsock_addr_init(&vsk->remote_addr, VMADDR_CID_ANY,
-				VMADDR_PORT_ANY);
+		vsock_addr_init(&addr_any, VMADDR_CID_ANY, VMADDR_PORT_ANY);
+		err = vsock_set_remote_info(vsk, vsock_core_get_transport(vsk),
+					    &addr_any);
 		sock->state = SS_UNCONNECTED;
 		release_sock(sk);
-		return 0;
+		return err;
 	} else if (err != 0)
 		return -EINVAL;
 
@@ -1352,14 +1583,13 @@ static int vsock_dgram_connect(struct socket *sock,
 	if (err)
 		goto out;
 
-	memcpy(&vsk->remote_addr, remote_addr, sizeof(vsk->remote_addr));
-
-	err = vsock_assign_transport(vsk, NULL);
+	err = vsock_assign_transport(vsk, NULL, remote_addr);
 	if (err)
 		goto out;
 
-	if (!vsk->transport->dgram_allow(remote_addr->svm_cid,
-					 remote_addr->svm_port)) {
+	transport = vsock_core_get_transport(vsk);
+	if (!transport->dgram_allow(remote_addr->svm_cid,
+				    remote_addr->svm_port)) {
 		err = -EINVAL;
 		goto out;
 	}
@@ -1406,7 +1636,9 @@ int vsock_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
 	if (flags & MSG_OOB || flags & MSG_ERRQUEUE)
 		return -EOPNOTSUPP;
 
-	transport = vsk->transport;
+	rcu_read_lock();
+	transport = vsock_core_get_transport(vsk);
+	rcu_read_unlock();
 
 	/* Retrieve the head sk_buff from the socket's receive queue. */
 	err = 0;
@@ -1474,7 +1706,7 @@ static const struct proto_ops vsock_dgram_ops = {
 
 static int vsock_transport_cancel_pkt(struct vsock_sock *vsk)
 {
-	const struct vsock_transport *transport = vsk->transport;
+	const struct vsock_transport *transport = vsock_core_get_transport(vsk);
 
 	if (!transport || !transport->cancel_pkt)
 		return -EOPNOTSUPP;
@@ -1511,6 +1743,7 @@ static int vsock_connect(struct socket *sock, struct sockaddr *addr,
 	struct sock *sk;
 	struct vsock_sock *vsk;
 	const struct vsock_transport *transport;
+	struct vsock_remote_info *remote_info;
 	struct sockaddr_vm *remote_addr;
 	long timeout;
 	DEFINE_WAIT(wait);
@@ -1548,14 +1781,20 @@ static int vsock_connect(struct socket *sock, struct sockaddr *addr,
 		}
 
 		/* Set the remote address that we are connecting to. */
-		memcpy(&vsk->remote_addr, remote_addr,
-		       sizeof(vsk->remote_addr));
-
-		err = vsock_assign_transport(vsk, NULL);
+		err = vsock_assign_transport(vsk, NULL, remote_addr);
 		if (err)
 			goto out;
 
-		transport = vsk->transport;
+		rcu_read_lock();
+		remote_info = vsock_core_get_remote_info(vsk);
+		if (!remote_info) {
+			err = -EINVAL;
+			rcu_read_unlock();
+			goto out;
+		}
+
+		transport = remote_info->transport;
+		rcu_read_unlock();
 
 		/* The hypervisor and well-known contexts do not have socket
 		 * endpoints.
@@ -1819,7 +2058,7 @@ static int vsock_connectible_setsockopt(struct socket *sock,
 
 	lock_sock(sk);
 
-	transport = vsk->transport;
+	transport = vsock_core_get_transport(vsk);
 
 	switch (optname) {
 	case SO_VM_SOCKETS_BUFFER_SIZE:
@@ -1957,7 +2196,7 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
 
 	lock_sock(sk);
 
-	transport = vsk->transport;
+	transport = vsock_core_get_transport(vsk);
 
 	/* Callers should not provide a destination with connection oriented
 	 * sockets.
@@ -1980,7 +2219,7 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
 		goto out;
 	}
 
-	if (!vsock_addr_bound(&vsk->remote_addr)) {
+	if (!vsock_remote_addr_bound(vsk)) {
 		err = -EDESTADDRREQ;
 		goto out;
 	}
@@ -2101,7 +2340,7 @@ static int vsock_connectible_wait_data(struct sock *sk,
 
 	vsk = vsock_sk(sk);
 	err = 0;
-	transport = vsk->transport;
+	transport = vsock_core_get_transport(vsk);
 
 	while (1) {
 		prepare_to_wait(sk_sleep(sk), wait, TASK_INTERRUPTIBLE);
@@ -2169,7 +2408,7 @@ static int __vsock_stream_recvmsg(struct sock *sk, struct msghdr *msg,
 	DEFINE_WAIT(wait);
 
 	vsk = vsock_sk(sk);
-	transport = vsk->transport;
+	transport = vsock_core_get_transport(vsk);
 
 	/* We must not copy less than target bytes into the user's buffer
 	 * before returning successfully, so we wait for the consume queue to
@@ -2245,7 +2484,7 @@ static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
 	DEFINE_WAIT(wait);
 
 	vsk = vsock_sk(sk);
-	transport = vsk->transport;
+	transport = vsock_core_get_transport(vsk);
 
 	timeout = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
 
@@ -2302,7 +2541,7 @@ vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 
 	lock_sock(sk);
 
-	transport = vsk->transport;
+	transport = vsock_core_get_transport(vsk);
 
 	if (!transport || sk->sk_state != TCP_ESTABLISHED) {
 		/* Recvmsg is supposed to return 0 if a peer performs an
@@ -2369,7 +2608,7 @@ static int vsock_set_rcvlowat(struct sock *sk, int val)
 	if (val > vsk->buffer_size)
 		return -EINVAL;
 
-	transport = vsk->transport;
+	transport = vsock_core_get_transport(vsk);
 
 	if (transport && transport->set_rcvlowat)
 		return transport->set_rcvlowat(vsk, val);
@@ -2459,7 +2698,10 @@ static int vsock_create(struct net *net, struct socket *sock,
 	vsk = vsock_sk(sk);
 
 	if (sock->type == SOCK_DGRAM) {
-		ret = vsock_assign_transport(vsk, NULL);
+		struct sockaddr_vm remote_addr;
+
+		vsock_addr_init(&remote_addr, VMADDR_CID_ANY, VMADDR_PORT_ANY);
+		ret = vsock_assign_transport(vsk, NULL, &remote_addr);
 		if (ret < 0) {
 			sock_put(sk);
 			return ret;
@@ -2581,7 +2823,18 @@ static void __exit vsock_exit(void)
 
 const struct vsock_transport *vsock_core_get_transport(struct vsock_sock *vsk)
 {
-	return vsk->transport;
+	const struct vsock_transport *transport;
+	struct vsock_remote_info *remote_info;
+
+	rcu_read_lock();
+	remote_info = vsock_core_get_remote_info(vsk);
+	if (!remote_info) {
+		rcu_read_unlock();
+		return NULL;
+	}
+	transport = remote_info->transport;
+	rcu_read_unlock();
+	return transport;
 }
 EXPORT_SYMBOL_GPL(vsock_core_get_transport);
 
diff --git a/net/vmw_vsock/diag.c b/net/vmw_vsock/diag.c
index a2823b1c5e28..f843bae86b32 100644
--- a/net/vmw_vsock/diag.c
+++ b/net/vmw_vsock/diag.c
@@ -15,8 +15,14 @@ static int sk_diag_fill(struct sock *sk, struct sk_buff *skb,
 			u32 portid, u32 seq, u32 flags)
 {
 	struct vsock_sock *vsk = vsock_sk(sk);
+	struct sockaddr_vm remote_addr;
 	struct vsock_diag_msg *rep;
 	struct nlmsghdr *nlh;
+	int err;
+
+	err = vsock_remote_addr_copy(vsk, &remote_addr);
+	if (err < 0)
+		return err;
 
 	nlh = nlmsg_put(skb, portid, seq, SOCK_DIAG_BY_FAMILY, sizeof(*rep),
 			flags);
@@ -36,8 +42,8 @@ static int sk_diag_fill(struct sock *sk, struct sk_buff *skb,
 	rep->vdiag_shutdown = sk->sk_shutdown;
 	rep->vdiag_src_cid = vsk->local_addr.svm_cid;
 	rep->vdiag_src_port = vsk->local_addr.svm_port;
-	rep->vdiag_dst_cid = vsk->remote_addr.svm_cid;
-	rep->vdiag_dst_port = vsk->remote_addr.svm_port;
+	rep->vdiag_dst_cid = remote_addr.svm_cid;
+	rep->vdiag_dst_port = remote_addr.svm_port;
 	rep->vdiag_ino = sock_i_ino(sk);
 
 	sock_diag_save_cookie(sk, rep->vdiag_cookie);
diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
index c00bc5da769a..84e8c64b3365 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -323,6 +323,8 @@ static void hvs_open_connection(struct vmbus_channel *chan)
 		goto out;
 
 	if (conn_from_host) {
+		struct sockaddr_vm remote_addr;
+
 		if (sk->sk_ack_backlog >= sk->sk_max_ack_backlog)
 			goto out;
 
@@ -336,10 +338,9 @@ static void hvs_open_connection(struct vmbus_channel *chan)
 		hvs_addr_init(&vnew->local_addr, if_type);
 
 		/* Remote peer is always the host */
-		vsock_addr_init(&vnew->remote_addr,
-				VMADDR_CID_HOST, VMADDR_PORT_ANY);
-		vnew->remote_addr.svm_port = get_port_by_srv_id(if_instance);
-		ret = vsock_assign_transport(vnew, vsock_sk(sk));
+		vsock_addr_init(&remote_addr, VMADDR_CID_HOST, get_port_by_srv_id(if_instance));
+
+		ret = vsock_assign_transport(vnew, vsock_sk(sk), &remote_addr);
 		/* Transport assigned (looking at remote_addr) must be the
 		 * same where we received the request.
 		 */
@@ -459,13 +460,18 @@ static int hvs_connect(struct vsock_sock *vsk)
 {
 	union hvs_service_id vm, host;
 	struct hvsock *h = vsk->trans;
+	int err;
 
 	vm.srv_id = srv_id_template;
 	vm.svm_port = vsk->local_addr.svm_port;
 	h->vm_srv_id = vm.srv_id;
 
 	host.srv_id = srv_id_template;
-	host.svm_port = vsk->remote_addr.svm_port;
+
+	err = vsock_remote_addr_port(vsk, &host.svm_port);
+	if (err < 0)
+		return err;
+
 	h->host_srv_id = host.srv_id;
 
 	return vmbus_send_tl_connect_request(&h->vm_srv_id, &h->host_srv_id);
@@ -566,7 +572,8 @@ static int hvs_dgram_get_length(struct sk_buff *skb, size_t *len)
 	return -EOPNOTSUPP;
 }
 
-static int hvs_dgram_enqueue(struct vsock_sock *vsk,
+static int hvs_dgram_enqueue(const struct vsock_transport *transport,
+			     struct vsock_sock *vsk,
 			     struct sockaddr_vm *remote, struct msghdr *msg,
 			     size_t dgram_len)
 {
@@ -866,7 +873,13 @@ static struct vsock_transport hvs_transport = {
 
 static bool hvs_check_transport(struct vsock_sock *vsk)
 {
-	return vsk->transport == &hvs_transport;
+	bool ret;
+
+	rcu_read_lock();
+	ret = vsock_core_get_transport(vsk) == &hvs_transport;
+	rcu_read_unlock();
+
+	return ret;
 }
 
 static int hvs_probe(struct hv_device *hdev,
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index ab4af21c4f3f..09d35c488902 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -258,8 +258,9 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
 	src_cid = t_ops->transport.get_local_cid();
 	src_port = vsk->local_addr.svm_port;
 	if (!info->remote_cid) {
-		dst_cid	= vsk->remote_addr.svm_cid;
-		dst_port = vsk->remote_addr.svm_port;
+		ret = vsock_remote_addr_cid_port(vsk, &dst_cid, &dst_port);
+		if (ret < 0)
+			return ret;
 	} else {
 		dst_cid = info->remote_cid;
 		dst_port = info->remote_port;
@@ -877,12 +878,14 @@ int virtio_transport_shutdown(struct vsock_sock *vsk, int mode)
 EXPORT_SYMBOL_GPL(virtio_transport_shutdown);
 
 int
-virtio_transport_dgram_enqueue(struct vsock_sock *vsk,
+virtio_transport_dgram_enqueue(const struct vsock_transport *transport,
+			       struct vsock_sock *vsk,
 			       struct sockaddr_vm *remote_addr,
 			       struct msghdr *msg,
 			       size_t dgram_len)
 {
-	const struct virtio_transport *t_ops;
+	const struct virtio_transport *t_ops =
+		(const struct virtio_transport *)transport;
 	struct virtio_vsock_pkt_info info = {
 		.op = VIRTIO_VSOCK_OP_RW,
 		.msg = msg,
@@ -896,7 +899,6 @@ virtio_transport_dgram_enqueue(struct vsock_sock *vsk,
 	if (dgram_len > VIRTIO_VSOCK_MAX_PKT_BUF_SIZE)
 		return -EMSGSIZE;
 
-	t_ops = virtio_transport_get_ops(vsk);
 	src_cid = t_ops->transport.get_local_cid();
 	src_port = vsk->local_addr.svm_port;
 
@@ -1120,7 +1122,9 @@ virtio_transport_recv_connecting(struct sock *sk,
 	case VIRTIO_VSOCK_OP_RESPONSE:
 		sk->sk_state = TCP_ESTABLISHED;
 		sk->sk_socket->state = SS_CONNECTED;
-		vsock_insert_connected(vsk);
+		err = vsock_insert_connected(vsk);
+		if (err)
+			goto destroy;
 		sk->sk_state_change(sk);
 		break;
 	case VIRTIO_VSOCK_OP_INVALID:
@@ -1326,6 +1330,7 @@ virtio_transport_recv_listen(struct sock *sk, struct sk_buff *skb,
 	struct virtio_vsock_hdr *hdr = virtio_vsock_hdr(skb);
 	struct vsock_sock *vsk = vsock_sk(sk);
 	struct vsock_sock *vchild;
+	struct sockaddr_vm child_remote;
 	struct sock *child;
 	int ret;
 
@@ -1354,14 +1359,13 @@ virtio_transport_recv_listen(struct sock *sk, struct sk_buff *skb,
 	vchild = vsock_sk(child);
 	vsock_addr_init(&vchild->local_addr, le64_to_cpu(hdr->dst_cid),
 			le32_to_cpu(hdr->dst_port));
-	vsock_addr_init(&vchild->remote_addr, le64_to_cpu(hdr->src_cid),
+	vsock_addr_init(&child_remote, le64_to_cpu(hdr->src_cid),
 			le32_to_cpu(hdr->src_port));
-
-	ret = vsock_assign_transport(vchild, vsk);
+	ret = vsock_assign_transport(vchild, vsk, &child_remote);
 	/* Transport assigned (looking at remote_addr) must be the same
 	 * where we received the request.
 	 */
-	if (ret || vchild->transport != &t->transport) {
+	if (ret || vsock_core_get_transport(vchild) != &t->transport) {
 		release_sock(child);
 		virtio_transport_reset_no_sock(t, skb);
 		sock_put(child);
@@ -1371,7 +1375,13 @@ virtio_transport_recv_listen(struct sock *sk, struct sk_buff *skb,
 	if (virtio_transport_space_update(child, skb))
 		child->sk_write_space(child);
 
-	vsock_insert_connected(vchild);
+	ret = vsock_insert_connected(vchild);
+	if (ret) {
+		release_sock(child);
+		virtio_transport_reset_no_sock(t, skb);
+		sock_put(child);
+		return ret;
+	}
 	vsock_enqueue_accept(sk, child);
 	virtio_transport_send_response(vchild, skb);
 
diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
index b6a51afb74b8..b9ba6209e8fc 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -283,18 +283,25 @@ vmci_transport_send_control_pkt(struct sock *sk,
 				u16 proto,
 				struct vmci_handle handle)
 {
+	struct sockaddr_vm addr_stack;
+	struct sockaddr_vm *remote_addr = &addr_stack;
 	struct vsock_sock *vsk;
+	int err;
 
 	vsk = vsock_sk(sk);
 
 	if (!vsock_addr_bound(&vsk->local_addr))
 		return -EINVAL;
 
-	if (!vsock_addr_bound(&vsk->remote_addr))
+	if (!vsock_remote_addr_bound(vsk))
 		return -EINVAL;
 
+	err = vsock_remote_addr_copy(vsk, remote_addr);
+	if (err < 0)
+		return err;
+
 	return vmci_transport_alloc_send_control_pkt(&vsk->local_addr,
-						     &vsk->remote_addr,
+						     remote_addr,
 						     type, size, mode,
 						     wait, proto, handle);
 }
@@ -317,6 +324,7 @@ static int vmci_transport_send_reset(struct sock *sk,
 	struct sockaddr_vm *dst_ptr;
 	struct sockaddr_vm dst;
 	struct vsock_sock *vsk;
+	int err;
 
 	if (pkt->type == VMCI_TRANSPORT_PACKET_TYPE_RST)
 		return 0;
@@ -326,13 +334,16 @@ static int vmci_transport_send_reset(struct sock *sk,
 	if (!vsock_addr_bound(&vsk->local_addr))
 		return -EINVAL;
 
-	if (vsock_addr_bound(&vsk->remote_addr)) {
-		dst_ptr = &vsk->remote_addr;
+	if (vsock_remote_addr_bound(vsk)) {
+		err = vsock_remote_addr_copy(vsk, &dst);
+		if (err < 0)
+			return err;
 	} else {
 		vsock_addr_init(&dst, pkt->dg.src.context,
 				pkt->src_port);
-		dst_ptr = &dst;
 	}
+	dst_ptr = &dst;
+
 	return vmci_transport_alloc_send_control_pkt(&vsk->local_addr, dst_ptr,
 					     VMCI_TRANSPORT_PACKET_TYPE_RST,
 					     0, 0, NULL, VSOCK_PROTO_INVALID,
@@ -490,7 +501,7 @@ static struct sock *vmci_transport_get_pending(
 
 	list_for_each_entry(vpending, &vlistener->pending_links,
 			    pending_links) {
-		if (vsock_addr_equals_addr(&src, &vpending->remote_addr) &&
+		if (vsock_remote_addr_equals(vpending, &src) &&
 		    pkt->dst_port == vpending->local_addr.svm_port) {
 			pending = sk_vsock(vpending);
 			sock_hold(pending);
@@ -940,6 +951,7 @@ static void vmci_transport_recv_pkt_work(struct work_struct *work)
 static int vmci_transport_recv_listen(struct sock *sk,
 				      struct vmci_transport_packet *pkt)
 {
+	struct sockaddr_vm remote_addr;
 	struct sock *pending;
 	struct vsock_sock *vpending;
 	int err;
@@ -1015,10 +1027,10 @@ static int vmci_transport_recv_listen(struct sock *sk,
 
 	vsock_addr_init(&vpending->local_addr, pkt->dg.dst.context,
 			pkt->dst_port);
-	vsock_addr_init(&vpending->remote_addr, pkt->dg.src.context,
-			pkt->src_port);
 
-	err = vsock_assign_transport(vpending, vsock_sk(sk));
+	vsock_addr_init(&remote_addr, pkt->dg.src.context, pkt->src_port);
+
+	err = vsock_assign_transport(vpending, vsock_sk(sk), &remote_addr);
 	/* Transport assigned (looking at remote_addr) must be the same
 	 * where we received the request.
 	 */
@@ -1133,6 +1145,7 @@ vmci_transport_recv_connecting_server(struct sock *listener,
 {
 	struct vsock_sock *vpending;
 	struct vmci_handle handle;
+	unsigned int vpending_remote_cid;
 	struct vmci_qp *qpair;
 	bool is_local;
 	u32 flags;
@@ -1189,8 +1202,13 @@ vmci_transport_recv_connecting_server(struct sock *listener,
 	/* vpending->local_addr always has a context id so we do not need to
 	 * worry about VMADDR_CID_ANY in this case.
 	 */
-	is_local =
-	    vpending->remote_addr.svm_cid == vpending->local_addr.svm_cid;
+	err = vsock_remote_addr_cid(vpending, &vpending_remote_cid);
+	if (err < 0) {
+		skerr = EPROTO;
+		goto destroy;
+	}
+
+	is_local = vpending_remote_cid == vpending->local_addr.svm_cid;
 	flags = VMCI_QPFLAG_ATTACH_ONLY;
 	flags |= is_local ? VMCI_QPFLAG_LOCAL : 0;
 
@@ -1203,7 +1221,7 @@ vmci_transport_recv_connecting_server(struct sock *listener,
 					flags,
 					vmci_transport_is_trusted(
 						vpending,
-						vpending->remote_addr.svm_cid));
+						vpending_remote_cid));
 	if (err < 0) {
 		vmci_transport_send_reset(pending, pkt);
 		skerr = -err;
@@ -1277,6 +1295,8 @@ static int
 vmci_transport_recv_connecting_client(struct sock *sk,
 				      struct vmci_transport_packet *pkt)
 {
+	struct vsock_remote_info *remote_info;
+	struct sockaddr_vm *remote_addr;
 	struct vsock_sock *vsk;
 	int err;
 	int skerr;
@@ -1306,9 +1326,20 @@ vmci_transport_recv_connecting_client(struct sock *sk,
 		break;
 	case VMCI_TRANSPORT_PACKET_TYPE_NEGOTIATE:
 	case VMCI_TRANSPORT_PACKET_TYPE_NEGOTIATE2:
+		rcu_read_lock();
+		remote_info = vsock_core_get_remote_info(vsk);
+		if (!remote_info) {
+			skerr = EPROTO;
+			err = -EINVAL;
+			rcu_read_unlock();
+			goto destroy;
+		}
+
+		remote_addr = &remote_info->addr;
+
 		if (pkt->u.size == 0
-		    || pkt->dg.src.context != vsk->remote_addr.svm_cid
-		    || pkt->src_port != vsk->remote_addr.svm_port
+		    || pkt->dg.src.context != remote_addr->svm_cid
+		    || pkt->src_port != remote_addr->svm_port
 		    || !vmci_handle_is_invalid(vmci_trans(vsk)->qp_handle)
 		    || vmci_trans(vsk)->qpair
 		    || vmci_trans(vsk)->produce_size != 0
@@ -1316,9 +1347,10 @@ vmci_transport_recv_connecting_client(struct sock *sk,
 		    || vmci_trans(vsk)->detach_sub_id != VMCI_INVALID_ID) {
 			skerr = EPROTO;
 			err = -EINVAL;
-
+			rcu_read_unlock();
 			goto destroy;
 		}
+		rcu_read_unlock();
 
 		err = vmci_transport_recv_connecting_client_negotiate(sk, pkt);
 		if (err) {
@@ -1379,6 +1411,7 @@ static int vmci_transport_recv_connecting_client_negotiate(
 	int err;
 	struct vsock_sock *vsk;
 	struct vmci_handle handle;
+	unsigned int remote_cid;
 	struct vmci_qp *qpair;
 	u32 detach_sub_id;
 	bool is_local;
@@ -1449,19 +1482,23 @@ static int vmci_transport_recv_connecting_client_negotiate(
 
 	/* Make VMCI select the handle for us. */
 	handle = VMCI_INVALID_HANDLE;
-	is_local = vsk->remote_addr.svm_cid == vsk->local_addr.svm_cid;
+
+	err = vsock_remote_addr_cid(vsk, &remote_cid);
+	if (err < 0)
+		goto destroy;
+
+	is_local = remote_cid == vsk->local_addr.svm_cid;
 	flags = is_local ? VMCI_QPFLAG_LOCAL : 0;
 
 	err = vmci_transport_queue_pair_alloc(&qpair,
 					      &handle,
 					      pkt->u.size,
 					      pkt->u.size,
-					      vsk->remote_addr.svm_cid,
+					      remote_cid,
 					      flags,
 					      vmci_transport_is_trusted(
 						  vsk,
-						  vsk->
-						  remote_addr.svm_cid));
+						  remote_cid));
 	if (err < 0)
 		goto destroy;
 
@@ -1692,6 +1729,7 @@ static int vmci_transport_dgram_bind(struct vsock_sock *vsk,
 }
 
 static int vmci_transport_dgram_enqueue(
+	const struct vsock_transport *transport,
 	struct vsock_sock *vsk,
 	struct sockaddr_vm *remote_addr,
 	struct msghdr *msg,
@@ -2052,7 +2090,13 @@ static struct vsock_transport vmci_transport = {
 
 static bool vmci_check_transport(struct vsock_sock *vsk)
 {
-	return vsk->transport == &vmci_transport;
+	bool retval;
+
+	rcu_read_lock();
+	retval = vsock_core_get_transport(vsk) == &vmci_transport;
+	rcu_read_unlock();
+
+	return retval;
 }
 
 static void vmci_vsock_transport_cb(bool is_host)
diff --git a/net/vmw_vsock/vsock_bpf.c b/net/vmw_vsock/vsock_bpf.c
index a3c97546ab84..4d811c9cdf6e 100644
--- a/net/vmw_vsock/vsock_bpf.c
+++ b/net/vmw_vsock/vsock_bpf.c
@@ -148,6 +148,7 @@ static void vsock_bpf_check_needs_rebuild(struct proto *ops)
 
 int vsock_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore)
 {
+	const struct vsock_transport *transport;
 	struct vsock_sock *vsk;
 
 	if (restore) {
@@ -157,10 +158,15 @@ int vsock_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore
 	}
 
 	vsk = vsock_sk(sk);
-	if (!vsk->transport)
+
+	rcu_read_lock();
+	transport = vsock_core_get_transport(vsk);
+	rcu_read_unlock();
+
+	if (!transport)
 		return -ENODEV;
 
-	if (!vsk->transport->read_skb)
+	if (!transport->read_skb)
 		return -EOPNOTSUPP;
 
 	vsock_bpf_check_needs_rebuild(psock->sk_proto);

-- 
2.30.2


