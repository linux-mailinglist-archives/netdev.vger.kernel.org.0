Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5B15560771
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 19:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbiF2RhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 13:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiF2RhL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 13:37:11 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C08773BBD2;
        Wed, 29 Jun 2022 10:37:10 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25T5aLcH025121;
        Wed, 29 Jun 2022 10:36:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=x58BXN+PDF95Jq9QefzpwbAjIYBGTx1r2Tt4ak+TMnE=;
 b=Je/ucdYYDRoFHyhkbKgp/GElT5mym669PQuKA4PYPYR5bLDzJEi1Y0DzJATIgoU9te7x
 DwoFkoTahSu3mAlORRl94v+0NYN4+R5Q6fjN6XnD5NE7iedt11tvAj2RiIabf54c4Sdi
 obvM/vVr/TUdS6Hb6Q1TtjZsd7XMYJRzAEA= 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h0691fsaa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Jun 2022 10:36:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MeL4+8rHWR0CAQVroXj+DThkGd6SqE24SY5gZkP98c+bR00/X04Tr30YWp/U+rb6R5MAk23M8gHBoEK5I4wCieNWjYtqiWWf2wJmSgfjxZSPGq56T+BYylHOfG7iXLFKfQ7oEI9iUSR1GWA3Fnes4hCKwTlZA0CF+YhtotMBSstMrSsTZfKHA0aoBUOc2rwYhlR4a8xcq6idJIqCajTcn7sokkCdwv2cdaAh659U7jO3rukuyAhp42ZZNfjop9npnplOJXmFJ7xIqfQmngKl7vQzrfckriK3GzQ61z4ifN7uV5SGjrZdz3VgnpjpbYucsQCuRxw4g5WNrUd2W+jmnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x58BXN+PDF95Jq9QefzpwbAjIYBGTx1r2Tt4ak+TMnE=;
 b=a28xfpMQumTpJhMDUJdO2IcPkS5jBo/XRlYFRtM0r88tCmdg/Csj6Y0niKccClavUwU7BhauFXiMgSxQ+sLKtv91folcqtWIgkhVlupiXNkUKTjgdDBzscVB/zH5lJ3etebh9wSZD1VlWnOEZm+fDcR8lxsTKnIHejhoBW1wbCKqfoudKT51blOJXaF0ylw540MpSy0RIkehbElJ2QWu9lJpauUnjibiiP6kvGs+YTv69eLlza5XePJzh2Py5ppOaFlcMoj8BZvJgwXVnwTBPrbfsl8ZpTScUkGX5STOZdkP9Yh9sloxLWf5ImYXliGyALcDTihtNi6drSy981wSAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by SA0PR15MB3872.namprd15.prod.outlook.com (2603:10b6:806:91::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Wed, 29 Jun
 2022 17:36:51 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::3941:25c6:c1cd:5762]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::3941:25c6:c1cd:5762%7]) with mapi id 15.20.5395.014; Wed, 29 Jun 2022
 17:36:51 +0000
Date:   Wed, 29 Jun 2022 10:36:50 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Jules Irenge <jbi.octave@gmail.com>
Cc:     Elana.Copperman@mobileye.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] btf: Fix error of Macros with multiple statements
Message-ID: <20220629173650.c4e67cmz7jqiadon@kafai-mbp.dhcp.thefacebook.com>
References: <YryJosfh8z2DhKC0@playground>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YryJosfh8z2DhKC0@playground>
X-ClientProxiedBy: BYAPR08CA0062.namprd08.prod.outlook.com
 (2603:10b6:a03:117::39) To MW4PR15MB4475.namprd15.prod.outlook.com
 (2603:10b6:303:104::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: efadf9a0-5a5e-464e-49ed-08da59f5f3a1
X-MS-TrafficTypeDiagnostic: SA0PR15MB3872:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0P/cuaLMLX6rTYuf336ePCouTpnDGuf9o78QtWCWwhDb2WhAweDqC9d41mboY6eW04FXBRPr6fwwfO9IvJADIfNBCNxfZMLZYbPfsPNg6yJVTojBLINmXqLcF73Et8hCkzrDt6sfn6I2tEIgdl6ZGhVeN4qbHgSlcVJ4Hhp2J2uxNg0RKMfjziVaHN1BehAm2wBqiATnTGwGgGT1uldSuitwuR0utzB2ikVC8lpzTdbJsUTGSS75MKUWpJLukUR1yXAir6PNAkpNGP8Xh13M1rFArAy4SF+snpX53BjlUodGIi2c8j9mlNWLJY+eH6VWmpbjPIXSY76h7uSNzzme1zS+MutjxQ5vP+TTR7IH2HPf3gV/aVpnm5P65bjA4nXzVMA391BoduJSh1OmCEBSzKsiVeixkMaZcEZqhuWw5g9vTt5swFmwpfV9Ea5YLQQ4g0sxsqqz2Dw0WtBiA2hfRKZpPUGrx7YrQYPJihCTs7Ynj0+4cMHYwn7JCahE8sQOe+OKcO54CLW9CU80EsMbUMNj94Ru0Cwzmsd30JGHkXWej7GLjwlR+ePv3rDTzr4woBBqTOcV4sKcZnym7K9qdKUzADXfyYDmAf+r62u7LIhDvFOvao8K5z55tk5hMk2aPK0F3Tl+cVkBfXZbSqxQUHcTpMDNyG8QeeYUyx+/uEcus9bweHAeu8d0UNv2Pi8FWFNG1dogpYCm4Fb50cZHD61E88YC9POxSOMY46rok+g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(396003)(346002)(39860400002)(366004)(38100700002)(186003)(54906003)(1076003)(8936002)(6506007)(6916009)(316002)(66476007)(66556008)(8676002)(66946007)(6512007)(4326008)(9686003)(7416002)(83380400001)(52116002)(5660300002)(41300700001)(2906002)(86362001)(478600001)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uK+ZStvZNGd36mzUdaQGacuYNrRQLSr+EB3U+Ua7/8GgNGIsRPPIaBSUR1Sv?=
 =?us-ascii?Q?DPSt0cQpI8H9ID6MuJ+OEquU6i81Z5SanWsWLRwtyHXy9i1ieuLug+uspCZY?=
 =?us-ascii?Q?INYdZR0olTviLx3j2sk/ahoncD7K5btDx56vrqelNx46GVvPicI5wVuqIoJU?=
 =?us-ascii?Q?FU2pe5SMItpBMoYuZfNKKln95iR/mCUmLRQ09VPfPofK96/iZFfJLjkFQpgK?=
 =?us-ascii?Q?TgqTLjy1cn2zyS+69TeicwlrwTECPKxGhPBsBCUqcVyitHygMsTa1swVMytO?=
 =?us-ascii?Q?MQUwey0YlaZbSM2b5aD3KoAH+QaziSB4Sp/3s6kmKg9ppnsUhRWOldBHG7he?=
 =?us-ascii?Q?nPRuT0wmhPLQJiedXxtN8IG1OdBBOn5CPxlbbzuSMEVtX+h8aODkJHZo+ZUO?=
 =?us-ascii?Q?zla65VuPX+vmJkIwe38kRrTe+jTh4QMYJ17r5FNEj9q0YOeUu+Aq3H3bM4GN?=
 =?us-ascii?Q?omYfn7ckg+wmdbwfNHQ+AWACO+L/wVxMSk7mRrjW0OeIc6292/kqoKl0+dkD?=
 =?us-ascii?Q?8BiaUWNUWVFi2BcmEutouKavmLVIfYNp/YghEgQPmqhe0ewyQwFO+mnx1mYg?=
 =?us-ascii?Q?kevEPxtbZ/myNedw7dR37LYe0P+Uxhj0Uq+Tr9GXQjl6oAdnWUqvtH88/puq?=
 =?us-ascii?Q?9Lj/XbedRGkndEGyyyURkXCoQFn+B0vj9FV16TnBuBGuXaSgVn6iQQ8ApIoN?=
 =?us-ascii?Q?3K1c3Zdlm/JBkUI9wMoTzFhTXFuY+SZQAxKUCCkEK/nogLDY7V4TjZwbpyBr?=
 =?us-ascii?Q?DOIVuTQtWvA2CGizB1SYtxeX7KSMp5xSmk6HnBdqm4KEs8eWF6OKa37o5cI6?=
 =?us-ascii?Q?1TRKkK9Y4CQGEp5Qf++52xBV5+yeafvhrhQxLS1E/ZHHAgF1fvamKPVb8pSa?=
 =?us-ascii?Q?Qh+2OBiJqp+jHxB0NcIz4tuRjwpjyAwxnrwNGZOYmLHORUEDppjCDaYGpJlS?=
 =?us-ascii?Q?dQhINs3BUYBjNSx5nO0nEfllbQcLaePxteUcrQxE71sNjTYhHa/+dLjsBjdU?=
 =?us-ascii?Q?ukSuL+snl9MARihEX3HMFXJR8jIRVqrW2I3Yh1jJ53dS0m7OIP64h/abFRcO?=
 =?us-ascii?Q?m2u+p0dLFGkCzgNUmjDCcFtWbFq0v/AutgvI20d/3RgBGHzYKFeomjsdxPU1?=
 =?us-ascii?Q?9Xv7lvg2Nh0nRRkj+bpEq7o02B376S31nzCBDbETObhiMP+Da9oDz9OFyc02?=
 =?us-ascii?Q?/M5bEPIJ/6tjuYQ+ZxzdGVDmP8InItNoBNPbbjBpV/JcPBWkTa/a2Samnkfk?=
 =?us-ascii?Q?XQvs8hssa+b2b/kRXNcWVCTGI5djlXrehE+viI6wYIAWpVsK3yHcU5YXx1kG?=
 =?us-ascii?Q?X5coSS1fOYnAEYQXFVLuNGKRl4LoZTOqwKNf7aUBfCgJBSSGaSvj9PKAa6uG?=
 =?us-ascii?Q?mZX4/7y4dNsboFvp9JygZijtfEgWMcuK46uky8cAeFlq3Qu3hKzD3DmUBKHX?=
 =?us-ascii?Q?lmqvHleYO8QVaEUUOQ57OyT6gix51IxxtzrkcAi4IDdty/2sUVmvk7WNyG1G?=
 =?us-ascii?Q?QYh4tbZYRsY7xV1OA1woXIruWeKjeoAIR3sUlNwr0q58Q1JNJaXqL67cmFLy?=
 =?us-ascii?Q?BzlRHwiZh1SUDky7xOvH876TsarmwaUmcBXknvzuXYqmCdukZbr8jgm34Uml?=
 =?us-ascii?Q?Lw=3D=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efadf9a0-5a5e-464e-49ed-08da59f5f3a1
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2022 17:36:51.6733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KHVOQZ0JStWo6rYwL7M+gk9YYmj3iiaiqgocS4kbayzltY5pcrxuYsutrAfVpyVO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3872
X-Proofpoint-GUID: e6iEIS58VZ9f_5egw6RDE6Xzydj38McY
X-Proofpoint-ORIG-GUID: e6iEIS58VZ9f_5egw6RDE6Xzydj38McY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-29_18,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 29, 2022 at 06:19:30PM +0100, Jules Irenge wrote:
> This patch fixes an error reported by checkpatch.pl
No.  It is not a fix.

Have you at least compiler tested it ?

> 
> ERROR: Macros with multiple statements should be
> enclosed in a do while loop
> 
> To fix this a do while(0) loop is used
> to encloses the multiple statements.
> 
> Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
> ---
>  kernel/bpf/btf.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 1bc496162572..95c1ee525e28 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -5057,8 +5057,10 @@ extern struct btf *btf_vmlinux;
>  static union {
>  	struct bpf_ctx_convert {
>  #define BPF_PROG_TYPE(_id, _name, prog_ctx_type, kern_ctx_type) \
> -	prog_ctx_type _id##_prog; \
> -	kern_ctx_type _id##_kern;
> +		do { \
> +			prog_ctx_type _id##_prog; \
> +			kern_ctx_type _id##_kern; \
> +		} while (0)
>  #include <linux/bpf_types.h>
>  #undef BPF_PROG_TYPE
>  	} *__t;
> -- 
> 2.36.1
> 
