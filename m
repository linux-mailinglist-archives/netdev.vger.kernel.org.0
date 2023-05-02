Return-Path: <netdev+bounces-23-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B9DE06F4BE3
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 23:10:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B6F721C209BB
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 21:10:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EA89A928;
	Tue,  2 May 2023 21:10:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31591944C
	for <netdev@vger.kernel.org>; Tue,  2 May 2023 21:10:17 +0000 (UTC)
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E36BC170F;
	Tue,  2 May 2023 14:10:13 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id 4fb4d7f45d1cf-50bcae898b2so3966123a12.0;
        Tue, 02 May 2023 14:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683061812; x=1685653812;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TCKW3GcfxPXY7mkB6iKCrbvfraXmwfBiRi821WTxUyg=;
        b=J9p1R7S+L42qJOIxO6GBgRityXwTaHOK0sN1u1gr+Y0AFRQSdDM8XEGBb29sCrpCtv
         WodQ2uzEBRGGliynmStoU8rUIRDAHGJ2+tgeGeQ03q9L5cJT70AKcVoc/cD8rIaTwmYo
         WEIS9VOCQMNbLyqbcsVkS+9vpEW50W6vpqiov/gH4LozJV2Vs9JlV10ARrXTQHnh0nnj
         +aoy77JBfPG+93JU57uR8MmEua+aXMrIv+Tb6HrzY0yDdsGXSuvrgFrIbaLRvZcxbvOq
         LcpWVZ6p0BrG1WOUR+tnnrjsOXN7KCU+sO/dpEoRrojJi9vhppc1Ge/LkJXLEImYzJZF
         OqTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683061812; x=1685653812;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TCKW3GcfxPXY7mkB6iKCrbvfraXmwfBiRi821WTxUyg=;
        b=BatjHIPan0mtzdEojjtHR4WakwIT4Hl+6HHQs0L7Y/8arYKT2ntB9dqVi8Rk2nXWac
         ph6YqnyWQljV1TBXhagm4nOFUJXSv5J1XcJDQ7W35RFiGV47ZdpyB1x8tmCPqAZRv/Js
         tLhIsHaFeqjjxk4lN2bp3npanKJNgJAF4gwa8h84+ggv7AaHLLFdDXbjot1IMc+a2zgO
         VbbDc3GfjOE7KCPWNkho1n4ldk3NAOTzGvBs9pqVAsQEapkAhC5ZLunQc6k8OWVoivEp
         NZTpGKmNjx7cR3/A2IUWqNAWbk884jhwaD9c5iXY3dLiFFzDFF++hLi41fUmyHcEY3ki
         K9Aw==
X-Gm-Message-State: AC+VfDwj8UkxJIn1DaHYDzeKrrfSGARCUSOXidgd30gGbpWic+vI83FP
	AwKDUId4OhK++t14cgGTKjk=
X-Google-Smtp-Source: ACHHUZ5giVFQBJDdgxXGEeryqm1QPaPTd/U+SD3+3it7wKm+bC42p+sg5P+s40TGBPKTwJ/m8HoR7w==
X-Received: by 2002:aa7:de11:0:b0:50b:c981:1fc7 with SMTP id h17-20020aa7de11000000b0050bc9811fc7mr5680216edv.19.1683061812116;
        Tue, 02 May 2023 14:10:12 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id a24-20020a50ff18000000b0050bd19ec39bsm1178620edu.83.2023.05.02.14.10.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 14:10:11 -0700 (PDT)
From: arinc9.unal@gmail.com
X-Google-Original-From: arinc.unal@arinc9.com
To: Sean Wang <sean.wang@mediatek.com>,
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
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	=?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
Cc: =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
	Bartel Eerdekens <bartel.eerdekens@constell8.be>,
	Richard van Schagen <richard@routerhints.com>,
	Richard van Schagen <vschagen@cs.com>,
	Frank Wunderlich <frank-w@public-files.de>,
	mithat.guner@xeront.com,
	erkin.bozoglu@xeront.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH v3 net 1/2] net: dsa: mt7530: fix corrupt frames using trgmii on 40 MHz XTAL MT7621
Date: Wed,  3 May 2023 00:09:46 +0300
Message-Id: <20230502210947.6815-1-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

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
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---

v3: Remove my tested-by tag as Florian pointed out it's implied with my
signed-off-by tag. Add Florian's reviewed-by tag.

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


