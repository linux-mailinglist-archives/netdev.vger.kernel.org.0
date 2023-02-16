Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 865D1698A19
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 02:37:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbjBPBhf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 20:37:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbjBPBhX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 20:37:23 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF08646159;
        Wed, 15 Feb 2023 17:36:33 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id s13-20020a05600c45cd00b003ddca7a2bcbso436587wmo.3;
        Wed, 15 Feb 2023 17:36:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UXjDXVBhPh+t9c62wIxQrMzlmx5/oPRIL9dFvo3+Emc=;
        b=eSPyZlmnVMuk7xkgaR5rAsNsQHXeLwRWwy9mGle9Ba0+6mFf7vasHk1mk7gtlNhv+g
         Otp8kwMuIP2+Y0g5vRF9lQJU9B4VvAGnmiaddUS9Av+LwHdtxzejBxiRH8rlnlMe1mwq
         LvSkPsj+II+gNmlXvSQ2c+EoYzR+5BmcWwR+j153Tm2ATh1P6VYQyEy0HuZuuIJBsA0w
         ED8pnbZnzuC2OBDmNfZdTHgtjBqKGtkR9udEHnDm40plgvE2FJhR85VrmRG87HSYRn6g
         1zoVDF9Vp/Zh8T4uNOh/5TNqrdXt+AHWOo9Mx7UzcvNPXF7dWY9DontZIrQRnJUez1sj
         d39g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UXjDXVBhPh+t9c62wIxQrMzlmx5/oPRIL9dFvo3+Emc=;
        b=I02yUd+RLc0hMogeMFBzas3Dc7+4l2WteA28AEsKqogf7zsF3bLGkPR+uyXgEnhUxm
         OsmufbAUaGojfmvVDNIyXksVa9Kzr1HTniMmE2kXFHalp9/3p8OnvQzqyQ8zJ/dlTaG1
         EnroR8gT0HQ0/KiBy9yUwwYqeb0zedXPSVXs8yDTZQfgHK1oe0/6JADQFq2wn9IW5MpY
         O5A0SRSY5YsniUo3IeIfdGDJ3ld8bums3ayMw2TQH5Vcz2FCpNk/bdc0wX9SdOijXtJ8
         MdbMxLdeL+SdAmvoxmdVbegltBh3/Vwmd0dzqVltIma1zMVCFvZmFm23wmsrcZ3ldHTo
         FISQ==
X-Gm-Message-State: AO0yUKVC/4B15VpxmxjVxQm0yf4MHdsXAWfhC1mcBN1nfg4+opwYEffT
        Sv4nnOtsxdzJ8ySFVy/lTaI=
X-Google-Smtp-Source: AK7set/gIe01fhNDx8RfJetArP9XD6OKX2UcVlBJULuAx419s18tbxUMeRl0EjdhF3wHyo3Gz2MV9g==
X-Received: by 2002:a05:600c:708:b0:3dc:1687:9ba2 with SMTP id i8-20020a05600c070800b003dc16879ba2mr3525748wmn.35.1676511391667;
        Wed, 15 Feb 2023 17:36:31 -0800 (PST)
Received: from localhost.localdomain (93-34-91-73.ip49.fastwebnet.it. [93.34.91.73])
        by smtp.googlemail.com with ESMTPSA id v15-20020a05600c214f00b003e1fb31fc2bsm64189wml.37.2023.02.15.17.36.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 17:36:31 -0800 (PST)
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
        Jonathan Corbet <corbet@lwn.net>,
        Christian Marangi <ansuelsmth@gmail.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        John Crispin <john@phrozen.org>, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        Tim Harvey <tharvey@gateworks.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Arun.Ramadoss@microchip.com
Subject: [PATCH v8 11/13] dt-bindings: leds: Document netdev trigger
Date:   Thu, 16 Feb 2023 02:32:28 +0100
Message-Id: <20230216013230.22978-12-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230216013230.22978-1-ansuelsmth@gmail.com>
References: <20230216013230.22978-1-ansuelsmth@gmail.com>
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

Document the netdev trigger that makes the LED blink or turn on based on
switch/phy events or an attached network interface.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 Documentation/devicetree/bindings/leds/common.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/leds/common.yaml b/Documentation/devicetree/bindings/leds/common.yaml
index d34bb58c0037..6e016415a4d8 100644
--- a/Documentation/devicetree/bindings/leds/common.yaml
+++ b/Documentation/devicetree/bindings/leds/common.yaml
@@ -98,6 +98,8 @@ properties:
             # LED alters the brightness for the specified duration with one software
             # timer (requires "led-pattern" property)
           - pattern
+            # LED blink and turns on based on netdev events
+          - netdev
       - pattern: "^cpu[0-9]*$"
       - pattern: "^hci[0-9]+-power$"
         # LED is triggered by Bluetooth activity
-- 
2.38.1

