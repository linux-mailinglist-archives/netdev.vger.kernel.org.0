Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2ED4E9B43
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 17:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238280AbiC1PnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 11:43:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232931AbiC1PnX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 11:43:23 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CA475EDE5;
        Mon, 28 Mar 2022 08:41:41 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22SA64re017315;
        Mon, 28 Mar 2022 08:41:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=5zygpzw4t7eVj3392s+5tDTT650If6i8XaWl2eTMR7s=;
 b=p7xJJlc/+OhTcCNV5RripEURRUzhwWpHA2ffytfO1jNQoMCSiSGx9Fs7Ueo1O9cEcWr3
 AX35fsKhiQ8v8Q3VYX+G2VeGL666E0MXTPUaeogbhQpUOD5TMwP8WZj6EjdhH+C2YwPG
 JXXkcf1TNkB6poSFdElICfHLIs8xG+hS5t0= 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3f1xvgu2vu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Mar 2022 08:41:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fFOfQ08mA7Jy7SqUO8Z76DWf5Syjj9ePt8uY3PKiyfluXCN4fXt4WsOqVGfxYkrdhvLJhGcaBjEGUi5cn9cHCbDm+u5dOgDLf52nSMO/OLCkRecBl1Hoqgq1lWJH+kC+RMjQvAIG/tXdCYvgyWq7kkhg0Ap147IcVXyMlVl7+Zkn8nJk3gRMHGLh79jPSvWmqI5vO0CPbVcgxClcFkSDvas0l5yJuy/v8vHYICPFaNY0N2FgkmNeCsxox9dwXsSdcONMuUIJCS8icELe9PgqNuKt6/NOU09jFQ/oKKQoBmhdFRxc9ePEkXAZWxRw2z/yFIUyWKYtcPkConXVy6mI7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5zygpzw4t7eVj3392s+5tDTT650If6i8XaWl2eTMR7s=;
 b=mFs6lriNA4cVQwMWTq72ZnBHA5Pzye6oKwQET+RU6fzbITZbu0D6EHSb4c7GLIuTzt9PimnS9aMuacjOAVxNXh2dognYFJmXCQWRPqIjjfCeBhqqSFyVSxrTy8sV4AzrZ7UEqpwWLrWKdvnFpCZm8LwQKIZkv19UfB9p/Dp+GCoMq4gqW6Fsph0++pFNc4D82cK1BHk33gUsxf/jXEYtEAQ65u15ggq6DNpSe5fJKefqRr6EXyam7VCATW1smQY7UfM7nKSY8OM/tQIs/2a/JDkVrspcaPwugxyKVL8a5YjN9v9WUCMjUJ8TbK87UFk0ok4jvt5wrhIm+qlKsmRtrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by MW3PR15MB3915.namprd15.prod.outlook.com (2603:10b6:303:4a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.23; Mon, 28 Mar
 2022 15:41:22 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::4da5:c3b4:371e:28c2]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::4da5:c3b4:371e:28c2%7]) with mapi id 15.20.5102.023; Mon, 28 Mar 2022
 15:41:22 +0000
Message-ID: <9a040393-e478-d14d-8cfd-14dd08e09be0@fb.com>
Date:   Mon, 28 Mar 2022 08:41:18 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH] bpftool: Fix generated code in codegen_asserts
Content-Language: en-US
To:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Delyan Kratunov <delyank@fb.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
References: <20220328083703.2880079-1-jolsa@kernel.org>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220328083703.2880079-1-jolsa@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR04CA0378.namprd04.prod.outlook.com
 (2603:10b6:303:81::23) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3d8f3203-a806-4573-e1aa-08da10d168fa
X-MS-TrafficTypeDiagnostic: MW3PR15MB3915:EE_
X-Microsoft-Antispam-PRVS: <MW3PR15MB39153ABEB0127B618DBD6E49D31D9@MW3PR15MB3915.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X5qs+Ocf56gQCG63lq90oHzEGgN5OIVfgrDsch8wPN884jUrKskqS7q1jJi83jSayKimFk7bHeqadC9XPDdicv3fr+GYIieHHquF5x+o1ilXHnC3Dce1CclG22HwX2jQ48Zz9bYDRrI/yhKSQFTLh9V6m0gBn/hbrQyU8Ey3s1k/qtHx+cge3HTHo6ceBhL9o9IWDB+x/7BvINslAC5/85ccHfn1Ch2pZa+JHwhywdVT82oWPX48MJJ7bIVFx5a6U2WG57FWqKe3mevxXNzMGb0iw9razAln67lsUw9/Fc7ddn50jMPS9b7sS7fXz99FejwRW0w5rJ1LN7gI3VxUl+cTwj01zNKN0+MJJ7trnS0KRXQ3AcVll80fy0+SMHN5cCvzvAz3tMHtNNeUzzqTBfFLqsvh1d++ROBwnav2XNsFNmGZ8K2C9OQRS8CkHdZsy+oZwSKMecSf/1KGdt5i9Mix6jwg30BzQraYZlv9YFgWz+oWkW8BJf1Ak8EmYO5Nfsh/rFVmTYgb7w6lnLMkSIXb8HPseUvXahI0/4rhqaZDg6Hm3ruRjb0UiZZQo2hS4BAD4N/dW/0ShOcI9vk3C8Rk4CmgqkJCV3RdTr2NSPKoJU8wJFA1tUzW3PLK2QLyL79MUzbNZPwJCVX4mcX9viUV4oVUb73qXMgcRy57HC6HBHwo0ygOKRw8dQEOGD78crIx0uOdfbPcNWNN8ajLeRUwAsAlb8+EW7WhJcLjIOAzNLkV9ybT9zsKnyn3F8Ec
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(54906003)(6486002)(110136005)(316002)(36756003)(6512007)(186003)(53546011)(2616005)(52116002)(31696002)(6506007)(508600001)(83380400001)(2906002)(5660300002)(8676002)(38100700002)(31686004)(66946007)(4326008)(66556008)(8936002)(66476007)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YnB0OWxCZkMxdC8vYU4yMngxQkdvcmZBSFU1ODhCRlpQbUQ3d2JGa3FKUi80?=
 =?utf-8?B?cWliVC9qcVdsREpwL1ZuRDJPQThETGpQWWpKZlZHTjJESTlBUjF1SmZhTTF6?=
 =?utf-8?B?cTRSTC9Mb0FzUGlFUktUeDhZYXRVSzdHV0l0RFFCMHI3UDJJSXNRc3JicDM0?=
 =?utf-8?B?Z004TGEwK2IyN2wvTHlaSlA1aDlHdXoyTzNzZjFHNGllVUpUNDdqRUMwTTlS?=
 =?utf-8?B?RksrTjRWQ1R5QmtJUDliZzFwTm50YjdwYWtLaFExUW52Qm5lSFo2MGJnMXNN?=
 =?utf-8?B?dHdwcDVsMld2ZmJweW9HanYxRHlaNDdYN3BwY2FmVU1IVEJPVzVLdXBnNklG?=
 =?utf-8?B?VVBVUWJYT3lyQXJOTml5bE4yKzQzVHZland1N0tQTVpHSkhnTSt3Z2t6RHNy?=
 =?utf-8?B?N1JzN3UzUEVqY09rRjJxTkpRQ0phU0dxeFB5dlVOdXA2VVhzZUlTei8zTHFi?=
 =?utf-8?B?VmM0dS9qdTcrYlBGc1NKZDB1bjJkcHVWajBRYW4vTXI2UlAySmYvMXRKSE9k?=
 =?utf-8?B?UXdBSHE1MHpnTHpZdFhRQ2w5NVdoeUZpdjZEVFFwQ0N1Y2JabmtNS211ZjAv?=
 =?utf-8?B?THluRzNMc1NZVEdnUStvNWcwejJmSG9Gb3kzSjM2VVBQcWdIcUd2dlFwb0Q4?=
 =?utf-8?B?SExYT2dPcTdDeS9NR0haTlVuZGFCZW02cHFlVTZJcC9WK2J1cEc4bzRxampZ?=
 =?utf-8?B?UWtWZEZ3eE9FYk9HTFkvbEV1S3U3UU1JZGd6dWRaT2FsZGpqNFVzTlhWN0Ri?=
 =?utf-8?B?bkFzK21kcFpJazN3YWlxNDF0VjFXRkl6WCtBTFBscll2Nk1La1RBZUR1VXA4?=
 =?utf-8?B?elhtRC9ZbzBrRGxld2JqSm1TNUc4OUhKYnkzYlZ4dlJHTGlnUWhxK2VqMWw3?=
 =?utf-8?B?VGlITUJVUng1K3BrWCtHNWIxaUZoSDZMaXBSMWZNWGlDNG1vTU9qRmpNSFJI?=
 =?utf-8?B?bzRGR3BWRXB0YUZib0xyUitJNmdRTXNzRHQ0cXUzaEE5dnJ3VloxeWtJRUUr?=
 =?utf-8?B?S08vRDZkNUNIclhkZ3V2VUFHZlJ3WGVkcE5yZzZLejB5M0xEdFk0UXVacXcv?=
 =?utf-8?B?aEVsVmY2TktUTWFXOElFWDdwVTZ6bVNqcm8wNnB5Z3doNi9WdjNzMHZReGJC?=
 =?utf-8?B?Z005Ui9hSnh2SVlWZDVTcSs0dU1pMm9pR2gzcDNnSFZ3T21PZXlRbDdmQXBF?=
 =?utf-8?B?V0JVaDYwaFc5c1JxTmdsd2xyckZNNExwdzBUdU5ic0xtV2srK1BlcC9SVG94?=
 =?utf-8?B?eGFadGptVC8xL083Q3dCR1hRWWtQeXVXK0dDcU1wWnBXdHVSaURxNVFsalJ5?=
 =?utf-8?B?RmxVWFp4RjdUNEI1N2xPSTllTTI4M2RxaWhEdjMzS1RrRUV4TVBYTERwNEoy?=
 =?utf-8?B?ZzhIdE5KYmFXeXhwS3RtbmpFcUtGZE0vRStVUlZuaXJsc09HK1dYcUNuVHNw?=
 =?utf-8?B?bk53bE9YeWZMUkIycS9IbUUzWUpocWcwcTNnYWllSGFlYmZ1bFY0anU4eTNN?=
 =?utf-8?B?SGZ4a3hUK0pqN1EvdEs0djFnRkZOUkxnb3oyUW01bkdSTzQ5djVzcEhpWitI?=
 =?utf-8?B?ZkxRVVlUMVQwaUhabHorQUFoWlV4SHpJNUpJRmtZcjArbi9kZHJOeWsxdXpP?=
 =?utf-8?B?UmZvWUVxSDNEak5YNE51VExVTDI4dG5WTHlKSEVHMnZseUhFRDB4YUNEcGNP?=
 =?utf-8?B?UGhDMUNSdmkxTUtDM0VHV01lYWtXWGY2eU91dEY0QkFqbE45Yk5CNTNBckhs?=
 =?utf-8?B?NkZRUUhyWllDL3dlUjRxVWFyalpBdi9kZklkSHQwdGFwQXV5N1d5QVE0cFJ3?=
 =?utf-8?B?VE9GMHhCdVVDNHVLNG1sWlE2OC94R1pKR2d2L2gzb2didStwU2ltOXdZMUVu?=
 =?utf-8?B?T0JicG0wajQ4VVNTVnlReDQ0UWZqckRpdEhXZ3VUelFJNXE5bHFnNEU5VWxw?=
 =?utf-8?B?ai9BQ2ZoUDFJSWZaUldPOE0wVVk2cmtvUXVjS1ovbTFJanRPY0RPN3Z3endr?=
 =?utf-8?B?SXRTQ2pSakZERm96OXNsSXQra1hoVk1wekVBQXE4ZjNEUHA5MkdYaGR2c3Z2?=
 =?utf-8?B?S3dSRjBHOFAxVFFidHpGZEM5VnhuL0xkbnE3b0tETmtNMTQzRzM0VldCUzBT?=
 =?utf-8?B?Rlh2Wm51V083K1VzTS9jR3FPVFlscC85RTdnK1FaS2plSFZDekRudHNwS3Jr?=
 =?utf-8?B?cmllVGpxaEhBYUhoVXBUWThYWXN1QWdPaXRndVVBQnltVE9LWG9DZlNEcWZk?=
 =?utf-8?B?WkpMYUphSVdOOEtRZ2JmeCtwSGMzdStvUnpSUjd1VVQxaHNCcWYyQlliYmNP?=
 =?utf-8?B?NzJma1hxaGxHcE1ObmhzV2tWWXpnd0MwamNrSGdBS005Q3pLdVJSK2drMjNV?=
 =?utf-8?Q?ClbgOVv/x3AuKbBg=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d8f3203-a806-4573-e1aa-08da10d168fa
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2022 15:41:22.3702
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7kNoUIanz2vMu5CBHnGLPg+5fOFHwB31XEAy3heCnTk7wDOtckt4Z/dB5MSna/LL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3915
X-Proofpoint-ORIG-GUID: OCBKZjac7REiDj-Jl-LYh2Xav3KlyFPY
X-Proofpoint-GUID: OCBKZjac7REiDj-Jl-LYh2Xav3KlyFPY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-28_07,2022-03-28_01,2022-02-23_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/28/22 1:37 AM, Jiri Olsa wrote:
> Arnaldo reported perf compilation fail with:
> 
>    $ make -k BUILD_BPF_SKEL=1 CORESIGHT=1 PYTHON=python3
>    ...
>    In file included from util/bpf_counter.c:28:
>    /tmp/build/perf//util/bpf_skel/bperf_leader.skel.h: In function ‘bperf_leader_bpf__assert’:
>    /tmp/build/perf//util/bpf_skel/bperf_leader.skel.h:351:51: error: unused parameter ‘s’ [-Werror=unused-parameter]
>      351 | bperf_leader_bpf__assert(struct bperf_leader_bpf *s)
>          |                          ~~~~~~~~~~~~~~~~~~~~~~~~~^
>    cc1: all warnings being treated as errors
> 
> If there's nothing to generate in the new assert function,
> we will get unused 's' warn/error, adding 'unused' attribute to it.

If there is nothing to generate, should we avoid generating
the assert function itself?

> 
> Cc: Delyan Kratunov <delyank@fb.com>
> Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> Fixes: 08d4dba6ae77 ("bpftool: Bpf skeletons assert type sizes")
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>   tools/bpf/bpftool/gen.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
> index 7ba7ff55d2ea..91af2850b505 100644
> --- a/tools/bpf/bpftool/gen.c
> +++ b/tools/bpf/bpftool/gen.c
> @@ -477,7 +477,7 @@ static void codegen_asserts(struct bpf_object *obj, const char *obj_name)
>   	codegen("\
>   		\n\
>   		__attribute__((unused)) static void			    \n\
> -		%1$s__assert(struct %1$s *s)				    \n\
> +		%1$s__assert(struct %1$s *s __attribute__((unused)))	    \n\
>   		{							    \n\
>   		#ifdef __cplusplus					    \n\
>   		#define _Static_assert static_assert			    \n\
