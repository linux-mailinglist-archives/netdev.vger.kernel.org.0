Return-Path: <netdev+bounces-9678-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E534072A2C6
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 21:05:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 36C2F1C2118E
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 19:05:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BE99408F5;
	Fri,  9 Jun 2023 19:05:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062D5408C0
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 19:05:31 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2117.outbound.protection.outlook.com [40.107.223.117])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9243D35B3
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 12:05:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VMFAPXf5N2oV888HzUSWh5V0JPgOjGSM4+iOXO80+CWRJ7KksQV9sfGH3j5pwF97Hbnqj1LOrhkc7fSB58eQh4OOX8vFCoo1LkKW2II2OujeBegJzXHSmahxjmfVT0/R+AGwwLDdlFVaStrO77aN4QaBebC8yPxzR3j1leRjBX/00R1RfqpuSsRb6P9TG0w9UvEkipbVr7euGXHgJNeb2FCKnt4ulvQiHJC69Dw4ctPsTzrIiiEQN5HSmvLwcGaDUF/xVVL6KVHL1ewjqea1RIlHo7eY1IyHFa+eWG8Dwqq22XyIh/LBfF0jyJ182RxnVho+gRo3VXgfs4BEGo2GrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aOh5NGrwhtasceFk8cD8RVtlB926VFOE35Ge95P0A/E=;
 b=CapV/HhsXasQdtaHv5+GRqDRiZ7CZ+SrhdNiPfBcOxZlGQkZ8tfUt5G5OYNr6H9stbTwxELOcpJuRnmoismxl3Qx2sb28EfsJa5w/fsHM+//3kpz/1/wnZGtX+4AUC71BgtlAP76qEOmi1kvI6lkmrKMVcv9XHXpZDrAveNSF29Vp0dHi8v9lLguhM3SsbEiMDLx5j8oXcyIAThYEG5WA5Cu3rzLy4AyjhfTxuJ6lw31aAIiiHwNUcGhoqAJIxQnnbqQhSjjFTsKGLljc6I8bO4wvEprAy9Gu2ds7OZjP00pI50caKuDKq4yRmWzUK6pT4MiHsYNZyxYpuKB30voJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aOh5NGrwhtasceFk8cD8RVtlB926VFOE35Ge95P0A/E=;
 b=SDyOZNofX4OLODGg80xo6N9ff+zzkkHM0gRohvDCqAwM2L6LLh/CQuqlmqMFHc5yUM58tdXSeA98ZpLrEBgx4g8Jzt+BDv4IJxqp4spf+8roS+xMktu0OslPSo7eLsAVUJqIcUeOVJoiRWAFoxCdY05YmEZeGN1YQPy/KpCOPkA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by LV3PR13MB6336.namprd13.prod.outlook.com (2603:10b6:408:198::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.17; Fri, 9 Jun
 2023 19:05:24 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Fri, 9 Jun 2023
 19:05:27 +0000
Date: Fri, 9 Jun 2023 21:05:19 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Petr Machata <petrm@nvidia.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
	Amit Cohen <amcohen@nvidia.com>, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 1/8] mlxsw: spectrum_router:
 mlxsw_sp_router_fini(): Extract a helper variable
Message-ID: <ZIN37305MJF6CEi+@corigine.com>
References: <cover.1686330238.git.petrm@nvidia.com>
 <c79d2114b7764b3191ebdb0a8e81b61b53a48528.1686330238.git.petrm@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c79d2114b7764b3191ebdb0a8e81b61b53a48528.1686330238.git.petrm@nvidia.com>
X-ClientProxiedBy: AM0PR10CA0119.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::36) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|LV3PR13MB6336:EE_
X-MS-Office365-Filtering-Correlation-Id: dcf45069-bffa-460c-a513-08db691c7c73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	NnxWNhoJB1GKb+4IH+mboXQdI6KdeT0bSBkt9JiFpiiDdQZeRLAYl4Fsph4DL0P9d8O+8g77EXBp+vgivhCps6LiqiNkf3w76Wxk7cn/33dHWH7xiWzMLRbduLCEHfDii5CqKnDpICl+8gkl2pWxycQbp1drXcSiDHLXFQEP38t/z+ztBXbQa3mOPxYvLOAAgjsOvYtD6fnZ1ipaCgYB50CN4NUNrt8KzCPPSQbn80f17WmLsuCR8HHcmUR5QwtYWSj/dZgkG/BiRF97+Yz02A5ACgBqscm+9uWMa5eyQpFH08xb0Iy7fuuVVCbkGWGDwyhYBZZof2LxsPTXD3VncRZ7cuBP7AkGkengSIErr37KOciYHb8ACbk8o/7Ibt3nZqbKEgyZ9qvoHwQMum/XOt6ALN+2cuy8Do8DimhUat94vx9wI0PrpMK9vOEYdkdWQ0lUF8oimY6edSMNXbhl8RAUO0UsmCVz3iofGBG65UFxe6UYfdn8jUjpEzFtReFMdm01U2LanI2wA8kyQeKWJh63hYByQHkQlrDhiIV45YFR7TExC1xLB108Y9etC22d
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(346002)(136003)(366004)(376002)(396003)(451199021)(66574015)(2906002)(4744005)(8676002)(8936002)(5660300002)(6486002)(316002)(41300700001)(44832011)(86362001)(6666004)(478600001)(66946007)(66556008)(66476007)(38100700002)(4326008)(6916009)(54906003)(2616005)(6506007)(6512007)(36756003)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?11IZ2q/bSEhMOtHTuJkG4rwrps10rhxjDgxrbeo1Tnlymf41ET2LfVQ3r6fM?=
 =?us-ascii?Q?NseI4MwBe15OTTWcGS1uG7mBkO257V4ZWuOBW2hJpkXNJ6tiTZ4Je9tLunjQ?=
 =?us-ascii?Q?QG8iL0TouM6YExwp6DIexQWxcQYAvnqrRVerN23ilYPBYWZLrl0jsW7nvsK6?=
 =?us-ascii?Q?dY6ABv7u2H8bncIudqiXZMRF0o3m3aJ+YM9suvEPLdVsDhnhizn6mwjHkEj6?=
 =?us-ascii?Q?0W43lFtBwYty4bO4f/gua0STgbUQQvNT9aSoxoAZ5ERbiD465hvXlX7RQ12I?=
 =?us-ascii?Q?mg/K1caqlB7+hioEyMtovxXy1mv9Ie87sOBQqvVqwZEnLvIfwzLTBmHqtV5t?=
 =?us-ascii?Q?Bik+5yoPGAQBmUXfs1/Kof4/hQqD7mP+puW21sBwkCS0t5UTEr2j2McX5eVn?=
 =?us-ascii?Q?tybhxaBah3m5B3Aj0Sz+Xo20ZKB4PAfUGsIqlg7IhllErdrqCmsKTLLRM2CT?=
 =?us-ascii?Q?IHd3lidD/kV4tK1Tcvlf/F6goIw+SLBCEZbxPC95BubaeL5q4YsB2nMYS7fp?=
 =?us-ascii?Q?8nXe4sM+168hxVJd5TFHSPNwW5dHPFGSOc2GSsGikgVvEIp71jcrs95GuI4t?=
 =?us-ascii?Q?/G9A2N09t0d8oZV7KKUMqJYWZCFWfiHELcQkz21L5dN8PCHuYdYWYvWlvjxs?=
 =?us-ascii?Q?dy4uoEwywUbjGnwy5wa1ZfhGn/Iv0QC49UXgWT5eExJcmQWGlZo++0S/oqbC?=
 =?us-ascii?Q?hmbuggEuD5SsPdTsnthtuYaU+376x9jk1Ut3y6e38i2vY0UX5IK6ZG+oFQKm?=
 =?us-ascii?Q?BTVkk0XZs9I8TLDtkACkbP4PXTI8pR+FQlqQz2jzF4T0AUDuFyp9Gq7YOd61?=
 =?us-ascii?Q?QNRiiPCSSEZTPhz5Nyst6u1/OUQKlzLmgIS+4OIos5dVyMyQhnJfsCWxp+X7?=
 =?us-ascii?Q?B55J++zuH7crsDWcXdnvGVhyAoJQGOW5BxmPP62H9nGQMC3OnDPLeJc2hHvO?=
 =?us-ascii?Q?a6RHJnHzXmcoxoJnFqN3Tk1yuAVJEGIZtDpFMDKny/yNGzcvzXBGBlu7TG5c?=
 =?us-ascii?Q?ipE3wRdIa+B6lchkpPi4EaEQhUirIFeAj4hqk66ofDQJ+zizsE8wsw4qG9RM?=
 =?us-ascii?Q?OMY3obf37zZ6rh0EGJoX0xbgEBjnDSz5T9Q36nb0QwUq9r6CQE3bquKAFAQh?=
 =?us-ascii?Q?ZLObJu36c1edgN1CEb6kur9IUqE7tt4z9q2lxZFoDw1POvQUfaiH4pOZgBhY?=
 =?us-ascii?Q?eBk7iSbs92B0k4bgpCHNFvXjQXVGlYBgllEB0UxpNSStCj9KyzOr3+RFZr+T?=
 =?us-ascii?Q?UYHQ/VmFByEgIOqo2lM8oll1pTuIsiAXv20ZAKfCZIqii/gwsAUM2eSLUPui?=
 =?us-ascii?Q?HHAy4tGJKqyrgpc8r7sw+7RaUYhqk+ynVtbrpI5YijTyLILw89S1R9syqSFk?=
 =?us-ascii?Q?ns8OK3GdmOS8Q1TUITV4g7jgyXO9IQLYAcbMDR0V7FgRbmyGm4DgD2ElMuib?=
 =?us-ascii?Q?tY2V10cuS8Ng8omudAp6Gxz6TXaM5AEQCcvQV0aOq3spv6UhFkdZdbzlm682?=
 =?us-ascii?Q?0JsOSj3Im6gWoGyumoBSUV5cZyFJyxBi4IdL5+bgRhb5Nc2tdsvOvvqn4dpB?=
 =?us-ascii?Q?UO+fLwTujRrrKcAcIZPF+FKTPcQ4JKjcbYgf6L1m4E77O6zyqqu5TQZkGp47?=
 =?us-ascii?Q?PlEMYnzWJeSBVMJZFqfS+yhBYe4vaY5fBKcxv8NrhFD9csZZia41O4yy1Nbh?=
 =?us-ascii?Q?B5QKXA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcf45069-bffa-460c-a513-08db691c7c73
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 19:05:27.4879
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rL8AGVBnDA9WFKRLLVJ+5TYBO+lD5rMSXUrFqzlM8WoawZ336tykOdxER6CUH5FxGbjMxX/7YuCEcMowIlU5UG93clUS6eSAVx+vhlvNwFo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR13MB6336
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 09, 2023 at 07:32:06PM +0200, Petr Machata wrote:
> Make mlxsw_sp_router_fini() more similar to the _init() function (and more
> concise) by extracting the `router' handle to a named variable and using
> that throughout. The availability of a dedicated `router' variable will
> come in handy in following patches.
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> Reviewed-by: Amit Cohen <amcohen@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


