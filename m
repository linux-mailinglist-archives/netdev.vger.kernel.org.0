Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF3AC3A49DA
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 22:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbhFKUIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 16:08:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbhFKUIG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 16:08:06 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D80CCC061574
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 13:05:51 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id s6so38421755edu.10
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 13:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9aLb5MTiMiX+eIH3cIXkfteLFULp/N00+e1rMmviAS8=;
        b=Km1XT8H83tLT8TNyIdLMRFimyUb95Z0/elr91QOxZ5/pCz2ISBWGfpm29wY2XYnH7V
         L2AvEZo1tb3v3QMaggr3aXQ4vIjG10EYNX8mdYVKgMBw2woWqqukBPj1zx6azfFpleIZ
         ZygKuEZwjRACnhxVW8nACqSr8UmrJv2DHpWy6ki6GBvy/giHXciB8ZV69wiWpOZKktlP
         nLj4VPBujEw1s4KM/j/4k7VRrtY3jqPg+DM4trsgSOvZmBOVR0cADLNsZQ2Kw4gJjnPh
         0NlfqLzF7qLF95C8ypzYhUuXlL49LMiUAu8SWWX4ZJ503LQ3GOdYEXM4ZxkgOn2qV+46
         zH9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9aLb5MTiMiX+eIH3cIXkfteLFULp/N00+e1rMmviAS8=;
        b=k/BfC+fJLMdPhu9uWauRetP1eMjgcUVAhl/7PjeWp96r2hb7eLVR5X/7ZGsk/atZaD
         XsLvj6ZwtXkvpqEoamXlDL/kwFqb2rXwQ6YE+fxkDAjwYalu2sjy41KE5Y9ODFIkrl4R
         97WdaO5eUchBfvXVfl80SRPKKXof+/1isW1TROVJHt1oo0BNBE/WAoAGEPc/Qvbaxixf
         O9v2EhPhtQ8oycCpRRAsqRACgGXGUsE6nnpBOb/vfhiLndvUcfOzh61l9QmyVT7eNNOO
         8L3S9Mp/uu0G7IMhC3pVTDsHTZ40ZJpLcZisYdAiunfSheVnLN/6ElAv5jt7CEJsN+Fc
         fGzg==
X-Gm-Message-State: AOAM53382HsmdkeV4HQo0kw2BDonsQ3txn3nMYlzcWMxEWHd6FVur6ZM
        HoLk9wd0ipCtkuOyfgpgHqEvFWWTYoQ=
X-Google-Smtp-Source: ABdhPJzmu8weoHDB0sMFCwMDVFSD6la1dr12loV+A+iUkl97xaxZjnJz5nrydk6D8sqLXDXAxV3bIg==
X-Received: by 2002:aa7:d555:: with SMTP id u21mr5600674edr.84.1623441950434;
        Fri, 11 Jun 2021 13:05:50 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id w2sm2392084ejn.118.2021.06.11.13.05.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 13:05:50 -0700 (PDT)
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
Subject: [PATCH v3 net-next 03/13] net: stmmac: reduce indentation when calling stmmac_xpcs_setup
Date:   Fri, 11 Jun 2021 23:05:21 +0300
Message-Id: <20210611200531.2384819-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210611200531.2384819-1-olteanv@gmail.com>
References: <20210611200531.2384819-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

There is no reason to embed an if within an if, we can just logically
AND the two conditions.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
---
v2->v3: none
v1->v2: none

 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index db97cd4b871d..975b90805359 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7003,12 +7003,10 @@ int stmmac_dvr_probe(struct device *device,
 	if (priv->plat->speed_mode_2500)
 		priv->plat->speed_mode_2500(ndev, priv->plat->bsp_priv);
 
-	if (priv->plat->mdio_bus_data) {
-		if (priv->plat->mdio_bus_data->has_xpcs) {
-			ret = stmmac_xpcs_setup(priv->mii);
-			if (ret)
-				goto error_xpcs_setup;
-		}
+	if (priv->plat->mdio_bus_data && priv->plat->mdio_bus_data->has_xpcs) {
+		ret = stmmac_xpcs_setup(priv->mii);
+		if (ret)
+			goto error_xpcs_setup;
 	}
 
 	ret = stmmac_phy_setup(priv);
-- 
2.25.1

