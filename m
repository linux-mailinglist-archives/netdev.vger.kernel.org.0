Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 420CB41D328
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 08:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348253AbhI3GV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 02:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348217AbhI3GV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 02:21:28 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCA8EC06161C;
        Wed, 29 Sep 2021 23:19:45 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id i25so20707127lfg.6;
        Wed, 29 Sep 2021 23:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GZKBNq+YiujxNh+mvumqFbgFxvNpazQ5GJiioQevf1c=;
        b=XMSSrTWV0pDM+6jI4IkgDWJ3m2Ljzu3CWjbOMnS1RxiWODZ8ARZT1AySuqXW5IpNMI
         tpr0yLiREwXe1/3ohr0uNSQefqx8Qvoc9eY9r+K3RDiH1nNrgd/0/OoE7tVnszj/YfVM
         UuGoMoeYwrz03SCkzyxToSmI3PsfReiBvGv/T8QBbBEYzKlq2VDOYEQKABgXKlWAkx1b
         O59gaQxKDJnXLjClIJxpEzR3OvDqnQfS5xK0cxNf8uinME2bxO6fCDUrCLaNk0NQ9y1k
         1bD5/xM3nvhFQ1s2Gr+bsWzcyNfKxahuLYuj3dgG0f+gJ6e2o69+0K5X/e3IxIdGWALK
         7vhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GZKBNq+YiujxNh+mvumqFbgFxvNpazQ5GJiioQevf1c=;
        b=2LS043rdjE0wfL8st47Q84395s6fRIqqE2EBreoPJ2JUTw7LsN2OK0i/cYAEL2EIe+
         tYhdoZrg8Ws7GyRYiqnDbkJUhLhbPjXZZGXj4F81V1LAPpu79gyQ5QwnXtJBLONcsQlg
         SXOfhATgZPm/r+jKN5fjZz9BDikjvDsM1hg0dc+2JHtCx2r+l2yMtjshiYvEyszp8/eH
         8TtRHYLUdvKN6gd2087Kog+wIxtAPwp4S0Bdk6OEvgdeEbuwvQrbdruwz5NtMmO4k3uz
         0k3bdFJVZGrDggPF409ojapqEuSXi5sUJn2qgmBesVHyhB1hAPBGRDJMJnkyR7HihS9w
         hOxQ==
X-Gm-Message-State: AOAM531p0XgHWBN+DeN7uMaBfaTRSudt//DFc1aiLBwriXZirpMpCpuP
        wpJV1r5OebgJCkIqGAX7mVw=
X-Google-Smtp-Source: ABdhPJx+pMbO0IPsn2Hm96Ds7c9laZsWkG7Y4dRIm47JtUK1n8MLKGEL4CmhONsgT2xWpQ8nloJ3CQ==
X-Received: by 2002:ac2:4c50:: with SMTP id o16mr65331lfk.286.1632982784082;
        Wed, 29 Sep 2021 23:19:44 -0700 (PDT)
Received: from localhost.localdomain ([217.117.245.149])
        by smtp.gmail.com with ESMTPSA id a21sm252222lfb.226.2021.09.29.23.19.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 23:19:43 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, buytenh@marvell.com,
        afleming@freescale.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        Yanfei Xu <yanfei.xu@windriver.com>
Subject: [PATCH v3 1/2] Revert "net: mdiobus: Fix memory leak in __mdiobus_register"
Date:   Thu, 30 Sep 2021 09:19:41 +0300
Message-Id: <f12fb1faa4eccf0f355788225335eb4309ff2599.1632982651.git.paskripkin@gmail.com>
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

