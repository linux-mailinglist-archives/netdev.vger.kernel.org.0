Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9128345351
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 00:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbhCVXwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 19:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbhCVXwE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 19:52:04 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B29AAC061574;
        Mon, 22 Mar 2021 16:52:03 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id e14so5901145ejz.11;
        Mon, 22 Mar 2021 16:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L7PBrxdFzG5KWaT2YGxWxyTgtqiT9AsP2MOM/CZw2Kc=;
        b=EcBL83arcK1GO3xEPgn7I5IcApcX1+zfJrZtvAwiaucbwBijf1UThCuuO3PQnDYlh9
         It0BlO6djDlSt8f1ygvtm/PboT4K1lgZwd70E4PPiH9zF7PM0Qy1FX/Eg7AEm0loVlRX
         JpyTBLGunH1SrFrEEfjCUzVlr46tC4XPswgaB7eqhz2aOb6X3WjJSDdyZ2egTNwyCIAB
         WY9kyrZcc7/0gdwMGuJ7IEVQ7F5cuCUergEJJnr5c4iKKvE8y/W7B0m6lt2pKd1PGgpp
         mn+eb/ti1iO/ElOm853UoeR50sx7kVKokeCS1Em+usd/bWSYU4Ib+WMWmIlxMrafF7kk
         wxgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L7PBrxdFzG5KWaT2YGxWxyTgtqiT9AsP2MOM/CZw2Kc=;
        b=k3MxisBT3cH5S1Q0pa6rjhfeq5EMcsyNEBS8Zjic3Nwop5eFcf74QlT7//PYmpFmZu
         UxRKIBaLXSeaS1pIFLBc6s1fIZ4nZCntfYJ/+sDWZ72XXgFVcwCzpctctxfCBMR6MPmV
         UEBF9PIHQiEK7oNRB3SOkCXdd0N1rlylQHzN/McdsDK8m34O2od2Y/XOc6jzep2Pq4vx
         YgNiFM6n4nAhjQaHyOV1JLu/y8kbg8uTNro8vYdMCyxS/rA0PfvoxClSsMP+EeKqzh6O
         mjmnVRHz7RixD4bgxuNMyZeEaiC39lpLra0I96N8dhOS5hJrxQ6f1D2+dxalT+4E6S5G
         ZMcQ==
X-Gm-Message-State: AOAM532OL330XgCTINil+/F34335eb3aOAVFPR7SClXh5OFwDRVPbefq
        uxsPlBJqRvl46AAQMND+D4w=
X-Google-Smtp-Source: ABdhPJw0/mDX5Q8Eq8XYR6523kJWaNX2nu8y9A5/IX+NRS+RsqYIpTXbF1tayuBjWULEA9Fh1brN4Q==
X-Received: by 2002:a17:906:fcc7:: with SMTP id qx7mr2170563ejb.486.1616457122482;
        Mon, 22 Mar 2021 16:52:02 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id q16sm12436933edv.61.2021.03.22.16.52.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 16:52:02 -0700 (PDT)
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
Subject: [PATCH v4 net-next 01/11] net: bridge: add helper for retrieving the current bridge port STP state
Date:   Tue, 23 Mar 2021 01:51:42 +0200
Message-Id: <20210322235152.268695-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210322235152.268695-1-olteanv@gmail.com>
References: <20210322235152.268695-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

It may happen that we have the following topology with DSA or any other
switchdev driver with LAG offload:

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

We need a function in the bridge driver which retrieves the current STP
state, such that drivers can synchronize to it when they may have missed
switchdev events.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 include/linux/if_bridge.h |  6 ++++++
 net/bridge/br_stp.c       | 14 ++++++++++++++
 2 files changed, 20 insertions(+)

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
-- 
2.25.1

