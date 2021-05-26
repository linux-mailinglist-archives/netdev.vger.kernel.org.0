Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62B76390E46
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 04:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231881AbhEZCZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 22:25:11 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:3398 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229907AbhEZCZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 22:25:10 -0400
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14Q2G3Pf011333;
        Tue, 25 May 2021 19:23:14 -0700
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2170.outbound.protection.outlook.com [104.47.73.170])
        by mx0a-0064b401.pphosted.com with ESMTP id 38s7nt86s3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 May 2021 19:23:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m82phghqz68CrXqfCJYKJrOQ3tyIpkBeBarzdIU4GgI7F85tUQRX/RcXuwkWpP9QPTpkZgUue6KPzKc6Lf+rGLZOfqLlYKeVLe9aUUmJzXRgDFD9Cyg8/dlB1mVL60f8+ApTgsZq/Y0uGOidnx1tOvDXXoFkKcQ4/0up5yoip3S3hxDPy1Ibkaq3dWRESoKuZTDtn2o0dK9k+c0FjO6KIKWAE5detUiPxQQmtWr/RziNxkAg9wx2jqEvZmXNBU3tEgqKiMh3ZaEwyjviVLy7gdEj8g4VlS5QlpT3Pb85LboG2HaoYFhFNuhj+7KNXbyZAnKFAXWofmU/lw+MX8Cjqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W8DlXYvZJQB1gI5YUsV0EWtK7iqAOMFWwM45L5P4Zuc=;
 b=ZRs7gWE22TAS7qzjcudDNbE8drhON3QtUwymS4zL7SuItnuabdzjY0RCNSnaFcmNmEtRQaLKAnQLSMxoiV3PnT6290zzBe2KyleSlXOCHC5AKR6pNZysbGXbSzJvKLjenP9bsqjK4P/Q0H0eyaFY2b0gS/hy9TkBSOMxvkfTdFbhHo/9rWnk31FMB4lolHP5dnTdTt3biGoy5JfmS6StONIENmxNickeVdg+xDnlEo5DViAPiWDd7AtGoEuOVvx+eMMN4DnL01B+aModRieB9NlRR5osrWAcqT8kjd5bsxFQ++N/eO9/p12LFU+2BdQa1TRUXqpyAqSxsr1uahudCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W8DlXYvZJQB1gI5YUsV0EWtK7iqAOMFWwM45L5P4Zuc=;
 b=YxkZS7+tGq8apWzeSavkcl0AiKmf35QpfdWWpK3LTRtAFd7xb3YbaWj27/Fpdcc3aG+ZbHL5FjxLZHMWFZ0FsgKGVHTjEcRv2uN0o/1oA3bxbiE+GkTEgPuSw5AiQrUVyG4W0QSKYzc/O4uuNNDXxzDbHjkHqeWHmIuuO3LIvsE=
Authentication-Results: fb.com; dkim=none (message not signed)
 header.d=none;fb.com; dmarc=none action=none header.from=windriver.com;
Received: from BY5PR11MB4241.namprd11.prod.outlook.com (2603:10b6:a03:1ca::13)
 by BYAPR11MB2840.namprd11.prod.outlook.com (2603:10b6:a02:c9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Wed, 26 May
 2021 02:23:11 +0000
Received: from BY5PR11MB4241.namprd11.prod.outlook.com
 ([fe80::34b3:17c2:b1ad:286c]) by BY5PR11MB4241.namprd11.prod.outlook.com
 ([fe80::34b3:17c2:b1ad:286c%5]) with mapi id 15.20.4150.027; Wed, 26 May 2021
 02:23:10 +0000
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
 <4b98d598-8044-0254-9ee2-0c9814b0245a@windriver.com>
 <20210525142835.GO4441@paulmck-ThinkPad-P17-Gen-1>
From:   "Xu, Yanfei" <yanfei.xu@windriver.com>
Message-ID: <62d52830-e422-d08d-fbb8-9e0984672ffe@windriver.com>
Date:   Wed, 26 May 2021 10:22:59 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210525142835.GO4441@paulmck-ThinkPad-P17-Gen-1>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [60.247.85.82]
X-ClientProxiedBy: HKAPR03CA0031.apcprd03.prod.outlook.com
 (2603:1096:203:c9::18) To BY5PR11MB4241.namprd11.prod.outlook.com
 (2603:10b6:a03:1ca::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [128.224.162.160] (60.247.85.82) by HKAPR03CA0031.apcprd03.prod.outlook.com (2603:1096:203:c9::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.12 via Frontend Transport; Wed, 26 May 2021 02:23:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 86ec3ea3-3c12-456b-a952-08d91fed34cc
X-MS-TrafficTypeDiagnostic: BYAPR11MB2840:
X-Microsoft-Antispam-PRVS: <BYAPR11MB2840F056E98A6F00C13AF0EAE4249@BYAPR11MB2840.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l5IoadT4ogMX5gc5plk4fg4DdC1l9RGm8yQyCZZEUDH1XKKxGZFag3ep+Cc2AzL1JYnLANUM3kEH2hzwgsi3vHKdkmnkna2j6O0ujHea/PtVqutg+eXV5Rf2TuVXiVxC/mhq5xqRNBxdelJhz4/q6n14J4rGPFEd1QgfkCGMsnJaKq62xMzZtJR3zQjEputKxXECEoFiol7DTIqFD21PMj3M4MzmjmG59TLJfDRjx/opWPBAlpErtYiDK5pt8U3qopQsKhjjIy4z2e+wJl8WltflrdCKqltZvvawA1/ugq8Vbw81mksrUZdJuxasbZR6ACZQEY1Q9SUbXGYmwgVjtL48Hb/ET1DUJ4a/ep8aA1TP2Z1n1Sxe9t7aPDmd2kOzJZFuTPdZov1W6Quu7rCKnaDrzdgOxM0BWi9nboZDxkuSMZFHOZbdR6BsfXcGw4/jhwPkUSppc+Va+ow4QvLyyWkKLIZh7dDJvSq+aO7vk1GXQ63/ywA21jg3bZ3GkxGIbJBIV5qlcBL8l/Ay+Et94ek6zRCwY2eMXC91DrJk38iWiZdO9TZQNvZRvQ9kN0kGFH+Jo4h2B+zgp1oN/yliJfYFYWooDfW6rb3+3IaAlKaXtp5mjKjp9EDiP8yZtAgfLh3oDd02vqa0ybxuXWzM8aS5EKFgLvjVp4u69upNgZcYqPNBdbnlZTURtiJ8EpKSqUenkoYyimEycziCiSCp8Gngo59IG5DvVgZzkejpv6FLPkXOMpE+ypl5uWgs/Mxl1Jq4MdlCbeCJp/lLOCD0UXdU78XiTr1tppkMYCHgUitxg7EMlfcT4ZvVLrCT972TEVPAuu2+/Pl1lMBdkL6o7jKNY5tb2oPfRYjGfaOlOYgq8iWu6CjtCV5v8GEaBW5x
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4241.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(39850400004)(376002)(346002)(31686004)(7416002)(956004)(86362001)(54906003)(66556008)(6486002)(6666004)(4326008)(6706004)(478600001)(26005)(186003)(8936002)(2906002)(83380400001)(8676002)(6916009)(5660300002)(31696002)(16526019)(66476007)(66946007)(38100700002)(36756003)(2616005)(966005)(38350700002)(16576012)(53546011)(316002)(52116002)(99710200001)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RDlaVWlYUWNrUXlCUkNoc1BNRllyalZEMXN2QTVuRGV6Vmd1Uk5ZVUhldlJo?=
 =?utf-8?B?NEdObUd6OE9hY1lHNlNGTUJ2bWoybWltblNPMldRWGZTR2xIRzR6QThQckNC?=
 =?utf-8?B?dk53SlZFbFYzZmlFZWtYZDBHb0UwaUlZTmx1Y3cydE9kdDJ2bEcwTGJjUHdv?=
 =?utf-8?B?cUd4QjBkaHo0SVNCN2VyR2c1WWRla0FzLzAxT0dscUpNZ3g3TVVxbndTU2RW?=
 =?utf-8?B?WlhtN3NKcHlraXlPRzlrcmdzbHRYWTJiUkkrRlROZWJ2WlJiSnE4SU1xbWt0?=
 =?utf-8?B?TUpsNjNKNkw0UE1BVk1aUENXRFdDalRyRnF6MFJTQ0RiVnBsdjVWWThGOUJq?=
 =?utf-8?B?L25CRm1MRFpiSDVBNEFIc0dlR1V4K2ZVR3hqM3dsVkk2bXErYTVYK3p2emth?=
 =?utf-8?B?Ylpoc1IyNlVXY0Vybkhaa3lvY3BBakg1aDdKRmxLNktqSWZxQ2xkQm1YN1F6?=
 =?utf-8?B?NEEvWHRwTTlBaFhINHZUemlVb0tZVU8wUVdkeXZ3WDNwOVNubUEvZDlkRWow?=
 =?utf-8?B?emR2a2pTVU9FTmdEU1MrMklKcDk2Zy9hai9aY0RIZ2haVDZLbXNOdnYwalZt?=
 =?utf-8?B?M2RSYW96ZllvM2Juek5jVFhiMk1RL091WXgwZ3NnK3pkaWZ1bDNKMkVRVFVO?=
 =?utf-8?B?a254YnB6elZFRjJWZVN0V2lwdnhaRlpFUFRqQzQ0YUoyWUQ2KytqWTFQZWg1?=
 =?utf-8?B?VW5ITmxmbGlEUm1BWFA2OEduQmtiTGVNU3pYVlpWQTNvdVNkLzFVMVpNOUtH?=
 =?utf-8?B?emtvREE3MHFrRGNiRFppTkxwTlAwTGlXek14cENnWkJ0VWQzOU9LWWJtMWtH?=
 =?utf-8?B?VUZ4OGJKbmo1TUlLcnRNNnVIc0gxR1l0S2NjUndNZUgvMFBjakI0UE13Q0xr?=
 =?utf-8?B?WUFNdnNKV2tPYTJvNGhFWnhCU2FyL3htcXY2dVQ4cEF3dnFGaDhPSkxFR3Ez?=
 =?utf-8?B?MGVRa3oxVmluRlMyN3kvdnI2blNQaWJSTUdGNG9aWTNnQkg4TWJXeDV3d2Rx?=
 =?utf-8?B?czAxRVVyclp6TlFMREpyWnYzUHZtbnp4SDZ3WDEzUVA0VkNJdVlMZUt0ekhZ?=
 =?utf-8?B?WHl1R0NkbXJMTmZIODltOUxVMzZ3M1BvNU5kTndqYVFwZkdqTHZRWWFIeUhx?=
 =?utf-8?B?WUk0THlOeUx3TlV2RGtUV2ZudlhOcUtlNVA0NGRHMlRhN2xkYkJVN1NFWWFH?=
 =?utf-8?B?Q1pMZ3BzUXlGOVpCcmNORmlaSVdNOFNrUjRmOHpmYUtQdEpKVXBNZDZJWEZL?=
 =?utf-8?B?WXBoekJBVHI2WXpKRExGcXZwYXh3aS90ZEFVZzdPaTlSQ2wrRDVERUlaN2g4?=
 =?utf-8?B?ZGZraVE0bTJRSEx0MEhoSk9KVktBNW5ldS94c0JFdWQ4OCt2MnU0ZmJyTWhK?=
 =?utf-8?B?NGVmME44Y0RGUis2cm5FZjROMVA1L0MwdDl0V3dLcVk5SnBLSFIyeFZyaTYz?=
 =?utf-8?B?WW5ZaFFndFRpdll0WVF1M3JibjJMWmJCOGJTQ0NHTTNIdk0ycW5KUy9rcUlZ?=
 =?utf-8?B?ZmFQbVI4Y1ViMGtNeXdDTk1Fc2pCRlRqSUcwc1ZsUWpKbFhmazFuUWE1Vk12?=
 =?utf-8?B?TVZES29YOTBuYlpwRlJhQVBqMjlwVE1TK2xoREVsOTNXNVBNSlU5TG5uY0l6?=
 =?utf-8?B?a2lmRW5zTFRmU1NZUVQ2cGZrSkZlOEsvTkYxVkgzVmJ3a0R4RTVUTnJQT3Qz?=
 =?utf-8?B?WTBpQzZ6SjZmVGt6U2tRaTJ6NUdPVzZzd2dmbDZyNTV1RkYwZktFZEN0ZmQz?=
 =?utf-8?Q?5DLT8j/Sv3kOcBwB3cEsrG3UqNjKn6Bp2gJNdA7?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86ec3ea3-3c12-456b-a952-08d91fed34cc
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4241.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 02:23:10.7151
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4/vbz1FHGCpiZocEZzzXhaUkHa6NmCA0V2YXU77XXVFKqX/xKk/x8/RlwFo+v4/G/24jJFBCMNxf+nPu78N95g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2840
X-Proofpoint-ORIG-GUID: IOUOmRlvUnpPcqxS9zCBe8zbu9Ec-2Xi
X-Proofpoint-GUID: IOUOmRlvUnpPcqxS9zCBe8zbu9Ec-2Xi
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-25_09:2021-05-25,2021-05-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 bulkscore=0 lowpriorityscore=0 adultscore=0 mlxlogscore=999 clxscore=1015
 priorityscore=1501 mlxscore=0 phishscore=0 spamscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105260015
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/25/21 10:28 PM, Paul E. McKenney wrote:
> [Please note: This e-mail is from an EXTERNAL e-mail address]
> 
> On Tue, May 25, 2021 at 06:24:10PM +0800, Xu, Yanfei wrote:
>>
>>
>> On 5/25/21 11:33 AM, Paul E. McKenney wrote:
>>> [Please note: This e-mail is from an EXTERNAL e-mail address]
>>>
>>> On Tue, May 25, 2021 at 10:31:55AM +0800, Xu, Yanfei wrote:
>>>>
>>>>
>>>> On 5/25/21 6:46 AM, Paul E. McKenney wrote:
>>>>> [Please note: This e-mail is from an EXTERNAL e-mail address]
>>>>>
>>>>> On Sun, May 23, 2021 at 09:13:50PM -0700, Paul E. McKenney wrote:
>>>>>> On Sun, May 23, 2021 at 08:51:56AM +0200, Dmitry Vyukov wrote:
>>>>>>> On Fri, May 21, 2021 at 7:29 PM syzbot
>>>>>>> <syzbot+7b2b13f4943374609532@syzkaller.appspotmail.com> wrote:
>>>>>>>>
>>>>>>>> Hello,
>>>>>>>>
>>>>>>>> syzbot found the following issue on:
>>>>>>>>
>>>>>>>> HEAD commit:    f18ba26d libbpf: Add selftests for TC-BPF management API
>>>>>>>> git tree:       bpf-next
>>>>>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=17f50d1ed00000
>>>>>>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=8ff54addde0afb5d
>>>>>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=7b2b13f4943374609532
>>>>>>>>
>>>>>>>> Unfortunately, I don't have any reproducer for this issue yet.
>>>>>>>>
>>>>>>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>>>>>>> Reported-by: syzbot+7b2b13f4943374609532@syzkaller.appspotmail.com
>>>>>>>
>>>>>>> This looks rcu-related. +rcu mailing list
>>>>>>
>>>>>> I think I see a possible cause for this, and will say more after some
>>>>>> testing and after becoming more awake Monday morning, Pacific time.
>>>>>
>>>>> No joy.  From what I can see, within RCU Tasks Trace, the calls to
>>>>> get_task_struct() are properly protected (either by RCU or by an earlier
>>>>> get_task_struct()), and the calls to put_task_struct() are balanced by
>>>>> those to get_task_struct().
>>>>>
>>>>> I could of course have missed something, but at this point I am suspecting
>>>>> an unbalanced put_task_struct() has been added elsewhere.
>>>>>
>>>>> As always, extra eyes on this code would be a good thing.
>>>>>
>>>>> If it were reproducible, I would of course suggest bisection.  :-/
>>>>>
>>>>>                                                            Thanx, Paul
>>>>>
>>>> Hi Paul,
>>>>
>>>> Could it be?
>>>>
>>>>          CPU1                                        CPU2
>>>> trc_add_holdout(t, bhp)
>>>> //t->usage==2
>>>>                                         release_task
>>>>                                           put_task_struct_rcu_user
>>>>                                             delayed_put_task_struct
>>>>                                               ......
>>>>                                               put_task_struct(t)
>>>>                                               //t->usage==1
>>>>
>>>> check_all_holdout_tasks_trace
>>>>     ->trc_wait_for_one_reader
>>>>       ->trc_del_holdout
>>>>         ->put_task_struct(t)
>>>>         //t->usage==0 and task_struct freed
>>>>     READ_ONCE(t->trc_reader_checked)
>>>>     //ops， t had been freed.
>>>>
>>>> So, after excuting trc_wait_for_one_reader（）, task might had been removed
>>>> from holdout list and the corresponding task_struct was freed.
>>>> And we shouldn't do READ_ONCE(t->trc_reader_checked).
>>>
>>> I was suspicious of that call to trc_del_holdout() from within
>>> trc_wait_for_one_reader(), but the only time it executes is in the
>>> context of the current running task, which means that CPU 2 had better
>>> not be invoking release_task() on it just yet.
>>>
>>> Or am I missing your point?
>>
>> Two times.
>> 1. the task is current.
>>
>>                 trc_wait_for_one_reader
>>                   ->trc_del_holdout
> 
> This one should be fine because the task cannot be freed until it
> actually exits, and the grace-period kthread never exits.  But it
> could also be removed without any problem that I see. >

Agree, current task's task_struct should be high probably safe.  If you 
think it is safe to remove, I prefer to remove it. Because it can make 
trc_wait_for_one_reader's behavior about deleting task from holdout more 
unified. And there should be a very small racy that the task is checked 
as a current and then turn into a exiting task before its task_struct is 
accessed in trc_wait_for_one_reader or check_all_holdout_tasks_trace.（or 
I misunderstand something about rcu tasks）

>> 2. task isn't current.
>>
>>                 trc_wait_for_one_reader
>>                   ->get_task_struct
>>                   ->try_invoke_on_locked_down_task（trc_inspect_reader）
>>                     ->trc_del_holdout
>>                   ->put_task_struct
> 
> Ah, this one is more interesting, thank you!
> 
> Yes, it is safe from the list's viewpoint to do the removal in the
> trc_inspect_reader() callback, but you are right that the grace-period
> kthread may touch the task structure after return, and there might not
> be anything else holding that task structure in place.
> 
>>> Of course, if you can reproduce it, the following patch might be
>>
>> Sorry...I can't reproduce it, just analyse syzbot's log. :(
> 
> Well, if it could be reproduced, that would mean that it was too easy,
> wouldn't it?  ;-)

Ha ;-)
> 
> How about the (untested) patch below, just to make sure that we are
> talking about the same thing?  I have started testing, but then
> again, I have not yet been able to reproduce this, either.
> 
>                                                          Thanx, Paul
> 

Yes! we are talking the same thing, Should I send a new patch?

Thanks,
Yanfei

> ------------------------------------------------------------------------
> 
> diff --git a/kernel/rcu/tasks.h b/kernel/rcu/tasks.h
> index efb8127f3a36..8b25551d10db 100644
> --- a/kernel/rcu/tasks.h
> +++ b/kernel/rcu/tasks.h
> @@ -957,10 +957,9 @@ static bool trc_inspect_reader(struct task_struct *t, void *arg)
>                  in_qs = likely(!t->trc_reader_nesting);
>          }
> 
> -       // Mark as checked.  Because this is called from the grace-period
> -       // kthread, also remove the task from the holdout list.
> +       // Mark as checked so that the grace-period kthread will
> +       // remove it from the holdout list.
>          t->trc_reader_checked = true;
> -       trc_del_holdout(t);
> 
>          if (in_qs)
>                  return true;  // Already in quiescent state, done!!!
> 
