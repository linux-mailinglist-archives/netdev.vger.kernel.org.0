Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C3746F30CA
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 14:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232446AbjEAMQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 08:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232430AbjEAMQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 08:16:15 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7C4F191;
        Mon,  1 May 2023 05:16:13 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id a640c23a62f3a-953343581a4so368589966b.3;
        Mon, 01 May 2023 05:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682943372; x=1685535372;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M25XzE8/ZHNsBMDYVfMQXrs94X4sNByO0fz3/W69lrA=;
        b=iOzKUZ7Nk+UvH+5TVKKXYuT6nxP1tYkIMyn1H2y9d15zAT8io4bRqX25a9Vr0GxbIX
         kCr1GB2vx7a14fJeKTwPa+kIEW17/0S4sznvPfVgirkVqsDd0xBlS6z9ne50ntiC9DsX
         qMc6zUpkMEBJEoBx3hBtnhijuHOoG0GFPNwP/k9QNGYBuy69Sryj0FAM3daBA2x8VEQr
         Pv5lPxC8g6n+m237dfnWezPJIijk9DTx5+LdkDmwncFSHBoPpQ8khcYFBwHoypFyK5Ff
         /KwhbD3nMk8+o7QwnlKqZQUBTATXDXHpYE/pHoMjahdA6sTjGsw2Bg4RnysHQidA3+x9
         meOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682943372; x=1685535372;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M25XzE8/ZHNsBMDYVfMQXrs94X4sNByO0fz3/W69lrA=;
        b=dQbcL5U5CZg+KP9opAAWBEDx0h60CNuKLCLTO4XOYiQlsl2ZmkvEiHIX59xvwlmXka
         nlmRKO6wdirH2YJXE5XSum9fvIFV0Z+Lhpci8UTWnh1+xoIeADsRIj54od4vtwfXD9/N
         CBwVGgHLu3LKR3bCqDCvWmipRAkwhmMO6q6btPeaOb6jUAT1CRNzzF5kk/fM+h7NNI81
         wXbuyG+qY1SHgasEHJcb1xSQBwwI/FOHm5AOjLUz+zjmfCaKI2E+nEaZS1/tEmth3Nsl
         ag9D+hLysRjlUkmwdiLZnVy8Vhxq3jI8FH2joFdm2FmHH6A8jVM2BMmxECxZ177vMo9n
         t7CA==
X-Gm-Message-State: AC+VfDwEMLiSBIsFDtklVPFzb3Q1x/u+iQ1nKQs8V0fP7cWLbqr4Pjm2
        ysoIJ+8r3kIjcHwUCU59Wio=
X-Google-Smtp-Source: ACHHUZ5DLOoZ9nPkikE6gez/BeGuWd2aAZywoCHBXuSN1Kd9NHZ7sQU13fLgEVRP3FCzMgntyztbSQ==
X-Received: by 2002:a17:907:846:b0:959:b745:d16f with SMTP id ww6-20020a170907084600b00959b745d16fmr12149356ejb.51.1682943371982;
        Mon, 01 May 2023 05:16:11 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id t20-20020a1709060c5400b0094ebc041e20sm14597000ejf.46.2023.05.01.05.16.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 May 2023 05:16:11 -0700 (PDT)
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
        Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Bartel Eerdekens <bartel.eerdekens@constell8.be>,
        mithat.guner@xeront.com, erkin.bozoglu@xeront.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH net 2/2] net: dsa: mt7530: fix network connectivity with multiple CPU ports
Date:   Mon,  1 May 2023 15:15:38 +0300
Message-Id: <20230501121538.57968-2-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230501121538.57968-1-arinc.unal@arinc9.com>
References: <20230501121538.57968-1-arinc.unal@arinc9.com>
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

On mt753x_cpu_port_enable() there's code that enables flooding for the CPU
port only. Since mt753x_cpu_port_enable() runs twice when both CPU ports
are enabled, port 6 becomes the only port to forward the frames to. But
port 5 is the active port, so no frames received from the user ports will
be forwarded to port 5 which breaks network connectivity.

Every bit of the BC_FFP, UNM_FFP, and UNU_FFP bits represents a port. Fix
this issue by setting the bit that corresponds to the CPU port without
overwriting the other bits.

Clear the bits beforehand only for the MT7531 switch. According to the
documents MT7621 Giga Switch Programming Guide v0.3 and MT7531 Reference
Manual for Development Board v1.0, after reset, the BC_FFP, UNM_FFP, and
UNU_FFP bits are set to 1 for MT7531, 0 for MT7530.

Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 7d9f9563dbda..9bc54e1348cb 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1002,9 +1002,9 @@ mt753x_cpu_port_enable(struct dsa_switch *ds, int port)
 	mt7530_write(priv, MT7530_PVC_P(port),
 		     PORT_SPEC_TAG);
 
-	/* Disable flooding by default */
-	mt7530_rmw(priv, MT7530_MFC, BC_FFP_MASK | UNM_FFP_MASK | UNU_FFP_MASK,
-		   BC_FFP(BIT(port)) | UNM_FFP(BIT(port)) | UNU_FFP(BIT(port)));
+	/* Enable flooding on the CPU port */
+	mt7530_set(priv, MT7530_MFC, BC_FFP(BIT(port)) | UNM_FFP(BIT(port)) |
+		   UNU_FFP(BIT(port)));
 
 	/* Set CPU port number */
 	if (priv->id == ID_MT7621)
@@ -2367,6 +2367,10 @@ mt7531_setup_common(struct dsa_switch *ds)
 	/* Enable and reset MIB counters */
 	mt7530_mib_reset(ds);
 
+	/* Disable flooding on all ports */
+	mt7530_clear(priv, MT7530_MFC, BC_FFP_MASK | UNM_FFP_MASK |
+		     UNU_FFP_MASK);
+
 	for (i = 0; i < MT7530_NUM_PORTS; i++) {
 		/* Disable forwarding by default on all ports */
 		mt7530_rmw(priv, MT7530_PCR_P(i), PCR_MATRIX_MASK,
-- 
2.39.2

