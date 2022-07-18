Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAFEC578E91
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 01:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235780AbiGRX6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 19:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235784AbiGRX62 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 19:58:28 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FBE033A1C;
        Mon, 18 Jul 2022 16:58:25 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id 70so12083781pfx.1;
        Mon, 18 Jul 2022 16:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pG0N4u96Y3Q7sKNcYzJoKZvufudR9Bye3mfkiP/vITk=;
        b=kJ+gr77ByQwmateTKMuk5p5k71vr62WdcAA9xkjmgtQwT0pzA5TuWcLBw2I2r0SgtV
         tCuxix6GMCpaTAcHlglVWo3owYpTI+KGSyVklEuFc4ZfanV2Xti2/ct8KnENCb1Zc7UJ
         WbyPHcUtLkSaYD3E1u2k+t04VLkc3gyA5ErJjkJvppNJGhDs/E+BFVZ7gXr0s0uc6KEM
         3SmYg7Rrd9Y/knZynGCHF0qbYHbu81uRZC0RohxYWY0C9B951I++J44Mw3/vz/IDipjt
         5Sto2nHgMwUZmGmRFD0k6jXsRflSTHPW+B3eBNM8si7seVBIOdFAPzW6LEzyV+h7JAZm
         wZgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pG0N4u96Y3Q7sKNcYzJoKZvufudR9Bye3mfkiP/vITk=;
        b=VlcgYEdAs0i7HoKVpnCnrXdWYKkLWrem01kPa6xLhxCrPc8JYFLZusnkxj65eZy08B
         qynA6xgA0Ww7ad9H8uZwEZIQZBjQOwixogDDGVbC94w48xYRB3Qr3/gLheM1ds9BBdpM
         IBmrcRUgCU3n0mTp9bPbAd3qUaYRZ3cd6GJ3VwnW5HHU9Ar0BLwnMv+NONjQWKffdG8v
         3tUwkjLxsyvKOi6qswU4zB0yGSymL814I9kW0JpV3jmzAEoQWVwz//iaJVu/01kiZczE
         RQouqtOgbbx/Y0BCHJ6PzQQk2CVBQkDCwAkuHwSwAOkahR5RrRKSC4hfRw5vAtDOqSuO
         GwJA==
X-Gm-Message-State: AJIora/DtR45355ykCdJVn4XR3GFa7pb2C37zfdZPXfr9C/vWzq6SDOQ
        ZXbkT5UasjPAs8gDhXYS5oERuv+EukE=
X-Google-Smtp-Source: AGRyM1sqfDpJP4Btxd2ClzkJbM/K+hAKokSVRpfHaBA4mY9VWvGMXYEXTssJhvAIlzIQcvFu96cGAw==
X-Received: by 2002:a63:2b84:0:b0:412:5277:99dc with SMTP id r126-20020a632b84000000b00412527799dcmr26165686pgr.208.1658188703826;
        Mon, 18 Jul 2022 16:58:23 -0700 (PDT)
Received: from stbirv-lnx-2.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j20-20020a170902759400b00161ccdc172dsm10027067pll.300.2022.07.18.16.58.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Jul 2022 16:58:23 -0700 (PDT)
From:   justinpopo6@gmail.com
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, jannh@google.com, jackychou@asix.com.tw,
        jesionowskigreg@gmail.com, joalonsof@gmail.com,
        justinpopo6@gmail.com, pabeni@redhat.com, kuba@kernel.org,
        edumazet@google.com, davem@davemloft.net, f.fainelli@gmail.com
Cc:     justin.chen@broadcom.com
Subject: [PATCH 1/5] net: usb: ax88179_178a: remove redundant init code
Date:   Mon, 18 Jul 2022 16:58:05 -0700
Message-Id: <1658188689-30846-2-git-send-email-justinpopo6@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1658188689-30846-1-git-send-email-justinpopo6@gmail.com>
References: <1658188689-30846-1-git-send-email-justinpopo6@gmail.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Justin Chen <justinpopo6@gmail.com>

Bind and reset are basically doing the same thing. Remove the duplicate
code and have bind call into reset.

Signed-off-by: Justin Chen <justinpopo6@gmail.com>
---
 drivers/net/usb/ax88179_178a.c | 79 +++---------------------------------------
 1 file changed, 4 insertions(+), 75 deletions(-)

diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index ac2d400..e0de98c 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -164,6 +164,8 @@
 	#define GMII_PHY_PGSEL_PAGE3	0x0003
 	#define GMII_PHY_PGSEL_PAGE5	0x0005
 
+static int ax88179_reset(struct usbnet *dev);
+
 struct ax88179_data {
 	u8  eee_enabled;
 	u8  eee_active;
@@ -1326,7 +1328,6 @@ static int ax88179_bind(struct usbnet *dev, struct usb_interface *intf)
 	u16 *tmp16;
 	u8 *tmp;
 	struct ax88179_data *ax179_data = (struct ax88179_data *)dev->data;
-	struct ethtool_eee eee_data;
 
 	usbnet_get_endpoints(dev, intf);
 
@@ -1335,34 +1336,6 @@ static int ax88179_bind(struct usbnet *dev, struct usb_interface *intf)
 
 	memset(ax179_data, 0, sizeof(*ax179_data));
 
-	/* Power up ethernet PHY */
-	*tmp16 = 0;
-	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_PHYPWR_RSTCTL, 2, 2, tmp16);
-	*tmp16 = AX_PHYPWR_RSTCTL_IPRL;
-	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_PHYPWR_RSTCTL, 2, 2, tmp16);
-	msleep(200);
-
-	*tmp = AX_CLK_SELECT_ACS | AX_CLK_SELECT_BCS;
-	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_CLK_SELECT, 1, 1, tmp);
-	msleep(100);
-
-	/* Read MAC address from DTB or asix chip */
-	ax88179_get_mac_addr(dev);
-	memcpy(dev->net->perm_addr, dev->net->dev_addr, ETH_ALEN);
-
-	/* RX bulk configuration */
-	memcpy(tmp, &AX88179_BULKIN_SIZE[0], 5);
-	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_RX_BULKIN_QCTRL, 5, 5, tmp);
-
-	dev->rx_urb_size = 1024 * 20;
-
-	*tmp = 0x34;
-	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_PAUSE_WATERLVL_LOW, 1, 1, tmp);
-
-	*tmp = 0x52;
-	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_PAUSE_WATERLVL_HIGH,
-			  1, 1, tmp);
-
 	dev->net->netdev_ops = &ax88179_netdev_ops;
 	dev->net->ethtool_ops = &ax88179_ethtool_ops;
 	dev->net->needed_headroom = 8;
@@ -1384,46 +1357,7 @@ static int ax88179_bind(struct usbnet *dev, struct usb_interface *intf)
 
 	netif_set_tso_max_size(dev->net, 16384);
 
-	/* Enable checksum offload */
-	*tmp = AX_RXCOE_IP | AX_RXCOE_TCP | AX_RXCOE_UDP |
-	       AX_RXCOE_TCPV6 | AX_RXCOE_UDPV6;
-	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_RXCOE_CTL, 1, 1, tmp);
-
-	*tmp = AX_TXCOE_IP | AX_TXCOE_TCP | AX_TXCOE_UDP |
-	       AX_TXCOE_TCPV6 | AX_TXCOE_UDPV6;
-	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_TXCOE_CTL, 1, 1, tmp);
-
-	/* Configure RX control register => start operation */
-	*tmp16 = AX_RX_CTL_DROPCRCERR | AX_RX_CTL_IPE | AX_RX_CTL_START |
-		 AX_RX_CTL_AP | AX_RX_CTL_AMALL | AX_RX_CTL_AB;
-	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_RX_CTL, 2, 2, tmp16);
-
-	*tmp = AX_MONITOR_MODE_PMETYPE | AX_MONITOR_MODE_PMEPOL |
-	       AX_MONITOR_MODE_RWMP;
-	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_MONITOR_MOD, 1, 1, tmp);
-
-	/* Configure default medium type => giga */
-	*tmp16 = AX_MEDIUM_RECEIVE_EN | AX_MEDIUM_TXFLOW_CTRLEN |
-		 AX_MEDIUM_RXFLOW_CTRLEN | AX_MEDIUM_FULL_DUPLEX |
-		 AX_MEDIUM_GIGAMODE;
-	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_MEDIUM_STATUS_MODE,
-			  2, 2, tmp16);
-
-	ax88179_led_setting(dev);
-
-	ax179_data->eee_enabled = 0;
-	ax179_data->eee_active = 0;
-
-	ax88179_disable_eee(dev);
-
-	ax88179_ethtool_get_eee(dev, &eee_data);
-	eee_data.advertised = 0;
-	ax88179_ethtool_set_eee(dev, &eee_data);
-
-	/* Restart autoneg */
-	mii_nway_restart(&dev->mii);
-
-	usbnet_link_change(dev, 0, 0);
+	ax88179_reset(dev);
 
 	return 0;
 }
@@ -1716,6 +1650,7 @@ static int ax88179_reset(struct usbnet *dev)
 
 	/* Read MAC address from DTB or asix chip */
 	ax88179_get_mac_addr(dev);
+	memcpy(dev->net->perm_addr, dev->net->dev_addr, ETH_ALEN);
 
 	/* RX bulk configuration */
 	memcpy(tmp, &AX88179_BULKIN_SIZE[0], 5);
@@ -1730,12 +1665,6 @@ static int ax88179_reset(struct usbnet *dev)
 	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_PAUSE_WATERLVL_HIGH,
 			  1, 1, tmp);
 
-	dev->net->features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-			      NETIF_F_RXCSUM;
-
-	dev->net->hw_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-				 NETIF_F_RXCSUM;
-
 	/* Enable checksum offload */
 	*tmp = AX_RXCOE_IP | AX_RXCOE_TCP | AX_RXCOE_UDP |
 	       AX_RXCOE_TCPV6 | AX_RXCOE_UDPV6;
-- 
2.7.4

