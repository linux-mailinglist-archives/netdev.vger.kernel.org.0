Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C84AC6B54BC
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 23:43:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbjCJWne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 17:43:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232045AbjCJWnA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 17:43:00 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC196150EC1
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 14:42:32 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1palQh-0002dF-AE; Fri, 10 Mar 2023 23:41:39 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1palQf-003Gqb-K3; Fri, 10 Mar 2023 23:41:37 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1palQe-003uEm-Ud; Fri, 10 Mar 2023 23:41:36 +0100
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        =?utf-8?q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Vinod Koul <vkoul@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Roy Pledge <Roy.Pledge@nxp.com>, Li Yang <leoyang.li@nxp.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <uwe@kleine-koenig.org>,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, dmaengine@vger.kernel.org,
        netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Subject: [PATCH 6/6] bus: fsl-mc: Make remove function return void
Date:   Fri, 10 Mar 2023 23:41:28 +0100
Message-Id: <20230310224128.2638078-7-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230310224128.2638078-1-u.kleine-koenig@pengutronix.de>
References: <20230310224128.2638078-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=10084; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=9mBAd0011vCFVMqmKv0sG8u7xl0d5ng9BqpXGJnY3UY=; b=owEBbQGS/pANAwAKAcH8FHityuwJAcsmYgBkC7IS4iDBmtk6endpHGEPsd8XTh4Wj6zZvJ4+p 3A9Hbr8tomJATMEAAEKAB0WIQR+cioWkBis/z50pAvB/BR4rcrsCQUCZAuyEgAKCRDB/BR4rcrs Cd01B/472HXgkkn1dxwJPe/PvNhCuB9iH9vI0Z1P6W+GYbYOaQK+LurDS+akY5QNd7tjzm4qWfm dZ4bbwuSY/lbJGxiDl3ZPsis0maetj+wnZFrxeVoH6+lNMmDaY8mqcKRjYRudOrP7aHGH7G7SQR o2n7D3BLUtp8aa6N9z87rmGT0CjTgOHoBshxHP2X5C/Mxs0Salc6xzduYSqyA5gqyFx4hwYaGcI vxLxA0+n0+TvBJGthGurOF977Cy8QlSysrsMuNnlOu2h241u2Vmr5ZOt8IqzN4D6e7ZDOOaG7d9 akuL2eJqsYXWXQ/ODB390DjCekbI2cL9jLOdoZn7SuQnOYWF
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Uwe Kleine-König <uwe@kleine-koenig.org>

The value returned by an fsl-mc driver's remove function is mostly
ignored.  (Only an error message is printed if the value is non-zero
and then device removal continues unconditionally.)

So change the prototype of the remove function to return no value. This
way driver authors are not tempted to assume that passing an error to
the upper layer is a good idea. All drivers are adapted accordingly.
There is no intended change of behaviour, all callbacks were prepared to
return 0 before.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/bus/fsl-mc/dprc-driver.c                    | 5 ++---
 drivers/bus/fsl-mc/fsl-mc-allocator.c               | 5 ++---
 drivers/bus/fsl-mc/fsl-mc-bus.c                     | 5 +----
 drivers/crypto/caam/caamalg_qi2.c                   | 4 +---
 drivers/dma/fsl-dpaa2-qdma/dpaa2-qdma.c             | 4 +---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c    | 4 +---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c    | 4 +---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c | 4 +---
 drivers/soc/fsl/dpio/dpio-driver.c                  | 4 +---
 drivers/vfio/fsl-mc/vfio_fsl_mc.c                   | 3 +--
 include/linux/fsl/mc.h                              | 2 +-
 11 files changed, 13 insertions(+), 31 deletions(-)

diff --git a/drivers/bus/fsl-mc/dprc-driver.c b/drivers/bus/fsl-mc/dprc-driver.c
index ef4f43f67b80..595d4cecd041 100644
--- a/drivers/bus/fsl-mc/dprc-driver.c
+++ b/drivers/bus/fsl-mc/dprc-driver.c
@@ -835,13 +835,13 @@ EXPORT_SYMBOL_GPL(dprc_cleanup);
  * It tears down the interrupts that were configured for the DPRC device.
  * It destroys the interrupt pool associated with this MC bus.
  */
-static int dprc_remove(struct fsl_mc_device *mc_dev)
+static void dprc_remove(struct fsl_mc_device *mc_dev)
 {
 	struct fsl_mc_bus *mc_bus = to_fsl_mc_bus(mc_dev);
 
 	if (!mc_bus->irq_resources) {
 		dev_err(&mc_dev->dev, "No irq resources, so unbinding the device failed\n");
-		return 0;
+		return;
 	}
 
 	if (dev_get_msi_domain(&mc_dev->dev))
@@ -852,7 +852,6 @@ static int dprc_remove(struct fsl_mc_device *mc_dev)
 	dprc_cleanup(mc_dev);
 
 	dev_info(&mc_dev->dev, "DPRC device unbound from driver");
-	return 0;
 }
 
 static const struct fsl_mc_device_id match_id_table[] = {
diff --git a/drivers/bus/fsl-mc/fsl-mc-allocator.c b/drivers/bus/fsl-mc/fsl-mc-allocator.c
index 36f70e5e418b..0ad68099684e 100644
--- a/drivers/bus/fsl-mc/fsl-mc-allocator.c
+++ b/drivers/bus/fsl-mc/fsl-mc-allocator.c
@@ -614,19 +614,18 @@ static int fsl_mc_allocator_probe(struct fsl_mc_device *mc_dev)
  * fsl_mc_allocator_remove - callback invoked when an allocatable device is
  * being removed from the system
  */
-static int fsl_mc_allocator_remove(struct fsl_mc_device *mc_dev)
+static void fsl_mc_allocator_remove(struct fsl_mc_device *mc_dev)
 {
 	int error;
 
 	if (mc_dev->resource) {
 		error = fsl_mc_resource_pool_remove_device(mc_dev);
 		if (error < 0)
-			return 0;
+			return;
 	}
 
 	dev_dbg(&mc_dev->dev,
 		"Allocatable fsl-mc device unbound from fsl_mc_allocator driver");
-	return 0;
 }
 
 static const struct fsl_mc_device_id match_id_table[] = {
diff --git a/drivers/bus/fsl-mc/fsl-mc-bus.c b/drivers/bus/fsl-mc/fsl-mc-bus.c
index 1531e6101fb1..08b7dc8f2181 100644
--- a/drivers/bus/fsl-mc/fsl-mc-bus.c
+++ b/drivers/bus/fsl-mc/fsl-mc-bus.c
@@ -454,11 +454,8 @@ static int fsl_mc_driver_remove(struct device *dev)
 {
 	struct fsl_mc_driver *mc_drv = to_fsl_mc_driver(dev->driver);
 	struct fsl_mc_device *mc_dev = to_fsl_mc_device(dev);
-	int error;
 
-	error = mc_drv->remove(mc_dev);
-	if (error < 0)
-		dev_err(dev, "%s failed: %d\n", __func__, error);
+	mc_drv->remove(mc_dev);
 
 	return 0;
 }
diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 5c8d35edaa1c..9156bbe038b7 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -5402,7 +5402,7 @@ static int dpaa2_caam_probe(struct fsl_mc_device *dpseci_dev)
 	return err;
 }
 
-static int __cold dpaa2_caam_remove(struct fsl_mc_device *ls_dev)
+static void __cold dpaa2_caam_remove(struct fsl_mc_device *ls_dev)
 {
 	struct device *dev;
 	struct dpaa2_caam_priv *priv;
@@ -5443,8 +5443,6 @@ static int __cold dpaa2_caam_remove(struct fsl_mc_device *ls_dev)
 	free_percpu(priv->ppriv);
 	fsl_mc_portal_free(priv->mc_io);
 	kmem_cache_destroy(qi_cache);
-
-	return 0;
 }
 
 int dpaa2_caam_enqueue(struct device *dev, struct caam_request *req)
diff --git a/drivers/dma/fsl-dpaa2-qdma/dpaa2-qdma.c b/drivers/dma/fsl-dpaa2-qdma/dpaa2-qdma.c
index 8dd40d00a672..a42a37634881 100644
--- a/drivers/dma/fsl-dpaa2-qdma/dpaa2-qdma.c
+++ b/drivers/dma/fsl-dpaa2-qdma/dpaa2-qdma.c
@@ -765,7 +765,7 @@ static int dpaa2_qdma_probe(struct fsl_mc_device *dpdmai_dev)
 	return err;
 }
 
-static int dpaa2_qdma_remove(struct fsl_mc_device *ls_dev)
+static void dpaa2_qdma_remove(struct fsl_mc_device *ls_dev)
 {
 	struct dpaa2_qdma_engine *dpaa2_qdma;
 	struct dpaa2_qdma_priv *priv;
@@ -787,8 +787,6 @@ static int dpaa2_qdma_remove(struct fsl_mc_device *ls_dev)
 	dma_async_device_unregister(&dpaa2_qdma->dma_dev);
 	kfree(priv);
 	kfree(dpaa2_qdma);
-
-	return 0;
 }
 
 static void dpaa2_qdma_shutdown(struct fsl_mc_device *ls_dev)
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index a62cffaf6ff1..a9676d0dece8 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -5025,7 +5025,7 @@ static int dpaa2_eth_probe(struct fsl_mc_device *dpni_dev)
 	return err;
 }
 
-static int dpaa2_eth_remove(struct fsl_mc_device *ls_dev)
+static void dpaa2_eth_remove(struct fsl_mc_device *ls_dev)
 {
 	struct device *dev;
 	struct net_device *net_dev;
@@ -5073,8 +5073,6 @@ static int dpaa2_eth_remove(struct fsl_mc_device *ls_dev)
 	dev_dbg(net_dev->dev.parent, "Removed interface %s\n", net_dev->name);
 
 	free_netdev(net_dev);
-
-	return 0;
 }
 
 static const struct fsl_mc_device_id dpaa2_eth_match_id_table[] = {
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c
index 90d23ab1ce9d..4497e3c0456d 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c
@@ -219,7 +219,7 @@ static int dpaa2_ptp_probe(struct fsl_mc_device *mc_dev)
 	return err;
 }
 
-static int dpaa2_ptp_remove(struct fsl_mc_device *mc_dev)
+static void dpaa2_ptp_remove(struct fsl_mc_device *mc_dev)
 {
 	struct device *dev = &mc_dev->dev;
 	struct ptp_qoriq *ptp_qoriq;
@@ -232,8 +232,6 @@ static int dpaa2_ptp_remove(struct fsl_mc_device *mc_dev)
 	fsl_mc_free_irqs(mc_dev);
 	dprtc_close(mc_dev->mc_io, 0, mc_dev->mc_handle);
 	fsl_mc_portal_free(mc_dev->mc_io);
-
-	return 0;
 }
 
 static const struct fsl_mc_device_id dpaa2_ptp_match_id_table[] = {
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index f4ae4289c41a..21cc4e52425a 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -3221,7 +3221,7 @@ static void dpaa2_switch_teardown(struct fsl_mc_device *sw_dev)
 		dev_warn(dev, "dpsw_close err %d\n", err);
 }
 
-static int dpaa2_switch_remove(struct fsl_mc_device *sw_dev)
+static void dpaa2_switch_remove(struct fsl_mc_device *sw_dev)
 {
 	struct ethsw_port_priv *port_priv;
 	struct ethsw_core *ethsw;
@@ -3252,8 +3252,6 @@ static int dpaa2_switch_remove(struct fsl_mc_device *sw_dev)
 	kfree(ethsw);
 
 	dev_set_drvdata(dev, NULL);
-
-	return 0;
 }
 
 static int dpaa2_switch_probe_port(struct ethsw_core *ethsw,
diff --git a/drivers/soc/fsl/dpio/dpio-driver.c b/drivers/soc/fsl/dpio/dpio-driver.c
index 09df5302d255..9e3fddd8f5a9 100644
--- a/drivers/soc/fsl/dpio/dpio-driver.c
+++ b/drivers/soc/fsl/dpio/dpio-driver.c
@@ -270,7 +270,7 @@ static void dpio_teardown_irqs(struct fsl_mc_device *dpio_dev)
 	fsl_mc_free_irqs(dpio_dev);
 }
 
-static int dpaa2_dpio_remove(struct fsl_mc_device *dpio_dev)
+static void dpaa2_dpio_remove(struct fsl_mc_device *dpio_dev)
 {
 	struct device *dev;
 	struct dpio_priv *priv;
@@ -299,8 +299,6 @@ static int dpaa2_dpio_remove(struct fsl_mc_device *dpio_dev)
 
 err_open:
 	fsl_mc_portal_free(dpio_dev->mc_io);
-
-	return 0;
 }
 
 static const struct fsl_mc_device_id dpaa2_dpio_match_id_table[] = {
diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
index c89a047a4cd8..f2140e94d41e 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
@@ -570,7 +570,7 @@ static void vfio_fsl_mc_release_dev(struct vfio_device *core_vdev)
 	mutex_destroy(&vdev->igate);
 }
 
-static int vfio_fsl_mc_remove(struct fsl_mc_device *mc_dev)
+static void vfio_fsl_mc_remove(struct fsl_mc_device *mc_dev)
 {
 	struct device *dev = &mc_dev->dev;
 	struct vfio_fsl_mc_device *vdev = dev_get_drvdata(dev);
@@ -578,7 +578,6 @@ static int vfio_fsl_mc_remove(struct fsl_mc_device *mc_dev)
 	vfio_unregister_group_dev(&vdev->vdev);
 	dprc_remove_devices(mc_dev, NULL, 0);
 	vfio_put_device(&vdev->vdev);
-	return 0;
 }
 
 static const struct vfio_device_ops vfio_fsl_mc_ops = {
diff --git a/include/linux/fsl/mc.h b/include/linux/fsl/mc.h
index a86115bc799c..a1b3de87a3d1 100644
--- a/include/linux/fsl/mc.h
+++ b/include/linux/fsl/mc.h
@@ -48,7 +48,7 @@ struct fsl_mc_driver {
 	struct device_driver driver;
 	const struct fsl_mc_device_id *match_id_table;
 	int (*probe)(struct fsl_mc_device *dev);
-	int (*remove)(struct fsl_mc_device *dev);
+	void (*remove)(struct fsl_mc_device *dev);
 	void (*shutdown)(struct fsl_mc_device *dev);
 	int (*suspend)(struct fsl_mc_device *dev, pm_message_t state);
 	int (*resume)(struct fsl_mc_device *dev);
-- 
2.39.1

