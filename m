Return-Path: <netdev+bounces-3804-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 97F23708E98
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 06:09:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 53EB728179D
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 04:09:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C456863C;
	Fri, 19 May 2023 04:07:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63AA3D78;
	Fri, 19 May 2023 04:07:12 +0000 (UTC)
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3174FE72;
	Thu, 18 May 2023 21:07:11 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-64d24136685so298337b3a.1;
        Thu, 18 May 2023 21:07:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684469231; x=1687061231;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1X8MavyMxt9ea7RvB7abRtbZx5QchGwJbc+sm6sp6gI=;
        b=hOwECO3gcvWe89i8a5T8D6FdIdAd/t+bTWTcC5aFGd8NVjFqFfBm1zSa+1JH+IvTRs
         ym8oEsNLaNoVfBqVNw+Qk1j1IEqJy0bp5Ubx8iR63xLPGNnHzllPxNFybEuVvamjfj5L
         V4kvWlgi/oKdX31vj+GG/zArpo18y1Q5oEYL7cJRmM2Fi4Yy62XghutLiy/VuRJ7vMVy
         /G3jXTIaDEz7212aPHqZZzb1GRBLfCX6opj9ucJqZ0IKC8G+i4+NwND7WBHe7qphZWGh
         hF9qxAm/bD3BCKAkmvhH1gOhlKn6MwAvVN8glcTSYO8ivEejk/e15FwbAIgb90LgKLK8
         gDLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684469231; x=1687061231;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1X8MavyMxt9ea7RvB7abRtbZx5QchGwJbc+sm6sp6gI=;
        b=ArTl9iu5ZgAMq2rhNhhEUXvZAr4rk+qUYFvrE4j/NVicFI7poGncXqSzkrjJqVelr8
         N8OncJXxaH7MUf8bqD6UCk2SlyyBd4Kr/r+bu4XsgwzTB5JUHWXd6Et3ZivDyVgjrzKb
         gS4s6FlfYBjc/BLVVpXm75tmQrdyEhWE+0FtxRnul+1Yj2mWTaFzDHPsPTg3ADcD8KiG
         rqhEuBo/9nzH7RCjha6CVwgyVImb85v4p8b0lYAEFgZ9KfZiVjoPrLFhqKMIS76q9X4K
         dHYKnUPrNFPX9h/VCdNN2ehn9f5k+TLV7cA+w8ejKg8kkpeEnUhUtlcjxyQj2glAUsEZ
         jWNA==
X-Gm-Message-State: AC+VfDxeLMwZCeTd41sOVqMJxEvW2aMo4Us2YYJGc3towJxS2aaqkURg
	ZwXPpNvMtQGegvvSep8LRWNw5MM+Cds=
X-Google-Smtp-Source: ACHHUZ58CEaACgGkAm217vDl+4vVFp7Nudv+G7Bgc8aINHlMTNLt8T9sMzzd+dqemad9k/nvNTTlQA==
X-Received: by 2002:a05:6a20:8e29:b0:101:281c:494 with SMTP id y41-20020a056a208e2900b00101281c0494mr1616178pzj.27.1684469230718;
        Thu, 18 May 2023 21:07:10 -0700 (PDT)
Received: from john.lan ([2605:59c8:148:ba10:706:628a:e6ce:c8a9])
        by smtp.gmail.com with ESMTPSA id x11-20020aa784cb000000b00625d84a0194sm434833pfn.107.2023.05.18.21.07.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 21:07:10 -0700 (PDT)
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
Subject: [PATCH bpf v9 05/14] bpf: sockmap, handle fin correctly
Date: Thu, 18 May 2023 21:06:50 -0700
Message-Id: <20230519040659.670644-6-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230519040659.670644-1-john.fastabend@gmail.com>
References: <20230519040659.670644-1-john.fastabend@gmail.com>
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


