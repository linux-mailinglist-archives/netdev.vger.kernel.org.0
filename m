Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EDDC38122E
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 23:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbhENVBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 17:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbhENVBa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 17:01:30 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 427AAC06174A;
        Fri, 14 May 2021 14:00:18 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id di13so74901edb.2;
        Fri, 14 May 2021 14:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iLW13GfpsJUzvkPWyitZyY28PPsAaoSpQ+0kP4qbd2Y=;
        b=bFV7z8ZtgBfu9mdtsF49tdTPY5ZDZ+Ru8hnb0M5L9k2oSBEZm/YxTJ2zGdujINc8Uv
         iU57iRuZrEzTS72c+O0roGXEZr6HI9D/rT0nIjCUtfneNjr2K7WrcODPcmqydDHKk0Pp
         xDDtTmtctI+as3G0H1RYOn343D82bsMsNDtQcSk4OK9905kK4z7r8abLvctpRJhf4WTp
         whqjXdwFqz/kMF3c7b2mRNi54tVOPWJ+8eSc5HAMBULqezisRaEbfk4estISfhmjvN7V
         ULPyKA4zz64DTz/WJxW4P48o0a1w5xc/gsHlfPe1K8V8RdiHmydrb6mu5jsMaDf91GFp
         v27w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iLW13GfpsJUzvkPWyitZyY28PPsAaoSpQ+0kP4qbd2Y=;
        b=H1PJY63P2WohrFephKPOp8G67RwG7N/+jvV77erVFJjPcoWDAv4/ndUcKNtBPUaVv0
         bdnlMi7BX/UE7jqi79XwIMocjGPSGw1hPNuYcdvOz9XdWxckzpr2mKMTsXs59CqGjfM0
         p8ki4adrR2F5q1Z0Y7Br0BHRz83Nx8IJ9U/wP4B6VYUBjxccKad9WeCHyamNAPpoEk5g
         ULSONVG+UhofOiSSHidEQQaPJkFYXv33lYmbmQpbBJhqDs5WLBGKEBAlmcQhcQgL7MTi
         yN3eO1sFGv1eqN4uYKhjWSx6j2Xw6kqUVWbOvsmtdCZtIgMLgbJplnTvPQgS1vrqnqJz
         5ILw==
X-Gm-Message-State: AOAM531iLyPT88/Ju5TmZxUWJoOrg8dH+PC/a0drA0M5SB9wbhTh2lvm
        MFZSCKrZSxOh1xkbAm32tuc=
X-Google-Smtp-Source: ABdhPJxcXic1mn7HxKuBgEWaVuJNec0+ZsB7HR7gV0qPcxlP0FO7zq4tnllxsXwbn67OX1A1H/haDg==
X-Received: by 2002:a05:6402:515:: with SMTP id m21mr58428029edv.117.1621026016905;
        Fri, 14 May 2021 14:00:16 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id c3sm5455237edn.16.2021.05.14.14.00.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:00:16 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [PATCH net-next v6 01/25] net: dsa: qca8k: change simple print to dev variant
Date:   Fri, 14 May 2021 22:59:51 +0200
Message-Id: <20210514210015.18142-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210514210015.18142-1-ansuelsmth@gmail.com>
References: <20210514210015.18142-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change pr_err and pr_warn to dev variant.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
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

