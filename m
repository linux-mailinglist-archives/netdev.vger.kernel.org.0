Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A76D3DEDFC
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 14:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236047AbhHCMkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 08:40:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236004AbhHCMkt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 08:40:49 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B602C061764;
        Tue,  3 Aug 2021 05:40:38 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id a20so23621834plm.0;
        Tue, 03 Aug 2021 05:40:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v/4BONrSOBizGoNEGmYr7gQHytyhSTdcu/YS8W1W0Yg=;
        b=U60ASrWzo2CxTUtUrtkvxqko0p3rw+Jy1Teurnr9z2qocwfsOEBT3f2k7yBm+wLiFx
         hpiOHGhKD1gf0hYyjTROX6BTyLZtPUwqolhfPx7QsjvADx6fdkUFI6cPyIxTqpseGq7L
         jS1h0tN574jRu5UrQ6O1mx7nzWOLGMS1ol+MubKsz2J/ScQqA6I38ffK11oHbx5OqIIO
         VN1YZ0GoirNjVqx1cgPifmafdJS6E2sDoyrm2aRf0fS8oawhKqrzkfslLglkNdJDdI+/
         ZWiT0Bjn+MTtQreRt5cSii6xVze2XjXCHzs+d0oy1O4CI+w7+s0FVb781S1YVVcunP7V
         exwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v/4BONrSOBizGoNEGmYr7gQHytyhSTdcu/YS8W1W0Yg=;
        b=n4uy+7WZlY0lVWc/9egbUKM3PHMMoP+D6xewqQj+VaUpH1GCJLsmJV5keaeeXaQmtj
         rSfQZT7MRlEFVl/NPoQ9o/hBpi0od2gUeHYpxfcScwMCSJb58JC0Ar3HpTbKnGHTaGOD
         gCPZjUHJ53XMRHSea4of9Opaz4GXJSMPLCJObkhTJv86W/RLmXgedwoVLyIae1XNWXgs
         cVajRH9DOYfJntAxzzEHEBEqwVcOBsgJpGShHo56Q5GZhTZom2w39GilK2WqOrHUoWdi
         F48M/0iKTJ5jL61Qwn/+etz0bPT89h7KLJfyIwMMAPHXjDxhQgYNjXq1yVuCw3qB7tbF
         hTKQ==
X-Gm-Message-State: AOAM531ZEoYimjtcvEh+ioev1JD+0mjFR7fQOdSU6Q535pxqeYLCjMDA
        IsRDFb317VMxx2zVq/F2d8g=
X-Google-Smtp-Source: ABdhPJzlRZxiHjRaX626SWcK6s9kRrCmhBb+zkxzEUKrSeaS4rwpEg1Bhk0nwO0PvGjvX0uIxk7T3w==
X-Received: by 2002:a17:90a:2f62:: with SMTP id s89mr4341247pjd.33.1627994437637;
        Tue, 03 Aug 2021 05:40:37 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id g25sm15747499pfk.138.2021.08.03.05.40.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 05:40:37 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Eric Woudstra <ericwouds@gmail.com>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Vladimir Oltean <oltean@gmail.com>
Subject: [PATCH net-next 1/4] net: dsa: mt7530: enable assisted learning on CPU port
Date:   Tue,  3 Aug 2021 20:40:19 +0800
Message-Id: <20210803124022.2912298-2-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210803124022.2912298-1-dqfext@gmail.com>
References: <20210803124022.2912298-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Consider the following bridge configuration, where bond0 is not
offloaded:

         +-- br0 --+
        / /   |     \
       / /    |      \
      /  |    |     bond0
     /   |    |     /   \
   swp0 swp1 swp2 swp3 swp4
     .        .       .
     .        .       .
     A        B       C

Address learning is enabled on offloaded ports (swp0~2) and the CPU
port, so when client A sends a packet to C, the following will happen:

1. The switch learns that client A can be reached at swp0.
2. The switch probably already knows that client C can be reached at the
   CPU port, so it forwards the packet to the CPU.
3. The bridge core knows client C can be reached at bond0, so it
   forwards the packet back to the switch.
4. The switch learns that client A can be reached at the CPU port.
5. The switch forwards the packet to either swp3 or swp4, according to
   the packet's tag.

That makes client A's MAC address flap between swp0 and the CPU port. If
client B sends a packet to A, it is possible that the packet is
forwarded to the CPU. With offload_fwd_mark = 1, the bridge core won't
forward it back to the switch, resulting in packet loss.

As we have the assisted_learning_on_cpu_port in DSA core now, enable
that and disable hardware learning on the CPU port.

Signed-off-by: DENG Qingfang <dqfext@gmail.com>
Reviewed-by: Vladimir Oltean <oltean@gmail.com>
---
RFC -> v1: no changes.

 drivers/net/dsa/mt7530.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index b6e0b347947e..abe57b04fc39 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2046,6 +2046,7 @@ mt7530_setup(struct dsa_switch *ds)
 	 * as two netdev instances.
 	 */
 	dn = dsa_to_port(ds, MT7530_CPU_PORT)->master->dev.of_node->parent;
+	ds->assisted_learning_on_cpu_port = true;
 	ds->mtu_enforcement_ingress = true;
 
 	if (priv->id == ID_MT7530) {
@@ -2116,15 +2117,15 @@ mt7530_setup(struct dsa_switch *ds)
 		mt7530_rmw(priv, MT7530_PCR_P(i), PCR_MATRIX_MASK,
 			   PCR_MATRIX_CLR);
 
+		/* Disable learning by default on all ports */
+		mt7530_set(priv, MT7530_PSC_P(i), SA_DIS);
+
 		if (dsa_is_cpu_port(ds, i)) {
 			ret = mt753x_cpu_port_enable(ds, i);
 			if (ret)
 				return ret;
 		} else {
 			mt7530_port_disable(ds, i);
-
-			/* Disable learning by default on all user ports */
-			mt7530_set(priv, MT7530_PSC_P(i), SA_DIS);
 		}
 		/* Enable consistent egress tag */
 		mt7530_rmw(priv, MT7530_PVC_P(i), PVC_EG_TAG_MASK,
@@ -2281,6 +2282,9 @@ mt7531_setup(struct dsa_switch *ds)
 		mt7530_rmw(priv, MT7530_PCR_P(i), PCR_MATRIX_MASK,
 			   PCR_MATRIX_CLR);
 
+		/* Disable learning by default on all ports */
+		mt7530_set(priv, MT7530_PSC_P(i), SA_DIS);
+
 		mt7530_set(priv, MT7531_DBG_CNT(i), MT7531_DIS_CLR);
 
 		if (dsa_is_cpu_port(ds, i)) {
@@ -2289,9 +2293,6 @@ mt7531_setup(struct dsa_switch *ds)
 				return ret;
 		} else {
 			mt7530_port_disable(ds, i);
-
-			/* Disable learning by default on all user ports */
-			mt7530_set(priv, MT7530_PSC_P(i), SA_DIS);
 		}
 
 		/* Enable consistent egress tag */
@@ -2299,6 +2300,7 @@ mt7531_setup(struct dsa_switch *ds)
 			   PVC_EG_TAG(MT7530_VLAN_EG_CONSISTENT));
 	}
 
+	ds->assisted_learning_on_cpu_port = true;
 	ds->mtu_enforcement_ingress = true;
 
 	/* Flush the FDB table */
-- 
2.25.1

