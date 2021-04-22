Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0CDA36784A
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 06:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234763AbhDVEKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 00:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbhDVEKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 00:10:16 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 123D4C06138B;
        Wed, 21 Apr 2021 21:09:42 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id f11-20020a17090a638bb02901524d3a3d48so245538pjj.3;
        Wed, 21 Apr 2021 21:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BqG+zTglnF7bDNQlesivFzezPjfS1NU3z80UalF/S6Y=;
        b=XIw7qzdmjjv0XsqmEg2M6245uhywBxRrA+GaJEsytTxoss5nmoS7Jjxnb0uvvC2eNb
         9PerPXO3noS0Fyb0AXyAkRimWmhdvX0pEHjJIlGdWfdABzP1SgdpjmvgKn5xDwfgm1J/
         hcDYEJQ7iEY+/4KMfcDOz38ecA/RC2pXfpUs+C1NOWIehj8T3bQW1f58v2LiALKZ4kMb
         9/1SYZEXtSxJNjtrWMhpN4H+pFql5CtFjgJsgNSrlkCD5HWaqDXEKZ4/cWovRVcfYnqC
         T1iL8QN9M1xEmVfnOnUr/RXCOSfIpZdZyXfgOf0oEkz9Ffj4yimeIdAiWHZ+AC0pfP0/
         IB7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BqG+zTglnF7bDNQlesivFzezPjfS1NU3z80UalF/S6Y=;
        b=Xi8s3ZyxX9G1mVk42+RjImo7ExFiB6NfIW5G6QXFv+k9+pcDCm8ATK7nGQFneG3ZUk
         ew28vagGoZKjE0zXUZzMQo4LkYDMjtYci/XaIfrYn1IYfW654DxXpDk6CfZNIw7S3LHd
         pSRdRIUV8kCx0/jecM3S+cqdLXLxSy8up5iQ0SYp2GFlPAeWSqXbOTHuYS+Igrw3nL1o
         nGp44AUOaEjBN/gB3+OBseast6J4lzv1XF4V1HaiTeL/dUMZ1Fx5Z/83iQGSTzSPlj6R
         OFnoXD0VXapj6y6zD5BsX+JlP881icSS1LcHwschzay72T4DFcb5JBxDafdFc6V8D9uB
         o9kg==
X-Gm-Message-State: AOAM530lgbJ8dSYOl+nihTWF++ImyQaxaUtp2Y1mefaZQpz/6Uf5JYlv
        GowtKC5FHLhsnlKZEalARIQ=
X-Google-Smtp-Source: ABdhPJyXEesIOVFoSTI8GDvHdygln2zE5LDKv0dytmwT9xBB8YiKt6cpGaU8lBrUMOCkCPl6DIUf/Q==
X-Received: by 2002:a17:902:a585:b029:e7:3d46:660d with SMTP id az5-20020a170902a585b02900e73d46660dmr1326944plb.12.1619064581626;
        Wed, 21 Apr 2021 21:09:41 -0700 (PDT)
Received: from z640-arch.lan ([2602:61:7344:f100::678])
        by smtp.gmail.com with ESMTPSA id i17sm635354pfd.84.2021.04.21.21.09.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 21:09:41 -0700 (PDT)
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
To:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Cc:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Subject: [PATCH net-next 05/14] net: ethernet: mtk_eth_soc: reduce MDIO bus access latency
Date:   Wed, 21 Apr 2021 21:09:05 -0700
Message-Id: <20210422040914.47788-6-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210422040914.47788-1-ilya.lipnitskiy@gmail.com>
References: <20210422040914.47788-1-ilya.lipnitskiy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

usleep_range often ends up sleeping much longer than the 10-20us provided
as a range here. This causes significant latency in mdio bus acceses,
which easily adds multiple seconds to the boot time on MT7621 when polling
DSA slave ports.

Use udelay via readx_poll_timeout_atomic, since the MDIO access does not
take much time

Signed-off-by: Felix Fietkau <nbd@nbd.name>
[Ilya: use readx_poll_timeout_atomic instead of cond_resched]
Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 18 ++++++++----------
 drivers/net/ethernet/mediatek/mtk_eth_soc.h |  2 +-
 2 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 5cf64de3ddf8..a3958e99a29f 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -79,18 +79,16 @@ static u32 mtk_m32(struct mtk_eth *eth, u32 mask, u32 set, unsigned reg)
 
 static int mtk_mdio_busy_wait(struct mtk_eth *eth)
 {
-	unsigned long t_start = jiffies;
+	int ret;
+	u32 val;
 
-	while (1) {
-		if (!(mtk_r32(eth, MTK_PHY_IAC) & PHY_IAC_ACCESS))
-			return 0;
-		if (time_after(jiffies, t_start + PHY_IAC_TIMEOUT))
-			break;
-		usleep_range(10, 20);
-	}
+	ret = readx_poll_timeout_atomic(__raw_readl, eth->base + MTK_PHY_IAC,
+					val, !(val & PHY_IAC_ACCESS),
+					5, PHY_IAC_TIMEOUT_US);
+	if (ret)
+		dev_err(eth->dev, "mdio: MDIO timeout\n");
 
-	dev_err(eth->dev, "mdio: MDIO timeout\n");
-	return -1;
+	return ret;
 }
 
 static u32 _mtk_mdio_write(struct mtk_eth *eth, u32 phy_addr,
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 875e67b41561..989342a7ae4a 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -327,7 +327,7 @@
 #define PHY_IAC_START		BIT(16)
 #define PHY_IAC_ADDR_SHIFT	20
 #define PHY_IAC_REG_SHIFT	25
-#define PHY_IAC_TIMEOUT		HZ
+#define PHY_IAC_TIMEOUT_US	1000000
 
 #define MTK_MAC_MISC		0x1000c
 #define MTK_MUX_TO_ESW		BIT(0)
-- 
2.31.1

