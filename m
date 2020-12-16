Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC7862DC74F
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 20:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728537AbgLPTmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 14:42:52 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47932 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727067AbgLPTmw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 14:42:52 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 0BGJbkQr002699;
        Wed, 16 Dec 2020 11:41:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=hWeVrCZJhmJh4wyKk8R2Kok+lk32IprRgxM9t4eDpWU=;
 b=Bu052DgdpAPrXydqQZZNCPTNmqC5kIaGZXEqvpf/xnFzAOAwcLS5ohB8SZJamBvRSg8O
 VKSYbczCj8Hmf8BL7E12lMncW7GDmFuf9VVk2aOzL5Pwu4pB4/635RvVms/Guacez5dt
 Nlb3HoH8bo7FvKsW5YvEtHTpOR0e3HkJATY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 35f4vk5mga-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 16 Dec 2020 11:41:56 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 16 Dec 2020 11:41:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dyAOu7kxsbu7LXNkLY7tagCm2j6MMViv0uqWzyyXu8XkoGnbw19I2vWbHAuWe628DEW11B6L06+Mw6iAPWSw5DPhRUsNfsF/lfcN815RVRulfnrovsdi6VR2jmhIBqdBbRRm6VS0PyCRxqi/ES7Lk9LJTUg2jtMdqo27VUMZBLMiTcnGQFndSkWDDjj9WPeCLc+bXQ/COafIeQ/h8zUdmAPhHjEHRdk36xK8g2Ux+iU5AXIMTFdXwOznHr8T0fujBgnqtAm7rgPLEhFsZHMBn4l5HAEXtEcbWW/oDjOWiKibwDL8jkasJdwILCTOUDA0KjsmsExnTfYuFwBYn7iN2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hWeVrCZJhmJh4wyKk8R2Kok+lk32IprRgxM9t4eDpWU=;
 b=meVSeezuc8MObFcms5XqGRwMjArqnHOx78oaIUaF8TN4mXFscDcr6ZlPeBjOYG7G4ESdMLwtZF4UV8wNsWKM+nUxGgSAkr6mUz/z8Kqm1UFaLW/vuhp/fxI6mFqYF8/vcxdREgyA6w2FolSFio92j8l0Lu4SkRTMt+Kzyg+2DSJp86eGDWl2fqh1CHdDWAK+1EfH5MprdhezFNmlXoIRoS0smNR9zOOXxri3NDfd6YncY0vB3AuHuY62TvX9NlsB8ki2xNJ1iODap4s4YPt2tKK31uxViuyHQefJRlcgVjwdeKOiIFsVvU05SsGXrwXEqRrLzsTueM/dqyAxXLhEdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hWeVrCZJhmJh4wyKk8R2Kok+lk32IprRgxM9t4eDpWU=;
 b=JVGIJglrRbnVtgjUzGB8CDsfE3/LfoqGURuSEkbmz1zfGSuWxmHsnGvVAE+tqbW0UrPfKvZG7cODO7+OgQNFjdNcqrpl0r2PEwpatQUVzz6lXOD2XlXn0PULq3GWaKzbY3TPu5Y3yHG4voy3MEkofm5MrGIXa2397Fu8y6tyL0Y=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2245.namprd15.prod.outlook.com (2603:10b6:a02:89::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.18; Wed, 16 Dec
 2020 19:41:53 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b%7]) with mapi id 15.20.3654.025; Wed, 16 Dec 2020
 19:41:53 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Yonghong Song <yhs@fb.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: introduce task_vma bpf_iter
Thread-Topic: [PATCH v2 bpf-next 1/4] bpf: introduce task_vma bpf_iter
Thread-Index: AQHW0zs42cd9AcJBNEyi77fZmX7Jx6n5/WOAgAAjJoA=
Date:   Wed, 16 Dec 2020 19:41:53 +0000
Message-ID: <A783F06F-A2CF-402D-BAAB-AFBCADD13307@fb.com>
References: <20201215233702.3301881-1-songliubraving@fb.com>
 <20201215233702.3301881-2-songliubraving@fb.com>
 <a0892e60-7cc3-80ed-f4d3-004128cb6b8e@fb.com>
In-Reply-To: <a0892e60-7cc3-80ed-f4d3-004128cb6b8e@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
x-originating-ip: [2620:10d:c091:480::1:e346]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1d36d8ea-693d-4ac2-69e9-08d8a1faa39f
x-ms-traffictypediagnostic: BYAPR15MB2245:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB22451829432011C240B78943B3C50@BYAPR15MB2245.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /JXMwI+H2+DWjAOwIMD4bktex4znFmcsCauxUOCpvFxALPoOxBMp9JJI5NL0obDFQebG3x/IgfszA0BLxke1foitXn70TRwIR5ZerxOBHMXVHbBEqjA/JpM6g0xogvDPGUIuoA8hycSbr2j+9IqJ9C58Y3l/medQyYVMZbNt/6DhqkxJCCXjtahqmpMDEi6jq2hkby96Zpx11feKfbiDQH+QZixIbS1qPwYI8mL+B3i32KWlORvk6g3/YEHo3UDgrSKJR+xSbc4cK1CIlZIJnTr0gwLQUt///iQ9E9YJTxxEaTvgAL5lK3e48JPoNTJ/KPcl8OTi+F6vVNivjOhgQdMHFm1iBXhhHjLIMx0uwY7sVyuNV+1AxG6FaV7z6ZSe
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(396003)(366004)(376002)(136003)(316002)(478600001)(186003)(54906003)(6506007)(64756008)(4326008)(6636002)(76116006)(66476007)(2906002)(8936002)(66556008)(33656002)(6512007)(36756003)(5660300002)(86362001)(66446008)(2616005)(6486002)(66946007)(6862004)(53546011)(91956017)(83380400001)(37006003)(71200400001)(8676002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?vEzkXQ0npuNESbaQuzeL02X9v5U1IAMe/yG5GkvH9hpC6v6T9KnF71ZaikJi?=
 =?us-ascii?Q?9jQfGe3RvY3GSNAXClbDSXkhqEtfG5EjIBM3A8gR31b7Uv57CPi+nLBz7b53?=
 =?us-ascii?Q?kvEY4yfDkW4AdQMXbc0NyPpZRbNOHX+yPn+DOAXhGh0GtqbsczLRWbohh11m?=
 =?us-ascii?Q?ePUzFG7ukUWkWHbnznIbhQulpLgnuZ1hefJiwoYah3YlGnZaL/R7fPR7ypw5?=
 =?us-ascii?Q?3mOOHJIYaQt327cjmc/NG7aHkrO9N9XfKkC8Q/zgyEmLj41FCt+uFENDoEqQ?=
 =?us-ascii?Q?+jaIJ9kYdjPb2ZFPNKuMQD4oDvUOP1bHtOSbjKgtXkW9vTUoZ9By/fXAFVXw?=
 =?us-ascii?Q?5OjnV4YUUNLKmzgeQzUSFxEimLGPP4ihe9JM0nfdp2OZqvoIjOLZWQFFvktF?=
 =?us-ascii?Q?vuu2GPhLlWTcDasvwp4SFxj7EU9VYrbg8dFt5oeVQgfbFU24nIBKu0b1JsYw?=
 =?us-ascii?Q?fdtBOLwphKXVD/HHh7GntzVtL3uQyZdp+BFApn2xSUlV5DXowlDydRr+J2MH?=
 =?us-ascii?Q?nQVVGkbkvyU1ZnswaLc7HJk2w+wtytt82dOkx0DFLNd9+20X3b+0rjqvEZJa?=
 =?us-ascii?Q?tW8Dp2ci7zOhMfu2GvHMyEV5/PjjwWWjHxPct33T+3hvI/NTLaYCXRRd0+QX?=
 =?us-ascii?Q?eS+0VtGoDsGwnt0v6ApTeTfLf1mfiFerzeHSoI2UYMuOR1nq7HBgEn/U+VsF?=
 =?us-ascii?Q?uDALVpwlUOn9gw3+VuFS+ba+njd7/7d/3PUwA4It6tWQ5quqTzACxiD5v+rB?=
 =?us-ascii?Q?VCJ9hhgPl+QsI7OLsLAE6wE1ibJUJj1/dgepTLlVs9lBJPOOshDftQv+NBSi?=
 =?us-ascii?Q?tCrPVGSuWH4clKsP3IA0ZD6Zy8tZMMeQ5llgqAXEpSDbLaamHycYSFakKg+G?=
 =?us-ascii?Q?tiPA6jvd/gcFdP4oXZyL9hjSehCkyoFufGAGhv9SFaSHCFDPpig/lFjBmzvT?=
 =?us-ascii?Q?A3UCEKCEKRsu6VWsApMIUg/D5gobvRfN4WqGfJJU8UV+Dtg3PDc6zE9TyLR7?=
 =?us-ascii?Q?AWUcpvsffS6mn+2yJ3d1XCCj2HUsW9/NsBBF4HuTUGRX5qs=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <325DEF9770A07B498DE052A623223D1A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d36d8ea-693d-4ac2-69e9-08d8a1faa39f
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2020 19:41:53.0705
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0mVnfuH3bGyrGDGiqdnJG04dvyg16It7bAql5c1rbzcCj2s8cJys/GLrz2aPJcfHrGpIF/zb9t1bhyyG8f8q1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2245
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-16_08:2020-12-15,2020-12-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 adultscore=0
 mlxlogscore=952 malwarescore=0 suspectscore=0 mlxscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 lowpriorityscore=0
 bulkscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012160121
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Dec 16, 2020, at 9:36 AM, Yonghong Song <yhs@fb.com> wrote:
>=20
[...]
>> +	if (info->task) {
>> +		curr_task =3D info->task;
>> +	} else {
>> +		curr_task =3D task_seq_get_next(ns, &curr_tid, true);
>> +		if (!curr_task) {
>> +			info->task =3D NULL;
>> +			info->tid++;
>=20
> Here, info->tid should be info->tid =3D curr_tid + 1.
> For exmaple, suppose initial curr_tid =3D info->tid =3D 10, and the
> above task_seq_get_next(...) returns NULL with curr_tid =3D 100
> which means tid =3D 100 has been visited. So we would like
> to set info->tid =3D 101 to avoid future potential redundant work.
> Returning NULL here will signal end of iteration but user
> space can still call read()...

Make sense. Let me fix.=20

>=20
>> +			return NULL;
>> +		}
>> +
>> +		if (curr_tid !=3D info->tid) {
>> +			info->tid =3D curr_tid;
>> +			new_task =3D true;
>> +		}
>> +
>> +		if (!curr_task->mm)
>> +			goto next_task;
>> +		info->task =3D curr_task;
>> +	}
>> +
>> +	mmap_read_lock(curr_task->mm);
>> +	if (new_task) {
>> +		vma =3D curr_task->mm->mmap;
>> +	} else {
>> +		/* We drop the lock between each iteration, so it is
>> +		 * necessary to use find_vma() to find the next vma. This
>> +		 * is similar to the mechanism in show_smaps_rollup().
>> +		 */
>> +		vma =3D find_vma(curr_task->mm, info->vma.end - 1);
>> +		/* same vma as previous iteration, use vma->next */
>> +		if (vma && (vma->vm_start =3D=3D info->vma.start))
>> +			vma =3D vma->vm_next;
>=20
> We may have some issues here if control is returned to user space
> in the middle of iterations. For example,
>   - seq_ops->next() sets info->vma properly (say corresponds to vma1 of t=
id1)
>   - control returns to user space
>   - control backs to kernel and this is not a new task since
>     tid is the same
>   - but we skipped this vma for show().
>=20
> I think the above skipping should be guarded. If the function
> is called from seq_ops->next(), yes it can be skipped.
> If the function is called from seq_ops->start(), it should not
> be skipped.
>=20
> Could you double check such a scenario with a smaller buffer
> size for read() in user space?

Yeah, this appeared to be a problem... Thanks for catching it! But I=20
am not sure (yet) how to fix it. Let me think more about it.=20

Thanks,
Song

