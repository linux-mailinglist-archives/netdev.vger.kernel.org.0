Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D899658DDF
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 15:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233542AbiL2OWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 09:22:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233521AbiL2OWp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 09:22:45 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 523A912AE0
        for <netdev@vger.kernel.org>; Thu, 29 Dec 2022 06:22:44 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id cf42so27705374lfb.1
        for <netdev@vger.kernel.org>; Thu, 29 Dec 2022 06:22:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1BAXkIo3rvrG/ME3mVxzJSzvIaQ3txJwSjcnNOS9ikw=;
        b=V3imPe76scnNaQO8xSv/lhvcpfaRJYdVYbAJZp0kmaHYOwLoigjHxmoQbTbS64oN9k
         8IN/xYNg1fWk/42IJMQdIe4lnaLgBaEoRhBs8kDPYiIsCMpCLZ5Zwbin3k07C2ctBqNG
         an/WAR8NLBfMWscfFIcekwsb1AHF0mKLJNtDu/8p4vF+7rpZh+qrsK5ovE65crEK3JXt
         PoNU80576lEYsW0MlSdeIvzMuQpghcKms0nPmiANX7GUvpR5v1VOSlRMBxBxrtL53vhU
         GxH5/orDupZ6KbLejD5DOacisbZvUnaxoV0AfM9N6Y/uqifqBpZ8DR5CNUKUMbxpyigV
         SXYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1BAXkIo3rvrG/ME3mVxzJSzvIaQ3txJwSjcnNOS9ikw=;
        b=hOWuGnjpfGlHl4Qm3n2VQcQQ5IWz2rlilJ7oeDDNz3e/WGiKUJD1hjN7kXRvtLatRJ
         jRGxJ8FAjEpmpfy07L1W0Tkb1uL4E87otoC8tc2LoruKek4xKsZegPLLW6C3o98FZdLz
         a8xZIC8zgioJAaFXqLU7Gbllj/CCcZ24g5L9OeWBDSapJjsj9ROVooICjoD8mcEt19vn
         uCG9RZ803Ef4KFaw8sy2+P6BYuvHFIByIPU8chSG7wdZMPRDKoNgAJXi0455rInsAHih
         fN1EF6NwQ472ARgHfVfUWUsPTMJUt232XL+MIedoLa0MntQn3E4gcyKVBzfqu7vW/6sj
         HFpQ==
X-Gm-Message-State: AFqh2kqj9IEuIrUbLEOganf9Ra2QN8Tdpy24fNWaUacloSx7M90lI/uM
        vrEYpNipZ/KgJUG56hdpRw9Eog==
X-Google-Smtp-Source: AMrXdXvcQA0Uzx6rZXAkZMCT24xypP5gE887MmT00+TTqh9OkChuHBg9joE7PirouA/lGZGp69eETA==
X-Received: by 2002:a19:7114:0:b0:4b6:fddb:8e43 with SMTP id m20-20020a197114000000b004b6fddb8e43mr8605040lfc.26.1672323762648;
        Thu, 29 Dec 2022 06:22:42 -0800 (PST)
Received: from michal-H370M-DS3H.office.semihalf.net ([83.142.187.84])
        by smtp.googlemail.com with ESMTPSA id e13-20020a05651236cd00b004b57a810e09sm3098819lfs.288.2022.12.29.06.22.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Dec 2022 06:22:42 -0800 (PST)
From:   =?UTF-8?q?Micha=C5=82=20Grzelak?= <mig@semihalf.com>
To:     linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, andrew@lunn.ch,
        chris.packham@alliedtelesis.co.nz, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, upstream@semihalf.com, mw@semihalf.com,
        mchl.grzlk@gmail.com,
        =?UTF-8?q?Micha=C5=82=20Grzelak?= <mig@semihalf.com>
Subject: [PATCH v3] dt-bindings: net: marvell,orion-mdio: Fix examples
Date:   Thu, 29 Dec 2022 15:22:19 +0100
Message-Id: <20221229142219.93427-1-mig@semihalf.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As stated in marvell-orion-mdio.txt deleted in commit 0781434af811f
("dt-bindings: net: orion-mdio: Convert to JSON schema") if
'interrupts' property is present, width of 'reg' should be 0x84.
Otherwise, width of 'reg' should be 0x4. Fix 'examples:' and add
constraints checking whether 'interrupts' property is present
and validate it against fixed values in reg.

Signed-off-by: Michał Grzelak <mig@semihalf.com>
---
Changelog:
v2->v3
- drop quotes and blank line

v1->v2
- remove second example
- add 'if:' constraint to 'allOf:'
- move 'allOf:' before 'examples:'


 .../bindings/net/marvell,orion-mdio.yaml      | 30 ++++++++++++++++---
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/marvell,orion-mdio.yaml b/Documentation/devicetree/bindings/net/marvell,orion-mdio.yaml
index d2906b4a0f59..e35da8b01dc2 100644
--- a/Documentation/devicetree/bindings/net/marvell,orion-mdio.yaml
+++ b/Documentation/devicetree/bindings/net/marvell,orion-mdio.yaml
@@ -16,9 +16,6 @@ description: |
   8k has a second unit which provides an interface with the xMDIO bus. This
   driver handles these interfaces.
 
-allOf:
-  - $ref: "mdio.yaml#"
-
 properties:
   compatible:
     enum:
@@ -39,13 +36,38 @@ required:
   - compatible
   - reg
 
+allOf:
+  - $ref: mdio.yaml#
+
+  - if:
+      required:
+        - interrupts
+
+    then:
+      properties:
+        reg:
+          items:
+            - items:
+                - $ref: /schemas/types.yaml#/definitions/cell
+                - const: 0x84
+
+    else:
+      properties:
+        reg:
+          items:
+            - items:
+                - $ref: /schemas/types.yaml#/definitions/cell
+                - enum:
+                    - 0x4
+                    - 0x10
+
 unevaluatedProperties: false
 
 examples:
   - |
     mdio@d0072004 {
       compatible = "marvell,orion-mdio";
-      reg = <0xd0072004 0x4>;
+      reg = <0xd0072004 0x84>;
       #address-cells = <1>;
       #size-cells = <0>;
       interrupts = <30>;
-- 
2.34.1

