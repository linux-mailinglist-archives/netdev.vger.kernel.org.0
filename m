Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D02E22E6C43
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 00:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730160AbgL1Wzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 17:55:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729526AbgL1VdB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 16:33:01 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EA76C061798;
        Mon, 28 Dec 2020 13:32:21 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id d9so10540989iob.6;
        Mon, 28 Dec 2020 13:32:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yQsgNyGUTm64m9DqBT5jJ+3g5SgjdTF9MLP6v+471uQ=;
        b=TzJmxAcmKfKrzu7W7F9P7Q+W6FrWbjg/NN78X7mhL02ARGPP+2XWr3ghcoK4wu4A4t
         NEzvyNATi/BBCJdiYuS9EkarmxFQNaRZzu8byiLSk+NIKVc3zixPh+brHwNBgycjx/Ge
         PqD+Fe/CkpGQT2lm9RNH99gkNYY3aF4q0yNpeQ3fKcTJudlOiSDdo9AazujcuAqaE4F+
         iWUadihiOv4dyKsASs16l4886iiSLuNiqlXm03ZsfbwgLKPEnmvp3OZbwAnf+5U6g4Ir
         Qa8y1oF5N1ZKKL2B3huzXWlG9FYA54/RnQE2WpEulLK6QRGzYdMx0MuFTwuuNwQtXY2g
         nk+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yQsgNyGUTm64m9DqBT5jJ+3g5SgjdTF9MLP6v+471uQ=;
        b=qFbUICEBkQQ3Teau9l7rZIzdyUA1iSITPIHlE9X5WZvCYxh+5zd6i/GeL+gq5G7mxS
         q2BVkm45Jm7LFeibgXP0tXg88KRdDBHfb6QBXEOIxFqFC6PMEn8hYv2w1Mh+WivXjGpN
         ZZ6XAVSlN83GEGfxKSYOaEpq3es8ZkTtjoR/sT2sO3Pxh/ZVEGJmg9lY3XY6XmQJLbPx
         13bPmEHOZSCci8hyDhDDW2cBkvjdBlMyIw8Sx0IotkQNGOVWS5FXio6Zouy3X/In7C31
         E8HWU2Ey3MA7vvQF2vgHouWvP4odo/XB87oTnwVKB/jpGENfa48zP4/oHwqskKk53/w+
         unWA==
X-Gm-Message-State: AOAM5301ndwhBmuLRb00HdhB5tQdqoREL5cplS4BYvmd9V/vsrTTpdv4
        0nLmU9lLEfErnLuiKEWyE4lCXN2rBJOqbQ==
X-Google-Smtp-Source: ABdhPJx5aknZYGg+8QNscwf/G+L7PjDGf8mMJZl1ktkIul3qxNejCprbGKh54tHj/G9/Vv2cXGT7Zg==
X-Received: by 2002:a6b:8e92:: with SMTP id q140mr38263962iod.182.1609191140408;
        Mon, 28 Dec 2020 13:32:20 -0800 (PST)
Received: from aford-IdeaCentre-A730.lan ([2601:448:8400:9e8:f45d:df49:9a4c:4914])
        by smtp.gmail.com with ESMTPSA id r10sm27671275ilo.34.2020.12.28.13.32.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Dec 2020 13:32:19 -0800 (PST)
From:   Adam Ford <aford173@gmail.com>
To:     linux-renesas-soc@vger.kernel.org
Cc:     aford@beaconembedded.com, Adam Ford <aford173@gmail.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] arm64: dts: renesas: Add fck to etheravb-rcar-gen3 clock-names list
Date:   Mon, 28 Dec 2020 15:31:19 -0600
Message-Id: <20201228213121.2331449-3-aford173@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201228213121.2331449-1-aford173@gmail.com>
References: <20201228213121.2331449-1-aford173@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bindings have been updated to support two clocks, but the
original clock now requires the name fck.  Add a clock-names
list in the device tree with fck in it.

Signed-off-by: Adam Ford <aford173@gmail.com>
---
 arch/arm64/boot/dts/renesas/r8a774a1.dtsi | 1 +
 arch/arm64/boot/dts/renesas/r8a774b1.dtsi | 1 +
 arch/arm64/boot/dts/renesas/r8a774c0.dtsi | 1 +
 arch/arm64/boot/dts/renesas/r8a774e1.dtsi | 1 +
 arch/arm64/boot/dts/renesas/r8a77951.dtsi | 1 +
 arch/arm64/boot/dts/renesas/r8a77960.dtsi | 1 +
 arch/arm64/boot/dts/renesas/r8a77961.dtsi | 1 +
 arch/arm64/boot/dts/renesas/r8a77965.dtsi | 1 +
 arch/arm64/boot/dts/renesas/r8a77970.dtsi | 1 +
 arch/arm64/boot/dts/renesas/r8a77980.dtsi | 1 +
 arch/arm64/boot/dts/renesas/r8a77990.dtsi | 1 +
 arch/arm64/boot/dts/renesas/r8a77995.dtsi | 1 +
 12 files changed, 12 insertions(+)

diff --git a/arch/arm64/boot/dts/renesas/r8a774a1.dtsi b/arch/arm64/boot/dts/renesas/r8a774a1.dtsi
index d37ec42a1caa..6804de678453 100644
--- a/arch/arm64/boot/dts/renesas/r8a774a1.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a774a1.dtsi
@@ -1112,6 +1112,7 @@ avb: ethernet@e6800000 {
 					  "ch20", "ch21", "ch22", "ch23",
 					  "ch24";
 			clocks = <&cpg CPG_MOD 812>;
+			clock-names = "fck";
 			power-domains = <&sysc R8A774A1_PD_ALWAYS_ON>;
 			resets = <&cpg 812>;
 			phy-mode = "rgmii";
diff --git a/arch/arm64/boot/dts/renesas/r8a774b1.dtsi b/arch/arm64/boot/dts/renesas/r8a774b1.dtsi
index 83523916d360..179817de1bef 100644
--- a/arch/arm64/boot/dts/renesas/r8a774b1.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a774b1.dtsi
@@ -986,6 +986,7 @@ avb: ethernet@e6800000 {
 					  "ch20", "ch21", "ch22", "ch23",
 					  "ch24";
 			clocks = <&cpg CPG_MOD 812>;
+			clock-names = "fck";
 			power-domains = <&sysc R8A774B1_PD_ALWAYS_ON>;
 			resets = <&cpg 812>;
 			phy-mode = "rgmii";
diff --git a/arch/arm64/boot/dts/renesas/r8a774c0.dtsi b/arch/arm64/boot/dts/renesas/r8a774c0.dtsi
index e0e54342cd4c..e43e8b0a167b 100644
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
index 1333b02d623a..c6b47ca9ed45 100644
--- a/arch/arm64/boot/dts/renesas/r8a774e1.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a774e1.dtsi
@@ -1215,6 +1215,7 @@ avb: ethernet@e6800000 {
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

