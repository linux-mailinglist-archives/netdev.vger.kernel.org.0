Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7B153A1CEE
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 20:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbhFISpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 14:45:13 -0400
Received: from mail-ej1-f54.google.com ([209.85.218.54]:33314 "EHLO
        mail-ej1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbhFISpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 14:45:11 -0400
Received: by mail-ej1-f54.google.com with SMTP id g20so39967974ejt.0
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 11:43:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x54p5UC5lHeUMUMtJqvxKcSN6gEMtSjFo1/RRsSFRo8=;
        b=BgVCGp6zgD3SfsXLg79UlCqiyGm1sdGlXj9Z7pZ1QTomcMktWMDevt+x6CK+riJ/tQ
         oyFrO7T4jQW1d1xjCCnnnG7hLYkIHm9G9t4IOL18eAtsvTOzF/fOS7+5zyBQtDJIOuMI
         LXiiivNhqyADDJPNgQ/dAc7FXFIJ2l5V384KlSFGkzzEEyPmH28mYyxn/CZJqoRGTZhB
         3gCUUxNkXa09tjYZMsKQ/VwajRhT9SooCNxgJUYVkQinnijd10cRzOybhkBeqVAdpnk+
         Sg4w+YhMhTMhAhnOMhE1JcXRg2laesasDgypfckkE9sJUj8y6yd7eP73sNhoLPmpssfR
         nS6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x54p5UC5lHeUMUMtJqvxKcSN6gEMtSjFo1/RRsSFRo8=;
        b=NpImJjNZ+fqnssXGoUrM+n5EoXU8sHoSZNNNuBy8pRlJh8QJ0CL/IwyMeIFIVP2PjP
         RNPVGhcUik2q0aUy2BYE2hgy6YRyOR7vpmU+BG7572XWAm1IJmyAfgm7oCJRugkjjwu6
         GGCub+Hwv3AowaDxV91qsCH1BDxYKTaJ81rJ+qZxhCo42+pH3lMxCFflNl/L0JPdMhIZ
         3XXyGrAEZSW+VsqdFJjoqils9phXNdPKcWU3E4ZySG3fe97i1H5o1SQtwpxdWdpuarSw
         K+69RglnZzMwXtljpp5xoTWms86+TcvhlC1LnDtLJWothf/833NSfzzXyC+S8fT4jPHe
         O6GA==
X-Gm-Message-State: AOAM531C78ijatQIe8qiN/uX42UqLUwHJPMI/ZvgUbRbTZE9kYw93K29
        OVAIDrf/VxdQQjH6rVEsHpQ=
X-Google-Smtp-Source: ABdhPJw/bsF3nCo3TrHtOFNVtGOHmhAvp+gm+pGvjAaYzus1s0zqZ2xcDnTZqNYKQ4ndaKw4Dh1qlw==
X-Received: by 2002:a17:906:869a:: with SMTP id g26mr1178657ejx.94.1623264135473;
        Wed, 09 Jun 2021 11:42:15 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id oz11sm194935ejb.16.2021.06.09.11.42.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 11:42:15 -0700 (PDT)
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
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 03/13] net: stmmac: reduce indentation when calling stmmac_xpcs_setup
Date:   Wed,  9 Jun 2021 21:41:45 +0300
Message-Id: <20210609184155.921662-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210609184155.921662-1-olteanv@gmail.com>
References: <20210609184155.921662-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

There is no reason to embed an if within an if, we can just logically
AND the two conditions.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 1c881ec8cd04..372673f9af30 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7002,12 +7002,10 @@ int stmmac_dvr_probe(struct device *device,
 	if (priv->plat->speed_mode_2500)
 		priv->plat->speed_mode_2500(ndev, priv->plat->bsp_priv);
 
-	if (priv->plat->mdio_bus_data) {
-		if (priv->plat->mdio_bus_data->has_xpcs) {
-			ret = stmmac_xpcs_setup(priv->mii);
-			if (ret)
-				goto error_xpcs_setup;
-		}
+	if (priv->plat->mdio_bus_data && priv->plat->mdio_bus_data->has_xpcs) {
+		ret = stmmac_xpcs_setup(priv->mii);
+		if (ret)
+			goto error_xpcs_setup;
 	}
 
 	ret = stmmac_phy_setup(priv);
-- 
2.25.1

