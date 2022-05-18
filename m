Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAF4152C058
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 19:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240626AbiERQzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 12:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240636AbiERQzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 12:55:47 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 945102044CD;
        Wed, 18 May 2022 09:55:30 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 24IFiOie026104;
        Wed, 18 May 2022 09:55:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=hCxIqXAROiYxGF0fuVRcFMoG8jDqOMyxZlty4Kw2kDE=;
 b=Auji2iwW2k1xF2qeFYGAwK1ZXaRl39fFEXtZqruwHeO/RJ/fHMtk17eKARc49zj6wDod
 P2sBNcCb4wkhoPEHgZ+S/qOdBKf/dtbSi9ifFhEhUWztwdgxGmG6H7sckIIWHevH8aPx
 g5S+UpcujNbveyFHLdQ3LGUz8kiViUJQ3VY= 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by m0089730.ppops.net (PPS) with ESMTPS id 3g4836u4pw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 May 2022 09:55:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=glpclpN8tRXKncN99za6gVBNHeUuxrz8nwPL/8xultGuRZPkSVoQ3o0cTGdQHJ4zIYOsJNQgCxRvsmFFkOPDbh6WFNXZCEGp46ZDBJDaSxw2ODm1cbQ8HSP5a50nfTgXXK01mIcgXihhp1x2i7ovoj2A4Y3rnfXwubHarpQQdT9zUsLFmbLulnTBuHNvjxnDFNsyhjYsLpPyyEYZ7Usnt2Nk6vLGhrsy/LK3/NYt+LdtUNpLBpYDzhZrq5G5fvCAnkU0zbArD2LoWnYfbCtOZlPV6s1//0RwB1/7iIRrTy/SdB2A7kiIq4rw0cAlgj8e5un8IxXEmO7GVXjJvsly1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hCxIqXAROiYxGF0fuVRcFMoG8jDqOMyxZlty4Kw2kDE=;
 b=ijUBHbHV/xxekyaYIR+JEmi+RC9dxHn+dFPkAZGXLv8GO0HScj89YN8UfX+KRuOweSKtbIEfsC77y1zL8p+KcVXbKyLhX3yXQcqB5BazQXCLWN/o/GGT5HwzyQoK8x4gi+cUkPLMmZZcgp4JZjQOuNkPG6bdIpOR9cU0p1zXRtWe/Lu0ofn1dKnI6TiMCQtMvOEjrIdGLFdiUlYanQbx7UFGmVM32TKZLXcYLt4wcASN88EmONHnQnDacV0YZG7i5KH2sTpUsjhD52Jl9eOud9ZNKiDDeOJsW6IHS8OwheUc3EBdWj8+1+sWnaqK+RBikFK1+0K3LBTQr5/kRMkFpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by MN0PR15MB5346.namprd15.prod.outlook.com (2603:10b6:208:371::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.15; Wed, 18 May
 2022 16:55:10 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53%7]) with mapi id 15.20.5273.015; Wed, 18 May 2022
 16:55:10 +0000
Message-ID: <7bbb4a95-0d12-2a8f-9503-2613d774eaaa@fb.com>
Date:   Wed, 18 May 2022 09:55:05 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH bpf v3 2/2] bpf_trace: bail out from
 bpf_kprobe_multi_link_attach when in compat
Content-Language: en-US
To:     Eugene Syromiatnikov <esyr@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1652876187.git.esyr@redhat.com>
 <47cbdb76178a112763a3766a03d8cc51842fcab0.1652876188.git.esyr@redhat.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <47cbdb76178a112763a3766a03d8cc51842fcab0.1652876188.git.esyr@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0P223CA0022.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:610:116::8) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1dad280e-4f91-47b9-aa24-08da38ef2b8c
X-MS-TrafficTypeDiagnostic: MN0PR15MB5346:EE_
X-Microsoft-Antispam-PRVS: <MN0PR15MB5346AAA3A187485CA7CFB21CD3D19@MN0PR15MB5346.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +wjrUaguIi+jO7c2hhtsqtmw1/7LHhCcekzdrThdAbFwT81M6uJBsdhLnWLMcTN21h7gP2LrMLEbGQHqZXaHd5b3waTPghhAaZ4pzJ4xm3IF4xeMWYrYDeK3i5clauQERotADGmnfdeFhJlSkveN1t1+f5b4PItO7C3RhKiYJiokcOqPC8XnLHwLWJx8Rld30kyc4SYPkqRwWpkgK6C6FiD1XoKvpHeEDE5yHvv5D1Gt4Nk9puFVUjMZJw3RdDanx9gmmNpwCE1TvAK57xofEkMKx+fRvrldNu0x6j0BqTF3P9LeRe7YVVWqgf5w83QUnXRXWRKUKziULy/D9fI99bwCZpG7u97YlphxM6ebYApXHFq9DonM81AG+e+q4gWyietopm73rsAGHsjxzkScHstR0cZLUhvXwD28Ep3q7bjtjWNUhlWXhM4jO/Xq628apVBKQHt+NNrwIQSU9w8mV3xuPfQOtFCVYjz/CzUi5reP/0kAkfjDwh9nV9KNn2r5EsBgFFZjbcW/rJp6o8WwFZaXTmPwTE3VbmNeYjGYkRZHC4pJzsa2PdBR9zgM6kg8lCvstE5+m0847/XaQdb8kfCaF3gOHye+gxpnaCWd0bMc1v8xVu8/VZIFP0yCAT/ZJDyecGgLAV2+i/mjIdBeEXJ2Zjbg1tvZNkBfr/5oLr1Y85hrE7h4QWYS2a41NE2fa8EEmC3olRZJbuhL0uvkd9Z/PhDpFE6NMYEgS8FMArmvKdbHH/WjExy2TCJadw4H
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(66476007)(31686004)(36756003)(53546011)(8936002)(66556008)(66946007)(7416002)(83380400001)(6512007)(6506007)(38100700002)(186003)(2616005)(4326008)(52116002)(6666004)(6486002)(2906002)(508600001)(110136005)(54906003)(8676002)(86362001)(316002)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y3g0dDlWdnR5TmdHTERQb05CbUk1eUsxOXhNbGNwZVpNZFFtT24vdTUxUHg1?=
 =?utf-8?B?NitiVVpTUStsQ0pwSWI5Yy9GaFR0T1BTdmpGTnEzc05LSWFYUjVBeGdlbGxn?=
 =?utf-8?B?VnlkWUtWd2NWMWsvTVErNnUzVFFiNFhwVHBpZ1I0WCtwS0xIVWZwa2tNNnhL?=
 =?utf-8?B?SW8xNC90cVl1Y1o5NFFLalVqTW5FN25jNTdoejlyYUF6eGJITnU5ek40Z3ZU?=
 =?utf-8?B?MFlMclEwTFE0eXJZSDdvaTYvdlcvZmZ4c0xxdGhhcG02NmR4VjdRd0NlZzJi?=
 =?utf-8?B?WmdIQmNrazIxeGE4TXlBa3VIRkdDckhEODVmWndUanpZNzRKdG1Na1l3MStk?=
 =?utf-8?B?U0NaZ0hRbkZWMlVwQ2V5Y0hKcCtTMnJIQ1ozMnR2dm1rSm9SWUNXQlJqeTQ1?=
 =?utf-8?B?NzU0SXVVQWxGQjBDNkxYZjJvdWdMVkVOdWg1bjVRQ3pBZWhsZFpKYnkzNStZ?=
 =?utf-8?B?K1I3d043NEdJNFp3ZHc5UitwYVB6Q1hqVTdWUGVySWY5cDZ3Qk5MQ0h2eGNR?=
 =?utf-8?B?dzY5cjBmV3FaMDlCaDBBdTEwWnhKRGw4Y1I3ckw2eGd4T1RQN2l5eWczZUNI?=
 =?utf-8?B?UmM1enFQazI3aGxlSlY4WlpPY050MVFDdjJ3NGlxWmt5OGhnTWk1amZtRjRO?=
 =?utf-8?B?dXVVVVJFTVpDUjAzVWRrWlF1dGE2anZwWDZnenJBWksxbEFjbmN5UnZ2Y3Rw?=
 =?utf-8?B?Nk1jNVBXSFZOMXFHZHNpSXIzblVNT3JxWkxBZlBVUVJpcENmbjIzZTN2Qkhm?=
 =?utf-8?B?OGpwOWh1TnBtNkJQQ2NxOGN0eEJDQnJWL3hLZGxhQ2JNZjhta1NEYXhQQTNO?=
 =?utf-8?B?Ti85eW1wSjJlSmFhREJVbE1yemZPbGg4a2RjUHJPL2dneHphQWY3Z0NNbXNZ?=
 =?utf-8?B?RlZUbVlEWVdDYUF1czNTUHNvSU5YVEpPRDVjOWNVY1IrNmt4MGljeXAwYzhz?=
 =?utf-8?B?Zy9veG5XTERFVXRobTI1L0JwOFVoWG5aVm1rd0RBcXdYRUwvYkpaTk9BUWsz?=
 =?utf-8?B?NGUzcCthclprckpSZjE1eUkrdmRhaUdNK0lad3d4RDNQMUZQOGV3SW1UbnAy?=
 =?utf-8?B?VVh5NnNzYnR5enVEY1JWZkM1VDdQbFN6YWtVQ3pGcUo0dFRmR0lDY3Q0Tjdm?=
 =?utf-8?B?YlJHZmNscldUa2JKdi94d3FvMldaWHFLS0puYXNhSGpwQUtoYmV3ditidE9h?=
 =?utf-8?B?aGFLMy9GK0lSS3NsQUF5ei9HZ2VYbERlMTBoVWE1ZGw3L2U3Z2RrK2F5T0xO?=
 =?utf-8?B?RzF3U1pXakE5MVBqYnBkaDRPM2RhVlpSMk5sWEdkbS9jRnQ2U1pvbTNiVTYr?=
 =?utf-8?B?a043MTVVUEE4THRsd1cwQTI3UlNCVklCWXRGZUlsWmpYNWloWHlqUXVQN1NQ?=
 =?utf-8?B?dWVxVHB5TFIrK0Jnc2Yzb00yQnBMZXhuc1ZXQ0w3bytXU0d3aEZXZFZYNEYw?=
 =?utf-8?B?Y01iTzdML0tzOGpsM0MxTkVzWFZRLzkrNG8ySTBMNi9yRENrYW03UklGNTl0?=
 =?utf-8?B?ZlZva2NiSCsvcjVBdW9KU1FHdCtFU2JsaXczRmdGUmZMTDlXdzVod21ibnBu?=
 =?utf-8?B?Wno1UTROOVd2MUZPU0Z0a0RsTnF5R1VjZTRXWXBCWFJvT0FwZ0RaWmZrNTlj?=
 =?utf-8?B?Q1hmRThsVWZnUTMzcFYyakVncVduZGFNSXFFNndZbU56MFNIZk9sQ0ZyZEpR?=
 =?utf-8?B?M25YUUhINUkyZlJHWXR3NTVZZ1BlNFBoc2kvSUNFWlVPRUFZU2NqT3dTS2Z5?=
 =?utf-8?B?TjlXbUhzTkhYNzdtSHQ5ekZjSGVtYWZpL3gybmVUOFh4N0dSd3pWaFYrU2Q5?=
 =?utf-8?B?NjBTQmUyd0VHUlVqZXpYQ003ajJoZjZwbkgyMk9VQ0lVaTFnVzFBTEJpWmtY?=
 =?utf-8?B?alpTT2F2VFdRTkp6MU5tUzJ1ek9XSjV6Qk1hMEhvMUxTcG81WU1qUmx5cFU1?=
 =?utf-8?B?VG13WHpmdWgwNEFDTzBNeW5LSVk4bG5tdFpoNHJxM0RaT2RQc3NvNnl5ZXNp?=
 =?utf-8?B?dC8yTXdFUlMxUU9NdXFVVDYrWmFSNDZrcFdSOXVXTkZGNFdZL3Y5OEVRTkVO?=
 =?utf-8?B?NmRLMGgyMDNpcHNLZFNQVk1ORzdWQWt3bWxUZ3VvT2g5R05iZ1p2V1ZFc1NC?=
 =?utf-8?B?cDlodU45ZkIyaHpLcUJSZVhiZmU2bXRJaFdoeEN2all1blRZTWRiWVZqSkdO?=
 =?utf-8?B?V1FZczlXOTNrMUUvR1pBdUJFTlM4TEdsUGZzOVhMZk9FM0sySzh2N1lHTEx1?=
 =?utf-8?B?cy81N2J0amloamUyL08rMCtnaGtiSDNqMlowZHBpN0hab2R4OHFPdy80MTM5?=
 =?utf-8?B?dFVaQ3RobDZyUklmUWttMllZYXVyc1NsRkxheE5TZ281UE03aW9CZEcrOHlF?=
 =?utf-8?Q?y9Tr4u3bpaqGUHlY=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dad280e-4f91-47b9-aa24-08da38ef2b8c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 16:55:10.6418
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XA6J6Xm8TiRnoZUvba+omjaatdserB2OrSBUf09JBAExKVEgeZKf+6mRFvjLzgOa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR15MB5346
X-Proofpoint-GUID: U1UAF1akmDsGBlszXKAAwR9zG7C4ia7-
X-Proofpoint-ORIG-GUID: U1UAF1akmDsGBlszXKAAwR9zG7C4ia7-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-18_06,2022-05-17_02,2022-02-23_01
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/18/22 5:22 AM, Eugene Syromiatnikov wrote:
> Since bpf_kprobe_multi_link_attach doesn't support 32-bit kernels
> for whatever reason, having it enabled for compat processes on 64-bit
> kernels makes even less sense due to discrepances in the type sizes
> that it does not handle.

If I understand correctly, the reason is due to
in libbpf we have
struct bpf_link_create_opts {
         size_t sz; /* size of this struct for forward/backward 
compatibility */
         __u32 flags;
         union bpf_iter_link_info *iter_info;
         __u32 iter_info_len;
         __u32 target_btf_id;
         union {
                 struct {
                         __u64 bpf_cookie;
                 } perf_event;
                 struct {
                         __u32 flags;
                         __u32 cnt;
                         const char **syms;
                         const unsigned long *addrs;
                         const __u64 *cookies;
                 } kprobe_multi;
         };
         size_t :0;
};

Note that we have `const unsigned long *addrs;`

If we have 32-bit user space application and 64bit kernel,
and we will have userspace 32-bit pointers and kernel as
64bit pointers and current kernel doesn't handle 32-bit
user pointer properly.

Consider this may involve libbpf uapi change, maybe
we should change "const unsigned long *addrs;" to
"const __u64 *addrs;" considering we haven't freeze
libbpf UAPI yet.

Otherwise, we stick to current code with this patch,
it will make it difficult to support 32-bit app with
64-bit kernel for kprobe_multi in the future due to
uapi issues.

WDYT?

> 
> Fixes: 0dcac272540613d4 ("bpf: Add multi kprobe link")
> Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
> ---
>   kernel/trace/bpf_trace.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index 212faa4..2f83489 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -2412,7 +2412,7 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
>   	int err;
>   
>   	/* no support for 32bit archs yet */
> -	if (sizeof(u64) != sizeof(void *))
> +	if (sizeof(u64) != sizeof(void *) || in_compat_syscall())
>   		return -EOPNOTSUPP;
>   
>   	if (prog->expected_attach_type != BPF_TRACE_KPROBE_MULTI)
