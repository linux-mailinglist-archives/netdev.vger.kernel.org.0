Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7B949F823
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 12:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348152AbiA1LUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 06:20:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348128AbiA1LUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 06:20:11 -0500
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [IPv6:2001:4b98:dc4:8::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E158FC061714;
        Fri, 28 Jan 2022 03:20:10 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 13E28100002;
        Fri, 28 Jan 2022 11:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1643368809;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ATxe8qBL+VheL5575a2nbwFegp1GRZ6tMQh4RRJj2xM=;
        b=pVsPI0UZ9EL788Af5Kkq2L1Lcj7GZUidaxqi/oUU0efjNmwoaoWNBoqQo0F5MsB9TdJHvE
        Qwxzqk8lSV0OXKJlqjduOPSDG48h3zi94a/o2iz2xpF3bMxiXJ9UqqAWCyZ8tOyvLFSfoq
        78RzIuY9rOdYUmMGFDyVHTsGrNrnDiv1JRAXov4yDI/kfwQQS2WTQipFkLNiRGpMzt0/cN
        cfRIZeP7Dx4qKHKHxrxsQoycREa7fkgkBarfVZBLX2GNfGARGinrgNuCfaQdlWlFKZUJs9
        Ny1vOwnHeI1+GfdBahRM5rLOZpPh9oz4r86g55tB3MKRu6+FvZYsom5EtHGvTA==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH wpan-next v2 1/2] net: ieee802154: Move the IEEE 802.15.4 Kconfig main entries
Date:   Fri, 28 Jan 2022 12:20:01 +0100
Message-Id: <20220128112002.1121320-2-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220128112002.1121320-1-miquel.raynal@bootlin.com>
References: <20220128112002.1121320-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Girault <david.girault@qorvo.com>

It makes certainly more sense to have all the low-range wireless
protocols such as Bluetooth, IEEE 802.11 (WiFi) and IEEE 802.15.4
together, so let's move the main IEEE 802.15.4 stack Kconfig entry at a
better location.

As the softMAC layer has no meaning outside of the IEEE 802.15.4 stack
and cannot be used without it, also move the mac802154 menu inside
ieee802154/.

Signed-off-by: David Girault <david.girault@qorvo.com>
[miquel.raynal@bootlin.com: Isolate this change from a bigger commit and
rewrite the commit message.]
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/Kconfig            | 3 +--
 net/ieee802154/Kconfig | 1 +
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/Kconfig b/net/Kconfig
index 8a1f9d0287de..a5e31078fd14 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -228,8 +228,6 @@ source "net/x25/Kconfig"
 source "net/lapb/Kconfig"
 source "net/phonet/Kconfig"
 source "net/6lowpan/Kconfig"
-source "net/ieee802154/Kconfig"
-source "net/mac802154/Kconfig"
 source "net/sched/Kconfig"
 source "net/dcb/Kconfig"
 source "net/dns_resolver/Kconfig"
@@ -380,6 +378,7 @@ source "net/mac80211/Kconfig"
 
 endif # WIRELESS
 
+source "net/ieee802154/Kconfig"
 source "net/rfkill/Kconfig"
 source "net/9p/Kconfig"
 source "net/caif/Kconfig"
diff --git a/net/ieee802154/Kconfig b/net/ieee802154/Kconfig
index 31aed75fe62d..7e4b1d49d445 100644
--- a/net/ieee802154/Kconfig
+++ b/net/ieee802154/Kconfig
@@ -36,6 +36,7 @@ config IEEE802154_SOCKET
 	  for 802.15.4 dataframes. Also RAW socket interface to build MAC
 	  header from userspace.
 
+source "net/mac802154/Kconfig"
 source "net/ieee802154/6lowpan/Kconfig"
 
 endif
-- 
2.27.0

