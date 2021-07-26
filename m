Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B63573D67A2
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 21:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbhGZTFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 15:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbhGZTFu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 15:05:50 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EB6AC061757
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 12:46:18 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id l4-20020a05600c1d04b02902506f89ad2dso592821wms.1
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 12:46:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kS6DThdwONy7bn46R5FPG2YNX/UeRY/RXsX9FiHrx/E=;
        b=eH7Ho7iVscBE+beTYmPPw52nnjDr+uQw2C3i5bUsk3pG4rKQMksCfoOVvtV/jhPxBq
         9B6gDMjQd1/C6Kx9qGXF4TJzsc220/AU6IB4BKirSJ5Ruek7DhHwGccgC+aDcZufZ7MQ
         IekaGC0zg/S/fhyEQxDJj6rTDsP2hkfVuaEuC4V/XqGHESoFPdz6QeUoo8k4HP4LBMbF
         XCWD7B1Jn8PPnq8niNUxM+1REap3aO6YtGzz/cND+T5xV2YDQn/ZnbsetXXbZzF9ORWb
         sJkodPc7v/XICq3YZBtJBWMHQUXDleu5p4gjajtQzRAJMUvNaowWTEEtl9Q1FLvJSYwK
         /rHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kS6DThdwONy7bn46R5FPG2YNX/UeRY/RXsX9FiHrx/E=;
        b=OaLBcxpdEFRAaIMI89ONAHtCr9WAaY9heblNwm7/I/GdgteipYO+VyilfwpvqhRowD
         HlIeUweMleU3lsj1VXtUB2QLSHaKSURWUJMKbklVQl39rjyT+oZyIKw29/scm5XtwBAA
         QtAxwqYogr9yeX74a9NAQ9SRvq1z/1utNoQCQ2YoSKYEcLytcr0O7hCw1FRMEA2SDCPP
         rRzLjaqDQCPKUIl95RAy80OToyrAaZCD5ouYJG0KCkoG6Rcp3suI4yM9lIpIeVQGd+TC
         WiX8ICLs56uMbVr3nEgzHHWqAshJrHqfvSoQG0btXGCizjgNp7ghwJfX3BBB/BHrkLAx
         kB5w==
X-Gm-Message-State: AOAM5311YoJ1GIfRBhcjf8Y/jX7YQHy3OccoOq/Wj/Mz0RAofGxAyBIA
        J8MJuS4+xbkX9EzfL3crOtw7jw==
X-Google-Smtp-Source: ABdhPJwEiuyxtg+2NvIBSwqFeG4a70UOuj7b+wFEdYRq3zADuaq9ZVg01wiF14OFAPczbzlpHHNjxw==
X-Received: by 2002:a05:600c:1993:: with SMTP id t19mr18576775wmq.62.1627328776328;
        Mon, 26 Jul 2021 12:46:16 -0700 (PDT)
Received: from hornet.engleder.at (dynamic-2f5ziwnqeg6t9oqqip-pd01.res.v6.highway.a1.net. [2001:871:23d:d66a:6e3b:e5ff:fe2c:34c1])
        by smtp.gmail.com with ESMTPSA id r4sm741528wre.84.2021.07.26.12.46.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 12:46:15 -0700 (PDT)
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        michal.simek@xilinx.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next 0/5] TSN endpoint Ethernet MAC driver
Date:   Mon, 26 Jul 2021 21:45:58 +0200
Message-Id: <20210726194603.14671-1-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds a driver for my FPGA based TSN endpoint Ethernet MAC.
It also includes device tree binding and a device tree for the reference
platform.

The device is designed as Ethernet MAC for TSN networks. It will be used
in PLCs with real-time requirements up to isochronous communication with
protocols like OPC UA Pub/Sub.

Sorry for the wrong v3 message before this message!

I'm looking forward to your comments!

Gerhard Engleder (5):
  dt-bindings: Add vendor prefix for Engleder
  dt-bindings: net: Add tsnep Ethernet controller
  dt-bindings: arm: Add Engleder bindings
  tsnep: Add TSN endpoint Ethernet MAC driver
  arm64: dts: zynqmp: Add ZCU104 based TSN endpoint

 .../devicetree/bindings/arm/engleder.yaml     |   22 +
 .../bindings/net/engleder,tsnep.yaml          |   77 +
 .../devicetree/bindings/vendor-prefixes.yaml  |    2 +
 arch/arm64/boot/dts/xilinx/Makefile           |    1 +
 arch/arm64/boot/dts/xilinx/zynqmp-tsnep.dts   |   50 +
 drivers/net/ethernet/Kconfig                  |    1 +
 drivers/net/ethernet/Makefile                 |    1 +
 drivers/net/ethernet/engleder/Kconfig         |   28 +
 drivers/net/ethernet/engleder/Makefile        |    9 +
 drivers/net/ethernet/engleder/tsnep.h         |  199 +++
 drivers/net/ethernet/engleder/tsnep_ethtool.c |  287 ++++
 drivers/net/ethernet/engleder/tsnep_hw.h      |  276 ++++
 drivers/net/ethernet/engleder/tsnep_main.c    | 1418 +++++++++++++++++
 drivers/net/ethernet/engleder/tsnep_ptp.c     |  224 +++
 drivers/net/ethernet/engleder/tsnep_stream.c  |  489 ++++++
 drivers/net/ethernet/engleder/tsnep_tc.c      |  443 +++++
 drivers/net/ethernet/engleder/tsnep_test.c    |  811 ++++++++++
 17 files changed, 4338 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/engleder.yaml
 create mode 100644 Documentation/devicetree/bindings/net/engleder,tsnep.yaml
 create mode 100644 arch/arm64/boot/dts/xilinx/zynqmp-tsnep.dts
 create mode 100644 drivers/net/ethernet/engleder/Kconfig
 create mode 100644 drivers/net/ethernet/engleder/Makefile
 create mode 100644 drivers/net/ethernet/engleder/tsnep.h
 create mode 100644 drivers/net/ethernet/engleder/tsnep_ethtool.c
 create mode 100644 drivers/net/ethernet/engleder/tsnep_hw.h
 create mode 100644 drivers/net/ethernet/engleder/tsnep_main.c
 create mode 100644 drivers/net/ethernet/engleder/tsnep_ptp.c
 create mode 100644 drivers/net/ethernet/engleder/tsnep_stream.c
 create mode 100644 drivers/net/ethernet/engleder/tsnep_tc.c
 create mode 100644 drivers/net/ethernet/engleder/tsnep_test.c

-- 
2.20.1

