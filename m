Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60DB8379C73
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 04:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbhEKCIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 22:08:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230421AbhEKCIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 22:08:30 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C017CC06175F;
        Mon, 10 May 2021 19:07:24 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id i128so10178609wma.5;
        Mon, 10 May 2021 19:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ywmj3IHTQkkVsQ7wEgbE7GBFALDJcNZKZ3QK56WN2IY=;
        b=nBehbyh2zjuhB+fNjiosUbYppcwD3LZ1fAe2mRyPSN4wUCzjP/qcR2ZfwKbZmmr6cE
         Lef52ffl/lupseFToi/KOGqP5vJN6UoZlEcm03CRgvYcscZImHuhiJ1oQ2Q1axnhiRZ0
         Qct8itEosQZIqgsjVj3+O8Ch/9CbfJEONK0GGmcvNH8P2I6zLAwEQMZYJNJdWmN+Krwl
         iFrKsUFy/FlVTOPAJKidp9gDWjQ3MiE5drQzoyySm2EN8iw5TvdwVf3WIF62O+xOygP0
         rEyl+EjmIP/+Se1FfQVTXrd7AAu46Hl40N1XxRaDr+DHYtO6LW160Zcv360/PreaZ10P
         Xabg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ywmj3IHTQkkVsQ7wEgbE7GBFALDJcNZKZ3QK56WN2IY=;
        b=QfOc757YNjeR78r9WAGPGch2N7NUhN2MHow/OtUIdkPAr/Krsy5YXxHYd/YYNHkxqM
         tqffOQdauQZU+eWjaFn4P5rp05XqbWf6VKcMgWV3vFTjXPcGluOndcOHQe0NLNVUaO//
         JVetXANbggnWV0t/AIUrsBfvunkTyW5MVp7BzSwflNX6MNwqgwq56ROvj2EabFC3QjV6
         a5y7coKEQ4xu2MYJO5qYybL0Erg0G9eKp3pr1MJyTWcuypO92/giddlQDmX+/3XEwcp4
         VyuIi9VF2bWpwNemMOq/jBy03zb03TCW8nXFyFKML7zPJaT8REw7o8GDzDLqNCpxfVO9
         6Ehg==
X-Gm-Message-State: AOAM532KUNgV3TyApCSgYOFcO5DyLDI/fZQ4/OYRFoTfCwo4zrsKayR2
        K2K3jtmWj83yaPLDobv06Qzl212S1nZRkg==
X-Google-Smtp-Source: ABdhPJxtLj9L+yaOiSizSDIbz5Yo8ZhlBpma5s2px2/FW0He6tXjn2gGl1STGRTXqRbslPfn+LYkrg==
X-Received: by 2002:a1c:401:: with SMTP id 1mr2349258wme.138.1620698843383;
        Mon, 10 May 2021 19:07:23 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id q20sm2607436wmq.2.2021.05.10.19.07.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 19:07:23 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list)
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [RFC PATCH net-next v5 01/25] net: dsa: qca8k: change simple print to dev variant
Date:   Tue, 11 May 2021 04:04:36 +0200
Message-Id: <20210511020500.17269-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210511020500.17269-1-ansuelsmth@gmail.com>
References: <20210511020500.17269-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change pr_err and pr_warn to dev variant.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/qca8k.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index cdaf9f85a2cb..0b295da6c356 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -701,7 +701,7 @@ qca8k_setup(struct dsa_switch *ds)
 
 	/* Make sure that port 0 is the cpu port */
 	if (!dsa_is_cpu_port(ds, 0)) {
-		pr_err("port 0 is not the CPU port\n");
+		dev_err(priv->dev, "port 0 is not the CPU port");
 		return -EINVAL;
 	}
 
@@ -711,7 +711,7 @@ qca8k_setup(struct dsa_switch *ds)
 	priv->regmap = devm_regmap_init(ds->dev, NULL, priv,
 					&qca8k_regmap_config);
 	if (IS_ERR(priv->regmap))
-		pr_warn("regmap initialization failed");
+		dev_warn(priv->dev, "regmap initialization failed");
 
 	ret = qca8k_setup_mdio_bus(priv);
 	if (ret)
-- 
2.30.2

