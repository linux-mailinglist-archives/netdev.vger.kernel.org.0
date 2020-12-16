Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D01B2DC990
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 00:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730784AbgLPXY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 18:24:26 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:64230 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726865AbgLPXY0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 18:24:26 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 0BGNFZoB029125;
        Wed, 16 Dec 2020 15:23:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=fQ891/zI985wiUAkR/Ar3LgH+NK6TfapU13DaHSskkU=;
 b=G1nZB05O1a184IDsUsYy5V+c58u/+HIq6OjDsB1Zweiz7egMj/LlZtllCMErzagkhupo
 oPhldEqgsl7ZkScCPxmt2et2M5le2rxh3nveMOV/2GPDRapxll8SgoE0WdTowEz59SJS
 U//ArhYy7ztCK4ROhslX1RpRggpclCegJzA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 35f7h65upr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 16 Dec 2020 15:23:31 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 16 Dec 2020 15:23:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZFAUJwBDV11MoScwxgkIcAe1iRP8EPl18bCRWxqZJCrJFknIIB4p4VMJQv8qd5zAYcc7TQkdROGrG9VWzOchsm4x1/f0PWsTCw5QG1Igp0nmjdks1bKqPEK7HuDvXYVro+8zDciG8pbSIWsHIayNMSYHO+obsJDHCr1+maPISICfhodCS3UonFT7dBhel3u8RMbrHAhq1G9Rr4D+AjN4GNJE+qSLgQbguKGQRxvjOylyhdn2nZ/vglhSLJoi5hQ99b/DxNhK051+badqdQEj/Yc2Q0g+FoJdwywviT4AQfpcXJJLGnw0/Vo3Ti7qpssEQIvjkmbd7sWrhVzX+OWUtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fQ891/zI985wiUAkR/Ar3LgH+NK6TfapU13DaHSskkU=;
 b=UMq2AGV89Lux0Q7IVLre+5FPMOeTOLzkqbr93pkXJVpL09X1kLBPPq10/bGmWCUSjfN8jMKssw1Fs33NwsApbomWzJ89wvJw+Ftbo3L9M1VQSPnE8BkzIII623JWR4VPsb2A332GGOsgVwj1LM596DjGdsgJ3yAjhaslcVkkHsXfniCc1Jct2ws+Ao74JugYh47t3cd7V2wXMVJ4n1ISuIEA2OeHlLHB6zJKj5Ns1AIN25RF2sU7SdKxrhkaVqmJX3QulpjaZD9j5umr5HpaXhQfhAg7EPklRzOaUJuSbUlE158Rltt6PTE104YR0cyfj0VWbvo5I1BUSD9s9rPwCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fQ891/zI985wiUAkR/Ar3LgH+NK6TfapU13DaHSskkU=;
 b=fWBFIn4pDC9jgftWCGEdL8rJr6d52lv46I8ybu93jTCzIFCQdcvTXdTvEfHz3zxQt93SMu38xZ94EUKhQDXFtKulnqweBduFuRnXluX2SZOX30oWUUWSMnHZBZiOTpxdE8zNKBI6bClwLKCI+6r5SQOFpW6PhIgXptdelSlwSCM=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2725.namprd15.prod.outlook.com (2603:10b6:a03:158::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.15; Wed, 16 Dec
 2020 23:23:24 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b%7]) with mapi id 15.20.3654.025; Wed, 16 Dec 2020
 23:23:24 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Yonghong Song <yhs@fb.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Andrii Nakryiko" <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 4/4] selftests/bpf: add test for
 bpf_iter_task_vma
Thread-Topic: [PATCH v2 bpf-next 4/4] selftests/bpf: add test for
 bpf_iter_task_vma
Thread-Index: AQHW0zs6KjDuN0nfMkKjCJzT2YpTXan6CS4AgABVPwA=
Date:   Wed, 16 Dec 2020 23:23:24 +0000
Message-ID: <EE276BC6-9513-414D-91D1-6257909AB952@fb.com>
References: <20201215233702.3301881-1-songliubraving@fb.com>
 <20201215233702.3301881-5-songliubraving@fb.com>
 <29e8f249-a23b-3c17-4000-a4075398b669@fb.com>
In-Reply-To: <29e8f249-a23b-3c17-4000-a4075398b669@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
x-originating-ip: [2620:10d:c091:480::1:e346]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6bd5fbe2-e7dc-4193-04bf-08d8a21995b1
x-ms-traffictypediagnostic: BYAPR15MB2725:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2725AA9E83FF2D9B3390FCF8B3C50@BYAPR15MB2725.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1ELCRliBy0tJCPjWEC6frPuzUhlDZHrzdsCjJ66+UQVvLVie4IZtLCFCJYgo0q/FIvPzeLwcOxQqsF6cVkgQzuL5ki8RTwWsXmXuQVH9jjAeNf3kjqLaz/m5p7YZblEGz9RP+3aU5YLDbXRxV3l/ETBTwALI4Bgc2rhU2EXKiXAv6WBCH4z+X6RW3IbuMkATBGvQQKGdxz7jRXM6EBLyM+9y1ql4/SDhcyrwPA3Q0CPtdNFrqlkgyPop/EjpEUf9y/QxNAZzWet+PL4jpRVghHgSoGWdp0IvRYAmi+hrgoM/JF6oez6Qi0oRMGus60FtzATWZBW2R6UhUIf+Zv02may+b6vcwoZ05oT87vtXC7ZRpleR8n5VratPiQMuoxTm
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(64756008)(66556008)(6862004)(5660300002)(76116006)(91956017)(71200400001)(66946007)(36756003)(66476007)(8936002)(33656002)(2616005)(66446008)(54906003)(8676002)(86362001)(186003)(53546011)(6636002)(37006003)(6506007)(2906002)(498600001)(4326008)(83380400001)(6486002)(6512007)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?a40VVA/CWabO/N+HXls2GvVH/GKon315k3O5HFWCp0G9A6E6N/IvfNGgFeh2?=
 =?us-ascii?Q?Ouv19FDEXtmw//I7nycMD5U0L844pcd0vD7wMhAYQgeHIPdli23f35vKO+rp?=
 =?us-ascii?Q?cMZnliQDqX005e9sz5aIZWcvd9bz+ugtobnT2HW7TjC+2GAChXmHhpoqskNJ?=
 =?us-ascii?Q?pxZ1VskwhemlnPsQvDvnE0oyT27UEBrVxFj5K1PWRKeis90nH9xV1m/1odEW?=
 =?us-ascii?Q?56mV45BczjYMEosTJAsPNzyRDfa+mTFG+vaFxYJhNdNFPSEs57hHv30P0WQF?=
 =?us-ascii?Q?3T2mTohe6iguTepVuSUVRjEuJUvmE4LuGFWiaLw9g5pBN6JynoeNuius9+fd?=
 =?us-ascii?Q?8YGCIqDMTErnn8/qIoDmDQDXzYjgB/Z9jVXjTBvuSh/JBPSUAhQcbT7fkZQj?=
 =?us-ascii?Q?OY669I0N2BEXscT766kYBWD3l2sgjHBFKbR5xDqpRLSM29zLvJQ/+6aqqKP6?=
 =?us-ascii?Q?KAe89GEMslWCU4mO27n/yK2p2+iqZKp2FaQQ8IFpOAMC0bkiTBFoB+MCp5pX?=
 =?us-ascii?Q?9dxPI0N/r4UXfgTXGCs9k17VQmoyPZx0SiluoaFY1ajYWeg5ms55kuh0tWF3?=
 =?us-ascii?Q?fr1ZwwvVo/ZE/AGgeF8Wia1rrfYgup4DS3zUAWN1sGxHZIlIDhXoPDUWtJrd?=
 =?us-ascii?Q?m19Fz96GFnHlKYiN037k6QCtqPCJdKtLuCRqOgh48tEWAQ3/ttIXL7D6naKM?=
 =?us-ascii?Q?mJxTGyZMo0pfdn1xwg+/WGtq7OttILGCP3V2hyO/2skdayTgckIBjyR66RFS?=
 =?us-ascii?Q?mriyVGxYAX2FNc+WPLfkiXcpUisk+Lm6DnZfj6IgaFQQl5Z+yr0p7z/da8QW?=
 =?us-ascii?Q?02ySso5imXa9U8SuL6UN5su5dGtyhpzeVdLDe2j+h6dzmT6dBJdfxdVq4Rkk?=
 =?us-ascii?Q?FnN8dzTofTXSFjmADOcrjlRZ1LKP0gMeG+rJFyeh/dxekgZMwjP0TOJVoHuT?=
 =?us-ascii?Q?zA9GS6UhVoPGjp5BHS6VB2j1Bec9SuFZcip3x4iZNJDrJAN8iBMUCgpvNmYj?=
 =?us-ascii?Q?GXqqdzjaZhdHmV9nZsPckg/ooHRVzF0agblmhTWMGRBF0tU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <31E07C11E3B716419B1D981E66216842@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bd5fbe2-e7dc-4193-04bf-08d8a21995b1
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2020 23:23:24.0944
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0HEdoJEXaoLPQDMbnXezb0cPUXmfOz4kU3f42kzueGR9uIHd23HKe4G+fWDXep0O7q8bAbaBVZMZ2C0U+0uD5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2725
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-16_10:2020-12-15,2020-12-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 suspectscore=0 bulkscore=0 phishscore=0 impostorscore=0 lowpriorityscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 clxscore=1015 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012160145
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Dec 16, 2020, at 10:18 AM, Yonghong Song <yhs@fb.com> wrote:
>=20

[...]

>> +
>> +	err =3D bpf_iter_task_vma__load(skel);
>> +	if (CHECK(err, "bpf_iter_task_vma__load", "skeleton load failed\n"))
>> +		goto out;
>> +
>> +	do_dummy_read(skel->progs.proc_maps);
>=20
> This do_dummy_read() is not needed, right?

do_dummy_read() helped me got bug in earlier version. I am planning to=20
change the following to do smaller reads, then do_dummy_read() is no longer
needed.=20

[...]

>=20
>> +
>> +SEC("iter.s/task_vma") int proc_maps(struct bpf_iter__task_vma *ctx)
>> +{
>> +	struct __vm_area_struct *vma =3D ctx->vma;
>> +	struct seq_file *seq =3D ctx->meta->seq;
>> +	struct task_struct *task =3D ctx->task;
>> +	struct file *file =3D ctx->file;
>> +	char perm_str[] =3D "----";
>> +
>> +	if (task =3D=3D (void *)0 || vma =3D=3D (void *)0 || task->pid !=3D pi=
d)
>=20
> I suppose kernel already filtered all non-group-leader tasks, so here
> we can have task->tgid !=3D pid?

Yeah, that works.=20

>=20
>> +		return 0;
>=20
> Using /proc system, user typically do cat /proc/pid/maps. How can we
> have a similar user experience with vma_iter here? One way to do this
> is:
>   - We still have this bpf program, filtering based on user pid,
>   - normal bpftool iter pin command pid the program to say /sys/fs/bpf/ta=
sk_vma
>   - since "pid" is in a map, user can use bpftool to update "pid"
>     with the target pid.
>   - "cat /sys/fs/bpf/task_vma" will work.
>=20
> One thing here is pid and d_path_buf are global (map) variables, so
> if two users are trying to do "cat /sys/fs/bpf/task_vma" at the same
> time, there will be interferences and it will not work.
>=20
> One possible way is during BPF_ITER_CREATE, we duplicate all program
> maps. But this is unnecessary as in most cases, the bpf_iter is not
> pinned and private to applications.
>=20
> Any other ideas?

Maybe we can use task local storage for pid and d_path_buf?=20

To make it more practical, we probably want in kernel filtering based=20
on pid. IOW, let user specify which task to iterate.=20

Thanks,
Song

