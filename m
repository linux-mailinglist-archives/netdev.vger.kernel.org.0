Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5F540ADC8
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 14:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232682AbhINMgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 08:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232985AbhINMfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 08:35:37 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B349C061574;
        Tue, 14 Sep 2021 05:34:19 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id j13so19601303edv.13;
        Tue, 14 Sep 2021 05:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ONT6D0TiwlnXZMTTExvQRnaRHuAUNBvjf6phJkt6RNk=;
        b=ouM5qbXCBsmJ7JY62EOAMU/CprIJKWWvWJQXHHA+IW3UwqnO8TD+2avXe++SQD/iMg
         ZnjQSRA/BreUynBx/szyvUPdsROEqIlVC54pe+Mtv3nJemWh1OerFxT83JAJyEvgUxrv
         F7momqaRPGI52m1b0/oemT+SXjyXvr62zFtuDw09tgr1HueQKsC+mGWaLRHgdl3ieQ2Q
         uxe30EyhWhEBXDJGplpv0Gdcl0y6aRfZe7DjLxQIYehp9By0sjN7T/YiC8ONjorzJyD0
         pxacxulKjNDrILlGJKBbzvP+SoslgDSO9SGsG/A5VhNpxXk+9chHiP0VL0xmyqiIC8Q1
         lU2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ONT6D0TiwlnXZMTTExvQRnaRHuAUNBvjf6phJkt6RNk=;
        b=pg02Z2m2XzLTcVDiLbj9V+lPmFcWwggfEOG5vRxSkPl/p8hrw5gJqHYmQn6oB/vMLf
         6QxOlAubIREdrFH0ACoPR3//1arKISx+j8AAiBoPbDasF38pTfKudst2AX+ZGqwRxNSW
         8wdEs/SE7WHv7i+7w88NhcGsnalRE5FS3ZHcZ1yISXfDbUmG+F4CoDJbtwGIUl+Aj+zz
         Ik8ItHocJIGeohUK8A/lmyJND3NG77g16LK5zTggSJcJj3eOOwtCnBNYIDKu7iQU3kO/
         gxnv45ELmRkYTATXVRX4akcn+8Qq+eWrFdOy9lYGao6D8qusnskm8BwtFDlh9UKVt+xb
         vp2A==
X-Gm-Message-State: AOAM53173VzMe5CiKTt+kUis6QO2fvcM8hdr43+J/vdWMJ6+xdM0g3jc
        c5qWvbAHittLUA11APs3mzw=
X-Google-Smtp-Source: ABdhPJyoSCczXRLAdvmlZJBKAqHZYQ+OEAR8lz2OEzSD0vKkDaAbkZ503xDmJBIuuhlcZegPSGhLTQ==
X-Received: by 2002:a05:6402:148:: with SMTP id s8mr18828560edu.298.1631622857804;
        Tue, 14 Sep 2021 05:34:17 -0700 (PDT)
Received: from Ansuel-xps.localdomain ([5.170.108.60])
        by smtp.googlemail.com with ESMTPSA id l9sm5560306edt.55.2021.09.14.05.34.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 05:34:17 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Rosen Penev <rosenp@gmail.com>
Subject: [PATCH net-next v2] net: phy: at803x: add support for qca 8327 internal phy
Date:   Tue, 14 Sep 2021 14:33:45 +0200
Message-Id: <20210914123345.6321-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for qca8327 internal phy needed for correct init of the
switch port. It does use the same qca8337 function and reg just with a
different id.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Tested-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/net/phy/at803x.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index bdac087058b2..719860a93d7c 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -1420,6 +1420,19 @@ static struct phy_driver at803x_driver[] = {
 	.get_sset_count = at803x_get_sset_count,
 	.get_strings = at803x_get_strings,
 	.get_stats = at803x_get_stats,
+}, {
+	/* QCA8327 */
+	.phy_id = QCA8327_PHY_ID,
+	.phy_id_mask = QCA8K_PHY_ID_MASK,
+	.name = "QCA PHY 8327",
+	/* PHY_GBIT_FEATURES */
+	.probe = at803x_probe,
+	.flags = PHY_IS_INTERNAL,
+	.config_init = qca83xx_config_init,
+	.soft_reset = genphy_soft_reset,
+	.get_sset_count = at803x_get_sset_count,
+	.get_strings = at803x_get_strings,
+	.get_stats = at803x_get_stats,
 }, };
 
 module_phy_driver(at803x_driver);
@@ -1430,6 +1443,8 @@ static struct mdio_device_id __maybe_unused atheros_tbl[] = {
 	{ PHY_ID_MATCH_EXACT(ATH8032_PHY_ID) },
 	{ PHY_ID_MATCH_EXACT(ATH8035_PHY_ID) },
 	{ PHY_ID_MATCH_EXACT(ATH9331_PHY_ID) },
+	{ PHY_ID_MATCH_EXACT(QCA8337_PHY_ID) },
+	{ PHY_ID_MATCH_EXACT(QCA8327_PHY_ID) },
 	{ }
 };
 
-- 
2.32.0

