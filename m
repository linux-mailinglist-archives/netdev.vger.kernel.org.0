Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 856FD349252
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 13:44:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbhCYMns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 08:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230475AbhCYMnL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 08:43:11 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB35CC06174A;
        Thu, 25 Mar 2021 05:43:10 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id j25so1949153pfe.2;
        Thu, 25 Mar 2021 05:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iEn6qKJ0gN4j90BS+aCP3T+jQ0ecUWl0Idd4DLZOaBs=;
        b=kL4jghWXYvGUk9aIgwhEwP+eY/j/zpJ3JozsIHI2hc+IsM1pXFILpKYoxU5rJopvEw
         ze3qBMfeHzCOY4StFgCfP4dC2hKQCabNcWrmT4ewtyDxU123R7i6imjZsVFiV//fYXwG
         /ZkCa4/YFPV1bR1sRPSf79jKAtPuLJE4L931KenhOcqb5N1kOEZdWfpQa76jq8AZf8ny
         37j26Ll7SwtTzPrgH9ylSMyhb5u/xtxIksTHngThNfamA1Q6tV5GhCdze8/zWGH1s4E/
         phXS3SVLVZHtJ0313e4pkKoPCzuunpXGy0zwA+dinfQEVxX8iPVtjP+G3AtdI3CLaa1K
         GK0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iEn6qKJ0gN4j90BS+aCP3T+jQ0ecUWl0Idd4DLZOaBs=;
        b=m8IE/xtEtm+v/xwFtwO+ObzMq/4lzus/ZJKegzcd8wFpqz55YbXakEw+gLtFDRK4hQ
         CGDOHMXTZr5juO8cywqsp/L333NuxMGgWBos5JpxfjWgNb5kOR4OWKZWknScajswLKg6
         kEwT9GjR6fmJXFLBUOASscf80oYM6olpUaT3G4VFx6HAXDK0pT5Zgndk3zsaMUm+DqAT
         93W9L0TmyoK1s36jjxWBRm2cz6gIowOJ9pBZ3yoT6XQVXZLmKmfheI/fhSCIAYxU4xDE
         ySxIwiiRv/tJwCQ7gX3WZsguXr0O6Kq5jTlUWazkI3s/iTnCdzpTUbCZRZvjzrgA6dv4
         csUQ==
X-Gm-Message-State: AOAM532Z5t+5cEiVfbZmx+ZmC5dBgBcjBbGKhxgvRRddP6AIqlGsZLA8
        ny+bOKklH+CiZeEDmqbNVYs=
X-Google-Smtp-Source: ABdhPJx/yBK25ROu+Q46FS9EPvSNS8ntot4VYxYvF1e0VDn1qlFEWnKCqXZe3VGsoMsUfPJSwVLAzA==
X-Received: by 2002:a62:8485:0:b029:1fc:823d:2a70 with SMTP id k127-20020a6284850000b02901fc823d2a70mr8120061pfd.18.1616676190304;
        Thu, 25 Mar 2021 05:43:10 -0700 (PDT)
Received: from archl-c2lm.. ([103.51.72.9])
        by smtp.gmail.com with ESMTPSA id t17sm6125917pgk.25.2021.03.25.05.43.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 05:43:09 -0700 (PDT)
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
Subject: [PATCHv1 6/6] arm64: dts: meson-glx: Fix the ethernet phy mdio compatible string
Date:   Thu, 25 Mar 2021 12:42:25 +0000
Message-Id: <20210325124225.2760-7-linux.amoon@gmail.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210325124225.2760-1-linux.amoon@gmail.com>
References: <20210325124225.2760-1-linux.amoon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the ethernet phy mdio comatible string to help
initialize the phy on Amlogic SoC sbc.

make ARCH=arm64 dtbs_check
DT_SCHEMA_FILES=Documentation/devicetree/bindings/net/ethernet-phy.yaml

Cc: Neil Armstrong <narmstrong@baylibre.com>
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Anand Moon <linux.amoon@gmail.com>
---
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi b/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
index c3ac531c4f84..303f54384a9a 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
@@ -773,7 +773,7 @@ internal_mdio: mdio@e40908ff {
 			#size-cells = <0>;
 
 			internal_phy: ethernet-phy@8 {
-				compatible = "ethernet-phy-id0181.4400";
+				compatible = "ethernet-phy-ieee802.3-c22";
 				interrupts = <GIC_SPI 9 IRQ_TYPE_LEVEL_HIGH>;
 				reg = <8>;
 				max-speed = <100>;
-- 
2.31.0

