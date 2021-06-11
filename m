Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B54333A3F47
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 11:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231494AbhFKJoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 05:44:38 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:39740 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231514AbhFKJoe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 05:44:34 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15B9fF65022658;
        Fri, 11 Jun 2021 02:42:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=Fcek1SCDFO82tqQQgt1SVgiPq1/IH8swkLzldiUqNAA=;
 b=gLqyOxJRAj9bBg7bR7t1cUdAKY/8M+7l0PT01ewmomD5X1HVAEgxFGSzfktVarARmN2B
 KB3OieShnTd/5hAppGmUCUz4smbptMfa5BPkE4Z6pe86xYXsyYHYV8nGZLTMGTuy4dQR
 X6ZQOYnkgZCLYXs3kWY9AD4if7Z7k6xmfOcRVFIA9JCpSsLUQ9JKwVY2hX5z9hLHYOUn
 9XQxHoCx/g5Mn4h4KECINEgxMzmMTRIOJ41HDTUPUgOHl8m1NCYAIPPrR+bAzbt2YS5j
 EqG03tn0fPmrydCS3LI+7YcN/z4dfLHTYV/cJfinnlQaljxJn4d/8Sv2ZSSQVkiGmbqg zA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 39417n8vbe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 11 Jun 2021 02:42:34 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 11 Jun
 2021 02:42:32 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 11 Jun 2021 02:42:33 -0700
Received: from #hyd1583.marvell.com (unknown [10.29.37.44])
        by maili.marvell.com (Postfix) with ESMTP id 130933F7077;
        Fri, 11 Jun 2021 02:42:29 -0700 (PDT)
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <sgoutham@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>, <lcherian@marvell.com>, <gakula@marvell.com>,
        Naveen Mamindlapalli <naveenm@marvell.com>,
        Sunil Kovvuri Goutham <Sunil.Goutham@marvell.com>
Subject: [PATCH net-next 4/4] octeontx2-pf: add support for ndo_set_vf_trust
Date:   Fri, 11 Jun 2021 15:12:05 +0530
Message-ID: <20210611094205.28230-5-naveenm@marvell.com>
X-Mailer: git-send-email 2.16.5
In-Reply-To: <20210611094205.28230-1-naveenm@marvell.com>
References: <20210611094205.28230-1-naveenm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: A5275JbPiL7vbV2XZSrhRS6u7Iiyh0sy
X-Proofpoint-ORIG-GUID: A5275JbPiL7vbV2XZSrhRS6u7Iiyh0sy
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-11_03:2021-06-11,2021-06-11 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hariprasad Kelam <hkelam@marvell.com>

Add support for setting a VF as a trusted VF by PF admin. Trusted VF
feature allows VFs to perform priviliged operations such as enabling
VF promiscuous mode, all-multicast mode and changing the VF MAC address
even if it was assigned by PF.

Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <Sunil.Goutham@marvell.com>
---
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   6 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   | 128 +++++++++++++++++----
 2 files changed, 109 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 45730d0d92f2..543aee726fbe 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -223,6 +223,11 @@ struct otx2_hw {
 	u64			*nix_lmt_base;
 };
 
+enum vfperm {
+	OTX2_RESET_VF_PERM,
+	OTX2_TRUSTED_VF,
+};
+
 struct otx2_vf_config {
 	struct otx2_nic *pf;
 	struct delayed_work link_event_work;
@@ -230,6 +235,7 @@ struct otx2_vf_config {
 	u8 mac[ETH_ALEN];
 	u16 vlan;
 	int tx_vtag_idx;
+	bool trusted;
 };
 
 struct flr_work {
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index dcc6b74471e3..82b53e72268f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -39,6 +39,8 @@ MODULE_DESCRIPTION(DRV_STRING);
 MODULE_LICENSE("GPL v2");
 MODULE_DEVICE_TABLE(pci, otx2_pf_id_table);
 
+static void otx2_vf_link_event_task(struct work_struct *work);
+
 enum {
 	TYPE_PFAF,
 	TYPE_PFVF,
@@ -2046,7 +2048,7 @@ static int otx2_set_vf_mac(struct net_device *netdev, int vf, u8 *mac)
 	if (!netif_running(netdev))
 		return -EAGAIN;
 
-	if (vf >= pci_num_vf(pdev))
+	if (vf >= pf->total_vfs)
 		return -EINVAL;
 
 	if (!is_valid_ether_addr(mac))
@@ -2057,7 +2059,8 @@ static int otx2_set_vf_mac(struct net_device *netdev, int vf, u8 *mac)
 
 	ret = otx2_do_set_vf_mac(pf, vf, mac);
 	if (ret == 0)
-		dev_info(&pdev->dev, "Reload VF driver to apply the changes\n");
+		dev_info(&pdev->dev,
+			 "Load/Reload VF driver\n");
 
 	return ret;
 }
@@ -2243,10 +2246,63 @@ static int otx2_get_vf_config(struct net_device *netdev, int vf,
 	ivi->vf = vf;
 	ether_addr_copy(ivi->mac, config->mac);
 	ivi->vlan = config->vlan;
+	ivi->trusted = config->trusted;
 
 	return 0;
 }
 
+static int otx2_set_vf_permissions(struct otx2_nic *pf, int vf,
+				   int req_perm)
+{
+	struct set_vf_perm *req;
+	int rc;
+
+	mutex_lock(&pf->mbox.lock);
+	req = otx2_mbox_alloc_msg_set_vf_perm(&pf->mbox);
+	if (!req) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	/* Let AF reset VF permissions as sriov is disabled */
+	if (req_perm == OTX2_RESET_VF_PERM) {
+		req->flags |= RESET_VF_PERM;
+	} else if (req_perm == OTX2_TRUSTED_VF) {
+		if (pf->vf_configs[vf].trusted)
+			req->flags |= VF_TRUSTED;
+	}
+
+	req->vf = vf;
+	rc = otx2_sync_mbox_msg(&pf->mbox);
+out:
+	mutex_unlock(&pf->mbox.lock);
+	return rc;
+}
+
+static int otx2_ndo_set_vf_trust(struct net_device *netdev, int vf,
+				 bool enable)
+{
+	struct otx2_nic *pf = netdev_priv(netdev);
+	struct pci_dev *pdev = pf->pdev;
+	int rc;
+
+	if (vf >= pci_num_vf(pdev))
+		return -EINVAL;
+
+	if (pf->vf_configs[vf].trusted == enable)
+		return 0;
+
+	pf->vf_configs[vf].trusted = enable;
+	rc = otx2_set_vf_permissions(pf, vf, OTX2_TRUSTED_VF);
+
+	if (rc)
+		pf->vf_configs[vf].trusted = !enable;
+	else
+		netdev_info(pf->netdev, "VF %d is %strusted\n",
+			    vf, enable ? "" : "not ");
+	return rc;
+}
+
 static const struct net_device_ops otx2_netdev_ops = {
 	.ndo_open		= otx2_open,
 	.ndo_stop		= otx2_stop,
@@ -2263,6 +2319,7 @@ static const struct net_device_ops otx2_netdev_ops = {
 	.ndo_set_vf_vlan	= otx2_set_vf_vlan,
 	.ndo_get_vf_config	= otx2_get_vf_config,
 	.ndo_setup_tc		= otx2_setup_tc,
+	.ndo_set_vf_trust	= otx2_ndo_set_vf_trust,
 };
 
 static int otx2_wq_init(struct otx2_nic *pf)
@@ -2317,6 +2374,40 @@ static int otx2_realloc_msix_vectors(struct otx2_nic *pf)
 	return otx2_register_mbox_intr(pf, false);
 }
 
+static int otx2_sriov_vfcfg_init(struct otx2_nic *pf)
+{
+	int i;
+
+	pf->vf_configs = devm_kcalloc(pf->dev, pf->total_vfs,
+				      sizeof(struct otx2_vf_config),
+				      GFP_KERNEL);
+	if (!pf->vf_configs)
+		return -ENOMEM;
+
+	for (i = 0; i < pf->total_vfs; i++) {
+		pf->vf_configs[i].pf = pf;
+		pf->vf_configs[i].intf_down = true;
+		pf->vf_configs[i].trusted = false;
+		INIT_DELAYED_WORK(&pf->vf_configs[i].link_event_work,
+				  otx2_vf_link_event_task);
+	}
+
+	return 0;
+}
+
+static void otx2_sriov_vfcfg_cleanup(struct otx2_nic *pf)
+{
+	int i;
+
+	if (!pf->vf_configs)
+		return;
+
+	for (i = 0; i < pf->total_vfs; i++) {
+		cancel_delayed_work_sync(&pf->vf_configs[i].link_event_work);
+		otx2_set_vf_permissions(pf, i, OTX2_RESET_VF_PERM);
+	}
+}
+
 static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct device *dev = &pdev->dev;
@@ -2511,6 +2602,11 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (err)
 		goto err_mcam_flow_del;
 
+	/* Initialize SR-IOV resources */
+	err = otx2_sriov_vfcfg_init(pf);
+	if (err)
+		goto err_pf_sriov_init;
+
 	/* Enable link notifications */
 	otx2_cgx_config_linkevents(pf, true);
 
@@ -2520,6 +2616,8 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	return 0;
 
+err_pf_sriov_init:
+	otx2_shutdown_tc(pf);
 err_mcam_flow_del:
 	otx2_mcam_flow_del(pf);
 err_unreg_netdev:
@@ -2578,7 +2676,7 @@ static int otx2_sriov_enable(struct pci_dev *pdev, int numvfs)
 {
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct otx2_nic *pf = netdev_priv(netdev);
-	int ret, i;
+	int ret;
 
 	/* Init PF <=> VF mailbox stuff */
 	ret = otx2_pfvf_mbox_init(pf, numvfs);
@@ -2589,23 +2687,9 @@ static int otx2_sriov_enable(struct pci_dev *pdev, int numvfs)
 	if (ret)
 		goto free_mbox;
 
-	pf->vf_configs = kcalloc(numvfs, sizeof(struct otx2_vf_config),
-				 GFP_KERNEL);
-	if (!pf->vf_configs) {
-		ret = -ENOMEM;
-		goto free_intr;
-	}
-
-	for (i = 0; i < numvfs; i++) {
-		pf->vf_configs[i].pf = pf;
-		pf->vf_configs[i].intf_down = true;
-		INIT_DELAYED_WORK(&pf->vf_configs[i].link_event_work,
-				  otx2_vf_link_event_task);
-	}
-
 	ret = otx2_pf_flr_init(pf, numvfs);
 	if (ret)
-		goto free_configs;
+		goto free_intr;
 
 	ret = otx2_register_flr_me_intr(pf, numvfs);
 	if (ret)
@@ -2620,8 +2704,6 @@ static int otx2_sriov_enable(struct pci_dev *pdev, int numvfs)
 	otx2_disable_flr_me_intr(pf);
 free_flr:
 	otx2_flr_wq_destroy(pf);
-free_configs:
-	kfree(pf->vf_configs);
 free_intr:
 	otx2_disable_pfvf_mbox_intr(pf, numvfs);
 free_mbox:
@@ -2634,17 +2716,12 @@ static int otx2_sriov_disable(struct pci_dev *pdev)
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct otx2_nic *pf = netdev_priv(netdev);
 	int numvfs = pci_num_vf(pdev);
-	int i;
 
 	if (!numvfs)
 		return 0;
 
 	pci_disable_sriov(pdev);
 
-	for (i = 0; i < pci_num_vf(pdev); i++)
-		cancel_delayed_work_sync(&pf->vf_configs[i].link_event_work);
-	kfree(pf->vf_configs);
-
 	otx2_disable_flr_me_intr(pf);
 	otx2_flr_wq_destroy(pf);
 	otx2_disable_pfvf_mbox_intr(pf, numvfs);
@@ -2684,6 +2761,7 @@ static void otx2_remove(struct pci_dev *pdev)
 
 	unregister_netdev(netdev);
 	otx2_sriov_disable(pf->pdev);
+	otx2_sriov_vfcfg_cleanup(pf);
 	if (pf->otx2_wq)
 		destroy_workqueue(pf->otx2_wq);
 
-- 
2.16.5

