Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 102B8699A3A
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 17:38:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbjBPQi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 11:38:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjBPQiZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 11:38:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B85B73B872
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 08:37:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676565456;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=WOsA7cg0NumLMK7P3utyWHEXKt+LNnfHgWC/priwxPs=;
        b=g9SiYyHrlRhzk42HHl9zsZNXSFo8LY5vIJbWFbqECnqE1/Edx8g1YFWX+nFgZHjrlOTnjy
        kUaQ5TDNhuxtXHnIjsHpKZzIGCNh17DhSdP2kkMkY16Y43QxdOzvuxfTkK95JvBHWl2Ku5
        DfAJ6EPFX9Opkq7wW3KUTEvyFRxI2E8=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-332--HdDj9-WNFa3elqClF1rFQ-1; Thu, 16 Feb 2023 11:37:34 -0500
X-MC-Unique: -HdDj9-WNFa3elqClF1rFQ-1
Received: by mail-pj1-f72.google.com with SMTP id ml1-20020a17090b360100b00234686df48fso1224130pjb.8
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 08:37:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WOsA7cg0NumLMK7P3utyWHEXKt+LNnfHgWC/priwxPs=;
        b=U4n5BbWbgQvM6kQleHIrZcHnEDkhu9ke7aHrZX0Nl4B2I4vxtlYKlucE26O7DVWihL
         LGa1YMT81nOIMUpjXdPqL4aTY+Ln8IXUXVNzSt/uOleSDnNfmT8WGXqWFdV5Wm1zBxnN
         7w5Hc0cMlGOxt9ehT73v35wwXU4aEvF/Yi1rekJGJ6DrIDUodp0JdYMz2fLR8NFNmRyk
         OE3/Kjo46tHhC11XFRO9nACG9sAgPQZ+Y6R/Yp8uMShebpLELlDZjNPzjaRmV1zI40Zr
         8wl/xFCg8j8AfeMoiTiDqcjZWk7HukbwXiuxewm0fFOS6sxuFFOpKZsIHb3EbsGzA7Tj
         5reA==
X-Gm-Message-State: AO0yUKW2RECeJiNdJx/EyeXoXKh2tcm+RKZ8UiFRF2Q6voRlAS9tOuf1
        6n51kQPSzKsymYdeI9Vgp4dyP4l1gTfqReQVhCesUdtUxRf9fn37xMD0Q2qibLdqJ106VvD8mW/
        kSLP2VcudsoWY+Iw7
X-Received: by 2002:a17:90b:4b46:b0:234:e0c:caaa with SMTP id mi6-20020a17090b4b4600b002340e0ccaaamr7455140pjb.6.1676565452216;
        Thu, 16 Feb 2023 08:37:32 -0800 (PST)
X-Google-Smtp-Source: AK7set+2LshNgnwu/tL02ECX5MGFoMM8xCd018g6MtMjwwUswbG40wqEeKEtHBxoDFB6DIoouE3b9g==
X-Received: by 2002:a17:90b:4b46:b0:234:e0c:caaa with SMTP id mi6-20020a17090b4b4600b002340e0ccaaamr7455112pjb.6.1676565451791;
        Thu, 16 Feb 2023 08:37:31 -0800 (PST)
Received: from localhost.localdomain ([240d:1a:c0d:9f00:ca6:1aff:fead:cef4])
        by smtp.gmail.com with ESMTPSA id ne9-20020a17090b374900b00233567a978csm3472180pjb.42.2023.02.16.08.37.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Feb 2023 08:37:31 -0800 (PST)
From:   Shigeru Yoshida <syoshida@redhat.com>
To:     jchapman@katalix.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     gnault@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Shigeru Yoshida <syoshida@redhat.com>,
        Cong Wang <cong.wang@bytedance.com>
Subject: [PATCH net v3] l2tp: Avoid possible recursive deadlock in l2tp_tunnel_register()
Date:   Fri, 17 Feb 2023 01:37:10 +0900
Message-Id: <20230216163710.2508327-1-syoshida@redhat.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a file descriptor of pppol2tp socket is passed as file descriptor
of UDP socket, a recursive deadlock occurs in l2tp_tunnel_register().
This situation is reproduced by the following program:

int main(void)
{
	int sock;
	struct sockaddr_pppol2tp addr;

	sock = socket(AF_PPPOX, SOCK_DGRAM, PX_PROTO_OL2TP);
	if (sock < 0) {
		perror("socket");
		return 1;
	}

	addr.sa_family = AF_PPPOX;
	addr.sa_protocol = PX_PROTO_OL2TP;
	addr.pppol2tp.pid = 0;
	addr.pppol2tp.fd = sock;
	addr.pppol2tp.addr.sin_family = PF_INET;
	addr.pppol2tp.addr.sin_port = htons(0);
	addr.pppol2tp.addr.sin_addr.s_addr = inet_addr("192.168.0.1");
	addr.pppol2tp.s_tunnel = 1;
	addr.pppol2tp.s_session = 0;
	addr.pppol2tp.d_tunnel = 0;
	addr.pppol2tp.d_session = 0;

	if (connect(sock, (const struct sockaddr *)&addr, sizeof(addr)) < 0) {
		perror("connect");
		return 1;
	}

	return 0;
}

This program causes the following lockdep warning:

 ============================================
 WARNING: possible recursive locking detected
 6.2.0-rc5-00205-gc96618275234 #56 Not tainted
 --------------------------------------------
 repro/8607 is trying to acquire lock:
 ffff8880213c8130 (sk_lock-AF_PPPOX){+.+.}-{0:0}, at: l2tp_tunnel_register+0x2b7/0x11c0

 but task is already holding lock:
 ffff8880213c8130 (sk_lock-AF_PPPOX){+.+.}-{0:0}, at: pppol2tp_connect+0xa82/0x1a30

 other info that might help us debug this:
  Possible unsafe locking scenario:

        CPU0
        ----
   lock(sk_lock-AF_PPPOX);
   lock(sk_lock-AF_PPPOX);

  *** DEADLOCK ***

  May be due to missing lock nesting notation

 1 lock held by repro/8607:
  #0: ffff8880213c8130 (sk_lock-AF_PPPOX){+.+.}-{0:0}, at: pppol2tp_connect+0xa82/0x1a30

 stack backtrace:
 CPU: 0 PID: 8607 Comm: repro Not tainted 6.2.0-rc5-00205-gc96618275234 #56
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.1-2.fc37 04/01/2014
 Call Trace:
  <TASK>
  dump_stack_lvl+0x100/0x178
  __lock_acquire.cold+0x119/0x3b9
  ? lockdep_hardirqs_on_prepare+0x410/0x410
  lock_acquire+0x1e0/0x610
  ? l2tp_tunnel_register+0x2b7/0x11c0
  ? lock_downgrade+0x710/0x710
  ? __fget_files+0x283/0x3e0
  lock_sock_nested+0x3a/0xf0
  ? l2tp_tunnel_register+0x2b7/0x11c0
  l2tp_tunnel_register+0x2b7/0x11c0
  ? sprintf+0xc4/0x100
  ? l2tp_tunnel_del_work+0x6b0/0x6b0
  ? debug_object_deactivate+0x320/0x320
  ? lockdep_init_map_type+0x16d/0x7a0
  ? lockdep_init_map_type+0x16d/0x7a0
  ? l2tp_tunnel_create+0x2bf/0x4b0
  ? l2tp_tunnel_create+0x3c6/0x4b0
  pppol2tp_connect+0x14e1/0x1a30
  ? pppol2tp_put_sk+0xd0/0xd0
  ? aa_sk_perm+0x2b7/0xa80
  ? aa_af_perm+0x260/0x260
  ? bpf_lsm_socket_connect+0x9/0x10
  ? pppol2tp_put_sk+0xd0/0xd0
  __sys_connect_file+0x14f/0x190
  __sys_connect+0x133/0x160
  ? __sys_connect_file+0x190/0x190
  ? lockdep_hardirqs_on+0x7d/0x100
  ? ktime_get_coarse_real_ts64+0x1b7/0x200
  ? ktime_get_coarse_real_ts64+0x147/0x200
  ? __audit_syscall_entry+0x396/0x500
  __x64_sys_connect+0x72/0xb0
  do_syscall_64+0x38/0xb0
  entry_SYSCALL_64_after_hwframe+0x63/0xcd

This patch fixes the issue by getting/creating the tunnel before
locking the pppol2tp socket.

Fixes: 0b2c59720e65 ("l2tp: close all race conditions in l2tp_tunnel_register()")
Cc: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
---
 net/l2tp/l2tp_ppp.c | 125 ++++++++++++++++++++++++--------------------
 1 file changed, 67 insertions(+), 58 deletions(-)

diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index db2e584c625e..f011af6601c9 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -650,54 +650,22 @@ static int pppol2tp_tunnel_mtu(const struct l2tp_tunnel *tunnel)
 	return mtu - PPPOL2TP_HEADER_OVERHEAD;
 }
 
-/* connect() handler. Attach a PPPoX socket to a tunnel UDP socket
- */
-static int pppol2tp_connect(struct socket *sock, struct sockaddr *uservaddr,
-			    int sockaddr_len, int flags)
+static struct l2tp_tunnel *pppol2tp_tunnel_get(struct net *net,
+					       const struct l2tp_connect_info *info,
+					       bool *new_tunnel)
 {
-	struct sock *sk = sock->sk;
-	struct pppox_sock *po = pppox_sk(sk);
-	struct l2tp_session *session = NULL;
-	struct l2tp_connect_info info;
 	struct l2tp_tunnel *tunnel;
-	struct pppol2tp_session *ps;
-	struct l2tp_session_cfg cfg = { 0, };
-	bool drop_refcnt = false;
-	bool drop_tunnel = false;
-	bool new_session = false;
-	bool new_tunnel = false;
 	int error;
 
-	error = pppol2tp_sockaddr_get_info(uservaddr, sockaddr_len, &info);
-	if (error < 0)
-		return error;
+	*new_tunnel = false;
 
-	lock_sock(sk);
-
-	/* Check for already bound sockets */
-	error = -EBUSY;
-	if (sk->sk_state & PPPOX_CONNECTED)
-		goto end;
-
-	/* We don't supporting rebinding anyway */
-	error = -EALREADY;
-	if (sk->sk_user_data)
-		goto end; /* socket is already attached */
-
-	/* Don't bind if tunnel_id is 0 */
-	error = -EINVAL;
-	if (!info.tunnel_id)
-		goto end;
-
-	tunnel = l2tp_tunnel_get(sock_net(sk), info.tunnel_id);
-	if (tunnel)
-		drop_tunnel = true;
+	tunnel = l2tp_tunnel_get(net, info->tunnel_id);
 
 	/* Special case: create tunnel context if session_id and
 	 * peer_session_id is 0. Otherwise look up tunnel using supplied
 	 * tunnel id.
 	 */
-	if (!info.session_id && !info.peer_session_id) {
+	if (!info->session_id && !info->peer_session_id) {
 		if (!tunnel) {
 			struct l2tp_tunnel_cfg tcfg = {
 				.encap = L2TP_ENCAPTYPE_UDP,
@@ -706,40 +674,82 @@ static int pppol2tp_connect(struct socket *sock, struct sockaddr *uservaddr,
 			/* Prevent l2tp_tunnel_register() from trying to set up
 			 * a kernel socket.
 			 */
-			if (info.fd < 0) {
-				error = -EBADF;
-				goto end;
-			}
+			if (info->fd < 0)
+				return ERR_PTR(-EBADF);
 
-			error = l2tp_tunnel_create(info.fd,
-						   info.version,
-						   info.tunnel_id,
-						   info.peer_tunnel_id, &tcfg,
+			error = l2tp_tunnel_create(info->fd,
+						   info->version,
+						   info->tunnel_id,
+						   info->peer_tunnel_id, &tcfg,
 						   &tunnel);
 			if (error < 0)
-				goto end;
+				return ERR_PTR(error);
 
 			l2tp_tunnel_inc_refcount(tunnel);
-			error = l2tp_tunnel_register(tunnel, sock_net(sk),
-						     &tcfg);
+			error = l2tp_tunnel_register(tunnel, net, &tcfg);
 			if (error < 0) {
 				kfree(tunnel);
-				goto end;
+				return ERR_PTR(error);
 			}
-			drop_tunnel = true;
-			new_tunnel = true;
+
+			*new_tunnel = true;
 		}
 	} else {
 		/* Error if we can't find the tunnel */
-		error = -ENOENT;
 		if (!tunnel)
-			goto end;
+			return ERR_PTR(-ENOENT);
 
 		/* Error if socket is not prepped */
-		if (!tunnel->sock)
-			goto end;
+		if (!tunnel->sock) {
+			l2tp_tunnel_dec_refcount(tunnel);
+			return ERR_PTR(-ENOENT);
+		}
 	}
 
+	return tunnel;
+}
+
+/* connect() handler. Attach a PPPoX socket to a tunnel UDP socket
+ */
+static int pppol2tp_connect(struct socket *sock, struct sockaddr *uservaddr,
+			    int sockaddr_len, int flags)
+{
+	struct sock *sk = sock->sk;
+	struct pppox_sock *po = pppox_sk(sk);
+	struct l2tp_session *session = NULL;
+	struct l2tp_connect_info info;
+	struct l2tp_tunnel *tunnel;
+	struct pppol2tp_session *ps;
+	struct l2tp_session_cfg cfg = { 0, };
+	bool drop_refcnt = false;
+	bool new_session = false;
+	bool new_tunnel = false;
+	int error;
+
+	error = pppol2tp_sockaddr_get_info(uservaddr, sockaddr_len, &info);
+	if (error < 0)
+		return error;
+
+	/* Don't bind if tunnel_id is 0 */
+	if (!info.tunnel_id)
+		return -EINVAL;
+
+	tunnel = pppol2tp_tunnel_get(sock_net(sk), &info, &new_tunnel);
+	if (IS_ERR(tunnel))
+		return PTR_ERR(tunnel);
+
+	lock_sock(sk);
+
+	/* Check for already bound sockets */
+	error = -EBUSY;
+	if (sk->sk_state & PPPOX_CONNECTED)
+		goto end;
+
+	/* We don't supporting rebinding anyway */
+	error = -EALREADY;
+	if (sk->sk_user_data)
+		goto end; /* socket is already attached */
+
 	if (tunnel->peer_tunnel_id == 0)
 		tunnel->peer_tunnel_id = info.peer_tunnel_id;
 
@@ -840,8 +850,7 @@ static int pppol2tp_connect(struct socket *sock, struct sockaddr *uservaddr,
 	}
 	if (drop_refcnt)
 		l2tp_session_dec_refcount(session);
-	if (drop_tunnel)
-		l2tp_tunnel_dec_refcount(tunnel);
+	l2tp_tunnel_dec_refcount(tunnel);
 	release_sock(sk);
 
 	return error;
-- 
2.39.0

