Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B865756D22A
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 02:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbiGKA0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 20:26:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiGKA0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 20:26:52 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B25415811;
        Sun, 10 Jul 2022 17:26:50 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 26ANlKLZ014676;
        Sun, 10 Jul 2022 17:26:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=EkN9iriu+fXbAw0wzR7p193DQT76V+ccrcAkUG9xQoU=;
 b=IaJLfb3HSE+C+mvuNJoB7sIivzrhdqSKNa48SW2wFHLUkgXpOWAzF4B/vizC0f+GhjBd
 rb5UkreBknZFvciW3hG+ZlhRyf71bysX4CTqUajv5CZYbWSCCxaINyl5Tovzsiy2lyU6
 ITN7UukjWCNjT56mwKZuQHbN8WpZUx9l77k= 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by m0089730.ppops.net (PPS) with ESMTPS id 3h7567pejh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 10 Jul 2022 17:26:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bYMRY2k1HtyvL6Cmvz2mhN6VZsPa3TJ+qxStvRgczNRIdxHWmfWP/xP0nGNkhhfjDfmil9KICX8qMvTUsVHTp7df8yR9GNoLpUeK9/iQbZpKvgLraC8vcB2A0Tq1jypPis9rLPjjJmBAgI1ZwRHcK+MRc72Im72Hr8Ikx/aVZw/iUCFhwguqeDUFV0Oxsg++MsEaq5V85Cn95RMPwpdsBveLyuRpifkxWiCX1NI7cGFPDffrPW4HgBWJYdiE1YcLyKwNsnZpGh+f8OemEtLk0XcaYwSpR8ff9wFGgb/kM7dX0uhlMV1CMImn9JkOkDwFpmhnc+4ldO4gi7YoaFk/UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EkN9iriu+fXbAw0wzR7p193DQT76V+ccrcAkUG9xQoU=;
 b=dl3vLLIr7/sU+U1hXBdI9rjZ8dcQL2UYRMWyjdW5Nkk8Py+rlDTtXBaKoakd8p4bYUezxvO39nH/n4s5bnjFI/5vvM1hhBOx7AgkVvvD5nhby8CubeH1AD+NWc3hZ9A9rNLjbeL79Hd0QWNsqz9OCEty0jw753LWdCjJ7EPo5WYHSPMt1iGeC/rsduZs7lySogd6iABDQ/Rgf2FV9rFwrvnr385AMaAvrsKGXbCUN4lVqF8XYoDeWJlyZooZ28ZQtSHqMyhIkMb29wlDI4FQFU2hnIAq7tfPAPz54v0vbjVBo8gbHvr7bB7Jw3AmhbB94cdFbHqhW69LDZsC9dDpeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by PH0PR15MB4150.namprd15.prod.outlook.com (2603:10b6:510:26::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Mon, 11 Jul
 2022 00:26:24 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23%6]) with mapi id 15.20.5417.026; Mon, 11 Jul 2022
 00:26:24 +0000
Message-ID: <b4936952-2fe7-656c-2d0d-69044265392a@fb.com>
Date:   Sun, 10 Jul 2022 17:26:21 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH bpf-next v3 8/8] bpf: add a selftest for cgroup
 hierarchical stats collection
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
 <20220709000439.243271-9-yosryahmed@google.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220709000439.243271-9-yosryahmed@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0077.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::18) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9ec350b1-fef2-4166-9132-08da62d3fccf
X-MS-TrafficTypeDiagnostic: PH0PR15MB4150:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XnVS8WEKMKSTeS25IIYO3Gh32mcM08UztWf+Ofk7pkd73CB/rlQVIlx3z2OMXBo6iQgh+TkCSrB+pEo4xeRjQtEZckbjuHPvWL5CjbHD9eqbjANNfvFI5Zd5PIB5kjsoNJkJXNzdg4Wf5doxworh9t8z9o/gpXx0Pj9CZzl/+5I5R3GfqFM9j1iFQk3j7DfY533wltsxdZUm0b8ALWSdaPejTzB7j1+tnHQrqm44EW4l5QZnUJLQuLktyc3bZaJWm7eeH7MNwVNBdnaUZpS7ntuSKPd8YZdoij8BoSjItHQMPyKx2+kAU9USsTyYlXUBr1D4Imhhn1aG5vvIeWPDe6869onLnn8tH3+JbjLCAVmHkXGDzfRbfznt36hrhbAv2uxbiNWX57RwB0bY0zpbmKWdMdp6TeA8gJQnI3HEaSpEZ438tT1S0kQv6rS3uNugpqNVFyt+DPImfXiCh67CSj8t4B3eAlByfXN1zftVFxybNDm/NGym+0ZhsPaHeTtcIkmtDP5sx8F6OBAlkvHm0h2CN3CdbZf7bYlEkWyg9qgMppLQ7Qq+VwvlAzuKEaNTxJd7+0Ik3TnyMvyEH6f843A8KHtzVPDOQTPPCsdw4c4zWyvjv4+KTOfrrMb5dXyxCQJSJqi9Y/5Gg2rBwb4oJpr8GX6w/S0Zn0qNXhTW0D5+Unyv+5DxsEXYkfk0HLPPkJeF/AESeNFCbPMtqrmewS0wss+AB/qarGWFLZUIGMdipcJWuo/2nNE3wXG6ce1mQCaijjwx6I5Qa+5mR7sFWW9PBi/odXvVtMIUSUz7xTnz2argu2bvCb2ucjq0upadXY1T25JPLLSdGZVWaPAsQTi6mDbOFn9nvoteQyZv1Oc2gD2UkjCtt8dqMUgDNx9FKT2Q7pLMGClJxdb85V3tQQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(376002)(39860400002)(366004)(346002)(2906002)(6486002)(478600001)(31686004)(83380400001)(36756003)(186003)(31696002)(66946007)(110136005)(8676002)(86362001)(316002)(2616005)(8936002)(7416002)(54906003)(66556008)(66476007)(4326008)(5660300002)(38100700002)(6666004)(41300700001)(6506007)(53546011)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M293d3RTM2tJSW14MDZFWElVamNXTGU4K1AzK0EzL295d1llOXZrdkZCcmRu?=
 =?utf-8?B?RE10eEljUDBvY00xdUpBTEdpWW5FU0ZiLy9EYWtZN3d5Sms2bGQrYUxTNElB?=
 =?utf-8?B?QkkxYnlwYXJQRzZTN1Izb2kyQ3RoVmtCWVE2RkgrMWU2anJJMnlsREhCMlpW?=
 =?utf-8?B?OXZDaWIzQWtZakVQalZCU25XekowZHBWYjc2N2xlZUh6WDNpeUlRVzZwY0JK?=
 =?utf-8?B?Sklhajd2V0lkY3RSWVBhVEs3Tm42S3dYeEZVQnB6QVF5T2phYWcyd2FKdzg2?=
 =?utf-8?B?OWhnR1BHMS9iY1lVY2s4aGVJSVcrMTV1UEgwSTZYVW8reFlHb1A4NGI3QkZx?=
 =?utf-8?B?dHVsRzh4ZnUyZk8rTVhMUEpxTjZXeS9kc2VyNGd6MzRVelJLS2hmRXIzVW1O?=
 =?utf-8?B?TFQ0RTRWZDZXaHlhcGdYY09kZW5teFpZek5vOGhkNklzOXZ0WEM5a2JZRVBK?=
 =?utf-8?B?Zk1sVnVuSnAxQ2orVmRLaUVLeE5pSXNKNXI2akt1QnJIUUZ1dXhLbzNvS2Zt?=
 =?utf-8?B?Yi9jdHVVOGszYlF3WEpTNjZIUmRWbmxiWStvaVg2MEs1OWs2ejdmK0RvVjhj?=
 =?utf-8?B?RnFUc3EyWEVBN1lWODZkSVhDWkwrNHJ0SlNhemdUSE9hdnMzdTR4L0R3V2hn?=
 =?utf-8?B?Z0RhYlN2c0w4S1dIalkrbGVLYXhRaExrN3k4S1lBQUxQWW1zK3EvMjJCUlVw?=
 =?utf-8?B?aytsM3JRSmhCZUZ5by9rVjVWMnBKRE5pUHExSTRaaTZCZkdJeGRJZjJGSjJV?=
 =?utf-8?B?eFN5Zk5ZTS9Da3NhenNVVUZ3M2lZQVBvckdoSThnaWV4UzZMNVJML2lYRUN3?=
 =?utf-8?B?cmhuaHZUeTZlZFVBREdFNXlDdElsdGJ4ZkVRUFFjWXZwTzhXdGVhRkRwSGJD?=
 =?utf-8?B?ellETFJYcnRvM1ZEN3lDekJOWDdFZkFEbHpiUGlXbXdRMGw5M1RGZzhIZ3Bq?=
 =?utf-8?B?OE1yQkVxejRhWndqM0NZa2hqQ3JBanU0cmRqbkVwQlovazQyeGhKZkMvYjFH?=
 =?utf-8?B?emhXWjlGeGY4QVNqdWZQaUwrUERPckhkemdIaWQ4SjFMdjdrdzd3a1QzRWlS?=
 =?utf-8?B?OWhxSkVYeGV4VG9waTI2VFFqWUxQUlV5NDAya09FMGo4TS95REJ3L05RWlBm?=
 =?utf-8?B?NzBDb1NVTWtTb2RwZzZNc1RRTHhQcDJpUUdEa3pXOEdtU1ZtekwzbHM3MjJ5?=
 =?utf-8?B?cGZpeFFEZWEydWltbm1BVkJqN0Zrei9FcjRxVFQ3bjNTa1hwUjF6dXZaVWlV?=
 =?utf-8?B?bGJDanVLbkhaS1FmRzRIcWdxMnZLajBCNWVuRVlpQ09JOWpjV08rY1ZxVVNL?=
 =?utf-8?B?N1JpSFBEUzFPbktKRCtXampuQnpwOE9OR01xMERqRnI0bzZDMHVSUWpsQTFM?=
 =?utf-8?B?OGZ4TlpuT1Vma0NOMCtrSUtERVRaSWpsa1B0WUZtMThOMkh5N0xJVWFpVmxF?=
 =?utf-8?B?MVBaSXIyZGZYRmxURVFyTUR6ZU9acmdZSDlMMVV5ZUpkL1VSbWRuekthaW1K?=
 =?utf-8?B?dGR4cmVJWnRjRDN1TkJVZmlFd3pWalhOUW1EQTNqc3B1RXdwMnJZZ0xyVEFk?=
 =?utf-8?B?MmhSSWVwSyttOWE3U3JOZ3lrSEE2MEtxOXBOc2svQ1BsbU1hSnllQlVnVGxv?=
 =?utf-8?B?QVB6ajVIdXl3RjBjejdkeUYvUVlQdDZYNVZ6OHQwZzUxelBNbzBob3ZqUzRE?=
 =?utf-8?B?dS9jeGl0dzZ2MjI0d2srZEsrYzJyeGxOam44V0FvTm9waExHQ3hnK0FyMGZP?=
 =?utf-8?B?VGQyZE9VdDgxaFRqTUZhamtvSnkzb280UkI3WkhEeUpHUWYyNXVBZ1JmQk5l?=
 =?utf-8?B?WE8xdEV5T0JsajFtbzY1SktGZmZsZVg0cVZwUUh3MTdpQzRMMmowb0VnU0Vx?=
 =?utf-8?B?c1hld1hya3BKRkMxQXovMDYzalBJeE5GVTBrb1FQVGJWVEhmb0N6ME1NUXl2?=
 =?utf-8?B?SmN2Z2c5dWZYelZ4R1lCeEdSeElBMzlkaWtrQzhnbWVGbElNV0wzRFdKK3dh?=
 =?utf-8?B?djlHM0tZVlNkWDcxZ2JDTUdqazVOS2VwQ1JvU3ExbE9IVzZTMzZmWE0vSHN0?=
 =?utf-8?B?cHJweldwZFlDazR4TE5DNTk5b2E2ZzN2TjNmbHdqbjQxdW9HSmNoeThPU0R4?=
 =?utf-8?B?VUxwQzVRK1Q3SFRXcmJENHhJbmV3dUcvZWFObnVDaVVUazhtc2xMNmEzZzlM?=
 =?utf-8?B?ZUE9PQ==?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ec350b1-fef2-4166-9132-08da62d3fccf
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2022 00:26:24.7460
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: odO0Mhr244qleaYdejJxWL/GH0ZFSPJLrWH8sxFr8U9a4d+ifg+oiSJp0dE4jBrO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB4150
X-Proofpoint-GUID: OQL7oau_AI3W2ay3ai8bIShY6tJ6fNYU
X-Proofpoint-ORIG-GUID: OQL7oau_AI3W2ay3ai8bIShY6tJ6fNYU
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
> Add a selftest that tests the whole workflow for collecting,
> aggregating (flushing), and displaying cgroup hierarchical stats.
> 
> TL;DR:
> - Userspace program creates a cgroup hierarchy and induces memcg reclaim
>    in parts of it.
> - Whenever reclaim happens, vmscan_start and vmscan_end update
>    per-cgroup percpu readings, and tell rstat which (cgroup, cpu) pairs
>    have updates.
> - When userspace tries to read the stats, vmscan_dump calls rstat to flush
>    the stats, and outputs the stats in text format to userspace (similar
>    to cgroupfs stats).
> - rstat calls vmscan_flush once for every (cgroup, cpu) pair that has
>    updates, vmscan_flush aggregates cpu readings and propagates updates
>    to parents.
> - Userspace program makes sure the stats are aggregated and read
>    correctly.
> 
> Detailed explanation:
> - The test loads tracing bpf programs, vmscan_start and vmscan_end, to
>    measure the latency of cgroup reclaim. Per-cgroup readings are stored in
>    percpu maps for efficiency. When a cgroup reading is updated on a cpu,
>    cgroup_rstat_updated(cgroup, cpu) is called to add the cgroup to the
>    rstat updated tree on that cpu.
> 
> - A cgroup_iter program, vmscan_dump, is loaded and pinned to a file, for
>    each cgroup. Reading this file invokes the program, which calls
>    cgroup_rstat_flush(cgroup) to ask rstat to propagate the updates for all
>    cpus and cgroups that have updates in this cgroup's subtree. Afterwards,
>    the stats are exposed to the user. vmscan_dump returns 1 to terminate
>    iteration early, so that we only expose stats for one cgroup per read.
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
> - Finally, the test creates a cgroup hierarchy and induces memcg reclaim
>    in parts of it, and makes sure that the stats collection, aggregation,
>    and reading workflow works as expected.
> 
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> ---
>   .../prog_tests/cgroup_hierarchical_stats.c    | 362 ++++++++++++++++++
>   .../bpf/progs/cgroup_hierarchical_stats.c     | 235 ++++++++++++
>   2 files changed, 597 insertions(+)
>   create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_hierarchical_stats.c
>   create mode 100644 tools/testing/selftests/bpf/progs/cgroup_hierarchical_stats.c
> 
[...]
> +
> +static unsigned long long get_cgroup_vmscan_delay(unsigned long long cgroup_id,
> +						  const char *file_name)
> +{
> +	char buf[128], path[128];
> +	unsigned long long vmscan = 0, id = 0;
> +	int err;
> +
> +	/* For every cgroup, read the file generated by cgroup_iter */
> +	snprintf(path, 128, "%s%s", BPFFS_VMSCAN, file_name);
> +	err = read_from_file(path, buf, 128);
> +	if (!ASSERT_OK(err, "read cgroup_iter"))
> +		return 0;
> +
> +	/* Check the output file formatting */
> +	ASSERT_EQ(sscanf(buf, "cg_id: %llu, total_vmscan_delay: %llu\n",
> +			 &id, &vmscan), 2, "output format");
> +
> +	/* Check that the cgroup_id is displayed correctly */
> +	ASSERT_EQ(id, cgroup_id, "cgroup_id");
> +	/* Check that the vmscan reading is non-zero */
> +	ASSERT_GT(vmscan, 0, "vmscan_reading");
> +	return vmscan;
> +}
> +
> +static void check_vmscan_stats(void)
> +{
> +	int i;
> +	unsigned long long vmscan_readings[N_CGROUPS], vmscan_root;
> +
> +	for (i = 0; i < N_CGROUPS; i++)
> +		vmscan_readings[i] = get_cgroup_vmscan_delay(cgroups[i].id,
> +							     cgroups[i].name);
> +
> +	/* Read stats for root too */
> +	vmscan_root = get_cgroup_vmscan_delay(CG_ROOT_ID, CG_ROOT_NAME);
> +
> +	/* Check that child1 == child1_1 + child1_2 */
> +	ASSERT_EQ(vmscan_readings[1], vmscan_readings[3] + vmscan_readings[4],
> +		  "child1_vmscan");
> +	/* Check that child2 == child2_1 + child2_2 */
> +	ASSERT_EQ(vmscan_readings[2], vmscan_readings[5] + vmscan_readings[6],
> +		  "child2_vmscan");
> +	/* Check that test == child1 + child2 */
> +	ASSERT_EQ(vmscan_readings[0], vmscan_readings[1] + vmscan_readings[2],
> +		  "test_vmscan");
> +	/* Check that root >= test */
> +	ASSERT_GE(vmscan_root, vmscan_readings[1], "root_vmscan");

I still get a test failure with

get_cgroup_vmscan_delay:PASS:cgroup_id 0 nsec
get_cgroup_vmscan_delay:FAIL:vmscan_reading unexpected vmscan_reading: 
actual 0 <= expected 0
check_vmscan_stats:FAIL:child1_vmscan unexpected child1_vmscan: actual 0 
!= expected -2
check_vmscan_stats:FAIL:child2_vmscan unexpected child2_vmscan: actual 0 
!= expected -2
check_vmscan_stats:PASS:test_vmscan 0 nsec
check_vmscan_stats:PASS:root_vmscan 0 nsec

I added 'dump_stack()' in function try_to_free_mem_cgroup_pages()
and run this test (#33) and didn't get any stacktrace.
But I do get stacktraces due to other operations like
         try_to_free_mem_cgroup_pages+0x1fd [kernel]
         try_to_free_mem_cgroup_pages+0x1fd [kernel]
         memory_reclaim_write+0x88 [kernel]
         cgroup_file_write+0x88 [kernel]
         kernfs_fop_write_iter+0xd0 [kernel]
         vfs_write+0x2c4 [kernel]
         __x64_sys_write+0x60 [kernel]
         do_syscall_64+0x2d [kernel]
         entry_SYSCALL_64_after_hwframe+0x44 [kernel]

If you can show me the stacktrace about how 
try_to_free_mem_cgroup_pages() is triggered in your setup, I can
help debug this problem in my environment.

> +}
> +
> +static int setup_cgroup_iter(struct cgroup_hierarchical_stats *obj, int cgroup_fd,
[...]
