Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E414D3616AE
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 02:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235060AbhDPAMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 20:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234764AbhDPAMg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 20:12:36 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06846C061574;
        Thu, 15 Apr 2021 17:12:11 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id j7so13023240plx.2;
        Thu, 15 Apr 2021 17:12:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XS9jf7c2Kn/z8NibUqzFqwM3JlkffV+BoajyGhE4uFo=;
        b=mo1BkFPwqS6c6CkwjkDF6esSCOHgCMlmbcTjcV9SxD1/CnFRa/6ug4NA0e/hEPwMdp
         0sbTfZYhpk+BhRcYsVQBvzvNRnu13U0vqEyOeRQmlKW1HiDsttuvOKUeAoGk5lUbv0Y7
         yANgaw/Ir7dh/mlDX/DiONSXnlSofjD6W5Kh/qVzRKY/1W338p4whzwJQJsb1z0UC+lH
         CHGTKC7xEyIdw5TR46dcW6w8xtYOpgjGYkD8y6mjH1LGarYIYCLcvmmeJG4qbEfTmwCg
         d7RvXPVJd4Ye7HUpQ+gkqqmizhlfa/ZR2KuAYWbmDQXWPCoRFYHX22ID0LsfLuvI6e+n
         P1Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XS9jf7c2Kn/z8NibUqzFqwM3JlkffV+BoajyGhE4uFo=;
        b=a6ZF5hAGYUSz7GZ3nnIYGQiHa2ZqCWiS22A+C8th0SyxPDHwjDhxrRT+HMQOhTUwlE
         9YBhvAldDywGg8H90IaqRR3KdF/1mLDzoaE3RkL8zTkkQzMHaYOEKyoeyty9VCD67rev
         wMzZEmdJc/OBn5a7paAm8epMmdfYmWbEpwjC9Gu3dQwtJtRx3Jep8gInOn4k64hE2zVY
         brQQBHiopezp6RFCGfmRUUBEmy2N/8N7MQkQuoS+NaULSHyY1m/Gk5/lLRywV6Xlp/77
         VrcTm4XJN/VCBchZwXcgzwSPZ9dyR6Hman0YIpMn5JL0RPEhFmqT50gkcmDEhvr2k6LF
         HACw==
X-Gm-Message-State: AOAM5319hrt6zAXDjRA4hsifkGxlaFkuQAC1qAyxlRegkl6HEv9x1AlG
        4NxZgxLR20+9a2yAt7vMumw=
X-Google-Smtp-Source: ABdhPJw86uCZIyZhfUfXRNdYT3BvkAgjE0TmQM8Ra+Ml2xGDSSsiy3C5xqlsxYPFzzSIgbQl2QEvaQ==
X-Received: by 2002:a17:903:4101:b029:ea:fc8a:9adb with SMTP id r1-20020a1709034101b02900eafc8a9adbmr6686043pld.49.1618531931378;
        Thu, 15 Apr 2021 17:12:11 -0700 (PDT)
Received: from ilya-fury.hpicorp.net ([2602:61:7344:f100::b87])
        by smtp.gmail.com with ESMTPSA id q63sm3563100pjq.17.2021.04.15.17.12.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 17:12:10 -0700 (PDT)
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
Subject: [PATCH net-next,v2] net: ethernet: mediatek: ppe: fix busy wait loop
Date:   Thu, 15 Apr 2021 17:11:48 -0700
Message-Id: <20210416001148.333969-1-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <YHjH3DxteZrID2hW@lunn.ch>
References: <YHjH3DxteZrID2hW@lunn.ch>
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
---
 drivers/net/ethernet/mediatek/mtk_ppe.c | 18 +++++++++---------
 drivers/net/ethernet/mediatek/mtk_ppe.h |  1 +
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.c b/drivers/net/ethernet/mediatek/mtk_ppe.c
index 71e1ccea6e72..f4b3fc0eeb50 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
@@ -5,6 +5,7 @@
 #include <linux/jiffies.h>
 #include <linux/delay.h>
 #include <linux/io.h>
+#include <linux/iopoll.h>
 #include <linux/etherdevice.h>
 #include <linux/platform_device.h>
 #include "mtk_ppe.h"
@@ -44,18 +45,17 @@ static u32 ppe_clear(struct mtk_ppe *ppe, u32 reg, u32 val)
 
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

