Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 872D63F1471
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 09:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236814AbhHSHkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 03:40:33 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:23400 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236756AbhHSHkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 03:40:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1629358795; x=1660894795;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DPvk51r+tNaQIX17IGj6lTpfR9i78AJ8Ij1ANlimbSQ=;
  b=ChNZXFKswj/X3XCFhHaFsBXls92YnnoLDbT+TodaouowMaOAhWiGhN6F
   1ZDpQmrekuUcvAPxdK+xmbVqc+Q/UdSsGLcnoqqlklIcoTzk6UjQ8ml+Q
   WnIx5Iu0SfdHAkVqUnvLG+/HOOZmdakd7Awbz5m7+rqSQKw2LlpGLJ+yr
   ViniU9bY/NGq8Sw/ofJBBRE34skYDsJ0iAP7IX3V2l2UPWzFdMXQjlk4Q
   afZ28XNbvQb/7XLgzpy06ei+CtXoQ4SGtrvx183ewRXrCSFIjBPjAcDSi
   ESBwHjJxbLvqOg366c0JJiS0akt05R+/xSE2Qw2/imSq5hfYQv8vf+/BP
   w==;
IronPort-SDR: ces0+IBP6z7YS69uhClnp1kN6Z23+ZJsBHrp1A9qOH/nXBDcjJ3FdP2gpKDRR07fUUMsAXvGZ6
 aVldLOslLgZpzWlXqT8LnaAAySC63PsAUhB09Nzm2HyL6qVLboz6arXfu84s7Bq3r6hG9YobwP
 k6v3pQlmE0x186Q7R0JfPiCV2RfgJWaejRr8X1A2FQ953+VGTAuoqf/OP4Gqb3ubdfqJOFsNh6
 yO6GSO9c2mpugP0OxnrzVj9locjVWGtan/ZWKySJBghyC2Q/1/zD+quqVyl5sBle+jt2QK1T/9
 QrvsrS96ADFK4olOyL46TacM
X-IronPort-AV: E=Sophos;i="5.84,334,1620716400"; 
   d="scan'208";a="133396229"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Aug 2021 00:39:54 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 19 Aug 2021 00:39:54 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 19 Aug 2021 00:39:52 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, "Rob Herring" <robh+dt@kernel.org>,
        <devicetree@vger.kernel.org>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH net-next v2 2/2] arm64: dts: sparx5: Add the Sparx5 switch frame DMA support
Date:   Thu, 19 Aug 2021 09:39:40 +0200
Message-ID: <20210819073940.1589383-3-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210819073940.1589383-1-steen.hegelund@microchip.com>
References: <20210819073940.1589383-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds the interrupt for the Sparx5 Frame DMA.

If this configuration is present the Sparx5 SwitchDev driver will use the
Frame DMA feature, and if not it will use register based injection and
extraction for sending and receiving frames to the CPU.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 arch/arm64/boot/dts/microchip/sparx5.dtsi | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/microchip/sparx5.dtsi b/arch/arm64/boot/dts/microchip/sparx5.dtsi
index ad07fff40544..787ebcec121d 100644
--- a/arch/arm64/boot/dts/microchip/sparx5.dtsi
+++ b/arch/arm64/boot/dts/microchip/sparx5.dtsi
@@ -471,8 +471,9 @@ switch: switch@0x600000000 {
 				<0x6 0x10004000 0x7fc000>,
 				<0x6 0x11010000 0xaf0000>;
 			reg-names = "cpu", "dev", "gcb";
-			interrupt-names = "xtr";
-			interrupts = <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "xtr", "fdma";
+			interrupts =	<GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>,
+					<GIC_SPI 25 IRQ_TYPE_LEVEL_HIGH>;
 			resets = <&reset 0>;
 			reset-names = "switch";
 		};
-- 
2.32.0

