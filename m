Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B779547E790
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 19:17:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349801AbhLWSRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 13:17:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235530AbhLWSRx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 13:17:53 -0500
Received: from mail-ua1-x935.google.com (mail-ua1-x935.google.com [IPv6:2607:f8b0:4864:20::935])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DF8DC061401;
        Thu, 23 Dec 2021 10:17:52 -0800 (PST)
Received: by mail-ua1-x935.google.com with SMTP id y22so11581378uap.2;
        Thu, 23 Dec 2021 10:17:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2DoeJMrLCJd4i4nfvvOGZtme/V247eVYY/et0WnUbAk=;
        b=Pi0PnrJ7I6mPcBd8bcvZEh82CN7PT3fPKZsFE43VoFL/6ateTTzH/o2wcVUDO2KuHm
         qgD6Y6OxowtFt2n4vCOPUF4gk7SSQ3HsoB57otrILfZy+IYDiqNa5NgjtBAmYyZGnkbn
         jj4j9bLx6fdBeMGBz94j4Oo2bVqrdKXqDwJ7nuIjNNqAh8cbcIDKyUyXvAYsZFdXxM1Q
         RNZY6fLr2/JuyX7a+f0N0Om8mm8nkbafjbNxfqBcrcUAW1lCrfkyAnexCzB1Kq9LkkXZ
         ABasn1M5/hDNpwC29Lcve8fkwKfBf3aSmSJAxxK+T/xbsngEHpDYK1eQiGG4zUVviMbf
         HP7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2DoeJMrLCJd4i4nfvvOGZtme/V247eVYY/et0WnUbAk=;
        b=toTSRp5qHOArSfhqX0qlLOEKAg6YiPZ/4NgtaCdIMgKKVURFLZ/evNAdn9GKooq6NH
         beR+YTY2qZOEFfOz1XRnDnlwacFfh9/zemcsP6LzNAz9Cci2QlsSvISqkr7RhTp9QEMF
         OfmX/i+4CCc8Y2yg4F2j1D/q2TO2CzrlLBL6wzhmJZVkABGzs95tQbIo0U+DxRY/sOtL
         4yf7QksNZLiohRHXe016jEuKSEd319rPevvxW1AJNVjMXqUKX2rlCS4TsZ4mI6kHwptS
         clQkiMdmsxthFxNSsX/B81rAcmL9KcJw/3vM48trAFVgGlJ5pJh7IXcevEN/1yD1Q26V
         sUFQ==
X-Gm-Message-State: AOAM533sbqZLGtJpgDJuYjY+BBh5uXtC6le+duhkVsncQSFNyE8i9LHL
        E+ldowubMXvRGttj9AzSzM1bwbkLC5g=
X-Google-Smtp-Source: ABdhPJxgTNHgYBJ+dCZ6o8KfcWvh+ah0yjg4iUOV6/G53omSxl4C9qCxpLhsTJJrxj+RsTvlCq0XNA==
X-Received: by 2002:a67:f141:: with SMTP id t1mr1098716vsm.35.1640283471269;
        Thu, 23 Dec 2021 10:17:51 -0800 (PST)
Received: from 7YHHR73.igp.broadcom.net (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id z11sm161727uac.13.2021.12.23.10.17.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Dec 2021 10:17:50 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     devicetree@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] dt-bindings: net: dsa: Fix realtek-smi example
Date:   Thu, 23 Dec 2021 10:17:41 -0800
Message-Id: <20211223181741.3999-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'ports' node is not supposed to have a 'reg' property at all, in
fact, doing so will lead to dtc issuing warnings looking like these:

arch/arm/boot/dts/bcm47094-asus-rt-ac88u.dts:109.4-14: Warning (reg_format): /switch/ports:reg: property has invalid length (4 bytes) (#address-cells == 2, #size-cells == 1)
arch/arm/boot/dts/bcm47094-asus-rt-ac88u.dtb: Warning (pci_device_reg): Failed prerequisite 'reg_format'
arch/arm/boot/dts/bcm47094-asus-rt-ac88u.dtb: Warning (pci_device_bus_num): Failed prerequisite 'reg_format'
arch/arm/boot/dts/bcm47094-asus-rt-ac88u.dtb: Warning (i2c_bus_reg): Failed prerequisite 'reg_format'
arch/arm/boot/dts/bcm47094-asus-rt-ac88u.dtb: Warning (spi_bus_reg): Failed prerequisite 'reg_format'
arch/arm/boot/dts/bcm47094-asus-rt-ac88u.dts:106.9-149.5: Warning (avoid_default_addr_size): /switch/ports: Relying on default #address-cells value
arch/arm/boot/dts/bcm47094-asus-rt-ac88u.dts:106.9-149.5: Warning (avoid_default_addr_size): /switch/ports: Relying on default #size-cells value

Fix the example by remove the stray 'reg' property.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Fixes: 3b3b6b460f78 ("net: dsa: Add bindings for Realtek SMI DSAs")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/devicetree/bindings/net/dsa/realtek-smi.txt | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/realtek-smi.txt b/Documentation/devicetree/bindings/net/dsa/realtek-smi.txt
index 7959ec237983..a8d0f1febe32 100644
--- a/Documentation/devicetree/bindings/net/dsa/realtek-smi.txt
+++ b/Documentation/devicetree/bindings/net/dsa/realtek-smi.txt
@@ -84,7 +84,6 @@ switch {
 	ports {
 		#address-cells = <1>;
 		#size-cells = <0>;
-		reg = <0>;
 		port@0 {
 			reg = <0>;
 			label = "lan0";
@@ -174,7 +173,7 @@ switch {
 	ports {
 		#address-cells = <1>;
 		#size-cells = <0>;
-		reg = <0>;
+
 		port@0 {
 			reg = <0>;
 			label = "swp0";
-- 
2.25.1

