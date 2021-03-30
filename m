Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94E2534DE22
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 04:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbhC3CSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 22:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230418AbhC3CR4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 22:17:56 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D29C061762
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 19:17:55 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id v70so14525788qkb.8
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 19:17:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V+WEIPsEAGA7jwvYy6qQleq6biy6Etghzkh4svXjlzI=;
        b=mxbrMN0KUGYxWEwnuqf7m43QXjYnDDjx9RHSHF366hBPMip6E2rMj1d4OP0kNepxXn
         je5w2E1GzeyNfBx4tySOGJdflPL9gj3yAf1rP+o0EHeyXkBZmDuBq1x1k98OYwDujMQn
         NC5ROKgjnz6+w6qg45L6kIbnvgFzWjwTzggOA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V+WEIPsEAGA7jwvYy6qQleq6biy6Etghzkh4svXjlzI=;
        b=gTdbmhMzNINRFRfFbTjKYZ/leO3ySRSMUO3jGjDWvhbtiz1APEHiRd1l3dCrbwUsK8
         GBzD/TgT+mFIxrt291TT+lJx0v20anZMNZ5Gj+dcdAj7yTtqWq4ddO7cm9SxYgqHfKtA
         H28wDDglXwg0YzGPOAmkMCcclv0AsfTjLblyP+4nLnAyuO65XKgqaaw3EMIuhs6ZP8Jk
         88TN08a1a/9AbXWfoXH+TC1RPy5bZP3fAOSt8mtqrnrHzR3TAGklwZwXVwOex5IsG7o7
         OKpnG3jx2sZtwWkw+8E0KUVLgGlgjthuPlauZ2rtzXNuatydjziU5p3m+4c/CRzVLZfr
         88nQ==
X-Gm-Message-State: AOAM532BXo3CWdF0ueHsNj7qvsY0ALwNrS1QjaO7uD2gb0Q+e2yhfJcj
        HZ+y4SnhFMuYV+f3cKtGfC/eCw==
X-Google-Smtp-Source: ABdhPJxRnUy9QDa1LT3bSLnnKFUd9Yg1R6EZAXA80fzqjMLlJqaGUmYG1m94hIjc1YAgtkSt6r72BQ==
X-Received: by 2002:a05:620a:15eb:: with SMTP id p11mr27697293qkm.454.1617070675110;
        Mon, 29 Mar 2021 19:17:55 -0700 (PDT)
Received: from grundler-glapstation.lan ([70.134.62.80])
        by smtp.gmail.com with ESMTPSA id j30sm12433067qtv.90.2021.03.29.19.17.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 19:17:54 -0700 (PDT)
From:   Grant Grundler <grundler@chromium.org>
To:     Oliver Neukum <oneukum@suse.com>, Jakub Kicinski <kuba@kernel.org>
Cc:     Roland Dreier <roland@kernel.org>, nic_swsd <nic_swsd@realtek.com>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Grant Grundler <grundler@chromium.org>
Subject: [PATCHv4 1/4] usbnet: add _mii suffix to usbnet_set/get_link_ksettings
Date:   Mon, 29 Mar 2021 19:16:48 -0700
Message-Id: <20210330021651.30906-2-grundler@chromium.org>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
In-Reply-To: <20210330021651.30906-1-grundler@chromium.org>
References: <20210330021651.30906-1-grundler@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

The generic functions assumed devices provided an MDIO interface (accessed
via older mii code, not phylib). This is true only for genuine ethernet.

Devices with a higher level of abstraction or based on different
technologies do not have MDIO. To support this case, first rename
the existing functions with _mii suffix.

v2: rebased on changed upstream
v3: changed names to clearly say that this does NOT use phylib
v4: moved hunks to correct patch; reworded commmit messages

Signed-off-by : Oliver Neukum <oneukum@suse.com>
Tested-by: Roland Dreier <roland@kernel.org>
Reviewed-by: Grant Grundler <grundler@chromium.org>
Tested-by: Grant Grundler <grundler@chromium.org>
---
 drivers/net/usb/asix_devices.c | 12 ++++++------
 drivers/net/usb/cdc_ncm.c      |  4 ++--
 drivers/net/usb/dm9601.c       |  4 ++--
 drivers/net/usb/mcs7830.c      |  4 ++--
 drivers/net/usb/sierra_net.c   |  4 ++--
 drivers/net/usb/smsc75xx.c     |  4 ++--
 drivers/net/usb/sr9700.c       |  4 ++--
 drivers/net/usb/sr9800.c       |  4 ++--
 drivers/net/usb/usbnet.c       | 15 +++++++++------
 include/linux/usb/usbnet.h     |  4 ++--
 10 files changed, 31 insertions(+), 28 deletions(-)

I'm reposting this with corrections to "misplaced" patch hunks
that I pointed out on Feb 19.  Code otherwise should be the same
and Oliver Neukum should be listed as author in git.

diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index 6e13d8165852..19a8fafb8f04 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -125,8 +125,8 @@ static const struct ethtool_ops ax88172_ethtool_ops = {
 	.get_eeprom		= asix_get_eeprom,
 	.set_eeprom		= asix_set_eeprom,
 	.nway_reset		= usbnet_nway_reset,
-	.get_link_ksettings	= usbnet_get_link_ksettings,
-	.set_link_ksettings	= usbnet_set_link_ksettings,
+	.get_link_ksettings	= usbnet_get_link_ksettings_mii,
+	.set_link_ksettings	= usbnet_set_link_ksettings_mii,
 };
 
 static void ax88172_set_multicast(struct net_device *net)
@@ -291,8 +291,8 @@ static const struct ethtool_ops ax88772_ethtool_ops = {
 	.get_eeprom		= asix_get_eeprom,
 	.set_eeprom		= asix_set_eeprom,
 	.nway_reset		= usbnet_nway_reset,
-	.get_link_ksettings	= usbnet_get_link_ksettings,
-	.set_link_ksettings	= usbnet_set_link_ksettings,
+	.get_link_ksettings	= usbnet_get_link_ksettings_mii,
+	.set_link_ksettings	= usbnet_set_link_ksettings_mii,
 };
 
 static int ax88772_link_reset(struct usbnet *dev)
@@ -782,8 +782,8 @@ static const struct ethtool_ops ax88178_ethtool_ops = {
 	.get_eeprom		= asix_get_eeprom,
 	.set_eeprom		= asix_set_eeprom,
 	.nway_reset		= usbnet_nway_reset,
-	.get_link_ksettings	= usbnet_get_link_ksettings,
-	.set_link_ksettings	= usbnet_set_link_ksettings,
+	.get_link_ksettings	= usbnet_get_link_ksettings_mii,
+	.set_link_ksettings	= usbnet_set_link_ksettings_mii,
 };
 
 static int marvell_phy_init(struct usbnet *dev)
diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index 8acf30115428..2644234d4c4d 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -142,8 +142,8 @@ static const struct ethtool_ops cdc_ncm_ethtool_ops = {
 	.get_sset_count    = cdc_ncm_get_sset_count,
 	.get_strings       = cdc_ncm_get_strings,
 	.get_ethtool_stats = cdc_ncm_get_ethtool_stats,
-	.get_link_ksettings      = usbnet_get_link_ksettings,
-	.set_link_ksettings      = usbnet_set_link_ksettings,
+	.get_link_ksettings      = usbnet_get_link_ksettings_mii,
+	.set_link_ksettings      = usbnet_set_link_ksettings_mii,
 };
 
 static u32 cdc_ncm_check_rx_max(struct usbnet *dev, u32 new_rx)
diff --git a/drivers/net/usb/dm9601.c b/drivers/net/usb/dm9601.c
index b5d2ac55a874..89cc61d7a675 100644
--- a/drivers/net/usb/dm9601.c
+++ b/drivers/net/usb/dm9601.c
@@ -282,8 +282,8 @@ static const struct ethtool_ops dm9601_ethtool_ops = {
 	.get_eeprom_len	= dm9601_get_eeprom_len,
 	.get_eeprom	= dm9601_get_eeprom,
 	.nway_reset	= usbnet_nway_reset,
-	.get_link_ksettings	= usbnet_get_link_ksettings,
-	.set_link_ksettings	= usbnet_set_link_ksettings,
+	.get_link_ksettings	= usbnet_get_link_ksettings_mii,
+	.set_link_ksettings	= usbnet_set_link_ksettings_mii,
 };
 
 static void dm9601_set_multicast(struct net_device *net)
diff --git a/drivers/net/usb/mcs7830.c b/drivers/net/usb/mcs7830.c
index fc512b780d15..9f9352a4522f 100644
--- a/drivers/net/usb/mcs7830.c
+++ b/drivers/net/usb/mcs7830.c
@@ -452,8 +452,8 @@ static const struct ethtool_ops mcs7830_ethtool_ops = {
 	.get_msglevel		= usbnet_get_msglevel,
 	.set_msglevel		= usbnet_set_msglevel,
 	.nway_reset		= usbnet_nway_reset,
-	.get_link_ksettings	= usbnet_get_link_ksettings,
-	.set_link_ksettings	= usbnet_set_link_ksettings,
+	.get_link_ksettings	= usbnet_get_link_ksettings_mii,
+	.set_link_ksettings	= usbnet_set_link_ksettings_mii,
 };
 
 static const struct net_device_ops mcs7830_netdev_ops = {
diff --git a/drivers/net/usb/sierra_net.c b/drivers/net/usb/sierra_net.c
index 55a244eca5ca..55025202dc4f 100644
--- a/drivers/net/usb/sierra_net.c
+++ b/drivers/net/usb/sierra_net.c
@@ -629,8 +629,8 @@ static const struct ethtool_ops sierra_net_ethtool_ops = {
 	.get_msglevel = usbnet_get_msglevel,
 	.set_msglevel = usbnet_set_msglevel,
 	.nway_reset = usbnet_nway_reset,
-	.get_link_ksettings = usbnet_get_link_ksettings,
-	.set_link_ksettings = usbnet_set_link_ksettings,
+	.get_link_ksettings = usbnet_get_link_ksettings_mii,
+	.set_link_ksettings = usbnet_set_link_ksettings_mii,
 };
 
 static int sierra_net_get_fw_attr(struct usbnet *dev, u16 *datap)
diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
index 4353b370249f..f8cdabb9ef5a 100644
--- a/drivers/net/usb/smsc75xx.c
+++ b/drivers/net/usb/smsc75xx.c
@@ -741,8 +741,8 @@ static const struct ethtool_ops smsc75xx_ethtool_ops = {
 	.set_eeprom	= smsc75xx_ethtool_set_eeprom,
 	.get_wol	= smsc75xx_ethtool_get_wol,
 	.set_wol	= smsc75xx_ethtool_set_wol,
-	.get_link_ksettings	= usbnet_get_link_ksettings,
-	.set_link_ksettings	= usbnet_set_link_ksettings,
+	.get_link_ksettings	= usbnet_get_link_ksettings_mii,
+	.set_link_ksettings	= usbnet_set_link_ksettings_mii,
 };
 
 static int smsc75xx_ioctl(struct net_device *netdev, struct ifreq *rq, int cmd)
diff --git a/drivers/net/usb/sr9700.c b/drivers/net/usb/sr9700.c
index 878557ad03ad..ce29261263cd 100644
--- a/drivers/net/usb/sr9700.c
+++ b/drivers/net/usb/sr9700.c
@@ -250,8 +250,8 @@ static const struct ethtool_ops sr9700_ethtool_ops = {
 	.get_eeprom_len	= sr9700_get_eeprom_len,
 	.get_eeprom	= sr9700_get_eeprom,
 	.nway_reset	= usbnet_nway_reset,
-	.get_link_ksettings	= usbnet_get_link_ksettings,
-	.set_link_ksettings	= usbnet_set_link_ksettings,
+	.get_link_ksettings	= usbnet_get_link_ksettings_mii,
+	.set_link_ksettings	= usbnet_set_link_ksettings_mii,
 };
 
 static void sr9700_set_multicast(struct net_device *netdev)
diff --git a/drivers/net/usb/sr9800.c b/drivers/net/usb/sr9800.c
index da56735d7755..a822d81310d5 100644
--- a/drivers/net/usb/sr9800.c
+++ b/drivers/net/usb/sr9800.c
@@ -527,8 +527,8 @@ static const struct ethtool_ops sr9800_ethtool_ops = {
 	.get_eeprom_len	= sr_get_eeprom_len,
 	.get_eeprom	= sr_get_eeprom,
 	.nway_reset	= usbnet_nway_reset,
-	.get_link_ksettings	= usbnet_get_link_ksettings,
-	.set_link_ksettings	= usbnet_set_link_ksettings,
+	.get_link_ksettings	= usbnet_get_link_ksettings_mii,
+	.set_link_ksettings	= usbnet_set_link_ksettings_mii,
 };
 
 static int sr9800_link_reset(struct usbnet *dev)
diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index f4f37ecfed58..5b4629c80b4b 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -944,7 +944,10 @@ EXPORT_SYMBOL_GPL(usbnet_open);
  * they'll probably want to use this base set.
  */
 
-int usbnet_get_link_ksettings(struct net_device *net,
+/* These methods are written on the assumption that the device
+ * uses MII
+ */
+int usbnet_get_link_ksettings_mii(struct net_device *net,
 			      struct ethtool_link_ksettings *cmd)
 {
 	struct usbnet *dev = netdev_priv(net);
@@ -956,9 +959,9 @@ int usbnet_get_link_ksettings(struct net_device *net,
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(usbnet_get_link_ksettings);
+EXPORT_SYMBOL_GPL(usbnet_get_link_ksettings_mii);
 
-int usbnet_set_link_ksettings(struct net_device *net,
+int usbnet_set_link_ksettings_mii(struct net_device *net,
 			      const struct ethtool_link_ksettings *cmd)
 {
 	struct usbnet *dev = netdev_priv(net);
@@ -978,7 +981,7 @@ int usbnet_set_link_ksettings(struct net_device *net,
 
 	return retval;
 }
-EXPORT_SYMBOL_GPL(usbnet_set_link_ksettings);
+EXPORT_SYMBOL_GPL(usbnet_set_link_ksettings_mii);
 
 u32 usbnet_get_link (struct net_device *net)
 {
@@ -1043,8 +1046,8 @@ static const struct ethtool_ops usbnet_ethtool_ops = {
 	.get_msglevel		= usbnet_get_msglevel,
 	.set_msglevel		= usbnet_set_msglevel,
 	.get_ts_info		= ethtool_op_get_ts_info,
-	.get_link_ksettings	= usbnet_get_link_ksettings,
-	.set_link_ksettings	= usbnet_set_link_ksettings,
+	.get_link_ksettings	= usbnet_get_link_ksettings_mii,
+	.set_link_ksettings	= usbnet_set_link_ksettings_mii,
 };
 
 /*-------------------------------------------------------------------------*/
diff --git a/include/linux/usb/usbnet.h b/include/linux/usb/usbnet.h
index cfbfd6fe01df..a89e1452107d 100644
--- a/include/linux/usb/usbnet.h
+++ b/include/linux/usb/usbnet.h
@@ -267,9 +267,9 @@ extern void usbnet_pause_rx(struct usbnet *);
 extern void usbnet_resume_rx(struct usbnet *);
 extern void usbnet_purge_paused_rxq(struct usbnet *);
 
-extern int usbnet_get_link_ksettings(struct net_device *net,
+extern int usbnet_get_link_ksettings_mii(struct net_device *net,
 				     struct ethtool_link_ksettings *cmd);
-extern int usbnet_set_link_ksettings(struct net_device *net,
+extern int usbnet_set_link_ksettings_mii(struct net_device *net,
 				     const struct ethtool_link_ksettings *cmd);
 extern u32 usbnet_get_link(struct net_device *net);
 extern u32 usbnet_get_msglevel(struct net_device *);
-- 
2.30.1

