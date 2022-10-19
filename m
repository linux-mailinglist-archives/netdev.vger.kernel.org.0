Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6E716040D9
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 12:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbiJSKZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 06:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbiJSKYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 06:24:40 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on20631.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36EF9E0AB;
        Wed, 19 Oct 2022 03:04:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IOUvqCCJHh1kPPvJ7soZmOjFpP0O8VOJ1pSqoT9H/tN0P0rKOZWEn0ZawaLXaVSWLA467aH8iN1C8arRCi6w5J9rasEPsYCM5r6qIV0cEVxap/zvxxIhIOIlotJCxQBpILJ2ix3tZ408+UrlCBdj2xKhcMEnCAW127s4Wbg0WLATHxqEvoW5xNURiftrQfqJufLtFYndMxvBP5S0vNaSPu0Rkj98w8H2QwUL+TYIJ1xLj2JV6iVE8rPZ4WiawxAS9eeUd4w2DIly/U1CGoiiKpYHhs7NM4gR8QtwGecB7APAG13hszC3vFG4YwCmO9SSRDC5u7PpItH4FNXODSR6tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YdivRuOW9khFBjerESPfO8a4yj+HYn4B5q+Zr77i/As=;
 b=Dfppw33yLleT6tBeP2uIUuH/RNPeURtOQlOXyYN5VkQoWaZ14vn47aK1h1Ik+I1FWdqTzMMWeWYlXwaBl4xTMpyTCrkGZ632ZBJXzyXoo4tRi5IEc7GZEJcGtHac7gbCtPkVLdcBd3qTGAfsUO/b5L2rk1GiUAoZh47jo2SzfztS7nemqSLCJOJUwudTclsg7F0c50fMirol2x4VRq51UnvN1zA99jVjEVf6aamYS1CEsU61zS3nDPM8llPxybbbeNIdgSKsw0QUZTSgGJlEzOSCpgeqf1FTMMPqP7C/uf6rWTgPyFDtbfIiGaPOD707ORkdpsVB9JlB84K6jhUWjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YdivRuOW9khFBjerESPfO8a4yj+HYn4B5q+Zr77i/As=;
 b=kHh7aHzoiZEaqEG21/sis+9tz3zp/OKkvn6Szgskx3r34Z17kW4jNremo62JXo2LjFpo9MjnPQ2MajoVfMuSLVfhc3PdIktv3q8s+Wvv4YJeycGOcH6lApC2ZUYRLmsmEOGOD3Hg24Mlsl4meOGtM9LoXpWaK9vrUvGnvgZ8taLdHd4g7yqFi+qeCmSXAnHc7agFAhLrOzR5TNzzf6HpLqtYkI8tQAr/1fDRPDsY127Bsea5ayzUKilOwgfqBwUdt26fSgslVpH2m7J2d42G5OiqAQyr/EEUv4qSx/4LdLu+RS7wqXLrjzjNM+ZlIsC3UGiXpwVmbS0MxIWT0+6PQg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4373.namprd12.prod.outlook.com (2603:10b6:208:261::8)
 by SJ1PR12MB6052.namprd12.prod.outlook.com (2603:10b6:a03:489::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Wed, 19 Oct
 2022 09:12:05 +0000
Received: from MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::6c65:8f78:f54e:3c93]) by MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::6c65:8f78:f54e:3c93%4]) with mapi id 15.20.5723.033; Wed, 19 Oct 2022
 09:12:05 +0000
From:   Benjamin Poirier <bpoirier@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Shuah Khan <shuah@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Jonathan Toppins <jtoppins@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net 2/2] selftests: net: Fix netdev name mismatch in cleanup
Date:   Wed, 19 Oct 2022 18:10:42 +0900
Message-Id: <20221019091042.783786-3-bpoirier@nvidia.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221019091042.783786-1-bpoirier@nvidia.com>
References: <20221019091042.783786-1-bpoirier@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYWPR01CA0008.jpnprd01.prod.outlook.com
 (2603:1096:400:a9::13) To MN2PR12MB4373.namprd12.prod.outlook.com
 (2603:10b6:208:261::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4373:EE_|SJ1PR12MB6052:EE_
X-MS-Office365-Filtering-Correlation-Id: 12c082b5-be0e-4f72-6aee-08dab1b1fdf4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VhGQMeomv6h0Lg672U/6ucyHG2vKGkw5Lo1Zup5Ip0vPwuinJkSZuRFXDGA1xtpognN8nTukgG+RmLxaG4Q0pbsh7udCaM8Ax1L4M/ZgSd1gkd2Ztfk5PGIqc1QFUYcv9fJyiWn8fC28b4rOUNwHXQRII7sr770QLyuU1jcPmkGMS6ufGowgN9G3gw/9XnSkM+Yo4WL2lwC6X4fDuD/0zwplTRV1XShX+ja5/RfiI4+C/I8ZELTveNu9RS8QF3/xs6ql5rVpqqfKW1/MbZfi+RA/C/C4Kg+Y2punlOUTk0Gz2d5ADwO9Qw113scQb9FJfEPNfrs8sxsSl7h85LT0zixi/uFnjyXTlQ03Tlwu8RcEzGtcGoMpBez3gyzTKHVKLl7ZQt7bAZjxnjktXMpy/aFlx3m8T6nIUGQ/Njehtri6qFPiDTch1GKOyAIwubYTLpQB83hf65QWcvGSkH35t2ohVBXimuxKyR8mP1Kou9/S0Y2w6gtq0oxz6rKd8w6D4VDaln8UNk94/N5mDr92x3oDwd8hPyq18RZ8Dgoa8K2kPIL5U2KcmGW9C+AzazGEz30GT4KCNcW9AoVkf9kz45reOdpPx2JJgGu0KIMPZ8dt7jbZ8OuFa2N4BPHqq48yZXLMiMG4QRcu1rjSKAu5HiKBV+40sVyppdBhDQt0bQtRxDZBWDs7y202+YuAIx6mVvOwjiev08/Z8Y3tXQH8NQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(366004)(346002)(136003)(451199015)(316002)(38100700002)(7416002)(2616005)(26005)(8936002)(4326008)(4744005)(6512007)(8676002)(36756003)(5660300002)(66476007)(66556008)(66946007)(6666004)(41300700001)(186003)(6506007)(86362001)(2906002)(1076003)(6486002)(6916009)(83380400001)(54906003)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AwclQmPMq7hD4YuCkk/eJsFNsW0L0pkEi154V5ejG4ws5ipSZcoOdEFSZNma?=
 =?us-ascii?Q?c5frxewFMp/uoFezSL2kNVW3Be4vZEpxIT7pdU/HLhzk8i2bjhztAvhfE0Un?=
 =?us-ascii?Q?MlwHepgmzf9ySuTpv65I4Tbr36Gsiq0patBireXwA1TODQyBN/jihxc/umNr?=
 =?us-ascii?Q?5JYph4qbjG6Tmb9SkZFjRDmXili3UEDObOcgItR8EMwSBjpa1GmoUYuhQzvw?=
 =?us-ascii?Q?DOD4dU/VtBxdIgmtY8kNBgIvDRak8SnlHoRRrCILfRMD4vCTmPNPHnjj4/hz?=
 =?us-ascii?Q?mpZwA7QS1XvS5vrp8vKo/8Xo22tWTWQmNu0tTNfcPpaCrUE3GfgYPl14J+Fj?=
 =?us-ascii?Q?fs2GxlVNeOue1zi+E8VUKIEDyBqpKj357yQUmK22zDokkUHvCK0sIdz9Rqx6?=
 =?us-ascii?Q?rWXgdItDJi4bKKZcQZZ5O/xqyFKb7X28/m8botiSHD3yeFuO5sVNM+dlWedn?=
 =?us-ascii?Q?lMBRGmKEMMkqUjDEu6Iaf43G5EmT1p7oSlFSNGp9GhFFyBo6uwR6smGRBwS8?=
 =?us-ascii?Q?cHb1uFqd57lX8A1lQKq7BD0DFrr2/TDrHhAJSotaQzemwyOFS6QCDELtag5k?=
 =?us-ascii?Q?LE0HNU4K8dmzRHkpgCPkd1EyIl00XFnuIX6u2kd8ZgTwd2hkZaH5/D5ukP0U?=
 =?us-ascii?Q?T+TwAE305/p2iTtwC9hS//fvvE7I5vFhxfx3z9gIXxo9JP+4zQEoOQgdeord?=
 =?us-ascii?Q?GV3bL7fvHmJ7jTvz8gOl5Im1k2BP+ytq9zoDnQd1S2Kzpid8699eVJ2GW4NE?=
 =?us-ascii?Q?RPnOxINOR/egU2iiV5Il81i9XLkeUrU/S5grKAfkpsiOuw1Ov1cVN64l+kkS?=
 =?us-ascii?Q?Ur6ZW5B98UjvtFNI7AJk6shgFniwIWY1ocZ4JUuzfTMLILVu9Qydk0Rz2M5F?=
 =?us-ascii?Q?TkewncL+T7h7VLc84d0Up2cuKnP7Md3lqrSsTw4lLpgUghfJx6oVcZuCFabf?=
 =?us-ascii?Q?qRbW9lfti2/4kuzoBwDORoPboZ5bCrZ3n1TB7bmE8A8rO4FKGHWZtkoF5Mqw?=
 =?us-ascii?Q?UMNiWyZozYLT9P3Sc1atSHgw8zBMbloEq7F+rFR2Tpgt4bHIu1OY2bNfQa7Z?=
 =?us-ascii?Q?att5r1rIR8lS4o61zHqgD9zORh2Sq7mTP39f+7SQnwjYBtldG6dA283aDl6q?=
 =?us-ascii?Q?xoYFy/Uk0dIBrtsih7iPV0GPZorqkKT4Z9Xe5q2X/7xGoULVh908CM9dKNAu?=
 =?us-ascii?Q?UUHERJHejPH5JUUFz605ahUjGq+8u+SxhBYOVhtwHgkmAL+Tg6FACjKkKJjs?=
 =?us-ascii?Q?0Kaz+5/8Lxsl1c3HPkhNvBe5CFAN+a+UoXQPCZpAu503/1BQOOFZuuS1Y2CX?=
 =?us-ascii?Q?KzTy8Ldn56VahmIcakIgug6OQbVIbH18RZeWFqI3GdETJjoGsjugShXxXveL?=
 =?us-ascii?Q?JlM1FCkQYoN4M6N1YotlHIf75iUPosnc/J3Kow0/qD8kNarBxB57fD/VjTto?=
 =?us-ascii?Q?/NAiktBp4DJNrKxUXbiIWeZR1LkJwe0O+FRjvIRlaZ9dFmSdpZmexq9Pks2q?=
 =?us-ascii?Q?OtqPwVseFSFBpNRiWgH4Wpdfqh7Bi7ZutdGgBwtVGcPfVUeFT24qD9x4kSin?=
 =?us-ascii?Q?S0PXlv06qohLzx8czMqLJoAF1odE4hBKIs5sQJwl?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12c082b5-be0e-4f72-6aee-08dab1b1fdf4
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2022 09:12:05.7140
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B5LVvHsdtgBF6iYlhJsKPSLCZateniLV1xpVW7MZT4LE1LlMF+/hm9ik+aSk6v44Gpl2cPSNCysr/nQ1rtLi7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6052
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

lag_lib.sh creates the interfaces dummy1 and dummy2 whereas
dev_addr_lists.sh:destroy() deletes the interfaces dummy0 and dummy1. Fix
the mismatch in names.

Fixes: bbb774d921e2 ("net: Add tests for bonding and team address list management")
Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
---
 tools/testing/selftests/drivers/net/team/dev_addr_lists.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/drivers/net/team/dev_addr_lists.sh b/tools/testing/selftests/drivers/net/team/dev_addr_lists.sh
index 9684163949f0..33913112d5ca 100755
--- a/tools/testing/selftests/drivers/net/team/dev_addr_lists.sh
+++ b/tools/testing/selftests/drivers/net/team/dev_addr_lists.sh
@@ -18,7 +18,7 @@ source "$lib_dir"/lag_lib.sh
 
 destroy()
 {
-	local ifnames=(dummy0 dummy1 team0 mv0)
+	local ifnames=(dummy1 dummy2 team0 mv0)
 	local ifname
 
 	for ifname in "${ifnames[@]}"; do
-- 
2.37.2

