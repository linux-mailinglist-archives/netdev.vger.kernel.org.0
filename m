Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A39863DF20C
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 18:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbhHCQEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 12:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231327AbhHCQEe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 12:04:34 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B948DC061757;
        Tue,  3 Aug 2021 09:04:23 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id g23-20020a17090a5797b02901765d605e14so5326759pji.5;
        Tue, 03 Aug 2021 09:04:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4DDzV8/Fk1hQnq24aZe35CXn12AVhJ1i/aTFMFKXbn4=;
        b=okNC+95eqklwvX4zzy4qD21U1kMduj63CtRXA06V5Amw8XOIBhmMIV94OVgWUE7CY8
         DSisxbhuSmUI8zFKabPhDSo0SRLOmEn2I1ZI+JMVQZyW8fTOaK/JnSPBjvjxz64A2OUs
         7vhlyD5d3InukEjdCv9uW9Z1zKdmIGdEnEIfUP7JKh+i3HM8Ir+KCn0JSJSWN+a+UcxR
         zhHMLBrXihkhTTLnw4Ul9Oym3uHDuhWwg3UtWxC53eOqCCpWBwWxRJ2D5WAY/Xosc74f
         x7w2eWKAyv+fjEeNurlAgsWi8juyXarv915JGKd6yeqwsVKSGSpgJgVtlV+kNdg3Wk83
         sMPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4DDzV8/Fk1hQnq24aZe35CXn12AVhJ1i/aTFMFKXbn4=;
        b=hfnufSEen/6Um5vOAcKARGrbONq/kVGZLliORpVUSC0lx+junRDTh3tSYH1C1JzS2A
         JTVDXwHc1arH9pDgcZIoYVsB3Tfl/EZItEKg0dPYGB8oE08l+cAnV6JrSV2Lq9LKZygu
         UPOLjW28YMUgsVCUid3RbPvD4gp/IUH/+cz5WTi8MeVD6CutH8+nuv/ma7VkncEyReWC
         y6BSHtUichyY6JqKBoJh1yBmsMpYVn6l+JXyW8CMGDFNln/BQ0o1sj0yhneT96KPA6em
         809jGHwlCmlyvk4Dudq7BK/gPDpnIuRt0QcZdoCoRshtVz1EhMxE62A750xaVmjYe85e
         QMRA==
X-Gm-Message-State: AOAM533Jr4s0iAtItI12v0r/bk+Iici1CBSWTMX7B0QnVnSZpSHZmJPP
        SDvyfMet/5kSMtRXV136VHI=
X-Google-Smtp-Source: ABdhPJwcMc7pBn9npc80n0nNmDQDDZpGDghJbvj7Xmc/kAG5aDm7AWrnBKfIYlEynAavc3DkERbqYw==
X-Received: by 2002:aa7:9115:0:b029:359:69db:bc89 with SMTP id 21-20020aa791150000b029035969dbbc89mr22573713pfh.32.1628006663340;
        Tue, 03 Aug 2021 09:04:23 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id y6sm14390653pjr.48.2021.08.03.09.04.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 09:04:22 -0700 (PDT)
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
Subject: [PATCH net-next v2 1/4] net: dsa: mt7530: enable assisted learning on CPU port
Date:   Wed,  4 Aug 2021 00:04:01 +0800
Message-Id: <20210803160405.3025624-2-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210803160405.3025624-1-dqfext@gmail.com>
References: <20210803160405.3025624-1-dqfext@gmail.com>
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
v1 -> v2: no changes.

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

