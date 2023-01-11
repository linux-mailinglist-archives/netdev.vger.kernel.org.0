Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17F88665AC9
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 12:49:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233517AbjAKLtb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 06:49:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238743AbjAKLrn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 06:47:43 -0500
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B221BEE00;
        Wed, 11 Jan 2023 03:45:10 -0800 (PST)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 30BBj19h030754;
        Wed, 11 Jan 2023 05:45:01 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1673437501;
        bh=gsE4XZA6NpAH7Ib8hRW4+ivUA6rjtiQonN9LPKstIHs=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=o6A4OWfA2BlLYuN78JCu1jXn99wM9zuxMvtfd9GFGv3jiRxQ4bAduHY1Ey5TJV+yL
         RMdIoyXRKM30JDwVRtJH422pHH3QtQ42CHGTXRX2OuYlRUH8c8Ge6WUGPkQ1zh1eM1
         7OMQsxg0/llmwMwzW1kRm+zPadvsetyhxVlN9634=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 30BBj1xN079394
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 11 Jan 2023 05:45:01 -0600
Received: from DFLE102.ent.ti.com (10.64.6.23) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Wed, 11
 Jan 2023 05:45:00 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Wed, 11 Jan 2023 05:45:00 -0600
Received: from uda0492258.dhcp.ti.com (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 30BBiUkM093892;
        Wed, 11 Jan 2023 05:44:56 -0600
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
Subject: [PATCH net-next 5/5] arm64: dts: ti: k3-am625-sk: Add cpsw3g cpts PPS support
Date:   Wed, 11 Jan 2023 17:14:29 +0530
Message-ID: <20230111114429.1297557-6-s-vadapalli@ti.com>
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

The CPTS driver is capable of configuring GENFy (Periodic Signal Generator
Function) present in the CPTS module, to generate periodic output signals
with a custom time period. In order to generate a PPS signal on the GENFy
output, the device-tree property "ti,pps" has to be used. The "ti,pps"
property is used to declare the mapping between the CPTS HWx_TS_PUSH
(Hardware Timestamp trigger) input and the GENFy output that is configured
to generate a PPS signal. The mapping is of the form:
<x-1 y>
where the value x corresponds to HWx_TS_PUSH input (1-based indexing) and
the value y corresponds to GENFy (0-based indexing).

To verify that the signal is a PPS signal, the GENFy output signal is fed
into the CPTS HWx_TS_PUSH input, which generates a timestamp event on the
rising edge of the GENFy signal. The GENFy output signal can be routed to
the HWx_TS_PUSH input by using the Time Sync Router. This is done by
mentioning the mapping between the GENFy output and the HWx_TS_PUSH input
within the "timesync_router" device-tree node.

The Input Sources to the Time Sync Router are documented at: [1]
The Output Destinations of the Time Sync Router are documented at: [2]

The PPS signal can be verified using testptp and ppstest tools as follows:
 # ./testptp -d /dev/ptp0 -P 1
 pps for system time request okay
 # ./ppstest /dev/pps0
 trying PPS source "/dev/pps0"
 found PPS source "/dev/pps0"
 ok, found 1 source(s), now start fetching data...
 source 0 - assert 48.000000013, sequence: 8 - clear  0.000000000, sequence: 0
 source 0 - assert 49.000000013, sequence: 9 - clear  0.000000000, sequence: 0
 source 0 - assert 50.000000013, sequence: 10 - clear  0.000000000, sequence: 0

Add an example in the device-tree, enabling PPS generation on GENF1. The
HW3_TS_PUSH Timestamp trigger input is used to verify the PPS signal.

[1]
Link: https://software-dl.ti.com/tisci/esd/latest/5_soc_doc/am62x/interrupt_cfg.html#timesync-event-router0-interrupt-router-input-sources
[2]
Link: https://software-dl.ti.com/tisci/esd/latest/5_soc_doc/am62x/interrupt_cfg.html#timesync-event-router0-interrupt-router-output-destinations

Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
---
 arch/arm64/boot/dts/ti/k3-am625-sk.dts | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm64/boot/dts/ti/k3-am625-sk.dts b/arch/arm64/boot/dts/ti/k3-am625-sk.dts
index 4f179b146cab..962a922cc94b 100644
--- a/arch/arm64/boot/dts/ti/k3-am625-sk.dts
+++ b/arch/arm64/boot/dts/ti/k3-am625-sk.dts
@@ -366,6 +366,10 @@ &cpsw3g {
 	pinctrl-names = "default";
 	pinctrl-0 = <&main_rgmii1_pins_default
 		     &main_rgmii2_pins_default>;
+
+	cpts@3d000 {
+		ti,pps = <2 1>;
+	};
 };
 
 &cpsw_port1 {
@@ -464,3 +468,19 @@ partition@3fc0000 {
 		};
 	};
 };
+
+#define TS_OFFSET(pa, val)	(0x4+(pa)*4) (0x10000 | val)
+
+&timesync_router {
+	status = "okay";
+	pinctrl-names = "default";
+	pinctrl-0 = <&cpsw_cpts>;
+
+	/* Example of the timesync routing */
+	cpsw_cpts: cpsw-cpts {
+		pinctrl-single,pins = <
+			/* pps [cpsw cpts genf1] in17 -> out12 [cpsw cpts hw3_push] */
+			TS_OFFSET(12, 17)
+			>;
+	};
+};
-- 
2.25.1

