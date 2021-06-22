Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FCEF3B0C8F
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 20:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232720AbhFVSLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 14:11:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232589AbhFVSK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 14:10:59 -0400
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D690DC09B096;
        Tue, 22 Jun 2021 11:05:16 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id m15so3787399qvc.9;
        Tue, 22 Jun 2021 11:05:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=wjKWa5kNXfQP53+toGFYutOWeDpF9uyavnuzYQGoUNs=;
        b=p0p9zpiFU9WNtC6Dj03dzMbkXy7XW4O2fkBk3kRmc5zp8cu+6k5ZN5RCmwouOdjQtP
         q1MojouQ89I5NFwW6izfiPVjdObX7VkchoY9T4fO/+zhKnybblvEm9zRTbGNpXX1VRnr
         mHfWO1CrVmlsC6nvsXPf1CdSLxUuSaqgjO7T8/GqDieoIhdXXMCkicHK5DjCzVBIgu+y
         bBe8niyNLrRlMdx5+5O/Eki/3BSsOLXM1cUnJTnOEoTwilbQH0esFNPornzAknajJsem
         s98lu0o5HszW+7V5MaZWaIU/Y/uPR0RrfEiCeCzEIpnTLvJYGlVDUo1NaWrHkxT4wEv5
         9Mdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wjKWa5kNXfQP53+toGFYutOWeDpF9uyavnuzYQGoUNs=;
        b=AwCQuFx8bWtUyTGp3iDAlRyuvaWzVMO4QPD+Fs5n15sfaP7AZIfN7ar8XW8Kpu8sAe
         8cLKmxPblat43cy5uN0RFXBPHEUyxijCE94jpJg0l4hBZgMNl9ky+Jj/qMM3Yi1/A/P+
         aCiHfo1biHrtON6WA7+cDwovh+s/moJQqu3mfXpPJlERtoiDdr12Jpf5AEiailJRSLsN
         4W0PujWLJE7QoXmrc93hsJ32hQo9d0fGhFwCQfTS5fZ4TITGsVF7JbRmbqbqHKkT7MmO
         B5X3R64fBnn80MzViLb2YwoBSoo+K7vfy5kubGpYAOEfSHS3ygfd7C3TJtHTMhMjPcnf
         /doQ==
X-Gm-Message-State: AOAM530drzID3h3Jga8gh0wCLMfWbB9xLLqYzsbNkcT7By+yhRvkkkc+
        Rf3HLn17PnZ6cmQ6zhctiXR/jrmv9nYCfA==
X-Google-Smtp-Source: ABdhPJwQACczIxlGP0ob9yktX5Vhg02nvUd2uHS7V+p7Gk9U1JbvKwKyXbTm/okIY/7//LOk6aPjGg==
X-Received: by 2002:a0c:e912:: with SMTP id a18mr23487947qvo.39.1624385115851;
        Tue, 22 Jun 2021 11:05:15 -0700 (PDT)
Received: from localhost (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id k20sm8422283qko.113.2021.06.22.11.05.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 11:05:15 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        linux-sctp@vger.kernel.org
Subject: [PATCHv2 net-next 13/14] sctp: extract sctp_v4_err_handle function from sctp_v4_err
Date:   Tue, 22 Jun 2021 14:04:59 -0400
Message-Id: <6c0e597a24f5f96389f5e157ab6590a01fb114fa.1624384990.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1624384990.git.lucien.xin@gmail.com>
References: <cover.1624384990.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to extract sctp_v4_err_handle() from sctp_v4_err() to
only handle the icmp err after the sock lookup, and it also makes
the code clearer.

sctp_v4_err_handle() will be used in sctp over udp's err handling
in the following patch.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sctp/input.c | 106 ++++++++++++++++++++++-------------------------
 1 file changed, 49 insertions(+), 57 deletions(-)

diff --git a/net/sctp/input.c b/net/sctp/input.c
index 9ffdbd6526e9..83d58d42ea45 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -556,6 +556,49 @@ void sctp_err_finish(struct sock *sk, struct sctp_transport *t)
 	sctp_transport_put(t);
 }
 
+static void sctp_v4_err_handle(struct sctp_transport *t, struct sk_buff *skb,
+			       __u8 type, __u8 code, __u32 info)
+{
+	struct sctp_association *asoc = t->asoc;
+	struct sock *sk = asoc->base.sk;
+	int err = 0;
+
+	switch (type) {
+	case ICMP_PARAMETERPROB:
+		err = EPROTO;
+		break;
+	case ICMP_DEST_UNREACH:
+		if (code > NR_ICMP_UNREACH)
+			return;
+		if (code == ICMP_FRAG_NEEDED) {
+			sctp_icmp_frag_needed(sk, asoc, t, SCTP_TRUNC4(info));
+			return;
+		}
+		if (code == ICMP_PROT_UNREACH) {
+			sctp_icmp_proto_unreachable(sk, asoc, t);
+			return;
+		}
+		err = icmp_err_convert[code].errno;
+		break;
+	case ICMP_TIME_EXCEEDED:
+		if (code == ICMP_EXC_FRAGTIME)
+			return;
+
+		err = EHOSTUNREACH;
+		break;
+	case ICMP_REDIRECT:
+		sctp_icmp_redirect(sk, t, skb);
+	default:
+		return;
+	}
+	if (!sock_owned_by_user(sk) && inet_sk(sk)->recverr) {
+		sk->sk_err = err;
+		sk->sk_error_report(sk);
+	} else {  /* Only an error on timeout */
+		sk->sk_err_soft = err;
+	}
+}
+
 /*
  * This routine is called by the ICMP module when it gets some
  * sort of error condition.  If err < 0 then the socket should
@@ -574,22 +617,19 @@ void sctp_err_finish(struct sock *sk, struct sctp_transport *t)
 int sctp_v4_err(struct sk_buff *skb, __u32 info)
 {
 	const struct iphdr *iph = (const struct iphdr *)skb->data;
-	const int ihlen = iph->ihl * 4;
 	const int type = icmp_hdr(skb)->type;
 	const int code = icmp_hdr(skb)->code;
-	struct sock *sk;
-	struct sctp_association *asoc = NULL;
+	struct net *net = dev_net(skb->dev);
 	struct sctp_transport *transport;
-	struct inet_sock *inet;
+	struct sctp_association *asoc;
 	__u16 saveip, savesctp;
-	int err;
-	struct net *net = dev_net(skb->dev);
+	struct sock *sk;
 
 	/* Fix up skb to look at the embedded net header. */
 	saveip = skb->network_header;
 	savesctp = skb->transport_header;
 	skb_reset_network_header(skb);
-	skb_set_transport_header(skb, ihlen);
+	skb_set_transport_header(skb, iph->ihl * 4);
 	sk = sctp_err_lookup(net, AF_INET, skb, sctp_hdr(skb), &asoc, &transport);
 	/* Put back, the original values. */
 	skb->network_header = saveip;
@@ -598,58 +638,10 @@ int sctp_v4_err(struct sk_buff *skb, __u32 info)
 		__ICMP_INC_STATS(net, ICMP_MIB_INERRORS);
 		return -ENOENT;
 	}
-	/* Warning:  The sock lock is held.  Remember to call
-	 * sctp_err_finish!
-	 */
 
-	switch (type) {
-	case ICMP_PARAMETERPROB:
-		err = EPROTO;
-		break;
-	case ICMP_DEST_UNREACH:
-		if (code > NR_ICMP_UNREACH)
-			goto out_unlock;
-
-		/* PMTU discovery (RFC1191) */
-		if (ICMP_FRAG_NEEDED == code) {
-			sctp_icmp_frag_needed(sk, asoc, transport,
-					      SCTP_TRUNC4(info));
-			goto out_unlock;
-		} else {
-			if (ICMP_PROT_UNREACH == code) {
-				sctp_icmp_proto_unreachable(sk, asoc,
-							    transport);
-				goto out_unlock;
-			}
-		}
-		err = icmp_err_convert[code].errno;
-		break;
-	case ICMP_TIME_EXCEEDED:
-		/* Ignore any time exceeded errors due to fragment reassembly
-		 * timeouts.
-		 */
-		if (ICMP_EXC_FRAGTIME == code)
-			goto out_unlock;
-
-		err = EHOSTUNREACH;
-		break;
-	case ICMP_REDIRECT:
-		sctp_icmp_redirect(sk, transport, skb);
-		/* Fall through to out_unlock. */
-	default:
-		goto out_unlock;
-	}
-
-	inet = inet_sk(sk);
-	if (!sock_owned_by_user(sk) && inet->recverr) {
-		sk->sk_err = err;
-		sk->sk_error_report(sk);
-	} else {  /* Only an error on timeout */
-		sk->sk_err_soft = err;
-	}
-
-out_unlock:
+	sctp_v4_err_handle(transport, skb, type, code, info);
 	sctp_err_finish(sk, transport);
+
 	return 0;
 }
 
-- 
2.27.0

