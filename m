Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25F064645AE
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 05:12:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346513AbhLAEPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 23:15:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346507AbhLAEPy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 23:15:54 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F6BC061574;
        Tue, 30 Nov 2021 20:12:33 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id m15so22196715pgu.11;
        Tue, 30 Nov 2021 20:12:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hB7RjF5Zqk06UnaHimAPbZGbA5Zgh9K2pcqrGIW9790=;
        b=ZwUKltzt7wcl/6iFt6MsHDF3Vx4lJdbMtyYJeis4PMKzSbi2RDu0XYcGuYyj48SRLM
         fHn2l7ClAgB9WOEYpI2w0a/tKy1JAgCWnxa2M/Vz08Z4y/H7G0qG3t5sVmTM9pZQ/ucW
         jMogKF0Md4Mu2y7QZUhVTeSndDB5lAFrjJBUb2wHkN3qCO+NU+UNW1P7afYA15n9IoI4
         IO3yS0xzG50JsfzogbmeK+FkcIUs2+YcBdB3t0L9MHtbr6IP3rpjgPdc5EGDWdUSizw+
         T7ZK/VPFEddQltqRQtWz5LoHf5D+vJC+ps8rQrbouc4ltcfdW8g6srBLh4gT8v1NshD7
         Ve8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hB7RjF5Zqk06UnaHimAPbZGbA5Zgh9K2pcqrGIW9790=;
        b=edtfxQLjDIW4YbdLba+NXTOdMdX8aHtsQk6XUjKqTbCVK7Cwfhc8aGujlac0aYXR9d
         bSJd1OWnaF1Dx4b5XNyD7MdFVR0XJopP4Lma6gPOUtrxGmGvlx1TCN2KtVLLv9eEJgNl
         JQqhRJsoZt3Bq7ioHG2mWGleEe6Rk240mly2i2n+oWz3CYPbGl+nGj+b7CZeW9rHScDe
         q4XMSE77z0jCzJv466qaWIvXA6yNTb3TUYIpm7mIv+g+e0tynKiyVt6zN7Ka3x+SUoB+
         SS25+o+mITVKW15hDRSAF7XRDS31INs9ebZG92emtmhXIKB1Xw5ss/pIh4HCWqG+BbaM
         QTsw==
X-Gm-Message-State: AOAM530DGPi9FsYfUuhOzmjZatFsLg0hBLYwfK6TeGV02nOKwrziDwbl
        fdDwkAQXgA+KB3cZxcrAq0lRpoicgY4=
X-Google-Smtp-Source: ABdhPJx/PeM2SREJeHchU7DrZ2FlQra+UUx52NbkGXe4DJSKCmxVkSQ4KkgX7Aof4ZUOMeZ4htqU9g==
X-Received: by 2002:a65:6251:: with SMTP id q17mr2963493pgv.403.1638331952671;
        Tue, 30 Nov 2021 20:12:32 -0800 (PST)
Received: from 7YHHR73.igp.broadcom.net ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id s8sm4296451pfe.196.2021.11.30.20.12.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 20:12:31 -0800 (PST)
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
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:BROADCOM IPROC ARM
        ARCHITECTURE)
Subject: [PATCH net-next 0/7] Broadcom DT bindings conversion to YAML
Date:   Tue, 30 Nov 2021 20:12:21 -0800
Message-Id: <20211201041228.32444-1-f.fainelli@gmail.com>
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

Florian Fainelli (7):
  dt-bindings: net: brcm,unimac-mdio: reg-names is optional
  dt-bindings: net: brcm,unimac-mdio: Update maintainers for binding
  dt-bindings: net: Document moca PHY interface
  dt-bindings: net: Convert GENET binding to YAML
  dt-bindings: net: Convert AMAC to YAML
  dt-bindings: net: Convert SYSTEMPORT to YAML
  dt-bindings: net: Convert iProc MDIO mux to YAML

 .../devicetree/bindings/net/brcm,amac.txt     |  30 ----
 .../devicetree/bindings/net/brcm,amac.yaml    |  88 +++++++++++
 .../devicetree/bindings/net/brcm,bcmgenet.txt | 125 ---------------
 .../bindings/net/brcm,bcmgenet.yaml           | 146 ++++++++++++++++++
 .../bindings/net/brcm,mdio-mux-iproc.txt      |  62 --------
 .../bindings/net/brcm,mdio-mux-iproc.yaml     |  80 ++++++++++
 .../bindings/net/brcm,systemport.txt          |  38 -----
 .../bindings/net/brcm,systemport.yaml         |  83 ++++++++++
 .../bindings/net/brcm,unimac-mdio.yaml        |   3 +-
 .../bindings/net/ethernet-controller.yaml     |   1 +
 MAINTAINERS                                   |   5 +-
 11 files changed, 403 insertions(+), 258 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/brcm,amac.txt
 create mode 100644 Documentation/devicetree/bindings/net/brcm,amac.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/brcm,bcmgenet.txt
 create mode 100644 Documentation/devicetree/bindings/net/brcm,bcmgenet.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/brcm,mdio-mux-iproc.txt
 create mode 100644 Documentation/devicetree/bindings/net/brcm,mdio-mux-iproc.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/brcm,systemport.txt
 create mode 100644 Documentation/devicetree/bindings/net/brcm,systemport.yaml

-- 
2.25.1

