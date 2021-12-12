Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCEB7471AF5
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 15:51:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231490AbhLLOvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Dec 2021 09:51:10 -0500
Received: from mout.kundenserver.de ([212.227.126.133]:53577 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbhLLOvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Dec 2021 09:51:10 -0500
Received: from localhost.localdomain ([37.4.249.122]) by
 mrelayeu.kundenserver.de (mreue011 [212.227.15.167]) with ESMTPSA (Nemesis)
 id 1Ml6Zo-1mFgSF3iTE-00lV0Q; Sun, 12 Dec 2021 15:50:52 +0100
From:   Stefan Wahren <stefan.wahren@i2se.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Michael Heimpold <michael.heimpold@in-tech.com>,
        jimmy.shen@vertexcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Stefan Wahren <stefan.wahren@i2se.com>
Subject: [PATCH V3 net-next 0/3] add Vertexcom MSE102x support
Date:   Sun, 12 Dec 2021 15:50:24 +0100
Message-Id: <1639320627-8827-1-git-send-email-stefan.wahren@i2se.com>
X-Mailer: git-send-email 2.7.4
X-Provags-ID: V03:K1:GJh4fm4EpN0K6GFNPRY/uDvzyy2OkqlZ8LEH7QXzJhIOasDfRtY
 7WnKoPiSz1W92QCIAQpT1+2YSSJkqXZ2fwypClcRCeIfjphG1ZZDTXzl08r7aOO4rRjiyaq
 clpieYIevXGqmC+s3yLE5bIPMF2E/4HxC9rupnIIlR+J/hE+LhwJqrFIEwf7NRdmBaWBgCh
 G4RTQTVDVJwAvDI1voWAQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:CgJ334s95G8=:bD1Gu4OA1VSXn+Va5Q/NwF
 Tpomza+H3f0ZUJkuv3iKk1b6qO8myljZjNxrV0B0RgSfDQWNQoxaPUYOWlw+DtaBkW1Yfrxwo
 xDfvys+iAA8WjRZY11OmkUelpx0MGR0t+BePF6LlQokzucBCoRQwk3gVijbTCxmBP4LxePJW0
 yIIzEyiZqjWVMowyzX4c154iq5EVEF+9LBKl3oCLk+KKORm5ZZLaXMIbneUjq2VdnxT+UbIyV
 ga35RL4F26mX+8h/EW7IxZJpt25d21wAlo2VAXSbk2nCyAm2GTZuHTy9bA1rXF8b/Ni56NcZf
 g6s+Mch3Py/Nuut7VuwAGrjST7LlSxtsiTswhV/eG4qV1BdnIsKZ1T5dcMBKQBcjSztmvcZL5
 0mcoq6Ds8mToxZwCINDyjfRsr4Xu6iu8z09QO584+MXqoSP1ERNS2USbOogjHXP8lrvUHvVSN
 7oG5r7Nl5oWmxYhPOyV3DMy9jyCxGlyYNdWHMmIjb70inn4XLGCsjf/FkZOWYKCZa7MnKMXcL
 IAwSYPkpyY2VLkp+0Thipc1t2tiODqk64aK6PHxn2PdnmaD7F7N7gy4TY+GheYAu/5oBZM5Vw
 /EtCvcFvvfGH6FPbvrOzy5UhZuOzLuIw9tJrw5z8PBHCPNEwjjSdnSlCpxxkVx8FqhP5R7U5o
 uWgr4lGpjL+cuFcqASbsVUify3OhTdZw4PtFpyhMA7G0HnIEVBCDylbIAHSeXLF+TfQRoLktP
 BqcyYZibmiLz7Luy
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds support for the Vertexcom MSE102x Homeplug GreenPHY
chips [1]. They can be connected either via RGMII, RMII or SPI to a host CPU.
These patches handles only the last one, with an Ethernet over SPI protocol
driver.

The code has been tested only on Raspberry Pi boards, but should work
on other platforms.

Changes in V3:
- drop IF_PORT_HOMEPLUG again, since it's actually not used

Changes in V2:
- improve lock handling for RX & TX path
- add new patch to introduce IF_PORT_HOMEPLUG as suggested by Andrew Lunn
- address all the comments by Jakub Kicinski, Andrew Lunn, Kernel test robot

[1] - http://www.vertexcom.com/p_homeplug_plc_en.html

Stefan Wahren (3):
  dt-bindings: add vendor Vertexcom
  dt-bindings: net: add Vertexcom MSE102x support
  net: vertexcom: Add MSE102x SPI support

 .../devicetree/bindings/net/vertexcom-mse102x.yaml |  71 ++
 .../devicetree/bindings/vendor-prefixes.yaml       |   2 +
 drivers/net/ethernet/Kconfig                       |   1 +
 drivers/net/ethernet/Makefile                      |   1 +
 drivers/net/ethernet/vertexcom/Kconfig             |  25 +
 drivers/net/ethernet/vertexcom/Makefile            |   6 +
 drivers/net/ethernet/vertexcom/mse102x.c           | 769 +++++++++++++++++++++
 7 files changed, 875 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/vertexcom-mse102x.yaml
 create mode 100644 drivers/net/ethernet/vertexcom/Kconfig
 create mode 100644 drivers/net/ethernet/vertexcom/Makefile
 create mode 100644 drivers/net/ethernet/vertexcom/mse102x.c

-- 
2.7.4

