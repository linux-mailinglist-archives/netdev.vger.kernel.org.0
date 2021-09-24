Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81E17416CD3
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 09:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbhIXH3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 03:29:48 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:57875 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237142AbhIXH3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 03:29:37 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 93105580F3A;
        Fri, 24 Sep 2021 03:28:04 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 24 Sep 2021 03:28:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm3; bh=42KPiA9o6F1jM
        s8b/YN0eR5v0rC8lVUlITBUqZ+gpAk=; b=30UmSNETnSA1rVkshReILd/ybGt/d
        o+tPZnDH10SbNaZCyi5UEeEF4I981p5InBGJ12W8DJNgOCfSv3Z63GVevDZIX62Z
        q2izQsWkX+p18jgtWArbHeIQfdIhA/DdfFGiq9DmPtPpkNnk8Z1dDWgQ/I6nyhPM
        /DPn8rjiY4dlPG7zPfw+H9nG8R4/xBFpFfB06P6p6dFTZmBf1MEpbpZMCcfzp6QW
        EBebQH7k4Y6iCtwwLACfxFlw76YIgQKTdumWOP1JulIG0r8eGO1AyXAuCMnDUYF/
        wNCvbUJ8rtpML9rtTSmaWGA17gki7RKa2Yxf7YqUCoedmP1gHrmPB3ZiA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=42KPiA9o6F1jMs8b/YN0eR5v0rC8lVUlITBUqZ+gpAk=; b=b60VlNH0
        5vIDtx7ZaYWKOb+kZF06HYyyfBLshe9d3Ez7KwaOoVQ0JO4DVq5/IfDA0xzUXGL0
        sl1qVerjyxSs7EUjVlSe5kalur9zZVOnrD1fsZv07pNQguYm5b+NtZjJRhUOMB2w
        bAAbfHM5J/sGbOa1jLaTgnr7AqndmMmf5yCQmUKXA1ZcQXVxRG5OML7YQeIokGXZ
        reuHtx4jLPVyD08M4HJyLUBoAIhKWF/xvWGmUxOUy7UYzjvA+TtEj1Mj6y03NrIg
        CJFhEvuNIkCQw/FQYmFq+vG1JT4GcAac5yQbvYnUHgKlco1SVNly6oFIhEXhx3lW
        OTTeLtUxAMngPg==
X-ME-Sender: <xms:BH5NYR0lnb2tWfs1pGlM1FZE1JoufhXT-oYPUY0QuwldNhGBkCXJZg>
    <xme:BH5NYYH38o8E62AntUj9-rq2kbb5rcchDhYphZ5Wdr5kw8F6HcDIXzj9GfIqDdPNW
    0wP3rW7q8FNw6OyQns>
X-ME-Received: <xmr:BH5NYR6gHZXSzj0N-dppSbTIzSjDaAoETmR9I9aVVc_Etry3fmYgV9a-koX5VYo5jClmlZk6PBId-WL6yo_4IByVmLYJ8Osdigmx>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudejtddguddujecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enogevohgrshhtrghlqdfhgeduvddqtddvucdludehtddmnecujfgurhephffvufffkffo
    jghfggfgsedtkeertdertddtnecuhfhrohhmpeforgigihhmvgcutfhiphgrrhguuceomh
    grgihimhgvsegtvghrnhhordhtvggthheqnecuggftrfgrthhtvghrnhepveejieejtdev
    gfffgfejuefggfeutdelteekgeetueeftddutddtgfffhffgueffnecuffhomhgrihhnpe
    guvghvihgtvghtrhgvvgdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgr
    mhepmhgrihhlfhhrohhmpehmrgigihhmvgestggvrhhnohdrthgvtghh
X-ME-Proxy: <xmx:BH5NYe2MAwDRWAG4flVu1h4_lOzu5sJtkZHjZCkhIsCRP4wZMo_0VA>
    <xmx:BH5NYUGz397XGoshxw3qHfLvwBq1HSgjpbwFPQuTUB-ZbT13NT-prw>
    <xmx:BH5NYf9UHv8iLcYqOtWz58UV59aqjEkBHMlPK2HY1jD-Q3b8mhV1eg>
    <xmx:BH5NYYG3ggfJF6IP6l7KgYEKN939MckgiZ-RnN93BfA416qz7sIzLA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 24 Sep 2021 03:28:03 -0400 (EDT)
From:   Maxime Ripard <maxime@cerno.tech>
To:     Chen-Yu Tsai <wens@csie.org>, Maxime Ripard <maxime@cerno.tech>,
        =?UTF-8?q?Jernej=20=C5=A0krabec?= <jernej.skrabec@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Cc:     linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-sunxi@lists.linux.dev,
        "David S. Miller" <davem@davemloft.net>,
        de Goede <hdegoede@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Rob Herring <robh@kernel.org>
Subject: [RESEND v2 4/4] dt-bindings: net: wireless: Convert ESP ESP8089 binding to a schema
Date:   Fri, 24 Sep 2021 09:27:56 +0200
Message-Id: <20210924072756.869731-4-maxime@cerno.tech>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210924072756.869731-1-maxime@cerno.tech>
References: <20210924072756.869731-1-maxime@cerno.tech>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ESP8089 Wireless Chip is supported by Linux (through an out-of-tree
driver) thanks to its device tree binding.

Now that we have the DT validation in place, let's convert the device
tree bindings for that driver over to a YAML schema.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: de Goede <hdegoede@redhat.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
---
 .../bindings/net/wireless/esp,esp8089.txt     | 30 -------------
 .../bindings/net/wireless/esp,esp8089.yaml    | 43 +++++++++++++++++++
 2 files changed, 43 insertions(+), 30 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/wireless/esp,esp8089.txt
 create mode 100644 Documentation/devicetree/bindings/net/wireless/esp,esp8089.yaml

diff --git a/Documentation/devicetree/bindings/net/wireless/esp,esp8089.txt b/Documentation/devicetree/bindings/net/wireless/esp,esp8089.txt
deleted file mode 100644
index 6830c4786f8a..000000000000
--- a/Documentation/devicetree/bindings/net/wireless/esp,esp8089.txt
+++ /dev/null
@@ -1,30 +0,0 @@
-Espressif ESP8089 wireless SDIO devices
-
-This node provides properties for controlling the ESP8089 wireless device.
-The node is expected to be specified as a child node to the SDIO controller
-that connects the device to the system.
-
-Required properties:
-
- - compatible : Should be "esp,esp8089".
-
-Optional properties:
- - esp,crystal-26M-en: Integer value for the crystal_26M_en firmware parameter
-
-Example:
-
-&mmc1 {
-	#address-cells = <1>;
-	#size-cells = <0>;
-
-	vmmc-supply = <&reg_dldo1>;
-	mmc-pwrseq = <&wifi_pwrseq>;
-	bus-width = <4>;
-	non-removable;
-
-	esp8089: sdio_wifi@1 {
-		compatible = "esp,esp8089";
-		reg = <1>;
-		esp,crystal-26M-en = <2>;
-	};
-};
diff --git a/Documentation/devicetree/bindings/net/wireless/esp,esp8089.yaml b/Documentation/devicetree/bindings/net/wireless/esp,esp8089.yaml
new file mode 100644
index 000000000000..284ef45add99
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/wireless/esp,esp8089.yaml
@@ -0,0 +1,43 @@
+# SPDX-License-Identifier: GPL-2.0
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/wireless/esp,esp8089.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Espressif ESP8089 Device Tree Bindings
+
+maintainers:
+  - Hans de Goede <hdegoede@redhat.com>
+
+properties:
+  compatible:
+    const: esp,esp8089
+
+  reg:
+    maxItems: 1
+
+  esp,crystal-26M-en:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    description: >
+      Value for the crystal_26M_en firmware parameter
+
+required:
+  - compatible
+  - reg
+
+additionalProperties: false
+
+examples:
+  - |
+      mmc {
+          #address-cells = <1>;
+          #size-cells = <0>;
+
+          wifi@1 {
+              compatible = "esp,esp8089";
+              reg = <1>;
+              esp,crystal-26M-en = <2>;
+          };
+      };
+
+...
-- 
2.31.1

