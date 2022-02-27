Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA3A4C5A08
	for <lists+netdev@lfdr.de>; Sun, 27 Feb 2022 09:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbiB0ITq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Feb 2022 03:19:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbiB0ITo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Feb 2022 03:19:44 -0500
Received: from mx.tkos.co.il (guitar.tcltek.co.il [84.110.109.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F7ED3B3DE;
        Sun, 27 Feb 2022 00:19:07 -0800 (PST)
Received: from tarshish.tkos.co.il (unknown [10.0.8.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id 4CF1E440EB0;
        Sun, 27 Feb 2022 10:18:26 +0200 (IST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tkos.co.il;
        s=default; t=1645949906;
        bh=Rvsj67ju5R/3APhA2dEbgrJBQsct718LIa5iTVH/eGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cl4VKk2Z83u2jnSgkyF9tsSrC9k+ltPOGl1mcROamAh+xI/7WoxMsZY+q6runn+rB
         +rwy2GI4KebnmvLXHoD710z/gAhLsiOUqA80pfzpv79HDxd6b1nxuP3cb1oe/FemIL
         yMzDX9vPo3fbzyWhY2j9oOKjAqdCS0E9ixaGpQ/Ps6kw4ayYL1k/scz/PVpIcfcM/l
         FHFTjBGwIn0sBUXk8h5YyEvZI7ujkHvv0B05saZZ1mQhK/EuMJP4S20j+AgmkqeWpe
         yEBs04tOU8UBk697n+343na4BwQg04FZhdZNs7X5/kLLkFxrVuJ2mX/KuobzGHUnW8
         ZMxFlb/QPCgEg==
From:   Baruch Siach <baruch@tkos.co.il>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Robert Marko <robert.marko@sartura.hr>
Cc:     Baruch Siach <baruch.siach@siklu.com>,
        Bryan O'Donoghue <bryan.odonoghue@linaro.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH v2 2/2] arm64: dts: qcom: ipq6018: Add mdio bus description
Date:   Sun, 27 Feb 2022 10:18:34 +0200
Message-Id: <4c4f1540f8f99c07a63a484b11e9880bbf3acdc4.1645949914.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <e96e06d3228d9bbd927da32379ba78d5b4b718a7.1645949914.git.baruch@tkos.co.il>
References: <e96e06d3228d9bbd927da32379ba78d5b4b718a7.1645949914.git.baruch@tkos.co.il>
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

Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Baruch Siach <baruch.siach@siklu.com>
---

v2:

   Add review tag from Bryan O'Donoghue
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

