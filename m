Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73BD46C3D07
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 22:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbjCUVw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 17:52:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbjCUVwZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 17:52:25 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 375B0442CC;
        Tue, 21 Mar 2023 14:52:24 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id j3-20020a17090adc8300b0023d09aea4a6so21759142pjv.5;
        Tue, 21 Mar 2023 14:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679435544;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y5tqObSMAtHNVK29HuvTPLgGUtx1E+Ad7BIcyyykhH0=;
        b=HScSEp5FMnWxC576elCb1Yu4r4jc7IgYJuU7qloJz++LeYaiebwp1UfQvEMziql2xH
         wr+d4OWe1/OJipHKnBYpjMg+PYv/uqEl2KojQ6GkU14H2cXir8jNmbNcn7byuvnHOZaK
         A3cHZv7Nxydsdi6e4Av01vVdkEuoV9Rgip7oGMiEOoHHaKzYpgaZ91cK4lzTmkZStdPJ
         OW5TJ1jKV1ezyPFfrzRnrxi1fldqxFEyZd3ChZSaWmk8jelsLBdrOdhxUqHfQowPqd6P
         eFMJFoGxnaiGZ1kTDUSM4DYRiacZO0hH2gFRa2X/hQ0I8dX0rxMB21ma/B6rNaIvd/jU
         WsxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679435544;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y5tqObSMAtHNVK29HuvTPLgGUtx1E+Ad7BIcyyykhH0=;
        b=fLx6FFzDWWH/yphW2D74ziD1R2NceJ3n8e8TUh7GzjVxUF83OJx/bSGFCqe8Mp4Rc7
         G+6hm9/kKuArfD8ZW3ourWidvZ1SOPviKzGhh0JQS6oHgg9pUVk4ianFwnbWVvfTfx05
         6If8875PgOo3En61sSD2KsGIqQr3Gt32ZMWy6QHdIDIsEKaP/LhJ4HYy+0KzxLxGQsfv
         vANVNHQl9L41v7a5O9gfBU/nm1k7inrs++Ftv7yeRGHUO3+ViOZzGRyKiKw2nMvIMTrU
         AwY1/l1ZcizKBI0fBjnF5mggHX+5IWf6sjKttKTwM4T/EaK+lqMBmlHHtvSIyS0Z5wTp
         KREg==
X-Gm-Message-State: AO0yUKXDUo9vfs0c3iW37TQ+JHy6zQWrKu+QYs02c/luI8kq+VV8Rop+
        pEj62TBM10aEvYFbW5L8Bco=
X-Google-Smtp-Source: AK7set/pjEdwZ0m5HPLZDTDbny/Sj4QbmUyYy0MvWDnuuJMu4PcjpV3QoOXdgyIsb4xQ9lvcw9/D+g==
X-Received: by 2002:a05:6a20:8b05:b0:d9:5db:7345 with SMTP id l5-20020a056a208b0500b000d905db7345mr3180458pzh.26.1679435543849;
        Tue, 21 Mar 2023 14:52:23 -0700 (PDT)
Received: from john.lan ([98.97.36.54])
        by smtp.gmail.com with ESMTPSA id m3-20020a63fd43000000b004facdf070d6sm8661331pgj.39.2023.03.21.14.52.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 14:52:23 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub@cloudflare.com, daniel@iogearbox.net, lmb@isovalent.com,
        cong.wang@bytedance.com
Cc:     bpf@vger.kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, edumazet@google.com, ast@kernel.org,
        andrii@kernel.org, will@isovalent.com
Subject: [PATCH bpf 04/11] bpf: sockmap, handle fin correctly
Date:   Tue, 21 Mar 2023 14:52:05 -0700
Message-Id: <20230321215212.525630-5-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230321215212.525630-1-john.fastabend@gmail.com>
References: <20230321215212.525630-1-john.fastabend@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/ipv4/tcp_bpf.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index cf26d65ca389..3a0f43f3afd8 100644
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
@@ -193,6 +211,19 @@ static int tcp_bpf_recvmsg_parser(struct sock *sk,
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

