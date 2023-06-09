Return-Path: <netdev+bounces-9683-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3ADAE72A2D4
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 21:07:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E8FB8281A16
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 19:07:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF0551427F;
	Fri,  9 Jun 2023 19:07:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7AB9408FD
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 19:07:05 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2105.outbound.protection.outlook.com [40.107.243.105])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A84C35B3
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 12:07:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fLR5dIAsuEyH9dXjvIdhU5LY0HwK9lJ0SVJzjrmaCNNirLrn/AY1jbaCf7bNO7FVivFZwa1EgXTB3z0nZGNMkYm9rQzwj2NOzcel1TgKduqaVU8VY73SIaP5Fw+oK47EN8YLdcXA6fte2riyPEkgaNJHTXeqsGT/F4MwgUHzPRofMBNi0ogMa5/ZFednAcQrFCVXsVsnHgJMfsZiZrt76iY5sVDbTJ7awWIGJOVcArShe7/uNOISB1y+BNVB80dFNx0PI5ggZsDLMxLnvH8UYiJ4GDAMrGO1Y/q20dJpanWmsBKYICtNi214nUm38xCtc8vxVlsyTVaUhElmJde2Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ypXTCvkY8Ie7yZfEUa3hy604801NtTow8/r7fmTruaY=;
 b=neXS8o2iEV3BPhu4wleCWX1DqrkUj1zI3RhG8NJaNnsGBA51Q3hl/UEDDrDZX9I6ou+0XvbPNZoHnvZyO7B6cEOMRjhQTKg9C3T2bOKGESDybV3E9dnkeS6RBbh6C6RNexA60uttbyHoj9YhZOlkbEmFZLmN+pk3Hm3s2kHUDYfqHDYNFk0kkO3k4m08S6xdUKtHG2I0SAQm12hahefnSWC0vsODkUpswp8t4hFJ9Op/o/pEvglcpsALAeQ/c4DF9j47KW71YLA5IaFjsTjploc/myifaKNDBhjt7xlhU4oIh7LvzI/qA0mFHpzba4trKtTb7p9ox6SOwSRCoFKofQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ypXTCvkY8Ie7yZfEUa3hy604801NtTow8/r7fmTruaY=;
 b=Ljq6eDD0j+Zq9zXwoJwFVY+vvL0ukeUoeTsv0F6gB2Hjr9ffA03KNBKwI9sjfvYsmgkQiiiHOkQgs+g1vl1AaDyjCAxTRfGLiGfbBHLVq3q99X/D+EOBc2plQSs8sOPPUxgFmhMXh9YphxdX6yOps9ldjGilJ0YA8bF/OisT0fM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by LV3PR13MB6336.namprd13.prod.outlook.com (2603:10b6:408:198::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.17; Fri, 9 Jun
 2023 19:06:59 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Fri, 9 Jun 2023
 19:07:02 +0000
Date: Fri, 9 Jun 2023 21:06:57 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Petr Machata <petrm@nvidia.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
	Amit Cohen <amcohen@nvidia.com>, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 5/8] mlxsw: spectrum_router: Reuse work neighbor
 initialization in work scheduler
Message-ID: <ZIN4UTcdTdGCcvVV@corigine.com>
References: <cover.1686330238.git.petrm@nvidia.com>
 <6340a83d7bb25bf42ae76852b1a42d0668a86a69.1686330239.git.petrm@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6340a83d7bb25bf42ae76852b1a42d0668a86a69.1686330239.git.petrm@nvidia.com>
X-ClientProxiedBy: AM0PR01CA0177.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::46) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|LV3PR13MB6336:EE_
X-MS-Office365-Filtering-Correlation-Id: 15a982c6-fb67-4647-68d1-08db691cb558
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	XVHjkkbrY/zA9S5SvHJugq2QSG6BclTWE3/MxFWGXO6KQKNSDk9i58T7lVNqBZSOd9cexKhWJKg7EQ+JgG4yKY7qVy4M/qec/aL/AU0o08YxXdQNYWo2Wx+iskbjfLkUdHNdT502QCaBEyElASidJCZzQhSgeIQOTdy3YxdYwOY3T6m/S74lEWWCqUvsivT6rlNpEYWWwn6KeAkFfLeEfse9sj6qAcXNoqxTZY6sjS2Zevv5c8R/dC0umwb/LyolD+/XjHAzNwbbWPtSqNSC3bukW1huFtNjQT0M74piVkSaKOub2+Glr8Xrcj663TiogtRJ3ZeSpXed9GSDdmMM44ZoClEStiAbxiH5VP7JFrWB/WuuLIdw6LPFdC5DW0tjgZIiFoDSIZgsdzRs1yHaGk7Wl2vqFUOww3mPzhjHe96H222ZTwMxapBEsvHUyTVM3zkWyFL01OAWywBzwomjes5Emb7dWshOgksWfRF2v1PGUuT1xvsLHDLFvAywlSne7A1T89tjjNkG15na5klmI/P6g3lF0ZkR63jYi1sv4fKFlUnNc6t+jm5/38gbGRN5
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(346002)(136003)(366004)(376002)(396003)(451199021)(83380400001)(2906002)(4744005)(8676002)(8936002)(5660300002)(6486002)(316002)(41300700001)(44832011)(86362001)(6666004)(478600001)(66946007)(66556008)(66476007)(38100700002)(4326008)(6916009)(54906003)(2616005)(6506007)(6512007)(36756003)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pY/0NZrIVR5zC6YVr1zNkGn35wetlJS3tM84jqxHyIjfcLSOgDPWshj7lNuf?=
 =?us-ascii?Q?gYWpKPa3dPXHBS6OyY3DsyTBLE5ey3ELPdjo8Po0R1l7rLswBDKQpn831pcB?=
 =?us-ascii?Q?GM7I+d24//UwmQN2txfwvhhJbkm13j1kRSqMl4u5cUVdZD3wPUj31ctvi2Eq?=
 =?us-ascii?Q?RsrtnPtKzX+c//T+kLUIRjowpzIIDGWjmjtFl9zo69n5SA6TUt/nERl+1ByO?=
 =?us-ascii?Q?n72MIGA1UoeFxLhyo2R0TIeq9kzq1O+1tmgQsLd1dA7beP+9clUIS5PJaEr9?=
 =?us-ascii?Q?gawo6wo2R4/fiDjRfqGVJA21GiV09RAXmyYG25421ChcGYNBx5q69QSShapd?=
 =?us-ascii?Q?n677It75nw6QdL5NTsUbIdWliJ9QAsWZACxkiujUIlYKsw3cFzbGdfScrCPM?=
 =?us-ascii?Q?+5ojjsWuf16LMS9ZWv/QXY1jLu1KVQoY7LiqDJ/BcYxan3ryYX0EGz/QkZwf?=
 =?us-ascii?Q?cI6763LD8Xwg7VQwKVUUn6ZT/BCGkCyyznl8ZlGmM+I9D/twIhj/tdOtU30M?=
 =?us-ascii?Q?kltTA7uYIKZ0tIsf3pc28dNvndwPqhiYann+OGbPTlEakUdXxiH+ihVd9bFB?=
 =?us-ascii?Q?1BL1uDP1yDmDrmsCJC1cdwYcK/KJPHeq7QGLCIbXMD9QB487qW+og3w1K64s?=
 =?us-ascii?Q?q+tcLnhnxHMJoPzzR0IJjbIgOn+Z2d7SchDYGL2P8d5ah3uGQfQfTVkK37e5?=
 =?us-ascii?Q?2e4cu+xQ3zsnDXYmkLowb0Izlqh76UQ1Dwt5V+Ww3wDg21SZGZU9R58zwQ5P?=
 =?us-ascii?Q?feR6070Kst8J2KpEJsMTgzQQQBiBXQ62DIkHFuoMq8+ZTx/4cjxQdY0d79Fy?=
 =?us-ascii?Q?QaGbc5zGLsI59gsg2PSCsuT8MPM8XkGcJhfyZ0/N3/gwVxrJzA9XwniYJ0kE?=
 =?us-ascii?Q?uAbSwsdoAgDXcFg0sTskfTIFhfBarsNvsk50Y8mAaM1zuSr4tXART9twEEVd?=
 =?us-ascii?Q?zYmsbKc84MsxScEcB4IbKQ7wEqkHhOBzdTr+qk7hKhblY1/3QCtXV8zjlZV+?=
 =?us-ascii?Q?5cKDS2pookK9l3hPyvN2KuhPBOOM6k+p5l33IChutQYPKDu0GdyOFOjBA9wY?=
 =?us-ascii?Q?2sax3yWYOs2JhMklJjNbjjh/NndMVyRphNIoyN/8G1/hNcpqm17/B50PTrQw?=
 =?us-ascii?Q?QZWJuv6o0lpLNo1QDGpJPVF9dmXXEX2Qmou7xeKOPwjQxarJmIyAleqLvMde?=
 =?us-ascii?Q?Uu3UP2QNf9qhtbLZMaRokTk8vtpvsY+oHREwLOMEX9rQcsriFZtbF+13K+sD?=
 =?us-ascii?Q?qSL8SCwk7us+7JUtsizOtq9y+Rrv+Jf5veyviQEiUc/AC2mWFJjJA77ocQiQ?=
 =?us-ascii?Q?PScEUZPXL5CtpmSdwi48BoLjEIWBpSdif/kErffqOaEhIy4H9ntkgAkSnWVT?=
 =?us-ascii?Q?GUED8N/ZB4oKVkGCRT/TW8Ys6Uwu5nWQyUm9sMleUhZ1MBm9xfnNK7Wnfshl?=
 =?us-ascii?Q?b6bxf1K3fz6mGSgGIG7a4THbgILlsuF7rtmq5NSxunPqFbVwd8PlN0/Li7Db?=
 =?us-ascii?Q?/2MbQZ+fm1CNzlxtjaOQrPt4fAtIA1f6fdmoKSVAH5y/LTfQGbKIkWb+Mep5?=
 =?us-ascii?Q?x6aykxugFcYTqav7MY9B7ebxagQYhVTM/yAfH5NsJrwEQXAENSzm9UVWL7WY?=
 =?us-ascii?Q?6c5+X/6AdkiZbiLBC/JawtAYtQEooEUAWMR1QY0zRp6Q9baSQRnlirzOuU2N?=
 =?us-ascii?Q?lYDShg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15a982c6-fb67-4647-68d1-08db691cb558
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 19:07:02.6876
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +ej6YrxcQUBC8fsJPzsHMdYSX6Sg7K980gKyUKLXjyxMlu8dZaTZzMvZfRKdz5UlVp+6so+qQsOqnvXUlZ94h4J0c4y0a3SLNL9oaEz+tVE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR13MB6336
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 09, 2023 at 07:32:10PM +0200, Petr Machata wrote:
> After the struct mlxsw_sp_netevent_work.n field initialization is moved
> here, the body of code that handles NETEVENT_NEIGH_UPDATE is almost
> identical to the one in the helper function. Therefore defer to the helper
> instead of inlining the equivalent.
> 
> Note that previously, the code took and put a reference of the netdevice.
> The new code defers to mlxsw_sp_dev_lower_is_port() to obviate the need for
> taking the reference.
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> Reviewed-by: Amit Cohen <amcohen@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


