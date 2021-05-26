Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0BA6391049
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 08:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232127AbhEZGFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 02:05:51 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:37668 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231532AbhEZGFu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 02:05:50 -0400
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14Q62xqx018973;
        Tue, 25 May 2021 23:03:54 -0700
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2044.outbound.protection.outlook.com [104.47.56.44])
        by mx0a-0064b401.pphosted.com with ESMTP id 38rr6yry1t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 May 2021 23:03:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N3p+D0lXVbBvXXuC3BJuC1r0SguvXqGnuK0N5VPRSrknQDlvNGVl2gOE1nea6cqoHKgpmjxd2/3pe9FVQLwyRb+iUM6dfxw2FK6XzjzjebDeQovY+Zb5G+0xPyq+1sRXJTBCBD4aJUQdM6fRiFLVXuqHJnpYxZX53yOyV9OudjRnEyq8EaK4uDwXnc7GMbAmJ68KLS8d84qVS7iAklxg75ZBWymRlhnxyMbJPk/7j1VPvA6Kof122cKEiVB4Yo5CCv/tB0v8mdwdgvBHTJom9DnS9d7EGOhcEi9GVyaopVSxQXa7GNE1TovbemDZNRDZTfAWB3LWKe4TY+LaNONekQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qv3Xpp98PiYInmF0yf6pB3zIOPCIltpcP8VOMV68ku4=;
 b=UnmUPCpjO0pVIO05CPEsyInwlhcYFfSf/RiQ0KkNqh3djDhVNhkiyZLM0zrB2cEVsoTmoZ052V4vHB1GnpTAMAOgH+lpu7mYVzSZ3YMhSNM8tUT/TXPu2d9IJw45jJQ/FPFFyCL6YIjuCEtMs9NrND9My4Yy7cjy9vaFdgMmdjg5UylR0BNQbFv/Sn2K7zmkhFF8Z6Nubph26CZ/A7Cyu3f9XjRL8QA7s10dCrwlvmFEmS/XA0G01bONFJiDI1oo0kl/8Yz1p9KW+ZZVsjzFKZkZrj+W6Sn1n2FAIn3hU14UjEWosDeu1glEhbF0qYCV5OwsPFp+ntBhRwFiHpqeWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qv3Xpp98PiYInmF0yf6pB3zIOPCIltpcP8VOMV68ku4=;
 b=ZRQtj+aRVq64uDYbqqynhPWX0sLKotupkdA9UNhU03YqhL+GP7INNxZR85gb5Tr9zptZxs6b0qF4RHMvSzBwB9E6xyKu+0kzg7So3s989lpf83bOvTWauLhS7OuI/jgGia381Js+BoTtgHOSHdLM+mMcadMrQAyHB1a1Ool4K9A=
Authentication-Results: fb.com; dkim=none (message not signed)
 header.d=none;fb.com; dmarc=none action=none header.from=windriver.com;
Received: from BY5PR11MB4241.namprd11.prod.outlook.com (2603:10b6:a03:1ca::13)
 by BYAPR11MB3255.namprd11.prod.outlook.com (2603:10b6:a03:1d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Wed, 26 May
 2021 06:03:51 +0000
Received: from BY5PR11MB4241.namprd11.prod.outlook.com
 ([fe80::34b3:17c2:b1ad:286c]) by BY5PR11MB4241.namprd11.prod.outlook.com
 ([fe80::34b3:17c2:b1ad:286c%5]) with mapi id 15.20.4150.027; Wed, 26 May 2021
 06:03:50 +0000
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
 <62d52830-e422-d08d-fbb8-9e0984672ffe@windriver.com>
 <20210526042104.GZ4441@paulmck-ThinkPad-P17-Gen-1>
From:   "Xu, Yanfei" <yanfei.xu@windriver.com>
Message-ID: <fb2ee999-1796-29af-c0ef-60923dc82e12@windriver.com>
Date:   Wed, 26 May 2021 14:03:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210526042104.GZ4441@paulmck-ThinkPad-P17-Gen-1>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [60.247.85.82]
X-ClientProxiedBy: HK2PR04CA0073.apcprd04.prod.outlook.com
 (2603:1096:202:15::17) To BY5PR11MB4241.namprd11.prod.outlook.com
 (2603:10b6:a03:1ca::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [128.224.162.160] (60.247.85.82) by HK2PR04CA0073.apcprd04.prod.outlook.com (2603:1096:202:15::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Wed, 26 May 2021 06:03:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7f606891-0447-4131-c64e-08d9200c085f
X-MS-TrafficTypeDiagnostic: BYAPR11MB3255:
X-Microsoft-Antispam-PRVS: <BYAPR11MB3255B2F4584F17D74942E2D3E4249@BYAPR11MB3255.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LyOPzMMWstKeHhRjYnU8AZUtzzerqsC9e17nGDbIohSsUuS5ELE8bCuNh4N8oZS//hmtPhcCOKk16e+9CaY5pfDjkEQyBjGxUExxi1V1+Bqjg1Kx8z7boh2WqpTjTp92Y5mmRvzEHgDvbRcGQ0zmn/drtdS4lEKIV42dnz9nuTEBoM9FNUYyXsJJXdC77dIyPfTVQQRLXELqkhiYktSqLJamFZkKzODECg8r4p8RardrnadgFr/zcymeHN+CvcDPkrsok2OTJCsFTx+6sadHXUzRcoLXnskmYOktXBDSZdy/Js4ZpcWlNkxE4dpPPZkaidUixQ2+m1MBZajjT1D9+Kz2Mo8EXI5hhvtPlzZeYpbJuhPPuNlXbiPp4pCyIn4k8fa3Jr96KY4jCahLhzO9orfGySy9khNKJpRfu5G5jXdxYwOtGRyz/sZIrFqO1v8p5HRenemr7R6QMLUUo8mTCV9v2Cnj7oyXvoadUhuJ7yWl8mEszNAglWU3x5FZkMVaaqysPB+CqMYIfWL7laqsmHfpOW9qkNxn5jFSg4KUFZhvhLQ13nuGk05rrXXd1mw9coz9Ar6tHew35fzIzE7/a+TflvtYhLLO/z7mHKzDCrSotEfVwsUCkdVMUpQZK8LPHxzxHm9SNrA/Lurk04EAy4e1hqphAKgAqTAK/ZL3ZMaHBb2bhyMTBJKW2fajhaankKrIvsvH93sNI/4FWYW/iCXeoUpAHZvhJZPby/Q16Dg67fitH8TyA1LoUP8bZt/rt/fbDw73a9ddVsAQEjDlJjItuWseP/mcUro7+EtyTiKpEELQUpPLrduGSncbXzShLUKIHx9SoL78AK6Q/djZYQM2jKOiWUyW29XZLXYmjDj4xJGeVcyhgdpyBWAQ3H0A
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4241.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(366004)(136003)(39850400004)(396003)(83380400001)(54906003)(7416002)(2906002)(2616005)(6666004)(86362001)(956004)(52116002)(8936002)(16576012)(66556008)(26005)(478600001)(316002)(53546011)(8676002)(4326008)(16526019)(66946007)(186003)(6706004)(31696002)(5660300002)(36756003)(38350700002)(6486002)(31686004)(966005)(38100700002)(66476007)(6916009)(99710200001)(78286007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?amRaRTNtWk5ETHlZSmR5NlVDc1dneFlyeUloNXdaellNb0I3ck4xamxUWmpm?=
 =?utf-8?B?eEZkWVB5K0hhU2dwcEpEWnJPYkQ4Q0pJY2lmK1JhakNGQUVkbzFPMm1pTG5Q?=
 =?utf-8?B?MnZMcmJ0YUhSN21xdmtpNStHem1laHIrejYrc0E0OExWVmgvbWV4MWVUNDBq?=
 =?utf-8?B?MERGWW9lRmZFTEtpRGQ1YTZ5U0ZDdU9PbmhRbStXZnMwMVRHK01HTElLK0t3?=
 =?utf-8?B?ZlF1dmpUUU5SdDE4Z3BvQmd2VytzUVR3L0dDdFRVbWd0TUVTeFoveWE2VlVm?=
 =?utf-8?B?bittTmFiV3lrMXRPalEyUWJlSnlxc052d01VdUZpQ24rT3ZCQ3RSbnJlR2Vj?=
 =?utf-8?B?QllBcWxEV0VoNTVqRUlTRHFTWDZOZWpKVis3UVZ4eFF2T2FDTUU5U3JQbEkr?=
 =?utf-8?B?a255WHFuYW9SUk1vZE90ZVVoRHVDM3V4TXVrWmExMEVUNVV1SUIyME1icEl1?=
 =?utf-8?B?NnFQeWcrVXBWNEttZWxGc2l0NmV4WFRQa0grT3ZOdlE5U1NhQ0o1MmJRaFNS?=
 =?utf-8?B?d1NkV21hcUNnYmo0cDNMWCsyRUVDdUhzekdhdTVqRlZIZ3BGM3RxUW81ZUhm?=
 =?utf-8?B?d2FkV2tLRW5JOFNDUFRmUFcrQUZmYVJSb1RSditETDVyWWoxNGFsb2pJeFhJ?=
 =?utf-8?B?TFhLNVY3M092bUhiRE9XVitLWk9VSUVROW1VNm5Oczl6ZTFsbHdMR1NqVTVW?=
 =?utf-8?B?Z2Ixc3B4Lyt0d2t5M2VJOWtKZ09NSTVCKzRsQ25YTU5JeWdOSnBkbDlJdVVz?=
 =?utf-8?B?NlRxN01oTEUxQlBuTzdUUjhVUktvcVFCSHZwN1hHL2F4WXJlLzNXa0x5UDY4?=
 =?utf-8?B?N3RlakZtN0ZKMHJ0Q2NkOVNuaTUvK21OMSs3bkw4Q2Z1RGgzQXNTZGNNc250?=
 =?utf-8?B?d2U0dVYvWEtNL21FNk5nczJ1VXRGK3BoNXIxa0VNeFhTT2RZZUhQam9PUmkx?=
 =?utf-8?B?MlpQd3N1Wmg1Tm84bG4yVlB1dk1aZk5wTG5WYWFGVzNPU1Y2dVZXM3NTd1NK?=
 =?utf-8?B?RTBldFd1Y3Bvcjc0dW9SekloVnNSN2lnMDU1dnErSi80K1ZBSXhvVURGTFNr?=
 =?utf-8?B?b3RNQ09oLzBSMDZFQUU3T1A1QTFjeExrblY2TElKOE1JYm9pSTBiZVFSVnpx?=
 =?utf-8?B?eHI5djRlSGcwejZ4REJiL3pBaVhnclRmeEl6blNkd0VpQ0RZOEFlV2RFa1Bn?=
 =?utf-8?B?R1BlaXREUzBaOVdkS0c2OWlEWVpkZkxmcnlMb3hNTVo0STZaSHlrMSttZVQy?=
 =?utf-8?B?a2dLT3BEcHlUdjVoY3hrL2srWUZQMTFxai84c2pjZEh2eDRqTnBqREZ3anNt?=
 =?utf-8?B?QTRucW5FenNBbDRsZlQzZk8vQ0VJblhiRFhZOXNSY2VkRFBIK0lRay9NQStN?=
 =?utf-8?B?T1dEbUMrTngrQUI4b1hiVHpsS1hsVE9EZHVQckZpZElSYjRxbHRxQUk2ZndU?=
 =?utf-8?B?UGlVb1EvWWJTR3l6elZlQjRhZ3ZVWk1uWW9CVFhmRWVpOFRUOE1hSmpBcUlW?=
 =?utf-8?B?Wmdua3Q1RXFGTGllcmtYcVNZWUFrSUVzK0RHc0s0c3BpRGlrTCtkNDMyRFI0?=
 =?utf-8?B?VTliNkcxUWZQdzRyTFoyQmg4MGJzNWJiR21uZFRDN2NPL3k0RzZBSGRkQ0cz?=
 =?utf-8?B?RmJWK1dWOGVDdlF2cldtZllFMjRlL0ROS3lWT1RHK1NIMXdoZlF1TTViZXJj?=
 =?utf-8?B?SVVNeVVyMGpYVG1XazIvTEZVbHVWSWJ2T3hJU2Z6OE5XU2R4Y2l4M0RlK2p1?=
 =?utf-8?Q?rRE5dLhWN+vStmwnA3igN+UCc4/FPhqwbXQQnPC?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f606891-0447-4131-c64e-08d9200c085f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4241.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 06:03:50.6543
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RmHlOXMi7zVAcwluPgSB8xUvn+kuApjC4nqy7Y6bsBNZ5Cq4CHyffB6jdXKppAWvED7REDfewPjkdc0N/W1ELA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3255
X-Proofpoint-ORIG-GUID: f-4np1Tsrv3qx8w5k8zc7GbWNvo2fnHx
X-Proofpoint-GUID: f-4np1Tsrv3qx8w5k8zc7GbWNvo2fnHx
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-26_04:2021-05-25,2021-05-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 phishscore=0 lowpriorityscore=0 adultscore=0
 impostorscore=0 clxscore=1015 malwarescore=0 priorityscore=1501
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105260040
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/26/21 12:21 PM, Paul E. McKenney wrote:
> [Please note: This e-mail is from an EXTERNAL e-mail address]
> 
> On Wed, May 26, 2021 at 10:22:59AM +0800, Xu, Yanfei wrote:
>> On 5/25/21 10:28 PM, Paul E. McKenney wrote:
>>> [Please note: This e-mail is from an EXTERNAL e-mail address]
>>>
>>> On Tue, May 25, 2021 at 06:24:10PM +0800, Xu, Yanfei wrote:
>>>>
>>>>
>>>> On 5/25/21 11:33 AM, Paul E. McKenney wrote:
>>>>> [Please note: This e-mail is from an EXTERNAL e-mail address]
>>>>>
>>>>> On Tue, May 25, 2021 at 10:31:55AM +0800, Xu, Yanfei wrote:
>>>>>>
>>>>>>
>>>>>> On 5/25/21 6:46 AM, Paul E. McKenney wrote:
>>>>>>> [Please note: This e-mail is from an EXTERNAL e-mail address]
>>>>>>>
>>>>>>> On Sun, May 23, 2021 at 09:13:50PM -0700, Paul E. McKenney wrote:
>>>>>>>> On Sun, May 23, 2021 at 08:51:56AM +0200, Dmitry Vyukov wrote:
>>>>>>>>> On Fri, May 21, 2021 at 7:29 PM syzbot
>>>>>>>>> <syzbot+7b2b13f4943374609532@syzkaller.appspotmail.com> wrote:
>>>>>>>>>>
>>>>>>>>>> Hello,
>>>>>>>>>>
>>>>>>>>>> syzbot found the following issue on:
>>>>>>>>>>
>>>>>>>>>> HEAD commit:    f18ba26d libbpf: Add selftests for TC-BPF management API
>>>>>>>>>> git tree:       bpf-next
>>>>>>>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=17f50d1ed00000
>>>>>>>>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=8ff54addde0afb5d
>>>>>>>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=7b2b13f4943374609532
>>>>>>>>>>
>>>>>>>>>> Unfortunately, I don't have any reproducer for this issue yet.
>>>>>>>>>>
>>>>>>>>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>>>>>>>>> Reported-by: syzbot+7b2b13f4943374609532@syzkaller.appspotmail.com
>>>>>>>>>
>>>>>>>>> This looks rcu-related. +rcu mailing list
>>>>>>>>
>>>>>>>> I think I see a possible cause for this, and will say more after some
>>>>>>>> testing and after becoming more awake Monday morning, Pacific time.
>>>>>>>
>>>>>>> No joy.  From what I can see, within RCU Tasks Trace, the calls to
>>>>>>> get_task_struct() are properly protected (either by RCU or by an earlier
>>>>>>> get_task_struct()), and the calls to put_task_struct() are balanced by
>>>>>>> those to get_task_struct().
>>>>>>>
>>>>>>> I could of course have missed something, but at this point I am suspecting
>>>>>>> an unbalanced put_task_struct() has been added elsewhere.
>>>>>>>
>>>>>>> As always, extra eyes on this code would be a good thing.
>>>>>>>
>>>>>>> If it were reproducible, I would of course suggest bisection.  :-/
>>>>>>>
>>>>>>>                                                             Thanx, Paul
>>>>>>>
>>>>>> Hi Paul,
>>>>>>
>>>>>> Could it be?
>>>>>>
>>>>>>           CPU1                                        CPU2
>>>>>> trc_add_holdout(t, bhp)
>>>>>> //t->usage==2
>>>>>>                                          release_task
>>>>>>                                            put_task_struct_rcu_user
>>>>>>                                              delayed_put_task_struct
>>>>>>                                                ......
>>>>>>                                                put_task_struct(t)
>>>>>>                                                //t->usage==1
>>>>>>
>>>>>> check_all_holdout_tasks_trace
>>>>>>      ->trc_wait_for_one_reader
>>>>>>        ->trc_del_holdout
>>>>>>          ->put_task_struct(t)
>>>>>>          //t->usage==0 and task_struct freed
>>>>>>      READ_ONCE(t->trc_reader_checked)
>>>>>>      //ops， t had been freed.
>>>>>>
>>>>>> So, after excuting trc_wait_for_one_reader（）, task might had been removed
>>>>>> from holdout list and the corresponding task_struct was freed.
>>>>>> And we shouldn't do READ_ONCE(t->trc_reader_checked).
>>>>>
>>>>> I was suspicious of that call to trc_del_holdout() from within
>>>>> trc_wait_for_one_reader(), but the only time it executes is in the
>>>>> context of the current running task, which means that CPU 2 had better
>>>>> not be invoking release_task() on it just yet.
>>>>>
>>>>> Or am I missing your point?
>>>>
>>>> Two times.
>>>> 1. the task is current.
>>>>
>>>>                  trc_wait_for_one_reader
>>>>                    ->trc_del_holdout
>>>
>>> This one should be fine because the task cannot be freed until it
>>> actually exits, and the grace-period kthread never exits.  But it
>>> could also be removed without any problem that I see. >
>>
>> Agree, current task's task_struct should be high probably safe.  If you
>> think it is safe to remove, I prefer to remove it. Because it can make
>> trc_wait_for_one_reader's behavior about deleting task from holdout more
>> unified. And there should be a very small racy that the task is checked as a
>> current and then turn into a exiting task before its task_struct is accessed
>> in trc_wait_for_one_reader or check_all_holdout_tasks_trace.（or I
>> misunderstand something about rcu tasks）
>>
>>>> 2. task isn't current.
>>>>
>>>>                  trc_wait_for_one_reader
>>>>                    ->get_task_struct
>>>>                    ->try_invoke_on_locked_down_task（trc_inspect_reader）
>>>>                      ->trc_del_holdout
>>>>                    ->put_task_struct
>>>
>>> Ah, this one is more interesting, thank you!
>>>
>>> Yes, it is safe from the list's viewpoint to do the removal in the
>>> trc_inspect_reader() callback, but you are right that the grace-period
>>> kthread may touch the task structure after return, and there might not
>>> be anything else holding that task structure in place.
>>>
>>>>> Of course, if you can reproduce it, the following patch might be
>>>>
>>>> Sorry...I can't reproduce it, just analyse syzbot's log. :(
>>>
>>> Well, if it could be reproduced, that would mean that it was too easy,
>>> wouldn't it?  ;-)
>>
>> Ha ;-)
> 
> But it should be possible to make this happen...  Is it possible to
> add lots of short-lived tasks to the test that failed?
> 

Agree.

>>> How about the (untested) patch below, just to make sure that we are
>>> talking about the same thing?  I have started testing, but then
>>> again, I have not yet been able to reproduce this, either.
>>>
>>>                                                           Thanx, Paul
>>
>> Yes! we are talking the same thing, Should I send a new patch?
> 
> Or look at these commits that I queued this past morning (Pacific Time)
> on the "dev" branch of the -rcu tree:
> 
> aac385ea2494 rcu-tasks: Don't delete holdouts within trc_inspect_reader()
> bf30dc63947c rcu-tasks: Don't delete holdouts within trc_wait_for_one_reader()

Got it, Thanks!

Regards,
Yanfei

> 
> They pass initial testing, but then again, such tests passed before
> these patches were queued.  :-/
> 
>                                                          Thanx, Paul
> 
