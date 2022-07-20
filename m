Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 547EE57BDCA
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 20:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240941AbiGTSbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 14:31:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiGTSbJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 14:31:09 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2051.outbound.protection.outlook.com [40.107.237.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97BCE11163
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 11:31:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YsFCfr9Mz8ZKAeoHRw1QA6QLMdRxP9x+GBDet+NJN4hPC1oshfQJSNbEzS3T65zXoHqeAk3X2jib9+gVyMZ3OSOE9n9nVVuEmNHSZY3hBXGJ4id01A0Zx2QbsAhEbqUo7lljyNrinEXictwlHSX/G6xua+l3zg7ounEpOyY1ykv3GmD01n5qk3DXxnBXczwoC31jsc5HwFYeBnlCFEsor+lpLsXUvrqBz4lLTOr2JifKNrjC4gzrD0dZ49WKyhQijVfbC8rPUJN1Fss4I0Q+FAyf6WycvWx29pyGA8jenNihzlnf/5V823uJ/u5XNlGRoHlSr/wPGVKiho6v3hGmpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x7Jnv2jzJLYjwqPpssW/ecB3FPAxueiMV+fZ5eTaNx4=;
 b=ETADEUV6DPVIFHnEyUOjOACvkefBje8ayqxfUk/IPY9rviHCTOuAvvR1Ot1A9b1TKL5yYSTJDT07fTkuU6pFkA65QniOSRuSEs5iJFWPOYLNdtuHnE5ZK1mIF38ytZOnzdB4Z6mycVQPnLLN7WENSGhSTtEg1/8rXxCXaiREHQ7ij6o+qa/ymkA48zAa8gFSv7YqFxSzddeJX+V15eTuyzObsLLp5hukc8tvSUVJHStcFPJGzuPf7cTEErUfxdx3sEhLyPYpYhdh178ZyBBpwxpLeObGBCswdfbiM4TlI3n80COo9hUqLSTZvyXQSeCEPvxaeabpUXeTXSxvE0t3cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x7Jnv2jzJLYjwqPpssW/ecB3FPAxueiMV+fZ5eTaNx4=;
 b=h48wRlS3ag8RortOZ+n+4JxaolOvnCR48QX092ZumrVRvQUC5pYbOfUQCg9OK0CEwBrR7gE1mrH71jroWdGK/l600MCQsudEThUHOVKL4umBPmoabCV4OcLZc1lYk+6hINhWFAmPI9/j38+JGnthaYQxZiK5LkZpC5OJJabn7rTTmsRSaWxFSWvXSaE3nwbCVV38RLsMHufeCKliJKKsPpgodMd8T4guim+qVM407kvD7ZMl1ITto5fNyVuhWP6Xns95xeOgpF3+nXEHwKMNOGpO3AKTGCFGmL5fmDKfZbb/h0qVU5bWola1w+efja+u2WcO7rsg/n0+A2fZEi0vZQ==
Received: from MW2PR16CA0067.namprd16.prod.outlook.com (2603:10b6:907:1::44)
 by CH2PR12MB3686.namprd12.prod.outlook.com (2603:10b6:610:23::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.19; Wed, 20 Jul
 2022 18:31:06 +0000
Received: from CO1NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:1:cafe::78) by MW2PR16CA0067.outlook.office365.com
 (2603:10b6:907:1::44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18 via Frontend
 Transport; Wed, 20 Jul 2022 18:31:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT011.mail.protection.outlook.com (10.13.175.186) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5458.17 via Frontend Transport; Wed, 20 Jul 2022 18:31:05 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 20 Jul
 2022 13:31:04 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 20 Jul
 2022 11:31:04 -0700
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Wed, 20 Jul 2022 13:31:03 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH v2 net-next 06/10] sfc: phys port/switch identification for ef100 reps
Date:   Wed, 20 Jul 2022 19:29:35 +0100
Message-ID: <23e86ec27679b5290125bcc956e5045a3108e1bb.1658158016.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1658158016.git.ecree.xilinx@gmail.com>
References: <cover.1658158016.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cce521eb-4ce9-4458-f92b-08da6a7e01f5
X-MS-TrafficTypeDiagnostic: CH2PR12MB3686:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: odWorSHbUxQFZSBc0oPq5iVjyceXBMC2VS6bLK+7QqOYuEJJKEgFjC1PtRLU79Xgbty4PPL1ngBsHTRHLdV3VkcOxiyzpc+do4JYAL7UXRfWEm4cz6vIlRxSTeRrz/Se5zPnVOiJPROT/C7ZINHY+q8DIHIiKzatNQ4yi9XYiq4WIVPKc15HBxxI55sX29TRVcyn8toTkIoluZ9/sGWf4VyRDS3idTEcDr1SXKACwDiZAqGsvGPQ3dB9xQQSa5XzNIH/FCgVmHThhvtX9pGOwN3WWHbXVW0HXHXQFRuHy6e9+PrUQ6zgiBWCL+azJ/DjG1Qr6HRxo+ap4tEyWu8ioekAMsH5yxMeI95Z6azDfwJ8rqV3nIlq0ck4izDaacxpVdNXB3AKhMTBacwEXjCbcnj+aodH3bAE8ds/tNrlYqAReivH41MwjymchqgAeS2LtpsMs87RJO4cSMWCzxu/wbr5rbW2aynrxfAk6480zGE8cJ2Y9J0f8horS23BA9LqxrJagIRZylviq3rDMSeFZQzBIfu5MUwxwLlhduFurX81DGDYKtYPTDcg/7nClba++iVky5pF6usq2s2yPznlkCriYNsscIBd7R06egzqKq/skow+w/wv7IqEZGsSBGoW1o0UnsB64uve80m2qBjAxH0sYzyBlof4B0t7VBhuekRfqLR/esp/6uHTSG9v8Z78Azr3yjdzKkaZwuH5ToC0+o4ZL5F3+f2uhOOB/GYNiPl/FWizoKZS+fFKvP1tRKEloZIPAjel5+bj1qyIy7tfDBQJ0RkZYRwEIfUZj4hYF+Rm9YHq0nbIoBULPoxpwMCgQOpnI+SQTajmjLHGbFcLFg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(346002)(136003)(39860400002)(36840700001)(46966006)(40470700004)(478600001)(82310400005)(2876002)(8676002)(26005)(40480700001)(41300700001)(55446002)(316002)(70586007)(36756003)(54906003)(4326008)(40460700003)(110136005)(6666004)(70206006)(42882007)(2906002)(356005)(9686003)(83380400001)(47076005)(186003)(82740400003)(81166007)(8936002)(36860700001)(5660300002)(336012)(83170400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2022 18:31:05.5792
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cce521eb-4ce9-4458-f92b-08da6a7e01f5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3686
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

Requires storing VF index in struct efx_rep.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/ef100_rep.c | 39 ++++++++++++++++++++++++++--
 drivers/net/ethernet/sfc/ef100_rep.h |  2 ++
 2 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100_rep.c b/drivers/net/ethernet/sfc/ef100_rep.c
index 1121bf162b2f..0b4f7d536ae6 100644
--- a/drivers/net/ethernet/sfc/ef100_rep.c
+++ b/drivers/net/ethernet/sfc/ef100_rep.c
@@ -14,9 +14,11 @@
 
 #define EFX_EF100_REP_DRIVER	"efx_ef100_rep"
 
-static int efx_ef100_rep_init_struct(struct efx_nic *efx, struct efx_rep *efv)
+static int efx_ef100_rep_init_struct(struct efx_nic *efx, struct efx_rep *efv,
+				     unsigned int i)
 {
 	efv->parent = efx;
+	efv->idx = i;
 	INIT_LIST_HEAD(&efv->list);
 	efv->msg_enable = NETIF_MSG_DRV | NETIF_MSG_PROBE |
 			  NETIF_MSG_LINK | NETIF_MSG_IFDOWN |
@@ -25,7 +27,40 @@ static int efx_ef100_rep_init_struct(struct efx_nic *efx, struct efx_rep *efv)
 	return 0;
 }
 
+static int efx_ef100_rep_get_port_parent_id(struct net_device *dev,
+					    struct netdev_phys_item_id *ppid)
+{
+	struct efx_rep *efv = netdev_priv(dev);
+	struct efx_nic *efx = efv->parent;
+	struct ef100_nic_data *nic_data;
+
+	nic_data = efx->nic_data;
+	/* nic_data->port_id is a u8[] */
+	ppid->id_len = sizeof(nic_data->port_id);
+	memcpy(ppid->id, nic_data->port_id, sizeof(nic_data->port_id));
+	return 0;
+}
+
+static int efx_ef100_rep_get_phys_port_name(struct net_device *dev,
+					    char *buf, size_t len)
+{
+	struct efx_rep *efv = netdev_priv(dev);
+	struct efx_nic *efx = efv->parent;
+	struct ef100_nic_data *nic_data;
+	int ret;
+
+	nic_data = efx->nic_data;
+	ret = snprintf(buf, len, "p%upf%uvf%u", efx->port_num,
+		       nic_data->pf_index, efv->idx);
+	if (ret >= len)
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+
 static const struct net_device_ops efx_ef100_rep_netdev_ops = {
+	.ndo_get_port_parent_id	= efx_ef100_rep_get_port_parent_id,
+	.ndo_get_phys_port_name	= efx_ef100_rep_get_phys_port_name,
 };
 
 static void efx_ef100_rep_get_drvinfo(struct net_device *dev,
@@ -67,7 +102,7 @@ static struct efx_rep *efx_ef100_rep_create_netdev(struct efx_nic *efx,
 		return ERR_PTR(-ENOMEM);
 
 	efv = netdev_priv(net_dev);
-	rc = efx_ef100_rep_init_struct(efx, efv);
+	rc = efx_ef100_rep_init_struct(efx, efv, i);
 	if (rc)
 		goto fail1;
 	efv->net_dev = net_dev;
diff --git a/drivers/net/ethernet/sfc/ef100_rep.h b/drivers/net/ethernet/sfc/ef100_rep.h
index 7d85811f0adb..235565869619 100644
--- a/drivers/net/ethernet/sfc/ef100_rep.h
+++ b/drivers/net/ethernet/sfc/ef100_rep.h
@@ -21,12 +21,14 @@
  * @parent: the efx PF which manages this representor
  * @net_dev: representor netdevice
  * @msg_enable: log message enable flags
+ * @idx: VF index
  * @list: entry on efx->vf_reps
  */
 struct efx_rep {
 	struct efx_nic *parent;
 	struct net_device *net_dev;
 	u32 msg_enable;
+	unsigned int idx;
 	struct list_head list;
 };
 
