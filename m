Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00F3646A39A
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 19:00:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345967AbhLFSEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 13:04:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345884AbhLFSEV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 13:04:21 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13DA9C061354;
        Mon,  6 Dec 2021 10:00:53 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id p13so10907814pfw.2;
        Mon, 06 Dec 2021 10:00:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3/Ga8N5Se9TR1n5VDV57kaqfWCZDfxPiuIZHay3w/+c=;
        b=elZAuCrhF4PN97o0TM8CLsqM6KPFIDFFmw58IPfqpNBTbxFWVMCnkj8sRvkhD/VRad
         OaFPLmPW8VvNswpJCV5A415iQWfAuJ9zTcM8mQsxB+6DY5gG6DO/3ymqFg8ZLaularv2
         PYqdep8dhFo8kXwdaCTmP7Ggm/sswaQxrnNhS6PM0MjW4DZ5II+lQAgxJ5v05G9GZysr
         Z09kKDIMGh9U96yty8puRyQZx5pm+cVHebiYSGb/W5v8ZKq6wlUNI3ZwkhkBSriBek7G
         +9lGTCIK1Eh/cSA+1BfF8YXaHyzdcBZ+XIdTjATb4mYTdtC0FgZeC4RmIHwDn0QZ6hAr
         lllw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3/Ga8N5Se9TR1n5VDV57kaqfWCZDfxPiuIZHay3w/+c=;
        b=KU/CSHf6MmhgiEy6k6ALWN3nAIXEInV9wcp56VsGX0P1z+0PWbRfVCdRCGZVXHoPnO
         BtbdaJmkoBMluTRiOUr3xl+VJnI2VdyyY4SN4cAO1GyIOLBQI+ntEcPy7dq+pMO93Ykl
         oF2ATC56MhG+iYoD4aVN8qneXfK4LJZme+UkpbAW4f++JefAmrA9UkTpVKP6cCeGpES9
         4yFRo0eE5yNpaXCKwos6A5ZkaQJxRZN7ssxMGeyeH96pVh+LKq1f8seI9cInXRHiuFZS
         5lU3VXItm0Q1nQv6Iff3da/b2NChDq0YHMnrns2Q0YWkkfo18du/aMygdIJ852vkgELx
         ZD7w==
X-Gm-Message-State: AOAM5333/+tpgQFCZlfO4y9+r+ajd5lEuwQ9uV3QVs+uYj9KiAg3Zs1C
        UuOsCM4VopRRNN1ok2uIBRW+9Lxfad0=
X-Google-Smtp-Source: ABdhPJx2ZmOppSjrrHM5+tC3QwVlAtuCvCErlVAc7g271AEZb6PvnVQuJle9ZYNswDu1eu/9sCGGzw==
X-Received: by 2002:a63:f4a:: with SMTP id 10mr19621121pgp.435.1638813652317;
        Mon, 06 Dec 2021 10:00:52 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u11sm5444070pfg.120.2021.12.06.10.00.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 10:00:51 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     devicetree@vger.kernel.org
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
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:BROADCOM IPROC ARM
        ARCHITECTURE),
        linux-phy@lists.infradead.org (open list:GENERIC PHY FRAMEWORK)
Subject: [PATCH v3 0/8] Broadcom DT bindings conversion to YAML
Date:   Mon,  6 Dec 2021 10:00:41 -0800
Message-Id: <20211206180049.2086907-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

This patch series converts 3 Broadcom Ethernet controller Device Tree
bindings to YAML and the iProc MDIO mux.

These patches should be routed via Rob's Device Tree binding tree since
there are dependencies there such as "dt-bindings: net:
ethernet-controller: add 2.5G and 10G speeds".

Thanks!

Changes in v3:

- rebased against Rob's dt/next branch to remove the first patch
- changed the licensing of the last patch to GPL-2.0 or BSD-2 clause

Changes in v2;

- converted Northstar 2 PCIe binding to YAML as well
- fixed DT_CHECKER_FLAGS=-m warnings
- documented 2500 Mbits/sec for fixed-link

Florian Fainelli (8):
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
 .../bindings/net/ethernet-controller.yaml     |   1 +
 .../bindings/phy/brcm,mdio-mux-bus-pci.txt    |  27 ----
 .../bindings/phy/brcm,ns2-pcie-phy.yaml       |  41 +++++
 MAINTAINERS                                   |   5 +-
 13 files changed, 442 insertions(+), 285 deletions(-)
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

