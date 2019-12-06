Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 096B911570F
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 19:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726345AbfLFSTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 13:19:21 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35185 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbfLFSTV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 13:19:21 -0500
Received: by mail-wm1-f65.google.com with SMTP id c20so6807446wmb.0;
        Fri, 06 Dec 2019 10:19:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=FLXIS+tKJCZqQe3ftQxxCM+L53W0Z6CULqU1f8qurnM=;
        b=iDCgPSRHh0gUGVnFOkxtPY2RDOw572sk0YWW6UlwZ598i8jnR/Xhr9PhI+ECGk20r4
         Ijh4TfgHHU2/MltTHFfh5RdL3WuPZ6M2TPj9Ju/TsKr/5CD8TSGAJlN0AHsKbL4fgMHz
         oDeO0I8qbQeHGuamUJYZVwk2NLxJlk+LCSQVwRXfYIk8cIwodbRjXm4mGFkqEvfGv4n8
         vIoq46nsn/7kkshxMSrM2ZOV/oao5+vRXA/4KX1cDgZGbtJ43Vzaztl84tO5TrB0PAp2
         znAlo82zWdAf8NM54dJP/6z4ZyCQUUOxCxCXqCZxzn5z4MiGpsqtMk1BnaqUv+NXEvmu
         fXAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=FLXIS+tKJCZqQe3ftQxxCM+L53W0Z6CULqU1f8qurnM=;
        b=YfZM3Juv++n9LXL2XwCcgaJtB8VoM/9uucuAB3sdxR+GjLB+JV5Y+qQCbqC7F0uZRe
         AnC4lcQkTYAUcX06b1jkNeV7SPHM2iX4hGcbP79ou4pUypLKB5aXsY8IP9rd3hTTKmc2
         pUGI+l+8DzoyK9abb4fMr5jsHpBbhQp6DENhjuqRWx1E8joKiZdD1r4VEZPDH2vBztte
         XhZD/QiH/s53Nz8UZdvNUmrDDtrHDe+Y3A7hlSJN2R5JuoI9+CpuxLa2He5sjXdf9/jF
         IGNF+Fo4FE4Oh7STW0Utly7pn65NaYQHpG+YkC4MNJWrzezreBWgwXo1B17WKIFKUtms
         ayBg==
X-Gm-Message-State: APjAAAWJd3yo8ZsNEY2x3S9qoRnspmfV3VP37CEhY1E/NfaIwsgE9WRu
        HI6bmLnV4zWMzDiuPuDQIaA=
X-Google-Smtp-Source: APXvYqyfwNCbAL3g1EUSeCA3aLJS8wmE10SYjLXzCh/SY2IcTNyz2rf2XMLQRBmVXph3Ztp0xP0JMA==
X-Received: by 2002:a1c:3d87:: with SMTP id k129mr11474183wma.26.1575656358536;
        Fri, 06 Dec 2019 10:19:18 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b17sm17073339wrx.15.2019.12.06.10.19.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Dec 2019 10:19:17 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-arm-kernel@lists.infradead.org
Cc:     grygorii.strashko@ti.com, simon.horman@netronome.com,
        robh+dt@kernel.org, rafal@milecki.pl, davem@davemloft.net,
        andrew@lunn.ch, mark.rutland@arm.com, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Eric Anholt <eric@anholt.net>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] ARM: dts: Cygnus: Fix MDIO node address/size cells
Date:   Fri,  6 Dec 2019 10:19:09 -0800
Message-Id: <20191206181909.10962-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MDIO node on Cygnus had an reversed #address-cells and
 #size-cells properties, correct those.

Fixes: 40c26d3af60a ("ARM: dts: Cygnus: Add the ethernet switch and ethernet PHY")
Reported-by: Simon Horman <simon.horman@netronome.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 arch/arm/boot/dts/bcm-cygnus.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/bcm-cygnus.dtsi b/arch/arm/boot/dts/bcm-cygnus.dtsi
index 2dac3efc7640..1bc45cfd5453 100644
--- a/arch/arm/boot/dts/bcm-cygnus.dtsi
+++ b/arch/arm/boot/dts/bcm-cygnus.dtsi
@@ -174,8 +174,8 @@
 		mdio: mdio@18002000 {
 			compatible = "brcm,iproc-mdio";
 			reg = <0x18002000 0x8>;
-			#size-cells = <1>;
-			#address-cells = <0>;
+			#size-cells = <0>;
+			#address-cells = <1>;
 			status = "disabled";
 
 			gphy0: ethernet-phy@0 {
-- 
2.17.1

