Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 001D738B108
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 16:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243624AbhETOJA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 10:09:00 -0400
Received: from newton.telenet-ops.be ([195.130.132.45]:47542 "EHLO
        newton.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243636AbhETOH7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 10:07:59 -0400
X-Greylist: delayed 456 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 May 2021 10:07:59 EDT
Received: from baptiste.telenet-ops.be (baptiste.telenet-ops.be [IPv6:2a02:1800:120:4::f00:13])
        by newton.telenet-ops.be (Postfix) with ESMTPS id 4FmBDC4SFPzMr95K
        for <netdev@vger.kernel.org>; Thu, 20 May 2021 15:58:51 +0200 (CEST)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed20:9cc6:7165:bcc2:1e70])
        by baptiste.telenet-ops.be with bizsmtp
        id 71yi2500G31btb9011yiMP; Thu, 20 May 2021 15:58:51 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1ljjCE-007Wn4-3R; Thu, 20 May 2021 15:58:42 +0200
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1ljjCD-008zrh-In; Thu, 20 May 2021 15:58:41 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 3/5] ARM: dts: qcom-apq8060: Correct Ethernet node name and drop bogus irq property
Date:   Thu, 20 May 2021 15:58:37 +0200
Message-Id: <8abfe44e2ad77b6309866531ec662c5daf1e4dbf.1621518686.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1621518686.git.geert+renesas@glider.be>
References: <cover.1621518686.git.geert+renesas@glider.be>
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

