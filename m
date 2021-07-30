Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A47593DBCFD
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 18:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbhG3QW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 12:22:59 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:59282 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229477AbhG3QW7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 12:22:59 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 16UGJosC031802;
        Fri, 30 Jul 2021 09:22:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=cOykOrbANnM0x7cpQslbtdMlAKanZHanjvNq598xVlg=;
 b=gn72hE+2/4wooqy/mPdv1OyvguF00+b/0StJZrkJ6iX2+UNv4k35Si2HWsieLn7SHUez
 VPp3Ba+pCfQ1AcxomP8Lghg92rAMyfy+fyePBYISZ7GORgKqORMMtH9GSWTz1qJ8BTuc
 qvk0YYV6NDKxIMUkhoO1YzEJxmeEPZ6oAQQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 3a4eqhj6p4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 30 Jul 2021 09:22:38 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 30 Jul 2021 09:22:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EqXHNGoteNvSiaYHvunigcfnvzAqld2qFwZl6AyeS/svh1+sJ785qcckvPIF+ScmPs9A2uKY/t6zfajjPx5c9HbdMDkrQZz/mgelsPgYF5ZxpMGsEYiDLcozsTlu4/bOlcmnIrqa6Iv1xS2z9vUa3RVBf9tIztbT5t7Egbdv3aC9AlPvwPPS7X2E55xSqzeQKjpTKtQNM5twUuPBhdygXNbrxNYJfXQmkKZokrhPFDzm0w5bdGQmv7BB7ALupxRJ4Fq+rqoR0mmIX3teDaDbdlm9GyZOnjL8b/nlZJiKAv7urf2tQm3oWEYDCc3Q54XU/Ahebw8ThGzD54rteNsR1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F8jT2v/w0v5HBQexfWq+fz3BRkJK9W2nlj2tE6RjLpQ=;
 b=A0W1mfxKB5DzPFk1e0GCBxCKdx9NAkSDXYLfVE+vGcruimbVHqdQMwdIIt6K61ZaUSEIqYtYB5RX9sFi4muz9rkbhYBa6JyhMR7Lgdd+1UriqKv10TQwJ9o3OWUEXyfxy6SODXG/DVv4RIqsJ4D1QU9tmPf93CZxbeqRMJs3Hoj5Bv1DPPKRd586Q5PhDQcmND7UsZOY5YUwolS4rwmGcPnKIDPr9MwjvCFB2LvX1rM5iKi+g3OseB0bempJ5zhG7EdeTa2kEamKYFkNg3LA7/axUjCa0JNzykTmh21Ig1vaQ5GdQuRRlyFLHhe+nPlO636DF1ZoR7o2oU3PZgSxSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4871.namprd15.prod.outlook.com (2603:10b6:806:1d2::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.20; Fri, 30 Jul
 2021 16:22:35 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb%7]) with mapi id 15.20.4373.021; Fri, 30 Jul 2021
 16:22:35 +0000
Subject: Re: [PATCH bpf-next 2/2] selftest/bpf: Implement sample UNIX domain
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <benh@amazon.com>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <john.fastabend@gmail.com>, <kafai@fb.com>,
        <kpsingh@kernel.org>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <songliubraving@fb.com>
References: <0a16fcbb-1c17-dfe2-24b0-6f1d1e6a91bd@fb.com>
 <20210730075806.48560-1-kuniyu@amazon.co.jp>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <1994df05-8f01-371f-3c3b-d33d7836878c@fb.com>
Date:   Fri, 30 Jul 2021 09:22:32 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
In-Reply-To: <20210730075806.48560-1-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
X-ClientProxiedBy: BYAPR04CA0021.namprd04.prod.outlook.com
 (2603:10b6:a03:40::34) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21d6::1130] (2620:10d:c090:400::5:ca99) by BYAPR04CA0021.namprd04.prod.outlook.com (2603:10b6:a03:40::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Fri, 30 Jul 2021 16:22:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9631a9bf-29d9-4f5f-98e8-08d953763d89
X-MS-TrafficTypeDiagnostic: SA1PR15MB4871:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB48711F3B5145AE1460CD1C22D3EC9@SA1PR15MB4871.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:529;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: glnnLK6r4/3geaOn4ikornrX/iDzyzjE/TeyPCSv7YG0E/zsTNLmb0Tabp83LNQOqb9yuVEsehHB7z7xP3M5GKAFFXrl8tsPyAmMDOYZdZxtya9eMAY8yHjZxH5Dt6QH5hKrHbX6ylXMjd6uHV/w6ZPCiSgm6iUoqfDXeDoiFHud+fMeB9FgL5MkuPdSWY00/IbOeoqRz1vZH3x+FgJUTRC03XW9IZG5keDGZDCP+JZ7FK6lu5Gxd5NK9eVAb3eakYtD6dEuJwfsd6yaQ6BA05NHKPg4r2alyrWzRqAoPB6h+p2QNQIy0pQs8bW3cY3E6JGgEnc4WK0QxQSVwv/KZmismiRa1cP81WiDXWXxSKHqlo6cY5bT/8w/S3rvBEE3WVUxlO+F5aFZpmZGEP06CRnZkRVx/xtpxtj4lZeKcfSI6TqjE8Yj3xoO8YQjEJAFvHCJ9b9nXTDcwf6oN+vkuqQZgC6vY1EXJgcn7NMbytlQL6Nc3N9IxAY8FxnpWX77LyHCsG4ufcOSqZ/9+jTBq9qGktGblreM19gCEroUqYLX+GnOrmn6ID0KHnZ8CyzfGEfqyMWt1IB0C7hLkYhFBDd3Qs1Qv38gUGLsIvtH8wePv58COQuabfbqPp25mKxfkPEO587htT9WqNtEzGAixxg8+eba5jcC7mHTw93LaL2/f3JeHFB25X0B/40Tvnjw/62tGae62FPAV2/B31UNPrxd8Gt/fwCA55EMuPrVg6mjAHSoL5/xxY36rgY2lYUoWwepy7UWl5oiz/YrIBEqgXd+8+jeABtw+NXotXhpM5fBZt39a9yeVg1y22kL71NY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39850400004)(376002)(396003)(136003)(366004)(66556008)(66476007)(8936002)(66946007)(4326008)(186003)(6486002)(31696002)(2906002)(38100700002)(2616005)(7416002)(316002)(86362001)(52116002)(6916009)(478600001)(36756003)(5660300002)(53546011)(31686004)(83380400001)(8676002)(966005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UGlqZEdKU0hpSmxNbVdsTU5kbExIaDIrbEFjQ3VaeUhOK2dkdDhCMFUyWWdx?=
 =?utf-8?B?SklaRkl2aTVoM3dsSWlNdXkxZk1EaUd6cHpOTFo3b0dnWGU3T2Iwa3hiRGpp?=
 =?utf-8?B?dC92ancraFJIT0w2QVpJVUVZanllWUlnbGgzdW92dW5Vb0lMVXN1SzZKWXlp?=
 =?utf-8?B?QzFPN1N5WkFsLzRiSk1mTEpSMDg4QjRvRnFsTnB5YWhqeUhXL1lhSCtyQTJz?=
 =?utf-8?B?NDV5dTBxblZIMG5EK3MvcStvenhGazNpVzYvNVlBUTNnVUFkc2IxcHBxSWI4?=
 =?utf-8?B?YjQ1bWE1eUQvV0dMWS9IUDA5NUl3UVBGQ1RGZSs5YzgvWnZsWmpHS0xXUml1?=
 =?utf-8?B?bjNuWlUwaTBGaUZwbGk4TittNWhUb01BcUR4VDlrRFJ1OU95U1BxRlhFakFy?=
 =?utf-8?B?eTJ1NGVwcTRKVU15MW1nTTRndlhzMDhwZkxlZVM5Vk4xQjYxYTVXWVpOTlI2?=
 =?utf-8?B?U0xVOWxQazlqUWU3TFNkMGFuNk9vdUZteHdiWHArbldYdmVjeXpqazZ2SG9j?=
 =?utf-8?B?SUp6ajh4L2RZM250LzArQzZITXNIRi9FaUlTc1ZDcmRaZE9BZ1llUjJXNnM3?=
 =?utf-8?B?YUNRS1RvMDI0cnUvWURnVDZUL1BWNGUramNsUkk1OVIyS3VJNWwyUXhma04v?=
 =?utf-8?B?RXBBc1ZnWnJSWWJFWFZFb2FncWdiOWcvRnRoZDc0REZuUEp6N0xmcXhmajRo?=
 =?utf-8?B?OW4yN3NVeGZlei9henpDcmdOZlZNNzJXdVViOUlEZG1JUjI0bDloNm1VNDR1?=
 =?utf-8?B?UDdRUHkrZmFhby9XVzR2ME9XeEk2aVZrVU9uaTBhb25TSXlJMDFuQ2cxa25O?=
 =?utf-8?B?aVpBZWtzWlBoQnRTMUdVSk5rOHJsVlRzWGREM1BMYTQxMFZUK0NPZm9hdEcw?=
 =?utf-8?B?TTJSOWF6SFFwTDZmaE1Dc2NpdHd1TFFuMVNlZnNxWm9lVG5rS1I5YmEreHVV?=
 =?utf-8?B?WUpMYlV1V3lWaThsUEZSWXFRVmp0ZVhlNzd6Q2wzM3RVOUxpZ0VtWTZLOXJM?=
 =?utf-8?B?UVJ1ZG5jSjBjMnlFdWRFSzZRK1ptRmdYRWdlVU9nNng3RUU3L3d3WEVOYnZu?=
 =?utf-8?B?RUhRSUQ3MVo0Z3pLdjRub2xzdTFML1V5d1l0aWdHR3ZyZkt5WXdWU1Y2S0h5?=
 =?utf-8?B?TnRRVURicTBXeXZ1MUthNGV6WExUa0hqSHNZVEdNbXAzcGRIdWlQa0NZLzBW?=
 =?utf-8?B?alA5UzdudWJ1NGZtcXFXcldVNUVEbTh3UWtsQVE1aG02anRyeUttVjRBNGJP?=
 =?utf-8?B?MDM4VDVJRUViUXZ2QktIU1ZaMnNqanFtRUV6VnZ6bkw1L0RXNDBDc3BkMUYx?=
 =?utf-8?B?a0ZOQ1huOFFqdWZUUXJCSXVSZGk3UUtUMXlieHhwS1FVTTdDWCtnNnBNUDR4?=
 =?utf-8?B?WE5IeFc1a0VlekxLTlV4QzFtQnFLVHllMDVLeTFMUlRYcW55MGZqWWQxc1Bt?=
 =?utf-8?B?V3MxRFRuTDlyN29oZ1ZSQndwNTFxTXBMMDc3eU9BL085YitOY2MzZXIyR0NF?=
 =?utf-8?B?SGFwMDNWSEk1ci9HL2RBNy9qZFNRaS9wTTdaUFhramZ3M3YwUllJUTh0SnhD?=
 =?utf-8?B?eHREL1J1ZmNqTmdpeDdVRXZTeDhyc0pLS09KdHUxbWVTMTVEWUJwVWJVbGJ4?=
 =?utf-8?B?TWRuV2hKbHNCR3FTTmtmZGVMVDZIcG9SMUkzeHlsaHNtQWxoQUZIZmhBUElO?=
 =?utf-8?B?eHNyNmhvQmZQTDNzZ3J4N0RrOWhzN2l0WlJ6MFNjZzBaTXViWnNKVlFKb1F0?=
 =?utf-8?B?SlRmbXZuRU5ManduTmM3NGphczhoOGNBdFMzV0Z2SzhkVXgzSk5tdlhOTzEx?=
 =?utf-8?Q?ATonOB85lKQSv9Z+OOLFf7kukE2Slvi6JtfB4=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9631a9bf-29d9-4f5f-98e8-08d953763d89
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2021 16:22:35.4739
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zieYeLCBPvQd1U4CNYsUioaFJxywkUEv8PZZSLrUgGW6r5ut5zbOLw35mGNbP79L
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4871
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: H2KfH7R9WDnFHxA7GyZ8bDdBoTJ9w3iC
X-Proofpoint-GUID: H2KfH7R9WDnFHxA7GyZ8bDdBoTJ9w3iC
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 1 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-30_11:2021-07-30,2021-07-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 spamscore=0
 adultscore=0 impostorscore=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107300110
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/30/21 12:58 AM, Kuniyuki Iwashima wrote:
> From:   Yonghong Song <yhs@fb.com>
> Date:   Thu, 29 Jul 2021 23:54:26 -0700
>> On 7/29/21 4:36 PM, Kuniyuki Iwashima wrote:
>>> If there are no abstract sockets, this prog can output the same result
>>> compared to /proc/net/unix.
>>>
>>>     # cat /sys/fs/bpf/unix | head -n 2
>>>     Num       RefCount Protocol Flags    Type St Inode Path
>>>     ffff9ab7122db000: 00000002 00000000 00010000 0001 01 10623 private/defer
>>>
>>>     # cat /proc/net/unix | head -n 2
>>>     Num       RefCount Protocol Flags    Type St Inode Path
>>>     ffff9ab7122db000: 00000002 00000000 00010000 0001 01 10623 private/defer
>>>
>>> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
>>> ---
>>>    .../selftests/bpf/prog_tests/bpf_iter.c       | 17 +++++
>>>    .../selftests/bpf/progs/bpf_iter_unix.c       | 75 +++++++++++++++++++
>>>    2 files changed, 92 insertions(+)
>>>    create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_unix.c
>>>
>>> diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
>>> index 1f1aade56504..4746bac68d36 100644
>>> --- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
>>> +++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
>>> @@ -13,6 +13,7 @@
>>>    #include "bpf_iter_tcp6.skel.h"
>>>    #include "bpf_iter_udp4.skel.h"
>>>    #include "bpf_iter_udp6.skel.h"
>>> +#include "bpf_iter_unix.skel.h"
>>>    #include "bpf_iter_test_kern1.skel.h"
>>>    #include "bpf_iter_test_kern2.skel.h"
>>>    #include "bpf_iter_test_kern3.skel.h"
>>> @@ -313,6 +314,20 @@ static void test_udp6(void)
>>>    	bpf_iter_udp6__destroy(skel);
>>>    }
>>>    
>>> +static void test_unix(void)
>>> +{
>>> +	struct bpf_iter_unix *skel;
>>> +
>>> +	skel = bpf_iter_unix__open_and_load();
>>> +	if (CHECK(!skel, "bpf_iter_unix__open_and_load",
>>> +		  "skeleton open_and_load failed\n"))
>>> +		return;
>>> +
>>> +	do_dummy_read(skel->progs.dump_unix);
>>> +
>>> +	bpf_iter_unix__destroy(skel);
>>> +}
>>> +
>>>    /* The expected string is less than 16 bytes */
>>>    static int do_read_with_fd(int iter_fd, const char *expected,
>>>    			   bool read_one_char)
>>> @@ -1255,6 +1270,8 @@ void test_bpf_iter(void)
>>>    		test_udp4();
>>>    	if (test__start_subtest("udp6"))
>>>    		test_udp6();
>>> +	if (test__start_subtest("unix"))
>>> +		test_unix();
>>>    	if (test__start_subtest("anon"))
>>>    		test_anon_iter(false);
>>>    	if (test__start_subtest("anon-read-one-char"))
>>> diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_unix.c b/tools/testing/selftests/bpf/progs/bpf_iter_unix.c
>>> new file mode 100644
>>> index 000000000000..285ec2f7944d
>>> --- /dev/null
>>> +++ b/tools/testing/selftests/bpf/progs/bpf_iter_unix.c
>>> @@ -0,0 +1,75 @@
>>> +// SPDX-License-Identifier: GPL-2.0
>>> +/* Copyright Amazon.com Inc. or its affiliates. */
>>> +#include "bpf_iter.h"
>>
>> Could you add bpf_iter__unix to bpf_iter.h similar to bpf_iter__sockmap?
>> The main purpose is to make test tolerating with old vmlinux.h.
> 
> Thank you for explanation!
> I've understood why it is needed even when the same struct is defined.
> I'll add it in the next spin.
> 
> 
>>
>>> +#include "bpf_tracing_net.h"
>>> +#include <bpf/bpf_helpers.h>
>>> +#include <bpf/bpf_endian.h>
>>> +
>>> +char _license[] SEC("license") = "GPL";
>>> +
>>> +#define __SO_ACCEPTCON		(1 << 16)
>>> +#define UNIX_HASH_SIZE		256
>>> +#define UNIX_ABSTRACT(unix_sk)	(unix_sk->addr->hash < UNIX_HASH_SIZE)
>>
>> Could you add the above three define's in bpf_tracing_net.h?
>> We try to keep all these common defines in a common header for
>> potential reusability.
> 
> Will do.
> 
> 
>>
>>> +
>>> +static long sock_i_ino(const struct sock *sk)
>>> +{
>>> +	const struct socket *sk_socket = sk->sk_socket;
>>> +	const struct inode *inode;
>>> +	unsigned long ino;
>>> +
>>> +	if (!sk_socket)
>>> +		return 0;
>>> +
>>> +	inode = &container_of(sk_socket, struct socket_alloc, socket)->vfs_inode;
>>> +	bpf_probe_read_kernel(&ino, sizeof(ino), &inode->i_ino);
>>> +	return ino;
>>> +}
>>> +
>>> +SEC("iter/unix")
>>> +int dump_unix(struct bpf_iter__unix *ctx)
>>> +{
>>> +	struct unix_sock *unix_sk = ctx->unix_sk;
>>> +	struct sock *sk = (struct sock *)unix_sk;
>>> +	struct seq_file *seq;
>>> +	__u32 seq_num;
>>> +
>>> +	if (!unix_sk)
>>> +		return 0;
>>> +
>>> +	seq = ctx->meta->seq;
>>> +	seq_num = ctx->meta->seq_num;
>>> +	if (seq_num == 0)
>>> +		BPF_SEQ_PRINTF(seq, "Num       RefCount Protocol Flags    "
>>> +			       "Type St Inode Path\n");
>>> +
>>> +	BPF_SEQ_PRINTF(seq, "%pK: %08X %08X %08X %04X %02X %5lu",
>>> +		       unix_sk,
>>> +		       sk->sk_refcnt.refs.counter,
>>> +		       0,
>>> +		       sk->sk_state == TCP_LISTEN ? __SO_ACCEPTCON : 0,
>>> +		       sk->sk_type,
>>> +		       sk->sk_socket ?
>>> +		       (sk->sk_state == TCP_ESTABLISHED ?
>>> +			SS_CONNECTED : SS_UNCONNECTED) :
>>> +		       (sk->sk_state == TCP_ESTABLISHED ?
>>> +			SS_CONNECTING : SS_DISCONNECTING),
>>> +		       sock_i_ino(sk));
>>> +
>>> +	if (unix_sk->addr) {
>>> +		if (UNIX_ABSTRACT(unix_sk))
>>> +			/* Abstract UNIX domain socket can contain '\0' in
>>> +			 * the path, and it should be escaped.  However, it
>>> +			 * requires loops and the BPF verifier rejects it.
>>> +			 * So here, print only the escaped first byte to
>>> +			 * indicate it is an abstract UNIX domain socket.
>>> +			 * (See: unix_seq_show() and commit e7947ea770d0d)
>>> +			 */
>>> +			BPF_SEQ_PRINTF(seq, " @");
>>> +		else
>>> +			BPF_SEQ_PRINTF(seq, " %s", unix_sk->addr->name->sun_path);
>>> +	}
>>
>> I looked at af_unix.c, for the above "if (unix_sk->addr) { ... }" code,
>> the following is the kernel source code,
>>
>>                   if (u->addr) {  // under unix_table_lock here
>>                           int i, len;
>>                           seq_putc(seq, ' ');
>>
>>                           i = 0;
>>                           len = u->addr->len - sizeof(short);
>>                           if (!UNIX_ABSTRACT(s))
>>                                   len--;
>>                           else {
>>                                   seq_putc(seq, '@');
>>                                   i++;
>>                           }
>>                           for ( ; i < len; i++)
>>                                   seq_putc(seq, u->addr->name->sun_path[i] ?:
>>                                            '@');
>>                   }
>>
>> It does not seem to match bpf program non UNIX_ABSTRACT case.
>> I am not familiar with unix socket so it would be good if you can
>> explain a little more.
> 
> There is three kinds of unix sockets: pathname, unnamed, abstract.  The
> first two terminate the addr with `\0`, but abstract must start with `\0`
> and can contain `\0` anywhere in addr.  The `\0` in addr of abstract socket
> does not have special meaning. [1]
> 
> They are inserted into the same hash table in unix_bind(), so the bpf prog
> matches all of them.
> 
> ``` net/unix/af_unix.c
>    1114		if (sun_path[0])
>    1115			err = unix_bind_bsd(sk, addr);
>    1116		else
>    1117			err = unix_bind_abstract(sk, addr);
> ```
> 
> [1]: https://man7.org/linux/man-pages/man7/unix.7.html
> 
> 
>>
>> For verifier issue with loops, do we have a maximum upper bound for
>> u->addr->len? If yes, does bounded loop work?
> 
> That has a maximum length in unix_mkname(): sizeof(struct sockaddr_un).
> 
> ``` net/unix/af_unix.c
>     223	/*
>     224	 *	Check unix socket name:
>     225	 *		- should be not zero length.
>     226	 *	        - if started by not zero, should be NULL terminated (FS object)
>     227	 *		- if started by zero, it is abstract name.
>     228	 */
>     229	
>     230	static int unix_mkname(struct sockaddr_un *sunaddr, int len, unsigned int *hashp)
>     231	{
> ...
>     234		if (len <= sizeof(short) || len > sizeof(*sunaddr))
>     235			return -EINVAL;
> ...
>     253	}
> ```
> 
> So, I rewrote the test like this, but it still causes an error.
> 
> ```
> 	if (unix_sk->addr) {
> 		int i, len;
> 
> 		len = unix_sk->addr->len - sizeof(short);
> 
> 		if (!UNIX_ABSTRACT(unix_sk)) {
> 			BPF_SEQ_PRINTF(seq, " %s", unix_sk->addr->name->sun_path);
> 		} else {
> 			BPF_SEQ_PRINTF(seq, " @");
> 			i++;

i++ is not useful here and "i" is not initialized earlier.

> 
> 			if (len < sizeof(struct sockaddr_un)) {
> 				for (i = 1 ; i < len; i++)
> 					BPF_SEQ_PRINTF(seq, "%c",
> 						       unix_sk->addr->name->sun_path[i] ?:
> 						       '@');
> 			}
> 		}
> 	}
> ```
> 
> ```
> processed 196505 insns (limit 1000000) max_states_per_insn 4 total_states 1830 peak_states 1830 mark_read 3
> ```

I did some debugging, the main reason is that llvm compiler used "!=" 
instead of "<" for "i < len" comparison.

      107:       b4 05 00 00 08 00 00 00 w5 = 8
      108:       85 00 00 00 7e 00 00 00 call 126
;                               for (i = 1 ; i < len; i++)
      109:       07 09 00 00 01 00 00 00 r9 += 1
      110:       5d 98 09 00 00 00 00 00 if r8 != r9 goto +9 <LBB0_18>


Considering "len" is not a constant, for verifier, r8 will never be 
equal to r9 in the above.

Digging into llvm compilation, it is llvm pass Induction Variable 
simplication pass made this code change. I will try to dig more and
find a solution. In your next revision, could you add the above code
as a comment so once llvm code gen is improved, we can have proper
implementation to match /proc/net/unix?

> 
>>
>>> +
>>> +	BPF_SEQ_PRINTF(seq, "\n");
>>> +
>>> +	return 0;
>>> +}
