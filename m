Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDF3B57C19B
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 02:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbiGUA2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 20:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231163AbiGUA2f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 20:28:35 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0C3974E08;
        Wed, 20 Jul 2022 17:28:33 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id gn24so102051pjb.3;
        Wed, 20 Jul 2022 17:28:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=rh9YWokngbonE7Snp74VlZyhTT2Pt7ct+I3KRd5dUQE=;
        b=d+MVuRSQtzLWRPUnPXnw6UNv/OhZrSgzUgTCv05PcDVsh6TbUsMgWNzVH531ZHsKOy
         cU3KsYJbb3GMbWNVbDcminHsn97+JfrdtnV8iAqXxcISombKkAj9inpvaopHQBHERLbG
         CpW2mTdUu2olN/uocdig05kDVY0vEIVLhZEtjgpJeYXQLNuq1Bzx2ZAguyePqNfJ1Fy5
         EcGdLBQS1zYVq7w6tV/QbVI77YkjE2yrv/I2z2hPMZ5A2Lwv0gy8GEAlI0OpYUcBFr19
         NrhwtGWT1tCUFnzq3zdhjXjC/4XVpav4IPpQ/MH+RPkMd3pJ1C5YpAejYOxS5G7vJOqo
         xUcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=rh9YWokngbonE7Snp74VlZyhTT2Pt7ct+I3KRd5dUQE=;
        b=excQj4/KVDASMN+r9OLVLKiW47O+Q/mUT1tFnDC66Z5vVTg1TnSgnJNhp1I6IcnFx4
         RaIe1tMNlOyqCjQnKeId8bPblVkJHRYydS5ufwZaApsOH7FtMYOfgdf27vFT2i7qiweb
         gsakrINDAXyWdMuk4Y8PKTI+1ayEUF9VmPaQMZzIEBpNMghhtfbetaOBC0reUcGcpUQq
         jAZr364MFDkfNHIyren2qR1cpG+QBjg9+vrlcfe1Tz4TizE1oDoixbpRRDBKK3PsMMFD
         CCDuwmjFuyeFqg5j6fOJxnFYf2633zeK1EGdFE34w3b+MXN5RMWpJ3atBrfn1IVH0K5P
         qbfQ==
X-Gm-Message-State: AJIora92uQ+6OwL49MJa2jPYJRkB3qNeZfM4Lv8dYtWk5yEqcROG2N37
        vXrVKgZRg6KapJ3QJzc9kYnVIofuiKXnhQ==
X-Google-Smtp-Source: AGRyM1uv74DHeaL90aLfCekYVnCS2WieF/E0TUifD06s4vTNabLjKJy/T6RgiMFbEmg+LucblMhhyA==
X-Received: by 2002:a17:90b:3507:b0:1f2:1b74:11d1 with SMTP id ls7-20020a17090b350700b001f21b7411d1mr6812127pjb.99.1658363313506;
        Wed, 20 Jul 2022 17:28:33 -0700 (PDT)
Received: from stbirv-lnx-2.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id m5-20020a170902db0500b0016bc4a6ce28sm163226plx.98.2022.07.20.17.28.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Jul 2022 17:28:33 -0700 (PDT)
From:   justinpopo6@gmail.com
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, joalonsof@gmail.com, jesionowskigreg@gmail.com,
        jackychou@asix.com.tw, jannh@google.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     f.fainelli@gmail.com, justin.chen@broadcom.com,
        Justin Chen <justinpopo6@gmail.com>
Subject: [PATCH v2 4/5] net: usb: ax88179_178a: move priv to driver_priv
Date:   Wed, 20 Jul 2022 17:28:15 -0700
Message-Id: <1658363296-15734-5-git-send-email-justinpopo6@gmail.com>
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

We need more space to save WoL context. So lets allocate memory
for ax88179_data instead of using struct usbnet data field which
only supports 5 words. We continue to use the struct usbnet data
field for multicast filters. However since we no longer have the
private data stored there, we can shift it to the beginning.

Signed-off-by: Justin Chen <justinpopo6@gmail.com>
---
 drivers/net/usb/ax88179_178a.c | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index 1cc388a..d0cd986 100644
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
@@ -1270,11 +1269,15 @@ static void ax88179_get_mac_addr(struct usbnet *dev)
 
 static int ax88179_bind(struct usbnet *dev, struct usb_interface *intf)
 {
-	struct ax88179_data *ax179_data = (struct ax88179_data *)dev->data;
+	struct ax88179_data *ax179_data;
 
 	usbnet_get_endpoints(dev, intf);
 
-	memset(ax179_data, 0, sizeof(*ax179_data));
+	ax179_data = kzalloc(sizeof(*ax179_data), GFP_KERNEL);
+	if (!ax179_data)
+		return -ENOMEM;
+
+	dev->driver_priv = ax179_data;
 
 	dev->net->netdev_ops = &ax88179_netdev_ops;
 	dev->net->ethtool_ops = &ax88179_ethtool_ops;
@@ -1304,6 +1307,7 @@ static int ax88179_bind(struct usbnet *dev, struct usb_interface *intf)
 
 static void ax88179_unbind(struct usbnet *dev, struct usb_interface *intf)
 {
+	struct ax88179_data *ax179_data = dev->driver_priv;
 	u16 tmp16;
 
 	/* Configure RX control register => stop operation */
@@ -1316,6 +1320,8 @@ static void ax88179_unbind(struct usbnet *dev, struct usb_interface *intf)
 	/* Power down ethernet PHY */
 	tmp16 = 0;
 	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_PHYPWR_RSTCTL, 2, 2, &tmp16);
+
+	kfree(ax179_data);
 }
 
 static void
@@ -1492,7 +1498,7 @@ ax88179_tx_fixup(struct usbnet *dev, struct sk_buff *skb, gfp_t flags)
 
 static int ax88179_link_reset(struct usbnet *dev)
 {
-	struct ax88179_data *ax179_data = (struct ax88179_data *)dev->data;
+	struct ax88179_data *ax179_data = dev->driver_priv;
 	u8 tmp[5], link_sts;
 	u16 mode, tmp16, delay = HZ / 10;
 	u32 tmp32 = 0x40000000;
@@ -1567,7 +1573,7 @@ static int ax88179_reset(struct usbnet *dev)
 	u8 buf[5];
 	u16 *tmp16;
 	u8 *tmp;
-	struct ax88179_data *ax179_data = (struct ax88179_data *)dev->data;
+	struct ax88179_data *ax179_data = dev->driver_priv;
 	struct ethtool_eee eee_data;
 
 	tmp16 = (u16 *)buf;
-- 
2.7.4

