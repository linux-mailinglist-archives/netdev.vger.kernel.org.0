Return-Path: <netdev+bounces-4805-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D07E070E6F2
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 22:56:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 999D41C20B36
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 20:56:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C8EB8F79;
	Tue, 23 May 2023 20:55:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 898A0BA24
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 20:55:42 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2068.outbound.protection.outlook.com [40.107.94.68])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DDBF189
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 13:55:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cxoc2vCyWwsQDGPGxrQcModYjdV0wB2qrBWtYaYdhML6OMS7HE4SuiFqRXMANunWCR2l1yHzZRqygu08E7TPrc9/+j0jIMyo3+A2QM8nSr+efqauM7OG3Ncrn+9+6sYkAvx5MuW0Zj8XZfBJq7qxrcwyBG5mWiKPnSfHVS+6COw8iPpnPwbAUeYu6czbyRE5D0cosZGT7ITeUbj7m24MW3Kkeh2mOovTfnXNsckfIF2R9atYCwl4BPpimgshNNXJAAbf2lXBnstFadiHCv5VFYaNiK0laS9fJh2FYZDaNrk3AyqrQy+sEoXACekuA2D9u+nTRFdeVG+pg/ncdNsnpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XFNriD/fL6A3uY8KpMkeUL3MZ8nlRVQVzMUOQejOyts=;
 b=CVwA1usFpjdlOFPg9LJ4njC/LFpQUH64CbHW+uAmxwoAnsR6wZV6EfGdu7Lx+LywHPohC2qDP8BKtCDJ4ub3QGwn9VrLomUcZL14w8AVMtNHMF3zuQjV/6hGcc3IwAcbeym/rm75d38tHTTDDg/j/Nz0H8USA4mB6LgXbmkCHrmz474wnXfonGeDdLD5A4KFjNNKHH4jjHK8v1W3oRavNJvWGNweEF4egPtRwr3JkeLkYQb2i4AyqOWZON6yGTeuQSnlUjJEUqM9QXjc1KqVmX9kyLKW61iUmapSsgl5EXf1QPVkMUEUnm4GRLML9A38rMa67ijeZ5CwR06PObrXwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XFNriD/fL6A3uY8KpMkeUL3MZ8nlRVQVzMUOQejOyts=;
 b=HAHqdaqaki6eusIz1kjstwsMdG/jiErVblcuA5otGW5rOH+lb7F6WfTWQbSY0GrMf9JBNTB10WZtwoxKYpbg/doTHzr0SKXQ9Adm0ce3lSjFYwxN1wtizvoA/AS94mjQhkOFwFjAE7qYG5ad/41NOvy4L6XCsq5dcibP1vQUEMwjcwLbtK8V90Nppjj4+l4DZG2kzmmY2PYJRTmY1HefR8WZuT+4//KQl6fiCnikXBkiFd7Kh3hPAbSHoXRt/0Tiiousw/a/NXbTsQi61KjA8CHcws2AcuyapK/c8O6mfR6Ott0y+XZfJduSqNLVUxGFYFbbd9SJN0GlN/Mtf8yt0A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.29; Tue, 23 May
 2023 20:55:30 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::f3d4:f48a:1bfc:dbf1]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::f3d4:f48a:1bfc:dbf1%5]) with mapi id 15.20.6411.019; Tue, 23 May 2023
 20:55:30 +0000
From: Rahul Rameshbabu <rrameshbabu@nvidia.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Gal Pressman <gal@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Saeed Mahameed <saeed@kernel.org>,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Richard Cochran <richardcochran@gmail.com>,
	Maciek Machnikowski <maciek@machnikowski.net>
Subject: [PATCH net-next v2 4/9] testptp: Add support for testing ptp_clock_info .adjphase callback
Date: Tue, 23 May 2023 13:54:35 -0700
Message-Id: <20230523205440.326934-5-rrameshbabu@nvidia.com>
X-Mailer: git-send-email 2.38.4
In-Reply-To: <20230523205440.326934-1-rrameshbabu@nvidia.com>
References: <20230523205440.326934-1-rrameshbabu@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0036.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::11) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|DM6PR12MB4337:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f083dcb-134b-4df6-9b5b-08db5bd00ae5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	M10RDJet+orxAfPro4YzoDeHfGv+CpIgn1rsw9mqYXbZpnWgxNJQTMUeiGaPbmWmS+DI6I90iKemmewV4RseHIBdVEuQZ5GGME1RE+bnH2/QMBYZB0urOF3Cax/f2IeneeDUE7WycbWcpZOzaa5SyxiGEEyINR5C6qoW5rKmPszeiwS4S4GTqTZXd8vCbulI5hl9ENNDyYOkLk5jbsoRJzA7fJ6cA+fWFRZ9e3FZIMeiEdt/oLk+4RzkyUexrQBdJwSGlHRBT8ISQ7wnFxgBf+ikjl4eu+WLMN78W2G6PrV6oFe5o4mk5pL0wsLUzPj/Pydk48p+0LEbaO1SJvYgD9+bkDMks3a6qsHjDOPSYo3U+ZOYvOW3s1ALszuYWOgpeqHz7uUEE71VLssPscNGbiT0ShCS73EQNnUlI/ipeXjkOKpcg/hEbzS5CCX7dQTdW9Sw9Jd2b84ghk7GRoOOGhCpTraGgj5UfpgqXnM0ocvjdtsdww3fYv82Nql1xfUAC4QeRw/LjmdzXAfezS1WnjUFwptZKeHEcNfmTtztNLJlRDzAcQzS9gYgYLTRZ3NfZhHqgw+3HYJOJ1kgLzh8ffo2ZljDhWRskKKXk7HYyZ8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(366004)(396003)(136003)(39860400002)(451199021)(26005)(186003)(1076003)(6512007)(6506007)(2616005)(36756003)(83380400001)(2906002)(41300700001)(6486002)(316002)(54906003)(38100700002)(478600001)(66476007)(66946007)(66556008)(6916009)(4326008)(86362001)(8936002)(8676002)(5660300002)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mmtq9O+S15Rl4b2FY7t97AZurIYsiAh7Nuk3FzVU8Cv/B++KbndmCMRBc4/N?=
 =?us-ascii?Q?PA2iEh8Yu7+c+rBi2RkwGrWkes7JC4wXKCF9/sbvD+7xfFM6d/aWm6SNWlUU?=
 =?us-ascii?Q?uCDf1CKMA/qi7TJoGhBudWwFyDUx8O3DA1s7tQHGERNc9DWr4Fd9HUcf399S?=
 =?us-ascii?Q?AdfusBbtvX/nrq/EIam7IHU8nrfwI3VZGCiIAf8K0frFwrZNKSHb8u6AXm9I?=
 =?us-ascii?Q?YjeYEfMK0SCxuWLf5nx7Ce9P+ItfTF7KCKudNnXjkuN1+7Cf0JDRp4wSe1Sa?=
 =?us-ascii?Q?Lo2EPoXd8erFuifK03QeHiL4FFEjOfctaN2mVrrgbpcsCnE+MrozCBr7dyjs?=
 =?us-ascii?Q?JWe4amUTmB7zM9F+Q7KGFr2I8SLyS1FPU+znhUvLUXHIBUxvmMsHJV2ogmau?=
 =?us-ascii?Q?Kraw0+srLi/f/5f9a42bOcdoNM67zckioZx913wdyvTXiJrGfo2vBoK2bOx+?=
 =?us-ascii?Q?9garSujSbFjFYKxM6EUKAukupyJ/gt9N1aSc9xla8A2LDzZ/63MRIqHf2vS4?=
 =?us-ascii?Q?OFtuxZNJocARViQPk76kyzAhFMQbpWocXF+kqD3FAu17H8GGhFK3wvj2A/+L?=
 =?us-ascii?Q?FMCLejNA3+/shAztI+4ekCG2OEEFVeWTWArAn4d8cldPJLIXAWtdc61k0+2/?=
 =?us-ascii?Q?nA6r9vQK1Rj8g8VqKFVkgOeLBDpfZtr2rDux13XxA+7lTZvgzSPUgx9tMGb8?=
 =?us-ascii?Q?uTufYabTKFb+gUiLLvl/vo7ptsL4gXh9qHtWx4pFs+Us5CA0BbjcfQnXXgk/?=
 =?us-ascii?Q?6XcKvxuGTkRWX9m1UEXfIKhxvc/hyfqun3UMIm1S0ecI0YLdhuJj+i6+C2eV?=
 =?us-ascii?Q?KQ6d2dadqNsZs9kXD9eco3JFBjMdDp84sUKERwUcFPeN/n4J91T+S8xLxrN0?=
 =?us-ascii?Q?NuCdXtx3LBIhnjytO2PFIRSm46Mf7XzfXeOEuUF5aEov9Gags/oeJsKOy2UA?=
 =?us-ascii?Q?IiOgCUIETTci6UObKhlFSzkPVII8rcFBVzYRY4ov8fpr9wobSsTaY9PBEBoK?=
 =?us-ascii?Q?L7GYVLu6JdyHTYyxb/Fp/xwHJD7jaW7CgMmm5CNPXnTLK3GO8RZXw5s6YMQg?=
 =?us-ascii?Q?BoiIy/l1KdxJWvWaV9iwTBF1kQ/QrQyWKCbRvkOekzp/pnj911oLWAuAcIcA?=
 =?us-ascii?Q?MzvnoBQg7KBdnpwtPD7DMivHC9RceEqA/nvT7Isx4UCqJwUk+UKwYbHBX5gm?=
 =?us-ascii?Q?fUJuxIHd71Tt7dt90oO3nGc0nihoSJAyGTAAih1WiTrOKbNkyisk11bKjJkV?=
 =?us-ascii?Q?n1XrjUUFPOhbMMvuoTGZr755nvO3UBSzZjviEjRda5gS9lmi4B2g/hcJDnIn?=
 =?us-ascii?Q?TJdYFPfdH5Vkrv0PgwnNsecLQsdE/sqMcrsktcqAVUzCMmPNJSVtF+YEkD2z?=
 =?us-ascii?Q?aKxtQl2soW5FhKNfFfsRIoCf+mltnmUXw8ahI+UfRX6GjF58Xiax6HDtLkB7?=
 =?us-ascii?Q?7ZMwi0uhWquEFlfwU65wSp7zQTMhgLjJCuiXhFd49wzaiXJNklqGG0oBJBFB?=
 =?us-ascii?Q?rBpxKxnlBsLiByNZ+Gc01LCtQhrfJbf6Yc//DDPCt1t3CBbaUGpsV+g5cI/t?=
 =?us-ascii?Q?mrmgNkkyIVbzAwSKe5jln3LOPm44lKsqVbxfJfEVOA+uVJAuHEtQK4LXgQ2H?=
 =?us-ascii?Q?oQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f083dcb-134b-4df6-9b5b-08db5bd00ae5
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2023 20:55:29.8643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mXoLH/BETKqz52maobZf/iZyDt5HgvLyRM3l0Zwyo/nFck2m48acLZpv+QjbFWH0wOe2GxoXNuUYKcQR8r0CUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4337
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Invoke clock_adjtime syscall with tx.modes set with ADJ_OFFSET when testptp
is invoked with a phase adjustment offset value. Support seconds and
nanoseconds for the offset value.

Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Maciek Machnikowski <maciek@machnikowski.net>
Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
---
 tools/testing/selftests/ptp/testptp.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/ptp/testptp.c b/tools/testing/selftests/ptp/testptp.c
index ca2b03d57aef..ae23ef51f198 100644
--- a/tools/testing/selftests/ptp/testptp.c
+++ b/tools/testing/selftests/ptp/testptp.c
@@ -134,6 +134,7 @@ static void usage(char *progname)
 		"            1 - external time stamp\n"
 		"            2 - periodic output\n"
 		" -n val     shift the ptp clock time by 'val' nanoseconds\n"
+		" -o val     phase offset (in nanoseconds) to be provided to the PHC servo\n"
 		" -p val     enable output with a period of 'val' nanoseconds\n"
 		" -H val     set output phase to 'val' nanoseconds (requires -p)\n"
 		" -w val     set output pulse width to 'val' nanoseconds (requires -p)\n"
@@ -167,6 +168,7 @@ int main(int argc, char *argv[])
 	int adjfreq = 0x7fffffff;
 	int adjtime = 0;
 	int adjns = 0;
+	int adjphase = 0;
 	int capabilities = 0;
 	int extts = 0;
 	int flagtest = 0;
@@ -188,7 +190,7 @@ int main(int argc, char *argv[])
 
 	progname = strrchr(argv[0], '/');
 	progname = progname ? 1+progname : argv[0];
-	while (EOF != (c = getopt(argc, argv, "cd:e:f:ghH:i:k:lL:n:p:P:sSt:T:w:z"))) {
+	while (EOF != (c = getopt(argc, argv, "cd:e:f:ghH:i:k:lL:n:o:p:P:sSt:T:w:z"))) {
 		switch (c) {
 		case 'c':
 			capabilities = 1;
@@ -228,6 +230,9 @@ int main(int argc, char *argv[])
 		case 'n':
 			adjns = atoi(optarg);
 			break;
+		case 'o':
+			adjphase = atoi(optarg);
+			break;
 		case 'p':
 			perout = atoll(optarg);
 			break;
@@ -327,6 +332,18 @@ int main(int argc, char *argv[])
 		}
 	}
 
+	if (adjphase) {
+		memset(&tx, 0, sizeof(tx));
+		tx.modes = ADJ_OFFSET | ADJ_NANO;
+		tx.offset = adjphase;
+
+		if (clock_adjtime(clkid, &tx) < 0) {
+			perror("clock_adjtime");
+		} else {
+			puts("phase adjustment okay");
+		}
+	}
+
 	if (gettime) {
 		if (clock_gettime(clkid, &ts)) {
 			perror("clock_gettime");
-- 
2.38.4


