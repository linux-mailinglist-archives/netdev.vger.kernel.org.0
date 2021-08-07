Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 013AF3E353F
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 14:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232210AbhHGMIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 08:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232190AbhHGMIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Aug 2021 08:08:05 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F707C0613D3;
        Sat,  7 Aug 2021 05:07:47 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id u13-20020a17090abb0db0290177e1d9b3f7so26704939pjr.1;
        Sat, 07 Aug 2021 05:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0uAUIoE5JB2C9srWWQ8+N9NzyVb4/41rqs1bQEBbz3w=;
        b=jjzvsdhoFNB2jItyXltAKHcvm0jSXfZQoXcgCJJSIqnQ945vSaP+9z/dOyUYtfg+SE
         iOO9IbeIHNJ38MKRObzFaWk3eVfBWpPoT9qcpAwILiYnCT3eJ/OT7d2eQx4EOo+bqcSf
         Di6nVSFDoBmL/OJozK8vIldU1uzhF78x0NPPneB2p9JwSZrtlO6qnlFy+zvOQIj9hQIP
         mY99IJT1E0rWDcU1LP5t7dwPdhYa5o+1UIABXNjXm2zlp2Dk598cJEcjgeZyvor0Tv/t
         l4bKpmJL8nUwrkJZmZSM1c2oGxLU71dphJgdtjq4SKZHE7L+YAiHJvsnSK7nUDlhk7wn
         LdsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0uAUIoE5JB2C9srWWQ8+N9NzyVb4/41rqs1bQEBbz3w=;
        b=qE/70AQfv7wzfTtocRuO3kEmg9Uci5CHdwToqwQyx/PYgq6pEDGBhpcjxWnPUxluiD
         UWJ2oyZ7NepywfbdoZ/QKnoqk/QZ3t+9SIyHzRPRIVyEJxK/8QgEQCo/nZV4bZp8ELaA
         tiD4bNFeCn7FmmbBte/RdB5QB0t6WLz6tXigGVCNMUNaGsbKu2eJvv403itddtCFGt6j
         KA74Z08PiEV2pIWZwpQzHWq7kjoIljz3+n0vtHUBDy2piqir0QnvLEJbvmbV0GI70Rrf
         7IsvglC7l65+OLggXYENnRJnOnU8UkwAU1v2zAPp9rFOHLolO6w/YOlo5YZklecUdA4j
         Na4g==
X-Gm-Message-State: AOAM530kTLvc/PB6Er8whkJzBI8XkBqbtQrEzx1NQH1X0jf0NNgiNENB
        wfwMFcgwnV0frQXg9myBwzc=
X-Google-Smtp-Source: ABdhPJzrfUOyLkVPnV+tr6HYvoTFFXGmbtWLjKzwCZE5GIFiP3WAL1SoP64V/Eq50ChsmrKOTxBNog==
X-Received: by 2002:a17:90a:c286:: with SMTP id f6mr26177385pjt.121.1628338067063;
        Sat, 07 Aug 2021 05:07:47 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id b15sm16471035pgj.60.2021.08.07.05.07.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Aug 2021 05:07:46 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Jonathan McDowell <noodles@earth.li>,
        =?UTF-8?q?Michal=20Vok=C3=A1=C4=8D?= <vokac.m@gmail.com>,
        Christian Lamparter <chunkeey@gmail.com>,
        Nishka Dasgupta <nishkadg.linux@gmail.com>,
        Xiaofei Shen <xiaofeis@codeaurora.org>,
        John Crispin <john@phrozen.org>,
        Stefan Lippers-Hollmann <s.l-h@gmx.de>,
        Hannu Nyman <hannu.nyman@iki.fi>,
        Imran Khan <gururug@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Nick Lowe <nick.lowe@gmail.com>,
        =?UTF-8?q?Andr=C3=A9=20Valentin?= <avalentin@vmh.kalnet.hooya.de>
Subject: [RFC net-next 1/3] net: dsa: qca8k: offload bridge flags
Date:   Sat,  7 Aug 2021 20:07:24 +0800
Message-Id: <20210807120726.1063225-2-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210807120726.1063225-1-dqfext@gmail.com>
References: <20210807120726.1063225-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The hardware supports controlling per-port flooding and learning.
Do not enable learning by default, instead configure them in
.port_bridge_flags function.

Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
 drivers/net/dsa/qca8k.c | 60 +++++++++++++++++++++++++++++++++++------
 1 file changed, 52 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 1f63f50f73f1..798bc548e5b0 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -987,10 +987,11 @@ qca8k_setup(struct dsa_switch *ds)
 		return ret;
 	}
 
-	/* Disable forwarding by default on all ports */
+	/* Disable forwarding and learning by default on all ports */
 	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
 		ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(i),
-				QCA8K_PORT_LOOKUP_MEMBER, 0);
+				QCA8K_PORT_LOOKUP_MEMBER |
+				QCA8K_PORT_LOOKUP_LEARN, 0);
 		if (ret)
 			return ret;
 	}
@@ -1028,12 +1029,6 @@ qca8k_setup(struct dsa_switch *ds)
 			if (ret)
 				return ret;
 
-			/* Enable ARP Auto-learning by default */
-			ret = qca8k_reg_set(priv, QCA8K_PORT_LOOKUP_CTRL(i),
-					    QCA8K_PORT_LOOKUP_LEARN);
-			if (ret)
-				return ret;
-
 			/* For port based vlans to work we need to set the
 			 * default egress vid
 			 */
@@ -1504,6 +1499,53 @@ qca8k_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
 		  QCA8K_PORT_LOOKUP_STATE_MASK, stp_state);
 }
 
+static int
+qca8k_port_pre_bridge_flags(struct dsa_switch *ds, int port,
+			    struct switchdev_brport_flags flags,
+			    struct netlink_ext_ack *extack)
+{
+	if (flags.mask & ~(BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD |
+			   BR_BCAST_FLOOD))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int
+qca8k_port_bridge_flags(struct dsa_switch *ds, int port,
+			struct switchdev_brport_flags flags,
+			struct netlink_ext_ack *extack)
+{
+	struct qca8k_priv *priv = ds->priv;
+	int ret = 0;
+
+	if (!ret && flags.mask & BR_LEARNING)
+		ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
+				QCA8K_PORT_LOOKUP_LEARN,
+				flags.val & BR_LEARNING ?
+				QCA8K_PORT_LOOKUP_LEARN : 0);
+
+	if (!ret && flags.mask & BR_FLOOD)
+		ret = qca8k_rmw(priv, QCA8K_REG_GLOBAL_FW_CTRL1,
+				BIT(port + QCA8K_GLOBAL_FW_CTRL1_UC_DP_S),
+				flags.val & BR_FLOOD ?
+				BIT(port + QCA8K_GLOBAL_FW_CTRL1_UC_DP_S) : 0);
+
+	if (!ret && flags.mask & BR_MCAST_FLOOD)
+		ret = qca8k_rmw(priv, QCA8K_REG_GLOBAL_FW_CTRL1,
+				BIT(port + QCA8K_GLOBAL_FW_CTRL1_MC_DP_S),
+				flags.val & BR_MCAST_FLOOD ?
+				BIT(port + QCA8K_GLOBAL_FW_CTRL1_MC_DP_S) : 0);
+
+	if (!ret && flags.mask & BR_BCAST_FLOOD)
+		ret = qca8k_rmw(priv, QCA8K_REG_GLOBAL_FW_CTRL1,
+				BIT(port + QCA8K_GLOBAL_FW_CTRL1_BC_DP_S),
+				flags.val & BR_BCAST_FLOOD ?
+				BIT(port + QCA8K_GLOBAL_FW_CTRL1_BC_DP_S) : 0);
+
+	return ret;
+}
+
 static int
 qca8k_port_bridge_join(struct dsa_switch *ds, int port, struct net_device *br)
 {
@@ -1764,6 +1806,8 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
 	.port_change_mtu	= qca8k_port_change_mtu,
 	.port_max_mtu		= qca8k_port_max_mtu,
 	.port_stp_state_set	= qca8k_port_stp_state_set,
+	.port_pre_bridge_flags	= qca8k_port_pre_bridge_flags,
+	.port_bridge_flags	= qca8k_port_bridge_flags,
 	.port_bridge_join	= qca8k_port_bridge_join,
 	.port_bridge_leave	= qca8k_port_bridge_leave,
 	.port_fdb_add		= qca8k_port_fdb_add,
-- 
2.25.1

