Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA4AE31A17C
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 16:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232124AbhBLPTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 10:19:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231753AbhBLPRe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 10:17:34 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC26AC06178C;
        Fri, 12 Feb 2021 07:16:20 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id f14so16222249ejc.8;
        Fri, 12 Feb 2021 07:16:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9apr4CU9ROkXpvdUS3JqoM5muZRLGcdC/mdCAjUO/2I=;
        b=qq/gRN94YuTLfdmLPHGrMIymx/OC2yPfwrCmUNWPUscQWFrnpX9Qp5prLEZZ5Smiqo
         +v48lKSnWO0bE2Yv4ibxQkAwGA4SuHUXkq/uoDWJyALgI/GCIuNFyEafXA0mWQbKTGsv
         AzVIlmgvxYH2bnlddkYkKKJss1qZQHIrqiaPtp0LoxhXt+cdWFUh4zl64DGC+L5Be7ym
         jWRZmZlxilq64BzvYo8meIs3IyHBvOzUAZ5xf3Sjt1pEAH++M6p4svBVQUhJN/OkeQ+Z
         LJDTJZ7Q+M2FTnRF/S5qeT/x4FQFCAT3v0OSc28sNm2WvN4suT9W58TDscjR/wDX0RFu
         j+Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9apr4CU9ROkXpvdUS3JqoM5muZRLGcdC/mdCAjUO/2I=;
        b=Z2Mm6wE5NAja0Gg6+vswyCOSOti5leeX4AiVW7l1XocwoPRSIAdmceVOlRlOtIBcXf
         WFU2sxF4LviOjzJf969rWqSTyuBgR3J9itnFV7ZyeM6xAPizdLPNh0/KHmgoLdO2qAUH
         ZWjjVCEI1+1TONMPIoUyQQ5vq0LRUgdVM5zwy4a7xJFse51zOinF8hVXtgkGEPzytUt/
         /Dzq4rH6vpOuNtOazung//myHWx9CZRCWl32eINskKCi6Uf+thqN4oZLft5jbDrryPHO
         qB2JxIqbTFbQ6h7uedf/NkixYzRrkDA+tHXfBDogD8PAB2KV7IvQ6jZQ/EXVJqk6Xsau
         DaLw==
X-Gm-Message-State: AOAM531eUsCiBwr42mbfsJBv0ET/solhwNdNWrcFJrfB9vg02ITIECT/
        oaHmvs9Yp5D0AIs75HTFncM=
X-Google-Smtp-Source: ABdhPJwHssbN/+yfFPMDwZu6omt1qgfcrLFY+m+hvPdQyX857QadMgG6m5v5GhoDlYC2fYMeyC7HYQ==
X-Received: by 2002:a17:906:378d:: with SMTP id n13mr3387451ejc.386.1613142979490;
        Fri, 12 Feb 2021 07:16:19 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id z19sm6515456edr.69.2021.02.12.07.16.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 07:16:19 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org
Subject: [PATCH v5 net-next 07/10] net: dsa: felix: restore multicast flood to CPU when NPI tagger reinitializes
Date:   Fri, 12 Feb 2021 17:15:57 +0200
Message-Id: <20210212151600.3357121-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210212151600.3357121-1-olteanv@gmail.com>
References: <20210212151600.3357121-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

ocelot_init sets up PGID_MC to include the CPU port module, and that is
fine, but the ocelot-8021q tagger removes the CPU port module from the
unknown multicast replicator. So after a transition from the default
ocelot tagger towards ocelot-8021q and then again towards ocelot,
multicast flooding towards the CPU port module will be disabled.

Fixes: e21268efbe26 ("net: dsa: felix: perform switch setup for tag_8021q")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v5:
Patch is new.

 drivers/net/dsa/ocelot/felix.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 386468e66c41..ae11d3f030ac 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -411,6 +411,7 @@ static int felix_setup_tag_npi(struct dsa_switch *ds, int cpu)
 	 */
 	cpu_flood = ANA_PGID_PGID_PGID(BIT(ocelot->num_phys_ports));
 	ocelot_rmw_rix(ocelot, cpu_flood, cpu_flood, ANA_PGID_PGID, PGID_UC);
+	ocelot_rmw_rix(ocelot, cpu_flood, cpu_flood, ANA_PGID_PGID, PGID_MC);
 
 	return 0;
 }
-- 
2.25.1

