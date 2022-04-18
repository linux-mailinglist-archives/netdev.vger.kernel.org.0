Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4996F506047
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 01:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235505AbiDRXjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 19:39:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235478AbiDRXjA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 19:39:00 -0400
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23A2C27FF8;
        Mon, 18 Apr 2022 16:36:19 -0700 (PDT)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-e5e433d66dso4456574fac.5;
        Mon, 18 Apr 2022 16:36:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xiiRzsI3K3MJOoT1BFbBBI2gKgU/fIkJXjdOpkTK3rY=;
        b=FYpU59LSL4ZaXSLnZ1Gd7jQCWeukDl4ixeXQZzNZf5ZzOfwl2nxmN3wEacS4HhBrf7
         qpbLuow8crfFle5Dq517LYX2HcYhw8Ep/kl93b1BmdW/vmAPcvYfuT6+L4LrX0gNm43Z
         nOd9AglT7G+txihqop6EdszMhRPZkDUXLkUGhmE9pGVLHgFLLP+3xjcHrlarxuQKcmnY
         OB7nz2EDQkSc0aLl80DtjE/Dkm3vR4EMBhqrn+bjIQpn5rb9scDErzTcLPwprtSrQdOd
         YK69LtQLGAWepPPgzvNKJamF56R1wjlzfAWb+PNIENkCllke5O3eIueXtr3xQAY/cJgh
         p9Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xiiRzsI3K3MJOoT1BFbBBI2gKgU/fIkJXjdOpkTK3rY=;
        b=rPLxX3n8yA/pbZ+NPoddZhdah6pXeo3Gpp4mFwPDqf/GEONUgCJLW8D6EbHRd8lmJz
         N+mAk0wm1b1l3Q65cH9yPCTM1Fl9Rq0ORF0ON63cCFTLk3rcjTVd4dmw9yRC+thk3dmo
         KtZzSMu44bwjd4fGwxCJiDvsRhRiD7KuTbHVLiWA+CmpAGLg4r/G376b04JK7F6jsHV6
         D5OF4k4vCWMMtVaHBLJc9h/k0OXUchfEx0EGdsp01HPuCFonEider8R3SfgFGhRneUu/
         l2JZVUSBlerfZ0OJSiOt2jJaYb88wwzsdR3HZdx+vKygKzyjem3GyvM6CpxbpGK0QD+e
         8aZA==
X-Gm-Message-State: AOAM533KQNh5bXvV9LN1zIT+d5Cv+IGccTyOMjzK5zENLXPhFomlsspw
        E6UioWP/rZZVdUHUaMHUvNj7g3INsZLOyw==
X-Google-Smtp-Source: ABdhPJwJLOFdCI61l2bkT2pcmVq1eliFK9y7l6GNPggUwYjzNFe39zKPYCylxsgs8ayOE1yD2YlH5Q==
X-Received: by 2002:a05:6870:b408:b0:dd:ed4f:b1c7 with SMTP id x8-20020a056870b40800b000dded4fb1c7mr5611715oap.41.1650324978163;
        Mon, 18 Apr 2022 16:36:18 -0700 (PDT)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id k14-20020a0568080e8e00b003224d35c729sm3674179oil.3.2022.04.18.16.36.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 16:36:17 -0700 (PDT)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, alsi@bang-olufsen.dk, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzk+dt@kernel.org, arinc.unal@arinc9.com,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        devicetree@vger.kernel.org
Subject: [PATCH net v2 1/2] dt-bindings: net: dsa: realtek: cleanup compatible strings
Date:   Mon, 18 Apr 2022 20:35:57 -0300
Message-Id: <20220418233558.13541-1-luizluca@gmail.com>
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

The removed compatible strings have never been used in a released kernel.

CC: devicetree@vger.kernel.org
Link: https://lore.kernel.org/netdev/20220414014055.m4wbmr7tdz6hsa3m@bang-olufsen.dk/
Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 .../devicetree/bindings/net/dsa/realtek.yaml  | 35 ++++++++-----------
 1 file changed, 14 insertions(+), 21 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/realtek.yaml b/Documentation/devicetree/bindings/net/dsa/realtek.yaml
index 8756060895a8..99ee4b5b9346 100644
--- a/Documentation/devicetree/bindings/net/dsa/realtek.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/realtek.yaml
@@ -27,32 +27,25 @@ description:
   The realtek-mdio driver is an MDIO driver and it must be inserted inside
   an MDIO node.
 
+  The compatible string is only used to identify which (silicon) family the
+  switch belongs to. Roughly speaking, a family is any set of Realtek switches
+  whose chip identification register(s) have a common location and semantics.
+  The different models in a given family can be automatically disambiguated by
+  parsing the chip identification register(s) according to the given family,
+  avoiding the need for a unique compatible string for each model.
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
+      realtek,rtl8366rb:
+        Use with models RTL8366RB, RTL8366S
 
   mdc-gpios:
     description: GPIO line for the MDC clock line.
@@ -335,7 +328,7 @@ examples:
             #size-cells = <0>;
 
             switch@29 {
-                    compatible = "realtek,rtl8367s";
+                    compatible = "realtek,rtl8365mb";
                     reg = <29>;
 
                     reset-gpios = <&gpio2 20 GPIO_ACTIVE_LOW>;
-- 
2.35.1

