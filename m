Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C406CE5AE4
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 15:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbfJZNSo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 09:18:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:40572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727977AbfJZNSn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 09:18:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FF8F222C3;
        Sat, 26 Oct 2019 13:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572095922;
        bh=Mm9kL3fTKhgVCOwa1CZY+whzW4MSgMeJVzsd4BL9wTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=avFUM/b1aPw+p3GL/waA+mwelUWoE0t4Fefb/ZjmxeiKMUj3Kc415QrIr1xPQ2QKw
         tgEOu06vo1V5lfkP0xGiCwsURiCFnhG8+/L9vIxm4/jRE+t6ItvRXaiC585/US1yf5
         i9SF9Prhnw7vzthlnNrOh5J9YZNFLs5YnrwYAWOE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 91/99] net: phy: bcm7xxx: define soft_reset for 40nm EPHY
Date:   Sat, 26 Oct 2019 09:15:52 -0400
Message-Id: <20191026131600.2507-91-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026131600.2507-1-sashal@kernel.org>
References: <20191026131600.2507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Doug Berger <opendmb@gmail.com>

[ Upstream commit fe586b823372a9f43f90e2c6aa0573992ce7ccb7 ]

The internal 40nm EPHYs use a "Workaround for putting the PHY in
IDDQ mode." These PHYs require a soft reset to restore functionality
after they are powered back up.

This commit defines the soft_reset function to use genphy_soft_reset
during phy_init_hw to accommodate this.

Fixes: 6e2d85ec0559 ("net: phy: Stop with excessive soft reset")
Signed-off-by: Doug Berger <opendmb@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/bcm7xxx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/bcm7xxx.c b/drivers/net/phy/bcm7xxx.c
index 8fc33867e524f..af8eabe7a6d44 100644
--- a/drivers/net/phy/bcm7xxx.c
+++ b/drivers/net/phy/bcm7xxx.c
@@ -572,6 +572,7 @@ static int bcm7xxx_28nm_probe(struct phy_device *phydev)
 	.name           = _name,					\
 	/* PHY_BASIC_FEATURES */					\
 	.flags          = PHY_IS_INTERNAL,				\
+	.soft_reset	= genphy_soft_reset,				\
 	.config_init    = bcm7xxx_config_init,				\
 	.suspend        = bcm7xxx_suspend,				\
 	.resume         = bcm7xxx_config_init,				\
-- 
2.20.1

