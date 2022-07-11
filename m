Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0755356D24C
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 02:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbiGKAvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 20:51:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiGKAvu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 20:51:50 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8360CEE21;
        Sun, 10 Jul 2022 17:51:49 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26AJZVnn000309;
        Sun, 10 Jul 2022 17:51:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=9L+DcFxkCiQxAE8oBgkRapLUaE/ooS5kS9KF1HfYCFY=;
 b=N0W26MaaAsgJjLIZInxLbcDJgdxzkOWjLVCDoSzkr3cgi1SzlT9qLDqgWrA7wei7D5jR
 s9b64+bKCdNJxY8PfKzAdez7L7qkCuxRQ4M1tEsbLn3hSjUOT7yI3n6sCWYRfCXhPYsi
 l50P5BukipFqY0cHmqMhPYwgZieegClW4JI= 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h776xe4pw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 10 Jul 2022 17:51:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MJ/7b3M0TEOfUJPm6AhDu5xYdpuU2u3SlZbD9fVhU/sNnh+ULQ11qGhF0EO5GNur7H8J+6onvwD2Gj6rQ+k8voBZISHrSAVYSpC3HjU+1F28tEkMYgVsz5XyPkfqLyQB68FsszDVXAg2p3A1SC+RNNOIIYYQ+caPLxaCjkweYrUrviknq59NfBOh9yiu/cGB1AmPSmOY63dWpRIuy7gdMyMbHwRZQmrRGa+qiVG0UySff1ilO7v9JJHKY/0/EFk1vijmLkfRK0pAU2hMJ6wMoMdUnZtiRFebuZZpMFwHQj+/kRDQymwSHAkl5jKJJsNmG94Fq/+rZz1PPorrQfF4Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9L+DcFxkCiQxAE8oBgkRapLUaE/ooS5kS9KF1HfYCFY=;
 b=AXSJ4t+dk1WEjCoz9VzxnFUJcsvCwblINFMVwtyfZaMWc/wj5V7byoERdS7fKQbVhLKyJKfYgUSQZmqWaOO4nymxa6Va2NEpmIkiENc1ISc3wn35RXiZJ9SVU63tvAOtg8NNEZhwhGQfASWAVnNj4VcVKsCd1tfxy8pGhX0fmp1yhK4SJc12yhLrNhSmGZxhCuVViKMPnSbNtLNQjExfnaFq87wdwMzWmIUDAqzXAGMxR7agc+fpEMDqWRRPnOppK0IU+S4E1duX4no6u90wTzqLJ2uOnNvEc8O5yskZkUvcXsdmCTLjvEAQ8Y2uOugq2fXGg1oERi3L5YeJva/yoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by MW5PR15MB5268.namprd15.prod.outlook.com (2603:10b6:303:198::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20; Mon, 11 Jul
 2022 00:51:25 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23%6]) with mapi id 15.20.5417.026; Mon, 11 Jul 2022
 00:51:25 +0000
Message-ID: <9c6a0ba3-2730-eb56-0f96-e5d236e46660@fb.com>
Date:   Sun, 10 Jul 2022 17:51:22 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH bpf-next v3 8/8] bpf: add a selftest for cgroup
 hierarchical stats collection
Content-Language: en-US
From:   Yonghong Song <yhs@fb.com>
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
 <b4936952-2fe7-656c-2d0d-69044265392a@fb.com>
In-Reply-To: <b4936952-2fe7-656c-2d0d-69044265392a@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ClientProxiedBy: SJ0PR13CA0192.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::17) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6ec6224f-d70d-4341-53ea-08da62d77b66
X-MS-TrafficTypeDiagnostic: MW5PR15MB5268:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JwgUsj0rFJi97p6YjVIHlvP8IDsOuH08ccimVGXmeBNZ862lxgRUopk8tLXk4Tqvmrk/Gl+dhsubd9fksYfn0ev6nlq38WqCETK++rXTP3k1DY08NckzslH1FXyk5HZx40r+NFN9AchtDa+JPVUdM0xDCDerBkITtcUUYZdr0c7KbfljzIP1m51SV2hkMrXr9IyRXlICmPMb0zXhMgR4FW0SMZBlAYmyD0noziSn0C9qlqM27E9yfQNjQfHKzuIizt1lfTkw4+fjCA/8r6nz2Yb4ELVV9JFOc/tfqXCngqEiFd014X8MT4ZYIkojsp4JEqTMrIsaUBT0ghI9XjrqxPaZ4oxTAI79krNeX4P9IzkUMMg0Pt0XV1+wDwriiQ7fVsT62I+Adg9I5pFAA7dPii9dOQ9LMlAVVfiuxzmZi6q1+KOCLD6B77rI6Uc9EPmIFDHtxh3QAcI7yogFjW5cCXjE/5JO3+Gn7aMDu8m3c+D+7fts9FpY7OV83ngOuLW59vf8l16+8f4ZucSWutNuxhdM+/ZM80mbhoXA063OgIiYsTBS9kTrXb0s4UhzjKTULgfYNVQ0vFyjAwW0RSrGEYXGN4MN/d9J9w992x6oRbv+/N1Ls9CUrccNQyF7Z0avsbOvzBGcH0maK9wJCPRH+UqrTR4c1x2BgK6/MwFsEFbQjgMyhzgwdhw92a4Xi6n3kybc0fGBKo359G9hZy+2e/BR58xS4ZT/W7nmZw+YQiOmYHLxkCF8pdiCHYcFTNwl4GweS14VQ9PYvqtYLeGNMW4czmTbkO+nvmE903gQOeWaqARwZSMFuzY4qMWqVMXymicHhyMapBcv1V752PxU2U+PEz+ruvYAc3LDlJVzSYKgbg0ZOAXziZx25RBvP/gJ1gVfs3nXneJZw9UldiC2ndw72MJqfno5oQacDkJ3QDs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(39860400002)(346002)(366004)(396003)(66556008)(8936002)(4326008)(7416002)(31686004)(5660300002)(6512007)(6486002)(110136005)(54906003)(316002)(86362001)(66476007)(2616005)(6666004)(41300700001)(8676002)(6506007)(478600001)(53546011)(966005)(66946007)(31696002)(2906002)(36756003)(83380400001)(186003)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bUJnby84cjRBU1Z0UitBTm1WWmhKOHB0SVBDRm5haDl0Qk9nQXM1eDgybDdi?=
 =?utf-8?B?L2FVcWtZOVhuSkoySEZNQ1d1S2dWL3FicUV2RzF1VTFyQW1EcVJaTnFqUFZl?=
 =?utf-8?B?U2V0YXoxV3ZIRWQxRW1ORmxTb2hhelg1eFVvT2prM1R1VEhSVVB4N1RGUUJu?=
 =?utf-8?B?RHhSb1JFUjFjTUVMa2hoNG1JQWhoQkRmSXVHMTFsbUV0b0p5UXkrdFZ4VzJM?=
 =?utf-8?B?MExjZEdjTjQ3UTljS2toVGtrNUxTTFAzVlpiTWJha05nSjMzb0pzYlljQ2Vn?=
 =?utf-8?B?QzFMSGNhTDB0YkNHajVjT2VGQ3dsK1AvUEJtK01OOHVScjN2b2ZaRkRWbDda?=
 =?utf-8?B?U2plTWcyWEtBaFdtSjZlTUh6aGNWUHlveS9KWEE1R2JqUlpqNnFKSWM4LzNE?=
 =?utf-8?B?Rm1nYUc2c2doRkJTLzlGY0lMc1RqbnU3OXVPWHMxcjdRd3REc3JCRkRCeVdY?=
 =?utf-8?B?MFFlbHhxVmFNMzFTYUVBVjJKdEFBZzREOU82UUlUZFFsaGczc3lFWU04WkJs?=
 =?utf-8?B?a2VKWTBpTEN4R01zQWtOZDh3OGIwbjVRaGxCM09DZGZEL2pGVTJPbC9PdDBn?=
 =?utf-8?B?aWQ4ZXpiV1pEQXlNVjB3WSsyMG45cmNnY0EvNFZqMjRQQjFNK2djNUF5eEFl?=
 =?utf-8?B?aGMvWXBDcmczaXFaSnBkRUpVYVpkZGlFK3R1QlAyWUIweFpOVUhKRFZZM3Av?=
 =?utf-8?B?dU81ZEZNY3JSV2xrd3RuWTRzbDh0azhOWUVsem9IZDFhUkt0OTBCclNjK0Fn?=
 =?utf-8?B?cStMS09JNWxTUExjUUZHL0pLRG92QzNBUUxmcEpkWjh1Y2ZIbGFKcVhjZzJz?=
 =?utf-8?B?TTd2QkJhdFRNL012ZnZOYkdiTTdOSks5UllGTGo3L1RJaXJDdm5UVUlKMHpi?=
 =?utf-8?B?Yk9yakUvZzdidDNNZkkza2FYVFdyUmY4K2UzNmltQjU5ZE0vcXJoSjBKUzVy?=
 =?utf-8?B?RzZ0Q3VMZzFSTHJzaXQ5RHF4Z3YyN0YzS1BPYTlrOHZuYXgvcnBXbDNTRDhJ?=
 =?utf-8?B?QzBiRHhpRGp4N0U4RDNVYUpMb0lmZGVRNzdWdWZpTlR4OW5veEZadllUOTV2?=
 =?utf-8?B?SlR4Nm1ndHRvRDlZekptN01PYURRU2VHZmk1ZUV0RFhOcnFqVitJTkluVEEz?=
 =?utf-8?B?RlQvcGtram5uZ2oxQ2tiWlBCWEpkS1Zza1lJMFpMb2ZXaEVLT0VkQVVOVzVo?=
 =?utf-8?B?RG42L1ZEcXh2bkFua3RxUlZaaFhXMGg5emczVjN3alZqeHZMMWY2enpnY0xL?=
 =?utf-8?B?UkhiRzhpSUlrb0ZhRUY1ZVoxUzNZeTUvL1BhSERLRExPMWh2TGgwWlRRRyt2?=
 =?utf-8?B?L1c5ZU40TnNMNDdkWUNaU1ZpRjdDU3lWNzlIVHVmQngwZTIyNE1hT3l2UkpL?=
 =?utf-8?B?SkRnREt5WVJScEtib0hmL2t2U0w0UDh2dEFPdm5ZMDdGWFdzbzRwSFIzdkZM?=
 =?utf-8?B?MG5FSzRVTmhDUkNQSy9IR1hZNlJqSXk1T3FHT3FDWlN0di9wWjVSRmhDZTIy?=
 =?utf-8?B?OUR2ZlZ6U3BsN3Jra0FGVUVkWTlBTXcwWlZ1STdBMktuZi9IMGxERU5CZmlR?=
 =?utf-8?B?S0xUTTh5ckM5SW1SRVZRdDIwelBxdWxDN1A2clUrVUtQSUFyN2NGK1BiK28r?=
 =?utf-8?B?MjJEZkEybThXdS9VTUdCbXlsdTYzZXAyTVRSZXVXT1lLVVVXeko1YzFRczk1?=
 =?utf-8?B?b01EQ3B5K3RsbVZFMFRVOXBST0ZRVEdock1Nd3pCV21wSFp2WmtHeUttWGsx?=
 =?utf-8?B?eGpOTUlpRzBWa0FSTkEvYkJHakdTS3lxbUEwY2ZZRVplTmpYZ2lPOW9rK2FJ?=
 =?utf-8?B?RUJKOGNHUXlGTmhSTWk3eVo1aHMxR2ZicFdIM1ROWDRCd205aUhlQ3BxS1Ir?=
 =?utf-8?B?d3ZSbEM4U0dNTzAvVlNtQVZ4b3J5UjFYc2RSc2Q4OFhwVXBzN3lncjIwVmc0?=
 =?utf-8?B?a2I5MWlhM2xYTHVmS2dEWm1XK3p6RHBwTDl2VlM2RU9nbkg4QU14bFNqN1J5?=
 =?utf-8?B?bVhheDFVeFlZMVZZQzBOZjhvbUdsMUpqNWpJSWZ3dTQvSms4b0F3WnlhMDY0?=
 =?utf-8?B?Zmx5MVA5MitZbXVzdGlwWnRoUlFFc0kvN09Gdk5GRWdPMFBER2pyNHk3MytO?=
 =?utf-8?Q?mQZr6mI19IqdvINe6FKbCjo9y?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ec6224f-d70d-4341-53ea-08da62d77b66
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2022 00:51:25.5390
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IY3vvKIbeaoD+C06utG3Z/jJNaW7wYL1ZiByKyUlRBv+AtHI1U4cUaje0BUYSIyy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR15MB5268
X-Proofpoint-GUID: 7iUa4rr-gOspe4wAglifvKX_etckiWf0
X-Proofpoint-ORIG-GUID: 7iUa4rr-gOspe4wAglifvKX_etckiWf0
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
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



On 7/10/22 5:26 PM, Yonghong Song wrote:
> 
> 
> On 7/8/22 5:04 PM, Yosry Ahmed wrote:
>> Add a selftest that tests the whole workflow for collecting,
>> aggregating (flushing), and displaying cgroup hierarchical stats.
>>
>> TL;DR:
>> - Userspace program creates a cgroup hierarchy and induces memcg reclaim
>>    in parts of it.
>> - Whenever reclaim happens, vmscan_start and vmscan_end update
>>    per-cgroup percpu readings, and tell rstat which (cgroup, cpu) pairs
>>    have updates.
>> - When userspace tries to read the stats, vmscan_dump calls rstat to 
>> flush
>>    the stats, and outputs the stats in text format to userspace (similar
>>    to cgroupfs stats).
>> - rstat calls vmscan_flush once for every (cgroup, cpu) pair that has
>>    updates, vmscan_flush aggregates cpu readings and propagates updates
>>    to parents.
>> - Userspace program makes sure the stats are aggregated and read
>>    correctly.
>>
>> Detailed explanation:
>> - The test loads tracing bpf programs, vmscan_start and vmscan_end, to
>>    measure the latency of cgroup reclaim. Per-cgroup readings are 
>> stored in
>>    percpu maps for efficiency. When a cgroup reading is updated on a cpu,
>>    cgroup_rstat_updated(cgroup, cpu) is called to add the cgroup to the
>>    rstat updated tree on that cpu.
>>
>> - A cgroup_iter program, vmscan_dump, is loaded and pinned to a file, for
>>    each cgroup. Reading this file invokes the program, which calls
>>    cgroup_rstat_flush(cgroup) to ask rstat to propagate the updates 
>> for all
>>    cpus and cgroups that have updates in this cgroup's subtree. 
>> Afterwards,
>>    the stats are exposed to the user. vmscan_dump returns 1 to terminate
>>    iteration early, so that we only expose stats for one cgroup per read.
>>
>> - An ftrace program, vmscan_flush, is also loaded and attached to
>>    bpf_rstat_flush. When rstat flushing is ongoing, vmscan_flush is 
>> invoked
>>    once for each (cgroup, cpu) pair that has updates. cgroups are popped
>>    from the rstat tree in a bottom-up fashion, so calls will always be
>>    made for cgroups that have updates before their parents. The program
>>    aggregates percpu readings to a total per-cgroup reading, and also
>>    propagates them to the parent cgroup. After rstat flushing is over, 
>> all
>>    cgroups will have correct updated hierarchical readings (including all
>>    cpus and all their descendants).
>>
>> - Finally, the test creates a cgroup hierarchy and induces memcg reclaim
>>    in parts of it, and makes sure that the stats collection, aggregation,
>>    and reading workflow works as expected.
>>
>> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
>> ---
>>   .../prog_tests/cgroup_hierarchical_stats.c    | 362 ++++++++++++++++++
>>   .../bpf/progs/cgroup_hierarchical_stats.c     | 235 ++++++++++++
>>   2 files changed, 597 insertions(+)
>>   create mode 100644 
>> tools/testing/selftests/bpf/prog_tests/cgroup_hierarchical_stats.c
>>   create mode 100644 
>> tools/testing/selftests/bpf/progs/cgroup_hierarchical_stats.c
>>
> [...]
>> +
>> +static unsigned long long get_cgroup_vmscan_delay(unsigned long long 
>> cgroup_id,
>> +                          const char *file_name)
>> +{
>> +    char buf[128], path[128];
>> +    unsigned long long vmscan = 0, id = 0;
>> +    int err;
>> +
>> +    /* For every cgroup, read the file generated by cgroup_iter */
>> +    snprintf(path, 128, "%s%s", BPFFS_VMSCAN, file_name);
>> +    err = read_from_file(path, buf, 128);
>> +    if (!ASSERT_OK(err, "read cgroup_iter"))
>> +        return 0;
>> +
>> +    /* Check the output file formatting */
>> +    ASSERT_EQ(sscanf(buf, "cg_id: %llu, total_vmscan_delay: %llu\n",
>> +             &id, &vmscan), 2, "output format");
>> +
>> +    /* Check that the cgroup_id is displayed correctly */
>> +    ASSERT_EQ(id, cgroup_id, "cgroup_id");
>> +    /* Check that the vmscan reading is non-zero */
>> +    ASSERT_GT(vmscan, 0, "vmscan_reading");
>> +    return vmscan;
>> +}
>> +
>> +static void check_vmscan_stats(void)
>> +{
>> +    int i;
>> +    unsigned long long vmscan_readings[N_CGROUPS], vmscan_root;
>> +
>> +    for (i = 0; i < N_CGROUPS; i++)
>> +        vmscan_readings[i] = get_cgroup_vmscan_delay(cgroups[i].id,
>> +                                 cgroups[i].name);
>> +
>> +    /* Read stats for root too */
>> +    vmscan_root = get_cgroup_vmscan_delay(CG_ROOT_ID, CG_ROOT_NAME);
>> +
>> +    /* Check that child1 == child1_1 + child1_2 */
>> +    ASSERT_EQ(vmscan_readings[1], vmscan_readings[3] + 
>> vmscan_readings[4],
>> +          "child1_vmscan");
>> +    /* Check that child2 == child2_1 + child2_2 */
>> +    ASSERT_EQ(vmscan_readings[2], vmscan_readings[5] + 
>> vmscan_readings[6],
>> +          "child2_vmscan");
>> +    /* Check that test == child1 + child2 */
>> +    ASSERT_EQ(vmscan_readings[0], vmscan_readings[1] + 
>> vmscan_readings[2],
>> +          "test_vmscan");
>> +    /* Check that root >= test */
>> +    ASSERT_GE(vmscan_root, vmscan_readings[1], "root_vmscan");
> 
> I still get a test failure with
> 
> get_cgroup_vmscan_delay:PASS:cgroup_id 0 nsec
> get_cgroup_vmscan_delay:FAIL:vmscan_reading unexpected vmscan_reading: 
> actual 0 <= expected 0
> check_vmscan_stats:FAIL:child1_vmscan unexpected child1_vmscan: actual 0 
> != expected -2
> check_vmscan_stats:FAIL:child2_vmscan unexpected child2_vmscan: actual 0 
> != expected -2
> check_vmscan_stats:PASS:test_vmscan 0 nsec
> check_vmscan_stats:PASS:root_vmscan 0 nsec
> 
> I added 'dump_stack()' in function try_to_free_mem_cgroup_pages()
> and run this test (#33) and didn't get any stacktrace.
> But I do get stacktraces due to other operations like
>          try_to_free_mem_cgroup_pages+0x1fd [kernel]
>          try_to_free_mem_cgroup_pages+0x1fd [kernel]
>          memory_reclaim_write+0x88 [kernel]
>          cgroup_file_write+0x88 [kernel]
>          kernfs_fop_write_iter+0xd0 [kernel]
>          vfs_write+0x2c4 [kernel]
>          __x64_sys_write+0x60 [kernel]
>          do_syscall_64+0x2d [kernel]
>          entry_SYSCALL_64_after_hwframe+0x44 [kernel]
> 
> If you can show me the stacktrace about how 
> try_to_free_mem_cgroup_pages() is triggered in your setup, I can
> help debug this problem in my environment.

BTW, CI also reported the test failure.
https://github.com/kernel-patches/bpf/pull/3284

For example, with gcc built kernel,
https://github.com/kernel-patches/bpf/runs/7272407890?check_suite_focus=true

The error:

   get_cgroup_vmscan_delay:PASS:cgroup_id 0 nsec
   get_cgroup_vmscan_delay:PASS:vmscan_reading 0 nsec
   check_vmscan_stats:FAIL:child1_vmscan unexpected child1_vmscan: 
actual 28390910 != expected 28390909
   check_vmscan_stats:FAIL:child2_vmscan unexpected child2_vmscan: 
actual 0 != expected -2
   check_vmscan_stats:PASS:test_vmscan 0 nsec
   check_vmscan_stats:PASS:root_vmscan 0 nsec

> 
>> +}
>> +
>> +static int setup_cgroup_iter(struct cgroup_hierarchical_stats *obj, 
>> int cgroup_fd,
> [...]
