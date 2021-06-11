Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 721123A49E1
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 22:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbhFKUI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 16:08:59 -0400
Received: from mail-ej1-f53.google.com ([209.85.218.53]:47100 "EHLO
        mail-ej1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbhFKUIz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 16:08:55 -0400
Received: by mail-ej1-f53.google.com with SMTP id he7so6197051ejc.13
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 13:06:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TAyARCwymts80UfSaJxc+A+RseuakUzeRsZERPmV1Kc=;
        b=ZsK2C8U7Y6zGtixzFqwU2f0qKlJ/48dNKaCasvleVmITH+fpVbVNZlChvOjnSMKb4d
         Et1NAI7OfiOLAo26jPwIXldDyUYYQw244Sex2p89SRqorGrIPeQbtkX9AQKjDUGG4Qts
         5Pe/UAnF6RtLhO/qk6bru7DfrB+PZBRUT55QRargLFZsvVcdVq7mMYVC8TS9E76qw3Ly
         tT0EbnaIP1HjAmM00oVUQeJIippTi7ff9/yytAL5jRoWVhbfYGrWezi4oFimGngc7QFD
         cSUsr/KyAHXfmrI0TDEB8xd7J27jV7cY6386t8dHAL/wEKZ8piCncZfCATGh2YmaGUVz
         EXRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TAyARCwymts80UfSaJxc+A+RseuakUzeRsZERPmV1Kc=;
        b=hHMcaUmPd5EHUPJR0CrCWJz7e651KP3MgvByXlHhXIXNSd1WFIzRO9EPs7u1BpHFOH
         +25EVCPiIHWL4mREukwzp+aNxAjulRPG2Q9w8f3V6JAvTYf+HW/rOJEKGIDAgLQ24gub
         6cLjNbJvSackwciXZvf8EVtkLo+3qa8LvhKRW2+MOye0uewy7zyLTxP6pUCbKk00zg0a
         IWPDV4IR8u6o7sIYJrlAsdt/WvhhRSAhqZEW9WTydKodAAezM2bfWXRil5c120z6nTvp
         YkvMM/2Suu3Fg1ODqeasY2WZqUSbdjigbNjSRG1KZRO2UckmfhfWdJbz8oDkTcv/6zvO
         6onA==
X-Gm-Message-State: AOAM532nSOBLoTpXzfDUraXdbogfVPT9KGQ5ltUW8xBgDzwl/WWMADx6
        QFvwmU52WXtR3LXp/KTUGZU=
X-Google-Smtp-Source: ABdhPJx0q3keaviy8zOp5QcWBmI9rN2JzJZ65MC3OfzZ0hFWUYMyILNEktPbrqluD5xD5LRSMEh7PA==
X-Received: by 2002:a17:906:b2c1:: with SMTP id cf1mr4991692ejb.544.1623441948579;
        Fri, 11 Jun 2021 13:05:48 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id w2sm2392084ejn.118.2021.06.11.13.05.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 13:05:48 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v3 net-next 02/13] net: stmmac: reverse Christmas tree notation in stmmac_xpcs_setup
Date:   Fri, 11 Jun 2021 23:05:20 +0300
Message-Id: <20210611200531.2384819-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210611200531.2384819-1-olteanv@gmail.com>
References: <20210611200531.2384819-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Reorder the variable declarations in descending line length order,
according to the networking coding style.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
---
v2->v3: none
v1->v2: none

 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index 3b3033b20b1d..a5d150c5f3d8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -399,11 +399,11 @@ int stmmac_mdio_reset(struct mii_bus *bus)
 
 int stmmac_xpcs_setup(struct mii_bus *bus)
 {
-	int mode, addr;
 	struct net_device *ndev = bus->priv;
-	struct dw_xpcs *xpcs;
-	struct stmmac_priv *priv;
 	struct mdio_device *mdiodev;
+	struct stmmac_priv *priv;
+	struct dw_xpcs *xpcs;
+	int mode, addr;
 
 	priv = netdev_priv(ndev);
 	mode = priv->plat->phy_interface;
-- 
2.25.1

