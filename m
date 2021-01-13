Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C82CF2F5578
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 01:11:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729784AbhANAJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 19:09:17 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48694 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729726AbhANAFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 19:05:47 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10DNJLXR027042;
        Wed, 13 Jan 2021 15:28:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=bK/JzC/fpdnK43sdX24FQdL+Oh3CJPREjOyGCONkMlI=;
 b=TnKtz/28JJKqU/8gvLYJBeZdkcFnObQcgzbrPmLcekqMoFC6GKCNxIdYpO+d8kDZiC8g
 AtLhRxWo9aVPxB0Jez+HV44jFSANgslWrgxzxgNcp050FNRWXEFw7fXW6px0Bv4wnKm2
 KdeoelZqDpS2DriqNdpc6+wX7tQlbY8W4Rw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 361fp582tb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 13 Jan 2021 15:28:41 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 13 Jan 2021 15:28:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EDivmGfM4hZ7pfPC4US+KzpQOP57r8uvvfro55JConwO5BA7krNLBHqS83CO11ancKir32qxBrQKTl9GtanSnPPUHjEGtzCOQYRk4n7glhDxT598mChyxWwUHAJ3FOgD3SRgzgPOXsBtf/UP8i5vKbbSLqPlg19bIzk6BMt+YiPJdWHT3b0gZCXpF33KpXxB7Uer09WRyi6ZxVausSu9iTpdKM4A9xyp/zliL44mR47Oy6/WPYl3mMV/F9mqj6Pa+DR0YBnixuWvnhFOBFj9HwcM1D+BiPPwQcJ2UwkaHaZEGYCYMQHIJpMMeEwkF1QZn6XHmwS/b5BDVep1C3EIGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bK/JzC/fpdnK43sdX24FQdL+Oh3CJPREjOyGCONkMlI=;
 b=BEY/SVzyXuCkrlZt5xd+nO51EX4h2In/dzOJSjjSNdNsHnIQAbAQdw8F/daQwzG9Ve4t77Jhs3NlNS9PeYAgZcipJJIZA/nSam0qsRsnXjH3IFwimOIhZckmkQGyvsGlg7iQ3swrQ4feqwLz00YPJ8M13KkbatnqKcEBa9IUzDu5KYulPcEvFzxzQ0UB7IF7WaFEL5rqcJj94cWvq/QDSqOVcNF2Undh2ZSjpo+ycTfuL5PImr/6FlS25jjO366ZvRhAdcPQGyE8kImFdZ7+HOMI5TsRMIQ4/rIXXibmszAQEXynptiUWjWSoZDbrOImhIht06MLCJ0S/KXsNsqyrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bK/JzC/fpdnK43sdX24FQdL+Oh3CJPREjOyGCONkMlI=;
 b=Efkl7Cwk7Vt+cxgKPnuaBlgAU8fKHHSQiUyCAsPJrdGQ0LDMweBsVODjY5SIkk3+vGnHwxU+E9oldO/3m7lgRCBPJy6siJPcoCiQYGAzZvqWNmIVKK7vqNkIx6cjFDuZl0QoaSg2+Fxg4cCqQqridNlOOcJj0CFpvx3GlmvXzuw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2376.namprd15.prod.outlook.com (2603:10b6:a02:8c::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.11; Wed, 13 Jan
 2021 23:28:36 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3742.012; Wed, 13 Jan 2021
 23:28:36 +0000
Subject: Re: [PATCH bpf-next] bpf: reject too big ctx_size_in for raw_tp test
 run
To:     Song Liu <songliubraving@fb.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Kernel Team <Kernel-team@fb.com>,
        "syzbot+4f98876664c7337a4ae6@syzkaller.appspotmail.com" 
        <syzbot+4f98876664c7337a4ae6@syzkaller.appspotmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20210112234254.1906829-1-songliubraving@fb.com>
 <b8b16115-4fba-265f-b0a5-33af02a75bbb@fb.com>
 <2DAED411-C65F-4BFD-A627-1EED4823168B@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <1d116261-5ef2-eef6-369f-e8e12eaebc6e@fb.com>
Date:   Wed, 13 Jan 2021 15:28:33 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
In-Reply-To: <2DAED411-C65F-4BFD-A627-1EED4823168B@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:bbd5]
X-ClientProxiedBy: MW4PR03CA0088.namprd03.prod.outlook.com
 (2603:10b6:303:b6::33) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e1::13f6] (2620:10d:c090:400::5:bbd5) by MW4PR03CA0088.namprd03.prod.outlook.com (2603:10b6:303:b6::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Wed, 13 Jan 2021 23:28:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2fa76415-bfba-4260-ebe7-08d8b81af344
X-MS-TrafficTypeDiagnostic: BYAPR15MB2376:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2376B963ED4C306FEDCCCBA4D3A90@BYAPR15MB2376.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t1jzxI+cja/vUuw8MVM7plIlNrI88FQwM2xWANhrmQrsUG4n6XQbsid4c5fmrdVY9FGQaPf+oNO2RTxVjnx/NGN77ur/TCZlWZ4L6n3AfXMD8+2SI3QfGx+8DDt5s4fak2KfQd38u3cUgeuDqU7VL5z3OR9E5cZW1BA7kjXKAZaST3q/cuNhT3kWZmWy00b4TXxojgb1kdIjevuYAnnevP56109JpP+n8YuQWwJLLx/EKUcNftU18uN8+3dI3sLn3eDqgtVYUu1bi6UBj4dmIb2TbT2Mpoes782clh0zaaFgmraQCd7nhd2KRy/mfsFnmbS3+aYUiwOP44qEH3Yqlf0Hj2nJioSR+LQAK+/rgfnsYwvgBPkrHeBtRQ4p0Itk248zZcSL0I/U0u0KUTBZsn5XjtoWfzVznZoKeWlRrHxMItnZzXaDNrXCFvsmicF2GBHK64e11PdADDx0hcz2SbsO0bb1RcCFosZIwSlhMY4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(39860400002)(136003)(346002)(396003)(186003)(16526019)(31696002)(2906002)(6862004)(4326008)(2616005)(478600001)(83380400001)(45080400002)(6486002)(53546011)(6636002)(86362001)(66476007)(66556008)(8936002)(31686004)(36756003)(8676002)(316002)(54906003)(52116002)(37006003)(5660300002)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?QVQ5dktReXdTdEhxTjIyQ1UrN3VzMjQzaW4ycnhFRUZhSHAyS0lUbFE3bmIz?=
 =?utf-8?B?aVI2SDBCV1FNS09kSDRTdDBvSUlHN1p0enQxK1JGcnd0OXhQd3BMSXBPcFdO?=
 =?utf-8?B?QUxYcm1wQ1p1VGJmK0hRL2R5TFNpZ2UvNEVQV3ZtWjdsYTU4SkNmKzlpQ1U2?=
 =?utf-8?B?NS9NbjQ1ZHdnSWdPbFpJQUl5djZLaENkRVM5UWhlc21UbVo1ckQwci9nc1h0?=
 =?utf-8?B?SlBTRjlFZjFCamc4Q3A1ZDd0ZldBeUZkQWFiMUx4aDhSVmxFZ1o1QjdiOWI3?=
 =?utf-8?B?OVltUjRIKzk3MENoelc1clNUTHdyMVZUZWMrS0doWlhRWGI0eVkxN3NROThH?=
 =?utf-8?B?cmg4S2w5MlpJdUdRZG9IZW5LbjgzclJKYnFyczh1R1R2ZjdjVVQvR0NqYmpw?=
 =?utf-8?B?Q0NPKzJLWlg0TS84eGhQZGNmQ0tLMFo1c21abDZ3SVYraWdGRVhFMnZPK25n?=
 =?utf-8?B?cWdLaEhSZENlYk90VVp4Z1pReUM3R0YrVmdjVTRrSHhjRS8xRjBpb0VRc1d4?=
 =?utf-8?B?bUFnN3lLdXo2YVBRN2h2TjNxdExuaU9WVWZxcVVFUGJWSTN2ZWtydlBUVnp4?=
 =?utf-8?B?b2MvazJ1L1NrbXltSk9VUXRYeGUyd1d1eDc0Slk5SlM1bVU2dTVnUk5Ubkdx?=
 =?utf-8?B?YzB1aUREbUJOR1g1aFp1amptdWhjbDVRTGpnRmVKcFNoMXB3THJYUVA5Qmsw?=
 =?utf-8?B?NnJYMXlLbFo2N1lPM2cxMU9LWTVmVWJYaEloNGxFYmllSGk1S2tnUEU0emNU?=
 =?utf-8?B?eVZNcWlucERiNmZtak04K3NzL0F0MS9wMEFUMWlOT0JQdVdSUFYrVDQrTHU0?=
 =?utf-8?B?WW1ReEVsSTFhL3JveUo5OUZMeEZ3aFh2TFdSSE5rSEhoWUM0RFFuRVd5TWZj?=
 =?utf-8?B?elQvcHlqbTFqRXk1MGw0cVNoZ0JyTGVtYURJZDhlQWE3OEwwV1Y0UzNKN2Nt?=
 =?utf-8?B?TldaTkZSNkFJUk9kS2dZQlZockl5MjRBUWU1UkRzbUoxYVUrY0FHbWdwU1J0?=
 =?utf-8?B?eWNFOFMxZTFrQm5vVFBVVFFpZXFncWx6emNVRVZGM3V2STV3MnorU2hkSzFT?=
 =?utf-8?B?YWhTWmJGQkVQZTlCRmpqeXBIcVFlcCtTUWRSNTl3N2p6RnFhZ1lBS0tYQTJn?=
 =?utf-8?B?QnJjelB6ZW56ZVB5bUs5bVN2Rk5Zemo0NlBNNlpxMUlwbnR0TGNUTHBtUm4v?=
 =?utf-8?B?RGVGRXhLeUcxcCtEQW1ZazV3UnRvRTJtbFFJZVRjbXU1OE5kWW85K3JYNVFt?=
 =?utf-8?B?L1ZtME41QkRYOVlIRXUyaldGcGYvVVZ3aG5JTTNQYms0bzZmLzFaVmp4QVZ0?=
 =?utf-8?B?cUlVbmducHBEU1VTZUVaL2x0Yk9aUHJ3eUpXbjA2dUFBZnhIZ3VGcE9yS3A4?=
 =?utf-8?B?R0QvK2Mra3VaTlE9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2021 23:28:36.1246
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fa76415-bfba-4260-ebe7-08d8b81af344
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gmVzVxmEwankm3ejuXNQq1OW1dE9PEx3l/9Q99i6V5sz0ItlxFnlk94r3H14eEAK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2376
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-13_14:2021-01-13,2021-01-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 priorityscore=1501 mlxscore=0 phishscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 adultscore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101130141
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/13/21 1:48 PM, Song Liu wrote:
> 
> 
>> On Jan 12, 2021, at 9:17 PM, Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 1/12/21 3:42 PM, Song Liu wrote:
>>> syzbot reported a WARNING for allocating too big memory:
>>> WARNING: CPU: 1 PID: 8484 at mm/page_alloc.c:4976 __alloc_pages_nodemask+0x5f8/0x730 mm/page_alloc.c:5011
>>> Modules linked in:
>>> CPU: 1 PID: 8484 Comm: syz-executor862 Not tainted 5.11.0-rc2-syzkaller #0
>>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>>> RIP: 0010:__alloc_pages_nodemask+0x5f8/0x730 mm/page_alloc.c:4976
>>> Code: 00 00 0c 00 0f 85 a7 00 00 00 8b 3c 24 4c 89 f2 44 89 e6 c6 44 24 70 00 48 89 6c 24 58 e8 d0 d7 ff ff 49 89 c5 e9 ea fc ff ff <0f> 0b e9 b5 fd ff ff 89 74 24 14 4c 89 4c 24 08 4c 89 74 24 18 e8
>>> RSP: 0018:ffffc900012efb10 EFLAGS: 00010246
>>> RAX: 0000000000000000 RBX: 1ffff9200025df66 RCX: 0000000000000000
>>> RDX: 0000000000000000 RSI: dffffc0000000000 RDI: 0000000000140dc0
>>> RBP: 0000000000140dc0 R08: 0000000000000000 R09: 0000000000000000
>>> R10: ffffffff81b1f7e1 R11: 0000000000000000 R12: 0000000000000014
>>> R13: 0000000000000014 R14: 0000000000000000 R15: 0000000000000000
>>> FS:  000000000190c880(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000000
>>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> CR2: 00007f08b7f316c0 CR3: 0000000012073000 CR4: 00000000001506f0
>>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>>> Call Trace:
>>> alloc_pages_current+0x18c/0x2a0 mm/mempolicy.c:2267
>>> alloc_pages include/linux/gfp.h:547 [inline]
>>> kmalloc_order+0x2e/0xb0 mm/slab_common.c:837
>>> kmalloc_order_trace+0x14/0x120 mm/slab_common.c:853
>>> kmalloc include/linux/slab.h:557 [inline]
>>> kzalloc include/linux/slab.h:682 [inline]
>>> bpf_prog_test_run_raw_tp+0x4b5/0x670 net/bpf/test_run.c:282
>>> bpf_prog_test_run kernel/bpf/syscall.c:3120 [inline]
>>> __do_sys_bpf+0x1ea9/0x4f10 kernel/bpf/syscall.c:4398
>>> do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>>> entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>> RIP: 0033:0x440499
>>> Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
>>> RSP: 002b:00007ffe1f3bfb18 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
>>> RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440499
>>> RDX: 0000000000000048 RSI: 0000000020000600 RDI: 000000000000000a
>>> RBP: 00000000006ca018 R08: 0000000000000000 R09: 00000000004002c8
>>> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401ca0
>>> R13: 0000000000401d30 R14: 0000000000000000 R15: 0000000000000000
>>> This is because we didn't filter out too big ctx_size_in. Fix it by
>>> rejecting ctx_size_in that are bigger than MAX_BPF_FUNC_ARGS (12) u64
>>> numbers.
>>> Reported-by: syzbot+4f98876664c7337a4ae6@syzkaller.appspotmail.com
>>> Fixes: 1b4d60ec162f ("bpf: Enable BPF_PROG_TEST_RUN for raw_tracepoint")
>>> Cc: stable@vger.kernel.org # v5.10+
>>> Signed-off-by: Song Liu <songliubraving@fb.com>
>>
>> Maybe this should target to bpf tree?
> 
> IIRC, we direct fixes to current release under rc (5.11) to bpf tree. This
> one is for 5.10 and 5.11, so should go bpf-next, no?

I don't know where it should go first. Maintainers know better. But it 
should go to 5.10, 5.11 (currently rc4) and bpf-next.

> 
>>
>> Acked-by: Yonghong Song <yhs@fb.com>
> 
> Thanks!
> 
