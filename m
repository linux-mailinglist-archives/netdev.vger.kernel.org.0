Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19A0E3DEC58
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 13:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235793AbhHCLlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 07:41:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:32948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235796AbhHCLlW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 07:41:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9F1160525;
        Tue,  3 Aug 2021 11:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627990871;
        bh=dNtFKQr5I3nQ99ZaxUpU9GUopGCxuccgkNfu/oYKujo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WrL8JQ8S+FdSV4Aq6FtNqTLTYOYB3UWRvy3B8SLpkmJOJdOvTrTSjQQ1Dscf7EFc/
         mAS0xrz1lj6xYxiHSZb8DFFK2hXVn9SZSVbRqDAo57UuNI4eUv6maqcs5bInO01Plk
         tHe3YqeNrtT5v1IKEPmmJANr1RsWBjWoG2Nc0tLz/QVepmZTE0yBAmWsjakYwbMLI6
         ueXAsMky5PtSnYxrzjzO0oDUYnHgOYJHplpYDWVTKNkThRlzEhvuF1Ti10r6r6BdB1
         0F+tUYatebVsgmNjcDokelbMIeGygYVhHxJCMc9Xvz+Qo2hOgrQDUU5YXXBo0TOV0l
         +4RwqSQhEyesQ==
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
Subject: [PATCH v2 01/14] [net-next] bcmgenet: remove call to netdev_boot_setup_check
Date:   Tue,  3 Aug 2021 13:40:38 +0200
Message-Id: <20210803114051.2112986-2-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210803114051.2112986-1-arnd@kernel.org>
References: <20210803114051.2112986-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The driver has never used the netdev->{irq,base_addr,mem_start}
members, so this call is completely unnecessary.

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 63e2237e0cb4..8507198992df 100644
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

