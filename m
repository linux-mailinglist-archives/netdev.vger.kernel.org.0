Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44D0743403E
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 23:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbhJSVQH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 17:16:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbhJSVQG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 17:16:06 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E301C06161C
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 14:13:53 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id v127so14478666wme.5
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 14:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kryo-se.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=l6gE86fggrp1Bnsb8sfug4v8+vo2kGXRhPZjmGdtdj8=;
        b=443ImPeqZVoO+mnnRDQWXv2tldarNEL3aBGVlnJu5/7F0YPVsWcHIkVJE9/+lTH4sX
         HKsMRVssZ7FkJrSQlL+NoihR4roGZeSmSb8xTZoB7ffcyWvI9pWFzSOUt4qE9aWKR7D8
         69Gmhmf6/7umXY/DL7PWu7ololEsJF49aLOWDWRe87t4/k2tcn7j8jo1TQ2asZ5Akdda
         UtX+g4RZ9RAYOAZQGbGvZA0VMfZG+wt8tKQPO08dSMh2QR4Tdf7bBFh+UkmKbLhNtC86
         OcRx0SlgjhVf/powEczo+KOVCvuuKDFPiBXMNUj+6TVyMPXwRTQmeDDlyYRAHG1VBAFA
         H/8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=l6gE86fggrp1Bnsb8sfug4v8+vo2kGXRhPZjmGdtdj8=;
        b=Ul8TLqMLCdtJiKSVj941vniD2opbR+jplrH2cCdq2Hgnm6JEZUEzjh8nNGZkaiFhP+
         smkHTEx2c2bddSgFfn18H6LGElga33NnC3HvHgSc1NMNW/eUWmXfOXYtbF7DAIRV1YMP
         7yi+yBpVS8ERa9vsGkU2h6YvNsJ3W0b+VxIHOHIUv2v1H2tT6sBXbQUNA7jrhtaCN6Na
         hKNPiUbfpwL3BDyzqJUm4/ZO6EltxMkVFr592REbN0RfI8fQKaCVXq662e3Yc3l7652+
         CAC3uX6Td3EhqT20ioZH8ah8d0SaDc+RZ8b+y3WUIgejijbq/RYEJdSvSI9a+i8ab7Rl
         ENVw==
X-Gm-Message-State: AOAM530v74ZcoKyeSJfab6WKZ57wuc5asdYz8Z89RBQ0oRxBMJUJUSQG
        3gpdBiTqVqIj5W/AhmMTRDEJ2g==
X-Google-Smtp-Source: ABdhPJzTAOhGml9ZLIhKYSNUfQC7ft8zX+Im9HeR0z90hZbniLjpxkYn9q+5OM1EmSBmNYv1iHD98A==
X-Received: by 2002:adf:a34b:: with SMTP id d11mr46398025wrb.107.1634678031406;
        Tue, 19 Oct 2021 14:13:51 -0700 (PDT)
Received: from kerfuffle.. ([2a02:168:9619:0:e47f:e8d:2259:ad13])
        by smtp.gmail.com with ESMTPSA id v13sm100929wrs.53.2021.10.19.14.13.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 14:13:50 -0700 (PDT)
From:   Erik Ekman <erik@kryo.se>
To:     Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Erik Ekman <erik@kryo.se>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] sfc: Export fibre-specific supported link modes
Date:   Tue, 19 Oct 2021 23:13:32 +0200
Message-Id: <20211019211333.19494-1-erik@kryo.se>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 1/10GbaseT modes were set up for cards with SFP+ cages in
3497ed8c852a5 ("sfc: report supported link speeds on SFP connections").
10GbaseT was likely used since no 10G fibre mode existed.

The missing fibre modes for 1/10G were added to ethtool.h in 5711a9822144
("net: ethtool: add support for 1000BaseX and missing 10G link modes")
shortly thereafter.

The user guide available at https://support-nic.xilinx.com/wp/drivers
lists support for the following cable and transceiver types in section 2.9:
- QSFP28 100G Direct Attach Cables
- QSFP28 100G SR Optical Transceivers (with SR4 modules listed)
- SFP28 25G Direct Attach Cables
- SFP28 25G SR Optical Transceivers
- QSFP+ 40G Direct Attach Cables
- QSFP+ 40G Active Optical Cables
- QSFP+ 40G SR4 Optical Transceivers
- QSFP+ to SFP+ Breakout Direct Attach Cables
- QSFP+ to SFP+ Breakout Active Optical Cables
- SFP+ 10G Direct Attach Cables
- SFP+ 10G SR Optical Transceivers
- SFP+ 10G LR Optical Transceivers
- SFP 1000BASE‐T Transceivers
- 1G Optical Transceivers
(From user guide issue 28. Issue 16 which also includes older cards like
SFN5xxx/SFN6xxx has matching lists for 1/10/40G transceiver types.)

Regarding SFP+ 10GBASE‐T transceivers the latest guide says:
"Solarflare adapters do not support 10GBASE‐T transceiver modules."

Tested using SFN5122F-R7 (with 2 SFP+ ports). Supported link modes do not change
depending on module used (tested with 1000BASE-T, 1000BASE-BX10, 10GBASE-LR).
Before:

$ ethtool ext
Settings for ext:
	Supported ports: [ FIBRE ]
	Supported link modes:   1000baseT/Full
	                        10000baseT/Full
	Supported pause frame use: Symmetric Receive-only
	Supports auto-negotiation: No
	Supported FEC modes: Not reported
	Advertised link modes:  Not reported
	Advertised pause frame use: No
	Advertised auto-negotiation: No
	Advertised FEC modes: Not reported
	Link partner advertised link modes:  Not reported
	Link partner advertised pause frame use: No
	Link partner advertised auto-negotiation: No
	Link partner advertised FEC modes: Not reported
	Speed: 1000Mb/s
	Duplex: Full
	Auto-negotiation: off
	Port: FIBRE
	PHYAD: 255
	Transceiver: internal
        Current message level: 0x000020f7 (8439)
                               drv probe link ifdown ifup rx_err tx_err hw
	Link detected: yes

After:

$ ethtool ext
Settings for ext:
	Supported ports: [ FIBRE ]
	Supported link modes:   1000baseT/Full
	                        1000baseX/Full
	                        10000baseCR/Full
	                        10000baseSR/Full
	                        10000baseLR/Full
	Supported pause frame use: Symmetric Receive-only
	Supports auto-negotiation: No
	Supported FEC modes: Not reported
	Advertised link modes:  Not reported
	Advertised pause frame use: No
	Advertised auto-negotiation: No
	Advertised FEC modes: Not reported
	Link partner advertised link modes:  Not reported
	Link partner advertised pause frame use: No
	Link partner advertised auto-negotiation: No
	Link partner advertised FEC modes: Not reported
	Speed: 1000Mb/s
	Duplex: Full
	Auto-negotiation: off
	Port: FIBRE
	PHYAD: 255
	Transceiver: internal
	Supports Wake-on: g
	Wake-on: d
        Current message level: 0x000020f7 (8439)
                               drv probe link ifdown ifup rx_err tx_err hw
	Link detected: yes

Signed-off-by: Erik Ekman <erik@kryo.se>
---
 drivers/net/ethernet/sfc/mcdi_port_common.c | 37 +++++++++++++++------
 1 file changed, 26 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/sfc/mcdi_port_common.c b/drivers/net/ethernet/sfc/mcdi_port_common.c
index 4bd3ef8f3384..c4fe3c48ac46 100644
--- a/drivers/net/ethernet/sfc/mcdi_port_common.c
+++ b/drivers/net/ethernet/sfc/mcdi_port_common.c
@@ -132,16 +132,27 @@ void mcdi_to_ethtool_linkset(u32 media, u32 cap, unsigned long *linkset)
 	case MC_CMD_MEDIA_SFP_PLUS:
 	case MC_CMD_MEDIA_QSFP_PLUS:
 		SET_BIT(FIBRE);
-		if (cap & (1 << MC_CMD_PHY_CAP_1000FDX_LBN))
+		if (cap & (1 << MC_CMD_PHY_CAP_1000FDX_LBN)) {
 			SET_BIT(1000baseT_Full);
-		if (cap & (1 << MC_CMD_PHY_CAP_10000FDX_LBN))
-			SET_BIT(10000baseT_Full);
-		if (cap & (1 << MC_CMD_PHY_CAP_40000FDX_LBN))
+			SET_BIT(1000baseX_Full);
+		}
+		if (cap & (1 << MC_CMD_PHY_CAP_10000FDX_LBN)) {
+			SET_BIT(10000baseCR_Full);
+			SET_BIT(10000baseLR_Full);
+			SET_BIT(10000baseSR_Full);
+		}
+		if (cap & (1 << MC_CMD_PHY_CAP_40000FDX_LBN)) {
 			SET_BIT(40000baseCR4_Full);
-		if (cap & (1 << MC_CMD_PHY_CAP_100000FDX_LBN))
+			SET_BIT(40000baseSR4_Full);
+		}
+		if (cap & (1 << MC_CMD_PHY_CAP_100000FDX_LBN)) {
 			SET_BIT(100000baseCR4_Full);
-		if (cap & (1 << MC_CMD_PHY_CAP_25000FDX_LBN))
+			SET_BIT(100000baseSR4_Full);
+		}
+		if (cap & (1 << MC_CMD_PHY_CAP_25000FDX_LBN)) {
 			SET_BIT(25000baseCR_Full);
+			SET_BIT(25000baseSR_Full);
+		}
 		if (cap & (1 << MC_CMD_PHY_CAP_50000FDX_LBN))
 			SET_BIT(50000baseCR2_Full);
 		break;
@@ -192,15 +203,19 @@ u32 ethtool_linkset_to_mcdi_cap(const unsigned long *linkset)
 		result |= (1 << MC_CMD_PHY_CAP_100FDX_LBN);
 	if (TEST_BIT(1000baseT_Half))
 		result |= (1 << MC_CMD_PHY_CAP_1000HDX_LBN);
-	if (TEST_BIT(1000baseT_Full) || TEST_BIT(1000baseKX_Full))
+	if (TEST_BIT(1000baseT_Full) || TEST_BIT(1000baseKX_Full) ||
+			TEST_BIT(1000baseX_Full))
 		result |= (1 << MC_CMD_PHY_CAP_1000FDX_LBN);
-	if (TEST_BIT(10000baseT_Full) || TEST_BIT(10000baseKX4_Full))
+	if (TEST_BIT(10000baseT_Full) || TEST_BIT(10000baseKX4_Full) ||
+			TEST_BIT(10000baseCR_Full) || TEST_BIT(10000baseLR_Full) ||
+			TEST_BIT(10000baseSR_Full))
 		result |= (1 << MC_CMD_PHY_CAP_10000FDX_LBN);
-	if (TEST_BIT(40000baseCR4_Full) || TEST_BIT(40000baseKR4_Full))
+	if (TEST_BIT(40000baseCR4_Full) || TEST_BIT(40000baseKR4_Full) ||
+			TEST_BIT(40000baseSR4_Full))
 		result |= (1 << MC_CMD_PHY_CAP_40000FDX_LBN);
-	if (TEST_BIT(100000baseCR4_Full))
+	if (TEST_BIT(100000baseCR4_Full) || TEST_BIT(100000baseSR4_Full))
 		result |= (1 << MC_CMD_PHY_CAP_100000FDX_LBN);
-	if (TEST_BIT(25000baseCR_Full))
+	if (TEST_BIT(25000baseCR_Full) || TEST_BIT(25000baseSR_Full))
 		result |= (1 << MC_CMD_PHY_CAP_25000FDX_LBN);
 	if (TEST_BIT(50000baseCR2_Full))
 		result |= (1 << MC_CMD_PHY_CAP_50000FDX_LBN);
-- 
2.31.1

