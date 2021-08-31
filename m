Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47BDF3FCDE2
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 22:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240827AbhHaTfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 15:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239210AbhHaTfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 15:35:37 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC60C061760
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 12:34:41 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id c129-20020a1c35870000b02902e6b6135279so300510wma.0
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 12:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gCKmSK8tJyGyjy1KDjrNXNc5xFC9cf88E1v15sSABiw=;
        b=kk8mMUnBToKUgloCDsKsDHAmxDrzaPoeyu5MBvvdc2mX30tR53u5VmfGuvM95N1BHi
         ER9lsdhneD93owQMUCvSeK76ZjndN14qNCYAwMJk0smutQ2s2d5AmVMLH3nVzV0+1Oog
         8Ecp+nU0NAExC3qNXTFuRJux6XtWCJMfDiobRr465/kCvCyD4l9JxORdP6UjTE1gBNZb
         tHvtlpGvdelOHiVJ3LdCSPQYUQ0gRKuL+uEsdujZ5it82y2klIblC9hMnGyNeivgWxE+
         2Yom4VA/FQksUtapPlQExcLRkte9hBklyHJ6hyUIfrSpzL8pg7+1YOCHtRRTX+NWlPZp
         oydQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gCKmSK8tJyGyjy1KDjrNXNc5xFC9cf88E1v15sSABiw=;
        b=bZ7kRISTfAmz8VqiXcNoW8Zygt7eAqJ9eq7pBzu50m1BVuBPxkVhbslUPwkTtjmB+g
         9AUlCBBLedjedyjKl8BfaaEWeV3dhm8KZ6ySSQksp2iY3Nb0nxA2wZ34NYWQAOAZWG4p
         DN4PCqRbm0zQzPqlvLRvm2bAqVIpssL/4NFIveev60rOe1qRBYPtGiMa5NpILu0JTewk
         c4TXMczOja25h7BPh96S0RA+6XMK64dTdAEn4adXwvX4yg/WUwtWpZ5BF44h2ZFnv7/f
         S2uOlOGxw+u1XGw7PSCSuwMj+vfCBdy2rwUh1BocqIs0TL4TDF/S8I6Z2FCVdM+afKuF
         byQA==
X-Gm-Message-State: AOAM531uT+lgadSo4mWUrj/uK/3+fEKacQq27ge6Md4SoeBVal4S/9yN
        J43lsM1Q9hcQ4YGmoW1pQfOsWJkvysS51/mH2C8qbw==
X-Google-Smtp-Source: ABdhPJxAWbZiz9taMTujZGFGlmjyd+VIxuOVPHSFR8nRrYJ3u2Tvqhb+ABuQ2aQc/+zNRZYLFEExYw==
X-Received: by 2002:a05:600c:206:: with SMTP id 6mr5913703wmi.178.1630438480223;
        Tue, 31 Aug 2021 12:34:40 -0700 (PDT)
Received: from hornet.engleder.at (dynamic-2el0lv6sxxeorz8a81-pd01.res.v6.highway.a1.net. [2001:871:23a:b9:6e3b:e5ff:fe2c:34c1])
        by smtp.gmail.com with ESMTPSA id n4sm18708324wri.78.2021.08.31.12.34.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 12:34:39 -0700 (PDT)
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        robh+dt@kernel.org, michal.simek@xilinx.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v2 0/3] TSN endpoint Ethernet MAC driver
Date:   Tue, 31 Aug 2021 21:34:22 +0200
Message-Id: <20210831193425.26193-1-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds a driver for my FPGA based TSN endpoint Ethernet MAC.
It also includes the device tree binding.

The device is designed as Ethernet MAC for TSN networks. It will be used
in PLCs with real-time requirements up to isochronous communication with
protocols like OPC UA Pub/Sub.

I'm looking forward to your comments!

v2:
 - add C45 check (Andrew Lunn)
 - forward phy_connect_direct() return value (Andrew Lunn)
 - use phy_remove_link_mode() (Andrew Lunn)
 - do not touch PHY directly, use PHY subsystem (Andrew Lunn)
 - remove management data lock (Andrew Lunn)
 - use phy_loopback (Andrew Lunn)
 - remove GMII2RGMII handling, use xgmiitorgmii (Andrew Lunn)
 - remove char device for direct TX/RX queue access (Andrew Lunn)
 - mdio node for mdiobus (Rob Herring)
 - simplify compatible node (Rob Herring)
 - limit number of items of reg and interrupts nodes (Rob Herring)
 - restrict phy-connection-type node (Rob Herring)
 - reference to mdio.yaml under mdio node (Rob Herring)
 - remove device tree (Michal Simek)
 - fix %llx warning (kernel test robot)
 - fix unused tmp variable warning (kernel test robot)
 - add missing of_node_put() for of_parse_phandle()
 - use devm_mdiobus_alloc()
 - simplify mdiobus read/write
 - reduce required nodes
 - ethtool priv flags interface for loopback
 - add missing static for some functions
 - remove obsolete hardware defines

Gerhard Engleder (3):
  dt-bindings: Add vendor prefix for Engleder
  dt-bindings: net: Add tsnep Ethernet controller
  tsnep: Add TSN endpoint Ethernet MAC driver

 .../bindings/net/engleder,tsnep.yaml          |   78 ++
 .../devicetree/bindings/vendor-prefixes.yaml  |    2 +
 drivers/net/ethernet/Kconfig                  |    1 +
 drivers/net/ethernet/Makefile                 |    1 +
 drivers/net/ethernet/engleder/Kconfig         |   28 +
 drivers/net/ethernet/engleder/Makefile        |    9 +
 drivers/net/ethernet/engleder/tsnep.h         |  166 +++
 drivers/net/ethernet/engleder/tsnep_ethtool.c |  382 +++++
 drivers/net/ethernet/engleder/tsnep_hw.h      |  236 ++++
 drivers/net/ethernet/engleder/tsnep_main.c    | 1227 +++++++++++++++++
 drivers/net/ethernet/engleder/tsnep_ptp.c     |  221 +++
 drivers/net/ethernet/engleder/tsnep_tc.c      |  442 ++++++
 drivers/net/ethernet/engleder/tsnep_test.c    |  811 +++++++++++
 13 files changed, 3604 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/engleder,tsnep.yaml
 create mode 100644 drivers/net/ethernet/engleder/Kconfig
 create mode 100644 drivers/net/ethernet/engleder/Makefile
 create mode 100644 drivers/net/ethernet/engleder/tsnep.h
 create mode 100644 drivers/net/ethernet/engleder/tsnep_ethtool.c
 create mode 100644 drivers/net/ethernet/engleder/tsnep_hw.h
 create mode 100644 drivers/net/ethernet/engleder/tsnep_main.c
 create mode 100644 drivers/net/ethernet/engleder/tsnep_ptp.c
 create mode 100644 drivers/net/ethernet/engleder/tsnep_tc.c
 create mode 100644 drivers/net/ethernet/engleder/tsnep_test.c

-- 
2.20.1

