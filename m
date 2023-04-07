Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7C16DA9EB
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 10:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239797AbjDGIPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 04:15:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240224AbjDGIOm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 04:14:42 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2078.outbound.protection.outlook.com [40.107.93.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A4B7B77F;
        Fri,  7 Apr 2023 01:14:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PukZLGxAKiiwYZZX6lOw0AsfNOhsK1gCnZsnOH3dDHTs8gAOzMXJOIL9WFvDOgq22xuGNEi+m6bPz3PwKA0XpJeufPHKeqMpJ4HpqPeUcVOD1RgvDOJ/46/xrHcRN0MlPvBUVUhrSsSE1rL2SA3cgvwEtbiomdxzKf8W3dAzfcMw4RtgDfURGSrl7n+a5blliRlaaB43Ar0xZRV3cKSV9ZLdGJs+TfxiBZIRRhjPytRbtPJdJZfEZE0lrcfgjmCJbN71Fg5syoxay3XEfT/bqWVFYqbQr1fOiqfmXY9LKUPuns/1l2NXPlhhD06GrUnlxUdLfafLbZpxmSqYgZkSFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MmjK3nYj/FHsFJ2tAk8z5wJawjcRuxgdcS5bUmxlS/M=;
 b=kQETgJqJGnwCBBp8MSIi/UmxsyUHCLTDscYA1Zj6Z9L68Njud2cU4k9An/LndLf50Rl9A6bxFmowafiQ7l+iSBdwHJVeyJZf3EJHBVLb7qGm6CMWrtwdV0sa0G66SJuC9z3GCrVmlWBA2uUL5fkpTpkX32mwt/Op2wFc/ETLB/iMzLfr1EBKs809gNjw78mo1AlDj36JvegnQikMYWJKdE9de1fwpZLc/AHzm8Xho94Jo0hMwtfqoGyXaAWhaH9PSTFHQyhBkEiEDfhrjkFS+sA4LrIq5+ey4A1efLmY1eQPVpD3qthZaTrBvzdj3z2O9YAg8tyIhP2JM/UV830B6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MmjK3nYj/FHsFJ2tAk8z5wJawjcRuxgdcS5bUmxlS/M=;
 b=sLEuKLNw9XnLlMV7yVkPztJavlncDUDFT08ZhEgFpd419sVz04doc/c96dTD9/te2iSF3/y9lz7LtfhSkhScwamaMT9eYp9uOWEG64MZRUY0UiOx1pa+sR3uxccPC+13ccS/XfBqWHKB0F+TCc78XDjfuU+rrjLMz5fSr8Kn7Mw=
Received: from DS7PR05CA0099.namprd05.prod.outlook.com (2603:10b6:8:56::20) by
 CYYPR12MB8923.namprd12.prod.outlook.com (2603:10b6:930:bc::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6277.31; Fri, 7 Apr 2023 08:12:58 +0000
Received: from CY4PEPF0000B8E8.namprd05.prod.outlook.com
 (2603:10b6:8:56:cafe::8c) by DS7PR05CA0099.outlook.office365.com
 (2603:10b6:8:56::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.14 via Frontend
 Transport; Fri, 7 Apr 2023 08:12:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CY4PEPF0000B8E8.mail.protection.outlook.com (10.167.241.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6298.8 via Frontend Transport; Fri, 7 Apr 2023 08:12:58 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 7 Apr
 2023 03:12:57 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 7 Apr
 2023 01:12:57 -0700
Received: from xndengvm004102.xilinx.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34
 via Frontend Transport; Fri, 7 Apr 2023 03:12:53 -0500
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
Subject: [PATCH net-next v4 13/14] sfc: update vdpa device MAC address
Date:   Fri, 7 Apr 2023 13:40:14 +0530
Message-ID: <20230407081021.30952-14-gautam.dawar@amd.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230407081021.30952-1-gautam.dawar@amd.com>
References: <20230407081021.30952-1-gautam.dawar@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000B8E8:EE_|CYYPR12MB8923:EE_
X-MS-Office365-Filtering-Correlation-Id: eb4730c0-5add-431d-d794-08db373fe61f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6bjHkHfqc8KsGRRMMH7plblA5VYCZXdVlbTXQMYcM11lnX4cVs3ZVtSLhEV8YKvj7qyPx3xQdZR/hD18Q57NfHaIAL7nImVQKcwTWvJTTuo/Bg2yMNL8vm+HrhPyN5jANIBrX+VsiCjl9zSB1dkaktajBt1T8+DM3EAhrSdaas3shGqlBOPpQp6oTA17GrNIPXpJQP9kEVevMdO+EG2chwOvDKG8CKpjf1IQQGtZwMRNfMOrSRdPs/moqdBVcKJoUNj3DXif460oBF3FEDD8qBXkL2jVa4UcZsF5mzhhy5cTOq0kKYSSAhMR6LxD0HMzpwHINvpZOPVH3eSjCxpbDjZLtTFMkaSK7qZA9QIuMihRw0UvP255JCGogGHd1TS3kudZbs+Qo2cu9KECBdaXGrHle/BFjQUj3yyiYYDEACr8wXllWOT40h/F6WRxEasMIbzX9d13KdunaJWL3kiRlbLlvP4LhRASYubrngerHo1nmd8ZEWt+DlydFFSiROuDhCqVjzLRJea5iE5Y3U2ddPfcxLmQNYDxBd7yZnkFH3ARQ3o3nqqZI2Gd1OS+Elp4kmok50+8k8EsWaOMmBQu7p+Rox45XqQbb1CGhY3OX6Vl4QuMtqveeu3lKEGjThVT2xnV/qqaTtQFx9BX9fCmducedDOVpT9J4jWDe/K7j/6acUffMwDWaD3eEB8HHzIQVzeJ15TlTmn7G7/MfEW9IOAQgVIY5nzSIMBGh3kd6/hnkkUzIZ65BJ3TMhyUUUU1
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(396003)(136003)(376002)(451199021)(46966006)(36840700001)(40470700004)(110136005)(316002)(54906003)(70206006)(7416002)(70586007)(8676002)(4326008)(82740400003)(8936002)(2906002)(5660300002)(336012)(2616005)(426003)(6666004)(15650500001)(478600001)(186003)(47076005)(83380400001)(81166007)(36860700001)(921005)(41300700001)(356005)(82310400005)(1076003)(86362001)(40480700001)(36756003)(26005)(44832011)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2023 08:12:58.5433
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eb4730c0-5add-431d-d794-08db373fe61f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000B8E8.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8923
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
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
index f8a273a4d221..1aa7dec6c8b3 100644
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

