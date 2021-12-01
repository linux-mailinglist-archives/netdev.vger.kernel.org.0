Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07AF84643F7
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 01:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345792AbhLAAjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 19:39:16 -0500
Received: from inva021.nxp.com ([92.121.34.21]:42646 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345744AbhLAAjQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Nov 2021 19:39:16 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 31A7F20119F;
        Wed,  1 Dec 2021 01:35:55 +0100 (CET)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id E94A520118A;
        Wed,  1 Dec 2021 01:35:54 +0100 (CET)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id BE91F183ACCB;
        Wed,  1 Dec 2021 08:35:52 +0800 (+08)
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kuba@kernel.org, qiangqing.zhang@nxp.com, Anson.Huang@nxp.com,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, yannick.vignon@nxp.com,
        boon.leong.ong@intel.com, Jose.Abreu@synopsys.com, mst@redhat.com,
        Joao.Pinto@synopsys.com, mingkai.hu@nxp.com, leoyang.li@nxp.com,
        xiaoliang.yang_1@nxp.com
Subject: [PATCH 1/2] arm64: dts: imx8mp-evk: configure multiple queues on eqos
Date:   Wed,  1 Dec 2021 08:47:49 +0800
Message-Id: <20211201004750.49010-1-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eqos ethernet support five queues on hardware, enable these queues and
configure the priority of each queue.

Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
---
 arch/arm64/boot/dts/freescale/imx8mp-evk.dts | 41 ++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-evk.dts b/arch/arm64/boot/dts/freescale/imx8mp-evk.dts
index 7b99fad6e4d6..1e523b3d122b 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-evk.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-evk.dts
@@ -86,6 +86,9 @@
 	pinctrl-0 = <&pinctrl_eqos>;
 	phy-mode = "rgmii-id";
 	phy-handle = <&ethphy0>;
+	snps,force_thresh_dma_mode;
+	snps,mtl-tx-config = <&mtl_tx_setup>;
+	snps,mtl-rx-config = <&mtl_rx_setup>;
 	status = "okay";
 
 	mdio {
@@ -99,6 +102,44 @@
 			eee-broken-1000t;
 		};
 	};
+
+	mtl_tx_setup: tx-queues-config {
+		snps,tx-queues-to-use = <5>;
+		queue0 {
+			snps,priority = <0x0>;
+		};
+		queue1 {
+			snps,priority = <0x1>;
+		};
+		queue2 {
+			snps,priority = <0x2>;
+		};
+		queue3 {
+			snps,priority = <0x3>;
+		};
+		queue4 {
+			snps,priority = <0x4>;
+		};
+	};
+
+	mtl_rx_setup: rx-queues-config {
+		snps,rx-queues-to-use = <5>;
+		queue0 {
+			snps,priority = <0x0>;
+		};
+		queue1 {
+			snps,priority = <0x1>;
+		};
+		queue2 {
+			snps,priority = <0x2>;
+		};
+		queue3 {
+			snps,priority = <0x3>;
+		};
+		queue4 {
+			snps,priority = <0x4>;
+		};
+	};
 };
 
 &fec {
-- 
2.17.1

