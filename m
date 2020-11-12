Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5DC12AFF0A
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 06:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728506AbgKLFdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 00:33:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729102AbgKLEwo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 23:52:44 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C9BDC061A49;
        Wed, 11 Nov 2020 20:51:37 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id b3so2135905pls.11;
        Wed, 11 Nov 2020 20:51:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HFo4rwKDO3HHhcsoL7vPox9y0FiOilLBsHbbX62U+iA=;
        b=ghLn6DvHvUoGN739B8VaOdHo9vtWLVqAFODa8gKY8XfQ+6hzxtVUfL5EjyNn3hKGRq
         qUydFbX1M4tjQoZfddZkHwSEYofTiH1jeHLrqZjIyhIXC5BnLIT9FuRr17RmZyu2eS/y
         5y5hrtWckq86E63Ess24ouVDTTAiTXWfIy/ErEkT/MPmN9QMBXYH3k+Sspyb4OlcZaMl
         tPbSlq5/t0NAqSAJTDOAWGMZdBV27wLmcHc0XJTVQqrXynBqxaJxo1KtTBTmVb6SfwK2
         eXRZDriDwXbnoJF0Eupun0fq9k6tL14oFWks6EbbGLwSBTd5fauE1xb8cU//F3HisbD2
         aJJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HFo4rwKDO3HHhcsoL7vPox9y0FiOilLBsHbbX62U+iA=;
        b=ScmD4kbE94yGweBu4bC/JZu51X3QdX94lDwKmmmgDsnorMndNiJPfYGYTcj9tFysix
         5z3hrmQl7yLjd+5nQHwY0GfwxB4UkX/GiVn9mUC807bsi/NOMLHgBaST8wAsBabPJBTF
         WustkdGpdc4HbWyKktod3+nwsyu6RsBlE/akh/xvsTtVi1wxEh/aelwaDLP3lRJ4NCT4
         UHVOTgYFmvuHuQg+lBhQLuF3l0q8NJIximV9bjf+Ucx69DeBKTnwQwGwLaOLkrFXi8jN
         LQ52zby7Ueym4evEjjnrud6xJeCp8jLMWiI0zsihrZhQydDzy4qRZXsIJ6fziobJwGSw
         9RJQ==
X-Gm-Message-State: AOAM5329mDHkhYBiREh9E5y3cH477z2YOp37JAYoZs8oyvKLJ/czEUOP
        mdxlYQsEmAkP14QmEndviyw=
X-Google-Smtp-Source: ABdhPJxp69cnois8Pe7fKuLL7klRxDUDb9MIrjd2IiSdiuTi6qDPXWqKfuJudrzfAAlCxuIhVtzs1A==
X-Received: by 2002:a17:902:d3ca:b029:d7:e0f9:b9c with SMTP id w10-20020a170902d3cab02900d7e0f90b9cmr15556764plb.2.1605156696480;
        Wed, 11 Nov 2020 20:51:36 -0800 (PST)
Received: from 1G5JKC2.Broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id gk22sm4189087pjb.39.2020.11.11.20.51.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 20:51:35 -0800 (PST)
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
Subject: [PATCH v2 08/10] ARM: dts: NSP: Add a SRAB compatible string for each board
Date:   Wed, 11 Nov 2020 20:50:18 -0800
Message-Id: <20201112045020.9766-9-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201112045020.9766-1-f.fainelli@gmail.com>
References: <20201112045020.9766-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Provide a valid compatible string for the Ethernet switch node based on
the board including the switch. This allows us to have sane defaults and
silences the following warnings:

 arch/arm/boot/dts/bcm958522er.dt.yaml:
    ethernet-switch@36000: compatible: 'oneOf' conditional failed,
one
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
 arch/arm/boot/dts/bcm958522er.dts  | 4 ++++
 arch/arm/boot/dts/bcm958525er.dts  | 4 ++++
 arch/arm/boot/dts/bcm958525xmc.dts | 4 ++++
 3 files changed, 12 insertions(+)

diff --git a/arch/arm/boot/dts/bcm958522er.dts b/arch/arm/boot/dts/bcm958522er.dts
index 7be4c4e628e0..5443fc079e6e 100644
--- a/arch/arm/boot/dts/bcm958522er.dts
+++ b/arch/arm/boot/dts/bcm958522er.dts
@@ -178,3 +178,7 @@ &usb3_phy {
 &xhci {
 	status = "okay";
 };
+
+&srab {
+	compatible = "brcm,bcm58522-srab", "brcm,nsp-srab";
+};
diff --git a/arch/arm/boot/dts/bcm958525er.dts b/arch/arm/boot/dts/bcm958525er.dts
index e58ed7e95346..e1e3c26cef19 100644
--- a/arch/arm/boot/dts/bcm958525er.dts
+++ b/arch/arm/boot/dts/bcm958525er.dts
@@ -190,3 +190,7 @@ &usb3_phy {
 &xhci {
 	status = "okay";
 };
+
+&srab {
+	compatible = "brcm,bcm58525-srab", "brcm,nsp-srab";
+};
diff --git a/arch/arm/boot/dts/bcm958525xmc.dts b/arch/arm/boot/dts/bcm958525xmc.dts
index 21f922dc6019..f161ba2e7e5e 100644
--- a/arch/arm/boot/dts/bcm958525xmc.dts
+++ b/arch/arm/boot/dts/bcm958525xmc.dts
@@ -210,3 +210,7 @@ &usb3_phy {
 &xhci {
 	status = "okay";
 };
+
+&srab {
+	compatible = "brcm,bcm58525-srab", "brcm,nsp-srab";
+};
-- 
2.25.1

