Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6966752F731
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 02:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238879AbiEUA7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 20:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232046AbiEUA7M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 20:59:12 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C46801AEC54;
        Fri, 20 May 2022 17:59:10 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 24KMsIvu022240;
        Fri, 20 May 2022 17:58:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=KIpZs9jKbqBOvPrqHQrp3jSELXI1Phrut9mQHwVWCrA=;
 b=J/xkxKQDc2QW7jfk9g/qUIAonSVzVHwhrRW6Wt6Ii+7Q6GCmciBQJxv9RV1AtKN+U5jr
 q6jdn51i65NeFeSmQNQy+2A81Cth7gVfavnLw2PE3EQV5RvAsyZC6SGKW2bwLyB2fSyf
 9rhmH2U6kpjS+BQF4gqVMf6X5uJ+2jwoTBc= 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by m0001303.ppops.net (PPS) with ESMTPS id 3g5wkrg98n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 May 2022 17:58:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=na3zHKV0NrJNFlrKFptKdNuWnL0LOI+LpCpobpTR0oS4+6YxHKZKLNbZi5vjQK2FKUKDOioCgml4kZfhOVf9eCDexiPKyNqJ4dnGpS655tO4PX2DBTMgXE/NvIcbXU7zvLzjRlukyMApvlCeQoLZIkSkpvbOdnEY5tXrR/l+YYUosO/0yy2zmU1bCGZGveKxJtZkYA1GcyMbGxesDyBBy0Dr1BDbXUcaUj5fwXHIVe+QjT83+h8nA9nrUHBsdZ9eT1X+KhZ3kJ06OEvRU30R2H6HIrj9mwtTaM2meUAJapM1Bypq096AbAGS7D3EBtbSGzyUYV1mBXkEFbHzoemFfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KIpZs9jKbqBOvPrqHQrp3jSELXI1Phrut9mQHwVWCrA=;
 b=VIBlM4BICoJd4KKS7oBN7FMbUOJTusvok24gBs3RqQQSvAe3DfRYOdoXNemVuOZ09XBT5A13RCRODFOEQYjfTYzdXYM9ruhDciG7uSUdgnsUutScAsKv+jheh/A3PU1C0vhNqu6SNnKBT/92twdaCsKnMWjdxIG2ha9OPsJKYtGiQZqrSIkUaCNf8Zv6sNbpvac/7OASURqjulygwDIYJ2S3Sc0bmDZ1+bzLvgKvmavyiUqagO98pVkafSlnKYz7fatqRIHgqIatLzKqfg69fdNB8PcKSEkJR5hXV6Pu83EmKR3Zw3E9Wexcu7S1YG2JqxGuLPVdvgEEJCEODnJNeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by PH0PR15MB5088.namprd15.prod.outlook.com (2603:10b6:510:cf::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.19; Sat, 21 May
 2022 00:58:50 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53%7]) with mapi id 15.20.5273.017; Sat, 21 May 2022
 00:58:49 +0000
Message-ID: <4cbdd3e9-c6fe-d796-5560-cd09c9220868@fb.com>
Date:   Fri, 20 May 2022 17:58:47 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH bpf-next v1 3/5] bpf: Introduce cgroup iter
Content-Language: en-US
To:     Hao Luo <haoluo@google.com>, Tejun Heo <tj@kernel.org>
Cc:     Yosry Ahmed <yosryahmed@google.com>,
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
 <CA+khW7iDDkO3h5WQixEA=nUL-tBmCTh7fMAf3iwNy98UfM-k9g@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <CA+khW7iDDkO3h5WQixEA=nUL-tBmCTh7fMAf3iwNy98UfM-k9g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0175.namprd03.prod.outlook.com
 (2603:10b6:a03:338::30) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4805a361-820a-485e-16ad-08da3ac5111b
X-MS-TrafficTypeDiagnostic: PH0PR15MB5088:EE_
X-Microsoft-Antispam-PRVS: <PH0PR15MB5088828AFFCBC8283FC50201D3D29@PH0PR15MB5088.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ur3A5XKwPqevbOO2vb2HSDiKxmRUk75k14jEcTtGC/x0umJOFHPIv/vN7QxareK+t0+U7/PMzVTabxU2Se3VJyL52D+8rH9ISRv4k04hkPsnltK/BJyu09UVokjS4F5/vhrqDiH7n2yBFAUkQQZp4ftCBfnB1m6oFr0e4hlWYYuxcS1EbvUQ4qx7NBQRnpOB4Pzz9QbK7JPEoxNoZpOofgCOzkyrwCRSSjEkY2S8xYuWVvc//hZiTfalcPRin2mbkMtAIpry9z3epv7uYKVt0JRCcusSMn23572fwW3nmMXeUACBbSv4/qsStHpT+UTv7VYJbPlTC4bKHr7RqQ/yLmOlfHbspgp+yBSPdYLoHf5t302SORoMPYhal60wBWXoHQDAS0pfHOjkh5TkrbKl32gCKzrx0jXk4TNBmcyYG/FuBTRsIkNi8QzgriVyE6M3VcSH/3Gwwp+SRUNOvqJO9MN5dEFsj8SQJD/itnqrCj9fbpiMGVoWtFX9BlTx8FBHzibLxvH6QpHbb3DYiL1CgxQlkW9WyLMUqrjPJoCikOdsA2GfxwpQJP/sJg1PQC65rFGITLT7veFnhj2jwwjr/an/a/QeYulN+J0lrq5o1m/memodPe8tv8w/JPSeudb6kei1bbgqd9+CVR7zwixV56iNG7RvQewrbqWpxp4by5RAWx8oND2oNTQcn4FwiDko92cHKQ6WTGn+r8XIhWw707++ebhgTHu3SIk7A0xLwrjh6udZNOWxhAQOLXqb5gf1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(66476007)(7416002)(508600001)(6486002)(66556008)(38100700002)(2906002)(4326008)(31686004)(6512007)(6506007)(53546011)(52116002)(86362001)(54906003)(8676002)(2616005)(316002)(186003)(5660300002)(8936002)(31696002)(36756003)(110136005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aEtKZTk5SUNlNTE3cEV3WkxDL3Y1WTZsKzlsOTd1SHdoZmlJdlZZMEN3MG0x?=
 =?utf-8?B?SlRCUGFmOEUzOGwvYjAzVHZ1a1ZQVzVEeXN4MjB5dWRCc3RycUpkTmdpS2NE?=
 =?utf-8?B?NU4vcnNndkdxOTZCMmlSSDhWMkM2WG9CK3B0emNIc3VEa2QxWEFHWDFzL1FI?=
 =?utf-8?B?dmwvTjFjUlhRaU9uTDhXUTVEajViTzBxODQvWE5weGQ5aWYxZytQaVYyUkN6?=
 =?utf-8?B?c3lwNmtOcnVkOGZSelc5MHlhU3dSRm9rR3Nsanhvb2pHMU5zcEk4RE1RRVl0?=
 =?utf-8?B?bWVoNmZGbzlJQ3J6OSt2OG0zaVRMelVBUDJ5Zk1KNTJ5TEtuQmx4ZGt4S1ky?=
 =?utf-8?B?QXBiVzdJdUJDSG1Vc0hLcithYnZQYWphN2FyWjNFQTZKZTJHRjlqcHo5d3kv?=
 =?utf-8?B?VnpNMjMwSFNzSWhrYWx2SEg2QkpmaHh6dlNQVVYxeTlUemJpY0tIZ1FLSFZM?=
 =?utf-8?B?ajQ0NnhUenQ1UXp6Uk1Hdi96ZGgrT0cxTVl2UXkwS2VENzBLUlJzS0p3WlhE?=
 =?utf-8?B?Ykw3cUdVcUIrUkZDS3JueFRLK3ZDbmxvTktVMmhsbjN4bm1TZ1A3Nmo0U2gr?=
 =?utf-8?B?Uzh4bjlsRjNPVjE1RHhZazBPZ21Uck5ScnZYOUFUZndHbVVhTjNSY0toUGZ3?=
 =?utf-8?B?K1lybjVwaEJRKzJPYzdBR0ltbkVWakFpeGFldWZjNmhCNGJ4U204dGxSTEl5?=
 =?utf-8?B?YU1vU0xBNXhFOUsrc1V5TTBENkRmSHUyWFVDUWk2MWxaemQ4dlVRN2FLek1s?=
 =?utf-8?B?ek8vYTdtVFBFYWZxdzdxNmtLRy82eWpKM0tQNzlWb2dGcnpEekR4bDR6eE1P?=
 =?utf-8?B?YzVWSDRPa3BtR0k1aWZ6UC8vZlY2WUVYak52QldwVTV3UEVpOXhla1FzRjhF?=
 =?utf-8?B?by9aT1NYcjFZWm8xcWorb1ZpNFI2THBtUjZaY2JZalM3SWpHTk9jV0xRQ3BU?=
 =?utf-8?B?VTBHVkdnYlgrcWN5R0tmdkVTZDZmK3lxbGEzVG1WaE1TVGE5em10aWV3cG1Y?=
 =?utf-8?B?RXYrVEZ1MHZBdnlPeTY4LzFEblFqU0xLcndNS0NHY3V6SXl4bVhTRWU1Wk93?=
 =?utf-8?B?blZKM250TVhuNzZxSDhCeVNRRXpPczlmak01TkN2Z3I3NGxXanpiUHBUZUpJ?=
 =?utf-8?B?QkRpazg0R2JPWkZ3NzJCN1FadHg2TkdYWGwyQjgzS25MbEEzcHFFQS9YcnVU?=
 =?utf-8?B?ZkhUTURUYUV2S2NvenMvZGxXaFNCTmFPZDUwY1lVUzFTZVJDQUlYS1VONFhG?=
 =?utf-8?B?eC9uVWVVaTJRU3VSekIwVzdzU1ZXenE1SkFib1dVRU9MdE5UVE9FY1FnOGcr?=
 =?utf-8?B?WXByWlo0M0hDa0MrSGwzd2k0MGZwbEdGZWtWVnBxaVRIekl4bzc5Ykg5dkNo?=
 =?utf-8?B?VFJhZzlPanU5TnRKKy82SVpDYkc2N3pUMXNhclRDeHRaU1VEcFVLbW5WTXZJ?=
 =?utf-8?B?cGlxTWFMMDlpclhPNWRyc083VEY2YkoyNVFJUjhSYU5kNXB6REJFRUlvVi9W?=
 =?utf-8?B?UHpvUDBwK2k5TEpFNGJaOURvbEZ6dVVxaDRhU0VITXQxVCtzc2dsU0JVVFMz?=
 =?utf-8?B?WHdMZGdHdlBta1p2RjVyb0VsKzZzcSs4UHJQbnBLT09YaW1ycXpqb003M3JK?=
 =?utf-8?B?ZWQ2T0pDQ2Fra0RUY2xTOVJYNXNYV0UwMkNYL25mZHZDcjRoUE5sRG94TDJp?=
 =?utf-8?B?RThGZkhWbVBCMm9iRmNJSEVNOWpBK1F3Zkx0Z3JGVEVIVVN2bWhkSkNCM01z?=
 =?utf-8?B?N3ZPbC9RSkY4OFpoYUd3UlZPbG83a3duakphM05LZUJXYmR4cm95WWt2a1k1?=
 =?utf-8?B?UmRxcVVTRWp5bHRKUUFwcG5lVVAwMVp6LzFHWnpYcEZ2d3FDZWdGeWtTNCty?=
 =?utf-8?B?QWx6TVM3dWcvNmgzNEx0cFRic0RKN1VvdllnMlFCNjF4THFWVW14MThMU01q?=
 =?utf-8?B?UXp2Mm9XNzV5YmpoUzRkblRSUlU3UWFCRnJsMmx0bmdQNXltNFJZMFlxK3pM?=
 =?utf-8?B?dlkwTmJyZE5sMk5idGxZenJhRVpMRVRTMG8wUXVDUG1ocUdrWVhSTU1SLzBT?=
 =?utf-8?B?MUZ1SmVPNUJqMnhHNjBrSmpRcHZYUjlpUklQQ0Z0eU5MNnlxdEwzUEIraTdy?=
 =?utf-8?B?blpYWTM4WFI3bU5nV3U1eXczQ0pyazc5bHRYNDdPaGUxNWs5b2pmOU52bllo?=
 =?utf-8?B?M1pmcko2cGRUNDVXcDNiTjBkWXVLMDNUSHVoK28zek4vWXZPaXRBZXFJVTR4?=
 =?utf-8?B?MDFYNGNkNGF1U3ZUMFF2TzdmdmordTBYTnhHcjl3OTZzVXpuTm5lcVI4enNE?=
 =?utf-8?B?QmRldm91SjdRaTJIUTJHcG41bVU5MTZ4cHQwMXRJV2wvZDlLempIZWhZb29W?=
 =?utf-8?Q?sll7WQ0kU9MQEYlk=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4805a361-820a-485e-16ad-08da3ac5111b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2022 00:58:49.8021
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qE/N17bxWsZhPpq1KWuSKyT16scCwXVV+DkNdbmfwoqwvLIP/YA1UE3bBi8mhcdW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB5088
X-Proofpoint-GUID: hEr9imfLMsJU0VK8JtOiCmOYyFEOGOsS
X-Proofpoint-ORIG-GUID: hEr9imfLMsJU0VK8JtOiCmOYyFEOGOsS
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



On 5/20/22 2:49 PM, Hao Luo wrote:
> Hi Tejun and Yonghong,
> 
> On Fri, May 20, 2022 at 12:42 PM Hao Luo <haoluo@google.com> wrote:
>>
>> Hi Tejun and Yonghong,
>>
>> On Fri, May 20, 2022 at 9:45 AM Tejun Heo <tj@kernel.org> wrote:
>>> On Fri, May 20, 2022 at 09:29:43AM -0700, Yonghong Song wrote:
>>>>     <various stats interested by the user>
>>>>
>>>> This way, user space can easily construct the cgroup hierarchy stat like
>>>>                             cpu   mem   cpu pressure   mem pressure ...
>>>>     cgroup1                 ...
>>>>        child1               ...
>>>>          grandchild1        ...
>>>>        child2               ...
>>>>     cgroup 2                ...
>>>>        child 3              ...
>>>>          ...                ...
>>>>
>>>> the bpf iterator can have additional parameter like
>>>> cgroup_id = ... to only call bpf program once with that
>>>> cgroup_id if specified.
>>
>> Yep, this should work. We just need to make the cgroup_id parameter
>> optional. If it is specified when creating bpf_iter_link, we print for
>> that cgroup only. If it is not specified, we iterate over all cgroups.
>> If I understand correctly, sounds doable.
>>
> 
> Yonghong, I realized that seek() which Tejun has been calling out, can
> be used to specify the target cgroup, rather than adding a new
> parameter. Maybe, we can pass cgroup_id to seek() on cgroup bpf_iter,
> which will instruct read() to return the corresponding cgroup's stats.
> On the other hand, reading without calling seek() beforehand will
> return all the cgroups.

Currently, seek is not supported for bpf_iter.

const struct file_operations bpf_iter_fops = {
         .open           = iter_open,
         .llseek         = no_llseek,
         .read           = bpf_seq_read,
         .release        = iter_release,
};

But if seek() works, I don't mind to remove this restriction.
But not sure what to seek. Do you mean to provide a cgroup_fd/cgroup_id
as the seek() syscall parameter? This may work.

But considering we have parameterized example (map_fd) and
in the future, we may have other parameterized bpf_iter
(e.g., for one task). Maybe parameter-based approach is better.

> 
> WDYT?
