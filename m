Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40E4541E05B
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 19:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352848AbhI3RwL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 13:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352839AbhI3RwK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 13:52:10 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8F9DC06176A;
        Thu, 30 Sep 2021 10:50:27 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id x27so28236759lfa.9;
        Thu, 30 Sep 2021 10:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WbMGoSeIG8Nre7YI94HB+1s+5OyVO37vI/FQasjDNY0=;
        b=qKckho3veE14jzoQZa3FHX5ehyczkirMrSzEPpck72OtAr3vB9PyWSrebSRG9I/sHP
         6IsrpzAOdLNiEudtcudInoxpEGgzbYB33JMUki6jD9wXa/qa689vM8U8HfVP69AJGFzd
         eFswiR4DEymO4lgUpvyk9smlkFfWLENrJvza3tWKrfpWI8hTcNmyO0oXJAuNqMfIj5FJ
         YPvJRxm2kHaW0kZezFrmKGfUtWSG5CzIwo701Pe4Y3LOV3EEZEvTTlInFIpA7mZxQEZA
         RNGwB0Ey6aa4NH+bBMZs+KVFO2xgrgx4yj7s31jeiPVutjV6P/j4VyPhqiNWy5hVCPRa
         F4IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WbMGoSeIG8Nre7YI94HB+1s+5OyVO37vI/FQasjDNY0=;
        b=5UE9e/4Qa57fHv4xKEFv2juW4QGHb18JxdKtihZgOgLwrHwPEy90WLdamsPpeEqcCP
         g9doasuvfFJek0G55MAZGcNRn0ITbd9ZThCzUPyTzzxwnQ38KZWM1be+XIZQP2ufaCRv
         oUPkNyzaFnUT7GZ9SH7WT4cE9/ksM5/7Cuno8idPvj+O5BCSnQDSk5mrPCO2WFJwpYph
         kLci+OAF2maV5sWNcDlScjWmgtSamDFvylf9EGl3rQiMrt8ctjvXL7qSWwJOAaeuC99K
         MNeNk3WEeO+VfCKhi1vE7Lp0rYV8JMPJVOIKtLN4rRnIbmXG4BnsAMcWktR3g8Vypa1x
         QyQQ==
X-Gm-Message-State: AOAM5305tBPDRCNof88UMxdOmNIBNygnQormNWhcs9UfvF7ciXm7CkOS
        997nFqMwbIyCOq5ReAKSdb4=
X-Google-Smtp-Source: ABdhPJzld8V0K1gmh+IgO8cfbtKL/xWokjolndUwXEnW/wfwaR9oljJXtjxvR61kmj0h8nuNQxqJoA==
X-Received: by 2002:a05:6512:b0c:: with SMTP id w12mr568372lfu.240.1633024225985;
        Thu, 30 Sep 2021 10:50:25 -0700 (PDT)
Received: from localhost.localdomain ([217.117.245.149])
        by smtp.gmail.com with ESMTPSA id q6sm485712lfn.170.2021.09.30.10.50.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 10:50:25 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, buytenh@marvell.com,
        afleming@freescale.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        Yanfei Xu <yanfei.xu@windriver.com>
Subject: [PATCH v4 1/2] Revert "net: mdiobus: Fix memory leak in __mdiobus_register"
Date:   Thu, 30 Sep 2021 20:49:42 +0300
Message-Id: <f12fb1faa4eccf0f355788225335eb4309ff2599.1633024062.git.paskripkin@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit ab609f25d19858513919369ff3d9a63c02cd9e2e.

This patch is correct in the sense that we _should_ call device_put() in
case of device_register() failure, but the problem in this code is more
vast.

We need to set bus->state to UNMDIOBUS_REGISTERED before calling
device_register() to correctly release the device in mdiobus_free().
This patch prevents us from doing it, since in case of device_register()
failure put_device() will be called 2 times and it will cause UAF or
something else.

Also, Reported-by: tag in revered commit was wrong, since syzbot
reported different leak in same function.

Link: https://lore.kernel.org/netdev/20210928092657.GI2048@kadam/
Acked-by: Yanfei Xu <yanfei.xu@windriver.com>
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---

Chnages in v4:
	No changes

Changes in v3:
	CC Yanfei -> Acked-by Yanfei

Changes in v2:
	Added this revert

---
 drivers/net/phy/mdio_bus.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 6f4b4e5df639..53f034fc2ef7 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -537,7 +537,6 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
 	err = device_register(&bus->dev);
 	if (err) {
 		pr_err("mii_bus %s failed to register\n", bus->id);
-		put_device(&bus->dev);
 		return -EINVAL;
 	}
 
-- 
2.33.0

