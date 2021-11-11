Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F51344CEF2
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 02:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233554AbhKKBiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 20:38:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233317AbhKKBiO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 20:38:14 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10D5BC06120E;
        Wed, 10 Nov 2021 17:35:24 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id b184-20020a1c1bc1000000b0033140bf8dd5so3273037wmb.5;
        Wed, 10 Nov 2021 17:35:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=mrT39HXhsvQIv884aQ7FKStKCV5fQEcK++rSuH4MPzo=;
        b=jqMykAR6VXN2xIlYa+0wkxRz2eQKa495CzICkfgqvBIgfgidn78nWvP9s8nJ3PFk56
         fXqoQARTue0J7vfhVzxyVF3xv1BsvuhV5UoP8eyO5pIZ5Z0OAF3v+GBMV0R8BNc1veyG
         4kv6yzBsb5vORckhrcygK5CXfMqhecblTRJ3z1qrp80K0cDaqxWYu4Lv878rEMLlZGWO
         cgfeSyXBcvqIiRRUD+AtoLs1zvKcAglW/i2G1SCImax741DfwBQ/RFpzp3JzVl3cgddH
         zIoXEEhK9Ez8pm5qCw8rlYx+v5kq2CKW6kDQQJqGIyJtiFnq7zqYKrdKFElqkfUQ6two
         zOMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mrT39HXhsvQIv884aQ7FKStKCV5fQEcK++rSuH4MPzo=;
        b=KW/kDXdIOHzzmiEEQorAXNOHLJUbkT1KJoP/FARkJANrEr8Tcf+mYXIs5RPwAQM2z2
         J39PizmW8itykRnxER8dj6nZs9QfE6mqRNelY6BSaTqNBYZ4LwqihYE+Cop2Lx8vvrED
         Z82I8ZZ7Z+CAr6fIx1OxmEHebIvxQ9OdDQbStSoro9/gpjYuhrUpDouxCpZpPPSpUyyM
         J+e9SoZujKmpqvsBn/r1AF6+aegAQ73O4MNR2tpgvMdtszY5YiMkIwQIrWQftpJC9Cz4
         Tm9aYe1CcUoqKAbKFXM10DMLJvbFNKytJYqfwLL9CFhS4/N3Hht5P1LDkl6IFgj0OaoH
         pPHQ==
X-Gm-Message-State: AOAM533n3LMQ+VOLhBtJlQDofxE5+2Q+LdSHWJn20MnipYPxv8UnFl0d
        OyurxRgKJtHkjLgmU/XiiouToV1e/+c=
X-Google-Smtp-Source: ABdhPJzM0hS2UOYIOh6e3NSsyIh7bBsGvStuj3qU0xtrkPQjGQsG/0culT4Hzqyr4W4oBtOugjZ4Gw==
X-Received: by 2002:a1c:2382:: with SMTP id j124mr4047911wmj.35.1636594522536;
        Wed, 10 Nov 2021 17:35:22 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id d8sm1369989wrm.76.2021.11.10.17.35.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 17:35:22 -0800 (PST)
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
Subject: [RFC PATCH v4 8/8] dt-bindings: net: dsa: qca8k: add LEDs definition example
Date:   Thu, 11 Nov 2021 02:35:00 +0100
Message-Id: <20211111013500.13882-9-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211111013500.13882-1-ansuelsmth@gmail.com>
References: <20211111013500.13882-1-ansuelsmth@gmail.com>
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

