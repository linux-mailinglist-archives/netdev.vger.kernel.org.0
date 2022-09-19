Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 497D85BD27B
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 18:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbiISQtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 12:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbiISQth (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 12:49:37 -0400
Received: from new1-smtp.messagingengine.com (new1-smtp.messagingengine.com [66.111.4.221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D4526E5;
        Mon, 19 Sep 2022 09:49:35 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id D781258034C;
        Mon, 19 Sep 2022 12:49:33 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 19 Sep 2022 12:49:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=svenpeter.dev;
         h=cc:cc:content-transfer-encoding:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm2; t=1663606173; x=
        1663613373; bh=WY1oTPCX29Sg6WaZxih3jkcx9HGBoylBzzxcehqaLFs=; b=s
        N/kdIzh3Su3yvFe3pWf3qYncxV75euZDXXa03QXfcPb7U1LbWAoxcMfNRauq52OK
        YHvZUZt+A7xnIdeW3Ylhfgdmv+o2X7D7ys9L1RPRMVYH6FNH35kx3TajY+gEp3J+
        PqNAphtHq8dMtzJW0W7ElB+r68Lcve6WZkTq2seU36l+qsucB6AcNMAMni2nC4Tq
        uBi/okLiUx0MN7UJP8+8/fKNhFQYuer6Czl7F6hN/lQzYKa6HgF89TcKoB7Zs7ZP
        RU3sHgUp3B6dkongE+BfMypyvZvsVL1oG6GiLxS1Pxke5gwhUCgyVMv4N2w3dPAW
        xfGJTZ4Sw34o/IAp7v4ng==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1663606173; x=1663613373; bh=WY1oTPCX29Sg6
        WaZxih3jkcx9HGBoylBzzxcehqaLFs=; b=OVN3lOGVN4g6PA7oqBhC2Yu/mgZLO
        6LxgU5irL14lbOOxkBnFzkDiUKQ1Uiluio0JBNwTLJpceaV1rrlCPdWU5M6GqWIe
        WO78AWa3OP6wnM4ifs2hQrnHUxDTVifl4XHi6mNe5MTLaFnCdCHAY6A04hYVaDZx
        khnZLwAcCf2sy3Xox/YrlMbqiJQ4mSQ4gB0LLlG90cyAtLiRfDZAcLL8hBXcdx4F
        5wrimX11nafgcIt5C3XOK60+nb6xQG7RogH+RzpQoSKR9CIm/CtQTG461/jELra2
        icS8ll6NvBDLIjt2r7ZphY4EJyFgulsAd0zYMim+SfuGdm8d3+F9j8SIw==
X-ME-Sender: <xms:nJ0oY91OD_29Op6t-9gockrdYmfEHfhBg6lIgaC79EKNxEt5Ub_vVw>
    <xme:nJ0oY0E-ESKtTKHM7MwDYa8FWcwt2JPgYqNn_5faISbVuSwtozjjwOivJFoAO-tDr
    dzFAEXwZPd1kZ1S1PI>
X-ME-Received: <xmr:nJ0oY94_krixzgHNgdaMX7AfVQ2RTKm6ajVQ17_4IL5XDfPWlzqhrUKjaEI-PbAWNRTtQu1TsnHeaKZ8WyM5bxqWOuTlVbN6YJ3uL5QQmF8krsxGklg9hlo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfedvjedguddtkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefuvhgv
    nhcurfgvthgvrhcuoehsvhgvnhesshhvvghnphgvthgvrhdruggvvheqnecuggftrfgrth
    htvghrnhephfeufffgffegtdefhfefueejfefghfelkeetuddvffeigeffuedvjeegudel
    ieelnecuffhomhgrihhnpeguvghvihgtvghtrhgvvgdrohhrghenucevlhhushhtvghruf
    hiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehsvhgvnhesshhvvghnphgvthgv
    rhdruggvvh
X-ME-Proxy: <xmx:nJ0oY60RMqVE5E9bD2yQhp6rANSibCoNwTOd8xjrJAzJS-hTBiEmhQ>
    <xmx:nJ0oYwG58t-lAcbvQ1yv3wKG6_JPCapkwo0L4tkDB8O-JXoez6cAxQ>
    <xmx:nJ0oY79HYlj6iTKGa6EqtpiUPCDvzpbEZq4xkXtViv-SGpPpbf9dvA>
    <xmx:nZ0oY4LCMYSI83ICOy0odVQomIom3pg_56Y3Cztpc0Vip-0_i21uug>
Feedback-ID: i51094778:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Sep 2022 12:49:29 -0400 (EDT)
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
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH v3 1/7] dt-bindings: net: Add generic Bluetooth controller
Date:   Mon, 19 Sep 2022 18:48:28 +0200
Message-Id: <20220919164834.62739-2-sven@svenpeter.dev>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220919164834.62739-1-sven@svenpeter.dev>
References: <20220919164834.62739-1-sven@svenpeter.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bluetooth controllers share the common local-bd-address property.
Add a generic YAML schema to replace bluetooth.txt for those.

Signed-off-by: Sven Peter <sven@svenpeter.dev>
---
changes from v2:
  - added new bluetooth subdirectory and moved files there
  - removed minItems from local-bd-address
  - dropped bjorn.andersson@linaro.org, bgodavar@codeaurora.org and
    rjliao@codeaurora.org due to bouncing emails from the CC list

changes from v1:
  - removed blueetooth.txt instead of just replacing it with a
    deprecation note
  - replaced references to bluetooth.txt

 .../devicetree/bindings/net/bluetooth.txt     |  5 ----
 .../net/bluetooth/bluetooth-controller.yaml   | 29 +++++++++++++++++++
 .../{ => bluetooth}/qualcomm-bluetooth.yaml   |  6 ++--
 .../bindings/soc/qcom/qcom,wcnss.yaml         |  8 ++---
 4 files changed, 35 insertions(+), 13 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/bluetooth.txt
 create mode 100644 Documentation/devicetree/bindings/net/bluetooth/bluetooth-controller.yaml
 rename Documentation/devicetree/bindings/net/{ => bluetooth}/qualcomm-bluetooth.yaml (96%)

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
diff --git a/Documentation/devicetree/bindings/net/bluetooth/bluetooth-controller.yaml b/Documentation/devicetree/bindings/net/bluetooth/bluetooth-controller.yaml
new file mode 100644
index 000000000000..9309dc40f54f
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/bluetooth/bluetooth-controller.yaml
@@ -0,0 +1,29 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/bluetooth/bluetooth-controller.yaml#
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
diff --git a/Documentation/devicetree/bindings/net/qualcomm-bluetooth.yaml b/Documentation/devicetree/bindings/net/bluetooth/qualcomm-bluetooth.yaml
similarity index 96%
rename from Documentation/devicetree/bindings/net/qualcomm-bluetooth.yaml
rename to Documentation/devicetree/bindings/net/bluetooth/qualcomm-bluetooth.yaml
index f93c6e7a1b59..a6a6b0e4df7a 100644
--- a/Documentation/devicetree/bindings/net/qualcomm-bluetooth.yaml
+++ b/Documentation/devicetree/bindings/net/bluetooth/qualcomm-bluetooth.yaml
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
 %YAML 1.2
 ---
-$id: http://devicetree.org/schemas/net/qualcomm-bluetooth.yaml#
+$id: http://devicetree.org/schemas/net/bluetooth/qualcomm-bluetooth.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
 title: Qualcomm Bluetooth Chips
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
index 5320504bb5e0..0e6fd57d658d 100644
--- a/Documentation/devicetree/bindings/soc/qcom/qcom,wcnss.yaml
+++ b/Documentation/devicetree/bindings/soc/qcom/qcom,wcnss.yaml
@@ -42,15 +42,13 @@ properties:
   bluetooth:
     type: object
     additionalProperties: false
+    allOf:
+      - $ref: /schemas/net/bluetooth/bluetooth-controller.yaml#
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

