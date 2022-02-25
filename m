Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 609314C410B
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 10:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238926AbiBYJNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 04:13:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238854AbiBYJNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 04:13:35 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF16F17C43C;
        Fri, 25 Feb 2022 01:13:02 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id p9so3392369wra.12;
        Fri, 25 Feb 2022 01:13:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=3LzQnFC/gEXEcei9aPEiGB8FYnlbExqgw7puxpdMUOM=;
        b=Lu4LDBcmRwGXyp95lJ6jnblmfc+OCbEwxvncZc6yFm6yiX6rkx4+muohEhfbXqEO0x
         uXnmfc0+ZU8JXBFsO8kBsQdgfgwtBAFw6BLMfmuq0iu+33X2L4P9HwvTGFjANcn0BkdM
         zl+xcCDhlLqOTEzaflwa1qG4U6g3HkHCRpvFSAB8zKsv2o1gUA93mCuLHtuWyhs2fYUm
         xMEZ42LEUdmL63H/RrxRx+Ks1klaM6azf61XIeyW6cw27kDJUg55yFpAE4DzS/Yvva3r
         QTIFpqGMCEnh9zmrDQsR0QuJCjyqQ6fW1q5ZpmhTrssrjVcVSfmh9caKhjncI1uZ0sZw
         tc3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=3LzQnFC/gEXEcei9aPEiGB8FYnlbExqgw7puxpdMUOM=;
        b=eiYG6E/PpvNW/KP2EdLHgFopNawgl8fPhjHri4yPyNMQ+MVfdtFoRXXpRMnSMwSert
         I2FvDuFcjk0MTO8yMbEIlNTA9wAQ/ZUXWv5lm1tTRKTfLaLH+t2h+uV/r9v9eeB7fLpf
         8s6aWWHVYKQDxAZPAbZoShsLrTln+AP7FNoSaLRplo6Jo0Fjy1IdcpVcGZbrIQG69oH3
         /wEDj3oKRVivZLY4yH4gkSJjQoo8QqJxKrN3W0zWFeE6OxzYeRT650e7FOqSTbIKsSU0
         jZHYxhdqTcCT3UhOEJtfJmgu+uAKvVgLA3J1StRfcYj1d0MvUBywEVdxBYoKM4nSgdeX
         /m8w==
X-Gm-Message-State: AOAM53089yZU4wHpOROfxIGbMdXRvYODnzL0JsPXyzm1qTKUs3PeqcBb
        ULWcdQQCqE4LX2xcIrD2rIJw0JclpH5z8Q==
X-Google-Smtp-Source: ABdhPJz3dt76O4qX9oa2SPv0G70W2LkgoMw2GtMHe0oyR6/9dCNi4JSqYngGdqedcaqXUCXtVJkODA==
X-Received: by 2002:adf:e8c5:0:b0:1e4:7c8a:21a7 with SMTP id k5-20020adfe8c5000000b001e47c8a21a7mr5395020wrn.516.1645780381318;
        Fri, 25 Feb 2022 01:13:01 -0800 (PST)
Received: from localhost.localdomain ([64.64.123.40])
        by smtp.gmail.com with ESMTPSA id z3-20020a1cf403000000b0037d1f4a2201sm1846991wma.21.2022.02.25.01.12.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 01:13:00 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     linux@armlinux.org.uk, andrew@lunn.ch, hkallweit1@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] net: phy: phylink: check the return value of phylink_validate()
Date:   Fri, 25 Feb 2022 01:12:46 -0800
Message-Id: <20220225091246.22085-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function phylink_validate() can fail, so its return value should be
checked.

Fixes: 9525ae83959b ("phylink: add phylink infrastructure")
Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/net/phy/phylink.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 420201858564..597f7579b29f 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -584,7 +584,9 @@ static int phylink_parse_fixedlink(struct phylink *pl,
 
 	bitmap_fill(pl->supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
 	linkmode_copy(pl->link_config.advertising, pl->supported);
-	phylink_validate(pl, pl->supported, &pl->link_config);
+	ret = phylink_validate(pl, pl->supported, &pl->link_config);
+	if (ret)
+		return ret;
 
 	s = phy_lookup_setting(pl->link_config.speed, pl->link_config.duplex,
 			       pl->supported, true);
@@ -1261,7 +1263,11 @@ struct phylink *phylink_create(struct phylink_config *config,
 
 	bitmap_fill(pl->supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
 	linkmode_copy(pl->link_config.advertising, pl->supported);
-	phylink_validate(pl, pl->supported, &pl->link_config);
+	ret = phylink_validate(pl, pl->supported, &pl->link_config);
+	if (ret < 0) {
+		kfree(pl);
+		return ERR_PTR(ret);
+	}
 
 	ret = phylink_parse_mode(pl, fwnode);
 	if (ret < 0) {
-- 
2.17.1

