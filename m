Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3C467D506
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 20:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbjAZTDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 14:03:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbjAZTDK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 14:03:10 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52BD06810B;
        Thu, 26 Jan 2023 11:02:40 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id hw16so7632278ejc.10;
        Thu, 26 Jan 2023 11:02:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zoeu3HTyadKicb0+N+TFDvPEqHOlj55gPnAt4XCFAqs=;
        b=fufaPVR7znCe8DH8unN19epEwkeKoOopSLF8cET5X2R1g1MAxNGknv9SvfE88X0Msp
         2b/wp77t8DD0Wux+bY7ZkR8E4IOieU4RMb/1G+9dsJoeYwSM4eM/nkDGnODXJhWiv+Gb
         YV5LaTCDEbiHjo+Psur5nF9d8wXuw2er2JnJqQSIYE358octtoHu+n2Ut7/jBPpAwVny
         Luvf37hwOH1TI4ftB5FHdPFmLdT6L+E5buayPotUDkueBBipMZbpVWt2lKDzqLL6cW6g
         pupkIuFqG/HjVnf9qe+vUdDu3C5ymaEoOMxtybsctmAv9MUBV7yL7qfjVsoZ//nnsN0t
         Vzxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zoeu3HTyadKicb0+N+TFDvPEqHOlj55gPnAt4XCFAqs=;
        b=wU/U3PO7wPXNWhoxsxoOCkR3GFop3zcF6nJ3+GRLvPpftPFFM2GUcJuE5TeBpkcdYH
         5XPVPWHSWJtCrKuNhqH0tX0Q8B7qgF/pbdVg2+sXbE7+6gFre9/NCTPrQsBAAMVnT2RC
         AbPb44TlC/5gQf4LLMJ/T2xG6cAW9X2KTxtGjt4LqCclzq5bpG8q3ruyoCdCnswPukOk
         Ef2q22uaR55PXi4x/TT+s/7KMKLEA4ABcfXPohStbiAF4Obxmi9FTpdVZ9l5YQneDcKP
         lWoq61e2MV3WzSkMtwcBOvCQUdAeq+i6gFGGxwWi2KlJjiVhGHFW9BPbus2q3OXTlbsl
         CYgw==
X-Gm-Message-State: AFqh2kp3dPKrQakbEO1npRHDMln2FgdBsjR8RRmI338NUCemaYiBvpz6
        /ilYrCaRDH9S3WIIW+MUgmSiOoZTsYiZ7cap
X-Google-Smtp-Source: AMrXdXsy0GniDdOvPEp40lduIWit7Ev3M9cZaYJMPJmmm81hFwi6DdIHI5TP7HvRYHaHxwxCDJxUoA==
X-Received: by 2002:a17:907:8c88:b0:86e:d375:1f04 with SMTP id td8-20020a1709078c8800b0086ed3751f04mr40526392ejc.30.1674759758779;
        Thu, 26 Jan 2023 11:02:38 -0800 (PST)
Received: from arinc9-PC.lan ([37.120.152.236])
        by smtp.gmail.com with ESMTPSA id i11-20020a170906850b00b00872c3e8d4e0sm993787ejx.13.2023.01.26.11.02.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jan 2023 11:02:38 -0800 (PST)
From:   arinc9.unal@gmail.com
X-Google-Original-From: arinc.unal@arinc9.com
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        erkin.bozoglu@xeront.com
Subject: [PATCH net] net: dsa: mt7530: fix tristate and help description
Date:   Thu, 26 Jan 2023 22:01:11 +0300
Message-Id: <20230126190110.9124-1-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arınç ÜNAL <arinc.unal@arinc9.com>

Fix description for tristate and help sections which include inaccurate
information.

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---

This should end up on the mailing list, and make it the last mail I send
to properly submit this patch.

Arınç

---
 drivers/net/dsa/Kconfig | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/Kconfig b/drivers/net/dsa/Kconfig
index c26755f662c1..f6f3b43dfb06 100644
--- a/drivers/net/dsa/Kconfig
+++ b/drivers/net/dsa/Kconfig
@@ -35,12 +35,13 @@ config NET_DSA_LANTIQ_GSWIP
 	  the xrx200 / VR9 SoC.
 
 config NET_DSA_MT7530
-	tristate "MediaTek MT753x and MT7621 Ethernet switch support"
+	tristate "MediaTek MT7530 and MT7531 Ethernet switch support"
 	select NET_DSA_TAG_MTK
 	select MEDIATEK_GE_PHY
 	help
-	  This enables support for the MediaTek MT7530, MT7531, and MT7621
-	  Ethernet switch chips.
+	  This enables support for the MediaTek MT7530 and MT7531 Ethernet
+	  switch chips. Multi-chip module MT7530 in MT7621AT, MT7621DAT,
+	  MT7621ST and MT7623AI SoCs is supported.
 
 config NET_DSA_MV88E6060
 	tristate "Marvell 88E6060 ethernet switch chip support"
-- 
2.37.2

