Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52A6A6AF8DC
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 23:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231666AbjCGWd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 17:33:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231196AbjCGWdx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 17:33:53 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 723679F236;
        Tue,  7 Mar 2023 14:33:36 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id e13so13627961wro.10;
        Tue, 07 Mar 2023 14:33:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678228415;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UQIxIQuz0qPop1m1y23AzYKP3fZZBi9ehi2OyfR3U2Q=;
        b=cwcFaL0DuRkZrkzWch+9kpLs9Wii5t1UBkhgiD976XDnd47PibX6P7HJsDNWhXQsAC
         yK4CJfDw2KR/e437kocckaAIzfj9Ahv14eVJ4UPd+TDydp/KPkT6s8g9jzO9nNh9zm+D
         T9mqGjK4siRrXX0ATVbAuDnQ4H7aPHmErXadXCgiWcCU7y25EMeDgFrAnhAsZ8StsyDn
         e5tHs/beIz2yXZ+BKseSarX41+9wVQ3yVRUjNpTwauMDqRhG3wo1gUPpzrMqRYAZcaCB
         8R2V0JQ9XIbKVx20qF+iGRTbZD5hxhAeKxO70O23L66l5dTMjzipRCCCnS/InsBkyPse
         HRbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678228415;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UQIxIQuz0qPop1m1y23AzYKP3fZZBi9ehi2OyfR3U2Q=;
        b=WcaHnF97wdC6C91TY/pkZJTPNN5Bg68V+Dgt6ikvj4VX4X0+u9rVwBfNTPxxC6Kk2r
         KBOk8gXAlKBaIKGUFOMCCS8X23Dk6XSwTDhepYkBaQZsEOm91yJwCGZ9Ouox8oNzbltX
         TUZWNdCo/j2+tdQO1CCEUz2mfj3MVJ+SIA6J3xBA7gydHJAjkxeE9VUKv8uy8i4DbJia
         gj79OsSgdIexOPP7pcdW3fRjSiEnexf37vTCbFqKAaLv4X19ZnZbfzB/viNQOQ/7Wywg
         KvFR4iK3mmiGwawgRuBBRYyYTe4Rv5ZDC1KqZGPLJU1jyRcCbWjMxxMVk8Zh38Zb0XqU
         ZHHA==
X-Gm-Message-State: AO0yUKXuEU5uKamh2/FtPCqcVOFTPt0/L2MdNta5iklXK+IlwSOLCsHX
        Jhwf2s9NNH67dCQQF+wqZzI=
X-Google-Smtp-Source: AK7set8Wl4lcBFilSaNGdtaALA6G8nL1wzO5CN2w3YjhPhV1YzjrNrqemmLvOfIeYIGIGEPNl2oS1g==
X-Received: by 2002:adf:e68e:0:b0:2ce:35d9:76ea with SMTP id r14-20020adfe68e000000b002ce35d976eamr9590187wrm.54.1678228414791;
        Tue, 07 Mar 2023 14:33:34 -0800 (PST)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id q11-20020a05600c46cb00b003dc1d668866sm19233101wmo.10.2023.03.07.14.33.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 14:33:34 -0800 (PST)
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
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Lee Jones <lee@kernel.org>,
        linux-leds@vger.kernel.org
Subject: [net-next PATCH 08/11] dt-bindings: net: dsa: dsa-port: Document support for LEDs node
Date:   Tue,  7 Mar 2023 18:00:43 +0100
Message-Id: <20230307170046.28917-9-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170046.28917-1-ansuelsmth@gmail.com>
References: <20230307170046.28917-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document support for LEDs node in dsa port.
Switch may support different LEDs that can be configured for different
operation like blinking on traffic event or port link.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 Documentation/devicetree/bindings/net/dsa/dsa-port.yaml | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
index 480120469953..f813e1f64f75 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
@@ -59,6 +59,13 @@ properties:
       - rtl8_4t
       - seville
 
+  leds:
+    type: object
+
+    patternProperties:
+      '^led(@[a-f0-9]+)?$':
+        $ref: /schemas/leds/common.yaml#
+
 # CPU and DSA ports must have phylink-compatible link descriptions
 if:
   oneOf:
-- 
2.39.2

