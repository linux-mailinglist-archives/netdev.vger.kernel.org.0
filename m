Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E49ED57C0E2
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 01:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbiGTXcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 19:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbiGTXcM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 19:32:12 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E477C4C
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 16:32:11 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-31e559f6840so1007657b3.6
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 16:32:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Jyz1RegHb8yiGPrNH63TYI5Tjd58NzMbX7B9+TYzgvM=;
        b=ZIEgfqwWiz27PKKnky3JvYfMHhQUXTzhe92VPSRLEYztgg5+DR96lPbF6ExiQHbxz6
         As3hHnAqfZbvbCmx65VqRrgaX6wH0qwWVDMErZSo8ZSGNbIl1Dt6Ucmrqo/OMQar4y9Q
         LqhGZWgnm+4wnzZ2gQws1WTJHTDgX1y+YXPz8vT0D2yLUsuoD2HgduNF3d5OGYrreFs8
         LsDIpWDnZBwMtPVrnhpQ7f3q3j+TdVoOMK6K3z8UCD0NF2paIswmYgAouO4lLGa+eMQl
         l3ag83uuxgDVR3ZgRqK/ILXn85XTnOKNzb5HSoDfUWSxD2Hsu8+bIXrCsxTn+UiGm1VX
         F2xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Jyz1RegHb8yiGPrNH63TYI5Tjd58NzMbX7B9+TYzgvM=;
        b=RYRrEhtUWLcWYLC7xyRbV94zW0ugmx5mARtbAVr36f4UeqovMn2aLKQ1WGm2eyYV9J
         qmZU/goG4+epvGNehmFaX2avjocKK3MB7+cWuJatNIb13TkFt02lNQfQ1lW9Ef8H7tNM
         VfEHjIcJq7XT2zFFAROoweSADuOIB3rIqxjzMoU2jqMAeMg/zUphNlbYds0WEII93kXt
         rSg4QVnLiBnzvV+HLZiHNlWOO71a5OKrxV3NebyHYl/sLiBJfBeS77/JJa8ZyHy5Vs7r
         moybHBXoVjovefkQQbrBUiiUCQSfGl3yz/Vrv283H5IaKZoCVQDINSG/bAlcI2sQf3e9
         yotQ==
X-Gm-Message-State: AJIora/Bo1Jg091UK05FpteHFdbSi0hLVi4INE8yWWkSQ+tjpXrKHmxa
        E+wKTZKMeSmCEuJrsAJtoNHtAQHuUYk=
X-Google-Smtp-Source: AGRyM1uupAj1bS15W9Gniafl2/c78XUXpbGwyfT/4LXpy/UcKJybhhtI8er/bKT3yw3VAPALR6dsStybTkc=
X-Received: from weiwan1.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1441])
 (user=weiwan job=sendgmr) by 2002:a25:71c4:0:b0:66f:95ff:b30 with SMTP id
 m187-20020a2571c4000000b0066f95ff0b30mr36304069ybc.63.1658359930530; Wed, 20
 Jul 2022 16:32:10 -0700 (PDT)
Date:   Wed, 20 Jul 2022 23:31:56 +0000
Message-Id: <20220720233156.295074-1-weiwan@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH net] Revert "tcp: change pingpong threshold to 3"
From:   Wei Wang <weiwan@google.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
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

Reported-by: LemmyHuang <hlm3280@163.com>
Suggested-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Wei Wang <weiwan@google.com>
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

