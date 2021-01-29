Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6123C3088B2
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 12:58:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232319AbhA2L6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 06:58:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232919AbhA2L5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 06:57:10 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5487C033255
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 03:51:53 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id gx5so12560605ejb.7
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 03:51:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W+AoUXtDRqmvCnzMPgUsFve3ZW9qFjze1BaacgAckyQ=;
        b=rP7bBBZ1y4rd4WfGTlIm+GisET+CW5rLxqmHCokDkYwVzZePgFY5fSj9316v4KKNjm
         51gkDjnuaT5LGRN1GJvODnoLAKomScvIzrnLbLJx1EJE194d7fTqkcnJNXw8Y8z2LTwy
         no0BDxl/TyxRwRrijqB1yR1srEqxWMNc11ILC3jy0ZhIBSSlxCkZlA4pirKFaEpwio4f
         F9J3iwWXddGMsyBiudQkShN9NUn2aihtJcyaDuDNJBU6LdMf3+oBbN18enZqq8P14wDI
         PS5uwcBTI2iXYsw9bIeSNeqct/vK1Lc9czduDJs8WlignzTUGeMsFM+Dto8k7Ix4vMf3
         xMcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W+AoUXtDRqmvCnzMPgUsFve3ZW9qFjze1BaacgAckyQ=;
        b=JItd0ZELotc6hzYbHstAhnHx+4BAbHV01Skux901jY5VLugeYOGPjNGiEvcmXz4Uz8
         m/a6EXEEbhzmpo54YnP9soZbME2/jaVfHAM3gNjPc/rVKxZUqWFgE2lv4pWthKFMCeax
         IxmyoJ+Ua7RS2Hjo9iw8YIdwA3+YCfuU+zPqxmd7s3pCsiH7qXn0f3UeE/YJx7rOyF5L
         ef7AoZdgr9ru1RbMHR8+iREihlHvTlEVqP5CuYn7sALHICRN3pBu0tQ+46xAiKQROCP4
         LbUDIh5CiSTE3nvs9WYl+8wP92c7s4euOf0DjGoRvxPKdC3KIdakZsPWaTu9opCO2ruR
         p8sQ==
X-Gm-Message-State: AOAM533MTirXZj+MPqY6qhCRdlREciK7rOcw8OUcilFQigXj1131+w5B
        nO/iMrITt9PzYUdu3lpMHA/eb4rAeWyv+P4tejQ=
X-Google-Smtp-Source: ABdhPJzykpfYOLoKVtG9t7sWcnMN1AImUAoa606abQ+tJgkMFwGfZATd223/UpA9Rsa3lfVzGrVzFg==
X-Received: by 2002:a17:907:7255:: with SMTP id ds21mr4169186ejc.258.1611921112197;
        Fri, 29 Jan 2021 03:51:52 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id u23sm4450130edt.87.2021.01.29.03.51.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 03:51:51 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        kuba@kernel.org, davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 1/2] net: bridge: mcast: drop hosts limit sysfs support
Date:   Fri, 29 Jan 2021 13:51:41 +0200
Message-Id: <20210129115142.188455-2-razor@blackwall.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210129115142.188455-1-razor@blackwall.org>
References: <20210129115142.188455-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

We decided to stop adding new sysfs bridge options and continue with
netlink only, so remove hosts limit sysfs support.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_sysfs_if.c | 26 --------------------------
 1 file changed, 26 deletions(-)

diff --git a/net/bridge/br_sysfs_if.c b/net/bridge/br_sysfs_if.c
index b66305fae26b..7a59cdddd3ce 100644
--- a/net/bridge/br_sysfs_if.c
+++ b/net/bridge/br_sysfs_if.c
@@ -16,7 +16,6 @@
 #include <linux/sched/signal.h>
 
 #include "br_private.h"
-#include "br_private_mcast_eht.h"
 
 struct brport_attribute {
 	struct attribute	attr;
@@ -246,29 +245,6 @@ static int store_multicast_router(struct net_bridge_port *p,
 static BRPORT_ATTR(multicast_router, 0644, show_multicast_router,
 		   store_multicast_router);
 
-static ssize_t show_multicast_eht_hosts_limit(struct net_bridge_port *p,
-					      char *buf)
-{
-	return sprintf(buf, "%u\n", p->multicast_eht_hosts_limit);
-}
-
-static int store_multicast_eht_hosts_limit(struct net_bridge_port *p,
-					   unsigned long v)
-{
-	return br_multicast_eht_set_hosts_limit(p, v);
-}
-static BRPORT_ATTR(multicast_eht_hosts_limit, 0644,
-		   show_multicast_eht_hosts_limit,
-		   store_multicast_eht_hosts_limit);
-
-static ssize_t show_multicast_eht_hosts_cnt(struct net_bridge_port *p,
-					    char *buf)
-{
-	return sprintf(buf, "%u\n", p->multicast_eht_hosts_cnt);
-}
-static BRPORT_ATTR(multicast_eht_hosts_cnt, 0444, show_multicast_eht_hosts_cnt,
-		   NULL);
-
 BRPORT_ATTR_FLAG(multicast_fast_leave, BR_MULTICAST_FAST_LEAVE);
 BRPORT_ATTR_FLAG(multicast_to_unicast, BR_MULTICAST_TO_UNICAST);
 #endif
@@ -298,8 +274,6 @@ static const struct brport_attribute *brport_attrs[] = {
 	&brport_attr_multicast_router,
 	&brport_attr_multicast_fast_leave,
 	&brport_attr_multicast_to_unicast,
-	&brport_attr_multicast_eht_hosts_limit,
-	&brport_attr_multicast_eht_hosts_cnt,
 #endif
 	&brport_attr_proxyarp,
 	&brport_attr_proxyarp_wifi,
-- 
2.29.2

