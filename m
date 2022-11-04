Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCF961A2FE
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 22:13:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbiKDVNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 17:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbiKDVN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 17:13:28 -0400
Received: from wnew3-smtp.messagingengine.com (wnew3-smtp.messagingengine.com [64.147.123.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3B381121;
        Fri,  4 Nov 2022 14:13:22 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.west.internal (Postfix) with ESMTP id 3655C2B066BD;
        Fri,  4 Nov 2022 17:13:20 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 04 Nov 2022 17:13:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=svenpeter.dev;
         h=cc:cc:content-transfer-encoding:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1667596399; x=
        1667603599; bh=tHzuOmU+HU6cakH/7CcnyTDF5rh8M6mBGsxwOP1JyDc=; b=Z
        KS6Jun3AkvRK7r0BM8pvmB93E3qYR5c8PDclKK0hxwhjwobeHgXFFp/qopbzN5fO
        ePt6zuXlMx2JkCF0UjyW0VtlxV9sHU3rfX7CoEQomkCp+MC0e43Ynl1VaNMIS3aO
        pwp+KfPKo8UKdf7r2S1lXep5leofZLczwftjeJTD1YbZG88GeejBa8t84A+jkXeJ
        LCyOjF9q4fNgKoOHJxkUkogEGC9ZqmAYCl86qmfdU3qPYSDybm8gLn+vB+C/iOYL
        pcHKEnJpV8QYTWivMW4mMYEDBpeZ8B152stPGX4lIdy14ti3K5fQUgugsC7Broz9
        cFeFBoune/CuHVRZYjuhg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1667596399; x=1667603599; bh=tHzuOmU+HU6ca
        kH/7CcnyTDF5rh8M6mBGsxwOP1JyDc=; b=EGVpLtTaGOxJXwfNf6S0FRSdW4PLK
        Fize4dZFwpmG6UoYPYjna7WwysWWAjAkYnjibcbfQlfsTQ5mDKVkfW3A04Fe92iR
        ohfcIAtM9wikxnbsERt+hg53GLKswjlaA6i6jc2QZq0/xeUu1/upuBufunLxcuCJ
        Ut0nNKOpp1oX5bmUPQ4OdKfQffaGHUUIufCS8tS7RnBA3vjWftOL0m7kSlFPRnxU
        r8LHsHGwlQz0jkDN1W2yIYx1SrUzYiTOVgXBYo31vfG+rLaIzBYer7LWjk1I3nID
        teTCJcCizZnoZ24CzBAxn/AzYY/KV0gLuVprITHruzkU1NDMmxWsfOTWw==
X-ME-Sender: <xms:b4BlY_uwA2Nty0PqnViWp-ynPW8EWzD3QM8p17TunxK1oMo59d-96g>
    <xme:b4BlYwf57ZJg-fevv_MjDowowozeLXjlJBogjMblbpsvZ-aiGqQK0ZPlrhb5nl-ce
    D8S3i4pYRScr4cR-G8>
X-ME-Received: <xmr:b4BlYyyq4_isWhKa1j5HgxaG0VWV1_vTdvXQwdaXt9XKEERlY9KkIJxDldkSE5cGBZBjgOiFbei0ZITg5UWVQqjwMUCwvN8xcapBUXzzKT1cgRhUFh9xdKe1SC85Yg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrvddugddugeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepufhvvghn
    ucfrvghtvghruceoshhvvghnsehsvhgvnhhpvghtvghrrdguvghvqeenucggtffrrghtth
    gvrhhnpefhueffgfffgedtfefhfeeujeefgffhleekteduvdffieegffeuvdejgeduleei
    leenucffohhmrghinhepuggvvhhitggvthhrvggvrdhorhhgnecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepshhvvghnsehsvhgvnhhpvghtvghr
    rdguvghv
X-ME-Proxy: <xmx:b4BlY-NoRtGbyvtUcq42Q9U03eEHx3pKm1gOtNwJk7M-Cz_dnXmcWg>
    <xmx:b4BlY_9eviRkz7V3NtjRSUvkYQmqkKguNc779zJm54w2id423_iKLw>
    <xmx:b4BlY-UoYuRzdOVRJgKkYNCZz0GCoVw6K0by3p4m4FlBA3xVUQjb-w>
    <xmx:b4BlY6e72_WEEpg8JMfCSuyGKtFpq5h8n1AnIEswYAjntyoi6whmH1h4JBs>
Feedback-ID: i51094778:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 4 Nov 2022 17:13:15 -0400 (EDT)
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
Subject: [PATCH v5 1/7] dt-bindings: net: Add generic Bluetooth controller
Date:   Fri,  4 Nov 2022 22:12:57 +0100
Message-Id: <20221104211303.70222-2-sven@svenpeter.dev>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20221104211303.70222-1-sven@svenpeter.dev>
References: <20221104211303.70222-1-sven@svenpeter.dev>
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

