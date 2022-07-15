Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C53105761CB
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 14:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233074AbiGOMgc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 08:36:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232529AbiGOMgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 08:36:21 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2065.outbound.protection.outlook.com [40.107.93.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB50152E7C
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 05:36:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ghw81X+FxPKtlBMLavyyr7GNdtiu0AgxyM1Jrj+Lt6w5FLjtcvfSOZSwNH1tDB0n0uMcuvrzvYVat/YAVaXWfndKFiQDl+p9WTVkY0w0J9wvse008J8Ed6jm2mtCSFRUmLE5lA9w3yxz0L9O1lN/P6T/a8kZu/ZfaFEg9m3uDVqlEO4oE/64ZV8jiuGv9frmRL/ts9MZFLz15uQD2+7akVjRbohH575cS8chNO1XXfAZtu82tqsxV2MP31YVhKI7X4GAlJ02X4hf9aDQlgHnMxbGbHqXoCQIzPHolH/GnPNcX2QbAcQY6hAbqf2W2NOKm8D00HSaHi+3yksdMNe/Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VwLXWwL7cIynFfQ8oo4gbJ/cygxEpj8WnLoZC9Tm5O8=;
 b=GhD8Q2CT1vUYiZVw76iqQwzIRKGFzNIPKlmdD2c82wh6yDj1YdsqU3Fys6eou4DrXE2ZRRVd7Rbgc9bWmq1h3mXYSnUbrz7j/V72Ab6QObu7HA71jbd0HN8xlTfQX/NAMngDKuvvh+0UFWW4DMOtdhJ1KF+rGfKdahjP9/NaB1ubviddei/Okj8tOx0mVZsaweU8JWL80lpGt2MtLAcn2d3GhDI0wg4F2NkwxVmN6cADV+eS6dzp9DKVB1yXjL3Em3OSP7nMHsEQGZYOAxgt92ohMEb7znmn63umikD2uP1w58oxhl6iOuzF1Y+j8ZsShe7OsYtLYfD6kH01Ph+AdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VwLXWwL7cIynFfQ8oo4gbJ/cygxEpj8WnLoZC9Tm5O8=;
 b=S0q4KyCszI6Qngp+95xYSKXJbD8kJpZ8vSLuCUVWhaprGiYSc/PNnQu2caHncUsSYs5bHinqcpuzn4AfslCJDBWkodQ69Fqls0ep2ctRpCx5n5yLcs+eKZMtodvkSLSGo39xCZ7c+0igYXQizlqBLGsdXZwNWIOtQkVgUEikQ6CGZVVdmjmPD4LRqq3eqE8/FEcrh9yCXy2up6ZEBWM4Zz7+nywOSc41DfMc9tjGqVn04LqSwB82z3oW8qpF5DA2Rvviv2Hvm99uTUelwOc/r61HZKYrsamScTkwSaYib+he+/EI6C6bmJr0zyKV28iKRxSAHNhnrG/1U2Y5PJ3NPg==
Received: from BN9PR03CA0059.namprd03.prod.outlook.com (2603:10b6:408:fb::34)
 by SJ0PR12MB5504.namprd12.prod.outlook.com (2603:10b6:a03:3ad::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Fri, 15 Jul
 2022 12:36:16 +0000
Received: from BN8NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fb:cafe::f1) by BN9PR03CA0059.outlook.office365.com
 (2603:10b6:408:fb::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.19 via Frontend
 Transport; Fri, 15 Jul 2022 12:36:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT028.mail.protection.outlook.com (10.13.176.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5438.12 via Frontend Transport; Fri, 15 Jul 2022 12:36:16 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 15 Jul
 2022 07:36:15 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 15 Jul
 2022 05:36:15 -0700
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Fri, 15 Jul 2022 07:36:14 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next 06/10] sfc: phys port/switch identification for ef100 reps
Date:   Fri, 15 Jul 2022 13:33:28 +0100
Message-ID: <f725f2e093ba6c7d5a256b9017aed640e2afb370.1657878101.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1657878101.git.ecree.xilinx@gmail.com>
References: <cover.1657878101.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ff99c52-6ce0-4de2-2178-08da665e9c57
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5504:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jWTTPMgntAYoAXUic4lUcLC9wYP6Fn/BzYJLUhBgsHit+ulaYyZNYu7Bj7suY7dGytYlD7lHOBjLm1C+Sj798wWLSOkltZBTCBqu14v0TVeZ+8+yYZh/pn4fGg+n+FexX2bpXs3FLLMELq7MCYiGIDGHmZf1x/GkxADTSq9Cix80G85VC7QoCZ5oZ6KZkf8uBANm6RD6cg8FPoZJF6l4HUisbtPpSE6Z1TUrBS2XpCdqwQXXaaS0ckVBJc9VcjJDGexZJFlwdk+i+lWcrhHzRvVUUoFZeYAe2ra8J7rrJl5RX5CdVVg5ejLbJabU+n0NPqOgsU2HM4821ahX2JlxM0OSxkpxG89GiQ5WT5U1Z4UjguhuuIpjMwaVmJVSFJHucOSu+PnOgem/4kRVqc8uk9NWZtWtAdmUY3jV4JhBrIAC4EIGUW9casj0AUBwC2TmFTRqKHw9AHUeE9XhZhCrshTTCm2o/xp1VSwRQPqSirg7K3lKWx7JHek5u/9yAcpw1Yl9xMPtXpoUGjdwT+OJT3DyaNixPMonkFY1Xy1rv9CLz/G60M+ppCFpYfondtyE1ckC2GQdItBFQquYi54/fUf7KsyPzI9sAXZqh9+rKwWtIjkY8pKv5RmTcfnoGiZa/g6I+uavusaVl2P5iRHrfvUReEq5v4jtaGVf463vJrH5pz3oyGQzjn2ZrTfbuQbUoznIi2A2Rm9wIX2rw4Z3e1PNlcnsncU2jY1bPaaRp8z6/xr9I91UPqqjjMDW7lDvtwN6UIb2A36L+qde4XdYWKnx+vsj/uwTgRyafPkGo2XX1rIhBAEGvrlzzu65crf206KSMA2tF96RSQaCVwyBQQ+ef6BQAh1ZiYgRINccvJI=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(346002)(396003)(376002)(46966006)(40470700004)(36840700001)(82740400003)(36756003)(26005)(9686003)(2906002)(356005)(83170400001)(41300700001)(81166007)(4326008)(40460700003)(42882007)(70586007)(8676002)(70206006)(478600001)(336012)(54906003)(5660300002)(83380400001)(8936002)(47076005)(6666004)(82310400005)(316002)(55446002)(2876002)(40480700001)(186003)(110136005)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 12:36:16.1636
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ff99c52-6ce0-4de2-2178-08da665e9c57
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5504
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
 drivers/net/ethernet/sfc/ef100_rep.h |  1 +
 2 files changed, 38 insertions(+), 2 deletions(-)

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
index 559f1f74db5e..7bd12aa5d980 100644
--- a/drivers/net/ethernet/sfc/ef100_rep.h
+++ b/drivers/net/ethernet/sfc/ef100_rep.h
@@ -20,6 +20,7 @@ struct efx_rep {
 	struct efx_nic *parent;
 	struct net_device *net_dev;
 	u32 msg_enable;
+	unsigned int idx; /* VF index  */
 	struct list_head list; /* entry on efx->vf_reps */
 };
 
