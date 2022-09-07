Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 984375B0B6F
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 19:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbiIGR0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 13:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbiIGR0I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 13:26:08 -0400
X-Greylist: delayed 601 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 07 Sep 2022 10:26:07 PDT
Received: from wnew2-smtp.messagingengine.com (wnew2-smtp.messagingengine.com [64.147.123.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FA077A76C;
        Wed,  7 Sep 2022 10:26:06 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.west.internal (Postfix) with ESMTP id 6957E2B05AFC;
        Wed,  7 Sep 2022 13:09:49 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 07 Sep 2022 13:09:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=svenpeter.dev;
         h=cc:cc:content-transfer-encoding:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm2; t=1662570588; x=
        1662577788; bh=1l67auKXfKKr5V+qydEfaS1KzmWDHYdzVtkj3vUBAKQ=; b=L
        hYn1kPC4ANB4hSXlT0p+ztcziV0ENwuTOZb5mUedJdfL2ctPZ7rENEE2pFpphrxU
        /pJSpZRcY6vIHw0VqX2ZSGSgqtigL2HZIsmpRI3RoP8ECszRH9A9cWngioxWg47W
        6YyVrHp8iHcVJ7bj8pJT48+WknpW75vGXquvcoUcIyPvooK8Cdewj3M1t9TFHQnL
        LqHMne1yMyazGyY2Pf5+DOgbiI0zk4hFD+ObsM23Jrtn6FM6IfcFQLDrFvz2XSZ8
        nTg+f3qcrrLQGxLYgyiCOq8dau0IKPdtjNr/H04SUBcqkNNS47vWPT/e3vtqVHR5
        DTg5ELr/9ahK2mJaHN48A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1662570588; x=1662577788; bh=1l67auKXfKKr5
        V+qydEfaS1KzmWDHYdzVtkj3vUBAKQ=; b=Cm5HS+MIXlVhFAAF7fp8Qz5rpc/AN
        2EHVkvefu3dF637Itkw4lGHPjvOZtGTHFipuJ5rITIZeFDWokXWUHUIP84m3c1uH
        mWi6yMSwUyjeACmr/rtxZbdBfK1co3XxRLiQQ6ICun3ddIb0kWOQCzfXeGAOba6u
        52qUOf2nNi7E8Skdmv19/ryD9ml5JzpOiztI6k87VyTKa8Q3pR2DRruawmqVlKgp
        qK/Ae8EZ540m4SJaQuctG2uTcNLuHAqArauRZgOCD6w6awY2Lo2YgDcgmm7Kzn0q
        IiXCrI9a1c9d5ULzaAlTvSMcqeREEGQWD+mgPwuVXemq18gFQZA8EiYKQ==
X-ME-Sender: <xms:XNAYY9gHgkQj-XuxMdYJBwXGEFz-_UA4GtU5KxklswHo4pELFlK19g>
    <xme:XNAYYyCDf9GDQOxxUgBpRYWmzXtxgritiME6jheNb1c-2T5BW6AHK0U09DUjR82Pv
    yHKOCfzSREpTeUT8Do>
X-ME-Received: <xmr:XNAYY9Hs-Vvu8YIxbXC5myI42MuIum5LwPBE005wt5dgmF4OmF-mb6NY_h8i4v2M5lcBdphDbxU1c0HuSaTgq6qrdlUFZ1nBc1BHESjDlIsnXTy53ZIy1wA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfedttddguddtlecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefuvhgv
    nhcurfgvthgvrhcuoehsvhgvnhesshhvvghnphgvthgvrhdruggvvheqnecuggftrfgrth
    htvghrnhephfeufffgffegtdefhfefueejfefghfelkeetuddvffeigeffuedvjeegudel
    ieelnecuffhomhgrihhnpeguvghvihgtvghtrhgvvgdrohhrghenucevlhhushhtvghruf
    hiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehsvhgvnhesshhvvghnphgvthgv
    rhdruggvvh
X-ME-Proxy: <xmx:XNAYYyQHvYc6SdlOh6KJAxBGBAJvtUCIPX_7O4qeyHFOgwMBz7vJDA>
    <xmx:XNAYY6wmWqlDizKt2DyRY0mSRySX-WkNZR10JMsj48lsvXWxSGhzww>
    <xmx:XNAYY46bl2mPSPn-HJ0WJ-wYO83zjfat4prozU04cZHp7i1hecPK5g>
    <xmx:XNAYYxjuD-2L228syW3rOFEElLgxIxxPnkbJ8vHmJUhVuYRv5Yvu9PKU2tw>
Feedback-ID: i51094778:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 7 Sep 2022 13:09:45 -0400 (EDT)
From:   Sven Peter <sven@svenpeter.dev>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Sven Peter <sven@svenpeter.dev>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hector Martin <marcan@marcan.st>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        asahi@lists.linux.dev, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Balakrishna Godavarthi <bgodavar@codeaurora.org>,
        Rocky Liao <rjliao@codeaurora.org>,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH v2 1/5] dt-bindings: net: Add generic Bluetooth controller
Date:   Wed,  7 Sep 2022 19:09:31 +0200
Message-Id: <20220907170935.11757-2-sven@svenpeter.dev>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220907170935.11757-1-sven@svenpeter.dev>
References: <20220907170935.11757-1-sven@svenpeter.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Bluetooth controllers share the common local-bd-address property.
Add a generic YAML schema to replace bluetooth.txt for those.

Signed-off-by: Sven Peter <sven@svenpeter.dev>
---
changes from v1:
  - removed blueetooth.txt instead of just replacing it with a
    deprecation note
  - replaced references to bluetooth.txt

checkpatch complains here because it thinks I do to many things at once,
I think it's better to replace bluetooth.txt in single commit though.
Let me know if you prefer this to be split into multiple commits
instead.

.../bindings/net/bluetooth-controller.yaml    | 30 +++++++++++++++++++
 .../devicetree/bindings/net/bluetooth.txt     |  5 ----
 .../bindings/net/qualcomm-bluetooth.yaml      |  4 +--
 .../bindings/soc/qcom/qcom,wcnss.yaml         |  8 ++---
 4 files changed, 35 insertions(+), 12 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/bluetooth-controller.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/bluetooth.txt

diff --git a/Documentation/devicetree/bindings/net/bluetooth-controller.yaml b/Documentation/devicetree/bindings/net/bluetooth-controller.yaml
new file mode 100644
index 000000000000..0ea8a20e30f9
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/bluetooth-controller.yaml
@@ -0,0 +1,30 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/bluetooth-controller.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Bluetooth Controller Generic Binding
+
+maintainers:
+  - Marcel Holtmann <marcel@holtmann.org>
+  - Johan Hedberg <johan.hedberg@gmail.com>
+  - Luiz Augusto von Dentz <luiz.dentz@gmail.com>
+
+properties:
+  $nodename:
+    pattern: "^bluetooth(@.*)?$"
+
+  local-bd-address:
+    $ref: /schemas/types.yaml#/definitions/uint8-array
+    minItems: 6
+    maxItems: 6
+    description:
+      Specifies the BD address that was uniquely assigned to the Bluetooth
+      device. Formatted with least significant byte first (little-endian), e.g.
+      in order to assign the address 00:11:22:33:44:55 this property must have
+      the value [55 44 33 22 11 00].
+
+additionalProperties: true
+
+...
diff --git a/Documentation/devicetree/bindings/net/bluetooth.txt b/Documentation/devicetree/bindings/net/bluetooth.txt
deleted file mode 100644
index 94797df751b8..000000000000
--- a/Documentation/devicetree/bindings/net/bluetooth.txt
+++ /dev/null
@@ -1,5 +0,0 @@
-The following properties are common to the Bluetooth controllers:
-
-- local-bd-address: array of 6 bytes, specifies the BD address that was
-  uniquely assigned to the Bluetooth device, formatted with least significant
-  byte first (little-endian).
diff --git a/Documentation/devicetree/bindings/net/qualcomm-bluetooth.yaml b/Documentation/devicetree/bindings/net/qualcomm-bluetooth.yaml
index f93c6e7a1b59..77eefa883d0a 100644
--- a/Documentation/devicetree/bindings/net/qualcomm-bluetooth.yaml
+++ b/Documentation/devicetree/bindings/net/qualcomm-bluetooth.yaml
@@ -79,8 +79,7 @@ properties:
   firmware-name:
     description: specify the name of nvm firmware to load
 
-  local-bd-address:
-    description: see Documentation/devicetree/bindings/net/bluetooth.txt
+  local-bd-address: true
 
 
 required:
@@ -89,6 +88,7 @@ required:
 additionalProperties: false
 
 allOf:
+  - $ref: bluetooth-controller.yaml#
   - if:
       properties:
         compatible:
diff --git a/Documentation/devicetree/bindings/soc/qcom/qcom,wcnss.yaml b/Documentation/devicetree/bindings/soc/qcom/qcom,wcnss.yaml
index 5320504bb5e0..a1417cf30a32 100644
--- a/Documentation/devicetree/bindings/soc/qcom/qcom,wcnss.yaml
+++ b/Documentation/devicetree/bindings/soc/qcom/qcom,wcnss.yaml
@@ -42,15 +42,13 @@ properties:
   bluetooth:
     type: object
     additionalProperties: false
+    allOf:
+      - $ref: /schemas/net/bluetooth-controller.yaml#
     properties:
       compatible:
         const: qcom,wcnss-bt
 
-      local-bd-address:
-        $ref: /schemas/types.yaml#/definitions/uint8-array
-        maxItems: 6
-        description:
-          See Documentation/devicetree/bindings/net/bluetooth.txt
+      local-bd-address: true
 
     required:
       - compatible
-- 
2.25.1

