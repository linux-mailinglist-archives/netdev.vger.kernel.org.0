Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 466BA6661F2
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 18:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235437AbjAKRap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 12:30:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239662AbjAKR2r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 12:28:47 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C0D03D9F3
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 09:25:00 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id g23so1896389plq.12
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 09:25:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=edgeble-ai.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NByx23y/6WTDoeQQrsJysazVpw5VoP9tpFdnTA2g30g=;
        b=KKINuB57md1UtsZPCKcATf+egXFYsn+AioXnK8YTrnnhcF4rRNoV4hRgAe/xHVg4HB
         QkoujQ+l86IfIpIhwWxnzdSdAlRi8pcuqgNuPOH6Hg4FpC0KsI+GIQJacJRMpVLUnlm5
         AgGMuIOwoL7q+kfvUTXOFhDaxB3xS5R9ZAOoHzdUfZEunC6dNkiOem0H1Qk9kZ0sLZYi
         rBK071pbaLtE2lYDJEHXm0h4kqPicKP8YDud3534Y2TbfZUtsPb3qmcUtWDqGBeBpdO6
         Tu0qGps8XvNdLqyHjT9cWXBqD0QUt7fjMGGMneHd3l7X5YbVOwuLAGDjSmEJA7rI5+kD
         wtsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NByx23y/6WTDoeQQrsJysazVpw5VoP9tpFdnTA2g30g=;
        b=HIfFcJS0+Btpe2B73jzLW1nEJagEn6jlwpvo1l9d2JW+MmhCKkQsbaf250RxmFMKS+
         atdek5RJeZvzTSgFlBhJlwZw5ygF4GoEmzS2l84mhOI2WekYASwazd9Rlcn4lvpcov2d
         A2rm0kQpdnoldMkpNDrjrW1FSdZFK0IxyA2aNndq8Olvj15F8Urkt5ddb1hpel68g+Rn
         fD/bcCfsIWryC2bS/mfLlX7FdtvEbJ08mYbZVtSRLuRWy+aoosr5GnmDtKlnGvgoO8Mx
         2eYG7HH18lmiZcfDJh8KKG+rhJZYuZdMJVF2lNIv5NMNKH6TcKuwM7V95xyTGley+m0v
         g+hQ==
X-Gm-Message-State: AFqh2kpDabNYuJBbTkbOabViLhrBtW7RwRYSj0KBkBRqUR/OlpwXSs9v
        ZtoEWDyhQ42z9qm4079IgjowCLx6j8JshOIvWc4=
X-Google-Smtp-Source: AMrXdXs33kCf5RuQM2En+SqY72OhTdwdHD9V2SE7l3q/Ih0SILfsTXt+N4b+SgAUQBEppvrNGbWVig==
X-Received: by 2002:a17:90b:264d:b0:213:18f3:68d1 with SMTP id pa13-20020a17090b264d00b0021318f368d1mr74169906pjb.29.1673457900181;
        Wed, 11 Jan 2023 09:25:00 -0800 (PST)
Received: from archl-hc1b.. ([45.112.3.15])
        by smtp.gmail.com with ESMTPSA id rm14-20020a17090b3ece00b00218fa115f83sm11110722pjb.57.2023.01.11.09.24.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 09:24:59 -0800 (PST)
From:   Anand Moon <anand@edgeble.ai>
To:     Heiko Stuebner <heiko@sntech.de>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Johan Jonker <jbx6244@gmail.com>, Anand Moon <anand@edgeble.ai>,
        Jagan Teki <jagan@edgeble.ai>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v5 linux-next 3/4] ARM: dts: Add Ethernet GMAC node for RV1126 SoC
Date:   Wed, 11 Jan 2023 17:24:33 +0000
Message-Id: <20230111172437.5295-3-anand@edgeble.ai>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230111172437.5295-1-anand@edgeble.ai>
References: <20230111172437.5295-1-anand@edgeble.ai>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rockchip RV1126 has GMAC 10/100/1000M ethernet controller

Co-Developed-by: Jagan Teki <jagan@edgeble.ai>
Signed-off-by: Anand Moon <anand@edgeble.ai>
Signed-off-by: Jagan Teki <jagan@edgeble.ai>
---
v5: Fix the $subject and add CoD of Jagan
v4: sort the node as reg adds. update the commit message.
v3: drop the gmac_clkin_m0 & gmac_clkin_m1 fix clock node which are not
    used, Add SoB of Jagan Teki.
v2: drop SoB of Jagan Teki.
---
 arch/arm/boot/dts/rv1126.dtsi | 49 +++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/arch/arm/boot/dts/rv1126.dtsi b/arch/arm/boot/dts/rv1126.dtsi
index 1cb43147e90b..1f07d0a4fa73 100644
--- a/arch/arm/boot/dts/rv1126.dtsi
+++ b/arch/arm/boot/dts/rv1126.dtsi
@@ -332,6 +332,55 @@ timer0: timer@ff660000 {
 		clock-names = "pclk", "timer";
 	};
 
+	gmac: ethernet@ffc40000 {
+		compatible = "rockchip,rv1126-gmac", "snps,dwmac-4.20a";
+		reg = <0xffc40000 0x4000>;
+		interrupts = <GIC_SPI 95 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 96 IRQ_TYPE_LEVEL_HIGH>;
+		interrupt-names = "macirq", "eth_wake_irq";
+		rockchip,grf = <&grf>;
+		clocks = <&cru CLK_GMAC_SRC>, <&cru CLK_GMAC_TX_RX>,
+			 <&cru CLK_GMAC_TX_RX>, <&cru CLK_GMAC_REF>,
+			 <&cru ACLK_GMAC>, <&cru PCLK_GMAC>,
+			 <&cru CLK_GMAC_TX_RX>, <&cru CLK_GMAC_PTPREF>;
+		clock-names = "stmmaceth", "mac_clk_rx",
+			      "mac_clk_tx", "clk_mac_ref",
+			      "aclk_mac", "pclk_mac",
+			      "clk_mac_speed", "ptp_ref";
+		resets = <&cru SRST_GMAC_A>;
+		reset-names = "stmmaceth";
+
+		snps,mixed-burst;
+		snps,tso;
+
+		snps,axi-config = <&stmmac_axi_setup>;
+		snps,mtl-rx-config = <&mtl_rx_setup>;
+		snps,mtl-tx-config = <&mtl_tx_setup>;
+		status = "disabled";
+
+		mdio: mdio {
+			compatible = "snps,dwmac-mdio";
+			#address-cells = <0x1>;
+			#size-cells = <0x0>;
+		};
+
+		stmmac_axi_setup: stmmac-axi-config {
+			snps,wr_osr_lmt = <4>;
+			snps,rd_osr_lmt = <8>;
+			snps,blen = <0 0 0 0 16 8 4>;
+		};
+
+		mtl_rx_setup: rx-queues-config {
+			snps,rx-queues-to-use = <1>;
+			queue0 {};
+		};
+
+		mtl_tx_setup: tx-queues-config {
+			snps,tx-queues-to-use = <1>;
+			queue0 {};
+		};
+	};
+
 	emmc: mmc@ffc50000 {
 		compatible = "rockchip,rv1126-dw-mshc", "rockchip,rk3288-dw-mshc";
 		reg = <0xffc50000 0x4000>;
-- 
2.39.0

