Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B34C63AF8D2
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 00:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232455AbhFUWxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 18:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232329AbhFUWxc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 18:53:32 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 467BDC061574
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 15:51:16 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id r16so27433049ljk.9
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 15:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=j2uv2MA4sc1scw7PiZnyqf1yD2PG2cpAR2JMuYS/dOI=;
        b=d892peFcWnuTnxYxegl1HpkwweO2pTtmBg3OACFYSCm5DWpDJN/ba4JlRxxaPPdjCR
         AladjOLJqs9uZvXN61+PrCk9mB6G5OHw2Sr1QEGh9stitvOsNhcipKm1DFPC8+BZGjPY
         y73lr72vmOU2GHIUNUVhw8RFs19Nppkh1JAzPtjJIv/YMfLNZ8Ut5qSkg5nC9IWR6tpF
         ZBCABzrjJZkQzmYZFzzUusXkua838SLKT1yupiCULepTJpdJxwVS/pqvrUNk3dngRFH2
         Sk3T1FXpHqVO5LtLww3Dr7xYHtrOT5rOLoYlpgMP59awGOugaoM3LjcgcDwJXQBrTP28
         ac2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j2uv2MA4sc1scw7PiZnyqf1yD2PG2cpAR2JMuYS/dOI=;
        b=ptboL5pAlv8/l/dYBJjmA7oU1bDg7UE0i0kQtXF1EHEHUd9BA4cLM96Yrzpwfq12sX
         9QK7j000layzObcBA9E3rNmIQvgxfMaU0QqnbDSqDnQXxg4ea991DC5cVAobg9QtN2w/
         +18vmRcJKWWlfR2XRqQ0RXbmQ3JGyo549ikaLL3hIHuCrvxmpVNOw2o+/O+rcdR6Jq5n
         KifxtQ6OTevc0ie1if0oLw6+aKAeyXOKrhRA9jNcPQzOYtsGyENuYZlq+6WsyMLlIiQV
         eZJf7VaolZAGnKfCsXSrtQNLgahvw+mFhbRilQQeL/XpOsyFRIs8rvPbq3OEIwyw3Oxc
         e8zg==
X-Gm-Message-State: AOAM533Z/z20ObXSRdhi56pU3onGjB3pFcohjiLfvo+GFlZbBAfSfp17
        S42MN0DttoNQM3i/UyNzKRw=
X-Google-Smtp-Source: ABdhPJwu0XqiCGvaCS7IkjxDrRR33Hy1tOAMayIG49+tO6CikHQ3By+KBzQDM1vEt+UcWJEeeuLT3g==
X-Received: by 2002:a2e:9e53:: with SMTP id g19mr469252ljk.58.1624315874654;
        Mon, 21 Jun 2021 15:51:14 -0700 (PDT)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id x207sm124826lff.53.2021.06.21.15.51.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 15:51:14 -0700 (PDT)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>
Subject: [PATCH net-next v2 10/10] wwan: core: add WWAN common private data for netdev
Date:   Tue, 22 Jun 2021 01:51:00 +0300
Message-Id: <20210621225100.21005-11-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210621225100.21005-1-ryazanov.s.a@gmail.com>
References: <20210621225100.21005-1-ryazanov.s.a@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The WWAN core not only multiplex the netdev configuration data, but
process it too, and needs some space to store its private data
associated with the netdev. Add a structure to keep common WWAN core
data. The structure will be stored inside the netdev private data before
WWAN driver private data and have a field to make it easier to access
the driver data. Also add a helper function that simplifies drivers
access to their data.

At the moment we use the common WWAN private data to store the WWAN data
link (channel) id at the time the link is created, and report it back to
user using the .fill_info() RTNL callback. This should help the user to
be aware which network interface is bound to which WWAN device data
channel.

Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
CC: M Chetan Kumar <m.chetan.kumar@intel.com>
CC: Intel Corporation <linuxwwan@intel.com>
---

v1 -> v2:
 * fix grammar in description

 drivers/net/mhi/net.c                 | 12 +++++------
 drivers/net/mhi/proto_mbim.c          |  5 +++--
 drivers/net/wwan/iosm/iosm_ipc_wwan.c | 12 +++++------
 drivers/net/wwan/wwan_core.c          | 29 ++++++++++++++++++++++++++-
 include/linux/wwan.h                  | 18 +++++++++++++++++
 5 files changed, 61 insertions(+), 15 deletions(-)

diff --git a/drivers/net/mhi/net.c b/drivers/net/mhi/net.c
index f36ca5c0dfe9..e60e38c1f09d 100644
--- a/drivers/net/mhi/net.c
+++ b/drivers/net/mhi/net.c
@@ -32,7 +32,7 @@ struct mhi_device_info {
 
 static int mhi_ndo_open(struct net_device *ndev)
 {
-	struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
+	struct mhi_net_dev *mhi_netdev = wwan_netdev_drvpriv(ndev);
 
 	/* Feed the rx buffer pool */
 	schedule_delayed_work(&mhi_netdev->rx_refill, 0);
@@ -47,7 +47,7 @@ static int mhi_ndo_open(struct net_device *ndev)
 
 static int mhi_ndo_stop(struct net_device *ndev)
 {
-	struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
+	struct mhi_net_dev *mhi_netdev = wwan_netdev_drvpriv(ndev);
 
 	netif_stop_queue(ndev);
 	netif_carrier_off(ndev);
@@ -58,7 +58,7 @@ static int mhi_ndo_stop(struct net_device *ndev)
 
 static netdev_tx_t mhi_ndo_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
-	struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
+	struct mhi_net_dev *mhi_netdev = wwan_netdev_drvpriv(ndev);
 	const struct mhi_net_proto *proto = mhi_netdev->proto;
 	struct mhi_device *mdev = mhi_netdev->mdev;
 	int err;
@@ -93,7 +93,7 @@ static netdev_tx_t mhi_ndo_xmit(struct sk_buff *skb, struct net_device *ndev)
 static void mhi_ndo_get_stats64(struct net_device *ndev,
 				struct rtnl_link_stats64 *stats)
 {
-	struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
+	struct mhi_net_dev *mhi_netdev = wwan_netdev_drvpriv(ndev);
 	unsigned int start;
 
 	do {
@@ -322,7 +322,7 @@ static int mhi_net_newlink(void *ctxt, struct net_device *ndev, u32 if_id,
 	if (dev_get_drvdata(&mhi_dev->dev))
 		return -EBUSY;
 
-	mhi_netdev = netdev_priv(ndev);
+	mhi_netdev = wwan_netdev_drvpriv(ndev);
 
 	dev_set_drvdata(&mhi_dev->dev, mhi_netdev);
 	mhi_netdev->ndev = ndev;
@@ -367,7 +367,7 @@ static int mhi_net_newlink(void *ctxt, struct net_device *ndev, u32 if_id,
 static void mhi_net_dellink(void *ctxt, struct net_device *ndev,
 			    struct list_head *head)
 {
-	struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
+	struct mhi_net_dev *mhi_netdev = wwan_netdev_drvpriv(ndev);
 	struct mhi_device *mhi_dev = ctxt;
 
 	if (head)
diff --git a/drivers/net/mhi/proto_mbim.c b/drivers/net/mhi/proto_mbim.c
index fc72b3f6ec9e..bf1ad863237d 100644
--- a/drivers/net/mhi/proto_mbim.c
+++ b/drivers/net/mhi/proto_mbim.c
@@ -16,6 +16,7 @@
 #include <linux/ip.h>
 #include <linux/mii.h>
 #include <linux/netdevice.h>
+#include <linux/wwan.h>
 #include <linux/skbuff.h>
 #include <linux/usb.h>
 #include <linux/usb/cdc.h>
@@ -56,7 +57,7 @@ static void __mbim_errors_inc(struct mhi_net_dev *dev)
 
 static int mbim_rx_verify_nth16(struct sk_buff *skb)
 {
-	struct mhi_net_dev *dev = netdev_priv(skb->dev);
+	struct mhi_net_dev *dev = wwan_netdev_drvpriv(skb->dev);
 	struct mbim_context *ctx = dev->proto_data;
 	struct usb_cdc_ncm_nth16 *nth16;
 	int len;
@@ -102,7 +103,7 @@ static int mbim_rx_verify_nth16(struct sk_buff *skb)
 
 static int mbim_rx_verify_ndp16(struct sk_buff *skb, struct usb_cdc_ncm_ndp16 *ndp16)
 {
-	struct mhi_net_dev *dev = netdev_priv(skb->dev);
+	struct mhi_net_dev *dev = wwan_netdev_drvpriv(skb->dev);
 	int ret;
 
 	if (le16_to_cpu(ndp16->wLength) < USB_CDC_NCM_NDP16_LENGTH_MIN) {
diff --git a/drivers/net/wwan/iosm/iosm_ipc_wwan.c b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
index d3cb28107836..c999c64001f4 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_wwan.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
@@ -20,7 +20,7 @@
 #define IOSM_IF_ID_PAYLOAD 2
 
 /**
- * struct iosm_netdev_priv - netdev private data
+ * struct iosm_netdev_priv - netdev WWAN driver specific private data
  * @ipc_wwan:	Pointer to iosm_wwan struct
  * @netdev:	Pointer to network interface device structure
  * @if_id:	Interface id for device.
@@ -51,7 +51,7 @@ struct iosm_wwan {
 /* Bring-up the wwan net link */
 static int ipc_wwan_link_open(struct net_device *netdev)
 {
-	struct iosm_netdev_priv *priv = netdev_priv(netdev);
+	struct iosm_netdev_priv *priv = wwan_netdev_drvpriv(netdev);
 	struct iosm_wwan *ipc_wwan = priv->ipc_wwan;
 	int if_id = priv->if_id;
 	int ret;
@@ -88,7 +88,7 @@ static int ipc_wwan_link_open(struct net_device *netdev)
 /* Bring-down the wwan net link */
 static int ipc_wwan_link_stop(struct net_device *netdev)
 {
-	struct iosm_netdev_priv *priv = netdev_priv(netdev);
+	struct iosm_netdev_priv *priv = wwan_netdev_drvpriv(netdev);
 
 	netif_stop_queue(netdev);
 
@@ -105,7 +105,7 @@ static int ipc_wwan_link_stop(struct net_device *netdev)
 static int ipc_wwan_link_transmit(struct sk_buff *skb,
 				  struct net_device *netdev)
 {
-	struct iosm_netdev_priv *priv = netdev_priv(netdev);
+	struct iosm_netdev_priv *priv = wwan_netdev_drvpriv(netdev);
 	struct iosm_wwan *ipc_wwan = priv->ipc_wwan;
 	int if_id = priv->if_id;
 	int ret;
@@ -178,7 +178,7 @@ static int ipc_wwan_newlink(void *ctxt, struct net_device *dev,
 	    if_id >= ARRAY_SIZE(ipc_wwan->sub_netlist))
 		return -EINVAL;
 
-	priv = netdev_priv(dev);
+	priv = wwan_netdev_drvpriv(dev);
 	priv->if_id = if_id;
 	priv->netdev = dev;
 	priv->ipc_wwan = ipc_wwan;
@@ -208,8 +208,8 @@ static int ipc_wwan_newlink(void *ctxt, struct net_device *dev,
 static void ipc_wwan_dellink(void *ctxt, struct net_device *dev,
 			     struct list_head *head)
 {
+	struct iosm_netdev_priv *priv = wwan_netdev_drvpriv(dev);
 	struct iosm_wwan *ipc_wwan = ctxt;
-	struct iosm_netdev_priv *priv = netdev_priv(dev);
 	int if_id = priv->if_id;
 
 	if (WARN_ON(if_id < IP_MUX_SESSION_START ||
diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
index ef6ec641d877..3e16c318e705 100644
--- a/drivers/net/wwan/wwan_core.c
+++ b/drivers/net/wwan/wwan_core.c
@@ -815,6 +815,7 @@ static struct net_device *wwan_rtnl_alloc(struct nlattr *tb[],
 	const char *devname = nla_data(tb[IFLA_PARENT_DEV_NAME]);
 	struct wwan_device *wwandev = wwan_dev_get_by_name(devname);
 	struct net_device *dev;
+	unsigned int priv_size;
 
 	if (IS_ERR(wwandev))
 		return ERR_CAST(wwandev);
@@ -825,7 +826,8 @@ static struct net_device *wwan_rtnl_alloc(struct nlattr *tb[],
 		goto out;
 	}
 
-	dev = alloc_netdev_mqs(wwandev->ops->priv_size, ifname, name_assign_type,
+	priv_size = sizeof(struct wwan_netdev_priv) + wwandev->ops->priv_size;
+	dev = alloc_netdev_mqs(priv_size, ifname, name_assign_type,
 			       wwandev->ops->setup, num_tx_queues, num_rx_queues);
 
 	if (dev) {
@@ -845,6 +847,7 @@ static int wwan_rtnl_newlink(struct net *src_net, struct net_device *dev,
 {
 	struct wwan_device *wwandev = wwan_dev_get_by_parent(dev->dev.parent);
 	u32 link_id = nla_get_u32(data[IFLA_WWAN_LINK_ID]);
+	struct wwan_netdev_priv *priv = netdev_priv(dev);
 	int ret;
 
 	if (IS_ERR(wwandev))
@@ -856,6 +859,7 @@ static int wwan_rtnl_newlink(struct net *src_net, struct net_device *dev,
 		goto out;
 	}
 
+	priv->link_id = link_id;
 	if (wwandev->ops->newlink)
 		ret = wwandev->ops->newlink(wwandev->ops_ctxt, dev,
 					    link_id, extack);
@@ -889,6 +893,27 @@ static void wwan_rtnl_dellink(struct net_device *dev, struct list_head *head)
 	put_device(&wwandev->dev);
 }
 
+static size_t wwan_rtnl_get_size(const struct net_device *dev)
+{
+	return
+		nla_total_size(4) +	/* IFLA_WWAN_LINK_ID */
+		0;
+}
+
+static int wwan_rtnl_fill_info(struct sk_buff *skb,
+			       const struct net_device *dev)
+{
+	struct wwan_netdev_priv *priv = netdev_priv(dev);
+
+	if (nla_put_u32(skb, IFLA_WWAN_LINK_ID, priv->link_id))
+		goto nla_put_failure;
+
+	return 0;
+
+nla_put_failure:
+	return -EMSGSIZE;
+}
+
 static const struct nla_policy wwan_rtnl_policy[IFLA_WWAN_MAX + 1] = {
 	[IFLA_WWAN_LINK_ID] = { .type = NLA_U32 },
 };
@@ -900,6 +925,8 @@ static struct rtnl_link_ops wwan_rtnl_link_ops __read_mostly = {
 	.validate = wwan_rtnl_validate,
 	.newlink = wwan_rtnl_newlink,
 	.dellink = wwan_rtnl_dellink,
+	.get_size = wwan_rtnl_get_size,
+	.fill_info = wwan_rtnl_fill_info,
 	.policy = wwan_rtnl_policy,
 };
 
diff --git a/include/linux/wwan.h b/include/linux/wwan.h
index 91590db70a12..9fac819f92e3 100644
--- a/include/linux/wwan.h
+++ b/include/linux/wwan.h
@@ -9,6 +9,7 @@
 #include <linux/poll.h>
 #include <linux/skbuff.h>
 #include <linux/netlink.h>
+#include <linux/netdevice.h>
 
 /**
  * enum wwan_port_type - WWAN port types
@@ -126,6 +127,23 @@ void wwan_port_txon(struct wwan_port *port);
  */
 void *wwan_port_get_drvdata(struct wwan_port *port);
 
+/**
+ * struct wwan_netdev_priv - WWAN core network device private data
+ * @link_id: WWAN device data link id
+ * @drv_priv: driver private data area, size is determined in &wwan_ops
+ */
+struct wwan_netdev_priv {
+	u32 link_id;
+
+	/* must be last */
+	u8 drv_priv[] __aligned(sizeof(void *));
+};
+
+static inline void *wwan_netdev_drvpriv(struct net_device *dev)
+{
+	return ((struct wwan_netdev_priv *)netdev_priv(dev))->drv_priv;
+}
+
 /*
  * Used to indicate that the WWAN core should not create a default network
  * link.
-- 
2.26.3

