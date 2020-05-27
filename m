Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDD741E506F
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 23:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728621AbgE0VZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 17:25:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbgE0VZt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 17:25:49 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBFDCC05BD1E
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 14:25:48 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id m7so10668984plt.5
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 14:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gUSZT4fCNdZtufE1Q8hPMwDBbNtgClmr/6n+Cb71Sx0=;
        b=PuT49a2+E4jeGf/qW1w3m22Dg0J6pRvqIqbyupLk2cPZ3B/zF7k4i8RRJOg7aN1FoY
         hmciePuE1UV5TfnQhqp8eQdObhkNUJqO5hfzyFv0vw87J2zBrHWmD6UYLn4/r2IHjaX4
         pS8rVAikRqVZSLLgJwWOcKWHPQCfC0IINLXwM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gUSZT4fCNdZtufE1Q8hPMwDBbNtgClmr/6n+Cb71Sx0=;
        b=QYSujNX1tpryqeB4ZGBxFtlixyzEDcgmc6Jk1VNmercx8gQnSq5aCQ+CifzRJhBcuc
         WJaTGCLZmuuWrzpSwVk3Dg2qrjxAwlzdpVys8YwNHWhssRg7GwA4gJY1/FDZaSJplpv4
         rsri7PJm+4ylIxB6NUrHwsxRybcFtLDnnF8z4y1F7UyWQJ+n+kSL3dDfaCnaScvg9q68
         G1A8WHZ0NCcf9uF9cJeWurf6RfRuV/nXBGIkeQA/vPK+urRIcyAk227GGVxVGJhqrMQu
         XZWZ4lGN+jcMKWQCiKSjaa1uht5sbTQeLbH7pt43jtZYj/c5FDU5pGu74wkkVs7PdDKg
         BbsA==
X-Gm-Message-State: AOAM531TQRpro3VncDmXkbVbRX5m++jhBnbJ1JnQ6Go3cn5rLsYZvi8u
        qW+/EJ5+arJV/XsuZ/oGAGMUvdfJ1C/XqFXpiIIbqY4e8cEnreuNi0HbH+fQX+ydAHwUswFmnVV
        +q6BEf8dg+OQwBompvYpzbq9I9/RFIqa10IriXu695KWy2/RhPyZFRsxmRNQmC9iI1xzMMNWc
X-Google-Smtp-Source: ABdhPJyM2uh3TdlYU3y9SoREO3jUtEkMmYmbSnwirJDW/TvuI9S/lUoLkyaUDhL5aOeMeMw0/UqasA==
X-Received: by 2002:a17:90b:ecf:: with SMTP id gz15mr361019pjb.122.1590614747871;
        Wed, 27 May 2020 14:25:47 -0700 (PDT)
Received: from localhost.localdomain ([2600:8802:202:f600::ddf])
        by smtp.gmail.com with ESMTPSA id c4sm2770344pfb.130.2020.05.27.14.25.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 14:25:47 -0700 (PDT)
From:   Edwin Peer <edwin.peer@broadcom.com>
To:     netdev@vger.kernel.org
Cc:     Edwin Peer <edwin.peer@broadcom.com>, edumazet@google.com,
        linville@tuxdriver.com, shemminger@vyatta.com,
        mirq-linux@rere.qmqm.pl, jesse.brandeburg@intel.com,
        jchapman@katalix.com, david@weave.works, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, sridhar.samudrala@intel.com,
        jiri@mellanox.com, geoff@infradead.org, mokuno@sm.sony.co.jp,
        msink@permonline.ru, mporter@kernel.crashing.org,
        inaky.perez-gonzalez@intel.com, jwi@linux.ibm.com,
        kgraul@linux.ibm.com, ubraun@linux.ibm.com,
        grant.likely@secretlab.ca, hadi@cyberus.ca, dsahern@kernel.org,
        shrijeet@gmail.com, jon.mason@intel.com, dave.jiang@intel.com,
        saeedm@mellanox.com, hadarh@mellanox.com, ogerlitz@mellanox.com,
        allenbh@gmail.com, michael.chan@broadcom.com
Subject: [RFC PATCH net-next 03/11] net: vlan: add IFF_NO_VLAN_ROOM to constrain MTU
Date:   Wed, 27 May 2020 14:25:04 -0700
Message-Id: <20200527212512.17901-4-edwin.peer@broadcom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200527212512.17901-1-edwin.peer@broadcom.com>
References: <20200527212512.17901-1-edwin.peer@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Normally MTU does not account for an outer VLAN tag, since MTU is an
L3 constraint. Some Ethernet devices, however, have a size constrained
L2 that cannot expand to accommodate a VLAN tag.

The MACsec virtual device is an existing example that limits the MTU of
upper VLAN devices via netif_reduces_vlan_mtu(), but there are other
devices that should do so too. For example, virtual tunnel devices that
provide L2 overlays inside L3 networks where the inner L2 headers
contribute towards the outer L3 size.

Generalize netif_reduces_vlan_mtu() using a new device private flag to
indicate that the lower device does not have sufficient room to
accommodate a VLAN tag and convert MACsec to use the new flag. Also
apply this concept to the VLAN virtual device itself, since physical
devices do not generally allocate L2 room for nested VLANs.

Note that if the lower device is manually configured to a smaller MTU
value than the maximum it supports, then there is sufficient room and
IFF_NO_VLAN_ROOM should not be set.

Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
---
 drivers/net/macsec.c      |  6 ++++--
 include/linux/if_vlan.h   | 40 +++++++++++++++++++++++++++++++++++++++
 include/linux/netdevice.h |  6 ++++--
 net/8021q/vlan_dev.c      |  9 +++++++++
 net/8021q/vlan_netlink.c  |  2 ++
 5 files changed, 59 insertions(+), 4 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 20b53e255f68..4d02a953803a 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3633,11 +3633,13 @@ static int macsec_change_mtu(struct net_device *dev, int new_mtu)
 {
 	struct macsec_dev *macsec = macsec_priv(dev);
 	unsigned int extra = macsec->secy.icv_len + macsec_extra_len(true);
+	unsigned int max_mtu = macsec->real_dev->mtu - extra;
 
-	if (macsec->real_dev->mtu - extra < new_mtu)
+	if (new_mtu > max_mtu)
 		return -ERANGE;
 
 	dev->mtu = new_mtu;
+	__vlan_constrain_mtu(dev, max_mtu);
 
 	return 0;
 }
@@ -4018,7 +4020,7 @@ static int macsec_newlink(struct net *net, struct net_device *dev,
 	if (real_dev->type != ARPHRD_ETHER)
 		return -EINVAL;
 
-	dev->priv_flags |= IFF_MACSEC;
+	dev->priv_flags |= IFF_MACSEC | IFF_NO_VLAN_ROOM;
 
 	macsec->real_dev = real_dev;
 
diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
index b05e855f1ddd..e4a5532fb179 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -749,4 +749,44 @@ static inline unsigned long compare_vlan_header(const struct vlan_hdr *h1,
 		(__force u32)h2->h_vlan_encapsulated_proto);
 #endif
 }
+
+/* max_mtu is not necessarily the same as dev->max_mtu */
+static inline void __vlan_constrain_mtu(struct net_device *dev, int max_mtu)
+{
+	if (dev->mtu > max_mtu - VLAN_HLEN)
+		dev->priv_flags |= IFF_NO_VLAN_ROOM;
+	else
+		dev->priv_flags &= ~IFF_NO_VLAN_ROOM;
+}
+
+/**
+ * vlan_constrain_mtu - reduce MTU for upper VLAN devices if there's no L2 room
+ * @dev: a lower device having a VLAN constrained L2
+ *
+ * Sets IFF_NO_VLAN_ROOM based on the device's current and max MTU.
+ *
+ * Normally MTU does not account for an outer VLAN tag, since MTU is an L3
+ * constraint. Thus, this should only be called by devices that cannot expand
+ * L2 to accommodate one. For example, in order to support VLANs without IP
+ * fragmentation inside various tunnel encapsulations where the inner L2 size
+ * contributes towards the outer L3 size.
+ *
+ * This can also be useful for supporting VLANs, using a reduced MTU, on
+ * hardware which is VLAN challenged.
+ */
+static inline void vlan_constrain_mtu(struct net_device *dev)
+{
+	__vlan_constrain_mtu(dev, dev->max_mtu);
+}
+
+/**
+ * vlan_constrained_change_mtu - ndo_change_mtu for VLAN challenged devices
+ * @dev: the device to update
+ * @new_mtu: the new MTU
+ *
+ * This handler updates MTU and maintains the IFF_NO_VLAN_ROOM flag based on
+ * the newly requested MTU and the maximum supported by the device.
+ */
+int vlan_constrained_change_mtu(struct net_device *dev, int new_mtu);
+
 #endif /* !(_LINUX_IF_VLAN_H_) */
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index fe7705eaad5a..4d2ccdb9c57e 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1516,6 +1516,7 @@ struct net_device_ops {
  * @IFF_LIVE_ADDR_CHANGE: device supports hardware address
  *	change when it's running
  * @IFF_MACVLAN: Macvlan device
+ * @IFF_NO_VLAN_ROOM: space constrained L2, upper VLAN devices must reduce MTU
  * @IFF_L3MDEV_MASTER: device is an L3 master device
  * @IFF_NO_QUEUE: device can run without qdisc attached
  * @IFF_OPENVSWITCH: device is a Open vSwitch master
@@ -1549,6 +1550,7 @@ enum netdev_priv_flags {
 	IFF_SUPP_NOFCS			= 1<<14,
 	IFF_LIVE_ADDR_CHANGE		= 1<<15,
 	IFF_MACVLAN			= 1<<16,
+	IFF_NO_VLAN_ROOM		= 1<<17,
 	IFF_L3MDEV_MASTER		= 1<<18,
 	IFF_NO_QUEUE			= 1<<19,
 	IFF_OPENVSWITCH			= 1<<20,
@@ -1581,6 +1583,7 @@ enum netdev_priv_flags {
 #define IFF_SUPP_NOFCS			IFF_SUPP_NOFCS
 #define IFF_LIVE_ADDR_CHANGE		IFF_LIVE_ADDR_CHANGE
 #define IFF_MACVLAN			IFF_MACVLAN
+#define IFF_NO_VLAN_ROOM		IFF_NO_VLAN_ROOM
 #define IFF_L3MDEV_MASTER		IFF_L3MDEV_MASTER
 #define IFF_NO_QUEUE			IFF_NO_QUEUE
 #define IFF_OPENVSWITCH			IFF_OPENVSWITCH
@@ -4855,8 +4858,7 @@ static inline void netif_keep_dst(struct net_device *dev)
 /* return true if dev can't cope with mtu frames that need vlan tag insertion */
 static inline bool netif_reduces_vlan_mtu(struct net_device *dev)
 {
-	/* TODO: reserve and use an additional IFF bit, if we get more users */
-	return dev->priv_flags & IFF_MACSEC;
+	return dev->priv_flags & IFF_NO_VLAN_ROOM;
 }
 
 extern struct pernet_operations __net_initdata loopback_net_ops;
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index f00bb57f0f60..67354b4ebcdb 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -149,10 +149,19 @@ static int vlan_dev_change_mtu(struct net_device *dev, int new_mtu)
 		return -ERANGE;
 
 	dev->mtu = new_mtu;
+	__vlan_constrain_mtu(dev, max_mtu);
 
 	return 0;
 }
 
+int vlan_constrained_change_mtu(struct net_device *dev, int new_mtu)
+{
+	dev->mtu = new_mtu;
+	vlan_constrain_mtu(dev);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vlan_constrained_change_mtu);
+
 void vlan_dev_set_ingress_priority(const struct net_device *dev,
 				   u32 skb_prio, u16 vlan_prio)
 {
diff --git a/net/8021q/vlan_netlink.c b/net/8021q/vlan_netlink.c
index 0db85aeb119b..c7aea2488f46 100644
--- a/net/8021q/vlan_netlink.c
+++ b/net/8021q/vlan_netlink.c
@@ -181,6 +181,8 @@ static int vlan_newlink(struct net *src_net, struct net_device *dev,
 		dev->mtu = max_mtu;
 	else if (dev->mtu > max_mtu)
 		return -EINVAL;
+	else if (dev->mtu > max_mtu - VLAN_HLEN)
+		dev->priv_flags |= IFF_NO_VLAN_ROOM;
 
 	err = vlan_changelink(dev, tb, data, extack);
 	if (!err)
-- 
2.26.2

