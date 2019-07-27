Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 282E277B4F
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 20:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388064AbfG0S7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 14:59:36 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:25358 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387975AbfG0S7f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 14:59:35 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6RIwtpT025313;
        Sat, 27 Jul 2019 11:59:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=0V4pls2kdCQ2nojjrB7Zz5MiqtG2rkvI3410krJzt1o=;
 b=G7rQVdkG53rQNkCxv4+Hxq1aJkL4JXqWz4C4iwC4rtGADoAqan7kxgc9rqQdX13zPCB6
 zlVqDCUs334LixPNgKozE/S9GZAmmj4ZvUrCylITUGroB0MAi4bN6MB8tp0WZ8DwxTQL
 Um+mKfrUWKWSUEpTKH+dbSW37Ht5SgeMl3Q= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2u0me8s49k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 27 Jul 2019 11:59:13 -0700
Received: from ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) by
 ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 27 Jul 2019 11:59:12 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Sat, 27 Jul 2019 11:59:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KYqVPNKrSDpU7Nh6MOTE9Vg72ArtuHm2DIPm0gGzyLaUo+Ga6NKTzwEnZT9humxD63iw7NW2z2EHGkXDlnZvHQUMvOBfqHWMVc3OD3B1+8nxb0Lkgl0Dx/Ur5frQRYkKH50gY1p2+8Ywa4UgeX8SMbblkUBH4xIBS2QlDEnT8wM8TLUC5nTNPgW4pTvMxNIS/gn/VDFAprFLP0B/MGlwo0qpJElEhOlp9PwIrT9bNk//RQk/1VcChJwshuCkcnOKk7C3CFKxUu0FiZ0HT86/ew9c/yMXO9da/wcfr+aRGsVPT7cD89s91wX2rmPhacyrwMCJx/7na8YNrHSKvABLUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0V4pls2kdCQ2nojjrB7Zz5MiqtG2rkvI3410krJzt1o=;
 b=oXvpSLZwUtTDltvtUSxq76ecDFmDVnSWokCWPl5JG+J2rY17V61xlkKSlaSDZUrXSgv8VFwsFBDR8D/luzBrIiBa8jL3rKl6kwvfejqpdaQbqAT5q6ftc9Oy8lHVl40gYhOwYlcV5BctT8Mq6OvUb/YYb3eW4VQsWmeOI+tGUsfNViLTL6GjQo5v4hXgd11ydVk9bRdLEH0YFgUilbJxHo+oxaMIuk++f58rj6kG8H//Nc0gf0iL0M2HR103qcSEvho1lzH53LJCEjjGC4s3IYWbs2ECEYHzQPQrKsXuDwUceELoVuowCm4NsCAHYmuB4NuPirhAFDQuo/r6GDRBSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0V4pls2kdCQ2nojjrB7Zz5MiqtG2rkvI3410krJzt1o=;
 b=RK5VMRJVA1UI5N7bx4QghucmlcszCCucODPzHsx2sEGG2D1Ro4kjqcugehsy8q7YurkOK6/TpHhpvPGrkqQaeAmZZbOq0U8xZ35P6SRc+XzIyEi9TfZOaFIalVCVvHk0NWTdp3dY28m6coM0i3rdIio+XQrJSFRZCMQ/Na5a+z8=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1280.namprd15.prod.outlook.com (10.175.3.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.14; Sat, 27 Jul 2019 18:59:11 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::d4fc:70c0:79a5:f41b]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::d4fc:70c0:79a5:f41b%2]) with mapi id 15.20.2115.005; Sat, 27 Jul 2019
 18:59:11 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 02/10] libbpf: implement BPF CO-RE offset
 relocation algorithm
Thread-Topic: [PATCH bpf-next 02/10] libbpf: implement BPF CO-RE offset
 relocation algorithm
Thread-Index: AQHVQlYfQU29UbcfIEO0wFH+SyI9nKbbutUAgAJEsQCAANaMAA==
Date:   Sat, 27 Jul 2019 18:59:11 +0000
Message-ID: <9EE75932-5AED-49D3-86BF-D1FC2A139BF8@fb.com>
References: <20190724192742.1419254-1-andriin@fb.com>
 <20190724192742.1419254-3-andriin@fb.com>
 <2D563869-72E5-4623-B239-173EE2313084@fb.com>
 <CAEf4BzZKA29xudKC8WWEXJq+egTCgX4bV9KaE0Y+_u50=D70iQ@mail.gmail.com>
In-Reply-To: <CAEf4BzZKA29xudKC8WWEXJq+egTCgX4bV9KaE0Y+_u50=D70iQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::1:6595]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 92ffa24e-8c96-420d-b8c0-08d712c482dc
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1280;
x-ms-traffictypediagnostic: MWHPR15MB1280:
x-microsoft-antispam-prvs: <MWHPR15MB1280C1D7323C930D3DF1614AB3C30@MWHPR15MB1280.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01110342A5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(376002)(396003)(136003)(346002)(39860400002)(51914003)(189003)(199004)(54534003)(6512007)(99286004)(7736002)(6486002)(4326008)(2906002)(305945005)(86362001)(229853002)(71200400001)(71190400001)(6116002)(6436002)(6916009)(33656002)(36756003)(11346002)(30864003)(68736007)(486006)(476003)(2616005)(5660300002)(25786009)(478600001)(66946007)(66476007)(66556008)(64756008)(76116006)(14454004)(66446008)(46003)(186003)(8676002)(57306001)(102836004)(14444005)(256004)(54906003)(53546011)(316002)(6506007)(76176011)(81166006)(81156014)(8936002)(50226002)(6246003)(446003)(53936002)(21314003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1280;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 1vQ20WzPpjRUIYu5GC8nOiwnqmorje0aQlHj/r+2lhZTGVK2me4THw/dlC+TiMNMql535r5fAYQ55JgFvirUoRzEK4zWM9THRffvmSfVqVcL2hs6K6EDwh+epFmdLgn5AaYu5ShoGMdhexICqcfhzcujRKJwp4MYAivkLTUr+cDG3aJ7/EEJZOfaWT306m0EkyvcmvqDnR5hC17kJqb2tHRz2WNNo6IyZnFhwuMd/jChAlcwcP3EBfVvOIRVs9wGPOn9dNcOndSPp4wskA/RxlGIWylt9kD+NQ2tlmsLsVknCjqnui4PupnC1XpdhZs3yDII4XHIV7+Gk4j6IvdlcHpJbxO3hWr+jH7L+6pOkNr5B+PrxgTqJY2SM2ODrZkzlfQG7Mlcbquhz9FHpIUwG+9V9CDTAIBzP14DjybQE4g=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <25A06F17376953429D979D9D984DB694@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 92ffa24e-8c96-420d-b8c0-08d712c482dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jul 2019 18:59:11.2586
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1280
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-27_15:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907270237
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 26, 2019, at 11:11 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com>=
 wrote:
>=20
> On Thu, Jul 25, 2019 at 12:32 PM Song Liu <songliubraving@fb.com> wrote:
>>=20
>>=20
>>=20
>>> On Jul 24, 2019, at 12:27 PM, Andrii Nakryiko <andriin@fb.com> wrote:
>>>=20
>>> This patch implements the core logic for BPF CO-RE offsets relocations.
>>> All the details are described in code comments.
>>=20
>> Some description in the change log is still useful. Please at least
>> copy-paste key comments here.
>=20
> OK, will add some more.
>=20
>>=20
>> And, this is looooong. I think it is totally possible to split it into
>> multiple smaller patches.
>=20
> I don't really know how to split it further without hurting reviewing
> by artificially splitting related code into separate patches. Remove
> any single function and algorithm will be incomplete.
>=20
> Let me give you some high-level overview of how pieces are put
> together. There are 9 non-trivial functions, let's go over their
> purpose in the orderd in which they are defined in file:
>=20
> 1. bpf_core_spec_parse()
>=20
> This one take bpf_offset_reloc's type_id and accessor string
> ("0:1:2:3") and parses it into more convenient bpf_core_spec
> datastructure, which has calculated offset and high-level spec
> "steps": either named field or array access.
>=20
> 2. bpf_core_find_cands()
>=20
> Given local type name, finds all possible target BTF types with same
> name (modulo "flavor" differences, ___flavor suffix is just ignored).
>=20
> 3. bpf_core_fields_are_compat()
>=20
> Given local and target field match, checks that their types are
> compatible (so that we don't accidentally match, e.g., int against
> struct).
>=20
> 4. bpf_core_match_member()
>=20
> Given named local field, find corresponding field in target struct. To
> understand why it's not trivial, here's an example:
>=20
> Local type:
>=20
> struct s___local {
>  int a;
> };
>=20
> Target type:
>=20
> struct s___target {
>  struct {
>    union {
>      int a;
>    };
>  };
> };
>=20
> For both cases you can access a as s.a, but in local case, field a is
> immediately inside s___local, while for s___target, you have to
> traverse two levels deeper into anonymous fields to get to an `a`
> inside anonymous union.
>=20
> So this function find that `a` by doing exhaustive search across all
> named field and anonymous struct/unions. But otherwise it's pretty
> straightforward recursive function.
>=20
> bpf_core_spec_match()
>=20
> Just goes over high-level spec steps in local spec and tries to figure
> out both high-level and low-level steps for targe type. Consider the
> above example. For both structs accessing s.a is one high-level step,
> but for s___local it's single low-level step (just another :0 in spec
> string), while for s___target it's three low-level steps: ":0:0:0",
> one step for each BTF type we need to traverse.
>=20
> Array access is simpler, it's always one high-level and one low-level ste=
p.
>=20
> bpf_core_reloc_insn()
>=20
> Once we match local and target specs and have local and target
> offsets, do the relocations - check that instruction has expected
> local offset and replace it with target offset.
>=20
> bpf_core_find_kernel_btf()
>=20
> This is the only function that can be moved into separate patch, but
> it's also very simple. It just iterates over few known possible
> locations for vmlinux image and once found, tries to parse .BTF out of
> it, to be used as target BTF.
>=20
> bpf_core_reloc_offset()
>=20
> It combines all the above functions to perform single relocation.
> Parse spec, get candidates, for each candidate try to find matching
> target spec. All candidates that matched are cached for given local
> root type.

Thanks for these explanation. They are really helpful.=20

I think some example explaining each step of bpf_core_reloc_offset()
will be very helpful. Something like:

Example:

struct s {
	int a;
	struct {
		int b;
		bool c;
	};
};

To get offset for c, we do:

bpf_core_reloc_offset() {
=09
	/* input data: xxx */

	/* first step: bpf_core_spec_parse() */

	/* data after first step */

	/* second step: bpf_core_find_cands() */

	/* candidate A and B after second step */

	...
}

Well, it requires quite some work to document this way. Please let me=20
know if you feel this is an overkill.=20

>=20
> bpf_core_reloc_offsets()
>=20
> High-level coordination. Iterate over all per-program .BTF.ext offset
> reloc sections, each relocation within them. Find corresponding
> program and try to apply relocations one by one.
>=20
>=20
> I think the only non-obvious part here is to understand that
> relocation records local raw spec with every single anonymous type
> traversal, which is not that useful when we try to match it against
> target type, which can have very different composition, but still the
> same field access pattern, from C language standpoint (which hides all
> those anonymous type traversals from programmer).
>=20
> But it should be pretty clear now, plus also check tests, they have
> lots of cases showing what's compatible and what's not.

I see. I will review the tests.=20

>>>=20
>>> static const struct btf_type *skip_mods_and_typedefs(const struct btf *=
btf,
>>> -                                                  __u32 id)
>>> +                                                  __u32 id,
>>> +                                                  __u32 *res_id)
>>> {
>>>      const struct btf_type *t =3D btf__type_by_id(btf, id);
>>=20
>> Maybe have a local "__u32 rid;"
>>=20
>>>=20
>>> +     if (res_id)
>>> +             *res_id =3D id;
>>> +
>>=20
>> and do "rid =3D id;" here
>>=20
>>>      while (true) {
>>>              switch (BTF_INFO_KIND(t->info)) {
>>>              case BTF_KIND_VOLATILE:
>>>              case BTF_KIND_CONST:
>>>              case BTF_KIND_RESTRICT:
>>>              case BTF_KIND_TYPEDEF:
>>> +                     if (res_id)
>>> +                             *res_id =3D t->type;
>> and here
>>=20
>>>                      t =3D btf__type_by_id(btf, t->type);
>>>                      break;
>>>              default:
>> and "*res_id =3D rid;" right before return?
>=20
> Sure, but why?

I think it is cleaner that way. But feel free to ignore if you
think otherwise.=20

>=20
>>=20
>>> @@ -1041,7 +1049,7 @@ static const struct btf_type *skip_mods_and_typed=
efs(const struct btf *btf,
>>> static bool get_map_field_int(const char *map_name, const struct btf *b=
tf,
>>>                            const struct btf_type *def,
>>>                            const struct btf_member *m, __u32 *res) {
>=20
> [...]
>=20
>>> +struct bpf_core_spec {
>>> +     const struct btf *btf;
>>> +     /* high-level spec: named fields and array indicies only */
>>=20
>> typo: indices
>=20
> thanks!
>=20
>>=20
>>> +     struct bpf_core_accessor spec[BPF_CORE_SPEC_MAX_LEN];
>>> +     /* high-level spec length */
>>> +     int len;
>>> +     /* raw, low-level spec: 1-to-1 with accessor spec string */
>>> +     int raw_spec[BPF_CORE_SPEC_MAX_LEN];
>>> +     /* raw spec length */
>>> +     int raw_len;
>>> +     /* field byte offset represented by spec */
>>> +     __u32 offset;
>>> +};
>=20
> [...]
>=20
>>> + *
>>> + *   int x =3D &s->a[3]; // access string =3D '0:1:2:3'
>>> + *
>>> + * Low-level spec has 1:1 mapping with each element of access string (=
it's
>>> + * just a parsed access string representation): [0, 1, 2, 3].
>>> + *
>>> + * High-level spec will capture only 3 points:
>>> + *   - intial zero-index access by pointer (&s->... is the same as &s[=
0]...);
>>> + *   - field 'a' access (corresponds to '2' in low-level spec);
>>> + *   - array element #3 access (corresponds to '3' in low-level spec).
>>> + *
>>> + */
>>=20
>> IIUC, high-level points are subset of low-level points. How about we int=
roduce
>> "anonymous" high-level points, so that high-level points and low-level p=
oints
>> are 1:1 mapping?
>=20
> No, that will just hurt and complicate things. See above explanation
> about why we need high-level points (it's what you as C programmer try
> to achieve vs low-level spec is what C-language does in reality, with
> all the anonymous struct/union traversal).
>=20
> What's wrong with this separation? Think about it as recording
> "intent" (high-level spec) vs "mechanics" (low-level spec, how exactly
> to achieve that intent, in excruciating details).

There is nothing wrong with separation. I just personally think it is=20
cleaner the other way. That's why I raised the question.=20

I will go with your assessment, as you looked into this much more than=20
I did. :-)

[...]

>>> +
>>> +     memset(spec, 0, sizeof(*spec));
>>> +     spec->btf =3D btf;
>>> +
>>> +     /* parse spec_str=3D"0:1:2:3:4" into array raw_spec=3D[0, 1, 2, 3=
, 4] */
>>> +     while (*spec_str) {
>>> +             if (*spec_str =3D=3D ':')
>>> +                     ++spec_str;
>>> +             if (sscanf(spec_str, "%d%n", &access_idx, &parsed_len) !=
=3D 1)
>>> +                     return -EINVAL;
>>> +             if (spec->raw_len =3D=3D BPF_CORE_SPEC_MAX_LEN)
>>> +                     return -E2BIG;
>>> +             spec_str +=3D parsed_len;
>>> +             spec->raw_spec[spec->raw_len++] =3D access_idx;
>>> +     }
>>> +
>>> +     if (spec->raw_len =3D=3D 0)
>>> +             return -EINVAL;
>>> +
>>> +     for (i =3D 0; i < spec->raw_len; i++) {
>>> +             t =3D skip_mods_and_typedefs(btf, id, &id);
>>> +             if (!t)
>>> +                     return -EINVAL;
>>> +
>>> +             access_idx =3D spec->raw_spec[i];
>>> +
>>> +             if (i =3D=3D 0) {
>>> +                     /* first spec value is always reloc type array in=
dex */
>>> +                     spec->spec[spec->len].type_id =3D id;
>>> +                     spec->spec[spec->len].idx =3D access_idx;
>>> +                     spec->len++;
>>> +
>>> +                     sz =3D btf__resolve_size(btf, id);
>>> +                     if (sz < 0)
>>> +                             return sz;
>>> +                     spec->offset +=3D access_idx * sz;
>>          spec->offset =3D access_idx * sz;  should be enough
>=20
> No. spec->offset is carefully maintained across multiple low-level
> steps, as we traverse down embedded structs/unions.
>=20
> Think about, e.g.:
>=20
> struct s {
>    int a;
>    struct {
>        int b;
>    };
> };
>=20
> Imagine you are trying to match s.b access. With what you propose
> you'll end up with offset 0, but it should be 4.

Hmm... this is just for i =3D=3D 0, right? Which line updated spec->offset
after "memset(spec, 0, sizeof(*spec));"?

>=20
>>=20
>>> +                     continue;
>>> +             }
>>=20
>> Maybe pull i =3D=3D 0 case out of the for loop?
>>=20
>>> +
>>> +             if (btf_is_composite(t)) {
>=20
> [...]
>=20
>>> +
>>> +     if (spec->len =3D=3D 0)
>>> +             return -EINVAL;
>>=20
>> Can this ever happen?
>=20
> Not really, because I already check raw_len =3D=3D 0 and exit with error.
> I'll remove.
>=20
>>=20
>>> +
>>> +     return 0;
>>> +}
>>> +
>=20
> [...]
>=20
>>> +
>>> +/*
>>> + * Given single high-level accessor (either named field or array index=
) in
>>> + * local type, find corresponding high-level accessor for a target typ=
e. Along
>>> + * the way, maintain low-level spec for target as well. Also keep upda=
ting
>>> + * target offset.
>>> + */
>>=20
>> Please describe the recursive algorithm here. I am kinda lost.
>=20
> Explained above. I'll extend description a bit. But it's just
> recursive exhaustive search:
> 1. if struct field is anonymous and is struct/union, go one level
> deeper and try to find field with given name inside those.
> 2. if field has name and it matched what we are searching - check type
> compatibility. It has to be compatible, so if it's not, then it's not
> a match.
>=20
>> Also, please document the meaning of zero, positive, negative return val=
ues.
>=20
> Ok. It's standard <0 - error, 0 - false, 1 - true.
>=20
>>=20
>>> +static int bpf_core_match_member(const struct btf *local_btf,
>>> +                              const struct bpf_core_accessor *local_ac=
c,
>>> +                              const struct btf *targ_btf,
>>> +                              __u32 targ_id,
>>> +                              struct bpf_core_spec *spec,
>>> +                              __u32 *next_targ_id)
>>> +{
>=20
> [...]
>=20
>>> +             if (local_acc->name) {
>>> +                     if (!btf_is_composite(targ_type))
>>> +                             return 0;
>>> +
>>> +                     matched =3D bpf_core_match_member(local_spec->btf=
,
>>> +                                                     local_acc,
>>> +                                                     targ_btf, targ_id=
,
>>> +                                                     targ_spec, &targ_=
id);
>>> +                     if (matched <=3D 0)
>>> +                             return matched;
>>> +             } else {
>>> +                     /* for i=3D0, targ_id is already treated as array=
 element
>>> +                      * type (because it's the original struct), for o=
thers
>>> +                      * we should find array element type first
>>> +                      */
>>> +                     if (i > 0) {
>>=20
>> i =3D=3D 0 case would go into "if (local_acc->name)" branch, no?
>=20
> No, i =3D=3D 0 is always an array access. s->a.b.c is the same as
> s[0].a.b.c, so relocation's first spec element is always either zero
> for pointer access or any non-negative index for array access. But it
> is always array access.

I see. Thanks for the explanation.

Song=
