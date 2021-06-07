Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC0839E955
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 00:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231410AbhFGWMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 18:12:02 -0400
Received: from mail-pj1-f46.google.com ([209.85.216.46]:36550 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231184AbhFGWMC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 18:12:02 -0400
Received: by mail-pj1-f46.google.com with SMTP id d5-20020a17090ab305b02901675357c371so12489610pjr.1;
        Mon, 07 Jun 2021 15:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=S4r4ZMmFGJcBB3JQm3vcl+jS+Ow4hR8FEe4q6UtWXKE=;
        b=sFpAKTPEqZfpoRnvHmkwyzKd8c09qRYgEHV2VvvZVor1yZW/qR8dEosTRj2a/7JblR
         Obq9+6+6XmgXBVNZ+cpuJ29G117OjoUdYuPvfGob6WNNiV0rYxuuhu1x+PmOu/cUUQqF
         ekiPmV2GbkZv9l4QEzfnIvCEpCL789a5E5xGFePcBIx1y8vqq/IYz9tfVQOCYb6Jtnh3
         l3qTn92ZKNnSNdcQw9x9FZ6wiYR7MYS/OuOgXC92+sFzr1xVs17j6KdGxmnswnPPcaGe
         WnfQ+6vVa2goYe8p/ofQIGtScUDI3ekF2N3AV+cDOsoqECxYiRDCKUuM0uzo3JZPKhe2
         cQkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S4r4ZMmFGJcBB3JQm3vcl+jS+Ow4hR8FEe4q6UtWXKE=;
        b=sS4qP5E4gYeL1BKGGOdMtnYs/dNbDBqXnmogrqk+/B+9BAP+owZfxSHopKf5y8M8Rr
         9mZkefN1BQ97nPsC1xw4zPzBwdYM2WBLtJmgNDZ0qKkZCI4EZTq4LbAPb9dNVNStdd8b
         fdi+7VqHmrLV/UjmgJToiIqTw3MkSke9dfEruGiThGITC2k4lsaIt/rOR+IYsHx9S5KO
         wMzIuCaEdQeqwy7O9DHIdV1EAwuhH+yOUzpjG4lHcizMpBhcZK/7PRKcqAI2pPZgop7X
         HRFQYfKRNILUM1Z/WSo51QCS0XVfYjnClB0d0gRqQJg/8mjPjOPf7FKbpRIkzBzI/h+n
         jeeA==
X-Gm-Message-State: AOAM533nVMG4xpQ+iDBIBAUMP6AU3QiaLZH5gftjZbsfLP1DCqAlaVnC
        3NI2nETv1lYCXKGLahRI/mFm/TiLnYs=
X-Google-Smtp-Source: ABdhPJxXPFfEMLA0nHUzknXp5XZjopH2KlJ3NK8ld6PPf19u0JCwzHEGxRXML2pTxHvyby6hj+DZpw==
X-Received: by 2002:a17:90a:fd05:: with SMTP id cv5mr21890580pjb.24.1623103733228;
        Mon, 07 Jun 2021 15:08:53 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h8sm9144845pfn.0.2021.06.07.15.08.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jun 2021 15:08:52 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list),
        Matthew Hagan <mnhagan88@gmail.com>
Subject: [PATCH net-next 2/2] net: dsa: Remove bridge PVID untagging
Date:   Mon,  7 Jun 2021 15:08:43 -0700
Message-Id: <20210607220843.3799414-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210607220843.3799414-1-f.fainelli@gmail.com>
References: <20210607220843.3799414-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that the only user of the bridge PVID untagging code is no longer
forcing the PVID untagged VLAN configuration to be PVID egress tagged
for the CPU, we no longer need this support code to pop the VLAN tag
automatically.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/b53/b53_common.c |  1 -
 include/net/dsa.h                |  8 -----
 net/dsa/dsa.c                    |  9 -----
 net/dsa/dsa_priv.h               | 59 --------------------------------
 4 files changed, 77 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 56e3b42ec28c..dc43dadd6d31 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -2660,7 +2660,6 @@ struct b53_device *b53_switch_alloc(struct device *base,
 	dev->priv = priv;
 	dev->ops = ops;
 	ds->ops = &b53_switch_ops;
-	ds->untag_bridge_pvid = true;
 	dev->vlan_enabled = true;
 	/* Let DSA handle the case were multiple bridges span the same switch
 	 * device and different VLAN awareness settings are requested, which
diff --git a/include/net/dsa.h b/include/net/dsa.h
index e1a2610a0e06..216443820a7e 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -355,14 +355,6 @@ struct dsa_switch {
 	 */
 	bool			configure_vlan_while_not_filtering;
 
-	/* If the switch driver always programs the CPU port as egress tagged
-	 * despite the VLAN configuration indicating otherwise, then setting
-	 * @untag_bridge_pvid will force the DSA receive path to pop the bridge's
-	 * default_pvid VLAN tagged frames to offer a consistent behavior
-	 * between a vlan_filtering=0 and vlan_filtering=1 bridge device.
-	 */
-	bool			untag_bridge_pvid;
-
 	/* Let DSA manage the FDB entries towards the CPU, based on the
 	 * software bridge database.
 	 */
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 84cad1be9ce4..daac329b6e93 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -260,15 +260,6 @@ static int dsa_switch_rcv(struct sk_buff *skb, struct net_device *dev,
 
 	p = netdev_priv(skb->dev);
 
-	if (unlikely(cpu_dp->ds->untag_bridge_pvid)) {
-		nskb = dsa_untag_bridge_pvid(skb);
-		if (!nskb) {
-			kfree_skb(skb);
-			return 0;
-		}
-		skb = nskb;
-	}
-
 	dev_sw_netstats_rx_add(skb->dev, skb->len);
 
 	if (dsa_skb_defer_rx_timestamp(p, skb))
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 92282de54230..08d915d951b0 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -290,65 +290,6 @@ dsa_slave_to_master(const struct net_device *dev)
 	return dp->cpu_dp->master;
 }
 
-/* If under a bridge with vlan_filtering=0, make sure to send pvid-tagged
- * frames as untagged, since the bridge will not untag them.
- */
-static inline struct sk_buff *dsa_untag_bridge_pvid(struct sk_buff *skb)
-{
-	struct dsa_port *dp = dsa_slave_to_port(skb->dev);
-	struct net_device *br = dp->bridge_dev;
-	struct net_device *dev = skb->dev;
-	struct net_device *upper_dev;
-	u16 vid, pvid, proto;
-	int err;
-
-	if (!br || br_vlan_enabled(br))
-		return skb;
-
-	err = br_vlan_get_proto(br, &proto);
-	if (err)
-		return skb;
-
-	/* Move VLAN tag from data to hwaccel */
-	if (!skb_vlan_tag_present(skb) && skb->protocol == htons(proto)) {
-		skb = skb_vlan_untag(skb);
-		if (!skb)
-			return NULL;
-	}
-
-	if (!skb_vlan_tag_present(skb))
-		return skb;
-
-	vid = skb_vlan_tag_get_id(skb);
-
-	/* We already run under an RCU read-side critical section since
-	 * we are called from netif_receive_skb_list_internal().
-	 */
-	err = br_vlan_get_pvid_rcu(dev, &pvid);
-	if (err)
-		return skb;
-
-	if (vid != pvid)
-		return skb;
-
-	/* The sad part about attempting to untag from DSA is that we
-	 * don't know, unless we check, if the skb will end up in
-	 * the bridge's data path - br_allowed_ingress() - or not.
-	 * For example, there might be an 8021q upper for the
-	 * default_pvid of the bridge, which will steal VLAN-tagged traffic
-	 * from the bridge's data path. This is a configuration that DSA
-	 * supports because vlan_filtering is 0. In that case, we should
-	 * definitely keep the tag, to make sure it keeps working.
-	 */
-	upper_dev = __vlan_find_dev_deep_rcu(br, htons(proto), vid);
-	if (upper_dev)
-		return skb;
-
-	__vlan_hwaccel_clear_tag(skb);
-
-	return skb;
-}
-
 /* switch.c */
 int dsa_switch_register_notifier(struct dsa_switch *ds);
 void dsa_switch_unregister_notifier(struct dsa_switch *ds);
-- 
2.25.1

