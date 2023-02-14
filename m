Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2B069686B
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 16:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233029AbjBNPsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 10:48:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233005AbjBNPsY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 10:48:24 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F5095BAC;
        Tue, 14 Feb 2023 07:47:54 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id o15so12810658wrc.9;
        Tue, 14 Feb 2023 07:47:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tRR037kJulgwhYLTLVS64RUcLKjXsyaAdjVztOdmt4c=;
        b=LHcslZJDJ8pOVmIPMgFS3RKX/ECo8AvXW1x8gcuyrSEHrMGizuufRmRzlUGBqID/Ty
         ZJDtUoCT7Fk9ZbhcrcK3U6xcUm9D+scmCVBkdbPJ35VSSlXwWdibTIFwGvYNflz6vOdl
         8Y4fc+imZQUula0TczQZhUmtD+ipQH0bm4eK4t6ffmOJ7fFlBiZmA8SNy5Hqyzjvp55o
         93YTUF2rD27wLAlrH9bxJm1r873qQ2DDgZmS2pOakTkdIVYvhFZ34ebL6GdgsDAbNnik
         iH4DLaD7PLbDdynEDAk1SKLkuNNMF5UlmVz6UcrWW2F8Q4bQrB6rJHlaRyzw9/xFpZ56
         eFzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tRR037kJulgwhYLTLVS64RUcLKjXsyaAdjVztOdmt4c=;
        b=H7oIqP0+1rJAfWTJw5ZD7Kb4Cy5pt3wKzxKsQXdRYoSTee5xs0i8ixmhW5/qBELtO7
         +aZa525q/wrYkFA987Y2ipb1BHjyYJlmmh7WEPvqQ//Suhu0g493M5/HGC0thnOCNHPh
         bh4WcLTfGjE+Rh7UF7oep3HlwF+cWBq1cphXO8hJyNEEO5NDEe/yZK70H77zqCkDh6oX
         PZpr2f1NUTZS1JB/XC2e8On8FpiHTvnE2BYKM5gGOiJU4D0LlH3SXXo3VlsQhlE+KTAr
         jAwQfuhSzHFr9LKH8cx0KrdYcyUJUAmTSI72eBUBu9mgE1xhVsTbjKx001lArut6yBuW
         ocLg==
X-Gm-Message-State: AO0yUKUHgoV18Ny6YO2fsXYb4Bt3ArmYAo0lEfKUtnS7dw7MGgubF48a
        PxEeu3vH77Pbgw+dZPljDMM=
X-Google-Smtp-Source: AK7set+CwGvIpahHplmQw/Wo46JqvON9hV+HVgYZg3zRz4apZODEa3REh9eIYNJv1wNVaguy//1UOw==
X-Received: by 2002:adf:fac4:0:b0:2c5:5357:60b8 with SMTP id a4-20020adffac4000000b002c5535760b8mr2183612wrs.48.1676389659383;
        Tue, 14 Feb 2023 07:47:39 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id e1-20020adfe381000000b002c54f39d34csm8894545wrm.111.2023.02.14.07.47.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 07:47:38 -0800 (PST)
Date:   Tue, 14 Feb 2023 18:42:37 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Frank Sae <Frank.Sae@motor-comm.com>
Cc:     Peter Geis <pgwipeout@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] net: phy: Uninitialized variables in
 yt8531_link_change_notify()
Message-ID: <Y+ur7SAUjidrMwkz@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These booleans are never set to false, but are just used uninitialized.

Fixes: 4ac94f728a58 ("net: phy: Add driver for Motorcomm yt8531 gigabit ethernet phy")
Signed-off-by: Dan Carpenter <error27@gmail.com>
---
Applies to net-next.

 drivers/net/phy/motorcomm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/motorcomm.c b/drivers/net/phy/motorcomm.c
index ee7c37dfdca0..119a54d6c65d 100644
--- a/drivers/net/phy/motorcomm.c
+++ b/drivers/net/phy/motorcomm.c
@@ -1534,9 +1534,9 @@ static void yt8531_link_change_notify(struct phy_device *phydev)
 {
 	struct device_node *node = phydev->mdio.dev.of_node;
 	bool tx_clk_adj_enabled = false;
-	bool tx_clk_1000_inverted;
-	bool tx_clk_100_inverted;
-	bool tx_clk_10_inverted;
+	bool tx_clk_1000_inverted = false;
+	bool tx_clk_100_inverted = false;
+	bool tx_clk_10_inverted = false;
 	u16 val = 0;
 	int ret;
 
-- 
2.35.1

