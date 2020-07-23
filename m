Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3A8722B16E
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 16:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728942AbgGWOeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 10:34:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727885AbgGWOeI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 10:34:08 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0196C0619DC
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 07:34:07 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id b14so3799902qkn.4
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 07:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SW50E8jnOWq1JMpv3b3XkWyV9URtKtIIRRZRsUMuSE4=;
        b=k/n9DzpXsldjXfyGmi84lW9OfTIREcQ9vVPgFuZqLZ3HkG67D+ZyELYxK1dDm0sSVM
         /+wzEgvC3R0a2S6MzqIOAcsIHLutoINYYVmwsfamx3bnq4OHDN07wQ3hL0ybwm0eSaoJ
         sW0BfIRLi2ansDWciDIK0pVg7mhRnlysywGsMN2duA8F8LurPrsiSVG7kiu7wYb7BT81
         ho+2m8iJmZurdv4wKQol/TMyeYP6vhdc8yfd4VVMF64VPFvLgBTlmBDS4k9tC5hjaGhu
         +9KGcsHrkfXpqpvepoZYhIy23ggJQqVcmpKklaOl9EFdIKQYej5joDaKm6H9J/ymkMNH
         JWhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SW50E8jnOWq1JMpv3b3XkWyV9URtKtIIRRZRsUMuSE4=;
        b=E8x3vEx/femUf3jVpUIhU5/AGnlWgAe1p9PWTqeqcW3cahc85y7pBa7j/y5JTuLdky
         ikrQE8MRUQ+T6BGm41b4+EJGb6/7TJr1toXUDgWAuHnDEeASF3I66w5/qInvf/TLOvGk
         cr/CEMLMHyeJ8YmSi7nfP5LuAOJwnBL8mhk/tt5/yhLgD5TTdSK0SYczfQ0BWf3Wrw9S
         NpOAMz5tMAh+gqQu8nKpSQeM98GXa1yik8YyEFLaqoisIXqp+NLubNfKRiK2O+sWfIib
         4gKr+kQaloZaSFuHICMDOWRtRun8MKIhpj75Xlpz1VSVT6pHUt+Nqd0KtMjl/DoIvCRY
         NvBg==
X-Gm-Message-State: AOAM533jMQbjoEKsa5AoX5Rfgv2zVYh3WkA/IiezTzrzlix4k3CIMx8k
        0A0pNFYGIh6P7M8qinqgy2I9IJwh
X-Google-Smtp-Source: ABdhPJyUSN7fjGJWduqwzNL0s0ooNecMgH9NWkiHlc/W2OOlk+sixI5jW7cZTDMSouCs09qFUyOWvg==
X-Received: by 2002:ae9:ea13:: with SMTP id f19mr3853053qkg.331.1595514846632;
        Thu, 23 Jul 2020 07:34:06 -0700 (PDT)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:f693:9fff:fef4:3e8a])
        by smtp.gmail.com with ESMTPSA id w27sm2488114qtv.68.2020.07.23.07.34.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 07:34:05 -0700 (PDT)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Willem de Bruijn <willemb@google.com>
Subject: [PATCH net-next 2/3] icmp: prepare rfc 4884 for ipv6
Date:   Thu, 23 Jul 2020 10:33:56 -0400
Message-Id: <20200723143357.451069-3-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.28.0.rc0.105.gf9edc3c819-goog
In-Reply-To: <20200723143357.451069-1-willemdebruijn.kernel@gmail.com>
References: <20200723143357.451069-1-willemdebruijn.kernel@gmail.com>
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
2.28.0.rc0.105.gf9edc3c819-goog

