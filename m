Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB02E648A82
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 23:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbiLIWFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 17:05:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbiLIWFe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 17:05:34 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F87A4310;
        Fri,  9 Dec 2022 14:05:31 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id jl24so6292336plb.8;
        Fri, 09 Dec 2022 14:05:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k1cBW6P671B+gcHjOUjeKFb80wjnsMDorPTCq5t+8BU=;
        b=CKuorDuVqSJ64DQb5aoKCb8BLcWybqolW6xiHbOWhGf1AO4/0R+o9EMcujHZmVMdxo
         Q3GsuCxfiP7gcfYqqhZDRsNsYl6kZ5z3FnFisIAKcFnk4w95xCquAMQ4crIWWpicJkOG
         NhOnw6/Akb8WFgFKwAskd3w51gsCEc54SHxJKcKVmiQStZ9bj6kiBciqRbzigK3ufbR6
         eUdHTeYH7wdpwHO+XwjgrkoYHMac3JpETK+z2PldB0Be4fv5RiMDE2p87f0KYfUkdJEu
         f7Bvj2gax5f8vJVbzST1KxyhPKswf+JPwm1FKj+4s8ByMqr3ykeh17QgloIb7Uel1ZWj
         ms4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k1cBW6P671B+gcHjOUjeKFb80wjnsMDorPTCq5t+8BU=;
        b=Ntmwr2RUIH56Emt6W0jwmXXtIcm/tZk4sjcVzmlu1lWCImn5YxtXV974vV9pqueLOK
         IDi5bQi0LUI3UHUoCrI12C8MmVjNP6Its0uhOVTMr1oHH+CG6O7fsjhrC+hjL2akjzpS
         L/MxEPj3OuqGnDrg0OEwQDmE+a/Bpvni1cinNaTCoh/9wp05BVApcpPvMMhQ4LQDAxGW
         54GLxgYICxz4t43WWzoUPNHzVqaBt/ubB6UNjCB3w/hj7Yg1aBk2jLPMxDaMQucME7+Q
         m/bcOwgscVAO5XsoKmvVqmbhkDMtbet0/EGyMo4sCgbBhE3WFfAWyAzD0ITiIG6dUKq1
         nPIA==
X-Gm-Message-State: ANoB5pnXTvyNtF8WJBbr6tPMYYKlTEnScIXkcfh7QdPRovi/1jDSG+Z5
        WTZxbmypRjhYP/C3ql4Lxid5i86XEolEiw==
X-Google-Smtp-Source: AA0mqf7XEImnw/Z4cCuX5bFsXPb4FNA1JZNzjsTwsXYUoESc2qSl2EH1XJXOq61+QbfQhIsOzz28oQ==
X-Received: by 2002:a17:90a:5b06:b0:213:1444:2f2d with SMTP id o6-20020a17090a5b0600b0021314442f2dmr8758634pji.10.1670623530324;
        Fri, 09 Dec 2022 14:05:30 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h7-20020a17090ac38700b0021870b2c7absm1528096pjt.42.2022.12.09.14.05.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 14:05:29 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        NXP Linux Team <linux-imx@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        linux-kernel@vger.kernel.org (open list:IRQCHIP DRIVERS),
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/FREESCALE IMX
        / MXC ARM ARCHITECTURE), Clark Wang <xiaoning.wang@nxp.com>,
        Wei Fang <wei.fang@nxp.com>,
        Shenwei Wang <shenwei.wang@nxp.com>
Subject: [PATCH net v2 2/2] dt-bindings: FEC/i.MX DWMAC and INTMUX maintainer
Date:   Fri,  9 Dec 2022 14:05:19 -0800
Message-Id: <20221209220519.1542872-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221209220519.1542872-1-f.fainelli@gmail.com>
References: <20221209220519.1542872-1-f.fainelli@gmail.com>
MIME-Version: 1.0
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

Emails to Joakim Zhang bounce, add Shawn Guo (i.MX architecture
maintainer) and the NXP Linux Team exploder email as well as well Wei
Wang for FEC and Clark Wang for DWMAC.

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 .../devicetree/bindings/interrupt-controller/fsl,intmux.yaml  | 3 ++-
 Documentation/devicetree/bindings/net/fsl,fec.yaml            | 4 +++-
 Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml      | 4 +++-
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/interrupt-controller/fsl,intmux.yaml b/Documentation/devicetree/bindings/interrupt-controller/fsl,intmux.yaml
index 1d6e0f64a807..985bfa4f6fda 100644
--- a/Documentation/devicetree/bindings/interrupt-controller/fsl,intmux.yaml
+++ b/Documentation/devicetree/bindings/interrupt-controller/fsl,intmux.yaml
@@ -7,7 +7,8 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: Freescale INTMUX interrupt multiplexer
 
 maintainers:
-  - Joakim Zhang <qiangqing.zhang@nxp.com>
+  - Shawn Guo <shawnguo@kernel.org>
+  - NXP Linux Team <linux-imx@nxp.com>
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/net/fsl,fec.yaml b/Documentation/devicetree/bindings/net/fsl,fec.yaml
index e0f376f7e274..77e5f32cb62f 100644
--- a/Documentation/devicetree/bindings/net/fsl,fec.yaml
+++ b/Documentation/devicetree/bindings/net/fsl,fec.yaml
@@ -7,7 +7,9 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: Freescale Fast Ethernet Controller (FEC)
 
 maintainers:
-  - Joakim Zhang <qiangqing.zhang@nxp.com>
+  - Shawn Guo <shawnguo@kernel.org>
+  - Wei Fang <wei.fang@nxp.com>
+  - NXP Linux Team <linux-imx@nxp.com>
 
 allOf:
   - $ref: ethernet-controller.yaml#
diff --git a/Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml b/Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml
index 4c155441acbf..1857cb4b7139 100644
--- a/Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml
+++ b/Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml
@@ -7,7 +7,9 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: NXP i.MX8 DWMAC glue layer
 
 maintainers:
-  - Joakim Zhang <qiangqing.zhang@nxp.com>
+  - Clark Wang <xiaoning.wang@nxp.com>
+  - Shawn Guo <shawnguo@kernel.org>
+  - NXP Linux Team <linux-imx@nxp.com>
 
 # We need a select here so we don't match all nodes with 'snps,dwmac'
 select:
-- 
2.34.1

