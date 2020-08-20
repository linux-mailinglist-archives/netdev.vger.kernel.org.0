Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF9224C0E9
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 16:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728122AbgHTOuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 10:50:00 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:42432 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726885AbgHTOtk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 10:49:40 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07KEkDj8012255;
        Thu, 20 Aug 2020 07:49:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=N2JYciGo3stDKphKVw7wGi1y0bjU92X5HW8zClleyAc=;
 b=q4J1QYtrkw0uydnVFRM9GNhK9/3qhOrPusD7JsTS+jlkmbH+o8Zn+L1sIgSoKsjo1riJ
 v4qaeVukQndGV1t//u8B4QqkiMwTiTDndMzLUGERZDGnpMFSx0XASIGqgqAey5xUPCuz
 078owbax8Fp+/3cjhrv2UwWEqCz51Na7xrU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3304nxxgfw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 20 Aug 2020 07:49:21 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 20 Aug 2020 07:49:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HjxTyDlzD9MXyZXnHVqJOW+/pRgOEEIZtn4X2CsvdyWbOqSboN8Ay5n+BA7r8M1w4CineLXzZLoe2/60yR10Z48SEiGh04NZMMhrs5he7NZQ2l1Y/tbYoFNsdhA3eD8HFa0ZDcWhUYyy20QgShD7vVdiOCKVaaEn3+Ma7k7x3OCTMpCRU2nUMZ+BUpv1jRYdcMWMN7qkA1xQj5aIcQqc0xbLMorqCao9Q+fQ9ZIgtAz7EPvgJ9sTRnhRg/NcmvLcCOk8lFsNeoOE5nMpoTrsb6tcCAf8wWxYML092NJkgEVUmHEycNJUHIyw0VoHkrX5pRe1E5LUAwjWObLt/Dxrbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N2JYciGo3stDKphKVw7wGi1y0bjU92X5HW8zClleyAc=;
 b=OHrX+xAuYguWBPrK2e2G5PrYRGRYyeUZSMOWyMuvZSdRK+kp8U9rdr5hEFwpLRDUMv3P9n53Ysrfg9R945v5vtopoBZbIcITEG132/tQVKwQjGJoCWAgKp2csmN4BJOLBO2Kwj+mD8zuuW5+ROv6e78g3Dm5yLzqBCQG3eCx1RHygSjIY5aifgIeWQsuvWUUXX2cUjkxk9DdA/0Yp4YGdoBbRgJxupU/gZlPt4QmwV3gHDlbdD/B7x6mBDv1QcuwiTa/+vXpwqHktgRJCECz58qlXSE1CnzMyyHd0FDWGNQK7X64vEzaAIWbnB/k2NRXO9T8QVzEa6yJIyH4ZC+Gsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N2JYciGo3stDKphKVw7wGi1y0bjU92X5HW8zClleyAc=;
 b=a0ITvzthAnk+5mbBPVIffzLfsZ3uijfbcgc76C3B+PXeLh9OFwyFNvsoXhIdIDwh2rMNlQurWMyYHnYmROyIfw1hXoJflmWLdRIeESZmgQDvX/xzt3Cd3+pla7yLwLO+lJhrn25/Xvczy46QIILBd8LHb1zDHSqnfpFALx3ZWCI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2695.namprd15.prod.outlook.com (2603:10b6:a03:150::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Thu, 20 Aug
 2020 14:49:19 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3305.026; Thu, 20 Aug 2020
 14:49:19 +0000
Subject: Re: [PATCH bpf-next 6/6] selftests: bpf: test sockmap update from BPF
To:     Lorenz Bauer <lmb@cloudflare.com>
CC:     Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team <kernel-team@cloudflare.com>,
        LKML <linux-kernel@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <20200819092436.58232-1-lmb@cloudflare.com>
 <20200819092436.58232-7-lmb@cloudflare.com>
 <1ad29823-1925-01ee-f042-20b422a62a73@fb.com>
 <CACAyw9-ORs29Gt0c02qsco9ah_h88OqQh5cq36SpDCD19x89uw@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <582e57e2-58e6-8a37-7dbc-67a2a1db7ecb@fb.com>
Date:   Thu, 20 Aug 2020 07:49:14 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <CACAyw9-ORs29Gt0c02qsco9ah_h88OqQh5cq36SpDCD19x89uw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR06CA0001.namprd06.prod.outlook.com
 (2603:10b6:208:23d::6) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by MN2PR06CA0001.namprd06.prod.outlook.com (2603:10b6:208:23d::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend Transport; Thu, 20 Aug 2020 14:49:16 +0000
X-Originating-IP: [2620:10d:c091:480::1:7ec1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60fc5185-03ce-4398-e1b3-08d8451837a1
X-MS-TrafficTypeDiagnostic: BYAPR15MB2695:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2695E2E59F06E3F87C34B16BD35A0@BYAPR15MB2695.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:257;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nVsqDQ5iPuDYQc/jwoGTFTDO1S27gJOJaHoKtjGQ3jIGZso3ek21ZBhVQQha8EY3BzB5LNSPbpFI/4vteQDEDLe85o5IQ9FQeT3m2XqVxfe26djWZ6+79Lutyi5+ueRRsFgIq+JVZD5T7rOOZZVbp4XHrBWvcCNzfh2Qe0nDkDZUj7LaHsGg98IJb/Je7lKExTyXqmFu+hCpJqJjdqr3LkK57h/prNe4Qlqp5dzY57ThDhuUNnttT+ADNDhh9eDF0OgbtDUw3mGJHTBtuj3nTNZmsOJjznajUJEaA29fldpmfSn8/iuv42+q14Rh+CNJEuSpNfUB27ZiiwhawtNhAgtzLfJtJ7ZjIwSn0AQGPKcuHPVnblzW3UH+PlvCa7Jje/JdR7o8Jpq7gWD6giaXxk52GbbyD+um+erjL4z1JAU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(396003)(376002)(346002)(39860400002)(2906002)(86362001)(186003)(52116002)(54906003)(316002)(36756003)(5660300002)(16576012)(6916009)(110011004)(956004)(31696002)(53546011)(2616005)(66946007)(8676002)(66556008)(66476007)(8936002)(31686004)(478600001)(4326008)(6486002)(7416002)(83380400001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: vSMGNQsY3x8/ubSqS2mGpy4Obp6hbcO9DXa59L7Yk5eZCMXfciAtd6eJVritLoUyOvwqigtJgAc/Vl+VbyQUvb8RcuSG4a3Et+cGWIha/OSxWd7dzU1Vql0HbO/j5JKnFdS3rS+urSYHPQxvtxz6op2U7pl6Xpg3y3ex/cwVFb60/XmGdJI/EJNjno3D3b8iIo9pTUlXmjXHl3G5CIW/UaGSabZA/9r1MSCSw3vG0DjRHJkyF1r02ZoikX2X70iO0qCpJzfPEiDUhVqwrdcfDcbLN7ajXAsYdI/ObbaHeSd/ax1buHFyfObtaKI66dPbWRMIkSvngVNWONuy2YWHi2ljLL748wTV7GY8hGd01I9wF32jHeW5RlRKtixoIIQRkmNeCutgksVFkAD/y5xLLTMG/ADZgSuwPl7yaiGLXO/OuHPO2xwILqbn73zqBuoqtaaP+BhiyCo7By3NAOqwt7pSsSII/pnqHv9wpJV86uUbsHyM8Pka4sYdeXeoZendd1xTyBtXlECfMIW4MVFhj710HybZRrEF7L9jzjxvYzdc2wHOeOtorb2RJQiA3WgRMt4FbHNTk7wIOhz/IZxM6HE2Sd2evZ1/rb95kFHf58rN4N83UTIGLecpbPBrtzLyWK4M76Kw2ata8Aa8+6S7zZICqpENjW0Bbu8z7bGzWXQUfdR/6+Z0wHtI//1ggGZy
X-MS-Exchange-CrossTenant-Network-Message-Id: 60fc5185-03ce-4398-e1b3-08d8451837a1
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2020 14:49:18.9711
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pamo3EOtw0EmFwvbWr6x+hudulvzRr6NflH4rgkYn8YA/+c7ZlDogHvgtMx90dQr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2695
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-20_03:2020-08-19,2020-08-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 impostorscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 clxscore=1015
 priorityscore=1501 malwarescore=0 lowpriorityscore=0 suspectscore=0
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008200123
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/20/20 4:58 AM, Lorenz Bauer wrote:
> On Wed, 19 Aug 2020 at 21:46, Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 8/19/20 2:24 AM, Lorenz Bauer wrote:
>>> Add a test which copies a socket from a sockmap into another sockmap
>>> or sockhash. This excercises bpf_map_update_elem support from BPF
>>> context. Compare the socket cookies from source and destination to
>>> ensure that the copy succeeded.
>>>
>>> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
>>> ---
>>>    .../selftests/bpf/prog_tests/sockmap_basic.c  | 76 +++++++++++++++++++
>>>    .../selftests/bpf/progs/test_sockmap_copy.c   | 48 ++++++++++++
>>>    2 files changed, 124 insertions(+)
>>>    create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_copy.c
>>>
>>> diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
>>> index 96e7b7f84c65..d30cabc00e9e 100644
>>> --- a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
>>> +++ b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
>>> @@ -4,6 +4,7 @@
>>>
>>>    #include "test_progs.h"
>>>    #include "test_skmsg_load_helpers.skel.h"
>>> +#include "test_sockmap_copy.skel.h"
>>>
>>>    #define TCP_REPAIR          19      /* TCP sock is under repair right now */
>>>
>>> @@ -101,6 +102,77 @@ static void test_skmsg_helpers(enum bpf_map_type map_type)
>>>        test_skmsg_load_helpers__destroy(skel);
>>>    }
>>>
>>> +static void test_sockmap_copy(enum bpf_map_type map_type)
>>> +{
>>> +     struct bpf_prog_test_run_attr attr;
>>> +     struct test_sockmap_copy *skel;
>>> +     __u64 src_cookie, dst_cookie;
>>> +     int err, prog, s, src, dst;
>>> +     const __u32 zero = 0;
>>> +     char dummy[14] = {0};
>>> +
>>> +     s = connected_socket_v4();
>>
>> Maybe change variable name to "sk" for better clarity?
> 
> Yup!
> 
>>
>>> +     if (CHECK_FAIL(s == -1))
>>> +             return;
>>> +
>>> +     skel = test_sockmap_copy__open_and_load();
>>> +     if (CHECK_FAIL(!skel)) {
>>> +             close(s);
>>> +             perror("test_sockmap_copy__open_and_load");
>>> +             return;
>>> +     }
>>
>> Could you use CHECK instead of CHECK_FAIL?
>> With CHECK, you can print additional information without perror.
> 
> I avoid CHECK because it requires `duration`, which doesn't make sense
> for most things that I call CHECK_FAIL on here. So either it outputs 0
> nsec (which is bogus) or it outputs the value from the last
> bpf_prog_test_run call (which is also bogus). How do other tests
> handle this? Just ignore it?

Just ignore it. You can define a static variable duration in the 
beginning of file and then use CHECK in the rest of file.

> 
>>
>>
>>> +
>>> +     prog = bpf_program__fd(skel->progs.copy_sock_map);
>>> +     src = bpf_map__fd(skel->maps.src);
>>> +     if (map_type == BPF_MAP_TYPE_SOCKMAP)
>>> +             dst = bpf_map__fd(skel->maps.dst_sock_map);
>>> +     else
>>> +             dst = bpf_map__fd(skel->maps.dst_sock_hash);
>>> +
[...]
