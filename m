Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6500610781
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 03:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235114AbiJ1B4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 21:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234377AbiJ1B4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 21:56:22 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3BF534DD4
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 18:56:20 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id c23so2713878qtw.8
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 18:56:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QFSp8Gx4w5A/kz9i8MLnQOAGdc+1wRun3PEnvhLdY94=;
        b=Y6RrE+pmTF/dQH8SABMBeNtSpSRZA2e6R+brGqO9hQZMeYaaEVPHhfS71KE8VnvegY
         OxbHVdCaYLpPLqJgvzjptumMzCEIo8V9aEUscBDIHrSgD1YSRi2rLCtjDApfcx9KkM2s
         C8FG5iVGmQtXIyBs3yFPyk7b+qQ5vQGzvtFzuHGWvBU1JfCencMOJnL4n7Za7f6oqUJ/
         IB07lhkV94YIVVCkZVnUfSfIuPBH2DzBM16E35SA/Gj5TlTxSZw4jxDcv17J9rXzItx6
         qMo1t5Zf6fL1Y/G5Ji7PupJGMAZVhiI7OrXzlLGNkPfvmK6i+bCvPBo/UO2Bj3HSsT+k
         htog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QFSp8Gx4w5A/kz9i8MLnQOAGdc+1wRun3PEnvhLdY94=;
        b=3cWQwJz6OmFhqhFaAV0Sx5o8kSUw64iEb2fzwcVwqHhqa4q5g7/O9mC8aa/BRqcuQJ
         SAHo53Zcspa5uD4C/V+Lz+SJOBY/c8J/vIGuQeUe9aisvMahtYCZ4Xi2qKKjxxT+5dMP
         JO2T5GTjvxtVJpMjCs5ipLS6ASjKk9pW61LVsYwLaNNZMENnPe2uYuzUCaDvObL5mGMY
         LMWY3mzuO/ZCaEb2vvyYAENPy+MF8rQK+oLnBii7104zf8LRYC0QLD0iTgAV6pWhunQP
         wOSc0OW1kv6tbU2xWlZwGAwQpZIcu7CdTPrHDc1ATK8PGHMIZt0mbajvha2W8Xk+yAIH
         tbUg==
X-Gm-Message-State: ACrzQf1obX67zJybWNgUGzm/sTzcyVniWo7iPBJ/T4t0hLwVM+HvuIRG
        EBIK7unAPhqSKZOq3qyZVWleqiQ6KJEDew==
X-Google-Smtp-Source: AMsMyM7Xo9W5zqlgQeOl61qFWDZWAQZKaYla7Bady0M41BCekgMax0lwbN7ph8twDwnM/cI9vq0i3g==
X-Received: by 2002:a05:622a:15d3:b0:39d:dd6:3a31 with SMTP id d19-20020a05622a15d300b0039d0dd63a31mr34285810qty.37.1666922179821;
        Thu, 27 Oct 2022 18:56:19 -0700 (PDT)
Received: from krzk-bin.. ([64.57.193.93])
        by smtp.gmail.com with ESMTPSA id ay17-20020a05620a179100b006bb78d095c5sm2021816qkb.79.2022.10.27.18.56.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 18:56:19 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Daniel Machon <daniel.machon@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Oleksij Rempel <linux@rempel-privat.de>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH v2] dt-bindings: net: constrain number of 'reg' in ethernet ports
Date:   Thu, 27 Oct 2022 21:56:16 -0400
Message-Id: <20221028015616.101750-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'reg' without any constraints allows multiple items which is not the
intention for Ethernet controller's port number.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

---

Changes since v1:
1. Drop change to non-accepted renesas,r8a779f0-ether-switch.

Please give it a time for Rob's bot to process this.
---
 Documentation/devicetree/bindings/net/asix,ax88178.yaml       | 4 +++-
 Documentation/devicetree/bindings/net/microchip,lan95xx.yaml  | 4 +++-
 .../devicetree/bindings/net/microchip,lan966x-switch.yaml     | 4 ++--
 .../devicetree/bindings/net/microchip,sparx5-switch.yaml      | 3 ++-
 .../devicetree/bindings/net/mscc,vsc7514-switch.yaml          | 3 ++-
 5 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/asix,ax88178.yaml b/Documentation/devicetree/bindings/net/asix,ax88178.yaml
index 1af52358de4c..a81dbc4792f6 100644
--- a/Documentation/devicetree/bindings/net/asix,ax88178.yaml
+++ b/Documentation/devicetree/bindings/net/asix,ax88178.yaml
@@ -27,7 +27,9 @@ properties:
           - usbb95,772b   # ASIX AX88772B
           - usbb95,7e2b   # ASIX AX88772B
 
-  reg: true
+  reg:
+    maxItems: 1
+
   local-mac-address: true
   mac-address: true
 
diff --git a/Documentation/devicetree/bindings/net/microchip,lan95xx.yaml b/Documentation/devicetree/bindings/net/microchip,lan95xx.yaml
index cf91fecd8909..3715c5f8f0e0 100644
--- a/Documentation/devicetree/bindings/net/microchip,lan95xx.yaml
+++ b/Documentation/devicetree/bindings/net/microchip,lan95xx.yaml
@@ -39,7 +39,9 @@ properties:
           - usb424,9e08   # SMSC LAN89530 USB Ethernet Device
           - usb424,ec00   # SMSC9512/9514 USB Hub & Ethernet Device
 
-  reg: true
+  reg:
+    maxItems: 1
+
   local-mac-address: true
   mac-address: true
 
diff --git a/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml b/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
index dc116f14750e..583d70c51be6 100644
--- a/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
+++ b/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
@@ -83,8 +83,8 @@ properties:
             const: 0
 
           reg:
-            description:
-              Switch port number
+            items:
+              - description: Switch port number
 
           phys:
             description:
diff --git a/Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml b/Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml
index 57ffeb8fc876..ccb912561446 100644
--- a/Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml
+++ b/Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml
@@ -89,7 +89,8 @@ properties:
 
         properties:
           reg:
-            description: Switch port number
+            items:
+              - description: Switch port number
 
           phys:
             maxItems: 1
diff --git a/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml b/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml
index ee0a504bdb24..1cf82955d75e 100644
--- a/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml
+++ b/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml
@@ -109,7 +109,8 @@ properties:
 
         properties:
           reg:
-            description: Switch port number
+            items:
+              - description: Switch port number
 
           phy-handle: true
 
-- 
2.34.1

