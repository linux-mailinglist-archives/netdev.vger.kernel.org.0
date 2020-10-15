Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A56428ECEF
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 08:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727197AbgJOGJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 02:09:39 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:2216 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725922AbgJOGJj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 02:09:39 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09F65FX8010132;
        Wed, 14 Oct 2020 23:09:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-id : mime-version
 : content-type : content-transfer-encoding; s=facebook;
 bh=ct36pnrOQUOWmdS8Qo7HMfMxX3K7Rja89lfQ/hodw7s=;
 b=OHa95o2N/NydZU+966SLBEYlxGBn4HfENfNK9l1NAebpBGMEWGxxN0Ui0Ycl8g/RfnNz
 PDnA7PUu59v6TmYg/Bc82B/zSYM7nm4nLHfqgQW9GiZFBdX9eJP831Sxg6EXlfFudEzE
 UrC0GlhF600SHtnwr62z5ITDIa2jP1F3reo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 345pwsqdab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 14 Oct 2020 23:09:21 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 14 Oct 2020 23:09:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RW4Hick7bHy+zonWIwprPU1oJ20bpF5doW0rQeuW5Kus+t7Ke7jxcwbmDcqYRQ5XC+gPtPeHI4JhU0IcBe3JRy+jhWR1eMwL1LYdvwQ92nchpNXVHh8r4J1BexZvRFQ5QmH7vj1+GpEPaApcHzIP67KpjSOe/WdGHwXx6XBr42wO5BofTjSX8p2xTViGHkus5vgslc2j4fJHGJ47gpYdMinirC5f2Mc14963SGK/66zaTXvfppP7GOuSEQu3vZavZm9DqHyUHn3xigEVjzR9mfl7oMsL4wqWqIhS6kyQOt6oaQdHB491e7YFyjgRLsUI5BZsDwnHskRdxeUoXbOhhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ct36pnrOQUOWmdS8Qo7HMfMxX3K7Rja89lfQ/hodw7s=;
 b=VCs7c72DgL/oOiXXH5mqRf8kFz6CVvy3pPfEREjaPli1Q0tdkVrWdYw1EIcI2Tb7DgnDbojpodiMusS7/uLI4ZdQyHmO3zR8zRyY51qIbySVKEgrUzE8ozok1bTZ4S9JRAKh/BaOhYS+D9bIj/AwyZi5dw9aRdVm6mf6+iCcFNUxN6OigMGbsKDKRNTAgjjQE58j9W1AaQQFdvcbPX47SeGxODcrNI+tdOwUUFkIAedQnAr9AGxqNuYQdxQjgPYUSVfRhrPHsfRHJbl4qmhZFfFVgMpkngx+ghDOgtiYCWe0y04hmhFh44sJQySjBKUUkTA0iHCyGhulmXVsUlKtSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ct36pnrOQUOWmdS8Qo7HMfMxX3K7Rja89lfQ/hodw7s=;
 b=YjymvBs8HrBJhlW1Prx+GBYlXlQV+AFF3YxabKQcHdBe/H39RwyfUGUQjMbAKCIV4CgMeoie948Ww/5ctXsymYQAhAAZXw6/NnDi8REYlDfB2gXmOauqfRf9iTWwi8gzyTffWIb/PeFf6ugisuCWWq2Xtwzf9zPH8Ye5t+mhY0A=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2584.namprd15.prod.outlook.com (2603:10b6:a03:150::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.25; Thu, 15 Oct
 2020 06:09:14 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::5448:b1c1:eb05:b08a]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::5448:b1c1:eb05:b08a%7]) with mapi id 15.20.3455.031; Thu, 15 Oct 2020
 06:09:14 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 3/4] selftests/bpf: Add profiler test
Thread-Topic: [PATCH v2 bpf-next 3/4] selftests/bpf: Add profiler test
Thread-Index: AQHWndldfr2Z6zpNO0OWlKsK59tHLamV+iYAgAASxYCAAA62AIACHBSA
Date:   Thu, 15 Oct 2020 06:09:14 +0000
Message-ID: <561A9F0C-BDAE-406A-8B93-011ECAB22B1C@fb.com>
References: <20201009011240.48506-1-alexei.starovoitov@gmail.com>
 <20201009011240.48506-4-alexei.starovoitov@gmail.com>
 <20201013195622.GB1305928@krava>
 <CAADnVQLYSk0YgK7_dUSF-5Rau10vOdDgosVhE9xmEr1dp+=2vg@mail.gmail.com>
 <CAEf4BzbWO3fgWxAWQw4Pee=F7=UqU+N6LtKYV7V9ZZrfkPZ3gw@mail.gmail.com>
In-Reply-To: <CAEf4BzbWO3fgWxAWQw4Pee=F7=UqU+N6LtKYV7V9ZZrfkPZ3gw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.1)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c091:480::1:8115]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8b796ff9-aa59-4928-9c43-08d870d0d7c2
x-ms-traffictypediagnostic: BYAPR15MB2584:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2584EB4E1013CE702F8B4119B3020@BYAPR15MB2584.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4KTTozQe3N+RCtLZP//iU2NsL8JMADnoBWH5ismFihLjftE8vKP63DjSy90DCzCpWE+mUgeX86o5zRl7av/dvm+fjNsZlqRVVtkCgxQFLMS0Ali8JXR3+Ade6xxcU1SDcQib8C1v8e78TWGcYtj4BYqvppUTkwej2w+Ksuh9+2ybVXwf9RgQrilG8f8PY87aqyQUeC7YFf4cXEpSQaigr+u42iM3bi8FhJFhdBPFXLvC5xkFW5+CdSNzHks+9vZm09+117gmUBRQyjFW81xNgCwYgag2tCInFyff+0+8cwriJWUj/jeeRh8QtO3Mtsqy
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(346002)(39860400002)(396003)(376002)(2906002)(8676002)(33656002)(4326008)(6916009)(66946007)(66556008)(66446008)(66476007)(64756008)(76116006)(2616005)(54906003)(316002)(478600001)(5660300002)(91956017)(8936002)(6506007)(86362001)(186003)(6512007)(53546011)(36756003)(6486002)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 7RZj0VCtieaSVsHxiOV5sbzDYjRIAi7rp/k6ZDqaxho/b0JZEaG5FIeGQ3Am34u6JbCUayMyM8WzQblQ9yiu5mQL/BcQlFLmLRVrBnroR1eK3zmV/fMmWwmm7vRuoamGwScSvp/OuLou/CEXCSe4+Z+y/jU9RUTSQqsVSz4z2tFmvYK4GclVBI2M/z0rkTligcGJKAbXfhLbIiWHyk5DWUXC4NegCvJOFvmMxU1bfAIlNSb8PCKHSNbVW+IEnjaaLhrh9IzlPX6NZDtEKi+lZ1huL1jtQoqY/ZpHnqQYFNv5kzzQjJiZxsUgr4CoHpHnMP8w07WsOY3QniFq0CNw37toD2IOaFLOQos6IO/VlJi7RJjUj3yYHwjPgbMR1qJ0iSQKcb47LS5NoeA9fY4VjiNyMC8VTSgVfVGlEBznNVzteaKQuPp89aEfqBmEW07WZK2Svh6POM0jA3WrZg1wjc4zbW/+pukibIv2criUTgrCDIV/sm35p0vlv8Xe7W6leTXpw6sB5HmqzVnCrDU0EtFK/8tx3FTuSkYt2YxiYNHKhSJ92I5O23ziTJE756OqbM2UZjhk6TNLBHTey/CKJQigNOEBXRBl9ubj6WfzJPFXciF2qX/QcHjBx80Kh4z6GZHkutSRHzo45OAMnoX4E1Mlu6byTufRpEv0ajW6Rz5zd8yc6eyDZmV24HXVmBMB
Content-ID: <8734713BDB12104DB0E1725BEB92E3E2@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b796ff9-aa59-4928-9c43-08d870d0d7c2
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2020 06:09:14.7719
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0Mb1L5PfUTogS2OKqpCTw9vMJqC+FiX3wQS/NJXzlbrwXUT3tGasTRO3ClaR8zon97fzRQMm87LsTmNj2qcikw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2584
X-OriginatorOrg: fb.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-15_03:2020-10-14,2020-10-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1011
 adultscore=0 phishscore=0 priorityscore=1501 mlxlogscore=967
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010150044
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Oct 13, 2020, at 2:56 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> =
wrote:

[...]

>=20
> I'd go with Kconfig + bpf_core_enum_value(), as it's shorter and
> nicer. This compiles and works with my Kconfig, but I haven't checked
> with CONFIG_CGROUP_PIDS defined.

Tested with CONFIG_CGROUP_PIDS, it looks good.=20

Tested-by: Song Liu <songliubraving@fb.com>

>=20
>=20
> diff --git a/tools/testing/selftests/bpf/progs/profiler.inc.h
> b/tools/testing/selftests/bpf/progs/profiler.inc.h
> index 00578311a423..79b8d2860a5c 100644
> --- a/tools/testing/selftests/bpf/progs/profiler.inc.h
> +++ b/tools/testing/selftests/bpf/progs/profiler.inc.h
> @@ -243,7 +243,11 @@ static ino_t get_inode_from_kernfs(struct
> kernfs_node* node)
>        }
> }
>=20
> -int pids_cgrp_id =3D 1;
> +extern bool CONFIG_CGROUP_PIDS __kconfig __weak;
> +
> +enum cgroup_subsys_id___local {
> +       pids_cgrp_id___local =3D 1, /* anything but zero */
> +};
>=20
> static INLINE void* populate_cgroup_info(struct cgroup_data_t* cgroup_dat=
a,
>                                         struct task_struct* task,
> @@ -253,7 +257,9 @@ static INLINE void* populate_cgroup_info(struct
> cgroup_data_t* cgroup_data,
>                BPF_CORE_READ(task, nsproxy, cgroup_ns, root_cset,
> dfl_cgrp, kn);
>        struct kernfs_node* proc_kernfs =3D BPF_CORE_READ(task, cgroups,
> dfl_cgrp, kn);
>=20
> -       if (ENABLE_CGROUP_V1_RESOLVER) {
> +       if (ENABLE_CGROUP_V1_RESOLVER && CONFIG_CGROUP_PIDS) {
> +               int cgrp_id =3D bpf_core_enum_value(enum
> cgroup_subsys_id___local, pids_cgrp_id___local);
> +
> #ifdef UNROLL
> #pragma unroll
> #endif
> @@ -262,7 +268,7 @@ static INLINE void* populate_cgroup_info(struct
> cgroup_data_t* cgroup_data,
>                                BPF_CORE_READ(task, cgroups, subsys[i]);
>                        if (subsys !=3D NULL) {
>                                int subsys_id =3D BPF_CORE_READ(subsys, ss=
, id);
> -                               if (subsys_id =3D=3D pids_cgrp_id) {
> +                               if (subsys_id =3D=3D cgrp_id) {
>                                        proc_kernfs =3D
> BPF_CORE_READ(subsys, cgroup, kn);
>                                        root_kernfs =3D
> BPF_CORE_READ(subsys, ss, root, kf_root, kn);
>                                        break;

