Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 923B912BB55
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 22:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbfL0Vg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 16:36:56 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33655 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbfL0Vgx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 16:36:53 -0500
Received: by mail-wr1-f66.google.com with SMTP id b6so27316521wrq.0
        for <netdev@vger.kernel.org>; Fri, 27 Dec 2019 13:36:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=lPcT1nIQRIywQ1Uddl11jQkMYgW4aZQzKVOqbOR3dDs=;
        b=k4nJ0H4zJRQyHuV1I4Drn8n6+RgkitXc2PlKDCqMYw8sRK1fyZ+7f47JpvCFsrukrJ
         R5JM069SIXrzl4ggN+BzAj5Fvz/wY/wpD72qvGiFSDrra6iAqA5W9njK0C4PjXd5v9LM
         3sJjTAh10ppzXzZG/xND5AebvB25uKUHKQRJTZzq4iYyQY+PZkk9I7sRVPPUfhdkocvA
         r5mtT6RghKPqBlCH4glv5X+CFjwkvWtpcRdIaWQ9YjCXXwUlc0PnxM8CE9EgFWCRL+Qn
         rV2bwM17SUSglZ1J9eJYAKTzLLFXwfxiS89aZiFgqY0r3RntA166Xrc7mudSWviUNs0U
         yfvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=lPcT1nIQRIywQ1Uddl11jQkMYgW4aZQzKVOqbOR3dDs=;
        b=dj5mXd/V4B2HB/iwd/rJ8uTXcmMiQO0uoN24QchjRJZiT78Hs/bELaT/o4Q/ZguXsZ
         3IcMkLpi84l0WFMTUpRBR+hN6fC10gEVL0ug1oO3jlueRYkwFKENHmcr/zCEgprLAjea
         d2lRgnQWLJvx/Pbk1gviIZWRTnyeNLfJ2fWyNLEF2wa2DTpRHBy2JbAjwUtivf8SAzcD
         27FAM0q2pEeH7m0W5/NhgIYpkGXe1ZKakziJRI7EIc9wZTT8m6ATOoVOw9iW4yKVG+ce
         WuDQ/F+a6qtW0zZHje3XNa5Cl1nc1Y385+u671dbABk1LNiuf+RlFdgSrVHsva5fIxgv
         ZhlQ==
X-Gm-Message-State: APjAAAXo48RG1HIcMGNUtbwJyDCPSwJ1Uei6m9wtLiJTx9KKwClA6tOs
        kdEWGURmVGhCGwFQ+jrXDog=
X-Google-Smtp-Source: APXvYqx1Wg7u6ymdDXhxtixfZ3Yn5Ln0dHEyib/Gw8ZFIt8vdwcWvy63O7+7Zw0HvEyYVtyCIVASag==
X-Received: by 2002:a5d:4b88:: with SMTP id b8mr4938219wrt.343.1577482611917;
        Fri, 27 Dec 2019 13:36:51 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id v3sm36330504wru.32.2019.12.27.13.36.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Dec 2019 13:36:51 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com,
        linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Cc:     alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com,
        netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        horatiu.vultur@microchip.com, UNGLinuxDriver@microchip.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v3 net-next 02/11] net: phylink: make QSGMII a valid PHY mode for in-band AN
Date:   Fri, 27 Dec 2019 23:36:17 +0200
Message-Id: <20191227213626.4404-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191227213626.4404-1-olteanv@gmail.com>
References: <20191227213626.4404-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

QSGMII is a SerDes protocol clocked at 5 Gbaud (4 times higher than
SGMII which is clocked at 1.25 Gbaud), with the same 8b/10b encoding and
some extra symbols for synchronization. Logically it offers 4 SGMII
interfaces multiplexed onto the same physical lanes. Each MAC PCS has
its own in-band AN process with the system side of the QSGMII PHY, which
is identical to the regular SGMII AN process.

So allow QSGMII as a valid in-band AN mode, since it is no different
from software perspective from regular SGMII.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
- None.

 drivers/net/phy/phylink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index ba9468cc8e13..c19cbcf183e6 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -281,6 +281,7 @@ static int phylink_parse_mode(struct phylink *pl, struct fwnode_handle *fwnode)
 
 		switch (pl->link_config.interface) {
 		case PHY_INTERFACE_MODE_SGMII:
+		case PHY_INTERFACE_MODE_QSGMII:
 			phylink_set(pl->supported, 10baseT_Half);
 			phylink_set(pl->supported, 10baseT_Full);
 			phylink_set(pl->supported, 100baseT_Half);
-- 
2.17.1

