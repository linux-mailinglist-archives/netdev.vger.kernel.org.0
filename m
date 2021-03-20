Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86DDF342FF6
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 23:39:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbhCTWf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 18:35:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbhCTWf0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 18:35:26 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6D1FC061574;
        Sat, 20 Mar 2021 15:35:25 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a7so15286005ejs.3;
        Sat, 20 Mar 2021 15:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uoAitKxY6Wm3fAUsNhRpFwI+ektVXceRmnN56H84oYw=;
        b=TwxUm1ebl6brytJbAJCTLrZWGI266T/DszMJZ+5RUe9AgtE+WcoclaxTaz9cJKJUEQ
         7+8JQfQOgglsCk77eP7Qjx0u2e0MYjtFxrqWki6WFIu/RTIsME6MMdtI124da56OA/at
         Gf7HkRUmjmphUs0jdlayZQA+HSJsSyTV5KydjCxerJgGoQdSwJj+kjwxOc7trxWkhsSh
         B/nnUdFyEDMpcklyp19QGSR8otPGUgiMpV/Z5Nv4xXh8E1YEPeopXsGFf2ePm9N3ioMi
         rJgtB7BiMG0M7FSjT+aTXIy2eUAtl1U6N1LCQYpjkCwZffsI2NYLz4d9ztqYnStvYwz1
         9anw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uoAitKxY6Wm3fAUsNhRpFwI+ektVXceRmnN56H84oYw=;
        b=mS1uFO/ban3bvmgtT2S9/f0EH1hyweJyxVBiO69SDG2Nvuywp9Ld1E27Lzygbwdj2X
         5UKtEMM1kBu6UEzIBgHZ660cqS0W7WtgRx2SvTw8shb/UuwbBdrm8oCZFYyDeysMuHqd
         FActButYZ1DOGeb4DP3QbG8orf8PHkre/CI5errEC5jya0mGadbDNb/kwNrzh05d/gDv
         OWhjlT2AABI1eH0PnSYCzlNCu53XvR3d47k4lssIN3V0j1aGdk04ijDJJbEcqeZc4qfP
         lE2MCSpCZKRcq6NKUCk5hFd/9dXIgDzrRNDCAtMe4MRQzzwjfSxOw2G0BbigtZ3OgGFj
         kkxA==
X-Gm-Message-State: AOAM532RLpLY+Fa4asEMROzvLjp0BYrLlaXSfn3wUOod9GHj2wYNPknV
        aSvrP9UldgEG7YQCJCUPUsc=
X-Google-Smtp-Source: ABdhPJwZ+qANVk5Dz01q9updiuAD0xK8qCumTxArrh9EmyN1EUfBkR2yHqXYQ/9I4uqAYnwYdgv7gg==
X-Received: by 2002:a17:906:a3d1:: with SMTP id ca17mr11728884ejb.92.1616279724641;
        Sat, 20 Mar 2021 15:35:24 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id n2sm6090850ejl.1.2021.03.20.15.35.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Mar 2021 15:35:24 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Ivan Vecera <ivecera@redhat.com>,
        linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v3 net-next 04/12] net: dsa: sync up with bridge port's STP state when joining
Date:   Sun, 21 Mar 2021 00:34:40 +0200
Message-Id: <20210320223448.2452869-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210320223448.2452869-1-olteanv@gmail.com>
References: <20210320223448.2452869-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

It may happen that we have the following topology:

ip link add br0 type bridge stp_state 1
ip link add bond0 type bond
ip link set bond0 master br0
ip link set swp0 master bond0
ip link set swp1 master bond0

STP decides that it should put bond0 into the BLOCKING state, and
that's that. The ports that are actively listening for the switchdev
port attributes emitted for the bond0 bridge port (because they are
offloading it) and have the honor of seeing that switchdev port
attribute can react to it, so we can program swp0 and swp1 into the
BLOCKING state.

But if then we do:

ip link set swp2 master bond0

then as far as the bridge is concerned, nothing has changed: it still
has one bridge port. But this new bridge port will not see any STP state
change notification and will remain FORWARDING, which is how the
standalone code leaves it in.

Add a function to the bridge which retrieves the current STP state, such
that drivers can synchronize to it when they may have missed switchdev
events.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v3:
None.

 include/linux/if_bridge.h |  6 ++++++
 net/bridge/br_stp.c       | 14 ++++++++++++++
 net/dsa/port.c            |  7 +++++++
 3 files changed, 27 insertions(+)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index b979005ea39c..920d3a02cc68 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -136,6 +136,7 @@ struct net_device *br_fdb_find_port(const struct net_device *br_dev,
 				    __u16 vid);
 void br_fdb_clear_offload(const struct net_device *dev, u16 vid);
 bool br_port_flag_is_set(const struct net_device *dev, unsigned long flag);
+u8 br_port_get_stp_state(const struct net_device *dev);
 #else
 static inline struct net_device *
 br_fdb_find_port(const struct net_device *br_dev,
@@ -154,6 +155,11 @@ br_port_flag_is_set(const struct net_device *dev, unsigned long flag)
 {
 	return false;
 }
+
+static inline u8 br_port_get_stp_state(const struct net_device *dev)
+{
+	return BR_STATE_DISABLED;
+}
 #endif
 
 #endif
diff --git a/net/bridge/br_stp.c b/net/bridge/br_stp.c
index 21c6781906aa..86b5e05d3f21 100644
--- a/net/bridge/br_stp.c
+++ b/net/bridge/br_stp.c
@@ -64,6 +64,20 @@ void br_set_state(struct net_bridge_port *p, unsigned int state)
 	}
 }
 
+u8 br_port_get_stp_state(const struct net_device *dev)
+{
+	struct net_bridge_port *p;
+
+	ASSERT_RTNL();
+
+	p = br_port_get_rtnl(dev);
+	if (!p)
+		return BR_STATE_DISABLED;
+
+	return p->state;
+}
+EXPORT_SYMBOL_GPL(br_port_get_stp_state);
+
 /* called under bridge lock */
 struct net_bridge_port *br_get_port(struct net_bridge *br, u16 port_no)
 {
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 8dbc6e0db30c..2ecdc824ea66 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -171,12 +171,19 @@ static void dsa_port_clear_brport_flags(struct dsa_port *dp,
 static int dsa_port_switchdev_sync(struct dsa_port *dp,
 				   struct netlink_ext_ack *extack)
 {
+	struct net_device *brport_dev = dsa_port_to_bridge_port(dp);
+	u8 stp_state;
 	int err;
 
 	err = dsa_port_inherit_brport_flags(dp, extack);
 	if (err)
 		return err;
 
+	stp_state = br_port_get_stp_state(brport_dev);
+	err = dsa_port_set_state(dp, stp_state);
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
 	return 0;
 }
 
-- 
2.25.1

