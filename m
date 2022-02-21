Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28E614BDE80
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:47:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378006AbiBUOg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 09:36:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377884AbiBUOfu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 09:35:50 -0500
Received: from mx.tkos.co.il (guitar.tcltek.co.il [84.110.109.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C2F01C116;
        Mon, 21 Feb 2022 06:35:26 -0800 (PST)
Received: from tarshish.tkos.co.il (unknown [10.0.8.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id EBA2F440F4B;
        Mon, 21 Feb 2022 16:34:50 +0200 (IST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tkos.co.il;
        s=default; t=1645454091;
        bh=8Yo/rDOE+4o1/9eoH/MnPevjHwozuDlo2GnwOqB7MmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NdB14XKWAaLzWE8tbZZn3/N4aBXMUw6ftC1P0+k7dhaZv5qH3SNN6CC29N/35ZtVQ
         W76PKfv+3I1oup2BdznTUuC6sKh33uV/eSiV0nvoGBZNQrcvz4XhuRucRUgy/5/ob8
         SrMm1XeKI5cOiSe3kXIDX6pFFuovK3omvw17Tc9NFgN48IkFIV5qkBOJfArFqSvMo0
         t91MWA30Dqo7NfS+LjRR4i1RBLgOeTWxjoDslgVTj0SFb2wN9KoEam3OsmmZfXOMhw
         LL+tgf/uauWlJHVTOIyVvBwPhpZC8C4zk6IhMFFGAKe7Q/4le1DSNHHweji2d7ulAv
         QVmeqBxf95W9g==
From:   Baruch Siach <baruch@tkos.co.il>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Robert Marko <robert.marko@sartura.hr>
Cc:     Baruch Siach <baruch.siach@siklu.com>,
        Bryan O'Donoghue <bryan.odonoghue@linaro.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 2/2] arm64: dts: qcom: ipq6018: Add mdio bus description
Date:   Mon, 21 Feb 2022 16:33:22 +0200
Message-Id: <5e7e06e0cb189bab4586646470894bbda572785d.1645454002.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <a4b1ad7b15c13f368b637efdb903da143b830a88.1645454002.git.baruch@tkos.co.il>
References: <a4b1ad7b15c13f368b637efdb903da143b830a88.1645454002.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baruch Siach <baruch.siach@siklu.com>

The IPQ60xx has the same MDIO bug block as IPQ4019. Add IO range and
clock resources description.

Signed-off-by: Baruch Siach <baruch.siach@siklu.com>
---
 arch/arm64/boot/dts/qcom/ipq6018.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/ipq6018.dtsi b/arch/arm64/boot/dts/qcom/ipq6018.dtsi
index 5eb7dc9cc231..093011d18ca6 100644
--- a/arch/arm64/boot/dts/qcom/ipq6018.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq6018.dtsi
@@ -635,6 +635,16 @@ qrtr_requests {
 			};
 		};
 
+		mdio: mdio@90000 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "qcom,ipq6018-mdio", "qcom,ipq4019-mdio";
+			reg = <0x0 0x90000 0x0 0x64>;
+			clocks = <&gcc GCC_MDIO_AHB_CLK>;
+			clock-names = "gcc_mdio_ahb_clk";
+			status = "disabled";
+		};
+
 		qusb_phy_1: qusb@59000 {
 			compatible = "qcom,ipq6018-qusb2-phy";
 			reg = <0x0 0x059000 0x0 0x180>;
-- 
2.34.1

