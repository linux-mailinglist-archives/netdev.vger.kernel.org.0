Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D18826C0FAB
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 11:52:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbjCTKwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 06:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbjCTKvg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 06:51:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DA4E22CB4;
        Mon, 20 Mar 2023 03:49:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6BFCB80E11;
        Mon, 20 Mar 2023 10:48:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A262C433D2;
        Mon, 20 Mar 2023 10:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679309288;
        bh=b6zSPC09M9ZFRFcNsTQuVCwj8XUEUaZcN2PuExL6Ogc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TNgKIwiA7uJYk6mLX54BKkXEKUbGOUt/FrJHJwmbmbzCvazeQYyqRChwp4ajdUK4N
         1d2lpGBZXb8FViDYJ2T8XpqeJKSd1Dtz7uXC0DatdQLLP11tx30DZ4y2yJGjS9Mz0D
         KeLQpprQT42HNtyGC2ma1YNwLiiakJjSL8lGHUgANsXD40hEfv6GKVHmPzF117K65l
         fNbxK6o6vejnoszhYnjhRCnL76E11Xq76WaFkYXUqsZFtP79GfAr/pmZjuwNIWL6XQ
         q0UIhdyzpYchQxNjnuN+WN2lV0O+FMDfp24OE/kefdj9AURDnfS7NFwSZE6TdxIdXa
         78QY17ZtzZn+A==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1peD4z-0005nX-5D; Mon, 20 Mar 2023 11:49:29 +0100
From:   Johan Hovold <johan+linaro@kernel.org>
To:     Kalle Valo <kvalo@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>
Subject: [PATCH 2/3] arm64: dts: qcom: sc8280xp-x13s: add wifi calibration variant
Date:   Mon, 20 Mar 2023 11:46:57 +0100
Message-Id: <20230320104658.22186-3-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230320104658.22186-1-johan+linaro@kernel.org>
References: <20230320104658.22186-1-johan+linaro@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Describe the bus topology for PCIe domain 6 and add the ath11k
calibration variant so that the board file (calibration data) can be
loaded.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216246
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 .../dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts  | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts b/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
index 150f51f1db37..0051025e0aa8 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
+++ b/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
@@ -711,6 +711,23 @@ &pcie4 {
 	pinctrl-0 = <&pcie4_default>;
 
 	status = "okay";
+
+	pcie@0 {
+		device_type = "pci";
+		reg = <0x0 0x0 0x0 0x0 0x0>;
+		#address-cells = <3>;
+		#size-cells = <2>;
+		ranges;
+
+		bus-range = <0x01 0xff>;
+
+		wifi@0 {
+			compatible = "pci17cb,1103";
+			reg = <0x10000 0x0 0x0 0x0 0x0>;
+
+			qcom,ath11k-calibration-variant = "LE_X13S";
+		};
+	};
 };
 
 &pcie4_phy {
-- 
2.39.2

