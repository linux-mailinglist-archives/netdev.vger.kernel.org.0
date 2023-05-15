Return-Path: <netdev+bounces-2696-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 813A170325A
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 18:09:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 441DE28138E
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 16:09:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5A19FBE0;
	Mon, 15 May 2023 16:08:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3F9E57B
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 16:08:45 +0000 (UTC)
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BBCF1A6;
	Mon, 15 May 2023 09:08:26 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a640c23a62f3a-96622bca286so2064105866b.1;
        Mon, 15 May 2023 09:08:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684166871; x=1686758871;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ejyfMm8PiNjAatlyZsU/FcNZmfv1YS8CXmWsR9TedAY=;
        b=RP9zl57eRXaJg+tHh/ej0tgO0dqGXLstSguoMLaKrbsHy2ltMWZuOUfjvhaRXpclgJ
         WCyIK2ke5jSXIcMoBVIDfPgMdgzKs49zOfgB9QpOmlsFMNviJ2M7MK4AtzpgxYfp4dxb
         1TCZm/Kb3wIFyr6lnKMCKMNXPeduAQTuCDSHXcPXSn4zJcIlKYtGY7dEbJDN2dZnAoNf
         ALYJ1O3sdO980GUBnMhspFNxf1R+ssffgl9lACSRSnv2pblQAELMtdGCxHawXhXc6rle
         ytkfksPBIiEDY5cDxZ5/zuBNzf4J6jPueJXEeQi9/KtZyNQJlB6RXd859zp4rsWCMPni
         zA4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684166871; x=1686758871;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ejyfMm8PiNjAatlyZsU/FcNZmfv1YS8CXmWsR9TedAY=;
        b=KZD4V0kJgp5cZqONAyup/gsc43n/zVDN60rq4F2wCykUy4D1ztZaAN/pd0S/zFT5aB
         cdGu7RKAbQbI5wSuGKaSiXs1N2oVtXiDPL/Vc2WYaS5OQ3Pl+86o574RxCaj4b3jyb9Y
         Wojw55O4x6R5MgV502bzNZgsnMCMljRy0FchjYL0ivKm+1UoV8fgpW/Go+N60iAfEGh1
         N0la+dHxHCUJmuWmPHkKvklSzeQ/wbnKkP8N/WJQT4NMN4xmbFtYQnQLntd7gq5xektE
         uNbqmbBLEntPGZwT4ENQo14SUaTLB+R0BPhRJlzGDXlIHWAgqFoRQ6THSaDMO0DCAX7l
         ovcA==
X-Gm-Message-State: AC+VfDyEcTfvqkUEa581l54Jjg4rbxoP4tg2vcAqD2t3otd2y15im1Ws
	ntXIdZgMAHL6csqyhSCE40/ZAxRAhMg=
X-Google-Smtp-Source: ACHHUZ6a8FAXsnDXpOjqGQqp9T0z+boTouSr45GJfWH8cougV4C0YqY1dqp3NGFciY4kBYDKj0veeg==
X-Received: by 2002:a17:907:360d:b0:94a:7979:41f5 with SMTP id bk13-20020a170907360d00b0094a797941f5mr28797874ejc.71.1684166871136;
        Mon, 15 May 2023 09:07:51 -0700 (PDT)
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
Subject: [PATCH net-next 2/2] net/tcp: optimise io_uring zc ubuf refcounting
Date: Mon, 15 May 2023 17:06:37 +0100
Message-Id: <bdbbff06f20c100c00e59932ffecbd18ad699f57.1684166247.git.asml.silence@gmail.com>
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

io_uring keeps a reference to ubuf_info during submission, so if
tcp_sendmsg_locked() sees msghdr::msg_ubuf in can be sure the buffer
will be kept alive and doesn't need to additionally pin it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv4/tcp.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 40f591f7fce1..3d18e295bb2f 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1231,7 +1231,6 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 	if ((flags & MSG_ZEROCOPY) && size) {
 		if (msg->msg_ubuf) {
 			uarg = msg->msg_ubuf;
-			net_zcopy_get(uarg);
 			zc = sk->sk_route_caps & NETIF_F_SG;
 		} else if (sock_flag(sk, SOCK_ZEROCOPY)) {
 			skb = tcp_write_queue_tail(sk);
@@ -1458,7 +1457,9 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 		tcp_push(sk, flags, mss_now, tp->nonagle, size_goal);
 	}
 out_nopush:
-	net_zcopy_put(uarg);
+	/* msg->msg_ubuf is pinned by the caller so we don't take extra refs */
+	if (uarg && !msg->msg_ubuf)
+		net_zcopy_put(uarg);
 	return copied + copied_syn;
 
 do_error:
@@ -1467,7 +1468,9 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 	if (copied + copied_syn)
 		goto out;
 out_err:
-	net_zcopy_put_abort(uarg, true);
+	/* msg->msg_ubuf is pinned by the caller so we don't take extra refs */
+	if (uarg && !msg->msg_ubuf)
+		net_zcopy_put_abort(uarg, true);
 	err = sk_stream_error(sk, flags, err);
 	/* make sure we wake any epoll edge trigger waiter */
 	if (unlikely(tcp_rtx_and_write_queues_empty(sk) && err == -EAGAIN)) {
-- 
2.40.0


