Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3A5577318
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 04:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231621AbiGQCEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 22:04:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiGQCE3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 22:04:29 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F78E192A3;
        Sat, 16 Jul 2022 19:04:28 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26H1ZSCo017548;
        Sat, 16 Jul 2022 19:03:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=3l8FK+YBG+TJNpkuiiB7ssF9lFzSzghWmhPRh6ibkzg=;
 b=HvHnuG6uBDZkuDv5y24VXc23JodNau0Z2SqQsmqIFSVqvXkgTaue/Fsg2sIUNpOX5moW
 5mpJUjzD6zBTbT/8GrXk4RQDH65V4NhX52sRQ1fPcObQa4edDwfl+tYqvMQBvcUr4ggr
 aTppBXfNUdVd6PT2f9tDFr0L882maLl0qXA= 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hbscm2kwg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 16 Jul 2022 19:03:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lBOmR6i9EQ1MLdTKNeGnYz4WxjAKI6PCJyRzsUyDZOs9KsPuRU/lNKkc32iObrIiu0FyfOkjvqE7QiHWebkiaisNVCit+BM3k5w3TXpOwTVC60Ttl5Vsjv4NbQADGVrYUzLYejdl7ad9mabktJWdD+2WcN1eOrNBM7qmOBaHpsh7/OrwX9VsR/U6QcjqQEkk54mdAcloNxt1+jht4iL/bHjxde4+r+pDhHyskwAd4H7Qr72YEagLQSpOGc/E2OtNKfzkZWJU4cfyXHe1RonTY9Chu/s1kyFyJVw1xRgS9q3xp2ARk2OZfvSijhy+psizBFcZffqppEALQAylFoVWkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3l8FK+YBG+TJNpkuiiB7ssF9lFzSzghWmhPRh6ibkzg=;
 b=dFAZ7YfiZgygIYxo43IHgf27iHcPDHo1ixKpGOPsR+XPENMypaUzYQjValWauA8uCjCKZffs5nCQ6j3GyoDH1h0c3TAHVnlVLuHcgS8b78PHe2obzIr3Y67nYI+1V6ycOQdjS017H08baN3vAJe7RcdCZUfyXP5Ln/oM4BXbOkJaownySsa3eg+CVHKWPCehEu+0aXscZgEXQul/KI8bQ/M7DXbu2GxFPql9vwsg0PjXEdPk7+94sLtqYOfwlQWZIU5TCCMlhuxEDWHM+CMX9P/WHTHbJq2qltjUJJK+DCy3y7WcFaZRis2YRu6M8IyDY3AQD1VgBA9wuqO4HkHNBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by DM5PR15MB1404.namprd15.prod.outlook.com (2603:10b6:3:d3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.21; Sun, 17 Jul
 2022 02:03:57 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23%6]) with mapi id 15.20.5438.021; Sun, 17 Jul 2022
 02:03:57 +0000
Message-ID: <b516b0dc-df40-8dae-8b3c-16048d2bfdb3@fb.com>
Date:   Sat, 16 Jul 2022 19:03:54 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH bpf-next 1/5] bpf: Unify memory address casting operation
 style
Content-Language: en-US
To:     Pu Lehui <pulehui@huawei.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
References: <20220716125108.1011206-1-pulehui@huawei.com>
 <20220716125108.1011206-2-pulehui@huawei.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220716125108.1011206-2-pulehui@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0061.namprd05.prod.outlook.com
 (2603:10b6:a03:332::6) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a818e143-4fc1-4f80-1f3f-08da67989baa
X-MS-TrafficTypeDiagnostic: DM5PR15MB1404:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V+0EkXtzU8wQrjOIWJeMGe7Wot8veK2kLZyQAW5D+6n7e/4lDd0hJFhJD4cTBidFpY+bkNLl1AhIqQlSG+FCMTk2wMBjZuMG+O9XAbNsnxXQ6aHShZ0KM/S20TT1BLqRwv1fKnWn17W3qBnbSojzA0tduo+ygGq9PucA0yQhZpwCr407nXqrlFxykdKibwzTuttXFIseegonzRVPT72S/43CTKrDC5hXh+D8+3M68TEDWxqzXvGivwHzfK7ufRGNzVdWQvv9pP5y5MQYggNwFGqKOrMfK9Dwls5A/2uBaC5F70mDanP81evG/1vq5fOO8+efKsYjYx5RGfsu+wqY9NvQgpCNvBUO6TpnZj1ZLGf3328dsq51ue+fni5/7UJzSIgEkZKuYcir9GYVQISQkgjQ4Hz+RFPO8w7uA/jBeXlmotcoUAqEBimS5CxgNFtgonPu0IWknfvJuaHMT+I6AvjRv67wPk1xCqhsiJoch9SFMJJmZ0XN4dZCX9HQpPfAuE+MYz3C+4Ccsxv4docv3uh6rccwaUfszf+JPpltfTmgwO1xF/9ejcTSkXn65yXoVB3dwxG7jCeueFWiiKnT56B5ggAdciO9+UsO7oJFkvkHT86qdIFilC2cgjHlMngd4Pc1TtJ5SumQnATCdf/Rxu9a3h18W8a3JIUKNKCIWW5UbdTZLRDEwJUbwiC2oXw8ccqhflfSsGn4E1FETmjYxnUBfeiux9wX1PzGha2FjB3i5PFPNg9MB8xpZvdQPB/gHg/bybIGZ+nVWCKBz/G5WCW5xV8xUxcEw4wFGXFk3uwaQSXFhdVhmdPsf2ewutmiu+gEK+vmfLddcnpYE70M5xAhv9HSium+kA3phZjDfN4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(39860400002)(376002)(396003)(366004)(36756003)(5660300002)(8936002)(6486002)(186003)(7416002)(2616005)(2906002)(38100700002)(31686004)(41300700001)(6666004)(4326008)(8676002)(6512007)(66946007)(66556008)(66476007)(53546011)(86362001)(316002)(478600001)(54906003)(6506007)(31696002)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a0tkZFJzMUlLMTFkdVN6Qkh5TG15Z0dtS1Z2RGF2bkVXYmdtWDc0Rmhhc0pH?=
 =?utf-8?B?TGZWUjJaQkRGK2E2aUlNbi9keTZpVEIvUkJCNENlNjBPVHRjcExzeTFpSnFi?=
 =?utf-8?B?b0hKYmJSNWhBMVpPT1o3a3lMMTBVOStKSDYrbXNMOHVOK2hGZkhud2RkMGgw?=
 =?utf-8?B?aytxeDltR3RONVFWUU5EMnJxdVFybXNjMU9lbnNEelZSckRkdnZ4aitpR3Fp?=
 =?utf-8?B?V1I3d1ZZblZRZGh0ZUhpV0VoY2I5TEthbmZ6T3ZsMXNnVmtlYlRIL3gycnZX?=
 =?utf-8?B?eVlNQWJjV3hEMkZ0Y1QrdGpuVUJsbW9PRFFUT2NmRjgwS2pFNEpNVWl5SG1G?=
 =?utf-8?B?K09tUENTYnc5QzhVcU5YUTZLZHNyR0Rqc3h4c3hSdlhMR1VQWjVNSEZQb1JH?=
 =?utf-8?B?aEpNRi9jNDR4UVpyL1pLU1FUWitQUlA5NEZzaUREakYrRDBHbGlHTjI2bXNM?=
 =?utf-8?B?Wkd4QW0vT05YVk9TQ3l4MmdsUVloN2N2aldkdVZPV1BESmd1UVo3YnJ3MHBW?=
 =?utf-8?B?UEhYdjdPbjdrcGs3bWRVT1VxN0o3ZG9pUEJzbjczaFArc3JUd3lkVkhWaVBj?=
 =?utf-8?B?NkFERVhrU3hndkZ3RjE4VktFVUZmMVloRDI5cnNMZnNDYXVEdk8rd2hkUHlz?=
 =?utf-8?B?byt0SEJZWE16eWFGb2RuUHFpdlNPTlBGc3RDa0dwUVMySHJsVDYxSjVMOStR?=
 =?utf-8?B?R0thNTByWW52SHN3NVBXQTR6MDg5NEh0enBpRXVMNWtHSFBvY2E1S0NNMlZL?=
 =?utf-8?B?SzF0V0VNSDN0YXZUQm1JaFNhTi9ubnlrRTdHeDRtV1lYMVpBaXV2b1BWVVoy?=
 =?utf-8?B?ZkdmYXMrNGRRdG9zdlhFWmdBcUNZanBUUW5wTFBHZm9QaGlValZ4cW4vUTRt?=
 =?utf-8?B?aVRtejRYNFp1YTVvQ1RROGxNTGVScnJiZ01tTXB5alZaMlBZczU3T3R6V1hl?=
 =?utf-8?B?citZWmZBRDVQU0pma3JaYzNHNGt0YXFLZGdKTVluOHpuQ2lOSWJNSHluN081?=
 =?utf-8?B?dlI5QUVjTkMwbjlpaHZDaER4OFltOWV3d29scTVVZFZ2bkpaekxnTUlLYXgv?=
 =?utf-8?B?WGZad1BEZjF6NllCbGh0b2JEbnVOQWIvOWR5ZXVmSjkzNCs1WWpyTGJwQ2th?=
 =?utf-8?B?K1A0bFpId3Z4VnpFbHpSMDNpOUUvV0J2aWtoV2U4QzI5L1JNYWpBWllxTGVp?=
 =?utf-8?B?dG1BRUJEMHgvMEt0RkkvK2tLZysvaXNGSVd6MVhXR0xCQ1lsTUp2L09WNktE?=
 =?utf-8?B?RGVQTE5XYVZGT2RxNC9ZazU4R3pCZk1MUFFQSk5qQXdJMDN6Rzc1dFRBMVZU?=
 =?utf-8?B?ZkZ1cnJQR0FmS1dSQnNhNU5meUVrWG93c3FsdURHOVlNN0xFQ3ZCNDZGUXd0?=
 =?utf-8?B?MGZpM3hlbERFWExJVnFZSW1JYnlGR0c4d2t2U2NUNVFXZm84OHpROWw2a3k3?=
 =?utf-8?B?QndoTHJEdk1Zc3hPQUVWVHFhK29ZOHQyZTJtalE5OUxmSy90TXN0c3dEampH?=
 =?utf-8?B?WW9wMlhXQTUxN1o0azBkOHNJUC9yUyt2SkFQTGVYaitUcGFuZzY0QXdQUHpS?=
 =?utf-8?B?YkVRYVlWY0E5S1VZcHh1c2I5dXo5TDhXYnlyOWxJekhoN0tINE04QVlMVmlH?=
 =?utf-8?B?NmVFUWZhYkExT21YMkxUZC9ITXZaUjF1ZmNJdWVTdVczWXN5eGY2SXUwWnhK?=
 =?utf-8?B?SWdGaS90MENlNDZKMVVoTm13NDhZVnpGM3p6cnZRTVVPSGRZU1A5ZFB0Rk1S?=
 =?utf-8?B?bjNHVjRvMmN2RHIvN3pSVVE1Q1FHSUY0Ym9zMlQvc2ppeFhDdzNDTjZERVFr?=
 =?utf-8?B?bnM4SGdFckVVVnA4OFR5RVRodnNUL0tIeFRRaVpnVHBqYVFIckVVSG1obGZE?=
 =?utf-8?B?SEgwcmNlN0szQUd5dkdJMzVlb1VOUmZFMWlDalhqdGdwRU5RSmpONFJTb3Zx?=
 =?utf-8?B?emFGeFBZcHFnM0p1SHdYUU5tcEMzQlRZakQyVFdTL3VGcXJYVzRlWmljY2c3?=
 =?utf-8?B?SnAxUlpEOTY2a0h5QjhKSTVqTklhTHNRMTZ2K3pzZnFIdXU5SWlxSVE2MXJP?=
 =?utf-8?B?VWZaZFlsS3dtYWNDbTBKNGYyYVh3bi9ZT3FNYkRHR1lScUwrVW5wRGpoOEJv?=
 =?utf-8?B?RjkyNkFLaGhZNmJ4Zm5LbXI3OWpHeHdJL2psaG5Ja2pxK0FySHRkemJCRGpE?=
 =?utf-8?B?MGc9PQ==?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a818e143-4fc1-4f80-1f3f-08da67989baa
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2022 02:03:57.1747
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cpxPW7Wv97thsvs6vcweac+ZhfCL13Ki/4CaSrmZFYmnhrLp5W2SVTMB6APj5JSe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1404
X-Proofpoint-ORIG-GUID: hpjKZI1zFUN8A1rNfZzp_U3ry_m7sqiA
X-Proofpoint-GUID: hpjKZI1zFUN8A1rNfZzp_U3ry_m7sqiA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-16_21,2022-07-15_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/16/22 5:51 AM, Pu Lehui wrote:
> Memory addresses are conceptually unsigned, (unsigned long) casting
> makes more sense, so let's make a change for conceptual uniformity
> and there is no functional change.
> 
> Signed-off-by: Pu Lehui <pulehui@huawei.com>

Only a few in bpf system, agree that we can do the change so in
the future we can recommend 'unsigned long' vs. 'long' casting
based on existing code base.

Acked-by: Yonghong Song <yhs@fb.com>

> ---
>   kernel/bpf/core.c     | 2 +-
>   kernel/bpf/helpers.c  | 6 +++---
>   kernel/bpf/syscall.c  | 2 +-
>   kernel/bpf/verifier.c | 6 +++---
>   4 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index cfb8a50a9f12..e14b399dd408 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -1954,7 +1954,7 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn)
>   		CONT;							\
>   	LDX_PROBE_MEM_##SIZEOP:						\
>   		bpf_probe_read_kernel(&DST, sizeof(SIZE),		\
> -				      (const void *)(long) (SRC + insn->off));	\
> +				      (const void *)(unsigned long) (SRC + insn->off));	\
>   		DST = *((SIZE *)&DST);					\
>   		CONT;
>   
> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> index a1c84d256f83..92c01dd007a6 100644
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c
> @@ -903,7 +903,7 @@ int bpf_bprintf_prepare(char *fmt, u32 fmt_size, const u64 *raw_args,
>   					err = snprintf(tmp_buf,
>   						       (tmp_buf_end - tmp_buf),
>   						       "%pB",
> -						       (void *)(long)raw_args[num_spec]);
> +						       (void *)(unsigned long)raw_args[num_spec]);
>   					tmp_buf += (err + 1);
>   				}
>   
> @@ -929,7 +929,7 @@ int bpf_bprintf_prepare(char *fmt, u32 fmt_size, const u64 *raw_args,
>   				goto out;
>   			}
>   
> -			unsafe_ptr = (char *)(long)raw_args[num_spec];
> +			unsafe_ptr = (char *)(unsigned long)raw_args[num_spec];
>   			err = copy_from_kernel_nofault(cur_ip, unsafe_ptr,
>   						       sizeof_cur_ip);
>   			if (err < 0)
> @@ -966,7 +966,7 @@ int bpf_bprintf_prepare(char *fmt, u32 fmt_size, const u64 *raw_args,
>   				goto out;
>   			}
>   
> -			unsafe_ptr = (char *)(long)raw_args[num_spec];
> +			unsafe_ptr = (char *)(unsigned long)raw_args[num_spec];
>   			err = bpf_trace_copy_string(tmp_buf, unsafe_ptr,
>   						    fmt_ptype,
>   						    tmp_buf_end - tmp_buf);
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 83c7136c5788..d1380473e620 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -5108,7 +5108,7 @@ BPF_CALL_3(bpf_sys_bpf, int, cmd, union bpf_attr *, attr, u32, attr_size)
>   			bpf_prog_put(prog);
>   			return -EBUSY;
>   		}
> -		attr->test.retval = bpf_prog_run(prog, (void *) (long) attr->test.ctx_in);
> +		attr->test.retval = bpf_prog_run(prog, (void *) (unsigned long) attr->test.ctx_in);
>   		__bpf_prog_exit_sleepable(prog, 0 /* bpf_prog_run does runtime stats */, &run_ctx);
>   		bpf_prog_put(prog);
>   		return 0;
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index c59c3df0fea6..d91f17598833 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -4445,7 +4445,7 @@ static int bpf_map_direct_read(struct bpf_map *map, int off, int size, u64 *val)
>   	err = map->ops->map_direct_value_addr(map, &addr, off);
>   	if (err)
>   		return err;
> -	ptr = (void *)(long)addr + off;
> +	ptr = (void *)(unsigned long)addr + off;
>   
>   	switch (size) {
>   	case sizeof(u8):
> @@ -6113,7 +6113,7 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
>   			return err;
>   		}
>   
> -		str_ptr = (char *)(long)(map_addr);
> +		str_ptr = (char *)(unsigned long)(map_addr);
>   		if (!strnchr(str_ptr + map_off, map->value_size - map_off, 0)) {
>   			verbose(env, "string is not zero-terminated\n");
>   			return -EINVAL;
> @@ -7099,7 +7099,7 @@ static int check_bpf_snprintf_call(struct bpf_verifier_env *env,
>   		verbose(env, "verifier bug\n");
>   		return -EFAULT;
>   	}
> -	fmt = (char *)(long)fmt_addr + fmt_map_off;
> +	fmt = (char *)(unsigned long)fmt_addr + fmt_map_off;
>   
>   	/* We are also guaranteed that fmt+fmt_map_off is NULL terminated, we
>   	 * can focus on validating the format specifiers.
