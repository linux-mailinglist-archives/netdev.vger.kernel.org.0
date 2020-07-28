Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3F623060B
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 11:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728356AbgG1JCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 05:02:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728325AbgG1JCN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 05:02:13 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 206ECC061794
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 02:02:13 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id v4so10622253ljd.0
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 02:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Zn4g1GhYdlCyctZ7NV2DdklRVZWr/tORWNWKAWMPXxc=;
        b=rvoGdSXC448vO2LRRAbusNfN+Zp/O3so+sZ7ywUaTe2qU1sbEmNK9pJzIrL7FyHy+o
         UTX8IcjJQuYzAr2E/0/J1SceNhyzH13vhzdiHZYGLVOoCNge73Be3JyTdxCjD5rXhcTs
         L0prP4ZIlKU+GaPzQ1XVt8s2DZ3iRRYA1YetlFpgjAFxIlOVqTGohFSoKk3MmkPcGCh6
         GQwKTYkGVwGvTB7ceNy9WxFL7MkpkYoEuSJaMWmlQbD94G1E8iZmQf6ERDheDYQf0kSM
         FIIs7NWsOjE91ElxWPSq3N+nHghPMjhK/uT8wtM7pMi7UxxVMg4yArwBAQKiEqJ+v2mi
         fH3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Zn4g1GhYdlCyctZ7NV2DdklRVZWr/tORWNWKAWMPXxc=;
        b=VrvYgGbdTzUWHpDe248wthtj8d0djSTfHvV9tPY0JVlqLK0Lhlt52Tz6arpCaWcn9t
         yTG1Vk11GtBEZBM5n9gYVR2GnKjpJTh34Yjp2vBQ9JKU05Y8WN54L+C7eV9D1VOYiDw3
         GVem44/BiGKdZvgpuXWpaFB/j0P6wQEwIH3mkDxQAZP3fpEH2HPyZdxORg4ilXrBIHRz
         LXAnfzFa52rXdeZF50pgjbiAGkKLBwjvAj70B0tr9aMc2SukcK8yqcJ/j268+Kpn3oyr
         G1ZL9YWjqU5rW1y6uxfdv99UOUdbnJNWWgZ/+YWNHivDpngq8KvRtMP732AeQkbsGdX+
         Frvw==
X-Gm-Message-State: AOAM530BM27NFzivTQX6MWmE5DSHpNcRd9d0N1wTMP5dxjPA/oQptHwC
        2kQ0xtnBJKyQDKUK0pJftIofAMtEiknKaQ==
X-Google-Smtp-Source: ABdhPJwZzxMoLecCDxo2pjfHsKMpYDLlr2NeeEX26jRIe5jjmOirUGBJtSpewcK8eUZ2xk09VOM+Gw==
X-Received: by 2002:a2e:91da:: with SMTP id u26mr12443822ljg.311.1595926927547;
        Tue, 28 Jul 2020 02:02:07 -0700 (PDT)
Received: from xps13.kamstrup.dk ([185.181.22.4])
        by smtp.googlemail.com with ESMTPSA id h21sm2836352ljk.31.2020.07.28.02.02.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2020 02:02:06 -0700 (PDT)
From:   Bruno Thomsen <bruno.thomsen@gmail.com>
To:     netdev <netdev@vger.kernel.org>
Cc:     Bruno Thomsen <bruno.thomsen@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Fabio Estevam <festevam@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lars Alex Pedersen <laa@kamstrup.com>,
        Bruno Thomsen <bth@kamstrup.com>
Subject: [PATCH 1/2] net: mdiobus: reset deassert delay
Date:   Tue, 28 Jul 2020 11:02:02 +0200
Message-Id: <20200728090203.17313-1-bruno.thomsen@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current reset logic only has a delay during assert.
This reuses the delay value as deassert delay to ensure
PHYs are ready for commands. Delays are typically needed
when external hardware slows down reset release with a
RC network. This solution does not need any new device
tree bindings.
It also improves handling of long delays (>20ms) by using
the generic fsleep() for selecting appropriate delay
function.

Signed-off-by: Bruno Thomsen <bruno.thomsen@gmail.com>
---
 drivers/net/phy/mdio_bus.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 6ceee82b2839..84d5ab07fe16 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -627,8 +627,9 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
 		bus->reset_gpiod = gpiod;
 
 		gpiod_set_value_cansleep(gpiod, 1);
-		udelay(bus->reset_delay_us);
+		fsleep(bus->reset_delay_us);
 		gpiod_set_value_cansleep(gpiod, 0);
+		fsleep(bus->reset_delay_us);
 	}
 
 	if (bus->reset) {

base-commit: 92ed301919932f777713b9172e525674157e983d
-- 
2.26.2

