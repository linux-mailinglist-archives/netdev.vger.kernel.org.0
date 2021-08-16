Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD4DC3ED954
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 16:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232484AbhHPO6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 10:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232181AbhHPO5y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 10:57:54 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F1DFC06179A
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 07:57:22 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id bq25so22257754ejb.11
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 07:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cEF4JoMHZEME1+G2CZln0Yotihc+zLCjsCuSYLc+j3Q=;
        b=ZjYbNocK7nQUZmK7tS1SYFaF524im4zpkYuIBe6PLoxPdvEg0nn2rcea6i9NgA8bX4
         5WxNZdktA5V1y3KOperLhnJRMWBEby8lRcK9l7YLqU355DpaS10sNON3jKYdlBXK8ytZ
         jcDmlbG/jOEGCna1DpdOLm16+JkjTsG1COKe/bBUmDBZ5Puj4LqLXK45s9LdVVItgSaS
         M8AU97MS3myCmrlBPZ+iXOeShvRSHzWI7WtrziFO2XoQv24HwBVQD9wl0A5CCtnsoMb2
         u2DlHGrvkSDUt3nAQmJ4Oz37oB5aH27bTak8L5rH0jBRcM/dBPzjZ2AcfcmnC3KJ48Is
         3kRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cEF4JoMHZEME1+G2CZln0Yotihc+zLCjsCuSYLc+j3Q=;
        b=VCydjqOo/LvjJ6myL5k/rbCQxyCHvEnxTp1aFlkQC3X5txq0vQlYnFBobp7vo6R1zP
         vM6oB5N7vqEhzARWml7Zm95KT4crnhS1JHiS0O4yA8trQtRlfcarFcyM4k6eiCS/vpFz
         bCzuuUZ6jw2xXnXPBKSy4xT0LrnlMZtcsv9Yb7GHLRMtrEYcNcHQQDcXzMPRPnTCiPOp
         4OGcMiaZgtHmLgF2fbrMmpIhknxdffI7yhDWxQ3JRnmNZ1GfmoboBKztOx7gtTPEJOFr
         mX9Otywv4fL8tc90uJgNN0+rkoBfN4F2gGcAbvWWpCRuhzFkuG2y5NI0ex2SGCs1z94d
         13Fw==
X-Gm-Message-State: AOAM530jIzFiS5y6gyT8N39OZbD45eGuebhadu4CmkJHtdCKmcf/kcmg
        uEse4x+E88MaFQj6/7nwGQ+gE0f/5+Khg06w
X-Google-Smtp-Source: ABdhPJw5OWKOOio/+Fe5CZbS7wFaCnTjZadQPBOSc04Ep5jRgCDHhWafz0loLdIDYEaFv5/2YsTkTw==
X-Received: by 2002:a17:906:2bd0:: with SMTP id n16mr16446539ejg.132.1629125840736;
        Mon, 16 Aug 2021 07:57:20 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id t25sm4946076edi.65.2021.08.16.07.57.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 07:57:20 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 4/4] net: bridge: mcast: toggle also host vlan state in br_multicast_toggle_vlan
Date:   Mon, 16 Aug 2021 17:57:07 +0300
Message-Id: <20210816145707.671901-5-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210816145707.671901-1-razor@blackwall.org>
References: <20210816145707.671901-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

When changing vlan mcast state by br_multicast_toggle_vlan it iterates
over all ports and enables/disables the port mcast ctx based on the new
state, but I forgot to update the host vlan (bridge master vlan entry)
with the new state so it will be left out. Also that function is not
used outside of br_multicast.c, so make it static.

Fixes: f4b7002a7076 ("net: bridge: add vlan mcast snooping knob")
Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_multicast.c | 5 ++++-
 net/bridge/br_private.h   | 6 ------
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index c9f7f56eaf9b..16e686f5b9e9 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -4074,7 +4074,7 @@ void br_multicast_toggle_one_vlan(struct net_bridge_vlan *vlan, bool on)
 	}
 }
 
-void br_multicast_toggle_vlan(struct net_bridge_vlan *vlan, bool on)
+static void br_multicast_toggle_vlan(struct net_bridge_vlan *vlan, bool on)
 {
 	struct net_bridge_port *p;
 
@@ -4089,6 +4089,9 @@ void br_multicast_toggle_vlan(struct net_bridge_vlan *vlan, bool on)
 			continue;
 		br_multicast_toggle_one_vlan(vport, on);
 	}
+
+	if (br_vlan_is_brentry(vlan))
+		br_multicast_toggle_one_vlan(vlan, on);
 }
 
 int br_multicast_toggle_vlan_snooping(struct net_bridge *br, bool on,
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index df0fa246c80c..21b292eb2b3e 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -938,7 +938,6 @@ void br_multicast_port_ctx_init(struct net_bridge_port *port,
 				struct net_bridge_mcast_port *pmctx);
 void br_multicast_port_ctx_deinit(struct net_bridge_mcast_port *pmctx);
 void br_multicast_toggle_one_vlan(struct net_bridge_vlan *vlan, bool on);
-void br_multicast_toggle_vlan(struct net_bridge_vlan *vlan, bool on);
 int br_multicast_toggle_vlan_snooping(struct net_bridge *br, bool on,
 				      struct netlink_ext_ack *extack);
 bool br_multicast_toggle_global_vlan(struct net_bridge_vlan *vlan, bool on);
@@ -1370,11 +1369,6 @@ static inline void br_multicast_toggle_one_vlan(struct net_bridge_vlan *vlan,
 {
 }
 
-static inline void br_multicast_toggle_vlan(struct net_bridge_vlan *vlan,
-					    bool on)
-{
-}
-
 static inline int br_multicast_toggle_vlan_snooping(struct net_bridge *br,
 						    bool on,
 						    struct netlink_ext_ack *extack)
-- 
2.31.1

