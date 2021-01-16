Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 294432F8B51
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 05:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbhAPEpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 23:45:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbhAPEpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 23:45:10 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DE69C061757;
        Fri, 15 Jan 2021 20:44:30 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id md11so6218705pjb.0;
        Fri, 15 Jan 2021 20:44:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=T05FIzPjhgOdVMELS047k9h0MCvGv7nplk+sqHRKxJo=;
        b=AURPRrjHuQ3u87Fn1il+KRgvQEckC2NCZRiqYaBsmYD+Rd+5vB4Lc2BY0a5PHA3MTq
         hteE9we39OlcCMEN6ZMsIEHPHMi+KhNNI9oH0vy1rhJKEh8G/G+gDAa2NQi7ko5osI2A
         22grUYRZvEfU0edl6dzLbf2AsE9GN7Y9AlmOP5dfJne9YZWp0k08HkycbQmd9CvYzbCI
         CC5B3lS0o8fBCiqOaG2R09GlQp3Ir4Cp2aLeEWrMbZvFR1hLin1hPNkC7sM0lJ0lJdi2
         gNH+3IIiv/wHt7cyrjehiISXbuP5hQM6//F3en5gAiF37dQJI1LzozP8E0l8KzzkiwZt
         aqow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=T05FIzPjhgOdVMELS047k9h0MCvGv7nplk+sqHRKxJo=;
        b=hPPfX1FWHvppDyUr1PzOEJsXl6j5qNjvnBFKJhDFjkCpo0fEC+neE5RV/L95mT8n+G
         0qaPPrZvKZeU5T7PCZTLX/JmbbqJ3cb/yoLwBjUxtaIDwu+m/aMyBHAkyMS1+aZKSCqH
         wI/B9L44kG+ipjPfPp6Y84aTt5B84OvR/S/Q1umGOlzyFV0CnXTT1M4bokuS6JkX6bRw
         RJaU7rZkHflpOiVNC1uJvxGw4CPF81SJZmeszlaCMv+f6zlAN2298qh2JRktocBPuoNG
         WBxBRiCgL5r1cRL52Zo1nZOEvSiKFxqQbhvEOzRxC8CZQORj0eeh+5FvaHl8vNlPFkAC
         v9dA==
X-Gm-Message-State: AOAM532cJNClypZjifSJCPhb2v+tVWnMxz374epXdRynQri4p30/pnG/
        Ik8BRdVIXAQtfplQte6bNzgSspRI665uFg==
X-Google-Smtp-Source: ABdhPJyia+0P4ikvSaJLq7Z5xgEWtGYyl9i3I9cVQP4RQgkhb5HCtxJpMamWCpAVU18kOSFagqfyXA==
X-Received: by 2002:a17:902:9f88:b029:dc:292d:37c5 with SMTP id g8-20020a1709029f88b02900dc292d37c5mr15807688plq.26.1610772269422;
        Fri, 15 Jan 2021 20:44:29 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 6sm9037912pgo.17.2021.01.15.20.44.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Jan 2021 20:44:28 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: [PATCHv3 net-next] ip_gre: remove CRC flag from dev features in gre_gso_segment
Date:   Sat, 16 Jan 2021 12:44:11 +0800
Message-Id: <00439f24d5f69e2c6fa2beadc681d056c15c258f.1610772251.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to let it always do CRC checksum in sctp_gso_segment()
by removing CRC flag from the dev features in gre_gso_segment() for
SCTP over GRE, just as it does in Commit 527beb8ef9c0 ("udp: support
sctp over udp in skb_udp_tunnel_segment") for SCTP over UDP.

It could set csum/csum_start in GSO CB properly in sctp_gso_segment()
after that commit, so it would do checksum with gso_make_checksum()
in gre_gso_segment(), and Commit 622e32b7d4a6 ("net: gre: recompute
gre csum for sctp over gre tunnels") can be reverted now.

Note that when need_csum is false, we can still leave CRC checksum
of SCTP to HW by not clearing this CRC flag if it's supported, as
Jakub and Alex noticed.

v1->v2:
  - improve the changelog.
  - fix "rev xmas tree" in varibles declaration.
v2->v3:
  - remove CRC flag from dev features only when need_csum is true.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/gre_offload.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/net/ipv4/gre_offload.c b/net/ipv4/gre_offload.c
index e0a2465..10bc49b 100644
--- a/net/ipv4/gre_offload.c
+++ b/net/ipv4/gre_offload.c
@@ -15,10 +15,10 @@ static struct sk_buff *gre_gso_segment(struct sk_buff *skb,
 				       netdev_features_t features)
 {
 	int tnl_hlen = skb_inner_mac_header(skb) - skb_transport_header(skb);
-	bool need_csum, need_recompute_csum, gso_partial;
 	struct sk_buff *segs = ERR_PTR(-EINVAL);
 	u16 mac_offset = skb->mac_header;
 	__be16 protocol = skb->protocol;
+	bool need_csum, gso_partial;
 	u16 mac_len = skb->mac_len;
 	int gre_offset, outer_hlen;
 
@@ -41,10 +41,11 @@ static struct sk_buff *gre_gso_segment(struct sk_buff *skb,
 	skb->protocol = skb->inner_protocol;
 
 	need_csum = !!(skb_shinfo(skb)->gso_type & SKB_GSO_GRE_CSUM);
-	need_recompute_csum = skb->csum_not_inet;
 	skb->encap_hdr_csum = need_csum;
 
 	features &= skb->dev->hw_enc_features;
+	if (need_csum)
+		features &= ~NETIF_F_SCTP_CRC;
 
 	/* segment inner packet. */
 	segs = skb_mac_gso_segment(skb, features);
@@ -99,15 +100,7 @@ static struct sk_buff *gre_gso_segment(struct sk_buff *skb,
 		}
 
 		*(pcsum + 1) = 0;
-		if (need_recompute_csum && !skb_is_gso(skb)) {
-			__wsum csum;
-
-			csum = skb_checksum(skb, gre_offset,
-					    skb->len - gre_offset, 0);
-			*pcsum = csum_fold(csum);
-		} else {
-			*pcsum = gso_make_checksum(skb, 0);
-		}
+		*pcsum = gso_make_checksum(skb, 0);
 	} while ((skb = skb->next));
 out:
 	return segs;
-- 
2.1.0

