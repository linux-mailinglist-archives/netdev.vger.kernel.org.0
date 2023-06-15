Return-Path: <netdev+bounces-11025-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 342D0731242
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 10:35:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 61ACE1C20DCB
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 08:35:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2529D10FF;
	Thu, 15 Jun 2023 08:35:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1757E659
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 08:35:10 +0000 (UTC)
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2060.outbound.protection.outlook.com [40.107.100.60])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6300272E;
	Thu, 15 Jun 2023 01:35:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NDgHJh7WWv9zaFoE/50z2p0Q2T3PRB9OWfQ+12D6JrEMdNhclOZt0uPBzG8SH7zCJf9uQ9IvvoxUz3lKFWyp8cc+OLkGehcakEUdDxKvntJgPncgR497lWomNWoxgDAhRL4IMMFG7Fi6ZKY/0nqGOAc2h9e/JL+gynlKuz8Zkgv6mIsUkGgB7pYB1mZ/fCRouZ9oIpYSK8ahhwh14ilMk7L8ZkikdEQrv5Of3bLye5CYZqt7X25FjJh1K8dfldWU1fYk6IPXGe6d5d16dlALjQBu+VOY2nsJyEsNkCS4ktjHJOGNQw5qFe0O7Zs524BuYCFmqk/b9PpBA7teJR79vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B5zF1HH++J+LEtjiQBhek6aV3vh47zkQNgm8Dw3IDys=;
 b=SIL2Cf/sS/ACRegDMOzd+kz0fkS2b53sIjZL/eN8C16XQFvB3/maWW+gk6otyWmODjpFSDhwHsII8kRWdh6+u8hKvvZE2px2/od0tL58ZWlNcF0YrrAUjRw6nfTAtsSIrYPZtCLD+jz+ITAG9f8ne8SZn2BixCO3LAE233FLAldFgjbx6V7DBW2EpnPHaVxNrxeTh/baE/qbRfBNU44ucIwBTeI/Dzu3/bAMMJcLbNJ/KDcGQyAheHz4jSN2Idusv538ymrDLuzbrNN5hzcAQry27ZDn08MfrW4LO54RP4E4vgYjycrohPUgld1q5cPw2ztIKFtQ2NTt3g0INjsdng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gmail.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B5zF1HH++J+LEtjiQBhek6aV3vh47zkQNgm8Dw3IDys=;
 b=ePagilp8+0KNKC7gGUSDLGQ1shHFo3qAQbRv+vy/1Q+YUIyWvKj4vLMNxmih3jUx+sSttfRTLCFLnsGPU2yuANMyfv0rNZGz8WbVL3wRiUX7Wx6x1R583/HHkLEcoQO+BL7wpkrwal4uQFdUU0vUvkXh34Vs9t3P/kqo4u/HpT8=
Received: from SN7PR18CA0007.namprd18.prod.outlook.com (2603:10b6:806:f3::27)
 by PH0PR12MB7486.namprd12.prod.outlook.com (2603:10b6:510:1e9::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Thu, 15 Jun
 2023 08:35:07 +0000
Received: from SN1PEPF00026369.namprd02.prod.outlook.com
 (2603:10b6:806:f3:cafe::73) by SN7PR18CA0007.outlook.office365.com
 (2603:10b6:806:f3::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.25 via Frontend
 Transport; Thu, 15 Jun 2023 08:35:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00026369.mail.protection.outlook.com (10.167.241.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.27 via Frontend Transport; Thu, 15 Jun 2023 08:35:06 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Thu, 15 Jun
 2023 03:35:06 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Thu, 15 Jun
 2023 03:34:52 -0500
Received: from xcbamaftei43x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23 via Frontend
 Transport; Thu, 15 Jun 2023 03:34:51 -0500
From: Alex Maftei <alex.maftei@amd.com>
To: <richardcochran@gmail.com>, <shuah@kernel.org>
CC: Alex Maftei <alex.maftei@amd.com>, <linux-kselftest@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH] selftests/ptp: Fix timestamp printf format for PTP_SYS_OFFSET
Date: Thu, 15 Jun 2023 09:34:04 +0100
Message-ID: <20230615083404.57112-1-alex.maftei@amd.com>
X-Mailer: git-send-email 2.28.0
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
X-MS-TrafficTypeDiagnostic: SN1PEPF00026369:EE_|PH0PR12MB7486:EE_
X-MS-Office365-Filtering-Correlation-Id: 40ee98b5-0b43-4151-7fc8-08db6d7b6c6d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	G50gFVdYKkNimGyLIU3SASDVD0jb3fStG6RqVEf+fm553IOfYsoTJi040Hx449s9icsxkXCa2RhxOTD0XWBnrXfTzsyi7Egy5WckScp1noxz3FVIDtX5aoSAa9V9Zprwha/eNeT7VVNQBguYD9gdCRemOTmJAA+XsnHwsUIk+hwg2afEBfuFXBWpul9TKLYESs6/gE6eY87r9vDl2rZmrn1Zp1yOjCQrNwh50mRBzNKZ3CaM9GUAuGLFWtZoPnmmmPB/gzzjZ4HcLvRw+CAZdhaiotuLfsF2HzjbUiQjzh7Xcpocsk/9i5cmOUBh04I+hR7/3gmjIq3e1XAuQQcVgXyQzqbzIv41H0qfPOV3hcx9Uu3ip3lNLNAk0vCZYo2wrE2H5SzzVYOmzKG9SXqAXu0QdaMJMSWkY/yk1NhSAljCp2y+AhtW2OURHJLHZABUcsnYyveY40OxKJyzBX0rfzMgvuLtC7yaNjtukBNfoWHboWpttQ/MhU3BKVbxUVUcmRtQ0N5nOeCMb+YWM6svase923IfTvYbMljBHY13S9u9s63VQuM2AnaEjXYu9nger17TM476d5gORSfRg2rD7i923Q4L8EvhIO2smVVHqlAz5eJorJgw67Cj91ogIFai6uVYv7c/cwLTV4+/8EwtmkNUaQBx964nL55dXVJT1isEXGeNjzUPLWc+gH75vzPNkWTgApe4mlT5hOdP8E0oYul8eCHLH33awZanAsRMsaAKFYZOTFxgxBAgsJD00uImgDECnei4Vusf4eEGP6LbAg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(376002)(396003)(136003)(451199021)(46966006)(40470700004)(36840700001)(5660300002)(83380400001)(426003)(336012)(186003)(40480700001)(44832011)(2906002)(47076005)(2616005)(36860700001)(41300700001)(8936002)(26005)(40460700003)(8676002)(316002)(110136005)(54906003)(6666004)(82740400003)(36756003)(478600001)(81166007)(356005)(82310400005)(4326008)(86362001)(70206006)(70586007)(1076003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 08:35:06.9952
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 40ee98b5-0b43-4151-7fc8-08db6d7b6c6d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00026369.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7486
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Previously, timestamps were printed using "%lld.%u" which is incorrect
for nanosecond values lower than 100,000,000 as they're fractional
digits, therefore leading zeros are meaningful.

This patch changes the format strings to "%lld.%09u" in order to add
leading zeros to the nanosecond value.

Fixes: 568ebc5985f5 ("ptp: add the PTP_SYS_OFFSET ioctl to the testptp program")
Fixes: 4ec54f95736f ("ptp: Fix compiler warnings in the testptp utility")
Fixes: 6ab0e475f1f3 ("Documentation: fix misc. warnings")
Signed-off-by: Alex Maftei <alex.maftei@amd.com>
---
 tools/testing/selftests/ptp/testptp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/ptp/testptp.c b/tools/testing/selftests/ptp/testptp.c
index 198ad5f32187..cfa9562f3cd8 100644
--- a/tools/testing/selftests/ptp/testptp.c
+++ b/tools/testing/selftests/ptp/testptp.c
@@ -502,11 +502,11 @@ int main(int argc, char *argv[])
 			interval = t2 - t1;
 			offset = (t2 + t1) / 2 - tp;
 
-			printf("system time: %lld.%u\n",
+			printf("system time: %lld.%09u\n",
 				(pct+2*i)->sec, (pct+2*i)->nsec);
-			printf("phc    time: %lld.%u\n",
+			printf("phc    time: %lld.%09u\n",
 				(pct+2*i+1)->sec, (pct+2*i+1)->nsec);
-			printf("system time: %lld.%u\n",
+			printf("system time: %lld.%09u\n",
 				(pct+2*i+2)->sec, (pct+2*i+2)->nsec);
 			printf("system/phc clock time offset is %" PRId64 " ns\n"
 			       "system     clock time delay  is %" PRId64 " ns\n",
-- 
2.28.0


