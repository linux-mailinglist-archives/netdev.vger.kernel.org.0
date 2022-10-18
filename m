Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8330660285B
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 11:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbiJRJ3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 05:29:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbiJRJ3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 05:29:18 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2075.outbound.protection.outlook.com [40.107.223.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4940FACA0E
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 02:29:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CrZi9ef6JWaAQSrFPAE9F8a2y7wJctXLZAWul3vFK59wmV3iQPQNj7B8OOJg1hmLhseJVH3KX19+LyAnM1f+QwScbMZgdo8OKN+qtgOjD3PnK+t7zyi1AAHhRXcoRL7RlXZBMi3NVuZ1TPDUlnTDbwUt4kbr90lZuKB7irV7lqCsfE2RIoRt7HWylw4/IClhuKjGTx4S9+EYLW4FTffwNmUcGMSRiHdnyVbIcRLQB8o9E3KIdW9QS22FqVf5NPhHlTsK5fxYCLLpn9hOC+upGiUIoSqI+aFGQIko79H0CrDMICNuOC8+VXkLoUXgUYUHdybTH4vGnmOREJHoKnUvFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kREAOCkXOuP+JfIsuZmaTZLZcsUTUI5rANRuoSoOpN0=;
 b=ffkLKNNrih81wunoFrSM3wJXi2LRfLpmAspkyPQZqKv4sX4ACWaNCvh6m7s7RqJaml8hZoZ0jRLM1SR+ujFRcdEmI7oVJmzBGbKVL4GYAbBKsohCGbwgTzc1XFxIL1uocECeCAy0U12HilbdHdy4dQYBehHutqZ//tr9ml1ea+CoSliSM/VMfADs/aWVc/OxNl8gM6XVDjapI1OzhKhLN0lEZG/erGuH+aF1xqCyPDsvAMlzV2VhCuMZiZyx9AG6OmWhx/JhvhmJc0/dNMFIagfSkqK/3EEMkAecWualLG9Z2DI2lv80MonPge1u3mYjW6CQZWI0KbqOVLRG+7XfoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kREAOCkXOuP+JfIsuZmaTZLZcsUTUI5rANRuoSoOpN0=;
 b=bGRoesE78h5yxK/TsoS9EsCifUoXjD8o2jei9wqvYdL0vXbpBHxAO56PHzhWGhb3U+aM/RyyyExsb9lssGftu1fQxmjIggxMS8CX/4fq+HIE4teGNZvY2EBr1038mHiuMapUynLLjIvltT0ARxwr/Trf8U85AKJYpaFmcMBNpZc=
Received: from BN9PR03CA0754.namprd03.prod.outlook.com (2603:10b6:408:13a::9)
 by DM6PR12MB5021.namprd12.prod.outlook.com (2603:10b6:5:208::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.33; Tue, 18 Oct
 2022 09:29:15 +0000
Received: from BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13a:cafe::ae) by BN9PR03CA0754.outlook.office365.com
 (2603:10b6:408:13a::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.31 via Frontend
 Transport; Tue, 18 Oct 2022 09:29:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT064.mail.protection.outlook.com (10.13.176.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5723.20 via Frontend Transport; Tue, 18 Oct 2022 09:29:15 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 18 Oct
 2022 04:29:14 -0500
Received: from xcbpieterj41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31 via Frontend
 Transport; Tue, 18 Oct 2022 04:29:13 -0500
From:   <pieter.jansen-van-vuuren@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <ecree.xilinx@gmail.com>,
        <habetsm.xilinx@gmail.com>,
        Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
Subject: [PATCH net] sfc: include vport_id in filter spec hash and equal()
Date:   Tue, 18 Oct 2022 10:28:41 +0100
Message-ID: <20221018092841.32206-1-pieter.jansen-van-vuuren@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT064:EE_|DM6PR12MB5021:EE_
X-MS-Office365-Filtering-Correlation-Id: fe2d36c6-6c9d-42b5-f796-08dab0eb396d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dmrxzmam372pFm0QeizPM+hiRzyGYI0UucFHGH4Z8WfhG+uHmqMReiYG5MGmXJqi2rk+HYJrxINRVCiD/VuFHQcUDvjpm0u/IPo1seqelXceAOadog9+XIW0McEW2X79e/5lKNtGEGWj03VfDVKoGTf4dzh+wY04JAJYm+NgzaeBSPLvSLr0hACmLCHxV9gvZFpR8s7L8J5sFBFrOD86A68JfzRR/O29SrTBXiClLs7OOYKQnM8VgYFEbqReM/Fa4KNVZcwJnZkmhqxiAYmABorxnvYXUXJkUz/kzWaUJeu15jV1lxtPo3AxEGYE2tqqSveV6O/0+7uVQy7DhZOtHn/vQbPeR1yIX6uBRlX/YhoIrntK2c3R3Dd+Bj8LvTe6mFvgb5iEpdowHA68e8kvQ1hCBD+iMGjXZ1xHMnni5SdHujfvynyOEkff/8hrXINJt/frRJjM17NhOv3Jl03QEPLoEUw9wOTbD+cI/cRzOsz+4WZGXKAoL2l0x86lUjg6O4EUszfR+0yBb32RAbeFXXVNrqvlkfFcvI0rDmMcs5x8BWBujUvwSCJGumj15EPOSXug6FvHJ9+Ua225tW2yDpoidxHIjCgBl9dNRGkKSDyDBXSlUW/a36IyifnIu1S1cwiFUC2gAnffJ7fFvGlqefgkQBGzxobmfBJeSNpJ40L3lV6MvYJ3nbfL/Mmi4FKzd+LI0EhfaeM/3Mytr8jzvwmcLtDFU210YQsiun6TJbNfmXsz37oi5GGB1Wbm53gycAZ3kRwdutYUBGJFUrc0CqdoCJv42W01VoUWfNsL4og=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(376002)(346002)(396003)(451199015)(36840700001)(40470700004)(46966006)(5660300002)(8936002)(2906002)(8676002)(4326008)(41300700001)(2876002)(40460700003)(36756003)(356005)(81166007)(86362001)(82740400003)(26005)(110136005)(6636002)(336012)(2616005)(1076003)(186003)(54906003)(82310400005)(6666004)(478600001)(36860700001)(70586007)(70206006)(40480700001)(426003)(316002)(47076005)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 09:29:15.3032
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fe2d36c6-6c9d-42b5-f796-08dab0eb396d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5021
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>

Filters on different vports are qualified by different implicit MACs and/or
VLANs, so shouldn't be considered equal even if their other match fields
are identical.

Fixes: 7c460d9be610 ("sfc: Extend and abstract efx_filter_spec to cover Huntington/EF10")
Co-developed-by: Edward Cree <ecree.xilinx@gmail.com>
Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
Signed-off-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
Reviewed-by: Martin Habets <habetsm.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/filter.h    |  4 ++--
 drivers/net/ethernet/sfc/rx_common.c | 10 +++++-----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/sfc/filter.h b/drivers/net/ethernet/sfc/filter.h
index be72e71da027..5f201a547e5b 100644
--- a/drivers/net/ethernet/sfc/filter.h
+++ b/drivers/net/ethernet/sfc/filter.h
@@ -162,9 +162,9 @@ struct efx_filter_spec {
 	u32	priority:2;
 	u32	flags:6;
 	u32	dmaq_id:12;
-	u32	vport_id;
 	u32	rss_context;
-	__be16	outer_vid __aligned(4); /* allow jhash2() of match values */
+	u32	vport_id;
+	__be16	outer_vid;
 	__be16	inner_vid;
 	u8	loc_mac[ETH_ALEN];
 	u8	rem_mac[ETH_ALEN];
diff --git a/drivers/net/ethernet/sfc/rx_common.c b/drivers/net/ethernet/sfc/rx_common.c
index 4826e6a7e4ce..9220afeddee8 100644
--- a/drivers/net/ethernet/sfc/rx_common.c
+++ b/drivers/net/ethernet/sfc/rx_common.c
@@ -660,17 +660,17 @@ bool efx_filter_spec_equal(const struct efx_filter_spec *left,
 	     (EFX_FILTER_FLAG_RX | EFX_FILTER_FLAG_TX)))
 		return false;
 
-	return memcmp(&left->outer_vid, &right->outer_vid,
+	return memcmp(&left->vport_id, &right->vport_id,
 		      sizeof(struct efx_filter_spec) -
-		      offsetof(struct efx_filter_spec, outer_vid)) == 0;
+		      offsetof(struct efx_filter_spec, vport_id)) == 0;
 }
 
 u32 efx_filter_spec_hash(const struct efx_filter_spec *spec)
 {
-	BUILD_BUG_ON(offsetof(struct efx_filter_spec, outer_vid) & 3);
-	return jhash2((const u32 *)&spec->outer_vid,
+	BUILD_BUG_ON(offsetof(struct efx_filter_spec, vport_id) & 3);
+	return jhash2((const u32 *)&spec->vport_id,
 		      (sizeof(struct efx_filter_spec) -
-		       offsetof(struct efx_filter_spec, outer_vid)) / 4,
+		       offsetof(struct efx_filter_spec, vport_id)) / 4,
 		      0);
 }
 
-- 
2.25.1

