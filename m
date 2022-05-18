Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC7A52C079
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 19:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240326AbiERQeq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 12:34:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240290AbiERQeo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 12:34:44 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA751F8C66;
        Wed, 18 May 2022 09:34:42 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 24IFiZmj014904;
        Wed, 18 May 2022 09:34:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=9ivSK1xbwugldoW4jyUK2Ob6lGYrY7E6EZmjYd4l4l8=;
 b=hz19PdUOOqR1i5pxTRpNghqfH6rfrf3AqUE3s5X5ba6wkY9MM4mxq2yfKUF26COLaWSN
 oycvjWseGcjRigz1igY79zddnXrUP4tyejZknLo05hEQmd1DWpdF1SHjgkXsug9q3IoK
 lH2nf0CSQpwvoJc0YDVclrkt8NT68uvDSrE= 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by m0001303.ppops.net (PPS) with ESMTPS id 3g4myhn8a9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 May 2022 09:34:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RGQvyOYWkuw3vJPKexkp7FNpdpYKNrn4dEfC3WtX1xFt8AXhTbw7Vdbl0CEEO+hFGS6A24j4rq1kfE6wnHfl5cQV6cZWBoUtq6WpOY6XTVku96eIVkJZJiIGaY5TrIixF8TnNG4dLGBV0LobEiLkpOc0BwBSRO3O4Urh7L7cMniH08fzM3UO5+E/aJpnB+5BR5o4EhOlMpU8gCRwK9Rhh6lqWfHUc0uDpgYtfCYNtxj+8DxycPvmP8QDcGxLkrjRsnnne5iwLJLRVPvaqos44GgwifeTTcsYlWPM2GGfznwDvnXHSMOp+IiqVQvmO1kVrYm/v2TMwqYGS1AxXg8FxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9ivSK1xbwugldoW4jyUK2Ob6lGYrY7E6EZmjYd4l4l8=;
 b=iWsbqRbfdruONTZbREeaKW7fqJYS3A53KlnzAh5nFvoOxWcL1n1XsLe72SxN/c62tKsl1UraKW0N7VEWOWYXQkYwdEWnq/wjkDQpyP5yQiBRyYCdEMdvVveVOPZ8dpNlzye2z5sqq9p+nbEsdhuQuZB4KfoDMI7F5dYwWROChoHkuaNyppmAY58ruZlKpege3Tfn5dOKRPTsWf9ntqgKwjYjWoaQVA7dhOO3oVF1joEGzrIE1gGhVGd7sjIAFoQJ9al/6vpKCyeNsRAUcixboluU3wqW71eUPIcJ9jdNexI5sWeHi1r9egDZMiYBhR2M8JVfzejX5f6Bw8GJApchqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by PH0PR15MB5088.namprd15.prod.outlook.com (2603:10b6:510:cf::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Wed, 18 May
 2022 16:34:24 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53%7]) with mapi id 15.20.5273.015; Wed, 18 May 2022
 16:34:24 +0000
Message-ID: <412bf136-6a5b-f442-1e84-778697e2b694@fb.com>
Date:   Wed, 18 May 2022 09:34:22 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH bpf v3 1/2] bpf_trace: check size for overflow in
 bpf_kprobe_multi_link_attach
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
 <39c4a91f2867684dc51c5395d26cb56ffe9d995d.1652876188.git.esyr@redhat.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <39c4a91f2867684dc51c5395d26cb56ffe9d995d.1652876188.git.esyr@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0012.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::17) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e3b351e3-ff1c-4fc6-acb8-08da38ec44d4
X-MS-TrafficTypeDiagnostic: PH0PR15MB5088:EE_
X-Microsoft-Antispam-PRVS: <PH0PR15MB5088DB323E582B1CE316F7B0D3D19@PH0PR15MB5088.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fdcZpRtyvw4Fi5kOu93phn7lMrOJZuiC2DpjiaJQ/9WP8TYL45ToHsIikTvY1HqATfiFaV4uHYjNBSNfbxrto0PV/Z3KB9pjHiIV54fJzX4OpvD9rL+0KxMrVcamXoISl338aOq+xl8u51hv9fpzbADKJMvh+eDt93J+tRLDSp78WdBC6A0y6C3FDNzcSFyjG6XPryPQzv23wLY74I0SMAEATOJ7yPafFV+GZaXvHea47p67rk8kakBr+krapGJjklMxvUObwaDB0YRt3zwm4NERIv2D1Hqi1Lhpp5D72ohjbtQP96oMCrF7U0KygO5Wgy9sb4nRKbsuXnpcysvF/h0uqm3EdTjdQocPIu5GZai6bkFNN+E9ffI8owbTra1B4BlHCr/7iOo/uhjI7Y3c6OrcGtQZVoBNJbSIbH6ZeLiiMscHGCYw8yoqD8vhWhjbh/7aHWMc6wdp+tCQEXPKMhecogitZnXp5rHBYElKO0V216/kK0Rvz0JiAjVfGpauNSgXsisS/E9FEHNYAX8l8nlOnIypeH6GS2psmwYqMmXzlhePkTrkh1X1ohM7i2lF9Uqb4AmRnZFOWCEA9VlAFcyZmc9OOP1JCx7coHVyJxmiqVYAfJOLNKsNibBSNJlEi6+2vJ+KqwKx7YwSimKZbCrwMNO2MWXNPXn5PUAuRKiwgcCH9X7K1l5Y8R1UaXawkLaLFYRecN6yow9swOmgte9RfrH/MGW1TIfC+zNkKEdK+Z3QbTHiYNuZQL2aNvPA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(7416002)(31696002)(8676002)(6506007)(52116002)(2906002)(6512007)(4326008)(36756003)(5660300002)(110136005)(86362001)(66946007)(186003)(66476007)(66556008)(53546011)(38100700002)(316002)(54906003)(6486002)(2616005)(8936002)(31686004)(83380400001)(508600001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Tkw2R1MvSmxMaEpTRFNDbnVWUzNqaGQ1QTFQYVVteGJudjVLNC96UUN3OCtj?=
 =?utf-8?B?anIrRXhwUHErK05DTWFlc2s0alNVQmgrR29uRWpBMHBKQWdFWDE4Vk1CeWZh?=
 =?utf-8?B?S0kvOUtkeHBzVzFvWGMvTlFXZnpocEZ0ZjFJSTRGVnFBRGorVXVhUVNDQ1N4?=
 =?utf-8?B?OE1FZVlsOGdOUURCSHdGditmWHRMQ2hyamk5Wmx3V2hkR0xyNXpXcmxZSy9F?=
 =?utf-8?B?V1d5T0l1TCtmQW1wWDNCM1lXcnNkdmk2TGZKZTJqRWUwODJQMjEydTN3NjZ3?=
 =?utf-8?B?ZU9PbExxa0htQ0xkM1hDaklCWUxIdUduYTB2eGd4L2xsQUJQMk1rOStydWdl?=
 =?utf-8?B?U1dpYktQL21xVThoeElBQ293KzJ1MlRmZzdQT05xcC9uOE5ZdWZhMG9wc2lH?=
 =?utf-8?B?cE5HUmxDcjlPWnpySkpHd2dWd3NXcUNQczJ0YVRrVEl2Ynl1NUYzeERVcjlQ?=
 =?utf-8?B?eXBDSlRmaW9uQ1A3UGlLL0JPSXphUnlVUFB4eFB5ZVB2MVRQNHdQSFlHOStD?=
 =?utf-8?B?ZTNVZGlmZWtIdDRqdzYvdW9GTlFNTDR0clVDME43SWFSKytNVWp6czZBQ1Ft?=
 =?utf-8?B?K0wrdUhzVGpFUVVYL3NZakcwNFczQlByNG96NXZHRzQxVU5rQ0MyNFlzUGY5?=
 =?utf-8?B?QkFNakYyRGhwU04rY1FGVFBXcG1ZWm1RVHpxOUNGZTJmbG1Jai9OcWUrSUdE?=
 =?utf-8?B?enFiSHNvQjhFVW53YXFiYXVYMFhUK0NzeWFldXhmWHdHMm1IVCtpYmJpUDgy?=
 =?utf-8?B?S0pqL01pSnFhSURnOXFsYzgzOWlGWEpvZjdDKy9HNHQ5RGNTUVdPT1J1SWRp?=
 =?utf-8?B?eG1YOE41ckpSVFV5Vzd2eFVOaWlsdXl4dGRnYnE2c3lqN1BNaTN3VzU2OFlL?=
 =?utf-8?B?NHA4TEgzdkpseVMrVUc3OG8zVVdwTzBxS3FFMFJ1a0EyMVhmVXR4dXdkcFlX?=
 =?utf-8?B?V2R4TndmdUZWWEJ1dnV0TUxJK3Q0elRiSTJ6Q2RHK0xld0JmR1h0dHAzcFZp?=
 =?utf-8?B?VkZRZEFYbVY2MUs3RjEzT1ZoZmpaeVRLUTRxd2xwaDd1RERRNGVHTmRQQXlL?=
 =?utf-8?B?WXFqZFVJZE5lRHN3eEhlb1VJYU5YamtvK0VjbFA4UmJ6aEdhN2c5aXJpVG9B?=
 =?utf-8?B?c2tYRksrTExXZC8xdW9LMEt5dXduTnVpeklWaDBSaittM1VLWmJoWHAxaWd6?=
 =?utf-8?B?akJYVWdxaUo4THpiTU03V2t4cStHRWZNM3h0T1pVbHhxMEdhSFBobzQzVnlr?=
 =?utf-8?B?VlpBTUIvRnN6bzBQazlndlF5d2lVNjBpUGhaMHZnSVBFS1dHVVVVUUx1eWZH?=
 =?utf-8?B?a1lzUVI2L1ExRFBHbldnSWg0eGZIY2JxWVNXSzBSOUl6b2JhZDBGcXgyQ2hJ?=
 =?utf-8?B?VjAvU3VFSG9KQlU1Y1JINWlCUjg1OHZXWW9JZHhmTXlQdkdkM2E0OHZFNCtz?=
 =?utf-8?B?VmZkNFN4U2J1QVM5ZWV2WFkvVDdiTDhLejFQZmx0S1lOL0FheHBoUDFJbkU2?=
 =?utf-8?B?U1dtNnFpM2N6RFdsK2hhMmZpMlNBaFlqcE04Sk96RkJVQURmUExOK0E3eUZL?=
 =?utf-8?B?YzRZTEFDeHZKWW1LWVk3a1E5QzRRMER4ZkdRdFVmM3FRUVhzZmdYcUFlYUcv?=
 =?utf-8?B?YloxS09FS243dlNpUHJ4Qjc1TmNTYnVUM0tUVGliMUpiOHlyT0F6Q29sTGRT?=
 =?utf-8?B?U09UY1NkbFZONUJlVlZDR2dnbXVQZTBKNElXMnlSRS9IZzY4Ykk5UnBsMzhV?=
 =?utf-8?B?ZGtXcDM1bEVNUDFOY005WVRFN1hNQVlaSVoyMFlnQzNUUTNvTFNOT01wQVV6?=
 =?utf-8?B?TzlyS056VWFiMTM1NUgvTWRSMURUTEVxaWhXVDNmUC8yQnVEZTNodkNFNTIz?=
 =?utf-8?B?MFRTb0hxZDl4T1paMXJyd1FhUnBremFtRzF0a1VaRE43Wk41d3htQjZ0Q2Yy?=
 =?utf-8?B?OTdaQmRpckJwbmxZcUJMRXFpbDBMelFVSUpUdGU0aEoyZGZrQ0JZTzFlOUY2?=
 =?utf-8?B?cGVVMm5TUGlRZmZ4d0ZINnNXK2NwdmdpS1N3M2JPc0hpUjVWTHViSjNhOGlL?=
 =?utf-8?B?U0hoT1Rxc0RMRGpibTI3b3RDRWRteTBydjE2alNGSk5Iai9xenh0aEtQd2pB?=
 =?utf-8?B?SHZnb2pBY1h5TUF1MmJ1aFFwbFZ4WnhGNkloWVlxT0Q5Vlg2aXdSa28weWh5?=
 =?utf-8?B?V1pYQWIwWFhkTFJUSHJUY1I4b2FWaS9OQVJKMEM1eUYvQ0p5NHVmOVFJY3BB?=
 =?utf-8?B?NFQwQm5pZmRPYklHcXRXV3Znc2o5Z3VqK091SlVsV0IzUmxqL2w1RE11MXFD?=
 =?utf-8?B?djVwa3VGMUpsZ2tsYnJHdkNnTVk5MjFjaU44RWFadmpOR0ZzdlUvMDNydlFN?=
 =?utf-8?Q?C0AFoKG+F81qcADY=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3b351e3-ff1c-4fc6-acb8-08da38ec44d4
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 16:34:24.5822
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CP1si6+zvrzyT9lEaWfFVLLWlpiLjCr15k1kYMsTHnKcfnDIP2Xk1TT7L6RKuZVP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB5088
X-Proofpoint-ORIG-GUID: OtLMnv-N3Y5M6bc2duUoi88r0w5EYlWm
X-Proofpoint-GUID: OtLMnv-N3Y5M6bc2duUoi88r0w5EYlWm
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
> Check that size would not overflow before calculation (and return
> -EOVERFLOW if it will), to prevent potential out-of-bounds write
> with the following copy_from_user.  Add the same check
> to kprobe_multi_resolve_syms in case it will be called from elsewhere
> in the future.
> 
> Fixes: 0dcac272540613d4 ("bpf: Add multi kprobe link")
> Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
> ---
>   kernel/trace/bpf_trace.c | 13 ++++++++-----
>   1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index d8553f4..212faa4 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -2352,13 +2352,15 @@ static int
>   kprobe_multi_resolve_syms(const void __user *usyms, u32 cnt,
>   			  unsigned long *addrs)
>   {
> -	unsigned long addr, size;
> +	unsigned long addr, sym_size;
> +	u32 size;
>   	const char __user **syms;
>   	int err = -ENOMEM;
>   	unsigned int i;
>   	char *func;
>   
> -	size = cnt * sizeof(*syms);
> +	if (check_mul_overflow(cnt, (u32)sizeof(*syms), &size))
> +		return -EOVERFLOW;

In mm/util.c kvmalloc_node(), we have

         /* Don't even allow crazy sizes */
         if (unlikely(size > INT_MAX)) {
                 WARN_ON_ONCE(!(flags & __GFP_NOWARN));
                 return NULL;
         }

Basically the maximum size to be allocated in INT_MAX.

Here, we have 'size' as u32, which means if the size is 0xffff0000,
the check_mul_overflow will return false (no overflow) but
kvzalloc will still have a warning.

I think we should change the type of 'size' to be 'int' which
should catch the above case and be consistent with
what kvmalloc_node() intends to warn.

>   	syms = kvzalloc(size, GFP_KERNEL);
>   	if (!syms)
>   		return -ENOMEM;
> @@ -2382,9 +2384,9 @@ kprobe_multi_resolve_syms(const void __user *usyms, u32 cnt,
>   		addr = kallsyms_lookup_name(func);
>   		if (!addr)
>   			goto error;
> -		if (!kallsyms_lookup_size_offset(addr, &size, NULL))
> +		if (!kallsyms_lookup_size_offset(addr, &sym_size, NULL))
>   			goto error;
> -		addr = ftrace_location_range(addr, addr + size - 1);
> +		addr = ftrace_location_range(addr, addr + sym_size - 1);
>   		if (!addr)
>   			goto error;
>   		addrs[i] = addr;
> @@ -2429,7 +2431,8 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
>   	if (!cnt)
>   		return -EINVAL;
>   
> -	size = cnt * sizeof(*addrs);
> +	if (check_mul_overflow(cnt, (u32)sizeof(*addrs), &size))
> +		return -EOVERFLOW;
>   	addrs = kvmalloc(size, GFP_KERNEL);
>   	if (!addrs)
>   		return -ENOMEM;
