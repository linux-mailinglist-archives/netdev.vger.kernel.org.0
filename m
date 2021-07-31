Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAD133DC7DC
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 21:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbhGaTKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Jul 2021 15:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230519AbhGaTKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Jul 2021 15:10:48 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB5BEC06175F;
        Sat, 31 Jul 2021 12:10:40 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id a14so12829050ila.1;
        Sat, 31 Jul 2021 12:10:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pf4e5z5kl4gOi9zuOWFB+34JLJ0QdGJxH+6mOqzI7vc=;
        b=PcNVaAbr7KAwYQe5hrR9XTZqJAi2liNH9G8jC06hqnvgGaGL43hxSDwkdsA++PfYFs
         OxLymYJgp12fVQSJF9i2aJVU9f4Emb+2Ypt9KWbvfmLwniEXYAprV6NxDmO6XhAzvuiy
         AC0nvZZq3WY+NJuGp3sPZUkgqItUOMeaTkKwAg6yf8fndduHSAct0h9qeoWAsvgm/Mys
         /xKyafcY7okuKHxq0fkerC73AdAGOc7aYOGz1ZoDRBUGveb02q+bcskvmtRWYsybHg3b
         JWZ3TlfZPgGHogWbatylwXgyBdiDbRhWyrxP6rGsQJeFTKGaqYDIPQHu+mhXmAyF/FXl
         Hj8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pf4e5z5kl4gOi9zuOWFB+34JLJ0QdGJxH+6mOqzI7vc=;
        b=FGx/zM9OP680ilJiyViksXH8NrV9zJAQU6vapsww79xpx24G6qmOmqoiluEgT9ZN2h
         ODh/8w/bd1ZUe6X0KdvgePD2nGe6VyZrAz7V6Wlca05p0+7goN0JC2a1ZdvrO8wev/6b
         6ZOnOu/DtRZZ7HobLt3byu0/1fL35nTj20osE4GIqlxOQvFvWsDvEQIH3PI4XIqRphtM
         NSircOZjUlJuAdITqWByzlwpmUrms3qRGTUqmfOl1i9DlaWyhWrpWkr4TYAQR7kYBz3x
         XWP93pQwzvxuFNdbLXkzX8CRuSX20VmrOyobC2ou5iTQgLQM6dFXRdKVF8U+u6EgCCdA
         klHw==
X-Gm-Message-State: AOAM532A5PFablyemSk2FiDJd8blxVsWkfx4UyCyd6qOX3kaKZjALpx9
        NBFFIPWxbeadBvLlVfTIbqw=
X-Google-Smtp-Source: ABdhPJxRzTveHTn181cO1yF+Rq5/FwFKIgU//FZUL2XfeKtbjr65COP8BnBc5y0Atptr1FbGNrrjDg==
X-Received: by 2002:a92:ab0a:: with SMTP id v10mr223601ilh.17.1627758640338;
        Sat, 31 Jul 2021 12:10:40 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id g1sm2837991ilq.13.2021.07.31.12.10.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Jul 2021 12:10:39 -0700 (PDT)
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
        Frank Wunderlich <frank-w@public-files.de>
Subject: [RFC net-next v2 1/4] net: dsa: mt7530: enable assisted learning on CPU port
Date:   Sun,  1 Aug 2021 03:10:19 +0800
Message-Id: <20210731191023.1329446-2-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210731191023.1329446-1-dqfext@gmail.com>
References: <20210731191023.1329446-1-dqfext@gmail.com>
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
---
 drivers/net/dsa/mt7530.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 69f21b71614c..7e7e0a35e351 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2054,6 +2054,7 @@ mt7530_setup(struct dsa_switch *ds)
 	 * as two netdev instances.
 	 */
 	dn = dsa_to_port(ds, MT7530_CPU_PORT)->master->dev.of_node->parent;
+	ds->assisted_learning_on_cpu_port = true;
 	ds->mtu_enforcement_ingress = true;
 
 	if (priv->id == ID_MT7530) {
@@ -2124,15 +2125,15 @@ mt7530_setup(struct dsa_switch *ds)
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
@@ -2289,6 +2290,9 @@ mt7531_setup(struct dsa_switch *ds)
 		mt7530_rmw(priv, MT7530_PCR_P(i), PCR_MATRIX_MASK,
 			   PCR_MATRIX_CLR);
 
+		/* Disable learning by default on all ports */
+		mt7530_set(priv, MT7530_PSC_P(i), SA_DIS);
+
 		mt7530_set(priv, MT7531_DBG_CNT(i), MT7531_DIS_CLR);
 
 		if (dsa_is_cpu_port(ds, i)) {
@@ -2297,9 +2301,6 @@ mt7531_setup(struct dsa_switch *ds)
 				return ret;
 		} else {
 			mt7530_port_disable(ds, i);
-
-			/* Disable learning by default on all user ports */
-			mt7530_set(priv, MT7530_PSC_P(i), SA_DIS);
 		}
 
 		/* Enable consistent egress tag */
@@ -2307,6 +2308,7 @@ mt7531_setup(struct dsa_switch *ds)
 			   PVC_EG_TAG(MT7530_VLAN_EG_CONSISTENT));
 	}
 
+	ds->assisted_learning_on_cpu_port = true;
 	ds->mtu_enforcement_ingress = true;
 
 	/* Flush the FDB table */
-- 
2.25.1

