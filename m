Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 199865710F7
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 05:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231896AbiGLDpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 23:45:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbiGLDpu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 23:45:50 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B639C820D8;
        Mon, 11 Jul 2022 20:45:49 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26C3aT5p022664;
        Mon, 11 Jul 2022 20:45:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=qYVOeYX7y1B94pJa32fraJcqXZkWibnP56b6KL6Z3fA=;
 b=QmAafKDP6JPR7e2YJv7+u5AG0Ym/iigND39xXvVUXgD4f8UL8akjZKdSKUVf+hM3hXs0
 HTl89lVYw0N7x0Tt7zGEMJ8miOqb3gujUPQb/RRPP3JxS96yLD1Rvi2rZ7EFucSZYdVF
 V1aT8Tpei1NDeJStlf8Ayr8Ej4+okVSdTLo= 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h8pqtkutr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jul 2022 20:45:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YYzDIHmUmZfhWSZx20OK+YHZFya9b5mGX+C0BVOsljKvdvei7afXwH9TlExVHVrd91Zf0gMx4DITwrQS1rkhwkytQhOjL0tpth+dl3zmejzkr1uvYBIRqxHs0fAVAiUXVJ8vgXT9EHN7iMuLkrecK0c9D0/TDKFzb1vSoECA76psINXMB+JpOYIuFpDc1CoBrrb/JFRoB87E4opW6bUgtlGGIKLxXF72pTN+fkaRbtLwO0RknSNcXTjZsM+zg7r2X6xwsZKEN5yPtgYUdA96v+Tjdo8JQfCuvWp0PGQEmLuvTf8vDuI7Cq0ZG/0AbawYdOow1t1eQAjJedr6Ag1Ykg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qYVOeYX7y1B94pJa32fraJcqXZkWibnP56b6KL6Z3fA=;
 b=j+TarJSG5nSkcZP9spGKW0RBI4BBCwIV5ak8QNFOhhtoSe1ClFhQ8qS/DvTeC/nTkCf9zeq5shWbUzoOc/V4LdYDFI6LnA4wzRaTdxyjv4DZ3qJ1cip2v7KREFPIE0kDMKWxuV0lJOuftJO7df+G2L44nvx5CD9sO/A60bwx+SdRhtOhIZQbm6O2XvJnpi8V5PLGWLhd9zyqZTBljPd/CVeGjOukMSNnrUR5b7+JOxwve9uNHDPTio2N315mbwSPxQaVEy6JsRxeVhgatLAGxEguJ+is9LPNqY/f5CirtnuxqcCkYezKbMXaq6Y4UrVUHiZZUmXrtSwQGx1Aeru5VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from DM5PR1501MB2055.namprd15.prod.outlook.com (2603:10b6:4:a1::13)
 by DM6PR15MB3404.namprd15.prod.outlook.com (2603:10b6:5:172::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Tue, 12 Jul
 2022 03:45:17 +0000
Received: from DM5PR1501MB2055.namprd15.prod.outlook.com
 ([fe80::acda:cdec:5c2f:af77]) by DM5PR1501MB2055.namprd15.prod.outlook.com
 ([fe80::acda:cdec:5c2f:af77%7]) with mapi id 15.20.5417.026; Tue, 12 Jul 2022
 03:45:17 +0000
Message-ID: <2a26b45d-6fab-b2a2-786e-5cb4572219ea@fb.com>
Date:   Mon, 11 Jul 2022 20:45:13 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH bpf-next v3 4/8] bpf: Introduce cgroup iter
Content-Language: en-US
To:     Hao Luo <haoluo@google.com>
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
References: <20220709000439.243271-1-yosryahmed@google.com>
 <20220709000439.243271-5-yosryahmed@google.com>
 <370cb480-a427-4d93-37d9-3c6acd73b967@fb.com>
 <a6d048b8-d017-ea7e-36f0-1c4f88fc4399@fb.com>
 <CA+khW7gmVmXMg4YP4fxTtgqNyAr4mQqnXbP=z0nUeQ8=hfGC3g@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <CA+khW7gmVmXMg4YP4fxTtgqNyAr4mQqnXbP=z0nUeQ8=hfGC3g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0084.namprd03.prod.outlook.com
 (2603:10b6:a03:331::29) To DM5PR1501MB2055.namprd15.prod.outlook.com
 (2603:10b6:4:a1::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c8e0e75a-daef-40a0-6c05-08da63b8efb1
X-MS-TrafficTypeDiagnostic: DM6PR15MB3404:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sdX4zMMrqdCHuAPm5OsXMHYusIu3TfnQWrrI3Xp3q1gDXNQ2oJIO8vguwmVKqr3u+jmGbkp9WI7TwWj90wEofday6Rsx1mEkd2Y+9iiz1MK4JYO4wjNAyEveEwM4NJDufyhrSMAzHxLK3iDljoMYNs+J2zuRHvGYt6YMzIN7hx2tdO3S6MbUJHkEXwJqsM1nr0MqG9eDXYPG6+2Hh/qIeVj40LT3cuvlcRJDx3P7K5cqU/gmIvbwqeQQA7IalGyME8mjyC9XlUqG62qKoi29N1Gy9sXhFqULMqRl6MhQjCSwpA3QvhRGeVHYwoVsKyDB4ve7QGIptPKUJ7WG4D53j6VpB86HLLIV2rZUdaeTUtujomDVVjgz5USrd5E1IHsgHXIaUWyO9WuwNV8VMxfgCkbKm7UO4Wu3JnGaZqGFWhCmdAp11kOZL71bP0Ms+K2LInYU1MRhXg6BLCKQrbqBCkQhtQhJCOBIuIBJY0ecgXYWfJZVlyW5kv7eQCZKZFwYbdCxbgy/uKo0kPGNDBM3JUIkuPpJUZOTBwnDtQpsCTeKfpuUkq0Sy8HRBLguxORKSzlHT8c4hIQR9cITHkQoRwktmnroiSKN3ZCM2GUy6Vj+u0JyPFaDG7gBw3ksiNu3GcUuQ67rd5hI081xdX5VB/1ZI/XvEfdLyqWojrT7aC6YPY3UUqEFpNm1GeUf/jgCXquPco/XbD7sOaNOt6AuiFEjEE8eRgKOn9bzsGLRkpxKNXDT7T80NHtuU3IVSp8IFX7js/9qqqE98AZm20Ajh6X/Dcitj1qeIz7NtjZKyDz/6H8QhNPIRIhmjFWHQbjWg9H6n24Ks65h1OCIiErf3FyO6dOJ7RGUDlUQogVXYk0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1501MB2055.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(39860400002)(136003)(366004)(376002)(186003)(478600001)(7416002)(8936002)(5660300002)(53546011)(6486002)(2616005)(6506007)(83380400001)(31696002)(38100700002)(6666004)(86362001)(2906002)(66946007)(31686004)(66556008)(4326008)(36756003)(6916009)(66476007)(54906003)(316002)(6512007)(8676002)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eHVsWFY0TERRaGxUTzdQcWN6N0RSMlhEc1VxZnJOR2FrSDhEVUYrVy9nMS9u?=
 =?utf-8?B?akhQb1NPb29SblBZTjhaY1VtSnZlcXdpckVEMDEzWVp6WXRGTHhKODRZSjJm?=
 =?utf-8?B?OGtiaUkvQ2c4NHVaYXJPNjZBaWt6RVBVUjA0K0FQd1c2aElCckFCb0pKek9o?=
 =?utf-8?B?TVBIYnZIbFJRVDRNZGk0MDFjdVpCbmo1Z242TW1FVTZSWlRDNU9mVUVQamRv?=
 =?utf-8?B?czNIWmM1ZEpPQ1Q4S0NEa3dKTGFGSjJyNmxubTlxQUhncG5RY01USWdEVllt?=
 =?utf-8?B?RmpIb0xDSjRoOUhXMnB3T0ZtcHdOc3pZRUdxbDV2REM5aEE0U3pyV1llUmZv?=
 =?utf-8?B?OHBWZE8vNlloMDJxbDNSS0VmQVFCaVpqbGRPNEYxL1BScWxwaE8yS21HbFVu?=
 =?utf-8?B?c1djcjhsT1pBUFNQdzVTQVZZS0oyc1JpQXQwSnRaSmt2RTMveDc3MExwNzF5?=
 =?utf-8?B?c05rN3VsSmZueG9HbnZUbGdxVTdscU1BM0xJZG5ZV0o4aDJNMEROQUF5MXZQ?=
 =?utf-8?B?TnlVQmE3ekdHdFRXSlM1amdORXFzT0xUSUpIenkvODIvMmVmMVJFYzJhOUdq?=
 =?utf-8?B?UnJnQWVVTWZFdmxsaWNENDFZM2I2ZXloeFl3L294bkhYbkM1TVZKUFBnbTRD?=
 =?utf-8?B?cmVhRmZsQXhmMGJLWS90WjJiNDNIM0NZbGlWZVBMYzV4V0h2WTJJSk01cmYz?=
 =?utf-8?B?SkVMeUdmdEx5VE9YdDcrbUhINjEyTTNLRHRJQnhPb0J4TU1LQml2UnQ1Y042?=
 =?utf-8?B?RjlNUFNCUjBLQ28xSFR2YXhkbHZVbUI5YlVpSU5aNmZ3d3lidVVtWGJzZFVC?=
 =?utf-8?B?TTdWWWNpWmxObkdaMHN6WDM3YzExSWJ0R1dCT0xoWXNGRGx0S1VjSDZkajlK?=
 =?utf-8?B?djdpbzJiOWJGOWJuY1VRMTg5SjhyL21PWmYrakxPa2RveEs3RXJHd2wreGM1?=
 =?utf-8?B?aG9rSVhHOWFBUDFzQTdod3h5RFZMMkpCWjhQYnpGbXorMG5KZHc1bEZjSVhK?=
 =?utf-8?B?cU0zaXpUTUk2ZzdqWnJzZjBRVE90RUg2aVhsZWRzVE04U3pmdDZMbk5yL2R2?=
 =?utf-8?B?RlFUaklVNURvSFc0MWtLWGdaL2ROdkpQK1g2ZG1LR1FGMmtwcmcxR1pRU3VU?=
 =?utf-8?B?YmpUL04rMlJOV0paaVlITExqaW9YR2Rpa0lRa2o1Y3dDTnUrQTFWYkFocWF2?=
 =?utf-8?B?djdJRnBmVURTS3ZSVGNwd3BsZmxoZDZmUjVGcDlQVTJxaitmZXFCREJnbnpE?=
 =?utf-8?B?QkgvY1VHWkdNSDRJclBtbzBoS2t4RitGUzVRWCtndU1MVXIzdHZNWmNYVmM2?=
 =?utf-8?B?d3BGV2Y5Z0Jmd0ZPcG1Vcml0WFQzSnB2RE1nVFJQOWVid2YrREdSRVMwVlFM?=
 =?utf-8?B?NFlBNTAvQzEwZ29HcHJ0VERwVDMvZllISEJkMWVvMlhnS2ZhTlYxMDlBeUM0?=
 =?utf-8?B?SnYyY21CLzJHRXdrMTMwNEFjUFQvUnZ6RmVCNkdnOFJHVmlGNWdOOEhiK1pt?=
 =?utf-8?B?b2RGNmNGNTZQYjJIREVvODQ2cXVLYnlGbWJEVUtjS3Z4OTdTcytXS09EdGFK?=
 =?utf-8?B?OUxrZFNEMWlCdGk0akxma2VwditjN1J1T0x4L2Rsb2w5T2Jla1ZvWCsxSlI1?=
 =?utf-8?B?NXM4RVpHN3VHeCtySWZ0M3lEVjEyN0hqUHo3bzhweUtHd0QwRFAzTE9WTkE0?=
 =?utf-8?B?MHBuYnlsRmZtTTI4TDlZZ3dqbmdJQWVNZ0poQXZRVHBHYXlxNi9hS2lPalo5?=
 =?utf-8?B?dlc2SkJha2RtV2xuYVdKVEx6azdQdWJwbGhRT0ZPMy9hK21COUV6TEsrQUkw?=
 =?utf-8?B?RHhmTjJCYkpkakI0SVIzSHBqOGJDaDlGM0t0dEQzZk1EWHJZU1R3Y0ZSSm5i?=
 =?utf-8?B?RER0ZU9NR2ZDQXFqQnRmZ0kvcFZ4L2pwQ3NLNjFrd0xVMVJmWnlpNnA4SUlm?=
 =?utf-8?B?Tk1DUWdub3FZWDNNd0hxUkRRTWxmSzhOVXVjWGdIaGlQN2RaanYrZTNCM0Ni?=
 =?utf-8?B?UWFGUlA3MmV6VWhSUGlLMitDWTZnQ0JJdnZlNmFKQlUwRWMxWnhSZ3lFalo4?=
 =?utf-8?B?cjl1UlUvanFxYW96T1VNWHZqc0FMVEJrdFdNNTBFVFJyS0dlaks4S2V4S1dv?=
 =?utf-8?Q?iIIyt62HlNvrs535C71NiRrcg?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8e0e75a-daef-40a0-6c05-08da63b8efb1
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1501MB2055.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2022 03:45:17.5360
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A9Q3Gx3BzP3fywlIrgBzT8PppJZkz+zKuvxIhmFD6jb+6RXa4WxxItC/Wt2mRsuU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3404
X-Proofpoint-ORIG-GUID: e7xSwJ8O0xUdiLaT_vQSQzJ13s_m67Y3
X-Proofpoint-GUID: e7xSwJ8O0xUdiLaT_vQSQzJ13s_m67Y3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-12_01,2022-07-08_01,2022-06-22_01
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



On 7/11/22 5:42 PM, Hao Luo wrote:
> On Mon, Jul 11, 2022 at 4:20 PM Yonghong Song <yhs@fb.com> wrote:
>>
>> On 7/10/22 5:19 PM, Yonghong Song wrote:
>>>
>>>
> [...]
>>>> +
>>>>    union bpf_iter_link_info {
>>>>        struct {
>>>>            __u32    map_fd;
>>>>        } map;
>>>> +
>>>> +    /* cgroup_iter walks either the live descendants of a cgroup
>>>> subtree, or the ancestors
>>>> +     * of a given cgroup.
>>>> +     */
>>>> +    struct {
>>>> +        /* Cgroup file descriptor. This is root of the subtree if for
>>>> walking the
>>>> +         * descendants; this is the starting cgroup if for walking
>>>> the ancestors.
>>>
>>> Adding comment that cgroup_fd 0 means starting from root cgroup?
> 
> Sure.
> 
>>> Also, if I understand correctly, cgroup v1 is also supported here,
>>> right? If this is the case, for cgroup v1 which root cgroup will be
>>> used for cgroup_fd? It would be good to clarify here too.
>>>
> 
> IMO, the case of cgroup_fd = 0 combined with cgroup v1 should return
> errors. It's an invalid case. If anyone wants to use cgroup_iter on
> cgroup v1 hierarchy, they could explicitly open the subsystems' root
> directory and pass the fd. With that said, Yosry and I will test and
> confirm the behavior in this situation and clarify in the comment.
> Thanks for pointing this out.

sounds good.

> 
>>>> +         */
>>>> +        __u32    cgroup_fd;
>>>> +        __u32    traversal_order;
>>>> +    } cgroup;
>>>>    };
>>>>    /* BPF syscall commands, see bpf(2) man-page for more details. */
>>>> @@ -6134,6 +6151,10 @@ struct bpf_link_info {
>>>>                    struct {
>>>>                        __u32 map_id;
>>>>                    } map;
>>>> +                struct {
>>>> +                    __u32 traversal_order;
>>>> +                    __aligned_u64 cgroup_id;
>>>> +                } cgroup;
>>>
>>> We actually has a problem here although I don't have a solution yet.
>>>
> [...]
>>>
>>> There is a 4 byte hole after member 'target_name_len'. So map_id will
>>> have a offset 16 from the start of structure 'iter'.
>>>
>>>
>>> This will break uapi. We probably won't be able to change the existing
>>> uapi with adding a ':32' after member 'target_name_len'. I don't have
>>> a good solution yet, but any suggestion is welcome.
>>>
>>> Also, for '__aligned_u64 cgroup_id', '__u64 cgroup_id' is enough.
>>> '__aligned_u64' mostly used for pointers.
>>
>> Briefly discussed with Alexei, the following structure iter definition
>> should work. Later on, if we need to addition fields for other iter's,
>> for a single __u32, the field can be added to either the first or the
>> second union. If fields are more than __u32, they can be placed
>> in the second union.
>>
>>                   struct {
>>                           __aligned_u64 target_name; /* in/out:
>> target_name buffer ptr */
>>                           __u32 target_name_len;     /* in/out:
>> target_name buffer len */
>>                           union {
>>                                   struct {
>>                                           __u32 map_id;
>>                                   } map;
>>                           };
>>                           union {
>>                                   struct {
>>                                           __u64 cgroup_id;
>>                                           __u32 traversal_order;
>>                                   } cgroup;
>>                           };
>>                   } iter;
>>
> 
> Thanks Yonghong for seeking the solution here. The solution looks
> good. I'm going to put your heads-up as comments there. One thing I'd
> like to confirm, when we query bpf_link_info for cgroup iter, do we
> also need to zero those fields for map_elem?

I think we don't need to do that. User space expected to check
target_name/target_name_len/cgroup only. For cgroup_iter, the
'map' value should be ignored.

> 
>>
>>>
>>>
>>>>                };
>>>>            } iter;
>>>>            struct  {
> [...]
>>>> +
>>>> +static void *cgroup_iter_seq_start(struct seq_file *seq, loff_t *pos)
>>>> +{
>>>> +    struct cgroup_iter_priv *p = seq->private;
>>>> +
>>>> +    mutex_lock(&cgroup_mutex);
>>>> +
>>>> +    /* support only one session */
>>>> +    if (*pos > 0)
>>>> +        return NULL;
>>>
>>> This might be okay. But want to check what is
>>> the practical upper limit for cgroups in a system
>>> and whether we may miss some cgroups. If this
>>> happens, it will be a surprise to the user.
>>>
> 
> Ok. What's the max number of items supported in a single session?

The max number of items (cgroups) in a single session is determined
by kernel_buffer_size which equals to 8 * PAGE_SIZE. So it really
depends on how much data bpf program intends to send to user space.
If each bpf program run intends to send 64B to user space, e.g., for
cpu, memory, cpu pressure, mem pressure, io pressure, read rate, write 
rate, read/write rate. Then each session can support 512 cgroups.

> 
>>>> +
>>>> +    ++*pos;
>>>> +    p->terminate = false;
>>>> +    if (p->order == BPF_ITER_CGROUP_PRE)
>>>> +        return css_next_descendant_pre(NULL, p->start_css);
>>>> +    else if (p->order == BPF_ITER_CGROUP_POST)
>>>> +        return css_next_descendant_post(NULL, p->start_css);
>>>> +    else /* BPF_ITER_CGROUP_PARENT_UP */
>>>> +        return p->start_css;
>>>> +}
>>>> +
>>>> +static int __cgroup_iter_seq_show(struct seq_file *seq,
>>>> +                  struct cgroup_subsys_state *css, int in_stop);
>>>> +
>>>> +static void cgroup_iter_seq_stop(struct seq_file *seq, void *v)
>>>> +{
>>>> +    /* pass NULL to the prog for post-processing */
>>>> +    if (!v)
>>>> +        __cgroup_iter_seq_show(seq, NULL, true);
>>>> +    mutex_unlock(&cgroup_mutex);
>>>> +}
>>>> +
>>> [...]
