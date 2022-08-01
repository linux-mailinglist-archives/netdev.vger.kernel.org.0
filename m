Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0895958679C
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 12:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231162AbiHAKjw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 06:39:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbiHAKju (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 06:39:50 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B92371B6;
        Mon,  1 Aug 2022 03:39:49 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 060EA5C00B2;
        Mon,  1 Aug 2022 06:39:49 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Mon, 01 Aug 2022 06:39:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=svenpeter.dev;
         h=cc:cc:content-transfer-encoding:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1659350389; x=
        1659436789; bh=Mz9Hzk+GHQX7q0f9ddatAPxHZ+IajsSZiJsLrFoGOJI=; b=0
        yakLLBAXpJayxZNWjomeExFykMZCiEy1qsKEZCcZi0fzNCokuiy+L4IinD1UH7tB
        fk0Mr4vUhrc/a3Ju/Qe+BuuowaxpVCm93pY3aDzuvYDEgdR7n7UbVAbu8SRPrCQm
        8vWJypRdrMU+dcU7wBDs1wtLX4PW1nnCd+c3Qa8hFKGbAbL+AS4I3Gs0PBNedm98
        axE0AvwLC4ptoiu8v8/qk2C1mgwLIPlqDwI45hkZeXYNY4W3ufx+OHq/cjcjIzRK
        qFZurqGsctsIcT/O91ld//RHfZLD3bhPCNb4nmD/eliMQEjZ2RSHYiSOqCzjpohQ
        8KSIEDCfnDin3FmKa6sFw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1659350389; x=1659436789; bh=Mz9Hzk+GHQX7q
        0f9ddatAPxHZ+IajsSZiJsLrFoGOJI=; b=yswEJ+9sn1O9Ns2Ji1d7o2DcnSpxw
        1+Sh7CpIHDtVw+WImGZgiIuLlc06svJPrS79UXDFjRW41BZNL/KDxlZy8BM0DIxr
        /2YyDJCNU8uiUYbSUEHk0mmd2+RWAlFo8JshoYWL4hqBTl/MwdEaVBDBfW4mUH+f
        B4QHGEB4XJOcxBE1Jgmd89IlsN+wBWNyR9tRnCUKC9nYW2FTFEQoyfUrQc5UmDHF
        G92jfe21Dbo0gYBTNFWckF7CWC6HhgknIGENSXtwSwJ76Oq2aeGvwsMY8crNVkiR
        LSUlJeEY422z2A3OZbsxc+qA+ZwXflatJTCWwBI4vmD8UnJ1j9hpTRh1g==
X-ME-Sender: <xms:dK3nYryLd8rDTYZUAwU10_EKgqGgg8aboolSP3OBoobk-LuIrFT1tA>
    <xme:dK3nYjSDt718PnVq-TOiIFLL2m5-cpiFDXKxp2Mh3CzQxiTaZiP67Tx74ML0tSgM3
    r2TONLXtVLCNrhxpjo>
X-ME-Received: <xmr:dK3nYlXtU6pNGaEncsfNZHr2nMoDXohD9_jvSGytYoXvUN-_d_7lHEE_FWaM9U4juIIxGW-uzkvw3FthH2wo5LdQOjlXsCDN76H5HINiPUY3jp77QQIcKzE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvddvfedgfeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepufhvvghn
    ucfrvghtvghruceoshhvvghnsehsvhgvnhhpvghtvghrrdguvghvqeenucggtffrrghtth
    gvrhhnpefhueffgfffgedtfefhfeeujeefgffhleekteduvdffieegffeuvdejgeduleei
    leenucffohhmrghinhepuggvvhhitggvthhrvggvrdhorhhgnecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepshhvvghnsehsvhgvnhhpvghtvghr
    rdguvghv
X-ME-Proxy: <xmx:dK3nYljXNbJXcEK_wP5s4C__jaN9ZECwhQU2Czlxwzs6wldL0S5b4w>
    <xmx:dK3nYtCEyVFPdFV3WlhBpsinGHNNE0wWmeACb7VyMzrKXPnfiokJoA>
    <xmx:dK3nYuIIxzAbzBDI9LhK79mrjhjcE6OcoPQugdEgjnuYA1TXHI624Q>
    <xmx:da3nYvzlK49TKTPUlAJ6weaTV5zyT8YY2Kq1dVgtgbcNVWpRB2g2zw>
Feedback-ID: i51094778:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 1 Aug 2022 06:39:46 -0400 (EDT)
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
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] dt-bindings: net: Add generic Bluetooth controller
Date:   Mon,  1 Aug 2022 12:36:29 +0200
Message-Id: <20220801103633.27772-2-sven@svenpeter.dev>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220801103633.27772-1-sven@svenpeter.dev>
References: <20220801103633.27772-1-sven@svenpeter.dev>
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
---
I hope it's fine to list the current Bluetooth maintainers in here
as well.

 .../bindings/net/bluetooth-controller.yaml    | 30 +++++++++++++++++++
 .../devicetree/bindings/net/bluetooth.txt     |  6 +---
 2 files changed, 31 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/bluetooth-controller.yaml

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
index 94797df751b8..3cb5a7b8e5ad 100644
--- a/Documentation/devicetree/bindings/net/bluetooth.txt
+++ b/Documentation/devicetree/bindings/net/bluetooth.txt
@@ -1,5 +1 @@
-The following properties are common to the Bluetooth controllers:
-
-- local-bd-address: array of 6 bytes, specifies the BD address that was
-  uniquely assigned to the Bluetooth device, formatted with least significant
-  byte first (little-endian).
+This file has been moved to bluetooth-controller.yaml.
-- 
2.25.1

