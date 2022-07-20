Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 667B357BDC7
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 20:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240923AbiGTSbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 14:31:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240915AbiGTSbG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 14:31:06 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2080.outbound.protection.outlook.com [40.107.244.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0010C70E79
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 11:31:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OvrLIm7xBjv35ngRMldTNt/SmuByIY5b4q1+XPx3wthYjA8XAxc4Pvne+l9n0GfY+u5DiHjZr3X0iqQ5eu/yTkcbTZ9OXnCeNAikCQNGjed+DXHT8fhsbCigeIMOaIfkSL95MDpg/f+XhfS1z53pX6IZHpHcUBr/QYK71EIk1bTeDEDvq29JLjaL3UL486/gCjWNcP2cwTUoUH4v2WgdqYlQGyvArRYbv2JOC2gX3f0ni7FEu1o3XWp99N6rZhUj45zhgn1YkHMzFciDyOcFm9GBNuHUxwzIQVhwKasyqmsjyU6SqgElL4nLm6HtXsXElchQGN9oHzkXh6iPwfm6Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x7Jnv2jzJLYjwqPpssW/ecB3FPAxueiMV+fZ5eTaNx4=;
 b=BPCYW0vwh4mr6slSgo07j0nEu4Qpbk2BzTMXl5Hmm+JE3/ZwJ3gyCeS0IB/4/3zjz1KrcDM9SMWmB3B2WUnSYBD3AMgV/DGuxY2qC6cM8o32H0P5yBLCjF8Zw2s8XVFcD+VrTCDSezWj9N9M4I9s2SDGrjbRx7t7ye4ASnJe1ji/vHFlHkQ4JkAj4BBMyXPEPqX2T2R2mu34Ma/HrIvui3SmFjZpMjWO3QnS+ICR0avnCJ+SyJ9wd6GeEpttU7UzcrY3tAaLjuSBd8ab64HP/91UlZZSsfk+4MF2D0bEBsbngUl8fVkjLnQjYvC2AQRaxaoK5DJtJHrV5QKduBqBug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x7Jnv2jzJLYjwqPpssW/ecB3FPAxueiMV+fZ5eTaNx4=;
 b=L9Yl0fQ43c/HGjhyil8/l80l7KXaC2l9rYROyro5ULDnmqp+w+PBd9+E+8muue3YG1r2j/u9STi7xi3oXHjONMIkXZMEd0krB5NyXwUbnABf3VSFXjj0rUkLZUZAhFG4rfN/3futD9LRy3CZ+FadxfuQRkQIO5RB0/3GBVTRg6aQ0jgEjy0WLLcEGaRuoLcIzsPmbOE695DTNScEQHtit9OvNC4/C1wXPztWT/CasawiTJmmOvk5Zbk5YtoVLa/56aFV+wJgHHHWPXdR7k9Kj6/lERKhm1v6yc7OdGaHraaaOJWsC4+hXBmaGoGDl/TsZFh4z09z0kvZd2JcZJ6RZw==
Received: from MW4PR03CA0028.namprd03.prod.outlook.com (2603:10b6:303:8f::33)
 by DM4PR12MB5294.namprd12.prod.outlook.com (2603:10b6:5:39e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Wed, 20 Jul
 2022 18:31:04 +0000
Received: from CO1NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8f:cafe::18) by MW4PR03CA0028.outlook.office365.com
 (2603:10b6:303:8f::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.23 via Frontend
 Transport; Wed, 20 Jul 2022 18:31:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT036.mail.protection.outlook.com (10.13.174.124) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5458.17 via Frontend Transport; Wed, 20 Jul 2022 18:31:04 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 20 Jul
 2022 13:31:02 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 20 Jul
 2022 11:31:01 -0700
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Wed, 20 Jul 2022 13:31:00 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH v3 net-next 5/9] sfc: phys port/switch identification for ef100 reps
Date:   Wed, 20 Jul 2022 19:29:33 +0100
Message-ID: <c60f9a3c6f50900578d9da4c5786ac4a6ccdba30.1658341691.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1658341691.git.ecree.xilinx@gmail.com>
References: <cover.1658341691.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cfae20f0-cc18-457d-cdcb-08da6a7e0124
X-MS-TrafficTypeDiagnostic: DM4PR12MB5294:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1/FA0hkAohCPiC8wtKPEfkj70VW23FYptBOeTO0aepdSLimrXjtPtHWBV0HyokTdo3tEpyzS0C0dTMSxQ3JvKOA3G7i5lLXZpkpHdQnwvB3OocHtF/tDI1LZmF0EOh9+Jn65DR0fuump56hpuNvimHsgvkOr/Op3xHBHbuHmLFUWlhNMsibYEnzIog72J7VkwU9njqghof1dizVotBziYpYej+fcqRRoLnCGjgvGbFq6kAxrtdR7ZCYHiwEbL/3D7suW6s7t1hi26mC3KOYEqQUeUoRieywWsZmOmZMPjfb0VwYPoFFPZIU24iLnZcxSM+p1jOF9WGSYS4PpJCuYYAOYO6sYohdvDi1y1rkjxkItrT8xTp189lPSjoRh2S9Z//4jbgv6xJyauuYtuvtzbE/FY1bnTb/ek/n0PcIW3h5I4ruoL+cqpynuaRfsg0s9IKQxiPvz/AzLTA5Q2dfjAPFi8gqSDUGJryb3ZXTJN6zW/3h4gO9nKwsjGRtnCZV53yQrLqWyCs0OdrzcSquoDYQifvx+dGBe1vvZKGkhLV4EuEHnn1TM3WA+K/VvhmWj49nWSAFPLQ098DNqVvu3RZRyqzVsqO8MQItuZChvIbTCS8tKb7LaVHVD04WwU0bx5GYCgZGksMnPeVYfSynMneTwJlLGlfeC5WCHAV15ns8YTRUZSPD30yN88Tg31YSd9p4/Hb3NTj+1uUk+zv0tv/MRvVDvIBHybpLtfF0t22HqTeGLS7kRJiiked15H2XcpwHC4oWvHo83q57gsj0852mBcDYXZfGfiaxVceqCcgFyQrMHXSwg93bi+zLe4lUUs5nxGhWdCJ5kQO9I38K5ww==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(396003)(346002)(136003)(40470700004)(36840700001)(46966006)(40460700003)(81166007)(4326008)(316002)(70206006)(8676002)(8936002)(70586007)(478600001)(40480700001)(55446002)(82310400005)(5660300002)(83380400001)(47076005)(336012)(42882007)(2876002)(36756003)(36860700001)(6666004)(9686003)(26005)(82740400003)(356005)(83170400001)(186003)(54906003)(2906002)(110136005)(41300700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2022 18:31:04.2084
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cfae20f0-cc18-457d-cdcb-08da6a7e0124
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5294
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
 
