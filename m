Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C91FD44A4C2
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 03:26:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242168AbhKIC3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 21:29:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241602AbhKIC3K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 21:29:10 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC83EC061224;
        Mon,  8 Nov 2021 18:26:24 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id g14so69814924edz.2;
        Mon, 08 Nov 2021 18:26:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=mrT39HXhsvQIv884aQ7FKStKCV5fQEcK++rSuH4MPzo=;
        b=TtLZw0cKGccSEVuFq/ci2LfNq61NfHPpsdi/btVt0vocMNp7RvPxb1NweLVfLV26qu
         AP1dascAnKp9lbt4R7Lkz2Uiqv67q7bU+k+H9J7WTMWHLuIIwbWrlP2DgbgzOit+8Yb2
         pnqbOLAXRr6rcSjACgmU6Vc8HlH/aSn8X8qozTBsW0tFkm0Q+rQUL4RG9yM0D7FWhrJQ
         dngdZ+DovbJaoWEUfteVxHajaJpTewt+84q+M183xwZZ3T4HI6jKNsUhmOvlKg3edc4F
         1isyB0HZ1fWlade98AGS+W5R6icPtavNZ38ACxoooRTHLTReUoiIGUDS+VT2o45BWugg
         /p8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mrT39HXhsvQIv884aQ7FKStKCV5fQEcK++rSuH4MPzo=;
        b=yvOCdV1XBeGUQEXINSs5VQwA9Lr6Q80CTYmz5wh2d1ikTIhZY10IyZXTQPlx85bb3X
         wca4nFVq2Sbt9KiQb7ezVWyUOGsez7vbwhk+ff9Z3UkpNXgqFe7i8G+BNGp+atxIKZFa
         7bkKspZsEjcLdYmz75i6F901k5cvsY6zLHUN2EEqDaReGntZrvg/N8XZfL50XEC4IPad
         UCWzvX68tJMrU+mdvtWat6wuo+0LIjAKx5tgbJANIyLUlOLPIogz9iVwOrNOGbV1msR+
         1HDXm8z83KH9jljyI8SZ0Y0ST7BzA774L4yw53cKxuDhUTYkQackopFRVtJyL38uYfT0
         mQ1A==
X-Gm-Message-State: AOAM532D2S/g2W8ym/XddbfNQrwp+XQ6YmjVcH7zaIG1VFqdAOyZkRVo
        ZQOQcwZ4QpZZR69KFRv9sMBuHPzU7sU=
X-Google-Smtp-Source: ABdhPJy24NOHPnnqMkGHRYS1LShCI3ybVPcsuMyTgHDUGnU+w1NX7iXPyWo4o9kEi+eNCaeTd6rVWg==
X-Received: by 2002:a50:d4cd:: with SMTP id e13mr5213578edj.29.1636424783388;
        Mon, 08 Nov 2021 18:26:23 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id m5sm8760900ejc.62.2021.11.08.18.26.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 18:26:23 -0800 (PST)
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
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [RFC PATCH v3 8/8] dt-bindings: net: dsa: qca8k: add LEDs definition example
Date:   Tue,  9 Nov 2021 03:26:08 +0100
Message-Id: <20211109022608.11109-9-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211109022608.11109-1-ansuelsmth@gmail.com>
References: <20211109022608.11109-1-ansuelsmth@gmail.com>
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
 .../devicetree/bindings/net/dsa/qca8k.yaml    | 20 +++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
index 48de0ace265d..106d95adc1e8 100644
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
@@ -340,6 +342,24 @@ examples:
 
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
+                        };
+
+                        led@1 {
+                            reg = <1>;
+                            color = <LED_COLOR_ID_AMBER>;
+                            function = LED_FUNCTION_LAN;
+                            function-enumerator = <1>;
+                            linux,default-trigger = "offload-phy-activity";
+                        };
+                    };
                 };
 
                 internal_phy_port2: ethernet-phy@1 {
-- 
2.32.0

