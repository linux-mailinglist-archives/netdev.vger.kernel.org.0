Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB14A1CBABE
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 00:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727926AbgEHWc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 18:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727787AbgEHWcZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 18:32:25 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 888B5C05BD43;
        Fri,  8 May 2020 15:32:25 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id mq3so4944300pjb.1;
        Fri, 08 May 2020 15:32:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=HlsIP2e5PFPi7nvSMuEJ4bPiGJ4HYNYx4TlK4SBkXe0=;
        b=R8eK7FyazGcKRs6yzkVQPiW4YlQ7T2W330z1o4M5hx0rR65CbYAEraCV9KOwtRCsbU
         yNlN63VVbiROMIS0gsAa2L5S0KlwS/tbq5YcYNsNHHAtPHkRPqZO6tFgaDBpW+8rRJvX
         MAG82nFxNOyMAxdgWB3y1gWvPonbaxs0O51b9y/XFQnZuAifpqbgOISVlarebkaeASAD
         beD68MUgnPf6oBniYzQlIdLnh+Bb3aRt8XNse8qB3PPL8TycDz0nCsamhcx9+R4pdPny
         eCxy+kA1049GKFxaqJNVAcFCV//xbUYkWtuO6+j0ddRyjhbm/sPEoVSoekT1tz7+hrBp
         hbzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=HlsIP2e5PFPi7nvSMuEJ4bPiGJ4HYNYx4TlK4SBkXe0=;
        b=Fpo2IYkW2TYY28vv/Ar/5XPo5Rj4OXu+k2nPg6cO1hCoouTwyo4CfgSt7v6GQVG2iu
         HpvjJhAcVRAokayUBCM2nGvygXSWS9l9msfDrZmGYUue8vOVJvstcKJykxA+GjjeaqFe
         445CpzusGI6nifTxO6vbkjUmIER9nhObInldvG1rLyi+zCSb5z73iuMl3qzo4yEV3qKR
         AipXmtkf5Vg6tAA7/fGOPdv7WldvRIJkpg90jGlNsPngyxZKfSGxlnd+V17JUCOmhe5e
         bOx5AyPp5RINOUfbFmL4GuE3o5LAh6YbeJcXvZwhZN51NZIoc4zyBDLmlsHmPit1w7/I
         Tn8w==
X-Gm-Message-State: AGi0Pub8zk3BIb6iunxa7aSTL2sjXO/qfMkUWdG2/6MQSWDhWRehQu9D
        Uy4KyRC5tI9jrFfYYHMzspabXeOx
X-Google-Smtp-Source: APiQypLK8FmDNT8vmw3iHLHLwS3nvn6H0j+49YlAIWS4tLzvwy+Sce50ltAKDzprLGBMd/KvMWWKMQ==
X-Received: by 2002:a17:902:c40c:: with SMTP id k12mr4755095plk.238.1588977144294;
        Fri, 08 May 2020 15:32:24 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y29sm2868482pfq.162.2020.05.08.15.32.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 15:32:23 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     nsaenzjulienne@suse.de, wahrenst@gmx.net, m.szyprowski@samsung.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tal Gilboa <talgi@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Andy Gospodarek <gospo@broadcom.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] net: broadcom: Imply BROADCOM_PHY for BCMGENET
Date:   Fri,  8 May 2020 15:32:10 -0700
Message-Id: <20200508223216.6611-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The GENET controller on the Raspberry Pi 4 (2711) is typically
interfaced with an external Broadcom PHY via a RGMII electrical
interface. To make sure that delays are properly configured at the PHY
side, ensure that we get a chance to have the dedicated Broadcom PHY
driver (CONFIG_BROADCOM_PHY) enabled for this to happen.

Fixes: 402482a6a78e ("net: bcmgenet: Clear ID_MODE_DIS in EXT_RGMII_OOB_CTRL when not needed")
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
David,

I would like Marek to indicate whether he is okay or not with this
change. Thanks!

 drivers/net/ethernet/broadcom/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/Kconfig b/drivers/net/ethernet/broadcom/Kconfig
index 53055ce5dfd6..8a70b9152f7c 100644
--- a/drivers/net/ethernet/broadcom/Kconfig
+++ b/drivers/net/ethernet/broadcom/Kconfig
@@ -69,6 +69,7 @@ config BCMGENET
 	select BCM7XXX_PHY
 	select MDIO_BCM_UNIMAC
 	select DIMLIB
+	imply BROADCOM_PHY if ARCH_BCM2835
 	help
 	  This driver supports the built-in Ethernet MACs found in the
 	  Broadcom BCM7xxx Set Top Box family chipset.
-- 
2.17.1

