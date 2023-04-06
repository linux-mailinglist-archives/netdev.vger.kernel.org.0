Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8466D9018
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 09:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236015AbjDFHFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 03:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236021AbjDFHFD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 03:05:03 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on20601.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eae::601])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C865A256;
        Thu,  6 Apr 2023 00:03:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IyShDh2iJu19aq8IctJgsiVq5pl8V1JQbOgqCKrRQJP+e0gXKoXkLjDToyOBA9bZ74khwfiQS/zhum0JKbvh6M2fF+8DYr7m/Qf/w4poLqwXoS4t6nfblA+iyBpC9wo16UvwJVuw2QTqLAE61aKybeN3QymPH+fY7HFy1SXob9ZtJMjZUf43EDruVrd7T6p+cQ2nv6fKj7PR+VHcq2Zknz1pUIUMY2PDF+wcdE0nGPRn84ab+zqG1ZbZBIt4YW8BUGMRlNzrsheHhKym2VLJa2eu837MIJED1hV6pmdkVTrfsSjYcE33fWWum2hIr2H9zO3Vkel6pxBCOydgYXGLwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TXI0FubCQwBWae+XMD4Nlu+libjQ2DiRRcLY1nUxpIs=;
 b=I795zcNxcl9Pe8VPXXUqpY9653dLkl6glEgjNB4c6q22+z0Ji+dUxDBrJQAqN9qBa/lYwaA7GQeiaAHT9j38bNodiAToIA9j+gngagrlufySE44i/GiW/LbEPqmPXBic1zZfF8siMcAdBqQcgNrFFnzldvJhCPfDABiEMWKUe+4qEqTfMAXjrXgLK3RbY4P5CcB+jcwp0DydrSH76ij8STB/c51w0TYZdT/hF5XjlcjSoVERchOmCIJyR5zG68vnD8BtFbpquU5s+WDaTd3I1gsexgbPcPVjReLjAWCWuSUaVknwNkvoTnStePsm/nV0Zu45ZylDCGiNmDBZHEeAeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TXI0FubCQwBWae+XMD4Nlu+libjQ2DiRRcLY1nUxpIs=;
 b=0BW66LuYCid6u/VTWjj9VkfC6R43sE+0fZ/dNRn/QRvMnBUOJPkuNN22q9AkDwnD/BAY0OC/CjcB+a7JHHxCdByQ3qGAtJoO8L4JlLzr8BMENijoSp4XcW0cxlTt9WivHaQAbA/qLbKx1trk/WVTNkjZF+3Vx1NkAY2dqcLLCWs=
Received: from MW4PR04CA0219.namprd04.prod.outlook.com (2603:10b6:303:87::14)
 by CY5PR12MB6177.namprd12.prod.outlook.com (2603:10b6:930:26::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Thu, 6 Apr
 2023 07:03:11 +0000
Received: from CO1NAM11FT102.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:87:cafe::6f) by MW4PR04CA0219.outlook.office365.com
 (2603:10b6:303:87::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35 via Frontend
 Transport; Thu, 6 Apr 2023 07:03:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT102.mail.protection.outlook.com (10.13.175.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6277.31 via Frontend Transport; Thu, 6 Apr 2023 07:03:11 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 6 Apr
 2023 02:03:05 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 6 Apr
 2023 02:02:55 -0500
Received: from xndengvm004102.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34
 via Frontend Transport; Thu, 6 Apr 2023 02:02:51 -0500
From:   Gautam Dawar <gautam.dawar@amd.com>
To:     <linux-net-drivers@amd.com>, <jasowang@redhat.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <eperezma@redhat.com>, <harpreet.anand@amd.com>,
        <tanuj.kamde@amd.com>, <koushik.dutta@amd.com>,
        Gautam Dawar <gautam.dawar@amd.com>
Subject: [PATCH net-next v3 13/14] sfc: update vdpa device MAC address
Date:   Thu, 6 Apr 2023 12:26:59 +0530
Message-ID: <20230406065706.59664-15-gautam.dawar@amd.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230406065706.59664-1-gautam.dawar@amd.com>
References: <20230406065706.59664-1-gautam.dawar@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT102:EE_|CY5PR12MB6177:EE_
X-MS-Office365-Filtering-Correlation-Id: 52ef074e-1819-47c8-4f49-08db366cfc26
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xC7JrJ+8888ikSdtk0/iKiAHRGKBd4PFGcav9ApFCQzknY0iuPBdOM98PK/r+i1d45qVXFFNNWcPz4YaW1C8f+R/6Llo6FtdXKTZbIgmdYKVrNMZFqJhIH52I+WfT6eC04uCQeAkCuvk/xNwhFDxHqF1R/f37W3t/MR4zjI4GrDV4QfOjXgOHtBisJSFwoPrSmBTcFxV9Ny/1GrFEbIZ19vlPolBJRFD3sgezhV19kneqzOuq21S0rOeXzs2n8ZwCkkq7Tt2+rPliiU1JBu3FCjMsgnzF5MXKR0DxUU26SLRETeOUgkH+SE2ODPGdu77Hi3NTASDsAh/Q9cs4/q+ad98YZRiAHk2DG/0E53Y5JQSXBrvnmGPGc/Jb+vGA2s4et07NppnycU8UNlr1jdO4+p5kpOhNOeXq81H7TUk8o1PvPbNNO1Oly+c9GNnHiJxBybmmkHn4SY8UydENnRBwTbdD8mh/uMfoKSCFlU+XnRrtvTKLbWEGvqDC+gBZP2li8deEct5BgfGFDouj33x4avz6DVe0eaKrIHH4m6Q6FL2GHpxF1QM0JHusg7Uy1+jiC6bDUc6lVFadoEYc9E9a/izKhpeuRJ9PcUvm0l/OsL5dQb9c7Keo1Xar9OSnA3Q1Zt+Jg6DnJhFt/LlFxqOkYe6nAxF8IodADk+FxfL+WoBr3rSkPSU+QLQOmE0y5CwcSbgj4xmT6fA8RdGz/vofxCuTptxhsc1e8eWoMiJYmhYlEDb5MhNo6MLBsQrAn9k
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(346002)(136003)(396003)(451199021)(36840700001)(40470700004)(46966006)(83380400001)(426003)(54906003)(36860700001)(2616005)(26005)(478600001)(186003)(316002)(1076003)(110136005)(44832011)(7416002)(5660300002)(15650500001)(40460700003)(921005)(81166007)(356005)(82310400005)(36756003)(70206006)(86362001)(70586007)(8676002)(41300700001)(2906002)(4326008)(82740400003)(8936002)(40480700001)(47076005)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2023 07:03:11.6231
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 52ef074e-1819-47c8-4f49-08db366cfc26
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT102.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6177
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As the VF MAC address can now be updated using `devlink port function set`
interface, fetch the vdpa device MAC address from the underlying VF during
vdpa device creation.

Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
---
 drivers/net/ethernet/sfc/ef100_vdpa.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.c b/drivers/net/ethernet/sfc/ef100_vdpa.c
index 15c00e898f64..a04bcae89b7b 100644
--- a/drivers/net/ethernet/sfc/ef100_vdpa.c
+++ b/drivers/net/ethernet/sfc/ef100_vdpa.c
@@ -277,6 +277,18 @@ static int get_net_config(struct ef100_vdpa_nic *vdpa_nic)
 	vdpa_nic->net_config.max_virtqueue_pairs =
 		cpu_to_efx_vdpa16(vdpa_nic, vdpa_nic->max_queue_pairs);
 
+	rc = ef100_get_mac_address(efx, vdpa_nic->mac_address,
+				   efx->client_id, true);
+	if (rc) {
+		dev_err(&vdpa_nic->vdpa_dev.dev,
+			"%s: Get MAC for vf:%u failed:%d\n", __func__,
+			vdpa_nic->vf_index, rc);
+		return rc;
+	}
+
+	if (is_valid_ether_addr(vdpa_nic->mac_address))
+		vdpa_nic->mac_configured = true;
+
 	rc = efx_vdpa_get_mtu(efx, &mtu);
 	if (rc) {
 		dev_err(&vdpa_nic->vdpa_dev.dev,
-- 
2.30.1

