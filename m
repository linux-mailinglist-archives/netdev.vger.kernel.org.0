Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3ED83349B5
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 22:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232030AbhCJVOk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 16:14:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231935AbhCJVOZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 16:14:25 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80D3BC061574;
        Wed, 10 Mar 2021 13:14:25 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id x7-20020a17090a2b07b02900c0ea793940so7946927pjc.2;
        Wed, 10 Mar 2021 13:14:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4FsyvPll9hketVRRLkgN32e9nK5xbA0yUQ+/xWtjN5A=;
        b=sS6imgOph8gR00hEK59z03oQEPnKC5OOit9DuHc9a9zW2bnRVXnbj4Sw2fC032b0w1
         Z40vFIAbd7Yg2JVUAlD0lsjjiKM5UyAS4EBh/3RAhonPZdbdzZcrXYiidJo2DkgJX2nL
         iiny/jjkthqyHfBbwuEkA44ykbHmGoMM97WzSzveom1U4u9koOGpnryhADOT/I6WTQ3u
         IH6mSU5vuAWSxYl6cCvbPWu2QDBsWEaMnM1KP2S0K5uk6gp0ZG/JBh1LXBnnibnqDEA2
         6H7ZYyd/lbb+asSbJAIYAIMIALiWGYV8PnZXdwrX/iXVy5Khvx/t581cLa1Preoz7UaU
         M6+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4FsyvPll9hketVRRLkgN32e9nK5xbA0yUQ+/xWtjN5A=;
        b=Q8hD+T2j5+sDwgZHGhtZilFVJe1oQVjPf5SDVw/6eafdq3MUgLxZibktyZOJt7QAxN
         iy2MDlcLH2jpErQWygkGEzAlKfWnqRVuVPYdRCgTL60eFtDspvXXKY/YszvJ/hUXrmyv
         xOIZusAAiMMvZK+5CUxCNvGFM35q9kOl7Qtq2rpCflfO7SgP8adcD78Wq5d3ZtuyJU1o
         KrhzW/stVu96b6zvXXgJ8VXyfctRWrqHknK1hCsM28ckHrZfduiTbnmGxAPi40jKvDXx
         0ANqvNLvJvYc0GV1QtWlJTZxrsY5fgdgmBvGU2XPqSg1tMiLh0lVuHsSOmIz8jdeH1Y4
         rTQg==
X-Gm-Message-State: AOAM5327lkZR4N+Tm9xyberjq/Qz2Bf+Y9FcTJg9IGxyoG4AQHlbJt5S
        4Ozw4Y64gdJOrnRR23wN14s=
X-Google-Smtp-Source: ABdhPJw4sfCLQailZ4/acL2LUKzPF+3TwjE25+ZJKEaff5COFkOBbZnQseKx/45xHgF0zVbL/vIMLA==
X-Received: by 2002:a17:90b:3890:: with SMTP id mu16mr5447946pjb.9.1615410865096;
        Wed, 10 Mar 2021 13:14:25 -0800 (PST)
Received: from ilya-fury.lan ([2602:61:738f:1000::b87])
        by smtp.gmail.com with ESMTPSA id 35sm412090pgr.14.2021.03.10.13.14.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 13:14:24 -0800 (PST)
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
To:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Subject: [PATCH 1/3] net: dsa: mt7530: remove redundant clock enables
Date:   Wed, 10 Mar 2021 13:14:18 -0800
Message-Id: <20210310211420.649985-1-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In RGMII mode, the REG_GSWCK_EN bit of CORE_TRGMII_GSW_CLK_CG gets
set three times in a row. In TRGMII mode, two times. Simplify the code
and only set it once for both modes.

Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
---
 drivers/net/dsa/mt7530.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index f06f5fa2f898..e785f80f966b 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -461,12 +461,9 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
 			   RG_GSWPLL_POSDIV_200M(2) |
 			   RG_GSWPLL_FBKDIV_200M(32));
 
-		/* Enable MT7530 core clock */
-		core_set(priv, CORE_TRGMII_GSW_CLK_CG, REG_GSWCK_EN);
 	}
 
 	/* Setup the MT7530 TRGMII Tx Clock */
-	core_set(priv, CORE_TRGMII_GSW_CLK_CG, REG_GSWCK_EN);
 	core_write(priv, CORE_PLL_GROUP5, RG_LCDDS_PCW_NCPO1(ncpo1));
 	core_write(priv, CORE_PLL_GROUP6, RG_LCDDS_PCW_NCPO0(0));
 	core_write(priv, CORE_PLL_GROUP10, RG_LCDDS_SSC_DELTA(ssc_delta));
@@ -480,6 +477,8 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
 	core_write(priv, CORE_PLL_GROUP7,
 		   RG_LCDDS_PCW_NCPO_CHG | RG_LCCDS_C(3) |
 		   RG_LCDDS_PWDB | RG_LCDDS_ISO_EN);
+
+	/* Enable MT7530 core and TRGMII Tx clocks */
 	core_set(priv, CORE_TRGMII_GSW_CLK_CG,
 		 REG_GSWCK_EN | REG_TRGMIICK_EN);
 
-- 
2.30.1

