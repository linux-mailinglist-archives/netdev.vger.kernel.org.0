Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE56696873
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 16:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233173AbjBNPtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 10:49:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233115AbjBNPs7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 10:48:59 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C51B92A9A5;
        Tue, 14 Feb 2023 07:48:38 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id co8so12376237wrb.1;
        Tue, 14 Feb 2023 07:48:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tRR037kJulgwhYLTLVS64RUcLKjXsyaAdjVztOdmt4c=;
        b=VjbWCbotQWqLI6NTvaGcQuuN96uHe8+UBeDLz/A66EW0peCmEB/10IudvOblgTTJM0
         ldWU16eigU+Dj5URo75u917Nu0vPunLTVGLW1kBYrCKKM8RDJNWxsUypJoKZTRIufRUz
         e1dbFaJItUXUfhfCugSErp+KdIiA+QLw2qvdyj6Z5EkJ9+YYwWflfywFlb9cCTtzU4Dd
         b+YNsgX7WuE4c9aCZUAKaulUzxE2SAaSZvfa8Qb4yNQHqcEdUV63OyYSzBWKNJthRvSL
         QJTbfRVMyiRUhgasD5XngcjB/lcOdVRQoMP6j/dLa/EV+RawU6NMsM7eZV6tTLlt3ne6
         oNPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tRR037kJulgwhYLTLVS64RUcLKjXsyaAdjVztOdmt4c=;
        b=s6UDCgbn/GHOUHEVot5uE3wZp6GvciDCmFz7RZQTFV8Bgzml1lYBAjCBfXqtjNL95e
         CjhWsuIlI+YjajrCyuBfSLK64Dgjve+WI7Kc2PPJdYsOUncPaNQn7MDTWGmb8ofmSUCT
         DeGZ8QUj0p8hQ3JC8TDENDxigXmoAkVCgZlxU2Dfgo3bj1VR4iWaPrP8z5wOwMSYVrWH
         A+sGALGvfLngiKjGXPTXUmKpx/YX7mJ/vjldgzv9fV1zvaQSnQYUhs9qmSEPR03L2tIl
         1hB0hxe90Tu4wldgZA1C40+VBEo+4V/hBAIk/AC1SXgdimf7IgoFd53A2Ivx5Q762Vb4
         Gi4g==
X-Gm-Message-State: AO0yUKVaGI+tu58dtpbKzuK/xSZXuULqxir8S7+DBwqoUMbe+0XFwLPm
        35gORQ0fhfAH/juzSnI0rWA=
X-Google-Smtp-Source: AK7set+azTp13SuUGwjoNTZyrMsLUMb49C2onH4V27e0C/cXyii//Ul3dV50Ex869zgJSQEedF0Kpw==
X-Received: by 2002:adf:f04e:0:b0:2bf:dcdc:afb8 with SMTP id t14-20020adff04e000000b002bfdcdcafb8mr2658209wro.64.1676389717261;
        Tue, 14 Feb 2023 07:48:37 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id s12-20020a5d510c000000b002c55bbeefc2sm4449390wrt.22.2023.02.14.07.48.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 07:48:36 -0800 (PST)
Date:   Tue, 14 Feb 2023 18:48:31 +0300
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
Message-ID: <Y+utT+5q5Te1GvYk@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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

