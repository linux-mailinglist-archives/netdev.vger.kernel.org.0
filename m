Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B94957C1A0
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 02:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230412AbiGUA2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 20:28:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbiGUA22 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 20:28:28 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4B3E6249D;
        Wed, 20 Jul 2022 17:28:26 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id gn24so101829pjb.3;
        Wed, 20 Jul 2022 17:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=X25xQ/eqdmK1FpQIMyTlSMdRWqqjHgGU7AOQyMO4Q7Y=;
        b=XdzeWtmGbMj5aPdFyVbx/Ko+XFLd4JTyIhXkdh6Mla7VBVgVl/9bGg61+n1rbG+EZn
         jRVNsYRR48J0qpPAerz48/Uoof1oHFN+idbmSRB+dnJcsDrfr7budLSVvZV6jbpXL5Kn
         FyIAJ+YODRr1hAIM50Ld5cnbWc9GC5ps0WoxefrI0CSrCSKHJSj8ea3eMkHUWaPtvBh0
         +001pDp0ZRTBKb6XW+h03ECYWfDkCbIN3TlmSIeieq5UiuD4qbuUVxqpSrz/rCnLZm6c
         xVTEELslrAzAExtrXbe0Llc1DffyK3AotDv7ie/Reluu5pIKK5RRxturEZIxQQXWD7/O
         coew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=X25xQ/eqdmK1FpQIMyTlSMdRWqqjHgGU7AOQyMO4Q7Y=;
        b=hd7KPZmQn3BI41jVaHVPu89FjjpKgPWUxBDDUGRWSd1jXjkK/4QOKJxDq7e7emeMVb
         zLBLcRj3Lo6mjWGc6RAka0mm87lykBbkk6yZ8uWut2hEY8VfdmYqYWZKVl9cHPOfD01R
         ncgQ1gykeJvmZUh0Xgo0Bd2ZlVLeGcaIWJhMSKlCiggirkc5xYNXUB39MX9R1/6/M4Ac
         E/Usbxmc6UQXXKBT7bSpB7zgw43IQyzqvuxariDmn7ENIKQUFFrG9UVUvXlK9twQH8Eo
         ww3s2KhyCpUmeKXiHxQ/gsqH3Jm7MHJWLRQ+1ik21NZGR5hNcg2iaXHoA+raBZea2t+X
         G9bA==
X-Gm-Message-State: AJIora/I5SyhLB6GQa15UgCys6754mbwPmkhiXZp3p2M9iDC9hsagh3/
        E4LvMAnXqIAhxVUHVch8lYk=
X-Google-Smtp-Source: AGRyM1vlYU0Ke4QzjR05zN7yjqDmle+chzqh0f+WQ6gBNIaoqCkdCccLWulLdO12A8XTiy40EcggyQ==
X-Received: by 2002:a17:90b:4a83:b0:1f2:2f3:9774 with SMTP id lp3-20020a17090b4a8300b001f202f39774mr8527795pjb.1.1658363306145;
        Wed, 20 Jul 2022 17:28:26 -0700 (PDT)
Received: from stbirv-lnx-2.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id m5-20020a170902db0500b0016bc4a6ce28sm163226plx.98.2022.07.20.17.28.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Jul 2022 17:28:25 -0700 (PDT)
From:   justinpopo6@gmail.com
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, joalonsof@gmail.com, jesionowskigreg@gmail.com,
        jackychou@asix.com.tw, jannh@google.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     f.fainelli@gmail.com, justin.chen@broadcom.com,
        Justin Chen <justinpopo6@gmail.com>
Subject: [PATCH v2 1/5] net: usb: ax88179_178a: remove redundant init code
Date:   Wed, 20 Jul 2022 17:28:12 -0700
Message-Id: <1658363296-15734-2-git-send-email-justinpopo6@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1658363296-15734-1-git-send-email-justinpopo6@gmail.com>
References: <1658363296-15734-1-git-send-email-justinpopo6@gmail.com>
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
 drivers/net/usb/ax88179_178a.c | 85 ++----------------------------------------
 1 file changed, 4 insertions(+), 81 deletions(-)

diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index ac2d400..b7098688 100644
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
@@ -1322,47 +1324,12 @@ static void ax88179_get_mac_addr(struct usbnet *dev)
 
 static int ax88179_bind(struct usbnet *dev, struct usb_interface *intf)
 {
-	u8 buf[5];
-	u16 *tmp16;
-	u8 *tmp;
 	struct ax88179_data *ax179_data = (struct ax88179_data *)dev->data;
-	struct ethtool_eee eee_data;
 
 	usbnet_get_endpoints(dev, intf);
 
-	tmp16 = (u16 *)buf;
-	tmp = (u8 *)buf;
-
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
@@ -1384,46 +1351,7 @@ static int ax88179_bind(struct usbnet *dev, struct usb_interface *intf)
 
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
@@ -1716,6 +1644,7 @@ static int ax88179_reset(struct usbnet *dev)
 
 	/* Read MAC address from DTB or asix chip */
 	ax88179_get_mac_addr(dev);
+	memcpy(dev->net->perm_addr, dev->net->dev_addr, ETH_ALEN);
 
 	/* RX bulk configuration */
 	memcpy(tmp, &AX88179_BULKIN_SIZE[0], 5);
@@ -1730,12 +1659,6 @@ static int ax88179_reset(struct usbnet *dev)
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

