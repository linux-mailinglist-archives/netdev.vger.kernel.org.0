Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B382465460
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 18:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351955AbhLASAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 13:00:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236519AbhLASAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 13:00:21 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6EA1C061748;
        Wed,  1 Dec 2021 09:57:00 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id r5so24351153pgi.6;
        Wed, 01 Dec 2021 09:57:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YH7GGCYhB4tao9D+uXBMuduOWm7x34SLXOg19azbyvw=;
        b=noFtrm6PLX2WhF4tykayOXxTZvaQZaXGwG5u2QkLE173zEZwCAoOPvJOwHoQze75XX
         50hrCjYoGEJmx2k2RA057N0mPlyPGirpVxuSBvLFC02PUrX+e+2TaJfvmVbKnctbEyJk
         +rHyL9rY4mEZf+i7PBRvveaj4HIfJqBgOe0Cn6V5fB7CyvCzcGbN6Am6dasfaOpJYA+o
         aIBkrDlcwEWKVp+J5FZlhM7ZYXSmuVCCe2ONolZCAF8B+wgxsQcafpPWnZd6gipKUxv4
         9WH6KXB4WQkx15+BpmZ+dPiBYK9kJ/pCwEVl2fVj80WMFhs2zkc6dSNUvHQB25A9NaUp
         uz7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YH7GGCYhB4tao9D+uXBMuduOWm7x34SLXOg19azbyvw=;
        b=nSeJXlLM85w2Zod7shzAv+fe+kdmmnA8AnQB0/WLHeJMz2SUhoXFRQXIOJg+ddbf4O
         LIek5zs9UP6/ovkXHob15A0M3fIPrAQl7L9+MpNF/eRFj4ZVzArmgkYKI+UPskqvUNHJ
         dKob86NojkoVSBwzgwoJMnJz7dOZ38n2P7nyqxWIu1yls8tlJNSGu1o6Ilvme32JGczY
         m+NU3jhVGjk+ecJ5Ve1N2gxo/qJjrmZ9UAuuNmEvkIMGsw/kEpU7cMGpVcgpNZcK4Un9
         v2LNCe4Zcj2cBl6ItUq8sMPgHil3byesIKJ4jJ/xRfYL789T677AizOJVCe7y5yQFFUs
         IbXw==
X-Gm-Message-State: AOAM5335io1lKCXL9jedu5KSZKO66lfgY/WjOlYeBU/6LhMdHvXnQBnT
        pfj8MiFOIoJ2lMGWzlTtZYZL7TxiH44=
X-Google-Smtp-Source: ABdhPJwYspeZxsIzy8BwyltvOICyH7yKqgNufLA6pu2F6n6Vt9d21WPjf/klHsf4yrP4cSAz1hGRWw==
X-Received: by 2002:a63:82c6:: with SMTP id w189mr5959474pgd.491.1638381419822;
        Wed, 01 Dec 2021 09:56:59 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j13sm471546pfc.151.2021.12.01.09.56.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 09:56:59 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        bcm-kernel-feedback-list@broadcom.com (maintainer:BROADCOM IPROC GBIT
        ETHERNET DRIVER), Doug Berger <opendmb@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:BROADCOM IPROC ARM
        ARCHITECTURE),
        linux-phy@lists.infradead.org (open list:GENERIC PHY FRAMEWORK)
Subject: [PATCH net-next v2 0/9] Broadcom DT bindings conversion to YAML
Date:   Wed,  1 Dec 2021 09:56:43 -0800
Message-Id: <20211201175652.4722-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

This patch series converts 3 Broadcom Ethernet controller Device Tree
bindings to YAML and the iProc MDIO mux. Please wait for a review from
Rob before applying, thank you!

Changes in v2;

- converted Northstar 2 PCIe binding to YAML as well
- fixed DT_CHECKER_FLAGS=-m warnings
- documented 2500 Mbits/sec for fixed-link

Florian Fainelli (9):
  dt-bindings: net: Document 2500Mbits/sec fixed link
  dt-bindings: net: brcm,unimac-mdio: reg-names is optional
  dt-bindings: net: brcm,unimac-mdio: Update maintainers for binding
  dt-bindings: net: Document moca PHY interface
  dt-bindings: net: Convert GENET binding to YAML
  dt-bindings: net: Convert AMAC to YAML
  dt-bindings: net: Convert SYSTEMPORT to YAML
  dt-bindings: phy: Convert Northstar 2 PCIe PHY to YAML
  dt-bindings: net: Convert iProc MDIO mux to YAML

 .../devicetree/bindings/net/brcm,amac.txt     |  30 ----
 .../devicetree/bindings/net/brcm,amac.yaml    |  88 +++++++++++
 .../devicetree/bindings/net/brcm,bcmgenet.txt | 125 ---------------
 .../bindings/net/brcm,bcmgenet.yaml           | 145 ++++++++++++++++++
 .../bindings/net/brcm,mdio-mux-iproc.txt      |  62 --------
 .../bindings/net/brcm,mdio-mux-iproc.yaml     |  80 ++++++++++
 .../bindings/net/brcm,systemport.txt          |  38 -----
 .../bindings/net/brcm,systemport.yaml         |  82 ++++++++++
 .../bindings/net/brcm,unimac-mdio.yaml        |   3 +-
 .../bindings/net/ethernet-controller.yaml     |   3 +-
 .../bindings/phy/brcm,mdio-mux-bus-pci.txt    |  27 ----
 .../bindings/phy/brcm,ns2-pcie-phy.yaml       |  41 +++++
 MAINTAINERS                                   |   5 +-
 13 files changed, 443 insertions(+), 286 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/brcm,amac.txt
 create mode 100644 Documentation/devicetree/bindings/net/brcm,amac.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/brcm,bcmgenet.txt
 create mode 100644 Documentation/devicetree/bindings/net/brcm,bcmgenet.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/brcm,mdio-mux-iproc.txt
 create mode 100644 Documentation/devicetree/bindings/net/brcm,mdio-mux-iproc.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/brcm,systemport.txt
 create mode 100644 Documentation/devicetree/bindings/net/brcm,systemport.yaml
 delete mode 100644 Documentation/devicetree/bindings/phy/brcm,mdio-mux-bus-pci.txt
 create mode 100644 Documentation/devicetree/bindings/phy/brcm,ns2-pcie-phy.yaml

-- 
2.25.1

