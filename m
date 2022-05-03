Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A97251885B
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 17:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238218AbiECPYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 11:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238198AbiECPWL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 11:22:11 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3D0F3B284;
        Tue,  3 May 2022 08:18:30 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id p18so20219595edr.7;
        Tue, 03 May 2022 08:18:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=4CKD+DKMQd1ZEVY0/Od89OuEu7h6AxtbdaBQHqft0yE=;
        b=HKihauhgQX2IKgIzKLB0B3T94583zUyrC5ZwDOufzBh1kiCDtyzDhz4oGrE5BVXib0
         mt/8qujzN+FR+2oAwGydwXS2FXNkBJcww/w3VY8UZtodzt8CB/26N3Vd1gPyP/SMlGUf
         /4Qgqg51j2lLfcjHYrZTSBA04QEe4SOZQh8NxeUOy84luKqxWpdz26B16/HeCqCdv8Cw
         jBtURTZVZiUGTqkQnMYuwEhR4hfFrheL1l8NUnNeN5CkGra4D1M65+tLE0/NnAkD/GyW
         M/vK3eVnoilumQkuDbAvvLhtB3aBXUH56Im+FGuo81WwO8fv+K50j8ObbDVVsGZOo3wT
         GPyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4CKD+DKMQd1ZEVY0/Od89OuEu7h6AxtbdaBQHqft0yE=;
        b=e6keluzVr8CeVS+CiQgRrYyKw6LSHcFv5Gj2H8HrpPrZA0op46xp2pd4GQzTo2EAtC
         FbOBblO3ylx5F+QIhCjwqBu7zroupEE9ymUu2BY6jbP4zwd4Jk6nilkiA2T10cIZECbR
         ym0vpNFRXCQWMyqsh+1mYUVdYJLnq4oizscMHvfkdaKbS3S3r5hP44cgwQ8EejlZynRn
         uYe+GiLpiEm1hnLAnkSJuRvaPQ6VBzb2Wn/1jNCsoNWsYn6tbaiqcilt8lADHIz8jLG3
         Zow3xIcrfRmPuL8OOB9Z4zaI7YuNIiJew0avXyDpKuaoRs4qpvSRa7idKSsv1XmecTPw
         D1Tg==
X-Gm-Message-State: AOAM530H5S45Z5E43K3TGuCjv7r5dhaFJAdFPJkkSC/S1t1UxeMnzlp3
        MRYW7V3ZAU+G5xZl/pMyysE=
X-Google-Smtp-Source: ABdhPJwNPlohltAOl9bRzLdnMWY8egRON0HXgwdFSqhhIXHwaosoUIwMHnQDOIRpRY8cy3iEWVPrwQ==
X-Received: by 2002:a05:6402:3586:b0:427:b16e:a191 with SMTP id y6-20020a056402358600b00427b16ea191mr15097225edc.137.1651591109212;
        Tue, 03 May 2022 08:18:29 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id v3-20020aa7d9c3000000b0042617ba63cesm7947507eds.88.2022.05.03.08.18.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 08:18:28 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
Subject: [RFC PATCH v6 11/11] dt-bindings: net: dsa: qca8k: add LEDs definition example
Date:   Tue,  3 May 2022 17:16:33 +0200
Message-Id: <20220503151633.18760-12-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220503151633.18760-1-ansuelsmth@gmail.com>
References: <20220503151633.18760-1-ansuelsmth@gmail.com>
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

Add LEDs definition example for qca8k using the offload trigger as the
default trigger and add all the supported offload triggers by the
switch.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 .../devicetree/bindings/net/dsa/qca8k.yaml    | 20 +++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
index f3c88371d76c..9b46ef645a2d 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
@@ -65,6 +65,8 @@ properties:
                  internal mdio access is used.
                  With the legacy mapping the reg corresponding to the internal
                  mdio is the switch reg with an offset of -1.
+                 Each phy have at least 3 LEDs connected and can be declared
+                 using the standard LEDs structure.
 
 patternProperties:
   "^(ethernet-)?ports$":
@@ -287,6 +289,24 @@ examples:
 
                 internal_phy_port1: ethernet-phy@0 {
                     reg = <0>;
+
+                    leds {
+                        led@0 {
+                            reg = <0>;
+                            color = <LED_COLOR_ID_WHITE>;
+                            function = LED_FUNCTION_LAN;
+                            function-enumerator = <1>;
+                            linux,default-trigger = "netdev";
+                        };
+
+                        led@1 {
+                            reg = <1>;
+                            color = <LED_COLOR_ID_AMBER>;
+                            function = LED_FUNCTION_LAN;
+                            function-enumerator = <1>;
+                            linux,default-trigger = "netdev";
+                        };
+                    };
                 };
 
                 internal_phy_port2: ethernet-phy@1 {
-- 
2.34.1

