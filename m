Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6009046F6C
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 12:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbfFOKJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 06:09:55 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54580 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726740AbfFOKJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 06:09:49 -0400
Received: by mail-wm1-f66.google.com with SMTP id g135so4678746wme.4;
        Sat, 15 Jun 2019 03:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+2oD/T2gc6N24fqNrzj6/wc7vB4Laq1g0xwvSr2ZKbs=;
        b=Tbn+fRxNzDPqt3dXwDOHmhvz1KRUKIeLE15UwPS7Aw07mlz4dq/T6LF2SVTNLz5mLZ
         PyoiOmkF/joUJFS6kUJ/0/MNwgoN57I6kkVuBeqWRwohMevKvE0F+dc/FzuBAMUyJ03v
         G8NweV2l51cLh0h8qJzK5Geqx3lDnoFEsPCKeP40L1LFRZuaIN8LHPrOhi4qaviSZvp6
         94HWbfFXG67h7zj8SJU0KrYlQ3HXdv1/j3vkRASNTrog5v0F+YrNvVeNrAs89dV6alZ4
         TI+WxthFrtSJ7iIYfJihpbsm66zotMRodljmY2LmrEbb64uArTJ3SjgFlzJhFZsHCgv0
         SZ3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+2oD/T2gc6N24fqNrzj6/wc7vB4Laq1g0xwvSr2ZKbs=;
        b=VFHw0lndQu5+L6FEs7P9aSd1mcO7HlLsd7uN9PitwFbsoIkPQ9k1Xh/RgoTQ4ETI5v
         VKaPr/OB2P7sb98mIxQAY3hI76SZZOTpvuLrLTrDTdJiDUd4FYSlOYkEJu/Ku25/DLD4
         jKbLYtdJh+xi3WesGEOsLVpXJBwGuCG6j64i33c2axJqujuDUfWE+P14i8D/7h++SQyC
         hgxzCdGBpkuDmJP3uzpOSQStztVj1i2Y6cKnc78e4vR3jxW83rCpkMT1lfqV6iYzRne0
         t+80jJrjIupv6lPT4El5SL1RNgGe2V3CYi+zMExUZwj+Ehr006VCprImVsFdbDN2535q
         cp5g==
X-Gm-Message-State: APjAAAXfUeyQxnFMwp4ryj/lktxD6IbFmAY6LLB9fArYCQrZBKehFviQ
        oWsDU7OgrdhVoEqKmyfc9/70Sr/h0Xo=
X-Google-Smtp-Source: APXvYqyWy5DuzLQIfgqm/qwN02Z8iZMe0vr3d729+Ve1oTg2V8Q3d6yjtc0DL1CeTDaOZ2WQ3MBHCw==
X-Received: by 2002:a1c:b6d4:: with SMTP id g203mr11100015wmf.19.1560593387236;
        Sat, 15 Jun 2019 03:09:47 -0700 (PDT)
Received: from blackbox.darklights.net (p200300F133C20E00A9A405DFDBBC0790.dip0.t-ipconnect.de. [2003:f1:33c2:e00:a9a4:5df:dbbc:790])
        by smtp.googlemail.com with ESMTPSA id f2sm9270513wrq.48.2019.06.15.03.09.46
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 15 Jun 2019 03:09:46 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     netdev@vger.kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com, davem@davemloft.net
Cc:     linus.walleij@linaro.org, andrew@lunn.ch,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH net-next v1 5/5] net: stmmac: drop the phy_reset hook from struct stmmac_mdio_bus_data
Date:   Sat, 15 Jun 2019 12:09:32 +0200
Message-Id: <20190615100932.27101-6-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190615100932.27101-1-martin.blumenstingl@googlemail.com>
References: <20190615100932.27101-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The phy_reset hook is not set anywhere. Drop it to make
stmmac_mdio_reset() smaller.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c | 6 ------
 include/linux/stmmac.h                            | 1 -
 2 files changed, 7 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index c9454cf4f189..14aa3ee14082 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -247,7 +247,6 @@ int stmmac_mdio_reset(struct mii_bus *bus)
 	struct net_device *ndev = bus->priv;
 	struct stmmac_priv *priv = netdev_priv(ndev);
 	unsigned int mii_address = priv->hw->mii.addr;
-	struct stmmac_mdio_bus_data *data = priv->plat->mdio_bus_data;
 
 #ifdef CONFIG_OF
 	if (priv->device->of_node) {
@@ -277,11 +276,6 @@ int stmmac_mdio_reset(struct mii_bus *bus)
 	}
 #endif
 
-	if (data->phy_reset) {
-		netdev_dbg(ndev, "stmmac_mdio_reset: calling phy_reset\n");
-		data->phy_reset(priv->plat->bsp_priv);
-	}
-
 	/* This is a workaround for problems with the STE101P PHY.
 	 * It doesn't complete its reset until at least one clock cycle
 	 * on MDC, so perform a dummy mdio read. To be updated for GMAC4
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index 96d97c908595..9aad16c379e7 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -92,7 +92,6 @@
 /* Platfrom data for platform device structure's platform_data field */
 
 struct stmmac_mdio_bus_data {
-	int (*phy_reset)(void *priv);
 	unsigned int phy_mask;
 	int *irqs;
 	int probed_phy_irq;
-- 
2.22.0

