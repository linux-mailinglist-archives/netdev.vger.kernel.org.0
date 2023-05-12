Return-Path: <netdev+bounces-2218-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F54F700C00
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 17:36:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 327031C213A7
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 15:36:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBF3114276;
	Fri, 12 May 2023 15:36:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C84F02412F
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 15:36:39 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8904E12A
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 08:36:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fzM6+N5GlP2tHiIQat0gFAIAip8s3Y+1ar4bhvxvM9upo4/GzgOgq8nvP4icTf5BK+gHBJLrfQidC1tpIFIqW/tTnYUY1Kcgkm9UfMef2Z3L9SQBpsvrdbQvBLgfWFPfe6YsBDvcVchbJNv297lEvCBM57+mRaXfuMrs04gSBdmzHiEoB3C08subN7izs0fRh1JXJraJPsUPS5u0qRWzTwkp5S2M53BM/jQLDo2+24wnxraPSardspPcFiPNIEOqDeqRXP3mOBTRUWSAJv2hrFq7DSjzU0B16vgbKpgzW9AWZYvj6/+EFLyGpX51hsULwiTyf+WJ6AowqHcp6pLxLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1vw8y7bdjR4LaNVycLsUqGury60aVMspHfg43h0fw+g=;
 b=X5uip5lhfjkiCwq44M1mxjn/m3Mz+uFjoTjxSbyUik2tapzbmWLnrG2FOOy7hLCEep+XGHNaZ2D2orwNGm3EnusyD2q+mkQESloTV2Q05gMS6xL8om4p4AsL7wUx1OpdWzCinjVi2CANYN3Pjn1RTPOuwkHykp5SVQSvwLrElQ7PBy95tpx8L2lZM0LJZMe64nWkexetKM4gdwCt3S87WA5MSemvWj2Z91OHcOfG//fezXyLiZikM0+9iNG6oA6sPwYtxPNRKFS5ehkW+MapRmo0HBADNhs1j1irDMho/238uDX0ySb1ijXPfG77N9bLYAXYxBBgLFZjC83P+9uJ/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=temperror (sender ip
 is 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=temperror action=none header.from=amd.com; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1vw8y7bdjR4LaNVycLsUqGury60aVMspHfg43h0fw+g=;
 b=W6emIPcsfYQFoh7us4VirCt7L8JeGLtp+w+EYcAqo4kKIgGv/yf4qjAEx4Gtnt8pUeenj1iAasQ5IOrQNyXzzuizrgTMO5/Fpcr8fCaxVoRU1cMX2j0f9ITGA2yqMhQckRIb/O2uc1gWFvugl3RzuDUzkurrLCV3K6KMGUzZWXc=
Received: from MW3PR06CA0015.namprd06.prod.outlook.com (2603:10b6:303:2a::20)
 by CH2PR12MB4956.namprd12.prod.outlook.com (2603:10b6:610:69::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.23; Fri, 12 May
 2023 15:36:29 +0000
Received: from CO1NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2a:cafe::d3) by MW3PR06CA0015.outlook.office365.com
 (2603:10b6:303:2a::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.24 via Frontend
 Transport; Fri, 12 May 2023 15:36:23 +0000
X-MS-Exchange-Authentication-Results: spf=temperror (sender IP is
 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=temperror action=none header.from=amd.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of amd.com: DNS Timeout)
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT054.mail.protection.outlook.com (10.13.174.70) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6387.25 via Frontend Transport; Fri, 12 May 2023 15:36:21 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 12 May
 2023 10:36:20 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 12 May
 2023 10:36:20 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Fri, 12 May 2023 10:36:19 -0500
From: <edward.cree@amd.com>
To: <linux-net-drivers@amd.com>, <davem@davemloft.net>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <edumazet@google.com>
CC: Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
	<habetsm.xilinx@gmail.com>, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next] sfc: fix use-after-free in efx_tc_flower_record_encap_match()
Date: Fri, 12 May 2023 16:35:58 +0100
Message-ID: <20230512153558.15025-1-edward.cree@amd.com>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT054:EE_|CH2PR12MB4956:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b0cbb09-013a-4324-087a-08db52fea345
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	XB8NJc8aUQASMj1tXdiVcarNprvpw/rd+2Mb8bSkx/2Lk5mFXQgo69U7wDz2wVESRZ5KvB1iC2pwsXGwkRuXw4h4p5qOWNGBFBy3rIUKApwfxT5shYhx7rth26sxywKDktafLX4N3dtvw9cA7Q8vqECEZiqYDF9UOTAfVR4UE3jisvrC4pKei6jDwYdvLRbS081i7QgvDIjGwBtTxYiRrI8KOrwj5HGoTtzdcH7nUjeUGu/a3qZgAWtMWxuVEpeUpE+NfdxQuzzbZFHvAH54kZe7XDpduuXyDm2+bBmHdQau/9mfKE+Mgp9ItcPHqSpSYDC0vysQht5uiPy++ivNzdz8o0BJ7eyYa/DFOarAWy5hfUxsll2VdS5VPXa+8lPMtBsAtfmNiB8MGW4ZEGbbDkV8HmJzbetiESHN5RHk1Z1ZWxdU6AQNIjGgEtggenVZ6FvkVhm/4UCF+E9znAakseqRLDwfR7UfZFM8iFGvU1eWyH9BBec85d8ceiOoceU2nPXenPR4YiDycRMATi+J9hb87Hq2jRgx1KIilGFCXoQTEThCUdFr5lPjWc7qESqMHBeiv5QeYihHtne83aRui0QPdbdlDpIuWLE/4Ip1LyCRxcg41lnJLGTCXZJoZXph/RqlsxzDa2Du96C9MMNnQezCyDIyureaoeUiowk3Egcst1F4FcQvul7sWhphmXaqghvCpAD5PAP1zsM+5Gah/26rBolGS9LV0YEmVVM3eZlHCBi55fq9tPhJUsWBeF2B3yLorgzRsnq6LheDGoH9cw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(396003)(39860400002)(346002)(451199021)(36840700001)(46966006)(40470700004)(81166007)(356005)(82740400003)(40480700001)(36756003)(40460700003)(86362001)(82310400005)(5660300002)(8936002)(8676002)(1076003)(2876002)(2616005)(186003)(26005)(70206006)(2906002)(70586007)(54906003)(110136005)(478600001)(6666004)(4326008)(316002)(41300700001)(36860700001)(63350400001)(47076005)(336012)(426003)(63370400001)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2023 15:36:21.6032
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b0cbb09-013a-4324-087a-08db52fea345
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4956
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Edward Cree <ecree.xilinx@gmail.com>

When writing error messages to extack for pseudo collisions, we can't
 use encap->type as encap has already been freed.  Fortunately the
 same value is stored in local variable em_type, so use that instead.

Fixes: 3c9561c0a5b9 ("sfc: support TC decap rules matching on enc_ip_tos")
Reported-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/tc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/tc.c b/drivers/net/ethernet/sfc/tc.c
index da684b4b7211..6dfbdb39f2fe 100644
--- a/drivers/net/ethernet/sfc/tc.c
+++ b/drivers/net/ethernet/sfc/tc.c
@@ -504,7 +504,7 @@ static int efx_tc_flower_record_encap_match(struct efx_nic *efx,
 			if (em_type != EFX_TC_EM_PSEUDO_MASK) {
 				NL_SET_ERR_MSG_FMT_MOD(extack,
 						       "%s encap match conflicts with existing pseudo(MASK) entry",
-						       encap->type ? "Pseudo" : "Direct");
+						       em_type ? "Pseudo" : "Direct");
 				return -EEXIST;
 			}
 			if (child_ip_tos_mask != old->child_ip_tos_mask) {
@@ -525,7 +525,7 @@ static int efx_tc_flower_record_encap_match(struct efx_nic *efx,
 		default: /* Unrecognised pseudo-type.  Just say no */
 			NL_SET_ERR_MSG_FMT_MOD(extack,
 					       "%s encap match conflicts with existing pseudo(%d) entry",
-					       encap->type ? "Pseudo" : "Direct",
+					       em_type ? "Pseudo" : "Direct",
 					       old->type);
 			return -EEXIST;
 		}

