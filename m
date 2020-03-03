Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B40417692A
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 01:11:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgCCALK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 19:11:10 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:35216 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726843AbgCCALK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 19:11:10 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0230AkSo020774;
        Mon, 2 Mar 2020 16:10:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=fZL7e9ZA3TuQWP8iECx3E8TFvDRrLMI/Uz3LH5RcZ2o=;
 b=HzFEDL+e3XbUz6xYWfW7p+ZnrFzE9UhV5X8Mdz4NHYoM8JHn/bm63wSDtkrmMM6VgDjw
 giTKKRa93O5Jo49zcLxAnTYvaQCyiTgCH6M6RH9QnqhsAoa9HT270V1w0Vs4W2QxRUB4
 IVa+ZM8owNrk+8ddXw+yab2jhS5/WjP+UTE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2yfpnqtqur-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 02 Mar 2020 16:10:54 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Mon, 2 Mar 2020 16:10:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hXrNk6gtDXWYdA/M/q/c9sOKfAj8O48CgPzQWgtMLtih3l7BfBhmBhMugwkcZ9uG6CE9zRzCMKg2FaMvkmwNOgTGEUoiWpYEnyn8X+EdTJs/UkUosv7t3tz+hAo7mZVL9gYr7BbdE+/x0Sk4bNy9opIaIGE4PYdG6jByVex2HQzfKzDNSAvPgNei6HTpp2/ffOxOzAqbxZn6Amom3hyNDvmSTkBxg/t/vKuGOkbTQz11XYRX2gV8AWwsF2pCVZst/vqwfbEVtM1f4ocBiTJSXrMATBWOE91msbyVplIsDTHEe2TW2c6D+qiUNPjprNsfJXmZ/gUjQoDsBnbmB7FPrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fZL7e9ZA3TuQWP8iECx3E8TFvDRrLMI/Uz3LH5RcZ2o=;
 b=RED3BHcjyw1BQLIrbP6RGrp70Kf/4GpEr2phzRKKYy5c0pQRiFzjR+WqBEZfumw/1stbV6tVWkjBV9DCcA4OSQGrZzmfJ5cQDg/tkDrb5MHIM1bl3XaSSSwghDHWD0fI31hFOtvZXNGzYZMfkBlTg176Ew9kkFnsSpluI6izx6uW7zBZD6/pYxME8S12qhASf6KmovH0AiRaW50qTWB3rwWtwPiAkfHH4f+k8WDK9zjFoHfAWjma+KkzdSDfh4ISpd642n6ozguDvsmM88feBXbNwJYdNAi0DDRqw4lPpeBse8MTzJzBz8e2EH+ysAETlIkY2u1UIWqhOrH5ObQl4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fZL7e9ZA3TuQWP8iECx3E8TFvDRrLMI/Uz3LH5RcZ2o=;
 b=IPLNzboVokz5GVqDBzNOrari1rQSXiUHsFmFYl00NBS90jhYl/dSDSJ8CFEjy6Ur15rk5ROJ275Ygz2mSA4J6UdSl4V9dJLB6BDWDhQaHDN+VWCf8t0xoHx8Gax0BWPW6LC5aQ6ZnbX8G6StpaG53mOXUyckEK4xpVQ8t222D+0=
Received: from MW3PR15MB3882.namprd15.prod.outlook.com (2603:10b6:303:49::11)
 by MW3PR15MB3868.namprd15.prod.outlook.com (2603:10b6:303:40::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14; Tue, 3 Mar
 2020 00:10:51 +0000
Received: from MW3PR15MB3882.namprd15.prod.outlook.com
 ([fe80::c570:6c46:cc47:5ca5]) by MW3PR15MB3882.namprd15.prod.outlook.com
 ([fe80::c570:6c46:cc47:5ca5%5]) with mapi id 15.20.2772.019; Tue, 3 Mar 2020
 00:10:51 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Yonghong Song <yhs@fb.com>
CC:     Networking <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "arnaldo.melo@gmail.com" <arnaldo.melo@gmail.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>
Subject: Re: [PATCH v2 bpf-next 1/2] bpftool: introduce "prog profile" command
Thread-Topic: [PATCH v2 bpf-next 1/2] bpftool: introduce "prog profile"
 command
Thread-Index: AQHV7pCRwZ1HBc6vtU2QEGEJ7IlYy6g0t8kAgAFLeQA=
Date:   Tue, 3 Mar 2020 00:10:50 +0000
Message-ID: <67921C65-D391-47C9-9582-C9D6060161A1@fb.com>
References: <20200228234058.634044-1-songliubraving@fb.com>
 <20200228234058.634044-2-songliubraving@fb.com>
 <367483bd-87ff-02f4-71f6-c2694579dda4@fb.com>
In-Reply-To: <367483bd-87ff-02f4-71f6-c2694579dda4@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.60.0.2.5)
x-originating-ip: [2620:10d:c090:400::5:f141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0c081c71-5592-46bc-7c2f-08d7bf075539
x-ms-traffictypediagnostic: MW3PR15MB3868:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR15MB3868F0B11F1B2FB74A3EFC57B3E40@MW3PR15MB3868.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 03319F6FEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(376002)(346002)(39860400002)(136003)(199004)(189003)(66476007)(8676002)(66446008)(81156014)(66556008)(33656002)(64756008)(316002)(54906003)(81166006)(8936002)(37006003)(76116006)(66946007)(6636002)(186003)(53546011)(6512007)(478600001)(36756003)(6862004)(6486002)(5660300002)(71200400001)(2906002)(6506007)(86362001)(2616005)(4326008);DIR:OUT;SFP:1102;SCL:1;SRVR:MW3PR15MB3868;H:MW3PR15MB3882.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NTaUrPD7jqqTP+Suum/VRVh4jEImLJq0K7yv8frS+byfgss8joJPoTSwqJlnayBwgLJGTCnD/CZghmLyD8ftbRxeKZziOMHtunhw8n2RegSQ8CylFaSJEnkGc8gMw83MtT5Zrp/sexf96x70/HiQxe7c6zBKwLzRNN4jGT5+sqBkGfdlEtH9HbsfQj1GsDUYVw4FB1GMAIIjA66YZVlV/70yMFrVncPlrNeZtupU7rCIo5sZAxB8tiiZvZnKcU8adxlyrldU9svR5rMJBJcJgu6zOmua8X3F5fTHDTdU3Z3Oj3aD+s39Rraek+sAlx+rrzGE4nXJAUkP+XgunG3o0QB69Z7q3qu3IDXLxpYAq9kSlCBXMZMvaxRe0nufdL/Cgk1cKfl8oK+YWN9t5PqApSKIXKygbxu/ZxM2ZkqDwxYinQsaKLvymh+vWr+MJvcU
x-ms-exchange-antispam-messagedata: WpxlQz8l2df1lyx2NValcGD5K6pwko2Zy6KfLhuNPsR0m6kcq0pVKSAaoNfVvcey3dNTowsl/wMblH3kR2Vkt8KWknLdv/mQxaBoUUKWsNbU6JAR/5cBZbgMTauAzgcJCYAgZCs1504y/Qidp2jlynVSsNp+WVnwcT4HhBoAzLzTUemq/4V6fFHgxGR/JJ2c
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E268398FA455B44A81D6EA2D1B9BB009@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c081c71-5592-46bc-7c2f-08d7bf075539
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2020 00:10:50.9720
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Hk9V2npUUlUs6k2pT7JvIqdMdYGMTJMapzA5dA6TezGh9pvVSmrvcAx0ZO0Mnvf9pGKnqmAP5riJqFbkpJpTtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3868
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-02_09:2020-03-02,2020-03-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 clxscore=1015
 lowpriorityscore=0 priorityscore=1501 suspectscore=0 spamscore=0
 malwarescore=0 impostorscore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003020157
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 1, 2020, at 8:24 PM, Yonghong Song <yhs@fb.com> wrote:
>> +	},
>> +	{
>> +		.name =3D "instructions",
>> +		.attr =3D {
>> +			.freq =3D 0,
>> +			.sample_period =3D SAMPLE_PERIOD,
>> +			.inherit =3D 0,
>> +			.type =3D PERF_TYPE_HARDWARE,
>> +			.read_format =3D 0,
>> +			.sample_type =3D 0,
>> +			.config =3D PERF_COUNT_HW_INSTRUCTIONS,
>> +		},
>> +		.ratio_metric =3D 1,
>> +		.ratio_mul =3D 1.0,
>> +		.ratio_desc =3D "insn per cycle",
>> +	},
>> +	{
>> +		.name =3D "l1d_loads",
>> +		.attr =3D {
>> +			.freq =3D 0,
>> +			.sample_period =3D SAMPLE_PERIOD,
>> +			.inherit =3D 0,
>> +			.type =3D PERF_TYPE_HW_CACHE,
>> +			.read_format =3D 0,
>> +			.sample_type =3D 0,
>> +			.config =3D
>> +				PERF_COUNT_HW_CACHE_L1D |
>> +				(PERF_COUNT_HW_CACHE_OP_READ << 8) |
>> +				(PERF_COUNT_HW_CACHE_RESULT_ACCESS << 16),
>> +		},
>=20
> why we do not have metric here?

This follows perf-stat design: some events have another event to compare=20
against, like instructions per cycle, etc.=20

>=20
>> +	},
>> +	{
>> +		.name =3D "llc_misses",
>> +		.attr =3D {
>> +			.freq =3D 0,
>> +			.sample_period =3D SAMPLE_PERIOD,
>> +			.inherit =3D 0,
>> +			.type =3D PERF_TYPE_HW_CACHE,
>> +			.read_format =3D 0,
>> +			.sample_type =3D 0,
>> +			.config =3D
>> +				PERF_COUNT_HW_CACHE_LL |
>> +				(PERF_COUNT_HW_CACHE_OP_READ << 8) |
>> +				(PERF_COUNT_HW_CACHE_RESULT_MISS << 16),
>> +		},
>> +		.ratio_metric =3D 2,
>> +		.ratio_mul =3D 1e6,
>> +		.ratio_desc =3D "LLC misses per million isns",
>> +	},
>> +};
>=20
> icache miss and itlb miss might be useful as well as the code will jump
> to a different physical page. I think we should addd them. dtlb_miss
> probably not a big problem, but it would be good to be an option.

I plan to add more events later on.=20

>=20
> For ratio_metric, we explicitly assign a slot here. Any specific reason?
> We can just say this metric *permits* ratio_metric and then ratio_matric
> is assigned dynamically by the user command line options?
>=20
> I am thinking how we could support *all* metrics the underlying system
> support based on `perf list`. This can be the future work though.

We are also thinking about adding similar functionality to perf-stat,=20
which will be more flexible.=20

>=20
>> +
>> +u64 profile_total_count;
>=20
[...]
>> +
>> +	reading_map_fd =3D bpf_map__fd(obj->maps.accum_readings);
>> +	count_map_fd =3D bpf_map__fd(obj->maps.counts);
>> +	if (reading_map_fd < 0 || count_map_fd < 0) {
>> +		p_err("failed to get fd for map");
>> +		return;
>> +	}
>> +
>> +	assert(bpf_map_lookup_elem(count_map_fd, &key, counts) =3D=3D 0);
>=20
> In the patch, I see sometime bpf_map_lookup_elem() result is checked
> with failure being handled. Sometimes, assert() is used. Maybe be
> consistent with checking result approach?

Will fix.=20

[...]
>=20
>>=20
>> +}
>> +
>> +#define PROFILE_DEFAULT_LONG_DURATION (3600 * 24)
>=20
> We need to let user know this value in "help" at least.
> In "man" page it may be get updated but I think we probably
> should add there as well.

I am planning to just use UINT_MAX.=20

>=20
>> +
[...]

>> +#define BPF_PROG(name, args...)						    \
>> +name(unsigned long long *ctx);						    \
>> +static __always_inline typeof(name(0))					    \
>> +____##name(unsigned long long *ctx, ##args);				    \
>> +typeof(name(0)) name(unsigned long long *ctx)				    \
>> +{									    \
>> +	_Pragma("GCC diagnostic push")					    \
>> +	_Pragma("GCC diagnostic ignored \"-Wint-conversion\"")		    \
>> +	return ____##name(___bpf_ctx_cast(args));			    \
>> +	_Pragma("GCC diagnostic pop")					    \
>> +}									    \
>> +static __always_inline typeof(name(0))					    \
>> +____##name(unsigned long long *ctx, ##args)
>=20
> I know it is internal. But all the above macros are not great in
> a bpf program. If we can reuse/amend current infrastructure.
> That will be great. It may benefit users writing a similar
> bpf program to here.

This is copied from tools/testing/selftests/bpf/bpf_trace_helpers.h.=20
I think we will move them to libbpf later. Then we can use that=20
version instead.=20

Thanks,
Song

