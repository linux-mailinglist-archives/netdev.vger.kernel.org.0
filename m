Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 420B22F8687
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 21:21:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388533AbhAOUUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 15:20:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388325AbhAOUUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 15:20:45 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67EE1C061793;
        Fri, 15 Jan 2021 12:20:05 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id b19so18058635ioa.9;
        Fri, 15 Jan 2021 12:20:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JPp2MICEAg6U/ik/5DIk7A+2LVzYjg/o/oLNwTffQ30=;
        b=LV79N7zy+K4lisf9lSupt9hMIYTafWKlHc/LuGvxy1/pqtrGuuFINZ+RwAXmT2EeZV
         /Oqnw2xL8GvSO8Tx2pP2hdnIISKrZBagwtqh2Qi/gphP7eUDobFrwFhUBIZ8UbphOihk
         GJtnuEQUOxQ+ARw+jyX0BBk2C7fMK2JauUJ4LZGfVuUyEpJy84YB08xBLp51G+Y4ywma
         ep74eVz5XkxKDcjHC2ngwlZeX96XwP47aEeRb1sz9M656YNT69x69VM1l2nPCdrA0D1i
         CylR8xEL9zXkJV9sz4d6aZ5bEPIlW6txdyHSDhVdMFvuf/sbDA4ApQNDXelPHb9M9CEk
         Lj3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JPp2MICEAg6U/ik/5DIk7A+2LVzYjg/o/oLNwTffQ30=;
        b=T8psi9Xp7xcp2PeuJ7YuDyF7v57quqaWNlkySMdwjq7UK8Ch613lp/t3WBme63/mpp
         nWBbdtPIFKC+I9eSXqppAfiCqKpGQdeaMy7tbbd/QGLlXJ244Rc0aVuPyQ587KVcnRnG
         E9x0zxINJqCz8Jz/wyyr64KtiIClgi3us6K/MbBfBj0rKHCY1eSRZzgahpcwKCUmQVzs
         jywLkNxoZMs3hCMb+g1bc0/ZqAvRsFqz2SJVuGuM14I2cJ3y1tm+CLCXFFJqqwfkB/sL
         dQ780gYNF1+3NeTcPcd92TULBgfp/GtofAHXNTXzR/9jQ9xGUa8X1iKWMbbm/0+EmQf1
         jKWg==
X-Gm-Message-State: AOAM5321q1pFWVlztsdE5KIBigRJVEiPVPFT2GWPbWu2Q91KG6y0r0xh
        tCKvIkPvs/oqPl1dEm6I+bXEYhp1TU3SCltD
X-Google-Smtp-Source: ABdhPJyHKEeDnonZoqGOWu5d2fOj1HwjGWnH6m7YAbVrZXw4JkqMMG6lLJib+RA89EGhi4ah43873g==
X-Received: by 2002:a05:6e02:929:: with SMTP id o9mr11920262ilt.42.1610742003860;
        Fri, 15 Jan 2021 12:20:03 -0800 (PST)
Received: from aford-IdeaCentre-A730.lan ([2601:448:8400:9e8:475c:c79e:a431:bccb])
        by smtp.gmail.com with ESMTPSA id e28sm4194900iov.38.2021.01.15.12.20.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 12:20:03 -0800 (PST)
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
Subject: [PATCH V2 2/4] ARM: dts: renesas: Add fck to etheravb-rcar-gen2 clock-names list
Date:   Fri, 15 Jan 2021 14:19:49 -0600
Message-Id: <20210115201953.443710-2-aford173@gmail.com>
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
 arch/arm/boot/dts/r8a7742.dtsi  | 1 +
 arch/arm/boot/dts/r8a7743.dtsi  | 1 +
 arch/arm/boot/dts/r8a7744.dtsi  | 1 +
 arch/arm/boot/dts/r8a7745.dtsi  | 1 +
 arch/arm/boot/dts/r8a77470.dtsi | 1 +
 arch/arm/boot/dts/r8a7790.dtsi  | 1 +
 arch/arm/boot/dts/r8a7791.dtsi  | 1 +
 arch/arm/boot/dts/r8a7792.dtsi  | 1 +
 arch/arm/boot/dts/r8a7794.dtsi  | 1 +
 9 files changed, 9 insertions(+)

V2:  No change

diff --git a/arch/arm/boot/dts/r8a7742.dtsi b/arch/arm/boot/dts/r8a7742.dtsi
index 6a78c813057b..6b922f664fcd 100644
--- a/arch/arm/boot/dts/r8a7742.dtsi
+++ b/arch/arm/boot/dts/r8a7742.dtsi
@@ -750,6 +750,7 @@ avb: ethernet@e6800000 {
 			reg = <0 0xe6800000 0 0x800>, <0 0xee0e8000 0 0x4000>;
 			interrupts = <GIC_SPI 163 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&cpg CPG_MOD 812>;
+			clock-names = "fck";
 			power-domains = <&sysc R8A7742_PD_ALWAYS_ON>;
 			resets = <&cpg 812>;
 			#address-cells = <1>;
diff --git a/arch/arm/boot/dts/r8a7743.dtsi b/arch/arm/boot/dts/r8a7743.dtsi
index f444e418f408..084bf3e039cf 100644
--- a/arch/arm/boot/dts/r8a7743.dtsi
+++ b/arch/arm/boot/dts/r8a7743.dtsi
@@ -702,6 +702,7 @@ avb: ethernet@e6800000 {
 			reg = <0 0xe6800000 0 0x800>, <0 0xee0e8000 0 0x4000>;
 			interrupts = <GIC_SPI 163 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&cpg CPG_MOD 812>;
+			clock-names = "fck";
 			power-domains = <&sysc R8A7743_PD_ALWAYS_ON>;
 			resets = <&cpg 812>;
 			#address-cells = <1>;
diff --git a/arch/arm/boot/dts/r8a7744.dtsi b/arch/arm/boot/dts/r8a7744.dtsi
index 0442aad4f9db..d01eba99ceb0 100644
--- a/arch/arm/boot/dts/r8a7744.dtsi
+++ b/arch/arm/boot/dts/r8a7744.dtsi
@@ -702,6 +702,7 @@ avb: ethernet@e6800000 {
 			reg = <0 0xe6800000 0 0x800>, <0 0xee0e8000 0 0x4000>;
 			interrupts = <GIC_SPI 163 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&cpg CPG_MOD 812>;
+			clock-names = "fck";
 			power-domains = <&sysc R8A7744_PD_ALWAYS_ON>;
 			resets = <&cpg 812>;
 			#address-cells = <1>;
diff --git a/arch/arm/boot/dts/r8a7745.dtsi b/arch/arm/boot/dts/r8a7745.dtsi
index 0f14ac22921d..d0d45a369047 100644
--- a/arch/arm/boot/dts/r8a7745.dtsi
+++ b/arch/arm/boot/dts/r8a7745.dtsi
@@ -645,6 +645,7 @@ avb: ethernet@e6800000 {
 			reg = <0 0xe6800000 0 0x800>, <0 0xee0e8000 0 0x4000>;
 			interrupts = <GIC_SPI 163 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&cpg CPG_MOD 812>;
+			clock-names = "fck";
 			power-domains = <&sysc R8A7745_PD_ALWAYS_ON>;
 			resets = <&cpg 812>;
 			#address-cells = <1>;
diff --git a/arch/arm/boot/dts/r8a77470.dtsi b/arch/arm/boot/dts/r8a77470.dtsi
index 691b1a131c87..ae90a001d663 100644
--- a/arch/arm/boot/dts/r8a77470.dtsi
+++ b/arch/arm/boot/dts/r8a77470.dtsi
@@ -537,6 +537,7 @@ avb: ethernet@e6800000 {
 			reg = <0 0xe6800000 0 0x800>, <0 0xee0e8000 0 0x4000>;
 			interrupts = <GIC_SPI 163 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&cpg CPG_MOD 812>;
+			clock-names = "fck";
 			power-domains = <&sysc R8A77470_PD_ALWAYS_ON>;
 			resets = <&cpg 812>;
 			#address-cells = <1>;
diff --git a/arch/arm/boot/dts/r8a7790.dtsi b/arch/arm/boot/dts/r8a7790.dtsi
index b0569b4ea5c8..af9cd3324f4c 100644
--- a/arch/arm/boot/dts/r8a7790.dtsi
+++ b/arch/arm/boot/dts/r8a7790.dtsi
@@ -768,6 +768,7 @@ avb: ethernet@e6800000 {
 			reg = <0 0xe6800000 0 0x800>, <0 0xee0e8000 0 0x4000>;
 			interrupts = <GIC_SPI 163 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&cpg CPG_MOD 812>;
+			clock-names = "fck";
 			power-domains = <&sysc R8A7790_PD_ALWAYS_ON>;
 			resets = <&cpg 812>;
 			#address-cells = <1>;
diff --git a/arch/arm/boot/dts/r8a7791.dtsi b/arch/arm/boot/dts/r8a7791.dtsi
index 87f0d6dc3e5a..2354af7fa83f 100644
--- a/arch/arm/boot/dts/r8a7791.dtsi
+++ b/arch/arm/boot/dts/r8a7791.dtsi
@@ -728,6 +728,7 @@ avb: ethernet@e6800000 {
 			reg = <0 0xe6800000 0 0x800>, <0 0xee0e8000 0 0x4000>;
 			interrupts = <GIC_SPI 163 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&cpg CPG_MOD 812>;
+			clock-names = "fck";
 			power-domains = <&sysc R8A7791_PD_ALWAYS_ON>;
 			resets = <&cpg 812>;
 			#address-cells = <1>;
diff --git a/arch/arm/boot/dts/r8a7792.dtsi b/arch/arm/boot/dts/r8a7792.dtsi
index f5b299bfcb23..60c184ab1b49 100644
--- a/arch/arm/boot/dts/r8a7792.dtsi
+++ b/arch/arm/boot/dts/r8a7792.dtsi
@@ -537,6 +537,7 @@ avb: ethernet@e6800000 {
 			reg = <0 0xe6800000 0 0x800>, <0 0xee0e8000 0 0x4000>;
 			interrupts = <GIC_SPI 163 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&cpg CPG_MOD 812>;
+			clock-names = "fck";
 			power-domains = <&sysc R8A7792_PD_ALWAYS_ON>;
 			resets = <&cpg 812>;
 			#address-cells = <1>;
diff --git a/arch/arm/boot/dts/r8a7794.dtsi b/arch/arm/boot/dts/r8a7794.dtsi
index cd5e2904068a..18cc6f6b588d 100644
--- a/arch/arm/boot/dts/r8a7794.dtsi
+++ b/arch/arm/boot/dts/r8a7794.dtsi
@@ -598,6 +598,7 @@ avb: ethernet@e6800000 {
 			reg = <0 0xe6800000 0 0x800>, <0 0xee0e8000 0 0x4000>;
 			interrupts = <GIC_SPI 163 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&cpg CPG_MOD 812>;
+			clock-names = "fck";
 			power-domains = <&sysc R8A7794_PD_ALWAYS_ON>;
 			resets = <&cpg 812>;
 			#address-cells = <1>;
-- 
2.25.1

