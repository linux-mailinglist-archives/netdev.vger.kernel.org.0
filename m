Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5A82665ACA
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 12:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236364AbjAKLtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 06:49:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231573AbjAKLsX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 06:48:23 -0500
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 225A5EE07;
        Wed, 11 Jan 2023 03:45:14 -0800 (PST)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 30BBiueR084032;
        Wed, 11 Jan 2023 05:44:56 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1673437496;
        bh=6rrNV/bmN/qHkEqrG10OnZlsWexAy6lEPtK7YwqRgVY=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=POL6OX4URm8tdYs8Z4rKLmfyAq8R6tyevo3hlQbZTgB0Ad2VLkZ6UAXy2WRWJyc7A
         N7QXTYL4rTdseg0PGkrpYo/R46QnIq6zQaHvG47JidRxbKSEGUQewy0T4AmABu/9ER
         1A5CT9Z7Ax/q9zBCiuQQfbfYT6ER5R2PjKGothDY=
Received: from DLEE110.ent.ti.com (dlee110.ent.ti.com [157.170.170.21])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 30BBiuV8066017
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 11 Jan 2023 05:44:56 -0600
Received: from DLEE108.ent.ti.com (157.170.170.38) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Wed, 11
 Jan 2023 05:44:55 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Wed, 11 Jan 2023 05:44:55 -0600
Received: from uda0492258.dhcp.ti.com (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 30BBiUkL093892;
        Wed, 11 Jan 2023 05:44:51 -0600
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski@linaro.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <nm@ti.com>,
        <kristo@kernel.org>, <vigneshr@ti.com>, <rogerq@kernel.org>,
        <nsekhar@ti.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: [PATCH net-next 4/5] arm64: dts: ti: k3-am62-main: Add timesync router node
Date:   Wed, 11 Jan 2023 17:14:28 +0530
Message-ID: <20230111114429.1297557-5-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230111114429.1297557-1-s-vadapalli@ti.com>
References: <20230111114429.1297557-1-s-vadapalli@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TI's AM62x SoC has a Time Sync Event Router, which enables routing a single
input signal to multiple recipients. This facilitates syncing all the
peripherals or processor cores to the input signal which acts as a master
clock.

Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
---
 arch/arm64/boot/dts/ti/k3-am62-main.dtsi | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/boot/dts/ti/k3-am62-main.dtsi b/arch/arm64/boot/dts/ti/k3-am62-main.dtsi
index 072903649d6e..4ce59170b6a7 100644
--- a/arch/arm64/boot/dts/ti/k3-am62-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62-main.dtsi
@@ -649,6 +649,15 @@ cpts@3d000 {
 		};
 	};
 
+	timesync_router: pinctrl@a40000 {
+		compatible = "pinctrl-single";
+		reg = <0x0 0xa40000 0x0 0x800>;
+		#pinctrl-cells = <1>;
+		pinctrl-single,register-width = <32>;
+		pinctrl-single,function-mask = <0x000107ff>;
+		status = "disabled";
+	};
+
 	hwspinlock: spinlock@2a000000 {
 		compatible = "ti,am64-hwspinlock";
 		reg = <0x00 0x2a000000 0x00 0x1000>;
-- 
2.25.1

