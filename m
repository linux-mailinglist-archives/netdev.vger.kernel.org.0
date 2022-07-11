Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4E456D221
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 02:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiGKATn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 20:19:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiGKATl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 20:19:41 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D56681409B;
        Sun, 10 Jul 2022 17:19:40 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26AMff1A029464;
        Sun, 10 Jul 2022 17:19:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=j1XbpZ2NXx0trmsHga7A+Re2q/7pxdhGga75Sk5iUJ4=;
 b=qiYkp7JNfsGGk/+ctFrzIqEIg5Psg/krCCYLAvRlpQ4IMHTH6GasZ/wE3x29bYYH/Y9Z
 Nra0jerS/8qQq0XNp+TGmDA8TtC6N/rZfRSWUlHhxiK0P2v7mcdJdhhvW5fdOql0bEUQ
 /c33i24pOvpzphg7/dpAIrkS1J6cz4bshhg= 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h75qmxe1j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 10 Jul 2022 17:19:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iczXDrMOrWW7yZlBzF8+xwjf/YzeWpCVr4xSXOCThcNVdxTpYUIuaRjDpiEd1RvWIk4Y/jfIi/oYwZw1l4/5Dj6yCocC5exxE6K67ZHXPJVlLH7lTRjJkuM4N6z6vuzcEAjgBL36h1oQJP2kt0tH81VK3pJ3etyfkNUwinEIiaqu8sStXI0K5trZjVJX7eO3zelwmzCboxs/7z7Tamzv3mMaE/Wcz0weVZM2z0kEcU2yayGR2orh2AkRcZmfl2Hk2Tjzy/Y7+GNzKZebQjSBW9nl/ZTzmA7Jb4uhy3DiYUwLKokFbt7ySNy6V6vkibHtI3Vcar42gSqmsjHYnLxt7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j1XbpZ2NXx0trmsHga7A+Re2q/7pxdhGga75Sk5iUJ4=;
 b=g9FFg2TYOXJ5agsoTXlJ8rxV1H+0hsKgQvnXJKjrOobrS1eSnZ1xiPZbhEbXRjskP91IMkDOePxqzOT6lQDxKCsGS+N5/HGVvPCxuohYp7R6o9i2CeGHCEofoKJBPE+fLDn4HIMC/uqSAxQWN3IXRk/wMOl6ji68Z9X3Y0cpRKpaPU7TmgPjPG4I0CzVJOiO6OlD/YwwOqoFdQE3yZBa7jVSgQmYKZ/4T9w9N91fjE2YLeHQEaJbNqfoDCMz/erarKFhV4UqjOO8xZlp6VRE6HHJXhc5dy/p5R4GPXanefO2qPEPkSeSsrBg+DczTuimdYf6rApzB3YQ1m1x99zv9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BN6PR15MB1537.namprd15.prod.outlook.com (2603:10b6:404:c8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Mon, 11 Jul
 2022 00:19:11 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23%6]) with mapi id 15.20.5417.026; Mon, 11 Jul 2022
 00:19:11 +0000
Message-ID: <370cb480-a427-4d93-37d9-3c6acd73b967@fb.com>
Date:   Sun, 10 Jul 2022 17:19:08 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH bpf-next v3 4/8] bpf: Introduce cgroup iter
Content-Language: en-US
To:     Yosry Ahmed <yosryahmed@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Hao Luo <haoluo@google.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        KP Singh <kpsingh@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, cgroups@vger.kernel.org
References: <20220709000439.243271-1-yosryahmed@google.com>
 <20220709000439.243271-5-yosryahmed@google.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220709000439.243271-5-yosryahmed@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0130.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::15) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 36fe818b-776e-4c3f-bedd-08da62d2faa0
X-MS-TrafficTypeDiagnostic: BN6PR15MB1537:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8IhndmTecuiikX1adoaEy1K41Fv3hNZW9ivhcMSh1GbwSS/y8H+yFHeQb9DcHIwIEG+JsVkrFBlwFeOAY5qt/gcTAV4UCRHXrP4EaqWJ6epFEkV8rKxQO/XtiikRJgosg+wQU3FrmdjE4Jsl/PHhvCPLmAYxslZ3Hrwy+DizoYFOVxdjW6aUiJ5+1OkAadBAM9R+rGXcawG8fGmOPkEwCipecogWyul/nkKKTdssJE/x9HrtIGNfpRUOuPAejC0hllTSXKOq1nOoyrtwG//3We3IwIw/MS/FFoOv/thW6xt7q33v0OwCSkTH+fY4paUqTS1H7xsvcYKoSFnBxBrtXAw/bNdqxd6ehLqY/yoiQjY87ajaC1jREwsoILV2yecGQ68yG/zBj4UxXh4fD2Ru+dJdQDe9Yocd99FDeODGP+rCk72Hr5aMencIUo72OjCwNwk5MhWKyWpRbjFV/1iAN1Um+kg6q+iBF3uUxkrNscEdq+dhR4jTZvFgRsDYXtSOdSL2R4HjKpQmY9Lvi0Te5YOkYYjwEaHmdHMGa0UYLcyC9VdotznwOikQzPKc5ljEk9y8ucWvVYxbtUB5nWLh/VuPuFOX2qN3vOb1A5pJwSe7a5o42RWakaBkj6g+NkRCnA8dX+y/sskf9XppmAEtF3O9PGQ0Z2bUMCYdnL4p41mslNoVdE+zGwgArODBkzfmPukeJy1LEBD5EeXyH/FmA2KAaZ50gIKi6gmfd/TlcMtrhgGvXWwKVe3TT29TnSZ24bcLiK2k3mTvCgqFBqQLloZIfcUH6VrXd3Whuvm2FvW86y46Btx1ys790TlFulLbLRqSr0qx2JQ3OTuq4LWRjamhbXs0iJ8IpJrWgReXbMA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(136003)(376002)(39860400002)(346002)(396003)(478600001)(83380400001)(54906003)(6486002)(86362001)(31696002)(6506007)(2616005)(38100700002)(41300700001)(53546011)(6666004)(6512007)(8676002)(4326008)(66556008)(66476007)(66946007)(31686004)(7416002)(5660300002)(8936002)(36756003)(316002)(2906002)(110136005)(186003)(21314003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ckVXZ2pKRkZ6ZGlScWVvRFgyMlFOSDFOdkYrR3pPbHBUUFRRcWFoS25OTzl0?=
 =?utf-8?B?d3kvc0hhTkFBbmlrT29wNGMvNTAvNEMyTVBTVWN5WDgzQ0NLZE9yeUt4czJK?=
 =?utf-8?B?NVNwUnRMTGtEOHRpakR3UWs4VzI2L21hRFh5ZWdyQllNSXV3dURpTDlyVW1z?=
 =?utf-8?B?RW5vYUdIdG9hTEVwWTRFUnkwVzdnN1Q4Tk9FTTVUZTVjYlJIbVI0RDVscUtJ?=
 =?utf-8?B?T2dMdkMyTmFqOHNDemNMaUF4ditXVXVOMmV5dWpmVmg4cjYvbk8wWXovVkJk?=
 =?utf-8?B?c2NVZUJmeVJyUEJSeWZNZGdXcVZVaXE0U0ZzM0hWeU9Vd3k3QTZpUi9Rdkth?=
 =?utf-8?B?b0NUcTZtbzlna3VaQnhCazg0anpEVk43ZllSNjI0OC9jNG9WMEM1VjY3TXd6?=
 =?utf-8?B?RXNtZE0vUEF2NFFCM2RDNUdFUzJia0VONlljVWFtM1MzM0h2VXJrNTkyU2pQ?=
 =?utf-8?B?ejV6VTY3azR4eXVxRlkrakZMSEZtc2xESm0vZlNpMFRnQkEvMUQ0aUFmOWl6?=
 =?utf-8?B?OHZ0Z05EY00xRG9qcnZOZ1VOeUlqTWtvUURHanV4dzAwZkJLSnoyekxibktY?=
 =?utf-8?B?WU1YZ21vek5wWkFsYW1LZ2x2NEdGT0xvbFpEUUx3ZlhPc0VxSFJNdkRQczlm?=
 =?utf-8?B?QzdlM2hOU3IvRFBBMnQ4aHlLd2c4TkVWdGRWMDdEYXd2aEVCU3RaekprRkQ2?=
 =?utf-8?B?VzNTY2IvNk9WeWFjTlF2K1ErNU1YbkQ5aWlzSFBPTVVPTXlXbUdJMVVvSCts?=
 =?utf-8?B?b1dlM2ZQOHZpdFNrMW54MG9SZ1FXajJZT1pTTGxXMENrUm1tQWNhSEVObkNv?=
 =?utf-8?B?a28wTmNOcnljbWp6ZWdBVk1jNG9vMk9LekY0d3ZNcEhYc3hLRWtQZnVoYitI?=
 =?utf-8?B?QXlyaitkRDV3RHlVQlBLUUIvWC9FenRmdWxEQUsydzhiMFAvdzRIUzY1dXN1?=
 =?utf-8?B?WU9JaGh3SjVzSGl6ZWpQRVE0QUN5YzJHME1pTTZlSzI5NXNiMFhkL0FHQzl2?=
 =?utf-8?B?ZElVdUJQZ2JMV2dlZjB6N0Z1MWt6cmlIUUk2L0M1aDliS0pyRjRXV3M2K0sy?=
 =?utf-8?B?QmI5d0RSSTQ4dVJ4anh2dkcyWitkUit6VDhSMWh4YXo2dWxWTnVISHh0WVZV?=
 =?utf-8?B?V1NocWNaY2FzdW0raVhqdzJXay85SnhneGwvdGNpZEtaN2Z3VksrWllSU0lD?=
 =?utf-8?B?ZkZQK2gvd3Ftb1NaRnRkSEdCTzQxRnpBRVZYd25VKzl5ZW1zMFI1WWR3Qmt2?=
 =?utf-8?B?bUEyK2ZyM3o4Q2RSQkRnMFJNTnE1MEEyK2dLOWNkMjVTaTRtTkozRlI3cjZF?=
 =?utf-8?B?L0dlZmw1NndnWE9tMWNnWlFsZWw0dFR2SkZwZWFLYTBXc3pMRGNRUlE2YXJn?=
 =?utf-8?B?aUpSV2p4cUNyZE03OUhqcVJTZHAzQXlBZHI0bXVnMDlXVmpiaFF5aUlsSGdB?=
 =?utf-8?B?Y3Z0dnJaQjUrblpOc0tJK2RVMEpSMm5FSGswNTJ0a25lOGcvaEtVcVN5VTFK?=
 =?utf-8?B?WTN6ejNFUTBKL0NNdWVkQUdSNUtHNUlmSlVsMXhYT2FqbklIckZFbU1hSDhL?=
 =?utf-8?B?eTdCbWkzalN5SGl0RDg0R2pVTU01bXFQbDBTUUhPU2wxVFBZSjRuN1pXV2JQ?=
 =?utf-8?B?ZDhCN0gwUko5ZEo3eG9pcGRONHFPM24wOU1WTHBXRlFYUGxsQTVhZFVHZUNL?=
 =?utf-8?B?LzR4ZXBIemNUYk5uZ2ZReU9UL3E3YlhUNDVGZUFpS0dobjgybEhYVXphMkNQ?=
 =?utf-8?B?NEVqRGlvMGRVUVM3RDFyazNxNm9JWHZDa3Rnb1Z5T0x3UnQ3dVFqbDBIYk5T?=
 =?utf-8?B?d3BRNXRYSlpBMythRVFITmR6VFdzY2ZBdTdIeFZIczE4bndPSU1VbmxLeFdr?=
 =?utf-8?B?S1FpQ0tWY0Uzb2VpcUJrQk95TldCUzZmQThQMzRFSXFGV3dYckpWZ00yU1Qy?=
 =?utf-8?B?eVpHOEl3SWprNm5vMmc4QnltbzQ0WFd5NEQ0U1ovcjdIYVczNW1JNGRDMVlu?=
 =?utf-8?B?N2o5R3RKVytFVHJKVzhQanZ4MTFFTXB6bHRjeW5zSHpwVk4zZW5qUHZVNTRy?=
 =?utf-8?B?UWJQS3FDbWpWOXBwK1Z5MmE0VmRxaGVCbEcyR0RXa2ZIS2tlNUhRMGsrQmlB?=
 =?utf-8?Q?QNdK9WDo+UNqkRPIW7HuKNcrB?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36fe818b-776e-4c3f-bedd-08da62d2faa0
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2022 00:19:11.5401
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uIohV903n82gpad9c++hVWKw5paPkfrTcJP+xJLPztJ8Z7ts2GIHPYFtDaXE9KoI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR15MB1537
X-Proofpoint-GUID: jnNUcfItETXdoQ1cwIfpEMXuzhOG0T7N
X-Proofpoint-ORIG-GUID: jnNUcfItETXdoQ1cwIfpEMXuzhOG0T7N
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-10_18,2022-07-08_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/8/22 5:04 PM, Yosry Ahmed wrote:
> From: Hao Luo <haoluo@google.com>
> 
> Cgroup_iter is a type of bpf_iter. It walks over cgroups in three modes:
> 
>   - walking a cgroup's descendants in pre-order.
>   - walking a cgroup's descendants in post-order.
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
> Acked-by: Yonghong Song <yhs@fb.com>
> ---
>   include/linux/bpf.h                           |   8 +
>   include/uapi/linux/bpf.h                      |  21 ++
>   kernel/bpf/Makefile                           |   3 +
>   kernel/bpf/cgroup_iter.c                      | 242 ++++++++++++++++++
>   tools/include/uapi/linux/bpf.h                |  21 ++
>   .../selftests/bpf/prog_tests/btf_dump.c       |   4 +-
>   6 files changed, 297 insertions(+), 2 deletions(-)
>   create mode 100644 kernel/bpf/cgroup_iter.c
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 2b21f2a3452ff..5de9de06e2551 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -47,6 +47,7 @@ struct kobject;
>   struct mem_cgroup;
>   struct module;
>   struct bpf_func_state;
> +struct cgroup;
>   
>   extern struct idr btf_idr;
>   extern spinlock_t btf_idr_lock;
> @@ -1714,7 +1715,14 @@ int bpf_obj_get_user(const char __user *pathname, int flags);
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
>   typedef int (*bpf_iter_attach_target_t)(struct bpf_prog *prog,
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 379e68fb866fc..6f5979e221927 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -87,10 +87,27 @@ struct bpf_cgroup_storage_key {
>   	__u32	attach_type;		/* program attach type (enum bpf_attach_type) */
>   };
>   
> +enum bpf_iter_cgroup_traversal_order {
> +	BPF_ITER_CGROUP_PRE = 0,	/* pre-order traversal */
> +	BPF_ITER_CGROUP_POST,		/* post-order traversal */
> +	BPF_ITER_CGROUP_PARENT_UP,	/* traversal of ancestors up to the root */
> +};
> +
>   union bpf_iter_link_info {
>   	struct {
>   		__u32	map_fd;
>   	} map;
> +
> +	/* cgroup_iter walks either the live descendants of a cgroup subtree, or the ancestors
> +	 * of a given cgroup.
> +	 */
> +	struct {
> +		/* Cgroup file descriptor. This is root of the subtree if for walking the
> +		 * descendants; this is the starting cgroup if for walking the ancestors.

Adding comment that cgroup_fd 0 means starting from root cgroup?
Also, if I understand correctly, cgroup v1 is also supported here, 
right? If this is the case, for cgroup v1 which root cgroup will be
used for cgroup_fd? It would be good to clarify here too.

> +		 */
> +		__u32	cgroup_fd;
> +		__u32	traversal_order;
> +	} cgroup;
>   };
>   
>   /* BPF syscall commands, see bpf(2) man-page for more details. */
> @@ -6134,6 +6151,10 @@ struct bpf_link_info {
>   				struct {
>   					__u32 map_id;
>   				} map;
> +				struct {
> +					__u32 traversal_order;
> +					__aligned_u64 cgroup_id;
> +				} cgroup;

We actually has a problem here although I don't have a solution yet.

Without this patch, for bpf_link_info structure, the output of pahole,

                 struct { 
 

                         __u64              target_name 
__attribute__((__aligned__(8))); /*     0     8 */ 

                         __u32              target_name_len;      /* 
  8     4 */ 

                         union { 
 

                                 struct { 
 

                                         __u32 map_id;            /* 
12     4 */ 

                                 } map;                           /* 
12     4 */
                         };                                       /* 
12     4 */
                         union {
                                 struct {
                                         __u32      map_id; 
   /*     0     4 */
                                 } map; 
   /*     0     4 */
                         };

                 } iter;

You can see map_id has the offset 12 from the beginning of 'iter' structure.

With this patch,

                 struct {
                         __u64              target_name 
__attribute__((__aligned__(8))); /*     0     8 */
                         __u32              target_name_len;      /* 
  8     4 */

                         /* XXX 4 bytes hole, try to pack */

                         union {
                                 struct {
                                         __u32 map_id;            /* 
16     4 */
                                 } map;                           /* 
16     4 */
                                 struct {
                                         __u32 traversal_order;   /* 
16     4 */

                                         /* XXX 4 bytes hole, try to pack */

                                         __u64 cgroup_id;         /* 
24     8 */
                                 } cgroup;                        /* 
16    16 */
                         };                                       /* 
16    16 */
                         union {
                                 struct {
                                         __u32      map_id; 
   /*     0     4 */
                                 } map; 
   /*     0     4 */
                                 struct {
                                         __u32      traversal_order; 
   /*     0     4 */

                                         /* XXX 4 bytes hole, try to pack */

                                         __u64      cgroup_id; 
   /*     8     8 */
                                 } cgroup; 
   /*     0    16 */
                         };

                 } iter;

There is a 4 byte hole after member 'target_name_len'. So map_id will
have a offset 16 from the start of structure 'iter'.


This will break uapi. We probably won't be able to change the existing
uapi with adding a ':32' after member 'target_name_len'. I don't have
a good solution yet, but any suggestion is welcome.

Also, for '__aligned_u64 cgroup_id', '__u64 cgroup_id' is enough.
'__aligned_u64' mostly used for pointers.


>   			};
>   		} iter;
>   		struct  {
> diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
> index 057ba8e01e70f..00e05b69a4df1 100644
> --- a/kernel/bpf/Makefile
> +++ b/kernel/bpf/Makefile
> @@ -24,6 +24,9 @@ endif
>   ifeq ($(CONFIG_PERF_EVENTS),y)
>   obj-$(CONFIG_BPF_SYSCALL) += stackmap.o
>   endif
> +ifeq ($(CONFIG_CGROUPS),y)
> +obj-$(CONFIG_BPF_SYSCALL) += cgroup_iter.o
> +endif
>   obj-$(CONFIG_CGROUP_BPF) += cgroup.o
>   ifeq ($(CONFIG_INET),y)
>   obj-$(CONFIG_BPF_SYSCALL) += reuseport_array.o
> diff --git a/kernel/bpf/cgroup_iter.c b/kernel/bpf/cgroup_iter.c
> new file mode 100644
> index 0000000000000..8f50b326016e6
> --- /dev/null
> +++ b/kernel/bpf/cgroup_iter.c
> @@ -0,0 +1,242 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright (c) 2022 Google */
> +#include <linux/bpf.h>
> +#include <linux/btf_ids.h>
> +#include <linux/cgroup.h>
> +#include <linux/kernel.h>
> +#include <linux/seq_file.h>
> +
> +#include "../cgroup/cgroup-internal.h"  /* cgroup_mutex and cgroup_is_dead */
> +
> +/* cgroup_iter provides three modes of traversal to the cgroup hierarchy.
> + *
> + *  1. Walk the descendants of a cgroup in pre-order.
> + *  2. Walk the descendants of a cgroup in post-order.
> + *  2. Walk the ancestors of a cgroup.
> + *
> + * For walking descendants, cgroup_iter can walk in either pre-order or
> + * post-order. For walking ancestors, the iter walks up from a cgroup to
> + * the root.
> + *
> + * The iter program can terminate the walk early by returning 1. Walk
> + * continues if prog returns 0.
> + *
> + * The prog can check (seq->num == 0) to determine whether this is
> + * the first element. The prog may also be passed a NULL cgroup,
> + * which means the walk has completed and the prog has a chance to
> + * do post-processing, such as outputing an epilogue.
> + *
> + * Note: the iter_prog is called with cgroup_mutex held.
> + */
> +
> +struct bpf_iter__cgroup {
> +	__bpf_md_ptr(struct bpf_iter_meta *, meta);
> +	__bpf_md_ptr(struct cgroup *, cgroup);
> +};
> +
> +struct cgroup_iter_priv {
> +	struct cgroup_subsys_state *start_css;
> +	bool terminate;
> +	int order;
> +};
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

This might be okay. But want to check what is
the practical upper limit for cgroups in a system
and whether we may miss some cgroups. If this
happens, it will be a surprise to the user.

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
[...]
