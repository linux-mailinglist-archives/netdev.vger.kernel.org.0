Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52F282F4390
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 06:19:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725801AbhAMFSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 00:18:47 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:51846 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725372AbhAMFSq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 00:18:46 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10D59Gc0032296;
        Tue, 12 Jan 2021 21:17:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=xDvrfTCnYiGKuK7h8f6+f7n6IskAnajTDMXAeZ1A+Ps=;
 b=nOqiq8hAJtrTfRAHTa8K+yimphHhVPp/ZuhW+Z2X+A/E4Mh4IiSadPTbkDP0N75g+U20
 gN/QpVO3f9Keo2ixPA2fJk53JuA2t0/vuAAFprgslMIGRqTivNRm7/Vvf/ttgMkFoPCO
 BZhHATAi0h2IT1pCC426ginA6+SsJfbWBYE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 361fp53d5y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 12 Jan 2021 21:17:49 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 12 Jan 2021 21:17:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ra+y5+yVS5C2gfS2GDqdcT7S7oGptMMkTAucyPRT1NXSOi5xgFCVcobUc5Mrmxg0CmQYDPbSuTyRmYWUGyl+Fg3npGKH1zMdJCsMftvjdgUz96w7YqXO3E7kC4bUrEpkPfaNgnjZ1jNn9YnjcB8/Hvp/Zn+mpPsjZOQkSYH6uOfY/GQEWWNWNktS5bndmoTte0Wmm7WXAXi/mWl1B/wNhmo0efxhooM18OAG6B6OKJ6Jp27+RWVyFkJpDkNqAvoDz1Qglz3jU69frLYnV7hHjUs1E9wb+hwNDYAOmYlvPiw83lNryUHq7z6XXsrVsHTtECqWAPyGS7O1bmHQLAdk4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xDvrfTCnYiGKuK7h8f6+f7n6IskAnajTDMXAeZ1A+Ps=;
 b=MHeakjaErDoUvZaD5Ti0x4J8DB2UE4azliOK3WFw/Y5HhN0ES47azXPIXXl+CKefqVYNFrEkW5hN5fN2vKZasaRPoW4XtviD1h4K308q8+6H+JW/ayFkwZjBR1DPwQAqpvUzmpQfOCPDQ/V0bx/dJbAIFvCCavMlNDnJX7+yZU/xO75uysZ4qqZpJtIMQK/gni4FALuLoC2omfRYouHonldEGXEPlQukgE2YMCRaYN+ptHdi02ZWgdrK42mB3MhVHS9jaBao3WuimykLJk17y3sd41zzBvQbpw9mzYVI8wZWRwZfa8GQp9Dy3yx435FeE+wYf6PIqZFQH2YPtfrKCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xDvrfTCnYiGKuK7h8f6+f7n6IskAnajTDMXAeZ1A+Ps=;
 b=Joxj4GWUPEWf+2jD9IjHBrVm3B6KtktvxXFPdNJ+5OSmFAWFidLlVvJAfvpZa0D28TpasbXfRUynOsbwnykuUTR5SMD+htHGS5IS3F2EaTyIuXkG0zhYQy6SE7GFKHdtbGT6bIbAAT4ACkCUCa/yxJBZQ2xiY41DCQH7I5DuXhA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2888.namprd15.prod.outlook.com (2603:10b6:a03:b5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Wed, 13 Jan
 2021 05:17:44 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3742.012; Wed, 13 Jan 2021
 05:17:44 +0000
Subject: Re: [PATCH bpf-next] bpf: reject too big ctx_size_in for raw_tp test
 run
To:     Song Liu <songliubraving@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        <kernel-team@fb.com>,
        <syzbot+4f98876664c7337a4ae6@syzkaller.appspotmail.com>,
        <stable@vger.kernel.org>
References: <20210112234254.1906829-1-songliubraving@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <b8b16115-4fba-265f-b0a5-33af02a75bbb@fb.com>
Date:   Tue, 12 Jan 2021 21:17:41 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
In-Reply-To: <20210112234254.1906829-1-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:dfc0]
X-ClientProxiedBy: CO2PR04CA0198.namprd04.prod.outlook.com
 (2603:10b6:104:5::28) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::123d] (2620:10d:c090:400::5:dfc0) by CO2PR04CA0198.namprd04.prod.outlook.com (2603:10b6:104:5::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Wed, 13 Jan 2021 05:17:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8231c3d4-606e-49fe-9ffb-08d8b7828f37
X-MS-TrafficTypeDiagnostic: BYAPR15MB2888:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB28887BE5143C33A0A480B96ED3A90@BYAPR15MB2888.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: leXFQEbSPalJ7m7p3pS3gbQ/IV7rH9CKyx5b485gD1xnJto7I+cniOtBLgqVyROf9xlOSuGdZyk5IWpznoKFYxpColVS8ld8vlRvXCugJWgENgNQKoKTfk6GBj06APUNoR/kumq1ori/54Qy6aN+lng7Mq/7DDVZBR6fuh081mwIDkKLQaX7OwqQO7kvbil/HAxyXQxEbOINobjnp+UFn/q3JkcWlPkLBT/RvSga2Oas8kPWN+dVffE4RAaW+EYol6j6st5RVTnvQlbsDthyk1xJmgqK3F9itLVR8owBxr4ruJ0ohBD92I98qLDTN1gpvYyO0iU6uX0SXnj2brnh/rmSQDBzZoTRux8ccgcs6yfp1ZKyMfhQUa5PEPOYHrPWo/CcXsjmwgX+jz1fZfwUbYB2UpGvClqR0KKXEelLOrQmgtCP8p+GokN0Htzo1MfkpSq9+3ikkNcdg1p9SUqQRaL6uNiosG8V4/cZeCAxsX4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(376002)(346002)(136003)(366004)(4326008)(8936002)(5660300002)(16526019)(36756003)(2616005)(52116002)(86362001)(2906002)(186003)(45080400002)(53546011)(478600001)(31696002)(31686004)(66556008)(66946007)(316002)(83380400001)(6486002)(8676002)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VnFNb3k4TkNCeXhERG9xSnZ1RGk5YmNtY3lqaUFoMUl6enJna002WnVVZWd5?=
 =?utf-8?B?TTZ2SEp0aG9hMkM0NEJ1T3RuTFZ2NkVmbVBxQklIZ1EybmFVUVBYbUgrVTZp?=
 =?utf-8?B?OFhDZkNzenBmR2VPVHhZU0M5aElXai9hZDhQMk8wMVZBMUVyaW5kRVZJQWF4?=
 =?utf-8?B?VkdraUx2aGRrbzlIcjN0V0FiaCsvVDJHbFp2bkhXREpBL3FOTVJHOGV5b2ZG?=
 =?utf-8?B?TjcxT0JQVklnMVQ5U050VlRYMUFjRXdVaFhtbUR4MGtqNTJPLzIxNE1OaXlD?=
 =?utf-8?B?L0R4Tjh4azV2OGhhM0dKSWw2b2pJeGZ4RC9ZNmR6dDhzdk1TVUVXMElHcHg1?=
 =?utf-8?B?TjEwTEQyZ2h0SExySi9yS1FBV1l4SlZialhJMDZSSWN0UDBjVE50VEQvbzUv?=
 =?utf-8?B?WUtqN2xrWlp4cHNPbzdQSW1BLy9vekZWVDk2RTFtU2xleHgyd0RqRXU5c0tB?=
 =?utf-8?B?SGYrMEtaSzFCcWtBNzNEdzBhSWs2SUduS0hnRUNIa0hSUUF4eUhDNnpidzA5?=
 =?utf-8?B?RUtvVkdSR3JYc0lPME5lS05ya0hWY2lHc2NST3hxYkcxMmtwODFtSmZxL1hX?=
 =?utf-8?B?c2pMSlYxZmRqejIwdW1TUjkydkcvTCtPTHlJMlkvUklMMjh5SWUwbkJBR0lK?=
 =?utf-8?B?WmIvZTVJYkw3dWk4cXBTaE5tVGlVRjNFTlVrVzFUMEUyQW0yOFNWTkRqUVNY?=
 =?utf-8?B?QkRlaVRuNUh5ZVNTby9YT2VpaGRoNlhXY2FsMkxaMEtLeHR1NFBUaXczVWI1?=
 =?utf-8?B?dHNta09VUXJNTm1YRlU5SVpyNHBUV3BTMzB6MTZ6ZUpaUko4d2VCTGJOdllP?=
 =?utf-8?B?eW03NytIaHlINUN0OVl0eHhVU08wOHpWNWpwN2s5NmNrYjF6aW5ERDJ0RXY0?=
 =?utf-8?B?OXRRNUZSLzRpK20raVVmaHo3azhPb3NOVVJlM3F5c0thVlZEZ1NvekE4M1la?=
 =?utf-8?B?cnUyUDFxcTVvWEJOTHJYeU1ucHYxdmpzUUtHckxPeWZYQnphSkY3c2ZRK3Fs?=
 =?utf-8?B?NHBJMTM1Y3NzSTNFS3RtVjlSTWdEOWxuSU05ZTRkRmdVSDVFRUJZSWM2aHZ2?=
 =?utf-8?B?R2ZkcVpkU25zV2VqNytqamRTMUkzLzBHRksxbnk2c2I0SWZsa1owVmdUeFVI?=
 =?utf-8?B?VytJRmNQdE9LS3FsbGxPR2o4Q0pSbUxGZlpzdXljWkRPeHhUcTI4RW1WYjFW?=
 =?utf-8?B?ekFOMXV1c0w4WWQ4Sko2WGlUQWFnUkYzOURtWnZhdWRWbVRlUVJKNCszZkdW?=
 =?utf-8?B?Z045ODE0ZDd5bG5wS2RkRDVIUmVUVEh1eklvMEkvOU84Z1FsV1dJenJUVG1P?=
 =?utf-8?B?dWk5NS92TjIxc3pvWGtwUlJYaWdVcXo5SHJhYW9TQ1FUeG1ySzllVFZ0Um41?=
 =?utf-8?B?VFJXNXZGL0hSM0E9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2021 05:17:44.7874
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 8231c3d4-606e-49fe-9ffb-08d8b7828f37
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n6E2sW1Ilzspq35tPpYkiQZYFJRLlBKqbqmJI/A3wy6VNGO1s222P1+4Nn5QZYdI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2888
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-13_02:2021-01-12,2021-01-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1011
 priorityscore=1501 mlxscore=0 phishscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 adultscore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101130030
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/12/21 3:42 PM, Song Liu wrote:
> syzbot reported a WARNING for allocating too big memory:
> 
> WARNING: CPU: 1 PID: 8484 at mm/page_alloc.c:4976 __alloc_pages_nodemask+0x5f8/0x730 mm/page_alloc.c:5011
> Modules linked in:
> CPU: 1 PID: 8484 Comm: syz-executor862 Not tainted 5.11.0-rc2-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:__alloc_pages_nodemask+0x5f8/0x730 mm/page_alloc.c:4976
> Code: 00 00 0c 00 0f 85 a7 00 00 00 8b 3c 24 4c 89 f2 44 89 e6 c6 44 24 70 00 48 89 6c 24 58 e8 d0 d7 ff ff 49 89 c5 e9 ea fc ff ff <0f> 0b e9 b5 fd ff ff 89 74 24 14 4c 89 4c 24 08 4c 89 74 24 18 e8
> RSP: 0018:ffffc900012efb10 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: 1ffff9200025df66 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: dffffc0000000000 RDI: 0000000000140dc0
> RBP: 0000000000140dc0 R08: 0000000000000000 R09: 0000000000000000
> R10: ffffffff81b1f7e1 R11: 0000000000000000 R12: 0000000000000014
> R13: 0000000000000014 R14: 0000000000000000 R15: 0000000000000000
> FS:  000000000190c880(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f08b7f316c0 CR3: 0000000012073000 CR4: 00000000001506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
> alloc_pages_current+0x18c/0x2a0 mm/mempolicy.c:2267
> alloc_pages include/linux/gfp.h:547 [inline]
> kmalloc_order+0x2e/0xb0 mm/slab_common.c:837
> kmalloc_order_trace+0x14/0x120 mm/slab_common.c:853
> kmalloc include/linux/slab.h:557 [inline]
> kzalloc include/linux/slab.h:682 [inline]
> bpf_prog_test_run_raw_tp+0x4b5/0x670 net/bpf/test_run.c:282
> bpf_prog_test_run kernel/bpf/syscall.c:3120 [inline]
> __do_sys_bpf+0x1ea9/0x4f10 kernel/bpf/syscall.c:4398
> do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
> entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x440499
> Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007ffe1f3bfb18 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440499
> RDX: 0000000000000048 RSI: 0000000020000600 RDI: 000000000000000a
> RBP: 00000000006ca018 R08: 0000000000000000 R09: 00000000004002c8
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401ca0
> R13: 0000000000401d30 R14: 0000000000000000 R15: 0000000000000000
> 
> This is because we didn't filter out too big ctx_size_in. Fix it by
> rejecting ctx_size_in that are bigger than MAX_BPF_FUNC_ARGS (12) u64
> numbers.
> 
> Reported-by: syzbot+4f98876664c7337a4ae6@syzkaller.appspotmail.com
> Fixes: 1b4d60ec162f ("bpf: Enable BPF_PROG_TEST_RUN for raw_tracepoint")
> Cc: stable@vger.kernel.org # v5.10+
> Signed-off-by: Song Liu <songliubraving@fb.com>

Maybe this should target to bpf tree?

Acked-by: Yonghong Song <yhs@fb.com>
