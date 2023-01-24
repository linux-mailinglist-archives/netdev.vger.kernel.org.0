Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3AC067A5C4
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 23:31:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234547AbjAXWbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 17:31:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234522AbjAXWbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 17:31:23 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2071.outbound.protection.outlook.com [40.107.237.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 325864F862
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 14:31:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=StOWqQcJZDMwYG0Xnop5UduS0j8coO57+b0pTt/VPWVMIWO79us4mWtCxCqtFm8RVmWOcuQWmNX/g7ZSuImxdnjxic2OG9yiFxnel48E6d+44vKVe43EFZ/RX6hOvR8ypzmuWWmnfkD5K3+LNtMYOjsmiNuqr9zOsbF8k1vIR560iPwXskvBYog2Z5T0Y04282O7PIl6JAV8c74ZEEOTGPgpRD04a6NqSeQzv7A8kUldjU6uiaV/COKcVLfaKZtk8X87K0q6xntXtkS+wGvA3JDgE9EZwAgrBuuD6fWQJHRirKGdIJBy9u4USePtf51hfj+e6Mi5NAHhuCXOWRL0Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ugihzcT6w5b87v9YUFuYKM0WE/g0dpV1qufbHeab9RE=;
 b=My+pSGi24E4VJrkU975hWXMiCC6Xlon1knOtIsjQ3k7ARv/FD9gxy76TOWhR7D0PbU2UK/kOYKfRY3XV8hDJ8yNuqg1jMZEKdX53zG/WbdhO9tSmqWzcgeGPREpR6A0Kpw96c8HqOjmhc7USCD8YAfW28eI46HA/AErI9it0TH9azZAglkQsMURxMLuYN5EOvjd4tBHZQgNvxgqedOXAcclXgtUganwE7bxMPXH6cm0Ti+8EM7nhYEGU+J4zMQ5RESr0cpLhDQJPvWTT4j7P4dMURWyPJq8SsVnc639lPQhDtw+i3kvkntg0yE8dtuSWDXX57j4Wvh95hQpQIG3aPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ugihzcT6w5b87v9YUFuYKM0WE/g0dpV1qufbHeab9RE=;
 b=FCC1HMJjI62BCqGLaZVDhliDaX4VgM79umd7gw/1ZoPpqANIBt9pdUm8i1CVrWZS7LM0MgYnRMp4Kqp8vqQblpVH8bC3pMLIg1yRbK3kQnQtplR0eCUkOzKog8eIEyRAuaH8BgkpE99aaOZWpBGEJPlP1Wo+fcvliXVk8OqAwA0=
Received: from DM6PR11CA0045.namprd11.prod.outlook.com (2603:10b6:5:14c::22)
 by CH2PR12MB4923.namprd12.prod.outlook.com (2603:10b6:610:6a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 22:31:06 +0000
Received: from DS1PEPF0000E64A.namprd02.prod.outlook.com
 (2603:10b6:5:14c:cafe::b6) by DM6PR11CA0045.outlook.office365.com
 (2603:10b6:5:14c::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33 via Frontend
 Transport; Tue, 24 Jan 2023 22:31:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DS1PEPF0000E64A.mail.protection.outlook.com (10.167.18.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6043.10 via Frontend Transport; Tue, 24 Jan 2023 22:31:06 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 24 Jan
 2023 16:31:05 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 24 Jan
 2023 16:31:03 -0600
Received: from xcbalucerop41x.xilinx.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34 via Frontend Transport; Tue, 24 Jan 2023 16:31:02 -0600
From:   <alejandro.lucero-palau@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        <ecree.xilinx@gmail.com>,
        Alejandro Lucero <alejandro.lucero-palau@amd.com>
Subject: [PATCH v2 net-next 8/8] sfc: add support for devlink port_function_hw_addr_set in ef100
Date:   Tue, 24 Jan 2023 22:30:29 +0000
Message-ID: <20230124223029.51306-9-alejandro.lucero-palau@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230124223029.51306-1-alejandro.lucero-palau@amd.com>
References: <20230124223029.51306-1-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E64A:EE_|CH2PR12MB4923:EE_
X-MS-Office365-Filtering-Correlation-Id: 22a59630-bc63-4751-bd6f-08dafe5aaee3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pvcVttcYkgqi05bZTTvqZfXGB4eWAbPrysyM0l//T8AhZoRCz9QCnnW1c71wwds7QvZy1bRO/AbedOEGfwC/lW5GZclySKbX5KNFAyF13z+ZjG7PDKxyuXL9bwH2/VvOENmBwwZMQo489vVfQndVdiSIk4dzjMvW3WdpWwu6CZzmb/HDtOrl60YnIIxjTo6R4WSVrLOptx4iPQwBCacchZWsLkRpqGUShgLjNKhMWlyLEt2z7jjttMGFUOpYwcOeA1SBeNVb61EPiEqQu9BCxnPcImHcCwnQ2jOYp6UMdFghrN2Fzn/HTQCk/cLxYS+dxJBLJ8vPP2zh1S+HfXU4ku7JEEmMVr7jhnh6J4ce6ijqGsUoSrvR3VpZF+ZCb3n1ARriQN0f/9Rq9Gi+qJaeB8gEu+YchAifkHAbpm0SQ1rCAbkLXqKaRtyEcEZh6NCEdshuSHQKcZG+bHvr5hZ6Qo8w7GFxCnyKN+UmUSwg5ugvXVJrmEpV6MNCx4bH9kDtLCNtY1VUBjMRMlyi3qm/SO22GG0KdMMMLuV57eWNdbQrt48f7kzcdKKMw45A7aUvAN6QQcoA4wqZTUKSlpdksuLgQpiYla1AmpFnG4yLskXxhPgilcEPkXmeHKYBOE4R/c+IlJFRwCpYUqJsEPqUdJymYSymw9wrEzOO4hIw/qkLCAN/i5toNnwnyeOIGb3alc26aVfEtGyXqbSlv20GBCxT6kpl5+tSGVNejNdOZOg=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(346002)(376002)(136003)(451199018)(40470700004)(46966006)(36840700001)(81166007)(36860700001)(36756003)(4326008)(316002)(70206006)(86362001)(70586007)(54906003)(110136005)(8676002)(186003)(6666004)(26005)(40480700001)(356005)(478600001)(336012)(426003)(1076003)(5660300002)(8936002)(47076005)(40460700003)(2616005)(41300700001)(2876002)(6636002)(2906002)(82740400003)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 22:31:06.0237
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 22a59630-bc63-4751-bd6f-08dafe5aaee3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E64A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4923
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
index e597280f36ad..46d8aec386ed 100644
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

