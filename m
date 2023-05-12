Return-Path: <netdev+bounces-2279-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97EEA700FBB
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 22:28:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AEBA51C21369
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 20:28:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04BA6209AF;
	Fri, 12 May 2023 20:23:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5122209AC
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 20:23:41 +0000 (UTC)
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CB762690
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 13:23:40 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-3f42c865535so48301155e9.1
        for <netdev@vger.kernel.org>; Fri, 12 May 2023 13:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google; t=1683923018; x=1686515018;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0dcdpK+4JPNZxxVzldNr8pk+aoPnnitnkLpo5A6eng0=;
        b=TnTLwyUYyBKp6L7s2zA/vT9j9N1AJZVn3txxbyGSYdfk5AacAc6ygwncJqipMJLsZL
         XpvKRHeI4RSFTbjxuJgwNpHPZCdKlV/r6a4jA5732irT3esDDYQGyINTv6m2IA4Y2UmU
         aNA4I4QoXwsAxNzMtbr4tk0rI12BFEWt1mzex5rg8NYM2nyZm31duMLnaqIdcWMuTU6Z
         qpxoASOk5bLnav0nTZqdXzS6iGsWGpePw9/5/Tp8dEdjxqEU6rC5796d2CVR+REqqbBW
         OW78XoIJaETP0WyXFNKAmejmbpqEmUers+wpY6yTIFqJA5CJ63u7QEZYjXSL7UIGFR9W
         SIXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683923018; x=1686515018;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0dcdpK+4JPNZxxVzldNr8pk+aoPnnitnkLpo5A6eng0=;
        b=JeUt6vavffrbtDkk7p4TAjE/V1HwMqaYSzsIhMaJNjUcVI2T1SJ1q7b55FcJR9ainG
         7ys2fMnMfLFUFBhMYc/MSgvs7D4xGUeougmw7Oz+irqr3XzduF4cSfCb/f0Z4Ra28VAq
         NkT/y+qnHP3WnttttRE9qdHrE45pw6uytG6VCdhhjA0ztNcT4i8q33loe4wDzNQvmP6n
         71WDTI99hbUnrS6n1YIXS8AiSmmDVRIEUAD5mvgzIPvuDRtY9HnuhZgZHjrYR0YcOasB
         5Kocx5kjB542K0C77Cscn601IKVFdNk/yOOJfLBXMuLBUWmBETjR/VLED0z2QM7p03go
         FdQQ==
X-Gm-Message-State: AC+VfDzj9Rxn5eVC+HFAKlp7zWo+pc6Y4XkzwzOqEfk01GjWF73qIa59
	2l/Y8b5xogsAxbGeQSfPgvByOQ==
X-Google-Smtp-Source: ACHHUZ5NDpYh+CmG77XsEA1fWPr/iHfzxj39QDwtGruhVcpUh98NbPC2swB75+vxAeiK4PpcnJ/lgQ==
X-Received: by 2002:a1c:741a:0:b0:3f4:e7c2:607d with SMTP id p26-20020a1c741a000000b003f4e7c2607dmr5371380wmc.13.1683923018652;
        Fri, 12 May 2023 13:23:38 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id n9-20020a05600c294900b003f423508c6bsm17304527wmd.44.2023.05.12.13.23.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 May 2023 13:23:38 -0700 (PDT)
From: Dmitry Safonov <dima@arista.com>
To: linux-kernel@vger.kernel.org,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Cc: Dmitry Safonov <dima@arista.com>,
	Andy Lutomirski <luto@amacapital.net>,
	Ard Biesheuvel <ardb@kernel.org>,
	Bob Gilligan <gilligan@arista.com>,
	Dan Carpenter <error27@gmail.com>,
	David Laight <David.Laight@aculab.com>,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Francesco Ruggeri <fruggeri05@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
	Ivan Delalande <colona@arista.com>,
	Leonard Crestez <cdleonard@gmail.com>,
	Salam Noureddine <noureddine@arista.com>,
	netdev@vger.kernel.org
Subject: [PATCH v6 14/21] net/tcp: Add TCP-AO SNE support
Date: Fri, 12 May 2023 21:23:04 +0100
Message-Id: <20230512202311.2845526-15-dima@arista.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230512202311.2845526-1-dima@arista.com>
References: <20230512202311.2845526-1-dima@arista.com>
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
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add Sequence Number Extension (SNE) extension for TCP-AO.
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
index 959e4bdf2906..d87c73346e8c 100644
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


