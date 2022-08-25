Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ADDB5A1CE9
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 01:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbiHYXAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 19:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242557AbiHYXAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 19:00:48 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A129524F39;
        Thu, 25 Aug 2022 16:00:47 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27PM4EQP009509;
        Thu, 25 Aug 2022 16:00:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=OmkLj5Myh3hymJJK14gqPoKd6G2/AMi3OtGulds5Ajg=;
 b=FLVKHXt4oQnuiQ7qlJsWvp/E8EzXUijLI+wANoL8Zh3W+xMHdhuwzTTLFvlsxmvGI8Rw
 tOw5ee1o0wwJlGUpVMNqHjvXb9ZuuXcUqC8z6VKgOSfRVxZwC8u87gHxYMltTwIM14ip
 z7H8oCleLk62p3qhpQ7YhbjdeQpFf7cbgh4= 
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2170.outbound.protection.outlook.com [104.47.73.170])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3j5nfckhtk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Aug 2022 16:00:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MKTq84LCNUSGSIy+ty4VNTlFNZzhz/lvzLxDQETokh4n8vO2osq0emfIurBeQA4LIk2psGJPEBjP8hF0xQnJ8Cg1GSr7qP/g0oYng6J8bJkr3QqY+UkPCRTVnWoTtthZbFW/bLlm7yqztVSaJl9vKYusy3GimUYswtmxKCEQs4JefmU/sX0aoqAz5P2sjYvIupPetHGR4Wcsk9wJ8vbkRB3oo3sQnrf2XlGVGUQZTBOOtA/36SCaWMfH/lgp1VXCFFT2lTSoh+Z2hTkxkMRFf60QAeMKNwjxbFYyO4MhLFCf1WUPxs5GBE3dZEaQKK9agTe7drCuL++twARCMbcY6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OmkLj5Myh3hymJJK14gqPoKd6G2/AMi3OtGulds5Ajg=;
 b=cO0RfkV0FDmOTJEwZwlU7h1mM3Sz1urx8hjvAfclujXxdwifRuGEejwmr+sK832uVzeJ6XtrPMs4gyzoGltzVVQDoiv0/ZqkNQvbYvMDKm8nTcLvtOX01+5R+6PGJmrB/nOUwmNQ1oo0U8DmPayE5B7ziQxkL5W1kf2rfF4NY56I+QnuOm/bYvtXHLkWuzQn3kF4FrMPaSWh4+2T3Ggr+5bClWJ30ILSJWmoCgsxIwmIBcB74Cu06Msvk36B/+dSVsoIuGH6pkzCR8TS8oDi530x8/UoQeSKSiuepR7AeZmM7iy/yRZWWN8RUvy4oL4NSZCLnHcY2lbLqtIF3Km00g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by DM6PR15MB3626.namprd15.prod.outlook.com (2603:10b6:5:1d3::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Thu, 25 Aug
 2022 23:00:20 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::dde5:25a3:a125:7bc7]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::dde5:25a3:a125:7bc7%2]) with mapi id 15.20.5566.015; Thu, 25 Aug 2022
 23:00:20 +0000
Message-ID: <9edbddb7-4a3b-f8d1-777c-66e5f8efc977@fb.com>
Date:   Thu, 25 Aug 2022 16:00:17 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [RESEND PATCH bpf-next v9 1/5] bpf: Introduce cgroup iter
Content-Language: en-US
To:     Hao Luo <haoluo@google.com>, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, cgroups@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Tejun Heo <tj@kernel.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        KP Singh <kpsingh@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>, Michal Koutny <mkoutny@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Yosry Ahmed <yosryahmed@google.com>
References: <20220824233117.1312810-1-haoluo@google.com>
 <20220824233117.1312810-2-haoluo@google.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220824233117.1312810-2-haoluo@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0137.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::22) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f640b99e-39f4-48cb-617e-08da86ed9567
X-MS-TrafficTypeDiagnostic: DM6PR15MB3626:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5JlwBIf2GCWUkCGra5igF24qgLnha2rfcTX1G5EQt06KpO8bTDfPC0d6clkkQ4fklYRV61X9U22eLKxYsK94Lp0orxKk+6AnRIuO0z6IZWMbw3MDRsuh7rLQtRMnwB2qQbgXdhbrEc4Ywg3bPGAHhNvXR95TS8w9uponlisoVJ4kzz1wnYG5OICLTI4ZSchwRl3dS2pgWjpYnH6OBRjquCnKul70WBDkr8OI/IROTKDFIVwDebU4qBqQtDHx7TbSq4wJ8tzanbmhU05GGJJFxBow/j5tHhA4hlctqC2xI/B3+omJiWCz9nbfPkV+tyUQcdwS5x2MoD6xn/NyVEKpcMDbNEf6lJM2BYZwCsdBsneDwEPBhAY8ZSjlQGuFBP6Z+wGnMN0FPmJmIHxDbin0fROHDyZtET35FZNI4tHWuGHkphhH/GM71fncAZozd3ZdDyMQpk/2ASma7t4oeGGvj4dLNM1Qs4j/IZwbRlwjHQAKH41Kv8nMhK7TmFhsW0KBoEWGyz/NuIyamXQcroeGJSTL7Na81oxXzhVrRm7caQJX4mz0nYyzCdIm2zZBcnxOKmsca/KUMUoGf+caPbfdOLSDShHKhHZ5Ml82S7HDslyWOQnWTJU6TcOrS5mlG6HymqRopowpzh3Wbq6amoYlsfixqUxqSBllrph71FMNidxkoc2WtrsQvKtjbf/7kw0Ph9UW/mI9IWga18FdVpJ7x5kVJLF+FpNZAdw5Hu0UPHrrGiwzIt/SY85RK5L3dVu6EOsjJZJmK5G04BMIBjeLuVcTTPtBfThpbBZ4cA8Yx40=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(376002)(396003)(366004)(39860400002)(8676002)(66556008)(54906003)(66476007)(316002)(66946007)(4326008)(5660300002)(2906002)(8936002)(38100700002)(7416002)(86362001)(31696002)(36756003)(41300700001)(6506007)(6512007)(6666004)(53546011)(6486002)(83380400001)(478600001)(186003)(2616005)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZDFTTzJhazd4a2lKeEdEblNaWGhhSVo5WEFxNWE4WG8yRi82T0JmV3NjRk92?=
 =?utf-8?B?S1dDSE92RVNrV2w1YXpRUGhBcHpYUklNKy9JNGRlbW53WXdZOU9jR1BIeW1C?=
 =?utf-8?B?cnhQUW1laUJnTjg1RU80UUdmei9MalRPQkhTcnRTYWJrcTNvYXdFd1BCYlJp?=
 =?utf-8?B?cHczRjk1YnE5RWhoejh2S01xbHdDaTEwSW02cTdEczNyV0JLVkNOb2FFRG1I?=
 =?utf-8?B?dUk3d3NWd0k0cmplNVFKTzBIbFFWa0NYdlJ5RE1GQ2MrYTFJd3pQRXRsRTU3?=
 =?utf-8?B?dTZlcmNIOFBSczl6N0tjOGlXNjExbUdocXJjbGtsOGlhY3owRCtKajhsYldj?=
 =?utf-8?B?ZkVQSUZOanQ1VzBKSVRVWER2T3ZOTXRlQW5DcGEzMmd0bzNsSXJoa0ZMdlNq?=
 =?utf-8?B?eU04aEptTnlleUpIUzhQMnFYTnJXbmVJNDJpUGZSOGhBRUpiTnhNWXYyWUpY?=
 =?utf-8?B?ME9Xa1NuVFh3NSszSFA0SnlZbzVtZCtacE51UTZiTU56c0F0MVhDZXM2WklE?=
 =?utf-8?B?SitZZ2JjcFBMa3RQYlVUZXYwcm5yUlBNUWhKUk9FT1BCVjhDc1VWd0ZQUUR1?=
 =?utf-8?B?Zk1vWjBhUFlEWFdxMSsvVU5Od29yYm5xdzVkU2pyKzRJNEtzRTJVdDZaL0Ja?=
 =?utf-8?B?OTJQbmM4bTdXZ3JqZGJXdnRPSnZWdWpRVWlwTXpZZVBjNFRkcXVGT1R2clpy?=
 =?utf-8?B?NDh4Q1F6NkZwc1g3TDR5S2l0ejV4emgxanZJYTQ5VXZQMlp0WlBDUTl2Q092?=
 =?utf-8?B?VlBKWnNha3Axajg5VFJWUUc5Vmpadmpia2JoWHhqaXBZUmc4cGtBNUlaZThG?=
 =?utf-8?B?N2VYY050TjdkV3I2amxxK25NNHplMGhWUG9IbEthVkxoNWdPcVc5dmtzN3Vm?=
 =?utf-8?B?eW1UVUUzRUpEb0huUld3Snc4V2ZWM2FySWpjekxmZnZpNVhuYzRRdW5Hamx3?=
 =?utf-8?B?eE9zMHR3RlVURnArVDcrM3ZsSzNGQnJuY1pSMGFNaWxOd201UUFBZmpFYVUx?=
 =?utf-8?B?WGpTUWRyM3FWanZvT01oc09uODV5UWMzdnR5bEJXT0RLSEJUdjJISUduWDRO?=
 =?utf-8?B?b1p5TFh6K0prVWx0QkJVbFlQbzRtTmprTjl0RURIbnozVnNvNWlDdHlXUFk3?=
 =?utf-8?B?eHdpK3BVdmZuSDBlUnN4azluSG0vZnh2L1BrYVBDbFFCMjlBUnlSN1p1NkZR?=
 =?utf-8?B?Rlk2Wk1nZERwMjluVGovQndrZ2tyQW5uTXQrK0JlRFFwM2VOZDJualBDNHNE?=
 =?utf-8?B?M2pNdm0wVDR5YVBCKzdycWVQcHRIODJrZFZCemcxdVByRVc0ZGl0MlhSdFFS?=
 =?utf-8?B?eXRmK1h1OE54cTYwVzBEOFhVenBGbWVNUXJvdkNjbkF4R2luT1RaSmw2cUV4?=
 =?utf-8?B?SXhwa0crcElUanJVamdFcEdoelRmaHA1R0VWVXp0KzdzaFU1YUpoaHZKbTRS?=
 =?utf-8?B?bnZtUWJhYURoUzZWdUE0MnpHaE1QUGwvWEhmWmxEYnpYUHgrRnQ1U1VaT2F3?=
 =?utf-8?B?YXZxak9ScVVhaXFpaWx6QWtqVlpuZnF0MzV5Q0FqbkM3VS84aVJjQWxKMjZh?=
 =?utf-8?B?OS9oems3dktVdEU3d1owUHNiZjdBM1RMNTdiK3lGYnQxeFZsdTZiVHNuOEpH?=
 =?utf-8?B?b2xsYVA0aXI0N1RuVmgyK1BJT2kwaUtKdW1DL3BmZ1BkWE5VVWcrREZGTm93?=
 =?utf-8?B?bXlEL3d3RS9uN0NqaEp4WEJIeWlLTFJ3RnJ0MS9CSzY2c3ludjZLaWZFUklz?=
 =?utf-8?B?bXI5SDJ2WnFHQzJpNUIwK05zRmRUaFBqNFQrOFl5UzZmVmo4di9CeUZDcmQ4?=
 =?utf-8?B?SXBKbDNuVkN5bVA5dElSbkdmMDdYTVFBTi81cFYrSm8yQkhkTE5nbDA5M0VL?=
 =?utf-8?B?NjQ5UkZ2eTRDZXBKMmJiUW1MbnRTNmk2Q3ZSV1UrV1d4MFJSS0Q3WVJmNlg3?=
 =?utf-8?B?VHVtWGpqbTNyV243cUNyd0d3d0R2TzYrMk5KQzBEajk3alIrQXp1d2E2Q1hn?=
 =?utf-8?B?ZUNuTzRSZW5kam1EVnBRMjNWaUNFZW44dkg1SU5lUkYzdTI2SU9qcFMrOVpM?=
 =?utf-8?B?VkgxSHpoeUIvTmNCbGNQRitXSS9xM3Fqbzd1Mk43YjNUVDkxQUtKa0hVQ1N0?=
 =?utf-8?Q?qraMIc004bOK/t4yfH7W44Vk2?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f640b99e-39f4-48cb-617e-08da86ed9567
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 23:00:20.0797
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aF3f2Y/FQOwPICdY69bClZw23XN0/JLqKnEkHYGdd7uNr+WqhGSICF2D5axICYDi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3626
X-Proofpoint-GUID: qNexuc1tWSQBrRD039aEUCsRZ9j-aNbY
X-Proofpoint-ORIG-GUID: qNexuc1tWSQBrRD039aEUCsRZ9j-aNbY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-25_10,2022-08-25_01,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/24/22 4:31 PM, Hao Luo wrote:
> Cgroup_iter is a type of bpf_iter. It walks over cgroups in four modes:
> 
>   - walking a cgroup's descendants in pre-order.
>   - walking a cgroup's descendants in post-order.
>   - walking a cgroup's ancestors.
>   - process only the given cgroup.
> 
> When attaching cgroup_iter, one can set a cgroup to the iter_link
> created from attaching. This cgroup is passed as a file descriptor
> or cgroup id and serves as the starting point of the walk. If no
> cgroup is specified, the starting point will be the root cgroup v2.
> 
> For walking descendants, one can specify the order: either pre-order or
> post-order. For walking ancestors, the walk starts at the specified
> cgroup and ends at the root.
> 
> One can also terminate the walk early by returning 1 from the iter
> program.
> 
> Note that because walking cgroup hierarchy holds cgroup_mutex, the iter
> program is called with cgroup_mutex held.
> 
> Currently only one session is supported, which means, depending on the
> volume of data bpf program intends to send to user space, the number
> of cgroups that can be walked is limited. For example, given the current
> buffer size is 8 * PAGE_SIZE, if the program sends 64B data for each
> cgroup, assuming PAGE_SIZE is 4kb, the total number of cgroups that can
> be walked is 512. This is a limitation of cgroup_iter. If the output
> data is larger than the kernel buffer size, after all data in the
> kernel buffer is consumed by user space, the subsequent read() syscall
> will signal EOPNOTSUPP. In order to work around, the user may have to
> update their program to reduce the volume of data sent to output. For
> example, skip some uninteresting cgroups. In future, we may extend
> bpf_iter flags to allow customizing buffer size.
> 
> Acked-by: Yonghong Song <yhs@fb.com>
> Acked-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Hao Luo <haoluo@google.com>
> ---
>   include/linux/bpf.h                           |   8 +
>   include/uapi/linux/bpf.h                      |  30 ++
>   kernel/bpf/Makefile                           |   3 +
>   kernel/bpf/cgroup_iter.c                      | 284 ++++++++++++++++++
>   tools/include/uapi/linux/bpf.h                |  30 ++
>   .../selftests/bpf/prog_tests/btf_dump.c       |   4 +-
>   6 files changed, 357 insertions(+), 2 deletions(-)
>   create mode 100644 kernel/bpf/cgroup_iter.c
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 99fc7a64564f..9c1674973e03 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -48,6 +48,7 @@ struct mem_cgroup;
>   struct module;
>   struct bpf_func_state;
>   struct ftrace_ops;
> +struct cgroup;
>   
>   extern struct idr btf_idr;
>   extern spinlock_t btf_idr_lock;
> @@ -1730,7 +1731,14 @@ int bpf_obj_get_user(const char __user *pathname, int flags);
>   	int __init bpf_iter_ ## target(args) { return 0; }
>   
>   struct bpf_iter_aux_info {
> +	/* for map_elem iter */
>   	struct bpf_map *map;
> +
> +	/* for cgroup iter */
> +	struct {
> +		struct cgroup *start; /* starting cgroup */
> +		enum bpf_cgroup_iter_order order;
> +	} cgroup;
>   };
>   
>   typedef int (*bpf_iter_attach_target_t)(struct bpf_prog *prog,
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 644600dbb114..0f61f09f467a 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -87,10 +87,29 @@ struct bpf_cgroup_storage_key {
>   	__u32	attach_type;		/* program attach type (enum bpf_attach_type) */
>   };
>   
> +enum bpf_cgroup_iter_order {
> +	BPF_ITER_ORDER_UNSPEC = 0,
> +	BPF_ITER_SELF_ONLY,		/* process only a single object. */
> +	BPF_ITER_DESCENDANTS_PRE,	/* walk descendants in pre-order. */
> +	BPF_ITER_DESCENDANTS_POST,	/* walk descendants in post-order. */
> +	BPF_ITER_ANCESTORS_UP,		/* walk ancestors upward. */
> +};
> +
>   union bpf_iter_link_info {
>   	struct {
>   		__u32	map_fd;
>   	} map;
> +	struct {
> +		enum bpf_cgroup_iter_order order;
> +
> +		/* At most one of cgroup_fd and cgroup_id can be non-zero. If
> +		 * both are zero, the walk starts from the default cgroup v2
> +		 * root. For walking v1 hierarchy, one should always explicitly
> +		 * specify cgroup_fd.
> +		 */
> +		__u32	cgroup_fd;
> +		__u64	cgroup_id;
> +	} cgroup;
>   };
>   
>   /* BPF syscall commands, see bpf(2) man-page for more details. */
> @@ -6176,11 +6195,22 @@ struct bpf_link_info {
>   		struct {
>   			__aligned_u64 target_name; /* in/out: target_name buffer ptr */
>   			__u32 target_name_len;	   /* in/out: target_name buffer len */
> +
> +			/* If the iter specific field is 32 bits, it can be put
> +			 * in the first or second union. Otherwise it should be
> +			 * put in the second union.
> +			 */
>   			union {
>   				struct {
>   					__u32 map_id;
>   				} map;
>   			};
> +			union {
> +				struct {
> +					__u64 cgroup_id;
> +					__u32 order;
> +				} cgroup;
> +			};
>   		} iter;
>   		struct  {
>   			__u32 netns_ino;

Hao, we missed the bpftool dump part for the above bpf_link_info so
a followup is needed.
Please take a look at tools/bpf/bpftool/link.c searching 'map_id'
for an example.
