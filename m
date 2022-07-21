Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82C3857D4FA
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 22:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233214AbiGUUoT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 16:44:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiGUUoS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 16:44:18 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44E8D8F510
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 13:44:17 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-31cb93cadf2so23732627b3.11
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 13:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=O+QEbeLs+S11i4hxClCoDMOaRhSL/W2i8PbaqDDW9cA=;
        b=OFJs6l/46tgihL5dHLtxWsfc2EXRmeL/msZGLmANWhICdw0Ru8kZFpkeJy4XVfLK/F
         FsrqsvJchbf8CsUG164rc2aMx6kios8Pf/33HzcVuhCXRSOVShP+i/ZOrwDw9nAHCX6Y
         DFiRKgi/FYYdQfHBt2C9QEk5eLWGMXw5Vw/alHmEf2M7tFmHiYoZyqclnw7NCOPVQitx
         q4ul72Uyyev/bmOdi2YST8etddxOm45U9xIr0unuwxSGRedCWKB+F5nKbTyWd2o8qcEz
         Wv5BYDf4MHib9y7KMWAko7rKikBdJ6H9Bz3hrmuFzhfjZS0bae+ny26u8+eXVMhSsYdv
         s5Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=O+QEbeLs+S11i4hxClCoDMOaRhSL/W2i8PbaqDDW9cA=;
        b=iKLpf56u/3dVKtMQ/g0kUKbCC1fh9WY58cwLN4O+v0jUhf7P6Y8Lc3xd69KGMwT5tQ
         KMqtQ34pDhwOlu8DFZ5K6a/80N93Wl42odbKcXs9vT3P4NJjAi8fobRel6Or69YUsQVn
         F+MFmOrsT2+B0ePymXYITN4MRTLoexWFVkcNEE81NRKdYn3lG19+CVI7QAz/ro8uQkAZ
         u8wAD5E6AdscxNZb6WYk08HcDWrbTFouYIBR3M0p4dnSUuBCh+g9JELUYpsI44NdlofO
         Jp1aL94A4wPn0qV5gP7C/oqTrCf09AAo3wlRCh0Xg/zqEFZbFQW6yfj7Zn6Chma243rt
         2akw==
X-Gm-Message-State: AJIora9MBreh/uV0FYVnECg23haz8L9legcgUG0KP1YNUqH3B7rMdmIa
        L2PvdG2Fb+NrwUQtwMGCfaKrBW2dPlY=
X-Google-Smtp-Source: AGRyM1vcby6lmF2Am9THEh7ZMQqdMKdDdA/DBCoiMxkxk0QrR4nFhTbvMsCqHAE9O09loAagwBJRle6RkEw=
X-Received: from weiwan1.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1441])
 (user=weiwan job=sendgmr) by 2002:a25:2e50:0:b0:669:9a76:beb with SMTP id
 b16-20020a252e50000000b006699a760bebmr321469ybn.597.1658436256624; Thu, 21
 Jul 2022 13:44:16 -0700 (PDT)
Date:   Thu, 21 Jul 2022 20:44:04 +0000
Message-Id: <20220721204404.388396-1-weiwan@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH net v2] Revert "tcp: change pingpong threshold to 3"
From:   Wei Wang <weiwan@google.com>
To:     David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Soheil Hassas Yeganeh <soheil@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Wei Wang <weiwan@google.com>, LemmyHuang <hlm3280@163.com>,
        Neal Cardwell <ncardwell@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 4a41f453bedfd5e9cd040bad509d9da49feb3e2c.

This to-be-reverted commit was meant to apply a stricter rule for the
stack to enter pingpong mode. However, the condition used to check for
interactive session "before(tp->lsndtime, icsk->icsk_ack.lrcvtime)" is
jiffy based and might be too coarse, which delays the stack entering
pingpong mode.
We revert this patch so that we no longer use the above condition to
determine interactive session, and also reduce pingpong threshold to 1.

Fixes: 4a41f453bedf ("tcp: change pingpong threshold to 3")
Reported-by: LemmyHuang <hlm3280@163.com>
Suggested-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Wei Wang <weiwan@google.com>

---
v2: added Fixes tag

---
 include/net/inet_connection_sock.h | 10 +---------
 net/ipv4/tcp_output.c              | 15 ++++++---------
 2 files changed, 7 insertions(+), 18 deletions(-)

diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index 85cd695e7fd1..ee88f0f1350f 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -321,7 +321,7 @@ void inet_csk_update_fastreuse(struct inet_bind_bucket *tb,
 
 struct dst_entry *inet_csk_update_pmtu(struct sock *sk, u32 mtu);
 
-#define TCP_PINGPONG_THRESH	3
+#define TCP_PINGPONG_THRESH	1
 
 static inline void inet_csk_enter_pingpong_mode(struct sock *sk)
 {
@@ -338,14 +338,6 @@ static inline bool inet_csk_in_pingpong_mode(struct sock *sk)
 	return inet_csk(sk)->icsk_ack.pingpong >= TCP_PINGPONG_THRESH;
 }
 
-static inline void inet_csk_inc_pingpong_cnt(struct sock *sk)
-{
-	struct inet_connection_sock *icsk = inet_csk(sk);
-
-	if (icsk->icsk_ack.pingpong < U8_MAX)
-		icsk->icsk_ack.pingpong++;
-}
-
 static inline bool inet_csk_has_ulp(struct sock *sk)
 {
 	return inet_sk(sk)->is_icsk && !!inet_csk(sk)->icsk_ulp_ops;
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index c38e07b50639..d06e72e141ac 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -167,16 +167,13 @@ static void tcp_event_data_sent(struct tcp_sock *tp,
 	if (tcp_packets_in_flight(tp) == 0)
 		tcp_ca_event(sk, CA_EVENT_TX_START);
 
-	/* If this is the first data packet sent in response to the
-	 * previous received data,
-	 * and it is a reply for ato after last received packet,
-	 * increase pingpong count.
-	 */
-	if (before(tp->lsndtime, icsk->icsk_ack.lrcvtime) &&
-	    (u32)(now - icsk->icsk_ack.lrcvtime) < icsk->icsk_ack.ato)
-		inet_csk_inc_pingpong_cnt(sk);
-
 	tp->lsndtime = now;
+
+	/* If it is a reply for ato after last received
+	 * packet, enter pingpong mode.
+	 */
+	if ((u32)(now - icsk->icsk_ack.lrcvtime) < icsk->icsk_ack.ato)
+		inet_csk_enter_pingpong_mode(sk);
 }
 
 /* Account for an ACK we sent. */
-- 
2.37.0.170.g444d1eabd0-goog

