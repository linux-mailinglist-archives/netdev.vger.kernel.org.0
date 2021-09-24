Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6480416CCC
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 09:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244336AbhIXH3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 03:29:33 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:48271 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244191AbhIXH3b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 03:29:31 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id 7DF7E580F3A;
        Fri, 24 Sep 2021 03:27:58 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 24 Sep 2021 03:27:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm3; bh=8ZUo02dZnGgFgfTeHndvB1x9MZ
        FJLT3D0GdIhBkBwqA=; b=Y7HfydDhDQlpA2UMLzUWZfR9q/1FwmMmDq7lXQwMc8
        Vgush16WBed+1oEkjplnln/mJdYgRMx3iOOM8vt/MQeKRZrCVBtFJox+pBbm8iBP
        0A7qgR8a5Wm8W3TwOD9z9/lVOYrqexvHXL81aU+c8ssytbgOa+kh1/wi2eG6Toa3
        5iGsNkhUZ37tYo8k10GghgLE4yQPA+06d/1IrDOdTi0e/c+s6U3A6FnQOVU0Pv1r
        PfodwK0OHsgyb+rrQNxK83j/rcUiztW+vIWAXZRFuw6V2SXWzBaF54ftEZ0uwR/Y
        so3L6XLkuqoHg5F1VcTvD3wZX6+IuFKz6AaETl7+5n0Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=8ZUo02dZnGgFgfTeH
        ndvB1x9MZFJLT3D0GdIhBkBwqA=; b=gPDpXF0YPJrqzAyjmx9B2GRxgd0RDhHoH
        7JSGftdgB8x7MHaLCjQNwD95rh1IQplQO6cuwNDiqGMZ3QKl+GLKs2b5ciRcqfKD
        p1Lg6ggkTsMySaq11gnGPxPS12VJjZustHPl2Rl8AQCYZsyEerJGH3u+bzUVRDZr
        IawP40+7oLEHjBQdAj4/0NAJKath8rxPrI9Ne9d+DZZVNi9q+sJMgn4GzxA87QVI
        /FvHfHZ2+/n96G9vkJa2xdJVUG2/C9sAbih8PSjY/Je5PHB5HfuycwLT5UbxPERZ
        elC+SxzvSLER2t/FeabxIEDGbIakNtTyumiditzM3sHfeVINcD0NA==
X-ME-Sender: <xms:_n1NYS25piSu6aQNUX9-ZKTAbTcKURCJwn1iDP7Uqz7r93SpYncOUA>
    <xme:_n1NYVFizWhPfgGqVbvSoraCQh9BQHoXhVrz1p-oBOgslKKmtSNMy85ARD_NB_8jC
    h4We4T2U4hZXPy_kXE>
X-ME-Received: <xmr:_n1NYa760_0Oi_-rzUZnCT8-Ng8xEDExXlG72rDPSa4vc2j03KP2HwUjv5PvXdInXwBgEx1ReOHUY0vPS40uWOVtzkCWfHsKKsxM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudejtddguddujecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvffufffkofgggfestdekredtredttdenucfhrhhomhepofgrgihimhgv
    ucftihhprghrugcuoehmrgigihhmvgestggvrhhnohdrthgvtghhqeenucggtffrrghtth
    gvrhhnpeejffehuddvvddvlefhgeelleffgfeijedvhefgieejtdeiueetjeetfeeukeej
    geenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehmrg
    igihhmvgestggvrhhnohdrthgvtghh
X-ME-Proxy: <xmx:_n1NYT18xcehf366GpSU2wuBKq3smR-RLnv9kSxbW3rVD1rcyKrosg>
    <xmx:_n1NYVF4NCfwYnusLNPJIpgCK5kEgB3x4qvVDBZ2k5OiAVRpasszew>
    <xmx:_n1NYc-cAn-KD5k-6fhHlk4PgoCrByf_AOCMR3WCQYvqKPn55S6DxQ>
    <xmx:_n1NYU-BRTHo75mtAjxfF_y_CC9s7AsbbtlO_qpA6ehMaKsTtWibFQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 24 Sep 2021 03:27:58 -0400 (EDT)
From:   Maxime Ripard <maxime@cerno.tech>
To:     Chen-Yu Tsai <wens@csie.org>, Maxime Ripard <maxime@cerno.tech>,
        =?UTF-8?q?Jernej=20=C5=A0krabec?= <jernej.skrabec@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Cc:     linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-sunxi@lists.linux.dev,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <robh@kernel.org>
Subject: [RESEND v2 1/4] dt-bindings: bluetooth: broadcom: Fix clocks check
Date:   Fri, 24 Sep 2021 09:27:53 +0200
Message-Id: <20210924072756.869731-1-maxime@cerno.tech>
X-Mailer: git-send-email 2.31.1
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
Cc: netdev@vger.kernel.org
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
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

