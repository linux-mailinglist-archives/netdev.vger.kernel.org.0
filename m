Return-Path: <netdev+bounces-10926-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D3898730B4E
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 01:15:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 107621C20E20
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 23:15:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C72719525;
	Wed, 14 Jun 2023 23:10:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F288815497
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 23:10:44 +0000 (UTC)
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 492DF2965
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 16:10:19 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-3f8cdb12719so10976295e9.1
        for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 16:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google; t=1686784217; x=1689376217;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nEfh4EMCc4IqGl/BAj96gbhPEjHc5nbwj1sO374I1UA=;
        b=K1WZl6oLNfkdEChs+Ovrq1V9Cm05mE6kgCk0LxvIhTdhfsjWCKMAjISSuVS6TUgu5r
         TQKF+5KCfIZzDtnfDvmEWNDAKTHdKz3GCA/Cf5PjZW5a6kf97LgI2yafsyXJcI2SEjUv
         q3/+vdDRoqTV87UmCUSVwkeprW3lklAaJoJPAsx1pN3S4JJ24ttTNlCuSJuNzCxE/P8V
         ecmIPEUyIpBvcBIrD0u+dgoAkmulGRaY56DlkDyD9idkAyh8jJgjKrpeouJJCfWUECdP
         siuFN6ZKBQEX/NfrsVdY6UR/QQdfs/5BTt+RBv5QrW/MqqhMC3aUS/kHpnF+aBXJ4/Cc
         cGdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686784217; x=1689376217;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nEfh4EMCc4IqGl/BAj96gbhPEjHc5nbwj1sO374I1UA=;
        b=HibdXnxMNgwpUMMQZ1Ds1Sjy9SxpVhEZv4ybVFtIcP1MMBZ9/fUOZyUIf0ooqXgA+v
         YFcOVLK+n5QJqNApwAASboT8IhaE3b03lkbSbcNtlvJkjTPY8E4bVkrriROpUUYqHyfI
         nFc7tw24cvokJlsIIqCP2yra/1nJCNqZAscxs/cbjoNe8vvfSkT6GKFwbBBf9ik3tt9J
         a+EYpz7me3orBPrxV+FBlyYvbZp9wObzTmMxXdjd+PLgblczn6Eq9WyFKrOkLHxLsHgh
         XIh8VEGwM/l7rviLz7C+ryJFo6pS3ZjRtRb4B5Wj9QoYw0k0Qj3qOhPRVIZC9UlKj3ns
         blPQ==
X-Gm-Message-State: AC+VfDy+ZP5zpA6ALU0uhh2o8dQqYE2+fSmVzfq2RAIud1y0dtOqui9c
	fGKHUH+NJIsModKdNCmelDl5Xw==
X-Google-Smtp-Source: ACHHUZ4u/F6VStzS7y3pGTaJOty5h7bxsd/9ikWh82asEzz1GKxZZc48FFKjHsrzv74n/QFV7UlblA==
X-Received: by 2002:a5d:5909:0:b0:30f:cdde:5ded with SMTP id v9-20020a5d5909000000b0030fcdde5dedmr4403746wrd.48.1686784217447;
        Wed, 14 Jun 2023 16:10:17 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id s12-20020a7bc38c000000b003f7ba52eeccsm18725261wmj.7.2023.06.14.16.10.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 16:10:17 -0700 (PDT)
From: Dmitry Safonov <dima@arista.com>
To: David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org,
	Dmitry Safonov <dima@arista.com>,
	Andy Lutomirski <luto@amacapital.net>,
	Ard Biesheuvel <ardb@kernel.org>,
	Bob Gilligan <gilligan@arista.com>,
	Dan Carpenter <error27@gmail.com>,
	David Laight <David.Laight@aculab.com>,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Donald Cassidy <dcassidy@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Francesco Ruggeri <fruggeri05@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
	Ivan Delalande <colona@arista.com>,
	Leonard Crestez <cdleonard@gmail.com>,
	Salam Noureddine <noureddine@arista.com>,
	netdev@vger.kernel.org
Subject: [PATCH v7 14/22] net/tcp: Add TCP-AO SNE support
Date: Thu, 15 Jun 2023 00:09:39 +0100
Message-Id: <20230614230947.3954084-15-dima@arista.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230614230947.3954084-1-dima@arista.com>
References: <20230614230947.3954084-1-dima@arista.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add Sequence Number Extension (SNE) for TCP-AO.
This is needed to protect long-living TCP-AO connections from replaying
attacks after sequence number roll-over, see RFC5925 (6.2).

Co-developed-by: Francesco Ruggeri <fruggeri@arista.com>
Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
Co-developed-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 net/ipv4/tcp_input.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 9e0a3dd9e9e0..eed3f7631b4b 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3528,9 +3528,21 @@ static inline bool tcp_may_update_window(const struct tcp_sock *tp,
 static void tcp_snd_una_update(struct tcp_sock *tp, u32 ack)
 {
 	u32 delta = ack - tp->snd_una;
+#ifdef CONFIG_TCP_AO
+	struct tcp_ao_info *ao;
+#endif
 
 	sock_owned_by_me((struct sock *)tp);
 	tp->bytes_acked += delta;
+#ifdef CONFIG_TCP_AO
+	ao = rcu_dereference_protected(tp->ao_info,
+				       lockdep_sock_is_held((struct sock *)tp));
+	if (ao) {
+		if (ack < ao->snd_sne_seq)
+			ao->snd_sne++;
+		ao->snd_sne_seq = ack;
+	}
+#endif
 	tp->snd_una = ack;
 }
 
@@ -3538,9 +3550,21 @@ static void tcp_snd_una_update(struct tcp_sock *tp, u32 ack)
 static void tcp_rcv_nxt_update(struct tcp_sock *tp, u32 seq)
 {
 	u32 delta = seq - tp->rcv_nxt;
+#ifdef CONFIG_TCP_AO
+	struct tcp_ao_info *ao;
+#endif
 
 	sock_owned_by_me((struct sock *)tp);
 	tp->bytes_received += delta;
+#ifdef CONFIG_TCP_AO
+	ao = rcu_dereference_protected(tp->ao_info,
+				       lockdep_sock_is_held((struct sock *)tp));
+	if (ao) {
+		if (seq < ao->rcv_sne_seq)
+			ao->rcv_sne++;
+		ao->rcv_sne_seq = seq;
+	}
+#endif
 	WRITE_ONCE(tp->rcv_nxt, seq);
 }
 
@@ -6371,6 +6395,17 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 		 * simultaneous connect with crossed SYNs.
 		 * Particularly, it can be connect to self.
 		 */
+#ifdef CONFIG_TCP_AO
+		struct tcp_ao_info *ao;
+
+		ao = rcu_dereference_protected(tp->ao_info,
+					       lockdep_sock_is_held(sk));
+		if (ao) {
+			ao->risn = th->seq;
+			ao->rcv_sne = 0;
+			ao->rcv_sne_seq = ntohl(th->seq);
+		}
+#endif
 		tcp_set_state(sk, TCP_SYN_RECV);
 
 		if (tp->rx_opt.saw_tstamp) {
-- 
2.40.0


