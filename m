Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8041E2ACBCC
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 04:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731929AbgKJDcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 22:32:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731634AbgKJDbh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 22:31:37 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5550BC0613CF;
        Mon,  9 Nov 2020 19:31:37 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id c20so10129897pfr.8;
        Mon, 09 Nov 2020 19:31:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ofJRb0fnphmHHB5NTXd1rq89u0HVXsf9qyxD0rCV8U4=;
        b=tjBQ4FqY0FjflqAIoKiCyjyuTe+W8+lfsLzANQ4byUq3kBgTtZROjkPl3yX9YHYjWE
         f19eAoChNGMaGaciwfiQRvpnm6nmyGOCNXiAMAbAOrvlWaifArvzIGLA/nDZrXCIoq2D
         qDzwYblTzVUeUSUIe4NylML51W2XfGB4XkFHFDnzsxMhBt0DIFzoJFeXrQ/GrQfaWNmN
         8d6j08qXqzoDiWvbe4Rhp3tWvhBgHIOWaemOP0hKNMY4rgH+GM/tUE1mD8BU260G1zXA
         TcBsKQqUtPzl7kGCrWxVPyNXukVzD7ynonC1bMguRSpCnHUVHlT9r8yz8P9y0BUgJZgn
         cIIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ofJRb0fnphmHHB5NTXd1rq89u0HVXsf9qyxD0rCV8U4=;
        b=V6CUbljlQONFu3mA41bBHHN2XkmIr8rgTai9E/DlkHHG4UeiiDZmvX4A5HPFNMzpeQ
         80qiy5VeEbDeH02T7CCk5uIUlAyMZCprDTZBkjz1r4m1etxPosomUhsIE5vXHt7pmqz0
         mmxBhacjVHyzIx1uSPGoheo3gcWEt4Dk0dtUkwxKLksfGiVC81SZBWOV4eN4i1G+0ivR
         YZM/Q0Ge4x2043UAI7Jj2JQI3Ky9WE7lmfexpLbW7KC5IHKsECMoyqQ540cnKjK/1YZ1
         55Uun+N6RTIui3HX4DEExv03+IF8xIOOme0lM3Xj5Sxts8xSJIrDSe9XfiMkuJDm8Mz0
         a3bA==
X-Gm-Message-State: AOAM530T0fn6PrkWRCmp5g7hDthrzi7/9oFhV4XAYscgXVLyDmH3NL4f
        i8MAf1sTOPedjgoV2eYCUcTv+dUxU0c=
X-Google-Smtp-Source: ABdhPJz08vJ15VvW9yP1+MK7j/XNuZo37xgmu7yOaNVs6pKG82eUyZ6gkewIQSgK1qBCEp/1D9v0mQ==
X-Received: by 2002:a17:90a:5806:: with SMTP id h6mr2601592pji.139.1604979096468;
        Mon, 09 Nov 2020 19:31:36 -0800 (PST)
Received: from 1G5JKC2.Broadcom.net (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id k12sm965677pjf.22.2020.11.09.19.31.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 19:31:35 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
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
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:BROADCOM IPROC ARM
        ARCHITECTURE), Kurt Kanzenbach <kurt@kmk-computers.de>
Subject: [PATCH 07/10] ARM: dts: NSP: Fix Ethernet switch SGMII register name
Date:   Mon,  9 Nov 2020 19:31:10 -0800
Message-Id: <20201110033113.31090-8-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201110033113.31090-1-f.fainelli@gmail.com>
References: <20201110033113.31090-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The register name should be "sgmii_config", not "sgmii", this is not a
functional change since no code is currently looking for that register
by name (or at all).

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

