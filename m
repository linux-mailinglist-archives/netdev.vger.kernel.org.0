Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17E476DAE50
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 15:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232248AbjDGNub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 09:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbjDGNtj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 09:49:39 -0400
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3066410D3;
        Fri,  7 Apr 2023 06:47:30 -0700 (PDT)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-545cb3c9898so721694807b3.7;
        Fri, 07 Apr 2023 06:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680875250;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KrhVwFwdiy8PafsiMhkpCPuLOjFFrIY15KiQQTf11aU=;
        b=AlfANMoRb9wyGOVs2RriQZW0B3V9w9QT6cgDWHACfUH0Gc99k6HjBBOrTrCQ7H/Sup
         FtVlxudRvwdw/8k9ZgBfiAUVUHDajsYWyZHM+rraiJfNu0IZZN+WozE4dO2haxVzG1qD
         HTfmzxe0S8jLZET6Mz5Bi+an889FlHW0Oc8S3zSYeJWnCzvNbYj7m/DNuVNy9JBoU0GS
         3BM+NpMu+nS7jz/vCRfIu+B3JD1diEYGtS9f2awXFNXCpzDHVdbpMyJgUw8aVjURRJRy
         f5vfcCFcSeYMIboIWtoJ8TOume8J0AV27BRfZbR6ttBQcdF77r6vA/8i7Dtlh4/R2w2M
         xQMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680875250;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KrhVwFwdiy8PafsiMhkpCPuLOjFFrIY15KiQQTf11aU=;
        b=fzSndiKgcS8/qT0nRGOlf1zVCqVuXFK6uENV9R1/Bz4iukr2OeJtMdJn/sKyQ2qMQA
         xwrgL2HhSA/n6lTASYwhJNYSJN95ZGhwVnnwZ26WCieMm1GpEZ1ObF3pJCO9OHcKFzze
         h8aDgUb++a+pNPrE88SQSUUwnf//ZGnPmiKGR9mFblv/4qXbeIhqlVDevei5KdJ1kXLE
         EtqDJtIl3oS33L+9l5QXV5o7EITkR23FxaQQEkOeLBEdO1b/wUlRQEKPbtngD3ig1wrY
         HWS1Xb3XISUmnzffy12f2brLcUmcIlsaGVkhxN4EDgPB+CFY9ZFY94WMEbYu6++pR3Xh
         AZGA==
X-Gm-Message-State: AAQBX9f9AfawyPFplWDvfDGMTrmyfPB3QMCULQrJC/+huKIJcS4YqIPD
        t1WhlRraIFWbLbFH0lD9CcM=
X-Google-Smtp-Source: AKy350ZRgyDFHukSn+0MW323t7p6FhxtWniWWbqWmcv8+P6ybWeXqdm/ISnIxoPizJaso4aprmfGhQ==
X-Received: by 2002:a81:9444:0:b0:546:3229:cc04 with SMTP id l65-20020a819444000000b005463229cc04mr2012517ywg.52.1680875249739;
        Fri, 07 Apr 2023 06:47:29 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id 139-20020a810e91000000b00545a0818473sm1034317ywo.3.2023.04.07.06.47.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Apr 2023 06:47:29 -0700 (PDT)
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
        Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [RFC PATCH v2 net-next 12/14] net: dsa: mt7530: move lowering port 5 RGMII driving to mt7530_setup()
Date:   Fri,  7 Apr 2023 16:46:24 +0300
Message-Id: <20230407134626.47928-13-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230407134626.47928-1-arinc.unal@arinc9.com>
References: <20230407134626.47928-1-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arınç ÜNAL <arinc.unal@arinc9.com>

Move lowering Tx driving of rgmii on port 5 to right before lowering of Tx
driving of trgmii on port 6 on mt7530_setup().

This way, the switch should consume less power regardless of port 5 being
used.

Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 384e601b2ecd..6fbbdcb5987f 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -956,10 +956,6 @@ static void mt7530_setup_port5(struct dsa_switch *ds, phy_interface_t interface)
 		/* P5 RGMII TX Clock Control: delay x */
 		mt7530_write(priv, MT7530_P5RGMIITXCR,
 			     CSR_RGMII_TXC_CFG(0x10 + tx_delay));
-
-		/* reduce P5 RGMII Tx driving, 8mA */
-		mt7530_write(priv, MT7530_IO_DRV_CR,
-			     P5_IO_CLK_DRV(1) | P5_IO_DATA_DRV(1));
 	}
 
 	mt7530_write(priv, MT7530_MHWTRAP, val);
@@ -2227,6 +2223,10 @@ mt7530_setup(struct dsa_switch *ds)
 
 	mt7530_pll_setup(priv);
 
+	/* Lower P5 RGMII Tx driving, 8mA */
+	mt7530_write(priv, MT7530_IO_DRV_CR,
+			P5_IO_CLK_DRV(1) | P5_IO_DATA_DRV(1));
+
 	/* Lower Tx driving for TRGMII path */
 	for (i = 0; i < NUM_TRGMII_CTRL; i++)
 		mt7530_write(priv, MT7530_TRGMII_TD_ODT(i),
-- 
2.37.2

