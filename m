Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37548348207
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 20:37:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237836AbhCXThB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 15:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237659AbhCXTge (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 15:36:34 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCC95C061763;
        Wed, 24 Mar 2021 12:36:33 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id v11so25613835wro.7;
        Wed, 24 Mar 2021 12:36:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gWw8pr/c6qQDp74PKwcrUz7UHUPDPno5aG6deS6EemM=;
        b=XprtAHT2IgD43tNdUTswa8Xa+723tWR3QDEneZ6XeqjON5u3wyLvGkD1bLZDbXGceh
         BE8i4ZLnO3v0I3cZfku+kWF/gXEpJJbd20+wUnIi1Gb3T0htNxSalzMIcOLBCTL0zYKE
         kT4U02CMc9eMNRvvuWOBt3iY2DmUHV8evM5HMJr4QB3qdVMwVDvP+3I1F8fOlHaTir3s
         82uY9PuXTD+FGFUjAXzeWFciBBptLgauW5yrpuhRGmNMgR1rkuAnsKuLVD0NeJYViS22
         ChCNfUJO+VcA9ShcsV3qEBFVX6gyFYo4ll++8E68Sarnk8hjLmh0T+i7mp1q0dz72VDW
         TgIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gWw8pr/c6qQDp74PKwcrUz7UHUPDPno5aG6deS6EemM=;
        b=JG+jLE3a5jt5/rAjhZ/B3tC+uWVv2chYNE5Kr6qeLZZa/TmN4/6m5nsASObVngpOBA
         oe/O1SrctJG9pCoYiL5O30OEILsfADFJ2GRS17iyHtNNommwShzKU+u0HValrshE5jSv
         tycw+gQfQPvMi6XA2JxslCXcnf4XTgt2y3PkecvBv2KPWOcVQAyFL9ZtsACRv7phcg1J
         1Yhj1LPv6eDu05hMVmC8OOpXw3T6jqdcoytSIOzJRBQHLSj1IpqRoJn1uOv7kMH9U/hw
         86NwxSgsh5gdZK+RBYtckNir+Rg0VQ646puvKqlBTroJIcXrwbByJYEbAXlR893XmUKR
         1xeA==
X-Gm-Message-State: AOAM533PJ5UU5XvOgmZT4vgzzRwyiX4ujvwbd3SMnKHGRCvLf99aSei0
        3+Yez8rFCawlr12/bNvtYsw=
X-Google-Smtp-Source: ABdhPJxUVepXuAteGW5kgBtzDkaeOzmkHJHdujPY13/gI/OYCBAworZWBrB+bd/x2f2bbg2S3i2wkQ==
X-Received: by 2002:a5d:6dcc:: with SMTP id d12mr5023301wrz.136.1616614592535;
        Wed, 24 Mar 2021 12:36:32 -0700 (PDT)
Received: from localhost.localdomain (p200300f137001200428d5cfffeb99db8.dip0.t-ipconnect.de. [2003:f1:3700:1200:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id n3sm3573277wmi.7.2021.03.24.12.36.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 12:36:31 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     hauke@hauke-m.de, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH net] net: dsa: lantiq_gswip: Let GSWIP automatically set the xMII clock
Date:   Wed, 24 Mar 2021 20:36:04 +0100
Message-Id: <20210324193604.1433230-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The xMII interface clock depends on the PHY interface (MII, RMII, RGMII)
as well as the current link speed. Explicitly configure the GSWIP to
automatically select the appropriate xMII interface clock.

This fixes an issue seen by some users where ports using an external
RMII or RGMII PHY were deaf (no RX or TX traffic could be seen). Most
likely this is due to an "invalid" xMII clock being selected either by
the bootloader or hardware-defaults.

Fixes: 14fceff4771e51 ("net: dsa: Add Lantiq / Intel DSA driver for vrx200")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
It would be great to have this fix backported to Linux 5.4 and 5.10 to
get rid of one more blocker which prevents OpenWrt from switching to
this new in-tree driver.


 drivers/net/dsa/lantiq_gswip.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 52e865a3912c..809dfa3be6bb 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -799,10 +799,15 @@ static int gswip_setup(struct dsa_switch *ds)
 	/* Configure the MDIO Clock 2.5 MHz */
 	gswip_mdio_mask(priv, 0xff, 0x09, GSWIP_MDIO_MDC_CFG1);
 
-	/* Disable the xMII link */
-	for (i = 0; i < priv->hw_info->max_ports; i++)
+	for (i = 0; i < priv->hw_info->max_ports; i++) {
+		/* Disable the xMII link */
 		gswip_mii_mask_cfg(priv, GSWIP_MII_CFG_EN, 0, i);
 
+		/* Automatically select the xMII interface clock */
+		gswip_mii_mask_cfg(priv, GSWIP_MII_CFG_RATE_MASK,
+				   GSWIP_MII_CFG_RATE_AUTO, i);
+	}
+
 	/* enable special tag insertion on cpu port */
 	gswip_switch_mask(priv, 0, GSWIP_FDMA_PCTRL_STEN,
 			  GSWIP_FDMA_PCTRLp(cpu_port));
-- 
2.31.0

