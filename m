Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E21116CFA94
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 07:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbjC3FIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 01:08:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbjC3FIi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 01:08:38 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2061.outbound.protection.outlook.com [40.107.92.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A485266;
        Wed, 29 Mar 2023 22:08:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O+9M8TPdW4yVe3vRGfUjbQ8FiYon62KTFDMHw8clCvJWhNYjV+NUJcWR590gG8vEs87xh4aKMtI4Dwuvt0woI/zswa1TZV1c7ocZ3QHgg+VDTuF+YIn4sTUpaQNtFWVCv5SKruYTzRwsHQa5iqtJdzsH9aE5CcA3Y2vrCGY7YXQNhcCM5PK9MDH3yNspT3A+JLtRpFexcQojzbjMOQqeFmpf2uoiqt1cVXq67CUChNutOV8fZK9JLl3VSSrxSUwcaU4cVfeeQ7kzRtinciJF4foN6EUO/ZcUetM+QrK32PcU9aLdlnPnQb4Mp4Muj81oGw5RiF+uASYho626YxqlVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5kvfvhMmBCpP0T+woqtHZssw0rNJLMHpPhpjh5m9wig=;
 b=UQxRrGl0Xn2f1Tueov7h7tso+mtBJeXfRJFR4v975dFmaPI4OZmUDmR57p5BcnQXqW9dXxMpy0FC4GxC3FFk4DbOU6SNKPWazJHZvhmNWzY22LUO6g/8fytxNMjFJ5mQ6NalYD7dQaJYcnByndzHnoG8hNPJFVTkzwYzIsUz12L1mESPjsuE749kY8krKdmkM9kD1S3fmehqq5wtnvhva0M1GdwEVdHExwaaoFSPlnHY230L6b9ZMlfsKk0LjPI7LqFVXAnh+GWA13uEThsh9SG603jPcFGjisyRLxMTva2o6cLeJWozubvyrUxwW+WQRaeiJnfeMgVQn89UMXg4Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=microchip.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5kvfvhMmBCpP0T+woqtHZssw0rNJLMHpPhpjh5m9wig=;
 b=434ZM8706bVYVRhvmojznh6NWoOtPAHQBeg1vgL/VyGJiwfUzOs1Zik7rGB1DyryF8FkD3ctzoRuEoElHqZYMze+0qdDTrU1XeP+zH+0jnFopY5qlTMxRI6Jd2jkfWelVzgvuHXvMzSOyjukk2GZsVKlzF5n9ITTJjOfDUrCBb0=
Received: from BN9PR03CA0135.namprd03.prod.outlook.com (2603:10b6:408:fe::20)
 by IA1PR12MB8077.namprd12.prod.outlook.com (2603:10b6:208:3f4::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.30; Thu, 30 Mar
 2023 05:08:30 +0000
Received: from BN8NAM11FT091.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fe:cafe::d9) by BN9PR03CA0135.outlook.office365.com
 (2603:10b6:408:fe::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.20 via Frontend
 Transport; Thu, 30 Mar 2023 05:08:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT091.mail.protection.outlook.com (10.13.176.134) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6254.22 via Frontend Transport; Thu, 30 Mar 2023 05:08:30 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 30 Mar
 2023 00:08:29 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 30 Mar
 2023 00:08:29 -0500
Received: from xhdharinik40.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Thu, 30 Mar 2023 00:08:26 -0500
From:   Harini Katakam <harini.katakam@amd.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <richardcochran@gmail.com>, <claudiu.beznea@microchip.com>,
        <andrei.pistirica@microchip.com>, <kuba@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@amd.com>, <harinikatakamlinux@gmail.com>,
        <harini.katakam@amd.com>
Subject: [PATCH net-next v4 3/3] net: macb: Optimize reading HW timestamp
Date:   Thu, 30 Mar 2023 10:38:09 +0530
Message-ID: <20230330050809.19180-4-harini.katakam@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230330050809.19180-1-harini.katakam@amd.com>
References: <20230330050809.19180-1-harini.katakam@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT091:EE_|IA1PR12MB8077:EE_
X-MS-Office365-Filtering-Correlation-Id: 4cb14454-f9ed-46f0-3c14-08db30dccda3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r0IhKUV3F2u0zqlW3gmzQjTO3V5EQNyXSEAqb4UoHk0QrP4ZXRaEuUPtfgb6pF0hp8ELfSP6tbxv48Txd2Pvip9P8ALcn3iDZO09RNqdDvLRve0H09o+q5zx1Ct/HZTx7AneFfvxfDWbcYBRuzsV93ofBP89U9XZ3O1jcNk+5ubplpdl992EzOSLP0TiHEg0UuNHbJHxNwhUoEnJPjnSdrfuY/rNm6rDBWQvTJLSdp21LxTTt21MaGN3ggSEuho0Xrfu7CDg+DcJTmClXpB44SxodNWW+qVTdJiyU+YEMK8hVUo2bVDsCn2nExvBYi9VCegARt0o/NdAsI3q0fCTLbzmyOG/faOv31czXvCklrl4KFvHQIcAvRi17TP0uoDIdY4JAePpaN+l1BuHdBUFuqtBRfDb9m2VfKTG1nAypJu+FWnB0dpdxIUIZ/ScGQNzjaYPAXCnxWIPOeKYSrj+657Nj4hCjzQ6kipXFnVQ9QFk0JZKpIvHStiylzrunbwssVJfGqEX/Y/PChWR7z3G1v4DsSc/qH42DjSrY/KSyPbQOVqxasCHC/pALNLtm6ZWtkOjgk2YV27vs0PBlDseFYm3wK0gVdx9E1MYRhPtIAqGYDS0MWJ6oWUQ/u9NH5Jmps5fBJDrAZ+cG8hnhiulGj7jObeSoyVlc6iwG48lJBGzX1tPSzChf9gn7nPwPQJgIW3Qh5L9/6+jChU7WwIoMPxw/UA2dN3wNdubeJOLsMM=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(136003)(346002)(39860400002)(451199021)(40470700004)(36840700001)(46966006)(316002)(110136005)(40460700003)(36860700001)(478600001)(54906003)(82310400005)(81166007)(36756003)(82740400003)(356005)(86362001)(5660300002)(8936002)(70586007)(4326008)(7416002)(44832011)(70206006)(8676002)(2906002)(40480700001)(41300700001)(426003)(1076003)(186003)(6666004)(26005)(336012)(83380400001)(2616005)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 05:08:30.3553
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cb14454-f9ed-46f0-3c14-08db30dccda3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT091.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8077
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Harini Katakam <harini.katakam@xilinx.com>

The seconds input from BD (6 bits) just needs to be ORed with the
upper bits from timer in this function. Avoid addition operation
every single time. Seconds rollover handling is left untouched.

Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
---
v4:
No change
v3:
No change
v2:
- Update HW timestamp logic to remove sec_rollover variable as per
Cladiu's comment
- Remove Richard Cochran's ACK on original patch as the patch changed

 drivers/net/ethernet/cadence/macb_ptp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_ptp.c b/drivers/net/ethernet/cadence/macb_ptp.c
index f962a95068a0..51d26fa190d7 100644
--- a/drivers/net/ethernet/cadence/macb_ptp.c
+++ b/drivers/net/ethernet/cadence/macb_ptp.c
@@ -258,6 +258,8 @@ static int gem_hw_timestamp(struct macb *bp, u32 dma_desc_ts_1,
 	 */
 	gem_tsu_get_time(&bp->ptp_clock_info, &tsu, NULL);
 
+	ts->tv_sec |= ((~GEM_DMA_SEC_MASK) & tsu.tv_sec);
+
 	/* If the top bit is set in the timestamp,
 	 * but not in 1588 timer, it has rolled over,
 	 * so subtract max size
@@ -266,8 +268,6 @@ static int gem_hw_timestamp(struct macb *bp, u32 dma_desc_ts_1,
 	    !(tsu.tv_sec & (GEM_DMA_SEC_TOP >> 1)))
 		ts->tv_sec -= GEM_DMA_SEC_TOP;
 
-	ts->tv_sec += ((~GEM_DMA_SEC_MASK) & tsu.tv_sec);
-
 	return 0;
 }
 
-- 
2.17.1

