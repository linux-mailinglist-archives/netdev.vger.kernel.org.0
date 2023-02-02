Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB22687BFC
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 12:15:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232011AbjBBLPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 06:15:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232050AbjBBLPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 06:15:17 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2046.outbound.protection.outlook.com [40.107.93.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A249988F03;
        Thu,  2 Feb 2023 03:15:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=myNNQ0VpU36mkHn3fpQ8lGD8UoX6ONQrMy0Y8YGnbIYon32HqkqUaMp8njXMNjuYXxFVSJOLSEzK5HiGl+wY9N5efvXp7Xtj4KYQG0f5V490P9qFclR0xLc50cN6GQkyxy19V07BZnkAvcSRHosR9z24oLzu+tRgS4PKVetbaCtSnG2cty68Gq3kUMNXcOebXcRzs2tTg32UMUr7xJCVnaJM+sj68txbSRdHDUknFiM/TUo5/k1H95NW8QMygvlg2Nk10xSrGQoxzjtEIfiOmsARP8IrnNzNArjMiF6Ixq+UBtSW9U2x1iXFqVYexX7+XEid0NtzW5v/Gq3tRiU5Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=acNbMERP3xlO4dRwJJVNEAYHmydxVq0wWOl0XGDB6gU=;
 b=TJHA/iOMFnp+cV9z7yx+OaipZ33H5/vF/kr3LkE9hVNb9+hG93cPkOy+8XV4IiT79LmN4jXMFhtl5AfdhcSdOjUfp7ItML5ur+tWKmLMi7i4+CcY3NslpHv6S0k15nlv+fi7+0dBKGJ4SsZn9QT6fPp2/bgfcFYm2TjWUjJDOUIVhTXjR3d2ohmKBNndPZffzS8dpK1v0djjKVJVDvnARyZ4NTH+dEKMeZS7boEfL8CIMq0/9yAs2hKjTNE/LYl1O5Gmkti8ULhdTwcuCZQoPbDc4xUXZtFFrVdl/qUVvT/6o9cGUTRctfWQ+ymRhOs7usKuW1Fz/OQeD4OHjqMcEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=acNbMERP3xlO4dRwJJVNEAYHmydxVq0wWOl0XGDB6gU=;
 b=t5J0DpP2xTOBaDek0OOGCTsHFvKihl6Y7OaWtcBHCHQsPQWftrXIToqTuO0KWAH7kqtJApqY/S/PGS9Fk+pibjKtoMmuSttoPb5r3rsFyGO60cIjjvvKK54qBUSPz8aqRN71Ov0K+RUVr8ihBItXTJl2vmCzaAH3E6LyQrmd1HA=
Received: from MW4PR03CA0154.namprd03.prod.outlook.com (2603:10b6:303:8d::9)
 by PH7PR12MB8056.namprd12.prod.outlook.com (2603:10b6:510:269::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.22; Thu, 2 Feb
 2023 11:15:05 +0000
Received: from CO1NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8d:cafe::7f) by MW4PR03CA0154.outlook.office365.com
 (2603:10b6:303:8d::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27 via Frontend
 Transport; Thu, 2 Feb 2023 11:15:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT050.mail.protection.outlook.com (10.13.174.79) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6064.28 via Frontend Transport; Thu, 2 Feb 2023 11:15:05 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 2 Feb
 2023 05:15:00 -0600
Received: from xcbalucerop41x.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34 via Frontend Transport; Thu, 2 Feb 2023 05:14:58 -0600
From:   <alejandro.lucero-palau@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        <ecree.xilinx@gmail.com>, <linux-doc@vger.kernel.org>,
        <corbet@lwn.net>, <jiri@nvidia.com>,
        "Alejandro Lucero" <alejandro.lucero-palau@amd.com>
Subject: [PATCH v5 net-next 8/8] sfc: add support for devlink port_function_hw_addr_set in ef100
Date:   Thu, 2 Feb 2023 11:14:23 +0000
Message-ID: <20230202111423.56831-9-alejandro.lucero-palau@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230202111423.56831-1-alejandro.lucero-palau@amd.com>
References: <20230202111423.56831-1-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT050:EE_|PH7PR12MB8056:EE_
X-MS-Office365-Filtering-Correlation-Id: 9bd15047-5280-4a6c-fd0e-08db050ebc9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kmsJRPZQUtGKxf9pmTHBEIIlfKEE0GyU1y8z3pMNvg2ffyeVPxVroBEm9RvlaH/o0Ep5z77RKUeAdn8W6hLjGaRYllF+KGVxrj5UNNhbKHYHL95ZPzAVo3CePW7fEftvwyCC3KHiNFdeiVGYdDDkb+oSsei/8PPpPcIttNZEUMv/BGCjq9fBaLAXWabsf46hZRhQlmnOVDToMQB2MsBrd3jSaEdukJZyHo4AcvjDj2jo3DFVhyHz6UkSLVksVrHJRIYS2xad8LLv39cwW0d9Pmyhi5mwDtd9zHEOYCQZuw/eBQWnQ+qhCo9i4+RiTXJg3mzOUhlDeVQtSlbxDbyBsHYio/0d6Tz2iNPBrLhmWyzUk72q0N0h9X1QCIVBQTlCG9d2nSXBPV3r+2xndPM2H7qPyI8sToZO+9xpYgwe3op3MWTXmgdnC+eDuTLYdPqI7TtEKOglQrpbS98WgRx18qHQT5pI/CtqfhBs5mSb3hImkCLSqaw0uf/uvvvWuvIvmIKfOAGMsLbaI1JFgVMCTLFDg88Pay7GE/bjtBsR0gOQh1w3wFBOecA8BNZuO4wc8wfZH3/M1dohU2NelEeYik1cy2qE0tJ0qgTUIJFzgSwnulZe3B1ck7GegAZC7K9hqiz6kgN43RXK63j73+VL3haMCLr5Vxg7Dw4+OjO1kECrP8uvaKEEODHjJ+s2csN9vsR3KQ+qc16GjuhA/7m7anuSnbCtsG7rsUrKyQFscHg=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(136003)(39860400002)(346002)(451199018)(40470700004)(36840700001)(46966006)(8676002)(110136005)(54906003)(2906002)(40480700001)(478600001)(6636002)(316002)(2876002)(40460700003)(41300700001)(8936002)(4326008)(70206006)(5660300002)(70586007)(7416002)(86362001)(81166007)(356005)(36756003)(82310400005)(47076005)(186003)(2616005)(26005)(336012)(82740400003)(6666004)(426003)(36860700001)(1076003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 11:15:05.2955
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bd15047-5280-4a6c-fd0e-08db050ebc9c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8056
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alejandro Lucero <alejandro.lucero-palau@amd.com>

Using the builtin client handle id infrastructure, this patch adds
support for setting the mac address linked to mports in ef100. This
implies to execute an MCDI command for giving the address to the
firmware for the specific devlink port.

Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>
---
 drivers/net/ethernet/sfc/efx_devlink.c | 50 ++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/drivers/net/ethernet/sfc/efx_devlink.c b/drivers/net/ethernet/sfc/efx_devlink.c
index c44547b9894e..bcb8543b43ba 100644
--- a/drivers/net/ethernet/sfc/efx_devlink.c
+++ b/drivers/net/ethernet/sfc/efx_devlink.c
@@ -110,6 +110,55 @@ static int efx_devlink_port_addr_get(struct devlink_port *port, u8 *hw_addr,
 	return rc;
 }
 
+static int efx_devlink_port_addr_set(struct devlink_port *port,
+				     const u8 *hw_addr, int hw_addr_len,
+				     struct netlink_ext_ack *extack)
+{
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_SET_CLIENT_MAC_ADDRESSES_IN_LEN(1));
+	struct efx_devlink *devlink = devlink_priv(port->devlink);
+	struct mae_mport_desc *mport_desc;
+	efx_qword_t pciefn;
+	u32 client_id;
+	int rc;
+
+	mport_desc = container_of(port, struct mae_mport_desc, dl_port);
+
+	if (!ef100_mport_is_vf(mport_desc)) {
+		NL_SET_ERR_MSG_FMT(extack,
+				   "port mac change not allowed (mport: %u)",
+				   mport_desc->mport_id);
+		return -EPERM;
+	}
+
+	EFX_POPULATE_QWORD_3(pciefn,
+			     PCIE_FUNCTION_PF, PCIE_FUNCTION_PF_NULL,
+			     PCIE_FUNCTION_VF, mport_desc->vf_idx,
+			     PCIE_FUNCTION_INTF, PCIE_INTERFACE_CALLER);
+
+	rc = efx_ef100_lookup_client_id(devlink->efx, pciefn, &client_id);
+	if (rc) {
+		NL_SET_ERR_MSG_FMT(extack,
+				   "No internal client_ID for port (mport: %u)",
+				   mport_desc->mport_id);
+		return rc;
+	}
+
+	MCDI_SET_DWORD(inbuf, SET_CLIENT_MAC_ADDRESSES_IN_CLIENT_HANDLE,
+		       client_id);
+
+	ether_addr_copy(MCDI_PTR(inbuf, SET_CLIENT_MAC_ADDRESSES_IN_MAC_ADDRS),
+			hw_addr);
+
+	rc = efx_mcdi_rpc(devlink->efx, MC_CMD_SET_CLIENT_MAC_ADDRESSES, inbuf,
+			  sizeof(inbuf), NULL, 0, NULL);
+	if (rc)
+		NL_SET_ERR_MSG_FMT(extack,
+				   "sfc MC_CMD_SET_CLIENT_MAC_ADDRESSES mcdi error (mport: %u)",
+				   mport_desc->mport_id);
+
+	return rc;
+}
+
 #endif
 
 static int efx_devlink_info_nvram_partition(struct efx_nic *efx,
@@ -574,6 +623,7 @@ static const struct devlink_ops sfc_devlink_ops = {
 	.info_get			= efx_devlink_info_get,
 #ifdef CONFIG_SFC_SRIOV
 	.port_function_hw_addr_get	= efx_devlink_port_addr_get,
+	.port_function_hw_addr_set	= efx_devlink_port_addr_set,
 #endif
 };
 
-- 
2.17.1

