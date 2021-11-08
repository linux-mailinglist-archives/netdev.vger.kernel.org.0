Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E25EF449E88
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 22:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236983AbhKHWCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 17:02:01 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:25062 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231330AbhKHWCA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 17:02:00 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A8Imnjb028781;
        Mon, 8 Nov 2021 13:59:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=YkRqAUSVjKPQZVXcc4r9V6yTDr81Efx/U0aG5H+6leo=;
 b=PSn87jDMogysRfrwsWklMNVcIZsF2xfIYz7XeJz7SNtKT4HAY4ruD65+L/O9SF8fg3re
 iH3ap/pIMtXUHbFhGktocs+UwnUNME61v5+/9VPUez5Qi0EdaoA4Dxw7FBv83CHmcmA6
 7WBKjFeiqqV/oh2MryTz5NXZFBKshNEN8lY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3c728t5fdb-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 08 Nov 2021 13:59:14 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Mon, 8 Nov 2021 13:59:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L5b4rVQN/587JcwfWiC3L8f9b+mxmY9ZpP7VkPQThqRkZwIvqyc1yzLPwT/VxYBm0xyYFFdyNB88gQTGhhKbTj77Bxzdnqqt4N89CIyiDjK0jrjnHHBRbo3BFpFiaKG46vRPzOctj9V/ju1nc/aFNHsoPcPSerVZIEKoKpxSsUv4+Jdm7nAW8UYedKQEgDabrhuJz+rIcEDfnuR6ldflncf+q2yd+we0kFlbZgUB6Pcv/CdWUJXXtlH7XanvAYvGfy8KdiQf0tFBzN2wWj4STdCCbIc0WDkL5fzyMfa/QtnpklrwAyyY5FQHyhicjqHSjxUQPgz/yysqfqfZrs1AoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YkRqAUSVjKPQZVXcc4r9V6yTDr81Efx/U0aG5H+6leo=;
 b=NPgq3hRZfIfTPnaXW5S69W8JnSiA520eLtWcbakv38PlxxrDsA61dllm2Le5dYZWqevYONq0Q0kxJ12AAW+djRwK/fxxTzUVipkkMIOvyoUrpg7nMaPL92tsnoyqXs1KN3ME4+xqO9ZYM0Qo+pLVtC6vWFUGf2IegZPrNNq0RKCK4l3vmfl9wBlbESPdgRHTHOHdeNBcVNoxWIXiwQFRnq/8Xggd1qcYG5my5yYfiH021WZf91uptXi6pYyRu+dEr4YJTn2uYN/PCc7vOf/2undT2LsI8Y9uTmIWphxX5GX1wT7RGS70WZ9z8cgHGagz612/cYdzd3P9ov9IMVTV7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5061.namprd15.prod.outlook.com (2603:10b6:806:1dc::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10; Mon, 8 Nov
 2021 21:59:09 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::30d5:5bb:f0af:d953]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::30d5:5bb:f0af:d953%9]) with mapi id 15.20.4669.016; Mon, 8 Nov 2021
 21:59:09 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
CC:     bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "hengqi.chen@gmail.com" <hengqi.chen@gmail.com>,
        Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH v5 bpf-next 1/2] bpf: introduce helper bpf_find_vma
Thread-Topic: [PATCH v5 bpf-next 1/2] bpf: introduce helper bpf_find_vma
Thread-Index: AQHX0pw03DwQL1y27kyf82pO/tDijqv5+dKAgAA4qYA=
Date:   Mon, 8 Nov 2021 21:59:09 +0000
Message-ID: <099A4F8E-0BB7-409B-8E40-8538AAC04DC5@fb.com>
References: <20211105232330.1936330-1-songliubraving@fb.com>
 <20211105232330.1936330-2-songliubraving@fb.com>
 <0ee9be06-6552-d8e3-74c7-7a96a46c8888@gmail.com>
In-Reply-To: <0ee9be06-6552-d8e3-74c7-7a96a46c8888@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 91e8bc56-9ea0-4bd7-3ffa-08d9a302fdcb
x-ms-traffictypediagnostic: SA1PR15MB5061:
x-microsoft-antispam-prvs: <SA1PR15MB506152C864FE718D0BBFE56EB3919@SA1PR15MB5061.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: S6D83u2BkKmnqnMjkadhKjwtTYuD6RqUwiaeG0OuDY3gCVAcfbB/m4sjMHi6Ezp8MQ2TakS0PJpHBZvxhb/D48+iXDzuXD1KE4Vgpea3TJ0dYbxVMLlyg0DDz9fpL7uvefl2mBhmSX1BzD1MzcAACeBW3bmRlp3zchZ6pyZtErjIXDeXp3Y8CJteEvmjXB1vNYy/kVgf8yajjw5D9oJm4pqs6q3V7Mb/lCy0sy9yfSwxjv3lMRlsUJdI14v085u4b/p4dAUK04KM1pTb2iM8wXAboQgHg8JD5Ji1P9cLI0cQysc5dn3N2ar4VkC0AUWhWXRXdUQkFtGpgoFSQuh8NXAi9FV0I2cHQEhpwtDg5mC+tCCHz2bq3SYZiXQK1nFm7tW783jRrhQ+9xhEkzSPBY7yAI6KeKrMhftd7+2SjrIaqjn2Eu8Z1RWSR3jrLwOSst/+YqoQV3LhJJ85hLqH7jen0jmsevkNgzb2cO0yn/L/wK+N1pk3EL947wI55+TtHcLUFooQzowQFf5CZQH9PTnL3ZrgFiOCk9NsSAmaQ63DeX6Kbankhszhds6J4OO+SKIM3KLZiWDrF8K3ms0JWeyV3vT32iNGLDpfgW3cxvPwQFTqvPQTcwJTKdweDuhP8fNfh1b38xxTRi5bXyS9XoQ1wlxY2HA/HJo4hp1GVa7ZO5wj2jS4LjSsHdkNhp1V6lY8U5nAcKuKNjIKE7v+VG0EUYQkzyjoW/iY558My9gbMDv3SiY3pV6pDh2uAqAc
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(122000001)(83380400001)(33656002)(38100700002)(91956017)(6486002)(4326008)(86362001)(54906003)(5660300002)(66476007)(2616005)(64756008)(8936002)(76116006)(66556008)(66446008)(66946007)(71200400001)(53546011)(2906002)(6512007)(6916009)(8676002)(186003)(6506007)(36756003)(316002)(38070700005)(508600001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?IPtxDKOGNmdW4wgMoXctEqMHPtp9alk25KPo2dcNHz+XB1fA7quItSt5ysWp?=
 =?us-ascii?Q?TyXWTdeZ8qNRsCz024doqp2fFIxMeQ+LceM4s0xLMmhpRQZRo3TUm8BgjRVG?=
 =?us-ascii?Q?uUzVIk/ZR9sqc8B6xlVzTjhbNhmiThp1EkQcjM2rpK32plrDjp4QJsPNm3sC?=
 =?us-ascii?Q?IjmXBLFO+S9NULc25UCEvolhrT61HdzQoT7UGsNdLzUg8qMNbnZGVSe19W27?=
 =?us-ascii?Q?nj9X5YocCe+SMAZ2eWmdX9pe5lxafEvrQM0xVHAbq4wmvXYqP5LzS7MEmI0a?=
 =?us-ascii?Q?jFuMFBAGfw/uPKgyoFzGDRhG3rtGYljJZoPAgoruynCBlosT6OcN8JRnNQxU?=
 =?us-ascii?Q?dvTvqfHMqG5JpZbN5PGSNSR4D7AXpqorf8W+5Lx23gFvRBDDwzq+G42eZFDl?=
 =?us-ascii?Q?Gf5rYQbQ2WlaBmNGhhboaTErVtctXUA2/4cSX3urkazD15POFchZoXt5vjfW?=
 =?us-ascii?Q?MepERzPLXDC2Hl86Te9SnbWB6e0FpZz8T1pI9nmPFryHLIGs6edLIy8/i1n1?=
 =?us-ascii?Q?45QghaiKjHShnokseKm8zHDaR1kfiLyprGBWkBpAYZZeYRgtTWKxL0ZuM7Cq?=
 =?us-ascii?Q?JXfcp9BR8ubXyZR/5BfyIA7MVl0V8Xx+SzW27ZMugKk2CIMoG9t5+rsxrs+I?=
 =?us-ascii?Q?4LfLQhu1W6qgopbo49ubLYSsn1f9QUJKGGuDib/RpAoDwKYjz0Kcp+5YmUE+?=
 =?us-ascii?Q?XEVAuB7JK3B7kgxJn/CD5BViuzvHoTmf48BGB5cMwUvuKu8isf+3Nu9AB7DE?=
 =?us-ascii?Q?PRw9xwFFbc6uQlgdzCVabRhJh44hQD6QzIgNc15d4kV7IM/M5VIY5Z7xevXb?=
 =?us-ascii?Q?C0+Ll71nqzJuyZl1frTOkFNsiWOOQO5PLiCOAxNch3NnSt4YoVWYmGTeASRT?=
 =?us-ascii?Q?8mjr91x/IL4HSTD5OHeLFcE8Qnfv6995HXCGNse6aL8APHHa6WT1DQjuMfd3?=
 =?us-ascii?Q?a1oyO2baeDQz5u3t68xhmYW+R3ahtFsjkjm89dXbJgxVagRLSfrc9wNIUDVp?=
 =?us-ascii?Q?vxQFkAywcEPpCdV9FFOlh3QW+wiGjwdcY9tTK6Xp7fYtEPbX4SFOLiAnFCQT?=
 =?us-ascii?Q?0Nm1ct/67Kui08NP2YOZ5HEMKPdHtB5wILZzjbx4kr28l77IhlYI86aub5NN?=
 =?us-ascii?Q?FVVGpXHym9WB8Glm/5WLsMrMs6XQt3tvvym4jnI58WZCWMQjEeqq2e81seKS?=
 =?us-ascii?Q?IWphaa6MQSrecN8ZZCHTyjaYYLAk5HfYQrjl8Ak2YUyFqdzElr9cmJB4bKCI?=
 =?us-ascii?Q?iFLdyqfzAsZ7CrNjixW54W1yUfaFxB3ocxXsojLvW5EwKtOMYdP0e7FfppXg?=
 =?us-ascii?Q?7VRwZVwA3MuJdfGiD1BHYmN55boxTYncCARnrXSFyHUJ9LdRGdJvlglhHSiu?=
 =?us-ascii?Q?gfe2u7wZJdTqjzs+xIfYgC0EQ+cJZM4J+5GsxPFarYTjNlg0tZB/x8t0bRA/?=
 =?us-ascii?Q?nExFItfvzuwVQDnHu26EULffK34uavoB/cJlPnSJQC/7c6JzyZPPlJe6beyc?=
 =?us-ascii?Q?r5jUr7pDymbcDCe5BTw5cwaQeFinM0x2X2IayIM1K7tq+iHaGapdhaGpKljU?=
 =?us-ascii?Q?QgmZtE5aAGkqBSknPn6m0xmM5SVcnUjIm7T/Mg1p45/OpXy/aySqW5mLH5uk?=
 =?us-ascii?Q?TJ5tpih6gv97QllfrZN/bt1uZ34E6InUvu3TROPkLyE6DXuxifXhi6+pBFnT?=
 =?us-ascii?Q?6yt3sg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9E962B8BA85DF44B99C2D35529FAA862@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91e8bc56-9ea0-4bd7-3ffa-08d9a302fdcb
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2021 21:59:09.2156
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yTOCYpMjE5GVbeam8L8O3l8WcQffy84kHiclhNzPvwHRMrA4CXY24PbskxamLXn2LohUOQPvwXiWwvRZLxWkYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5061
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: p3li8Tk6Kg9hZbRNnufXdb0UC_JdS4TY
X-Proofpoint-ORIG-GUID: p3li8Tk6Kg9hZbRNnufXdb0UC_JdS4TY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-08_06,2021-11-08_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 impostorscore=0 clxscore=1015 mlxscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 lowpriorityscore=0 priorityscore=1501
 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111080130
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 8, 2021, at 10:36 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> 
> 
> 
> On 11/5/21 4:23 PM, Song Liu wrote:
>> In some profiler use cases, it is necessary to map an address to the
>> backing file, e.g., a shared library. bpf_find_vma helper provides a
>> flexible way to achieve this. bpf_find_vma maps an address of a task to
>> the vma (vm_area_struct) for this address, and feed the vma to an callback
>> BPF function. The callback function is necessary here, as we need to
>> ensure mmap_sem is unlocked.
>> 
>> It is necessary to lock mmap_sem for find_vma. To lock and unlock mmap_sem
>> safely when irqs are disable, we use the same mechanism as stackmap with
>> build_id. Specifically, when irqs are disabled, the unlocked is postponed
>> in an irq_work. Refactor stackmap.c so that the irq_work is shared among
>> bpf_find_vma and stackmap helpers.
>> 
>> Acked-by: Yonghong Song <yhs@fb.com>
>> Tested-by: Hengqi Chen <hengqi.chen@gmail.com>
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>> ---
> 
> ...
> 
>> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
>> index dbc3ad07e21b6..cdb0fba656006 100644
>> --- a/kernel/bpf/btf.c
>> +++ b/kernel/bpf/btf.c
>> @@ -6342,7 +6342,10 @@ const struct bpf_func_proto bpf_btf_find_by_name_kind_proto = {
>> 	.arg4_type	= ARG_ANYTHING,
>> };
>> 
>> -BTF_ID_LIST_GLOBAL_SINGLE(btf_task_struct_ids, struct, task_struct)
>> +BTF_ID_LIST_GLOBAL(btf_task_struct_ids)
>> +BTF_ID(struct, task_struct)
>> +BTF_ID(struct, file)
>> +BTF_ID(struct, vm_area_struct)
> 
> $ nm -v vmlinux |grep -A3 btf_task_struct_ids
> ffffffff82adfd9c R btf_task_struct_ids
> ffffffff82adfda0 r __BTF_ID__struct__file__715
> ffffffff82adfda4 r __BTF_ID__struct__vm_area_struct__716
> ffffffff82adfda8 r bpf_skb_output_btf_ids
> 
> KASAN thinks btf_task_struct_ids has 4 bytes only.

I have KASAN enabled, but couldn't repro this issue. I think
btf_task_struct_ids looks correct:

nm -v vmlinux | grep -A3 -B1 btf_task_struct_ids
ffffffff83cf8260 r __BTF_ID__struct__task_struct__1026
ffffffff83cf8260 R btf_task_struct_ids
ffffffff83cf8264 r __BTF_ID__struct__file__1027
ffffffff83cf8268 r __BTF_ID__struct__vm_area_struct__1028
ffffffff83cf826c r bpf_skb_output_btf_ids

Did I miss something?

Thanks,
Song

> 
> BUG: KASAN: global-out-of-bounds in task_iter_init+0x212/0x2e7 kernel/bpf/task_iter.c:661
> Read of size 4 at addr ffffffff90297404 by task swapper/0/1
> 
> CPU: 1 PID: 1 Comm: swapper/0 Not tainted 5.15.0-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
> <TASK>
> __dump_stack lib/dump_stack.c:88 [inline]
> dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
> print_address_description.constprop.0.cold+0xf/0x309 mm/kasan/report.c:256
> __kasan_report mm/kasan/report.c:442 [inline]
> kasan_report.cold+0x83/0xdf mm/kasan/report.c:459
> task_iter_init+0x212/0x2e7 kernel/bpf/task_iter.c:661
> do_one_initcall+0x103/0x650 init/main.c:1295
> do_initcall_level init/main.c:1368 [inline]
> do_initcalls init/main.c:1384 [inline]
> do_basic_setup init/main.c:1403 [inline]
> kernel_init_freeable+0x6b1/0x73a init/main.c:1606
> kernel_init+0x1a/0x1d0 init/main.c:1497
> ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
> </TASK>
> 
> The buggy address belongs to the variable:
> btf_task_struct_ids+0x4/0x40

