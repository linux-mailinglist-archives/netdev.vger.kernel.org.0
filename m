Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 713A350346E
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 08:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbiDPG16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 02:27:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiDPG15 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 02:27:57 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F28512FFD7;
        Fri, 15 Apr 2022 23:25:26 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id c21-20020a056830001500b005f8f6757c22so4780633otp.1;
        Fri, 15 Apr 2022 23:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=m4zdO4FwkXc6f31oyTAiz2VllA8ZYggkDmpwHP6e3l0=;
        b=UvQ+CJPJoipRoQQ0NzsNb4fFpaMMJvCwFv8wyp1EqBS09HzBgSMwp7j4C0DBDUEKdb
         jdl4ckSmWDssKhUjO2csA7griZHKqwXKnj/ptiOUZ/MYdUZZm4vkmnCYT1q6GPdTiid7
         p68q+YxyqkAusXydN7g8xMxv6Ceh1wCvaHvsMVtVslDgX7iHc9hJ9gR3yioBqqS4iRFU
         +ZZbFJuBDIQ/dXYyxzv6gsR9pXYVFCfbWFCvfNwLJCvdazSslPqXCCcd6F9eiWW6cxCa
         cDWeP7sSQqNM4V0VKlpKe+Q4IkfJouDn/FCi1qieB2TGeiKvaty+iG3v7xWUgyhYMXPD
         llag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=m4zdO4FwkXc6f31oyTAiz2VllA8ZYggkDmpwHP6e3l0=;
        b=wA8iRAwLvRXTXSfIoZDDUBnDVECL6QLY5oh6qu6Mjtp+YExAAU7Pol1sWZudqgEB+V
         gMcAL9XBJ2mXtfXXFKX6e88uDbKArdA4VqkeBme+nhfzwPz5z5zTn2ofzCrcr/OcjTau
         IyToudAD/Rizf121Vp2BOredbVI+Vbg0j9u4d02Ydc7nnXWi3E+8ymafV6NbZtpwS5Bb
         GQqbhB4rYAyWoBz4sM/k7qMlMznaqHPafQr3z+GSLgRFTlHRYv6gXDTWIcRzBbj9IJqM
         pBIxDweiSbs6PlfP1W4dNBOHBQRDmIOGf3gYEGo0Gg8IXcAPKrOePF9MsIrq9es5mov0
         bzhg==
X-Gm-Message-State: AOAM531CFE9iwDVectbB978XhsHNE7fvvbf0b9pPMgPXlVPGJAQIMBGq
        ishU/DE2z0o0umBCwJX7yXN08nuLW3R6tQ==
X-Google-Smtp-Source: ABdhPJyyzl+3t88BO1OKQfFLwpNwUnEOGBmT4YDeHYJLC6De6hGKwrinKLZHZnB3myLcXNuVuK5PVA==
X-Received: by 2002:a9d:62c:0:b0:5e6:b611:ff6b with SMTP id 41-20020a9d062c000000b005e6b611ff6bmr765880otn.210.1650090325940;
        Fri, 15 Apr 2022 23:25:25 -0700 (PDT)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id 6-20020aca0706000000b002f9d20b3134sm1838928oih.7.2022.04.15.23.25.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 23:25:22 -0700 (PDT)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, alsi@bang-olufsen.dk, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzk+dt@kernel.org, arinc.unal@arinc9.com,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        devicetree@vger.kernel.org
Subject: [PATCH net 1/2] dt-bindings: net: dsa: realtek: cleanup compatible strings
Date:   Sat, 16 Apr 2022 03:25:03 -0300
Message-Id: <20220416062504.19005-1-luizluca@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
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

Compatible strings are used to help the driver find the chip ID/version
register for each chip family. After that, the driver can setup the
switch accordingly. Keep only the first supported model for each family
as a compatible string and reference other chip models in the
description.

CC: devicetree@vger.kernel.org
Link: https://lore.kernel.org/netdev/20220414014055.m4wbmr7tdz6hsa3m@bang-olufsen.dk/
Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 .../devicetree/bindings/net/dsa/realtek.yaml  | 33 +++++++------------
 1 file changed, 12 insertions(+), 21 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/realtek.yaml b/Documentation/devicetree/bindings/net/dsa/realtek.yaml
index 8756060895a8..9bf862abb496 100644
--- a/Documentation/devicetree/bindings/net/dsa/realtek.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/realtek.yaml
@@ -27,32 +27,23 @@ description:
   The realtek-mdio driver is an MDIO driver and it must be inserted inside
   an MDIO node.
 
+  The compatibility string is used only to find an identification register,
+  (chip ID and version) which is at a different MDIO base address in different
+  switch families. The driver then uses the chip ID/version to device how to
+  drive the switch.
+
 properties:
   compatible:
     enum:
       - realtek,rtl8365mb
-      - realtek,rtl8366
       - realtek,rtl8366rb
-      - realtek,rtl8366s
-      - realtek,rtl8367
-      - realtek,rtl8367b
-      - realtek,rtl8367rb
-      - realtek,rtl8367s
-      - realtek,rtl8368s
-      - realtek,rtl8369
-      - realtek,rtl8370
     description: |
-      realtek,rtl8365mb: 4+1 ports
-      realtek,rtl8366: 5+1 ports
-      realtek,rtl8366rb: 5+1 ports
-      realtek,rtl8366s: 5+1 ports
-      realtek,rtl8367:
-      realtek,rtl8367b:
-      realtek,rtl8367rb: 5+2 ports
-      realtek,rtl8367s: 5+2 ports
-      realtek,rtl8368s: 8 ports
-      realtek,rtl8369: 8+1 ports
-      realtek,rtl8370: 8+2 ports
+      realtek,rtl8365mb:
+        Use with models RTL8363NB, RTL8363NB-VB, RTL8363SC, RTL8363SC-VB,
+        RTL8364NB, RTL8364NB-VB, RTL8365MB, RTL8366SC, RTL8367RB-VB, RTL8367S,
+        RTL8367SB, RTL8370MB, RTL8310SR
+      realtek,rtl8367rb:
+        Use with models RTL8366RB, RTL8366S
 
   mdc-gpios:
     description: GPIO line for the MDC clock line.
@@ -335,7 +326,7 @@ examples:
             #size-cells = <0>;
 
             switch@29 {
-                    compatible = "realtek,rtl8367s";
+                    compatible = "realtek,rtl8365mb";
                     reg = <29>;
 
                     reset-gpios = <&gpio2 20 GPIO_ACTIVE_LOW>;
-- 
2.35.1

