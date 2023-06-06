Return-Path: <netdev+bounces-8357-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1445C723CB9
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 11:13:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7B1A61C20E7D
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:13:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05521290F7;
	Tue,  6 Jun 2023 09:13:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E76125C0
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 09:13:13 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2131.outbound.protection.outlook.com [40.107.237.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0C26100
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 02:13:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tn0UF0KvJ74MJp3Kes7wDbJEkDy4XQswUww0zwSTNAW8UaZo48m9Fq2lakeCYVRtYvhTtzU5645LLAEXihuuTEB5kh3te0WlPuRy5BY9IiOFhq7NJKkLBUol6VVs38pdLvF2/o9yte1I5ZbdSqjKkk9jHPAlF7zFldLdEZadeKcwWmKAp2BNHaOkipd0uBCmATaE9wBZJyuLCieiodAlrHFKhALeAehQTV4iIemys+UPz21kB9JDjszRklQ5M9omUPTHuP7noSuXoZIUZkyvk/yjeMgdgS1Er6vB5422nKFATUlaH44EJQ26foRxvqP65nwB9n7gOGAcFoInFU7Ybw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MIaBWal3HzGmc/xorDCzGMT0PyXregu/TK2Zt8h7O1Q=;
 b=eydAEU13bhNVgjJ5JBESLjqlbo3EStM1FbMDt99bSRRwKsPMd+G7uFwk2Fw/RUoiHhjfUE5d1oUx2fX+/t7R5UHrRYCgg/NjHS+9TgZJ43VbEv2zGBlt8IxucHK/EUKcBsgzpBKqvWc3WIDg7ghadRtmzqii6wgEaqsy7NoiivWM1dtr9TC88ZX+jyjzBtRNL5hBmtKwa4LMOb4NYxRvIvriTz5RRWUrsTHymwAfUmuVRmus9UcZR5Rm3Kwl1/gMCFBLRtbJWgd9ALWlqROsrnqO9o9RwpdZ4eaQtjfNmVAFH8XDylQTU8btlC8JNvdqcBPtpkNYCbxi9gLp+sN0hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MIaBWal3HzGmc/xorDCzGMT0PyXregu/TK2Zt8h7O1Q=;
 b=SIzKKUc2xbE0FnUDc4gDKGatLSqw/534oC7xsCCiQz+DR+v/3ATOt8FfDNkBqBNskI8MzfTyCSyGBrg7LCJhAA6jtfB4j7YxkzygLqCqd0qpwmkLMSn3MnsDpWi5J3AzdQdo57iBlWed25z/W8ES7g2rmigOS2Z/twrxzTy268I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB6366.namprd13.prod.outlook.com (2603:10b6:510:2f8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.19; Tue, 6 Jun
 2023 09:13:11 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 09:13:11 +0000
Date: Tue, 6 Jun 2023 11:13:04 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>, Leon Romanovsky <leonro@nvidia.com>,
	Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	Patrisious Haddad <phaddad@nvidia.com>,
	Raed Salem <raeds@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH net 4/4] net/mlx5e: Fix scheduling of IPsec ASO query
 while in atomic
Message-ID: <ZH74oEZHPwDDICqj@corigine.com>
References: <cover.1685950599.git.leonro@nvidia.com>
 <633cd2b3f23ca9d759781ca1a316f728b001ecd6.1685950599.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <633cd2b3f23ca9d759781ca1a316f728b001ecd6.1685950599.git.leonro@nvidia.com>
X-ClientProxiedBy: AS4P189CA0020.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5db::9) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB6366:EE_
X-MS-Office365-Filtering-Correlation-Id: 65627493-3c81-4a34-5668-08db666e4006
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	R66dbcRzbD/fGNtTgT64CrMdHh0pgn6BiYc19TarS3BHRIMkk5l+4G63Y3SLlYt3VyDcUxG33RiTvUgLtc2sac79hNjtyGGdobsI8tiX9FNe7czPkbQOsM/PfHMmJNNjru9Rx697po9oJyf+3WdnKFwZDfK22137S/97OB6HTpDh42lVMJb7kchYNJt920DK0/dOrWflvCtqth7yz1FMJ/hr1Cl78WUjLd9jh0hVIzCFBlFFJT8r74KU4YaFbxwSvEj1UCAEYBH6b/w2Q1v2TmjfbC2EZgmYxJdMPT5gwrV/MGJjow2MUKdFb90M7nvXL8kNQGxcz74upINTW2RehXJHi6SiLmfOOkHXeqQ5wk/Xdu4t/7jIGYtKMCzy6HfB4xD95s2ZizPzlrEo0NnoOpL3Q4v/pVT5bgnIe1oNH706voeCUbOkLHSfXqKap+2JBXdEgxXZFsqw/n/9oOrP9uJX5EXwJdMdevWj05HTuN1D3OKgALQ9HQp8BnA2Z3oZD7jRpZrEyj/pda+140i7WEvwaqx7l/ZoCikdFZdPUuGNJ+r9d/PidHiB1fdL8lvdaFVd3sj6TfehuO6f1bm0ROHSc+DaxuZoW+vcThbwoWw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(376002)(366004)(396003)(346002)(136003)(451199021)(6486002)(6666004)(2906002)(4744005)(66946007)(66556008)(66476007)(54906003)(44832011)(38100700002)(5660300002)(8936002)(36756003)(7416002)(86362001)(8676002)(41300700001)(6916009)(4326008)(316002)(478600001)(2616005)(6512007)(6506007)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2HY44WI0682uXnnY0iUT5recYM+toSU+f7cFlj0NCNxFsrdKJeQ4mpOc/oiq?=
 =?us-ascii?Q?bL64xRN1ZVO2mSvbM2BEiWHjcNk57dSofkj6+Gi3NkOJnNUMspMmA+iJ+jeF?=
 =?us-ascii?Q?JWNS2rxpDF9j1zqGPwbr3atCCwYDvppb3ULX91r7FJzEgd9EcHW26r4KkEi+?=
 =?us-ascii?Q?1THOsFFC/UDvzHwQe8MDIpqOpJ5j1jeRhTJ2Ggg3mgrtrqLpaytQz3RvRki1?=
 =?us-ascii?Q?pH/8LGnaVOKOCZQYAR067upxrW+4I6l87BnSQKKuV3ztxQt6x2ER7i8YEGbz?=
 =?us-ascii?Q?3u4ll7g8HinQ9xPllkdtzG16I2WfdsrwoUHuoY9Dnni7QqwWhoy6XkVpZsL5?=
 =?us-ascii?Q?jXih94GJUcSAVTpvr1mM1CE60c45o6YQU1qPh/+P9euBbRIxSM2+s/1VPWYn?=
 =?us-ascii?Q?EkOTjk5NCjwYE3B4ZQdJnYt4hMprCG+YgxQl1gWbAaRwBECicdWbjQAsps69?=
 =?us-ascii?Q?8kE97gDgyBnEzwuGhdL1DURqDlxirIW2yuyspzO2IuJY8GgzW8gxEgcU6986?=
 =?us-ascii?Q?7J48eA/INySoRd3oSqfaAlqaY3Gg4dLSTCLV2TeAs3/DDi5QdMMcxRRhBrIE?=
 =?us-ascii?Q?/nWhKBcFEXzJGkB66cCr/VrOcfs7CGp3NIknbXzl27K0RhQWGOm+O281r9X4?=
 =?us-ascii?Q?IZM98IFzzCB3jp/R1kYlQGOh1DQdcQHA53XW8xDmv5L3Tg2hKK4s04KpocNr?=
 =?us-ascii?Q?/KyW1jJgqaFOG8A3UTO7iHO/b4ulvkBOkUfyyKYdDkEiYJQ0pQ4FH/tgqSqM?=
 =?us-ascii?Q?Aowdp2I7vepvMGOWMMs8kPL9UfA+SYx6hbvvaO8hvaqY7w+/iOLgCwDX6Jk1?=
 =?us-ascii?Q?WrEwkH0kl+laPDwMfGK38NwudNi5FCfj7rJllx57so1khYRXnYkVIlgG+1pL?=
 =?us-ascii?Q?ujjCCDQYylGowkYwuyudRcTUD+5PcR32z1zWRMTXLSHzf8ie8GbOlSpTJQyl?=
 =?us-ascii?Q?LzuxLR3U3Vlo90/U+wG0KAIYfXZe4QAHcQ9mIcXRFDbegKiMpooX85ABvm9A?=
 =?us-ascii?Q?fzqJQZpIQakIYlvvPwgIAIe44zG7KNbm7Zxo0xEnidYrJTiM1OYINsL0jgb6?=
 =?us-ascii?Q?v3rklfKAxB25VmL2hWYATJjo/FeKSJuXD3AiM6OJTY6Q4IvVUFOtRvMJsdOe?=
 =?us-ascii?Q?VP9NeCGluaS0N5xuNviTBe4JXkKZNAnvkjnvWfb4BZdiZWELdw8PlWlVFnDx?=
 =?us-ascii?Q?gqgXMvr4k5HkNf5dbh9uHyVfotJcunM4f3kEf6ld2rBXVzZEYJMP0aE9HAPZ?=
 =?us-ascii?Q?bqrXTlkfdyYC1k1MOPLDfS8vJ8UwZt55zbhNmji2K07bkh4Ou5tYF+dF40n2?=
 =?us-ascii?Q?SC1jIvWsr5SUm+PV78h1NQtrgqcgs+WyEHdbqK734i9oDl2ygorvjeNODdN/?=
 =?us-ascii?Q?RV0PrDgpEJP84p+BU48stjT2tU7coTYMlNAqJbQAm2HCewbDYZd6bWYLwFIe?=
 =?us-ascii?Q?ZQFj/clprsKzzXV+QCVOL1H15RF69gO0olfhiEW7rxsg0VTrp2PTtgasxv6E?=
 =?us-ascii?Q?GQ3cLpZ9HcHrap5TlgOsClXWwXHtBtBpcRPdQ+F09atocyjVyPjn1qOFXhZX?=
 =?us-ascii?Q?8D9sbWpS65gt5x7AovR4BHH9VP1fe5ACHE0tmhVIOov2YHJtWV1I3BuGqMWd?=
 =?us-ascii?Q?9DpRknPc1N7Lj6ylgfTqmVqICC9RpDhMmkfH5egKCorVd5hhLPDbvFW9HOve?=
 =?us-ascii?Q?zCcy4Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65627493-3c81-4a34-5668-08db666e4006
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 09:13:11.0640
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EIKJACJIl4dEH+Q8A5kJx/aKVxlwktsNFjrIELZBvIqOiyxV2EsVjirPYGWteF4pvtmytiJWOnGyUfAtYZuLue4pEQgozAf/Kd3tdDJ3aG0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB6366
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 11:09:52AM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> ASO query can be scheduled in atomic context as such it can't use usleep.
> Use udelay as recommended in Documentation/timers/timers-howto.rst.
> 
> Fixes: 76e463f6508b ("net/mlx5e: Overcome slow response for first IPsec ASO WQE")
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


