Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE3A381B56
	for <lists+netdev@lfdr.de>; Sun, 16 May 2021 00:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235213AbhEOWPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 18:15:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:46742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235192AbhEOWPp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 May 2021 18:15:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F22461377;
        Sat, 15 May 2021 22:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621116871;
        bh=YCqwXaC8nyUzzLzY3riJfAk2+jTyFVH0x32PItprsTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cHtaPaIWlXp4VXbhiksOSAh0v8hAjp1ExsTzvwZqj0LkAVcFzVCOSxGQUnxy6rqGk
         F1Ip4k59p3bL7yIMHDy7rlMTWFDVl/Kcq4eAxmm7jssypfNVMY5jEx5VbDojtXwTYg
         ohVBB0Q3Zh+MK/EhO53doqGBxFaomoaaPeeZgebAdxI1ZFdsZ9HdBCkZHEJIHMsYz8
         r1OM+iW1nCPjr6GEXyxIIIwNOeozHTwq8cnOltI+s3GcaN9Vtfpe3MS/zRuGb1jAgS
         +Tm/ngM4JCnqU44S9ENzjgLG5OxJ0940tTbcF4YDNA8LgQvCtBa7Hd4p32dE4+QP49
         HJwTGSqy54zxg==
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
Subject: [RFC 01/13] [net-next] bcmgenet: remove call to netdev_boot_setup_check
Date:   Sun, 16 May 2021 00:13:08 +0200
Message-Id: <20210515221320.1255291-2-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210515221320.1255291-1-arnd@kernel.org>
References: <20210515221320.1255291-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The driver has never used the netdev->{irq,base_addr,mem_start}
members, so this call is completely unnecessary.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index fcca023f22e5..b52910f141dc 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3972,8 +3972,6 @@ static int bcmgenet_probe(struct platform_device *pdev)
 	 */
 	dev->needed_headroom += 64;
 
-	netdev_boot_setup_check(dev);
-
 	priv->dev = dev;
 	priv->pdev = pdev;
 
-- 
2.29.2

