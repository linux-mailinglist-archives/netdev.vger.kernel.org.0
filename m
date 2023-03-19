Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC5C6C0435
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 20:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbjCSTTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 15:19:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbjCSTTH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 15:19:07 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17CFEC65C;
        Sun, 19 Mar 2023 12:18:50 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id l12so8513626wrm.10;
        Sun, 19 Mar 2023 12:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679253529;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mZv5FnCiudZKDVGAnq53ZSH02fIH+isgRk91M2T3n+E=;
        b=PQ9TvN/Z+J6tBc9SVmvrVyMVKxr14rqIr+WZCNIqp4FMAgO+aHt/E+eieG2kqZ3ZZZ
         3l/hHKAmrcOpCyIoGf4d7AuZTce+GKMQH9GMzRKXfX5wlnTWKbhuy/w5DRZAlJzl3mcs
         2bwc8cjqIq1cpyJzJfETO45WMp6xo0AjXpQdOxcL4f2SGP3YBtOvd2T/duTrwZq+Cq6E
         vK7174vdHd0cp5NCPOPVItVRDxr8eKA72h4cc5rY7zv3+4jl9SKbS3E7WG3YgU5gLM8r
         sOuu+RlWU/9fKa6lxeQUff2eyAjtfOZShDY2MWNYubaC63tHHFCwpByd/ZhxY7I1yWJ5
         m/ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679253529;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mZv5FnCiudZKDVGAnq53ZSH02fIH+isgRk91M2T3n+E=;
        b=jswy1lVreDNCnoKNbt/c/XiCfV96tfAl9MHwdSbTJfE1X53bP7l/OIyV438D3kcCKH
         8CvX2vdMyAu3hOTbPkHMu/D0Uw6YQ4jqna8KYVGOcB8TzDpWhLwKmCwSJq3qvPkNNn67
         6DrQh/tADwGGWXX8iuvqw5pX6InxUZVVuej/frFjnjHqoeJSRjz36Nb1hkZulQ9uHrVM
         lWHb1Ke9ONv2eef+stpaCOZ/DGhXrhcbJaQ0ASiHAVTcuMTrb8ELpqfE4ErTbBPS5YtG
         aSqbUgetN+Dh2n/smBSMvVcH/7zwgIZ+6ucV9crANJy2OsbUEV/YeNR3acJVzRbxdvuD
         n+2A==
X-Gm-Message-State: AO0yUKWXoyrc21WgY+pNgIXxCtJrz6y4ICcAYyVcwMVXDwMKNsEDFiXc
        KA/clFrinprejDfqDqVrMfM=
X-Google-Smtp-Source: AK7set8DTz2u6rfaC0QVBQ2AnleUSa3iBD3B8ZpimjH09KMNhfR4snQ8COEkjsrc74q3uNQ/gAdxAw==
X-Received: by 2002:adf:dd83:0:b0:2cf:e517:c138 with SMTP id x3-20020adfdd83000000b002cfe517c138mr12463230wrl.66.1679253528712;
        Sun, 19 Mar 2023 12:18:48 -0700 (PDT)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id b7-20020a5d4b87000000b002cfe0ab1246sm7165167wrt.20.2023.03.19.12.18.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Mar 2023 12:18:48 -0700 (PDT)
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
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-leds@vger.kernel.org
Subject: [net-next PATCH v5 10/15] dt-bindings: net: ethernet-controller: Document support for LEDs node
Date:   Sun, 19 Mar 2023 20:18:09 +0100
Message-Id: <20230319191814.22067-11-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230319191814.22067-1-ansuelsmth@gmail.com>
References: <20230319191814.22067-1-ansuelsmth@gmail.com>
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

