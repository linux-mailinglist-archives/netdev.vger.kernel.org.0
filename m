Return-Path: <netdev+bounces-4494-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B78E670D1ED
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 04:58:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8863E1C20C6E
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 02:58:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35F6FBA3E;
	Tue, 23 May 2023 02:56:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2188CBA3A;
	Tue, 23 May 2023 02:56:32 +0000 (UTC)
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37C72CA;
	Mon, 22 May 2023 19:56:30 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 41be03b00d2f7-51f1b6e8179so4800846a12.3;
        Mon, 22 May 2023 19:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684810589; x=1687402589;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1X8MavyMxt9ea7RvB7abRtbZx5QchGwJbc+sm6sp6gI=;
        b=fbcv3eWbWfOQ8G2DHCfVDBgYgHhv+c8mVnUevD0YHwHDoQ11EbCpWoKK3zsjSGLg+o
         RjNlJ8qXfiiBo8h5CpmqlZ6qqnOHEzdmCYNsYevU0JlHNR8SDgyVJ8It+aWrZob/cHcv
         RKLMVo6aa/yTqdiyzl3ajuozwuEDn4Go7EHYcOHuiIezkT8p0g73gNSzd/keIiNwcRrY
         MVzTIKJWBg4MUyvyWkfVf6485ehv/9J57MTpNtWXC9SZQ7sGRw4Vs9kjfdgeR1vabz+d
         G7Tjhix1HoBVoEz6xmZVhFdVVLxMf/Af5cEKiR/sxqkkGOxpwFyUczb3F+oKhlbnocBd
         SRsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684810589; x=1687402589;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1X8MavyMxt9ea7RvB7abRtbZx5QchGwJbc+sm6sp6gI=;
        b=FcLClSlGPS8/Yon/yzgJY97etyEUE8SO/sS9/OgFWMoBe0/vVB0UprCs5NC6q1X28L
         9RH4e2vrU5HX9mCGVwvL9Y5JCL0okkb1pfPSZr8b95Te3oTRTUrW9cR8QX8hEy0rVwHB
         nHbFd3LJEXWVTRUXLvNsziQhp+mznsZMspYxcePpAjuzzcIXAvBS+p+/GeMmnBbj0K/X
         w0r4eN0yosz0pZ/YqnnMtVF9h8SbhfJaD9LH7OVf6HnLamhR5pGrfgoZuFqT3qIfJLHa
         X7FPlLJr+GIFYqB8em8/jQLK0pyUMkP+6Hx4OS61zue6KCcqzPLqB+lUWLs6U5jbLpCL
         rUeg==
X-Gm-Message-State: AC+VfDyEqY6+uEUbdVSXZV7WLqXOWwyqlElRmAAPtZJ8H8HuQ2f/VWlT
	HtJTNqLzjqHqrM4EC2ERqho=
X-Google-Smtp-Source: ACHHUZ4t5bPlcj8XxkeuxCbbb5+12p5YVwFNrXDzn2il+ZyWPtQfnpAc5aYUNUeghGqFaVNH2ouG4w==
X-Received: by 2002:a17:903:24c:b0:1ac:3ddf:2299 with SMTP id j12-20020a170903024c00b001ac3ddf2299mr14341990plh.44.1684810589656;
        Mon, 22 May 2023 19:56:29 -0700 (PDT)
Received: from john.lan ([2605:59c8:148:ba10:82a6:5b19:9c99:3aad])
        by smtp.gmail.com with ESMTPSA id h10-20020a170902748a00b001a67759f9f8sm5508285pll.106.2023.05.22.19.56.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 19:56:29 -0700 (PDT)
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
Subject: [PATCH bpf v10 05/14] bpf: sockmap, handle fin correctly
Date: Mon, 22 May 2023 19:56:09 -0700
Message-Id: <20230523025618.113937-6-john.fastabend@gmail.com>
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

The sockmap code is returning EAGAIN after a FIN packet is received and no
more data is on the receive queue. Correct behavior is to return 0 to the
user and the user can then close the socket. The EAGAIN causes many apps
to retry which masks the problem. Eventually the socket is evicted from
the sockmap because its released from sockmap sock free handling. The
issue creates a delay and can cause some errors on application side.

To fix this check on sk_msg_recvmsg side if length is zero and FIN flag
is set then set return to zero. A selftest will be added to check this
condition.

Fixes: 04919bed948dc ("tcp: Introduce tcp_read_skb()")
Tested-by: William Findlay <will@isovalent.com>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/ipv4/tcp_bpf.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 2e9547467edb..73c13642d47f 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -174,6 +174,24 @@ static int tcp_msg_wait_data(struct sock *sk, struct sk_psock *psock,
 	return ret;
 }
 
+static bool is_next_msg_fin(struct sk_psock *psock)
+{
+	struct scatterlist *sge;
+	struct sk_msg *msg_rx;
+	int i;
+
+	msg_rx = sk_psock_peek_msg(psock);
+	i = msg_rx->sg.start;
+	sge = sk_msg_elem(msg_rx, i);
+	if (!sge->length) {
+		struct sk_buff *skb = msg_rx->skb;
+
+		if (skb && TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN)
+			return true;
+	}
+	return false;
+}
+
 static int tcp_bpf_recvmsg_parser(struct sock *sk,
 				  struct msghdr *msg,
 				  size_t len,
@@ -196,6 +214,19 @@ static int tcp_bpf_recvmsg_parser(struct sock *sk,
 	lock_sock(sk);
 msg_bytes_ready:
 	copied = sk_msg_recvmsg(sk, psock, msg, len, flags);
+	/* The typical case for EFAULT is the socket was gracefully
+	 * shutdown with a FIN pkt. So check here the other case is
+	 * some error on copy_page_to_iter which would be unexpected.
+	 * On fin return correct return code to zero.
+	 */
+	if (copied == -EFAULT) {
+		bool is_fin = is_next_msg_fin(psock);
+
+		if (is_fin) {
+			copied = 0;
+			goto out;
+		}
+	}
 	if (!copied) {
 		long timeo;
 		int data;
-- 
2.33.0


