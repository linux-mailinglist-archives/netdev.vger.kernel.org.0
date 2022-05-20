Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE1052F029
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 18:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351402AbiETQKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 12:10:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344921AbiETQJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 12:09:59 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFD0817CE78;
        Fri, 20 May 2022 09:09:57 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KF913f011843;
        Fri, 20 May 2022 09:09:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=dK/WPah+Njuj6KyTgpYn4HCZNrvh+sREx3/JSOWITTE=;
 b=KxteDxWim7Ps9k41SrVJxCLDS8pimzC9LQpOTW7fIL3HhxClUSn7/p0A8RPW00PyjhVP
 Gv2PpvrX5NBScg7bEF38u4QgSeEuk2ReCVtMIGdEPbk7gKuMrBi4vlmxESjuFr5LOw8F
 2dyb3785mbd4Spq+yjuQ8gIfMcpvFhZfgV4= 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g5xexctes-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 May 2022 09:09:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=grqamDGTmUBRfxip0Ib3AH998YIzcqHgOC0YVULGwh2u+H2Y6J2+ZKvd0QK72AahH3X/fAjANtLZqqJB4MGdEtvL+VQoX1ZDZHDvPXvg8/KTppWktFQqqz2ck8fH0oGcW18+ktqiGSAL6qn8MW9g0guyER9vCliMz7YRVMAkuyVGw4r8w5zung5E1jaHKZ3+qIG8FfIrVs8WfB1NJYu8DKv96+CXl3C6vYKAkc0mIRHBASEQUVbiMYVwam/L07J7P7l6QjzI946Sr7dpndGwPUqsq1sUGZZMnxq6ui+kYveB0eb1dEZ8L3PVHXqlInSmAQSkNnlJCnxSyeUyaKgOdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dK/WPah+Njuj6KyTgpYn4HCZNrvh+sREx3/JSOWITTE=;
 b=Pj8rnV/VjK09CL4770xs41vbbiRY0nSgTbtD5nAkCXQLhWNdEaVN140cr2BTgTItPh9vAjarvRCyx96kTipXSL/3rJIPApSbdMH2in/8ZIBwua5mZ0w7ahDUnVGMjsE9VnQj1Oag0J+viWF5Scq3ivTSA7tyVNyffv+gdiYiCJUjd4zTKVLUm90KTex3ka/r1VJvmT6W8hU7am7JNPxpmT33Q2ET9x/AMhcdvpQv4lAymxGemF6mwbHbbsTp2/uJKKJLIYAe39kFJ9YYADRWG97C8ZfwMQQhICQ/A6PX1r2Aa/gABDXkS7SL24x0qySf/vqNdvDJurBJQh/ooAuYYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by DM5PR1501MB2008.namprd15.prod.outlook.com (2603:10b6:4:a6::34) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.17; Fri, 20 May
 2022 16:09:33 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53%7]) with mapi id 15.20.5273.017; Fri, 20 May 2022
 16:09:33 +0000
Message-ID: <926b21ee-58e8-18b1-3d60-148d02f1c17a@fb.com>
Date:   Fri, 20 May 2022 09:09:30 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH bpf-next v1 5/5] bpf: add a selftest for cgroup
 hierarchical stats collection
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
        Shuah Khan <shuah@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Michal Hocko <mhocko@kernel.org>
Cc:     Stanislav Fomichev <sdf@google.com>,
        David Rientjes <rientjes@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, cgroups@vger.kernel.org
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220520012133.1217211-6-yosryahmed@google.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220520012133.1217211-6-yosryahmed@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0189.namprd05.prod.outlook.com
 (2603:10b6:a03:330::14) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9bb04a12-37f2-4eba-fc5b-08da3a7b20d9
X-MS-TrafficTypeDiagnostic: DM5PR1501MB2008:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1501MB2008B2955EAA7B725440B0FFD3D39@DM5PR1501MB2008.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B6X8BuDU3ZDyyCgJIOrQMeOQaMzDOxSFXvzW2HslP7NNbLPshshtCa3zS5ZPK3WMuiJiGmZ6jcdkjTkNFsXidAbNrxMsDrjVlU+BoX4HVdRTYG+Cbye7DYXR6Y8J85QHJJ5kmJut2V4MEnwiAB6CcG0eC81SOd6ic8cj5R/Y7kwCnXyAdZqYlTq7I5/ldm+Ec1F4RYgT+ygtUfVe9r9GBncL204ECbNU0XIg47543bsx2tWgV8043Gxg7rRfdn+RoOYbirvGrfBDoa+KRLYF1igyx8tLO66dtJ+WBd50BMOtnEvluGbaeI/GRRzoMmYAFCwEgDyaYlYyMTUr9d/lI4LKZAPXhnymbi3DVrPqXdLb/iZQbDW/EHkbo5HaHDHITPXRje3iRaMjCpPhc8RhCU/tM+FLHsfgIqBxrBCIkJAXHlJ01OIwHMUrtKoFt4U8kFstjtPFbkkpbFiukxO7r5rgSD2ZM6cCi1hwZmeVUaVR+KH5YQpZ/hrtKxnhPJJIVqC46wsIj0aP7aKb1q8xPiSVfOE0eyAxErhc4KB4OMUwd2azC5LL0RkeAdbqpRX1gHL5K5Z6Y6JKu3x+G+mffknEjfor0af3a7y38jr/mZlHZfO4TlKcTGvpA7SqRSSIBEUsUPoUqrDGFsOjnTuqwX8iGqiMsATC1kpjqWFSHIQEgR+k6sjwRoKOsB5NNBV+f65sLgIC58Pz+3g0RtrSp/Z3O2HtjFrZ/5YiS0Ug4FN0fde8pp+Asp1KAr7OCUszCHuOCBV75V/uuWq+OTbECA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(5660300002)(6486002)(7416002)(8936002)(66946007)(66556008)(66476007)(8676002)(4326008)(52116002)(31686004)(54906003)(316002)(110136005)(508600001)(2906002)(53546011)(6506007)(38100700002)(31696002)(86362001)(2616005)(83380400001)(6512007)(186003)(921005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZnIyd2pLMkxxcWVHd25DZjByU1N6TGZBSXRrMEtiMVMxclFBcHlxVUJiMnkx?=
 =?utf-8?B?bmJZV29qdTFZamtFcGpENWtFZ2oxcUlLZjlUOGt3ZjkrOHErNjFUYUNvT2pr?=
 =?utf-8?B?RGxFTEg2WU5JME5rdkkrREg4YzFybS9HZ1RoeFNQUURHanFQTkszZ21wRzlX?=
 =?utf-8?B?NnFWaUhrQzB2RjIwSGZLTkxibTdKUituV3dxRTZFYzZ4ZnQ1ZkkxK2t2Q1Fz?=
 =?utf-8?B?a3dOR0dtaTYrTFNGSHNOZXYwQ3p2THBhcE1FV3RlanhoY0JLTmpLSzluemtI?=
 =?utf-8?B?Ym44NkJYTWlhM3ZrTmd6WUxRMHJUUWhud0xuc3kva3BGVU5OUkhaVGFRT1kw?=
 =?utf-8?B?bFArQXVDSy9KYWRhYXFReVdQWFVXY01DVXh4YTlScDVlcFhTMldEVFQ3anFE?=
 =?utf-8?B?YlFoZ1JhZHlqeDRpb1FHL1J4bmZSd1VXa21PMDBubkVpKzBjc1VqNUN5S1Y0?=
 =?utf-8?B?aDdkM2xzWVY4aGd0bi92aHpQNGZOUVlpV3dzTmRycElKaFJpQkpzSWwzVlVS?=
 =?utf-8?B?SXhzS1lHMmY5bVJJZ1I3THhkZ2pDTEk5bHF5ZXNDVVZSd2pGQTBmdHEzcS93?=
 =?utf-8?B?WndtdmNUbVZla1lxMzNkeVRJdWJWNkFQdmZaQnIxc0hIR2lSMUVLV1l1MkVP?=
 =?utf-8?B?cmVPRzJzQWhFZElSZ3hEODNWSlZaTnBlWkNWZUVmd2lNcHJobmYybWU2SUt3?=
 =?utf-8?B?eWZoWVB4UHFDK1BSbFBFYlVieElJUXlCRFdyM1RHUUx1K2o0L2U2dlIyMFRa?=
 =?utf-8?B?MG93bk1OSlZ5U0FUeG9SN0pWcmdkTGhCVW8ybit2WTVCcFVDdndCY2lCS1Z6?=
 =?utf-8?B?ZE8ySlp3d2kyekpFdjVLWnphdElDMWxmLzU5NkNTTmJVd3NQYkpXZERJZDA4?=
 =?utf-8?B?bmNxcVo3ZWVlUXF3S0hIVzVUUUFqZGRSMFFNR3VtUTMxak15K05pYzViQXFB?=
 =?utf-8?B?cGVtZlJBa1VpaHEyd080M2ZUU0k4WjYzUm9wSkFuYVhZUG9GajNGL29kdWVI?=
 =?utf-8?B?VHlhalRTdlg1ZXlwaEZLNXVSMDZ6RyswYjc5dm1lVUNKQzhESnBBRkUzeWlF?=
 =?utf-8?B?LzBsMjBEWnhVRHpiVUErTDdaUVFJODU2b08yWFl3YmVpVDZuTjg0N0dMalZP?=
 =?utf-8?B?Z3A3dXpBTS8xeFcrVUorZC9tMlo2a0Rwd3ZNQytabHQrWUI5cHdPdjUvR2JQ?=
 =?utf-8?B?YmhTeS83OEdjQ2k4bGQySTV2ODRuNVdadjdWakh6bHJTLzdUcTk1ZlBaT2dP?=
 =?utf-8?B?U05oTWRIZEhzeWVHbzBDQ3R4NkVjYWhNSlJ3YkJtVEx5RkhDYmtsMmszSS9O?=
 =?utf-8?B?NWMrV2lrNUEvRVhabHhrRVVTR3UvbWxKcVNlMUdGQlBTRU85RzN5bld6aGkx?=
 =?utf-8?B?NGZDZjk3MGl3akMxQVlVUVhIOVRqeUFOb0ZheUxZNUlVbnVDampvYVRRdElp?=
 =?utf-8?B?MWtEN1RrUTB2dlFpQXl6ZGZib2NVZUkzbmdEZHpVb3hKd1ZoUDdkZ0IzMUwr?=
 =?utf-8?B?cTVQNlpLemZDc0h2UHNxNlVkWTFSVUtDM1JMS1d5K1NBV3FuMWo0Z2NVOW9B?=
 =?utf-8?B?Q3k0WEJuRmZaNW0vOFMxWmpyejdHVzhEVHY5RkRJYWVUemk3c3JIeTFHK3kx?=
 =?utf-8?B?blFqTW1HazU3SWZkNEU1UXpoV3Z3TGZFUlpPZ2xOdGpvTGZNaU0yYlh6cVFx?=
 =?utf-8?B?emNML3BvNWVJajRHSk1NNFpUaXRBN0NnaUVXSHRyTWl2am9qV0h5V1FlNXp6?=
 =?utf-8?B?ZnkrN3R2eTZJVVl2bk5GYm9Ua0tZTkJqUEp1STJVSEN2NWhFQTNLMW1SUkF3?=
 =?utf-8?B?WnpNMzByN3ZmMDVZYjRBN0p2SDg4VGlKNUVqRjJCVDE1RFVtMitVcEJmNHBZ?=
 =?utf-8?B?M1Bsd2I3R2VPS21BcW9YZldXcEo0V0wwUXVVNDE5RGFoZTlpdnNzS25tZXlk?=
 =?utf-8?B?clZ5d2VxbndNNi9RTndCWjJkVjIrL1pDN29yL2VrZEZFWkp5azRjRlNPaENN?=
 =?utf-8?B?eldoR2tsWGc2dWVKYlJXUUE5NWpDc010Ky92VmlERFBiNGN0ektqU1RRZWZE?=
 =?utf-8?B?eXpITjBvdzBYdzFHL0RSV2Zud2Ztd2lDOElRNGthUFBXRklJRStPaXY5c1Zq?=
 =?utf-8?B?UWhmUGt2OFBycStjcGJja0JjbTF3SHJsU3F4V0NsdHY5VHRpSjZMVUh0QXpk?=
 =?utf-8?B?a01ObXQyMVJwTXpKQ3E1TERHYkxTNDVSZnhNOGtaaE00ZytPWm1KRWhtYmE2?=
 =?utf-8?B?YWV5MWhMb1hzOEpxSG9xSzFPNCtacWFkTHVESU1mMEtONE1CUlNaZVB4Um9Y?=
 =?utf-8?B?VDBPYlloVFZ1Y1ZNaHNmMUo5M25hbGRzZU5vaTZQZU5nVjFYY3lpc3dSaTh0?=
 =?utf-8?Q?bkDa6t4VG2+zwe/E=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bb04a12-37f2-4eba-fc5b-08da3a7b20d9
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 16:09:33.4141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MKfrr0/6bAGqGV5QhAA6pkVDRJPsIPCGPBiVyVjYe5wxKPvL92oTLNzc6pJtoyQa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1501MB2008
X-Proofpoint-ORIG-GUID: bNP1kkowz_5ZrtF4HTbELdEB7IaZWfEu
X-Proofpoint-GUID: bNP1kkowz_5ZrtF4HTbELdEB7IaZWfEu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-20_04,2022-05-20_02,2022-02-23_01
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/19/22 6:21 PM, Yosry Ahmed wrote:
> Add a selftest that tests the whole workflow for collecting,
> aggregating, and display cgroup hierarchical stats.
> 
> TL;DR:
> - Whenever reclaim happens, vmscan_start and vmscan_end update
>    per-cgroup percpu readings, and tell rstat which (cgroup, cpu) pairs
>    have updates.
> - When userspace tries to read the stats, vmscan_dump calls rstat to flush
>    the stats.
> - rstat calls vmscan_flush once for every (cgroup, cpu) pair that has
>    updates, vmscan_flush aggregates cpu readings and propagates updates
>    to parents.
> 
> Detailed explanation:
> - The test loads tracing bpf programs, vmscan_start and vmscan_end, to
>    measure the latency of cgroup reclaim. Per-cgroup ratings are stored in
>    percpu maps for efficiency. When a cgroup reading is updated on a cpu,
>    cgroup_rstat_updated(cgroup, cpu) is called to add the cgroup to the
>    rstat updated tree on that cpu.
> 
> - A cgroup_iter program, vmscan_dump, is loaded and pinned to a file, for
>    each cgroup. Reading this file invokes the program, which calls
>    cgroup_rstat_flush(cgroup) to ask rstat to propagate the updates for all
>    cpus and cgroups that have updates in this cgroup's subtree. Afterwards,
>    the stats are exposed to the user.
> 
> - An ftrace program, vmscan_flush, is also loaded and attached to
>    bpf_rstat_flush. When rstat flushing is ongoing, vmscan_flush is invoked
>    once for each (cgroup, cpu) pair that has updates. cgroups are popped
>    from the rstat tree in a bottom-up fashion, so calls will always be
>    made for cgroups that have updates before their parents. The program
>    aggregates percpu readings to a total per-cgroup reading, and also
>    propagates them to the parent cgroup. After rstat flushing is over, all
>    cgroups will have correct updated hierarchical readings (including all
>    cpus and all their descendants).
> 
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> ---
>   .../test_cgroup_hierarchical_stats.c          | 339 ++++++++++++++++++
>   tools/testing/selftests/bpf/progs/bpf_iter.h  |   7 +
>   .../selftests/bpf/progs/cgroup_vmscan.c       | 221 ++++++++++++
>   3 files changed, 567 insertions(+)
>   create mode 100644 tools/testing/selftests/bpf/prog_tests/test_cgroup_hierarchical_stats.c
>   create mode 100644 tools/testing/selftests/bpf/progs/cgroup_vmscan.c
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/test_cgroup_hierarchical_stats.c b/tools/testing/selftests/bpf/prog_tests/test_cgroup_hierarchical_stats.c
> new file mode 100644
> index 000000000000..e560c1f6291f
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/test_cgroup_hierarchical_stats.c
> @@ -0,0 +1,339 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Functions to manage eBPF programs attached to cgroup subsystems
> + *
> + * Copyright 2022 Google LLC.
> + */
> +#include <errno.h>
> +#include <sys/types.h>
> +#include <sys/mount.h>
> +#include <sys/stat.h>
> +#include <unistd.h>
> +
> +#include <bpf/libbpf.h>
> +#include <bpf/bpf.h>
> +#include <test_progs.h>
> +
> +#include "cgroup_helpers.h"
> +#include "cgroup_vmscan.skel.h"
> +
> +#define PAGE_SIZE 4096
> +#define MB(x) (x << 20)
> +
> +#define BPFFS_ROOT "/sys/fs/bpf/"
> +#define BPFFS_VMSCAN BPFFS_ROOT"vmscan/"
> +
> +#define CG_ROOT_NAME "root"
> +#define CG_ROOT_ID 1
> +
> +#define CGROUP_PATH(p, n) {.name = #n, .path = #p"/"#n}
> +
> +static struct {
> +	const char *name, *path;
> +	unsigned long long id;
> +	int fd;
> +} cgroups[] = {
> +	CGROUP_PATH(/, test),
> +	CGROUP_PATH(/test, child1),
> +	CGROUP_PATH(/test, child2),
> +	CGROUP_PATH(/test/child1, child1_1),
> +	CGROUP_PATH(/test/child1, child1_2),
> +	CGROUP_PATH(/test/child2, child2_1),
> +	CGROUP_PATH(/test/child2, child2_2),
> +};
> +
> +#define N_CGROUPS ARRAY_SIZE(cgroups)
> +#define N_NON_LEAF_CGROUPS 3
> +
> +bool mounted_bpffs;
> +static int duration;
> +
> +static int read_from_file(const char *path, char *buf, size_t size)
> +{
> +	int fd, len;
> +
> +	fd = open(path, O_RDONLY);
> +	if (fd < 0) {
> +		log_err("Open %s", path);
> +		return -errno;
> +	}
> +	len = read(fd, buf, size);
> +	if (len < 0)
> +		log_err("Read %s", path);
> +	else
> +		buf[len] = 0;
> +	close(fd);
> +	return len < 0 ? -errno : 0;
> +}
> +
> +static int setup_bpffs(void)
> +{
> +	int err;
> +
> +	/* Mount bpffs */
> +	err = mount("bpf", BPFFS_ROOT, "bpf", 0, NULL);
> +	mounted_bpffs = !err;
> +	if (CHECK(err && errno != EBUSY, "mount bpffs",

Please use ASSERT_* macros instead of CHECK.
There are similar instances below as well.

> +	      "failed to mount bpffs at %s (%s)\n", BPFFS_ROOT,
> +	      strerror(errno)))
> +		return err;
> +
> +	/* Create a directory to contain stat files in bpffs */
> +	err = mkdir(BPFFS_VMSCAN, 0755);
> +	CHECK(err, "mkdir bpffs", "failed to mkdir %s (%s)\n",
> +	      BPFFS_VMSCAN, strerror(errno));
> +	return err;
> +}
> +
> +static void cleanup_bpffs(void)
> +{
> +	/* Remove created directory in bpffs */
> +	CHECK(rmdir(BPFFS_VMSCAN), "rmdir", "failed to rmdir %s (%s)\n",
> +	      BPFFS_VMSCAN, strerror(errno));
> +
> +	/* Unmount bpffs, if it wasn't already mounted when we started */
> +	if (mounted_bpffs)
> +		return;
> +	CHECK(umount(BPFFS_ROOT), "umount", "failed to unmount bpffs (%s)\n",
> +	      strerror(errno));
> +}
> +
> +static int setup_cgroups(void)
> +{
> +	int i, err;
> +
> +	err = setup_cgroup_environment();
> +	if (CHECK(err, "setup_cgroup_environment", "failed: %d\n", err))
> +		return err;
> +
> +	for (i = 0; i < N_CGROUPS; i++) {
> +		int fd;

You can put this to the top declaration 'int i, err'.

> +
> +		fd = create_and_get_cgroup(cgroups[i].path);
> +		if (!ASSERT_GE(fd, 0, "create_and_get_cgroup"))
> +			return fd;
> +
> +		cgroups[i].fd = fd;
> +		cgroups[i].id = get_cgroup_id(cgroups[i].path);
> +		if (i < N_NON_LEAF_CGROUPS) {
> +			err = enable_controllers(cgroups[i].path, "memory");
> +			if (!ASSERT_OK(err, "enable_controllers"))
> +				return err;
> +		}
> +	}
> +	return 0;
> +}
> +
> +static void cleanup_cgroups(void)
> +{
> +	for (int i = 0; i < N_CGROUPS; i++)
> +		close(cgroups[i].fd);
> +	cleanup_cgroup_environment();
> +}
> +
> +
> +static int setup_hierarchy(void)
> +{
> +	return setup_bpffs() || setup_cgroups();
> +}
> +
> +static void destroy_hierarchy(void)
> +{
> +	cleanup_cgroups();
> +	cleanup_bpffs();
> +}
> +
[...]
> +
> +SEC("iter.s/cgroup")
> +int BPF_PROG(dump_vmscan, struct bpf_iter_meta *meta, struct cgroup *cgrp)
> +{
> +	struct seq_file *seq = meta->seq;
> +	struct vmscan *total_stat;
> +	__u64 cg_id = cgroup_id(cgrp);
> +
> +	/* Flush the stats to make sure we get the most updated numbers */
> +	cgroup_rstat_flush(cgrp);
> +
> +	total_stat = bpf_map_lookup_elem(&cgroup_vmscan_elapsed, &cg_id);
> +	if (!total_stat) {
> +		bpf_printk("error finding stats for cgroup %llu\n", cg_id);
> +		BPF_SEQ_PRINTF(seq, "cg_id: -1, total_vmscan_delay: -1\n");
> +		return 0;
> +	}
> +	BPF_SEQ_PRINTF(seq, "cg_id: %llu, total_vmscan_delay: %llu\n",
> +		       cg_id, total_stat->state);
> +	return 0;
> +}
> +

Empty line here.

