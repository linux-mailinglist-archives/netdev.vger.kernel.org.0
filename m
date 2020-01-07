Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED62D131EC6
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 06:09:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725914AbgAGFIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 00:08:53 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:53575 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbgAGFIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 00:08:53 -0500
Received: by mail-pj1-f66.google.com with SMTP id n96so8487767pjc.3;
        Mon, 06 Jan 2020 21:08:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cr5sx8yPELFvuYRl+jNMxMdmYnoYhuCmAKJ5oKY9g0E=;
        b=bs8O920SS1yotiq316xmFKSrZBnBRdPAatoEKVXgtngpJcFL++S9RN5RwkXU2oL4Xx
         K0Xovl+wvF80zIxlBK+RWOePBY/ZNYDD8y0nTG/5qxJCsOX9yRL2TSOSxrjFTaSV9vWb
         kkcNaCW0XzGLmtdgZxX+e0l1kxQZSSgRJgEuC11v8NNShmuCvWGSdMTSM6g1SrlevIAF
         k0K/m1O0x9KoKblKFHdKetFua70jZ1+UwCwXtCXl5o0pHJOXI3684yFzCU7yGoVPy6e+
         /F5rsnlyDzeNoL48tvUnWJktqdeqB1xjmff/zZbdJSsR2bJw3dwlqd8QcraP2rM3Q/S5
         rIDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cr5sx8yPELFvuYRl+jNMxMdmYnoYhuCmAKJ5oKY9g0E=;
        b=gqGUl3StxC49uGXj/Cn5N1jivWHULQo0wI8ESPqhex5NZXZlcG0tu3SYV1zU1ceikK
         eOQHOLzn7dFE0/1VFLTtf3dK0FtvAvGJ1WKdjFx5ZkwuhWSMckVzmyDugvK3RGj26miR
         m3t0MxGF3e9yBy/LddwqSel9fR/LKG5pK9Pje3mJHOKealrA3WsFWfoCM6NeJdaEfooK
         z8NsYN6gT1rOUoD4ZUUb8/Kt3jq7Yro/1qxV/gb8Q0dYPsWDeF+kW7uj3HOACHPvMnNz
         aMPemKdSDseVlgcoZ79UIQK00qZ/0nIjQtuCuY0wKFmK3yLsn0P9247bnjSAkPrwsynM
         a99Q==
X-Gm-Message-State: APjAAAXvYGsnVCNjRgcOOOF+Y1otFqgOq/RpoyNsC952aLgMiFo/FAmC
        w9voxJHz9JGip6nfRGNOQn3coNOM
X-Google-Smtp-Source: APXvYqz6YXrRtzypIMvVy+x3Jnu/MuLIq8K/vpYiXguCE8h2B/hQlRh5PoCsvQtDYr6Xwakge0GZjg==
X-Received: by 2002:a17:90a:8912:: with SMTP id u18mr46705829pjn.21.1578373732299;
        Mon, 06 Jan 2020 21:08:52 -0800 (PST)
Received: from localhost.localdomain (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id l66sm75149647pga.30.2020.01.06.21.08.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jan 2020 21:08:51 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        tomeu.vizoso@collabora.com, khilman@baylibre.com,
        "David S. Miller" <davem@davemloft.net>, mgalka@collabora.com,
        guillaume.tucker@collabora.com, broonie@kernel.org,
        Jayati Sahu <jayati.sahu@samsung.com>,
        Sriram Dash <sriram.dash@samsung.com>,
        Padmanabhan Rajanbabu <p.rajanbabu@samsung.com>,
        enric.balletbo@collabora.com, Jose Abreu <Jose.Abreu@synopsys.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        linux-kernel@vger.kernel.org,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, heiko@sntech.de
Subject: [PATCH net] Revert "net: stmmac: platform: Fix MDIO init for platforms without PHY"
Date:   Mon,  6 Jan 2020 21:08:46 -0800
Message-Id: <20200107050846.16838-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit d3e014ec7d5ebe9644b5486bc530b91e62bbf624 ("net:
stmmac: platform: Fix MDIO init for platforms without PHY") because it
breaks existing systems with stmmac which do not have a MDIO bus
sub-node nor a 'phy-handle' property declared in their Device Tree. On
those systems, the stmmac MDIO bus is expected to be created and then
scanned by of_mdiobus_register() to create PHY devices.

While these systems should arguably make use of a more accurate Device
Tree reprensentation with the use of the MDIO bus sub-node an
appropriate 'phy-handle', we cannot break them, therefore restore the
behavior prior to the said commit.

Fixes: d3e014ec7d5e ("net: stmmac: platform: Fix MDIO init for platforms without PHY")
Reported-by: Heiko Stuebner <heiko@sntech.de>
Reported-by: kernelci.org bot <bot@kernelci.org>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
Heiko,

I did not add the Tested-by because the patch is a little bit different
from what you tested, even if you most likely were not hitting the other
part that I was changing. Thanks!

 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index cc8d7e7bf9ac..bedaff0c13bd 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -320,7 +320,7 @@ static int stmmac_mtl_setup(struct platform_device *pdev,
 static int stmmac_dt_phy(struct plat_stmmacenet_data *plat,
 			 struct device_node *np, struct device *dev)
 {
-	bool mdio = false;
+	bool mdio = true;
 	static const struct of_device_id need_mdio_ids[] = {
 		{ .compatible = "snps,dwc-qos-ethernet-4.10" },
 		{},
-- 
2.19.1

