Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5841E5071
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 23:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387409AbgE0VZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 17:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbgE0VZ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 17:25:56 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99510C05BD1E
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 14:25:56 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id g5so945221pfm.10
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 14:25:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pIJb8OlIrEi/I/juOatU3vRzicOP7TfyuvuaEq31vrs=;
        b=U284Q8h2rYv3eTeGbB88vUoieKDXDt2YYekFL3vYIeIJ5SbWTXLyHGYuoYv9vX0dai
         qpcW51SL6oKG53oAslKM4HDz0AUTNz5I5mjKZGS25WBlCBxQN7g5J6Pgbq3u+OJMXW1u
         E4roIVYOoZ+sAHFlombLz+xjH2GTUr8ylhWIA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pIJb8OlIrEi/I/juOatU3vRzicOP7TfyuvuaEq31vrs=;
        b=bsg3UvemQrjUsCLcBQ6ZkR/Yn1CA7Da/Ub0AjoHnpHqH0SundUu42wPpm3L/SH5emq
         IsJN2xr9tTgJRhrlDxBY48DNj6GbOrgN2tDcHd8v9sgzPUDgJOPYcRmGY+gx2+RJIC3r
         8lXPjmllbREqcDdRVeYZo/HUXxHq7Cw34LsBAihHiReucsUKZRJEN/XgsG1AKL8S3Fri
         r2xwfXt8VJVRL5G+GbhPx8OWPimnusft/UYbjcywWf5cSWoxgP31hq/zGAnYNsm2WGy1
         h/OXN+7pF3QUUCk/YzO3rIya9QxFl6n082C4qj5b/QF7QpkTyE63gvgAxMYsIuUnKweH
         Hhdw==
X-Gm-Message-State: AOAM5307ik+UwHuGJ2WCkP1721W07zX+WPiqclpjW6GChxxWSiupdq9M
        Bb9GDQ+TReA2bBITjmx97FSCMcoO18MuU6kPYWL2ckj5Y1WelsPBFkkZ7QOLNJH/Sn5rlLoqDtN
        90EKBTT8GFw0Puytt/pHxruBxU6SoJjgBh4y1lwvngD8oUcGlLWIq976VGEMcfYzDjLj7hE/V
X-Google-Smtp-Source: ABdhPJwob2kWZrti9hIQwdG84/YjwMxVx6AtRWAgWdxW6+PbPsi9a1FW2ot0IF9YH05mAUGXmy84RA==
X-Received: by 2002:a65:6496:: with SMTP id e22mr6061953pgv.63.1590614755602;
        Wed, 27 May 2020 14:25:55 -0700 (PDT)
Received: from localhost.localdomain ([2600:8802:202:f600::ddf])
        by smtp.gmail.com with ESMTPSA id c4sm2770344pfb.130.2020.05.27.14.25.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 14:25:55 -0700 (PDT)
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
Subject: [RFC PATCH net-next 05/11] net: vxlan: constrain upper VLAN MTU using IFF_NO_VLAN_ROOM
Date:   Wed, 27 May 2020 14:25:06 -0700
Message-Id: <20200527212512.17901-6-edwin.peer@broadcom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200527212512.17901-1-edwin.peer@broadcom.com>
References: <20200527212512.17901-1-edwin.peer@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Constrain the MTU of upper VLAN devices if the MTU of the VXLAN device
is configured to its default optimal size, which does not leave space
for a nested VLAN tag without causing fragmentation. If the underlying
lower device is not known, then the worst case is assumed and any upper
VLAN devices will always be adjusted to accommodate the VLAN tag.

Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
---
 drivers/net/vxlan.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index a0015cdedfaf..3e9c65eb4737 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -3098,18 +3098,20 @@ static int vxlan_change_mtu(struct net_device *dev, int new_mtu)
 	struct net_device *lowerdev = __dev_get_by_index(vxlan->net,
 							 dst->remote_ifindex);
 	bool use_ipv6 = !!(vxlan->cfg.flags & VXLAN_F_IPV6);
+	unsigned int max_mtu = 0;
 
 	/* This check is different than dev->max_mtu, because it looks at
 	 * the lowerdev->mtu, rather than the static dev->max_mtu
 	 */
 	if (lowerdev) {
-		int max_mtu = lowerdev->mtu -
-			      (use_ipv6 ? VXLAN6_HEADROOM : VXLAN_HEADROOM);
+		max_mtu = lowerdev->mtu -
+			  (use_ipv6 ? VXLAN6_HEADROOM : VXLAN_HEADROOM);
 		if (new_mtu > max_mtu)
 			return -EINVAL;
 	}
 
 	dev->mtu = new_mtu;
+	__vlan_constrain_mtu(dev, max_mtu);
 	return 0;
 }
 
@@ -3241,7 +3243,7 @@ static void vxlan_setup(struct net_device *dev)
 	dev->hw_features |= NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_RXCSUM;
 	dev->hw_features |= NETIF_F_GSO_SOFTWARE;
 	netif_keep_dst(dev);
-	dev->priv_flags |= IFF_NO_QUEUE;
+	dev->priv_flags |= IFF_NO_QUEUE | IFF_NO_VLAN_ROOM;
 
 	/* MTU range: 68 - 65535 */
 	dev->min_mtu = ETH_MIN_MTU;
@@ -3762,6 +3764,8 @@ static void vxlan_config_apply(struct net_device *dev,
 	if (dev->mtu > max_mtu)
 		dev->mtu = max_mtu;
 
+	__vlan_constrain_mtu(dev, max_mtu);
+
 	if (use_ipv6 || conf->flags & VXLAN_F_COLLECT_METADATA)
 		needed_headroom += VXLAN6_HEADROOM;
 	else
-- 
2.26.2

