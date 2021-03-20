Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34BB8343003
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 23:39:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbhCTWgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 18:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbhCTWfa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 18:35:30 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E313C061574;
        Sat, 20 Mar 2021 15:35:29 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id w3so15294214ejc.4;
        Sat, 20 Mar 2021 15:35:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+w2V4CrXrr28bS/NRzU+Y8EJ/yXppRLpxb1GjTO73/I=;
        b=iphxnX1ZrOLj5/YdIZ0aKTSnUEeubyNIZ4hZHfDFzhEJ9qqzB35qJOq3ZseWdtRjqD
         NPS+gyUYgOH5T4bVAtHHzeGndNJxEu2wxtHKxMC9AuhrTtFZ9k0ERQ1oACRsH47lrOSK
         aOs/DZu9mYMsMVs4EQOfUXSfVRILJi6StlnJICXUXZNp5MjCbYCgXLuZtArq5Azngoq4
         WYEb0Ck4WJA1ht6JmaHlGudFmgVOUO8EJBweobneuT3/OCHQya0umNNQ3KnuuTbN5F+A
         T4qaqkRd4YORnQV3zxPl+WsDzhbRf9nCPwtTM1wa3DVSUMzsAkETjqkXTHorF/LjPBFa
         cU+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+w2V4CrXrr28bS/NRzU+Y8EJ/yXppRLpxb1GjTO73/I=;
        b=LeKXuQrmUHfVvY6fx01dltZrHPN9A+YGDP7vN94LPT0ZcNtWFvfD1F5tygC9qSWzZ3
         59YMYt2crCxLzg6oaeWnHrMqe7ZPtkjNxJ4GggnTVv5VrREZa7M5vFvi7L4DGnM8UsoX
         QmZa7c8LhkiHD+Q4uHYm5/h/7nGn+rHj4wiYDvoLwvyTwAxn042NG6+tE0VQM//Nozk2
         tEphBjc2ktQy5DyMzCMFFNh0b/0TrPEeOSyg1UdFoF8MnJS74ocv3PI/EWOrWTeAy2p8
         flMfbIlayfAMS01mDKEdZQhzuceV5fnMnhpM+A8VRgWeMgBooJRmP6JjTDYgOuIlrluE
         5RiQ==
X-Gm-Message-State: AOAM532BZut2+H4f5fWpCii1RwifC2TfGeM1TOpn6jmDSZoGvLyqo0Ee
        2oM7L6CF8wB7/SQZUhCA2kA=
X-Google-Smtp-Source: ABdhPJw5s5cjzrjbNOKfNNzuyHbiBwu6TiIvMhrfInX/00aZJWlYvRChC+pCJuwb+oOoBDrRKsaUgg==
X-Received: by 2002:a17:906:a413:: with SMTP id l19mr11676480ejz.421.1616279728454;
        Sat, 20 Mar 2021 15:35:28 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id n2sm6090850ejl.1.2021.03.20.15.35.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Mar 2021 15:35:28 -0700 (PDT)
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
Subject: [PATCH v3 net-next 07/12] net: dsa: sync ageing time when joining the bridge
Date:   Sun, 21 Mar 2021 00:34:43 +0200
Message-Id: <20210320223448.2452869-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210320223448.2452869-1-olteanv@gmail.com>
References: <20210320223448.2452869-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The SWITCHDEV_ATTR_ID_BRIDGE_AGEING_TIME attribute is only emitted from:

sysfs/ioctl/netlink
-> br_set_ageing_time
   -> __set_ageing_time

therefore not at bridge port creation time, so:
(a) drivers had to hardcode the initial value for the address ageing time,
    because they didn't get any notification
(b) that hardcoded value can be out of sync, if the user changes the
    ageing time before enslaving the port to the bridge

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
None.

 include/linux/if_bridge.h |  6 ++++++
 net/bridge/br_stp.c       | 13 +++++++++++++
 net/dsa/port.c            | 10 ++++++++++
 3 files changed, 29 insertions(+)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index 920d3a02cc68..ebd16495459c 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -137,6 +137,7 @@ struct net_device *br_fdb_find_port(const struct net_device *br_dev,
 void br_fdb_clear_offload(const struct net_device *dev, u16 vid);
 bool br_port_flag_is_set(const struct net_device *dev, unsigned long flag);
 u8 br_port_get_stp_state(const struct net_device *dev);
+clock_t br_get_ageing_time(struct net_device *br_dev);
 #else
 static inline struct net_device *
 br_fdb_find_port(const struct net_device *br_dev,
@@ -160,6 +161,11 @@ static inline u8 br_port_get_stp_state(const struct net_device *dev)
 {
 	return BR_STATE_DISABLED;
 }
+
+static inline clock_t br_get_ageing_time(struct net_device *br_dev)
+{
+	return 0;
+}
 #endif
 
 #endif
diff --git a/net/bridge/br_stp.c b/net/bridge/br_stp.c
index 86b5e05d3f21..3dafb6143cff 100644
--- a/net/bridge/br_stp.c
+++ b/net/bridge/br_stp.c
@@ -639,6 +639,19 @@ int br_set_ageing_time(struct net_bridge *br, clock_t ageing_time)
 	return 0;
 }
 
+clock_t br_get_ageing_time(struct net_device *br_dev)
+{
+	struct net_bridge *br;
+
+	if (!netif_is_bridge_master(br_dev))
+		return 0;
+
+	br = netdev_priv(br_dev);
+
+	return jiffies_to_clock_t(br->ageing_time);
+}
+EXPORT_SYMBOL_GPL(br_get_ageing_time);
+
 /* called under bridge lock */
 void __br_set_topology_change(struct net_bridge *br, unsigned char val)
 {
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 124f8bb21204..95e6f2861290 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -173,6 +173,7 @@ static int dsa_port_switchdev_sync(struct dsa_port *dp,
 {
 	struct net_device *brport_dev = dsa_port_to_bridge_port(dp);
 	struct net_device *br = dp->bridge_dev;
+	clock_t ageing_time;
 	u8 stp_state;
 	int err;
 
@@ -193,6 +194,11 @@ static int dsa_port_switchdev_sync(struct dsa_port *dp,
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
+	ageing_time = br_get_ageing_time(br);
+	err = dsa_port_ageing_time(dp, ageing_time);
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
 	return 0;
 }
 
@@ -222,6 +228,10 @@ static void dsa_port_switchdev_unsync(struct dsa_port *dp)
 	 * allow this in standalone mode too.
 	 */
 	dsa_port_mrouter(dp->cpu_dp, true, NULL);
+
+	/* Ageing time may be global to the switch chip, so don't change it
+	 * here because we have no good reason (or value) to change it to.
+	 */
 }
 
 int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
-- 
2.25.1

