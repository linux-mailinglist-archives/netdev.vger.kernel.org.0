Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 118654B05F8
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 07:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234865AbiBJF74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 00:59:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234843AbiBJF7z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 00:59:55 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D763C10CD;
        Wed,  9 Feb 2022 21:59:56 -0800 (PST)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 219NYHu9008224;
        Wed, 9 Feb 2022 21:59:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=AYZpWdiRIjU39RhPx34u+s3W5+B/i6VGlSOQnKMjchI=;
 b=IDqMGko8s0dmCPW7F/ATNMgkgI1nLDyYPuSfi1c4FKONUMp+CmQ6ddFT8I0Ir+5NS4wp
 Fi0wSM82BKCCYEMkVBTq0EfXhG3/RBPrX5ZhIDyYS8xT4X1LL6qdZK2yc9wXILI6OwS0
 coxFpGMrmXg3/O5PgJ+Hiaq9oVoP3ni7/pk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e4fyk579k-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 09 Feb 2022 21:59:55 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 9 Feb 2022 21:59:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=he3xGknk5bXERoqTjHzuFCLqJ0jNaQU2+c9T8jh2x0THfuQMiNnZpDFMQBTTG76lHSqJTaYomMXl4SNxsJ5F18C9JrFLgmHtzSrMt+SJ/QRQTSwe9XAIb8hmO+uBoornvuJ4U5J6y/5P9LnI5M37gYJYPnTCbKPojcDV0zMM0lZPqxELnHTs0yzmF0g8J+K0WTbPYerPPQVUs8xhSW0/jw46OCon2BFb9EvJy9E7iFWL8NxMGktmyZ1DCZXfnc8TyNTGoUsiYwhTIhoY+9N7tuZ2Nbo3kz9Err42hL9SJZHxe8NigdKwAj/OsxeICYyuKLHehP3Mw/BpR1rb82f5XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AYZpWdiRIjU39RhPx34u+s3W5+B/i6VGlSOQnKMjchI=;
 b=cvZyWRpn7hQEarD5/NhbW65qVh927SSFgWuU1uh2CORXwog/AP0G/mBY/6H0V3UT6BSpvi/VAcC3EcYqUkjxHdyABNaGOejTSrSJXnCSzZftFR/ogshc/DcqJq6itSktLWyYHOiwNOn0AnaM0XQJ+v3A1iAf8kZYP7SYv3rQP/+2r73z2UAaiBCzjluaL2XFL++tByRbFnHc6saGu4yqb+yim36nqEFcLtHcCEwP6AkW2fKOpE+4qyqc9FWzBF3xr28ZjmWnyo5/WGNeZ7N7l8H6n/SBiwZU/i2QqMWYY0CHw7KAQor1/+ecUtFkQGUkDQ1Qm7PWros/FyrXUQaaQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SN6PR1501MB4143.namprd15.prod.outlook.com (2603:10b6:805:e1::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Thu, 10 Feb
 2022 05:59:52 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::cd7f:351f:8939:596e]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::cd7f:351f:8939:596e%5]) with mapi id 15.20.4951.018; Thu, 10 Feb 2022
 05:59:52 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
CC:     Song Liu <song@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Kernel Team" <Kernel-team@fb.com>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH bpf-next 2/2] bpf: fix bpf_prog_pack build HPAGE_PMD_SIZE
Thread-Topic: [PATCH bpf-next 2/2] bpf: fix bpf_prog_pack build HPAGE_PMD_SIZE
Thread-Index: AQHYHThI4rFDXJwtj0GEWMIEgSEK0qyL/EqAgABQGoA=
Date:   Thu, 10 Feb 2022 05:59:52 +0000
Message-ID: <29F9AAFA-82EC-4D88-9BA9-9AE12BF01B51@fb.com>
References: <20220208220509.4180389-1-song@kernel.org>
 <20220208220509.4180389-3-song@kernel.org>
 <3d13bcf4-8d20-0f06-5c00-3880b79363af@gmail.com>
In-Reply-To: <3d13bcf4-8d20-0f06-5c00-3880b79363af@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1933d280-850e-426a-a52e-08d9ec5a8de4
x-ms-traffictypediagnostic: SN6PR1501MB4143:EE_
x-microsoft-antispam-prvs: <SN6PR1501MB41437164CC893C32C9880075B32F9@SN6PR1501MB4143.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RAd31tcebHz2icdATZcIzUyhV6aJfef+EqOw2Vbfe0kwGfsi4r7/ViX9QwnN8xQ4+yndtr9IApu+WTZ97KIfDT7eVscLNrgueeayp6VHTtWfK8bjP9uCBmYz4v+pw8Yh9YPDhHiYJAkAW6i4sdENHnzOEcZD/nyxoM05ctkXb6jEYEdQZhp2AcU1DnKnhVFJfKv9wdMIU5ETJpoBMnVQVOOEWwUVxN5FdtzoVZm01WxDAFahmjXZIYLlLNmff0mpsGpqLrALaD8NeKJmI8PBAvABMfR1aNVw2uveFLQXu1oM5Ovt4hZNCbnivTOLgW7ReofE/C4KaR++1d/iY8xOkxwLPKxc6Y6BPZ3DuTEtjYiNp0gwRAxkSuTHSIfq0ih7AVQPSrQSPV78YN8IcXwskfFJQKIsR5hPlZZrqQsO74oIGfBbs/XA3W1dRu6bdhfzDJcRfbSlQrWhu4OgDk4YDoWT/fBkTPObZ5W8Pv7dA0NrB1rdsYY/aQ8tmxFKi8iMG6w0U2RN0BMrXl9qrVEUkN3o1Cl/YucGzdGwe4kc9BRtey230f0z/iFMf2gh9/Csl7ovdoUX0R1/HN8x7z4BcpJcJS1zp1i9IFs8pyGmry4G4VSrgCGx5sJUtOWj/oQmHKQ3CFoJO31l+rjTDb9zbFrYmZDagEpo7TXrfu4HJgySLkj3uPq3tjgpWMCnBAZezdg/aNuXNBRFA3puHQFgtfE/+qlCe2tVGoImn1NeChU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66946007)(38070700005)(8936002)(5660300002)(8676002)(4326008)(66476007)(64756008)(66446008)(66556008)(6486002)(36756003)(76116006)(508600001)(6512007)(83380400001)(91956017)(71200400001)(53546011)(38100700002)(2906002)(186003)(33656002)(2616005)(6916009)(122000001)(86362001)(316002)(6506007)(54906003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?p7MPVHuqQZRcxQpq6p9VSUcC2aubfqmKL6hmWJ/mag3Kwrp5YFHwE8UJeR8l?=
 =?us-ascii?Q?xWN68QSMHwuBuKH/h+6tSfqyASV/uaGl9S7VEwGsM7i9hg6CFsyQxEJy6V8T?=
 =?us-ascii?Q?hb400jF/+7FcHkH6LKdZCwGkFFttZ1zVn2HnlWRgA3TTPZ9YliKU1knamBvM?=
 =?us-ascii?Q?WAkgCd2rmOecDpZuup0ok3faghuT/WOeArkg6EtX723KgcbFHTc59HHv0Pdx?=
 =?us-ascii?Q?5PcqLgSpXovRS7sgCCeuQA4fxsFxZTL98KnZ2hsMvzbXBvJmsERrshdQTXGv?=
 =?us-ascii?Q?fdBv68UNShBYBfsgAj57L2Z0Lj0a3BWONEiG7jMq3RtJ+mtOn6o50wd4qFnb?=
 =?us-ascii?Q?G3pidFV3YXhQMCAq9+DgC+cULQjrxsWMVp9a/dddoOt+Yj7d6quAYL/sX3NR?=
 =?us-ascii?Q?jM+qlcGdEK29BeK2ygvo25wsdvmVix/mdbmx+YK2izL98ppljRFkY5qwsMdb?=
 =?us-ascii?Q?9+XJqWo36QiibdF4+Xn+vW1YbQ/hdAlYQm9u0NWBzRelabDiL8vr8awZs8mJ?=
 =?us-ascii?Q?wUkS0lv1JK58/eV8fmaQfHRCLvGlx7pr2KuGwiway2oQ4Zf1tEUNi6ggIlGQ?=
 =?us-ascii?Q?A1UgO6B7VDQW657cFi1EovA+MnvHb4/j35qjdN7B1dzi2jeWdMv9U3LBAHYM?=
 =?us-ascii?Q?J0/OZ0ynACAnyVripLRJFKfQ27wr3ORJ1o+6vv76MtoNJJMa17PEUHN/xq/T?=
 =?us-ascii?Q?4s0CuYXI2SEsZX72Q20AGGqTmc8NL5P/QJ6HmjuQypzl6DjAvDISBeXGI99m?=
 =?us-ascii?Q?LytK8BM/ugZH7OlcNN71VXZpbsw3Qa6/CXMdj4OdrBqlByKMesJZpz2YsvL8?=
 =?us-ascii?Q?sBkRZhwFxe51GZuqARZ+7e6Fg3BBEVX9iE223tJA6WMrrgGI74xgm3D2WHlb?=
 =?us-ascii?Q?z+BOaUhMB6P6ym+aCJtgzSpmUPxX1Eulxwhxm9N9lhEomw3/ovnPUB44KBIc?=
 =?us-ascii?Q?40WyxPKwY20Hv+yl3hvnMUuqFELPtUgtNQyvczuYajZeHndoNXcOQq1/funa?=
 =?us-ascii?Q?QXIphzRBnrJTUTCtemJ352LKHS/AnXNenQGrq0XZtTr1ePeEKU/2noIK/Ivg?=
 =?us-ascii?Q?nZ7xB6S65WyaOmB8kVInw5c9RyOwBxO/4I9asY0Jfc6v24hus6cSP+4tFwbO?=
 =?us-ascii?Q?6Foy7n62+C4cR38z6KWB+QA1Np2AmzC4ZiqXuNfqfOOudA1sbxaUGlAED5en?=
 =?us-ascii?Q?TsDuPgHT46O2a4rBrmHHHe74W4BLL1D2KWXTy7kLaEM56PvMtaDpskUoDCC+?=
 =?us-ascii?Q?rv3IXwhYmcPjFcIdlEKz0DN8PB4xUy1S4AOi5qAyplfiLidRo1+kxzOh/WU4?=
 =?us-ascii?Q?o+gMIRt3+KsGQEDIT51bCui7/IUJ0NXD1bGrNBjIEBkJLmiteOuZKJTj72ho?=
 =?us-ascii?Q?ywSX+dTZiqt9pxWmhF83GSsYF3UuQ8u0AuD+FyC2NKlbYZLmWckGjAvCskqq?=
 =?us-ascii?Q?oaGdy/RmXH11Ld7ZU67wyrJJ4lZcwtYYajlAtlA97mB4Cnp/YJL0vs5DH70j?=
 =?us-ascii?Q?ylbbveUVG1ZS6SPDtvQ1jhpef9yZ7vLxNxDEi5rLfRvt7T0S/+24Dsrne5lF?=
 =?us-ascii?Q?tUzj8R/USaq8ngyVF6YNEIsQcpXD+EdQFHrk15UZyYwX9S3CzRduaKUsrtQU?=
 =?us-ascii?Q?R3alIgvE9uygZeykwyOC9CNyIk56jL6UWGfkhjnJ9YsgUoNMow1+SklGKt+/?=
 =?us-ascii?Q?Pu3xAA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <70F014EAA8CBDA40BDDBD28B688EDD3F@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1933d280-850e-426a-a52e-08d9ec5a8de4
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2022 05:59:52.0482
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0kbk/nxWVFO2n9wk76dwxMgssoFyQmq5v2RrX6U3x9pW9n71vaKvCI2mHXOQMRohC4LTWa8nhq9w/cFr7glJJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR1501MB4143
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: _79vY6Gfg975Th89dmPBl5hcvxwgxzDX
X-Proofpoint-ORIG-GUID: _79vY6Gfg975Th89dmPBl5hcvxwgxzDX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-10_02,2022-02-09_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 suspectscore=0
 clxscore=1015 impostorscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202100032
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric, 

> On Feb 9, 2022, at 5:13 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> 
> 
> On 2/8/22 14:05, Song Liu wrote:
>> Fix build with CONFIG_TRANSPARENT_HUGEPAGE=n with BPF_PROG_PACK_SIZE as
>> PAGE_SIZE.
>> 
>> Fixes: 57631054fae6 ("bpf: Introduce bpf_prog_pack allocator")
>> Reported-by: kernel test robot <lkp@intel.com>
>> Signed-off-by: Song Liu <song@kernel.org>
>> ---
>>  kernel/bpf/core.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>> 
>> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
>> index 306aa63fa58e..9519264ab1ee 100644
>> --- a/kernel/bpf/core.c
>> +++ b/kernel/bpf/core.c
>> @@ -814,7 +814,11 @@ int bpf_jit_add_poke_descriptor(struct bpf_prog *prog,
>>   * allocator. The prog_pack allocator uses HPAGE_PMD_SIZE page (2MB on x86)
>>   * to host BPF programs.
>>   */
>> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>  #define BPF_PROG_PACK_SIZE	HPAGE_PMD_SIZE
>> +#else
>> +#define BPF_PROG_PACK_SIZE	PAGE_SIZE
>> +#endif
>>  #define BPF_PROG_CHUNK_SHIFT	6
>>  #define BPF_PROG_CHUNK_SIZE	(1 << BPF_PROG_CHUNK_SHIFT)
>>  #define BPF_PROG_CHUNK_MASK	(~(BPF_PROG_CHUNK_SIZE - 1))
> 
> BTW, I do not understand with module_alloc(HPAGE_PMD_SIZE) would necessarily allocate a huge page.
> 
> I am pretty sure it does not on x86_64 and dual socket host (NUMA)
> 
> It seems you need to multiply this by num_online_nodes()  or change the way __vmalloc_node_range()
> 
> works, because it currently does:
> 
>     if (vmap_allow_huge && !(vm_flags & VM_NO_HUGE_VMAP)) {
>         unsigned long size_per_node;
> 
>         /*
>          * Try huge pages. Only try for PAGE_KERNEL allocations,
>          * others like modules don't yet expect huge pages in
>          * their allocations due to apply_to_page_range not
>          * supporting them.
>          */
> 
>         size_per_node = size;
>         if (node == NUMA_NO_NODE)
> <*>          size_per_node /= num_online_nodes();
>         if (arch_vmap_pmd_supported(prot) && size_per_node >= PMD_SIZE)
>             shift = PMD_SHIFT;
>         else
>             shift = arch_vmap_pte_supported_shift(size_per_node);


Thanks for highlighting this issue! I will address this in a follow up commit. 

Regards,
Song

