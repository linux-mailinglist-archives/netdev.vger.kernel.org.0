Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC6D850D6AE
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 03:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240221AbiDYBsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 21:48:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240213AbiDYBsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 21:48:17 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C72A116E
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 18:45:14 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d15so23684013pll.10
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 18:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0lX3gznPOI75GqYMIynfYTAzG96BWu7CwIMnBtSe3mo=;
        b=XggauLTSiLyu/+nykFS/zXIoDs+wlsWglH65iqnTBihCdbVA8bP2CxaHIpvlCQo3UQ
         YP8Np4i/DEvltIVuqcADyxdI3wMv75kqpi+K+EWHaJawWLZFoS7IQKnVURaam3xF0g/v
         hE1VoIUaW0TBUsxVzKkGMUK3Bs1xHfF/YU+gHLqqvo4fn/N3pkLTKXKAfoiVAcK9W0cr
         XotHlEVpZ7XrmaT3dt9tQsBoq5PThMso7myuAiNbX8wilVR+tq31CNMn90B5V1H60R8z
         cunhH0lZCrWXL/BQquMASS/Pa4DMtBoprrIGa+DuBWGp+DxBd42/I+6JqoF7UT842WeV
         h/EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0lX3gznPOI75GqYMIynfYTAzG96BWu7CwIMnBtSe3mo=;
        b=dR295OfHNnszqAXDaDAHaf9wajvHYtbR+2oyLbvEGSr9zTKYP8+u8cIgkeEXb+eitM
         GMj6vRxVJpR1VgHFXuPNE1MszDozggUnpyG8g+cDTwp+Ojj6eWS5qc3nOHd0knpUXMZs
         v8WZvREcirONW0MWvM2p/hs8nmfCf4nNKbv9pFyWkx/maMyhS0n+47MUj3WiBuufFG23
         ciulL6NWCZ/M17AdHu+9QJIUMKvCc+XuhP2zctvM8fgOEGaHNqG3l3I5RgeCDy+6paRt
         eTk62iHQ44HeyoPOMEcs+Zpq8keiJj5PuzkrFFYAD/9HWcDRRHBZ5uJnJ+YpNvQsuQFd
         BSLg==
X-Gm-Message-State: AOAM531WsVGYnaam4OxIwbzzGM35UzwCTb4UlCU6chsA+qxqDiKzReQC
        7zmkvDeukPG//wt59SL+qh/HBhCSQXQ=
X-Google-Smtp-Source: ABdhPJyTrRr6EpVyFdChKvWiXYkdP1BhrmA/Ws82fbI67Ku8a4YQbtei1ZPOZGFuuVEHD6NFwD++iw==
X-Received: by 2002:a17:90b:350e:b0:1d2:b6e2:1000 with SMTP id ls14-20020a17090b350e00b001d2b6e21000mr18425172pjb.199.1650851113771;
        Sun, 24 Apr 2022 18:45:13 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v16-20020aa78090000000b0050583cb0adbsm9072072pff.196.2022.04.24.18.45.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Apr 2022 18:45:13 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Willem de Bruijn 
        <WillemdeBruijnwillemdebruijn.kernel@gmail.com>,
        Balazs Nemeth <bnemeth@redhat.com>,
        Mike Pattrick <mpattric@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 net-next] net/af_packet: add VLAN support for AF_PACKET SOCK_RAW GSO
Date:   Mon, 25 Apr 2022 09:45:02 +0800
Message-Id: <20220425014502.985464-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the kernel drops GSO VLAN tagged packet if it's created with
socket(AF_PACKET, SOCK_RAW, 0) plus virtio_net_hdr.

The reason is AF_PACKET doesn't adjust the skb network header if there is
a VLAN tag. Then after virtio_net_hdr_set_proto() called, the skb->protocol
will be set to ETH_P_IP/IPv6. And in later inet/ipv6_gso_segment() the skb
is dropped as network header position is invalid.

Let's handle VLAN packets by adjusting network header position in
packet_parse_headers(). The adjustment is safe and does not affect the
later xmit as tap device also did that.

In packet_snd(), packet_parse_headers() need to be moved before calling
virtio_net_hdr_set_proto(), so we can set correct skb->protocol and
network header first.

There is no need to update tpacket_snd() as it calls packet_parse_headers()
in tpacket_fill_skb(), which is already before calling virtio_net_hdr_*
functions.

skb->no_fcs setting is also moved upper to make all skb settings together
and keep consistency with function packet_sendmsg_spkt().

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---

v2: Rewrite commit description, no code update.
---
 net/packet/af_packet.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 243566129784..fd31334cf688 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1924,12 +1924,20 @@ static int packet_rcv_spkt(struct sk_buff *skb, struct net_device *dev,
 
 static void packet_parse_headers(struct sk_buff *skb, struct socket *sock)
 {
+	int depth;
+
 	if ((!skb->protocol || skb->protocol == htons(ETH_P_ALL)) &&
 	    sock->type == SOCK_RAW) {
 		skb_reset_mac_header(skb);
 		skb->protocol = dev_parse_header_protocol(skb);
 	}
 
+	/* Move network header to the right position for VLAN tagged packets */
+	if (likely(skb->dev->type == ARPHRD_ETHER) &&
+	    eth_type_vlan(skb->protocol) &&
+	    __vlan_get_protocol(skb, skb->protocol, &depth) != 0)
+		skb_set_network_header(skb, depth);
+
 	skb_probe_transport_header(skb);
 }
 
@@ -3047,6 +3055,11 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
 	skb->mark = sockc.mark;
 	skb->tstamp = sockc.transmit_time;
 
+	if (unlikely(extra_len == 4))
+		skb->no_fcs = 1;
+
+	packet_parse_headers(skb, sock);
+
 	if (has_vnet_hdr) {
 		err = virtio_net_hdr_to_skb(skb, &vnet_hdr, vio_le());
 		if (err)
@@ -3055,11 +3068,6 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
 		virtio_net_hdr_set_proto(skb, &vnet_hdr);
 	}
 
-	packet_parse_headers(skb, sock);
-
-	if (unlikely(extra_len == 4))
-		skb->no_fcs = 1;
-
 	err = po->xmit(skb);
 	if (unlikely(err != 0)) {
 		if (err > 0)
-- 
2.35.1

