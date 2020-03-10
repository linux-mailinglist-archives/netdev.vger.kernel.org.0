Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7142218074E
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 19:47:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbgCJSrv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 14:47:51 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37673 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727228AbgCJSrt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 14:47:49 -0400
Received: by mail-pg1-f195.google.com with SMTP id z12so6712446pgl.4
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 11:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=rRK/Wprle/CrsWQw9gWRJ27HxJuORYrAjy+4dAA7sEA=;
        b=E/49W+ln7QibhLevJQB3QuH2VyUR4+f1ZhpGc+ErfIsUI70ENqia6wVrWnwCzmH8Tu
         IELHKIfa2Qtdt1YwjLHxLNfspVhQZWt4U2zlEMdczJlZ/B4fHlsGyZxumD0GZtWgxNW7
         bjyq/CYMtuexl+PyfZ7L5gkBtOgU9qqWDD4znKdQGmOuaFWc0WQCIZYbpDWG8BZnlu7/
         QX4nVyvI9p5+BltbnRHfWLZgKGETQD5lwcm1dftlZEQDtAy8AkivvIcmI/H1QruahlaB
         BU874qtgu7jkc48AIcAnQHTiNVmL/DcCkaNiNAcHDfOJ0HqM86nt3BJHHktZofNUohEi
         He4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=rRK/Wprle/CrsWQw9gWRJ27HxJuORYrAjy+4dAA7sEA=;
        b=YDPsdKcX1Eqg+0IhM7r/sfFdZGWWktAK/c6bFWExhPAfv2htRPH4bbWxlR6HOsPVYd
         FP1Ufj/LpVbgyAVcnSxjsG/tiDW1HrcquO2jhNeTgEXf1uQXaEnDGyG00kvoN22FvpJz
         6IJwrE0fdYugnb4jsd04a2b+520tE2HjJn3r5Z3ceUW8QM3YqkbHZZaCmHGG18rn0G/o
         y3ZBSvyLCU3XeGuu7BClGkpTyaTi7u8H/4ztIcCgvQFP0+/Aj7jEhOyf+dneuZd7zE5m
         zrHlBV+mOPEFi4ZudTEnSskbU3Lb1wVPvf8cyMqMAIFYW7iD2vvYdy2lbYaiZeCUEHjq
         tnig==
X-Gm-Message-State: ANhLgQ2Q3az6hDoP59AHMvgGuujxDqL0v+qFNLbd+D+4mGviZxR+j2pj
        SmC6i07xF0i0DxqFuXuF9TXdBd40/Go=
X-Google-Smtp-Source: ADFU+vtV04JfGmgD70NJZz0C7CxsGe3YR7PHswwOJnERXKKugWGAkgmyI6KMZZp1BrE5gO4vl+0nKA==
X-Received: by 2002:a63:c601:: with SMTP id w1mr21401189pgg.449.1583866066765;
        Tue, 10 Mar 2020 11:47:46 -0700 (PDT)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id v67sm4240490pfc.120.2020.03.10.11.47.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 10 Mar 2020 11:47:46 -0700 (PDT)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Tomasz Duszynski <tduszynski@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH net-next 4/6] octeontx2-vf: Ethtool support
Date:   Wed, 11 Mar 2020 00:17:23 +0530
Message-Id: <1583866045-7129-5-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1583866045-7129-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1583866045-7129-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tomasz Duszynski <tduszynski@marvell.com>

Added ethtool support for VF devices for
 - Driver stats, Tx/Rx perqueue stats
 - Set/show Rx/Tx queue count
 - Set/show Rx/Tx ring sizes
 - Set/show IRQ coalescing parameters
 - RSS configuration etc

It's the PF which owns the interface, hence VF
cannot display underlying CGX interface stats.
Except for this rest ethtool support reuses PF's
APIs.

Signed-off-by: Tomasz Duszynski <tduszynski@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   1 +
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  | 131 ++++++++++++++++++++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |   4 +
 3 files changed, 134 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index ca757b2..95b8f1e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -631,6 +631,7 @@ void otx2_update_lmac_stats(struct otx2_nic *pfvf);
 int otx2_update_rq_stats(struct otx2_nic *pfvf, int qidx);
 int otx2_update_sq_stats(struct otx2_nic *pfvf, int qidx);
 void otx2_set_ethtool_ops(struct net_device *netdev);
+void otx2vf_set_ethtool_ops(struct net_device *netdev);
 
 int otx2_open(struct net_device *netdev);
 int otx2_stop(struct net_device *netdev);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index f450111..523aee4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -17,6 +17,7 @@
 #include "otx2_common.h"
 
 #define DRV_NAME	"octeontx2-nicpf"
+#define DRV_VF_NAME	"octeontx2-nicvf"
 
 struct otx2_stat {
 	char name[ETH_GSTRING_LEN];
@@ -63,14 +64,34 @@ static const unsigned int otx2_n_dev_stats = ARRAY_SIZE(otx2_dev_stats);
 static const unsigned int otx2_n_drv_stats = ARRAY_SIZE(otx2_drv_stats);
 static const unsigned int otx2_n_queue_stats = ARRAY_SIZE(otx2_queue_stats);
 
+int __weak otx2vf_open(struct net_device *netdev)
+{
+	return 0;
+}
+
+int __weak otx2vf_stop(struct net_device *netdev)
+{
+	return 0;
+}
+
 static void otx2_dev_open(struct net_device *netdev)
 {
-	otx2_open(netdev);
+	struct otx2_nic *pfvf = netdev_priv(netdev);
+
+	if (pfvf->pcifunc & RVU_PFVF_FUNC_MASK)
+		otx2vf_open(netdev);
+	else
+		otx2_open(netdev);
 }
 
 static void otx2_dev_stop(struct net_device *netdev)
 {
-	otx2_stop(netdev);
+	struct otx2_nic *pfvf = netdev_priv(netdev);
+
+	if (pfvf->pcifunc & RVU_PFVF_FUNC_MASK)
+		otx2vf_stop(netdev);
+	else
+		otx2_stop(netdev);
 }
 
 static void otx2_get_drvinfo(struct net_device *netdev,
@@ -259,6 +280,9 @@ static void otx2_get_pauseparam(struct net_device *netdev,
 	struct otx2_nic *pfvf = netdev_priv(netdev);
 	struct cgx_pause_frm_cfg *req, *rsp;
 
+	if (is_otx2_lbkvf(pfvf->pdev))
+		return;
+
 	req = otx2_mbox_alloc_msg_cgx_cfg_pause_frm(&pfvf->mbox);
 	if (!req)
 		return;
@@ -279,6 +303,9 @@ static int otx2_set_pauseparam(struct net_device *netdev,
 	if (pause->autoneg)
 		return -EOPNOTSUPP;
 
+	if (is_otx2_lbkvf(pfvf->pdev))
+		return -EOPNOTSUPP;
+
 	if (pause->rx_pause)
 		pfvf->flags |= OTX2_FLAG_RX_PAUSE_ENABLED;
 	else
@@ -670,6 +697,9 @@ static u32 otx2_get_link(struct net_device *netdev)
 {
 	struct otx2_nic *pfvf = netdev_priv(netdev);
 
+	/* LBK link is internal and always UP */
+	if (is_otx2_lbkvf(pfvf->pdev))
+		return 1;
 	return pfvf->linfo.link_up;
 }
 
@@ -701,3 +731,100 @@ void otx2_set_ethtool_ops(struct net_device *netdev)
 {
 	netdev->ethtool_ops = &otx2_ethtool_ops;
 }
+
+/* VF's ethtool APIs */
+static void otx2vf_get_drvinfo(struct net_device *netdev,
+			       struct ethtool_drvinfo *info)
+{
+	struct otx2_nic *vf = netdev_priv(netdev);
+
+	strlcpy(info->driver, DRV_VF_NAME, sizeof(info->driver));
+	strlcpy(info->bus_info, pci_name(vf->pdev), sizeof(info->bus_info));
+}
+
+static void otx2vf_get_strings(struct net_device *netdev, u32 sset, u8 *data)
+{
+	struct otx2_nic *vf = netdev_priv(netdev);
+	int stats;
+
+	if (sset != ETH_SS_STATS)
+		return;
+
+	for (stats = 0; stats < otx2_n_dev_stats; stats++) {
+		memcpy(data, otx2_dev_stats[stats].name, ETH_GSTRING_LEN);
+		data += ETH_GSTRING_LEN;
+	}
+
+	for (stats = 0; stats < otx2_n_drv_stats; stats++) {
+		memcpy(data, otx2_drv_stats[stats].name, ETH_GSTRING_LEN);
+		data += ETH_GSTRING_LEN;
+	}
+
+	otx2_get_qset_strings(vf, &data, 0);
+
+	strcpy(data, "reset_count");
+	data += ETH_GSTRING_LEN;
+}
+
+static void otx2vf_get_ethtool_stats(struct net_device *netdev,
+				     struct ethtool_stats *stats, u64 *data)
+{
+	struct otx2_nic *vf = netdev_priv(netdev);
+	int stat;
+
+	otx2_get_dev_stats(vf);
+	for (stat = 0; stat < otx2_n_dev_stats; stat++)
+		*(data++) = ((u64 *)&vf->hw.dev_stats)
+				[otx2_dev_stats[stat].index];
+
+	for (stat = 0; stat < otx2_n_drv_stats; stat++)
+		*(data++) = atomic_read(&((atomic_t *)&vf->hw.drv_stats)
+						[otx2_drv_stats[stat].index]);
+
+	otx2_get_qset_stats(vf, stats, &data);
+	*(data++) = vf->reset_count;
+}
+
+static int otx2vf_get_sset_count(struct net_device *netdev, int sset)
+{
+	struct otx2_nic *vf = netdev_priv(netdev);
+	int qstats_count;
+
+	if (sset != ETH_SS_STATS)
+		return -EINVAL;
+
+	qstats_count = otx2_n_queue_stats *
+		       (vf->hw.rx_queues + vf->hw.tx_queues);
+
+	return otx2_n_dev_stats + otx2_n_drv_stats + qstats_count + 1;
+}
+
+static const struct ethtool_ops otx2vf_ethtool_ops = {
+	.get_link		= otx2_get_link,
+	.get_drvinfo		= otx2vf_get_drvinfo,
+	.get_strings		= otx2vf_get_strings,
+	.get_ethtool_stats	= otx2vf_get_ethtool_stats,
+	.get_sset_count		= otx2vf_get_sset_count,
+	.set_channels		= otx2_set_channels,
+	.get_channels		= otx2_get_channels,
+	.get_rxnfc		= otx2_get_rxnfc,
+	.set_rxnfc              = otx2_set_rxnfc,
+	.get_rxfh_key_size	= otx2_get_rxfh_key_size,
+	.get_rxfh_indir_size	= otx2_get_rxfh_indir_size,
+	.get_rxfh		= otx2_get_rxfh,
+	.set_rxfh		= otx2_set_rxfh,
+	.get_ringparam		= otx2_get_ringparam,
+	.set_ringparam		= otx2_set_ringparam,
+	.get_coalesce		= otx2_get_coalesce,
+	.set_coalesce		= otx2_set_coalesce,
+	.get_msglevel		= otx2_get_msglevel,
+	.set_msglevel		= otx2_set_msglevel,
+	.get_pauseparam		= otx2_get_pauseparam,
+	.set_pauseparam		= otx2_set_pauseparam,
+};
+
+void otx2vf_set_ethtool_ops(struct net_device *netdev)
+{
+	netdev->ethtool_ops = &otx2vf_ethtool_ops;
+}
+EXPORT_SYMBOL(otx2vf_set_ethtool_ops);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index 6ca958d..6dc70a7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -383,11 +383,13 @@ int otx2vf_open(struct net_device *netdev)
 
 	return 0;
 }
+EXPORT_SYMBOL(otx2vf_open);
 
 int otx2vf_stop(struct net_device *netdev)
 {
 	return otx2_stop(netdev);
 }
+EXPORT_SYMBOL(otx2vf_stop);
 
 static netdev_tx_t otx2vf_xmit(struct sk_buff *skb, struct net_device *netdev)
 {
@@ -603,6 +605,8 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_detach_rsrc;
 	}
 
+	otx2vf_set_ethtool_ops(netdev);
+
 	/* Enable pause frames by default */
 	vf->flags |= OTX2_FLAG_RX_PAUSE_ENABLED;
 	vf->flags |= OTX2_FLAG_TX_PAUSE_ENABLED;
-- 
2.7.4

