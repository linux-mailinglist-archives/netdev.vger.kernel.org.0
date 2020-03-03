Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BDEE177B6D
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 17:03:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730329AbgCCQBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 11:01:08 -0500
Received: from lelv0142.ext.ti.com ([198.47.23.249]:56898 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730197AbgCCQBD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 11:01:03 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 023G110K087011;
        Tue, 3 Mar 2020 10:01:01 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1583251261;
        bh=kMGzEG3llNgQuXMud+pl3UcHifoB2y/ZMOSZK0Quy3A=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=oGAEoToAiFkyZqc9hJqPrWskitemoDFntb6OHwV4d93i6/+EiiyNNFMMsHH6GmTYs
         KmI+Wunoslp9I4+cxYcPReqI0wu/2feH/q197LNsthIPIeC63TaI/lQ3/Unt2kbFpr
         DbVAUti+oLQbJsbGC9Rj3U7gycRuNdkjszCHsS18=
Received: from DFLE104.ent.ti.com (dfle104.ent.ti.com [10.64.6.25])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 023G119P112162
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 3 Mar 2020 10:01:01 -0600
Received: from DFLE114.ent.ti.com (10.64.6.35) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Tue, 3 Mar
 2020 10:01:00 -0600
Received: from localhost.localdomain (10.64.41.19) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Tue, 3 Mar 2020 10:01:01 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by localhost.localdomain (8.15.2/8.15.2) with ESMTP id 023G10jb030402;
        Tue, 3 Mar 2020 10:01:00 -0600
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     Murali Karicheri <m-karicheri2@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Tero Kristo <t-kristo@ti.com>,
        "David S . Miller" <davem@davemloft.net>
CC:     Sekhar Nori <nsekhar@ti.com>, Rob Herring <robh+dt@kernel.org>,
        netdev <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [for-next PATCH v2 5/5] arm64: dts: ti: k3-j721e-mcu: add scm node and phy-gmii-sel nodes
Date:   Tue, 3 Mar 2020 18:00:29 +0200
Message-ID: <20200303160029.345-6-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200303160029.345-1-grygorii.strashko@ti.com>
References: <20200303160029.345-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add DT node for MCU System Control module DT node and DT node for the TI
J721E SoC phy-gmii-sel PHY required for Ethernet ports mode selection.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 arch/arm64/boot/dts/ti/k3-j721e-mcu-wakeup.dtsi | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm64/boot/dts/ti/k3-j721e-mcu-wakeup.dtsi b/arch/arm64/boot/dts/ti/k3-j721e-mcu-wakeup.dtsi
index 16c874bfd49a..6f961d5f077a 100644
--- a/arch/arm64/boot/dts/ti/k3-j721e-mcu-wakeup.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j721e-mcu-wakeup.dtsi
@@ -34,6 +34,20 @@
 		};
 	};
 
+	mcu_conf: syscon@40f00000 {
+		compatible = "syscon", "simple-mfd";
+		reg = <0x0 0x40f00000 0x0 0x20000>;
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges = <0x0 0x0 0x40f00000 0x20000>;
+
+		phy_gmii_sel: phy@4040 {
+			compatible = "ti,am654-phy-gmii-sel";
+			reg = <0x4040 0x4>;
+			#phy-cells = <1>;
+		};
+	};
+
 	wkup_pmx0: pinmux@4301c000 {
 		compatible = "pinctrl-single";
 		/* Proxy 0 addressing */
-- 
2.17.1

