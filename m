Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF166A4DBB
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 23:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbjB0WF4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 17:05:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbjB0WFy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 17:05:54 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6509298F8;
        Mon, 27 Feb 2023 14:05:43 -0800 (PST)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31RHYiaR011998;
        Mon, 27 Feb 2023 14:05:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=b4L65mn6sAPTAVDfZ7m580ofyVU/f092/iX4wEW1CO8=;
 b=P4tXXZWILRZlKcmNQb6WtjE9vu/ZjkOb2G5Y25Fg6F1WcFZEtkStHUhUW/Cr8mDPuIJa
 pIA/0MF/tpvBh4RycCCPeh/la7rTpjnLDwHeimH3khzRZ5NfYp0+RrDklYp1OLe5Q8pp
 NF1rwJrm6CekyiWNpXEPi9wRvLACn+IemZAz79BK8SRCYvPXS9VGnRsriDtRmaY40ayM
 9dpage+4dKbc57G/IGS7ezyF3E7oTIU3NFollvI7/HfpEJ17PT1NjlCS1ENY3chI7auL
 p4glfzxqMK9rmY3gfsr++gL9c6PoTY8V6FaeiCcCR2dUIorSfltbA+sRc3hmZ2oMWr9S mg== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3p109djja1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Feb 2023 14:05:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DEobAL8ZCR7zU8irnH/1ys+vSYWe7C5RicKOarhpCAi9GThGBy6Ky4aQ94KWGnMh6pPinvs3sPFkPXzcRyCe1mU2Chdp/NkooYkiTHcs8JIDPYGxEXcLV5cLx7Lti+NCiEueAVs0G0mFRD3wPZhR3nKMm8Qdt46vN2BW1ZXpT9z2JWcR9ZB4p23MthcyiQSdXges1xjMWI4ekpp2MC94WWfW52p+49oh/bKeY7P2mco9AYE7qfCErkvnCjf9m1u+yJxSGMrIljezjL9Qwr7ehMhSn6W44OhsXG7bl0JXUznhJ2CvoJ69sT4Cr8D/6uW0li+Y5mewVAia5u2RBW+7jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b4L65mn6sAPTAVDfZ7m580ofyVU/f092/iX4wEW1CO8=;
 b=WVAiC48V2GREcMg+pMjaqYibuchQ4KCGlc9MveJklq1oDjl4+zDkaRLlh2Bogc1RLtAVKI2UiIvesbEibDaLpFBhAwbFDG/zuUG3O97FnZBXF3frVv+68X3wWbhAV3KGgdfrxivLWWuJQzcdoK3dgKZ1ihCbuBqykg8K7Uo8JXAQqYWDBCDtbJZROFp6zOiD3z6chRyDdt3fuzsUcljhZm3I1PqhS25NDq4q03Jp3GTZz2jVweAPSvUgZsSIY8DjNKEStKxFDWhGupuwz5DDXOWbY+mXpDHpetzVJKmahlBGzIR6cqn1iUBZjsD2Q5DhyAposgnB750LqD3ZgXvNsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by CH3PR15MB5891.namprd15.prod.outlook.com (2603:10b6:610:12a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.26; Mon, 27 Feb
 2023 22:05:25 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::a595:5e4d:d501:dc18]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::a595:5e4d:d501:dc18%4]) with mapi id 15.20.6134.029; Mon, 27 Feb 2023
 22:05:25 +0000
Message-ID: <6b008033-9c97-7f46-310f-1b1ad74a8af6@meta.com>
Date:   Mon, 27 Feb 2023 14:05:21 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH v5 bpf-next 5/8] libbpf: add API to get XDP/XSK supported
 features
Content-Language: en-US
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kuba@kernel.org,
        Martin KaFai Lau <martin.lau@kernel.org>
References: <cover.1675245257.git.lorenzo@kernel.org>
 <a72609ef4f0de7fee5376c40dbf54ad7f13bfb8d.1675245258.git.lorenzo@kernel.org>
 <e519f15d-cdd0-9362-34f3-3e6b8c8a4762@meta.com>
 <CAEf4BzY0sHqEXaY8no0VgwEbNoPEaQz0h53Gav=T1DCsjsjo8A@mail.gmail.com>
From:   Yonghong Song <yhs@meta.com>
In-Reply-To: <CAEf4BzY0sHqEXaY8no0VgwEbNoPEaQz0h53Gav=T1DCsjsjo8A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ClientProxiedBy: BYAPR05CA0073.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::14) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|CH3PR15MB5891:EE_
X-MS-Office365-Filtering-Correlation-Id: a04c3a34-5ab5-4179-c70b-08db190eba93
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SfrkqxuBPXdhumu29IHkh4YITb6tecH4AaY3tssiKfs5KW8qqiTDBbYAqeGWYLyAHuBaKzSaoFBWljBJ/hxFKIo6vWTjfWxHiwtmHw7wYyASCVQmw0uM6UT4eiaWfy9rxW/zHCw1OYWGrEJVUg+4i87pdxdVUeAlBHxJBb+H9gUgoLTs3aZutQ95hnDEF4ax52PU/dNhfcuS47YO0JvjnyRu8j+RDJzCiISmp44JHHTWD7LZ8XyChLIrO5FXOq9zwk4gKACu4MUGYyRnriSqgJ0JSX8eZfqkKfV0gSJD8BIV+C3NSRZNrDyK+WUy6upTJ7SVgGmAUEv2+Im1TVnhr3cAZbaeLk+G9ukIAydrkxLgEht94i/w1Bv/+ABKpaE3LbFftV2nEccS+c6RMQLfx/HLy2mA661reVT2pgylMwJ4mqa9v8GKbx296BH03fRLkmCDu1XH+jsW6s3cOMTtM0w8Xdeg4R+WPXUPX6TKRtokG3wj9o4aTjUDJPDkVUd4UM8HfaCQubJZWbsIa72DiqPYQ9pxLf/GGHlsxKpTS9SQYkhEePpdQzHi3EKMgkIhbqp2DnJkeIPedkEpvsqfl2f4jAGyZSxl5uBRa3MZl0jwymOUaDOo7LTqisQXycocItsltpOwbc4tobdleP/tf+qZeJqilFk7JbufeIWPWL6MWUI93EmAfA/txlP2/zfH2mwf7PVneunjsZaMEayDf4lTnSi7N2q/HMOafvH4aWo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(366004)(396003)(346002)(136003)(451199018)(31686004)(478600001)(66946007)(4326008)(66556008)(41300700001)(6916009)(8936002)(66476007)(8676002)(36756003)(31696002)(86362001)(6506007)(186003)(6486002)(53546011)(6512007)(38100700002)(6666004)(2616005)(83380400001)(2906002)(5660300002)(316002)(54906003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R2gyV1E0ZkhzVkhyYXdVQWdtY0xtRmpoSGFWN1lBRmdsSVJXUmY1cngrR2ZF?=
 =?utf-8?B?QU42cStyVmtxK3N0TnM2eFRnV29ESzJxNHpSb3ErTWY3a0xuaVQyQXB1SEtr?=
 =?utf-8?B?L1JLM21JK3pidHRKbm45NTE2dzJlZGhZRE5FbDdldXFqT1dNd0tiTVBBYUxV?=
 =?utf-8?B?SDBFa2xsbjZxcWpkelA0SXVGTWlJT3Jya0FrTmE3dDBBMGh4dFZMYnlxRi96?=
 =?utf-8?B?VXIzQWFuQk5raDFvQjZrZ3A5Y0N6NEFIOEwwWXY1cGRnSUJuTzlkdGNjRDNE?=
 =?utf-8?B?QlJSQmM0b3U0WEs2YlhMZ1lvdVI0dFh0eHk4REdLeHVUTXVpb3orQUZ6SG51?=
 =?utf-8?B?bThzMlhhNS92TGVIdFJraTVVemdDdCtCMUNyNDhEUlpicnpBUi9SYThnL0JD?=
 =?utf-8?B?dlVQVlFMZE5xNGNQcGNlQTF1QzM3cEpRaitBVzZwTXJINFNKRFY0N1paL21L?=
 =?utf-8?B?VnZJRlZjWDF4aE5rbFdwV3ZqUmNpYXJFVjMxdUxaKzdiTDN2VXFnWDhtaFhr?=
 =?utf-8?B?QVR0aUtwMWhia2ZUcXA2QmxuNExSK3YyYXVac0I1c3NYSnRIcE5SdU5acVlE?=
 =?utf-8?B?OTVBVU5kUkJoZzZkQnZoc3NnNHlIWk13VjcwRllqYWdLV3dWOC9NWWlHTXU3?=
 =?utf-8?B?dUV1NVZLdnVuZDZPdUdtMm1HNkNNNy9YUXRQYlh1dGx2WFdwTURDSDdSSGxO?=
 =?utf-8?B?Ynd0UVROTFJLQTNmZW13Y2E4eGNiVURlQmZlek1kc3BjcGxBSjJ6V2FYWUI4?=
 =?utf-8?B?YzlTaDBqQlNyWUJmZHdWa1RHZ3JjekNlZlk5RFpaQzdqcHRzdnpSR2RJaGxM?=
 =?utf-8?B?OGdBWEQ1SWZGSEVEMktRTFlkU3o2RS9KL3Q5MXN5U3BlWldUNlgyYnlUSkdR?=
 =?utf-8?B?cFQvM0F2L3NIVlVBNElZSEdsZElXNmdrU3d1ZXpsdXNvNmFNREphbXBIVTB0?=
 =?utf-8?B?YmgwbkFNVFRiUWR3NlNqVWd2WkhMMHc2QnVzcjlvOEl0a0RaaXZ3UlZFc2d1?=
 =?utf-8?B?SXc2TVRUM1RlODl4MHhPNlpMZ0hHLzluQ0xqNlNwdlNRUWVmTTYweU5KWk4w?=
 =?utf-8?B?Q2l2LzVXOHhnVi9aK3lkK2F5VkJYaWh0MXA2VnZ3c253OUVybkN4dDdRM2pK?=
 =?utf-8?B?cDhlbjE5LzZjUDYyUHBSbmw5dXBoQm5BVndBamswRU82TmxvZUk5eXVKaElM?=
 =?utf-8?B?QlNJck9DVnpxMU90TWNaanZMNnEyZlVpbXF4VWFWNERMU29HSGthUGFZRFYw?=
 =?utf-8?B?cy9yRElnOE0rSXc2U0dSYTd3RGEwcE1ld0t2QVVoK3ByN1ZDUkxjMmlKUDQx?=
 =?utf-8?B?Zmw5R3BKNDRKK1NweXEvcHVFOFhVcnRtb3N1VFlBVzhzTFpnSUdYbi85aVVM?=
 =?utf-8?B?RHovbjgzNE03YmVFNGNheFc0VXJxNGFycThqOU1kT092dzhybHdtTHpMSDhv?=
 =?utf-8?B?c3VySGZCaVpGVWFBL3BTNUpTRVZZeGEyblE1cmVrUzdLeFdtbDlIVyt5eEJ0?=
 =?utf-8?B?UUdZZWlLNFU3R1p2VVp3a2ZQcEdNSmZuVzlsaTBlUDY1amdIN3RIek9zOXQz?=
 =?utf-8?B?cEl5UzVOUUFxN3VZTnlUWlZRN2RUbW1NRkphNW4vcXN6aC9BN1J5VGFzR01E?=
 =?utf-8?B?UlFKcDBlelk3cWhXdTRianFmT0xGY0hmNmVWM3AvT0phZnRtQ2I4dVBieWtW?=
 =?utf-8?B?d1ZHWWhlUW1PcHYzSS9xaUo2R0hhM3hxVkY0bVNnbkF0clpBUk9sc3ZSeHF4?=
 =?utf-8?B?aVJBblpJZlRWNU9Bd0dKR0JkQUlEbHRtbXozQUpURnF4U01pd3RCNE96S2kr?=
 =?utf-8?B?VElqdzRJSzVSaDhzVDNUODk3Q0tzQyt3VW5qenhxMEg0N21DUTlmckVWUGt6?=
 =?utf-8?B?TDhMSmxqUFdtZ0U0TEhCZU91LzFjR2wrMHNrZkNqcjQ5OExRVG1MZGFpTzFy?=
 =?utf-8?B?VGFCZU4rVDUwVWJ6M2ZyT1dXSkFudWtqVXV4RHhsYzNXM1YwOTgrOVZNdjhR?=
 =?utf-8?B?bjJkbW84UVJ0M3lRa0l0T3UrMXl3QmhBelhuaGlzdlV2OWlXV2cyUzc4bTZo?=
 =?utf-8?B?ZitLZ0lCMVR6djgvaHZaS2lqZE5iQnhvaEV1L0l4UUtONEhoY2pkY0oxVE9w?=
 =?utf-8?B?S0NiV0l6dEx4WXJiLy9qTlNqQUZJWkRMd1pHZHFxT3oyTjFXcllMWmw5eTFH?=
 =?utf-8?B?eEE9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a04c3a34-5ab5-4179-c70b-08db190eba93
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2023 22:05:25.4790
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R//Wr2jJvgL1SO06zl3pvgl8t20gl9FxnhhGIduWQFP8IBbuF2XXW89sCwOKxAbI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR15MB5891
X-Proofpoint-GUID: yI_UoP1wKYUFht5cJ28RkcR1Q4HUYcAq
X-Proofpoint-ORIG-GUID: yI_UoP1wKYUFht5cJ28RkcR1Q4HUYcAq
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-27_17,2023-02-27_01,2023-02-09_01
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/27/23 1:01 PM, Andrii Nakryiko wrote:
> On Mon, Feb 27, 2023 at 12:39 PM Yonghong Song <yhs@meta.com> wrote:
>>
>>
>>
>> On 2/1/23 2:24 AM, Lorenzo Bianconi wrote:
>>> Extend bpf_xdp_query routine in order to get XDP/XSK supported features
>>> of netdev over route netlink interface.
>>> Extend libbpf netlink implementation in order to support netlink_generic
>>> protocol.
>>>
>>> Co-developed-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
>>> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
>>> Co-developed-by: Marek Majtyka <alardam@gmail.com>
>>> Signed-off-by: Marek Majtyka <alardam@gmail.com>
>>> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>>> ---
>>>    tools/lib/bpf/libbpf.h  |  3 +-
>>>    tools/lib/bpf/netlink.c | 96 +++++++++++++++++++++++++++++++++++++++++
>>>    tools/lib/bpf/nlattr.h  | 12 ++++++
>>>    3 files changed, 110 insertions(+), 1 deletion(-)
>>>
>> [...]
>>> +
>>>    int bpf_xdp_query(int ifindex, int xdp_flags, struct bpf_xdp_query_opts *opts)
>>>    {
>>>        struct libbpf_nla_req req = {
>>> @@ -366,6 +433,10 @@ int bpf_xdp_query(int ifindex, int xdp_flags, struct bpf_xdp_query_opts *opts)
>>>                .ifinfo.ifi_family = AF_PACKET,
>>>        };
>>>        struct xdp_id_md xdp_id = {};
>>> +     struct xdp_features_md md = {
>>> +             .ifindex = ifindex,
>>> +     };
>>> +     __u16 id;
>>>        int err;
>>>
>>>        if (!OPTS_VALID(opts, bpf_xdp_query_opts))
>>> @@ -393,6 +464,31 @@ int bpf_xdp_query(int ifindex, int xdp_flags, struct bpf_xdp_query_opts *opts)
>>>        OPTS_SET(opts, skb_prog_id, xdp_id.info.skb_prog_id);
>>>        OPTS_SET(opts, attach_mode, xdp_id.info.attach_mode);
>>>
>>> +     if (!OPTS_HAS(opts, feature_flags))
>>> +             return 0;
>>> +
>>> +     err = libbpf_netlink_resolve_genl_family_id("netdev", sizeof("netdev"), &id);
>>> +     if (err < 0)
>>> +             return libbpf_err(err);
>>
>> Hi, Lorenzo,
>>
>> Using latest libbpf repo (https://github.com/libbpf/libbpf, sync'ed from
>> source), looks like the above change won't work if the program is
>> running on an old kernel, e.g., 5.12 kernel.
>>
>> In this particular combination, in user space, bpf_xdp_query_opts does
>> have 'feature_flags' member, so the control can reach
>> libbpf_netlink_resolve_genl_family_id(). However, the family 'netdev'
>> is only available in latest kernel (after this patch set). So
>> the error will return in the above.
>>
>> This breaks backward compatibility since old working application won't
>> work any more with a refresh of libbpf.
>>
>> I could not come up with an easy solution for this. One thing we could
>> do is to treat 'libbpf_netlink_resolve_genl_family_id()' as a probe, so
>> return 0 if probe fails.
>>
>>     err = libbpf_netlink_resolve_genl_family_id("netdev",
>> sizeof("netdev"), &id);
>>     if (err < 0)
>>          return 0;
>>
>> Please let me know whether my suggestion makes sense or there could be a
>> better solution.
>>
> 
> feature_flags is an output parameter and if the "netdev" family
> doesn't exist then there are no feature flags to return, right?
> 
> Is there a specific error code that's returned when such a family
> doesn't exist? If yes, we should check for it and return 0 for
> feature_flags. If not, we'll have to do a generic < 0 check as
> Yonghong proposes.

We can check -ENOENT.

         err = libbpf_netlink_resolve_genl_family_id("netdev", 
sizeof("netdev"), &id);
-       if (err < 0)
+       if (err < 0) {
+               if (err == -ENOENT)
+                       return 0;
                 return libbpf_err(err);
+       }

Let me propose a patch for this.

> 
> 
>>
>>> +
>>> +     memset(&req, 0, sizeof(req));
>>> +     req.nh.nlmsg_len = NLMSG_LENGTH(GENL_HDRLEN);
>>> +     req.nh.nlmsg_flags = NLM_F_REQUEST;
>>> +     req.nh.nlmsg_type = id;
>>> +     req.gnl.cmd = NETDEV_CMD_DEV_GET;
>>> +     req.gnl.version = 2;
>>> +
>>> +     err = nlattr_add(&req, NETDEV_A_DEV_IFINDEX, &ifindex, sizeof(ifindex));
>>> +     if (err < 0)
>>> +             return err;
>>> +
>>> +     err = libbpf_netlink_send_recv(&req, NETLINK_GENERIC,
>>> +                                    parse_xdp_features, NULL, &md);
>>> +     if (err)
>>> +             return libbpf_err(err);
>>> +
>>> +     opts->feature_flags = md.flags;
>>> +
>>>        return 0;
>>>    }
>>>
>> [...]
