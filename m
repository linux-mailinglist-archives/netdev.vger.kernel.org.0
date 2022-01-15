Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3C5948F4A4
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 05:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232351AbiAOEBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 23:01:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232340AbiAOEBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 23:01:09 -0500
Received: from mail-pg1-x564.google.com (mail-pg1-x564.google.com [IPv6:2607:f8b0:4864:20::564])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB19BC06161C
        for <netdev@vger.kernel.org>; Fri, 14 Jan 2022 20:01:09 -0800 (PST)
Received: by mail-pg1-x564.google.com with SMTP id 8so4377506pgc.10
        for <netdev@vger.kernel.org>; Fri, 14 Jan 2022 20:01:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:dkim-signature:from:to:cc:subject:date
         :message-id:in-reply-to:references:content-transfer-encoding;
        bh=UDxnNduLlPLXwz3qo3PCnLNTGRzVnlC88AHZnSxGFQc=;
        b=64+HsrDjhnuYIBYH2nUsSI2Ol3c+II6c7Wm8Rw5/59GXZgQI45iyM5WHGmF7pVInG+
         rnHeiw8I627FOepwKNw/aUf5gIaTdCR3/yoPwF7klNdPw0AeE629uCau4Jg3yVRFYY3+
         jbLWjUhG0/XCtnaZg5Wdk5wXR9JBsPR4jgSUm9R6WW86b1ohM7TNKV74MZKBkLg3FS9o
         DweyX5PT72MR6Y74cfwBHBeX+alnJTuZ43G0djGmpiuyE8lt+8yaKjbolweToHRomqnS
         2gZndXDl7SHwSYYPhMYCwusCEXEen5BXKjz48y9Nr1hZ/s69MthGMo1C2Y+uHu4DD+X7
         idaQ==
X-Gm-Message-State: AOAM530uXdI15fqyhbx8pJhP2DIYCfBikcdqe7TjyHNGhGvCxUzaDcfk
        S26UPW2VfqHN/9tFYbBjgz5ogQPwfLK+HrtxNSzCSIWCmUqM
X-Google-Smtp-Source: ABdhPJyVx+XQcFJIEhvWGUBHJEk4qx97pcZNU7Iww7Q3SXYpxF018z44VVjFZAkvu/0Ph6BazaYlc5SBIwWb
X-Received: by 2002:aa7:928e:0:b0:4ba:fa67:d87 with SMTP id j14-20020aa7928e000000b004bafa670d87mr11938563pfa.41.1642219269252;
        Fri, 14 Jan 2022 20:01:09 -0800 (PST)
Received: from smtp.aristanetworks.com (mx.aristanetworks.com. [162.210.129.12])
        by smtp-relay.gmail.com with ESMTPS id my18sm2158761pjb.0.2022.01.14.20.01.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jan 2022 20:01:09 -0800 (PST)
X-Relaying-Domain: arista.com
Received: from chmeee (unknown [10.95.70.41])
        by smtp.aristanetworks.com (Postfix) with ESMTPS id DE7D2419000;
        Fri, 14 Jan 2022 20:01:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arista.com;
        s=Arista-A; t=1642219268;
        bh=UDxnNduLlPLXwz3qo3PCnLNTGRzVnlC88AHZnSxGFQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jR4gu2UcOxjQfrvylhsB6OWXAJQQ9ZIkQuGPHKFf+yqUz/yJWO1I3yWRsGLx7jNM/
         Gh6mo8Z/wRTX6u+2D5iOreH3Qz0TZQeuSLI6PAeFLYyLzlbGddafRU+MliwgKgFzBZ
         F8IRUx09W+TT5paGcQJgox5AhGsVx92AnQwUHblh69xXBV48n0oLRhvXgTpNfPNRIA
         g9l8aehIXI/Mm5GqnUEkdtgc8g0foL4aZqCqSh0jfhEsZ30YUbDJ5kYdowJqn0sLIz
         tAyCNoBvTeqJMqE6Nzx/eSobU04Zvfa1OVYM5dWb71Sr71pOQaAfgMRAmSfXo6MCjz
         xJPcSYgl5WjoQ==
Received: from kevmitch by chmeee with local (Exim 4.95)
        (envelope-from <kevmitch@chmeee>)
        id 1n8aFX-000mum-EF;
        Fri, 14 Jan 2022 20:01:07 -0800
From:   Kevin Mitchell <kevmitch@arista.com>
Cc:     kevmitch@arista.com, Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] netfilter: conntrack: mark UDP zero checksum as CHECKSUM_UNNECESSARY
Date:   Fri, 14 Jan 2022 20:00:50 -0800
Message-Id: <20220115040050.187972-2-kevmitch@arista.com>
In-Reply-To: <20220115040050.187972-1-kevmitch@arista.com>
References: <20220115040050.187972-1-kevmitch@arista.com>
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The udp_error function verifies the checksum of incoming UDP packets if
one is set. This has the desirable side effect of setting skb->ip_summed
to CHECKSUM_COMPLETE, signalling that this verification need not be
repeated further up the stack.

Conversely, when the UDP checksum is empty, which is perfectly legal (at least
inside IPv4), udp_error previously left no trace that the checksum had been
deemed acceptable.

This was a problem in particular for nf_reject_ipv4, which verifies the
checksum in nf_send_unreach() before sending ICMP_DEST_UNREACH. It makes
no accommodation for zero UDP checksums unless they are already marked
as CHECKSUM_UNNECESSARY.

This commit ensures packets with empty UDP checksum are marked as
CHECKSUM_UNNECESSARY, which is explicitly recommended in skbuff.h.

Signed-off-by: Kevin Mitchell <kevmitch@arista.com>
---
 net/netfilter/nf_conntrack_proto_udp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index 3b516cffc779..12f793d8fe0c 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -63,8 +63,10 @@ static bool udp_error(struct sk_buff *skb,
 	}
 
 	/* Packet with no checksum */
-	if (!hdr->check)
+	if (!hdr->check) {
+		skb->ip_summed = CHECKSUM_UNNECESSARY;
 		return false;
+	}
 
 	/* Checksum invalid? Ignore.
 	 * We skip checking packets on the outgoing path
-- 
2.34.1

