Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDE888C8F1
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 04:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728503AbfHNCfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 22:35:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:45664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728362AbfHNCNj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 22:13:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 436442084F;
        Wed, 14 Aug 2019 02:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565748819;
        bh=tT82xRkihxHI2sedOcvsSUDg84D0mqteRBZHZJaYlo0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DSEp/C9L1JxgyuMmUwJu4ZsxitCE6y4h84BllAnFfTP6s/purZuozOTF8f0gVt1Vh
         hzmGHl3D5IUAeAnRPhvBWmWDzmonX3OHpH4+yEooOkXUr7JKISTx1dJOqXwyIy2FJH
         FDjwypHw/9sltl65QEYqEtTm0uYcCA23Q/ScMLOg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 079/123] enetc: Select PHYLIB while CONFIG_FSL_ENETC_VF is set
Date:   Tue, 13 Aug 2019 22:10:03 -0400
Message-Id: <20190814021047.14828-79-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021047.14828-1-sashal@kernel.org>
References: <20190814021047.14828-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 2802d2cf24b1ca7ea4c54dde266ded6a16020eb5 ]

Like FSL_ENETC, when CONFIG_FSL_ENETC_VF is set,
we should select PHYLIB, otherwise building still fails:

drivers/net/ethernet/freescale/enetc/enetc.o: In function `enetc_open':
enetc.c:(.text+0x2744): undefined reference to `phy_start'
enetc.c:(.text+0x282c): undefined reference to `phy_disconnect'
drivers/net/ethernet/freescale/enetc/enetc.o: In function `enetc_close':
enetc.c:(.text+0x28f8): undefined reference to `phy_stop'
enetc.c:(.text+0x2904): undefined reference to `phy_disconnect'
drivers/net/ethernet/freescale/enetc/enetc_ethtool.o:(.rodata+0x3f8): undefined reference to `phy_ethtool_get_link_ksettings'
drivers/net/ethernet/freescale/enetc/enetc_ethtool.o:(.rodata+0x400): undefined reference to `phy_ethtool_set_link_ksettings'

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: d4fd0404c1c9 ("enetc: Introduce basic PF and VF ENETC ethernet drivers")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/freescale/enetc/Kconfig b/drivers/net/ethernet/freescale/enetc/Kconfig
index 8ac109e73a7bb..a268e74b1834e 100644
--- a/drivers/net/ethernet/freescale/enetc/Kconfig
+++ b/drivers/net/ethernet/freescale/enetc/Kconfig
@@ -13,6 +13,7 @@ config FSL_ENETC
 config FSL_ENETC_VF
 	tristate "ENETC VF driver"
 	depends on PCI && PCI_MSI && (ARCH_LAYERSCAPE || COMPILE_TEST)
+	select PHYLIB
 	help
 	  This driver supports NXP ENETC gigabit ethernet controller PCIe
 	  virtual function (VF) devices enabled by the ENETC PF driver.
-- 
2.20.1

