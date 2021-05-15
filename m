Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8BEC381B5C
	for <lists+netdev@lfdr.de>; Sun, 16 May 2021 00:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbhEOWQH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 18:16:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:46958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235228AbhEOWP4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 May 2021 18:15:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A34E613AF;
        Sat, 15 May 2021 22:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621116882;
        bh=Kz0rXaPw+8EGWxmJZy58W+olppvkU9ELa9aUqRHAj7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R8Ms79k8xUPJcduIo+ovu3p16C2b3tJYMWNbE1FJdlWLaElIfc0mnasjm/yztLnBB
         AWuY4UQDjQJ+k3se3ABB0F1Vmv+n79QIDvl0RL1BU9dZKj7gdcLFb1Tv9wYt1AV/Iw
         u/PtYEaLDH43rFWiJRwjbJ1G1xA/zmYdraZphNUp7qZl8DMVl7EmsFgJejZe3g3j7C
         3oMD4t7u7hiiybRtolazUnKpfBbx/vRtUUvt1j+Z+1JcT5wMUNu8BALA3ytM1ALDQ3
         aauR2wU+Pi+GRi7dN/pEpL7mZ0ZhW2tQKDZgZxS8BDJmzFfuvqwRnojyA+aALQ2bdR
         vhmvLpFRvBc0Q==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sam Creasey <sammy@sammy.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Finn Thain <fthain@telegraphics.com.au>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        linux-kernel@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com
Subject: [RFC 04/13] [net-next] 3c509: stop calling netdev_boot_setup_check
Date:   Sun, 16 May 2021 00:13:11 +0200
Message-Id: <20210515221320.1255291-5-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210515221320.1255291-1-arnd@kernel.org>
References: <20210515221320.1255291-1-arnd@kernel.org>
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
index 96cc5fc36eb5..7fd2d322f2bb 100644
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
@@ -588,7 +586,6 @@ static int el3_eisa_probe(struct device *device)
 	}
 
 	SET_NETDEV_DEV(dev, device);
-	netdev_boot_setup_check(dev);
 
 	el3_dev_fill(dev, phys_addr, ioaddr, irq, if_port, EL3_EISA);
 	eisa_set_drvdata (edev, dev);
-- 
2.29.2

