Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53D0F6ADDD1
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 12:44:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbjCGLo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 06:44:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230491AbjCGLoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 06:44:03 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2052.outbound.protection.outlook.com [40.107.243.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF3BC7B111;
        Tue,  7 Mar 2023 03:41:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JwMQfnTHncu4Sle7Yy3jdr/r7sOZ1n0NdebMHmbU24G0wL2OS27RtSPmLz9eKSjyW2IGQ0leIzU6H9GOd4lyLSxhz7NV9ZOtZ6Xs/68p527j2KPrIlkxhpEVANtkjaZAvI22oIe5VichIvZfeWD9LTzoStDjSyiOpmWl5A3mGdDCZWYUTvgYqOTAq6GXVOZK1++qam43Lus0+REPuGbAndGqMrj342Mk9iLul1XetZnf3lEl6Zfk0z82jUNWZ7F7jl7rik/Etr8sc5DpY/FQHpK5aLSHAfMecgVRPc/BzP+rFjHiI1cI08es6wSGYlIVZIAUvi9/tH7TujJN2vHgOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XbTI5WWRnak4xyvBv4kSk9drUz9CD4h2fVxbIOw+m3o=;
 b=THD3HSmSTxvgNyaWbvPh2Lsc6p/z197Mi4FQ208I7gG5exa393gkm26XtoVXmzDN8c1r321y1HYK3sjWzAdNn896cQrhDiycMOUugnnEGYLW8MmNB9oElzFeiDC9CtFcfwks/2H4QswV7nboffOGaWwwraHvblEN2pScoUUHWnRm25pNmY5JIkuLpLrHksBCruOTWmKotSxNBwxlMVQj/HwFA9FQukw//LA4RU3tAfapc3i6ZdgoP5EWu1PWPssRbjoJjMtIlk+mRrZEaH/qBoDr/MQs/rCoyqL2KxYXcyQUbTGgr8iSj0gpeJLZfAmtWmhsV/mmV0PaAqni/IeDJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XbTI5WWRnak4xyvBv4kSk9drUz9CD4h2fVxbIOw+m3o=;
 b=pl0ItYhuXYcHqsi7ITFH6eIcDdx15sq41GEbQigG+HotZSaWiDorSb2Z3tZom3z3BcQ1ZFfG0j0pM+7bm/BtXDPXyKkohcycOTCUu3mg5LhuKQy1hGMUABWVt+v1uLxxujHhotBB9MtWv4S6m9IwJc81ad9xmWCmYo94EoBaRZM=
Received: from BN9PR03CA0639.namprd03.prod.outlook.com (2603:10b6:408:13b::14)
 by SA3PR12MB8809.namprd12.prod.outlook.com (2603:10b6:806:31f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Tue, 7 Mar
 2023 11:38:34 +0000
Received: from BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13b:cafe::23) by BN9PR03CA0639.outlook.office365.com
 (2603:10b6:408:13b::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29 via Frontend
 Transport; Tue, 7 Mar 2023 11:38:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT064.mail.protection.outlook.com (10.13.176.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.16 via Frontend Transport; Tue, 7 Mar 2023 11:38:34 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 7 Mar
 2023 05:38:29 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 7 Mar
 2023 03:38:29 -0800
Received: from xndengvm004102.xilinx.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34
 via Frontend Transport; Tue, 7 Mar 2023 05:38:25 -0600
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
Subject: [PATCH net-next v2 13/14] sfc: update vdpa device MAC address
Date:   Tue, 7 Mar 2023 17:06:15 +0530
Message-ID: <20230307113621.64153-14-gautam.dawar@amd.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230307113621.64153-1-gautam.dawar@amd.com>
References: <20230307113621.64153-1-gautam.dawar@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT064:EE_|SA3PR12MB8809:EE_
X-MS-Office365-Filtering-Correlation-Id: b282e306-8fa3-4360-65a3-08db1f007c1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zVJ6JbqwXibPkyeZBrPMUCeqAd6Q3kXnWRQvpKlUfwK1EQ7Vdq+S4/at8y00MzQ1YW+j9PXu5qkF4JE8/8gyOQDsEYtTkJuJHxq1zYHOzWkCwsqumG8b2Uyr1Drw+nJSv4mMGIA6iu9vuNUZXPbPHPWkXz1oBE5NVuZLRwpx2W4xjKOwF+Z1iz52GahDtqUF2G3KioKzps1ay5UvfPcpKqv+X6+cxFyjdTyabIUnFST/z7/q26qcq/gAZC2/PIF764fp5CMsVfVNsJzYp3OF6gZM8Nm7kFrf2WzWcKLjq8jb4nqngvy8ImEZ1J6XSDbe4h9utGm0dr9xWXcqbEoJsKDNFYDf/YWF/J9uD1Z34wUX1iWjaxfYZL1DeA7nMJDWNjgTQVQer9xLZgY7nUKXd8Q0l8TnY2SGBeKot0ygxoJ8L6QT85hrEECNSgM+MDtqzsnTuMyNLYdAvX5JsEcTeaEPBwgrmwx8ifgvIi4VOc0qbqsAsC7oTsfld9FnoqcHh/raTFsyIlkdRuFnWHO/x5pdCYwTwp8q6Z5C8svfbDwv0ghpufhw1+i3nMr6XMmM8XIymM42ifxqoAjtRSVA50UXvv00tKTl7/Pqc26hw3bmujMeCqHTxauUlUeXeFU4TMqTRzBmSKziyYz9xx50fO7UbA3zwk964UprlljrA18iu0E0Mbxtgfvy2yCOLbnI6i8cQeE/9hR3aBcri0Twn8e3/ZcLTu63pfOxrMynVHY1vRQbpZbUDKf/6HvfJsDM
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(136003)(396003)(346002)(451199018)(36840700001)(40470700004)(46966006)(8676002)(8936002)(36756003)(40480700001)(70586007)(70206006)(4326008)(41300700001)(15650500001)(5660300002)(7416002)(44832011)(2906002)(82740400003)(81166007)(921005)(356005)(86362001)(36860700001)(1076003)(26005)(6666004)(316002)(478600001)(110136005)(54906003)(82310400005)(426003)(83380400001)(47076005)(336012)(2616005)(40460700003)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 11:38:34.5219
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b282e306-8fa3-4360-65a3-08db1f007c1b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8809
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
index 30ca4ab00175..32182a01f6a5 100644
--- a/drivers/net/ethernet/sfc/ef100_vdpa.c
+++ b/drivers/net/ethernet/sfc/ef100_vdpa.c
@@ -272,6 +272,18 @@ static int get_net_config(struct ef100_vdpa_nic *vdpa_nic)
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

