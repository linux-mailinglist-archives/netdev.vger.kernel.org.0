Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0607449EEF
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 00:08:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240853AbhKHXLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 18:11:05 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50806 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234561AbhKHXLF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 18:11:05 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A8Impcb010827;
        Mon, 8 Nov 2021 15:08:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=T7PzJqgh5DwAf4/yEcucC1eK7+v78/paFd/gcmOwDDk=;
 b=iUujWTpjz3ZWNSTmUdbLlJu08EYtoHSWytAdF24GKAjv4ezTpTFOvrqNNk4BF/9P5s9o
 hWV91jBbrW5J5cFJaGYj1nHRJlIj5JsyKv/PjgzuOHPvE6zByPaY0mt7UX/gsgr/1DKn
 e42YRgXt0LkzvqWY7luM6KIbr/IRaQccj+A= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3c724w5xe3-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 08 Nov 2021 15:08:19 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Mon, 8 Nov 2021 15:08:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rt6QS7TQXHRYRByFXABC4TKUT+jjgDt6q96YeloydRHMsfOiC7UihQlNXjctYh7WhEdCEh2X1sLhNLqG1xRoq1ACPWErhFQ2GipD9VbOvKFpbsyFnSNDS1CngetE5It4g1Jx98p//i/88mXVU4BtER1Y+UfPIqjgjrPr6wg0aLYgv+L9KgEktxdmNy5hRWx1Drc/600FZS5KkUj7dHJNQ731zhwoT1WDBXkfjtfiKuB8SP2cwbSDucg8NkuYDR+yfFgkeIDJkJcXKyC/GD6JB1D5g6o7d9PVo64DdkUDPlIat1wwAx0pAx2J7IwEJWJ6PA0nUu6rJy4eqJtgsy5J2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T7PzJqgh5DwAf4/yEcucC1eK7+v78/paFd/gcmOwDDk=;
 b=J8cHgF7drbq157jdbYpw2wXvrBmVWeOaVEjxZ0L2Tjr5RqcmnqNKMYpOq7XXn6aL/QcwVIE3nPSEZiVXGkdaCZ6hpIk9drZTvccnkO45i9bPnZsGRirn4E1YscbAC0Z0QPMFBsUomQgCINciWNRfVrQZ0Ml66qGfVEiNOUq7IqzDnTZ62qdSenB8WsYPQqfYbh275u74Ru6QXlYqxril4ecWvK9hxR3xdD23vvUeQn4OkpHjeUlK7wwuPqReKu554mZoLv7eGej+V2kVgDP2SBUYjaPS/NkMrHFhuhx+Wa7kHqJ4hx+rE+TVSEe3pSUD/bFIxLMyn2uldb7odrfcCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5161.namprd15.prod.outlook.com (2603:10b6:806:234::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.16; Mon, 8 Nov
 2021 23:08:16 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::30d5:5bb:f0af:d953]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::30d5:5bb:f0af:d953%9]) with mapi id 15.20.4669.016; Mon, 8 Nov 2021
 23:08:16 +0000
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
Thread-Index: AQHX0pw03DwQL1y27kyf82pO/tDijqv5+dKAgAA4qYCAAAgAgIAABEUAgAADzwCAAAM9gA==
Date:   Mon, 8 Nov 2021 23:08:16 +0000
Message-ID: <CD937CB6-C13A-4846-9503-1CD753309045@fb.com>
References: <20211105232330.1936330-1-songliubraving@fb.com>
 <20211105232330.1936330-2-songliubraving@fb.com>
 <0ee9be06-6552-d8e3-74c7-7a96a46c8888@gmail.com>
 <099A4F8E-0BB7-409B-8E40-8538AAC04DC5@fb.com>
 <048f6048-b5ff-4ab7-29dc-0cbae919d655@gmail.com>
 <c824244f-996e-fb0c-3090-2e217681c6a1@gmail.com>
 <23f914ba-36ea-7270-f0a7-9f2e4b396535@gmail.com>
In-Reply-To: <23f914ba-36ea-7270-f0a7-9f2e4b396535@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0aa3474a-75e0-46a3-8893-08d9a30ca5f2
x-ms-traffictypediagnostic: SA1PR15MB5161:
x-microsoft-antispam-prvs: <SA1PR15MB516197444FB46CD0B97465D2B3919@SA1PR15MB5161.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0o2E0eq9b6N6AXAQmp8+bpNMKSwwnnyAihLELm4CFgUs1sF8qLCj9vEoLtk+WFhyAyuvqr4iafdoGNKe39kW/qFNaj9RSjywu3wvYjk5oUNCZdJ8+FuPrWA6kJ+jlYBRzAys3UML8lN1WeGDk+4PNBySg/AfXmtQial2J23cF0/nmgrcXblfPdjeBw7J/Xhn584H0v2bJE3FfdXa3DG4ZMpzB8GiI7OvQhFi78m9uhhNuGRfzZg1j1xq0VEDHQUqghTvpTPylH9DRBR7l3b7Wx85NWFFK7ajjes3ZjhkJX6+wgdi1lwRkTTHcnEUVqg7yymSBDhLpiv3uNkP153fI5KLB05CnVHHZcUCOPefpas0WbcJYHq+udsDckjIfkA7YvtdsFJ7ie633zAZqgHKbv0ykKbRJ3zxluARMUPiS0k4lqVf6flw/KFVYdxCY38fr3oWhepWE3oLnX8Tgi+FRHztasOITME4OlM/cCoKHuR32Us5y64YCfW/G//l1RcjLuqe/hHbsaj3mfAICnJDFe1Rsw1/mzWP2al1cHGp9wjQbKb95eoBYcEcOtq35Yr/2kI2Z1H2AxJ8EhKvMQYqqiLjVu+0fuXXNgk9k0LIuWbyOwhnqDBupwzPucRFBvQnM1Cyt2+rnBcugCi12p46Kf+DumBTpJB29Q0wuPGs3s79Rc3KMCZ0XjSuEcxhPJUdRP+8vDHPoQU2g5+vxxGMRrJ1LPP9vYj57iQtrKyWEqumuEKZQD+StkfHWzei+oTrj8rcO0iP4iG9c4oXHwROBg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(6512007)(38070700005)(86362001)(71200400001)(33656002)(83380400001)(6916009)(54906003)(2616005)(66476007)(76116006)(316002)(8936002)(4326008)(508600001)(6506007)(5660300002)(66446008)(2906002)(66946007)(38100700002)(186003)(66556008)(64756008)(122000001)(53546011)(91956017)(6486002)(8676002)(21314003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?in7swr5FSZ7pZICSP0+AkUDjalT6X8ihHpDoAmyHzRE5g7hLWayU3nnyqKpN?=
 =?us-ascii?Q?ovcrnjp7y6IwAFP6uABCrlpmuylOsK+uSokq7i+jkhoVclzInbMpFh6I3qwJ?=
 =?us-ascii?Q?lpj1AFvpUXbfGwxKcTWaIgsG4mmwlb/qc9Qs0AR57FpHCnydKiRfhqQi4ccH?=
 =?us-ascii?Q?wU42jon90ZHE36VTzJkiP1boTI4IBWpluVt+PKlBFjPqmNVKk5VVCYIiVHDQ?=
 =?us-ascii?Q?UEX0QZCDDUr+Rk7Qv542q9ICu9f15dkeIKNyx0appS0q4jtGDhmQQfHmTpxT?=
 =?us-ascii?Q?QUsWILE3jNz5fXrYwXAeFT9o6LVuIVdvfpu4wZ73gPiRmmrIJPeMpTMIW5E/?=
 =?us-ascii?Q?aW4j5EHecci+Kj6aCjIYe0OZEj/eOIZxkhoZRZVMELG7Ns0vsxFZO/2gFbBy?=
 =?us-ascii?Q?Bup4TdTn05heYUK49bUElvBct5UxNFcEHF+UHd2jg6V05ncW9m5eJgkv1nwo?=
 =?us-ascii?Q?G70ic/5n+vHQCV1M5DPfeBMcq5Nt2VHG5qzk6IF0Dd0HNt5u56I9MQwbo30p?=
 =?us-ascii?Q?jdJLemehxYTnBA8hdumxjNQGmd68DUNwd+XciCYDAEfzEcxx2ra0E3oxnp9B?=
 =?us-ascii?Q?lEBD6KbYFRwhkfutAExpUdkV/iK4OHOg3iHp1sIuBNSPf5mlpqJ0hzzIrTT0?=
 =?us-ascii?Q?fGRvREKcsJ58ttxse0Rq+5nc61AXRU2v5at065MCq6fAONDsXVxQdfpn1ucZ?=
 =?us-ascii?Q?g9u8CKehcLPpUCridGPftC8bWVzUaA3zfy7hzyXiUWvja8oYw2rO/JGp0wo8?=
 =?us-ascii?Q?VwQYSorVnUAFgR80tDL4iLKoVYRKjXb4Dufp30ZCSdAPnSMQWn2GoXi41rh6?=
 =?us-ascii?Q?JaOHrUhXwPQFxjH/2fqg0U6SHHJZhmBH+JIsA5wKLAb6Pd2/gIUydlVJknf4?=
 =?us-ascii?Q?6M07jDFqfyOE+DE1JfVmFqyZl+BXPaj/LBPDrylWbCGq6jMkgyldwhztq8ja?=
 =?us-ascii?Q?es3z63UYf2m28Ad81EPZI6TdALUGVXhdtUcROp0Ab9IBYMHTbvFDDtSZSr5B?=
 =?us-ascii?Q?gbo46SuYPq8b3tXzYhDXvUf2AQCse7GASsy7lGLgRtoO6r74Jk1z8Fa0koDi?=
 =?us-ascii?Q?X3hsecEvwdVdFrpYjxhnynPCvE8aVXnxAz2ToUSvhR9OOts3TTmUee4V3i9L?=
 =?us-ascii?Q?9/o6JDB22UMOhsfZvDU95NPD148xD2UpzkYzZe2yB7+OkfsBkgTvP8EPJY1o?=
 =?us-ascii?Q?EvqUoM/yJZITHlcfSh0UJaKQIx2sDy58JlUmQBZ1/ZL5gamX/sJdhU4nuZ6n?=
 =?us-ascii?Q?cshilD/7Mh/AF27hlYA4mj3uKzxz1To+xBp9bekMGHDuzBoikWCV+5WliHAG?=
 =?us-ascii?Q?pcyTw81zP9MSrLZsXWMtSB/abD1tgFuiRP5ge3OUvKD1anwmj1LxjIWWvzb2?=
 =?us-ascii?Q?/8I2V+7IH9vWaXuq+WH96bUy6Aks6Yf/WLv4E7HyzotoLUj+TXaqANL+RGcb?=
 =?us-ascii?Q?oM5PljAXv2pHlheow7psnAbhAN38DIT/9rLB94nNH8/970HffyWtD3sdrfOa?=
 =?us-ascii?Q?nMfPeOXhBMj5SV4c1y3Zcv6m75+pPit392zRvITRYWTIYl2jonbekoHSc+fP?=
 =?us-ascii?Q?vF7PoUx4OSk1G7+HAvtS5+Vn4uJmwU2+I4v191G5g9f/gPRvba/n9diXWuYW?=
 =?us-ascii?Q?GEFK2GO6vp/qYKQHoEVhSPFfdnePHbpxJo+5CMgKI7OWrkGiwgfTI2AqZsgS?=
 =?us-ascii?Q?vhIIfA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F926EF08A14A0E40A0DEED8767AE8953@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0aa3474a-75e0-46a3-8893-08d9a30ca5f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2021 23:08:16.8059
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HGS2h5SY8/K+Qo6PiRTOkuLAn+Kt7gXw9/rEIil8Q7bnHfsyBJT93DkRCOYNs56nbLBcKcl2zuibUHCjPzmC4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5161
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: 4iAVsErTdaW5M-WoWCy6MBa4L4pD_Mo9
X-Proofpoint-ORIG-GUID: 4iAVsErTdaW5M-WoWCy6MBa4L4pD_Mo9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-08_07,2021-11-08_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 mlxscore=0 suspectscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 priorityscore=1501 adultscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111080138
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 8, 2021, at 2:56 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> 
> 
> 
> On 11/8/21 2:43 PM, Eric Dumazet wrote:
>> 
>> 
>> On 11/8/21 2:27 PM, Eric Dumazet wrote:
>>> 
>>> 
>>> On 11/8/21 1:59 PM, Song Liu wrote:
>>>> 
>>>> 
>>>>> On Nov 8, 2021, at 10:36 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>>>> 
>>>>> 
>>>>> 
>>>>> On 11/5/21 4:23 PM, Song Liu wrote:
>>>>>> In some profiler use cases, it is necessary to map an address to the
>>>>>> backing file, e.g., a shared library. bpf_find_vma helper provides a
>>>>>> flexible way to achieve this. bpf_find_vma maps an address of a task to
>>>>>> the vma (vm_area_struct) for this address, and feed the vma to an callback
>>>>>> BPF function. The callback function is necessary here, as we need to
>>>>>> ensure mmap_sem is unlocked.
>>>>>> 
>>>>>> It is necessary to lock mmap_sem for find_vma. To lock and unlock mmap_sem
>>>>>> safely when irqs are disable, we use the same mechanism as stackmap with
>>>>>> build_id. Specifically, when irqs are disabled, the unlocked is postponed
>>>>>> in an irq_work. Refactor stackmap.c so that the irq_work is shared among
>>>>>> bpf_find_vma and stackmap helpers.
>>>>>> 
>>>>>> Acked-by: Yonghong Song <yhs@fb.com>
>>>>>> Tested-by: Hengqi Chen <hengqi.chen@gmail.com>
>>>>>> Signed-off-by: Song Liu <songliubraving@fb.com>
>>>>>> ---
>>>>> 
>>>>> ...
>>>>> 
>>>>>> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
>>>>>> index dbc3ad07e21b6..cdb0fba656006 100644
>>>>>> --- a/kernel/bpf/btf.c
>>>>>> +++ b/kernel/bpf/btf.c
>>>>>> @@ -6342,7 +6342,10 @@ const struct bpf_func_proto bpf_btf_find_by_name_kind_proto = {
>>>>>> 	.arg4_type	= ARG_ANYTHING,
>>>>>> };
>>>>>> 
>>>>>> -BTF_ID_LIST_GLOBAL_SINGLE(btf_task_struct_ids, struct, task_struct)
>>>>>> +BTF_ID_LIST_GLOBAL(btf_task_struct_ids)
>>>>>> +BTF_ID(struct, task_struct)
>>>>>> +BTF_ID(struct, file)
>>>>>> +BTF_ID(struct, vm_area_struct)
>>>>> 
>>>>> $ nm -v vmlinux |grep -A3 btf_task_struct_ids
>>>>> ffffffff82adfd9c R btf_task_struct_ids
>>>>> ffffffff82adfda0 r __BTF_ID__struct__file__715
>>>>> ffffffff82adfda4 r __BTF_ID__struct__vm_area_struct__716
>>>>> ffffffff82adfda8 r bpf_skb_output_btf_ids
>>>>> 
>>>>> KASAN thinks btf_task_struct_ids has 4 bytes only.
>>>> 
>>>> I have KASAN enabled, but couldn't repro this issue. I think
>>>> btf_task_struct_ids looks correct:
>>>> 
>>>> nm -v vmlinux | grep -A3 -B1 btf_task_struct_ids
>>>> ffffffff83cf8260 r __BTF_ID__struct__task_struct__1026
>>>> ffffffff83cf8260 R btf_task_struct_ids
>>>> ffffffff83cf8264 r __BTF_ID__struct__file__1027
>>>> ffffffff83cf8268 r __BTF_ID__struct__vm_area_struct__1028
>>>> ffffffff83cf826c r bpf_skb_output_btf_ids
>>>> 
>>>> Did I miss something?
>>>> 
>>>> Thanks,
>>>> Song
>>>> 
>>> 
>>> I will release the syzbot bug, so that you can use its .config
>>> 
>>> Basically, we have
>>> 
>>> u32 btf_task_struct_ids[1];
>> 
>> That is, if  
>> 
>> # CONFIG_DEBUG_INFO_BTF is not set
>> 
> 
> This is how btf_sock_ids gets defined :
> 
> #ifdef CONFIG_DEBUG_INFO_BTF
> BTF_ID_LIST_GLOBAL(btf_sock_ids)
> #define BTF_SOCK_TYPE(name, type) BTF_ID(struct, type)
> BTF_SOCK_TYPE_xxx
> #undef BTF_SOCK_TYPE
> #else
> u32 btf_sock_ids[MAX_BTF_SOCK_TYPE];
> #endif
> 
> 
> Perhaps do the same for btf_task_struct_ids ?

Yeah, I was testing something below, but this one looks better. 

Shall I include syzbot link for the fix?

Thanks,
Song




diff --git i/include/linux/btf_ids.h w/include/linux/btf_ids.h
index 47d9abfbdb556..4153264c1236b 100644
--- i/include/linux/btf_ids.h
+++ w/include/linux/btf_ids.h
@@ -149,7 +149,7 @@ extern struct btf_id_set name;
 #define BTF_ID_LIST(name) static u32 name[5];
 #define BTF_ID(prefix, name)
 #define BTF_ID_UNUSED
-#define BTF_ID_LIST_GLOBAL(name) u32 name[1];
+#define BTF_ID_LIST_GLOBAL(name) u32 name[3];
 #define BTF_ID_LIST_SINGLE(name, prefix, typename) static u32 name[1];
 #define BTF_ID_LIST_GLOBAL_SINGLE(name, prefix, typename) u32 name[1];
 #define BTF_SET_START(name) static struct btf_id_set name = { 0 };



