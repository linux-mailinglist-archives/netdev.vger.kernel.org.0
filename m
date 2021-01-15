Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA8182F868F
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 21:21:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388738AbhAOUVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 15:21:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388500AbhAOUUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 15:20:50 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C92FDC061794;
        Fri, 15 Jan 2021 12:20:09 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id q1so20545031ion.8;
        Fri, 15 Jan 2021 12:20:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=b6LpyRqm8gwHX6DUVwLYo6c/p/ziK+XDz1CqMvS59ZA=;
        b=BrWRZagr4gSZyw5zB2x4/e89FEty0ipuus8FryS1/3ZnV/JNXGOVQvopUuXC8HNnDM
         ZMyZp+7gBHSdeMjs7e70IszbeAK0pDM1pLJxoNmgm5kBRiu+QIGfWNseySwWGSgskKDt
         lqDgRqGUXCcf3mVATuVtlmZGorZuJjp4bEcvficADUjPt/x5IfjLEecSA4gB9eZnlvly
         BJwZRAjnHfA6xH8ID0VyushE9XidHzxpXfayjyOjh1M5QmBTFjGFlVYnJkI4NqtcsiQn
         Dlv+E093N0RA0BGZaUPXUew16G5YZAYHTM08r272DQzURAlNmoTiPa+bNu6zMzQSdigU
         8DQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b6LpyRqm8gwHX6DUVwLYo6c/p/ziK+XDz1CqMvS59ZA=;
        b=D5qZG29jFUSOsvUL+v+Aghshe+voBOfIf5UFb0KMxe+5R3MBA1AtNG38s5tcLWvSeA
         x+WLGTDMZZpI6e6n+86qP75/H5mdvFkYk6JdTgwgyV2HiW/cGO9B2f1bby1hs//WklK8
         8szdaXzKgoSGH1gvHoE1aus94w401ogLM6bK+5wuEA3VPOVqWRjQniicyiXJclUo7EpP
         BDE1TkrNpMnuXl6zg+ysrPE28fVEQ76pFLeEHiR2b8MumVwDmUmxqA0foMEdro9pBBl+
         dhHHH18GBouxvQ6no03lpeiR3yjQA1HKtJqCrJRb/SObkkSDMg7fgxCvUw7NnH/d90jb
         7NHQ==
X-Gm-Message-State: AOAM531iJ6d4eZJ8NNLyyJXZy8UotX9wK2wMXHuHsYHl6nghX1W7xTPR
        bAuu5LOfY4wlmxdTV+hib4qSjsZdO+RBrSsm
X-Google-Smtp-Source: ABdhPJwn/Oamq250AglJYc0yUNqJHhUAnihDYBc6xGXWBZsiVzG88kKheqrsr9khJX/+GZKaHn1oWg==
X-Received: by 2002:a5d:9506:: with SMTP id d6mr9753401iom.37.1610742008385;
        Fri, 15 Jan 2021 12:20:08 -0800 (PST)
Received: from aford-IdeaCentre-A730.lan ([2601:448:8400:9e8:475c:c79e:a431:bccb])
        by smtp.gmail.com with ESMTPSA id e28sm4194900iov.38.2021.01.15.12.20.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 12:20:05 -0800 (PST)
From:   Adam Ford <aford173@gmail.com>
To:     linux-renesas-soc@vger.kernel.org
Cc:     aford@beaconembedded.com, Adam Ford <aford173@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V2 3/4] arm64: dts: renesas: Add fck to etheravb-rcar-gen3 clock-names list
Date:   Fri, 15 Jan 2021 14:19:50 -0600
Message-Id: <20210115201953.443710-3-aford173@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210115201953.443710-1-aford173@gmail.com>
References: <20210115201953.443710-1-aford173@gmail.com>
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

V2:  No change

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

