Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39449460622
	for <lists+netdev@lfdr.de>; Sun, 28 Nov 2021 13:39:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357451AbhK1Mmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 07:42:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357368AbhK1Mkp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 07:40:45 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B60DAC06175A
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 04:37:22 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id k37-20020a05600c1ca500b00330cb84834fso14563466wms.2
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 04:37:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kryo-se.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LcBtqbRPkEcsZfTVxey43CZc666mGtsTaMbpCcH3s5g=;
        b=EFGSv3vr1jlJ/3OMklxcssKtiEGwrXuZR4CYy49g2ILzX8LCZv42cKGCrlgF94UaAR
         fJzYXAAHNBb0rJsfAuc0DYrr3AM7KMyuGTeCUEapqAzfvCQ6ub2bS4bq1NMHwZQRAo3c
         UYOzndMo+SQ7jD+XM6MMtVyJo1UfH2XO+jcqAakyvfrbmErRkhvy2cuqXiZynZeIHnUd
         K6M8trgx348nfu/shp7EacR2qsTamZx2vMKL0BwmAaUnlU0Zw5qwwBF6ZVSt1ARptJAI
         30gCfj+PQkYRad5Jt+lKq9suUS5kV9dAnrEkmt3DsBUkIcf5DK8EHepZYdOhdSKn2+Wy
         7idw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LcBtqbRPkEcsZfTVxey43CZc666mGtsTaMbpCcH3s5g=;
        b=k55v7o0y4ElH5nJZ3CvdLU5Y8WBi7UBmnOLUkRTEJdsie3ALBNR3iSKunu84x3eT4v
         iF+QpNVlQI0DLOwKoGn0B+Z04OBGi4FFAz/c0sf6B/vdU1/z63JvqMsLq8qvpENzSPm4
         q0UtrSHez9DtDUniI3aYDBDW7KbkMjzMuDCTkUg95eow2JhDd9HqbjjsRElgWjGEwCrx
         jtWDEzisD1BIB+xnJ8TLDf8mptI0s4Uf2Q+p38YO4duVkWagtfwVrAZp7S4mhN5/swHC
         xYkUTC5N44crps9/PAzbhrUFDEaCPWsGMQpOOdjhYwyWmm9p9a30/soRV252uVi24Whq
         6NJA==
X-Gm-Message-State: AOAM5329lyDspfwtJayE1tH1SM1tv2Ks43izaNlSnAKX40EmMCDTSHn+
        duCnCYLXTCePvuLthy2pYg24hg==
X-Google-Smtp-Source: ABdhPJzoYvlmfuiKv+WzJ+bzTDTdJ/1Ukqz8IBwpUamRawGyGPn7UwPf0/m9fhSyxaXJfWgNsb3osA==
X-Received: by 2002:a05:600c:3505:: with SMTP id h5mr28916296wmq.22.1638103041103;
        Sun, 28 Nov 2021 04:37:21 -0800 (PST)
Received: from kerfuffle.. ([2a02:168:9619:0:5497:3715:36d:f557])
        by smtp.gmail.com with ESMTPSA id y6sm16242178wma.37.2021.11.28.04.37.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Nov 2021 04:37:20 -0800 (PST)
From:   Erik Ekman <erik@kryo.se>
To:     Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Erik Ekman <erik@kryo.se>,
        Michael Stapelberg <michael@stapelberg.ch>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net/mlx4_en: Update reported link modes for 1/10G
Date:   Sun, 28 Nov 2021 13:37:11 +0100
Message-Id: <20211128123712.82096-1-erik@kryo.se>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When link modes were initially added in commit 2c762679435dc
("net/mlx4_en: Use PTYS register to query ethtool settings") and
later updated for the new ethtool API in commit 3d8f7cc78d0eb
("net: mlx4: use new ETHTOOL_G/SSETTINGS API") the only 1/10G non-baseT
link modes configured were 1000baseKX, 10000baseKX4 and 10000baseKR.
It looks like these got picked to represent other modes since nothing
better was available.

Switch to using more specific link modes added in commit 5711a98221443
("net: ethtool: add support for 1000BaseX and missing 10G link modes").

Tested with MCX311A-XCAT connected via DAC.
Before:

% sudo ethtool enp3s0
Settings for enp3s0:
	Supported ports: [ FIBRE ]
	Supported link modes:   1000baseKX/Full
	                        10000baseKR/Full
	Supported pause frame use: Symmetric Receive-only
	Supports auto-negotiation: No
	Supported FEC modes: Not reported
	Advertised link modes:  1000baseKX/Full
	                        10000baseKR/Full
	Advertised pause frame use: Symmetric
	Advertised auto-negotiation: No
	Advertised FEC modes: Not reported
	Speed: 10000Mb/s
	Duplex: Full
	Auto-negotiation: off
	Port: Direct Attach Copper
	PHYAD: 0
	Transceiver: internal
	Supports Wake-on: d
	Wake-on: d
        Current message level: 0x00000014 (20)
                               link ifdown
	Link detected: yes

With this change:

% sudo ethtool enp3s0
	Settings for enp3s0:
	Supported ports: [ FIBRE ]
	Supported link modes:   1000baseX/Full
	                        10000baseCR/Full
 	                        10000baseSR/Full
	Supported pause frame use: Symmetric Receive-only
	Supports auto-negotiation: No
	Supported FEC modes: Not reported
	Advertised link modes:  1000baseX/Full
 	                        10000baseCR/Full
 	                        10000baseSR/Full
	Advertised pause frame use: Symmetric
	Advertised auto-negotiation: No
	Advertised FEC modes: Not reported
	Speed: 10000Mb/s
	Duplex: Full
	Auto-negotiation: off
	Port: Direct Attach Copper
	PHYAD: 0
	Transceiver: internal
	Supports Wake-on: d
	Wake-on: d
        Current message level: 0x00000014 (20)
                               link ifdown
	Link detected: yes

Tested-by: Michael Stapelberg <michael@stapelberg.ch>
Signed-off-by: Erik Ekman <erik@kryo.se>
---
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
index 066d79e4ecfc..10238bedd694 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
@@ -670,7 +670,7 @@ void __init mlx4_en_init_ptys2ethtool_map(void)
 	MLX4_BUILD_PTYS2ETHTOOL_CONFIG(MLX4_1000BASE_T, SPEED_1000,
 				       ETHTOOL_LINK_MODE_1000baseT_Full_BIT);
 	MLX4_BUILD_PTYS2ETHTOOL_CONFIG(MLX4_1000BASE_CX_SGMII, SPEED_1000,
-				       ETHTOOL_LINK_MODE_1000baseKX_Full_BIT);
+				       ETHTOOL_LINK_MODE_1000baseX_Full_BIT);
 	MLX4_BUILD_PTYS2ETHTOOL_CONFIG(MLX4_1000BASE_KX, SPEED_1000,
 				       ETHTOOL_LINK_MODE_1000baseKX_Full_BIT);
 	MLX4_BUILD_PTYS2ETHTOOL_CONFIG(MLX4_10GBASE_T, SPEED_10000,
@@ -682,9 +682,9 @@ void __init mlx4_en_init_ptys2ethtool_map(void)
 	MLX4_BUILD_PTYS2ETHTOOL_CONFIG(MLX4_10GBASE_KR, SPEED_10000,
 				       ETHTOOL_LINK_MODE_10000baseKR_Full_BIT);
 	MLX4_BUILD_PTYS2ETHTOOL_CONFIG(MLX4_10GBASE_CR, SPEED_10000,
-				       ETHTOOL_LINK_MODE_10000baseKR_Full_BIT);
+				       ETHTOOL_LINK_MODE_10000baseCR_Full_BIT);
 	MLX4_BUILD_PTYS2ETHTOOL_CONFIG(MLX4_10GBASE_SR, SPEED_10000,
-				       ETHTOOL_LINK_MODE_10000baseKR_Full_BIT);
+				       ETHTOOL_LINK_MODE_10000baseSR_Full_BIT);
 	MLX4_BUILD_PTYS2ETHTOOL_CONFIG(MLX4_20GBASE_KR2, SPEED_20000,
 				       ETHTOOL_LINK_MODE_20000baseMLD2_Full_BIT,
 				       ETHTOOL_LINK_MODE_20000baseKR2_Full_BIT);
-- 
2.33.1

