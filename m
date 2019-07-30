Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91EB67A050
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 07:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729290AbfG3F2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 01:28:22 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:10794 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729273AbfG3F2W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 01:28:22 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6U5NQoQ021488;
        Mon, 29 Jul 2019 22:27:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=mrdFdKNM5SFzN0xtdzNgCYd7FpwZCBXKoB331BuluIM=;
 b=KVu8LI1gmX2Wh5/Lm5AKcJR7xglBiZiAN1Ta9vrppVUj/ezHflxCrCMsm49a+d+fUgtk
 gUVquluKoUW/tb8C/1PwT8u0oiwhThDywL7voJNdzCLmmfvdsKDYTV037VzHokJuIITO
 r3hclr8Zq5t7jDmELj5kfoiG+Mzpt+cD3r0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2u29ya0xrf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 29 Jul 2019 22:27:58 -0700
Received: from ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) by
 ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 29 Jul 2019 22:27:57 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 29 Jul 2019 22:27:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HJEI8FsK510Ya889e4gc0YvksXFDV+88hsWJzhu/hEFfzptpoJ2t0lxOpDnIMtArKpMVYw9Ng+4dojN/cPJNrJNJDYwqp1bU0Yup++9M67pUPjma+3tSi1NCBynnOCBOeuRLfvMwcukhxghQnTLejCyOysOfatij/mJ7MCe1OFMZISWN1OeIU0H/uIDJxk/fSb6GJaTJ6yY+7iGHIfFf1bTTqKl4NxXYLtvqL7ryoCIjHKjVZCIJxpvgM9sZ1ykDQCk+GbZjgznrGJJRbx/gTbOYgbLEErDMKOJKncfbfhoPdGPOne+XTg7rUCJafyVP5n1I1tCGO1MBD6b9BMfk5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mrdFdKNM5SFzN0xtdzNgCYd7FpwZCBXKoB331BuluIM=;
 b=lFgE4JFNv+7JiOu7QPxMxsYZJ5I/VPmPwOAWy+SpGwIAtkzTmm43dkWaque3KlFJC45dZGkm0S1G82Mkv5hs7mjEEdwbOS7ds5/iH7PIpJiWCJ43ONNq2KYog73L+vQv/YipJOcK8MOeDWD0AzshSUyvLsGK7FLs++BWz+Q3RyROZeT9UOWW3Q1O+rIZPPBOF3j9ckjDVBFAihGgnZ7Sm5nGR7BEyWV/78Ib+Amu1y0jii3VkSespwJpmUcrrcgjsT7QRS+9zAA8BPC+EcdesfRLLD3aHIDDjHVZWf5Nzc+PLmbtxaSrKC2GSSWSXoWtqBg2s0aam++lze6TXucf7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mrdFdKNM5SFzN0xtdzNgCYd7FpwZCBXKoB331BuluIM=;
 b=NDNfWZF93qoEGL7lYchsaQB3DUf8XjjrmARmVFViIHqw1O4Xb8tziyUGvxY7+Vh9oAd38i/1OpqoBoFI0MNBKfsKuqwRD2PF7RaSB5ro7uVztn4zQvBdYtL0MpjzkqhL96cUBLtR2wFTtWArG0Ycn2iIYRjdP959b/0WP07ayWI=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1872.namprd15.prod.outlook.com (10.174.101.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.13; Tue, 30 Jul 2019 05:27:55 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::d4fc:70c0:79a5:f41b]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::d4fc:70c0:79a5:f41b%2]) with mapi id 15.20.2115.005; Tue, 30 Jul 2019
 05:27:55 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Song Liu <liu.song.a23@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Yonghong Song" <yhs@fb.com>, Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 00/10] CO-RE offset relocations
Thread-Topic: [PATCH bpf-next 00/10] CO-RE offset relocations
Thread-Index: AQHVQlYNZa0mhAFeBEiEVNd5g4bd86biEZAAgAAEfICAACrEgIAAaZcA
Date:   Tue, 30 Jul 2019 05:27:55 +0000
Message-ID: <FCAF9AD8-C138-4AA7-AD68-195B01C6A25C@fb.com>
References: <20190724192742.1419254-1-andriin@fb.com>
 <CAPhsuW4hd2NJU5VZAwXDTMwrJRA4O-O2iNm8OywtJd0EZd5DmA@mail.gmail.com>
 <CAPhsuW5H2QQjuASV2iXTdA73E7AQnj73b77x4FmJomc-gJy-Cg@mail.gmail.com>
 <CAEf4BzbKYi53TdF9nAB3i3gAuca8FjM_P3F5aHp1uQ6coMgZ9A@mail.gmail.com>
In-Reply-To: <CAEf4BzbKYi53TdF9nAB3i3gAuca8FjM_P3F5aHp1uQ6coMgZ9A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::1:3c23]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1183d7ab-c6c7-4169-be2a-08d714aead1c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1872;
x-ms-traffictypediagnostic: MWHPR15MB1872:
x-ms-exchange-purlcount: 3
x-microsoft-antispam-prvs: <MWHPR15MB18724FDE4E620EDA057E3E25B3DC0@MWHPR15MB1872.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0114FF88F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(376002)(366004)(346002)(136003)(39860400002)(199004)(189003)(50226002)(76176011)(36756003)(68736007)(446003)(30864003)(2616005)(229853002)(11346002)(54906003)(966005)(256004)(81156014)(25786009)(476003)(6116002)(6486002)(186003)(14454004)(86362001)(6916009)(5660300002)(8936002)(6436002)(478600001)(99286004)(81166006)(14444005)(53936002)(57306001)(6246003)(46003)(2906002)(316002)(33656002)(486006)(66476007)(66556008)(8676002)(66446008)(64756008)(53546011)(66946007)(6512007)(6506007)(6306002)(76116006)(4326008)(305945005)(102836004)(71190400001)(71200400001)(7736002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1872;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: NEHwc1WKYByUF+OckMg2K5nmHQxBQmXRMjalJL8rdeLJL1JdM1bQiEUt61GanKm756AW4EoGpNL7QfWJwlfBc3ILZRyJa4aIhCGurNE1wuj/4DQn0vHayxXcHttVUbCKGAonayEUmadJx3AQ6mvdOQORHMBHFVMmykd21lVwn2PlLzCGlyWoRDTx1mezyuiJCNLrtiUHuhQXB9hQfzaIRRGQsxrNBJ3h0vkYLIj5EfBwM+mClZhz5RPShPIH/HnU+8LP7KcK2S1w5X+wV/m4DvUn0pXGAI8Zf3AEQA1/AsANO9o/X6vdgulhsWUmlA7/3ekDJ1W7om8mES8M9HChu5Tu1csLN5sxJ0Ehv4IUG7vFmm6JCD6S/cVw9a50J38eQxwr7iiBQNMrcIS3oikUaRWcwhtDLv0lYAaAEeVHyvE=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C9B471BF7C359D4D960770196FDFAA11@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1183d7ab-c6c7-4169-be2a-08d714aead1c
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2019 05:27:55.4839
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1872
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-30_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907300056
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 29, 2019, at 4:09 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> =
wrote:
>=20
> On Mon, Jul 29, 2019 at 1:37 PM Song Liu <liu.song.a23@gmail.com> wrote:
>>=20
>> On Mon, Jul 29, 2019 at 1:20 PM Song Liu <liu.song.a23@gmail.com> wrote:
>>>=20
>>> On Wed, Jul 24, 2019 at 1:34 PM Andrii Nakryiko <andriin@fb.com> wrote:
>>>>=20
>>>> This patch set implements central part of CO-RE (Compile Once - Run
>>>> Everywhere, see [0] and [1] for slides and video): relocating field of=
fsets.
>>>> Most of the details are written down as comments to corresponding part=
s of the
>>>> code.
>>>>=20
>>>> Patch #1 adds loading of .BTF.ext offset relocations section and macro=
s to
>>>> work with its contents.
>>>> Patch #2 implements CO-RE relocations algorithm in libbpf.
>>>> Patches #3-#10 adds selftests validating various parts of relocation h=
andling,
>>>> type compatibility, etc.
>>>>=20
>>>> For all tests to work, you'll need latest Clang/LLVM supporting
>>>> __builtin_preserve_access_index intrinsic, used for recording offset
>>>> relocations. Kernel on which selftests run should have BTF information=
 built
>>>> in (CONFIG_DEBUG_INFO_BTF=3Dy).
>>>>=20
>>>>  [0] http://vger.kernel.org/bpfconf2019.html#session-2
>>>>  [1] http://vger.kernel.org/lpc-bpf2018.html#session-2CO-RE relocation=
s
>>>>=20
>>>> This patch set implements central part of CO-RE (Compile Once - Run
>>>> Everywhere, see [0] and [1] for slides and video): relocating field of=
fsets.
>>>> Most of the details are written down as comments to corresponding part=
s of the
>>>> code.
>>>>=20
>>>> Patch #1 adds loading of .BTF.ext offset relocations section and macro=
s to
>>>> work with its contents.
>>>> Patch #2 implements CO-RE relocations algorithm in libbpf.
>>>> Patches #3-#10 adds selftests validating various parts of relocation h=
andling,
>>>> type compatibility, etc.
>>>>=20
>>>> For all tests to work, you'll need latest Clang/LLVM supporting
>>>> __builtin_preserve_access_index intrinsic, used for recording offset
>>>> relocations. Kernel on which selftests run should have BTF information=
 built
>>>> in (CONFIG_DEBUG_INFO_BTF=3Dy).
>>>>=20
>>>>  [0] http://vger.kernel.org/bpfconf2019.html#session-2
>>>>  [1] http://vger.kernel.org/lpc-bpf2018.html#session-2
>>>>=20
>>>> Andrii Nakryiko (10):
>>>>  libbpf: add .BTF.ext offset relocation section loading
>>>>  libbpf: implement BPF CO-RE offset relocation algorithm
>>>>  selftests/bpf: add CO-RE relocs testing setup
>>>>  selftests/bpf: add CO-RE relocs struct flavors tests
>>>>  selftests/bpf: add CO-RE relocs nesting tests
>>>>  selftests/bpf: add CO-RE relocs array tests
>>>>  selftests/bpf: add CO-RE relocs enum/ptr/func_proto tests
>>>>  selftests/bpf: add CO-RE relocs modifiers/typedef tests
>>>>  selftest/bpf: add CO-RE relocs ptr-as-array tests
>>>>  selftests/bpf: add CO-RE relocs ints tests
>>>>=20
>>>> tools/lib/bpf/btf.c                           |  64 +-
>>>> tools/lib/bpf/btf.h                           |   4 +
>>>> tools/lib/bpf/libbpf.c                        | 866 +++++++++++++++++-
>>>> tools/lib/bpf/libbpf.h                        |   1 +
>>>> tools/lib/bpf/libbpf_internal.h               |  91 ++
>>>> .../selftests/bpf/prog_tests/core_reloc.c     | 363 ++++++++
>>>> .../bpf/progs/btf__core_reloc_arrays.c        |   3 +
>>>> .../btf__core_reloc_arrays___diff_arr_dim.c   |   3 +
>>>> ...btf__core_reloc_arrays___diff_arr_val_sz.c |   3 +
>>>> .../btf__core_reloc_arrays___err_non_array.c  |   3 +
>>>> ...btf__core_reloc_arrays___err_too_shallow.c |   3 +
>>>> .../btf__core_reloc_arrays___err_too_small.c  |   3 +
>>>> ..._core_reloc_arrays___err_wrong_val_type1.c |   3 +
>>>> ..._core_reloc_arrays___err_wrong_val_type2.c |   3 +
>>>> .../bpf/progs/btf__core_reloc_flavors.c       |   3 +
>>>> .../btf__core_reloc_flavors__err_wrong_name.c |   3 +
>>>> .../bpf/progs/btf__core_reloc_ints.c          |   3 +
>>>> .../bpf/progs/btf__core_reloc_ints___bool.c   |   3 +
>>>> .../btf__core_reloc_ints___err_bitfield.c     |   3 +
>>>> .../btf__core_reloc_ints___err_wrong_sz_16.c  |   3 +
>>>> .../btf__core_reloc_ints___err_wrong_sz_32.c  |   3 +
>>>> .../btf__core_reloc_ints___err_wrong_sz_64.c  |   3 +
>>>> .../btf__core_reloc_ints___err_wrong_sz_8.c   |   3 +
>>>> .../btf__core_reloc_ints___reverse_sign.c     |   3 +
>>>> .../bpf/progs/btf__core_reloc_mods.c          |   3 +
>>>> .../progs/btf__core_reloc_mods___mod_swap.c   |   3 +
>>>> .../progs/btf__core_reloc_mods___typedefs.c   |   3 +
>>>> .../bpf/progs/btf__core_reloc_nesting.c       |   3 +
>>>> .../btf__core_reloc_nesting___anon_embed.c    |   3 +
>>>> ...f__core_reloc_nesting___dup_compat_types.c |   5 +
>>>> ...core_reloc_nesting___err_array_container.c |   3 +
>>>> ...tf__core_reloc_nesting___err_array_field.c |   3 +
>>>> ...e_reloc_nesting___err_dup_incompat_types.c |   4 +
>>>> ...re_reloc_nesting___err_missing_container.c |   3 +
>>>> ...__core_reloc_nesting___err_missing_field.c |   3 +
>>>> ..._reloc_nesting___err_nonstruct_container.c |   3 +
>>>> ...e_reloc_nesting___err_partial_match_dups.c |   4 +
>>>> .../btf__core_reloc_nesting___err_too_deep.c  |   3 +
>>>> .../btf__core_reloc_nesting___extra_nesting.c |   3 +
>>>> ..._core_reloc_nesting___struct_union_mixup.c |   3 +
>>>> .../bpf/progs/btf__core_reloc_primitives.c    |   3 +
>>>> ...f__core_reloc_primitives___diff_enum_def.c |   3 +
>>>> ..._core_reloc_primitives___diff_func_proto.c |   3 +
>>>> ...f__core_reloc_primitives___diff_ptr_type.c |   3 +
>>>> ...tf__core_reloc_primitives___err_non_enum.c |   3 +
>>>> ...btf__core_reloc_primitives___err_non_int.c |   3 +
>>>> ...btf__core_reloc_primitives___err_non_ptr.c |   3 +
>>>> .../bpf/progs/btf__core_reloc_ptr_as_arr.c    |   3 +
>>>> .../btf__core_reloc_ptr_as_arr___diff_sz.c    |   3 +
>>>> .../selftests/bpf/progs/core_reloc_types.h    | 642 +++++++++++++
>>>> .../bpf/progs/test_core_reloc_arrays.c        |  58 ++
>>>> .../bpf/progs/test_core_reloc_flavors.c       |  65 ++
>>>> .../bpf/progs/test_core_reloc_ints.c          |  48 +
>>>> .../bpf/progs/test_core_reloc_kernel.c        |  39 +
>>>> .../bpf/progs/test_core_reloc_mods.c          |  68 ++
>>>> .../bpf/progs/test_core_reloc_nesting.c       |  48 +
>>>> .../bpf/progs/test_core_reloc_primitives.c    |  50 +
>>>> .../bpf/progs/test_core_reloc_ptr_as_arr.c    |  34 +
>>>> 58 files changed, 2527 insertions(+), 47 deletions(-)
>>>> create mode 100644 tools/testing/selftests/bpf/prog_tests/core_reloc.c
>>>> create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_a=
rrays.c
>>>> create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_a=
rrays___diff_arr_dim.c
>>>> create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_a=
rrays___diff_arr_val_sz.c
>>>> create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_a=
rrays___err_non_array.c
>>>> create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_a=
rrays___err_too_shallow.c
>>>> create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_a=
rrays___err_too_small.c
>>>> create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_a=
rrays___err_wrong_val_type1.c
>>>> create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_a=
rrays___err_wrong_val_type2.c
>>>> create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_f=
lavors.c
>>>> create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_f=
lavors__err_wrong_name.c
>>>> create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_i=
nts.c
>>>> create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_i=
nts___bool.c
>>>> create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_i=
nts___err_bitfield.c
>>>> create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_i=
nts___err_wrong_sz_16.c
>>>> create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_i=
nts___err_wrong_sz_32.c
>>>> create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_i=
nts___err_wrong_sz_64.c
>>>> create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_i=
nts___err_wrong_sz_8.c
>>>> create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_i=
nts___reverse_sign.c
>>>> create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_m=
ods.c
>>>> create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_m=
ods___mod_swap.c
>>>> create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_m=
ods___typedefs.c
>>>> create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_n=
esting.c
>>>> create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_n=
esting___anon_embed.c
>>>> create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_n=
esting___dup_compat_types.c
>>>> create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_n=
esting___err_array_container.c
>>>> create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_n=
esting___err_array_field.c
>>>> create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_n=
esting___err_dup_incompat_types.c
>>>> create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_n=
esting___err_missing_container.c
>>>> create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_n=
esting___err_missing_field.c
>>>> create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_n=
esting___err_nonstruct_container.c
>>>> create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_n=
esting___err_partial_match_dups.c
>>>> create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_n=
esting___err_too_deep.c
>>>> create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_n=
esting___extra_nesting.c
>>>> create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_n=
esting___struct_union_mixup.c
>>>> create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_p=
rimitives.c
>>>> create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_p=
rimitives___diff_enum_def.c
>>>> create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_p=
rimitives___diff_func_proto.c
>>>> create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_p=
rimitives___diff_ptr_type.c
>>>> create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_p=
rimitives___err_non_enum.c
>>>> create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_p=
rimitives___err_non_int.c
>>>> create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_p=
rimitives___err_non_ptr.c
>>>> create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_p=
tr_as_arr.c
>>>> create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_p=
tr_as_arr___diff_sz.c
>>>> create mode 100644 tools/testing/selftests/bpf/progs/core_reloc_types.=
h
>>>> create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_a=
rrays.c
>>>> create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_f=
lavors.c
>>>> create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_i=
nts.c
>>>> create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_k=
ernel.c
>>>> create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_m=
ods.c
>>>> create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_n=
esting.c
>>>> create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_p=
rimitives.c
>>>> create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_p=
tr_as_arr.c
>>>=20
>>> We have created a lot of small files. Would it be cleaner if we can
>>> somehow put these
>>> data in one file (maybe different sections?).
>>=20
>> After reading more, I guess you have tried this and end up with current
>> design: keep most struct defines in core_reloc_types.h.
>=20
> Yeah, I have all the definition in one header file, but then I need
> individual combinations as separate BTFs, so I essentially "pick"
> desired types using function declarations. Creating those BTFs by hand
> would be a nightmare to create and maintain.
>=20
>>=20
>>>=20
>>> Alternatively, maybe create a folder for these files:
>>>  tools/testing/selftests/bpf/progs/core/
>>=20
>> I guess this would still make it cleaner.
>=20
> There is nothing too special about core tests to split them. Also it
> would require Makefile changes and would deviate test_progs
> definitions from analogous test_maps, test_verifier, test_btf, etc, so
> I'm not sure about that. I though about putting those btf__* files
> under separate directory, but I'm on the fence there as well, as I'd
> rather have related files to stay together...
>=20

I guess we can defer this decision to later. So I am OK with current
approach for now.=20

Thanks,
Song

