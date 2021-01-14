Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 822022F64B4
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 16:35:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728441AbhANPef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 10:34:35 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:9368 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726602AbhANPee (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 10:34:34 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10EFU1b8018493;
        Thu, 14 Jan 2021 07:33:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=m5Pk5zlyKL9xKJaYtRoQOiIZuGBsLMb8pLNLpqWXemM=;
 b=TlZvb9t2M80GQFNzyEOQ7wl1ygbZZViFxjNAWHrK7qXmYG7mT7CoPRn9YdtahvkU7tvS
 Fl/aiRwFo+KWFpztkBP9VpgbmiuIbH0qkLnZkg8awfTSxtFNYiQHCRGhYcC+hkhBpDgp
 gB7VnwK8VIyzy0lMyxdwdHSCOSsNzWsoJvQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 361fpebd1g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 14 Jan 2021 07:33:32 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 14 Jan 2021 07:33:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MeHhoXjRSiWatxWZlMca/pkLqsJy4KwVlaC2B/XiZtnTjFvGSBrdzYXh5p/Dqo/nURgUx1vewPAS/JgAkImhIMGBanyUlNakVa/qmx+EQQvEJMZKqNvCn62jYqAS09l45yIcxlPZy8dhCN2vnMp4HaOtFRwDheVysPzGd/T3jeHZc5zKigTCsVUaOBw0+W65qODvELFBg5SF4ghkg/D8DbXAQ7tsTfjvVupHu0FqIlswwEH12SvKXmF1GJwcZtDw35dJKxNRaiJOE/VEsdoYGW2biQjxdcz/DLXI1Hg2X0iU4PxyRdWUrrY2QbjGX6E1DRae8pJuebpVckoMbseLkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m5Pk5zlyKL9xKJaYtRoQOiIZuGBsLMb8pLNLpqWXemM=;
 b=eE7dVjVlrHmXr9UDhziWLBLrdi8vky+2+W/ZctNmeIgbyoFaNUfZtodRSDn7xK9SiMJYW6E/E+X3pQ54LajfjImWYdJYg+OZjACGwgzHrQ+NcQzX258yMl880RVlXiapM69CzxI88CcnYJGR4ngFtdG4pMhl/fwDoNCe1sz05rQB4S7oLp8e8I3+Vap2VGWHnj9DSwFEVB0RXlO1BoQbnUsz8Z4fFue3KyoEtWdvDAkY4jxqkknJ0zjk4+Wf68xPJsPcdFNtYIgQsqF7YmWYNSUct2327efayubyPo0hbNsM1Zotm4508sq5NbSGRE/K6Yh/Linfe1Omz/9tXDapfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m5Pk5zlyKL9xKJaYtRoQOiIZuGBsLMb8pLNLpqWXemM=;
 b=XL1jZ95+SasU9aEx24PkyuLGN4DD3xQ8M+1U9BL5HHYR1gTymXF+f/gXHz74hFgsnTPnVO/+wEvZzJkzYIsCjbtq0W7Y4G/z9C7bgy0KkjB6XnOuzLVOuEWgO4D/o+yaJRgiyHH420ozFHi5q8BO7UIe4ymB3SuToJ9MRHLLgFY=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2584.namprd15.prod.outlook.com (2603:10b6:a03:150::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Thu, 14 Jan
 2021 15:33:29 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3763.011; Thu, 14 Jan 2021
 15:33:29 +0000
Subject: Re: [PATCH bpf-next V11 4/7] bpf: add BPF-helper for MTU checking
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <maze@google.com>,
        Lorenz Bauer <lmb@cloudflare.com>, <shaun@tigera.io>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, <eyal.birger@gmail.com>,
        <colrack@gmail.com>
References: <161047346644.4003084.2653117664787086168.stgit@firesoul>
 <161047352084.4003084.16468571234023057969.stgit@firesoul>
 <CAEf4Bzb0Z+qeuDTtfz6Ae3ab5hz_iG0vt8ALiry2zYWkgRh2Fw@mail.gmail.com>
 <20210114155228.128457c7@carbon>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <e0436ecc-542c-0242-bbf7-23ad6350952e@fb.com>
Date:   Thu, 14 Jan 2021 07:33:28 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
In-Reply-To: <20210114155228.128457c7@carbon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:ab59]
X-ClientProxiedBy: BYAPR02CA0027.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::40) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e1::13f6] (2620:10d:c090:400::5:ab59) by BYAPR02CA0027.namprd02.prod.outlook.com (2603:10b6:a02:ee::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Thu, 14 Jan 2021 15:33:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 61a44cfe-f5c6-46c8-500d-08d8b8a1be91
X-MS-TrafficTypeDiagnostic: BYAPR15MB2584:
X-Microsoft-Antispam-PRVS: <BYAPR15MB258465A4DFADE331B608865BD3A80@BYAPR15MB2584.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vDwKoAGd5Z55dwj9hdbthUvbnTJZLtBrH9VHoqQ0p7liad1u3bVvP2QYXFg/+QFvnBvqvW2bhxuFiBaslmlb3hv/JLJBX02I1XDDGZ8P7sJUBk+MeCWvGAA1/t3unndEcnXEAsUAH55/zlz2elNHT0iCqkv1tyqz1a/e7Q9TNPVKcT8/mjBNEC8wJXxo2rJbX5aUKep4lRe1YbAEMiY5R+iUTAw2wuI/usoMSfHGxvwfzdMTfMpndjzFS9dvA9ibPst0Iii/PXUkmPkdevhFpFcajqs0ST6uMxKTcDp4wzmy6RTztCZCVo1CEy7bzCjJq70yWCAyDFt7SKyEf9wpUyZ9Z6kEo6CBziDjFBhcGcExN+2mz5iUR7SEjzdnYSXDUiNanVFQH+tzHRgy40UvDa22Em6QLg90Y49L+XoBw/L767574Z1hf9jsPR8yF25sYJBJjKEWEzoIHjWJZx7bL6rOMKZamweAmfhfFl3DTyg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(366004)(376002)(396003)(136003)(4326008)(316002)(186003)(5660300002)(66556008)(16526019)(54906003)(31686004)(52116002)(66946007)(66476007)(2906002)(86362001)(6486002)(53546011)(36756003)(31696002)(8936002)(8676002)(83380400001)(2616005)(7416002)(110136005)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dGp0eTdWMVJYMk5vb0V4WkJ6VGtoR0hBWlR0bEVTVVJId3BpbU5qL2p4Nm5J?=
 =?utf-8?B?RTVxTkFZa0MyZWQ0aCt0NW16QllOL1VEQjZtcGR5SktkbTM4YkN0MXMyTERt?=
 =?utf-8?B?eWZKMUV1MVRRK2o0SW91MUt0WTBib3VGUGg2bjFrOUpSelcyRksveUVjSFo3?=
 =?utf-8?B?MTl1cGJ5VVR6RHZ2aEpUc2RjeFZsSWU2SUpNMjhxRTVvcmduUmhpVTdiTW9O?=
 =?utf-8?B?YU9VeUxRU1AxTmF5am43ejJ5clZKU0V1OThaYjBvKzlvcHZuVVQ3SzVOcmhx?=
 =?utf-8?B?U01IeWlXVmtnVkNLc21NbDd4ci9OVmlYUnJ5d1VkNXJvYUt3anFUaG1lOEx5?=
 =?utf-8?B?ZWorVFU3bUw1aURzKzhPN1F3VTFsRE1tR004RjZ2dytuZjlua0c2NTA5Wkhy?=
 =?utf-8?B?cFJXVThhem5GQk9DSTFPWWNublVBVU9sdjUvNjdOYzRXQzk4R3ZzQ09HQ0lk?=
 =?utf-8?B?WlNaRFpCdktBVTN3NjB6SExnSUN2ei9Wd1dpN3JWaU9WblV1ZTMzcWpWWWRy?=
 =?utf-8?B?NHFJMGVBWkxheUQwQkpwbnF2SStyZHZ4MEpsRzIzSGYyWU5HK2FKa29wTGZp?=
 =?utf-8?B?R2hsK25CdFNweW1XSkdsVk1CTVhSdnpLcWYyUUFvZmxPR1hQdnRRR3VOTEVr?=
 =?utf-8?B?Q2c5TklaYTkrS0dMTHdPUFlZMHIweU1MQUVFa3B0cFpJTk52Qk9aY3lUbk03?=
 =?utf-8?B?dGlpODh3V2lrYmI1WVRSN3dZSWtMekRTcWF1bTUveGJLdjJFaUhycWZrUVo2?=
 =?utf-8?B?cDZBL2lJUzhVVGtzc2cvbFhxcjVCSEgzbi9SUmRWN2NKY21kUzBiOTA3Q1cw?=
 =?utf-8?B?cHFzSDlSdzBCYWpjeGxaMVZySmhkYmR2bEhKMmh2elBlbm1idXFLY05HVGZF?=
 =?utf-8?B?eGc2WnR0dTlLZlJKY2tFdzY0K3dFYVFNTS9PbS9TYjR3L3k4bThweU9KSFh0?=
 =?utf-8?B?VSsvZTNmUUlXbXFtL2RmT2xwVnVLbzB1Rk9zd2Q5aGZjZGljUkx5cENhSmht?=
 =?utf-8?B?R2JUQ2hBelpyVDhwcjdPWUxNd2tVM3ZkYnAza1p1cElhUmYrSFVrYmovTGtt?=
 =?utf-8?B?bEtQakI3WFJWMlRnL2tRN1BjT2NtWndkTWFUM3RwT3VKR0Irck9nMnRGME9F?=
 =?utf-8?B?elR4TTdSb2M4SGZEQWJZWUN4RTlkMDBjSFF0NkZuSzhqSFlUWkVjKzlvbXZV?=
 =?utf-8?B?eVpxZCs5LzdZa2tORDJ3b1BmMm50TSsyRjFwZG80dDROMWtvWnZES3BXdmtq?=
 =?utf-8?B?VE9RZ2U4VUhyaWpMNWdRay8vNlY5c1pkN1BTUk5RN1dDMlBhNjFXYVRmby9a?=
 =?utf-8?B?dFFtYmJKSDZyekpHS2ZTWGZyeUJnVm10L0FkVm9GT1V6TnJKNC9YSXMrTlEv?=
 =?utf-8?B?UUFTY3lpQ2JCS3c9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2021 15:33:29.8405
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 61a44cfe-f5c6-46c8-500d-08d8b8a1be91
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DtSzo8Ns8lMdTVHAU0p/uXNG/mOCb0+tjVraAhunc4E2WbehBZDUx1458r19JRvk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2584
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-14_05:2021-01-14,2021-01-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 clxscore=1011 mlxscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 impostorscore=0 malwarescore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101140090
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/14/21 6:52 AM, Jesper Dangaard Brouer wrote:
> On Tue, 12 Jan 2021 11:23:33 -0800
> Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> 
>> On Tue, Jan 12, 2021 at 9:49 AM Jesper Dangaard Brouer
>> <brouer@redhat.com> wrote:
>>>
>>> This BPF-helper bpf_check_mtu() works for both XDP and TC-BPF programs.
>>>
>>> The SKB object is complex and the skb->len value (accessible from
>>> BPF-prog) also include the length of any extra GRO/GSO segments, but
>>> without taking into account that these GRO/GSO segments get added
>>> transport (L4) and network (L3) headers before being transmitted. Thus,
>>> this BPF-helper is created such that the BPF-programmer don't need to
>>> handle these details in the BPF-prog.
>>>
>>> The API is designed to help the BPF-programmer, that want to do packet
>>> context size changes, which involves other helpers. These other helpers
>>> usually does a delta size adjustment. This helper also support a delta
>>> size (len_diff), which allow BPF-programmer to reuse arguments needed by
>>> these other helpers, and perform the MTU check prior to doing any actual
>>> size adjustment of the packet context.
>>>
>>> It is on purpose, that we allow the len adjustment to become a negative
>>> result, that will pass the MTU check. This might seem weird, but it's not
>>> this helpers responsibility to "catch" wrong len_diff adjustments. Other
>>> helpers will take care of these checks, if BPF-programmer chooses to do
>>> actual size adjustment.
>>>
>>> V9:
>>> - Use dev->hard_header_len (instead of ETH_HLEN)
>>> - Annotate with unlikely req from Daniel
>>> - Fix logic error using skb_gso_validate_network_len from Daniel
>>>
>>> V6:
>>> - Took John's advice and dropped BPF_MTU_CHK_RELAX
>>> - Returned MTU is kept at L3-level (like fib_lookup)
>>>
>>> V4: Lot of changes
>>>   - ifindex 0 now use current netdev for MTU lookup
>>>   - rename helper from bpf_mtu_check to bpf_check_mtu
>>>   - fix bug for GSO pkt length (as skb->len is total len)
>>>   - remove __bpf_len_adj_positive, simply allow negative len adj
>>>
>>> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
>>> ---
>>>   include/uapi/linux/bpf.h       |   67 ++++++++++++++++++++++
>>>   net/core/filter.c              |  122 ++++++++++++++++++++++++++++++++++++++++
>>>   tools/include/uapi/linux/bpf.h |   67 ++++++++++++++++++++++
>>>   3 files changed, 256 insertions(+)
>>>
>>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>>> index 649586d656b6..fa2e99351758 100644
>>> --- a/include/uapi/linux/bpf.h
>>> +++ b/include/uapi/linux/bpf.h
>>> @@ -3833,6 +3833,61 @@ union bpf_attr {
>>>    *     Return
>>>    *             A pointer to a struct socket on success or NULL if the file is
>>>    *             not a socket.
>>> + *
>>> + * int bpf_check_mtu(void *ctx, u32 ifindex, u32 *mtu_len, s32 len_diff, u64 flags)
>>
>> should return long, same as most other helpers
> 
> Is it enough to change it here?
> (as this will be used for generating the helpers header file,
> via ./scripts/bpf_helpers_doc.py --header)

Just change here is enough.

> 
> Or do I also need to change bpf_func_proto.ret_type ?

There is no need to change bpf_func_proto.ret_type.
RET_INTEGER already implies 64bit scalar.

> 
>>> + *     Description
>>> + *             Check ctx packet size against MTU of net device (based on
>>> + *             *ifindex*).  This helper will likely be used in combination with
>>> + *             helpers that adjust/change the packet size.  The argument
>>> + *             *len_diff* can be used for querying with a planned size
>>> + *             change. This allows to check MTU prior to changing packet ctx.
>>> + *
>>
>> [...]
>>
> 
> 
> 
