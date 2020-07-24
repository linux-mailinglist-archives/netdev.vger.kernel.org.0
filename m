Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9919222C5B1
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 15:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgGXNDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 09:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726317AbgGXNDQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 09:03:16 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 858EBC0619E4
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 06:03:15 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id u8so4027169qvj.12
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 06:03:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=06HT4wXCGPr8/Xt49Ob28EVxkpMcb9QTE5otfDCwkWc=;
        b=XjF1IjByg8BljKGZ+c252SaFgcpjlnS8+CoOUCi2kH0VpFbDPIIDGON1ZtkjmCP+ED
         KAZPkGkBq4B8Qw5E7V8oY2rqK+BhtV+szI1SmbIoktuvnvhX320lUjdHTVhqMDQL9v0X
         INBoy8KJGQAUS+gOr+Q5aO5Z/5BdHMnBB7FCaLm77cMR8z+Z6ECSHmXCL/DILvcR8+8G
         AF6aMN+20QmMQTqKgKZ2ZigAdbM/weSundCsn/zw/6H5v00K6rHf9N4PxxCCGReuh/Zx
         vOGU57X9+xqjqyVrn1hx/a8yol541GCxQEJ5BB3NijlGzIaP6X8hPqr/l/Xv1/4fE4UP
         ga+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=06HT4wXCGPr8/Xt49Ob28EVxkpMcb9QTE5otfDCwkWc=;
        b=PXrCBVVwx38CdxpLo4HFiI6+KA7bhQaIMoIA33t+M7+Wi7Q/tAa0JbThI6492Yn5xU
         qJ7M4+v6OlRBijOHMuFlUP0bYFPhq0FHEbuI2T1dJFtreq3JCik1NZC0cSHZrtmTcsWN
         O4AChjUzSt6eZ4jjHsYMOn9peTYy3X1KvdXPsNEJ0A0QWhOpjGysece9cZXNSBGz7rI0
         knq/GtX07PkQ8l+7I2fyCZ1QwWqLO8LW1w8vJKq5XWRXo/jJ94sH3U2RQKDSzJdthQeZ
         3kGN5ww/ge103B1OTrAVTxEiHa56BK+I4Hd3EOhZJXPQ9QAGj+t5iGBZPJYEQPju8Zob
         6EYA==
X-Gm-Message-State: AOAM531VSQ+Akb62WRSNC/AMbQtjD1rRDGw0/XB0ssvWKj8WU6EEhxQH
        kpusYbbxKlda1Fv+u5z+EaHYvVio
X-Google-Smtp-Source: ABdhPJxGVOkXT98VXWyrNKwR03SwL0AJSpYROXCK/cnheImKJSUxhg9AMrxLRnvp3rf9IFI/RUPUgQ==
X-Received: by 2002:a05:6214:18f:: with SMTP id q15mr9881136qvr.23.1595595794302;
        Fri, 24 Jul 2020 06:03:14 -0700 (PDT)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:f693:9fff:fef4:3e8a])
        by smtp.gmail.com with ESMTPSA id b8sm1203491qtg.45.2020.07.24.06.03.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2020 06:03:13 -0700 (PDT)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Willem de Bruijn <willemb@google.com>
Subject: [PATCH net-next v2 1/3] icmp: revise rfc4884 tests
Date:   Fri, 24 Jul 2020 09:03:08 -0400
Message-Id: <20200724130310.788305-2-willemdebruijn.kernel@gmail.com>
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

1) Only accept packets with original datagram len field >= header len.

The extension header must start after the original datagram headers.
The embedded datagram len field is compared against the 128B minimum
stipulated by RFC 4884. It is unlikely that headers extend beyond
this. But as we know the exact header length, check explicitly.

2) Remove the check that datagram length must be <= 576B.

This is a send constraint. There is no value in testing this on rx.
Within private networks it may be known safe to send larger packets.
Process these packets.

This test was also too lax. It compared original datagram length
rather than entire icmp packet length. The stand-alone fix would be:

  -       if (hlen + skb->len > 576)
  +       if (-skb_network_offset(skb) + skb->len > 576)

Fixes: eba75c587e81 ("icmp: support rfc 4884")
Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 net/ipv4/icmp.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index fd2e7a3a9eb2..646d4fb72c07 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -1199,16 +1199,12 @@ void ip_icmp_error_rfc4884(const struct sk_buff *skb,
 		return;
 	}
 
-	/* outer headers up to inner iph. skb->data is at inner payload */
+	/* original datagram headers: end of icmph to payload (skb->data) */
 	hlen = -skb_transport_offset(skb) - sizeof(struct icmphdr);
 
-	/* per rfc 791: maximum packet length of 576 bytes */
-	if (hlen + skb->len > 576)
-		return;
-
 	/* per rfc 4884: minimal datagram length of 128 bytes */
 	off = icmp_hdr(skb)->un.reserved[1] * sizeof(u32);
-	if (off < 128)
+	if (off < 128 || off < hlen)
 		return;
 
 	/* kernel has stripped headers: return payload offset in bytes */
-- 
2.28.0.rc0.142.g3c755180ce-goog

