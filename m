Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C11683FD68C
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 11:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243577AbhIAJVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 05:21:00 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:38961 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243545AbhIAJUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 05:20:49 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 022B3580B15;
        Wed,  1 Sep 2021 05:19:53 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 01 Sep 2021 05:19:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm3; bh=42KPiA9o6F1jM
        s8b/YN0eR5v0rC8lVUlITBUqZ+gpAk=; b=1xj3P1v7HLS5BsmQBv4IHJgFfZt9K
        s+hXmH7HhTrQ29hvw6SBOLPUzol2bALR+aVdIhIfUoYrHVf+FEmY9stHgTv3z/P+
        XCvJ2ADcGjkaOlovldOlI7s+0IsG6q0Too+NFbi/7Szw43smQAreIGLvKdc+s/nP
        TppD7LGSXZIL6oMMgcccWzdFssxK+x5quE/FXvAzwO5kcC30mgYSCl7hPHGXHAgF
        kyDj8TiXx/CsCKuA5VKqsGTR2R0HUch691TISVYN902JygFGLI/lHXa/XLmS9UJa
        9qFlKZMHjyWatbVI5nVXSdosUrk9z3ybkMmkYBKeoTH2/MPlgRzq7e3Ng==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=42KPiA9o6F1jMs8b/YN0eR5v0rC8lVUlITBUqZ+gpAk=; b=qqXEIEbR
        7/0jD5bdUZJQzXxuWdY0eH9ILHsKpLezzAcZLaK0ISub4FwCMXY5xi33OlHVOFmc
        Hw21UdRl/tdGLPdLklxtjIn4rz90dNcV4VP3Hrz/UG5APOH4YM8chAgz8jdOF9es
        wXKLjgh/590s6BE8glu9NYPRgCaxuI51purssTmkSsle7/0/2kF2EECu6Keyui9K
        1qVgh3vgP74DBgBv6qpbYu0BQuwbdyXECclm8WPSaJBKf05WU7S3PoqlisxYvhwi
        DhW+18xTe9A/eeck61C+Ep6UKCA0vmawFqy9ANEZKYjJ39HSiNxxI+ViWDuJlkw6
        uECZm2wy166PjQ==
X-ME-Sender: <xms:uEUvYaq8pRgOsg8OujEGelYjoQmq6_jvjN8y96xf-nXtE45hAnU1dQ>
    <xme:uEUvYYoswAYswkQ8IKtrbEXBMz7jl063WTY5nF8eB5EkdNsYQl9oc7u_WgjdalKeC
    eL0SFI3cY6iHBV1UJA>
X-ME-Received: <xmr:uEUvYfNKbzq6cunkoe3-GCyIbdeT9PVunHhFE1ggXT_YJPnmrzAPxtScOzFcIK2I9QxV1CST6qKj_eLWqoETCuhFHGNnCA0K3zTs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddvfedgudehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    govehorghsthgrlhdqhfeguddvqddtvdculdduhedtmdenucfjughrpefhvffufffkofgj
    fhgggfestdekredtredttdenucfhrhhomhepofgrgihimhgvucftihhprghrugcuoehmrg
    igihhmvgestggvrhhnohdrthgvtghhqeenucggtffrrghtthgvrhhnpeevjeeijedtvefg
    fffgjeeugffguedtleetkeegteeufedtuddttdfgfffhgfeuffenucffohhmrghinhepug
    gvvhhitggvthhrvggvrdhorhhgnecuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghm
    pehmrghilhhfrhhomhepmhgrgihimhgvsegtvghrnhhordhtvggthh
X-ME-Proxy: <xmx:uEUvYZ6noPUFZca2KzutJaTk3k2Yomg4mr2sabxbESBCO27b0jaSAQ>
    <xmx:uEUvYZ4W67E2qo190s3VO-Vd_RlZc_xavACltt7xyUlce5qj5XMonw>
    <xmx:uEUvYZgx-VVtflxHWk34mOqdSlSaNmEDANujkak4HIaArR8YQZDzBA>
    <xmx:uEUvYYLeP74fhvUKlRWISIYPyMq2TtxnW5RkfDGG_A4Wn9h0r__kUQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 1 Sep 2021 05:19:52 -0400 (EDT)
From:   Maxime Ripard <maxime@cerno.tech>
To:     devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime@cerno.tech>,
        =?UTF-8?q?Jernej=20=C5=A0krabec?= <jernej.skrabec@gmail.com>
Cc:     linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        "David S. Miller" <davem@davemloft.net>,
        de Goede <hdegoede@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Rob Herring <robh@kernel.org>
Subject: [PATCH v2 32/52] dt-bindings: net: wireless: Convert ESP ESP8089 binding to a schema
Date:   Wed,  1 Sep 2021 11:18:32 +0200
Message-Id: <20210901091852.479202-33-maxime@cerno.tech>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210901091852.479202-1-maxime@cerno.tech>
References: <20210901091852.479202-1-maxime@cerno.tech>
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

