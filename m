Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85E3644B93B
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 00:07:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240752AbhKIXKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 18:10:21 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46804 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236797AbhKIXKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 18:10:20 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with SMTP id 1A9MwuPl021433;
        Tue, 9 Nov 2021 15:07:33 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=z4+oNxDpZ3CagbvPemANB817KOOkxJNBXgrnoCqykAs=;
 b=pXvP/bMSxuMqqOoO9uYx2WIijkrL19EuHEDuYZK6Hf3zwEVglLAZuaCI11Dec+0m47AU
 O2KiOGshC85JfCVLWsqei8PEp0J7rYMlbYSWORLOy0bmFinzBX1PI2yE8PrGfgohAdPi
 yP130zey0qnFm3i8Fi96tK4/eUH1nbetf58= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 3c7tefd592-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 09 Nov 2021 15:07:33 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Tue, 9 Nov 2021 14:56:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YvfJcwLziI0QCvHxB0b1wRfizEevpp0s4ayJUjDn6SQcIbn66pen3vmoTl+IK2iGBomtpZEYZeQOYSVSfNwyeL37y8UH724f5P4ivgbWGquXc2e3cWjkdBlQqy+GkYYfgWVb61RRPR4m/utm2DdEygYcfwbQhGDH31EDLffjgJrkZpdTnTiPcZsIJ4SWXxzFqFz3dBOTXgg2cjpVaXu7n34JrywFIQswIkR1KnT4q3lTe6mZ6RVPKLtsv57PvrIo88hRuXyJszhlsCw2q9JlCKmOmW29X6DdH3LKPwR+5Po2ygsH02rVv7p0UeqhQMTrrAiOOyKQKMxLzooaLfi1Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z4+oNxDpZ3CagbvPemANB817KOOkxJNBXgrnoCqykAs=;
 b=M+DwPIZsi0NUYlS0Yg8vLnzWBLef6BAXaXCLU4tARJDxX04IjqHEH1JN/geuGniWDnST4bz+7mxty0arNgw8YIgsHMGqQhCDqri/tw25panHc1hpjI1pHX1arTI2vKsgvz+/LBujHfhV1UEiomXZgzKYF+swxFKpsC1Ae27h4a9SukTgoMBTTfm6bNncrtuGce6nKt81dMEgYaxMsyTL9/Tcq8TTBxn37i1ZlWX29jZW/3DpbqephlVboD7QaGAyk4fuLxMFo2+ng0DMtowpsLtE1dvNfpsDu+nh8XJoqQfRQe7n8o96QqKUWigxqS0x8w9SBAFHhpFhvVtMtdIoEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from PH0PR15MB5117.namprd15.prod.outlook.com (2603:10b6:510:c4::8)
 by PH7PR15MB5276.namprd15.prod.outlook.com (2603:10b6:510:13e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Tue, 9 Nov
 2021 22:56:39 +0000
Received: from PH0PR15MB5117.namprd15.prod.outlook.com
 ([fe80::3102:269:96e6:379c]) by PH0PR15MB5117.namprd15.prod.outlook.com
 ([fe80::3102:269:96e6:379c%9]) with mapi id 15.20.4669.016; Tue, 9 Nov 2021
 22:56:39 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Eric Dumazet <edumazet@google.com>, Yonghong Song <yhs@fb.com>
CC:     bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next] bpf: fix btf_task_struct_ids w/o
 CONFIG_DEBUG_INFO_BTF
Thread-Topic: [PATCH bpf-next] bpf: fix btf_task_struct_ids w/o
 CONFIG_DEBUG_INFO_BTF
Thread-Index: AQHX1bitryCAq/+ByUq+OwLiE+zgCav7ybIAgAAE9oA=
Date:   Tue, 9 Nov 2021 22:56:39 +0000
Message-ID: <F9CC386F-9598-41EA-8B15-D2DF4EB4EC01@fb.com>
References: <20211109222447.3251621-1-songliubraving@fb.com>
 <CANn89iLULCxZ+p-zkZVTLObLvJ+z34nEqS-e3nmA8MK0cKzi=g@mail.gmail.com>
In-Reply-To: <CANn89iLULCxZ+p-zkZVTLObLvJ+z34nEqS-e3nmA8MK0cKzi=g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2df23a3d-e252-4127-66bf-08d9a3d43096
x-ms-traffictypediagnostic: PH7PR15MB5276:
x-microsoft-antispam-prvs: <PH7PR15MB527681071DFEE88486D279F5B3929@PH7PR15MB5276.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7HQhCArSgUCIptIBGpHSkMRUum/4S1DgUmX1JKtdahtrsVY6pii5AXk4t+FoIR/QYf6IRV5k+jj3q7ghfdBK44jNle71es5uWiGwPSCTmiABomDgenLigTZwGW95+L3zx5UhTyZ6CeyPFkirz6hQCkR7/FJmfFP090aaDeAiLHi92bpn2vuiDVj6hYNc/pqsMH3wm//SATW447sDZn+vXIVeB8U23ta+n8bs7o+uw+niKaXsj5Js0FOy7SsNRAsjt0dyOJOmG2t74z5y91H2JiFWiIodNloSV2FzfR3UBa9w79j+97eQA1Dtln4tnAToKN/SPytLoLviA6Fg4cFEWl3Lt1sRtCKnMmPOivhRU49OshWQbuwfSB+9WLexy4wgCPCmIZ0wW38at0cWvVnzjTaceUGmO+sFAPHzgBeOEs/WUGcUcPimXX+fDvB8C08vf5ZMDkpMTVS2IFDIa9rjmhVYDiVjjc2vpKiizjsbiema33+G8Ldowg0ZwWhnE405mMYtq1aeqL8jUCCx5WJ+n6l27qUJjt6H/kB6OyaUI33DAuJ2rsNyFbQZGyL01q4tPmt17EDootLmDOyh4MMM8sM5Tn9Q4Ulk0ErszbgUkKTecHpEiM0LWBuj/1sY8F2aAzG62wtZZmITU59NVfeZ8N5HyYQuVJr1X7lz4dPbw9SOz0OAavAtEkibsls7S96HKU9c2eqSNEQTf9vymOVNG3JRspgInURLi5u6silvtnFNCxGs58CaKnNJ0bddnFYF
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR15MB5117.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(33656002)(186003)(5660300002)(64756008)(86362001)(36756003)(66446008)(38070700005)(6486002)(66946007)(508600001)(66476007)(91956017)(76116006)(6636002)(8936002)(6512007)(66556008)(4326008)(38100700002)(2616005)(122000001)(53546011)(71200400001)(110136005)(6506007)(2906002)(54906003)(316002)(8676002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9DGvQevguZ5EzRj1xqAo/yH/L5USGKcyO3RitV0gRQSCIlSsuewHaeDambwM?=
 =?us-ascii?Q?50K8DhY/y4R23ByqxY1wegvzSlSAtkntXy30Q9XxJKWYKg1I2swDvjpY7tNn?=
 =?us-ascii?Q?yy3DhF38lIxWG7hM95sHUbNCwR5oNld4Q7rbq0FjCfCmPH3mH6pFxfbhI91R?=
 =?us-ascii?Q?ZsyS2PzqMYqUyPIvZsYPdD/B7AtOaLLDxZRiE3hyiCS/vss4z0FUFUgiW9n6?=
 =?us-ascii?Q?NBEOGATe1MTfFr5ZZAe3sUU9yDwJ/+QK735NsSlKif5rhWtwMOZEsi06/6RQ?=
 =?us-ascii?Q?cRI2Kp2PFFQA306qavhrvca9o/m6dDKoCz3UlplJQx8fZx9E4xolvKZ2vX+V?=
 =?us-ascii?Q?nSqGvU9drlNrLv6kM8Rxyyn+BkjtGEvKYWcSqgEY8sskBmBuUNEhlPERHZtJ?=
 =?us-ascii?Q?l1Xq7vRfloEx12eG0PKwSf7p8g18B8yLqRHcQCXXeNcnoaMEX5AL+hN+gEnf?=
 =?us-ascii?Q?48efthCb4+nuMD2IL4iWvJvwYJxytZfMZyKqb+R+OkE077CBIuYVhbEncbj7?=
 =?us-ascii?Q?alzh/lpxKXDIbFnlDk84li2BRa+lZFCAALsiSI2hoNfwP8mSSmBdfVaGSCiF?=
 =?us-ascii?Q?x8awy9AdeAQoFgOaq+byMzRaxt0EbaUMcwA64X/je2ExumcAlIdIdhd4PeET?=
 =?us-ascii?Q?SaN3FaYT2iMzDRnctV1xOnzHBX5mAtYNpEOA6uHFv//DY2r413oSW7sYO92b?=
 =?us-ascii?Q?q6t8tmNx36EuhtEJzvCAWBFq6XU421Rmq4IyX1dLXWFnIBAWgJD2BuAqor3m?=
 =?us-ascii?Q?NT1XEx7h9wgm9ltMgLcPeWFFOefZCRybVlc/D2eOVPAvGLqTeiw5J5yDRBk1?=
 =?us-ascii?Q?ggBlCiScHMqIcb+UZk2wOR6vgCBZFL/PSBOsxxMVizcpZRbb+eFmKZCeNTTG?=
 =?us-ascii?Q?OdOOmPxVW6VqKxm/hPi6qwnT/bc5jxpdBg7uKM+BQBu6jt+n/jeMjkbwFyd6?=
 =?us-ascii?Q?FEAzBkSVfp512tMdkODNJm76AaU3cNPdh4i9tl9wIAjpoTC6GFf6kmc/0Zcb?=
 =?us-ascii?Q?0uPlJxyavHPNNObrLL/LsjwGA1u15gvOgstwmI6cr3TrcJNF5xtnK2qxeZRy?=
 =?us-ascii?Q?+F2aekNS/DiXY6CEfcK2xzdB/YSqrTiY1n2+hl8UMb9KVFBQa+dVigr6Jmmj?=
 =?us-ascii?Q?+b5oO30j8Tkmjro8Nv41ACgTPdGJdAQhkSNdQUND3cb4k3lRTfU6p4HlHvn3?=
 =?us-ascii?Q?9r0KuQHRKeCksecdJo+u1rurJO5ymfYr9abCdR4G+ZojouQ+eBecE+pLM2IT?=
 =?us-ascii?Q?PayouLnl37KvUvkN/lK68PLjtme4R+7G3KB1ag+bimviAZU3FT7+gZ++jJ5c?=
 =?us-ascii?Q?JQhmKxOSdDg5vC+CT8R+Lat/OA2rbYX35sht10hLMAZeV4PHVFn9N1ScYw4M?=
 =?us-ascii?Q?Tt03USd8jYWJdmzYaTowJLXk4T/jtXF1JzzDllZ2aZDcGvTve7s/7XO/kpgW?=
 =?us-ascii?Q?FsItmcieugQbOK2A8WmT6gDpCArXrXsz56ATpfdd1ukcoBDhOADBppBMLMQJ?=
 =?us-ascii?Q?LZ1W8rKZpALlOf70MyCs1lKJHjjuTW5srMHiWP7yg5BxQHTc7VZlICPGDG2I?=
 =?us-ascii?Q?vG+Eb8MJ13kwDbUKgWokG55qgO6ZcZiVsDlP8x3ztBTqH2fxD835mdjfadoZ?=
 =?us-ascii?Q?yadci+IQk0jJzaxPL4KEgQ5IzsOtxaZ40pdx5A3tWFHIUj/9XjJGgJOybaHu?=
 =?us-ascii?Q?8tEMlw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <74E63EDBFCC4E845A5DED034192C2E9D@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR15MB5117.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2df23a3d-e252-4127-66bf-08d9a3d43096
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2021 22:56:39.2526
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: be2iia92A/GUecau4RZ/k7GQPT2omArXuf7cZDQsXm7FRIWogmhyU/owZL7YdfKgpL212Nxt6BpgTy9ot3UmTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR15MB5276
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: iVfLfj5mW9ARh97G6mWJc4cxvWTq_l7s
X-Proofpoint-ORIG-GUID: iVfLfj5mW9ARh97G6mWJc4cxvWTq_l7s
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-09_07,2021-11-08_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 adultscore=0 priorityscore=1501 impostorscore=0 clxscore=1015 spamscore=0
 bulkscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 lowpriorityscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111090126
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 9, 2021, at 2:38 PM, Eric Dumazet <edumazet@google.com> wrote:
> 
> On Tue, Nov 9, 2021 at 2:25 PM Song Liu <songliubraving@fb.com> wrote:
>> 
>> This fixes KASAN oops like
>> 
>> BUG: KASAN: global-out-of-bounds in task_iter_init+0x212/0x2e7 kernel/bpf/task_iter.c:661
>> Read of size 4 at addr ffffffff90297404 by task swapper/0/1
>> 
>> CPU: 1 PID: 1 Comm: swapper/0 Not tainted 5.15.0-syzkaller #0
>> Hardware name: ... Google Compute Engine, BIOS Google 01/01/2011
>> Call Trace:
>> <TASK>
>> __dump_stack lib/dump_stack.c:88 [inline]
>> dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
>> print_address_description.constprop.0.cold+0xf/0x309 mm/kasan/report.c:256
>> __kasan_report mm/kasan/report.c:442 [inline]
>> kasan_report.cold+0x83/0xdf mm/kasan/report.c:459
>> task_iter_init+0x212/0x2e7 kernel/bpf/task_iter.c:661
>> do_one_initcall+0x103/0x650 init/main.c:1295
>> do_initcall_level init/main.c:1368 [inline]
>> do_initcalls init/main.c:1384 [inline]
>> do_basic_setup init/main.c:1403 [inline]
>> kernel_init_freeable+0x6b1/0x73a init/main.c:1606
>> kernel_init+0x1a/0x1d0 init/main.c:1497
>> ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
>> </TASK>
>> 
> 
> Please add a Fixes: tag

Will add it in v2. 

> 
> Also you can add
> 
> Reported-by: syzbot+e0d81ec552a21d9071aa@syzkaller.appspotmail.com
> 
> 
>> Reported-by: Eric Dumazet <edumazet@google.com>
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>> ---
>> kernel/bpf/btf.c | 4 ++++
>> 1 file changed, 4 insertions(+)
>> 
>> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
>> index cdb0fba656006..6db929a5826d4 100644
>> --- a/kernel/bpf/btf.c
>> +++ b/kernel/bpf/btf.c
>> @@ -6342,10 +6342,14 @@ const struct bpf_func_proto bpf_btf_find_by_name_kind_proto = {
>>        .arg4_type      = ARG_ANYTHING,
>> };
>> 
>> +#ifdef CONFIG_DEBUG_INFO_BTF
>> BTF_ID_LIST_GLOBAL(btf_task_struct_ids)
>> BTF_ID(struct, task_struct)
>> BTF_ID(struct, file)
>> BTF_ID(struct, vm_area_struct)
>> +#else
>> +u32 btf_task_struct_ids[3];
>> +#endif
> 
> What about adding to  BTF_ID_LIST_GLOBAL() another argument ?
> 
> BTF_ID_LIST_GLOBAL(btf_task_struct_ids, 3)
> 
> This would avoid this #ifdef
> 
> I understand commit 079ef53673f2e3b3ee1728800311f20f28eed4f7
> hardcoded a [5] value, maybe we can do slightly better with exact
> boundary checks for KASAN.

I like this idea. 

Yonghong, I believe you added BTF_ID_LIST_GLOBAL. What do you think 
about this proposal?

Thanks,
Song

