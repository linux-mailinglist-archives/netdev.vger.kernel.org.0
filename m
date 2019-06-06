Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6AD379AA
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 18:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729799AbfFFQcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 12:32:01 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:54270 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726752AbfFFQcB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 12:32:01 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id x56GVob6064717;
        Thu, 6 Jun 2019 11:31:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1559838710;
        bh=nFl3XytlIowFjWq3TzRRIjdabQqMTMLIHAwovguMLJo=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=UWYCBt5KzQxhGEQ8LGXI4SyKKb4vKE5nI+jZuS/N0aDsgZnj6lIDQyBpcb3luUF+q
         uvJClYey0tqsjjOtVnIMn0+LMCB8pJ1392tOSCed70QkOie9EMGwcxlv8WmfC0OnnA
         eMHQJGbheNLyWBmenKIewrF2ld5+mdRbMjAvYL8s=
Received: from DFLE110.ent.ti.com (dfle110.ent.ti.com [10.64.6.31])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x56GVnN8007841
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 6 Jun 2019 11:31:49 -0500
Received: from DFLE115.ent.ti.com (10.64.6.36) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Thu, 6 Jun
 2019 11:31:49 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Thu, 6 Jun 2019 11:31:49 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id x56GVmKv056079;
        Thu, 6 Jun 2019 11:31:49 -0500
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
Subject: [PATCH net-next v2 08/10] ARM: dts: k2hk-netcp: add cpts refclk_mux node
Date:   Thu, 6 Jun 2019 19:30:45 +0300
Message-ID: <20190606163047.31199-9-grygorii.strashko@ti.com>
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

KeyStone 66AK2H/K 1G Ethernet Switch Subsystems, can control an external
multiplexer that selects one of up to 32 clocks for time sync reference
(RFTCLK) clock. This feature can be configured through CPTS_RFTCLK_SEL
register (offset: x08) in CPTS module and modelled as multiplexer clock.

Hence, add cpts-refclk-mux clock node which allows to mux one of SYSCLK2,
SYSCLK3, TIMI0, TIMI1, TSREFCLK clocks as CPTS reference clock [1] and
group all CPTS properties under "cpts" subnode.

[1] http://www.ti.com/lit/gpn/66ak2h14
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
---
 arch/arm/boot/dts/keystone-k2hk-netcp.dtsi | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/keystone-k2hk-netcp.dtsi b/arch/arm/boot/dts/keystone-k2hk-netcp.dtsi
index e203145acbea..d5a6c1f5633c 100644
--- a/arch/arm/boot/dts/keystone-k2hk-netcp.dtsi
+++ b/arch/arm/boot/dts/keystone-k2hk-netcp.dtsi
@@ -152,8 +152,8 @@ netcp: netcp@2000000 {
 	/* NetCP address range */
 	ranges  = <0 0x2000000 0x100000>;
 
-	clocks = <&clkpa>, <&clkcpgmac>, <&chipclk12>;
-	clock-names = "pa_clk", "ethss_clk", "cpts";
+	clocks = <&clkpa>, <&clkcpgmac>;
+	clock-names = "pa_clk", "ethss_clk";
 	dma-coherent;
 
 	ti,navigator-dmas = <&dma_gbe 22>,
@@ -175,6 +175,22 @@ netcp: netcp@2000000 {
 			tx-queue = <648>;
 			tx-channel = "nettx";
 
+			cpts {
+				clocks = <&cpts_refclk_mux>;
+				clock-names = "cpts";
+
+				cpts_refclk_mux: cpts-refclk-mux {
+					#clock-cells = <0>;
+					clocks = <&chipclk12>, <&chipclk13>,
+						 <&timi0>, <&timi1>,
+						 <&tsrefclk>;
+					ti,mux-tbl = <0x0>, <0x1>, <0x2>,
+						<0x3>, <0x8>;
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

