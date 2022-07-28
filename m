Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 337F558390D
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 08:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234388AbiG1G4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 02:56:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232715AbiG1G43 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 02:56:29 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E27B2E688;
        Wed, 27 Jul 2022 23:56:27 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26S17uSZ010636;
        Wed, 27 Jul 2022 23:56:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=75HCixyYdb3b6Q4e6sNvQvIRsYzA4zD5zmgZyi+geZI=;
 b=d+BEptjAaRAHzq2bAivJjXq7nvUpp+BMX/CSts7SQCTvkDmqek166LGfLOVVQnrb0kpX
 BgEDL/ehqf+4tiEaPziZQQyMmYtSX1Uivk36BswOkQlvnuBpm9yZjZE1WF00Prj4VlXj
 TEPbyYeNIOqMUHhJxZLiggLtYqbSqVB8svg= 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hk3ck7exm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Jul 2022 23:55:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D+DfxfPM4tlATP2GxogE9k6/ECeJktaL3KAsPtRggsyTzzqdwTZ93nsgsGaI6q/WsYXFXu9gczzm3i3+V93L7Mxq8BI/r2dWsZC6jeMDAxoo4Fy/QMxVPVRUJv1z5M6ilpFzVdt+zEav5lpJVuubDwNC7++tob3FTtMi9cyYXdG2LKUBhPpVHLooq+Qu99EHW+G9MIubCRWKuGCyyCWCp+4aa0WvaHX+3Xkw9txpO/QSSZXaJTuzDOXfEJxN/HURu+4jVb8ijiDoOAoXyWGtXrTomDQGVU1nGfXa39hIgwzxK/iA3YfAZ3s0DOwu3xV9ZcAMmV2RkSJvh0wx9A/KHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=75HCixyYdb3b6Q4e6sNvQvIRsYzA4zD5zmgZyi+geZI=;
 b=imggRBEoBg12nyU+4GW2GB22ecrn43y29OoDK9tK82PNkGeOf+hlmgHJhAU/1X84Wq2uPBM3OTyhtUkE1Y5fy0lCNRaZF8htNWI/FhH0gcUSKnMgd0PfF0Gf9fVB6q4vHC3iiQEF8V+H3TUbAZ10sWqw7nTcPAVAnV3uXrN5LxRcZM531jdQ9VN0t8ztmeWmJCQStZOV0Kuqcr/MkWDj8NnuhH4eoF96iJNuw2yuee22KhY4dSXH4YL85wHCFivcehRzDVoEcE9M/+V/Ika9lMrIfhVykvM4DWBe+06mqPInyETIUCF3CtstRFhj1CDMNU9ed/6J2twQ/XIdBO40Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by DM6PR15MB2252.namprd15.prod.outlook.com (2603:10b6:5:88::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11; Thu, 28 Jul
 2022 06:55:57 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23%6]) with mapi id 15.20.5458.024; Thu, 28 Jul 2022
 06:55:57 +0000
Message-ID: <639f575e-bc8c-46b9-b21b-bd9fbba835c1@fb.com>
Date:   Wed, 27 Jul 2022 23:55:54 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH bpf-next v5 4/8] bpf: Introduce cgroup iter
Content-Language: en-US
To:     Hao Luo <haoluo@google.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     Yosry Ahmed <yosryahmed@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Tejun Heo <tj@kernel.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
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
References: <20220722174829.3422466-1-yosryahmed@google.com>
 <20220722174829.3422466-5-yosryahmed@google.com>
 <CAP01T76p7CCj2i4X7PmZiG3G3-Bfx_ygnO0Eg+DnfwLHQiEPbA@mail.gmail.com>
 <CA+khW7g2kriOb7on0u_UpGpS2A0bftrQowTB0+AJ=S7rpLKaZA@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <CA+khW7g2kriOb7on0u_UpGpS2A0bftrQowTB0+AJ=S7rpLKaZA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0031.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::44) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a147486a-660b-4787-0f38-08da706638f7
X-MS-TrafficTypeDiagnostic: DM6PR15MB2252:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A4shZuOj8d6rUM//S7Y+xySAZAPufYcFtZAWSvoTtJ4bumg2grpvlSnprCPgUaWsF0g22jgj6kHGSDpPqVEH7HU0qrwc4i2AtV7APSmpzOiOgr1k0rrDL+BcmgpcjaWv/QyZm0Z+58wkE8m3XaYTvngiAQkXY4cnwMLJYJSzTBklNrsVCyU3SgSClowFVdA96AnZXydpLd75W7UEc+b35I0VTqe7q+RupNAJqlft/yRb181ImOJ6lfkom2ze7F6ltGBflPKhLd2UHAuuWE0Wz+n7Bv54qZG3KvTZI3oSWLLDuStHTbAAO9VX28cIWwzj+/mnBII8qdo7DDPuMiwd1FddUIVKk8fL2GvTH9OptbRNsquKru42lXF36w0qmDSRmma1XwvxXXYVXhUKSfrK6OFn8AGICzQVbTkTti8B8sgZmKyq8/jn2vrzypXguecp56qmRPm2HdakWO/tyWl4nKAVuuPVhvookqeaD8O8bK5HO+ED/uxK71cEtUAYa1d2wHxF8Pz2Mc03NhriJBLeVMOgcN2x/FtuVAxB04P6mW0h0CQi11ELgwBq43Xehcu+0SAy35vIdwsMMEDy1tTj48XNAKVQKjYX8CguKy9R8BeY27Y9ZLC6rvuY0JNRro1Q2spMgNCkC4mIXdRFXDneXeBZ6Mye8Hwx9Yfdp4V4kFQNePTkPeCVnwqaJJJGvL+3T4gvobgpOz1eKWJxZ7UWHsvc/0zNVdSB59ZtawEJ6i6YjfwHY1KvtPukCw/jFmjHVq88dLiJ7yXjcs8q1Y+NYLhkTRqpDW36sS7iRkampF9Y8RcpuqoRFee+grYrZ/278J1tRDO5bbP/wJejDUTkdQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(39860400002)(376002)(366004)(396003)(5660300002)(6512007)(6666004)(53546011)(6506007)(8936002)(7416002)(30864003)(6486002)(41300700001)(31686004)(36756003)(478600001)(186003)(2616005)(83380400001)(38100700002)(31696002)(86362001)(316002)(110136005)(4326008)(2906002)(54906003)(66476007)(8676002)(66556008)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dHFSaHVjbC90RmEzTDJsTXQyeW1KdTQ5SWUzVXdRdmtUeEVheG80eWJYTFlj?=
 =?utf-8?B?djJYTkFWRUUwTEZ3OW5tU3VYQTBBd0lWMDVUQ3dhc1FyZmZnL3Y2elAxRDV6?=
 =?utf-8?B?TkV3S3h6VzdWUzNad0VqNEdFRU1tWVBmcUdpc28xSFV1ams2Qm1XN0ZOK3I0?=
 =?utf-8?B?bHNmZCt4THFzdE1kMld4TXBaWUNVeGg2dkptN1EvcW4vMUMyVklENGRMTlMv?=
 =?utf-8?B?dlBNN0trQkxPLzdGcVNOQmhvVUF5UnBrekRrdHZXUFBDUTFvV3RyZFR5amJV?=
 =?utf-8?B?NDF6S0dBMWtqWXVzVGVZRkYyS1pZM01ERzJlVk40akhmSi8zeElZenRaN0N6?=
 =?utf-8?B?eTU1SkVIWHpHYnJGY0IrQU1SOFJIdlZLZWdhcmQ1NWhkdVRTSlBHRjYwdDRO?=
 =?utf-8?B?TXF0ZVJ3NUlmOURhTzRPZ0hlbUt0U0gwZVphem4vMGhXUGp6SEJ4QXowQVdO?=
 =?utf-8?B?enBqNjFsZVBDWVh1UklIQThrRlBMcVhnUmtId0pmMllZRnVaZ1dsTFg1VFFS?=
 =?utf-8?B?bW13SnZEanJzT01pNmtaT0cwU3Bld3VjZXR6QUhUWFY3RFhDN2xYRHhxS25l?=
 =?utf-8?B?ZnVWQkdqUEs3TTkwY0MrNjFUNEtIYUdqSXltc0dFQ1hpYkswd0FBSHJFZk5q?=
 =?utf-8?B?ZytOVG9CUmwyOTM4anhIOG5Nc28rdUZMc3ErZkp6cGN6eHBKdmZwdnBIM3Vk?=
 =?utf-8?B?azNXK2EyY2dvRVk0Z0RyRkMwS21kL3FBUDcxS0gvV3lnTWt4THFEbVRveTlz?=
 =?utf-8?B?NVlDNWRGQnBGQ1p0VlQwWndVdjFjdHhDb2htK1JkSU9sWjMvRmtQSG9XZGRt?=
 =?utf-8?B?TWZ0SnJYdnJyeHV2eHlEVGU4K1B5SVo4WTRid2J0UlA3bnVCSkczOW10ZndF?=
 =?utf-8?B?Vyt3bWtqM01JYm0zQzRvdUUxb3ppWjF3dDBsTndQWXFrQlNHQ2xCQWdaL2k4?=
 =?utf-8?B?bUowQVI5Sld2UU5JTkF0TUtlM014WVFFTTh5UUl3NVVqZ2FCclRSb1FKNGpY?=
 =?utf-8?B?RzhJUVVhK050SzRxemJnSEJZeEV6OUx4YlRNMTBmQzNDaXRoZmFadUVXM25N?=
 =?utf-8?B?ODdnWUs3cEMvMXZhK1lOd20xTmUzM0xyWXZkTVBXTnBjbnBaVkhqci8yMTJD?=
 =?utf-8?B?dWpXWTU0SXBvSVJFQkdibk5qbkFpMnA0TWlURXBQeEdZa3JJeEZpcUd1eHAy?=
 =?utf-8?B?WVg4cWZkcDZmVk1PbFF5bW5YVzVIOGkrd01iZm1KUE50WXQ3WW9sZ212Yitn?=
 =?utf-8?B?UEZSNEhwY2diSUpqWEkyK2sxNWs1QWtKd3lLMWk5ekE5MnRDWGk1WkY5Y0Rp?=
 =?utf-8?B?WFhKN290cFNqNTBOczdwVEYza1B2NnhvdEtMWFJScXJ3VzBZckNvbExHUk1l?=
 =?utf-8?B?clh3N2E4RHFDbWlJMS9oVVdhODZaUWNJZGZXRGRhcXpQK0hNVkhqMkxXZStZ?=
 =?utf-8?B?RjEzWUdLMDIrOHNCSjkzNzdYSzBLQ1lQa2xjV1p2RTFJZlZmUjNrc0lLaVRT?=
 =?utf-8?B?UEs2S3UzdWNnMHRRQmh3NTIvTTI1U3RSQmhta1FTVVEvRUR5d3ZXNHE5NThH?=
 =?utf-8?B?am82bDQvSGd3RURkbSt3U2U3UHlhcWZ6MWFsOC92S0xBbDRZZnlYT0p1bENn?=
 =?utf-8?B?VTAwMlk3SFhWRVV0emFBQVNYdTFuZFl4ZlF5aFFndzBaVHhPVWp1MlFuZFcr?=
 =?utf-8?B?ZWFKK1lwYmFDUjVTUE51dG9hVExxYUdmQ0Fuenp1WGRSd0JHWFJER1VJamox?=
 =?utf-8?B?WkZjTEZmR0RxS2dHTUFWOENRTkhkc2ExUXNqZGpGdFZXaUljdTBqRzI0MXJM?=
 =?utf-8?B?NXB0cFdKbit5MDMvbVJZM2dnRkpSWTZtd1MvdUJ0SytEWW11SmM1OERSaUxC?=
 =?utf-8?B?eWRSUjFVeTFtMWlSeitiTlphZDJ6TUZsWThzdmMyMTBvYjdyMGl4Y1ptNEZC?=
 =?utf-8?B?UGpmWWNsa2ZKN0MrQnFtblV4UVNia28vcG96M0srSER2L0w1cnIzaWhWVWhV?=
 =?utf-8?B?YUkyZVQxWCtyTzczYUQyaHZLMWkxR0hpaXB3WGg1V0ljOVBlVDBBTjRDR1Yz?=
 =?utf-8?B?R0ZoSUhoOExodCsxVSsxcHJzendNUjZZMmladURvUWhFUDlWYUc5eS81Qzk1?=
 =?utf-8?Q?U9DKgRw3SNxd1yu1unbA7gH69?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a147486a-660b-4787-0f38-08da706638f7
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 06:55:57.2286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 66IXwIaPmfjM9qeI6LZaZPByAzFoW9ysl03uVMXHsoQco2yigksuQVtWATVLeJFQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2252
X-Proofpoint-ORIG-GUID: LcSnYiplYZgkSzRruyy6p654Spt_cZ2j
X-Proofpoint-GUID: LcSnYiplYZgkSzRruyy6p654Spt_cZ2j
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-28_01,2022-07-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/22/22 1:33 PM, Hao Luo wrote:
> On Fri, Jul 22, 2022 at 11:36 AM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
>>
>> On Fri, 22 Jul 2022 at 19:52, Yosry Ahmed <yosryahmed@google.com> wrote:
>>>
>>> From: Hao Luo <haoluo@google.com>
>>>
>>> Cgroup_iter is a type of bpf_iter. It walks over cgroups in three modes:
>>>
>>>   - walking a cgroup's descendants in pre-order.
>>>   - walking a cgroup's descendants in post-order.
>>>   - walking a cgroup's ancestors.
>>>
>>> When attaching cgroup_iter, one can set a cgroup to the iter_link
>>> created from attaching. This cgroup is passed as a file descriptor and
>>> serves as the starting point of the walk. If no cgroup is specified,
>>> the starting point will be the root cgroup.
>>>
>>> For walking descendants, one can specify the order: either pre-order or
>>> post-order. For walking ancestors, the walk starts at the specified
>>> cgroup and ends at the root.
>>>
>>> One can also terminate the walk early by returning 1 from the iter
>>> program.
>>>
>>> Note that because walking cgroup hierarchy holds cgroup_mutex, the iter
>>> program is called with cgroup_mutex held.
>>>
>>> Currently only one session is supported, which means, depending on the
>>> volume of data bpf program intends to send to user space, the number
>>> of cgroups that can be walked is limited. For example, given the current
>>> buffer size is 8 * PAGE_SIZE, if the program sends 64B data for each
>>> cgroup, the total number of cgroups that can be walked is 512. This is
>>> a limitation of cgroup_iter. If the output data is larger than the
>>> buffer size, the second read() will signal EOPNOTSUPP. In order to work
>>> around, the user may have to update their program to reduce the volume
>>> of data sent to output. For example, skip some uninteresting cgroups.
>>> In future, we may extend bpf_iter flags to allow customizing buffer
>>> size.
>>>
>>> Signed-off-by: Hao Luo <haoluo@google.com>
>>> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
>>> Acked-by: Yonghong Song <yhs@fb.com>
>>> ---
>>>   include/linux/bpf.h                           |   8 +
>>>   include/uapi/linux/bpf.h                      |  30 +++
>>>   kernel/bpf/Makefile                           |   3 +
>>>   kernel/bpf/cgroup_iter.c                      | 252 ++++++++++++++++++
>>>   tools/include/uapi/linux/bpf.h                |  30 +++
>>>   .../selftests/bpf/prog_tests/btf_dump.c       |   4 +-
>>>   6 files changed, 325 insertions(+), 2 deletions(-)
>>>   create mode 100644 kernel/bpf/cgroup_iter.c
>>>
>>> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
>>> index a97751d845c9..9061618fe929 100644
>>> --- a/include/linux/bpf.h
>>> +++ b/include/linux/bpf.h
>>> @@ -47,6 +47,7 @@ struct kobject;
>>>   struct mem_cgroup;
>>>   struct module;
>>>   struct bpf_func_state;
>>> +struct cgroup;
>>>
>>>   extern struct idr btf_idr;
>>>   extern spinlock_t btf_idr_lock;
>>> @@ -1717,7 +1718,14 @@ int bpf_obj_get_user(const char __user *pathname, int flags);
>>>          int __init bpf_iter_ ## target(args) { return 0; }
>>>
>>>   struct bpf_iter_aux_info {
>>> +       /* for map_elem iter */
>>>          struct bpf_map *map;
>>> +
>>> +       /* for cgroup iter */
>>> +       struct {
>>> +               struct cgroup *start; /* starting cgroup */
>>> +               int order;
>>> +       } cgroup;
>>>   };
>>>
>>>   typedef int (*bpf_iter_attach_target_t)(struct bpf_prog *prog,
>>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>>> index ffcbf79a556b..fe50c2489350 100644
>>> --- a/include/uapi/linux/bpf.h
>>> +++ b/include/uapi/linux/bpf.h
>>> @@ -87,10 +87,30 @@ struct bpf_cgroup_storage_key {
>>>          __u32   attach_type;            /* program attach type (enum bpf_attach_type) */
>>>   };
>>>
>>> +enum bpf_iter_cgroup_traversal_order {
>>> +       BPF_ITER_CGROUP_PRE = 0,        /* pre-order traversal */
>>> +       BPF_ITER_CGROUP_POST,           /* post-order traversal */
>>> +       BPF_ITER_CGROUP_PARENT_UP,      /* traversal of ancestors up to the root */
>>> +};
>>> +
>>>   union bpf_iter_link_info {
>>>          struct {
>>>                  __u32   map_fd;
>>>          } map;
>>> +
>>> +       /* cgroup_iter walks either the live descendants of a cgroup subtree, or the
>>> +        * ancestors of a given cgroup.
>>> +        */
>>> +       struct {
>>> +               /* Cgroup file descriptor. This is root of the subtree if walking
>>> +                * descendants; it's the starting cgroup if walking the ancestors.
>>> +                * If it is left 0, the traversal starts from the default cgroup v2
>>> +                * root. For walking v1 hierarchy, one should always explicitly
>>> +                * specify the cgroup_fd.
>>> +                */
>>> +               __u32   cgroup_fd;
>>> +               __u32   traversal_order;
>>> +       } cgroup;
>>>   };
>>>
>>>   /* BPF syscall commands, see bpf(2) man-page for more details. */
>>> @@ -6136,6 +6156,16 @@ struct bpf_link_info {
>>>                                          __u32 map_id;
>>>                                  } map;
>>>                          };
>>> +                       union {
>>> +                               struct {
>>> +                                       __u64 cgroup_id;
>>> +                                       __u32 traversal_order;
>>> +                               } cgroup;
>>> +                       };
>>> +                       /* For new iters, if the first field is larger than __u32,
>>> +                        * the struct should be added in the second union. Otherwise,
>>> +                        * it will create holes before map_id, breaking uapi.
>>> +                        */
>>>                  } iter;
>>>                  struct  {
>>>                          __u32 netns_ino;
>>> diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
>>> index 057ba8e01e70..00e05b69a4df 100644
>>> --- a/kernel/bpf/Makefile
>>> +++ b/kernel/bpf/Makefile
>>> @@ -24,6 +24,9 @@ endif
>>>   ifeq ($(CONFIG_PERF_EVENTS),y)
>>>   obj-$(CONFIG_BPF_SYSCALL) += stackmap.o
>>>   endif
>>> +ifeq ($(CONFIG_CGROUPS),y)
>>> +obj-$(CONFIG_BPF_SYSCALL) += cgroup_iter.o
>>> +endif
>>>   obj-$(CONFIG_CGROUP_BPF) += cgroup.o
>>>   ifeq ($(CONFIG_INET),y)
>>>   obj-$(CONFIG_BPF_SYSCALL) += reuseport_array.o
>>> diff --git a/kernel/bpf/cgroup_iter.c b/kernel/bpf/cgroup_iter.c
>>> new file mode 100644
>>> index 000000000000..1027faed0b8b
>>> --- /dev/null
>>> +++ b/kernel/bpf/cgroup_iter.c
>>> @@ -0,0 +1,252 @@
>>> +// SPDX-License-Identifier: GPL-2.0-only
>>> +/* Copyright (c) 2022 Google */
>>> +#include <linux/bpf.h>
>>> +#include <linux/btf_ids.h>
>>> +#include <linux/cgroup.h>
>>> +#include <linux/kernel.h>
>>> +#include <linux/seq_file.h>
>>> +
>>> +#include "../cgroup/cgroup-internal.h"  /* cgroup_mutex and cgroup_is_dead */
>>> +
>>> +/* cgroup_iter provides three modes of traversal to the cgroup hierarchy.
>>> + *
>>> + *  1. Walk the descendants of a cgroup in pre-order.
>>> + *  2. Walk the descendants of a cgroup in post-order.
>>> + *  2. Walk the ancestors of a cgroup.
>>> + *
>>> + * For walking descendants, cgroup_iter can walk in either pre-order or
>>> + * post-order. For walking ancestors, the iter walks up from a cgroup to
>>> + * the root.
>>> + *
>>> + * The iter program can terminate the walk early by returning 1. Walk
>>> + * continues if prog returns 0.
>>> + *
>>> + * The prog can check (seq->num == 0) to determine whether this is
>>> + * the first element. The prog may also be passed a NULL cgroup,
>>> + * which means the walk has completed and the prog has a chance to
>>> + * do post-processing, such as outputing an epilogue.
>>> + *
>>> + * Note: the iter_prog is called with cgroup_mutex held.
>>> + *
>>> + * Currently only one session is supported, which means, depending on the
>>> + * volume of data bpf program intends to send to user space, the number
>>> + * of cgroups that can be walked is limited. For example, given the current
>>> + * buffer size is 8 * PAGE_SIZE, if the program sends 64B data for each
>>> + * cgroup, the total number of cgroups that can be walked is 512. This is
>>> + * a limitation of cgroup_iter. If the output data is larger than the
>>> + * buffer size, the second read() will signal EOPNOTSUPP. In order to work
>>> + * around, the user may have to update their program to reduce the volume
>>> + * of data sent to output. For example, skip some uninteresting cgroups.
>>> + */
>>> +
>>> +struct bpf_iter__cgroup {
>>> +       __bpf_md_ptr(struct bpf_iter_meta *, meta);
>>> +       __bpf_md_ptr(struct cgroup *, cgroup);
>>> +};
>>> +
>>> +struct cgroup_iter_priv {
>>> +       struct cgroup_subsys_state *start_css;
>>> +       bool terminate;
>>> +       int order;
>>> +};
>>> +
>>> +static void *cgroup_iter_seq_start(struct seq_file *seq, loff_t *pos)
>>> +{
>>> +       struct cgroup_iter_priv *p = seq->private;
>>> +
>>> +       mutex_lock(&cgroup_mutex);
>>> +
>>> +       /* cgroup_iter doesn't support read across multiple sessions. */
>>> +       if (*pos > 0)
>>> +               return ERR_PTR(-EOPNOTSUPP);
>>> +
>>> +       ++*pos;
>>> +       p->terminate = false;
>>> +       if (p->order == BPF_ITER_CGROUP_PRE)
>>> +               return css_next_descendant_pre(NULL, p->start_css);
>>> +       else if (p->order == BPF_ITER_CGROUP_POST)
>>> +               return css_next_descendant_post(NULL, p->start_css);
>>> +       else /* BPF_ITER_CGROUP_PARENT_UP */
>>> +               return p->start_css;
>>> +}
>>> +
>>> +static int __cgroup_iter_seq_show(struct seq_file *seq,
>>> +                                 struct cgroup_subsys_state *css, int in_stop);
>>> +
>>> +static void cgroup_iter_seq_stop(struct seq_file *seq, void *v)
>>> +{
>>> +       /* pass NULL to the prog for post-processing */
>>> +       if (!v)
>>> +               __cgroup_iter_seq_show(seq, NULL, true);
>>> +       mutex_unlock(&cgroup_mutex);
>>
>> I'm just curious, but would it be a good optimization (maybe in a
>> follow up) to move this mutex_unlock before the check on v? That
>> allows you to store/buffer some info you want to print as a compressed
>> struct in a map, then write the full text to the seq_file outside the
>> cgroup_mutex lock in the post-processing invocation.
>>
>> It probably also allows you to walk the whole hierarchy, if one
>> doesn't want to run into seq_file buffer limit (or it can decide what
>> to print within the limit in the post processing invocation), or it
>> can use some out of band way (ringbuf, hashmap, etc.) to send the data
>> to userspace. But all of this can happen without holding cgroup_mutex
>> lock.
> 
> Thanks Kumar.
> 
> It sounds like an idea, but the key thing is not about moving
> cgroup_mutex unlock before the check IMHO. The user can achieve
> compression using the current infra. Compression could actually be
> done in the bpf program. user can define and output binary content and
> implement a userspace library to parse/decompress when reading out the
> data.

Right mutex_unlock() can be moved to the beginning of the
function since the cgroup is not used in
   __cgroup_iter_seq_show(seq, NULL, true)
