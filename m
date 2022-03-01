Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00D934C98B8
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 00:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbiCAXCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 18:02:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiCAXCE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 18:02:04 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D913B79397;
        Tue,  1 Mar 2022 15:01:21 -0800 (PST)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 221GjKXk010804;
        Tue, 1 Mar 2022 15:01:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=qLQe8g0xzTf5HmrMjmUzanWC/6GuiPLuzESNTOQxNAY=;
 b=IXe5vRcLJVfcnh+XTlHmItwbtC1HQftsOZq2ByeihybaqYxHspCoaskEIrx+JBc1Ylg7
 uGkvGURarcfJa3oNGm/BbuRx6nMdv/T23xNBQQPAMpFs+1d4XKcg5ZCf3BBkVtM7q9cr
 siST1GZKC+mkAoFo4jZmrcM9H+QvuP/me5k= 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ehn3e3qp7-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Mar 2022 15:01:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JbFm8JppUb6Pb4DnSoN6PjQhZPFzEcmONrrMc0/FVT8ums2NO3RShiQb62BtrcIi9NX2xJM4p6ZESpd3GivTrI2+TUvz1HkrQRCCL2TXg50xcwarmngwIqmO+PRh0mSzkf2xBtxDB35WrOrJNpX8alLtOKq766c69Fvs4YCBQd7/9A0fi8FAjQYPlodM7agYerciYR8W/UkYtA23NlvKA0POe79EeAQeKoZaA1jarq0Ll9azsSRO2f5u4dk573IrUrWKvfGuQ/Ade0bm3eF/hUPn/WHXsjMA/nIRinlDTQUpTzJ+mWYB7R8SQFFZSkEBnonBzhMm+mHHxNRfdlMqow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qLQe8g0xzTf5HmrMjmUzanWC/6GuiPLuzESNTOQxNAY=;
 b=LGVrAdMN2I2JKWIF+nR7jehEzBIs5hWOWTlMiRnB/yx2Ue8YhV0WibMb+CX40YDnvZbt2rZhVDqOD+XmzVLDoR4Zwz4eBefpX/ESIsWLizaYI93mWPN8obVsn7V3HhjeA9CN+c9T9L13/1LfWqkP8+RF6DvmZzPo5xkIYy/fBquMN3tuhLUlLSNAbzrZjEXC30PD0viQVUkL+qUKVe/O/rQMu8SAT38oqKFOP8al79JYwBjE7lUdoRWyvDofew+np9jgOUwYBx3jsIM8IjzPIlRmAtENbsiZVELK0NLUfKie90YaRj+fCUsxDPKhr0KDp2e8M2+kFbPCO8MMlQ4VTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by DM5PR1501MB2168.namprd15.prod.outlook.com (2603:10b6:4:a8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Tue, 1 Mar
 2022 23:01:15 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7da4:795a:91b8:fa54]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7da4:795a:91b8:fa54%7]) with mapi id 15.20.5017.027; Tue, 1 Mar 2022
 23:01:15 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     Song Liu <song@kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH bpf-next 2/2] bpf: flexible size for bpf_prog_pack
Thread-Topic: [PATCH bpf-next 2/2] bpf: flexible size for bpf_prog_pack
Thread-Index: AQHYHklKCIaff07zEkyT+B5ekpbKEqyMcwwAgACNNQCAAWxqgIAAVccAgByBeQA=
Date:   Tue, 1 Mar 2022 23:01:15 +0000
Message-ID: <DD3E07A4-3DFE-478B-85BC-408A7DAFF0B2@fb.com>
References: <20220210064108.1095847-1-song@kernel.org>
 <20220210064108.1095847-3-song@kernel.org>
 <34d0ed40-30cf-a1a2-f4eb-fa3d0a55bce8@iogearbox.net>
 <A3FB68F3-34DC-4598-8C6B-145421DCE73E@fb.com>
 <dd6dee71-94d7-5393-8fe6-c667938ebfac@iogearbox.net>
 <14B98886-D56E-4FE5-89F6-3A41D35B7105@fb.com>
In-Reply-To: <14B98886-D56E-4FE5-89F6-3A41D35B7105@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.60.0.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 41e3124f-c96c-4cfa-ced4-08d9fbd7637f
x-ms-traffictypediagnostic: DM5PR1501MB2168:EE_
x-microsoft-antispam-prvs: <DM5PR1501MB2168A81F719AB1FA1246011BB3029@DM5PR1501MB2168.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bjd+ZPf+sMypJo5Glai0UTGVVmGJkifiWy5seFH4PARkaMoq4XjYVCar3/1sZEzYCrCWtARAUorcuYWUhuocHvKmy2BCu9p9Z0Urb1/sw0bJqJ0Xxxkh9x+9GSWWLPHA8mwvPtetXqsyxyr5Vc7zWp323N7W4595Xrpnolj3Uli6/Iuoxpk7EAOV+XIOY2GaWip5FEqkwqSd0DLzyyzat491UPih5e7kxXCe+57+AgUZ0iaU/iv6kwsQ9Up1oSTQY+tJlPf7jRUXrTPfBG8L9np/TTGYhLJocRkxYAdfYrqI2iTY5H2RPIncGxCmn4iVhMaXvIhWf7Ld80LephMcKHL4KneuhlsS4ZSyojQRLDy/SB8xAAqtuNIiSd8r9h2sWxdZnMz1Anr4flGEsISSEiCaM52xZqKjwRam9HbASNOWsk9r26hyCI+HaXAwnzoIIzoFqdXcOvSsXsYlJZPZ7PkNtFRO+nVCmgSSiChxPYAFxRAlw3d1ec1VyZUeZODxWf+kSY6IXpGzHjpYQ7J6CEkn8bKPwIfYd6lv/brosi5GR0wLC7W8oMmlF5CMrI5oWmC/TQ9BuEDU8ionIUiMiDKr7NlHVvbu7OfAPqR1OINw/tuKprPDku7/upoxcng8C/szdaXOCknSE9x1/2coBm6eK4hNHpAuc3Uu/MPF0nHLZya2lhqazUFMD+pWobfwwi5IpbdlDb5GGQ96o6yeSsng5sGdoAcigqoZf097O9MsarQL6hBmQfQ0YL2YDvAP
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(2906002)(33656002)(36756003)(6512007)(186003)(6916009)(2616005)(6486002)(8936002)(54906003)(7416002)(66556008)(508600001)(86362001)(5660300002)(66476007)(53546011)(66446008)(6506007)(64756008)(66946007)(38100700002)(91956017)(76116006)(4326008)(122000001)(8676002)(83380400001)(38070700005)(71200400001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Gd/tNN531VUO9qTv/Wxj6ydkwHPCqeMZRaF/jfftFL8BVXhGbRYFEWwZ0aYv?=
 =?us-ascii?Q?9rs1QS9ddjK+s93TtGbAytG7+HcO/N1zV0OKi93RtCe8FhvCi7JF2qWRyNgy?=
 =?us-ascii?Q?+Jja0qGrA+gSf0TLf0T3S4Ic2Uz+3StvFsEwxaaDgJ+kjhg24AiZsEEMopqJ?=
 =?us-ascii?Q?aw8MXQSlMz1Elvda0gU8VqiWlwfLG7R5FNpkRvEHoPKrIHhC+0Ov+nhxaHv5?=
 =?us-ascii?Q?ILOPreDlQKIafOlvvoJF4EcjFkDwUzraiy81f8dqdFAsbo5RlkaxMiwMlH3p?=
 =?us-ascii?Q?CDJnt4yDqoXrJmxSwMtvBfg/kXZhYzopytTnjEPNnjbhQrJSaSgz+riqSURB?=
 =?us-ascii?Q?/RDUmLPJeqQmmu1WLMbq2qAE1G65BIMPO6DuIAPRZReoXyc2okrz8pA4U2kj?=
 =?us-ascii?Q?UkUhSeM2gFmHAonZ3M2OHaezCxxRiy3kfo8lzRhyhaiMfYH3GnJ67GH76AXi?=
 =?us-ascii?Q?hytpYSasmKX7tdj9+a0LpTqpcPP1v0BqTP62MRby3tVWU2SRit4yv6gMJLG3?=
 =?us-ascii?Q?4cTVH3HtHsfYcICAN86lfmDIt2CBsfeCUt4fGAcpmjBZHQZ+JglGuJc6Y55z?=
 =?us-ascii?Q?oXdV9dkOMb3ZKeOPtgxCS2sWdjSJLjuMgU5MrH+nloHksYzUg2SZjapy0npV?=
 =?us-ascii?Q?z+4KvVWIXRu5oiS3B1zX9JDbBP/gjkraAijtBUEtfVOynlZCQqNhJhJ3AnfC?=
 =?us-ascii?Q?Rf2SfrCOwwYw9uQSj2cF6oxXl1x2EKVUMjjxVhbMS0XuqRQgBETbsna0OBkf?=
 =?us-ascii?Q?rAoclhm3ffONhqYRHKAmj+FH2o8agvdPyvW2EN354VsSg/PhD/zmpGFfTJl5?=
 =?us-ascii?Q?Y3R1bGkF2w79knceLCHA0qbopMo+B1i1hVFkL0RdSZY54/LtHtd/V+cV0TRR?=
 =?us-ascii?Q?aqf078bsDTGUTdhPo5hYbpby+WjzorniXvShzxG6u5wZeMSUAzYkazIPdDua?=
 =?us-ascii?Q?X/JTdtdry1qYBNbKZCd3cZ9AW+PzEpWtMhHAJd2UBv9R2BiTDflnjutMGMlT?=
 =?us-ascii?Q?NPRDrpAFRjf5aJIRMXYDSDxifed+zPfKS3k9pcTVmNPzxPbXdxpNicujNeeC?=
 =?us-ascii?Q?adeLj8yVS6LfOb1JpEnqHEArPs4pHIp1dYw7atdLZjebjVox6lMRG2S+2cFd?=
 =?us-ascii?Q?+59bJa52V/9/b9NdM581oM3JHk0sukjjAlrL+IZDMjW6sJNVrw+PrR5nawaa?=
 =?us-ascii?Q?LqGvkfjCNHUTkQYPIderrjSGhLRoGVJlGciRPdKwRMq7t2dsSJpEBTLQg68B?=
 =?us-ascii?Q?141FvUGDvD6+2BMnf7LIH2w32DMVIwzNADp3Z8WyRVrKyOo1dpna49onV4x5?=
 =?us-ascii?Q?v/n3PTxss0WR2ocq4bZGck5JNDte+RalfudvZ0lSraWHmhZJfbj6yg/2JHSn?=
 =?us-ascii?Q?ykDP+9smTUDkHFrf/DWcfoKaagqRZvimqWhDY9lzmvRbtqpT/Ie4wFABcMcy?=
 =?us-ascii?Q?KS3TmZ5oqmSMQJinIUfkO81YxSHQJSzaKqyP3ttNhM7JGQnKIiDsFOkd5o9Q?=
 =?us-ascii?Q?8qRGINTkIqnBMpXs52g4orhNOkAX5OSOvw9j8FSUi/niGpFxilJGZu2a8G5t?=
 =?us-ascii?Q?saFCoEaXK+Lxf1PFiu/q+zwoOxQM0H2rsxkaflcCQWBYXeRCnFyrgnLQ6dZP?=
 =?us-ascii?Q?A/MsWOQJGDD2WP9RpkL8mCVfEfgqYXgsS8ZSaamN79DAN6gSPznThr7HtzZB?=
 =?us-ascii?Q?k7k7bQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E26FF4B86BDC1C45AC053D2D9530142A@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41e3124f-c96c-4cfa-ced4-08d9fbd7637f
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2022 23:01:15.4715
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nFI7mQerWTkZ7PY6zk7pONAfXBbhRdSwi2OnW70GTRgLdM+7lzPj0/BJhHndX7AjEFp3SIpuU6MG6xLsqQ7IUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1501MB2168
X-Proofpoint-GUID: pb5tne15DLVs3KHLRP9l81wD6jLGwlEp
X-Proofpoint-ORIG-GUID: pb5tne15DLVs3KHLRP9l81wD6jLGwlEp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-01_07,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 lowpriorityscore=0
 phishscore=0 mlxscore=0 spamscore=0 suspectscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 priorityscore=1501 impostorscore=0
 clxscore=1015 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2203010114
X-FB-Internal: deliver
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Feb 11, 2022, at 11:42 AM, Song Liu <songliubraving@fb.com> wrote:
> 
> 
> 
>> On Feb 11, 2022, at 6:35 AM, Daniel Borkmann <daniel@iogearbox.net> wrote:
>> 
>> On 2/10/22 5:51 PM, Song Liu wrote:
>>>> On Feb 10, 2022, at 12:25 AM, Daniel Borkmann <daniel@iogearbox.net> wrote:
>>>> On 2/10/22 7:41 AM, Song Liu wrote:
>>>>> bpf_prog_pack uses huge pages to reduce pressue on instruction TLB.
>>>>> To guarantee allocating huge pages for bpf_prog_pack, it is necessary to
>>>>> allocate memory of size PMD_SIZE * num_online_nodes().
>>>>> On the other hand, if the system doesn't support huge pages, it is more
>>>>> efficient to allocate PAGE_SIZE bpf_prog_pack.
>>>>> Address different scenarios with more flexible bpf_prog_pack_size().
>>>>> Signed-off-by: Song Liu <song@kernel.org>
>>>>> ---
>>>>> kernel/bpf/core.c | 47 +++++++++++++++++++++++++++--------------------
>>>>> 1 file changed, 27 insertions(+), 20 deletions(-)
>>>>> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
>>>>> index 42d96549a804..d961a1f07a13 100644
>>>>> --- a/kernel/bpf/core.c
>>>>> +++ b/kernel/bpf/core.c
>>>>> @@ -814,46 +814,53 @@ int bpf_jit_add_poke_descriptor(struct bpf_prog *prog,
>>>>>  * allocator. The prog_pack allocator uses HPAGE_PMD_SIZE page (2MB on x86)
>>>>>  * to host BPF programs.
>>>>>  */
>>>>> -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>>>> -#define BPF_PROG_PACK_SIZE	HPAGE_PMD_SIZE
>>>>> -#else
>>>>> -#define BPF_PROG_PACK_SIZE	PAGE_SIZE
>>>>> -#endif
>>>>> #define BPF_PROG_CHUNK_SHIFT	6
>>>>> #define BPF_PROG_CHUNK_SIZE	(1 << BPF_PROG_CHUNK_SHIFT)
>>>>> #define BPF_PROG_CHUNK_MASK	(~(BPF_PROG_CHUNK_SIZE - 1))
>>>>> -#define BPF_PROG_CHUNK_COUNT	(BPF_PROG_PACK_SIZE / BPF_PROG_CHUNK_SIZE)
>>>>>   struct bpf_prog_pack {
>>>>> 	struct list_head list;
>>>>> 	void *ptr;
>>>>> -	unsigned long bitmap[BITS_TO_LONGS(BPF_PROG_CHUNK_COUNT)];
>>>>> +	unsigned long bitmap[];
>>>>> };
>>>>> -#define BPF_PROG_MAX_PACK_PROG_SIZE	BPF_PROG_PACK_SIZE
>>>>> #define BPF_PROG_SIZE_TO_NBITS(size)	(round_up(size, BPF_PROG_CHUNK_SIZE) / BPF_PROG_CHUNK_SIZE)
>>>>>   static DEFINE_MUTEX(pack_mutex);
>>>>> static LIST_HEAD(pack_list);
>>>>> +static inline int bpf_prog_pack_size(void)
>>>>> +{
>>>>> +	/* If vmap_allow_huge == true, use pack size of the smallest
>>>>> +	 * possible vmalloc huge page: PMD_SIZE * num_online_nodes().
>>>>> +	 * Otherwise, use pack size of PAGE_SIZE.
>>>>> +	 */
>>>>> +	return get_vmap_allow_huge() ? PMD_SIZE * num_online_nodes() : PAGE_SIZE;
>>>>> +}
>>>> 
>>>> Imho, this is making too many assumptions about implementation details. Can't we
>>>> just add a new module_alloc*() API instead which internally guarantees allocating
>>>> huge pages when enabled/supported (e.g. with a __weak function as fallback)?
>>> I agree that this is making too many assumptions. But a new module_alloc_huge()
>>> may not work, because we need the caller to know the proper size to ask for.
>>> (Or maybe I misunderstood your suggestion?)
>>> How about we introduce something like
>>>    /* minimal size to get huge pages from vmalloc. If not possible,
>>>     * return 0 (or -1?)
>>>     */
>>>    int vmalloc_hpage_min_size(void)
>>>    {
>>>        return vmap_allow_huge ? PMD_SIZE * num_online_nodes() : 0;
>>>    }
>> 
>> And that would live inside mm/vmalloc.c and is exported to users ...
> 
> Yeah, this will go to vmalloc.c.
> 
>> 
>>>    /* minimal size to get huge pages from module_alloc */
>>>    int module_alloc_hpage_min_size(void)
>>>    {
>>>        return vmalloc_hpage_min_size();
>>>    }
>> 
>> ... and this one as wrapper in module alloc infra with __weak attr?
> 
> And this goes to some module.c file(s). I am not quite sure whether we
> need __weak attr or not. 
> 
>> 
>>>    static inline int bpf_prog_pack_size(void)
>>>    {
>>>        return module_alloc_hpage_min_size() ? : PAGE_SIZE;
>>>    }
>> 
>> Could probably work. It's not nice, but at least in the corresponding places so it's
>> not exposed / hard coded inside bpf and assuming implementation details which could
>> potentially break later on.
> 
> I don't really like it either. 
> 
> Another way to do this is to test the required size for bpf_prog_pack 
> in BPF code, something like the following. The pro of this version is 
> that we don't need changes in vmalloc and module code. 

Hi Daniel, 

Do you have further suggestions on this? I personally like the following
version best, as all the changes are limited to bpf/core.c. 

Thanks,
Song

> diff --git i/kernel/bpf/core.c w/kernel/bpf/core.c
> index 44623c9b5bb1..3cfd0f0c93d2 100644
> --- i/kernel/bpf/core.c
> +++ w/kernel/bpf/core.c
> @@ -814,15 +814,9 @@ int bpf_jit_add_poke_descriptor(struct bpf_prog *prog,
>  * allocator. The prog_pack allocator uses HPAGE_PMD_SIZE page (2MB on x86)
>  * to host BPF programs.
>  */
> -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -#define BPF_PROG_PACK_SIZE     HPAGE_PMD_SIZE
> -#else
> -#define BPF_PROG_PACK_SIZE     PAGE_SIZE
> -#endif
> #define BPF_PROG_CHUNK_SHIFT   6
> #define BPF_PROG_CHUNK_SIZE    (1 << BPF_PROG_CHUNK_SHIFT)
> #define BPF_PROG_CHUNK_MASK    (~(BPF_PROG_CHUNK_SIZE - 1))
> -#define BPF_PROG_CHUNK_COUNT   (BPF_PROG_PACK_SIZE / BPF_PROG_CHUNK_SIZE)
> 
> struct bpf_prog_pack {
>        struct list_head list;
> @@ -830,30 +824,56 @@ struct bpf_prog_pack {
>        unsigned long bitmap[];
> };
> 
> -#define BPF_PROG_MAX_PACK_PROG_SIZE    BPF_PROG_PACK_SIZE
> #define BPF_PROG_SIZE_TO_NBITS(size)   (round_up(size, BPF_PROG_CHUNK_SIZE) / BPF_PROG_CHUNK_SIZE)
> 
> +static int bpf_prog_pack_size = -1;
> +
> +static inline int bpf_prog_chunk_count(void)
> +{
> +       WARN_ON_ONCE(bpf_prog_pack_size == -1);
> +       return bpf_prog_pack_size / BPF_PROG_CHUNK_SIZE;
> +}
> +
> static DEFINE_MUTEX(pack_mutex);
> static LIST_HEAD(pack_list);
> 
> static struct bpf_prog_pack *alloc_new_pack(void)
> {
>        struct bpf_prog_pack *pack;
> +       void *ptr;
> +       int size;
> 
> -       pack = kzalloc(sizeof(*pack) + BITS_TO_BYTES(BPF_PROG_CHUNK_COUNT), GFP_KERNEL);
> -       if (!pack)
> +       /* Test whether we can get huge pages. If not just use PAGE_SIZE
> +        * packs.
> +        */
> +       if (bpf_prog_pack_size == -1) {
> +               size = PMD_SIZE * num_online_nodes();
> +               ptr = module_alloc(size);
> +               if (is_vm_area_hugepages(ptr)) {
> +                       bpf_prog_pack_size = size;
> +                       goto got_ptr;
> +               } else {
> +                       bpf_prog_pack_size = PAGE_SIZE;
> +                       vfree(ptr);
> +               }
> +       }
> +
> +       ptr = module_alloc(bpf_prog_pack_size);
> +       if (!ptr)
>                return NULL;
> -       pack->ptr = module_alloc(BPF_PROG_PACK_SIZE);
> -       if (!pack->ptr) {
> -               kfree(pack);
> +got_ptr:
> +       pack = kzalloc(sizeof(*pack) + BITS_TO_BYTES(bpf_prog_chunk_count()), GFP_KERNEL);
> +       if (!pack) {
> +               vfree(ptr);
>                return NULL;
>        }
> -       bitmap_zero(pack->bitmap, BPF_PROG_PACK_SIZE / BPF_PROG_CHUNK_SIZE);
> +       pack->ptr = ptr;
> +       bitmap_zero(pack->bitmap, bpf_prog_pack_size / BPF_PROG_CHUNK_SIZE);
>        list_add_tail(&pack->list, &pack_list);
> 
>        set_vm_flush_reset_perms(pack->ptr);
> -       set_memory_ro((unsigned long)pack->ptr, BPF_PROG_PACK_SIZE / PAGE_SIZE);
> -       set_memory_x((unsigned long)pack->ptr, BPF_PROG_PACK_SIZE / PAGE_SIZE);
> +       set_memory_ro((unsigned long)pack->ptr, bpf_prog_pack_size / PAGE_SIZE);
> +       set_memory_x((unsigned long)pack->ptr, bpf_prog_pack_size / PAGE_SIZE);
>        return pack;
> }
> 
> @@ -864,7 +884,7 @@ static void *bpf_prog_pack_alloc(u32 size)
>        unsigned long pos;
>        void *ptr = NULL;
> 
> -       if (size > BPF_PROG_MAX_PACK_PROG_SIZE) {
> +       if (size > bpf_prog_pack_size) {
>                size = round_up(size, PAGE_SIZE);
>                ptr = module_alloc(size);
>                if (ptr) {
> @@ -876,9 +896,9 @@ static void *bpf_prog_pack_alloc(u32 size)
>        }
>        mutex_lock(&pack_mutex);
>        list_for_each_entry(pack, &pack_list, list) {
> -               pos = bitmap_find_next_zero_area(pack->bitmap, BPF_PROG_CHUNK_COUNT, 0,
> +               pos = bitmap_find_next_zero_area(pack->bitmap, bpf_prog_chunk_count(), 0,
>                                                 nbits, 0);
> -               if (pos < BPF_PROG_CHUNK_COUNT)
> +               if (pos < bpf_prog_chunk_count())
>                        goto found_free_area;
>        }
> 
> @@ -904,12 +924,12 @@ static void bpf_prog_pack_free(struct bpf_binary_header *hdr)
>        unsigned long pos;
>        void *pack_ptr;
> 
> -       if (hdr->size > BPF_PROG_MAX_PACK_PROG_SIZE) {
> +       if (hdr->size > bpf_prog_pack_size) {
>                module_memfree(hdr);
>                return;
>        }
> 
> -       pack_ptr = (void *)((unsigned long)hdr & ~(BPF_PROG_PACK_SIZE - 1));
> +       pack_ptr = (void *)((unsigned long)hdr & ~(bpf_prog_pack_size - 1));
>        mutex_lock(&pack_mutex);
> 
>        list_for_each_entry(tmp, &pack_list, list) {
> @@ -926,8 +946,8 @@ static void bpf_prog_pack_free(struct bpf_binary_header *hdr)
>        pos = ((unsigned long)hdr - (unsigned long)pack_ptr) >> BPF_PROG_CHUNK_SHIFT;
> 
>        bitmap_clear(pack->bitmap, pos, nbits);
> -       if (bitmap_find_next_zero_area(pack->bitmap, BPF_PROG_CHUNK_COUNT, 0,
> -                                      BPF_PROG_CHUNK_COUNT, 0) == 0) {
> +       if (bitmap_find_next_zero_area(pack->bitmap, bpf_prog_chunk_count(), 0,
> +                                      bpf_prog_chunk_count(), 0) == 0) {
>                list_del(&pack->list);
>                module_memfree(pack->ptr);
>                kfree(pack);
> 
> 

