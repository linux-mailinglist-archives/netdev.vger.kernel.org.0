Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDC0E6F30C9
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 14:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232303AbjEAMQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 08:16:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231779AbjEAMQM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 08:16:12 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B305191;
        Mon,  1 May 2023 05:16:11 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-50bc040c7b8so2516553a12.2;
        Mon, 01 May 2023 05:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682943370; x=1685535370;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qI1N6Zt1ichZ6d+bawiKp7X6Hia786Ixe1XzJA/8a1M=;
        b=YOy1OVoDmGMAcGUMIcWF2hdmky++kfkclWbsQbcd5HvhRPG2ka/PUqk4aTMOWZOStm
         drsyktoUYykaTyW+2h57sj2Nz+oD9IlI0nxg9/vfkbbMZOVHc+at5L6clRiJj/bW8vzk
         66jIrEwk6Ad1lV1ZTNKDJNrTDh3yXazf45BvOmHXJcjo5gbs5hb7qZyYQjTd9Uq5qE11
         c6DgLBrGeVDzA1TjfJdsW6hTIzx7gjomxyB4M3Tu02EXXJVU8yLki8FQJ7TwhXo7g1ni
         UTJvnpyKo65OMy2ObU5qG7AbT78WhRXm9MSrq4ahp1xYY1X/PPEpiVjEAE5boULh7QuP
         cImQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682943370; x=1685535370;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qI1N6Zt1ichZ6d+bawiKp7X6Hia786Ixe1XzJA/8a1M=;
        b=ZawjRt9JNrhgIjKPLdC2+5OEcZE3XpeUE7ssqY+JFa1zSCGsXqldY5aFzax3x3yJkj
         7YoLOxfzMOsWqj0CwnoYIcl6tJZXx7mzXFzTaG2CD5apJapScbiLmVvDLYwSqj+xRas3
         3HAvDdlqH/9YvVRn1LVWCfNIC2yw0qwmCqEFBLVIppKRodSwuKJZQKLeEuG/DnVEwVji
         wyvW5d3szyft0akxX4Q8qyjd6j/6jl1El4IdNd31Z9D3PySaHzagoVt9AzQuUvP/jxyU
         pGsja8aBLlqWCYjT3sAUA843i+pfbQQ2rSIONEaPhr8df1G7mVMEBifjRYP66NaaYG6g
         fvOA==
X-Gm-Message-State: AC+VfDx6ze+9LJxDQQ215GM+lwi1Gsxn51ZamA1QMISj7WWZ6JRPmgCd
        erQd9Z1fxfMbU37LdxsmUYU=
X-Google-Smtp-Source: ACHHUZ42ywzxk8pSiGJuLh3/VyXM5Zdh+LbpwLjowrvTTdDKs9Df+mVQSoXHbYgYmFWBv8z/Nanrtw==
X-Received: by 2002:a17:906:58c5:b0:94e:626e:c108 with SMTP id e5-20020a17090658c500b0094e626ec108mr12965230ejs.50.1682943369686;
        Mon, 01 May 2023 05:16:09 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id t20-20020a1709060c5400b0094ebc041e20sm14597000ejf.46.2023.05.01.05.16.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 May 2023 05:16:09 -0700 (PDT)
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
Subject: [PATCH net 1/2] net: dsa: mt7530: fix corrupt frames using trgmii on 40 MHz XTAL MT7621
Date:   Mon,  1 May 2023 15:15:37 +0300
Message-Id: <20230501121538.57968-1-arinc.unal@arinc9.com>
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

