Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC42360770A
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 14:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbiJUMjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 08:39:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbiJUMio (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 08:38:44 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FD8C2670EF
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 05:38:28 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20221021123827epoutp0342e48446c44af98d701ca2f50f340cd0~gFd5oJ9RT0743307433epoutp03d
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 12:38:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20221021123827epoutp0342e48446c44af98d701ca2f50f340cd0~gFd5oJ9RT0743307433epoutp03d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1666355907;
        bh=0UA+QTR0FkfkJo7+7ZrbSX8cXYLLiFn/NkBCfoaadW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qtBl2m/AyKeiX5+mcjC4z+VtPyN97mALgT4EMEShboXfgTUBHalZ8AjVUnbHk/U8i
         Vk1UvvqtMkA+VNjWRN5g6MX39wy9X6fWPpUlRKWeda05hpfah/0G5kan1j7KieCa0T
         LTTig5uExR0faXCJn5am4pS/sKhHgNDL4i2sjbi4=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20221021123826epcas5p2df4efc95c8e59c2608dab6fef360baf5~gFd48PibG2157121571epcas5p2W;
        Fri, 21 Oct 2022 12:38:26 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.174]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4Mv3sq6lD5z4x9Pv; Fri, 21 Oct
        2022 12:38:23 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        29.6F.56352.FB292536; Fri, 21 Oct 2022 21:38:23 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20221021102635epcas5p33623e6b6ed02d3fb663da9ec253585ad~gDqxbWSCr0943809438epcas5p3e;
        Fri, 21 Oct 2022 10:26:35 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20221021102635epsmtrp266c550ef92263276df6db4f724a81bea~gDqxZPLL40776407764epsmtrp2I;
        Fri, 21 Oct 2022 10:26:35 +0000 (GMT)
X-AuditID: b6c32a4b-5f7fe7000001dc20-92-635292bf6e66
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        13.40.18644.BD372536; Fri, 21 Oct 2022 19:26:35 +0900 (KST)
Received: from cheetah.sa.corp.samsungelectronics.net (unknown
        [107.109.115.53]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20221021102633epsmtip1d52552301b1c3d956e0657096a8cf681~gDqvaRIgG2574025740epsmtip19;
        Fri, 21 Oct 2022 10:26:33 +0000 (GMT)
From:   Vivek Yadav <vivek.2311@samsung.com>
To:     rcsekar@samsung.com, wg@grandegger.com, mkl@pengutronix.de,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, pankaj.dubey@samsung.com,
        ravi.patel@samsung.com, alim.akhtar@samsung.com
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vivek Yadav <vivek.2311@samsung.com>,
        Sriranjani P <sriranjani.p@samsung.com>
Subject: [PATCH 5/7] arm64: dts: fsd: Add MCAN device node
Date:   Fri, 21 Oct 2022 15:28:31 +0530
Message-Id: <20221021095833.62406-6-vivek.2311@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221021095833.62406-1-vivek.2311@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIJsWRmVeSWpSXmKPExsWy7bCmlu7+SUHJBsv+Glk8mLeNzWLO+RYW
        i6fHHrFbXNjWx2qx6vtUZovLu+awWaxfNIXF4tgCMYtvp98wWiza+oXd4uGHPewWsy7sYLW4
        /WYdq8WvhYdZLJbe28nqwO+xZeVNJo8Fm0o9Pl66zeixaVUnm0f/XwOP9/uusnn0bVnF6PF5
        k1wAR1S2TUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
        6UoKZYk5pUChgMTiYiV9O5ui/NKSVIWM/OISW6XUgpScApMCveLE3OLSvHS9vNQSK0MDAyNT
        oMKE7IzpZ56wF3xQq2jd8pS9gXG3fBcjJ4eEgInE5yuTmUFsIYHdjBJdrUxdjFxA9idGiSv/
        W9khnM+MEpdWvWaE6dh0dg8jRMcuRokPqwUgilqZJL7/aGQHSbAJaEk87lzAAmKLCNxllLi2
        OBPEZhZYxihx+IUOiC0sYCUx8RDEahYBVYmmiX1gvbwC1hI7np9jhlgmL7F6wwEwm1PARuLV
        /C1QR0zlkLh1ThrCdpFY3n2BFcIWlnh1fAs7hC0l8fndXjYIO1lix79OqJoMiQUT90DNsZc4
        cGUO0J0cQLdpSqzfpQ8RlpWYemodE8TJfBK9v58wQcR5JXbMg7FVJF58nsAK0gqyqvecMETY
        Q+LGlc3QQOxnlPh26g/bBEa5WQgbFjAyrmKUTC0ozk1PLTYtMM5LLYdHWXJ+7iZGcNrU8t7B
        +OjBB71DjEwcjIcYJTiYlUR4LeqCkoV4UxIrq1KL8uOLSnNSiw8xmgKDbyKzlGhyPjBx55XE
        G5pYGpiYmZmZWBqbGSqJ8y6eoZUsJJCeWJKanZpakFoE08fEwSnVwCR54mnMan6Oi4dlCifG
        n5zlqf2h9UJnvODky3zJEkIv50z/VD3zp/enC6kPG65O5kpiZO9ye5h6wnj7t7Br1Y3rV+5c
        If55Wev3G0rsoRYS86XvJgVefFwopHu+lqs8xzdmx5xzMXdXndlil5f3MXFNvMDMZYLdbKeK
        u/dmfWUs3pFt5C1+adXcPUrX2VWWTjVQmbfu2tFfRl2HA13/Pa7WuRqvEddyffXKfLa3Z+Yc
        zdef2rrff7JO+HZmB3cV7fsBvjLTn+5XXTJJ6bQub1wTz4lDd3K/f1nw9fOEY8vX+VX4NUgf
        5K24vk8x6cXKRJsNYjKrfG27vzp8mLrDxbonwMk9S+AtS03y1KocoWdKLMUZiYZazEXFiQC6
        rafwJAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsWy7bCSnO7t4qBkg4tPZSwezNvGZjHnfAuL
        xdNjj9gtLmzrY7VY9X0qs8XlXXPYLNYvmsJicWyBmMW3028YLRZt/cJu8fDDHnaLWRd2sFrc
        frOO1eLXwsMsFkvv7WR14PfYsvImk8eCTaUeHy/dZvTYtKqTzaP/r4HH+31X2Tz6tqxi9Pi8
        SS6AI4rLJiU1J7MstUjfLoErY/qZJ+wFH9QqWrc8ZW9g3C3fxcjJISFgIrHp7B7GLkYuDiGB
        HYwSGxr+M0MkpCSmnHnJAmELS6z895wdoqiZSeL1G5AOTg42AS2Jx50LwIpEBF4ySrScZQOx
        mQVWMUpcvK0IYgsLWElMPDQZbCiLgKpE08Q+dhCbV8BaYsfzc1DL5CVWbzgAZnMK2Ei8mr8F
        bL4QUM2yRzfZJzDyLWBkWMUomVpQnJueW2xYYJSXWq5XnJhbXJqXrpecn7uJERzeWlo7GPes
        +qB3iJGJg/EQowQHs5IIb8G7gGQh3pTEyqrUovz4otKc1OJDjNIcLErivBe6TsYLCaQnlqRm
        p6YWpBbBZJk4OKUamFr+nLUIqvB8823p4X2anekuB52mlJZ3nNLauHd59rpz0+6Kmxb9Dmj9
        Z/px1uq21YUVFffvG3iybd/9+EHGyedSfZFFsm4VN29venF0w/M5axe0NJW1Xti1jn3WP6k1
        ks1vJr6cIbLvTNTx/7GKtjXTXiQ/ygt+aKFvwXpa+B7zLY4OyWcBTxYfM1RbkKKisUJswqSs
        qbLvEv8ohumLqLx0nCH94tiStp8yIs/n1nQumi50Zv9bmTttP4Xmxzvtv2fF+2HyzQunv/Jt
        MDvFuvNMxb78TZMutYi+nDFrYoCVcEa66J0b88M6Ted0rnEtEvrC1zvp7u/JZjeP1xVcSvx0
        dOJibh+1pirbH2kxsgkhSizFGYmGWsxFxYkAq54RrN4CAAA=
X-CMS-MailID: 20221021102635epcas5p33623e6b6ed02d3fb663da9ec253585ad
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221021102635epcas5p33623e6b6ed02d3fb663da9ec253585ad
References: <20221021095833.62406-1-vivek.2311@samsung.com>
        <CGME20221021102635epcas5p33623e6b6ed02d3fb663da9ec253585ad@epcas5p3.samsung.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add MCAN device node and enable the same for FSD platform.
This also adds the required pin configuration for the same.

Signed-off-by: Sriranjani P <sriranjani.p@samsung.com>
Signed-off-by: Vivek Yadav <vivek.2311@samsung.com>
---
 arch/arm64/boot/dts/tesla/fsd-evb.dts      | 16 +++++
 arch/arm64/boot/dts/tesla/fsd-pinctrl.dtsi | 28 +++++++++
 arch/arm64/boot/dts/tesla/fsd.dtsi         | 68 ++++++++++++++++++++++
 3 files changed, 112 insertions(+)

diff --git a/arch/arm64/boot/dts/tesla/fsd-evb.dts b/arch/arm64/boot/dts/tesla/fsd-evb.dts
index 1db6ddf03f01..af3862e9fe3b 100644
--- a/arch/arm64/boot/dts/tesla/fsd-evb.dts
+++ b/arch/arm64/boot/dts/tesla/fsd-evb.dts
@@ -34,6 +34,22 @@
 	clock-frequency = <24000000>;
 };
 
+&m_can0 {
+	status = "okay";
+};
+
+&m_can1 {
+	status = "okay";
+};
+
+&m_can2 {
+	status = "okay";
+};
+
+&m_can3 {
+	status = "okay";
+};
+
 &serial_0 {
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/tesla/fsd-pinctrl.dtsi b/arch/arm64/boot/dts/tesla/fsd-pinctrl.dtsi
index d0abb9aa0e9e..bb5289ebfef3 100644
--- a/arch/arm64/boot/dts/tesla/fsd-pinctrl.dtsi
+++ b/arch/arm64/boot/dts/tesla/fsd-pinctrl.dtsi
@@ -339,6 +339,34 @@
 		samsung,pin-pud = <FSD_PIN_PULL_UP>;
 		samsung,pin-drv = <FSD_PIN_DRV_LV1>;
 	};
+
+	m_can0_bus: m-can0-bus-pins {
+		samsung,pins = "gpd0-0", "gpd0-1";
+		samsung,pin-function = <FSD_PIN_FUNC_2>;
+		samsung,pin-pud = <FSD_PIN_PULL_UP>;
+		samsung,pin-drv = <FSD_PIN_DRV_LV4>;
+	};
+
+	m_can1_bus: m-can1-bus-pins {
+		samsung,pins = "gpd0-2", "gpd0-3";
+		samsung,pin-function = <FSD_PIN_FUNC_2>;
+		samsung,pin-pud = <FSD_PIN_PULL_UP>;
+		samsung,pin-drv = <FSD_PIN_DRV_LV4>;
+	};
+
+	m_can2_bus: m-can2-bus-pins {
+		samsung,pins = "gpd0-4", "gpd0-5";
+		samsung,pin-function = <FSD_PIN_FUNC_2>;
+		samsung,pin-pud = <FSD_PIN_PULL_UP>;
+		samsung,pin-drv = <FSD_PIN_DRV_LV4>;
+	};
+
+	m_can3_bus: m-can3-bus-pins {
+		samsung,pins = "gpd0-6", "gpd0-7";
+		samsung,pin-function = <FSD_PIN_FUNC_2>;
+		samsung,pin-pud = <FSD_PIN_PULL_UP>;
+		samsung,pin-drv = <FSD_PIN_DRV_LV4>;
+	};
 };
 
 &pinctrl_pmu {
diff --git a/arch/arm64/boot/dts/tesla/fsd.dtsi b/arch/arm64/boot/dts/tesla/fsd.dtsi
index 3d8ebbfc27f4..154fd3fc5895 100644
--- a/arch/arm64/boot/dts/tesla/fsd.dtsi
+++ b/arch/arm64/boot/dts/tesla/fsd.dtsi
@@ -765,6 +765,74 @@
 			interrupts = <GIC_SPI 79 IRQ_TYPE_LEVEL_HIGH>;
 		};
 
+		m_can0: can@14088000 {
+			compatible = "bosch,m_can";
+			reg = <0x0 0x14088000 0x0 0x0200>,
+				<0x0 0x14080000 0x0 0x8000>;
+			reg-names = "m_can", "message_ram";
+			interrupts = <GIC_SPI 159 IRQ_TYPE_LEVEL_HIGH>,
+					<GIC_SPI 160 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "int0", "int1";
+			pinctrl-names = "default";
+			pinctrl-0 = <&m_can0_bus>;
+			clocks = <&clock_peric PERIC_MCAN0_IPCLKPORT_PCLK>,
+				<&clock_peric PERIC_MCAN0_IPCLKPORT_CCLK>;
+			clock-names = "hclk", "cclk";
+			bosch,mram-cfg = <0x0 128 64 64 64 64 32 32>;
+			status = "disabled";
+		};
+
+		m_can1: can@14098000 {
+			compatible = "bosch,m_can";
+			reg = <0x0 0x14098000 0x0 0x0200>,
+				<0x0 0x14090000 0x0 0x8000>;
+			reg-names = "m_can", "message_ram";
+			interrupts = <GIC_SPI 162 IRQ_TYPE_LEVEL_HIGH>,
+					<GIC_SPI 163 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "int0", "int1";
+			pinctrl-names = "default";
+			pinctrl-0 = <&m_can1_bus>;
+			clocks = <&clock_peric PERIC_MCAN1_IPCLKPORT_PCLK>,
+				<&clock_peric PERIC_MCAN1_IPCLKPORT_CCLK>;
+			clock-names = "hclk", "cclk";
+			bosch,mram-cfg = <0x0 128 64 64 64 64 32 32>;
+			status = "disabled";
+		};
+
+		m_can2: can@140a8000 {
+			compatible = "bosch,m_can";
+			reg = <0x0 0x140a8000 0x0 0x0200>,
+				<0x0 0x140a0000 0x0 0x8000>;
+			reg-names = "m_can", "message_ram";
+			interrupts = <GIC_SPI 165 IRQ_TYPE_LEVEL_HIGH>,
+					<GIC_SPI 166 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "int0", "int1";
+			pinctrl-names = "default";
+			pinctrl-0 = <&m_can2_bus>;
+			clocks = <&clock_peric PERIC_MCAN2_IPCLKPORT_PCLK>,
+				<&clock_peric PERIC_MCAN2_IPCLKPORT_CCLK>;
+			clock-names = "hclk", "cclk";
+			bosch,mram-cfg = <0x0 128 64 64 64 64 32 32>;
+			status = "disabled";
+		};
+
+		m_can3: can@140b8000 {
+			compatible = "bosch,m_can";
+			reg = <0x0 0x140b8000 0x0 0x0200>,
+				<0x0 0x140b0000 0x0 0x8000>;
+			reg-names = "m_can", "message_ram";
+			interrupts = <GIC_SPI 168 IRQ_TYPE_LEVEL_HIGH>,
+					<GIC_SPI 169 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "int0", "int1";
+			pinctrl-names = "default";
+			pinctrl-0 = <&m_can3_bus>;
+			clocks = <&clock_peric PERIC_MCAN3_IPCLKPORT_PCLK>,
+				<&clock_peric PERIC_MCAN3_IPCLKPORT_CCLK>;
+			clock-names = "hclk", "cclk";
+			bosch,mram-cfg = <0x0 128 64 64 64 64 32 32>;
+			status = "disabled";
+		};
+
 		spi_0: spi@14140000 {
 			compatible = "tesla,fsd-spi";
 			reg = <0x0 0x14140000 0x0 0x100>;
-- 
2.17.1

