Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 802443B539C
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 16:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbhF0OM5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Jun 2021 10:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231184AbhF0OMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Jun 2021 10:12:50 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0083C061766
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 07:10:26 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id gn32so24481468ejc.2
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 07:10:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HKlfmal/o+CP7UHp7miJ8mPxVzfJGeRrmH/ouQVVG8A=;
        b=lWtIZ3mlqhnvw6UnsJvbVGzGl3vsXQTX9sOwD0Vg6w56z1yAp2pK/yEScEjLMJCqWB
         MX1rOrTxg4Gkuz/kKWQFnWlRIHExi4KAEqkiq9wo2/IzjOwZMTNuR+hrRZMi8NM2+/8y
         HaV7oc3HPIVHNyOWf0E1Q6Ei22FmVPvHsnafXKhy3x4mojkXLt9qIaTd2uSXD4W1yFTn
         Z0Jen3gJzKWbrga43tfNjk68oQe7ScYm2Y6KS/m14Y29ZF7Ps2B6/aiwbrVeQ3x74P7v
         IfBiD4qyH5WzlnOEeWObFXLz6zCSL97BMmYWoowyStj2YgyVlKfE6LUgBxLLMRFgyrHz
         3yRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HKlfmal/o+CP7UHp7miJ8mPxVzfJGeRrmH/ouQVVG8A=;
        b=FKNbHzqwPFzdretCH+Ot+CkCmhcNtvLJ1DpawpRFriIvqGcXQvkfHHg9Qu8Jj2VlPH
         CgT3obCZimRPwj53VHyVETkwDesfU+l62saAbnQHzFnb+q66zBa7uxHk2QqKZ8R4wqGI
         wydOwMrrJTerm9dO4NXZ1nIdd6VJdP4BZuTRUP3ps0IAIYWz1pEe5ADycSiNlJLVzudP
         FV4PtTf3eaZwXAGR0huCtYFYkC3rB3lWcsgAmTI27iNXmSBkU8ej71L/++g7emQfopiC
         rVCDf3r+k05vs4NaplnbyokZAHF6rwdvC9cT5XnsgW4ovnkQZJiWXWhUmHnOm68e85JI
         +oGQ==
X-Gm-Message-State: AOAM532g77acJrHtYO3fKWFKtW6esimABFfAxSuk4T5+PeHcE0PRQqB9
        BygPtMdmwFkBWVSJmFx/qZL7XTbpDsw=
X-Google-Smtp-Source: ABdhPJyE1/zACGmHIauTH1LXzVqFT6boTE00Mpu7jMOpWhP8n61jTgGIPX9dHi1AFfMLCuLoKTnWgQ==
X-Received: by 2002:a17:906:c1da:: with SMTP id bw26mr20114558ejb.253.1624803024872;
        Sun, 27 Jun 2021 07:10:24 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id s4sm7857389edu.49.2021.06.27.07.10.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jun 2021 07:10:24 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH v3 net-next 04/15] net: dsa: delete dsa_legacy_fdb_add and dsa_legacy_fdb_del
Date:   Sun, 27 Jun 2021 17:10:02 +0300
Message-Id: <20210627141013.1273942-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210627141013.1273942-1-olteanv@gmail.com>
References: <20210627141013.1273942-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

We want to add reference counting for FDB entries in cross-chip
topologies, and in order for that to have any chance of working and not
be unbalanced (leading to entries which are never deleted), we need to
ensure that higher layers are sane, because if they aren't, it's garbage
in, garbage out.

For example, if we add a bridge FDB entry twice, the bridge properly
errors out:

$ bridge fdb add dev swp0 00:01:02:03:04:07 master static
$ bridge fdb add dev swp0 00:01:02:03:04:07 master static
RTNETLINK answers: File exists

However, the same thing cannot be said about the bridge bypass
operations:

$ bridge fdb add dev swp0 00:01:02:03:04:07
$ bridge fdb add dev swp0 00:01:02:03:04:07
$ bridge fdb add dev swp0 00:01:02:03:04:07
$ bridge fdb add dev swp0 00:01:02:03:04:07
$ echo $?
0

But one 'bridge fdb del' is enough to remove the entry, no matter how
many times it was added.

The bridge bypass operations are impossible to maintain in these
circumstances and lack of support for reference counting the cross-chip
notifiers is holding us back from making further progress, so just drop
support for them. The only way left for users to install static bridge
FDB entries is the proper one, using the "master static" flags.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 23 -----------------------
 1 file changed, 23 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 898ed9cf756f..64acb1e11cd7 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1651,27 +1651,6 @@ static const struct ethtool_ops dsa_slave_ethtool_ops = {
 	.self_test		= dsa_slave_net_selftest,
 };
 
-/* legacy way, bypassing the bridge *****************************************/
-static int dsa_legacy_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
-			      struct net_device *dev,
-			      const unsigned char *addr, u16 vid,
-			      u16 flags,
-			      struct netlink_ext_ack *extack)
-{
-	struct dsa_port *dp = dsa_slave_to_port(dev);
-
-	return dsa_port_fdb_add(dp, addr, vid);
-}
-
-static int dsa_legacy_fdb_del(struct ndmsg *ndm, struct nlattr *tb[],
-			      struct net_device *dev,
-			      const unsigned char *addr, u16 vid)
-{
-	struct dsa_port *dp = dsa_slave_to_port(dev);
-
-	return dsa_port_fdb_del(dp, addr, vid);
-}
-
 static struct devlink_port *dsa_slave_get_devlink_port(struct net_device *dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
@@ -1713,8 +1692,6 @@ static const struct net_device_ops dsa_slave_netdev_ops = {
 	.ndo_change_rx_flags	= dsa_slave_change_rx_flags,
 	.ndo_set_rx_mode	= dsa_slave_set_rx_mode,
 	.ndo_set_mac_address	= dsa_slave_set_mac_address,
-	.ndo_fdb_add		= dsa_legacy_fdb_add,
-	.ndo_fdb_del		= dsa_legacy_fdb_del,
 	.ndo_fdb_dump		= dsa_slave_fdb_dump,
 	.ndo_do_ioctl		= dsa_slave_ioctl,
 	.ndo_get_iflink		= dsa_slave_get_iflink,
-- 
2.25.1

