Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAFE06F3534
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 19:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232234AbjEARsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 13:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbjEARsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 13:48:11 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E752E10C6;
        Mon,  1 May 2023 10:48:09 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-506b2a08877so4962926a12.2;
        Mon, 01 May 2023 10:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682963288; x=1685555288;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qI1N6Zt1ichZ6d+bawiKp7X6Hia786Ixe1XzJA/8a1M=;
        b=lmE7WGlLGrME4epC57gTjPU0aUj16Grms5aQKdEtvi90ImHoewFujkBINSKYc9GXXI
         hvz+21dt6GXQsWG3BteSk9p1bJMqRVoEYZ/GRlR0jc6qjZArII9vyr0D3TvQpsrW764a
         iHeMjvuy/hr2cU6R1Au5Gc2pmHtgasxTWFSXf+oO0LpECeK+LRzaatwTRmvUBpTVO6JX
         9ir44g/tp/E0zr3w7zx8NO551T/d31QC4Kl7U3hQF5kvP4x8Q4r0Z4A4+MRqADFkv2Vv
         F6/k992ug7yMHiBnYIPgifHZb+ZUdJ6pJ6Q/MtPMd0jSB62S7LP+BlV1xuUJWnUp2aYA
         cZqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682963288; x=1685555288;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qI1N6Zt1ichZ6d+bawiKp7X6Hia786Ixe1XzJA/8a1M=;
        b=iXVWSbKAB/sdTZ4kitPBGMG5mri8/XsqaD4sb5MZgleJlXCReLV1koLKr8BffzpztB
         vhQZOFQbTlrahpFvvqljTqRMiDnpcPglIp0SxbjcnotlAH8FZOW4S567jefJrA2rn6Qo
         ZbyiUlhLiKl0OEhErr8KtFTNFrVJfKeNjkzfTat60sokaiKMIhrw9qAzL8s8aH68QAfl
         9N1Kul3jYqIlQtM7J7kduzUQHdSYMCaIHi86G/dyYtwX3Ub3YwRgyllfhyhtzMvX8kSX
         xpL+i3/UVxNRICOipVKiSJwUhRchf9Qj1azPxN85rk51V/fHEd04v0dYxj5QmoEQ6EAh
         1IOw==
X-Gm-Message-State: AC+VfDx09leCry4FK+GJLOiHUtdHUxQCmHWih26ja0O2ZVMeHs73ajG7
        c3PGpViGpjUlCiUu/3Frjz0=
X-Google-Smtp-Source: ACHHUZ51gmO+BlobpsctJj4Kl2cSXLWvxQ/F9MjBGUzNp9G/uelXavA5/b6R7ImxR6gMX7nKRSnn1w==
X-Received: by 2002:a17:907:c23:b0:94f:2852:1d2b with SMTP id ga35-20020a1709070c2300b0094f28521d2bmr13090056ejc.72.1682963288063;
        Mon, 01 May 2023 10:48:08 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id se20-20020a170907a39400b0095ef737dbd7sm7745282ejc.93.2023.05.01.10.48.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 May 2023 10:48:07 -0700 (PDT)
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
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
Cc:     =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Bartel Eerdekens <bartel.eerdekens@constell8.be>,
        Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        mithat.guner@xeront.com, erkin.bozoglu@xeront.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH v2 net 1/2] net: dsa: mt7530: fix corrupt frames using trgmii on 40 MHz XTAL MT7621
Date:   Mon,  1 May 2023 20:47:42 +0300
Message-Id: <20230501174743.95897-1-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.39.2
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
2.39.2

