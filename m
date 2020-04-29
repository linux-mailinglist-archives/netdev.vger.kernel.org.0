Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A70B1BD48D
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 08:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbgD2GVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 02:21:10 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:64228 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726181AbgD2GVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 02:21:10 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 03T6IEjZ014929;
        Tue, 28 Apr 2020 23:20:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=s3bEBRDCrA4q/f6w/qyCFJtHCbhL8i3iAjiItD7NeT4=;
 b=mGJTmoOwxfT1/7cxL9w0bDYJNnZA4BM6pL1aPJsZvStGQBRfqK8QEbFC193LT7xT5h00
 Nh4fSB5oFARP3aZQsB35Es3qp4ifZsU8pFzOubA0zqvFuMzy+uPVRCJkcVqYC5cAF+YB
 SaS7yEoO/FdI99GXuI74KGkfjFcEOwWjOcY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 30mgvnsqx7-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 28 Apr 2020 23:20:54 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 28 Apr 2020 23:20:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DzD3GVFCJF3p2FFfkP1cGGCQUA/KReW0DrY0rJml7chje5u4pq70hIfFXee57czDla47iOHK9Sui4iigdFV6PBjmIvBpF7wJzxWZK4AUi0w5A7fHhCIRUSeDG58HP2akPJAnhH5ryoE1U7BJDfiKgYA+cpzX4Mc1nZMXkPKzLD/r3aTCim14HLObdWY2P5QOlzMxagSfu+6JoHd3vRFbgQN18mrbsxERS6KqXlraNPTLGPX2guOvgTp/UW3bNqjEhKdjRRppFAUj4imraKkZ/XcwLAEunGHS827H8W3UytfBjPCSN581r9Sb/UjhKPxxYnayTrrEczO2VRJD0LJiVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s3bEBRDCrA4q/f6w/qyCFJtHCbhL8i3iAjiItD7NeT4=;
 b=Je5nOestSyVUVDxfqPaHUmkMJ/P443qXL0cBcF6HcVzaPE2mCLnHZACqLvOHk1L2eA9NzdD+a6mQ7YMHxrqzGeGu4qoUiIH3ZnQA+tlERi94hBA/jNdz8X0Q0awoiGcF8cyPSN+1EANse2+mFC2zwhikvAU0BenSaDFqL08ftY4kyHseTXN922RvdCYUE/45XlgiN/FW6bUAtSpjgcAU9oLWfdATcHZ72x3LLaBcp/oKttREQGpqeRYAKSXX1JXpLBreBrX7+Q+jja5iU/dlOIENf/LC+LcSR7rwtX4U8ehiF/pk0/T9QW6bWdI16GYx+DbwEemWmd7SWuegQ91gVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s3bEBRDCrA4q/f6w/qyCFJtHCbhL8i3iAjiItD7NeT4=;
 b=a3xLnVDek3mAxce0Gt7tzc//tUN/RGDhaIZBtxW57sGC+V53tcmqDXnlU79vXjxxC5D66PL9sfthFj41EsY74AdsWqVvylW25ab2gGWEvYNL4+ZwxwtyjRFAQ7DoD/9Ca5J/0sIHIrN+eVByf+6wUI9r4BqzarZTZOoSHwcmYv0=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB4101.namprd15.prod.outlook.com (2603:10b6:a02:ce::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Wed, 29 Apr
 2020 06:20:35 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923%5]) with mapi id 15.20.2937.023; Wed, 29 Apr 2020
 06:20:34 +0000
Subject: Re: [PATCH bpf-next v1 03/19] bpf: add bpf_map iterator
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Alexei Starovoitov <ast@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20200427201235.2994549-1-yhs@fb.com>
 <20200427201237.2994794-1-yhs@fb.com>
 <20200429003738.pv4flhdaxpg66wiv@kafai-mbp>
 <3df31c9a-2df7-d76a-5e54-b2cd48692883@fb.com>
 <a5255338-94e8-3f4b-518e-e7f7146f69f2@fb.com>
 <65a83b48-3965-5ae9-fafd-3e8836b03d2c@fb.com>
 <7f15274d-46dd-f43f-575e-26a40032f900@fb.com>
 <CAEf4BzaCVZem4O9eR9gBTO5c+PHy5zE8BdLD2Aa-PCLHC4ywRg@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <401b5bd2-dc43-4465-1232-34428a1b3e4e@fb.com>
Date:   Tue, 28 Apr 2020 23:20:30 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <CAEf4BzaCVZem4O9eR9gBTO5c+PHy5zE8BdLD2Aa-PCLHC4ywRg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CO2PR05CA0002.namprd05.prod.outlook.com
 (2603:10b6:102:2::12) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:e9ab) by CO2PR05CA0002.namprd05.prod.outlook.com (2603:10b6:102:2::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.9 via Frontend Transport; Wed, 29 Apr 2020 06:20:33 +0000
X-Originating-IP: [2620:10d:c090:400::5:e9ab]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3e3379c0-5076-4a28-0df9-08d7ec056d29
X-MS-TrafficTypeDiagnostic: BYAPR15MB4101:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB41012EDB879C2776C7F4D9DED3AD0@BYAPR15MB4101.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 03883BD916
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(366004)(39860400002)(376002)(396003)(136003)(16526019)(8936002)(6486002)(52116002)(8676002)(5660300002)(2616005)(4326008)(66556008)(31696002)(36756003)(186003)(6512007)(86362001)(6506007)(31686004)(2906002)(53546011)(478600001)(54906003)(66946007)(6916009)(316002)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sbCHXPCRszfTOgXS+4HYgwYsy5ND6xhe/G7IzGYDGDxW4hmsRRTI6bxQC2whMzSkY9THimIW216oiq4wRzo5BFcvjFs7NRmXq6OsLQ45wPAVnwm1osViwkHGyMO5B1Ryp16hA06HOo4HzrlmSL0eIlF0kwRL2ebtjysrzzVGdDW4ZKLLxB29mmfvRKpkb2jgw7EM407acjN8+YhklY3OX3TadASXIjv2ISVyAOYkpUyBSN6QN8eiwANGX0uf1X3dB11MN4AAXJoJQ1WaU3V0LuWXehnkdALE4XQglmTPUcdcH3r+yB7Jf0ri1JBv97XNfHWhlWuWK0RzB6MBN6hsQU/ND1RBstE+pd6ajKaGSb+M+Uj/l1q6xwhLe8qMxZERe5MmjgzaXBgB1WU2oQc/VRxVg2w+6WqK1Z7lxpg+E/Zza4qR+EC72udEz0vq/Wo7
X-MS-Exchange-AntiSpam-MessageData: GvmbZdFbrszIhw+7cYuELDAtBPGZJrniGufRZaDXpZEG4jNoxn5bmtw0JBGq6D+Y5HwlOU4fFFtFhFLniTWXjz83Uqj/o4f05VwoqY/gASCAkof1SgeGRcz+pDy2TxDMCNMopvW7R0POZRvIzF/h6+DFrGcLUKD++hOKHxLIvyPYgSbweogH/DblYHVlMOumKQNJrVxT/UMjBzINquGQ+Vm01ja/pUaDC+wgad0pqRrUw0N64+X5wXXfF7N8XuvoIYfG5IIrurak0ycaf8p5XcdEHG8T8K1bmbrQVoTmHu8Hzbbh8iiHtsCgRfaV042kIE0twIuTeqGE+oiogLfBEa6iRPjuCjmcBA5czuCe9OoAb/B7UWaeHUrtKRXvx5SFtkdACwXqjsFXa6oi6TIsMaj4ECv5pYovlocuMeq1JASMKOMPG4sQBO8JKdOUQzK6QcheZH9E8VHSsFsEjGL7fP45+S3jA664W5GNJi4UYmUQTDvTXs2Q0+0sMjiAi3CwSvVElF7+WNhYusSNboWHNbjithDF6RsOZUSEDW9DShMLjSUzrQR22VQh2bCUtJRFYr563TeH+wbH5xMB324k5dlHFtnJa99pcAZxappx3bt6ETk8QgPl9n43bMBg8Emn52ZirnWqdwe8tFvqOKmu/1XEq0ewCwLyJrME99jY9nyC3s7moncr5ztbggl3hxEkZ8yXruLVihDhv/aEATwGmAW8MRGMX77GWbbMlsvAl+bzYpcYUc5vX1P/V777JQDHF/UZbd238Og+MN740xBtTRTrxIzVSiU3XRDXuSCY3cxyEbGjWBixH8e7LJBrQqSrZzUw6NDYmda1z3i3IPEm6A==
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e3379c0-5076-4a28-0df9-08d7ec056d29
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2020 06:20:34.8502
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VFL+530xyvSmxKLIzrcnYDGbcT73Ciov7IZGNTzrCuu1UvUU4A93ipHLjHXFSbQX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4101
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-29_01:2020-04-28,2020-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 bulkscore=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 priorityscore=1501 impostorscore=0 mlxlogscore=999 clxscore=1015
 suspectscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004290050
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/28/20 11:08 PM, Andrii Nakryiko wrote:
> On Tue, Apr 28, 2020 at 10:10 PM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 4/28/20 7:44 PM, Alexei Starovoitov wrote:
>>> On 4/28/20 6:15 PM, Yonghong Song wrote:
>>>>
>>>>
>>>> On 4/28/20 5:48 PM, Alexei Starovoitov wrote:
>>>>> On 4/28/20 5:37 PM, Martin KaFai Lau wrote:
>>>>>>> +    prog = bpf_iter_get_prog(seq, sizeof(struct
>>>>>>> bpf_iter_seq_map_info),
>>>>>>> +                 &meta.session_id, &meta.seq_num,
>>>>>>> +                 v == (void *)0);
>>>>>>   From looking at seq_file.c, when will show() be called with "v ==
>>>>>> NULL"?
>>>>>>
>>>>>
>>>>> that v == NULL here and the whole verifier change just to allow NULL...
>>>>> may be use seq_num as an indicator of the last elem instead?
>>>>> Like seq_num with upper bit set to indicate that it's last?
>>>>
>>>> We could. But then verifier won't have an easy way to verify that.
>>>> For example, the above is expected:
>>>>
>>>>        int prog(struct bpf_map *map, u64 seq_num) {
>>>>           if (seq_num >> 63)
>>>>             return 0;
>>>>           ... map->id ...
>>>>           ... map->user_cnt ...
>>>>        }
>>>>
>>>> But if user writes
>>>>
>>>>        int prog(struct bpf_map *map, u64 seq_num) {
>>>>            ... map->id ...
>>>>            ... map->user_cnt ...
>>>>        }
>>>>
>>>> verifier won't be easy to conclude inproper map pointer tracing
>>>> here and in the above map->id, map->user_cnt will cause
>>>> exceptions and they will silently get value 0.
>>>
>>> I mean always pass valid object pointer into the prog.
>>> In above case 'map' will always be valid.
>>> Consider prog that iterating all map elements.
>>> It's weird that the prog would always need to do
>>> if (map == 0)
>>>     goto out;
>>> even if it doesn't care about finding last.
>>> All progs would have to have such extra 'if'.
>>> If we always pass valid object than there is no need
>>> for such extra checks inside the prog.
>>> First and last element can be indicated via seq_num
>>> or via another flag or via helper call like is_this_last_elem()
>>> or something.
>>
>> Okay, I see what you mean now. Basically this means
>> seq_ops->next() should try to get/maintain next two elements,
> 
> What about the case when there are no elements to iterate to begin
> with? In that case, we still need to call bpf_prog for (empty)
> post-aggregation, but we have no valid element... For bpf_map
> iteration we could have fake empty bpf_map that would be passed, but
> I'm not sure it's applicable for any time of object (e.g., having a
> fake task_struct is probably quite a bit more problematic?)...

Oh, yes, thanks for reminding me of this. I put a call to
bpf_prog in seq_ops->stop() especially to handle no object
case. In that case, seq_ops->start() will return NULL,
seq_ops->next() won't be called, and then seq_ops->stop()
is called. My earlier attempt tries to hook with next()
and then find it not working in all cases.

> 
>> otherwise, we won't know whether the one in seq_ops->show()
>> is the last or not. We could do it in newly implemented
>> iterator bpf_map/task/task_file. Let me check how I could
>> make existing seq_ops (ipv6_route/netlink) works with
>> minimum changes.
