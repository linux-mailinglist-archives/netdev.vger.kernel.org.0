Return-Path: <netdev+bounces-8187-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DDBC2723075
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 21:53:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 07EC31C20D42
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 19:53:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69A1A24EA4;
	Mon,  5 Jun 2023 19:53:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532FCDDC0
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 19:53:08 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2062b.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::62b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65906114;
	Mon,  5 Jun 2023 12:52:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M7YLiH/3udsMQ/MZJV8ipuIl+NeQ2KL9OLRwmHhiYLBK+ARncm8KOTLWbX6pzZZG1YDZGXWkp/eTyogW5dMmWThyf9MfkrD2Ye3fa9ojEPRSv51RYS9GXX9GEYtcnl3WAyCgLg8iwoH+y5iebSy0u7UiTQPrG1e87ols5ijD+BgKs3nPW9qF/iM3oy2iIzfPt7iALpeerIBNDafFZjBFoiUPr1lt0KmjUmeZq4Lz73PP8zEKO6DwTYBsgUA+HNUjqkqJgpHuWCwaZ8YjnTziZxXJ4sYX1RgBQNvrNEJa+n8SHtQMF/0nXIbb1vQnGVJfKpnSr4PbRD3x197lu3sBZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PS57z1YDT/rSbRtfU+HyKoF1fFoadofBNRItPhV9kFs=;
 b=PnetK79GJUQ9IPv5VjEy9kf2B8f1sG7jkRY+y9giHfVycYGFlECjxoqWoofRVTEnWiXyvEtkC5lcWW4ry9G1noUiJX4D4QkISWVHSwFEsaTYZ7p9bdigE/mm9fcIAVktABDN0kyXOxf+Ke1/XomK6gzHUvdEPfXxmFlAQk7bQeZlOJHNY7z3o07zb0f4XFTw/eonqC7eEevyIr+17Gm/jMcGOF6kZkaqRSO7Izn24lp+ZB5VKlq1JhZSKYRDpgu7YRtDMep9MsNjfSX8gpWRyGQZilf7n/c+L8jNrL0eKKShNGs6e4hltp2Qq5XORvSMXPcdoK6M7Kd/mW64UFKNeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PS57z1YDT/rSbRtfU+HyKoF1fFoadofBNRItPhV9kFs=;
 b=Q7eONPREDUC1iC2y0wCV+aLQjB2Z97WFfoHMYbJtwaFTDEYH5mp4lt42vf9JRX5TGqUDB4IXbOQV/Rvgzw3x8Y3uFDdbZBs98GgCW8I/7O5KCCn+sUrQEjUwDtbfzoyfhvAsOd4Lbreb4uoRvx+r7SU3KmqC20p6eiT+GCWlekY=
Received: from MW4PR03CA0130.namprd03.prod.outlook.com (2603:10b6:303:8c::15)
 by CH3PR12MB7668.namprd12.prod.outlook.com (2603:10b6:610:14d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Mon, 5 Jun
 2023 19:51:29 +0000
Received: from CO1NAM11FT067.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8c:cafe::6f) by MW4PR03CA0130.outlook.office365.com
 (2603:10b6:303:8c::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33 via Frontend
 Transport; Mon, 5 Jun 2023 19:51:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT067.mail.protection.outlook.com (10.13.174.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6455.33 via Frontend Transport; Mon, 5 Jun 2023 19:51:28 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 5 Jun
 2023 14:51:27 -0500
From: Brett Creeley <brett.creeley@amd.com>
To: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
	<pabeni@redhat.com>, <kuba@kernel.org>, <edumazet@google.com>,
	<davem@davemloft.net>
CC: <brett.creeley@amd.com>, <shannon.nelson@amd.com>
Subject: [PATCH net] pds_core: Fix FW recovery detection
Date: Mon, 5 Jun 2023 12:51:16 -0700
Message-ID: <20230605195116.49653-1-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT067:EE_|CH3PR12MB7668:EE_
X-MS-Office365-Filtering-Correlation-Id: a270227a-a686-4940-0411-08db65fe40fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	2ORwlz9qwJSrppxQ5yWbK8uqH2L45QYIfEqM54aag5L4fC4oiSUs602so5VW1RktpxkqjAjRkG/LawPDG0xFfCaj/iYGWdRTvbQfPvJ4wxrDGFjo/F1DuVZsa7C0/u3dN6nA/1QLIS3SEzxCxn7oAg0DkD5Q7oJ+XbA1kMl4jLSJ1AGirJhkvhIDdqVhBWb1BkKBjyN0bEMulx4EFhnuflol+be1vbMd7wA+MNexUKrYTX7ma4kFsMTCw1xDP9cLOGCcnCAJF3T54oH1hjvVVnx6dAkkxPpwSfa7nZopFB5vcbLOTamOAbXAHfajHdTY0q/yVAuUb2mU6Eu1yq6RI1cgoNFcZinUUsscELWM9/5LjY/L4g83p1VKrJjon1T0APS3o27Mzsd4NZ/VoF+tsX+1IyDybk1nXksDOHjjSeJGSc5a8d3yRX/qGQ1m2C58EfayOMAb5GCwVUSjSd830n9n+T/e8PoS810qUYANGE2QyUfJ0k4AkiNBXepgfSLScaKdbiaYpmFBHpdfsWeVZsfSdrFZ4ApUT1qbU8XugFvd/M8VT34tcypNNiLBUVPz8XJ4KjAI5t2xK+qxXkmaPWzk9DRDFaKTNnkcycXswDNF7z3i6KAiG8QadnGRXhKLt+L209xh7OssZtsz6evZOP+jbHpbGlmD0ArXy+bro5CSygtcT5PoQnDYSCwdZn8fry4fJ8b/QdXQ8zf6z/ffDnsYG6nlNwGA9Gel8Y4ySCSKwem1YAQPOtxCUx50olIGkwg0hVQNnEORK8gNRWrBfw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(396003)(39860400002)(346002)(451199021)(36840700001)(40470700004)(46966006)(36756003)(2906002)(86362001)(82310400005)(44832011)(5660300002)(40480700001)(40460700003)(47076005)(83380400001)(6666004)(16526019)(336012)(186003)(426003)(36860700001)(1076003)(26005)(356005)(81166007)(478600001)(82740400003)(110136005)(54906003)(70586007)(70206006)(316002)(4326008)(41300700001)(2616005)(8936002)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 19:51:28.8007
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a270227a-a686-4940-0411-08db65fe40fc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1NAM11FT067.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7668
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Commit 523847df1b37 ("pds_core: add devcmd device interfaces") included
initial support for FW recovery detection. Unfortunately, the ordering
in pdsc_is_fw_good() was incorrect, which was causing FW recovery to be
undetected by the driver. Fix this by making sure to update the cached
fw_status by calling pdsc_is_fw_running() before setting the local FW
gen.

Fixes: 523847df1b37 ("pds_core: add devcmd device interfaces")
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Signed-off-by: Brett Creeley <brett.creeley@amd.com>
---
 drivers/net/ethernet/amd/pds_core/dev.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amd/pds_core/dev.c b/drivers/net/ethernet/amd/pds_core/dev.c
index f7c597ea5daf..debe5216fe29 100644
--- a/drivers/net/ethernet/amd/pds_core/dev.c
+++ b/drivers/net/ethernet/amd/pds_core/dev.c
@@ -68,9 +68,15 @@ bool pdsc_is_fw_running(struct pdsc *pdsc)
 
 bool pdsc_is_fw_good(struct pdsc *pdsc)
 {
-	u8 gen = pdsc->fw_status & PDS_CORE_FW_STS_F_GENERATION;
+	bool fw_running = pdsc_is_fw_running(pdsc);
+	u8 gen;
 
-	return pdsc_is_fw_running(pdsc) && gen == pdsc->fw_generation;
+	/* Make sure to update the cached fw_status by calling
+	 * pdsc_is_fw_running() before getting the generation
+	 */
+	gen = pdsc->fw_status & PDS_CORE_FW_STS_F_GENERATION;
+
+	return fw_running && gen == pdsc->fw_generation;
 }
 
 static u8 pdsc_devcmd_status(struct pdsc *pdsc)
-- 
2.17.1


