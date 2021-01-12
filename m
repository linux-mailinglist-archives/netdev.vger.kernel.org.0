Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4552F3656
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 18:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405728AbhALRAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 12:00:30 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:20604 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388731AbhALRAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 12:00:30 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10CGxWUs030294;
        Tue, 12 Jan 2021 08:59:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=PSKqR4bj6D2dOt9XWkOgOTHSIA21uV1xRa9jaKRHurw=;
 b=j7M3//XEnWau8lwO24tbkrp58coA8HE+a5PcRmBEDV2MSVTogNg1NYWzH7jodwRlZUb+
 s09zJhq/4taGtHL7bU+EuJ7azbBQUC2Wxmu2YOOFkiqSW3J4amFkTSCSvpHfo2yEOh3o
 MRZwXTyYQcDbZbhZovuq924YKHeqCWB3mAI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 361fpe016y-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 12 Jan 2021 08:59:35 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 12 Jan 2021 08:59:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ll0dZB+tQY4LGurvQlwuJBUupSXAP+kljW57TxS2SI+C/La/TK4gBV/1Q8tRJRzgg/0lrUbQp4cbPRnMFvuorpjejyxPHHUWCA4yzFshkYDJrc158/dW5UjMPQd2dlSI2WWvRlOLHxwzrQNTo6RU8PST+KgKpb0qMoUyMKs9ds3MYE/nDWuuHZdsHeIo+mz8pd0SUdeKWbeFN2jBgq9uXHYTAJX3Xb/wGBxUlCgQCaYfofEGmGc4QMg0G1+XVValsLUzzxUXOSluNE7XJr3MNGSYDaVReplqGdAPKKz8GebKpuLRc9IrYkRyicelWmInCC4bVvk2+xf3Ya3+bJDRlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PSKqR4bj6D2dOt9XWkOgOTHSIA21uV1xRa9jaKRHurw=;
 b=Dru9tRi0JTRYQMnvcJyPaaSKI3nDjoyYx4ScdpUdLIw5/S0+RCW1gXUbAClJGD+xo91VoF62FDOKJhacQRXl15lKPPryaTHc6nDZxOiH/ELVgUCvlkSKMKrhggOiFnhqVsXQfEgK7RLYpUUlq1wN/dI2RDZMqr+M/3LXd2TYC5mHzMmObxbOgZKnfWA/86OPGyea5ViMJMNuT9V+7UUvH8ev++0dmX5tVLlOX4YG+J9Wvy09efm7LD8Ap9swA+7D4KL8LHLbVisPZcoaI8lqIcwv+9qB1iKUZ+6Xytpq1BedRdYV8tmNF0YW/WhdEJExspsLiXJQ0nxO9uBlSnCivw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PSKqR4bj6D2dOt9XWkOgOTHSIA21uV1xRa9jaKRHurw=;
 b=P6jSHz12qvTz60QMRF9CWKVfyznwr0nxjVwLIJTV6E0BrHRF5SIjCQ7UXAUCLeCV7Fy8kwNIR51hcKbvCKhnwcuP2BiKAdwL/qBgu8F9jBql9w0tBAb4jBpdOQ/dqKr3j7zjZVHMh47sAJk26JKstGRaFM5GyHBuXiETINX3o+A=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2823.namprd15.prod.outlook.com (2603:10b6:a03:15a::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.8; Tue, 12 Jan
 2021 16:59:15 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 16:59:15 +0000
Subject: Re: [PATCH 2/2] selftests/bpf: add verifier test for PTR_TO_MEM spill
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Gilad Reti <gilad.reti@gmail.com>,
        KP Singh <kpsingh@kernel.org>
CC:     bpf <bpf@vger.kernel.org>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        <linux-kselftest@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20210112091545.10535-1-gilad.reti@gmail.com>
 <CACYkzJ69serkHRymzDEAcQ-_KAdHA+RxP4qpAwzGmppWUxYeQQ@mail.gmail.com>
 <CANaYP3G_39cWx_L5Xs3tf1k4Vj9JSHcsr+qzNQN-dcY3qvT8Yg@mail.gmail.com>
 <60034a79-573f-125c-76b0-17e04941a155@iogearbox.net>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <eadd9b0f-aff5-99e2-e425-4b798d7a85c4@fb.com>
Date:   Tue, 12 Jan 2021 08:59:12 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
In-Reply-To: <60034a79-573f-125c-76b0-17e04941a155@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Originating-IP: [2620:10d:c090:400::5:3e3]
X-ClientProxiedBy: MW4PR04CA0171.namprd04.prod.outlook.com
 (2603:10b6:303:85::26) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e1::190b] (2620:10d:c090:400::5:3e3) by MW4PR04CA0171.namprd04.prod.outlook.com (2603:10b6:303:85::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Tue, 12 Jan 2021 16:59:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dba350a8-8704-46b9-6188-08d8b71b64a5
X-MS-TrafficTypeDiagnostic: BYAPR15MB2823:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2823C782EB8931C59E9F11ABD3AA0@BYAPR15MB2823.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: moSjTh7bWhEB56MX09PM9GM2lwlawHUJkRvWAU0B2wF6/bpnF9eRqt5Mrt86ZPF/DGzCGpqnqLRzSZMfvvbBqc5Dbc/6h3B+me3grhOG+iJTKE8FiIU1uXsw94coZwOw6JXgpRTdY7kKea8MBwo/ofj+rBl0xIo1u3aTP+/rnJ19zzBj+u9KPe+hhx7Nfx5Ruwp22LxatobdGLtDeOtJbNcmiRNXRRmpfKxFiw3GCIlzk330CjAI5pPJJvabt1+Xinp1gMqAxB8ZqitZ5OWmk0dALjaO4fPZ5BeZT+MD4xIaFb42QOmrh7SNy4dREwgzefxJ/G+JEfAcDYrS3Wcd6cKck7lf9ej0S1nW1/r9YuzvqApCaoMwgphZT5pIkBsCNtd74gYWFaiKj52ICGGQbtIZIY0x05hFzC2eHQlawJEN/Uy9bgfq4nMhjvyj1lSB7om5dEkQr4nGF+T9yzy2U2nQdqjFmVM6XDvm5JJ9/ExmcvCR7leBMMU0VcUNfydtGGG5cbwxmgOXzy7rbhRqOqGGRtC1zXU6iDqUM6q1COhuN9eqNk1Q/TQfF1ty/lk3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(396003)(39850400004)(136003)(346002)(53546011)(54906003)(316002)(16526019)(31696002)(186003)(36756003)(66946007)(2616005)(966005)(2906002)(8936002)(110136005)(8676002)(5660300002)(6486002)(4326008)(478600001)(66476007)(66556008)(83380400001)(52116002)(7416002)(86362001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?SkhWNUZyZWxEQnhqRTRPTkMxc0hRRVBUVFVLcnBIM011S1piblFMZ2FIMVZj?=
 =?utf-8?B?T083NWhHeGZUZDE1UkRDNUtQR015c29BR1hiWVhjMlh1aWw0aWFMeG52T01y?=
 =?utf-8?B?VitHVXJvRWtpam1vN3RiNWYwSCtsWmlUdUlmejBVZ2tpVGNaWkR6SFNmQUVj?=
 =?utf-8?B?eEF0Sk9qblA4M2NwaXFKYkwzaVhVWVFmSnVvWXBSbW5qcmUxYXRGNFZJSkw0?=
 =?utf-8?B?ZXhja3ZnNU8xS1FZNEhuSjRKV2hFRUd0a0phMHN0Sk1PMjh3aEJlMzNmL2hD?=
 =?utf-8?B?d0o0N1NsQW1keEF5Vk9yZ21NZklkUFZsU1J6bjViUjhISzlIYTFSZGNMRWxp?=
 =?utf-8?B?QnIvb2Z0QUc0eHdBb0xFb25xSnhxMVBDdm5FL0crdFZvZlNxVlNVdzhaS1ZY?=
 =?utf-8?B?OUpmMWFJKzlVUkZNNjFnelJBeGFvcFpmTXU1cVpDTFJObTBNaW5FOHhyaHVv?=
 =?utf-8?B?bVJOclpFK2ZGbFpEMGJaeFZzeFZ6cEllalFvT1FYWFF5d0Z0ZmtYS0dJZE1E?=
 =?utf-8?B?UjJKT1VTSTFhZ1IzVmtaSGVvZk1QQmk2NDFabDNwV1NxQXgrN2pJUnZOc3VZ?=
 =?utf-8?B?bnZjSjc4N3doamwyYURHWjdLNWpRNDZPL2czZ0g1WVo5czlnM2FJUmhwamM5?=
 =?utf-8?B?bjFyQStPUE9UTjRvUnRYaVJ4eVg0N1pUUzFaNEJOaXhVNVZ1ZGhvT3I3ckpT?=
 =?utf-8?B?WmpHSGxiRDZHckJxQVVqTDhqWVB0c1FqT2VpS0ZlQ3dqeTFzVzVYWUJ2a29r?=
 =?utf-8?B?bU1oZkp4MGpaejIzUENzNzBJNFdTeDFQcmZxSGhsZDM3Umt4SmY3elBBUFNZ?=
 =?utf-8?B?YUNHc1pjOEp5ZEZSdG5zQWhzUkRLYTN0NmdGNEl4Y1N2b3UvZXEwSURVZnJP?=
 =?utf-8?B?YldSTzB2aXZwVytxQnE2enZHT1UvZ3FVbk8wc1lnWllFZDFhQTYzT1BJalpx?=
 =?utf-8?B?WU81UmRpZ3NPbWhidUVqU2x1NS92WXJJdUZ4NDQwRjVzNlpacDNSZ3dhcWhR?=
 =?utf-8?B?enl4ZnltUWk0TzdOaHJYYnB2Tm0vekQ2bTVGSEJCWjY0T2wzRllhVzlnQ0hQ?=
 =?utf-8?B?ZHlQT2hoa1JiZHU4dWlGbkVNc1BQcC9VMDVlTGJ4eUlzeDBFT012MFdjR3lG?=
 =?utf-8?B?WUhrbXpiNzcrMEhVblpLNGRhUlptNjZHMzdheExtem9wcFkwWXNEUEFFckVI?=
 =?utf-8?B?NTd0N1RuNGo4NnZaRHQ0MER1YmdPWXhrWTYwWjduRmp2d21kMWNKWEw5ZlU0?=
 =?utf-8?B?aTRBblpyN2V6RjJYWXVHRTl2T3VXZHh1SGVHSCtaREJYWHJxV1hienNmdzVQ?=
 =?utf-8?B?Z2lGNEJmSTdDb0Ixb2d6eEhnb05SYllUcjc4Wm1XY3Vkc1RMdmJtVGgza0I5?=
 =?utf-8?B?aUYzZ29QTnBGdFE9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2021 16:59:15.2026
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: dba350a8-8704-46b9-6188-08d8b71b64a5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c70YM11eJrc4RMFQN1sRSi7/dOyFh1EZoiF/MvP4ZQBvjBhjfWn6EaTkHVP7WnzK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2823
X-OriginatorOrg: fb.com
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_12:2021-01-12,2021-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 clxscore=1015 mlxscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 impostorscore=0 malwarescore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101120099
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/12/21 7:43 AM, Daniel Borkmann wrote:
> On 1/12/21 4:35 PM, Gilad Reti wrote:
>> On Tue, Jan 12, 2021 at 4:56 PM KP Singh <kpsingh@kernel.org> wrote:
>>> On Tue, Jan 12, 2021 at 10:16 AM Gilad Reti <gilad.reti@gmail.com> 
>>> wrote:
>>>>
>>>> Add test to check that the verifier is able to recognize spilling of
>>>> PTR_TO_MEM registers.
>>>
>>> It would be nice to have some explanation of what the test does to
>>> recognize the spilling of the PTR_TO_MEM registers in the commit
>>> log as well.
>>>
>>> Would it be possible to augment an existing test_progs
>>> program like tools/testing/selftests/bpf/progs/test_ringbuf.c to test
>>> this functionality?
> 
> How would you guarantee that LLVM generates the spill/fill, via inline asm?

You can make the following change to force the return value ("sample" 
here) of bpf_ringbuf_reserve() to spill on the stack.

diff --git a/tools/testing/selftests/bpf/progs/test_ringbuf.c 
b/tools/testing/selftests/bpf/progs/test_ringbuf.c
index 8ba9959b036b..011521170856 100644
--- a/tools/testing/selftests/bpf/progs/test_ringbuf.c
+++ b/tools/testing/selftests/bpf/progs/test_ringbuf.c
@@ -40,7 +40,7 @@ SEC("tp/syscalls/sys_enter_getpgid")
  int test_ringbuf(void *ctx)
  {
         int cur_pid = bpf_get_current_pid_tgid() >> 32;
-       struct sample *sample;
+       struct sample * volatile sample;
         int zero = 0;

         if (cur_pid != pid)

This change will cause verifier failure without Patch #1.

> 
>> It may be possible, but from what I understood from Daniel's comment here
>>
>> https://lore.kernel.org/bpf/17629073-4fab-a922-ecc3-25b019960f44@iogearbox.net/ 
>>
>>
>> the test should be a part of the verifier tests (which is reasonable
>> to me since it is
>> a verifier bugfix)
> 
> Yeah, the test_verifier case as you have is definitely the most straight
> forward way to add coverage in this case.
