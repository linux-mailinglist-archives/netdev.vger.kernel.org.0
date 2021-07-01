Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99DD13B9177
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 14:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236392AbhGAME7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 08:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236387AbhGAME5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 08:04:57 -0400
Received: from laurent.telenet-ops.be (laurent.telenet-ops.be [IPv6:2a02:1800:110:4::f00:19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF2CBC061756
        for <netdev@vger.kernel.org>; Thu,  1 Jul 2021 05:02:26 -0700 (PDT)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed20:445e:1c3:be41:9e10])
        by laurent.telenet-ops.be with bizsmtp
        id Po2P2500c474TTe01o2Pjc; Thu, 01 Jul 2021 14:02:25 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1lyvOh-005MHT-9J; Thu, 01 Jul 2021 14:02:23 +0200
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1lyvOg-00EXSE-LT; Thu, 01 Jul 2021 14:02:22 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH v2 1/2] ARM: dts: qcom-apq8060: Correct Ethernet node name and drop bogus irq property
Date:   Thu,  1 Jul 2021 14:02:20 +0200
Message-Id: <d58c8323c3d544f91f7e4585a5b163bc374397d1.1625140615.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625140615.git.geert+renesas@glider.be>
References: <cover.1625140615.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

make dtbs_check:

    ethernet-ebi2@2,0: $nodename:0: 'ethernet-ebi2@2,0' does not match '^ethernet(@.*)?$'
    ethernet-ebi2@2,0: 'smsc,irq-active-low' does not match any of the regexes: 'pinctrl-[0-9]+'

There is no "smsc,irq-active-low" property, as active low is the
default.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
---
v2:
  - Add Reviewed-by.
---
 arch/arm/boot/dts/qcom-apq8060-dragonboard.dts | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/qcom-apq8060-dragonboard.dts b/arch/arm/boot/dts/qcom-apq8060-dragonboard.dts
index dace8ffeb99118cb..0a4ffd10c48464f5 100644
--- a/arch/arm/boot/dts/qcom-apq8060-dragonboard.dts
+++ b/arch/arm/boot/dts/qcom-apq8060-dragonboard.dts
@@ -581,7 +581,7 @@ external-bus@1a100000 {
 			 * EBI2. This has a 25MHz chrystal next to it, so no
 			 * clocking is needed.
 			 */
-			ethernet-ebi2@2,0 {
+			ethernet@2,0 {
 				compatible = "smsc,lan9221", "smsc,lan9115";
 				reg = <2 0x0 0x100>;
 				/*
@@ -598,8 +598,6 @@ ethernet-ebi2@2,0 {
 				phy-mode = "mii";
 				reg-io-width = <2>;
 				smsc,force-external-phy;
-				/* IRQ on edge falling = active low */
-				smsc,irq-active-low;
 				smsc,irq-push-pull;
 
 				/*
-- 
2.25.1

