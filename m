Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A859268E480
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 00:40:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbjBGXkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 18:40:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbjBGXkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 18:40:32 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2041.outbound.protection.outlook.com [40.107.244.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1093529145
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 15:40:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EZvkTYBprTuSfRbGdmyd149IeC7xUZXAQ6vOYbKaZckWFOPACuAhr2lGmlMBYWnsEyluzmNj607cYYo5KTqykvUzv7dsX1iVkuzq2BqU8SKYKDeeUwI7xyMrVbqMiaeobonDYBTW9wldb1Rpmv7ZUY2PP/mwgG+bNwmtt9HMXMHLdCP8KXE5n2c0fLSDRMKqLBls/viy0kcGBh4Quw4rCyp/pL87MDgQWEBXBxTM8p7gZuCAJFZkNY9OUSX7m3Jz6DwfNNiSCGpUqoXyqDhmrV4gltpJKNeZTVaYMSwceRCwcchO1Pqyk/D3lxOOVedp35RA37k6W9cjxPT5IslWNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K2DX9/EXzVzJ6ueWi+oBGONHK5JoCnVUT3A1svJY4FI=;
 b=jErF6qGETFnlCWauaRISJNsWtUMKet7MWw3k5RR2czXCO1fnmUry28/ASGp4OUY+Y1uzgU6+BEz4wOoJ1SIKdjQpyIV9N/zA/KozhNdnmHTbRT3IEHa6aTbIugyrRwnVAUBeAKlV7Ip0SJUfBWtHipgLrkImq5AJT4zY0imc0PP5oJIelM62PLE3cEeFHgZscenNDhWyrLfCheIjiWdcsVU4Gc6yx6jwBE6xuibXn91b3lcW7wJYJe1DJCadnF+XmNBOcmLKGJ41v7hjd/klsoELkNBBMThpQT16F30qE+ZLWtmERsHjbxFlo0AJC605TEW2Z3z/tyd/6f6C21Od9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K2DX9/EXzVzJ6ueWi+oBGONHK5JoCnVUT3A1svJY4FI=;
 b=sDaDzTGrthoE/TKK0XMZGFv48lr74R61wrUVPwF1/MCUlu56Yi2m+O949xlh6IxpzLGq37hbDfoPApOOB5TEAlAOuSEffU/wI0HzHVtuHwM09p7x/fYIqOHKM62zB5qZMFGxTd7l7Wiuy5aE47anYQKqbMWRT7qWtCCA7u/blDc=
Received: from CY5PR13CA0016.namprd13.prod.outlook.com (2603:10b6:930::13) by
 MW3PR12MB4345.namprd12.prod.outlook.com (2603:10b6:303:59::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.36; Tue, 7 Feb 2023 23:40:26 +0000
Received: from CY4PEPF0000C982.namprd02.prod.outlook.com
 (2603:10b6:930:0:cafe::b2) by CY5PR13CA0016.outlook.office365.com
 (2603:10b6:930::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.16 via Frontend
 Transport; Tue, 7 Feb 2023 23:40:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C982.mail.protection.outlook.com (10.167.241.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6086.16 via Frontend Transport; Tue, 7 Feb 2023 23:40:25 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 7 Feb
 2023 17:40:24 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH v3 net-next 3/3] ionic: add support for device Component Memory Buffers
Date:   Tue, 7 Feb 2023 15:40:06 -0800
Message-ID: <20230207234006.29643-4-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230207234006.29643-1-shannon.nelson@amd.com>
References: <20230207234006.29643-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C982:EE_|MW3PR12MB4345:EE_
X-MS-Office365-Filtering-Correlation-Id: ce6ed5ea-03cd-4d0d-13d0-08db0964b00f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EwY2tzZvgfDjZ4p/VxPlWP+7EBLj1C1HNZeaZYMeaAj51ZPVB4JaN2qfK56EcUWc8bYVQ70G7W77jEZ0BbG82TCx34vOzsUfQfqiEIQMGSd1fPHVorTmZj6evyMHSHovBLXZ8LGPyHIQFOmakgD4kkT0mqJwqXsUwuOkOVkYvJzoODtvkhvfz5Bcg6B0uAkLGDchglC1VbDzvdqy3Ass4pkRWRloEAhhgSvQydakljwnZp1FlWBKfyrIuxQDQCf/CUmtKi561oQm9A0lbYmLSgzBqPnSwQ7CRyE6iq1ZC/tsvqm1GBEvBPTdXBZyx4fO3hdb6jdnAQAvrrDJpwmL0iMCT4AwJMRHxVqKoXr/O2Umdd67AEc9R/bNRmNwj4lQBFZvDV8i5vjHXnptYhWNCKNu52KA9sgolJm1HiMFvmT94boMz5xK7gB1zmWhnF+2Eq9qzUMtu76oLK/mPGSR4uLEPne6ENbqp1QVxAegUqDuJ/H9DMa7P1rxkp48uOb6YgAeS4OyUbtvynNakiOHYxU9r7xLtw+YvZS3TYHutPYoMw1fWGUeVpnco9rz3KlQ88Sl5fT7TrNjS2YfD6bsNy/gnC6ewQ1c9HS003ATktmgGyVriqX41jtdtLFoq6mKE25hEjyzh147MsZUCG9MUMeMfHe+LNGTqtMldXYnP6q+ztCP0RGCXVGNE4xVO1/PahVSp54DV30o+//+B3la2+Ldrzwfmn0okHut7bxlaaw=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(346002)(136003)(396003)(451199018)(40470700004)(46966006)(36840700001)(2906002)(36756003)(82740400003)(40460700003)(36860700001)(356005)(81166007)(336012)(186003)(16526019)(26005)(83380400001)(426003)(2616005)(70586007)(47076005)(70206006)(316002)(4326008)(5660300002)(44832011)(41300700001)(8936002)(30864003)(8676002)(40480700001)(6666004)(1076003)(478600001)(86362001)(110136005)(54906003)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 23:40:25.7121
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ce6ed5ea-03cd-4d0d-13d0-08db0964b00f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C982.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4345
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ionic device has on-board memory (CMB) that can be used
for descriptors as a way to speed descriptor access for faster
traffic processing.  It is best used to improve latency and
packets-per-second for some profiles of small packet traffic.
It is not on by default, but can be enabled through the ethtool
priv-flags when the interface is down.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 .../ethernet/pensando/ionic/ionic_bus_pci.c   |   2 +
 .../net/ethernet/pensando/ionic/ionic_dev.c   |  67 ++++++++
 .../net/ethernet/pensando/ionic/ionic_dev.h   |  13 ++
 .../ethernet/pensando/ionic/ionic_ethtool.c   | 128 +++++++++++++-
 .../ethernet/pensando/ionic/ionic_ethtool.h   |   1 +
 .../net/ethernet/pensando/ionic/ionic_if.h    |   3 +-
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 160 ++++++++++++++++--
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  32 +++-
 .../net/ethernet/pensando/ionic/ionic_txrx.c  |  22 ++-
 9 files changed, 408 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
index 0eff78fa0565..e508f8eb43bf 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -352,6 +352,7 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 err_out_reset:
 	ionic_reset(ionic);
 err_out_teardown:
+	ionic_dev_teardown(ionic);
 	pci_clear_master(pdev);
 	/* Don't fail the probe for these errors, keep
 	 * the hw interface around for inspection
@@ -390,6 +391,7 @@ static void ionic_remove(struct pci_dev *pdev)
 
 	ionic_port_reset(ionic);
 	ionic_reset(ionic);
+	ionic_dev_teardown(ionic);
 	pci_clear_master(pdev);
 	ionic_unmap_bars(ionic);
 	pci_release_regions(pdev);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index 626b9113e7c4..9c2be75ffbab 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -92,6 +92,7 @@ int ionic_dev_setup(struct ionic *ionic)
 	unsigned int num_bars = ionic->num_bars;
 	struct ionic_dev *idev = &ionic->idev;
 	struct device *dev = ionic->dev;
+	int size;
 	u32 sig;
 
 	/* BAR0: dev_cmd and interrupts */
@@ -133,9 +134,36 @@ int ionic_dev_setup(struct ionic *ionic)
 	idev->db_pages = bar->vaddr;
 	idev->phy_db_pages = bar->bus_addr;
 
+	/* BAR2: optional controller memory mapping */
+	bar++;
+	mutex_init(&idev->cmb_inuse_lock);
+	if (num_bars < 3 || !ionic->bars[IONIC_PCI_BAR_CMB].len) {
+		idev->cmb_inuse = NULL;
+		return 0;
+	}
+
+	idev->phy_cmb_pages = bar->bus_addr;
+	idev->cmb_npages = bar->len / PAGE_SIZE;
+	size = BITS_TO_LONGS(idev->cmb_npages) * sizeof(long);
+	idev->cmb_inuse = kzalloc(size, GFP_KERNEL);
+	if (!idev->cmb_inuse)
+		dev_warn(dev, "No memory for CMB, disabling\n");
+
 	return 0;
 }
 
+void ionic_dev_teardown(struct ionic *ionic)
+{
+	struct ionic_dev *idev = &ionic->idev;
+
+	kfree(idev->cmb_inuse);
+	idev->cmb_inuse = NULL;
+	idev->phy_cmb_pages = 0;
+	idev->cmb_npages = 0;
+
+	mutex_destroy(&idev->cmb_inuse_lock);
+}
+
 /* Devcmd Interface */
 bool ionic_is_fw_running(struct ionic_dev *idev)
 {
@@ -571,6 +599,33 @@ int ionic_db_page_num(struct ionic_lif *lif, int pid)
 	return (lif->hw_index * lif->dbid_count) + pid;
 }
 
+int ionic_get_cmb(struct ionic_lif *lif, u32 *pgid, phys_addr_t *pgaddr, int order)
+{
+	struct ionic_dev *idev = &lif->ionic->idev;
+	int ret;
+
+	mutex_lock(&idev->cmb_inuse_lock);
+	ret = bitmap_find_free_region(idev->cmb_inuse, idev->cmb_npages, order);
+	mutex_unlock(&idev->cmb_inuse_lock);
+
+	if (ret < 0)
+		return ret;
+
+	*pgid = ret;
+	*pgaddr = idev->phy_cmb_pages + ret * PAGE_SIZE;
+
+	return 0;
+}
+
+void ionic_put_cmb(struct ionic_lif *lif, u32 pgid, int order)
+{
+	struct ionic_dev *idev = &lif->ionic->idev;
+
+	mutex_lock(&idev->cmb_inuse_lock);
+	bitmap_release_region(idev->cmb_inuse, pgid, order);
+	mutex_unlock(&idev->cmb_inuse_lock);
+}
+
 int ionic_cq_init(struct ionic_lif *lif, struct ionic_cq *cq,
 		  struct ionic_intr_info *intr,
 		  unsigned int num_descs, size_t desc_size)
@@ -679,6 +734,18 @@ void ionic_q_map(struct ionic_queue *q, void *base, dma_addr_t base_pa)
 		cur->desc = base + (i * q->desc_size);
 }
 
+void ionic_q_cmb_map(struct ionic_queue *q, void __iomem *base, dma_addr_t base_pa)
+{
+	struct ionic_desc_info *cur;
+	unsigned int i;
+
+	q->cmb_base = base;
+	q->cmb_base_pa = base_pa;
+
+	for (i = 0, cur = q->info; i < q->num_descs; i++, cur++)
+		cur->cmb_desc = base + (i * q->desc_size);
+}
+
 void ionic_q_sg_map(struct ionic_queue *q, void *base, dma_addr_t base_pa)
 {
 	struct ionic_desc_info *cur;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index 2a1d7b9c07e7..a4a8802f3771 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -153,6 +153,11 @@ struct ionic_dev {
 	struct ionic_intr __iomem *intr_ctrl;
 	u64 __iomem *intr_status;
 
+	struct mutex cmb_inuse_lock; /* for cmb_inuse */
+	unsigned long *cmb_inuse;
+	dma_addr_t phy_cmb_pages;
+	u32 cmb_npages;
+
 	u32 port_info_sz;
 	struct ionic_port_info *port_info;
 	dma_addr_t port_info_pa;
@@ -197,6 +202,7 @@ struct ionic_desc_info {
 		struct ionic_rxq_desc *rxq_desc;
 		struct ionic_admin_cmd *adminq_desc;
 	};
+	void __iomem *cmb_desc;
 	union {
 		void *sg_desc;
 		struct ionic_txq_sg_desc *txq_sg_desc;
@@ -233,12 +239,14 @@ struct ionic_queue {
 		struct ionic_rxq_desc *rxq;
 		struct ionic_admin_cmd *adminq;
 	};
+	void __iomem *cmb_base;
 	union {
 		void *sg_base;
 		struct ionic_txq_sg_desc *txq_sgl;
 		struct ionic_rxq_sg_desc *rxq_sgl;
 	};
 	dma_addr_t base_pa;
+	dma_addr_t cmb_base_pa;
 	dma_addr_t sg_base_pa;
 	unsigned int desc_size;
 	unsigned int sg_desc_size;
@@ -301,6 +309,7 @@ static inline bool ionic_q_has_space(struct ionic_queue *q, unsigned int want)
 
 void ionic_init_devinfo(struct ionic *ionic);
 int ionic_dev_setup(struct ionic *ionic);
+void ionic_dev_teardown(struct ionic *ionic);
 
 void ionic_dev_cmd_go(struct ionic_dev *idev, union ionic_dev_cmd *cmd);
 u8 ionic_dev_cmd_status(struct ionic_dev *idev);
@@ -336,6 +345,9 @@ void ionic_dev_cmd_adminq_init(struct ionic_dev *idev, struct ionic_qcq *qcq,
 
 int ionic_db_page_num(struct ionic_lif *lif, int pid);
 
+int ionic_get_cmb(struct ionic_lif *lif, u32 *pgid, phys_addr_t *pgaddr, int order);
+void ionic_put_cmb(struct ionic_lif *lif, u32 pgid, int order);
+
 int ionic_cq_init(struct ionic_lif *lif, struct ionic_cq *cq,
 		  struct ionic_intr_info *intr,
 		  unsigned int num_descs, size_t desc_size);
@@ -352,6 +364,7 @@ int ionic_q_init(struct ionic_lif *lif, struct ionic_dev *idev,
 		 unsigned int num_descs, size_t desc_size,
 		 size_t sg_desc_size, unsigned int pid);
 void ionic_q_map(struct ionic_queue *q, void *base, dma_addr_t base_pa);
+void ionic_q_cmb_map(struct ionic_queue *q, void __iomem *base, dma_addr_t base_pa);
 void ionic_q_sg_map(struct ionic_queue *q, void *base, dma_addr_t base_pa);
 void ionic_q_post(struct ionic_queue *q, bool ring_doorbell, ionic_desc_cb cb,
 		  void *cb_arg);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index 01c22701482d..40e657735eee 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -11,6 +11,38 @@
 #include "ionic_ethtool.h"
 #include "ionic_stats.h"
 
+static const char ionic_priv_flags_strings[][ETH_GSTRING_LEN] = {
+#define IONIC_PRIV_F_CMB_RINGS		BIT(0)
+	"cmb-rings",
+};
+
+#define IONIC_PRIV_FLAGS_COUNT ARRAY_SIZE(ionic_priv_flags_strings)
+
+static int ionic_validate_cmb_config(struct ionic_lif *lif,
+				     struct ionic_queue_params *qparam)
+{
+	int pages_have, pages_required = 0;
+	unsigned long sz;
+
+	if (!qparam->cmb_enabled)
+		return 0;
+
+	sz = sizeof(struct ionic_txq_desc) * qparam->ntxq_descs * qparam->nxqs;
+	pages_required += ALIGN(sz, PAGE_SIZE) / PAGE_SIZE;
+
+	sz = sizeof(struct ionic_rxq_desc) * qparam->nrxq_descs * qparam->nxqs;
+	pages_required += ALIGN(sz, PAGE_SIZE) / PAGE_SIZE;
+
+	pages_have = lif->ionic->bars[IONIC_PCI_BAR_CMB].len / PAGE_SIZE;
+	if (pages_required > pages_have) {
+		netdev_info(lif->netdev, "Not enough CMB pages for number of queues and size of descriptor rings, need %d have %d",
+			    pages_required, pages_have);
+		return -ENOMEM;
+	}
+
+	return pages_required;
+}
+
 static void ionic_get_stats_strings(struct ionic_lif *lif, u8 *buf)
 {
 	u32 i;
@@ -52,6 +84,9 @@ static int ionic_get_sset_count(struct net_device *netdev, int sset)
 	case ETH_SS_STATS:
 		count = ionic_get_stats_count(lif);
 		break;
+	case ETH_SS_PRIV_FLAGS:
+		count = IONIC_PRIV_FLAGS_COUNT;
+		break;
 	}
 	return count;
 }
@@ -65,6 +100,10 @@ static void ionic_get_strings(struct net_device *netdev,
 	case ETH_SS_STATS:
 		ionic_get_stats_strings(lif, buf);
 		break;
+	case ETH_SS_PRIV_FLAGS:
+		memcpy(buf, ionic_priv_flags_strings,
+		       IONIC_PRIV_FLAGS_COUNT * ETH_GSTRING_LEN);
+		break;
 	}
 }
 
@@ -554,6 +593,13 @@ static int ionic_set_ringparam(struct net_device *netdev,
 	    ring->rx_pending == lif->nrxq_descs)
 		return 0;
 
+	qparam.ntxq_descs = ring->tx_pending;
+	qparam.nrxq_descs = ring->rx_pending;
+
+	err = ionic_validate_cmb_config(lif, &qparam);
+	if (err < 0)
+		return err;
+
 	if (ring->tx_pending != lif->ntxq_descs)
 		netdev_info(netdev, "Changing Tx ring size from %d to %d\n",
 			    lif->ntxq_descs, ring->tx_pending);
@@ -569,9 +615,6 @@ static int ionic_set_ringparam(struct net_device *netdev,
 		return 0;
 	}
 
-	qparam.ntxq_descs = ring->tx_pending;
-	qparam.nrxq_descs = ring->rx_pending;
-
 	mutex_lock(&lif->queue_lock);
 	err = ionic_reconfigure_queues(lif, &qparam);
 	mutex_unlock(&lif->queue_lock);
@@ -638,7 +681,7 @@ static int ionic_set_channels(struct net_device *netdev,
 				    lif->nxqs, ch->combined_count);
 
 		qparam.nxqs = ch->combined_count;
-		qparam.intr_split = 0;
+		qparam.intr_split = false;
 	} else {
 		max_cnt /= 2;
 		if (ch->rx_count > max_cnt)
@@ -654,9 +697,13 @@ static int ionic_set_channels(struct net_device *netdev,
 				    lif->nxqs, ch->rx_count);
 
 		qparam.nxqs = ch->rx_count;
-		qparam.intr_split = 1;
+		qparam.intr_split = true;
 	}
 
+	err = ionic_validate_cmb_config(lif, &qparam);
+	if (err < 0)
+		return err;
+
 	/* if we're not running, just set the values and return */
 	if (!netif_running(lif->netdev)) {
 		lif->nxqs = qparam.nxqs;
@@ -699,6 +746,75 @@ static int ionic_get_rxnfc(struct net_device *netdev,
 	return err;
 }
 
+int ionic_cmb_pages_in_use(struct ionic_lif *lif)
+{
+	struct ionic_queue_params qparam;
+
+	ionic_init_queue_params(lif, &qparam);
+	return ionic_validate_cmb_config(lif, &qparam);
+}
+
+static int ionic_cmb_rings_toggle(struct ionic_lif *lif, bool cmb_enable)
+{
+	struct ionic_queue_params qparam;
+	int pages_used;
+
+	if (!(lif->qtype_info[IONIC_QTYPE_TXQ].features & IONIC_QIDENT_F_CMB) ||
+	    !(lif->qtype_info[IONIC_QTYPE_RXQ].features & IONIC_QIDENT_F_CMB) ||
+	    !lif->ionic->idev.cmb_inuse) {
+		netdev_info(lif->netdev, "CMB rings are not supported on this device\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (netif_running(lif->netdev))
+		return -EBUSY;
+
+	ionic_init_queue_params(lif, &qparam);
+	qparam.cmb_enabled = cmb_enable;
+	pages_used = ionic_validate_cmb_config(lif, &qparam);
+	if (pages_used < 0)
+		return pages_used;
+
+	if (cmb_enable) {
+		netdev_info(lif->netdev, "Enabling CMB rings - %d pages\n",
+			    pages_used);
+		set_bit(IONIC_LIF_F_CMB_RINGS, lif->state);
+	} else {
+		netdev_info(lif->netdev, "Disabling CMB rings\n");
+		clear_bit(IONIC_LIF_F_CMB_RINGS, lif->state);
+	}
+
+	return 0;
+}
+
+static u32 ionic_get_priv_flags(struct net_device *netdev)
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
+	u32 priv_flags = 0;
+
+	if (test_bit(IONIC_LIF_F_CMB_RINGS, lif->state))
+		priv_flags |= IONIC_PRIV_F_CMB_RINGS;
+
+	return priv_flags;
+}
+
+static int ionic_set_priv_flags(struct net_device *netdev, u32 priv_flags)
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
+	bool cmb_now, cmb_req;
+	int ret;
+
+	cmb_now = test_bit(IONIC_LIF_F_CMB_RINGS, lif->state);
+	cmb_req = !!(priv_flags & IONIC_PRIV_F_CMB_RINGS);
+	if (cmb_now != cmb_req) {
+		ret = ionic_cmb_rings_toggle(lif, cmb_req);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
 static u32 ionic_get_rxfh_indir_size(struct net_device *netdev)
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
@@ -980,6 +1096,8 @@ static const struct ethtool_ops ionic_ethtool_ops = {
 	.get_strings		= ionic_get_strings,
 	.get_ethtool_stats	= ionic_get_stats,
 	.get_sset_count		= ionic_get_sset_count,
+	.get_priv_flags		= ionic_get_priv_flags,
+	.set_priv_flags		= ionic_set_priv_flags,
 	.get_rxnfc		= ionic_get_rxnfc,
 	.get_rxfh_indir_size	= ionic_get_rxfh_indir_size,
 	.get_rxfh_key_size	= ionic_get_rxfh_key_size,
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.h b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.h
index 38b91b1d70ae..6bc9c177d14b 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.h
@@ -4,6 +4,7 @@
 #ifndef _IONIC_ETHTOOL_H_
 #define _IONIC_ETHTOOL_H_
 
+int ionic_cmb_pages_in_use(struct ionic_lif *lif);
 void ionic_ethtool_set_ops(struct net_device *netdev);
 
 #endif /* _IONIC_ETHTOOL_H_ */
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_if.h b/drivers/net/ethernet/pensando/ionic/ionic_if.h
index eac09b2375b8..9a1825edf0d0 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_if.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_if.h
@@ -3073,9 +3073,10 @@ union ionic_adminq_comp {
 
 #define IONIC_BARS_MAX			6
 #define IONIC_PCI_BAR_DBELL		1
+#define IONIC_PCI_BAR_CMB		2
 
-/* BAR0 */
 #define IONIC_BAR0_SIZE				0x8000
+#define IONIC_BAR2_SIZE				0x800000
 
 #define IONIC_BAR0_DEV_INFO_REGS_OFFSET		0x0000
 #define IONIC_BAR0_DEV_CMD_REGS_OFFSET		0x0800
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 8499165b1563..e8884de83474 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -25,9 +25,12 @@
 static const u8 ionic_qtype_versions[IONIC_QTYPE_MAX] = {
 	[IONIC_QTYPE_ADMINQ]  = 0,   /* 0 = Base version with CQ support */
 	[IONIC_QTYPE_NOTIFYQ] = 0,   /* 0 = Base version */
-	[IONIC_QTYPE_RXQ]     = 0,   /* 0 = Base version with CQ+SG support */
-	[IONIC_QTYPE_TXQ]     = 1,   /* 0 = Base version with CQ+SG support
-				      * 1 =   ... with Tx SG version 1
+	[IONIC_QTYPE_RXQ]     = 2,   /* 0 = Base version with CQ+SG support
+				      * 2 =       ... with CMB rings
+				      */
+	[IONIC_QTYPE_TXQ]     = 3,   /* 0 = Base version with CQ+SG support
+				      * 1 =       ... with Tx SG version 1
+				      * 3 =       ... with CMB rings
 				      */
 };
 
@@ -379,6 +382,15 @@ static void ionic_qcq_free(struct ionic_lif *lif, struct ionic_qcq *qcq)
 		qcq->q_base_pa = 0;
 	}
 
+	if (qcq->cmb_q_base) {
+		iounmap(qcq->cmb_q_base);
+		ionic_put_cmb(lif, qcq->cmb_pgid, qcq->cmb_order);
+		qcq->cmb_pgid = 0;
+		qcq->cmb_order = 0;
+		qcq->cmb_q_base = NULL;
+		qcq->cmb_q_base_pa = 0;
+	}
+
 	if (qcq->cq_base) {
 		dma_free_coherent(dev, qcq->cq_size, qcq->cq_base, qcq->cq_base_pa);
 		qcq->cq_base = NULL;
@@ -587,6 +599,7 @@ static int ionic_qcq_alloc(struct ionic_lif *lif, unsigned int type,
 		ionic_cq_map(&new->cq, cq_base, cq_base_pa);
 		ionic_cq_bind(&new->cq, &new->q);
 	} else {
+		/* regular DMA q descriptors */
 		new->q_size = PAGE_SIZE + (num_descs * desc_size);
 		new->q_base = dma_alloc_coherent(dev, new->q_size, &new->q_base_pa,
 						 GFP_KERNEL);
@@ -599,6 +612,33 @@ static int ionic_qcq_alloc(struct ionic_lif *lif, unsigned int type,
 		q_base_pa = ALIGN(new->q_base_pa, PAGE_SIZE);
 		ionic_q_map(&new->q, q_base, q_base_pa);
 
+		if (flags & IONIC_QCQ_F_CMB_RINGS) {
+			/* on-chip CMB q descriptors */
+			new->cmb_q_size = num_descs * desc_size;
+			new->cmb_order = order_base_2(new->cmb_q_size / PAGE_SIZE);
+
+			err = ionic_get_cmb(lif, &new->cmb_pgid, &new->cmb_q_base_pa,
+					    new->cmb_order);
+			if (err) {
+				netdev_err(lif->netdev,
+					   "Cannot allocate queue order %d from cmb: err %d\n",
+					   new->cmb_order, err);
+				goto err_out_free_q;
+			}
+
+			new->cmb_q_base = ioremap_wc(new->cmb_q_base_pa, new->cmb_q_size);
+			if (!new->cmb_q_base) {
+				netdev_err(lif->netdev, "Cannot map queue from cmb\n");
+				ionic_put_cmb(lif, new->cmb_pgid, new->cmb_order);
+				err = -ENOMEM;
+				goto err_out_free_q;
+			}
+
+			new->cmb_q_base_pa -= idev->phy_cmb_pages;
+			ionic_q_cmb_map(&new->q, new->cmb_q_base, new->cmb_q_base_pa);
+		}
+
+		/* cq DMA descriptors */
 		new->cq_size = PAGE_SIZE + (num_descs * cq_desc_size);
 		new->cq_base = dma_alloc_coherent(dev, new->cq_size, &new->cq_base_pa,
 						  GFP_KERNEL);
@@ -637,6 +677,10 @@ static int ionic_qcq_alloc(struct ionic_lif *lif, unsigned int type,
 err_out_free_cq:
 	dma_free_coherent(dev, new->cq_size, new->cq_base, new->cq_base_pa);
 err_out_free_q:
+	if (new->cmb_q_base) {
+		iounmap(new->cmb_q_base);
+		ionic_put_cmb(lif, new->cmb_pgid, new->cmb_order);
+	}
 	dma_free_coherent(dev, new->q_size, new->q_base, new->q_base_pa);
 err_out_free_cq_info:
 	vfree(new->cq.info);
@@ -718,6 +762,8 @@ static void ionic_qcq_sanitize(struct ionic_qcq *qcq)
 	qcq->cq.tail_idx = 0;
 	qcq->cq.done_color = 1;
 	memset(qcq->q_base, 0, qcq->q_size);
+	if (qcq->cmb_q_base)
+		memset_io(qcq->cmb_q_base, 0, qcq->cmb_q_size);
 	memset(qcq->cq_base, 0, qcq->cq_size);
 	memset(qcq->sg_base, 0, qcq->sg_size);
 }
@@ -737,6 +783,7 @@ static int ionic_lif_txq_init(struct ionic_lif *lif, struct ionic_qcq *qcq)
 			.index = cpu_to_le32(q->index),
 			.flags = cpu_to_le16(IONIC_QINIT_F_IRQ |
 					     IONIC_QINIT_F_SG),
+			.intr_index = cpu_to_le16(qcq->intr.index),
 			.pid = cpu_to_le16(q->pid),
 			.ring_size = ilog2(q->num_descs),
 			.ring_base = cpu_to_le64(q->base_pa),
@@ -745,17 +792,19 @@ static int ionic_lif_txq_init(struct ionic_lif *lif, struct ionic_qcq *qcq)
 			.features = cpu_to_le64(q->features),
 		},
 	};
-	unsigned int intr_index;
 	int err;
 
-	intr_index = qcq->intr.index;
-
-	ctx.cmd.q_init.intr_index = cpu_to_le16(intr_index);
+	if (qcq->flags & IONIC_QCQ_F_CMB_RINGS) {
+		ctx.cmd.q_init.flags |= cpu_to_le16(IONIC_QINIT_F_CMB);
+		ctx.cmd.q_init.ring_base = cpu_to_le64(qcq->cmb_q_base_pa);
+	}
 
 	dev_dbg(dev, "txq_init.pid %d\n", ctx.cmd.q_init.pid);
 	dev_dbg(dev, "txq_init.index %d\n", ctx.cmd.q_init.index);
 	dev_dbg(dev, "txq_init.ring_base 0x%llx\n", ctx.cmd.q_init.ring_base);
 	dev_dbg(dev, "txq_init.ring_size %d\n", ctx.cmd.q_init.ring_size);
+	dev_dbg(dev, "txq_init.cq_ring_base 0x%llx\n", ctx.cmd.q_init.cq_ring_base);
+	dev_dbg(dev, "txq_init.sg_ring_base 0x%llx\n", ctx.cmd.q_init.sg_ring_base);
 	dev_dbg(dev, "txq_init.flags 0x%x\n", ctx.cmd.q_init.flags);
 	dev_dbg(dev, "txq_init.ver %d\n", ctx.cmd.q_init.ver);
 	dev_dbg(dev, "txq_init.intr_index %d\n", ctx.cmd.q_init.intr_index);
@@ -807,6 +856,11 @@ static int ionic_lif_rxq_init(struct ionic_lif *lif, struct ionic_qcq *qcq)
 	};
 	int err;
 
+	if (qcq->flags & IONIC_QCQ_F_CMB_RINGS) {
+		ctx.cmd.q_init.flags |= cpu_to_le16(IONIC_QINIT_F_CMB);
+		ctx.cmd.q_init.ring_base = cpu_to_le64(qcq->cmb_q_base_pa);
+	}
+
 	dev_dbg(dev, "rxq_init.pid %d\n", ctx.cmd.q_init.pid);
 	dev_dbg(dev, "rxq_init.index %d\n", ctx.cmd.q_init.index);
 	dev_dbg(dev, "rxq_init.ring_base 0x%llx\n", ctx.cmd.q_init.ring_base);
@@ -1966,8 +2020,13 @@ static int ionic_txrx_alloc(struct ionic_lif *lif)
 		sg_desc_sz = sizeof(struct ionic_txq_sg_desc);
 
 	flags = IONIC_QCQ_F_TX_STATS | IONIC_QCQ_F_SG;
+
+	if (test_bit(IONIC_LIF_F_CMB_RINGS, lif->state))
+		flags |= IONIC_QCQ_F_CMB_RINGS;
+
 	if (test_bit(IONIC_LIF_F_SPLIT_INTR, lif->state))
 		flags |= IONIC_QCQ_F_INTR;
+
 	for (i = 0; i < lif->nxqs; i++) {
 		err = ionic_qcq_alloc(lif, IONIC_QTYPE_TXQ, i, "tx", flags,
 				      num_desc, desc_sz, comp_sz, sg_desc_sz,
@@ -1988,6 +2047,9 @@ static int ionic_txrx_alloc(struct ionic_lif *lif)
 
 	flags = IONIC_QCQ_F_RX_STATS | IONIC_QCQ_F_SG | IONIC_QCQ_F_INTR;
 
+	if (test_bit(IONIC_LIF_F_CMB_RINGS, lif->state))
+		flags |= IONIC_QCQ_F_CMB_RINGS;
+
 	num_desc = lif->nrxq_descs;
 	desc_sz = sizeof(struct ionic_rxq_desc);
 	comp_sz = sizeof(struct ionic_rxq_comp);
@@ -2663,6 +2725,55 @@ static const struct net_device_ops ionic_netdev_ops = {
 	.ndo_get_vf_stats       = ionic_get_vf_stats,
 };
 
+static int ionic_cmb_reconfig(struct ionic_lif *lif,
+			      struct ionic_queue_params *qparam)
+{
+	struct ionic_queue_params start_qparams;
+	int err = 0;
+
+	/* When changing CMB queue parameters, we're using limited
+	 * on-device memory and don't have extra memory to use for
+	 * duplicate allocations, so we free it all first then
+	 * re-allocate with the new parameters.
+	 */
+
+	/* Checkpoint for possible unwind */
+	ionic_init_queue_params(lif, &start_qparams);
+
+	/* Stop and free the queues */
+	ionic_stop_queues_reconfig(lif);
+	ionic_txrx_free(lif);
+
+	/* Set up new qparams */
+	ionic_set_queue_params(lif, qparam);
+
+	if (netif_running(lif->netdev)) {
+		/* Alloc and start the new configuration */
+		err = ionic_txrx_alloc(lif);
+		if (err) {
+			dev_warn(lif->ionic->dev,
+				 "CMB reconfig failed, restoring values: %d\n", err);
+
+			/* Back out the changes */
+			ionic_set_queue_params(lif, &start_qparams);
+			err = ionic_txrx_alloc(lif);
+			if (err) {
+				dev_err(lif->ionic->dev,
+					"CMB restore failed: %d\n", err);
+				goto errout;
+			}
+		}
+
+		ionic_start_queues_reconfig(lif);
+	} else {
+		/* This was detached in ionic_stop_queues_reconfig() */
+		netif_device_attach(lif->netdev);
+	}
+
+errout:
+	return err;
+}
+
 static void ionic_swap_queues(struct ionic_qcq *a, struct ionic_qcq *b)
 {
 	/* only swapping the queues, not the napi, flags, or other stuff */
@@ -2705,6 +2816,10 @@ int ionic_reconfigure_queues(struct ionic_lif *lif,
 	unsigned int flags, i;
 	int err = 0;
 
+	/* Are we changing q params while CMB is on */
+	if (test_bit(IONIC_LIF_F_CMB_RINGS, lif->state) && qparam->cmb_enabled)
+		return ionic_cmb_reconfig(lif, qparam);
+
 	/* allocate temporary qcq arrays to hold new queue structs */
 	if (qparam->nxqs != lif->nxqs || qparam->ntxq_descs != lif->ntxq_descs) {
 		tx_qcqs = devm_kcalloc(lif->ionic->dev, lif->ionic->ntxqs_per_lif,
@@ -2741,6 +2856,16 @@ int ionic_reconfigure_queues(struct ionic_lif *lif,
 			sg_desc_sz = sizeof(struct ionic_txq_sg_desc);
 
 		for (i = 0; i < qparam->nxqs; i++) {
+			/* If missing, short placeholder qcq needed for swap */
+			if (!lif->txqcqs[i]) {
+				flags = IONIC_QCQ_F_TX_STATS | IONIC_QCQ_F_SG;
+				err = ionic_qcq_alloc(lif, IONIC_QTYPE_TXQ, i, "tx", flags,
+						      4, desc_sz, comp_sz, sg_desc_sz,
+						      lif->kern_pid, &lif->txqcqs[i]);
+				if (err)
+					goto err_out;
+			}
+
 			flags = lif->txqcqs[i]->flags & ~IONIC_QCQ_F_INTR;
 			err = ionic_qcq_alloc(lif, IONIC_QTYPE_TXQ, i, "tx", flags,
 					      num_desc, desc_sz, comp_sz, sg_desc_sz,
@@ -2760,6 +2885,16 @@ int ionic_reconfigure_queues(struct ionic_lif *lif,
 			comp_sz *= 2;
 
 		for (i = 0; i < qparam->nxqs; i++) {
+			/* If missing, short placeholder qcq needed for swap */
+			if (!lif->rxqcqs[i]) {
+				flags = IONIC_QCQ_F_RX_STATS | IONIC_QCQ_F_SG;
+				err = ionic_qcq_alloc(lif, IONIC_QTYPE_RXQ, i, "rx", flags,
+						      4, desc_sz, comp_sz, sg_desc_sz,
+						      lif->kern_pid, &lif->rxqcqs[i]);
+				if (err)
+					goto err_out;
+			}
+
 			flags = lif->rxqcqs[i]->flags & ~IONIC_QCQ_F_INTR;
 			err = ionic_qcq_alloc(lif, IONIC_QTYPE_RXQ, i, "rx", flags,
 					      num_desc, desc_sz, comp_sz, sg_desc_sz,
@@ -2809,10 +2944,15 @@ int ionic_reconfigure_queues(struct ionic_lif *lif,
 			lif->tx_coalesce_hw = lif->rx_coalesce_hw;
 		}
 
-		/* clear existing interrupt assignments */
+		/* Clear existing interrupt assignments.  We check for NULL here
+		 * because we're checking the whole array for potential qcqs, not
+		 * just those qcqs that have just been set up.
+		 */
 		for (i = 0; i < lif->ionic->ntxqs_per_lif; i++) {
-			ionic_qcq_intr_free(lif, lif->txqcqs[i]);
-			ionic_qcq_intr_free(lif, lif->rxqcqs[i]);
+			if (lif->txqcqs[i])
+				ionic_qcq_intr_free(lif, lif->txqcqs[i]);
+			if (lif->rxqcqs[i])
+				ionic_qcq_intr_free(lif, lif->rxqcqs[i]);
 		}
 
 		/* re-assign the interrupts */
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index a53984bf3544..5425a8983ae0 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -59,6 +59,7 @@ struct ionic_rx_stats {
 #define IONIC_QCQ_F_TX_STATS		BIT(3)
 #define IONIC_QCQ_F_RX_STATS		BIT(4)
 #define IONIC_QCQ_F_NOTIFYQ		BIT(5)
+#define IONIC_QCQ_F_CMB_RINGS		BIT(6)
 
 struct ionic_qcq {
 	void *q_base;
@@ -70,6 +71,11 @@ struct ionic_qcq {
 	void *sg_base;
 	dma_addr_t sg_base_pa;
 	u32 sg_size;
+	void __iomem *cmb_q_base;
+	phys_addr_t cmb_q_base_pa;
+	u32 cmb_q_size;
+	u32 cmb_pgid;
+	u32 cmb_order;
 	struct dim dim;
 	struct ionic_queue q;
 	struct ionic_cq cq;
@@ -140,6 +146,7 @@ enum ionic_lif_state_flags {
 	IONIC_LIF_F_BROKEN,
 	IONIC_LIF_F_TX_DIM_INTR,
 	IONIC_LIF_F_RX_DIM_INTR,
+	IONIC_LIF_F_CMB_RINGS,
 
 	/* leave this as last */
 	IONIC_LIF_F_STATE_SIZE
@@ -243,8 +250,9 @@ struct ionic_queue_params {
 	unsigned int nxqs;
 	unsigned int ntxq_descs;
 	unsigned int nrxq_descs;
-	unsigned int intr_split;
 	u64 rxq_features;
+	bool intr_split;
+	bool cmb_enabled;
 };
 
 static inline void ionic_init_queue_params(struct ionic_lif *lif,
@@ -253,8 +261,28 @@ static inline void ionic_init_queue_params(struct ionic_lif *lif,
 	qparam->nxqs = lif->nxqs;
 	qparam->ntxq_descs = lif->ntxq_descs;
 	qparam->nrxq_descs = lif->nrxq_descs;
-	qparam->intr_split = test_bit(IONIC_LIF_F_SPLIT_INTR, lif->state);
 	qparam->rxq_features = lif->rxq_features;
+	qparam->intr_split = test_bit(IONIC_LIF_F_SPLIT_INTR, lif->state);
+	qparam->cmb_enabled = test_bit(IONIC_LIF_F_CMB_RINGS, lif->state);
+}
+
+static inline void ionic_set_queue_params(struct ionic_lif *lif,
+					  struct ionic_queue_params *qparam)
+{
+	lif->nxqs = qparam->nxqs;
+	lif->ntxq_descs = qparam->ntxq_descs;
+	lif->nrxq_descs = qparam->nrxq_descs;
+	lif->rxq_features = qparam->rxq_features;
+
+	if (qparam->intr_split)
+		set_bit(IONIC_LIF_F_SPLIT_INTR, lif->state);
+	else
+		clear_bit(IONIC_LIF_F_SPLIT_INTR, lif->state);
+
+	if (qparam->cmb_enabled)
+		set_bit(IONIC_LIF_F_CMB_RINGS, lif->state);
+	else
+		clear_bit(IONIC_LIF_F_CMB_RINGS, lif->state);
 }
 
 static inline u32 ionic_coal_usec_to_hw(struct ionic *ionic, u32 usecs)
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index 0c3977416cd1..413ff735225b 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -341,6 +341,14 @@ bool ionic_rx_service(struct ionic_cq *cq, struct ionic_cq_info *cq_info)
 	return true;
 }
 
+static inline void ionic_write_cmb_desc(struct ionic_queue *q,
+					void __iomem *cmb_desc,
+					void *desc)
+{
+	if (q_to_qcq(q)->flags & IONIC_QCQ_F_CMB_RINGS)
+		memcpy_toio(cmb_desc, desc, q->desc_size);
+}
+
 void ionic_rx_fill(struct ionic_queue *q)
 {
 	struct net_device *netdev = q->lif->netdev;
@@ -419,6 +427,8 @@ void ionic_rx_fill(struct ionic_queue *q)
 					      IONIC_RXQ_DESC_OPCODE_SIMPLE;
 		desc_info->nbufs = nfrags;
 
+		ionic_write_cmb_desc(q, desc_info->cmb_desc, desc);
+
 		ionic_rxq_post(q, false, ionic_rx_clean, NULL);
 	}
 
@@ -860,7 +870,8 @@ static int ionic_tx_tcp_pseudo_csum(struct sk_buff *skb)
 	return 0;
 }
 
-static void ionic_tx_tso_post(struct ionic_queue *q, struct ionic_txq_desc *desc,
+static void ionic_tx_tso_post(struct ionic_queue *q,
+			      struct ionic_desc_info *desc_info,
 			      struct sk_buff *skb,
 			      dma_addr_t addr, u8 nsge, u16 len,
 			      unsigned int hdrlen, unsigned int mss,
@@ -868,6 +879,7 @@ static void ionic_tx_tso_post(struct ionic_queue *q, struct ionic_txq_desc *desc
 			      u16 vlan_tci, bool has_vlan,
 			      bool start, bool done)
 {
+	struct ionic_txq_desc *desc = desc_info->desc;
 	u8 flags = 0;
 	u64 cmd;
 
@@ -883,6 +895,8 @@ static void ionic_tx_tso_post(struct ionic_queue *q, struct ionic_txq_desc *desc
 	desc->hdr_len = cpu_to_le16(hdrlen);
 	desc->mss = cpu_to_le16(mss);
 
+	ionic_write_cmb_desc(q, desc_info->cmb_desc, desc);
+
 	if (start) {
 		skb_tx_timestamp(skb);
 		if (!unlikely(q->features & IONIC_TXQ_F_HWSTAMP))
@@ -1001,7 +1015,7 @@ static int ionic_tx_tso(struct ionic_queue *q, struct sk_buff *skb)
 		seg_rem = min(tso_rem, mss);
 		done = (tso_rem == 0);
 		/* post descriptor */
-		ionic_tx_tso_post(q, desc, skb,
+		ionic_tx_tso_post(q, desc_info, skb,
 				  desc_addr, desc_nsge, desc_len,
 				  hdrlen, mss, outer_csum, vlan_tci, has_vlan,
 				  start, done);
@@ -1050,6 +1064,8 @@ static void ionic_tx_calc_csum(struct ionic_queue *q, struct sk_buff *skb,
 	desc->csum_start = cpu_to_le16(skb_checksum_start_offset(skb));
 	desc->csum_offset = cpu_to_le16(skb->csum_offset);
 
+	ionic_write_cmb_desc(q, desc_info->cmb_desc, desc);
+
 	if (skb_csum_is_sctp(skb))
 		stats->crc32_csum++;
 	else
@@ -1087,6 +1103,8 @@ static void ionic_tx_calc_no_csum(struct ionic_queue *q, struct sk_buff *skb,
 	desc->csum_start = 0;
 	desc->csum_offset = 0;
 
+	ionic_write_cmb_desc(q, desc_info->cmb_desc, desc);
+
 	stats->csum_none++;
 }
 
-- 
2.17.1

