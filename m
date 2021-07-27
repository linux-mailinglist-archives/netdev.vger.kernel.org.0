Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 585D43D70E1
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 10:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235958AbhG0IJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 04:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235786AbhG0II6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 04:08:58 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21529C061765
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 01:08:59 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1m8I8w-0006l7-Td; Tue, 27 Jul 2021 10:08:50 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1m8I8u-0005sw-OZ; Tue, 27 Jul 2021 10:08:48 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1m8I8u-0004FF-NY; Tue, 27 Jul 2021 10:08:48 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Finn Thain <fthain@linux-m68k.org>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org, linux-m68k@lists.linux-m68k.org
Subject: [PATCH 2/5] nubus: Make struct nubus_driver::remove return void
Date:   Tue, 27 Jul 2021 10:08:37 +0200
Message-Id: <20210727080840.3550927-3-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727080840.3550927-1-u.kleine-koenig@pengutronix.de>
References: <20210727080840.3550927-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Patch-Hashes: v=1; h=sha256; i=JbhrniV2vNHdVwpfhOpuz1F2d1zKsTqaep2udV5D+Zk=; m=x7vdvVMVl5wHK8X7+wGP5Ra6XOkCM87tL3t7TNPTKwg=; p=M8x4NLAOxru7JT+Gx9SxrzxvaGHJbzJ2lK5/w5joXMM=; g=204cfdb681a19c4390cf9518bfe9e7d01d0688de
X-Patch-Sig: m=pgp; i=u.kleine-koenig@pengutronix.de; s=0x0D2511F322BFAB1C1580266BE2DCDD9132669BD6; b=iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmD/vvcACgkQwfwUeK3K7AmgHwf/XLV x9JQnVHroRcWok/CacSA+YekHsCKimEcdiUsdyGeLGVlXSOzdeOWuT1gYG1xhIK7fJo+0Qn4o4PsL huvZUf0dbMWC7xiOh0N81NqP+1bbzfO+A81upPmoyBM7x+FS2Qk3t82mko0vWSJ6+mSIEGLfms9Sq p8aCbw8pakerSHRL1Dm5UFMteSgC1qtmhcLU5l0hPhTFoMWozLu+cpRjQ/FtuyeT83GfPkwRS0emx ODjTxs2FPcpS70Tfn69NucKBYqN5MKyu32ffUPYQf0G0GdmCPJEcRqickNlHeUVs1pvyshjtQ8OAi U0kOupcXhQhncFbDDmifKzU/e5JYapQ==
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The nubus core ignores the return value of the remove callback (in
nubus_device_remove()) and all implementers return 0 anyway.

So make it impossible for future drivers to return an unused error code
by changing the remove prototype to return void.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/net/ethernet/8390/mac8390.c     | 3 +--
 drivers/net/ethernet/natsemi/macsonic.c | 4 +---
 include/linux/nubus.h                   | 2 +-
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/8390/mac8390.c b/drivers/net/ethernet/8390/mac8390.c
index 9aac7119d382..91b04abfd687 100644
--- a/drivers/net/ethernet/8390/mac8390.c
+++ b/drivers/net/ethernet/8390/mac8390.c
@@ -428,13 +428,12 @@ static int mac8390_device_probe(struct nubus_board *board)
 	return err;
 }
 
-static int mac8390_device_remove(struct nubus_board *board)
+static void mac8390_device_remove(struct nubus_board *board)
 {
 	struct net_device *dev = nubus_get_drvdata(board);
 
 	unregister_netdev(dev);
 	free_netdev(dev);
-	return 0;
 }
 
 static struct nubus_driver mac8390_driver = {
diff --git a/drivers/net/ethernet/natsemi/macsonic.c b/drivers/net/ethernet/natsemi/macsonic.c
index 2289e1fe3741..8709d700e15a 100644
--- a/drivers/net/ethernet/natsemi/macsonic.c
+++ b/drivers/net/ethernet/natsemi/macsonic.c
@@ -603,7 +603,7 @@ static int mac_sonic_nubus_probe(struct nubus_board *board)
 	return err;
 }
 
-static int mac_sonic_nubus_remove(struct nubus_board *board)
+static void mac_sonic_nubus_remove(struct nubus_board *board)
 {
 	struct net_device *ndev = nubus_get_drvdata(board);
 	struct sonic_local *lp = netdev_priv(ndev);
@@ -613,8 +613,6 @@ static int mac_sonic_nubus_remove(struct nubus_board *board)
 			  SIZEOF_SONIC_DESC * SONIC_BUS_SCALE(lp->dma_bitmode),
 			  lp->descriptors, lp->descriptors_laddr);
 	free_netdev(ndev);
-
-	return 0;
 }
 
 static struct nubus_driver mac_sonic_nubus_driver = {
diff --git a/include/linux/nubus.h b/include/linux/nubus.h
index eba50b057f6f..392fc6c53e96 100644
--- a/include/linux/nubus.h
+++ b/include/linux/nubus.h
@@ -86,7 +86,7 @@ extern struct list_head nubus_func_rsrcs;
 struct nubus_driver {
 	struct device_driver driver;
 	int (*probe)(struct nubus_board *board);
-	int (*remove)(struct nubus_board *board);
+	void (*remove)(struct nubus_board *board);
 };
 
 extern struct bus_type nubus_bus_type;
-- 
2.30.2

