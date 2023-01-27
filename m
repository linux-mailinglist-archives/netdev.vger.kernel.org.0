Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D81BC67E069
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 10:37:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233139AbjA0Jhn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 04:37:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233126AbjA0Jhk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 04:37:40 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2073.outbound.protection.outlook.com [40.107.96.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E4C4347B
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 01:37:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nBbFg06cFgyLzhjhI23j+rZMJR9YXyw37dFzR5Un4T2TlsoPYn+hPTLGQ3bwgR7m20s/ts7b+9dtyOS32x4dcg7stgcYVADvhh705hZBT7zc64sNerinnpbOv7PdEOwgl5I3zkKsmozi3NERhOUV3kw3Mpi962sEMxspdLxdonw44QRbcTCMPeMeX/VWZj2BNAJPH8B8xXW/5+MQi5IAIXTYeQFLwOe0ZbikiUH4t6Bs5qzVsEJhYf5yKJ7APrLgdYnIBDGJFIF2PcCXnUc8bZry4Nq+0z869MM6wk9OZPCoJFKvmVgaWnrrFdoWQyWc7UW6PP9saIRnqX1gjSQBEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WfGT1atdJUhHhw6lwE0zjn3nkvpfcubKTiOpuApkKvA=;
 b=NUvh8bGTA6A4wBa2+0iXaZTSGkOFUQRD+TFCwaZFAvNmEmNFM3BnJqGaSJSlDUlwoN23C+cVqqrfDCgbjrwpbRb5NwRGy8D8GyFXS7+EfjDlzmCPi9fz1P+V/A8JoEtxddgD5q6rXYXRURkJ9/Y6dW9JFRCCO1J/mkNgDKhgu+2W2E1Z2iLaNO1hmn+datG4bhq8CJIEaDLejVBwTpFJ+9acl/+JSuwNpmOsh7FZh1f5mLdpnTCp3KVvEODen2y1+FLLS6Uitev3VPHI58pykKl0auhow0AS69eRR357A7qo51Qsst5OdNvCALz5/WDczu4RUXPuKVaixYS5ZAI8TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WfGT1atdJUhHhw6lwE0zjn3nkvpfcubKTiOpuApkKvA=;
 b=EQ4W8zwM5LjaV2I7ky7ZdibphxUSpCngfUsz/CvsQcVTfwZGBbHxj+f/mHF+Wmxqdu+3qSlq6nQZ/3V20eU3AuY6SNljWngMgNkBcEujdjKyXhV3UDbSPeEaWWSik7eif+NFfwBcEZILmINlQRrtmPPIhu6Kx757jVQYR5pFKgs=
Received: from DM6PR12CA0013.namprd12.prod.outlook.com (2603:10b6:5:1c0::26)
 by IA1PR12MB8192.namprd12.prod.outlook.com (2603:10b6:208:3f9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.21; Fri, 27 Jan
 2023 09:37:27 +0000
Received: from DM6NAM11FT095.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1c0:cafe::26) by DM6PR12CA0013.outlook.office365.com
 (2603:10b6:5:1c0::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23 via Frontend
 Transport; Fri, 27 Jan 2023 09:37:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT095.mail.protection.outlook.com (10.13.172.180) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6023.16 via Frontend Transport; Fri, 27 Jan 2023 09:37:26 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 27 Jan
 2023 03:37:25 -0600
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 27 Jan
 2023 03:37:25 -0600
Received: from xcbalucerop41x.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34 via Frontend Transport; Fri, 27 Jan 2023 03:37:24 -0600
From:   <alejandro.lucero-palau@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        <ecree.xilinx@gmail.com>,
        Alejandro Lucero <alejandro.lucero-palau@amd.com>
Subject: [PATCH v3 net-next 8/8] sfc: add support for devlink port_function_hw_addr_set in ef100
Date:   Fri, 27 Jan 2023 09:36:51 +0000
Message-ID: <20230127093651.54035-9-alejandro.lucero-palau@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230127093651.54035-1-alejandro.lucero-palau@amd.com>
References: <20230127093651.54035-1-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT095:EE_|IA1PR12MB8192:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a9c23e4-760e-40ee-1aea-08db004a19dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P1pmEysYCKwp2sCR71WPT34P1otHHiGe9R6hmDhrtDow78nTyoeHJSts9FQNlvCpQ0zFUYBBwb7h+y/nWVREAJoYlJJg90MEpae8TybEuiy/FVLtiiy4ghs1i676EhNQ0MNMyRANTYdOzkWzJ32x5sd7q9ckGuG+nAyttbf6e2IfkTNVYIlgVCZ1Y5lg6oqfPYdOHF9k36Uv1KQpMvioZIf7RWCDGBQ5f1R33ttpu6JvQHrKpZzmCU23G8KAErGQrYVFcXGy5NoauP8/SaUN8ZyihfA+L/DL4lvoWYyjgVOV0GBr7y7gEfEFq+qy9JmoeMsFw8AsUQwfyZfBKSBCpAbKnMeB52D36a7KAIooITzCWa4jw0FyF51pChsGvXb6Zm7tNSn2ghMp4J8W8ix06gP+DGo+KsJlIDDv7kBl3AAhH06pH51Dqdt72AONZET4TXNKlWqo7LmhRylxqZ5Yrb6SlhYZ53vYNdAYqRUfaxj3mnHw1qzya868XzVA8/66JdC05KI8Jx6yObnrrpbZ0l1Zip1fFVP45rbgwwWHjAoGsyt3eyf1Obf+PsxvY5x8vhJNpl3XFeo60tw4qzYtFYHAxB9gz9bTjH6Y8dXsWD8qAoy7Jcm4N7AYDThjuRj2RiIPELqqRagMI45ZgG6xxygtFLU7/qvrjWbywUAG5u7reLCYtMManFS/oOpsTMddTEbE7ppNBBjnGBwNuW7CsXGb/LaLoPuGPEQjsNNt2WE=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(39860400002)(136003)(376002)(451199018)(36840700001)(40470700004)(46966006)(40460700003)(356005)(40480700001)(36756003)(6636002)(8676002)(82740400003)(1076003)(478600001)(41300700001)(6666004)(2876002)(70586007)(110136005)(4326008)(70206006)(2906002)(316002)(8936002)(36860700001)(426003)(2616005)(26005)(81166007)(82310400005)(5660300002)(336012)(86362001)(54906003)(186003)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 09:37:26.3554
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a9c23e4-760e-40ee-1aea-08db004a19dc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT095.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8192
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
 drivers/net/ethernet/sfc/efx_devlink.c | 44 ++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/drivers/net/ethernet/sfc/efx_devlink.c b/drivers/net/ethernet/sfc/efx_devlink.c
index 2c84e89bd007..f294d829d0d0 100644
--- a/drivers/net/ethernet/sfc/efx_devlink.c
+++ b/drivers/net/ethernet/sfc/efx_devlink.c
@@ -101,6 +101,49 @@ static int efx_devlink_port_addr_get(struct devlink_port *port, u8 *hw_addr,
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
+		NL_SET_ERR_MSG_MOD(extack, "port mac change not allowed");
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
+		NL_SET_ERR_MSG_MOD(extack, "No internal client_ID for port");
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
+		NL_SET_ERR_MSG_MOD(extack, "sfc mcdi error");
+
+	return rc;
+}
+
 static int efx_devlink_info_nvram_partition(struct efx_nic *efx,
 					    struct devlink_info_req *req,
 					    unsigned int partition_type,
@@ -507,6 +550,7 @@ static int efx_devlink_info_get(struct devlink *devlink,
 static const struct devlink_ops sfc_devlink_ops = {
 	.info_get			= efx_devlink_info_get,
 	.port_function_hw_addr_get	= efx_devlink_port_addr_get,
+	.port_function_hw_addr_set	= efx_devlink_port_addr_set,
 };
 
 static struct devlink_port *ef100_set_devlink_port(struct efx_nic *efx, u32 idx)
-- 
2.17.1

