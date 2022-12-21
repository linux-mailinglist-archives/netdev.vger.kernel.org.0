Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ECE265308D
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 13:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbiLUMG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 07:06:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiLUMG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 07:06:27 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD841C930
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 04:06:24 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id ay40so11011011wmb.2
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 04:06:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aK+harKFdh05j7ikUbsUL9aBNPAUblg48ttg0Rk1PY0=;
        b=IEVuxoUap2KilZ+w1fxmOQtAeVzY82k+84OlD6p3sdYWVhvtl+JrA8hIBYpyoaX8uY
         qdbg8yYRVY/avh7iOGf3ZJYwXYpMeOW6BE36hINj3oXhR0ifgPKBQqYCRbJzj6C4p70b
         50O8gTPNsAed4ijZJSCclUl+RB0VHZDcErLJGTRq6aXnk9D+/NoXkWxSQRVYUrKWt0Er
         PzTaCdv3eP+I6mNsmMeTS5N7udle4qqQGE7kMLjBdMgZUPuWhIZzTNESt/J/JlS33p2L
         hDC7941sBhFh9JZjUTgvKwQg7ae0B9FxlWAtWrvqEPOJRs4BWN0GZpSYxJDqDXMG2/+j
         cgNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aK+harKFdh05j7ikUbsUL9aBNPAUblg48ttg0Rk1PY0=;
        b=jRD4HDFxQreuwqH/gl6+dTwgEs9VBYAHBuKzcUsYqzVINymMS7moOZLcMn1+J7ujI1
         oxEsABQr+uuEyOL4elehiQ6FrKe+TOL0gEZ7rm2nSZuCIZrZr0jWROE7Fl743o0+8COO
         rQoxfONL7ZW6sE8RHoX+5VrMHLYgbkdtLSKsg3OPlkvD3x3lIoeBe1aLGaAb9RAFsIab
         695k3HXzRJ/nsZJf6DHrchph1TXnTuGsA9d/ueJrU42kFRtgZ6AumPjeR7jI6svs05OZ
         d4VyBh5IFaDspShoHD84K9lcQ+zdfpk3kOfqJ3b0zY6XCwTNmRslL+BCXtcwg+y2EY8I
         CjAw==
X-Gm-Message-State: AFqh2konvQCGtjUKt/d2aof6twxMWcN033aVjI495lh3qAv2NU5o4Wun
        W6UXF/+/nC7zLL/tRM+5q0T3EQ==
X-Google-Smtp-Source: AMrXdXvBSiQ4tAsA58ZmJ3PR3kRIyMor2XrvlGzrcNCf5mS9vAReIO1EeuyEqqJlszY260oiHhZA8Q==
X-Received: by 2002:a05:600c:1e18:b0:3d2:5e4e:701 with SMTP id ay24-20020a05600c1e1800b003d25e4e0701mr1467731wmb.31.1671624382538;
        Wed, 21 Dec 2022 04:06:22 -0800 (PST)
Received: from localhost.localdomain (bzq-84-110-153-254.static-ip.bezeqint.net. [84.110.153.254])
        by smtp.gmail.com with ESMTPSA id a7-20020a05600c348700b003cf6e1df4a8sm2118768wmq.15.2022.12.21.04.06.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Dec 2022 04:06:21 -0800 (PST)
From:   Alvaro Karsz <alvaro.karsz@solid-run.com>
To:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     Alvaro Karsz <alvaro.karsz@solid-run.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH] virtio_net: send notification coalescing command only if value changed
Date:   Wed, 21 Dec 2022 14:06:18 +0200
Message-Id: <20221221120618.652074-1-alvaro.karsz@solid-run.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't send a VIRTIO_NET_CTRL_NOTF_COAL_TX_SET or
VIRTIO_NET_CTRL_NOTF_COAL_RX_SET command if the coalescing parameters
haven't changed.

Signed-off-by: Alvaro Karsz <alvaro.karsz@solid-run.com>
---
 drivers/net/virtio_net.c | 48 ++++++++++++++++++++++------------------
 1 file changed, 27 insertions(+), 21 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 7723b2a49d8..1d7118de62a 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2760,31 +2760,37 @@ static int virtnet_send_notf_coal_cmds(struct virtnet_info *vi,
 	struct virtio_net_ctrl_coal_tx coal_tx;
 	struct virtio_net_ctrl_coal_rx coal_rx;
 
-	coal_tx.tx_usecs = cpu_to_le32(ec->tx_coalesce_usecs);
-	coal_tx.tx_max_packets = cpu_to_le32(ec->tx_max_coalesced_frames);
-	sg_init_one(&sgs_tx, &coal_tx, sizeof(coal_tx));
-
-	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_NOTF_COAL,
-				  VIRTIO_NET_CTRL_NOTF_COAL_TX_SET,
-				  &sgs_tx))
-		return -EINVAL;
+	if (ec->tx_coalesce_usecs != vi->tx_usecs ||
+	    ec->tx_max_coalesced_frames != vi->tx_max_packets) {
+		coal_tx.tx_usecs = cpu_to_le32(ec->tx_coalesce_usecs);
+		coal_tx.tx_max_packets = cpu_to_le32(ec->tx_max_coalesced_frames);
+		sg_init_one(&sgs_tx, &coal_tx, sizeof(coal_tx));
+
+		if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_NOTF_COAL,
+					  VIRTIO_NET_CTRL_NOTF_COAL_TX_SET,
+					  &sgs_tx))
+			return -EINVAL;
 
-	/* Save parameters */
-	vi->tx_usecs = ec->tx_coalesce_usecs;
-	vi->tx_max_packets = ec->tx_max_coalesced_frames;
+		/* Save parameters */
+		vi->tx_usecs = ec->tx_coalesce_usecs;
+		vi->tx_max_packets = ec->tx_max_coalesced_frames;
+	}
 
-	coal_rx.rx_usecs = cpu_to_le32(ec->rx_coalesce_usecs);
-	coal_rx.rx_max_packets = cpu_to_le32(ec->rx_max_coalesced_frames);
-	sg_init_one(&sgs_rx, &coal_rx, sizeof(coal_rx));
+	if (ec->rx_coalesce_usecs != vi->rx_usecs ||
+	    ec->rx_max_coalesced_frames != vi->rx_max_packets) {
+		coal_rx.rx_usecs = cpu_to_le32(ec->rx_coalesce_usecs);
+		coal_rx.rx_max_packets = cpu_to_le32(ec->rx_max_coalesced_frames);
+		sg_init_one(&sgs_rx, &coal_rx, sizeof(coal_rx));
 
-	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_NOTF_COAL,
-				  VIRTIO_NET_CTRL_NOTF_COAL_RX_SET,
-				  &sgs_rx))
-		return -EINVAL;
+		if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_NOTF_COAL,
+					  VIRTIO_NET_CTRL_NOTF_COAL_RX_SET,
+					  &sgs_rx))
+			return -EINVAL;
 
-	/* Save parameters */
-	vi->rx_usecs = ec->rx_coalesce_usecs;
-	vi->rx_max_packets = ec->rx_max_coalesced_frames;
+		/* Save parameters */
+		vi->rx_usecs = ec->rx_coalesce_usecs;
+		vi->rx_max_packets = ec->rx_max_coalesced_frames;
+	}
 
 	return 0;
 }
-- 
2.32.0

