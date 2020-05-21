Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1D71DD922
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 23:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730605AbgEUVK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 17:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730588AbgEUVK5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 17:10:57 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D5AC05BD43
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 14:10:57 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id s3so10572872eji.6
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 14:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eIKCBg6+dx920ZtMunbCi2uj3FNIMlWi2s3bJKgHEls=;
        b=JLn60lLaKl8EL3oMmZOY/B82gBHQxP6SJHir3WL1WkjsR7SWzCQJup+tbrWxWfTDsb
         V4AOm0NJZ0gaq4DHay34xQAw/HFCKan8qChka4MVFd7YJU15WdVXnACy362+dnVA3UU5
         E7MYU4XKpZljfiWI8gmn2Iosagf6M9moYxlZIjHzlkTfeqcVyp/oeafuxEEI0j6S+fXa
         K+4sTmwf3fRQREGjKR/EvdE5Z679lroUXhMd9GwZeETEqBDAt/+RWzOuSL+/wc1lO4Ei
         DiD7JUhfnzpwczIXtHukmM/yjYyVwbPxSwGyZH9xULyszUr8r47788dZykL6YLyDNJDR
         AIcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eIKCBg6+dx920ZtMunbCi2uj3FNIMlWi2s3bJKgHEls=;
        b=JUcs5JnicAQ2A1zIfEYlWZhYxdg0QoKJI4Yo0cB792CJLdnvwScBmTkesVXCpdcReT
         PnqkDIxcNOdQ1vRQy+mxccHnBK63BzaZDZMWpY/hj9DgejWJhZq2fdmhhsOqx/A7+vT5
         wBTZe6FK5dVQpiEXluGPvOqDpQ0i9/1xAHJB6IyIzpPItM+sDZqEC5qT2nMerNuEpLTb
         BWzr6LX3MljoE0dO8lcT8+0n1Wymz22ob39Xirffg0a9FkWs41JqRLBCaVQ8gZjATDg5
         FP1c9qG50bHxkqffFryCegLFj4e2YgZVpgqrtSStgcjwkQlvYP1L0V0/YN03tCuy41f1
         GW/Q==
X-Gm-Message-State: AOAM531r3KHL440xTzzoO3V9P/GkVkW3/J4SscBkwPBBDTSTH4K6FhwZ
        ObysATuFs/ipgoSdP6i4SCs=
X-Google-Smtp-Source: ABdhPJySfZv9RMkEUIL5740XSIcEDmec/LW9M8wfF2DIx7VuqQk3KgeoSGvPQgsBuM/VhRuUUeJSWg==
X-Received: by 2002:a17:906:55c3:: with SMTP id z3mr5214478ejp.180.1590095456058;
        Thu, 21 May 2020 14:10:56 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id h8sm5797637edk.72.2020.05.21.14.10.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2020 14:10:55 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        ivecera@redhat.com, netdev@vger.kernel.org,
        horatiu.vultur@microchip.com, allan.nielsen@microchip.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com
Subject: [PATCH RFC net-next 04/13] ethernet: eth: add default vid len for all ethernet kind devices
Date:   Fri, 22 May 2020 00:10:27 +0300
Message-Id: <20200521211036.668624-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200521211036.668624-1-olteanv@gmail.com>
References: <20200521211036.668624-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>

IVDF - individual virtual device filtering. Allows to set per vlan
L2 address filters on end real network device (for unicast and for
multicast) and drop redundant, unexpected packet ingress.

If CONFIG_VLAN_8021Q_IVDF is enabled the following changes are
applied, and only for ethernet network devices.

By default every ethernet netdev needs vid len = 2 bytes to be able to
hold up to 4096 vids. So set it for every eth device to be correct,
except vlan devs.

In order to shrink all addresses of devices above vlan, the vid_len
for vlan dev = 0, as result all suckers sync their addresses to common
base not taking into account vid part (vid_len of "to" devices is
important only). And only vlan device is the source of addresses with
actual its vid set, propagating it to parent devices while rx_mode().

Also, don't bother those ethernet devices that at this moment are not
moved to vlan addressing scheme, so while end ethernet device is
created - set vid_len to 0, thus, while syncing, its address space is
concatenated to one dimensional like usual, and who needs IVDF - set
it to NET_8021Q_VID_TSIZE.

There is another decision - is to inherit vid_len or some feature flag
from end root device in order to all upper devices have vlan extended
address space only if exact end real device have such capability. But
I didn't, because it requires more changes and probably I'm not
familiar with all places where it should be inherited, I would
appreciate if someone can guide where it's applicable, then it could
become a little bit more limited.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/linux/if_vlan.h |  1 +
 net/8021q/Kconfig       | 12 ++++++++++++
 net/8021q/vlan_core.c   | 12 ++++++++++++
 net/8021q/vlan_dev.c    |  1 +
 net/ethernet/eth.c      | 12 ++++++++++--
 5 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
index 20407f73cfee..b3f7e92cd645 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -132,6 +132,7 @@ extern int vlan_for_each(struct net_device *dev,
 			 int (*action)(struct net_device *dev, int vid,
 				       void *arg), void *arg);
 extern u16 vlan_dev_get_addr_vid(struct net_device *dev, const u8 *addr);
+extern void vlan_dev_ivdf_set(struct net_device *dev, bool enable);
 extern struct net_device *vlan_dev_real_dev(const struct net_device *dev);
 extern u16 vlan_dev_vlan_id(const struct net_device *dev);
 extern __be16 vlan_dev_vlan_proto(const struct net_device *dev);
diff --git a/net/8021q/Kconfig b/net/8021q/Kconfig
index 5510b4b90ff0..aaae09068ab8 100644
--- a/net/8021q/Kconfig
+++ b/net/8021q/Kconfig
@@ -39,3 +39,15 @@ config VLAN_8021Q_MVRP
 	  supersedes GVRP and is not backwards-compatible.
 
 	  If unsure, say N.
+
+config VLAN_8021Q_IVDF
+	bool "IVDF (Individual Virtual Device Filtering) support"
+	depends on VLAN_8021Q
+	help
+	  Select this to enable IVDF addressing scheme support. IVDF is used
+	  for automatic propagation of registered VLANs addresses to real end
+	  devices. If no device supporting IVDF then disable this as it can
+	  consume some memory in configuration with complex network device
+	  structures to hold vlan addresses.
+
+	  If unsure, say N.
diff --git a/net/8021q/vlan_core.c b/net/8021q/vlan_core.c
index b528f09be9a3..d21492f7f557 100644
--- a/net/8021q/vlan_core.c
+++ b/net/8021q/vlan_core.c
@@ -453,6 +453,18 @@ bool vlan_uses_dev(const struct net_device *dev)
 }
 EXPORT_SYMBOL(vlan_uses_dev);
 
+void vlan_dev_ivdf_set(struct net_device *dev, bool enable)
+{
+#ifdef CONFIG_VLAN_8021Q_IVDF
+	if (enable) {
+		dev->vid_len = NET_8021Q_VID_TSIZE;
+		return;
+	}
+#endif
+	dev->vid_len = 0;
+}
+EXPORT_SYMBOL(vlan_dev_ivdf_set);
+
 u16 vlan_dev_get_addr_vid(struct net_device *dev, const u8 *addr)
 {
 	u16 vid = 0;
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index f3f570a12ffd..22ce9f9f666d 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -894,5 +894,6 @@ void vlan_setup(struct net_device *dev)
 	dev->min_mtu		= 0;
 	dev->max_mtu		= ETH_MAX_MTU;
 
+	vlan_dev_ivdf_set(dev, true);
 	eth_zero_addr(dev->broadcast);
 }
diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
index c8b903302ff2..c40fae6df46b 100644
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -372,6 +372,7 @@ void ether_setup(struct net_device *dev)
 	dev->flags		= IFF_BROADCAST|IFF_MULTICAST;
 	dev->priv_flags		|= IFF_TX_SKB_SHARING;
 
+	vlan_dev_ivdf_set(dev, false);
 	eth_broadcast_addr(dev->broadcast);
 
 }
@@ -395,8 +396,15 @@ EXPORT_SYMBOL(ether_setup);
 struct net_device *alloc_etherdev_mqs(int sizeof_priv, unsigned int txqs,
 				      unsigned int rxqs)
 {
-	return alloc_netdev_mqs(sizeof_priv, "eth%d", NET_NAME_UNKNOWN,
-				ether_setup, txqs, rxqs);
+	struct net_device *dev;
+
+	dev = alloc_netdev_mqs(sizeof_priv, "eth%d", NET_NAME_UNKNOWN,
+			       ether_setup, txqs, rxqs);
+	if (!dev)
+		return NULL;
+
+	vlan_dev_ivdf_set(dev, false);
+	return dev;
 }
 EXPORT_SYMBOL(alloc_etherdev_mqs);
 
-- 
2.25.1

