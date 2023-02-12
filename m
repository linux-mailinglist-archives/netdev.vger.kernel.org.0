Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E06969372B
	for <lists+netdev@lfdr.de>; Sun, 12 Feb 2023 13:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbjBLMQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 07:16:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjBLMQf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 07:16:35 -0500
Received: from soltyk.jannau.net (soltyk.jannau.net [144.76.91.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84F9511673;
        Sun, 12 Feb 2023 04:16:34 -0800 (PST)
Received: from robin.home.jannau.net (p579ad32f.dip0.t-ipconnect.de [87.154.211.47])
        by soltyk.jannau.net (Postfix) with ESMTPSA id 29E4F26F76F;
        Sun, 12 Feb 2023 13:16:33 +0100 (CET)
From:   Janne Grunau <j@jannau.net>
Date:   Sun, 12 Feb 2023 13:16:32 +0100
Subject: [PATCH v2 4/4] nios2: dts: Fix tse_mac "max-frame-size" property
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230203-dt-bindings-network-class-v2-4-499686795073@jannau.net>
References: <20230203-dt-bindings-network-class-v2-0-499686795073@jannau.net>
In-Reply-To: <20230203-dt-bindings-network-class-v2-0-499686795073@jannau.net>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Mailing List <devicetree-spec@vger.kernel.org>,
        Kalle Valo <kvalo@kernel.org>, van Spriel <arend@broadcom.com>,
        =?utf-8?q?J=C3=A9r=C3=B4me_Pouiller?= <jerome.pouiller@silabs.com>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Ley Foon Tan <lftan@altera.com>,
        Chee Nouk Phoon <cnphoon@altera.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        Janne Grunau <j@jannau.net>
X-Mailer: b4 0.12.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1609; i=j@jannau.net;
 h=from:subject:message-id; bh=uWSEYKB7li7fZFeyFFAr5iOwvcAG0u54TSff/HhFETY=;
 b=owGbwMvMwCG2UNrmdq9+ahrjabUkhuQXN+ZNYed9b6O9jTP29ZQXij7nE82O7uadl5nw7cQ57
 6aoNY7qHaUsDGIcDLJiiixJ2i87GFbXKMbUPgiDmcPKBDKEgYtTACZy/C3DP4WASfu19at0E0sY
 FS2si9Vmb8+Q+GdmqLm8rEWK9XeSPMP/qgXTfRV6i368/r3zYfGxBxt44lbc0BFtMNL+zn3Q1j+
 VGQA=
X-Developer-Key: i=j@jannau.net; a=openpgp;
 fpr=8B336A6BE4E5695E89B8532B81E806F586338419
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The given value of 1518 seems to refer to the layer 2 ethernet frame
size without 802.1Q tag. Actual use of the "max-frame-size" including in
the consumer of the "altr,tse-1.0" compatible is the MTU.

Fixes: 95acd4c7b69c ("nios2: Device tree support")
Fixes: 61c610ec61bb ("nios2: Add Max10 device tree")
Signed-off-by: Janne Grunau <j@jannau.net>
---
 arch/nios2/boot/dts/10m50_devboard.dts | 2 +-
 arch/nios2/boot/dts/3c120_devboard.dts | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/nios2/boot/dts/10m50_devboard.dts b/arch/nios2/boot/dts/10m50_devboard.dts
index 56339bef3247..0e7e5b0dd685 100644
--- a/arch/nios2/boot/dts/10m50_devboard.dts
+++ b/arch/nios2/boot/dts/10m50_devboard.dts
@@ -97,7 +97,7 @@ rgmii_0_eth_tse_0: ethernet@400 {
 			rx-fifo-depth = <8192>;
 			tx-fifo-depth = <8192>;
 			address-bits = <48>;
-			max-frame-size = <1518>;
+			max-frame-size = <1500>;
 			local-mac-address = [00 00 00 00 00 00];
 			altr,has-supplementary-unicast;
 			altr,enable-sup-addr = <1>;
diff --git a/arch/nios2/boot/dts/3c120_devboard.dts b/arch/nios2/boot/dts/3c120_devboard.dts
index d10fb81686c7..3ee316906379 100644
--- a/arch/nios2/boot/dts/3c120_devboard.dts
+++ b/arch/nios2/boot/dts/3c120_devboard.dts
@@ -106,7 +106,7 @@ tse_mac: ethernet@4000 {
 				interrupt-names = "rx_irq", "tx_irq";
 				rx-fifo-depth = <8192>;
 				tx-fifo-depth = <8192>;
-				max-frame-size = <1518>;
+				max-frame-size = <1500>;
 				local-mac-address = [ 00 00 00 00 00 00 ];
 				phy-mode = "rgmii-id";
 				phy-handle = <&phy0>;

-- 
2.39.1

