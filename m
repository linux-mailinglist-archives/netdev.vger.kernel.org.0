Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60F4C379B0
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 18:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729815AbfFFQcM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 12:32:12 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:50336 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726752AbfFFQcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 12:32:10 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id x56GVgL2108223;
        Thu, 6 Jun 2019 11:31:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1559838703;
        bh=s0DHhLKrDcHh55C/pydFQUdzuLIZ+F0uIWMj4m4t5N0=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=i+hMyuO06wYTkE9cAQcFlkXn3N8RwFlSMbzjlyiZoCdDk0pQJH8xJ+QNKA3thTaMr
         DlKkU/koYE5NcqIsnyXfe6zKG+3gSHAev6+WHIDEiVDK3EDe8vD2SH0xzyhGEQUwZv
         rzYG/xjr7zPPmXClxz/BLYZsEhXts5vQTd3E5gCw=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x56GVg2a007202
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 6 Jun 2019 11:31:42 -0500
Received: from DFLE114.ent.ti.com (10.64.6.35) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Thu, 6 Jun
 2019 11:31:42 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Thu, 6 Jun 2019 11:31:42 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id x56GVf3P053034;
        Thu, 6 Jun 2019 11:31:42 -0500
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
Subject: [PATCH net-next v2 07/10] ARM: dts: k2e-netcp: add cpts refclk_mux node
Date:   Thu, 6 Jun 2019 19:30:44 +0300
Message-ID: <20190606163047.31199-8-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190606163047.31199-1-grygorii.strashko@ti.com>
References: <20190606163047.31199-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

KeyStone 66AK2E 1G Ethernet Switch Subsystems, can control an external
multiplexer that selects one of up to 32 clocks for time sync reference
(RFTCLK) clock. This feature can be configured through CPTS_RFTCLK_SEL
register (offset: x08) in CPTS module and modelled as multiplexer clock.

Hence, add cpts-refclk-mux clock node which allows to mux one of SYSCLK2,
SYSCLK3, TIMI0, TIMI1, TSIPCLKA, TSREFCLK, TSIPCLKB clocks as CPTS
reference clock [1] and group all CPTS properties under "cpts" subnode.

[1] http://www.ti.com/lit/gpn/66ak2e05
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
---
 arch/arm/boot/dts/keystone-k2e-netcp.dtsi | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/keystone-k2e-netcp.dtsi b/arch/arm/boot/dts/keystone-k2e-netcp.dtsi
index 1db17ec744b1..ad15e77874b1 100644
--- a/arch/arm/boot/dts/keystone-k2e-netcp.dtsi
+++ b/arch/arm/boot/dts/keystone-k2e-netcp.dtsi
@@ -135,8 +135,8 @@ netcp: netcp@24000000 {
 	/* NetCP address range */
 	ranges = <0 0x24000000 0x1000000>;
 
-	clocks = <&clkpa>, <&clkcpgmac>, <&chipclk12>;
-	clock-names = "pa_clk", "ethss_clk", "cpts";
+	clocks = <&clkpa>, <&clkcpgmac>;
+	clock-names = "pa_clk", "ethss_clk";
 	dma-coherent;
 
 	ti,navigator-dmas = <&dma_gbe 0>,
@@ -156,6 +156,23 @@ netcp: netcp@24000000 {
 			tx-queue = <896>;
 			tx-channel = "nettx";
 
+			cpts {
+				clocks = <&cpts_refclk_mux>;
+				clock-names = "cpts";
+
+				cpts_refclk_mux: cpts-refclk-mux {
+					#clock-cells = <0>;
+					clocks = <&chipclk12>, <&chipclk13>,
+						 <&timi0>, <&timi1>,
+						 <&tsipclka>, <&tsrefclk>,
+						 <&tsipclkb>;
+					ti,mux-tbl = <0x0>, <0x1>, <0x2>,
+						<0x3>, <0x4>, <0x8>, <0xC>;
+					assigned-clocks = <&cpts_refclk_mux>;
+					assigned-clock-parents = <&chipclk12>;
+				};
+			};
+
 			interfaces {
 				gbe0: interface-0 {
 					slave-port = <0>;
-- 
2.17.1

