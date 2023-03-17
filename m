Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48DBC6BDED4
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 03:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbjCQCeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 22:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbjCQCdm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 22:33:42 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72DDBB328A;
        Thu, 16 Mar 2023 19:33:33 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id p4so3182125wre.11;
        Thu, 16 Mar 2023 19:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679020412;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mZv5FnCiudZKDVGAnq53ZSH02fIH+isgRk91M2T3n+E=;
        b=RTp0mEPG1x3QJnyW+mXKNUnNncVZBTlmPW9XN1NL6oKJ2YK/P6EiNv4TetcqzBuVrt
         aVAXC6nHT/OwmIgPFOyOz2Hl3f4MCFJwpWxFWOArr4Ha0f12Lhm/31IP0ssyeFXLBtcx
         rImaOYJtfuOw8QzUq5GfxJ1TIcG/0k8I5pkpAAoJb/czmE/QTnPEajyVU+gqkPrngOLL
         B/WBB1Ex04tUUBPXlAvQC76DuOyJkYx+RS67GJ7TI4APDMTp/1sc9cKINbCAKxKL0qEu
         qeOvFFIOiAESrufZCaThJe+6Guj1JTaWwOn4IFTkMVRIehW6NQu+hAEHU+UIpr4rh07B
         aFWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679020412;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mZv5FnCiudZKDVGAnq53ZSH02fIH+isgRk91M2T3n+E=;
        b=w/Ol2ZXOs/QCshLBg8/XSsoVYQvF8lxqTQ3IYtNXzHugjWMQNFKU+k5G6ZAfihIf4N
         Q3/xm47uxleD8Kih7T8ZKCDCxvwGa3nZeicliM6FIgDpmsG8/KiEg/YBGBlk/7zWFfcn
         e4UnNuDv9eA+3MNRf5MrwAuwig/szZs6+teRUT8r8RIqd7cSnZdEPATKDYFkVNIYre0s
         MXT/4SIOGR9cEBPr7HyHyi2m4ZSgV8SRkZcV2jbPH2H6Zf0DhbE34W/3CZMW+YHa/yGN
         MhEPQ7NZbzLPfVsg671G5scpP9tyzMeluvzrNgnstQrOAZCsCe+HYcwJL41dpuJwYqWB
         HY5g==
X-Gm-Message-State: AO0yUKXGPOyQfB7i30dFzUixDZRnZSG20JIO+dRizr+ZjOYkKbTp9rI4
        HkjYOBERNrzH1mBTj8S6rXM=
X-Google-Smtp-Source: AK7set//rwtVf+fHh7PC4t8hAhqjPN3KDY+OjIA+hirS0GP2IXeP8gw4kQ9vCI9DHQ2uVrUDV/zasw==
X-Received: by 2002:adf:ee52:0:b0:2ce:a938:ecc9 with SMTP id w18-20020adfee52000000b002cea938ecc9mr6245320wro.69.1679020411651;
        Thu, 16 Mar 2023 19:33:31 -0700 (PDT)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id z15-20020a5d44cf000000b002ce9f0e4a8fsm782313wrr.84.2023.03.16.19.33.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 19:33:31 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Lee Jones <lee@kernel.org>,
        linux-leds@vger.kernel.org
Subject: [net-next PATCH v4 09/14] dt-bindings: net: ethernet-controller: Document support for LEDs node
Date:   Fri, 17 Mar 2023 03:31:20 +0100
Message-Id: <20230317023125.486-10-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230317023125.486-1-ansuelsmth@gmail.com>
References: <20230317023125.486-1-ansuelsmth@gmail.com>
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

Document support for LEDs node in ethernet-controller.
Ethernet Controller may support different LEDs that can be configured
for different operation like blinking on traffic event or port link.

Also add some Documentation to describe the difference of these nodes
compared to PHY LEDs, since ethernet-controller LEDs are controllable
by the ethernet controller regs and the possible intergated PHY doesn't
have control on them.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 .../bindings/net/ethernet-controller.yaml     | 21 +++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
index 00be387984ac..a93673592314 100644
--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -222,6 +222,27 @@ properties:
         required:
           - speed
 
+  leds:
+    type: object
+    description:
+      Describes the LEDs associated by Ethernet Controller.
+      These LEDs are not integrated in the PHY and PHY doesn't have any
+      control on them. Ethernet Controller regs are used to control
+      these defined LEDs.
+
+    properties:
+      '#address-cells':
+        const: 1
+
+      '#size-cells':
+        const: 0
+
+    patternProperties:
+      '^led(@[a-f0-9]+)?$':
+        $ref: /schemas/leds/common.yaml#
+
+    additionalProperties: false
+
 dependencies:
   pcs-handle-names: [pcs-handle]
 
-- 
2.39.2

