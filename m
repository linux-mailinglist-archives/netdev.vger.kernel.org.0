Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 002A431AE02
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 21:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbhBMUow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 15:44:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbhBMUon (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 15:44:43 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BA10C061756
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 12:44:03 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id f14so5148257ejc.8
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 12:44:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JE1I1VTGDFZPepiasTZT3Ni4jl6RKpTn+EDYbD9hlJc=;
        b=HJPZ+DRfIlHqsIg/HCNUIYT9TQoyIrozPjADRmvG6CrGgSsBgYLuWOeawiC1YQkLqF
         riUJIMLLdlc2ngF1ODOPYiRdKS7y24uVB7xcUBRebUAtCPvOQJ9n6lXXfi2oEFW5gmp8
         Ye+Hd6EkiXKXyQL5+zxvmj1niE0dTmYtcrcg2mygk+1jKlLy/nu4U67o/ZdgraZfRTAw
         xK8D5MMwdfKlwVe6mFILuqLtgEvMRhFpsYGMM4jg62iyMCuiTR4EtQAnV1uCOqcZihgT
         KcbEXDtQSwYDJpd2R1L3dwHqaJA9awG1IIKMp4MhdVmZMP4LHqmcOzI/ykvk9Wu5hYkH
         u+Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JE1I1VTGDFZPepiasTZT3Ni4jl6RKpTn+EDYbD9hlJc=;
        b=nATT2NOKz66xxXA/rtX1LQWkb467pnRseF0CVxJgaq7hd1k9FGgw+KgneZmin96tjw
         iEZK1vU+3y1uY8pLzHU5NIorjvP/xiT4DhpqAMiQhDcWpWX1W5SqZjJIqxEovfxuSRts
         AcuIe8dN54x/IP2rRa+tzy4CeN/vF2ixG1N7hYT4iVgFQpLsqObQq6nO+EbxjabpWx9d
         JTGQ2dGGBn2FeZ9SWt5WebmmrBWN2qwA6lYiWJp13G+EqMjDD7t2rdTwJOTEHJ47lRUz
         QN5eG8RUmbuPJhBuKZHacBGWHK9Lx9NO6bKlCngBQSXk1SePdmspHRNs5U2qDTCGmer7
         he2w==
X-Gm-Message-State: AOAM533osnWjTqukes6alGSBRXMXMX76jGcZzR57UPm4CKFCkFUyzmAK
        76uhXCpA8wttpeUDp4N5e74=
X-Google-Smtp-Source: ABdhPJygvGHXdfg7lnNvsAMxYPh6fDBYVKdRrXubau4Ir6UYVrLpLgG5Zjnd1mXjDXn7gq/JBGLKIw==
X-Received: by 2002:a17:906:a3da:: with SMTP id ca26mr1762876ejb.67.1613249042040;
        Sat, 13 Feb 2021 12:44:02 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id p6sm2363937ejw.79.2021.02.13.12.44.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Feb 2021 12:44:01 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Ido Schimmel <idosch@idosch.org>
Subject: [PATCH net-next 1/5] net: bridge: remove __br_vlan_filter_toggle
Date:   Sat, 13 Feb 2021 22:43:15 +0200
Message-Id: <20210213204319.1226170-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210213204319.1226170-1-olteanv@gmail.com>
References: <20210213204319.1226170-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This function is identical with br_vlan_filter_toggle.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_netlink.c | 2 +-
 net/bridge/br_private.h | 5 ++---
 net/bridge/br_vlan.c    | 7 +------
 3 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 7b513c5d347f..a12bbbdacb9b 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -1212,7 +1212,7 @@ static int br_changelink(struct net_device *brdev, struct nlattr *tb[],
 	if (data[IFLA_BR_VLAN_FILTERING]) {
 		u8 vlan_filter = nla_get_u8(data[IFLA_BR_VLAN_FILTERING]);
 
-		err = __br_vlan_filter_toggle(br, vlan_filter);
+		err = br_vlan_filter_toggle(br, vlan_filter);
 		if (err)
 			return err;
 	}
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index a1639d41188b..0281de20212e 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1085,7 +1085,6 @@ int br_vlan_delete(struct net_bridge *br, u16 vid);
 void br_vlan_flush(struct net_bridge *br);
 struct net_bridge_vlan *br_vlan_find(struct net_bridge_vlan_group *vg, u16 vid);
 void br_recalculate_fwd_mask(struct net_bridge *br);
-int __br_vlan_filter_toggle(struct net_bridge *br, unsigned long val);
 int br_vlan_filter_toggle(struct net_bridge *br, unsigned long val);
 int __br_vlan_set_proto(struct net_bridge *br, __be16 proto);
 int br_vlan_set_proto(struct net_bridge *br, unsigned long val);
@@ -1261,8 +1260,8 @@ static inline u16 br_get_pvid(const struct net_bridge_vlan_group *vg)
 	return 0;
 }
 
-static inline int __br_vlan_filter_toggle(struct net_bridge *br,
-					  unsigned long val)
+static inline int br_vlan_filter_toggle(struct net_bridge *br,
+					unsigned long val)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index bb2909738518..26e7e06b6a0d 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -806,7 +806,7 @@ void br_recalculate_fwd_mask(struct net_bridge *br)
 					      ~(1u << br->group_addr[5]);
 }
 
-int __br_vlan_filter_toggle(struct net_bridge *br, unsigned long val)
+int br_vlan_filter_toggle(struct net_bridge *br, unsigned long val)
 {
 	struct switchdev_attr attr = {
 		.orig_dev = br->dev,
@@ -831,11 +831,6 @@ int __br_vlan_filter_toggle(struct net_bridge *br, unsigned long val)
 	return 0;
 }
 
-int br_vlan_filter_toggle(struct net_bridge *br, unsigned long val)
-{
-	return __br_vlan_filter_toggle(br, val);
-}
-
 bool br_vlan_enabled(const struct net_device *dev)
 {
 	struct net_bridge *br = netdev_priv(dev);
-- 
2.25.1

