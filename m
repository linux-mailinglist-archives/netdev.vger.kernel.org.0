Return-Path: <netdev+bounces-1575-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF7036FE5D9
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 22:57:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3E9DB281554
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 20:57:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7724321CE8;
	Wed, 10 May 2023 20:57:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647F821CC4
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 20:57:55 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2060e.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5a::60e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C4E98A60
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 13:57:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TBEnMKHRHO5a0OP0Bb+sDYwjbITqgmUth5YgXYCSTm2mGBf1/U87Bh940hz3jnN3YPA/Hs5QoEGPZ+yysANs8H/wlgB2ivNR6YuHAyNmfM1e/sMwUA9DPMTo6x2R/DZJ1+R+vTDslXN3MARYyOY8k/Qj3FvCpuslmiS2ZmbarfXLgusF/reFoygoHKK5gSWHgSlYqiGRn+1e4cpFhtHvelHGI4isOMaVCpuaxnKhdeOCufk8gs2wPJCS1exOLOBQMkQqVtnDbcXQ7buw+es1A3IqpDLB8UxSNNv/O8OsY0cAACJdzR3szV8ArE4iYABioY+78Yp/AFVX0YxQr9CwpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3l58gfbJDCz4OLrUG6plTxaF1O4DIYrW7WT6qLyxPpY=;
 b=BLeqGN8H8H+m10IXk265Qo9zRX+xLx7TjFla/xsDZlpyXq4dbKBaq6PcKFdOSyhnduQYQ6C386RExLASZnXGDDWaSZ2ki4Q+5BUVCIf/X/ufWe7IhTnD6lfoxdwsQxMittAxd0qW89HyA8kDbWzo6sEqI3VZ62K5Bao7gnYMJckbYtBlkVzgPTTQrRCgwgPSndsmfi9Ytf8ar+JKc4+ACsh4x0XznmZTi5OnJokOLvC+cowFLrNfv6/O2qbLBjXfD7u+ubHosyaF6HdjJu24DvGyzPYb44yMGj44kuCT6jYOi/GfmMr8l7xcaegvaIO+YazztfYE2yRXnW9Ah5/+3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3l58gfbJDCz4OLrUG6plTxaF1O4DIYrW7WT6qLyxPpY=;
 b=TaKaVicGszPmtkwRRn3cbZx34YoqoK3rqWzHj+H+N65mfOmK3UgPBdoPS58J/tZLW7fGJPjXPQpztYpE88viprPXX4My1qERwvYXIi5U6g08FOyvIFo8TmP+ASEYHwuzTuRdCYvH4BSGT7Zyu+4R4HVGdOna2B0Tj/V4fWTa8XaBcYwALMuRYpxnHRCtww9EhY3ldJQ7/Xniw1KQrlxaPWWs7ugmJ3lt6UtdmNQbIPpTzIGjN9oSekUExfLL2ugFp4hFik4Rsurs7pDjDf/QQr5tyh4CAHqvv7CZ734f8mMIvPcoveQaXRex2dNOWGY9XojTOq9DQflAIJWstS6PZg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by MW5PR12MB5624.namprd12.prod.outlook.com (2603:10b6:303:19d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.18; Wed, 10 May
 2023 20:53:54 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::de5a:9000:2d2f:a861]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::de5a:9000:2d2f:a861%7]) with mapi id 15.20.6363.033; Wed, 10 May 2023
 20:53:54 +0000
From: Rahul Rameshbabu <rrameshbabu@nvidia.com>
To: netdev@vger.kernel.org
Cc: Saeed Mahameed <saeed@kernel.org>,
	Gal Pressman <gal@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Richard Cochran <richardcochran@gmail.com>,
	Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH net-next 4/9] testptp: Add support for testing ptp_clock_info .adjphase callback
Date: Wed, 10 May 2023 13:53:01 -0700
Message-Id: <20230510205306.136766-5-rrameshbabu@nvidia.com>
X-Mailer: git-send-email 2.38.4
In-Reply-To: <20230510205306.136766-1-rrameshbabu@nvidia.com>
References: <20230510205306.136766-1-rrameshbabu@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0013.namprd04.prod.outlook.com
 (2603:10b6:a03:217::18) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|MW5PR12MB5624:EE_
X-MS-Office365-Filtering-Correlation-Id: af270b61-dc8f-43a0-3b20-08db5198aa91
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ud8NdVt0ixkvlLd+taEBUicvPQv2PW6hIbRNLLlPk4K1kdxhu5AcSAEAedVXQ3O8BAZ5kPMoyoLzN7SOYRHn5SGrJzaVfx3Wh1FUjwlBESf5No1tYuxMYVBzvo77o115AtyiPHt2uqUzTdCRfovMBN32B8i9Llp/yLr92oH++aJgTzWPR3J4v0IWbJ568UcIuiQjd4cEjlPu/LvAgP0mSX+ZLnj02QnN9bXczOB46tNIHLHzamLHt96hsrX4pU9btnEL5LZWW/3j0oSuRZbEbOWIX1prwNcu48Uspd85S9tuWh05Sf016b1NHFBkORTYp+nHc1naEWeTTsCeAL6sfJU9tSUMU1M9Z/Xi0JY9Y1E53hx6zffi9qb6mQDCSnuHudYE6bz15YEUohma+C3KEupwyyYjClU2XWniHWvH6/ChkP84caasA7arw+82idUNG6ys72dC09Kt6JylvaFpHPyzJl52pHCfQD5uWt3w5LeAB5jq2QRUqS6WPh3YjhqV8HhirMBM/3nQ3/zDSz7bmaHEYO2y7pKZrs8rOBAsHunB3fH+twSr2O85IQtIdiTRMqomzEbrTounBDfc455Mpgxz00zYBZrnBoH7QzjR+c4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(39860400002)(366004)(396003)(376002)(451199021)(86362001)(5660300002)(41300700001)(4326008)(6666004)(38100700002)(316002)(6486002)(6506007)(6512007)(26005)(1076003)(478600001)(54906003)(36756003)(2906002)(8936002)(8676002)(186003)(83380400001)(66946007)(6916009)(66476007)(66556008)(2616005)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?npMNOtyf/OWLp8ECq2BrPBRBU5D0Vs4cHX/5Uls3nNNG7cdvx7fC6Rm7W4sG?=
 =?us-ascii?Q?3sb80+qeYdNoFNz6d/wOUlosu6/BrE1w+FcZvAEz4O9R0B++avSrZ6aH4fnp?=
 =?us-ascii?Q?CthEZJKc/IQw6F2T1SJrF1QxUkVRGM/DMmwfz8QDRGPSp4+LBrxCQBTN1NK2?=
 =?us-ascii?Q?+fr8EsRIHj8NKccVCxXTRPheuIuNokPioDJQzpBfK13C5PxBx23u3jsFcwFt?=
 =?us-ascii?Q?It1jt03KTZIZmUKAgIq/8kfAnSrk0/bkeqAJPhbpHQw2a7T7LxP5EOAbJ+qQ?=
 =?us-ascii?Q?hSOvEICY7J7ULZD37ovRJ59rD/r81hw8qg0a7pqikIVrUJjYRxHulUrN4Whh?=
 =?us-ascii?Q?3JBRJRVByZX1qV+PK3rEF9wFIb06YbWE3FuD/TJtpQuFR40fYxZU0tc4LWEh?=
 =?us-ascii?Q?OtBi5FwT8mfe/D5H5zG4xP3cuOV9wOqFy4VLGfyCTdcfA/9d9iBMfHiUzhYu?=
 =?us-ascii?Q?OPUUJKKOvZmqOnYNGfR3wTBJCAVgYFyH7LGiLgWtznbvqoLAHDS7Znu2Cj7N?=
 =?us-ascii?Q?WKk6LHxHJYZf8XERt0ftj9GoSLL5umptd93sXWr1FKLq3Wtw5JcSobuXOLea?=
 =?us-ascii?Q?3XJvQkAIf7Udo9+U4kisMKzbzXxnebtMUJEpwkJTkAqCyVpRk21ewbq56Hnx?=
 =?us-ascii?Q?TfR+pChkxwfpVypf09v03D2i9BufMoTnDlfwXM0ztZhad17zQikW8jiVdQT+?=
 =?us-ascii?Q?QvRrl8gkMWKbi5Rw4pdd11PHonbKjVj2b/8zcnX5u834rKrvLb5uIaUzYfGC?=
 =?us-ascii?Q?sMPAaS9biNxhY/8u4B4nXbr3O9VRIadxev8vx7fcTSQAb18b0seZBjJfEJMB?=
 =?us-ascii?Q?ZOoHBp9KIU9yalzX8IaGZr18CaiNDjk7xvlZ2gB7lzGLkd2c6/Wa7q+DrlTA?=
 =?us-ascii?Q?3bDv+1AstYU23zl9Ihx97aKr4Jn54qOnW/iPDuJc7QxYOBVdwU1Gc40Vl7U2?=
 =?us-ascii?Q?9KKIV5TzW6Dos5g4aK/QWus74TvzRZhPSasq2OtqVlXPU+ey+/AqbebpKfAb?=
 =?us-ascii?Q?9nq3MM3u7+tbmdrgR90V4xehjywDEuJCRIlCpptrPcWGfoOiQc+p89IsLygL?=
 =?us-ascii?Q?4IsDGzZ+/q2LSeSj6T6sU8G2TBSDvte48+DfLJKjNPgnZ+5qxuZB+XpgfYyp?=
 =?us-ascii?Q?B/ineHiv0vK8UzMt0KaVBngA5jTA2DIkNeHnfoV4ptMubbx9jA4V4d+0m2Wb?=
 =?us-ascii?Q?9LLISOQCTslZOSCpQwVdrZCwSOH8eXgFRdAiOKVA4UzEsAje/JDeX8H5b0SX?=
 =?us-ascii?Q?fx0qb+fSVaZdcoDkbFgIKX5gc41lopOawn6yVDWBlseJu0QVIq79jDRlEHjV?=
 =?us-ascii?Q?LGxK/zBoiub10SAdHpdpJotCuIBEOfQ9F8rQ0XIrKVAUriKvVCuND6keQJMI?=
 =?us-ascii?Q?SAYO6pSBicF1orFbIih/FXFTbJWeGbPncojss/RPoECpC0qTbf7ps0mz43sr?=
 =?us-ascii?Q?vu/yDl/bWDzfI+xUhB5z37tzzvDrJ17azL1lLkW+kdlYf+8raKi33dE93Zo3?=
 =?us-ascii?Q?LDnUf0Ty24yQYNK2VvrQyqmkpBBW5yKZ9VDZ0+nbqfe0H4mg9M4rWq1tVOFb?=
 =?us-ascii?Q?x8vrEl7Ob/ADY2n70JdjSOdjxklLmoXSXl4LwudbItThwD5oKzlezdvxE1rw?=
 =?us-ascii?Q?2A=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af270b61-dc8f-43a0-3b20-08db5198aa91
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 20:53:54.3550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 43Bqynk1GhLB4yRiQYmd6tF/B7dH/nbMZKCoL15UjtyzghkQ0jBmQjKcQ5JJaVtpZ2a75xVL939BkkZF8N87uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5624
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
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


