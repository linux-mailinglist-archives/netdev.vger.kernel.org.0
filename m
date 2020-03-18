Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89D8B18A669
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 22:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727745AbgCRVIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 17:08:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:53494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727542AbgCRUyG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 16:54:06 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83F1A20724;
        Wed, 18 Mar 2020 20:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564846;
        bh=QJg5dbPMMfu3F11UcTFkO03F2cyBYQMHfMbgC//ejzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qle7w/cQGeSrdsEzBm/Flc5VE0zOgCE6R26GrhqAhoyEGoawMEsCyghHlrinI2ObG
         t7xnUTH+1smGOsMLByNQGKx/3RkQ04fxeapp1cuuO69zCuXsfAkAQEpIqyev4gLrLx
         KpesF3pJlb3t51M8LDZ/CHgEkis87wujTl4Wvka8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dajun Jin <adajunjin@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 24/73] drivers/of/of_mdio.c:fix of_mdiobus_register()
Date:   Wed, 18 Mar 2020 16:52:48 -0400
Message-Id: <20200318205337.16279-24-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200318205337.16279-1-sashal@kernel.org>
References: <20200318205337.16279-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dajun Jin <adajunjin@gmail.com>

[ Upstream commit 209c65b61d94344522c41a83cd6ce51aac5fd0a4 ]

When registers a phy_device successful, should terminate the loop
or the phy_device would be registered in other addr. If there are
multiple PHYs without reg properties, it will go wrong.

Signed-off-by: Dajun Jin <adajunjin@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/of_mdio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
index bd6129db64178..c34a6df712adb 100644
--- a/drivers/of/of_mdio.c
+++ b/drivers/of/of_mdio.c
@@ -268,6 +268,7 @@ int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
 				rc = of_mdiobus_register_phy(mdio, child, addr);
 				if (rc && rc != -ENODEV)
 					goto unregister;
+				break;
 			}
 		}
 	}
-- 
2.20.1

