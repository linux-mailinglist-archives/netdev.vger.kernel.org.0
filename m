Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 147031BF0B6
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 09:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbgD3HCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 03:02:35 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:7102 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726337AbgD3HCe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 03:02:34 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03U706Va026729;
        Thu, 30 Apr 2020 00:02:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=3j2etwmAQw8q+jY1GkIOt/RZAh/Rf92lSQ6Ir9vLvoA=;
 b=O8MGSizNq5nOTzyZ9saXkQ6cS1ByoCIjph7cnU63H//PvS5GyJ2iGqOyzRs3jZUK2ws9
 qjvvuM1G6TfhmQjIH69VkbbBOASimnRZxXxSHSCbxlYanGZ7ucx/5WkW1ll9+Na4P66O
 PRTH0xB0Iglqbu1ehwUOttUdTNWNhBj72J8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30qd20m564-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 30 Apr 2020 00:02:20 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 30 Apr 2020 00:02:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eD2dlz4IkCb8/tBM7zBOJr3naeq3PCgzf2K1BKvVEIlvpXV5rhZWA+181dDoUc1U/Z49/wg9Qs1akj+ObuFUbOU23Q+mlxVoyaBjt6MqcOeyWVH/8W13/vCkBPMgM+OnX8i5bBcHDVoyDG/IPVHJD+bRrF612g852rx9zAaLU/ShAojB7Xo+B3CVU8n6pdcf5DrAueIcuPcxyRfsarhwiUIi6dHvXZ2kHzyGZtg0rsPSE+5U4ZRQpY6Sd4rYDUB3/4YqSmTrqkeAsJtGrimo5XXrLg+OF/AJZLPCa9Djd+DTKY6kIv+dzWoZnno13bN13CuxB7bzZBDE6gOFQX9a2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3j2etwmAQw8q+jY1GkIOt/RZAh/Rf92lSQ6Ir9vLvoA=;
 b=C9XEJJAZfM6Zn0KRdhYDmIdApJOdJsaldjt4kGgr1o6xMfAS+YMbHbMwF6SV5HouxyXNqL/leWUeY8ZhXmUL+J/rET9gsuRZMqyxvE9y62JYrG9U2KA38qv9o8HIlbFoEgqUh5Maqy5tbVp9oQ3b8FUfqAMvoeo4XvjHhrDjbvoqyHeJwfbrDRFexelkcp+YewsbZqXTcEX2jIMbn1+NxE2juKNGo+PQuHuNliymJzeS/xtwDJUAyzKkdrefA2IBvO0CYbk5K496RcVjd/wSwXT1dsGXoWpen/S7CzF1kjuBork1UqYDhuRVbV+xYqXzUCQytWMNs8jrCvBjK3+gFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3j2etwmAQw8q+jY1GkIOt/RZAh/Rf92lSQ6Ir9vLvoA=;
 b=Ac/P5ggN4s5JC1Hj8AmOeXZ5rt6SoDB0iIoDMaTCi0v0i0vLHrCWiqw+mFZBf17TxCgKE3D4jPhDeO6skk593vYKzY5s26DVplDoBs0z/mhj+3CMy4ZTC2+QHX8mgIyTkWPVOfdByAzGhAbr+9CFEmIJ5NovMvUA5EGsRvSjG/U=
Received: from DM6PR15MB4090.namprd15.prod.outlook.com (2603:10b6:5:c2::18) by
 DM6PR15MB3196.namprd15.prod.outlook.com (2603:10b6:5:172::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2937.22; Thu, 30 Apr 2020 07:02:17 +0000
Received: from DM6PR15MB4090.namprd15.prod.outlook.com
 ([fe80::f802:39e2:ef5:ff91]) by DM6PR15MB4090.namprd15.prod.outlook.com
 ([fe80::f802:39e2:ef5:ff91%6]) with mapi id 15.20.2937.028; Thu, 30 Apr 2020
 07:02:17 +0000
Subject: Re: [PATCH v8 bpf-next 3/3] bpf: add selftest for BPF_ENABLE_STATS
To:     Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
References: <20200429064543.634465-1-songliubraving@fb.com>
 <20200429064543.634465-4-songliubraving@fb.com>
 <CAEf4BzZNbBhfS0Hxmn6Fu5+-SzxObS0w9KhMSrLz23inWVSuYQ@mail.gmail.com>
 <C9DC5EF9-0DEE-4952-B7CA-64153C8D8850@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <222fc0f5-2073-2f2d-2079-b564f12287b8@fb.com>
Date:   Thu, 30 Apr 2020 00:02:13 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <C9DC5EF9-0DEE-4952-B7CA-64153C8D8850@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CO1PR15CA0074.namprd15.prod.outlook.com
 (2603:10b6:101:20::18) To DM6PR15MB4090.namprd15.prod.outlook.com
 (2603:10b6:5:c2::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:8d6a) by CO1PR15CA0074.namprd15.prod.outlook.com (2603:10b6:101:20::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Thu, 30 Apr 2020 07:02:15 +0000
X-Originating-IP: [2620:10d:c090:400::5:8d6a]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 691c7a3e-ffc7-4435-5620-08d7ecd46ad1
X-MS-TrafficTypeDiagnostic: DM6PR15MB3196:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR15MB3196E6FD1511CC6446A19A89D3AA0@DM6PR15MB3196.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0389EDA07F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR15MB4090.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(346002)(376002)(39860400002)(396003)(136003)(2616005)(8936002)(2906002)(8676002)(186003)(6512007)(16526019)(36756003)(478600001)(316002)(110136005)(54906003)(52116002)(6506007)(53546011)(31686004)(4326008)(31696002)(6486002)(86362001)(66476007)(66946007)(66556008)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ra89UzYMOWPFBOZFQK42VNy8ST50SN9ybJv4oAoV6AHZ43xxATvYdFYDaQBx5CYbXSkw+AaMmujwvRNGsyhv0IHrI08ACz+Z2+fSf99a8cG7cWGj6I1ckeQnEV9JaRZKQZj4XRi21Hy8tSGM+SvmwGbMfnm7acb1OYrfm1eKS+tzV2wahiPz9hK4O54VZgJxCv7s3y9MSVQhQ0L6cNwVM4H1kkUaCQL1h3q1D/Y+ZQ00wvJOC74qvGDRFsq2BxVNKpumSYZFj0ja1sFJyJvboqaZhVglDIusPSXnHxLbO6YHNGGZf471NACrN8Lon/J1C9AK6ZHYWZks588OhPV/HK7axeyS+IWOWjde/45d1Y43Auh5PkNeqv1iVfkMm52snwtHu8HaQrLmuhvmYacnE0T1Pt5ryQGsb5UyIIPGZDjG+UknOXNQFRfafl0Ygzfc
X-MS-Exchange-AntiSpam-MessageData: OW8JO0NKWLG7DYdLX/C+zh2va3kijhY3q8MMvd4FxZK3duGrCE5EQFWNxgTqBbGa7nHTJ9TXUXU/DOZNss0swpaGyAQWTfoUTaM9Mmqeu2IL9TeRAVRUwU7rkTyxDAH1SRMzI8HpWnTaNUnjYdr7WEXwZkPvqpr23N8SNzQgHasDaerbxSIt9A9e83iIpwPzTJXXNGL0CYLDvuU0uf7B7mi93WPfsDrGpocyMsTUTy60CEU5CcYxjCepgPu8I2BAzxjcrfmoiYh4W2y6b/boloBOnP1dCVsE+JPrlVvpqcyM5QcuX2VIBcC48ApwMVY9NXO9HpMGfO2M8kZ9bMhLdLb9BUewMR9/y4hBH8xOYLHXmv7e+eLMIZl8a4lnC37nNawMHPAAiLM/PgBwK2qTzfOT12Ho/dTy1COkRmojuJM+2vB6+gHd3r2md4hiwSyoZRbIbDS4Ec7rqlnCwm893Gx1RP3eXE4mvxrNVX3vNlyZprZSl0+871XKwqc/EKEdkZ0a2eUK0XWBFLDsA+rVhv7/vlidxZbdilRetdrIVUczS8hZ1o+K2843sitSD7K+2U315zjZFuhYQiVrPOfXb8x3sEGfur2sLT8CYqGNjFrSM0bvwbSqKoJ92hTF2hg5G+gcHJz7jtgLWXhSSvbgZ+wVp0zmxtuEPTlBXaau9vpbYZmNQtn4rY15OJRbVlZvl+hPzHWPVd5p5ZerWgbKe2vjRcoli0pXmPk6G2duvFQ4dfdMOk6NkSCIRVMjOR7MPvrdeS+u5x6h5N3Ro55Di9J5WXrDMOI4TZryrwNrMfUpb8oVRKRLGcMQOsnsqz0esiTzxb+OX+hHunTO85Sf2Q==
X-MS-Exchange-CrossTenant-Network-Message-Id: 691c7a3e-ffc7-4435-5620-08d7ecd46ad1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 07:02:17.0247
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y2rHZKOEKhYvn5N9+bC8rWC4u976i7i8CQ+CaRvzvkwh6M/8IKoXr2SvasX6CmXp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3196
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-30_02:2020-04-30,2020-04-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 impostorscore=0 lowpriorityscore=0 suspectscore=0 priorityscore=1501
 mlxlogscore=999 malwarescore=0 phishscore=0 mlxscore=0 adultscore=0
 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300056
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/29/20 10:12 PM, Song Liu wrote:
> 
> 
>> On Apr 29, 2020, at 7:23 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
>>
>> On Tue, Apr 28, 2020 at 11:47 PM Song Liu <songliubraving@fb.com> wrote:
>>>
>>> Add test for BPF_ENABLE_STATS, which should enable run_time_ns stats.
>>>
>>> ~/selftests/bpf# ./test_progs -t enable_stats  -v
>>> test_enable_stats:PASS:skel_open_and_load 0 nsec
>>> test_enable_stats:PASS:get_stats_fd 0 nsec
>>> test_enable_stats:PASS:attach_raw_tp 0 nsec
>>> test_enable_stats:PASS:get_prog_info 0 nsec
>>> test_enable_stats:PASS:check_stats_enabled 0 nsec
>>> test_enable_stats:PASS:check_run_cnt_valid 0 nsec
>>> Summary: 1/0 PASSED, 0 SKIPPED, 0 FAILED
>>>
>>> Signed-off-by: Song Liu <songliubraving@fb.com>
>>> ---
>>> .../selftests/bpf/prog_tests/enable_stats.c   | 46 +++++++++++++++++++
>>> .../selftests/bpf/progs/test_enable_stats.c   | 18 ++++++++
>>> 2 files changed, 64 insertions(+)
>>> create mode 100644 tools/testing/selftests/bpf/prog_tests/enable_stats.c
>>> create mode 100644 tools/testing/selftests/bpf/progs/test_enable_stats.c
>>>
>>> diff --git a/tools/testing/selftests/bpf/prog_tests/enable_stats.c b/tools/testing/selftests/bpf/prog_tests/enable_stats.c
>>> new file mode 100644
>>> index 000000000000..cb5e34dcfd42
>>> --- /dev/null
>>> +++ b/tools/testing/selftests/bpf/prog_tests/enable_stats.c
>>> @@ -0,0 +1,46 @@
>>> +// SPDX-License-Identifier: GPL-2.0
>>> +#include <test_progs.h>
>>> +#include <sys/mman.h>
>>
>> is this header used for anything?
> 
> Not really, will remove it.
> 
>>
>>> +#include "test_enable_stats.skel.h"
>>> +
>>> +void test_enable_stats(void)
>>> +{
>>
>> [...]
>>
>>> +
>>> +char _license[] SEC("license") = "GPL";
>>> +
>>> +static __u64 count;
>>
>> this is actually very unreliable, because compiler might decide to
>> just remove this variable. It should be either `static volatile`, or
>> better use zero-initialized global variable:
>>
>> __u64 count = 0;
> 
> Why would compile remove it? Is it because "static" or "no initialized?
> Would "__u64 count;" work?

It is because of "static". This static variable has file scope and the
compiler COULD remove count+=1 since it does not have any other effect
other than incrementting itself and nobody uses it.

> 
> For "__u64 count = 0;", checkpatch.pl generates an error:
> 
> ERROR: do not initialise globals to 0
> #92: FILE: tools/testing/selftests/bpf/progs/test_enable_stats.c:11:
> +__u64 count = 0;

I think this is okay.

For llvm10, you have to use `__u64 count = 0`.
For llvm11, you can use "__u64 count", the compiler changed global 
"common" variable treatment default from as a "common" var
to as a "bss" var.

In selftest, we have numerous cases for `__u64 count = 0` style
definitions and I recommend to use it as well since probably
quite some people uses llvm10 to compile/run selftests.

> 
> Thanks,
> Song
> 
