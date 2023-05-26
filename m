Return-Path: <netdev+bounces-5594-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B8C871234E
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 11:20:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C17ED281743
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 09:20:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F067310965;
	Fri, 26 May 2023 09:20:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF19C10957
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 09:20:43 +0000 (UTC)
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2134.outbound.protection.outlook.com [40.107.100.134])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD0D194;
	Fri, 26 May 2023 02:20:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gj70CEAqh23Rm3smK2wykLmJEx8zBT/i/btRdepinpnN38STCR8/OZONvoCNnYqX7eeTUKpVlWNUYYmjgg44+YDqKEGUofD3MNUwIPofJ+BOfTJLCnjKTQAiFCjT9chtmftMkKKdMgpc8hhHaq9H3Y1ndUzNWbmNfZwL/lj6dQxCg26YtqI0w5tVgd+fVXXRb8pI03WSkJhZ+PhfmMFPhdUm1kF58GgC/SDjtkLN30q0q9Tz/aYzS1dfwPRtb6c3ER3ftD0Jix+l10GVi01DCA7DvLzVpvCHJJ9ldMe/0DIgB8GjSuPy1JFeoHpOpfoX8ChDQ3c3XP+JRL54w27jGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ACRFNt4ZXC/GFs0S72HHZU/dCu41XtO+ZKAHnFQ12u4=;
 b=fAgKVSUfgU3ySYsV3GR+X2MQVOl6g4MqiyNtSH/EicW9XDLTMYC58nhXRWxxAamFFmcEJV43DVmM5RuOhuacg5MUnreDYjT8qSnD5Uwmztcf6BXV4WLwB3/705oBXDcCwYS8ZPc2HpH/Kg2plyDZkRyALyTKxJjMx/Ih6Sh4f7XWLmixsEFq4x6rZtOKvAQIDv9QFl6sKd+8JzNWpvdweD6joMfbgienzCRq7bD4+0COFzj5duewveC25YYESOPhKrYGnzMAr6At8KS18b6pdajLJskfXAqcn01tbXQpEMRSfhbjg2HCiNh9/YvOrm+hZdyPhuu341eeBRBqxMm35w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ACRFNt4ZXC/GFs0S72HHZU/dCu41XtO+ZKAHnFQ12u4=;
 b=Hgh1A7d5awK+KQHj9nl0KFbuu4J8wGvZwlhEo6icmQP34zwaiojR46hnbjTDRZA2uosOcPZI3ckztQel42Q9IS3m6gA9ibLQDW4bOA9TjQRBH6VLbfuVlFhjVYzaaYdlt8LPE38TzkRssgoe+xjCP1NZ2aTUUgse32PJcT6cFqk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3781.namprd13.prod.outlook.com (2603:10b6:610:9a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.18; Fri, 26 May
 2023 09:20:39 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.017; Fri, 26 May 2023
 09:20:38 +0000
Date: Fri, 26 May 2023 11:20:30 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: rafael@kernel.org, linux-pm@vger.kernel.org, thierry.reding@gmail.com,
	Sandipan Patra <spatra@nvidia.com>, Gal Pressman <gal@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>, Leon Romanovsky <leon@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	"open list:MELLANOX MLX5 core VPI driver" <netdev@vger.kernel.org>,
	"open list:MELLANOX MLX5 core VPI driver" <linux-rdma@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/8] net/mlx5: Update the driver with the recent thermal
 changes
Message-ID: <ZHB53sm0od4RvsKe@corigine.com>
References: <20230525140135.3589917-1-daniel.lezcano@linaro.org>
 <20230525140135.3589917-2-daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230525140135.3589917-2-daniel.lezcano@linaro.org>
X-ClientProxiedBy: AM0PR01CA0168.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::37) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3781:EE_
X-MS-Office365-Filtering-Correlation-Id: b24c71f4-a83b-4bcd-462c-08db5dca7819
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	/JIRNiXBWU/UwpjqyWiVyc8OcXoOxyGZrv9d5v/L4LQNL82WnkT9WKZy190A84AbuRC6BWZ+Uqgz1WrDL41lbemwO0X2BTCyLo5tGws7TgKcTMGJMqM5nhaBkOiSwL8RzhEWG++YWxfYtF+A7MQEBmKSnd+IT4sVwbLC/SviclKslui7e5JTmJ7rMec8u3MVCoo0qestI9ppEsjfZ+ePY2ctjSF3FJ7KxmNYUR4hVlonrG2ClPjRnk8jweWB+3lF/ev8s+USSJrnRT0BIAgsOgY++3effbTlbYijkoOupxt/zQvZ0s+L1E0exWRz3VvgPYyKHVsz3Od0QB3I21KNfrzTCd41WAgM8fJoviTWXBWFeviB9wA4Nd5yZ6WJGFmeSzDIsQi+AvFD9sTObsRMPQBMFu8fI6RglnM211okwKuLmjzvBud7PiCgGoune8kFWmRC38053TW0UbWeo0zMjFV0BxnQH0tSknrM+8bi5a8niyFi4BBZUuVzhpO7I3vEVc0UMDwQM96xeETSrlEcpV1RCovJRq+wJ7ts9KbAZQ2UbmMnpwFNSPPSx1yzYZvB
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39840400004)(396003)(376002)(366004)(136003)(451199021)(54906003)(86362001)(83380400001)(478600001)(2616005)(186003)(4744005)(2906002)(66946007)(44832011)(6512007)(6916009)(4326008)(66556008)(66476007)(6666004)(7416002)(36756003)(6506007)(316002)(6486002)(41300700001)(5660300002)(8676002)(8936002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Hxge8S3laYkpCmPB/VzmLniftQA7NeJ7iurxhpQPr22rXDgVzD23cZyWCWR2?=
 =?us-ascii?Q?Q47sW5y4TvFF9o5IDCSYz/dcecdVZMqzu8b3/diVCfGiyGgYhLNWu1WLb7uo?=
 =?us-ascii?Q?Es3ee+1SWlNzk+0zdK1dSM6OOI97wEKs9L5z16bw//2bZQ6Y5esr5Ku1qnX/?=
 =?us-ascii?Q?6UuvFSb3PtDYUCM25g6OV9e6aMQEOzMvpX6jkIu1ERzxkdKt+NOt9KqS1NVb?=
 =?us-ascii?Q?InjA2BvFm5MJ+eUAjMvIkGuzChHV3dc98Gc6SQUdZVEqTGT5AguGMlFcqZAE?=
 =?us-ascii?Q?1DrXU+0WXbVfOhHXFeET5DyW9077kUj5jJnZQNdAa5gvDkujx4mip1DMUrvE?=
 =?us-ascii?Q?b1Fdl9sL/i4Zs0ptQ2XDNLo3D2DiLTa7fbm/G+46c4tCSAnLNu3V0juefUUh?=
 =?us-ascii?Q?CEOiP5BEBDgFPFD8JPdLjMqNlIjJWSAndLDXgafQX8Z/U5drMVYGZt2+W0Er?=
 =?us-ascii?Q?jvlapAUHeYrQk/ZUL9Wee6NnhdV9q+y2VyC/rI0RAvhIyoMKRDVdr5DqtlIK?=
 =?us-ascii?Q?ApJntEr1OwsC6qpaJR039P6PLieWZ1YRAEbZLOlzlK0+iK5UF9wnNZU2giVO?=
 =?us-ascii?Q?GpuXrLDgD898X+ZibhmYDiYUvyUvXnGsWVKo17J9GtrYpg/Ody6CmqTLHtIm?=
 =?us-ascii?Q?j6t5DVtkXO2R8DjqBzHPf1cD5J724MG2siJAWEr5DnpBettP/uL7HFJBREzp?=
 =?us-ascii?Q?efB0iIIexiCKFsYWmTN87AJBWlWEOpHk1OVUmZ3Noc5iHbfpbVwll3rAY3j6?=
 =?us-ascii?Q?oL3b8D6o8gl+HmnbOcRB9Zjd8FfzdpI6ECI+qq8d9vmYLbr1Aph2SfNccyN0?=
 =?us-ascii?Q?GD7aHeVI1gpp6GFTqcE1SSZAWDykPmLoNFMqyWMVG+hJBlDkDiRaCNjzLPQM?=
 =?us-ascii?Q?CuO+A4r/dFoMbSie56qf7SrtTupGf3/K28wchy0+Ou14a7jsfIrJ8y7H1lUK?=
 =?us-ascii?Q?PGPFSZMi0BWB08/LcwpNuBH4Awl6xk8MeFdCp140kpqFVUhqk1QEXB4UoCFd?=
 =?us-ascii?Q?7qP6eJbPH+GIT3FuTFlVKkmmYT/jNSmQTRS6ZdI8qeX+c1zz5CHtcCHjIdPZ?=
 =?us-ascii?Q?wxEaaVCyQIqMvG4CdSeJinItCaty+Bn7rPDSKQoDWwnMJ8q86xCepfY4u3lD?=
 =?us-ascii?Q?BWaJB0uYtjSBwkeTUwGm0w1D7NmoQEqozD0dSPKANjc3r8q32CPC4E0dlNc1?=
 =?us-ascii?Q?pTmMe6tpBNYW4NvgyJEwMBvNx0dlElpwngmy5kEbeOq5IRGdF0BNu8UPrGL2?=
 =?us-ascii?Q?ApsYU4CTERQWye/PYKbCD6vABHJZrhwKfRjcb6L6nCssNQH1XKizRRdjk2Vf?=
 =?us-ascii?Q?ufZMgCz9wZC68RpwUrhdhBLhYbUi2fSRAImk+Aw3VV0DYgR03d1XxBEYhD88?=
 =?us-ascii?Q?LeHDxfaQdqZIJQ4H+Quzdw2ufEy4THvxqqhvt7T0ug58u5KYmE/DKwW6OpPE?=
 =?us-ascii?Q?EUEIXz96w7i0M3Aw35peLWBBFK81uMn/pP9FNRG6EMbz5s3RjmSXZtSXV2Ke?=
 =?us-ascii?Q?u4PnDaT9PgGffIWoAwwPXdi/i9EuLtiCGDdY5SLLMsN5pnHsruhskQYICTf+?=
 =?us-ascii?Q?7cIvNTOEOwDDbaYIGaAE9UIro09xcuWrSlKCNOGyJ4C24n9GHqlU1za5Ana0?=
 =?us-ascii?Q?2q6vR82cT1F4DgXv/+WTXNjJlRS+PVeGFst+uS5YfNrc1DSE2Dq3YBE+HnpC?=
 =?us-ascii?Q?h2MMhg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b24c71f4-a83b-4bcd-462c-08db5dca7819
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2023 09:20:38.4085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i0mUvcORRmTwG5VbzAUqPeZnOOfbnEh29rioMOOYk9p9rP92l4r/saqMVoTrhEWY0Y9qzD1m/CxkWuuxJDzvcgeBjbv/ut42QiG7wQDZe+U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3781
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 25, 2023 at 04:01:28PM +0200, Daniel Lezcano wrote:
> The thermal framework is migrating to the generic trip points. The set
> of changes also implies a self-encapsulation of the thermal zone
> device structure where the internals are no longer directly accessible
> but with accessors.
> 
> Use the new API instead, so the next changes can be pushed in the
> thermal framework without this driver failing to compile.
> 
> No functional changes intended.
> 
> Cc: Sandipan Patra <spatra@nvidia.com>
> Cc: Gal Pressman <gal@nvidia.com>
> Cc: Saeed Mahameed <saeedm@nvidia.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


