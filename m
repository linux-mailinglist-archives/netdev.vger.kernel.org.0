Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8647668F0C5
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 15:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbjBHO0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 09:26:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231476AbjBHO0F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 09:26:05 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2081.outbound.protection.outlook.com [40.107.93.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9C8E4B193;
        Wed,  8 Feb 2023 06:25:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cYANdnnHMqa2jhBkaAOsBppWYq7bIqrNd22HQ2VlSBYroAZCs0fNpVbEL8gxOHWGSKjwVWamSxZmViHiMIz4WJ++fP6zuk/vP67vXpIlmKwLvAy2S5vcapkCihZTqE706yDzpPcnbtl6nSW5TN0haNzHfgZjRNd+fZ5zFjUUBJAWrV7o4qD7GvbVHYywLlFii3E5fI5vFwcMzw9zgXznRmpLV52nN2wAzMQGRK8mOM+Dep9jHKH5dxjpZS/vEK2uaS1sy5DMLTfxqeGlhg2vNQ4IEG9VlHG7uBLftUaUgYN1e5gVvbuVrtYoCvRDZ61eSDI8WO3Dqgwf9r0P2YTdHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jn3z1wMrY6oM/+u3a4oOwwuBi3rZ19iDwgW6VcJ6gNQ=;
 b=eebSlXlansNPST5iqydId0u9FfiwVOkq2ffTvX73Uh0JOfP+djKN+AevjlxA6mzs/oZqwce8NkA3RR3Fo4zQE7vHgu8hl/OQCPn83LxSzlSEqij+sCWWyqVF7LL+Ysd/jP86rbVwJvWUtr6yXxcLqK5VN0ggawh2R+v4zWszeHSgWD9jdTqbhkmtyvnTImatgXi5BMvY5J/qVvpa3J4e9/9G4wiWkRrkZmXjwxelF3YiKLN4HzLch7Ns5W6Jd8CSBM9waMe51HF5Bvx0WG6txPz5inPM+lXQMhdgVYGqFACapKD8iMxBw9er6M3eiGlc3vcnDe/Z4uCECJ/FA8ZFVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jn3z1wMrY6oM/+u3a4oOwwuBi3rZ19iDwgW6VcJ6gNQ=;
 b=Qnc+WfjovW7dKq4gwfYY13VXxHL7ADS0AL5d9nCqTSX3BwRp/Ls++7oYQSrcHr+U4b5U1/GJ/ttntZk71NZLktMRdJXEqc9Fzb8huZ6hosWlaTPvTqWHkJkv2rE1v5gJcyZfF67Orhiqz0FEKW2aIQoTm99mAmcFbsp1X4BPOBQ=
Received: from MW4PR03CA0144.namprd03.prod.outlook.com (2603:10b6:303:8c::29)
 by DS0PR12MB7702.namprd12.prod.outlook.com (2603:10b6:8:130::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Wed, 8 Feb
 2023 14:25:53 +0000
Received: from CO1NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8c:cafe::b) by MW4PR03CA0144.outlook.office365.com
 (2603:10b6:303:8c::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17 via Frontend
 Transport; Wed, 8 Feb 2023 14:25:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT065.mail.protection.outlook.com (10.13.174.62) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6086.18 via Frontend Transport; Wed, 8 Feb 2023 14:25:53 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 8 Feb
 2023 08:25:52 -0600
Received: from xcbalucerop41x.xilinx.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34 via Frontend Transport; Wed, 8 Feb 2023 08:25:51 -0600
From:   <alejandro.lucero-palau@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        <ecree.xilinx@gmail.com>, <linux-doc@vger.kernel.org>,
        <corbet@lwn.net>, <jiri@nvidia.com>,
        "Alejandro Lucero" <alejandro.lucero-palau@amd.com>
Subject: [PATCH v6 net-next 8/8] sfc: add support for devlink port_function_hw_addr_set in ef100
Date:   Wed, 8 Feb 2023 14:25:19 +0000
Message-ID: <20230208142519.31192-9-alejandro.lucero-palau@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230208142519.31192-1-alejandro.lucero-palau@amd.com>
References: <20230208142519.31192-1-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT065:EE_|DS0PR12MB7702:EE_
X-MS-Office365-Filtering-Correlation-Id: 0cd8106d-69fd-4b7f-e346-08db09e062c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4TFdIELFf/oTtk0gPXk2ugXbSPafGJv9MMWMgDoaWN55pCB4ciYKmqxWLvQPx1ofJX7QdJSsY3FWKPiSuxDdeCaoFE/Xw16Eoun/bcGhp6ABZZQMvU26urqWIpWzs1cFG8q6PuIDkg2KJgRx9rgno4zMLL5Eb8HrEl+e/u3qfDqXsTfW7HVXvuQR31nd2ZgqSXh27FoT1g/XL0kd/30Mwu/lD5T8dRYdL3joDw8XbkJkQarEgVGETxTKRQOGH1nWdbsIqP7MeGLKFLHKS3PMYlF/eWryIjV1OdrBUfkmHfeMRPHrOrtSjtS/fylsn+B8kqPfTgtybblnZTRxXNzA2u0f49LiCfnEWJRwNo1Qps50UJr8kCvodZqVDzzZgB66fAjnQ+yHf52QPg1e5sDMC1HFrpsRXn5lBQygXCpo8xQAnCSO7rp+byiaB8xGwAQ8kDhKvp10HArTWivLgwuLH1rVHyfVAuT9NASjUsqStut4psjDw1/+LdYaIFOqCbUJTYZjunyE/k2W/TgbKaHWaLv3pc656yJIqV1FUg/TiF19FfojrOwYsGSo5wGxguhsRxLjngLqJ6x2F0+mhARpk1E5hj2vSX1tv47GpSuQ2QPvUAQwFcq3nRMRVbpZyvtoaHGx4E7a+/9yDBpjKTy/JEn0lx/mZhcRqX59cJRzhddVZ6njFb+49Z3ukumLHP+cHV2+00qKxEmjtQk7bVnbv0+ByOrmafB7P4Y4eSlX0W4=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(346002)(39860400002)(396003)(451199018)(40470700004)(46966006)(36840700001)(82310400005)(81166007)(426003)(36756003)(47076005)(5660300002)(2906002)(2876002)(7416002)(1076003)(186003)(26005)(8936002)(6666004)(41300700001)(478600001)(40460700003)(316002)(86362001)(82740400003)(2616005)(40480700001)(336012)(356005)(70586007)(54906003)(6636002)(110136005)(70206006)(4326008)(36860700001)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 14:25:53.5536
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cd8106d-69fd-4b7f-e346-08db09e062c1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7702
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

Using the builtin client handle id infrastructure, add support for
setting the mac address linked to mports in ef100. This implies to
execute an MCDI command for giving the address to the firmware for
the specific devlink port.

Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>
---
 drivers/net/ethernet/sfc/efx_devlink.c | 42 ++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/drivers/net/ethernet/sfc/efx_devlink.c b/drivers/net/ethernet/sfc/efx_devlink.c
index 68d04c2176d3..9fc2fe862303 100644
--- a/drivers/net/ethernet/sfc/efx_devlink.c
+++ b/drivers/net/ethernet/sfc/efx_devlink.c
@@ -103,6 +103,47 @@ static int efx_devlink_port_addr_get(struct devlink_port *port, u8 *hw_addr,
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
+		NL_SET_ERR_MSG_MOD(extack, "Port MAC change not allowed");
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
+		NL_SET_ERR_MSG_MOD(extack, "No internal client_ID");
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
+
+	return rc;
+}
+
 static int efx_devlink_info_nvram_partition(struct efx_nic *efx,
 					    struct devlink_info_req *req,
 					    unsigned int partition_type,
@@ -557,6 +598,7 @@ static const struct devlink_ops sfc_devlink_ops = {
 #ifdef CONFIG_SFC_SRIOV
 	.info_get			= efx_devlink_info_get,
 	.port_function_hw_addr_get	= efx_devlink_port_addr_get,
+	.port_function_hw_addr_set	= efx_devlink_port_addr_set,
 #endif
 };
 
-- 
2.17.1

