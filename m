Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0036D6F289B
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 13:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbjD3Lfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Apr 2023 07:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjD3Lfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Apr 2023 07:35:38 -0400
X-Greylist: delayed 400 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 30 Apr 2023 04:35:35 PDT
Received: from perseus.uberspace.de (perseus.uberspace.de [95.143.172.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29AB02701
        for <netdev@vger.kernel.org>; Sun, 30 Apr 2023 04:35:34 -0700 (PDT)
Received: (qmail 18674 invoked by uid 988); 30 Apr 2023 11:28:52 -0000
Authentication-Results: perseus.uberspace.de;
        auth=pass (plain)
From:   David Bauer <mail@david-bauer.net>
To:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 1/2] mt7530: register OF node for internal MDIO bus
Date:   Sun, 30 Apr 2023 13:28:32 +0200
Message-Id: <20230430112834.11520-1-mail@david-bauer.net>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Bar: /
X-Rspamd-Report: BAYES_HAM(-2.999999) R_MISSING_CHARSET(0.5) MIME_GOOD(-0.1) MID_CONTAINS_FROM(1) SUSPICIOUS_RECIPS(1.5)
X-Rspamd-Score: -0.099999
Received: from unknown (HELO unkown) (::1)
        by perseus.uberspace.de (Haraka/3.0.1) with ESMTPSA; Sun, 30 Apr 2023 13:28:52 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=david-bauer.net; s=uberspace;
        h=from;
        bh=1CwuYfvRbtvDggjy1KUcLv3iiE191S7uqbxY1wuyIr0=;
        b=ZbtXbBd/kO8pqErhBWiIYRRlfZkANNXqJv6XUkTRqVaZ1yUqjgL8WchfyNL9dEf6Z4cnG+WgG7
        zLNfx5NUihvGk9H5Q86mpSU1KLSQE28vE0kNSrJK1bIUV+1/RI5P3zTnsqxH+TxXpITizsg7qH0k
        vnhQhfCJ+KfDN+gqeJt9PmjXNDDatkip7ppHh4hZ0dnjKfJmwlgrxjGE71O+TWVfMqJKyR28YdbW
        kkQ0ffCvMN8QfNKwOQg3YsOFzIg6fLGuI7LoiGwnxm4suFTm+13bFep5CUFynlrB7i4Z06FdZpau
        7L0zaculLlrnKD5Dxd1ekxTIrMytJmYqajs8lt3+M8xnWcd6zqAbjIIaLX9la3SRqG3tJhjdFfPG
        TBJfYCx4nB0N9bFQO80Kq87oGJC/ioubnBiNMBgx5efBrTveLE7L3HjcjcdgJMufGfqUUg4ebTWm
        d+v7+nInuLQ19Tu3blzw6hdeYnfIGojUFqzMnnXG2bNWq1sa0JHUjmCkizBCgFcqeN3AyNTlMUJU
        fb5vBZOt/rR/hOdtDSpjpHNV/FYGXBat+htaDWouyNPHkEBVauYF7w1iIuiRVcrEwYtn2eOMpgNm
        0L5m2CoXibIYntiRa5kMt9uszM/WbeF0NKWWFLrPapQwHOEp4qo9hSff7m6bXPIAokXYYgYsiZXA
        o=
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,MSGID_FROM_MTA_HEADER,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MT753x switches provide a switch-internal MDIO bus for the embedded
PHYs.

Register a OF sub-node on the switch OF-node for this internal MDIO bus.
This allows to configure the embedded PHYs using device-tree.

Signed-off-by: David Bauer <mail@david-bauer.net>
---
 drivers/net/dsa/mt7530.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index c680873819b0..7e8ea5b75c3e 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2119,10 +2119,13 @@ mt7530_setup_mdio(struct mt7530_priv *priv)
 {
 	struct dsa_switch *ds = priv->ds;
 	struct device *dev = priv->dev;
+	struct device_node *np, *mnp;
 	struct mii_bus *bus;
 	static int idx;
 	int ret;
 
+	np = priv->dev->of_node;
+
 	bus = devm_mdiobus_alloc(dev);
 	if (!bus)
 		return -ENOMEM;
@@ -2141,7 +2144,9 @@ mt7530_setup_mdio(struct mt7530_priv *priv)
 	if (priv->irq)
 		mt7530_setup_mdio_irq(priv);
 
-	ret = devm_mdiobus_register(dev, bus);
+	mnp = of_get_child_by_name(np, "mdio");
+	ret = devm_of_mdiobus_register(dev, bus, mnp);
+	of_node_put(mnp);
 	if (ret) {
 		dev_err(dev, "failed to register MDIO bus: %d\n", ret);
 		if (priv->irq)
-- 
2.39.2

