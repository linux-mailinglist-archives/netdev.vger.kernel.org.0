Return-Path: <netdev+bounces-2429-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1452B701DF3
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 17:18:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 218741C2099C
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 15:17:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F3BB6FB8;
	Sun, 14 May 2023 15:17:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037EA1C33
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 15:17:57 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2134.outbound.protection.outlook.com [40.107.93.134])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5E581BF0;
	Sun, 14 May 2023 08:17:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QWOT7e9IcPbQr2F8GYlAAaT1YW6XwGFPW2Wk4W5EnJ2/GXbPR6/bWg9yujyP3/I/+AL0dNCYI+o75vBswy1meySqvERvpksOWDBJuLfRx2KRdaU+4GMDo/8qNmGYljyq4Gxo9B5arPyXkJy6AkT4686Vqf3juLaJUkslqmIBO8fG7D2h+CTrVXrch+TBHD/ru/NOmj3YZY5tyJnnHHTj2e1GV/6NJlZ8q4YGouuwVwNuuepf6q6qlJFl3R+OXSG8wNbIjRfCyUWO/HNHcjV5rHKn5J2Sx1C0LIHhlv7i/MjIkoo2TRbGywCXK9PMhLEWyCsiy7Hl3jy4y24su0uJtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o7iBJf7xuLfxkV6gQIvgKYtuuSeFdCod//q22HySaCQ=;
 b=c+Q6jdEFL2eQY4slIpcwhZmpmDfYFqTTz7ZSFwG3hQp7LnTKi/uPA7meT7bH6vC+ja2ZPgQIAj397349n016M5CT2975nTh6+0ws2XNw6brYZSvBhdMzkx6/SVhw7aKqCu++t35VdfnKsBo0ap39uPbnH/TkgwIi53aim0OdiM0nHPucxdBbxBwcJaMOvRvhIohPaJzmInLPNcwvJIOTUj/exLQu4vgTs2JRzhDPutQw4s2i029Ss95KGhRRqixSLOTyBb22JGYI7jOsOiC2UbjiS9wUEho7rqV7Pmb99wYh4tvSuLHmEpyHV8MDKZbLHSM8X3wwe/Vb5W4hnCUPvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o7iBJf7xuLfxkV6gQIvgKYtuuSeFdCod//q22HySaCQ=;
 b=Tj4/AEibYudqa7hTukEBLzsHjkwKrsQLLWjojYIQPzZi4i/d1c124oHotsiP15GnxHfKFdeE8A81Q01MzW00UoI/RuX/MvwhxlsugAQXW6wMSP1ymff/09DR/URu6EitDcgm/RCAR6sqNGdimS167/0MNjSG+NbuFMRsiHRm3ic=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3907.namprd13.prod.outlook.com (2603:10b6:5:2a8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Sun, 14 May
 2023 15:17:54 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.029; Sun, 14 May 2023
 15:17:54 +0000
Date: Sun, 14 May 2023 17:17:46 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Tom Rix <trix@redhat.com>
Cc: pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: conntrack: define variables
 exp_nat_nla_policy and any_addr with CONFIG_NF_NAT
Message-ID: <ZGD7mphdxml6qgCx@corigine.com>
References: <20230514140010.3399219-1-trix@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230514140010.3399219-1-trix@redhat.com>
X-ClientProxiedBy: AM9P250CA0026.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:21c::31) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3907:EE_
X-MS-Office365-Filtering-Correlation-Id: 62620db4-07ce-4fc0-9147-08db548e63bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	qskOST+WUmlzxjnFQ1dL1MqaWfE0TNAV3Zni/vBoh9Dyfi5tZGLAexlqziqc8SdyGzlOenthj5LixS4i8/MkD1w0mujsaEWwFmUBWmrf+qwhrzyrkrQYwLKLyxqkvsvI8WiiYtFFERhLlLFp53kyfBqfPA/80/892A3N1qJLDnhoI/FmGLM+XAiUYCfr7/Dpq1zvSDL5kDfF25VEQxb8nWckX3WIUVuL/l5CGOU8L/tUtazQJLvZTgTycza6Wt4TFCdn+oSpBv1tSCNUpXjE1bhJKlo9YKQhDCtDcXW6Y1h2DWjLcN4Ql8FEmBA7zr/k9hx+fpRvaWkZI3XdL4Xfftx5DK1NIxQGG+/jN4lPOC/cx+5U+7GlWCT5WpuRPzKQpCqQ/IgBJesTZCYABozurLCrtS4U5XZMQ1x+Vr9TB+bAD1svyOenuUOSwWlHkT32SimDnhovhW+19rJ3Q+r1Ya97EGTbmXaJWxpHHdk8mWocv0uw3CSubjwts7xS4XGch85WUxeqYp+qbtze8+A91OoDhvkCSky/2q2GYEAEJF/U2gnmOp7TI8UV20g63+Tx8sGhPX0tuczMI/oUXAKTkkBdHLi5/jrRx7lCnCcO3VI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39830400003)(136003)(346002)(396003)(376002)(366004)(451199021)(478600001)(66556008)(66476007)(6916009)(4326008)(66946007)(6666004)(6486002)(316002)(2906002)(8936002)(8676002)(41300700001)(44832011)(5660300002)(7416002)(4744005)(86362001)(36756003)(38100700002)(2616005)(186003)(6512007)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K2hZR2J4NXgzaXduSzlxa2xtSi9SS0FPdEdKaGhQQ2huemtOREdNYUpoK0lZ?=
 =?utf-8?B?OEs1SUtSZ0RJRTVNMEJ2R2UvV3pSNHRLdWZjeWdsYnltWG9BWmRkRTF2MzE0?=
 =?utf-8?B?MVArRUc3Z2hveEVrWCtBRUhUYnEvd1BnT25USkgvTE9rZkxibVg5VWZXSlZy?=
 =?utf-8?B?ZnAxSVdWTU9pYnlVUklxbndLZE5kRkJIenltZzRSSXREME8wTjloOTIyK2dy?=
 =?utf-8?B?M0cxa1RiZ1NmQkpGUDZNSG5LQU9WTlpuNHBoQzlxOHpkSURyNkltWmowNFQ2?=
 =?utf-8?B?cWVCNHVDRVI1MEdZTVU5TmIwdDhKU3ZkZ2drNXQrcHZQWms4KzFmcCtIUmtZ?=
 =?utf-8?B?VTZ0ZU9YaktXNTFWcHJwNXZXd09UN3FMZy9ob3J6bHRLb3ZERXdHVmU0VExa?=
 =?utf-8?B?cXI3dnQyb2ZxSm1jWWZUTldsTW8wRWZveFNhNFNVa0tFMzZabUluK1paemk2?=
 =?utf-8?B?b0ljc0s0TkErdDhsWVVVUjRySTFvcHBnNjE1dmQ5VlkwM0M4UFF6ZFAyMll0?=
 =?utf-8?B?eEVQTjN6WFVYTnExZEUxb1lvOHBDeDRoajJyMkEyWXVMbWVTZ0lVQ1ZIcFdr?=
 =?utf-8?B?SlhPZDZ0akZuK2J6YkhzOFU0eEw2aDhJZEwxaVcyV3craVQ0WWFwcmxIVmVt?=
 =?utf-8?B?NGEySzNnV25PaElnQ2hLME03dlpZWUZpOGZ4L3ZicVc3MnBDMFN4a0VVZzla?=
 =?utf-8?B?cEczWXRyY1dYSm5acElHeCs1bUoydFJwS1BTNWlSa0JGWVIrT1FUdUw4V0li?=
 =?utf-8?B?SVRUYjRJT1ZIZnRtWHdGVkxya29xaFFNMVJ5MjdCZjB0UTlBekpFWHJUL1o2?=
 =?utf-8?B?UEJ6NE5XWVJzeFZSNk1PUUlDMWF2OUk1YlNHcWhjUjAwY3VGZEozQ3hqWmc4?=
 =?utf-8?B?cFZHbFBvZ2NtVDNNc2srRFpRVUIyMTlvR3JKNkFTMm5ONnBseld2TWNJSmky?=
 =?utf-8?B?c0twRlg5eTc5bG1tYzNNWTdwY2hScnpSM012WmxkaE5HQk40UWJFVVA3cUJY?=
 =?utf-8?B?VHdMZ28rcXZsQWJsTWJmVnBtdENodmlrbGxXdGM4c0ZyNG9LQXdZZ2M3WjJi?=
 =?utf-8?B?Q0xERWtyc1hxU1JHWU1IL0JLRkRDSVR0VjZXMzBNLzAyQURLb3I0VDNraDBI?=
 =?utf-8?B?VHlkNktFUlI4UDd6UDJHNEFveUpFaGZneHNBTnkrdG04ZTBzdzI1d0VoeTVJ?=
 =?utf-8?B?M0U1Wmh5ckRrVVEwTy9XRmlEd21iTmk3TXZSNWVpU1h5SXdMVityT2QvY2Q0?=
 =?utf-8?B?d0NMb1dsbzFaUksvMjZBL2orWjJwUm4reDN2dUFORnNSbUJLOW5lR0tlQXNN?=
 =?utf-8?B?NG9nMC9KK2hvZXdySGJMYS9JaVppTEFOb09sS29uZzJOS1hrRTRzT3lKWGp0?=
 =?utf-8?B?M0lqazIxOGJIeHNqTUJzUFAzb3Vjb1lqUS9sQkx5dk9BUHFySHRnS1p6bnMv?=
 =?utf-8?B?c3hVVkVXUlduNmZET2wvMUgrK2s0ZWhVR0VmMUl0b2Fkb1FaUEZlZnF2TjdE?=
 =?utf-8?B?VS9rUEVmTnF3SGQxVVpveFc0dW5maEdyQVoxN24rM3I0QmN3NTlpQkg3cEpZ?=
 =?utf-8?B?TjJ1T2pwSStWbFEyUzRXT1dkSTIzOUt0V0FiVW02STNqR01rTE9Rdm8rNHZQ?=
 =?utf-8?B?RGxYN0xhMmFGcldjcHVWREZwaVFsU3gvck13OWRub3MrT1Nqb29VRXp5SU95?=
 =?utf-8?B?WC9PQWVKMXkxd01hWWIyL0p0cWFTR2dQSjZYREpZY1duYnRsOG1RVVhHK3Rp?=
 =?utf-8?B?S3NXbFB4N3h5OEZKcDE1VVA3c0VzVzhSclVrbnh1ODV2bTFlRTZ2TTlFWDdl?=
 =?utf-8?B?aU84WlJyR3dtWE5MT1ZGenB4Ymszdndjbm5TYytBYi9TTEJyRTNDaldKb05a?=
 =?utf-8?B?dzZLZ0N5ZzdnUS9hY1NXQ04zUEUrL2o1aEx1cm9DeGhxYXJ3cUZwVi9yWGRv?=
 =?utf-8?B?NmtQMlJXVFp0Tm5YQy8xWmZibWNYa2tWM2lvNSs4M0tIekhHWlcwLzNKNkVr?=
 =?utf-8?B?Wmt5Wkc5Y1phVW1kQUFlWWgrTXpwS0xuK0pWTlZtUmRZWGtWSGlOUlcrY3Vh?=
 =?utf-8?B?U2JCZ3FxaWhIQ0VPNEFtYlhqdDRQZWcrY0RVZFk5czJuang1cVJnUENXRTJQ?=
 =?utf-8?B?RW5uTUQrdWZQUTV0aWFXMzB2aWFpNk1tVzEwSytoWXJJWG1OOWZ4UjhvOWV4?=
 =?utf-8?B?akdWMU93V3d1SFl3YjB3TWV3bG9ZNnV6dTI0WURHY212WlNxL2Vnam1LLyto?=
 =?utf-8?B?RG1JcHJsanZKSStydU9udmQ4UmJ3PT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62620db4-07ce-4fc0-9147-08db548e63bf
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2023 15:17:54.0594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bZ0JEAVAOutSgIi8vDBTdprP2op1fxXzBy+elhnTrZQS8hmGQzgE0dHsXA/InNzynOfqL7j8SEjwZY7MQsWiAD9L5naMuS3nUCjSCZAqPHc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3907
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, May 14, 2023 at 10:00:10AM -0400, Tom Rix wrote:
> gcc with W=1 and ! CONFIG_NF_NAT
> net/netfilter/nf_conntrack_netlink.c:3463:32: error:
>   ‘exp_nat_nla_policy’ defined but not used [-Werror=unused-const-variable=]
>  3463 | static const struct nla_policy exp_nat_nla_policy[CTA_EXPECT_NAT_MAX+1] = {
>       |                                ^~~~~~~~~~~~~~~~~~
> net/netfilter/nf_conntrack_netlink.c:2979:33: error:
>   ‘any_addr’ defined but not used [-Werror=unused-const-variable=]
>  2979 | static const union nf_inet_addr any_addr;
>       |                                 ^~~~~~~~
> 
> These variables use is controlled by CONFIG_NF_NAT, so should their definitions.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

