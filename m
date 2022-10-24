Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65DD460B7A1
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 21:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232952AbiJXT21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 15:28:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232757AbiJXT1p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 15:27:45 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D74013CC0
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 10:59:31 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id b2so17991712lfp.6
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 10:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wat2wDgkkLK6F0fgO5Mq6n4q8cRpJuAITWLiaEShUng=;
        b=BG7Wlf4IxwqAmCeStohIC12GCw+6vdOfu8TaZVOjZUjlrjEvnwcCwdkcpuWrf8vkKI
         1dF9dU/PnF37GjIWQJu79lWjGcRJOHlVD/zLj181rQJgJhhB8DY72JIItT+S3iRf/Lwt
         kJMqAiL0S66FJrB5N4tNvklSjrGbeIfL9eoGmrkqAeEVckAbo5fslXuHi5PlasB/SswL
         44WQLZ74L5wDASUzPKhZKXlnBg8T4Ia8YTKyDEM1mR10VUogvivOmYMVZF/va9Qr0U+2
         VFPyZNSd0SktTWwzrax9vr6jOK4J2A/IqYlaCZIXQehh5piP/5j5UN5+G1+ccZambRkj
         lIIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wat2wDgkkLK6F0fgO5Mq6n4q8cRpJuAITWLiaEShUng=;
        b=w2uOF4zSqADkPwevmUkmpEwadZ+4wNYNEEot4vXUqeQvPqzL1bSghX2sA0WS/Td0oA
         0GbgXMgarfXdJly8rH/nqwq+CmBtiUFf8409/5+KqIRZbg+Ozl9auXWQyLeMudED+pF7
         PwqFDXCTg8HLtdzw5mg8vl5yGZsULvUbF61CSWX3raJNJydMjQlpeYuiv+pAZqD2mriM
         XmNG/+DLfFoHDAfh4Pgsd3PUmsyehTK1UsIRTP4QDMO4tVeUKIDKyBsHoqyOAlo0+E4Q
         5PEhUJsZRBeSD2GyrEgaEXJ15ilwFGberQyDVC7/mAWtLhI+KmAEcoKVa51J8l94TJhA
         FVhQ==
X-Gm-Message-State: ACrzQf1ir+mWZMuyhmdbdPHzWDd90dSjrvmVzlxQBVzvcMAngynEbCIT
        r7XrhZ+a3HUW1r0WZaN0FtviUtsfEGTWCg==
X-Google-Smtp-Source: AMsMyM4OogD4hiZThf/GTaG1oyen8IKNdFEg6LcD/aK5YEoD8CwEeIim00OBk7ikk7+jgZg5w9IibA==
X-Received: by 2002:a05:6512:2815:b0:4a4:5399:82bf with SMTP id cf21-20020a056512281500b004a4539982bfmr11736527lfb.16.1666634324015;
        Mon, 24 Oct 2022 10:58:44 -0700 (PDT)
Received: from saproj-Latitude-5501.yandex.net ([2a02:6b8:0:40c:edda:6b39:d3b6:5eb0])
        by smtp.gmail.com with ESMTPSA id p10-20020a2eb7ca000000b0027700021d0csm78529ljo.3.2022.10.24.10.58.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 10:58:43 -0700 (PDT)
From:   Sergei Antonov <saproj@gmail.com>
To:     netdev@vger.kernel.org
Cc:     olteanv@gmail.com, andrew@lunn.ch, pabeni@redhat.com,
        kuba@kernel.org, edumazet@google.com, davem@davemloft.net,
        Sergei Antonov <saproj@gmail.com>
Subject: [PATCH v5 net-next] net: ftmac100: support mtu > 1500
Date:   Mon, 24 Oct 2022 20:58:23 +0300
Message-Id: <20221024175823.145894-1-saproj@gmail.com>
X-Mailer: git-send-email 2.34.1
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

The ftmac100 controller considers packets >1518 (1500 + Ethernet + FCS)
FTL (frame too long) and drops them. That is fine with mtu 1500 or less
and it saves CPU time. When DSA is present, mtu is bigger (for VLAN
tagging) and the controller's built-in behavior is not desired then. We
can make the controller deliver FTL packets to the driver by setting
FTMAC100_MACCR_RX_FTL. Then we have to check ftmac100_rxdes_frame_length()
(packet length sans FCS) on packets marked with FTMAC100_RXDES0_FTL flag.

Check for mtu > 1500 in .ndo_open() and set FTMAC100_MACCR_RX_FTL to let
the driver FTL packets. Implement .ndo_change_mtu() and check for
mtu > 1500 to set/clear FTMAC100_MACCR_RX_FTL dynamically.

Fixes: 8d77c036b57c ("net: add Faraday FTMAC100 10/100 Ethernet driver")
Signed-off-by: Sergei Antonov <saproj@gmail.com>
---
v5:
* Handle ndo_change_mtu().
* Make description and code comments correct (hopefully).

v4:
* Set FTMAC100_MACCR_RX_FTL depending on the "mtu > 1500" condition.
* DSA tagging seems unrelated to the issue - updated description and a
code comment accordingly.

v3:
* Corrected the explanation of the problem: datasheet is correct.
* Rewrote the code to use the currently set mtu to handle DSA frames.

v2:
* Typos in description fixed.

 drivers/net/ethernet/faraday/ftmac100.c | 52 +++++++++++++++++++++++--
 1 file changed, 49 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/faraday/ftmac100.c b/drivers/net/ethernet/faraday/ftmac100.c
index d95d78230828..f276d54bcd85 100644
--- a/drivers/net/ethernet/faraday/ftmac100.c
+++ b/drivers/net/ethernet/faraday/ftmac100.c
@@ -159,6 +159,7 @@ static void ftmac100_set_mac(struct ftmac100 *priv, const unsigned char *mac)
 static int ftmac100_start_hw(struct ftmac100 *priv)
 {
 	struct net_device *netdev = priv->netdev;
+	unsigned int maccr;
 
 	if (ftmac100_reset(priv))
 		return -EIO;
@@ -175,7 +176,20 @@ static int ftmac100_start_hw(struct ftmac100 *priv)
 
 	ftmac100_set_mac(priv, netdev->dev_addr);
 
-	iowrite32(MACCR_ENABLE_ALL, priv->base + FTMAC100_OFFSET_MACCR);
+	maccr = MACCR_ENABLE_ALL;
+
+	/* We have to set FTMAC100_MACCR_RX_FTL in case MTU > 1500
+	 * and do extra length check in ftmac100_rx_packet_error().
+	 * Otherwise the controller silently drops these packets.
+	 *
+	 * When the MTU of the interface is standard 1500, rely on
+	 * the controller's functionality to drop too long packets
+	 * and save some CPU time.
+	 */
+	if (netdev->mtu > 1500)
+		maccr |= FTMAC100_MACCR_RX_FTL;
+
+	iowrite32(maccr, priv->base + FTMAC100_OFFSET_MACCR);
 	return 0;
 }
 
@@ -337,9 +351,18 @@ static bool ftmac100_rx_packet_error(struct ftmac100 *priv,
 		error = true;
 	}
 
-	if (unlikely(ftmac100_rxdes_frame_too_long(rxdes))) {
+	/* If the frame-too-long flag FTMAC100_RXDES0_FTL is set, check
+	 * if ftmac100_rxdes_frame_length(rxdes) exceeds the currently
+	 * set MTU plus ETH_HLEN. FCS is not included here.
+	 * The controller would set FTMAC100_RXDES0_FTL for all incoming
+	 * frames longer than 1518 (includeing FCS) in the presence of
+	 * FTMAC100_MACCR_RX_FTL in the MAC Control Register.
+	 */
+	if (unlikely(ftmac100_rxdes_frame_too_long(rxdes) &&
+		     ftmac100_rxdes_frame_length(rxdes) > netdev->mtu + ETH_HLEN)) {
 		if (net_ratelimit())
-			netdev_info(netdev, "rx frame too long\n");
+			netdev_info(netdev, "rx frame too long (%u)\n",
+				    ftmac100_rxdes_frame_length(rxdes));
 
 		netdev->stats.rx_length_errors++;
 		error = true;
@@ -1037,6 +1060,28 @@ static int ftmac100_do_ioctl(struct net_device *netdev, struct ifreq *ifr, int c
 	return generic_mii_ioctl(&priv->mii, data, cmd, NULL);
 }
 
+static int ftmac100_change_mtu(struct net_device *netdev, int new_mtu)
+{
+	struct ftmac100 *priv = netdev_priv(netdev);
+	unsigned int maccr;
+
+	maccr = ioread32(priv->base + FTMAC100_OFFSET_MACCR);
+	if (new_mtu <= 1500) {
+		/* Let the controller drop incoming packets greater
+		 * than 1518 (that is 1500 + 14 Ethernet + 4 FCS).
+		 */
+		maccr &= ~FTMAC100_MACCR_RX_FTL;
+	} else {
+		/* process FTL packets in the driver */
+		maccr |= FTMAC100_MACCR_RX_FTL;
+	}
+	iowrite32(maccr, priv->base + FTMAC100_OFFSET_MACCR);
+
+	netdev->mtu = new_mtu;
+	netdev_info(netdev, "changed mtu to %d\n", new_mtu);
+	return 0;
+}
+
 static const struct net_device_ops ftmac100_netdev_ops = {
 	.ndo_open		= ftmac100_open,
 	.ndo_stop		= ftmac100_stop,
@@ -1044,6 +1089,7 @@ static const struct net_device_ops ftmac100_netdev_ops = {
 	.ndo_set_mac_address	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_eth_ioctl		= ftmac100_do_ioctl,
+	.ndo_change_mtu		= ftmac100_change_mtu,
 };
 
 /******************************************************************************
-- 
2.34.1

