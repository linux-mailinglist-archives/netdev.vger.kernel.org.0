Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0EA3D6797
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 21:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231935AbhGZTBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 15:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbhGZTBB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 15:01:01 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14062C061757
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 12:41:30 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id m20-20020a05600c4f54b029024e75a15716so744131wmq.2
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 12:41:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MJXXcLnerKpTNRxDFe7O8JOmqy5p+3SB0+PIr1UG0EY=;
        b=S4aDBdKLwDslmgoRtjcf49Ad2VLoO7vAJuQ+UNOgCpRDniAiZObwzyYXxUnF/RrarW
         O7XsSNpI+W2nOls49vQWPpg5qSHULQsnJb64Om6PuMU2eLQILxr6ftGl5vv/kvqND7Bm
         EOxAaQfmsaBbOAsmgjiC8sjZEYTgk0f1aRp8ZY7o3+9LItYjurB3uzYdx9cFq8iLH95Q
         s4vKuilFeFyLKCfxc/DesDi0/LuAdXIlQX48mjnNvqUP/3b2b48VfrosCYQxzcBc6rC3
         Pe0GtJGB7+9o7OnX+y74PkPcCzDMp/fnyVN6E3iDy2kOS1KPF21oym1QSvey7UTLUNbv
         J61A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MJXXcLnerKpTNRxDFe7O8JOmqy5p+3SB0+PIr1UG0EY=;
        b=Pd7Qjk+Zp6WEOWANw4A44cXZqCzuyItxs8HwssiP/KgqCC0vtnHfKQnZQYlwVGVc0z
         DpaUhUZTPUkb0tsoGnATAjQIctgt3zoRQGluZvM5yUQbH7BY+Vyk/EBUriswddkGeUyC
         bSal+vi3l9E75Kzts0yi8CZSFCqzaKzdCLe7N+xWwdHnDeJImWazeEk+lXLBPJkl7+Uu
         f2jEUqH/ltUXnGgufM6yG/ra83BiuiUtmCttQYtRdflStpDdLPb6nlOHPbsyUMK08+zd
         BlsU+yVr8sTIgvfl47EBc76M+ppK/KrJ2Dm/kyCxGUQRBpY8HNOesz8XCcED9oxlOcCM
         JK5w==
X-Gm-Message-State: AOAM531sYMjsCMkERKkFa/n9dMoiLPE84NaFpNS9afjvdIl45wR2WiG/
        9P+4Zl04wTxtMKkPdPr+iFGKZw==
X-Google-Smtp-Source: ABdhPJz7FjYqhwHlmO9VXwDsCeKr0G1x1xvGc6F2Y+SCN59kvVYk+q9fUZWE3AFKKifavS23x7nCyw==
X-Received: by 2002:a7b:c083:: with SMTP id r3mr18584690wmh.97.1627328488592;
        Mon, 26 Jul 2021 12:41:28 -0700 (PDT)
Received: from hornet.engleder.at (dynamic-2f5ziwnqeg6t9oqqip-pd01.res.v6.highway.a1.net. [2001:871:23d:d66a:6e3b:e5ff:fe2c:34c1])
        by smtp.gmail.com with ESMTPSA id d18sm945285wrp.54.2021.07.26.12.41.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 12:41:28 -0700 (PDT)
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        michal.simek@xilinx.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v3 0/5] TSN endpoint Ethernet MAC driver
Date:   Mon, 26 Jul 2021 21:40:31 +0200
Message-Id: <20210726194036.14516-1-gerhard@engleder-embedded.com>
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

