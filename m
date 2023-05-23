Return-Path: <netdev+bounces-4496-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 87D6170D1F3
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 04:59:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 497F61C20C10
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 02:59:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A130BE51;
	Tue, 23 May 2023 02:56:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49CD5C129;
	Tue, 23 May 2023 02:56:37 +0000 (UTC)
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 157B2E0;
	Mon, 22 May 2023 19:56:32 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1ae85b71141so36219375ad.0;
        Mon, 22 May 2023 19:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684810591; x=1687402591;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xp4LbGPkNU6EN2wBzfXws+yiU1Dph6UgcZtiAxf5AYY=;
        b=X1roESqs+aWMANqz1vyFLX4+kbHYcXYHRClEtYho7oy+mcxCEkqf7pC2+ZmX7Rz/BY
         6nORmVlqsgy+lHoCny/EMFxFN9X1/9hwEqK9PB1xyA5XaIJiDFdR3EVlvmmGeUiKeNzA
         fmzmzvw7c9nUu2leiJPCJ6EKPdQ9oOh9qjgRgbwAcpvConhYYLBDqptNcY0e1068tw4C
         a8OMRD+0fWCScej2NBAsuOME7bOOYS+VVwPC+lYrNhV6USMDy77WZNf5IzDYtkofEUyE
         JYQ+AhSoCDxF6BzHWnweXTcOnzZGP8e5EVnPyzczZzs2w6NFqiOMrUePJAH86TDewZap
         Dssg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684810591; x=1687402591;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xp4LbGPkNU6EN2wBzfXws+yiU1Dph6UgcZtiAxf5AYY=;
        b=jttjE+NtLxUWNKojQemkgs+47XWJ20r9cANFt/S94vWottM8mreXZvtcR6Pvc/4X7g
         Uw8sMsUzLvYNoeUPBVZVIfWNZ3rdcZouOqYkl8kCzyrA8T9mKoLUzI3lM7mwPbwQ2h2k
         IyVnc6vBM1thuJkm40sZ9OvYsSTxDHoIH8anq7XY/RgfCrveHNmvIbhNTid7FEED2rtz
         SougUB87DJil464lMIIAW/cZz6OSeB8cHxT/1/QfgK1i+UQ9n+lKlViohXxoz8+AT45/
         GWSuyf9qwU4duCyeVuxooQBvThu8c57TjAmbSIJl+/OUwj7nM4wwVU7cSlGsmgLXM/yG
         hbvw==
X-Gm-Message-State: AC+VfDy6lezS/fmy094PA67y1REKRHbko9EeT8YbwHVf9e5+iCRtRa3a
	xMd9nqG+GpU3s46rRF1iKsc=
X-Google-Smtp-Source: ACHHUZ7F/yWscFhYJQUQm7JAA5B7V0yzQuX3UbtOpBWYHP8R7lvZlQoMzbjzN6zCN4FqFa1aXMZ35Q==
X-Received: by 2002:a17:902:f2cc:b0:1ac:72ff:9853 with SMTP id h12-20020a170902f2cc00b001ac72ff9853mr10480838plc.30.1684810591274;
        Mon, 22 May 2023 19:56:31 -0700 (PDT)
Received: from john.lan ([2605:59c8:148:ba10:82a6:5b19:9c99:3aad])
        by smtp.gmail.com with ESMTPSA id h10-20020a170902748a00b001a67759f9f8sm5508285pll.106.2023.05.22.19.56.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 19:56:30 -0700 (PDT)
From: John Fastabend <john.fastabend@gmail.com>
To: jakub@cloudflare.com,
	daniel@iogearbox.net
Cc: john.fastabend@gmail.com,
	bpf@vger.kernel.org,
	netdev@vger.kernel.org,
	edumazet@google.com,
	ast@kernel.org,
	andrii@kernel.org,
	will@isovalent.com
Subject: [PATCH bpf v10 06/14] bpf: sockmap, TCP data stall on recv before accept
Date: Mon, 22 May 2023 19:56:10 -0700
Message-Id: <20230523025618.113937-7-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230523025618.113937-1-john.fastabend@gmail.com>
References: <20230523025618.113937-1-john.fastabend@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

A common mechanism to put a TCP socket into the sockmap is to hook the
BPF_SOCK_OPS_{ACTIVE_PASSIVE}_ESTABLISHED_CB event with a BPF program
that can map the socket info to the correct BPF verdict parser. When
the user adds the socket to the map the psock is created and the new
ops are assigned to ensure the verdict program will 'see' the sk_buffs
as they arrive.

Part of this process hooks the sk_data_ready op with a BPF specific
handler to wake up the BPF verdict program when data is ready to read.
The logic is simple enough (posted here for easy reading)

 static void sk_psock_verdict_data_ready(struct sock *sk)
 {
	struct socket *sock = sk->sk_socket;

	if (unlikely(!sock || !sock->ops || !sock->ops->read_skb))
		return;
	sock->ops->read_skb(sk, sk_psock_verdict_recv);
 }

The oversight here is sk->sk_socket is not assigned until the application
accepts() the new socket. However, its entirely ok for the peer application
to do a connect() followed immediately by sends. The socket on the receiver
is sitting on the backlog queue of the listening socket until its accepted
and the data is queued up. If the peer never accepts the socket or is slow
it will eventually hit data limits and rate limit the session. But,
important for BPF sockmap hooks when this data is received TCP stack does
the sk_data_ready() call but the read_skb() for this data is never called
because sk_socket is missing. The data sits on the sk_receive_queue.

Then once the socket is accepted if we never receive more data from the
peer there will be no further sk_data_ready calls and all the data
is still on the sk_receive_queue(). Then user calls recvmsg after accept()
and for TCP sockets in sockmap we use the tcp_bpf_recvmsg_parser() handler.
The handler checks for data in the sk_msg ingress queue expecting that
the BPF program has already run from the sk_data_ready hook and enqueued
the data as needed. So we are stuck.

To fix do an unlikely check in recvmsg handler for data on the
sk_receive_queue and if it exists wake up data_ready. We have the sock
locked in both read_skb and recvmsg so should avoid having multiple
runners.

Fixes: 04919bed948dc ("tcp: Introduce tcp_read_skb()")
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/ipv4/tcp_bpf.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 73c13642d47f..01dd76be1a58 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -212,6 +212,26 @@ static int tcp_bpf_recvmsg_parser(struct sock *sk,
 		return tcp_recvmsg(sk, msg, len, flags, addr_len);
 
 	lock_sock(sk);
+
+	/* We may have received data on the sk_receive_queue pre-accept and
+	 * then we can not use read_skb in this context because we haven't
+	 * assigned a sk_socket yet so have no link to the ops. The work-around
+	 * is to check the sk_receive_queue and in these cases read skbs off
+	 * queue again. The read_skb hook is not running at this point because
+	 * of lock_sock so we avoid having multiple runners in read_skb.
+	 */
+	if (unlikely(!skb_queue_empty(&sk->sk_receive_queue))) {
+		tcp_data_ready(sk);
+		/* This handles the ENOMEM errors if we both receive data
+		 * pre accept and are already under memory pressure. At least
+		 * let user know to retry.
+		 */
+		if (unlikely(!skb_queue_empty(&sk->sk_receive_queue))) {
+			copied = -EAGAIN;
+			goto out;
+		}
+	}
+
 msg_bytes_ready:
 	copied = sk_msg_recvmsg(sk, psock, msg, len, flags);
 	/* The typical case for EFAULT is the socket was gracefully
-- 
2.33.0


