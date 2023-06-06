Return-Path: <netdev+bounces-8562-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C2F9C724926
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 18:30:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CA8671C20B0E
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 16:30:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE17C33CBE;
	Tue,  6 Jun 2023 16:28:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD59733C9A
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 16:28:47 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06F2BE40
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 09:28:46 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1q6ZXw-00056l-Bg; Tue, 06 Jun 2023 18:28:36 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1q6ZXu-005Y5h-VW; Tue, 06 Jun 2023 18:28:34 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1q6ZXt-00Bl0X-Vq; Tue, 06 Jun 2023 18:28:34 +0200
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Pantelis Antoniou <pantelis.antoniou@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: linuxppc-dev@lists.ozlabs.org,
	netdev@vger.kernel.org,
	kernel@pengutronix.de,
	Michal Kubiak <michal.kubiak@intel.com>
Subject: [PATCH net-next v2 5/8] net: fs_enet: Convert to platform remove callback returning void
Date: Tue,  6 Jun 2023 18:28:26 +0200
Message-Id: <20230606162829.166226-6-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230606162829.166226-1-u.kleine-koenig@pengutronix.de>
References: <20230606162829.166226-1-u.kleine-koenig@pengutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=4371; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=TSxLrItVdGU4w2E+RgCvjB0ueIuADLhsdxN+Ez6quxs=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBkf16nfJESMOxvM/9JhX8Nkhsgo+02AlGi6suoS 0Wg+SuWfduJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZH9epwAKCRCPgPtYfRL+ TvtTB/0d/v/kHpcwVLoSwRfgIVeTIdDuj0UbImRVLiuyMx42dp36EQBp7POZpWGpfKklF76nDLS xxvrj9Zr1CjF+unhWz3D3KoXsxy7ubhoNzPpnoS/UyF593IdTgF8/yO+mY37xKxoMtZcg3pq+tN iNfy766ww8IJPz7ff2lkgUUBXZrO7lfT80J6u84lWnr+aEpIBMA95P8n+8iyT0Oiw0ZZYJB5n2o 3BLL3ktL/gb6rpaD89NsatXp8PAQ/HTTYeoSSheSI8SaKBlHEDAfOzp6ok+/hwSpCexXPsQOQx8 x08Tz0NAVM6UZ5YQPU5P8YfQoA8s86NWuWvv0XmyZPm32rj/
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is (mostly) ignored
and this typically results in resource leaks. To improve here there is a
quest to make the remove callback return void. In the first step of this
quest all drivers are converted to .remove_new() which already returns
void.

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c | 5 ++---
 drivers/net/ethernet/freescale/fs_enet/mii-bitbang.c  | 6 ++----
 drivers/net/ethernet/freescale/fs_enet/mii-fec.c      | 6 ++----
 3 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c b/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
index 8844a9a04fcf..f9f5b28cc72e 100644
--- a/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
+++ b/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
@@ -1051,7 +1051,7 @@ static int fs_enet_probe(struct platform_device *ofdev)
 	return ret;
 }
 
-static int fs_enet_remove(struct platform_device *ofdev)
+static void fs_enet_remove(struct platform_device *ofdev)
 {
 	struct net_device *ndev = platform_get_drvdata(ofdev);
 	struct fs_enet_private *fep = netdev_priv(ndev);
@@ -1066,7 +1066,6 @@ static int fs_enet_remove(struct platform_device *ofdev)
 	if (of_phy_is_fixed_link(ofdev->dev.of_node))
 		of_phy_deregister_fixed_link(ofdev->dev.of_node);
 	free_netdev(ndev);
-	return 0;
 }
 
 static const struct of_device_id fs_enet_match[] = {
@@ -1113,7 +1112,7 @@ static struct platform_driver fs_enet_driver = {
 		.of_match_table = fs_enet_match,
 	},
 	.probe = fs_enet_probe,
-	.remove = fs_enet_remove,
+	.remove_new = fs_enet_remove,
 };
 
 #ifdef CONFIG_NET_POLL_CONTROLLER
diff --git a/drivers/net/ethernet/freescale/fs_enet/mii-bitbang.c b/drivers/net/ethernet/freescale/fs_enet/mii-bitbang.c
index 21de56345503..91a69fc2f7c2 100644
--- a/drivers/net/ethernet/freescale/fs_enet/mii-bitbang.c
+++ b/drivers/net/ethernet/freescale/fs_enet/mii-bitbang.c
@@ -192,7 +192,7 @@ static int fs_enet_mdio_probe(struct platform_device *ofdev)
 	return ret;
 }
 
-static int fs_enet_mdio_remove(struct platform_device *ofdev)
+static void fs_enet_mdio_remove(struct platform_device *ofdev)
 {
 	struct mii_bus *bus = platform_get_drvdata(ofdev);
 	struct bb_info *bitbang = bus->priv;
@@ -201,8 +201,6 @@ static int fs_enet_mdio_remove(struct platform_device *ofdev)
 	free_mdio_bitbang(bus);
 	iounmap(bitbang->dir);
 	kfree(bitbang);
-
-	return 0;
 }
 
 static const struct of_device_id fs_enet_mdio_bb_match[] = {
@@ -219,7 +217,7 @@ static struct platform_driver fs_enet_bb_mdio_driver = {
 		.of_match_table = fs_enet_mdio_bb_match,
 	},
 	.probe = fs_enet_mdio_probe,
-	.remove = fs_enet_mdio_remove,
+	.remove_new = fs_enet_mdio_remove,
 };
 
 module_platform_driver(fs_enet_bb_mdio_driver);
diff --git a/drivers/net/ethernet/freescale/fs_enet/mii-fec.c b/drivers/net/ethernet/freescale/fs_enet/mii-fec.c
index d37d7a19a759..94bd76c6cf9e 100644
--- a/drivers/net/ethernet/freescale/fs_enet/mii-fec.c
+++ b/drivers/net/ethernet/freescale/fs_enet/mii-fec.c
@@ -187,7 +187,7 @@ static int fs_enet_mdio_probe(struct platform_device *ofdev)
 	return ret;
 }
 
-static int fs_enet_mdio_remove(struct platform_device *ofdev)
+static void fs_enet_mdio_remove(struct platform_device *ofdev)
 {
 	struct mii_bus *bus = platform_get_drvdata(ofdev);
 	struct fec_info *fec = bus->priv;
@@ -196,8 +196,6 @@ static int fs_enet_mdio_remove(struct platform_device *ofdev)
 	iounmap(fec->fecp);
 	kfree(fec);
 	mdiobus_free(bus);
-
-	return 0;
 }
 
 static const struct of_device_id fs_enet_mdio_fec_match[] = {
@@ -220,7 +218,7 @@ static struct platform_driver fs_enet_fec_mdio_driver = {
 		.of_match_table = fs_enet_mdio_fec_match,
 	},
 	.probe = fs_enet_mdio_probe,
-	.remove = fs_enet_mdio_remove,
+	.remove_new = fs_enet_mdio_remove,
 };
 
 module_platform_driver(fs_enet_fec_mdio_driver);
-- 
2.39.2


