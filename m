Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5A45477CBC
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 20:45:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240705AbhLPTpe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 14:45:34 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34326 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229945AbhLPTpd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 14:45:33 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BGIHHQX008086;
        Thu, 16 Dec 2021 11:45:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=JrMCwqRYyKYLnVGM+ewKRZjLD1m6iuWXCigfGM8Ovsc=;
 b=BNZxGr0SFQWXlgJFOb6Xd/etuUFCK3OBV1nVRPj8rcDa6sg1sgBqKgbKAeDpZ93Y/QyS
 7hC8ZKkdVUc//PTEWzbFJJy7V3UW609ag795kmf2KNZpINo4FRo/sgTSbLvkdzWEjuL6
 vrmEn63hci9GLe2i/TlQ+fpYRFinjARMMsc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3d03d5v77t-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 16 Dec 2021 11:45:31 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 16 Dec 2021 11:45:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=msGfDeAxeiOBH5iJQK6S3Fto9vIjYY2FUlcw6Iju+wVqWNWxlwj+l0/L2O7rASygzSTGHaxqEd3u+3QCJgwKnmpxm07qhWgGc9iDx2hqbAh/2J5U+qLj4+PIi6Vlxoei3uCXSLYlklJb96w/Fk1s+tLdknZAFIO+Enc6qw+e9ywL/R+6WsyPo41acoNQCXaRrWSH3qNegsmtrBnLdIoQM1l6RBsam3aMVoeetCeO9LvpaL+ag/l+wHobj2aQyFVDLhs7Jr/4U67QHcdUqfsCtFwsKFyeQIsSP5oDXvbwSpibuUwB5uXpoho0+hVY0SH1WZAE5rnd6VawgtEnwqqFuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JrMCwqRYyKYLnVGM+ewKRZjLD1m6iuWXCigfGM8Ovsc=;
 b=C2++TzkGjMTnkqkRi9/9SB0Y+zkJKpdL9lUq8QBxeTCIb8M5W4/qx4T8n35X28ZtWWOKD0/d4ARfC7NdbPs3pxwT28eD5QWo1Dv47fBOc342770sMp3GXAtE4HuaUEFkdrxduprZXvjjjqUJ7tfCK78pIpxFWBT+jaZdchN8ojYZaCcUDYGFpaVa7dDbUEr4FwBH7bWln3w4KFQ4GXtBFilPGZuczbGDoJhW7TFHfqtKsSiVU/Zey9Raq7shqo8AOHAFoOgYGmEQLPbKJYmJBB3vozGHLaHCQeIQ0Xi9McyztpJq+5/v9NchSfhLk2rUuH13Y8ka6+a1X2NH7nydvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5061.namprd15.prod.outlook.com (2603:10b6:806:1dc::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.11; Thu, 16 Dec
 2021 19:45:26 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::f826:e515:ee1a:a33]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::f826:e515:ee1a:a33%6]) with mapi id 15.20.4801.014; Thu, 16 Dec 2021
 19:45:26 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Peter Zijlstra <peterz@infradead.org>
CC:     Song Liu <song@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v2 bpf-next 2/7] bpf: use bytes instead of pages for
 bpf_jit_[charge|uncharge]_modmem
Thread-Topic: [PATCH v2 bpf-next 2/7] bpf: use bytes instead of pages for
 bpf_jit_[charge|uncharge]_modmem
Thread-Index: AQHX8Xk2RhT4OmwE5UKoGBpiYcjtlqwzQGkAgAJHhoA=
Date:   Thu, 16 Dec 2021 19:45:25 +0000
Message-ID: <60221F26-614D-48DA-85C5-5FF4143AF642@fb.com>
References: <20211215060102.3793196-1-song@kernel.org>
 <20211215060102.3793196-3-song@kernel.org>
 <YbmtyiGpGLug1x5u@hirez.programming.kicks-ass.net>
In-Reply-To: <YbmtyiGpGLug1x5u@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.20.0.1.32)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d7d61a4b-236c-4c75-f735-08d9c0cc9b62
x-ms-traffictypediagnostic: SA1PR15MB5061:EE_
x-microsoft-antispam-prvs: <SA1PR15MB50619F06753E25290C57FF26B3779@SA1PR15MB5061.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:127;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AQ89loW81Xs2FxGuw6I2J/NKSQLvbjuuU7W7usAlQ6Xfj/N7LZXW83tZuP5WCtm875ZNfQWwv+wrCTU2o4GWWUyUo/RHNKeoEOJDztWYL8vjJdTNmchF+6yOGtiU+DN8OZHJmMWfFCHUpvTrX2iA2wG97o07RWKgE89d4D/KWxU64/V8aQPNX4BJ4PMAwE9TSfI0ud3p8hb4cu1FMVQVIIK7HDfAbBsR/wOh5CXMPLk+jGVMiJKyIqWDlm8QiQ3AhxeW5p6fvfEyL2qey+9f0eLAAdwk+zBH/ces7KPjlRz1v5J03YMAiTwNxw5zILNqvNd1FpsDSFkO6hBA01SslssAgHldzd29+z/2kPi6CaeBS3u6sDZMXYZtgn28JUaUTHwLsqRdwx50PMulfQugt019tbxgZMTDKTem1623/KiXRtPv6y6YmnTmrt2tYzw/JrssF0bHJRqkMGS2OhabfwGcjoRdJXOuKuEJ3pPXeXVO9RMeWzDJ355AipnLPj6Sv5hpteL5bXLj3yCBK6nYFJAew6Xi4McR+Bf+oakk/bghsRmYR1mTNsQ4VOx6XaI+SidVrPOm4Xb+5SOlWvJWFHuaG4WMFctpixrLJb/shee0eaRoiXoeIP3IIMoAMefaDXntd9t8v0xVfh+EA5CYyj8cat9URsHn2/C6soJvvEiFVPwWFhDPV+nvmO8EFaLDoeo3+M3tyzMkAbf+COL/o6Qx6GcJd7NeWWsNkrQ73HcmHKvwdES9TXRBlrs5Yzmb
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(53546011)(71200400001)(2906002)(6916009)(91956017)(122000001)(316002)(6512007)(2616005)(33656002)(66946007)(66446008)(66476007)(66556008)(76116006)(86362001)(186003)(508600001)(83380400001)(5660300002)(4326008)(38100700002)(64756008)(6486002)(36756003)(6506007)(38070700005)(8676002)(54906003)(8936002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QHFAmdrBEyOluPDk16tk3HDmwK150DIrmERQtyJtBY1yA55FAZETSBzpea2I?=
 =?us-ascii?Q?8oSJAtjH8M9/v2Onm3HvpynN4CK94JANzFKw0nWsQldZWrbSDRwHysCAGkyf?=
 =?us-ascii?Q?h8N6RFuSP7wqeOp/uFX88SOkqhfA/tyuipLoVMWtfET50KAaxILAW4giKYHT?=
 =?us-ascii?Q?b30lo0r3Cn4u5OzoIjPb9ouJ7VvuDyl2gjQAk7VD7N/BVcF9fQN9a0SxJex2?=
 =?us-ascii?Q?XDTFF3cMlasYZk/hViEEKBlJ3a2WSruCY768B79iuiDR+oCpSB5VHnd81p5x?=
 =?us-ascii?Q?3KkP9Uz+8xwnriaIXoMWJwuorv1Zn3x3sUdtTvc94YWV44ub6SOzyPvqZqaD?=
 =?us-ascii?Q?yUAr6SgwMH9u2DfbO9fpL0QLT+Sfvqw6iFI5xv6va/vtAGctsEKa/NCNxqjQ?=
 =?us-ascii?Q?JdiU9EHsbayJbIYoiUzgfG9Kbf99Ehk3ZAXv0Z/B9g8sp3TPcGbKtk5yAYfZ?=
 =?us-ascii?Q?x27o6lJPdZ2ULtZ835UAujgVV7DIAauYuCQndukmW6+9RnpGUJSYNILAU9ha?=
 =?us-ascii?Q?rDkugc415eD3x2gr5T6FiGx18BjzbQA3XQxJH3ztduJwATZuFCgXIQqNCQ3Y?=
 =?us-ascii?Q?NEiHHnX64ClWeVt0H3X2aVdpGWXmq99+kh8B79nNRxHnmG+S3fF39VEUdioQ?=
 =?us-ascii?Q?h0bvXhNRZ4iGuubcy+Z2wRjvCz8xODMIqhqiHQ+oFovKCW+1MG2Jp446xxGN?=
 =?us-ascii?Q?tlyz1PXNXsAt6ejMRB2dKYoC1fjLZdfuquN4NAGEi9KvBPuZB3cGmdaLrB+u?=
 =?us-ascii?Q?kM8OPXJ6kPebPQ86G8bUTOgzhJot5bg89KaeRjRV6moaXve+LIZRP0HG9pmP?=
 =?us-ascii?Q?gEhApXNhfMUr/AMmdkBhunVsMXPRWhoIUuM9Y3ZwJoDR5FwawLGTaT52bXLQ?=
 =?us-ascii?Q?gQ8OIp2aiUKKrdvrb9KQiIXLlM6RzgiN8Uk36Zqc84CqvKScYywdHhqP7XzK?=
 =?us-ascii?Q?Mr2A6EcpKZJnAXGvVbWPomgYigJ4hnfP7mWIrG3JwmJEPy3mrHf3sts2DWx4?=
 =?us-ascii?Q?S/6cvcbMDmdW9hRZATE8pBK5/a///Hwbr37ajOvy9uc6hcnLOXhYFhfbqDvR?=
 =?us-ascii?Q?2cvJRtM0HVY8OddPmBM937lGlrQ9y2GnuMaaaJVFjC4QthvqQ9fgfOkeVnLF?=
 =?us-ascii?Q?fcJQYzXR1slQbhRp3QetiMROzqgzDjzNTYHSRweDeXKfxaSa6IZYUIzdENon?=
 =?us-ascii?Q?lwgLEbYadm0W4cgtTcKaAguYm0fGil85LHrvvoB2wMlY/dDAn7ysYisnbXXV?=
 =?us-ascii?Q?E2NIM66CMM6ZodPq5/lv6Uq+kvmEKNt8ldZlUez6b7g14sxrDyUNZunnsKKG?=
 =?us-ascii?Q?D5fpMDNgLCdLH/XVR0Kx9eiToZJ/kFluc/YKTKDixZZUSOFohkWJLhzrNYwl?=
 =?us-ascii?Q?sDq4xVYl3Fsn3m+9zuzFrOhiY1y307aZnJePindaB4x7vnMYD5MrinXzCwYO?=
 =?us-ascii?Q?A+qpHYkxlTP9JodJhiopZLXbYdUGuK6UYsn5XxXE1cNdNZYpmibB41Py0KMB?=
 =?us-ascii?Q?+WRrcfIScTL73YyrdgGrW2CRxq9mm+vNPoqdKCee2oq+E7pxEmi71ZhOMQco?=
 =?us-ascii?Q?yHTH8muozDXKTjL6WYmb/uqMILEqnSHeAm3AWSLyi+CffL7yQCjDGxY5swDE?=
 =?us-ascii?Q?8sGEKRxu10GbwNPnhsz5xcsVBkQmYjaD1ZfBirsc1h0jVL5DuVLS8Da5/tJg?=
 =?us-ascii?Q?+2Rp5w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3D47F9A4445A48478551E66EE76882B5@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7d61a4b-236c-4c75-f735-08d9c0cc9b62
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2021 19:45:26.0758
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tD+tu5RzfUyjfVSilshb2HsDCgvyx2lrvq6DnmiJuetAS/HxZaIPoZ+LBRG4G1hIlTYotelaCAkLsQkDkZ8Miw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5061
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: P8bJNnzS_Jul4sPgxT5hPvB1iFNQKb27
X-Proofpoint-GUID: P8bJNnzS_Jul4sPgxT5hPvB1iFNQKb27
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-16_07,2021-12-16_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 suspectscore=0
 mlxscore=0 priorityscore=1501 adultscore=0 clxscore=1015
 lowpriorityscore=0 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 impostorscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2112160108
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Dec 15, 2021, at 12:56 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> 
> On Tue, Dec 14, 2021 at 10:00:57PM -0800, Song Liu wrote:
>> From: Song Liu <songliubraving@fb.com>
>> 
>> This enables sub-page memory charge and allocation.
>> 
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>> ---
>> include/linux/bpf.h     |  4 ++--
>> kernel/bpf/core.c       | 19 +++++++++----------
>> kernel/bpf/trampoline.c |  6 +++---
>> 3 files changed, 14 insertions(+), 15 deletions(-)
>> 
>> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
>> index 965fffaf0308..adcdda0019f1 100644
>> --- a/include/linux/bpf.h
>> +++ b/include/linux/bpf.h
>> @@ -775,8 +775,8 @@ void bpf_image_ksym_add(void *data, struct bpf_ksym *ksym);
>> void bpf_image_ksym_del(struct bpf_ksym *ksym);
>> void bpf_ksym_add(struct bpf_ksym *ksym);
>> void bpf_ksym_del(struct bpf_ksym *ksym);
>> -int bpf_jit_charge_modmem(u32 pages);
>> -void bpf_jit_uncharge_modmem(u32 pages);
>> +int bpf_jit_charge_modmem(u32 size);
>> +void bpf_jit_uncharge_modmem(u32 size);
>> bool bpf_prog_has_trampoline(const struct bpf_prog *prog);
>> #else
>> static inline int bpf_trampoline_link_prog(struct bpf_prog *prog,
>> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
>> index de3e5bc6781f..495e3b2c36ff 100644
>> --- a/kernel/bpf/core.c
>> +++ b/kernel/bpf/core.c
>> @@ -808,7 +808,7 @@ int bpf_jit_add_poke_descriptor(struct bpf_prog *prog,
>> 	return slot;
>> }
>> 
>> -static atomic_long_t bpf_jit_current;
>> +static atomic64_t bpf_jit_current;
> 
> atomic64_t is atrocious crap on much of 32bit. I suppose it doesn't
> matter since this is slow path accounting?

Yeah, speed shouldn't matter for bpf_jit_charge|uncharge(). 

Thanks,
Song

