Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 111B0343E1C
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 11:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbhCVKii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 06:38:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbhCVKiZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 06:38:25 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD201C061574
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 03:38:24 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id x21so18653222eds.4
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 03:38:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N+Z019FTmNdQoy2fMcasjqIR4BZXtUnBZiaXBGeEH5A=;
        b=r+wp0XzvOyj8O+bF+Baem0XKKYipKmS3prj8msBFBl9fLK+Wv3nOXAHp82xdcv78WA
         Pr902tKEALv9Vw3VTHPNcXnEgphj/Uoub0kvCj3s3TXJ+ChhQVOHzZFLT8sd0CCvx6jQ
         tKN7/yzhZ3Tr3AX5OdNbfzuqRvDoyyNs4Gj92cAf9y6WuINR32FLkFBn3Oe/6cUjJNrM
         wS7YZ580JV/xdOg3P9hse78XjppY7v0+lxGBQV7ZvcwCGQLy2Oq/rzpgUiB0IDjouL2f
         klBql6UJIln34A4gEhBbZFD0FVmAe3/H2xEW/XlV/UgVOoIStq0JI0awQvGVW8aZfhDD
         ws4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N+Z019FTmNdQoy2fMcasjqIR4BZXtUnBZiaXBGeEH5A=;
        b=aMX9MHMev8rR0XJFzO/6Gm9nzYhr2BRSyjtafGo0yr1y0bppifrgpGphxjGD35RrQh
         jfnt6P5HPEpA4e8agdvaQURKV2xPskEtbpF0dovFrgtxgmWwGumWeaC6n8U/KTcHUFNO
         VRCKZXbjdJ64qRlYgdnmnxonFiNF0Khm0D8POdbPxcAHBG6mjqTm+y/hSbAzC2h1HAvd
         RiG4UoQNLsLvC0gLOV0MljCCYMC7mGwi+0bhgQrLyTntcg3jhN+tiEZwT0zExz+2efnP
         LmcCfeartGJrI2SHh3/mNOrw9NC9w8yp/4omY6stukwClAOwmQwB9cQ5o5YAwfamzPBB
         xpew==
X-Gm-Message-State: AOAM5323+e0RbJOFJssWR07u5YA6DGG7kcTanfvHwn2G25zXHOS7JpMQ
        R+/EdOQf6hAwMDiploYJhUk=
X-Google-Smtp-Source: ABdhPJxYUe1bmTRUZApiJN5K9y/zVkwGG+yX8v37O0KAP2Z9gAHyMeJAf4Jnj7OuCpjYGQsf6HxCZg==
X-Received: by 2002:a50:f314:: with SMTP id p20mr24609567edm.236.1616409503586;
        Mon, 22 Mar 2021 03:38:23 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id cb17sm11267097edb.10.2021.03.22.03.38.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 03:38:22 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next] net: bridge: declare br_vlan_tunnel_lookup argument tunnel_id as __be64
Date:   Mon, 22 Mar 2021 12:38:19 +0200
Message-Id: <20210322103819.3723179-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The only caller of br_vlan_tunnel_lookup, br_handle_ingress_vlan_tunnel,
extracts the tunnel_id from struct ip_tunnel_info::struct ip_tunnel_key::
tun_id which is a __be64 value.

The exact endianness does not seem to matter, because the tunnel id is
just used as a lookup key for the VLAN group's tunnel hash table, and
the value is not interpreted directly per se. Moreover,
rhashtable_lookup_fast treats the key argument as a const void *.

Therefore, there is no functional change associated with this patch,
just one to silence "make W=1" builds.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_vlan_tunnel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_vlan_tunnel.c b/net/bridge/br_vlan_tunnel.c
index 169e005fbda2..0d3a8c01552e 100644
--- a/net/bridge/br_vlan_tunnel.c
+++ b/net/bridge/br_vlan_tunnel.c
@@ -35,7 +35,7 @@ static const struct rhashtable_params br_vlan_tunnel_rht_params = {
 };
 
 static struct net_bridge_vlan *br_vlan_tunnel_lookup(struct rhashtable *tbl,
-						     u64 tunnel_id)
+						     __be64 tunnel_id)
 {
 	return rhashtable_lookup_fast(tbl, &tunnel_id,
 				      br_vlan_tunnel_rht_params);
-- 
2.25.1

