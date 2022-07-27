Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A06E4583268
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 20:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236025AbiG0Sv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 14:51:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236840AbiG0Su7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 14:50:59 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2083.outbound.protection.outlook.com [40.107.244.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6483A6A48E
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 10:47:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JTa5a+kzoQuNTtb8SKbSP3xmV0mQi7mf5SHQ9q9uhxA1snc8XmEyEEQLgatj+d3KaGfdReF37ixOxUhjrUYu/LiE1wyl7GkIA/+ejTMlByJY2Y5zY3q7K5irh4Wy/589wPHte8WmN2/sOgHIUl6DmKsP33CD57w3G6vLsoBjUdOUQFTCA3ecJn02rqaDm3cc2f8GWKzw+XZ+BFxjy/DiS3lSa5fODhn76OePtFnenurWQUOwJgPHyyT/NTaFo+g6Jf3siQfb+gV/TkRF1qrFAYEqJ4Fo8BweESnsTWf3OpR1JuzD+54G9gMP35hiiaGZdxYai+LjZ2IP4kSmY8qClg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8XTsJuTByqFqUO897Si3mKIyF+N/ta0OtSHC/9HLdTc=;
 b=ZeveLfPHP17Zryn8nuT1ddFipaxIEOb2CJhfOZYMkSULtJ9CJ+0hq8B5+VJujiGl2VJFVZIucgzF0RxNlAlN8/S0efRJ+tayaTkLzehtX81AxEXfjNKROm992suEiZvOffYRfqRsMSyEMVv2FvDRe0dG5XEYToEccr2OL5APfHmHj3WwjEz39yUCVkEXN3zDTNksmiR5G0lui8BvuYpjzr1MyXHxHkToIBHY3frzmDRKPimaLRxcYT7h4M+vkxvazSQCSfPWHcnAe1x+wpqWSxwFZX6HcOHPD9Pc+nNIdHY/ctd/9Znh4hG/W9G+k6D+Umkx1JDJW7Nxq6VVpa9tXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8XTsJuTByqFqUO897Si3mKIyF+N/ta0OtSHC/9HLdTc=;
 b=PwmViiSWnq85uV7Qb5Z6TpSa274uHXsRn0UFHoVDB8RIbS+lRWkUhGbL6ZsdwFaDKjLOYApcWts7fOvQl7NFRdwUAaDySt35P2LWfuIhDNBzx5SlY1Gxi/8iP+IYr5NLnbGmUodqlr5pBCyJrK+Y/kLzlxqmO48+fIWQYqIHdA2O4Eo1RMPKI56dUqXyF7oBJr9XdT9DuobpQcTWJaHAjl6+UjhRVcXpo4C9Mub0UciLXV1BVwWOR4DAqNDT4f2x+reEuIOu5nUODxThlqpSx5EfKL6CjYAwgQaY3tli2m4c4l6uMJptQOtIUPGzqKTceGuOarbxjJrdGFj9+id+fA==
Received: from MW4PR04CA0323.namprd04.prod.outlook.com (2603:10b6:303:82::28)
 by MN2PR12MB4286.namprd12.prod.outlook.com (2603:10b6:208:199::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Wed, 27 Jul
 2022 17:47:09 +0000
Received: from CO1NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:82:cafe::c3) by MW4PR04CA0323.outlook.office365.com
 (2603:10b6:303:82::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.25 via Frontend
 Transport; Wed, 27 Jul 2022 17:47:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT044.mail.protection.outlook.com (10.13.175.188) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5482.10 via Frontend Transport; Wed, 27 Jul 2022 17:47:08 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 27 Jul
 2022 12:47:08 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 27 Jul
 2022 10:47:07 -0700
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Wed, 27 Jul 2022 12:47:06 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next v2 13/14] sfc: get provisioned MAC address on EF100 VF probe
Date:   Wed, 27 Jul 2022 18:46:03 +0100
Message-ID: <4b371ae8c8a010a02e29fed47bb72f221c99b132.1658943678.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1658943677.git.ecree.xilinx@gmail.com>
References: <cover.1658943677.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b0db4372-3db7-4638-7d37-08da6ff80732
X-MS-TrafficTypeDiagnostic: MN2PR12MB4286:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y22FSJ78/zskTTVXA2CDWW6Hp1JNrYU2nb6pcFQUAZm4EkvaOl42RBeJ1wl1DbKu/LZFcQNAQkMTsn3tJzhmn12UWj24ihYKN4T8xfa09RCgShXkC8WY/ag8K3hhWKFPsX+iAtMPhoqcki3qqLQNZUkybIrA9C1dC/vscv2FVuOOMKorzJfjBnVl66Nc5LYqP8psTMwqaI1FIDm85igOWAR4WRc2RGqGLalslhRRH9ycqDUvdqD9oVPK3qicEnFikl3yjCuPdUcNI9V4AcRC4oFNH+xbL9rJ/DMqqBBQJqhTckXaKPIAII487j0dz84z3fqteOd/db6RzH8duiP9eFE3cy2OTnJhAl3A/UDXfrKSaeimFDzKKHurLyNHGmeFZ4nnW9+CTEM895lJIPBzDJ6eg0qne4fcwcaNikZ0nrWS3ggnntKJl61miflnDCj8AhX5jP6rLTzSg7UeD08g7SIi07zqJADuPDAc+gxSl0xccBJ+OvOshjihBRNyhRYfEMQKp1njBQs3tx94j+qWEliigqjvnhbHJQ2dM7QXxb3hytmU54ie7/9YdRNB0OL10deazsv+L7iKzB1AFUynvgKK82/8xELtWIlZRsWsWRTcVZT9xNNl9i3IKxK6jOIqK9ipg0xrGntyAXgDCmq0V8GYRivY0okH8CNgiwB6i+m/5HwGrGVhRolX81foW8G8WbgggonNIGS5kXaZoDJ+Uaa059WDCctxXsxBSFwnnpkQnJymm4ewC7F/EcbS6W2E2ehMcPr2Nm7gvDm9+y/XN/0mRD2c62CyKs+R76zpptsU7KtAlmmQOfALxbnc/cn84mwjrO4iUDR4BD8jTxD9rA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(39860400002)(396003)(346002)(40470700004)(36840700001)(46966006)(8676002)(4326008)(70206006)(36860700001)(316002)(82310400005)(8936002)(70586007)(478600001)(110136005)(54906003)(36756003)(5660300002)(186003)(42882007)(9686003)(2876002)(47076005)(6666004)(336012)(41300700001)(26005)(2906002)(40480700001)(356005)(83380400001)(81166007)(55446002)(40460700003)(83170400001)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 17:47:08.7793
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b0db4372-3db7-4638-7d37-08da6ff80732
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4286
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

Move the implementation from the PF-specific probe path to that part
 which is common to both PFs and VFs.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/ef100_netdev.c | 10 ++++++++++
 drivers/net/ethernet/sfc/ef100_nic.c    | 13 ++-----------
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
index 17b9d37218cb..4694417a4054 100644
--- a/drivers/net/ethernet/sfc/ef100_netdev.c
+++ b/drivers/net/ethernet/sfc/ef100_netdev.c
@@ -349,6 +349,7 @@ int ef100_probe_netdev(struct efx_probe_data *probe_data)
 {
 	struct efx_nic *efx = &probe_data->efx;
 	struct efx_probe_data **probe_ptr;
+	struct ef100_nic_data *nic_data;
 	struct net_device *net_dev;
 	int rc;
 
@@ -400,6 +401,15 @@ int ef100_probe_netdev(struct efx_probe_data *probe_data)
 	/* Don't fail init if RSS setup doesn't work. */
 	efx_mcdi_push_default_indir_table(efx, efx->n_rx_channels);
 
+	rc = ef100_get_mac_address(efx, net_dev->perm_addr, CLIENT_HANDLE_SELF,
+				   efx->type->is_vf);
+	if (rc)
+		goto fail;
+	/* Assign MAC address */
+	eth_hw_addr_set(net_dev, net_dev->perm_addr);
+	nic_data = efx->nic_data;
+	memcpy(nic_data->port_id, net_dev->perm_addr, ETH_ALEN);
+
 	rc = ef100_register_netdev(efx);
 	if (rc)
 		goto fail;
diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 2d244a425821..b5c08023c1fb 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -1135,16 +1135,10 @@ int efx_ef100_lookup_client_id(struct efx_nic *efx, efx_qword_t pciefn, u32 *id)
 int ef100_probe_netdev_pf(struct efx_nic *efx)
 {
 	struct ef100_nic_data *nic_data = efx->nic_data;
+#ifdef CONFIG_SFC_SRIOV
 	struct net_device *net_dev = efx->net_dev;
 	int rc;
-
-	rc = ef100_get_mac_address(efx, net_dev->perm_addr, CLIENT_HANDLE_SELF,
-				   false);
-	if (rc)
-		goto fail;
-	/* Assign MAC address */
-	eth_hw_addr_set(net_dev, net_dev->perm_addr);
-	memcpy(nic_data->port_id, net_dev->perm_addr, ETH_ALEN);
+#endif
 
 	if (!nic_data->grp_mae)
 		return 0;
@@ -1175,9 +1169,6 @@ int ef100_probe_netdev_pf(struct efx_nic *efx)
 	}
 #endif
 	return 0;
-
-fail:
-	return rc;
 }
 
 int ef100_probe_vf(struct efx_nic *efx)
