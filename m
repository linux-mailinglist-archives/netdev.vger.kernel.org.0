Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2BE62AFE17
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 06:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728419AbgKLFdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 00:33:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729084AbgKLEvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 23:51:04 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BFACC0617A7;
        Wed, 11 Nov 2020 20:51:04 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id g11so2138800pll.13;
        Wed, 11 Nov 2020 20:51:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MJoLvL0oyUiQIAUCCDvNyyDYOZQYfjsgzkgozFWjSes=;
        b=co43/I9VL9yg3lRwIiTMr8pkQJRzo3Ss2y/N5+jnMvmiANdX8IHCrA8bHbwPPErsFA
         VKSA3wF7G1ftMFKa9UqjP0y2Sau/LPl6YXU5P6iYPccDvLd4iaZjBo8PxQ1CPBKltQUt
         yIdc7A9NLQkji4rYIvKEo0eU3fXZF/jPkwwQrp0s+aOlSmhuLbhnrqpFyjcP4yLxUf+Y
         r8O+Q5bxPr3sGZCj7vVKqZS9IAlO5zxqqfW3aS2cS4JPc8BLN27vwY7XFOzYF591vJ/a
         fJNY7L/LuhFyYrMvsXm1Q+PdRbaaXm+/xcjTiNkLcErcGyHZIyNYSccGyedWbuQ9P7kJ
         kIqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MJoLvL0oyUiQIAUCCDvNyyDYOZQYfjsgzkgozFWjSes=;
        b=N1UfVGbjkeeKEsiMrvolXcsQzJ+Wbxt1yJzLpZsialFfo4YHnmxiACpymXRdoLtIh4
         DO4CpK5I+U+iOBFLgIbnZqg1olZ0eGP8s9HmP3QtThcx6/nTQTa4NpXYG2avctLN98nt
         gEBxNqfLF0YD73QQZKuQMnSWXrB58cMPBf3FQ/mCRCXT3GZJg7LTWTxZtgvbzYDZS7b6
         q50OeeD+Pmc1tkxWlJgszZtEQQTFk7GdH9Ai9OikmA+Q0yFK9w90KJhnqFDRvOch8y3L
         BcBowG3v+sOYTZtQbshXZZa425qJ8Rk31u5oppr7bwWFJqNj70E60DEvYoWOpOq8AmwS
         EtVA==
X-Gm-Message-State: AOAM531Hh4nl4y3wTu6Yqp/c26khv6Ypc4G8Mpf35CIg4Z6pvHjPbcDw
        iwf+3k/WrwiWx/B71mc/k80=
X-Google-Smtp-Source: ABdhPJygGSrsc5FnPE2fT5HJ97LmdPF7oFdAeAOB/QoKRF146pDy1FeAm5Szqw7GrsfWD6aSCmq+Dw==
X-Received: by 2002:a17:902:c10c:b029:d8:c028:5ceb with SMTP id 12-20020a170902c10cb02900d8c0285cebmr4416600pli.36.1605156664068;
        Wed, 11 Nov 2020 20:51:04 -0800 (PST)
Received: from 1G5JKC2.Broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id gk22sm4189087pjb.39.2020.11.11.20.50.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 20:51:03 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-arm-kernel@lists.infradead.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com (maintainer:BROADCOM IPROC ARM
        ARCHITECTURE), Hauke Mehrtens <hauke@hauke-m.de>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list),
        Kurt Kanzenbach <kurt@kmk-computers.de>
Subject: [PATCH v2 04/10] ARM: dts: BCM5301X: Add a default compatible for switch node
Date:   Wed, 11 Nov 2020 20:50:14 -0800
Message-Id: <20201112045020.9766-5-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201112045020.9766-1-f.fainelli@gmail.com>
References: <20201112045020.9766-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Provide a default compatible string which is based on the 53011 SRAB
compatible by default. The 4709 and 47094 default to the 53012 SRAB
compatible.

This allows us to have sane defaults and silences the following
warnings:

arch/arm/boot/dts/bcm4708-asus-rt-ac56u.dt.yaml:
ethernet-switch@18007000: compatible: 'oneOf' conditional failed, one
must be fixed:
        ['brcm,bcm5301x-srab'] is too short
        'brcm,bcm5325' was expected
        'brcm,bcm53115' was expected
        'brcm,bcm53125' was expected
        'brcm,bcm53128' was expected
        'brcm,bcm5365' was expected
        'brcm,bcm5395' was expected
        'brcm,bcm5389' was expected
        'brcm,bcm5397' was expected
        'brcm,bcm5398' was expected
        'brcm,bcm11360-srab' was expected
        'brcm,bcm5301x-srab' is not one of ['brcm,bcm53010-srab',
'brcm,bcm53011-srab', 'brcm,bcm53012-srab', 'brcm,bcm53018-srab',
'brcm,bcm53019-srab']
        'brcm,bcm5301x-srab' is not one of ['brcm,bcm11404-srab',
'brcm,bcm11407-srab', 'brcm,bcm11409-srab', 'brcm,bcm58310-srab',
'brcm,bcm58311-srab', 'brcm,bcm58313-srab']
        'brcm,bcm5301x-srab' is not one of ['brcm,bcm58522-srab',
'brcm,bcm58523-srab', 'brcm,bcm58525-srab', 'brcm,bcm58622-srab',
'brcm,bcm58623-srab', 'brcm,bcm58625-srab', 'brcm,bcm88312-srab']
        'brcm,bcm5301x-srab' is not one of ['brcm,bcm3384-switch',
'brcm,bcm6328-switch', 'brcm,bcm6368-switch']
        From schema:
Documentation/devicetree/bindings/net/dsa/b53.yaml

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 arch/arm/boot/dts/bcm4709.dtsi  | 4 ++++
 arch/arm/boot/dts/bcm47094.dtsi | 4 ++++
 arch/arm/boot/dts/bcm5301x.dtsi | 2 +-
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/bcm4709.dtsi b/arch/arm/boot/dts/bcm4709.dtsi
index e1bb8661955f..cba3d910bed8 100644
--- a/arch/arm/boot/dts/bcm4709.dtsi
+++ b/arch/arm/boot/dts/bcm4709.dtsi
@@ -9,3 +9,7 @@ &uart0 {
 	clock-frequency = <125000000>;
 	status = "okay";
 };
+
+&srab {
+	compatible = "brcm,bcm53012-srab", "brcm,bcm5301x-srab";
+};
diff --git a/arch/arm/boot/dts/bcm47094.dtsi b/arch/arm/boot/dts/bcm47094.dtsi
index 747ca030435f..2a8f7312d1be 100644
--- a/arch/arm/boot/dts/bcm47094.dtsi
+++ b/arch/arm/boot/dts/bcm47094.dtsi
@@ -25,3 +25,7 @@ &uart0 {
 	clock-frequency = <125000000>;
 	status = "okay";
 };
+
+&srab {
+	compatible = "brcm,bcm53012-srab", "brcm,bcm5301x-srab";
+};
diff --git a/arch/arm/boot/dts/bcm5301x.dtsi b/arch/arm/boot/dts/bcm5301x.dtsi
index b8d2e8d28482..a4ab3aabf8b0 100644
--- a/arch/arm/boot/dts/bcm5301x.dtsi
+++ b/arch/arm/boot/dts/bcm5301x.dtsi
@@ -484,7 +484,7 @@ thermal: thermal@2c0 {
 	};
 
 	srab: ethernet-switch@18007000 {
-		compatible = "brcm,bcm5301x-srab";
+		compatible = "brcm,bcm53011-srab", "brcm,bcm5301x-srab";
 		reg = <0x18007000 0x1000>;
 
 		status = "disabled";
-- 
2.25.1

