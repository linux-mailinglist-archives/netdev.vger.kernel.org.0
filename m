Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC2C7323B95
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 12:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235168AbhBXLw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 06:52:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235098AbhBXLwr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 06:52:47 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8297C06178A;
        Wed, 24 Feb 2021 03:52:06 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id g27so331577iox.2;
        Wed, 24 Feb 2021 03:52:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PZYx3CEvDuMWXOVkaKAK3jWRfzBdNDqn9c53O2oQMwE=;
        b=VI4dDzBSd/+aDsk//OvZL94AiNy3tV11V0Rfg0AUmjG2lopVMw+dF1vJSLZ3TN/qLx
         bWh+kQ4ekM30qfS+ZslOg6t9DsvMauEP0zw9Hq+HtCeilippJr7Y7ILtrfSn1Txr74Cd
         i63SitMYpTz0oEwIG5PxqA6vy8MeK4+34B5ifhysntWBo6aeXVkjLzFzJgjZP3pZj/xA
         HgxNzlUIV+OZgCSklmwOKpRUUhaQ3uV5Nv8F2rglkZYZUtLOv89opEMbkOEfeAq3/PHT
         ArHi/f+4cQpkr7QrRaeG9cyJp4k6wbWq7WE6lb0UnnGfEs+JRbtT8a06AGIG7co62lD9
         LIxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PZYx3CEvDuMWXOVkaKAK3jWRfzBdNDqn9c53O2oQMwE=;
        b=H4JVt7tXlFx/euaimzfLHqHfbM1nVloBpX2239hB/2gT53tvfMWOUV4Vqy9C7V6UM8
         BvX5ykJQd+WIfEAVi4lOWY01uWXeXA/U0hblGVzN7AN/msvAGfgntz/VL0qX1oRCvvwR
         XcME9pqWoKGczv5YCxX6yfhpAhHqWJ8LYyZ3FRTW6StO33Ybrd676teGE+sOZPbreZkC
         k/Yxi7PneBTPtcq19/Gd633iEfXusN/sIkeuDEIMVzEyxwmB4wqmPRVsBav9KksRwBPu
         d3LfLP1oyiCxk55k2aibdLz+IW1zJwtOq6FXrk58eKFBFgXKgggwYG8+doJ7BRijkCH+
         nyug==
X-Gm-Message-State: AOAM531TSrtepHWz2QKkXOZuGO9vyCQYCJBtH3WIsnZJRLrBrPorSWZf
        D9tro1wySIRe6JdkD5VBX2XRlhhJbJsIMA==
X-Google-Smtp-Source: ABdhPJxGJx1NpfODLuLZ//hinfAV2zXVFS/PE8Q1OM0HI70cNLFu2FVpKbFAJsK8eGmtP7yVPzIQLg==
X-Received: by 2002:a5d:9c88:: with SMTP id p8mr15913521iop.23.1614167525910;
        Wed, 24 Feb 2021 03:52:05 -0800 (PST)
Received: from aford-IdeaCentre-A730.lan ([2601:448:8400:9e8:de9c:d296:189b:385a])
        by smtp.gmail.com with ESMTPSA id l16sm1500001ils.11.2021.02.24.03.52.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 03:52:05 -0800 (PST)
From:   Adam Ford <aford173@gmail.com>
To:     netdev@vger.kernel.org
Cc:     aford@beaconembedded.com, Adam Ford <aford173@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V3 3/5] arm64: dts: renesas: Add fck to etheravb-rcar-gen3 clock-names list
Date:   Wed, 24 Feb 2021 05:51:43 -0600
Message-Id: <20210224115146.9131-3-aford173@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210224115146.9131-1-aford173@gmail.com>
References: <20210224115146.9131-1-aford173@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bindings have been updated to support two clocks, but the
original clock now requires the name fck.  Add a clock-names
list in the device tree with fck in it.

Signed-off-by: Adam Ford <aford173@gmail.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
V3:  No Change
V2:  No Change

diff --git a/arch/arm64/boot/dts/renesas/r8a774a1.dtsi b/arch/arm64/boot/dts/renesas/r8a774a1.dtsi
index d64fb8b1b86c..ec4feb7df775 100644
--- a/arch/arm64/boot/dts/renesas/r8a774a1.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a774a1.dtsi
@@ -1127,6 +1127,7 @@ avb: ethernet@e6800000 {
 					  "ch20", "ch21", "ch22", "ch23",
 					  "ch24";
 			clocks = <&cpg CPG_MOD 812>;
+			clock-names = "fck";
 			power-domains = <&sysc R8A774A1_PD_ALWAYS_ON>;
 			resets = <&cpg 812>;
 			phy-mode = "rgmii";
diff --git a/arch/arm64/boot/dts/renesas/r8a774b1.dtsi b/arch/arm64/boot/dts/renesas/r8a774b1.dtsi
index 5b05474dc272..1ff62b2be1f3 100644
--- a/arch/arm64/boot/dts/renesas/r8a774b1.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a774b1.dtsi
@@ -1001,6 +1001,7 @@ avb: ethernet@e6800000 {
 					  "ch20", "ch21", "ch22", "ch23",
 					  "ch24";
 			clocks = <&cpg CPG_MOD 812>;
+			clock-names = "fck";
 			power-domains = <&sysc R8A774B1_PD_ALWAYS_ON>;
 			resets = <&cpg 812>;
 			phy-mode = "rgmii";
diff --git a/arch/arm64/boot/dts/renesas/r8a774c0.dtsi b/arch/arm64/boot/dts/renesas/r8a774c0.dtsi
index 20fa3caa050e..a4d9c6b31574 100644
--- a/arch/arm64/boot/dts/renesas/r8a774c0.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a774c0.dtsi
@@ -957,6 +957,7 @@ avb: ethernet@e6800000 {
 					  "ch20", "ch21", "ch22", "ch23",
 					  "ch24";
 			clocks = <&cpg CPG_MOD 812>;
+			clock-names = "fck";
 			power-domains = <&sysc R8A774C0_PD_ALWAYS_ON>;
 			resets = <&cpg 812>;
 			phy-mode = "rgmii";
diff --git a/arch/arm64/boot/dts/renesas/r8a774e1.dtsi b/arch/arm64/boot/dts/renesas/r8a774e1.dtsi
index 8eb006cbd9af..fec5839163ec 100644
--- a/arch/arm64/boot/dts/renesas/r8a774e1.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a774e1.dtsi
@@ -1230,6 +1230,7 @@ avb: ethernet@e6800000 {
 					  "ch20", "ch21", "ch22", "ch23",
 					  "ch24";
 			clocks = <&cpg CPG_MOD 812>;
+			clock-names = "fck";
 			power-domains = <&sysc R8A774E1_PD_ALWAYS_ON>;
 			resets = <&cpg 812>;
 			phy-mode = "rgmii";
diff --git a/arch/arm64/boot/dts/renesas/r8a77951.dtsi b/arch/arm64/boot/dts/renesas/r8a77951.dtsi
index 5c39152e4570..1e622ab8a044 100644
--- a/arch/arm64/boot/dts/renesas/r8a77951.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a77951.dtsi
@@ -1312,6 +1312,7 @@ avb: ethernet@e6800000 {
 					  "ch20", "ch21", "ch22", "ch23",
 					  "ch24";
 			clocks = <&cpg CPG_MOD 812>;
+			clock-names = "fck";
 			power-domains = <&sysc R8A7795_PD_ALWAYS_ON>;
 			resets = <&cpg 812>;
 			phy-mode = "rgmii";
diff --git a/arch/arm64/boot/dts/renesas/r8a77960.dtsi b/arch/arm64/boot/dts/renesas/r8a77960.dtsi
index 25d947a81b29..a3d1c33cbc1d 100644
--- a/arch/arm64/boot/dts/renesas/r8a77960.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a77960.dtsi
@@ -1188,6 +1188,7 @@ avb: ethernet@e6800000 {
 					  "ch20", "ch21", "ch22", "ch23",
 					  "ch24";
 			clocks = <&cpg CPG_MOD 812>;
+			clock-names = "fck";
 			power-domains = <&sysc R8A7796_PD_ALWAYS_ON>;
 			resets = <&cpg 812>;
 			phy-mode = "rgmii";
diff --git a/arch/arm64/boot/dts/renesas/r8a77961.dtsi b/arch/arm64/boot/dts/renesas/r8a77961.dtsi
index e8c31ebec097..55a3ba3c844f 100644
--- a/arch/arm64/boot/dts/renesas/r8a77961.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a77961.dtsi
@@ -1144,6 +1144,7 @@ avb: ethernet@e6800000 {
 					  "ch20", "ch21", "ch22", "ch23",
 					  "ch24";
 			clocks = <&cpg CPG_MOD 812>;
+			clock-names = "fck";
 			power-domains = <&sysc R8A77961_PD_ALWAYS_ON>;
 			resets = <&cpg 812>;
 			phy-mode = "rgmii";
diff --git a/arch/arm64/boot/dts/renesas/r8a77965.dtsi b/arch/arm64/boot/dts/renesas/r8a77965.dtsi
index 657b20d3533b..dd4c0e621b9c 100644
--- a/arch/arm64/boot/dts/renesas/r8a77965.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a77965.dtsi
@@ -1050,6 +1050,7 @@ avb: ethernet@e6800000 {
 					  "ch20", "ch21", "ch22", "ch23",
 					  "ch24";
 			clocks = <&cpg CPG_MOD 812>;
+			clock-names = "fck";
 			power-domains = <&sysc R8A77965_PD_ALWAYS_ON>;
 			resets = <&cpg 812>;
 			phy-mode = "rgmii";
diff --git a/arch/arm64/boot/dts/renesas/r8a77970.dtsi b/arch/arm64/boot/dts/renesas/r8a77970.dtsi
index 5a5d5649332a..d4b0b9952619 100644
--- a/arch/arm64/boot/dts/renesas/r8a77970.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a77970.dtsi
@@ -612,6 +612,7 @@ avb: ethernet@e6800000 {
 					  "ch20", "ch21", "ch22", "ch23",
 					  "ch24";
 			clocks = <&cpg CPG_MOD 812>;
+			clock-names = "fck";
 			power-domains = <&sysc R8A77970_PD_ALWAYS_ON>;
 			resets = <&cpg 812>;
 			phy-mode = "rgmii";
diff --git a/arch/arm64/boot/dts/renesas/r8a77980.dtsi b/arch/arm64/boot/dts/renesas/r8a77980.dtsi
index ec7ca72399ec..992a577a3b17 100644
--- a/arch/arm64/boot/dts/renesas/r8a77980.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a77980.dtsi
@@ -664,6 +664,7 @@ avb: ethernet@e6800000 {
 					  "ch20", "ch21", "ch22", "ch23",
 					  "ch24";
 			clocks = <&cpg CPG_MOD 812>;
+			clock-names = "fck";
 			power-domains = <&sysc R8A77980_PD_ALWAYS_ON>;
 			resets = <&cpg 812>;
 			phy-mode = "rgmii";
diff --git a/arch/arm64/boot/dts/renesas/r8a77990.dtsi b/arch/arm64/boot/dts/renesas/r8a77990.dtsi
index 5010f23fafcc..cc56267e0850 100644
--- a/arch/arm64/boot/dts/renesas/r8a77990.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a77990.dtsi
@@ -1000,6 +1000,7 @@ avb: ethernet@e6800000 {
 					  "ch20", "ch21", "ch22", "ch23",
 					  "ch24";
 			clocks = <&cpg CPG_MOD 812>;
+			clock-names = "fck";
 			power-domains = <&sysc R8A77990_PD_ALWAYS_ON>;
 			resets = <&cpg 812>;
 			phy-mode = "rgmii";
diff --git a/arch/arm64/boot/dts/renesas/r8a77995.dtsi b/arch/arm64/boot/dts/renesas/r8a77995.dtsi
index 2319271c881b..84dba3719381 100644
--- a/arch/arm64/boot/dts/renesas/r8a77995.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a77995.dtsi
@@ -760,6 +760,7 @@ avb: ethernet@e6800000 {
 					  "ch20", "ch21", "ch22", "ch23",
 					  "ch24";
 			clocks = <&cpg CPG_MOD 812>;
+			clock-names = "fck";
 			power-domains = <&sysc R8A77995_PD_ALWAYS_ON>;
 			resets = <&cpg 812>;
 			phy-mode = "rgmii";
-- 
2.25.1

