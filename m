Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93376653D08
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 09:36:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235128AbiLVIgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 03:36:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235074AbiLVIgF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 03:36:05 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B9A720F44
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 00:36:04 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id jo4so3221897ejb.7
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 00:36:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2uMiJRSZNHDn3NW9YLYywzqW5VP6C8zvivEO2dkl/lc=;
        b=x5zfH5cKoYc7TwFJOZjSlJap9WnyBfYMaLFLkFbdCxhN4dpbErYPAq2V0J9mVs2RXY
         zDSxomDcTCDPDNcfdn4ebZnP+fpscHf1o3EjjJj6KRgJXNMqSr5zTiaNYX1DE+MhcCZU
         6w7mT7NSaF/UYCtlnCJcAiMMyqo1KnfwqLUsCIbQmhPxvW7x2o2vhLKppMXCMgxtlm4g
         dwq2mnNXvQgynAjA/7WXMXPdq0OCPVmr7PaV58DJ5WsRqhqOopFKvkmbVQ/t3b3n/Uro
         R5Voe+m3HMsmfeiAbIWQvmZp6pnAQawJJl8glR5/KbjCaJ+mYIgO9iscni6sKL2d8UZP
         3qNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2uMiJRSZNHDn3NW9YLYywzqW5VP6C8zvivEO2dkl/lc=;
        b=5KyAJlg10iZvS8t55h0TUtWoVmsEDHyRfHpQ6f4SMD1EG5o8PpedvNC/SMzbQvLBcU
         rbcDgXgausuIFEB2GXINvK2CE4sEfoQkUK+F4aItwfgvc4ZKQYLCrc1i1kV12HzeRCrx
         /JExJlvr1IWKIAZ/SNkGhkVIoynLW4TNOy5vQmLuhrXX2IW01yHLB+91z/4Kc1G0Gy6b
         Lpk/PmQi48m9WIEuIn3lde9nQxAvD+pLz8GrXcInRMR0cI/yZt+Xy8gXu2FslmYYrkqB
         yfifVEZlchVEn18PC89vvf64qagjy+FJhmKEQNU5e3//LbQRgvkrVl2pT1CmJIaKNcJH
         UsBg==
X-Gm-Message-State: AFqh2kqD8YEOOTwk6ldHLUbuhgCqWyEAfsAtQfrSsBdZqqBWLjAmOM30
        yOTjhxjsiPw3UvpYvZB3tUEXeA==
X-Google-Smtp-Source: AMrXdXvNJsbgYslmqSlpw/BpNiKogMIIBf2hsJYS+/heVsntym5fUx2DaCfXFcfB8MDu7YeMuDw8Rw==
X-Received: by 2002:a17:906:b7c4:b0:7c0:dac7:36dc with SMTP id fy4-20020a170906b7c400b007c0dac736dcmr7495896ejb.46.1671698162883;
        Thu, 22 Dec 2022 00:36:02 -0800 (PST)
Received: from alba.. ([82.77.81.131])
        by smtp.gmail.com with ESMTPSA id t16-20020a1709060c5000b007c14ae38a80sm7987721ejf.122.2022.12.22.00.36.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Dec 2022 00:36:02 -0800 (PST)
From:   Tudor Ambarus <tudor.ambarus@linaro.org>
To:     stable@vger.kernel.org
Cc:     willemdebruijn.kernel@gmail.com, mst@redhat.com,
        jasowang@redhat.com, edumazet@google.com,
        virtualization@lists.linux-foundation.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        willemb@google.com, syzkaller@googlegroups.com,
        liuhangbin@gmail.com, linux-kernel@vger.kernel.org,
        joneslee@google.com,
        syzbot+3d91b8dbbcf515400e92@syzkaller.appspotmail.com,
        Tudor Ambarus <tudor.ambarus@linaro.org>
Subject: [PATCH 1/2] net/af_packet: add VLAN support for AF_PACKET SOCK_RAW GSO
Date:   Thu, 22 Dec 2022 10:35:44 +0200
Message-Id: <20221222083545.1972489-2-tudor.ambarus@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221222083545.1972489-1-tudor.ambarus@linaro.org>
References: <20221222083545.1972489-1-tudor.ambarus@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit dfed913e8b55a0c2c4906f1242fd38fd9a116e49 ]

Before the blammed commit, the kernel drops GSO VLAN tagged packet if it's
created with socket(AF_PACKET, SOCK_RAW, 0) plus virtio_net_hdr.
The reason is AF_PACKET doesn't adjust the skb network header if there is
a VLAN tag. Then after virtio_net_hdr_set_proto() called, the skb->protocol
will be set to ETH_P_IP/IPv6. And in later inet/ipv6_gso_segment() the skb
is dropped as network header position is invalid.

The blammed commit introduces a kernel BUG in __skb_gso_segment for
AF_PACKET SOCK_RAW GSO VLAN tagged packets. What happens is that
virtio_net_hdr_set_proto() exists early as skb->protocol is already set to
ETH_P_ALL. Then in packet_parse_headers() skb->protocol is set to
ETH_P_8021AD, but neither the network header position is adjusted, nor the
mac header is pulled. Thus when we get to validate the xmit skb and enter
skb_mac_gso_segment(), skb->mac_len has value 14, but vlan_depth gets
updated to 18 after skb_network_protocol() is called. This causes the
BUG_ON from __skb_pull(skb, vlan_depth) to be hit, as the mac header has
not been pulled yet.

Let's handle VLAN packets by adjusting network header position in
packet_parse_headers(). The adjustment is safe and does not affect the
later xmit as tap device also did that. The mac header pull is handled in
a following commit:
commit e9d3f80935b6 ("net/af_packet: make sure to pull mac header")

In packet_snd(), packet_parse_headers() need to be moved before calling
virtio_net_hdr_set_proto(), so we can set correct skb->protocol and
network header first.

There is no need to update tpacket_snd() as it calls packet_parse_headers()
in tpacket_fill_skb(), which is already before calling virtio_net_hdr_*
functions.

skb->no_fcs setting is also moved upper to make all skb settings together
and keep consistency with function packet_sendmsg_spkt().

Cc: stable@vger.kernel.org # 5.4+
Fixes: 1ed1d5921139 ("net: skip virtio_net_hdr_set_proto if protocol already set")
Reported-by: syzbot+3d91b8dbbcf515400e92@syzkaller.appspotmail.com
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Link: https://lore.kernel.org/r/20220425014502.985464-1-liuhangbin@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Tested-by: Tudor Ambarus <tudor.ambarus@linaro.org>
[ta: Update commit description, add Cc, Fixes, Reported-by and Tested-by.]
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
---
 net/packet/af_packet.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index ceca0d6c41b5..f25fa75fe651 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1888,12 +1888,20 @@ static int packet_rcv_spkt(struct sk_buff *skb, struct net_device *dev,
 
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
 
@@ -3008,6 +3016,11 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
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
@@ -3016,11 +3029,6 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
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
2.34.1

