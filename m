Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A862455E0EF
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232075AbiF1EOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 00:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbiF1EOl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 00:14:41 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0B3827FD9;
        Mon, 27 Jun 2022 21:14:40 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25RJ1R1I004975;
        Mon, 27 Jun 2022 21:14:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=VoaGov6hKjpcuuyFinFnNspQtMbN34D3FaR0W1CPW7c=;
 b=YEPesEry/ll09FQiLJN1Da8Pwg7kuWBA6Jdc675jfhCAWiZ+UqqGTSN9n422clgSyM9K
 hq9HZZMqXddjA0Z6Tq/PxlYLqb1qd7ODORWTgBgFOypcZ8APEBYxXLwU3EsM2UyGP8Sx
 suEZpRgnFS+cFXLRGncsuw+Q1Apvs2sZqJk= 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gx03yy6ds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 21:14:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nUxxDzkr6OfXEc3coIV0nm64Cus73q/zFZTw9Jtjm2qTn752CSp4RnsPX4x7+96+F/ZUH5BykB0xIeKq4d5mQRyGCbfCyUtlZSnDN2F6DqGqdyqi7yeOn/tnOh865k5XK0Btb8/wO3cINftzWp916lCCnHmFPwdz8xaZNoU46fwZAApWYD5chNc9As2jsf4o583T02C8IWbSoWkBw8UA7rZjsKbhhZlCV+XEXEaDeqSNLA4Eq/kXp0HtmdJnlpzVjf/klCdD/Q25hoK7Vn/vtu/obpUUPfIs8J+poiQyHDJJZXb5peORKqaEiibLTl1/M5+MU4BVg5NDbcliKihqmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VoaGov6hKjpcuuyFinFnNspQtMbN34D3FaR0W1CPW7c=;
 b=Urxroj/HR4qMjb48dZSsPZXBzN4MdkfVGsIh8mVG9G4FXFyYYltYF3vr8EXL2xojVOrecVHnzygmk1952TYn5VJzWHx99XeJLWRfVymdGAGF0HhVKFFxxtZxP8YP2COQrWFli4lCtt6BJynPSZUK60I9RNo4uDsCFH8WJWxoc63TnUyGXKfY3DUcZ2vjm0q77y3wX6rW30TbFeNf+iH6G7zDg+ZY0I4ieGDcxN1vmFshqbqjMu4DRqUBQFxwb8cB9vb6aWq97K6AZNVmLD++G/WWrkr7VVfxhmaKErAbBddphvAsJHCtmBFsmfowQYqXAIJf5nWLI6dSiG5/sDQLOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BN7PR15MB2195.namprd15.prod.outlook.com (2603:10b6:406:88::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 04:14:21 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23%6]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 04:14:21 +0000
Message-ID: <40114462-d5e2-ab07-7af9-5e60180027f9@fb.com>
Date:   Mon, 27 Jun 2022 21:14:18 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [PATCH bpf-next v2 4/8] bpf: Introduce cgroup iter
Content-Language: en-US
To:     Yosry Ahmed <yosryahmed@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>, Michal Hocko <mhocko@kernel.org>
Cc:     Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, cgroups@vger.kernel.org
References: <20220610194435.2268290-1-yosryahmed@google.com>
 <20220610194435.2268290-5-yosryahmed@google.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220610194435.2268290-5-yosryahmed@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0064.namprd11.prod.outlook.com
 (2603:10b6:a03:80::41) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 83ff6cb3-e32f-4ed7-3434-08da58bcad85
X-MS-TrafficTypeDiagnostic: BN7PR15MB2195:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Fa3wa9/4MGKkTCXDvUTcyEjKz68JiYLbTV7IC14hhu60Xt+301xt2KwTsopfBDq+PAWKcw16D7fDfQdOJ8nQPBU5KB75fEmeoDJy5ZkSEzzDT5p7/iJ7+W0alqLv4OBaJJmsQ9U27N2bbABq7ecj0HaSP/QZK+FIqSnDiDH03mmuv//7Nvw96zw9e3U+PuhMLgYDT7gKuD8zsAuvt44xzSrBkyI7JbyqqdoNGHET3rgQV16KzrNSZdpSBFivwDF4IHZWt7E81UNtxxTZ084wijBzk2ZBpdJRhrfCDuuy928weeWVRuacC3YokIV7Yfbbvo2bja8gxBBlCqZYJAioHlaZjPJfZfnlFUNRanhH2NAUFRwkxG887CnqDWltbIv0b9CUO6ANfyICSKfSRVUTNI/9rnl0nRHMPaNMnI54L2P64NNF8JuBiU6IG3OsNAVpuR/wbcy/e0XquzEBiGXYXLjbjaK98CdQTSrI4pkFEeqFcpLNjKyoZhAW4MIfS/hJn4gRLesUvzdpJ9e3zwJy2dXlGfaSb7LBX3lSf3lc13ZFsNklo6JnbAxiiPqCZTQ1hNEvURWwEmdxOcxRN12x1taSLaijnxj/C1cNwgUg/iwcPzQVJJT5i3WNhG/HXyajmssoh+d+O/MPh/BbDbxk4Kzoy2BLD0oYG6x1FoDiRmLYk8lV1MtNCbXZVE7adA0sH2z67eJnoH+1+1cbc6D5yylrC1J3QJIn3RvH/lBCiVmTzc+LCwgUp+kuQExg63dih2jCSVMYe3VcWEbrq7BiK8dJ0/kpvDeMr1glAvcLd2ISs8E2cICatJ9GceRgt+xNWRgGTOlf6W844fq0CeTz+Xm8sBrnmUHKKJYpPODs1yQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(346002)(366004)(396003)(39860400002)(31696002)(110136005)(6512007)(5660300002)(54906003)(83380400001)(53546011)(921005)(7416002)(186003)(38100700002)(2906002)(316002)(6666004)(31686004)(36756003)(6486002)(66476007)(66556008)(478600001)(41300700001)(4326008)(6506007)(8676002)(8936002)(86362001)(66946007)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L0U1TXliRGJiVkFkS29TaE5YY3pmS1Bya0tYU2M2VlJSVTJVMnhZNHdpNDht?=
 =?utf-8?B?dVFXa2t5cmM3U25WVGx4VVVDZHdFYkJQMVlIcVRBYVdEQVlDR3NiMVdWWWcy?=
 =?utf-8?B?QzZkZzVzWUV6Zi9wQ0lHZ2laWWhNakpkbFlxT28yNlVlQ3NFMDd2bGpOZi9N?=
 =?utf-8?B?bldoZjFtTEpFaWVBODZMREEzMFNneS83QjZpTzVQaUtscEVVem5QRkxTT2ph?=
 =?utf-8?B?ZmVScFpTNXRYWXdFUXNhVWlvbkhRMCsxMEpSWmZlTTlGMm1EN3p2TzhWbDJu?=
 =?utf-8?B?TzhNNE1iRVZZRzg4OVRzUkhRcVcxWVVJSFQwRnQ1aDZHL0FxVFlhb0NrSExu?=
 =?utf-8?B?cmVpM3BNUXM1eWZUUFhrcnR2a250SVVtQlpid2swQ2lxWjVwenhQaWR5d3l1?=
 =?utf-8?B?b1ZvS2wyR1YxVTdBMkNWNUdveXU2M2pCSVF1Z0VuVjJtSHJNeGl0d2dYZXpl?=
 =?utf-8?B?T3VwV2VnVE41TkptaGxLbW81VVRZaDkvWkJYd0NwMDh0VVJRN0xJSjBHSTRa?=
 =?utf-8?B?TVloMGo3OGJtNFRDTVRJaUxpcThIVGpaN3p5ZkpqSWdRWHo2ei9LZ1R6eFZG?=
 =?utf-8?B?N3FFb01OVU1jWWJRMGJaZExLOWtYWXdZMXFicU9xcXpqc3FwK0RWUWFLNlkz?=
 =?utf-8?B?Q1ZPcmZTd1J3a0lNVXA2S2Jzb1JjQ1Q2WWNTRjZWL3JvWnUvUVhLbXlWTWRQ?=
 =?utf-8?B?WE1udFZhT2FDRmVSempWVnRuUHlWSjhZcUhNaW5PMXNKSTFFNStYb2xFNXhh?=
 =?utf-8?B?V2tsMU9PdVZMZCtaMUVqYXBRd3RPMy82WExTSVZFMTBPVmtROUExV3ZqTDFM?=
 =?utf-8?B?SzNDaUo2SVlPUWNOSkZFL1R3UzUrUG5CU2JuUG9XK1ZMQ3hQcEpJZUQyQkU0?=
 =?utf-8?B?Szltb2l0TXpoWHV3c3RTZVByRXlOeW5vZTduRDAxL1lNUXhweEkxbUFYVFhq?=
 =?utf-8?B?M29UUGs1YUg1Z2toQzdSMjg0L044NXZyNHFiWE5DQkhDWk9ObE0yRzErcnkr?=
 =?utf-8?B?aG8xWDgwenRkUWdhejhDWHVFaXhhRzIrcDhya3J1WlMrb09nY0ZZWU9FTzM4?=
 =?utf-8?B?OGZnZFowd1NUSWpxM2hmSmZhYWduWG5kRHZWVTBPYTRQQU5tYmNiRDNySjV3?=
 =?utf-8?B?bWpML2hzYW5BeHFCV2hQdi9DQ2N0cTZsOW5nOVhkYm5aRGQ4NkNEblc2bnpz?=
 =?utf-8?B?OGFMbHIwY2ZEWHRrVERsZ08wTjRmd0FLMHBXT1ZOcWhyd3E3T2xLR1dWUTc0?=
 =?utf-8?B?MzRuMkZJQU1MdjZPTy9CbUlYUkdvNzEzWUthT3N2WjhHUGtMQStnVFpnL2Iy?=
 =?utf-8?B?L2UvTnNvcXdDcWNhVzBmbEhaUUk4ZUdGUVZiOHFxQzhGOE9neGdvKy9pdmg3?=
 =?utf-8?B?U3Z3SWtLWGd2THhWV1VhY3hxMGJMSXZMeXFCT2tYUEsyMEFlcHA3eU1qWjk0?=
 =?utf-8?B?UEcwTDdtV3M5RkZlRk8zN0pSbSs1RUd4SkhjSnFXK2paOG9uazQ4YUxXWlMr?=
 =?utf-8?B?d0kwTVpGTERDdkJjd1MzZnEwd3kxa1REaG11dXhwR3lOY1l5Mk9XODMyQmVJ?=
 =?utf-8?B?c0NDeHRIOWJPeWh3Y1RNdUtHQzlHZWN6UDhZV0p4a3RmYWVtY0locnIvNU1X?=
 =?utf-8?B?RWVSZm5UM1dyRWRwR1RuUktJYnNLR0paRWdaVzZId0JsREErRVJMMXRoaDI1?=
 =?utf-8?B?ZTJzNnVNNkh2NnE5c09RQ1psSlFRMkZadGNDMXptKytMMUgvU3lZdFpESUhR?=
 =?utf-8?B?a3NNZkFRWGVqUERWOFJ3TGhOWTI2d29BTXdvM1RpakJzRUZvSm83c09DVzV5?=
 =?utf-8?B?QllQRTk5cVVLT1JJY00rNlVPZlZ1dVR1MU5jWFoyUkhBQ2VBUkw3MEprNE0v?=
 =?utf-8?B?TSswUHQwTUVrek1VdmpMaWdBZURrcVphanlOVnI1RGZoZkdKTGNWb01YRXd1?=
 =?utf-8?B?WTNHSVVIa2poRzhNdzVqS2JYTVFLcElQTFhYb2l4UTg5QklVRE9HbHFKd1ha?=
 =?utf-8?B?eGRPOHp2ZjNnNFJJUkRGVG5JUnJsTytkb0RUOGZQajQwdUgvVnFDYnNqdnIr?=
 =?utf-8?B?bGNNckdId3hPeC85b1BlekQ3Z0N5L2RIZE0yN1MvMERLandhKzVJWFAyZFRi?=
 =?utf-8?B?OFFJbkxoa3JXOC8wZElENHdZTnFtWjluRUdoeFkrd1VyU3p5ckpacFpvdU5U?=
 =?utf-8?B?Nnc9PQ==?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83ff6cb3-e32f-4ed7-3434-08da58bcad85
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 04:14:21.5880
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iWUwBjhCnte4mQ17akhWuJfDYRuUccZGNcVB9ofBoGyXtDonQk51mJ5mimhbu5uD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR15MB2195
X-Proofpoint-GUID: FTqIqcpyJQzdWsCdJV-UaZ2exnxm-WZZ
X-Proofpoint-ORIG-GUID: FTqIqcpyJQzdWsCdJV-UaZ2exnxm-WZZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-27_09,2022-06-24_01,2022-06-22_01
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/10/22 12:44 PM, Yosry Ahmed wrote:
> From: Hao Luo <haoluo@google.com>
> 
> Cgroup_iter is a type of bpf_iter. It walks over cgroups in two modes:
> 
>   - walking a cgroup's descendants.
>   - walking a cgroup's ancestors.
> 
> When attaching cgroup_iter, one can set a cgroup to the iter_link
> created from attaching. This cgroup is passed as a file descriptor and
> serves as the starting point of the walk. If no cgroup is specified,
> the starting point will be the root cgroup.
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
> Signed-off-by: Hao Luo <haoluo@google.com>
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> ---
>   include/linux/bpf.h            |   8 ++
>   include/uapi/linux/bpf.h       |  21 +++
>   kernel/bpf/Makefile            |   2 +-
>   kernel/bpf/cgroup_iter.c       | 235 +++++++++++++++++++++++++++++++++
>   tools/include/uapi/linux/bpf.h |  21 +++
>   5 files changed, 286 insertions(+), 1 deletion(-)
>   create mode 100644 kernel/bpf/cgroup_iter.c
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 8e6092d0ea956..48d8e836b9748 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -44,6 +44,7 @@ struct kobject;
>   struct mem_cgroup;
>   struct module;
>   struct bpf_func_state;
> +struct cgroup;
>   
>   extern struct idr btf_idr;
>   extern spinlock_t btf_idr_lock;
> @@ -1590,7 +1591,14 @@ int bpf_obj_get_user(const char __user *pathname, int flags);
>   	int __init bpf_iter_ ## target(args) { return 0; }
>   
>   struct bpf_iter_aux_info {
> +	/* for map_elem iter */
>   	struct bpf_map *map;
> +
> +	/* for cgroup iter */
> +	struct {
> +		struct cgroup *start; /* starting cgroup */
> +		int order;
> +	} cgroup;
>   };
>   
[...]
> +
> +static void *cgroup_iter_seq_start(struct seq_file *seq, loff_t *pos)
> +{
> +	struct cgroup_iter_priv *p = seq->private;
> +
> +	mutex_lock(&cgroup_mutex);
> +
> +	/* support only one session */
> +	if (*pos > 0)
> +		return NULL;
> +
> +	++*pos;
> +	p->terminate = false;
> +	if (p->order == BPF_ITER_CGROUP_PRE)
> +		return css_next_descendant_pre(NULL, p->start_css);
> +	else if (p->order == BPF_ITER_CGROUP_POST)
> +		return css_next_descendant_post(NULL, p->start_css);
> +	else /* BPF_ITER_CGROUP_PARENT_UP */
> +		return p->start_css;
> +}
> +
> +static int __cgroup_iter_seq_show(struct seq_file *seq,
> +				  struct cgroup_subsys_state *css, int in_stop);
> +
> +static void cgroup_iter_seq_stop(struct seq_file *seq, void *v)
> +{
> +	/* pass NULL to the prog for post-processing */
> +	if (!v)
> +		__cgroup_iter_seq_show(seq, NULL, true);
> +	mutex_unlock(&cgroup_mutex);
> +}
> +
> +static void *cgroup_iter_seq_next(struct seq_file *seq, void *v, loff_t *pos)
> +{
> +	struct cgroup_subsys_state *curr = (struct cgroup_subsys_state *)v;
> +	struct cgroup_iter_priv *p = seq->private;
> +
> +	++*pos;
> +	if (p->terminate)
> +		return NULL;
> +
> +	if (p->order == BPF_ITER_CGROUP_PRE)
> +		return css_next_descendant_pre(curr, p->start_css);
> +	else if (p->order == BPF_ITER_CGROUP_POST)
> +		return css_next_descendant_post(curr, p->start_css);
> +	else
> +		return curr->parent;
> +}
> +
> +static int __cgroup_iter_seq_show(struct seq_file *seq,
> +				  struct cgroup_subsys_state *css, int in_stop)
> +{
> +	struct cgroup_iter_priv *p = seq->private;
> +	struct bpf_iter__cgroup ctx;
> +	struct bpf_iter_meta meta;
> +	struct bpf_prog *prog;
> +	int ret = 0;
> +
> +	/* cgroup is dead, skip this element */
> +	if (css && cgroup_is_dead(css->cgroup))
> +		return 0;
> +
> +	ctx.meta = &meta;
> +	ctx.cgroup = css ? css->cgroup : NULL;
> +	meta.seq = seq;
> +	prog = bpf_iter_get_info(&meta, in_stop);
> +	if (prog)
> +		ret = bpf_iter_run_prog(prog, &ctx);

Do we need to do anything special to ensure bpf program gets
up-to-date stat from ctx.cgroup?

> +
> +	/* if prog returns > 0, terminate after this element. */
> +	if (ret != 0)
> +		p->terminate = true;
> +
> +	return 0;
> +}
> +
[...]
