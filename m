Return-Path: <netdev+bounces-2695-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 202E9703258
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 18:08:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 248471C20BB5
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 16:08:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD268E578;
	Mon, 15 May 2023 16:08:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF3EE574
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 16:08:45 +0000 (UTC)
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 859AE19BA;
	Mon, 15 May 2023 09:08:26 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a640c23a62f3a-9661047f8b8so1997767766b.0;
        Mon, 15 May 2023 09:08:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684166871; x=1686758871;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7q0UcurCQuSrsWYVJZvWTx8sSO/ocIRDuJSAioMoYTw=;
        b=qOKqb9XUz1rLU2EfTRI1MtKc0o+FKAJHpve7/wAB3hskLZtEpFqbxbHNkHUgvjKKPv
         +m+cZP/KmqtlozpvtJ6QIu2yDtECEJ1VgqPAu42qs7WxNSfc9sym5HWA9lXqwPwTPU5l
         vs5Y17MT3CAiqdqOwRs4Kv8YRKtnxfVrajfgdzJDntV2BMNuw92KqYbhRMKAGfbflaOG
         kt03jlWvUoIfUUexgGMBMkD2uWuH88E0XKCzpiH/s3EVs3Yd81xhG3ZkugAu/qsJEQcW
         Z/rC0cfD8AqQRlTtyqpZxewULPtIY3mYGi1I4vTBM7xGUMum6ZvdjWNNTLLe1eWyZ4GK
         /l6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684166871; x=1686758871;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7q0UcurCQuSrsWYVJZvWTx8sSO/ocIRDuJSAioMoYTw=;
        b=SEyYSpkLTTLHx+k61pAecfrMSahNrSTj+Doc4sVy3QKO0ZDagaVHqU6/9gj3YH//5D
         vThJWidyjxHf4EGEd0H0Zr5x1rUIfpiYdj03qWitM+bEMr56eeD+C0Ll4mcpNyJzoPAF
         TzCQ4cMoLwFcv2XfEzCCGzM4jE0CgpbU/6pUsXRRhSBozcQM9Y32jfIfBrNVoAg8CwCH
         Y0HU6ZyfttUjTso/lHHL0j9YFBWJPL/MnhbQcuIFUQYoQnZ6kUC1+M9R0DEl2SypRwot
         5LJTLylBBAzeyTDzfu02zxi94F758PZk8Hd5/NalDRGbEVVHTQvv5CSrNB9YXz6uEmlk
         V5vg==
X-Gm-Message-State: AC+VfDzYaNNWjtsTZu3dFu+ci3mhSL6eJ+62y3JTRbXgg0YYhSCZAy04
	s5ltUmPIUn/IS+flE1XV1ri6LhJn+yE=
X-Google-Smtp-Source: ACHHUZ4dKldiscJ3eDa7mSfcvyHAbvYnBZX+b77H3OOBD/Pi9h9+DZndXF4SRAL9NzeGtm16L0K5EQ==
X-Received: by 2002:a17:906:99c4:b0:94e:4c8f:758 with SMTP id s4-20020a17090699c400b0094e4c8f0758mr30748732ejn.76.1684166870543;
        Mon, 15 May 2023 09:07:50 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:6366])
        by smtp.gmail.com with ESMTPSA id z25-20020a17090674d900b0096ac3e01a35sm4407085ejl.130.2023.05.15.09.07.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 May 2023 09:07:50 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org,
	edumazet@google.com,
	davem@davemloft.net,
	dsahern@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 1/2] net/tcp: don't peek at tail for io_uring zc
Date: Mon, 15 May 2023 17:06:36 +0100
Message-Id: <d49262a8a39c995cd55f89d1f6fd39cd4346f528.1684166247.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1684166247.git.asml.silence@gmail.com>
References: <cover.1684166247.git.asml.silence@gmail.com>
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

Move tcp_write_queue_tail() to SOCK_ZEROCOPY specific flag as zerocopy
setup for msghdr->ubuf_info doesn't need to peek into the last request.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv4/tcp.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 4d6392c16b7a..40f591f7fce1 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1229,13 +1229,12 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 	flags = msg->msg_flags;
 
 	if ((flags & MSG_ZEROCOPY) && size) {
-		skb = tcp_write_queue_tail(sk);
-
 		if (msg->msg_ubuf) {
 			uarg = msg->msg_ubuf;
 			net_zcopy_get(uarg);
 			zc = sk->sk_route_caps & NETIF_F_SG;
 		} else if (sock_flag(sk, SOCK_ZEROCOPY)) {
+			skb = tcp_write_queue_tail(sk);
 			uarg = msg_zerocopy_realloc(sk, size, skb_zcopy(skb));
 			if (!uarg) {
 				err = -ENOBUFS;
-- 
2.40.0


