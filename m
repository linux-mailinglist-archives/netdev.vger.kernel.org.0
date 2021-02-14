Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A35F31AEA3
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 02:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbhBNBR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 20:17:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbhBNBR6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 20:17:58 -0500
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 102CDC061574;
        Sat, 13 Feb 2021 17:17:18 -0800 (PST)
Received: from mwalle01.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:fa59:71ff:fe9b:b851])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 18F0223E55;
        Sun, 14 Feb 2021 02:17:16 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1613265436;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ZXOO60f6gZRL00iZbad8nxEVcghn0+AbZN/JpgeY/2o=;
        b=nLBPApdIb4QEzWYYYLjADSFAWkxQUdUS0FprqmbpPGTEsFXVv+qLlvL2/Yoxij0F0jae5x
        3MCb1Gs4tcoMUkokwAZ23sGpVhFiAMgv0US8EXY+nmdV7wR9uclMFSyP/EkMHqDGSSuWgD
        INz+Ys2tHpWuZr7sPEdExN/8wr9vw0A=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next] net: phy: at803x: add MDIX support to AR8031/33
Date:   Sun, 14 Feb 2021 02:17:11 +0100
Message-Id: <20210214011711.12428-1-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

AR8035 recently gained MDIX support. The same functions will work for
the AR8031/33 PHY. We just need to add the at803x_config_aneg()
callback.

This was tested on a Kontron sl28 board.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/at803x.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index d67bddc111e3..c2aa4c92edde 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -1190,6 +1190,7 @@ static struct phy_driver at803x_driver[] = {
 	.probe			= at803x_probe,
 	.remove			= at803x_remove,
 	.config_init		= at803x_config_init,
+	.config_aneg		= at803x_config_aneg,
 	.soft_reset		= genphy_soft_reset,
 	.set_wol		= at803x_set_wol,
 	.get_wol		= at803x_get_wol,
-- 
2.20.1

