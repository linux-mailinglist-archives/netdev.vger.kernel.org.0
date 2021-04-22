Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC772368623
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 19:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238643AbhDVRjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 13:39:39 -0400
Received: from mx.socionext.com ([202.248.49.38]:19511 "EHLO mx.socionext.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238586AbhDVRjg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 13:39:36 -0400
Received: from unknown (HELO iyokan2-ex.css.socionext.com) ([172.31.9.54])
  by mx.socionext.com with ESMTP; 23 Apr 2021 02:31:52 +0900
Received: from mail.mfilter.local (m-filter-2 [10.213.24.62])
        by iyokan2-ex.css.socionext.com (Postfix) with ESMTP id 08F5A205902A;
        Fri, 23 Apr 2021 02:31:52 +0900 (JST)
Received: from 172.31.9.51 (172.31.9.51) by m-FILTER with ESMTP; Fri, 23 Apr 2021 02:31:51 +0900
Received: from plum.e01.socionext.com (unknown [10.213.132.32])
        by kinkan2.css.socionext.com (Postfix) with ESMTP id 825CAB1D40;
        Fri, 23 Apr 2021 02:31:51 +0900 (JST)
From:   Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
To:     Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Masami Hiramatsu <masami.hiramatsu@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Subject: [PATCH net v2 1/2] ARM: dts: uniphier: Change phy-mode to RGMII-ID to enable delay pins for RTL8211E
Date:   Fri, 23 Apr 2021 02:31:48 +0900
Message-Id: <1619112709-13234-2-git-send-email-hayashi.kunihiko@socionext.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1619112709-13234-1-git-send-email-hayashi.kunihiko@socionext.com>
References: <1619112709-13234-1-git-send-email-hayashi.kunihiko@socionext.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

UniPhier PXs2 boards have RTL8211E ethernet phy, and the phy have the RX/TX
delays of RGMII interface using pull-ups on the RXDLY and TXDLY pins.

After the commit bbc4d71d6354 ("net: phy: realtek: fix rtl8211e rx/tx
delay config"), the delays are working correctly, however, "rgmii" means
no delay and the phy doesn't work. So need to set the phy-mode to
"rgmii-id" to show that RX/TX delays are enabled.

Fixes: e3cc931921d2 ("ARM: dts: uniphier: add AVE ethernet node")
Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
---
 arch/arm/boot/dts/uniphier-pxs2.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/uniphier-pxs2.dtsi b/arch/arm/boot/dts/uniphier-pxs2.dtsi
index 4d9f69a..5ba831e 100644
--- a/arch/arm/boot/dts/uniphier-pxs2.dtsi
+++ b/arch/arm/boot/dts/uniphier-pxs2.dtsi
@@ -583,7 +583,7 @@
 			clocks = <&sys_clk 6>;
 			reset-names = "ether";
 			resets = <&sys_rst 6>;
-			phy-mode = "rgmii";
+			phy-mode = "rgmii-id";
 			local-mac-address = [00 00 00 00 00 00];
 			socionext,syscon-phy-mode = <&soc_glue 0>;
 
-- 
2.7.4

