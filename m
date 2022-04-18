Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3185504BC1
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 06:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236524AbiDREqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 00:46:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236523AbiDREqu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 00:46:50 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0497817AAA
        for <netdev@vger.kernel.org>; Sun, 17 Apr 2022 21:44:12 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id q3so11485442plg.3
        for <netdev@vger.kernel.org>; Sun, 17 Apr 2022 21:44:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9GlZqr5GHjmACFFd+00ZZBjVRiXmjoK19qAAw32r+hw=;
        b=bCDnswZNlMSZrIKM2V9jcmv7D5SqlDQ+Izu66mbYVw8cGs/JERaTwDV2bF+aUqK6Yl
         Hs6kKAJ2kSeaFgUcxmYQO4LNyIPkep8zMm0qoTtVaHjlBOclVLpPX222+vZkMg5FLMuX
         zXQVOg8aQIN1ft71y/u+PdNhVwFyrSUvNt3yLmb/KCP0sVmqpnTfGG2DWXdwPz80Oso1
         jJide6O8/KzmhR34jjsfR7HWDUDW4NF2h7ojlOW9ZStn54PZUWO9/lKKRazGU9+ZBJfG
         SiFjIqEZJMPJNuuUBU1+xY0Jmc72ADJI8X9drUY/eOm04eFepLQ7/TB9L9ZZt75M3a7q
         teDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9GlZqr5GHjmACFFd+00ZZBjVRiXmjoK19qAAw32r+hw=;
        b=nGoY4r5ilAf1tTQRIwVopUHf6laPjF/TfKpLO9Ny68510ucRec6YPP0e5nktcJ6dg2
         YZ3/shRXozn9Ic81CukpxCKvaD65nFkYcmQSVFK6hlmhi5Km4ZSWj8NxI3/QjdTIb51T
         e0ypn4GWjnRrQck0eGKQECoFvMNjFvp+hXdxJGTFJIpVnk0sNiMxXQfHopkjpVNM0u8d
         6okoTBLynWyyJtscaP9r+1ayA1GQQdRsN93oMXHKThtlcUlOQ4jqEGBZE3dnLsMUbC9j
         COwNE87HpSlsA7YB8gXEXqi8s72otRKIx7iFgrYX27V8omC6pb7qA469Qu6cZsYVGSAv
         T60g==
X-Gm-Message-State: AOAM533y9eJGKXAZfYfxEH4dqjB4+hoS3mrrxgxj6GIxSoxsU3gvsCt+
        Z37askohULvlNtwReWukm0tTnQZHuSw=
X-Google-Smtp-Source: ABdhPJwxdEgBtw92zBkACb0WlXz8qeOjvmgexTblhoiKfXRlg0fWFOV1F5G+0TZe9CHVLzmqFJ1H8A==
X-Received: by 2002:a17:902:b596:b0:158:f23a:c789 with SMTP id a22-20020a170902b59600b00158f23ac789mr6876053pls.57.1650257051289;
        Sun, 17 Apr 2022 21:44:11 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w7-20020aa79547000000b0050a63adbb32sm3948110pfq.112.2022.04.17.21.44.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Apr 2022 21:44:10 -0700 (PDT)
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
        Mike Pattrick <mailmpattric@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net 2/2] virtio_net: check L3 protocol for VLAN packets
Date:   Mon, 18 Apr 2022 12:43:39 +0800
Message-Id: <20220418044339.127545-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220418044339.127545-1-liuhangbin@gmail.com>
References: <20220418044339.127545-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For gso packets, virtio_net_hdr_to_skb() will check the protocol via
virtio_net_hdr_match_proto(). But a packet may come from a raw socket
with a VLAN tag. Checking the VLAN protocol for virtio net_hdr makes no
sense. Let's check the L3 protocol if it's a VLAN packet.

Make the virtio_net_hdr_match_proto() checking for all skbs instead of
only skb without protocol setting.

Also update the data, protocol parameter for
skb_flow_dissect_flow_keys_basic() as the skb->protocol may not IP or IPv6.

Fixes: 7e5cced9ca84 ("net: accept UFOv6 packages in virtio_net_hdr_to_skb")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 include/linux/virtio_net.h | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
index a960de68ac69..97b4f9680786 100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -3,6 +3,7 @@
 #define _LINUX_VIRTIO_NET_H
 
 #include <linux/if_vlan.h>
+#include <uapi/linux/if_arp.h>
 #include <uapi/linux/tcp.h>
 #include <uapi/linux/udp.h>
 #include <uapi/linux/virtio_net.h>
@@ -102,25 +103,36 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
 		 */
 		if (gso_type && skb->network_header) {
 			struct flow_keys_basic keys;
+			__be16 protocol;
 
 			if (!skb->protocol) {
-				__be16 protocol = dev_parse_header_protocol(skb);
+				protocol = dev_parse_header_protocol(skb);
 
 				if (!protocol)
 					virtio_net_hdr_set_proto(skb, hdr);
-				else if (!virtio_net_hdr_match_proto(protocol, hdr->gso_type))
-					return -EINVAL;
 				else
 					skb->protocol = protocol;
+			} else {
+				protocol = skb->protocol;
 			}
+
+			/* Get L3 protocol if current protocol is VLAN */
+			if (likely(skb->dev->type == ARPHRD_ETHER) &&
+			    eth_type_vlan(protocol))
+				protocol = vlan_get_protocol(skb);
+
+			if (!virtio_net_hdr_match_proto(protocol, hdr->gso_type))
+				return -EINVAL;
+
 retry:
 			if (!skb_flow_dissect_flow_keys_basic(NULL, skb, &keys,
-							      NULL, 0, 0, 0,
-							      0)) {
+							      skb->data, protocol,
+							      skb_network_offset(skb),
+							      skb_headlen(skb), 0)) {
 				/* UFO does not specify ipv4 or 6: try both */
 				if (gso_type & SKB_GSO_UDP &&
-				    skb->protocol == htons(ETH_P_IP)) {
-					skb->protocol = htons(ETH_P_IPV6);
+				    protocol == htons(ETH_P_IP)) {
+					protocol = htons(ETH_P_IPV6);
 					goto retry;
 				}
 				return -EINVAL;
-- 
2.35.1

