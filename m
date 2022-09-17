Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2258F5BBA3C
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 22:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiIQUSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Sep 2022 16:18:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbiIQUSR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Sep 2022 16:18:17 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85C542ED4C;
        Sat, 17 Sep 2022 13:18:16 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id g2so15288286qkk.1;
        Sat, 17 Sep 2022 13:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=KD38OQmgSaziFwz483qpbZ1Z/wABtZJQ/6K4DXA6e78=;
        b=gs9ODi1SU9Kl9RMZdfPPVTL92g9U582A3QyiLLRHk0DP7aMRekW1vpxaCY0DuFyIy4
         Gmc4JC2MEREo4YrkmPICVj1cRladnhz9FRB9fiEK9D3+BIlyLccZYLnCIxuHqHwdrsGD
         dW8uzY5Nr3tOyjePNVIUQBANY0ZAZjFX1So6C4mK1nQlfAAJBFmtz6jCoNsXy7zttZND
         jKfX1evavoNcmyB5HmuMkKAb5ycpNjp8o+OKvklksejBqwuCTi0YqGk2/+C1AXLVvmLd
         o8ma7WJJpQUuFiae7662YPBheSg92Qu7bruwrCCM5boqvzkYdsq1aBWq0QBXeiPfQ6Js
         14Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=KD38OQmgSaziFwz483qpbZ1Z/wABtZJQ/6K4DXA6e78=;
        b=d296d2ejuUjMHgNskUsDjSaet5STLOVCEJhdn1+6UYCng6RB7IRHBpg7DWhSul6Utr
         LkJrdZYXUB8qtv+2iENLpAkVYC/3k0shl1qgHxrzKVf9DgHYCRX1+No+qKcYldR5NeBG
         bDwC++VBP3x0M4oHOshbne9lflIt2sstLpYT6x4RIgtRjg6zzSSrfiZwzv/22jwv0lzX
         a9KpUAAzoj3tJi3cq7TqvWV2xe5KlV9oKiBcrel+TdlSvUunP60TC+KhdVQNq4ZfAPwL
         d4abinUpPWb4C77ZygqoR7kl2kj9H8cnWVoRfGW3SFtNECk7EQ+29T94RXJBb7z3+pEy
         qAiw==
X-Gm-Message-State: ACrzQf01lk10JtAbIV7dcUX+hRo7OvTFUw9PvspJBZwSAAMVszUDydnB
        jELo/Kvf/8WnOwchgoK1fAm9X/FaDUEHTyxF
X-Google-Smtp-Source: AMsMyM6Ok6WmHv6IRGK6yGFxMFRo9CdplvCq2/ELeU5O7Zh8aUDcrdFmWFDh2DR4PhIfiFuVbfsnHg==
X-Received: by 2002:a05:620a:254f:b0:6bc:5763:de4b with SMTP id s15-20020a05620a254f00b006bc5763de4bmr8083968qko.207.1663445895626;
        Sat, 17 Sep 2022 13:18:15 -0700 (PDT)
Received: from euclid ([71.58.109.160])
        by smtp.gmail.com with ESMTPSA id q13-20020a37f70d000000b006b8e63dfffbsm8769539qkj.58.2022.09.17.13.18.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Sep 2022 13:18:15 -0700 (PDT)
From:   Sevinj Aghayeva <sevinj.aghayeva@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>, aroulin@nvidia.com,
        sbrivio@redhat.com, roopa@nvidia.com,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        Sevinj Aghayeva <sevinj.aghayeva@gmail.com>
Subject: [PATCH RFC net-next 3/5] net: 8021q: notify bridge module of bridge-binding flag change
Date:   Sat, 17 Sep 2022 16:17:59 -0400
Message-Id: <d6500b2caf726437fad97d37c728708755791c0e.1663445339.git.sevinj.aghayeva@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1663445339.git.sevinj.aghayeva@gmail.com>
References: <cover.1663445339.git.sevinj.aghayeva@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Notify the bridge module when a user changes the bridge-binding flag
of a VLAN interface using "ip link set ... vlan bridge_binding on"
command, so that the bridge module can take the appropriate action for
this change.

Signed-off-by: Sevinj Aghayeva <sevinj.aghayeva@gmail.com>
---
 net/8021q/vlan.h     |  2 +-
 net/8021q/vlan_dev.c | 20 +++++++++++++++++---
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/net/8021q/vlan.h b/net/8021q/vlan.h
index 5eaf38875554..71947cdcfaaa 100644
--- a/net/8021q/vlan.h
+++ b/net/8021q/vlan.h
@@ -130,7 +130,7 @@ void vlan_dev_set_ingress_priority(const struct net_device *dev,
 int vlan_dev_set_egress_priority(const struct net_device *dev,
 				 u32 skb_prio, u16 vlan_prio);
 void vlan_dev_free_egress_priority(const struct net_device *dev);
-int vlan_dev_change_flags(const struct net_device *dev, u32 flag, u32 mask);
+int vlan_dev_change_flags(struct net_device *dev, u32 flag, u32 mask);
 void vlan_dev_get_realdev_name(const struct net_device *dev, char *result,
 			       size_t size);
 
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index e1bb41a443c4..7c61b813e654 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -22,6 +22,7 @@
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
 #include <linux/net_tstamp.h>
+#include <linux/notifier_info.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
 #include <linux/phy.h>
@@ -211,8 +212,9 @@ int vlan_dev_set_egress_priority(const struct net_device *dev,
 /* Flags are defined in the vlan_flags enum in
  * include/uapi/linux/if_vlan.h file.
  */
-int vlan_dev_change_flags(const struct net_device *dev, u32 flags, u32 mask)
+int vlan_dev_change_flags(struct net_device *dev, u32 flags, u32 mask)
 {
+	struct netdev_notifier_change_details_info details;
 	struct vlan_dev_priv *vlan = vlan_dev_priv(dev);
 	u32 old_flags = vlan->flags;
 
@@ -223,19 +225,31 @@ int vlan_dev_change_flags(const struct net_device *dev, u32 flags, u32 mask)
 
 	vlan->flags = (old_flags & ~mask) | (flags & mask);
 
-	if (netif_running(dev) && (vlan->flags ^ old_flags) & VLAN_FLAG_GVRP) {
+	if (!netif_running(dev))
+		return 0;
+
+	if ((vlan->flags ^ old_flags) & VLAN_FLAG_GVRP) {
 		if (vlan->flags & VLAN_FLAG_GVRP)
 			vlan_gvrp_request_join(dev);
 		else
 			vlan_gvrp_request_leave(dev);
 	}
 
-	if (netif_running(dev) && (vlan->flags ^ old_flags) & VLAN_FLAG_MVRP) {
+	if ((vlan->flags ^ old_flags) & VLAN_FLAG_MVRP) {
 		if (vlan->flags & VLAN_FLAG_MVRP)
 			vlan_mvrp_request_join(dev);
 		else
 			vlan_mvrp_request_leave(dev);
 	}
+
+	if ((vlan->flags ^ old_flags) & VLAN_FLAG_BRIDGE_BINDING &&
+	    netif_is_bridge_master(vlan->real_dev)) {
+		details.info.dev = dev;
+		details.vlan.bridge_binding =
+		    !!(vlan->flags & VLAN_FLAG_BRIDGE_BINDING);
+		call_netdevice_notifiers_info(NETDEV_CHANGE_DETAILS, &details.info);
+	}
+
 	return 0;
 }
 
-- 
2.34.1

