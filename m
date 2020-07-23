Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79C7422B16C
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 16:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728777AbgGWOeH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 10:34:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727885AbgGWOeH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 10:34:07 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7EE4C0619DC
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 07:34:06 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id 6so4554043qtt.0
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 07:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=utwLKIiDHY5TJ1dKgkvpKLpYXuoDVUvrDVlxyvHumwM=;
        b=fXAu9Mc9HiZsmXjLEEMTueC/omDGo27BlBiPnqGJgFPesioCBYuOgiZC5rqLbzSn3X
         BqAlbGOXWxUCcXd56z1n+YC+WhPZBceEgtA681+kDRgHDTERWaaoVoiD9vs3K/IFOfTn
         jiZT0uUPemw4WWzEG316bfTruvUDeuMmjVxrl98yrPgJ66OXx+G2yeRRNqp4IKVvjajC
         N+R3xg8IEzmY9nT/XI6hdsitGZWuUQa/ozV6xLzjQh9ksNXcHbzE3TDPRZUNpHNWFd05
         HGGib7yE+hMkCkn1cxFL8SwxErPG+xgVgH1ZBJ0wZpQh51eTrAXZA8FIR4iu+vVzXElP
         ZIXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=utwLKIiDHY5TJ1dKgkvpKLpYXuoDVUvrDVlxyvHumwM=;
        b=o9kmiKf80b1EQ1Ux48SrNG4mkQWNYOgxgVdwKG9kgD57bpEVJqNzZ1SXucmQVd+pL2
         d/LQmwSpPlEnsVq2JZzH5p+Djr9cgFcd/HS81whM4KL4EL41qR6NgdMDzD0AkRCHJdoo
         4vZ53jLUoLTYYf6EzeNyoLOT39r8RR8iQNyNkHEPeIe9KpinB4PbVmaNAZ7g+RpF1TPD
         4EJSbJLkwSufEShVWqvIDEd4CwDJdVEqzpZ0KzeShcC0AsQ4BjJ+Jhg0Vgj6tNNnslDb
         vpSKtwHStJuCUBdz4EltjLcEOBjdjRdAOCDpX9a1xrpeT+8nyKHwklOTnt6f/6WM30et
         0X4Q==
X-Gm-Message-State: AOAM533UEw2XlYbFZ4Y6uIp/Idgh30wCgmH8yYfj5CiUJ/iGiX67oR2b
        z3TaO5toBLaiU8SL0nrgifcrc8lo
X-Google-Smtp-Source: ABdhPJwoswFNK9ZOs7pLCFCEjOubDkwUCGM/gAnD0Zt7q0624puVhs0EJwlpQsnkF9xlwIUkYNpHYw==
X-Received: by 2002:ac8:70da:: with SMTP id g26mr4668704qtp.67.1595514845559;
        Thu, 23 Jul 2020 07:34:05 -0700 (PDT)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:f693:9fff:fef4:3e8a])
        by smtp.gmail.com with ESMTPSA id w27sm2488114qtv.68.2020.07.23.07.34.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 07:34:04 -0700 (PDT)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Willem de Bruijn <willemb@google.com>
Subject: [PATCH net-next 1/3] icmp: revise rfc4884 tests
Date:   Thu, 23 Jul 2020 10:33:55 -0400
Message-Id: <20200723143357.451069-2-willemdebruijn.kernel@gmail.com>
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
2.28.0.rc0.105.gf9edc3c819-goog

