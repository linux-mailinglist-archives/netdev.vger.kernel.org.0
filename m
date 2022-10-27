Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3318460FB35
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 17:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235984AbiJ0PIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 11:08:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235863AbiJ0PIl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 11:08:41 -0400
Received: from wnew3-smtp.messagingengine.com (wnew3-smtp.messagingengine.com [64.147.123.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43F5018E737;
        Thu, 27 Oct 2022 08:08:39 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.west.internal (Postfix) with ESMTP id CDB482B067A1;
        Thu, 27 Oct 2022 11:08:37 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 27 Oct 2022 11:08:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=svenpeter.dev;
         h=cc:cc:content-transfer-encoding:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1666883317; x=
        1666890517; bh=tHzuOmU+HU6cakH/7CcnyTDF5rh8M6mBGsxwOP1JyDc=; b=G
        7xAg01PTVLno976Us4AWGP9QBpk2HpXKILrA6+iUqfPrfJxQ6wglqSmx/WHKNBDK
        znBRM43GB1QK7dELtGK3/CFCSmpdQHMpsZCvPC6bZ70Ylz43N+2IsMS8PGe19iTK
        mXsJKn00jJH8gpAZD0sxh6SkTQt4Qy2O361f7tR70e105ekFnG2rv1Ir1Hum1Zot
        yCPq53hv4pcX7LHrVFUfJI2FCIl4Zo8jXZF8tfSpBso+Dv/euWQAIPjXC9/+3bJa
        ddzVeNdG4yk/OZdg0vZg6/TgJx2OHyXACC7QLef3iOqEr2LdAjazLaX4e5xAv7Fh
        JWwaGkK23Dz52GmX1sz2w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1666883317; x=1666890517; bh=tHzuOmU+HU6ca
        kH/7CcnyTDF5rh8M6mBGsxwOP1JyDc=; b=LIVN6nxTIkLdZ3SccVwmhQTyd+/8F
        AnvKDef3rIPVRz99Yj5vtlDHM0BZXR2Fq9aB9nItf9ubddN2osGzcjZnUmiQRMd0
        XjEky9eG9r/Bti63CAAMv9E/d9OoPFlymTYFvGO7+OEj0ufL5bpbsCfYf0YYFg8x
        fOPQ6A42RMwa/mUDJVc7MEPB6s3x1XmI7Tkb4QxCG7T8Hdi2330lxO+0WuUTWAna
        IEYACu/4UCl06AnDWH6OTKAYCVH/SabZLuLbjFyXVR0dmFvk//T7yMBjO1a8WA2/
        gjFuEGXsKE9BCvWVMtmWJ1UsDXr/n1QXF+EjdLrVmb89BEExsPPlSKgKg==
X-ME-Sender: <xms:9J5aY9czs09jcQX2aXFG4txO4aAdC6JnzEKMlnHcX9Ty8Y36NXEAKA>
    <xme:9J5aY7NYCnS4PbwT3l-BGQ-YdPNTw5cHGMGeBr93dARgacQj_vRIZciE_qBxqfcat
    trw5kEDIPODYHaVw-w>
X-ME-Received: <xmr:9J5aY2jufKpuCqdcM5NusALuPW2N19DvL9ETDg1ayxQxCTVgL1Sy_3XxDDo_xsfeei7MC_Zhgs5YyALK2pZIvASwQaz7ZKa2R-2okpxpixb1V6SORGKsu9w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrtdeggdekfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefuvhgvnhcu
    rfgvthgvrhcuoehsvhgvnhesshhvvghnphgvthgvrhdruggvvheqnecuggftrfgrthhtvg
    hrnhephfeufffgffegtdefhfefueejfefghfelkeetuddvffeigeffuedvjeegudelieel
    necuffhomhgrihhnpeguvghvihgtvghtrhgvvgdrohhrghenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehsvhgvnhesshhvvghnphgvthgvrhdr
    uggvvh
X-ME-Proxy: <xmx:9J5aY29eJhJiJeV-Oz0ESTXIUScWIWxs5byOZOATt0yILnt14phj1w>
    <xmx:9J5aY5uzxb8MjuMbLDnZHaJKuZvElrsfiiXBiw53Wy0Qg6U7SZZibA>
    <xmx:9J5aY1FXVcQTPrjcRBQzYat2TBVHnAZVoOhfZ6s-IQIoZVmIoZjiaw>
    <xmx:9Z5aYyNiRZQKs9SMMEh6Qnc0xNVLNQpP9UVkb6RPFEgGigG3tiqOQTj42Dk>
Feedback-ID: i51094778:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 27 Oct 2022 11:08:33 -0400 (EDT)
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
        linux-arm-msm@vger.kernel.org, Rob Herring <robh@kernel.org>
Subject: [PATCH v4 1/7] dt-bindings: net: Add generic Bluetooth controller
Date:   Thu, 27 Oct 2022 17:08:16 +0200
Message-Id: <20221027150822.26120-2-sven@svenpeter.dev>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20221027150822.26120-1-sven@svenpeter.dev>
References: <20221027150822.26120-1-sven@svenpeter.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bluetooth controllers share the common local-bd-address property.
Add a generic YAML schema to replace bluetooth.txt for those.

Signed-off-by: Sven Peter <sven@svenpeter.dev>
Reviewed-by: Rob Herring <robh@kernel.org>
---
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

