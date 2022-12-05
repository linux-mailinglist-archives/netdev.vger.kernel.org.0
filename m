Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB6F16436BF
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 22:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233537AbiLEVYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 16:24:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233419AbiLEVXy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 16:23:54 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95FA52AE3D;
        Mon,  5 Dec 2022 13:23:50 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id s196so11631528pgs.3;
        Mon, 05 Dec 2022 13:23:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xZ/BXsgSSQx88KdV9xFUEpCkYa2jR8CzLJ5Kj5MNY/A=;
        b=EQ0j6S2KJt6t+2HL/l1/9XsGr38P9Oo8tCFWGZL3ywQ7NQwEzJ8mc/XpeuEWqDJ7Is
         uF+A0Rc9Nu022z2O7ZPLcWvd73EHs7bl8kJ8GIgkohsk4Q0tKpXUYwexZ0gRwknMRFjl
         +aTTfbNjAWCxVOHi6EdYj2RbeRHhkK0EyggasKjox8y8XrUUIBeyCUI2AsZJXRjAsIFb
         OpdzZaNUgW9CwWBqQ5oOZtlt6/mdBI6iCzYRUYtwQJ+CafzRUpa9GgpHa159LEdDJrEv
         WVjeHeiYAi+KvwJFdyVyoACdueMViUQ7YdcvMKqWogz7a+FTaMob67tzOLpibJ2Z8Xyk
         XH9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xZ/BXsgSSQx88KdV9xFUEpCkYa2jR8CzLJ5Kj5MNY/A=;
        b=jwJanLgIrfBhnYK95QFqEQytccOJjru3hkQ99pEN9Au6KrOj8rRliHmaGnV7rlHb3R
         9a+FuZW6cht8g8Jjoz5WqhHQQov1hlFJmUzSe0fiKBOc5bcDzKBN6ABOf5ioUDYinwSs
         +Iodn8l+CDIKxbahofY68JlL4LwruHoGEFZzixBsTwBIO7t0Z6W0KBUB9jqd6vowCDni
         S8Ym9kgPfCEwewycM85OWrdDRKXe+wWjUWjuaoI8maIdlpJ8BIPGBv0woUkUpgMLQh+i
         cftbybGa7mZfx4TGKnmSAIOwmibMxjP2q+wHdOt8rQHMhTeBAs2fLDyMPMtXV++lmWm9
         Oong==
X-Gm-Message-State: ANoB5pmbFHX8ZM/4W0t7+ssAOZzL5b+gkXaXMyw1/MDkycBXt6OEU756
        Fsk9mjk3jQQNzNC7zjQv+fwhiXX33aKgoQ==
X-Google-Smtp-Source: AA0mqf70aGPcmCDpchFYcioQrRpEXs+wfkkRioZZCYzpODv9gbv885vJ44ivlecUhvXgcq6d1ORw4A==
X-Received: by 2002:a05:6a00:1409:b0:56b:e1d8:e7a1 with SMTP id l9-20020a056a00140900b0056be1d8e7a1mr66058750pfu.28.1670275429728;
        Mon, 05 Dec 2022 13:23:49 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y2-20020a17090264c200b00189348ab156sm4029270pli.283.2022.12.05.13.23.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 13:23:49 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
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
        / MXC ARM ARCHITECTURE)
Subject: [PATCH net 2/2] dt-bindings: FEC/i.MX DWMAC and INTMUX maintainer
Date:   Mon,  5 Dec 2022 13:23:40 -0800
Message-Id: <20221205212340.1073283-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221205212340.1073283-1-f.fainelli@gmail.com>
References: <20221205212340.1073283-1-f.fainelli@gmail.com>
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
maintainer) and the NXP Linux Team exploder email.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 .../devicetree/bindings/interrupt-controller/fsl,intmux.yaml   | 3 ++-
 Documentation/devicetree/bindings/net/fsl,fec.yaml             | 3 ++-
 Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml       | 3 ++-
 3 files changed, 6 insertions(+), 3 deletions(-)

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
index e0f376f7e274..83b390ef9abb 100644
--- a/Documentation/devicetree/bindings/net/fsl,fec.yaml
+++ b/Documentation/devicetree/bindings/net/fsl,fec.yaml
@@ -7,7 +7,8 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: Freescale Fast Ethernet Controller (FEC)
 
 maintainers:
-  - Joakim Zhang <qiangqing.zhang@nxp.com>
+  - Shawn Guo <shawnguo@kernel.org>
+  - NXP Linux Team <linux-imx@nxp.com>
 
 allOf:
   - $ref: ethernet-controller.yaml#
diff --git a/Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml b/Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml
index 4c155441acbf..bd430dede242 100644
--- a/Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml
+++ b/Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml
@@ -7,7 +7,8 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: NXP i.MX8 DWMAC glue layer
 
 maintainers:
-  - Joakim Zhang <qiangqing.zhang@nxp.com>
+  - Shawn Guo <shawnguo@kernel.org>
+  - NXP Linux Team <linux-imx@nxp.com>
 
 # We need a select here so we don't match all nodes with 'snps,dwmac'
 select:
-- 
2.34.1

