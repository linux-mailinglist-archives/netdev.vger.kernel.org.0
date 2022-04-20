Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3C7508365
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 10:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376718AbiDTIa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 04:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356317AbiDTIa4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 04:30:56 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE69235267
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 01:28:11 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id q12so958821pgj.13
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 01:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IMmFREpwVKZdYPhC2ag1sFdEaDwPX8MICJtKP9oqq/s=;
        b=ea1RKeifMY/fPWE3w5HfXltYVjBG9DB3iVI2CZTQKKbvD4091ROXlyCAtEWu2r4i6O
         YAYtMSMXNMh0+9rB17ASj6k6S4HSCxlbUGU7yjzLYQwIzykOETPLFaXNTW6o/n7STjyh
         wm/7z0lcNfhKTQ4ww6Ggqy8DeezKqqum8UsivxZWjqmU+MNAaPjnNcygCFxO/CmHm5wC
         tgclwjl8qgnBmK8C0JtFWSeU4RViqSpNaiD5vrL0QtfVExp1620u5x9cEoPpKZyRHtpQ
         wQeUDMFEQX/lfMlt/ftn1Rxot4Os8MLJEMR13oLEWMgH+Jf0hniWEkxhfXBSPYxMyggn
         2Myw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IMmFREpwVKZdYPhC2ag1sFdEaDwPX8MICJtKP9oqq/s=;
        b=1KcaOEjA6p6tVgGiW2a7sDdfkyqMt/DNyDKCoyITkOAHs/gcSXF6QIHiTqg8PcVjZ6
         CfvIjlXR5ZGHRSzLaLPLnEW5ZBtq/OfLfJX4nYlmgxYnsoedh6khioSretoKMLA60qeo
         K8RaxTDY+UqVOACmU2aQSsi+hEAiwn5gXFScJxUC+qIlbHjBO7UGkSvTmKevxbk8yHjG
         A7JBFWs9EUldnfyNAK66FQS1JK8b2oz/rgJF0Ac9Rf4rfYhv4F9OXvHntaC1Ev4gzC/I
         mEGcASXejhV3cpWc7EhyA5HyRFT8QnBhN1XPT0eqxXNj1mTPwPgNihcZB9S/BYeMQNTX
         pAxw==
X-Gm-Message-State: AOAM532BDhrcfk6tj+xwlzhAJGfoB3ueg0MoxFDIuz3cAJV2ZcGblRV6
        ICov7QnnIdHWbt5k2e96oaUaR6NNbeo=
X-Google-Smtp-Source: ABdhPJyu++OLnOsKbMT/ouzdpFkSwAqAEovtRA1q11ylPKR/2j/6Rx3OGaMPgDrB+LIU30ZomyZzeA==
X-Received: by 2002:a65:6a56:0:b0:3aa:49b8:ee77 with SMTP id o22-20020a656a56000000b003aa49b8ee77mr4765637pgu.19.1650443290882;
        Wed, 20 Apr 2022 01:28:10 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q5-20020a056a00084500b0050ace4a699dsm1197999pfk.95.2022.04.20.01.28.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 01:28:10 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Willem de Bruijn <willemb@google.com>,
        virtualization@lists.linux-foundation.org,
        Balazs Nemeth <bnemeth@redhat.com>,
        Mike Pattrick <mpattric@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net-next] net/af_packet: add VLAN support for AF_PACKET SOCK_RAW GSO
Date:   Wed, 20 Apr 2022 16:27:58 +0800
Message-Id: <20220420082758.581245-1-liuhangbin@gmail.com>
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
packet_parse_headers(), and move the function in packet_snd() before
calling virtio_net_hdr_set_proto().

No need to update tpacket_snd() as it calls packet_parse_headers() in
tpacket_fill_skb(), which is already before calling virtio_net_hdr_*
functions.

skb->no_fcs setting is also moved upper to make all skb settings together
and keep consistence with function packet_sendmsg_spkt().

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/packet/af_packet.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 002d2b9c69dd..cfdbda28ef82 100644
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

