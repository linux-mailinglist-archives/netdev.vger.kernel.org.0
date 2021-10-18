Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA49043268D
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 20:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232171AbhJRSj4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 14:39:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231590AbhJRSjz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 14:39:55 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B0A6C06161C
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 11:37:44 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 63-20020a1c0042000000b0030d60716239so93283wma.4
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 11:37:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kryo-se.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7hfYG9ngN44n8cK8yaU0t5TJm8OEoNDtrTeVqiPoS4I=;
        b=EqLhAXgEh92tFGr5kjK32t76DTlz+yMUUz3jHLk+X1fkwEESsHZescMt+GcyiZGu0E
         xk12D07vdi1OBfDol6ltIk6bMRCz1jGNcpf/qkliIuG9JSKuWTpmaCQMzy0nKfLNTt3t
         L+moys2I97dsm3SL7GCtsduzLY2lGRH+J7MvnGfVS9/xVDT1aOFKxWE6abBlzNNusTvP
         vptWeG8qLqUUJKF9exuWgzmCah0jQFbMKzxd39eOeXfpiFdssEcYHa33CYo8JXsCyFra
         ticuoiE1QIUdHlF1/LcASoK9izea58aFZcJA2o8pXHaCYHh50AaKjhR8m6yNbUUKF5gM
         63TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7hfYG9ngN44n8cK8yaU0t5TJm8OEoNDtrTeVqiPoS4I=;
        b=5ymAJmb8R0utgsroM8wpMz7Z47CyV/HNcB4HsiVeFeW4riE/ItzABpjORwWK3e6nNM
         R8lvkY2Pr0hQpQcoWlgq4BUm66Gj1/o8HCHE1s73So3eEdEzcpDwv5/kdJ61iCdYk+n+
         8T7iJJbFOaVlULVx5tv2k8krdMkftqqS56n/WqPbbhQC0USKtXctPVK1eE4mAsbdZYr1
         G6qmyGJKIeNh41/9dFuQAxej62O2UMtC1WYoCF6pIDw9/t0q6XJAVyMCF5xPPQGnT6ly
         U+hT61qtlWhZGyXKtYphpA7minTpuRz0j1/tK6JoG5IcOw/c+CoN3Fj9UpQv2+UbrPEU
         joHg==
X-Gm-Message-State: AOAM532r8xvJWGZEAMoNWtbMrCRZBegiVYw/rSugt/q4tiJnYdMkgZUD
        pHb/EJq4DwVeZELLGpQ0/oLyig==
X-Google-Smtp-Source: ABdhPJxhh9XAYMwsqbdaS0Fb7BOKQmxT0jNrLc8s2ru4Ve4AQJHIStAqWyJrDxLBMlG0C3kCtvEfFQ==
X-Received: by 2002:a7b:c856:: with SMTP id c22mr627144wml.178.1634582262201;
        Mon, 18 Oct 2021 11:37:42 -0700 (PDT)
Received: from kerfuffle.. ([2a02:168:9619:0:5497:3715:36d:f557])
        by smtp.gmail.com with ESMTPSA id n1sm195958wmi.30.2021.10.18.11.37.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 11:37:41 -0700 (PDT)
From:   Erik Ekman <erik@kryo.se>
To:     Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Erik Ekman <erik@kryo.se>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] sfc: Export fibre-specific link modes for 1/10G
Date:   Mon, 18 Oct 2021 20:37:08 +0200
Message-Id: <20211018183709.124744-1-erik@kryo.se>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These modes were added to ethtool.h in 5711a98221443 ("net: ethtool: add support
for 1000BaseX and missing 10G link modes") back in 2016.

Only setting CR mode for 10G, similar to how 25/40/50/100G modes are set up.

Tested using SFN5122F-R7 (with 2 SFP+ ports) and a 1000BASE-BX10 SFP module.
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
	Supported link modes:   1000baseX/Full
	                        10000baseCR/Full
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
 drivers/net/ethernet/sfc/mcdi_port_common.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/sfc/mcdi_port_common.c b/drivers/net/ethernet/sfc/mcdi_port_common.c
index 4bd3ef8f3384..e84cdcb6a595 100644
--- a/drivers/net/ethernet/sfc/mcdi_port_common.c
+++ b/drivers/net/ethernet/sfc/mcdi_port_common.c
@@ -133,9 +133,9 @@ void mcdi_to_ethtool_linkset(u32 media, u32 cap, unsigned long *linkset)
 	case MC_CMD_MEDIA_QSFP_PLUS:
 		SET_BIT(FIBRE);
 		if (cap & (1 << MC_CMD_PHY_CAP_1000FDX_LBN))
-			SET_BIT(1000baseT_Full);
+			SET_BIT(1000baseX_Full);
 		if (cap & (1 << MC_CMD_PHY_CAP_10000FDX_LBN))
-			SET_BIT(10000baseT_Full);
+			SET_BIT(10000baseCR_Full);
 		if (cap & (1 << MC_CMD_PHY_CAP_40000FDX_LBN))
 			SET_BIT(40000baseCR4_Full);
 		if (cap & (1 << MC_CMD_PHY_CAP_100000FDX_LBN))
@@ -192,9 +192,11 @@ u32 ethtool_linkset_to_mcdi_cap(const unsigned long *linkset)
 		result |= (1 << MC_CMD_PHY_CAP_100FDX_LBN);
 	if (TEST_BIT(1000baseT_Half))
 		result |= (1 << MC_CMD_PHY_CAP_1000HDX_LBN);
-	if (TEST_BIT(1000baseT_Full) || TEST_BIT(1000baseKX_Full))
+	if (TEST_BIT(1000baseT_Full) || TEST_BIT(1000baseKX_Full) ||
+	    TEST_BIT(1000baseX_Full))
 		result |= (1 << MC_CMD_PHY_CAP_1000FDX_LBN);
-	if (TEST_BIT(10000baseT_Full) || TEST_BIT(10000baseKX4_Full))
+	if (TEST_BIT(10000baseT_Full) || TEST_BIT(10000baseKX4_Full) ||
+	    TEST_BIT(10000baseCR_Full))
 		result |= (1 << MC_CMD_PHY_CAP_10000FDX_LBN);
 	if (TEST_BIT(40000baseCR4_Full) || TEST_BIT(40000baseKR4_Full))
 		result |= (1 << MC_CMD_PHY_CAP_40000FDX_LBN);
-- 
2.31.1

