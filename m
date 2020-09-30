Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3120427F562
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 00:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731808AbgI3WrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 18:47:08 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:14018 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730981AbgI3WrI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 18:47:08 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08UMkEcF023696;
        Wed, 30 Sep 2020 15:46:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=hMbQsGQZse1+Eha7nhu2VCS9upNF2rqBEBInXXJuTDY=;
 b=DKWMLoS68Cgx6DrkVY+tNMZcIBjfacKyd+75j8+BpTYGFj9RC+phbOWCt4fWR1EH2Jwj
 F5aE/wDUw91aNVne6mBOaeuaTcTc/vTcUxuofAhx95gxk7sXNqefFnRwntIJ3unTcyKd
 HELuU0lvcYoctsUJIq0z9w9OPm3L0BfWrO0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33vtgc397n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 30 Sep 2020 15:46:52 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 30 Sep 2020 15:46:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GdONSCjPovZ0HwG+7PFUuKvwHTrHDmtoyXp9VxKV18UX9Q+3iRcmEKKBQC0hkzIq5E45klnxX/LrxWZHv10J/JVztr9AU31K1LecJzp0wPUu5vnSrLOxS+k5asy8/QRjK30WZDtBgHCcv1rV2MjlNSzXy78fI6++/m7Lyxlh13oU6rCiYbHAiDMoKOdYMpRHf4WNGMzubiuN97YOl2n8TtmL5lgP75uEi3zaUz2+FeQOBYqGUJ7KveQ9x2abI9k2dhGNvWIsCnETIYyLs4NGvx/e7YcGT/svUYMLlzjUh0GKAf76dkMP3Ax5X0zJlraQ2PSjZ6b+YyilS3gekBcmvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hMbQsGQZse1+Eha7nhu2VCS9upNF2rqBEBInXXJuTDY=;
 b=D+LCOTwZO/sB+uSTXw7oP9w8XQDBIY5QvvT9ftB5qj6i92U/7MPDsbr4tiHYBoJyNVExezbw/NxCuN4FBO8f+pSqJ0vJpFDInOlV5EmpK0hFspZL5fkno9H/1n7ndHNlibhkqrKNVpR5TasO5tQDtIKCzTOQ9GekUoVNBOMNpc60kfOF3/FfKnj9B/1kyfis8Aj33imAsstdVeC6V9DusVa8sOkNubOfqICvEQTPexyLRUz/L9Ggvj3yl1Hv0mF+8DtYBP7kimFuKxNfkMIuOWTF7K+NAILH7/3DxBZOOWugVwgTSLeYGgDkUhySbhr2pwR7XyH1TwFmhPgQXvU0Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hMbQsGQZse1+Eha7nhu2VCS9upNF2rqBEBInXXJuTDY=;
 b=AYH4ue+jr0QJVG27WAV3ZkJ2OjUESQE4+jWiO/jSW76fz6RD7OEPq1whgUHdyoIsJJNkHq6o+IpQk33MqCh8vXBTaXOFNzaQA+y6Mk447RH/UFl1MKv+JYUTPrikdgkYQlApRm1dgRuMJkbx9uO82PZGsEkTTPk+djJYwM3/yRs=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3464.namprd15.prod.outlook.com (2603:10b6:a03:10a::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32; Wed, 30 Sep
 2020 22:46:48 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d%7]) with mapi id 15.20.3412.029; Wed, 30 Sep 2020
 22:46:48 +0000
From:   Song Liu <songliubraving@fb.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
CC:     Kernel Team <Kernel-team@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>
Subject: Re: [PATCH v4 bpf-next 2/2] selftests/bpf: add tests for
 BPF_F_PRESERVE_ELEMS
Thread-Topic: [PATCH v4 bpf-next 2/2] selftests/bpf: add tests for
 BPF_F_PRESERVE_ELEMS
Thread-Index: AQHWl3CxqHh2EarO3kmZo8RJrS2H/KmByEQA
Date:   Wed, 30 Sep 2020 22:46:47 +0000
Message-ID: <6EE9333C-93C8-47EC-AF4B-F4924177CF99@fb.com>
References: <20200930212824.1418683-1-songliubraving@fb.com>
 <20200930212824.1418683-3-songliubraving@fb.com>
In-Reply-To: <20200930212824.1418683-3-songliubraving@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.1)
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:cb37]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e1fae1f4-3cfc-40b6-a039-08d86592b70e
x-ms-traffictypediagnostic: BYAPR15MB3464:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB3464BB8965FC1E4EBFFB1BB7B3330@BYAPR15MB3464.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ux3gN/TP++JL87UXm2BlGnDiiwtBqYxrhL7FfO+CL8nyUwx7n5V9QzCy8xoN9LbyHHMB/HO7WLu3sgHZFK7AJ7lTUhk10w1ch8xuEqfGx3umG8cWDntPRAZ6as+toHg/Y+GSr/trMQbuLcxCjCtZ/B1XrsHKKUXY+8CB5fzcS7Uh7wISvnn47mgMl+RgjW+9yFo7akCXsUqsHWp5r2Y/N2k4wgXX2YejTQF8yLHAA+/qWlFlCS9NcWkecfNjSrJJFlZf9rLgk4BuoCiOCQN5wgYE27m1GU1jgE+ahp5I3XZojpxlqqEB2aqlPp8DuHhwSx1R4p/dwFgt29PAp90ajA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(136003)(376002)(39860400002)(366004)(4326008)(6506007)(53546011)(66476007)(6486002)(186003)(8936002)(6512007)(36756003)(8676002)(86362001)(76116006)(66946007)(66556008)(64756008)(66446008)(91956017)(478600001)(71200400001)(5660300002)(33656002)(2616005)(54906003)(110136005)(316002)(2906002)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: bAaEZW00gTKMjTrXfIuI27Xy/zICvwC7T7YXXU0QU+lORx9JKyk5gUYdjUCytf3Jv3OWBXMtyp+tHSyZZH6t44cGBq+sYLWArboRsgX6buvnByb86iMIlRBsRVLLeOr3Q5eEIiBGt5PDHrZTBkPZKFtKmuAd3xiYogKLP/jKKeq92DNSzw16E68dF0AhLXdg///x3KSJ/N/zC0din9NMpmNxRRjSkPE9MT+VRuP0ISZBZ2YXjCQJ6aw7ir4ZY3FB7PjTRZRvKCQ+LeXz2egzm0emaX7ILYONsUD2wwb6WyS50QcdFb1TbkgkhHkk8qn8XlxASj1YTOvZdlPawhJNPpq1vmxLFUViWWVhcjmEFK8lqnAr4MyCTfA1yPEMhhv63caDUXMTw9Z6Jggd5gkNQffakciIVXakSDtVa6HqHe8flw3JsFxQNyrCMDeXJwpZV96t0RFTn3P6YGX8payd2vnDn0/mWul6ontnWLpQE6jMc9gF4d2WBYrAqqgMCaU3KOJNmov6D97zRdjmOXtZDpeZftiJW3+DjERZTC3uf1KISQOPGatkn3S5DNv15IM55hrY1x51eolBX62TF0bcJkbOlDqZ0dJ4vcrl/h5ugzG92dgGlZdryFRpbpIACfpXS9a42PXxU56o4kZ7bneEBjpnu+QphJn38oSoRe/RHAjYEhg7uYCs9TbIMq/Zf65D
Content-Type: text/plain; charset="us-ascii"
Content-ID: <167CC3D36204C840B83478C8BE0029BF@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1fae1f4-3cfc-40b6-a039-08d86592b70e
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2020 22:46:47.7948
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: INh9dtmTc1DpmWhRB9GM1quJxD3zFYHivk7Z8EhA+znJ8pHCv4V3UVlhM8HOWWcp1G061kaTfzZaP1xXO6YRvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3464
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-30_13:2020-09-30,2020-09-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 bulkscore=0
 lowpriorityscore=0 suspectscore=0 impostorscore=0 phishscore=0
 adultscore=0 priorityscore=1501 malwarescore=0 mlxlogscore=999 mlxscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009300183
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Sep 30, 2020, at 2:28 PM, Song Liu <songliubraving@fb.com> wrote:
>=20
> Add tests for perf event array with and without BPF_F_PRESERVE_ELEMS.
>=20
> Add a perf event to array via fd mfd. Without BPF_F_PRESERVE_ELEMS, the
> perf event is removed when mfd is closed. With BPF_F_PRESERVE_ELEMS, the
> perf event is removed when the map is freed.
>=20
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
> .../bpf/prog_tests/pe_preserve_elems.c        | 66 +++++++++++++++++++
> .../bpf/progs/test_pe_preserve_elems.c        | 44 +++++++++++++
> 2 files changed, 110 insertions(+)
> create mode 100644 tools/testing/selftests/bpf/prog_tests/pe_preserve_ele=
ms.c
> create mode 100644 tools/testing/selftests/bpf/progs/test_pe_preserve_ele=
ms.c
>=20
> diff --git a/tools/testing/selftests/bpf/prog_tests/pe_preserve_elems.c b=
/tools/testing/selftests/bpf/prog_tests/pe_preserve_elems.c
> new file mode 100644
> index 0000000000000..673d38395253b
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/pe_preserve_elems.c
> @@ -0,0 +1,66 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright (c) 2019 Facebook */
> +#include <test_progs.h>
> +#include <linux/bpf.h>
> +#include "test_pe_preserve_elems.skel.h"
> +
> +static int duration;
> +
> +static void test_one_map(struct bpf_map *map, struct bpf_program *prog,
> +			 bool has_share_pe)
> +{
> +	int err, key =3D 0, pfd =3D -1, mfd =3D bpf_map__fd(map);
> +	DECLARE_LIBBPF_OPTS(bpf_test_run_opts, opts);
> +	struct perf_event_attr attr =3D {
> +		.size =3D sizeof(struct perf_event_attr),
> +		.type =3D PERF_TYPE_SOFTWARE,
> +		.config =3D PERF_COUNT_SW_CPU_CLOCK,
> +	};
> +
> +	pfd =3D syscall(__NR_perf_event_open, &attr, 0 /* pid */,
> +		      -1 /* cpu 0 */, -1 /* group id */, 0 /* flags */);
> +	if (CHECK(pfd < 0, "perf_event_open", "failed\n"))
> +		return;
> +
> +	err =3D bpf_map_update_elem(mfd, &key, &pfd, BPF_ANY);
> +	close(pfd);
> +	if (CHECK(err < 0, "bpf_map_update_elem", "failed\n"))
> +		return;
> +
> +	err =3D bpf_prog_test_run_opts(bpf_program__fd(prog), &opts);
> +	if (CHECK(err < 0, "bpf_prog_test_run_opts", "failed\n"))
> +		return;
> +	if (CHECK(opts.retval !=3D 0, "bpf_perf_event_read_value",
> +		  "failed with %d\n", opts.retval))
> +		return;
> +
> +	/* closing mfd, prog still holds a reference on map */
> +	close(mfd);
> +
> +	err =3D bpf_prog_test_run_opts(bpf_program__fd(prog), &opts);
> +	if (CHECK(err < 0, "bpf_prog_test_run_opts", "failed\n"))
> +		return;
> +
> +	if (has_share_pe) {
> +		CHECK(opts.retval !=3D 0, "bpf_perf_event_read_value",
> +		      "failed with %d\n", opts.retval);
> +	} else {
> +		CHECK(opts.retval !=3D -ENOENT, "bpf_perf_event_read_value",
> +		      "should have failed with %d, but got %d\n", -ENOENT,
> +		      opts.retval);
> +	}
> +}
> +
> +void test_pe_preserve_elems(void)
> +{
> +	struct test_pe_preserve_elems *skel;
> +
> +	skel =3D test_pe_preserve_elems__open_and_load();
> +	if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
> +		return;
> +
> +	test_one_map(skel->maps.array_1, skel->progs.read_array_1, false);
> +	test_one_map(skel->maps.array_2, skel->progs.read_array_2, true);
> +
> +	test_pe_preserve_elems__destroy(skel);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/test_pe_preserve_elems.c b=
/tools/testing/selftests/bpf/progs/test_pe_preserve_elems.c
> new file mode 100644
> index 0000000000000..dc77e406de41f
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_pe_preserve_elems.c
> @@ -0,0 +1,44 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (c) 2020 Facebook
> +#include "vmlinux.h"
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +
> +struct {
> +	__uint(type, BPF_MAP_TYPE_PERF_EVENT_ARRAY);
> +	__uint(max_entries, 1);
> +	__uint(key_size, sizeof(int));
> +	__uint(value_size, sizeof(int));
> +} array_1 SEC(".maps");
> +
> +struct {
> +	__uint(type, BPF_MAP_TYPE_PERF_EVENT_ARRAY);
> +	__uint(max_entries, 1);
> +	__uint(key_size, sizeof(int));
> +	__uint(value_size, sizeof(int));
> +	__uint(map_flags, BPF_F_PRESERVE_ELEMS);
> +} array_2 SEC(".maps");
> +
> +SEC("raw_tp/sched_switch")
> +int BPF_PROG(read_array_1)
> +{
> +	struct bpf_perf_event_value val;
> +	long ret;
> +
> +	ret =3D bpf_perf_event_read_value(&array_1, 0, &val, sizeof(val));
> +	bpf_printk("read_array_1 returns %ld", ret);

Oops, I didn't do amend... Please ignore this version..

I am so sorry for the problem...

Song

> +	return ret;
> +}
> +
> +SEC("raw_tp/task_rename")
> +int BPF_PROG(read_array_2)
> +{
> +	struct bpf_perf_event_value val;
> +	long ret;
> +
> +	ret =3D bpf_perf_event_read_value(&array_2, 0, &val, sizeof(val));
> +	bpf_printk("read_array_2 returns %ld", ret);
> +	return ret;
> +}
> +
> +char LICENSE[] SEC("license") =3D "GPL";
> --=20
> 2.24.1
>=20

