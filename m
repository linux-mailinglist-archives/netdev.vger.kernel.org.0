Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD061BE858
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 22:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbgD2URf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 16:17:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727827AbgD2UR1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 16:17:27 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AF7BC03C1AE;
        Wed, 29 Apr 2020 13:17:26 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id b11so4113938wrs.6;
        Wed, 29 Apr 2020 13:17:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0knvu8zyqVx4y2NkIr8lOmrEgshGQH0lpKJi3cjk2SI=;
        b=QveB36T9cQfiMiI9HNOdZ7yQwlct6qNuNxJikrgRPBAt+IVOZQpzYY64/wICgNjMEE
         hGkVzt4CRM/9icHJ7hoBYLj/RfsYzQr5i9OTVlJc328Utkbe6rku9I2AZD33/SCOwxdd
         LvBWWSfiFVZszv6UUklwzPO0/bCoZ+IboL/FMLCIRy8ZBki4UlQWoszUwRM5B2qDj2jm
         GD/sfTOz9Xz0ZYrdPkCpPJAsR2YJHJpdfSlWFV77DeMeuV4Si8xVTszKN9Ibf+rfxVkB
         azePNdVax5XNLpUgEktsaqVBqJBI/lsZNEq7ARgbx9DCrbLcPxpuO+wxQpjrpSq6570r
         EwSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0knvu8zyqVx4y2NkIr8lOmrEgshGQH0lpKJi3cjk2SI=;
        b=blpui7O3xV0YI9xVWTDf0DD6XvcrZl7doRHUWUz5ZAc1c8FUQPU12efHs2dXNrv16V
         HQyQ1s8862wSogyQ7aKl3qXWwKfwfyFsRLrjuo/awX1FeFrDPZ3BeUETJxDLMRmNEB5l
         zyrgx7Woko4Xbfwil3EFqZ6blmVjk1I9y73CeTgEHGadUwcnCfKoKX+TNAcAqUcnoTOM
         gH93G5UZ8VDxLhhEbeiituCbyP3ck7qiXHl19hiEbvOJwO9VLI3SLpgpYIB9htdVnI9H
         DPZjFJxWK9k0P/LjUXA4lDsqqC43oop+cU5hIwSkPG+ebGqzR0pK4MIAaE2IqV2bvdCY
         3IZA==
X-Gm-Message-State: AGi0PuYdmlAWod4F4ElRLyyAD556V8GhdIW/r9uFYTqEvOdMgSorp0tw
        Y+OWnNhWsw3cVDItNyE4xa4=
X-Google-Smtp-Source: APiQypI7/tFm351D0aZQ+OFBTov0tzQC4j8sVuoaGKjl8wXkEwEwydb01p0/bZVora7GdZbF0ZPmWA==
X-Received: by 2002:adf:fe44:: with SMTP id m4mr43579867wrs.188.1588191444705;
        Wed, 29 Apr 2020 13:17:24 -0700 (PDT)
Received: from localhost.localdomain (p200300F137142E00428D5CFFFEB99DB8.dip0.t-ipconnect.de. [2003:f1:3714:2e00:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id q143sm9923623wme.31.2020.04.29.13.17.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 13:17:24 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     robh+dt@kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org
Cc:     jianxin.pan@amlogic.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH DO NOT MERGE v2 11/11] ARM: dts: meson: Switch existing boards with RGMII PHY to "rgmii-id"
Date:   Wed, 29 Apr 2020 22:16:44 +0200
Message-Id: <20200429201644.1144546-12-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200429201644.1144546-1-martin.blumenstingl@googlemail.com>
References: <20200429201644.1144546-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let the PHY generate the RX and TX delay on the Odroid-C1 and MXIII
Plus.

Previously we did not know that these boards used an RX delay. We
assumed that setting the TX delay on the MAC side It turns out that
these boards also require an RX delay of 2ns (verified on Odroid-C1,
but the u-boot code uses the same setup on both boards). Ethernet only
worked because u-boot added this RX delay on the MAC side.

The 4ns TX delay was also wrong and the result of using an unsupported
RGMII TX clock divider setting. This has been fixed in the driver with
commit bd6f48546b9cb7 ("net: stmmac: dwmac-meson8b: Fix the RGMII TX
delay on Meson8b/8m2 SoCs").

Switch to phy-mode "rgmii-id" to let the PHY side handle all the delays,
(as recommended by the Ethernet maintainers anyways) to correctly
describe the need for a 2ns RX as well as 2ns TX delay on these boards.
This fixes the Ethernet performance on Odroid-C1 where there was a huge
amount of packet loss when transmitting data due to the incorrect TX
delay.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 arch/arm/boot/dts/meson8b-odroidc1.dts    | 3 +--
 arch/arm/boot/dts/meson8m2-mxiii-plus.dts | 4 +---
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/arm/boot/dts/meson8b-odroidc1.dts b/arch/arm/boot/dts/meson8b-odroidc1.dts
index a2a47804fc4a..cb21ac9f517c 100644
--- a/arch/arm/boot/dts/meson8b-odroidc1.dts
+++ b/arch/arm/boot/dts/meson8b-odroidc1.dts
@@ -202,9 +202,8 @@ &ethmac {
 	pinctrl-0 = <&eth_rgmii_pins>;
 	pinctrl-names = "default";
 
-	phy-mode = "rgmii";
 	phy-handle = <&eth_phy>;
-	amlogic,tx-delay-ns = <4>;
+	phy-mode = "rgmii-id";
 
 	nvmem-cells = <&ethernet_mac_address>;
 	nvmem-cell-names = "mac-address";
diff --git a/arch/arm/boot/dts/meson8m2-mxiii-plus.dts b/arch/arm/boot/dts/meson8m2-mxiii-plus.dts
index d54477b1001c..cc498191ddd1 100644
--- a/arch/arm/boot/dts/meson8m2-mxiii-plus.dts
+++ b/arch/arm/boot/dts/meson8m2-mxiii-plus.dts
@@ -69,9 +69,7 @@ &ethmac {
 	pinctrl-names = "default";
 
 	phy-handle = <&eth_phy0>;
-	phy-mode = "rgmii";
-
-	amlogic,tx-delay-ns = <4>;
+	phy-mode = "rgmii-id";
 
 	mdio {
 		compatible = "snps,dwmac-mdio";
-- 
2.26.2

