Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB78444E939
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 15:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232403AbhKLO4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 09:56:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231553AbhKLO4y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 09:56:54 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D8E1C061766
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 06:54:03 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mlXwD-0001aA-OZ; Fri, 12 Nov 2021 15:53:57 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1mlXwB-0009Zf-Sz; Fri, 12 Nov 2021 15:53:55 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mlXwB-0001QS-17; Fri, 12 Nov 2021 15:53:55 +0100
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        netdev@vger.kernel.org
Subject: [PATCH net-next] net: dsa: vsc73xxx: Make vsc73xx_remove() return void
Date:   Fri, 12 Nov 2021 15:53:52 +0100
Message-Id: <20211112145352.1125971-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Patch-Hashes: v=1; h=sha256; i=eu5lpI142438jSBFNGP4+xKeiLnKVvgxom/YjY+Unis=; m=RgdKUNZ4EmOBm5+JEA0/hy6eq01I+9XOcnBscgz91u8=; p=76VmQKWaksssuoIDXNJZgtpGwNXvTphGh9SX0rYbdic=; g=98cfe0fc15fa33be5087a62f98100c54ae0f6d5a
X-Patch-Sig: m=pgp; i=u.kleine-koenig@pengutronix.de; s=0x0D2511F322BFAB1C1580266BE2DCDD9132669BD6; b=iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmGOf/sACgkQwfwUeK3K7Akzawf+O6i Rgci3Ix26a92SC6UTdY+ai958pKaA+GhZJq21KnqKc2ZsLyRDBZ3MQDhzyQKGhmPL8NbLlXURoOjo +qY6OUbs2PRhDYgLwFb07iKA8FglOOKNEFlLFJxUoiipIY97kiM5YCXmqKKNlva6wr8N284gtL6Ad f8/bGiBIXpIZ1GUO57oEliex4VjNbzkwkraa6x9RC3T8hB82ZmBzdgc700QvD+jiHMnZs1GxNQUb/ GOBz4+85irMUdRcM7/Y+XYADSMlWMDzz16Ua2QTlQYcwpkhDLv9JmpgxGEMVaNu+8KWgmObXfOtEF X4gQgsEmF/WMieF7kssY/VVl28HP0Uw==
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vsc73xx_remove() returns zero unconditionally and no caller checks the
returned value. So convert the function to return no value.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
Hello,

this is the successor of a patch I sent earlier[1], only doing the safe
and undisputed part.

Best regards
Uwe

[1] net: dsa: Some cleanups in remove code
    https://lore.kernel.org/r/20211109113921.1020311-1-u.kleine-koenig@pengutronix.de

 drivers/net/dsa/vitesse-vsc73xx-core.c | 4 +---
 drivers/net/dsa/vitesse-vsc73xx.h      | 2 +-
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/vitesse-vsc73xx-core.c b/drivers/net/dsa/vitesse-vsc73xx-core.c
index a4b1447ff055..4c18f619ec02 100644
--- a/drivers/net/dsa/vitesse-vsc73xx-core.c
+++ b/drivers/net/dsa/vitesse-vsc73xx-core.c
@@ -1216,12 +1216,10 @@ int vsc73xx_probe(struct vsc73xx *vsc)
 }
 EXPORT_SYMBOL(vsc73xx_probe);
 
-int vsc73xx_remove(struct vsc73xx *vsc)
+void vsc73xx_remove(struct vsc73xx *vsc)
 {
 	dsa_unregister_switch(vsc->ds);
 	gpiod_set_value(vsc->reset, 1);
-
-	return 0;
 }
 EXPORT_SYMBOL(vsc73xx_remove);
 
diff --git a/drivers/net/dsa/vitesse-vsc73xx.h b/drivers/net/dsa/vitesse-vsc73xx.h
index 30b951504e65..30b1f0a36566 100644
--- a/drivers/net/dsa/vitesse-vsc73xx.h
+++ b/drivers/net/dsa/vitesse-vsc73xx.h
@@ -26,5 +26,5 @@ struct vsc73xx_ops {
 
 int vsc73xx_is_addr_valid(u8 block, u8 subblock);
 int vsc73xx_probe(struct vsc73xx *vsc);
-int vsc73xx_remove(struct vsc73xx *vsc);
+void vsc73xx_remove(struct vsc73xx *vsc);
 void vsc73xx_shutdown(struct vsc73xx *vsc);

base-commit: 5833291ab6de9c3e2374336b51c814e515e8f3a5
-- 
2.30.2

