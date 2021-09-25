Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0141941817D
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 13:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343630AbhIYLZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 07:25:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:56594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245343AbhIYLZW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Sep 2021 07:25:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D4856128B;
        Sat, 25 Sep 2021 11:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632569028;
        bh=PMH85H5qipZOBKpjQUuS38xXXX8zD2iZVNUxRrzSq2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bl6F2XX2QrtGJ/goSxrWiZ4kTfaDRalUW+JX64R4+f5tX2MkVbudqMboMu4+2r17G
         9ypRSr6/TbxTX5ORpt0WdmEFf4Q9lTCPiz+FKtPuz9OazWtk3RxYg4dOQIG3qJItpb
         pbsdhwETQqV8zGIh6DTOueiiB6dX2qdXhef22O55T8LHb5HQ/oDZd4nwPrZj/bqO7m
         JhHZtPN0ApEbgjNw6XG7w2GgfEOi/wJOq/MBu65oKBl7Ftd6PTsLr9J/BfEnVlCops
         Kpqi2qjOoxhp/Ux5Aml2oWUSJR2F3fXuK8NnJcOU5kQF7HvO859ztbO8XzHL22qlxH
         S0xx6v652WI1Q==
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
Subject: [PATCH net-next v1 13/21] nfp: Move delink_register to be last command
Date:   Sat, 25 Sep 2021 14:22:53 +0300
Message-Id: <f393212ad3906808ee7eb5cff06ef2e053eb9d2b.1632565508.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1632565508.git.leonro@nvidia.com>
References: <cover.1632565508.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Open user space access to the devlink after driver is probed.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/netronome/nfp/devlink_param.c | 9 ++-------
 drivers/net/ethernet/netronome/nfp/nfp_net_main.c  | 5 ++---
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/devlink_param.c b/drivers/net/ethernet/netronome/nfp/devlink_param.c
index 36491835ac65..db297ee4d7ad 100644
--- a/drivers/net/ethernet/netronome/nfp/devlink_param.c
+++ b/drivers/net/ethernet/netronome/nfp/devlink_param.c
@@ -233,13 +233,8 @@ int nfp_devlink_params_register(struct nfp_pf *pf)
 	if (err <= 0)
 		return err;
 
-	err = devlink_params_register(devlink, nfp_devlink_params,
-				      ARRAY_SIZE(nfp_devlink_params));
-	if (err)
-		return err;
-
-	devlink_params_publish(devlink);
-	return 0;
+	return devlink_params_register(devlink, nfp_devlink_params,
+				       ARRAY_SIZE(nfp_devlink_params));
 }
 
 void nfp_devlink_params_unregister(struct nfp_pf *pf)
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_main.c b/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
index 616872928ada..5fbb7c613ff1 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
@@ -701,7 +701,6 @@ int nfp_net_pci_probe(struct nfp_pf *pf)
 	if (err)
 		goto err_unmap;
 
-	devlink_register(devlink);
 	err = nfp_shared_buf_register(pf);
 	if (err)
 		goto err_devlink_unreg;
@@ -731,6 +730,7 @@ int nfp_net_pci_probe(struct nfp_pf *pf)
 		goto err_stop_app;
 
 	mutex_unlock(&pf->lock);
+	devlink_register(devlink);
 
 	return 0;
 
@@ -748,7 +748,6 @@ int nfp_net_pci_probe(struct nfp_pf *pf)
 	nfp_shared_buf_unregister(pf);
 err_devlink_unreg:
 	cancel_work_sync(&pf->port_refresh_work);
-	devlink_unregister(devlink);
 	nfp_net_pf_app_clean(pf);
 err_unmap:
 	nfp_net_pci_unmap_mem(pf);
@@ -759,6 +758,7 @@ void nfp_net_pci_remove(struct nfp_pf *pf)
 {
 	struct nfp_net *nn, *next;
 
+	devlink_unregister(priv_to_devlink(pf));
 	mutex_lock(&pf->lock);
 	list_for_each_entry_safe(nn, next, &pf->vnics, vnic_list) {
 		if (!nfp_net_is_data_vnic(nn))
@@ -775,7 +775,6 @@ void nfp_net_pci_remove(struct nfp_pf *pf)
 
 	nfp_devlink_params_unregister(pf);
 	nfp_shared_buf_unregister(pf);
-	devlink_unregister(priv_to_devlink(pf));
 
 	nfp_net_pf_free_irqs(pf);
 	nfp_net_pf_app_clean(pf);
-- 
2.31.1

