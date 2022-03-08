Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15B434D1EC7
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 18:21:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbiCHRVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 12:21:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349076AbiCHRVY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 12:21:24 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74FF0546A5;
        Tue,  8 Mar 2022 09:19:53 -0800 (PST)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 228A4svj009775;
        Tue, 8 Mar 2022 09:19:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=KRP0GUvzzmJDYSGO4f9mqdkCU+0/vzpWvadyggwNWpI=;
 b=QuYNxZItvIBiVl1eSTtMOTg2KXNSoseCb+/OBuab5LG4yBA3TZv4f9BqBJnCPPJO//cR
 ypv836bX/i+4jyVNuzJWR8veL8tx/uXtI++fx9w6Hn8ROueV8UPLBgOXBK3Qi0/60NaM
 sYU3UFGq7GgmnXPfOWmZZPzfSn+nVssTvd0= 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ep52tjqdy-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Mar 2022 09:19:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FcOjQiZ1YhRqutdC9i1mqN+h0ryF77LNeupRPpdG1B+hr+M2ad1U8U1QJ474LqQ9nqVAQ89/UULLCR7LgqVZs+Y/HW2jK9dPP4Ly6zpduy2sYPhR4Z8AlnDn1/xUM/AYTggJWMGgLQq4R12NNdKQ7bbACRzacQe8IWnxuGycA5DgNa3CpRhKDiz1Dw8s6uY108mGTKRUH5A8eJzbHYl0LVbo5yfL+Krr4ue+N/P68AZEGRjZSVeHEquZxQQNf1rXZ0jN/mAXDcT9/cxyKulL9u70qNoaAhKlXOy9wiNt9/Qpm8va+qEyJSKpScLCqasESGpf3L3NGBHrveCDEmd91Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KRP0GUvzzmJDYSGO4f9mqdkCU+0/vzpWvadyggwNWpI=;
 b=h7m5syurli7sudDRaA67W3vkU/3n4kj27WSMbYH0pkH5iPRIDxCPA8Aow1sA3P7cuv1g7CVB/2Cpf1CfhD+A3mEXgTfuIe0J9vX67C/98S6awsti6o69MwKcqdk/dvcwZ7VFcavKM8oN0rNnWlBmbDAgGfUj0IMhNI2evwH6LLrEKlnS/ueF1pL4N3pj9xyi02vWB6Y3DXNhX5VUXdlORW7cK5qfsEtHlHG18B547oUobDWqi13EM2rE6SyhWmAntwyQVstabUBMySDy0sGiuQGwho2OxMY5OTU54WNk4TAUACy6Thw8KgbwpxY7WqoiJozyG/JVLcXEXxyk6zRhWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by DM6PR15MB3863.namprd15.prod.outlook.com (2603:10b6:5:2b6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Tue, 8 Mar
 2022 17:19:50 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7da4:795a:91b8:fa54]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7da4:795a:91b8:fa54%7]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 17:19:50 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     Song Liu <song@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "andrii@kernel.org" <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "edumazet@google.com" <edumazet@google.com>
Subject: Re: [PATCH bpf-next] bpf: select proper size for bpf_prog_pack
Thread-Topic: [PATCH bpf-next] bpf: select proper size for bpf_prog_pack
Thread-Index: AQHYL/fEiFkJ4O2/t0yRT6QAA+PKx6y1u3kAgAAGBYA=
Date:   Tue, 8 Mar 2022 17:19:49 +0000
Message-ID: <FE4A0984-E31A-485F-BC63-E87888C3CC5D@fb.com>
References: <20220304184320.3424748-1-song@kernel.org>
 <c0be971d-c03e-abcb-83fd-d0b087e38780@iogearbox.net>
In-Reply-To: <c0be971d-c03e-abcb-83fd-d0b087e38780@iogearbox.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.60.0.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f9fe565c-5f35-4123-d3c1-08da0127da13
x-ms-traffictypediagnostic: DM6PR15MB3863:EE_
x-microsoft-antispam-prvs: <DM6PR15MB386363B59A5353457FDA8417B3099@DM6PR15MB3863.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WfODJFszN+G9aguI08O5+7zwhe08xo/AirHhtwlwAkPryRsN1eg3V3McXKtHfDItWxh/Kp8Y5oM76MI0YU4WL2+3DnfvRf51+2BMn40XZrJzdTkADw5HPV+Pj+nhNPt3UP2ENeuKwqiz24SLN/NOI23gWXPQeHQCWX01N8tMe4mqzIl1mM2P3lBIeIH3Oo9KSI+wC8+vmCbEi5OxN2WxZYR+x5ueb+uKUjNJzp7UYQV56UjIvx072sXsCP5AZQJK2HTkMMEcOblegMPLvRP3LSWa+IVIX50XZ5Bp+VwrV0GEoU1mxAAqDTyDbhTh+votmYcCPo0B/gJHPgVlJluKJtwiJ3B2j2dH8qfeH83gEttCcSHgS/m6WUu/Bpq9OwAHhZT6/2T0D2tpT3Q+dHX9+yDi54vYBT9lYQ5A+yC6n/V/wrXn43W/Yp0eDQvz7CqA4WZ0IdgPkO0yC9lLIeX+YBfpupOar1C3T2BQIUDE1FeGKXRPX+89poA6verUDlEpo5e4cs1xdtUHKqRfjYKqGB8FWsUiplzgn36oxI4hv4o3ZVEiynIImIzIBcx2JOfIcKJKDMSEIkLwoIz4xl/hjrGePtf3YHdbYHk2xByg9KMeewa+I3h4D5/1SBDEuwbD0LkA0Qt6vq4vvo2Pv7iYyuKwHAkqSQmNolS6XZiybrNGaSFF6Sv0J0rjkZWWeO2sGmEF++uGtBXR5Mk2kYeka4bsuAvEJFC7g5faErQJJEuc2vsYkop5B/rLW7SEiaAq
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(6916009)(38070700005)(6512007)(71200400001)(6486002)(83380400001)(54906003)(316002)(4326008)(8676002)(64756008)(66446008)(66556008)(6506007)(86362001)(53546011)(66946007)(66476007)(8936002)(508600001)(122000001)(91956017)(76116006)(38100700002)(36756003)(186003)(33656002)(2906002)(2616005)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xdkNyNSnzJOyjONwTrOw04nJQ74CantkrPoKV56JUGy1JQAZJ5kdSQh4Crhv?=
 =?us-ascii?Q?QDHR8CloY5Ye1jsiVf3Za+cjgvjKOLPxJeL+qSJiaOrJt8tNquP8d3+Mi6Ne?=
 =?us-ascii?Q?6a5SEiIY5PR5Z7Zr9yfsc0PFO8RkfVIxQQb+PDTDiAIDjHHP9n7PDxChR07K?=
 =?us-ascii?Q?nxo4/98roiA12m8qRD2eLsruBtoagcmfECd9aeIIXu0qtYofbCMjd2kDDW2l?=
 =?us-ascii?Q?6DOpJbJZHVWmQ1Vi2TqojmHYrAbsHpb/O5oiiufaXPpv5kvRJwUQBy9bg+GZ?=
 =?us-ascii?Q?qHEiS3MUAgNkU8QFfqXzu++OFt9SB9pTZ5MZLCMQrWPN9h/PKmaw9gXk+34+?=
 =?us-ascii?Q?/s5A4zbv7MVd+VtDZl9OS/QheL1xvjvwpzrup5Jd3PHigNeSjnVbO/xLpVB+?=
 =?us-ascii?Q?ZwpajcnI8y8sV9wajuzIs9ys4RWAlkknP7aj6ILwLOQdW+oAsUDbgBiG7BKX?=
 =?us-ascii?Q?tzfJ1CRPHK5GDG+GipKOVHtvzqTkRaiEJ7EoCZ76Fac17bbFxGtsOo3Wv0Zx?=
 =?us-ascii?Q?lFQo4NJNOTs31iWPUl87qq2l+AWfBrUrT/+1fRhsHq12dFcfgWsYcWwDmD0Y?=
 =?us-ascii?Q?dwLcYBnhMrWcTv3tuwsYLjcmiZ87RVp45OXLAmrgW507rKADXBeWwoIce2Ql?=
 =?us-ascii?Q?RN0/hLkQoVIX3b3pL2eMEepeF+36t4cuP15Jx79/8uE/VU5MRTUXOqWzvHWZ?=
 =?us-ascii?Q?1FYpfbAfaZQz3WSVdRLhz5JtE4hncU9Ql8KEx5fZ4OE6Y5X+RtauljQ/jr/+?=
 =?us-ascii?Q?3dRj+m091jkUnX9GAm1K3qiWlzQQDlXUN1LS0LEIABJeNXGRKtn2F/b/as6g?=
 =?us-ascii?Q?yCZEFauVhP6Wf7LOzBpCBDw1H/0yEiPEpuQLvpmC7MgxaRnpbdC2eYWH2giO?=
 =?us-ascii?Q?9zrsnG4IJplLj0gEzCIgUb5TVpHI8ENTu770kCVtnvAPlBANYSZoG62RbL0p?=
 =?us-ascii?Q?HK7KPMMnitla/H9962x6bE5RPWL1x8pVy2sPiABswHPxsFxid8x8FyOSEhkp?=
 =?us-ascii?Q?E3oTm73U1oqdZ0h2x2zra3t8xFZ8GtXNhrfMRYkbwwGnzbb+LjfeC47/z+N0?=
 =?us-ascii?Q?Dkf2lbqLUkRRrXvLhs5WFsRRtb/QY9H+Ed6kgv20hy4j9L85kVRz4I/uJREZ?=
 =?us-ascii?Q?ipb+gXZ9hPYkjCtD1K9OgR7xD1hi2YxP7ygYRrZUErhTQfuDIfInkil2qaYX?=
 =?us-ascii?Q?9wperx8oJ7vfTs4e3Bqv0VXcd28M/hBDjmpffFdYHpGJPecDw/RgilFGx3hp?=
 =?us-ascii?Q?A4Gr50jpDkhWz6K2Hi57p/PbbXwMnk82rkzPjSy18jGdRJ84tdcZ62y5ErlF?=
 =?us-ascii?Q?0eb5DF2DZz76/cDSn4femcyOxwCikYcYigLNo0Iy1+rgQSc40fKx2mtZQCP2?=
 =?us-ascii?Q?HNJkykhxgMAoMn42F8YYH3+iUU6nybre+vLBZZiQw07uvorFwe18ZZN44xvB?=
 =?us-ascii?Q?rqyVr3R9sjZG3uL6Df+0JDRkG8+Mai5a9xpWAvgfpXcwU4Rn3yY7zOp/3qu8?=
 =?us-ascii?Q?hsBTyNxcJETSePLXcz2f7GwwvcfMl0FeMJrd3axf75qkm7qnyYhNFZ/qmDPz?=
 =?us-ascii?Q?gjDbb1jfq6M4Jec39yJCZwInJ3ues9iOR39JxZ8fWl7KW3xsOlWPNIS3HRJq?=
 =?us-ascii?Q?2ts7lxpidx8izGTKrHm5hlHpy30VoBaVolQcbqEB/RKVaYeWBeFLoW0/LWYx?=
 =?us-ascii?Q?+POpaA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <72F9315DED51A74F86066C8067EF4820@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9fe565c-5f35-4123-d3c1-08da0127da13
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2022 17:19:49.9650
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HBM/hk9G/ia7Iu8qB9c7dq7T/lXlo6dsIr2Um7dnMKG/1G4Nvk3zsPfKeuX4mMkipK18EX2jmi3ZHEOF9Wsy/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3863
X-Proofpoint-ORIG-GUID: qJZe3CZvos6TOXCSJaATmDMcCGJxM8IK
X-Proofpoint-GUID: qJZe3CZvos6TOXCSJaATmDMcCGJxM8IK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-08_06,2022-03-04_01,2022-02-23_01
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 8, 2022, at 8:58 AM, Daniel Borkmann <daniel@iogearbox.net> wrote:
> 
> On 3/4/22 7:43 PM, Song Liu wrote:
>> Using HPAGE_PMD_SIZE as the size for bpf_prog_pack is not ideal in some
>> cases. Specifically, for NUMA systems, __vmalloc_node_range requires
>> PMD_SIZE * num_online_nodes() to allocate huge pages. Also, if the system
>> does not support huge pages (i.e., with cmdline option nohugevmalloc), it
>> is better to use PAGE_SIZE packs.
>> Add logic to select proper size for bpf_prog_pack. This solution is not
>> ideal, as it makes assumption about the behavior of module_alloc and
>> __vmalloc_node_range. However, it appears to be the easiest solution as
>> it doesn't require changes in module_alloc and vmalloc code.
> 
> nit: Fixes tag?
> 
>> Signed-off-by: Song Liu <song@kernel.org>
> [...]
>>  +static size_t bpf_prog_pack_size = -1;
>> +
>> +static inline int bpf_prog_chunk_count(void)
>> +{
>> +	WARN_ON_ONCE(bpf_prog_pack_size == -1);
>> +	return bpf_prog_pack_size / BPF_PROG_CHUNK_SIZE;
>> +}
>> +
>>  static DEFINE_MUTEX(pack_mutex);
>>  static LIST_HEAD(pack_list);
>>    static struct bpf_prog_pack *alloc_new_pack(void)
>>  {
>>  	struct bpf_prog_pack *pack;
>> +	size_t size;
>> +	void *ptr;
>>  -	pack = kzalloc(sizeof(*pack) + BITS_TO_BYTES(BPF_PROG_CHUNK_COUNT), GFP_KERNEL);
>> -	if (!pack)
>> +	if (bpf_prog_pack_size == -1) {
>> +		/* Test whether we can get huge pages. If not just use
>> +		 * PAGE_SIZE packs.
>> +		 */
>> +		size = PMD_SIZE * num_online_nodes();
>> +		ptr = module_alloc(size);
>> +		if (ptr && is_vm_area_hugepages(ptr)) {
>> +			bpf_prog_pack_size = size;
>> +			goto got_ptr;
>> +		} else {
>> +			bpf_prog_pack_size = PAGE_SIZE;
>> +			vfree(ptr);
>> +		}
>> +	}
>> +
>> +	ptr = module_alloc(bpf_prog_pack_size);
>> +	if (!ptr)
>>  		return NULL;
>> -	pack->ptr = module_alloc(BPF_PROG_PACK_SIZE);
>> -	if (!pack->ptr) {
>> -		kfree(pack);
>> +got_ptr:
>> +	pack = kzalloc(struct_size(pack, bitmap, BITS_TO_LONGS(bpf_prog_chunk_count())),
>> +		       GFP_KERNEL);
>> +	if (!pack) {
>> +		vfree(ptr);
>>  		return NULL;
>>  	}
>> -	bitmap_zero(pack->bitmap, BPF_PROG_PACK_SIZE / BPF_PROG_CHUNK_SIZE);
>> +	pack->ptr = ptr;
>> +	bitmap_zero(pack->bitmap, bpf_prog_pack_size / BPF_PROG_CHUNK_SIZE);
>>  	list_add_tail(&pack->list, &pack_list);
>>    	set_vm_flush_reset_perms(pack->ptr);
>> -	set_memory_ro((unsigned long)pack->ptr, BPF_PROG_PACK_SIZE / PAGE_SIZE);
>> -	set_memory_x((unsigned long)pack->ptr, BPF_PROG_PACK_SIZE / PAGE_SIZE);
>> +	set_memory_ro((unsigned long)pack->ptr, bpf_prog_pack_size / PAGE_SIZE);
>> +	set_memory_x((unsigned long)pack->ptr, bpf_prog_pack_size / PAGE_SIZE);
>>  	return pack;
>>  }
>>  @@ -864,7 +886,7 @@ static void *bpf_prog_pack_alloc(u32 size)
>>  	unsigned long pos;
>>  	void *ptr = NULL;
>>  -	if (size > BPF_PROG_MAX_PACK_PROG_SIZE) {
>> +	if (size > bpf_prog_pack_size) {
>>  		size = round_up(size, PAGE_SIZE);
>>  		ptr = module_alloc(size);
>>  		if (ptr) {
> 
> What happens if the /very first/ program requests an allocation size of >PAGE_SIZE? Wouldn't
> this result in OOB write?
> 
> The 'size > bpf_prog_pack_size' is initially skipped due to -1 but then the module_alloc()
> won't return a huge page, so we redo the allocation with bpf_prog_pack_size as PAGE_SIZE and
> return a pointer into this pack?

Good catch! Let me see how to fix this.

Thanks,
Song

