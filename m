Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4050D3FD66A
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 11:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243507AbhIAJUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 05:20:10 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:37111 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243506AbhIAJUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 05:20:06 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 998DF580AF6;
        Wed,  1 Sep 2021 05:19:09 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 01 Sep 2021 05:19:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm3; bh=P6Nu6aTsQPnD4
        VDKF+yrkv+lZ72RVulC249s1d3SA1A=; b=fyiiFo9+hVDa0nlR+UU1Q3DTE7o7i
        IdR3OXR8nGCe5ZivF8enSkzSHWkoUO7vVCcvRroK1m1WrJTlb8vXD1m+bjm/FRBY
        RZHfUME7wCL4RezW5KXfv48BMTO4ZEYU09EaNLFtSuQbA10Ik28llF7FWrT4OM8o
        09gHoJMNm0BeK0p7Rt1gEQw0FUEj5ZLbU8hjjJr9j63wrY3/oXDRvOEOepNXWz5s
        zaivaq2iGAu8tGhL3mxWn6eKElwQ3paytmzI1hZICdVgOAko1eH8hk9jY+nRjEwh
        N2TSl4v4jaRlvFMRVVZLPK1yK2r5Wd9x94Bt8pLFwvs/bpIqmfALh4oww==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=P6Nu6aTsQPnD4VDKF+yrkv+lZ72RVulC249s1d3SA1A=; b=ZXAfJMQ0
        5Muo/tu+Fn9xKwqE3QGA6DsKAVG+iNx5E+XIZOwchCSnRe2DK7zkqVislyRGENVH
        RRz6Jj1f28wI3eWr7k1yeWZDN3Mo/byZmz0/kPaxV0OxNYrzRSO2SiVAyYEK/+F5
        guuNmCjEtAYH2CrDnQFhJMMl2Y0K9Bb6dpKEIt18HWQD0oS4PMU+XM0y9n/RPdTB
        nG1CmZitU2ETdQ3ly+WXN4MGItX2D3GMYjteTRVgY3uiGimTmdg73rc0a1s65qqh
        ceI6MF9S1yyIYnhJKAGOOH23BGAl7XJjjVGcIGdme8AHqaRoTztPXc0WZ9tLnVLA
        njS96idSgzqwWA==
X-ME-Sender: <xms:jUUvYQiHPWqp8qMSedt5am4PftRxo86uHTNtwU9IbTDrPaz8xLeLdA>
    <xme:jUUvYZDK2TY70lZ-ojsqhnZwN5IzDZhQiHC6OkFYGaYo7bRfftH9xq87jJ27_yqRj
    I2yJNAvUst_RRF9958>
X-ME-Received: <xmr:jUUvYYH32Jq6XMfShiRiwmzkioFIVXBQR1wEBfD5T7oXs1jAxkQUF5ZBLNoYVhNq6Lo0LWzn78BPWc3ROaR63D-LnDKYSnl6LUQE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddvfedgudegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeforgigihhm
    vgcutfhiphgrrhguuceomhgrgihimhgvsegtvghrnhhordhtvggthheqnecuggftrfgrth
    htvghrnhepvdekleevfeffkeejhfffueelteelfeduieefheduudfggffhhfffheevveeh
    hedvnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepmh
    grgihimhgvsegtvghrnhhordhtvggthh
X-ME-Proxy: <xmx:jUUvYRS0jiqPBXQf86awspDY1_WzbLlOCX-gnJMtjneFX09ASzTD4w>
    <xmx:jUUvYdxoQOvhqvI_teeJFlDSk8q86Ww8ujIfek2c-TvXU_DjWcbDmg>
    <xmx:jUUvYf7pWPyfaweD54KpYJv7VVTeVa0992uBNjBq7gQ3JanG__HOKQ>
    <xmx:jUUvYT54FUq85Ab2mVlzO2Hf35nSzUeHJq6wjoUrFSjKG19pYQPiQg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 1 Sep 2021 05:19:08 -0400 (EDT)
From:   Maxime Ripard <maxime@cerno.tech>
To:     devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime@cerno.tech>,
        =?UTF-8?q?Jernej=20=C5=A0krabec?= <jernej.skrabec@gmail.com>
Cc:     linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        netdev@vger.kernel.org, Rob Herring <robh@kernel.org>
Subject: [PATCH v2 07/52] dt-bindings: bluetooth: broadcom: Fix clocks check
Date:   Wed,  1 Sep 2021 11:18:07 +0200
Message-Id: <20210901091852.479202-8-maxime@cerno.tech>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210901091852.479202-1-maxime@cerno.tech>
References: <20210901091852.479202-1-maxime@cerno.tech>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The original binding was mentioning that valid values for the clocks and
clock-names property were one or two clocks from extclk, txco and lpo,
with extclk being deprecated in favor of txco.

However, the current binding lists a valid array as extclk, txco and
lpo, with either one or two items.

While this looks similar, it actually enforces that all the device trees
use either ["extclk"], or ["extclk", "txco"]. That doesn't make much
sense, since the two clocks are said to be equivalent, with one
superseeding the other.

lpo is also not a valid clock anymore, and would be as the third clock
of the list, while we could have only this clock in the previous binding
(and in DTs).

Let's rework the clock clause to allow to have either:

 - extclk, and mark it a deprecated
 - txco alone
 - lpo alone
 - txco, lpo

While ["extclk", "lpo"] wouldn't be valid, it wasn't found in any device
tree so it's not an issue in practice.

Similarly, ["lpo", "txco"] is still considered invalid, but it's
generally considered as a best practice to fix the order of clocks.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: netdev@vger.kernel.org
Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
---
 .../bindings/net/broadcom-bluetooth.yaml        | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml b/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml
index fbdc2083bec4..5aac094fd217 100644
--- a/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml
+++ b/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml
@@ -50,16 +50,29 @@ properties:
       by interrupts and "host-wakeup" interrupt-names
 
   clocks:
+    minItems: 1
     maxItems: 2
     description: 1 or 2 clocks as defined in clock-names below,
       in that order
 
   clock-names:
     description: Names of the 1 to 2 supplied clocks
-    items:
+    oneOf:
+      - const: extclk
+        deprecated: true
+        description: Deprecated in favor of txco
+
       - const: txco
+        description: >
+          external reference clock (not a standalone crystal)
+
       - const: lpo
-      - const: extclk
+        description: >
+          external low power 32.768 kHz clock
+
+      - items:
+          - const: txco
+          - const: lpo
 
   vbat-supply:
     description: phandle to regulator supply for VBAT
-- 
2.31.1

