Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6A0376DAD
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 02:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbhEHAa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 20:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbhEHAaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 20:30:24 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED2FC061574;
        Fri,  7 May 2021 17:29:22 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id d11so10860530wrw.8;
        Fri, 07 May 2021 17:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7bk6dC/RhqBa/IIFsr+kb2YvIfeYb74QE7Ww5BRo2TY=;
        b=uyOW/b8QBjOw8OA1vNp/uR0EL2l+xxP33Cqrq0nxg9eGeHFv7dAhBM7M6dIMwbMYAJ
         MdK9JsykBlj8L9qeaathmaQe5Jnwgk0hqhSGXFR7/s9g0eYjZMuPzSYvNQtBWEoDrAgn
         WCIV5F3ocr5VF+MQuR+lYz7D18KMsV4v9VO8nO+2jcToLU7c4CpJWfKkdPnwv2H4HpRP
         EMhzr+uGR95VmGGB+XAB/U7K7sFxxD6GPlU1PwhYWf7pxLZYjN6mEeLfsDVE0uefBP3Q
         UEWqhfgeH28r4nWMeF8RlfESOU1qTSMiVjMwlo6OskEKYnJZ24tTvmWTGj2MIjpQc4bq
         Qffw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7bk6dC/RhqBa/IIFsr+kb2YvIfeYb74QE7Ww5BRo2TY=;
        b=pJOHTaeJ8KaYsEg7we5d5N1ULwUMYw56nNnkw4nb8X0ItjLgIlS6gPQHGTSucczR3T
         WjUk4pgVfu+MpnBSBnnzjsQ58/3EpkXUtx8aKiohwzGIlMyUG9hQa+Q1XYYk9LZggqcb
         4Cb/CdnltI1DHoDn5n1TCSSqIW7r9N33Xh0NT50BsqHYSJoqPed9aDUEYdtBcu+ptjxf
         0C6AKazhckHEKN9tGOuoZqiitmNPa99khrR7dWPRICDVttcdT67ZNz0HCcobBIWu/qYd
         boObvAg9f5XFODxk9XcFXZegwXadvu3+lUMxPrHIuDO0D6yc60LNg+JZYU1TT0Y0X6U1
         8KjQ==
X-Gm-Message-State: AOAM533ajG3MtxYPBLMzxzjm/FK+r4LE9aIsagtyqHhGe6a76iP5D78h
        ZKh6wkTI7hRdhxjHQOWGKiU=
X-Google-Smtp-Source: ABdhPJzUVLPq3wTfAMJuclxNm6eharoZw9hAXbNdlFDPjujU4cTQt5vanFMGq+ay73Q3ICd/gLtkEA==
X-Received: by 2002:a5d:5047:: with SMTP id h7mr15661690wrt.287.1620433761674;
        Fri, 07 May 2021 17:29:21 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id f4sm10967597wrz.33.2021.05.07.17.29.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 17:29:21 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v4 04/28] net: dsa: qca8k: change simple print to dev variant
Date:   Sat,  8 May 2021 02:28:54 +0200
Message-Id: <20210508002920.19945-4-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210508002920.19945-1-ansuelsmth@gmail.com>
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change pr_err and pr_warn to dev variant.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
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

