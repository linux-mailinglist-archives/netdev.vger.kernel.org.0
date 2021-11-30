Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02729462CE6
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 07:39:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238685AbhK3GnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 01:43:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233768AbhK3GnI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 01:43:08 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF42C061574
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 22:39:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=A6daDwCiIh3975g68Xikm65PMFqryYSeKnUccgK88Ag=; b=D3C8JbZS6323Fh6YlL4k9UFUoY
        JWuk3DDMs1G9OnOHMpdumy1pcQhbsxv32aOIevzA9SSACqjMyaVSJgTJvVDPBQa+P5gWPQSRkR/Yx
        B7lP12opYaJotxll63EXcTwqBbtpZS6NSC6Q4v6esIzBPa6S9ViBCHA477qdTL6wAwEN6JTCzOZaH
        eYuFBhRMnIMWUqOLZPwJWT3Te4MQ5PXCIdJbptlOEvxgZ2H8oKoM1nCRureBMQe3f4h2tN0ad5fsy
        nDx8w4BzSqfcHgMm9PRfoq3eM9pyAZDXYJBZcN2Pu3kTivM8dIhAQwi0iXiWpAjgwf+AVYbvnt4Wk
        N+2H3y7Q==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mrwns-003p0j-MK; Tue, 30 Nov 2021 06:39:48 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Finn Thain <fthain@telegraphics.com.au>,
        Chris Zankel <chris@zankel.net>,
        Max Filippov <jcmvbkbc@gmail.com>,
        linux-xtensa@linux-xtensa.org,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 2/2 -net] natsemi: xtensa: fix section mismatch warnings
Date:   Mon, 29 Nov 2021 22:39:47 -0800
Message-Id: <20211130063947.7529-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix section mismatch warnings in xtsonic. The first one appears to be
bogus and after fixing the second one, the first one is gone.

WARNING: modpost: vmlinux.o(.text+0x529adc): Section mismatch in reference from the function sonic_get_stats() to the function .init.text:set_reset_devices()
The function sonic_get_stats() references
the function __init set_reset_devices().
This is often because sonic_get_stats lacks a __init 
annotation or the annotation of set_reset_devices is wrong.

WARNING: modpost: vmlinux.o(.text+0x529b3b): Section mismatch in reference from the function xtsonic_probe() to the function .init.text:sonic_probe1()
The function xtsonic_probe() references
the function __init sonic_probe1().
This is often because xtsonic_probe lacks a __init 
annotation or the annotation of sonic_probe1 is wrong.

Fixes: 74f2a5f0ef64 ("xtensa: Add support for the Sonic Ethernet device for the XT2000 board.")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Finn Thain <fthain@telegraphics.com.au>
Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: linux-xtensa@linux-xtensa.org
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/natsemi/xtsonic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20211129.orig/drivers/net/ethernet/natsemi/xtsonic.c
+++ linux-next-20211129/drivers/net/ethernet/natsemi/xtsonic.c
@@ -120,7 +120,7 @@ static const struct net_device_ops xtson
 	.ndo_set_mac_address	= eth_mac_addr,
 };
 
-static int __init sonic_probe1(struct net_device *dev)
+static int sonic_probe1(struct net_device *dev)
 {
 	unsigned int silicon_revision;
 	struct sonic_local *lp = netdev_priv(dev);
