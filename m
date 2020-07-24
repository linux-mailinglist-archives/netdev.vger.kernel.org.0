Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8987D22C5B2
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 15:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbgGXNDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 09:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726317AbgGXNDR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 09:03:17 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91762C0619D3
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 06:03:16 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id s16so6785786qtn.7
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 06:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cZ/1M4M2pcjmsPWzTe6SQb7gKK8NBJsxA41/6m3M+nM=;
        b=efN+rQV+o3Vqpa9gEVy59KkqiqRNjvJMBaI8kMnJHGlVzsVRbUhcAEhVHYrq/7XNpZ
         gwlsgLvvdsbNXakIRObIU6BudouqUkNM6V0AVG3m7ijmb4dE7eio3a2Qo6YewyhQXg7U
         HwwPMMChNFev7GMhz1PDVC0VUzSEQ8PQ9gjhbeq2qfELb0KHEuYm6O7JIDVM3GpOeR49
         1IWX4KY7jsBKT2Dw0uRcHY9gP8zScV9OdKuMXD0omUGH5w3ucIVfMQ5WQBYxqURj4xye
         WTSWMUiVKQ1rXzSYu5lCgf1B3zX7OL+R/eTecs8NUJNqcZxd9ChL3CbSM8qqjM92akFc
         ZYHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cZ/1M4M2pcjmsPWzTe6SQb7gKK8NBJsxA41/6m3M+nM=;
        b=OjEL7oY6DfsDZoxaiAHnxRzyknm5JjEWtrz8DhcL0z9uvGksvVBFOR+jJ0EO2fpBs9
         GnmTKAuCtfhMzf1GxHoYPIfKRSy5QCWf1qUYBFHmOkJNq+lJTDoMWMXhtP9+KgM3b+7T
         Q0pzxte5Zf06AKfCsYwmbBEtEleQInxBv8pTnw0iGRGdikfluL/lF/mPEzFWQwk7ACRj
         ypg1c+jOPPMFruXdrQLz0G9iq8n4I8tDo2UHF6z5mDv9P19KeedvGV3q04ExuEU8aIUn
         FVxXwlsPedJY0Qfs/bXrl1pVVlKuL0cE6yiwGREVNe3bj6P54/p4TEUiGQ3Y4mYrBPgJ
         lfxQ==
X-Gm-Message-State: AOAM532N/Ebd0soPempI8vMJ5nVUxykCx8A4o4HnVAs76F7dJk7+8yxY
        RhE4QT9/SXlp/bgav6RnPpwsjAY+
X-Google-Smtp-Source: ABdhPJwnvVc5Lz652w40j73Shn4g/Q0fdz/B63mov29WH3WPgr2GoYLggGbKT8cRNo/113lywDFmmA==
X-Received: by 2002:ac8:72cb:: with SMTP id o11mr6787345qtp.13.1595595795431;
        Fri, 24 Jul 2020 06:03:15 -0700 (PDT)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:f693:9fff:fef4:3e8a])
        by smtp.gmail.com with ESMTPSA id b8sm1203491qtg.45.2020.07.24.06.03.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2020 06:03:14 -0700 (PDT)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Willem de Bruijn <willemb@google.com>
Subject: [PATCH net-next v2 2/3] icmp: prepare rfc 4884 for ipv6
Date:   Fri, 24 Jul 2020 09:03:09 -0400
Message-Id: <20200724130310.788305-3-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.28.0.rc0.142.g3c755180ce-goog
In-Reply-To: <20200724130310.788305-1-willemdebruijn.kernel@gmail.com>
References: <20200724130310.788305-1-willemdebruijn.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

The RFC 4884 spec is largely the same between IPv4 and IPv6.
Factor out the IPv4 specific parts in preparation for IPv6 support:

- icmp types supported

- icmp header size, and thus offset to original datagram start

- datagram length field offset in icmp(6)hdr.

- datagram length field word size: 4B for IPv4, 8B for IPv6.

Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 include/linux/icmp.h   |  3 ++-
 net/ipv4/icmp.c        | 17 ++++-------------
 net/ipv4/ip_sockglue.c | 14 +++++++++++++-
 3 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/include/linux/icmp.h b/include/linux/icmp.h
index 8fc38a34cb20..0af4d210ee31 100644
--- a/include/linux/icmp.h
+++ b/include/linux/icmp.h
@@ -37,6 +37,7 @@ static inline bool icmp_is_err(int type)
 }
 
 void ip_icmp_error_rfc4884(const struct sk_buff *skb,
-			   struct sock_ee_data_rfc4884 *out);
+			   struct sock_ee_data_rfc4884 *out,
+			   int thlen, int off);
 
 #endif	/* _LINUX_ICMP_H */
diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 646d4fb72c07..1e70e98f14f8 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -1186,24 +1186,15 @@ static bool ip_icmp_error_rfc4884_validate(const struct sk_buff *skb, int off)
 }
 
 void ip_icmp_error_rfc4884(const struct sk_buff *skb,
-			   struct sock_ee_data_rfc4884 *out)
+			   struct sock_ee_data_rfc4884 *out,
+			   int thlen, int off)
 {
-	int hlen, off;
-
-	switch (icmp_hdr(skb)->type) {
-	case ICMP_DEST_UNREACH:
-	case ICMP_TIME_EXCEEDED:
-	case ICMP_PARAMETERPROB:
-		break;
-	default:
-		return;
-	}
+	int hlen;
 
 	/* original datagram headers: end of icmph to payload (skb->data) */
-	hlen = -skb_transport_offset(skb) - sizeof(struct icmphdr);
+	hlen = -skb_transport_offset(skb) - thlen;
 
 	/* per rfc 4884: minimal datagram length of 128 bytes */
-	off = icmp_hdr(skb)->un.reserved[1] * sizeof(u32);
 	if (off < 128 || off < hlen)
 		return;
 
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index a5ea02d7a183..6aa45fe0a676 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -389,6 +389,18 @@ int ip_ra_control(struct sock *sk, unsigned char on,
 	return 0;
 }
 
+static void ipv4_icmp_error_rfc4884(const struct sk_buff *skb,
+				    struct sock_ee_data_rfc4884 *out)
+{
+	switch (icmp_hdr(skb)->type) {
+	case ICMP_DEST_UNREACH:
+	case ICMP_TIME_EXCEEDED:
+	case ICMP_PARAMETERPROB:
+		ip_icmp_error_rfc4884(skb, out, sizeof(struct icmphdr),
+				      icmp_hdr(skb)->un.reserved[1] * 4);
+	}
+}
+
 void ip_icmp_error(struct sock *sk, struct sk_buff *skb, int err,
 		   __be16 port, u32 info, u8 *payload)
 {
@@ -412,7 +424,7 @@ void ip_icmp_error(struct sock *sk, struct sk_buff *skb, int err,
 
 	if (skb_pull(skb, payload - skb->data)) {
 		if (inet_sk(sk)->recverr_rfc4884)
-			ip_icmp_error_rfc4884(skb, &serr->ee.ee_rfc4884);
+			ipv4_icmp_error_rfc4884(skb, &serr->ee.ee_rfc4884);
 
 		skb_reset_transport_header(skb);
 		if (sock_queue_err_skb(sk, skb) == 0)
-- 
2.28.0.rc0.142.g3c755180ce-goog

