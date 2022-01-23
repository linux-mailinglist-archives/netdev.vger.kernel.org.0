Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B71CE496F59
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 02:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235127AbiAWBDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 20:03:30 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:33700 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231594AbiAWBD3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 20:03:29 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20N0HKTk016914;
        Sat, 22 Jan 2022 17:03:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=vO5O4sN/JUMtWTPOqw2jNM6kMFYx+etZvkinuZWKQXw=;
 b=ilVuyO2IBENM6nxqWdf2yGf/MyV5ngctl8hkHOUF82CADaIq5ty3kDf68jHPGnMkooV/
 dVzszTOk3Sjc/WCM/T31jlbKJDw1XhLTMgm91xszMhZx2XhiuLtK/5bNIiqRgiKS7W0N
 VscNcd7+xOOzZqDdFfoi3fs24MpK54VsGco= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3dre4ntn9a-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 22 Jan 2022 17:03:27 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sat, 22 Jan 2022 17:03:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oE86gf/UjX5m6dXWCYn7WwBqTu4aKyxYNc0Cu/vrh5ni04SnG1A3cjIfODpNIIue3k1phr5g4jg1N5V6WHbfSFgItg4YZebuMIzmJnSDtqvyvVqERIh8kc72L1sVmi48oTrDYWL/JF+KoIa1dfNUzlp6Z7uG9N8Qz/4n4Wislq/sISvfzvCPjARicDDEtn/Pq0MWJZggKM36cWqFjTqERBlDlCf1vD2wy33ccX0iJjDMyU55HLDmWxgDmi+dh0n3mzN96ehndFE+ctEHuS/2UHZPb2P3fumM2yVEtLpd1mHUAgrU8lzhYzkvy7IYuB2hvtqntQ5JACh2U0t7IVrVmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vO5O4sN/JUMtWTPOqw2jNM6kMFYx+etZvkinuZWKQXw=;
 b=ffmV8QNsAvQ8+yLvTZf22qHqlG0XkiXwJVCGYMzMkM4zVuH9EVrDVnymivvkNtd62z5v0azkYduc+kIVPqiFgAOUvWHk+G3iZzh9UijgbcEwwOkZaXqyOb0ulzSjT549cBQ6fZkjPkOksKEu89Skt2F3AGJsJjpiHskV5h799+Ye1HQGGvpMVEd+Sfhema2ls5wpAccnn0H0llYW5JdlmOqTBXxZMwL85VXn6NyWj2PB1Ja1HdsN7VzOcqIMz28DmE32B18czkK7lsE/ZkO5nT60MG1z00lsrRSBlkPuhuV3HdeJSBA9wG/qqeuxYSKAm930MU/zgDKp2XryNJPVtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SJ0PR15MB4424.namprd15.prod.outlook.com (2603:10b6:a03:375::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.12; Sun, 23 Jan
 2022 01:03:25 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::1d7e:c02b:ebe1:bf5e]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::1d7e:c02b:ebe1:bf5e%7]) with mapi id 15.20.4909.014; Sun, 23 Jan 2022
 01:03:25 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Ilya Leoshkevich <iii@linux.ibm.com>, Song Liu <song@kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Kernel Team" <Kernel-team@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, X86 ML <x86@kernel.org>
Subject: Re: [PATCH v6 bpf-next 6/7] bpf: introduce bpf_prog_pack allocator
Thread-Topic: [PATCH v6 bpf-next 6/7] bpf: introduce bpf_prog_pack allocator
Thread-Index: AQHYDwA7v2eTErzZP02KrqTA2Ue2qKxuJqkAgAAH3QCAAAUSgIAABaKAgAAC8wCAAAUaAIAAC8WAgAF+/gA=
Date:   Sun, 23 Jan 2022 01:03:25 +0000
Message-ID: <5E70BF53-E3FB-4F7A-B55D-199C54A8FDCA@fb.com>
References: <20220121194926.1970172-1-song@kernel.org>
 <20220121194926.1970172-7-song@kernel.org>
 <CAADnVQK6+gWTUDo2z1H6AE5_DtuBBetW+VTwwKz03tpVdfuoHA@mail.gmail.com>
 <7393B983-3295-4B14-9528-B7BD04A82709@fb.com>
 <CAADnVQJLHXaU7tUJN=EM-Nt28xtu4vw9+Ox_uQsjh-E-4VNKoA@mail.gmail.com>
 <5407DA0E-C0F8-4DA9-B407-3DE657301BB2@fb.com>
 <CAADnVQLOpgGG9qfR4EAgzrdMrfSg9ftCY=9psR46GeBWP7aDvQ@mail.gmail.com>
 <5F4DEFB2-5F5A-4703-B5E5-BBCE05CD3651@fb.com>
 <CAADnVQLXGu_eF8VT6NmxKVxOHmfx7C=mWmmWF8KmsjFXg6P5OA@mail.gmail.com>
In-Reply-To: <CAADnVQLXGu_eF8VT6NmxKVxOHmfx7C=mWmmWF8KmsjFXg6P5OA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b8933bc7-f15c-474b-ad43-08d9de0c2892
x-ms-traffictypediagnostic: SJ0PR15MB4424:EE_
x-microsoft-antispam-prvs: <SJ0PR15MB4424E4303EA47CD1BAF89325B35D9@SJ0PR15MB4424.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uh98YVgCA/kW69W2JcJG0qmJebm32sRS0dazdntaAjYCrj9Xy/1FUzZdLw7xvukREV0ZYxTDE4yfLU2Nlc91vRoYlNwN5I7RvtcSc1H4hi+EONZgZ793CXvFxvnAsVNmqviWs94Nt3wfXa+/xjODuh+xqWAdfC6ngI2DASVnG9gBhOF803N8IWIcbWTlx26i23hqDdyl1UUYg3ZfUhVSv4frKF812iRIpIQ3cmHivm2CXMOF6yzUNKhivrpI0M/7sblYBvnjGfHis+XVZb8z7ldg1DDjjx4m6THlS570d039b+vQS5Dmt/sQM3LFfv3MbylqojVtr56CJabM/1t462v/rauLIn1YPZmrZ4plWXvGkZelrbbr81dtsdNBp5w4v6opLqjz5aGflSGVYxxtpybdctr2IhNMN9LdoTXnPzij/olv8c35qS4ooSSsVr9uFXSTF6+OFgf1vrxY/zplzz/YMlZP5ReOEnUTQo1U8yN+TEAO6WmT6SEcheNeY8nPCgj0g5Cid1/QobC6s5ZZP1W8cjTQxZrLtvR66P0/EPMI9DxzfIRjtW3KzTgAkiTNH0iiZyKy2h8fqp0umThS4D/zJwYJBANdAEPTZo6Qsr1TSgYnEnqMUA1/W/bkM+j8HxeWsMhFPeVPWgMfmv0YLliHIMcLWVuASbNw8FWFil3D+/mTH5chYNsMpoklp6k2HeaRXfInPkBZTh3peC/vMEXoRla7yxF1bc81/dDfNOw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(53546011)(8676002)(54906003)(2616005)(122000001)(64756008)(6506007)(8936002)(36756003)(5660300002)(86362001)(66446008)(186003)(4326008)(6486002)(38100700002)(91956017)(316002)(66556008)(7416002)(66476007)(83380400001)(2906002)(6512007)(33656002)(66946007)(71200400001)(76116006)(38070700005)(508600001)(6916009)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gLKQVzgUIZk8pxfCe0UNVeOXPCVVKDTfplUIkI9FkWum64Z5/3g/nq9GOx0p?=
 =?us-ascii?Q?7IKP7oXb1C1xjAX9ACoNf0T7TdmomdSWxHcEN4QdxpPkL4LfH/Cx+9vUkM+0?=
 =?us-ascii?Q?fUlJqa7lRp6XmwX1RLzh8/yeK6zgS/Oq21H0MjM9vmlZ9GCyXTSGGgpDYd0M?=
 =?us-ascii?Q?lVzmbyi+UEc2g6VIANrCdSZdrYX/NkY0LcpQZ8C+ewQ+NduE/hqmzqqCTAn3?=
 =?us-ascii?Q?6rXXh42N1YaNUQ/zUwDLO5iHdhn9QXeQ5MlLkpmsbIj0wlNhSDWe5goXIQsd?=
 =?us-ascii?Q?autK14IuqlVJ6F2GcxofiYOYIpnNnxZFNHycft/TItWGMbHETAK4yxnXl3Aj?=
 =?us-ascii?Q?FnbZl2FZ/ddHRydPFsHYN2c1hETF/Seq1C1YdaxgYbf6WmWP3yj6AKvCpRLy?=
 =?us-ascii?Q?W8Y9Cj736RnOpz/zoiBaF+Sh29gYd3U+Y7f/+10CD116oNlxmAzCk8aoGKwy?=
 =?us-ascii?Q?b78v2v0MIxh0JH94dHmavi7RWfwEMYh2Dk+csTXpsHaabrNOcVldvFgHgWPk?=
 =?us-ascii?Q?fZeOqtb8dJOFceKFpXHH74qRr0r0VZ/ltLoesCGssVpbL/aDXCdBwRmNBSNP?=
 =?us-ascii?Q?Mw4xeznUGBrsRcMlYxqck2f2gwQ98ImNM1wscWUVJs1JAHEZ6tWkUCDYo9aw?=
 =?us-ascii?Q?wD/p9FUNuJS1maOfD4G8hPBdkr+bnWdaY4F/XOITcX7bE2AxT8xeatI2Cten?=
 =?us-ascii?Q?k91zQMsed4eISz/dvpeFH7YcnFmW+1Fet4rJT8Ke7EeTSub8elC5ElAbA6AB?=
 =?us-ascii?Q?vth6lYivaHNeo9W+RqW5adVjz43jkWjjVlsZbcYHtvEV9vV/lw++IWybGGSr?=
 =?us-ascii?Q?yyAHDnks98yNRN9AheKdS2ZslzuGj0d5bh6Re/I4Q+wUWiUXlwffT2qhJGEh?=
 =?us-ascii?Q?Jzf5gO39ArnEz+C5AqyIGGc79hF4w4Zbjtwxqh/38Pm8UItwNKK79cbBK7td?=
 =?us-ascii?Q?kNIjSy9hNPjuUZKOjDDg1hiqgfTFkBdn+eBrGK3JN5U0WhgNMlFvZEoKbY5t?=
 =?us-ascii?Q?9wTA8p+MSmw+FjDU07S0FA+6s2VW6QXgTCF2oJH6hyj5F9PCCtK+gr5OhNjR?=
 =?us-ascii?Q?kLYZ9SrM5xaE8rhyPzPc6X+vHwbHMJ44AwztMnoDH+K/orwu15pX6DAzk6AR?=
 =?us-ascii?Q?qnTQMD33PTELkZeqIhABmgTI/33Mee9KoW/PZ7A/nPkBRl/tJz2vT7ynf31I?=
 =?us-ascii?Q?OTXZfKXu3WqpFQ23NwiaeMeQlJVAxmWFwjrC68a3Bcw3IdZO3dY4hdw1Hgf9?=
 =?us-ascii?Q?miR9X/F/gRct1SqJBQSgGLxlBOpPcoXwjbQ9CV1WWyyoawpgNM1izhbHgzzF?=
 =?us-ascii?Q?jZ7haVWIjN7Sih7H3W1qYF8SGQrbdM4qv9Vto4uIN4F2zFjmMcI6yPGL9yPN?=
 =?us-ascii?Q?KIjqBB9AnnQa4JmoUurVb8inUFAm0VwIvPKsAxYKk1ZCo4CHcdYOUCQlzXnm?=
 =?us-ascii?Q?9I0nhhBgu2wrylvYZvi69ov3CTz70hxOqwTDTwvXxWb5hnk931v8O3pbTqf5?=
 =?us-ascii?Q?7VNl3ooR5V0pRD4eojWLkpD07HblKgz3qkuWwpUI6r8Dh2kDIbuceAPgWmFg?=
 =?us-ascii?Q?6Jf67eDbRdoSd2Eej01We4eaG0bEUBPvFgfImeBD387DEk467idVNGRtGiYs?=
 =?us-ascii?Q?HHaSNmI+qB71QXPOl3CidWRwM6IKNkoNCE6r5mfs76A4CugnJ/NXpgFYtH9b?=
 =?us-ascii?Q?YXCYMA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5B7F2F9442F8164F90D7E633B99CED81@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8933bc7-f15c-474b-ad43-08d9de0c2892
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2022 01:03:25.0842
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tQn6c0yPqPity6NeSq8LJ7Z15IFNVE7rIqUzVVuCTev6X6RX0NMnnPr9aMm9pyz7i3Sr06PXmhOEfGkVn8r09g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4424
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: SsDQVoNF9OEg6m3gk0CYTsndYApQ23kt
X-Proofpoint-GUID: SsDQVoNF9OEg6m3gk0CYTsndYApQ23kt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-22_10,2022-01-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 suspectscore=0
 bulkscore=0 mlxlogscore=999 spamscore=0 mlxscore=0 phishscore=0
 adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0
 clxscore=1015 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2201230005
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jan 21, 2022, at 6:12 PM, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> 
> On Fri, Jan 21, 2022 at 5:30 PM Song Liu <songliubraving@fb.com> wrote:
>> 
>> 
>> 
>>> On Jan 21, 2022, at 5:12 PM, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
>>> 
>>> On Fri, Jan 21, 2022 at 5:01 PM Song Liu <songliubraving@fb.com> wrote:
>>>> 
>>>> In this way, we need to allocate rw_image here, and free it in
>>>> bpf_jit_comp.c. This feels a little weird to me, but I guess that
>>>> is still the cleanest solution for now.
>>> 
>>> You mean inside bpf_jit_binary_alloc?
>>> That won't be arch independent.
>>> It needs to be split into generic piece that stays in core.c
>>> and callbacks like bpf_jit_fill_hole_t
>>> or into multiple helpers with prep in-between.
>>> Don't worry if all archs need to be touched.
>> 
>> How about we introduce callback bpf_jit_set_header_size_t? Then we
>> can split x86's jit_fill_hole() into two functions, one to fill the
>> hole, the other to set size. The rest of the logic gonna stay the same.
>> 
>> Archs that do not use bpf_prog_pack won't need bpf_jit_set_header_size_t.
> 
> That's not any better.
> 
> Currently the choice of bpf_jit_binary_alloc_pack vs bpf_jit_binary_alloc
> leaks into arch bits and bpf_prog_pack_max_size() doesn't
> really make it generic.
> 
> Ideally all archs continue to use bpf_jit_binary_alloc()
> and magic happens in a generic code.
> If not then please remove bpf_prog_pack_max_size(),
> since it doesn't provide much value and pick
> bpf_jit_binary_alloc_pack() signature to fit x86 jit better.
> It wouldn't need bpf_jit_fill_hole_t callback at all.
> Please think it through so we don't need to redesign it
> when another arch will decide to use huge pages for bpf progs.
> 
> cc-ing Ilya for ideas on how that would fit s390.

I guess we have a few different questions here:

1. Can we use bpf_jit_binary_alloc() for both regular page and shared 
huge page? 

I think the answer is no, as bpf_jit_binary_alloc() allocates a rw 
buffer, and arch calls bpf_jit_binary_lock_ro after JITing. The new 
allocator will return a slice of a shared huge page, which is locked
RO before JITing. 

2. The problem with bpf_prog_pack_max_size() limitation. 

I think this is the worst part of current version of bpf_prog_pack, 
but it shouldn't be too hard to fix. I will remove this limitation 
in the next version. 

3. How to set proper header->size? 

I guess we can introduce something similar to bpf_arch_text_poke() 
for this? 


My proposal for the next version is:
1. No changes to archs that do not use huge page, just keep using 
   bpf_jit_binary_alloc.

2. For x86_64 (and other arch that would support bpf program on huge
   pages):
   2.1 arch/bpf_jit_comp calls bpf_jit_binary_alloc_pack() to allocate
       an RO bpf_binary_header;
   2.2 arch allocates a temporary buffer for JIT. Once JIT is done, 
       use text_poke_copy to copy the code to the RO bpf_binary_header. 

3. Remove bpf_prog_pack_max_size limitation. 


Does this sound reasonable?

Thanks,
Song


