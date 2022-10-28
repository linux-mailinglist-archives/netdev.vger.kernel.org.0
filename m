Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5C8B611A21
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 20:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbiJ1Sct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 14:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbiJ1Scq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 14:32:46 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C10229E6A
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 11:32:44 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id j14so9380945ljh.12
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 11:32:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bmBXWkBELaUb/3uoJHe5dEnBNPl10KZF7tILoAgc144=;
        b=H9ZjpEGNHbrdov6qfLrSw66SJqUNko5ayuxr2U4tLUKNjDdxWEblFLk+VMiqCai2oO
         tegYYzW8YnXKOrcdczeWX0DUxor41wUMv8y2GFCQONpYidyK9G4N33LDVkttd0oaOc9R
         fYJsHv5JWL1XV0VljLRAptkMByFPJnyURoLJxTHFGcQuRYFLR38ogydwHxjNoUyL2OXH
         pXdtaV0nPHFcQCdVbLOkb/GWGsXBif0e3ogcayUpJCbx6GQZ4FMJz/nx9aafMsrr6FVh
         4DRcUY04e+ds4/dHZd/XwgRAFb2VEaMsBLsf7QLAqvJ0D5besDHQl9MOy3Yr6F2xfxpr
         qpdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bmBXWkBELaUb/3uoJHe5dEnBNPl10KZF7tILoAgc144=;
        b=jsQjdG/5NH5HDnASK+3/pta+lrdr61ZQGEWwmx8kKmiHc7DigKXtxbfce4zhuD1yE/
         OD04nHybsNxEon1/kNuUeox9uDo+l4A7ofYYX+UYBEsyQtAYyy1iTO0AOxQyLbHsvJdL
         IgOLOTwNLO3JsC/FN4r0pR+iF5k7RaFhlD/l30BIn8tNyV3mPVHZPwmp3y4exigokfIO
         /BwS0sbqTirRkSKL6UdbRrqp+uOVi+txGwXwSp0rekXg7/RssIUw+wdlM2wRqEn0O4Fi
         sukJBzyqTCiSiVuqpdk/cRE9x7p0nLWhbi8M27DeSjxxx/ikXYIazp6ba0RbevJni6SK
         Z4Tw==
X-Gm-Message-State: ACrzQf1VHdqGOz6J+8k3bHw8yq8E8nOzVdgiEEiSxP+nrj6hE5PcBJNw
        uHkVc9T/JazAhbT7whN3sUPvviohIqbwzg==
X-Google-Smtp-Source: AMsMyM5xmMishQwz8LTqv7PQmv9D5NwiYw5e7DT6TEPvPjfz3ltmrFqsHZOPt0ozw1EInK2S9UMCyg==
X-Received: by 2002:a2e:94cf:0:b0:26c:5d14:6ec7 with SMTP id r15-20020a2e94cf000000b0026c5d146ec7mr343127ljh.237.1666981963319;
        Fri, 28 Oct 2022 11:32:43 -0700 (PDT)
Received: from saproj-Latitude-5501.yandex.net ([2a02:6b8:0:40c:5e0d:c276:399c:5839])
        by smtp.gmail.com with ESMTPSA id k2-20020a2eb742000000b0026dc7b59d8esm739161ljo.22.2022.10.28.11.32.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 11:32:43 -0700 (PDT)
From:   Sergei Antonov <saproj@gmail.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, pabeni@redhat.com, kuba@kernel.org,
        edumazet@google.com, davem@davemloft.net,
        Sergei Antonov <saproj@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH 3/3] net: ftmac100: allow increasing MTU to make most use of single-segment buffers
Date:   Fri, 28 Oct 2022 21:32:20 +0300
Message-Id: <20221028183220.155948-3-saproj@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221028183220.155948-1-saproj@gmail.com>
References: <20221028183220.155948-1-saproj@gmail.com>
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

If the FTMAC100 is used as a DSA master, then it is expected that frames
which are MTU sized on the wire facing the external switch port (1500
octets in L2 payload, plus L2 header) also get a DSA tag when seen by
the host port.

This extra tag increases the length of the packet as the host port sees
it, and the FTMAC100 is not prepared to handle frames whose length
exceeds 1518 octets (including FCS) at all.

Only a minimal rework is needed to support this configuration. Since
MTU-sized DSA-tagged frames still fit within a single buffer (RX_BUF_SIZE),
we just need to optimize the resource management rather than implement
multi buffer RX.

In ndo_change_mtu(), we toggle the FTMAC100_MACCR_RX_FTL bit to tell the
hardware to drop (or not) frames with an L2 payload length larger than
1500. We need to replicate the MACCR configuration in ftmac100_start_hw()
as well, since there is a hardware reset there which clears previous
settings.

The advantage of dynamically changing FTMAC100_MACCR_RX_FTL is that when
dev->mtu is at the default value of 1500, large frames are automatically
dropped in hardware and we do not spend CPU cycles dropping them.

Suggested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Sergei Antonov <saproj@gmail.com>
---
 drivers/net/ethernet/faraday/ftmac100.c | 33 +++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/faraday/ftmac100.c b/drivers/net/ethernet/faraday/ftmac100.c
index 7c571b4515a9..6c8c78018ce6 100644
--- a/drivers/net/ethernet/faraday/ftmac100.c
+++ b/drivers/net/ethernet/faraday/ftmac100.c
@@ -11,6 +11,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
+#include <linux/if_ether.h>
 #include <linux/if_vlan.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
@@ -28,8 +29,8 @@
 #define RX_QUEUE_ENTRIES	128	/* must be power of 2 */
 #define TX_QUEUE_ENTRIES	16	/* must be power of 2 */
 
-#define MAX_PKT_SIZE		1518
 #define RX_BUF_SIZE		2044	/* must be smaller than 0x7ff */
+#define MAX_PKT_SIZE		RX_BUF_SIZE /* multi-segment not supported */
 
 #if MAX_PKT_SIZE > 0x7ff
 #error invalid MAX_PKT_SIZE
@@ -160,6 +161,7 @@ static void ftmac100_set_mac(struct ftmac100 *priv, const unsigned char *mac)
 static int ftmac100_start_hw(struct ftmac100 *priv)
 {
 	struct net_device *netdev = priv->netdev;
+	unsigned int maccr = MACCR_ENABLE_ALL;
 
 	if (ftmac100_reset(priv))
 		return -EIO;
@@ -176,7 +178,11 @@ static int ftmac100_start_hw(struct ftmac100 *priv)
 
 	ftmac100_set_mac(priv, netdev->dev_addr);
 
-	iowrite32(MACCR_ENABLE_ALL, priv->base + FTMAC100_OFFSET_MACCR);
+	 /* See ftmac100_change_mtu() */
+	if (netdev->mtu > ETH_DATA_LEN)
+		maccr |= FTMAC100_MACCR_RX_FTL;
+
+	iowrite32(maccr, priv->base + FTMAC100_OFFSET_MACCR);
 	return 0;
 }
 
@@ -1033,6 +1039,28 @@ static int ftmac100_do_ioctl(struct net_device *netdev, struct ifreq *ifr, int c
 	return generic_mii_ioctl(&priv->mii, data, cmd, NULL);
 }
 
+static int ftmac100_change_mtu(struct net_device *netdev, int mtu)
+{
+	struct ftmac100 *priv = netdev_priv(netdev);
+	unsigned int maccr;
+
+	maccr = ioread32(priv->base + FTMAC100_OFFSET_MACCR);
+	if (mtu > ETH_DATA_LEN) {
+		/* process long packets in the driver */
+		maccr |= FTMAC100_MACCR_RX_FTL;
+	} else {
+		/* Let the controller drop incoming packets greater
+		 * than 1518 (that is 1500 + 14 Ethernet + 4 FCS).
+		 */
+		maccr &= ~FTMAC100_MACCR_RX_FTL;
+	}
+	iowrite32(maccr, priv->base + FTMAC100_OFFSET_MACCR);
+
+	netdev->mtu = mtu;
+
+	return 0;
+}
+
 static const struct net_device_ops ftmac100_netdev_ops = {
 	.ndo_open		= ftmac100_open,
 	.ndo_stop		= ftmac100_stop,
@@ -1040,6 +1068,7 @@ static const struct net_device_ops ftmac100_netdev_ops = {
 	.ndo_set_mac_address	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_eth_ioctl		= ftmac100_do_ioctl,
+	.ndo_change_mtu		= ftmac100_change_mtu,
 };
 
 /******************************************************************************
-- 
2.34.1

