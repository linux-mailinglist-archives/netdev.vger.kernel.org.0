Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1942588827
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 09:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235774AbiHCHoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 03:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiHCHoi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 03:44:38 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F355201A6;
        Wed,  3 Aug 2022 00:44:37 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 272Ni6jo025793;
        Wed, 3 Aug 2022 00:44:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=bjJGCrhUBCXr8ln00Sd9xbn9iQiz3Al/MXTsFVr+irE=;
 b=Kf1SUDK1PZsteCSW/3O932ZTiFP+ujt4DbbL3MdqXz+VG2vfUiYD4k9rYpQB8hmc1jUN
 SgFFKZawDIarZm83NFd5SS25xcVirmslQ7/o/4LRcv9QneBcs9FIcVU0aPwEzn38AJ9r
 OtMwaKzGf6tvCPZwoeNaCz3bsdzv2VU6vvA= 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hpy32fytj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Aug 2022 00:44:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LPdEon029zXPbBvSP4hYr/StdLh6IhRSRgTUA81GNcJ+7PKOiRrudA/E+1V6BIlsfUX9r2juuNKzF96gK/aitFAdfj0TSWQeweQYf+G8/mcMBN2QOKy4Uf5OxtLYje4IR9SSvaS7gWGCQdNwFBlPACuoD/MdrUr+2iPe98FrR9k/e4Djkm7KVYffxhd917ZZSwIKxb2sHiwwQQ0byAJVOxvnoXzqaQpvDmtl6pDh6yGh74zZaFwNpeT3yakl4kWxOKulF6YDxNsLbaJbpo+faFyJ7BK/ykemGQLKGf1I+Jz44iRcXsHSHWo5IlRh+LCqDSDZtck7PEHKahoIkHQD4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bjJGCrhUBCXr8ln00Sd9xbn9iQiz3Al/MXTsFVr+irE=;
 b=Zz4FU802Q+xUz9nKExP7buJZdQGCa817KqObg+BQbazK5jZY7a1IWZpENsNYcHKxDtQvM11f2WP5t+Wive0N+uNkh18bP5MuSnbVFhtdsqdWdYiFx1BY4Ia6829NlKUr45tM53TxKvF/OEY65M6ZKLhnFTkOEkzSNPGI7zDAwrA3X+1AeKqQtwXuWL6EJdK01EY5piSUnvefv4hjuXGUdS9ACyToWIo/cGiFBlAfzpTTG/wATy7IsmtOlIuGTFuA/hkQTH87T7ZbYLTZp6Oodo87IQS8xNp4NPRUKAqS1tv+O0ur3ERNvXtI/+aJ2AyFvqKSWPvh6TeK2eQ5knUEwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by MWHPR15MB1341.namprd15.prod.outlook.com (2603:10b6:320:24::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Wed, 3 Aug
 2022 07:44:04 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::de2:b318:f43e:6f55]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::de2:b318:f43e:6f55%3]) with mapi id 15.20.5482.015; Wed, 3 Aug 2022
 07:44:03 +0000
Message-ID: <c018a834-e834-270c-24b1-2c726b38b729@fb.com>
Date:   Wed, 3 Aug 2022 00:44:00 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH bpf-next v6 4/8] bpf: Introduce cgroup iter
Content-Language: en-US
To:     Hao Luo <haoluo@google.com>, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, cgroups@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Tejun Heo <tj@kernel.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        KP Singh <kpsingh@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Michal Koutny <mkoutny@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Yosry Ahmed <yosryahmed@google.com>
References: <20220801175407.2647869-1-haoluo@google.com>
 <20220801175407.2647869-5-haoluo@google.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220801175407.2647869-5-haoluo@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0194.namprd05.prod.outlook.com
 (2603:10b6:a03:330::19) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 775990f6-38e7-49bd-38dd-08da7523effe
X-MS-TrafficTypeDiagnostic: MWHPR15MB1341:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xg6LsiPbVVAod0MIEIMzsmngco/5pym0zACr600k2tS0eTlBU5brlbsNbvxRnRNoXYQojR6+MwS+dmjHe1piPO+wEmHtJdiJsp6+WOHUBijMO/CDMfHGvTDIBLnTHfWDLyyVbI160BIEpXo+HplsdTkDHbVQCaCutFPntvJESqAstvgu4AdJ3FJ1weCxirZxw4Jyj1oyQwWV4tnzj7Sdl330aPLTsJgtvYAcDpbhY/K/0sLJmeyhOOx2yvqDL6UaP/NNUKA9nfDGPQHUMSsL02yX/TPDBP0no4wKOXU6Yqpp8oGOJkyq8i3d02T01B4FsdwbmWCa6CmYnVWW0GygmN9hXQMaXxoa1DdIBVagArBbzj6viybkekSCtMUK2vfGqG09LPSZXPGZJDfzcVCOq5y68NMG8SbMxwonIsqXkTvvsQPer1SK+vtPWS7YlrIVvKeqnDRIU1t4F/g0mYWDO+29QH9CDxacJy2oRnSff9QcNREabRJwh5dx4AbuR2WwrxGT99mWm9yK9jnyWQfxOMZDPct2RNSxW52Xmqf/YdUeuxr2jKX+1PZ+cNYp6yO5rImpNc1Z75n5S3lz6gCW2vV2PT0QkZmv22lR5ow6qB7kNJqMztBRvcTG4gSPYfQGr8zjmlzXut72+BKLiNmGlr2EOEXXQGdg7KKhiyUmVME1D8tk2nY2eGxKdloxRagaiJ/7LFWIodwmlIdddJNLW/hffcC+S+LqJOt4P1CeaacEVPtxnaz2K+eUQGy0ajZJl8HcUXzaE5Tz4ActhS/Lgzq8EBxtxKVh1SRc35A2GccEUc8Zq2HEgnueg/Joi2U+NEejM7pAp4vqF9U4r4QDIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(346002)(376002)(39860400002)(366004)(36756003)(5660300002)(2906002)(8936002)(8676002)(66946007)(4326008)(66556008)(31686004)(66476007)(316002)(6486002)(86362001)(478600001)(54906003)(7416002)(6512007)(53546011)(38100700002)(41300700001)(6506007)(31696002)(2616005)(186003)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N2hNdDNTbjZwdVQ3MEpMMVMxOVNqTTFaRXA5Yk1xYnYvMk1tZURKSDNXT0pJ?=
 =?utf-8?B?d1I5WDVJekw0aXpVSjRIenRWQUdjVmI1S0dNbXVYOS9xTk9WZGNmeThBTE5W?=
 =?utf-8?B?ZEJLelh5WHRCdVJNK3ZqMmo5WWVaUGJtVHZkNXlJeVk5dUVVRDkyZ0lSR240?=
 =?utf-8?B?U3pOOGVwUUNSSWtrT1dSYnNPZDRKU3BKd1ovNkh4U0dxU3VJY2RUbHplcmNl?=
 =?utf-8?B?R3JZcDdiVVp6YVFHTHc2bEhDZXcyTXFrdXZhTW1YbjBGQXdwOVFkSjBRc0do?=
 =?utf-8?B?MkxRQkhFYUx6WEpzMmh6RDRyUksxZnJvZVArSTRBcTU5b0FMWjJXVWNmK0V1?=
 =?utf-8?B?V2tUNytHOFE2aEo5R1lYakZ1SkRnNGROVHZwM0xxZnFiUjVra3pXNlg3anFS?=
 =?utf-8?B?ZHcrenZ4VzJGVnkzVGVNTlY0TFppdTF1NkUrZkNGK2NndjZwMkpua0lXbUpk?=
 =?utf-8?B?V3VnNER4Y3JLdStVLzdtaHNMMXhacXhwUFRzajN2a3ZFN0tVdnIwUmdLT05t?=
 =?utf-8?B?cTUxNzZ0SEhCdVpMRFhWay8xdkVhaTYzckhlVXdnVzNNTllqZitJSDE0N3F0?=
 =?utf-8?B?MHFmTlNyV1lzSVFucExTQlVwR1BiSy90cFNJbktHVEhYMGw3bmlkOHFBNDRN?=
 =?utf-8?B?RTFvS2Vmdit4OEtLSE9sVGFjcE05Lys3L01jRDBGQTluRllNUGRPdzEvbDlx?=
 =?utf-8?B?VHdNZUFEK2cvRWkyVUR3V2JGK1V2OHk3TkczRmlESTByWExWL2RJaS9pbXRi?=
 =?utf-8?B?OExkV0RBWWZjOFkrNGs5OFo0bXRMVWNDV3BVUWZuM1ZmTUNlOWVyb2hEaUpm?=
 =?utf-8?B?VzFUVHE1d3VqNWJXWWNuWk96RjVtWEJtYzFGNGhTOWhCZVB0Y3owYVArNWxx?=
 =?utf-8?B?R1RwTmVVakpMd0xuVGxwcU5BMFBtWXNBWVFkWDlkd0tQZERiMm8rb0pZekYx?=
 =?utf-8?B?SWRzUllFcGNETG9tSHpSS1phZGZOalNRc1lnVFF3K1hZamFDS2pVU01RVGlr?=
 =?utf-8?B?V1Y5ckpyNjkzSlRRTFptbjg5WFk4VytVMzNmbEJ0T3Y1dDVpK0VRQlZQa3g5?=
 =?utf-8?B?SW55QnJmalc3RXd2N1VUd1k1SjV6ekFUbjNzazRFUmU1ZmpBeG4wem01eVZl?=
 =?utf-8?B?d1N6YlZML3VYZE5oZE9NUk5WOW45Z21UYkxYSkh6U0crOGpVU01lUFEyNFQ3?=
 =?utf-8?B?UEhLVzZ6S3BjUEtCNWZyaFFtSHI0TWRESDN4OFhvb2VHcUp3NGNMNGZScURR?=
 =?utf-8?B?a2pFSCtGOUk5QTE4ZlBLMDRZL0xzZVh3cmZzdFZFR1NQMFc2KzkvOTBWcCs1?=
 =?utf-8?B?THlwNFdYNTlsdjY0N0tTT1dDbjFkTEJuNGxyRmFLelhUeC9HQTc2elNGVmYv?=
 =?utf-8?B?a3M3MWlVdXEzMTFEc21KTjhzRzZkNk8zMWNScjdNa2xxYXp3d2JOV09oYjRK?=
 =?utf-8?B?R0hwREs0YmNGS1NQcDJmWVJtWVovUGc3a0swZi9DTWRQWXpISkwyVmpXdzNM?=
 =?utf-8?B?a0x5YS9OQXpaWEZJbFdvdml2QkJqZFRPZjBWbmlKOGx5WnNqME5IUGwvc2c5?=
 =?utf-8?B?b1VnQ1pORHFBK2lrOVZ1VitGQnFCS3IzOWVQSHhlNzQ5cXhBUGJFbmhxYzht?=
 =?utf-8?B?N1dEZUhyTE5LMXRSZGgrZnRkNlN1azM0bkhLN2U2aHZFN2h6bnAyZy9KNlVZ?=
 =?utf-8?B?b0IyRkExeFJjemwzOFh5MTlHbWJSZDRjUVR2ODlFT0p2amlkR2kvOEZia2h0?=
 =?utf-8?B?S1BramlxbUxxSExWS0NqcUNjVDlreGpPRzZXMDRqeGdKRUR6RGx0cWFyclZu?=
 =?utf-8?B?OHlDNEVndFdhank4YW0xUzVQa2JoZDJleFR6M1VqeTRkWFdjclplQW5VbVFL?=
 =?utf-8?B?SDBEaFR3TzdCT2NHdTBvcEgvcUE4dWUycXpUUTN1Y1dSSGpLREZhZ2g0TEIw?=
 =?utf-8?B?ajQwbm55S2ZVQUpsdS94MWxQNSt3V3FseHFlOSsrT1BNejlVeW5QaU0rZVls?=
 =?utf-8?B?R2ZTS2p4dXNsMGs5TjEreFE1UkxDdGFOUUFyc3VjZkE4T3Q4RmdUd3g0SE0y?=
 =?utf-8?B?ZFZmaERXNDFBRm1mZlpvajRtV21ROUVUVjJuMVJzMy9nTG42TSswV2IwUitk?=
 =?utf-8?B?UjJ2WWRkU3k1eU5jRDVRZHdGNnBqbXNzZCtNQS93a0hzVE1BYnZZQUhOSVJT?=
 =?utf-8?B?dHc9PQ==?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 775990f6-38e7-49bd-38dd-08da7523effe
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2022 07:44:03.8316
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OrUaG1SyhWRU1+ZcijThBWCuKm+VRiFe4oU90zKNMzH7r3SmfgQUIuTqxn6XgGGL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1341
X-Proofpoint-ORIG-GUID: QIgifCKBPSwI4kEOeuiakOf_cvZKdiLj
X-Proofpoint-GUID: QIgifCKBPSwI4kEOeuiakOf_cvZKdiLj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-03_03,2022-08-02_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/1/22 10:54 AM, Hao Luo wrote:
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
> Currently only one session is supported, which means, depending on the
> volume of data bpf program intends to send to user space, the number
> of cgroups that can be walked is limited. For example, given the current
> buffer size is 8 * PAGE_SIZE, if the program sends 64B data for each
> cgroup, assuming PAGE_SIZE is 4kb, the total number of cgroups that can
> be walked is 512. This is a limitation of cgroup_iter. If the output
> data is larger than the buffer size, the second read() will signal
> EOPNOTSUPP. In order to work around, the user may have to update their

'the second read() will signal EOPNOTSUPP' is not true. for bpf_iter,
we have user buffer from read() syscall and kernel buffer. The above
buffer size like 8 * PAGE_SIZE refers to the kernel buffer size.

If read() syscall buffer size is less than kernel buffer size,
the second read() will not signal EOPNOTSUPP. So to make it precise,
we can say
   If the output data is larger than the kernel buffer size, after
   all data in the kernel buffer is consumed by user space, the
   subsequent read() syscall will signal EOPNOTSUPP.

> program to reduce the volume of data sent to output. For example, skip
> some uninteresting cgroups. In future, we may extend bpf_iter flags to
> allow customizing buffer size.
> 
> Acked-by: Yonghong Song <yhs@fb.com>
> Acked-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Hao Luo <haoluo@google.com>
> ---
>   include/linux/bpf.h                           |   8 +
>   include/uapi/linux/bpf.h                      |  31 ++
>   kernel/bpf/Makefile                           |   3 +
>   kernel/bpf/cgroup_iter.c                      | 268 ++++++++++++++++++
>   tools/include/uapi/linux/bpf.h                |  31 ++
>   .../selftests/bpf/prog_tests/btf_dump.c       |   4 +-
>   6 files changed, 343 insertions(+), 2 deletions(-)
>   create mode 100644 kernel/bpf/cgroup_iter.c
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 20c26aed7896..09b5c2167424 100644
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
> +		int order;
> +	} cgroup;
>   };
>   
>   typedef int (*bpf_iter_attach_target_t)(struct bpf_prog *prog,
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 59a217ca2dfd..b8e0644bf43c 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -87,10 +87,30 @@ struct bpf_cgroup_storage_key {
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
> +	/* cgroup_iter walks either the live descendants of a cgroup subtree, or the
> +	 * ancestors of a given cgroup.
> +	 */
> +	struct {
> +		/* Cgroup file descriptor. This is root of the subtree if walking
> +		 * descendants; it's the starting cgroup if walking the ancestors.
> +		 * If it is left 0, the traversal starts from the default cgroup v2
> +		 * root. For walking v1 hierarchy, one should always explicitly
> +		 * specify the cgroup_fd.
> +		 */
> +		__u32	cgroup_fd;
> +		__u32	traversal_order;
> +	} cgroup;
>   };
>   
>   /* BPF syscall commands, see bpf(2) man-page for more details. */
> @@ -6134,11 +6154,22 @@ struct bpf_link_info {
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
> +					__u32 traversal_order;
> +				} cgroup;
> +			};
>   		} iter;
>   		struct  {
>   			__u32 netns_ino;
> diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
> index 057ba8e01e70..00e05b69a4df 100644
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
> index 000000000000..e56178fbcc85
> --- /dev/null
> +++ b/kernel/bpf/cgroup_iter.c
> @@ -0,0 +1,268 @@
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
> + *
> + * Currently only one session is supported, which means, depending on the
> + * volume of data bpf program intends to send to user space, the number
> + * of cgroups that can be walked is limited. For example, given the current
> + * buffer size is 8 * PAGE_SIZE, if the program sends 64B data for each
> + * cgroup, assuming PAGE_SIZE is 4kb, the total number of cgroups that can
> + * be walked is 512. This is a limitation of cgroup_iter. If the output data
> + * is larger than the buffer size, the second read() will signal EOPNOTSUPP.
> + * In order to work around, the user may have to update their program to

same here as above for better description.

> + * reduce the volume of data sent to output. For example, skip some
> + * uninteresting cgroups.
> + */
> +
> +struct bpf_iter__cgroup {
> +	__bpf_md_ptr(struct bpf_iter_meta *, meta);
> +	__bpf_md_ptr(struct cgroup *, cgroup);
> +};
> +
> +struct cgroup_iter_priv {
> +	struct cgroup_subsys_state *start_css;
> +	bool visited_all;
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
> +	/* cgroup_iter doesn't support read across multiple sessions. */
> +	if (*pos > 0) {
> +		if (p->visited_all)
> +			return NULL;

This looks good. thanks!

> +
> +		/* Haven't visited all, but because cgroup_mutex has dropped,
> +		 * return -EOPNOTSUPP to indicate incomplete iteration.
> +		 */
> +		return ERR_PTR(-EOPNOTSUPP);
> +	}
> +
> +	++*pos;
> +	p->terminate = false;
> +	p->visited_all = false;
> +	if (p->order == BPF_ITER_CGROUP_PRE)
> +		return css_next_descendant_pre(NULL, p->start_css);
> +	else if (p->order == BPF_ITER_CGROUP_POST)
> +		return css_next_descendant_post(NULL, p->start_css);
> +	else /* BPF_ITER_CGROUP_PARENT_UP */
> +		return p->start_css;
> +}
> +
[...]
