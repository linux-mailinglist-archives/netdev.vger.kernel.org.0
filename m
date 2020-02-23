Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03FED169A0E
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 21:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727218AbgBWUr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 15:47:29 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35823 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727190AbgBWUr3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 15:47:29 -0500
Received: by mail-wr1-f66.google.com with SMTP id w12so8015058wrt.2;
        Sun, 23 Feb 2020 12:47:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QZjZXAIJGmhzIoJIXLLcQGATRWxRcQcmbOZU2XUvhr8=;
        b=FBcUEWtHHdC03wzlf5lOzaeabI5rY7dNTvBXsGVuHv6J7MVi2E/uGnJD4a5eQeSXsB
         KjDZyemAlBZNe4aQxdzHSzOT1dWMdWNqQ77sozG7WjNLXc+YV/fBmTh/7MUEttAHanR9
         Jsn1aza9iZCS/Zz7pFw75NHtnyXlY8m+udFgo/T7qqBWULbF0OO3g8JdbenVkYVjf7km
         7RKuWc5KQSGrYn483r1iY5fLdVKLriMxdn1+Hjnds2O5ueFGY7/T3oG4RfiuZKWGM8KX
         qOiNdKnfauQQAmCcXMEOO0mx4fpHsDcu9Jo7lljwYXBqOQEltJJ4Z+TYOEBmUwVuUK7u
         Glhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QZjZXAIJGmhzIoJIXLLcQGATRWxRcQcmbOZU2XUvhr8=;
        b=EoTxNHw9U6/YFJFp2a19TYsou/vaAi2Dv3Uwi4zTE/gyVVTgS2cBiIZk1bUQZS3Oh7
         +DLpCqxcJvslw4Yf1EtQCugz2OA9lmyHk23ZRe6hR2tlc5Vl9jLof8qHxqTxYWrzDRAw
         CA9516tphsI3SZR4XGTB2VzdtfAwEO1IC81txqmC/9ulvgkW17HxFPPqcjIhHvSwgZb1
         7pdDj0tKD4+h7+qLoi59T78NNo1xGo+7lcaby5hvNqIHG5IdOCOJvXDojWI/Wnx1gphj
         w9EH78s2+cKu63JY5UVfnXVvga9madiwVaAGQOca9vJtZq+rzbHdKB9R5yFedHnQkF8T
         N+fA==
X-Gm-Message-State: APjAAAXvxZ55GC65RJ5OlRmkMc0XEpDH0c4rz7hKiwNIZ6Mxco2Twj4r
        3E06zjDPhtMsaddckOO8ZhQ=
X-Google-Smtp-Source: APXvYqwui9MKPbwXd20NXyO7coHBC44a229d+ygMe0+oWAsi8GGbCfVA7032TrEIAXA89yiBWxpQ0g==
X-Received: by 2002:adf:f744:: with SMTP id z4mr57099002wrp.318.1582490847193;
        Sun, 23 Feb 2020 12:47:27 -0800 (PST)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id z8sm14817927wrq.22.2020.02.23.12.47.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2020 12:47:26 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     shawnguo@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        michael@walle.cc, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 devicetree 3/6] net: dsa: felix: Use PHY_INTERFACE_MODE_INTERNAL instead of GMII
Date:   Sun, 23 Feb 2020 22:47:13 +0200
Message-Id: <20200223204716.26170-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200223204716.26170-1-olteanv@gmail.com>
References: <20200223204716.26170-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

phy-mode = "gmii" is confusing because it may mean that the port
supports the 8-bit-wide parallel data interface pinout, which it
doesn't.

It may also be confusing because one of the "gmii" internal ports is
actually overclocked to run at 2.5Gbps (even though, yes, as far as the
switch MAC is concerned, it still thinks it's gigabit).

So use the phy-mode = "internal" property to describe the internal ports
inside the NXP LS1028A chip (the ones facing the ENETC). The change
should be fine, because the device tree bindings document is yet to be
introduced, and there are no stable DT blobs in use.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Tested-by: Michael Walle <michael@walle.cc>
---
Changes in v3:
None.

Changes in v2:
Patch is new.

 drivers/net/dsa/ocelot/felix.c         | 3 +--
 drivers/net/dsa/ocelot/felix_vsc9959.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 3257962c147e..35124ef7e75b 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -176,8 +176,7 @@ static void felix_phylink_validate(struct dsa_switch *ds, int port,
 	phylink_set(mask, 100baseT_Full);
 	phylink_set(mask, 1000baseT_Full);
 
-	/* The internal ports that run at 2.5G are overclocked GMII */
-	if (state->interface == PHY_INTERFACE_MODE_GMII ||
+	if (state->interface == PHY_INTERFACE_MODE_INTERNAL ||
 	    state->interface == PHY_INTERFACE_MODE_2500BASEX ||
 	    state->interface == PHY_INTERFACE_MODE_USXGMII) {
 		phylink_set(mask, 2500baseT_Full);
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 2c812b481778..93800e81cdd4 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -955,8 +955,7 @@ static int vsc9959_prevalidate_phy_mode(struct ocelot *ocelot, int port,
 					phy_interface_t phy_mode)
 {
 	switch (phy_mode) {
-	case PHY_INTERFACE_MODE_GMII:
-		/* Only supported on internal to-CPU ports */
+	case PHY_INTERFACE_MODE_INTERNAL:
 		if (port != 4 && port != 5)
 			return -ENOTSUPP;
 		return 0;
-- 
2.17.1

