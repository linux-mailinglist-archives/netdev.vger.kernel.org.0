Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58B0E3A32CD
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 20:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbhFJSQ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 14:16:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbhFJSQ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 14:16:26 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3CB7C061760
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 11:14:29 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id h24so633328ejy.2
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 11:14:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qKw3yEePw7sdX/XkR5PYfXAFHvNJnLsszbSn8SyUSdc=;
        b=Fqdf68xyQE8SpKdVm0+8wl1EHMtXlk4i9x48MAwL5kEkb9eJBo/WevEXQj1YTtnZi/
         6umKhUfAUzxR0W20CoXDXIDKPVV9XNUQNSCNls+Gx/slji5gPqoWAZDIAbnhgLUVuZgt
         t4rKhhDm8D1X80x32QGKxN8hdMXWAdePXudE/SI/b4/RfVfl6sNl0e+DwINgQ4HkClGq
         YRX5vWU+5HXsg7gI4/mtmM+aoB8tRDgEKpgwwuRwW4l8ruSUXDCWDJd8eHgntGwwdseL
         Eddk514o7QTBj6qscDXEizFGtQXWPg+54NUYI1xZZOqIaAvHwIdFUqmziJzM4cpoMMYj
         W1lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qKw3yEePw7sdX/XkR5PYfXAFHvNJnLsszbSn8SyUSdc=;
        b=J3EQQWFvMe1LFlESrQD92TlWqqJ6B76C9eh9NMg89oQTJPF3Hbsf5aArxbmz1hcD5I
         dvYlXpts+N7vCeOnaKurPt15tclVfexwaV7Mr4iIU6mvIwOpI168ZU9Ui3fiWc0Sa0Zr
         Xjx9moGikNN0hzARgbIErCsQJhHawbot8W95/9+lVWVLJFtVJKcy9WIpicJq8o9u7KF1
         GvAZsndGT6OuVccpQL0let2rShkSjNw8tHXvaugYDjY/a3mCZGaFqazRhWMbbpCFHyoa
         /iKKqU4WJx+RMq0IjQLRcpJ9KRm7lPX+2ohAYffKwOIp3rs+TDGZEEAO9dZqqZmuLi2v
         crlg==
X-Gm-Message-State: AOAM533Vl8AM60md6UxtfhT2BDSaO00LqCMv/iY0VSJW/oC6tYgNV8Zt
        PWYq0TL+Z5MqJYwtchAUZDWMN/vasQI=
X-Google-Smtp-Source: ABdhPJw32iku2epXg1u2J2/xg+Q7I7aFebe/ZBNyTL4VJ08XF8i024Y69nvPDB9nqYNEHiK8vnaIsg==
X-Received: by 2002:a17:907:948f:: with SMTP id dm15mr835370ejc.476.1623348868430;
        Thu, 10 Jun 2021 11:14:28 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id dh18sm1705660edb.92.2021.06.10.11.14.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 11:14:27 -0700 (PDT)
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
Subject: [PATCH v2 net-next 03/13] net: stmmac: reduce indentation when calling stmmac_xpcs_setup
Date:   Thu, 10 Jun 2021 21:14:00 +0300
Message-Id: <20210610181410.1886658-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210610181410.1886658-1-olteanv@gmail.com>
References: <20210610181410.1886658-1-olteanv@gmail.com>
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
v1->v2: none

 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 1c881ec8cd04..372673f9af30 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7002,12 +7002,10 @@ int stmmac_dvr_probe(struct device *device,
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

