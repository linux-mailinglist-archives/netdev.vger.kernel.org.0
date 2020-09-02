Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9513125A2F8
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 04:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726244AbgIBCT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 22:19:29 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:17060 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726140AbgIBCT1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 22:19:27 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0822JDG5020029;
        Tue, 1 Sep 2020 19:19:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=5ajqrYSjhRL19cqLWzHluLNcPK+J+R4Ii32A4okhZMc=;
 b=HhbhBrvSj+HppVBQQCGj5FWm8GxdDNb2bABn1hghhQzj3jUOrEJNwwemBLMaMvcFB7kW
 1gc++NKoJFHk5oGyN1iCS+us7rBPEUzS6B1/jfommi8MB13DwKWXU5EVw57A23tEZYBb
 TzIivutoTaLBqlY1vFmbCYcye0a0zWlYAV0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3386ukpke5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 01 Sep 2020 19:19:13 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 1 Sep 2020 19:18:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DZbdIpTg5mVSVBf/M/bH2AWpBrwqb4eHP3yZVQfKjLxaPygVDR+JBm3YbEovUQpoX5e9AUawcgkSAQt79sqDXkaTgHg92BojITV3cL9FTbWdxAnZrSWTiyK/hLWNtkOp3t25gDqWSkPLUGz1yJY/jW8oYuL1+O4J3g0bU+WixjU77L3Dp2OBbmMcDwoLzsuwsvtzmomR6fpu0upp8APFbL4V4X2kXjNz9TRZmYRZeOZ3zRteMtVAXnYAsukhio/gKjz6swtRAWEIKA2zHojgQANun3OneJakxYmTVnu0ZMOzE5ChyvwCFl3JBnQAspivXzMb21DJNPX+8+i7hkl6zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ajqrYSjhRL19cqLWzHluLNcPK+J+R4Ii32A4okhZMc=;
 b=YcuK9ZdSHEa3TNmsxlv3AcPZ4sxcpHD2u39xViDiE5F3ki1I8eIFFTIAbAA6/lxs0P69yzEA7Lon+BNSPTKKtN78Rt141NeXxXhwWrgmF4i8eEZoM5AY6fmkrr4xMkTSe1bDBmRTskXufGqXmZJzplAhyTR0lEWF2SmxoxHR8TqYUWPJpuUbxEMRlDwpZqVMp2K1xgjTQf4Atwms7s7GOeM7jprILVumEjSEnlyB68KLUamdT1nrJWmOQlMkZRmY96INoynvgSC1gy/xSsvsgpsEQzzCpFlHmnkFV2sKeRVgaG2pSUivD+77lqqPQkxlujavJWtdpOAbqIA6KYMqqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ajqrYSjhRL19cqLWzHluLNcPK+J+R4Ii32A4okhZMc=;
 b=Sn5u7aN/KrM0DqieMvN36cEtFZ1vQijcOtT2yOsXq2zoeGK9RjXNJzvBHsGVBMPOONgkRGizRqQARKQyAYChhQBYSZtE7+oB7UddFbIxzcNuuZOd37di+9JSJjyPrrP/1maZplTSuc/9lm8YrjV/GMTL1my8W32nWGlop4CXfEU=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB4120.namprd15.prod.outlook.com (2603:10b6:a02:c4::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.25; Wed, 2 Sep
 2020 02:18:56 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3348.015; Wed, 2 Sep 2020
 02:18:56 +0000
Subject: Re: [PATCH bpf-next v2 2/2] selftests/bpf: test task_file iterator
 without visiting pthreads
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20200828053815.817726-1-yhs@fb.com>
 <20200828053817.817890-1-yhs@fb.com>
 <CAEf4BzbQboQ3uPmXG2HAsv2=S3iJ5-6RQiC8Z8OymnCCyMJ77A@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <3633b57b-dd3e-9cd0-e740-0df2b42458ab@fb.com>
Date:   Tue, 1 Sep 2020 19:18:55 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
In-Reply-To: <CAEf4BzbQboQ3uPmXG2HAsv2=S3iJ5-6RQiC8Z8OymnCCyMJ77A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0011.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::24) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by BYAPR06CA0011.namprd06.prod.outlook.com (2603:10b6:a03:d4::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15 via Frontend Transport; Wed, 2 Sep 2020 02:18:56 +0000
X-Originating-IP: [2620:10d:c090:400::5:365a]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 80af7fa8-dd34-45a2-39a7-08d84ee68b89
X-MS-TrafficTypeDiagnostic: BYAPR15MB4120:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB412001483F397C5929F98BE3D32F0@BYAPR15MB4120.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B03lRWrMCnibwvsMRnAwB9/9Z3tUrjPqUml0UNiJiMf1jZh2iN7+UosnmrojUNK0rXMWrxKWbGQoykCE1MWnyec7Fj8Blpd4xODYrwjM5PyzG/YS+o1CieGt3FZLhacG5D0K2mdz20NDhyR6J759jhIQLCQHtnIKEwfkaFQDcdJs1dvygPCQFrUg8exV9+JneGiSWE8J0GlGCFvrETaW8fqcC0E7ykjsYHS55RxHlXH9hdFpQWgPlsrtvtC2f7ZBkrHt+nbM4HN60C/bAYnOFnUFDIbzg72EAr9/9RoTI4tixZL/nc7gZuSz7lw9MsmcKFFJ4oRejvtrPKhC2SkLX5FBb8AimWhDX9xwz4LaPIRqU2NtDbRumG7h+hevV2cM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(376002)(396003)(39860400002)(346002)(86362001)(956004)(4326008)(2616005)(36756003)(66556008)(478600001)(6486002)(66476007)(31686004)(5660300002)(16576012)(2906002)(83380400001)(8936002)(53546011)(66946007)(31696002)(52116002)(6916009)(54906003)(186003)(8676002)(316002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: p6drD9tIiR2HswO5Ri7zg8kx0tMUZLtDdN/v5h51HDf7AUkW86t+BUyL4lctteQm3jv0S3b8cT8EWu7A8+6L2ixkgBcvVXktyAsdkbUDS8zXvpDBNsxSIxMP/AyIHBcImF3N3GC2uvn1xytVcfvtGmvyVUwv9SIoqiCirJY7VB8EZ/eqSzlPMOuHxIZJgEUETVOkZW0/BSqrFb9q6jQN8dULLOU9yZUCfGI10jsdttbrhl7dIs/BLGwCX2ExD5JbE1WxeVQYscl/46TwmjIIenMyreAq1Sp0L2M++dmueXBFiFSkaW0R1MjyfGJPzLoRiFRqS4lpwHO/+43T2X5E6A6ICQakz0XHd0FKULqv7eokIJOfFnkTvuGVYGOWSlwP77I3v8Ab/do9z1pjOlma2z9SeF6xiVgvbBNSirN6Ck57g//NECw1uqGm0JyOsQMf5Z2PxgIllb2hQIOIqOoEh992nANl0EMNa0z1kCAN1JLg0Kyp8OxRFd7ocTiuW1s/2tyKp+IzUBW3g0ka+1A8tIz1wTRwRJ5mVGwsdW0OLXdeMyMyIrzaOIhmPaOkUjlJKWXLoqv0rsWlc474Lp3VJ3czPqF2Rh8CaNaItZjND8+tlRcMj8hWMyBj5LBo2cX5AxIx1UmqQHk53OxwTO89zuCo5VTdLiBDIWXfozGWBNI=
X-MS-Exchange-CrossTenant-Network-Message-Id: 80af7fa8-dd34-45a2-39a7-08d84ee68b89
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2020 02:18:56.5394
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EaUzKIJ5VqhYRUCVy7IvxgU6M4Wgedwka1GtbPvEgrIAHihubOAIQzcXzsuBfcEq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4120
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-02_02:2020-09-01,2020-09-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 clxscore=1015
 impostorscore=0 malwarescore=0 bulkscore=0 spamscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009020020
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/1/20 5:41 PM, Andrii Nakryiko wrote:
> On Thu, Aug 27, 2020 at 10:38 PM Yonghong Song <yhs@fb.com> wrote:
>>
>> Modified existing bpf_iter_test_file.c program to check whether
>> all accessed files from the main thread or not.
>>
>> Modified existing bpf_iter_test_file program to check
>> whether all accessed files from the main thread or not.
>>    $ ./test_progs -n 4
>>    ...
>>    #4/7 task_file:OK
>>    ...
>>    #4 bpf_iter:OK
>>    Summary: 1/24 PASSED, 0 SKIPPED, 0 FAILED
>>
>> Signed-off-by: Yonghong Song <yhs@fb.com>
>> ---
> 
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> 
>>   .../selftests/bpf/prog_tests/bpf_iter.c       | 21 +++++++++++++++++++
>>   .../selftests/bpf/progs/bpf_iter_task_file.c  | 10 ++++++++-
>>   2 files changed, 30 insertions(+), 1 deletion(-)
>>
> 
> [...]
> 
>> +       if (CHECK(pthread_join(thread_id, &ret) || ret != NULL,
>> +                 "pthread_join", "pthread_join failed\n"))
>> +               goto done;
>> +
>> +       CHECK(skel->bss->count != 0, "",
> 
> nit: please use non-empty string for second argument

Okay, will change to "check_count" instead of empty string. Thanks!

> 
>> +             "invalid non pthread file visit %d\n", skel->bss->count);
>> +
>> +done:
>>          bpf_iter_task_file__destroy(skel);
>>   }
>>
> 
> [...]
> 
