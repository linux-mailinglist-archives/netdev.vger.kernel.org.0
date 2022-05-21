Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 062DB52F734
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 02:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239002AbiEUA7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 20:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232046AbiEUA7s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 20:59:48 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5A9E1AEC67;
        Fri, 20 May 2022 17:59:47 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KMrvoP023540;
        Fri, 20 May 2022 17:59:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=JYu9SA2HKPHuyf2nTdzvIr2BKdjhVNQKHE819MgcQSQ=;
 b=YiDSniia/6BMbsMJXG7fFQw7DifadFkJWqSiozbxMTV1sd/LK/w3UYeKyWyCospP8dYJ
 m2VAj60N+1t2FUcZDbojCDGDlqeXCsD464v5aB+kpeaQU+IOoYHl7kbI7HckXOuehzRa
 KD0IAPuSihCxQeUEJ6lwkXz1J69IWuB9+vs= 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g604bqd90-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 May 2022 17:59:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gv9gIwSO6qx45dE+EVcz/INKigB/pgdcgXhwDv9GdMUfWtHBEy7xZDqUteAZLbZOyrfbSMN0KbnqT0AXwr5bOAsr10TFHubptBXPI2N0LhayT00bJuMuNUIpCYmze0NJitQkUzXUVsu1PyE4xWsfDp/pVtGlOxycWk5V2p5z/IN+1VNC6IUTiSm0sZvjhzJt/dszydcWvTqg8qvzwDaep7qh8xwaGYYKRxmMdvB5URjiQ/DhJ+ez3F34+MXdpFPOw+BbE7Z2J2w1o4mU0to2HE5Hi+OnRb5KoUfrDpyhZAw/4/gd00MxOqKOyDfQY6bgxDnsiAjSpZmlt9P5ywiQpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JYu9SA2HKPHuyf2nTdzvIr2BKdjhVNQKHE819MgcQSQ=;
 b=IJu0HltKJdN3yI3nNni+LoOre9MDIPbw0M+St2rGrYOLRdVIZ14Jr0lodoD6j8qvC1gXRMcbdy90wOe/xSRW2NOmvNKDqLjTdCXqRuhoPGJfHzWyCe/Oqgfugc4DaXaIWgiBF3n+DFwrnNdEIFETQ4RMo1vETI9gMzDSjE3W3S8Es1dcRTJOZmlLcQHlx5JOI/Uv/kaGxfyEN7WFdR0EaL3iepxGpvEq4eSiY6QZQHHYK46N4n6rhhRU+OriB/m2YAwnMRWBsGfxlIlswy3Wv85lSyMPlmVPuY9GvMV12xjsc8s1aVtQzLAc3b5dn9VcphJkuBUN5NlPFK24YNRJ7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by PH0PR15MB5088.namprd15.prod.outlook.com (2603:10b6:510:cf::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.19; Sat, 21 May
 2022 00:59:24 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53%7]) with mapi id 15.20.5273.017; Sat, 21 May 2022
 00:59:24 +0000
Message-ID: <5b301151-0a65-df43-3a3a-6d57e10cfc2d@fb.com>
Date:   Fri, 20 May 2022 17:59:21 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH bpf-next v1 3/5] bpf: Introduce cgroup iter
Content-Language: en-US
To:     Tejun Heo <tj@kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Yosry Ahmed <yosryahmed@google.com>, Hao Luo <haoluo@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Michal Hocko <mhocko@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        David Rientjes <rientjes@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220520012133.1217211-4-yosryahmed@google.com>
 <YodGI73xq8aIBrNM@slm.duckdns.org>
 <CAJD7tkbvMcMWESMcWi6TtdCKLr6keBNGgZTnqcHZvBrPa1qWPw@mail.gmail.com>
 <YodNLpxut+Zddnre@slm.duckdns.org>
 <73fd9853-5dab-8b59-24a0-74c0a6cae88e@fb.com>
 <YofFli6UCX4J5YnU@slm.duckdns.org>
 <CA+khW7gjWVKrwCgDD-4ZdCf5CMcA4-YL0bLm6aWM74+qNQ4c0A@mail.gmail.com>
 <CAJD7tkaJQjfSy+YARFRkqQ8m7OGJHO9v91mSk-cFeo9Z5UVJKg@mail.gmail.com>
 <20220520221919.jnqgv52k4ajlgzcl@MBP-98dd607d3435.dhcp.thefacebook.com>
 <Yogc0Kb5ZVDaQ0oU@slm.duckdns.org>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <Yogc0Kb5ZVDaQ0oU@slm.duckdns.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0169.namprd03.prod.outlook.com
 (2603:10b6:a03:338::24) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2f6e1fbd-42ff-4833-f353-08da3ac52597
X-MS-TrafficTypeDiagnostic: PH0PR15MB5088:EE_
X-Microsoft-Antispam-PRVS: <PH0PR15MB5088243CB4286E527A31144AD3D29@PH0PR15MB5088.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SiGSDI7YreFKZv6ucwESi4Q2lYBc8gT7xJNEo3QoZe6pSxhISj9EcvenJqb7Ii1DYGQeJ9VAnzgnNzZzYJOkKEK1hL5ZquNJWqtzFcnKYy3q0yjajcV5xtdMFovDqATGAwb7R74gtb9R8rbk2ON19TTS3i/RFA3N5hmUCIaBh26IzEhFU8O+XaXZXG8eAPqF6OGL7ijEyju0hrZTcJstbVFNSqleU0/MtbQrMbgs9RNFAj/zG8yeoWbOjWGjJJpVYta6su/koFwj427i0ZJ8RgnNdRHzGRkrdlPNakcLPUr43m5ySr8Rdf3/gXr63PEuAMiJK5s+AMJ3C3/uUn8GGHJbhBDryNOZgzuHU/n8bipy2HlHdGYDgwAezUkEo6XUqK6hpMeYuBVLZ/fi8hLtcbPZZA2LSh1YbUCIqz/+rfNraYUW5hs9eKF6WSH4VdP+s91eR4EB/WBwxh0UV1XZavCwSixkvGKoCN2OHVym4kEZ2h+BOYbqfmcpBVltAnjcGs/1UI2AaYruHYTnbuLql2i7lsIDlaKheL8dIc4yJ4zyLVhlwk2L2Htoj2tx6ops53Y4sPPrTeH4CdxIUuUYtDSxUpADXtQwlQY78Kxe6+mieNQP/VMYNdJuG3er2wC2sUUPaLl5Lp/V7w+sRnbKxElm0pabD9qS0Dtw+2k2tu5fGeZcZ8bDSlMOlydh3f08ZDhbx4vAlVe9Ip6ZaN9IDLE+T3IsdIeVXoHgUxeAy+Px0eg2zqujuNayq/d3am8o
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(86362001)(83380400001)(8676002)(2616005)(54906003)(186003)(110136005)(36756003)(8936002)(31696002)(4744005)(5660300002)(6666004)(508600001)(7416002)(6486002)(66556008)(66476007)(66946007)(31686004)(6512007)(6506007)(53546011)(52116002)(38100700002)(4326008)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N3hvRnNkUDhHRVpXMjdnQi95YkJzUFBiWVluL29UbWw5clFxL25La0lEQWpB?=
 =?utf-8?B?cVBSZ1lncHdGRS9pU3BmNVp0NG4wLzBDWGJDU3hLb3Y3TjdvN3hnYXJKTTVy?=
 =?utf-8?B?bmRURDZrVDVkWmJjS1NwRkFIcVZFZDhRd2lDMWFwTFhpcGFmVENVQk1Pczd4?=
 =?utf-8?B?VFlSTUdLQ1JEb3pyZVdudlBCQ1JQSDRvdVN2bEY0dXRBbytsWERWbmE5ZXlH?=
 =?utf-8?B?VVNEQ2h2eGdaTmt1eTNzNkczSkxyaC9DNzJTaVRFN3grODNUMDFMNEo4OUw3?=
 =?utf-8?B?K29kZ2l5K3JLLzRuczlGYnRTODdzNHU5UDhvYmdsZXFsNTBuZXFKWE9uRmx4?=
 =?utf-8?B?cmNiLzFhQzU0Nm94Y3pIZExSTHR2YmswZVNxUWI1SnZFMXB6NC9NelFSdFAw?=
 =?utf-8?B?QkgwR2JZeGdqQ0Z5YndrdHladVZVZVhSZXdIK2JpZkJwT2FwSG0wcjVxNGdC?=
 =?utf-8?B?ZkdHbWRrRXZiaC9wdFZ0ZnBaMXFlUFRCK0xDSzhKL3BuTmhLZE5RMDFrM3BF?=
 =?utf-8?B?NitNcXgzbGk2NzJYVUxOYmVHWmF0WVpTSkFtT1pCdWlxY0swS0dZKzZobGh2?=
 =?utf-8?B?U3hyejU2MXJ4WEk3czNXdjYzYzBzQkJkTm0vQXlHMXdSM3FOQnpKZWxPUUFB?=
 =?utf-8?B?cWduWDdvRENNTWZMM2kxZFVKOXpwOGNoZDRPZTVqM0VXOWl2YW9xT2RhQWJ5?=
 =?utf-8?B?ZyttMUN3SlNLc0hJallLSjBVZjdaV3Y4NGtpeTBSWFd2T1hpQnVuZnJGT0JS?=
 =?utf-8?B?N2QyRURCVnhBWTVQaGVXNnlKRVU2bVFDTlh0d1ZzZGNwdUdaM05tK29aYWx2?=
 =?utf-8?B?K2VqQU5ydmh4ekt1RE1RR0huUmxCem1ENTYzNVpVNExTNkxHME9WQWxoUE1Y?=
 =?utf-8?B?UytHSm9FbStwZktiQlNJd2c5T2pKMXRmeHJ1TG5SVkJOS2FiYlhMclNvb29W?=
 =?utf-8?B?MUdSUG9UblpsSG9kU0xLYWRQYmsyZ0UvWXVWcEd5azVXNEhYVG5DQzUrb1Ny?=
 =?utf-8?B?MkdqN0ZtdXN1Z1VvMHFlNjZUcytDckhOZ2F5ZitDcmZtWWpuUTEySURTSjhr?=
 =?utf-8?B?ZXpzTUZ0cHBKOG82YWpxcUFTdTZFSG5SNUdsRE54NHRpemE4STFJZ1UrMTJr?=
 =?utf-8?B?eExSaXFjOXgzZGxGNnlIQXR0ckhFVld0NGp2RjloTHowYVh4OXd4emJNTkt0?=
 =?utf-8?B?amFJU3VDbHVkditCeDBDdS9VVjFDemkzUHQrOFpqaWxUZDBwc01qWjJVQ2hV?=
 =?utf-8?B?c28zTjRhZzBaa05mRWxXQ0xqOVNCTmRJNzFwTzBxVTBrVHZJNkN1NGtYaVlD?=
 =?utf-8?B?eTJHb0p2b01IVjdkeU1TeXE2dHpLU1RGS2c3cWV3dEVZWjZwbmk5dkdKRkRV?=
 =?utf-8?B?TVByTnBRV2Z6VE1hWmtES25SWDJnRUFkd1F4cThFSTFuNmlBRVhGY0gzT2lQ?=
 =?utf-8?B?ejByT1I3d3RtR2pFYmYvdEZJK0xUb2lQSERMandFZnZXNVBwTW12Wmc1NjFS?=
 =?utf-8?B?SGZ4N01DYTlpbU43UGxHRXp1WjBkNjNLdElCMUE0NEh2aEM2eEp0MUVpZmhS?=
 =?utf-8?B?MzBaOG44V1p3Y08vT1Bsdkw3UUlTeGNObnlFREozdXNNVk54UVBwMXcwclJm?=
 =?utf-8?B?cjlvMmswaFhvRG5qc2NTb09NT3JuUjNndlZrSjhZWGkyZjhTWnlIQ0dMZ0lF?=
 =?utf-8?B?dk9oakg4WUFWS2JwT0N4S0RVRXRMclhKSWRveWNOWTJsUXZpUDBUM2R4ZFNt?=
 =?utf-8?B?WXZvMURzaGlBRGU3NDFsVk5tb1JaTFN4cmJxUlBjVUR6UzJieFk5VGp2M3VJ?=
 =?utf-8?B?dG9lc1BHQVFFWFJMa1NnZ1BTZnVBOUMvVkc2ZDcrMzNlMmw1OXRTS2VTemJo?=
 =?utf-8?B?Z2VoMXFxUDFKQWZWdWpJY1hFczFrQUQ0ZVBLbFRZcE1vLzY2bUdhNmhTcGRZ?=
 =?utf-8?B?eUlSS0x3REUrV01FUE4zS3FRM1ByQ0lKV3lldUFvdFZjaTU1YkZQL25HMUJV?=
 =?utf-8?B?MHFjT25yOE1rUDNuZkhmVEZucU9hTUJWdFM1RENsZldNWTNQQmtCYlFtM2w4?=
 =?utf-8?B?cm4yMEFqK3ViTjVQYlZWTlJjRElKYXNXR3RiWTlmNEdoN3NwT2N1dHAyeDVC?=
 =?utf-8?B?WGpZTENWek01RWFQOHVqY1VscVlrcExFRGNJVmp6ZEhhaUt2VDdXcDRRZHVv?=
 =?utf-8?B?UDlQTVVYdUJFMllGcWlkSStyNFVINFYvLzMzSEVmWmp4WXRFczJiYzVKMnAr?=
 =?utf-8?B?OWF1V05La2N2enh5VlV1ZjNuYVF0anl5bHF3eXVvT1JwQVFLRWpxa0FQNUxL?=
 =?utf-8?B?YTVER3JGZnZldWlIYjlMa002aUo5eHpYaG1NWVN4akpMcFBTSVVkNnVOeStr?=
 =?utf-8?Q?51oedFFhJWdulCOA=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f6e1fbd-42ff-4833-f353-08da3ac52597
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2022 00:59:24.1748
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ekgVicsSRuYtXDGUh0ZquF0BUVv1h1nnX/XLC7fxijhA9p03J/q+NUg1yu7jrpM2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB5088
X-Proofpoint-ORIG-GUID: 8XAPXlP6toqw8ZeDjxf-zQ4ZKEZQJ03r
X-Proofpoint-GUID: 8XAPXlP6toqw8ZeDjxf-zQ4ZKEZQJ03r
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-20_08,2022-05-20_02,2022-02-23_01
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



On 5/20/22 3:57 PM, Tejun Heo wrote:
> Hello,
> 
> On Fri, May 20, 2022 at 03:19:19PM -0700, Alexei Starovoitov wrote:
>> We have bpf_map iterator that walks all bpf maps.
>> When map iterator is parametrized with map_fd the iterator walks
>> all elements of that map.
>> cgroup iterator should have similar semantics.
>> When non-parameterized it will walk all cgroups and their descendent
>> depth first way. I believe that's what Yonghong is proposing.
>> When parametrized it will start from that particular cgroup and
>> walk all descendant of that cgroup only.
>> The bpf prog can stop the iteration right away with ret 1.
>> Maybe we can add two parameters. One -> cgroup_fd to use and another ->
>> the order of iteration css_for_each_descendant_pre vs _post.
>> wdyt?
> 
> Sounds perfectly reasonable to me.

This works for me too. Thanks!

> 
> Thanks.
> 
