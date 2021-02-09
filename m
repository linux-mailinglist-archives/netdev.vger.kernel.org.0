Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73F583153BD
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 17:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232799AbhBIQY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 11:24:29 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:45430 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231520AbhBIQYU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 11:24:20 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 119G9mDj005071;
        Tue, 9 Feb 2021 08:23:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=WzsZuQgOs/OAwkoxJeM7sfNezXGd/dPSbafEL7LDLTA=;
 b=NYqhhmzedOcqZqGgt/jOI1eQUTjpankauU77DRDHEm5oGjxpSjgXK+BSW+oyxAdQLP/M
 2glAI2eSmKU6ORT5TedghmHq3oACqtYY5NY0D03EMQt/IiDHqbZskgbfL3i7uIIoK8jZ
 4C1jit/kebeaIY74fhCqCibK8TeB9XycmJw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 36jc1ukths-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 09 Feb 2021 08:23:20 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 9 Feb 2021 08:23:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QuoMa5Uvb9O2YAGz+8kIIrvrYnIZ5g0I4+abwJawUJbDgNQdzszBaltHkuq3NSHjkRRgZ8+yqSyQiXRbuWp3FIreTHZ2I+Ey+aPd9QmSGBRz0J44+96goInfyPOhElD+NMrFK6MLNUwTAx0zPfqAYOutXPxMDaVMOd1z9ng1H9tktk+p3V0NlgWYdq6k5akS37/YAXvh7OiKI0/TxxWzor1lgLlwNf+gxxWzcnW3YvClr+07wVRJgtFUfWlQzEca7poh0QoQOGHhyWv7d7+6wmz/MDh/nQLbbHsLvmITPzHKwJItbheRldhp3jhR/5kuPCZo5PHTGWUMtgNt+X6bbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P6ThFXhAmwIzDaLdPiLIkfslYCNWr4FxyKmTiwyD9ew=;
 b=J3nnoF7DitZZ9uGTeRWPnDAbt7BjLZa/O3GfphBYcxYvFDKTedyrbHkstIfddVddDw6UDWT4O6WxBfMToOrj7JnDAn/2RXP2M9YHDNUWhFmB/RkTzDVka8FILHbLhiYncUCrp1tERCm5C+4VcCUGu7UtuqUICnc0ekjpHMJkzOL8eUTMI9fAZcQcRbtUJkBnquKa7uj4xNJ3O3xj66mBywYhO0eFsUMRaIdSkfbWL0fCXI81dxVwMeueXxc1T90APEO++eYZprvv97EPn/stwE3DQxncUGk2k+g8ORVKPhrjpyQCOIDeoBWv1RNzOmnCkmADbHCXM6j0MI8arN4Atg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P6ThFXhAmwIzDaLdPiLIkfslYCNWr4FxyKmTiwyD9ew=;
 b=hP5s2151Qs+1Jv3ii9m1yEto1AGKQb/gRMoekR4tffxY7IBkNWVnE7gNaAoPzcSppn3WY1qDgGie3AjMmKXZTSji8VzLIbdbwey4FEZ2B2rlTPG5DxfjfNU3xvZoJ3ehVbVYY1BaOQYENL60RGJG7nqNY2fxp4PVi0/y+rWHHGE=
Authentication-Results: googlegroups.com; dkim=none (message not signed)
 header.d=none;googlegroups.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2646.namprd15.prod.outlook.com (2603:10b6:a03:155::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20; Tue, 9 Feb
 2021 16:23:18 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::61d6:781d:e0:ada5]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::61d6:781d:e0:ada5%5]) with mapi id 15.20.3825.030; Tue, 9 Feb 2021
 16:23:18 +0000
Subject: Re: KMSAN: uninit-value in bpf_iter_prog_supported
To:     Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+580f4f2a272e452d55cb@syzkaller.appspotmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
CC:     Alexander Potapenko <glider@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
References: <000000000000364d5505babe13f5@google.com>
 <CACT4Y+aDGsVkzTkQ551XUpT0Z1vuiGTubvtKne+VYjK3zX67kQ@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <2affbff0-892c-8037-72a5-e698d03019e4@fb.com>
Date:   Tue, 9 Feb 2021 08:23:15 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
In-Reply-To: <CACT4Y+aDGsVkzTkQ551XUpT0Z1vuiGTubvtKne+VYjK3zX67kQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Originating-IP: [2620:10d:c090:400::5:eb5f]
X-ClientProxiedBy: MW4PR03CA0061.namprd03.prod.outlook.com
 (2603:10b6:303:b6::6) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21d6::1610] (2620:10d:c090:400::5:eb5f) by MW4PR03CA0061.namprd03.prod.outlook.com (2603:10b6:303:b6::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20 via Frontend Transport; Tue, 9 Feb 2021 16:23:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9daaa73a-0881-4624-b61f-08d8cd170245
X-MS-TrafficTypeDiagnostic: BYAPR15MB2646:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB264616A8B7C1DAB37785C0A4D38E9@BYAPR15MB2646.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hfBM9Hinh3hkQZUnJJnxny4MbMVSLgYrCFWW6QZ/eiCwfmstN1B59N/HUkp3Ty93+W++DoTnko8u6QVIfK8ezQK+WLUs2gkoQB4kczfrIoTsGGNbVQ0KpcfU93tNfOUe+GahRk2PrASPRHhtdf7WW6I/hUFlT+7Kbci5qi96Rf7yvaQ+xTUTiORnxwHMxp+jlVUectCDEtOM6sxkofdnrP+YUjCOzi6dNtJQmR2+UdiCnjA1Kz6LFwHJE28CSUEnjTmEZ5gqN63c+oEPN1yn5oZM0q4+ssNGTuySD5C4gqr3n1SCZgoClbGlkOlKXcE3v27+ivSt1/L8aoT6Zw3DnAsP/kxbOrxTBkG7wHih/d+amr2AmYWQ6GRKpdNifbegBrWzQBi+gYTe2qDSxYZOuO3zxQ2Znhz6w7C2L+hKEcz1s9ogLGwRVh41ocYA9hmTKdBsyXETsyndHBVTEqKAIzEvtLZPVgzwlBv4sfpJdCHUqvD6acZlT6OmFY5NJyYfzaoeKRIRmUjirT0de8UNWyFRlqHQ6b4P9T8PXAKbQBGh2R9/9v4ckVXlXoLIruO72UtYpbUWIhDUTlpb7/Vc74oB8/A6RjD13e796/1UczyY60sINn6kHVXc+MmK5APubHtEUKkm1IdTjES8pzl5kYk8WelqtrGW/W+UwxyUGiU1tGLLCpFB9ER7JZTf+DXHdCSx8s5/pVXuUqYZ/5D6Eg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(136003)(376002)(346002)(39860400002)(53546011)(478600001)(2906002)(16526019)(86362001)(966005)(186003)(31696002)(54906003)(2616005)(6486002)(110136005)(316002)(4326008)(8676002)(8936002)(31686004)(5660300002)(83380400001)(52116002)(7416002)(66476007)(66556008)(36756003)(66946007)(99710200001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZHRYdGZTKzRhYk9tTXp2S1VWKy9HRTJpV3R0MjZTMFd0VDhwQkFqTjNPdGpJ?=
 =?utf-8?B?TGZ5WU92aUdreGxHUHBuekRUbmZWU0dqeXZRNFRvdUdXQjN2bkZ2UHJINjMw?=
 =?utf-8?B?dTZXa2V5dG0yWlJZbmZWSVpOZDdFQlVXTjZIUXVObmtVUFplNDFITzhyQzZV?=
 =?utf-8?B?ZUMrbDZoWlc5K0duQ3lPbTZCOWVMOW0wYm9HV1NpeHE2MHBLUnVyenZoL2hD?=
 =?utf-8?B?K21YdEdsZUExdU1ucVV0Qm1HUXA1dWVBem9FN1hGZ0pwR1dQVi9VSHFGQTdS?=
 =?utf-8?B?eWZnK1RIUVhhbzNFTmYwbWRLa1dpUGZUNEQ1MGRKWnVrb0N0c3FlQ2tVMXhm?=
 =?utf-8?B?SE5kUEViZ0FxZjZzMitRcU53bUQxN0dKMXFSYUVLVnNFSVpmT21BQ0xhQVVs?=
 =?utf-8?B?d2ZmQkZ5VjAyK0JmcDJ3a3AvUWhFeUpMODNmZnB2Y1Vva3VoM0RWd0xsakNo?=
 =?utf-8?B?dFNNbUpSNkZUdmVpd0xnbnlCUmpVZEJleFhIdnorajdETm9GTUNISzIwZld2?=
 =?utf-8?B?aWZkTVdBVnd5a3VDMGhPVlFheUFsRWRYWU1tQ3Z5dTBZVjhWckFQMG1OdmhV?=
 =?utf-8?B?eksySDBSYkZBQ0trYU55eE91aTd4U2tBeTBSVDhoczlIcFY2aktubDhicFJK?=
 =?utf-8?B?ZG9LbnozdnFjVW9HN3BpbXlDVm5xOHRBSUVZQUQ2bjJURFA1Wm1XUFpMN0Nk?=
 =?utf-8?B?bVRLdkU0aHMyTW1wd0FNcjlOb3QzTjdRaDVSZlZNOHZRbnU0OFd6bEI0djQy?=
 =?utf-8?B?cVg3QVl2UzJ3K0dnbTE1cG5ZUXB1dmJVdmdxbjBEZFZLekFtQXpwaFZXSmhN?=
 =?utf-8?B?NnJHR3hJc0F0Z3ZjUXJKU0M5NFdwK3ZhY0drb3h2c0NUbVJqRytGWUdRZXN3?=
 =?utf-8?B?bEIxZ2tJaFc2Vmg3aHdpakdqWW1pWWpEOWJZNmVTRVRhNW9renBTQndZVWlV?=
 =?utf-8?B?SEt4NzlRZnJOUXV0endyK0czTytCTm9BUnBkaXdHYU1BOTBCSWsyd0phNVVU?=
 =?utf-8?B?UjcxSktwbG9FQ0FxOEZxTjlvaW15czNZK1RqeldlMURFZGtYaC92WGNqWlRV?=
 =?utf-8?B?eDRnSXMzMk81VzVGZWorTDhDRlI3NEdxL0NxaHhxa09IK3lQRCtsM3NZbHdY?=
 =?utf-8?B?dTBGU09sSzVYTERXdW1Ed014UlBzaDIrcVJPMnJjd20wdjgwaTlzRGNLbjdR?=
 =?utf-8?B?aTdXRUcrckZpbjlETk1HSnV5NWM0T3RDcTY1L0ZhVkpCRFlJSzUwTHlEYmYw?=
 =?utf-8?B?dEIzRUREUFo1S0dnUE1xaFZGcGN4bjR0SEgwYXhDME5NYkYyRlpzcWpvZE9E?=
 =?utf-8?B?bzFpZ2x4RUdBbnZnc2Vybms0dE5MQmNNeDU5dC9XdXBUN2svakZyMEt2bXcz?=
 =?utf-8?B?TVJ4ajJ2WVlYamkwSGM4Rm9nT0lOUzlJejM3OWF2ejJlYzNWTndQcTEzTzg4?=
 =?utf-8?B?SXJhRWxZTlg4cVRjeTRNblY1K00yS04yTEl3V0Y4ZEsyaUJaNnVaeU9WS3NP?=
 =?utf-8?B?UnptNTJVMUE3RnpxR3ZXNHRRZVZIeFZNNWhyWm1WeVJnR2Ywc2N1dThsR0tv?=
 =?utf-8?B?S0RrMzE5MkV6MWd0cjRvc1pod1RtOWd0K0dFTUg0ZVZoK1dVUXpHS2d5Y1BJ?=
 =?utf-8?B?OCsxbWFxT1lUOVRvWDQ1ZUs3Q3VZY2h4NDcxaDI0Y09tRUcwRXUxc2JVUjdS?=
 =?utf-8?B?L3BKOUJwb2wvYmJBendIMzNTbU0zNUhWWUJmV1VjbTJ4ZU1WTjRqbk5xNlJj?=
 =?utf-8?B?MFRlNUhoeU5xQmpvVUpZMFNTd1JQSHVpVGNkdy9ETHovSDR1UTJlNGZTRXRC?=
 =?utf-8?Q?zpfuAWhib3f8bGS2ei5Q1AMhsI0eRIRbnQDc4=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9daaa73a-0881-4624-b61f-08d8cd170245
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2021 16:23:18.0679
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vDzULk3h+g3bVaISfqU1+z6nEGyxXaR/0PN7eDcdUSzSeqLrQdiE2UQ0Q14kM6Th
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2646
X-OriginatorOrg: fb.com
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 6 URL's were un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-09_03:2021-02-09,2021-02-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 impostorscore=0 adultscore=0 spamscore=0 bulkscore=0 lowpriorityscore=0
 malwarescore=0 suspectscore=0 phishscore=0 clxscore=1011 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102090081
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/8/21 11:35 PM, Dmitry Vyukov wrote:
> On Sun, Feb 7, 2021 at 1:20 PM syzbot
> <syzbot+580f4f2a272e452d55cb@syzkaller.appspotmail.com> wrote:
>>
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    73d62e81 kmsan: random: prevent boot-time reports in _mix_..
>> git tree:       https://github.com/google/kmsan.git master
>> console output: https://syzkaller.appspot.com/x/log.txt?x=17ac5f64d00000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=df698232b2ac45c9
>> dashboard link: https://syzkaller.appspot.com/bug?extid=580f4f2a272e452d55cb
>> compiler:       Debian clang version 11.0.1-2
>> userspace arch: i386
>>
>> Unfortunately, I don't have any reproducer for this issue yet.
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+580f4f2a272e452d55cb@syzkaller.appspotmail.com
> 
> +BPF maintainers
> 
>> =====================================================
>> BUG: KMSAN: uninit-value in bpf_iter_prog_supported+0x3dd/0x6a0 syzkaller/managers/upstream-kmsan-gce-386/kernel/kernel/bpf/bpf_iter.c:329

I will take a look. Thanks.

>> CPU: 0 PID: 18494 Comm: bpf_preload Not tainted 5.10.0-rc4-syzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>> Call Trace:
>>   __dump_stack syzkaller/managers/upstream-kmsan-gce-386/kernel/lib/dump_stack.c:77 [inline]
>>   dump_stack+0x21c/0x280 syzkaller/managers/upstream-kmsan-gce-386/kernel/lib/dump_stack.c:118
>>   kmsan_report+0xfb/0x1e0 syzkaller/managers/upstream-kmsan-gce-386/kernel/mm/kmsan/kmsan_report.c:118
>>   __msan_warning+0x5f/0xa0 syzkaller/managers/upstream-kmsan-gce-386/kernel/mm/kmsan/kmsan_instr.c:197
>>   bpf_iter_prog_supported+0x3dd/0x6a0 syzkaller/managers/upstream-kmsan-gce-386/kernel/kernel/bpf/bpf_iter.c:329
>>   check_attach_btf_id syzkaller/managers/upstream-kmsan-gce-386/kernel/kernel/bpf/verifier.c:11772 [inline]
>>   bpf_check+0x11872/0x1c380 syzkaller/managers/upstream-kmsan-gce-386/kernel/kernel/bpf/verifier.c:11900
>>   bpf_prog_load syzkaller/managers/upstream-kmsan-gce-386/kernel/kernel/bpf/syscall.c:2210 [inline]
>>   __do_sys_bpf+0x17483/0x1aee0 syzkaller/managers/upstream-kmsan-gce-386/kernel/kernel/bpf/syscall.c:4399
>>   __se_sys_bpf+0x8e/0xa0 syzkaller/managers/upstream-kmsan-gce-386/kernel/kernel/bpf/syscall.c:4357
>>   __x64_sys_bpf+0x4a/0x70 syzkaller/managers/upstream-kmsan-gce-386/kernel/kernel/bpf/syscall.c:4357
>>   do_syscall_64+0x9f/0x140 syzkaller/managers/upstream-kmsan-gce-386/kernel/arch/x86/entry/common.c:48
>>   entry_SYSCALL_64_after_hwframe+0x44/0xa9
>> RIP: 0033:0x7fb70b5ab469
>> Code: 00 f3 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d ff 49 2b 00 f7 d8 64 89 01 48
>> RSP: 002b:00007ffdbb4cde38 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
>> RAX: ffffffffffffffda RBX: 000000000065b110 RCX: 00007fb70b5ab469
>> RDX: 0000000000000078 RSI: 00007ffdbb4cdef0 RDI: 0000000000000005
>> RBP: 00007ffdbb4cdef0 R08: 0000001000000017 R09: 0000000000000000
>> R10: 00007ffdbb4ce0e8 R11: 0000000000000246 R12: 0000000000000000
>> R13: 00007ffdbb4cdf20 R14: 0000000000000000 R15: 0000000000000000
>>
>> Uninit was created at:
>>   kmsan_save_stack_with_flags syzkaller/managers/upstream-kmsan-gce-386/kernel/mm/kmsan/kmsan.c:121 [inline]
>>   kmsan_internal_poison_shadow+0x5c/0xf0 syzkaller/managers/upstream-kmsan-gce-386/kernel/mm/kmsan/kmsan.c:104
>>   kmsan_slab_alloc+0x8d/0xe0 syzkaller/managers/upstream-kmsan-gce-386/kernel/mm/kmsan/kmsan_hooks.c:76
>>   slab_alloc_node syzkaller/managers/upstream-kmsan-gce-386/kernel/mm/slub.c:2906 [inline]
>>   slab_alloc syzkaller/managers/upstream-kmsan-gce-386/kernel/mm/slub.c:2915 [inline]
>>   kmem_cache_alloc_trace+0x893/0x1000 syzkaller/managers/upstream-kmsan-gce-386/kernel/mm/slub.c:2932
>>   kmalloc syzkaller/managers/upstream-kmsan-gce-386/kernel/./include/linux/slab.h:552 [inline]
>>   bpf_iter_reg_target+0x81/0x3f0 syzkaller/managers/upstream-kmsan-gce-386/kernel/kernel/bpf/bpf_iter.c:276
>>   bpf_sk_storage_map_iter_init+0x6a/0x85 syzkaller/managers/upstream-kmsan-gce-386/kernel/net/core/bpf_sk_storage.c:870
>>   do_one_initcall+0x362/0x8d0 syzkaller/managers/upstream-kmsan-gce-386/kernel/init/main.c:1220
>>   do_initcall_level+0x1e7/0x35a syzkaller/managers/upstream-kmsan-gce-386/kernel/init/main.c:1293
>>   do_initcalls+0x127/0x1cb syzkaller/managers/upstream-kmsan-gce-386/kernel/init/main.c:1309
>>   do_basic_setup+0x33/0x36 syzkaller/managers/upstream-kmsan-gce-386/kernel/init/main.c:1329
>>   kernel_init_freeable+0x238/0x38b syzkaller/managers/upstream-kmsan-gce-386/kernel/init/main.c:1529
>>   kernel_init+0x1f/0x840 syzkaller/managers/upstream-kmsan-gce-386/kernel/init/main.c:1418
>>   ret_from_fork+0x1f/0x30 syzkaller/managers/upstream-kmsan-gce-386/kernel/arch/x86/entry/entry_64.S:296
>> =====================================================
>>
>>
>> ---
>> This report is generated by a bot. It may contain errors.
>> See https://goo.gl/tpsmEJ  for more information about syzbot.
>> syzbot engineers can be reached at syzkaller@googlegroups.com.
>>
>> syzbot will keep track of this issue. See:
>> https://goo.gl/tpsmEJ#status  for how to communicate with syzbot.
>>
>> --
>> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
>> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
>> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/000000000000364d5505babe13f5@google.com .
