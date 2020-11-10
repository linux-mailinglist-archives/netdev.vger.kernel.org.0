Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 742392ACBC6
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 04:32:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730330AbgKJDbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 22:31:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731300AbgKJDb3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 22:31:29 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44AD5C0613D4;
        Mon,  9 Nov 2020 19:31:28 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id e7so10108860pfn.12;
        Mon, 09 Nov 2020 19:31:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cxtACsKlWxvLB+hXE/0GSAbFDdTqWfJVViue1wX7GUE=;
        b=DBQD1db2KEbgj20z08lHtLDUN/bGlqbMoeo2CwHyr2sRWoYtQcv2cE055KMoysX4Am
         UUQKV2I51K7XuIFeBbEPCyamdNJNUi7kA+Kz5qdIRwIvTA67NSaxFXNRKmevChdy2gNx
         VK4H7Sj4yFk90z/3bf3xj4fEYj90VdkFhEM4oVE8ZWHkuVrR2EC0yuNLNNIqfyJGLe+n
         WGqD/H8LuYO2uZvlkWdHwH/O0yFmj8nr+QqEH2KTAHvHZm5G4nkvQE0zpmvPlZbtsUAK
         4245exJFX/jcMgwNeuVmeCxL5jgXXZgXmeglc8sHXzh4iEFQNX0Rnwjrfqh54Yve7XXD
         RgFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cxtACsKlWxvLB+hXE/0GSAbFDdTqWfJVViue1wX7GUE=;
        b=sPMPEb5ZpUZns/iON/qaO61voEpPEIXj4Fv1W60nKErh3xqRk1eV9inqdHr/GURmLO
         BKzj5jkcS0KkUj8uR3ZkBuWLYDwd+n4lFwbefNDlSz4+w45lW/ggHaxHvlJulceMb3CX
         20F28tg8zfEAqH9gWBAt+z7Z0bvhuh4K+FV/ur5WdtIMhblzw6qTNBTWqVGdzYtUrmLP
         TO+V6pr9jToq4+knm7vE2qVUvovjirZfpw60yGhP/fnlZdI4gnPLNxvr86dIyne5WuPu
         V7xJ7vNaxIhkxkJ5Xu+rgOrvPG7cisQ4bT1NuetyPqTxBKhIFUc4Z8qF3tDXaC/qPGUz
         65EA==
X-Gm-Message-State: AOAM532m1q2mY0REyqfF68oRSXvu6FUKA1YTz3lVd//EDYHRogSZdSv2
        5hJbENNK2nJN1NcB/J275jL/MYlSIUg=
X-Google-Smtp-Source: ABdhPJwcywVGezMjHkJBvc8udd8EiO9C5hLiiawiuZ4Kj0u2Y3oGq/aG2TTK5lWKnht9X+n+DpxRRA==
X-Received: by 2002:a17:90a:8c87:: with SMTP id b7mr2735457pjo.162.1604979087242;
        Mon, 09 Nov 2020 19:31:27 -0800 (PST)
Received: from 1G5JKC2.Broadcom.net (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id k12sm965677pjf.22.2020.11.09.19.31.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 19:31:26 -0800 (PST)
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
Subject: [PATCH 03/10] ARM: dts: BCM5301X: Update Ethernet switch node name
Date:   Mon,  9 Nov 2020 19:31:06 -0800
Message-Id: <20201110033113.31090-4-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201110033113.31090-1-f.fainelli@gmail.com>
References: <20201110033113.31090-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the switch unit name from srab to ethernet-switch, allowing us to
fix warnings such as:

  CHECK   arch/arm/boot/dts/bcm4708-buffalo-wzr-1750dhp.dt.yaml
arch/arm/boot/dts/bcm4708-buffalo-wzr-1750dhp.dt.yaml:
srab@18007000: $nodename:0: 'srab@18007000' does not match
'^(ethernet-)?switch(@.*)?$'
        From schema:
Documentation/devicetree/bindings/net/dsa/b53.yaml

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 arch/arm/boot/dts/bcm5301x.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/bcm5301x.dtsi b/arch/arm/boot/dts/bcm5301x.dtsi
index ac3a99cf2079..ee23c0841699 100644
--- a/arch/arm/boot/dts/bcm5301x.dtsi
+++ b/arch/arm/boot/dts/bcm5301x.dtsi
@@ -482,7 +482,7 @@ thermal: thermal@1800c2c0 {
 		#thermal-sensor-cells = <0>;
 	};
 
-	srab: srab@18007000 {
+	srab: ethernet-switch@18007000 {
 		compatible = "brcm,bcm5301x-srab";
 		reg = <0x18007000 0x1000>;
 
-- 
2.25.1

