Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85568468508
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 14:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385070AbhLDNV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 08:21:58 -0500
Received: from mout.kundenserver.de ([217.72.192.73]:35679 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385045AbhLDNVy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 08:21:54 -0500
Received: from localhost.localdomain ([37.4.249.122]) by
 mrelayeu.kundenserver.de (mreue106 [212.227.15.183]) with ESMTPSA (Nemesis)
 id 1MiZof-1mP8G02d4J-00fiiD; Sat, 04 Dec 2021 14:18:07 +0100
From:   Stefan Wahren <stefan.wahren@i2se.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Michael Heimpold <michael.heimpold@in-tech.com>,
        jimmy.shen@vertexcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Stefan Wahren <stefan.wahren@i2se.com>
Subject: [PATCH RFC V2 0/4] add Vertexcom MSE102x support
Date:   Sat,  4 Dec 2021 14:17:47 +0100
Message-Id: <1638623871-21805-1-git-send-email-stefan.wahren@i2se.com>
X-Mailer: git-send-email 2.7.4
X-Provags-ID: V03:K1:ffvfSHiWTAHlAFS5+Gs7RPwQ4rMLlF7b3PA+sKUTs+/eYEazYu6
 hRYtI4dzKJPmjeGSj2jtVnRSw5F5G37ZRHFBJcMHRmijLBe3WdBdfaIBzDGmX93DVKiqcVO
 YwQr7kpQYH7arW3Vd3wAr6exK/8kDrzSMTXLXGJetNXBDjjTEw5ID038TYPHFH1h6E+mYf3
 QBK51F3xvv9X50XdCgBdA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:hcsXOstsG/k=:mAf5V+ozEC7FDtOb3picJi
 vpnNRyneP0GuMfubeagJ+PKp+oOrI/NkbsXlEpaISJr6n6LTMRmMZegXKwKONkqU+oPjaJR3W
 a7PPvPjHRTSMRmQdfHPBJK/yH0aI1Ht/9dAGIGSE98F7n2UolUNsox0VFo4r9ZlQuEVhVC2nD
 6ScBHoU2OJfKQgaAkhzqGtGABi018xDcqVitOigyEyFv+ktPyWVenxHNF47zXrUOUTboY6uY/
 QoIS0Trklw9IEIFlPT5YrBVgayQ0JWQakfN8yR6lnLofbkys9U+uCly4gzTJdZjrW1txMsqrt
 6hTTy516UpE0lCvQcaAFKe0K2qW6xDni5cSOAdaXqqx8weAr6H1QHkV6h/2PiiUjOV2dKibnS
 lgkAFZYLNo+bxuZ1ymu481TdwEkB+LMJkjTklErtPimPuZOsQX/9rY5/DB9fx4vK/FNMrFxTY
 8U/nDIJuUH7Gjbdth3UvFmXCEkKNaSkyWOBZC1V+pSoLPJpCw/L3bvSveiRk9yLKioy/QjMSW
 rLxz5S2Oz2MGLcnjjSvKM27vqA9wFphw5+kMzJexFIjm8hJvSKVr/Xr3IMhPHVKI7Px9GjH6J
 4HL5gZApSSo1+RyotNUimRarZzFoY5n6zPixJhQFUSYH+fUOfJlHOOGb9i9Z8IQdeicap2qcs
 13Fvw4EW+8U59Y3QL19yObMi+ypgxQHMFItsgzfxHcYuPus0qk+J7pyz6q5TIqdNd0txSCa9R
 491NsX8HcN+4aeOI
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds support for the Vertexcom MSE102x Homeplug GreenPHY
chips [1]. They can be connected either via RGMII, RMII or SPI to a host CPU.
These patches handles only the last one, with an Ethernet over SPI protocol
driver.

The code has been tested only on Raspberry Pi boards, but should work
on other platforms.

Any comments about the code are welcome.

Changes in V2:
- improve lock handling for RX & TX path
- add new patch to introduce IF_PORT_HOMEPLUG as suggested by Andrew Lunn
- address all the comments by Jakub Kicinski, Andrew Lunn, Kernel test robot

[1] - http://www.vertexcom.com/p_homeplug_plc_en.html

Stefan Wahren (4):
  dt-bindings: add vendor Vertexcom
  dt-bindings: net: add Vertexcom MSE102x support
  net: introduce media selection IF_PORT_HOMEPLUG
  net: vertexcom: Add MSE102x SPI support

 .../devicetree/bindings/net/vertexcom-mse102x.yaml |  71 ++
 .../devicetree/bindings/vendor-prefixes.yaml       |   2 +
 drivers/net/ethernet/Kconfig                       |   1 +
 drivers/net/ethernet/Makefile                      |   1 +
 drivers/net/ethernet/vertexcom/Kconfig             |  25 +
 drivers/net/ethernet/vertexcom/Makefile            |   6 +
 drivers/net/ethernet/vertexcom/mse102x.c           | 770 +++++++++++++++++++++
 include/uapi/linux/netdevice.h                     |   3 +-
 8 files changed, 878 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/net/vertexcom-mse102x.yaml
 create mode 100644 drivers/net/ethernet/vertexcom/Kconfig
 create mode 100644 drivers/net/ethernet/vertexcom/Makefile
 create mode 100644 drivers/net/ethernet/vertexcom/mse102x.c

-- 
2.7.4

