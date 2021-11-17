Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 873F9454EF3
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 22:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235817AbhKQVIf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 16:08:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239501AbhKQVIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 16:08:24 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF8C3C0613B9;
        Wed, 17 Nov 2021 13:05:25 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id z5so17018935edd.3;
        Wed, 17 Nov 2021 13:05:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=t1oOKjv+/U8RdtftE11t0rCXcL7mhgPsJv3IjVSG5Pg=;
        b=Mn2AOqTW4ZhtLcqyjUQCdSIl1ysUOuyA10BrQYxnSGBRhKKyMN8A57Rk598GVbv3km
         n3Xmsl2d60SymdAnQvR17B2y0ijwx5nP0IVbRtjQ3QHYrimAzAlgh73JPbbLXW5WTFnW
         2mqiTVXd7amUwLhw2h/bw/hxBGaIiYVkC9zeekR52YaCPce64JDpZYjWlL6nGABJcKIC
         jSiBQfg7zUzPA/w3K2b61h4c0l34P9xY2ANEXUIHoF3f/3+6Iss4A5o5OSzB6le6YJP2
         4OwfAUA2pbDCusxCe/qYdo73BVpSgzQn2dZqUOFtirwITrSvHn+8gcIJTDC17rbBtQzQ
         187Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t1oOKjv+/U8RdtftE11t0rCXcL7mhgPsJv3IjVSG5Pg=;
        b=VQTuAtF30s3EBksHqPiaBv1tMiOv0jlWWfGdiemGQopacuQIUFdsLdP95tQ2ktdLmV
         jz7je/TQAiSwEg+10LHWj+Q56dB1YiQMTg77HdYnmC0Aw1G57zSUlynBf7P5hziu6o4D
         luEIvfPJh0VpEC5Bo3cwdvKDeVCJ1IvTRpJR72jnTnbSEXrZtwOZ3VBuZ5N7qBMTiYpj
         Io5NUPZ0/uGLvYdkhEK1r8EYs2AAi81FACnJljW5ff83FRodAu5b+ckS2Zwc24Cv3AFX
         v+7oBixCszpEzMJGhPnYkynO3nWKqLa+0js6ZRiIYoEkZXza06zWj8hJNSYv1SUwcROE
         12vw==
X-Gm-Message-State: AOAM5324+E4Jls3aYYDo1PpLXXWnf37ViQRfPPwUKjEhwT3X0jFqNIex
        mn+nZZoxRJ0Djmz166Zk7hs=
X-Google-Smtp-Source: ABdhPJzoNhW1A4AfFIPfzw2gQ7rXbRSscMvtCN8tEZDTKccMQAHUULiWGqfhVdNM6NZmMYvPfp1+ig==
X-Received: by 2002:a05:6402:6d2:: with SMTP id n18mr2724566edy.210.1637183124245;
        Wed, 17 Nov 2021 13:05:24 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id di4sm467070ejc.11.2021.11.17.13.05.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 13:05:24 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [net-next PATCH 07/19] net: dsa: qca8k: set regmap init as mandatory for regmap conversion
Date:   Wed, 17 Nov 2021 22:04:39 +0100
Message-Id: <20211117210451.26415-8-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211117210451.26415-1-ansuelsmth@gmail.com>
References: <20211117210451.26415-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for regmap conversion, make regmap init mandatory and
fail if any error occurs.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index ee04b48875e7..792b999da37c 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1110,6 +1110,14 @@ qca8k_setup(struct dsa_switch *ds)
 	int cpu_port, ret, i;
 	u32 mask;
 
+	/* Start by setting up the register mapping */
+	priv->regmap = devm_regmap_init(ds->dev, NULL, priv,
+					&qca8k_regmap_config);
+	if (IS_ERR(priv->regmap)) {
+		dev_err(priv->dev, "regmap initialization failed");
+		return PTR_ERR(priv->regmap);
+	}
+
 	/* Check the detected switch id */
 	ret = qca8k_read_switch_id(priv);
 	if (ret)
@@ -1126,12 +1134,6 @@ qca8k_setup(struct dsa_switch *ds)
 	if (ret)
 		return ret;
 
-	/* Start by setting up the register mapping */
-	priv->regmap = devm_regmap_init(ds->dev, NULL, priv,
-					&qca8k_regmap_config);
-	if (IS_ERR(priv->regmap))
-		dev_warn(priv->dev, "regmap initialization failed");
-
 	ret = qca8k_setup_mdio_bus(priv);
 	if (ret)
 		return ret;
-- 
2.32.0

