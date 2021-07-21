Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14AB83D10A7
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 16:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239107AbhGUNYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 09:24:49 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:40083 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238984AbhGUNYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 09:24:48 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 6171A580490;
        Wed, 21 Jul 2021 10:05:24 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 21 Jul 2021 10:05:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm3; bh=BbpD5un6hz/Cp
        pNPwZ3yWte9SCm7D64rp4YLYcyvMok=; b=QrsofyIqW14lIPCrOhOku+sLO5QDP
        lm2aYVxZjgY2aFb/0azh1VJdwJJspzSN1bCv2XRiGhyHg5aRWWT+5QTgrr8GnqjN
        TlHeAuZzNSrgHQ7I1t39mcafrdesnuCvSELmsLYzR8hMggIG7iLZd3rUXdBya4Mj
        6EQGAMNo1WuS6j9tRlayHknlLg0MRcw0xdiKPAaELyXTxNi4/7iuebgXkyYnMWeh
        1mrszPPQBNqGciVRgHBd9awGZPUDjt3pb12lfn/v5D87zTzzycvKvP3P8qMY0Ru5
        2RcHv1La4e+Mz7dUsulp4TSP1z5lQWfh9uEEj7kpCODAmUf0KjVhx5Ibg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=BbpD5un6hz/CppNPwZ3yWte9SCm7D64rp4YLYcyvMok=; b=Pcfb2cwu
        LL6qv8TdIXG56kO2StSfGS62a59irjInRNlRMP6vatPXLMBCLFsHZBNLngqga9bh
        kzgk7rWScdSG3IVmiy+Va4vpmaLpcRaMLvh6/D58pdzDCF2ObXfruQsE1RJP1Dxc
        omqZqm7+sq2zYBA+fV34TghXVVw3/L/bo7SZxMet2xQTHUUssgVDbir/jjsIxSZi
        JjX1K5xpAGGAQuoE44dKASmon4wPmxYv3nal6eRy4cYlHBvuWHp9XvnTB+Y+Jc3u
        vloA25Vu0UwlEXN3zfoNN7GYo4D+9XpL9QxknixBfvlCOEPQSQ4cWVpr/ls8anDL
        1I9i2T1KOKiH3g==
X-ME-Sender: <xms:pCn4YIXGOFlkpMCQXOODe1zPAFO-8YOziyBuxEu8LnkfWECQZ9yGGA>
    <xme:pCn4YMkgGqByfA7QD3Sx2U176QsUFjCehkLvkxsfP2_vPBE8-KqgcNV-IKBNZmnsH
    8k1iN1RYRSFwlgMhbc>
X-ME-Received: <xmr:pCn4YMbjQCPL-lLPxKEA4IBLcdmZbu8d1lGfToMQ0PJyGyLUYpt3TK8-Ea9XKFcMnYvY66i2sv5Oqc7rtJgcrvID2UG6MMZV1ADi>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrfeeggdeijecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenog
    evohgrshhtrghlqdfhgeduvddqtddvucdludehtddmnecujfgurhephffvufffkffojghf
    ggfgsedtkeertdertddtnecuhfhrohhmpeforgigihhmvgcutfhiphgrrhguuceomhgrgi
    himhgvsegtvghrnhhordhtvggthheqnecuggftrfgrthhtvghrnhepveejieejtdevgfff
    gfejuefggfeutdelteekgeetueeftddutddtgfffhffgueffnecuffhomhgrihhnpeguvg
    hvihgtvghtrhgvvgdrohhrghenucevlhhushhtvghrufhiiigvpeegnecurfgrrhgrmhep
    mhgrihhlfhhrohhmpehmrgigihhmvgestggvrhhnohdrthgvtghh
X-ME-Proxy: <xmx:pCn4YHVLsEI934yTM7JQ1cWbCTQQW6Orqqc1BPF21Wh8PlIvCye_yA>
    <xmx:pCn4YCkD-wpEQZAZyzbL9mxHUUthi51iIMuW84Sq2JnvBq5FCsWVZw>
    <xmx:pCn4YMfKaSpU-g6XM8HqwESoxiRj7lMZ9sKuIjRDrIeeQ3QSh9PS0g>
    <xmx:pCn4YN_EvEVtksfjk6OnWSuCGFGeldClltfa3D5ewTcQ1pqe0OttNg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 21 Jul 2021 10:05:23 -0400 (EDT)
From:   Maxime Ripard <maxime@cerno.tech>
To:     Chen-Yu Tsai <wens@csie.org>, Maxime Ripard <maxime@cerno.tech>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Cc:     linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        "David S. Miller" <davem@davemloft.net>,
        de Goede <hdegoede@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 27/54] dt-bindings: net: wireless: Convert ESP ESP8089 binding to a schema
Date:   Wed, 21 Jul 2021 16:03:57 +0200
Message-Id: <20210721140424.725744-28-maxime@cerno.tech>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210721140424.725744-1-maxime@cerno.tech>
References: <20210721140424.725744-1-maxime@cerno.tech>
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

