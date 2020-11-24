Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEF492C2D57
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 17:55:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390554AbgKXQvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 11:51:24 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:22788 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726929AbgKXQvX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 11:51:23 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AOGowGu001700;
        Tue, 24 Nov 2020 08:51:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=lWIE+/ZLzymiHn4giM5xucFY3i5FAP1nR4x+Edxo068=;
 b=JMZgUMkpmReWqJdteSMNGkaj0HK4yeCfTSAgo6wgMC2lvWIwpQ18L6WEdbeLqzYm2czb
 YhHLTFSL6za/CA1xVsIZtmbmYFwhOk25+oYV8iL1kgfYeXjDVnI76pf6E/y7FT24ZZ/x
 NiQpEXjBMxbC4q1DR5C/Y+P5LZwLrNPz9/4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34yk9gagu0-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 24 Nov 2020 08:51:03 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 24 Nov 2020 08:50:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IMqjHTaPZmm807M+4QGArEWuhEHfcKt/tOGmpzaCk1zu3GvfOWsL/N7Vzcho/RfuP3ofN+ZQyalkbvEfAnlU3GT20LqMBawugRxHxwzXcH1q/1H+PezWi+Y7BL/9fFFarBON1JR/02qfzVkHcVuz/+NQ0tCxwVMwz+h0NgHOBOtwkEjUW5GApaYovReuUrC0/02kohRf/uy0J0wQ/+fBoBVgrDKRMti/vFBpQNIx62j0sJXAveg8yk+EDvYm9YGK1S9K/FhtK+xcqEoaS+awgeeUTPqc5VKWjvGwhi4SJmaI40ZJPKV5ial+DPeHW164ZRvmXVAn6T2Z63GF0Uz4rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DBqPPIpGE1rX8DkrzTBmW/iw8r8n6U4KXCYskr/fAyo=;
 b=UG5YZwCKFCc8BUJzSYeABuMpRp7RVRxMcgDQGUo9xc74hQXRaNMhMSebNXBpeIt7ja7Ob9TnVbyShzzuMefnwVLr+zD1jVyg9AmXu8JLUM6xjcsWuGHvBcTbgO3FXrwVYWVtalTJBZ3/YTBfrwUozsF2rYQuu8Ul527SKChgkZviebJ4UuLBWIbvGlLEeO0dopulJI5Ua4fbjBgVZqfQzMemMyUfOoaKXIKKNX4sgDvIUXaszBilBhW8YGVzIPcoZ1csXgS3oPQLsK6Us6GIKLfKNl3F7z3Q1G3qtk23YWyS57dnvcEWGFJS4oaQdvUj4Ll1R6ipRKSlYLriRJiuCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DBqPPIpGE1rX8DkrzTBmW/iw8r8n6U4KXCYskr/fAyo=;
 b=TPw8+IZ4i7cciabsdit9HD25TFBFPaWkRV1cpeHyHlH8EUvAZPT0PUuYg4hfy7q+DuSnPamFxK0NTIbcgPHFy051tDPCw9el/E/DsQxGD1f3QT1SwyEwy8QcNtytdlkBvaMlzPkJrR3B2KBYTPXT3H/gAlkCalk98pMUpdaTLXM=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2886.namprd15.prod.outlook.com (2603:10b6:a03:f7::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.22; Tue, 24 Nov
 2020 16:50:46 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3589.029; Tue, 24 Nov 2020
 16:50:46 +0000
Subject: Re: [PATCH bpf-next V7 8/8] bpf/selftests: activating bpf_check_mtu
 BPF-helper
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <maze@google.com>,
        Lorenz Bauer <lmb@cloudflare.com>, <shaun@tigera.io>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, <eyal.birger@gmail.com>,
        <colrack@gmail.com>
References: <160588903254.2817268.4861837335793475314.stgit@firesoul>
 <160588912738.2817268.9380466634324530673.stgit@firesoul>
 <CAEf4BzbfqvCiHDaZk3yQCPfzwpGJ-35XBw3qaGuPNYkfBHR2Kw@mail.gmail.com>
 <20201124153301.47abc09c@carbon>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <50342795-fae2-fb20-222e-a7fec282ca62@fb.com>
Date:   Tue, 24 Nov 2020 08:50:43 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.3
In-Reply-To: <20201124153301.47abc09c@carbon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Originating-IP: [2620:10d:c090:400::5:4987]
X-ClientProxiedBy: MWHPR04CA0035.namprd04.prod.outlook.com
 (2603:10b6:300:ee::21) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::10b2] (2620:10d:c090:400::5:4987) by MWHPR04CA0035.namprd04.prod.outlook.com (2603:10b6:300:ee::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Tue, 24 Nov 2020 16:50:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4102ddc6-9f3d-4adc-d62f-08d89099173c
X-MS-TrafficTypeDiagnostic: BYAPR15MB2886:
X-Microsoft-Antispam-PRVS: <BYAPR15MB288636D2AFA74FDE65FF7762D3FB0@BYAPR15MB2886.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U890IQ+CGRLiA/5RV8meMlnDO4WRQbSbPHHEN8qjl7C+Ogk303gyeQzs81YuQdWXVo1tVPaYqbu5dtZrMaRPIJPGYYHtVphDXEffJJm8+56RsGfuKGb0tkaa/mOf9KUpala5JpwzwlI3vLb9CkF0b7l5c8byY6PtWFuSE8mcgzNl8i3QxjfxYuMK6sVuPT++wdEXP+0/tkwCHZmmPOspDI3fR2a9BDiW5+jWRZn3ILddCmsMl+OGRAmxqnZSlzTPsgQ61Cj6ukXVnbhWBiFCK00o5O1zjh/IXZ7TjSVR8TMaD/JwtQ4/wTZAJ8zL17Nf3wiPHBD3viqzqGTudSyX5fFa0UnRuSjP+7Wj6UwXEtUCmtCJT4nxmZ7PzNu0Pv75nDOj2WfJPg52q+0Do7qNTw49UOsLS8x6roKeE658/a/unK9UDCTV1WmcEsYoNhz2Rj5QdF09BZ3kAJxH58nRApR1SCb2KHoqSaXRzcwVOnU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(346002)(366004)(396003)(136003)(966005)(53546011)(478600001)(66946007)(5660300002)(66476007)(31686004)(66556008)(36756003)(86362001)(54906003)(31696002)(316002)(110136005)(2616005)(52116002)(8676002)(45080400002)(8936002)(186003)(16526019)(4326008)(6486002)(7416002)(2906002)(21314003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RTBLbjVoS0h1ZHdRdUJzZVhBbkJWaEdKbXRWMFpTRTg2Wm5uaXJMQXBodUVw?=
 =?utf-8?B?MWpQNGhURVpjN0lBREtoRE1DWVNUdEZCbzBBUU80T0JpcmRaZkg5NCtudkhK?=
 =?utf-8?B?a3NSMGpDcWxjQ0cwUWdHTzF1cVdMOEtmdEYwcDlLS3RQNWFuK0x1Vkk2RllN?=
 =?utf-8?B?WklnU09nVUhROWtnYTJoaUd2eG5zWGo0M2o3NUkyNHByZ3RCMW5BMUVFVUI0?=
 =?utf-8?B?SjJLdkMrVjNCNTBKTlRCZVJnbzZ3Z3EzRHVJNXdncGI0K0V3WE9QbjIrUERP?=
 =?utf-8?B?bHVVNGhHVkhQREJVVFpMS1EwSUpMNk5nakk0YWVwR09nTHVwN2Jqd2ZHOXYy?=
 =?utf-8?B?NVlkTm4zdWYvWWtwYW00b0wxcFdaNElnN2Ruakd0VXFVMEFUWGptam0yOUZ5?=
 =?utf-8?B?QXZIaWp0SVJkclRzNUxrNS9odDI5WXBxRVB1bEhwVEhKWFlac3RjMHBxc0V3?=
 =?utf-8?B?MmZHeElhUGpvZ3NmeDBsN1ZqZldrUk4vd1VJVVBaeUlDSlptSWNYb2xMRnBQ?=
 =?utf-8?B?andSUWVmUU1UNzlLaUpVTElJQ0N6UnVYaW9ZZGdJS1drVXFCRTB0TFIrU1Qz?=
 =?utf-8?B?Wkt5TnAwRHhPL1BTTXRGMnY3QjVjNUhnNXN1TnpCRnI2SDUzMmtSM05ySE1x?=
 =?utf-8?B?RUJ5c1p2Smp4V05FM2lXMWFramxQSG9xWjU1SmkyK25vL201NWtycnVQZDhY?=
 =?utf-8?B?OU5yZFd5VXBkeE5vZDZ6VDlJM2JHbkdVdkhnV1huYWIwa05pSUlqVUt1Vjl0?=
 =?utf-8?B?MzNQZ21QVzVCS2NKSjJ0UTBFWDMyeUNEYXBlNDdQUGJ0dVFIdkRMQlJrWitO?=
 =?utf-8?B?YlMxcUo4ZTgwa2Jmd1lFVHYyY3h2OUJoRXVBRmNXVThxaWR5T3paQUFzMTlS?=
 =?utf-8?B?Q0N6bDBpeXp1bi9RYi9wWFNFQmdHZTF2NmFUQm02dUtMQmlNa254WXN3anRO?=
 =?utf-8?B?SkpxYnYzVFluUnMwUUFrWWg4dkcvRWVuQ1hjRWxybEJvUVN6WmMyL0VHQ1Bs?=
 =?utf-8?B?THQ5U3hrSDg2Q3hZQmpILzNZVW1aKy9tT3hGRUplNnZoQng3bW5xNnVnS3ZC?=
 =?utf-8?B?OUhXUzFtUkQvSnlCK05PT3dYK1c4SktpcmVoNHp4UFZIWSs2N1NxNWsvbHZX?=
 =?utf-8?B?a0piYUh6MW9CRlN3S29XN2JGb2Ivb0FkTnpqc1Y3Q1BSUW04L0daWjNISkxh?=
 =?utf-8?B?TjZCYmMzM1gzYTl2L3JFbkowZHhNVXZYMjlHK0RqSmlVeThnaDRGdnhsQnp5?=
 =?utf-8?B?ZFg0Mk1OT0gyTHVZYkV0WVZDTTlLSGx0MmZ3eVJ6MWJiUXVNUkMxVXF5VXZ0?=
 =?utf-8?B?MW14UUtGVHVyNE5jQWhDNDMweWF0dVdlYjQ5clg0Sm54UW5hMW9OK1Q3MHR3?=
 =?utf-8?B?WE1pWDVHc2xnS0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4102ddc6-9f3d-4adc-d62f-08d89099173c
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2020 16:50:46.8063
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /ZkiOmV75+yFvizYL5npGp09iRK/B5focokX7XgQzDr6YccLmgBbHwHggRRJLW0a
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2886
X-OriginatorOrg: fb.com
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 1 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-24_04:2020-11-24,2020-11-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1011
 suspectscore=0 malwarescore=0 adultscore=0 priorityscore=1501 phishscore=0
 spamscore=0 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011240104
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/24/20 6:33 AM, Jesper Dangaard Brouer wrote:
> On Fri, 20 Nov 2020 23:41:11 -0800
> Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> 
>> On Fri, Nov 20, 2020 at 8:21 AM Jesper Dangaard Brouer
>> <brouer@redhat.com> wrote:
>>>
>>> Adding selftest for BPF-helper bpf_check_mtu(). Making sure
>>> it can be used from both XDP and TC.
>>>
>>> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
>>> ---
>>>   tools/testing/selftests/bpf/prog_tests/check_mtu.c |   37 ++++++++++++++++++++
>>>   tools/testing/selftests/bpf/progs/test_check_mtu.c |   33 ++++++++++++++++++
>>>   2 files changed, 70 insertions(+)
>>>   create mode 100644 tools/testing/selftests/bpf/prog_tests/check_mtu.c
>>>   create mode 100644 tools/testing/selftests/bpf/progs/test_check_mtu.c
>>>
>>> diff --git a/tools/testing/selftests/bpf/prog_tests/check_mtu.c b/tools/testing/selftests/bpf/prog_tests/check_mtu.c
>>> new file mode 100644
>>> index 000000000000..09b8f986a17b
>>> --- /dev/null
>>> +++ b/tools/testing/selftests/bpf/prog_tests/check_mtu.c
>>> @@ -0,0 +1,37 @@
>>> +// SPDX-License-Identifier: GPL-2.0
>>> +/* Copyright (c) 2020 Red Hat */
>>> +#include <uapi/linux/bpf.h>
>>> +#include <linux/if_link.h>
>>> +#include <test_progs.h>
>>> +
>>> +#include "test_check_mtu.skel.h"
>>> +#define IFINDEX_LO 1
>>> +
>>> +void test_check_mtu_xdp(struct test_check_mtu *skel)
>>
>> this should be static func, otherwise it's treated as an independent selftest.
> 
> Ok, fixed.
> 
>>> +{
>>> +       int err = 0;
>>> +       int fd;
>>> +
>>> +       fd = bpf_program__fd(skel->progs.xdp_use_helper);
>>> +       err = bpf_set_link_xdp_fd(IFINDEX_LO, fd, XDP_FLAGS_SKB_MODE);
>>> +       if (CHECK_FAIL(err))
>>
>> please use CHECK() or one of ASSERT_xxx() helpers. CHECK_FAIL() should
>> be used for high-volume unlikely to fail test (i.e., very rarely).
> 
> I could not get CHECK() macro working.  I now realize that this is
> because I've not defined a global static variable named 'duration'.
> 
>   static __u32 duration;
> 
> I wonder, are there any best-practice documentation or blogpost on
> howto write these bpf-selftests?

The 'duration' in old days is used to measure performance. Today most
of selftests actually do not need this. We do not have doc/blogpost
for this. The best is to look at other files under prog_tests to see
how they handle duration ...

> 
> 
> Below signature is the compile error for others to Google for, and
> solution above.
> -
> Best regards,
>    Jesper Dangaard Brouer
>    MSc.CS, Principal Kernel Engineer at Red Hat
>    LinkedIn: http://www.linkedin.com/in/brouer
> 
> 
> $ make
>    TEST-OBJ [test_progs] check_mtu.test.o
> In file included from /home/jbrouer/git/kernel/bpf-next/tools/testing/selftests/bpf/prog_tests/check_mtu.c:6:
> /home/jbrouer/git/kernel/bpf-next/tools/testing/selftests/bpf/prog_tests/check_mtu.c: In function ‘test_check_mtu’:
> ./test_progs.h:129:25: error: ‘duration’ undeclared (first use in this function)
>    129 |  _CHECK(condition, tag, duration, format)
>        |                         ^~~~~~~~
> ./test_progs.h:111:25: note: in definition of macro ‘_CHECK’
>    111 |          __func__, tag, duration);   \
>        |                         ^~~~~~~~
> /home/jbrouer/git/kernel/bpf-next/tools/testing/selftests/bpf/prog_tests/check_mtu.c:33:6: note: in expansion of macro ‘CHECK’
>     33 |  if (CHECK(!skel, "open and load skel", "failed"))
>        |      ^~~~~
> ./test_progs.h:129:25: note: each undeclared identifier is reported only once for each function it appears in
>    129 |  _CHECK(condition, tag, duration, format)
>        |                         ^~~~~~~~
> ./test_progs.h:111:25: note: in definition of macro ‘_CHECK’
>    111 |          __func__, tag, duration);   \
>        |                         ^~~~~~~~
> /home/jbrouer/git/kernel/bpf-next/tools/testing/selftests/bpf/prog_tests/check_mtu.c:33:6: note: in expansion of macro ‘CHECK’
>     33 |  if (CHECK(!skel, "open and load skel", "failed"))
>        |      ^~~~~
> make: *** [Makefile:396: /home/jbrouer/git/kernel/bpf-next/tools/testing/selftests/bpf/check_mtu.test.o] Error 1
> 
