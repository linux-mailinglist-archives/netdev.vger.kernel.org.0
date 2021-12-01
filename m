Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3B5464491
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 02:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244362AbhLABid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 20:38:33 -0500
Received: from inva021.nxp.com ([92.121.34.21]:44966 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241053AbhLABic (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Nov 2021 20:38:32 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id B1F5F20191A;
        Wed,  1 Dec 2021 02:35:11 +0100 (CET)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 7F6C520190C;
        Wed,  1 Dec 2021 02:35:11 +0100 (CET)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id 6F851183ACCB;
        Wed,  1 Dec 2021 09:35:09 +0800 (+08)
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kuba@kernel.org, qiangqing.zhang@nxp.com, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        yannick.vignon@nxp.com, boon.leong.ong@intel.com,
        Jose.Abreu@synopsys.com, mst@redhat.com, Joao.Pinto@synopsys.com,
        mingkai.hu@nxp.com, leoyang.li@nxp.com, xiaoliang.yang_1@nxp.com
Subject: [PATCH net-next 1/2] arm64: dts: imx8mp-evk: configure multiple queues on eqos
Date:   Wed,  1 Dec 2021 09:47:04 +0800
Message-Id: <20211201014705.6975-2-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211201014705.6975-1-xiaoliang.yang_1@nxp.com>
References: <20211201014705.6975-1-xiaoliang.yang_1@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eqos ethernet support five queues on hardware, enable these queues and
configure the priority of each queue. Uses Strict Priority as scheduling
algorithms to ensure that the TSN function works.

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

