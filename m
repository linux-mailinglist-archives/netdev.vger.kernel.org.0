Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95D3741814B
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 13:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244876AbhIYLY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 07:24:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:55572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244725AbhIYLYv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Sep 2021 07:24:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD4986127C;
        Sat, 25 Sep 2021 11:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632568996;
        bh=cCL9OPu7ylTp3lXAkUh0UgmGr0ZctC2d0EdfzXcuSDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c9YNQD+E2p1TmAdtqT0WIwmiJu5kmUIVN+O+nplzesA2lLLcARe0V/utgO/vGx8lF
         DaZJnAMul9QUW5QGKzdFYXLss2DIlj4VOai0ic6LDtd7+26oCTBwNaeAJviNFDzSA1
         COwBr7dTsUw7g0++Wj9lyb3LuPDjKcbnr2Dsrt7/p3VwD6QwP7Umb69VvNtd/6+TTj
         mlM+hoVAKG9BTNPfXEH//VST0WH4AcLFAK8sbQQC0r1UH4mERsDgPC0j9YYFdoNvy1
         4toONRoZ2+u/r7lz48dgmissq7azoDonbkAMJLJxFHBliNJx9qw8YM63YO2F/FeYr6
         6JQgCJMr6c7Cw==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>, Ariel Elior <aelior@marvell.com>,
        Bin Luo <luobin9@huawei.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Coiby Xu <coiby.xu@gmail.com>,
        Derek Chickles <dchickles@marvell.com>, drivers@pensando.io,
        Felix Manlunas <fmanlunas@marvell.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        GR-everest-linux-l2@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        hariprasad <hkelam@marvell.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Intel Corporation <linuxwwan@intel.com>,
        intel-wired-lan@lists.osuosl.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jerin Jacob <jerinj@marvell.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Linu Cherian <lcherian@marvell.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-staging@lists.linux.dev,
        Loic Poulain <loic.poulain@linaro.org>,
        Manish Chopra <manishc@marvell.com>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Michael Guralnik <michaelgur@mellanox.com>,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        Richard Cochran <richardcochran@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Satanand Burla <sburla@marvell.com>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Shannon Nelson <snelson@pensando.io>,
        Simon Horman <simon.horman@corigine.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next v1 04/21] dpaa2-eth: Register devlink instance at the end of probe
Date:   Sat, 25 Sep 2021 14:22:44 +0300
Message-Id: <c6abd202014523d6e685a97c0ec844d2756ffd34.1632565508.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1632565508.git.leonro@nvidia.com>
References: <cover.1632565508.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Move devlink_register to be the last command in the initialization
sequence.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../ethernet/freescale/dpaa2/dpaa2-eth-devlink.c   | 14 +++++++++++---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |  9 ++++++---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h   |  5 ++++-
 3 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.c
index 426926fb6fc6..7fefe1574b6a 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.c
@@ -189,7 +189,7 @@ static const struct devlink_ops dpaa2_eth_devlink_ops = {
 	.trap_group_action_set = dpaa2_eth_dl_trap_group_action_set,
 };
 
-int dpaa2_eth_dl_register(struct dpaa2_eth_priv *priv)
+int dpaa2_eth_dl_alloc(struct dpaa2_eth_priv *priv)
 {
 	struct net_device *net_dev = priv->net_dev;
 	struct device *dev = net_dev->dev.parent;
@@ -203,15 +203,23 @@ int dpaa2_eth_dl_register(struct dpaa2_eth_priv *priv)
 	}
 	dl_priv = devlink_priv(priv->devlink);
 	dl_priv->dpaa2_priv = priv;
+	return 0;
+}
+
+void dpaa2_eth_dl_free(struct dpaa2_eth_priv *priv)
+{
+	devlink_free(priv->devlink);
+}
+
 
+void dpaa2_eth_dl_register(struct dpaa2_eth_priv *priv)
+{
 	devlink_register(priv->devlink);
-	return 0;
 }
 
 void dpaa2_eth_dl_unregister(struct dpaa2_eth_priv *priv)
 {
 	devlink_unregister(priv->devlink);
-	devlink_free(priv->devlink);
 }
 
 int dpaa2_eth_dl_port_add(struct dpaa2_eth_priv *priv)
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 7065c71ed7b8..03c168b1712f 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -4431,7 +4431,7 @@ static int dpaa2_eth_probe(struct fsl_mc_device *dpni_dev)
 	if (err)
 		goto err_connect_mac;
 
-	err = dpaa2_eth_dl_register(priv);
+	err = dpaa2_eth_dl_alloc(priv);
 	if (err)
 		goto err_dl_register;
 
@@ -4453,6 +4453,7 @@ static int dpaa2_eth_probe(struct fsl_mc_device *dpni_dev)
 	dpaa2_dbg_add(priv);
 #endif
 
+	dpaa2_eth_dl_register(priv);
 	dev_info(dev, "Probed interface %s\n", net_dev->name);
 	return 0;
 
@@ -4461,7 +4462,7 @@ static int dpaa2_eth_probe(struct fsl_mc_device *dpni_dev)
 err_dl_port_add:
 	dpaa2_eth_dl_traps_unregister(priv);
 err_dl_trap_register:
-	dpaa2_eth_dl_unregister(priv);
+	dpaa2_eth_dl_free(priv);
 err_dl_register:
 	dpaa2_eth_disconnect_mac(priv);
 err_connect_mac:
@@ -4508,6 +4509,8 @@ static int dpaa2_eth_remove(struct fsl_mc_device *ls_dev)
 	net_dev = dev_get_drvdata(dev);
 	priv = netdev_priv(net_dev);
 
+	dpaa2_eth_dl_unregister(priv);
+
 #ifdef CONFIG_DEBUG_FS
 	dpaa2_dbg_remove(priv);
 #endif
@@ -4519,7 +4522,7 @@ static int dpaa2_eth_remove(struct fsl_mc_device *ls_dev)
 
 	dpaa2_eth_dl_port_del(priv);
 	dpaa2_eth_dl_traps_unregister(priv);
-	dpaa2_eth_dl_unregister(priv);
+	dpaa2_eth_dl_free(priv);
 
 	if (priv->do_link_poll)
 		kthread_stop(priv->poll_thread);
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index cdb623d5f2c1..628d2d45f045 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -725,7 +725,10 @@ void dpaa2_eth_set_rx_taildrop(struct dpaa2_eth_priv *priv,
 
 extern const struct dcbnl_rtnl_ops dpaa2_eth_dcbnl_ops;
 
-int dpaa2_eth_dl_register(struct dpaa2_eth_priv *priv);
+int dpaa2_eth_dl_alloc(struct dpaa2_eth_priv *priv);
+void dpaa2_eth_dl_free(struct dpaa2_eth_priv *priv);
+
+void dpaa2_eth_dl_register(struct dpaa2_eth_priv *priv);
 void dpaa2_eth_dl_unregister(struct dpaa2_eth_priv *priv);
 
 int dpaa2_eth_dl_port_add(struct dpaa2_eth_priv *priv);
-- 
2.31.1

