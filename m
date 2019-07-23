Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2B3714FB
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 11:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387781AbfGWJZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 05:25:54 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49708 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732316AbfGWJZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 05:25:53 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6N9O58f020040;
        Tue, 23 Jul 2019 02:25:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=jPQS+5gPcupO5/vaC9SBgQaNe3WVu6P5ffiJDZaLErQ=;
 b=KOfYFbUuj6tS9BFJhUqCMcdQArIhnGKJ6bfy1T5Uo0CzAJfDNsMiMMEq+mB+PEOct7Sh
 6fgHgYrFgt/rpUnbghS5xX5kbLhSRE89eijfviO1UJL1U6MWJXT1J7WAsm0z4iVmbZtw
 85h9xaSEisZVYcT7JICGe0SABGsW/U0SZbg= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2twk0sjbjq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 23 Jul 2019 02:25:34 -0700
Received: from prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 23 Jul 2019 02:25:33 -0700
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 23 Jul 2019 02:25:33 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 23 Jul 2019 02:25:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GZkz5fK4Slfd5SCP1bz4wWPnWD4bB7X9AMSm4t982Qt0cNea6gkgR6g9CTEASa8icbADl2+21eRfY/RYvoPTQOlywkZeKWRFGDwDZhMQHbvwQ4N6URsSlml097ZB/ud8GsA783B6u8dD6pqWm+fkmpXvF1v6ZalVK7nYkW8S6bYzmCanK8m+iASW4opd8lcjnRqeqY3a648wcvG6HVhCZ6YudKdUEgWAeqXYPVg5f2/55D/cMmuGsX3/pkpvBo3JVv3Ig+cOYPVJhDJHPRy7WijjyjgbH21jlFP7nDmE1Fe/GgjtaxnAzb4rSNIXj/RjOiMVVzG6ZQVJJ6CADOWvRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jPQS+5gPcupO5/vaC9SBgQaNe3WVu6P5ffiJDZaLErQ=;
 b=U2uQNDXEEaljLGwxFIoORNaOfb5tMggdRtoy9F5a6QVLbzI0u44x7xVPYEA0OEat/YvPSYHbDdxBmu2jF9kcDv7JQZFvHcEnYBO3VhCaBZsNNN9oaO9o6nqAX9N91H5nChJjCeYK9lVMJAfOAfCqQN0NO4WOG6xnFpqBM9UAIPZGiH/JULl9YWWCUHGCt85Znr7W4KX6umJ+s78MqJrFLsGJrEZRk+7t6M7GD6v0Vr/g4+7jKfbTWMnU6i2Nx4gF0xh7Yj/3rU1BwNL6vxvosRQxlpPCpeMFQMz4SQOEq1pSqTDvB1Rpb9NUYr/b5jcs/l4Negl+iOqtW8Se/RpMcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jPQS+5gPcupO5/vaC9SBgQaNe3WVu6P5ffiJDZaLErQ=;
 b=d2aposVYGRmHmj3BvduTvqgwYrd4OCIHRIQYkUpBwZJ8QcX36n442YsbX2+yT3CmsjQOVnVHMM7xIfdlWdYPVf7txPVc9f8mnBNMF8lwn5tcwoUDRSgE9D/qAJPIZcsJ48y0nDEU93xjajfAnN76I7WV0ADG1Zsd2NzUCsZys+A=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1741.namprd15.prod.outlook.com (10.174.254.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Tue, 23 Jul 2019 09:25:19 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::4066:b41c:4397:27b7]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::4066:b41c:4397:27b7%7]) with mapi id 15.20.2094.013; Tue, 23 Jul 2019
 09:25:19 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 1/5] selftests/bpf: convert test_get_stack_raw_tp
 to perf_buffer API
Thread-Topic: [PATCH bpf-next 1/5] selftests/bpf: convert
 test_get_stack_raw_tp to perf_buffer API
Thread-Index: AQHVQQ+C5Pm2D3qrh0u1GboKuGQN5qbX7vYA
Date:   Tue, 23 Jul 2019 09:25:19 +0000
Message-ID: <EBDB05E7-C10F-479F-B2A7-62D59EE4887E@fb.com>
References: <20190723043112.3145810-1-andriin@fb.com>
 <20190723043112.3145810-2-andriin@fb.com>
In-Reply-To: <20190723043112.3145810-2-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::1:2cda]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b54902f9-b62d-477f-7af1-08d70f4fae57
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1741;
x-ms-traffictypediagnostic: MWHPR15MB1741:
x-microsoft-antispam-prvs: <MWHPR15MB1741B0E488CA93880C657405B3C70@MWHPR15MB1741.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:568;
x-forefront-prvs: 0107098B6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(136003)(366004)(376002)(346002)(396003)(189003)(199004)(478600001)(68736007)(6486002)(53936002)(33656002)(446003)(6436002)(76176011)(316002)(37006003)(81166006)(2616005)(186003)(6862004)(25786009)(57306001)(6512007)(50226002)(81156014)(8936002)(99286004)(46003)(54906003)(11346002)(476003)(4326008)(229853002)(6636002)(71200400001)(71190400001)(36756003)(6506007)(7736002)(53546011)(6246003)(66476007)(102836004)(66946007)(66556008)(64756008)(2906002)(305945005)(66446008)(91956017)(76116006)(8676002)(5024004)(14444005)(256004)(5660300002)(6116002)(86362001)(14454004)(486006);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1741;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: GUrbIMOrummtY2uuKc9i019tDNa1rEAZCBIS8b5V/EcrEDge6uo8lwNiFf4qwr4tV1JTAzOjHUOcVL4XNMhhDSIPbsAqubdmwFEHPN1afP+l/+qU5yXVIt5rfrhsbNLBMVuzqF379YkD9Kb9HnJ0UD+/kgN4gez/DY5dAB5SSX5Z3O6+YBj8kmUlSCaAufCDeHLom4kk5N+N4y56qXPxe5KjMaXx9orFlfGqgKnNv8UMCEPBuP6It8oPnZFmEU+yO0Yegcut0mYxpIjWjUN5vi4IaskdzNkYNrs7wZlK8FQ6tkIR695+cuTu2LdouEMDSTqHqw42PONr1qhZol0ggyV+Jg9TQkbk6T0+Vcm84fipitYLpjtYLcMqPTXbhyO2odHgogk7eQ4kCKWyugtqJCOEEHelXBXjSfNnCxmeiTY=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <696EE792F2304D438FBC9364DE5C65C4@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b54902f9-b62d-477f-7af1-08d70f4fae57
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2019 09:25:19.5374
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1741
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-23_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907230089
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 22, 2019, at 9:31 PM, Andrii Nakryiko <andriin@fb.com> wrote:
>=20
> Convert test_get_stack_raw_tp test to new perf_buffer API.
>=20
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
> .../bpf/prog_tests/get_stack_raw_tp.c         | 78 ++++++++++---------
> .../bpf/progs/test_get_stack_rawtp.c          |  2 +-
> 2 files changed, 44 insertions(+), 36 deletions(-)
>=20
> diff --git a/tools/testing/selftests/bpf/prog_tests/get_stack_raw_tp.c b/=
tools/testing/selftests/bpf/prog_tests/get_stack_raw_tp.c
> index c2a0a9d5591b..473889e1b219 100644
> --- a/tools/testing/selftests/bpf/prog_tests/get_stack_raw_tp.c
> +++ b/tools/testing/selftests/bpf/prog_tests/get_stack_raw_tp.c
> @@ -1,8 +1,15 @@
> // SPDX-License-Identifier: GPL-2.0
> +#define _GNU_SOURCE
> +#include <pthread.h>
> +#include <sched.h>
> +#include <sys/socket.h>
> #include <test_progs.h>
>=20
> #define MAX_CNT_RAWTP	10ull
> #define MAX_STACK_RAWTP	100
> +
> +static int duration =3D 0;
> +

Are we using "duration" at all?

> struct get_stack_trace_t {
> 	int pid;
> 	int kern_stack_size;
> @@ -13,7 +20,7 @@ struct get_stack_trace_t {
> 	struct bpf_stack_build_id user_stack_buildid[MAX_STACK_RAWTP];
> };
>=20
> -static int get_stack_print_output(void *data, int size)
> +static void get_stack_print_output(void *ctx, int cpu, void *data, __u32=
 size)
> {
> 	bool good_kern_stack =3D false, good_user_stack =3D false;
> 	const char *nonjit_func =3D "___bpf_prog_run";
> @@ -65,75 +72,76 @@ static int get_stack_print_output(void *data, int siz=
e)
> 		if (e->user_stack_size > 0 && e->user_stack_buildid_size > 0)
> 			good_user_stack =3D true;
> 	}
> -	if (!good_kern_stack || !good_user_stack)
> -		return LIBBPF_PERF_EVENT_ERROR;
>=20
> -	if (cnt =3D=3D MAX_CNT_RAWTP)
> -		return LIBBPF_PERF_EVENT_DONE;
> -
> -	return LIBBPF_PERF_EVENT_CONT;
> +	if (!good_kern_stack)
> +	    CHECK(!good_kern_stack, "bad_kern_stack", "bad\n");

Two "bad" is a little weird. How about "kern stack", "bad"?

> +	if (!good_user_stack)
> +	    CHECK(!good_user_stack, "bad_user_stack", "bad\n");
> }
>=20
> void test_get_stack_raw_tp(void)
> {
> 	const char *file =3D "./test_get_stack_rawtp.o";
> -	int i, efd, err, prog_fd, pmu_fd, perfmap_fd;
> -	struct perf_event_attr attr =3D {};
> +	const char *prog_name =3D "raw_tracepoint/sys_enter";
> +	int i, err, prog_fd, exp_cnt =3D MAX_CNT_RAWTP;
> +	struct perf_buffer_opts pb_opts =3D {};
> +	struct perf_buffer *pb =3D NULL;
> +	struct bpf_link *link =3D NULL;
> 	struct timespec tv =3D {0, 10};
> -	__u32 key =3D 0, duration =3D 0;
> +	struct bpf_program *prog;
> 	struct bpf_object *obj;
> +	struct bpf_map *map;
> +	cpu_set_t cpu_set;
>=20
> 	err =3D bpf_prog_load(file, BPF_PROG_TYPE_RAW_TRACEPOINT, &obj, &prog_fd=
);
> 	if (CHECK(err, "prog_load raw tp", "err %d errno %d\n", err, errno))
> 		return;
>=20
> -	efd =3D bpf_raw_tracepoint_open("sys_enter", prog_fd);
> -	if (CHECK(efd < 0, "raw_tp_open", "err %d errno %d\n", efd, errno))
> +	prog =3D bpf_object__find_program_by_title(obj, prog_name);
> +	if (CHECK(!prog, "find_probe", "prog '%s' not found\n", prog_name))
> 		goto close_prog;
>=20
> -	perfmap_fd =3D bpf_find_map(__func__, obj, "perfmap");
> -	if (CHECK(perfmap_fd < 0, "bpf_find_map", "err %d errno %d\n",
> -		  perfmap_fd, errno))
> +	map =3D bpf_object__find_map_by_name(obj, "perfmap");
> +	if (CHECK(!map, "bpf_find_map", "not found\n"))
> 		goto close_prog;
>=20
> 	err =3D load_kallsyms();
> 	if (CHECK(err < 0, "load_kallsyms", "err %d errno %d\n", err, errno))
> 		goto close_prog;
>=20
> -	attr.sample_type =3D PERF_SAMPLE_RAW;
> -	attr.type =3D PERF_TYPE_SOFTWARE;
> -	attr.config =3D PERF_COUNT_SW_BPF_OUTPUT;
> -	pmu_fd =3D syscall(__NR_perf_event_open, &attr, getpid()/*pid*/, -1/*cp=
u*/,
> -			 -1/*group_fd*/, 0);
> -	if (CHECK(pmu_fd < 0, "perf_event_open", "err %d errno %d\n", pmu_fd,
> -		  errno))
> +	CPU_ZERO(&cpu_set);
> +	CPU_SET(0, &cpu_set);
> +	err =3D pthread_setaffinity_np(pthread_self(), sizeof(cpu_set), &cpu_se=
t);
> +	if (CHECK(err, "set_affinity", "err %d, errno %d\n", err, errno))
> 		goto close_prog;
>=20
> -	err =3D bpf_map_update_elem(perfmap_fd, &key, &pmu_fd, BPF_ANY);
> -	if (CHECK(err < 0, "bpf_map_update_elem", "err %d errno %d\n", err,
> -		  errno))
> +	link =3D bpf_program__attach_raw_tracepoint(prog, "sys_enter");
> +	if (CHECK(IS_ERR(link), "attach_raw_tp", "err %ld\n", PTR_ERR(link)))
> 		goto close_prog;
>=20
> -	err =3D ioctl(pmu_fd, PERF_EVENT_IOC_ENABLE, 0);
> -	if (CHECK(err < 0, "ioctl PERF_EVENT_IOC_ENABLE", "err %d errno %d\n",
> -		  err, errno))
> -		goto close_prog;
> -
> -	err =3D perf_event_mmap(pmu_fd);
> -	if (CHECK(err < 0, "perf_event_mmap", "err %d errno %d\n", err, errno))
> +	pb_opts.sample_cb =3D get_stack_print_output;
> +	pb =3D perf_buffer__new(bpf_map__fd(map), 8, &pb_opts);
> +	if (CHECK(IS_ERR(pb), "perf_buf__new", "err %ld\n", PTR_ERR(pb)))
> 		goto close_prog;
>=20
> 	/* trigger some syscall action */
> 	for (i =3D 0; i < MAX_CNT_RAWTP; i++)
> 		nanosleep(&tv, NULL);
>=20
> -	err =3D perf_event_poller(pmu_fd, get_stack_print_output);
> -	if (CHECK(err < 0, "perf_event_poller", "err %d errno %d\n", err, errno=
))
> -		goto close_prog;
> +	while (exp_cnt > 0) {
> +		err =3D perf_buffer__poll(pb, 100);
> +		if (err < 0 && CHECK(err < 0, "pb__poll", "err %d\n", err))
> +			goto close_prog;
> +		exp_cnt -=3D err;
> +	}
>=20
> 	goto close_prog_noerr;
> close_prog:
> 	error_cnt++;
> close_prog_noerr:
> +	if (!IS_ERR_OR_NULL(link))
> +		bpf_link__destroy(link);
> +	if (!IS_ERR_OR_NULL(pb))
> +		perf_buffer__free(pb);
> 	bpf_object__close(obj);
> }
> diff --git a/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c b/t=
ools/testing/selftests/bpf/progs/test_get_stack_rawtp.c
> index 33254b771384..f8ffa3f3d44b 100644
> --- a/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c
> +++ b/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c
> @@ -55,7 +55,7 @@ struct {
> 	__type(value, raw_stack_trace_t);
> } rawdata_map SEC(".maps");
>=20
> -SEC("tracepoint/raw_syscalls/sys_enter")
> +SEC("raw_tracepoint/sys_enter")
> int bpf_prog1(void *ctx)
> {
> 	int max_len, max_buildid_len, usize, ksize, total_size;
> --=20
> 2.17.1
>=20

