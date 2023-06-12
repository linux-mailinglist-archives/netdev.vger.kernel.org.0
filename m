Return-Path: <netdev+bounces-10244-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D38F72D31D
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 23:18:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB3D81C20A10
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 21:18:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A43CD22D54;
	Mon, 12 Jun 2023 21:17:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD31C8C1
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 21:17:50 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2079.outbound.protection.outlook.com [40.107.244.79])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41BA9423C
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 14:17:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B3i+bBMiigjjOw78WiajfTqYMuUwmFITXcPF7pufwftaHylGkaJPQf17z72DDmOuTKD1eYUn5+FGmz/KwvOqNGaNpchIew0Wb83XebOB9BBBVNZWuN/Gw5JF1KO0pn3W4sdDVRpbRiFhU/CeHpmjT/jZ36/0UqFkvJ1vwS0Q6jjTEKmYb/4zXmC3zCfL3G5tqvEQVsCfxqpnH0sE0oOz9lmCpnShRJT4Fsfgtd684igsyUsGvrFBBLrHAos54WJ75yTWRRxVwa1sNBYGrMWPP2ocBFtdLcajjnZYHDLmohP6YfsNz83Yuo5X+sBIgIN+J/ijrXjcGRkJHcGwqBNL1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=boXwxr35ZnW42dvcysS/GCarnpxMcc8wKvTFXRvnoHk=;
 b=R+6fXEaNcThtaG+ORxW+aSOvY1zkiP6tYot+4OZ2gX0dJ4PmIOMb6NHunCgPNVZgOekanwHc5SkGlh5Sz6BkIFu2RLlmTjIKbKm5QqyruGBNFeJK8e6rWscp8CbkHrUQofe8/rLls3SWqJoUYbY8kl8tzT7cTd1qH8TXwufy6zDAQeNJghqbrbGgeAkIC3epOmVhzEMUfdXV6zAwgZp488xBoYTwqpHsGXFTZuG/pe1uAjYOUrqmOW8QaFgHaq9r8vt01RYZhEkJfjDlAVX9DvKxkdKtD/XAe+bDQoCJTQcmnwzXp32Qr15qM+NWiUJxQGJfYowV+rQFDlCHs8L6/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=boXwxr35ZnW42dvcysS/GCarnpxMcc8wKvTFXRvnoHk=;
 b=uBYGYzmrIxIqZ5022k1/kEoY0S/RA0F2FHvJ4YQ8PtzN1NGIYj3oyGe4B7kq8lkdJLbQzhxCrcj1ja0xAjS0dKn7xyWQhp1XaVO7w/Y7SNOiw3GtrFCiRglQvqEIbO/2CtAyVsTzDp0lZ8hSL+ey4uGrjNt8hySXmilPlue3PC/bOdfJ02OaGZtWS+I1raW/tsQRCHLh+Szueu74OHOaWRX9BtATab0ef7XqhroXcM4bzVaUuS01SuANijJwJIDpmptvq0JwpLgblGnJrkGAF4NS+ggo/wjtWXyRgaUaZ25LXYojvH2OkJRF3LqZs96SAtN6auf/jZ8DAn+SpIQfIA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by MW6PR12MB8733.namprd12.prod.outlook.com (2603:10b6:303:24c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Mon, 12 Jun
 2023 21:16:00 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::ecb0:2f8e:c4bf:b471]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::ecb0:2f8e:c4bf:b471%6]) with mapi id 15.20.6455.030; Mon, 12 Jun 2023
 21:16:00 +0000
From: Rahul Rameshbabu <rrameshbabu@nvidia.com>
To: netdev@vger.kernel.org
Cc: Gal Pressman <gal@nvidia.com>,
	Saeed Mahameed <saeed@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Richard Cochran <richardcochran@gmail.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Shuah Khan <shuah@kernel.org>,
	Maciek Machnikowski <maciek@machnikowski.net>
Subject: [PATCH v3 4/9] testptp: Add support for testing ptp_clock_info .adjphase callback
Date: Mon, 12 Jun 2023 14:14:55 -0700
Message-Id: <20230612211500.309075-5-rrameshbabu@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230612211500.309075-1-rrameshbabu@nvidia.com>
References: <20230612211500.309075-1-rrameshbabu@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR04CA0035.namprd04.prod.outlook.com
 (2603:10b6:a03:40::48) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|MW6PR12MB8733:EE_
X-MS-Office365-Filtering-Correlation-Id: 67375a42-cc10-4989-58c3-08db6b8a3466
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	6Kcqp/4PC3vx+CdPADnizwme90RfrIDy7ni9p7BradOg73srcgTXRzEERBSaqnMlfKGUZY9jO4MTVt6epaY2+XFhsSQ50x6AHj4Zj4mSah3jAY92vvRRHlxss9FIQhWAhfkOqpfvLb8THV9W0VEu2U6H8+rFyZof1Dgicpt860tHaQ0jsf4qhCrK48uOWJyHdtCiHNCNcZ+Z0Qyv6tZOsPNDIFwxH62sXvVWVY3K5PDyzHl4PqGynVHl9jpNxp9tAp37FPMxAWC5ar8luRTu1gs6YviuyM9wd13gVg09Qae6YA3g2iFVwlJGDNraV2edgIua7pDJ+btBCEkBJSNo7cpMFCyafF+oZhX72xAfjDiAHPEl6cJNaUjxhyfRQi5Va1PXt04lzlw/eMJ5FAPBIv++31lplCUgAjClycShoj3GOBb4+ESAG90O8IIhbpCFqXj+4UsqO1E7a9R4AvpHZW2YP3qkwuu+KJ/FEVOfXJRwduCQAeSZoU03PAluCAjlyPWXxq4x6cgjg4b8v4OuaTfmx+sMn3qso6P9b72r0xI0wA/HgYeqiZ8yQKAiaWMk5S9A9egAM/+c6+bZJc8W98i0fkRIVtcwyQpiHg8kK30=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(396003)(346002)(136003)(376002)(451199021)(6916009)(4326008)(66946007)(66476007)(66556008)(36756003)(186003)(478600001)(54906003)(2616005)(2906002)(8676002)(316002)(41300700001)(86362001)(6486002)(6666004)(6506007)(1076003)(8936002)(83380400001)(5660300002)(26005)(38100700002)(6512007)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4HJwMmtd3gk4oAyGVnz1SxT5mxgnFXLBWv2kNBqoqlbQpnhWV0QVpmm5rbc8?=
 =?us-ascii?Q?0xOStPQ6AMIzqEqDIW/LJ/vy7lWzBNEVD+hsmuksqq7UmZff+uKsBlulXtmF?=
 =?us-ascii?Q?rtVExXJF46KxhrMGGPamnCZVHBD3a+EYPRn6vl7d4tLriSSvjijdV8vFirTV?=
 =?us-ascii?Q?Qo8TWysICECTt7kuFEB7K1rJZz5VZWrKDGahlzerW3P0sxnXuj6Zhtquy4tM?=
 =?us-ascii?Q?nUVDaNWguGZKh0X1PLRgPLRhRJKPlQLmKDQ3G4PVUSPZkzMf3/XfsitZNCse?=
 =?us-ascii?Q?CxJowFqJsEuCh1f8rSjym5NT+loQRp3enyMtq+ksq1e890GQHhz8hFSK+Y5n?=
 =?us-ascii?Q?ZlIASBgMHc9ZC1W4n+91/qs0rHttHhacfVYDXRmRBIRwvx6SBbi747mXLr9h?=
 =?us-ascii?Q?OSyNsCkL4F2bxJhq1a/bC6BosUViS6E5Uo7ojP3KZAn4Qx5FsiDCV96LYP6Z?=
 =?us-ascii?Q?hw51q+bwdSTmvQWhOhkZrBW58FARXFF31tyK60B4x4mDyX79SRyHiaE9IWkM?=
 =?us-ascii?Q?1FoWeKorDzTHrSQ09VxxcmyiZ88k/odXMxmAtmToNwWN2tw8SNonUZ+W+ut0?=
 =?us-ascii?Q?fknE8/dEn1UyYklRNzT3K+RVugCDTc8AMXS+Kes9JvUKNvkavbmYO2APo2AV?=
 =?us-ascii?Q?dMbH1ru9iExGiBNq12uxlrtw6GAB7Z4E74nj9GVqdHl1KKgaf6zpS+l6MJJ0?=
 =?us-ascii?Q?Ibd2LhXH/grnYwyT3qkvcgf2Ik6rdIVt6Gbm1jzzrRgY0g/jcz7q4XSdeeyS?=
 =?us-ascii?Q?w8QXUowRsb+fpCsvF+476JdMHofcxp3CkOLYXb9uF6KclCILIo4HqlNIFF99?=
 =?us-ascii?Q?BdHQoxlr/WN+JsBb44SO1FC27wkPV2lNR0HMIhLVk8xhRvsWkRRdGpR7QEA4?=
 =?us-ascii?Q?0n/PDEdiYFr4DKx4QLwlPWlUofyvibnyNe1o8im+UZFh9ZA4JHt0w7hZaEWr?=
 =?us-ascii?Q?GbAyaENZ73XLEWs8O0K0xnPfqdf4fdg3r+bv0GyXYg+pLvFyRmaPfgF7Y4Yo?=
 =?us-ascii?Q?aPLEiM3vzDXgfwkFL4Wz/QGvKAuExSce53t3weVMrUyShs0OUnNH/W7W8jZT?=
 =?us-ascii?Q?830ciTnQmFsdsk9WEL7j+kvXPpt4n/5lRVX0+kcup4XFuLbRCJEJ4JiUHKcY?=
 =?us-ascii?Q?8t7TGSI0XRJYvsyPGz3F9vnUPiu7/e33Gzmprn77Ka8aMHGxutZ9FbzSBv5P?=
 =?us-ascii?Q?m7cnpnyAuQahcGnPlj/U31Soo69q/S8vkDFWYKTFkVajKbH4wEgSmSu7ifcR?=
 =?us-ascii?Q?FkzGzwndeyWPEZR+uVDBbK8OSU2KR0rWao1tnaEWPUHY1dVE6WsgqFPbTMD5?=
 =?us-ascii?Q?l7xjnsaqPnZytwKjca2Uwd3ntUKpsd8whH2nOLjs9y3aBfCvJc793RWBYe1z?=
 =?us-ascii?Q?WirFHkT85YypxrPxwpG45a0Nr2Ge6Vr43MYZyQAUP2KmxxHNao6DrJxJEOzs?=
 =?us-ascii?Q?9TwJu+jewJwzupoRi6CVSLpr0xJADtXNxN7zJm5ZmUAso1a4PKYkG471FZOA?=
 =?us-ascii?Q?DoXkmKq6L+UHlHQ3ajYeR1LhfEuqVmhreW8J9XU9dkkgzOSnBwJVN5jeC0lS?=
 =?us-ascii?Q?rr2x0O6h6dkAGU1Uw92HmK1w66bHjjkDBBcMxbcYupCK+Uq3DOdV87YsIIeT?=
 =?us-ascii?Q?tw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67375a42-cc10-4989-58c3-08db6b8a3466
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 21:15:53.3197
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fQW7kAdQ9LsH1aAyip9oTFexAtJde1w6xCwRD9BlPJfNV6ELiX3u+0KNoM5XAQpkvvuL1ToMaZa+Ice6QW3/GA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8733
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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
2.40.1


