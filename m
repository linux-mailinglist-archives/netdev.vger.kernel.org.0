Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE092417D1C
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 23:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348574AbhIXVqh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 17:46:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343895AbhIXVqg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 17:46:36 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D368DC061571;
        Fri, 24 Sep 2021 14:45:02 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id t1so11124958pgv.3;
        Fri, 24 Sep 2021 14:45:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=Uv269OeTJg43AaEPwcf5zcDpdZuLffPrpQspT2ye6xU=;
        b=GDRkBLmdWxaRhCXbBu7YhAYbfeYGcttFcqZQUt4XlBxNUK35YdxbQMwpUalFFLPftH
         Npc4pW8vwy2T0BUtB9pnp8eJ1Go3CeniD143fA19dgSaDVrKgakxqr02gpM0ABF94Epo
         ugCS6I49c5dluUva4M873P7YRlcsrt+u7TmzTOOBOTlcmd0VodEXJ262iat5DD1UKMXw
         xsRwnWYl492lGYSigCXYojczyGTF6DjE0VQMPttEUwPzTCCJvUDQwVlFR6dGy09ioG7i
         CHaFaSPF1Oyi/g0YhR7QngZ1GewB0EIUwp7Xlsg5wj8jQrGGeHTjIX7raIwL9LsdQR/a
         tu3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Uv269OeTJg43AaEPwcf5zcDpdZuLffPrpQspT2ye6xU=;
        b=tlSMb5uJu1ay+E/f2y6kZZD47C/ZSbXaY+t00cGsr4KwYt8XVRxStkxW3NaegxljlM
         m9G12QoXif18VQp0UkDFUSSboB00fGgfkg24jrMO+4vI5WqNhfkUDy2n6WwZMQZGT++2
         nlj8xzR3dOuwMxrm4O5AOLuJpqd8ZESrMzwC5b9PP9K22hPn7L4Lhb5X474E8VLl6bWm
         J6FVQdIN7ySt0mNCn8NSK3xs6ciBVi6AcxL7PO6ZApPJFAYBfjVG+2iKP3kcM/WqeUN/
         ViHWPDn899Lklv9t+utdjzpo7C1WHg9XfGj3ejYU9THuO0ocfWbGecqVp0KzRlMW1fuD
         jXYQ==
X-Gm-Message-State: AOAM5339CDkvL+9fdwxWhoMCEvyczB2sqqc02JUh8/DhfeTkuGk9Sypo
        yETzrVaCq3MRoMPQUchjgA4/eEPAXR/zTQ==
X-Google-Smtp-Source: ABdhPJwDrhd5pnOFu92NgEERf8Zbyl9RvTTpSJvTXTv8hkVyuO2rcisRSR+OExbhjh244F0cDZqWNg==
X-Received: by 2002:a63:155d:: with SMTP id 29mr5600716pgv.118.1632519901868;
        Fri, 24 Sep 2021 14:45:01 -0700 (PDT)
Received: from stbirv-lnx-2.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id n66sm9842029pfn.142.2021.09.24.14.44.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Sep 2021 14:45:01 -0700 (PDT)
From:   Justin Chen <justinpopo6@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bcm-kernel-feedback-list@broadcom.com,
        Justin Chen <justinpopo6@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Doug Berger <opendmb@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Michael Chan <michael.chan@broadcom.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list),
        linux-media@vger.kernel.org (open list:DMA BUFFER SHARING FRAMEWORK),
        dri-devel@lists.freedesktop.org (open list:DMA BUFFER SHARING FRAMEWORK),
        linaro-mm-sig@lists.linaro.org (moderated list:DMA BUFFER SHARING
        FRAMEWORK)
Subject: [PATCH net-next 0/5] brcm ASP 2.0 Ethernet controller
Date:   Fri, 24 Sep 2021 14:44:46 -0700
Message-Id: <1632519891-26510-1-git-send-email-justinpopo6@gmail.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds support for Broadcom's ASP 2.0 Ethernet controller.

Florian Fainelli (1):
  dt-bindings: net: Brcm ASP 2.0 Ethernet controller

Justin Chen (4):
  dt-bindings: net: brcm,unimac-mdio: Add asp-v2.0
  net: bcmasp: Add support for ASP2.0 Ethernet controller
  net: phy: mdio-bcm-unimac: Add asp v2.0 support
  MAINTAINERS: ASP 2.0 Ethernet driver maintainers

 .../devicetree/bindings/net/brcm,asp-v2.0.yaml     |  147 ++
 .../devicetree/bindings/net/brcm,unimac-mdio.yaml  |    1 +
 MAINTAINERS                                        |    9 +
 drivers/net/ethernet/broadcom/Kconfig              |   11 +
 drivers/net/ethernet/broadcom/Makefile             |    1 +
 drivers/net/ethernet/broadcom/asp2/Makefile        |    2 +
 drivers/net/ethernet/broadcom/asp2/bcmasp.c        | 1351 +++++++++++++++++++
 drivers/net/ethernet/broadcom/asp2/bcmasp.h        |  565 ++++++++
 .../net/ethernet/broadcom/asp2/bcmasp_ethtool.c    |  628 +++++++++
 drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c   | 1414 ++++++++++++++++++++
 .../net/ethernet/broadcom/asp2/bcmasp_intf_defs.h  |  187 +++
 drivers/net/mdio/mdio-bcm-unimac.c                 |    1 +
 12 files changed, 4317 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/brcm,asp-v2.0.yaml
 create mode 100644 drivers/net/ethernet/broadcom/asp2/Makefile
 create mode 100644 drivers/net/ethernet/broadcom/asp2/bcmasp.c
 create mode 100644 drivers/net/ethernet/broadcom/asp2/bcmasp.h
 create mode 100644 drivers/net/ethernet/broadcom/asp2/bcmasp_ethtool.c
 create mode 100644 drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
 create mode 100644 drivers/net/ethernet/broadcom/asp2/bcmasp_intf_defs.h

-- 
2.7.4

