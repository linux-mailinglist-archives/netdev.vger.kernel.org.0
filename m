Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB7A61293F
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 09:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727270AbfECH4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 03:56:55 -0400
Received: from smtp-out.xnet.cz ([178.217.244.18]:44775 "EHLO smtp-out.xnet.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727243AbfECH4x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 May 2019 03:56:53 -0400
Received: from meh.true.cz (meh.true.cz [108.61.167.218])
        (Authenticated sender: petr@true.cz)
        by smtp-out.xnet.cz (Postfix) with ESMTPSA id 407293589;
        Fri,  3 May 2019 09:56:51 +0200 (CEST)
Received: by meh.true.cz (OpenSMTPD) with ESMTP id 7b19b074;
        Fri, 3 May 2019 09:56:50 +0200 (CEST)
From:   =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>
To:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 08/10] staging: octeon-ethernet: support of_get_mac_address new ERR_PTR error
Date:   Fri,  3 May 2019 09:56:05 +0200
Message-Id: <1556870168-26864-9-git-send-email-ynezz@true.cz>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1556870168-26864-1-git-send-email-ynezz@true.cz>
References: <1556870168-26864-1-git-send-email-ynezz@true.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There was NVMEM support added to of_get_mac_address, so it could now
return NULL and ERR_PTR encoded error values, so we need to adjust all
current users of of_get_mac_address to this new fact.

Signed-off-by: Petr Štetiar <ynezz@true.cz>
---
 drivers/staging/octeon/ethernet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/octeon/ethernet.c b/drivers/staging/octeon/ethernet.c
index 986db76..8847a11c2 100644
--- a/drivers/staging/octeon/ethernet.c
+++ b/drivers/staging/octeon/ethernet.c
@@ -421,7 +421,7 @@ int cvm_oct_common_init(struct net_device *dev)
 	if (priv->of_node)
 		mac = of_get_mac_address(priv->of_node);
 
-	if (mac)
+	if (!IS_ERR_OR_NULL(mac))
 		ether_addr_copy(dev->dev_addr, mac);
 	else
 		eth_hw_addr_random(dev);
-- 
1.9.1

