Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE584474D4
	for <lists+netdev@lfdr.de>; Sun,  7 Nov 2021 18:58:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236107AbhKGSAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 13:00:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236069AbhKGSAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Nov 2021 13:00:46 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7B41C061570;
        Sun,  7 Nov 2021 09:58:02 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id z21so7974842edb.5;
        Sun, 07 Nov 2021 09:58:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=BkNZKWlktxVlCgFfDkbpw/BG6V3cG3yF0hJ0Q8+ra5w=;
        b=VARy+XsEOaU09CQ+dUfJX0Nxvo8LYXkBBHABv+5OzCONOY8Tb6wuqjXsXsQxohRBq/
         cDkoUtpm1WMQ341PXo2WHAP8tKoNpJQd8UT+6DNWka42/O2O58/NKEPGj6Y65Uqvt5Ge
         5a5Z6q0iVozPLqTQ3RlU87F+52Kiy5yGLhiEJR9JXJ/uc8xmnASpiJkebMeKgEZx5qof
         6nmcQJTUez/YGKrZST3wASRAX/CDfuHfZKsRIZAjSAK1WOHdIZdjIMY8KaHp37IPdGaT
         YOyjNu957Fjq6sxqgYwa8iHhTpUVonCQ7nI/2QalBbDxN7kFxswBct7Bp3U9ziXI2ZuO
         PaQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BkNZKWlktxVlCgFfDkbpw/BG6V3cG3yF0hJ0Q8+ra5w=;
        b=pA95ZgbLS+Rfbkb8rlAO57auJb+CV9YSu4n/HYs1ll5OU7qX7TOSzkz5yy461Z8Yaj
         whtUAAMNGQb2iy3tlsLI21I2d3JF8YKC8ewRu0gM5ow/Sg8NpNC7KdF15c0qJCmDjvFd
         QeiryUWV5adkj3uqndB2v7XVEzaBVub8aUd4TeqhqvSn+u5uIE3JdtSh0GSZOqpPfnzE
         XrgQmEnwO4iQU6wCxE/7N5zSnzTj4HcILt4E8HalagDBVPeobJv5GPvujiMXWq1gYoBr
         Qp7B4fHzdcZbVvQye4MtyqpexTpuIpsXcAsbRgHd+0UrVIkDehz3tR7VP2+Kd2Zk7cGr
         AMdA==
X-Gm-Message-State: AOAM531m0GzsGVhCC2IS/oS9KUJyInn3mLyn2jV9J37Hz+c/tAfcbS7d
        NUC7mFKHaCPZrG98CH7TfPE=
X-Google-Smtp-Source: ABdhPJzfFkbNftsCho1RAVW8xYuJC5CB2ugYT+lyVBQMZssUtfoFgGfthMl3LTvXfpIIR7sDc++8DA==
X-Received: by 2002:a17:907:ea5:: with SMTP id ho37mr67011769ejc.133.1636307881428;
        Sun, 07 Nov 2021 09:58:01 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id m11sm4251182edd.58.2021.11.07.09.58.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Nov 2021 09:58:01 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
Subject: [RFC PATCH 6/6] dt-bindings: net: dsa: qca8k: add LEDs definition example
Date:   Sun,  7 Nov 2021 18:57:18 +0100
Message-Id: <20211107175718.9151-7-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211107175718.9151-1-ansuelsmth@gmail.com>
References: <20211107175718.9151-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add LEDs definition example for qca8k using the offload trigger as the
default trigger and add all the supported offload triggers by the
switch.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 .../devicetree/bindings/net/dsa/qca8k.yaml    | 30 +++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
index 48de0ace265d..d8394f625d03 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
@@ -64,6 +64,8 @@ properties:
                  internal mdio access is used.
                  With the legacy mapping the reg corresponding to the internal
                  mdio is the switch reg with an offset of -1.
+                 Each phy have at least 3 LEDs connected and can be declared
+                 using the standard LEDs structure.
 
     properties:
       '#address-cells':
@@ -340,6 +342,34 @@ examples:
 
                 internal_phy_port1: ethernet-phy@0 {
                     reg = <0>;
+
+                    leds {
+                        led@0 {
+                            reg = <0>;
+                            color = <LED_COLOR_ID_WHITE>;
+                            function = LED_FUNCTION_LAN;
+                            function-enumerator = <1>;
+                            linux,default-trigger = "offload-phy-activity";
+                            linux,supported-offload-triggers = "rx-blink", "tx-blink", "ollision-blink",
+                                                        "link-10M", "link-100M", "link-1000M",
+                                                        "half-duplex", "full-duplex", "linkup-over",
+                                                        "power-on-reset", "blink-2hz", "blink-4hz",
+                                                        "blink-8hz", "blink-auto";
+                        };
+
+                        led@1 {
+                            reg = <1>;
+                            color = <LED_COLOR_ID_AMBER>;
+                            function = LED_FUNCTION_LAN;
+                            function-enumerator = <1>;
+                            linux,default-trigger = "offload-phy-activity";
+                            linux,supported-offload-triggers = "rx-blink", "tx-blink", "ollision-blink",
+                                                        "link-10M", "link-100M", "link-1000M",
+                                                        "half-duplex", "full-duplex", "linkup-over",
+                                                        "power-on-reset", "blink-2hz", "blink-4hz",
+                                                        "blink-8hz", "blink-auto";
+                        };
+                    };
                 };
 
                 internal_phy_port2: ethernet-phy@1 {
-- 
2.32.0

