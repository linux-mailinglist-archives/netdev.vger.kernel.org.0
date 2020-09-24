Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C14F1277AB6
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 22:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726606AbgIXUtb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 16:49:31 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:6100 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725208AbgIXUta (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 16:49:30 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08OKj7mu016548;
        Thu, 24 Sep 2020 13:49:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=VWfmBB5GJJN9U4wCcljHdtyYKJZFE9sOEXCdWJ0M4T8=;
 b=Ye+wk1pHVMpTcVpR37JPp5vLwZ3BNr/f58unAeFasm5s4oFNee9FzcFjERbpV62ozj2E
 VmWnvNc0y1aTc9NoYDUZhIa1D2RuBPYfU3H3ypYNMu9D2TKIGLJq4SdcvQi72dpwnKdP
 lwapyM0UjqXWyA7ugp+Vw1yg8wY1plzP6lw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33qsp4kxdq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 24 Sep 2020 13:49:15 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 24 Sep 2020 13:49:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BhLtkqKceF0J7ZVYcWpY60vYeK9hExm+tusvzIqFva2PxwdabcDw8MZgHkaYwe6Yb0H8BhAJAq857l0mZBIw9+Hr64/ARbYVNNlx8qkspAEMORwMFrgVrSK+YCOLF+yU468nmdVcUu3fMZvmH6PU5wcnqfYxQeCCyelok5iA1kkHFu7q+muPXCQ8jV5r8Rio2fn7puoFfNKPcYWt0NdMcquEWUYSFNkLGhKowyKviHgOfj4RsmZ7aPl5YbSi+w0n7wh2hiP3FCn1nJaki5pgvcPlMvqBCdTUzICv+kD/B0EqkVClBgDuM6AIfTcjTEQglPoHoiHshcHXgPnsqKugwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VWfmBB5GJJN9U4wCcljHdtyYKJZFE9sOEXCdWJ0M4T8=;
 b=CaDsXH8By1ON4f/8wYrbLJgVEaoBBCvfyqAsX6cMwlUUaNs0UVbKQWHRNqTk682l3p4rHM++R/fV2TnFBdTv1zbcIEqFZr8HfOwp8JFtY2UnLZ0igzsAMkiCRs7Fw9BsloaRVCPV3lPpADPlgO0qiKxno4C+at7A3u2x098uGi1wEuGBn9+ZImLsg+74mVL6o9en35EUccpaUvma8Zdl+1CZXk/fuf3uvfxYA3tZEHwK6dURaz6YtiBPbXK9E2mtsggDkOCe6RjJ4Lwz89xwSAHTRGuZGhZYj2qiqcO0xuR5RLsZum/FePketQRBVy+CVqBfdj7mBswwM7eNQ2d7lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VWfmBB5GJJN9U4wCcljHdtyYKJZFE9sOEXCdWJ0M4T8=;
 b=BsfeUe/X8Wl0Xj+7326oBsiksnHjhXiFWdXfF9XXuxmtqbkTwW4WJLXB9WvB7zH5eAVsTBimA3S21uNzTSB6DfhRiqvu7/VilRqxPU5pbT0rCq0Kr4qRLP5QUe0OJpXYbsCSuyXCeRoH8s+9Hhys0/5fi3Rgh8TvoHwGuDip3ds=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2584.namprd15.prod.outlook.com (2603:10b6:a03:150::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14; Thu, 24 Sep
 2020 20:49:10 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d%7]) with mapi id 15.20.3412.020; Thu, 24 Sep 2020
 20:49:10 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "Kernel Team" <Kernel-team@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [PATCH v4 bpf-next 1/3] bpf: enable BPF_PROG_TEST_RUN for
 raw_tracepoint
Thread-Topic: [PATCH v4 bpf-next 1/3] bpf: enable BPF_PROG_TEST_RUN for
 raw_tracepoint
Thread-Index: AQHWkhDV1qnL3WFzGUiPpjWbeOTwoKl4NYgAgAAOo4A=
Date:   Thu, 24 Sep 2020 20:49:10 +0000
Message-ID: <AC6F846A-0ED4-45F3-9B77-553014B36D3A@fb.com>
References: <20200924011951.408313-1-songliubraving@fb.com>
 <20200924011951.408313-2-songliubraving@fb.com>
 <CAEf4Bzasv2wJZ32G0K9aohZN=s7nys5LMcM4MywyMxBW7baOsQ@mail.gmail.com>
In-Reply-To: <CAEf4Bzasv2wJZ32G0K9aohZN=s7nys5LMcM4MywyMxBW7baOsQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.1)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:cb37]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 02fab427-c9e4-431e-0b69-08d860cb49b9
x-ms-traffictypediagnostic: BYAPR15MB2584:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB25848C7645F3A121F1818637B3390@BYAPR15MB2584.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sLHj0ATKM/3wfEOD6Au5AVdcn1v4Z1kmGmgEDVvBKAwU69Pm1QoPM3bQePksJtwuusCzsvmd2is6q8kau+fWls1KDgm9saSIiZ/JbCRnr9rgxDLy6GlkJgDXOlLWIX/me05xb5kc6NgrX4EQQdROg6qthNvjNetmBu6oQsv09W7COpFWTE76CuvZ0g4jCaOHcE+GQmDs5Oo2M881b3DTCEynuCYp14oe03Ze6OtGnLDjY/ewSgCONUFzF6feMKOtDACN/3ZvHw7UjOAnXpfHiAMuth2U67k7mbKzv+TzjWolD+8Eb3KkhFQ3Ra58BuWqp3E2E+YkFjtrS0u4HX05Dg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(376002)(136003)(39860400002)(346002)(2906002)(76116006)(8676002)(6512007)(83380400001)(478600001)(54906003)(36756003)(8936002)(6916009)(6486002)(186003)(33656002)(71200400001)(4326008)(66556008)(66476007)(2616005)(5660300002)(91956017)(6506007)(64756008)(86362001)(66446008)(66946007)(53546011)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: eszgEhpq/FEXfOq1E+LFFfBji6ltDTsrJN9Byo8hnIuMU20oxbpeyta5uqNgXlP/1iUIwvX6vVAmBMqdMbDm0YT4blN6VEXhK7PvD2i28E7Y78EnAuWq0FC25u719X4FB4PGMkH9OK/D0FnskztQslHaO9xlR1XLmXKX4FZD0r2rrmKUPhBF01hREPmKewmuRjAmAeqafAZpeNjXNahasPNtj/O/S7XgIRlhWwm/kkSVyy73I8rkf6wexx2+E9xeVDMmuQbFtiLB5RN4p3NXqY5lHEQSoV/KNLOEsYQPnok8sPsEEqR3ibiZrexDFCEFvLtdQaJ45uviPCGFIpalCGpG2SOAVWwx6tt66F0jK66M1qkm+W5Fl7FgXCRobXfS3LKyPO7K16wSSTLx3phLOVlDtXmFJzEYlCi012KGIAEPfanufn/7+6gWUEdNSjGJIiB+H2/g/hRDm57ZrizNH+6G+apRhbiTvvboytP3KKbKiBFaqaTMEUEFj3GQ4YZhUzY+G24SYIXxd3Sg56H8IA+cqWiFrOgnF1NfGSmoSmfTpsXthhmNeF/zIeCzAGe2QN78HzMuk+2S7vjrleIeNK1IGclW5BFZC1dGcKJk8tVrH0R8uryqWHR3ZXtAdtHulpOY3E4w83gh5RpsS1OCrJQG2JVTOxIptiNjVNJC/Iek2Tz3jWrs+aFeEuB07S+b
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6433FF7790BEB64899A1BC7AA2807C92@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02fab427-c9e4-431e-0b69-08d860cb49b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2020 20:49:10.2917
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ++Bx/2egsldfDeFC/zv7eIJsZU+HxDb/2wQ2ZHbU/oHUVihNRTCtx2YWryjm1dEdzqfwhH+lWnp3SuSe2FFaGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2584
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-24_15:2020-09-24,2020-09-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 priorityscore=1501 lowpriorityscore=0 phishscore=0 mlxscore=0 adultscore=0
 impostorscore=0 clxscore=1015 malwarescore=0 bulkscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009240152
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Sep 24, 2020, at 12:56 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com>=
 wrote:
>=20
> On Wed, Sep 23, 2020 at 6:46 PM Song Liu <songliubraving@fb.com> wrote:
>>=20
>> Add .test_run for raw_tracepoint. Also, introduce a new feature that run=
s
>> the target program on a specific CPU. This is achieved by a new flag in
>> bpf_attr.test, BPF_F_TEST_RUN_ON_CPU. When this flag is set, the program
>> is triggered on cpu with id bpf_attr.test.cpu. This feature is needed fo=
r
>> BPF programs that handle perf_event and other percpu resources, as the
>> program can access these resource locally.
>>=20
>> Acked-by: John Fastabend <john.fastabend@gmail.com>
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>> ---
>> include/linux/bpf.h            |  3 ++
>> include/uapi/linux/bpf.h       |  7 +++
>> kernel/bpf/syscall.c           |  2 +-
>> kernel/trace/bpf_trace.c       |  1 +
>> net/bpf/test_run.c             | 89 ++++++++++++++++++++++++++++++++++
>> tools/include/uapi/linux/bpf.h |  7 +++
>> 6 files changed, 108 insertions(+), 1 deletion(-)
>>=20
>=20
> [...]
>=20
>> +int bpf_prog_test_run_raw_tp(struct bpf_prog *prog,
>> +                            const union bpf_attr *kattr,
>> +                            union bpf_attr __user *uattr)
>> +{
>> +       void __user *ctx_in =3D u64_to_user_ptr(kattr->test.ctx_in);
>> +       __u32 ctx_size_in =3D kattr->test.ctx_size_in;
>> +       struct bpf_raw_tp_test_run_info info;
>> +       int cpu, err =3D 0;
>> +
>> +       /* doesn't support data_in/out, ctx_out, duration, or repeat */
>> +       if (kattr->test.data_in || kattr->test.data_out ||
>> +           kattr->test.ctx_out || kattr->test.duration ||
>> +           kattr->test.repeat)
>=20
> duration and repeat sound generally useful (benchmarking raw_tp
> programs), so it's a pity you haven't implemented them. But it can be
> added later, so not a deal breaker.
>=20
>> +               return -EINVAL;
>> +
>> +       if (ctx_size_in < prog->aux->max_ctx_offset)
>> +               return -EINVAL;
>> +
>> +       if (ctx_size_in) {
>> +               info.ctx =3D kzalloc(ctx_size_in, GFP_USER);
>> +               if (!info.ctx)
>> +                       return -ENOMEM;
>> +               if (copy_from_user(info.ctx, ctx_in, ctx_size_in)) {
>> +                       err =3D -EFAULT;
>> +                       goto out;
>> +               }
>> +       } else {
>> +               info.ctx =3D NULL;
>> +       }
>> +
>> +       info.prog =3D prog;
>> +       cpu =3D kattr->test.cpu;
>> +
>> +       if ((kattr->test.flags & BPF_F_TEST_RUN_ON_CPU) =3D=3D 0 ||
>> +           cpu =3D=3D smp_processor_id()) {
>=20
> should we enforce that cpu =3D=3D 0 if BPF_F_TEST_RUN_ON_CPU is not set?

Added a test.=20

>=20
>=20
>> +               __bpf_prog_test_run_raw_tp(&info);
>> +       } else {
>> +               /* smp_call_function_single() also checks cpu_online()
>> +                * after csd_lock(). However, since cpu_plus is from use=
r
>=20
> cpu_plus leftover in a comment

Fixed.=20

>=20
>> +                * space, let's do an extra quick check to filter out
>> +                * invalid value before smp_call_function_single().
>> +                */
>> +               if (!cpu_online(cpu)) {
>=20
> briefly looking at cpu_online() code, it seems like it's not checking
> that cpu is < NR_CPUS. Should we add a selftest that validates that
> passing unreasonable cpu index doesn't generate warning or invalid
> memory access?

Good catch! We need extra "cpu >=3D nr_cpu_ids".

Thanks,
Song=
