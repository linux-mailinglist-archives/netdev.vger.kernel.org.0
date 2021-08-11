Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB56D3E8B5D
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 10:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236035AbhHKIAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 04:00:32 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:36821 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235974AbhHKH7s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 03:59:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1628668765; x=1660204765;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=doHf05BSxz8JLwdETceKQtVg12HvxaXyUfWGoXfYgEA=;
  b=vPsfUtoHt+jYwod7AT9nICRIdARVNah9pkaDZd4qipgcHbeQuZxeetRR
   ZMEfv1/lI3QEoQEy1tJ78OMmC2dVxtjhXpwlLA07//eZjnhgWQT4N1uYb
   72cOcsxsFsI58k+9pBM8C4ZHhEGCWjWCY1/WYjW2u9vHvIVYbiQ2zB56O
   45aM5sflBtmwGHF7+GHBoN8/s2LiA+ZNQ4U7yqjxLeFhehYF6BBo2R1RF
   d2griXzTk8xzuRTQlscSUaXaBeDa3gYo9E090zYSCaER72jWGYIB9E/wB
   fXedlF/sjLxZdhFehKbw/ooGmfE7R+QH3eCtnlUdZ28Bd8Z3QGtTIQand
   g==;
IronPort-SDR: 8v/81hvEQo/ok5ajM0wlH2A4qZDYrYFK5jTt0Y+kgJsqhmzf9u2wKCrrAfIsnqNsAAPuk4HvQt
 8v/QyY5dWz8vvau4CTzR3wzh8N6TgnsCe6Dz6NY0L1nzqyTVY7RkRRg+ONVxDb4vnfu41afrYn
 zoslRWpMD7hGmRz1h81FShsQDGHqYJ22/enw4NOmMQoEVtl4B3Um8aDQYDU7HU83slIuss2XbE
 MVvk+UKvw5NSwnT7dEolv0I+MBbHA5D34/z67e4Wjkn6gtjMfbmp0M54/PTU8ZVhbo62A005NC
 R7tI9RxYXU3nW6YZqgajyPdW
X-IronPort-AV: E=Sophos;i="5.84,311,1620716400"; 
   d="scan'208";a="132373660"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Aug 2021 00:59:20 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 11 Aug 2021 00:59:20 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Wed, 11 Aug 2021 00:59:18 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, "Rob Herring" <robh+dt@kernel.org>,
        <devicetree@vger.kernel.org>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH net-next 2/2] arm64: dts: sparx5: Add the Sparx5 switch frame DMA support
Date:   Wed, 11 Aug 2021 09:59:09 +0200
Message-ID: <20210811075909.543633-3-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210811075909.543633-1-steen.hegelund@microchip.com>
References: <20210811075909.543633-1-steen.hegelund@microchip.com>
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

