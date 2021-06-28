Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3E073B6AAD
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 00:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236640AbhF1WDU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 18:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236853AbhF1WDG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 18:03:06 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94FD8C061768
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 15:00:38 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id yy20so24746019ejb.6
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 15:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BdAkYnE5Kq9sdISL/FbJdDE43qotZgnmTzLnBMhqPMU=;
        b=Ha7y8l7sMxOBxM6O6l9H5YVpXZIXpvrTAtCYq7znoMq1gyo7h+YDwqnCosjfTzYOWy
         /VEDrckG77xglA5sBqRIUiaGowLT5NhQReDMvLU82tRgYN5pKoyART9vm9IsTlMTaqYR
         5l9EPB+XqqsI4GgourJwuwrg3seq/q6Jh7gheRuusXbh2vmotKlRQCUhc90zkyL0cbCo
         0fxqwNpPZZsXbmA9Vd7K17GFfF/6TMxk1MwhQZWEDEuBWEmE9Bz4HLTZmGeG5oMRypaS
         P9gQw02D7SDPrqAiR2QJ78JcViZ8WsWSWwRB0iEExKBq+EV7DTXS5uWc4XZ8ceX/4+gC
         MKoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BdAkYnE5Kq9sdISL/FbJdDE43qotZgnmTzLnBMhqPMU=;
        b=Cqc69WR4XkpAEgFWC2Lp34Z5p13yK2ql2Zr27NAjRMFinBfAMWk0l3s13aNEHbWkvB
         xeBWACAdLJJZFbY0NGxcJ84Xv24EG1+MGkbucaxMqVJSljVr5Oibvu0S7IvklNJWSdlt
         wppqQXrAi1qeKuWcc7lNzKEAKAfYdd1wN2TsLBMZ/afc/8Tpv3Q+1gyL+dFvrLtgqaNS
         sEkFeFhZw5gwG1u3o5lTa5kJBO1wECu2aSz8tbdNc9ho2Qrx3h8OeZ2tjYYX+9BOFOe0
         rfpdCqXCWCpMt/YM2zUYEz/UUCgdtmytOpeeSSIchnFMQq9IRqA4MVHUQfjGDl8o45Fe
         fC0A==
X-Gm-Message-State: AOAM530xX9QTCkn81lwdRsElbcKr/vtYRMP0N0cYnY60W/zmMq6fZTPo
        RyhG7AODnQcxC/FyVnOzZqMZjKep6zs=
X-Google-Smtp-Source: ABdhPJzMNbR2UCAX4vyJZze9q+3zcNlzO8r353rrh3GU1D23KQFOLlMnsLovf/p4DbI+dqDZQTnL6g==
X-Received: by 2002:a17:906:64c8:: with SMTP id p8mr25684368ejn.428.1624917637243;
        Mon, 28 Jun 2021 15:00:37 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id dn7sm10146615edb.29.2021.06.28.15.00.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 15:00:36 -0700 (PDT)
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
Subject: [PATCH v4 net-next 03/14] net: dsa: delete dsa_legacy_fdb_add and dsa_legacy_fdb_del
Date:   Tue, 29 Jun 2021 01:00:00 +0300
Message-Id: <20210628220011.1910096-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210628220011.1910096-1-olteanv@gmail.com>
References: <20210628220011.1910096-1-olteanv@gmail.com>
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

With this change, rtnl_fdb_add() falls back to calling
ndo_dflt_fdb_add() which uses the duplicate-exclusive variant of
dev_uc_add(): dev_uc_add_excl(). Because DSA does not (yet) declare
IFF_UNICAST_FLT, this results in us going to promiscuous mode:

$ bridge fdb add dev swp0 00:01:02:03:04:05
[   28.206743] device swp0 entered promiscuous mode
$ bridge fdb add dev swp0 00:01:02:03:04:05
RTNETLINK answers: File exists

So even if it does not completely fail, there is at least some indication
that it is behaving differently from before, and closer to user space
expectations, I would argue (the lack of a "local|static" specifier
defaults to "local", or "host-only", so dev_uc_add() is a reasonable
default implementation). If the generic implementation of .ndo_fdb_add
provided by Vlad Yasevich is a proof of anything, it only proves that
the implementation provided by DSA was always wrong, by not looking at
"ndm->ndm_state & NUD_NOARP" (the "static" flag which means that the FDB
entry points outwards) and "ndm->ndm_state & NUD_PERMANENT" (the "local"
flag which means that the FDB entry points towards the host). It all
used to mean the same thing to DSA.

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

