Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC3B63616D8
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 02:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236845AbhDPAjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 20:39:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234708AbhDPAjm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 20:39:42 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77813C061574;
        Thu, 15 Apr 2021 17:39:18 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id lt13so4160801pjb.1;
        Thu, 15 Apr 2021 17:39:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aBY6qtFGj7zNDeJrN4gaVYMDLifsluyCEYYVjXGUGhY=;
        b=cav1PYT9iCq8PxAzlZbBd+YxkDZfawTwl6raGIuwLXAtFBYU8V3WJ63WF45R5/ijlT
         DLCCAOX4TmUPoxxmaKH/H+bFtjtUa2RatsivRWU1USF1TPDt7fzBmnwBlPDLFTOYloa6
         Dg8n/HODoNXMkccFin239ZYZ2rtplEJxO60bpmnKC8eLiyPHhebswwqfbUSNkTcO+GBV
         0w3bxDqPvo5f8U0LE3G5EjQ2RZomxdNjFjU4nzIQ5kDILqXpuT2DyjIuTcHa3VpMpQMn
         +iiKar9SqIrYQswPVz1nH5xSzWStlp+qnuzVyOJ7PtAoJfyWh4t9ZBrNd6vNTqnSq4mQ
         fOcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aBY6qtFGj7zNDeJrN4gaVYMDLifsluyCEYYVjXGUGhY=;
        b=eMA62Mnd+dP1NaAKIhp6IZW98XYUex17E8f4DrMlvax6e9WAz9VlXLYFVNvY/PNFuO
         q5JAsb3d/Tu83kmB57+7U5TNfSobdiYIuHZF/dm46jKcK159J08LZvF+PbvSAnPP67Qa
         MICpZq80nWlevn1jV848uomJ9U2tfJ6z35kuIgHcYHdq2+N1r4+XG6Pflw++K+gOhldI
         pdYsaQa5dgJbFVesEBr9DF2xrh5dvB5SXeWpZcSsV8BEgIP9vf+4xTATx7sl68j3vCNh
         lkYjGxZQimBHMGSFr1Ol9vlOpNVjiKSgTi0ZG4rWNURE1Rc6khr6f+i+/AqNutiQB8tW
         4+1Q==
X-Gm-Message-State: AOAM530NqwJ0WTXyz5yUsJd+wsg6mJNLs2uZ36ypcl/iXJQpf6XcaltS
        uYOStK6v1m88Im94gwOe2kAgdYaoozbwSovm
X-Google-Smtp-Source: ABdhPJzZxuzx5BmhL6ooNAafP7LdyiGBNpGXHo1p0bXduDUsTRQt6kHmK1A1kskzEY5G8oe6ZFHByg==
X-Received: by 2002:a17:90a:318d:: with SMTP id j13mr6947037pjb.174.1618533557891;
        Thu, 15 Apr 2021 17:39:17 -0700 (PDT)
Received: from ilya-fury.hpicorp.net ([2602:61:7344:f100::b87])
        by smtp.gmail.com with ESMTPSA id k3sm3187094pfh.12.2021.04.15.17.39.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 17:39:17 -0700 (PDT)
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
To:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Subject: [PATCH net-next,v3] net: ethernet: mediatek: ppe: fix busy wait loop
Date:   Thu, 15 Apr 2021 17:37:48 -0700
Message-Id: <20210416003747.340041-1-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <YHjaBWdMzrhajq2Q@lunn.ch>
References: <YHjaBWdMzrhajq2Q@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The intention is for the loop to timeout if the body does not succeed.
The current logic calls time_is_before_jiffies(timeout) which is false
until after the timeout, so the loop body never executes.

Fix by using readl_poll_timeout as a more standard and less error-prone
solution.

Fixes: ba37b7caf1ed ("net: ethernet: mtk_eth_soc: add support for initializing the PPE")
Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Cc: Felix Fietkau <nbd@nbd.name>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
v2:
  - Use readl_poll_timeout as suggested by Andrew Lunn
v3:
  - Remove unused #include's

 drivers/net/ethernet/mediatek/mtk_ppe.c | 20 +++++++++-----------
 drivers/net/ethernet/mediatek/mtk_ppe.h |  1 +
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.c b/drivers/net/ethernet/mediatek/mtk_ppe.c
index 71e1ccea6e72..3ad10c793308 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
@@ -2,9 +2,8 @@
 /* Copyright (C) 2020 Felix Fietkau <nbd@nbd.name> */
 
 #include <linux/kernel.h>
-#include <linux/jiffies.h>
-#include <linux/delay.h>
 #include <linux/io.h>
+#include <linux/iopoll.h>
 #include <linux/etherdevice.h>
 #include <linux/platform_device.h>
 #include "mtk_ppe.h"
@@ -44,18 +43,17 @@ static u32 ppe_clear(struct mtk_ppe *ppe, u32 reg, u32 val)
 
 static int mtk_ppe_wait_busy(struct mtk_ppe *ppe)
 {
-	unsigned long timeout = jiffies + HZ;
-
-	while (time_is_before_jiffies(timeout)) {
-		if (!(ppe_r32(ppe, MTK_PPE_GLO_CFG) & MTK_PPE_GLO_CFG_BUSY))
-			return 0;
+	int ret;
+	u32 val;
 
-		usleep_range(10, 20);
-	}
+	ret = readl_poll_timeout(ppe->base + MTK_PPE_GLO_CFG, val,
+				 !(val & MTK_PPE_GLO_CFG_BUSY),
+				 20, MTK_PPE_WAIT_TIMEOUT_US);
 
-	dev_err(ppe->dev, "PPE table busy");
+	if (ret)
+		dev_err(ppe->dev, "PPE table busy");
 
-	return -ETIMEDOUT;
+	return ret;
 }
 
 static void mtk_ppe_cache_clear(struct mtk_ppe *ppe)
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.h b/drivers/net/ethernet/mediatek/mtk_ppe.h
index 51bd5e75bbbd..242fb8f2ae65 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.h
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.h
@@ -12,6 +12,7 @@
 #define MTK_PPE_ENTRIES_SHIFT		3
 #define MTK_PPE_ENTRIES			(1024 << MTK_PPE_ENTRIES_SHIFT)
 #define MTK_PPE_HASH_MASK		(MTK_PPE_ENTRIES - 1)
+#define MTK_PPE_WAIT_TIMEOUT_US		1000000
 
 #define MTK_FOE_IB1_UNBIND_TIMESTAMP	GENMASK(7, 0)
 #define MTK_FOE_IB1_UNBIND_PACKETS	GENMASK(23, 8)
-- 
2.31.1

