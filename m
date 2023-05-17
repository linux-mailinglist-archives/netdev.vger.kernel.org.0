Return-Path: <netdev+bounces-3197-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 48C5F705F3E
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 07:25:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BF659281517
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 05:25:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBBE8AD2E;
	Wed, 17 May 2023 05:23:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8FFBAD24;
	Wed, 17 May 2023 05:23:12 +0000 (UTC)
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9121B3C25;
	Tue, 16 May 2023 22:22:59 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id 98e67ed59e1d1-24decf5cc03so353008a91.0;
        Tue, 16 May 2023 22:22:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684300978; x=1686892978;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=chnbx0aexE84U6XPaCif+oK0SPIJniesfJ0+4Zw1ypA=;
        b=EOMsNClnAc8cox9uN68QJLq92eUkQF7xHV9V6z8SznSTl6Ibmvre1qnNSnYa1VywV6
         h0uiFRZbSJONtmQyeLF4vqxZnE/jWogsNAERMAthTFtb6tfDwU1IKcxMdkv3EEFuDu8x
         hHFFI/fY2As3J4YJqUlOG5bi9esbCgYDPW9QLmzPP8aDQzcKXz9IPO3ek9kXw6V06m48
         S4aUANE4kbfn1GdhcSbnIqpAnFEblkrj0OXlAj/0iGRuTXt8p9n16yGwMNDwmkoBVvtP
         wQ3GaM7sNCRpyivgSeIhjRU1f+c2EglJD/lZN7yTRit81BSOF4NefRokBcJ7IbIo9BHU
         po9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684300978; x=1686892978;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=chnbx0aexE84U6XPaCif+oK0SPIJniesfJ0+4Zw1ypA=;
        b=BWp3184BjOlP6IfEtdwZChD8Jw/V9X2AF/im3AYp8PzzPdiOVYLg+JVrLxON4aBsiP
         rlCEghmCZe2UMLscHxMc7P2CH+Kdu+F2jUersVric0QKJa6RGqgB7lrKNjBhSqGl+MIb
         WS6fzVKtgsMo0g4ArbyPIZo/YrpfjPVU7paHicH/0cgtN9EvSJ9Ep4s7g8kWc1y3LGoe
         c6XzctiYyRjCusrJOo3bqRmibxEm4VDRORujegwZ+IZCgX7tBIIIyK0fWwyGUValN8RX
         vCwenLYgY3pFDYLgu4hzQKftzZ60UigA9fowdW3FSitxhKDsZ0JeQyOzdB4pZV9pnYCw
         FdMA==
X-Gm-Message-State: AC+VfDzudTz+HRlx32YwTf4w3cDYKbDmrjreROSebx03YzX7Va4mRK2V
	gfgR4IrJaRFCqzQi4qXxlo0=
X-Google-Smtp-Source: ACHHUZ7UbZQL7vqRZguGMCtvprcEmDxVAIIz11hODVG5HsRoJl03FozqH0GsENo+Pc277ULUZ1cAyg==
X-Received: by 2002:a17:90b:33cf:b0:247:2152:6391 with SMTP id lk15-20020a17090b33cf00b0024721526391mr39745751pjb.17.1684300978620;
        Tue, 16 May 2023 22:22:58 -0700 (PDT)
Received: from john.lan ([98.97.37.198])
        by smtp.gmail.com with ESMTPSA id n11-20020a17090a2fcb00b0023cfdbb6496sm581779pjm.1.2023.05.16.22.22.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 22:22:58 -0700 (PDT)
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
Subject: [PATCH bpf v8 05/13] bpf: sockmap, handle fin correctly
Date: Tue, 16 May 2023 22:22:36 -0700
Message-Id: <20230517052244.294755-6-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230517052244.294755-1-john.fastabend@gmail.com>
References: <20230517052244.294755-1-john.fastabend@gmail.com>
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
index ebf917511937..804bd0c247d0 100644
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


