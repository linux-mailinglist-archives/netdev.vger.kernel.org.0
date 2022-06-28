Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21E0055D329
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245548AbiF1GOk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 02:14:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244457AbiF1GOg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 02:14:36 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 118F1275D2;
        Mon, 27 Jun 2022 23:14:33 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 25RJ1Rmf015465;
        Mon, 27 Jun 2022 23:14:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=zfnxdRO341h3VnUCSodh/HVpvoixRt3FRrWkZO3iH1g=;
 b=jNAXShCfZblaaUt7JrEBDHzMK6O9MmRC+aD+kylUtVjVgymHLzgCmOLZKYtSxa+zQ3ka
 cg/QfqgeE5pckKAQMFUHDFipXi4JD3E5ymkZsq2pe0AVxO0Hj2v4C1DHc8tvHyvp8Iuf
 SDhpWjOtlpJkMT6+IAzwntOejXjnRsA1G8o= 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by m0089730.ppops.net (PPS) with ESMTPS id 3gwwv77w0h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 23:14:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cGDKXfMRX4idS63UVJTtO07RXGEKBYChyZW4AatCY52DoVV1ejK8Rwn8yetHAkOBJtto1D0GYNVmx/pEmrA9qbN64KEffMIr4ybC+zzkF3r4Sx35+MN9wHPsrYH7JkUVKYVTYWKqgxMSkQb8Y+Wa5b3hre1pXVs6orGETge9A/w02UkUO7K4WjOivpIqLrkwvRjPbpNavpwO0vdp85+r6RGUWMAHEUIO71SrYNMBAOFMTVQFqrov8Ier4xitu9TyXPxYwqxOxgGqXrm8M750rSzpxxx3UPrh43O5pc/2zQkvWmFUq/hKwAgdT626EuIrpRVTHz7tLftMiY5sFU9PVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zfnxdRO341h3VnUCSodh/HVpvoixRt3FRrWkZO3iH1g=;
 b=LoxTQQZookg0lK0PsjL/gTbiv1xAVfDXRCWBCFXUNJgLDOy6cHfltV1LRFxUaC7xCubagcy2+G+EGQT1qx7B6p+Xe8uXJzr1uPimdEwHIwv8ttwr/I2l6nr+qFqK1G3/OzF9xh2NDu01sEsWFyfRwGFf+WG5n677wyvsN24I/1iBdPlGfG9POlHSZdOBzoo/DzMGd9KVTnce2SYuguSDoMHypEBEJfnxjtzFzZ+gYIINI0neNJq3rlPMBDk1IcQOKyEuIvHFebxDRFH+mSuLM6luioGSaKimhd7s2+wsIJPd2nGIJb7WNyJgPPXHUAdrtKMnSrzvfRmSihmESSJebQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BYAPR15MB2534.namprd15.prod.outlook.com (2603:10b6:a03:152::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 06:14:12 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23%6]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 06:14:12 +0000
Message-ID: <00df1932-38fe-c6f8-49d0-3a44affb1268@fb.com>
Date:   Mon, 27 Jun 2022 23:14:09 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [PATCH bpf-next v2 8/8] bpf: add a selftest for cgroup
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
        Shuah Khan <shuah@kernel.org>, Michal Hocko <mhocko@kernel.org>
Cc:     Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, cgroups@vger.kernel.org
References: <20220610194435.2268290-1-yosryahmed@google.com>
 <20220610194435.2268290-9-yosryahmed@google.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220610194435.2268290-9-yosryahmed@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ClientProxiedBy: SJ0PR03CA0137.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::22) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ac4e349b-71fc-4eb6-9651-08da58cd6b5f
X-MS-TrafficTypeDiagnostic: BYAPR15MB2534:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rea6ojl1rlil2L+0uDdWhT+hH1V62D4/V5AdbKMIpOzS9lfOXumB6xdmbFQOmHJxGJ3FjeI7X1mCa3IzpIpPSSmvAqGyu9IhEh7sLzkRfpK5EcfBb7/st1Ur3s1FNZ8GQN4GfBi6NNcvC+RxTUHoInHJXpmaGwkc3Hm1d825RUHErArfMQiX28wEpcg1MG+OmlCSha+V6FFFesaFCrRtlNF12X4eusy/IXeUvxX10H5kKAZqCdoh78AS+mz2g2o6tgJsm8BPlLM2/Tv7iEWF3op5AwZYnW9XPGlK+JSZltMGFbxzQ7l4zGjJ+GrQuYk9M2bN8PT73tN1MX3GC7bwYAIKSb5eDxiLI4Dl7cL3NIHXfXG7X2wzVVEouRJB3RQNHwAFul5fYbZRjR3Hqh4KkIM0uxJOimFYbt3ytuT+P8ndwIiPofgpWoOG4smjz3V7g2pPOmRMHQOB0g8A/XLPKii5pwYCoz6iIIrIuaqaDr2ArO7Bh9fAF5Sc4z3cpQ3DCV+ghQvMAXD3UOTtSAVgi8kXTKcQ1zMnZwvht4I2slP7+bmfKu/LW3knzNKK1OY97Y3o0Xc+DyirOPEPuPQbGaA1O91GovQybqDY3b2IKXTTnlwJvwq9/2zlUoRP5IZ9MJTdKznYfMuDs4NnTYvjoHNEx5JfMb4+SIJQw5gl+AKQm/A9jx6SOtnN+gdUOtAKvMBQu+dZXWCJHhzFkSBK16U7shKjT9Qab0IbJ81bP1i5SzpESB/x4hpwsPQXoJjjHWRlROFBlv/YF3sjvaqz6gWxkr01mPa0i5p0PgiPi1VXVQ90r7fYTKt0JnwrFooIeCfse3AmdAlwGUcE15DdN6Uop3SGA0k1tg5aCRFo/5w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(346002)(376002)(366004)(396003)(2906002)(478600001)(83380400001)(2616005)(7416002)(5660300002)(41300700001)(6512007)(53546011)(31696002)(86362001)(921005)(6506007)(36756003)(38100700002)(6486002)(110136005)(30864003)(6666004)(66476007)(31686004)(54906003)(186003)(8936002)(8676002)(316002)(4326008)(66946007)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q2s5RVg3Qm1BWlNVRmdNZzd3NDZ1OHhvVVBYL2lRUUE1UDJWRFByakZ5d0cw?=
 =?utf-8?B?cjVoRHR0bHMvS1NMNU5scFFPU2hBTkV4dWQ3cnc1OHhYdVpjUVNCaVRlQWpC?=
 =?utf-8?B?M1hLUERmUEtUckpZSnVTZVpCN3BzSnF0QjVwTTJBVnhiOUxBVVJQMHMzaVY4?=
 =?utf-8?B?bjJYYVFnS1JiZGVSVGorVnRWZFhrTkExeW1NQys3Q1NmZ2IrT1RJc2lmTzU4?=
 =?utf-8?B?WTY1WS9tVUdoZ3NoY2d3SldBMW9HTWJ4WTYvVHdvTzhqTHZPbVliU1FoZlg2?=
 =?utf-8?B?THBwSXliSlVMZG1WMlgwazkvTnhxamdoZ2dDeDVZWStRNU1NbU9wM1B6Q215?=
 =?utf-8?B?eWE4NHI0anVPTnZ4Nk5ITnJhcjNScGNpSWRsbmt6ditkb0RvL0pZRXBsUklE?=
 =?utf-8?B?V3BWQzVRTE50b3BFaTBCSm9GTkthamRTdEdpOGNJVnFMZmV4RWg4Nk9lcFMy?=
 =?utf-8?B?cXJ0bzNnNjY5UWRqWGdsaGsyWmtiNzY1QVZyOXFFZG93dTZnaEI0VGxwRm51?=
 =?utf-8?B?T2tzWlNBOHJKellRZmxQMldySjVYSUxBak9KcW85V09IcDc0S2cvN1Q3QlBZ?=
 =?utf-8?B?YWlOanRBY0w0STFCRFVhUTQ0aGFTZXZmQTgzcU1mLzNQbE0yalJyYm9KZGlI?=
 =?utf-8?B?ZUJBa29tNkk2ZVVMYU1mSnVOY0NSL0ZSaExRRUFKTnlMeitFbGo3NlBDK21x?=
 =?utf-8?B?RGYwV0I2cGRQRGpMUFIyaWU2UEZUUjY2b2Y1OW9PZG9kd2ZtYUw0QmhVMFM2?=
 =?utf-8?B?ZlgzYkc3eEpielMrV25jekdmTllXWXM4Rk5rVWl5NnF5cUFxaGxBZDNiUk15?=
 =?utf-8?B?eS94SDcvUmhUQ0pEd01neU05OXd4RnZ0eHoyZWdMZ0FxQS9vVTZTbFZSUHoy?=
 =?utf-8?B?VTlBTnZTQldvT0dmRnNxYVZxWXVHUWhHWktBRkFjUmNWQldyMmhhMndUdnpT?=
 =?utf-8?B?QkMwTS82QWgzcWFSRWFnRE1uVzRCYXlLQ21pbC9TS2lYRHVHdUFGQ0RyRlZy?=
 =?utf-8?B?b3Evcm1hMW1YcHMyNVFTUmJpclRIem0xNENjdjl5UWxuMmVib245anRmeWxD?=
 =?utf-8?B?TjNHY3hzR3pHWDVjakZPbDRiQmkwVVRPaDdkYmptYktaWlZBWkdTVTA4VzhR?=
 =?utf-8?B?L1o3M1dLSUU3NHl4dngxaVJpK0VUNEtyb3k5dUpVckxadldFRHlkNnh2Z0VX?=
 =?utf-8?B?Qm9tTHZMV1pyL2pxZWFkUFlLbDhXUEhqZzBMbjA2Vk14VllaKzc2Qk9jeFho?=
 =?utf-8?B?WHdmaWdEU3RIRzBSRll3cVFGa2QvOVJ1T1p5bjd0Wno2NFJlMEF4VmluMXNu?=
 =?utf-8?B?elZSOUp1S0pIRENYTWpGaU4rdlA2Yi9JbHFkNlp1NVZoVDJtbEdwV2R2cERI?=
 =?utf-8?B?MU1sUkQzR2J4dVRxSUtuaktCMDF0MVlEdmhqNHlBaXU2T2VhdkVPRTlNM1dz?=
 =?utf-8?B?Y2I1OEk2azZ0THZHdUEzbXBZK2Q5RkpEOHRMSi9XMnFGN05ISG5SQkpvdFBX?=
 =?utf-8?B?dEEvRFAvZ2xKUSs3U0pTMWdBb29HUEZmdUpESnpEVVF0NVJGQnJCbzFyVW4y?=
 =?utf-8?B?c3BJNStYcFduMTNqNnFVT1NsK2xCMlRQdllDa3FVUDFRVHJPMlRISHRLMk5E?=
 =?utf-8?B?ZDE2T1Q5SkRDUnM3VHpRcUVNbjc0SGZmRlRFaWNZNHVKOEMxRmx2Q1hDcWdu?=
 =?utf-8?B?M1VJMUZpQ3JyS1VRdWtWRnRPeU1USVZ5bUh4RlhDUTFCSGR0NGI0VFVBd3FT?=
 =?utf-8?B?US9tak9QdnJscHNGcE0ydCtQVkFqTUxUemdTOU9NUmY2c1lVckFkV1htOUk1?=
 =?utf-8?B?M0NHRVBuVzRYaWJqMUozcEZnZnlIUUtCSVBLS3hPa2ZKeEZEdVZHNjFWS1VS?=
 =?utf-8?B?WEIvWXFXZ05wZkFHRUFxOVNjaEJtMHJTSzgrL2hSV3dnZGN1elQvazNlNW9a?=
 =?utf-8?B?bDNnaE84UmRtWGhoOUUyeklYVFMrbk5DT0VYTlRxUjNmK2FyUVlDYkFZQ0xW?=
 =?utf-8?B?NnhnYTlWb0ZIZVBBZlVsR3FoejRRNW9oWUR4ZE85bEtMU0k5akJ3U0ExSWdY?=
 =?utf-8?B?dG9hbVY4Ymd4eHRFRzMxeTlNeTgxQTZjN2M2dm1rTGhlS0xDL1hxbjZFTUhk?=
 =?utf-8?B?eVlsQXZGUkFDV3F1NEJNY3JqTGFuRnBFN1l0djUwTEFXR3YwWlcxVkMvd2tl?=
 =?utf-8?B?R2c9PQ==?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac4e349b-71fc-4eb6-9651-08da58cd6b5f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 06:14:12.1187
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: huZsK2+3R/UJSttrgQzjWy/M4uql7SCX0/24Jj3gOWIuWdcdKd/O88qm0AsC6P65
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2534
X-Proofpoint-GUID: UfHyLoc2QW1GIBLmh9NmR-Clggv36JCC
X-Proofpoint-ORIG-GUID: UfHyLoc2QW1GIBLmh9NmR-Clggv36JCC
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
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
> Add a selftest that tests the whole workflow for collecting,
> aggregating (flushing), and displaying cgroup hierarchical stats.
> 
> TL;DR:
> - Whenever reclaim happens, vmscan_start and vmscan_end update
>    per-cgroup percpu readings, and tell rstat which (cgroup, cpu) pairs
>    have updates.
> - When userspace tries to read the stats, vmscan_dump calls rstat to flush
>    the stats, and outputs the stats in text format to userspace (similar
>    to cgroupfs stats).
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
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>

There are a selftest failure with test:

get_cgroup_vmscan_delay:PASS:output format 0 nsec
get_cgroup_vmscan_delay:PASS:cgroup_id 0 nsec
get_cgroup_vmscan_delay:PASS:vmscan_reading 0 nsec
get_cgroup_vmscan_delay:PASS:read cgroup_iter 0 nsec
get_cgroup_vmscan_delay:PASS:output format 0 nsec
get_cgroup_vmscan_delay:PASS:cgroup_id 0 nsec
get_cgroup_vmscan_delay:FAIL:vmscan_reading unexpected vmscan_reading: 
actual 0 <= expected 0
check_vmscan_stats:FAIL:child1_vmscan unexpected child1_vmscan: actual 
781874 != expected 382092
check_vmscan_stats:FAIL:child2_vmscan unexpected child2_vmscan: actual 
-1 != expected -2
check_vmscan_stats:FAIL:test_vmscan unexpected test_vmscan: actual 
781874 != expected 781873
check_vmscan_stats:FAIL:root_vmscan unexpected root_vmscan: actual 0 < 
expected 781874
destroy_progs:PASS:remove cgroup_iter pin 0 nsec
destroy_progs:PASS:remove cgroup_iter pin 0 nsec
destroy_progs:PASS:remove cgroup_iter pin 0 nsec
destroy_progs:PASS:remove cgroup_iter pin 0 nsec
destroy_progs:PASS:remove cgroup_iter pin 0 nsec
destroy_progs:PASS:remove cgroup_iter pin 0 nsec
destroy_progs:PASS:remove cgroup_iter pin 0 nsec
destroy_progs:PASS:remove cgroup_iter root pin 0 nsec
cleanup_bpffs:PASS:rmdir /sys/fs/bpf/vmscan/ 0 nsec
#33      cgroup_hierarchical_stats:FAIL


Also an existing test also failed.

btf_dump_data:PASS:find type id 0 nsec 
 

btf_dump_data:PASS:failed/unexpected type_sz 0 nsec 
 

btf_dump_data:FAIL:ensure expected/actual match unexpected ensure 
expected/actual match: actual '(union bpf_iter_link_info){.map = 
(struct){.map_fd = (__u32)1,},.cgroup '
test_btf_dump_struct_data:PASS:find struct sk_buff 0 nsec 
 

test_btf_dump_struct_data:PASS:unexpected return value dumping sk_buff 0 
nsec 

btf_dump_data:PASS:verify prefix match 0 nsec 
 

btf_dump_data:PASS:find type id 0 nsec 
 

btf_dump_data:PASS:failed to return -E2BIG 0 nsec 
 

btf_dump_data:PASS:ensure expected/actual match 0 nsec 
 

btf_dump_data:PASS:verify prefix match 0 nsec 
 

btf_dump_data:PASS:find type id 0 nsec 
 

btf_dump_data:PASS:failed to return -E2BIG 0 nsec 
 

btf_dump_data:PASS:ensure expected/actual match 0 nsec 
 

#21/14   btf_dump/btf_dump: struct_data:FAIL

please take a look.

> ---
>   .../prog_tests/cgroup_hierarchical_stats.c    | 351 ++++++++++++++++++
>   .../bpf/progs/cgroup_hierarchical_stats.c     | 234 ++++++++++++
>   2 files changed, 585 insertions(+)
>   create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_hierarchical_stats.c
>   create mode 100644 tools/testing/selftests/bpf/progs/cgroup_hierarchical_stats.c
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_hierarchical_stats.c b/tools/testing/selftests/bpf/prog_tests/cgroup_hierarchical_stats.c
> new file mode 100644
> index 0000000000000..b78a4043da49a
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/cgroup_hierarchical_stats.c
> @@ -0,0 +1,351 @@
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
> +#include <test_progs.h>
> +#include <bpf/libbpf.h>
> +#include <bpf/bpf.h>
> +
> +#include "cgroup_helpers.h"
> +#include "cgroup_hierarchical_stats.skel.h"
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
> +#define CGROUP_PATH(p, n) {.path = #p"/"#n, .name = #n}
> +
> +static struct {
> +	const char *path, *name;
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
> +int root_cgroup_fd;
> +bool mounted_bpffs;
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
> +	if (!ASSERT_OK(err && errno != EBUSY, "mount bpffs"))
> +		return err;
> +
> +	/* Create a directory to contain stat files in bpffs */
> +	err = mkdir(BPFFS_VMSCAN, 0755);
> +	ASSERT_OK(err, "mkdir bpffs");
> +	return err;
> +}
> +
> +static void cleanup_bpffs(void)
> +{
> +	/* Remove created directory in bpffs */
> +	ASSERT_OK(rmdir(BPFFS_VMSCAN), "rmdir "BPFFS_VMSCAN);
> +
> +	/* Unmount bpffs, if it wasn't already mounted when we started */
> +	if (mounted_bpffs)
> +		return;
> +	ASSERT_OK(umount(BPFFS_ROOT), "unmount bpffs");
> +}
> +
> +static int setup_cgroups(void)
> +{
> +	int i, fd, err;
> +
> +	err = setup_cgroup_environment();
> +	if (!ASSERT_OK(err, "setup_cgroup_environment"))
> +		return err;
> +
> +	root_cgroup_fd = get_root_cgroup();
> +	if (!ASSERT_GE(root_cgroup_fd, 0, "get_root_cgroup"))
> +		return root_cgroup_fd;
> +
> +	for (i = 0; i < N_CGROUPS; i++) {
> +		fd = create_and_get_cgroup(cgroups[i].path);
> +		if (!ASSERT_GE(fd, 0, "create_and_get_cgroup"))
> +			return fd;
> +
> +		cgroups[i].fd = fd;
> +		cgroups[i].id = get_cgroup_id(cgroups[i].path);
> +
> +		/*
> +		 * Enable memcg controller for the entire hierarchy.
> +		 * Note that stats are collected for all cgroups in a hierarchy
> +		 * with memcg enabled anyway, but are only exposed for cgroups
> +		 * that have memcg enabled.
> +		 */
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
> +	close(root_cgroup_fd);
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
> +static void alloc_anon(size_t size)
> +{
> +	char *buf, *ptr;
> +
> +	buf = malloc(size);
> +	for (ptr = buf; ptr < buf + size; ptr += PAGE_SIZE)
> +		*ptr = 0;
> +	free(buf);
> +}
> +
> +static int induce_vmscan(void)
> +{
> +	char size[128];
> +	int i, err;
> +
> +	/*
> +	 * Set memory.high for test parent cgroup to 1 MB to throttle
> +	 * allocations and invoke reclaim in children.
> +	 */
> +	snprintf(size, 128, "%d", MB(1));
> +	err = write_cgroup_file(cgroups[0].path, "memory.high",	size);
> +	if (!ASSERT_OK(err, "write memory.high"))
> +		return err;
> +	/*
> +	 * In every leaf cgroup, run a memory hog for a few seconds to induce
> +	 * reclaim then kill it.
> +	 */
> +	for (i = N_NON_LEAF_CGROUPS; i < N_CGROUPS; i++) {
> +		pid_t pid = fork();
> +
> +		if (pid == 0) {
> +			/* Join cgroup in the parent process workdir */
> +			join_parent_cgroup(cgroups[i].path);
> +
> +			/* Allocate more memory than memory.high */
> +			alloc_anon(MB(2));
> +			exit(0);
> +		} else {
> +			/* Wait for child to cause reclaim then kill it */
> +			if (!ASSERT_GT(pid, 0, "fork"))
> +				return pid;
> +			sleep(2);
> +			kill(pid, SIGKILL);
> +			waitpid(pid, NULL, 0);
> +		}
> +	}
> +	return 0;
> +}
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
> +}
> +
> +static int setup_cgroup_iter(struct cgroup_hierarchical_stats *obj, int cgroup_fd,
> +			     const char *file_name)
> +{
> +	DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
> +	union bpf_iter_link_info linfo = {};
> +	struct bpf_link *link;
> +	char path[128];
> +	int err;
> +
> +	/*
> +	 * Create an iter link, parameterized by cgroup_fd.
> +	 * We only want to traverse one cgroup, so set the traversal order to
> +	 * "pre", and return 1 from dump_vmscan to stop iteration after the
> +	 * first cgroup.
> +	 */
> +	linfo.cgroup.cgroup_fd = cgroup_fd;
> +	linfo.cgroup.traversal_order = BPF_ITER_CGROUP_PRE;
> +	opts.link_info = &linfo;
> +	opts.link_info_len = sizeof(linfo);
> +	link = bpf_program__attach_iter(obj->progs.dump_vmscan, &opts);
> +	if (!ASSERT_OK_PTR(link, "attach iter"))
> +		return libbpf_get_error(link);
> +
> +	/* Pin the link to a bpffs file */
> +	snprintf(path, 128, "%s%s", BPFFS_VMSCAN, file_name);
> +	err = bpf_link__pin(link, path);
> +	ASSERT_OK(err, "pin cgroup_iter");
> +	return err;
> +}
> +
> +static int setup_progs(struct cgroup_hierarchical_stats **skel)
> +{
> +	int i, err;
> +	struct bpf_link *link;
> +	struct cgroup_hierarchical_stats *obj;
> +
> +	obj = cgroup_hierarchical_stats__open_and_load();
> +	if (!ASSERT_OK_PTR(obj, "open_and_load"))
> +		return libbpf_get_error(obj);
> +
> +	/* Attach cgroup_iter program that will dump the stats to cgroups */
> +	for (i = 0; i < N_CGROUPS; i++) {
> +		err = setup_cgroup_iter(obj, cgroups[i].fd, cgroups[i].name);
> +		if (!ASSERT_OK(err, "setup_cgroup_iter"))
> +			return err;
> +	}
> +	/* Also dump stats for root */
> +	err = setup_cgroup_iter(obj, root_cgroup_fd, CG_ROOT_NAME);
> +	if (!ASSERT_OK(err, "setup_cgroup_iter"))
> +		return err;
> +
> +	/* Attach rstat flusher */
> +	link = bpf_program__attach(obj->progs.vmscan_flush);
> +	if (!ASSERT_OK_PTR(link, "attach rstat"))
> +		return libbpf_get_error(link);
> +
> +	/* Attach tracing programs that will calculate vmscan delays */
> +	link = bpf_program__attach(obj->progs.vmscan_start);
> +	if (!ASSERT_OK_PTR(obj, "attach raw_tracepoint"))
> +		return libbpf_get_error(obj);
> +
> +	link = bpf_program__attach(obj->progs.vmscan_end);
> +	if (!ASSERT_OK_PTR(obj, "attach raw_tracepoint"))
> +		return libbpf_get_error(obj);
> +
> +	*skel = obj;
> +	return 0;
> +}
> +
> +void destroy_progs(struct cgroup_hierarchical_stats *skel)
> +{
> +	char path[128];
> +	int i;
> +
> +	for (i = 0; i < N_CGROUPS; i++) {
> +		/* Delete files in bpffs that cgroup_iters are pinned in */
> +		snprintf(path, 128, "%s%s", BPFFS_VMSCAN,
> +			 cgroups[i].name);
> +		ASSERT_OK(remove(path), "remove cgroup_iter pin");
> +	}
> +
> +	/* Delete root file in bpffs */
> +	snprintf(path, 128, "%s%s", BPFFS_VMSCAN, CG_ROOT_NAME);
> +	ASSERT_OK(remove(path), "remove cgroup_iter root pin");
> +	cgroup_hierarchical_stats__destroy(skel);
> +}
> +
> +void test_cgroup_hierarchical_stats(void)
> +{
> +	struct cgroup_hierarchical_stats *skel = NULL;
> +
> +	if (setup_hierarchy())
> +		goto hierarchy_cleanup;
> +	if (setup_progs(&skel))
> +		goto cleanup;
> +	if (induce_vmscan())
> +		goto cleanup;
> +	check_vmscan_stats();
> +cleanup:
> +	destroy_progs(skel);
> +hierarchy_cleanup:
> +	destroy_hierarchy();
> +}
> diff --git a/tools/testing/selftests/bpf/progs/cgroup_hierarchical_stats.c b/tools/testing/selftests/bpf/progs/cgroup_hierarchical_stats.c
> new file mode 100644
> index 0000000000000..fd2028f1ed70b
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/cgroup_hierarchical_stats.c
> @@ -0,0 +1,234 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Functions to manage eBPF programs attached to cgroup subsystems
> + *
> + * Copyright 2022 Google LLC.
> + */
> +#include "vmlinux.h"
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +
> +char _license[] SEC("license") = "GPL";
> +
> +/*
> + * Start times are stored per-task, not per-cgroup, as multiple tasks in one
> + * cgroup can perform reclain concurrently.
> + */
> +struct {
> +	__uint(type, BPF_MAP_TYPE_TASK_STORAGE);
> +	__uint(map_flags, BPF_F_NO_PREALLOC);
> +	__type(key, int);
> +	__type(value, __u64);
> +} vmscan_start_time SEC(".maps");
> +
> +struct vmscan_percpu {
> +	/* Previous percpu state, to figure out if we have new updates */
> +	__u64 prev;
> +	/* Current percpu state */
> +	__u64 state;
> +};
> +
> +struct vmscan {
> +	/* State propagated through children, pending aggregation */
> +	__u64 pending;
> +	/* Total state, including all cpus and all children */
> +	__u64 state;
> +};
> +
> +struct {
> +	__uint(type, BPF_MAP_TYPE_PERCPU_HASH);
> +	__uint(max_entries, 10);
> +	__type(key, __u64);
> +	__type(value, struct vmscan_percpu);
> +} pcpu_cgroup_vmscan_elapsed SEC(".maps");
> +
> +struct {
> +	__uint(type, BPF_MAP_TYPE_HASH);
> +	__uint(max_entries, 10);
> +	__type(key, __u64);
> +	__type(value, struct vmscan);
> +} cgroup_vmscan_elapsed SEC(".maps");
> +
> +extern void cgroup_rstat_updated(struct cgroup *cgrp, int cpu) __ksym;
> +extern void cgroup_rstat_flush(struct cgroup *cgrp) __ksym;
> +
> +static inline struct cgroup *task_memcg(struct task_struct *task)
> +{
> +	return task->cgroups->subsys[memory_cgrp_id]->cgroup;
> +}
> +
> +static inline uint64_t cgroup_id(struct cgroup *cgrp)
> +{
> +	return cgrp->kn->id;
> +}
> +
> +static inline int create_vmscan_percpu_elem(__u64 cg_id, __u64 state)
> +{
> +	struct vmscan_percpu pcpu_init = {.state = state, .prev = 0};
> +
> +	if (bpf_map_update_elem(&pcpu_cgroup_vmscan_elapsed, &cg_id,
> +				&pcpu_init, BPF_NOEXIST)) {
> +		bpf_printk("failed to create pcpu entry for cgroup %llu\n"
> +			   , cg_id);
> +		return 1;
> +	}
> +	return 0;
> +}
> +
> +static inline int create_vmscan_elem(__u64 cg_id, __u64 state, __u64 pending)
> +{
> +	struct vmscan init = {.state = state, .pending = pending};
> +
> +	if (bpf_map_update_elem(&cgroup_vmscan_elapsed, &cg_id,
> +				&init, BPF_NOEXIST)) {
> +		bpf_printk("failed to create entry for cgroup %llu\n"
> +			   , cg_id);
> +		return 1;
> +	}
> +	return 0;
> +}
> +
> +SEC("tp_btf/mm_vmscan_memcg_reclaim_begin")
> +int BPF_PROG(vmscan_start, struct lruvec *lruvec, struct scan_control *sc)
> +{
> +	struct task_struct *task = bpf_get_current_task_btf();
> +	__u64 *start_time_ptr;
> +
> +	start_time_ptr = bpf_task_storage_get(&vmscan_start_time, task, 0,
> +					  BPF_LOCAL_STORAGE_GET_F_CREATE);
> +	if (!start_time_ptr) {
> +		bpf_printk("error retrieving storage\n");
> +		return 0;
> +	}
> +
> +	*start_time_ptr = bpf_ktime_get_ns();
> +	return 0;
> +}
> +
> +SEC("tp_btf/mm_vmscan_memcg_reclaim_end")
> +int BPF_PROG(vmscan_end, struct lruvec *lruvec, struct scan_control *sc)
> +{
> +	struct vmscan_percpu *pcpu_stat;
> +	struct task_struct *current = bpf_get_current_task_btf();
> +	struct cgroup *cgrp;
> +	__u64 *start_time_ptr;
> +	__u64 current_elapsed, cg_id;
> +	__u64 end_time = bpf_ktime_get_ns();
> +
> +	/*
> +	 * cgrp is the first parent cgroup of current that has memcg enabled in
> +	 * its subtree_control, or NULL if memcg is disabled in the entire tree.
> +	 * In a cgroup hierarchy like this:
> +	 *                               a
> +	 *                              / \
> +	 *                             b   c
> +	 *  If "a" has memcg enabled, while "b" doesn't, then processes in "b"
> +	 *  will accumulate their stats directly to "a". This makes sure that no
> +	 *  stats are lost from processes in leaf cgroups that don't have memcg
> +	 *  enabled, but only exposes stats for cgroups that have memcg enabled.
> +	 */
> +	cgrp = task_memcg(current);
> +	if (!cgrp)
> +		return 0;
> +
> +	cg_id = cgroup_id(cgrp);
> +	start_time_ptr = bpf_task_storage_get(&vmscan_start_time, current, 0,
> +					      BPF_LOCAL_STORAGE_GET_F_CREATE);
> +	if (!start_time_ptr) {
> +		bpf_printk("error retrieving storage local storage\n");
> +		return 0;
> +	}
> +
> +	current_elapsed = end_time - *start_time_ptr;
> +	pcpu_stat = bpf_map_lookup_elem(&pcpu_cgroup_vmscan_elapsed,
> +					&cg_id);
> +	if (pcpu_stat)
> +		__sync_fetch_and_add(&pcpu_stat->state, current_elapsed);
> +	else
> +		create_vmscan_percpu_elem(cg_id, current_elapsed);
> +
> +	cgroup_rstat_updated(cgrp, bpf_get_smp_processor_id());
> +	return 0;
> +}
> +
> +SEC("fentry/bpf_rstat_flush")
> +int BPF_PROG(vmscan_flush, struct cgroup *cgrp, struct cgroup *parent, int cpu)
> +{
> +	struct vmscan_percpu *pcpu_stat;
> +	struct vmscan *total_stat, *parent_stat;
> +	__u64 cg_id = cgroup_id(cgrp);
> +	__u64 parent_cg_id = parent ? cgroup_id(parent) : 0;
> +	__u64 *pcpu_vmscan;
> +	__u64 state;
> +	__u64 delta = 0;
> +
> +	/* Add CPU changes on this level since the last flush */
> +	pcpu_stat = bpf_map_lookup_percpu_elem(&pcpu_cgroup_vmscan_elapsed,
> +					       &cg_id, cpu);
> +	if (pcpu_stat) {
> +		state = pcpu_stat->state;
> +		delta += state - pcpu_stat->prev;
> +		pcpu_stat->prev = state;
> +	}
> +
> +	total_stat = bpf_map_lookup_elem(&cgroup_vmscan_elapsed, &cg_id);
> +	if (!total_stat) {
> +		create_vmscan_elem(cg_id, delta, 0);
> +		goto update_parent;
> +	}
> +
> +	/* Collect pending stats from subtree */
> +	if (total_stat->pending) {
> +		delta += total_stat->pending;
> +		total_stat->pending = 0;
> +	}
> +
> +	/* Propagate changes to this cgroup's total */
> +	total_stat->state += delta;
> +
> +update_parent:
> +	/* Skip if there are no changes to propagate, or no parent */
> +	if (!delta || !parent_cg_id)
> +		return 0;
> +
> +	/* Propagate changes to cgroup's parent */
> +	parent_stat = bpf_map_lookup_elem(&cgroup_vmscan_elapsed,
> +					  &parent_cg_id);
> +	if (parent_stat)
> +		parent_stat->pending += delta;
> +	else
> +		create_vmscan_elem(parent_cg_id, 0, delta);
> +
> +	return 0;
> +}
> +
> +SEC("iter.s/cgroup")
> +int BPF_PROG(dump_vmscan, struct bpf_iter_meta *meta, struct cgroup *cgrp)
> +{
> +	struct seq_file *seq = meta->seq;
> +	struct vmscan *total_stat;
> +	__u64 cg_id = cgroup_id(cgrp);
> +
> +	/* Do nothing for the terminal call */
> +	if (!cgrp)
> +		return 1;
> +
> +	/* Flush the stats to make sure we get the most updated numbers */
> +	cgroup_rstat_flush(cgrp);
> +
> +	total_stat = bpf_map_lookup_elem(&cgroup_vmscan_elapsed, &cg_id);
> +	if (!total_stat) {
> +		bpf_printk("error finding stats for cgroup %llu\n", cg_id);
> +		BPF_SEQ_PRINTF(seq, "cg_id: %llu, total_vmscan_delay: -1\n",
> +			       cg_id);
> +		return 1;
> +	}
> +	BPF_SEQ_PRINTF(seq, "cg_id: %llu, total_vmscan_delay: %llu\n",
> +		       cg_id, total_stat->state);
> +
> +	/*
> +	 * We only dump stats for one cgroup here, so return 1 to stop
> +	 * iteration after the first cgroup.
> +	 */
> +	return 1;
> +}
