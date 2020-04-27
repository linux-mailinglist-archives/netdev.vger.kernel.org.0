Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0B61BA5DC
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 16:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbgD0OLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 10:11:36 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:53915 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727953AbgD0OLe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 10:11:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587996692;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=icM8hZ+i5Gko0yUWJ2jD4kfy+2/QO64p3wH5kLHPJeA=;
        b=a+1P1ku+dqp84nAAlOCfMqpudeYsvsoAPYypjn4jVfkFE9uxcmQqfWPpj31OKA4IZyvjFp
        PV98vbN0OQFSU+pOj4/np4B2otEA8SCaC4is8XPY5cAt7geiVj+GYPpkriRlweRIy8XmU3
        o3O9rlGq5GA/9grQrkkLWOyxCKH7cEE=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-wGdMrSJaObGL99x0NbVZ0w-1; Mon, 27 Apr 2020 10:11:30 -0400
X-MC-Unique: wGdMrSJaObGL99x0NbVZ0w-1
Received: by mail-lf1-f70.google.com with SMTP id l28so7507451lfp.8
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 07:11:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=icM8hZ+i5Gko0yUWJ2jD4kfy+2/QO64p3wH5kLHPJeA=;
        b=RflfoJJgYD3E2EBlLt15c8FQhLRs5fjCkxyu4Rcm7fCIOIJkDkIhT7Oz44B2e/YCcc
         B+03OI4p1peZeavx/Va1iiEXUJI9eZV3nogA/9JQx+HlhMjRLUGfDaurrFKMPN86lTFI
         S3F26JZnI/yOFE8Q8MhzvBwjgXTdF2ShdmVw50rVbkjp2nN22gULX7DidWuXSdVUb13n
         1wGdJ7K8PzV5BoIMiF0RtJ5F35jo6pz+yZ2V70edYePxx+Ihg32ru4YzsMY8CeSb1qpJ
         66lsEOLHDeawZ9sh9DNfWGj+YtFhka7wZbCkGx4Zok/DUhaVpqNSFnEtOSu5BbLcjkti
         edYA==
X-Gm-Message-State: AGi0PuZyRj21d2syDDVg7NPsT1L1qj8rp+RjAM8kuQJuhM4TacGxJTV4
        qZVILh5IZo+DtU5vtGqGlyKSkPhENfIznI3cYRyOgale4doRPyh29YrYqYaF/JF7RGvUtiiVtUA
        +ENEbZ352sjEbT+75
X-Received: by 2002:a2e:b162:: with SMTP id a2mr14289279ljm.25.1587996689116;
        Mon, 27 Apr 2020 07:11:29 -0700 (PDT)
X-Google-Smtp-Source: APiQypIHwBWLVQVFp3Q5+nV3EgB1yBPhWIxROruvQHZQ128Qs4PmIhjlcDLN2OmESo2FlOtYrreawg==
X-Received: by 2002:a2e:b162:: with SMTP id a2mr14289268ljm.25.1587996688907;
        Mon, 27 Apr 2020 07:11:28 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id l18sm10027491ljg.98.2020.04.27.07.11.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2020 07:11:27 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 1BEFA1814FF; Mon, 27 Apr 2020 16:11:26 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     davem@davemloft.net
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, Bob Briscoe <ietf@bobbriscoe.net>,
        Olivier Tilmans <olivier.tilmans@nokia-bell-labs.com>,
        Dave Taht <dave.taht@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH net] tunnel: Propagate ECT(1) when decapsulating as recommended by RFC6040
Date:   Mon, 27 Apr 2020 16:11:05 +0200
Message-Id: <20200427141105.555251-1-toke@redhat.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RFC 6040 recommends propagating an ECT(1) mark from an outer tunnel header
to the inner header if that inner header is already marked as ECT(0). When
RFC 6040 decapsulation was implemented, this case of propagation was not
added. This simply appears to be an oversight, so let's fix that.

Fixes: eccc1bb8d4b4 ("tunnel: drop packet if ECN present with not-ECT")
Reported-by: Bob Briscoe <ietf@bobbriscoe.net>
Reported-by: Olivier Tilmans <olivier.tilmans@nokia-bell-labs.com>
Cc: Dave Taht <dave.taht@gmail.com>
Cc: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/net/inet_ecn.h | 57 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 55 insertions(+), 2 deletions(-)

diff --git a/include/net/inet_ecn.h b/include/net/inet_ecn.h
index c8e2bebd8d93..0f0d1efe06dd 100644
--- a/include/net/inet_ecn.h
+++ b/include/net/inet_ecn.h
@@ -99,6 +99,20 @@ static inline int IP_ECN_set_ce(struct iphdr *iph)
 	return 1;
 }
 
+static inline int IP_ECN_set_ect1(struct iphdr *iph)
+{
+	u32 check = (__force u32)iph->check;
+
+	if ((iph->tos & INET_ECN_MASK) != INET_ECN_ECT_0)
+		return 0;
+
+	check += (__force u16)htons(0x100);
+
+	iph->check = (__force __sum16)(check + (check>=0xFFFF));
+	iph->tos ^= INET_ECN_MASK;
+	return 1;
+}
+
 static inline void IP_ECN_clear(struct iphdr *iph)
 {
 	iph->tos &= ~INET_ECN_MASK;
@@ -134,6 +148,22 @@ static inline int IP6_ECN_set_ce(struct sk_buff *skb, struct ipv6hdr *iph)
 	return 1;
 }
 
+static inline int IP6_ECN_set_ect1(struct sk_buff *skb, struct ipv6hdr *iph)
+{
+	__be32 from, to;
+
+	if ((ipv6_get_dsfield(iph) & INET_ECN_MASK) != INET_ECN_ECT_0)
+		return 0;
+
+	from = *(__be32 *)iph;
+	to = from ^ htonl(INET_ECN_MASK << 20);
+	*(__be32 *)iph = to;
+	if (skb->ip_summed == CHECKSUM_COMPLETE)
+		skb->csum = csum_add(csum_sub(skb->csum, (__force __wsum)from),
+				     (__force __wsum)to);
+	return 1;
+}
+
 static inline void ipv6_copy_dscp(unsigned int dscp, struct ipv6hdr *inner)
 {
 	dscp &= ~INET_ECN_MASK;
@@ -159,6 +189,25 @@ static inline int INET_ECN_set_ce(struct sk_buff *skb)
 	return 0;
 }
 
+static inline int INET_ECN_set_ect1(struct sk_buff *skb)
+{
+	switch (skb->protocol) {
+	case cpu_to_be16(ETH_P_IP):
+		if (skb_network_header(skb) + sizeof(struct iphdr) <=
+		    skb_tail_pointer(skb))
+			return IP_ECN_set_ect1(ip_hdr(skb));
+		break;
+
+	case cpu_to_be16(ETH_P_IPV6):
+		if (skb_network_header(skb) + sizeof(struct ipv6hdr) <=
+		    skb_tail_pointer(skb))
+			return IP6_ECN_set_ect1(skb, ipv6_hdr(skb));
+		break;
+	}
+
+	return 0;
+}
+
 /*
  * RFC 6040 4.2
  *  To decapsulate the inner header at the tunnel egress, a compliant
@@ -208,8 +257,12 @@ static inline int INET_ECN_decapsulate(struct sk_buff *skb,
 	int rc;
 
 	rc = __INET_ECN_decapsulate(outer, inner, &set_ce);
-	if (!rc && set_ce)
-		INET_ECN_set_ce(skb);
+	if (!rc) {
+		if (set_ce)
+			INET_ECN_set_ce(skb);
+		else if ((outer & INET_ECN_MASK) == INET_ECN_ECT_1)
+			INET_ECN_set_ect1(skb);
+	}
 
 	return rc;
 }
-- 
2.26.2

