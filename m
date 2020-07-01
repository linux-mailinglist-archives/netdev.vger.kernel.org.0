Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15974210207
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 04:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgGAC0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 22:26:36 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:11152 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725988AbgGAC0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 22:26:35 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0612PgO6021112;
        Tue, 30 Jun 2020 19:26:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=XzVwesyXppnhHor1c093K65mOOFh7rGEx8HYY3wRhes=;
 b=WQj71VD+40nL5ohfqASlPtfV0WERo31ODOGDOy/AaMZUJtfiyuncqsglfOgpVE95BFKD
 RcTdXP0RK6dIEFebvzXX1YhXo8p6nprD9B4plCr2xZq57oKgspVuJ7nd6SA05LOgANpa
 s8idjv+i/pjuVFWImA+QzjfL7eufoJUvXKI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31x3xgymmf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 30 Jun 2020 19:26:19 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 30 Jun 2020 19:26:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QOa1re290sy08wHaCwUMzWqZw3wRte2ymcOm7h4fCQvVcBblxuTo+Y5clNKwx40NoMXPjlB1keDxgeBlrrVpK4w9fx90Imb1F9XsuSRb9hByD0nRj4VihDSDOC3aU3W4P/lYusACNis980ixUkzpgIp7DiFcHl2/cr0xGJOdIKJEI6tCA0ihcKGrrdXzvs8uWrokD9BTe9bEoG2tWk28EYCGP0wwDII1wVRBJ5vp2jjnu7yqZM5mteHtcIl9uwG5yKqO00L+G6yaoLMTqlNstzhlWMMmgJA1YjTAqVUrnVHOJnE/YzIJvbGNfsFhs2Sxg5BPHNearkX7DcMRBMtBAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XzVwesyXppnhHor1c093K65mOOFh7rGEx8HYY3wRhes=;
 b=kctZ/lzxuR7VeEqVXKyrJtwKZODzaOlE0M8swa8yBB4GpbEdoKpXWzbQzc+Lugv7b/KgTevYoy3OzG2OOQcZj01PSqrjhtCsJcTl3oenHUy/EPXzoHBYVuAthCFlwR1d7kBtawcO8F19PiEtYh2u8hLE94drCITLlA6ZebrAD230jBVaYLjLugBZOThOi1QY7dcq4SIsVbDscGjE2W5A5iJXtTA9+7V+cCQYBvtrutuhnpj5u6DlIKxiDAGU1ZWScLBUJTeculMBp/9g1E2ZgsgCjmhiv2AkFAME/kznZPAi52/hZ2nbsgPOHlNV57L7MEljuspeqiRgQz0h2uFJhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XzVwesyXppnhHor1c093K65mOOFh7rGEx8HYY3wRhes=;
 b=iAicbsmgdRGIHk3V6YLxWOD7mI9xrMyOG9GTc8biUE3JW5CvLRgATXWhkz/2t4zMqfkW7t26ik+r2flKty6v2kI4/REG+apbgWPprMeAY+MldjLKUr3YvkhhbIh5751zoCrdpdojo0YOIVn2FK8bHrQGvCVi0CWYVOWAcruyGAI=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2822.namprd15.prod.outlook.com (2603:10b6:a03:15b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20; Wed, 1 Jul
 2020 02:26:05 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3131.027; Wed, 1 Jul 2020
 02:26:05 +0000
Subject: Re: [PATCH bpf-next] selftests/bpf: Switch test_vmlinux to use
 hrtimer_range_start_ns.
To:     Hao Luo <haoluo@google.com>
CC:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <clang-built-linux@googlegroups.com>,
        <linux-kselftest@vger.kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Bill Wendling <morbo@google.com>
References: <20200630184922.455439-1-haoluo@google.com>
 <49df8306-ecc7-b979-d887-b023275e4842@fb.com>
 <CA+khW7iJu2tzcz36XzL6gBq4poq+5Qt0vbrmPRdYuvC-c5U4_A@mail.gmail.com>
 <CA+khW7jNqVMqq2dzf6Dy0pWCZYjHrG7Vm_sUEKKLS-L-ptzEtQ@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <46fc8e13-fb3e-6464-b794-60cf90d16543@fb.com>
Date:   Tue, 30 Jun 2020 19:26:02 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
In-Reply-To: <CA+khW7jNqVMqq2dzf6Dy0pWCZYjHrG7Vm_sUEKKLS-L-ptzEtQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0048.prod.exchangelabs.com (2603:10b6:a03:94::25)
 To BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::15c2] (2620:10d:c090:400::5:5757) by BYAPR01CA0048.prod.exchangelabs.com (2603:10b6:a03:94::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.20 via Frontend Transport; Wed, 1 Jul 2020 02:26:04 +0000
X-Originating-IP: [2620:10d:c090:400::5:5757]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fe7cf668-a757-44c5-073c-08d81d661b4a
X-MS-TrafficTypeDiagnostic: BYAPR15MB2822:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB282280E82F7163680D1DB04CD36C0@BYAPR15MB2822.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 04519BA941
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ifpBzi4u4HCaEZUd7rZgVjIjbdlP1V3dXNdJP0RGQmBCWTOGXwte7a5EEGGn0SqbjFAJbwISYeoke8E5lGSdDEvF7+QNndHxAV97KEbOsq/NV4d17LuQPFjxkD6lvSgAfLRm8nUo334U0fHOxbf9uecbXqhFvhtc5T5W9DfffrbSuQDQctiKisW0zX94u44Dgp5snXeVur52DMrHBj1wLXTWfGZFBZbfOXGuLTBF2dPoshtGcOJjlhacn2FLNKCEJG2G/TeMidzeEKzAFSJDUwuph4hOo2fUsEd+aQPT7kIYEhVVoZMzwQQS+l83eRJcE+wxVEsOj9eAqanR6n9tP/Wn0hgxb0wl6QvfKtF72EXED1kDx/+x2STwu4h5PBph
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(366004)(39860400002)(136003)(396003)(376002)(6486002)(36756003)(54906003)(83380400001)(478600001)(16526019)(4326008)(7416002)(186003)(316002)(52116002)(31686004)(8676002)(66556008)(66476007)(66946007)(2906002)(53546011)(8936002)(31696002)(86362001)(6916009)(5660300002)(2616005)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: f9zp8w1hG1APb2Tl4OZ95sHtDIukIECvslDY9RLM41mySPiLtP8AREcrU8uEfeHpRvfjTG352ldBU/quW+V5rparNbXsg2VZu2C1yxlddmjzVV/rxEpDyHZnob9bcHXS3hUEWaYzMEPXktc1CHuy1aqzN8TV/nGvDBl4EzCoUYZyRhMSSAuaFrVXy0xeMHvFfsgN+ptVAg/gBFVSTSivoPcCR+DspMI90jMhtFXOgeaE6M9tfjFzafTc+Lsp9TSOGTIaHJjw/1enrQMQMry1x66KhRn0SIME0X8X7pbPHwgv6GaDntPGkrYVFMUtxRUAoZGX5hTm6XDWIvD8wREnkawlrWI5e+M59xpaKyGX6fbg14s+yb2NNVVd1OGnN88NXQUsaaBrAtF4f6oe2ARLuel9CT2M2+pMFKkjbBdi/h4Ai0Pji4AqGmbJCusrGC9/CnfauEKn/qYLtk1u5GaqjgvYoSWVyorNyJGKGNHXtf2+Z46yjVEhOCL6VTV7cmM/27xdiNF9y43hVtfHii2xoQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: fe7cf668-a757-44c5-073c-08d81d661b4a
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2020 02:26:05.7609
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IxjnbgR6fAHJpXpJotXdyNxFlCrSkLlUfxSQDV34hvX6b8aakSzE3Mv5VT0nN4d6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2822
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-01_01:2020-06-30,2020-06-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999
 bulkscore=0 priorityscore=1501 mlxscore=0 impostorscore=0 spamscore=0
 clxscore=1011 cotscore=-2147483648 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007010013
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/30/20 5:10 PM, Hao Luo wrote:
> Ok, with the help of my colleague Ian Rogers, I think we solved the
> mystery. Clang actually inlined hrtimer_nanosleep() inside
> SyS_nanosleep(), so there is no call to that function throughout the
> path of the nanosleep syscall. I've been looking at the function body
> of hrtimer_nanosleep for quite some time, but clearly overlooked the
> caller of hrtimer_nanosleep. hrtimer_nanosleep is pretty short and
> there are many constants, inlining would not be too surprising.

Oh thanks for explanation. inlining makes sense. We have many other
instances like this in the past where kprobe won't work properly.

Could you reword your commit message then?

 > causing fentry and kprobe to not hook on this function properly on a
 > Clang build kernel.

The above is a little vague on what happens. What really happens is
fentry/kprobe does hook on this function but has no effect since
its caller has inlined the function.


> Sigh...
> 
> Hao
> 
> On Tue, Jun 30, 2020 at 3:48 PM Hao Luo <haoluo@google.com> wrote:
>>
>> On Tue, Jun 30, 2020 at 1:37 PM Yonghong Song <yhs@fb.com> wrote:
>>>
>>> On 6/30/20 11:49 AM, Hao Luo wrote:
>>>> The test_vmlinux test uses hrtimer_nanosleep as hook to test tracing
>>>> programs. But it seems Clang may have done an aggressive optimization,
>>>> causing fentry and kprobe to not hook on this function properly on a
>>>> Clang build kernel.
>>>
>>> Could you explain why it does not on clang built kernel? How did you
>>> build the kernel? Did you use [thin]lto?
>>>
>>> hrtimer_nanosleep is a global function who is called in several
>>> different files. I am curious how clang optimization can make
>>> function disappear, or make its function signature change, or
>>> rename the function?
>>>
>>
>> Yonghong,
>>
>> We didn't enable LTO. It also puzzled me. But I can confirm those
>> fentry/kprobe test failures via many different experiments I've done.
>> After talking to my colleague on kernel compiling tools (Bill, cc'ed),
>> we suspected this could be because of clang's aggressive inlining. We
>> also noticed that all the callsites of hrtimer_nanosleep() are tail
>> calls.
>>
>> For a better explanation, I can reach out to the people who are more
>> familiar to clang in the compiler team to see if they have any
>> insights. This may not be of high priority for them though.
>>
>> Hao
