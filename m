Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C41C2F82AE
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 18:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729030AbhAORmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 12:42:09 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41254 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728176AbhAORmJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 12:42:09 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10FHcYYG002345;
        Fri, 15 Jan 2021 09:41:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=vLzz5vyYK3DKUBAxAOn+POKYw42VXNsFMf0xv2vAM5E=;
 b=MQ9XtYPCTib5UAQCFtdM/5CQR9yqkI/02GhS/KLlHwNbH71JFuu3wihGs7Zy3/iE2+tZ
 HpioVgWec4RYLAum+pfr590bxhApQRMwDOIiQpjMcpYaRh5Vlo2bcydXXkNVsxYUPoFJ
 h+TZZpHn7HDhwVB1r3/pHi+Le2LKykcQPCg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 363e4frksj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 15 Jan 2021 09:41:12 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 15 Jan 2021 09:41:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q5wxbnCP3j/z4yRVsm+4XmL1DaQWRanE9I/HCbyYOc4fF5mN1S1cE0aYXNIFDe122ONSGvTh5B72Lk8eXTGEGUhctOoJsk/ibb+nf0QgU3/zazgxt57LySyFvQjTXYCuj0dV2Tm0QAMkN9YcIzVRY7wSP//Fv2MDldM9XZ7sON5jZPDGqspJY5D86+QFdr8rtkhmlHjNAbRgkz0eO7IBnoQmAR3Dca0RLXag0Bzq3+mGEwNWrbb6TfDX6ne71V7GnabgOXlpj53JxKJ/k/sms8zz4DQr3kRdiISCNfb0zLgRgl+BxokyLmO+jMwSMRZu3oNoJR9Q0vq/M+SAASNeow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vLzz5vyYK3DKUBAxAOn+POKYw42VXNsFMf0xv2vAM5E=;
 b=Df+gqLIJtsYniGd7dvSraKDN8i+tvi/9Y6oCH4CaaOE13eSC3iYqPeRfL71IEJOM1JwGt0J4hx/vf451O4kEOtFHwHOdxR57JAVwE1iS/fMXutwFBy6DH3A7r6JVh+PBvuFA597AR857Jqep4UdO8ZT4vPNRbrGW6MUTw2HXnKnkdgG9DdorbeZbd7U6N9d9nYamnH9R3Pkbia8A4Mvo2U7n9nQny495J17FobhrLIotCLOk+m+9xXlPKb52EScrQpEyTwEXoAGmIeyODYiK6IwafS5thiZL4qjlJ206Aa/7LebWKxa5uhgLxvi4Bt2lSEq2EvClaoojRc78no0uzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vLzz5vyYK3DKUBAxAOn+POKYw42VXNsFMf0xv2vAM5E=;
 b=A0z6NbyA3b7QZEE+b1HrKuV4Fv9YpQ8fztvxCNVm7zPmwb1A9Ar845/M/huVHv2+O7OgYX4VG+3fWDcoTX7tXudZ7cVP+CES+ahVYwXpgEZVlEBBBQZK9L7LGr81cmQ2Ozk2MspFUs+FpRhSfPWRPWrI1oFqO4PrGTD2vUHvd28=
Authentication-Results: iogearbox.net; dkim=none (message not signed)
 header.d=none;iogearbox.net; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BY5PR15MB3715.namprd15.prod.outlook.com (2603:10b6:a03:1fe::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.12; Fri, 15 Jan
 2021 17:41:09 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3763.011; Fri, 15 Jan 2021
 17:41:09 +0000
Subject: Re: [RPC PATCH bpf-next] bpf: implement new
 BPF_CGROUP_INET_SOCK_POST_CONNECT
To:     Stanislav Fomichev <sdf@google.com>
CC:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
References: <1627e0f688c7de7fe291b09c524c7fbb55cfe367.1610669653.git.sdf@google.com>
 <CAEf4BzZOt-VZPwHZ4uGxG_mZYb7NX3wJv1UiAnnt3+dOSkkqtA@mail.gmail.com>
 <CAKH8qBuvbRa0qSbYBqJ0cz5vcQ-8XQA8k6B4FS-TNE1QUEnH8Q@mail.gmail.com>
 <CAADnVQJwOteRbJuZXhbkexBYp2Sr2R9KxgTF4xEw16KmCuH1sQ@mail.gmail.com>
 <500e4d8b-6ed0-92a5-a5ef-9477766be3e4@fb.com>
 <CAKH8qBuZ0iLAiuqi=65RBiQ=Vhi3qkitPzj0b7U=XuiH_4TuLA@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <f3661770-65dc-05f2-a580-199580eb0b74@fb.com>
Date:   Fri, 15 Jan 2021 09:41:06 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
In-Reply-To: <CAKH8qBuZ0iLAiuqi=65RBiQ=Vhi3qkitPzj0b7U=XuiH_4TuLA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:bb30]
X-ClientProxiedBy: MWHPR11CA0005.namprd11.prod.outlook.com
 (2603:10b6:301:1::15) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::1366] (2620:10d:c090:400::5:bb30) by MWHPR11CA0005.namprd11.prod.outlook.com (2603:10b6:301:1::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Fri, 15 Jan 2021 17:41:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dfffb5ee-f181-4f13-1d57-08d8b97cbe5d
X-MS-TrafficTypeDiagnostic: BY5PR15MB3715:
X-Microsoft-Antispam-PRVS: <BY5PR15MB3715760F3C546209697AFD75D3A70@BY5PR15MB3715.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bZnW+KhgkECrQQvUTqvgsUo2jBIea5cx/YbjQP9ci9W9451m3kHvfZ7ABo6sJ0tShQ163PLoqAcpslI352+E0MByJJZ/TXni8o+ygV1s+qh/pvdLdWeSQXDseUFUQWYNu7SuapEjU0rvu+gyErMdqgMwefJ+5IfwNeI8NNJvAHxdcTsQonUV1P7ZxxlIWvZMnHJoqlmM9M2rzAfhE+aiPxCnbz218roj73Ml/7zA80SARk6jZM7dpkCsGFdl/8lz9Ije5sKd+l+SuhB5ygL/0lhioITr6SwviQenmZAkeRcM7OJlP2xwDe8Ez0Dg2iEQ9l9+U9zdlSxihUgPvKYI6mlxPYrNK5JLb1gTzs3/HnOTiLjsNTrxUsTSkDJmuWbttrgUXXGB8aB7x9abr7/+nUIzqrGtVY4W4RkmrXmH3HFadSY/mVYM20X8vJrkGXyLBktRUladqBZobNfj1FO+fLesd4IodUvmUhB7sQoCmbY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(366004)(376002)(136003)(346002)(52116002)(86362001)(66556008)(31686004)(66476007)(8676002)(54906003)(6486002)(53546011)(6916009)(316002)(31696002)(478600001)(8936002)(16526019)(66946007)(5660300002)(2616005)(186003)(2906002)(83380400001)(4326008)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RzZPWFZPekd1bkJrVk10ZHlCSlF2UUUvUmRidU1SVzRGaDVzRlVhM2ZKLzJW?=
 =?utf-8?B?UFhndm5NR0FkaUJjOWk1aGtIMktTKys1QWZNWUVYU0RNL25CQTNhWTBMV3VF?=
 =?utf-8?B?QldJSnI4SlFLb01OOUtQMnhhN0p5VGdmeFpCcmFPaXFFcGxMVjR0RGY3YWcw?=
 =?utf-8?B?bERBZTZzRDNTalVVTnRZRlV2MXowaklZbE9nMXlqQTk5NVZwN09VdVQ1bFJL?=
 =?utf-8?B?Yng3T3dZV0RnNnVFSUZFYTZqOGlnMVN3ZXZOQThNbzBEQTVCWGxUNXpQeFRp?=
 =?utf-8?B?RkJtc0UyY1RVc2doMys4a05NY0ZyUEhBNkJwbVNEc3lOQ01MK3NyeGppV211?=
 =?utf-8?B?YUJQclBtSDdwTGR1bmFnbGg1cEU2YkhCSjNEa1NnZmpBOTAzZ28vRDVBZ2tK?=
 =?utf-8?B?QkNHWUk5a2IyejJDNmc3RFg0V0VhbEIzYTBML21ZY29tVW4zLzlGU1Y5dlJK?=
 =?utf-8?B?R0hIZEJ0VVhCcWszZ2VBNVBkVVl4dEtkcGtjVXc0QTFlL25QaENDZ0p1U2ZW?=
 =?utf-8?B?TnM4OURtck0rbW5GdzM3ZHAyVXNYSkwzdC9rSDhyemJybE9lbjA0ZVZsaWxC?=
 =?utf-8?B?M2VGRTA1bzI4Z0N3ZkJ3ZFRoSGJaeVVzMlBRR2xwS1ArQzZ1ZEZQRHdiV0dt?=
 =?utf-8?B?T0kyRVdpbGRLd2Z6N2FPZmh3NmY1dGVZZ0dwQzBtRnYxa2J2WFV3aURobFVB?=
 =?utf-8?B?SzRRNnh1cDdsczJCdFRhdGlZQnpOM0ZwNWxXanhNdm92TkhPT0RUUjFzaDM0?=
 =?utf-8?B?N0NmaG9Iakx1eWZ0Q0M1dHBneGFzY3FDMnI1Nko4N3l2OW9XNGNnOUxsOGp0?=
 =?utf-8?B?VnR0dUFQWUtuVkFHNkJXa2JiTzd4QTNmUEVOVDVVOTlyNks0OHVvZUg5ajYy?=
 =?utf-8?B?OWhPTmU1RlpRSGpFVVRtSkhtRVNGamJ2NjZDQlg4dGxmTEpUU2hxTzdBZXNU?=
 =?utf-8?B?bHRDeGoxbXBGclhUUnVoNzcxQ3BIT2VDRXBZbktlc0swNEd6V2xpYWk3bXhp?=
 =?utf-8?B?UDdxQWJOREg1K2NvTFMyL0RtRDNvNWQwT1BibVg5a29nZXJvK1didzE5UzM5?=
 =?utf-8?B?RHlZVUYyNi9SSy9aNHlKd2ppdnhDWGcwSWxVQkxyU3ZDbzVmQ3I2TXRDRnRh?=
 =?utf-8?B?Q1lTUWdscU1rckk3NnlBc04wZFUrN0tTNk5SS3hCeGlQaVFuMUVuRFdKWWh0?=
 =?utf-8?B?Y01LMmdHa29ScDRwNE1JdjVoUTNjTzltMjVtdUxCYml2dU1neHorVGtpNmJ6?=
 =?utf-8?B?dzE0SmxHd0p6MmRzR0EzMVYrV2w1YlRBNFNoWVg4dnFOSE0zUWlBKytWQnhQ?=
 =?utf-8?B?TDdSc2U3NnJsckhwVzl2UldsSVBzMFBvRWltLzMvcFNsYlphRmQrYytodHBy?=
 =?utf-8?B?RmdnUnJOWUpNdXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dfffb5ee-f181-4f13-1d57-08d8b97cbe5d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2021 17:41:09.5121
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AcpcKUq6uDjKf4DUeYWOvBw+7c3Y7GDDNNL0EyUFcK5yC9HBEhnjRUREvw6FQmHo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3715
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-15_09:2021-01-15,2021-01-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 impostorscore=0 phishscore=0 adultscore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101150107
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/15/21 8:39 AM, Stanislav Fomichev wrote:
> On Thu, Jan 14, 2021 at 8:27 PM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 1/14/21 7:59 PM, Alexei Starovoitov wrote:
>>> On Thu, Jan 14, 2021 at 7:51 PM Stanislav Fomichev <sdf@google.com> wrote:
>>>>>>
>>>>>>           lock_sock(sock->sk);
>>>>>>           err = __inet_stream_connect(sock, uaddr, addr_len, flags, 0);
>>>>>
>>>>> Similarly here, attaching fexit to __inet_stream_connect would execute
>>>>> your BPF program at exactly the same time (and then you can check for
>>>>> err value).
>>>>>
>>>>> Or the point here is to have a more "stable" BPF program type?
>>>> Good suggestion, I can try to play with it, I think it should give me
>>>> all the info I need (I only need sock).
>>>> But yeah, I'd rather prefer a stable interface against stable
>>>> __sk_buff, but maybe fexit will also work.
>>>
>>> Maybe we can add an extension to fentry/fexit that are cgroup scoped?
>>> I think this will solve many such cases.
>>
>> Currently, google is pushing LTO build of the kernel. If this happens,
>> it is possible one global function in one file (say a.c) might be
>> inlined into another file (say b.c). So in this particular case,
>> if the global function is inlined, fentry/fexit approach might be
>> missing some cases? We could mark certain *special purpose* function
>> as non-inline, but not sure whether this is scalable or not.
> For this particular case I don't think it matters, right?
> I'd like to fexit ip4_datagram_connect which is exported symbol,
> it's accessed via proto->connect and there is no way it's
> gonna be inlined. Unless our indirect call macros give clang
> a hint :-/

You are right. It is called through indirect call and by default
compiler won't be able to do inlining. One possibility is profile
guided optimization which often profiles indirect call as well.
They may find the indirect call has one call happening in say
80% and will special case that one and may do inlining. not sure.
I guess kernel build in general is not that advanced. But just
keep in mind that this could happen in distant future.

> 
> I'm in general a bit concerned about using tracing calls for stuff
> like that and depending on the non-uapi, but it's probably
> time to give it a try and see how co-re works :-)

you can filter out based on cgroup id in bpf program. I guess
fexit should work in your use case.
