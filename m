Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE41F1BB00E
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 23:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbgD0VQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 17:16:50 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41118 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726030AbgD0VQu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 17:16:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588022208;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pQ6cSQ4NOD/EcRYBTUoFzvtQJ8BE84XLNBUyGYQoWso=;
        b=Hc/Gpa+PhlfJxNriOe160016jCGfmPOG8+bviVuvIh5WQGc3D58Ev4I4o8bU5B/HwbbJ4U
        ElHSJAwXkKgyF4RnP+pZejK64+o1kboOy59d1lFrYqrSQQBrgpNIbFk+WzAMCyU7HO+yML
        6u4dHtCOubgzsJ48k1+l6isLKfoJtA0=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-261-W4-1hcRKM7CYTTqNsrUwpg-1; Mon, 27 Apr 2020 17:16:46 -0400
X-MC-Unique: W4-1hcRKM7CYTTqNsrUwpg-1
Received: by mail-lf1-f72.google.com with SMTP id v22so8081526lfa.1
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 14:16:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pQ6cSQ4NOD/EcRYBTUoFzvtQJ8BE84XLNBUyGYQoWso=;
        b=F0zVIyjpPR4e1mNVqs4hF8rGw8je3q5/4Vuxm9O3RwMhO+qirDOiN0JHXabxevJvGW
         VEn+t2z0sO9gCp3Iq61xuk2YdeMjAxrreLd6ouVz7GbvQd1HKDpanHChttfvWceE+tYZ
         GPmGNacCjqtXZwysrUQkrls+ndJ6B7NS8Yb+DjquWZCifNhfKx5jxkWJxzRqfEnk95++
         pv16SUFaRdbtbeN3vdqpE9dy4BrWuUodOEog+lr7IrPRZEQj9r1nXLyaCJlivQyBzXb4
         OAmcahzoLWAYve4V+qQMDpaa9Iz5o6ZEaUOjAHa74F56yovh5KCT3aWXYjZVJ3r/hD37
         0TqA==
X-Gm-Message-State: AGi0PuZHQx9NuNhFONrHwtoAKHKCCHmxs3Tv6qRwC3UcTxkVZd6A/FWl
        yI8j5e9oOlp+9ruiD7h3q+b2+pJUwsUw5bGC5Z+U+j8oTpCjb4GSSXi7ggr31uCpI0Ic9pJabnu
        OpYy7zQT2B+/nYfxE
X-Received: by 2002:a19:ca13:: with SMTP id a19mr16639987lfg.68.1588022204967;
        Mon, 27 Apr 2020 14:16:44 -0700 (PDT)
X-Google-Smtp-Source: APiQypJ/PjJHImG1/fIdkB3vo5Rsw2djBqt6xiUD+PahDj4soiPyXITo1r2D1CiF2ttTEOwinPzcGw==
X-Received: by 2002:a19:ca13:: with SMTP id a19mr16639974lfg.68.1588022204716;
        Mon, 27 Apr 2020 14:16:44 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id j13sm12080093lfb.19.2020.04.27.14.16.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2020 14:16:43 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 4E1711814FF; Mon, 27 Apr 2020 23:16:43 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     davem@davemloft.net, jason@zx2c4.com
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, wireguard@lists.zx2c4.com,
        Olivier Tilmans <olivier.tilmans@nokia-bell-labs.com>,
        Dave Taht <dave.taht@gmail.com>,
        "Rodney W . Grimes" <ietf@gndrsh.dnsmgr.net>
Subject: [PATCH net v2] wireguard: use tunnel helpers for decapsulating ECN markings
Date:   Mon, 27 Apr 2020 23:16:19 +0200
Message-Id: <20200427211619.603544-1-toke@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <87d07sy81p.fsf@toke.dk>
References: <87d07sy81p.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

WireGuard currently only propagates ECN markings on tunnel decap according
to the old RFC3168 specification. However, the spec has since been updated
in RFC6040 to recommend slightly different decapsulation semantics. This
was implemented in the kernel as a set of common helpers for ECN
decapsulation, so let's just switch over WireGuard to using those, so it
can benefit from this enhancement and any future tweaks.

RFC6040 also recommends dropping packets on certain combinations of
erroneous code points on the inner and outer packet headers which shouldn't
appear in normal operation. The helper signals this by a return value > 1,
so also add a handler for this case.

Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Reported-by: Olivier Tilmans <olivier.tilmans@nokia-bell-labs.com>
Cc: Dave Taht <dave.taht@gmail.com>
Cc: Rodney W. Grimes <ietf@gndrsh.dnsmgr.net>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
v2:
  - Don't log decap errors, and make sure they are recorded as frame errors,
    not length errors.

 drivers/net/wireguard/receive.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireguard/receive.c b/drivers/net/wireguard/receive.c
index da3b782ab7d3..ad36f358c807 100644
--- a/drivers/net/wireguard/receive.c
+++ b/drivers/net/wireguard/receive.c
@@ -393,13 +393,15 @@ static void wg_packet_consume_data_done(struct wg_peer *peer,
 		len = ntohs(ip_hdr(skb)->tot_len);
 		if (unlikely(len < sizeof(struct iphdr)))
 			goto dishonest_packet_size;
-		if (INET_ECN_is_ce(PACKET_CB(skb)->ds))
-			IP_ECN_set_ce(ip_hdr(skb));
+		if (INET_ECN_decapsulate(skb, PACKET_CB(skb)->ds,
+					 ip_hdr(skb)->tos) > 1)
+			goto ecn_decap_error;
 	} else if (skb->protocol == htons(ETH_P_IPV6)) {
 		len = ntohs(ipv6_hdr(skb)->payload_len) +
 		      sizeof(struct ipv6hdr);
-		if (INET_ECN_is_ce(PACKET_CB(skb)->ds))
-			IP6_ECN_set_ce(skb, ipv6_hdr(skb));
+		if (INET_ECN_decapsulate(skb, PACKET_CB(skb)->ds,
+					 ipv6_get_dsfield(ipv6_hdr(skb))) > 1)
+			goto ecn_decap_error;
 	} else {
 		goto dishonest_packet_type;
 	}
@@ -437,6 +439,7 @@ static void wg_packet_consume_data_done(struct wg_peer *peer,
 dishonest_packet_type:
 	net_dbg_ratelimited("%s: Packet is neither ipv4 nor ipv6 from peer %llu (%pISpfsc)\n",
 			    dev->name, peer->internal_id, &peer->endpoint.addr);
+ecn_decap_error:
 	++dev->stats.rx_errors;
 	++dev->stats.rx_frame_errors;
 	goto packet_processed;
-- 
2.26.2

