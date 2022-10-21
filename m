Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7216074E4
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 12:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbiJUKS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 06:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231167AbiJUKSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 06:18:44 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FD9625D66C;
        Fri, 21 Oct 2022 03:18:39 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id bg9-20020a05600c3c8900b003bf249616b0so1652069wmb.3;
        Fri, 21 Oct 2022 03:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YFGZLS7Na8k6WOdiyoxTx78eZiB1yoNR/NfyuPKeoNw=;
        b=GS939ykh70x0f5EIYYk8lEd0n2d+AIeP1VZA7Q9oYrrZZgrUD80hg9NIBmIK93rWdi
         ImzxlIo8iclXkpLE1n1OedcpvoD8J+dDRi1TuU9nnHx8S9ax3mFC+4FgSRLyhysAB4vy
         KUT+Ek7xVn5Q1FnFHsbK+fZcdQk9KaDeIMzkmNJWyNP8mq0FrydPw0VDjPbV85eU+9yQ
         YH8YLy2FWc4dxc0IwW4qfdEZXVTaH6KlL80XXpPcWCtY43WBGKGe8vmEqG6fXOb+G5bc
         Q8mGo6isIGqTow1+ozHyoXZzMcE6kp6hnYN+Q6jq1H7OlhwuJQBJKZYdy5ilSkaecwyK
         QWxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YFGZLS7Na8k6WOdiyoxTx78eZiB1yoNR/NfyuPKeoNw=;
        b=LZZVS+KSWPb+7abj/4YlGze8w3ADFXi0f3M03y73JvYIfaCpl38lAfwMvDzW8kYfN1
         nJeAtLqV1ozlBHoWxu2I3qVMM1o2xEmVt3RP5x4sO49VHnIq4pU4/nrX1eo2jPNwL6+f
         nWdauudDn8xl/SAs99U4dk88jnbLnkcFlbrDc/90dty+54xZ8gp9UZvdtwFVUoeCo/vP
         IOjIJ25mvw9N4ogkJj90WoVOKlZzK2EDb+ClFzD3jXqLl7ntcCFFxmSybvZvodubSi1L
         GQfYvWmWu/IwNKVq+TIaaMIwyfChR/CUcwBCW9fjaZDQzxVFNYX1brYAf3f6hdmP5ucW
         JmJQ==
X-Gm-Message-State: ACrzQf1fmPlRtLmIdEp3PYEmpdCPNTACdfugC2iWbiAYPOvBJvAzKvUT
        NgS5fpuq51RyFDAiS4V4dHA=
X-Google-Smtp-Source: AMsMyM7SNgaJuRQkrZB19yur58rRdWLcLGXVr2ZmAOerojd99u8bQkOJP90LCLoH98abzYJvSHp5UQ==
X-Received: by 2002:a1c:27c6:0:b0:3c2:e6df:c79b with SMTP id n189-20020a1c27c6000000b003c2e6dfc79bmr32179622wmn.14.1666347517669;
        Fri, 21 Oct 2022 03:18:37 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:f27e])
        by smtp.gmail.com with ESMTPSA id ba3-20020a0560001c0300b002365254ea42sm1565184wrb.1.2022.10.21.03.18.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 03:18:36 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     io-uring@vger.kernel.org, asml.silence@gmail.com,
        netdev@vger.kernel.org, Stefan Metzmacher <metze@samba.org>
Subject: [PATCH for-6.1 1/3] net: flag sockets supporting msghdr originated zerocopy
Date:   Fri, 21 Oct 2022 11:16:39 +0100
Message-Id: <3dafafab822b1c66308bb58a0ac738b1e3f53f74.1666346426.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <cover.1666346426.git.asml.silence@gmail.com>
References: <cover.1666346426.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need an efficient way in io_uring to check whether a socket supports
zerocopy with msghdr provided ubuf_info. Add a new flag into the struct
socket flags fields.

Cc: <stable@vger.kernel.org> # 6.0
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/net.h | 1 +
 net/ipv4/tcp.c      | 1 +
 net/ipv4/udp.c      | 1 +
 3 files changed, 3 insertions(+)

diff --git a/include/linux/net.h b/include/linux/net.h
index 711c3593c3b8..18d942bbdf6e 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -41,6 +41,7 @@ struct net;
 #define SOCK_NOSPACE		2
 #define SOCK_PASSCRED		3
 #define SOCK_PASSSEC		4
+#define SOCK_SUPPORT_ZC		5
 
 #ifndef ARCH_HAS_SOCKET_TYPES
 /**
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 0c51abeee172..aeb7b9eaddc7 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -457,6 +457,7 @@ void tcp_init_sock(struct sock *sk)
 	WRITE_ONCE(sk->sk_sndbuf, READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_wmem[1]));
 	WRITE_ONCE(sk->sk_rcvbuf, READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_rmem[1]));
 
+	set_bit(SOCK_SUPPORT_ZC, &sk->sk_socket->flags);
 	sk_sockets_allocated_inc(sk);
 }
 EXPORT_SYMBOL(tcp_init_sock);
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index d63118ce5900..03616fc5162c 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1620,6 +1620,7 @@ int udp_init_sock(struct sock *sk)
 {
 	skb_queue_head_init(&udp_sk(sk)->reader_queue);
 	sk->sk_destruct = udp_destruct_sock;
+	set_bit(SOCK_SUPPORT_ZC, &sk->sk_socket->flags);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(udp_init_sock);
-- 
2.38.0

