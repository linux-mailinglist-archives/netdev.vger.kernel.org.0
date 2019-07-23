Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22CCC72261
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 00:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389522AbfGWW2Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 18:28:25 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:44132 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729617AbfGWW2Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 18:28:24 -0400
Received: by mail-io1-f67.google.com with SMTP id s7so85202993iob.11;
        Tue, 23 Jul 2019 15:28:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=pU9a7WDmDblNhHtORn5q1an88I7KvX3awfI/tpZswsc=;
        b=vTUBTfU3WRSbpoLXj3LQRCNpjzD333/dk4AToQ4R+yDDRRvC4KUPHKNSgN9l7LMX57
         3mt+PJntp8PCG3uGt29gQ4J9yoGL+R6fRpRO0WzvNPgtHeaSGxBavFHBsDkXX+ZTwNXq
         +G8KudPajVfM5q3ZSUAASyzViApUZN+Hs4u5iHJY06VgI0tsyEfbpSOxuyEutjEvw64G
         yVYw4ZwX9RCTYumtERA/by6KsC2fwayQBmcUcshaSSKFyIkpMm4YKmb/ldsZnrz02WKK
         2wGhkLNKm+xZEDgKN7x7aFgBXX6V3z4iJ4jmcr7+2ZWX/ACVuwkwcT7oWGoSWHqViAKH
         fTKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=pU9a7WDmDblNhHtORn5q1an88I7KvX3awfI/tpZswsc=;
        b=TyR5rwQzi/W8bGs4DW9gSOhRWIL5HIewBXHmmZR3FCwPCqZF20y2Bp4MeyHmmCTyLI
         WPJEPd4IeqBH8Z+omw2aANiiYru8ci3sBnq+aBm+7OOMvwK5NA0JLOTt71SFZ8B09KIo
         KZMPFkdTNLVx75jNHh2P0IM8o15XP6mxDQzZsBaiSCTAp+5srwaODLqND1I0DF/8tXAA
         2pCQris1UNWBGIchg/bUbxU2e1BVjO4kW5AnoVNfnO89ykVNjX5Oxex/vv86KRn5RlqC
         1vd79/jdBqz+MmKO5WoKRjd3HyJ4XpZEobX/lymvHSUTgShNfZ7toARCL5jXQeTBkkKq
         Mhdw==
X-Gm-Message-State: APjAAAVMRzxL1+g30KspsZQDaWSPLREprvZi4YRmF4H9R7V+73qLI7JV
        iEWGW2YrU/TnOFU7JUaqXEc=
X-Google-Smtp-Source: APXvYqw3itXpwcxCPWEGgT4oxNdiQSL++cL7fM7qnjdamhn1oCj7qCS8wG0y7AsQnIb8WWfLJWqK/Q==
X-Received: by 2002:a6b:dc17:: with SMTP id s23mr67568306ioc.56.1563920903840;
        Tue, 23 Jul 2019 15:28:23 -0700 (PDT)
Received: from cs-dulles.cs.umn.edu (cs-dulles.cs.umn.edu. [128.101.35.54])
        by smtp.googlemail.com with ESMTPSA id f17sm41593017ioc.2.2019.07.23.15.28.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Jul 2019 15:28:23 -0700 (PDT)
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     emamd001@umn.edu, kjlu@umn.edu, smccaman@umn.edu,
        secalert@redhat.com, Navid Emamdoost <navid.emamdoost@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] stmmac_dt_phy: null check the allocation
Date:   Tue, 23 Jul 2019 17:28:09 -0500
Message-Id: <20190723222809.9752-1-navid.emamdoost@gmail.com>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

devm_kzalloc may fail and return NULL. So the null check is needed.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 73fc2524372e..392f8d9539c1 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -342,10 +342,13 @@ static int stmmac_dt_phy(struct plat_stmmacenet_data *plat,
 		mdio = true;
 	}
 
-	if (mdio)
+	if (mdio) {
 		plat->mdio_bus_data =
 			devm_kzalloc(dev, sizeof(struct stmmac_mdio_bus_data),
 				     GFP_KERNEL);
+		if (!plat->mdio_bus_data)
+			return -ENOMEM;
+	}
 	return 0;
 }
 
-- 
2.17.1

