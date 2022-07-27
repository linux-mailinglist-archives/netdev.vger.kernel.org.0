Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C507583269
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 20:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236628AbiG0SwA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 14:52:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236962AbiG0SvA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 14:51:00 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2075.outbound.protection.outlook.com [40.107.244.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 644A36A48D
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 10:47:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iqK2WDPpYTNz8j/vKESli9EAomCxZQcE1fDGlQUkKdFcVmj6y7gS8ZNpbPNLdyjyIuACNTDV7HUEjAzyQTqSayZpJYLcMmrvNueSJlsQBx31o0Nh0KyiWn/XVbMbN98pPkNVtPEzXmowFm5Jegu/Y+Fg9+sAD7lzvykv7v12w/MV9BAHfk61ZOoBODikoNTYTcu3FACFZsZ7RZK3edTdNMuV/mCi9y4faHTLmuaSaYZYLIZ/B9D6+3bqbsnRPA85XDsSSdqBfYqoxHBT/KcnfoJscJWTraXKlncK9Wobrj35k9Kpsvk9ygb+WmHvGEwpMaWeE2i1SasekPUsyXOFDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dx5wMDZSDqlqmR68BewYhFDPYuZSr1kZe3iqiLBNebg=;
 b=dTXxphmC/1VsX7kPryV5lxBD3fLIFOpL4QbRdlmMAX5FkWQuLLzerZMNZmIdJ4sTDeFZO+vQIUM3I3HV0g4KOT5csD0k8ww3EkHmRxj3S4zxxtRccuA9Jnf9OWUm2Uf5TvZzdXcI3e6LoP0g7EEQNEDL8hzeYAOgdfptALP705Q2fP0GlEQ4+UBpKl+8pkUaAWbj+B3ObZRwQc0P3dQujoVJbO/BVsWJgIQk9Kst+CLGgg53xnNQX4EQrXLAiEniztUnrPEXgPo9LsAMJLqkG1svVoAnhFs2yi97EOsToXhRDjKdu3GXgK8L6VAxAqN+oCMsPVI/IMmbIHWKMp6YeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dx5wMDZSDqlqmR68BewYhFDPYuZSr1kZe3iqiLBNebg=;
 b=Bhi9kEurvxVe/6NM8Tfe1cIepGcd1aeTsQfmHD6pgrssyWoc+zxYg1BFk8du/tGlJO3jpoVBq6quhB2L5Ca7r6DQN0hczazz47qSkAHYvBG255VtKU14L1gFey2uVC6Bl+ZBcYXMkfAGmrPkoWPIy0FnDUxBQfSE9nNDa5WxFquKRb/VTCY8zsA5uJlRtS8G7E7gSATTYXJZQOLgLZsCeQvJqnBPtpguP7B3sb2Vu1MbIi115TYbdtGnqFIuMznMSgILMArVlL1a5jcAKkG3Gl1tOVRN/nQdtVZ2cn4xMcQoa3aZ9gbL+tNkztSEbr/7LasezYAV5N7fQHyywPvJJw==
Received: from MW4PR04CA0105.namprd04.prod.outlook.com (2603:10b6:303:83::20)
 by MN2PR12MB3600.namprd12.prod.outlook.com (2603:10b6:208:c6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Wed, 27 Jul
 2022 17:47:09 +0000
Received: from CO1NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:83:cafe::bd) by MW4PR04CA0105.outlook.office365.com
 (2603:10b6:303:83::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.20 via Frontend
 Transport; Wed, 27 Jul 2022 17:47:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT016.mail.protection.outlook.com (10.13.175.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5482.10 via Frontend Transport; Wed, 27 Jul 2022 17:47:08 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 27 Jul
 2022 12:47:07 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 27 Jul
 2022 10:47:06 -0700
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Wed, 27 Jul 2022 12:47:05 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next v2 12/14] sfc: set EF100 VF MAC address through representor
Date:   Wed, 27 Jul 2022 18:46:02 +0100
Message-ID: <304963d62ed1fa5f75437d1f832830d7970f9919.1658943678.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1658943677.git.ecree.xilinx@gmail.com>
References: <cover.1658943677.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 17c8eb29-6adf-4897-e8a9-08da6ff806e5
X-MS-TrafficTypeDiagnostic: MN2PR12MB3600:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xCptj5TNa9m+fnHsvO0ZCDrgscmM4sxKywbzvkaJeFCCm9MXyMqu685ajlr6OssSh0tq9eEdEdpbAm69Kqn9mLs64rJwZwk5gcGnWXGhJwa3sXDrBJh9BXBvFqidVAFzLQO3AryDl67HCJNNqOYJ9fkDEalg6c0tMwdk5Smd7nI125MyEt4tBzTX38B/QOT4Sh0zDXsnFjn2kFQoQVSIjC/gisDCocOFFebKO8gj3RQA7xd35pJUDAk0vSR50ViRJrozsgXXgijyR+YUkO46rT5a2mR7zddc71a51t+Gkr9/luSDaEd8ySdtGUDhMM7028X+pd/6qcqjzAIIk4i2HYguR9iC0CVKZ8UIS0/v7RlBzRZBRQuPV3VWmrPTRErKJxrKVjEbHDm5G3k4mNTjxe4+4zNl0aHXelWGlv7e/bKyAtiGOpjaqLi2FhopZQ1XuZVZs25hjxACX5uuRoCfVj1aqUAblC5L3C4WDGikyRnEgfjc0xKCLAoW2xwRrYHzb37JC7Zojb7n80KmAht06sMxkiA8SHW7cXdN4iEtke+3Kp0EFHoDsus1s+A1JbqE882rn9T54s9bZLQZbFvzSJr8Wd+akPMFa50Is51BJ7PAv7WGv2JYZRmf2joLsmH46M1cy/lqw+advSqEEhu4villvcQ4c7gj/4aq73Yqs713t1iiTUlvOWtXO1q7ONwip8l3FS+97BMoTmnT3/rCvE3llDDGLEmYFoQy9eklVRCfBMMnWJ3dpW47BmEw1lvKuY5vjGRFWZyCSSdOCKp/W47+rmhehCvQqj/a+cC9PEzGvBefwG/SELtmFqdxD4Igv5+PALzQScX1/ISveeHl7A==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(346002)(39860400002)(136003)(36840700001)(46966006)(40470700004)(9686003)(40480700001)(42882007)(26005)(186003)(8676002)(8936002)(36756003)(2906002)(41300700001)(6666004)(36860700001)(2876002)(82310400005)(55446002)(47076005)(40460700003)(5660300002)(336012)(316002)(110136005)(70206006)(81166007)(4326008)(478600001)(356005)(70586007)(83170400001)(82740400003)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 17:47:08.2774
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 17c8eb29-6adf-4897-e8a9-08da6ff806e5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3600
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
 
