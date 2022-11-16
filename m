Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7929362B9FD
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 11:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238907AbiKPKtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 05:49:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233771AbiKPKtE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 05:49:04 -0500
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E2EBFCEB
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 02:37:27 -0800 (PST)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20221116103722epoutp01a57f60e36f176d39525af4fcf160975f~oClnF5DuH2951429514epoutp01F
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 10:37:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20221116103722epoutp01a57f60e36f176d39525af4fcf160975f~oClnF5DuH2951429514epoutp01F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1668595042;
        bh=2d2nToH+3CLmligaAbCbS+2i+xS+WtQiNEytigtIN7c=;
        h=From:To:Cc:Subject:Date:References:From;
        b=CThfVloz3i6hQcXOx6p/+6RsYxSWgC2WXcNenXszw7adetx6qS834nAgfIp1NHSCt
         IZQ0P9nzC6P6b2ysBzURvSWlj86kuLeoqo4g1XRKs9xsT6Plj31SP2Wk3RNup8m30c
         NqMB7E6oejRcQr5ND/HX5+4/fgnz2MdFbO23P6RM=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20221116103721epcas5p326929cd0d980c6de49ca6bbedf01092a~oClmCbrRr1961719617epcas5p3n;
        Wed, 16 Nov 2022 10:37:21 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.178]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4NBzy7550rz4x9Pv; Wed, 16 Nov
        2022 10:37:19 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        FC.28.39477.F5DB4736; Wed, 16 Nov 2022 19:37:19 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20221116090644epcas5p3a0fa6d51819a2b2a9570f236191748ea~oBWeQC0x11719417194epcas5p3P;
        Wed, 16 Nov 2022 09:06:44 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20221116090644epsmtrp2ac8ae7579660093a0a74b601ee0de9a8~oBWeO20s82745427454epsmtrp2h;
        Wed, 16 Nov 2022 09:06:44 +0000 (GMT)
X-AuditID: b6c32a4a-259fb70000019a35-e2-6374bd5f041c
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        FA.11.18644.428A4736; Wed, 16 Nov 2022 18:06:44 +0900 (KST)
Received: from cheetah.sa.corp.samsungelectronics.net (unknown
        [107.109.115.53]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20221116090639epsmtip278e51ffe96dffbb921c510fee2f04ebb~oBWZyneJz2996229962epsmtip2b;
        Wed, 16 Nov 2022 09:06:39 +0000 (GMT)
From:   Vivek Yadav <vivek.2311@samsung.com>
To:     rcsekar@samsung.com, krzysztof.kozlowski+dt@linaro.org,
        wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        pankaj.dubey@samsung.com, ravi.patel@samsung.com,
        alim.akhtar@samsung.com, linux-fsd@tesla.com, robh+dt@kernel.org
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        aswani.reddy@samsung.com, sriranjani.p@samsung.com,
        ajaykumar.rs@samsung.com, Vivek Yadav <vivek.2311@samsung.com>
Subject: [PATCH] arm64: dts: fsd: Change the reg properties from 64-bit to
 32-bit
Date:   Wed, 16 Nov 2022 14:42:47 +0530
Message-Id: <20221116091247.52388-1-vivek.2311@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA0WTfUxTVxjGc+5HWzS4S3HzyMLATmckAi22eEDByRi5cW6wMCIuI6yUK2X0
        y97WgWYRFvkDJkg3SBhf6xibATZwpXyIwLAw1EmkUzT4MUJlIIFGWKsITtxaL2z//d7nfZ88
        Oe85R4ALe3gBgmyNgdFr5CoRbx3RMbBje2h6r0Ehbh3fgvrnLxJooq6Dh2xt7XxUM3KKQN8M
        XiPR1NB9PiqdceDI3lFKIsvkLRI1PanAkWP2ELrRXcNDlSN9GGqtLyfQkPkVtHjVCVB9+yM+
        ciz08FGVvYtEhb2DfHTX2UKip98OEOj78fPkm5toa+NtjDZbjPRf1+8C2tJUxKPv3erh0W0N
        J+kzK2J6vu8mjy61NgH6+ee1fNpteS1p/Yc5e5WMPJPRBzMahTYzW5MVI3onOf2tdFmkWBIq
        iUK7RcEauZqJEcUfTApNyFZ5zisKPiZXGT1SkpxlReGxe/Vao4EJVmpZQ4yI0WWqdFJdGCtX
        s0ZNVpiGMURLxOIImWfw4xxlfuUdTHdFnetqH+Tlg4fJxcBHACkprL54hvCykLoAoGtYWAzW
        edgF4Py5SZIr3AB21BQRa46CqT4+1+gGsLrKvVoUYvBS8ZcvpnhUCJwsMhPexkaqGYNWtwN4
        C5yyYnD5HxPwTvlTyXBo4Z7HLhAQ1DZYXfGJV/al9sCV60urcUGw+Vw/7vVCalgASxobcK4R
        D39srl1lfzh7ycrnOAC6H/byOFbArudFJMdKaDb1AI73wf7RGsKbi1M7YGt3OCcHworfWjAv
        49QGWPL3nxin+8KuujXeCmfcZaTX6o0quebPyTQsnBohuT2mQctZGygDgVX/B5gBaAKbGR2r
        zmJYmS5Cw3z630UptGoLePGMQw50AcfEQpgNYAJgA1CAizb6ar8yKIS+mfK844xem643qhjW
        BmSejZnwgJcVWs8/0BjSJdIosTQyMlIatStSItrk+11liEJIZckNTA7D6Bj9mg8T+ATkY/vt
        ifGF9oGbMW3Rv46898iwuJ70ixtzsUHPylNlt/Xzttd/7hfuWs49vLv7M1PxF78ciC8fe2kq
        r+jKs9g/Qvcspo7dGU3YNhdYPyQlV17t1Fx+HNt+nlBETByRvOsz1JDywc6cN5yPf0gxZz4Y
        GG2axjbEJqsr3z66FJ1ytDbt7GzuglGhTpyYCVzwG08Qpp3enGGvlNpj61syHFvjH9zojD7R
        05n1k6vx/rEQudsktJaNm+a2xB3yU/YHuPZ1BBekfjRdsWyIG8g/sv+k/+mv5yMuhJ4aTX4S
        5nRS21Wy6dSl8KDfh9/Pv3y1YHa2LNGSV5fntMwdrlKdcCfsbLBltEweFBGsUi4JwfWs/F/V
        gjvmTwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJLMWRmVeSWpSXmKPExsWy7bCSvK7KipJkgwVbuSwOvD/IYvFg3jY2
        i0Obt7JbzDnfwmIx/8g5Vounxx6xW/S9eMhscWFbH6vFpsfXWC1WfZ/KbPHwVbjF5V1z2Cxm
        nN/HZLF+0RQWi2MLxCy+nX7DaLFo6xd2i4cf9rBbzLqwg9Wide8Rdovbb9axWvxaeJjFYum9
        nawO4h5bVt5k8liwqdTj46XbjB6bVnWyedy5tofNY/OSeo/+vwYe7/ddZfPo27KK0eNf01x2
        j8+b5AK4o7hsUlJzMstSi/TtErgyGmbcYio4mVvxaesRtgbGd8FdjJwcEgImEo1P97F3MXJx
        CAnsYJT48PwqK0RCSmLKmZcsELawxMp/z6GKmpkkdpz6yASSYBPQknjcuYAFJCEisJtJ4m33
        XLAqZoF9TBJH9+wEaxcWCJQ4fegk0FgODhYBVYnZU7NAwrwC1hJ/L/2A2iAvsXrDAeYJjDwL
        GBlWMUqmFhTnpucWGxYY5aWW6xUn5haX5qXrJefnbmIEx4aW1g7GPas+6B1iZOJgPMQowcGs
        JMKbP7kkWYg3JbGyKrUoP76oNCe1+BCjNAeLkjjvha6T8UIC6YklqdmpqQWpRTBZJg5OqQam
        YudHrhWe6RJ90S8rVViDVnReiNK3nnC4eOXdyiVSbiueHgwVmXHRK8B5rvrWaGUhzWsnrBzY
        lcP8n5X92bHN/cTE/pBclfehmpPCBL3vX+eQrflwUsfQ18xml+HXrrtiYfIMad+lf0wQrROc
        GLxNWs/+0AFPduMzCznW1G6/989jk/hRv9TtV+O+dm25ULAqrfhahPLC9wdfbLY0u5zP9XDb
        48VaV/r5re4v6n4a1bTld6e25mRJ67LDhmp1/TbvCn4cehx7okGzUGV+2BExu/lODvw2UnNu
        yDtny4XuefRa5OKlvYdyz324E1Yy2+dHd29sWYQzJ0fU1raVO3d9zH4dHLZlV4bwZcXrOcFK
        LMUZiYZazEXFiQAYji3w/AIAAA==
X-CMS-MailID: 20221116090644epcas5p3a0fa6d51819a2b2a9570f236191748ea
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221116090644epcas5p3a0fa6d51819a2b2a9570f236191748ea
References: <CGME20221116090644epcas5p3a0fa6d51819a2b2a9570f236191748ea@epcas5p3.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change the reg properties from 64-bit to 32-bit for all IPs, as none of
the nodes are above 32-bit range in the fsd SoC.

Since dma-ranges length does not fit into 32-bit size, keep it 64-bit
and move it to specific node where it is used instead of SoC section.

Signed-off-by: Ravi Patel <ravi.patel@samsung.com>
Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
Signed-off-by: Vivek Yadav <vivek.2311@samsung.com>
---
 arch/arm64/boot/dts/tesla/fsd-evb.dts |   2 +
 arch/arm64/boot/dts/tesla/fsd.dtsi    | 109 ++++++++++++++------------
 2 files changed, 62 insertions(+), 49 deletions(-)

diff --git a/arch/arm64/boot/dts/tesla/fsd-evb.dts b/arch/arm64/boot/dts/tesla/fsd-evb.dts
index 1db6ddf03f01..81d9937d8828 100644
--- a/arch/arm64/boot/dts/tesla/fsd-evb.dts
+++ b/arch/arm64/boot/dts/tesla/fsd-evb.dts
@@ -14,6 +14,8 @@
 / {
 	model = "Tesla Full Self-Driving (FSD) Evaluation board";
 	compatible = "tesla,fsd-evb", "tesla,fsd";
+	#address-cells = <2>;
+	#size-cells = <2>;
 
 	aliases {
 		serial0 = &serial_0;
diff --git a/arch/arm64/boot/dts/tesla/fsd.dtsi b/arch/arm64/boot/dts/tesla/fsd.dtsi
index f35bc5a288c2..7378ae39233a 100644
--- a/arch/arm64/boot/dts/tesla/fsd.dtsi
+++ b/arch/arm64/boot/dts/tesla/fsd.dtsi
@@ -342,23 +342,22 @@
 
 	soc: soc@0 {
 		compatible = "simple-bus";
-		#address-cells = <2>;
-		#size-cells = <2>;
-		ranges = <0x0 0x0 0x0 0x0 0x0 0x18000000>;
-		dma-ranges = <0x0 0x0 0x0 0x0 0x10 0x0>;
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges = <0x0 0x0 0x0 0x18000000>;
 
 		gic: interrupt-controller@10400000 {
 			compatible = "arm,gic-v3";
 			#interrupt-cells = <3>;
 			interrupt-controller;
-			reg =	<0x0 0x10400000 0x0 0x10000>, /* GICD */
-				<0x0 0x10600000 0x0 0x200000>; /* GICR_RD+GICR_SGI */
+			reg =	<0x10400000 0x10000>, /* GICD */
+				<0x10600000 0x200000>; /* GICR_RD+GICR_SGI */
 			interrupts = <GIC_PPI 9 IRQ_TYPE_LEVEL_HIGH>;
 		};
 
 		smmu_imem: iommu@10200000 {
 			compatible = "arm,mmu-500";
-			reg = <0x0 0x10200000 0x0 0x10000>;
+			reg = <0x10200000 0x10000>;
 			#iommu-cells = <2>;
 			#global-interrupts = <7>;
 			interrupts = <GIC_SPI 438 IRQ_TYPE_LEVEL_HIGH>, /* Global secure fault */
@@ -378,7 +377,7 @@
 
 		smmu_isp: iommu@12100000 {
 			compatible = "arm,mmu-500";
-			reg = <0x0 0x12100000 0x0 0x10000>;
+			reg = <0x12100000 0x10000>;
 			#iommu-cells = <2>;
 			#global-interrupts = <11>;
 			interrupts = <GIC_SPI 321 IRQ_TYPE_LEVEL_HIGH>, /* Global secure fault */
@@ -406,7 +405,7 @@
 
 		smmu_peric: iommu@14900000 {
 			compatible = "arm,mmu-500";
-			reg = <0x0 0x14900000 0x0 0x10000>;
+			reg = <0x14900000 0x10000>;
 			#iommu-cells = <2>;
 			#global-interrupts = <5>;
 			interrupts = <GIC_SPI 197 IRQ_TYPE_LEVEL_HIGH>, /* Global secure fault */
@@ -422,7 +421,7 @@
 
 		smmu_fsys0: iommu@15450000 {
 			compatible = "arm,mmu-500";
-			reg = <0x0 0x15450000 0x0 0x10000>;
+			reg = <0x15450000 0x10000>;
 			#iommu-cells = <2>;
 			#global-interrupts = <5>;
 			interrupts = <GIC_SPI 100 IRQ_TYPE_LEVEL_HIGH>, /* Global secure fault */
@@ -438,7 +437,7 @@
 
 		clock_imem: clock-controller@10010000 {
 			compatible = "tesla,fsd-clock-imem";
-			reg = <0x0 0x10010000 0x0 0x3000>;
+			reg = <0x10010000 0x3000>;
 			#clock-cells = <1>;
 			clocks = <&fin_pll>,
 				<&clock_cmu DOUT_CMU_IMEM_TCUCLK>,
@@ -452,7 +451,7 @@
 
 		clock_cmu: clock-controller@11c10000 {
 			compatible = "tesla,fsd-clock-cmu";
-			reg = <0x0 0x11c10000 0x0 0x3000>;
+			reg = <0x11c10000 0x3000>;
 			#clock-cells = <1>;
 			clocks = <&fin_pll>;
 			clock-names = "fin_pll";
@@ -460,7 +459,7 @@
 
 		clock_csi: clock-controller@12610000 {
 			compatible = "tesla,fsd-clock-cam_csi";
-			reg = <0x0 0x12610000 0x0 0x3000>;
+			reg = <0x12610000 0x3000>;
 			#clock-cells = <1>;
 			clocks = <&fin_pll>;
 			clock-names = "fin_pll";
@@ -468,7 +467,7 @@
 
 		clock_mfc: clock-controller@12810000 {
 			compatible = "tesla,fsd-clock-mfc";
-			reg = <0x0 0x12810000 0x0 0x3000>;
+			reg = <0x12810000 0x3000>;
 			#clock-cells = <1>;
 			clocks = <&fin_pll>;
 			clock-names = "fin_pll";
@@ -476,7 +475,7 @@
 
 		clock_peric: clock-controller@14010000 {
 			compatible = "tesla,fsd-clock-peric";
-			reg = <0x0 0x14010000 0x0 0x3000>;
+			reg = <0x14010000 0x3000>;
 			#clock-cells = <1>;
 			clocks = <&fin_pll>,
 				<&clock_cmu DOUT_CMU_PLL_SHARED0_DIV4>,
@@ -494,7 +493,7 @@
 
 		clock_fsys0: clock-controller@15010000 {
 			compatible = "tesla,fsd-clock-fsys0";
-			reg = <0x0 0x15010000 0x0 0x3000>;
+			reg = <0x15010000 0x3000>;
 			#clock-cells = <1>;
 			clocks = <&fin_pll>,
 				<&clock_cmu DOUT_CMU_PLL_SHARED0_DIV6>,
@@ -508,7 +507,7 @@
 
 		clock_fsys1: clock-controller@16810000 {
 			compatible = "tesla,fsd-clock-fsys1";
-			reg = <0x0 0x16810000 0x0 0x3000>;
+			reg = <0x16810000 0x3000>;
 			#clock-cells = <1>;
 			clocks = <&fin_pll>,
 				<&clock_cmu DOUT_CMU_FSYS1_SHARED0DIV8>,
@@ -520,47 +519,59 @@
 
 		mdma0: dma-controller@10100000 {
 			compatible = "arm,pl330", "arm,primecell";
-			reg = <0x0 0x10100000 0x0 0x1000>;
+			reg = <0x10100000 0x1000>;
 			interrupts = <GIC_SPI 424 IRQ_TYPE_LEVEL_HIGH>;
 			#dma-cells = <1>;
 			clocks = <&clock_imem IMEM_DMA0_IPCLKPORT_ACLK>;
 			clock-names = "apb_pclk";
 			iommus = <&smmu_imem 0x800 0x0>;
+			#address-cells = <2>;
+			#size-cells = <2>;
+			dma-ranges = <0x0 0x0 0x0 0x10 0x0>;
 		};
 
 		mdma1: dma-controller@10110000 {
 			compatible = "arm,pl330", "arm,primecell";
-			reg = <0x0 0x10110000 0x0 0x1000>;
+			reg = <0x10110000 0x1000>;
 			interrupts = <GIC_SPI 425 IRQ_TYPE_LEVEL_HIGH>;
 			#dma-cells = <1>;
 			clocks = <&clock_imem IMEM_DMA1_IPCLKPORT_ACLK>;
 			clock-names = "apb_pclk";
 			iommus = <&smmu_imem 0x801 0x0>;
+			#address-cells = <2>;
+			#size-cells = <2>;
+			dma-ranges = <0x0 0x0 0x0 0x10 0x0>;
 		};
 
 		pdma0: dma-controller@14280000 {
 			compatible = "arm,pl330", "arm,primecell";
-			reg = <0x0 0x14280000 0x0 0x1000>;
+			reg = <0x14280000 0x1000>;
 			interrupts = <GIC_SPI 190 IRQ_TYPE_LEVEL_HIGH>;
 			#dma-cells = <1>;
 			clocks = <&clock_peric PERIC_DMA0_IPCLKPORT_ACLK>;
 			clock-names = "apb_pclk";
 			iommus = <&smmu_peric 0x2 0x0>;
+			#address-cells = <2>;
+			#size-cells = <2>;
+			dma-ranges = <0x0 0x0 0x0 0x10 0x0>;
 		};
 
 		pdma1: dma-controller@14290000 {
 			compatible = "arm,pl330", "arm,primecell";
-			reg = <0x0 0x14290000 0x0 0x1000>;
+			reg = <0x14290000 0x1000>;
 			interrupts = <GIC_SPI 191 IRQ_TYPE_LEVEL_HIGH>;
 			#dma-cells = <1>;
 			clocks = <&clock_peric PERIC_DMA1_IPCLKPORT_ACLK>;
 			clock-names = "apb_pclk";
 			iommus = <&smmu_peric 0x1 0x0>;
+			#address-cells = <2>;
+			#size-cells = <2>;
+			dma-ranges = <0x0 0x0 0x0 0x10 0x0>;
 		};
 
 		serial_0: serial@14180000 {
 			compatible = "samsung,exynos4210-uart";
-			reg = <0x0 0x14180000 0x0 0x100>;
+			reg = <0x14180000 0x100>;
 			interrupts = <GIC_SPI 171 IRQ_TYPE_LEVEL_HIGH>;
 			dmas = <&pdma1 1>, <&pdma1 0>;
 			dma-names = "rx", "tx";
@@ -572,7 +583,7 @@
 
 		serial_1: serial@14190000 {
 			compatible = "samsung,exynos4210-uart";
-			reg = <0x0 0x14190000 0x0 0x100>;
+			reg = <0x14190000 0x100>;
 			interrupts = <GIC_SPI 172 IRQ_TYPE_LEVEL_HIGH>;
 			dmas = <&pdma1 3>, <&pdma1 2>;
 			dma-names = "rx", "tx";
@@ -584,12 +595,12 @@
 
 		pmu_system_controller: system-controller@11400000 {
 			compatible = "samsung,exynos7-pmu", "syscon";
-			reg = <0x0 0x11400000 0x0 0x5000>;
+			reg = <0x11400000 0x5000>;
 		};
 
 		watchdog_0: watchdog@100a0000 {
 			compatible = "samsung,exynos7-wdt";
-			reg = <0x0 0x100a0000 0x0 0x100>;
+			reg = <0x100a0000 0x100>;
 			interrupts = <GIC_SPI 471 IRQ_TYPE_LEVEL_HIGH>;
 			samsung,syscon-phandle = <&pmu_system_controller>;
 			clocks = <&fin_pll>;
@@ -598,7 +609,7 @@
 
 		watchdog_1: watchdog@100b0000 {
 			compatible = "samsung,exynos7-wdt";
-			reg = <0x0 0x100b0000 0x0 0x100>;
+			reg = <0x100b0000 0x100>;
 			interrupts = <GIC_SPI 472 IRQ_TYPE_LEVEL_HIGH>;
 			samsung,syscon-phandle = <&pmu_system_controller>;
 			clocks = <&fin_pll>;
@@ -607,7 +618,7 @@
 
 		watchdog_2: watchdog@100c0000 {
 			compatible = "samsung,exynos7-wdt";
-			reg = <0x0 0x100c0000 0x0 0x100>;
+			reg = <0x100c0000 0x100>;
 			interrupts = <GIC_SPI 473 IRQ_TYPE_LEVEL_HIGH>;
 			samsung,syscon-phandle = <&pmu_system_controller>;
 			clocks = <&fin_pll>;
@@ -616,7 +627,7 @@
 
 		pwm_0: pwm@14100000 {
 			compatible = "samsung,exynos4210-pwm";
-			reg = <0x0 0x14100000 0x0 0x100>;
+			reg = <0x14100000 0x100>;
 			samsung,pwm-outputs = <0>, <1>, <2>, <3>;
 			#pwm-cells = <3>;
 			clocks = <&clock_peric PERIC_PWM0_IPCLKPORT_I_PCLK_S0>;
@@ -626,7 +637,7 @@
 
 		pwm_1: pwm@14110000 {
 			compatible = "samsung,exynos4210-pwm";
-			reg = <0x0 0x14110000 0x0 0x100>;
+			reg = <0x14110000 0x100>;
 			samsung,pwm-outputs = <0>, <1>, <2>, <3>;
 			#pwm-cells = <3>;
 			clocks = <&clock_peric PERIC_PWM1_IPCLKPORT_I_PCLK_S0>;
@@ -636,7 +647,7 @@
 
 		hsi2c_0: i2c@14200000 {
 			compatible = "samsung,exynos7-hsi2c";
-			reg = <0x0 0x14200000 0x0 0x1000>;
+			reg = <0x14200000 0x1000>;
 			interrupts = <GIC_SPI 148 IRQ_TYPE_LEVEL_HIGH>;
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -649,7 +660,7 @@
 
 		hsi2c_1: i2c@14210000 {
 			compatible = "samsung,exynos7-hsi2c";
-			reg = <0x0 0x14210000 0x0 0x1000>;
+			reg = <0x14210000 0x1000>;
 			interrupts = <GIC_SPI 149 IRQ_TYPE_LEVEL_HIGH>;
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -662,7 +673,7 @@
 
 		hsi2c_2: i2c@14220000 {
 			compatible = "samsung,exynos7-hsi2c";
-			reg = <0x0 0x14220000 0x0 0x1000>;
+			reg = <0x14220000 0x1000>;
 			interrupts = <GIC_SPI 150 IRQ_TYPE_LEVEL_HIGH>;
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -675,7 +686,7 @@
 
 		hsi2c_3: i2c@14230000 {
 			compatible = "samsung,exynos7-hsi2c";
-			reg = <0x0 0x14230000 0x0 0x1000>;
+			reg = <0x14230000 0x1000>;
 			interrupts = <GIC_SPI 151 IRQ_TYPE_LEVEL_HIGH>;
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -688,7 +699,7 @@
 
 		hsi2c_4: i2c@14240000 {
 			compatible = "samsung,exynos7-hsi2c";
-			reg = <0x0 0x14240000 0x0 0x1000>;
+			reg = <0x14240000 0x1000>;
 			interrupts = <GIC_SPI 152 IRQ_TYPE_LEVEL_HIGH>;
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -701,7 +712,7 @@
 
 		hsi2c_5: i2c@14250000 {
 			compatible = "samsung,exynos7-hsi2c";
-			reg = <0x0 0x14250000 0x0 0x1000>;
+			reg = <0x14250000 0x1000>;
 			interrupts = <GIC_SPI 153 IRQ_TYPE_LEVEL_HIGH>;
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -714,7 +725,7 @@
 
 		hsi2c_6: i2c@14260000 {
 			compatible = "samsung,exynos7-hsi2c";
-			reg = <0x0 0x14260000 0x0 0x1000>;
+			reg = <0x14260000 0x1000>;
 			interrupts = <GIC_SPI 154 IRQ_TYPE_LEVEL_HIGH>;
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -727,7 +738,7 @@
 
 		hsi2c_7: i2c@14270000 {
 			compatible = "samsung,exynos7-hsi2c";
-			reg = <0x0 0x14270000 0x0 0x1000>;
+			reg = <0x14270000 0x1000>;
 			interrupts = <GIC_SPI 155 IRQ_TYPE_LEVEL_HIGH>;
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -740,24 +751,24 @@
 
 		pinctrl_pmu: pinctrl@114f0000 {
 			compatible = "tesla,fsd-pinctrl";
-			reg = <0x0 0x114f0000 0x0 0x1000>;
+			reg = <0x114f0000 0x1000>;
 		};
 
 		pinctrl_peric: pinctrl@141f0000 {
 			compatible = "tesla,fsd-pinctrl";
-			reg = <0x0 0x141f0000 0x0 0x1000>;
+			reg = <0x141f0000 0x1000>;
 			interrupts = <GIC_SPI 189 IRQ_TYPE_LEVEL_HIGH>;
 		};
 
 		pinctrl_fsys0: pinctrl@15020000 {
 			compatible = "tesla,fsd-pinctrl";
-			reg = <0x0 0x15020000 0x0 0x1000>;
+			reg = <0x15020000 0x1000>;
 			interrupts = <GIC_SPI 79 IRQ_TYPE_LEVEL_HIGH>;
 		};
 
 		spi_0: spi@14140000 {
 			compatible = "tesla,fsd-spi";
-			reg = <0x0 0x14140000 0x0 0x100>;
+			reg = <0x14140000 0x100>;
 			interrupts = <GIC_SPI 156 IRQ_TYPE_LEVEL_HIGH>;
 			dmas = <&pdma1 4>, <&pdma1 5>;
 			dma-names = "tx", "rx";
@@ -775,7 +786,7 @@
 
 		spi_1: spi@14150000 {
 			compatible = "tesla,fsd-spi";
-			reg = <0x0 0x14150000 0x0 0x100>;
+			reg = <0x14150000 0x100>;
 			interrupts = <GIC_SPI 157 IRQ_TYPE_LEVEL_HIGH>;
 			dmas = <&pdma1 6>, <&pdma1 7>;
 			dma-names = "tx", "rx";
@@ -793,7 +804,7 @@
 
 		spi_2: spi@14160000 {
 			compatible = "tesla,fsd-spi";
-			reg = <0x0 0x14160000 0x0 0x100>;
+			reg = <0x14160000 0x100>;
 			interrupts = <GIC_SPI 158 IRQ_TYPE_LEVEL_HIGH>;
 			dmas = <&pdma1 8>, <&pdma1 9>;
 			dma-names = "tx", "rx";
@@ -811,7 +822,7 @@
 
 		timer@10040000 {
 			compatible = "tesla,fsd-mct", "samsung,exynos4210-mct";
-			reg = <0x0 0x10040000 0x0 0x800>;
+			reg = <0x10040000 0x800>;
 			interrupts = <GIC_SPI 455 IRQ_TYPE_LEVEL_HIGH>,
 				<GIC_SPI 456 IRQ_TYPE_LEVEL_HIGH>,
 				<GIC_SPI 457 IRQ_TYPE_LEVEL_HIGH>,
@@ -834,10 +845,10 @@
 
 		ufs: ufs@15120000 {
 			compatible = "tesla,fsd-ufs";
-			reg = <0x0 0x15120000 0x0 0x200>,  /* 0: HCI standard */
-			      <0x0 0x15121100 0x0 0x200>,  /* 1: Vendor specified */
-			      <0x0 0x15110000 0x0 0x8000>,  /* 2: UNIPRO */
-			      <0x0 0x15130000 0x0 0x100>;  /* 3: UFS protector */
+			reg = <0x15120000 0x200>,  /* 0: HCI standard */
+			      <0x15121100 0x200>,  /* 1: Vendor specified */
+			      <0x15110000 0x8000>,  /* 2: UNIPRO */
+			      <0x15130000 0x100>;  /* 3: UFS protector */
 			reg-names = "hci", "vs_hci", "unipro", "ufsp";
 			interrupts = <GIC_SPI 91 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&clock_fsys0 UFS0_TOP0_HCLK_BUS>,
@@ -853,7 +864,7 @@
 
 		ufs_phy: ufs-phy@15124000 {
 			compatible = "tesla,fsd-ufs-phy";
-			reg = <0x0 0x15124000 0x0 0x800>;
+			reg = <0x15124000 0x800>;
 			reg-names = "phy-pma";
 			samsung,pmu-syscon = <&pmu_system_controller>;
 			#phy-cells = <0>;
-- 
2.17.1

