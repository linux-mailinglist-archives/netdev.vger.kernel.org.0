Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 643B438FF00
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 12:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbhEYK0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 06:26:19 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:18166 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231423AbhEYK0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 06:26:17 -0400
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14PAEQR2008759;
        Tue, 25 May 2021 10:24:25 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by mx0a-0064b401.pphosted.com with ESMTP id 38rgn50ftq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 May 2021 10:24:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d7nYOAAhWH3nsW0kppK+zI8CnEqhRMSPRfPwuKuOep3NwnqX0Nx0JCHdUZS0LLRr13aZL8FCime9+kPekTrPr0aEW9hJOb/ivsQ3oGuOgrp8CpVJtkM5NYARZBvISMao6Xkn8MeLNub3UxsmNVP/Vz38s3RX/aRx2/hB8EuRwYS4D9PpQel7TxGTQvb0cPK7cwRUzS9XGkb8R3gqNtkLKRaCMS2LqYer5Mgp8XVASGwhpyqiLYGZaYKaPt756fQ/aP8J7K8DXOh7KjUj8KewV8AUKrsoQ7WuFimH4Tt+kHS6PR3ZkhU1pZWqpSEw38FfNlYW0hs96ZmnUSFgZxsjfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YkZ9RUQhNp9GhdZFx3NlVqRnDd57EWuEFT8OvJo1nP8=;
 b=juomUxg7OqmF+x/XpHfDlQ+25j4MNRvqo9o5hTqwe32aV9OQj2qb+O/MyF76q4XGiYjfMiHv/0fdNW1H4spI9wzE5XjWQba2PSWWrzySRwK+f9uL6rY0EcbiCXaiM3pDTPcFGsretctbG0iCKMV+MEgFqbb6p1acfmaA+oDyUuevDbs549/2KhKPCSsbyts1Tf2IcYnkl25CATT00GNYiUWQ8pT5uyqbw+1OOBxrvXmy27pkQxXXoY6GSGrWA9ex1eDXRlNuP+OEqnaRRxdwz8cElTWHC0KIHx2LaeXa+ZewBVWtdnuebc6sP54mrxWZG6ZRamKDR6mfjCJUgicRZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YkZ9RUQhNp9GhdZFx3NlVqRnDd57EWuEFT8OvJo1nP8=;
 b=gczVAqxd+o+ulFC6nBON3jwYaaNL/c82awsXgHWQle4Q9WixWu3vRSp7arxVjPzZomAdL6FU/z6S4kGfBuyX/cltnGrFcZvrw7yDVw1ehrUoenZwYAH6RgWFsWH2sp500wV6TjfkoNLmR+v3IWJ66w2w+wRRLUfcswADfDD/ARc=
Authentication-Results: fb.com; dkim=none (message not signed)
 header.d=none;fb.com; dmarc=none action=none header.from=windriver.com;
Received: from BY5PR11MB4241.namprd11.prod.outlook.com (2603:10b6:a03:1ca::13)
 by BYAPR11MB3480.namprd11.prod.outlook.com (2603:10b6:a03:79::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Tue, 25 May
 2021 10:24:21 +0000
Received: from BY5PR11MB4241.namprd11.prod.outlook.com
 ([fe80::34b3:17c2:b1ad:286c]) by BY5PR11MB4241.namprd11.prod.outlook.com
 ([fe80::34b3:17c2:b1ad:286c%5]) with mapi id 15.20.4150.027; Tue, 25 May 2021
 10:24:21 +0000
Subject: Re: [syzbot] KASAN: use-after-free Read in
 check_all_holdout_tasks_trace
To:     paulmck@kernel.org
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+7b2b13f4943374609532@syzkaller.appspotmail.com>,
        rcu@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, bpf <bpf@vger.kernel.org>,
        Christian Brauner <christian@brauner.io>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Shakeel Butt <shakeelb@google.com>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Yonghong Song <yhs@fb.com>
References: <000000000000f034fc05c2da6617@google.com>
 <CACT4Y+ZGkye_MnNr92qQameXVEHNc1QkpmNrG3W8Yd1Xg_hfhw@mail.gmail.com>
 <20210524041350.GJ4441@paulmck-ThinkPad-P17-Gen-1>
 <20210524224602.GA1963972@paulmck-ThinkPad-P17-Gen-1>
 <24f352fc-c01e-daa8-5138-1f89f75c7c16@windriver.com>
 <20210525033355.GN4441@paulmck-ThinkPad-P17-Gen-1>
From:   "Xu, Yanfei" <yanfei.xu@windriver.com>
Message-ID: <4b98d598-8044-0254-9ee2-0c9814b0245a@windriver.com>
Date:   Tue, 25 May 2021 18:24:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210525033355.GN4441@paulmck-ThinkPad-P17-Gen-1>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [60.247.85.82]
X-ClientProxiedBy: HK2P15301CA0010.APCP153.PROD.OUTLOOK.COM
 (2603:1096:202:1::20) To BY5PR11MB4241.namprd11.prod.outlook.com
 (2603:10b6:a03:1ca::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [128.224.162.160] (60.247.85.82) by HK2P15301CA0010.APCP153.PROD.OUTLOOK.COM (2603:1096:202:1::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.2 via Frontend Transport; Tue, 25 May 2021 10:24:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 21e21b9b-fd1c-4123-f171-08d91f6742cc
X-MS-TrafficTypeDiagnostic: BYAPR11MB3480:
X-Microsoft-Antispam-PRVS: <BYAPR11MB34809E23CF5AD7002484BDBDE4259@BYAPR11MB3480.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n3MNeVA9hNX/QcKoWHoNPUjwuaHwhZ28fOigFf7KBwQuKwHyW/2nkdTBqX8Gc3aYeGXQeJLW+7cZ+UfNM8MZwgD3/Fk4bEtmv5BzEL7GKptY1eUxUM20NdMWBs6rR6pp5JEmnCTT2GBasXAizkP5ehc/E17/H7Qt98GmHJUvPubhCrHaHDKDEy9m4pVl9jrXmEK26RLeYwj9pKhQi2im5x1gZjxCw7Hm/EmJumc+Kq1y3MsO6LA/fFNEz2jErwwELbyhoT22yMzb8Ur1yPF0CkGkcwAvrm6pCMHEI5//2MfvypTaCKSVvhXRB5n5EJOHz2d5l4p55SIlSNMYF8NEqNrAtTTmbr5PdwsmATNqwBvtyypTzZx0Du2aEIRbw+7SEootnew97WiCexuhjJXv471YscS/B+3DBwh6fXZ/nwpVRoDKyGmaFEPk68gPCam6jI24VnjaE5OwumftrZK4cXNznJXgzxoRiwFhacNIgV0EwrN9OAW6oYGAguA/CFxL51MqUV9ac0SKDzc5OyLcI6/+3BtgpMbiANGk1iggUm/MJcAXnXa0oYYWrvNd1s40RGpY7jGdBOv69ZZqvmt/p80vth3GgJC5zD1FQ36/h2eHAnKDmTikxr0ZQcPxOSJCAdKAnjSC0z+9ESry0XhMfQKsvxcNc7Q/X8kLtnFEDFOQcP09MUC9YK2CFM7Dm5jF3SBWdG9Qb+W5787FGkDc5IHwVbgw1pwJQwq0vVzxmmUkpPd1YhoDe4y+2yn5yt7+zeitOY4pXA6e60MJWtSaz0V0ymwRL5TNltDEEVLAwEpAdpNJoxh5TlKjsZZTMRxdcI8X00TVRcE1pzGZqtB0FJOJ4SCkdDBTanM3ZC0DTdDs229bUgrutDc0p/CX0ILT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4241.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(39850400004)(396003)(346002)(376002)(31686004)(956004)(86362001)(66556008)(16526019)(186003)(2906002)(8936002)(4326008)(6486002)(6706004)(8676002)(83380400001)(53546011)(5660300002)(52116002)(2616005)(66946007)(6916009)(31696002)(36756003)(38350700002)(966005)(38100700002)(6666004)(16576012)(7416002)(26005)(478600001)(66476007)(316002)(54906003)(99710200001)(78286007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?azhmbVB0bURqWldkWFZyMXFFQ2o2Y2J2cVlyVG1oMGt4WkhyT1poSkttTTNn?=
 =?utf-8?B?bk4weWVoMWh5VktHaTU3NThncXJJTUR5L3V1V0ZhYTIwZ0tZSDJYV1NoTWZj?=
 =?utf-8?B?WUpKOTdEcXpGd3JNeVpuMlZxbi9aVDQxYWpPTmxVZE5wSjZ6SUFyOUxJck8v?=
 =?utf-8?B?SXpCeS83aTRPSUE1RTRoTWFjR0N0SmZyeUZQeDhwVjNid1VFdTNuOXFLSWp0?=
 =?utf-8?B?L1piZ2YvN2dVQkZlN29jWGlneVVkRzJTMDVHeExpTkNsMmhVNFJRSXNjMklJ?=
 =?utf-8?B?S05yb0RFc29HUHdMeWY2OEZncERNMFhCd1FQK2VSWGtreWFwVXpUdTZjMWRq?=
 =?utf-8?B?alZRVVI0dEFGeGlwZmEvdk1ZYkF2Qlc1KzV4VjBkN0Rvd3ZjOXp1VzduSTFN?=
 =?utf-8?B?MzF5L2RoZjVROFNZQnNzRE1Qa01mQkw4Z0gxSWdRZGMwYTVIbFJlN1kzbUlM?=
 =?utf-8?B?V0JsamQ5NkFrZnhETXRTY3MzWVMrSFBTM1BMdkZyKzcvRkZ1RVlHdFpTMjMr?=
 =?utf-8?B?SFdKSUpTMy9vOUdOTDN4RVJ6eklxaHJaUG56THluaVRoNTdqYlRHdVo3U3M2?=
 =?utf-8?B?ZExTemFRd2paN3RwVHduVnhYd0h4SWFQTFVMSDNhQ25pc3N1Y3M0N0VPaTNR?=
 =?utf-8?B?M3A4TSsvM0lRT3grU201SkkraGh3OCtwa1diM3hqcVAySjBpU3F1VTVCazNQ?=
 =?utf-8?B?dnhGMWgwSmtkSVo4UWNuaG5jM0hhVGt6WDMvSUJOTmxhTGlLQ3d3VTQrd3lw?=
 =?utf-8?B?ZDlBd1Z3c0Y2VmNxcWIzbTNuN3YwbDlwaUgvaTlNUVY0QmhONCs1a0h1aEhF?=
 =?utf-8?B?TklIL1VGY3hzN0hsZEp3aHErL1MwZkRCMTJka3VFYnFHSTZWRGpXbUNtK2sy?=
 =?utf-8?B?RnVIYlh3NS9MSE5JK1MyWmtKdWdENG4wZmNyTUI0NkpHWTB5bEF2Z2xFZHJz?=
 =?utf-8?B?TDVIamVPUVNUUWp2SUp3bmx5Z3ExbnA5N2hQbUpQTE9xYUFxTjhmdytHSTl4?=
 =?utf-8?B?WStFWVc4MEJDRUkwc01PZ3YxQnMyblBhb2FhMVJwSXpIT05mejlqZjdWYk9j?=
 =?utf-8?B?NzJiOTBuNlI0RmxJTlNlVGRvalFVMHpsUVBvRnl3YUYwN0JIY2xJaUVaWG5q?=
 =?utf-8?B?RkNhR2I3RUp4MXdBUGlvZ3c0VmdOSFZ5ejRSWTEvclhyYXN6eS8yU1h0ODZ5?=
 =?utf-8?B?K1VxMHQrWjl5b3FLRFlVUWdFczMyQUhsNzZzK3RaUlFHUWtjZjFOWTlzaG8r?=
 =?utf-8?B?dnFkdjFPMVVmSE9VeTIzc015UXozalUwSE5pMzNOcHJ6YXNtZlpLS0kvMmlC?=
 =?utf-8?B?eXV2N3U1d3E5c0JaenZMMTdBcEVCUDlrMkYxN1lQb2VhUytHRTlNRUhHTDlB?=
 =?utf-8?B?Qks0eU5zMHUrbnpET0N5ZER5dnVxM1dUUmw0YmNKNUxyTnZHdnB5TTI4ZURN?=
 =?utf-8?B?VWIzOHI1amErRmZZampLVzdsbnFMQ3ZjVmxXRXZHNTJkQWtuUy9Bc1VXNEZY?=
 =?utf-8?B?TVRrc0tuL3R4RVNncy9JM2VTVlk3RWVmYjI0NlAxOEMwTzA1bXFFTENLdVcw?=
 =?utf-8?B?KzRLRTlEK1lTRFR6T0dGcXM3TkNJMlJoc2RzMFhQUll4S3pNUytabVAra0No?=
 =?utf-8?B?VXFEcnpwcUpPSmlBZE1xeWhhcEx1Y0JTeXMzWUhFQVJqazJLelB1Rm1veG5E?=
 =?utf-8?B?Z3JOdjhkQitZU2Vab2ZkSU03dmJEUjRWa21SMlRLOVp3emk2Y215SWg4Nk1I?=
 =?utf-8?Q?k5KNqATYKfMp91HNrQXgipxFyqsD4HH62ymy286?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21e21b9b-fd1c-4123-f171-08d91f6742cc
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4241.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 10:24:21.4914
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i5gPqpqpa2k0gB0jK5t96F1p5vcqRzbbtgaaSVD8nkROlcjUC8elxSnmPZ+cnRL5qmtDEZWoTpz+QQywXwfb3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3480
X-Proofpoint-GUID: rzraKglHO25zGJq8FzaBCZQXKS15_5cM
X-Proofpoint-ORIG-GUID: rzraKglHO25zGJq8FzaBCZQXKS15_5cM
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-25_05:2021-05-25,2021-05-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 phishscore=0 spamscore=0 mlxscore=0 suspectscore=0 clxscore=1015
 bulkscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2105250068
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/25/21 11:33 AM, Paul E. McKenney wrote:
> [Please note: This e-mail is from an EXTERNAL e-mail address]
> 
> On Tue, May 25, 2021 at 10:31:55AM +0800, Xu, Yanfei wrote:
>>
>>
>> On 5/25/21 6:46 AM, Paul E. McKenney wrote:
>>> [Please note: This e-mail is from an EXTERNAL e-mail address]
>>>
>>> On Sun, May 23, 2021 at 09:13:50PM -0700, Paul E. McKenney wrote:
>>>> On Sun, May 23, 2021 at 08:51:56AM +0200, Dmitry Vyukov wrote:
>>>>> On Fri, May 21, 2021 at 7:29 PM syzbot
>>>>> <syzbot+7b2b13f4943374609532@syzkaller.appspotmail.com> wrote:
>>>>>>
>>>>>> Hello,
>>>>>>
>>>>>> syzbot found the following issue on:
>>>>>>
>>>>>> HEAD commit:    f18ba26d libbpf: Add selftests for TC-BPF management API
>>>>>> git tree:       bpf-next
>>>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=17f50d1ed00000
>>>>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=8ff54addde0afb5d
>>>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=7b2b13f4943374609532
>>>>>>
>>>>>> Unfortunately, I don't have any reproducer for this issue yet.
>>>>>>
>>>>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>>>>> Reported-by: syzbot+7b2b13f4943374609532@syzkaller.appspotmail.com
>>>>>
>>>>> This looks rcu-related. +rcu mailing list
>>>>
>>>> I think I see a possible cause for this, and will say more after some
>>>> testing and after becoming more awake Monday morning, Pacific time.
>>>
>>> No joy.  From what I can see, within RCU Tasks Trace, the calls to
>>> get_task_struct() are properly protected (either by RCU or by an earlier
>>> get_task_struct()), and the calls to put_task_struct() are balanced by
>>> those to get_task_struct().
>>>
>>> I could of course have missed something, but at this point I am suspecting
>>> an unbalanced put_task_struct() has been added elsewhere.
>>>
>>> As always, extra eyes on this code would be a good thing.
>>>
>>> If it were reproducible, I would of course suggest bisection.  :-/
>>>
>>>                                                           Thanx, Paul
>>>
>> Hi Paul,
>>
>> Could it be?
>>
>>         CPU1                                        CPU2
>> trc_add_holdout(t, bhp)
>> //t->usage==2
>>                                        release_task
>>                                          put_task_struct_rcu_user
>>                                            delayed_put_task_struct
>>                                              ......
>>                                              put_task_struct(t)
>>                                              //t->usage==1
>>
>> check_all_holdout_tasks_trace
>>    ->trc_wait_for_one_reader
>>      ->trc_del_holdout
>>        ->put_task_struct(t)
>>        //t->usage==0 and task_struct freed
>>    READ_ONCE(t->trc_reader_checked)
>>    //ops， t had been freed.
>>
>> So, after excuting trc_wait_for_one_reader（）, task might had been removed
>> from holdout list and the corresponding task_struct was freed.
>> And we shouldn't do READ_ONCE(t->trc_reader_checked).
> 
> I was suspicious of that call to trc_del_holdout() from within
> trc_wait_for_one_reader(), but the only time it executes is in the
> context of the current running task, which means that CPU 2 had better
> not be invoking release_task() on it just yet.
> 
> Or am I missing your point?

Two times.
1. the task is current.

                trc_wait_for_one_reader
                  ->trc_del_holdout

2. task isn't current.

                trc_wait_for_one_reader
                  ->get_task_struct
                  ->try_invoke_on_locked_down_task（trc_inspect_reader）
                    ->trc_del_holdout
                  ->put_task_struct


> 
> Of course, if you can reproduce it, the following patch might be

Sorry...I can't reproduce it, just analyse syzbot's log. :(


Thanks,
Yanfei

> an interesting thing to try, my doubts notwithstanding.  But more
> important, please check the patch to make sure that we are both
> talking about the same call to trc_del_holdout()!
> 
> If we are talking about the same call to trc_del_holdout(), are you
> actually seeing that code execute except when rcu_tasks_trace_pertask()
> calls trc_wait_for_one_reader()?
> 
>> I investigate the trc_wait_for_one_reader（） and found before we excute
>> trc_del_holdout, there is always set t->trc_reader_checked=true. How about
>> we just set the checked flag and unified excute trc_del_holdout()
>> in check_all_holdout_tasks_trace with checking the flag?
> 
> The problem is that we cannot execute trc_del_holdout() except in
> the context of the RCU Tasks Trace grace-period kthread.  So it is
> necessary to manipulate ->trc_reader_checked separately from the list
> in order to safely synchronize with IPIs and with the exit code path
> for any reader tasks, see for example trc_read_check_handler() and
> exit_tasks_rcu_finish_trace().
> 
> Or are you thinking of some other approach?
> 
>                                                          Thanx, Paul
> 
> ------------------------------------------------------------------------
> 
> diff --git a/kernel/rcu/tasks.h b/kernel/rcu/tasks.h
> index efb8127f3a36..2a0d4bdd619a 100644
> --- a/kernel/rcu/tasks.h
> +++ b/kernel/rcu/tasks.h
> @@ -987,7 +987,6 @@ static void trc_wait_for_one_reader(struct task_struct *t,
>          // The current task had better be in a quiescent state.
>          if (t == current) {
>                  t->trc_reader_checked = true;
> -               trc_del_holdout(t);
>                  WARN_ON_ONCE(READ_ONCE(t->trc_reader_nesting));
>                  return;
>          }
> 
