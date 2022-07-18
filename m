Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F84C578670
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 17:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235387AbiGRPc6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 11:32:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234524AbiGRPcz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 11:32:55 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2046.outbound.protection.outlook.com [40.107.220.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA918BA9
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 08:32:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nObiv7pwnXJzns77Ycj1ZobQ9mDFUr7qB1515fovIhFXZwQnTFiDQE44KmHfQXGNHN3inpVZAzHQl8hlIRbUCXrc57ZuBgJCFPXjo4Zy1em/29Zl1IYWneYs1xSSet6uSWOhy/VkCIQksmn2fSok3Obua8HV/oDuXFrr/HADoMLe0ILIxdkW+VhS1uTKa29PTgNJfilt6ECekHolNWq3OXfew8oLV2EBLxs4cfliDvwOpVprHpBmSbCPu6VJTnrBFslDCMGkPaZhkek3AcmPEfdlUoiJb7OjT6zZ25inNtIY1ajgXyM5TTfP1Rp0BkGIk+rAYCUaYgBKrh5E5ValKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x7Jnv2jzJLYjwqPpssW/ecB3FPAxueiMV+fZ5eTaNx4=;
 b=eVpAvms23Nxv9KzGWcvTMZbdNSsxlGyY2/bBxQIli0N4i620/8hGVphk8drSf/BwwvKRwG4KAu4Lm9CtBLMAeFmkR6VQ8pIR9p9bhRhYYszPoaaJBV5OPrvtOgMFd5rWYALwyqWu5uZeSNs5w6fECNtefuRuryEL8FISWR2wNNYt+qKpij5G/D4xnEVZOqei83g+E9rqvU0Ac2N2zewWuWg16drQcNJ0IzF/2LCZHwk1xniF+2UzsRAAb4SVV+Vw8Eq2v/OhtqgnVbItU1dt+0mMXxToUzpBvubi659YbyQtgt8dsAciYZ9axDoRF0FOHVJyFnmm3O8+XNU5kDrZPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x7Jnv2jzJLYjwqPpssW/ecB3FPAxueiMV+fZ5eTaNx4=;
 b=1t1NCcmL8fnop1tZAYHNxRtx5WKp4kwBTzDR4dREuTVS4tmIfn43Phk1vD2V/SNZ4vEWySsfZ7fOlHsg8AjlLaG9QEFNNl16c/roE3wCJbixDwSVi1cvV90YsLDLKD2428FNa4EpXNdhxTGE5bnhje+uX2wrZPlIs037FEC9Md0Z4L1YIijD1TCpoS0VhXXEftKh1W8EXAbfz5iIkPHlvVg7MPZTTuVQurqI5VckJQAhwxSN0PbJZgSIzdzQIVCLEOGAlBEMN0jKQh70cm99nQTX7wMlRUj8UO996TBe1iyJRKweBQbG5PqNQPg2AacDxh7xfEbUJIAo+VoLywwrLA==
Received: from BN9PR03CA0229.namprd03.prod.outlook.com (2603:10b6:408:f8::24)
 by MWHPR1201MB0192.namprd12.prod.outlook.com (2603:10b6:301:5a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Mon, 18 Jul
 2022 15:32:53 +0000
Received: from BN8NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f8:cafe::fc) by BN9PR03CA0229.outlook.office365.com
 (2603:10b6:408:f8::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20 via Frontend
 Transport; Mon, 18 Jul 2022 15:32:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT065.mail.protection.outlook.com (10.13.177.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5438.12 via Frontend Transport; Mon, 18 Jul 2022 15:32:52 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 18 Jul
 2022 10:32:50 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 18 Jul
 2022 10:32:49 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Mon, 18 Jul 2022 10:32:48 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH v2 net-next 06/10] sfc: phys port/switch identification for ef100 reps
Date:   Mon, 18 Jul 2022 16:30:12 +0100
Message-ID: <23e86ec27679b5290125bcc956e5045a3108e1bb.1658158016.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1658158016.git.ecree.xilinx@gmail.com>
References: <cover.1658158016.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f0dc85b2-e2dd-43db-fead-08da68d2c765
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0192:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BROiMUapnZ2hiZySIyduVZiUyjXsLXE+hiVEoyion1pRmHbGE6zANR9ERzL4Tlv0LuKlXKyBvydakVQSncPPjTM1Wo6VzJ+zG92dYZ8rNCAZrsblY2f9u0J5IeH7RpZffDySEBAQiWMtCwt86fKGXMpsuHYzMuHd6c3Rx+Hi+Jp2oGduuh+wyClQAEPJLaQDdD5yXQtSYAXv8LfHyeMjAV6KQlQJpByICVZv7o1Ofnnskm/F906Ky8cFKmZJrcV/b1ufTMzl2+t9gTgucc8XE6JZBRWYxO9AjFqtzVPJdiCWDdTsPiHc1gw4WpeZ5QTAAyaX0rpc2jDGHh/pWHPQBZNk1O8/+MH/yj5VVhMwUNsjS/Ueuyk9bWikzBEELyud2odlC+AqMbQLRcSZgiJQzSY2fG/QkVVs9tAGY7/sjyjR/VL5jmRLrOP6sUsgkvjkzFE+OB8F09k+m6Vo8gLeBm4crIABwQ7WqzcoJLAHDo/Vy0zyyjTjDgmPbCxJwxChCnE7zJRghRMlGeJAg7r8Xhg95MvOdT/DEYb8H8iP1LgngGmz51ZIovaJfPU9BFSnRReRM6vgvbLUlX2oZaAN0bNbNE6GkqUblmeWfkz2kgKT53Jbfxz6T8SS5tUz7TIp6KmvJMI9beZ8TqmT6g40+H3QBytiitk+PZbFcXa2FTOUxwUS26+bmdjh5uOyW3mFFxWLT91K6up0BqolEkNWALzBVGiGoL+aBH16W9NybmbvfYqK8/BjdlFoHyo5OSzNmF6DCzckSLLVdyiZ9p9rH7SYFB7BtYBTzA5pnKoXf73JHbUzqt+B/yN6+XUBWi412m1bi3JBe20oZTHkgw+Za1iH3Zi5y85FoK3vOpzFp4U=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(396003)(136003)(376002)(46966006)(40470700004)(36840700001)(36756003)(356005)(83170400001)(36860700001)(82740400003)(70206006)(81166007)(186003)(42882007)(70586007)(83380400001)(40460700003)(47076005)(336012)(55446002)(2876002)(2906002)(110136005)(54906003)(26005)(9686003)(41300700001)(478600001)(6666004)(8936002)(316002)(8676002)(4326008)(5660300002)(40480700001)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 15:32:52.3336
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f0dc85b2-e2dd-43db-fead-08da68d2c765
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0192
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
 
