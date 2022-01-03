Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3690748379C
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 20:35:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236223AbiACTe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 14:34:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236159AbiACTe5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 14:34:57 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF0D1C061761;
        Mon,  3 Jan 2022 11:34:57 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id i6so19488881pla.0;
        Mon, 03 Jan 2022 11:34:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZQSxVw71hQKcJag96dNA2/qYOoUnho5N87+3PfeRU7o=;
        b=INSsXBtzB3DSosLcMwixFDL1duSp/6YU+pUdCnc8xeNxcul0RrLlhoW7tOGBRk+qg+
         sW1ZfWcUFW7kAJ61nwthLyJAlP5z0z3IOrC37IuQBTc1ERdzWCSk33nTO+DSg5X3+F1z
         GxLwLh+QAsEWKa1CEN/eK0xzW0P0hZBOse+T8GHtd5k+NmHgfZeFUUfdvW6hWPn6ix9r
         SUvDMrmPnZHQzgQR7z0k47ogcfmN0dVQrUVLi7PJ6/LMw1eO2Ot99MvTXIQWp1uiep4u
         Tc2Ux4V4KBGHMsWcUUBZto9ma7Y/sVPGR+/g2e/qU9ege7zxQwCMH8/Fu2ChtDi/vym8
         8MaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZQSxVw71hQKcJag96dNA2/qYOoUnho5N87+3PfeRU7o=;
        b=PQEyP51xewWQu6lFrMSKMK3LEgPzS+ROEtTieyxLL5Kd1380coxF2joIRGDCbOaqs7
         R1bNv3CMa/DWiYhGqtvOi9C61ug2MDUnF/02I69pPYd5Boy6qZa1ZSFp4DGZ8MLSMBlO
         oKxO+hSomDXSjTyBi+tF2mQBcCcndAguDCQi9qL2iMeVqHmVFwjMEvvCNISPF+BpOv+F
         KVOIxDsxBRIAK2y1s6KtUQbm06ObL3VtfCyK4vwNXoA9QgH6JY9ixeVmhTZmur6tHSyw
         XZRjZv4DqRMBxR2cm2pAaiWASS9FuHYLBd4WwQBfNlt/zrqs7iDcPcYoloyFI1o3sILo
         lIOw==
X-Gm-Message-State: AOAM531UgVFVEV3E/ti9/zKM7/fdmtk7gQ7FSCp5IbrhQSNJa+G0wGWq
        lyJ6uOv22FqR/9iIAdawHxfnpBo7/P8=
X-Google-Smtp-Source: ABdhPJyBtL4fJwEh8vxyMkUZ0f624hJELqB2WBo2sfM+96CMbzEPWGq9MHccChE/fsZBRa5sqfFSoQ==
X-Received: by 2002:a17:90b:4d86:: with SMTP id oj6mr56838900pjb.185.1641238496932;
        Mon, 03 Jan 2022 11:34:56 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j8sm40746294pfc.11.2022.01.03.11.34.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 11:34:56 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Miaoqian Lin <linmq006@gmail.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] Revert "net: phy: fixed_phy: Fix NULL vs IS_ERR() checking in __fixed_phy_register"
Date:   Mon,  3 Jan 2022 11:34:52 -0800
Message-Id: <20220103193453.1214961-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit b45396afa4177f2b1ddfeff7185da733fade1dc3 ("net: phy:
fixed_phy: Fix NULL vs IS_ERR() checking in __fixed_phy_register")
since it prevents any system that uses a fixed PHY without a GPIO
descriptor from properly working:

[    5.971952] brcm-systemport 9300000.ethernet: failed to register fixed PHY
[    5.978854] brcm-systemport: probe of 9300000.ethernet failed with error -22
[    5.986047] brcm-systemport 9400000.ethernet: failed to register fixed PHY
[    5.992947] brcm-systemport: probe of 9400000.ethernet failed with error -22

Fixes: b45396afa417 ("net: phy: fixed_phy: Fix NULL vs IS_ERR() checking in __fixed_phy_register")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/fixed_phy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/fixed_phy.c b/drivers/net/phy/fixed_phy.c
index a0c256bd5441..c65fb5f5d2dc 100644
--- a/drivers/net/phy/fixed_phy.c
+++ b/drivers/net/phy/fixed_phy.c
@@ -239,8 +239,8 @@ static struct phy_device *__fixed_phy_register(unsigned int irq,
 	/* Check if we have a GPIO associated with this fixed phy */
 	if (!gpiod) {
 		gpiod = fixed_phy_get_gpiod(np);
-		if (!gpiod)
-			return ERR_PTR(-EINVAL);
+		if (IS_ERR(gpiod))
+			return ERR_CAST(gpiod);
 	}
 
 	/* Get the next available PHY address, up to PHY_MAX_ADDR */
-- 
2.25.1

