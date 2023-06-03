Return-Path: <netdev+bounces-7668-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C909A721060
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 16:14:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A6C91C20B07
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 14:14:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 562B8D2F4;
	Sat,  3 Jun 2023 14:14:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 363F8C2FB;
	Sat,  3 Jun 2023 14:14:00 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2118.outbound.protection.outlook.com [40.107.243.118])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B5DD132;
	Sat,  3 Jun 2023 07:13:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OSlcaGeDcHTqBmKBnX+6aAHa8cnf7OmADgxd+RElImqOIbuHy636/PUHhBYrO3Q89ZC+r8gPiPV1LmXUCkkqDmx7r+2sRTRnl5rSbce7W5KqMSH0yWQezFXl1gRiqDw0kuUuxWRd/OXlKi1Q31o//yk8DnfDbhXRQvRRlVkki3YR97o3bNUa+HcPMVWdXT3iOEU8Oo1UQzcMSZJWjEsF6PdPjwq9BKBeMM+651X23OjE9UUKSpfY0ZssmYlP/ELJHwvpNogQA4OVvlxMCoxup4BbHd9xk5RuHAmUin6hamLcNk9VkYLIGuVv4q+aUBj273LKL77yZaCn+3IkEVKxWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oBpzh0CyYM42iGeScueNpoV0X/1ab6HsTBjmquwQj+w=;
 b=TD1gKgs3j5YfZGMxeyo9vbErC02RHv+cY5ImKUgSjMcs1XkNaaYi2NhFuv8fZV/vFWXTJp1XuvKvtC8iZNcdtENGK6nF/KWKDUJLbzx1kcpN9XIbs2xTKcfw7KQg46EOuJL5Ti8ibtdEY7ewUkBAXqLXAtz65TVQJkfBk0qrNVuSpdgBCdT20jpKVQoGFGWNDtMe1xMoJAPa/NdqSLOsmdtGGovH0uyNv40XUBwaYPerx+TpuuCOKrBtMfEQ+HF5IHAz84CZGd9RuAEuPQyDQhuh4FZBQAtoNAJ/MGGXFVlQ3TXkrLwZFRA8tcYMhT+Eku1NTCFa8HP5dVqZTnd0KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oBpzh0CyYM42iGeScueNpoV0X/1ab6HsTBjmquwQj+w=;
 b=C0p8brv7L1rsOtcUnj6dMLx3ti0NyjyQS7RbcBAgvn8EfHfCTo5ynbUVBBcJAfyyTDQX+v5LjoGR4IePLmypMiGVv51GAVe1cHKs/PDZG7w0FMo9i4jd3fT1z3jfwGQMCEtoSUIgl2ZVU4lrli3aIBmP+39kB7wVwD5Y/noeT5k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5723.namprd13.prod.outlook.com (2603:10b6:a03:40a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.28; Sat, 3 Jun
 2023 14:13:54 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6455.028; Sat, 3 Jun 2023
 14:13:54 +0000
Date: Sat, 3 Jun 2023 16:13:43 +0200
From: Simon Horman <simon.horman@corigine.com>
To: menglong8.dong@gmail.com
Cc: olsajiri@gmail.com, davem@davemloft.net, dsahern@kernel.org,
	ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
	martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
	john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
	haoluo@google.com, jolsa@kernel.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, mykolal@fb.com, shuah@kernel.org,
	benbjiang@tencent.com, iii@linux.ibm.com, imagedong@tencent.com,
	xukuohai@huawei.com, chantr4@gmail.com, zwisler@google.com,
	eddyz87@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 1/5] bpf: make MAX_BPF_FUNC_ARGS 14
Message-ID: <ZHtKl8UE3AmJ3OpH@corigine.com>
References: <20230602065958.2869555-1-imagedong@tencent.com>
 <20230602065958.2869555-2-imagedong@tencent.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230602065958.2869555-2-imagedong@tencent.com>
X-ClientProxiedBy: AM0PR02CA0155.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5723:EE_
X-MS-Office365-Filtering-Correlation-Id: 75aad7c3-240c-4e80-aef5-08db643cc39f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	VwEOQycc1990/5zahpC2gS9cToCtJRoRasxSOhikyC9BeKSKxSAzvyaMrnBcGfzJqL57bZx6tyVUtqui3nC/RJSPjXzCu+BHoPnXo4aAdIB/FSbK7OkGEIV9KYMbdsL89cTFPvBDxTz1tDDVTbFxBQMN5Dp21p5/yxX2uaoPIXCOhq9A9l4nUTrQtamXKkCVB2/wACq4Jwfknlc/R44a1iFJ7mDawpgDe1or0y+bLWmkZMIhz9jWAbEUVktTpnlYO5VpNMIxMItfFnqLcybT+bZcFDI6NG9uV64oT74Ud9w279eVjmL8WeR4gwnhoUMJdoBmLgZgkG174LfeE208FkIez+lWWryArbzLBmdBXksHQHRqGtUf+k+vAs6nzW1LftXbM48+qqe/ZUYICD8VFEDm2/po36xKnQt8GilvLB3RlYh5BVJpYWQ9xHCyPwL+Kq/dODb9z2/77jp5KNpkTb22n96LJ+UVWVb110bTeY6Z0bGDIJysriF/8E+msjgCaV0rnHF9BvvbmK22iJn/2nAAeRUUE5NSG3GJoEfVlKI04xLJS99mv17R/IoiHyLPHmymsCvGAIAfKzPuxy85UAhaBQDgHy1E2wmdlBEzsVt3E0xAQ6eSZExcML7agQu+
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39830400003)(376002)(346002)(136003)(366004)(451199021)(41300700001)(316002)(7406005)(7416002)(44832011)(5660300002)(478600001)(2906002)(6916009)(66946007)(66556008)(66476007)(4326008)(8936002)(8676002)(6666004)(6486002)(86362001)(186003)(36756003)(2616005)(38100700002)(6512007)(6506007)(83380400001)(88384005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7vcNcDFigERYI+8Tbg01YSaxiDwoGjMhnA0tJ4QF3v+OFuYQnkNQB2SyiBAI?=
 =?us-ascii?Q?z/9BgBFb9AjBn0HbhvrUan7g5s3ufiBDq/ef6YeXW1N5xBm6DrvWaXlTaEtl?=
 =?us-ascii?Q?/wPzjtYPdJdqG/oo3KX/kboF+MDwEo1rZ9p8V7c+3QpifBvvLaYoMBI6sw1T?=
 =?us-ascii?Q?jzZSAshlb/9pNH8Ip97KJOaPm33V1WGFjaNsI4AGksF51+f7t1/3vuAal7qa?=
 =?us-ascii?Q?wAvNCyfekdnXITFj/YCX6tlHbrnM3w6bUa5nJgoVUrQ7C3ZqndBAAhD6CH1P?=
 =?us-ascii?Q?EKp78gb3FCYOYxirBCLZWu+5xm8iKrQNU8srVL+aTcXohPHiIFFKlv1Im0k2?=
 =?us-ascii?Q?K4dznlshAbNUTFxCdZxZlVWp2CSvQHRKDV5kro2RJdo5erSwolc9g4sCyfkT?=
 =?us-ascii?Q?2SXb7iZLqS/6vDeygXyBv7se++JCSbixVBr2y14kHITxotNmcqKrWIn/btm4?=
 =?us-ascii?Q?ZRO2cpXBtc967e6NITNnUCZrAoitEx7jqav134GIa9I0jIn7cacz6uYm9ERS?=
 =?us-ascii?Q?thUlZtRl1//j7rgMt0LoQhsMZby9LTNywWmDo+sS5MuVaBrrC1/tABE9O6dG?=
 =?us-ascii?Q?tr+cdWVJRaeY+LX3lTiuhiMJLI5JyBS6ZH2HxQDon09xhRspd728CeDO0NXx?=
 =?us-ascii?Q?qKYU9QPmfI/i6wf21iPPmqWu5d6ksqKqJqPqiXrox48hZYQXQS1fCXo5Z3Lt?=
 =?us-ascii?Q?478GzW+k7Bq7AQtHccGtwfLb0mTzheVA1w+MRCtQdR/E/b7cy7ko1HJLbjHD?=
 =?us-ascii?Q?B4f5wUzP1rR0gESYRodstQ0Srgn8Qlwaku5DrgjGEwW3RpQTqpQ/9GI3D+8I?=
 =?us-ascii?Q?jY10s/cBmVDcl6Ai2i8//E32S8IBG46C72J8KTYJOi1glqOU9zYX8XllSqUI?=
 =?us-ascii?Q?ZAsTxjUU21/Qo2FBdDppSoHlxv+vPzAQLI1WvAimR6IavL8E9eL220N6vItp?=
 =?us-ascii?Q?4bUxE8E02T6vkr0siSOyZ3QLhP7u2TX0+BcmS63HrBAVYXux58+zNlX7Rmpn?=
 =?us-ascii?Q?CAcgGzQGvoEtbfil5EU9ubPAVkiBp2GDAfKxGiiwX0CUwdTKhhDymFnnqJx9?=
 =?us-ascii?Q?BRN8rZHfcToD9rxlrtzi2Tdg2yyaBe/b5Xqj/j0es5dTrejJlZ/sngah3KOj?=
 =?us-ascii?Q?hVymAKOZ9+dqslUQdwpic/WAnH5wqKpcr0XBmlylOor5bYiEziKf3VbO5/UY?=
 =?us-ascii?Q?eO15YK5k/XyC0ibcfXn60ilNSpvDfzjE7l7EIDY6/egtBKf13bKpqrtl/im1?=
 =?us-ascii?Q?Il5coTJC+cP+nCu6R3ICfVwNJQo9Uuq35B/BDB5icL3nXLcK9z3kEJRIYQCQ?=
 =?us-ascii?Q?OZlHrIITvvBYfAasuAFafRXU9Cqsnb91x5bjZJCNMxyt6584jTaMJnQU1f2h?=
 =?us-ascii?Q?tDCh8/HLPhHGJghoC3a8gpPwW4I1/NtUWaDMY69ubxFMiiT7j9DXP9Z0AqSc?=
 =?us-ascii?Q?KNw0bwEAthunJYwr3T3VoRoDHl1OCgKImTQCwa+zQkawH6qQr7FuACdY26Y2?=
 =?us-ascii?Q?fKGWF6+h8kba4ZP5YnD8WkArdnC9bILC+K0ANEACSV+BCNbgmYTQpYL/9E0v?=
 =?us-ascii?Q?E3Q/VTg/wU5FNXJISr25rDb1wyDtSINRU6S7AdIWbcnv2q5GLvGaITp23xyJ?=
 =?us-ascii?Q?Q04VtkEuNpVLv3njnoVFDzV11zbPH9SbQsOgUy2bfX1N4O9lktXk07d+MFH7?=
 =?us-ascii?Q?TrtsKw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75aad7c3-240c-4e80-aef5-08db643cc39f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2023 14:13:54.7244
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3oH7YvvL2mcvA9XZvT/kjukoZibeu1cnGuFGNN2dBhta1EO5VvB1y9HfQMa3SV6K7kV44XabDwswDPLhq3TU4RbCHdfn3c7PtNhG4ZXFHMM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5723
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 02, 2023 at 02:59:54PM +0800, menglong8.dong@gmail.com wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> According to the current kernel version, below is a statistics of the
> function arguments count:
> 
> argument count | FUNC_PROTO count
> 7              | 367
> 8              | 196
> 9              | 71
> 10             | 43
> 11             | 22
> 12             | 10
> 13             | 15
> 14             | 4
> 15             | 0
> 16             | 1
> 
> It's hard to statisics the function count, so I use FUNC_PROTO in the btf
> of vmlinux instead. The function with 16 arguments is ZSTD_buildCTable(),
> which I think can be ignored.
> 
> Therefore, let's make the maximum of function arguments count 14. It used
> to be 12, but it seems that there is no harm to make it big enough.
> 
> Reviewed-by: Jiang Biao <benbjiang@tencent.com>
> Signed-off-by: Menglong Dong <imagedong@tencent.com>
> ---
>  include/linux/bpf.h | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index f58895830ada..8b997779faf7 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -961,10 +961,10 @@ enum bpf_cgroup_storage_type {
>  
>  #define MAX_BPF_CGROUP_STORAGE_TYPE __BPF_CGROUP_STORAGE_MAX
>  
> -/* The longest tracepoint has 12 args.
> - * See include/trace/bpf_probe.h
> +/* The maximun number of the kernel function arguments.

Hi Menglong Dong,

as it looks like there will be a v3 anyway, please
consider correcting the spelling of maximum.

...

