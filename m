Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5CDC34924C
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 13:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbhCYMnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 08:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230475AbhCYMmt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 08:42:49 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83DC2C06174A;
        Thu, 25 Mar 2021 05:42:49 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id f10so1645950pgl.9;
        Thu, 25 Mar 2021 05:42:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3ltQuHjZ2Dx4rM2etKJdZXBIVzAy3G8OeRSAF5zKHFQ=;
        b=cYD37tfOFxTIQc8pJCixMPHtDMuFqTAvYYbzQ7/LVeS3NqXIBN4+xS/LGlRm5sSokt
         pW3f1J73gTaXNYEFV0e4sbX5AEGWIg89n2MpFW3JynzDsTKZFA+gT2mg7YSb5fY46tfm
         z8dSWDw9aB+nrgQSzzDiH34Yqmc624BJKqWoKuLjsR3YTbT4kZ6zok8Vqh1um2uno5Xf
         yIqBnAMof7CatTLO/aU4Oz+DVIPLWb6EW2U25VjdOxmsMUKFdiCWRCKT814oV/NUCh66
         +G5AMqcU8Mpo3PjFqzZR7AYMrLPRx0irq+Otmq53hdrj2lvwzcKE2ZkC2hho1A2/Rhr3
         ThZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3ltQuHjZ2Dx4rM2etKJdZXBIVzAy3G8OeRSAF5zKHFQ=;
        b=gbTRSzVrITIa/yeXd6LwW2PGt+o4ABcCiPPX5SKmy7pz5mpqHELoCTfxDabczoFagx
         XJCMflwohMxmBhWJRd/MRXTLZtbJQxeDEm1GTBKIK+WvJnBhAk7HSNqceWIDqG7kMhSi
         VpQc+AWIFcI9LZouX8czVls1o4aaoXoxAJFXOetLUVEE9E7T6SAJw+Ly5OTdv8WYU1oH
         Q1fhTglDO+/rLzC6wraJSMabKxnCay51jJIFYIbMo0Is6YC/wjxEVVoZE8ogqOW4z7Nj
         uHb0qhUouyv2JabYcV9pmdLj2PCum3JyrYZ88tKH0suxrpTDSMti2+lIlBmpKuTBGUxb
         KU4g==
X-Gm-Message-State: AOAM533xFJZI388/N3+kN0OwygBP0ivNlptcW972bRGHD622qDizs1o+
        uf/FeeE5Aq48yt0uLmnVEkPAakJ1v29Rug==
X-Google-Smtp-Source: ABdhPJx9Tv1NUnOleZSOzJFANweJXp9b3HT9f3ckzmcerGk/AvLG0xmMKAxIrI79ze9FvHFKQOfXgQ==
X-Received: by 2002:a17:902:bf92:b029:e6:bc0:25ac with SMTP id v18-20020a170902bf92b02900e60bc025acmr9622503pls.49.1616676168868;
        Thu, 25 Mar 2021 05:42:48 -0700 (PDT)
Received: from archl-c2lm.. ([103.51.72.9])
        by smtp.gmail.com with ESMTPSA id t17sm6125917pgk.25.2021.03.25.05.42.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 05:42:48 -0700 (PDT)
From:   Anand Moon <linux.amoon@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Anand Moon <linux.amoon@gmail.com>,
        linux-amlogic@lists.infradead.org
Subject: [PATCHv1 2/6] arm: dts: meson: Add missing ethernet phy mdio compatible string
Date:   Thu, 25 Mar 2021 12:42:21 +0000
Message-Id: <20210325124225.2760-3-linux.amoon@gmail.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210325124225.2760-1-linux.amoon@gmail.com>
References: <20210325124225.2760-1-linux.amoon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing ethernet phy mdio comatible string to help
initiate the phy on Amlogic SoC SBC.

Cc: Neil Armstrong <narmstrong@baylibre.com>
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Anand Moon <linux.amoon@gmail.com>
---
 arch/arm/boot/dts/meson8b-ec100.dts       | 1 +
 arch/arm/boot/dts/meson8b-mxq.dts         | 1 +
 arch/arm/boot/dts/meson8b-odroidc1.dts    | 1 +
 arch/arm/boot/dts/meson8m2-mxiii-plus.dts | 1 +
 4 files changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/meson8b-ec100.dts b/arch/arm/boot/dts/meson8b-ec100.dts
index 8e48ccc6b634..09ce822308de 100644
--- a/arch/arm/boot/dts/meson8b-ec100.dts
+++ b/arch/arm/boot/dts/meson8b-ec100.dts
@@ -262,6 +262,7 @@ mdio {
 
 		eth_phy0: ethernet-phy@0 {
 			/* IC Plus IP101A/G (0x02430c54) */
+			compatible = "ethernet-phy-ieee802.3-c22";
 			reg = <0>;
 
 			reset-assert-us = <10000>;
diff --git a/arch/arm/boot/dts/meson8b-mxq.dts b/arch/arm/boot/dts/meson8b-mxq.dts
index f3937d55472d..c1638f3c9edf 100644
--- a/arch/arm/boot/dts/meson8b-mxq.dts
+++ b/arch/arm/boot/dts/meson8b-mxq.dts
@@ -109,6 +109,7 @@ mdio {
 
 		eth_phy0: ethernet-phy@0 {
 			/* IC Plus IP101A/G (0x02430c54) */
+			compatible = "ethernet-phy-ieee802.3-c22";
 			reg = <0>;
 
 			reset-assert-us = <10000>;
diff --git a/arch/arm/boot/dts/meson8b-odroidc1.dts b/arch/arm/boot/dts/meson8b-odroidc1.dts
index c440ef94e082..ca439302c74d 100644
--- a/arch/arm/boot/dts/meson8b-odroidc1.dts
+++ b/arch/arm/boot/dts/meson8b-odroidc1.dts
@@ -216,6 +216,7 @@ mdio {
 
 		/* Realtek RTL8211F (0x001cc916) */
 		eth_phy: ethernet-phy@0 {
+			compatible = "ethernet-phy-ieee802.3-c22";
 			reg = <0>;
 
 			reset-assert-us = <10000>;
diff --git a/arch/arm/boot/dts/meson8m2-mxiii-plus.dts b/arch/arm/boot/dts/meson8m2-mxiii-plus.dts
index fa6d55f1cfb9..6c9b22605264 100644
--- a/arch/arm/boot/dts/meson8m2-mxiii-plus.dts
+++ b/arch/arm/boot/dts/meson8m2-mxiii-plus.dts
@@ -73,6 +73,7 @@ mdio {
 
 		eth_phy0: ethernet-phy@0 {
 			/* Realtek RTL8211F (0x001cc916) */
+			compatible = "ethernet-phy-ieee802.3-c22";
 			reg = <0>;
 
 			reset-assert-us = <10000>;
-- 
2.31.0

