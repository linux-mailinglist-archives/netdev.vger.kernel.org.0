Return-Path: <netdev+bounces-10242-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EA4872D31B
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 23:18:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 24E2128107D
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 21:17:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B37CC22D69;
	Mon, 12 Jun 2023 21:17:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1647C8C1
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 21:17:16 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2079.outbound.protection.outlook.com [40.107.244.79])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5417B5273
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 14:16:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iCmzkFizh6uaU+lCYo5fjvegni2bt2W2GaAc65qbntauM70wK+rNL5NwiH7eOkGUZztOEsr1KSt2EaGieduMxVu+JdlJM6SC4WJ77QvLeAG/ruoaN8i7smb8ed1QvwXPPQcpnIbHvJ8hAuNZzaOhEzhJ6wmVEhCbX5ND5IWRExzI2n+R5yxVAjlqUFlDjOcZzeBRswbkvz1CChLGOmbl09e2YYgP5OsH7VHBU49K25A8IniHjoPPzW9OHqna0xgiaoQz1n/K0cBJbMAvRKabJhJtPmOqpVY3/lRylX+rOM+PZvg5rF7mV/maaXhxWqI4uzN0QDPL1yKAvAy+QwLKUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=35R5oB+HaDMvV5rRIv/nnXEuLvp8BO3QXdvwtOZf8GA=;
 b=U9Z4jZNqEtjrhEktKKCgPhtwYnaytn35lzfVj+mlEpLLAg/o4v3drgsJmzDEEySZlk8QMv6gscqsVZVyg4SE4mRiOhbyxtbSg5ScoB0llenFAukP53X+tt70dc19H44K3pdcfRFk7hanFLG0nTqca5ps8JEgZG7vd5Qhnj8J3bv90HQk+STz9oPXTXxq4q66SSI0i+E8Vo7C1IMh4Jpmsk2RuPnI7PFiEZYgD+F863j/Zg70gQDJIm6HSaOywY2/UKHhsluf88WrEgZhZjjfCsOFy5RZ/uRgn4tANNaV9GjLggOmf7Vo+Sil5+yqlmZKG+CMTshxstpsO1OZohtoMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=35R5oB+HaDMvV5rRIv/nnXEuLvp8BO3QXdvwtOZf8GA=;
 b=pqp085Goo4MIkxpKiS2+mN4Yq6T5SogIqQCuBZpJoohUlMGr/gmDVLdbBJNxYJc5S33bp0RCVVzHsPS+iu5gX5LBy8RewRGTBoNIKJWhgY0zKpTacWKK7QSDopJi43QfUD8EGv3dh5AK1ytMXnXgv/rX7BCYofkiPryiBu4vRupMwa32wgY3e58IB/3uZimmQFI5I8LDZUybLYNOKroCaJk3SD7snaFLfXESMGGg4EU1N4vXzidYQ4RiO1wMWd891hlLYdBJx08sJolNvDjjGchOgG8ZqiuFfHgJV2gNVKntoBGhf/i5j1DulQjpC8eAB3k4rH44eEm0Iqd2MFNPzA==
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
 21:15:59 +0000
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
Subject: [PATCH v3 3/9] testptp: Remove magic numbers related to nanosecond to second conversion
Date: Mon, 12 Jun 2023 14:14:54 -0700
Message-Id: <20230612211500.309075-4-rrameshbabu@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230612211500.309075-1-rrameshbabu@nvidia.com>
References: <20230612211500.309075-1-rrameshbabu@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ2PR07CA0017.namprd07.prod.outlook.com
 (2603:10b6:a03:505::17) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|MW6PR12MB8733:EE_
X-MS-Office365-Filtering-Correlation-Id: d6740059-b27b-4df8-87fe-08db6b8a3054
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	H/OGN9Wm88xeRXqRH0qgZpvOEO4S8ROVqLQwRB+oOgIu120kdpXHdXxSzRnFbgxHPFVn/QQsbN4Sr9zdEjaTb+YqZn5p0Z9CYYzqCAhJRqxwNZ8b4KQGVYZZmlnbpd8TXC42pholoDmIZQJURExccj6PJuyVKgVrQWymUB1ukM4GJbBDahBYB93mzb042QOYr+PhGvnBAC+XoN+NOoes/NaeVy9GrbGjDAfVSEXWeP//Lngc39DNfSqH/obVYRgK77v8O9cwfVUmHcyEpdOJqknVygOrplXRKezFSQ9YrGrun1Y/6T8oEU0D7fVbX+u5lIH0VMeY3W1hsSTyR8lJ0HoNPL0dNtkSYiSwuIXhzbg4KCfu9KVL3+M6TZEB40yem1W4iEKmhPKsaUXn7ZulMZoVRg2v4UF5AJRRTTvbusHTVxaXjOx2JF3pk4kCCY0fWyevLp9XXyl89ukOT2IjxktZ1Azy9tmmksFR/nTPxSClUP7DU/NtI606nl+tliUS4lQEpFlfwsk2P9dmWiSB6zLP+zE6vFg4A5GP0tsrVzQ9PwuKKGQwu5TIrhEJLOrw
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(396003)(346002)(136003)(376002)(451199021)(6916009)(4326008)(66946007)(66476007)(66556008)(36756003)(186003)(478600001)(54906003)(2616005)(2906002)(8676002)(316002)(41300700001)(86362001)(6486002)(6666004)(6506007)(1076003)(8936002)(83380400001)(5660300002)(26005)(38100700002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RY4a/eSXzJmIgMPp4vkJ0zMn8JWiRlVscHHtiztPnovAqcWYO3snrVa2dfc5?=
 =?us-ascii?Q?KPE1/meE4q6J7IiFWoJzzV0Ve8wm7DyHhSLURYDNPt8PVNdLg1bizfQYU7g5?=
 =?us-ascii?Q?YlZjWnTeRd5kKDSc/iayuIbt6/ccDBj0MIjaoxk/go4XFJn0J3yTnaWDj6rO?=
 =?us-ascii?Q?NzTPCp7G4neq9JQ+pNhE6yPyMktrRS8Ch59RehQBtNrtAubQNkXSkSv4W+4R?=
 =?us-ascii?Q?03uZHK2l5py9x11XrHdECKefhJu0DbGOQXzLmcmybBvTdJkgsWoroV5xJKsN?=
 =?us-ascii?Q?0K+odav+v86UAz10XJGwno4nko2kJfZRAWSAKGWY6yw/B46R9oZjGmo4vdli?=
 =?us-ascii?Q?mICUdaLNFReJb0fSZapUm9e50ptPFTN321gGWrXa/38xzSnBJs8+a2eP5R+K?=
 =?us-ascii?Q?ULEyqdSAJlZLOznoCvKBxaJXOxKKRJetfBTIzwF+RdMeNJtGucLvoBPmcqd6?=
 =?us-ascii?Q?17b0lJayIee57AZV718ruOZo2/tO0RwsVr/HRSa9/ilOCssPcpWNLk4VIiLR?=
 =?us-ascii?Q?wC1iskVTrOHy2LiSUk8+ka8OfHaSwlZWgTXGpakmn0Q0dxTp3DCPaoeOSLJm?=
 =?us-ascii?Q?kRazEJmmF7paiZzw897L1ljZXaNbr87iiKLuNhsbfzsemKSztxtED5E4wEqh?=
 =?us-ascii?Q?nzw9sGN9D/3P/SiHpwcwZ7VKBr8al9WtGqj6inTCY8TQKpImdK6MZH7qC//N?=
 =?us-ascii?Q?3CuNESkQ6dTrkCA41YMNo4/vK0rS+OU3WuDffbNZ0zjNxj3sWTTsbOIV8Xfi?=
 =?us-ascii?Q?6bF5OVMC0LsRDEvS7ryhq8ZLEf8LY/g2SgKAcctFKl12b1WcsH1/Ta2W6AFb?=
 =?us-ascii?Q?qNtJwC1ewZEx98C8yQgusAW0NvUSdVujYK64LD9iyQWxMVGWVNS5n3bP++kf?=
 =?us-ascii?Q?X5EmTeR6CEkSF9wBLrnyqFTCMJ6E0urhTIhK+jIYX5WrWLGrrX/GqKKK8wzx?=
 =?us-ascii?Q?yMnkiO10r6t/IrnJQj2utZgjyXnaSTJu+2C5Vhq7SwnnY2OBgla7rHLHzCIY?=
 =?us-ascii?Q?Z3VPK6Rb5OjU5pZ3MOGSVN2Q8cbUtAIwG0CtdGOYbF2aIpFnyGjAqyM9cqrK?=
 =?us-ascii?Q?UMb65g2K34UUDAdY1ljBv1ckNdhIKSDC1oH1O6CgQ4STjJbYlwiwMteRSeu8?=
 =?us-ascii?Q?CIK2/fPsCb7BkN4dKhOYnQDCGi6/4o274GNTdqjVgiypwkOuxY+Y09hkVmW2?=
 =?us-ascii?Q?Axva4JzzcQfrqLOYSEW1hQ5uXo7EREzAgfOZAcpccVWb65oQPYVnucUVeh9/?=
 =?us-ascii?Q?+fAYtOGs4sJX9HPsmt7cnvF4dj+1Zx4TQFUZSN8y3UvCOuRB4ekmrpoGWB6m?=
 =?us-ascii?Q?W87NdzQ3VDjQY18As4rKOQtUTwPZOKo8nLQCPaMPWuWVVqylRYWPNiWbeEDI?=
 =?us-ascii?Q?xzNTXkk4uTgJWliV0YulWGpTlpmPlsy3wEYJl4pD0JNRfrCRGZXqsuH2iyut?=
 =?us-ascii?Q?s8rB+EubY+dahlUQqD18j2h8KWPnDroakNp1cYSysC6A1ZatMnjGdjcCDNeg?=
 =?us-ascii?Q?yNt/PVb9FDvaY9YBHGA+/s71SMVqtM5vZF6/teL9NaQFatjyLjs/bq5ooKc+?=
 =?us-ascii?Q?KGVUHYJGa9hEhRnK24lWCJlErbtDSgSqrLVzVXEEn/ua6F2p2BtAQPGJYMMc?=
 =?us-ascii?Q?/Q=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6740059-b27b-4df8-87fe-08db6b8a3054
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 21:15:46.4782
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: INk3Yqdjwe8TeBIrbHpHVOh1Em+0zcJbuD2xgRQrgVFYJOsE7sqzgFHjEp3f0sEACcB9+AMrcVPn8B+Mp9aYZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8733
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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
2.40.1


