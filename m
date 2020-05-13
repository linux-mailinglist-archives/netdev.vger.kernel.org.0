Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91FFC1D19F1
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 17:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732146AbgEMPwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 11:52:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729467AbgEMPwF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 11:52:05 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEC22C061A0C;
        Wed, 13 May 2020 08:52:05 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id y9so4390501plk.10;
        Wed, 13 May 2020 08:52:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Wsabm89FpE/feMsX28YuohxPiesLZODdMH4JuG9VcvM=;
        b=CzGwoOizhDQGU+w4fxA2OGKtdzlvCi7UtGd/DQkbzf1hcRKrf3npD7TglFs0+AqJ7U
         xE6dnX9+UiMw9skIJ4gU3r7kThiUWs6xo0T2Nn3+CQNCP42Pgj8DAtCRSqPdB3BHQmpg
         W0v0JEgYw6RX6UfH0WENhwDKL18RFYzvq1tI93MrnrYFL7lhfxYQHk9YduMdNXjHJCrp
         kOBuLrLfNAEH2rJjWzyw9WPZ7RBWH6NmSxYzVpEbR1U3Ja0IaobaKECZ2CJfNTw8zxiD
         43qT9nRVT20alpBSs1NtebGb7cHnOmhw7YFyHhcRTSoyg3Qk8wP6xISvUPyvbndRjYZK
         D6QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Wsabm89FpE/feMsX28YuohxPiesLZODdMH4JuG9VcvM=;
        b=V8XqiXMFsYPwfXz2cs60WnJhVf+m2zlTZYPc98icouDbp4D96h9go74BSlUt17iMMH
         zVRYcfD29jIJLRL1eYAe1KiYgYNUITKeqF6YyEqN28vcMJeIAOsSptsbtVcz7iV0T3he
         YRNMFsubTIX4knhCHxO0nGNE0E07Jb3CSUbKKTD15IJ/Qd9xT0WTLi9t4ODKMUgsG7/o
         tNv7K1/dhC5E0NIbkPGIJkkQwyE732bxUcF9eNfg9ARu/EPWO+J3uNLim/OkxrvXOp9p
         eJ3XhZtoQ/alGZzVIXL9Vam1dImIP1C1UwMh9yz0Exv3HWfJj4Mn57SQEM1zgIZ/m5C8
         7PRQ==
X-Gm-Message-State: AGi0PuZivXT2BOXBzuRUi2Kny9CrK197Y9S0E68n/l0Nc5FMGdb6QBi2
        ON+7tnvEZv2h4CGRG/ORPsQkZeCb
X-Google-Smtp-Source: APiQypLC7e0RVe3YRBh0a10gRTTEdjKk7ICM2sgkDRL+Lt2shgOxwuITBTkCpYPbBD3Hcms5ALTncg==
X-Received: by 2002:a17:902:209:: with SMTP id 9mr24253511plc.22.1589385125072;
        Wed, 13 May 2020 08:52:05 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 19sm15621986pjl.52.2020.05.13.08.52.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2020 08:52:04 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     m.szyprowski@samsung.com, nsaenzjulienne@suse.de, wahrenst@gmx.net,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Andy Gospodarek <gospo@broadcom.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tal Gilboa <talgi@mellanox.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net v2] net: broadcom: Select BROADCOM_PHY for BCMGENET
Date:   Wed, 13 May 2020 08:51:51 -0700
Message-Id: <20200513155158.26110-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The GENET controller on the Raspberry Pi 4 (2711) is typically
interfaced with an external Broadcom PHY via a RGMII electrical
interface. To make sure that delays are properly configured at the PHY
side, ensure that we the dedicated Broadcom PHY driver
(CONFIG_BROADCOM_PHY) is enabled for this to happen.

Fixes: 402482a6a78e ("net: bcmgenet: Clear ID_MODE_DIS in EXT_RGMII_OOB_CTRL when not needed")
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:

- use select instead of imply

 drivers/net/ethernet/broadcom/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/Kconfig b/drivers/net/ethernet/broadcom/Kconfig
index 53055ce5dfd6..2a69c0d06f3c 100644
--- a/drivers/net/ethernet/broadcom/Kconfig
+++ b/drivers/net/ethernet/broadcom/Kconfig
@@ -69,6 +69,7 @@ config BCMGENET
 	select BCM7XXX_PHY
 	select MDIO_BCM_UNIMAC
 	select DIMLIB
+	select BROADCOM_PHY if ARCH_BCM2835
 	help
 	  This driver supports the built-in Ethernet MACs found in the
 	  Broadcom BCM7xxx Set Top Box family chipset.
-- 
2.17.1

