Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3649D2AFF09
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 06:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728486AbgKLFdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 00:33:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729096AbgKLEwj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 23:52:39 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5821C061A48;
        Wed, 11 Nov 2020 20:51:28 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id z24so3150749pgk.3;
        Wed, 11 Nov 2020 20:51:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zuL+aKkvTXRvVyAjB9d0Gmyxs4zs/ysdm48P1lvShlU=;
        b=B2XMsIL3ic2jUbsf2bHrS4jw96MgEclQ0RI/sr9gjoWPIXEjTVtDfr+JK5NELVzBRP
         gFBnp0aSVHxhdeMYGYJg2iHHt7bu50KRe+CG/T3zEgj75YeD2KlsNyek2oo2Ufy4wArS
         ARBk/gVu2d4eI4agezSPs2HhSsa4WpcmZTo5lorOtzZAjPRHwLZLWTMQ9pL+TjiO7zW/
         5hfJ3bdF0RYVetkkw5PCtO6a13LoVl2HJFq4jL2mi466+OJgCmfF/cHetmYCPrwjHjl/
         B4Rs3oZ/zxEfWMdYf2Km3m250spwNJp85OTWNa1UBMtngsAGro4hAOe/RKcxuX+WO/sB
         dXHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zuL+aKkvTXRvVyAjB9d0Gmyxs4zs/ysdm48P1lvShlU=;
        b=fzDh9rMKDsobu1gtFnpJe1a3AUFaEvglRx2UaN6fZOnfjgMbZyzxq+IbUa9N8pOZ3k
         Ej0HJKY37yg3ubpXYpmdcGy2sQ3BfWAOwLB9b2RGDv9SsbCx5WYHnnPLUhsZadhAbve0
         vjR6wobqgOCemWSyA2FOjIVYBl+IqHHSK+Zt4HuntYFPEJliD65Wfz3Gq/E0YMNQW+LK
         65r5VbzDvRe/1qFw2OGUAERDYeI8traOnoB643GEWJbAxpxpMHIU9XT5a9/Y1wcV6M9K
         VUG+shCAEVpiyzjKA+j6hsY0nUH11IFx6zFIqK9lnujrRMr0dbNOuAFUh1XPdD9oQL/K
         tiqQ==
X-Gm-Message-State: AOAM532+STa/QqKyXEeqZOxH+hpNRUXVwFh+QA0OwBG/oheLcO/fsDdT
        lckiGitjO+//Pl9d5tS9A8QyOO4MGR0=
X-Google-Smtp-Source: ABdhPJyp7uiq1u9B2wvQJxWWeSOHJNPuLAde6qeLyZA3hLn3GfMybSCe9MzW2FciAUHF2xoKpWL0+A==
X-Received: by 2002:a63:7a51:: with SMTP id j17mr24150116pgn.186.1605156688262;
        Wed, 11 Nov 2020 20:51:28 -0800 (PST)
Received: from 1G5JKC2.Broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id gk22sm4189087pjb.39.2020.11.11.20.51.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 20:51:27 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-arm-kernel@lists.infradead.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
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
Subject: [PATCH v2 07/10] ARM: dts: NSP: Fix Ethernet switch SGMII register name
Date:   Wed, 11 Nov 2020 20:50:17 -0800
Message-Id: <20201112045020.9766-8-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201112045020.9766-1-f.fainelli@gmail.com>
References: <20201112045020.9766-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The register name should be "sgmii_config", not "sgmii", this is not a
functional change since no code is currently looking for that register
by name (or at all).

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 arch/arm/boot/dts/bcm-nsp.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/bcm-nsp.dtsi b/arch/arm/boot/dts/bcm-nsp.dtsi
index e7d08959d5fe..09fd7e55c069 100644
--- a/arch/arm/boot/dts/bcm-nsp.dtsi
+++ b/arch/arm/boot/dts/bcm-nsp.dtsi
@@ -390,7 +390,7 @@ srab: ethernet-switch@36000 {
 			reg = <0x36000 0x1000>,
 			      <0x3f308 0x8>,
 			      <0x3f410 0xc>;
-			reg-names = "srab", "mux_config", "sgmii";
+			reg-names = "srab", "mux_config", "sgmii_config";
 			interrupts = <GIC_SPI 95 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 96 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 97 IRQ_TYPE_LEVEL_HIGH>,
-- 
2.25.1

