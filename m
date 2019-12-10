Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F25B119531
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:19:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728773AbfLJVT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:19:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:36354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728637AbfLJVM0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 16:12:26 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFBD82077B;
        Tue, 10 Dec 2019 21:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012345;
        bh=q+Y2FqgyC5P4xznxyYbyo57Frv7m6bD/d91ky37bn4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uANCwYjYJdLZQrchXZdtqx+1HzeYrcxCT4k9nwk6PvUjNEBYe6sfoJQQ7VVmScQyA
         ecSyRAyVxUdHy6QlCaUwMvGGuwO1GZvLdV5XJPi9j50HylvfchARP0hXJu2t027ZD1
         hIpHrnA+u0C/L6GNbxVZMERGEwcU+YckqFKbPVUY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stefan Wahren <wahrenst@gmx.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 276/350] net: bcmgenet: Add RGMII_RXID support
Date:   Tue, 10 Dec 2019 16:06:21 -0500
Message-Id: <20191210210735.9077-237-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
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
index dbe18cdf6c1b8..04a2a2d171136 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -281,6 +281,11 @@ int bcmgenet_mii_config(struct net_device *dev, bool init)
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

