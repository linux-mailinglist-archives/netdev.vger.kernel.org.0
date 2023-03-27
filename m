Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5376CA719
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 16:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232985AbjC0OMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 10:12:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232856AbjC0OMF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 10:12:05 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 943725BB3;
        Mon, 27 Mar 2023 07:11:19 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id v1so8962018wrv.1;
        Mon, 27 Mar 2023 07:11:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679926278;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3Z6/vpShlUlg/J0rkwr+qjoQBR81Rffp5jMKcKsFHNI=;
        b=lp+M6+H7U9MucCz9wGB7fQjadR8acyOZHoS+5jL8JC9QKyYD+rhj5QCH/p65CKgRmO
         Cs3fdKAcSGfB6GafxQCHo5p0v9xzqOatsWDtbmkCiNxkIZ3SX2hwlUHjyCsS3g80bBsk
         K2yxce0zqgXoC/8WqGrtsCyokYZIX0lEEKeerB4cLt0tgo7Gvz25e97fT3UDxa++5YVN
         h9Sm5kJoNTVQ7Y52qSuD0c3OU+gzEmreenWyaOiduiqCDhQe0bDGJMxuLeeGsg2HA2jy
         sTkPv45klKnzBLaiDfMBvyAZrIfEtam//It/VfMkbNBTP7jMKbgYjYya6vDowbcpGSft
         jbQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679926278;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3Z6/vpShlUlg/J0rkwr+qjoQBR81Rffp5jMKcKsFHNI=;
        b=jRDooIU3jkfFYNYLOm8o2Vlz+pIkNLP3cMUEU1cpgHbckaRqR5xCxwOpObOW7omBtm
         tbKCktyEEvvxZopgmB/Kz1B9QKX3D8R8ajlI6J56ve1LC1K5Ug4IAzu0/di4rR3rALZJ
         mqQlbqlO/oQKMN4vmTGVcyeMcYQO7uw1/ywOvYatJDlaBz7aHrjaXk+mBeyi54McFBbZ
         18i/ZK3XjcaODl6JdgTMomSYE3sbeexfwTzeEKp5+fJuvrbR21AbM8bTC2GJyXba3UAP
         rVo6uXjdziDkiCLN8cQ6VfVnG8oUNnyRmvklGx3qHjPK9PJmhyPQYSqh1wA6FHgRkyCO
         eN9w==
X-Gm-Message-State: AAQBX9cP/CSuXw9sxr3ESM+Bw7UpUhlrzTWkqundYG3Y3wY5MP0iuvKx
        re/rn7NykYTRfxpOFWd6470=
X-Google-Smtp-Source: AKy350ZzxqZMh5iOjbZYPWRnemygLvqUrM+NlUJa3yuZXBpaPSFFJmEwwWpEF6BT0SrmHFY4iftS/g==
X-Received: by 2002:adf:f491:0:b0:2ce:da65:12d9 with SMTP id l17-20020adff491000000b002ceda6512d9mr9863140wro.15.1679926277917;
        Mon, 27 Mar 2023 07:11:17 -0700 (PDT)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id p17-20020adfcc91000000b002c71dd1109fsm25307591wrj.47.2023.03.27.07.11.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 07:11:17 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Subject: [net-next PATCH v6 12/16] dt-bindings: net: dsa: qca8k: add LEDs definition example
Date:   Mon, 27 Mar 2023 16:10:27 +0200
Message-Id: <20230327141031.11904-13-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230327141031.11904-1-ansuelsmth@gmail.com>
References: <20230327141031.11904-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
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

Add LEDs definition example for qca8k Switch Family to describe how they
should be defined for a correct usage.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 .../devicetree/bindings/net/dsa/qca8k.yaml    | 24 +++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
index 389892592aac..ad354864187a 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
@@ -18,6 +18,8 @@ description:
   PHY it is connected to. In this config, an internal mdio-bus is registered and
   the MDIO master is used for communication. Mixed external and internal
   mdio-bus configurations are not supported by the hardware.
+  Each phy has at most 3 LEDs connected and can be declared
+  using the standard LEDs structure.
 
 properties:
   compatible:
@@ -117,6 +119,7 @@ unevaluatedProperties: false
 examples:
   - |
     #include <dt-bindings/gpio/gpio.h>
+    #include <dt-bindings/leds/common.h>
 
     mdio {
         #address-cells = <1>;
@@ -226,6 +229,27 @@ examples:
                     label = "lan1";
                     phy-mode = "internal";
                     phy-handle = <&internal_phy_port1>;
+
+                    leds {
+                        #address-cells = <1>;
+                        #size-cells = <0>;
+
+                        led@0 {
+                            reg = <0>;
+                            color = <LED_COLOR_ID_WHITE>;
+                            function = LED_FUNCTION_LAN;
+                            function-enumerator = <1>;
+                            default-state = "keep";
+                        };
+
+                        led@1 {
+                            reg = <1>;
+                            color = <LED_COLOR_ID_AMBER>;
+                            function = LED_FUNCTION_LAN;
+                            function-enumerator = <1>;
+                            default-state = "keep";
+                        };
+                    };
                 };
 
                 port@2 {
-- 
2.39.2

