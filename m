Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D431E58D922
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 15:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242125AbiHINKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 09:10:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243292AbiHINKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 09:10:14 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2055.outbound.protection.outlook.com [40.107.93.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2A25E0A4
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 06:10:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GNUn7eMPCh77GH6dhlexyOEKvxqerna5Ty+yhT6aNHHZUZLAQpn04bFWlkVKP2cTHyX3VfjtfOjHJnxd9Rpl7qkDs+tAjKHiZa5nqjMj/g8XLUCUgaQ11oRiPMeFvLVe4+ZKyk8EB+J2Gohr6Sp5R2/0fDJHr9tJAP7O5ARVperbtTNMVIH+bBuzH0b4nL8xsG4Xp1VTAiMAfx9/U81lfVJW2iZE1Y2QmnkVvbCX98Jidizs/450FAOeTlAIdDmjKIhLAFH77TiZaG33mn4O/8zfiW2cliM+Ocu1PudWz+VVLB5Qs4hGdzv/A4JFHHOwH/1dJjc1UzMF6XwPA4ll3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Y9Yke2SV5Zh5+KCuOfOZEibfEwdof06QPn2Zz8XPvs=;
 b=NzurufanhLjUz6DdmIyEf/EVyh5n38SXpZpkkP+foO6hcTEBjX1v4zRAzS+gP8/7SzeB8rAH9HExBdihQlQx81u8gN+a45KecISieCwzf4hAYaKBGyMy+93+F+OOl8qhSrlBIw9me/DFaUasfK3Dcc3f0xivF9siHuPl7REhdNSOjD7Wapg/xsOJ9aeUUdUmYyUemSB6kyw3r/g/NJHSDBFQ1y0chMhr3bURAkOBN+hfgAe7gurMHvcKrN2jSSia+v0ILba+skRVZpkmyK4367trR4BXcC28tp5dZchSt8fZh7GgH/hOcqEZlmf5QjCVdYGZ7o7tsb+vATIiDVIOyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Y9Yke2SV5Zh5+KCuOfOZEibfEwdof06QPn2Zz8XPvs=;
 b=Hxa5rtRDZyr6h52sWyFGrf0aMCY5aYeCD2eD1/sKfw6QPbzC79mF0FhspR91dSQxLeBnjZVWMosuRYv7AuOcxFXrhwYzuDuINy0kbQEz7OAmrVfoUkif8IXdtQW2jGi/L/CkVrb4/drzoEXOKNFxK/QGOfKBQydaADedy3/gKkepaShG/2MdevmQFr9ER8ZF3IKfzt+BsU4NDsrOGphnfr+Po6zi//OaUwHqod7bxm+8f/Ig+ZdPUhLpWpzl/oVWodE4HNV8QMoeKfNBhaZGWGiKCmfEL0LjAz3aIfBR/Tvi1RnFTtm7kQ956r4iR7IjBhEyqilThlWIAPtjNDE9Dg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN0PR12MB5979.namprd12.prod.outlook.com (2603:10b6:208:37e::15)
 by DM6PR12MB4044.namprd12.prod.outlook.com (2603:10b6:5:21d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.15; Tue, 9 Aug
 2022 13:10:08 +0000
Received: from MN0PR12MB5979.namprd12.prod.outlook.com
 ([fe80::1135:eee6:b8b0:ff09]) by MN0PR12MB5979.namprd12.prod.outlook.com
 ([fe80::1135:eee6:b8b0:ff09%6]) with mapi id 15.20.5525.010; Tue, 9 Aug 2022
 13:10:07 +0000
Date:   Tue, 9 Aug 2022 15:10:02 +0200
From:   Jiri Pirko <jiri@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, amcohen@nvidia.com,
        dsahern@gmail.com, ivecera@redhat.com, mlxsw@nvidia.com
Subject: Re: [PATCH net] selftests: forwarding: Fix failing tests with old
 libnet
Message-ID: <YvJcql9M0CHJ6qGP@nanopsycho>
References: <20220809113320.751413-1-idosch@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809113320.751413-1-idosch@nvidia.com>
X-ClientProxiedBy: ZR0P278CA0092.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:23::7) To MN0PR12MB5979.namprd12.prod.outlook.com
 (2603:10b6:208:37e::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ac0d72e0-0fbb-48c4-ab99-08da7a087b79
X-MS-TrafficTypeDiagnostic: DM6PR12MB4044:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3XCWWLrZknjacHDTHdE7GijBXXDCralIAGuViAmwvx0UTIjiO1Y7Hq0nl0xq6TN/C2BGWKu+7gNiB9SNYQzB39gPHVNEu6bCfP5hRBzW9nkg8g78LAxg6MI91AlexcsqttvMehDMeeVfUSiTm0wZNEyU5XvFe1KoICTqyLHnQRg07R11GuxRGje4PnOZometc8wObL1y2tTngbcsS3LIbcnn3KE4//t0HEzGK6BZJKiWVINDNMD65GhIL6nrhxEpgf9yiaoyrWCQsauTDW9bIaQ4wKqnYZRM3aNzmi4reydIpy9ryep/G5RW2s+sWu0PX0TRhP1W9aicXltWOdGXS6Iqmize8zhr5jw827cUqAWX3GttZeXXXBG7/D7Un/JNCID4vyRa1XBQPLj521If0hWUEl4F4slRh8UMIZbQjcv6zQNNNBGqotCjCPjP2kESlJ8CKkmTl8M9aGvBF6pYr+UXwhDBPL1rWwlMHCnKRB/nL+wDlzxsBT5UitR/bMA84R4HSj74QHFoFkRCJ4Uf2s26LSw9AVylqPtoZzboBR/1a6Z2WQsUVRaHEDCWvQ0OvMxzqnr5E6g3YFf9JW53v3emcYNanY5KFUtZxqrRsNFFQql6x8xlQgClYt/F/XOKWSum6JvITfoIjfTKsWvvtpOuMQLiqtJXTBzJl0jXFvgrM6k8EHDBI2DpuETYsAZOD6ZuW9W61SLpc9E14zUn/M8OQE/e0xXicQ0+ido8L3qSbNyw5+7hjcy46LgKWKPp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5979.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(366004)(376002)(396003)(346002)(39860400002)(136003)(26005)(6666004)(86362001)(6512007)(9686003)(6506007)(66946007)(38100700002)(66556008)(83380400001)(186003)(107886003)(41300700001)(4326008)(66476007)(8676002)(2906002)(5660300002)(8936002)(6862004)(33716001)(6636002)(478600001)(6486002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ys/83l4tOkttoMqepHnxjnKjh7jmWE+ISHwkIUuns0fO8zhVSBHjESwcO6+G?=
 =?us-ascii?Q?fgTuMvtd9oVe2IR38CcFBa8dkmkBWkFyLrzIZ0u8dmqhIx6+hhtNfRc/B8Ic?=
 =?us-ascii?Q?iPbEcdbAs69n0T3235KDI7EBDUDTjHEmte1ou3FyJcmFEESCYf7OY/O4lKox?=
 =?us-ascii?Q?WTkABtKz/sxvv7ImknzeiLZ1WmNllJ50T15u7gPBg+hVN1SWLnxUY1s5BhNj?=
 =?us-ascii?Q?Odk8PYI27bSJjf3H0wRjlJ/m0sfXCMyxygYQiRMMJpkDcuRjQvzMjnO4DQBi?=
 =?us-ascii?Q?Gtr/ftJas/5gvk6J3jlhqvidp69FMRqZ+g4FfMrOmKTlzn/QuuXa17lQxOYU?=
 =?us-ascii?Q?qpEdCHE/Q7i8mOUk71dvcDFyUBteEvlhmV8uHYOivQ8f+XD7XVUinM47ZbYJ?=
 =?us-ascii?Q?+M4NpPM9dD8TB6HeBthZdyLF1H1oIXH15CJWK8lP8carmjy6v2l0Yzt7NUTd?=
 =?us-ascii?Q?1CkGqYVrr/Fx5QUdpgP2GRKPEsdBxJCmrnLxOEOZ4LSFWW2r2GGhOlUnu0Cx?=
 =?us-ascii?Q?2zCESPWEVJSaGsUGXEttJwF7S+omBC3SdNLykxxqvwPyp+o6BDWY6Co9hoFT?=
 =?us-ascii?Q?cQ0p/+MTO8Z9FX9fzpWcugQcEHLd0Visal29X2+U2HjiyN5pRxE1YnBRYxjd?=
 =?us-ascii?Q?v/sp2lt7XV6rOF9Hkz1oDqllgIM+wsOEQHJF/4F+GFjOEO6cuUAzHSQkvH6Q?=
 =?us-ascii?Q?3xVWZNv4UABF462FxphiBWOoIx34Ki2NstIMF0vGcrJMQyrNfZf5zjBdLvpI?=
 =?us-ascii?Q?UuWjNcvW2+QUjivSC4sWJJfqn0ZqZ11+e+fCeyDVpTDuBHS3dMEz3PqMM36P?=
 =?us-ascii?Q?vXnLwptTytjsTPdtUG1zcFrzR0ZbI42ScPbuyLa74mAtz8wtgGvZpft/yxaz?=
 =?us-ascii?Q?ETnt+t4154ltNb/HKyd2Hx0Y10e57oFAn5ZZlSf8MJPBQGJYssyROkb8m87s?=
 =?us-ascii?Q?p8SCF7ZNTv2o0622jD0WB36sBqe555U0Cmb7BY7Aot9JmfSyOHzDsAhmIPAt?=
 =?us-ascii?Q?UNkXDPluqAlDKWL4O4j4+98mlCHlcObMJP9av0FECKENslsaGYOfrG5D8jUg?=
 =?us-ascii?Q?QxMevVrvcPKFtyhiZml+YuCMvWupSNqz5ors3vftBWrX9AlInEzn14LA3+Vs?=
 =?us-ascii?Q?/DbFFuvOSjxqIxI80Ybt/kbArAvDkE8lYN9KwtpJKk6HYSXziqZGCUEMYhWA?=
 =?us-ascii?Q?vUInyUzu0JKUliwsu+eO5ryl6a9a8tFj3TwJ+7R11gWN3VnxuhukdHkVeMoc?=
 =?us-ascii?Q?HtzMc0sZ3k+UNKppPdDM/2EsYvStL3uZghVNcG6rhLt6sdGMLI0si7NsB8bM?=
 =?us-ascii?Q?h9I82mZgceoj/fXPHO7LIvCQ/sGcbVcB3Rtx/l1E2sAwNSg6apE2ryWMwaqO?=
 =?us-ascii?Q?jUISNFk0mL87k+gmvXBJ0mvA3re7+4yDzye1sXsewR4/sh3nHtBs28UuXigI?=
 =?us-ascii?Q?EF8ZQCPdjp5CCGvYGGzICbzQkYtQ83zFHcpprbNmdw+IGOyhqp167+ev6mWO?=
 =?us-ascii?Q?1dLdtIpxQc5UndJn2U/rvO/sf6ZZmmvmVVRhtsD8qgwgCdkqxpZSAt2BbuT4?=
 =?us-ascii?Q?Kf5tM8PU8KBJ6U6CUucUlK2Wrql1N1ZyiHvw1fC4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac0d72e0-0fbb-48c4-ab99-08da7a087b79
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5979.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 13:10:07.7182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mG/8r0t21kWUN6bQ/Lj35FsQPfvyPsr5sXCApznEYfy/tmfsZNQ+Wh/GJT5Fs7Bs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4044
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Aug 09, 2022 at 01:33:20PM CEST, idosch@nvidia.com wrote:
>The custom multipath hash tests use mausezahn in order to test how
>changes in various packet fields affect the packet distribution across
>the available nexthops.
>
>The tool uses the libnet library for various low-level packet
>construction and injection. The library started using the
>"SO_BINDTODEVICE" socket option for IPv6 sockets in version 1.1.6 and
>for IPv4 sockets in version 1.2.
>
>When the option is not set, packets are not routed according to the
>table associated with the VRF master device and tests fail.
>
>Fix this by prefixing the command with "ip vrf exec", which will cause
>the route lookup to occur in the VRF routing table. This makes the tests
>pass regardless of the libnet library version.
>
>Fixes: 511e8db54036 ("selftests: forwarding: Add test for custom multipath hash")
>Fixes: 185b0c190bb6 ("selftests: forwarding: Add test for custom multipath hash with IPv4 GRE")
>Fixes: b7715acba4d3 ("selftests: forwarding: Add test for custom multipath hash with IPv6 GRE")
>Reported-by: Ivan Vecera <ivecera@redhat.com>
>Tested-by: Ivan Vecera <ivecera@redhat.com>
>Signed-off-by: Ido Schimmel <idosch@nvidia.com>
>Reviewed-by: Amit Cohen <amcohen@nvidia.com>
>---
> .../net/forwarding/custom_multipath_hash.sh   | 24 ++++++++++++-------
> .../forwarding/gre_custom_multipath_hash.sh   | 24 ++++++++++++-------
> .../ip6gre_custom_multipath_hash.sh           | 24 ++++++++++++-------
> 3 files changed, 48 insertions(+), 24 deletions(-)
>
>diff --git a/tools/testing/selftests/net/forwarding/custom_multipath_hash.sh b/tools/testing/selftests/net/forwarding/custom_multipath_hash.sh
>index a15d21dc035a..56eb83d1a3bd 100755
>--- a/tools/testing/selftests/net/forwarding/custom_multipath_hash.sh
>+++ b/tools/testing/selftests/net/forwarding/custom_multipath_hash.sh
>@@ -181,37 +181,43 @@ ping_ipv6()
> 
> send_src_ipv4()
> {
>-	$MZ $h1 -q -p 64 -A "198.51.100.2-198.51.100.253" -B 203.0.113.2 \
>+	ip vrf exec v$h1 $MZ $h1 -q -p 64 \

Not directly related to this, but I was wondering, if it would be
possible to use $IP and allow user to replace the system-wide "ip" for
testing purposes...
