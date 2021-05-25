Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D741D38F838
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 04:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbhEYCeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 22:34:03 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:28384 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230132AbhEYCd7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 22:33:59 -0400
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14P2UVEV000885;
        Tue, 25 May 2021 02:32:08 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by mx0a-0064b401.pphosted.com with ESMTP id 38rgn508km-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 May 2021 02:32:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VnuPkKf6CsBdp6WV+WS9+0xtmWYOzb/y4IRsj45xlmcoEn0HTi31vFT6kY7m7MMWDQrZOd9qJtR2Xy8b40qWUIqUn46BiRtvNVzlFJqoG0/h+w1s3L4qVxeE4QGhLtO6sE4ABN8lX1mLWrJ+uaAdfQe/wNtOG4aXPbXP7tTKkcFd1/wfuS37hUUTp/Mcb5ByG+6eae2JMaDPbNoNboOqJ4zgqi1gjV6lIPQbDIKv6ssoNkQNb8JzMUR8exx5FqQubzm1B4fk4TvkhtFr/mxAG0QkJET9xW9yrnKVNdmhwigFgd+3jqrkPzkc8mrHxC/ROfbD4vEUjsDfiaoLoa40GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HJtnAz6ptk/fff6a/oMdcslkgWfmy4DZF93+wKK0bLY=;
 b=K851l9BdYIVPU04JJpzIu+DGGHJg2Md4YAHx9JLy0P9GeKO7eewc96IEy6HkDBfXpOmvrpUlXjdQhh2AjdyZcRIAtvRP/D1NWTOjSP2Dt+J6/xbyhytFi7rDcE03MHHxyec8Q4d2TDALJ1PHkNjue0DwlRR4zzKytSYtrifYE6VEEQNytDJ2jv7+y3ArCeZM4tIMy5mAPfq1mammIbl/Tgi/YS2pTz+O4EBUMUwvzEPZyg2lgXmsMfrmlQrQqouDlaJzX0zPxjfpOvttD2oIZcodp7PI/btW27FLEJKMvUMOWH34dJsT6fb0APwkBkbChnBDVFlJ4cpzD2ZfKBQ+LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HJtnAz6ptk/fff6a/oMdcslkgWfmy4DZF93+wKK0bLY=;
 b=WJGLgcaNLV7wIRKRLuE9QRFBPzNBK9V0hgcEUDoEVXqPvfMBo8ZD3QhPFWLF2ydUweOz3vJpVeWUYJjCvyMKaO6oxyGFOyzncsI0JRHk3wZKyxQR7nHIvr+vwhvFrsKrQ+Hn1WOwSZ5t3UP3Lf17PN/bVNsVa1ZJtYQ3UEAkNdg=
Authentication-Results: fb.com; dkim=none (message not signed)
 header.d=none;fb.com; dmarc=none action=none header.from=windriver.com;
Received: from BY5PR11MB4241.namprd11.prod.outlook.com (2603:10b6:a03:1ca::13)
 by BYAPR11MB3765.namprd11.prod.outlook.com (2603:10b6:a03:f6::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Tue, 25 May
 2021 02:32:05 +0000
Received: from BY5PR11MB4241.namprd11.prod.outlook.com
 ([fe80::34b3:17c2:b1ad:286c]) by BY5PR11MB4241.namprd11.prod.outlook.com
 ([fe80::34b3:17c2:b1ad:286c%5]) with mapi id 15.20.4150.027; Tue, 25 May 2021
 02:32:05 +0000
Subject: Re: [syzbot] KASAN: use-after-free Read in
 check_all_holdout_tasks_trace
To:     paulmck@kernel.org, Dmitry Vyukov <dvyukov@google.com>
Cc:     syzbot <syzbot+7b2b13f4943374609532@syzkaller.appspotmail.com>,
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
From:   "Xu, Yanfei" <yanfei.xu@windriver.com>
Message-ID: <24f352fc-c01e-daa8-5138-1f89f75c7c16@windriver.com>
Date:   Tue, 25 May 2021 10:31:55 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210524224602.GA1963972@paulmck-ThinkPad-P17-Gen-1>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [60.247.85.82]
X-ClientProxiedBy: SJ0PR03CA0122.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::7) To BY5PR11MB4241.namprd11.prod.outlook.com
 (2603:10b6:a03:1ca::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [128.224.162.160] (60.247.85.82) by SJ0PR03CA0122.namprd03.prod.outlook.com (2603:10b6:a03:33c::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26 via Frontend Transport; Tue, 25 May 2021 02:32:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9fb515d8-9237-4e47-cc7c-08d91f2548d3
X-MS-TrafficTypeDiagnostic: BYAPR11MB3765:
X-Microsoft-Antispam-PRVS: <BYAPR11MB3765EB97AC2DCE4BB54972CEE4259@BYAPR11MB3765.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gBAaJjnEh3Zvv276yOgzAIjcOA032Bixf9nKgGkxvr5x0G+/AS7zIKEMfAK/lnyJ2Ak1nu2ngG042wOkYpBwhX4qJVb+zIxmt6ZN33M5wkHYxc/IknYzQOP6BxFq9OXXCncz4uPw1axMUHYHK94aaHp0vNt4S+Tt4nOaKyO2jaCy6NCUuCKGE+o0LzY8bbJUoyqaEAwkA0z5qe+/I+vC2sdoFXpxt9pWkhTzE1KMIysaUXEF4+xfvhIQOqs4lP8v0mLlo8wq82rw8f1zdFFqIUSdctV7oE4K3SQQKWSt17poSDQF+MacVbQ5RymBdE1ThyHRdNVfmbulm62BSCMF4AMvHdeKcQxgdcj6O4BKsbvDGyIFfV3xXEgx6CZikM5WoTTXzJjhJJp9OY9S3u1TcsAubS8QgVo22xygGik4Y/STyz4gSLunsFFIgJrca/W1zP1m3zx1O0OuU0N8CuUTUgB3Ce1fcXQ1jTS9f1P0pqQ8HDfy9Zal882VbW5r0aXMg+zvnhhLmUuwuyGmRvfTX34eqALp+k9qcAScsam/0j3fciw9BRoW7SZSZ4LN6df5LTH84r1cuUeWGg2XwzwKZnCWXc2aeom8RjKyAb9TUfc8Ez+EamEtbs048H7IXWgFJcyORyLXCbD0kJK5wB6FI9Z203ED/mPmYyojQrgn6kRyqo4VwstAso70rJ14aBeURpWA+xXk5qvNAIST1ZeYPC6jr2RdtXpvg5jKLAnKs5t+LkQ3OaUgcITSKrQh714AiSGhHfqpMbeXQoURFxQItwODgoZsUdwpqHq6Z3aPMeE5DnA3s3n4HaGq4f8zoRAjevtGIwzjzFUOAr6f6+UCKFV2445N+6QTZCtn0/sLJOQwpgrSV5Xm6yUEyE/sAfHX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4241.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(346002)(366004)(39850400004)(4326008)(38100700002)(316002)(36756003)(5660300002)(8936002)(186003)(86362001)(16526019)(8676002)(7416002)(38350700002)(16576012)(30864003)(2616005)(54906003)(52116002)(956004)(66946007)(66556008)(83380400001)(6486002)(478600001)(66476007)(6916009)(31696002)(966005)(31686004)(26005)(6706004)(6666004)(2906002)(53546011)(99710200001)(78286007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UmZ5Y2EvZjAyN1JyTUNHZHovZGx4WHFNcnRFbkpvV01kSVA0cFcxbHlxNzVQ?=
 =?utf-8?B?YmFqbzVTM0w5SGluWU1PUDRNeHkvUlpkUGhsRlFyLytZMlBhbkMwK0E1ZlI4?=
 =?utf-8?B?WnBIczhJTE5Lc01OcVp6eTRiam8yMlFWT3RXSmsvTmJCd3lEbzFYaGErMUVr?=
 =?utf-8?B?ZTBZYTlXVmRiTE1OcTJwQm95Q3BDN3NRNE1UUElheTZlVU43OTRCN2YyN1p0?=
 =?utf-8?B?ZjRiM1VMVFJCRE1ueFFJMkZWUnFYM3FPamdCZStYcFhHOEN3UmFpdXlhQktT?=
 =?utf-8?B?NkNXUFQ0c0ttNDBxQytTcXI2ajRYNnpTa3g1cEVPUXUyV3BkOUpJSnB4M1ly?=
 =?utf-8?B?NU9iWHF3bmFzeURuejVxK1hWd2NjdVZvcjI2eHNleThSWG5lRTB4MThvVzIv?=
 =?utf-8?B?bmdaNGlCTjR5ditNTTZQaUxzYXhoWjM0SnAzd2V1cFppL1BlKy9RYVJDMmgy?=
 =?utf-8?B?TXJhZUxjK2NoUm82MlNKK0xEc0ZrMEIwTkhnWFRwQVNlajdYY09vMFlJN1NS?=
 =?utf-8?B?cTBJSFE0YldyRUJvQUlkVEJqS0xST2NRcWtkd00xOGJlTVloYVpQaFY1U3JR?=
 =?utf-8?B?SEtMQ1VuR1pJVXEyNW9nVVduZXVUMXVaT0tZL2RRMGVoeU9GQlN1bnJ0dUIy?=
 =?utf-8?B?bThGTkMwaUU4UE5TcllZZXZ4dWpvbjgwQkpWeHk3dU1ZOFZKOVRIMG1EOVVz?=
 =?utf-8?B?dW9YMkdadmU2S3l1dWpaZ0lOYUdkTk5xaDBiTGlJUjM0K3VseVRRaDNMa2VK?=
 =?utf-8?B?L3hJclVJUXpaQk1jdVh3NlpVdW4yb2srU05rbWw2THNiZmtVaTZzUngyUHpa?=
 =?utf-8?B?OFJZR0tqYzFHcXV2dnRkSk95ZS9WOWMwcEV1NFlVN25JdVNEQnpjeW14Z0Y2?=
 =?utf-8?B?U3RIZHJLZHNhOFVhcGZJUlp4dldNelVjVi85cU1veTNhRDcvTTlleWVPSTRV?=
 =?utf-8?B?c2hnQUkwNU0yUUFEcVhSRks0WVZUWEN5LzJkY1grWUJxMEs5OUp1OXQvRHpC?=
 =?utf-8?B?OE00cmdHSHlRZmJUNzZKMDh6WDNXblVzb1M5dUh2N1A0US9CbldWS0puRWJj?=
 =?utf-8?B?VDFBSHFJb1VubjFwZFN2ejV0YjRPV1hxNWNOSGU1a0kyVTVadmIrZkFmbWdy?=
 =?utf-8?B?ZjZnRE5BOHVwV0pNV1VQSk5rc3V0RjBqOHFQZzVrVkpCdFJrdVovejdXa0p6?=
 =?utf-8?B?bUg3b3BuM3RmSVp5Rzg5TUV0M29sZFZyVytnV2NEcXpCRDFYQ21oeWNLQ01j?=
 =?utf-8?B?cUZsQ1lhbzdUUEhoUG9GL2k0bnNoVXJUaTNLa05mMmpJUk4yV0N3Q3lqaE82?=
 =?utf-8?B?UERmaEpONmRZUWJ2dC9UWGt6SHNjclVRVk9MaXQ0b1JBcVMyL05FR2U5aHhp?=
 =?utf-8?B?VXRjMnRrQXYrdW95NzVLbU1nckdUbFZWSjg3TVEwQlRMYmNaMzBuSFArcy84?=
 =?utf-8?B?UkVKNGRzdE0rVWorRGlkdmpqaitsVkNaYUVjODhMS1J1d0kyejV6NkVvMmRZ?=
 =?utf-8?B?ZTBTMEVZcFNqc0FZc3RYMlRHb3E5ZG9jSTlmdGlOdkdPZDlVV0VvQTl1ME1j?=
 =?utf-8?B?dUk4YythMC8vQ2RiUlEyREV1Tm5vUUJzcXBMdUFEZnRBZTdHd1p3RXZXMkxy?=
 =?utf-8?B?dmdOalk2clJUTVVxdi9JS3BhaXBQcm5EbEQyaU1ycHVpWjFScVZ4OTV4Ujdu?=
 =?utf-8?B?RzZnc0pwdk1XOVQxbVZteGRRVExjazFQM29LR1Q3R0FvRUVyUEtkcHhUV1hD?=
 =?utf-8?Q?2PoC+ONkipeMNC6OUmrCvMTYFEmZbUPYTdCgoXU?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fb515d8-9237-4e47-cc7c-08d91f2548d3
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4241.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 02:32:05.3612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5X9q7wwddJgX3FEF/OhzeR60Q+rxSr7QhKfdVHIGZsv7rn8GKI5MWwG9jYZ+X7a5cA6/pXBG0I4iMTm0j3Z0zQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3765
X-Proofpoint-GUID: pfREbx1OUbmcGfzk3ntCOyvpGOUTCucn
X-Proofpoint-ORIG-GUID: pfREbx1OUbmcGfzk3ntCOyvpGOUTCucn
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-25_02:2021-05-24,2021-05-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 phishscore=0 spamscore=0 mlxscore=0 suspectscore=0 clxscore=1011
 bulkscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2105250016
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/25/21 6:46 AM, Paul E. McKenney wrote:
> [Please note: This e-mail is from an EXTERNAL e-mail address]
> 
> On Sun, May 23, 2021 at 09:13:50PM -0700, Paul E. McKenney wrote:
>> On Sun, May 23, 2021 at 08:51:56AM +0200, Dmitry Vyukov wrote:
>>> On Fri, May 21, 2021 at 7:29 PM syzbot
>>> <syzbot+7b2b13f4943374609532@syzkaller.appspotmail.com> wrote:
>>>>
>>>> Hello,
>>>>
>>>> syzbot found the following issue on:
>>>>
>>>> HEAD commit:    f18ba26d libbpf: Add selftests for TC-BPF management API
>>>> git tree:       bpf-next
>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=17f50d1ed00000
>>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=8ff54addde0afb5d
>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=7b2b13f4943374609532
>>>>
>>>> Unfortunately, I don't have any reproducer for this issue yet.
>>>>
>>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>>> Reported-by: syzbot+7b2b13f4943374609532@syzkaller.appspotmail.com
>>>
>>> This looks rcu-related. +rcu mailing list
>>
>> I think I see a possible cause for this, and will say more after some
>> testing and after becoming more awake Monday morning, Pacific time.
> 
> No joy.  From what I can see, within RCU Tasks Trace, the calls to
> get_task_struct() are properly protected (either by RCU or by an earlier
> get_task_struct()), and the calls to put_task_struct() are balanced by
> those to get_task_struct().
> 
> I could of course have missed something, but at this point I am suspecting
> an unbalanced put_task_struct() has been added elsewhere.
> 
> As always, extra eyes on this code would be a good thing.
> 
> If it were reproducible, I would of course suggest bisection.  :-/
> 
>                                                          Thanx, Paul
> 
Hi Paul,

Could it be?

        CPU1                                        CPU2
trc_add_holdout(t, bhp)
//t->usage==2
                                       release_task
                                         put_task_struct_rcu_user
                                           delayed_put_task_struct
                                             ......
                                             put_task_struct(t)
                                             //t->usage==1 

check_all_holdout_tasks_trace
   ->trc_wait_for_one_reader
     ->trc_del_holdout
       ->put_task_struct(t)
       //t->usage==0 and task_struct freed
   READ_ONCE(t->trc_reader_checked)
   //ops， t had been freed.

So, after excuting trc_wait_for_one_reader（）, task might had been 
removed from holdout list and the corresponding task_struct was freed.
And we shouldn't do READ_ONCE(t->trc_reader_checked).

I investigate the trc_wait_for_one_reader（） and found before we excute 
trc_del_holdout, there is always set t->trc_reader_checked=true. How 
about we just set the checked flag and unified excute trc_del_holdout()
in check_all_holdout_tasks_trace with checking the flag?


Thanks,
Yanfei




>>>> ==================================================================
>>>> BUG: KASAN: use-after-free in check_all_holdout_tasks_trace+0x302/0x420 kernel/rcu/tasks.h:1084
>>>> Read of size 1 at addr ffff88802767a05c by task rcu_tasks_trace/12
>>>>
>>>> CPU: 0 PID: 12 Comm: rcu_tasks_trace Not tainted 5.12.0-syzkaller #0
>>>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>>>> Call Trace:
>>>>   __dump_stack lib/dump_stack.c:79 [inline]
>>>>   dump_stack+0x141/0x1d7 lib/dump_stack.c:120
>>>>   print_address_description.constprop.0.cold+0x5b/0x2f8 mm/kasan/report.c:233
>>>>   __kasan_report mm/kasan/report.c:419 [inline]
>>>>   kasan_report.cold+0x7c/0xd8 mm/kasan/report.c:436
>>>>   check_all_holdout_tasks_trace+0x302/0x420 kernel/rcu/tasks.h:1084
>>>>   rcu_tasks_wait_gp+0x594/0xa60 kernel/rcu/tasks.h:358
>>>>   rcu_tasks_kthread+0x31c/0x6a0 kernel/rcu/tasks.h:224
>>>>   kthread+0x3b1/0x4a0 kernel/kthread.c:313
>>>>   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
>>>>
>>>> Allocated by task 8477:
>>>>   kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
>>>>   kasan_set_track mm/kasan/common.c:46 [inline]
>>>>   set_alloc_info mm/kasan/common.c:428 [inline]
>>>>   __kasan_slab_alloc+0x84/0xa0 mm/kasan/common.c:461
>>>>   kasan_slab_alloc include/linux/kasan.h:236 [inline]
>>>>   slab_post_alloc_hook mm/slab.h:524 [inline]
>>>>   slab_alloc_node mm/slub.c:2912 [inline]
>>>>   kmem_cache_alloc_node+0x269/0x3e0 mm/slub.c:2948
>>>>   alloc_task_struct_node kernel/fork.c:171 [inline]
>>>>   dup_task_struct kernel/fork.c:865 [inline]
>>>>   copy_process+0x5c8/0x7120 kernel/fork.c:1947
>>>>   kernel_clone+0xe7/0xab0 kernel/fork.c:2503
>>>>   __do_sys_clone+0xc8/0x110 kernel/fork.c:2620
>>>>   do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
>>>>   entry_SYSCALL_64_after_hwframe+0x44/0xae
>>>>
>>>> Freed by task 12:
>>>>   kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
>>>>   kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
>>>>   kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:357
>>>>   ____kasan_slab_free mm/kasan/common.c:360 [inline]
>>>>   ____kasan_slab_free mm/kasan/common.c:325 [inline]
>>>>   __kasan_slab_free+0xfb/0x130 mm/kasan/common.c:368
>>>>   kasan_slab_free include/linux/kasan.h:212 [inline]
>>>>   slab_free_hook mm/slub.c:1581 [inline]
>>>>   slab_free_freelist_hook+0xdf/0x240 mm/slub.c:1606
>>>>   slab_free mm/slub.c:3166 [inline]
>>>>   kmem_cache_free+0x8a/0x740 mm/slub.c:3182
>>>>   __put_task_struct+0x26f/0x400 kernel/fork.c:747
>>>>   trc_wait_for_one_reader kernel/rcu/tasks.h:935 [inline]
>>>>   check_all_holdout_tasks_trace+0x179/0x420 kernel/rcu/tasks.h:1081
>>>>   rcu_tasks_wait_gp+0x594/0xa60 kernel/rcu/tasks.h:358
>>>>   rcu_tasks_kthread+0x31c/0x6a0 kernel/rcu/tasks.h:224
>>>>   kthread+0x3b1/0x4a0 kernel/kthread.c:313
>>>>   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
>>>>
>>>> Last potentially related work creation:
>>>>   kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
>>>>   kasan_record_aux_stack+0xe5/0x110 mm/kasan/generic.c:345
>>>>   __call_rcu kernel/rcu/tree.c:3038 [inline]
>>>>   call_rcu+0xb1/0x750 kernel/rcu/tree.c:3113
>>>>   put_task_struct_rcu_user+0x7f/0xb0 kernel/exit.c:180
>>>>   release_task+0xca1/0x1690 kernel/exit.c:226
>>>>   wait_task_zombie kernel/exit.c:1108 [inline]
>>>>   wait_consider_task+0x2fb5/0x3b40 kernel/exit.c:1335
>>>>   do_wait_thread kernel/exit.c:1398 [inline]
>>>>   do_wait+0x724/0xd40 kernel/exit.c:1515
>>>>   kernel_wait4+0x14c/0x260 kernel/exit.c:1678
>>>>   __do_sys_wait4+0x13f/0x150 kernel/exit.c:1706
>>>>   do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
>>>>   entry_SYSCALL_64_after_hwframe+0x44/0xae
>>>>
>>>> Second to last potentially related work creation:
>>>>   kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
>>>>   kasan_record_aux_stack+0xe5/0x110 mm/kasan/generic.c:345
>>>>   __call_rcu kernel/rcu/tree.c:3038 [inline]
>>>>   call_rcu+0xb1/0x750 kernel/rcu/tree.c:3113
>>>>   put_task_struct_rcu_user+0x7f/0xb0 kernel/exit.c:180
>>>>   context_switch kernel/sched/core.c:4342 [inline]
>>>>   __schedule+0x91e/0x23e0 kernel/sched/core.c:5147
>>>>   preempt_schedule_common+0x45/0xc0 kernel/sched/core.c:5307
>>>>   preempt_schedule_thunk+0x16/0x18 arch/x86/entry/thunk_64.S:35
>>>>   try_to_wake_up+0xa12/0x14b0 kernel/sched/core.c:3489
>>>>   wake_up_process kernel/sched/core.c:3552 [inline]
>>>>   wake_up_q+0x96/0x100 kernel/sched/core.c:597
>>>>   futex_wake+0x3e9/0x490 kernel/futex.c:1634
>>>>   do_futex+0x326/0x1780 kernel/futex.c:3738
>>>>   __do_sys_futex+0x2a2/0x470 kernel/futex.c:3796
>>>>   do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
>>>>   entry_SYSCALL_64_after_hwframe+0x44/0xae
>>>>
>>>> The buggy address belongs to the object at ffff888027679c40
>>>>   which belongs to the cache task_struct of size 6976
>>>> The buggy address is located 1052 bytes inside of
>>>>   6976-byte region [ffff888027679c40, ffff88802767b780)
>>>> The buggy address belongs to the page:
>>>> page:ffffea00009d9e00 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff88802767b880 pfn:0x27678
>>>> head:ffffea00009d9e00 order:3 compound_mapcount:0 compound_pincount:0
>>>> flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
>>>> raw: 00fff00000010200 ffffea000071e208 ffffea0000950808 ffff888140005140
>>>> raw: ffff88802767b880 0000000000040003 00000001ffffffff 0000000000000000
>>>> page dumped because: kasan: bad access detected
>>>> page_owner tracks the page as allocated
>>>> page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 243, ts 14372676818, free_ts 0
>>>>   prep_new_page mm/page_alloc.c:2358 [inline]
>>>>   get_page_from_freelist+0x1033/0x2b60 mm/page_alloc.c:3994
>>>>   __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5200
>>>>   alloc_pages+0x18c/0x2a0 mm/mempolicy.c:2272
>>>>   alloc_slab_page mm/slub.c:1644 [inline]
>>>>   allocate_slab+0x2c5/0x4c0 mm/slub.c:1784
>>>>   new_slab mm/slub.c:1847 [inline]
>>>>   new_slab_objects mm/slub.c:2593 [inline]
>>>>   ___slab_alloc+0x44c/0x7a0 mm/slub.c:2756
>>>>   __slab_alloc.constprop.0+0xa7/0xf0 mm/slub.c:2796
>>>>   slab_alloc_node mm/slub.c:2878 [inline]
>>>>   kmem_cache_alloc_node+0x12f/0x3e0 mm/slub.c:2948
>>>>   alloc_task_struct_node kernel/fork.c:171 [inline]
>>>>   dup_task_struct kernel/fork.c:865 [inline]
>>>>   copy_process+0x5c8/0x7120 kernel/fork.c:1947
>>>>   kernel_clone+0xe7/0xab0 kernel/fork.c:2503
>>>>   kernel_thread+0xb5/0xf0 kernel/fork.c:2555
>>>>   call_usermodehelper_exec_work kernel/umh.c:174 [inline]
>>>>   call_usermodehelper_exec_work+0xcc/0x180 kernel/umh.c:160
>>>>   process_one_work+0x98d/0x1600 kernel/workqueue.c:2275
>>>>   worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
>>>>   kthread+0x3b1/0x4a0 kernel/kthread.c:313
>>>>   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
>>>> page_owner free stack trace missing
>>>>
>>>> Memory state around the buggy address:
>>>>   ffff888027679f00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>>>>   ffff888027679f80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>>>>> ffff88802767a000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>>>>                                                      ^
>>>>   ffff88802767a080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>>>>   ffff88802767a100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>>>> ==================================================================
>>>>
>>>>
>>>> ---
>>>> This report is generated by a bot. It may contain errors.
>>>> See https://goo.gl/tpsmEJ for more information about syzbot.
>>>> syzbot engineers can be reached at syzkaller@googlegroups.com.
>>>>
>>>> syzbot will keep track of this issue. See:
>>>> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>>>>
>>>> --
>>>> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
>>>> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
>>>> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/000000000000f034fc05c2da6617%40google.com.
