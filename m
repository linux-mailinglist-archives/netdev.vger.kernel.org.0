Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D74FF57E415
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 18:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235661AbiGVQHE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 12:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235559AbiGVQGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 12:06:43 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2078.outbound.protection.outlook.com [40.107.92.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF92A709B1
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 09:06:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YeuySkUwljwZD3N+RuuGKPJlntacKvHwiKkAgUd/ErAYWGkmp2FoeJxUEM5feggkrC8zTNfEzr4q/UiTPKOOMn4H4rGIlgCDaYZhXHfzm9tR0uFK+LprpT/1q7PExDPJFQubo2weuWToXkVe75jFaFYkpZE0wMjUX1XHHxVE/45p/16kaf2AwOqhuvXP0R4EmheARTaA95GogbJeEtb2vVt2hh/JTz9cVPquC48k3LIBemD2K8eSgSE3i7y7kM6iWwNEuERea32IbfQ6+cFiIqSic+g7Zfu9uCpJsNlI7pO6bB40B9IzcUWZm5qv+1Pe60BYXgB+pTRk0HnHI1p4/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dx5wMDZSDqlqmR68BewYhFDPYuZSr1kZe3iqiLBNebg=;
 b=l777viFERyKrauCUht/JYvQHIVRMVsXLitizey/velgGHwIDVN9YR3DQkUNo6gBeeNq8Cv0Y9QH02oc/1XSNnhIvEbEzuRLNK3GEfBJpn5g5Ws6PSV4l7BUw2GIu46AH/KSXnQLg9rghu4TMeNGeBekYIRgx8sT1mBwfmaIc+QLiBlvQ2EdO3aUmtTYOXN5ElvIU7JVGzJPDSLZDKzmRBUeBUpR/MqhhwGADf+DlvjlWGjEhBXQ+4EaNxk6JnYp7VFIQX/pk/GFuoWkA6hjyZ8LX2+/C7NYx4wLtmJ/gUfD4HmW6I9Ne5eWTWIUzQB2kXOa2Dx7g08AhkYKZ9ReEAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dx5wMDZSDqlqmR68BewYhFDPYuZSr1kZe3iqiLBNebg=;
 b=EubsjfBzb4qlzthQ2kYkzGpYGjiQZASPiyfp0XU6NW6txtLZr4auUZtYsCVce9/6StQqdoeJAl7sJdCJDxvDSTeCOOL2q3GcUMnsJAIm/Y8kuPIpS2zObZakplYtDtdtSaqGuUxJgVtAQfiKcgztERADkAPNKJbHtqw25nbExSzJTKFYfq9HWx/OBi4kktmtTCyvy8u7TaNH1gaVoZDw77E9oCU7+YRp03ucgYXe0sHfYeEAc+5eCCkuSAP+v2kLPqxCM/m3x8am/ZugqHV7BWDABtB29AHWWctPiE4FI/ctV/iqHcLwIVB8uQbaJwoLbrkaXzJzuaZoBcWUuRZu1g==
Received: from DS7PR03CA0046.namprd03.prod.outlook.com (2603:10b6:5:3b5::21)
 by PH7PR12MB6810.namprd12.prod.outlook.com (2603:10b6:510:1b4::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Fri, 22 Jul
 2022 16:06:33 +0000
Received: from DM6NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b5:cafe::36) by DS7PR03CA0046.outlook.office365.com
 (2603:10b6:5:3b5::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19 via Frontend
 Transport; Fri, 22 Jul 2022 16:06:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT019.mail.protection.outlook.com (10.13.172.172) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5458.17 via Frontend Transport; Fri, 22 Jul 2022 16:06:33 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 22 Jul
 2022 11:06:30 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Fri, 22 Jul 2022 11:06:29 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next 12/14] sfc: set EF100 VF MAC address through representor
Date:   Fri, 22 Jul 2022 17:04:21 +0100
Message-ID: <19ce6189b03c297cbcb481a733712cafebcc0fab.1658497661.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1658497661.git.ecree.xilinx@gmail.com>
References: <cover.1658497661.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5d5d59c4-9045-402a-80d7-08da6bfc258f
X-MS-TrafficTypeDiagnostic: PH7PR12MB6810:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hqEEr59Dp3A3CFW71qW5dNT10bieEIBzfXduEU9kROoOp90iUYB/vVLvNgvBRFEBRh5ABTj3AwZqZX0tyxn2mXvsfD6Z8qenn2NceguWAtR7/sgeWpWJZpgM6/wI69bDCqUmllNV/Ap6HPg904GqXT6vamzbZwGS9MwBT4kZt6KPFREe0zpal+6dW+pTNdDrEfOJULwh7XHAhv/YUwOpsABD9FCmSbiNqzl971bVQJFVye8DqTw4JGxA1OnuDJDARFrMSbJ0iTNODrhxjk0+EDcOSe0NXnVApWt5jGwa5d9yCs9nUSEq6NjYqZCEPw3av5nSZCXnQxIfIZewCbRw/DSazB5BoPY0xS/rkaWBCLp4RRmh7fD1aeyMSn13rLVaQ9WjaK15E1jZc0YVg7t++c1GgnGrZoL/uQ6kMtZ401TwiIa9y6Q+u6NH2Yy/SNTf0GLvXXIc3WwbKhW91ciP0FIR4w5eSfFkJh6RB+3Wid3P2sxVO0xYHdBQXM2T2X/DNU+f/MKqF/6FYa1UNXSi260omJK/9eFRZfoPOqwp2TJDsoA6obfFSTmgmiIFun5Yq5oRQZD6WdV5ysAVgaBRe+bXi0o91DP6O9a13uyohLIgWNbgDtNlF+jC6IXfL+CI3rdPMLaWLcPW+qqXbP938SbRHv9Qjvykc3k+q4GZ1ce90FIIdFOAiRoAQBJrQvxuXbzHTT8MQu61+ZYWvkFfMYwvRBmhoQrBhbUPPPK6QnIkEHvvldGV/VEZ+UkWMlNq7jtS3wHncDvPBkqm/Q0rWO7nfFbHZluNE3Kk2O1vJQlC8COtyt+2RorIgbpqRyLYJga7CE65+jyEywtamahpXQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(346002)(39860400002)(136003)(46966006)(40470700004)(36840700001)(186003)(41300700001)(82740400003)(42882007)(83170400001)(356005)(9686003)(26005)(82310400005)(81166007)(316002)(2876002)(40460700003)(36860700001)(40480700001)(54906003)(8936002)(6666004)(70586007)(47076005)(5660300002)(110136005)(336012)(4326008)(70206006)(8676002)(2906002)(55446002)(36756003)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2022 16:06:33.1345
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d5d59c4-9045-402a-80d7-08da6bfc258f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6810
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

When setting the VF rep's MAC address, set the provisioned MAC address
 for the VF through MC_CMD_SET_CLIENT_MAC_ADDRESSES.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/ef100_rep.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef100_rep.c b/drivers/net/ethernet/sfc/ef100_rep.c
index ebab4579e63b..58365a4c7c6a 100644
--- a/drivers/net/ethernet/sfc/ef100_rep.c
+++ b/drivers/net/ethernet/sfc/ef100_rep.c
@@ -107,6 +107,33 @@ static int efx_ef100_rep_get_phys_port_name(struct net_device *dev,
 	return 0;
 }
 
+static int efx_ef100_rep_set_mac_address(struct net_device *net_dev, void *data)
+{
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_SET_CLIENT_MAC_ADDRESSES_IN_LEN(1));
+	struct efx_rep *efv = netdev_priv(net_dev);
+	struct efx_nic *efx = efv->parent;
+	struct sockaddr *addr = data;
+	const u8 *new_addr = addr->sa_data;
+	int rc;
+
+	if (efv->clid == CLIENT_HANDLE_NULL) {
+		netif_info(efx, drv, net_dev, "Unable to set representee MAC address (client ID is null)\n");
+	} else {
+		BUILD_BUG_ON(MC_CMD_SET_CLIENT_MAC_ADDRESSES_OUT_LEN);
+		MCDI_SET_DWORD(inbuf, SET_CLIENT_MAC_ADDRESSES_IN_CLIENT_HANDLE,
+			       efv->clid);
+		ether_addr_copy(MCDI_PTR(inbuf, SET_CLIENT_MAC_ADDRESSES_IN_MAC_ADDRS),
+				new_addr);
+		rc = efx_mcdi_rpc(efx, MC_CMD_SET_CLIENT_MAC_ADDRESSES, inbuf,
+				  sizeof(inbuf), NULL, 0, NULL);
+		if (rc)
+			return rc;
+	}
+
+	eth_hw_addr_set(net_dev, new_addr);
+	return 0;
+}
+
 static void efx_ef100_rep_get_stats64(struct net_device *dev,
 				      struct rtnl_link_stats64 *stats)
 {
@@ -126,6 +153,7 @@ static const struct net_device_ops efx_ef100_rep_netdev_ops = {
 	.ndo_start_xmit		= efx_ef100_rep_xmit,
 	.ndo_get_port_parent_id	= efx_ef100_rep_get_port_parent_id,
 	.ndo_get_phys_port_name	= efx_ef100_rep_get_phys_port_name,
+	.ndo_set_mac_address    = efx_ef100_rep_set_mac_address,
 	.ndo_get_stats64	= efx_ef100_rep_get_stats64,
 };
 
