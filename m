Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77331578E8A
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 01:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236124AbiGRX6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 19:58:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235843AbiGRX6h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 19:58:37 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C3933A0F;
        Mon, 18 Jul 2022 16:58:34 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id x18-20020a17090a8a9200b001ef83b332f5so19793497pjn.0;
        Mon, 18 Jul 2022 16:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/pC+NXVrv1Rl0FFXYuHEZKAvudR99y67YQVF032RJmE=;
        b=TOxy2qVY7aLuiK8wYDzU8CfNpylGUJ3N9bKs/fCkt5weQ7GkIAlfnUh47QhBwEYgMf
         xZn7bWLLTYZgroVMs6A4U9LFjbMdfTAVGGFkeyxsHgOolzr6E1PDAMB3bauWxgBq8aiK
         JbAYJrsBiyK9kdz03UA3MIQu90xPHuFv02e7F/YMk25B8I4wFWWkHgjStnQAZ6+vkykK
         norF+jvoyzyVR1LWV9ZMGq98wYBvTeOmTzVB9n7ujpySJ4v2UycgodcJy+/ymYkgAVk4
         /9vdc/gfLcpXDPDC7hgm6GfBxyrkPLebsk+oRb15n/LQ0+T2RiIW6e34NWMBRyxDYwv8
         dktg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/pC+NXVrv1Rl0FFXYuHEZKAvudR99y67YQVF032RJmE=;
        b=z2OICKTsXmOlGiby+NDxeee+sLhTJf9HKvtIgeP7SobgNfKfhFV0ddYQ8fj3a8CFdz
         lmfO1brDvmqu4W9AL/m7215a+7XUVfHUbkkNjkzjfs+fgcHLSJPO6y0S9h2Dqq1ViKcS
         qE5wsgAiMtQlF9KX7ncT8/OmXVipfxDb+F2Og2VdsvDtYbrdooIROHSDsfy4wgNIh2+E
         Geus3DJtVJLEe+Igg3e/1ZaB9f8ILdnElEX0TxZ/mh4XWhRyW+bTPHAQPfp+lGPZebCw
         OS/HC5ola0uOsge9U2yXF+itUCcX9V3BPefJL3UaugbEzTfC7+9K94Ipzelnz7w0r+ed
         oXig==
X-Gm-Message-State: AJIora8TzsH0FL2wZcgAMTfy9zkReA5xF7NX7KG5TNAvfdjdwCg88/uO
        gUltCfCexy+J+eSn5SD1J+9JtwKST2M=
X-Google-Smtp-Source: AGRyM1vdZnQUarWLdr0E7axzh1ZwxrEJHg8EOB2GSqpKiDWX1aEeggLVMzGMp42zUJCmjYgFM6fUAw==
X-Received: by 2002:a17:902:ba91:b0:16c:6b8e:cd06 with SMTP id k17-20020a170902ba9100b0016c6b8ecd06mr30056876pls.33.1658188713399;
        Mon, 18 Jul 2022 16:58:33 -0700 (PDT)
Received: from stbirv-lnx-2.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j20-20020a170902759400b00161ccdc172dsm10027067pll.300.2022.07.18.16.58.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Jul 2022 16:58:32 -0700 (PDT)
From:   justinpopo6@gmail.com
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, jannh@google.com, jackychou@asix.com.tw,
        jesionowskigreg@gmail.com, joalonsof@gmail.com,
        justinpopo6@gmail.com, pabeni@redhat.com, kuba@kernel.org,
        edumazet@google.com, davem@davemloft.net, f.fainelli@gmail.com
Cc:     justin.chen@broadcom.com
Subject: [PATCH 4/5] net: usb: ax88179_178a: move priv to driver_priv
Date:   Mon, 18 Jul 2022 16:58:08 -0700
Message-Id: <1658188689-30846-5-git-send-email-justinpopo6@gmail.com>
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

We need more space to save WoL context. So lets allocate memory
for ax88179_data instead of using struct usbnet data field which
only supports 5 words. We continue to use the struct usbnet data
field for multicast filters. However since we no longer have the
private data stored there, we can shift it to the beginning.

Signed-off-by: Justin Chen <justinpopo6@gmail.com>
---
 drivers/net/usb/ax88179_178a.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index 60742bb..cb7b89f 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -170,7 +170,6 @@ struct ax88179_data {
 	u8  eee_enabled;
 	u8  eee_active;
 	u16 rxctl;
-	u16 reserved;
 	u8 in_pm;
 };
 
@@ -190,14 +189,14 @@ static const struct {
 
 static void ax88179_set_pm_mode(struct usbnet *dev, bool pm_mode)
 {
-	struct ax88179_data *ax179_data = (struct ax88179_data *)dev->data;
+	struct ax88179_data *ax179_data = dev->driver_priv;
 
 	ax179_data->in_pm = pm_mode;
 }
 
 static int ax88179_in_pm(struct usbnet *dev)
 {
-	struct ax88179_data *ax179_data = (struct ax88179_data *)dev->data;
+	struct ax88179_data *ax179_data = dev->driver_priv;
 
 	return ax179_data->in_pm;
 }
@@ -693,7 +692,7 @@ ax88179_ethtool_set_eee(struct usbnet *dev, struct ethtool_eee *data)
 static int ax88179_chk_eee(struct usbnet *dev)
 {
 	struct ethtool_cmd ecmd = { .cmd = ETHTOOL_GSET };
-	struct ax88179_data *priv = (struct ax88179_data *)dev->data;
+	struct ax88179_data *priv = dev->driver_priv;
 
 	mii_ethtool_gset(&dev->mii, &ecmd);
 
@@ -796,7 +795,7 @@ static void ax88179_enable_eee(struct usbnet *dev)
 static int ax88179_get_eee(struct net_device *net, struct ethtool_eee *edata)
 {
 	struct usbnet *dev = netdev_priv(net);
-	struct ax88179_data *priv = (struct ax88179_data *)dev->data;
+	struct ax88179_data *priv = dev->driver_priv;
 
 	edata->eee_enabled = priv->eee_enabled;
 	edata->eee_active = priv->eee_active;
@@ -807,7 +806,7 @@ static int ax88179_get_eee(struct net_device *net, struct ethtool_eee *edata)
 static int ax88179_set_eee(struct net_device *net, struct ethtool_eee *edata)
 {
 	struct usbnet *dev = netdev_priv(net);
-	struct ax88179_data *priv = (struct ax88179_data *)dev->data;
+	struct ax88179_data *priv = dev->driver_priv;
 	int ret;
 
 	priv->eee_enabled = edata->eee_enabled;
@@ -858,8 +857,8 @@ static const struct ethtool_ops ax88179_ethtool_ops = {
 static void ax88179_set_multicast(struct net_device *net)
 {
 	struct usbnet *dev = netdev_priv(net);
-	struct ax88179_data *data = (struct ax88179_data *)dev->data;
-	u8 *m_filter = ((u8 *)dev->data) + 12;
+	struct ax88179_data *data = dev->driver_priv;
+	u8 *m_filter = ((u8 *)dev->data);
 
 	data->rxctl = (AX_RX_CTL_START | AX_RX_CTL_AB | AX_RX_CTL_IPE);
 
@@ -871,7 +870,7 @@ static void ax88179_set_multicast(struct net_device *net)
 	} else if (netdev_mc_empty(net)) {
 		/* just broadcast and directed */
 	} else {
-		/* We use the 20 byte dev->data for our 8 byte filter buffer
+		/* We use dev->data for our 8 byte filter buffer
 		 * to avoid allocating memory that is tricky to free later
 		 */
 		u32 crc_bits;
@@ -1273,10 +1272,15 @@ static int ax88179_bind(struct usbnet *dev, struct usb_interface *intf)
 	u8 buf[5];
 	u16 *tmp16;
 	u8 *tmp;
-	struct ax88179_data *ax179_data = (struct ax88179_data *)dev->data;
+	struct ax88179_data *ax179_data;
 
 	usbnet_get_endpoints(dev, intf);
 
+	ax179_data = kzalloc(sizeof(*ax179_data), GFP_KERNEL);
+	if (!ax179_data)
+		return -ENOMEM;
+
+	dev->driver_priv = ax179_data;
 	tmp16 = (u16 *)buf;
 	tmp = (u8 *)buf;
 
@@ -1310,6 +1314,7 @@ static int ax88179_bind(struct usbnet *dev, struct usb_interface *intf)
 
 static void ax88179_unbind(struct usbnet *dev, struct usb_interface *intf)
 {
+	struct ax88179_data *ax179_data = dev->driver_priv;
 	u16 tmp16;
 
 	/* Configure RX control register => stop operation */
@@ -1322,6 +1327,8 @@ static void ax88179_unbind(struct usbnet *dev, struct usb_interface *intf)
 	/* Power down ethernet PHY */
 	tmp16 = 0;
 	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_PHYPWR_RSTCTL, 2, 2, &tmp16);
+
+	kfree(ax179_data);
 }
 
 static void
@@ -1498,7 +1505,7 @@ ax88179_tx_fixup(struct usbnet *dev, struct sk_buff *skb, gfp_t flags)
 
 static int ax88179_link_reset(struct usbnet *dev)
 {
-	struct ax88179_data *ax179_data = (struct ax88179_data *)dev->data;
+	struct ax88179_data *ax179_data = dev->driver_priv;
 	u8 tmp[5], link_sts;
 	u16 mode, tmp16, delay = HZ / 10;
 	u32 tmp32 = 0x40000000;
@@ -1573,7 +1580,7 @@ static int ax88179_reset(struct usbnet *dev)
 	u8 buf[5];
 	u16 *tmp16;
 	u8 *tmp;
-	struct ax88179_data *ax179_data = (struct ax88179_data *)dev->data;
+	struct ax88179_data *ax179_data = dev->driver_priv;
 	struct ethtool_eee eee_data;
 
 	tmp16 = (u16 *)buf;
-- 
2.7.4

