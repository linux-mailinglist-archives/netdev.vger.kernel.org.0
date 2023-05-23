Return-Path: <netdev+bounces-4804-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 789C670E6EE
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 22:56:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2D259281213
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 20:56:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 186ACBA45;
	Tue, 23 May 2023 20:55:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3F7A948
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 20:55:24 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2056.outbound.protection.outlook.com [40.107.94.56])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4531189
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 13:55:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JvwzicnS2SAapf7OlIdisOvTCmF6yX4Wc50SYXIX6B4oa7uCcqcgBSQ7EmxnNzJ+qITRfWzs9mxqCt240qEN05YVkDhNghXsbDsbeE0uU9vqHim9UB+3KAHKPN6XnyiBO1qkfku/EYwcdXYh2UZKcWb96FJfmyQlopJ+C4S1yRzMrMwWcKyDRSOj+WD9eN+bzbyMDzukeKupsHIkoebUN2+34wzwrFynITyc4TgDLaa5kXg7Pf4TSpn4b/KmTIVSmlM8LWvnKel4RLl39ujzoJVWRUdVxObaPq1jkjcCd7PfhRJO3/kihEUt5o64jPdfo3FuyjjdTXuPtYHfMt0Prw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mN4YuAu4XOLQRKtUn5zAODG8P0tQ3lLj0rh5n6V0F3Q=;
 b=BfG9ZsBxeiYQHlGe0W9OD5mAgGB0+ZCWflOVgiECt+WU5D5ELvLfAB2HF6zCJ1sKznnZFY+BiYSXPJHJRZaFniPuMQCP+rB7VfptNY1Wpcj4LglDypxoLNaZkdMpsw9tin9sQ6IbiDOBNDywT5o1bdGreY6C+ptYwL6ADX/4878pPA4wxBdvkBjCqQh0TReAqKUzEGoPRRmUhtz1hNP8cnxmERAiaiCALYxvtvhOSobT2Lr2vF398ZPPwwt14Edx81tzG0UH8tubH+eA0yq93I7oUCb0+3IIjbQOqdxAml0HPx2JHV6+CfuHxNY3E1Yi/m7HRO9JxgTt+iAkvJ97Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mN4YuAu4XOLQRKtUn5zAODG8P0tQ3lLj0rh5n6V0F3Q=;
 b=AH5CJSpYS8pSJV0seXpEp8LWTQIYaPmU/WfRzXA+Smi88mGd8t6HZzF1JxP6dZojJNyegmuc3CblUNqklnUeQ5Vy02+hTThBRPrZQn1oP18APcowCZgvWXwZYJz/JJ0jYhSd27NwQNjIv2SXUd6B6VghsONSTUlE/A9iW4xLQ/1w23ks5AFVtbN5BXaP1yOPr1WLdpRD3OWFrEmkwIcmii/KnJc0RYJTn3t/UT1pB8WTVvyKAcb6/xWyg2v3j2Hsz7SiLHkibpC9viYJO+Vce9EOX0EBXco7pPYlZceQ563I5V435sk1/WGR/M2TR8aPBr5BDbPf888xRUhzvYIk8w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.29; Tue, 23 May
 2023 20:55:20 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::f3d4:f48a:1bfc:dbf1]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::f3d4:f48a:1bfc:dbf1%5]) with mapi id 15.20.6411.019; Tue, 23 May 2023
 20:55:20 +0000
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
Subject: [PATCH net-next v2 3/9] testptp: Remove magic numbers related to nanosecond to second conversion
Date: Tue, 23 May 2023 13:54:34 -0700
Message-Id: <20230523205440.326934-4-rrameshbabu@nvidia.com>
X-Mailer: git-send-email 2.38.4
In-Reply-To: <20230523205440.326934-1-rrameshbabu@nvidia.com>
References: <20230523205440.326934-1-rrameshbabu@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0186.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::11) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|DM6PR12MB4337:EE_
X-MS-Office365-Filtering-Correlation-Id: 67cf0fe5-75b5-49c7-bb9b-08db5bd00558
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	8z1NNiGHt0NELYvKc6/JWnEKAg3TvTrCsFiVunVpsmrO9o0/3WNZ/VY5UKwAM2S+gFB1eK9rs7ru3b+HQCGppOt17pimAgEQAZ2oHXme/t21jhzFqPbkvDKKKwO8qipG16Z+q+6ee2LWfktRcH1cYwRepOA+E4ZMRt5HQJp5GDNsTRAK9ZYbIUt33YpL1h/yDzGTCNFojA/5uuEf6bAWzAjeR6yrAmvHATibVU9B5c4oBa/u1DZC39YOCAZDycSXNxtWkktHF+loDSRBjWCwTFT5ADLR+Nj3wNAbpwIjDB6zbj0nbypMN0CsoPphRn13niqWrS+bs5tnL15MRVtIjY7Kg5DIAKjPfRSrGxXSNKFigZGjs8boVlEnTRrQ61+PLvpUG/U7O/obHNmhHLRWOZl2wRkH3oGnPQNA1UhwDru20ztbGKDwIwxZMsFh3IcuigredSEtYBKjirnYsLFgUroL2JiTWmwEj9xby5sWGN5ij1vWyPYvkv6OztBHF+PoRn1HkKCWZn8nkdyQL7WWsW7RgZZOcwcJx4C/iWi+Cd5c4ANAWmog320jQt7pCCgm
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(366004)(396003)(136003)(39860400002)(451199021)(26005)(186003)(1076003)(6512007)(6506007)(2616005)(36756003)(83380400001)(2906002)(41300700001)(6486002)(316002)(54906003)(6666004)(38100700002)(478600001)(66476007)(66946007)(66556008)(6916009)(4326008)(86362001)(8936002)(8676002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?66Ru7ec5hwPD3DXpd2F28u5RC9dAxY6ColODCX2cqGcRQuXRIT1xPeh+krhk?=
 =?us-ascii?Q?bOMKMhOCRvOae/aJpGr7s4zSgFY7/pHG7Y2SgrdP0F2/+ud9d1GO55TLkq5G?=
 =?us-ascii?Q?hET4Ao76vcpqMF5tDliavA/HVMSSCJT4nLu2QAlUlReyiAm5tyTDxrRn/brD?=
 =?us-ascii?Q?/wL2iInEClqqKiOWK8XwVfqQgP7F0F811x2/8yic+11dussEET56ZKWf2b/0?=
 =?us-ascii?Q?drp6mUvZi9QSRuBhrwR1jW0dpjauBVc2Bze3H/T0EowvC33vgR1CPf86+Ew/?=
 =?us-ascii?Q?f6th4pu7M7BAst84yNHeUacF7IhZLvcx4CXeZ6qZXslnE3HMqynImVPrBcTa?=
 =?us-ascii?Q?aVk+y9qDWXEkXDk3oOTFWtjunvJu/Iegp9NF357Z52USnCCMIv52Ovkt+Yv0?=
 =?us-ascii?Q?opwv+RRaPZ/IT66zh9TFQge8zhLsFgFrn0o9DdXd+We3vRq27ox43Y95BNRh?=
 =?us-ascii?Q?e9RUu1Em8K4NvtqLI3qskabaASE+4wNrNQdDjpYEgPlR0UhU+aC5PtncX6IL?=
 =?us-ascii?Q?Qr3D98eARrF4VgD/4JPPAdrumj8Q0gvccTUQujtp5ekJTcystKXzziPb8uAK?=
 =?us-ascii?Q?9kCimfR41ip6mFZfS8zpUoV8Wg+EQ2iKHkb/c3vI60+Lds167cgaA1i/LoYR?=
 =?us-ascii?Q?xm91liTOoyXlC9FFEPxs/IptoP4bshB4M6pYRF9Vwyas6IrnYMdhCqsZsNLb?=
 =?us-ascii?Q?NJ62GZNR0/CX4DXqHaKOEXovEIp+0EA4Lc82LBSgDFfCTnW8K2Jcyja4cxBN?=
 =?us-ascii?Q?Wfe2WGaQJsjaMn2cBVc51M2xHjMJiAin9fuoZjC9UFBVO1mghyDaVfqQX2fc?=
 =?us-ascii?Q?4Fkmot782rDgyw1O/2fyCYcejkq6HV+mvUDJxR6qbME9dqdW1lnIfis0XyTm?=
 =?us-ascii?Q?eTOH4H8tZ6Nz5qUDVw6FKXDvTibGlZ/qXJyie9zPczwnkgtgvhJAQ5pOxGvK?=
 =?us-ascii?Q?5vAUKvUtm8S1BX23cAPzP47z3hepr39QpULfvcmBUQj+xXhtFgqDNaZ8nYtu?=
 =?us-ascii?Q?jalfRZE2Hkx38ZV2Jhqd0jsRGi8fvBp3Un0DxvXkylFVU4t3MvMk843irdNd?=
 =?us-ascii?Q?VPm2riIITXU5KmxkVR5clL1Dozk0b02BA6r3uCq36b3zXUC2Y8ZTx6ecBHZy?=
 =?us-ascii?Q?D5w6zKwXEHc0sz5R5/P2Pa645KiBVNQh0E7tztRPqM5kNBL7dvsiRrGCXzxc?=
 =?us-ascii?Q?jVRnW1WDGc63f18/lUkOvenrPLUWnLeAX2BvVHhCa82qkXUv1YPG7ijCiIhg?=
 =?us-ascii?Q?ny3SAQUydISAxzr84h7xGh5uxalH+RdWMJQ9u4+l7m0wagd9TPVJTjuwOd8S?=
 =?us-ascii?Q?oCML4EYvsqYA9Fs6QdBS2Hlqo2Dv1T6BQdoop2LwDknfif6EERo6GQ3dIVtj?=
 =?us-ascii?Q?yfrxtXxZ/XlThhyRYkZ6qNJIlZxm9pHvjBk4swpVEc5OeOvXk58rLH10w535?=
 =?us-ascii?Q?aFLJOsTmLFC/s+FtejKYdXREqU9ptg4fqlO2bfu0tR45kxr88JNYWJhFY3iY?=
 =?us-ascii?Q?zdGVdYvJhqbpsojFBuHsRU9ifcQd71GKnHNxMnkygxxLJJfQc2k59CMEjUoc?=
 =?us-ascii?Q?KQqIRsQ32vR12WS8JLBVc5tRFCPMzzwqLh6iDXANLxmPKYifZg2mvb2iLx3i?=
 =?us-ascii?Q?Bw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67cf0fe5-75b5-49c7-bb9b-08db5bd00558
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2023 20:55:20.5886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VdFDKJh725erDoWVVhPALiJ9ewA2rbyHWN//DnhpCexRZa2SKokFgy69hTrcsgUqFf8O8/LB65j775urRL/wbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4337
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Use existing NSEC_PER_SEC declaration in place of hardcoded magic numbers.

Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Maciek Machnikowski <maciek@machnikowski.net>
Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
---
 tools/testing/selftests/ptp/testptp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/ptp/testptp.c b/tools/testing/selftests/ptp/testptp.c
index 198ad5f32187..ca2b03d57aef 100644
--- a/tools/testing/selftests/ptp/testptp.c
+++ b/tools/testing/selftests/ptp/testptp.c
@@ -110,7 +110,7 @@ static long ppb_to_scaled_ppm(int ppb)
 
 static int64_t pctns(struct ptp_clock_time *t)
 {
-	return t->sec * 1000000000LL + t->nsec;
+	return t->sec * NSEC_PER_SEC + t->nsec;
 }
 
 static void usage(char *progname)
@@ -317,7 +317,7 @@ int main(int argc, char *argv[])
 		tx.time.tv_usec = adjns;
 		while (tx.time.tv_usec < 0) {
 			tx.time.tv_sec  -= 1;
-			tx.time.tv_usec += 1000000000;
+			tx.time.tv_usec += NSEC_PER_SEC;
 		}
 
 		if (clock_adjtime(clkid, &tx) < 0) {
-- 
2.38.4


