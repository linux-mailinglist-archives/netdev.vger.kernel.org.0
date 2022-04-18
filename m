Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB042504BC2
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 06:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231889AbiDREqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 00:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236515AbiDREqp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 00:46:45 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABCD817AAA
        for <netdev@vger.kernel.org>; Sun, 17 Apr 2022 21:44:06 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id q12so16763245pgj.13
        for <netdev@vger.kernel.org>; Sun, 17 Apr 2022 21:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wePUrECsd3uupbMoCB9c5dPaZvMeGgmkP3pFM7pNm6Y=;
        b=bEwvgh72okZ2Pu2FIx7gnOfPXhm9JfuYO5jihLfp+ad/YHvjlqawfOD8PbWopHTMaR
         i1vZOxuHGk4LYaTKPlxf6Mx7vUE0S7gwcDly4CUQEZVqUFCAlGE62LuO/WsMtjsJQ8nm
         FQ+KScw5s6u+q+InEplJEgxUgtuxHgFG2f8X1HVI5muMgJvRmmtTT1XL77Lo+hwhd5qU
         wthsn0Mt9aDFaxLvGzzplEgNGcxsbna0ynIpXhhJy/0T9Mm6t5OZtERtGXC91i9lPWLp
         G9HEVRXKZRNhZU7Xaj9Ct3TPB8cCJjMY6eLeqFtCizWtI3N7Y1JI3nJJtIDVzTUN/Dtt
         VcBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wePUrECsd3uupbMoCB9c5dPaZvMeGgmkP3pFM7pNm6Y=;
        b=2d9TvlMZik9QYO8R6AthjxydEIHd6VjsjftXjkf5JTESD6yGNG2c1Q+izBER4yO8Fw
         qAqq1zRQmiYOuig9904s6X/UrtUzH8HOgzHvJN8esGiPKEOsKBWVk9RpvvFs13LrAQXf
         1SdymRztU+SV1h96VOH3R2G+ZTYL8VEk2umBU6Q0FEJQnpeCE63/tNDKtmQGPmVIP0fw
         XZAUo14BLfcyhKzGtIN+duFtsjs3QcLUFynrLuuWxwPSPOF7FCYK2JLmPqxwGZDo2Agt
         1YTgfmxIFf51wo+MntTZZEoUqjtiSbI/uYuMpTdGE2+MFzSXaFt55SCjFTXaJn4NV63i
         TOaA==
X-Gm-Message-State: AOAM532n4Sa2Wo3rncfpr9olTDg7nd2nu+t4pz2MyA3n5FQfrLbMC4mc
        I4n1d8gTl5hDoJqTbTYn9i8XROlUxvg=
X-Google-Smtp-Source: ABdhPJxd17qRsl/2sbIcjAfqiBkFRBX3Yta5r6H5qMpdhw9GP1PXm/bYOTgFx4TwuACyWWWbTPeuRg==
X-Received: by 2002:a65:5b81:0:b0:3aa:1671:c6a7 with SMTP id i1-20020a655b81000000b003aa1671c6a7mr204310pgr.169.1650257045973;
        Sun, 17 Apr 2022 21:44:05 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w7-20020aa79547000000b0050a63adbb32sm3948110pfq.112.2022.04.17.21.44.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Apr 2022 21:44:05 -0700 (PDT)
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
        Hangbin Liu <liuhangbin@gmail.com>,
        Flavio Leitner <fbl@redhat.com>
Subject: [PATCH net 1/2] net/af_packet: adjust network header position for VLAN tagged packets
Date:   Mon, 18 Apr 2022 12:43:38 +0800
Message-Id: <20220418044339.127545-2-liuhangbin@gmail.com>
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

Flavio reported that the kernel drops GSO VLAN tagged packet if it's
created with socket(AF_PACKET, SOCK_RAW, 0) plus virtio_net_hdr.

The reason is AF_PACKET doesn't adjust the skb network header if there is
a VLAN tag. Then after virtio_net_hdr_set_proto() called, the skb->protocol
will be set to ETH_P_IP/IPv6. And in later inet/ipv6_gso_segment() the skb
is dropped as network header position is invalid.

Fix it by adjusting network header position in packet_parse_headers()
and move the function before calling virtio_net_hdr_* functions.

I also moved skb->no_fcs setting upper to make all skb setting together
and keep consistence of function packet_sendmsg_spkt().

No need to update tpacket_snd() as it calls packet_parse_headers() in
tpacket_fill_skb() before calling virtio_net_hdr_* functions.

Fixes: 75c65772c3d1 ("net/packet: Ask driver for protocol if not provided by user")
Reported-by: Flavio Leitner <fbl@redhat.com>
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

