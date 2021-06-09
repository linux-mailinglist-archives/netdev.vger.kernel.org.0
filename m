Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F42033A1CED
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 20:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbhFISpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 14:45:11 -0400
Received: from mail-ed1-f43.google.com ([209.85.208.43]:35368 "EHLO
        mail-ed1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbhFISpJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 14:45:09 -0400
Received: by mail-ed1-f43.google.com with SMTP id ba2so27946518edb.2
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 11:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2zACc4dR85B+NndbPDutn8hN0y3/WAYBjPgmcpbzmuk=;
        b=UMRQ/BX9FKw7eP8PldeOiSE1U4B8gRjMMJXo3+Hw2PpdByHzSL1CmLh+BwEpW8yNC8
         aBN+t2DNH16wN+1mYSYWC3bhplvVbYrDiT2gnG/qYU/8AUcEx3UqNmNvrTyRM5qPjnCs
         LGllVgavFLFFkAqBdvGj0HyUkumZFuDFE+A+H3Hqewxlsixn6W1fnreAyQTd44fNA5Vs
         eW8dHiMmJvfacncnzjfqXTJwuBjCCKLsmsygFe+xZB8rYxNNg4LE/xk3xx8+LCCwTq4z
         zmiIC5WurDTTIYPramI2v6mtXBeMqaFaO0eCpASIExBeLpNEeV9WDsNP8bzK04TVO0vA
         WGjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2zACc4dR85B+NndbPDutn8hN0y3/WAYBjPgmcpbzmuk=;
        b=PcecKhBQ1+3FjGm6edNxJYE5t1PoS0724uzFqclp6opXbrMsiDLyCJT7UgyC0yvmrR
         nvoz+u40Su/XvM32W0+8cZkZM67AfNLBureuzABT54sYxyOei3cVTbP+YAnia2XUvRDV
         BhyyivuObZ4ppD7Qrdi6mEqTG8qXE0L05eBu3nivaj37oaMM9YXDMlHj3ThYCuaD0Mjk
         kvpN7tk/dkAiGAfI0THexnZeulPQZNZKTcBQ5Lu9x4/RuPFYuSOZkfTUNFtqoFKJWSBK
         CIzYbSLeFJf77YnedgJl6nWH3jzT9UWNwbeCi2RxIzIBSs5LcST8B2aoY5yEPovbpkVt
         CHyw==
X-Gm-Message-State: AOAM531fi3gXZe5tgz8REJqCV9zqlsl5no2mnjXcOT++nJmCfVbuEZPS
        HuqJdGh7WJmUSiuYyTiS/R4=
X-Google-Smtp-Source: ABdhPJyqP/QkAsLdk1NeTvj47DrKs6p3iKX6qFLA7OGUCYa7wqs3KpDs5Xc+ldPwKYYbM4R0AEa17g==
X-Received: by 2002:aa7:db94:: with SMTP id u20mr752801edt.381.1623264134065;
        Wed, 09 Jun 2021 11:42:14 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id oz11sm194935ejb.16.2021.06.09.11.42.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 11:42:13 -0700 (PDT)
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
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 02/13] net: stmmac: reverse Christmas tree notation in stmmac_xpcs_setup
Date:   Wed,  9 Jun 2021 21:41:44 +0300
Message-Id: <20210609184155.921662-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210609184155.921662-1-olteanv@gmail.com>
References: <20210609184155.921662-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Reorder the variable declarations in descending line length order,
according to the networking coding style.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
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

