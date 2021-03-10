Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66F033349B7
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 22:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232086AbhCJVOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 16:14:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231964AbhCJVO1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 16:14:27 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45CF4C061574;
        Wed, 10 Mar 2021 13:14:27 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id a188so13009293pfb.4;
        Wed, 10 Mar 2021 13:14:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yve5BB90c/as2wOa80BfMCFbUCTgC67sdO61zec9GZ0=;
        b=OZFfh8Vt0Cu4mawZtmQpyBKOGCaQ3clX9KdNOdqxLlZlt3nh4BWL25L3UmLNExzU6y
         HP5PnPu+01ahyzmFSZBlPUcZV4hkVhbANq5YHl0L+xf1kEY4DLs5qLrvegvH3MSV11qY
         K1/NVsmNEO0H48Idn80xECABCEvIiuPrNfA8OBW94V4d9dDZH44elFDcYId8ac0lQ3Dg
         wN/a2R+IvD3Jt+sqgDi4yFS/qqxRauhBmESg5Oowog0js8pFPoVV68Moj2fCHKLKmKzT
         5pSvOBjCLlDzJZ/o6UrgnGMCxHwMxHHTMAdqf8ctCZ7Oos49zwWP0YSGQd2/4ZjKbA8R
         kDEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yve5BB90c/as2wOa80BfMCFbUCTgC67sdO61zec9GZ0=;
        b=cpPJYDfZJbSe9qLG5NLGeDEKGaAlXQEfb9Q+96FIFKQ6rPcauqBO1EYDXDqh5dDeKf
         vkhpbs4j9cMwY6BIIxdv1tW0CGSfsc6ByhL+I6hWYze7tsgYrXxtmIxJ9yZMWNgkqpfT
         EvPQw2cQ/D4l5c3Xk2XiEQfW0XI+sPRn/MYmYdfbLNhTUS4OEuWIvYBriHyD0mkQ9k8T
         6fTH1Jkmxia8vT+OHu4gmEWua5QUHitkkXXmq2s5AMERgr6PT9dVWkMsOI4rY7rRFvr/
         5r2AeqgtjXx2yfERtfF7g8rEv+172u9mhUMoF0EhFzJtNTlcnONTAzXLUm1eaz52jWS2
         hUPw==
X-Gm-Message-State: AOAM5303s+7bau++eT6DoRRaV/22twxPyLy2hW1CNPDqKy9AYHExlry3
        zjma9p5O7BNFx8i2E9y2Gm8=
X-Google-Smtp-Source: ABdhPJwlWieVx5tgc77i//vC5nut7Ty2JzURJWrddKHuT8PXEAoSEMjY4mbMYUmyAOKryS8JCD/2Vw==
X-Received: by 2002:a05:6a00:78c:b029:1f5:d587:1701 with SMTP id g12-20020a056a00078cb02901f5d5871701mr4544454pfu.59.1615410866803;
        Wed, 10 Mar 2021 13:14:26 -0800 (PST)
Received: from ilya-fury.lan ([2602:61:738f:1000::b87])
        by smtp.gmail.com with ESMTPSA id 35sm412090pgr.14.2021.03.10.13.14.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 13:14:26 -0800 (PST)
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
Subject: [PATCH 2/3] net: dsa: mt7530: use core_write wrapper
Date:   Wed, 10 Mar 2021 13:14:19 -0800
Message-Id: <20210310211420.649985-2-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210310211420.649985-1-ilya.lipnitskiy@gmail.com>
References: <20210310211420.649985-1-ilya.lipnitskiy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When disabling PLL, there is no need to call core_write_mmd_indirect
directly, use the core_write wrapper instead like the rest of the code
in the function does. This change helps with consistency and
readability.

Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
---
 drivers/net/dsa/mt7530.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index e785f80f966b..b106ea816778 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -445,10 +445,7 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
 		 * provide our own core_write_mmd_indirect to complete this
 		 * function.
 		 */
-		core_write_mmd_indirect(priv,
-					CORE_GSWPLL_GRP1,
-					MDIO_MMD_VEND2,
-					0);
+		core_write(priv, CORE_GSWPLL_GRP1, 0);
 
 		/* Set core clock into 500Mhz */
 		core_write(priv, CORE_GSWPLL_GRP2,
-- 
2.30.1

