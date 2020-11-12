Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A83A22AFE13
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 06:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728333AbgKLFd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 00:33:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729055AbgKLEuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 23:50:39 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D57C0613D4;
        Wed, 11 Nov 2020 20:50:37 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id q10so3397801pfn.0;
        Wed, 11 Nov 2020 20:50:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4QaAqu0iD/ITRgAwPfVsE1pSqb2BxI9IroYfzGrBYfg=;
        b=pQTBSw/XiTlCMELaE5nhlB6kyS1HikEDQCbHJelJySV//EjamxyG1L10iftyChPmwM
         7xersPOHekaAVeCb6ClAGrHkllilqS3s9M58nEwV0jS1/1U3fdtIsRorYCiO9MuhsNwc
         Zbk0D6pHknOPiWiFM/NyTKqRRXBOYQbogwmCL81A7/eng9oZmxbP/XbymfvjX9cJwsSj
         LjcD/T6W6h10c6fbJe7vMBP/UtYF+mXwfNKEl4+AzGOlPh/kyrqqO/8DRl1nu0QkXB6m
         nx0lXmHLMwYB3uvCRE1umYMxGgl3+pSfWdKCXpM73cylNYeDkqSBCfV9ekSN5hwhb3eo
         P/QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4QaAqu0iD/ITRgAwPfVsE1pSqb2BxI9IroYfzGrBYfg=;
        b=nBfw0r3F9zAEo9zWetZRSvCPQpbbXr/QNYtu0k2b2sUPPKKyaAeC4WW+rC+sw0QLO0
         yJcIhZwkeVBWvAOHQmOk8GieSxgzXDpVJ2UWqTgSULv8/CSTIzs43Oiuoxs4Y+U+QyJv
         hVQ15mduCX5EP4n92Zlsmm1wu1SnNwP1VE5eJAsizjHD1MnxQSOkKoP+iMOriwt7NBcp
         JU+SgRKEDsMcqiEWjpXxJuKQ4IT7518Z9rfi6EUjcV1R7JFxz+6ziMFMOVOXxiw5JalK
         ZCGQEhO8LUu5tWM6noIMPpTYblMogsf03UjfufACDWMCi16iZMgytOd9nWZYNlbjygcv
         IGVA==
X-Gm-Message-State: AOAM532HeOxsBNuyTP4wozTP6RSqAmVKG4Uur26BpPIUT9gz1HKphHnN
        9ySVhxqLWtvdUEvq6I6dFunLH6oluZ4=
X-Google-Smtp-Source: ABdhPJymJNKtvXWnPs9a9e096PJ7akpTqgKeXqyTCYb1D0htvcaRXKryP6ZyNA/yfl0gPBP4zcay/g==
X-Received: by 2002:a17:90a:3989:: with SMTP id z9mr2041171pjb.236.1605156636475;
        Wed, 11 Nov 2020 20:50:36 -0800 (PST)
Received: from 1G5JKC2.Broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id gk22sm4189087pjb.39.2020.11.11.20.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 20:50:35 -0800 (PST)
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
Subject: [PATCH v2 00/10] Broadcom b53 YAML bindings
Date:   Wed, 11 Nov 2020 20:50:10 -0800
Message-Id: <20201112045020.9766-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This patch series fixes the various Broadcom SoCs DTS files and the
existing YAML binding for missing properties before adding a proper b53
switch YAML binding from Kurt.

If this all looks good, given that there are quite a few changes to the
DTS files, it might be best if I take them through the upcoming Broadcom
ARM SoC pull requests. Let me know if you would like those patches to be
applied differently.

Thanks!

Changes in v2:

- collected Reviewed-by and Acked-by tags from Vladimir and Rob
- corrected BCM5301X default compatibles based on data provided by Rafal
  on his different devices
- updated strategy for NSP to tackle each board separately
- provide both a ports {} container node and its #address-cells and
  #size-cells properties
- renamed binding from b53.yaml to brcm,b53.yaml

Florian Fainelli (9):
  dt-bindings: net: dsa: Extend switch nodes pattern
  dt-bindings: net: dsa: Document sfp and managed properties
  ARM: dts: BCM5301X: Update Ethernet switch node name
  ARM: dts: BCM5301X: Add a default compatible for switch node
  ARM: dts: BCM5301X: Provide defaults ports container node
  ARM: dts: NSP: Update ethernet switch node name
  ARM: dts: NSP: Fix Ethernet switch SGMII register name
  ARM: dts: NSP: Add a SRAB compatible string for each board
  ARM: dts: NSP: Provide defaults ports container node

Kurt Kanzenbach (1):
  dt-bindings: net: dsa: b53: Add YAML bindings

 .../devicetree/bindings/net/dsa/b53.txt       | 149 -----------
 .../devicetree/bindings/net/dsa/brcm,b53.yaml | 249 ++++++++++++++++++
 .../devicetree/bindings/net/dsa/dsa.yaml      |   6 +-
 MAINTAINERS                                   |   2 +-
 arch/arm/boot/dts/bcm-nsp.dtsi                |   8 +-
 arch/arm/boot/dts/bcm4708-luxul-xap-1510.dts  |   3 -
 arch/arm/boot/dts/bcm4708-luxul-xwc-1000.dts  |   3 -
 arch/arm/boot/dts/bcm4708-smartrg-sr400ac.dts |   3 -
 arch/arm/boot/dts/bcm47081-luxul-xap-1410.dts |   3 -
 arch/arm/boot/dts/bcm47081-luxul-xwr-1200.dts |   3 -
 arch/arm/boot/dts/bcm4709.dtsi                |   4 +
 .../boot/dts/bcm47094-linksys-panamera.dts    |   3 -
 arch/arm/boot/dts/bcm47094-luxul-xap-1610.dts |   3 -
 arch/arm/boot/dts/bcm47094-luxul-xwc-2000.dts |   3 -
 arch/arm/boot/dts/bcm47094-luxul-xwr-3100.dts |   3 -
 .../boot/dts/bcm47094-luxul-xwr-3150-v1.dts   |   3 -
 arch/arm/boot/dts/bcm47094.dtsi               |   4 +
 arch/arm/boot/dts/bcm5301x.dtsi               |   8 +-
 arch/arm/boot/dts/bcm953012er.dts             |   3 -
 arch/arm/boot/dts/bcm958522er.dts             |   4 +
 arch/arm/boot/dts/bcm958525er.dts             |   4 +
 arch/arm/boot/dts/bcm958525xmc.dts            |   4 +
 arch/arm/boot/dts/bcm958622hr.dts             |   3 -
 arch/arm/boot/dts/bcm958623hr.dts             |   3 -
 arch/arm/boot/dts/bcm958625hr.dts             |   3 -
 arch/arm/boot/dts/bcm958625k.dts              |   3 -
 arch/arm/boot/dts/bcm988312hr.dts             |   3 -
 27 files changed, 287 insertions(+), 203 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/dsa/b53.txt
 create mode 100644 Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml

-- 
2.25.1

