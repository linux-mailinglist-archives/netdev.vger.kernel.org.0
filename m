Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3F913D1082
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 16:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239038AbhGUNYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 09:24:08 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:37391 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238996AbhGUNYH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 09:24:07 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id A6BCE580482;
        Wed, 21 Jul 2021 10:04:43 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 21 Jul 2021 10:04:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm3; bh=WEtwLnx+QVbmS
        8n18vDVOz92pmKoYRzOnL/9rJ8bn9I=; b=BlNfFNdGVLkv6FTAuHgxsMSV3Puxq
        fInba0N+dkM8+nVm4InroKoKW/sm4O+nV4lsVyHYwOcNeCTh2zaIHMVOdigD/CIa
        pTscfzsPE0MogAbMvrvOrvJxg1W+XJlRif+NAqtvxAVc+0k5ncyWXEusnx/S7kVd
        XcA+Pvru5TxhVBP7N9+4tMfEqRR7EbNHl6qSL8rv13zC8cjEAUJLsXA1n3RfBbBp
        0wT8FYfF7rE7l4voioNcw6qDzYXWhaeR+sqiXo73lpIruVWstaBTKUrNcTJjzkvx
        bKLZZhnBJdNxXvdyDlg6q+4kb1UKIvOoo0trXn3SKTOiZV3HSSjQNAUfQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=WEtwLnx+QVbmS8n18vDVOz92pmKoYRzOnL/9rJ8bn9I=; b=AD72dh2C
        Uepx7MXWJRuIciJ0Ex+8R59oLqkN/B6oLMexutGb3kAD1KEWuy9EG9IcANiqLx5D
        S8LE5MygcHI3XyDN889rDgrFuV0uPTgCoH78KfDGspmEtVBcaRlSzQFHtrRUSt9j
        zemVhXDGZxD/jTa7sOHoEhSR+UQOgdgSMKyvvRmz8Gx6H8ZTB3eEBiTPxRHL7WRT
        p3Ya2UNji+ded6t+Ja96hiWNC/DbQYDsCL6wNPuGludtDWzisiEHMdhv4V9wr15/
        F3b+7MGShenaKObgtRYX4WNu2fsME38FL6pEdiTjcCifZC3MTQYxUD7XaJcLmtWS
        roTrrbYCYqIE7A==
X-ME-Sender: <xms:eyn4YLNCqHH8_cCwJLHRndiHSvfWvp0qi0boiet2ywyalKacK2bUJw>
    <xme:eyn4YF9Ui49YPQANYaTyfQ4cM7hiWPIpARHma1LXkJbv10_DXydkMU-cW3zuQTijv
    gYPvyR40aCXoNroJ_c>
X-ME-Received: <xmr:eyn4YKSeFG2oGYEyA1XGstcFA5zbvglcZ2fTNLINniu2Zi0wqrt3aKjuPB62iD-gq_bFC3G0i9rSlhL__ucGWMVCOz-iWkVRQDeI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrfeeggdeiiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepofgrgihimhgv
    ucftihhprghrugcuoehmrgigihhmvgestggvrhhnohdrthgvtghhqeenucggtffrrghtth
    gvrhhnpedvkeelveefffekjefhffeuleetleefudeifeehuddugffghffhffehveevheeh
    vdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehmrg
    igihhmvgestggvrhhnohdrthgvtghh
X-ME-Proxy: <xmx:eyn4YPtPYrSDmlDXwr3YWFb6u4vW_tj1JmJsCKGWnmMo4xEGCx5uUQ>
    <xmx:eyn4YDdUX8PrTMHsBMUVLsCm0Bh80rj_Z4ZHF6_N6sUC2FIU0ZdRtw>
    <xmx:eyn4YL3h2qqLgXFIFHFBVRtCa5m-OmjHEIt7qbBi3TrW7qiOGmCmDQ>
    <xmx:eyn4YEViL7NbPQ4XKkl3bQpCNnqBLjVOSNK7e-xzLx2rOw7XqCBbXw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 21 Jul 2021 10:04:43 -0400 (EDT)
From:   Maxime Ripard <maxime@cerno.tech>
To:     Chen-Yu Tsai <wens@csie.org>, Maxime Ripard <maxime@cerno.tech>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Cc:     linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        netdev@vger.kernel.org
Subject: [PATCH 07/54] dt-bindings: bluetooth: broadcom: Fix clocks check
Date:   Wed, 21 Jul 2021 16:03:37 +0200
Message-Id: <20210721140424.725744-8-maxime@cerno.tech>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210721140424.725744-1-maxime@cerno.tech>
References: <20210721140424.725744-1-maxime@cerno.tech>
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

