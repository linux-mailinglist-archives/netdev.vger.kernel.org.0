Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB40531B5D
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 12:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbfFAKqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 06:46:36 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:36336 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbfFAKqe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jun 2019 06:46:34 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id x51AkLOd092075;
        Sat, 1 Jun 2019 05:46:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1559385981;
        bh=Z3348jTxSQPyURwc46vrJOUi9hMLdEHin3sWtU/Y7iY=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=c5zXDeuWj1HgCV3eSHncr2UCDRotKVZJPwmkjAbv6KppEe3wmUWZAmARuSzy1ME05
         uJFEtAfikKZN4uvhphZXeVziN6Ic2ffrzbxaaMCJitSIXZhCa8GWzhFotEZIxpJyZl
         xhEEMJ1J+0msgPmVGT2jsSfGrAb8u0e7k9+wSfAI=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x51AkKfb023307
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 1 Jun 2019 05:46:20 -0500
Received: from DLEE106.ent.ti.com (157.170.170.36) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Sat, 1 Jun
 2019 05:46:20 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE106.ent.ti.com
 (157.170.170.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Sat, 1 Jun 2019 05:46:20 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id x51AkJN7077632;
        Sat, 1 Jun 2019 05:46:20 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Rob Herring <robh+dt@kernel.org>
CC:     Sekhar Nori <nsekhar@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Wingman Kwok <w-kwok2@ti.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next 05/10] ARM: dts: keystone-clocks: add input fixed clocks
Date:   Sat, 1 Jun 2019 13:45:29 +0300
Message-ID: <20190601104534.25790-6-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190601104534.25790-1-grygorii.strashko@ti.com>
References: <20190601104534.25790-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add set of fixed, external input clocks definitions for TIMI0, TIMI1,
TSREFCLK clocks. Such clocks can be used as reference clocks for some HW
modules (as cpts, for example) by configuring corresponding clock muxes.
For these clocks real frequencies have to be defined in board files.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 arch/arm/boot/dts/keystone-clocks.dtsi | 27 ++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/arch/arm/boot/dts/keystone-clocks.dtsi b/arch/arm/boot/dts/keystone-clocks.dtsi
index 457515b0736a..0397c3423d2d 100644
--- a/arch/arm/boot/dts/keystone-clocks.dtsi
+++ b/arch/arm/boot/dts/keystone-clocks.dtsi
@@ -408,4 +408,31 @@ clocks {
 		reg-names = "control", "domain";
 		domain-id = <0>;
 	};
+
+	/*
+	 * Below are set of fixed, input clocks definitions,
+	 * for which real frequencies have to be defined in board files.
+	 * Those clocks can be used as reference clocks for some HW modules
+	 * (as cpts, for example) by configuring corresponding clock muxes.
+	 */
+	timi0: timi0 {
+		#clock-cells = <0>;
+		compatible = "fixed-clock";
+		clock-frequency = <0>;
+		clock-output-names = "timi0";
+	};
+
+	timi1: timi1 {
+		#clock-cells = <0>;
+		compatible = "fixed-clock";
+		clock-frequency = <0>;
+		clock-output-names = "timi1";
+	};
+
+	tsrefclk: tsrefclk {
+		#clock-cells = <0>;
+		compatible = "fixed-clock";
+		clock-frequency = <0>;
+		clock-output-names = "tsrefclk";
+	};
 };
-- 
2.17.1

