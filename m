Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E2CC6870BC
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 22:53:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbjBAVx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 16:53:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjBAVx1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 16:53:27 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 541438680;
        Wed,  1 Feb 2023 13:53:26 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id o13so90403pjg.2;
        Wed, 01 Feb 2023 13:53:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8zwRSKbGTUujqFIojImH5B73/GPqNmHMeo69BZFjNQ8=;
        b=NqlAFbyXSN7RSrD60ELXRot++RoLteUH/WCCWknfvc/Aaqu3A5kwvT2G4f1e66ZCUO
         lvjk8qsSD0GHeBX45rJf2gFIfLBuN2Zf9tCbkxfNEmGvqS6tPWZcW9w8wWDQ+UnR8+BX
         DVeHb7IJ8oLGUVhuQqREOLFTvhBJvNms2oOTAsVlre+J+af7fNuDTOJUx3AcdGk8UuaE
         dmC3uUBdbdY1VpBLWOTTgekDdcd5lAGLIGuW4OCLVNK8ciEgNPwaaf+xPz/ahjUmz2uF
         NJ3Jr5q7vajsj3nEONQIAeesBOaw5c2zYXRhrwQ84O3Su12ku9cxol3kptpW+FebJvUH
         H/lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8zwRSKbGTUujqFIojImH5B73/GPqNmHMeo69BZFjNQ8=;
        b=cCNkMRqhET0SV9COAXIhSiHqLPgVcREg1+eTWOF/SCi+cCVksYL47ag98yloxOB8PB
         yasTi6Fg2vWmPBFjvXUwfB/rwS+9MX8cnpzKlrzdBY+SdIwNtcLb6gsINf8+mkXR6lw6
         VUtDrbExjYjeVha6YHZzfiKTN1VihvThSElzaQWjmCj4VqKgorBb5Fd25/tNevOnhV5P
         R0T9KE6RspnpCzNW+s7fz1PTqmbNa1FKlq/kKGpd44P3D/4iBTD3kfTmvuntfWXNbw0+
         pYR1B3i5w6686njXS7PAUIqME7Whhbhq226QyTD0saC3ZUSYRmx5ooKrK/G9gC/wXldW
         Jr7w==
X-Gm-Message-State: AO0yUKW1K5v88t8LpgCnyOxw8LivJxoym6wQoVZ/TfKjuVrRMV/QP6pH
        3opGTC425eqPeqP9XV1aMmc=
X-Google-Smtp-Source: AK7set9XC3lLto515i1KBYnKzbRZRvqT7zYrOnmavr/KCHXCH3MTPE5I8FWGoulhWwrxCk7N200wxA==
X-Received: by 2002:a17:90a:1955:b0:22c:3ce3:29f1 with SMTP id 21-20020a17090a195500b0022c3ce329f1mr3776325pjh.46.1675288405604;
        Wed, 01 Feb 2023 13:53:25 -0800 (PST)
Received: from dtor-ws.mtv.corp.google.com ([2620:15c:9d:2:ce3a:44de:62b3:7a4b])
        by smtp.gmail.com with ESMTPSA id h15-20020a17090a054f00b002276ba8fb71sm1781957pjf.25.2023.02.01.13.53.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 13:53:24 -0800 (PST)
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Wei Fang <wei.fang@nxp.com>, Jakub Kicinski <kuba@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Arnd Bergmann <arnd@arndb.de>, Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/2] net: fec: restore handling of PHY reset line as optional
Date:   Wed,  1 Feb 2023 13:53:19 -0800
Message-Id: <20230201215320.528319-1-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Conversion of the driver to gpiod API done in 468ba54bd616 ("fec:
convert to gpio descriptor") incorrectly made reset line mandatory and
resulted in aborting driver probe in cases where reset line was not
specified (note: this way of specifying PHY reset line is actually
deprecated).

Switch to using devm_gpiod_get_optional() and skip manipulating reset
line if it can not be located.

Fixes: 468ba54bd616 ("fec: convert to gpio descriptor")
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---

v3: removed handling of 'phy-reset-active-high', it was moved to patch #2
v2: dropped conversion to generic device properties from the patch

 drivers/net/ethernet/freescale/fec_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 2716898e0b9b..00115b55d0ff 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -4056,12 +4056,15 @@ static int fec_reset_phy(struct platform_device *pdev)
 
 	active_high = of_property_read_bool(np, "phy-reset-active-high");
 
-	phy_reset = devm_gpiod_get(&pdev->dev, "phy-reset",
+	phy_reset = devm_gpiod_get_optional(&pdev->dev, "phy-reset",
 			active_high ? GPIOD_OUT_HIGH : GPIOD_OUT_LOW);
 	if (IS_ERR(phy_reset))
 		return dev_err_probe(&pdev->dev, PTR_ERR(phy_reset),
 				     "failed to get phy-reset-gpios\n");
 
+	if (!phy_reset)
+		return 0;
+
 	if (msec > 20)
 		msleep(msec);
 	else
-- 
2.39.1.456.gfc5497dd1b-goog

