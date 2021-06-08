Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E642339F758
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 15:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232695AbhFHNM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 09:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231162AbhFHNMz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 09:12:55 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 835E0C061574;
        Tue,  8 Jun 2021 06:10:48 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id g8so32575643ejx.1;
        Tue, 08 Jun 2021 06:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=804/bC9Z2zHXp+58/xaswq1VZqZQikziOCC71To0VF8=;
        b=UVJfC9RW4ya+jxSijO/GKZlBv87RkiJGO9JVLpOMF6lHudL4J0JQIXt5Ify/xTXit0
         o/m5yGuOfIRk0jXKX6CR6RSwsTOhc9zOoXImYLZG5VZYpCcS+NKp3Ho11KMBF8j1cLmC
         apqebKtCjr0Rfdyny25NPEPkmUErxQ4TU1rcdzKS4mgy8Yh1Kfzf6g6tYIRh3K/ck+Wr
         y1lx89aJlRTextrF1kzkAe78LZVmWQBQgCyBWzPXRAaOrJLxxM2+eyCT2JGY/e7pBFuX
         2Avlov6vXEaCg82CljBvoBm5xLlMnT62DuPzO3JFwRioX32x8E4svIfxZ/SwV4OGd+le
         4+MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=804/bC9Z2zHXp+58/xaswq1VZqZQikziOCC71To0VF8=;
        b=taFcGx8FvyyUEZGPXmGRvdRwutMtHdOOJYpC1+VJ20eKq7kds2wibmPiacZR7kU5fH
         n+MYxDyRuZZEQ8x0xGM7KRJuFsYBAkEqBEEaSMrgR0EAZbTpG5Wa27vCpwIidozsktrj
         Hnju1liKIxNzCW51wbyIEcKTgDajjBLFpJQ0wU8dhPBKTURc3OUYDhHt+UBePyRvGccJ
         vurwMZhfX++Ataq2D/KIl9jkwi0mz0EwcqoyUk9eWDCSiP7JtLQOiVhdDz1dKJR3c57r
         jBEo+owaj6vWlA0/0LNvbrBk64w6/R31cekLW8GHQP1n9tnRt1c2ntQk4jjitIceGpZE
         XQ2w==
X-Gm-Message-State: AOAM5322UVlLwaTeDEOB1YbX9mDbx2MyOOa2R4bYq8OUUOYBRFueMC7b
        82g4wlEfanbfZo+/fWbvbVA=
X-Google-Smtp-Source: ABdhPJzEV7bMmQjf7DLkCWVhgYJmV6uYrbhhWeYERRSA/pwyjaF4xwx9h94qWF2xre3wNbv3VcwA8Q==
X-Received: by 2002:a17:906:606:: with SMTP id s6mr22987987ejb.206.1623157847047;
        Tue, 08 Jun 2021 06:10:47 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id y15sm3220118edd.55.2021.06.08.06.10.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 06:10:46 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, kernel-janitors@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH net-next] net: stmmac: fix NPD with phylink_set_pcs if there is no MDIO bus
Date:   Tue,  8 Jun 2021 16:10:37 +0300
Message-Id: <20210608131037.4127646-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

priv->plat->mdio_bus_data is optional, some platforms may not set it,
however we proceed to look straight at priv->plat->mdio_bus_data->has_xpcs.

Since the xpcs is instantiated based on the has_xpcs property, we can
avoid looking at the priv->plat->mdio_bus_data structure altogether and
just check for the presence of the xpcs pointer.

Fixes: 11059740e616 ("net: pcs: xpcs: convert to phylink_pcs_ops")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index dd2fb851c693..ec060ce9bcf2 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1238,11 +1238,8 @@ static int stmmac_phy_setup(struct stmmac_priv *priv)
 	if (IS_ERR(phylink))
 		return PTR_ERR(phylink);
 
-	if (mdio_bus_data->has_xpcs) {
-		struct mdio_xpcs_args *xpcs = priv->hw->xpcs;
-
-		phylink_set_pcs(phylink, &xpcs->pcs);
-	}
+	if (priv->hw->xpcs)
+		phylink_set_pcs(phylink, &priv->hw->xpcs->pcs);
 
 	priv->phylink = phylink;
 	return 0;
-- 
2.25.1

