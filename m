Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DAC04DB46C
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 16:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357128AbiCPPLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 11:11:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356988AbiCPPLD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 11:11:03 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C66EB673F2
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 08:09:17 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id bn33so3536807ljb.6
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 08:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=GnM2vWwSx2i5cE2iNl+NO2cDrpNSR+FaAqPVnKFkrgM=;
        b=uyhfrzP7w9DjuBUBI2RL71VgIXkwbG6IgUN2y0ZJe7zvgp8IWsL1bDwgVyCDnoTfZ9
         CHQA4UL9uMDbL2tZOAVJGcMjd3ekQIITSByP5SF129hYTSMLHsapZA8uro58+w3svgBx
         51EtxzdMy9jSYcZv3YxmR9oMMdHCWHVUXbJw7lXaeDdfO+VUJnkA3GUlXevzhv1TM593
         m9RFo1iNJo/OXZQxmkIvpd+zic1FlIbILxF5UVF06rgyMCg1ah8dZ3nBmQMsZM8cION6
         onopmBEBmOr45EaQ1P9TlgmsjTmQ2K6WVeufmzgSglCsjZ39R0Lr+/TS6pyzGMMCD4wQ
         N9Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=GnM2vWwSx2i5cE2iNl+NO2cDrpNSR+FaAqPVnKFkrgM=;
        b=bNcNUQA75zmElRxcnQRDGBfTiGnPbxgkdlXsK11VLr7o5GgJeX3vdNEXsVJoZFk+wi
         NMcZAv4HeE/7dw6wALeF4yST11P9Z8yQnqFypTic88IGvIouA6T8ZiG7E8IB+bnNeX2z
         3TbF5zhhm8SK9mdXw5h1cZgzWSKvhreODyzVvWRxg6pLxPrd4Td7h8yf7caks82iPS15
         FT4yuy1id67n12AfB13zxoBSX/9EBbjJVIYErMkqYBvfJ2hdwIWBPJ387wrFUI0UOW/p
         SqYO0tZ2oBA4q6QmHLRd2roThXQsziHTrnw77jLgCS3iqS2KPkOFIaJ50QN/D7zD4mMG
         QXEA==
X-Gm-Message-State: AOAM532gcrokLDnXoFi2mj/XP+QxG3wDVB6bjE3K+InrtV6w8C3PtE0g
        aTvvgon/v+PQSi0dunVHrPJYQQ==
X-Google-Smtp-Source: ABdhPJzbOI3RF2Lo7DsoZn4bCh3kZRgGrUgW3rYJ0m0cbZOwnF6t9JI4yZfGQL5uXPcjR1fXubPKKw==
X-Received: by 2002:a2e:a584:0:b0:249:1463:cb84 with SMTP id m4-20020a2ea584000000b002491463cb84mr45535ljp.231.1647443355643;
        Wed, 16 Mar 2022 08:09:15 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id d2-20020a194f02000000b00448b915e2d3sm176048lfb.99.2022.03.16.08.09.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 08:09:15 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        Cooper Lees <me@cooperlees.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: [PATCH v5 net-next 09/15] net: bridge: mst: Add helper to query a port's MST state
Date:   Wed, 16 Mar 2022 16:08:51 +0100
Message-Id: <20220316150857.2442916-10-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220316150857.2442916-1-tobias@waldekranz.com>
References: <20220316150857.2442916-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is useful for switchdev drivers who are offloading MST states
into hardware. As an example, a driver may wish to flush the FDB for a
port when it transitions from forwarding to blocking - which means
that the previous state must be discoverable.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 include/linux/if_bridge.h |  6 ++++++
 net/bridge/br_mst.c       | 25 +++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index 4efd5540279a..d62ef428e3aa 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -121,6 +121,7 @@ int br_vlan_get_info_rcu(const struct net_device *dev, u16 vid,
 			 struct bridge_vlan_info *p_vinfo);
 bool br_mst_enabled(const struct net_device *dev);
 int br_mst_get_info(const struct net_device *dev, u16 msti, unsigned long *vids);
+int br_mst_get_state(const struct net_device *dev, u16 msti, u8 *state);
 #else
 static inline bool br_vlan_enabled(const struct net_device *dev)
 {
@@ -164,6 +165,11 @@ static inline int br_mst_get_info(const struct net_device *dev, u16 msti,
 {
 	return -EINVAL;
 }
+static inline int br_mst_get_state(const struct net_device *dev, u16 msti,
+				   u8 *state)
+{
+	return -EINVAL;
+}
 #endif
 
 #if IS_ENABLED(CONFIG_BRIDGE)
diff --git a/net/bridge/br_mst.c b/net/bridge/br_mst.c
index 830a5746479f..ee680adcee17 100644
--- a/net/bridge/br_mst.c
+++ b/net/bridge/br_mst.c
@@ -48,6 +48,31 @@ int br_mst_get_info(const struct net_device *dev, u16 msti, unsigned long *vids)
 }
 EXPORT_SYMBOL_GPL(br_mst_get_info);
 
+int br_mst_get_state(const struct net_device *dev, u16 msti, u8 *state)
+{
+	const struct net_bridge_port *p = NULL;
+	const struct net_bridge_vlan_group *vg;
+	const struct net_bridge_vlan *v;
+
+	ASSERT_RTNL();
+
+	p = br_port_get_check_rtnl(dev);
+	if (!p || !br_opt_get(p->br, BROPT_MST_ENABLED))
+		return -EINVAL;
+
+	vg = nbp_vlan_group(p);
+
+	list_for_each_entry(v, &vg->vlan_list, vlist) {
+		if (v->brvlan->msti == msti) {
+			*state = v->state;
+			return 0;
+		}
+	}
+
+	return -ENOENT;
+}
+EXPORT_SYMBOL_GPL(br_mst_get_state);
+
 static void br_mst_vlan_set_state(struct net_bridge_port *p, struct net_bridge_vlan *v,
 				  u8 state)
 {
-- 
2.25.1

