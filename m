Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29C3A3F57C4
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 07:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234464AbhHXF4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 01:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbhHXF4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 01:56:02 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0C6CC061575;
        Mon, 23 Aug 2021 22:55:18 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id z24-20020a17090acb1800b0018e87a24300so1601449pjt.0;
        Mon, 23 Aug 2021 22:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uzm00SI6Xxv7Dr12oDCG09tFQ89IjLql7VYEkcSa46Y=;
        b=U+/FRkIIjFBtQoRW5haOg0F8PlwQaveBzrO3OYhJi0C3fyk25+NPCgb9o8wUrKcNHf
         ae/4mTxPFes/E4AatfwSp6CwzbwS5SaGFPyGBbXiziD0TbQKB0gZxdft+/vbZaaUGmnK
         T8BXeOseqa3/sQo7eyhGLJV0zuw5uy8nvV49gNccJzEZQO+uugR2H50r7uuc8P8KEK8K
         C6PvI7X6UgWBCwHy/5LGZBjO5pQaQkcJWR6JHWf1Riz38nat4JXClCQbsxSEw4U/s44N
         +t4RqSyoIT/IM3HRkfn8mvFyMDy9f2heRo7RIQ02bIRmA4aICIz7u+tHYOxpJ2TblFBJ
         zByw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uzm00SI6Xxv7Dr12oDCG09tFQ89IjLql7VYEkcSa46Y=;
        b=oNVftBXrwzUNmRd3pXWY/cJSFSwe2nyw15l2aec1YPMiI4DMtnGVkvMeIOEsfN603K
         chewOmwkLuQgYApMwCUZsMF/x12TaatfEwoUopOIMpOjkDqdGZbtP2FLzGAcWGgnXaFe
         ut8L2xcQz17j4oRNRDOgFwnwSHIdXXPwRV+AH912aWxiWxX5NKJoLyTg3046hQKsLoI0
         CbGzORgNj3yepPUIK5TCmlPmMcfQa+QrJnRVQ45s6NCn4fgYr/D4s162UaFcC57C+A51
         ThHyEfDbOAPzbthrCf22ft/oBv3YbfMwgbX9o3Yad9ARCBaSqpEdqI5se/hoePStmXja
         eenw==
X-Gm-Message-State: AOAM530I8DOTNBNmisbymeYR3xdN4w8kek6BKPT8A1QQqAdxLKE40F87
        hm3bd252CoTKVL2DBvWaZpNaPxweHPrP4T5f
X-Google-Smtp-Source: ABdhPJzBi/kmvgCws8SSBpovsykHE9dI8wovC6w+AuFQJxJ7Rnya+3XcIsj2pgCgwhudhuxNy0sklg==
X-Received: by 2002:a17:90a:af88:: with SMTP id w8mr2625365pjq.104.1629784518132;
        Mon, 23 Aug 2021 22:55:18 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id j5sm1053958pjv.56.2021.08.23.22.55.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 22:55:17 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     stable@vger.kernel.org
Cc:     Sean Wang <sean.wang@mediatek.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org (open list:MEDIATEK SWITCH DRIVER),
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support),
        linux-mediatek@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support)
Subject: [PATCH 4.19.y] net: dsa: mt7530: disable learning on standalone ports
Date:   Tue, 24 Aug 2021 13:55:08 +0800
Message-Id: <20210824055509.1316124-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a partial backport of commit 5a30833b9a16f8d1aa15de06636f9317ca51f9df
("net: dsa: mt7530: support MDB and bridge flag operations") upstream.

Make sure that the standalone ports start up with learning disabled.

Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
 drivers/net/dsa/mt7530.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 6335c4ea0957..67dfab774618 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -803,6 +803,8 @@ mt7530_port_bridge_join(struct dsa_switch *ds, int port,
 			   PCR_MATRIX_MASK, PCR_MATRIX(port_bitmap));
 	priv->ports[port].pm |= PCR_MATRIX(port_bitmap);
 
+	mt7530_clear(priv, MT7530_PSC_P(port), SA_DIS);
+
 	mutex_unlock(&priv->reg_mutex);
 
 	return 0;
@@ -907,6 +909,8 @@ mt7530_port_bridge_leave(struct dsa_switch *ds, int port,
 
 	mt7530_port_set_vlan_unaware(ds, port);
 
+	mt7530_set(priv, MT7530_PSC_P(port), SA_DIS);
+
 	mutex_unlock(&priv->reg_mutex);
 }
 
@@ -1287,11 +1291,15 @@ mt7530_setup(struct dsa_switch *ds)
 		mt7530_rmw(priv, MT7530_PCR_P(i), PCR_MATRIX_MASK,
 			   PCR_MATRIX_CLR);
 
-		if (dsa_is_cpu_port(ds, i))
+		if (dsa_is_cpu_port(ds, i)) {
 			mt7530_cpu_port_enable(priv, i);
-		else
+		} else {
 			mt7530_port_disable(ds, i, NULL);
 
+			/* Disable learning by default on all user ports */
+			mt7530_set(priv, MT7530_PSC_P(i), SA_DIS);
+		}
+
 		/* Enable consistent egress tag */
 		mt7530_rmw(priv, MT7530_PVC_P(i), PVC_EG_TAG_MASK,
 			   PVC_EG_TAG(MT7530_VLAN_EG_CONSISTENT));
-- 
2.25.1

