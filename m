Return-Path: <netdev+bounces-1581-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A054D6FE5E2
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 23:00:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B3772815C7
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 21:00:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E7FC171BA;
	Wed, 10 May 2023 20:59:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC7F21CDD
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 20:59:14 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2074.outbound.protection.outlook.com [40.107.244.74])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5A15729D
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 13:58:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CTWicWeyFSgtfmRmnRxHvOj1L3ypDkVg8I/TqQ8hp45KPm7oYJA18+s7ivK0zarqCbXY3/FSK31Ga7cgd6t5pnd9ab3gEFZRGvCk774qVIznp97qtam6FX07oy9am7qHqzEYSSUmf9srKcBA1quYyyLnHZzuTvOuw/jMO6RZf9OgRT2iK7PDOvYSFCwAfhbcojL+4rTVr0DhwSHzkdBrHDGTK24xkFavonW9y/VqR95AOjWtbkbK9n1wzV9XfmINH8LCTL0Dh0/Gn2hgZGZKeTMU4ZtEmEmGBURcZxsVXyr0cNYkz9SvIMonuqtV+JFNvOyctkDSHuZdifLs0B5SCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c1KmTdOfEKSuPeNZeRYC4urBdlOKgDxcAA+qdlwQfr8=;
 b=HRxIEZGvtIIFRyIYTU6U5eaWsvvByHxPV4NKKPBjmgfQWiuymhGJ/+8WgXAL0+7NiozuUbNyGSyek+/CNxIJMDk4El7A4GKWwA0nhobr3ragboyZu4QqTWAJD0v2lNueh642/obEwdUbF1IdtquTCP1P7Ys1h/8F6n5k2XVmyp0Qh5axlo4PY7athnsSOzv9RAhwYz+h+buW7/Sdgdw6ut7VjG0nalaS8bztQ5dCRy4pX8UWGcFjaRGmqbA7jE++C2aQQwBmTbp25ucVZ7t5wxeMz0hAR7SjTSrc+vJpbMDRGEl7yYQdpXlJi5kfPbySm9Xg0kV6q69iKSa8uHvVQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c1KmTdOfEKSuPeNZeRYC4urBdlOKgDxcAA+qdlwQfr8=;
 b=YLeA9Yf1SGPutlcOM0gDcAtqQ0MHnOCjWkiludg/4GlPzWw8BdZUtXVzfgzzLxb2yaHpvaxtAnzB7hhOihMvQmqz7RQsAosec9ZRv7JifetSEUO8iENqwJEq3iI6k29+exAuoVUg1rAPDCLiPguZGHUR3Tb0oVqvZ7AZojFzSqXtw6kWA7zwOqPN8f+EsBg/FkyoZvTidjRJmgDHww9FX4NrF8y+xHGTxTmVv6pMgRqP7iYsI5U2USMlmZKDXxT6sn81K97h7Oq6d1uCaU0i3bb2xNHozZIES7aucRJJUmBDEEi48WpcFO6NmblJsZuDi/FS4iz77PNrH7OMgaDHYQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by MW5PR12MB5624.namprd12.prod.outlook.com (2603:10b6:303:19d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.18; Wed, 10 May
 2023 20:53:52 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::de5a:9000:2d2f:a861]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::de5a:9000:2d2f:a861%7]) with mapi id 15.20.6363.033; Wed, 10 May 2023
 20:53:52 +0000
From: Rahul Rameshbabu <rrameshbabu@nvidia.com>
To: netdev@vger.kernel.org
Cc: Saeed Mahameed <saeed@kernel.org>,
	Gal Pressman <gal@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Richard Cochran <richardcochran@gmail.com>,
	Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH net-next 3/9] testptp: Remove magic numbers related to nanosecond to second conversion
Date: Wed, 10 May 2023 13:53:00 -0700
Message-Id: <20230510205306.136766-4-rrameshbabu@nvidia.com>
X-Mailer: git-send-email 2.38.4
In-Reply-To: <20230510205306.136766-1-rrameshbabu@nvidia.com>
References: <20230510205306.136766-1-rrameshbabu@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0035.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::48) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|MW5PR12MB5624:EE_
X-MS-Office365-Filtering-Correlation-Id: 4be20c72-023a-4555-3aaf-08db5198a967
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	cdlzp1trc+ZdcWF16RXHCu9zn/MyTImLl/eWndzCBjW2RS8W9vbCv1k6kMYcj2NGCFlvMmMwO0KSlLxRybwL7nbELA5tsBa/J8JvpzbUu2A5HFpr9+me6xwXnl968qNVgeTlrK7nK3adMxw/6EaQlr/W/W760iqAY7w6YbDH4bVmh1QhKwrNC93fELtEIew4vlmDuVvtVaYRee1NXn5F/X3VbYKnX19FSioFXhAK2zZTl6Zle8tv28rd+5RnqIdatOWBW4SZnpxPDzhoiPbUrmn1e717N2ve8Vg1lcUtg00gp95FcvsGbhC2cZiEhlPacptcpT/gIiFMpzUDuPMPtyBfUW8wFhFtrLuICihxuvvZVTVgFDRmj9g7N5VrApnnLwd+t3qvkswd6tSeOY2rbjIQMa+RUEOk9ve4BEIIIf0kJue/3OgpbkPt2gE9foQkE8i+OwK4nQJztytrP/tKgTsELxW0au8r9o5pWwQEhTdu6O4jb3Z5urRzB7PnrVzLuASixqXiRbpxjKpFo4wZxjnOordH7QhJJY+oCw3M3exNo2jjyuHTrteCLouuph7l
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(39860400002)(366004)(396003)(376002)(451199021)(86362001)(5660300002)(41300700001)(4326008)(6666004)(38100700002)(316002)(6486002)(6506007)(6512007)(26005)(1076003)(478600001)(54906003)(36756003)(2906002)(8936002)(8676002)(186003)(83380400001)(66946007)(6916009)(66476007)(66556008)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?48Xw5OWM4EmS+kLG6Jj9Rl+ooW/4OYyFvbKBAVQ/bIywxvCB69n6XZg4ZGgx?=
 =?us-ascii?Q?czdwLt4OXmAIIp8kK4KUs4qGbG4NGw+unHwRAz0CGqY+GWUvVH6MzTaMdTyh?=
 =?us-ascii?Q?LnUpP3CQz9ysyINkyQhkusf0cTuHhTXwxg7b3pilhHxO7Zm5ZL6aK9ui+zhl?=
 =?us-ascii?Q?6ByzGwMYLsyt/J/IlKyNUc2RrNOeZ90wadIRzIHMUWC+doQbcbginspHq8O8?=
 =?us-ascii?Q?+LDV5Le5D8pcC+M7anPwVLv6GiH1FQ2doHq65bd/cBMAos8TWEo5onTWqjm9?=
 =?us-ascii?Q?CeJfsP6rLpmXBSTl90/v3tGCFhPx9qxEaR96mgtWeRaqIAnxvGZ66GaBBgyk?=
 =?us-ascii?Q?5gzLPhntr07DwD8GmulHU85nOWVsVCLR4XkkYMhNEPfF8H9iLS92uloeyU1e?=
 =?us-ascii?Q?jDhoHAOt8jHwUyWP2skmuJRiifnwafDy0Z1uUDyhDUgiR94q5ZXY0wZwSzdB?=
 =?us-ascii?Q?xDbS4cSA9xKuFgOQRQIBcN3KFOHbcd3qx83DumaDNWbP+cMn9h93VuGEJr5E?=
 =?us-ascii?Q?ZFh4va4K74UQWSTOI716HciLqOajyMWt80w0FDI9WdkssAT9nPAAgiJwbwiS?=
 =?us-ascii?Q?8TWwh6/jcefS056uNfQBsLhOrLlcLDBJSxJJLvsJTlleWOHk1ZnEM0JLcEjV?=
 =?us-ascii?Q?lDyWJ1GIJPhsLFpxF/gycX83nA22o46UbLj/g/CjZHbJGW2kTwREYsHA3tnU?=
 =?us-ascii?Q?U8JQeFiOG7qvTykT3YHvgQKAQQ9UyOPhSrFEzys8Q+kp5S92mGcSQUHdrAqg?=
 =?us-ascii?Q?xgcYsr7PW3RudRFf+qeUSzfTC8GWm4TtFPavVFDPO1JHy1gWcPaH2LD1aMHX?=
 =?us-ascii?Q?CuXj5Co7MYlOCSWuA9PbPNzRJQYRjlqYp93xNRjjwcCTuNna7XbeNgZDIzE3?=
 =?us-ascii?Q?/wjlzYEbMr16pKx/p5TmfsBWx0axhcaGRQoasvo8aLFPVaHFwCEbdHajMZDy?=
 =?us-ascii?Q?TWu6ewvvxmZKIwNk1mN/dxfCTwC68b7ENyuxcAF+aeOqAgksMKdNgNvviw/c?=
 =?us-ascii?Q?36vmw094CQO9C8nLjVIh3qzQfeN4FzR4KskxumwGEWj3jq5O7/v6qH6Jh/e2?=
 =?us-ascii?Q?MZWQHgRGG8yyRsErbhWog0PWAJ895DeXoQRlYdXHwV/cbIOa6x6XGe8AG+Se?=
 =?us-ascii?Q?4GweJPv+7JTbVn4YbF49A0g7OGJa8nyEiRzOq6nFZGXQWn5N0gm9MqDnNQez?=
 =?us-ascii?Q?oCjLeJ99jBZDOUVG0JP/fmSUlANxuGaFf9+fH27UQxdkH9Z8CUbV0ufBbxAn?=
 =?us-ascii?Q?nmA3zugXBeKvvW1UZ3VdlWaXKTNrR1Erp+Ml2EVWT1w3dnvfkN4eapx9aeAp?=
 =?us-ascii?Q?15S+mu1+OetLlZGie2aoGT1ThalgTUNwRCzIy7xJEORQU9TEI1JUT4H4wOLw?=
 =?us-ascii?Q?ENo+WirM1sK9Jz4Fova1BS+ZiKbEIoQ+fYJo0hVkO9am38nU/tUHX5zGdt1a?=
 =?us-ascii?Q?fZjsY77IQ/G4q9eBT358s53FN4aHAeGx9Taru5P/XZgEYSozvp1na5uyh1JS?=
 =?us-ascii?Q?f4UvbjehPplULek0oTqaHNx4sG/dGSnW++oB5Hi36Vat6E14zlF07b8NdSZF?=
 =?us-ascii?Q?3L0RULPKKPWCG+YXJX5hkGdYgdT0uf0PQ3ioRJ98zKBNis6ZJn/wMzRqENZJ?=
 =?us-ascii?Q?VQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4be20c72-023a-4555-3aaf-08db5198a967
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 20:53:52.3949
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LPUZmESEoFj2Gv43SRiAffV0dqn+E15wV7iw/GEHhpijxPG2Mp8ghHLpe4wN+mg15YnryMTEAQ4sn0KXm4Rnlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5624
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


