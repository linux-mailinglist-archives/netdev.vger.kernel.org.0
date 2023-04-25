Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4DC56EDE02
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 10:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233664AbjDYIaB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 04:30:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233672AbjDYI35 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 04:29:57 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7624D40E0;
        Tue, 25 Apr 2023 01:29:56 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id a640c23a62f3a-94f7a0818aeso813914266b.2;
        Tue, 25 Apr 2023 01:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682411395; x=1685003395;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LaUHbduLvT7VglteyNVg17dxlefVbbFzI2gkZnIc6Vo=;
        b=RNg4TxdpaoPZ75DhJpNTUsxQOiUNBEwwOvkaIQWV8Rxmv/cHH1Dc82zums7p9O3nRc
         vAZxcKkZn+OEy45IZctFwMls7KpJ5HjXE3g6otBXRmxU2d+0Lo3vz8aNIYKc26tjQXVy
         sBaB3/y8BGC2+G1lEhFDNqiHd2nk0ybFiccl6vbt8F0YP9Z0Pj42VzNzg6OOQyVxRdz9
         /WsI1HJw8kHWsjgsIT3dJeQcGSqzCgNAttBIFba4LAk79cYqE3iS2my2tSCtAqg320ik
         pAz6D0wVmNdovtJqEpLGlpEUu7ug9cIb1mtFcy1MzC/jSsss1hYlRZkGNfpYC+mGICgV
         B60g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682411395; x=1685003395;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LaUHbduLvT7VglteyNVg17dxlefVbbFzI2gkZnIc6Vo=;
        b=PwnTzRQwPQhnVKlmEiyiFEfp4wxQRsJE9+v43ewhrUdCEHgFH12bE9j56Hk9CCFnzl
         cughSyHVLmztdutFjsrq7lHCwCixITalEOU1Iyu/BbYrGDMlGY3bl9MB6kXqyhY/aSSD
         5G4XZTqi992W9WZ14jJRFEvm8Aht6dKRR9up5lAAf0GKf5bz76TBrxP4qPbuIr/XtORs
         MvP4ESal5eRJIkXSA1jbcX9xjhZopcF4Yme9jY0kgcYo3pbTrE97d9FLvt4CILuWTptZ
         Qd1rQVW1kT7ublvXMsWpW+trt7s39GvgD9ZOwqBYdsz6VU/24QDmFXWt2nYBJTki1EBt
         DE6g==
X-Gm-Message-State: AAQBX9emQ6swCXkUlNcxPnRfR50AuYHEGolnTDEEYFHbXQXTyPlgDFaJ
        odNaA/2PUN0u9bwzNkjFOs0=
X-Google-Smtp-Source: AKy350Yap/bGcpQf2xq4sCbut3Oh2Si3tTlDY/j7jrRF8KfM8Fk4Vn3KlifqbJVaeCl1FeMEUphp1w==
X-Received: by 2002:a17:906:300b:b0:951:756d:6542 with SMTP id 11-20020a170906300b00b00951756d6542mr13114494ejz.32.1682411394759;
        Tue, 25 Apr 2023 01:29:54 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id mc2-20020a170906eb4200b0094ca077c985sm6439028ejb.213.2023.04.25.01.29.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 01:29:54 -0700 (PDT)
From:   arinc9.unal@gmail.com
X-Google-Original-From: arinc.unal@arinc9.com
To:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        stable@vger.kernel.org,
        Bartel Eerdekens <bartel.eerdekens@constell8.be>,
        Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH net-next 01/24] net: dsa: mt7530: fix corrupt frames using trgmii on 40 MHz XTAL MT7621
Date:   Tue, 25 Apr 2023 11:29:10 +0300
Message-Id: <20230425082933.84654-2-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230425082933.84654-1-arinc.unal@arinc9.com>
References: <20230425082933.84654-1-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arınç ÜNAL <arinc.unal@arinc9.com>

The multi-chip module MT7530 switch with a 40 MHz oscillator on the
MT7621AT, MT7621DAT, and MT7621ST SoCs forwards corrupt frames using
trgmii.

This is caused by the assumption that MT7621 SoCs have got 150 MHz PLL,
hence using the ncpo1 value, 0x0780.

My testing shows this value works on Unielec U7621-06, Bartel's testing
shows it won't work on Hi-Link HLK-MT7621A and Netgear WAC104. All devices
tested have got 40 MHz oscillators.

Using the value for 125 MHz PLL, 0x0640, works on all boards at hand. The
definitions for 125 MHz PLL exist on the Banana Pi BPI-R2 BSP source code
whilst 150 MHz PLL don't.

Forwarding frames using trgmii on the MCM MT7530 switch with a 25 MHz
oscillator on the said MT7621 SoCs works fine because the ncpo1 value
defined for it is for 125 MHz PLL.

Change the 150 MHz PLL comment to 125 MHz PLL, and use the 125 MHz PLL
ncpo1 values for both oscillator frequencies.

Link: https://github.com/BPI-SINOVOIP/BPI-R2-bsp/blob/81d24bbce7d99524d0771a8bdb2d6663e4eb4faa/u-boot-mt/drivers/net/rt2880_eth.c#L2195
Fixes: 7ef6f6f8d237 ("net: dsa: mt7530: Add MT7621 TRGMII mode support")
Cc: stable@vger.kernel.org
Tested-by: Bartel Eerdekens <bartel.eerdekens@constell8.be>
Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index c680873819b0..7d9f9563dbda 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -426,9 +426,9 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
 		else
 			ssc_delta = 0x87;
 		if (priv->id == ID_MT7621) {
-			/* PLL frequency: 150MHz: 1.2GBit */
+			/* PLL frequency: 125MHz: 1.0GBit */
 			if (xtal == HWTRAP_XTAL_40MHZ)
-				ncpo1 = 0x0780;
+				ncpo1 = 0x0640;
 			if (xtal == HWTRAP_XTAL_25MHZ)
 				ncpo1 = 0x0a00;
 		} else { /* PLL frequency: 250MHz: 2.0Gbit */
-- 
2.37.2

