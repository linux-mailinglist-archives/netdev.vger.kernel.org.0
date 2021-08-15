Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8929F3ECA83
	for <lists+netdev@lfdr.de>; Sun, 15 Aug 2021 20:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbhHOSL6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Aug 2021 14:11:58 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:35540 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229502AbhHOSL5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Aug 2021 14:11:57 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17FI6ZYY028364;
        Sun, 15 Aug 2021 11:10:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=NzBRGqV6580wlcPFBQUVoAp0uFcgzoO/uFTFeR4M8fI=;
 b=lq9cmfu/jXujcbMTZnog3NfDjh9Rub3/xYDqf2iGalZWSdI4nTEF6Ir4SWLUXNULfqeD
 7i4pkJYWV5Qjs+v4VKyuP2NeS3MyvXsTvzTgRN0uDUCYDTXFSecJtWQ842AnkGPkt5Cb
 a3WEtwShVRZ310cGF1BR7lqEYXQJHOkKLHc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3aebhnne8g-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 15 Aug 2021 11:10:55 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sun, 15 Aug 2021 11:10:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q1PvUWEUFz/VoPCyorlLFNWNxmEbsHtu2zcH2L1JJDkEmKkmS2bOpl8fPRXIaQ9lWum9wkb+eVrwBIAp74U9gzxCZkbQ5KiabVR599wDd74pXaZeK9Zg7pV3N34smkF9GVi5X1XAcS2OLDLDtpNpJJrKQjt7HRSPchM/C63R8jfWJOxxKF3eEFkypDA/P6Bxx2Pjn0dpxjJ9O3h4vZ6pmNemfZN6L2Yx5TsRY30iECCrCYIx2xjyNvLP8HvkvkDXo4Ub0w5mo7EWNgxMjx89hWnStj7kn/IZvT9Q0LRs0qk2fnbL1U5b7Ah7AxYqOno6SrBbmDj8bOo6OH2w6Lzm+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1MAzMiAgp2tTVN8I/1tDHQhEStIlv/lRA8+iF2O6RAY=;
 b=ms3L0WNYXcjAWVMTGeISB9nU5+E6W+sZBNjQWuF8n1UKgqz23muCfZQfRE4SVqBaBxLnOvRnrUzv54yVa4kvje3cQOHe4pZzw5odJRM1Iw8grQGmushrJErfTeaCT/5hyVWsYMz0xUYPeJqRy/fGu77WwjqpaAbeNW3w+DoYjAqD6jGhd10sXbXJNjgtaQ1NwnlWnpY3iC53q73YZ/4FYmukSLqzO+/kR07HAkJNHPaXy8qeNiHA53jfTxBC5lIEGz08mu1AQvQEx2jA8pcF9VHLGBYx/bO4wnfe2uOR9w1OM2C7KvbNRz+g2oWrwnDQ2BmczrOPhuK/IGNT3G1YbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR15MB2415.namprd15.prod.outlook.com (2603:10b6:805:1c::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.13; Sun, 15 Aug
 2021 18:10:52 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb%7]) with mapi id 15.20.4415.022; Sun, 15 Aug 2021
 18:10:52 +0000
Subject: Re: [PATCH v5 bpf-next 3/4] selftest/bpf: Implement sample UNIX
 domain socket iterator program.
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        <andrii.nakryiko@gmail.com>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <benh@amazon.com>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <john.fastabend@gmail.com>, <kafai@fb.com>,
        <kpsingh@kernel.org>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <songliubraving@fb.com>
References: <CAEf4BzZ3sVx1m1mOCcPcuVPiY6cWEAO=6VGHDiXEs9ZVD-RoLg@mail.gmail.com>
 <20210814002101.33742-1-kuniyu@amazon.co.jp>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <c5b4e17b-97b3-061a-6956-6f21c5ad9581@fb.com>
Date:   Sun, 15 Aug 2021 11:10:49 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
In-Reply-To: <20210814002101.33742-1-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
X-ClientProxiedBy: BYAPR05CA0088.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::29) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::1013] (2620:10d:c090:400::5:12bf) by BYAPR05CA0088.namprd05.prod.outlook.com (2603:10b6:a03:e0::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.8 via Frontend Transport; Sun, 15 Aug 2021 18:10:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6342fd3a-2430-430a-67a6-08d96018045a
X-MS-TrafficTypeDiagnostic: SN6PR15MB2415:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR15MB24156E86CD33C61005A09860D3FC9@SN6PR15MB2415.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jE5plF4S+wH9ShNwnVm8LMs0NKPo7f1Qh1adI+qAL73su7BmvQzCChE9jHM+icnhQE5FdFEljs+Y+m2hOlwnwd8Bphl5Oyey6REESsmU1xLtbEl6wBmrdv8YgPDm2nRGyFUoYoY0pjCbBJG3gAzHAaAfccRdgwfewYSZo1eYoLzjw+pJ+V1CLq0GULwLNXPjZhEJDRETq+QFE8QIODwIFpCyjl7VOKhxUdLy2faLI15SOWr9oYfNCfKW8KpNbCYJ8OTh8lMUa2PHL2LiyrYBCFQvh1vjA7NFVfxqNUoMnda2az9+hVjWPtRP0J8D16AWtGIJ1hRHKgsU18y604NruNBJz9arRDXmEgxqz3c9UaOqae76y9Vn1BlT7DgQGBgzdUc92ykTQRmUGZE97Y3hj2A6Sj0qFn39JdAhe1kkecNUdt084BY9gE95xsmYpQ3m6bYPD+O62iwwtB/LKSEQ0NbtCKzuvcqmSpibBvNvFtBP0IFBg0oG6bqiXcxoB9Wh9zNHa5vgZZMwQU9FZJEHwR3avRtAF7zldlX+bR4KJ1WqvKE+ydVIPjvb396injG7vI6ySCk3INsSlkaOPUkQRb8x/S7blZ2p7Y0k9WvNRloDImYufmmyUWGfu++mXc7Sv2A1pVUypwBATHbSMuwDVwS/1DJU78xc62qHrJBNvYsqZqgWoQ6VjD0DRBcfVq3i9BmHldgwN0/zQjWkGCzljXvfsE7GGSExAeR1iZxyGwtuFUZgNqWU3P4MKl1FxhOXLQ+IfcirTVt/LHLQF0ovKwkcutslLbLWwsbP3rw+zanmy/lhfEofT383h6QQdKYWJfVy6Lb8p3RHOyTHd/wutruTUWkQZgA/NCDtsoSlcPw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(396003)(39860400002)(136003)(346002)(66556008)(66476007)(66574015)(53546011)(52116002)(66946007)(36756003)(8676002)(31696002)(38100700002)(6486002)(478600001)(8936002)(86362001)(7416002)(186003)(31686004)(2616005)(2906002)(316002)(4326008)(966005)(5660300002)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VDFCNE54MitXUnJGSkJRZks1a0oxQ0RsMHFpd0p6d1BYRHpVZmltYllNVjZy?=
 =?utf-8?B?RGRteFNqUkpWR1Jyb0d0NkhVTUoxMnVVYVJwdi9BU2hHOWExSVRwTVA5aUlB?=
 =?utf-8?B?L3MyMUFYSmlrRzU1S2Nsb0ozZENtSWpIMlBjdGxpWTBLY1ZOVjlUbmp4N0Iz?=
 =?utf-8?B?M1ZFSWhhVy9vekpMU25ZUk91QTAxNkJWaFNZV294S1VqbW92bC80amQ2OEQ1?=
 =?utf-8?B?Q3FEZzNrNVluUEJJRFFhZW85U0NRNU1xcUZ0cTFaT1Nyb3krU2p1QkFhbWJL?=
 =?utf-8?B?RFBmSktndGowRVFyVzBjYUdETVJCVklEaGVMdFZrLzNXR2VZaHJzNWJjR2hU?=
 =?utf-8?B?eHA3UFNPUHYzd2FySlRuVVhvOEFJVllMRlUrYlFqOTVjNG1xMHZVem9SODkx?=
 =?utf-8?B?UDdCL2g5SUFXYlhlS3p2S2NZRUdrMHcrUDRXRDFnQTVrMjhWYWRUOW1vdnJo?=
 =?utf-8?B?ZGp3TjZHMlo1d3FXZWFwQitod2RuamJnVVluNnh6TTQ0YzFUcDB2TjhGTjJC?=
 =?utf-8?B?cThHY3R6NG1WNThxQXFRWFBVbFRhaHZTSmIranpEK2tySjlMZDBvZE1jS1N3?=
 =?utf-8?B?WCtqWXBqd3RFS2RxUUV0T1BiazBGZENwSHNlMVdiMFJERHdMalBuTnZJbG16?=
 =?utf-8?B?VkRRRHNobE5pcnQ4M3l3bkdSWWNVMDNCRTVBMmFoOUZ5dU9nemgzWEpXY2Vt?=
 =?utf-8?B?c1hHT2VPRCtBeWlhVURobkVwL3IzbktabERmYTJURWF4VWdkWDdQQkhnNU1G?=
 =?utf-8?B?eWVGakYxRVhVY2dDbXA4VjcxaTgzaWtDcXV6bzhTMWVyNHJrUmI4S3pRK3Zv?=
 =?utf-8?B?a1VUSU9YWTFERDM2aXRnbllaQ2tFNEczUGE5bjg1Y0J6eXVESUlJUG5UZE1O?=
 =?utf-8?B?R2NZTzUySVpGb1BkVmVaUVVsemNqK2k0TGJZTFloMW9rZFhvclFoaTNUVVFa?=
 =?utf-8?B?RHVGOVRlV0kvejJERDcxZUdYTXVFSGl2WGJaUGttbWR3R2JwamNrSkNWeHBS?=
 =?utf-8?B?OGd0bXR4TVlPanZjeWZ1R1U0K3VsOURici9jRUUwUzI1bVplN2VkTjJKcFd3?=
 =?utf-8?B?bHlkbVhaQllCVHhLcFpoYnZQdVhqZjhubEhNbW1UWk11MmpxU0VPall1cTll?=
 =?utf-8?B?L3pXWkZmM1RrcnFNWWNaWkV6a2ZFa3VTWmFXVkV6eTFlWjEvVVg5K1BPV3ZW?=
 =?utf-8?B?cEVRazZVeFl2dmhmSU9xaUJVYWhBSXU0ZkpJK1Q3bk82VGxDa0lqZGNtQXJh?=
 =?utf-8?B?R2JML0c4bGxYcmMrUWNzUWorMjIwc2EralJWbGZOKy9lSDNzQm5hK0hoaUpX?=
 =?utf-8?B?OE9YSGpXM1FmZUpVSitpK3FMQWV4anA1VmZaVWhlMW9rbW5LM25tS3JFOVox?=
 =?utf-8?B?eEU5cEVMNGUyM2JKMUNWZzArSlNmNHRuMUhIWU00WExVQW4xZUFjUzJnNkNS?=
 =?utf-8?B?TmNZeGNOeDBLdVFQT2ZaSzF5WUc0a2hnWnIyaE5WNStacFZBNkFyczV3aVFw?=
 =?utf-8?B?N002c0VHWWZWK25IR3BEQlNMbnpUYUNGeXhzT1hkczFwZ242ZkpBVTZkZHds?=
 =?utf-8?B?S2pGN0JZeFlEUnFueHVlV3JKWG80ODZBTm1KVGJWUFVCc24zL0IxRlROb2VD?=
 =?utf-8?B?R3NQL3k3UzVqS2VlcEoxcG01aEcxeDg3dkl5OTdvVlUzVENhSWV4UHN5ZWFC?=
 =?utf-8?B?RmFiVFl6VFJkaVVDTXkxWDJza0RHSzIyZlFYNXY1K29OUExvZDhOTk1uNk8y?=
 =?utf-8?B?SEIwTG5hMzlydXhacVJ4bFAzdzUyWjhDZ1N2cXErLytyTWFHNVMyMVVXbmNw?=
 =?utf-8?B?cFN5UEtya0ZTMHVVUVZQdz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6342fd3a-2430-430a-67a6-08d96018045a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2021 18:10:51.9550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tak1JeENAMvkwwbU2yr4CRnBakZMmUWmmq0kBOGUUz/cemIkE3QpxEvK9gjUbupD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2415
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: J7SbzyFZXcWL4U4Alho8WTY7TLgpxylb
X-Proofpoint-GUID: J7SbzyFZXcWL4U4Alho8WTY7TLgpxylb
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 1 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-15_06:2021-08-13,2021-08-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 phishscore=0 adultscore=0 malwarescore=0 bulkscore=0 mlxscore=0
 impostorscore=0 spamscore=0 clxscore=1015 mlxlogscore=999
 lowpriorityscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2108150125
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/13/21 5:21 PM, Kuniyuki Iwashima wrote:
> From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
> Date:   Fri, 13 Aug 2021 16:25:53 -0700
>> On Thu, Aug 12, 2021 at 9:46 AM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
>>>
>>> The iterator can output almost the same result compared to /proc/net/unix.
>>> The header line is aligned, and the Inode column uses "%8lu" because "%5lu"
>>> can be easily overflown.
>>>
>>>    # cat /sys/fs/bpf/unix
>>>    Num               RefCount Protocol Flags    Type St Inode    Path
>>
>> It's totally my OCD, but why the column name is not aligned with
>> values? I mean the "Inode" column. It's left aligned, but values
>> (numbers) are right-aligned? I'd fix that while applying, but I can't
>> apply due to selftests failures, so please take a look.
> 
> Ah, honestly, I've felt something strange about the column... will fix it!
> 
> 
>>
>>
>>>    ffff963c06689800: 00000002 00000000 00010000 0001 01    18697 private/defer
>>>    ffff963c7c979c00: 00000002 00000000 00000000 0001 01   598245 @Hello@World@
>>>
>>>    # cat /proc/net/unix
>>>    Num       RefCount Protocol Flags    Type St Inode Path
>>>    ffff963c06689800: 00000002 00000000 00010000 0001 01 18697 private/defer
>>>    ffff963c7c979c00: 00000002 00000000 00000000 0001 01 598245 @Hello@World@
>>>
>>> Note that this prog requires the patch ([0]) for LLVM code gen.  Thanks to
>>> Yonghong Song for analysing and fixing.
>>>
>>> [0] https://reviews.llvm.org/D107483
>>>
>>> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
>>> Acked-by: Yonghong Song <yhs@fb.com>
>>> ---
>>
>> This selftests breaks test_progs-no_alu32 ([0], the error log is super
>> long and can freeze browser; it looks like an infinite loop and BPF
>> verifier just keeps reporting it until it runs out of 1mln
>> instructions or something). Please check what's going on there, I
>> can't land it as it is right now.
>>
>>    [0] https://github.com/kernel-patches/bpf/runs/3326071112?check_suite_focus=true#step:6:124288
>>
>>
>>>   tools/testing/selftests/bpf/README.rst        | 38 +++++++++
>>>   .../selftests/bpf/prog_tests/bpf_iter.c       | 16 ++++
>>>   tools/testing/selftests/bpf/progs/bpf_iter.h  |  8 ++
>>>   .../selftests/bpf/progs/bpf_iter_unix.c       | 77 +++++++++++++++++++
>>>   .../selftests/bpf/progs/bpf_tracing_net.h     |  4 +
>>>   5 files changed, 143 insertions(+)
>>>   create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_unix.c
>>>
>>
>> [...]
>>
>>> +                       /* The name of the abstract UNIX domain socket starts
>>> +                        * with '\0' and can contain '\0'.  The null bytes
>>> +                        * should be escaped as done in unix_seq_show().
>>> +                        */
>>> +                       int i, len;
>>> +
>>
>> no_alu32 variant probably isn't happy about using int for this, it
>> probably does << 32, >> 32 dance and loses track of actual value in
>> the loop. You can try using u64 instead.
> 
> Sorry, I missed the no_alu32 test.
> Changing int to __u64 fixed the error, thanks!

Indeed for no_alu32, the index has << 32 and >> 32, which makes
verifier *equivalent* register tracking not effective, see below:

       96:       r1 = r8 

       97:       r1 <<= 32 

       98:       r2 = r1 

       99:       r2 >>= 32 

      100:       if r2 > 109 goto +19 <LBB0_21> 

      101:       r1 s>>= 32 

      102:       if r1 s< 2 goto +17 <LBB0_21> 

      103:       r9 = 1 

      104:       r8 <<= 32 

      105:       r8 >>= 32

Because these shifting, r1/r2/r8 equivalence cannot be
easily established, so verifier ends with conservative
r8 and cannot verify program successfully.

Using __u64 for 'i' and 'len', the upper bound is directly
tested:
       98:       if r8 > 109 goto +16 <LBB0_21> 

       99:       if r8 < 2 goto +15 <LBB0_21>
and verifier is very happy with this.

> 
> 
>>
>>> +                       len = unix_sk->addr->len - sizeof(short);
>>> +
>>> +                       BPF_SEQ_PRINTF(seq, " @");
>>> +
>>> +                       /* unix_mkname() tests this upper bound. */
>>> +                       if (len < sizeof(struct sockaddr_un))
>>> +                               for (i = 1; i < len; i++)
>>
>> if you move above if inside the loop to break out of the loop, does it
>> change how Clang generates code?
>>
>> for (i = 1; i < len i++) {
>>      if (i >= sizeof(struct sockaddr_un))
>>          break;
>>      BPF_SEQ_PRINTF(...);
>> }
> 
> Yes, but there seems little defference.
> Which is preferable?
> 
> ---8<---
> before (for inside if) <- -> after (if inside loop)
>        96:	07 08 00 00 fe ff ff ff	r8 += -2			  |	; 			for (i = 1; i < len; i++) {
> ; 			if (len < sizeof(struct sockaddr_un))		  |	      97:	bf 81 00 00 00 00 00 00	r1 = r8
>        97:	25 08 10 00 6d 00 00 00	if r8 > 109 goto +16 <LBB0_21>	  |	      98:	07 01 00 00 fc ff ff ff	r1 += -4
> ; 				for (i = 1; i < len; i++)		  |	      99:	25 01 12 00 6b 00 00 00	if r1 > 107 goto +18 <LBB0_21>
>        98:	a5 08 0f 00 02 00 00 00	if r8 < 2 goto +15 <LBB0_21>	  |	     100:	07 08 00 00 fe ff ff ff	r8 += -2
>        99:	b7 09 00 00 01 00 00 00	r9 = 1				  |	     101:	b7 09 00 00 01 00 00 00	r9 = 1
>       100:	05 00 16 00 00 00 00 00	goto +22 <LBB0_18>		  |	     102:	b7 06 00 00 02 00 00 00	r6 = 2
> 									  |	     103:	05 00 17 00 00 00 00 00	goto +23 <LBB0_17>
> ...
>       111:	85 00 00 00 7e 00 00 00	call 126			  |	     113:	b4 05 00 00 08 00 00 00	w5 = 8
> ; 				for (i = 1; i < len; i++)		  |	     114:	85 00 00 00 7e 00 00 00	call 126
>       112:	07 09 00 00 01 00 00 00	r9 += 1				  |	; 			for (i = 1; i < len; i++) {
>       113:	ad 89 09 00 00 00 00 00	if r9 < r8 goto +9 <LBB0_18>	  |	     115:	25 08 02 00 6d 00 00 00	if r8 > 109 goto +2 <LBB0_21>
> 									  >	     116:	07 09 00 00 01 00 00 00	r9 += 1
> 									  >	; 			for (i = 1; i < len; i++) {
> 									  >	     117:	ad 89 09 00 00 00 00 00	if r9 < r8 goto +9 <LBB0_17>
> ---8<---
> 
> 
>>
>>
>>> +                                       BPF_SEQ_PRINTF(seq, "%c",
>>> +                                                      unix_sk->addr->name->sun_path[i] ?:
>>> +                                                      '@');
>>> +               }
>>> +       }
>>> +
>>> +       BPF_SEQ_PRINTF(seq, "\n");
>>> +
>>> +       return 0;
>>> +}
>>> diff --git a/tools/testing/selftests/bpf/progs/bpf_tracing_net.h b/tools/testing/selftests/bpf/progs/bpf_tracing_net.h
>>> index 3af0998a0623..eef5646ddb19 100644
>>> --- a/tools/testing/selftests/bpf/progs/bpf_tracing_net.h
>>> +++ b/tools/testing/selftests/bpf/progs/bpf_tracing_net.h
>>> @@ -5,6 +5,10 @@
>>>   #define AF_INET                        2
>>>   #define AF_INET6               10
>>>
>>> +#define __SO_ACCEPTCON         (1 << 16)
>>> +#define UNIX_HASH_SIZE         256
>>> +#define UNIX_ABSTRACT(unix_sk) (unix_sk->addr->hash < UNIX_HASH_SIZE)
>>> +
>>>   #define SOL_TCP                        6
>>>   #define TCP_CONGESTION         13
>>>   #define TCP_CA_NAME_MAX                16
>>> --
>>> 2.30.2
>>>
