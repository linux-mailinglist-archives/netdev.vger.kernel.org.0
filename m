Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3FA358E53C
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 05:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbiHJDMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 23:12:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbiHJDLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 23:11:49 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA3F781B24;
        Tue,  9 Aug 2022 20:11:48 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id i4so10073323qvv.7;
        Tue, 09 Aug 2022 20:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=Hp8X0Fyr4/2vEhnQv+XptPZYetbjO6fR4naGTVRNFEM=;
        b=cNpzzB1r3CIyeIFPMsN7JSnnntMkiuMtFWRzYVBFPnHuy082TYrzFn/KTQZipNcjgk
         uZ1Mk/VwdQoMec9VWUtDqfcMKy47WBL32T7HHnz6i14X7ZAdZq37p1iaUBXsAXndQbxA
         1F3Jp4KoCltzWgv6n1TUfL0ry8MKU9RLs5XgcgAzheVqVsIeUUNfvcFBilIPFjgChHBs
         Rv4KXtpSNmRbp9f5stWjX5Avc6XJbG06A55YMS8BxDViv1EllxR6ysbpA0BduKb6nM8V
         XmskwtufmwpAtFuPT8xW3v1i5YH4wv9qErn+znOLnbISrtP9bDLhTRna3ghVntrBewwV
         f43Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=Hp8X0Fyr4/2vEhnQv+XptPZYetbjO6fR4naGTVRNFEM=;
        b=DnwfGN7MglimWBAAfoZbJtuSupRiXG1PJS3aBGu3vG8MDtrCckZ86wWAefi2hPyN93
         5Drxq2+oI1heJ9zrsJc6CsV6JQxfGjuv/yQMWFOj8o/Tnl6C8rU6uehMvqRzl9sbpvN8
         hPpEE1pAwgHjOA+enIzewaKNw6RTR1pY6+CteU88QdPaaIcRxx0E/Gy/LofIyJDUGa3u
         bYIYSpH7bq3Uyx1d4TOdVjodnjMZR5Qfr2ff0P1QoAtJl8wGscpgZuZNfDEB+I0gvylN
         548OmHzyNSdmnzbFgAxWUhKNdd/BX22tYcOS8/ro5mdgLj+MEa2M6CXcRmQlqzaBSBsO
         xBzQ==
X-Gm-Message-State: ACgBeo2V6cFfLsI4af8JN7fZ16wwg9KeqXlqO4mX9Y3bJt9PDtUB+4Ej
        YLSs796z2mQQgvREyFju55LXCURn5AmieVKQ
X-Google-Smtp-Source: AA6agR6nqrPhrxobM5Q9dHGGZvRWGptqfBT8L9O4bSMq5BcAfoMZRBU9yDXeOK3rutc7YpNPkJleiA==
X-Received: by 2002:ad4:5be4:0:b0:47b:4bdd:b1c7 with SMTP id k4-20020ad45be4000000b0047b4bddb1c7mr10203328qvc.64.1660101107623;
        Tue, 09 Aug 2022 20:11:47 -0700 (PDT)
Received: from euclid ([71.58.109.160])
        by smtp.gmail.com with ESMTPSA id bl4-20020a05620a1a8400b006b999c1030bsm676680qkb.52.2022.08.09.20.11.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 20:11:47 -0700 (PDT)
From:   Sevinj Aghayeva <sevinj.aghayeva@gmail.com>
To:     netdev@vger.kernel.org
Cc:     aroulin@nvidia.com, sbrivio@redhat.com, roopa@nvidia.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        Sevinj Aghayeva <sevinj.aghayeva@gmail.com>
Subject: [PATCH RFC net-next 2/3] net: 8021q: fix bridge binding behavior for vlan interfaces
Date:   Tue,  9 Aug 2022 23:11:20 -0400
Message-Id: <3a01eea27e92133a3130e3d8d5f487d6900298db.1660100506.git.sevinj.aghayeva@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1660100506.git.sevinj.aghayeva@gmail.com>
References: <cover.1660100506.git.sevinj.aghayeva@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, when one creates a vlan interface with the bridge binding flag
disabled (using ip link add... command) and then enables the bridge binding flag
afterwards (using ip link set... command), the second command has no effect. In
other words, the vlan interface does not follow the status of the ports in its
vlan.

The root cause of this problem is as follows. The correct bridge binding
behavior depends on two flags being set: a per vlan interface flag
(VLAN_FLAG_BRIDGE_BINDING) and global per bridge flag
(BROPT_VLAN_BRIDGE_BINDING); the ip link set command calls vlan_dev_change_flags
function, which sets only the per vlan interface flag.

The correct behavior is to set/unset per bridge flag as well, depending on
whether there are other vlan interfaces with bridge binding flags set. The logic
for this behavior is already captured in br_vlan_upper_change function, which is
called whenever NETDEV_CHANGEUPPER event occurs. This patch fixes the bridge
binding behavior by triggering the NETDEV_CHANGEUPPER event from the
vlan_dev_change_flags function whenever the per interface flag is changed.

Signed-off-by: Sevinj Aghayeva <sevinj.aghayeva@gmail.com>
---
 net/8021q/vlan.h     |  2 +-
 net/8021q/vlan_dev.c | 25 ++++++++++++++++++++++---
 2 files changed, 23 insertions(+), 4 deletions(-)

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
index 839f2020b015..49cf4cceebef 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -208,12 +208,19 @@ int vlan_dev_set_egress_priority(const struct net_device *dev,
 	return 0;
 }
 
+static inline bool netif_is_bridge(const struct net_device *dev)
+{
+	return dev->rtnl_link_ops &&
+	    !strcmp(dev->rtnl_link_ops->kind, "bridge");
+}
+
 /* Flags are defined in the vlan_flags enum in
  * include/uapi/linux/if_vlan.h file.
  */
-int vlan_dev_change_flags(const struct net_device *dev, u32 flags, u32 mask)
+int vlan_dev_change_flags(struct net_device *dev, u32 flags, u32 mask)
 {
 	struct vlan_dev_priv *vlan = vlan_dev_priv(dev);
+	struct netdev_notifier_changeupper_info info;
 	u32 old_flags = vlan->flags;
 
 	if (mask & ~(VLAN_FLAG_REORDER_HDR | VLAN_FLAG_GVRP |
@@ -223,19 +230,31 @@ int vlan_dev_change_flags(const struct net_device *dev, u32 flags, u32 mask)
 
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
+	    netif_is_bridge(vlan->real_dev)) {
+		info.info.dev = vlan->real_dev;
+		info.upper_dev = dev;
+		info.linking = !!(vlan->flags & VLAN_FLAG_BRIDGE_BINDING);
+		call_netdevice_notifiers_info(NETDEV_CHANGEUPPER, &info.info);
+	}
+
 	return 0;
 }
 
-- 
2.25.1

