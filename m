Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C615E1BCE38
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 23:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbgD1VJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 17:09:06 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:56553 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726274AbgD1VJF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 17:09:05 -0400
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 4647622723;
        Tue, 28 Apr 2020 23:09:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1588108143;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=gpXkJHqGGtoLi/kTvzdyHQl12eg8hljlk1ZvOexWd90=;
        b=jLu6pGscUtllUyNxifoqVueP+QDLn1cmyqVo3oHxPIU0sM+KsWQBoo/hSq4/G4dAssjZrR
        g2wMGGOwzHpzaLrZK0t83/E9F8YxMC712ZklrCrLbNiOQ3Bp/rwejjyrIQgpOnKKCF7Zhs
        EY69vpNTaG7lWWFM8AvPOVXb4qKdQKg=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 1/4] net: phy: bcm54140: use genphy_soft_reset()
Date:   Tue, 28 Apr 2020 23:08:51 +0200
Message-Id: <20200428210854.28088-1-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: ++++++
X-Spam-Level: ******
X-Rspamd-Server: web
X-Spam-Status: Yes, score=6.40
X-Spam-Score: 6.40
X-Rspamd-Queue-Id: 4647622723
X-Spamd-Result: default: False [6.40 / 15.00];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         R_MISSING_CHARSET(2.50)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         BROKEN_CONTENT_TYPE(1.50)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         DKIM_SIGNED(0.00)[];
         RCPT_COUNT_SEVEN(0.00)[8];
         MID_CONTAINS_FROM(1.00)[];
         RCVD_COUNT_ZERO(0.00)[0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:31334, ipnet:2a02:810c:8000::/33, country:DE];
         FREEMAIL_CC(0.00)[lunn.ch,gmail.com,armlinux.org.uk,davemloft.net,walle.cc];
         SUSPICIOUS_RECIPS(1.50)[]
X-Spam: Yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set the .soft_reset() op to be sure there will be a reset even if there
is no hardware reset line registered.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/bcm54140.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/bcm54140.c b/drivers/net/phy/bcm54140.c
index 7341f0126cc4..eb5dbacc1253 100644
--- a/drivers/net/phy/bcm54140.c
+++ b/drivers/net/phy/bcm54140.c
@@ -862,6 +862,7 @@ static struct phy_driver bcm54140_drivers[] = {
 		.probe		= bcm54140_probe,
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
+		.soft_reset	= genphy_soft_reset,
 		.get_tunable	= bcm54140_get_tunable,
 		.set_tunable	= bcm54140_set_tunable,
 	},
-- 
2.20.1

