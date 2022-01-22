Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25830496934
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 02:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbiAVBam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 20:30:42 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:5114 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230416AbiAVBal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 20:30:41 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20LG9wXr010759;
        Fri, 21 Jan 2022 17:30:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=PlOvo12UldYutEJH8ySrWGOfqzFu/aHS5LvPMMKzsuU=;
 b=FbbCvF5aOQ4RBtcVnzJTA/2gGW57FacNYt2xx6amjEobN25ZDN6Ss6X/EEGftj/qOsBq
 TkmXki8KwrOZgm2B/sdJiAd467YQwGVNolR/sDlM7X9Uq+txET7zZDye+mmaU8lhxWOa
 v0t083xnw/7sYch5PL3xLx61Tv4qIu6qiLc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3dqj0gq4v1-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 21 Jan 2022 17:30:41 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 21 Jan 2022 17:30:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KZPJj9Nhk1scv+MBn83JRB5Amrv4L+AQusUpdBXpdkjLZZupTYHRbzZqozR7/tp/OOZPuve3TcZ2OAtSg/oohu/aoL6ew239BGQOQRJ/fAI8R/y2q5R7yLlKa4oh2IRP1iI7G//R6eM8FppC1WcNYAyjx0yL5wPiLy1hwQ+vYedznrjyPVDUrHMxfxvSUBT21pllxWx5ZER+iVzmH4qSF3DsYclY7NHR/jENpG1N8CRAMnUlU4PwaYQbQmX0eVahUlp5YsM4I/B6cyAgWsPcYj3qDjSoayFbLpCRS+9F/nUYBF/zmhGN2I2jBW39GYKQWsDdAveh9+Sz9sTgYPP+ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PlOvo12UldYutEJH8ySrWGOfqzFu/aHS5LvPMMKzsuU=;
 b=NhZorKnu3mpL2OGdLV/7j0uoMXqjTPiLCOuVIR4GUD0JaECIHtz+rmhGNB1I38Vki0HqYFCdDP6fE4ltlPwlzWxXRMnLFdu/Vh81OaXxnfZgnqq4E5AlkRvd6Jtqa+On+dpESJOSFWXSjlFYseWRDGsRro9Bj90mdkMo4X5nFsXtgNIfq74wRMHv95niYElz1MUoyZog5abIUgMVZie0KPPBT36hDPHCKRt72kKCXkjzyDyJmwWLi6ECpf7j6WNbUn+sxYTUmFUq5hnbF4hbjh6ymjsUFghGzi4KWQF3rhZ4q8es5AmbNuAf9aG4So7kakf4u48jc7nQk4D41XOBwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by BN6PR15MB1137.namprd15.prod.outlook.com (2603:10b6:404:ed::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8; Sat, 22 Jan
 2022 01:30:31 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::1d7e:c02b:ebe1:bf5e]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::1d7e:c02b:ebe1:bf5e%7]) with mapi id 15.20.4909.012; Sat, 22 Jan 2022
 01:30:30 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Song Liu <song@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Andrii Nakryiko" <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "Peter Zijlstra" <peterz@infradead.org>, X86 ML <x86@kernel.org>
Subject: Re: [PATCH v6 bpf-next 6/7] bpf: introduce bpf_prog_pack allocator
Thread-Topic: [PATCH v6 bpf-next 6/7] bpf: introduce bpf_prog_pack allocator
Thread-Index: AQHYDwA7v2eTErzZP02KrqTA2Ue2qKxuJqkAgAAH3QCAAAUSgIAABaKAgAAC8wCAAAUaAA==
Date:   Sat, 22 Jan 2022 01:30:30 +0000
Message-ID: <5F4DEFB2-5F5A-4703-B5E5-BBCE05CD3651@fb.com>
References: <20220121194926.1970172-1-song@kernel.org>
 <20220121194926.1970172-7-song@kernel.org>
 <CAADnVQK6+gWTUDo2z1H6AE5_DtuBBetW+VTwwKz03tpVdfuoHA@mail.gmail.com>
 <7393B983-3295-4B14-9528-B7BD04A82709@fb.com>
 <CAADnVQJLHXaU7tUJN=EM-Nt28xtu4vw9+Ox_uQsjh-E-4VNKoA@mail.gmail.com>
 <5407DA0E-C0F8-4DA9-B407-3DE657301BB2@fb.com>
 <CAADnVQLOpgGG9qfR4EAgzrdMrfSg9ftCY=9psR46GeBWP7aDvQ@mail.gmail.com>
In-Reply-To: <CAADnVQLOpgGG9qfR4EAgzrdMrfSg9ftCY=9psR46GeBWP7aDvQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a18ee87b-d42d-45d7-51e2-08d9dd46c73b
x-ms-traffictypediagnostic: BN6PR15MB1137:EE_
x-microsoft-antispam-prvs: <BN6PR15MB1137D69DAAA42015FCF54CA5B35C9@BN6PR15MB1137.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qzT9vCFAY6NPhDuE/xT2ofFiksh095jvc88MSKfWwFvnZ5RhK6ugMNja/mm/+Xam5hqSJpvHzyrBznbi0br4QmgfwNsgN5tbcj2imZ9LVM+X02I9nN7Yl1hpwkUi2A9pFs6a923ZRGQ1J/UZTcG8DTWylzIkhEjL83tu/pLtdi7XfiTc+faf8FcGkwVvUVB2EMSXUj0KeLHQFh8IuZwvLsgz1Ad0sZOngm988oouxYXe2hi4xc9461OYyqIilBACusuQja8VPTwihwjDAvGgHRZgx5oRySqECyM3FDq1DyRZcBgrd4RKQE/oU+P5MXf2M7YpOYu8drXNGbRwwQmMp5paKUSz6cIJ7tNQuQuNNkEkCzUhX+czvMW8gaV3b323Uiv+l7btEhA8biXXoUNtkKpaOdThS2I6BjttbKopNNhb3UQ0SgJQDsB62/fD8HA6axEq+QKgkC9h3QEZvRY3GiGI//h2tnCRPuAukjpzV5sLFo8yyE72VvxILoOrhkapqD3uwyTQXVEjzFK9uTgYI4dBe3JojeqyYsBFKXN37j85OxoxMxCydgRMAJ80tn+Wcs4dZSoVWLg89FMGSV5M9cjZAGikkSxmw4Chk7mEcFLxRVS32vFcshMMEQK83hson8mWImioKVWRKrETpZkG7S2Aaf7iFHSKaMgQdkM0CFPSc6E+rXB8i4OMJrbapA7OD8FkO2/HqhWcXhEMvoxRutYYDj6i31nz3+oqll4AuZ3KNBGclE39Radb6syd5t/n
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(6506007)(71200400001)(8676002)(186003)(6916009)(7416002)(54906003)(76116006)(91956017)(508600001)(53546011)(64756008)(66446008)(66556008)(66946007)(66476007)(2616005)(6512007)(316002)(6486002)(4744005)(86362001)(4326008)(5660300002)(2906002)(38100700002)(122000001)(33656002)(38070700005)(36756003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?yR9qOf7IxHEOmxPYYQbMuncmH3T8v9P7rheFu0ZSXnwodNcrcM8Tf/4gXyKq?=
 =?us-ascii?Q?mHgCYWzbwuNqFUqC77GrHjKjLwI7jbi/5c0NlfrKrusQpnyJ0apvWZJQK28B?=
 =?us-ascii?Q?GbH1QA9vMiTl5+VoW1qROidZnbeJvWlxVICsSrm9Hygv5vi2XAhAUIg5NjSa?=
 =?us-ascii?Q?PnH7zERmm4SdKyqwwYfgO5fp6/99v3l20Vm/g6vKJjuwrz7USj+VL6F/x2pY?=
 =?us-ascii?Q?IlXPPJqkFNGCVeP0LZjGxYKbvtWQcdqZM/kf9/NEuNiBfbEu2ZDCFVqAkFtb?=
 =?us-ascii?Q?9scfSxjdfhhQn9pJSd52LiIOB274BDh3MzcqcVYDU/qs3XqP49J0ORGrvsMU?=
 =?us-ascii?Q?xqNu8iwuPqEtueLILM+F59HbdoWff52mqz0ZFPULPemTRuHGkcapkVFFh2Id?=
 =?us-ascii?Q?Aw9nr4E9PmyAbEe9Z0R2H4L3jsuIEey251pdFnzWR2ECThSD3GWd5haFl1bl?=
 =?us-ascii?Q?v0KqieqQtICEfsU5TQ/8JICC+ptGPPMTgTIVSrWsJYavkO0vsQ1hPAI3jjWY?=
 =?us-ascii?Q?7QEGwU41jMY39LKN6wnuSUyc4NbO2EDPor3y77WM26TeHzC0l1MKSS5yLTYZ?=
 =?us-ascii?Q?NaVmSy0K3fO6ySrRYIRAPJgGx4n0X6+rd1i3GmHLJUspMyP6NR4Kh7bbwFnU?=
 =?us-ascii?Q?IHSJVgLLN9rRCikYYnuY2d3Qlb8c1g84srcbBrZCzheLqsyPMpUhzizDx3TT?=
 =?us-ascii?Q?b/obQUbyUKMwCYfZwzn+j7MABMx2PzZZmt4vP8ZLd+4o6zMSWas4xCsBNTqW?=
 =?us-ascii?Q?2U737lqHXG5u5fOMEhhtZfIjhyb+Kc22BMs56D7x3VYyEhMaOWxx4eO3p6AJ?=
 =?us-ascii?Q?zOeUjzEP3D4HEcc1pwJYsO7oQTZeaaraajejs+pB7rV+TaEed/DLhLqS9xdD?=
 =?us-ascii?Q?+QjNmn0v5btdqa/w6Vm2WAK5Fij83DKlYfn9Z4WUAfGGMAN1SDS8OI6h56Al?=
 =?us-ascii?Q?E9vWwoBi/N18ReLKFfiIProj+uZ+faCGEHqC8B/BSxpH6zIpvOWpOcuEWVAf?=
 =?us-ascii?Q?NqNBBeWD9cz2op9E66fxMgSPd+vDR0Ihmd6RSdwZNljz8tpB+02xF6EkhL9P?=
 =?us-ascii?Q?LD8BEyynGtBilU0rvOBpa7Y9rFNg9EPb+GG+Wc917vphW1WHjf+mZd64ySsu?=
 =?us-ascii?Q?rvm3hljBENg+mbt1kNRP7nxqbe6jXE1HgMsKRB6GuZPI/o8nsIzHxdkdPaY0?=
 =?us-ascii?Q?5ay3YRGx/0fg5BTdeULdrvJZRCI9pPXW2++sEAhknauNVi3VxY6UmRWgoQur?=
 =?us-ascii?Q?m07YELehP0tNZvOS0Ak97Z1aQndVs1EUIAb2Eg1EdrUs1snSNQp+Jku/0rs+?=
 =?us-ascii?Q?rmpoaMgnKtvDzZ6HPpQ0W6TGAwGl8nr6ShzNGMxqdHZlLWsPdgoU9MHhqe17?=
 =?us-ascii?Q?c3y3+HCD4XjWV8DZtLCggn9FR21aekbKOARE3sosY1NOBSt5wL3KvzycTqHU?=
 =?us-ascii?Q?GqhAjzQFOsVCXBd6wjj1IuGPZzHzaqNRsPq4B+whkTAHARnuJvC1aBLpmKkn?=
 =?us-ascii?Q?OR3KgcxT045bIHNmTJiNLN0tBWAnIfamQxt5I09wKVZFZpuM3ckI9VuR47GM?=
 =?us-ascii?Q?e63nffpf486wDUWEDD0VHujjMTtB7LRaeUlpbPcq5xiivhdpYYeV/CjYgLXi?=
 =?us-ascii?Q?jFq7inFu96GXpMTeLu0/iGrWJVeM3ivBAY1qKAiSbN8W4mH/GGUQRpNiwJJN?=
 =?us-ascii?Q?zxRwfg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AC676B3E2A828C4CB6939F5EF792F306@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a18ee87b-d42d-45d7-51e2-08d9dd46c73b
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2022 01:30:30.8858
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uoRWJqLv9OZi4likXSGR7YvTk6rp1Gw3R6wS7f4taZbOcsPwCsEx749U4UoUmmO5xIXRc2EtPKK9Lhg2q2Veuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR15MB1137
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: wn1LBgBLqcBZuGY14NHNGqVgCJ690y7s
X-Proofpoint-GUID: wn1LBgBLqcBZuGY14NHNGqVgCJ690y7s
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-21_10,2022-01-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 mlxscore=0 adultscore=0
 clxscore=1015 bulkscore=0 impostorscore=0 spamscore=0 phishscore=0
 suspectscore=0 mlxlogscore=848 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201220005
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jan 21, 2022, at 5:12 PM, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> 
> On Fri, Jan 21, 2022 at 5:01 PM Song Liu <songliubraving@fb.com> wrote:
>> 
>> In this way, we need to allocate rw_image here, and free it in
>> bpf_jit_comp.c. This feels a little weird to me, but I guess that
>> is still the cleanest solution for now.
> 
> You mean inside bpf_jit_binary_alloc?
> That won't be arch independent.
> It needs to be split into generic piece that stays in core.c
> and callbacks like bpf_jit_fill_hole_t
> or into multiple helpers with prep in-between.
> Don't worry if all archs need to be touched.

How about we introduce callback bpf_jit_set_header_size_t? Then we
can split x86's jit_fill_hole() into two functions, one to fill the
hole, the other to set size. The rest of the logic gonna stay the same. 

Archs that do not use bpf_prog_pack won't need bpf_jit_set_header_size_t. 

Thanks,
Song
