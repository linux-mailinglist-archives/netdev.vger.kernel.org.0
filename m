Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29CB73DEC5E
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 13:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235898AbhHCLlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 07:41:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:33150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235841AbhHCLle (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 07:41:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C68EC60C3F;
        Tue,  3 Aug 2021 11:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627990883;
        bh=UBD3M8WBN//4ZqeP9fpBl1bUHvzXVR18YdJMOcPKNHo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=juxqMW4wvOL8vTVr/hGjxmMHCZ/Nt89iHzIpozWdhomNLykGIvxQHHokzTdBY94A/
         GpITDziG9lev35oqR/PJE0bxoHkS6h3YQFSe2M6vCPVqeYZlX9aG2ZOOCkegvtufHl
         ii+ZmcU0KZo3d1AhfsIEEQa3x4ssrZ66wopXtZ9XlZmaZoPwFUdBA3/vqrGTw15kG0
         QzbPe32+nQy//kRqk/utDa0C3dHXjN+rQlry5MFKZdJQTZkCDVX4SJ/ze4Yaw8cu/q
         uKtbilqm4saKePyhV7xJU6JrG/GpRRQ7rWTglgkdsypwMl494A6JkuG2pj6/ziFRSU
         MAR5vpukcUyFg==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Andrii Nakryiko <andriin@fb.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Doug Berger <opendmb@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jakub Kicinski <kuba@kernel.org>, Jessica Yu <jeyu@kernel.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Sam Creasey <sammy@sammy.net>, linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com
Subject: [PATCH v2 04/14] [net-next] 3c509: stop calling netdev_boot_setup_check
Date:   Tue,  3 Aug 2021 13:40:41 +0200
Message-Id: <20210803114051.2112986-5-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210803114051.2112986-1-arnd@kernel.org>
References: <20210803114051.2112986-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

This driver never uses the information returned by
netdev_boot_setup_check, and is not called by the boot-time probing from
driver/net/Space.c, so just remove these stale references.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/3com/3c509.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/3com/3c509.c b/drivers/net/ethernet/3com/3c509.c
index df6927f66771..87c906e744fb 100644
--- a/drivers/net/ethernet/3com/3c509.c
+++ b/drivers/net/ethernet/3com/3c509.c
@@ -302,7 +302,6 @@ static int el3_isa_match(struct device *pdev, unsigned int ndev)
 		return -ENOMEM;
 
 	SET_NETDEV_DEV(dev, pdev);
-	netdev_boot_setup_check(dev);
 
 	if (!request_region(ioaddr, EL3_IO_EXTENT, "3c509-isa")) {
 		free_netdev(dev);
@@ -421,7 +420,6 @@ static int el3_pnp_probe(struct pnp_dev *pdev, const struct pnp_device_id *id)
 		return -ENOMEM;
 	}
 	SET_NETDEV_DEV(dev, &pdev->dev);
-	netdev_boot_setup_check(dev);
 
 	el3_dev_fill(dev, phys_addr, ioaddr, irq, if_port, EL3_PNP);
 	pnp_set_drvdata(pdev, dev);
@@ -590,7 +588,6 @@ static int el3_eisa_probe(struct device *device)
 	}
 
 	SET_NETDEV_DEV(dev, device);
-	netdev_boot_setup_check(dev);
 
 	el3_dev_fill(dev, phys_addr, ioaddr, irq, if_port, EL3_EISA);
 	eisa_set_drvdata (edev, dev);
-- 
2.29.2

