Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2EE411984C
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:39:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728698AbfLJVig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:38:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:40838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730203AbfLJVfO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 16:35:14 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5367205C9;
        Tue, 10 Dec 2019 21:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576013713;
        bh=uMzTj59C+aYkV51XN2tz7lF9MA0IC/TM/rAz6NoK6Mo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WS0THuoaV3TiK1s28d5yuSghdA13qxo82MrpMZnZpCFOelwQhjy+GzOy4JVa7K26U
         +g81dGdvZRsxtBN53kqUvuAww5Rso3xcFQ4ms+mV/HaMd01EqvztFCYwVlNJ7GChAN
         Bdc3aP3CzdMLvTPsL9P4PWfLLVez4E9PES5oLrEQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stefan Wahren <wahrenst@gmx.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 141/177] net: bcmgenet: Add RGMII_RXID support
Date:   Tue, 10 Dec 2019 16:31:45 -0500
Message-Id: <20191210213221.11921-141-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210213221.11921-1-sashal@kernel.org>
References: <20191210213221.11921-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Wahren <wahrenst@gmx.net>

[ Upstream commit da38802211cc3fd294211a642932edb09e3af632 ]

This adds the missing support for the PHY mode RGMII_RXID.
It's necessary for the Raspberry Pi 4.

Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmmii.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
index a5049d637791d..10dcf8cb523f2 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -283,6 +283,11 @@ int bcmgenet_mii_config(struct net_device *dev, bool init)
 		bcmgenet_sys_writel(priv,
 				    PORT_MODE_EXT_GPHY, SYS_PORT_CTRL);
 		break;
+
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+		phy_name = "external RGMII (RX delay)";
+		port_ctrl = PORT_MODE_EXT_GPHY;
+		break;
 	default:
 		dev_err(kdev, "unknown phy mode: %d\n", priv->phy_interface);
 		return -EINVAL;
-- 
2.20.1

