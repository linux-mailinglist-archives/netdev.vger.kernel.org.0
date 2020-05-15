Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 736F01D53BF
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 17:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728314AbgEOPKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 11:10:47 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:7888 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728273AbgEOPKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 11:10:39 -0400
X-IronPort-AV: E=Sophos;i="5.73,395,1583161200"; 
   d="scan'208";a="47188452"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 16 May 2020 00:10:38 +0900
Received: from localhost.localdomain (unknown [10.226.36.204])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 399CE400D4CD;
        Sat, 16 May 2020 00:10:34 +0900 (JST)
From:   Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Jens Axboe <axboe@kernel.dk>, Rob Herring <robh+dt@kernel.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S. Miller" <davem@davemloft.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>
Cc:     linux-ide@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-mmc@vger.kernel.org, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH 15/17] ARM: dts: r8a7742: Add APMU nodes
Date:   Fri, 15 May 2020 16:08:55 +0100
Message-Id: <1589555337-5498-16-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1589555337-5498-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <1589555337-5498-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add DT nodes for the Advanced Power Management Units (APMU), and use the
enable-method to point out that the APMU should be used for SMP support.

Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>
---
 arch/arm/boot/dts/r8a7742.dtsi | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm/boot/dts/r8a7742.dtsi b/arch/arm/boot/dts/r8a7742.dtsi
index 1fe65f7..da75767 100644
--- a/arch/arm/boot/dts/r8a7742.dtsi
+++ b/arch/arm/boot/dts/r8a7742.dtsi
@@ -18,6 +18,7 @@
 	cpus {
 		#address-cells = <1>;
 		#size-cells = <0>;
+		enable-method = "renesas,apmu";
 
 		cpu0: cpu@0 {
 			device_type = "cpu";
@@ -305,6 +306,18 @@
 			#reset-cells = <1>;
 		};
 
+		apmu@e6151000 {
+			compatible = "renesas,r8a7742-apmu", "renesas,apmu";
+			reg = <0 0xe6151000 0 0x188>;
+			cpus = <&cpu4 &cpu5 &cpu6 &cpu7>;
+		};
+
+		apmu@e6152000 {
+			compatible = "renesas,r8a7742-apmu", "renesas,apmu";
+			reg = <0 0xe6152000 0 0x188>;
+			cpus = <&cpu0 &cpu1 &cpu2 &cpu3>;
+		};
+
 		rst: reset-controller@e6160000 {
 			compatible = "renesas,r8a7742-rst";
 			reg = <0 0xe6160000 0 0x0100>;
-- 
2.7.4

