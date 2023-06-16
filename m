Return-Path: <netdev+bounces-11640-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F5A3733C99
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 00:50:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9BEDD1C20A57
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 22:50:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88B3F7480;
	Fri, 16 Jun 2023 22:49:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BEA28C1A
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 22:49:57 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2086.outbound.protection.outlook.com [40.107.223.86])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6036A358C;
	Fri, 16 Jun 2023 15:49:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AD3e5A7jQeRYx41wLkGsZIzvGPIEu3I64GnhW+7W7lOuo1elumXyYCyKPaE4XcxYMMUlotj60z2WhrD9rJPy1xLS5sU/7UA93XM0+MiNkVxxN55m1FS+/lLgKltfKThZffUsiWy0qzDC6Nq/AuxIVRfWBecE+5Cj1oBPNtET7hpFpjHsczMmMM0WkLybpWghRJvHNGbLv3IBCru0/WLRwV/61jAtbpHp4xU/r1o98R7F4PcTbnF01S60px36r0UH3eFZRe8KE1PBzc4krkWpuGXMH1R6RLIbgd2ZxJHFhs6NlGunZdhbKVSLgK4ND+alFHEUSF+uWwSRNAzCL9+46A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X8kC5IsxcdzTebW+gcgoHiserpY8qf4nEWO57q30iwo=;
 b=FsyJHNfVbgqroxE67zZSqWlq4udnQ24vpLlXU4OBdGW0y2NVJKUIS9+H/OHKJJDSw616dCNvzCHIn20eN7NC4NkWrASSlOn/f+sO8asTowLfnEZK343O/K+epuqgJHH32CJ25p2ABJpTZQYs6XC7qFnfKYfeZJ9WQH33CoXuZXizx6zHFIRIv7i9djsO626Ezsneb0sGxNWlsUXgjDNYcjl5nfX3LkOJZH/b52f2IUJXr8g72ZApdUZV4Ijds8hQh4605mTx/W7lb2j5N2a6/KzFmwKHOqcIZIysTJuC8YCk9hXTFnnGs/uvACfHFu0AIOOhK6g8A1Cj2rfHrKAgGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gmail.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X8kC5IsxcdzTebW+gcgoHiserpY8qf4nEWO57q30iwo=;
 b=azRAqm1mxqo0ekQgUZbhXEK8jCFcx/SgmY2MXg5LtZgRyBhfHPxQoHDSOA9TE29lCCKPCxtoHof0rdW4/rMGN/aIXpwWHPJ/TdgqjtOaVxdElHwl0IuOMHhws1VXo5MEM+koWz+mSy/pjr8jdkoyiiL/XyoN/CajGG2EVqNSDsA=
Received: from BN0PR08CA0015.namprd08.prod.outlook.com (2603:10b6:408:142::31)
 by SN7PR12MB7853.namprd12.prod.outlook.com (2603:10b6:806:348::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.27; Fri, 16 Jun
 2023 22:49:53 +0000
Received: from BN8NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:142:cafe::f3) by BN0PR08CA0015.outlook.office365.com
 (2603:10b6:408:142::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.29 via Frontend
 Transport; Fri, 16 Jun 2023 22:49:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT016.mail.protection.outlook.com (10.13.176.97) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.25 via Frontend Transport; Fri, 16 Jun 2023 22:49:53 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Fri, 16 Jun
 2023 17:49:52 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Fri, 16 Jun
 2023 17:49:52 -0500
Received: from xcbamaftei43x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23 via Frontend
 Transport; Fri, 16 Jun 2023 17:49:51 -0500
From: Alex Maftei <alex.maftei@amd.com>
To: <richardcochran@gmail.com>, <shuah@kernel.org>
CC: Alex Maftei <alex.maftei@amd.com>, <linux-kselftest@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH net 2/2] selftests/ptp: Add -X option for testing PTP_SYS_OFFSET_PRECISE
Date: Fri, 16 Jun 2023 23:48:45 +0100
Message-ID: <e679110fb29bbf3d8bc7f27a60c48a25e1fa6600.1686955631.git.alex.maftei@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1686955631.git.alex.maftei@amd.com>
References: <cover.1686955631.git.alex.maftei@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT016:EE_|SN7PR12MB7853:EE_
X-MS-Office365-Filtering-Correlation-Id: 246ec6a7-878b-4cdd-7404-08db6ebbffbd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	tTkhzkrdcs/rS/m4xfQsDYMZhAIREEI1v4sOC0DQiEjRA+qUtGCRTkb+dTRxVjP8KQ9nSGpJb1ylPhzh8lN5+/XJY/zMGzbADutbXDe6fb9LlFoT2rSCrs9TtPdjmT02rAPn6m9H7N3XuREYq9lSrDwTYXXS7sAo1gXoQ7kLeWr/0r9NAIxKQ/MCMR/0fqRq1SlGJUOTHpNjCeFeHu/skl7ryVOMStloesG8a73l+Zfqs/dp6YTMXHa3vfGnUDMbDX+bfQmwJFhzBMH4AMydLI/XDl9zaGTZUGNLPdR5MhYdLRsy/i5Dm/QrmTwrMlBHZGRng/RZzU7FXGWqzpI6OrWl/De1BUd6+gRYvvd9vw8MSjownjz53NKsU5Vp805Gi0ffFBdtNq7JlwVU2pVXRID/TTGhSYoWR9N/ohORrnChGgSJ6vh0kc1Pzd/vfPHGRnEfCNyx2POsP+rVHsoC/TjnodRTPw/HpPbrKRlkRDpHHT+BhJwYpSoOMh3rU86mq1bJ861otBiLsH9p24D8aWs4Av16Z8U+U8uE5UFqx/U3U9WUOpLO0oxi/ezIIlKcJe0rDaDRSr6RGMzoYYjvtPpzfK7FHsARSFSYswxUNzSOLnilE1+ia5v711B3bjJU/BfEh6qL/4g5//n77kaCIuQTdeAztemQFKAdxrLv6W+utCD5ZwE19CQuUXs5aDYtsOT958Ctv1Q362lVRBB3MeKpdZta0HLP+H9q5TpqH2JvmeRtP457+t0D5xzsHMVtSLxWcwzOPYcqAYczQjJU4g==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(346002)(376002)(396003)(451199021)(36840700001)(40470700004)(46966006)(26005)(83380400001)(82740400003)(5660300002)(81166007)(2616005)(336012)(426003)(2906002)(186003)(356005)(36860700001)(47076005)(44832011)(478600001)(40480700001)(40460700003)(70206006)(316002)(8936002)(6666004)(86362001)(41300700001)(82310400005)(8676002)(4326008)(36756003)(70586007)(110136005)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2023 22:49:53.1134
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 246ec6a7-878b-4cdd-7404-08db6ebbffbd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7853
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The -X option was chosen because X looks like a cross, and the underlying
callback is 'get cross timestamp'.

Signed-off-by: Alex Maftei <alex.maftei@amd.com>
---
 tools/testing/selftests/ptp/testptp.c | 29 +++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/tools/testing/selftests/ptp/testptp.c b/tools/testing/selftests/ptp/testptp.c
index 2a99973ffc1b..6ab5836b53ff 100644
--- a/tools/testing/selftests/ptp/testptp.c
+++ b/tools/testing/selftests/ptp/testptp.c
@@ -143,6 +143,7 @@ static void usage(char *progname)
 		" -t val     shift the ptp clock time by 'val' seconds\n"
 		" -T val     set the ptp clock time to 'val' seconds\n"
 		" -x val     get an extended ptp clock time with the desired number of samples (up to %d)\n"
+		" -X         get a ptp clock cross timestamp\n"
 		" -z         test combinations of rising/falling external time stamp flags\n",
 		progname, PTP_MAX_SAMPLES);
 }
@@ -159,6 +160,7 @@ int main(int argc, char *argv[])
 	struct ptp_clock_time *pct;
 	struct ptp_sys_offset *sysoff;
 	struct ptp_sys_offset_extended *soe;
+	struct ptp_sys_offset_precise *xts;
 
 	char *progname;
 	unsigned int i;
@@ -177,6 +179,7 @@ int main(int argc, char *argv[])
 	int list_pins = 0;
 	int pct_offset = 0;
 	int getextended = 0;
+	int getcross = 0;
 	int n_samples = 0;
 	int pin_index = -1, pin_func;
 	int pps = -1;
@@ -260,6 +263,9 @@ int main(int argc, char *argv[])
 				return -1;
 			}
 			break;
+		case 'X':
+			getcross = 1;
+			break;
 		case 'z':
 			flagtest = 1;
 			break;
@@ -554,6 +560,29 @@ int main(int argc, char *argv[])
 		free(soe);
 	}
 
+	if (getcross) {
+		xts = calloc(1, sizeof(*xts));
+		if (!xts) {
+			perror("calloc");
+			return -1;
+		}
+
+		if (ioctl(fd, PTP_SYS_OFFSET_PRECISE, xts))
+			perror("PTP_SYS_OFFSET_PRECISE");
+		else {
+			puts("system and phc crosstimestamping request okay");
+
+			printf("device time: %lld.%09u\n",
+			       xts->device.sec, xts->device.nsec);
+			printf("system time: %lld.%09u\n",
+			       xts->sys_realtime.sec, xts->sys_realtime.nsec);
+			printf("monoraw time: %lld.%09u\n",
+			       xts->sys_monoraw.sec, xts->sys_monoraw.nsec);
+		}
+
+		free(xts);
+	}
+
 	close(fd);
 	return 0;
 }
-- 
2.28.0


