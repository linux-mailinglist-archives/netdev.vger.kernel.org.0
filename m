Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D76611BA6D6
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 16:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbgD0OrC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 10:47:02 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30008 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726539AbgD0OrC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 10:47:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587998820;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ddiB4jMApVJxygpX0CgPIMlcKA3qPJtV24eu/rm0sQc=;
        b=Rp+8+jfPt3buYgTtoDFzYtWczdFNkDeIdCeQNjJtONYckrLX42FFCTqv6tiPGDnMTODLII
        vfY17fzx2Kl2NZJ5MGUWdGHPDmwGx9LDaUaZZDGwKb2bjTn6gE+ojNIXwPRdwZZzCW3E3Q
        0tuEr3neZmDMmhGbwNx30NRFEXIR3Yw=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-129-In-YMzQsP9-d3bphRqvpPw-1; Mon, 27 Apr 2020 10:46:59 -0400
X-MC-Unique: In-YMzQsP9-d3bphRqvpPw-1
Received: by mail-lf1-f70.google.com with SMTP id d5so7588510lfb.5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 07:46:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ddiB4jMApVJxygpX0CgPIMlcKA3qPJtV24eu/rm0sQc=;
        b=KnUOqGGbuqIa8dw78uYvtlSDuW0feoREybOnRhvGD1yHlKsMEtkbfNaeaPVel2chh1
         vouSZcmc2Z92P3IyBqyNXlw8k36td6Qh5xa7lqt9ZfhJbqcRZdNr0SNPwSo9UAyxmvgY
         +8AcAGR4SeA12vrIwhKffDS2q/7b2jotEqD+9h391hLF9Mas/uyccLzFRKvhC5K6U99B
         +NoVQgGY3Lj6d4maOewz5j0jdMJ7mVayIVuhn/P9JQvSzHCxV4e7DDhgnVRUMbHQRoug
         QFkKbp6U0/vkAK1m/SMPqVWdui9CIQa6tscfVf2QTedLL/CtaBwn/SsSAlN3Zw07qGXY
         7efg==
X-Gm-Message-State: AGi0PubULuE0+Zm/j/VL75J+4Fs2K9LJecRBJlqouvJYnotECS3zTisk
        vsEGC0tDJ/S1oZN8xXxRXNndsBtUq6REjLW7YghYSwJ1u1Rq7xmxJS3JtiPPekaFsMeh+bwmDTf
        d3Gpc11/h9pkJ+EQh
X-Received: by 2002:a2e:9d83:: with SMTP id c3mr13719974ljj.90.1587998817507;
        Mon, 27 Apr 2020 07:46:57 -0700 (PDT)
X-Google-Smtp-Source: APiQypLji2QumBqqpxNvq3ae2aYOimecX9XLqyNhWHzRGypgd/7nOtNmrxgSlj4rZhAGQXiENtVr1Q==
X-Received: by 2002:a2e:9d83:: with SMTP id c3mr13719962ljj.90.1587998817309;
        Mon, 27 Apr 2020 07:46:57 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id z21sm10173772ljh.42.2020.04.27.07.46.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2020 07:46:56 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id AB6D91814FF; Mon, 27 Apr 2020 16:46:55 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     davem@davemloft.net, jason@zx2c4.com
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, wireguard@lists.zx2c4.com,
        Olivier Tilmans <olivier.tilmans@nokia-bell-labs.com>,
        Dave Taht <dave.taht@gmail.com>,
        "Rodney W . Grimes" <ietf@gndrsh.dnsmgr.net>
Subject: [PATCH net] wireguard: Use tunnel helpers for decapsulating ECN markings
Date:   Mon, 27 Apr 2020 16:46:25 +0200
Message-Id: <20200427144625.581110-1-toke@redhat.com>
X-Mailer: git-send-email 2.26.2
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
 drivers/net/wireguard/receive.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireguard/receive.c b/drivers/net/wireguard/receive.c
index da3b782ab7d3..f33e476ad574 100644
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
@@ -446,6 +448,12 @@ static void wg_packet_consume_data_done(struct wg_peer *peer,
 	++dev->stats.rx_errors;
 	++dev->stats.rx_length_errors;
 	goto packet_processed;
+ecn_decap_error:
+	net_dbg_ratelimited("%s: Non-ECT packet from peer %llu (%pISpfsc)\n",
+			    dev->name, peer->internal_id, &peer->endpoint.addr);
+	++dev->stats.rx_errors;
+	++dev->stats.rx_length_errors;
+	goto packet_processed;
 packet_processed:
 	dev_kfree_skb(skb);
 }
-- 
2.26.2

